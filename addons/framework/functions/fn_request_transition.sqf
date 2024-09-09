#include "..\script_component.hpp"

/*
* Author: [Zorn]
* Function to Start a Transition from Current (0 if no previous Storm occoured) to target intensity.
*
* Arguments:
* 0: _stormPreset       <STRING>  Classname of Storm Preset - Capitalisation needs to be exact! - Defines which Effects to call - Currently implemented Presets can be found here: addons/framework/Storm_MainPresets.inc.hpp
*                       Example: "STORM_Sandstorm"
*                       Default: "" (will fail)
* 1: _duration          <NUMBER>  Time in Minutes for the transition to take place.
*                       Example: 15
*                       Default: 5
* 2: _Intensity         <NUMBER> from 0 to 1 where 1 stands for 100% - Intensity of the Storm Effects. The higher the intensity, the stronger the Effects etc.
*                       Example: 0.75
*                       Example: 0.5
* 3: _chainTranisition  <BOOLEAN> if true, when a transition is currently taking place, // NOT IMPLEMENT YET
*                       Example: true
*                       Default: false
*
* Return Value:
* array of applied effects and their return [mostly true/false dependend on success
* OR
* if _chainTransition is true, it will return the index as Number in the queue. 
*
* Note: 
*
* Example:
* [_stormPreset,     _durationInMinutes, _Intensity] call storm_fnc_request_transition;
* ["STORM_Sandstorm",      10,               0.75  ] call storm_fnc_request_transition;
* 
* Public: Yes
*/

if (!isServer) exitWith {
   ZRN_LOG_MSG(failed: storm_fnc_request_transition needs to be executed on the server!);
   systemChat "Failed: storm_fnc_request_transition needs to be executed on the server!";
   false
};


params [
   ["_stormPreset",        "",      [""]  ],
   ["_duration",           5,       [0]   ],
   ["_intensity",          0.5,     [0]   ]
];

ZRN_LOG_4(_stormPreset,_duration,_intensity,_chainTransitions);

private _configPath = (configFile >> QPVAR(mainPresets));
_test = (configProperties [_configPath, "true", true] apply { toLowerANSI configName _x });


if  (_stormPreset == "")                                                                                             exitWith { ZRN_LOG_MSG(failed: Preset not provided); false };
if !(toLowerANSI _stormPreset in (configProperties [_configPath, "true", true] apply { toLowerANSI configName _x })) exitWith { ZRN_LOG_MSG(failed: Preset not found); false };
if (!isNil QPVAR(isActive) && {PVAR(isActive) # 2 == true && {_chainTransitions == false}} )                         exitWith { ZRN_LOG_MSG(failed: Transition is already taking place); false };
// TODO: ADD CHAIN TRANSITION FUNCTION 
if (_intensity == 0 && {isNil QPVAR(isActive) } )                                                                    exitWith { ZRN_LOG_MSG(failed: Cannot transition to 0 without previous Storm Transition); false };

// Sanitize
_duration =  _duration  max 1;
_intensity = _intensity max 0 min 1;

_hashMap = [_configPath, _stormPreset] call PFUNC(hashFromConfig);
if (_hashMap isEqualTo false) exitWith {false};

// _arr = [_stormPreset, intensity, isTransitioning, _hashMap];
_arr = [];
_arr set [0, _stormPreset];
_arr set [1, _intensity];
_arr set [2, true];
_arr set [3, _hashMap];
if (isNil QPVAR(isActive)) then { missionNameSpace setVariable [ QPVAR(isActive), _arr, true] };

ZRN_LOG_1(_hashMap);
private _result = [];
private "_var";

// ServerSide - FX Weather
_var = [_hashMap get "fx_weather_preset", _duration, _intensity * (_hashMap get "fx_weather_coef") ] call EFUNC(fx_weather,request);
_result pushback [_var, _hashMap get "fx_weather_preset"];

_var = [_hashMap get "fx_weather_fog_preset", _duration, _intensity * (_hashMap get "fx_weather_fog_coef") ] call EFUNC(fx_weather,request_fog);
_result pushback [_var, _hashMap get "fx_weather_fog_preset"];

// ServerSide - Mod_Skill
_var = [_hashMap get "mod_skill_preset",  _duration, _intensity * (_hashMap get "mod_skill_coef") ]  call EFUNC(mod_skill,request);
_result pushback [_var, _hashMap get "mod_skill_preset"];


// ClientSide - FX Sound
{   _var = [_x, _duration, _intensity * (_hashMap get "fx_sound_coef")   ] call EFUNC(fx_sound,request);
   _result pushback [_var, _x];
} forEach (_hashMap get "fx_sound_presets");

// ClientSide - FX Particle
{   _var = [_x, _duration, _intensity * (_hashMap get "fx_particle_coef") ] call EFUNC(fx_particle,request);
   _result pushback [_var, _x];
} forEach (_hashMap get "fx_particle_presets");

// ClientSide - FX Post
{   _var = [_x, _duration, _intensity * (_hashMap get "fx_post_coef")    ] call EFUNC(fx_post,request);
   _result pushback [_var, _x];
} forEach (_hashMap get "fx_post_presets");



_code = if (_intensity == 0 ) then {
    {
      missionNameSpace setVariable [QPVAR(isActive), nil, true];
    }
} else {
   {
      PVAR(isActive) set [2, false];
   };
};
[_code, [], _duration * 60 ] call CBA_fnc_waitAndExecute;

ZRN_LOG_MSG_1(completed!,_stormPreset);
_result