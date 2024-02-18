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
 * none - intended to be remoteExecCall -> returns JIP Handle
 *
 * Note: 
 *
 * Example:
 * [_storm_preset_name, _duration, _intensity] call cvo_storm_fnc_storm_apply;
 * 
 * Public: No
 */


 if (isNil "CVO_Storm_isActive") then {
    CVO_Storm_isActive = true;
    publicVariable "CVO_Storm_isActive";
 };

 