#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Retrieves the RainParticle Class from Config and Exports it as Array because of the wierd ass bool in the class.
 *
 * Arguments:
 * 0: _rainParams_preset <STRING> Name of Rain Particle Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * _rainParams  <Array> Array of Rain Parameters, compatible with the `setRain` Command
 *
 * Example:
 * [_rainParams_preset] call storm_fxWeather_fnc_rainParms_as_Array;
 * 
 * Public: No
 *
 * GVARS
 * 	None
 *
*/

 params [   ["_rainParams_preset", "", [""]]    ];

//Check if EffectName given
if (_rainParams_preset isEqualTo "") exitWith {
    ZRN_LOG_MSG(failed: _rainParams_preset not provided);
    false
};

//Check if config Exists
if !(_rainParams_preset in (configProperties [configFile >> QGVAR(Presets) >> QGVAR(RainParams), "true", true] apply { configName _x })) exitWith {
    ZRN_LOG_MSG(failed: _rainParams_preset not found);
    false
};

private _configPath = (configFile >> QGVAR(Presets) >> QGVAR(RainParams) >> _rainParams_preset );
private _properties = (configProperties [(configFile >> QGVAR(Presets) >> QGVAR(RainParams) >> QGVAR(Default) ), "true", true] apply { configName _x });

private _rainParams = [];

// Create effect Array to be exported
{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;

    // Converts Config Number into Boolean. If its already a boolean, oh well, still turns into a bool lol.
    if (_x in ["snow", "dropColorStrong"] ) then {    _value = [false, true] select _value;     };

    _rainParams set [_forEachIndex,_value];
} forEach _properties;

_rainParams