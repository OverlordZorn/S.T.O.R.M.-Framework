//#include "\x\cba\addons\main\script_macros_common.hpp"
//#include "\x\cba\addons\xeh\script_xeh.hpp"

#include "\z\cvo_storm\addons\based\script_version.hpp"
#include "\z\cvo_storm\addons\based\script_mod.hpp"

#define _CVO_DEBUG_

#define TRUE 1
#define FALSE 0

// CBA Stuff
#define RETDEF(VARIABLE,DEFAULT_VALUE) (if (isNil {VARIABLE}) then [{DEFAULT_VALUE}, {VARIABLE}])
#define RETNIL(VARIABLE) RETDEF(VARIABLE,nil)

#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3
#define QUOTE(var1) #var1
#define QQUOTE(var1) QUOTE(QUOTE(var1))

#define ADDON DOUBLES(PREFIX,COMPONENT)
#define MAIN_ADDON DOUBLES(PREFIX,main)


#ifdef SUBCOMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(PREFIX - COMPONENT_BEAUTIFIED - SUBCOMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(PREFIX - COMPONENT_BEAUTIFIED)
#endif

#define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}

// Selfmade
#define PATH_TO_FNC QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\functions)
#define PATH_TO_ADDON(var1) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1)
#define PATH_TO_ADDON_2(var1,var2) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1##\##var2)
#define PATH_TO_ADDON_3(var1,var2,var3) QUOTE(MAINPREFIX\PREFIX\addons\COMPONENT\##var1##\##var2##\##var3)

// Debug
#define DEBUG_HEADER format [QUOTE([PREFIX][COMPONENT](%1)),_fnc_scriptName]
#define ZRN_LOG_MSG(MSG) diag_log (DEBUG_HEADER + QUOTE(MSG))


#ifdef _CVO_DEBUG_
    #define ZRN_LOG_MSG_1(MSG,A) diag_log (DEBUG_HEADER + (format [' %1 - A: %2',QUOTE(MSG),A]))
    #define ZRN_LOG_MSG_2(MSG,A,B) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3',QUOTE(MSG),A,B]))
    #define ZRN_LOG_MSG_3(MSG,A,B,C) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4',QUOTE(MSG),A,B,C]))
    #define ZRN_LOG_MSG_4(MSG,A,B,C,D) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5',QUOTE(MSG),A,B,C,D]))
    #define ZRN_LOG_MSG_5(MSG,A,B,C,D,E) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6',QUOTE(MSG),A,B,C,D,E]))
    #define ZRN_LOG_MSG_6(MSG,A,B,C,D,E,F) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7',QUOTE(MSG),A,B,C,D,E,F]))
    #define ZRN_LOG_MSG_7(MSG,A,B,C,D,E,F,G) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8',QUOTE(MSG),A,B,C,D,E,F,G]))
    #define ZRN_LOG_MSG_8(MSG,A,B,C,D,E,F,G,H) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8 - I: %9',QUOTE(MSG),A,B,C,D,E,F,G,H]))

    #define ZRN_LOG_1(A) diag_log (DEBUG_HEADER + (format [' A: %1',A]))
    #define ZRN_LOG_2(A,B) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2',A,B]))
    #define ZRN_LOG_3(A,B,C) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3',A,B,C]))
    #define ZRN_LOG_4(A,B,C,D) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4',A,B,C,D]))
    #define ZRN_LOG_5(A,B,C,D,E) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5',A,B,C,D,E]))
    #define ZRN_LOG_6(A,B,C,D,E,F) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6',A,B,C,D,E,F]))
    #define ZRN_LOG_7(A,B,C,D,E,F,G) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7',A,B,C,D,E,F,G]))
    #define ZRN_LOG_8(A,B,C,D,E,F,G,H) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7 - I: %8',A,B,C,D,E,F,G,H]))
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

