/*
 * Author: Zorn
 * Creates, Adjusts and ppEffects over time with intensity. 
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
 * ["CVO_CC_Alias", 5, 0.5] call cvo_storm_fnc_ppEffect_request;
 * 
 * Public: No
 */

// diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) - Start : %1", _this];

 params [
    ["_PP_effect_Name", "", [""]],
    ["_duration",       0, [0]],
    ["_intensity",      0, [0]]
 ];

if (_PP_effect_Name isEqualTo "") exitWith {false};
if (_duration <= 0              ) exitWith {false};
if (_intensity <= 0             ) exitWith {false};

//Check if config Exists
if !(_PP_effect_Name in (configProperties [configFile >> "CVO_PP_Effects", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_request) - provided PP_Effect_name doesnt exist: %1", _PP_effect_Name];
    false
};

private _configPath = (configFile >> "CVO_PP_Effects" >> _PP_effect_Name ); 
private _ppEffectType = getText (_configPath >> "ppEffectType");
private _layer = getNumber (_configPath >> "layer");

// Check when _intensity == 0, is there previous effect that can be reverted to 0? If not, Fail
private _jip_handle_string = ["CVO_STORM",_ppEffectType, _layer,"PP_Effect_JIP_Handle" ] joinString "_";
if ( _intensity == 0 && { isNil "CVO_Storm_Active_JIP_Array" || { !(_jip_handle_string in CVO_Storm_Active_JIP_Array)} } ) exitWith {   diag_log "[CVO](STORM)(fn_ppEffect_request) Failed: _intensity 0 while no previous effect of same type exists"; };


// Adjusts Duration to secounds.
_duration = _duration * 60;
// diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) - _duration: %1", _duration];

private _effectArray = [_PP_effect_Name] call cvo_storm_fnc_ppEffect_get_from_config;

private "_resultArray";

// Check if given Class is Default (Parent)
if (configName inheritsFrom _configPath isEqualTo "") then {

    // Default Class -> ignore Intensity
    // diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) - : %1", _effectArray];
    _resultArray = _effectArray;

} else {

    // Non Default Class -> Apply Intensity based of _effectArray and _baseArray (Parent: Default)
    private   _baseArray = getArray (_configPath >> "baseArray");

    if (_effectArray isEqualTo false) exitWith {false};
    if !( _baseArray isEqualType [] ) exitWith {false};

    //  diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) - _effectArray: %1 // %2", _effectArray, count _effectArray];
    //  diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) -   _baseArray: %1 // %2", _baseArray, count _baseArray];

    _resultArray = [_effectArray, _intensity, _baseArray] call cvo_storm_fnc_ppEffect_convert_intensity;

};

diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_request) - _resultArray: %1", _resultArray];


private _jip_handle_string = [_PP_effect_Name, _resultArray, _duration, _intensity] remoteExecCall ["cvo_storm_fnc_ppEffect_remote",0, _jip_handle_string];

if (isNil "_jip_handle_string") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_request) - Not Successful: %1", _PP_effect_Name];
    false
};

// diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_request) - Success: _PP_effect_Name %1 - _duration %2 - _intensity %3", _PP_effect_Name, _duration, _intensity];
// diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_request) - Success: _PP_effect_Name %1", _PP_effect_Name];

if (_intensity == 0) then {
    // Handles Cleanup of JIP in case of decaying(transition-> 0) Effect once transition to 0 is completed.
    [{
        CVO_Storm_Active_JIP_Array = CVO_Storm_Active_JIP_Array - [_this#0];
        remoteExec ["", _this#0]; // removes entry from JIP Queue
    }, [_jip_handle_string], _duration] call CBA_fnc_waitAndExecute;

    "";
} else {
    if (isNil "CVO_Storm_Active_JIP_Array") then {
        CVO_Storm_Active_JIP_Array = [];
    };
    CVO_Storm_Active_JIP_Array pushBackUnique _jip_handle_string;

    _jip_handle_string
};




