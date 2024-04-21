class GVAR(DB_Default)
{
	ppEffectType = "DynamicBlur";
	ppEffectPrio = "401";				// 400 seems to be already used by *something*
	ppEffectLayer = 0;

	blurriness =   0.00;		// 0..
	
	baseArray[] = {0};
};

class GVAR(DB_05) : GVAR(DB_Default)
{
	blurriness =   0.05;
};


class GVAR(DB_10) : GVAR(DB_Default)
{
	blurriness =   0.10;
};

class GVAR(DB_15) : GVAR(DB_Default)
{
	blurriness =   0.15;
};

class GVAR(DB_20) : GVAR(DB_Default)
{
	blurriness =   0.20;
};

class GVAR(DB_25) : GVAR(DB_Default)
{
	blurriness =   0.25;
};

class GVAR(DB_30) : GVAR(DB_Default)
{
	blurriness =   0.30;
};

