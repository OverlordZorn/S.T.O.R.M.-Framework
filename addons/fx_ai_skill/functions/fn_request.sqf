#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Takes care of AI Skill changes over time. Especially for Storm Events that reduce player visibliity, it is highly recommended to adjust AI Skill to keep the experience of the weather balanced.
 *
 * Arguments:
 * 0: _presetName     <STRING> Name of Particle Effect Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be at the end of the Transitio
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * none
 *
 * Example:
 * ["CVO_AI_Skill_reducedVisibility", 1, 1] call storm_mod_skill_fnc_request;
 * 
 * Public: Yes
 * GVARS
 * 	    GVAR(isActive) - [_inTransition, _previous_map, _current_Map, _handler_ID]
*/

if !(isServer) exitWith { _this remoteExecCall [QFUNC(request), 2, false] };

params [
   ["_presetName",        "",                     [""]],
   ["_duration",               5,                     [0]],
   ["_intensity",              0,                     [0]]
];


ZRN_LOG_MSG_3(INIT,_presetName,_duration,_intensity);

// Prepare Input Values
_duration = 60 * (_duration max 1);
_intensity = _intensity max 0 min 1;


// Fail Conditions
if (_presetName isEqualTo "")                      exitWith {ZRN_LOG_MSG(Failed - No Preset Name given); false };
if ((!isNil QGVAR(isActive)) && { GVAR(isActive)#0 }) exitWith {ZRN_LOG_MSG(Failed - Transition is currently in progress); false };
if (( isNil QGVAR(isActive)) && {_intensity == 0})    exitWith {ZRN_LOG_MSG(Failed - No Modification currently active to be reset); false };

if (isNil QGVAR(isActive)) then {

    _default_map = [(configFile >> QGVAR(Presets)), QGVAR(Default)] call PFUNC(hashFromConfig);

    // Is [transition active?, _previous_map, _current_Map, _handler_ID]
    GVAR(isActive) = [true,_default_map, _default_map, -1];
};


private _previous_map = + GVAR(isActive)#1;

////////////////////////////////////////////////////////////////////////////////////////
// 1. Establish Target by inearConversion of Intensity between raw vs default (always 1)

private _raw_mod_map = [(configFile >> QGVAR(Presets)), _presetName] call PFUNC(hashFromConfig);
if (_raw_mod_Map isEqualTo false) exitWith {ZRN_LOG_MSG(Failed -Preset not found); false };

private _target_map = createHashMap;
{   _target_map set [_x, linearConversion [0,1, _intensity, 1, _y, true] ];   } forEach _raw_mod_map;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// 2. pfH to Iterate during the transition: Previous Modifier -> Target Modifier

private _startTime = time;
private   _endTime = time + _duration;

private _delay      = _duration / 4;

private _condition  = { (_this#1) > time };
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
    [_current_map, (entities [["CAManBase"], [], true, true])] call FUNC(apply_recursive);
    GVAR(isActive) set [2, _current_map];
};

// Code to be executed at the end of the Transition
private _exitCode   = {
    [_this#3, (entities [["CAManBase"], [], true, true])] call FUNC(apply_recursive);
    GVAR(isActive) set [2,(+ _this#3)];
    GVAR(isActive) set [1,(+ _this#3)];
    GVAR(isActive) set [0, false];
};

// Establishes the perFrameHandler
[{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_parameters", "_exitCode", "_condition"];

    if (_parameters call _condition) then {
        _parameters call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
        _parameters call _exitCode;
    };
}, _delay, [_codeToRun, _parameters, _exitCode, _condition]] call CBA_fnc_addPerFrameHandler;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////
// 3. create EH for newly created units and applies _current_map via glob-var if this EH doesnt exist already.

if (GVAR(isActive)#3 isEqualTo -1) then {
    private _eh_Handle = addMissionEventHandler ["EntityCreated", {
        params ["_entity"];

        if (_entity isKindOf "CAManBase") then {
            [(GVAR(isActive)#2), [_entity]] call FUNC(apply_recursive);

            ZRN_LOG_MSG_2(EventHandler EntitiyCreated -,_entity,typeOf _entity);
        };
    }];
    GVAR(isActive) set [3, _eh_Handle];
};

/////////////////////////////////  Deletes EH and start cleanup when intensity == 0 after the final transition /////////////////////////////////
if (_intensity == 0) then {
    [
        {
            removeMissionEventHandler ["EntityCreated",GVAR(isActive)#3];
            [ ( entities [ ["CAManBase"], [], true, true ] ) ] call fn_AI_cleanup_recursive;
            GVAR(isActive) = nil;

        }, 
        [], 
        _duration * 1.01
    ] call CBA_fnc_waitAndExecute;
};

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

ZRN_LOG_MSG_1(completed!,_presetName);

true