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
 * _pp_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_CC_Alias", 5, 0.5] call storm_fxPost_fnc_request;
 * 
 * Public: No
  *
 * GVARS
 *      GVAR(S_activeJIPs) set [_jipHandle, inTransition]
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
if !(_presetName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found);    false};

private _configPath = (configFile >> QGVAR(Presets) >> _presetName ); 
private _jipHandle = [ ADDON, getText(_configPath >> "ppEffectType"), getNumber(_configPath >> "layer") ] joinString "_";  // dedicated jipHandle needed due to the nature of postEffects. There can be multiple of the same type, but they have to on seperate layers. jipHandle based on effectName is not enough. 

// Check fail when _intensity == 0 while no Prev effect
if ( _intensity == 0 && { isNil QGVAR(S_activeJIPs) || { !(_jipHandle in GVAR(S_activeJIPs))} } ) exitWith {   ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };

if (isNil QGVAR(S_activeJIPs)) then {
    GVAR(S_activeJIPs) = createHashMap;
} else {
    if ( GVAR(S_activeJIPs) getOrDefault [_jipHandle, false] ) exitWith { ZRN_LOG_MSG(failed: This Type and Layer is currently in Transition!); false };
};


private "_resultArray";
private _effectArray = [_presetName] call FUNC(getConfig);


// Check if given Class is Default (Parent)
if (configName inheritsFrom _configPath isEqualTo "") then {

    // i dont remember why i made this but i guess it has a reason lol
    // Default Class -> ignore Intensity
    _resultArray = _effectArray;
} else {

    // Non Default Class -> Apply Intensity based of _effectArray and _baseArray (Parent: Default)
    private   _baseArray = getArray (_configPath >> "baseArray");

    if (_effectArray isEqualTo false) exitWith {false};
    if !( _baseArray isEqualType [] ) exitWith {false};

    _resultArray = [_effectArray, _intensity, _baseArray] call FUNC(convertIntensity);

};

/////////////////////////////////////////////////////////////////////////////
// RemoteExec the request

private _jipHandle = [_presetName, _resultArray, _duration, _intensity] remoteExecCall [QFUNC(remote), [0,2] select isDedicated, _jipHandle];
if (isNil "_jipHandle") exitWith { ZRN_LOG_MSG(failed: remoteExec failed);    false };

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

// Sets Transition to false post Transition
[{ GVAR(S_activeJIPs) set [_this#0, false]; }, [_jipHandle], _duration] call CBA_fnc_waitAndExecute;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

// Handles Cleanup of JIP in case of decaying(transition-> 0) Effect once transition to 0 is completed.
if (_intensity == 0) then {
    [{
        remoteExec ["", _this#0];
        GVAR(S_activeJIPs) deleteAt (_this#0);
        if (count GVAR(S_activeJIPs) isEqualTo 0) then { GVAR(S_activeJIPs) = nil; };
    }, [_jipHandle], _duration] call CBA_fnc_waitAndExecute;

} else {
    // true for _inTransition;
    GVAR(S_activeJIPs) set [_jipHandle, true];
};

ZRN_LOG_MSG_1(completed!,_presetName);
true
