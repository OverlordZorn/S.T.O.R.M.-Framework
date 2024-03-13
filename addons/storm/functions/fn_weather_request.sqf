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
 * ["CVO_Weather_Sandstorm_01", 1, 0.5] call CVO_STORM_fnc_weather_request;
 * 
 * Public: No
 */


if !(isServer) exitWith {};

params [
   ["_weather_preset_name",    "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",             0,  [0]]
];

if (_weather_preset_name isEqualTo "")    exitWith { diag_log "[CVO](debug)(fn_weather_request) Failed - Weather PresetName = "" "; false };

_duration = _duration max 1;
_duration = _duration * 60;

_intensity = _intensity max 0;
_intensity = _intensity min 1;


if ( missionNamespace getVariable ["CVO_WeatherChanges_active", false] ) exitWith { diag_log "[CVO](STORM)(fn_weather_request) Request failed - Weather Transition already taking place";};

if (isNil "CVO_WeatherChanges_active") then {
   CVO_WeatherChanges_active = true;
};




// get hashMap, check if its "false", if not, store _hashmap
private _hashMap  = [_weather_preset_name] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash;
if (_hashMap isEqualTo false) exitWith {   diag_log format ["[CVO][STORM](Weather_request)(Error) - get_WeatherPreset_as_Hash returned False: %1", _hashMap]; };
// Diag_log format ["[CVO][STORM](Weather_request) - hashmap: %1", _hashMap];

diag_log format ["[CVO][STORM](Weather_request) Weather sucessfully Requested: %1 - _duration: %2 - _intensity: %3", _weather_preset_name, _duration, _intensity];

CVO_Storm_previous_weather_hashmap = createHashMap;


// ##########################################################
// ################### FREEZE CURRENT ####################### 

0 setOvercast     overcast;
0 setRain         rain;
0 setLightnings   lightnings;
0 setFog          fogParams;
  setWind         [wind#0, wind#1, true];
0 setGusts        gusts;
0 setWaves        waves;
forceWeatherChange;
// Diag_log "[CVO](debug)(fn_weather_request) Freeze Current Weather Done";

// ##########################################################
// ################### OVERCAST ############################# 

if ((_hashMap get "change_overcast") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Overcast Requested";


   // Save Current
   CVO_Storm_previous_weather_hashmap set ["overcast", overcast];

//   diag_log format ["[CVO][STORM](Weather_request) - overcast_value: %1", _hashMap get "overcast_value"];

   // apply new
   _value_overcast = linearConversion [   0,    1, _intensity, 0, (_hashMap get "overcast_value"), true];
   _duration setOvercast _value_overcast;

   // Diag_log "[CVO](debug)(fn_weather_request) Set Overcast Done";
};

// ##################################################
// ################### wind vector ################## 

if ((_hashMap get "change_wind") > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Wind Requested";


   // Save Current
   CVO_Storm_previous_weather_hashmap set ["wind", wind];
   diag_log format ['[CVO](debug)(fn_weather_request) CVO_Storm_previous_weather_hashmap: %1 - "": %2 - "": %3 - "": %4 - "": %5 - "": %6 - "": %7 - "": %8', CVO_Storm_previous_weather_hashmap , "" ,"" , "" , "" , "" , "" , "" ];

   // get Value + Intensity
   _target_magnitude = linearConversion[0,1,_intensity,0,_hashMap get "wind_value",true];

   diag_log format ['[CVO](debug)(fn_weather_request) _target_magnitude: %1', _target_magnitude];
   // Start "recursive", finite  transition.

   _forceWindEnd = switch (_hashmap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration, _forceWindEnd] call cvo_storm_fnc_weather_setWind;
   diag_log "[CVO](debug)(fn_weather_request) Set Wind Done";
};

// ##################################################
// ################### Gusts ######################## 

if ((_hashMap get "change_gusts") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Gust Done";

   // Save Current
   CVO_Storm_previous_weather_hashmap set ["gusts", gusts];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   // execute Changes
   _duration setGusts _value;
   // Diag_log "[CVO](debug)(fn_weather_request) Set Gust Done";
};


// ##################################################
// ################### Waves ######################## 

if ((_hashMap get "change_waves") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Waves Requested";
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["waves", waves];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];
   // execute Changes
   _duration setWaves _value;
   // Diag_log "[CVO](debug)(fn_weather_request) Set Waves Done ";
};




// ##################################################
// ################### Lightnings ################### 


if ((_hashMap get "change_lightnings") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Lightning Requested";
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["lightnings", lightnings];

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "lightnings_value", true];
   // execute Changes
   _duration setLightnings _value;
   // Diag_log "[CVO](debug)(fn_weather_request) Set Lightning Done ";
};


// ##################################################
// ################### fog params ################### 

if ((_hashMap get "change_fog") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Fog Requested";
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["fogParams", fogParams];

   // Establish FogParameters for the Transition
   _fogParams = [];
   _fogParams set [0, (linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", false])];
   _fogParams set [1,_hashMap get "fog_dispersion"];
   _fogParams set [2,_hashmap get "fog_base"];
   _fogParams set [3, "no_avg_ASL"];

   if ((_hashmap get "fog_use_AvgASL")           == 1 ) then { _fogParams set [3,"use_AvgASL_once"]; };
   if ((_hashmap get "fog_use_AvgASL_continous") == 1 ) then { _fogParams set [3,"use_AvgASL_continous"]; };

   // Execute
   if (isNil "CVO_Storm_FogParams_target") then {

      // Diag_log "[CVO](debug)(fn_weather_request) fog params - CVO_Storm_FogParams_target isNil! ";
      // Establish new setFog-loop
      CVO_Storm_FogParams_target = _fogParams;
      ["CVO_Storm_FogParams_target", _duration ] call cvo_storm_fnc_weather_setFog_recursive_continous;
   } else {
      // update already existing setFog-loop
      CVO_Storm_FogParams_target = _fogParams;
      // Diag_log "[CVO](debug)(fn_weather_request) fog params - CVO_Storm_FogParams_target is not Nil! ";
   };
   // Diag_log "[CVO](debug)(fn_weather_request) Set Fog Done ";
};


// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

// use this for Set rainParameters
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]

if ((_hashMap get "change_rainParams") > 0) then {
   Diag_log "[CVO](debug)(fn_weather_request) Set Rain Requested - RainParams: true ";
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
   // Diag_log "[CVO](debug)(fn_weather_request) Set Rain Done - RainParams: true ";
} else {
   Diag_log "[CVO](debug)(fn_weather_request) Set Rain Requested";
   // Set Rain only
   if ((_hashMap get "change_rainValue") > 0) then {
      // Save Current
      CVO_Storm_previous_weather_hashmap set ["rain", rain];

      // Diag_log format ["[CVO][STORM](Weather_request) reee - _hashMap get ""rain_value"": %1 - _duration: %2- _intensity: %3", (_hashMap get "rain_value"), _duration, _intensity];

      // apply Intensity
      _value = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
   // Diag_log "[CVO](debug)(fn_weather_request) Set Rain Done";
   };
};

// ##########################################################
// ##########################################################


[
   {
      CVO_WeatherChanges_active = false;
      Diag_log "[CVO](debug)(fn_weather_request) Transition Complete";
   },[], _duration
] call CBA_fnc_waitAndExecute;