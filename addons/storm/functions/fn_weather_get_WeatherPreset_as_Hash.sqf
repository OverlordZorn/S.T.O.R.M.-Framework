/*
 * Author: Zorn
 * Retrieves the Weather Preset Class from Config and Exports it as a HashMap.
 *
 * Arguments:
 * 0: _weatherPreset_name <STRING> Name of Weather Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * [_weatherPresetMap, _properties]
 *          _weatherPresetMap  <HASHMAP> Hashmap of the Weather Preset
 *          _properties        <ARRAY> Array of all the properties as Strings
 * Example:
 * ["CVO_Weather_Default"] call cvo_storm_fnc_weather_get_WeatherPreset_as_Hash;
 * 
 * Public: No
 */

 params [   ["_weatherPreset_name", "", [""]]    ];

//Check if EffectName given
if (_weatherPreset_name isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(h) - no _weatherPreset_name provided: %1", _weatherPreset_name];
    false
};

//Check if config Exists
if !(_weatherPreset_name in (configProperties [configFile >> "CVO_Weather_Effects" >> "CVO_Weather_Presets", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_weather_get_WeatherPreset_as_Hash) - provided _weatherPreset_name doesnt exist: %1", _weatherPreset_name];
    false
};

private _configPath = (configFile >> "CVO_Weather_Effects" >> "CVO_Weather_Presets" >> _weatherPreset_name );
private _properties = (configProperties [(configFile >> "CVO_Weather_Effects" >> "CVO_Weather_Presets" >> "CVO_Weather_Default" ), "true", true] apply { configName _x });

private _weatherPresetMap = createHashMap;


// Create effect Array to be exported
{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _weatherPresetMap set [_x,_value];
} forEach _properties;

diag_log format ["[CVO][STORM](LOG)(fnc_weather_get_WeatherPreset_as_Hash) - success : %1",_weatherPresetMap];

_weatherPresetMap