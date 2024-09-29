new Float:AC_Position[MAX_PLAYERS][3];
new pLastPosTick[MAX_PLAYERS];
new p_ResetBitTimer[MAX_PLAYERS];
new p_ResetPosTimer[MAX_PLAYERS];
new BitArray:AC_SafeTP < MAX_PLAYERS > ;
new bool:Player_TeleportKickStatus[MAX_PLAYERS];
new Player_TeleportCount[MAX_PLAYERS];

stock IsPlayerFalling(playerid) //true if player is falling with a closed parachute
{
    new index = GetPlayerAnimationIndex(playerid);
    if (index >= 958 && index <= 979 || index == 1130 || index == 1195 || index == 1132) return 1;
    return 0;
}

hook OnPlayerSpawn(playerid) {
    GetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    GetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    GetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    if (gettime() - pLastPosTick[playerid] > 1 && GetPlayerTeleportKickStatus(playerid)) //updates the player location every 2 seconds.
    {
        pLastPosTick[playerid] = gettime() + 2;
        //on-foot
        if (!IsPlayerInRangeOfPoint(playerid, 50.0, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]) && !Bit_Get(AC_SafeTP, playerid) && !IsPlayerNPC(playerid) &&
            GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !IsPlayerFalling(playerid)) {
            new vID = GetPlayerNearestVehicle(playerid);
            new revVehicles[] = { 430, 446, 452, 453, 454, 472, 473, 484, 493, 595 };
            if (vID != -1 && IsArrayContainNumber(revVehicles, GetVehicleModel(vID), sizeof revVehicles)) {
                if (IsPlayerConnected(GetVehicleDriver(vID))) {
                    if (!IsPlayerInRangeOfPoint(playerid, 300.0, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]) && !Bit_Get(AC_SafeTP, playerid) && !IsPlayerNPC(playerid) &&
                        GetVehicleSpeed(GetPlayerVehicleID(GetVehicleDriver(vID))) <= 50 && IsPlayerInAnyVehicle(playerid)) return CallRemoteFunction("OnPlayerTeleport", "if", playerid, GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]));
                }
            } else return CallRemoteFunction("OnPlayerTeleport", "if", playerid, GetPlayerDistanceFromPoint(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]));
        }
        //on-vehicle
        else if (!IsPlayerInRangeOfPoint(playerid, 300.0, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]) && !Bit_Get(AC_SafeTP, playerid) && !IsPlayerNPC(playerid) &&
            GetVehicleSpeed(GetPlayerVehicleID(playerid)) <= 50 && IsPlayerInAnyVehicle(playerid)) return CallRemoteFunction("OnPlayerTeleport", "if", playerid, GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]));
        if (IsPlayerFreezed(playerid) && !Bit_Get(AC_SafeTP, playerid)) return 1;
        GetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    }
    return 1;
}

stock ActivateResetOriginalPos(playerid) {
    DeactivateResetOriginalPos(playerid);
    p_ResetPosTimer[playerid] = SetTimerEx("ResetOriginalPos", 1000, true, "d", playerid);
    return 1;
}

stock DeactivateResetOriginalPos(playerid) {
    KillTimer(p_ResetPosTimer[playerid]);
    p_ResetPosTimer[playerid] = -1;
    return 1;
}

forward ResetOriginalPos(playerid);
public ResetOriginalPos(playerid) {
    if (IsPlayerPaused(playerid)) return 1;
    if (!IsPlayerInAnyVehicle(playerid)) SetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    else SetVehiclePosEx(GetPlayerVehicleID(playerid), AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    if (IsPlayerInRangeOfPoint(playerid, 25.0, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2])) DeactivateResetOriginalPos(playerid);
    return 1;
}

hook OnSetPlayerPosEx(playerid, Float:PossX, Float:PossY, Float:PossZ, bool:freeze) {
    ResetTeleportBit(playerid, 10000);
    if (!IsPlayerFreezed(playerid) && !IsPlayerInRangeOfPoint(playerid, 100.0, PossX, PossY, PossZ)) freezeEx(playerid, 3000);
    return 1;
}

