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
* [_soundName,_soundPreset, _direction, _distance, _intensity, _maxDistance] call storm_fxSound_fnc_local_3d_play;
*
* Public: No
*
* GVARS
*  	GVAR(C_Objects) hashmap key = _soundPreset - value = _helperObj
*
*/

params [
    ["_soundName",      "",         [""]    ],
    ["_soundPreset",    "",         [""]    ],
    ["_direction",      "WIND",     ["",0]  ],
    ["_distance",       50,         [0]     ],
    ["_intensity",      0,          [0]     ],
    ["_maxDistance",    1500,       [0]     ]
];

#define ABOVEGROUND 5
#define RND_PITCH 0.2
#define ISSPEECH 0
#define OFFSET 0
#define ABSOLUTE_MAXRANGE 5000
#define RANGE_MOD 1.5



if (_soundName == "")                                                     exitWith {ZRN_LOG_MSG(failed: no _soundName Provided); false };
if ( _direction isEqualType "" && { !(_direction in ["WIND", "RAND"]) } ) exitWith { ZRN_LOG_MSG(failed: _direction invalid!); false };

if (isNil QGVAR(C_Objects) ) then { GVAR(C_Objects) = createHashMap; };
private _exists = _soundpreset in GVAR(C_Objects);

if (_intensity == 0 && { !_exists })                                      exitWith { ZRN_LOG_MSG(failed: cannot cleanup while no previous effect); false };

private ["_helperObj"];

if (!_exists ) then {
        // use invisible helperObj to play3d the sound from, or, when debug, use big funny arrow
        _helperClass = ["Helper_Base_F", call {selectRandom ["Sign_Arrow_Large_Green_F", "Sign_Arrow_Large_Blue_F", "Sign_Arrow_Large_Pink_F", "Sign_Arrow_Large_Yellow_F", "Sign_Arrow_Large_Green_F"]} ] select (missionNamespace getVariable ["CVO_Debug", false]);
        
        _helperObj  = createVehicleLocal [_helperClass, [0,0,0]];
        ZRN_LOG_1(_helperObj);

        GVAR(C_Objects) set [_soundPreset, _helperObj];
        ZRN_LOG_1(GVAR(C_Objects));
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
_pos = [_pos#0, _pos#1, ABOVEGROUND + (getPosASL player # 2)];

_helperObj setPosASL _pos;

private _range = (RANGE_MOD * _maxDistance) min ABSOLUTE_MAXRANGE;


private _sayObj = if (__GAME_VER_MAJ__ >= 2 && { __GAME_VER_MIN__ >= 18 }) then {
    _helperObj say3D [_soundName, _range, ((1 - RND_PITCH) + random RND_PITCH), ISSPEECH, OFFSET, true];      // additional bool argument once 2.18 hits
} else {
    _helperObj say3D [_soundName, _range, ((1 - RND_PITCH) + random RND_PITCH), ISSPEECH, OFFSET];      // additional bool argument once 2.18 hits
};

ZRN_LOG_MSG_3(say3D,_sayObj,_soundName,_intensity);


// Deletes the Local Helper Obj once intensity has reached 0;

if (_intensity == 0) then {
    _condition = {  _this#0 isEqualTo objNull    };                 
    _parameter = [_sayObj, _helperObj, _soundPreset];         
    _statement = {
        
        ZRN_LOG_1(_this#1);
        deleteVehicle _this#1;
        
        GVAR(C_Objects) deleteAt _this#2;
        
        if (count GVAR(C_Objects) == 0) then {
            GVAR(C_Objects) = nil;
            ZRN_LOG_MSG_1(cleanup: C_Objects empty,_intensity);
        } else {
            ZRN_LOG_MSG_1(cleanup:,GVAR(C_Objects));
        };
        
        ZRN_LOG_MSG_1(cleanup: helper obj deleted - gvar = nil,_intensity);
    };

    _timeout = 120;                                                 // if condition isnt true within this time in S, _timecode will be executed.
    [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;
};

_sayObj