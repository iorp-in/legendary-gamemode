new Iterator:StaticVehicles < MAX_VEHICLES > ;
#define MAXTRAILERITEMS 698
enum StaticVehicle:DataEnum {
    VID,
    Float:spawn_X,
    Float:spawn_Y,
    Float:spawn_Z,
    Float:ez_angle,
    ecolor1,
    ecolor2,
    erespawn_delay,
    addsiren,
    static_vvm,
    static_int,
    factionID,
    SpawnedID,
    Float:sFuel,
    StaticVehicle:Storage[MAXTRAILERITEMS]
}
new StaticVehicle:Data[MAX_VEHICLES][StaticVehicle:DataEnum];

#include "IORP_SYSTEM/systems/v20/Dynamic Trailer Storage v2.pwn"
#include <YSI_Coding\y_hooks>

forward StaticVehiclesOnLoad();
public StaticVehiclesOnLoad() {
    new rows = cache_num_rows();
    if (rows) {
        new staticID, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", staticID);
            cache_get_value_name_int(loaded, "VID", StaticVehicle:Data[staticID][VID]);
            cache_get_value_name_float(loaded, "spawn_X", StaticVehicle:Data[staticID][spawn_X]);
            cache_get_value_name_float(loaded, "spawn_Y", StaticVehicle:Data[staticID][spawn_Y]);
            cache_get_value_name_float(loaded, "spawn_Z", StaticVehicle:Data[staticID][spawn_Z]);
            cache_get_value_name_float(loaded, "z_angle", StaticVehicle:Data[staticID][ez_angle]);
            cache_get_value_name_int(loaded, "color1", StaticVehicle:Data[staticID][ecolor1]);
            cache_get_value_name_int(loaded, "color2", StaticVehicle:Data[staticID][ecolor2]);
            cache_get_value_name_int(loaded, "respawn_delay", StaticVehicle:Data[staticID][erespawn_delay]);
            cache_get_value_name_int(loaded, "addsiren", StaticVehicle:Data[staticID][addsiren]);
            cache_get_value_name_int(loaded, "factionID", StaticVehicle:Data[staticID][factionID]);
            cache_get_value_name_int(loaded, "interior", StaticVehicle:Data[staticID][static_int]);
            cache_get_value_name_int(loaded, "virtualworld", StaticVehicle:Data[staticID][static_vvm]);

            for (new i; i < MAXTRAILERITEMS; i++) cache_get_value_name_int(
                loaded, TrailerStorage:Data[i][TrailerStorage:Name], StaticVehicle:Data[staticID][StaticVehicle:Storage][i]
            );

            StaticVehicle:Data[staticID][SpawnedID] = CreateVehicle(StaticVehicle:Data[staticID][VID], StaticVehicle:Data[staticID][spawn_X], StaticVehicle:Data[staticID][spawn_Y], StaticVehicle:Data[staticID][spawn_Z], StaticVehicle:Data[staticID][ez_angle], StaticVehicle:Data[staticID][ecolor1], StaticVehicle:Data[staticID][ecolor2], StaticVehicle:Data[staticID][erespawn_delay], StaticVehicle:Data[staticID][addsiren], StaticVehicle:Data[staticID][static_vvm], StaticVehicle:Data[staticID][static_int], true);
            StaticVehicle:Data[staticID][sFuel] = 20.0;
            Iter_Add(StaticVehicles, staticID);
            loaded++;
        }
    }
    printf("  [Static Vehicle System] Loaded %d Static Vehicle's.", rows);
    return 1;
}

new lastUpdateTime = 0;

hook GlobalOneMinuteInterval() {
    if (gettime() - lastUpdateTime < 5 * 60) return 1;
    lastUpdateTime = gettime();
    foreach(new staticid:StaticVehicles) {
        new vehicleid = StaticVehicle:GetVehicleID(staticid);
        if (!IsVehicleAllowedForStorage(vehicleid)) continue;
        StaticVehicle:UpdateTrailerDB(staticid);
    }
    return 1;
}

