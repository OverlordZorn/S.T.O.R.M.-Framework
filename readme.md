### Dependencies
"ace_interaction","cba_common"


###
```sqf

_intensity = 1;
_duration = 1;

["CVO_CC_Mars_Storm", 1, 0] call cvo_storm_fnc_ppEffect_request;
["CVO_DB_25", 1, 0] call cvo_storm_fnc_ppEffect_request;
["CVO_FG_Storm", 1, 0] call cvo_storm_fnc_ppEffect_request;

["CVO_SFX_3D_WindBursts", 60, 0] call cvo_storm_fnc_sfx_remote_3d;
["CVO_SFX_3D_WindLong", 60, 0] call cvo_storm_fnc_sfx_remote_3d;

["CVO_PE_Dust_High_50", 1, 0] call cvo_storm_fnc_particle_request;
["CVO_PE_Dust_High_35", 1, 0] call cvo_storm_fnc_particle_request;
["CVO_PE_Leafes", 1, 0] call cvo_storm_fnc_particle_request;

["CVO_Weather_Sandstorm_01", 1, 0] call CVO_STORM_fnc_weather_request;


```