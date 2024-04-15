class GVAR(CC_Default)
{
	ppEffectType = "ColorCorrections";
	ppEffectPrio = "1500";
	ppEffectLayer = 0;

	brightness = 1;															
	contrast = 1;
	offset = 0;
	
	blending_rgba[] = 		{		0,		0,		0,		0	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{		1,		1,		1,		1	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	0.299, 	0.587, 	0.114, 		0	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation

/*
	radial_color[] = {
		-1,												// 0..1			major axis radius of ellipse
		-1,												// 0..1			minor axis radius of ellipse
		 0,												// 0..359		rotation of ellipse axis (in degrees) 
		 0,												// -0.5 .. 0.5	centerX of ellipse on the screen (in relative coords)  where 0 is screen center
		 0,												// -0.5 .. 0.5	centerY of ellipse on the screen (in relative coords) -0.5 .. 0.5 where 0 is screen center
		 0,												// 0..1			coefficient for inner radius (where effect is not applied)
		 1												// 0..			coefficient for color interpolation between inner and outer radius
	}; 
*/

	baseArray[] = { 1, 1, 0, {"false","false","false",0},{"false","false","false",1},{"false","false","false",0}  };

};

class GVAR(CC_Alias) : GVAR(CC_Default)
{
	brightness = 0.86;
	offset = 0.01;
	blending_rgba[] = 		{	-0.14,	 0.17, 	 0.33,	-0.14	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	 0.86,	 -0.4,	 0.86,	 0.86	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	-0.57,	 0.86,	 -1.2,   0.86	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};

class GVAR(CC_01) : GVAR(CC_Default)
{
	brightness = 	0.98;
	contrast = 		0.93;
	offset = 		0.08;
	blending_rgba[] = 		{	-0.28,	-0.28, 	-0.81,	-0.04	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	 1.23,	 0.44,	-0.54,	 0.57	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	 0.33,	 0.33,   0.33,   0.00	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};


class GVAR(CC_Mars_Storm) : GVAR(CC_Default)
{
	brightness = 	0.80;
	contrast = 		0.80;
	offset = 		0.05;
	blending_rgba[] = 		{	  0.5,	-0.10, 	-0.60,	 0.20	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	 -0.4,	 1.00,	 2.40,	 1.30	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	 0.33,	 0.33,   0.33,   0.00	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};


class GVAR(CC_Muted_Green_Yellow) : GVAR(CC_Default)
{
	brightness = 	0.80;
	contrast = 		1.00;
	offset = 		0.00;
	blending_rgba[] = 		{	 0.14,	 1.16, 	 0.26,	 0.04	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	 0.34,	 0.89,	 1.03,	 1.22	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	-0.63,	 1.73,   0.33,   0.00	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};


class GVAR(CC_Muted_Pale_Blue) : GVAR(CC_Default)
{
	brightness = 	1.07;
	contrast = 		0.90;
	offset = 		0.00;
	blending_rgba[] = 		{	-0.04,	 0.14, 		0.67,	0.12	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	 0.30,	 0.64,	 	0.74,	0.99	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	 0.33,	 0.33,   	0.33,   0.00	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};




class GVAR(CC_Frosted_Blue_Purple) : GVAR(CC_Default)
{
	brightness = 	1.00;
	contrast = 		0.90;
	offset = 		0.00;
	blending_rgba[] = 		{	0.00,	0.00,	0.30,	0.15	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{	0.89,	1.28,	1.67,	0.80	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	0.12,	0.67,	0.94,	0.00	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
};


class GVAR(CC_ColdSnow) : GVAR(CC_Default)
{
	colorization_rgba[] = 	{	1.31,	0.81,	0.62,	1.22	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
};

class GVAR(CC_ColdSnow_Bleak) : GVAR(CC_ColdSnow)
{
	brightness = 	0.70;
	contrast = 		0.90;
	offset = 		0.10;
};
 

/* Currently not in use

class GVAR(CC_Radial_Default)
{
	ppEffectType = "ColorCorrections";
	ppEffectPrio = "1600";
	ppEffectLayer = 1;

	brightness = 1;															
	contrast = 1;
	offset = 0;
	
	blending_rgba[] = 		{		0,		0,		0,		0	};			// RGB - Color -- A - Blend Factor (0-> Original Color - 1 -> Blended Color)
	colorization_rgba[] = 	{		1,		1,		1,		1	};			// RGB - Color -- A - Saturation   (0-> Original Color - 1 -> B&W moltiplied by colorize color)
	desaturation_rgba0[] = 	{	0.299, 	0.587, 	0.114, 		0	};			// RGB - Color -- 0 - not in use? -- color rgb weights for desaturation
	
	radial_color[] = {
		-1,												// 0..1			major axis radius of ellipse
		-1,												// 0..1			minor axis radius of ellipse
		 0,												// 0..359		rotation of ellipse axis (in degrees) 
		 0,												// -0.5 .. 0.5	centerX of ellipse on the screen (in relative coords)  where 0 is screen center
		 0,												// -0.5 .. 0.5	centerY of ellipse on the screen (in relative coords) -0.5 .. 0.5 where 0 is screen center
		 0,												// 0..1			coefficient for inner radius (where effect is not applied)
		 1												// 0..			coefficient for color interpolation between inner and outer radius
	}; 	
};

class GVAR(CC_Radial_Blinking_open) : GVAR(CC_Radial_Default)
{
	brightness = 0.1;
	radial_color[] = {
		1,												// 0..1			major axis radius of ellipse
		1,												// 0..1			minor axis radius of ellipse
		 0,												// 0..359		rotation of ellipse axis (in degrees) 
		 0,												// -0.5 .. 0.5	centerX of ellipse on the screen (in relative coords)  where 0 is screen center
		 0,												// -0.5 .. 0.5	centerY of ellipse on the screen (in relative coords) -0.5 .. 0.5 where 0 is screen center
		 0,												// 0..1			coefficient for inner radius (where effect is not applied)
		 1												// 0..			coefficient for color interpolation between inner and outer radius
	};
};

class GVAR(CC_Radial_Blinking_half) : GVAR(CC_Radial_Default)
{
	brightness = 0.1;
	radial_color[] = {
		0.5,												// 0..1			major axis radius of ellipse
		0.5,												// 0..1			minor axis radius of ellipse
		 0,												// 0..359		rotation of ellipse axis (in degrees) 
		 0,												// -0.5 .. 0.5	centerX of ellipse on the screen (in relative coords)  where 0 is screen center
		 0,												// -0.5 .. 0.5	centerY of ellipse on the screen (in relative coords) -0.5 .. 0.5 where 0 is screen center
		 0,												// 0..1			coefficient for inner radius (where effect is not applied)
		 1												// 0..			coefficient for color interpolation between inner and outer radius
	};
};
class GVAR(CC_Radial_Blinking_closed) : GVAR(CC_Radial_Default)
{
	brightness = 0.1;
	radial_color[] = {
		0.5,												// 0..1			major axis radius of ellipse
		0.05,												// 0..1			minor axis radius of ellipse
		 0,												// 0..359		rotation of ellipse axis (in degrees) 
		 0,												// -0.5 .. 0.5	centerX of ellipse on the screen (in relative coords)  where 0 is screen center
		 0,												// -0.5 .. 0.5	centerY of ellipse on the screen (in relative coords) -0.5 .. 0.5 where 0 is screen center
		 0,												// 0..1			coefficient for inner radius (where effect is not applied)
		 1												// 0..			coefficient for color interpolation between inner and outer radius
	};
};

*/