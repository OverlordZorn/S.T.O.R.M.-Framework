#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Creates, Adjusts and ParticleEffects over time with intensity. 
 *
 * Arguments:
 * 0: _PE_effect_Name    <STRING> Name of Particle Effect Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * _pe_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_PE_Default", 5, 0.5] call cvo_storm_fnc_particle_request;
 * 
 * Public: No
 */

if (!isServer) exitWith { _this remoteExecCall [ "cvo_storm_fnc_particle_request", 2, false]; };


params [
   ["_PE_effect_Name",        "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",              0,  [0]]
];

if (_PE_effect_Name isEqualTo "")         exitWith { diag_log "[CVO](debug)(fn_particle_request) Failed - no effect name given"; false };
if (_duration isEqualTo 0)                exitWith { diag_log "[CVO](debug)(fn_particle_request) Failed - Duration of 0 "; false };

_duration = (_duration max 1) * 60;
_intensity = _intensity max 0 min 1;

diag_log format ["[CVO][STORM](Particle_request) - name: %1 - _duration: %2- _intensity: %3", _PE_effect_Name, _duration, _intensity];


//Check if config Exists
if !(_PE_effect_Name in (configProperties [configFile >> "CVO_PE_Effects", "true", true] apply { configName _x })) exitWith {    diag_log format ["[CVO][STORM](Particle_request) Failed: provided PE_Effect_name doesnt exist: %1", _PE_effect_Name]; false };


// Check if can transition to 0 (Needs effect to be already active)
private _jip_handle_string = [_PE_effect_Name,"_JIP_HANDLE"] joinString "";
if ( _intensity == 0 && { isNil "CVO_PE_active_jips" || { !(_jip_handle_string in CVO_PE_active_jips)} } ) exitWith {   diag_log "[CVO](STORM)(Particle_request) Failed: _intensity 0 while no previous effect of same type exists"; };

if (isNil "CVO_PE_inTransition") then { CVO_PE_inTransition = []; };

private _inTransition_str = ["CVO_STORM",_PE_effect_Name] joinString "_";
if (_inTransition_str in CVO_PE_inTransition) exitWith {diag_log "[CVO](debug)(Particle_request) Failed: This Particle Effect is currently in Transition"};
diag_log format ['[CVO](debug)(Particle_request) Request Passed: _PE_effect_Name: %1 - _duration: %2 - _intensity: %3', _pp_effect_Name , _duration ,_intensity];

/////////////////////////////////////////////////////////////////////////////
// RemoteExec the request
private _jip_handle_string = [_PE_effect_Name, _duration, _intensity] remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];
if (isNil "_jip_handle_string") exitWith {
    diag_log format ["[CVO][STORM](Error)(Particle_request) - Not Successful: %1", _PE_effect_Name];
    false
};
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// Handles In-Transition-Check
CVO_PE_inTransition pushBack _inTransition_str;
[{  
    CVO_PE_inTransition = CVO_PE_inTransition - [_this#0];
    // diag_log format ['[CVO](debug)(Particle_request)Transition compeleted - Item removed: _this#0: %1', _this#0];
}, [_inTransition_str], _duration] call CBA_fnc_waitAndExecute;

/////////////////////////////////////////////////////////////////////////////


if (_intensity == 0) then {
    // Handles Cleanup of JIP in case of decaying(transition-> 0) Effect once transition to 0 is completed.
    [{
        CVO_PE_active_jips = CVO_PE_active_jips - [_this#0];
        remoteExec ["", _this#0]; // removes entry from JIP Queue
        // diag_log format ['[CVO](debug)(fn_ppEffect_request) JIP Handler cleaned up: %1', _this#0];
        // diag_log format ['[CVO](debug)(fn_ppEffect_request) Remaining JIP Array: %1', CVO_PE_active_jips];
    }, [_jip_handle_string], _duration] call CBA_fnc_waitAndExecute;

    "";
} else {
    if (isNil "CVO_PE_active_jips") then {
        CVO_PE_active_jips = [];
    };

    CVO_PE_active_jips pushBackUnique _jip_handle_string;
        // diag_log format ['[CVO](debug)(fn_ppEffect_request) JIP added: %1', _jip_handle_string];
        // diag_log format ['[CVO](debug)(fn_ppEffect_request) JIP Array: %1', CVO_PE_active_jips];
    _jip_handle_string
};

