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
 * ["CVO_CC_Alias", 5, 0.5] call cvo_storm_fnc_apply_ppEffect;
 * 
 * Public: No
 */


if !(isServer) exitWith {};

params [
   ["_weather_preset_name",    "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity,",             0,  [0]]
];

if (_weather_preset_name isEqualTo "")    exitWith { false };
if (_duration isEqualTo 0)                exitWith { false };
if (_duration isEqualTo 0)                exitWith { false };
if (_intensity <= 0 )                     exitWith { false };

if (isNil "CVO_WeatherChanges_active") then {
   CVO_WeatherChanges_active = true;
};

// Adjusts Duration to secounds.
_duration = _duration * 60;


_return = ["_weather_preset_name"] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash;
_return params ["_hashMap", "_properties"];

CVO_Storm_previous_weather_hashmap = createHashMap;

if ((_hashMap get "change_overcast") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["overcast", overcast];
   _value = linearConversion [   0,    1, _intensity, overcast,_hashMap get "overcast_value", true];
   _duration setOvercast _value;
};

/////// freeze current weather changes
0 setOvercast     overcast;
0 setRain         rain;
0 setLightnings   lightnings;
0 setFog          fogParams;
  setWind         (wind set [2,true]);
0 setGusts        gusts;
0 setWaves        waves;
forceWeatherChange;



/////// TODO: RAIN mechanism that handles rain parameter change when it is currently raining
/////// TODO: RAIN effects setHumidity (maybe 2-3 times over the duration? set according to Rain Value if rainParams "snow" is >0)

/*


// ############################################
// ################### RAIN ################### 

if ((_hashMap get "change_rainValue") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["rain", rain];
   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "rain_value", true];
   // execute Changes
   _duration setRain _value;
};

// ###################################################
// ################### RAIN Params ################### 

// use this for Set rain
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]

if ((_hashMap get "change_rainParams") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["RainParams", rainParams];
   // retrieve Params
   _value = [_hashMap get "rainParams"] call cvo_storm_fnc_weather_get_rainParams_as_Array;
   // execute Changes
   _value call BIS_fnc_setRain;
};
*/



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

// TODO: Refine to have AvgASL applied over time multiple times during the duration.
/*
if ((_hashMap get "change_fog") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["fogParams", fogParams];

   _fogParams = [];
   _fogParams set [0, (linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", false])] 
   _fogParams set [1,_hashMap get "fog_density"];
   
   _fogBase = if ((_hashmap get "fog_useAvgASL") > 0 ) then {
      // get dynamic value

   } else {
      // use fixed value
      _hashmap get "fog_base"
      };

   _fogParams set [2,_fogBase];

   // execute Changes   
   _duration setFog _fogParams;
};
*/

// ##################################################
// ################### wind vector ################## 

// TODO: Apply Wind via x/y component and increase over time manually
/*
if ((_hashMap get "change_wind") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["wind", wind];
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "wind_value", true];
   _duration setWind [x,y,force] ;
};
*/

// ##################################################
// ################### Gusts ######################## 

// TODO: Apply Wind via x/y component and increase over time manually
if ((_hashMap get "change_gusts") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["gusts", gusts];
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   _duration setGusts _value;
};

// ##################################################
// ################### Waves ######################## 

// TODO: Apply Wind via x/y component and increase over time manually
if ((_hashMap get "change_waves") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["waves", waves];
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];
   _duration setWaves _value;
};

