// TogglePlayerSpectating
forward TogglePlayerSpectatingEx(playerid, bool:toggle);
public TogglePlayerSpectatingEx(playerid, bool:toggle) {
    CallRemoteFunction("OnTogglePRSpectatingEx", "dd", playerid, toggle);
    return TogglePlayerSpectating(playerid, toggle);
}
forward OnTogglePRSpectatingEx(playerid, bool:toggle);
public OnTogglePRSpectatingEx(playerid, bool:toggle) {
    return 1;
}
// SetPlayerPos
forward SetPlayerPosEx(playerid, Float:x, Float:y, Float:z);
public SetPlayerPosEx(playerid, Float:x, Float:y, Float:z) {
    CallRemoteFunction("OnSetPlayerPosEx", "dfff", playerid, Float:x, Float:y, Float:z);
    return SetPlayerPos(playerid, Float:x, Float:y, Float:z);
}
forward OnSetPlayerPosEx(playerid, Float:x, Float:y, Float:z);
public OnSetPlayerPosEx(playerid, Float:x, Float:y, Float:z) {
    return 1;
}
// SetPlayerPosFindZ
forward SetPlayerPosFindZEx(playerid, Float:x, Float:y, Float:z);
public SetPlayerPosFindZEx(playerid, Float:x, Float:y, Float:z) {
    CallRemoteFunction("OnSetPlayerPosFindZEx", "dfff", playerid, Float:x, Float:y, Float:z);
    return SetPlayerPosFindZ(playerid, Float:x, Float:y, Float:z);
}
forward OnSetPlayerPosFindZEx(playerid, Float:x, Float:y, Float:z);
public OnSetPlayerPosFindZEx(playerid, Float:x, Float:y, Float:z) {
    return 1;
}
// PutPlayerInVehicle
forward PutPlayerInVehicleEx(playerid, vehicleid, seatid);
public PutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    CallRemoteFunction("OnPutPlayerInVehicleEx", "ddd", playerid, vehicleid, seatid);
    return PutPlayerInVehicle(playerid, vehicleid, seatid);
}
forward OnPutPlayerInVehicleEx(playerid, vehicleid, seatid);
public OnPutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    return 1;
}
// SetPlayerInterior
forward SetPlayerInteriorEx(playerid, interiorid);
public SetPlayerInteriorEx(playerid, interiorid) {
    CallRemoteFunction("OnSetPlayerInteriorEx", "dd", playerid, interiorid);
    return SetPlayerInterior(playerid, interiorid);
}
forward OnSetPlayerInteriorEx(playerid, interiorid);
public OnSetPlayerInteriorEx(playerid, interiorid) {
    return 1;
}
// SetPlayerVirtualWorld
forward SetPlayerVirtualWorldEx(playerid, worldid);
public SetPlayerVirtualWorldEx(playerid, worldid) {
    CallRemoteFunction("OnSetPlayerVWEx", "dd", playerid, worldid);
    return SetPlayerVirtualWorld(playerid, worldid);
}
forward OnSetPlayerVWEx(playerid, worldid);
public OnSetPlayerVWEx(playerid, worldid) {
    return 1;
}
// SetPlayerSkin
forward SetPlayerSkinEx(playerid, skinid);
public SetPlayerSkinEx(playerid, skinid) {
    CallRemoteFunction("OnSetPlayerSkin", "dd", playerid, skinid);
    return SetPlayerSkin(playerid, skinid);
}
forward OnSetPlayerSkin(playerid, skinid);
public OnSetPlayerSkin(playerid, skinid) {
    return 1;
}
// TeleportVehicle
stock TeleportVehicleEx(vehicleid, Float:x, Float:y, Float:z, Float:angle, worldid = -1, interiorid = -1) {
    CallRemoteFunction("OnTeleportVehicleEx", "ddffffdd", vehicleid, x, y, z, angle, worldid, interiorid);
    return TeleportVehicle(vehicleid, x, y, z, angle, worldid, interiorid);
}
forward OnTeleportVehicleEx(vehicleid, x, y, z, angle, worldid, interiorid);
public OnTeleportVehicleEx(vehicleid, x, y, z, angle, worldid, interiorid) {
    return 1;
}
// SetVehiclePosEx
stock SetVehiclePosEx(vehicleid, Float:x, Float:y, Float:z) {
    CallRemoteFunction("OnSetVehiclePosEx", "dfff", vehicleid, x, y, z);
    return SetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
}
forward OnSetVehiclePosEx(vehicleid, Float:x, Float:y, Float:z);
public OnSetVehiclePosEx(vehicleid, Float:x, Float:y, Float:z) {
    return 1;
}
// SendClientMessageEx
stock SendClientMessageEx(playerid, color, const message[]) {
    // printf("id: %d, cl: %d, msg: %s", playerid, color, message);
    return SendClientMessage(playerid, color, message);
}
// SendClientMessageEx
stock SendRangeMessageToAll(playerid, Float:range, color, const message[]) {
    new Float:rPosPl[3], intid = GetPlayerInteriorID(playerid), vwid = GetPlayerVirtualWorldID(playerid);
    GetPlayerPos(playerid, rPosPl[0], rPosPl[1], rPosPl[2]);
    foreach(new i:Player) {
        if (IsPlayerInRangeOfPoint(i, range, rPosPl[0], rPosPl[1], rPosPl[2]) && intid == GetPlayerInteriorID(i) && vwid == GetPlayerVirtualWorldID(i)) SendClientMessage(i, color, message);
    }
    return 1;
}
stock SendRPMessageToAll(playerid, Float:range, color, const message[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) return 0;
    new Float:rPosPl[3], intid = GetPlayerInteriorID(playerid), vwid = GetPlayerVirtualWorldID(playerid);
    GetPlayerPos(playerid, rPosPl[0], rPosPl[1], rPosPl[2]);
    foreach(new i:Player) {
        if (
            rpid == Roleplay:GetPlayerRpId(i) &&
            IsPlayerInRangeOfPoint(i, range, rPosPl[0], rPosPl[1], rPosPl[2]) &&
            intid == GetPlayerInteriorID(i) &&
            vwid == GetPlayerVirtualWorldID(i)
        ) SendClientMessage(i, color, message);
    }
    return 1;
}
// SetPlayerScore
stock SetPlayerScoreEx(playerid, score) {
    CallRemoteFunction("OnSetPlayerScoreEx", "dd", playerid, score);
    return SetPlayerScore(playerid, score);
}
forward OnSetPlayerScoreEx(playerid, score);
public OnSetPlayerScoreEx(playerid, score) {
    return 1;
}