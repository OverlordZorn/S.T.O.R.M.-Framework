#include "..\script_component.hpp"

/*
* Author: Zorn
* Establishes hashMapObject which maintains a loop based on parameters inside the hmo - can be updated on the fly and will clean itself up once intensity reaches 0 again.
*
* Arguments:
*   0:  _PresetName
*   1:  _duration       in secounds
*   2:  _startTime      based on CBA_MissionTime
*   3:  _intensity
*
*
*
* Return Value:
* None
*
* Example:
* ["CVO_SFX_3D_WindBursts", 60, 1] call storm_fxSound_fnc_remote_3d;
*
* Public: No
*
* GVARS
*   GVAR(C_FX_Sound_Array) // array of active hashMapObjects
*
*/

#define ABOVEGROUND 5
#define ABSOLUTE_MAXRANGE 5000   // Somewhere between 5000 and 7500 seems to be a hard limit - if source obj is beyond that distance (maybe obj render distance?) then it will not be audible - Needs more testing
#define RANGE_MOD 1.5

if (!hasInterface) exitWith {};
params ["_presetName", "_startTime", "_duration", "_intensity"];

private _varName =[_presetName,"HMO"] joinString "_";
private _hmo = missionNamespace getVariable [_varName, "404"];

if (_hmo isEqualTo "404") then {


    private _cfg = (configFile >> QGVAR(Presets) >> _presetName);

    _hmo = createHashMapObject [
        [
            ["isActive", true],
            ["inTransition", true],


            ["varName", _varName],
            ["presetName", _presetName],

            ["helperObj", ""],

            ["missionTimeStart", _startTime],
            ["missionTimeEnd", (_startTime + _duration)],

            ["intensityStart", 0],
            ["intensityCurrent", 0.01],
            ["intensityTarget", _intensity],

            ["soundArrayFull", getArray (_cfg >> "sounds")],
            ["soundArrayCurrent", []],

            ["delayMin", getNumber (_cfg >> "delayMin")],
            ["delayMax", getNumber (_cfg >> "delayMax")],

            ["distanceMin", getNumber (_cfg >> "DistanceMin")],
            ["distanceMax", getNumber (_cfg >> "distanceMax")],

            ["direction", [_cfg >> "Direction"] call BIS_fnc_getCfgData],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                private _fnc_scriptName = "#create";
                [ { _this#0 call ["Meth_Loop"]; } , [_self], 1] call CBA_fnc_waitAndExecute;
            }],


            ["#delete", {
                private _fnc_scriptName = "#delete";
                ZRN_LOG_MSG_1(Pre-Cleanup,OGET(HelperObj));
                deleteVehicle OGET(HelperObj);
                ZRN_LOG_MSG_1(PostCleanup,OGET(HelperObj));
            }],

            // Methods
            ["Meth_Create_Helper",{
                private _fnc_scriptName = "Meth_Create_Helper";
                _helperObj = createVehicleLocal ["Storm_FX_Sound_Helper", [0,0,0]];
                OSET(helperObj,_helperObj);
            }],
            ["Meth_Update", {
                private _fnc_scriptName = "Meth_Update";

                params ["_presetName", "_startTime", "_duration", "_intensity"];

                OSET(missionTimeStart,_startTime);
                OSET(missionTimeEnd,_startTime + _duration);

                OSET(intensityStart,OGET(intensityCurrent));
                OSET(intensityTarget,_intensity);

                OSET(inTransition,true);
            }],
            ["Meth_Loop", {
                private _fnc_scriptName = "Meth_Loop";

                if (!OGET(isActive)) exitWith { ZRN_LOG_MSG_1(is not active anymore,OGET(presetName)); missionNamespace setVariable [OGET(varName), nil]; };
                if (OGET(helperObj) isEqualTo objNull || OGET(helperObj) isEqualTo "" ) then { _self call ["Meth_Create_Helper"]; };

                // Establish Intensity
                private "_intensityCurrent";
                if (OGET(inTransition)) then {
                    _intensityCurrent = linearConversion [OGET(missionTimeStart), OGET(missionTimeEnd), CBA_missionTime, OGET(intensityStart), OGET(intensityTarget),true];
                    OSET(intensityCurrent,_intensityCurrent);             
                    if ( _intensityCurrent == 0 && { CBA_missionTime > OGET(missionTimeEnd) } ) then { OSET(isActive,false) };
                    if ( _intensityCurrent == OGET(intensityTarget)) then { OSET(inTransition,false)};
                } else {
                    _intensityCurrent = OGET(intensityCurrent);
                };
                // Slightly Randomizes Intensity for the Effects
                _intensityCurrent = _intensityCurrent + (selectRandom[-1,1] * _intensityCurrent * 0.2);

                // Establish Delay
                private _delay = linearConversion [0,1, _intensityCurrent, OGET(delayMax), OGET(delayMin), true];
                // establishes Distance
                private _distance = linearConversion [0,1,_intensityCurrent, OGET(distanceMax), OGET(distanceMin),true];

                // Establishes Direction
                private _direction =  switch (OGET(direction)) do {
                    case "RAND": { round random 360 };
                    case "WIND": { windDir + 180 };
                    default {OGET(direction)};
                };

                // Establishes relative position from ace_player and move HelperObj to said position
                private _pos = ace_player getPos [_distance, _direction];
                _pos set [2,_pos#2 + ABOVEGROUND];

                OGET(helperObj) setPos _pos;

                // Establish Soundfile and Arrays
                if (count (OGET(soundArrayCurrent)) == 0) then { OSET(soundArrayCurrent,+ OGET(soundArrayFull)); };
                private _soundName = selectRandom OGET(soundArrayCurrent);
                OSET(soundArrayCurrent,OGET(soundArrayCurrent) - [_soundName]);

                // PLay the sound
                private _range = (RANGE_MOD * OGET(distanceMax)) min ABSOLUTE_MAXRANGE;
                private _sayObj = OGET(helperObj) say3D [_soundName,_range];

                // Wait until _sayObj is objNull (once the sound is played), then execute a WaitAndExecute to call itself again.
                _statement = {
//                    ZRN_LOG_MSG_1(WaitUntil condition done,_this#0);
                    [ { _this#0 call ["Meth_Loop"] } , [_this#2], _this#1] call CBA_fnc_waitAndExecute;
                };                                                          // Code to be executed once condition true
                _condition = { _this#0 isEqualTo objNull };                 // condition - Needs to return bool
                _parameter = [_sayObj,_delay, _self];                       // arguments to be passed on -> _this
                _timeout = 120;                                             // if condition isnt true within this time in S, _timecode will be executed.
                [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;
            }]
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", _this];
};
