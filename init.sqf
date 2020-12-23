
//Set some variables and broadcast values.
if (isServer) then {
	isCamOn = false;
		publicVariable "isCamOn";
	comp_1_ready = false;
		publicVariable "comp_1_ready";
	comp_2_ready = false;
		publicVariable "comp_2_ready";
	drillscript_active = false;
		publicVariable "drillscript_active";
};

//Add some actions to controlPC. Obsolete with drill officer supports?
controlPC addAction ["Toggle Cams", "[] spawn cofD_fnc_PipCam"];
/*
controlPC addAction ["Start the Drill", "startDrill.sqf", nil, 1.5, true, true, "", "drillScript_active isEqualTo false"];
controlPC_1 addAction ["Start the Drill", "startDrill.sqf", nil, 1.5, true, true, "", "drillScript_active isEqualTo false"];
controlPC addAction ["Stop the Drill", { [] remoteExec ["cofD_fnc_terminateDrill", 2, false] }, nil, 1.5, true, true, "", "drillScript_active isEqualTo true"];
*/

//Add ace3 arsenal if ace3 is present.
if ( isClass ( configfile >> "CfgPatches" >> "ace_arsenal" ) ) then {
[arsenal_1, true] call ace_arsenal_fnc_initBox;
[arsenal_2, true] call ace_arsenal_fnc_initBox;
};

//Drill officer supports
support_1 = [officer_1,"startDrill"] call BIS_fnc_addCommMenuItem;
support_2 = [officer_1,"stopDrill"] call BIS_fnc_addCommMenuItem;

//benchmark_target addEventHandler ["Hit", {hint format ["Damage dealt: \n%1", _this select 2]; benchmark_target setDamage 0}];