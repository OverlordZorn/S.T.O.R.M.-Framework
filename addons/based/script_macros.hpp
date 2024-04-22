//#include '\x\cba\addons\main\script_macros_common.hpp'
//#include '\x\cba\addons\xeh\script_xeh.hpp'

#include "\z\storm\addons\based\script_version.hpp"
#include "\z\storm\addons\based\script_mod.hpp"

#define _STORM_DEBUG_     // TODO Comment out before big release

#define TRUE 1
#define FALSE 0


#ifdef _STORM_DEBUG_
    #define _DEBUG_01_ 1
#else
    #define _DEBUG_01_ 0
#endif


// CBA Stuff
#define RETDEF(VARIABLE,DEFAULT_VALUE) (if (isNil {VARIABLE}) then [{DEFAULT_VALUE}, {VARIABLE}])
#define RETNIL(VARIABLE) RETDEF(VARIABLE,nil)

#define DOUBLES(var1,var2) var1##_##var2
#define TRIPLES(var1,var2,var3) var1##_##var2##_##var3

#define QUOTE(var1) #var1
#define QQUOTE(var1) QUOTE(QUOTE(var1))
#define Q(var1) QUOTE(var1)
#define QQ(var1) QQUOTE(var1)

#define ADDON DOUBLES(PREFIX,COMPONENT)
#define MAIN_ADDON DOUBLES(PREFIX,main)

#define QADDON Q(ADDON)

#define FUNC(var1) TRIPLES(ADDON,fnc,var1)
#define QFUNC(var1) QUOTE(FUNC(var1))

#define PFUNC(var1) TRIPLES(PREFIX,fnc,var1)
#define QPFUNC(var1) QUOTE(FUNC(var1))


#define FUNC_INNER(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)
#define EFUNC(var1,var2) FUNC_INNER(var1,var2)
#define QEFUNC(var1,var2) Q(EFUNC(var1,var2))

#define COMPONENT_NAME QUOTE(PREFIX - COMPONENT_BEAUTIFIED)

#define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}

#define GVAR(var1) DOUBLES(ADDON,var1)
#define QGVAR(var1) QUOTE(GVAR(var1))
#define QQGVAR(var1) QUOTE(QGVAR(var1))
#define EGVAR(var1,var2) TRIPLES(PREFIX,var1,var2)
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))
#define QQEGVAR(var1,var2) QUOTE(QEGVAR(var1,var2))

#define GVAR_2(var1,var2) TRIPLES(ADDON,var1,var2)
#define QGVAR_2(var1,var2) Q(GVAR_2(var1,var2))
#define QQGVAR_2(var1,var2) QQ(GVAR_2(var1,var2))

#define GVAR_3(var1,var2,var3) DOUBLES(ADDON,TRIPLES(var1,var2,var3))
#define QGVAR_3(var1,var2,var3) Q(GVAR_3(var1,var2,var3))
#define QQGVAR_3(var1,var2,var3) QQ(GVAR_3(var1,var2,var3))


// Prefix Variables
#define PVAR(var1) DOUBLES(PREFIX,var1)
#define QPVAR(var1) QUOTE(PVAR(var1))
#define QQPVAR(var1) QUOTE(PVAR(var1))

#define P_CFG_COMP TRIPLES(PREFIX,CFG,COMPONENT)

#define PATHTO_SYS(var1,var2,var3) \MAINPREFIX\var1\addons\var2\var3.sqf
#define COMPILE_SCRIPT(var1) compileScript ['PATHTO_SYS(PREFIX,COMPONENT,var1)']

//////// Selfmade
// Paths
#define PATH_TO_FNC QUOTE(\MAINPREFIX\PREFIX\addons\COMPONENT\functions)
#define PATH_TO_ADDON(var1) QUOTE(\MAINPREFIX\PREFIX\addons\COMPONENT\var1)
#define PATH_TO_ADDON_2(var1,var2) QUOTE(\MAINPREFIX\PREFIX\addons\COMPONENT\var1\var2)
#define PATH_TO_ADDON_3(var1,var2,var3) QUOTE(\MAINPREFIX\PREFIX\addons\COMPONENT\var1\var2\var3)


