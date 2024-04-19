#include "script_component.hpp"

// CBA Addon Options


[
    QSET(DEBUG),                                            // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX",                                             // setting type
    ["Enable Debug",  "Enable Debug Mode and Messages across the Mod"],                       // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    [MOD_NAME_BEAUTIFIED, "Main - Debug"],                                 // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [true],                                                 // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,                                                    // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
        missionNameSpace setVariable [QPVAR(DEBUG), _this];
        [_this] call PFUNC(toggleDebugHelper);
    },                                                      // function that will be executed once on mission start and every time the setting is changed.
    false                                                   
] call CBA_fnc_addSetting;

// TODO set debug default to false



// Other stuff
isAceLoaded = isClass (configFile >> "CfgPatches" >> "ace_common");
if (!isAceLoaded) then {
    ACE_player = objNull;
    uiNamespace setVariable ["ACE_player", objNull];
};