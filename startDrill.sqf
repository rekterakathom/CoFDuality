//This script simply starts cofD_fnc_firingDrill.
//I don't really know why I do it this way but don't question it.

if (!isServer) exitWith {};

if (drillScript_active) exitWith {"The course is already active!" remoteExec ["hint", _this # 1, false]};

drillHandle = [] spawn cofD_fnc_firingDrill;

[parseText "<t size='1.5'>The course is now open!</t>"] remoteExec ["hintSilent", [0,-2] select isDedicated, false];
"FD_Finish_F" remoteExec ["playSound", [0,-2] select isDedicated, false];