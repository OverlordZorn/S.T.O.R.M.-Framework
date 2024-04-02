#include "../script_component.hpp"

addMissionEventHandler ["EntityCreated", {
	params ["_entity"];
    if (typeOf _entity isEqualTo "B_Soldier_VR_F") then {
        _arr = diag_stacktrace;
        systemChat "MILKMAN ALEART";
        [] spawn {
            
            while {storm_debug} do {
                hint "MILKMAN ALEART";
                sleep 0.5;
            };
        };
        systemChat str _arr;
        ZRN_LOG_MSG_1(MILKMAN,_arr);
    };
}];
