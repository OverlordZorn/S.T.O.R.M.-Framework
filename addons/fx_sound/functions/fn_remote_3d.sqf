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
* Public: No
*
* GVARS
*   GVAR(C_isActive) // key = _presetName # value =[_inInTransition, _previousIntensity, _currentIntensity, _targetIntensity, helperObj, sayObj,isActive]
*
*/
                    


params [
    ["_presetName",             "",     [""]    ],
    ["_duration",               60,     [0]     ],
    ["_intensity",              0,      [0]     ],
    ["_previousIntensity",      0,      [0]     ]
];

ZRN_LOG_MSG_4(start,_presetName,_duration,_intensity,_previousIntensity);

#define DELAY 5

if (_PresetName isEqualTo "") exitWith {false};


if ( _intensity == 0 && { missionNamespace getVariable [QGVAR(C_isActive), false] isEqualTo false } )        exitWith { ZRN_LOG_MSG(failed: intensity == 0 while no active effect); false };
//Check if config Exists
if !(_PresetName in (configProperties [configFile >> QGVAR(Presets), "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };


_duration = _duration min 60;
_intensity = _intensity max 0 min 1;


if (missionNamespace getVariable [QGVAR(C_isActive), false] isEqualTo false) then {
    GVAR(C_isActive) = createHashMap;
    ZRN_LOG_MSG_1(hashmap on client created: isActive,GVAR(C_isActive));
    };


private _exists = false;
if (count GVAR(C_isActive) > 0) then { _exists = _presetName in GVAR(C_isActive) };

private ["_arr", "_currentIntensity", "_targetIntensity", "_exitDueTransitionActive", "_startRecursive"];

if (_exists) then {
    // retrieve and update existing Entry
    _startRecursive = false;
    _arr = GVAR(C_isActive) get _presetName;
    _previousIntensity = _arr select 1;
    _currentIntensity = _arr select 1;
    _targetIntensity = _intensity;
    _exitDueTransitionActive = _arr select 0;
    _arr set [1, _previousIntensity];
    _arr set [2, _currentIntensity];
    _arr set [3, _targetIntensity];
    ZRN_LOG_MSG_2(Retrieve existing Entry,_arr,GVAR(C_isActive));
} else {
    // create new entry
    _startRecursive = true;
    _previousIntensity = 0;
    _currentIntensity = 0.01;       // Starts with 0.01 intensity to avoid the fail of the first recursive call
    _targetIntensity = _intensity;
    GVAR(C_isActive) set [_presetName,[true, _previousIntensity, _currentIntensity, _targetIntensity,objNull,objNull,true] ];
    _exitDueTransitionActive = false;
    ZRN_LOG_MSG_1(New Entry,GVAR(C_isActive));
};

if (_exitDueTransitionActive) exitWith {ZRN_LOG_MSG(failed: Transition already taking place); false };


////////////////////////////////////////////////////
// perFrameHandler for transition of Intensity //
//////////////////////////////////////////////////

private _startTime = time;
private _endTime = time + _duration;
private _condition = { _this#1 > time };

private _parameters = [_startTime, _endTime, _presetName];


private _codeToRun = {
    private _exists = _this#2 in GVAR(C_isActive);
    if (!_exists) exitWith { ZRN_LOG_MSG_1(PFH: doesnt exist anymore,_this#2); };
    private _arr = GVAR(C_isActive) get _this#2;

    _currentIntensity = linearConversion [_this#0, _this#1, time, _arr#1, _arr#3, true];
    _arr set [2, _currentIntensity];
};
private _exitCode = {
    private _exists = _this#2 in GVAR(C_isActive);
    if (!_exists) exitWith { ZRN_LOG_MSG_1(PFH during exit: doesnt exist anymore,_this#2); };
    private _arr = GVAR(C_isActive) get _this#2;
    _tgtInt = _arr#3;
    _arr set [0,false];
    _arr set [1,_tgtInt];
    _arr set [2,_tgtInt];
    ZRN_LOG_MSG_1(PFH-Transition exited,true);
};

ZRN_LOG_MSG_3(PFH PARAMS,_startTime,_endTime,_presetName);

_handle = [{
    params ["_args", "_handle"];
    _args params ["_codeToRun", "_parameters", "_exitCode", "_condition"];

    if (_parameters call _condition) then {
        _parameters call _codeToRun;
    } else {
        _handle call CBA_fnc_removePerFrameHandler;
        _parameters call _exitCode;
    };
}, DELAY, [_codeToRun, _parameters, _exitCode, _condition]] call CBA_fnc_addPerFrameHandler;
//////////////////////////////////////////////////



//////////////////////////////////////////////////
///////// Starts recursive function  /////////////
//////////////////////////////////////////////////

if (_startRecursive) then {
    [_presetName] call FUNC(local_3d_recursive);
    ZRN_LOG_MSG_1(Recursive Function Started,true);
};

//////////////////////////////////////////////////
// 1. Wait until end of transition
// 2. check if current _sayOBJ is objNull or not, if its not objNull, it waits until it gets objNull.
// 3. deletes the helperObject which functions as the soundsource of say3d
// 4. check if isActive is empty, if so, delete isActive
//////////////////////////////////////////////////


if (_intensity == 0) then {
    ZRN_LOG_MSG_1(Intensity 0 detected,true);
    [{
        ZRN_LOG_MSG_1(1. Wait until end of Transition done,true);
        if (!isNil QGVAR(C_isActive)) then {
            params ["_presetName"];
            _parameter = [_presetName];                
            _condition = { GVAR(C_isActive) get (_this#0) isEqualTo objNull };
            _timeout = 120;

            _statement = {
                ZRN_LOG_MSG_1(2. sayObj done - start cleanup,true);
                params ["_presetName"];
                deleteVehicle (GVAR(C_isActive) get _presetName select 4); // cleanup of helper object (( sound source))
                ZRN_LOG_MSG_1(helperObject deleted,true);
                GVAR(C_isActive) deleteAt _presetName;
                if (count GVAR(C_isActive) isEqualTo 0) then {
                    GVAR(C_isActive) = nil;
                    ZRN_LOG_MSG_1(C_isActive has been cleaned up,true);
                };
                ZRN_LOG_MSG_1(5. cleanup full completed,true);
            };

            [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;


        }
    } , [_presetName], _duration] call CBA_fnc_waitAndExecute;
};

//////////////////////////////////////////////////
//////////////////////////////////////////////////
// GVAR(C_isActive) // key = _presetName # value =[_inInTransition, _previousIntensity, _currentIntensity, _targetIntensity, helperObj, sayObj,isActive]
