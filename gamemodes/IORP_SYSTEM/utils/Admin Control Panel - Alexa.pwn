hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerAdminLevel(playerid) < 1) return 1;
    if (IsStringContainWords(text, "respawn") && GetPlayerAdminLevel(playerid) > 0) {
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]: {FFFFEE}Admin {FFCC66}%s {FFFFEE}requested for respawn all unoccupied Vehicle's", GetPlayerNameEx(playerid)));
        respawnunoccupiedvehicle(true);
        return ~1;
    }

    if (IsStringContainWords(text, "tp") && GetPlayerAdminLevel(playerid) > 0) {
        new Float:x, Float:y, Float:z, string[128];
        sscanf(text, "s[128]", string);
        strreplace(string, "tp ", "");
        sscanf(string, "p<,>fff", x, y, z);
        SetPlayerPosEx(playerid, Float:x, Float:y, Float:z);
        return ~1;
    }

    if (IsStringContainWords(text, "goto") && GetPlayerAdminLevel(playerid) > 0) {
        new extraid;
        if (sscanf(GetNextWordFromString(text, "goto"), "u", extraid)) extraid = playerid;
        if (!IsPlayerConnected(extraid)) extraid = playerid;
        if (extraid == playerid) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Invalid PlayerID");
            return ~1;
        }
        if (!Tryg3D::IsPlayerSpawned(extraid)) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Error]:{FFFFEE} wait for the player to spawn");
            return ~1;
        }
        new Float:x, Float:y, Float:z, Float:a, int, worldid;
        int = GetPlayerInterior(extraid);
        worldid = GetPlayerVirtualWorld(extraid);
        GetPlayerPos(extraid, x, y, z);
        GetXYInFrontOfPlayer(extraid, x, y, 10);
        GetPlayerFacingAngle(extraid, a);
        SetPlayerVirtualWorldEx(playerid, worldid);
        SetPlayerInteriorEx(playerid, int);
        if (IsPlayerInAnyVehicle(playerid)) TeleportVehicleEx(GetPlayerVehicleID(playerid), x, y, z, a - 180, worldid, int);
        else {
            SetPlayerPosEx(playerid, x, y, z);
            SetPlayerFacingAngle(playerid, a - 180);
        }
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have teleported yourself to location of %s", GetPlayerNameEx(extraid)));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} Administrator %s teleported himself to your location", GetPlayerNameEx(playerid)));
        return ~1;
    }

    if (IsStringContainWords(text, "get") && GetPlayerAdminLevel(playerid) > 0) {
        new extraid;
        if (sscanf(GetNextWordFromString(text, "get"), "d", extraid)) extraid = playerid;
        if (extraid == -1) {
            new Float:x, Float:y, Float:z, Float:a, int, worldid;
            int = GetPlayerInterior(playerid);
            worldid = GetPlayerVirtualWorld(playerid);
            GetPlayerFacingAngle(playerid, a);
            GetPlayerPos(playerid, x, y, z);
            foreach(new i:Player) {
                if (IsPlayerInAnyVehicle(i)) TeleportVehicleEx(GetPlayerVehicleID(i), x + random(5), y + random(5), z + 1, a + 180, worldid, int);
                else SetPlayerVirtualWorldEx(i, worldid), SetPlayerInteriorEx(i, int), SetPlayerPosEx(i, x + random(5), y + random(5), z + 1), SetPlayerFacingAngle(i, a - 180);
            }
            new string[512];
            format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}Admin %s teleported all players to his location", GetPlayerNameEx(playerid));
            SendClientMessageToAll(-1, string);
            return ~1;
        }
        if (!IsPlayerConnected(extraid)) extraid = playerid;
        if (extraid == playerid) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Invalid PlayerID");
            return ~1;
        }
        new Float:x, Float:y, Float:z, Float:a, int, worldid;
        int = GetPlayerInterior(playerid);
        worldid = GetPlayerVirtualWorld(playerid);
        GetPlayerPos(playerid, x, y, z);
        GetXYInFrontOfPlayer(playerid, x, y, 10);
        GetPlayerFacingAngle(playerid, a);
        SetPlayerVirtualWorldEx(extraid, worldid);
        SetPlayerInteriorEx(extraid, int);
        if (IsPlayerInAnyVehicle(extraid)) TeleportVehicleEx(GetPlayerVehicleID(extraid), x, y, z, a + 180, worldid, int);
        else SetPlayerPosEx(extraid, x, y, z);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have teleported %s to yourself", GetPlayerNameEx(extraid)));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s teleported you to himself", GetPlayerNameEx(playerid)));
        return ~1;
    }

    if (IsStringContainWords(text, "getvehicle") && GetPlayerAdminLevel(playerid) >= 8) {
        new vehicleid;
        if (sscanf(GetNextWordFromString(text, "getvehicle"), "d", vehicleid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} /alexa getvehicle [vehicleid]"); return ~1; }
        if (!IsValidVehicle(vehicleid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} invalid vehicleid"); return ~1; }
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetXYInFrontOfPlayer(playerid, x, y, 10);
        GetPlayerFacingAngle(playerid, a);
        SetVehiclePosEx(vehicleid, x, y, z);
        SetVehicleZAngle(vehicleid, a - 180);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}you have teleported vehicleid %d to yourself", vehicleid));
        return ~1;
    }

    if (IsStringContainWords(text, "gotovehicle") && GetPlayerAdminLevel(playerid) >= 8) {
        new vehicleid;
        if (sscanf(GetNextWordFromString(text, "gotovehicle"), "d", vehicleid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} /alexa gotovehicle [vehicleid]"); return ~1; }
        if (!IsValidVehicle(vehicleid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} invalid vehicleid"); return ~1; }
        new Float:x, Float:y, Float:z, Float:a;
        GetVehiclePos(vehicleid, x, y, z);
        GetXYInFrontOfVehicle(vehicleid, x, y, 10);
        GetVehicleZAngle(vehicleid, a);
        TeleportPlayer(playerid, x, y, z, GetVehicleVirtualWorld(vehicleid), GetVehicleInterior(vehicleid));
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}you are teleported to vehicleid %d", vehicleid));
        return ~1;
    }

    if (IsStringContainWords(text, "sethealth") && GetPlayerAdminLevel(playerid) >= 8) {
        new extraid, Float:sHealth;
        if (sscanf(GetNextWordFromString(text, "sethealth"), "u", extraid)) extraid = playerid;
        if (sscanf(GetNextWordFromString(text, "sethealth", 2), "f", sHealth)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[syntax]:{FFFFEE} /alexa sethealth playerid health");
            return ~1;
        }
        if (!IsPlayerConnected(extraid)) return 1;
        SetPlayerHealthEx(extraid, sHealth);
        if (IsPlayerFreezedForDeath(extraid)) {
            SetPlayerFreezeState(extraid, false);
            ApplyAnimation(extraid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        }
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s health to %.0f", GetPlayerNameEx(extraid), sHealth));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} Admin %s set your health to %.0f", GetPlayerNameEx(playerid), sHealth));
        return ~1;
    }

    if (IsStringContainWords(text, "setarmour") && GetPlayerAdminLevel(playerid) >= 8) {
        new extraid, Float:sArmour;
        if (sscanf(GetNextWordFromString(text, "setarmour"), "u", extraid)) extraid = playerid;
        if (sscanf(GetNextWordFromString(text, "setarmour", 2), "f", sArmour)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[syntax]:{FFFFEE} /alexa setarmour playerid armour");
            return ~1;
        }
        if (!IsPlayerConnected(extraid)) return 1;
        SetPlayerArmourEx(playerid, sArmour);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s armour to %.0f", GetPlayerNameEx(extraid), sArmour));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} Admin %s set your armour to %.0f", GetPlayerNameEx(playerid), sArmour));
        return ~1;
    }

    if (IsStringContainWords(text, "freeze") && GetPlayerAdminLevel(playerid) > 0) {
        new extraid;
        if (sscanf(GetNextWordFromString(text, "freeze"), "d", extraid)) extraid = playerid;
        if (extraid == -1) {
            foreach(new i:Player) freeze(i);
            SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]: {FFCC66}%s{FFFFEE} admin freezed all players", GetPlayerNameEx(playerid)));
            return ~1;
        }
        if (!IsPlayerConnected(extraid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Invalid PlayerID");
            return ~1;
        }
        if (IsPlayerFreezed(extraid)) {
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} %s already freezed", GetPlayerNameEx(extraid)));
            return ~1;
        }
        freeze(extraid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have freezed %s", GetPlayerNameEx(extraid)));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s freezed you", GetPlayerNameEx(playerid)));
        return ~1;
    }

    if (IsStringContainWords(text, "unfreeze") && GetPlayerAdminLevel(playerid) > 0) {
        new extraid;
        if (sscanf(GetNextWordFromString(text, "unfreeze"), "d", extraid)) extraid = playerid;
        if (extraid == -1) {
            foreach(new i:Player) unfreeze(i);
            SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]: {FFCC66}%s{FFFFEE} admin unfreezed all players", GetPlayerNameEx(playerid)));
            return ~1;
        }
        if (!IsPlayerConnected(extraid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Invalid PlayerID");
            return ~1;
        }
        if (!IsPlayerFreezed(extraid)) {
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} %s already unfreezed", GetPlayerNameEx(extraid)));
            return ~1;
        }
        unfreeze(extraid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have unfreezed %s", GetPlayerNameEx(extraid)));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s unfreezed you", GetPlayerNameEx(playerid)));
        return ~1;
    }

    if (IsStringContainWords(text, "spawn") && GetPlayerAdminLevel(playerid) >= 8) {
        new extraid = -1;
        new Vehicle[32], VehicleID, ColorOne = -1, ColorTwo = -1, string[512];
        sscanf(GetNextWordFromString(text, "spawn", 1), "s[32]", Vehicle);
        sscanf(GetNextWordFromString(text, "spawn", 2), "D(1)", ColorOne);
        sscanf(GetNextWordFromString(text, "spawn", 3), "D(1)", ColorTwo);
        if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
        if (!IsPlayerConnected(extraid)) extraid = playerid;
        if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
        else {
            new vcount = 0, ovtl[5];
            for (new d = 0; d < 212; d++) {
                if (strfind(GetVehicleModelName(d + 400), Vehicle, true) != -1 || strval(Vehicle) == d + 400) {
                    VehicleID = d + 400;
                    if (vcount < 5) ovtl[vcount] = VehicleID;
                    else {
                        GameTextForPlayer(playerid, "~w~More than ~r~5 ~r~vehicle", 1000, 3);
                        return ~1;
                    }
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
        if (VehicleID < 400 || VehicleID > 611) {
            GameTextForPlayer(playerid, "~w~Invalid Vehicle Name", 1000, 3);
            return ~1;
        }
        if (VehicleID == 611) {
            GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3);
            return ~1;
        }
        new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
        GetPlayerPos(extraid, pX, pY, pZ);
        GetPlayerFacingAngle(extraid, pAngle);
        GetXYInFrontOfPlayer(extraid, pX, pY, 3);
        vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(extraid), true);
        ResetVehicleEx(vehicleid);
        SetVehicleFuelEx(vehicleid, 99.0);
        Iter_Add(ASpawnedVeh, vehicleid);
        if (!IsPlayerInAnyVehicle(extraid)) PutPlayerInVehicleEx(extraid, vehicleid, 0);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you spawned %s for %s", GetVehicleModelName(VehicleID), GetPlayerNameEx(extraid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}This %s spawned for you by Admin %s", GetVehicleModelName(VehicleID), GetPlayerNameEx(playerid));
        SendClientMessageEx(extraid, COLOR_GREY, string);
        GameTextForPlayer(extraid, "~w~vehicle spawned", 1000, 3);
        if (!IsPlayerMasterAdmin(playerid)) SendAdminLogMessage(sprintf("Admin %s spawned %s vehicle for %s", GetPlayerNameEx(playerid), GetVehicleModelName(VehicleID), GetPlayerNameEx(extraid)));
        return ~1;
    }
    return 1;
}