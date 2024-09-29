new ReWardSpawned[MAX_VEHICLES];

hook OnGameModeInit() {
    for (new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++) ReWardSpawned[vehicleid] = -1;
    return 1;
}

hook OnPlayerLogin(playerid) {
    SetTimerEx("init_reward", 15 * 1000, false, "d", playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    for (new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++) {
        if (ReWardSpawned[vehicleid] == playerid) {
            ReWardSpawned[vehicleid] = -1;
            if (IsValidVehicle(vehicleid)) {
                foreach(new pl:Player) {
                    if (GetPlayerVehicleID(pl) == vehicleid) RemovePlayerFromVehicle(pl);
                }
                SetTimerEx("DestroyVehicleEx", 5 * 1000, false, "d", vehicleid);
            }
        }
    }
    return 1;
}

forward init_reward(playerid);
public init_reward(playerid) {
    if (GetPlayerScore(playerid) > 10) return 1;
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFCC66} You are our valuable player to us, please enjoy your reward :)");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFF55} Your reward list ...");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}spawn vehicle /rewardveh");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Vehicle Repair /rewardrepair");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Health and Armour /rewardpower");
    return 1;
}

cmd:rewardveh(playerid, const text[]) {
    if (GetPlayerScore(playerid) > 10) return 0;
    if (IsPlayerInHeist(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist");
    if (IsPlayerFreezed(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while you are freezed");
    // if (GetPlayerRPMode(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while fight mode enabled");
    new Vehicle[32], VehicleID, ColorOne, ColorTwo, string[512];
    sscanf(text, "s[32] D(1) D(1)", Vehicle, ColorOne, ColorTwo);
    if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
    else {
        new vcount = 0, ovtl[5];
        for (new d = 0; d < 212; d++) {
            if (strfind(GetVehicleModelName(d + 400), Vehicle, true) != -1 || strval(Vehicle) == d + 400) {
                VehicleID = d + 400;
                if (vcount < 5) ovtl[vcount] = VehicleID;

                else return GameTextForPlayer(playerid, "~w~More than ~r~5 ~r~vehicle", 1000, 3);
                vcount++;
            }
        }
        if (vcount > 1) {
            for (new e = 0; e < vcount; e++) {
                if (e == 0) SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}we got many vehicles with this name, here's the list..");
                format(string, 64, " %s [Model - %d]", GetVehicleModelName(ovtl[e]), ovtl[e]);
                SendClientMessageEx(playerid, -1, string);
            }
            return ~1;
        }
    }
    if (VehicleID < 400 || VehicleID > 611) return GameTextForPlayer(playerid, "~w~Invalid Vehicle Name", 1000, 3);
    if (!IsArrayContainNumber(LightMotor_Vehicles, VehicleID)) {
        GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3);
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can only spawn cars, if you don't know any name then try vehicleid 400");
        return 1;
    }
    if (VehicleID == 611) return GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3);
    if (!IsTimePassedForPlayer(playerid, "rewardveh", 5 * 60)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Command can only be used in every 5 minutes.");
    new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
    GetPlayerPos(playerid, pX, pY, pZ);
    GetPlayerFacingAngle(playerid, pAngle);
    GetXYInFrontOfPlayer(playerid, pX, pY, 3);
    vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), true);
    ResetVehicleEx(vehicleid);
    ReWardSpawned[vehicleid] = playerid;
    if (!IsPlayerInAnyVehicle(playerid)) PutPlayerInVehicleEx(playerid, vehicleid, 0);
    format(string, sizeof string, "{4286f4}[Alexa]: {FFFFFF}reward vehicle spawned:%s", GetVehicleModelName(VehicleID), GetPlayerNameEx(playerid));
    SendClientMessageEx(playerid, COLOR_GREY, string);
    GameTextForPlayer(playerid, "~w~vehicle spawned", 1000, 3);
    return 1;
}

cmd:rewardrepair(playerid, const text[]) {
    if (GetPlayerScore(playerid) > 10) return 0;
    if (IsPlayerInHeist(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist");
    if (IsPlayerFreezed(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while you are freezed");
    // if (GetPlayerRPMode(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while fight mode enabled");
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Command can only be used in vehicle.");
    if (GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Command can only be used as driver.");
    if (!IsTimePassedForPlayer(playerid, "rewardrepair", 5 * 60)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Command can only be used in every 5 minutes.");
    new vehicleid = GetPlayerVehicleID(playerid);
    if (Float:GetVehicleFuelEx(vehicleid) < 10.0) {
        SetVehicleFuelEx(vehicleid, 10.0);
    }
    ResetVehicleEx(vehicleid);
    return 1;
}

cmd:rewardpower(playerid, const text[]) {
    if (GetPlayerScore(playerid) > 10) return 0;
    if (IsPlayerInHeist(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist");
    if (IsPlayerFreezed(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while you are freezed");
    // if (GetPlayerRPMode(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while fight mode enabled");
    if (!IsTimePassedForPlayer(playerid, "rewardpower", 5 * 60)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Command can only be used in every 5 minutes.");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Reward Power Generated.");
    SetPlayerHealthEx(playerid, 100.0);
    SetPlayerArmourEx(playerid, 100.0);
    return 1;
}