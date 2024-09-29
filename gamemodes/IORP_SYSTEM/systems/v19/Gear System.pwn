#define GEAR_1_MAX_SPEED 20
#define GEAR_2_MAX_SPEED 50
#define GEAR_2_MIN_SPEED 10
#define GEAR_3_MAX_SPEED 80
#define GEAR_3_MIN_SPEED 30
#define GEAR_4_MAX_SPEED 120
#define GEAR_4_MIN_SPEED 50
#define GEAR_5_MIN_SPEED 70

#define HEAVY_SPEED_REDUCTION 1.5
#define LIGHT_SPEED_REDUCTION 1.1
#define STALL_PUNISHMENT 10
#define GEAR_PUNISHMENT 1

new gs_gear[MAX_PLAYERS];
new gs_clutch[MAX_PLAYERS];
new gs_acc[MAX_PLAYERS];
new gs_rev[MAX_PLAYERS];
new gs_transmission[MAX_PLAYERS];

stock GetPlayerGear(playerid) {
    return gs_gear[playerid];
}

stock GetPlayerTramission(playerid) {
    return gs_transmission[playerid];
}

stock switch_transmission(playerid) {
    if (gs_transmission[playerid] == 1) gs_transmission[playerid] = 0;
    else gs_transmission[playerid] = 1;
    return 1;
}

forward EnableEngine(playerid);
public EnableEngine(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (engine == 0) SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}

forward StallEngine(playerid);
public StallEngine(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new engine, lights, alarm, doors, bonnet, boot, objective;
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
    if (IsTimePassedForPlayer(playerid, "Stall Warning", 2)) GameTextForPlayer(playerid, "Engine ~r~Stall", 1500, 3);
    return 1;
}

forward ReduceSpeed(playerid, status);
public ReduceSpeed(playerid, status) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:Velocity[3];
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    GetVehicleVelocity(vehicleid, Velocity[0], Velocity[1], Velocity[2]);

    if (status == 0) {
        SetVehicleVelocity(GetPlayerVehicleID(playerid), Velocity[0] / LIGHT_SPEED_REDUCTION, Velocity[1] / LIGHT_SPEED_REDUCTION, Velocity[2] / LIGHT_SPEED_REDUCTION);
    }

    if (status == 1) {
        SetVehicleVelocity(GetPlayerVehicleID(playerid), Velocity[0] / HEAVY_SPEED_REDUCTION, Velocity[1] / HEAVY_SPEED_REDUCTION, Velocity[2] / HEAVY_SPEED_REDUCTION);
    }

    if (status == 2) {
        SetVehicleVelocity(GetPlayerVehicleID(playerid), Velocity[0] / HEAVY_SPEED_REDUCTION, Velocity[1] / HEAVY_SPEED_REDUCTION, Velocity[2] / HEAVY_SPEED_REDUCTION);
    }
}

forward GS_GetVehicleSpeed(vehicleid);
public GS_GetVehicleSpeed(vehicleid) {
    new Float:V[3];
    GetVehicleVelocity(vehicleid, V[0], V[1], V[2]);
    return floatround(floatsqroot(V[0] * V[0] + V[1] * V[1] + V[2] * V[2]) * 180.00);
}


