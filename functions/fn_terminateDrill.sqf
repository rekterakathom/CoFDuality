/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Terminates the drill and resets everything.

Parameters:
	NONE.

Usage: [] spawn cofd_fnc_terminateDrill;

Returns: Nothing.
*/

//Serverside script!
if (!isServer) exitWith {};
if (drillscript_active isEqualTo false) exitWith {};

terminate drillHandle;

private _targets = [target_1a, target_1b, target_2a, target_2b, target_3a, target_3b, target_3a_1, target_3b_1, target_3c_1, target_3d_1, target_4a, target_4b, target_5a, target_5b, target_5c, target_5d, target_5e, target_6a, target_6b, target_6c, target_7a, target_7b, target_7c, target_7d, target_7e, target_7f, target_8a, target_8b, target_8c, target_8d, target_8e, target_9a, target_9b, target_9c, target_9d, target_9e, target_9f, target_9g, target_9h];


drillScript_active = false;
	publicVariable "drillScript_active";

comp_1_ready = false;
	publicVariable "comp_1_ready";
comp_1_player = nil;

comp_2_ready = false;
	publicVariable "comp_2_ready";
comp_2_player = nil;

{
	_x animate ["terc",0];
	_x setVariable ["targetStatus","down",true];
	_x removeAllEventHandlers "Hit";
} forEach _targets;

p1ready remoteExec ["removeAllActions", 0, false];
p2ready remoteExec ["removeAllActions", 0, false];

p1ready setObjectTextureGlobal [1, "images\notopen_co.paa"];
p2ready setObjectTextureGlobal [1, "images\notopen_co.paa"];

parseText format ["<t size='1.5'>Cease fire! <br />The course has been stopped by %1!</t>", name officer_1] remoteExec ["hintSilent", [0,-2] select isDedicated, false];
"FD_Course_Active_F" remoteExec ["playSound", [0,-2] select isDedicated, false];