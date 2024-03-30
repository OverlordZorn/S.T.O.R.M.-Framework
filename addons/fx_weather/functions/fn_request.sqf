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
 * _pp_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_Weather_Sandstorm_01", 1, 0.5] call storm_fxWeather_fnc_request;
 * 
 * Public: No
 */


if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };


params [
   ["_presetName",    "", [""]],
   ["_duration",      5,  [0] ],
   ["_intensity",     0,  [0] ]
];

ZRN_LOG_MSG_3(INIT,_presetName,_duration,_intensity);


// Check: transition currently?
if ( missionNamespace getVariable [QGVAR(isActiveTransition), false] ) exitWith { ZRN_LOG_MSG(failed: Transition already in progress); false };

// check: Can reset?
if ( _intensity == 0 && isNil QGVAR(previous) ) exitWith { ZRN_LOG_MSG(failed: intensity = 0 while no previous change); false };

if (_intensity == 0) then {   _presetName = "Reset";  };

// Check: No Preset?
if (_presetName isEqualTo "")    exitWith { ZRN_LOG_MSG(failed - no _presetName given); false };


_duration = 60 * (_duration max 1);
_intensity = _intensity max 0 min 1;


if (isNil QGVAR(isActiveTransition)) then {   GVAR(isActiveTransition) = true;   };



private _hashMap = switch (_intensity) do {
   case 0: { + GVAR(previous) };
   default { [_presetName] call FUNC(get_WeatherPreset_as_Hash); };
};

// get hashMap, check if its "false", if not, store _hashMap
if (_hashMap isEqualTo false) exitWith {   ZRN_LOG_MSG(failed: get_WeatherPreset_as_Hash has returned with an error); false };

ZRN_LOG_MSG(Request approved - wait for completion);
ZRN_LOG_3(_presetName,_duration,_intensity);
ZRN_LOG_1(_hashMap);

private _firstWeatherChange = isNil QGVAR(previous);
if (_firstWeatherChange) then {
   GVAR(previous) = createHashMap;
};



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

// ##########################################################
// ################### OVERCAST ############################# 

