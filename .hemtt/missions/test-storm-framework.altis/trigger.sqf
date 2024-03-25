/*_array_mod = [(configFile >> "CVO_AI_SubSkill_Modifier"), "CVO_AI_Skill_sandstorm_old"] call cvo_storm_fnc_common_hash_from_config;
[_array_mod, allUnits] call CVO_STORM_fnc_AI_setSkill_recursive;
*/


diag_Log str (skill test_unit);


trigger_test = true;

[] spawn {
    while {trigger_test} do {

        diag_Log (skill test_unit);
        sleep 1;
    };
};

[] spawn {
    diag_Log "AI Applied";
    diag_Log "Changing to 0.5";
    ["CVO_AI_Skill_sandstorm_old", 1, 0.5] call cvo_storm_fnc_ai_request;
    sleep 70;
    diag_Log str (skill test_unit);
    sleep 1;

    diag_Log "Changing to 0";
    ["CVO_AI_Skill_sandstorm_old", 1, 0] call cvo_storm_fnc_ai_request;
    sleep 70;
    diag_Log str (skill test_unit);

    diag_Log " transition test ended";
    diag_log "testing 0 on 0";

    ["CVO_AI_Skill_sandstorm_old", 1, 0] call cvo_storm_fnc_ai_request;

    sleep 70;
    trigger_test = false;

   diag_Log str (skill test_unit);

};

