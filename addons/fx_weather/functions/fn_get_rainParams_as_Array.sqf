#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Retrieves the RainParticle Class from Config and Exports it as Array because of the wierd ass bool in the class.
 *
 * Arguments:
 * 0: _paramName <STRING> Name of Rain Particle Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * _rainParams  <Array> Array of Rain Parameters, compatible with the `setRain` Command
 *
 * Example:
 * [_paramName] call storm_fx_weather_fnc_rainParms_as_Array;
 * 
 * Public: No
 *
 * GVARS
 * 	None
 *
*/

 params [   ["_paramName", "", [""]]    ];

//Check if EffectName given
if (_paramName isEqualTo "") exitWith {
    ZRN_LOG_MSG(failed: _paramName not provided);
    false
};

private _configPath = configFile >> QGVAR(RainParams);

//Check if config Exists
if !(_paramName in (configProperties [_configPath, "true", true] apply { configName _x })) exitWith {
    ZRN_LOG_MSG(failed: _paramName not found);
    false
};

private _properties = (configProperties [(_configPath >> QGVAR(RainParams_Default) ), "true", true] apply { configName _x });

private _rainParams = [];

// Create effect Array to be exported
{
    _value = [_configPath >> _paramName, _x] call BIS_fnc_returnConfigEntry;

    // Converts Config Number into Boolean. If its already a boolean, oh well, still turns into a bool lol.
    if (_x in ["snow", "dropColorStrong"] ) then {    _value = [false, true] select _value;     };

    _rainParams set [_forEachIndex,_value];
} forEach _properties;

_rainParams