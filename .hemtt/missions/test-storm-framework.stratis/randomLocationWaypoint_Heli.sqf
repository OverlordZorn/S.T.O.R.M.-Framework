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
vehicle _groupLeader limitSpeed 999;
vehicle _groupLeader flyInHeight [100, false];

// Aquire Nearest Location

private _previousLocations = missionNamespace getVariable ["previous_locations", false];
if (_previousLocations isEqualTo false) then {
    _previousLocations = [];
};

private _filteredLocations = [];
private _radius = 0;

while {0 isEqualTo count _filteredLocations} do {
    _radius = _radius + 3000;
    _nearLocations = nearestLocations [player,_locationTypes, _radius];
    _filteredLocations = _nearLocations - _previousLocations;
    systemChat format ['[CVO](debug)(randomLocationWaypoint) _radius: %1 - count _nearLocations: %2 - count _filteredLocations: %3 ', _radius , count _nearLocations ,count _filteredLocations];
};

_nextLocation = selectRandom _filteredLocations;

_previousLocations pushBack _nextLocation;
missionNamespace setVariable ["previous_locations", _previousLocations];


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

_wp = _group addWaypoint [_wpPos, -1];
_wp waypointAttachObject _helperObj;
_wp setWaypointPosition _wpPos;


_statement ='vehicle this land "GET OUT";';

_wp setWaypointStatements ["true", _statement];



[   { (vehicle (_this#0) distance2D (_this#1)) < 1500 },
    {  vehicle (_this#0) limitSpeed 250; vehicle (_this#0) flyInHeight [50, true];
        systemChat "Within 1500 -> 250kph 50m";

        [   { (vehicle (_this#0) distance2D (_this#1)) < 500 },
            {  vehicle (_this#0) limitSpeed 200; vehicle (_this#0) flyInHeight [30, true];
                systemChat "Within 500 -> 200kph 30m";
            
                [   { (vehicle (_this#0) distance2D (_this#1)) < 300 },
                    {  vehicle (_this#0) limitSpeed 150; vehicle (_this#0) flyInHeight [20, true];
                        systemChat "Within 300 -> 150kph 20m";
                    
                        [   { (vehicle (_this#0) distance2D (_this#1)) < 50 },
                            {  vehicle (_this#0) limitSpeed 75; vehicle (_this#0) flyInHeight [10, true];
                                systemChat "Within 50 -> 75kph 10m";

                                    [   { (vehicle (_this#0) distance2D (_this#1)) < 10 },
                                        {  
                                            systemChat "Within 10 -> 15s to Take Off";
                                            [{[_this#0] execVM "randomLocationWaypoint_Heli.sqf";}, [_this#0], 15] call CBA_fnc_waitAndExecute;


                            
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
_marker setMarkerSize [2,2];
_marker setMarkerText str (round time);






