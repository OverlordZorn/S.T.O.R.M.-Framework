_CCppEffect_test1 = 
[
    1, 
    0.4, 
    0, 
    [0, 0, 0, 0], 
    [1, 1, 1, 0], 
    [1, 1, 1, 0]
];


_CCppEffect_test2 = 
[
    1, 
    0.4, 
    0, 
    [1, 1, 1, 1], 
    [1, 1, 1, 0], 
    [1, 1, 1, 0]
];

_CCppEffect_default = [
	1,
	1,
	0,
	[0, 0, 0, 0],
	[1, 1, 1, 1],
	[0.299, 0.387, 0.114, 0],
	[-1, -1, 0, 0, 0, 0, 0]
];


handle1 = ppEffectCreate ["ColorCorrections", 1300];
handle1 ppEffectEnable true;
systemChat "starting applying effect 1";
handle1 ppEffectAdjust _CCppEffect_test1;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 1";
uiSleep 3;
systemChat "starting applying effect 2";
handle1 ppEffectAdjust _CCppEffect_test2;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 2";
uiSleep 3;
systemChat "starting applying effect 1";
handle1 ppEffectAdjust _CCppEffect_test1;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 1";
uiSleep 3;
systemChat "starting applying effect 2";
handle1 ppEffectAdjust _CCppEffect_test2;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 2";
uiSleep 3;
systemChat "starting applying effect 1";
handle1 ppEffectAdjust _CCppEffect_test1;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 1";
uiSleep 3;
systemChat "starting applying effect 2";
handle1 ppEffectAdjust _CCppEffect_test2;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 2";
uiSleep 3;
systemChat "starting applying effect 1";
handle1 ppEffectAdjust _CCppEffect_test1;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 1";
uiSleep 3;
systemChat "starting applying effect 2";
handle1 ppEffectAdjust _CCppEffect_test2;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 2";
uiSleep 3;
systemChat "starting applying effect 1";
handle1 ppEffectAdjust _CCppEffect_test1;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 1";
uiSleep 3;
systemChat "starting applying effect 2";
handle1 ppEffectAdjust _CCppEffect_test2;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "admire effect 2";
uiSleep 3;
systemChat "starting applying default";
handle1 ppEffectAdjust _CCppEffect_default;
handle1 ppEffectCommit 2;
waitUntil { ppEffectCommitted handle1 };
systemChat "default should have been restored by now";
uiSleep 3;
ppEffectDestroy handle1;

// ^ this seems to work!

// ################ Blinking ProtoType

["CVO_CC_Radial_Blinking_open", 0.1, 1] call cvo_storm_fnc_apply_ppeffect;
sleep 0.1*60;
systemChat "open established";
sleep 5;
systemchat "start squinting";
["CVO_CC_Radial_Blinking_half", 0.25, 1] call cvo_storm_fnc_apply_ppeffect;
sleep 15;
systemchat "start blinking";

["CVO_CC_Radial_Blinking_closed", (1/120), 1] call cvo_storm_fnc_apply_ppeffect;
sleep 0.5;
["CVO_CC_Radial_Blinking_half", (1/120), 1] call cvo_storm_fnc_apply_ppeffect;
sleep 0.5;
["CVO_CC_Radial_Blinking_closed", (1/120), 1] call cvo_storm_fnc_apply_ppeffect;
sleep 0.5;
["CVO_CC_Radial_Blinking_half", (1/120), 1] call cvo_storm_fnc_apply_ppeffect;


// ################ Blinking ProtoType
// restore previous weather from hashmap

params ["_duration", "_hashmap"];

{
    // key =  ; value = _y

    switch (_x) do {
        case "overcast":    {_duration setOvercast      _y};
//      case "rain":        {_duration setRain          _y};    // Use Rain Transition that considers the change of Rain Parameters if present.
//      case "RainParams":  {  _y call BIS_fnc_setRain    };    // Use Rain Transition that considers the change of Rain Parameters if present.
        case "lightnings":  {_duration setlightnings    _y};
        case "fogParams":   {_duration setFog           _y};
//      case "wind":        { set wind function over time };
        case "gusts":       {_duration setGusts         _y};
        case "Waves":       {_duration setWaves         _y};
    };

} forEach _hashMap;



// ### Avoid setWindStr because it affects max fog_value.