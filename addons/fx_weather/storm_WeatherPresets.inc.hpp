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

        change_wind = 0;                                // 0 or 1 - consider it a bool
        wind_value = 0;                                 // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 0;                               // o or 1 - defines if the wind stays locked in place at the end of the transition; 0 = false; >0 = true;

        change_gusts = 0;                               // 0 or 1 - consider it a bool
        gusts_value = 0;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 0;                               // 0 or 1 - consider it a bool
        waves_value = 0;                                // 0..1

        ace_temp_shift = 0;                             // if Ace_weather is detected, it will modify the temperature shift by the value in °C.
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

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 10;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
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

        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 7.5;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference
        forceWindEnd = 1;                               // 0 or 1 - consider it a bool

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 1;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 0.5;                                // 0..1

        ace_temp_shift = -15;                             // if Ace_weather is active, it will modify the ace_weather_temperatureShift by the value in °C.
    };


    class GVAR(SnowStorm_Calm) : GVAR(SnowStorm)
    {
        rainParams = QGVAR(RainParams_Snow_Calm);          // String - name of RainParams Config Class
        wind_value = 5;
        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 0.3;                                // 0..1   - wind Gusts, changes in windspeed
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


        change_wind = 1;                                // 0 or 1 - consider it a bool
        wind_value = 10;                                // Number - 0.. - ~32m/s is classified as hurricane - see "beaufort wind scale" for reference

        change_gusts = 1;                               // 0 or 1 - consider it a bool
        gusts_value = 1;                                // 0..1   - wind Gusts, changes in windspeed

        change_waves = 1;                               // 0 or 1 - consider it a bool
        waves_value = 1;                                // 0..1
    };
};

