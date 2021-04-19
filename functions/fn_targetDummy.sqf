/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Spawns / despawns a target dummy that the player can use to -
benchmark weapon damage.

Parameters:
	_this # 0: NUMBER - A number between 0-3. 
	0 - Spawns unit with no gear.
	1 - Spawns unit with player gear.
	2 - Despawns unit.

	_this # 1: OBJECT - Player who called the function.

Usage: [2, player] spawn cofd_fnc_targetDummy;

Returns: Handle to dummy.
*/

if (!isServer) exitWith {};

private _mode = _this # 0;
private _activator = _this # 1;

//Create unit (no gear).
if (_mode isEqualTo 0) then {

	private _unitCheck = [21639.6,20852.8,2.82839] nearEntities ["Man", 1];
	if ( {side _x isNotEqualTo west} count _unitCheck > 0) exitWith {hint "A target is already present!"};

	private _dummyGrp = createGroup east;
	_dummyGrp deleteGroupWhenEmpty true;
	private _dummyUnit = _dummyGrp createUnit ["O_Soldier_VR_F", [21639.6,20852.8,2.82839], [], 0, "CAN_COLLIDE"];
	hideObjectGlobal _dummyUnit;

	_dummyUnit disableAI "ALL";
	[_dummyUnit, ""] remoteExec ["switchMove", 0, false];
	_dummyUnit setSkill 0;
	_dummyUnit setDir 89.46;

	//Check if ace3 is enabled because the ace3 system doesn't work in vanilla and vice versa.
	if ( isClass ( configfile >> "CfgPatches" >> "ace_medical" ) ) then {
		_dummyUnit addEventHandler ["HandleDamage", {
		_str = format ["Damage dealt: \n%1", (((_this # 2) * 100) toFixed 2)];
		[_str] remoteExec ["hintSilent", _this # 3, false]}];
	} else {
		_dummyUnit addEventHandler ["hit", {
		_str = format ["Damage dealt: \n%1", parseNumber (((_this # 2) * 100) toFixed 2)];
		[_str] remoteExec ["hintSilent", _this # 3, false];
		}];
	};

	//The killed effect will not apply on the server because it is a waste of frames because it adds an EH.
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", 0, false];
	[ _dummyUnit, 30 ] remoteExec ["BIS_fnc_VRHitpart", 0, false];
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VREffectKilled", -2, false];
	_dummyUnit;
};

//Create unit, copy player gear.
if (_mode isEqualTo 1) then {

	private _unitCheck = [21639.6,20852.8,2.82839] nearEntities ["Man", 1];
	if ( {side _x isNotEqualTo west} count _unitCheck > 0) exitWith {hint "A target is already present!"};

	private _gear = getUnitLoadOut _activator;
	private _dummyGrp = createGroup east;
	_dummyGrp deleteGroupWhenEmpty true;
	private _dummyUnit = _dummyGrp createUnit ["O_Soldier_VR_F", [21639.6,20852.8,2.82839], [], 0, "CAN_COLLIDE"];	
	hideObjectGlobal _dummyUnit;

	_dummyUnit disableAI "ALL";
	[_dummyUnit, ""] remoteExec ["switchMove", 0, false];
	_dummyUnit setSkill 0;
	_dummyUnit setDir 89.46;
	_dummyUnit setUnitLoadout _gear;
	removeAllWeapons _dummyUnit;
	removeUniform _dummyUnit;

	//Check if ace3 is enabled because the ace3 system doesn't work in vanilla and vice versa.
	if ( isClass ( configfile >> "CfgPatches" >> "ace_medical" ) ) then {
		_dummyUnit addEventHandler ["HandleDamage", {
		_str = format ["Damage dealt: \n%1", (((_this # 2) * 100) toFixed 2)];
		[_str] remoteExec ["hintSilent", _this # 3, false]}];
	} else {
		_dummyUnit addEventHandler ["hit", {
		_str = format ["Damage dealt: \n%1", parseNumber (((_this # 2) * 100) toFixed 2)];
		[_str] remoteExec ["hintSilent", _this # 3, false];
		}];
	};

	//The killed effect will not apply on the server because it is a waste of frames because it adds an EH.
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", 0, false];
	[ _dummyUnit, 30 ] remoteExec ["BIS_fnc_VRHitpart", 0, false];
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VREffectKilled", -2, false];
	_dummyUnit;
};

//Delete unit.
if (_mode isEqualTo 2) then {

	private _deleteUnit = [21639.6,20852.8,2.82839] nearEntities ["Man", 1];

	if ( {side _x isNotEqualTo west} count _deleteUnit < 1) exitWith {hint "There is no target to delete!"};

		private _deleteUnitNew = _deleteUnit select {side _x isNotEqualTo west}; 
		[ _deleteUnitNew select 0, true, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", 0, false]; 
		sleep 1;
		deleteVehicle (_deleteUnitNew select 0);
};