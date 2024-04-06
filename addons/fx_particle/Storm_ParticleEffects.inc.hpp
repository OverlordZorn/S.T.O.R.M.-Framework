// Emitter 3Ditor: https://steamcommunity.com/sharedfiles/filedetails/?id=1613905318

// https://community.bistudio.com/wiki/ParticleArray
// https://community.bistudio.com/wiki/setParticleParams
// https://community.bistudio.com/wiki/setParticleRandom
// https://community.bistudio.com/wiki/setParticleCircle

// https://github.com/PulsarNeutronStar/CVO_co-30_Hearts_and_Minds.lythium/blob/main/cvo/sandstorm/cvo_ss_fnc_effects.sqf#L122-L144
// https://github.com/PulsarNeutronStar/CVO_co-30_Hearts_and_Minds.lythium/blob/dbad24973bd8bb5514978c881034be08d0b227ce/cvo/sandstorm/cvo_ss_fnc_effects.sqf#L147-L152

// https://community.bistudio.com/wiki/Arma_3:_Particle_Effects
// https://community.bistudio.com/wiki/setParticleClass

// #################################################################################################################################################################################################
// !!! setParticleClass does not allow for simple expressions within statements, meaning effects with parameters defined like this < "interval = "0.5 * speedSize + 0.5" > will not get executed !!!
// #################################################################################################################################################################################################

class Default;
class GVAR(DEFAULT) : Default
{
	interval = 0.5;					    	// interval of particle's creation
	circleRadius = 0;						// radius around emitter where particles are created
	circleVelocity[] = {0, 0, 0};			// direction and speed of movement of particle's circle

	particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";	// path and name of file
	particleFSNtieth = 16;					// How many rows there are in the texture. For example Universal is 16x16, so particleFSNtieth is 16. Default: 1
	particleFSIndex = 12;					// Row index 0 based, so particleFSIndex 12 will mean 13th row from the top. Default: 0
	particleFSFrameCount = 8;					// How many frames from the start of the chosen row to animate (particleFSFrameCount 8 means animate frames 1,2,3,4,5,6 and 7 in sequence). Default: 1
	particleFSLoop = 1;						// Whether or not to repeat from the beginning when all frames got played (0 - false, 1 - true). If particleFSLoop is 0 animation sequence is played only once. Default: 1
	animationSpeed[] = {3,2,1};				// interpolated speed of animation in animation cycles per second.
												// e.g if particleFSFrameCount is 8 and animationSpeed at the time is 0.4 result in 8 * 0.5 = 4 frame changes per second.
												// Value 1000 is a special value but only when combined with particleFSLoop 0;
												// this will instruct the engine to play only the last frame of the given count, so if particleFSFrameCount is 5, animationSpeed[] is {1000} and particleFSLoop is 0 only 5th frame will be played.

	angle = 0;								// angle of particle
	angleVar = 0;							// variability in angle of particle
	animationName = "";
	particleType = "Billboard";				// type of animation (Billboard (2D), Spaceobject (3D))
	timerPeriod = 1;						// interval of timer (how often is called script defined in parameter onTimerScript)
	lifeTime = 1;							// life time of particle in seconds
	moveVelocity[] = {0, 0, 0};				// direction and speed of movement of particle [x,z,y]
	rotationVelocity = 0;					// direction and speed of rotation of particle [x,z,y]
	weight = 1;								// weight of particle (kg)
	volume = 1;								// volume of particle (m3)
	rubbing = 0.05;							// how much is particle affected by wind/air resistance
	size[] = {1,1};							// size of particle during the life
	color[] = {{1,1,1,1},{1,1,1,0}};		// color of particle during the life (r,g,b,a)
	randomDirectionPeriod = 0;				// interval of random speed change
	randomDirectionIntensity = 0;			// intensity of random speed change
	onTimerScript = "";						// script triggered by timer (in variable "this" is stored position of particle)
	beforeDestroyScript = "";				// script triggered before destroying of particle (in variable "this" is stored position of particle)
	lifeTimeVar = 0;						// variability in lifetime of particle
	position[] = {0, 0, 2};					// defines position of effect
	positionVar[] = {0, 0, 0};				// variability in position of particle (each part of vector has it is own variability)
	positionVarConst[] = {0, 0, 0};			// variability in position of particle (variablity of all parts of vector is the same)
	moveVelocityVar[] = {0, 0, 0};			// variability in direction and speed of particle (each part of vector has it is own variability)
	moveVelocityVarConst[] = {0, 0, 0};		// variability in direction and speed of particle (variablity of all parts of vector is the same)
	rotationVelocityVar = 0;				// variability in rotation of particle
	sizeVar = 0;							// variability in size of particle
	colorVar[] = {0, 0, 0, 0};				// variability in color of particle
	randomDirectionPeriodVar = 0;			// variability in interval of random speed change
	randomDirectionIntensityVar = 0;		// variability in intensity of random speed change
	sizeCoef = 1;							// size of particle = size parameter value * this coef (works only in some effects)
	colorCoef[]={1,1,1,1};					// color of particle = color parameter value * this coef (works only in some effects)
	animationSpeedCoef = 1;					// animation speed of particle = animationSpeed parameter value * this coef (works only in some effects)

