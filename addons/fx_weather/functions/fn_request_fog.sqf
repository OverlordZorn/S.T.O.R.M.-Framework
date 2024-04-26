#include "..\script_component.hpp"

/*
* Author: Zorn
* Establishes hashMapObject which maintains a loop based on parameters inside the hmo - can be updated on the fly and will clean itself up once intensity reaches 0 again.
*
* Arguments:
*   0:  _PresetName
*   1:  _duration       in secounds
*   2:  _intensity
*
*
*
* Return Value:
* None
*
* Example:
* ["STORM_FX_Weather_Fog_Dynamic_Sandstorm", 1, 1] call Storm_fx_weather_fnc_request_fog;
*
* Public: yes
*
* GVARS
*
*
*/

// TODO - Continue here


if (!isServer) exitWith {};

params [
    ["_presetName", "", [""]],
    ["_duration",   5,  [0] ],
    ["_intensity",  1,  [0] ]
];

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

// Check Fail conditions
if  ( _presetName isEqualTo "" ) exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !( _presetName in (configProperties [configFile >> QGVAR(FogParams), "true", true] apply { configName _x } ) ) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };

private _varName = "STORM_FX_Weather_Fog_HMO";
private _hmo = missionNameSpace getVariable [_varName, "404"];
if ( _intensity == 0 && { _hmo isEqualTo "404" } ) exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };



if (_hmo isEqualTo "404") then {
    private _cfg = (configFile >> QGVAR(FogParams) >> _presetName);
    _hmo = createHashMapObject [
        [
            ["inTransition", true],

            ["varName", _varName],
            ["presetName", _presetName],

            ["missionTimeStart", _startTime],
            ["missionTimeEnd", (_startTime + _duration)],

            ["intensityStart", 0],
            ["intensityCurrent", 0.01],
            ["intensityTarget", _intensity],

            ["fogMode", 0],

            ["fogParamsPreviousWeather", fogParams],
            ["fogParamsRestorePrevious", true],
            ["fogParamsRestoreTime", 5*60],


            ["fogParamsPreset", []],
            ["fogParamsTarget", []],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                _fnc_scriptName = "#create";
                [ { _this#0 call ["Meth_Loop"]; } , [_self], 1] call CBA_fnc_waitAndExecute;
            }],


            ["#delete", {
                _fnc_scriptName = "#delete";
                if (fogParamsRestorePrevious) then {
                    OGET(fogParamsRestoreTime) setFog OGET(fogParamsPreviousWeather);
                };
            }],

            // Methods
            ["Meth_Update", {
                _fnc_scriptName = "Meth_Update";

                params ["_presetName", "_duration", "_intensity"];

                private _startTime = CBA_missionTime;

                OSET(missionTimeStart,_startTime);
                OSET(missionTimeEnd,_startTime + _duration);

                OSET(intensityStart,OGET(intensityCurrent));
                OSET(intensityTarget,_intensity);

                OSET(inTransition,true);
            }],
            ["Meth_Loop", {
            }]
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", _this];
};


//////////////////////////////////
if (_firstWeatherChange) then {
   0 setFog          fogParams;
};

// ##################################################
// ################### fog params ################### 

if ((_hashMap getOrDefault ["change_fog", 0]) > 0) then {
  if (_firstWeatherChange) then {
 // Save Current
   GVAR(S_previousWeather) set ["change_fog", 1];
   GVAR(S_previousWeather) set ["fogParams", fogParams];
   };


 // Establish _fog_target for the Transition
   private ["_fog_target", "_fog_Mode", "_fog_boost"];

   _fog_boost = _hashMap getOrDefault ["fog_boost", 0];
   _fog_boost = _fog_boost > 0;

   switch (_intensity) do {
      case 0: {
         // Handles reset to pre-request weather
         _fog_target = _hashMap getOrDefault ["fogParams", [0,0,0]];
         _fog_Mode = 1;
         ZRN_LOG_MSG_2(Reset of Fog - Intensity == 0,_fog_mode,_fog_target);

         [ { GVAR(S_fogParams) = nil; } , [], _duration * 1.1] call CBA_fnc_waitAndExecute;


      };
      default {
         _fog_target = [];
         _fog_target set [0, ( linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", true] )];
         _fog_target set [1,_hashMap get "fog_decay"];
         _fog_target set [2,_hashMap get "fog_base"];
         _fog_Mode = _hashMap getOrDefault ["fog_mode", 0];
         ZRN_LOG_MSG_2(Intensity != 0,_fog_mode,_fog_target);
      };
   };

    // Executes Transition based on Mode
   switch (_fog_Mode) do {
      case 0: {

         if (!isNil QGVAR(fogParams)) then {GVAR(fogParams) = nil};

         [ { _this#0 setFog _this#1 } , [_duration, _fog_target], 5] call CBA_fnc_waitAndExecute;
         _duration setFog _fog_target;

         // No fogBase via AvgASL needed. Terminate perFrameHandler if active.
         _return pushback ["fog reset to 0", true];

      };
      default {
         // fogBase via AvgASL requested.
         [_fog_target, _duration, _fog_boost] call FUNC(setFog_avg);
         ZRN_LOG_MSG_3(setFog_avg-call,_duration,_fog_target,_intensity);

         // If fogBase via AvgASL is requested only during initial Tranistion, (Mode=1), perFrameHandler will be terminated after transition.
         _isContinous = [false, true] select (_fog_Mode - 1);
         if (!_isContinous) then { [ { GVAR(fogParams) = nil; } , [], _duration * 1.1] call CBA_fnc_waitAndExecute;};
         _return pushback ["fog", true];
      };
   };
};
