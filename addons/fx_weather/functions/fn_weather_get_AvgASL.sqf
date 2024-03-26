#include "..\script_component.hpp"

/*
*	Author: MrZorn
*
*	Description:
*		Gathers ASL of Ground Beneath Players feet, then, groups them in "brackets", finds the Bracket with the most players, and returns the Average ASL of those Players.
*
*
*	Parameter(s):
*  0 : _bracketSize 	<NUMBER> Size of bracket in Meters. 
*
*	Returns:
*		<array> <[suggested fogBase, _range from max to min]>
*
*	Examples:
*		   _var = [] call cvo_storm_fnc_weather_get_AvgASL;
*
*/

params [
	["_bracketSize", 25, [0]]
];

private _arr = [];
{_arr pushback (name _x) } forEach allPlayers;

private _allPlayers = call BIS_fnc_listPlayers;
private _allASL = [];
private _filteredPlayers = [];

if (count _allPlayers > 3) then {
	// Removes Zeus players based on zeus.
	_filteredPlayers =_allPlayers select {getAssignedCuratorLogic _x isEqualTo objNull};
	// If all Players are Zeus, use allPlayers.
	if ( count _filteredPlayers <= 1 ) then {_filteredPlayers = _allPlayers };
} else {
	_filteredPlayers = _allPlayers;
};

// diag_log format ['[CVO](debug)(fn_weather_get_AvgASL) _allPlayers: %1 - _filteredPlayers: %2', _allPlayers , _filteredPlayers];

_allASL = _filteredPlayers apply {
    switch (isTouchingGround vehicle _x) do {
        case true:  {  getPosASL _x select 2  };
        case false: { (getPosASL _x select 2 ) - (getPos _x select 2)    };
    };
};

if (count _allASL == 0) exitWith {diag_log "[CVO](debug)(fn_weather_get_AvgASL) failed - empty _allASL "; 0}; 

_allASL sort true;

// diag_log format ['[CVO](debug)(fn_weather_get_AvgASL) _allASL: %1', _allASL];

private _min = selectMin _allASL;
private _max = selectMax _allASL;
private _range = _max - _min;

private _result = [];
private _arr2 = [];

_arr2 = _allASL apply { floor (_x/_bracketSize) };
_arr2 = _arr2 call BIS_fnc_consolidateArray;
_arr2 = [_arr2, 1, false] call CBA_fnc_sortNestedArray;
_avgASL = ((_arr2 select 0) select 0) * _bracketSize + _bracketSize * 0.5;
_avgASL = [_allASL, _avgASL] call BIS_fnc_nearestNum;

_result = _avgASL;

//_result = [_avgASL, _range];
// diag_log ("[CVO] [ENV] (allPlayersASL) - " + format ["return: %1 - ASLs: %2 - Min: %3 - Max: %4",_result, _allASL, _min, _max]);

// diag_log format ['[CVO](debug)(fn_weather_get_AvgASL) _result: %1', _result];
_result


/* 
 	how to define the returning value? 
		https://cbateam.github.io/CBA_A3/docs/files/arrays/fnc_filter-sqf.html
		https://cbateam.github.io/CBA_A3/docs/files/arrays/fnc_sortNestedArray-sqf.html
		https://community.bistudio.com/wiki/BIS_fnc_consolidateArray
*/ 

// TODO FIND ERROR HERE