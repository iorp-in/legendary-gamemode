#define AllPlayer:%0 AlPA@
new AllPlayer:dialogid;
enum {
    AllPlayer:OffsetWeather,
    AllPlayer:OffsetTelVehByID,
    AllPlayer:OffsetTelUsCord,
    AllPlayer:OffsetGiWeAlPl,
    AllPlayer:OffsetGiveVehtoAll,
    AllPlayer:OffsetStAlPlHlt,
    AllPlayer:OffsetStAlPlArm,
    AllPlayer:OffsetStAlPlSkin,
    AllPlayer:OffsetStAlPlWnLvl
}

hook OnGameModeInit() {
    AllPlayer:dialogid = Dialog:GetFreeID();
    return 1;
}

ACP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ACP:AddCommand(playerid, "Respawn all vehicles");
    ACP:AddCommand(playerid, "Change weather");
    ACP:AddCommand(playerid, "Clear global chat");
    ACP:AddCommand(playerid, "Teleport to vehicle by ID");
    ACP:AddCommand(playerid, "Teleport to coordinates");
    ACP:AddCommand(playerid, "Give weapon to all players");
    ACP:AddCommand(playerid, "Disarm all players");
    ACP:AddCommand(playerid, "Sign off all faction members");
    ACP:AddCommand(playerid, "Give vehicle to all players");
    ACP:AddCommand(playerid, "Bring all players");
    ACP:AddCommand(playerid, "Freeze all players");
    ACP:AddCommand(playerid, "Unfreeze all players");
    ACP:AddCommand(playerid, "Set health for all players");
    ACP:AddCommand(playerid, "Set armour for all players");
    ACP:AddCommand(playerid, "Make all players invisible");
    ACP:AddCommand(playerid, "Make all players visible");

    if (GetPlayerAdminLevel(playerid) == 3) {
        ACP:AddCommand(playerid, "Set wanted level for all players");
        ACP:AddCommand(playerid, "Clear wanted level for all players");
        ACP:AddCommand(playerid, "Set skin for all players");
        ACP:AddCommand(playerid, "Kick all players");
    }

    if (IsPlayerMasterAdmin(playerid)) ACP:AddCommand(playerid, "Restart server");
    return 1;
}