hook OnGameModeInit() {
    lastUpdateTime = gettime();
    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `staticVehicles` (\
	  `ID` int(11) NOT NULL,\
	  `VID` int(11) NOT NULL,\
	  `spawn_X` float NOT NULL,\
	  `spawn_Y` float NOT NULL,\
	  `spawn_Z` float NOT NULL,\
	  `z_angle` float NOT NULL,\
	  `color1` int(11) NOT NULL,\
	  `color2` int(11) NOT NULL,\
	  `respawn_delay` int(11) NOT NULL,\
	  `addsiren` int(11) NOT NULL,");
    strcat(query, "`factionID` int(11) NOT NULL default '-1',\
	  `interior` int(11) NOT NULL default '0',\
	  `virtualworld` int(11) NOT NULL default '0',\
	PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "select * from staticVehicles", "StaticVehiclesOnLoad", "");
    return 1;
}

stock StaticVehicle:GetIDbyPlayerID(playerid) {
    new vId = GetPlayerVehicleID(playerid);
    return StaticVehicle:GetID(vId);
}

stock StaticVehicle:IsValidID(id) {
    return Iter_Contains(StaticVehicles, id);
}

stock StaticVehicle:GetVehicleID(staticID) {
    return StaticVehicle:Data[staticID][SpawnedID];
}

stock StaticVehicle:GetID(vehicleid) {
    foreach(new i:StaticVehicles) {
        if (StaticVehicle:Data[i][SpawnedID] == vehicleid) {
            return i;
        }
    }
    return -1;
}

stock StaticVehicle:IsStatic(vehicleid) {
    return StaticVehicle:IsValidID(StaticVehicle:GetVehicleID(vehicleid));
}

stock StaticVehicle:GetFactionID(staticID) {
    if (!StaticVehicle:IsValidID(staticID)) return -1;
    return StaticVehicle:Data[staticID][factionID];
}

forward StaticVehicleUpdate(staticID);
public StaticVehicleUpdate(staticID) {
    if (!Iter_Contains(StaticVehicles, staticID)) return 0;
    if (!IsValidVehicle(StaticVehicle:Data[staticID][SpawnedID])) return 0;
    new vehicleid = StaticVehicle:Data[staticID][SpawnedID];
    GetVehicleColor(vehicleid, StaticVehicle:Data[staticID][ecolor1], StaticVehicle:Data[staticID][ecolor2]);
    GetVehiclePos(vehicleid, StaticVehicle:Data[staticID][spawn_X], StaticVehicle:Data[staticID][spawn_Y], StaticVehicle:Data[staticID][spawn_Z]);
    GetVehicleZAngle(vehicleid, StaticVehicle:Data[staticID][ez_angle]);
    StaticVehicle:Data[staticID][static_vvm] = GetVehicleVirtualWorld(vehicleid);
    StaticVehicle:Data[staticID][static_int] = GetVehicleInterior(vehicleid);
    if (IsValidVehicle(StaticVehicle:Data[staticID][SpawnedID])) DestroyVehicle(StaticVehicle:Data[staticID][SpawnedID]);
    StaticVehicle:Data[staticID][SpawnedID] = CreateVehicle(StaticVehicle:Data[staticID][VID], StaticVehicle:Data[staticID][spawn_X], StaticVehicle:Data[staticID][spawn_Y], StaticVehicle:Data[staticID][spawn_Z], StaticVehicle:Data[staticID][ez_angle], StaticVehicle:Data[staticID][ecolor1], StaticVehicle:Data[staticID][ecolor2], StaticVehicle:Data[staticID][erespawn_delay], StaticVehicle:Data[staticID][addsiren], StaticVehicle:Data[staticID][static_vvm], StaticVehicle:Data[staticID][static_int], true);
    mysql_tquery(Database, sprintf(
        "UPDATE `staticVehicles` SET `spawn_X` = \"%f\", `spawn_Y` = \"%f\", `spawn_Z` = \"%f\", `z_angle` = \"%f\", `color1` = \"%d\", `color2` = \"%d\",\
        `respawn_delay` = \"%d\", `addsiren` = \"%d\", `virtualworld` = \"%d\", `interior` = \"%d\", `factionID` = \"%d\" WHERE `ID` = \"%d\"",
        StaticVehicle:Data[staticID][spawn_X], StaticVehicle:Data[staticID][spawn_Y], StaticVehicle:Data[staticID][spawn_Z],
        StaticVehicle:Data[staticID][ez_angle], StaticVehicle:Data[staticID][ecolor1], StaticVehicle:Data[staticID][ecolor2],
        StaticVehicle:Data[staticID][erespawn_delay], StaticVehicle:Data[staticID][addsiren], StaticVehicle:Data[staticID][static_vvm],
        StaticVehicle:Data[staticID][static_int], StaticVehicle:Data[staticID][factionID], staticID
    ));
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_DRIVER) {
        new fId = StaticVehicle:GetFactionID(StaticVehicle:GetIDbyPlayerID(playerid));
        if (fId != Faction:GetPlayerFID(playerid) && fId != -1) {
            if (GetPlayerAdminLevel(playerid) < 8) RemovePlayerFromVehicle(playerid);
            new Message[512];
            format(Message, sizeof(Message), "{4286f4}[%s]:{e9967a} you are not authorize to access this vehicle", Faction:GetName(fId));
            return SendClientMessageEx(playerid, -1, Message);
        }
        if (fId == Faction:GetPlayerFID(playerid) && !Faction:IsPlayerSigned(playerid) && fId != -1) {
            if (GetPlayerAdminLevel(playerid) < 8) RemovePlayerFromVehicle(playerid);
            new Message[512];
            format(Message, sizeof(Message), "{4286f4}[%s]:{e9967a}You need to sign in to access the vehicle", Faction:GetName(fId));
            return SendClientMessageEx(playerid, -1, Message);
        }
    }
    return 1;
}

forward DestroyVehicleEx(vehicleid);
public DestroyVehicleEx(vehicleid) {
    DestroyVehicle(vehicleid);
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Static Vehicle System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Static Vehicle System", inputtext)) StaticVehicle:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "static vehicle system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    StaticVehicle:AdminPanel(playerid);
    return ~1;
}

// Fixed Fuel storing for static vehicles

hook OnVehicleSpawn(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 1;
    new sID = StaticVehicle:GetID(vehicleid);
    if (sID == -1) return 1;
    SetVehicleFuelEx(vehicleid, StaticVehicle:Data[sID][sFuel]);
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    new sID = StaticVehicle:GetID(vehicleid);
    if (sID == -1) return 1;
    StaticVehicle:Data[sID][sFuel] = GetVehicleFuelEx(vehicleid);
    return 1;
}

stock StaticVehicle:Create(playerid, modelid, color1 = -1, color2 = -1, respawnDelay = 1800, siren = 0, factionid = -1) {
    new staticID = Iter_Free(StaticVehicles);
    if (staticID == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "Vehicle slot exceed", "Error");
    new Float:Pos[4], Float:NewPos[4];
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
        GetVehicleZAngle(vehicleid, Pos[3]);

        // tp player
        GetVehiclePos(vehicleid, NewPos[0], NewPos[1], NewPos[2]);
        GetVehicleZAngle(vehicleid, NewPos[3]);
        GetXYInFrontOfVehicle(GetPlayerVehicleID(playerid), NewPos[1], NewPos[2], 10.0);
        SetVehicleZAngle(vehicleid, NewPos[3] - 180);
        SetVehiclePosEx(vehicleid, NewPos[0], NewPos[1], NewPos[2]);
    } else {
        GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
        GetPlayerFacingAngle(playerid, Pos[3]);

        // tp player
        GetPlayerPos(playerid, NewPos[0], NewPos[1], NewPos[2]);
        GetPlayerFacingAngle(playerid, NewPos[3]);
        GetXYInFrontOfPlayer(playerid, NewPos[1], NewPos[2], 10.0);
        SetPlayerPosEx(playerid, NewPos[0], NewPos[1], NewPos[2]);
        SetPlayerFacingAngle(playerid, NewPos[3] - 180);
    }
    StaticVehicle:Data[staticID][VID] = modelid;
    StaticVehicle:Data[staticID][spawn_X] = Pos[0];
    StaticVehicle:Data[staticID][spawn_Y] = Pos[1];
    StaticVehicle:Data[staticID][spawn_Z] = Pos[2];
    StaticVehicle:Data[staticID][ez_angle] = Pos[3];
    StaticVehicle:Data[staticID][ecolor1] = color1;
    StaticVehicle:Data[staticID][ecolor2] = color2;
    StaticVehicle:Data[staticID][erespawn_delay] = respawnDelay;
    StaticVehicle:Data[staticID][addsiren] = siren;
    StaticVehicle:Data[staticID][factionID] = factionid;
    StaticVehicle:Data[staticID][static_int] = GetPlayerInterior(playerid);
    StaticVehicle:Data[staticID][static_vvm] = GetPlayerVirtualWorld(playerid);

    StaticVehicle:Data[staticID][sFuel] = 40.0;
    Iter_Add(StaticVehicles, staticID);
    mysql_tquery(Database, sprintf(
        "INSERT INTO `staticVehicles`(`ID`, `VID`, `spawn_X`, `spawn_Y`, `spawn_Z`, `z_angle`, `color1`, `color2`, \
        `respawn_delay`, `addsiren`, `factionID`, `virtualworld`, `interior`) VALUES ('%d','%d','%f','%f','%f','%f','%d','%d','%d','%d','%d','%d','%d')",
        staticID, modelid, Pos[0], Pos[1], Pos[2], Pos[3], color1, color2, respawnDelay, siren, factionid, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)
    ));
    StaticVehicle:Data[staticID][SpawnedID] = CreateVehicle(
        StaticVehicle:Data[staticID][VID], StaticVehicle:Data[staticID][spawn_X], StaticVehicle:Data[staticID][spawn_Y], StaticVehicle:Data[staticID][spawn_Z],
        StaticVehicle:Data[staticID][ez_angle], StaticVehicle:Data[staticID][ecolor1], StaticVehicle:Data[staticID][ecolor2],
        StaticVehicle:Data[staticID][erespawn_delay], StaticVehicle:Data[staticID][addsiren], StaticVehicle:Data[staticID][static_vvm],
        StaticVehicle:Data[staticID][static_int], true
    );
    AlexaMsg(playerid, sprintf("Added Static Vehicle ID {FFCC66}%d", staticID));
    return 1;
}

