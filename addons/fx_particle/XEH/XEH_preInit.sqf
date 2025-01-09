#include "../script_component.hpp"


/*
here, you put in your CBA Settings so they are available in the editor!

https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#create-a-custom-setting-for-mission-or-mod

MACROS Used:
SETLSTRING(test) -> [LSTRING(set_test), LSTRING(set_test_desc)] -> STR_prefix_component_set_test // STR_prefix_component_set_test_desc


SET(test) -> ADDON_set_test
QSET(test) -> "ADDON_set_test"
*/

/*
[
	QSET(enable),							//    _setting     - Unique setting name. Matches resulting variable name <STRING>
	"CHECKBOX",								//    _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
	SETLSTRING(enable),
											//    _title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
	[LSTRING(set_cat_main)],				//    _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
	true,									//    _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
	1,										//    _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
	{},										//    _script      - Script to execute when setting is changed. (optional) <CODE>
	false									//    _needRestart - Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;
*/

[
    QSET(PlayerCoef),                                                           //     _setting     - Unique setting name. Matches resulting variable name <STRING>// Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER",                                                                   //     _settingType - Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
    SETLSTRING(PlayerCoef),
                                                                                // _title - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY> - Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    [ELSTRING(framework,set_cat_main), LSTRING(cat_particle)],                         //     _category    - Category for the settings menu + optional sub-category <STRING, ARRAY>
    [0.25,1,1,0,true],                                                           //     _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY> - data for this setting: [min, max, default, number of shown trailing decimals]
    2,                                                                          //     _isGlobal    - 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER> 
    {},                                                                         // function that will be executed once on mission start and every time the setting is changed.
    false                                                   
] call CBA_fnc_addSetting;