ACP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (page != 0) return 1;
    if (!strcmp("Respawn all vehicles", inputtext)) {
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFCC66}%s{FFFFEE} Admin %s requested for respawn all unoccupied Vehicle's", GetPlayerNameEx(playerid)));
        respawnunoccupiedvehicle(true);
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Change weather", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetWeather, DIALOG_STYLE_INPUT, "Change server weather", "Enter Weather ID\nLimit:0 - 45", "Update", "Cancel");
        return ~1;
    }
    if (!strcmp("Clear global chat", inputtext)) {
        for (new i = 0; i < 100; i++) SendClientMessageToAll(COLOR_WHITE, " ");
        SendClientMessageToAll(COLOR_YELLOW, "Global Chat has been reset");
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}You have reset global chat");
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Restart server", inputtext)) {
        SendClientMessageToAll(-1, "{4286f4}[Alexa]:{FFFFEE}Server Restarting...");
        HardRebootServer();
        return ~1;
    }
    if (!strcmp("Teleport to vehicle by ID", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetTelVehByID, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter VehicleID", "Teleport", "Close");
        return ~1;
    }
    if (!strcmp("Teleport to coordinates", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetTelUsCord, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [X] [Y] [Z]", "Teleport", "Close");
        return ~1;
    }
    if (!strcmp("Give weapon to all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiWeAlPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponId] [Ammo]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Disarm all players", inputtext)) {
        foreach(new i:Player) ResetPlayerWeaponsEx(i);
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players are disarmed by admin %s", GetPlayerNameEx(playerid)));
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Sign off all faction members", inputtext)) {
        foreach(new i:Player) {
            if (Faction:IsPlayerSigned(i)) Faction:SignOff(i);
        }
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players are signed out by admin %s", GetPlayerNameEx(playerid)));
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Give vehicle to all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiveVehtoAll, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Vehiclename/Vehicleid] [Color 1] [Color 2]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Bring all players", inputtext)) {
        new Float:x, Float:y, Float:z, int, worldid;
        int = GetPlayerInterior(playerid);
        worldid = GetPlayerVirtualWorld(playerid);
        GetPlayerPos(playerid, x, y, z);
        foreach(new i:Player) SetPlayerVirtualWorldEx(i, worldid), SetPlayerInteriorEx(i, int), SetPlayerPosEx(i, x + random(5), y + random(5), z + 1);
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s teleported all players to his location", GetPlayerNameEx(playerid)));
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Freeze all players", inputtext)) {
        foreach(new i:Player) freeze(i);
        SendClientMessageToAll(COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s freezed all players", GetPlayerNameEx(playerid)));
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Unfreeze all players", inputtext)) {
        foreach(new i:Player) unfreeze(i);
        SendClientMessageToAll(COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s unfreezed all players", GetPlayerNameEx(playerid)));
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Set health for all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlHlt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Set armour for all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Make all players invisible", inputtext)) {
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players invisible mode a has been activated by admin %s", GetPlayerNameEx(playerid)));
        foreach(new i:Player) InvisibleAuth:SetPlayer(i, true);
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Make all players visible", inputtext)) {
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players invisible mode a has been deactivated by admin %s", GetPlayerNameEx(playerid)));
        foreach(new i:Player) InvisibleAuth:SetPlayer(i, false);
        ACP:Init(playerid, page);
        return ~1;
    }
    if (!strcmp("Set skin for all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Set wanted level for all players", inputtext)) {
        ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlWnLvl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Wantedlevel] [Reason]", "Submit", "Close");
        return ~1;
    }
    if (!strcmp("Clear wanted level for all players", inputtext)) {
        foreach(new i:Player) WantedDatabase:ResetWantedLevel(i, sprintf("admin %s reseted this record", GetPlayerNameEx(playerid)));
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players wanted level has been reset by admin %s", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Kick all players", inputtext)) {
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s kicked all players", GetPlayerNameEx(playerid)));
        SetTimerEx("kickall", 1000, false, "i", playerid);
        ACP:Init(playerid, page);
        return ~1;
    }
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != AllPlayer:dialogid) return 1;
    if (offsetid == AllPlayer:OffsetWeather) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new weatherid;
        if (sscanf(inputtext, "i", weatherid)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetWeather, DIALOG_STYLE_INPUT, "Change server weather", "Enter Weather ID\nLimit:0 - 45", "Update", "Cancel"); return ~1; }
        if (weatherid < 0 || weatherid > 45) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetWeather, DIALOG_STYLE_INPUT, "Change server weather", "Enter Weather ID\nLimit:0 - 45", "Update", "Cancel"); return ~1; }
        SetWeather(weatherid);
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetTelVehByID) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new vehicleid, Float:pX, Float:pY, Float:pZ;
        if (sscanf(inputtext, "i", vehicleid)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetTelVehByID, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter VehicleID", "Teleport", "Close"); return ~1; }
        if (!IsValidVehicle(vehicleid)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetTelVehByID, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter VehicleID", "Teleport", "Close"); return ~1; }
        GetVehiclePos(vehicleid, pX, pY, pZ);
        SetPlayerPosEx(playerid, pX + 1, pY + 1, pZ + 1);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}teleported to vehicleid %d", vehicleid));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetTelUsCord) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new Float:x, Float:y, Float:z;
        if (sscanf(inputtext, "p<,>fff", x, y, z)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetTelUsCord, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [X] [Y] [Z]", "Teleport", "Close"); return ~1; }
        if (IsPlayerInAnyVehicle(playerid)) SetVehiclePosEx(GetPlayerVehicleID(playerid), x, y, z);
        else SetPlayerPosEx(playerid, x, y, z);
        SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE}Teleport to coordinates");
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetGiWeAlPl) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new WeaponId, ammo;
        if (sscanf(inputtext, "ii", WeaponId, ammo)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiWeAlPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponId] [Ammo]", "Submit", "Close"); return ~1; }
        if (WeaponId < 1 || WeaponId == 19 || WeaponId == 20 || WeaponId == 21 || WeaponId == 38 || WeaponId > 46) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiWeAlPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponId] [Ammo]", "Submit", "Close"); return ~1; }
        if (ammo < 0 || ammo > 1000) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiWeAlPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponId] [Ammo]", "Submit", "Close"); return ~1; }
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Maximum Ammo limit is 1000");
        foreach(new i:Player) GivePlayerWeaponEx(i, WeaponId, ammo);
        SendClientMessageToAll(COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s gived all player weapon %d with ammo %d", GetPlayerNameEx(playerid), WeaponId, ammo));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetGiveVehtoAll) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
        new Vehicle[32], VehicleID, ColorOne, ColorTwo;
        if (sscanf(inputtext, "s[32]D(1)D(1)", Vehicle, ColorOne, ColorTwo)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetGiveVehtoAll, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Vehiclename/Vehicleid] [Color 1] [Color 2]", "Submit", "Close"); return ~1; }
        if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
        else {
            new vcount = 0, ovtl[5];
            for (new d = 0; d < 212; d++) {
                if (strfind(GetVehicleModelName(d + 400), Vehicle, true) != -1 || strval(Vehicle) == d + 400) {
                    VehicleID = d + 400;
                    if (vcount < 5) ovtl[vcount] = VehicleID;
                    else { SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}More than 5 results with that name were found."); return ~1; }
                    vcount++;
                }
            }
            if (vcount > 1) {
                for (new e = 0; e < vcount; e++) {
                    if (e == 0) SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}we got many vehicles with this name, here's the list..");
                    SendClientMessageEx(playerid, -1, sprintf(" %s [Model - %d]", GetVehicleModelName(ovtl[e]), ovtl[e]));
                }
                return ~1;
            }
        }
        if (VehicleID < 400 || VehicleID > 611) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFFF}You entered an invalid vehiclename!");
            return ~1;
        }
        if (VehicleID == 611) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFFF}This vehicle can not be spawned!!");
            return ~1;
        }

        foreach(new i:Player) {
            GetPlayerPos(i, pX, pY, pZ);
            GetPlayerFacingAngle(i, pAngle);
            GetXYInFrontOfPlayer(i, pX, pY, 3);
            vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(i), GetPlayerInterior(i), true);
            ResetVehicleEx(vehicleid);
            Iter_Add(ASpawnedVeh, vehicleid);
            PutPlayerInVehicleEx(i, vehicleid, 0);
        }
        SendClientMessageToAll(COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s spawned %s for all player", GetPlayerNameEx(playerid), GetVehicleModelName(VehicleID)));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetStAlPlHlt) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new Float:health;
        if (sscanf(inputtext, "f", health)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlHlt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close"); return ~1; }
        if (health < 0 || health > 100) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlHlt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close"); return ~1; }
        foreach(new i:Player) SetPlayerHealthEx(i, health);
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players health set to %0.0f by Admin %s", health, GetPlayerNameEx(playerid)));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetStAlPlArm) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new Float:armour;
        if (sscanf(inputtext, "f", armour)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close"); return ~1; }
        if (armour < 0 || armour > 100) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close"); return ~1; }
        foreach(new i:Player) SetPlayerArmourEx(i, armour);
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players armour set to %0.0f by Admin %s", armour, GetPlayerNameEx(playerid)));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetStAlPlSkin) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new skinid;
        if (sscanf(inputtext, "i", skinid)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close"); return ~1; }
        if (skinid < 0 || skinid > 299) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE}Invalid [SkinID]");
            return ~1;
        }
        foreach(new i:Player) SetPlayerSkinEx(i, skinid);
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}All Players skin reset by Admin %s", GetPlayerNameEx(playerid)));
        ACP:Init(playerid);
        return ~1;
    }
    if (offsetid == AllPlayer:OffsetStAlPlWnLvl) {
        if (!response) { ACP:Init(playerid); return ~1; }
        new level, reason[512], string[512];
        if (sscanf(inputtext, "is[512]", level, reason)) { ShowPlayerDialogEx(playerid, AllPlayer:dialogid, AllPlayer:OffsetStAlPlWnLvl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Wantedlevel] [Reason]", "Submit", "Close"); return ~1; }
        if (level > 6 || level < 0) { SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Maximum wanted level limit is 6"); return ~1; }
        foreach(new i:Player) SetPlayerWantedLevelEx(i, level);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}Admin %s Set wanted level for all players %d for %s", GetPlayerNameEx(playerid), level, reason);
        SendClientMessageToAll(COLOR_GREY, string);
        ACP:Init(playerid);
        return ~1;
    }
    return ~1;
}