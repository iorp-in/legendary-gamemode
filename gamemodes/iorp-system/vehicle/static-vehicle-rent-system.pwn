#define rent_fare 1 

enum Rent_Vehicle_Status_Enum {
    Rent_OnTime,
    Rent_PlayerID,
    bool:Rent_Status,
    bool:Rent_Exit,
    Rent_Exit_Time
}
new Rent_Vehicle_Status[MAX_VEHICLES][Rent_Vehicle_Status_Enum];
new Text3D:Rent_3DText[MAX_VEHICLES];

hook OnVehicleCreated(vehicleid) {
    SetTimerEx("InitStaticVehicleRent", 3000, false, "d", vehicleid);
    return 1;
}

forward InitStaticVehicleRent(vehicleid);
public InitStaticVehicleRent(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 1;
    if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) return 1;
    if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) return 1;
    if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) return 1;
    Rent_3DText[vehicleid] = CreateDynamic3DTextLabel("[{FFFFFF}Rentable Vehicle {DEF200}] \n{13EB3A} Available", 0xDEF200FF, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, vehicleid, 1, GetVehicleVirtualWorld(vehicleid), GetVehicleInterior(vehicleid), -1);
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    // if(StaticVehicle:GetID(vehicleid) == -1) return 1;
    if (IsValidDynamic3DTextLabel(Rent_3DText[vehicleid])) DestroyDynamic3DTextLabel(Rent_3DText[vehicleid]);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    DeductRent(vehicleid);
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if (ispassenger) return 1;
    if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) return 1;
    if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) return 1;
    if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) return 1;
    if (Rent_Vehicle_Status[vehicleid][Rent_Status]) {
        Rent_Vehicle_Status[vehicleid][Rent_Exit] = false;
        return 1;
    }
    if (!IsTimePassedForPlayer(playerid, "rentable warning", 5 * 60) || GetPlayerScore(playerid) > 10) return 1;
    if (GetVehicleFuelEx(vehicleid) < 2.0) SetVehicleFuelEx(vehicleid, 10.0);
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}start vehicle engine to {FF0000}rent ($100) {FFFFFF}and stop the engine to {FF0000}unrent {FFFFFF}it.");
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) return 1;
    if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) return 1;
    if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) return 1;
    if (!Rent_Vehicle_Status[vehicleid][Rent_Status]) return 1;
    Rent_Vehicle_Status[vehicleid][Rent_Exit] = true;
    Rent_Vehicle_Status[vehicleid][Rent_Exit_Time] = gettime();
    if (!IsTimePassedForPlayer(playerid, "unrent warning", 5 * 60) || GetPlayerScore(playerid) > 10) return 1;
    if (Rent_Vehicle_Status[vehicleid][Rent_PlayerID] == playerid) SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FF0000}unrent {FFFFFF}your rental vehicle, to avoid addition charges.");
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new vehicleid: Vehicle) {
        if (
            Rent_Vehicle_Status[vehicleid][Rent_Status] &&
            Rent_Vehicle_Status[vehicleid][Rent_Exit] &&
            (gettime() - Rent_Vehicle_Status[vehicleid][Rent_Exit_Time]) >= 3 * 60
        ) {
            VehicleEngineStop(vehicleid);
        }

    }
}

hook OnVehicleEngineStart(vehicleid) {
    if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) return 1;
    if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) return 1;
    if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) return 1;
    foreach(new playerid:Player) {
        if (GetPlayerVehicleID(playerid) == vehicleid && GetPlayerVehicleSeat(playerid) == 0) {
            Rent_Vehicle_Status[vehicleid][Rent_Status] = true;
            Rent_Vehicle_Status[vehicleid][Rent_OnTime] = gettime();
            Rent_Vehicle_Status[vehicleid][Rent_PlayerID] = playerid;
            Rent_Vehicle_Status[vehicleid][Rent_Exit] = false;
            new string[128];
            format(string, sizeof string, "[{FFFFFF}Rentable Vehicle {DEF200}] \n{13EB3A} is rented by\n{ffbf7f}%s", GetPlayerNameEx(playerid));
            UpdateDynamic3DTextLabelText(Rent_3DText[vehicleid], 0xDEF200FF, string);
        }
    }
    return 1;
}

hook OnVehicleEngineStop(vehicleid) {
    DeductRent(vehicleid);
    return 1;
}

stock DeductRent(vehicleid) {
    if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) return 1;
    if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) return 1;
    if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) return 1;
    if (IsPlayerConnected(Rent_Vehicle_Status[vehicleid][Rent_PlayerID])) {
        new rent_seconds = gettime() - Rent_Vehicle_Status[vehicleid][Rent_OnTime];
        new rentT = rent_seconds * rent_fare;
        if (rentT > 0 && rentT < 86400) {
            if (Event:IsInEvent(Rent_Vehicle_Status[vehicleid][Rent_PlayerID])) {
                SendClientMessage(Rent_Vehicle_Status[vehicleid][Rent_PlayerID], -1, "{4286f4}[Alexa]: {FFFFFF}you are not charged for vehicle rent because it's free in events.");
            } else {
                GivePlayerCash(Rent_Vehicle_Status[vehicleid][Rent_PlayerID], (-1) * rentT, sprintf("charged for %s vehicle rent", GetVehicleName(vehicleid)));
                vault:addcash(Vault_ID_Government, rentT, Vault_Transaction_Cash_To_Vault, sprintf("%s charged for vehicle rent", GetPlayerNameEx(Rent_Vehicle_Status[vehicleid][Rent_PlayerID])));
                SendClientMessageEx(Rent_Vehicle_Status[vehicleid][Rent_PlayerID], -1, sprintf("{4286f4}[Alexa]: {FFFFFF}you are charged {008000}-$%s {FFFFFF}for vehicle rent.", FormatCurrency(rentT)));
            }
        }
    }
    Rent_Vehicle_Status[vehicleid][Rent_Status] = false;
    Rent_Vehicle_Status[vehicleid][Rent_Exit] = false;
    Rent_Vehicle_Status[vehicleid][Rent_OnTime] = 0;
    Rent_Vehicle_Status[vehicleid][Rent_PlayerID] = -1;
    UpdateDynamic3DTextLabelText(Rent_3DText[vehicleid], 0xDEF200FF, "[{FFFFFF}Rentable Vehicle {DEF200}] \n{13EB3A} Available");
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    for (new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++) {
        if (!IsValidVehicle(vehicleid)) continue;
        if (StaticVehicle:GetID(vehicleid) == -1 || IsVehicleModelTrailer(vehicleid) || IsVehicleModelRC(vehicleid)) continue;
        if (StaticVehicle:GetFactionID(StaticVehicle:GetID(vehicleid)) > -1) continue;
        if (IsArrayContainNumber(Cycle_Vehicles, GetVehicleModel(vehicleid))) continue;
        if (Rent_Vehicle_Status[vehicleid][Rent_Status] && Rent_Vehicle_Status[vehicleid][Rent_PlayerID] == playerid) VehicleEngineStop(vehicleid);
    }
    return 1;
}