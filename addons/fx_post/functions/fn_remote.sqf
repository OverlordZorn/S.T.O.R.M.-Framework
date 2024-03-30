#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Function to apply the PPEffects on each client locally.
 *
 * Arguments:
 * 0: _EffectName  <STRING> of configClassname of the desired effect. 
 * 1: _duration    <NUMBER> in secounds - effect Commit Time in Seconds
 * 2: _effectArray <Array>
 *
 * Return Value:
 * none - intended to be remoteExecCall -> returns JIP Handle
 *
 * Note: 
 *
 * Example:
 * [_effectArray, _duration] remoteExecCall ["cvo_storm_fnc_ppEffect_remote",[0,2] select isDedicated, "CVO_Storm_CC_PP_Effect_JIP_Handle" ];
 * 
 * Public: No
 *
 * GVARS
 *      GVAR(C_activeEffects) = [.._effectName..]; array of all active effects
 *
 */

if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_effectArray", [], [[]]],
    ["_duration",     5, [0]],
    ["_intensity",    0, [0]]
];

if (_effectArray isEqualTo []) exitWith {};

private _ppEffectType = getText   (configFile >> QGVAR(Presets) >> _effectName >> "ppEffectType");
private _ppEffectPrio = getNumber (configFile >> QGVAR(Presets) >> _effectName >> "ppEffectPrio");
private _layer        = getNumber (configFile >> QGVAR(Presets) >> _effectName >> "layer");


if (isNil QGVAR(C_activeEffects)) then {
    GVAR(C_activeEffects) = [];
};


// Defines custom Variablename as String 
// missionNameSpace has only lowercase letters
private _varName = toLower ([ADDON,_ppEffectType,_layer,handle]joinstring "_");

// diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _varName : %1", _varName];

// Creates the custom Variable if it doesnt exist yet
_existsVar = missionNamespace getVariable [_varName, false];

// diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _existsVar : %1", _existsVar];

if (_existsVar isEqualto false && {_intensity == 0} ) exitWith {};

if (_existsVar isEqualto false) then {
    missionNamespace setVariable [_varName, (ppEffectCreate [_ppEffectType, _ppEffectPrio]) ];

    // adds the name of the variable as a string to the array  
    GVAR(C_activeEffects) pushback _varName;

    (missionNamespace getVariable _varname) ppEffectEnable true;
};

// Apply the effects based the custom variable
(missionNamespace getVariable _varname) ppEffectAdjust _effectArray;
(missionNamespace getVariable _varname) ppEffectCommit _duration;

if (_intensity == 0) then {
    [ {
        ppEffectDestroy (missionNamespace getVariable _this#0);
        if (count GVAR(C_activeEffects) == 0) then { GVAR(C_activeEffects) = nil; };
     }, [_varName], _duration] call CBA_fnc_waitAndExecute;
};