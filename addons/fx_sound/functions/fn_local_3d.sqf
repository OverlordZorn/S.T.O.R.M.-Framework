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
* [_soundName,_soundPreset, _direction, _distance, _intensity, _maxDistance] call storm_fxSound_fnc_local_3d;
*
* Public: Yes
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


if (_soundName == "") exitWith {};
if ( _direction isEqualType "" && { !(_direction in ["WIND", "RAND"]) } ) exitWith { ZRN_LOG_MSG(failed: _direction invalid!); false };

if (missionNamespace getVariable [QGVAR(Helper_Array), false] isEqualTo false ) then {    GVAR(Helper_Array) = [];    };
private _HelperName = [ADDON,_soundPreset,"helperOBJ"] joinString "_";
private _helperObj = missionNamespace getVariable [_HelperName, objNull ];
if (_intensity == 0 && { _helperObj isEqualTo objNull }) exitWith { ZRN_LOG_MSG(failed: cannot cleanup while no previous effect); false };


if (_helperObj isEqualTo objNull) then {
        // use invisible helperObj to play3d the sound from, or, when debug, use big funny arrow
        _helperClass = ["Helper_Base_F", call {selectRandom ["Sign_Arrow_Large_Green_F", "Sign_Arrow_Large_Blue_F", "Sign_Arrow_Large_Pink_F", "Sign_Arrow_Large_Yellow_F", "Sign_Arrow_Large_Green_F"]} ] select (missionNamespace getVariable ["CVO_Debug", false]);
        
        _helperObj  = createVehicleLocal [_helperClass, [0,0,0]];
        missionNamespace setVariable [_HelperName, _helperObj];
        GVAR(Helper_Array) pushBack _helperObj;
        ZRN_LOG_1(GVAR(Helper_Array));
        ZRN_LOG_MSG_1(Debug Helper Created,_helperClass);
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

ZRN_LOG_MSG_2(say3D,_soundName,_intensity);


// Deletes the Local Helper Obj once intensity has reached 0;
if (_intensity == 0) then {
    _statement = {
        private _array = GVAR(Helper_Array) - [_this#1];
        if (count _array == 0) then {
            GVAR(Helper_Array) = nil;
            ZRN_LOG_MSG_1(cleanup: helper array == isNil,_intensity);
        } else {
            GVAR(Helper_Array) = _array;
            ZRN_LOG_MSG_1(cleanup: helper Array ==,GVAR(Helper_Array));
        };
        deleteVehicle (missionNameSpace getVariable _this#2 );
        missionNamespace setVariable [_this#2, nil];  
        ZRN_LOG_MSG_1(cleanup: helper obj deleted - gvar = nil,_intensity);
    };

    _condition = {  _this#0 isEqualTo objNull    };                 // condition - Needs to return bool
    _parameter = [_sayObj, _helperObj, _HelperName];                                         // arguments to be passed on -> _this
    _timeout = 120;                                                 // if condition isnt true within this time in S, _timecode will be executed.
    [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;
};

_sayObj