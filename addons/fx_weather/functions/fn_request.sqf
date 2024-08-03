#include "..\script_component.hpp"

/*
* Author: Zorn
* Applies Weather Over Time. 
*
* Arguments:
* 0: _presetName    <STRING> Name of Post Process Preset - Capitalisation needs to be exact!
* 1: _duration          <NUMBER> in Minutes for the duration to be applied.
* 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
*
* Return Value:
* true if successful
*
* Example:
* ["storm_fx_weather_RainParams_Snow"] call STORM_FX_WEATHER_fnc_get_rainParams_as_Array;
* 
* Public: No
*
* GVARS
*  	GVAR(S_inTransition) boolean
*     GVAR(S_previousWeather) hashmap of previous weather settings for reset 
*
*/



if (!isServer) exitWith {};

params [
   ["_presetName",    "", [""]],
   ["_duration",      5,  [0] ],
   ["_intensity",     0,  [0] ]
];

ZRN_LOG_MSG_3(INIT,_presetName,_duration,_intensity);


// Check: transition currently?
if ( missionNamespace getVariable [QGVAR(S_inTransition), false] ) exitWith { ZRN_LOG_MSG(failed: Transition already in progress); false };

// check: Can reset?
if ( _intensity == 0 && isNil QGVAR(S_previousWeather) ) exitWith { ZRN_LOG_MSG(failed: intensity = 0 while no S_previousWeather change); false };

if (_intensity == 0) then {   _presetName = "Reset";  };

// Check: No Preset?
if (_presetName isEqualTo "")    exitWith { ZRN_LOG_MSG(failed: no _presetName given); false };


_duration = 60 * (_duration max 1);
_intensity = _intensity max 0 min 1;


if (isNil QGVAR(S_inTransition)) then {   GVAR(S_inTransition) = true;   };



private _hashMap = switch (_intensity) do {
   case 0: { + GVAR(S_previousWeather) };
   default { [( configFile >> QGVAR(Presets) ), _presetName] call PFUNC(hashFromConfig); };
};



// get hashMap, check if its "false", if not, store _hashMap
if (_hashMap isEqualTo false) exitWith {   ZRN_LOG_MSG(failed: get_WeatherPreset_as_Hash has returned with an error); false };


ZRN_LOG_MSG(Request approved - wait for completion);
ZRN_LOG_3(_presetName,_duration,_intensity);
ZRN_LOG_1(_hashMap);

private _firstWeatherChange = isNil QGVAR(S_previousWeather);
if (_firstWeatherChange) then {
   GVAR(S_previousWeather) = createHashMap;
};

private _return = [];

// ##########################################################
// ###### FREEZE CURRENT Weather transitions ################ 

