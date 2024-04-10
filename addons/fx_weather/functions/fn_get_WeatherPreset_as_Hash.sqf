#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Retrieves the Weather Preset Class from Config and Exports it as a HashMap.
 *
 * Arguments:
 * 0: _presetName <STRING> Name of Weather Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * [_weatherPresetMap, _properties]
 * 
 *         _weatherPresetMap   <HASHMAP> Hashmap of the Weather Preset 
 *          _properties         <ARRAY> Array of all the properties as Strings
 *
 * Example:
 * [_presetName] call storm_fxWeather_fnc_get_WeatherPreset_as_Hash;
 * 
 * Public: No
 * GVARS
 * 	None
*/


/*

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NOT IN USE ANYMORE

params [   ["_presetName", "", [""]]    ];


//Check if EffectName given
if (_presetName isEqualTo "") exitWith {
    ZRN_LOG_MSG(failed: no _presetName provided);
    false
};

//Check if config Exists
if !(_presetName in (configProperties [configFile >> Q(P_CFG_COMP) >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith {
    ZRN_LOG_MSG(failed: provided _presetName not found);
    false
};

private _configPath = (configFile >> Q(P_CFG_COMP) >> QGVAR(Presets) >> _presetName );
private _properties = (configProperties [(configFile >> Q(P_CFG_COMP) >> QGVAR(Presets) >> QGVAR(Default) ), "true", true] apply { configName _x });

private _weatherPresetMap = createHashMap;



{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _weatherPresetMap set [_x,_value];
} forEach _properties;

_weatherPresetMap



*/