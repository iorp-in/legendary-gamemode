new bool:Player_RepairAuth[MAX_PLAYERS];
new bool:Player_AutoRepairAuth[MAX_PLAYERS];

stock GetPlayerRepairAuth(playerid) {
    return Player_RepairAuth[playerid];
}

stock SetPlayerRepairAuth(playerid, bool:status) {
    Player_RepairAuth[playerid] = status;
    return 1;
}

stock GetPlayerAutoRepairAuth(playerid) {
    return Player_AutoRepairAuth[playerid];
}

stock SetPlayerAutoRepairAuth(playerid, bool:status) {
    Player_AutoRepairAuth[playerid] = status;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Player_RepairAuth[playerid] = false;
    Player_AutoRepairAuth[playerid] = false;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys & KEY_SUBMISSION) && GetPlayerRepairAuth(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) {
            ResetVehicleEx(GetPlayerVehicleID(playerid));
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (!IsPlayerInAnyVehicle(playerid) || !GetPlayerAutoRepairAuth(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (GetVehicleHealthEx(vehicleid) != 1000) SetVehicleHealthEx(vehicleid, 1000), RepairVehicle(vehicleid);
    return 1;
}