//#include "\x\cba\addons\main\script_macros_common.hpp"
//#include "\x\cba\addons\xeh\script_xeh.hpp"

#include "\z\cvo_storm\addons\based\script_version.hpp"
#include "\z\cvo_storm\addons\based\script_mod.hpp"

#define TRUE 1
#define FALSE 0

#define ADDON DOUBLES(PREFIX,COMPONENT)
#define MAIN_ADDON DOUBLES(PREFIX,main)

#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3
#define QUOTE(var1) #var1


#ifdef SUBCOMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(PREFIX - COMPONENT_BEAUTIFIED - SUBCOMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(PREFIX - COMPONENT_BEAUTIFIED)
#endif

#define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}

#define PATH_TO_FNC QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\functions)
#define PATH_TO_ADDON(var1) QOUTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1)
#define PATH_TO_ADDON_2(var1,var2) QOUTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1##\##var2)