#include "../script_component.hpp"

/*
* Author: Zorn
* This function takes in changes to currently active jipHandlers for the S.T.O.R.M. Framework.
* More importantly, it will montior changes to the jip handle when their "expiry time" is reached. Once expiry time < missionTime
* 
*
* Arguments:
*
* Return Value:
* None
*
* Example:
* ['something', player] call cvo_fnc_sth
*
* Public: Yes
*
*   PVAR(jipMonitor_HMO) -> jipMonitor
*
*   PVAR(arrayActive)  Storm_arrayActive  [[_expiry, _jipHandle], [...]]
*   PVAR(arrayPassive) Storm_arrayPassive [[_expiry, _jipHandle], [...]]
*/


params [
    ["_expiry",     false,  [0,false]    ],
    ["_jipHandle",  "",     [""]         ]
];

private _hmo = missionNameSpace getVariable [QPVAR(jipMonitor_HMO), "404"];

ZRN_LOG_MSG_1(INIT,_hmo);

if (_hmo isEqualTo "404") then {

    _hmo = createHashMapObject [[
        ["pfHHandle", -1],
        ["arrayActive", []],   
        ["arrayPassive", []],

        ["varName", QPVAR(jipMonitor_HMO)],
        ["#flags", ["noCopy", "sealed", "unscheduled"]],
        ["#str", { QPVAR(jipMonitor_HMO) }],

// Meth_Check
    	["Meth_Check", {
            _fnc_scriptName = "Meth_Check";
            params ["_jipHandle"];

            private _indexActive  = OGET(arrayActive)  findIf { _x#1 isEqualTo _jipHandle };
            private _indexPassive = OGET(arrayPassive) findIf { _x#1 isEqualTo _jipHandle };
            private _return = [false, true] select (_indexActive > - 1 || _indexPassive > -1);
            _return
        }],
// Meth_Update
        ["Meth_Update", {
            _fnc_scriptName = "Meth_Update";

            params ["_expiry","_jipHandle"];

            // check if jipHandle already exists in arrayActive or arrayPassive
            private _indexActive  = OGET(arrayActive)  findIf { _x#1 isEqualTo _jipHandle };
            private _indexPassive = OGET(arrayPassive) findIf { _x#1 isEqualTo _jipHandle };

            if (_expiry isEqualTo -1) then {
                // remove entry from arrayActive if already exists
                if ( _indexActive != -1) then {
                    OGET(arrayActive) deleteAt _indexActive;
                    // Stop pfHandler if arrayActive is now empty
                    if (count OGET(arrayActive) == 0) then { _self call ["Meth_pfH_Stop"] };
                };

                // add new entry to arrayPassive if it wasnt existing already
                if ( _indexPassive == -1) then {
                    OGET(arrayPassive) pushBack _this;
                };

            } else {
            // Handles if the incoming change needs to be actively monitored
                // Removes entry if it was previously in an array
                if (_indexPassive != -1) then { OGET(arrayPassive) deleteAt _indexPassive; };
                if (_indexActive != -1) then { OGET(arrayActive) deleteAt _indexActive };

                // add Entry to Active Array and re-sort the array
                _self call ["Meth_NewActiveEntry", _this];

            };
        }],

// Meth_NewActiveEntry
        ["Meth_NewActiveEntry",{
            _fnc_scriptName = "Meth_NewActiveEntry";
            // start pfH when arrayActive was previously empty
            private _start_pfH = false;
            if (count OGET(arrayActive) == 0) then { _start_pfH = true };

            OGET(arrayActive) pushBack _this;

            // sort if needed
            if (count OGET(arrayActive) >1 ) then {
                private _newArray = [ OGET(arrayActive),[],{ _x#0 }, "ASCEND" ] call BIS_fnc_sortBy;
                OSET(arrayActive,_newArray);

            };
            
            // start pfH if not previously active
            if (_start_pfH) then { _self call ["Meth_pfH_Start"] };

        }],
// Meth_pfH_Start
        ["Meth_pfH_Start", {
            _fnc_scriptName = "Meth_pfH_Start";
            // entry = [expiry, handle]
            if (OGET(pfHHandle) != -1) exitWith {ZRN_LOG_MSG_1(MSG,A);};

            private _handle = [{
                if (PVAR(jipMonitor_HMO) get "arrayActive" select 0 select 0 < CBA_MissionTime) then {
                    private _entry = PVAR(jipMonitor_HMO) get "arrayActive" deleteAt 0;
                    remoteExec ["", _entry#1];
                    if (count (PVAR(jipMonitor_HMO) get "arrayActive") == 0) then {
                        PVAR(jipMonitor_HMO) call ["Meth_pfH_Stop"];
                    };
                };
            }, 0, []] call CBA_fnc_addPerFrameHandler;
            OSET(pfHHandle,_handle);
        }],

// Meth_pfH_Stop
        ["Meth_pfH_Stop", {
            _fnc_scriptName = "Meth_pfH_Stop";
            private _fnc_scriptName = "Meth_pfH_Stop";
            private _handle = OGET(pfHHandle);
            if (_handle isNotEqualTo -1) then { [_handle] call CBA_fnc_removePerFrameHandler };
            OSET(handle,-1);

            // delete _HMO if active && passive is empty
        }]
    ]];
};

_hmo call ["Meth_Update", [_jipHandle,_expiry]];
