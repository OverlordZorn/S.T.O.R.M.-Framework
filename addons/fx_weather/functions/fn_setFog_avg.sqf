#include "..\script_component.hpp"

/*
 * Author: [Zorn]
 * Starts perFrameHandler and/or adjust GVAR(S_fogParams) - will repeatedly use setFog during tranistion.
 * If requested, will maintain adjustment beyond transition and adapt fogbase, based on average player ASL
 * If GVAR isNil, perFrameHandler stops.
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
 

if (!isServer) exitWith {};

  params [
    ["_fog_target",         [0,0,0],    [[]],   [3] ],
    ["_duration",           0,          [0]         ],
    ["_boost",              true,       [true]      ]
];
#define DELAY 15

private _fog_start = fogParams;
private _startTime = time;
private _endTime = time + _duration;

private _needPerFrameHandler = isNil QGVAR(S_fogParams);

// S_fogParams gets updated with the new target parameters
GVAR(S_fogParams) = [_startTime, _endTime, _fog_start, _fog_target, DELAY, _boost];
ZRN_LOG_1(GVAR(S_fogParams));

// If the perFrameHandler is already running, we only need to update the array
if (!_needPerFrameHandler) exitWith { ZRN_LOG_1(_needPerFrameHandler);};

private "_condition";

_condition = { ! isNil QGVAR(S_fogParams) };

private _codeToRun = {
    private _fnc_scriptName = "PFH_setFog_avg";


    
    GVAR(S_fogParams) params ["_startTime", "_endTime", "_fog_start", "_fog_target", "_delay", "_boost"];
    //ZRN_LOG_1(GVAR(S_fogParams));

    private _avg_ASL = round ([] call FUNC(get_AvgASL));
    //ZRN_LOG_MSG_1(Pre-Boost:,_avg_ASL);

    if (_boost) then {
        ////////////////////////////////////////////////////////////////////////////////
        // Problem: On Maps with a very high base elevation, fog sometimes wont be as intensive as on sea-level, where tested.
        // When increasing templates base value, the expierence on sea level will be to soupy
        // Temporary Solution: Boost of avgASL in case of high base elevation of map.
        // could be made better, for example, simple factor, or investigate if the fogparams can be made more universal but i cant be fucked to investigate rn
        _avg_ASL = _avg_ASL + linearConversion [0, 900, _avg_ASL, 0, 230];
        ////////////////////////////////////////////////////////////////////////////////
    };


    //ZRN_LOG_MSG_1(PostBoost:,_avg_ASL);

    private _currentParams = switch (time > _endTime) do {
        case true: {
            // ZRN_LOG_MSG_1(PFH after transitiion,time);
            // fog_target
            [
                _fog_target#0,
                _fog_target#1,
               (_fog_target#2) + _avg_ASL
            ]
        };
        case false: {
            // ZRN_LOG_MSG_1(PFH during transitiion,time);
            [
                linearConversion [_startTime, _endTime, time, _fog_start#0, _fog_target#0,             true ],
                linearConversion [_startTime, _endTime, time, _fog_start#1, _fog_target#1,             true ],
                linearConversion [_startTime, _endTime, time, _fog_start#2,(_fog_target#2) + _avg_ASL, true ]
            ]
        };
    };

    // ZRN_LOG_1(_currentParams);
    _delay setFog _currentParams;

};
_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_condition"];

    if ([] call _condition) then {
        [] call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
    };
}, DELAY, [_codeToRun,_condition]] call CBA_fnc_addPerFrameHandler;