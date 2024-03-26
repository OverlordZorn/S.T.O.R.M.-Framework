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
 * ["CVO_CC_Default"] call cvo_storm_fnc_ppEffect_get_from_config;
 * 
 * Public: No
 */



params [   ["_PP_effect_Name", "", [""]]    ];


//Check if EffectName given
if (_PP_effect_Name isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_get_from_config) - no PP_Effect_name provided: %1", _PP_effect_Name];
    false
};

//Check if config Exists
if !(_PP_effect_Name in (configProperties [configFile >> "CVO_PP_Effects", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_ppEffect_get_from_config) - provided PP_Effect_name doesnt exist: %1", _PP_effect_Name];
    false
};

private _configPath = (configFile >> "CVO_PP_Effects" >> _PP_effect_Name ); 
private _ppEffectType = getText (_configPath >> "ppEffectType");


// Get Array of Properties
/*
 * The following Wont work because inherited properties will be added in the end but we need strict order, therefore handmade arrays
 * private _properties = (configProperties [_configPath , "true", true] apply { configName _x });
 * 
 * Instead: Autogenerate Array based on default class
*/

private _properties = switch (_ppEffectType) do {
    case "ColorCorrections": {(configProperties [(configFile >> "CVO_PP_Effects" >> "CVO_CC_Default" ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","layer", "baseArray"]};
    case "FilmGrain":        {(configProperties [(configFile >> "CVO_PP_Effects" >> "CVO_FG_Default" ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","layer", "baseArray"]};
    case "DynamicBlur":      {(configProperties [(configFile >> "CVO_PP_Effects" >> "CVO_DB_Default" ), "true", true] apply { configName _x }) - ["ppEffectType","ppEffectPrio","layer", "baseArray"]};
};

private _effectArray = [];

// Create effect Array to be exported
{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _effectArray set [_forEachIndex,_value];
} forEach _properties;


// diag_log format ["[CVO][STORM](LOG)(fnc_ppEffect_get_from_config) - success : %1 %2",_pp_effect_name, _effectArray];

_effectArray
