class PVAR(mainPresets)
{
    class PVAR(Default)
    {
        author = AUTHOR;
        mod_skill_preset = ""; // QEGVAR(mod_skill,reducedVisibility)
        mod_skill_coef = 1;

        fx_weather_preset = "";
        fx_weather_coef = 1;

        fx_post_presets[] = { "", "", "" };
        fx_post_coef = 1;

        fx_particle_presets[] = {""};
        fx_particle_coef = 1;
        
        fx_sound_presets[] = {""};
        fx_sound_coef = 1;
    };

// SAND STORMS


    class PVAR(Sandstorm) : PVAR(Default)
    {
        mod_skill_preset = QEGVAR(mod_skill,reducedVisibility);
        mod_skill_coef = 1;

        fx_weather_preset = QEGVAR(fx_weather,Sandstorm);
        fx_weather_coef = 1;

        fx_post_presets[] = {QEGVAR(fx_post,CC_Mars_Storm), QEGVAR(fx_post,FG_Storm), QEGVAR(fx_post,DB_20)};
        fx_post_coef = 1;

        fx_particle_presets[] = {QEGVAR(fx_particle,Branches), QEGVAR(fx_particle,Dust_35), QEGVAR(fx_particle,Dust_100)};
        fx_particle_coef = 1;
        
        fx_sound_presets[] = {QEGVAR(fx_sound,3D_WindLong),QEGVAR(fx_sound,3D_WindBursts)};
        fx_sound_coef = 1;
    };

// SNOW STORMS

    class PVAR(SnowStorm) : PVAR(Default)
    {
        mod_skill_preset = QEGVAR(mod_skill,reducedVisibility);
        mod_skill_coef = 1;

        fx_weather_preset = QEGVAR(fx_weather,SnowStorm);                                            // Need to make SnowStorm Weather
        fx_weather_coef = 1;

        fx_post_presets[] = {QEGVAR(fx_post,CC_ColdSnow), QEGVAR(fx_post,FG_Storm), QEGVAR(fx_post,DB_20)};                           // need to get right CC filter // QEGVAR(fx_post,CC_Muted_Pale_Blue)
        fx_post_coef = 1;

        fx_particle_presets[] = {QEGVAR(fx_particle,Snow), QEGVAR(fx_particle,Snow_25)};                                    // Removed QEGVAR(fx_particle,Branches), QEGVAR(fx_particle,Dust_35),
        fx_particle_coef = 1;
        
        fx_sound_presets[] = {QEGVAR(fx_sound,3D_WindLong),QEGVAR(fx_sound,3D_WindBursts)};
        fx_sound_coef = 1;
    };


    class PVAR(SnowStorm_Bleak) : PVAR(SnowStorm)
    {
        fx_post_presets[] = {QEGVAR(fx_post,CC_ColdSnow_Bleak), QEGVAR(fx_post,FG_Storm), QEGVAR(fx_post,DB_20)};                           // need to get right CC filter // QEGVAR(fx_post,CC_Muted_Pale_Blue)
    };


    class PVAR(SnowStorm_Calm) : PVAR(SnowStorm)
    {
        fx_weather_preset = QEGVAR(fx_weather,SnowStorm_Calm);                                            // Need to make SnowStorm Weather
        fx_weather_coef = 1;

        fx_post_presets[] = {QEGVAR(fx_post,CC_ColdSnow), QEGVAR(fx_post,FG_Storm), QEGVAR(fx_post,DB_20)};                           // need to get right CC filter // QEGVAR(fx_post,CC_Muted_Pale_Blue)
        fx_post_coef = 1;

        fx_particle_presets[] = {QEGVAR(fx_particle,Snow), QEGVAR(fx_particle,Snow_25)};                                    // Removed QEGVAR(fx_particle,Branches), QEGVAR(fx_particle,Dust_35),
        fx_particle_coef = 1;
        
        fx_sound_presets[] = {QEGVAR(fx_sound,3D_WindLong),QEGVAR(fx_sound,3D_WindBursts)};
        fx_sound_coef = 0.3;
    };
};