	destroyOnWaterSurface = 0;				// particle can exist - only underwater (-1), only above the water (1), everywhere (0)
	destroyOnWaterSurfaceOffset = 0;		// offset of water surface in destroyOnWaterSurface parameter
	destroyAfterCrossing = "false";			// if true, destroy when the whole particle is on the other side of the water surface. Only when _destroyOnWaterSurfaceOffset is enabled, 
	onSurface = "true";					// placing of particle on (water) surface on start of it is existence, default value is true, works only if circleRadius > 0
	keepOnSurface = "false";				// true for particle is stay on water surface - see notes below
	surfaceOffset = 0; 						// offset of water surface in keepOnSurface parameter
	bounceOnSurface = 0;					// coef of speed's loosing in collision with ground, 0-1 for collisions, -1 disable collision
	bounceOnSurfaceVar = 0.0;				// variability in speed's loosing in collision with ground
	// postEffects = "";					// effect triggered before destroying of particle
	// particleEffects = "";				// emitter of effect defined in this parameter is attached to each particle
	ignoreWind = "false";					// if true, wind will not be applied on the particle 
	blockAIVisibility = "false";			// sets if particles are in the AI visibility tests (default true) - false for better performance but AI is able to see through particles
	emissiveColor[] = {{0,0,0,0},{0,0,0,0}};	// sets emissivity of particle, 4th number has no meaning for now

	// --- fire damage related parameters (optional)
	// damageType="Fire";					// damage type, only available option is "Fire" so far
	// coreIntensity = 1.25;				// damage coeficient in the center of fire
	// coreDistance = 3.0;					// how far can unit get damage
	// damageTime = 0.1;					// how often is unit getting damage 

	// --- override of global particle quality params
	// --- current values are in, for example:
	// --- getNumber (((configFile >> "CfgVideoOptions" >> "Particles") select particlesQuality) >> "smokeGenMinDist");
	// smokeGenMinDist = 100;				// for more info see "Changes dependent on distance"
	// smokeGenMaxDist = 500;				// for more info see "Changes dependent on distance"
	// smokeSizeCoef = 2.0;				// for more info see "Changes dependent on distance"
	// smokeIntervalCoef = 4.0;			// for more info see "Changes dependent on distance"

	// additional Meta Data
	// obj = "objNull";
	interval_min = 2;
};

class GVAR(Dust_High) : GVAR(DEFAULT)
{
    particleShape = "\A3\data_f\cl_basic";
    particleFSNtieth = 1;
    particleFSIndex = 0;
    particleFSFrameCount = 1;
    particleFSLoop = 1;

    animationName = "";
    particleType = "Billboard";
    timerPeriod = 1;
    lifeTime = 30;

    position[] = {0, 0, 3};
    moveVelocity[] =  {0,5,5};

    rotationVelocity = 3;
    weight = 1.10;
    volume = 0.85;
    rubbing = 0.01;

    size[] = {0,1,3,5,7,4,1};

    color[] = {
		{0.65, 0.5, 0.5, 0.01}, 
		{0.65, 0.6, 0.5, 0.03}, 
		{1,   0.95, 0.8, 0.07},
		{1,   0.95, 0.8, 0.10},
		{1,   0.95, 0.8, 0.07},
		{0.65, 0.6, 0.5, 0.01}, 
		{0.65, 0.6, 0.5, 0.00}
	};

    animationSpeed[] = {0.08};	

    randomDirectionPeriod = 1;
    randomDirectionIntensity = 0; 

    onTimerScript = "";
    beforeDestroyScript = "";

    angle = 1;

    onSurface = "true";

