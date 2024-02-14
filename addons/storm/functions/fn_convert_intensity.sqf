
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
 * [_effectArray, _intensity, _baseArray] call cvo_storm_fnc_convert_intensity;
 * 
 * Public: No
 */

 params [
    ["_effectArray",    [],     [[]]],
    ["_intensity",       1,      [0]],
    ["_baseArray",      [],     [[]]]
 ];

// diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - Start : %1", _this];

if !(_effectArray isEqualTypeArray _baseArray) exitWith {false};

private _resultArray = [];

{
    if (_x isEqualType [] ) then {

        // diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - _x == array : %1", _x];

        private _subArray = _x;
        private _subArrayBase = _baseArray select _forEachIndex;
        private _subResultArray = [];

        {
            _target = _x;
            _base   = _subArrayBase select _forEachIndex;
            _value = linearConversion [0,1,_intensity, _base,_target,true];
    
            // diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - _value : %1", _value];

            _subResultArray pushBack _value;

        } forEach _subArray;

        _resultArray pushBack _subResultArray;
     

    } else {

        // diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - _x != array : %1", _x];

        _target = _x;
        _base   = _baseArray select _forEachIndex;

        _value = linearConversion [0,1,_intensity, _base,_target,true];

        // diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - _value : %1", _value];


        _resultArray pushBack _value;

    };

    // diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - _resultArray : %1", _resultArray];


} forEach _effectArray;

diag_log format ["[CVO][STORM](LOG)(fnc_convert_intensity) - Final result : %1", _resultArray];

_resultArray