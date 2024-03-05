/*
 * Author: [Zorn]
 * Function to apply the Particle Effects - Handles creation, deletion and adjustment of intensity of particlespawners on each client locally.
 * Intensity will be regulated simply by dropInterval (The bigger the number, the less particles)
 * If the same Effect has already been called, it will instead adjust the already existing PE spawner.
 * If _intensityTarget == 0, the function will ether exit in case the spawner doesnt exist already or transition the spawner to 0 intensity and afterwards, the spawner will be deleted.  
 * If a transition is currently taking place (CVO_Storm_Local_PE_Spawner_array#_x#3), then the funciton will simply fail silently.
 *
 * Arguments:
 * 0: _EffectName           <STRING> CfgCloudlet Classname of the desired Particle Effect. 
 * 1: _intensityTarget      <Number> 0..1 Intensity of Effect with 1 having the strongest Effect. 
 * 2: _duration             <Number> in seconds. Defines the Duration of the Transition. 
 *
 * Return Value:
 * none - intended to be remoteExecCall -> returns JIP Handle
 *
 * Note: 
 *
 * Example:
 *
 * ["CVO_PE_Leafes", 600, 0.75] remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
 * ["CVO_PE_Leafes", 600]       remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
 * ["CLEANUP"]                  remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
 * ["CVO_PE_Leafes"]                      call   cvo_storm_fnc_particle_remote;
 * ["CLEANUP"]                            call   cvo_storm_fnc_particle_remote;
 * 
 * Public: No
 */

#define COEF_SPEED 6
#define COEF_WIND  0.2
#define PFEH_ATTACH_DELAY 0
#define PFEH_INTENSITY_DELAY 7 // _duration /  PFEH_INTENSITY_DELAY == _delay
#define DROP_INTERVAL_MIN 20



if (!hasInterface) exitWith {};

params [
    ["_effectName",        "",       [""]],
    ["_duration",         300,        [0]],
    ["_intensityTarget",    0,        [0]]
];

