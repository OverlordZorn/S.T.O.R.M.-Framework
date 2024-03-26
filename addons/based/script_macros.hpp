//#include "\x\cba\addons\main\script_macros_common.hpp"
//#include "\x\cba\addons\xeh\script_xeh.hpp"

#include "\z\cvo_storm\addons\based\script_version.hpp"
#include "\z\cvo_storm\addons\based\script_mod.hpp"

#define _CVO_DEBUG_ true

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
#define PATH_TO_ADDON(var1) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1)
#define PATH_TO_ADDON_2(var1,var2) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1##\##var2)
#define PATH_TO_ADDON_3(var1,var2,var3) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1##\##var2##\##var3)

// Personal Debug Stuff

// #define DEBUG_HEADER __DATE_STR_ISO8601__[PREFIX][COMPONENT](__FILE__)

#define DEBUG_HEADER [PREFIX][COMPONENT](__FILE__)

#define ZRN_LOG_MSG(MSG) diag_log QUOTE(DEBUG_HEADER MSG)

#ifdef _CVO_DEBUG_
    #define ZRN_LOG_MSG_1(MSG,A) diag_log format ["##DEBUG_HEADER %1 - A: %2",MSG, A]
    #define ZRN_LOG_MSG_2(MSG,A,B) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3",MSG, A, B]
    #define ZRN_LOG_MSG_3(MSG,A,B,C) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4",MSG, A, B, C]
    #define ZRN_LOG_MSG_4(MSG,A,B,C,D) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4 - D: %5",MSG, A, B, C, D]
    #define ZRN_LOG_MSG_5(MSG,A,B,C,D,E) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6",MSG, A, B, C, D, E]
    #define ZRN_LOG_MSG_6(MSG,A,B,C,D,E,F) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7",MSG, A, B, C, D, E, F]
    #define ZRN_LOG_MSG_7(MSG,A,B,C,D,E,F,G) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8",MSG, A, B, C, D, E, F, G]
    #define ZRN_LOG_MSG_8(MSG,A,B,C,D,E,F,G,H) diag_log format ["##DEBUG_HEADER %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8 - I: %9",MSG, A, B, C, D, E, F, G, H]

    #define ZRN_LOG_1(A) diag_log format ["DEBUG_HEADER A: %1", A]
    #define ZRN_LOG_2(A,B) diag_log format ["DEBUG_HEADER A: %1 - B: %2", A, B]
    #define ZRN_LOG_3(A,B,C) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3", A, B, C]
    #define ZRN_LOG_4(A,B,C,D) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3 - D: %4", A, B, C, D]
    #define ZRN_LOG_5(A,B,C,D,E) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3 - D: %4 - E: %5", A, B, C, D, E]
    #define ZRN_LOG_6(A,B,C,D,E,F) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6", A, B, C, D, E, F]
    #define ZRN_LOG_7(A,B,C,D,E,F,G) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7", A, B, C, D, E, F, G]
    #define ZRN_LOG_8(A,B,C,D,E,F,G,H) diag_log format ["DEBUG_HEADER A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7 - I: %8", A, B, C, D, E, F, G, H]
#else
    #define ZRN_LOG_MSG_1(MSG,A)
    #define ZRN_LOG_MSG_2(MSG,A,B)
    #define ZRN_LOG_MSG_3(MSG,A,B,C)
    #define ZRN_LOG_MSG_4(MSG,A,B,C,D)
    #define ZRN_LOG_MSG_5(MSG,A,B,C,D,E)
    #define ZRN_LOG_MSG_6(MSG,A,B,C,D,E,F)
    #define ZRN_LOG_MSG_7(MSG,A,B,C,D,E,F,G)
    #define ZRN_LOG_MSG_8(MSG,A,B,C,D,E,F,G,H)

    #define ZRN_LOG_1(A)
    #define ZRN_LOG_2(A,B)
    #define ZRN_LOG_3(A,B,C)
    #define ZRN_LOG_4(A,B,C,D)
    #define ZRN_LOG_5(A,B,C,D,E)
    #define ZRN_LOG_6(A,B,C,D,E,F)
    #define ZRN_LOG_7(A,B,C,D,E,F,G)
    #define ZRN_LOG_8(A,B,C,D,E,F,G,H)
#endif