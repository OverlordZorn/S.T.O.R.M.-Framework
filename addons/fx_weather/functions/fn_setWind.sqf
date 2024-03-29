#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Executes a gradual application of setWind [x,y, forced] over the duration as a recursive function. 
 *
 * Arguments:
 * 0: _wind_magnitude               <Number> - Magnitute of desired target        of the transition.
 * 1: _duration                     <Number> in Secounds - Total time of Transition
 * 2: _direction        <Optional>  <Number> 0..360 Targeted Winddirection in Degrees - "PREV" takes current wind direction. 
 * 3: _forceWindEnd     <Optional>  <Boolean> <PREV: false> locks wind in place at the end of the recursive loop. (setWind [x,y, forced]) 
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_wind_magnitude, _duration] call storm_fxWeather_fnc_setWind;
 * 
 * Public: No
 */

if (!isServer)                            exitWith {_this remoteExecCall [QFUNC(setWind),2]};
// if (isNil QGVAR(isActiveTransition))   exitWith {false};
// if (!GVAR(isActiveTransition))         exitWith {false};


params [
    ["_wind_magnitude",          0,     [0]       ],
    ["_duration",                0,     [0]       ],
    ["_forceWindEnd",        false, [false]       ],
    ["_azimuth",            "PREV",  ["",0]       ]
];

if (_duration isEqualTo 0) exitWith {false};

// apply Mode
switch (_azimuth) do {
    case "PREV": { _azimuth = ceil windDir };
    case "RAND": { _azimuth = ceil random 360 };
};
if ( _azimuth isEqualTo 0 ) then { _azimuth = 360 };


// Define Target Vector
private _wind_target = [sin _azimuth, cos _azimuth, 0] vectorMultiply _wind_magnitude;

private _startTime = time;
private _endTime = time + _duration;
private _wind_start = + wind;


private _parameters = [ _startTime, _endTime, _wind_start, _wind_target, _forceWindEnd];

private _codeToRun = {
    _newWind = vectorLinearConversion [_this#0,_this#1, time, _this#2, _this#3, true];
    _newWind = [_newWind#0, _newWind#1, true];
    setWind _newWind;
};

private _exitCode = {
    _finalWind = + _this#3;
    _finalWind = [_finalWind#0, _finalWind#1, _this#4];
    setWind _finalWind;
};

private _condition = { _this#1 > time };
private _delay = 1;

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

true