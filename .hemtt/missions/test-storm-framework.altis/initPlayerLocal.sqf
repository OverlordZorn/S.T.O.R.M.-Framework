player setVariable ["STORM_StartLoadout", getUnitLoadout player];
player addEventHandler ["Respawn", { private _loadout = player getVariable "STORM_StartLoadout"; if (!isNil "_loadout") then { player setUnitLoadout _loadout; }; }];