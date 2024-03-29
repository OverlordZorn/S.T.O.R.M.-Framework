class GVAR(Presets)             // class to be used for 3D sounds
{
    class GVAR(3D_Base)             // class to be used for 3D sounds
    {
        maxDistance = 0;
        minDistance = 0;
        direction = "WIND";
        sounds[] = {};  

        maxDelay = 0;
        minDelay = 0;  
    };

    class GVAR(3D_WindLong) : GVAR(3D_Base)             // class to be used for 3D sounds
    {
        maxDistance = 1500;
        minDistance = 500;

        direction = "WIND";

        maxDelay = 30;
        minDelay = 3;  

        sounds[] = {QGVAR(WindLong1), QGVAR(WindLong2)};
    };

    class GVAR(3D_WindBursts) : GVAR(3D_Base)               // class to be used for 3D sounds
    {
        maxDistance = 50;
        minDistance = 5;

        maxDelay = 30;
        minDelay = 3;  

        direction = "RAND";

        sounds[] = {QGVAR(WindBurst1), QGVAR(WindBurst2), QGVAR(WindBurst3), QGVAR(WindBurst4), QGVAR(WindBurst5)};  
    };
};