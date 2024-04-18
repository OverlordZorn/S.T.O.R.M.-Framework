#include "../script_component.hpp"

/*
* Author: Zorn
* Gets executed once, when the mission starts or the setting changes.
* Will search for all #particlesource and storm_sound_helper
*
* Arguments:
*
* Return Value:
* None
*
* Example:
* [true] call storm_fnc_toggleDebugHelper
*
* Public: Yes
*/

params ["_mode"];

ZRN_LOG_1(_mode);

switch (_mode) do {
    case true: {
        private _mEH_ID = missionNamespace getVariable [QPVAR(Debug_mEH_ID), -1];

        private _classNames = ["Storm_FX_Sound_Helper", "Storm_FX_Particle_Helper", "#particlesource"];
        private _existingObjects = [];
        { _existingObjects append allMissionObjects _x; } forEach _classNames;

        // Add Debug Helper to all _existingObjects 
        {   _debugObj = createVehicleLocal ["Storm_Debug_Helper",[0,0,0]];
            _debugObj attachTo [_x, [0,0,1]];
        } forEach _existingObjects;

        // Add Debug Helper to newly created Objects
        _mEH_ID = addMissionEventHandler ["EntityCreated", {
        	params ["_entity"];
            ZRN_LOG_MSG_2(EH_EntityCreated,_entity,typeOf _entity);
            if !(typeOf _entity in ["Storm_FX_Sound_Helper", "Storm_FX_Particle_Helper", "#particlesource"]) exitWith {};

            _debugObj = createVehicleLocal ["Storm_Debug_Helper",[0,0,0]];
            _debugObj attachTo [_entity, [0,0,1]];
        }];

        // Add EventHandler to remove 
        {   // Delete Event Handler
            _x addEventHandler ["Deleted", {
                params ["_entity"];
                private _attachedObjects = attachedObjects _entitity;
                ZRN_LOG_MSG_2(EH Deleted,_entity,_attachedObjects);
                _attachedObjects = _attachedObjects select { typeOf _x == "Storm_Debug_Helper" };
                { deleteVehicle _x } forEach _attachedObjects;
            }];
        } forEach _existingObjects;

        missionNamespace setVariable [ QPVAR(Debug_mEH_ID) , _mEH_ID ];
    };
    case false: {
        private _mEH_ID   = missionNamespace getVariable [ QPVAR(Debug_mEH_ID) , -1];
        if (_mEH_ID != -1) then { removeMissionEventHandler [EntityCreated,_mEH_ID]; };
        { deleteVehicle _x } forEach (allMissionObjects "Storm_Debug_Helper");

        missionNamespace setVariable [QPVAR(Debug_mEH_ID), -1];
    };
};