stock StaticVehicle:RemoveAllPlayer(staticID) {
    new vehicleid = StaticVehicle:Data[staticID][SpawnedID];
    foreach(new playerid:Player) {
        if (GetPlayerVehicleID(playerid) == vehicleid) RemovePlayerFromVehicle(playerid);
    }
    return 1;
}

stock StaticVehicle:Remove(staticID) {
    SetPreciseTimer("DestroyVehicleEx", 3000, false, "d", StaticVehicle:Data[staticID][SpawnedID]);
    StaticVehicle:Data[staticID][SpawnedID] = -1;
    StaticVehicle:Data[staticID][VID] = -1;
    StaticVehicle:Data[staticID][spawn_X] = -1;
    StaticVehicle:Data[staticID][spawn_X] = -1;
    StaticVehicle:Data[staticID][spawn_Z] = -1;
    StaticVehicle:Data[staticID][ez_angle] = -1;
    StaticVehicle:Data[staticID][ecolor1] = -1;
    StaticVehicle:Data[staticID][ecolor2] = -1;
    StaticVehicle:Data[staticID][erespawn_delay] = -1;
    StaticVehicle:Data[staticID][addsiren] = -1;
    StaticVehicle:Data[staticID][factionID] = -1;
    StaticVehicle:Data[staticID][static_vvm] = -1;
    Iter_Remove(StaticVehicles, staticID);
    mysql_tquery(Database, sprintf("DELETE FROM `staticVehicles` WHERE `ID`='%d'", staticID));
    return 1;
}

