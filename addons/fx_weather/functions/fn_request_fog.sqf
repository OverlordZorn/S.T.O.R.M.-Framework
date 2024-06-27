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
    ["_presetName", "",     [""]    ],
    ["_duration",   5,      [0]     ],
    ["_intensity",  1,      [0]     ],
    ["_restore",    false,  [true]  ]
];

ZRN_LOG_MSG_4(INIT,_presetName,_duration,_intensity,_restore);

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

// Check Fail conditions
if  ( _presetName isEqualTo "" ) exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !( toLowerANSI _presetName in (configProperties [configFile >> QGVAR(FogParams), "true", true] apply { toLowerANSI configName _x } ) ) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };

private _varName = "STORM_FX_Weather_Fog_HMO";
private _hmo = missionNameSpace getVariable [_varName, "404"];
if ( _intensity == 0 && { _hmo isEqualTo "404" } ) exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };



if (_hmo isEqualTo "404") then {
//    private _cfg = (configFile >> QGVAR(FogParams) >> _presetName); // not in use currently
    ZRN_LOG_MSG_1(creating new HMO,_hmo);

    private _hash = [configFile >> QGVAR(FogParams), _presetName] call PFUNC(hashFromConfig);


    _hmo = createHashMapObject [
        [
            ["varName", _varName],
            ["presetName", _presetName],

            ["missionTimeStart", _startTime],
            ["missionTimeEnd", (_startTime + _duration)],

            ["fogParamsPreviousWeather", fogParams],
            ["fogParamsRestorePrevious", _restore],
            ["fogParamsRestoreTime", 5*60],

            ["fog_value_min", _hash get "fog_value_min"],
            ["fog_value_max", _hash get "fog_value_max"],
            ["fog_decay", _hash get "fog_decay"],
            ["fog_base", _hash get "fog_base"],
            ["fog_mode", _hash get "fog_mode"],
            ["fog_boost", (_hash get "fog_boost") > 0],

            ["fogParamsStart", fogParams],
            ["fogParamsTarget", [0,0,0]],

//            ["M2_inTransition", false],
//            ["M2_isActive", false],
//            ["M2_breakLoop", false],
//            ["M2_interval", 60],


            ["intensityStart", 0],
            ["intensityCurrent", 0.01],
            ["intensityTarget", _intensity],

            ["#flags", ["noCopy","unscheduled"]],

            ["#create", {
                _fnc_scriptName = "#create";

                ZRN_LOG_MSG_1(init,OGET(fog_mode));

                switch (OGET(fog_mode)) do {
                    case 0: { _self call ["Meth_Apply_Mode0"]; };
                    /*
                    case 1: { _self call ["Meth_Apply_Mode1"]; };
                    case 2: {
                        _self call ["Meth_Apply_Mode2"];
                        
                        OSET(M2_inTransition,true);
                        OSET(M2_isActive,true);
                    };
                    */
                };
                ZRN_LOG_1(OGET(intensityCurrent));
            }],


            ["#delete", {
                // Handles return to pre-storm fogParams
                _fnc_scriptName = "#delete";
                if (fogParamsRestorePrevious) then {
                    OGET(fogParamsRestoreTime) setFog OGET(fogParamsPreviousWeather);
                };
            }],

            ["Meth_updateTarget",{
                _fnc_scriptName = "Meth_updateTarget";

                private _arr = [
                    linearConversion[0,1,OGET(intensityCurrent),OGET(fog_value_min),OGET(fog_value_max),true],
                    OGET(fog_decay),
                    OGET(fog_base)
                ];
                OSET(fogParamsTarget,_arr);
                ZRN_LOG_MSG_1(Result,_arr);
                ZRN_LOG_1(OGET(fogParamsTarget));
            }],


            // Methods
            ["Meth_Update", {
                _fnc_scriptName = "Meth_Update";

                params [
                    ["_presetName", "",     [""]    ],
                    ["_duration",   5,      [0]     ],
                    ["_intensity",  1,      [0]     ],
                    ["_restore",    false,  [true]  ]
                ];
                ZRN_LOG_MSG_1(x,OGET(intensityCurrent));

                private _oldMode = OGET(fog_mode);

                OSET(fogParamsRestorePrevious,_restore);
                OSET(fogParamsStart,fogParams);

                OSET(missionTimeStart,CBA_missionTime);
                OSET(missionTimeEnd,CBA_missionTime + _duration);


                if (_presetName != OGET(presetName)) then {
                    private _hash = [configFile >> QGVAR(FogParams), _presetName] call PFUNC(hashFromConfig);
                    OSET(presetName,_presetName);
                    OSET(fog_value_min,_hash get "fog_value_min");
                    OSET(fog_value_max,_hash get "fog_value_max");
                    OSET(fog_decay,_hash get "fog_decay");
                    OSET(fog_base,_hash get "fog_base");
                    OSET(fog_mode,_hash get "fog_mode");
                    OSET(fog_boost,_hash get "fog_boost");
                };

                OSET(intensityStart,OGET(intensityCurrent));
                OSET(intensityTarget,_intensity);

                if (_intensity == 0) then {
                    OSET(fog_mode,0);
                };
               
                private _newMode = OGET(fog_mode);


                if ((_oldMode == 2) && (_newMode != 2)) then {
                    // check if current mode == 2 and new mode is different, then break and wait for automatic 
                    OSET(M2_breakLoop,true);
                } else {
                    _self call ["#create"];
                };
            }],


            ["Meth_Apply_Mode0", {
                _fnc_scriptName = "Meth_Apply_Mode0";
                ZRN_LOG_MSG(Mode0 init);


                private _duration = OGET(missionTimeEnd) - CBA_missionTime;
                
                OSET(intensityCurrent,OGET(intensityTarget));
                
                if (OGET(intensityTarget == 0) && {OGET(fogParamsRestorePrevious)} ) then {
                    _duration setFog OGET(fogParamsPreviousWeather);
                } else {
                    _self call ["Meth_updateTarget"];
                    _duration setFog OGET(fogParamsTarget);
                };
            }]/*,          
// Mode 1 is currently on hold, dont really see any need or application for it
            ["Meth_Apply_Mode1", {
                _fnc_scriptName = "Meth_Apply_Mode1";
                private _duration = OGET(missionTimeEnd) - CBA_missionTime;
                
                ZRN_LOG_MSG_1(x,OGET(intensityCurrent));
                ZRN_LOG_MSG_1(x,OGET(intensityTarget));

                OSET(intensityCurrent,OGET(intensityTarget));

                ZRN_LOG_MSG_1(x,OGET(intensityCurrent));
                ZRN_LOG_MSG_1(x,OGET(intensityTarget));

                _self call ["Meth_updateTarget"];

                private _avg_ASL = round ([] call FUNC(get_AvgASL));
                if (OGET(fog_boost)) then { _avg_ASL = _avg_ASL + linearConversion [0, 900, _avg_ASL, 0, 230,false]; };
              
                private _fogParams = + OGET(fogParamsTarget);
                _fogParams set [2, _fogParams#2 + _avg_ASL ];

                _duration setFog _fogParams;
            }],
*/

/*
            ["Meth_Apply_Mode2", {
                _fnc_scriptName = "Meth_Apply_Mode2";                
                if (OGET(M2_breakLoop)) exitWith { _self call ["#create"]; };

                private _avg_ASL = round ([] call FUNC(get_AvgASL));                
                if (OGET(fog_boost)) then { _avg_ASL = _avg_ASL + linearConversion [0, 900, _avg_ASL, 0, 230,false]; };

                private _fog_target = OGET(fogParamsTarget);
                private _fog_start = OGET(fogParamsStart);


                private _currentParams = switch (time > _endTime) do {
                    case true: {
                        ZRN_LOG_MSG_1(PFH after transitiion,time);
                        // fog_target
                        [
                            _fog_target#0,
                            _fog_target#1,
                           (_fog_target#2) + _avg_ASL
                        ]
                    };
                    case false: {
                        ZRN_LOG_MSG_1(PFH during transitiion,time);
                        [
                            linearConversion [OGET(missionTimeStart), OGET(missionTimeEnd), time, _fog_start#0, _fog_target#0,             true ],
                            linearConversion [OGET(missionTimeStart), OGET(missionTimeEnd), time, _fog_start#1, _fog_target#1,             true ],
                            linearConversion [OGET(missionTimeStart), OGET(missionTimeEnd), time, _fog_start#2,(_fog_target#2) + _avg_ASL, true ]
                        ]
                    };
                };
                ZRN_LOG_1(_currentParams);

                if (OGET(M2_inTransition)) then {
                    // adjust params based on intensity
                    private _value = linearConversion[OGET(missionTimeStart), OGET(MissionTimeEnd), CBA_missionTime, OGET(intensityStart), OGET(intensityTarget), true];
                    ZRN_LOG_MSG_2(pre-,OGET(intensityCurrent),_value);
                    OSET(intensityCurrent,_value);
                    ZRN_LOG_MSG_1(post,OGET(intensityCurrent));
                    _self call ["Meth_updateTarget"];
                    if (CBA_missionTime > OGET(missionTimeEnd)) then { OSET(M2_inTransition,false); };
                };

                //just retrieve AvgASL and adjust base
                private _fogParams = + OGET(fogParamsTarget);

                _fogParams set [2, _fogParams#2 + _avg_ASL ];

                OGET(M2_interval) setFog _fogParams;


                // Final
                if ( !OGET(M2_inTransition) && {OGET(intensityCurrent) == 0} ) exitWith { missionNamespace setVariable [OGET(varName),nil] };
                [ { _this call ["Meth_Apply_Mode2"] } , _self, OGET(M2_interval)] call CBA_fnc_waitAndExecute;
            }]*/
        ]
    ];

    missionNamespace setVariable [_varName, _hmo];

} else {
    _hmo call ["Meth_Update", _this];
};

true


/*

old code
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
*/