	// setParticleRandom
    lifeTimeVar = 10;
    positionVar[] = {10, 10, 10};
    moveVelocityVar[] = {0, 5, 5};
   	rotationVelocityVar = 1;
	sizeVar = 0;
    colorVar[] = {0, 0, 0, 0.05};	
    angleVar = 0;

	bounceOnSurface = 1;
  	bounceOnSurfaceVar = 0.0;

	// setParticleCircle
   	circleRadius = 35;
	circleVelocity[] = {-3, -3, 2};

	// setDropInterval
	interval = 0.01;					    // interval of particle's creation
	// 0.01+random 0.1

	interval_min = 1;

};


class GVAR(Dust_High_100) : GVAR(Dust_High)
{
   	circleRadius = 100;
};

class GVAR(Dust_High_50) : GVAR(Dust_High)
{
   	circleRadius = 50;
};

class GVAR(Dust_High_35) : GVAR(Dust_High)
{
   	circleRadius = 35;
};



class GVAR(Dust_Low) : GVAR(Dust_High) 
{
    size[] = {0,3,7,10,7,3,0};
};

// Twigs
class GVAR(Branches) : GVAR(DEFAULT)
{
    particleShape = "\A3\data_f\ParticleEffects\Hit_Leaves\Sticks_Green";
    particleFSNtieth = 1;
    particleFSIndex = 1;
    particleFSFrameCount = 1;
    particleFSLoop = 1;

    animationName = "";
    particleType = "SpaceObject";
    timerPeriod = 1;
    lifeTime = 27;

    position[] = {0, 0, 3};
    moveVelocity[] =  {0,0,3};

    rotationVelocity = 0;
    weight = 0.000002;
    volume = 0.0;
    rubbing = 0.3;

    size[] = {0.01};

    color[] = {{0.68, 0.68, 0.68, 1}};

    animationSpeed[] = {1.5, 1};	

    randomDirectionPeriod = 13;
    randomDirectionIntensity = 13; 

    onTimerScript = "";
    beforeDestroyScript = "";

    angle = 0;

    onSurface = "true";
	bounceOnSurface = 1;

	emissiveColor[] = {{0,0,0,0}};

	// setParticleRandom
	sizeVar = 5;
    lifeTimeVar = 0;
    positionVar[] = {25, 25, 5};
    moveVelocityVar[] = {3, 3, 1};
   	rotationVelocityVar = 2;
    colorVar[] = {0, 0, 0, 0.1};	
    angleVar = 1;
  	bounceOnSurfaceVar = 1;

	// setParticleCircle
   	circleRadius = 75;
	circleVelocity[] = {-2, -2, 1};

	// setDropInterval
	interval = 0.15;					    // interval of particle's creation
	// 0.01+random 0.1
	interval_min = 2;

};


/*
class particle_emitter_0: Default
{
	interval = 0.03;
	circleRadius = 50;
	circleVelocity[] = {0,-1,0};
	particleFSNtieth = 16;
	particleFSIndex = 12;
	particleFSFrameCount = 13;
	particleFSLoop = 0;
	angleVar = 0;
	particleShape = "\A3\data_f\ParticleEffects\Universal\Universal.p3d";
	particleType = "Billboard";
	timerPeriod = 1;
	lifeTime = 15;
	moveVelocity[] = {2,0,2};
	rotationVelocity = 1;
	weight = 0.053;
	volume = 0.04;
	rubbing = 0.01;
	size[] = {13,15};
	color[] =
	{
			{0.08,0.067,0.052,0},
			{0.6,0.5,0.4,0.2012},
			{0.42618,0.431949,0.420412,0.183895},
			{0.6,0.5,0.4,0.166588},
			{0.6,0.5,0.4,0.15},
			{0.6,0.5,0.4,0}
	};
	animationSpeed[] = {1000};
	randomDirectionPeriod = 0.1;
	randomDirectionIntensity = 0.05;
	onTimerScript = "";
	beforeDestroyScript = "";
	lifeTimeVar = 5;
	positionVar[] = {5,1,5};
	moveVelocityVar[] = {5,1,5};
	rotationVelocityVar = 20;
	sizeVar = 0.3;
	colorVar[] = {0,0,0,0};
	randomDirectionPeriodVar = 0;
	randomDirectionIntensityVar = 0;
	coreIntensity = 0;
	coreDistance = 0;
	damageTime = 0;
	damageType = "";
	angle = 0;
	position[] = {0,0,0};
};


*/