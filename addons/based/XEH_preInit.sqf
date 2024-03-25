[
    "CVO_Storm_Debug",                                     // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX",                                            // setting type
    "Enable Debug",                                        // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["CVO Storm", "CVO Debug"],                            // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [true],                                                // data for this setting: [min, max, default, number of shown trailing decimals]
    nil,                                                   // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    { missionNameSpace setVariable ["CVO_Debug", _this]; }, // function that will be executed once on mission start and every time the setting is changed.
    false                                                  //
] call CBA_fnc_addSetting;