if ((_hashMap getOrDefault ["change_overcast",0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(previous) set ["change_overcast", 1];
   GVAR(previous) set ["overcast_value", overcast];
};
   // apply new
   _value_overcast = linearConversion [   0,    1, _intensity, 0, (_hashMap get "overcast_value"), true];
   _duration setOvercast _value_overcast;
};


// ##################################################
// ################### Gusts ######################## 

if ((_hashMap getOrDefault ["change_gusts", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(previous) set ["change_gusts", 1];
   GVAR(previous) set ["gusts_value", gusts];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   // execute Changes
   _duration setGusts _value;
};


// ##################################################
// ################### Waves ######################## 

if ((_hashMap getOrDefault ["change_waves", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(previous) set ["change_gusts", 1];
   GVAR(previous) set ["waves_value", waves];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];

   // execute Changes
   _duration setWaves _value;
};




// ##################################################
// ################### Lightnings ################### 


if ((_hashMap getOrDefault ["change_lightnings", 0]) > 0) then {

if (_firstWeatherChange) then {
   // Save Current
   GVAR(previous) set ["change_lightnings", 1];
   GVAR(previous) set ["lightnings_value", lightnings];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "lightnings_value", true];
   // execute Changes
   _duration setLightnings _value;
};

// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

if ((_hashMap getOrDefault ["change_rainParams", 0]) > 0) then {

      // Store previous rain Parms
   if (_firstWeatherChange) then {
      GVAR(previous) set ["change_rainParams", 1];
      GVAR(previous) set ["RainParams", rainParams];
      // Store previous rainValue if rain changes
      if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then { 
         GVAR(previous) set ["change_rainValue", 1];
         GVAR(previous) set ["rain_value", rain];
      };
   };


   //retrieve RainParms Value and Rain Value with Intensity
   _rainParams = [ _hashMap get "rainParams" ] call cvo_storm_fnc_weather_get_rainParams_as_Array;
   _valueRain = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true ];

   // remove the rain to create a no-rain period to change rainParams
   ( _duration / 3 ) setRain 0;

    // Apply new Rain Parameters during "noRain" period
   [ { _this call BIS_fnc_setRain; }, _rainParams, ( _duration * 1/2 ) ] call CBA_fnc_waitAndExecute;

    // setRain during the last third of the transition, only if needed. 
   if ( (_hashMap getOrDefault ["change_rainValue", 0] > 0 )  && (_valueRain > 0) ) then { 
      [{
         params ["_duration", "_value"];
         (_duration * 1/3) setRain _value;
      }, [_duration,_valueRain],    _duration * 2/3] call CBA_fnc_waitAndExecute;
   };
} else {

   // Set Rain only
   if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then {

   // Save Current
   if (_firstWeatherChange) then {
      GVAR(previous) set ["change_rainValue", 1];
      GVAR(previous) set ["rain_value", rain];
   };

      // apply Intensity
      _value = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
   };
};


// ##################################################
// ################### fog params ################### 

if ((_hashMap getOrDefault ["change_fog", 0]) > 0) then {
  if (_firstWeatherChange) then {
 // Save Current
   GVAR(previous) set ["change_fog", 1];
   GVAR(previous) set ["fogParams", fogParams];
   };


 // Establish _fog_target for the Transition
   private ["_fog_target", "_fog_Mode"];
   switch (_intensity) do {
      case 0: {
         // Handles reset 
         _fog_target = _hashMap getOrDefault ["fogParams", [0,0,0]];
         _fog_Mode = 0;
      };
      default {
         _fog_target = [];
         _fog_target set [0, ( linearConversion [0,1,_intensity, _hashMap get "fog_value_min",_hashMap get "fog_value_max", true] )];
         _fog_target set [1,_hashMap get "fog_dispersion"];
         _fog_target set [2,_hashMap get "fog_base"];
         _fog_Mode = _hashMap getOrDefault ["fog_mode", 0];
      };
   };

 // Executes Transition based on Mode
   switch (_fog_Mode) do {
      case 0: {
         // No fogBase via AvgASL needed. Terminate perFrameHandler if active.
         if (!isNil QGVAR(fogParams)) then {GVAR(fogParams) = nil};
         _duration setFog _fog_target;
      };
      default {
         // fogBase via AvgASL requested.
         [_fog_target, _duration] call cvo_Storm_fnc_weather_setFog_avg;

         // If fogBase via AvgASL is requested only during initial Tranistion, (Mode=1), perFrameHandler will be terminated after transition.
         _isContinous = [false, true] select (_fog_Mode - 1);
         if (!_isContinous) then { [ { GVAR(fogParams) = nil; } , [], _duration] call CBA_fnc_waitAndExecute;};
      };
   };
};

// ##################################################
// ################### wind vector ################## 

if ((_hashMap getOrDefault ["change_wind",0]) > 0) then {


   if (_firstWeatherChange) then {
      // Save Current
      GVAR(previous) set ["change_wind", 1];
      GVAR(previous) set ["wind_value", vectorMagnitude wind];

      missionNamespace setVariable ["ace_weather_disableWindSimulation", true];
   };

   // get Value + Intensity
   _target_magnitude = linearConversion[0,1,_intensity,0,_hashMap get "wind_value",true];

   // Start "recursive", finite  transition.

   _forceWindEnd = switch (_hashMap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration, _forceWindEnd] call cvo_storm_fnc_weather_setWind;

   if (_intensity == 0) then {
      [ { missionNamespace setVariable ["ace_weather_disableWindSimulation", nil]; } , [], _duration] call CBA_fnc_waitAndExecute;
   };
};

// ##########################################################
// ##########################################################


private _code = switch (_intensity) do {
   case 0: {{
      GVAR(previous) = nil;

      GVAR(isActiveTransition) = false;

      ZRN_LOG_MSG(Transition Complete & previous weather has been restored);
    }};
   default {{
      GVAR(isActiveTransition) = false;

      ZRN_LOG_MSG(Transition Complete);
    }};
};

[ _code , [], _duration ] call CBA_fnc_waitAndExecute;

true