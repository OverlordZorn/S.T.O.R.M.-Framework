// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX z
#define PREFIX storm

#define MOD_NAME_BEAUTIFIED "S.T.O.R.M. Framework"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCHLVL,BUILD

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.10
#define REQUIRED_CBA_VERSION {3,15,7}



// config.cpp addon header
#define AUTHOR "Overlord Zorn [CVO]"
#define URL "http:\/\/www.github.com/PulsarNeutronStar/CVO-Sandstorm"

#define ADDON_CONFIG_HEADER VERSION_CONFIG; name = COMPONENT_NAME; author = AUTHOR; url = URL
