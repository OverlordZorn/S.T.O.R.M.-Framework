
if (!isAceLoaded) then {
    ["unit", {
        ACE_player = (_this select 0);
    }, true] call CBA_fnc_addPlayerEventHandler;
};
