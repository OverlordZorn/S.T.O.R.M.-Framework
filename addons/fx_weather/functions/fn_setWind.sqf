#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Executes a gradual application of setWind [x,y, forced] with a looped HashMapObject Method. 
 *
 * Arguments:
 * 0: _wind_magnitude               <Number> - Magnitute of desired target        of the transition.
 * 1: _duration                     <Number> in Secounds - Total time of Transition
 * 2: _forceWindEnd     <Optional>  <Boolean> <PREV: false> locks wind in place at the end of the recursive loop. (setWind [x,y, forced]) 
 * 3: _azimuth          <Optional>  <Number> 0..360 Targeted Winddirection in Degrees - "PREV" takes current wind direction. 
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_magnitude, _duration, _forceWindEnd, _azimuth] call storm_fx_weather_fnc_setWind;
 * 
 * Public: No
 */

if (!isServer) exitWith {};

#define INTERVAL 0.25

params [
    ["_magnitude",              0,     [0]        ],
    ["_duration",                0,     [0]       ],
    ["_intensity",               0,     [0]       ],
    ["_forceWindEnd",        false, [false]       ],
    ["_azimuth",            "PREV",  ["",0]       ]
];

// Check Fail conditions
if (_duration isEqualTo 0) exitWith { ZRN_LOG_MSG(failed: duration == 0); false};

// apply Mode
switch (_azimuth) do {
    case "PREV": { _azimuth = ceil windDir };
    case "RAND": { _azimuth = ceil random 360 };
};

if ( _azimuth isEqualTo 0 ) then { _azimuth = 360 };

private _varName = "STORM_FX_Weather_Wind_HMO";
private _hmo = missionNameSpace getVariable [_varName, "404"];

if (_hmo isEqualTo "404") then {

    missionNamespace setVariable ["ace_weather_disableWindSimulation", true];

    ZRN_LOG_MSG_1(creating new HMO,_hmo);

    private _hash = [configFile >> QGVAR(FogParams), _presetName] call PFUNC(hashFromConfig);

    _hmo = createHashMapObject [
        [
            ["varName", _varName],

            ["isActive", true],

            ["time_start", CBA_missionTime],
            ["time_end", (CBA_missionTime + _duration)],

            ["azimuth", _azimuth],
            ["magnitude", _magnitude],
            ["forceWindEnd", _forceWindEnd],

            ["intensity", _intensity],

            ["wind_start", wind],
            ["wind_target", [0,0,0]],

            ["interval", INTERVAL],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                private _fnc_scriptName = "#create";

                _self call ["Meth_DefineTarget"];
                _self call ["Meth_Loop"];

                ZRN_LOG_MSG(done);
            }],


            ["#delete", {
                // Handles return to pre-storm fogParams
                private _fnc_scriptName = "#delete";

                if (OGET(intensity) == 0) then {
                missionNamespace setVariable ["ace_weather_disableWindSimulation", nil];                        
                };

                ZRN_LOG_MSG(HMO deletion complete);
            }],

            ["Meth_DefineTarget", {
                // Define Target Vector
                private _target = [sin OGET(azimuth), cos OGET(azimuth), 0] vectorMultiply OGET(magnitude);
                OSET(wind_target,_target);
            }],

            ["Meth_returnCurrent", {
                private _newWind = vectorLinearConversion [OGET(time_start),OGET(time_end), CBA_missionTime, OGET(wind_start), OGET(wind_target), true];
                _newWind = [_newWind#0, _newWind#1, true];
                _newWind
            }],

            // Methods
            ["Meth_Loop", {
                private _fnc_scriptName = "Meth_Loop";

                if !(OGET(isActive)) exitWith {
                    private _wind = OGET(wind_target);
                    _wind set [2,OGET(forceWindEnd)];
                    ZRN_LOG_MSG_1(Exit: setWind,_wind);
                    setWind _wind;

                    missionNamespace setVariable [OGET(varName), nil];
                };

                private _wind = _self call ["Meth_returnCurrent"];
                setWind _wind;
                ZRN_LOG_MSG_1(loop: setWind,_wind);

                [ { _this#0 call ["Meth_Loop"] } , [_self], OGET(interval)] call CBA_fnc_waitAndExecute;

                if (CBA_missionTime > OGET(time_end)) then { OSET(isActive,false); };
            }],

            ["Meth_Update", {
                // Updates the current
                private _fnc_scriptName = "Meth_Update";

                params [
                    ["_magnitude",              0,     [0]        ],
                    ["_duration",                0,     [0]       ],
                    ["_intensity",               0,     [0]       ],
                    ["_forceWindEnd",        false, [false]       ],
                    ["_azimuth",            "PREV",  ["",0]       ]
                ];

                OSET(time_start,CBA_missionTime);
                OSET(time_end,CBA_missionTime + _duration);

                OSET(intensity,_intensity);

                OSET(azimuth,_azimuth);
                OSET(magnitude,_magnitude);
                OSET(forceWindEnd,_forceWindEnd);

                OSET(wind_start,wind);
                _self call ["Meth_DefineTarget"];
            }]
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", [_magnitude,_duration,_intensity,_forceWindEnd,_azimuth]];
};

true