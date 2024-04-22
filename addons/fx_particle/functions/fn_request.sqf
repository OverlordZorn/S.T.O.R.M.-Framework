#include "..\script_component.hpp"

/*
* Author: Zorn
* To be executed on the server, will remoteExecute all needed Fnc Calls and Handle JIP
*
* Arguments:
*	0:	_presetName		<STRING>	Name of desired preset
*	1:	_duration		<NUMBER>	Duration in Minutes - Time of the transition from current to target
*	2:	_intensity		<Number>	0..1 Intensity Value - 1 means 100%, 0 means 0% - 0 Will reset and cleanup previous effects
*
* Return Value:
* None
*
* Example:
* ["storm_fx_sound_windBursts", 1,1] call storm_fxSound_fnc_request;
*
* Public: Yes
*
* GVARS
*  	GVAR(S_activeJIP) set [_presetName, [isTransitioning, previous_intensity, _endTime]
*
*/


if (!isServer) exitWith {};

params [
	["_presetName",		"",		[""]	],
	["_duration",		2,		[0]		],
	["_intensity",		0,		[0]		]
];

ZRN_LOG_MSG_1(init,_this);

_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

// Check Fail conditions
if  ( _presetName isEqualTo "" )                                                                               	 exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !( _presetName in ( configProperties [configFile >> "CfgCloudlets", "true", true] apply { configName _x } ) ) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };
if  ( _intensity == 0 && { !( [_presetName] call PFUNC(jipExists) ) } ) 											 exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of this Type); false };


// Execute Remotely on the clients
[_presetName, CBA_missionTime, _duration, _intensity] remoteExecCall [ QFUNC(remote), [0,2] select isDedicated, _presetName];


// handoff _jipHandle to jipMonitor
private _expiry = -1;
if (_intensity == 0) then { _expiry = CBA_MissionTime + _duration; };
[_expiry, _presetName] call PFUNC(jipMonitor);


ZRN_LOG_MSG(request successful);
true
