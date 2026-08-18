#define SEATBELT_HELMET_BODY_ATTACH_INDEX 9
#define NRoleplayRange 100.0
#define MODEL_ERROR		0
#define MODEL_CAR       1
#define MODEL_BIKE      2
#define MODEL_MBIKE		3
#define MODEL_BOAT      4
#define MODEL_PLANE     5

#define ATTACH_PLAYER_SEATBELT  19314
#define ATTACH_PLAYER_HELMET1   18978
#define ATTACH_PLAYER_HELMET2   19102

new VehicleSafety[MAX_PLAYERS];

//0 - error, 1 - car, 2 - bike, 3 - boat, 4 - plane/heli
stock SeatbeltHelmet_IsVehicleModel(modelid) {
    switch (modelid) {
        case 0 : return MODEL_ERROR;
        case 481, 509, 510 : return MODEL_BIKE;
        case 448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586 : return MODEL_MBIKE;
        case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595 : return MODEL_BOAT;
        case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593 : return MODEL_PLANE;
        default: return MODEL_CAR;
    }
    return 0;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (newstate == PLAYER_STATE_ONFOOT) {
        if (VehicleSafety[playerid] != 0) {
            if (VehicleSafety[playerid] == 1) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their seatbelt, and unbuckles it.", GetPlayerNameEx(playerid)));
            else if (VehicleSafety[playerid] == 2) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it off.", GetPlayerNameEx(playerid)));
            VehicleSafety[playerid] = 0;
            RemovePlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX);
        }
    }
    if (newstate == PLAYER_STATE_PASSENGER || newstate == PLAYER_STATE_DRIVER) {
        if (IsTimePassedForPlayer(playerid, "seatbelt warning", 5 * 60) && GetPlayerScore(playerid) < 50) {
            GameTextForPlayer(playerid, "~r~please wear~n~seatbelt/helmet", 3000, 3);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} wear the seatbelt/helmet while driving because seat belts/helmet could avoid accidents");
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    if (VehicleSafety[playerid] != 0) {
        if (VehicleSafety[playerid] == 1) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their seatbelt, and unbuckles it.", GetPlayerNameEx(playerid)));
        else if (VehicleSafety[playerid] == 2) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it off.", GetPlayerNameEx(playerid)));
        VehicleSafety[playerid] = 0;
        RemovePlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX);
    }
    return 1;
}

hook OnVehicleHealthChange(vehicleid, Float:newhealth, Float:oldhealth) {
    foreach(new playerid: Player) {
        if (GetPlayerVehicleID(playerid) == vehicleid && !Event:IsInEvent(playerid)) {
            if (IsTimePassedForPlayer(playerid, "seatbelt_damage", 10)) {
                new Float:p_HP;
                GetPlayerHealth(playerid, p_HP);
                if (VehicleSafety[playerid] == 1) SetPlayerHealthEx(playerid, p_HP - 1);
                else SetPlayerHealthEx(playerid, p_HP - 7);
            }
        }
    }
    return 1;
}

cmd:seatbelt(playerid, const params[]) {
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) {
        new vehid = GetPlayerVehicleID(playerid);
        new model = GetVehicleModel(vehid);
        new vehicletype = SeatbeltHelmet_IsVehicleModel(model);
        if (SeatbeltHelmet_IsVehicleModel(model) == MODEL_CAR || vehicletype == MODEL_BIKE || vehicletype == MODEL_MBIKE) {
            if (VehicleSafety[playerid] == 0) {
                AlexaMsg(playerid, "You have put on your seatbelt/helmet");
                if (vehicletype == MODEL_BIKE) SetPlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX, ATTACH_PLAYER_HELMET2, 2, 0.15, 0.00, 0.00, 0.0, 0.0, 0.0, 1.14, 1.10, 1.11), SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it on.", GetPlayerNameEx(playerid))), VehicleSafety[playerid] = 2;
                else if (vehicletype == MODEL_MBIKE) SetPlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX, ATTACH_PLAYER_HELMET1, 2, 0.06, 0.02, 0.00, 0.0, 89.0, 89.0, 1.10, 0.89, 1.00), SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it on.", GetPlayerNameEx(playerid))), VehicleSafety[playerid] = 2;
                else if (vehicletype == MODEL_CAR) SetPlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX, ATTACH_PLAYER_SEATBELT, 1, 0.07, 0.21, -0.00, -21.0, -54.0, 183.0, 0.39, 0.40, 0.31), SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their seatbelt, and buckles it.", GetPlayerNameEx(playerid))), VehicleSafety[playerid] = 1;
            } else if (VehicleSafety[playerid] == 1 || VehicleSafety[playerid] == 2) {
                AlexaMsg(playerid, "You have taken off your seatbelt/helmet");
                VehicleSafety[playerid] = 0;
                RemovePlayerAttachedObject(playerid, SEATBELT_HELMET_BODY_ATTACH_INDEX);
                if (vehicletype == MODEL_BIKE) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it off.", GetPlayerNameEx(playerid)));
                else if (vehicletype == MODEL_MBIKE) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their helmet, and takes it off.", GetPlayerNameEx(playerid)));
                else if (vehicletype == MODEL_CAR) SendRPMessageToAll(playerid, NRoleplayRange, COLOR_MEDIUMPURPLE, sprintf("* %s reaches for their seatbelt, and unbuckles it.", GetPlayerNameEx(playerid)));
            }
            return 1;
        }
    }
    return 0;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsPlayerInAnyVehicle(playerid)) UCP:AddCommand(playerid, "Put Seatbelt/Helmet", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Put Seatbelt/Helmet", inputtext)) {
        callcmd::seatbelt(playerid, "");
        return ~1;
    }
    return 1;
}