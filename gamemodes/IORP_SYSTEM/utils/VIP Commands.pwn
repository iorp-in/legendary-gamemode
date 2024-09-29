new bool:VIP_FlamingHand[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    VIP_FlamingHand[playerid] = false;
    return 1;
}

new VIP_PRICE_REPAIR = 2500, VIP_PRICE_REFUEL = 2500, VIP_PRICE_SPAWN = 5000;

hook GlobalFiveMinInterval() {
    VIP_PRICE_REPAIR = RandomEx(2000, 4000);
    VIP_PRICE_REFUEL = RandomEx(2000, 4000);
    VIP_PRICE_SPAWN = RandomEx(5000, 10000);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (IsStringContainWords(text, "clean screen")) {
        clean_screen(playerid);
        GameTextForPlayer(playerid, "~r~Clean Screen Mode", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "fix screen")) {
        fix_screen(playerid);
        GameTextForPlayer(playerid, "~r~Screen Fixed", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "minigame, minigames, mini game")) {
        ShowMiniGameMenu(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "gamezone")) {
        if (GetPlayerAdminLevel(playerid) == 10) {
            new extraid;
            if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
            if (!IsPlayerConnected(extraid)) extraid = playerid;
            Event:MainMenu(extraid);
            return ~1;
        } else if (GetPlayerVIPLevel(playerid) > 0) {
            Event:MainMenu(playerid);
            return ~1;
        }
    }
    if (IsStringContainWords(text, "leave game") && Event:IsInEvent(playerid)) {
        Event:Leave(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "ult, translator")) {
        UniLangTranslator(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "faction locker")) {
        if (GetPlayerAdminLevel(playerid) == 10) {
            new extraid;
            if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
            if (!IsPlayerConnected(extraid)) extraid = playerid;
            Faction:ShowLocker(extraid, Faction:GetPlayerFID(extraid));
            return ~1;
        } else if (GetPlayerVIPLevel(playerid) > 0) {
            if (GetPlayerVIPLevel(playerid) < 2) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you required level 3+ access for this action"); return ~1; }
            if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
            Faction:ShowLocker(playerid, Faction:GetPlayerFID(playerid));
            return ~1;
        }
    }
    if (IsStringContainWords(text, "dial")) {
        new phonenumb;
        if (sscanf(GetNextWordFromString(text, "call"), "d", phonenumb)) {
            SendClientMessage(playerid, 0xFFFFFFAA, "Number not dialed.");
            return ~1;
        }
        new name[24];
        GetPlayerName(playerid, name, 24);
        strdel(numberab[playerid], 0, 4);
        foreach(new i:Player) {
            if (IsPlayerConnected(i)) {
                if (MobilePlayer[i][number] == phonenumb && phonenumb != 0 && !MobilePlayer[i][calling] && i != playerid) {
                    new string[128];
                    format(string, sizeof(string), "%d (%s) is calling you ...", MobilePlayer[playerid][number], name);
                    SendClientMessageEx(i, 0xFFFF00AA, string);
                    SendClientMessageEx(i, 0xFFFFFFFF, "Use your pocket > answer to talk and your pocket > hangup to cancel");
                    GetPlayerName(i, name, sizeof(name));
                    format(string, sizeof(string), "You are calling %d (%s) ...", phonenumb, name);
                    SendClientMessageEx(playerid, 0xFFFFFFAA, string);
                    MobilePlayer[playerid][calling] = 0;
                    MobilePlayer[playerid][caller] = i;
                    MobilePlayer[i][calling] = 2;
                    MobilePlayer[i][caller] = playerid;
                    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
                    PlayerPlaySound(i, 20804, 0.0, 0.0, 0.0);
                    TimerWaitCalling[playerid] = SetTimerEx("EndCallBecauseWait", MAX_TIME_TO_WAIT, 0, "i", playerid);
                    return ~1;
                } else SendClientMessageEx(playerid, 0xFFFFFFAA, "The dialed number does not exist or is out of coverage. Try it again later");
            }
        }
        return ~1;
    }
    if (IsStringContainWords(text, "play") && (GetPlayerAdminLevel(playerid) > 0 || GetPlayerVIPLevel(playerid) > 0)) {
        new song[128];
        sscanf(text, "s[128]", song);
        if (strreplace(song, "play ", "", false, 0, 1) == 0) strreplace(song, "play", "", false, 0, 1);
        if (isnull(song)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} what to play?");
            return ~1;
        }
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}playing {FFCC66}%s {FFFFEE}for you", song));
        PlayAudioStreamForPlayer(playerid, sprintf("https://iorp.in/music/%s", song));
        return ~1;
    }
    if (IsStringContainWords(text, "aplay") && (GetPlayerAdminLevel(playerid) > 0 || DJ:IsPlayer(playerid))) {
        new song[128];
        sscanf(text, "s[128]", song);
        if (strreplace(song, "aplay ", "", false, 0, 1) == 0) strreplace(song, "aplay", "", false, 0, 1);
        if (isnull(song)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} what to play?");
            return ~1;
        }
        foreach(new i:Player) {
            if (!DJ:GetStatusMP3(i)) continue;
            SendClientMessageEx(i, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}DJ %s playing {FFCC66}%s {FFFFEE}for you", GetPlayerNameEx(playerid), song));
            PlayAudioStreamForPlayer(i, sprintf("https://iorp.in/music/%s", song));
        }
        return ~1;
    }
    if (IsStringContainWords(text, "dj panel")) {
        DJ:OpenPanel(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "my cars, mycars")) {
        PersonalVehicle:Menu(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "ucp, pocket, my pocket, user control panel")) {
        callcmd::pocket(playerid, "");
        return ~1;
    }
    if (IsStringContainWords(text, "change skin")) {
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        ChangeSkin(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "help, commands")) {
        callcmd::help(playerid, "");
        return ~1;
    }
    if (IsStringContainWords(text, "family")) {
        Family:MyView(playerid);
        return ~1;
    }
    //    if (IsStringContainWords(text, "spray tag")) {
    //        cmd_tags(playerid);
    //        return ~1;
    //    }
    if (IsStringContainWords(text, "math")) {
        new string[128];
        sscanf(text, "s[128]", string);
        strreplace(string, "math ", "", false, 0, 1);
        Math(playerid, string, 111);
        return ~1;
    }
    if (IsStringContainWords(text, "vipspawn")) {
        // if (GetPlayerRPMode(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in fight mode"); return ~1; }
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist."); return ~1; }
        if (IsPlayerFreezed(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command while you are freezed."); return ~1; }
        if (GetPlayerVIPLevel(playerid) < 3) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you required level 3+ access for this action");
        new extraid = playerid;
        new Vehicle[32], VehicleID, ColorOne, ColorTwo, string[512];
        sscanf(GetNextWordFromString(text, "vipspawn", 1), "s[32]", Vehicle);
        sscanf(GetNextWordFromString(text, "vipspawn", 2), "D(1)", ColorOne);
        sscanf(GetNextWordFromString(text, "vipspawn", 3), "D(1)", ColorTwo);
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
        if (VehicleID < 400 || VehicleID > 611) { GameTextForPlayer(playerid, "~w~Invalid Vehicle Name", 1000, 3); return ~1; }
        new resvlist[] = { 470, 472, 435, 450, 584, 591, 606, 607, 608, 610, 611, 592, 594, 601, 596, 597, 598, 599, 582, 577, 573, 574, 571, 570, 569, 564, 563, 557, 556, 552, 553, 548, 544, 539, 537, 538, 532, 528, 530, 524, 520, 523, 519, 512, 513, 514, 515, 511, 504, 502, 503, 501, 497, 488, 586, 476, 464, 465, 460, 455, 449, 448, 443, 441, 437, 435, 432, 433, 430, 431, 427, 425, 417, 416, 408, 407, 406, 403 };
        if (IsArrayContainNumber(resvlist, VehicleID)) { GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3); return ~1; }
        if (!IsTimePassedForPlayer(playerid, "vip spawn", 10 * 60)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}you can use this command after ten minute"); return ~1; }
        if (GetPlayerCash(playerid) < VIP_PRICE_SPAWN) { SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa VIP]: {FFFFFF}you need $%s money to spawn vehicles, vip ain't that free.", FormatCurrency(VIP_PRICE_SPAWN))); return ~1; }
        // check if player is eligible to spawn requested vehicle
        new resvlist1[] = { 481, 509, 510, 448, 461, 462, 463, 468, 521, 522, 523, 581, 586 };
        if (!IsArrayContainNumber(resvlist1, VehicleID) && GetPlayerVIPLevel(playerid) == 1) { GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3); return ~1; }
        new resvlist2[] = { 481, 509, 510, 448, 461, 462, 463, 468, 521, 522, 523, 581, 586, 400, 401, 404, 405, 409, 410, 412, 413, 416, 418, 419, 420, 421, 422, 423, 424, 426, 434, 436, 438, 439, 440, 442, 445, 457, 458, 459, 466, 467, 470, 471, 474, 478, 479, 480, 482, 483, 485, 489, 490, 492, 495, 500, 504, 505, 507, 516, 517, 518, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 540, 542, 543, 545, 546, 547, 549, 550, 551, 552, 554, 555, 560, 561, 562, 566, 567, 568, 571, 572, 574, 575, 576, 579, 580, 582, 583, 585, 596, 597, 598, 599, 600, 604, 605, 609 };
        if (!IsArrayContainNumber(resvlist2, VehicleID) && GetPlayerVIPLevel(playerid) == 2) { GameTextForPlayer(playerid, "~w~This vehicle can not be spawned", 1000, 3); return ~1; }

        // spawned count in last 24 hours
        new spawnedRate = CountPlayerEvent(playerid, "VIPSPAWN", gettime() - (24 * 60 * 60));
        if (GetPlayerVIPLevel(playerid) == 3 && spawnedRate >= 20) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (GetPlayerVIPLevel(playerid) == 2 && spawnedRate >= 10) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (spawnedRate >= 5) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        }
        LogPlayerEvent(playerid, "VIPSPAWN", sprintf("spawned %s", GetVehicleModelName(VehicleID)));

        new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
        GetPlayerPos(extraid, pX, pY, pZ);
        GetPlayerFacingAngle(extraid, pAngle);
        GetXYInFrontOfPlayer(extraid, pX, pY, 3);
        vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(extraid), true);
        ResetVehicleEx(vehicleid);
        SetVehicleFuelEx(vehicleid, 10);
        Iter_Add(ASpawnedVeh, vehicleid);
        if (!IsPlayerInAnyVehicle(extraid)) PutPlayerInVehicleEx(extraid, vehicleid, 0);
        format(string, sizeof string, "{4286f4}[Alexa VIP]: {FFFFEE}you have spawned %s for $%s", GetVehicleModelName(VehicleID), FormatCurrency(VIP_PRICE_SPAWN));
        vault:PlayerVault(playerid, -1 * VIP_PRICE_SPAWN, sprintf("spawned %s using vipspawn", GetVehicleModelName(VehicleID)), Vault_ID_Government, VIP_PRICE_SPAWN, sprintf("%s spawned %s using vipspawn", GetPlayerNameEx(playerid), GetVehicleModelName(VehicleID)));
        SendClientMessageEx(playerid, COLOR_GREY, string);
        GameTextForPlayer(extraid, "~w~vehicle spawned", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "viprefuel")) {
        // if (GetPlayerRPMode(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in fight mode"); return ~1; }
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        if (!IsPlayerInAnyVehicle(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFEE}This VIP command can only be accessed in vehicle"); return ~1; }
        if (GetPlayerCash(playerid) < VIP_PRICE_REFUEL) { SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}you don't have enough money ($%s) to use this command", FormatCurrency(VIP_PRICE_REFUEL))); return ~1; }
        // refuel count in last 24 hours
        new refuelRate = CountPlayerEvent(playerid, "VIPREFUEL", gettime() - (24 * 60 * 60));
        if (GetPlayerVIPLevel(playerid) == 3 && refuelRate >= 20) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (GetPlayerVIPLevel(playerid) == 2 && refuelRate >= 10) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (refuelRate >= 5) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        }
        LogPlayerEvent(playerid, "VIPREFUEL", sprintf("refueled %s", GetVehicleName(GetPlayerVehicleID(playerid))));

        vault:PlayerVault(playerid, -VIP_PRICE_REFUEL, sprintf("refueled %s using viprefuel", GetVehicleName(GetPlayerVehicleID(playerid))), Vault_ID_Government, VIP_PRICE_REFUEL, sprintf("%s refueled %s using viprefuel", GetPlayerNameEx(playerid), GetVehicleName(GetPlayerVehicleID(playerid))));
        SetVehicleFuelEx(GetPlayerVehicleID(playerid), 99);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}you have refueld %s for $%s", GetVehicleName(GetPlayerVehicleID(playerid)), FormatCurrency(VIP_PRICE_REFUEL)));
        return ~1;
    }
    if (IsStringContainWords(text, "viprepair")) {
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        // if (GetPlayerRPMode(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in fight mode"); return ~1; }
        if (!IsPlayerInAnyVehicle(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFEE}This VIP command can only be accessed in vehicle"); return ~1; }
        new vehicleid = GetPlayerVehicleID(playerid);
        if (!IsValidVehicle(vehicleid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFEE}Can not use this command at the movement, try again"); return ~1; }
        if (GetPlayerCash(playerid) < VIP_PRICE_REPAIR) { SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}you don't have enough money ($%s) to use this command", FormatCurrency(VIP_PRICE_REPAIR))); return ~1; }
        // refuel count in last 24 hours
        new refuelRate = CountPlayerEvent(playerid, "VIPREPAIR", gettime() - (24 * 60 * 60));
        if (GetPlayerVIPLevel(playerid) == 3 && refuelRate >= 20) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (GetPlayerVIPLevel(playerid) == 2 && refuelRate >= 10) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        } else if (refuelRate >= 5) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFFF}your 24 hour limit is reached, please try again later.");
            return ~1;
        }
        LogPlayerEvent(playerid, "VIPREPAIR", sprintf("repaired %s", GetVehicleName(vehicleid)));

        vault:PlayerVault(playerid, -VIP_PRICE_REPAIR, sprintf("repaired %s using viprepair", GetVehicleName(vehicleid)), Vault_ID_Government, VIP_PRICE_REPAIR, sprintf("%s repaired %s using viprepair", GetPlayerNameEx(playerid), GetVehicleName(vehicleid)));
        ResetVehicleEx(vehicleid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}you have repaired %s for $%s", GetVehicleName(GetPlayerVehicleID(playerid)), FormatCurrency(VIP_PRICE_REPAIR)));
        return ~1;
    }
    if (IsStringContainWords(text, "vipmod")) {
        // if (GetPlayerRPMode(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in fight mode"); return ~1; }
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        if (GetPlayerVIPLevel(playerid) < 3) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you required level 3+ access for this action");
        if (!IsPlayerInAnyVehicle(playerid)) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFEE}This VIP command can only be accessed in vehicle");
            return ~1;
        }
        ModShop:ShowModMenu(playerid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}vehicle modification shop for %s", GetVehicleName(GetPlayerVehicleID(playerid))));
        return ~1;
    }
    if (IsStringContainWords(text, "vipweather")) {
        new weatherid;
        if (sscanf(GetNextWordFromString(text, "vipweather"), "d", weatherid)) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa VIP]: {FFFFEE}Provide weather ID: 1-45");
            return ~1;
        }
        if (weatherid < 0 || weatherid > 45) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa VIP]: {FFFFEE}Invalid provided weather ID: 1-45");
            return ~1;
        }
        SetPlayerWeather(playerid, weatherid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa VIP]: {FFFFEE}your weather is set to: %d", weatherid));
        return ~1;
    }
    if (IsStringContainWords(text, "vipflamminghand")) {
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        if (!VIP_FlamingHand[playerid]) {
            VIP_FlamingHand[playerid] = true;
            SetPlayerAttachedObject(playerid, 6, 18693, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
            SetPlayerAttachedObject(playerid, 7, 18693, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
            SetPlayerAttachedObject(playerid, 8, 18703, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
            SetPlayerAttachedObject(playerid, 9, 18703, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa VIP]: {FFFFEE}flaming hands enabled for you");
        } else {
            VIP_FlamingHand[playerid] = false;
            for (new i = 6; i < 10; i++) {
                if (IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
            }
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa VIP]: {FFFFEE}flaming hands disabled for you");
        }
        return ~1;
    }
    if (IsStringContainWords(text, "vipghostrider")) {
        if (IsPlayerInHeist(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}you can't use this command in heist"); return ~1; }
        EnableGhostRider(playerid);
        return ~1;
    }
    return 1;
}

hook OnMathResponse(playerid, const response[], offset) {
    if (offset != 111) return 1;
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}%s", response));
    return 1;
}

hook OnTranslateResponse(playerid, const response[], offset) {
    if (offset != 111) return 1;
    new output[144], res[144];
    format(output, sizeof output, "%s", response);
    strurldecode(res, output);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}%s", res));
    return 1;
}

VCP:OnInit(playerid, page) {
    VCP:AddCommand(playerid, "All VIP Alexa Commands");
    VCP:AddCommand(playerid, "All VIP Commands");
    return 1;
}

VCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (!strcmp(inputtext, "All VIP Alexa Commands")) return Alexa_VipCommands(playerid);
    if (!strcmp(inputtext, "All VIP Commands")) return VipCommands(playerid);
    return 1;
}