hook OnTeleportVehicleEx(vehicleid, x, y, z, angle, worldid, interiorid) {
    foreach(new i:Player) if (IsPlayerInVehicle(i, vehicleid)) ResetTeleportBit(i, 10000);
    return 1;
}

hook OnSetVehiclePosEx(vehicleid, Float:x, Float:y, Float:z) {
    foreach(new i:Player) if (IsPlayerInVehicle(i, vehicleid)) ResetTeleportBit(i, 10000);
    return 1;
}

stock ResetTeleportBit(playerid, time) {
    KillTimer(p_ResetBitTimer[playerid]);
    Bit_Set(AC_SafeTP, playerid, true);
    p_ResetBitTimer[playerid] = SetTimerEx("CallResetTeleportBit", time, false, "d", playerid);
    return 1;
}

forward CallResetTeleportBit(playerid);
public CallResetTeleportBit(playerid) {
    Bit_Set(AC_SafeTP, playerid, false);
    return 1;
}

hook OnPutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    ResetTeleportBit(playerid, 10000);
    GetPlayerPos(playerid, AC_Position[playerid][0], AC_Position[playerid][1], AC_Position[playerid][2]);
    return 1;
}


hook OnSetPlayerPosFindZEx(playerid, Float:PossX, Float:PossY, Float:PossZ) {
    ResetTeleportBit(playerid, 10000);
    freezeEx(playerid, 3000);
    return 1;
}


hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Player_TeleportKickStatus[playerid] = true;
    Player_TeleportCount[playerid] = 0;
    p_ResetPosTimer[playerid] = -1;
    p_ResetBitTimer[playerid] = -1;
    return 1;
}


hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    DeactivateResetOriginalPos(playerid);
    return 1;
}

forward GetPlayerTeleportKickStatus(playerid);
public GetPlayerTeleportKickStatus(playerid) {
    return Player_TeleportKickStatus[playerid];
}

forward SetPlayerTeleportKickStatus(playerid, bool:status);
public SetPlayerTeleportKickStatus(playerid, bool:status) {
    Player_TeleportKickStatus[playerid] = status;
    return 1;
}

forward OnPlayerTeleport(playerid, Float:distance);
public OnPlayerTeleport(playerid, Float:distance) {
    ActivateResetOriginalPos(playerid);
    GameTextForPlayer(playerid, "~r~Teleportation Hack ~w~Detected", 3000, 3);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE} you have done a unauthorized teleport, distance: %f", distance));
    if (Player_TeleportCount[playerid] >= 2) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}I have unbuged you in case you are stuck somewhere.");
        unbug(playerid, true);
        return 1;
    }
    if (Player_TeleportCount[playerid] >= 3) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}I have unbuged you, in case you are buged somewhere.");
        unbug(playerid, true);
        return 1;
    }
    if (Player_TeleportCount[playerid] >= 5) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}I think you, are hacking our server, so I can't allow you to play.");
        SendAdminLogMessage(sprintf("kicked: %s done a unauthorized teleport, distance: %f", GetPlayerNameEx(playerid), distance));
        KickPlayer(playerid, 2);
        return 1;
    }
    new freezetime;
    if (Player_TeleportCount[playerid] == 0) freezetime = 10 * 1000;
    else if (Player_TeleportCount[playerid] == 1) freezetime = 30 * 1000;
    else if (Player_TeleportCount[playerid] == 2) freezetime = 60 * 1000;
    else freezetime = 5 * 10 * 1000;
    freezeEx(playerid, freezetime);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}we have freezed you for %d seconds for security reasons, please avoid mods and hacks from being banned.", freezetime / 1000));
    SendAdminLogMessage(sprintf("%s done a unauthorized teleport, distance: %f", GetPlayerNameEx(playerid), distance), false);
    Player_TeleportCount[playerid]++;
    return 1;
}


hook OnPlayerUnfreezed(playerid) {
    Player_TeleportCount[playerid] = 0;
    return 1;
}