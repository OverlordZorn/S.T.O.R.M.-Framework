class CVO_FG_Default
{
	ppEffectType = "FilmGrain";
	ppEffectPrio = "2000";
	layer = 0;

	intensity =   0.005;		// 0..1
	sharpness =    1.25;		// 1..20
	grainSize =    2.01;		// 1..8
	intensityX0 =  0.75;		// -x..0..+x
	intensityX1 =  1.00;		// -x..0..+x
	monochromatic =   0;		// 0,1 # 0 Monochromatic # Any other value Color

	baseArray[] = {0.005, "false","false","false","false","false"};
};

class CVO_FG_Basic : CVO_FG_Default
{
	intensity =   0.1;			// 0..1
	sharpness =   0.1;			// 1..20
	grainSize =   2.0;			// 1..8
	intensityX0 = 0.1;			// -x..0..+x
	intensityX1 = 0.1;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

class CVO_FG_Storm : CVO_FG_Default
{
	intensity =   0.15;			// 0..1
	sharpness =   0.7;			// 1..20
	grainSize =   2.4;			// 1..8
	intensityX0 = 0.2;			// -x..0..+x
	intensityX1 = 0.5;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

class CVO_FG_Storm_02 : CVO_FG_Default
{
	intensity =   0.78;			// 0..1
	sharpness =   1.5;			// 1..20
	grainSize =   1.46;			// 1..8
	intensityX0 = 0.56;			// -x..0..+x
	intensityX1 = 0.69;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

