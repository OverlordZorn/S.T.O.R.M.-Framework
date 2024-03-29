#include "..\script_component.hpp"

/*
* Author: Zorn
* Establishes pfH for the transition of the intensity + Starts a recursive loop for the actual execution.
*
* Arguments:
*   0:  _PresetName
*   1:  _duration       in secounds
*   2:  _intensity
*   3:  _previousIntensity      gets provides so in case of JIP, the client will start with the same parameters instead of  up with the same 
*
*
* Return Value:
* None
*
* Example:
* ["CVO_SFX_3D_WindBursts", 60, 1] call storm_fxSound_fnc_remote_3d;
*
* Public: Yes
*/




params [
    ["_presetName",             "",     [""]    ],
    ["_duration",               60,     [0]     ],
    ["_intensity",              0,      [0]     ],
    ["__previousIntensity",     0,      [0]     ]
];

ZRN_LOG_MSG_1(start,_this);

#define DELAY 5

if (_PresetName isEqualTo "") exitWith {false};
if ( _intensity == 0 && { missionNamespace getVariable ["CVO_SFX_3D_Active", false] isEqualTo false } ) exitWith {diag_log "[CVO](Storm)(fn_sound_remote_spatial) failed: intensity 0 without active sfx";};
//Check if config Exists
if !(_PresetName in (configProperties [configFile >> "CVO_SFX_Presets", "true", true] apply { configName _x })) exitWith {    diag_log format ["[CVO][STORM](Particle_request) Failed: provided PE_Effect_name doesnt exist: %1", _PE_effect_Name]; false };


_duration = _duration min 60;
_intensity = _intensity max 0 min 1;

// array of all active SFX spacial preset Types - [_presetName, _isInTransition, _previousIntensity, _currentIntensity, _targetIntensity]
if (missionNamespace getVariable ["CVO_SFX_3D_Active", false] isEqualTo false) then {  missionNamespace setVariable ["CVO_SFX_3D_Active", []]; };

private _index = -1;

if (count CVO_SFX_3D_Active > 0) then { _index = CVO_SFX_3D_Active findIf { _x#0 == _presetName }; };
ZRN_LOG_1(_index);

private ["_arr", "_currentIntensity", "_targetIntensity", "_exitDueTransitionActive"];

private _startRecursive = false;
if (_index == -1) then {
    _startRecursive = true;
    // create new entry
    _previousIntensity = 0;
    _currentIntensity = 0.01;       // Starts with 0.01 intensity to avoid the fail of the first recursive call
    _targetIntensity = _intensity;
    _arr = [_presetName, true, _previousIntensity, _currentIntensity, _targetIntensity];
    CVO_SFX_3D_Active pushBack _arr;
    _exitDueTransitionActive = false;
    ZRN_LOG_MSG_1(New Entry,CVO_SFX_3D_Active);
} else {
    // retrieve and update existing Entry
    _arr = CVO_SFX_3D_Active select _index;
    _previousIntensity = _arr select 2;
    _currentIntensity = _arr select 2;
    _targetIntensity = _intensity;
    _exitDueTransitionActive = _arr select 1;
    // [_presetName, _isInTransition, _previousIntensity, _currentIntensity, _targetIntensity]
    _arr set [2, _previousIntensity];
    _arr set [3, _currentIntensity];
    _arr set [4, _targetIntensity];
    ZRN_LOG_MSG_3(Retrieve existing Entry,_arr,_index,CVO_SFX_3D_Active);
};

if _exitDueTransitionActive exitWith {diag_log format ['[CVO](Storm)(fn_sound_remote_spatial) failed - Transition already taking place: %1', _presetName]; false };


////////////////////////////////////////////////////
// perFrameHandler for transition of Intensity //
//////////////////////////////////////////////////

private _startTime = time;
private _endTime = time + _duration;
private _condition = { _this#1 > time };

private _parameters = [_startTime, _endTime, _presetName];

private _codeToRun = {
    private _index = CVO_SFX_3D_Active findIf { _x#0 == _this#2 };
    if (_index == -1) exitWith {diag_log "[CVO](debug)(fn_sfx_remote_3d) PFH _index == -1";};
    private _arr = CVO_SFX_3D_Active select _index;
    _currentIntensity = linearConversion [_this#0, _this#1, time, _arr#2, _arr#4, true];
    _arr set [3, _currentIntensity];
};
private _exitCode = {
    private _index = CVO_SFX_3D_Active findIf { _x#0 == _this#2 };
    if (_index == -1) exitWith {diag_log "[CVO](debug)(fn_sfx_remote_3d) PFH _index == -1 druing exitCode";};
    private _arr = CVO_SFX_3D_Active select _index;
    _tgtInt = _arr select 4;
    _arr set [1,false];
    _arr set [2,_tgtInt];
    _arr set [3,_tgtInt];
    if (_tgtInt == 0) then {
        CVO_SFX_3D_Active deleteAt _index;
        if (count CVO_SFX_3D_Active == 0) then {CVO_SFX_3D_Active = nil};
    };
};

private _delay = DELAY;

_handle = [{
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

if (_startRecursive) then {
    [_presetName] call FUNC(local_3d_recursive);
};

//////////////////////////////////////////////////
