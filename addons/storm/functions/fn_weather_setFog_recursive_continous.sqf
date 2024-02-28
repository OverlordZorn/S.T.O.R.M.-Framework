
/*
 * Author: [Zorn]
 * Applies Fog initially and, if needed updates it based on getAvgASL.
 *
 * Arguments:
 * 0: _fogParams_VarName             <String> Name of the provided global variable name which will be used to update and, if needed, end the fogParams application.
 * 1: _duration                      <Number> Duration in Secounds over which this effect is to be applied.
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_fogParams_VarName, 120 ] call cvo_storm_fnc_weather_setFog_recursive_continous;
 * 
 * Public: No
 */


if (!isServer)                              exitWith {_this remoteExecCall ["cvo_storm_fnc_weather_setFog_recursive_continous",2]};
if (canSuspend)                             exitWith {_this           call   cvo_storm_fnc_weather_setFog_recursive_continous    };

// if (isNil "CVO_WeatherChanges_active")   exitWith {false};
// if (!CVO_WeatherChanges_active)          exitWith {false};


  params [
    ["_fogParams_VarName",  "",        [""]         ],
    ["_duration",            0,         [0]         ],
    ["_iteration",     "UNDEFINED",    [[]],   [3]  ]
];


if (_duration isEqualTo 0) exitWith {    diag_log format ["[CVO][STORM](ExitWith) - %1", "duration equal 0"]; false };

private _fogParams = missionNamespace getVariable [_fogParams_VarName, "NOT DEFINED"];

if  (_fogParams isEqualTo "NOT DEFINED") exitWith {diag_log format ["[CVO][STORM](ExitWith) - %1", "fogparams not defined"]; false};

// make copy of array and assign it to the variable to avoid editing the original
_fogParams = + _fogParams;

private _previous_FogParams = CVO_Storm_previous_weather_hashmap get "fogParams";



// Handles reset to previous fogParams during Hard Reset
if  (_fogParams isEqualTo false)         exitWith { 
        diag_log format ["[CVO][STORM](ExitWith) - %1", "_fogParams equal to false"];
        // if current weather is not already equal to the previous fog (in case of hard stop), apply previous weather over 0.1 * _duration
        if !(fogParams isEqualTo _previous_FogParams) then { (_duration / 10) setFog _previous_FogParams };
        missionNamespace setVariable [_fogParams_VarName, nil];
};

private _mode = _fogParams select 3;
_fogParams deleteAt 3;


if !(_fogParams isEqualType [])          exitWith {diag_log format ["[CVO][STORM](ExitWith) - %1", "fogParams isnt an array "];false};


// ##################################################
// Case 1: Set Fog once without using AvgASL 
_case1 = {
    // apply Effect
    _duration setFog _fogParams;
    diag_log format[ "%1 - %2 setFog %3", _mode, _duration, _fogParams ];

    // Delete global var
    missionNamespace setVariable [_fogParams_VarName, nil];
};
// ##################################################


// ##################################################
// Case 2: set Fog Once, use AvgASL_once
_case2 = {
    // get Avg_ASL once
    // get Avg_ASL
    private _var = [] call cvo_storm_fnc_weather_getAvgASL;
    _fogBase = _var select 0;

    // Add fogBase as "minimum value" and adds avg Players 
    // Potential need for Fine Tuning
    _fogParams set [2, (_fogParams select 2) + _fogBase];

    // apply Effect
    _duration setFog _fogParams;
    diag_log format[ "%1 - %2 setFog %3", _mode, _duration, _fogParams ];


    // Delete global var
    missionNamespace setVariable [_fogParams_VarName, nil];

};
// ##################################################


// ##################################################
// Case 3: Set Fog with AsgASL repeatedly, ether until 
_case3 = {
    // Defines amount of iterations [Current, Total, time between] - Happens only once
    if (_iteration isEqualTo "UNDEFINED") then {
        _total_iterations = 1 + floor (_duration / 15);
        _delay = _duration / _total_iterations;
        _iteration = [ 1, _total_iterations, _delay ];
        diag_log format ["[CVO][STORM](weather_setFog_recursive_continous) - _iteration defined: %1", _iteration];
    };

    // get Avg_ASL
    private _var = [] call cvo_storm_fnc_weather_getAvgASL;
    _fogBase = _var select 0;

    // Add fogBase as "minimum value" and adds avg Players 
    // Potential need for Fine Tuning
    _fogParams set [2, (_fogParams select 2) + _fogBase];

    for "_i" from 0 to 2 do {
        _fogParam set [_i, linearConversion [0, _iteration # 1, _iteration # 0, _previous_FogParams # _i, _fogParams # _i, true] ];
    };

    // apply Effect
    _iteration#2 setFog _fogParams;
    diag_log format[ "%1 - %2 setFog %3", _mode, _iteration#2, _fogParams ];

    // Increases the Iteration cycle
    _iteration set [ 0, (_iteration select 0) + 1 ];

    // Recursive Call
    [ 
        {   
            diag_log format ["recursive Call Fog: _this: ", _this];
            _this call cvo_storm_fnc_weather_setFog_recursive_continous;
        },
        [ _fogParams_VarName, _duration, _iteration ], _iteration#2] call CBA_fnc_waitAndExecute;
};
// ##################################################


switch (_mode) do {
    case "no_avg_ASL":           _case1;
    case "use_AvgASL_once":      _case2;
    case "use_AvgASL_continous": _case3;
};



