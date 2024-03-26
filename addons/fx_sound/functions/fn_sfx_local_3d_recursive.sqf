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
* ['something', player] call cvo_storm_fnc_sfx_local_3d_recursive;
*
* Public: Yes
*/


params [
    ["_presetName",     "",     [""]                ],
    ["_hashMap",        "INIT", ["", createHashMap] ]
];
private _index = CVO_SFX_3D_Active findIf { _x#0 == _presetName };
if (_index isEqualTo -1) exitWith {diag_log format ['[CVO](debug)(fn_sound_remote_recursive) finished: %1 not found in CVO_SFX_3D_Active', _presetName];};

diag_log "[CVO](debug)(fn_sfx_local_3d_recursive) Start Recursive ";

if (_hashMap isEqualTo "INIT") then {
    _configPath = (configFile >> "CVO_SFX_Presets");
    _hashMap = [_configPath, _presetName] call cvo_storm_fnc_common_hash_from_config;
};

// array of all active SFX spacial preset Types - [_presetName, _isInTransition, _previousIntensity, _currentIntensity, _targetIntensity]


private _maxDistance    =  _hashMap get "maxDistance";
private _minDistance    =  _hashMap get "minDistance";
private _direction      =  _hashMap get "direction";
private _maxDelay       =  _hashMap get "maxDelay";
private _minDelay       =  _hashMap get "minDelay";
_soundName = selectRandom (_hashMap get "sounds");


private _intensity = ( ( CVO_SFX_3D_Active select _index select 3 ) + selectRandom [-1,1] * 0.25 ) max 0;


_distance = linearConversion [0,1, _intensity, _maxDistance, _minDistance, false] max 0;
_delay =    linearConversion [0,1, _intensity, _maxDelay,    _minDelay,    false] max 0;

diag_log format ['[CVO](debug)(fn_sfx_local_3d_recursive) _soundName: %1 - _presetName: %2 - _direction: %3 - _distanced: %4 - _maxDistance: %5', _soundName , _presetName ,_direction , _distanced , _maxDistance];

_sayObj = [_soundName,_presetName, _direction, _distance, _intensity, _maxDistance] call cvo_storm_fnc_sfx_local_3d;

// waitUntil previous sound is played, then wait _delay AndExecute "recursive" function


_statement = {
    diag_log "[CVO](debug)(fn_sfx_local_3d_recursive) previous _sayObj died";
    [{_this call cvo_storm_fnc_sfx_local_3d_recursive}, [_this#2,_this#3], _this#1] call CBA_fnc_waitAndExecute;    
};                
_condition = { _this#0 isEqualTo objNull };                 // condition - Needs to return bool
_parameter = [_sayObj, _delay, _presetName, _hashMap];                              // arguments to be passed on -> _this
_timeout = 120;                                             // if condition isnt true within this time in S, _timecode will be executed.
[_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;