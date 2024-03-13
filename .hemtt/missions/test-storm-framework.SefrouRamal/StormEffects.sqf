["CVO_PE_Leafes", duration * 60, 1] call cvo_storm_fnc_particle_remote;

["CVO_PE_Dust_High_50", duration * 60, 1] call cvo_storm_fnc_particle_remote;

["CVO_PE_Dust_High_35", duration * 60, 1] call cvo_storm_fnc_particle_remote;

["CVO_Weather_Sandstorm_01", duration * 60, 1] call cvo_storm_fnc_weather_request;
["CVO_CC_01", duration, intensity] call cvo_storm_fnc_ppEffect_request;
["CVO_DB_20", duration, intensity] call cvo_storm_fnc_ppEffect_request;
["CVO_FG_Storm", duration, intensity] call cvo_storm_fnc_ppEffect_request;

