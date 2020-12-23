// Terminate the firing drill systems.
// Reset variables etc..

//Serverside script!
if (!isServer) exitWith {};
if (drillscript_active isEqualTo false) exitWith {};

terminate drillHandle;

private _1stFloorTargets = [target_1a, target_1b, target_2a, target_2b, target_3a, target_3b, target_3c, target_3a_1, target_3b_1, target_3c_1, target_3d_1, target_4a, target_4b, target_5a, target_5b, target_5c, target_5d];
nopop = false;


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
} forEach _1stFloorTargets;

p1ready remoteExec ["removeAllActions", 0, false];
p2ready remoteExec ["removeAllActions", 0, false];

parseText format ["<t size='1.5'>Cease fire! <br />The course has been stopped by %1!</t>", name officer_1] remoteExec ["hintSilent", [0,-2] select isDedicated, false];
"FD_Course_Active_F" remoteExec ["playSound", [0,-2] select isDedicated, false];