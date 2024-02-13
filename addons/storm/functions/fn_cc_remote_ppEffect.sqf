/*
 * Author: [Zorn]
 * Function to apply the CC PPEffects on each client locally.
 *
 * Arguments:
 * 0: _duration    <NUMBER> in secounds - Time for the effect to be commited over!
 * 1: _effectArray <Array> 
 *
 * Return Value:
 * 
 * _
 *
 * Note: 
 *
 * Example:
 * [_effectArray, _duration] remoteExecCall ["cvo_storm_fnc_cc_remote_ppEffect",0, "CVO_Storm_CC_PP_Effect_JIP_Handle" ];
 * 
 * Public: No
 */


if (!hasInterface) exitWith {};

params [
    ["_CC_effectName",  "", [""]],
    ["_effectArray",    [], [[]]],
    ["_duration",        5, [0]]
];

if (_effectArray isEqualTo []) exitWith {};

_ppEffectType = getText   (configFile >> "CVO_PP_Effects" >> _CC_effectName >> "ppEffectType");
_ppEffectPrio = getNumber (configFile >> "CVO_PP_Effects" >> _CC_effectName >> "ppEffectPrio");

if (isNil "CVO_Storm_CC_PP_Effect_Handle") then {
    CVO_Storm_CC_PP_Effect_Handle = ppEffectCreate [_ppEffectType, _ppEffectPrio];
};


CVO_Storm_CC_PP_Effect_Handle ppEffectEnable true;
CVO_Storm_CC_PP_Effect_Handle ppEffectAdjust _effectArray;
CVO_Storm_CC_PP_Effect_Handle ppEffectCommit _duration;