if ( _effectName isEqualTo "CLEANUP")  exitWith {
    if ( missionNamespace getVariable ["CVO_Debug", false] ) then {
        deleteVehicle (CVO_Storm_Local_PE_Spawner_array#0#0); 
        CVO_Storm_Local_PE_Spawner_array deleteAt 0;
    };

    {  
        [_x#1] call cvo_storm_fnc_particle_remote;
    } forEach CVO_Storm_Local_PE_Spawner_array;
};

if ( _effectName isEqualTo "")  exitWith {false};
if (_intensityTarget < 0     )  exitWith {false};
if (_duration    isEqualTo  0)  exitWith {false};

if (isNil "CVO_Storm_Local_PE_Spawner_array") then {
    CVO_Storm_Local_PE_Spawner_array = [];
    CVO_particle_isActive = true;

    // Adds Debug_Helper Object (arrow)
    if (missionNamespace getVariable ["CVO_Debug", false]) then {
            _helper = createVehicleLocal [ "Sign_Arrow_Large_F", [0,0,0] ];
            CVO_Storm_Local_PE_Spawner_array pushback [_helper, "Debug_Helper"];
    };

    // Start pfEH to re-attach all Particle Spawners according to player speed & wind.
    // watch CVO_particle_isActive, if inactive, delete remaining particle spawners, the particle array and exit the pfH

    private _codeToRun = {
        private _player = vehicle ace_player;  
        //_SpeedVector vectorDiff _windVector
        private _relPosArray = (( velocityModelSpace _player ) vectorMultiply COEF_SPEED) vectorDiff (( _player vectorWorldToModel wind ) vectorMultiply COEF_WIND);
        _relPosArray set [2, (_relPosArray#2) + 1 ];
        { _x#0 attachTo [_player, _relPosArray]; } forEach CVO_Storm_Local_PE_Spawner_array;
    };

    private _exitCode  = { 
    diag_log "reAttach pfEH Exit";
        { deleteVehicle (_x#0) } forEach CVO_Storm_Local_PE_Spawner_array; 
        CVO_Storm_Local_PE_Spawner_array = nil;  
    };

    private _condition = { ( missionNameSpace getVariable ["CVO_particle_isActive", false] ) };
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

////////////////////////////////////////////////////////////////////////////////////////////////////
// Check if a spawner of that type already exists, 
// if not, create, setParticleClass, store as array [_obj,_name,_intensity] and add it to the array.
// if already exists, take previous intensity and set as start inensity. 
////////////////////////////////////////////////////////////////////////////////////////////////////

private _intensityStart = 0;
private _index = CVO_Storm_Local_PE_Spawner_array findIf { _x#1 isEqualTo _effectName };

private _dropIntervalStart = DROP_INTERVAL_MIN;
private _dropIntervalMax = ([_effectName] call BIS_fnc_getCloudletParams) select 2; // #0 setParticleParams, #1 setParticleRandom, #2 setDropInterval
private _dropIntervalTarget = linearConversion [0, 1, _intensityTarget, _dropIntervalStart, _dropIntervalMax, true];


private "_spawner";
if (_index == -1) then {

    // Interrupts cration of a new particle spwaner if the target intensity is 0. 
    if (_intensityTarget == 0) exitWith {
        // Stops the reAttach pfh there is no other already existing particlesource. 
        if ( count CVO_Storm_Local_PE_Spawner_array == ( parseNumber ( missionNamespace getVariable ["CVO_Debug", false] ) ) ) then {
            CVO_particle_isActive = false;
        };
        false
    };

    _spawner = createVehicleLocal ["#particlesource", [0,0,0]];
    _spawner setParticleClass _effectName;

    _isTransitioning = true;
    CVO_Storm_Local_PE_Spawner_array pushback [_spawner, _effectName, _intensityTarget,_isTransitioning];

} else {
    _spawnerArray = CVO_Storm_Local_PE_Spawner_array select _index;

    if (_spawnerArray#3) exitWith {false}; // exits when transition of this PE is already in progress.    
    
    _spawner = _spawnerArray#0; 
    _intensityStart = _spawnerArray#2;
    _spawnerArray set [3, true];
    _dropIntervalStart = linearConversion [0, 1, _intensityTarget, DROP_INTERVAL_MIN, _dropIntervalMax, true];
};

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//                      Per Frame Handler for the Transition of the Effect
////////////////////////////////////////////////////////////////////////////////////////////////////
///////////// Particle Intensity will simply be adjusted over time via setDropInterval /////////////
///////////// Maybe in Future, Intensity could be applied via colorAlpha, Size, ...    /////////////
///////////// Problem: bad solution solution for non-dust-like particles like leafes   /////////////
///////////// Therefore, for now, particle quantitiy has been chosen as the regulator  /////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

private _startTime = time;
private _endTime = _startTime + _duration;


//// params inside the pfEH
private _parameters = [ _spawner, _startTime, _endTime, _dropIntervalStart, _dropIntervalTarget, _intensityTarget ];

private _codeToRun = {
    params [ "_spawner", "_startTime", "_endTime", "_dropIntervalStart", "_dropIntervalTarget", "_intensityTarget" ];
    _drop = linearConversion [ _startTime, _endTime, time, _dropIntervalStart, _dropIntervalTarget ];
    _spawner setDropInterval _drop;
}; 

private _exitCode = {   
    params [ "_spawner", "_startTime", "_endTime", "_dropIntervalStart", "_dropIntervalTarget", "_intensityTarget" ];
    diag_log "Transition pfEH Exit";


    private _index = CVO_Storm_Local_PE_Spawner_array findIf { _x#0 isEqualTo _spawner };

    (CVO_Storm_Local_PE_Spawner_array select _index) set [3, false];


    _spawner setDropInterval  _dropIntervalTarget; 
    if ( _intensityTarget isEqualTo 0) then {

        diag_log "Transition pfEH Exit - Intensity == 0 -> Spawner Deleted";
        CVO_Storm_Local_PE_Spawner_array deleteAt _index;   
        deleteVehicle _spawner;


        if ( count CVO_Storm_Local_PE_Spawner_array == ( parseNumber ( missionNamespace getVariable ["CVO_Debug", false] ) ) ) then {
            CVO_particle_isActive = false;
        };

        
    };
};

private _condition = {  _this#2 >= time };

private _delay = _duration / PFEH_INTENSITY_DELAY;

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


////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// ## TODO ## /////////////////////////////////////////////////
/////////////////// Handling of the Debug_arrow during "CLEANUP" could be optimized, ///////////////
/////////////////// but its happening so rarely, i dont think its gonna be necessary ///////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
