/*				SOUND SOURCES CURRENTLY NOT IN USE
class CfgSFX
{
	class GVAR(SFX_Base)
	{
		empty[] = { "", 0, 0, 0, 0, 0, 0, 0 };
	};

   	class GVAR(SFX_WindBursts) : GVAR(SFX_Base)
	{
        name = "S.T.O.R.M. - Windburst Soundeffects";
        description = "~10s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { PATH_TO_ADDON_2(data,sandstorm.ogg), "db+20", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound1[] = { PATH_TO_ADDON_2(data,windburst_1.ogg), "db+20", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound2[] = { PATH_TO_ADDON_2(data,windburst_2.ogg), "db+20", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound3[] = { PATH_TO_ADDON_2(data,windburst_3_dr.ogg), "db+20", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sound4[] = { PATH_TO_ADDON_2(data,windburst_4_st.ogg), "db+20", 1.0, 500, 1, 5, 15, 30 };	// path to addon sound
		sounds[] = { "sound0", "sound1", "sound2","sound3","sound4" };
	};

   	class GVAR(SFX_WindLong) : GVAR(SFX_Base)
	{
        name = "S.T.O.R.M. - Long Storm Soundeffects";
        description = "~60s Sound Effects for the Storm SFX Module - Most of them are originally from the Alias Dust Storm Script";

        // {soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
		sound0[] = { PATH_TO_ADDON_2(data,hurricane.ogg), "db+20", 1.0, 50000, 1, 0, 3, 5 };	// path to addon sound
		sound1[] = { PATH_TO_ADDON_2(data,strong_wind.ogg), "db+20", 1.0, 50000, 1, 0, 3, 5 };	// path to addon sound
		sounds[] = { "sound0", "sound1" };
	};
};
class CfgVehicles
{
	class Sound;
    class GVAR(SS_Base) : Sound
    {
        name = "S.T.O.R.M. - Base Soundsource";
        description = "Base SoundSource Obj Effects for the Storm SFX Module";
        sound = QGVAR(SFX_Base);
    };

	class GVAR(SS_Windbursts) : GVAR(SS_Base) // class name to be used with createSoundSource
	{
        name = "S.T.O.R.M. - WindBurst SoundSource";
		sound = QGVAR(SFX_WindBursts); // reference to CfgSFX class
	};

	class GVAR(SS_WindLong) : GVAR(SS_Base) // class name to be used with createSoundSource
	{
        name = "S.T.O.R.M. - WindLong SoundSource";
		sound = QGVAR(SFX_WindLong); // reference to CfgSFX class
	};
};
*/ 

// Simple Sounds files for 3D playback
class CfgSounds
{
	class GVAR(Base)
	{
		titles[] = { 0, "" };								// subtitles
		forceTitles = 0;			// Arma 3 - display titles even if global show titles option is off (1) or not (0)
		titlesStructured = 0;		// Arma 3 - treat titles as Structured Text (1) or not (0)
	};

// Used for "3D_WindLong"
	class GVAR(WindLong1) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Long: 1 - Hurricane";								// display name
		sound[] = { PATH_TO_ADDON_2(data,hurricane.ogg), "db+20", 1, 5000 };		// file, volume, pitch, maxDistance
		duration = 60;
	};
	
	class GVAR(WindLong2) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Long: 2 - Strong Wind";								// display name
		sound[] = { PATH_TO_ADDON_2(data,strong_wind.ogg), "db+20", 1, 5000 };		// file, volume, pitch, maxDistance
		duration = 70;
	};

// Used for "3D_WindBursts"
	class GVAR(WindBurst1) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Burst: 1";											// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_1.ogg), "db+20", 1, 250};		// path to addon sound // 05
		duration = 5;
	};

	class GVAR(WindBurst2) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Burst: 2";											// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_2.ogg), "db+20", 1, 250};		// path to addon sound
		duration = 8;
	};

	class GVAR(WindBurst3) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Burst: 3";											// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_3_dr.ogg), "db+20", 1, 250};		// path to addon sound // 05
		duration = 4;
	};

	class GVAR(WindBurst4) : GVAR(Base)
	{
		name = "S.T.O.R.M. Wind Burst: 4";											// display name
		sound[] = { PATH_TO_ADDON_2(data,windburst_4_st.ogg), "db+20", 1, 250};		// path to addon sound
		duration = 4;
	};

	class GVAR(WindBurst5) : GVAR(Base) // sounda kind of like wind wooshing into treetops and rattling leaves
	{
		name = "S.T.O.R.M. Wind Burst: 5 Sandstorm";							// display name
		sound[] = { PATH_TO_ADDON_2(data,sandstorm.ogg), "db+20", 1, 250};		// path to addon sound // 05
		duration = 16;
	};
};
