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