hook OnPlayerConnect(playerid) {
    gs_gear[playerid] = 0;
    gs_clutch[playerid] = 0;
    gs_acc[playerid] = 0;
    gs_rev[playerid] = 0;
    gs_transmission[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    gs_gear[playerid] = 0;
    gs_clutch[playerid] = 0;
    gs_acc[playerid] = 0;
    gs_rev[playerid] = 0;
    gs_transmission[playerid] = 0;
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (gs_transmission[playerid] == 0) return 1;
    if (oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) gs_gear[playerid] = 0;
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (!IsPlayerInAnyVehicle(playerid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)) return 1;
    if (gs_transmission[playerid] == 0) {
        return 1;
    }
    if (newkeys & KEY_SPRINT) {
        gs_acc[playerid] = 1;
    } else {
        gs_acc[playerid] = 0;
    }
    if (newkeys & KEY_JUMP) {
        gs_rev[playerid] = 1;
    } else {
        gs_rev[playerid] = 0;
    }
    if (newkeys & KEY_FIRE) {
        gs_clutch[playerid] = 1;
    } else {
        gs_clutch[playerid] = 0;
    }
    if ((newkeys & KEY_FIRE) && (newkeys & KEY_SPRINT) && gs_gear[playerid] < 5) {
        gs_gear[playerid]++;
    }
    if ((newkeys & KEY_FIRE) && (newkeys & KEY_JUMP) && gs_gear[playerid] > -1) {
        gs_gear[playerid]--;
    }
    if ((newkeys & KEY_FIRE) && ((newkeys & KEY_SPRINT) || (newkeys & KEY_JUMP)) && (gs_gear[playerid] == 1 || gs_gear[playerid] == -1)) {
        EnableEngine(playerid);
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (!IsPlayerInAnyVehicle(playerid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)) return 1;
    if (gs_transmission[playerid] == 0) return 1;
    if (IsPlayerInAnyVehicle(playerid) == 0) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicleid);
    new arrayRev[] = { 417, 425, 447, 460, 469, 476, 487, 488, 460, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593 };
    if (IsArrayContainNumber(arrayRev, model)) return 1;

    //HANDLES VEHICLE MECHANICS//

    new speed = GS_GetVehicleSpeed(vehicleid);

    // reverse gear
    if (gs_gear[playerid] == -1 && gs_acc[playerid] == 1) StallEngine(playerid);

    // idel gear
    if (gs_gear[playerid] == 0 && (speed > 0) && (gs_acc[playerid] == 1 || gs_rev[playerid] == 1)) StallEngine(playerid);

    // gear more than idle
    if (gs_gear[playerid] > 0) {
        if (
            (speed > 0 && speed < 10 && gs_rev[playerid] == 1) ||
            (speed < 3 && gs_clutch[playerid] == 0)
        ) StallEngine(playerid);
        else if (gs_acc[playerid] == 1 && gs_clutch[playerid] == 1) ReduceSpeed(playerid, 0);
    }

    // gear more than 1
    if (gs_gear[playerid] > 1 && (speed < 10)) {
        if (gs_clutch[playerid] == 1) ReduceSpeed(playerid, 2);
        else StallEngine(playerid);
    }


    // gear: 1
    if (gs_gear[playerid] == 1 && speed > GEAR_1_MAX_SPEED) ReduceSpeed(playerid, 1);

    // gear: 2
    if (gs_gear[playerid] == 2) {
        if (speed > GEAR_2_MAX_SPEED) ReduceSpeed(playerid, 0);
        if (gs_clutch[playerid] == 1 || gs_acc[playerid] == 0) return 1;
        if (speed < GEAR_2_MIN_SPEED) StallEngine(playerid);
    }

    if (gs_gear[playerid] == 3) {
        if (speed > GEAR_3_MAX_SPEED) ReduceSpeed(playerid, 0);
        if (gs_clutch[playerid] == 1 || gs_acc[playerid] == 0) return 1;
        if (speed < GEAR_3_MIN_SPEED) StallEngine(playerid);
    }

    if (gs_gear[playerid] == 4) {
        if (speed > GEAR_4_MAX_SPEED) ReduceSpeed(playerid, 0);
        if (gs_clutch[playerid] == 1 || gs_acc[playerid] == 0) return 1;
        if (speed < GEAR_4_MIN_SPEED) StallEngine(playerid);
    }

    if (gs_gear[playerid] == 5) {
        if (gs_clutch[playerid] == 1 || gs_acc[playerid] == 0) return 1;
        if (speed < GEAR_5_MIN_SPEED) StallEngine(playerid);

    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (IsStringContainWords(text, "auto gear")) {
        if (gs_transmission[playerid] == 0) {
            SendClientMessage(playerid, 0x00FF00FF, "Alexa:type manual to change to manual gs_transmission.");
            return ~1;
        }
        gs_transmission[playerid] = 0;
        SendClientMessage(playerid, 0x00FF00FF, "Alexa:Transmission:Automatic");
        return ~1;
    }

    if (IsStringContainWords(text, "manual gear")) {
        if (gs_transmission[playerid] == 1) {
            SendClientMessage(playerid, 0x00FF00FF, "Alexa:type auto to change to automatic gs_transmission.");
            return ~1;
        }
        gs_transmission[playerid] = 0;
        SendClientMessage(playerid, 0x00FF00FF, "Alexa:Transmission:Manual");
        SendClientMessage(playerid, 0x00FF00FF, "Alexa:CONTROLS -  [LALT] CLUTCH || [LALT+W] UP GEAR || [LALT+S] DOWN GEAR");
        gs_transmission[playerid] = 1;
        return ~1;
    }
    return 1;
}