stock StaticVehicle:AdminPanel(playerid) {
    new string[1080];
    strcat(string, "Create Static Vehicle\n");
    strcat(string, "Manage Static Vehicle\n");
    strcat(string, "Manage Static Vehicle by Vehicle ID\n");
    if (StaticVehicle:IsValidID(StaticVehicle:GetID(GetPlayerVehicleID(playerid)))) strcat(string, "Manage this Static Vehicle\n");
    return FlexPlayerDialog(
        playerid, "StaticVehicleAdminPanel", DIALOG_STYLE_TABLIST,
        "{4286f4}[Static Vehicle System]:{FFFFEE}Admin Control Panel",
        string, "Select", "Close"
    );
}

FlexDialog:StaticVehicleAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Static Vehicle")) return StaticVehicle:MenuCreateNew(playerid);
    if (IsStringSame(inputtext, "Manage Static Vehicle")) return StaticVehicle:MenuManageInput(playerid);
    if (IsStringSame(inputtext, "Manage Static Vehicle by Vehicle ID")) return StaticVehicle:MenuManageInput(playerid);
    if (IsStringSame(inputtext, "Manage this Static Vehicle") && StaticVehicle:IsValidID(StaticVehicle:GetID(GetPlayerVehicleID(playerid))))
        return StaticVehicle:Manage(playerid, StaticVehicle:GetID(GetPlayerVehicleID(playerid)));
    return 1;
}

