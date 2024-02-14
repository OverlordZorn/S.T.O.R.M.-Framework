/*
 * Author: Zorn
 * Creates, Adjusts and Commits Color Correction ppEffect over time with intensity. 
 *
 * Arguments:
 * 0: _PP_effect_Name    <STRING> Name of Post Process Preset - Capitalisation needs to be exact!
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

diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) - Start : %1", _this];

 params [
    ["_PP_effect_Name", "", [""]],
    ["_duration",       0, [0]],
    ["_intensity",      0, [0]]
 ];

if (_PP_effect_Name isEqualTo "") exitWith {false};
if (_duration <= 0              ) exitWith {false};
if (_intensity <= 0             ) exitWith {false};


private _configPath = (configFile >> "CVO_PP_Effects" >> _PP_effect_Name ); 
private _ppEffectType = getText (_configPath >> "ppEffectType");
private _layer = getText (_configPath >> "layer");



// Adjusts Duration to secounds.
_duration = _duration * 60;
// diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) - _duration: %1", _duration];

private _effectArray = [_PP_effect_Name] call cvo_storm_fnc_get_from_config;

private "_resultArray";

// Check if given Class is Default (Parent)
if (configName inheritsFrom _configPath isEqualTo "") then {

    // Default Class -> ignore Intensity
    // diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) - : %1", _effectArray];
    _resultArray = _effectArray;

} else {

    // Non Default Class -> Apply Intensity based of _effectArray and _baseArray (Parent: Default)
    private   _baseArray = [configName inheritsFrom _configPath] call cvo_storm_fnc_get_from_config;

    if (_effectArray isEqualTo false) exitWith {false};
    if (  _baseArray isEqualTo false) exitWith {false};

    //  diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) - _effectArray: %1 // %2", _effectArray, count _effectArray];
    //  diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) -   _baseArray: %1 // %2", _baseArray, count _baseArray];

    _resultArray = [_effectArray, _intensity, _baseArray] call cvo_storm_fnc_convert_intensity;

};


diag_log format ["[CVO][STORM](LOG)(fnc_apply_ppEffect) - _resultArray: %1", _resultArray];

_jip_handle_string = ["CVO_STORM",_ppEffectType, _layer,"PP_Effect_JIP_Handle" ] joinString "_";

_pp_effect_JIP_handle = [_PP_effect_Name, _resultArray, _duration] remoteExecCall ["cvo_storm_fnc_remote_ppEffect",0, _jip_handle_string];

if (isNil "_pp_effect_JIP_handle") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_apply_ppEffect) - Not Successful: %1", _PP_effect_Name];
};

diag_log format ["[CVO][STORM](Error)(fnc_apply_ppEffect) - Success: _PP_effect_Name %1 - _duration %2 - _intensity %3", _PP_effect_Name, _duration, _intensity];

if (isNil "CVO_Storm_Active_JIP_Array") then {
    CVO_Storm_Active_JIP_Array = [];
};
CVO_Storm_Active_JIP_Array pushback _jip_handle_string;

_pp_effect_JIP_handle