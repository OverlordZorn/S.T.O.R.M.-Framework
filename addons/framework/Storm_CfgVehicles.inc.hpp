class CfgVehicles
{
    class Helper_Base_F;
    class Storm_Base_Helper : Helper_Base_F
    {
        author = MOD_NAME_BEAUTIFIED;
        displayName = "S.T.O.R.M. Helper";
        icon = PATH_TO_ADDON_3(data,icons,logo_256.paa);
    };
    class Storm_FX_Sound_Helper : Storm_Base_Helper
    {
        displayName = "S.T.O.R.M. FX Sound Helper";
    };
    class Storm_FX_Particle_Helper : Storm_Base_Helper
    {
        displayName = "S.T.O.R.M. FX Particle Helper";
    };


    class Sign_Arrow_Large_F;
    class Storm_Debug_Helper : Sign_Arrow_Large_F
    {
        scope = 1;
        author = MOD_NAME_BEAUTIFIED;
        displayName = "S.T.O.R.M. Debug Helper";
        icon = PATH_TO_ADDON_3(data,icons,logo_256.paa);
    };
};