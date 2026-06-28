new Data_Ghost_Rider[MAX_PLAYERS + 1][3];

hook OnGameModeExit() {
    for (new i = 0; i < MAX_PLAYERS + 1; i++) {
        if (Data_Ghost_Rider[i][0]) {
            DestroyObject(Data_Ghost_Rider[i][0]);
            DestroyObject(Data_Ghost_Rider[i][1]);
            DestroyObject(Data_Ghost_Rider[i][2]);
            Data_Ghost_Rider[i][0] = 0;
        }
    }
    return 1;
}

stock EnableGhostRider(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF0000AA, "{4286f4}[Alexa]: {FFFFEE}You have to be in a 'freeway' motorbike!");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, 0xFF0000AA, "{4286f4}[Alexa]: {FFFFEE}You must be the driver!");
    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 463) return SendClientMessage(playerid, 0xFF0000AA, "{4286f4}[Alexa]: {FFFFEE}You have to be in a 'freeway' motorbike!");
    if (Data_Ghost_Rider[playerid][0]) {
        DestroyObject(Data_Ghost_Rider[playerid][0]);
        DestroyObject(Data_Ghost_Rider[playerid][1]);
        DestroyObject(Data_Ghost_Rider[playerid][2]);
        Data_Ghost_Rider[playerid][0] = 0;
        return 1;
    }
    new Float:vh;
    GetVehicleHealth(GetPlayerVehicleID(playerid), vh);
    if (vh < 250) return SendClientMessage(playerid, 0xFF0000AA, "{4286f4}[Alexa]: {FFFFEE}Repair your bike first!");
    Data_Ghost_Rider[playerid][0] = CreateObject(18689, 0.0, 0.0, 0.0, 0.0, 0.0, 256.0);
    Data_Ghost_Rider[playerid][1] = CreateObject(18689, 0.0, 0.0, 0.0, 0.0, 0.0, 256.0);
    Data_Ghost_Rider[playerid][2] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0.0, 256.0);
    AttachObjectToVehicle(Data_Ghost_Rider[playerid][0], GetPlayerVehicleID(playerid), 0.0, 0.6, -1.7, 0.0, 0.0, 0.0);
    AttachObjectToVehicle(Data_Ghost_Rider[playerid][1], GetPlayerVehicleID(playerid), 0.0, -1.4, -1.7, 0.0, 0.0, 0.0);
    AttachObjectToPlayer(Data_Ghost_Rider[playerid][2], playerid, 0.0, -0.01, -0.9, 0.0, 0.0, 0.0);
    ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0);
    return 1;
}


hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) {
        if (Data_Ghost_Rider[playerid][0]) {
            DestroyObject(Data_Ghost_Rider[playerid][0]);
            DestroyObject(Data_Ghost_Rider[playerid][1]);
            DestroyObject(Data_Ghost_Rider[playerid][2]);
            Data_Ghost_Rider[playerid][0] = 0;
        }
    }
    if (oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_WASTED) {
        if (Data_Ghost_Rider[playerid][0]) {
            DestroyObject(Data_Ghost_Rider[playerid][0]);
            DestroyObject(Data_Ghost_Rider[playerid][1]);
            DestroyObject(Data_Ghost_Rider[playerid][2]);
            Data_Ghost_Rider[playerid][0] = 0;
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    Data_Ghost_Rider[playerid][0] = 0;
    Data_Ghost_Rider[playerid][1] = 0;
    Data_Ghost_Rider[playerid][2] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (Data_Ghost_Rider[playerid][0]) {
        DestroyObject(Data_Ghost_Rider[playerid][0]);
        DestroyObject(Data_Ghost_Rider[playerid][1]);
        DestroyObject(Data_Ghost_Rider[playerid][2]);
        Data_Ghost_Rider[playerid][0] = 0;
    }
    return 1;
}