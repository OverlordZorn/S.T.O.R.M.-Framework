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


if (!isServer) exitWith { _this remoteExecCall [ "CVO_STORM_fnc_weather_request", 2, false]; };


params [
   ["_weather_preset_name",    "", [""]],
   ["_duration",               5,  [0]],
   ["_intensity",             0,  [0]]
];

// Check: transition currently?
if ( missionNamespace getVariable ["CVO_WeatherChanges_active", false] ) exitWith { diag_log "[CVO](STORM)(fn_weather_request) Request failed: Weather Transition already taking place"; false };

// check: Can reset?
if ( _intensity == 0 && isNil "CVO_Storm_weather_previous" ) exitWith { diag_log "[CVO](STORM)(fn_weather_request) Request Failed: _intensity 0 -> Reset while no change of weather exists"; false };

if (_intensity == 0) then {   _weather_preset_name = "Reset";  };

// Check: No Preset?
if (_weather_preset_name isEqualTo "")    exitWith { diag_log "[CVO](debug)(fn_weather_request) Request Failed: Weather PresetName = "" "; false };


_duration = 60 * _duration max 1;
_intensity = _intensity max 0 min 1;


if (isNil "CVO_WeatherChanges_active") then {   CVO_WeatherChanges_active = true;   };



private _hashMap = switch (_intensity) do {
   case 0: { + CVO_Storm_weather_previous };
   default { [_weather_preset_name] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash; };
};

// get hashMap, check if its "false", if not, store _hashMap
if (_hashMap isEqualTo false) exitWith {   diag_log format ["[CVO][STORM](Weather_request)(Error) - get_WeatherPreset_as_Hash returned False: %1", _hashMap]; };

diag_log format ["[CVO][STORM](Weather_request) Weather sucessfully Requested: %1 - _duration: %2 - _intensity: %3", _weather_preset_name, _duration, _intensity];
diag_log format ["[CVO][STORM](Weather_request) hashmap: %1", _hashMap];


private _firstWeatherChange = isNil "CVO_Storm_weather_previous";

if (_firstWeatherChange) then {
   CVO_Storm_weather_previous = createHashMap;
};



// ##########################################################
// ################### FREEZE CURRENT ####################### 

/*
0 setOvercast     overcast;
0 setRain         rain;
0 setLightnings   lightnings;
0 setFog          fogParams;
  setWind         [wind#0, wind#1, true];
0 setGusts        gusts;
0 setWaves        waves;
forceWeatherChange;

diag_log "[CVO](debug)(fn_weather_request) Freeze Current Weather Done";
*/

// ##########################################################
// ################### OVERCAST ############################# 