// CBA Settings

#define SET(var1) TRIPLES(ADDON,SET,var1)
#define QSET(var1) Q(SET(var1))
#define QQSET(var1) QQ(SET(var1))
#define ESET(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),SET,var2)
#define QESET(var1,var2) Q(ESET(var1,var2))
#define QQESET(var1,var2) QQ(ESET(var1,var2))

// Debug
#define DEBUG_HEADER format [QUOTE([PREFIX][COMPONENT](%1)),_fnc_scriptName]



#define ZRN_LOG_MSG(MSG) diag_log (DEBUG_HEADER + QUOTE(MSG))

#ifdef _STORM_DEBUG_
    #define ZRN_SCRIPTNAME(var1) _fnc_scriptName = Q(var1)

    #define ZRN_LOG_MSG_1(MSG,A) diag_log (DEBUG_HEADER + (format [' %1 - A: %2',QUOTE(MSG),RETNIL(A)]))
    #define ZRN_LOG_MSG_2(MSG,A,B) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3',QUOTE(MSG),RETNIL(A),RETNIL(B)]))
    #define ZRN_LOG_MSG_3(MSG,A,B,C) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C)]))
    #define ZRN_LOG_MSG_4(MSG,A,B,C,D) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D)]))
    #define ZRN_LOG_MSG_5(MSG,A,B,C,D,E) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E)]))
    #define ZRN_LOG_MSG_6(MSG,A,B,C,D,E,F) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F)]))
    #define ZRN_LOG_MSG_7(MSG,A,B,C,D,E,F,G) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F),RETNIL(G)]))
    #define ZRN_LOG_MSG_8(MSG,A,B,C,D,E,F,G,H) diag_log (DEBUG_HEADER + (format [' %1 - A: %2 - B: %3 - C: %4 - D: %5 - E: %6 - F: %7 - H: %8 - I: %9',QUOTE(MSG),RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F),RETNIL(G),RETNIL(H)]))

    #define ZRN_LOG_1(A) diag_log (DEBUG_HEADER + (format [' A: %1',RETNIL(A)]))
    #define ZRN_LOG_2(A,B) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2',RETNIL(A),RETNIL(B)]))
    #define ZRN_LOG_3(A,B,C) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3',RETNIL(A),RETNIL(B),RETNIL(C)]))
    #define ZRN_LOG_4(A,B,C,D) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4',RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D)]))
    #define ZRN_LOG_5(A,B,C,D,E) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5',RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E)]))
    #define ZRN_LOG_6(A,B,C,D,E,F) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6',RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F)]))
    #define ZRN_LOG_7(A,B,C,D,E,F,G) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7',RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F),RETNIL(G)]))
    #define ZRN_LOG_8(A,B,C,D,E,F,G,H) diag_log (DEBUG_HEADER + (format [' A: %1 - B: %2 - C: %3 - D: %4 - E: %5 - F: %6 - H: %7 - I: %8',RETNIL(A),RETNIL(B),RETNIL(C),RETNIL(D),RETNIL(E),RETNIL(F),RETNIL(G),RETNIL(H)]))

    #define ZRN_LOG_HMO(var1) { if ('#' in _x || 'Meth' in _x) then {continue}; diag_log (DEBUG_HEADER + (format [' %3 - %1 - %2', _x, _y, Q(MSG)])) } forEach var1;
    #define ZRN_LOG_MSG_HMO(MSG,var1) { if ('#' in _x || 'Meth' in _x) then {continue}; diag_log (DEBUG_HEADER + (format [' %3 - %1 - %2', _x, _y, Q(MSG)])) } forEach var1;

#else
    #define ZRN_SCRIPTNAME(var1)

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

    #define ZRN_LOG_HMO(var1)
    #define ZRN_LOG_MSG_HMO(MSG,var1)
#endif



// hashMapObjects

#define OGET(var1) (_self get Q(var1))
#define OSET(var1,var2) (_self set [Q(var1), var2])