if (_firstWeatherChange) then {

   0 setOvercast     overcast;
   0 setRain         rain;
   0 setLightnings   lightnings;
   0 setFog          fogParams;
     setWind         [wind#0, wind#1, true];
   0 setGusts        gusts;
   0 setWaves        waves;
   forceWeatherChange;
};

// ##########################################################
// ################### OVERCAST ############################# 

if ((_hashMap getOrDefault ["change_overcast",0]) > 0) then {

   if (_firstWeatherChange) then {
      // Save Current
      GVAR(S_previousWeather) set ["change_overcast", 1];
      GVAR(S_previousWeather) set ["overcast_value", overcast];
   };
   // apply new
   _value = linearConversion [   0,    1, _intensity, 0, (_hashMap get "overcast_value"), true];
   _duration setOvercast _value;
   _return pushback ["overcast", true];
   ZRN_LOG_MSG_2(setOvercast----,_duration,_value);
};


// ##################################################
// ################### Gusts ######################## 

if ((_hashMap getOrDefault ["change_gusts", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(S_previousWeather) set ["change_gusts", 1];
   GVAR(S_previousWeather) set ["gusts_value", gusts];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   // execute Changes
   _duration setGusts _value;
   _return pushback ["gusts", true];
   ZRN_LOG_MSG_2(setGusts-------,_duration,_value);
};


// ##################################################
// ################### Waves ######################## 

if ((_hashMap getOrDefault ["change_waves", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(S_previousWeather) set ["change_gusts", 1];
   GVAR(S_previousWeather) set ["waves_value", waves];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];

   // execute Changes
   _duration setWaves _value;
   _return pushback ["Waves", true];
   ZRN_LOG_MSG_2(setWaves-------,_duration,_value);
};




// ##################################################
// ################### Lightnings ################### 


if ((_hashMap getOrDefault ["change_lightnings", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(S_previousWeather) set ["change_lightnings", 1];
   GVAR(S_previousWeather) set ["lightnings_value", lightnings];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "lightnings_value", true];
   // execute Changes
   _duration setLightnings _value;
   _return pushback ["Lightnings", true];
   ZRN_LOG_MSG_2(setLightnings--,_duration,_value);
};

// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

if ((_hashMap getOrDefault ["change_rainParams", 0]) > 0) then {

      // Store S_previousWeather rain Parms
   if (_firstWeatherChange) then {
      GVAR(S_previousWeather) set ["change_rainParams", 1];
      GVAR(S_previousWeather) set ["RainParams", rainParams];
      // Store S_previousWeather rainValue if rain changes
      if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then { 
         GVAR(S_previousWeather) set ["change_rainValue", 1];
         GVAR(S_previousWeather) set ["rain_value", rain];
      };
   };


   //retrieve RainParms Value and Rain Value with Intensity
   private _rainParams_target = if (_intensity == 0) then {
      GVAR(S_previousWeather) getOrDefault ["RainParams", []]
   } else {
      [ _hashMap get "rainParams" ] call FUNC(get_rainParams_as_Array);      
   };

   private _valueRain = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true ];

   ZRN_LOG_MSG_1(rain Params Retrieved,_rainParams_target);

   _rainParams_current = missionNameSpace getVariable [QGVAR(S_current_rainParams), [] ];

   private _transition = "SOFT";
// if (_rainParams_current isEqualTo []) then { _transition = "SOFT" };
   if (_rainParams_current isEqualTo _rainParams_target ) then { _transition = "DIRECT"};


   missionNameSpace setVariable [QGVAR(S_current_rainParams), _rainParams_target];
   // If current RainParams isNotEqualTo the Incoming RainParams, pause the rain, apply new Params and restart.
   switch (_transition) do {
      case "DIRECT": {
         [
            {
               _return = _this call BIS_fnc_setRain;
               ZRN_LOG_MSG_2(Direct BisFncsetRain,_return,_this);
            },
            _rainParams_target,
            _duration/2
         ] call CBA_fnc_waitAndExecute;
      };
      case "SOFT": {
         // remove the rain to create a no-rain period to change rainParams
         ( _duration / 3 ) setRain 0;

         // Apply new Rain Parameters during "noRain" period
         [{
            // If the RainParams Argument isSnow == true, it will set the Humidity to 0.25 do avoid the sound of "extremely drippingly wet footsteps"
            ZRN_LOG_MSG_2(CATCHME,_this,_this#15);
            if ( count _rainParams_target != 0 && {(_this select 15) isEqualTo true} ) then {
               0.25 remoteExec ["setHumidity", [0,-2] select isDedicated];
            };
            _return = _this call BIS_fnc_setRain;
            ZRN_LOG_MSG_2(Soft bisFncsetRain,_return,_this);

         }, _rainParams_target, ( _duration /2 ) ] call CBA_fnc_waitAndExecute;

         ZRN_LOG_MSG_2(setRainParams--,_duration,_rainParams_target);

         // setRain during the last third of the transition, only if needed. 
         if ( (_hashMap getOrDefault ["change_rainValue", 0] > 0 )  && (_valueRain > 0) ) then { 
            [{
               params ["_duration", "_value"];
               (_duration * 1/3) setRain _value;
            }, [_duration,_valueRain],    _duration * 2/3] call CBA_fnc_waitAndExecute;
            _return pushback ["Rain", true];
         };
      };
   };
   _return pushback ["RainParams", true];

} else {

   // Set Rain only
   if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then {

   // Save Current
   if (_firstWeatherChange) then {
      GVAR(S_previousWeather) set ["change_rainValue", 1];
      GVAR(S_previousWeather) set ["rain_value", rain];
   };

      // apply Intensity
      _value = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
      ZRN_LOG_MSG_2(setRain--------,_duration,_value);
      _return pushback ["RainOnly", true];
   };
};


// ##################################################
// ################### wind vector ################## 

if ((_hashMap getOrDefault ["change_wind",0]) > 0) then {

   
   if (_firstWeatherChange) then {
      // Save Current
      GVAR(S_previousWeather) set ["change_wind", 1];
      GVAR(S_previousWeather) set ["wind_value", vectorMagnitude wind];

   };

   // get Value + Intensity
   _target_magnitude = linearConversion[0,1,_intensity,0,_hashMap get "wind_value",true];

   // Start "recursive", finite  transition.
   _forceWindEnd = switch (_hashMap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration,_intensity, _forceWindEnd] call FUNC(setWind);

   _return pushback ["wind", true];
   ZRN_LOG_MSG_2(setWind--------,_duration,_target_magnitude);

};

// ##########################################################
// ##########################################################


// ##########################################################
// ############## ace_weather_temperatureShift ##############

if (!isNil "ace_weather_temperatureShift" && {_hashmap getorDefault ["ace_temp_shift", 0] != 0}) then {
   if !( ace_weather_temperatureShift in GVAR(S_previousWeather) ) then { GVAR(S_previousWeather) set ["ace_weather_temperatureShift", ace_weather_temperatureShift]; };
   _tempShift = linearConversion [0,1,_intensity, 0,_hashMap get "ace_temp_shift"];
   [ { ace_weather_temperatureShift = _this#0; } , [_tempShift], _duration/2] call CBA_fnc_waitAndExecute;
};


// ##########################################################
// ##########################################################


private _code = switch (_intensity) do {
   case 0: {{
      // Cleanup
      GVAR(S_current_rainParams) = nil;
      GVAR(S_inTransition) = nil;

      if ("ace_weather_temperatureShift" in GVAR(S_previousWeather)) then {

         [{
            ace_weather_temperatureShift = GVAR(S_previousWeather) get "ace_weather_temperatureShift";
            GVAR(S_previousWeather) = nil;   
         } , [], _duration/2] call CBA_fnc_waitAndExecute;

      } else {
         GVAR(S_previousWeather) = nil;
      };
      ZRN_LOG_MSG(Transition Complete & S_previousWeather weather has been restored);
    }};
   default {{
      GVAR(S_inTransition) = false;

      ZRN_LOG_MSG(Transition Complete);
    }};
};

[ _code , [], _duration ] call CBA_fnc_waitAndExecute;

_return