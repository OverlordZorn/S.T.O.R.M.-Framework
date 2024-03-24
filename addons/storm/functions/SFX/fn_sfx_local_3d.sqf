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
* [_soundName,_soundPreset, _direction, _maxDistance, _minDistance, _intensity] call cvo_storm_fnc_sfx_local_3d
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

#define ABOVEGROUND 100
#define RND_PITCH 0.2
#define ISSPEECH 0
#define OFFSET 0
#define ABSOLUTE_MAXRANGE 5000
#define RANGE_MOD 1.5

if (_soundName == "") exitWith {};

if ( _direction isEqualType "" && { !(_direction in ["WIND", "RAND"]) } ) exitWith {diag_log format ['[CVO](debug)(fn_sound_remote_spacial) failed: _Direction invalid: %1', _direction]; };

if ( ! missionNamespace getVariable ["CVO_SFX_3D_helper_array", false] ) then {    CVO_SFX_3D_helper_array = [];    };

_HelperName = ["CVO_SFX_3D",_soundPreset,"helperOBJ"] joinString "_";

private _helperObj = missionNamespace getVariable [_HelperName, objNull ];

if (_intensity == 0 && { _helperObj isEqualTo objNull }) exitWith {diag_log "[CVO](debug)(fn_sound_remote_distant) failed: Intensity 0: Cleanup not possible while no previous sound execution";};


if (_helperObj isEqualTo objNull) then {
        _helperObj  = createVehicleLocal ["Helper_Base_F", [0,0,0]];
        missionNamespace setVariable [_HelperName, _helperObj];
        CVO_SFX_3D_helper_array pushBack _helperObj;
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

_sayObj = _helperObj say3D [_soundName, _range, ((1 - RND_PITCH) + random RND_PITCH), ISSPEECH, OFFSET /*, true */];      // additional bool argument once 2.18 hits


// Deletes the Local Helper Obj once intensity has reached 0;
if (_intensity == 0) then {
    _statement = {
        private _array = CVO_SFX_3D_helper_array - [_this#1];
        if (count _array == 0) then { CVO_SFX_3D_helper_array = nil } else { CVO_SFX_3D_helper_array = _array };

        deleteVehicle (missionNameSpace getVariable _this#2 );
        missionNamespace setVariable [_this#2, nil];  
    };

    _condition = {  _this#0 isEqualTo objNull    };                 // condition - Needs to return bool
    _parameter = [_sayObj, _helperObj, _HelperName];                                         // arguments to be passed on -> _this
    _timeout = 120;                                                 // if condition isnt true within this time in S, _timecode will be executed.
    [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;
};

_sayObj