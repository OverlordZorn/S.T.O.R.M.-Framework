class GVAR(Presets)             // class to be used for 3D sounds
{
    class GVAR(3D_Base)             // class to be used for 3D sounds
    {
        name = "3D_Base";

        distanceMax = 0;
        distanceMin = 0;
        direction = "WIND";
        sounds[] = {};  

        delayMax = 0;
        delayMin = 0;  
    };

    class GVAR(3D_WindLong) : GVAR(3D_Base)             // class to be used for 3D sounds
    {
        name = "3D_WindLong";

        distanceMax = 1000;
        distanceMin = 250;

        direction = "WIND";

        delayMax = 30;
        delayMin = 0;  

        sounds[] = {QGVAR(WindLong1), QGVAR(WindLong2)};
    };

    class GVAR(3D_WindBursts) : GVAR(3D_Base)               // class to be used for 3D sounds
    {
        name = "3D_WindBursts";

        distanceMax = 50;
        distanceMin = 5;

        delayMax = 30;
        delayMin = 0;  

        direction = "RAND";

        sounds[] = {QGVAR(WindBurst1), QGVAR(WindBurst2), QGVAR(WindBurst3), QGVAR(WindBurst4), QGVAR(WindBurst5)};  
    };
};