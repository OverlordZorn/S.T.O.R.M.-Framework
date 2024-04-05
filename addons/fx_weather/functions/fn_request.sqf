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
* ["Storm_fx_weather_Sandstorm_01", 1, 0.5] call storm_fxWeather_fnc_request;
* 
* Public: No
*
* GVARS
*  	GVAR(S_inTransition) boolean
*     GVAR(S_previousWeather) hashmap of previous weather settings for reset 
*
*/



if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };


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
// ################### FREEZE CURRENT ####################### 

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
   _rainParams = [ _hashMap get "rainParams" ] call FUNC(get_rainParams_as_Array);
   _valueRain = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true ];

   // remove the rain to create a no-rain period to change rainParams
   ( _duration / 3 ) setRain 0;

    // Apply new Rain Parameters during "noRain" period
   [ { _this call BIS_fnc_setRain; }, [_rainParams], ( _duration * 1/2 ) ] call CBA_fnc_waitAndExecute;
   ZRN_LOG_MSG_2(setRainParams--,_duration,_rainParams);
   _return pushback ["RainParams", true];

    // setRain during the last third of the transition, only if needed. 
   if ( (_hashMap getOrDefault ["change_rainValue", 0] > 0 )  && (_valueRain > 0) ) then { 
      [{
         params ["_duration", "_value"];
         (_duration * 1/3) setRain _value;
      }, [_duration,_valueRain],    _duration * 2/3] call CBA_fnc_waitAndExecute;
      _return pushback ["Rain", true];
   };
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
// ################### fog params ################### 

if ((_hashMap getOrDefault ["change_fog", 0]) > 0) then {
  if (_firstWeatherChange) then {
 // Save Current
   GVAR(S_previousWeather) set ["change_fog", 1];
   GVAR(S_previousWeather) set ["fogParams", fogParams];
   };


 // Establish _fog_target for the Transition
   private ["_fog_target", "_fog_Mode"];
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
         _fog_target set [1,_hashMap get "fog_dispersion"];
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
         [_fog_target, _duration, _intensity] call FUNC(setFog_avg);
         ZRN_LOG_MSG_3(setFog_avg-call,_duration,_fog_target,_intensity);

         // If fogBase via AvgASL is requested only during initial Tranistion, (Mode=1), perFrameHandler will be terminated after transition.
         _isContinous = [false, true] select (_fog_Mode - 1);
         if (!_isContinous) then { [ { GVAR(fogParams) = nil; } , [], _duration * 1.1] call CBA_fnc_waitAndExecute;};
         _return pushback ["fog", true];
      };
   };
};



// ##################################################
// ################### wind vector ################## 

if ((_hashMap getOrDefault ["change_wind",0]) > 0) then {


   if (_firstWeatherChange) then {
      // Save Current
      GVAR(S_previousWeather) set ["change_wind", 1];
      GVAR(S_previousWeather) set ["wind_value", vectorMagnitude wind];

      missionNamespace setVariable ["ace_weather_disableWindSimulation", true];

   };

   // get Value + Intensity
   _target_magnitude = linearConversion[0,1,_intensity,0,_hashMap get "wind_value",true];

   // Start "recursive", finite  transition.

   _forceWindEnd = switch (_hashMap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration, _forceWindEnd] call FUNC(setWind);

   _return pushback ["wind", true];
   ZRN_LOG_MSG_2(setWind--------,_duration,_target_magnitude);


   if (_intensity == 0) then {
      [ { missionNamespace setVariable ["ace_weather_disableWindSimulation", nil]; } , [], _duration] call CBA_fnc_waitAndExecute;
   };
};

// ##########################################################
// ##########################################################




private _code = switch (_intensity) do {
   case 0: {{
      GVAR(S_previousWeather) = nil;

      GVAR(S_inTransition) = nil;

      ZRN_LOG_MSG(Transition Complete & S_previousWeather weather has been restored);
    }};
   default {{
      GVAR(S_inTransition) = false;

      ZRN_LOG_MSG(Transition Complete);
    }};
};

[ _code , [], _duration ] call CBA_fnc_waitAndExecute;

_return