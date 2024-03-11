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

params ["_vehicle"];

private _groupLeader = leader driver _vehicle;
_vehicle = vehicle _groupLeader; 
vehicle _groupLeader limitSpeed 999;

// Aquire Nearest Location

private _previousLocations = _vehicle getVariable ["previous_locations", false];
if (_previousLocations isEqualTo false) then {
    _previousLocations = [];
};

private _filteredLocations = [];
private _radius = 0;

while {0 isEqualTo count _filteredLocations} do {
    _radius = _radius + 1000;
    _nearLocations = nearestLocations [player,_locationTypes, _radius];
    _filteredLocations = _nearLocations - _previousLocations;
    // systemChat format ['[CVO](debug)(randomLocationWaypoint) _radius: %1 - count _nearLocations: %2 - count _filteredLocations: %3 ', _radius , count _nearLocations ,count _filteredLocations];
};

_nextLocation = selectRandom _filteredLocations;

_previousLocations pushBack _nextLocation;
_vehicle setVariable ["previous_locations", _previousLocations];


// 

private _group = group _groupLeader;
private _heliType = typeOf vehicle _groupLeader;

_pos = getPos _nextLocation;


private _roadsArray = [];
_radius = 0;

while {count _roadsArray == 0} do {
    _radius = _radius + 50;
    _roadsArray = _pos nearRoads _radius;
};

_wpPos =  getPos (selectRandom _roadsArray);

private _helperObjType = "Land_JumpTarget_F"; // Land_HelipadEmpty_F
_helperObj = createVehicle [_helperObjType, [0,0,0]];
_helperObj setPos _wpPos;

_wp = _group addWaypoint [_wpPos, -1];
_wp waypointAttachObject _helperObj;
// _wp setWaypointPosition _wpPos;


// _statement ='vehicle this land "GET OUT";';
// _wp setWaypointStatements ["true", _statement];



[   { (vehicle (_this#0) distance (_this#1)) < 1500 },
    {  vehicle (_this#0) limitSpeed 250; //vehicle (_this#0) flyInHeight [100, false];
        // systemChat "Within 1500 -> 200kph 100m";

        [   { (vehicle (_this#0) distance (_this#1)) < 500 },
            {  vehicle (_this#0) limitSpeed 200; // vehicle (_this#0) flyInHeight [50, true];
                // systemChat "Within 500 -> 150kph 50m";
            
                [   { (vehicle (_this#0) distance (_this#1)) < 300 },
                    {  vehicle (_this#0) limitSpeed 150; // vehicle (_this#0) flyInHeight [30, true];
                        // systemChat "Within 200 -> 100kph 50m";
                    
                        [   { (vehicle (_this#0) distance (_this#1)) < 50 },
                            {  vehicle (_this#0) limitSpeed 75; // vehicle (_this#0) flyInHeight [15, true];
                                // systemChat "Within 50 -> 50kph 30m";

                                    [   { (vehicle (_this#0) distance (_this#1)) < 10 },
                                        {  
                                            // systemChat "Within 50 -> 50kph 30m";
                                            [{[_this#0] execVM "randomLocationWaypoint_Vehicle.sqf";}, [_this#0], 15] call CBA_fnc_waitAndExecute;


                            
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
_marker setMarkerColor "ColorBlue";
_marker setMarkerSize [1.5,1.5];
_marker setMarkerText str (round time);