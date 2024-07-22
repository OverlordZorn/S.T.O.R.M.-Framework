#include "..\script_component.hpp"

if !(_DEBUG_) exitWith {};

/*
//["storm_Sandstorm", 1, 1] call storm_fnc_request_transition;
//["storm_Sandstorm", 1, 0] call storm_fnc_request_transition;


//["storm_Duststorm_Green", 1, 0] call storm_fnc_request_transition;
//["storm_Sandstorm_Green", 1, 0] call storm_fnc_request_transition;

//["storm_fx_weather_SnowStorm", 1, 1] call storm_fx_weather_fnc_request;

["storm_Snowstorm_lessFog", 1, 1] call storm_fnc_request_transition;
//["storm_Snowstorm", 1, 0] call storm_fnc_request_transition;


//["storm_fx_particle_Dust_High", 1, 0] call storm_fx_particle_fnc_request;
//["storm_fx_particle_Branches", 1, 0] call storm_fx_particle_fnc_request;



//["storm_fx_sound_3D_WindBursts", 1,0] call STORM_FX_SOUND_fnc_request;

//["storm_fx_post_CC_ColdSnow_Muted", 1,0] call STORM_FX_POST_fnc_request;


//["storm_Snowstorm", 1, 1] call storm_fnc_request_transition;
//["storm_Snowstorm", 1, 0] call storm_fnc_request_transition;

//["storm_SnowStorm_Bleak", 1, 0.7] call storm_fnc_request_transition;
//["storm_SnowStorm_Bleak", 1, 0] call storm_fnc_request_transition;

*/



// Test Fog Request
systemChat "Waiting 10 secounds";
5 setFog [1,0.1,50];
[ { 
    ["STORM_FX_Weather_Fog_Static_70", 1, 0.7, true] call Storm_fx_weather_fnc_request_fog;
    systemChat "10s passed - starting Fog Transition";
 } , [], 10] call CBA_fnc_waitAndExecute;
[ { 
    ["STORM_FX_Weather_Fog_Static_70", 1, 0] call Storm_fx_weather_fnc_request_fog;
    systemChat "70s passed - setting Fog to 0";
 } , [], 70] call CBA_fnc_waitAndExecute;

