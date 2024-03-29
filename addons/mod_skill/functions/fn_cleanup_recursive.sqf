#include "..\script_component.hpp"

/*
* Author: Zorn
* Takes an Array of Units to apply setskill to one per frame.
*
* Arguments:
* 0:  _array_Units        <ARRAY> of Objects  - Objects to be 
*
* Return Value:
* None
*
* Example:
* [allUnits] call storm_mod_skill_fnc_cleanup_recursive;
*
* Public: No 
*/

params [
    ["_array_units",    [],     [ []            ]   ]
];

private _unit = _array_units deleteAt 0;

if (count _array_units > 0) then {
    _statement = { _this call FUNC(cleanup_recursive); };
    _parameters = [_array_units];
    [_statement, _parameters] call CBA_fnc_execNextFrame;
} else {ZRN_LOG_MSG(Cleanup done);};

/*
if (_unit isKindOf "Man")   exitWith {};
if (!alive _unit)           exitWith {};
if (isPlayer _unit)         exitWith {};
*/

_unit setVariable [QGVAR(preSkills), false];

// Hands off the remaining array with same parameters to the next iteration

