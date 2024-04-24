#include "script_component.hpp"

// CBA Addon Options
[
    QSET(DEBUG),                                                                //     _setting     - Unique setting name. Matches resulting variable name <STRING>// Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX",                                                                 //     _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    [localize "STR_STORM_Based_debug",  localize "STR_STORM_Based_debug_desc"],                   // _title - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY> - Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    [MOD_NAME_BEAUTIFIED, localize "STR_STORM_Based_cat_Debug"],                                      //     _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    [false],                                                                    //     _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY> - data for this setting: [min, max, default, number of shown trailing decimals]
    2,                                                                          //     _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER> 
    {
        missionNameSpace setVariable [QPVAR(DEBUG), _this];
        [_this] call PFUNC(toggleDebugHelper);
    },                                                      // function that will be executed once on mission start and every time the setting is changed.
    false                                                   
] call CBA_fnc_addSetting;


// Other stuff
isAceLoaded = isClass (configFile >> "CfgPatches" >> "ace_common");
if (!isAceLoaded) then {
    ACE_player = objNull;
    uiNamespace setVariable ["ACE_player", objNull];
};