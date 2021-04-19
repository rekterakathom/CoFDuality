/*
Author: ThomasAngel
Steam: https://steamcommunity.com/id/Thomasangel/
Github: https://github.com/rekterakathom

Description:
Handles the PIP cameras.

Parameters:
	NONE.

Usage: [] spawn cofd_fnc_PiPcam;

Returns: Nothing.
*/

//Client only.
if (!hasInterface) exitWith {};

//_peopleList = [officer_1, officer_2, comp_1, comp_2, comp_3, comp_4, comp_5, comp_6, comp_7, comp_8] apply { [ [name _x] ] };
_peopleList = [];
{
	if (alive _x) then {
		_peopleList pushBack [ [name _x] ];
	};
} forEach units playersGroup;


//First display (this gets initialized second for some reason)
[
	[ _peopleList, 0, false ],
	"Select helmetcam to view for display 2 (left)",
	{
		if (_confirmed) then {

			[_index] spawn {
				_people = [ officer_1, officer_2, comp_1, comp_2, comp_3, comp_4, comp_5, comp_6, comp_7, comp_8];
				_index = _this # 0;
				_selected = _people # _index;

				_cam1 = "camera" camCreate (ASLToAGL eyePos _selected);
				waitUntil {
					_pos1 = ASLtoAGL eyePos _selected vectorAdd (eyeDirection _selected);
					_cam1 camSetPos _pos1;
					_cam1 camSetDir eyeDirection _selected;
					_cam1 cameraEffect ["internal", "back", "rendertarget0"];
					_cam1 camCommit 0;
					if (player distance controlPC > 20) then {isCamOn = false};
					!isCamOn;
				};
			_cam1 cameraEffect ["terminate","back"];
			camDestroy _cam1;
			};

	};
},
"",
""
] call CAU_UserInputMenus_fnc_listbox;

//Second display (this gets initialized first, don't ask me why)
[
	[ _peopleList, 0, false ],
	"Select helmetcam to view for display 1 (right)",
	{
		if (_confirmed) then {

			[_index] spawn {
				_people = [ officer_1, officer_2, comp_1, comp_2, comp_3, comp_4, comp_5, comp_6, comp_7, comp_8];
				_index = _this # 0;
				_selected = _people # _index;

				_cam1 = "camera" camCreate (ASLToAGL eyePos _selected);
				waitUntil {
					_pos1 = ASLtoAGL eyePos _selected vectorAdd (eyeDirection _selected);
					_cam1 camSetPos _pos1;
					_cam1 camSetDir eyeDirection _selected;
					_cam1 cameraEffect ["internal", "back", "rendertarget1"];
					_cam1 camCommit 0;
					if (player distance controlPC > 20) then {isCamOn = false};
					!isCamOn;
				};
			_cam1 cameraEffect ["terminate","back"];
			camDestroy _cam1;
			};

	};
},
"",
""
] call CAU_UserInputMenus_fnc_listbox;