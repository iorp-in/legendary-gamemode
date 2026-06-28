new Float:VEHICLE_POSITIONS[MAX_VEHICLES][4],
    bool:ALLOW_UPDATE[MAX_VEHICLES] = {
        false,
        ...
    },
    bool:VEHICLE_SPAWNED[MAX_VEHICLES] = {
        false,
        ...
    },
    LAST_TRAILER[MAX_VEHICLES],
    LAST_TOWED[MAX_VEHICLES],
    UPDATE_COUNTER[MAX_VEHICLES char];

new LAST_VEHICLE[MAX_PLAYERS],
    FORCED_VEHICLE[MAX_PLAYERS];

hook OnUnoccupiedVehicleUpd(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z) {
    if (VEHICLE_SPAWNED[vehicleid]) {
        if (!ALLOW_UPDATE[vehicleid]) {
            if (GetVehicleDistanceFromPoint(vehicleid, VEHICLE_POSITIONS[vehicleid][0], VEHICLE_POSITIONS[vehicleid][1], VEHICLE_POSITIONS[vehicleid][2]) > 10.5) {
                UPDATE_COUNTER {
                    vehicleid
                } = 0;
                SetVehicleOriginalPos(vehicleid);
                if (funcidx("OnAntiCheatVehicleWarp") != -1) {
                    CallRemoteFunction("OnAntiCheatVehicleWarp", "ii", playerid, vehicleid);
                }
            } else {
                if (UPDATE_COUNTER {
                        vehicleid
                    } >= 2) {
                    UPDATE_COUNTER {
                        vehicleid
                    } = 0;
                    VEHICLE_POSITIONS[vehicleid][0] = new_x;
                    VEHICLE_POSITIONS[vehicleid][1] = new_y;
                    VEHICLE_POSITIONS[vehicleid][2] = new_z;
                    GetVehicleZAngle(
                        vehicleid,
                        VEHICLE_POSITIONS[vehicleid][3]);
                }
                UPDATE_COUNTER {
                    vehicleid
                }++;
            }
        } else {
            if (LAST_TRAILER[vehicleid] > 0) {
                if (!IsTrailerAttachedToVehicle(LAST_TRAILER[vehicleid])) {
                    LAST_TOWED[LAST_TRAILER[vehicleid]] = 0;
                    LAST_TRAILER[vehicleid] = 0;
                    ALLOW_UPDATE[vehicleid] = false;
                    UPDATE_COUNTER {
                        vehicleid
                    } = 0;
                }
            } else {
                if (GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) <= 1.5) {
                    SaveVehiclePosition(vehicleid);
                    SetVehicleOriginalPos(vehicleid);
                    UPDATE_COUNTER {
                        vehicleid
                    } = 0;
                    ALLOW_UPDATE[vehicleid] = false;
                }
            }
        }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) {
        SaveVehiclePosition(LAST_VEHICLE[playerid]);
        ALLOW_UPDATE[LAST_VEHICLE[playerid]] = true;
    } else if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
        new vehicleid = GetPlayerVehicleID(playerid);

        if (FORCED_VEHICLE[playerid] == vehicleid) {
            FORCED_VEHICLE[playerid] = 0;
            LAST_VEHICLE[playerid] = vehicleid;
        } else {
            if (VEHICLE_SPAWNED[vehicleid]) {
                SetVehicleToRespawn(vehicleid);
                if (funcidx("OnAntiCheatVehicleWarpInto") != -1) {
                    return CallRemoteFunction("OnAntiCheatVehicleWarpInto", "ii", playerid, vehicleid);
                }
            }
        }
        if (!ALLOW_UPDATE[vehicleid]) {
            if (GetVehicleDistanceFromPoint(
                    vehicleid,
                    VEHICLE_POSITIONS[vehicleid][0],
                    VEHICLE_POSITIONS[vehicleid][1],
                    VEHICLE_POSITIONS[vehicleid][2]) > 7.5) {
                UPDATE_COUNTER {
                    vehicleid
                } = 0;

                SetVehicleOriginalPos(vehicleid);
                if (funcidx("OnAntiCheatVehicleWarp") != -1) {
                    return CallRemoteFunction("OnAntiCheatVehicleWarp", "ii", playerid, vehicleid);
                }
            }
        }
    }
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    FORCED_VEHICLE[playerid] = vehicleid;
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    SaveVehiclePosition(vehicleid);

    VEHICLE_SPAWNED[vehicleid] = true;

    if (LAST_TRAILER[vehicleid] > 0) {
        if (VEHICLE_SPAWNED[LAST_TRAILER[vehicleid]]) {
            AttachTrailerToVehicleEx(vehicleid, LAST_TRAILER[vehicleid]);
        }
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    VEHICLE_SPAWNED[vehicleid] = false;

    if (LAST_TOWED[vehicleid] > 0) {
        LAST_TRAILER[LAST_TOWED[vehicleid]] = 0;
        UPDATE_COUNTER {
            LAST_TOWED[vehicleid]
        } = 0;
        ALLOW_UPDATE[LAST_TOWED[vehicleid]] = false;
        LAST_TOWED[vehicleid] = 0;
    }
    if (LAST_TRAILER[vehicleid] > 0) {
        LAST_TOWED[LAST_TRAILER[vehicleid]] = 0;
        LAST_TRAILER[vehicleid] = 0;
        UPDATE_COUNTER {
            vehicleid
        } = 0;
        ALLOW_UPDATE[vehicleid] = false;
    }
    return 1;
}

hook OnVehicleStreamIn(vehicleid, forplayerid) {
    if (!VEHICLE_SPAWNED[vehicleid]) {
        VEHICLE_SPAWNED[vehicleid] = true;
        SetVehicleToRespawn(vehicleid);
    }
    return 1;
}

