#include "..\script_component.hpp"

/*
* Author: Zorn
* To be executed on the server, will remoteExecute all needed Fnc Calls and Handle JIP
*
* Arguments:
*	0:	_presetName		<STRING>	Name of desired preset from CVO SFX Soundpresets
*	1:	_duration		<NUMBER>	Duration in Minutes - Time of the transition from current to target
*	2:	_intensity		<Number>	0..1 Intensity Value - 1 means 100%, 0 means 0% - 0 Will reset and cleanup previous effects
*
* Return Value:
* None
*
* Example:
* ['something', player] call storm_fxSound_fnc_request;
*
* Public: Yes
*/


params [
	["_presetName",		"",		[""]	],
	["_duration",		1,		[""]	],
	["_intensity",		0,		[""]	]
];

_intensity = _intensity max 0 min 1;
_duration = _duration * 60;

if (isNil QGVAR(jip_hashMap)) then { GVAR(jip_hashMap) = createHashMap };

private _hashMap = missionNamespace getVariable QGVAR(jip_hashMap);

// Waits until the individual last transition has been completed
if (_presentName isEqualTo "CLEANUP") exitWith {
	{
		_parameter = [ _x, _y#3 ];
		_condition = { time > _this#1 };
		_statement = { [_this#0] call cvo_storm_fnc_sfx_request;  };
		[_condition, _statement, _parameter] call CBA_fnc_waitUntilAndExecute;
		diag_log format ['[CVO](debug)(fn_sfx_request) CLEANUP Requested for: %1', _x];
	} foreach _hashMap;
};


private _jipHandle = ["CVO_SFX_JIP",_presetName,"_handle"] joinString "_";

//[_presetName, _jipHandle, _previousIntensity, _endTime]

_array = _hashMap getOrDefault [_presetName, _jipHandle, 0, time + _duration * 1.1];
private _previousIntensity = _array#2;

if (_intensity == 0 && { count _hashMap == 0 || { _presetName in _hashMap }}) exitWith {diag_log format ['[CVO](debug)(fn_sfx_request) failed: Intensity == 0 while active sound 3D SFX of same Type: %1', _presetName]; };


[_presetName, _duration, _intensity, _previousIntensity] remoteExecCall ["cvo_storm_fnc_sfx_remote_3d", [0,2] select isDedicated, _jipHandle];
_array set [ 2, _intensity ];
_array set [ 3, time + _duration ];
_hashMap set [_presetName, _array];

if (_intensity == 0) then {

	[ {
		remoteExec ["", _this#0];
		_this#1 deleteAt _this#2;
		if (count _this#1 == 0) then { missionNamespace setVariable [QGVAR(jip_hashMap), nil]; };
	} , [_jipHandle, _hashMap, _presetName], _duration] call CBA_fnc_waitAndExecute;
};
