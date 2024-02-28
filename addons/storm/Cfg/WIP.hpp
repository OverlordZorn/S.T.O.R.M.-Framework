[particleShape,particleFSNtieth,particleFSIndex,particleFSFrameCount,particleFSLoop],
animationName,
particleType,
timerPeriod,
lifeTime,

position[],
moveVelocity[],

rotationVelocity, weight, volume, rubbing,

size[],

animationSpeed[],

randomDirectionPeriod, randomDirectionIntensity, 

onTimerScript,
beforeDestroyScript,
// object -> not defined via config it seems

angle,

onSurface


// Default Param Array -> Config

class CVO_PE_Dust_High : CVO_PE_Default
{
    particleShape = "\A3\data_f\cl_basic";
    particleFSNtieth = 1;
    particleFSIndex = 0;
    particleFSFrameCount = 1;
    particleFSLoop = 1;

    animationName = "";
    particleType = "Billboard";
    timerPeriod = 1;
    lifeTime = 20;

    position[] = {0, 0, 0};
    moveVelocity[] =  {-1,-1,0};

    rotationVelocity = 3;
    weight = 10.15;
    volume = 7.9;
    rubbing = 0.01;

    size[] = {10,10,20};

    color[] = {{0.65, 0.5, 0.5, 0}, {0.65, 0.6, 0.5, 0.5}, {1, 0.95, 0.8, 0}};

    animationSpeed[] = {0.08};	

    randomDirectionPeriod = 1;
    randomDirectionIntensity = 0; 

    onTimerScript = "";
    beforeDestroyScript = "";

    angle = 1;

    onSurface = "true";
};

// Default Random Array -> Config
_alias_local_fog_1 setParticleRandom [10, [0.25, 0.25, 0], [1, 1, 0], 1, 1, [0, 0, 0, 0.1], 0, 0];

class CVO_PE_Dust_High : CVO_PE_Dust_High
{
    lifeTimeVar = 10;
    positionVar[] = {0.25, 0.25, 0};
    moveVelocityVar[] = {1, 1, 0};
   	rotationVelocityVar = 1;
	sizeVar = 1;
    colorVar[] = {0, 0, 0, 0.1};	
    angleVar = 0;
  	bounceOnSurfaceVar = 0.0;
} 



// Default Circle Array -> Config
_alias_local_fog_1 setParticleCircle [20, [3, 3, 0]];

class CVO_PE_Dust_High : CVO_PE_Dust_High
{
   	circleRadius = 20;
	circleVelocity[] = {3, 3, 0};
}


