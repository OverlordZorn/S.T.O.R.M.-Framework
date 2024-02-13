/*
 * Author: [Zorn]
 * Function to apply the PPEffects on each client locally.
 *
 * Arguments:
 * 0: _EffectName  <STRING> of configClassname of the desired effect. 
 * 0: _duration    <NUMBER> in secounds - effect Commit Time in Seconds
 * 1: _effectArray <Array> 
 *
 * Return Value:
 * none - intended to be remoteExecCall -> returns JIP Handle
 *
 * Note: 
 *
 * Example:
 * [_effectArray, _duration] remoteExecCall ["cvo_storm_fnc_remote_ppEffect",0, "CVO_Storm_CC_PP_Effect_JIP_Handle" ];
 * 
 * Public: No
 */


if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_effectArray", [], [[]]],
    ["_duration",     5, [0]]
];

if (_effectArray isEqualTo []) exitWith {};

_ppEffectType = getText   (configFile >> "CVO_PP_Effects" >> _effectName >> "ppEffectType");
_ppEffectPrio = getNumber (configFile >> "CVO_PP_Effects" >> _effectName >> "ppEffectPrio");



if (isNil "CVO_Storm_Active_PP_Effects_Array") then {
    CVO_Storm_Active_PP_Effects_Array = [];
};


// Defines custom Variablename as String
private _varName = ["CVO_Storm_",_ppEffectType,"_PP_Effect_Handle"] joinString "";


// Creates the custom Variable if it doesnt exist yet
_existsVar = missionNamespace getVariable [_varName, false];

if (_existsVar == false) then {
    missionNamespace setVariable [_varName, (ppEffectCreate [_ppEffectType, _ppEffectPrio]) ];

    // adds the name of the variable as a string to the array  
    CVO_Storm_Active_PP_Effects_Array pushback _varName;

    (missionNamespace getVariable _varname) ppEffectEnable true;
};

/* old
if (isNil "CVO_Storm_CC_PP_Effect_Handle") then {
    CVO_Storm_CC_PP_Effect_Handle = ppEffectCreate [_ppEffectType, _ppEffectPrio];
};
*/

// Apply the effects based the custom variable
(missionNamespace getVariable _varname) ppEffectAdjust _effectArray;
(missionNamespace getVariable _varname) ppEffectCommit _duration;


