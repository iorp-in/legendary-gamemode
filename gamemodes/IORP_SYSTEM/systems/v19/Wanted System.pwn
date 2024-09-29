new WantedDatabase:FineFee = 500;

enum WantedDatabase:PlayerEnum {
    bool:WantedDatabase:InJail,
    WantedDatabase:JailTimer,
    WantedDatabase:ActiveStars
};
new WantedDatabase:PlayerData[MAX_PLAYERS][WantedDatabase:PlayerEnum];

hook GlobalOneMinuteInterval() {
    WantedDatabase:FineFee = Random(500, 1500);
    UpdatePlayersWantedLevel();
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "LastJailKick", "int", "0");
    Database:AddColumn("playerdata", "IsJailed", "boolean", "0");
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `wantedRecords` (\
      `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `Username` varchar(50) NOT NULL,\
	  `Date` int(11) NOT NULL,\
	  `Reason` varchar(512) NOT NULL,\
	  `Levels` int(11) NOT NULL,\
	  `Resolved` int(11) NOT NULL,\
      PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

stock WantedDatabase:IsInJail(playerid) {
    return WantedDatabase:PlayerData[playerid][WantedDatabase:InJail];
}

stock WantedDatabase:SetJailStatus(playerid, bool:status) {
    WantedDatabase:PlayerData[playerid][WantedDatabase:InJail] = status;
    return 1;
}

stock WantedDatabase:UpdateJailData(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    Database:UpdateBool(WantedDatabase:IsInJail(playerid) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "IsJailed");
    return 1;
}

stock WantedDatabase:GiveWantedLevel(playerid, const reason[], levels = 1, bool:fineable = true) {
    if (!IsPlayerConnected(playerid)) return 1;
    SetPlayerWantedLevelEx(playerid, GetPlayerWantedLevelEx(playerid) + levels);
    return WantedDatabase:GiveWantedLevelOffline(GetPlayerNameEx(playerid), reason, levels, fineable);
}

stock WantedDatabase:GiveWantedLevelOffline(const player[], const reason[], levels = 1, bool:fineable = true) {
    if (!IsValidAccount(player)) return 1;
    mysql_tquery(
        Database, sprintf(
            "insert into wantedRecords set `Username` = \"%s\", `Date` = UNIX_TIMESTAMP(), `Reason` = \"%s\", `Resolved` = 0, `Levels` = %d, `fineable` = %d",
            player, RemoveMalChars(reason), levels, fineable
        )
    );
    new playerid = GetPlayerIDByName(player);
    if (IsPlayerConnected(playerid)) CallRemoteFunction("OnPlayerGiveWantedLevel", "dds", playerid, levels, reason);
    return 1;
}

forward OnPlayerGiveWantedLevel(playerid, levels, const reason[]);
public OnPlayerGiveWantedLevel(playerid, levels, const reason[]) {
    AlexaMsg(playerid, "you are reported for committing a crime", "SAPD");
    AlexaMsg(playerid, sprintf("Crime: %s", reason), "SAPD");
    return 1;
}

stock WantedDatabase:ResetWantedLevel(playerid, const resolvedlog[]) {
    if (!IsPlayerConnected(playerid)) return 1;
    new query[256];
    mysql_format(Database, query, sizeof query, "update wantedRecords set `Resolved` = 1, `resolvedReason` = \"%s\", `resolvedDate` = CURRENT_TIMESTAMP where Resolved = 0 and Username = \"%s\"", resolvedlog, GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "OnPlayerWantedLevelReset", "i", playerid);
    return 1;
}

stock WantedDatabase:ResetFinableWantedLevel(playerid, const resolvedlog[]) {
    if (!IsPlayerConnected(playerid)) return 1;
    new query[256];
    mysql_format(Database, query, sizeof query, "update wantedRecords set `Resolved` = 1, `resolvedReason` = \"%s\", `resolvedDate` = CURRENT_TIMESTAMP where Resolved = 0 and Username = \"%s\" and fineable = 1", resolvedlog, GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "OnPlayerWantedLevelReset", "i", playerid);
    return 1;
}

forward OnPlayerWantedLevelReset(playerid);
public OnPlayerWantedLevelReset(playerid) {
    new string[512];
    format(string, sizeof string, "{4286f4}[SAPD]:{0000CD} your wanted database record are reseted");
    SendClientMessageEx(playerid, -1, string);
    new stars = WantedDatabase:GetTotalLevelByState(GetPlayerNameEx(playerid));
    SetPlayerWantedLevelEx(playerid, stars);
    return 1;
}

stock WantedDatabase:GetTotalWantedLevel(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from wantedRecords where username =\"%s\"", username));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock WantedDatabase:GetTotalLevelByState(const username[], resolved = 0) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from wantedRecords where username =\"%s\" and Resolved = %d", username, resolved));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock WantedDatabase:GetFinableWantedLevel(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from wantedRecords where username =\"%s\" and fineable = 1 and Resolved = 0", username));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock WantedDatabase:AdminJail(playerid, stars, const Reason[], bool:fineable) {
    if (stars < 1) return 1;
    WantedDatabase:GiveWantedLevel(playerid, Reason, stars, fineable);
    WantedDatabase:SendJail(playerid);
    WantedDatabase:JailPlayer(playerid);
    return 1;
}

stock WantedDatabase:SendJail(playerid) {
    SetPlayerInteriorEx(playerid, 6);
    SetPlayerVirtualWorldEx(playerid, 100);
    SetPlayerPosEx(playerid, 1833, -1722.1720, 5204);
    SetCameraBehindPlayer(playerid);
    Cuff_Player(playerid);
    return 1;
}

stock WantedDatabase:SendSAPD(playerid) {
    SetPlayerInteriorEx(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, 0);
    SetPlayerPosEx(playerid, 1538, -1674, 14);
    SetCameraBehindPlayer(playerid);
    Uncuff_Player(playerid);
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    WantedDatabase:SetJailStatus(playerid, Database:GetBool(GetPlayerNameEx(playerid), "username", "IsJailed"));
    mysql_tquery(Database, sprintf("select count(*) as total from wantedRecords where username =\"%s\" and Resolved = 0", GetPlayerNameEx(playerid)), "OnActiveWantedLevelCount", "d", playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    WantedDatabase:UpdateJailData(playerid);
    DeletePreciseTimer(WantedDatabase:PlayerData[playerid][WantedDatabase:JailTimer]);
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    if (WantedDatabase:IsInJail(playerid) && newinteriorid != 6) {
        WantedDatabase:GiveWantedLevel(playerid, "tried Jail Break");
        WantedDatabase:SendJail(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD} you are autojailed for remaining crimes, pls cooperate with us");
        WantedDatabase:JailPlayer(playerid);
    }
    return 1;
}

hook OnPlayerVirtualWorld(playerid, newvirtualworld, oldvirtualworld) {
    if (WantedDatabase:IsInJail(playerid) && newvirtualworld != 100) {
        WantedDatabase:GiveWantedLevel(playerid, "tried Jail Break");
        WantedDatabase:SendJail(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD} you are autojailed for remaining crimes, pls cooperate with us");
        WantedDatabase:JailPlayer(playerid);
    }
    return 1;
}

stock WantedDatabase:ShowWantedRecordTo(playerid, toplayer) {
    if (!IsPlayerConnected(toplayer || !IsPlayerConnected(playerid))) return 1;
    if (GetPlayerWantedLevelEx(toplayer)) return SendClientMessage(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} %s's is cleared, no criminal records", GetPlayerNameEx(toplayer)));
    return WantedDatabase:ViewRecords(playerid, GetPlayerNameEx(toplayer));
}

stock UpdatePlayersWantedLevel() {
    foreach(new playerid:Player) {
        if (GetPlayerWantedLevelEx(playerid) > 6) {
            if (!GetPlayerRPMode(playerid)) {
                callcmd::fightmode(playerid, "");
                AlexaMsg(playerid, "you can not turn off fight mode when you have wanted stars", "SAPD");
            }
        }
        // mysql_tquery(Database, sprintf("select count(*) as total from wantedRecords where username =\"%s\" and Resolved = 0", GetPlayerNameEx(playerid)), "OnActiveWantedLevelCount", "d", playerid);
    }
    return 1;
}

forward OnActiveWantedLevelCount(playerid);
public OnActiveWantedLevelCount(playerid) {
    new rows = cache_num_rows();
    if (rows) {
        new total = 0;
        cache_get_value_name_int(0, "total", total);
        SetPlayerWantedLevelEx(playerid, total);
    }
    return 1;
}

stock WantedDatabase:JailPlayer(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    ResetPlayerWeaponsEx(playerid);
    RemoveLastWantedLevelStart(playerid);
    WantedDatabase:SetJailStatus(playerid, true);
    CallRemoteFunction("OnPlayerJailed", "d", playerid);
    return 1;
}

forward OnPlayerJailed(playerid);
public OnPlayerJailed(playerid) {
    new query[256], Cache:response_cache, total_crime;
    mysql_format(Database, query, sizeof query, "SELECT * from wantedRecords where Username = \"%s\" and Resolved = 0", GetPlayerNameEx(playerid));
    response_cache = mysql_query(Database, query);
    total_crime = cache_num_rows();
    cache_delete(response_cache);
    new string[512];
    format(string, sizeof string, "{4286f4}[SAPD]:{0000CD}%s jailed for %d crimes", GetPlayerNameEx(playerid), total_crime);
    SendClientMessageToAll(-1, string);
    return 1;
}

stock WantedDatabase:UnjailPlayer(playerid) {
    StopScreenTimer(playerid, 1);
    DeletePreciseTimer(WantedDatabase:PlayerData[playerid][WantedDatabase:JailTimer]);
    WantedDatabase:SetJailStatus(playerid, false);
    WantedDatabase:SendSAPD(playerid);
    CallRemoteFunction("OnPlayerUnJailed", "d", playerid);
    return 1;
}

forward OnPlayerUnJailed(playerid);
public OnPlayerUnJailed(playerid) {
    return 1;
}

forward RemoveLastWantedLevelStart(playerid);
public RemoveLastWantedLevelStart(playerid) {
    new query[256], Cache:mysql_cache;
    mysql_format(Database, query, sizeof(query), "SELECT ID, Levels, Resolved, Reason, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i:%%s') AS Created from wantedRecords where Username=\"%s\" and Resolved = 0 ORDER BY Date ASC limit 1", GetPlayerNameEx(playerid));
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) {
        new levels;
        cache_get_value_name_int(0, "Levels", levels);
        DeletePreciseTimer(WantedDatabase:PlayerData[playerid][WantedDatabase:JailTimer]);
        WantedDatabase:PlayerData[playerid][WantedDatabase:JailTimer] = SetPreciseTimer(
            "RemoveLastWantedLevel", levels * 60 * 1000, false, "d", playerid
        );
        StopScreenTimer(playerid, 1);
        StartScreenTimer(playerid, levels * 60);
    } else {
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD}all wanted level cleared, you are unjailed");
        WantedDatabase:UnjailPlayer(playerid);
    }
    cache_delete(mysql_cache);
    return 1;
}

forward RemoveLastWantedLevel(playerid);
public RemoveLastWantedLevel(playerid) {
    if (IsPlayerPaused(playerid)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD} please unpause your game, your wanted level won't decrease if you pause your game.");
        RemoveLastWantedLevelStart(playerid);
        return 1;
    }
    new query[256], Cache:mysql_cache, cID;
    mysql_format(Database, query, sizeof(query), "SELECT ID, Levels, Resolved, Reason, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i:%%s') AS Created from wantedRecords where Username=\"%s\" and Resolved = 0 ORDER BY Date ASC limit 1", GetPlayerNameEx(playerid));
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) {
        new reason[50], cdate[24], levels;
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", cID);
            cache_get_value_name_int(i, "Levels", levels);
            cache_get_value_name(i, "Reason", reason, sizeof reason);
            cache_get_value_name(i, "Created", cdate, sizeof cdate);
            SetPlayerWantedLevelEx(playerid, GetPlayerWantedLevelEx(playerid) - levels);
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD}wanted level cleared for commited crime %s at %s", reason, cdate));
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD}%d crimes to spend in jail", GetPlayerWantedLevelEx(playerid)));
        }
    } else {
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD}all wanted level cleared, you are unjailed");
        WantedDatabase:UnjailPlayer(playerid);
        cache_delete(mysql_cache);
        return 1;
    }
    cache_delete(mysql_cache);
    mysql_format(Database, query, sizeof query, "update wantedRecords set Resolved = 1, `resolvedReason` = \"%s\", `resolvedDate` = CURRENT_TIMESTAMP where ID = %d limit 1", "spent jail for it", cID);
    mysql_tquery(Database, query);
    RemoveLastWantedLevelStart(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && IsPlayerInAnyVehicle(playerid) && Faction:IsPlayerSigned(playerid)) {
        new allow_vehicle[] = { 497, 523, 596, 597, 598, 599 };
        if (IsArrayContainNumber(allow_vehicle, GetVehicleModel(GetPlayerVehicleID(playerid)))) UCP:AddCommand(playerid, "SAPD HQ");
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("SAPD HQ", inputtext)) WantedDatabase:Menu(playerid);
    return 1;
}

forward OnCopBodySearch(playerid, suspectid);
public OnCopBodySearch(playerid, suspectid) {
    // show player drugs
    if (Drug:Get(suspectid) > 0) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} Drug: %d grams", Drug:Get(suspectid)));
    }

    if (Drug:GetSeed(playerid) > 0) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} Drug Seed: %d unit", Drug:GetSeed(suspectid)));
    }

    //whitelisted weapons 
    new wWeaponList[] = { 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 17, 16 };

    // find player weapons
    new weaponid, ammo;
    for (new i = 0; i <= 12; i++) {
        GivePlayerWeaponEx(suspectid, weaponid, ammo);
        if (ammo > 0 && IsArrayContainNumber(wWeaponList, weaponid)) {
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} Weapon: %s", GetWeaponNameEx(weaponid)));
        }
    }

    // check player active crimes
    if (GetPlayerWantedLevelEx(suspectid) == 0) SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD} The suspect does not have any active criminal records");
    else SendClientMessageEx(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} There are %d active crimes against the suspect", GetPlayerWantedLevelEx(suspectid)));

    // body search complete
    SendClientMessage(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} searched body of %s", GetPlayerNameEx(suspectid)));
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid) &&
        GetPlayerRPMode(playerid) &&
        GetPlayerRPMode(targetid) &&
        !WantedDatabase:IsInJail(targetid)
    ) QuickActions:AddCommand(playerid, "Jail Player");
    else if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid) &&
        IsPlayerInRangeOfPoint(playerid, 25, 1833, -1722.1720, 5202) &&
        GetPlayerInterior(playerid) == 6 &&
        GetPlayerInterior(targetid) == 6 &&
        IsPlayerInRangeOfPoint(targetid, 25, 1833, -1722.1720, 5202) &&
        !WantedDatabase:IsInJail(targetid)
    ) QuickActions:AddCommand(playerid, "Jail Player");
    else if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid) &&
        IsPlayerInRangeOfPoint(playerid, 25, 1833, -1722.1720, 5202) &&
        GetPlayerInterior(playerid) == 6 &&
        GetPlayerInterior(targetid) == 6 &&
        IsPlayerInRangeOfPoint(targetid, 25, 1833, -1722.1720, 5202) &&
        WantedDatabase:IsInJail(targetid)
    ) QuickActions:AddCommand(playerid, "UnJail Player");
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid) &&
        !WantedDatabase:IsInJail(targetid)
    ) QuickActions:AddCommand(playerid, "Give Ticket");
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid) &&
        !WantedDatabase:IsInJail(targetid)
    ) QuickActions:AddCommand(playerid, "Player Fines");
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid)
    ) QuickActions:AddCommand(playerid, "View Wanted Records for player");
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid)
    ) QuickActions:AddCommand(playerid, "Show Wanted Records to player");
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) &&
        Faction:IsPlayerSigned(playerid)
    ) QuickActions:AddCommand(playerid, "Search the body of the suspect");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Search the body of the suspect", inputtext)) {
        CallRemoteFunction("OnCopBodySearch", "dd", playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Jail Player", inputtext)) {
        WantedDatabase:SendJail(targetid);
        WantedDatabase:JailPlayer(targetid);
        return ~1;
    }
    if (IsStringSame("UnJail Player", inputtext)) {
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[SAPD]:{0000CD} you are unjailed early by %s", GetPlayerNameEx(targetid)));
        WantedDatabase:UnjailPlayer(targetid);
        return ~1;
    }
    if (IsStringSame("Give Ticket", inputtext)) return WantedDatabase:GiveTicket(playerid, targetid);
    if (IsStringSame("View Wanted Records for player", inputtext)) return WantedDatabase:ShowWantedRecordTo(playerid, targetid);
    if (IsStringSame("Show Wanted Records to player", inputtext)) return WantedDatabase:ShowWantedRecordTo(targetid, targetid);
    if (IsStringSame("Player Fines", inputtext)) {
        new WantedDatabase:TotalCrimes = WantedDatabase:GetFinableWantedLevel(GetPlayerNameEx(targetid));
        new total_fine = WantedDatabase:FineFee * WantedDatabase:TotalCrimes;
        if (WantedDatabase:TotalCrimes > 20) return SendClientMessage(playerid, -1, "{4286f4}[SAPD]:{0000CD} please take this criminal to SAPD HQ, Immediately");
        if (WantedDatabase:TotalCrimes == 0) return SendClientMessage(playerid, -1, "{4286f4}[SAPD]:{0000CD} there are no criminal record for him/her");
        new string[512];
        strcat(string, sprintf("Name:%s\n", GetPlayerNameEx(targetid)));
        strcat(string, sprintf("Tatal Crimes: %d (only fineable crimes are display)\n", WantedDatabase:TotalCrimes));
        strcat(string, sprintf("Tatal Fine: %d\n", total_fine));
        strcat(string, sprintf("\nDo you want to fine %s?", GetPlayerNameEx(targetid)));
        FlexPlayerDialog(playerid, "WantedShowFine", DIALOG_STYLE_MSGBOX, "{4286f4}[SAPD]:{0000CD}SAPD HQ", string, "Fine", "No", targetid);
        return ~1;
    }
    return 1;
}

FlexDialog:WantedShowFine(playerid, response, listitem, const inputtext[], targetid, const payload[]) {
    if (!response) return 1;
    new WantedDatabase:TotalCrimes = WantedDatabase:GetFinableWantedLevel(GetPlayerNameEx(targetid));
    return FlexPlayerDialog(
        targetid, "WantedShowFineConfirm", DIALOG_STYLE_MSGBOX, "{4286f4}[SAPD]:{0000CD}SAPD HQ",
        sprintf(
            "%s fined you for %d crimes\nDo you want to pay $%s fine?",
            GetPlayerNameEx(playerid), WantedDatabase:TotalCrimes,
            FormatCurrency(WantedDatabase:FineFee * WantedDatabase:TotalCrimes)
        ), "Yes", "No", playerid
    );
}

FlexDialog:WantedShowFineConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return SendClientMessage(extraid, -1, sprintf("{4286f4}[SAPD]:{0000CD}%s does not want to pay fine", GetPlayerNameEx(playerid)));
    new WantedDatabase:TotalCrimes = WantedDatabase:GetFinableWantedLevel(GetPlayerNameEx(playerid));
    new total_fine = WantedDatabase:FineFee * WantedDatabase:TotalCrimes;
    if (GetPlayerCash(playerid) < total_fine) {
        SendClientMessage(playerid, -1, "{4286f4}[SAPD]:{0000CD}you does not have enough money");
        SendClientMessage(extraid, -1, sprintf("{4286f4}[SAPD]:{0000CD}%s does not have enough money", GetPlayerNameEx(playerid)));
        return 1;
    }
    new copreward = GetPercentageOf(30, total_fine);
    GivePlayerCash(playerid, -total_fine, "paid fine to law");
    GivePlayerCash(extraid, copreward, "cut from fine");
    if (total_fine - copreward > 0) vault:addcash(Vault_ID_SAPD, total_fine - copreward, Vault_Transaction_Cash_To_Vault, sprintf("fine recieved from %s", GetPlayerNameEx(playerid)));
    WantedDatabase:ResetFinableWantedLevel(playerid, sprintf("fined by officer %s ", GetPlayerNameEx(extraid)));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} you have payed $%s fine.", FormatCurrency(total_fine)));
    SendClientMessage(extraid, -1, sprintf("{4286f4}[SAPD]:{0000CD} %s payed $%s fine.", GetPlayerNameEx(playerid), FormatCurrency(total_fine)));
    SendClientMessage(extraid, -1, sprintf("{4286f4}[SAPD]:{0000CD} you have recieved $%s from this fine", FormatCurrency(copreward)));
    return 1;
}

new bool:WantedDatabase:SpawnInJail[MAX_PLAYERS] = false;

hook OnPlayerConnect(playerid) {
    WantedDatabase:SpawnInJail[playerid] = false;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (IsPlayerConnected(killerid)) {
        if (WantedDatabase:IsInJail(killerid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FF0000} I am sorry, one of our player did not followed rules, but I have taken action against him.");
            Discord:SendHelper(sprintf(":page_with_curl:** %s killed %s in jail. **", GetPlayerNameEx(killerid), GetPlayerNameEx(playerid)));
            if (gettime() - Database:GetInt(GetPlayerNameEx(killerid), "username", "LastJailKick") < 15 * 60) {
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} Hello, I am alexa again. I told you but you did not listened.");
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} I am banning you for next 6 hours to teach you some respect.");
                new unbantime[100];
                UnixToHuman(gettime() + 6 * 60 * 60, unbantime);
                mysql_tquery(Database, sprintf("UPDATE `players` set bantime = %d, banreason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", gettime() + 6 * 60 * 60, "jail evade by alexa", GetPlayerNameEx(killerid)));
                SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE} I banned %s for %s", GetPlayerNameEx(killerid), "jail evade by alexa"));
                Discord:SendHelper(sprintf("[Alexa]: I banned %s till %s for %s", GetPlayerNameEx(killerid), unbantime, "jail evade by alexa"));
                KickPlayer(killerid);
            } else {
                Database:UpdateInt(gettime(), GetPlayerNameEx(killerid), "username", "LastJailKick");
                SendClientMessageEx(killerid, -1, sprintf("{4286f4}[SAPD]:{0000CD} you have killed %s in jail", GetPlayerNameEx(playerid)));
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} Hello, I am alexa. you were not suppose to kill anyone in jail, but I guess you don't want to play by rules.");
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} do not worry management has been notified, they will take action against your account very soon.");
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} but for now, I am kicking your ass out of server. Join only if you can play by rules.");
                SendClientMessageEx(killerid, -1, "{4286f4}[Alexa]:{FF0000} I hope, I made myself very clear to you. Next time, I won't leave you with notice.");
                KickPlayer(killerid);
            }
        }
    }
    if (killerid == INVALID_PLAYER_ID || !IsPlayerConnected(killerid)) return 1;
    if (!GetPlayerRPMode(killerid) || !GetPlayerRPMode(playerid)) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (!IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(killerid)) || !Faction:IsPlayerSigned(killerid) || WantedDatabase:IsInJail(playerid)) return 1;
    if (GetPlayerWantedLevelEx(playerid) > 0) WantedDatabase:SpawnInJail[playerid] = true;
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if (WantedDatabase:IsInJail(playerid)) {
        WantedDatabase:SendJail(playerid);
        AlexaMsg(playerid, sprintf("{4286f4}[SAPD]:{0000CD} you are autojailed for remaining %d crimes", GetPlayerWantedLevelEx(playerid)));
        WantedDatabase:JailPlayer(playerid);
    }
    if (!WantedDatabase:SpawnInJail[playerid]) return 1;
    WantedDatabase:SpawnInJail[playerid] = false;
    WantedDatabase:SendJail(playerid);
    WantedDatabase:JailPlayer(playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `wantedRecords` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `wantedRecords` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords("wanted database", text) && GetPlayerAdminLevel(playerid) > 5) {
        WantedDatabase:Menu(playerid);
        return ~1;
    }
    return 1;
}

stock WantedDatabase:GiveTicket(playerid, targetid) {
    return FlexPlayerDialog(playerid, "WantedDatabaseGiveTicket", DIALOG_STYLE_INPUT, "{4286f4}[SAPD]:{0000CD}SAPD HQ", "[Jail Minutes] [Fineable? 1/0] [Crime]", "Report", "Close", targetid);
}

FlexDialog:WantedDatabaseGiveTicket(playerid, response, listitem, const inputtext[], targetid, const payload[]) {
    if (!response || !IsPlayerConnected(targetid)) return 1;
    new levels, Reason[144], bool:fineable;
    if (sscanf(inputtext, "dbs[144]", levels, fineable, Reason) || levels < 1 || levels > 15) return WantedDatabase:GiveTicket(playerid, targetid);
    WantedDatabase:GiveWantedLevel(targetid, sprintf("%s reported %s", GetPlayerNameEx(playerid), Reason), levels, fineable);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[SAPD]:{0000CD}Crime reported for %s", GetPlayerNameEx(targetid)));
    return 1;
}

stock WantedDatabase:Menu(playerid) {
    if (WantedDatabase:IsInJail(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD}When you are jailed, you cannot access the database");
    new string[512];
    strcat(string, "Register FIR\n");
    strcat(string, "View Wanted Database\n");
    return FlexPlayerDialog(playerid, "WantedDatabaseMenu", DIALOG_STYLE_LIST, "{4286f4}[SAPD]:{0000CD}SAPD HQ", string, "Select", "Close");
}

FlexDialog:WantedDatabaseMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Register FIR")) return WantedDatabase:NewFIR(playerid);
    if (IsStringSame(inputtext, "View Wanted Database")) return WantedDatabase:ViewRecordInput(playerid);
    return 1;
}

stock WantedDatabase:NewFIR(playerid) {
    return FlexPlayerDialog(playerid, "WantedDatabaseNewFIR", DIALOG_STYLE_INPUT, "SAPD: FIR", "[playername] [Jail Minutes] [Fineable? 1/0] [Crime]", "Register", "Close");
}

FlexDialog:WantedDatabaseNewFIR(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return WantedDatabase:Menu(playerid);
    new username[32], Reason[144], levels, bool:fineable;
    if (sscanf(inputtext, "s[32]dbs[144]", username, levels, fineable, Reason) || !IsValidAccount(username)) return WantedDatabase:NewFIR(playerid);
    WantedDatabase:GiveWantedLevelOffline(username, Reason, levels, fineable);
    AlexaMsg(playerid, sprintf("Crime reported for %s", username), "SAPD");
    return WantedDatabase:Menu(playerid);
}

stock WantedDatabase:ViewRecordInput(playerid) {
    return FlexPlayerDialog(playerid, "WantedDatabaseViewInput", DIALOG_STYLE_INPUT, "SAPD: Database", "Enter suspect name", "View", "Close");
}

FlexDialog:WantedDatabaseViewInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return WantedDatabase:Menu(playerid);
    new suspectName[32];
    if (sscanf(inputtext, "s[32]", suspectName) || !IsValidAccount(suspectName)) return WantedDatabase:ViewRecordInput(playerid);
    return WantedDatabase:ViewRecords(playerid, suspectName);
}

stock WantedDatabase:ViewRecords(playerid, const suspectName[], page = 0) {
    new total = WantedDatabase:GetTotalWantedLevel(suspectName);
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "SELECT ID, Levels, Resolved, Reason, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i:%%s') AS Created \
        from wantedRecords where Username=\"%s\" ORDER BY Date DESC limit %d, 10",
        suspectName, skip
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        SendClientMessageEx(playerid, -1, "{4286f4}[SAPD]:{0000CD}could not found any wanted record");
        return WantedDatabase:Menu(playerid);
    }

    new string[2000], reason[252], cdate[100], cID, resolved, levels;
    format(string, sizeof(string), "ID | Levels\tCrime\tDate\tResolved\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "ID", cID);
        cache_get_value_name_int(i, "Resolved", resolved);
        cache_get_value_name_int(i, "Levels", levels);
        cache_get_value_name(i, "Reason", reason, sizeof reason);
        cache_get_value_name(i, "Created", cdate, sizeof cdate);
        strcat(string, sprintf("{FFFFFF}%d | %d\t%s\t%s\t%s\n", cID, levels, reason, cdate, (resolved == 0 ? "No" : "Yes")));
    }
    cache_delete(mysql_cache);

    if (remaining > 0) format(string, sizeof(string), "%s{FFFFFF}Next Page\n", string);
    if (page > 0) format(string, sizeof(string), "%s{FFFFFF}Back Page\n", string);

    return FlexPlayerDialog(
        playerid, "WantedDatabaseView", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[SAPD]:{0000CD}Wanted Database", string, "Close", "Close", page, suspectName
    );
}

FlexDialog:WantedDatabaseView(playerid, response, listitem, const inputtext[], page, const suspectName[]) {
    if (!response) return WantedDatabase:Menu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return WantedDatabase:ViewRecords(playerid, suspectName, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return WantedDatabase:ViewRecords(playerid, suspectName, page - 1);
    return WantedDatabase:ViewRecords(playerid, suspectName, page);
}

hook ApcpOnInit(playerid, targetid, page) {
    if (page != 1) return 1;
    if (GetPlayerWantedLevelEx(targetid)) APCP:AddCommand(playerid, "Clear All Wanted Levels");
    return 1;
}

hook ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 1) return 1;
    if (IsStringSame("Clear All Wanted Levels", inputtext)) {
        WantedDatabase:ResetWantedLevel(targetid, sprintf("admin %s cleared this wanted level", GetPlayerNameEx(playerid)));
        return ~1;
    }
    return 1;
}