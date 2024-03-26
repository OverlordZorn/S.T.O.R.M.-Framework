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
 * [_fogParams_Target, _setFog, 120 ] call cvo_storm_fnc_weather_setFog_avg;
 * 
 * Public: No
 */


if (!isServer)                              exitWith {_this remoteExecCall ["cvo_storm_fnc_weather_setFog_avg",2]};

  params [
    ["_fog_target",         [0,0,0],    [[]],   [3] ],
    ["_duration",           0,          [0]         ]
];


if (_duration isEqualTo 0) exitWith {    diag_log format ["[CVO][STORM](fn_weather_setFog_avg) - %1", "duration equal 0"]; false };

private _fog_previous = fogParams;

private _startTime = time;
private _endTime = time + _duration;

#define DELAY 20

private _needStart = isNil "CVO_Storm_fogParams";

CVO_Storm_fogParams = [_startTime, _endTime, _fog_previous, _fog_target, DELAY];


// If the perFrameHandler is already running, we only need to update the array
if (!_needStart) exitWith {};

private _condition = { !isNil "CVO_Storm_fogParams" };

private _codeToRun = {
    
    private _avg_ASL = round ([] call cvo_storm_fnc_weather_get_AvgASL);

    private _currentParams = switch (time > CVO_Storm_fogParams#1) do {
        case true: {
            // fog_target
            diag_log "[CVO](debug)(fn_weather_setFog_avg) pfh - past Transition";
            [
                CVO_Storm_fogParams#3#0,
                CVO_Storm_fogParams#3#1,
               (CVO_Storm_fogParams#3#2) + _avg_ASL
            ]
        };
        case false: {
            diag_log "[CVO](debug)(fn_weather_setFog_avg) pfh - mid Transition";
            [
                linearConversion [CVO_Storm_fogParams#0, CVO_Storm_fogParams#1, time, CVO_Storm_fogParams#2#0, CVO_Storm_fogParams#3#0,             true ],
                linearConversion [CVO_Storm_fogParams#0, CVO_Storm_fogParams#1, time, CVO_Storm_fogParams#2#1, CVO_Storm_fogParams#3#1,             true ],
                linearConversion [CVO_Storm_fogParams#0, CVO_Storm_fogParams#1, time, CVO_Storm_fogParams#2#2,(CVO_Storm_fogParams#3#2) + _avg_ASL, true ]
            ]
        };
    };
    diag_log format ['[CVO](debug)(fn_weather_setFog_avg) previous: %1', CVO_Storm_fogParams#2];
    diag_log format ['[CVO](debug)(fn_weather_setFog_avg)  current: %1', _currentParams];
    diag_log format ['[CVO](debug)(fn_weather_setFog_avg)   target: %1', CVO_Storm_fogParams#3];
    diag_log format ['[CVO](debug)(fn_weather_setFog_avg) DELAY: %1', CVO_Storm_fog_Params#4];
    DELAY setFog _currentParams;
    diag_log "[CVO](debug)(fn_weather_setFog_avg) setFog successful ";
};

_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_condition"];

    if ([] call _condition) then {
        diag_log "[CVO](debug)(fn_weather_setFog_avg) PerFrameHandler executing.";
        [] call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
        diag_log "[CVO](debug)(fn_weather_setFog_avg) PerFrameHandler Terminated";
    };
}, DELAY, [_codeToRun,_condition]] call CBA_fnc_addPerFrameHandler;

