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


if (!hasInterface) exitWith {};

params [
    ["_effectName",  "", [""]],
    ["_effectArray", [], [[]]],
    ["_duration",     5, [0]]
];

if (_effectArray isEqualTo []) exitWith {};


if !(missionNamespace getVariable ["CVO_Storm_particle_local_helper",false] isEqualType objNull) then {

    private _helperObjClassName = ["Helper_Base_F", "Sign_Arrow_F"] select  (missionNamespace getVariable ["CVO_Debug", false]);
   

    CVO_Storm_particle_local_helper = createVehicleLocal [_helperObjClassName, [0,0,0]];
};






// Defines custom Variablename as String 
// missionNameSpace has only lowercase letters
private _varName = toLower (["CVO_Storm_",_ppEffectType,"_",_layer,"_PP_Effect_Handle"] joinString "");

diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _varName : %1", _varName];

// Creates the custom Variable if it doesnt exist yet
_existsVar = missionNamespace getVariable [_varName, false];

diag_log format ["[CVO][STORM](LOG)(fnc_remote_ppEffect) - _existsVar : %1", _existsVar];



// https://github.com/CBATeam/CBA_A3/wiki/Per-Frame-Handlers