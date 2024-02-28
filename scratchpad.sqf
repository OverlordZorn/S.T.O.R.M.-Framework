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

["CVO_CC_Radial_Blinking_open", 0.1, 1] call cvo_storm_fnc_ppEffect_apply;
sleep 0.1*60;
systemChat "open established";
sleep 5;
systemchat "start squinting";
["CVO_CC_Radial_Blinking_half", 0.25, 1] call cvo_storm_fnc_ppEffect_apply;
sleep 15;
systemchat "start blinking";

["CVO_CC_Radial_Blinking_closed", (1/120), 1] call cvo_storm_fnc_ppEffect_apply;
sleep 0.5;
["CVO_CC_Radial_Blinking_half", (1/120), 1] call cvo_storm_fnc_ppEffect_apply;
sleep 0.5;
["CVO_CC_Radial_Blinking_closed", (1/120), 1] call cvo_storm_fnc_ppEffect_apply;
sleep 0.5;
["CVO_CC_Radial_Blinking_half", (1/120), 1] call cvo_storm_fnc_ppEffect_apply;



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


cvo_debug = true;
[] spawn {
    while {cvo_debug} do {
        sleep 1;
        systemChat str _variable;
    };
};




// create helper obj, attached to vehicle player, relative to player speed vector - windvector 

cvo_debug = false; 
cvo_debug = true;
private _test_obj_array = [player, test_dummy];


{
	_x spawn {
		params ["_objTarget"];

		private _helperObj_class = "Helper_Base_F";
		private _helperObj = createVehicleLocal [_helperObj_class, [0,0,0] ];

		while {cvo_debug} do {
			_speedVectorRelative = velocityModelSpace vehicle _objTarget;
			_relPosArray = _speedVectorRelative vectorDiff (	( vehicle _objTarget vectorWorldToModel wind ) vectorMultiply 0.9);
			_helperObj attachTo [vehicle _objTarget,_relPosArray ];
			sleep 0.05;
		};
		deleteVehicle _helperObj;
	};
} forEach _test_obj_array;



////

cvo_debug_fnc_var_array = {
    params [
        [["_ModuleNameArray"], [], []],
        [["_varNameArray"], [], []],
    ];

    // creates and returns array for the "format" command.
    // ["[CVO][MODULE_x0](Module_x1)(Module_xN) _varName_x1: %1 - _varName_xN: %N", _var_x1, _var_xN]


    private _finalString = "";
    private _varArray = [];

    // header
    {    _str = if (_forEachIndex in [0,1]) then {"[" + _x + "]"} else {"()" + _x + ")"}
        _finalString = _finalString + _str;
    } forEach _moduleNameArray;


    {
        _str = " " + _x + ": %" + str (_forEachIndex + 1) + " -";
        _finalString = _finalString + _str;

        _varArray append [missionNamespace getVariable [_x, "NotFound"]];    
    } forEach _varNameArray;

    _strArray = _finalString splitString "";
    _strArray deleteAt [-1,-2];
    _finalString = _strArray joinString "";





    _returnArray = [_finalString];
    _returnArray append _varArray;
    _returnArray
};





// Particle Emitter "helper Object classname
"Helper_Base_F"







/// 
Some Technically Overdone Remotely-Executed Meteorology-Stuff
Storms, Technically Optimised, Really Mom, Sheesh!
System for Tactical Operations during Meteorological Situations
Scenario-based Tropical Atmosphere Reconstruction Methodology 