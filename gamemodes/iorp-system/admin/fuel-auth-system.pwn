new bool:FuelAuth:PlayerData[MAX_PLAYERS];
new bool:FuelAuth:PlayerDataAuto[MAX_PLAYERS];

stock FuelAuth:IsActive(playerid) {
    return FuelAuth:PlayerData[playerid];
}

stock FuelAuth:SetActive(playerid, bool:status) {
    FuelAuth:PlayerData[playerid] = status;
    return 1;
}

stock FuelAuth:IsAutoActive(playerid) {
    return FuelAuth:PlayerDataAuto[playerid];
}

stock FuelAuth:SetAutoActive(playerid, bool:status) {
    FuelAuth:PlayerDataAuto[playerid] = status;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    FuelAuth:PlayerData[playerid] = false;
    FuelAuth:PlayerDataAuto[playerid] = false;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys & KEY_SUBMISSION) && FuelAuth:IsActive(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) {
            SetVehicleFuelEx(GetPlayerVehicleID(playerid), 99);
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (!IsPlayerInAnyVehicle(playerid) || !FuelAuth:IsAutoActive(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (GetVehicleFuelEx(vehicleid) != 99) SetVehicleFuelEx(GetPlayerVehicleID(playerid), 99);
    return 1;
}