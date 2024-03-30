#include "..\script_component.hpp"

/*
 * Author: Zorn
 * Creates, Adjusts and ParticleEffects over time with intensity. 
 *
 * Arguments:
 * 0: _effectName    <STRING> Name of Particle Effect Preset - Capitalisation needs to be exact!
 * 1: _duration          <NUMBER> in Minutes for the duration to be applied.
 * 2: _intensity         <NUMBER> 0..1 Factor of Intensity for the PP Effect 
 *
 * Return Value:
 * _pe_effect_JIP_handle  <STRING>
 *
 * Example:
 * ["CVO_PE_Default", 5, 0.5] call cvo_storm_fnc_particle_request;
 * 
 * Public: No
 */

 /////////// TODO: MACRO_FY

if (!isServer) exitWith { _this remoteExecCall [ QFUNC(request), 2, false]; };


params [
   ["_effectName",             "", [""]],
   ["_duration",               1,  [0]],
   ["_intensity",              0,  [0]]
];


_intensity = _intensity max 0 min 1;
_duration = 60 * (_duration max 1);

ZRN_LOG_MSG_3(INIT,_effectName,_duration,_intensity);

//Check if config Exists
if  (_effectName isEqualTo "")                                                                               exitWith { ZRN_LOG_MSG(failed: effectName not provided); false };
if !(_effectName in (configProperties [configFile >> "CfgCloudlets", "true", true] apply { configName _x })) exitWith { ZRN_LOG_MSG(failed: effectName not found); false };
if ( _intensity == 0 && { isNil QGVAR(activeJIP) || { !(_effectName in GVAR(activeJIP))} } )                 exitWith { ZRN_LOG_MSG(failed: _intensity == 0 while no previous effect of same type); false };
if (isNil QGVAR(activeJIP)) then { GVAR(activeJIP) = createHashMap; };
if (_effectName in GVAR(activeJIP) && { (GVAR(activeJIP) get _effectName) } )                                exitWith { ZRN_LOG_MSG(failed: this effectName is currently in Transition); false };

/////////////////////////////////////////////////////////////////////////////
// RemoteExec the request
private _effectName = [_effectName, _duration, _intensity] remoteExecCall [QFUNC(remote), [0,2] select isDedicated, _effectName];
if (isNil "_effectName") exitWith { ZRN_LOG_MSG(failed: remoteExec failed); false };
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// Handles In-Transition-Check
GVAR(activeJIP) set [_effectName, true];
[{  
    GVAR(activeJIP) set [_this#0, false];
}, [_effectName], _duration] call CBA_fnc_waitAndExecute;
/////////////////////////////////////////////////////////////////////////////


if (_intensity == 0) then {
    // Handles Cleanup of JIP in case of decaying(transition-> 0) Effect once transition to 0 is completed.
    [{
        GVAR(activeJIP) deleteAt _this#0;
        remoteExec ["", _this#0]; // removes entry from JIP Queue
        if ( count GVAR(activeJIP) == 0) then { GVAR(activeJIP) = nil; };
    }, [_effectName], _duration] call CBA_fnc_waitAndExecute;

};

true