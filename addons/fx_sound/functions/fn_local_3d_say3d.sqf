#include "..\script_component.hpp"

/*
* Author: Zorn
* Function to play a single distant CfgSound with the help of a Helper Object in 3D Space (say3d).
* 
*
* Arguments:
*   0   _classname      <STRING> Classname of CfgSounds class
*   1   _intensity      <NUMBER> 0..1 Intensity - The stronger the Intensity, the closer the soundsource. 
*
* Return Value:
* None
*
* Example:
* [_soundName,_presetName, _direction, _distance, _intensity, _maxDistance] call storm_fxSound_fnc_local_3d_play;
*
* Public: No
*
* GVARS
*  	GVAR(C_Objects) hashmap key = _presetName - value = _helperObj
*
*/

params [
    ["_soundName",      "",         [""]    ],
    ["_presetName",    "",         [""]    ],
    ["_direction",      "WIND",     ["",0]  ],
    ["_distance",       50,         [0]     ],
    ["_intensity",      0,          [0]     ],
    ["_maxDistance",    1500,       [0]     ]
];

ZRN_LOG_MSG_6(START,_soundName,_presetName,_direction,_distance,_intensity,_maxDistance);

#define ABOVEGROUND 5
//#define ISSPEECH 0
//#define OFFSET 0
#define ABSOLUTE_MAXRANGE 5000
#define RANGE_MOD 1.5

if (_soundName == "")                                                     exitWith {ZRN_LOG_MSG(failed: no _soundName Provided); false };
if ( _direction isEqualType "" && { !(_direction in ["WIND", "RAND"]) } ) exitWith { ZRN_LOG_MSG(failed: _direction invalid!); false };


if (isNil QGVAR(C_isActive)) exitWith {ZRN_LOG_MSG(Failed: C_isActive doesnt Exist anymore); false};
if !(_presetName in GVAR(C_isActive)) exitWith { ZRN_LOG_MSG(failed: _presetName not in C_isActive anymore); false };

private _exists = GVAR(C_isActive) get _presetName select 4 isNotEqualTo objNull;

if (_intensity isEqualTo 0 && { !_exists }) exitWith { ZRN_LOG_MSG(failed: cannot cleanup while no previous effect); false };

private ["_helperObj"];

if (!_exists ) then {
        // use invisible helperObj to play3d the sound from, or, when debug, use big funny arrow
        _helperClass = ["Helper_Base_F", call {selectRandom ["Sign_Arrow_Large_Green_F", "Sign_Arrow_Large_Blue_F", "Sign_Arrow_Large_Pink_F", "Sign_Arrow_Large_Yellow_F", "Sign_Arrow_Large_Green_F"]} ] select (missionNamespace getVariable ["CVO_Debug", false]);
        _helperObj  = createVehicleLocal [_helperClass, [0,0,0]];
        GVAR(C_isActive) get _presetName set [4, _helperObj];
} else {
    _helperObj = GVAR(C_isActive) get _presetName select 4;
};

// Define Mode of Operation regarding Direction of sound source.
if (_direction isEqualType "") then {
    _direction = switch (_direction) do {
        case "WIND": { windDir + 180  };
        case "RAND": { ceil random 360 };
        default { 0 };
    };
};

private _pos = player getPos [_distance, _direction];
_pos = [_pos#0, _pos#1, ABOVEGROUND + (getPos player # 2)];

_helperObj setPos _pos;

private _range = (RANGE_MOD * _maxDistance) min ABSOLUTE_MAXRANGE;
private _pitch = 0.1 + 0.01 * round random 14;

private _sayObj = _helperObj say3D [_soundName, _range, _pitch];      /* [_soundName, _range, _pitch, ISSPEECH, OFFSET, true];      // additional bool argument once 2.18 hits */


if (_sayObj isEqualTo false) exitWith {ZRN_LOG_MSG(failed: say3d returned false); };

GVAR(C_isActive) get _presetName set [5, _sayObj];

ZRN_LOG_MSG_1(completed - returning:,_sayObj);

_sayObj

// CONTINUE HERE INTEGRATE C_isActive instead of C_Objects
/* Reminder: 

hash set ["test", [1,2,3,4,5]];
_arr = get "test";
_arr set [0, 10]

==> hash: test#[10,2,3,4,5]

*/