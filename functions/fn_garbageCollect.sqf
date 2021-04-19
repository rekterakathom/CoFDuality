/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Collects all the garbage that 3den doesn't.

Parameters:
	_this # 0: ARRAY - Array of positions to keep clean.
	_this # 1: NUMBER - Radius of each position.

Usage: [ [arsenal_1,arsenal_2], 50 ] spawn cofd_fnc_garbageCollect;

Returns: Nothing.
*/

if (!isServer) exitWith {};

private _array = _this # 0;
private _radius = _this # 1;

if (typeName _array isNotEqualTo "ARRAY") exitWith { ["fn_garbageCollect: Invalid parameter 0 - Supplied %1, expected ARRAY", typeName _array] call BIS_fnc_error };
if (typeName _radius isNotEqualTo "SCALAR") exitWith { ["fn_garbageCollect: Invalid parameter 1 - Supplied %1, expected SCALAR", typeName _radius] call BIS_fnc_error };

waitUntil {
	{
		private _list = nearestObjects [_x,["WeaponHolder"], _radius];
		{ clearWeaponCargo _x; clearMagazineCargo _x; clearItemCargo _x } forEach _list;
	} forEach _array;
	uiSleep (5*60);
	false;
};