/*

Server-side JIP initialization.
Basically broadcast variables to JIP players.

*/

private _didJIP = _this # 1;

//Only broadcast if JIP.
if (_didJIP) then {
publicVariable "reflexActive";
publicVariable "comp_1_ready";
publicVariable "comp_2_ready";
publicVariable "drillscript_active";
publicVariable "nopop";
};