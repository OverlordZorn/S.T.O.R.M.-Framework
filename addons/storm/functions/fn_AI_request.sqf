/*
 * Author: Zorn
 * Takes care of AI Skill changes over time. Especially for Storm Events that reduce player visibliity, it is highly recommended to adjust AI Skill to keep the experience of the weather balanced.
 *
 * Arguments:
 * 0: _AI_presetName     <STRING> Name of Particle Effect Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * none
 *
 * Example:
 * ["CVO_AI_Skill_sandstorm_old", 1, 1] call cvo_storm_fnc_ai_request;
 * 
 * Public: No
 */

if !(isServer) exitWith {};

params [
   ["_AI_presetName",        "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",              0,  [0]]
];

if (_AI_presetName isEqualTo "") exitWith {};


_duration = _duration max 1;
_duration = _duration * 60;

_intensity = _intensity max 0;
_intensity = _intensity min 1;


if ( !(missionNamespace getVariable ["CVO_Storm_AI_active", false]) && _intensity == 0 ) exitWith {false};

if (isNil "CVO_Storm_AI_active") then {
    CVO_Storm_AI_active = true;
};

private _raw_mod_map = [(configFile >> "CVO_AI_SubSkill_Modifier"), _AI_presetName] call cvo_storm_fnc_common_hash_from_config;

///////////////////////////////// Create pfH to adjust skill based on transition & intensity /////////////////////////////////
///////////////////////////////// Establish target modifier for the end of the transition based on intensity.

private _target_mod_map = createHashMap;

{
   _target_mod_map set [_x, linearConversion [0,1, _intensity, 1, _y] ];
   
} forEach _raw_mod_map;


private _startTime = time;
private   _endTime = time + _duration;


diag_log format ['[CVO](debug)(fn_AI_request) _startTime: %1 - _endTime: %2 - _raw_mod_map: %3 - _target_mod_map: %4', _startTime , _endTime, _intensity];

private _parameters = [ _startTime, _endTime, _target_mod_map];

CVO_AI_Target_Mod = + _target_mod_map;

private _codeToRun  = {

    diag_log "[CVO](debug)(fn_AI_request) INSIDE PFEH - adjust skill intensity during transition ";

    params ["_startTime", "_endTime", "_target_mod_map"];
    
    private _current_mod_map = createHashMap;
    
    {
            _current_mod_map set [_x,    linearConversion [_startTime, _endTime, time, 1, _y] ];
      
    } forEach _target_mod_map;

    [_current_mod_map, (entities [["Man"], [], true, true])] call CVO_STORM_fnc_AI_setSkill_recursive;

};

private _exitCode   = {
    diag_log "[CVO](debug)(fn_AI_request) Exit of PFEH - final adjustment of skill at the end of the transition ";
    [_this#2, (entities [["Man"], [], true, true])] call CVO_STORM_fnc_AI_setSkill_recursive;
};

private _condition  = { _this#1 > time };

private _delay      = _duration / 4;

_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_parameters", "_exitCode", "_condition"];

    if (_parameters call _condition) then {
        _parameters call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
        _parameters call _exitCode;
    };
}, _delay, [_codeToRun, _parameters, _exitCode, _condition]] call CBA_fnc_addPerFrameHandler;
diag_log format ['[CVO](debug)(fn_AI_request) _handle: %1', _handle];


/////////////////////////////////  create EH for newly created units /////////////////////////////////

private _eh_Handle = addMissionEventHandler ["EntityCreated", {
	params ["_entity"];
    _thisArgs params ["_target_mod_map"];

    if (_entity isKindOf "Man") then {

        diag_log format ['[CVO](debug)(fn_AI_request) Evenhandler: Entitiy Created: %1 - %2', _entity , typeOf _entity ];
        [_target_mod_map, [_entity]] call CVO_STORM_fnc_AI_setSkill_recursive;

    };

},[_target_mod_map]];

/////////////////////////////////  Deletes EH and start cleanup after intensity -> 0 /////////////////////////////////

if (_intensity == 0 && missionNamespace getVariable ["CVO_Storm_AI_active", false] == true) then {
    [
        {
            removeMissionEventHandler ["EntityCreated",_eh_Handle];
            CVO_Storm_AI_active = false;
            [ ( entities [ ["Man"], [], true, true ] ) ] call fn_AI_cleanup_per_unit_recursive;
            diag_log "[CVO](debug)(fn_AI_request) EH deleted and Cleanup started"; 
        }, 
        [_eh_Handle], 
        _duration * 1.1
    ] call CBA_fnc_waitAndExecute;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