if ((_hashMap getOrDefault ["change_overcast",0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Overcast Requested";


if (_firstWeatherChange) then {
   // Save Current
   CVO_Storm_weather_previous set ["change_overcast", 1];
   CVO_Storm_weather_previous set ["overcast_value", overcast];
};

//   diag_log format ["[CVO][STORM](Weather_request) - overcast_value: %1", _hashMap get "overcast_value"];

   // apply new
   _value_overcast = linearConversion [   0,    1, _intensity, 0, (_hashMap get "overcast_value"), true];
   _duration setOvercast _value_overcast;

   diag_log "[CVO](debug)(fn_weather_request) Set Overcast Done";
};


// ##################################################
// ################### Gusts ######################## 

if ((_hashMap getOrDefault ["change_gusts", 0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Gust Done";

if (_firstWeatherChange) then {
   // Save Current
   CVO_Storm_weather_previous set ["change_gusts", 1];
   CVO_Storm_weather_previous set ["gusts_value", gusts];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "gusts_value", true];
   // execute Changes
   _duration setGusts _value;
   diag_log "[CVO](debug)(fn_weather_request) Set Gust Done";
};


// ##################################################
// ################### Waves ######################## 

if ((_hashMap getOrDefault ["change_waves", 0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Waves Requested";

if (_firstWeatherChange) then {
   // Save Current
   CVO_Storm_weather_previous set ["change_gusts", 1];
   CVO_Storm_weather_previous set ["waves_value", waves];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0 ,_hashMap get "waves_value", true];
   // execute Changes
   _duration setWaves _value;
   diag_log "[CVO](debug)(fn_weather_request) Set Waves Done ";
};




// ##################################################
// ################### Lightnings ################### 


if ((_hashMap getOrDefault ["change_lightnings", 0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Lightning Requested";

if (_firstWeatherChange) then {
   // Save Current
   CVO_Storm_weather_previous set ["change_lightnings", 1];
   CVO_Storm_weather_previous set ["lightnings_value", lightnings];
};

   // apply Intensity
   _value = linearConversion [   0,    1, _intensity, 0, _hashMap get "lightnings_value", true];
   // execute Changes
   _duration setLightnings _value;
   diag_log "[CVO](debug)(fn_weather_request) Set Lightning Done ";
};

// ##########################################################
// ################### RAIN & RAIN PARAMS ################### 

// use this for Set rainParameters
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]

if ((_hashMap getOrDefault ["change_rainParams", 0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Rain Requested - RainParams: true ";

   if (_firstWeatherChange) then {
      // Store previous rain Parms
      CVO_Storm_weather_previous set ["change_rainParams", 1];
      CVO_Storm_weather_previous set ["RainParams", rainParams];
      // Store previous rainValue if rain changes
      if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then { 
         CVO_Storm_weather_previous set ["change_rainValue", 1];
         CVO_Storm_weather_previous set ["rain_value", rain];
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
   diag_log "[CVO](debug)(fn_weather_request) Set Rain Done - RainParams: true ";
} else {
   diag_log "[CVO](debug)(fn_weather_request) Set Rain Requested";
   // Set Rain only
   if ((_hashMap getOrDefault ["change_rainValue", 0]) > 0) then {

   if (_firstWeatherChange) then {
      // Save Current
      CVO_Storm_weather_previous set ["change_rainValue", 1];
      CVO_Storm_weather_previous set ["rain_value", rain];
   };

      diag_log format ["[CVO][STORM](Weather_request) reee - _hashMap get ""rain_value"": %1 - _duration: %2- _intensity: %3", (_hashMap get "rain_value"), _duration, _intensity];

      // apply Intensity
      _value = linearConversion [ 0, 1, _intensity, 0, _hashMap get "rain_value", true];
      // execute Changes
      _duration setRain _value;
   diag_log "[CVO](debug)(fn_weather_request) Set Rain Done";
   };
};


// ##################################################
// ################### fog params ################### 

if ((_hashMap getOrDefault ["change_fog", 0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Fog Requested";
  if (_firstWeatherChange) then {
 // Save Current
   CVO_Storm_weather_previous set ["change_fog", 1];
   CVO_Storm_weather_previous set ["fogParams", fogParams];
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
   diag_log format ['[CVO](debug)(fn_weather_request) _intensity: %1 - _fog_target: %2 - _fog_Mode: %3', _intensity , _fog_target ,_fog_Mode];

 // Executes Transition based on Mode
   switch (_fog_Mode) do {
      case 0: {
         // No fogBase via AvgASL needed. Terminate perFrameHandler if active.
         if (!isNil "CVO_Storm_fogParams") then {CVO_Storm_fogParams = nil};
         _duration setFog _fog_target;
         diag_log "[CVO](debug)(fn_weather_request) FogMode 0 Requested.";
      };
      default {
         // fogBase via AvgASL requested.
         [_fog_target, _duration] call cvo_Storm_fnc_weather_setFog_avg;
         diag_log format ['[CVO](debug)(fn_weather_request) cvo_storm_fnc_weather_setFog_avg called # _fog_target: %1 - _duration: %2', _fog_target , _duration];
         // If fogBase via AvgASL is requested only during initial Tranistion, (Mode=1), perFrameHandler will be terminated after transition.
         _isContinous = [false, true] select (_fog_Mode - 1);
         if (!_isContinous) then { [ { CVO_Storm_fogParams = nil; } , [], _duration] call CBA_fnc_waitAndExecute;};
      };
   };
};

// ##################################################
// ################### wind vector ################## 

if ((_hashMap getOrDefault ["change_wind",0]) > 0) then {
   diag_log "[CVO](debug)(fn_weather_request) Set Wind Requested";


   if (_firstWeatherChange) then {
      // Save Current
      CVO_Storm_weather_previous set ["change_wind", 1];
      CVO_Storm_weather_previous set ["wind_value", vectorMagnitude wind];

      missionNamespace setVariable ["ace_weather_disableWindSimulation", true];
   };

   // get Value + Intensity
   _target_magnitude = linearConversion[0,1,_intensity,0,_hashMap get "wind_value",true];

   diag_log format ['[CVO](debug)(fn_weather_request) _target_magnitude: %1', _target_magnitude];
   // Start "recursive", finite  transition.

   _forceWindEnd = switch (_hashMap get "forceWindEnd") do {
      case 1: { true };
      default { false};
   };
   
   [_target_magnitude, _duration, _forceWindEnd] call cvo_storm_fnc_weather_setWind;
   diag_log "[CVO](debug)(fn_weather_request) Set Wind Done";

   if (_intensity == 0) then {
      [ { missionNamespace setVariable ["ace_weather_disableWindSimulation", nil]; } , [], _duration] call CBA_fnc_waitAndExecute;
   };
};

// ##########################################################
// ##########################################################


private _code = switch (_intensity) do {
   case 0: {{
      CVO_Storm_weather_previous = nil;

      CVO_WeatherChanges_active = false;
      Diag_log "[CVO](debug)(fn_weather_request) Transition Complete";
    }};
   default {{
      CVO_WeatherChanges_active = false;
      Diag_log "[CVO](debug)(fn_weather_request) Transition Complete";
    }};
};

[ _code , [], _duration ] call CBA_fnc_waitAndExecute;