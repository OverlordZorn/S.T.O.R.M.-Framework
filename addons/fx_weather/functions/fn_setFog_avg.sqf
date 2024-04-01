#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Initialises or Readjust perFrameHandler which setFogs overtime while fogbase is modified based on average player ASL - based on global variable - if global variable isNil, perFrameHandler stops.
 *
 * Arguments:
 * 0: _fogParams_Target
 * 1: _duration                      <Number> Duration in Secounds over which this effect is to be applied.
 *
 * Return Value:
 * none 
 *
 * Note: 
 *
 * Example:
 * [_fogParams_Target, _setFog, 120 ] call storm_fxWeather_fnc_setFog_avg;
 * 
 * Public: No
  *
 * GVARS
 *  	GVAR(S_fogParams) = [_startTime, _endTime, _fog_start, _fog_target, DELAY];
 *
 */
 

if (!isServer) exitWith {_this remoteExecCall [QFUNC(setFog_avg),2]};

  params [
    ["_fog_target",         [0,0,0],    [[]],   [3] ],
    ["_duration",           0,          [0]         ],
    ["_targetIntensity",    0,          [0]         ]
];
#define DELAY 20

ZRN_LOG_MSG_3(INIT,_fog_target,_duration,_targetIntensity);
if (_duration isEqualTo 0) exitWith {ZRN_LOG_MSG(failed: duration == 0); false };


private _fog_start = fogParams;
private _startTime = time;
private _endTime = time + _duration;

private _needPerFrameHandler = isNil QGVAR(S_fogParams);

GVAR(S_fogParams) = [_startTime, _endTime, _fog_start, _fog_target,_targetIntensity, DELAY];

ZRN_LOG_1(GVAR(S_fogParams));

// If the perFrameHandler is already running, we only need to update the array
if (!_needPerFrameHandler) exitWith {};

private "_condition";

switch (_targetIntensity) do {
    case 0: { _condition = { QGVAR(S_fogParams)#1 > time }; };
    default { _condition = { !isNil QGVAR(S_fogParams) }; };
};


private _codeToRun = {
    
    GVAR(S_fogParams) params ["_startTime", "_endTime", "_fog_start", "_fog_target","_targetIntensity", "_delay"];
    ZRN_LOG_1(GVAR(S_fogParams));

    private _avg_ASL = round ([] call FUNC(get_AvgASL));
    ZRN_LOG_1(_avg_ASL);

    private _currentParams = switch (time > _endTime) do {
        case true: {
            ZRN_LOG_MSG_1(PFH after transitiion,time);
            // fog_target
            [
                _fog_target#0,
                _fog_target#1,
               (_fog_target#2) + _avg_ASL
            ]
        };
        case false: {
            ZRN_LOG_MSG_1(PFH during transitiion,time);
            [
                linearConversion [_startTime, _endTime, time, _fog_start#0, _fog_target#0,             true ],
                linearConversion [_startTime, _endTime, time, _fog_start#1, _fog_target#1,             true ],
                linearConversion [_startTime, _endTime, time, _fog_start#2,(_fog_target#2) + _avg_ASL, true ]
            ]
        };
    };

    ZRN_LOG_1(_currentParams);
    _delay setFog _currentParams;

};
private _exit = {
    GVAR(S_fogParams) params ["_startTime", "_endTime", "_fog_start", "_fog_target","_targetIntensity", "_delay"];
    _delay setFog _fog_target;
    GVAR(S_fogParams) = nil;
};
_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_condition"];

    if ([] call _condition) then {
        [] call _codeToRun;
    } else {
        [] call _exit;
        _handle call CBA_fnc_removePerFrameHandler;
    };
}, DELAY, [_codeToRun,_condition]] call CBA_fnc_addPerFrameHandler;