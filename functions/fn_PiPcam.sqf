if (isDedicated) exitWith {};

if (isCamOn isEqualTo true) then {
	isCamOn = false;
	publicVariable "isCamOn";
	} else {
	isCamOn = true;
	publicVariable "isCamOn";
	};

[] spawn {
	_cam1 = "camera" camCreate (ASLToAGL eyePos comp_1);
	waitUntil {
		_pos1 = ASLToAGL eyePos comp_1;
		_dir1 = comp_1 modelToWorld [0,0,0];
		_dir2 = comp_1 modelToWorld [0,10,0];
		_cam1 camSetPos _pos1;
		_cam1 camSetDir (_dir1 vectorFromTo _dir2);
		_cam1 cameraEffect ["internal", "back", "rendertarget0"];
		_cam1 camCommit 0;
		isCamOn isEqualTo false;
	};
	publicVariable "isCamOn";
	_cam1 cameraEffect ["terminate","back"];
	camDestroy _cam1;
};

[] spawn {
	_cam2 = "camera" camCreate (ASLToAGL eyePos comp_2);
	waitUntil {
		_pos2 = ASLToAGL eyePos comp_2;
		_dir3 = comp_2 modelToWorld [0,0,0];
		_dir4 = comp_2 modelToWorld [0,10,0];
		_cam2 camSetPos _pos2;
		_cam2 camSetDir (_dir3 vectorFromTo _dir4);
		_cam2 cameraEffect ["internal", "back", "rendertarget1"];
		_cam2 camCommit 0;
		isCamOn isEqualTo false;
	};
	publicVariable "isCamOn";
	_cam2 cameraEffect ["terminate","back"];
	camDestroy _cam2;
};