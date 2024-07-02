#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Creates, Adjusts and ppEffects over time with intensity. 
 *
 * Arguments:
 * 0: _presetName    <STRING> Name of Post Process Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * boolean - true if success, else false
 *
 * Example:
 * ["CVO_CC_Alias", 5, 0.5] call storm_fx_post_fnc_request;
 * 
 * Public: No
  *
 * GVARS
 *
 */

params [
    ["_presetName",     "", [""]],
    ["_duration",       1,  [0] ],
    ["_intensity",      0,  [0] ]
];

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

ZRN_LOG_MSG_3(INIT,_presetName,_duration,_intensity);


if  (_presetName isEqualTo "")                                                                               exitWith { ZRN_LOG_MSG(failed: effectName not provided); false};
if !(_presetName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found); false};

private _cfg = (configFile >> QGVAR(Presets) >> _presetName );
private _ppType = getText(_cfg >> "ppEffectType");
private _ppEffectLayer = getNumber(_cfg >> "ppEffectLayer");
private _jipHandle = [QADDON, _ppType, getNumber(_cfg >> "ppEffectLayer") ] joinString "_";  // dedicated jipHandle needed due to the nature of postEffects. There can be multiple of the same type, but they have to on seperate layers. jipHandle based on effectName is not enough. 


// Adjust Basic CC Effects for minimum Intensity
if (
        (_ppType == "ColorCorrections") &&
        {_ppEffectLayer == 0}
    ) then {
    _intensity = _intensity max 0.5;
};


// Check fail when _intensity == 0 while no Prev effect
if ( _intensity == 0 && { !( [_jipHandle] call PFUNC(jipExists) ) } ) exitWith {   ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };

private "_resultArray";
private _effectArray = [_presetName] call FUNC(getConfig);


// Check if given Class is Default (Parent)
if (configName inheritsFrom _cfg isEqualTo "") then {

    // i dont remember why i made this but i guess it has a reason lol
    // Default Class -> ignore Intensity
    _resultArray = _effectArray;
} else {

    // Non Default Class -> Apply Intensity based of _effectArray and _baseArray (Parent: Default)
    private   _baseArray = getArray (_cfg >> "baseArray");

    if (_effectArray isEqualTo false) exitWith {false};
    if !( _baseArray isEqualType [] ) exitWith {false};

    _resultArray = [_effectArray, _intensity, _baseArray] call FUNC(convertIntensity);
};


// RemoteExec the request
private _jipHandle = [_presetName, _resultArray, _duration, _intensity] remoteExecCall [QFUNC(remote), [0,-2] select isDedicated, _jipHandle];
if (isNil "_jipHandle") exitWith { ZRN_LOG_MSG(failed: remoteExec failed);    false };


// handoff _jipHandle to jipMonitor
private _expiry = -1;
if (_intensity == 0) then { _expiry = CBA_MissionTime + _duration; };
[_expiry, _jipHandle] call PFUNC(jipMonitor);

ZRN_LOG_MSG(request successful);
true