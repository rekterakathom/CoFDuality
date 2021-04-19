/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Handles firing drill CP activation and deactivation.

Parameters:
	_this # 0: ARRAY - Array of targets in CP.

	_this # 1: NUMBER - Time to shoot targets.

	_this # 2: BOOLEAN - True for pistol CP, false for rifle CP.

	_this # 3: ARRAY - Array of bonus targets.

Usage: [ [target_1a, target_1b], 2, true, [] ] call cofd_fnc_firingDrillCP;

Returns: True if CP cleared successfully, false if not.
*/

//Client only function.
if (!hasInterface) exitWith {};

//Get params and if something is wrong pass an error.
if (!params[
	["_targets", [], [[]] ],
	["_time", 0, [0] ],
	["_weapon", true, [true] ],
	["_bonus", [], [[]] ]
]) exitWith { ["Invalid parameter."] call BIS_fnc_error };

//Make the targets pop up and add eventhandlers.
{
	_x animateSource ["terc",0];
	[_x, "FD_Target_PopUp_Large_F"] remoteExec ["say3D", 0, false];
	if (_weapon) then {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo handgunWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "hit",true] }}];
	} else {
		_x addEventHandler ["Hit", { if (currentWeapon (_this # 3) isEqualTo primaryWeapon (_this # 3)) then { _this # 0 setVariable ["targetStatus", "hit",true] }}];
	};
} forEach _targets;

//Make the bonus targets pop up and add eventhandlers.
{
	_x animateSource ["terc",0];
	[_x, "FD_Target_PopUp_Large_F"] remoteExec ["say3D", 0, false];
	if (_weapon) then {
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


if (!_clear) then {
//Not clear.
	"FD_CP_Not_Clear_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false];

	//If wrong weapon is used, hint check weapon. Also this is a dumb way to do this but oh well.
	if (_weapon) then {
		if (currentWeapon comp_1_player isNotEqualTo handgunWeapon comp_1_player or currentWeapon comp_2_player isNotEqualTo handgunWeapon comp_2_player) then {
			//[parseText "<t size='1.5'>Checkpoint not clear!<br/>Check weapon!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
			hintSilent parseText "<t size='1.5'>Checkpoint not clear!<br/>Check weapon!</t>";
		} else {
			//[parseText "<t size='1.5'>Checkpoint not clear!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
			hintSilent parseText "<t size='1.5'>Checkpoint not clear!</t>";
		};
	} else {
		if (currentWeapon comp_1_player isNotEqualTo primaryWeapon comp_1_player or currentWeapon comp_2_player isNotEqualTo primaryWeapon comp_2_player) then {
			//[parseText "<t size='1.5'>Checkpoint not clear!\nCheck weapon!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
			hintSilent parseText "<t size='1.5'>Checkpoint not clear!\nCheck weapon!</t>";
		} else {
			//[parseText "<t size='1.5'>Checkpoint not clear!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
			hintSilent parseText "<t size='1.5'>Checkpoint not clear!</t>";
		};
	};

	//Remove eventhandlers and reset targets with sound effect.
	{
		_x removeAllEventHandlers "Hit";
		_X animateSource ["terc",1];
		[_X, "FD_Target_PopDown_Large_F"] remoteExec ["say3D", 0, false];
	} forEach _targets;

	//From bonus targets as well.
	{
		_x removeAllEventHandlers "Hit";
		_x animateSource ["terc",1];
		[_x, "FD_Target_PopDown_Large_F"] remoteExec ["say3D", 0, false];
	} forEach _bonus;

	//Return false because the CP isn't clear.
	false;

} else {
	
	//Clear.
	"FD_CP_Clear_F" remoteExec ["playSound", 0, false];
	//[parseText "<t size='1.5'>Checkpoint clear!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
	hintSilent parseText "<t size='1.5'>Checkpoint clear!</t>";

	//Remove eventhandlers
	{
		_x removeAllEventHandlers "Hit";
	} forEach _targets;

	{
		_x removeAllEventHandlers "Hit";
		_x animateSource ["terc",1];
	} forEach _bonus;

	//Return true because the CP is clear.
	true;
};