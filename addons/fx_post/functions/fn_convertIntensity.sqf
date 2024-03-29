#include "..\script_component.hpp"


/*
 * Author: [Zorn]
 * Takes the any array and applies linearConversion based on a secound array. 2. Array must have same structure as first array.
 *
 * Arguments:
 * 0: _effectArray  <STRING> of configClassname of the desired effect. 
 * 1: _intensity    <NUMBER> in secounds - effect Commit Time in Seconds
 * 2: _baseArray    <Array> Array of the default class
 *
 * Return Value:
 * _appliedArray 
 *
 * Note: 
 *
 * Example:
 * [_effectArray, _intensity, _baseArray] call storm_fxPost_fnc_convert_intensity;
 * 
 * Public: No
 */

params [
    ["_effectArray",    [],     [[]]],
    ["_intensity",       1,      [0]],
    ["_baseArray",      [],     [[]]]
];

private _resultArray = [];
{
    if (_x isEqualType [] ) then {

        private _subArray = _x;
        private _subArrayBase = _baseArray select _forEachIndex;
        private _subResultArray = [];

        {
            private "_value"; 
            _target = _x;
            _base   = _subArrayBase select _forEachIndex;
            if (_base isEqualTo "false") then {
                _value = _target;
            } else {
                _value = linearConversion [0,1,_intensity, _base,_target,true];
            };
    
            _subResultArray pushBack _value;

        } forEach _subArray;

        _resultArray pushBack _subResultArray;
     

    } else {

        private "_value";

        _target = _x;
        _base   = _baseArray select _forEachIndex;

        if (_base isEqualTo "false") then {
            _value = _target;
        } else {
            _value = linearConversion [0,1,_intensity, _base,_target,true];
        };
        _resultArray pushBack _value;
    };
} forEach _effectArray;
_resultArray