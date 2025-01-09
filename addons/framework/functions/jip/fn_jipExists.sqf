#include "..\../script_component.hpp"

/*
* Author: Zorn
* Function to check if a jipHandle already exists. also checks if the jipMonitor HMO already exists.
*
* Arguments:
* 0 _jipHandle
*
* Return Value:
* boolean - if jipHandle already exists, true, else false
*
* Example:
* [_jipHandle] call PFUNC(jipExists)
*
* Public: false
*/

params ["_jipHandle"];

private _exists = if ( isNil QPVAR(jipMonitor_HMO) ) then {
    ZRN_LOG_MSG_1(HMO doenst exist yet,false);
    false
} else {
    PVAR(jipMonitor_HMO) call ["Meth_Exists", [_jipHandle]]
};
ZRN_LOG_MSG_2(checked,_jipHandle,_exists);

_exists
