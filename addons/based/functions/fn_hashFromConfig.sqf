#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Extracts properties from Config Class and returns hashMap.
 *
 * Arguments:
 * 0: _configPath       <ConfigPath> configpath that leads to the class (without target class)
 * 1: _className        <STRING> Name of any Class - Capitalisation needs to be exact!
 * 2: _inherit          <Boolean> default true - include inherited properties.
 *
 * Return Value:
 * hashMap
 *
 * Note: 
 *
 * Example:
 * [(configFile >> "CVO_AI_SubSkill_Modifier"), "CVO_AI_Skill_sandstorm_old"] call storm_based_fnc_hashFromConfig;
 * 
 * Public: No
 */

params [   
    "_configPath",
    ["_className",      "",     [""]    ],
    ["_inherit",      true,     [true]  ]
];

if (_className  isEqualTo "") exitWith {false};

//Check if config Exists
if !(_className in (configProperties [_configPath , "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fn_common_get_hash_from_config) - provided classname doesnt exist: %1", _className];
    false
};

// get list of Properties
private _properties = (configProperties [_configPath >> _classname, "true", _inherit] apply { configName _x });

// create Hashmap and fill
private _returnHashMap = createHashMap;
{
    _value = [_configPath >> _classname, _x] call BIS_fnc_returnConfigEntry;
    _returnHashMap set [_x,_value];
} forEach _properties;

// diag_log format ["[CVO][STORM](LOG)(fn_common_get_hash_from_config) - success : %1",_returnHashMap];

_returnHashMap