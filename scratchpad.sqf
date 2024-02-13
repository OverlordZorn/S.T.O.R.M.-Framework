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