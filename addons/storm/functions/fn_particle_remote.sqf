/*
 * Author: [Zorn]
 * Function to apply the Particle Effect Spawners on each client locally.
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
 * [] remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
 * 
 * Public: No
 */

// https://github.com/CBATeam/CBA_A3/wiki/Per-Frame-Handlers
// macro beispiel: #define BURN_THRESHOLD 1


#define COEF_SPEED 5
#define COEF_WIND 0.2
#define PFEH_DELAY 1


if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_effectArray", [], [[]]],
    ["_duration",     0, [0]]
];

if (_effectArray isEqualTo []) exitWith {};
if (_effectName  isEqualTo "") exitWith {};
if (_duration    isEqualTo  0) exitWith {};

if {isNil "CVO_Storm_Local_Particle_Spawner_array"} then {
    CVO_Storm_Local_Particle_Spawner_array = [];

    // Adds Debug_Helper Object (arrow)
    if (missionNamespace getVariable ["CVO_Debug", false]) then {
        if (isNil "CVO_Storm_Particle_Helper") then {
            CVO_Storm_Particle_Helper = createVehicleLocal ["Sign_Arrow_Large_F", [0,0,0] ];
            CVO_Storm_Local_Particle_Spawner_array pushback CVO_Storm_Particle_Helper;
        };
    };

    // Start pfEH to re-attach all Particle Spawners according to player speed & wind.
    // watch CVO_particle_isActive, if inactive, delete particle spawners and pfEH

    private _codeToRun = {
        //_SpeedVector vectorDiff _windVector
        private _player = vehicle ace_player;  
        private _relPosArray = (( velocityModelSpace _player ) vectorMultiply COEF_SPEED) vectorDiff (( _player vectorWorldToModel wind ) vectorMultiply COEF_WIND);
        { _x attachTo [_player, _relPosArray]; } forEach CVO_Storm_Local_Particle_Spawner_array;
    };

    private _condition = { missionNameSpace getVariable ["CVO_particle_isActive", false] || count CVO_Storm_Local_Particle_Spawner_array > 0 };
    private _exitCode = { {deleteVehicle _x } forEach CVO_Storm_Local_Particle_Spawner_array; CVO_Storm_Local_Particle_Spawner_array = nil  };
    private _delay = PFEH_DELAY;

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
private _varName = toLower (["CVO_Storm_Particle_",_effectName,"_particlesource"] joinString "");


//  check if _spawner exists already, else create it.
private _spawner = missionNamespace getVariable [_varName, false];

if ( _spawner isEqualTo false ) then {
    _spawner = ("#particlesource" createVehicleLocal getPosWorld player);
    missionNamespace setVariable [_varName, _spawner, false];
    CVO_Storm_Local_Particle_Spawner_array pushback _spawner;
};



