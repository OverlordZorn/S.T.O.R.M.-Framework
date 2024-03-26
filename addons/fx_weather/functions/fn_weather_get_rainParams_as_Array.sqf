#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Retrieves the RainParticle Class from Config and Exports it as Array because of the wierd ass bool in the class.
 *
 * Arguments:
 * 0: _rainParticle_name <STRING> Name of Rain Particle Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * _rainParams  <Array> Array of Rain Parameters, compatible with the `setRain` Command
 *
 * Example:
 * ["CVO_RainParams_Default"] call cvo_storm_fnc_weather_get_rainParams_as_Array;
 * 
 * Public: No
 */

 params [   ["_rainParticle_name", "", [""]]    ];




//Check if EffectName given
if (_rainParticle_name isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_weather_get_rainParams_as_Array) - no _rainParticle_name provided: %1", _rainParticle_name];
    false
};

//Check if config Exists
if !(_rainParticle_name in (configProperties [configFile >> "CVO_Weather_Effects" >> "CVO_Rain_Params", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_weather_get_rainParams_as_Array) - provided _rainParticle_name doesnt exist: %1", _rainParticle_name];
    false
};

private _configPath = (configFile >> "CVO_Weather_Effects" >> "CVO_Rain_Params" >> _rainParticle_name );
private _properties = (configProperties [(configFile >> "CVO_Weather_Effects" >> "CVO_Rain_Params" >> "CVO_RainParams_Default" ), "true", true] apply { configName _x });

private _rainParams = [];

// Create effect Array to be exported
{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;

    // Converts Config Number into Boolean. If its already a boolean, oh well, still turns into a bool lol.
    if (_x in ["snow", "dropColorStrong"] ) then {    _value = [false, true] select _value;     };

    _rainParams set [_forEachIndex,_value];
} forEach _properties;

diag_log format ["[CVO][STORM](LOG)(fnc_weather_get_rainParams_as_Array) - success : %1 %2",_rainParticle_name, _rainParams];

_rainParams