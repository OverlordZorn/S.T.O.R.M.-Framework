class CfgPatches {

	class CVO_Storm_Framework
	{
		// Meta information for editor
		version = "1.0.0";
        name = "CVO Storm Framework";
		author = "Overlord Zorn [CVO]";
        url = "https://github.com/PulsarNeutronStar/CVO-Sandstorm";

        // Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
        requiredVersion = 2.02;

        // Required addons, used for setting load order.
        // When any of the addons is missing, pop-up warning will appear when launching the game.
        requiredAddons[] = {"ace_interaction","cba_common","A3_Misc_F_Helpers"};

		// Optional. If this is 1, if any of requiredAddons[] entry is missing in your game the entire config will be ignored and return no error (but in rpt) so useful to make a compat Mod (Since Arma 3 2.14)
		skipWhenMissingDependencies = 1;
        
        // List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups)
        units[] = {};

        // List of weapons (CfgWeapons classes) contained in the addon.
        weapons[] = {};

	};

};

#include "Cfg\CVO_StormPresets.hpp"
#include "Cfg\CVO_PP_Effects.hpp"

class CVO_Weather_Effects
{
	class CVO_Weather_Presets
	{
		#include "Cfg\CVO_WeatherPresets.hpp"
	};

	class CVO_Rain_Params
	{
		#include "Cfg\CVO_RainParams.hpp"
	};
};

class CfgCloudlets {
	#include "Cfg\CVO_ParticleEffects.hpp"
};


#include "Cfg\CVO_SubSkills.hpp"


class CfgFunctions
{
	class CVO_Storm            // Tag
	{
		class PostProcessing   // Category
		{
			file = "z\cvo_storm\addons\storm\functions";

			class ppEffect_apply {};
			class ppEffect_get_from_config {};
			class ppEffect_convert_intensity {};
			class ppEffect_remote {};
		};
		class WeatherSettings   // Category
		{
			file = "z\cvo_storm\addons\storm\functions";

			class weather_apply {};
			class weather_getAvgASL {};
			class weather_get_WeatherPreset_as_Hash {};
			class weather_get_rainParams_as_Array {};
			class weather_setWind_recursive {};
			class weather_setFog_recursive_continous {};

		};
		class ParticleEffects   // Category
		{
			file = "z\cvo_storm\addons\storm\functions";

			class particle_get_params_from_config {};
			class particle_remote {};
		};
	}; 
};
