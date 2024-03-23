/*
* Author: Zorn
* Function to play distant windsound.
* To be executed remotely on each client.
*
* Arguments:
*   0   _classname      <STRING> Classname of CfgSounds class
*   1   _intensity      <NUMBER> 0..1 Intensity - The stronger the Intensity, the closer the soundsource. 
*
* Return Value:
* None
*
* Example:
* ['_soundName', 0.5] call cvo_storm_fnc_sound_remote_distant
*
* Public: Yes
*/

params [
    ["_soundName",      "",         [""]    ],
    ["_intensity",      0,          [0]     ],
    ["_direction",     "WIND",      ["",0], ],
    ["_maxDistance",    1500,       [0]     ],
    ["_minDistance",    500,        [0]     ]
];

#define ABOVEGROUND 500

if (_soundName == "") exitWith {};
// _windSounds_array = ["CVO_SFX_SS_Wind1", "CVO_SFX_SS_Wind2"];

if (_intensity == 0 && {missionNamespace getVariable ["CVO_SFX_Distant_helper", false] isEqualTo false}) exitWith {diag_log "[CVO](debug)(fn_sound_remote_distant) failed: Intensity 0: Cleanup not possible while no previous sound execution";}

if (missionNamespace getVariable ["CVO_SFX_Distant_helper", false] isEqualTo false) then {
    CVO_SFX_Distant_helper  = createVehicleLocal ["Helper_Base_F", [0,0,0]];
};

private _distance = linearConversion [0,1, _intensity, _maxDistance, _minDistance];

private _pos = player getPos [_distance, windDir + 180];
_pos = [_pos#0, _pos#1, getPosASL player # 2];


CVO_SFX_Distant_helper setPosASL _pos;
_sayObj = _helper say3D [_soundName, 5000, 1, 0, 0 /* 2.18, true */];


// Deletes the Local Helper Obj once intensity has reached 0;
if (_intensity == 0) then {
    _condition = {  _this#0 isEqualtO objNull    };                 // condition - Needs to return bool
    _statement = { deleteVehicle CVO_SFX_Distant_helper };          // Code to be executed once condition true
    _parameter = [_sayObj];                                         // arguments to be passed on -> _this
    _timeout = 120;                                                 // if condition isnt true within this time in S, _timecode will be executed.
    [_condition, _statement, _parameter, _timeout,_statement] call CBA_fnc_waitUntilAndExecute;
};