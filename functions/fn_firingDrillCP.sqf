/*
Author: ThomasAngel aka Rekter (76561198034573104)

Description:
Handles firing drill CP activation and deactivation.
TODO: This function is a mess, but it works.

Parameters:
	_this # 0: ARRAY - Array of targets in CP.

	_this # 1: NUMBER - Time to shoot targets.

	_this # 2: BOOLEAN - True for pistol CP, false for rifle CP.

	_this # 3: ARRAY - Array of bonus targets.


Usage: [[target_1a, target_1b], 2, true] call cofd_fnc_firingDrillCP;

Returns: True if CP cleared successfully, false if not.
*/

//Server only function.
if (!isServer) exitWith {};

private _targets = _this # 0;
private _time = _this # 1;
private _weapon = _this # 2;
private _bonus = _this # 3;

//Check that params are correct type.
if (typeName _targets != "ARRAY") exitWith { ["fn_firingDrillCP: Invalid parameter 0 - Supplied %1, expected ARRAY", typeName _targets] call BIS_fnc_error };
if (typeName _time != "SCALAR") exitWith { ["fn_firingDrillCP: Invalid parameter 1 - Supplied %1, expected SCALAR", typeName _time] call BIS_fnc_error };
if (typeName _weapon != "BOOL") exitWith { ["fn_firingDrillCP: Invalid parameter 2 - Supplied %1, expected BOOL", typeName _weapon] call BIS_fnc_error };
if (typeName _bonus != "ARRAY") exitWith { ["fn_firingDrillCP: Invalid parameter 3 - Supplied %1, expected ARRAY", typeName _bonus] call BIS_fnc_error };

//Make the targets pop up and add eventhandlers.
{
	_x animate ["terc",0];
	[_x, "FD_Target_PopUp_Large_F"] remoteExec ["say3D", 0, false];
	if (_weapon isEqualTo true) then {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo handgunWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "hit",true] }}];
	} else {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo primaryWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "hit",true] }}];
	};
} forEach _targets;

//Make the bonus targets pop up and add eventhandlers.
{
	_x animate ["terc",0];
	[_x, "FD_Target_PopUp_Large_F"] remoteExec ["say3D", 0, false];
	if (_weapon isEqualTo true) then {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo handgunWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "bonus",true] }}];
	} else {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo primaryWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "bonus",true] }}];
	};
} forEach _bonus;


//Time to shoot targets
sleep _time;

//The CP is clear, unless some target is down.
_clear = true;
{
	if (_x getVariable "targetStatus" isEqualTo "down") exitWith {_clear = false};
} forEach _targets;


if ( _clear isEqualTo false ) then {
//Not clear.
	"FD_CP_Not_Clear_F" remoteExec ["playSound", 0, false];

	//If wrong weapon is used, hint check weapon. Also this is a dumb way to do this but oh well.
	if (_weapon isEqualTo true) then {
		if (currentWeapon comp_1_player != handgunWeapon comp_1_player or currentWeapon comp_2_player != handgunWeapon comp_2_player) then {
			"Checkpoint not clear!\nCheck weapon!" remoteExec ["hintSilent", 0, false];
		} else {
			"Checkpoint not clear!" remoteExec ["hintSilent", 0, false];
		};
	} else {
		if (currentWeapon comp_1_player != primaryWeapon comp_1_player or currentWeapon comp_2_player != primaryWeapon comp_2_player) then {
			"Checkpoint not clear!\nCheck weapon!" remoteExec ["hintSilent", 0, false];
		} else {
			"Checkpoint not clear!" remoteExec ["hintSilent", 0, false];
		};
	};

	//Remove eventhandlers and reset targets with sound effect.
	{
		_x removeAllEventHandlers "Hit";
		_X animate ["terc",1];
		[_X, "FD_Target_PopDown_Large_F"] remoteExec ["say3D", 0, false];
	} forEach _targets;

	//From bonus targets as well.
	{
		_x removeAllEventHandlers "Hit";
		_x animate ["terc",1];
		[_x, "FD_Target_PopDown_Large_F"] remoteExec ["say3D", 0, false];
	} forEach _bonus;

	//Return false because the CP isn't clear.
	false;

	} else {
	//Clear.
	"FD_CP_Clear_F" remoteExec ["playSound", 0, false];
	"Checkpoint clear!" remoteExec ["hintSilent", 0, false];

	//Remove eventhandlers
	{
		_x removeAllEventHandlers "Hit";
	} forEach _targets;

	{
		_x removeAllEventHandlers "Hit";
		_x animate ["terc",1];
	} forEach _bonus;

	true;
};