#include "..\script_component.hpp"

["CBA_settingsInitialized", { // from postInit

    missionNameSpace setVariable [QPVAR(DEBUG), SET(DEBUG)];
    [SET(DEBUG)] call FUNC(toggleDebugHelper);



    ZRN_LOG_MSG_1(CBA_settingsInitialized,SET(DEBUG));
}] call CBA_fnc_addEventHandler;

