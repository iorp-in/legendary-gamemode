new bool:Player_Can_Teleport[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Player_Can_Teleport[playerid] = false;
    return 1;
}

hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
    if (GetPlayerTPAuth(playerid)) {
        SetPlayerInteriorEx(playerid, 0);
        if (IsPlayerInAnyVehicle(playerid)) {
            SetVehiclePosEx(GetPlayerVehicleID(playerid), fX, fY, fZ), SetCameraBehindPlayer(playerid);
        } else SetPlayerPosFindZEx(playerid, fX, fY, fZ), SetCameraBehindPlayer(playerid);
    }
    return 1;
}

stock GetPlayerTPAuth(playerid) {
    return Player_Can_Teleport[playerid];
}

stock SetPlayerTPAuth(playerid, bool:status) {
    Player_Can_Teleport[playerid] = status;
    return 1;
}