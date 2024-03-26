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
 * [_wind_magnitude, _duration] call cvo_storm_fnc_weather_setWind;
 * 
 * Public: No
 */

if (!isServer)                              exitWith {_this remoteExecCall ["cvo_storm_fnc_weather_setWind",2]};

// if (isNil "CVO_WeatherChanges_active")   exitWith {false};
// if (!CVO_WeatherChanges_active)          exitWith {false};


params [
    ["_wind_magnitude",          0,     [0]       ],
    ["_duration",                0,     [0]       ],
    ["_forceWindEnd",        false, [false]       ],
    ["_azimuth",            "PREV",  ["",0]       ]
];

// diag_log format ['[CVO](debug)(fn_weather_setWind)(START) _wind_magnitude: %1 - _duration: %2 - _forceWindEnd: %3 - _azimuth: %4', _wind_magnitude , _duration ,_forceWindEnd , _azimuth];

if (_duration isEqualTo 0) exitWith {false};

// Params Sanitization

switch (_azimuth) do {
    case "PREV": { _azimuth = ceil windDir };
    case "RAND": { _azimuth = ceil random 360 };
};

if ( _azimuth isEqualTo 0 )         then { _azimuth = 360      };

// Define Target Vector
private _wind_target = [sin _azimuth, cos _azimuth, 0] vectorMultiply _wind_magnitude;

diag_log format ['[CVO](debug)(fn_weather_setWind)(START) _wind_target: %1 - vectorMagnitude _wind_target: %2', _wind_target , vectorMagnitude _wind_target];


private _startTime = time;
private _endTime = time + _duration;
private _wind_start = + wind;


private _parameters = [ _startTime, _endTime, _wind_start, _wind_target, _forceWindEnd];

private _codeToRun = {
    // diag_log format ['[CVO](debug)(fn_weather_setWind) Start of Loop : _this#0: %1 - _this#1: %2 - _this#2: %3 - _this#3: %4 - _this#4: %5', _this#0 , _this#1 ,_this#2 , _this#3 , _this#4];
    _newWind = vectorLinearConversion [_this#0,_this#1, time, _this#2, _this#3, true];
    // diag_log format ['[CVO](debug)(fn_weather_setWind) Pre: _newWind: %1 - vectorMagnitude _newWind: %2', _newWind , vectorMagnitude _newWind ];
    _newWind = [_newWind#0, _newWind#1, true];
    setWind _newWind;
    // diag_log format ['[CVO](debug)(fn_weather_setWind) Post: wind: %1 - vectorMagnitude wind: %2', wind , vectorMagnitude wind ];
};

private _exitCode = {
    // diag_log format ['[CVO](debug)(fn_weather_setWind)  _this#3: %1 - vectorMagnitude  _this#3: %2',  _this#3 , vectorMagnitude  (_this#3) ];
    _finalWind = + _this#3;
    // diag_log format ['[CVO](debug)(fn_weather_setWind) _finalWind: %1 - vectorMagnitude _finalWind: %2', _finalWind , vectorMagnitude _finalWind ];
    _finalWind = [_finalWind#0, _finalWind#1, _this#4];
    setWind _finalWind;
    // diag_log format ['[CVO](debug)(fn_weather_setWind) Wind: %1 - vectorMagnitude Wind: %2', Wind , vectorMagnitude Wind ];
    // diag_log "[CVO][STORM](fn_weather_setWind) - Transition completed!";
};


private _condition = { _this#1 > time };
private _delay = 1;

// diag_log "[CVO][STORM](fn_weather_setWind) - Transition starting!";
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