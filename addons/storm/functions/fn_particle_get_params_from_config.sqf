/*
 * Author: [Zorn]
 * Extracts Particle Effects Parameters from Config Class in suitable format for setParticleParams command.
 *
 * Arguments:
 * 0: _PE_effect_Name    <STRING> Name of any Post Process Preset - Capitalisation needs to be exact!
 *
 * Return Value:
 * effect-array for setParticleParams 
 *
 * Note: 
 *
 * Example:
 * ["CVO_PE_Leafes"] call cvo_storm_fnc_particle_get_params_from_config;
 * 
 * Public: No
 */

params [   ["_PE_effect_name", "", [""]]    ];


//Check if EffectName given
if (_PE_effect_name isEqualTo "") exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_particle_get_params_from_config) - no _PE_effect_name provided: %1", _PE_effect_name];
    false
};

//Check if config Exists
if !(_PE_effect_name in (configProperties [configFile >> "CfgCloudlets", "true", true] apply { configName _x })) exitWith {
    diag_log format ["[CVO][STORM](Error)(fnc_particle_get_params_from_config) - provided _PE_effect_name doesnt exist: %1", _PE_effect_name];
    false
};


private _hash = createHashMap;

private _properties = [
	"particleShape",		
	"particleFSNtieth",		
	"particleFSIndex",		
	"particleFSFrameCount",	
	"particleFSLoop",
	"animationName",		
	"particleType",			
	"timerPeriod",			
	"lifeTime",				
	"position",				
	"moveVelocity",			
	"rotationVelocity",		
	"weight",				
	"volume",				
	"rubbing",				
	"size",			        
	"color",				
	"animationSpeed",		
	"randomDirectionPeriod",
	"randomDirectionIntensity",	
	"onTimerScript",			
	"beforeDestroyScript",		
	"obj",						
	"angle",					
	"onSurface",				
	"bounceOnSurface",			
	"emissiveColor"
];

private _configPath = (configFile >> "CfgCloudlets" >> _PE_effect_name ); 

{
    _value = [_configPath, _x] call BIS_fnc_returnConfigEntry;
    _hash set [_x, _value];
} forEach _properties;

_returnArray = [
	[
		_hash get "particleShape",			
		_hash get "particleFSNtieth",		
		_hash get "particleFSIndex",		
		_hash get "particleFSFrameCount",	
		_hash get "particleFSLoop"		
	],
	_hash get "animationName",			
	_hash get "particleType",			
	_hash get "timerPeriod",			
	_hash get "lifeTime",				
	_hash get "position",				
	_hash get "moveVelocity",			
	_hash get "rotationVelocity",		
	_hash get "weight",					
	_hash get "volume",					
	_hash get "rubbing",				
	_hash get "size",			        
	_hash get "color",					
	_hash get "animationSpeed",			
	_hash get "randomDirectionPeriod",	
	_hash get "randomDirectionIntensity",	
	_hash get "onTimerScript",			
	_hash get "beforeDestroyScript",	
	switch (_hash get "obj") do {
		case "objNull": { objNull };
		case "player": { player };
		case Default { _hash get "obj" };
	},					
	_hash get "angle",					
	switch (_hash get "onSurface") do {
		case "true": { true };
		case "false": { false };
	},				
	_hash get "bounceOnSurface",		
	_hash get "emissiveColor"
];

_returnArray