stock StaticVehicle:ManageInputByVehID(playerid) {
    return FlexPlayerDialog(playerid, "StaticManageInputByVehID", DIALOG_STYLE_INPUT, "Manage Static Vehicle", "Enter vehicle ID", "Manage", "Cancel");
}

FlexDialog:StaticManageInputByVehID(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return StaticVehicle:AdminPanel(playerid);
    new vehicleid;
    if (sscanf(inputtext, "d", vehicleid) || !StaticVehicle:IsValidID(StaticVehicle:GetID(vehicleid))) return StaticVehicle:ManageInputByVehID(playerid);
    return StaticVehicle:Manage(playerid, StaticVehicle:GetID(vehicleid));
}

stock StaticVehicle:MenuManageInput(playerid) {
    return FlexPlayerDialog(playerid, "StaticVehMenuManageInput", DIALOG_STYLE_INPUT, "Manage Static Vehicle", "Enter static vehicle ID", "Manage", "Cancel");
}

FlexDialog:StaticVehMenuManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return StaticVehicle:AdminPanel(playerid);
    new staticID;
    if (sscanf(inputtext, "d", staticID) || !StaticVehicle:IsValidID(staticID)) return StaticVehicle:MenuManageInput(playerid);
    return StaticVehicle:Manage(playerid, staticID);
}

stock StaticVehicle:MenuCreateNew(playerid) {
    if (IsPlayerInAnyVehicle(playerid)) {
        StaticVehicle:Create(playerid, GetVehicleModel(GetPlayerVehicleID(playerid)));
        return StaticVehicle:AdminPanel(playerid);
    }
    return FlexPlayerDialog(playerid, "StaticVehicleMenuCreateNew", DIALOG_STYLE_INPUT, "Create Static Vehicle", "Enter vehicle model id", "Create", "Close");
}

FlexDialog:StaticVehicleMenuCreateNew(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return StaticVehicle:AdminPanel(playerid);
    new modelid;
    if (sscanf(inputtext, "d", modelid) || modelid < 400 || modelid > 611 || IsModelRC(modelid)) return StaticVehicle:MenuCreateNew(playerid);
    StaticVehicle:Create(playerid, modelid);
    return StaticVehicle:AdminPanel(playerid);
}

stock StaticVehicle:Manage(playerid, staticID) {
    new string[2000];
    strcat(string, "Update this Vehicle\n");
    strcat(string, "Teleport to vehicle\n");
    strcat(string, "Teleport vehicle to you\n");
    strcat(string, "Set Faction of this Vehicle\n");
    if (StaticVehicle:Data[staticID][addsiren] != 1) strcat(string, "Enable Siren for this Vehicle\n");
    if (StaticVehicle:Data[staticID][addsiren] == 1) strcat(string, "Disable Siren for this Vehicle\n");
    strcat(string, "Set Respawn Delay\n");
    strcat(string, "Remove this Vehicle\n");
    return FlexPlayerDialog(playerid, "StaticVehicleManage", DIALOG_STYLE_LIST, "Manage Static Vehicle", string, "Select", "Close", staticID);
}

