/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Handles the firing drill.

Parameters:
	NONE.

Usage: [] spawn cofd_fnc_firingDrill;

Returns: Nothing.
*/

//Serverside script!
if (!isServer) exitWith {};

//If this function is already active, don't run it again!
if (drillscript_active) exitWith {};

//Define variables.
private _targets = [target_1a, target_1b, target_2a, target_2b, target_3a, target_3b, target_3a_1, target_3b_1, target_3c_1, target_3d_1, target_4a, target_4b, target_5a, target_5b, target_5c, target_5d, target_5e, target_6a, target_6b, target_6c, target_7a, target_7b, target_7c, target_7d, target_7e, target_7f, target_8a, target_8b, target_8c, target_8d, target_8e, target_9a, target_9b, target_9c, target_9d, target_9e, target_9f, target_9g, target_9h];
private _1stFloorBonus = [target_3c, bonus_1, bonus_2, bonus_3, bonus_4, bonus_5, bonus_6, bonus_7, bonus_8, bonus_9, bonus_10];
private _timer = 0;
private _bonus = []; //This array is for special bonus targets, e.g bonus targets that aren't human targets.

//Reset variables in case they were used before.
comp_1_ready = false;
	publicVariable "comp_1_ready";
comp_1_player = nil;
	//publicVariable "comp_1_player";

comp_2_ready = false;
	publicVariable "comp_2_ready";
comp_2_player = nil;
	//publicVariable "comp_2_player";

drillscript_active = true;
	publicVariable "drillscript_active";

//Reset targets.
{
	_x animateSource ["terc",1];
	_x setVariable ["targetStatus","down",true];
	_x removeAllEventHandlers "Hit";
} forEach _targets;

p1ready setObjectTextureGlobal [1, "images\notready_co.paa"];
p2ready setObjectTextureGlobal [1, "images\notready_co.paa"];

//Add the actions to the laptops so the players can start the drill.
[p1ready, ["Competitor 1 ready", { comp_1_ready = true; publicVariable "comp_1_ready"; comp_1_player = _this select 1; publicVariableServer "comp_1_player"; p1ready setObjectTextureGlobal [1, "images\ready_co.paa"] }, nil, 1.5, true, true, "", "!comp_1_ready", 5]] remoteExec ["addAction", 0, false];
[p1ready, ["Competitor 1 not ready", { comp_1_ready = false; publicVariable "comp_1_ready"; comp_1_player = nil; publicVariableServer "comp_1_player"; p1ready setObjectTextureGlobal [1, "images\notready_co.paa"] }, nil, 1.5, true, true, "", "comp_1_ready", 5]] remoteExec ["addAction", 0, false];

[p2ready, ["Competitor 2 ready", { comp_2_ready = true; publicVariable "comp_2_ready"; comp_2_player = _this select 1; publicVariableServer "comp_2_player"; p2ready setObjectTextureGlobal [1, "images\ready_co.paa"] }, nil, 1.5, true, true, "", "!comp_2_ready", 5]] remoteExec ["addAction", 0, false];
[p2ready, ["Competitor 2 not ready", { comp_2_ready = false; publicVariable "comp_2_ready"; comp_2_player = nil; publicVariableServer "comp_2_player"; p2ready setObjectTextureGlobal [1, "images\notready_co.paa"] }, nil, 1.5, true, true, "", "comp_2_ready", 5]] remoteExec ["addAction", 0, false];

//Wait until both players are ready.
waitUntil {comp_1_ready isEqualTo true && comp_2_ready isEqualTo true};

//TODO: Grab global variables and get them local to the server
//private _comp_1_player = comp_1_player;
//private _comp_2_player = comp_2_player;

p1ready remoteExec ["removeAllActions", 0, false];
p2ready remoteExec ["removeAllActions", 0, false];

"FD_Course_Active_F" remoteExec ["playSound", 0, false];
[parseText "<t size='1.5'>The drill is starting!</t>"] remoteExec ["hintSilent", 0, false];

