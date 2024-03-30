#include "..\script_component.hpp"

/*
* Author: Zorn
* To be executed on the server, will remoteExecute all needed Fnc Calls and Handle JIP
*
* Arguments:
*	0:	_effectName		<STRING>	Name of desired preset from CVO SFX Soundpresets
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

if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };

params [
	["_effectName",		"",		[""]	],
	["_duration",		1,		[0]		],
	["_intensity",		0,		[0]		]
];

ZRN_LOG_MSG_3(INIT,_effectName,_duration,_intensity);


if (_presentName isEqualTo "CLEANUP") exitWith {
	{
		// inTransition?
		if (_y#0) then {
			_parameter = [ _x, _y#2 ];
			_condition = { time > _this#1 };	// Waits until the individual last transition has been completed
			_statement = { [_this#0] call FUNC(request); };
			[_condition, _statement, _parameter] call CBA_fnc_waitUntilAndExecute;
		}
	} foreach QGVAR(activeJIP);
	ZRN_LOG_MSG(Cleanup Requested!);
	true
};

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

if  (_effectName isEqualTo "")                                                                               exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !(_effectName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found);    false};
if ( _intensity == 0 && { isNil QGVAR(activeJIP) || { !(_effectName in GVAR(activeJIP))} } )                 exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of same type); false };
if (isNil QGVAR(activeJIP)) then { GVAR(activeJIP) = createHashMap; };
if (_effectName in GVAR(activeJIP) && { (GVAR(activeJIP) get _effectName)#0 } )                              exitWith { ZRN_LOG_MSG(failed: this effectName is currently in Transition); false };

//_effectName = [inTransition, _previousIntensity, _endTime]

_array = GVAR(activeJIP) getOrDefault [_effectName, [true, 0, time + _duration], true];

private _previousIntensity = _array#2;

if (_intensity == 0 && { count QGVAR(activeJIP) == 0 || { _effectName in QGVAR(activeJIP) }}) exitWith {ZRN_LOG_MSG(failed: Intensity == 0 while active sound 3D SFX of same Type); false };


[_effectName, _duration, _intensity, _previousIntensity] remoteExecCall [ QFUNC(remote_3d), [0,2] select isDedicated, _effectName];

_array set [ 2, _intensity ];
_array set [ 3, time + _duration ];
GVAR(activeJIP) set [_effectName, _array];

if (_intensity == 0) then {

	[ {
		remoteExec ["", _this#0];
		_this#1 deleteAt _this#2;
		if (count _this#1 == 0) then { GVAR(activeJIP) = nil; };
	} , [_effectName, QGVAR(activeJIP), _effectName], _duration] call CBA_fnc_waitAndExecute;
};

true