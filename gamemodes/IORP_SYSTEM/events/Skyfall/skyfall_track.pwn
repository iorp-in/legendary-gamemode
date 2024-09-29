#define SKYFALL_EVENT_ID 1
#define skyfall_track_virtualworld 11

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != SKYFALL_EVENT_ID) return 1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Event System]:{FFFFEE} type /alexa espawn vehicleid to spawn vehicle and + to repair and refuel vehicle.");
    SendClientMessageEx(playerid, -1, "{4286f4}[Event System]:{FFFFEE} type /alexa skyfall if you fall.");
    SetPlayerVirtualWorldEx(playerid, skyfall_track_virtualworld);
    SetPlayerInteriorEx(playerid, 0);
    SetPlayerPosEx(playerid, RandomEx(8000, 8010), RandomEx(-7133, -7123), 13691);
    SetPlayerTeleportKickStatus(playerid, false);
    SetPlayerSpeedHackKickStatus(playerid, false);
    SetPlayerAutoRepairAuth(playerid, true);
    FuelAuth:SetAutoActive(playerid, true);
    Event:SetVehicleAuth(playerid, true);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != SKYFALL_EVENT_ID) return 1;
    SetPlayerTeleportKickStatus(playerid, true);
    SetPlayerSpeedHackKickStatus(playerid, true);
    SetPlayerAutoRepairAuth(playerid, false);
    FuelAuth:SetAutoActive(playerid, false);
    Event:SetVehicleAuth(playerid, false);
    return 1;
}

stock skyfall_cmd(playerid) {
    if (Event:IsInEvent(playerid) && Event:GetID(playerid) == SKYFALL_EVENT_ID) {
        if (IsPlayerInAnyVehicle(playerid)) TeleportVehicleEx(GetPlayerVehicleID(playerid), RandomEx(8000, 8010), RandomEx(-7133, -7123), 13691, 0, skyfall_track_virtualworld, 0);
        else SetPlayerPosEx(playerid, RandomEx(8000, 8010), RandomEx(-7133, -7123), 13691);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Event System]:{FFFFEE}teleported back to skyfall hub.");
    }
    return 0;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp(cmd, "skyfall") || !Event:IsInEvent(playerid) || Event:GetID(playerid) != SKYFALL_EVENT_ID) return 1;
    skyfall_cmd(playerid);
    return ~1;
}