#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Initialises or Readjust perFrameHandler which setFogs overtime while fogbase is modified based on average player ASL - based on global variable - if global variable isNil, perFrameHandler stops.
 *
 * Arguments:
 * 0: _fogParams_Target
 * 1: _duration                      <Number> Duration in Secounds over which this effect is to be applied.
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_fogParams_Target, _setFog, 120 ] call storm_fxWeather_fnc_setFog_avg;
 * 
 * Public: No
  *
 * GVARS
 *  	GVAR(S_fogParams) = [_startTime, _endTime, _fog_previous, _fog_target, DELAY];
 *
 */
 

if (!isServer) exitWith {_this remoteExecCall [QFUNC(setFog_avg),2]};

  params [
    ["_fog_target",         [0,0,0],    [[]],   [3] ],
    ["_duration",           0,          [0]         ]
];
#define DELAY 20


if (_duration isEqualTo 0) exitWith {ZRN_LOG_MSG(failed: duration == 0); false };

private _fog_previous = fogParams;

private _startTime = time;
private _endTime = time + _duration;

private _needPerFrameHandler = isNil QGVAR(S_fogParams);

GVAR(S_fogParams) = [_startTime, _endTime, _fog_previous, _fog_target, DELAY];


// If the perFrameHandler is already running, we only need to update the array
if (!_needPerFrameHandler) exitWith {};

private _condition = { !isNil QGVAR(S_fogParams) };

private _codeToRun = {
    
    private _avg_ASL = round ([] call cvo_storm_fnc_weather_get_AvgASL);

    private _currentParams = switch (time > GVAR(S_fogParams)#1) do {
        case true: {
            // fog_target
            [
                GVAR(S_fogParams)#3#0,
                GVAR(S_fogParams)#3#1,
               (GVAR(S_fogParams)#3#2) + _avg_ASL
            ]
        };
        case false: {
            [
                linearConversion [GVAR(S_fogParams)#0, GVAR(S_fogParams)#1, time, GVAR(S_fogParams)#2#0, GVAR(S_fogParams)#3#0,             true ],
                linearConversion [GVAR(S_fogParams)#0, GVAR(S_fogParams)#1, time, GVAR(S_fogParams)#2#1, GVAR(S_fogParams)#3#1,             true ],
                linearConversion [GVAR(S_fogParams)#0, GVAR(S_fogParams)#1, time, GVAR(S_fogParams)#2#2,(GVAR(S_fogParams)#3#2) + _avg_ASL, true ]
            ]
        };
    };
    DELAY setFog _currentParams;
};

_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_condition"];

    if ([] call _condition) then {
        [] call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
    };
}, DELAY, [_codeToRun,_condition]] call CBA_fnc_addPerFrameHandler;
