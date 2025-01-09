// AVOID 0.0 for sharpness, potential engine/driver issue for AMD GPU's -> Can cause fully black pixels

class GVAR(FG_Default)
{
	ppEffectType = "FilmGrain";
	ppEffectPrio = "2000";
	ppEffectLayer = 0;

	intensity =   0.005;		// 0..1
	sharpness =    1.25;		// 1..20
	grainSize =    2.01;		// 1..8
	intensityX0 =  0.75;		// -x..0..+x
	intensityX1 =  1.00;		// -x..0..+x
	monochromatic =   0;		// 0,1 # 0 Monochromatic # Any other value Color

	baseArray[] = {0.005, "false","false","false","false","false"};
};

class GVAR(FG_Basic) : GVAR(FG_Default)
{
	intensity =   0.1;			// 0..1
	sharpness =   0.1;			// 1..20
	grainSize =   2.0;			// 1..8
	intensityX0 = 0.1;			// -x..0..+x
	intensityX1 = 0.1;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

class GVAR(FG_Storm) : GVAR(FG_Default)
{
	intensity =   0.15;			// 0..1
	sharpness =   0.7;			// 1..20
	grainSize =   2.4;			// 1..8
	intensityX0 = 0.2;			// -x..0..+x
	intensityX1 = 0.5;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

class GVAR(FG_Storm_10) : GVAR(FG_Default)
{
	intensity =   0.10;			// 0..1
	sharpness =   0.01;			// 1..20
	grainSize =   1.0;			// 1..8
	intensityX0 = 0.1;			// -x..0..+x
	intensityX1 = 0.0;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};


class GVAR(FG_Storm_02) : GVAR(FG_Default)
{
	intensity =   0.78;			// 0..1
	sharpness =   1.5;			// 1..20
	grainSize =   1.46;			// 1..8
	intensityX0 = 0.56;			// -x..0..+x
	intensityX1 = 0.69;			// -x..0..+x
	monochromatic = 0;			// 0,1 # 0 Monochromatic # Any other value Color
};

