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
*
* GVARS
*  	GVAR(S_activeJIP) set [_presetName, [isTransitioning, previous_intensity, _endTime]
*
*/


if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };

params [
	["_presetName",		"",		[""]	],
	["_duration",		1,		[0]		],
	["_intensity",		0,		[0]		]
];

ZRN_LOG_MSG_3(INIT,_presetName,_duration,_intensity);


if (_presentName isEqualTo "CLEANUP") exitWith {
	{
		// inTransition?
		if (_y#0) then {
			_parameter = [ _x, _y#2 ];
			_condition = { time > _this#1 };	// Waits until the individual last transition has been completed
			_statement = { [_this#0] call FUNC(request); };
			[_condition, _statement, _parameter] call CBA_fnc_waitUntilAndExecute;
		}
	} foreach QGVAR(S_activeJIP);
	ZRN_LOG_MSG(Cleanup Requested!);
	true
};

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

if  (_presetName isEqualTo "")                                                                               exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !(_presetName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found);    false};
if ( _intensity == 0 && { isNil QGVAR(S_activeJIP) || { !(_presetName in GVAR(S_activeJIP))} } )                 exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of same type); false };
if (isNil QGVAR(S_activeJIP)) then { GVAR(S_activeJIP) = createHashMap; };
if (_presetName in GVAR(S_activeJIP) && { (GVAR(S_activeJIP) get _presetName)#0 } )                              exitWith { ZRN_LOG_MSG(failed: this effectName is currently in Transition); false };

//_presetName = [inTransition, _previousIntensity, _endTime]

_array = GVAR(S_activeJIP) getOrDefault [_presetName, [true, 0, time + _duration], true];

private _previousIntensity = _array#1;

if (_intensity == 0 && { count QGVAR(S_activeJIP) == 0 || { _presetName in QGVAR(S_activeJIP) }}) exitWith {ZRN_LOG_MSG(failed: Intensity == 0 while active sound 3D SFX of same Type); false };


[_presetName, _duration, _intensity, _previousIntensity] remoteExecCall [ QFUNC(remote_3d), [0,2] select isDedicated, _presetName];

_array set [ 1, _intensity ];
_array set [ 2, time + _duration ];
GVAR(S_activeJIP) set [_presetName, _array];

if (_intensity == 0) then {

	[ {
		remoteExec ["", _this#0];
		_this#1 deleteAt _this#2;
		if (count _this#1 == 0) then { GVAR(S_activeJIP) = nil; };
	} , [_presetName, QGVAR(S_activeJIP), _presetName], _duration] call CBA_fnc_waitAndExecute;
};
ZRN_LOG_MSG_1(:,GVAR(S_activeJIP));
ZRN_LOG_MSG_1(completed!,_presetName);
true