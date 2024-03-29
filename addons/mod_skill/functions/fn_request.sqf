#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Takes care of AI Skill changes over time. Especially for Storm Events that reduce player visibliity, it is highly recommended to adjust AI Skill to keep the experience of the weather balanced.
 *
 * Arguments:
 * 0: _AI_presetName     <STRING> Name of Particle Effect Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be at the end of the Transitio
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

if !(isServer) exitWith { _this remoteExecCall ["cvo_storm_fnc_ai_request", 2, false] };

params [
   ["_AI_presetName",        "",                     [""]],
   ["_duration",               5,                     [0]],
   ["_intensity",              0,                     [0]]
];

// Fail Conditions

if (_AI_presetName isEqualTo "") exitWith {diag_log "AI_Request failed - No Preset Name given"};

// Prepare Input Values
 
_duration = _duration max 1;
_duration = _duration * 60;

_intensity = _intensity max 0;
_intensity = _intensity min 1;


if ((!isNil "CVO_Storm_AI_active") && { CVO_Storm_AI_active#0 }) exitWith {diag_log "AI_Request Failed - Transition is currently in progress!"};

if (( isNil "CVO_Storm_AI_active") && {_intensity == 0}) exitWith {diag_log "AI_Request failed - No Modification currently active to be reset"};

if (isNil "CVO_Storm_AI_active") then {

    _default_map = [(configFile >> "CVO_AI_SubSkill_Modifier"), "CVO_AI_Skill_Default"] call cvo_storm_fnc_common_hash_from_config;

    // Is [transition active?, _previous_map, _current_Map, _handler_ID]
    CVO_Storm_AI_active = [true,_default_map, _default_map, -1];
};



private _previous_map = + (missionNamespace getVariable "CVO_Storm_AI_active")#1;

////////////////////////////////////////////////////////////////////////////////////////
// 1. Establish Target by inearConversion of Intensity between raw vs default (always 1)
private _raw_mod_map = [(configFile >> "CVO_AI_SubSkill_Modifier"), _AI_presetName] call cvo_storm_fnc_common_hash_from_config;
if (_raw_mod_Map isEqualTo false) exitWith {diag_log "AI_Request Failed - Preset not found"};

private _target_map = createHashMap;
{   _target_map set [_x, linearConversion [0,1, _intensity, 1, _y, true] ];   } forEach _raw_mod_map;


////////////////////////////////////////////////////////////////////////////////
// 2. pfH to Iterate during the transition: Previous Modifier -> Target Modifier

private _startTime = time;
private   _endTime = time + _duration;

diag_log format ['[CVO](debug)(fn_AI_request) _startTime: %1 - _endTime: %2 - _raw_mod_map: %3 - _target_map: %4', _startTime , _endTime, _intensity, _target_map];

private _parameters = [ _startTime, _endTime, _previous_map, _target_map];

// Code to be executed during the Transition
private _codeToRun  = {
    params ["_startTime", "_endTime", "_previous_map", "_target_map"];
    private _current_map = createHashMap;
    {
        _prev_value    = _previous_map get _x;
        _target_value  = _y;
        _current_value = linearConversion [_startTime, _endTime, time, _prev_value, _target_value, true];
        _current_map set [_x, _current_value];            
    } forEach _target_map;
    [_current_map, (entities [["CAManBase"], [], true, true])] call CVO_STORM_fnc_AI_setSkill_recursive;
    CVO_Storm_AI_active set [2, _current_map];
};

// Code to be executed at the end of the Transition
private _exitCode   = {
    diag_log "[CVO](debug)(fn_AI_request) final adjustment of skill at the end of the transition ";
    [_this#3, (entities [["CAManBase"], [], true, true])] call CVO_STORM_fnc_AI_setSkill_recursive;
    CVO_Storm_AI_active set [2,(+ _this#3)];
    CVO_Storm_AI_active set [1,(+ _this#3)];
    CVO_Storm_AI_active set [0, false];
};

// Condition for the perFrameHandler: While True, it will keep executing, once failed -> ExitCode
private _condition  = { (_this#1) > time };

// Time between executions - will execute before the first delay.
private _delay      = _duration / 4;

// Establishes the perFrameHandler
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




////////////////////////////////////////////////////////////////////////////////
// 3. create EH for newly created units and applies _current_map via glob-var if this EH doesnt exist already.

if (CVO_Storm_AI_active#3 isEqualTo -1) then {
    private _eh_Handle = addMissionEventHandler ["EntityCreated", {
        params ["_entity"];

        if (_entity isKindOf "CAManBase") then {
            diag_log format ['[CVO](debug)(fn_AI_request) Evenhandler: Entitiy Created: %1 - %2', _entity , typeOf _entity ];
            [(CVO_Storm_AI_active#2), [_entity]] call CVO_STORM_fnc_AI_setSkill_recursive;
        };
    }];
    CVO_Storm_AI_active set [3, _eh_Handle];
};

/////////////////////////////////  Deletes EH and start cleanup when intensity == 0 after the final transition /////////////////////////////////
if (_intensity == 0) then {
    [
        {
            removeMissionEventHandler ["EntityCreated",CVO_Storm_AI_active#3];
            [ ( entities [ ["CAManBase"], [], true, true ] ) ] call fn_AI_cleanup_recursive;

            CVO_Storm_AI_active = nil;
            diag_log "[CVO](debug)(fn_AI_request) EH deleted, Cleanup started,CVO_Storm_AI_active nill'd"; 

        }, 
        [], 
        _duration * 1.01
    ] call CBA_fnc_waitAndExecute;
};

///////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////
///////////// TO DO /////////////
//////////////////////////////////////////////////
/*


*/
//////////////////////////////////////////////////