stock VipCommands(playerid) {
    new string[2000];
    strcat(string, "{db6600}General Commands: {FFFFEE}/vsay, /vchat, /findbackpack\n");
    FlexPlayerDialog(playerid, "VipCommands", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]:{FFFFEE}VIP Control", string, "Okay", "");
    return 1;
}

stock Alexa_VipCommands(playerid) {
    new string[2000];
    strcat(string, "{db6600}General Commands: {FFFFEE}vipweather, vipflamminghand, vipghostrider, viphouseint\n");
    strcat(string, "{db6600}Vehicle Control: {FFFFEE}vipspawn, viprepair, viprefuel, vipmod, turn lights, open/close bonnet, open/close boot, lock/unlock doors, start/stop engine, turn on/of alarm, open/close windows\n");
    strcat(string, "{db6600}License System: {FFFFEE}license\n");
    strcat(string, "{db6600}DJ Panel: {FFFFEE}enable/disable/start/stop mp3/tts, start/stop mp3, play, dj panel\n");
    strcat(string, "{db6600}Faction System: {FFFFEE}faction locker, factions\n");
    strcat(string, "{db6600}Screen Control: {FFFFEE}clean/fix screen\n");
    strcat(string, "{db6600}Minigame System: {FFFFEE}minigame, minigames, mini game\n");
    strcat(string, "{db6600}Universal Language Translator: {FFFFEE}ult, translator\n");
    strcat(string, "{db6600}General Commands: {FFFFEE}phone, tablet, answer call, pickup call, end call, hangup call, my number, dial\n");
    strcat(string, "{db6600}Personal Vehicles: {FFFFEE}my cars, mycars\n");
    strcat(string, "{db6600}Control Panels: {FFFFEE}pocket, scp, change skin, change password\n");
    strcat(string, "{db6600}Patch System: {FFFFEE}patch status\n");
    FlexPlayerDialog(playerid, "VipCommands", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]:{FFFFEE}VIP Control", string, "Okay", "");
    return 1;
}

CMD:vsay(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (isnull(params)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa VIP]: {FFFFEE}what to send?");
        return ~1;
    }
    SendClientMessageToAll(-1, sprintf("{bc0000}[VIP]: {e0000e}%s (%s)", FormatMention(params), GetPlayerNameEx(playerid)));
    return 1;
}

cmd:vchat(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    if (isnull(params)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa VIP]:{FFFFEE}what to send?");
        return 1;
    }
    foreach(new i:Player) if (GetPlayerVIPLevel(i) > 0) SendClientMessageEx(i, -1, sprintf("{4286f4}[VIP Chat] %s: {FFFFFF}%s", GetPlayerNameEx(playerid), FormatMention(params)));
    return 1;
}

// stock GiveVIP2xCash(playerid, cash, const log[]) {
//     if(GetPlayerVIPLevel(playerid) > 0) {
//         GivePlayerCash(playerid, 2 * cash, sprintf("VIP 2x: %s", log));
//         GameTextForPlayer(playerid, "2x money recieved", 3000, 3);
//     } else GivePlayerCash(playerid, cash, log);
//     return 1;
// }

stock Show2xVIPEarn(playerid) {
    GameTextForPlayer(playerid, "2x money recieved", 3000, 3);
    return 1;
}