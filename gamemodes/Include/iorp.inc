stock SetPlayerPosEx(playerid, Float:x,Float:y,Float:z) { return CallRemoteFunction("SetPlayerPosEx", "dfff", playerid, Float:x,Float:y,Float:z); }
stock GetPlayerNameEx(playerid) { return CallRemoteFunction("GetPlayerNameEx", "d", playerid); }
stock GetPlayerAdminLevel(playerid)	{ return CallRemoteFunction("GetPlayerAdminLevel", "d", playerid); }