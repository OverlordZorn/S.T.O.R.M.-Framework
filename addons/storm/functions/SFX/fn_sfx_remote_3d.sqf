/*
* Author: Zorn
* Establishes pfH for the transition of the intensity + Starts a recursive loop for the actual execution.
*
* Arguments:
*   0:  _PresetName
*   1:  _intensity
*   2:  _duration
*
*
* Return Value:
* None
*
* Example:
* ['something', player] call cvo_storm_fnc_sfx_remote_3d
*
* Public: Yes
*/

#define DELAY 1

params [
    ["_presetName",     "",     [""]    ],
    ["_duration",       0,      [0]     ],
    ["_intensity",      0,      [0]     ]
];


if (_PresetName isEqualTo "") exitWith {};

if ( _intensity == 0 && { missionNamespace getVariable ["CVO_SFX_3D_Active", false] isEqualTo false } ) exitWith {diag_log "[CVO](debug)(fn_sound_remote_spatial) failed: intensity 0 without active sfx";};

// array of all active SFX spacial preset Types - [_presetName, _isInTransition, _previousIntensity, _currentIntensity, _targetIntensity]
if (missionNamespace getVariable ["CVO_SFX_3D_Active", false] isEqualTo false) then {  missionNamespace setVariable ["CVO_SFX_3D_Active", []]; };

private _index = -1;

if (count CVO_SFX_3D_Active > 0) then { _index = CVO_SFX_3D_Active findIf { _x#0 == _presetName }; };

private ["_arr", "_previousIntensity", "_currentIntensity", "_targetIntensity", "_exitDueTransitionActive"];
private _startRecursive = false;
if (_index == -1) then {
    _startRecursive = true;
    // new entry
    _arr = [_presetName, true, 0, 0, _intensity];
    CVO_SFX_3D_Active pushBack _arr;
    _previousIntensity = 0;
    _currentIntensity = 0;
    _targetIntensity = _intensity;
    _exitDueTransitionActive = false;
} else {
    // retrieve old Entry
    _arr = CVO_SFX_3D_Active select _index;
    _previousIntensity = _arr select 2;
    _currentIntensity = _arr select 2;
    _targetIntensity = _intensity;
    _exitDueTransitionActive = _arr select 1;
};
if _exitDueTransitionActive exitWith {diag_log format ['[CVO](debug)(fn_sound_remote_spatial) failed - Transition already taking place: %1', _presetName]; false };


////////////////////////////////////////////////////
// perFrameHandler for transition of Intensity //
//////////////////////////////////////////////////

private _startTime = time;
private _endTime = time + _duration;
private _condition = { _this#1 > time };

private _parameters = [_startTime, _endTime, _presetName];

private _codeToRun = {
    private _index = CVO_SFX_3D_Active findIf { _x#0 == _this#2 };
    if (_index == -1) exitWith {};
    private _arr = CVO_SFX_3D_Active select _index;
    _currentIntensity = linearConversion [_this#0, _this#1, time, _arr#2, _arr#4, true];
    _arr set [3, _currentIntensity];
};
private _exitCode = {
    private _index = CVO_SFX_3D_Active findIf { _x#0 == _this#2 };
    if (_index == -1) exitWith {};
    private _arr = CVO_SFX_3D_Active select _index;
    _tgtInt = _arr select 4;
    _arr set [1,false];
    _arr set [2,_tgtInt];
    _arr set [3,_tgtInt];
};

private _delay = DELAY;

[{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_parameters", "_exitCode", "_condition"];

    if (_parameters call _condition) then {
        _parameters call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
        _parameters call _exitCode;
    };
}, _delay, [_codeToRun, _parameters, _exitCode, _condition]] call CBA_fnc_addPerFrameHandler;

//////////////////////////////////////////////////


//////////////////////////////////////////////////
///////// Starts recursive function  /////////////
//////////////////////////////////////////////////
if _startRecursive then {

};


//////////////////////////////////////////////////

