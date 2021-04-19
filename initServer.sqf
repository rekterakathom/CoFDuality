/*

Server-side initialization.

*/

nopop = true;
	publicVariable "nopop";
reflexActive = false;
	publicVariable "reflexActive";
comp_1_ready = false;
	publicVariable "comp_1_ready";
comp_2_ready = false;
	publicVariable "comp_2_ready";
drillscript_active = false;
	publicVariable "drillscript_active";

if ( isClass ( configfile >> "CfgPatches" >> "ace_arsenal" ) ) then {
	[arsenal_1, true, true] call ace_arsenal_fnc_initBox;
	[arsenal_2, true, true] call ace_arsenal_fnc_initBox;
	execVM "blacklist.sqf";
};
["AmmoboxInit", [arsenal_1, true]] spawn BIS_fnc_arsenal;
["AmmoboxInit", [arsenal_2, true]] spawn BIS_fnc_arsenal;

//Start the garbage collector for arsenal locations.
[ [arsenal_1,arsenal_2], 50 ] spawn cofd_fnc_garbageCollect;

//Delete all non-player controlled units.
{ if (isPlayer _x) then {} else {deleteVehicle _x}; } forEach units playersGroup;

//If enabled from the parameters, don't unassign drill officer curators.
private _zeusEnabled = "Zeus_Active" call BIS_fnc_getParamValue;
if (_zeusEnabled isEqualTo 0) then {
	unAssignCurator curator_1;
	deleteVehicle curator_1;
	deleteVehicle curator_1_obj;
	unAssignCurator curator_2;
	deleteVehicle curator_2;
	deleteVehicle curator_2_obj;
};