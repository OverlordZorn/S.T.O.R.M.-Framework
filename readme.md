### Dependencies
"ace_interaction","cba_common"


###
```sqf

_intensity = 1;
_duration = 1;

["storm_fx_post_CC_Mars_Storm",     _duration, _intensity] call storm_fx_post_fnc_request;
["storm_fx_post_DB_25",             _duration, _intensity] call storm_fx_post_fnc_request;
["storm_fx_post_FG_Storm",          _duration, _intensity] call storm_fx_post_fnc_request;

["storm_fx_sound_3D_WindBursts",    _duration, _intensity] call storm_fx_sound_fnc_request;
["storm_fx_sound_3D_WindLong",      _duration, _intensity] call storm_fx_sound_fnc_request;

["storm_fx_particle_Dust_High_50",  _duration, _intensity] call storm_fx_particle_fnc_request;
["storm_fx_particle_Dust_High_35",  _duration, _intensity] call storm_fx_particle_fnc_request;
["storm_fx_particle_Leafes",        _duration, _intensity] call storm_fx_particle_fnc_request;

["storm_fx_weather_Sandstorm_01",   _duration, _intensity] call storm_fx_weather_fnc_request;

```