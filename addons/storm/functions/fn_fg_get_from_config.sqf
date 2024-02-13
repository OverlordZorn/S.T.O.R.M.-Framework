/*
 * Author: [Zorn]
 * Extracts Film Grain Parameters from Config Class in suitable format for ppEffectAdjust command.
 *
 * Arguments:
 * 0: _FG_effectName    <STRING> Name of Film Grain Post Process Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * effect-array for ppEffectAdjust
 *
 * Note: 
 *
 * Example:
 * ["CVO_FG_Default"] call cvo_storm_fnc_FG_get_from_config;
 * 
 * Public: No
 */



params [   ["_FG_effectName", "", [""]]    ];

diag_log format ["[CVO][STORM](LOG)(Fnc_FG_get_from_config) - Start : %1", _this];

//Check if EffectName given
if (_FG_effectName isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_FG_get_from_config) - no classname provided: %1", _FG_effectName];
    false
};

//Check if config Exists
if !(_FG_effectName in (configProperties [configFile >> "CVO_PP_Effects", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_FG_get_from_config) - provided classname doesnt exist: %1", _FG_effectName];
    false
};


private _configPath = (configFile >> "CVO_PP_Effects" >> _FG_effectName ); 

//Check if its a FG Effect
if !(getText (_configPath >> "ppEffectType") isEqualTo "FilmGrain" ) exitWith {
    diag_log format ["[CVO][STORM](Error)(Fnc_FG_get_from_config) - classname is not a CC_PPEffect: %1", _FG_effectName];
    false
};

private _effectArray = [];

{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _effectArray set [_forEachIndex,_value];
} forEach [ "intensity", "sharpness", "grainSize", "intensityX0", "intensityX1", "monochromatic" ];


diag_log format ["[CVO][STORM](LOG)(Fnc_FG_get_from_config) - success : %1", _effectArray];

_effectArray
