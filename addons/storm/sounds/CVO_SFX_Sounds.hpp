class CfgSFX
{

	class CVO_SFX_Base
	{
        name = "CVO Storm - Windburst Soundeffects";
        description = "Sound Effects for the Storm SFX Module";
        author = "Mr. Zorn";

		empty[] = { "", 0, 0, 0, 0, 0, 0, 0 };
	};

   	class CVO_SFX_WindBursts : CVO_SFX_Base
	{
        name = "CVO Storm - Windburst Soundeffects";
        description = "~10s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";
        author = "Mr. Zorn";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { "z\cvo_storm\addons\storm\sounds\sandstorm.ogg", "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound1[] = { "z\cvo_storm\addons\storm\sounds\windburst_1.ogg", "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound2[] = { "z\cvo_storm\addons\storm\sounds\windburst_2.ogg", "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound3[] = { "z\cvo_storm\addons\storm\sounds\windburst_3_dr.ogg", "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound4[] = { "z\cvo_storm\addons\storm\sounds\windburst_4_st.ogg", "db-0", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sounds[] = { "sound0", "sound1", "sound2","sound3","sound4" };
	};

   	class CVO_SFX_WindLong : CVO_SFX_Base
	{
        name = "CVO Storm - Long Storm Soundeffects";
        description = "~60s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";
        author = "Mr. Zorn";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { "z\cvo_storm\addons\storm\sounds\hurricane.ogg", "db-0", 1.0, 500, 1, 60, 90, 120 };	// path to addon sound
		sound1[] = { "z\cvo_storm\addons\storm\sounds\strong_wind.ogg", "db-0", 1.0, 500, 1, 60, 90, 120 };	// path to addon sound
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
        author = "Mr. Zorn";
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

