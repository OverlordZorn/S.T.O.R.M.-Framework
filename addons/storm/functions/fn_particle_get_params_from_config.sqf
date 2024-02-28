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

_properties = [
	"particleShape",		
	"particleFSNtieth",		
	"particleFSIndex",		
	"particleFSFrameCount",	
	"particleFSLoop"
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
		_hash get "particleShape",			/* String */
		_hash get "particleFSNtieth",		/* Number */
		_hash get "particleFSIndex",		/* Number */
		_hash get "particleFSFrameCount",	/* Number */
		_hash get "particleFSLoop"		/* Optional - Number. Default: 1 */
	],
	_hash get "animationName",			/* String */
	_hash get "particleType",				/* String - Enum: Billboard, SpaceObject */
	_hash get "timerPeriod",				/* Number */
	_hash get "lifeTime",					/* Number */
	_hash get "position",					/* 3D Array of numbers as relative position to particleSource or (if object at index 18 is set) object. */
	_hash get "moveVelocity",				/* 3D Array of numbers. */
	_hash get "rotationVelocity",			/* Number */
	_hash get "weight",					/* Number */
	_hash get "volume",					/* Number */
	_hash get "rubbing",					/* Number */
	_hash get "size",			            /* Array of Numbers */
	_hash get "color",					/* Array of Array of RGBA Numbers */
	_hash get "animationSpeed",			/* Array of Number */
	_hash get "randomDirectionPeriod",	/* Number */
	_hash get "randomDirectionIntensity",	/* Number */
	_hash get "onTimerScript",			/* String */
	_hash get "beforeDestroyScript",		/* String */
	_hash get "obj",						/* Object */
	_hash get "angle",					/* Optional Number - Default: 0 */
	_hash get "onSurface",				/* Optional Boolean */
	_hash get "bounceOnSurface",			/* Optional Number */
	_hash get "emissiveColor"			/* Optional Array of Array of RGBA Numbers */
];

_returnArray;















