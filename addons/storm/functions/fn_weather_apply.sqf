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



// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

// use this for Set rain
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]

if ((_hashMap get "change_rainParams") > 0) then {

   // Store previous rain Parms
   CVO_Storm_previous_weather_hashmap set ["RainParams", rainParams];

   // Store previous rainValue if rain changes
   if ((_hashMap get "change_rainValue") > 0) then { CVO_Storm_previous_weather_hashmap set ["rain", rain]; };

   //retrieve RainParms Value and Rain Value with Intensity
   _valuePara = [ _hashMap get "rainParams" ] call cvo_storm_fnc_weather_get_rainParams_as_Array;
   _valueRain = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true ];

   // remove the rain to create a no-rain period to change rainParams
   ( _duration / 3 ) setRain 0;

    // Apply new Rain Parameters during "noRain" period
   [ { _this call BIS_fnc_setRain; }, _valuePara, ( _duration * 1/2 ) ] call CBA_fnc_waitAndExecute;

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
      // apply Intensity
      _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
   };
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

// TODO: Refine to have AvgASL applied over time multiple times during the duration.

if ((_hashMap get "change_fog") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["fogParams", fogParams];

   _fogParams = [];
   _fogParams set [0, (linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", false])];
   _fogParams set [1,_hashMap get "fog_density"];
   
   _fogBase = if ((_hashmap get "fog_use_AvgASL") == 0 ) then {
      // get dynamic value
      ([] call cvo_storm_fnc_weather_getAvgASL)  select 0;
   } else {
      // use fixed value
      _hashmap get "fog_base";
      };
   _fogParams set [2,_fogBase];


   if (_hashmap get "fog_use_AvgASL_continous" > 0) then {
      // Defines server_global variable to be accessed from the continous
      CVO_Storm_Fog_Current_Params = _fogParams;

      // Start Function 
      // TODO: Start Fog_constant_AvgASL 
   } else {
      // execute Changes   
      _duration setFog _fogParams;
      
   };   
};


// ##################################################
// ################### wind vector ################## 

if ((_hashMap get "change_wind") > 0) then {
   // Save Current
   CVO_Storm_previous_weather_hashmap set ["wind", wind];
   // get Value + Intensity
   _target_magnitude = _hashMap get "wind_value";
   // Start recursive, limted transition.
   [wind, _target_magnitude, _duration] call cvo_storm_fnc_weather_setWind_recursive;
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

