/*
 * Author: [Zorn]
 * Extracts Color Correction Parameters from Config Class in suitable format for ppEffectAdjust command.
 *
 * Arguments:
 * 0: _CC_effectName    <STRING> Name of Color Correction Post Process Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * effect-array for ppEffectAdjust
 *
 * Note: 
 *
 * Example:
 * ["CVO_CC_Default"] call cvo_storm_fnc_cc_get_from_config;
 * 
 * Public: No
 */



params [   ["_CC_effectName", "", [""]]    ];

diag_log format ["[CVO][STORM](LOG)(Fnc_cc_get_from_config) - Start : %1", _this];

//Check if EffectName given
if (_CC_effectName isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_cc_get_from_config) - no classname provided: %1", _CC_effectName];
    false
};

//Check if config Exists
if !(_CC_effectName in (configProperties [configFile >> "CVO_PP_Effects", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_cc_get_from_config) - provided classname doesnt exist: %1", _CC_effectName];
    false
};

private _configPath = (configFile >> "CVO_PP_Effects" >> _CC_effectName ); 

//Check if its a CC Effect
if !(getText (_configPath >> "ppEffectType") isEqualTo "ColorCorrections" ) exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_cc_get_from_config) - classname is not a CC_PPEffect: %1", _CC_effectName];
    false
};

private _effectArray = [];

{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _effectArray set [_forEachIndex,_value];
} forEach [ "brightness", "contrast", "offset", "blending_rgba", "colorization_rgba", "desaturation_rgba0" ];

if (getNumber (_configPath >> "radial_inUse") == 1) then {
    _value = getArray (_configPath >> radial_color);
    _effectArray set [6,_value];
};

diag_log format ["[CVO][STORM](LOG)(Fnc_cc_get_from_config) - success : %1", _effectArray];

_effectArray
