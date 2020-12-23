//This script simply starts cofD_fnc_firingDrill.

if (!isServer) exitWith {};

drillHandle = [] spawn cofD_fnc_firingDrill;

[parseText "<t size='1.5'>The course is now open!</t>"] remoteExec ["hintSilent", [0,-2] select isDedicated, false];
"FD_Finish_F" remoteExec ["playSound", [0,-2] select isDedicated, false];