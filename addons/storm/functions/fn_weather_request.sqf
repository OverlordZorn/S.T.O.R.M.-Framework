/*
 * Author: Zorn
 * Applies Weather Over Time. 
 *
 * Arguments:
 * 0: _weather_preset_name    <STRING> Name of Post Process Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * _pp_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_Weather_Sandstorm_01", 5, 0.5] call CVO_STORM_fnc_weather_request;
 * 
 * Public: No
 */


if !(isServer) exitWith {};

params [
   ["_weather_preset_name",    "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",             0,  [0]]
];

if (_weather_preset_name isEqualTo "")    exitWith { false };
if (_duration isEqualTo 0)                exitWith { false };
if (_intensity <= 0 )                     exitWith { false };


if (isNil "CVO_WeatherChanges_active") then {
   CVO_WeatherChanges_active = true;
};

// Adjusts Duration to secounds.
_duration = _duration * 60;

diag_log format ["[CVO][STORM](Weather_request) - name: %1 - _duration: %2- _intensity: %3", _weather_preset_name, _duration, _intensity];

// get hashMap, check if its "false", if not, store _hashmap
private _hashMap  = [_weather_preset_name] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash;
if (_hashMap isEqualTo false) exitWith {   diag_log format ["[CVO][STORM](Weather_request)(Error) - get_WeatherPreset_as_Hash returned False: %1", _hashMap]; };
diag_log format ["[CVO][STORM](Weather_request) - hashmap: %1", _hashMap];


CVO_Storm_previous_weather_hashmap = createHashMap;


// ##########################################################
// ################### FREEZE CURRENT ####################### 

0 setOvercast     overcast;
0 setRain         rain;
0 setLightnings   lightnings;
0 setFog          fogParams;
  setWind         (wind set [2,true]);
0 setGusts        gusts;
0 setWaves        waves;
forceWeatherChange;

// ##########################################################
// ################### OVERCAST ############################# 

if ((_hashMap get "change_overcast") > 0) then {

   // Save Current
   CVO_Storm_previous_weather_hashmap set ["overcast", overcast];

//   diag_log format ["[CVO][STORM](Weather_request) - overcast_value: %1", _hashMap get "overcast_value"];

   // apply new
   _value_overcast = linearConversion [   0,    1, _intensity, 0, (_hashMap get "overcast_value"), true];
   _duration setOvercast _value_overcast;
};


// ##################################################
// ################### wind vector ################## 

if ((_hashMap get "change_wind") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["wind", wind];

   // get Value + Intensity
   _target_magnitude = _hashMap get "wind_value";
   // Start "recursive", finite  transition.

   _forceWindEnd = switch (_hashmap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration, _forceWindEnd] call cvo_storm_fnc_weather_setWind;
};

// ##################################################
// ################### Gusts ######################## 

if ((_hashMap get "change_gusts") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["gusts", gusts];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   // execute Changes
   _duration setGusts _value;
};

// ##################################################
// ################### Waves ######################## 

if ((_hashMap get "change_waves") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["waves", waves];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];
   // execute Changes
   _duration setWaves _value;
};




// ##################################################
// ################### Lightnings ################### 


if ((_hashMap get "change_lightnings") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["lightnings", lightnings];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "lightnings_value", true];
   // execute Changes
   _duration setLightnings _value;
};


// ##################################################
// ################### fog params ################### 

if ((_hashMap get "change_fog") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["fogParams", fogParams];

   // Establish FogParameters for the Transition
   _fogParams = [];
   _fogParams set [0, (linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", false])];
   _fogParams set [1,_hashMap get "fog_dispersion"];
   _fogParams set [2,_hashmap get "fog_base"];
   _fogParams set [3, "no_avg_ASL"];

   _fogBase = if ((_hashmap get "fog_use_AvgASL")           == 1 ) then { _fogParams set [3,"use_AvgASL_once"]; };
   _fogBase = if ((_hashmap get "fog_use_AvgASL_continous") == 1 ) then { _fogParams set [3,"use_AvgASL_continous"]; };

   // Execute
   if (isNil "CVO_Storm_FogParams_target") then {
      // Establish new setFog-loop
      CVO_Storm_FogParams_target = _fogParams;
      ["CVO_Storm_FogParams_target", _duration ] call cvo_storm_fnc_weather_setFog_recursive_continous;
   } else {
      // update already existing setFog-loop
      CVO_Storm_FogParams_target = _fogParams;
   };
};


// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

// use this for Set rainParameters
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]

if ((_hashMap get "change_rainParams") > 0) then {

   // Store previous rain Parms
   CVO_Storm_previous_weather_hashmap set ["RainParams", rainParams];

   // Store previous rainValue if rain changes
   if ((_hashMap get "change_rainValue") > 0) then { CVO_Storm_previous_weather_hashmap set ["rain", rain]; };

   //retrieve RainParms Value and Rain Value with Intensity
   _rainParams = [ _hashMap get "rainParams" ] call cvo_storm_fnc_weather_get_rainParams_as_Array;
   _valueRain = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true ];

   // remove the rain to create a no-rain period to change rainParams
   ( _duration / 3 ) setRain 0;

    // Apply new Rain Parameters during "noRain" period
   [ { _this call BIS_fnc_setRain; }, _rainParams, ( _duration * 1/2 ) ] call CBA_fnc_waitAndExecute;

    // setRain during the last third of the transition, only if needed. 
   if ( (_hashMap get "change_rainValue" > 0 )  && (_valueRain > 0) ) then { 
      [{
         params ["_duration", "_value"];
         (_duration * 1/3) setRain _value;
      }, [_duration,_valueRain],    _duration * 2/3] call CBA_fnc_waitAndExecute;
   };

} else {

   // Set Rain only
   if ((_hashMap get "change_rainValue") > 0) then {
      // Save Current
      CVO_Storm_previous_weather_hashmap set ["rain", rain];

      diag_log format ["[CVO][STORM](Weather_request) reee - _hashMap get ""rain_value"": %1 - _duration: %2- _intensity: %3", (_hashMap get "rain_value"), _duration, _intensity];

      // apply Intensity
      _value = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
   };
};
