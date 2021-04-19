
if (!hasInterface) exitWith {};

private _totalTime = _this # 0;
private _missedTime = _this # 1;
private _bonusTime = _this # 2;

if (typeName _totalTime isNotEqualTo "SCALAR") exitWith { ["fn_firingDrillEnd: Invalid parameter 0 - Supplied %1, expected SCALAR", typeName _totalTime] call BIS_fnc_error };
if (typeName _missedTime isNotEqualTo "SCALAR") exitWith { ["fn_firingDrillEnd: Invalid parameter 1 - Supplied %1, expected SCALAR", typeName _missedTime] call BIS_fnc_error };
if (typeName _bonusTime isNotEqualTo "SCALAR") exitWith { ["fn_firingDrillEnd: Invalid parameter 2 - Supplied %1, expected SCALAR", typeName _bonusTime] call BIS_fnc_error };

private _previousTime = profileNameSpace getVariable ["personalBest", 0];

//Format texts for the final hint.
_title = "<t color='#FFFFFF' size='2' shadow='1' shadowColor='#000000' align='center'>Course Cleared!</t>";

_text = "";

if (_previousTime isEqualTo 0) then {
	profileNamespace setVariable ["personalBest", _totalTime];
	saveProfileNamespace;
	_text = format ["<br /><t color='#FFFFFF' size='1.5' shadow='1' shadowColor='#000000' align='center'>Time: %1<br />New Personal Best!</t>", _totalTime];
} else {
	if ( _totalTime < (profileNameSpace getVariable "personalBest") ) then {
		profileNamespace setVariable ["personalBest", _totalTime];
		saveProfileNamespace;
		_text = format ["<br /><t color='#FFFFFF' size='1.5' shadow='1' shadowColor='#000000' align='center'>Time: %1<br />New Personal Best!</t>", _totalTime];
	} else {
		_text = format ["<br /><t color='#FFFFFF' size='1.5' shadow='1' shadowColor='#000000' align='center'>Time: %1<br />Personal Best: %2</t>", _totalTime, _previousTime];
	};
};


_competitors = "";

//If one competitor then show only one name, else show two.
if (comp_1_player isEqualTo comp_2_player) then {
	_competitors = format ["<br />Competitor: %1", name comp_1_player];
} else {
	_competitors = format ["<br />Competitors: %1 and %2", name comp_1_player, name comp_2_player];
};

//Bonus and missed times.
_bonusTotal = format ["<br />Bonus time: %1s", _bonusTime * -1];
_missedTotal = format ["<br />Penalty time: %1s", _missedTime];

//Hint competitor name(s) and the time to the whole server!
_text = parseText (_title + _text + _competitors + _bonusTotal + _missedTotal);
hintSilent _text;
playSound "FD_Finish_F";