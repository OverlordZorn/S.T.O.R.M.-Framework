class GVAR(Presets)
{

    class GVAR(Default)
    {
        change_overcast = 0;                            // 0 or 1 - consider it a bool
        overcast_value = 0;                             // 0..1

        change_rainValue = 0;                           // 0 or 1 - consider it a bool
        rain_value = 0;                                 // 0..1

        change_rainParams = 0;                          // 0 or 1 - consider it a bool
        rainParams = QGVAR(RainParams_Default);          // String - name of RainParams Config Class

        change_lightnings = 0;                          // 0 or 1 - consider it a bool
        lightnings_value = 0;                           // 0..1

        change_fog = 0;                                 // 0 or 1 - consider it a bool

        fog_value_min = 0;                              // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0;                              // 0..1   - Maximum Fog Level at 100% intensity
        fog_dispersion = 0;                             // 0..1   - Recommend to stay within 0 .. 0.1
        fog_base = 0;                                   // number - meters +/- above Sea Level
        fog_mode = 0;                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.

        change_wind = 0;                                // 0 or 1 - consider it a bool
        wind_value = 0;                                 // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 0;                               // o or 1 - defines if the wind stays locked in place at the end of the transition; 0 = false; >0 = true;

        change_gusts = 0;                               // 0 or 1 - consider it a bool
        gusts_value = 0;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 0;                               // 0 or 1 - consider it a bool
        waves_value = 0;                                // 0..1
    };

    class GVAR(ClearSky) : GVAR(Default)
    {
        change_overcast = 1;                            // 0 or 1 - consider it a bool
        overcast_value = 0;                             // 0..1

        change_rainValue = 1;                           // 0 or 1 - consider it a bool
        rain_value = 0;                                 // 0..1

        change_rainParams = 1;                          // 0 or 1 - consider it a bool
        rainParams = QGVAR(RainParams_Default);          // String - name of RainParams Config Class

        change_lightnings = 1;                          // 0 or 1 - consider it a bool
        lightnings_value = 0;                           // 0..1

        change_fog = 1;                                 // 0 or 1 - consider it a bool

        fog_value_min = 0;                              // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0;                              // 0..1   - Maximum Fog Level at 100% intensity
        fog_dispersion = 0;                             // 0..1   - Recommend to stay within 0 .. 0.1
        fog_base = 0;                                   // number - meters +/- above Sea Level
        fog_mode = 0;                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 0;                                 // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 1;                               // o or 1 - defines if the wind stays locked in place at the end of the transition; 0 = false; >0 = true;

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 0;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 0;                                // 0..1
    };

    class GVAR(Sandstorm) : GVAR(Default)
    {
        change_overcast = 1;                            // 0 or 1 - consider it a bool
        overcast_value = 1;                             // 0..1

        change_rainValue = 1;                           // 0 or 1 - consider it a bool
        rain_value = 0;                                 // 0..1

        change_rainParams = 0;                          // 0 or 1 - consider it a bool
        rainParams = QGVAR(RainParams_Default);          // String - name of RainParams Config Class

        change_lightnings = 1;                          // 0 or 1 - consider it a bool
        lightnings_value = 0;                           // 0..1

        change_fog = 1;                                 // 0 or 1 - consider it a bool

        fog_value_min = 0.01;                            // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0.4;                            // 0..1   - Maximum Fog Level at 100% intensity
        fog_dispersion = 0.015;                         // 0..1   - Recommend to stay within 0 .. 0.1
        fog_base = 100;                                 // number - meters +/- above Sea Level
        fog_mode = 2;                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 32;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 1;                               // 0 or 1 - consider it a bool

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 1;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 1;                                // 0..1
    };


    class GVAR(SnowStorm) : GVAR(Default)
    {
        change_overcast = 1;                            // 0 or 1 - consider it a bool
        overcast_value = 1;                             // 0..1

        change_rainValue = 1;                           // 0 or 1 - consider it a bool
        rain_value = 1;                                 // 0..1

        change_rainParams = 1;                          // 0 or 1 - consider it a bool
        rainParams = QGVAR(RainParams_Snow);          // String - name of RainParams Config Class

        change_lightnings = 1;                          // 0 or 1 - consider it a bool
        lightnings_value = 0;                           // 0..1

        change_fog = 1;                                 // 0 or 1 - consider it a bool

        fog_value_min = 0.01;                            // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0.4;                            // 0..1   - Maximum Fog Level at 100% intensity
        fog_dispersion = 0.015;                         // 0..1   - Recommend to stay within 0 .. 0.1
        fog_base = 50;                                 // number - meters +/- above Sea Level
        fog_mode = 2;                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 32;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 1;                               // 0 or 1 - consider it a bool

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 1;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 0;                                // 0..1
    };





    class GVAR(Test) : GVAR(Default)
    {
        change_overcast = 1;                            // 0 or 1 - consider it a bool
        overcast_value = 1;                             // 0..1

        change_rainValue = 1;                           // 0 or 1 - consider it a bool
        rain_value = 1;                                 // 0..1

        change_rainParams = 1;                          // 0 or 1 - consider it a bool
        rainParams = QGVAR(RainParams_Snow_CVO);          // String - name of RainParams Config Class

        change_lightnings = 1;                          // 0 or 1 - consider it a bool
        lightnings_value = 1;                           // 0..1

        change_fog = 1;                                 // 0 or 1 - consider it a bool

        fog_value_min = 0.01;                            // 0..1   - Minimum Fog, even with 1% intensity                              
        fog_value_max = 0.4;                            // 0..1   - Maximum Fog Level at 100% intensity
        fog_dispersion = 0.015;                         // 0..1   - Recommend to stay within 0 .. 0.1
        fog_base = 50;                                  // number - meters +/- above Sea Level
        fog_mode = 1;                                   // Fogmode: 0 - apply setFog with param once, nothing else fancy going on.  | 1 - Gets Players Average ASL once and adds that to the fog_base Value. | 2 - Continously adapts fogbase based on player AvgAVL.

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 32;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 1;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 1;                                // 0..1
    };
};

