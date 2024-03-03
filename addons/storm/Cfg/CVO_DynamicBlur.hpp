class CVO_DB_Default
{
	ppEffectType = "DynamicBlur";
	ppEffectPrio = "401";				// 400 seems to be already used by *something*
	layer = 0;

	blurriness =   0.00;		// 0..
};

class CVO_DB_10 : CVO_DB_Default
{
	blurriness =   0.10;
};

class CVO_DB_15 : CVO_DB_Default
{
	blurriness =   0.15;
};

class CVO_DB_20 : CVO_DB_Default
{
	blurriness =   0.20;
};

class CVO_DB_25 : CVO_DB_Default
{
	blurriness =   0.25;
};

class CVO_DB_30 : CVO_DB_Default
{
	blurriness =   0.30;
};