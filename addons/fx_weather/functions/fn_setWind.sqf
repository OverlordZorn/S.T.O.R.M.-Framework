#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Executes a gradual application of setWind [x,y, forced] over the duration as a recursive function. 
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
 * [_wind_magnitude, _duration] call storm_fxWeather_fnc_setWind;
 * 
 * Public: No
 */





if (!isServer) exitWith {};

params [
    ["_magnitude",          0,     [0]       ],
    ["_duration",                0,     [0]       ],
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

            ["start", wind],
            ["target", [0,0,0]],

            ["interval", 1],

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
                private _wind = OGET(target);

                setWind [_wind#0,_wind#1,OGET(forceWindEnd)];

                ZRN_LOG_MSG(HMO deletion complete);
            }],

            ["Meth_DefineTarget", {
                // Define Target Vector
                OSET(target,[sin OGET(azimuth), cos OGET(azimuth), 0] vectorMultiply OGET(magnitude));
            }],

            ["Meth_returnCurrent", {
                private _newWind = vectorLinearConversion [OGET(time_start),OGET(time_end), CBA_missionTime, OGET(start), OGET(target), true];
                _newWind = [_newWind#0, _newWind#1, true];
                _newWind
            }],

            // Methods
            ["Meth_Loop", {
                private _fnc_scriptName = "Meth_Loop";

                if !(OGET(isActive)) exitWith { missionNamespace setVariable [OGET(varName), nil] };

                _newWind = _self call ["Meth_returnCurrent"];
                setWind _finalWind;

                [ { _this#0 call ["Meth_Loop"] } , [_self], OGET(interval)] call CBA_fnc_waitAndExecute;
                if (CBA_missionTime > OGET(time_end)) then { OSET(isActive,false); };
            }],

            ["Meth_Update", {
                // Updates the current
                private _fnc_scriptName = "Meth_Update";

                params ["_wind_magnitude", "_duration", "_forceWindEnd","_azimuth"];

                OSET(time_start,CBA_missionTime);
                OSET(time_end,CBA_missionTime + _duration);

                OSET(azimuth,_azimuth);
                OSET(magnitude,_magnitude);
                OSET(forceWindEnd,_forceWindEnd);

                _self call ["Meth_DefineTarget"];
            }]
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", _this];
};

true