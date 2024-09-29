new VSASTIMER[MAX_PLAYERS];
new Iterator:ASpawnedVeh < MAX_VEHICLES > ;

stock respawnunoccupiedvehicle(bool:force = false) {
    for (new i = 1; i < MAX_VEHICLES; i++) {
        if (!IsVehicleOccupied(i)) {
            if (Iter_Contains(ASpawnedVeh, i)) {
                DestroyVehicle(i);
                Iter_Remove(ASpawnedVeh, i);
            } else {
                if (force) SetVehicleToRespawn(i);
            }
        }
    }
    return 1;
}

new PlayerText:textVelocimetro[6][MAX_PLAYERS];
new PlayerText:textPlayerVelocimetro[5][MAX_PLAYERS];
forward VSASUpdate(playerid);
public VSASUpdate(playerid) {
    if (IsPlayerPaused(playerid)) return 1;
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (IsValidVehicle(vehicleid)) {
            PlayerTextDrawSetString(playerid, textPlayerVelocimetro[0][playerid], GetVehicleName(vehicleid));
            new string_velo[15];

            if (GetPlayerTramission(playerid)) format(string_velo, sizeof(string_velo),
                "%02d km/h (G:%s)",
                GetVehicleSpeedEx(playerid),
                GetPlayerGear(playerid) == -1 ? ("R") : GetPlayerGear(playerid) == 0 ? ("N") : sprintf("%d", GetPlayerGear(playerid))
            );
            else format(string_velo, sizeof(string_velo),
                "%02d km/h (A)",
                GetVehicleSpeedEx(playerid)
            );
            PlayerTextDrawSetString(playerid, textPlayerVelocimetro[1][playerid], string_velo);

            format(string_velo, sizeof(string_velo), "%02d%", floatround(Fuel[vehicleid]));
            PlayerTextDrawSetString(playerid, textPlayerVelocimetro[2][playerid], string_velo);

            new Float:Vhealth;
            GetVehicleHealth(vehicleid, Vhealth);
            if (Vhealth < 450.00 && GetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE) && !Event:IsInEvent(playerid)) {
                VehicleEngineStop(vehicleid);
                GameTextForPlayer(playerid, "~w~out of ~r~service", 3000, 3);
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} this vehicle is out of service due to engine error. call 911 and machanic will assist you better.");
            }
            format(string_velo, sizeof(string_velo), "%.0f%", Vhealth);
            PlayerTextDrawSetString(playerid, textPlayerVelocimetro[3][playerid], string_velo);

            new ZoneName[MAX_ZONE_NAME] = "San Andreas";
            GetPlayer3DZone(playerid, ZoneName, MAX_ZONE_NAME);
            format(string_velo, sizeof(string_velo), "%s", ZoneName);
            PlayerTextDrawSetString(playerid, textPlayerVelocimetro[4][playerid], string_velo);
        } else {
            KillTimer(VSASTIMER[playerid]);
            HideVSAS(playerid);
        }
    } else HideVSAS(playerid);
    return 1;
}
stock CreateVSAS(playerid) {
    textPlayerVelocimetro[0][playerid] = CreatePlayerTextDraw(playerid, 615.000000, 371.000000, "-");
    PlayerTextDrawAlignment(playerid, textPlayerVelocimetro[0][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textPlayerVelocimetro[0][playerid], 0);
    PlayerTextDrawFont(playerid, textPlayerVelocimetro[0][playerid], 1);
    PlayerTextDrawLetterSize(playerid, textPlayerVelocimetro[0][playerid], 0.330000, 1.299999);
    PlayerTextDrawColor(playerid, textPlayerVelocimetro[0][playerid], -156);
    PlayerTextDrawSetOutline(playerid, textPlayerVelocimetro[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textPlayerVelocimetro[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textPlayerVelocimetro[0][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textPlayerVelocimetro[0][playerid], 0);

    textPlayerVelocimetro[1][playerid] = CreatePlayerTextDraw(playerid, 615.000000, 385.000000, "000 km/h");
    PlayerTextDrawAlignment(playerid, textPlayerVelocimetro[1][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textPlayerVelocimetro[1][playerid], 0);
    PlayerTextDrawFont(playerid, textPlayerVelocimetro[1][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textPlayerVelocimetro[1][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid, textPlayerVelocimetro[1][playerid], -156);
    PlayerTextDrawSetOutline(playerid, textPlayerVelocimetro[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textPlayerVelocimetro[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textPlayerVelocimetro[1][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textPlayerVelocimetro[1][playerid], 0);

    textPlayerVelocimetro[2][playerid] = CreatePlayerTextDraw(playerid, 615.000000, 399.000000, "0%");
    PlayerTextDrawAlignment(playerid, textPlayerVelocimetro[2][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textPlayerVelocimetro[2][playerid], 0);
    PlayerTextDrawFont(playerid, textPlayerVelocimetro[2][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textPlayerVelocimetro[2][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid, textPlayerVelocimetro[2][playerid], -156);
    PlayerTextDrawSetOutline(playerid, textPlayerVelocimetro[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textPlayerVelocimetro[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textPlayerVelocimetro[2][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textPlayerVelocimetro[2][playerid], 0);

    textPlayerVelocimetro[3][playerid] = CreatePlayerTextDraw(playerid, 615.000000, 413.000000, "0%");
    PlayerTextDrawAlignment(playerid, textPlayerVelocimetro[3][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textPlayerVelocimetro[3][playerid], 0);
    PlayerTextDrawFont(playerid, textPlayerVelocimetro[3][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textPlayerVelocimetro[3][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid, textPlayerVelocimetro[3][playerid], -156);
    PlayerTextDrawSetOutline(playerid, textPlayerVelocimetro[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textPlayerVelocimetro[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textPlayerVelocimetro[3][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textPlayerVelocimetro[3][playerid], 0);

    textPlayerVelocimetro[4][playerid] = CreatePlayerTextDraw(playerid, 615.000000, 427.000000, "San Andreas");
    PlayerTextDrawAlignment(playerid, textPlayerVelocimetro[4][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textPlayerVelocimetro[4][playerid], 0);
    PlayerTextDrawFont(playerid, textPlayerVelocimetro[4][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textPlayerVelocimetro[4][playerid], 0.250000, 1.299999);
    PlayerTextDrawColor(playerid, textPlayerVelocimetro[4][playerid], -156);
    PlayerTextDrawSetOutline(playerid, textPlayerVelocimetro[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textPlayerVelocimetro[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textPlayerVelocimetro[4][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textPlayerVelocimetro[4][playerid], 0);

    textVelocimetro[0][playerid] = CreatePlayerTextDraw(playerid, 379.000000, 364.000000, "i");
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[0][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[0][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[0][playerid], 28.800073, 2.600000);
    PlayerTextDrawColor(playerid, textVelocimetro[0][playerid], 80);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[0][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[0][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[0][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[0][playerid], 0);

    textVelocimetro[1][playerid] = CreatePlayerTextDraw(playerid, 379.000000, 378.000000, "i");
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[1][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[1][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[1][playerid], 28.800073, 2.600000);
    PlayerTextDrawColor(playerid, textVelocimetro[1][playerid], 80);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[1][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[1][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[1][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[1][playerid], 0);

    textVelocimetro[2][playerid] = CreatePlayerTextDraw(playerid, 379.000000, 392.000000, "i");
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[2][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[2][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[2][playerid], 28.800073, 2.600000);
    PlayerTextDrawColor(playerid, textVelocimetro[2][playerid], 80);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[2][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[2][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[2][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[2][playerid], 0);

    textVelocimetro[3][playerid] = CreatePlayerTextDraw(playerid, 379.000000, 406.000000, "i");
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[3][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[3][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[3][playerid], 28.800073, 2.600000);
    PlayerTextDrawColor(playerid, textVelocimetro[3][playerid], 80);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[3][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[3][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[3][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[3][playerid], 0);

    textVelocimetro[4][playerid] = CreatePlayerTextDraw(playerid, 379.000000, 420.000000, "i");
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[4][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[4][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[4][playerid], 28.800073, 2.600000);
    PlayerTextDrawColor(playerid, textVelocimetro[4][playerid], 80);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[4][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[4][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[4][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[4][playerid], 0);

    textVelocimetro[5][playerid] = CreatePlayerTextDraw(playerid, 531.000000, 373.000000, "Vehicle~n~~n~Speed~n~~n~Fuel~n~~n~Health~n~~n~Location");
    PlayerTextDrawAlignment(playerid, textVelocimetro[5][playerid], 3);
    PlayerTextDrawBackgroundColor(playerid, textVelocimetro[5][playerid], 0);
    PlayerTextDrawFont(playerid, textVelocimetro[5][playerid], 2);
    PlayerTextDrawLetterSize(playerid, textVelocimetro[5][playerid], 0.210000, 0.799999);
    PlayerTextDrawColor(playerid, textVelocimetro[5][playerid], -186);
    PlayerTextDrawSetOutline(playerid, textVelocimetro[5][playerid], 0);
    PlayerTextDrawSetProportional(playerid, textVelocimetro[5][playerid], 1);
    PlayerTextDrawSetShadow(playerid, textVelocimetro[5][playerid], 1);
    PlayerTextDrawSetSelectable(playerid, textVelocimetro[5][playerid], 0);
    return 1;
}
stock HideVSAS(playerid) {
    KillTimer(VSASTIMER[playerid]);
    PlayerTextDrawHide(playerid, textPlayerVelocimetro[0][playerid]);
    PlayerTextDrawHide(playerid, textPlayerVelocimetro[1][playerid]);
    PlayerTextDrawHide(playerid, textPlayerVelocimetro[2][playerid]);
    PlayerTextDrawHide(playerid, textPlayerVelocimetro[3][playerid]);
    PlayerTextDrawHide(playerid, textPlayerVelocimetro[4][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[0][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[1][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[2][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[3][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[4][playerid]);
    PlayerTextDrawHide(playerid, textVelocimetro[5][playerid]);
    return 1;
}
stock ShowVSAS(playerid) {
    PlayerTextDrawShow(playerid, textPlayerVelocimetro[0][playerid]);
    PlayerTextDrawShow(playerid, textPlayerVelocimetro[1][playerid]);
    PlayerTextDrawShow(playerid, textPlayerVelocimetro[2][playerid]);
    PlayerTextDrawShow(playerid, textPlayerVelocimetro[3][playerid]);
    PlayerTextDrawShow(playerid, textPlayerVelocimetro[4][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[0][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[1][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[2][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[3][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[4][playerid]);
    PlayerTextDrawShow(playerid, textVelocimetro[5][playerid]);
}
stock DestroyVSAS(playerid) {
    PlayerTextDrawDestroy(playerid, textPlayerVelocimetro[0][playerid]);
    PlayerTextDrawDestroy(playerid, textPlayerVelocimetro[1][playerid]);
    PlayerTextDrawDestroy(playerid, textPlayerVelocimetro[2][playerid]);
    PlayerTextDrawDestroy(playerid, textPlayerVelocimetro[3][playerid]);
    PlayerTextDrawDestroy(playerid, textPlayerVelocimetro[4][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[0][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[1][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[2][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[3][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[4][playerid]);
    PlayerTextDrawDestroy(playerid, textVelocimetro[5][playerid]);
    return 1;
}

///=== Control Menu ===///
new LastVehicle[MAX_VEHICLES] = {
    -1,
    ...
};

stock VehicleControlMenu(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return AlexaMsg(playerid, "You are not in any vehicle");
    new vehicleid = GetPlayerVehicleID(playerid);
    new string[1024];
    strcat(string, "Lighting (On/Off)\n");
    strcat(string, "Bonnect (Open/Close)\n");
    strcat(string, "Boot/Trunk (Open/Close)\n");
    strcat(string, "Doors (Open/Close)\n");
    strcat(string, "Engine (On/Off)\n");
    strcat(string, "Alarm (On/Off)\n");
    strcat(string, "Window (Open/Close)\n");
    strcat(string, "Tranmission (Auto/Manual)\n");

    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        if (PersonalVehicle:GetNeon(vehicleid) != 0) {
            if (GetVehicleNeonLightsState(vehicleid)) strcat(string, "Turn off neon lights\n");
            else strcat(string, "Turn on neon lights\n");
        }
        if (PersonalVehicle:GetXenon(xid) != 0) {
            strcat(string, "Turn off xenon lights\n");
            strcat(string, "Turn on xenon lights\n");
        }
        if (PersonalVehicle:GetHalloween(xid)) {
            strcat(string, "Turn Off Halloween Mode\n");
            strcat(string, "Turn On Halloween Mode\n");
        }
    }
    return FlexPlayerDialog(playerid, "VehicleControlMenuRes", DIALOG_STYLE_LIST, "Control", string, "Select", "Close");
}

FlexDialog:VehicleControlMenuRes(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Lighting (On/Off)")) switch_lights(playerid);
    if (IsStringSame(inputtext, "Bonnect (Open/Close)")) switch_bonnet(playerid);
    if (IsStringSame(inputtext, "Boot/Trunk (Open/Close)")) switch_boot(playerid);
    if (IsStringSame(inputtext, "Doors (Open/Close)")) switch_doors(playerid);
    if (IsStringSame(inputtext, "Engine (On/Off)")) switch_engine(playerid);
    if (IsStringSame(inputtext, "Alarm (On/Off)")) switch_alarm(playerid);
    if (IsStringSame(inputtext, "Window (Open/Close)")) switch_windows(playerid);
    if (IsStringSame(inputtext, "Tranmission (Auto/Manual)")) switch_transmission(playerid);
    if (IsStringSame(inputtext, "Turn off neon lights") || IsStringSame(inputtext, "Turn on neon lights")) switch_neon(playerid);

    new vehicleid = GetPlayerVehicleID(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        if (IsStringSame(inputtext, "Turn Off Halloween Mode")) VehicleHalloweenMode:Remove(vehicleid);
        if (IsStringSame(inputtext, "Turn On Halloween Mode")) VehicleHalloweenMode:Install(vehicleid);
        if (IsStringSame(inputtext, "Turn off xenon lights")) XenonMod:Uninstall(vehicleid);
        if (IsStringSame(inputtext, "Turn on xenon lights")) XenonMod:Install(vehicleid, PersonalVehicle:GetXenon(xid));
    }
    return VehicleControlMenu(playerid);
}

stock switch_neon(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if (PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid)) && PersonalVehicle:GetNeon(vehicleid) != 0) {
        if (GetVehicleNeonLightsState(vehicleid)) SetVehicleNeonLights(vehicleid, false, WHITE_NEON);
        else PersonalVehicle:LoadNeon(vehicleid);
    }
    return 1;
}

stock IsVehicleLocked(vehicleid) {
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (doors == 1) return true;
    else return false;
}

stock GetVehicleLastPlayerID(vehicleid) {
    return LastVehicle[vehicleid];
}

stock vunlock_cmd(playerid, vehicleid) {
    if (!IsValidVehicle(vehicleid)) return SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Unable to locate vehicle.");
    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);
    if (!IsPlayerInRangeOfPoint(playerid, 5, x, y, z)) return SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}You must be near the vehicle to use this command.");
    if (!IsVehicleLocked(vehicleid)) SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Vehicle Already unlocked.");
    else {
        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
        SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Vehicle unlocked.");
    }
    return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    /// unlock system
    if (IsPlayerInAnyVehicle(playerid)) return 1;
    if (newkeys != KEY_SECONDARY_ATTACK) return 1;
    new vehicleid = GetPlayerNearestVehicle(playerid);
    if (!IsValidVehicle(vehicleid)) return 1;
    if (!IsVehicleLocked(vehicleid)) return 1;
    if (GetVehicleLastPlayerID(vehicleid) != playerid) return 1;
    vunlock_cmd(playerid, vehicleid);
    return 1;
}

stock switch_engine(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    if (GetPlayerVehicleSeat(playerid) != 0) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (engine == VEHICLE_PARAMS_ON) {
        VehicleEngineStop(vehicleid);
        GameTextForPlayer(playerid, "~w~Engine ~r~Stopped", 500, 3);
    } else {
        VehicleEngineStart(vehicleid);
        GameTextForPlayer(playerid, "~w~Engine ~r~Started", 500, 3);
    }
    return 1;
}

stock switch_alarm(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (alarm == VEHICLE_PARAMS_ON) {
        SetVehicleParamsEx(vehicleid, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
        SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Alarm Turned OFF.");
        GameTextForPlayer(playerid, "~w~Alarm ~r~Turned OFF", 500, 3);
    } else {
        SetVehicleParamsEx(vehicleid, engine, lights, VEHICLE_PARAMS_ON, doors, bonnet, boot, objective);
        SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Alarm Turned On.");
        GameTextForPlayer(playerid, "~w~Alarm ~r~Turned On", 500, 3);
    }
    return 1;
}

stock switch_doors(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (doors == VEHICLE_PARAMS_ON) {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
        GameTextForPlayer(playerid, "~w~Doors ~r~Unlocked", 500, 3);
    } else {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
        GameTextForPlayer(playerid, "~w~Doors ~r~Locked", 500, 3);
    }
    return 1;
}

stock switch_bonnet(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    if (bonnet == VEHICLE_PARAMS_ON) {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
        GameTextForPlayer(playerid, "~w~Bonnet ~r~Closed", 500, 3);
    } else {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
        GameTextForPlayer(playerid, "~w~Bonnet ~r~Closed", 500, 3);
    }
    return 1;
}

stock switch_boot(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (boot == VEHICLE_PARAMS_ON) {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
        SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFEE}Boot Closed.");
        GameTextForPlayer(playerid, "~w~Boot ~r~Closed", 500, 3);
    } else {
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
        GameTextForPlayer(playerid, "~w~Boot ~r~Opened", 500, 3);
    }
    return 1;
}

stock switch_windows(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (GetVehicleWindowState(vehicleid, DOOR_DRIVER) == VEHICLE_PARAMS_ON) {
        SetVehicleWindowState(vehicleid, DOOR_DRIVER, VEHICLE_PARAMS_OFF);
        SetVehicleWindowState(vehicleid, DOOR_PASSENGER, VEHICLE_PARAMS_OFF);
        SetVehicleWindowState(vehicleid, DOOR_BACKLEFF, VEHICLE_PARAMS_OFF);
        SetVehicleWindowState(vehicleid, DOOR_BACKRIGHT, VEHICLE_PARAMS_OFF);
        GameTextForPlayer(playerid, "~w~Window ~r~Opened", 500, 3);
    } else {
        SetVehicleWindowState(vehicleid, DOOR_DRIVER, VEHICLE_PARAMS_ON);
        SetVehicleWindowState(vehicleid, DOOR_PASSENGER, VEHICLE_PARAMS_ON);
        SetVehicleWindowState(vehicleid, DOOR_BACKLEFF, VEHICLE_PARAMS_ON);
        SetVehicleWindowState(vehicleid, DOOR_BACKRIGHT, VEHICLE_PARAMS_ON);
        GameTextForPlayer(playerid, "~w~Window ~r~Closed", 500, 3);
    }
    return 1;
}

stock switch_lights(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return GameTextForPlayer(playerid, "~w~Unable to connect to the ~r~vehicle", 500, 3);
    new vehicleid = GetPlayerVehicleID(playerid);
    LastVehicle[vehicleid] = playerid;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (GetVehicleModel(vehicleid) != 481 || GetVehicleModel(vehicleid) != 509 || GetVehicleModel(vehicleid) != 510) {
        if (lights == VEHICLE_PARAMS_ON) SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective), GameTextForPlayer(playerid, "~w~Vehicle light ~r~turned off", 500, 3);
        else SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective), GameTextForPlayer(playerid, "~w~Vehicle light ~r~turned on", 500, 3);
        if (IsTrailerAttachedToVehicle(vehicleid)) {
            new trailerid = GetVehicleTrailer(vehicleid);
            if (lights == VEHICLE_PARAMS_OFF) SetVehicleParamsEx(trailerid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
            else SetVehicleParamsEx(trailerid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
        }
    } else GameTextForPlayer(playerid, "~w~This vehicle doesn't have ~r~lights", 500, 3);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    CreateVSAS(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    KillTimer(VSASTIMER[playerid]);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_ONFOOT) KillTimer(VSASTIMER[playerid]), HideVSAS(playerid);
    if (newstate == PLAYER_STATE_DRIVER) {
        new blacklist[] = { 481, 509, 510 };
        if (!IsArrayContainNumber(blacklist, GetVehicleModel(GetPlayerVehicleID(playerid)))) {
            VSASTIMER[playerid] = SetTimerEx("VSASUpdate", 1000, true, "i", playerid);
            ShowVSAS(playerid);
        }
    }
    return 1;
}

#include <YSI_Coding\y_hooks>
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    ///=== Tow System ===///
    new vehicle = GetPlayerVehicleID(playerid);
    new model = GetVehicleModel(vehicle);
    new targetVehicle, Float:targetVehicleDistance, closestVehicle, Float:closestVehicleDistance = 7.0, bool:found = FALSE;
    new Float:tX, Float:tY, Float:tZ;
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && (newkeys & KEY_ACTION) && (model == 525 || model == 531 || model == 583)) {
        if (IsTrailerAttachedToVehicle(vehicle)) {
            DetachTrailerFromVehicleEx(vehicle);
        } else {
            while (targetVehicle < MAX_VEHICLES) {
                GetVehiclePos(targetVehicle, tX, tY, tZ);
                targetVehicleDistance = GetVehicleDistanceFromPoint(vehicle, tX, tY, tZ);
                if (IsValidVehicle(targetVehicle) && (floatcmp(targetVehicleDistance, 7.0) <= 0) && (targetVehicle != vehicle) && (floatcmp(targetVehicleDistance, closestVehicleDistance) <= 0)) {
                    found = true;
                    closestVehicle = targetVehicle;
                    closestVehicleDistance = targetVehicleDistance;
                }
                targetVehicle++;
            }
            if (found) { if (!IsTrailerAttachedToVehicle(vehicle)) AttachTrailerToVehicleEx(closestVehicle, vehicle); }
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    HideVSAS(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsPlayerInAnyVehicle(playerid)) UCP:AddCommand(playerid, "Vehicle Controls", true);
    if (IsAndroidPlayer(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) {
            new vehicle = GetPlayerVehicleID(playerid);
            new model = GetVehicleModel(vehicle);
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && (model == 525 || model == 531 || model == 583)) {
                if (IsTrailerAttachedToVehicle(vehicle)) {
                    UCP:AddCommand(playerid, "Deattach Trailer", true);
                } else {
                    new targetVehicle, Float:targetVehicleDistance, Float:closestVehicleDistance = 7.0, bool:found = FALSE;
                    new Float:tX, Float:tY, Float:tZ;
                    while (targetVehicle < MAX_VEHICLES) {
                        GetVehiclePos(targetVehicle, tX, tY, tZ);
                        targetVehicleDistance = GetVehicleDistanceFromPoint(vehicle, tX, tY, tZ);
                        if (IsValidVehicle(targetVehicle) && (floatcmp(targetVehicleDistance, 7.0) <= 0) && (targetVehicle != vehicle) && (floatcmp(targetVehicleDistance, closestVehicleDistance) <= 0)) {
                            found = true;
                            closestVehicleDistance = targetVehicleDistance;
                        }
                        targetVehicle++;
                    }
                    if (found) UCP:AddCommand(playerid, "Attach Trailer", true);
                }
            }
        }
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Vehicle Controls", inputtext)) VehicleControlMenu(playerid);
    if (IsAndroidPlayer(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) {
            new vehicle = GetPlayerVehicleID(playerid);
            new model = GetVehicleModel(vehicle);
            new targetVehicle, Float:targetVehicleDistance, closestVehicle, Float:closestVehicleDistance = 7.0, bool:found = FALSE;
            new Float:tX, Float:tY, Float:tZ;
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && (model == 525 || model == 531 || model == 583)) {
                if (IsStringSame("Deattach Trailer", inputtext)) {
                    if (IsTrailerAttachedToVehicle(vehicle)) {
                        DetachTrailerFromVehicleEx(vehicle);
                    }
                }
                if (IsStringSame("Attach Trailer", inputtext)) {
                    while (targetVehicle < MAX_VEHICLES) {
                        GetVehiclePos(targetVehicle, tX, tY, tZ);
                        targetVehicleDistance = GetVehicleDistanceFromPoint(vehicle, tX, tY, tZ);
                        if (IsValidVehicle(targetVehicle) && (floatcmp(targetVehicleDistance, 7.0) <= 0) && (targetVehicle != vehicle) && (floatcmp(targetVehicleDistance, closestVehicleDistance) <= 0)) {
                            found = true;
                            closestVehicle = targetVehicle;
                            closestVehicleDistance = targetVehicleDistance;
                        }
                        targetVehicle++;
                    }
                    if (found) { if (!IsTrailerAttachedToVehicle(vehicle)) AttachTrailerToVehicleEx(closestVehicle, vehicle); }
                }
            }
        }
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        if (IsStringContainWords(text, "turn neon") && PersonalVehicle:GetNeon(vehicleid) != 0) {
            switch_neon(playerid);
            return ~1;
        }
        if (IsStringContainWords(text, "turn off xenon") && PersonalVehicle:GetXenon(xid) != 0) {
            XenonMod:Uninstall(vehicleid);
            return ~1;
        }
        if (IsStringContainWords(text, "turn on xenon") && PersonalVehicle:GetXenon(xid) != 0) {
            XenonMod:Install(vehicleid, PersonalVehicle:GetXenon(xid));
            return ~1;
        }
        if (IsStringContainWords(text, "turn on halloween") && PersonalVehicle:GetHalloween(xid)) {
            VehicleHalloweenMode:Install(vehicleid);
            return ~1;
        }
        if (IsStringContainWords(text, "turn off halloween") && PersonalVehicle:GetHalloween(xid)) {
            VehicleHalloweenMode:Remove(vehicleid);
            return ~1;
        }
    }

    if (IsStringContainWords(text, "turn lights")) {
        switch_lights(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "open bonnet, close bonnet")) {
        switch_bonnet(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "open boot, boot bonnet")) {
        switch_boot(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "lock doors, unlock doors")) {
        switch_doors(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "start engine, stop engine")) {
        switch_engine(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "turn on alarm, turn of alarms")) {
        switch_alarm(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "open windows, close windows")) {
        switch_windows(playerid);
        return ~1;
    }
    return 1;
}