#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Extracts Effect Parameters from Config Class in suitable format for ppEffectAdjust command.
 *
 * Arguments:
 * 0: _presetName    <STRING> Name of any Post Process Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * effect-array for ppEffectAdjust
 *
 * Note: 
 *
 * Example:
 * [_PP_effect_Nam] call cvo_storm_fnc_get_from_config;
 * [_presetName] call FUNC(get_from_config);
 * 
 * Public: No
 *
 * GVARS
 *  NONE
 *
 */



params [   ["_presetName", "", [""]]    ];


//Check if EffectName given
if (_presetName isEqualTo "") exitWith {
    ZRN_LOG_MSG(failed: presetName not provided);
    false
};

private _cfg = (configFile >> QGVAR(Presets) ); 

//Check if config Exists
if !(_presetName in (configProperties [_cfg, "true", true] apply { configName _x })) exitWith {
    ZRN_LOG_MSG(failed: presetName not found);
    false
};

private _ppEffectType = getText (_cfg >> "ppEffectType");

private _remProps = ["ppEffectType","ppEffectPrio","ppEffectLayer", "baseArray"];

private _properties = switch (_ppEffectType) do {
    case "ColorCorrections": {(configProperties [(_cfg >> QGVAR(CC_Default) ), "true", true] apply { configName _x }) - _remProps};
    case "FilmGrain":        {(configProperties [(_cfg >> QGVAR(FG_Default) ), "true", true] apply { configName _x }) - _remProps};
    case "DynamicBlur":      {(configProperties [(_cfg >> QGVAR(DB_Default) ), "true", true] apply { configName _x }) - _remProps};
};

ZRN_LOG_1(_properties);

private _effectArray = [];

_cfg = _cfg >> _presetName;
// Create effect Array to be exported
{
    _value = [_cfg, _x] call BIS_fnc_returnConfigEntry;
    _effectArray set [_forEachIndex,_value];
} forEach _properties;

ZRN_LOG_1(_effectArray);

_effectArray