forward SaveVehiclePosition(vehicleid);
public SaveVehiclePosition(vehicleid) {
    GetVehiclePos(vehicleid, VEHICLE_POSITIONS[vehicleid][0], VEHICLE_POSITIONS[vehicleid][1], VEHICLE_POSITIONS[vehicleid][2]);
    GetVehicleZAngle(vehicleid, VEHICLE_POSITIONS[vehicleid][3]);
    return 1;
}

stock SetVehicleOriginalPos(vehicleid) {
    SetVehiclePosEx(vehicleid, VEHICLE_POSITIONS[vehicleid][0], VEHICLE_POSITIONS[vehicleid][1], VEHICLE_POSITIONS[vehicleid][2]);
    SetVehicleZAngle(vehicleid, VEHICLE_POSITIONS[vehicleid][3]);
    return 1;
}

hook AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2) {
    //modelid	=	AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, angle, color1, color2);

    VEHICLE_POSITIONS[modelid][0] = spawn_x;
    VEHICLE_POSITIONS[modelid][1] = spawn_y;
    VEHICLE_POSITIONS[modelid][2] = spawn_z;
    VEHICLE_POSITIONS[modelid][3] = angle;

    //SetVehicleToRespawn(modelid);
    //return modelid;
    return 1;
}

hook AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:angle, color1, color2, respawn_delay) {
    //modelid	=	AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, angle, color1, color2, respawn_delay);

    VEHICLE_POSITIONS[modelid][0] = spawn_x;
    VEHICLE_POSITIONS[modelid][1] = spawn_y;
    VEHICLE_POSITIONS[modelid][2] = spawn_z;
    VEHICLE_POSITIONS[modelid][3] = angle;

    //SetVehicleToRespawn(modelid);
    //return modelid;
    return 1;
}

hook OnVehicleCreated(vehicleid) {
    SaveVehiclePosition(vehicleid);
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    SaveVehiclePosition(vehicleid);
    return 1;
}

hook OnSetVehiclePosEx(vehicleid, Float:x, Float:y, Float:z) {
    VEHICLE_POSITIONS[vehicleid][0] = x;
    VEHICLE_POSITIONS[vehicleid][1] = y;
    VEHICLE_POSITIONS[vehicleid][2] = z;

    //return SetVehiclePosEx(vehicleid, x, y, z);
    return 1;
}

hook OnVehicleZAngleUpdate(vehicleid, Float:angle) {
    VEHICLE_POSITIONS[vehicleid][3] = angle;
    //return SetVehicleZAngle(vehicleid, z_angle);
    return 1;
}

stock AttachTrailerToVehicleEx(trailerid, vehicleid) {
    ALLOW_UPDATE[trailerid] = true;
    LAST_TRAILER[trailerid] = vehicleid;
    LAST_TOWED[vehicleid] = trailerid;
    return AttachTrailerToVehicle(trailerid, vehicleid);
}

stock DetachTrailerFromVehicleEx(vehicleid) {
    LAST_TOWED[LAST_TRAILER[vehicleid]] = 0;
    ALLOW_UPDATE[vehicleid] = false;
    LAST_TRAILER[vehicleid] = 0;
    SaveVehiclePosition(vehicleid);
    return DetachTrailerFromVehicle(vehicleid);
}

hook OnTrailerHooked(playerid, vehicleid, trailerid) {
    ALLOW_UPDATE[trailerid] = true;
    LAST_TRAILER[trailerid] = vehicleid;
    LAST_TOWED[vehicleid] = trailerid;
    SaveVehiclePosition(trailerid);
    return 1;
}

hook OnTrailerUnhooked(playerid, vehicleid, trailerid) {
    ALLOW_UPDATE[trailerid] = false;
    LAST_TRAILER[trailerid] = vehicleid;
    LAST_TOWED[vehicleid] = trailerid;
    SaveVehiclePosition(trailerid);
    return 1;
}

hook OnSetVehicleToRespawnEx(vehicleid) {
    //SetVehicleToRespawn(vehicleid);

    ALLOW_UPDATE[vehicleid] = false;
    LAST_TRAILER[vehicleid] = 0;

    SaveVehiclePosition(vehicleid);
    return 1;
}

hook OnPutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    FORCED_VEHICLE[playerid] = vehicleid;
    return 1;
}

hook RemovePlayerFromVehicle(playerid) {
    SaveVehiclePosition(LAST_VEHICLE[playerid]);

    FORCED_VEHICLE[playerid] = 0;

    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (IsPlayerInAnyVehicle(playerid)) SaveVehiclePosition(LAST_VEHICLE[playerid]);
    return 1;
}

new WarpHackWarning[MAX_PLAYERS] = { 0, ... };
hook OnPlayerConnect(playerid) {
    WarpHackWarning[playerid] = 0;
    return 1;
}
forward ResetHackCounter(playerid);
public ResetHackCounter(playerid) {
    return 1;
}
forward OnAntiCheatVehicleWarp(playerid, vehicleid);
public OnAntiCheatVehicleWarp(playerid, vehicleid) {
    return 1;
}
forward OnAntiCheatVehicleWarpInto(playerid, vehicleid);
public OnAntiCheatVehicleWarpInto(playerid, vehicleid) {
    WarpHackWarning[playerid]++;
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE} you have attemp to warp vehicle %d", vehicleid));
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}we have jailed you for 3 mins for security reasons, please avoid mods and hacks from being reported."));
    SendAdminLogMessage(sprintf("%s attemp to warp vehicle %d", GetPlayerNameEx(playerid), vehicleid));
    if (WarpHackWarning[playerid] > 3) WantedDatabase:AdminJail(playerid, 3, sprintf("attemp to warp vehicle %d", GetPlayerNameEx(playerid), vehicleid), false);
    return 1;
}