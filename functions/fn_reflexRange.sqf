/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Handles the reflex range stuff.

Parameters:
	NONE.

Usage: [] spawn cofd_fnc_reflexRange;

Returns: Nothing.
*/

if (!isServer) exitWith {};

private _activator = _this # 1;

//Array of all the targets.
private _targets = [
	reflex_1, 
	reflex_2,
	reflex_3,
	reflex_4,
	reflex_5,
	reflex_6,
	reflex_7,
	reflex_8,
	reflex_9,
	reflex_10,
	reflex_11,
	reflex_12,
	reflex_13,
	reflex_14,
	reflex_15,
	reflex_16,
	reflex_17,
	reflex_18
	];

//Set targets down.
{ _x animateSource ["terc",1]; } forEach _targets;


//Loop
waitUntil {

	//Variables & event handler for time hint.
	private _target = selectRandom _targets;
	private _time = time;
	private _EH = _target addEventHandler ["Hit", { [format "Time: %1", time - _time] remoteExec ["hintSilent", false] } ];

	//Target pop up & sound.
	_target animateSource ["terc",0];
	[_target, "FD_Target_PopUp_Large_F"] remoteExec ["say3D", 0, false];

	//How long the target is up for.
	sleep 2;

	//Remove event handler, target pop down & sound.
	_target removeEventHandler ["Hit", _EH];
	_target animateSource ["terc",1];
	[_target, "FD_Target_PopDown_Large_F"] remoteExec ["say3D", 0, false];

	//Exit condition
	!reflexActive;
	};

//Set targets up.
{ _x animateSource ["terc",0]; } forEach _targets;

//Remove all event handlers in case there are some.
{ _x removeAllEventHandlers "Hit" } forEach _targets;