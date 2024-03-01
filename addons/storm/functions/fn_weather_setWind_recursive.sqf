
/*
 * Author: [Zorn]
 * Executes a gradual application of setWind [x,y, forced] over the duration as a recursive function. 
 *
 * Arguments:
 * 0: _wind_magnitude               <Number> - Magnitute of desired target        of the transition.
 * 1: _duration                     <Number> in Secounds - Total time of Transition
 * 2: _direction        <Optional>  <Number> 0..360 Targeted Winddirection in Degrees - "DEFAULT" takes current wind direction. 
 * 3: _forceWindEnd     <Optional>  <Boolean> <DEFAULT: false> locks wind in place at the end of the recursive loop. (setWind [x,y, forced]) 
 *
 * !!! Internal Arguments - Dont use
 *
 * 4: _final_vector     <Array> [X,Y,0] - Wind vector at the end of the transition.
 * 5: _wind_start       <ARRAY> [X,Y,0] - Wind vector at the beginning of the transition.
 * 6: _iterations       <Array> [current Iteration, total Iteration, time between Iterations]
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_wind_magnitude, _duration] call cvo_storm_fnc_weather_setWind_recursive;
 * 
 * Public: No
 */

if (!isServer)                              exitWith {_this remoteExecCall ["cvo_storm_fnc_weather_setWind_recursive",2]};
if (canSuspend)                             exitWith {_this           call   cvo_storm_fnc_weather_setWind_recursive    };

// if (isNil "CVO_WeatherChanges_active")   exitWith {false};
// if (!CVO_WeatherChanges_active)          exitWith {false};


params [
    ["_wind_magnitude",          0,     [0]       ],
    ["_duration",                0,     [0]       ],
    ["_forceWindEnd",        false, [false]       ],
    ["_azimuth",         "DEFAULT",  ["",0]       ],
    ["_final_vector",  "UNDEFINED",    [[]], [2,3]],
    ["_wind_start",    "UNDEFINED",    [[]], [2,3]],
    ["_iteration",     "UNDEFINED",    [[]],   [3]]
];

if (_duration isEqualTo 0) exitWith {false};


// Defines amount of iterations [Current, Total, time between];
if (_iteration isEqualTo "UNDEFINED") then {
    _total_iterations = 1 + floor (_duration / 5);
    _delay = _duration / _total_iterations;
    _iteration = [ 1, _total_iterations, _delay ]; 
};

if (_wind_start isEqualTo "UNDEFINED") then {
    _wind_start = wind;
};

// Only if first Iteration, define _final_vector
if ( _final_vector isEqualTo "UNDEFINED") then {

    // Params Sanitization
    if ( _azimuth isEqualTo "DEFAULT" ) then { _azimuth = windDir  };
    if ( _azimuth isEqualTo 0 )         then { _azimuth = 360      };

    // Define Target Vector
    _final_vector = [sin _azimuth, cos _azimuth, 0] vectorMultiply _wind_magnitude;
};

// Establish current Iteration Wind Vector
_newWind = vectorLinearConversion [ 0, _iteration#1, _iteration#0 , _wind_start, _final_vector, true ];

// sanitize vector + setWind force = true
_newWind set [2,true];
// Executes setWind
setWind _newWind;

// Increases the Iteration cycle
_iteration set [ 0, (_iteration select 0) + 1 ];

if ( _iteration#0 <= _iteration#1 ) then {
    [
        { _this call cvo_storm_fnc_weather_setWind_recursive; },
        [ _wind_magnitude, _duration, _forceWindEnd, _azimuth, _final_vector,_wind_start, _iteration ],
        _iteration#2
    ] call CBA_fnc_waitAndExecute;
} else {

    // applies _forceWindEnd
    _newWind set [2,_forceWindEnd];
    setWind _newWind;

    diag_log format ["[CVO][STORM](SetWind_recur) - Transition Complete!",""];
};