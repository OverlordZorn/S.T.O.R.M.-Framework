#include "..\script_component.hpp"

/*
* Author: Zorn
* "Recursive" Function that loops until the entry is not present anymore in 
*
*
* Return Value:
* None
*
* Example:
* [_presetName] call storm_fx_sound_fnc_local_3d_recursive;
*
* Public: Yes
*
* GVARS
*   GVAR(C_isActive) - established by fn_remote_3d ## key = _presetName # value =[_inInTransition, _previousIntensity, _currentIntensity, _targetIntensity]
*/


params [
    ["_presetName",     "",     [""]                ],
    ["_hashMap",        "INIT", ["", createHashMap] ]
];
private _exists = _presetName in GVAR(C_isActive);

if (!_exists) exitWith { ZRN_LOG_MSG(completed: preset not in GVAR(C_isActive) anymore); };

if (_hashMap isEqualTo "INIT") then {
    _configPath = (configFile >> QGVAR(Presets));
    _hashMap = [_configPath, _presetName] call PFUNC(hashFromConfig);
    if (_hashMap isEqualto false) exitWith {ZRN_LOG_MSG(failed: _hashMap == false); false};
};

private _maxDistance    = _hashMap get "maxDistance";
private _minDistance    = _hashMap get "minDistance";
private _direction      = _hashMap get "direction";
private _maxDelay       = _hashMap get "maxDelay";
private _minDelay       = _hashMap get "minDelay";
private _previousSound  = _hashMap getOrDefault ["previousSound", ""];
private _arr            = + (_hashMap get "sounds");
if (count _arr >1) then { _arr = _arr - [_previousSound]; };

private _soundName      = selectRandom _arr;

_hashMap set ["previousSound", _soundName];

private _intensity = ( ( GVAR(C_isActive) get _presetName  select 2 ) + selectRandom [-1,1] * random 0.2 ) max 0;

_distance = linearConversion [0,1, _intensity, _maxDistance, _minDistance, false] max 0;
_delay =    linearConversion [0,1, _intensity, _maxDelay,    _minDelay,    false] max 0;

_sayObj = [_soundName,_presetName, _direction, _distance, _intensity, _maxDistance] call FUNC(local_3d_say3d);

// waitUntil previous sound is played, then wait _delay AndExecute "recursive" function

_statement = {
    [{_this call FUNC(local_3d_recursive)}, [_this#2,_this#3], _this#1] call CBA_fnc_waitAndExecute;    
};                
_condition = { _this#0 isEqualTo objNull };                 // condition - Needs to return bool
_parameter = [_sayObj, _delay, _presetName, _hashMap];      // arguments to be passed on -> _this
_timeout = 120;                                             // if condition isnt true within this time in S, _timecode will be executed.
[_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;

