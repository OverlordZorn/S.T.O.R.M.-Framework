class CfgPatches {

	class CVO_Storm_Framework
	{
		// Meta information for editor
		version = "1.0.0";
        name = "CVO Storm Framework";
		author = "Overlord Zorn [CVO]";
        url = "https://github.com/PulsarNeutronStar/CVO-Sandstorm";

        // Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
        requiredVersion = 2.0;

        // Required addons, used for setting load order.
        // When any of the addons is missing, pop-up warning will appear when launching the game.
        requiredAddons[] = {"ace_interaction","cba_common"};

		// Optional. If this is 1, if any of requiredAddons[] entry is missing in your game the entire config will be ignored and return no error (but in rpt) so useful to make a compat Mod (Since Arma 3 2.14)
		skipWhenMissingDependencies = 1;
        
        // List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups)
        units[] = {};

        // List of weapons (CfgWeapons classes) contained in the addon.
        weapons[] = {};

	};

};

class CVO_PP_Effects
{
	#include "CVO_ColorCorrections.hpp"
	#include "CVO_FilmGrain.hpp"
	#include "CVO_DynamicBlur.hpp"
};

class CVO_Weather_Effects
{
	#include "CVO_WeatherPresets.hpp"
	#include "CVO_RainParams.hpp"
};

class CfgFunctions
{
	class CVO_Storm            // Tag
	{
		class Storm           // Category
		{
			file = "z\cvo_storm\addons\storm\functions";


			class ppEffect_apply {};
			class ppEffect_get_from_config {};
			class ppEffect_convert_intensity {};
			class ppEffect_remote {};

			class weather_apply {};
			class weather_getAvgASL {};
		};
	}; 
};