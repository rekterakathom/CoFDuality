//Start the firing drill systems.
//TODO: Hashmaps! Arma 3 v 2.01 required!
//Instead of assigning variables to the targets, make a hashmap to represent targets?

//Serverside script!
if (!isServer) exitWith {};

//If this function is already active, don't run it again!
if (drillscript_active isEqualTo true) exitWith {};

//Define variables.
private _1stFloorTargets = [target_1a, target_1b, target_2a, target_2b, target_3a, target_3b, target_3a_1, target_3b_1, target_3c_1, target_3d_1, target_4a, target_4b, target_5a, target_5b, target_5c, target_5d];
private _1stFloorBonus = [target_3c, bonus_1, bonus_2, bonus_3, bonus_4, bonus_5, bonus_6, bonus_7, bonus_8, bonus_9, bonus_10];
private _timer = 0;
private _bonus = []; //This variable is for special bonus targets, e.g bonus targets that aren't human targets.
nopop = true;

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
	_x animate ["terc",1];
	_x setVariable ["targetStatus","down",true];
	_x removeAllEventHandlers "Hit";
} forEach _1stFloorTargets;

//Add the actions to the laptops so the players can start the drill.
[p1ready, ["Competitor 1 ready", { comp_1_ready = true; publicVariable "comp_1_ready"; comp_1_player = _this select 1; publicVariableServer "comp_1_player"}, nil, 1.5, true, true, "", "comp_1_ready isEqualTo false", 5]] remoteExec ["addAction", 0, false];
[p1ready, ["Competitor 1 not ready", { comp_1_ready = false; publicVariable "comp_1_ready"; comp_1_player = nil; publicVariableServer "comp_1_player"}, nil, 1.5, true, true, "", "comp_1_ready isEqualTo true", 5]] remoteExec ["addAction", 0, false];

[p2ready, ["Competitor 2 ready", { comp_2_ready = true; publicVariable "comp_2_ready"; comp_2_player = _this select 1; publicVariableServer "comp_2_player"}, nil, 1.5, true, true, "", "comp_2_ready isEqualTo false", 5]] remoteExec ["addAction", 0, false];
[p2ready, ["Competitor 2 not ready", { comp_2_ready = false; publicVariable "comp_2_ready"; comp_2_player = nil; publicVariableServer "comp_2_player"}, nil, 1.5, true, true, "", "comp_2_ready isEqualTo true", 5]] remoteExec ["addAction", 0, false];

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
	"FD_Timer_F" remoteExec ["playSound", 0, false];
	[parseText "<t size='1.5'>3</t>"] remoteExec ["hintSilent", 0, false];
sleep 1;
	"FD_Timer_F" remoteExec ["playSound", 0, false];
	[parseText "<t size='1.5'>2</t>"] remoteExec ["hintSilent", 0, false];
sleep 1;
	"FD_Timer_F" remoteExec ["playSound", 0, false];
	[parseText "<t size='1.5'>1</t>"] remoteExec ["hintSilent", 0, false];
sleep 1;
//Check for false start.
if (comp_1_player distance cp_1 < 9 or comp_2_player distance cp_1 < 9) exitWith { "False start!" remoteExec ["hintSilent", 0, false]; "FD_CP_Not_Clear_F" remoteExec ["playSound", 0, false] };
	"FD_Start_F" remoteExec ["playSound", 0, false];
	[parseText "<t size='1.5'>Go!</t>"] remoteExec ["hintSilent", 0, false];
//Start timer.
_timer = time;

//First CP.
waitUntil {comp_1_player distance cp_1 < 2 or comp_2_player distance cp_1 < 2};
[ [target_1a, target_1b], 2, true, [] ] call cofd_fnc_firingDrillCP;

//Second CP.
waitUntil {comp_1_player distance cp_2 < 2 or comp_2_player distance cp_2 < 2};
[ [target_2a, target_2b], 2.2, true, [] ] call cofd_fnc_firingDrillCP;

//Third CP.
waitUntil {comp_1_player distance cp_3 < 2 or comp_2_player distance cp_3 < 2};
[ [target_3a, target_3b], 1.3, true, [target_3c] ] call cofd_fnc_firingDrillCP;

//Fourth CP.
waitUntil {comp_1_player distance cp_4 < 2 or comp_2_player distance cp_4 < 2};
[ [target_3a_1, target_3b_1, target_3c_1, target_3d_1], 2.5, true, [] ] call cofd_fnc_firingDrillCP;

//Fifth CP.
waitUntil {comp_1_player distance cp_5 < 1.5 or comp_2_player distance cp_5 < 1.5};
[ [target_4a, target_4b], 1.2, false, [] ] call cofd_fnc_firingDrillCP;

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
waitUntil {comp_1_player distance cp_6 < 1.5 or comp_2_player distance cp_6 < 1.5};
[ [target_5a, target_5b, target_5c, target_5d, target_5e], 4, false, [] ] call cofd_fnc_firingDrillCP;

waitUntil {comp_1_player distance cp_7 < 1 or comp_2_player distance cp_7 < 1};

//Calculate missed and bonus times.
_missedTime = count (_1stFloorTargets select {_x getVariable "targetStatus" isEqualTo "down"});
_bonusTime = count (_1stFloorBonus select {_x getVariable "targetStatus" isEqualTo "bonus"});
_specialBonus = 0 - count (_bonus select {!alive _x});
_bonusTime = _specialBonus - _bonusTime;

//Format text for missed time.
_missedTotal = format ["<br />Penalty time: %1s", _missedTime];

//Format text for bonus time.
_bonusTotal = format ["<br />Bonus time: %1s", _bonusTime * -1];

//Final calculation for the player's time.
_totalTime = time - _timer - _missedTime + _bonusTime;

//Format texts for the final hint.
_title = "<t color='#FFFFFF' size='2' shadow='1' shadowColor='#000000' align='center'>Course Cleared!</t>";
_text = format ["<br /><t color='#FFFFFF' size='1.5' shadow='1' shadowColor='#000000' align='center'>Time: %1</t>", _totalTime];


//If one competitor then show only one name, else show two.
if (comp_1_player isEqualTo comp_2_player) then {
	_competitors = format ["<br />Competitor: %1", name comp_1_player];
	hint parseText (_title + _text + _competitors + _bonusTotal + _missedTotal);
} else {
	_competitors = format ["<br />Competitors: %1 & %2", name comp_1_player, name comp_2_player];
	hintSilent parseText (_title + _text + _competitors + _bonusTotal + _missedTotal);
};

"FD_Finish_F" remoteExec ["playSound", 0, false];

drillScript_active = false;
	publicVariable "drillScript_active";