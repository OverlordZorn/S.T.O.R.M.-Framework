#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Function to apply the Storm Preset, which will take care off all needed groups of effect, be it Post Processing, Weather, Particles etc.
 *
 * Arguments:
 * 0: _storm_preset_name      <STRING> Name of Storm Preset - Capitalisation needs to be exact!
 * 1: _duration               <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity              <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * none
 *
 * Note: 
 *
 * Example:
 * [_storm_preset_name, _duration, _intensity] call cvo_storm_fnc_storm_request;
 * 
 * Public: No
 */

if (!isServer) exitWith {_this call PFUNC(request_transition) };

params [
   ["_stormPreset",     "",   [""]  ],
   ["_duration",        5,    [0]   ],
   ["_intensity",       0.5,  [0]   ]
];

ZRN_LOG_3(_stormPreset,_duration,_intensity);

private _configPath = (configFile >> QPVAR(mainPresets));
_test = (configProperties [_configPath, "true", true] apply { toLowerANSI configName _x });


if  (_stormPreset == "")                                                                                             exitWith { ZRN_LOG_MSG(failed: Preset not provided); false };
if !(toLowerANSI _stormPreset in (configProperties [_configPath, "true", true] apply { toLowerANSI configName _x })) exitWith { ZRN_LOG_MSG(failed: Preset not found); false };
if (!isNil QPVAR(isActive) && {PVAR(isActive) # 2 == true} )                                                         exitWith { ZRN_LOG_MSG(failed: Transition is already taking place); false };
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

_var = [_hashMap get "mod_skill_preset",  _duration, _intensity * (_hashMap get "mod_skill_coef") ]  call EFUNC(mod_skill,request);
_result pushback [_var, _hashMap get "mod_skill_preset"];


_var = [_hashMap get "fx_weather_preset", _duration, _intensity * (_hashMap get "fx_weather_coef") ] call EFUNC(fx_weather,request);
_result pushback [_var, _hashMap get "fx_weather_preset"];


{   _var = [_x, _duration, _intensity * (_hashMap get "fx_sound_coef")   ] call EFUNC(fx_sound,request);
   _result pushback [_var, _x];
} forEach (_hashMap get "fx_sound_presets");


{   _var = [_x, _duration, _intensity * (_hashMap get "fx_particle_coef") ] call EFUNC(fx_particle,request);
   _result pushback [_var, _x];
} forEach (_hashMap get "fx_particle_presets");


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
   }
};
[_code, [], _duration * 60 ] call CBA_fnc_waitAndExecute;

_result