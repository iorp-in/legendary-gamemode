

new speed_hack_count[MAX_PLAYERS];
new Float:speed_hack_pos[MAX_PLAYERS][3];
new bool:Player_SpeedHackKickStatus[MAX_PLAYERS];
new Player_SpeedHackSafeReport[MAX_PLAYERS];

stock GetPlayerSpeedHackKickStatus(playerid) {
    return Player_SpeedHackKickStatus[playerid];
}

stock SetPlayerSpeedHackKickStatus(playerid, bool:status) {
    Player_SpeedHackKickStatus[playerid] = status;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    speed_hack_count[playerid] = 0;
    Player_SpeedHackKickStatus[playerid] = true;
    Player_SpeedHackSafeReport[playerid] = 0;
    return 1;
}

new Whitelisted_Vehicles[] = { 449, 537, 538 };

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    new Float:last_z = speed_hack_pos[playerid][2];
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    if (IsTimePassedForPlayer(playerid, "Anti Speed Hack Pos Update", 2)) {
        GetPlayerPos(playerid, speed_hack_pos[playerid][0], speed_hack_pos[playerid][1], speed_hack_pos[playerid][2]);
        Player_SpeedHackSafeReport[playerid] = 0;
    }
    if (Player_SpeedHackSafeReport[playerid] < 5) return Player_SpeedHackSafeReport[playerid]++;
    if (IsPlayerInAnyVehicle(playerid) && GetPlayerSpeedHackKickStatus(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        new modelid = GetVehicleModel(vehicleid);
        if (IsValidVehicle(vehicleid) && !IsArrayContainNumber(Whitelisted_Vehicles, modelid)) {
            //SendClientMessageEx(playerid, -1, sprintf("Current Speed: %f, Top Speed: %f", GetVehicleSpeed(vehicleid), GetVehicleTopSpeed(vehicleid) + 30));
            if (GetVehicleSpeed(vehicleid) > GetVehicleTopSpeed(vehicleid) + 30 && (z - last_z) > -1) {
                CallRemoteFunction("OnSpeedHackDetected", "d", playerid);
            }
        }
    }
    return 1;
}
forward OnSpeedHackDetected(playerid);
public OnSpeedHackDetected(playerid) {
    if (!IsTimePassedForPlayer(playerid, "Anti Speed Hack Warning", 1)) return 1;
    speed_hack_count[playerid]++;
    GameTextForPlayer(playerid, "~r~Speed Hack ~w~Detected", 3000, 3);
    if (speed_hack_count[playerid] == 1) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}we have detected speed hack, please slow down or will take action on you");
        freezeEx(playerid, 1000);
    }
    if (speed_hack_count[playerid] == 2) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}we have detected speed hack, please slow down or will take action on you");
        freezeEx(playerid, 10 * 1000);
    }
    if (speed_hack_count[playerid] >= 3) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}speed hack is not allowed, join again if you want understand our rules.");
        SendAdminLogMessage(sprintf("kicked %s for speed hack.", GetPlayerNameEx(playerid)));
        KickPlayer(playerid);
    }
    return 1;
}

hook OnPlayerUnfreezed(playerid) {
    speed_hack_count[playerid] = 0;
    return 1;
}