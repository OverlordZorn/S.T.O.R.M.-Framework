/*
 * Author: Zorn
 * Creates, Adjusts and Commits Color Correction ppEffect over time with intensity. 
 *
 * Arguments:
 * 0: _CC_effectName    <STRING> Name of Color Correction Post Process Preset - Capitalisation needs to be exact!
 * 1: _duration         <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity        <NUMBER> 0..1 Factor of Intensity for the CC PP Effect 
 *
 * Return Value:
 * _cc_pp_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_CC_Alias", 5, 0.5] call cvo_storm_fnc_cc_apply_ppEffect;
 * 
 * Public: No
 */

diag_log format ["[CVO][STORM](LOG)(fnc_cc_apply_ppEffect) - Start : %1", _this];

 params [
    ["_CC_effectName", "", [""]],
    ["_duration",       0, [0]],
    ["_intensity",      0, [0]]
 ];

if (_CC_effectName isEqualTo "" ) exitWith {false};
if (_duration <= 0              ) exitWith {false};
if (_intensity <= 0             ) exitWith {false};



// Adjusts Duration to secounds.
_duration = _duration * 60;

diag_log format ["[CVO][STORM](LOG)(fnc_cc_apply_ppEffect) - _duration: %1", _duration];


// Apply Intensity Modifier on Preset
// on RGB Arrays, Modifier is applied on the Alpha Channel only.

private _effectArray = [_CC_effectName] call cvo_storm_fnc_cc_get_from_config;

if (_effectArray isEqualTo false) exitWith {false};

diag_log format ["[CVO][STORM](LOG)(fnc_cc_apply_ppEffect) - _effectArray: %1", _effectArray];


private _applyArray = [     // Index, Default Value
    [0,1],                  //brightness
    [1,1],                  // contrast
    [2,0],                  // offset
    [3,0],                  // blending RGBA
    [4,1],                  // colorization RGBA
    [5,0]                   // Desaturation RGB0
];


// Default + (Default - Target) * _intensity

{
    _x params ["_index", "_default"];
    private _target = _effectArray select _index;
    
    private _isArray = [false,true] select (_target isEqualType []);
    
    if (_isArray) then {  _target = _target select 3; };

    diag_log format ["_default: %1 - _target: %2 - _intensity: %3", _default, _target, _intensity];


    private _newValue = _default + (_Default - _target ) * _intensity;

    diag_log format ["new Value: %1 - isArray: %2", _newValue, _isArray];

    if (_isArray) then {
        _newSubArray = (_effectArray select _index);
        _newSubArray set [3, _newValue];
        _newValue = _newSubArray; 

        diag_log format ["Post _subArray",""];
        diag_log format ["new Value: %1 - isArray: %2", _newValue, _isArray];
    };

    _effectArray set [_index, _newValue];

} forEach _applyArray;

diag_log format ["[CVO][STORM](LOG)(fnc_cc_apply_ppEffect) - _effectArray: %1", _effectArray];


_cc_pp_effect_JIP_handle = [_CC_effectName, _effectArray, _duration] remoteExecCall ["cvo_storm_fnc_cc_remote_ppEffect",0, "CVO_Storm_CC_PP_Effect_JIP_Handle"];

if (isNil "_cc_pp_effect_JIP_handle") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_cc_apply_ppEffect) - Not Successful: %1", _CC_effectName];
};
diag_log format ["[CVO][STORM](Error)(fnc_cc_apply_ppEffect) - Success: _CC_effectName %1 - _duration %2 - _intensity %3", _CC_effectName, _duration, _intensity];

_cc_pp_effect_JIP_handle