FlexDialog:StaticVehicleManage(playerid, response, listitem, const inputtext[], staticID, const payload[]) {
    if (!response) return StaticVehicle:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Set Faction of this Vehicle")) return StaticVehicle:SetFaction(playerid, staticID);
    if (IsStringSame(inputtext, "Set Respawn Delay")) return StaticVehicle:SetRespawnDelay(playerid, staticID);
    if (IsStringSame(inputtext, "Teleport to vehicle")) {
        AlexaMsg(playerid, sprintf("you are teleported to static vehicle %d", staticID));
        new vehicleid = StaticVehicle:GetVehicleID(staticID);
        new Float:pos[4];
        GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
        GetVehicleZAngle(vehicleid, pos[3]);
        GetXYInFrontOfVehicle(vehicleid, pos[1], pos[2], RandomEx(5, 10));
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerPosEx(playerid, pos[0], pos[1], pos[2]);
        SetPlayerFacingAngle(playerid, pos[3] - 180);
        return StaticVehicle:Manage(playerid, staticID);
    }
    if (IsStringSame(inputtext, "Teleport vehicle to you")) {
        AlexaMsg(playerid, sprintf("teleported static vehicle %d to your location", staticID));
        new vehicleid = StaticVehicle:GetVehicleID(staticID);
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        TeleportVehicleEx(vehicleid, pos[0], pos[1], pos[2], pos[3] - 180, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        return StaticVehicle:Manage(playerid, staticID);
    }
    if (IsStringSame(inputtext, "Update this Vehicle")) {
        StaticVehicle:RemoveAllPlayer(staticID);
        SetPreciseTimer("StaticVehicleUpdate", 3000, false, "i", staticID);
        return AlexaMsg(playerid, sprintf("updated static vehicle %d", staticID));
    }
    if (IsStringSame(inputtext, "Enable Siren for this Vehicle")) {
        StaticVehicle:Data[staticID][addsiren] = 1;
        StaticVehicle:RemoveAllPlayer(staticID);
        SetPreciseTimer("StaticVehicleUpdate", 3000, false, "i", staticID);
        return AlexaMsg(playerid, sprintf("enabled siren for static vehicle %d", staticID));
    }
    if (IsStringSame(inputtext, "Disable Siren for this Vehicle")) {
        StaticVehicle:Data[staticID][addsiren] = 0;
        StaticVehicle:RemoveAllPlayer(staticID);
        SetPreciseTimer("StaticVehicleUpdate", 3000, false, "i", staticID);
        return AlexaMsg(playerid, sprintf("disabledsiren for static vehicle %d", staticID));
    }
    if (IsStringSame(inputtext, "Remove this Vehicle")) {
        StaticVehicle:RemoveAllPlayer(staticID);
        StaticVehicle:Remove(staticID);
        return AlexaMsg(playerid, sprintf("removed static vehicle %d", staticID));
    }
    return 1;
}

stock StaticVehicle:SetFaction(playerid, staticID) {
    return FlexPlayerDialog(
        playerid, "StaticVehicleSetFaction", DIALOG_STYLE_INPUT, "Vehicle: Update Faction",
        "Enter faction id, use -1 to disable faction for vehicle", "Update", "Cancel", staticID
    );
}

FlexDialog:StaticVehicleSetFaction(playerid, response, listitem, const inputtext[], staticID, const payload[]) {
    if (!response) return StaticVehicle:Manage(playerid, staticID);
    StaticVehicle:Data[staticID][factionID] = strval(inputtext);
    StaticVehicle:RemoveAllPlayer(staticID);
    SetPreciseTimer("StaticVehicleUpdate", 3000, false, "i", staticID);
    return AlexaMsg(playerid, sprintf("updated faction for static vehicle %d", staticID));
}

stock StaticVehicle:SetRespawnDelay(playerid, staticID) {
    return FlexPlayerDialog(
        playerid, "StaticVehicleRespawnDelay", DIALOG_STYLE_INPUT, "Vehicle: Update Respawn Delay",
        "Enter respawn delay for vehicle, default is 1800", "Update", "Cancel", staticID
    );
}

FlexDialog:StaticVehicleRespawnDelay(playerid, response, listitem, const inputtext[], staticID, const payload[]) {
    if (!response) return StaticVehicle:Manage(playerid, staticID);
    new respawnDelay;
    if (sscanf(inputtext, "d", respawnDelay) || respawnDelay < 500) return StaticVehicle:SetRespawnDelay(playerid, staticID);
    StaticVehicle:Data[staticID][factionID] = respawnDelay;
    StaticVehicle:RemoveAllPlayer(staticID);
    SetPreciseTimer("StaticVehicleUpdate", 3000, false, "i", staticID);
    return AlexaMsg(playerid, sprintf("updated faction for static vehicle %d", staticID));
}