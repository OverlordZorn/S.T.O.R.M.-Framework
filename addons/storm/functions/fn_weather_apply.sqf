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

 
// Adjusts Duration to secounds.
_duration = _duration * 60;



_return = ["_weather_preset_name"] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash;
_return params ["_hashMap", "_properties"];






// use this for Set rain
// [_rainParams] remoteExecCall ["BIS_fnc_setRain",2]