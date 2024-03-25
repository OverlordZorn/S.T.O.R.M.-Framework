class CVO_SFX_Presets
{
    class CVO_SFX_Spacial_Base
    {
        maxDistance = 0;
        minDistance = 0;
        direction = "WIND";
        sounds[] = {};  

        maxDelay = 0;
        minDelay = 0;  
    };

    class CVO_SFX_Spacial_WindLong : CVO_SFX_Spacial_Base
    {
        maxDistance = 1500;
        minDistance = 500;

        direction = "WIND";

        maxDelay = 30;
        minDelay = 5;  

        sounds[] = {"CVO_SFX_SS_WindLong1", "CVO_SFX_SS_WindLong2"};
    };

    class CVO_SFX_Spacial_WindBursts : CVO_SFX_Spacial_Base
    {
        maxDistance = 150;
        minDistance = 25;

        maxDelay = 30;
        minDelay = 3;  

        direction = "RAND";

        sounds[] = {"CVO_SFX_SS_WindBurst1", "CVO_SFX_SS_WindBurst2", "CVO_SFX_SS_WindBurst3", "CVO_SFX_SS_WindBurst4", "CVO_SFX_SS_WindBurst5"};  
    };
};