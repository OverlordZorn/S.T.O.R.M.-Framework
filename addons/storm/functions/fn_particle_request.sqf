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

 if !(isServer) exitWith {};

params [
   ["_PE_effect_Name",        "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",              0,  [0]]
];

if (_PE_effect_Name isEqualTo "")         exitWith { diag_log "[CVO](debug)(fn_particle_request) Failed - no effect name given"; false };
if (_duration isEqualTo 0)                exitWith { diag_log "[CVO](debug)(fn_particle_request) Failed - Duration of 0 "; false };

_duration = _duration max 1;
_duration = _duration * 60;

_intensity = _intensity max 0;
_intensity = _intensity min 1;


diag_log format ["[CVO][STORM](Particle_request) - name: %1 - _duration: %2- _intensity: %3", _PE_effect_Name, _duration, _intensity];

// Adjusts Duration to secounds.
_duration = _duration * 60;

// get particleParams Array, check if its "false": fail or store _array
private _array  = [_PE_effect_Name] call cvo_storm_fnc_particle_get_params_from_config;
if (_array isEqualTo false) exitWith {   diag_log format ["[CVO][STORM](Particle_request)(Error) - particle_get_params_from_config returned False: %1", _array]; false};
diag_log format ["[CVO][STORM](Weather_request) - _array: %1", _array];

// take the target Array and apply 

// remoteExec  

private _jip_handle_string = [_PE_effect_Name,"_JIP_HANDLE"] joinString "";



[_PE_effect_Name, _duration, _intensity] remoteExecCall ["cvo_storm_fnc_particle_remote",0, _jip_handle_string];





// remoteExec ["", "MY_JIP_ID"]; // the "MY_JIP_ID" order is removed from the JIP queue