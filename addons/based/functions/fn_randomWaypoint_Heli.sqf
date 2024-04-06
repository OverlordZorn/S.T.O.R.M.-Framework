_locationTypes = ["Airport",
"BorderCrossing",
"CivilDefense",
"CulturalProperty",
"Flag",
"FlatArea",
"FlatAreaCity",
"FlatAreaCitySmall",
"Hill",
"HistoricalSite",
"Name",
"NameCity",
"NameCityCapital",
"NameLocal",
"NameMarine",
"NameVillage",
"RockArea",
"SafetyZone",
"Strategic",
"StrongpointArea",
"VegetationBroadleaf",
"VegetationFir",
"VegetationPalm",
"VegetationVineyard",
"ViewPoint"];

params ["_heli"];

private _groupLeader = leader driver _heli;
_heli = vehicle _groupLeader;
vehicle _groupLeader limitSpeed 999;
vehicle _groupLeader flyInHeight [50, true];

// Aquire Nearest Location

private _previousLocations = _heli getVariable ["previous_locations", false];
if (_previousLocations isEqualTo false) then {
    _previousLocations = [];
};

private _filteredLocations = [];
private _radius = 0;

while {0 isEqualTo count _filteredLocations} do {
    _radius = _radius + 5000;
    _nearLocations = nearestLocations [player,_locationTypes, _radius];
    _filteredLocations = _nearLocations - _previousLocations;
    // systemChat format ['[CVO](debug)(randomLocationWaypoint) _radius: %1 - count _nearLocations: %2 - count _filteredLocations: %3 ', _radius , count _nearLocations ,count _filteredLocations];
};

_nextLocation = selectRandom _filteredLocations;

_previousLocations pushBack _nextLocation;
_heli setVariable ["previous_locations", _previousLocations];


// 

private _group = group _groupLeader;
private _heliType = typeOf vehicle _groupLeader;

_pos = getPos _nextLocation;


private _wpPos = 0;
_radius = 0;

while {_wpPos isEqualType 0} do {
    _radius = _radius + 50;
    _wpPos = [_pos, 0, _radius, 2.5 * (boundingBox vehicle _groupLeader # 2), 0, 0.25,0,[],[0,0,0]] call BIS_fnc_findSafePos;
};
_wpPos set [2,0];

private _helperObjType = "Land_JumpTarget_F"; // Land_HelipadEmpty_F
_helperObj = createVehicle [_helperObjType, [0,0,0]];
_helperObj setPos _wpPos;
_wpPos = getPosASL _helperObj;

_wp = _group addWaypoint [(AGLToASL _wpPos), -1];

// diag_log format ['[CVO](debug)(randomLocationWaypoint_Heli) _wp: %1 - _wppos: %2 - _helperObj: %3 - _group: %4 - _groupLeader: %5 - _nextLocation: %6 - _pos: %7 - _wpPos: %8', _wp , _wppos ,_helperObj , _group , _groupLeader , _nextLocation , _pos , _wpPos ];

_wp setWaypointType "MOVE";
_wp setWaypointPosition [_wpPos, -1];


_wp waypointAttachObject _helperObj;

_statement ='vehicle this land "GET OUT";';
_wp setWaypointStatements ["true", _statement];



[   { (vehicle (_this#0) distance2D (_this#1)) < 3000 },
    {  vehicle (_this#0) limitSpeed 200; vehicle (_this#0) flyInHeight [50, true];
        // systemChat "Heli - Within 3000 -> 200kph 50m";
        // diag_log format ['[CVO](debug)(randomLocationWaypoint_Heli) _this#0: %1 - _this#1: %2', _this#0 , _this#1];

        [   { (vehicle (_this#0) distance2D (_this#1)) < 2000 },
            {  vehicle (_this#0) limitSpeed 150; vehicle (_this#0) flyInHeight [30, true];
                // systemChat "Heli - Within 2000 -> 150kph 30m";
           
                [   { (vehicle (_this#0) distance2D (_this#1)) < 1000 },
                    {  vehicle (_this#0) limitSpeed 100; vehicle (_this#0) flyInHeight [20, true];
                        // systemChat "Heli - Within 1000 -> 100kph 20m";
                        
                        [   { (vehicle (_this#0) distance2D (_this#1)) < 250 },
                            {  vehicle (_this#0) limitSpeed 50; vehicle (_this#0) flyInHeight [10, true];
                                // systemChat "Heli - Within 50 -> 50kph 10m";
                                
                                    [   { (vehicle (_this#0) distance2D (_this#1)) < 30 },
                                        {  


                                            [   { (vehicle (_this#0) distance2D (_this#1)) < 15 },
                                            {  
                                                // systemChat "Heli - Within 5 -> 30s to Take Off";
                                                [{[_this#0] execVM "randomLocationWaypoint_Heli.sqf";}, [_this#0], 60] call CBA_fnc_waitAndExecute;
                                
                                            },
                                            [_this#0, _this#1]] call CBA_fnc_waitUntilAndExecute;
                           
                                        },
                                    [_this#0, _this#1]] call CBA_fnc_waitUntilAndExecute;

                            },
                        [_this#0, _this#1]] call CBA_fnc_waitUntilAndExecute;

                    },
                [_this#0, _this#1]] call CBA_fnc_waitUntilAndExecute;
            
            },
        [_this#0, _this#1]] call CBA_fnc_waitUntilAndExecute;
   
    },
[_groupLeader, _helperObj]] call CBA_fnc_waitUntilAndExecute;
 


_marker = createMarker [str time, _wpPos, -1];
_marker setMarkerType "hd_pickup";
_marker setMarkerColor "ColorGreen";
_marker setMarkerSize [1,1];
_marker setMarkerText str (round time);






