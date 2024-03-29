#include "..\script_component.hpp"

/*
* Author: Zorn
* Takes an Array of Units to apply setskill to one per frame.
*
* Arguments:
* 0:  _array_Modifier     <HASH> of Numbers
* 1:  _array_Units        <ARRAY> of Objects  - Objects to be 
*
* INTERAL Parameters. DO NOT USE!
* 2: _iteration     
*
* Return Value:
* None
*
* Example:
* [_array_mod, _array_units] call storm_modSkill_fnc_setSkill_recursive;
*
* Public: No 
*/

params [
    ["_array_mod",      "",     [ createHashMap ]   ], 
    ["_array_units",    [],     [ []            ]   ],
    ["_iteration",       0,     []                  ]
];


if (_iteration == 0) then {
    if (!(_array_mod isEqualType createHashMap))    exitWith {false};
    if (count _array_units == 0)                    exitWith {false};
};
_iteration = _iteration + 1;

private _unit = _array_units deleteAt 0;


private _base_Ai_Skill_Hash = _unit getVariable [QGVAR(preSkills), false];

// stores initial Units SubSkills 
if (_base_Ai_Skill_Hash isEqualTo false) then {
    _base_Ai_Skill_Hash = createHashMap;
    { _base_Ai_Skill_Hash set [_x, (_unit skill _x)] } forEach ["general","courage","aimingAccuracy","aimingShake","aimingSpeed","commanding","spotDistance","spotTime","reloadSpeed"];
    _unit setVariable [QGVAR(preSkills), _base_Ai_Skill_Hash];
};


// set Skill based on _array_mod
{   
    _value = ( _base_Ai_Skill_Hash get _x ) * _y;
    _unit setSkill [_x, _value];
} forEach _array_mod;

// Handle Exit of self-calling function
if (count _array_units == 0) exitWith {
    ZRN_LOG_MSG(completed);
};

// Hands off the remaining array with same parameters to the next iteration

diag_log format ["[CVO](debug)(fn_AI_setSkill) [%3] Done: %1 Remaining: %2", _iteration, count _array_units, diag_frameno];

_statement = {     [{_this call CVO_STORM_fnc_AI_setSkill_recursive; }, _this] call CBA_fnc_execNextFrame;  };
[_statement, [_array_mod, _array_units, _iteration]] call CBA_fnc_execNextFrame;
