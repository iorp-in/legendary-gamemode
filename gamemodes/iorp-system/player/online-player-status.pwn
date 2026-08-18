hook OnGameModeInit() {
    Database:AddColumn("playerdata", "isPlayerInServer", "boolean", "0");
    Database:AddColumn("playerdata", "LastPosition", "text", "0, 0, 0, 0, 0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "isPlayerInServer");
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "isPlayerInServer");
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    new Float:xXx, Float:yYy, Float:zZz;
    GetPlayerPos(playerid, Float:xXx, Float:yYy, Float:zZz);
    Database:UpdateString(
        sprintf("%f, %f, %f, %d, %d", Float:xXx, Float:yYy, Float:zZz, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid)),
        GetPlayerNameEx(playerid), "username", "LastPosition"
    );
    return 1;
}