
class CfgSFX
{

	class CVO_SFX_Base
	{
		empty[] = { "", 0, 0, 0, 0, 0, 0, 0 };
	};

   	class CVO_SFX_WindBursts : CVO_SFX_Base
	{
        name = "CVO Storm - Windburst Soundeffects";
        description = "~10s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { PATH_TO_ADDON_2(data,sandstorm.ogg), "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound1[] = { PATH_TO_ADDON_2(data,windburst_1.ogg), "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound2[] = { PATH_TO_ADDON_2(data,windburst_2.ogg), "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound3[] = { PATH_TO_ADDON_2(data,windburst_3_dr.ogg), "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound4[] = { PATH_TO_ADDON_2(data,windburst_4_st.ogg), "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sounds[] = { "sound0", "sound1", "sound2","sound3","sound4" };
	};

   	class CVO_SFX_WindLong : CVO_SFX_Base
	{
        name = "CVO Storm - Long Storm Soundeffects";
        description = "~60s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { PATH_TO_ADDON_2(data,hurricane.ogg), "db-0", 1.0, 50000, 1, 0, 3, 5 };	// path to addon sound
		sound1[] = { PATH_TO_ADDON_2(data,strong_wind.ogg), "db-0", 1.0, 50000, 1, 0, 3, 5 };	// path to addon sound
		sounds[] = { "sound0", "sound1" };
	};
};



class CfgVehicles
{
	class Sound;
    class CVO_SFX_SS_Base : Sound
    {
        name = "CVO Storm - Base Soundsource";
        description = "Base SoundSource Obj Effects for the Storm SFX Module";
        sound = "CVO_SFX_Base";
    };

	class CVO_SFX_SS_Windbursts : CVO_SFX_SS_Base // class name to be used with createSoundSource
	{
        name = "CVO Storm - WindBurst SoundSource";
		sound = "CVO_SFX_WindBursts"; // reference to CfgSFX class
	};

	class CVO_SFX_SS_WindLong : CVO_SFX_SS_Base // class name to be used with createSoundSource
	{
        name = "CVO Storm - WindLong SoundSource";
		sound = "CVO_SFX_WindLong"; // reference to CfgSFX class
	};
};


// Simple Sounds
class CfgSounds
{
	class CVO_SFX_SS_Base
	{
		titles[] = { 0, "" };																// subtitles
		forceTitles = 0;			// Arma 3 - display titles even if global show titles option is off (1) or not (0)
		titlesStructured = 0;		// Arma 3 - treat titles as Structured Text (1) or not (0)
	};

	class CVO_SFX_SS_WindLong1 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Long: 1 - Hurricane";															// display name
		sound[] = { PATH_TO_ADDON_2(data,hurricane.ogg), "db+3", 1, 5000 };	// file, volume, pitch, maxDistance
		duration = 60;
	};
	
	class CVO_SFX_SS_WindLong2 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Long: 2 - Strong Wind";															// display name
		sound[] = { PATH_TO_ADDON_2(data,strong_wind.ogg), "db+3", 1, 5000 };	// file, volume, pitch, maxDistance
		duration = 70;
	};

	class CVO_SFX_SS_WindBurst1 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Burst: 1";															// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_1.ogg), "db+3", 1, 250};		// path to addon sound // 05
		duration = 5;
	};

	class CVO_SFX_SS_WindBurst2 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Burst: 2";															// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_2.ogg), "db+3", 1, 250};		// path to addon sound
		duration = 8;
	};

	class CVO_SFX_SS_WindBurst3 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Burst: 3";															// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_3_dr.ogg), "db+3", 1, 250};		// path to addon sound // 05
		duration = 4;
	};

	class CVO_SFX_SS_WindBurst4 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Burst: 4";															// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_4_st.ogg), "db+3", 1, 250};		// path to addon sound
		duration = 4;
	};

	class CVO_SFX_SS_WindBurst5 : CVO_SFX_SS_Base
	{
		name = "CVO Storm Wind Burst: 5 Sandstorm";															// display name
		sound[] = { PATH_TO_ADDON_2(data,sandstorm.ogg), "db+3", 1, 250};		// path to addon sound // 05
		duration = 16;
	};
};