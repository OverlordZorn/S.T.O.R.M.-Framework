#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Extracts Effect Parameters from Config Class in suitable format for ppEffectAdjust command.
 *
 * Arguments:
 * 0: _PP_effect_Name    <STRING> Name of any Post Process Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * effect-array for ppEffectAdjust
 *
 * Note: 
 *
 * Example:
 * [_PP_effect_Nam] call cvo_storm_fnc_get_from_config;
 * [_PP_effect_Name] call FUNC(get_from_config);
 * 
 * Public: No
 *
 * GVARS
 *  NONE
 *
 */



params [   ["_PP_effect_Name", "", [""]]    ];


//Check if EffectName given
if (_PP_effect_Name isEqualTo "") exitWith {
    ZRN_LOG_MSG(failed: presetName not provided);
    false
};

//Check if config Exists
if !(_PP_effect_Name in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith {
    ZRN_LOG_MSG(failed: presetName not found);
    false
};

private _configPath = (configFile >> QGVAR(Presets) >> _PP_effect_Name ); 
private _ppEffectType = getText (_configPath >> "ppEffectType");


private _properties = switch (_ppEffectType) do {
    case "ColorCorrections": {(configProperties [(configFile >> QGVAR(Presets) >> QGVAR(CC_Default) ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","ppEffectLayer", "baseArray"]};
    case "FilmGrain":        {(configProperties [(configFile >> QGVAR(Presets) >> QGVAR(FG_Default) ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","ppEffectLayer", "baseArray"]};
    case "DynamicBlur":      {(configProperties [(configFile >> QGVAR(Presets) >> QGVAR(DB_Default) ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","ppEffectLayer", "baseArray"]};
};

ZRN_LOG_1(_properties);

private _effectArray = [];

// Create effect Array to be exported
{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _effectArray set [_forEachIndex,_value];
} forEach _properties;

ZRN_LOG_1(_effectArray);

_effectArray
