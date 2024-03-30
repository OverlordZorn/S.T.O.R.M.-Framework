#include "..\script_component.hpp"

["CBA_settingsInitialized", { // from postInit
    missionNameSpace setVariable [QPVAR(DEBUG), SET(DEBUG)];
}] call CBA_fnc_addEventHandler;

