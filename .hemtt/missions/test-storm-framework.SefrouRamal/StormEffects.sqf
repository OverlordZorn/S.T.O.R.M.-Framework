duration = 1;
intensity = 1;


["CVO_PE_Leafes",               60 *    duration, intensity] call CVO_STORM_fnc_particle_remote;
["CVO_PE_Dust_High_100",        60 *    duration, intensity] call CVO_STORM_fnc_particle_remote;
["CVO_PE_Dust_High_50",         60 *    duration, intensity] call CVO_STORM_fnc_particle_remote;

diag_log "[CVO](debug)(StormEffects) post Particles ";

["CVO_CC_Mars_Storm",                   duration, intensity] call CVO_STORM_fnc_ppEffect_request;
["CVO_DB_20",                           duration, intensity] call CVO_STORM_fnc_ppEffect_request;
["CVO_FG_Storm",                        duration, intensity] call CVO_STORM_fnc_ppEffect_request;

diag_log "[CVO](debug)(StormEffects) Post ppEffects ";

["CVO_Weather_Sandstorm_01",            duration, intensity] call CVO_STORM_fnc_weather_request;

diag_log "[CVO](debug)(StormEffects) Post Weather ";
