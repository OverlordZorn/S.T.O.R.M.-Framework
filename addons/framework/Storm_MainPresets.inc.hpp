class PVAR(mainPresets)
{
    class PVAR(Default)
    {
        author = AUTHOR;
        storm_name = QPVAR(Default);

        mod_skill_preset = ""; // QEGVAR(mod_skill,sandstorm_old)
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

    class PVAR(Sandstorm) : PVAR(Default)
    {
        storm_name = QPVAR(Sandstorm);

        mod_skill_preset = QEGVAR(mod_skill,sandstorm_old);
        mod_skill_coef = 1;

        fx_weather_preset = QEGVAR(fx_weather,Sandstorm_01);
        fx_weather_coef = 1;

        fx_post_presets[] = {QEGVAR(fx_post,CC_Mars_Storm), QEGVAR(fx_post,FG_Storm), QEGVAR(fx_post,DB_20)};
        fx_post_coef = 1;

        fx_particle_presets[] = {QEGVAR(fx_particle,Branches), QEGVAR(fx_particle,Dust_High_35), QEGVAR(fx_particle,Dust_High_100)};
        fx_particle_coef = 1;
        
        fx_sound_presets[] = {QEGVAR(fx_sound,3D_WindLong),QEGVAR(fx_sound,3D_WindBursts)};
        fx_sound_coef = 1;
    };
};
