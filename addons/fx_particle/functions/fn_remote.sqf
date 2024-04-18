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
* Return Value:
* None
*
* Example:
* ["", 60, 1] call storm_fx_Particle_fnc_remote_3d;
*
* Public: No
*
* GVARS
*   GVAR(C_FX_Sound_Array) // array of active hashMapObjects
*
*/

#define DELAY 0
//private _delay = 1;

if (!hasInterface) exitWith {};

params ["_presetName", "_startTime", "_duration", "_intensity"];

private _varName =[_presetName,"HMO"] joinString "_";
private _hmo = missionNameSpace getVariable [_varName, "404"];

if (_hmo isEqualTo "404") then {

    private _cfg = (configFile >> "CfgCloudlets" >> _presetName);

    _hmo = createHashMapObject [
        [
            ["isActive", true],
            ["inTransition", true],

            ["varName", _varName],
            ["presetName", _presetName],
            //["delay", DELAY],

            ["helperObj", ""],

            ["missionTimeStart", _startTime],
            ["missionTimeEnd", (_startTime + _duration)],

            ["intensityStart", 0],
            ["intensityCurrent", 0.01],
            ["intensityTarget", _intensity],

            ["coefSpeedHeli", getNumber (_cfg >> "coefSpeedHeli")],
            ["coefSpeed", getNumber (_cfg >> "coefSpeed")],
            ["coefWind", getNumber (_cfg >> "coefWind")],

            ["offsetHeight", getNumber (_cfg >> "offsetHeight")],

            ["intervalMax", getNumber (_cfg >> "interval")],        //most particles dropped at int 1
            ["intervalMin", getNumber (_cfg >> "intervalMin")],     //least particles dropped at int 0

//            ["#str", { OGET(varName) }],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                _fnc_scriptName = "#create";
                [ { _this#0 call ["Meth_Loop"]; } , [_self], 1] call CBA_fnc_waitAndExecute;
            }],

            ["#delete", {
                _fnc_scriptName = "#delete";
                deleteVehicle OGET(helperObj);
            }],
            ["Meth_Create_Helper",{
                _fnc_scriptName = "Meth_Create_Helper";
                _helperObj = createVehicleLocal ["#particlesource", [0,0,0]];
                _helperObj setPos getPos player;
                _helperObj setParticleClass OGET(presetName);
                OSET(helperObj,_helperObj);
            }],

            ["Meth_Update", {
                _fnc_scriptName = "Meth_Update";
                params ["_presetName", "_startTime", "_duration", "_intensity"];
                OSET(missionTimeStart,_startTime);
                OSET(missionTimeEnd,_startTime + _duration);

                OSET(intensityStart,OGET(intensityCurrent));
                OSET(intensityTarget,_intensity);

                OSET(inTransition,true);
            }],

            ["Meth_Loop",{
                _fnc_scriptName = "Meth_Loop";
                //default header
                if !(OGET(isActive)) exitWith { ZRN_LOG_MSG_1(is not active anymore,OGET(presetName)); missionNamespace setVariable [OGET(varName), nil]; };
                if  (OGET(helperObj) isEqualto objNull || OGET(helperObj) isEqualto "" ) then { _self call ["Meth_Create_Helper"]; };

                // Update Effects only during Transition
                private "_intensityCurrent";
                if (OGET(inTransition)) then {
                    // Establish Intensity
                    _intensityCurrent = linearConversion [OGET(missionTimeStart), OGET(missionTimeEnd), CBA_missionTime, OGET(intensityStart), OGET(intensityTarget),true];

                    OSET(intensityCurrent,_intensityCurrent);             
                    if ( _intensityCurrent == 0 && { CBA_missionTime > OGET(missionTimeEnd) } ) then { OSET(isActive,false) };
                    if ( _intensityCurrent == OGET(intensityTarget) ) then {OSET(inTransition,false)}; 

                    // Establish and apply dropInterval
                    private _dropInterval = linearConversion[0,1,_intensityCurrent,OGET(intervalMin),OGET(intervalMax),true];
                    OGET(helperObj) setDropInterval _dropInterval;
                };

                //Establish Offset for attachTo based on PlayerMovementVector + WindSpeedVector
                private _coefSpeed = [OGET(coefSpeed), OGET(CoefSpeedHeli)] select ((vehicle ace_player) isKindOf "Air");
                private _relPos = (( velocityModelSpace (vehicle ace_player) ) vectorMultiply _coefSpeed) vectorDiff (( (vehicle ace_player) vectorWorldToModel wind ) vectorMultiply OGET(coefWind));
                _relPos set [2, _relPos#2 + 1 + OGET(offsetHeight)];


                // Attach the object to the new offset
                OGET(helperObj) attachTo [(vehicle ace_player), _relPos];
  
                // Restart the Function until isActive is false
                [{
                    _this#0 call ["Meth_Loop"]
                } , [_self], DELAY] call CBA_fnc_waitAndExecute;
            }]
        ],
        []
    ];
    missionNamespace setVariable [_varName, _hmo];
} else {
    _hmo call ["Meth_Update", _this];
};