/*

Client-side initialization.

*/

//Preload arsenal configs.
//I don't think this currently works?
[ "Preload", true ] call BIS_fnc_arsenal;

//Set view distance to client settings.
setViewDistance -1;

//Fade in to hide potential lag spikes
[1, "BLACK", 2, 0] spawn BIS_fnc_fadeEffect;

isCamOn = false;
reflexActive = false;

//Add actions to the main PC.
controlPC addAction ["Open the course", { 'startDrill.sqf' remoteExec ['execVM', 2, false] }, nil, 1.5, true, true, "",  "player isEqualTo officer_1 || player isEqualTo officer_2"];
controlPC addAction ["Close the course", { [ [], cofD_fnc_terminateDrill] remoteExec ['spawn', 2, false] }, nil, 1.5, true, true, "",  "player isEqualTo officer_1 || player isEqualTo officer_2"];
controlPC addAction ["View helmetcams", { [] spawn cofD_fnc_PipCam; isCamOn = true }, nil, 1.5, true, true, "",  "!isCamOn"];
controlPC addAction ["Turn off helmetcam displays", { isCamOn = false }, nil, 1.5, true, true, "",  "isCamOn"];
controlPC addAction ["Reset personal best", { profileNameSpace setVariable ["personalBest", 0] }];
//reflexRange addAction ["Start", { [ [], cofD_fnc_reflexRange] remoteExec ["spawn", 2, false]; reflexActive = true; publicVariable "reflexActive" }, nil, 1.5, true, true, "", "reflexActive isEqualTo false" ];
//reflexRange addAction ["Stop", { reflexActive = false; publicVariable "reflexActive" }, nil, 1.5, true, true, "", "reflexActive isEqualTo true" ];

//Retrieve personal times.
personalBest = profileNameSpace getVariable ["personalBest", 0];