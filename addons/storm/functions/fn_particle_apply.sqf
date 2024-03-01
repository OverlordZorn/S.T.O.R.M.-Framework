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
 * ["CVO_PE_Default", 5, 0.5] call cvo_storm_fnc_particle_apply;
 * 
 * Public: No
 */

 if !(isServer) exitWith {};

params [
   ["_PE_effect_Name",        "", [""]],
   ["_duration",               0,  [0]],
   ["_intensity",              0,  [0]]
];

if (_PE_effect_Name isEqualTo "")         exitWith { false };
if (_duration isEqualTo 0)                exitWith { false };
if (_intensity <= 0 )                     exitWith { false };

diag_log format ["[CVO][STORM](Particle_Apply) - name: %1 - _duration: %2- _intensity: %3", _PE_effect_Name, _duration, _intensity];

if (isNil "CVO_particle_isActive") then {
   CVO_particle_isActive = true;
   publicVariable "CVO_particle_isActive";
};

// Adjusts Duration to secounds.
_duration = _duration * 60;

// get particleParams Array, check if its "false": fail or store _array
private _array  = [_PE_effect_Name] call cvo_storm_fnc_particle_get_params_from_config;
if (_array isEqualTo false) exitWith {   diag_log format ["[CVO][STORM](Particle_Apply)(Error) - particle_get_params_from_config returned False: %1", _array]; };
diag_log format ["[CVO][STORM](Weather_Apply) - _array: %1", _array];

// take the target Array and apply 





// remoteExec  




