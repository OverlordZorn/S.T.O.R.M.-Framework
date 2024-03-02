/*
 * Author: [Zorn]
 * Function to apply the Particle Effect Spawners on each client locally. Intensity will be regulated simply by dropInterval (The bigger the number, the less particles)
 *
 * Arguments:
 * 0: _EffectName  <STRING> of configClassname of the desired effect. 
 *
 * Return Value:
 * none - intended to be remoteExecCall -> returns JIP Handle
 *
 * Note: 
 *
 * Example:
 * [_effectName, _intensityTarget, _duration] remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
 * 
 * Public: No
 */

// https://github.com/CBATeam/CBA_A3/wiki/Per-Frame-Handlers
// macro beispiel: #define BURN_THRESHOLD 1


#define COEF_SPEED 5
#define COEF_WIND  0.2
#define PFEH_ATTACH_DELAY 1
#define PFEH_INTENSITY_DELAY 5
#define INTERVAL_MINIMUM 30



if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_intensityTarget",    0,  [0]],
    ["_duration",     0,  [0]]
];

if ( _effectName isEqualTo "")  exitWith {};
if (_intensityTarget < 0 )            exitWith {};
if (_duration    isEqualTo  0)  exitWith {};

if (isNil "CVO_Storm_Local_PE_Spawner_array") then {
    CVO_Storm_Local_PE_Spawner_array = [];

    // Adds Debug_Helper Object (arrow)
    if (missionNamespace getVariable ["CVO_Debug", false]) then {
            _helper = createVehicleLocal [ "Sign_Arrow_Large_F", [0,0,0] ];
            _helper setVariable ["CVO_PE_Spawner_Name", "Debug_helper", false];
            CVO_Storm_Local_PE_Spawner_array pushback _helper;
    };

    // Start pfEH to re-attach all Particle Spawners according to player speed & wind.
    // watch CVO_particle_isActive, if inactive, delete particle spawners and pfEH

    private _codeToRun = {
        //_SpeedVector vectorDiff _windVector
        private _player = vehicle ace_player;  
        private _relPosArray = (( velocityModelSpace _player ) vectorMultiply COEF_SPEED) vectorDiff (( _player vectorWorldToModel wind ) vectorMultiply COEF_WIND);
        { _x attachTo [_player, _relPosArray]; } forEach CVO_Storm_Local_PE_Spawner_array;
    };

    private _condition = { missionNameSpace getVariable ["CVO_particle_isActive", false] };
    private _exitCode = { {deleteVehicle _x } forEach CVO_Storm_Local_PE_Spawner_array; CVO_Storm_Local_PE_Spawner_array = nil  };
    private _delay = PFEH_ATTACH_DELAY;

    [{
        params ["_args", "_handle"];
        _args params ["_codeToRun", "_exitCode", "_condition"];

        if ([] call _condition) then {
            [] call _codeToRun;
        } else {
            _handle call CBA_fnc_removePerFrameHandler;
            [] call _exitCode;
        };
    }, _delay, [_codeToRun, _exitCode, _condition]] call CBA_fnc_addPerFrameHandler;
};

// Defines custom Variablename as String 
// missionNameSpace has only lowercase letters
private _spawnerName = toLower (["CVO_Storm_Particle_",_effectName,"_particlesource"] joinString "");



////////////////////////////////////////////////////////////////////////////////////////////////////
// Check if a spawner of that type already exists, 
// if not, create, setParticleClass, setVariables and add it to the array.
// if already exists, take previous intensity and set as start inensity. 
////////////////////////////////////////////////////////////////////////////////////////////////////

private "_spawner";

private _intensityStart = 0;
//      _intensityTarget <- initial parameter

private _DropIntervalStart = INTERVAL_MINIMUM;
private _DropIntervalMax = ([_effectName] call BIS_fnc_getCloudletParams) select 2; // #0 setParticleParams, #1 setParticleRandom, #2 setDropInterval
private _DropIntervalTarget = linearConversion [0, 1, _intensityTarget, INTERVAL_MINIMUM, _DropIntervalMax, true];


private _index = CVO_Storm_Local_PE_Spawner_array findIf { _spawnerName isEqualTo _x getVariable [ "CVO_PE_Spawner_Name" , "" ] };

if (_index == -1) then {
    _spawner = "#particlesource" createVehicleLocal [0,0,0];
    _spawner setParticleClass _effectName;

    _spawner setVariable ["CVO_PE_Spawner_Name", _spawnerName]; 
    _spawner setVariable ["CVO_PE_Spawner_Intensity", _intensity];
    CVO_Storm_Local_PE_Spawner_array pushback _spawner;

} else {
    _spawner = CVO_Storm_Local_PE_Spawner_array select _index;
    _intensityStart = _spawner getVariable ["CVO_PE_Spawner_Intensity", 0];
};





////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// Particle Intensity will simply be adjusted over time via setDropInterval /////////////
///////////// Maybe in Future, Intensity could be applied via colorAlpha, Size, ...    /////////////
///////////// Problem: bad solution solution for non-dust-like particles like leafes   /////////////
///////////// Therefore, for now, particle quantitiy has been chosen as the regulator  /////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// establish current intensity from 0 to "input" intensity.

private _startTime = time;
private _endTime = _startTime + _duration;

//// params inside the pfEH
private _parameters = [ _spawner, _startTime, _endTime, _effectArray,  ];

private _codeToRun = {  _this#0 setDropInterval  linearConversion [_startTime,_endTime, time, ,_effectArray#2];  }; 

private _exitCode = {   _this#0 setDropInterval  _effectArray#2; }; // Add check: If target intensity ==  0, delete particle spawner and array entry.

private _condition = { _endTime >= time };

private _delay = PFEH_INTENSITY_DELAY;

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


