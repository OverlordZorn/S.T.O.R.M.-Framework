#include "..\script_component.hpp"


["CBA_settingsInitialized", { // from postInit
    missionNameSpace setVariable ["CVO_Debug", CVO_Storm_Debug];

}] call CBA_fnc_addEventHandler;
