class GVAR(Presets)
{
    class GVAR(Default)
    {
        general =           1.00;
        courage =           1.00;
        aimingAccuracy =    1.00;
        aimingShake =       1.00;
        aimingSpeed =       1.00;
        commanding =        1.00;
        spotDistance =      1.00;
        spotTime =          1.00;
        reloadSpeed =       1.00;

//      endurance =     0.80;     // doesnt exist in arma

    };


    class GVAR(sandstorm_old) : GVAR(Default)               // EGVAR(mod_skill,sandstorm_old)
    {
        general =           0.40;
        courage =           0.30;
        aimingAccuracy =    0.15;
        aimingShake =       0.50;
        aimingSpeed =       0.40;
        commanding =        0.40;
        spotDistance =      0.10;
        spotTime =          0.10;
        reloadSpeed =       0.50;

//      endurance =     0.80;     // doesnt exist in arma
    };
};

