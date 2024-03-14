duration = 1;
// intensity = 0.05 + 0.01 * ceil random 95;
intensity = 1;

systemChat format ["Intensity set to: %1", intensity];


["CVO_PE_Leafes",                   duration, intensity] call cvo_storm_fnc_ppEffect_request;
["CVO_PE_Dust_High_50",             duration, intensity] call cvo_storm_fnc_ppEffect_request;
["CVO_PE_Dust_High_100",            duration, intensity] call cvo_storm_fnc_ppEffect_request;

//diag_log "[CVO](debug)(StormEffects) post Particles ";

["CVO_CC_Mars_Storm",               duration, intensity] call CVO_STORM_fnc_ppEffect_request;
["CVO_DB_20",                       duration, intensity] call CVO_STORM_fnc_ppEffect_request;
["CVO_FG_Storm",                    duration, intensity] call CVO_STORM_fnc_ppEffect_request;

// diag_log "[CVO](debug)(StormEffects) Post ppEffects ";

["CVO_Weather_Sandstorm_01",        duration, intensity] call CVO_STORM_fnc_weather_request;

//diag_log "[CVO](debug)(StormEffects) Post Weather";
