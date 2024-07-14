#include "script_component.hpp"

class CfgPatches {

	class ADDON
	{
		// Meta information for editor
		ADDON_CONFIG_HEADER;		// see based/script_mod.hpp

        // Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game.
        requiredVersion = 2.10;

        // Required addons, used for setting load order.
        // When any of the addons is missing, pop-up warning will appear when launching the game.
		requiredAddons[] = {"cba_common","A3_Misc_F_Helpers", "storm_based", "storm_framework"};

		// Optional. If this is 1, if any of requiredAddons[] entry is missing in your game the entire config will be ignored and return no error (but in rpt) so useful to make a compat Mod (Since Arma 3 2.14)
		skipWhenMissingDependencies = 1;
        
        // List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups)
        units[] = {};

        // List of weapons (CfgWeapons classes) contained in the addon.
        weapons[] = {};

	};

};


class CfgFunctions
{
	class ADDON            // Tag
	{
        class COMPONENT
		{ 
			file = PATH_TO_FNC;

			class request {};
			class remote_3d {};
        };
	}; 
};


#include "storm_CfgSFX.inc.hpp"
#include "storm_SoundPresets.inc.hpp"