sleep 3;
	"FD_Timer_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false];
	[parseText "<t size='1.5'>3</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
sleep 1;
	"FD_Timer_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false];
	[parseText "<t size='1.5'>2</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
sleep 1;
	"FD_Timer_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false];
	[parseText "<t size='1.5'>1</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
sleep 1;
//Check for false start.
if (comp_1_player distance [21964.3,21018.2,3.199] < 9 or comp_2_player distance [21964.3,21018.2,3.199] < 9) exitWith { "False start!" remoteExec ["hintSilent", [comp_1_player, comp_2_player], false]; "FD_CP_Not_Clear_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false] };
	"FD_Start_F" remoteExec ["playSound", [comp_1_player, comp_2_player], false];
	[parseText "<t size='1.5'>Go!</t>"] remoteExec ["hintSilent", [comp_1_player, comp_2_player], false];
//Start timer.
_timer = time;
missionNameSpace setVariable ["BIS_stopTimer", false];
[] remoteExec ["BIS_fnc_VRTimer", [comp_1_player, comp_2_player], false];

//First CP.
waitUntil {comp_1_player distance [21964.3,21018.2,3.199] < 2 or comp_2_player distance [21964.3,21018.2,3.199] < 2};
[ [target_1a, target_1b], 2, true, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Second CP.
waitUntil {comp_1_player distance [21955.1,21029.1,5.68234] < 2 or comp_2_player distance [21955.1,21029.1,5.68234] < 2};
[ [target_2a, target_2b], 2.2, true, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Third CP.
waitUntil {comp_1_player distance [21951.4,21023.7,5.5866] < 2 or comp_2_player distance [21951.4,21023.7,5.5866] < 2};
[ [target_3a, target_3b], 1.3, true, [target_3c] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Fourth CP.
waitUntil {comp_1_player distance [21947.4,21029.3,5.26434] < 2 or comp_2_player distance [21947.4,21029.3,5.26434] < 2};
[ [target_3a_1, target_3b_1, target_3c_1, target_3d_1], 2.5, true, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Fifth CP.
waitUntil {comp_1_player distance [21949.5,21039.2,2.59443] < 1.5 or comp_2_player distance [21949.5,21039.2,2.59443] < 1.5};
[ [target_4a, target_4b], 2, false, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Spawn the bonus target room now, before the players can see it.
_bonusTargets_1 = [bonus_1, bonus_2, bonus_3, bonus_4, bonus_5, bonus_6, bonus_7, bonus_8, bonus_9, bonus_10];
{
	_pos = getPosATL _x;
	_target = createVehicle ["EauDeCombat_01_F", _pos, [], 0, "CAN_COLLIDE"];
	_target enableSimulationGlobal false;
	_target setVectorUp [0,0,1];
	_target setDir (getDir _x);
	_bonus pushBack _target;
} forEach _bonusTargets_1;

//Sixth CP.
waitUntil {comp_1_player distance [21944.7,21034.9,3.23064] < 1.5 or comp_2_player distance [21944.7,21034.9,3.23064] < 1.5};
[ [target_5a, target_5b, target_5c, target_5d, target_5e], 4, false, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Seventh CP.
waitUntil {comp_1_player distance [21943.6,21050.2,0.62571] < 2 or comp_2_player distance [21943.6,21050.2,0.62571] < 2};
[ [target_6a, target_6b, target_6c], 3, true, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Eighth CP.
waitUntil {comp_1_player distance [21951.3,21043.2,6.122] < 2 or comp_2_player distance [21951.3,21043.2,6.122] < 2};
[ [target_7a, target_7b, target_7c, target_7d, target_7e, target_7f], 6, true, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Ninth CP.
waitUntil {comp_1_player distance [21949,21030.4,9.67916] < 2 or comp_2_player distance [21949,21030.4,9.67916] < 2};
[ [target_8a, target_8b, target_8c, target_8d, target_8e], 8, false, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Tenth CP.
waitUntil {comp_1_player distance [21959,21039.7,6.78909] < 1 or comp_2_player distance [21959,21039.7,6.78909] < 1};
[ [target_9a, target_9b, target_9c, target_9d, target_9e, target_9f, target_9g, target_9h], 15, false, [] ] remoteExec ["cofd_fnc_firingDrillCP", [comp_1_player, comp_2_player], false];

//Before the finish line, an epic final target to magdump into for bonus time!
private _suppGrp = createGroup east;
private _suppress_1 = _suppGrp createUnit ["O_Soldier_VR_F", [22004.1,21062.7,0], [], 0, "CAN_COLLIDE"];
_suppress_1 hideObjectGlobal true;
private _suppress_2 = _suppGrp createUnit ["O_Soldier_VR_F", [22005.9,21061,0], [], 0, "CAN_COLLIDE"];
_suppress_2 hideObjectGlobal true;

_suppress_1 disableAI "ALL";
_suppress_2 disableAI "ALL";
_suppress_1 setSkill 0;
_suppress_2 setSkill 0;
magDumpTime = 0;
_suppress_1 addEventHandler ["suppressed", { if (magDumpTime < 5) then { magDumpTime = magDumpTime + 0.2 } }];
_suppress_2 addEventHandler ["suppressed", { if (magDumpTime < 5) then { magDumpTime = magDumpTime + 0.2 } }];

//Finish
waitUntil {comp_1_player distance [21988.3,21044.3,0.719] < 4 or comp_2_player distance [21988.3,21044.3,0.719] < 4};
_suppress_1 removeAllEventHandlers "suppressed";
_suppress_2 removeAllEventHandlers "suppressed";
deleteVehicle _suppress_1;
deleteVehicle _suppress_2;
deleteGroup _suppGrp;

//Stop the UI timer.
missionNameSpace setVariable ["BIS_stopTimer", true];
missionNameSpace setVariable ["RscFiringDrillTime_done", true];

//Calculate missed and bonus times.
_missedTime = count (_targets select {_x getVariable "targetStatus" isEqualTo "down"});
_bonusTime = count (_1stFloorBonus select {_x getVariable "targetStatus" isEqualTo "bonus"});
_specialBonus = -10 + count _bonus;
_bonusTime = _specialBonus - _bonusTime - magDumpTime;

//Final calculation for the player's time.
_totalTime = time - _timer + _missedTime + _bonusTime;
[_totalTime, _missedTime, _bonusTime] remoteExec ["cofd_fnc_firingDrillEnd", [comp_1_player, comp_2_player], false];

drillScript_active = false;
	publicVariable "drillScript_active";

//Delete leftover bonus targets.
{ deleteVehicle _x; } forEach _bonus;

//TODO: implement a better solution to an issue than this.
sleep 1;

//Reset course.
[] spawn cofD_fnc_firingDrill;