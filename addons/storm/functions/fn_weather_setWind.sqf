
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
    ["_azimuth",            "RAND",  ["",0]       ]
];

if (_duration isEqualTo 0) exitWith {false};

// Params Sanitization

switch (_azimuth) do {
    case "PREV": { _azimuth = ceil windDir };
    case "RAND": { _azimuth = ceil random 360 };
};

if ( _azimuth isEqualTo 0 )         then { _azimuth = 360      };

// Define Target Vector
private _wind_target = [sin _azimuth, cos _azimuth, 0] vectorMultiply _wind_magnitude;

private _startTime = time;
private _endTime = time + _duration;
private _wind_start = wind;


private _parameters = [ _startTime, _endTime, _wind_start, _wind_target, _forceWindEnd];

private _codeToRun = {
    _newWind = vectorLinearConversion [_this#0,_this#1, time, _this#2, _this#3, true];
    _newWind set [2,true];
    setWind _newWind;
};

private _exitCode = {
    _this#3 set [2, _this#4];
    diag_log "[CVO][STORM](fn_weather_setWind) - Transition completed!";
};


private _condition = { _this#1 > time };
private _delay = 5;

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
diag_log "[CVO][STORM](fn_weather_setWind) - Transition started!";
true