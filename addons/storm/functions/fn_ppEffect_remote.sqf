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
 * [_effectArray, _duration] remoteExecCall ["cvo_storm_fnc_ppEffect_remote",0, "CVO_Storm_CC_PP_Effect_JIP_Handle" ];
 * 
 * Public: No
 */


if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_effectArray", [], [[]]],
    ["_duration",     5, [0]],
    ["_intensity",    0, [0]]
];

if (_effectArray isEqualTo []) exitWith {};

private _ppEffectType = getText   (configFile >> "CVO_PP_Effects" >> _effectName >> "ppEffectType");
private _ppEffectPrio = getNumber (configFile >> "CVO_PP_Effects" >> _effectName >> "ppEffectPrio");
private _layer        = getNumber (configFile >> "CVO_PP_Effects" >> _effectName >> "layer");


if (isNil "CVO_Storm_Active_PP_Effects_Array") then {
    CVO_Storm_Active_PP_Effects_Array = [];
};


// Defines custom Variablename as String 
// missionNameSpace has only lowercase letters
private _varName = toLower (["CVO_Storm_",_ppEffectType,"_",_layer,"_PP_Effect_Handle"] joinString "");

// diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _varName : %1", _varName];

// Creates the custom Variable if it doesnt exist yet
_existsVar = missionNamespace getVariable [_varName, false];

// diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _existsVar : %1", _existsVar];

if (_existsVar isEqualto false && {_intensity == 0} ) exitWith {};

if (_existsVar isEqualto false) then {
    missionNamespace setVariable [_varName, (ppEffectCreate [_ppEffectType, _ppEffectPrio]) ];

    // adds the name of the variable as a string to the array  
    CVO_Storm_Active_PP_Effects_Array pushback _varName;

    (missionNamespace getVariable _varname) ppEffectEnable true;
};

// Apply the effects based the custom variable
(missionNamespace getVariable _varname) ppEffectAdjust _effectArray;
(missionNamespace getVariable _varname) ppEffectCommit _duration;

if (_intensity == 0) then {
    [ {
        ppEffectDestroy (missionNamespace getVariable _this#0);
        if (count CVO_Storm_Active_PP_Effects_Array == 0) then { CVO_Storm_Active_PP_Effects_Array = nil; };
     }, [_varName], _duration] call CBA_fnc_waitAndExecute;
};