class CVO_DB_Default
{
	ppEffectType = "DynamicBlur";
	ppEffectPrio = "401";				// 400 seems to be already used by *something*
	layer = 0;

	blurriness =   0.00;		// 0..
};

class CVO_DB_Basic : CVO_DB_Default
{
	blurriness =   0.10;
};

class CVO_DB_Storm : CVO_DB_Default
{
	blurriness =   0.30;
};