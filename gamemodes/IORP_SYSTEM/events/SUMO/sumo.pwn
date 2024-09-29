#define SUMO_EVENT_ID 7
#define SUMO_VIRTUAL_WORLD 14
#include "IORP_SYSTEM/events/SUMO/locations.pwn"

new bool:SUMO_Started = false;
new Sumo:IsAlive[MAX_PLAYERS];
new SumoVehicles[MAX_VEHICLES + 100];

hook OnVehicleDeath(vehicleid, killerid) {
    if (SumoVehicles[vehicleid]) {
        if (IsValidVehicle(vehicleid)) DestroyVehicleEx(vehicleid);
        SumoVehicles[vehicleid] = 0;
    }
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    if (SumoVehicles[vehicleid]) {
        SumoVehicles[vehicleid] = 0;
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (newstate == PLAYER_STATE_ONFOOT) {
        if (SUMO_Started && Sumo:IsAlive[playerid]) {
            GameTextForPlayer(playerid, "~w~LOST ~r~SUMO", 5000, 3);
            Sumo:SpawnInLobby(playerid);
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    if (SumoVehicles[vehicleid]) {
        if (IsValidVehicle(vehicleid)) DestroyVehicleEx(vehicleid);
        SumoVehicles[vehicleid] = 0;
    }
    if (SUMO_Started && Sumo:IsAlive[playerid]) {
        GameTextForPlayer(playerid, "~w~LOST ~r~SUMO", 5000, 3);
        Sumo:SpawnInLobby(playerid);
    }
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != SUMO_EVENT_ID) return 1;
    GameTextForPlayer(playerid, "WELCOME TO ~r~SUMO", 5000, 3);
    Sumo:SpawnInLobby(playerid);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != SUMO_EVENT_ID) return 1;
    Sumo:IsAlive[playerid] = 0;
    return 1;
}

hook GlobalOneMinuteInterval() {
    if (!SUMO_Started) {
        if (Event:GetOnlinePlayerIn(SUMO_EVENT_ID) < 2) {
            Event:SendMessageToAll(SUMO_EVENT_ID, "Required minimum 2 players to start sumo");
            return 1;
        }
        Sumo:Start();
    } else {
        if (Sumo:TotalAlivePlayers() < 2) Sumo:End();
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (!SUMO_Started || !Sumo:IsAlive[playerid]) return 1;
    new Float:pLocs[3];
    GetPlayerPos(playerid, pLocs[0], pLocs[1], pLocs[2]);
    if (pLocs[2] < 32.0) {
        GameTextForPlayer(playerid, "~w~LOST ~r~SUMO", 5000, 3);
        Sumo:SpawnInLobby(playerid);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (!SUMO_Started || !Sumo:IsAlive[playerid]) return 1;
    GameTextForPlayer(playerid, "~w~LOST ~r~SUMO", 5000, 3);
    Sumo:SpawnInLobby(playerid, 8000);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    Sumo:IsAlive[playerid] = 0;
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (SumoVehicles[vehicleid]) {
            DestroyVehicleEx(vehicleid);
            SumoVehicles[vehicleid] = 0;
        }
    }
    return 1;
}

stock Sumo:TotalAlivePlayers() {
    new count = 0;
    foreach(new playerid: Player) {
        if (Sumo:IsAlive[playerid]) count++;
    }
    return count;
}

stock Sumo:Start() {
    SUMO_Started = true;
    foreach(new playerid:Player) {
        if (Event:GetID(playerid) == SUMO_EVENT_ID) {
            Sumo:SpawnInMap(playerid);
        }
    }
    return 1;
}

stock Sumo:End() {
    foreach(new playerid:Player) {
        if (Event:GetID(playerid) == SUMO_EVENT_ID) {
            if (Sumo:IsAlive[playerid]) {
                GameTextForPlayer(playerid, "YOU ARE~n~~g~SUMO WINNER", 5000, 3);
                Event:SendMessageToAll(SUMO_EVENT_ID, sprintf("%s wins sumo round", GetPlayerNameEx(playerid)));
                Sumo:SpawnInLobby(playerid);
            }
        }
    }
    SUMO_Started = false;
    return 1;
}

stock Sumo:SpawnInLobby(playerid, respawn = 3000) {
    Sumo:IsAlive[playerid] = 0;
    SetPlayerVirtualWorldEx(playerid, SUMO_VIRTUAL_WORLD);
    new rpos = RandomEx(0, MAX_SUMO_SPAWN_LOCS - 1);
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (SumoVehicles[vehicleid]) {
            RemovePlayerFromVehicle(playerid);
            DestroyVehicleEx(vehicleid);
            SumoVehicles[vehicleid] = 0;
        }
    }
    SetPreciseTimer("SetPlayerPosEx", respawn, false, "dfff", playerid, SUMO_SPAWN_LOCATIONS[rpos][SUMO_POSX], SUMO_SPAWN_LOCATIONS[rpos][SUMO_POSY], SUMO_SPAWN_LOCATIONS[rpos][SUMO_POSZ]);
    return 1;
}

stock Sumo:SpawnInMap(playerid) {
    new rPos = RandomEx(0, MAX_SUMO_VEH_SPAWN_LOCS - 1);
    SetPlayerPosEx(
        playerid, SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSX], SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSY],
        SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSZ] + 2.0
    );
    SetPreciseTimer("SumoGiveVeh", 5000, false, "dd", playerid, rPos);
    return 1;
}

forward SumoGiveVeh(playerid, rPos);
public SumoGiveVeh(playerid, rPos) {
    new rVeh = RandomEx(0, MAX_SUMO_VEHCLES - 1);
    new vehicleid = CreateVehicle(
        SUMO_VEHCLES[rVeh], SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSX], SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSY],
        SUMO_VEH_SPAWN_LOCATIONS[rPos][SUMO_POSZ] + 2.0, 0.0, -1, -1, 1800, 0, SUMO_VIRTUAL_WORLD, 0, true
    );
    SetVehicleHealthEx(vehicleid, 1000.0);
    SetVehicleFuelEx(vehicleid, 100.0);
    AddVehicleComponent(vehicleid, 1010);
    ResetVehicleEx(vehicleid);
    PutPlayerInVehicleEx(playerid, vehicleid, 0);
    SumoVehicles[vehicleid] = 1;
    GameTextForPlayer(playerid, "~r~GET ~g~STARTED", 5000, 3);
    Sumo:IsAlive[playerid] = 1;
    return 1;
}