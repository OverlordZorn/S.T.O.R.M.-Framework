#include "../script_component.hpp"

/*
* Author: Zorn
* This function handles currently active jipHandlers for the S.T.O.R.M. Framework, mainly for "client side effects" like particles etc.
* More importantly, it will montior changes to the jip handle when their "expiry time" is reached. 
* Once expiry time < missionTime, the handle will get removed from the JIP stack via remoteExec ["",_handle]
* 
* 2 arrays are being maintained. 
*
*   If a new handle has no expriy date, it will be added to the passive array, so it can be checked via storm_fnc_jipCheck if it already exists.
*   
*   If a handle gets provided with an expiry date, it will be added to the active array and will be sorted by acending expiry, the item that expires first will be on index 0.
*   Aditionally, a pfH starts, checking the expiry date of the first item vs current mission time. Once reached, it will remoteExec ["",_handle], and, if arrayActive empty, stop the pfH.
*    
*   Why so complicated? If the transition of an effect-module, which was initially set to go from x to 0 gets updated again (to anything >0) and instead, does not lead to the termination of said effect,
*   the termination of the JIP needs to be canceled. Therefore, an active monitor is needed.
*
* Arguments:
*
*   0   _expiry     <Number>    Time of Expiry, based on CBA_MissionTime + duration of effect. <-1> means no expiry -> passive Array
*   1   _jipHandle  <String>    String of the JIP handle - usually the _presetName when applicable
* Return Value:
* None
*
* Example:
* [_expiry, _handle]  call Storm_fnc_jipMonitor;
*
* Public: No
*
*   
*
*/


params [
    ["_expiry",     -1,     [0]     ],
    ["_jipHandle",  "",     [""]    ]
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

// Meth_Exists
    	["Meth_Exists", {
            _fnc_scriptName = "Meth_Exists";
            params ["_jipHandle"];

            // Checks if _jipHandle already exists within ether of the arrays, if so, return true
            private _indexActive  = OGET(arrayActive)  findIf { _x#1 isEqualTo _jipHandle };
            private _indexPassive = OGET(arrayPassive) findIf { _x#1 isEqualTo _jipHandle };
            private _return = [false, true] select (_indexActive > -1 || _indexPassive > -1);

            ZRN_LOG_MSG_2(Checked,_jipHandle,_return);

            _return
        }],
// Meth_Update
        ["Meth_Update", {
            _fnc_scriptName = "Meth_Update";

            params ["_expiry","_jipHandle"];

            // check if jipHandle already exists in arrayActive or arrayPassive
            private _indexActive  = OGET(arrayActive)  findIf { _x#1 isEqualTo _jipHandle };
            private _indexPassive = OGET(arrayPassive) findIf { _x#1 isEqualTo _jipHandle };

            ZRN_LOG_5(_this,_expiry,_jipHandle,_indexActive,_indexPassive);

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

            ZRN_LOG_MSG_1(Init,_this);

            // start pfH when arrayActive was previously empty
            private _start_pfH = count OGET(arrayActive) == 0;
            OGET(arrayActive) pushBack _this;

            // sort if needed
            if (count OGET(arrayActive) >1 ) then {
                private _newArray = [ OGET(arrayActive),[],{ _x#0 }, "ASCEND" ] call BIS_fnc_sortBy;
                OSET(arrayActive,_newArray);

            };
            ZRN_LOG_1(_start_pfH);
            // start pfH if not previously active
            if (_start_pfH) then { _self call ["Meth_pfH_Start"] };
        }],

// Meth_pfH_Start
        ["Meth_pfH_Start", {
            _fnc_scriptName = "Meth_pfH_Start";
            // entry = [expiry, handle]
            if (OGET(pfHHandle) != -1) exitWith {ZRN_LOG_MSG(pfH not started - already active);};

            // Start perFrameHandler
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
            OSET(pfHHandle,-1);

            // delete _HMO if active && passive is empty
            // Active can be considered Empty already, otherwise the pfH wouldnt have stopped
            if ( count OGET(arrayPassive) == 0 ) then {
                // HMO can be cleaned up!
                PVAR(jipMonitor_HMO) = nil;                
            };
        }]
    ]];

    ZRN_LOG_MSG_1(HMO created,_hmo isEqualType createHashMap);
    PVAR(jipMonitor_HMO) = _hmo;
};

_hmo call ["Meth_Update", _this];

true
