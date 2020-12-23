/*
Author: ThomasAngel aka Rekter (76561198034573104)

Description:
Spawns / despawns a target dummy that the player can use to -
benchmark weapon damage.

Parameters:
	_this select 0: NUMBER - A number between 0-3. 
	0 - Spawns unit with no gear.
	1 - Spawns unit with player gear.
	2 - Despawns unit.

	_this select 1: OBJECT - Player who called the function..

Usage: [2, player] spawn cofd_fnc_targetDummy;

Returns: Handle to dummy.
*/

//Server only
if (!isServer) exitWith {};

private _mode = _this select 0;
private _activator = _this select 1;

//Create unit (no gear).
if (_mode isEqualTo 0) then {

	private _unitCheck = [21654.9,20876,0] nearEntities ["Man", 1];
	if ( {side _x isEqualTo east} count _unitCheck > 0) exitWith {hint "A target is already present!"};

	private _dummyGrp = createGroup east;
	private _dummyUnit = _dummyGrp createUnit ["O_Soldier_VR_F", [21654.9,20876,0], [], 0, "CAN_COLLIDE"];
	hideObjectGlobal _dummyUnit;

	_dummyUnit disableAI "ALL";
	[_dummyUnit, ""] remoteExec ["switchMove", 0, false];
	_dummyUnit setSkill 0;
	_dummyUnit setDir 83.8;

	_dummyUnit addEventHandler ["Hit", {format ["Damage dealt: \n%1", parseNumber (_this select 2 toFixed 4) * 100] remoteExec ["Hint", _this select 3, false]; _this select 0 setDamage 0}];

	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", _activator, false];
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VREffectKilled", _activator, false];
	_dummyUnit;
};

//Create unit, copy player gear.
if (_mode isEqualTo 1) then {

	private _unitCheck = [21654.9,20876,0] nearEntities ["Man", 1];
	if ( {side _x isEqualTo east} count _unitCheck > 0) exitWith {hint "A target is already present!"};

	private _gear = getUnitLoadOut _activator;
	private _dummyGrp = createGroup east;
	private _dummyUnit = _dummyGrp createUnit ["O_Soldier_VR_F", [21654.9,20876,0], [], 0, "CAN_COLLIDE"];	
	hideObjectGlobal _dummyUnit;

	_dummyUnit disableAI "ALL";
	[_dummyUnit, ""] remoteExec ["switchMove", 0, false];
	_dummyUnit setSkill 0;
	_dummyUnit setDir 83.8;
	_dummyUnit setUnitLoadout _gear;
	removeAllWeapons _dummyUnit;
	removeUniform _dummyUnit;

	_dummyUnit addEventHandler ["Hit", {format ["Damage dealt: \n%1", parseNumber (_this select 2 toFixed 4) * 100] remoteExec ["Hint", _this select 3, false]; _this select 0 setDamage 0}];

	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", _activator, false];
	[ _dummyUnit, false, 2 ] remoteExec ["BIS_fnc_VREffectKilled", _activator, false];
	_dummyUnit;
};

//Delete unit.
if (_mode isEqualTo 2) then {

	private _deleteUnit = [21654.9,20876,0] nearEntities ["Man", 1];

	if ( {side _x isEqualTo east} count _deleteUnit < 1) exitWith {hint "There is no target to delete!"};

		private _deleteUnitNew = _deleteUnit select {side _x isEqualTo east}; 
		[ _deleteUnitNew select 0, true, 2 ] remoteExec ["BIS_fnc_VRSpawnEffect", _activator, false]; 
		sleep 1;
		deleteVehicle (_deleteUnitNew select 0);
};