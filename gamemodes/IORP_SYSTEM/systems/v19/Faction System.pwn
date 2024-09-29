#define Max_Faction 100
#define Max_Faction_Rank 100
#define Max_Faction_Skin 10
#define Max_Faction_Weapon 50
#define MAX_Faction 50

enum Faction:PlayerDataEnum {
    FactionID,
    FactionRankID,

    LastSkin,
    SingInTime,
    bool:FactionStatus,
    FactionRequestID
};
new Faction:PlayerData[MAX_PLAYERS][Faction:PlayerDataEnum];

enum Faction:DataEnum {
    ID,
    Name[50],
    Members_Limit,
    AllowJoining,
    Leader_Name[MAX_PLAYER_NAME],
    RankLimit,
    RpScoreRequired,
    GameScoreRequired,
    vaultID,
    SkinLimit,
    WeaponLimit,
    Faction_Color,
    Faction_Wage,
    Float:Faction_CP[3],
    Faction_CP_DATA[2],
    Faction_CP_ID,
    Float:MinX,
    Float:MinY,
    Float:MaxX,
    Float:MaxY,
    ZColor,
    NColor,
    BColor,
    ZoneID
};
new Faction:Data[Max_Faction][Faction:DataEnum];
new Iterator:factions < Max_Faction > ;

enum Faction:RankDataEnum {
    Name[50],
        rank_wage
}
new Faction:RankData[Max_Faction][Max_Faction_Rank + 1][Faction:RankDataEnum];

enum Faction:SkinDataEnum {
    SkinID
}
new Faction:SkinData[Max_Faction][Max_Faction_Skin][Faction:SkinDataEnum];

enum Faction:WeaponDataEnum {
    WeaponID,
    WeaponBullet
}
new Faction:WeaponData[Max_Faction][Max_Faction_Weapon][Faction:WeaponDataEnum];

enum Faction:VehicleEnum {
    FactionID
}
new Faction:VehicleData[400 + 612][Faction:VehicleEnum];
// new FactionPlayerWeapons[MAX_PLAYERS][13][2];

forward LoadFactionsData();
public LoadFactionsData() {
    new rows = cache_num_rows();
    if (rows) {
        new factionid, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", factionid);
            cache_get_value_name_int(loaded, "ID", Faction:Data[factionid][ID]);
            cache_get_value_name(loaded, "Name", Faction:Data[factionid][Name], .max_len = 50);
            cache_get_value_name_int(loaded, "Members_Limit", Faction:Data[factionid][Members_Limit]);
            cache_get_value_name_int(loaded, "AllowJoining", Faction:Data[factionid][AllowJoining]);
            cache_get_value_name(loaded, "Leader_Name", Faction:Data[factionid][Leader_Name], .max_len = MAX_PLAYER_NAME);
            cache_get_value_name_int(loaded, "RankLimit", Faction:Data[factionid][RankLimit]);
            cache_get_value_name_int(loaded, "SkinLimit", Faction:Data[factionid][SkinLimit]);
            cache_get_value_name_int(loaded, "GameScoreRequired", Faction:Data[factionid][GameScoreRequired]);
            cache_get_value_name_int(loaded, "RpScoreRequired", Faction:Data[factionid][RpScoreRequired]);
            cache_get_value_name_int(loaded, "vaultID", Faction:Data[factionid][vaultID]);
            cache_get_value_name_int(loaded, "WeaponLimit", Faction:Data[factionid][WeaponLimit]);
            cache_get_value_name_int(loaded, "Faction_Color", Faction:Data[factionid][Faction_Color]);
            cache_get_value_name_float(loaded, "Faction_CP_X", Faction:Data[factionid][Faction_CP][0]);
            cache_get_value_name_float(loaded, "Faction_CP_Y", Faction:Data[factionid][Faction_CP][1]);
            cache_get_value_name_float(loaded, "Faction_CP_Z", Faction:Data[factionid][Faction_CP][2]);
            cache_get_value_name_int(loaded, "Faction_CP_VW", Faction:Data[factionid][Faction_CP_DATA][0]);
            cache_get_value_name_int(loaded, "Faction_CP_INT", Faction:Data[factionid][Faction_CP_DATA][1]);
            cache_get_value_name_float(loaded, "MinX", Faction:Data[factionid][MinX]);
            cache_get_value_name_float(loaded, "MinY", Faction:Data[factionid][MinY]);
            cache_get_value_name_float(loaded, "MaxX", Faction:Data[factionid][MaxX]);
            cache_get_value_name_float(loaded, "MaxY", Faction:Data[factionid][MaxY]);
            cache_get_value_name_int(loaded, "ZColor", Faction:Data[factionid][ZColor]);
            cache_get_value_name_int(loaded, "NColor", Faction:Data[factionid][NColor]);
            cache_get_value_name_int(loaded, "BColor", Faction:Data[factionid][BColor]);
            cache_get_value_name_int(loaded, "Faction_Wage", Faction:Data[factionid][Faction_Wage]);
            if (Faction:Data[factionid][MinX] != 0.0) {
                Faction:Data[factionid][ZoneID] = CreateZone(Faction:Data[factionid][MinX], Faction:Data[factionid][MinY], Faction:Data[factionid][MaxX], Faction:Data[factionid][MaxY]);
                CreateZoneNumber(Faction:Data[factionid][ZoneID], Faction:Data[factionid][ID]);
                CreateZoneBorders(Faction:Data[factionid][ZoneID]);
            }
            Faction:Data[factionid][Faction_CP_ID] = CreateDynamicPickup(1275, 2, Faction:Data[factionid][Faction_CP][0], Faction:Data[factionid][Faction_CP][1], Faction:Data[factionid][Faction_CP][2], Faction:Data[factionid][Faction_CP_DATA][0], Faction:Data[factionid][Faction_CP_DATA][1]);
            Iter_Add(factions, factionid);
            loaded++;
        }
    }
    printf("  [Faction System] Loaded %d Factions.", rows);
    return 1;
}

forward LoadFactionRanks();
public LoadFactionRanks() {
    new rows = cache_num_rows();
    if (rows) {
        new factionid, rank, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "FactionID", factionid);
            cache_get_value_name_int(loaded, "Faction_RankID", rank);
            cache_get_value_name(loaded, "Name", Faction:RankData[factionid][rank][Name], .max_len = 50);
            cache_get_value_name_int(loaded, "Wage", Faction:RankData[factionid][rank][rank_wage]);
            loaded++;
        }
    }
    printf("  [Faction System] Loaded %d Faction Rank Data's.", rows);
    return 1;
}

forward LoadFactionSkins();
public LoadFactionSkins() {
    new rows = cache_num_rows();
    if (rows) {
        new factionid, slot, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "FactionID", factionid);
            cache_get_value_name_int(loaded, "Faction_SkinID_Slot", slot);
            cache_get_value_name_int(loaded, "SkinID", Faction:SkinData[factionid][slot][SkinID]);
            loaded++;
        }
    }
    printf("  [Faction System] Loaded %d Faction Skin Data's.", rows);
    return 1;
}

forward LoadFactionWeapons();
public LoadFactionWeapons() {
    new rows = cache_num_rows();
    if (rows) {
        new factionid, slot, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "FactionID", factionid);
            cache_get_value_name_int(loaded, "Faction_WeaponID_Slot", slot);
            cache_get_value_name_int(loaded, "WeaponID", Faction:WeaponData[factionid][slot][WeaponID]);
            cache_get_value_name_int(loaded, "WeaponBullet", Faction:WeaponData[factionid][slot][WeaponBullet]);
            loaded++;
        }
    }
    printf("  [Faction System] Loaded %d Faction Weapon Data's.", rows);
    return 1;
}

forward LoadFactionVehicleData();
public LoadFactionVehicleData() {
    new rows = cache_num_rows();
    if (rows) {
        new vehiclemodelid, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "VID", vehiclemodelid);
            cache_get_value_name_int(loaded, "FactionID", Faction:VehicleData[vehiclemodelid][FactionID]);
            loaded++;
        }
    }
    printf("  [Vehicle Faction System] Loaded %d Vehilce's Faction Data.", rows);
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new playerid:Player) {
        if (Faction:IsPlayerSigned(playerid) && !IsPlayerPaused(playerid)) Faction:PlayerData[playerid][SingInTime]++;
    }
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "LastJoinDate", "int", "0");
    new query[1424];

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionPlayerData` (\
	  `Username` varchar(50) NOT NULL,\
	  `FactionID` int(11) NOT NULL,\
	  `LastSigned` int(11) NOT NULL,\
	  `FactionRankID` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    strcat(query, "CREATE TABLE IF NOT EXISTS `factions` (\
	  `ID` int(11) NOT NULL,\
	  `Name` varchar(50) NOT NULL default 'Not_Available',\
	  `Members_Limit` int(11) NOT NULL  default '10',\
	  `AllowJoining` int(11) NOT NULL  default '0',\
	  `Leader_Name` varchar(50) NOT NULL default '-1',\
	  `RpScoreRequired` int(11) NOT NULL default '100',\
	  `GameScoreRequired` int(11) NOT NULL default '10',\
	  `RankLimit` int(11) NOT NULL default '10',\
	  `SkinLimit` int(11) NOT NULL default '5',\
	  `WeaponLimit` int(11) NOT NULL default '10',\
	  `Faction_Wage` int(11) NOT NULL default '0',\
	  `Faction_Color` int(11) NOT NULL default '-1',");
    strcat(query, "`Faction_CP_X` float NOT NULL default '-1',\
	  `Faction_CP_Y` float NOT NULL default '-1',\
	  `Faction_CP_Z` float NOT NULL default '-1',\
	  `Faction_CP_VW` int(11) NOT NULL default '-1',\
	  `Faction_CP_INT` int(11) NOT NULL default '-1',\
	  `MinX` float NOT NULL default '0',\
	  `MinY` float NOT NULL default '0',\
	  `MaxX` float NOT NULL default '1',\
	  `MaxY` float NOT NULL default '1',\
	  `ZColor` int(11) NOT NULL default '0',\
	  `NColor` int(11) NOT NULL default '0',\
	  `BColor` int(11) NOT NULL default '0',\
	  PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionRank` (\
	  `FactionID` int(11) NOT NULL,\
	  `Faction_RankID` int(11) NOT NULL,\
	  `Wage` int(11) NOT NULL default 1,\
	  `Name` varchar(50) NOT NULL default 'Not_Available'\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionSkinData` (\
	  `FactionID` int(11) NOT NULL,\
	  `Faction_SkinID_Slot` int(11) NOT NULL,\
	  `SkinID` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionWeaponData` (\
	  `FactionID` int(11) NOT NULL,\
	  `Faction_WeaponID_Slot` int(11) NOT NULL,\
	  `WeaponID` int(11) NOT NULL,\
	  `WeaponBullet` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionVehicleData` (\
	  `VID` int(11) NOT NULL,\
	  `FactionID` int(11) NOT NULL,\
	  PRIMARY KEY (`VID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    for (new i = 400; i <= 611; i++) {
        mysql_format(Database, query, sizeof(query), "INSERT IGNORE INTO `factionVehicleData`(`VID`, `FactionID`) VALUES ('%d','-1')", i);
        mysql_tquery(Database, query);
    }

    mysql_tquery(Database, "select * from factions", "LoadFactionsData", "");
    mysql_tquery(Database, "select * from factionRank", "LoadFactionRanks", "");
    mysql_tquery(Database, "select * from factionSkinData", "LoadFactionSkins", "");
    mysql_tquery(Database, "select * from factionWeaponData", "LoadFactionWeapons", "");
    mysql_tquery(Database, "select * from factionVehicleData", "LoadFactionVehicleData", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new factionid:factions) {
        DestroyZoneNumber(Faction:Data[factionid][ZoneID]);
        DestroyZoneBorders(Faction:Data[factionid][ZoneID]);
        DestroyZone(Faction:Data[factionid][ZoneID]);
    }
    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    foreach(new i:factions) {
        if (pickupid == Faction:Data[i][Faction_CP_ID]) {
            Faction:ShowLocker(playerid, i);
        }
    }
    return 1;
}

stock Faction:GetVehicleFaction(vehicleid) {
    new Model = GetVehicleModel(vehicleid);
    return Faction:VehicleData[Model][FactionID];
}

stock Faction:IsValidID(factionid) {
    return Iter_Contains(factions, factionid);
}

stock Faction:GetSkinLimit(factionid) {
    return Faction:Data[factionid][SkinLimit];
}

stock Faction:GetWeaponLimit(factionid) {
    return Faction:Data[factionid][WeaponLimit];
}

stock Faction:GetWeaponBySlot(factionid, slot) {
    return Faction:WeaponData[factionid][slot][WeaponID];
}

stock Faction:GetWeaponSlotAmmo(factionid, slot) {
    return Faction:WeaponData[factionid][slot][WeaponBullet];
}

stock Faction:GetSkinBySlot(factionid, slot) {
    return Faction:SkinData[factionid][slot][SkinID];
}

stock Faction:GetRankLimit(factionid) {
    return Faction:Data[factionid][RankLimit];
}

stock Faction:GetMemberLimit(factionid) {
    return Faction:Data[factionid][Members_Limit];
}

new isPlayerTakingTestFaction[MAX_PLAYERS];

stock Faction:SignOff(playerid) {
    if (Faction:GetPlayerFID(playerid) == -1) return 1;
    if (!Faction:IsPlayerSigned(playerid)) return 1;
    new factionid = Faction:GetPlayerFID(playerid);
    new playerFactionRankID = Faction:GetPlayerRankID(playerid);
    new vaultid = Faction:Data[factionid][vaultID];
    new wage = Faction:RankData[factionid][playerFactionRankID][rank_wage];
    if (wage != 0 && vault:isValidID(vaultid)) {
        new total_mins = Faction:PlayerData[playerid][SingInTime];
        if (total_mins != 0) {
            new cash = total_mins * wage;
            if (vault:getBalance(vaultid) < cash) {
                AlexaMsg(playerid, "salary is not provided because faction vault does not have enough cash", Faction:GetName(factionid));
            } else {
                AlexaMsg(playerid, sprintf("you are paid with $%s for serving you faction since %d mins", FormatCurrency(cash), total_mins), Faction:GetName(factionid));
                if (GetPlayerVIPLevel(playerid) > 0) {
                    GivePlayerCash(playerid, cash * 2, "earned from faction");
                    vault:addcash(vaultid, -cash * 2, Vault_Transaction_Vault_To_Cash, sprintf("paid salary to %s for faction %s", GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))));
                    Show2xVIPEarn(playerid);
                } else {
                    GivePlayerCash(playerid, cash, "earned from faction");
                    vault:addcash(vaultid, -cash, Vault_Transaction_Vault_To_Cash, sprintf("paid salary to %s for faction %s", GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))));
                }
            }
        }
    }
    Faction:SetPlayerSigned(playerid, false);
    SetPlayerSkinEx(playerid, Faction:PlayerData[playerid][LastSkin]);
    // ResetPlayerWeaponsEx(playerid);
    // for (new wp = 0; wp <= 12; wp++) GivePlayerWeaponEx(playerid, FactionPlayerWeapons[playerid][wp][0], FactionPlayerWeapons[playerid][wp][1]);
    SetPlayerColor(playerid, Player_Color);
    AlexaMsg(playerid, "you are now signed out", Faction:GetName(factionid));
    return 1;
}

stock Faction:GetJoiningState(factionid) {
    return Faction:Data[factionid][AllowJoining];
}

stock Faction:EnableDisableAutoJoin(playerid, factionid) {
    if (!Faction:IsValidID(factionid)) return AlexaMsg(playerid, "invalid faction id");
    if (Faction:Data[factionid][AllowJoining] == 0) {
        Faction:Data[factionid][AllowJoining] = 1;
        AlexaMsg(playerid, "auto joining allowed for this faction");
        AlexaMsg(playerid, "players can join from faction locker automatically");
        AlexaMsg(playerid, "you can disable this function any time");
        mysql_tquery(Database, sprintf("UPDATE `factions` SET `AllowJoining`='%d' WHERE `ID` = '%d'", 1, factionid), "", "");
    } else {
        Faction:Data[factionid][AllowJoining] = 0;
        AlexaMsg(playerid, "auto joining disabled for this faction");
        AlexaMsg(playerid, "players can not join from faction locker automatically");
        AlexaMsg(playerid, "you can enable this function any time");
        mysql_tquery(Database, sprintf("UPDATE `factions` SET `AllowJoining`='%d' WHERE `ID` = '%d'", 0, factionid), "", "");
    }
    return 1;
}

hook OnPlayerDeathSpawn(playerid) {
    if (Faction:IsPlayerSigned(playerid)) Faction:SignOff(playerid);
    return 1;
}

forward FactionPlayerInit(playerid);
public FactionPlayerInit(playerid) {
    new rows = cache_num_rows();
    Faction:PlayerData[playerid][FactionID] = -1;
    Faction:PlayerData[playerid][FactionRankID] = -1;
    Faction:PlayerData[playerid][LastSkin] = 0;
    Faction:PlayerData[playerid][FactionStatus] = false;
    Faction:PlayerData[playerid][FactionRequestID] = -1;
    if (rows) {
        if (rows) {
            cache_get_value_name_int(0, "FactionID", Faction:PlayerData[playerid][FactionID]);
            cache_get_value_name_int(0, "FactionRankID", Faction:PlayerData[playerid][FactionRankID]);
        }
    } else {
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO factionPlayerData SET Username=\"%s\", FactionID = -1, FactionRankID = -1", GetPlayerNameEx(playerid));
        mysql_tquery(Database, query);
    }
    return 1;
}

stock Faction:GetAccountFaction(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select * from factionPlayerData where username = \"%s\"", username));
    new factionid = 0;
    cache_get_value_name_int(0, "FactionID", factionid);
    cache_delete(result);
    return factionid;
}

stock Faction:GetAccountFactionRank(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select * from factionPlayerData where username = \"%s\"", username));
    new rankid = 0;
    cache_get_value_name_int(0, "FactionRankID", rankid);
    cache_delete(result);
    return rankid;
}

stock Faction:JoinLeaveLog(const username[], factionid, rankid, bool:type) {
    new DB_Query[512];
    format(
        DB_Query, sizeof DB_Query,
        "insert into factionJoinLeave (username, factionid, rankid, createdAt, type) values (\"%s\", %d, %d, %d, %d)",
        username, factionid, rankid, gettime(), type
    );
    mysql_tquery(Database, DB_Query);
    return 1;
}

stock Faction:UpdatePlayerData(playerid) {
    new DB_Query[512];
    format(DB_Query, sizeof DB_Query, "UPDATE `factionPlayerData` SET `FactionID`='%d', `FactionRankID`='%d' WHERE `Username` = \"%s\" LIMIT 1", Faction:PlayerData[playerid][FactionID], Faction:PlayerData[playerid][FactionRankID], GetPlayerNameEx(playerid));
    mysql_tquery(Database, DB_Query);
    return 1;
}

stock Faction:RemovePlayerFaction(playerid, targetid) {
    if (!IsPlayerConnected(targetid) || Faction:GetPlayerFID(targetid) == -1) return AlexaMsg(playerid, "unable to remove player from his faction");
    new factionid = Faction:GetPlayerFID(targetid);
    if (Faction:IsPlayerSigned(targetid)) Faction:SignOff(targetid);
    Faction:SetPlayer(targetid, -1, -1);
    AlexaMsg(playerid, sprintf("%s removed from his faction", GetPlayerNameEx(targetid)), Faction:GetName(factionid));
    AlexaMsg(targetid, sprintf("%s removed you from faction", GetPlayerNameEx(playerid)), Faction:GetName(factionid));
    return 1;
}

stock Faction:ShowZoneToPlayer(playerid) {
    foreach(new i:factions) ShowZoneForPlayer(playerid, Faction:Data[i][ZoneID], Faction:Data[i][ZColor], Faction:Data[i][NColor], Faction:Data[i][BColor]);
    return 1;
}

stock Faction:HideZoneToPlayer(playerid) {
    foreach(new i:factions) HideZoneForPlayer(playerid, Faction:Data[i][ZoneID]);
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    isPlayerTakingTestFaction[playerid] = -1;
    Faction:ShowZoneToPlayer(playerid);
    new query[512];
    mysql_format(Database, query, sizeof(query), "SELECT * FROM `factionPlayerData` WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "FactionPlayerInit", "i", playerid);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_DRIVER) {
        new factionid = Faction:GetVehicleFaction(GetPlayerVehicleID(playerid));
        if (factionid != Faction:GetPlayerFID(playerid) && factionid != -1) {
            RemovePlayerFromVehicle(playerid);
            AlexaMsg(playerid, "you are not authorize to access this vehicle", Faction:GetName(factionid), "4286f4", "e9967a");
        }
        if (factionid == Faction:GetPlayerFID(playerid) && !Faction:IsPlayerSigned(playerid) && factionid != -1) {
            RemovePlayerFromVehicle(playerid);
            AlexaMsg(playerid, "you need to sign in to access this vehicle", Faction:GetName(factionid), "4286f4", "e9967a");
        }
    }
    return 1;
}

stock Faction:GetPlayerFID(playerid) {
    return Faction:PlayerData[playerid][FactionID];
}

stock Faction:GetPlayerRankID(playerid) {
    return Faction:PlayerData[playerid][FactionRankID];
}

stock Faction:SetPlayer(playerid, factionid, rankid) {
    new bool:isFactionChange = factionid != Faction:PlayerData[playerid][FactionID];
    new bool:isRankChange = rankid != Faction:PlayerData[playerid][FactionRankID];
    if (!isFactionChange && !isRankChange) return 1;
    if (isFactionChange && Faction:PlayerData[playerid][FactionID] != -1) {
        Faction:JoinLeaveLog(GetPlayerNameEx(playerid), Faction:PlayerData[playerid][FactionID], Faction:PlayerData[playerid][FactionRankID], false);
    }
    if (isFactionChange && factionid != -1) {
        Faction:JoinLeaveLog(GetPlayerNameEx(playerid), factionid, rankid, true);
    }
    Faction:PlayerData[playerid][FactionID] = factionid;
    Faction:PlayerData[playerid][FactionRankID] = rankid;
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "LastJoinDate");
    Faction:UpdatePlayerData(playerid);
    return 1;
}

stock Faction:SetAccount(const username[], factionid, rankid) {
    new oFactionId = Faction:GetAccountFaction(username);
    new oRankId = Faction:GetAccountFactionRank(username);

    new bool:isFactionChange = factionid != oFactionId;
    new bool:isRankChange = rankid != oRankId;
    if (!isFactionChange && !isRankChange) return 1;
    if (isFactionChange && oFactionId != -1) {
        Faction:JoinLeaveLog(username, oFactionId, oRankId, false);
    }
    if (isFactionChange && factionid != -1) {
        Faction:JoinLeaveLog(username, factionid, rankid, true);
    }
    mysql_tquery(Database, sprintf("update `playerdata` set LastJoinDate = %d WHERE `username` = \"%s\"", gettime(), username));
    mysql_tquery(Database, sprintf("update `factionPlayerData` set FactionID = %d, FactionRankID = %d WHERE `username` = \"%s\"", factionid, rankid, username));
    return 1;
}

stock Faction:GetColor(factionid) {
    return Faction:Data[factionid][Faction_Color];
}

stock Faction:IsPlayerSigned(playerid) {
    return Faction:PlayerData[playerid][FactionStatus];
}

stock Faction:SetPlayerSigned(playerid, bool:status) {
    Faction:PlayerData[playerid][FactionStatus] = status;
    return 1;
}

stock Faction:GetPlayerRequestID(playerid) {
    return Faction:PlayerData[playerid][FactionRequestID];
}

stock Faction:SetPlayerRequestID(playerid, factionid) {
    Faction:PlayerData[playerid][FactionRequestID] = factionid;
    return 1;
}

stock Faction:GetPlayerRequestCount(factionid) {
    new count = 0;
    foreach(new i:Player) {
        if (Faction:GetPlayerRequestID(i) == factionid) count++;
    }
    return count;
}

stock Faction:GetLeaderName(factionid) {
    new string[50];
    format(string, sizeof string, "%s", Faction:Data[factionid][Leader_Name]);
    return string;
}

stock Faction:IsPlayerLeader(playerid, factionid) {
    if (IsStringSame(Faction:GetLeaderName(factionid), GetPlayerNameEx(playerid))) return 1;
    return 0;
}

stock Faction:GetLeaderID(factionid) {
    foreach(new i:Player) {
        if (IsStringSame(Faction:GetLeaderName(factionid), GetPlayerNameEx(i))) return i;
    }
    return -1;
}

stock Faction:GetMemberCount(factionid) {
    new query[148];
    format(query, sizeof query, "select * from factionPlayerData where `FactionID` = '%d'", factionid);
    new rows, Cache:result = mysql_query(Database, query);
    rows = cache_num_rows();
    cache_delete(result);
    return rows;
}

stock Faction:GetName(factionid) {
    new string[50] = "Unknown";
    if (factionid < 0) return string;
    format(string, sizeof string, "%s", Faction:Data[factionid][Name]);
    return string;
}

stock Faction:GetFactionID(factionid) {
    return Faction:Data[factionid][ID];
}

stock Faction:GetFactionRequiredRP(factionid) {
    return Faction:Data[factionid][RpScoreRequired];
}

stock Faction:GetFactionRequiredScore(factionid) {
    return Faction:Data[factionid][GameScoreRequired];
}

stock Faction:GetWage(factionid) {
    return Faction:Data[factionid][Faction_Wage];
}

stock Faction:GetVaultID(factionid) {
    return Faction:Data[factionid][vaultID];
}

stock Faction:GetRankName(factionid, rankid) {
    new string[50] = "None";
    if (factionid < 0) return string;
    format(string, sizeof string, "%s", Faction:RankData[factionid][rankid][Name]);
    return string;
}

stock Faction:GetRankWage(factionid, rankid) {
    return Faction:RankData[factionid][rankid][rank_wage];
}

stock Faction:FactionPullOver(playerid, targetid = -1) {
    new factionid = Faction:GetPlayerFID(playerid);
    if (factionid == -1) return 0;
    if (!Faction:IsPlayerSigned(playerid)) return AlexaMsg(playerid, "you must be signed on your faction to use this command", "Usage");
    new Float:x, Float:y, Float:z, bool:sucs = false, count = 0;
    GetPlayerPos(playerid, x, y, z);
    if (IsPlayerConnected(targetid)) {
        if (IsPlayerInRangeOfPoint(targetid, 100, x, y, z) && targetid != playerid) {
            AlexaMsg(
                targetid, "pull over immediately", Faction:GetName(factionid),
                sprintf("%06x", Faction:GetColor(factionid) >>> 8),
                "2100ff"
            );
            GameTextForPlayer(targetid, "~w~Pull ~r~Over", 3000, 3);
            count++;
            sucs = true;
        }
    } else {
        foreach(new i:Player) {
            if (IsPlayerInRangeOfPoint(i, 50, x, y, z) && i != playerid && Faction:GetPlayerFID(i) != factionid) {
                AlexaMsg(
                    i, "pull over immediately", Faction:GetName(factionid),
                    sprintf("%06x", Faction:GetColor(factionid) >>> 8),
                    "2100ff"
                );
                GameTextForPlayer(i, "~w~Pull ~r~Over", 3000, 3);
                count++;
                sucs = true;
            }
        }
    }
    if (!sucs) AlexaMsg(playerid, "No Player around you", Faction:GetName(factionid), sprintf("%06x", Faction:GetColor(factionid) >>> 8), "2100ff");
    else AlexaMsg(playerid, sprintf("pull over broadcasted to %d players", count), Faction:GetName(factionid), sprintf("%06x", Faction:GetColor(factionid) >>> 8), "2100ff");
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringSame("factions", cmd) && (GetPlayerVIPLevel(playerid) > 0 || GetPlayerAdminLevel(playerid) > 0)) {
        Faction:MenuList(playerid);
        return ~1;
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Leader_Name` = \"%s\" WHERE  `Leader_Name` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `factionPlayerData` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `factions` WHERE `Leader_Name` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `factionPlayerData` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid == 5) return Faction:MenuList(playerid);
    if (shopid == 7) return Faction:ShowLocker(playerid, 0);
    if (shopid == 8) return Faction:ShowLocker(playerid, 1);
    if (shopid == 9) return Faction:ShowLocker(playerid, 2);
    if (shopid == 10) return Faction:ShowLocker(playerid, 3);
    if (shopid == 11) return Faction:ShowLocker(playerid, 4);
    if (shopid == 12) return Faction:ShowLocker(playerid, 5);
    if (shopid == 13) return Faction:ShowLocker(playerid, 6);
    if (shopid == 14) return Faction:ShowLocker(playerid, 7);
    if (shopid == 15) return Faction:ShowLocker(playerid, 8);
    if (shopid == 16) return Faction:ShowLocker(playerid, 9);
    if (shopid == 23) return Faction:ShowLocker(playerid, 10);
    if (shopid == 39) return Faction:ShowLocker(playerid, 11);
    if (shopid == 40) return Faction:ShowLocker(playerid, 12);
    if (shopid == 41) return Faction:ShowLocker(playerid, 13);
    return 1;
}

DC_CMD:removefaction(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50];
    if (sscanf(params, "s[50]", Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !removefaction [Account]");
    if (!IsValidAccount(Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    new factionid = Faction:GetAccountFaction(Account);
    if (factionid == -1) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player is not in any faction");
    if (!IsPlayerInServerByName(Account)) {
        Email:Send(ALERT_TYPE_FACTION, Account, "You are removed from faction by server management", "update from your faction.-n--n-you have been removed from faction by your server management. you can contact server management for further informations.-n--n-Thank you!!");
    }
    foreach(new playerid:Player) {
        if (IsStringSame(GetPlayerNameEx(playerid), Account)) {
            if (Faction:GetPlayerFID(playerid) == -1) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player does not have any faction");
            Faction:SetPlayer(playerid, -1, -1);
            AlexaMsg(playerid, "your faction has been removed");
            return DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s removed from his faction", Account));
        }
    }
    Faction:SetAccount(Account, -1, -1);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s offline removed from his faction", Account));
    return 1;
}

DC_CMD:setfaction(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], factionid, rankid;
    if (sscanf(params, "s[50]dd", Account, factionid, rankid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !setfaction [Account] [factionid] [rankid]");
    if (!IsValidAccount(Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (!Iter_Contains(factions, factionid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: invalid factionid");
    new oFactionId = Faction:GetAccountFaction(Account);
    new oRankId = Faction:GetAccountFactionRank(Account);
    if (oFactionId == factionid && oRankId == rankid) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Player is already in this faction and rank");
    if (rankid < 1 || rankid > Faction:Data[factionid][RankLimit]) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: invalid rankid");
    if (oFactionId != factionid && Faction:GetMemberCount(factionid) == Faction:Data[factionid][Members_Limit]) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Faction Reached it's maximum Limit");
    if (!IsPlayerInServerByName(Account)) {
        Email:Send(ALERT_TYPE_FACTION, Account, sprintf("Welcome to %s", Faction:GetName(factionid)),
            sprintf("Welcome to %s.-n--n-server management has assigned you %s rank. you can now sign in your faction.-n--n-Thank you!!", Faction:GetName(factionid), Faction:GetRankName(factionid, rankid)));
    }
    foreach(new playerid:Player) {
        if (IsStringSame(GetPlayerNameEx(playerid), Account)) {
            if (Faction:PlayerData[playerid][FactionID] == factionid) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Player Already in this Faction");
            Faction:SetPlayer(playerid, factionid, rankid);
            AlexaMsg(
                playerid,
                sprintf("your faction now {FFCC66}%s{FFFFFF} with rank {FFCC66}%s", Faction:GetName(factionid), Faction:GetRankName(factionid, rankid))
            );
            return DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s faction updated to %s [%d] with rank %s", Account, Faction:GetName(factionid), factionid, Faction:GetRankName(factionid, rankid)));
        }
    }
    Faction:SetAccount(Account, factionid, rankid);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s offline faction updated to %s [%d] with rank %s", Account, Faction:GetName(factionid), factionid, Faction:GetRankName(factionid, rankid)));
    return 1;
}

stock Faction:ShowDirectJoin(playerid, factionid) {
    if (Faction:Data[factionid][AllowJoining] == 0) return AlexaMsg(playerid, "We are not accepting direct applications. contact faction leader.", Faction:GetName(factionid));
    new astring[1000];
    strcat(astring, "Do you want to join this faction?\n\n", sizeof astring);
    strcat(astring, "once you have joined this faction, then you can not leave it for next 7 days\n", sizeof astring);
    strcat(astring, "if you need more time to decide your faction then cancel this opportunity\n", sizeof astring);
    return FlexPlayerDialog(
        playerid, "FactionShowDirectJoin", DIALOG_STYLE_MSGBOX,
        sprintf("{4286f4}[%s]: {FFFFFF}Apply for faction", Faction:GetName(factionid)),
        astring, "Apply", "Cancel", factionid
    );
}

FlexDialog:FactionShowDirectJoin(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return AlexaMsg(playerid, "Your request to join the faction is rejected, please try later or contact leader", Faction:GetName(factionid));
    if (GetPlayerRpScore(playerid) < Faction:GetFactionRequiredRP(factionid)) return AlexaMsg(playerid,
        sprintf(
            "Your request to join the faction is rejected, because you need %d rp score", Faction:GetFactionRequiredRP(factionid)
        ), Faction:GetName(factionid)
    );

    if (GetPlayerRpScore(playerid) < Faction:GetFactionRequiredScore(factionid)) return AlexaMsg(playerid,
        sprintf(
            "Your request to join the faction is rejected, because minimum %d score is required to apply", Faction:GetFactionRequiredScore(factionid)
        ), Faction:GetName(factionid)
    );

    if (Faction:GetMemberCount(factionid) == Faction:GetMemberLimit(factionid))
        return AlexaMsg(playerid, "Your request to join the faction is rejected, because faction is at it's full capacity", Faction:GetName(factionid));

    isPlayerTakingTestFaction[playerid] = factionid;
    return startRoleplayTest(playerid);
}

hook OnRoleplayTestResult(playerid, bool:result) {
    if (isPlayerTakingTestFaction[playerid] == -1) return 1;
    new factionid = isPlayerTakingTestFaction[playerid];
    if (result) {
        Faction:SetPlayer(playerid, factionid, Faction:GetRankLimit(factionid));
        AlexaMsg(
            playerid, sprintf(
                "Your request to join the faction is accepted, your rank is %s and your wage is $%s/hour",
                Faction:GetRankName(factionid, Faction:GetRankLimit(factionid)), FormatCurrency(Faction:GetRankWage(factionid, Faction:GetRankLimit(factionid)) * 60)
            ), Faction:GetName(factionid)
        );
        return Faction:ShowLocker(playerid, factionid);
    } else AlexaMsg(playerid, "you have failed the roleplay test to join faction");
    isPlayerTakingTestFaction[playerid] = -1;
    return 1;
}

stock Faction:MenuList(playerid) {
    new string[2000];
    strcat(string, "{FFCC66}ID\tName\tLeader\tMember Count\n");
    foreach(new i:factions) {
        strcat(
            string, sprintf(
                "{FFCC66}%d\t%s\t%s\t%d\n",
                Faction:GetFactionID(i),
                Faction:GetName(i),
                Faction:GetLeaderName(i),
                Faction:GetMemberCount(i)
            )
        );
    }
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Create\tFaction\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Globel\tVehicle\tFaction\n");
    return FlexPlayerDialog(playerid, "FactionMenuList", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Faction System]: {FFFFFF}Factions List", string, "select", "cancel");
}

FlexDialog:FactionMenuList(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create")) return Faction:MenuAdminCreate(playerid);
    if (IsStringSame(inputtext, "Globel")) return Faction:MenuAdminVehicle(playerid);
    new factionid = strval(inputtext);
    return Faction:ListOptions(playerid, factionid);
}

stock Faction:ListOptions(playerid, factionid) {
    new string[1024];
    if (Faction:GetMemberCount(factionid) > 0) strcat(string, "See list of faction players\n");
    if (Faction:GetPlayerFID(playerid) == -1 && Faction:GetPlayerRequestID(playerid) == -1) strcat(string, "Apply for joining the faction\n");
    if ((Faction:GetLeaderID(factionid) == playerid || GetPlayerAdminLevel(playerid) == 10) && Faction:GetPlayerRequestCount(factionid) > 0) strcat(string, "Accept the request of players\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Manage Faction\n");
    if (!strlen(string)) return Faction:MenuList(playerid);
    return FlexPlayerDialog(
        playerid, "FactionListOptions", DIALOG_STYLE_LIST,
        sprintf("{F1C40F}%s: {FFFFFF}Members", Faction:GetName(factionid)),
        string, "Select", "Close", factionid
    );
}

FlexDialog:FactionListOptions(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuList(playerid);
    if (IsStringSame(inputtext, "Manage Faction")) return Faction:MenuAdminManage(playerid, factionid);
    if (IsStringSame(inputtext, "See list of faction players")) return Faction:ShowMemberList(playerid, factionid, false);
    if (IsStringSame(inputtext, "Accept the request of players")) return Faction:MenuAcceptJoining(playerid, factionid);
    if (IsStringSame(inputtext, "Apply for joining the faction")) {
        new leaderid = Faction:GetLeaderID(factionid);
        if (!IsPlayerConnected(leaderid)) {
            AlexaMsg(playerid, "Faction Leader not available at this time, try again", Faction:GetName(factionid));
            return Faction:ListOptions(playerid, factionid);
        }
        Faction:SetPlayerRequestID(playerid, factionid);
        AlexaMsg(
            leaderid,
            sprintf("%s requested to join your faction, please respond to his request", GetPlayerNameEx(playerid)),
            Faction:GetName(factionid)
        );
        AlexaMsg(
            playerid,
            "Request sent to leader of the faction, please wait for the response",
            Faction:GetName(factionid)
        );
        return 1;
    }
    return 1;
}

stock Faction:MenuAcceptJoining(playerid, factionid) {
    new string[2000];
    strcat(string, "ID\tName\tScore\n");
    new count = 0;
    foreach(new i:Player) {
        if (Faction:GetPlayerRequestID(i) == factionid) {
            strcat(string, sprintf("%d\t%s\t%d\n", i, GetPlayerNameEx(i), GetPlayerScore(i)));
            count++;
        }
    }
    if (!count) {
        AlexaMsg(playerid, "there are no requests to accept");
        return Faction:ListOptions(playerid, factionid);
    }
    return FlexPlayerDialog(playerid, "FactionMenuAcceptJoining", DIALOG_STYLE_TABLIST_HEADERS, Faction:GetName(factionid), string, "Select", "Close", factionid);
}

FlexDialog:FactionMenuAcceptJoining(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ListOptions(playerid, factionid);
    new targetid = strval(inputtext);
    new string[512];
    strcat(string, "Accept\n");
    strcat(string, "Reject\n");
    return FlexPlayerDialog(playerid, "FactionMenuAcceptJoinRes", DIALOG_STYLE_LIST, Faction:GetName(factionid), string, "Select", "Close", factionid, sprintf("%d", targetid));
}

FlexDialog:FactionMenuAcceptJoinRes(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new targetid = strval(payload);
    if (!response || !IsPlayerConnected(targetid)) return Faction:MenuAcceptJoining(playerid, factionid);
    if (IsStringSame(inputtext, "Accept")) {
        new string[2000];
        strcat(string, "RankID\tRankName\tWage\n");
        for (new rankid = 1; rankid <= Faction:GetRankLimit(factionid); rankid++) {
            strcat(string, sprintf("%d\t%s\t%d\n", rankid, Faction:GetRankName(factionid, rankid), Faction:GetRankWage(factionid, rankid)));
        }
        return FlexPlayerDialog(playerid, "FactionRequestAccept", DIALOG_STYLE_TABLIST_HEADERS, Faction:GetName(factionid), string, "Select", "Close", factionid, payload);
    }
    if (IsStringSame(inputtext, "Reject")) {
        Faction:SetPlayerRequestID(targetid, -1);
        AlexaMsg(playerid, "your request to join the faction was rejected", Faction:GetName(factionid));
        return Faction:MenuAcceptJoining(playerid, factionid);
    }
    return Faction:MenuAcceptJoining(playerid, factionid);
}

FlexDialog:FactionRequestAccept(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new targetid = strval(payload);
    if (!response || !IsPlayerConnected(targetid)) return Faction:MenuAcceptJoining(playerid, factionid);
    new rankid = strval(inputtext);
    Faction:SetPlayerRequestID(targetid, -1);
    Faction:SetPlayer(targetid, factionid, rankid);
    AlexaMsg(
        targetid, sprintf(
            "Your request to join the faction is accepted, your rank is %s and your wage is $%s/hour",
            Faction:GetRankName(factionid, rankid), FormatCurrency(Faction:GetRankWage(factionid, rankid) * 60)
        ), Faction:GetName(factionid)
    );
    AlexaMsg(
        playerid, sprintf(
            "Your have accepted %s in faction, his/her rank is %s and wage is $%s/hour",
            GetPlayerNameEx(targetid), Faction:GetRankName(factionid, rankid), FormatCurrency(Faction:GetRankWage(factionid, rankid) * 60)
        ), Faction:GetName(factionid)
    );
    return Faction:MenuAcceptJoining(playerid, factionid);
}

stock Faction:ShowMemberList(playerid, factionid, bool:locker = false) {
    if (!Iter_Contains(factions, factionid)) return 1;
    if (Faction:GetMemberCount(factionid) < 1) return 1;
    new query[256], Cache:result, string[2000];
    mysql_format(Database, query, sizeof query, "select Username, FactionRankID, FROM_UNIXTIME(LastSigned, '%%d/%%m/%%Y %%H:%%i:%%s') AS Last from factionPlayerData where FactionID=%d order by FactionRankID", factionid);
    result = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(result);
        AlexaMsg(playerid, "there are no members in this faction", Faction:GetName(factionid));
        if (locker) return Faction:ShowLocker(playerid, factionid);
        return Faction:MenuList(playerid);
    }

    new pName[50], rankid, lastSigned[100];
    strcat(string, "Name\tRank\tLast Signed On\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name(i, "Username", pName, 50);
        cache_get_value_name(i, "Last", lastSigned, 100);
        cache_get_value_name_int(i, "FactionRankID", rankid);
        strcat(string, sprintf("{FFFFFF}%s\t{2ECC71}%s\t%s\n\n", pName, Faction:GetRankName(factionid, rankid), lastSigned));
    }
    cache_delete(result);
    return FlexPlayerDialog(playerid, "FactionMenuMemberOption", DIALOG_STYLE_TABLIST_HEADERS, Faction:GetName(factionid), string, "Select", "Close", factionid, sprintf("%d", locker));
}

FlexDialog:FactionMenuMemberOption(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new isLocker = strval(payload);
    if (!response || (GetPlayerAdminLevel(playerid) < 8 && !Faction:IsPlayerLeader(playerid, factionid))) {
        if (isLocker) return Faction:ShowLocker(playerid, factionid);
        return Faction:MenuList(playerid);
    }
    new string[512];
    strcat(string, "Change Rank\n");
    strcat(string, "Remove From Faction\n");
    return FlexPlayerDialog(
        playerid, "FactionMemberOptionRes", DIALOG_STYLE_LIST, Faction:GetName(factionid), string, "Select", "Close", factionid, sprintf("%d %s", isLocker, inputtext)
    );
}

FlexDialog:FactionMemberOptionRes(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new isLocker, username[100];
    sscanf(payload, "ds[100]", isLocker, username);
    if (response) {
        if (IsStringSame(inputtext, "Change Rank")) {
            new string[2000];
            strcat(string, "RankID\tRankName\tWage\n");
            for (new rankid = 1; rankid <= Faction:GetRankLimit(factionid); rankid++) {
                strcat(string, sprintf("%d\t%s\t%d\n", rankid, Faction:GetRankName(factionid, rankid), Faction:GetRankWage(factionid, rankid)));
            }
            return FlexPlayerDialog(playerid, "FactionChangeRank", DIALOG_STYLE_TABLIST_HEADERS, Faction:GetName(factionid), string, "Select", "Close", factionid, payload);
        }
        if (IsStringSame(inputtext, "Remove From Faction")) {
            mysql_tquery(Database, sprintf("UPDATE `factionPlayerData` SET `FactionID`='-1', `FactionRankID`='-1' WHERE `Username` = \"%s\" LIMIT 1", username));
            AlexaMsg(playerid, sprintf("you have removed %s from faction", username), Faction:GetName(factionid));
            if (!IsPlayerInServerByName(username)) {
                Email:Send(
                    ALERT_TYPE_FACTION, username, "You are removed from faction by faction leader",
                    sprintf(
                        "update from %s.-n--n-you have been removed from faction by your faction leader. you can contact your faction leader for further informations.-n--n-Thank you!!",
                        Faction:GetName(factionid)
                    )
                );
            }
            foreach(new i:Player) {
                if (IsStringSame(GetPlayerNameEx(i), username)) {
                    Faction:RemovePlayerFaction(i, playerid);
                    break;
                }
            }
        }
    }
    if (isLocker) return Faction:ShowLocker(playerid, factionid);
    return Faction:MenuList(playerid);
}

FlexDialog:FactionChangeRank(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new bool:isLocker, username[100];
    sscanf(payload, "ds[100]", isLocker, username);
    if (!response) return Faction:ShowMemberList(playerid, factionid, isLocker);
    new rankid = strval(inputtext);
    mysql_tquery(Database, sprintf("UPDATE `factionPlayerData` SET `FactionRankID`='%d' WHERE `Username`=\"%s\" AND `FactionID`='%d' LIMIT 1", rankid, username, factionid));
    AlexaMsg(playerid, sprintf("You have changed %s rank to %s", username, Faction:GetRankName(factionid, rankid)), Faction:GetName(factionid));
    if (!IsPlayerInServerByName(username)) {
        Email:Send(
            ALERT_TYPE_FACTION, username, "Your faction rank has been updated.",
            sprintf(
                "update from %s.-n--n-your rank has been updated to %s by your faction leader.-n--n-Thank you!!",
                Faction:GetName(factionid),
                Faction:GetRankName(factionid, rankid)
            )
        );
    }
    foreach(new i:Player) {
        if (IsStringSame(GetPlayerNameEx(i), username)) {
            Faction:PlayerData[i][FactionID] = factionid;
            Faction:PlayerData[i][FactionRankID] = rankid;
            AlexaMsg(i, sprintf("your rank changed to %s by faction leader", Faction:GetRankName(factionid, rankid)), Faction:GetName(factionid));
            break;
        }
    }
    return Faction:ShowMemberList(playerid, factionid, isLocker);
}

stock Faction:ShowLocker(playerid, factionid) {
    if (!Faction:IsValidID(factionid)) return AlexaMsg(playerid, "you are not in any faction.");
    if (Faction:GetPlayerFID(playerid) != factionid) {
        if (Faction:GetPlayerFID(playerid) == -1) return Faction:ShowDirectJoin(playerid, factionid);
        return AlexaMsg(playerid, "You are not member of faction", Faction:GetName(factionid));
    }

    new string[1024];
    if (Faction:IsPlayerSigned(playerid)) {
        new allowedFactions[] = { 0, 1, 2, 3, 4 };
        if (IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid))) strcat(string, "Take Taser\n");
        // strcat(string, "Armour, Health, Weapon's\n");
        strcat(string, "Sign OFF\n");
        if (IsStringSame(GetPlayerNameEx(playerid), Faction:GetLeaderName(factionid)) || GetPlayerAdminLevel(playerid) == 10) strcat(string, "Enable/Disable Auto Join\n");
        if (IsStringSame(GetPlayerNameEx(playerid), Faction:GetLeaderName(factionid)) || GetPlayerAdminLevel(playerid) == 10) strcat(string, "Manage Faction Wage\n");
        if (Faction:GetMemberCount(factionid) > 0) strcat(string, "Check Members List\n");
        if ((gettime() - Database:GetInt(GetPlayerNameEx(playerid), "username", "LastJoinDate")) > 7 * 24 * 60 * 60) strcat(string, "Resign\n");
    } else {
        strcat(string, "Sign In\n");
    }
    return FlexPlayerDialog(playerid, "FactionLockerRes", DIALOG_STYLE_LIST, sprintf("%s: Locker", Faction:GetName(factionid)), string, "Select", "Close", factionid);
}

FlexDialog:FactionLockerRes(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Sign OFF")) {
        Faction:SignOff(playerid);
        return Faction:ShowLocker(playerid, factionid);
    }
    if (IsStringSame(inputtext, "Take Taser")) {
        TaserCommand(playerid);
        return Faction:ShowLocker(playerid, factionid);
    }
    if (IsStringSame(inputtext, "Enable/Disable Auto Join")) {
        Faction:EnableDisableAutoJoin(playerid, factionid);
        return Faction:ShowLocker(playerid, factionid);
    }
    if (IsStringSame(inputtext, "Sign In")) return Faction:ShowSignInMenu(playerid, factionid);
    if (IsStringSame(inputtext, "Check Members List")) return Faction:ShowMemberList(playerid, factionid, true);
    if (IsStringSame(inputtext, "Manage Faction Wage")) return Faction:ManageRankWage(playerid, factionid);
    if (IsStringSame(inputtext, "Resign")) return Faction:ShowResignMenu(playerid, factionid);
    return 1;
}

stock Faction:ShowSignInMenu(playerid, factionid) {
    if (WantedDatabase:IsInJail(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Faction System]: {FFFFFF}you can not access locker inside jail");
    if (gettime() - GetPVarInt(playerid, "PlayerLastDeath") < 5 * 60) return SendClientMessageEx(playerid, -1, "{4286f4}[Faction System]: {FFFFFF}you need wait 5 minute to sign in back because of roleplay rules");
    new string[2000];
    for (new slot = 1; slot <= Faction:GetSkinLimit(factionid); slot++) {
        strcat(string, sprintf("%d\t%s\n", Faction:GetSkinBySlot(factionid, slot), GetSkinName(Faction:GetSkinBySlot(factionid, slot))));
    }
    return FlexPlayerDialog(
        playerid, "FactionShowSignInMenu",
        IsAndroidPlayer(playerid) ? (DIALOG_STYLE_LIST) : (DIALOG_STYLE_PREVIEW_MODEL),
        "Faction:Sign IN", string, "Select", "Close", factionid
    );
}

FlexDialog:FactionShowSignInMenu(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ShowLocker(playerid, factionid);
    Faction:PlayerData[playerid][LastSkin] = GetPlayerSkin(playerid);
    Faction:PlayerData[playerid][SingInTime] = 0;
    SetPlayerSkinEx(playerid, strval(inputtext));
    Faction:SetPlayerSigned(playerid, true);
    SetPlayerColor(playerid, Faction:GetColor(factionid));
    mysql_tquery(Database, sprintf("UPDATE `factionPlayerData` SET `LastSigned`= UNIX_TIMESTAMP() WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid)));
    AlexaMsg(playerid, "You are now signed in!", Faction:GetName(factionid));
    return Faction:ShowLocker(playerid, factionid);
}

stock Faction:ShowResignMenu(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionShowResignMenu", DIALOG_STYLE_MSGBOX, "Faction: Resign", "Are you sure you want to resign from your faction?", "Yes", "No", factionid
    );
}

FlexDialog:FactionShowResignMenu(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ShowLocker(playerid, factionid);
    Faction:SetPlayerSigned(playerid, false);
    SetPlayerSkinEx(playerid, Faction:PlayerData[playerid][LastSkin]);
    SetPlayerColor(playerid, Player_Color);
    Faction:PlayerData[playerid][FactionID] = -1;
    Faction:SetPlayer(playerid, -1, -1);
    AlexaMsg(playerid, "You are no longer a member of faction", Faction:GetName(factionid));
    return 1;
}

stock Faction:ManageRankWage(playerid, factionid) {
    new string[2000];
    strcat(string, "RankID\tRankName\tWage\n");
    for (new rankid = 1; rankid <= Faction:GetRankLimit(factionid); rankid++) {
        strcat(string, sprintf(
            "%d\t%s\t$%s\n",
            rankid, Faction:GetRankName(factionid, rankid),
            FormatCurrency(Faction:GetRankWage(factionid, rankid))
        ));
    }
    return FlexPlayerDialog(playerid, "FactionManageRankWage", DIALOG_STYLE_TABLIST_HEADERS, "Manage Wage", string, "Select", "Close", factionid);
}

FlexDialog:FactionManageRankWage(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ShowLocker(playerid, factionid);
    return Faction:UpdateRankWage(playerid, factionid, strval(inputtext));
}

stock Faction:UpdateRankWage(playerid, factionid, rankid) {
    return FlexPlayerDialog(
        playerid, "FactionUpdateRankWage", DIALOG_STYLE_INPUT, "Update Rank Wage",
        sprintf(
            "Enter rank wage between $1 to $%s for rank %s (%d)\nCurrent Wage: $%s",
            FormatCurrency(Faction:GetWage(factionid)), Faction:GetRankName(factionid, rankid),
            rankid, FormatCurrency(Faction:GetRankWage(factionid, rankid))
        ), "Update", "Close", factionid, sprintf("%d", rankid)
    );
}

FlexDialog:FactionUpdateRankWage(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ManageRankWage(playerid, factionid);
    new rankid = strval(payload);
    new wage;
    if (sscanf(inputtext, "d", wage) || wage < 1 || wage > Faction:GetWage(factionid)) return Faction:UpdateRankWage(playerid, factionid, rankid);
    mysql_tquery(Database, sprintf("UPDATE `factionRank` SET `Wage`= %d WHERE `FactionID`='%d' AND`Faction_RankID`='%d'", wage, factionid, rankid));
    Faction:RankData[factionid][rankid][rank_wage] = wage;
    AlexaMsg(
        playerid, sprintf("you have set rank %s (%d) wage to $%s", Faction:GetRankName(factionid, rankid), rankid, FormatCurrency(wage)), Faction:GetName(factionid)
    );
    return Faction:ManageRankWage(playerid, factionid);
}

stock Faction:MenuAdminCreate(playerid, const alert[] = "") {
    if (strlen(alert)) AlexaMsg(playerid, alert);
    return FlexPlayerDialog(
        playerid, "FactionMenuAdminCreate", DIALOG_STYLE_INPUT, "{4286f4}[Faction System]:{FFFFEE}Create Faction", "Enter Faction Name", "Create", "Close"
    );
}

FlexDialog:FactionMenuAdminCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Faction:MenuList(playerid);
    new factionName[50];
    if (sscanf(inputtext, "s[50]", factionName)) return Faction:MenuAdminCreate(playerid, "faction name required");
    new factionid = Iter_Free(factions);
    if (factionid == INVALID_ITERATOR_SLOT) return Faction:MenuAdminCreate(playerid, "faction limit exceed, can not create more factions");
    mysql_tquery(Database, sprintf("INSERT INTO `factions`(`ID`, `Name`) VALUES ('%d',\"%s\")", factionid, factionName));
    for (new i = 1; i <= 10; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionRank`(`FactionID`, `Faction_RankID`, `Name`) VALUES ('%d','%d','Rank %d')", factionid, i, i));
        new rev[50];
        format(rev, sizeof rev, "Rank %d", i);
        Faction:RankData[factionid][i][Name] = rev;
    }
    for (new i = 1; i <= 5; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionSkinData`(`FactionID`, `Faction_SkinID_Slot`, `SkinID`) VALUES ('%d','%d','%d')", factionid, i, i));
        Faction:SkinData[factionid][i][SkinID] = i;
    }
    for (new i = 1; i <= 10; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionWeaponData`(`FactionID`, `Faction_WeaponID_Slot`, `WeaponID`, `WeaponBullet`) VALUES ('%d','%d','%d','%d')", factionid, i, 24, 24));
        Faction:WeaponData[factionid][i][WeaponID] = 24;
        Faction:WeaponData[factionid][i][WeaponBullet] = 10;
    }
    format(Faction:Data[factionid][Leader_Name], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
    Faction:Data[factionid][ID] = factionid;
    Faction:Data[factionid][Name] = factionName;
    Faction:Data[factionid][Members_Limit] = 10;
    Faction:Data[factionid][RankLimit] = 10;
    Faction:Data[factionid][SkinLimit] = 5;
    Faction:Data[factionid][WeaponLimit] = 10;
    Faction:Data[factionid][Faction_CP][0] = -1;
    Faction:Data[factionid][Faction_CP][1] = -1;
    Faction:Data[factionid][Faction_CP][2] = -1;
    Faction:Data[factionid][Faction_CP_DATA][0] = -1;
    Faction:Data[factionid][Faction_CP_DATA][1] = -1;
    Faction:Data[factionid][Faction_CP_ID] = -1;
    Faction:Data[factionid][MinX] = 0.0;
    Faction:Data[factionid][MinY] = 0.0;
    Faction:Data[factionid][MaxX] = 0.0;
    Faction:Data[factionid][MaxY] = 0.0;
    Faction:Data[factionid][ZColor] = 0;
    Faction:Data[factionid][NColor] = 0;
    Faction:Data[factionid][BColor] = 0;
    Iter_Add(factions, factionid);
    AlexaMsg(playerid, sprintf("you have created new faction name:{FFCC66}%s [%d]", factionName, factionid));
    return Faction:MenuList(playerid);
}

stock Faction:MenuAdminVehicle(playerid, const alert[] = "") {
    if (strlen(alert)) AlexaMsg(playerid, alert);
    return FlexPlayerDialog(playerid, "FactionMenuAdminVehicle", DIALOG_STYLE_INPUT, "Faction Global Vehicle", "Enter [Vehicle Model] [Faction ID]", "Submit", "Close");
}

FlexDialog:FactionMenuAdminVehicle(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Faction:MenuList(playerid);
    new modelid, factionid;
    if (sscanf(inputtext, "modelid", "factionid", modelid, factionid)) return Faction:MenuAdminVehicle(playerid);
    if (modelid < 400 || modelid > 611) return Faction:MenuAdminVehicle(playerid, "invalid model id");
    if (!Faction:IsValidID(factionid)) return Faction:MenuAdminVehicle(playerid, "invalid faction id");
    Faction:VehicleData[modelid][FactionID] = factionid;
    mysql_tquery(Database, sprintf("UPDATE `factionVehicleData` SET `FactionID`='%d' WHERE `VID`='%d'", factionid, modelid));
    AlexaMsg(playerid, sprintf("Updated Vehicle ID {FFCC66}%s (%d){FFFFFF} Faction with ID {FFCC66}%d{FFFFFF}", GetVehicleModelName(modelid), modelid, factionid));
    return Faction:MenuAdminVehicle(playerid);
}

stock Faction:MenuAdminManage(playerid, factionid) {
    new string[2000];
    strcat(string, "Action\t---\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Enable/Disable Auto Join\t%s\n", Faction:GetJoiningState(factionid) ? "Allowed" : "Not Allowed"));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Set Leader\t%s\n", Faction:GetLeaderName(factionid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Set Member Limit\t%d/%d\n", Faction:GetMemberCount(factionid), Faction:GetMemberLimit(factionid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Set Required Roleplay Score\t%d\n", Faction:GetFactionRequiredRP(factionid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Set Required Score\t%d\n", Faction:GetFactionRequiredScore(factionid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Manage Rank\t\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Manage Skin\t\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Manage Weapon\t\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Update Locker Position\t\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Update Color\t\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Update Zone Data\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, sprintf("Update Wage\t$%s\n", FormatCurrency(Faction:GetWage(factionid))));
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, sprintf("Update VaultID\t%d\n", Faction:GetVaultID(factionid)));
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Rename Faction\t\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Remove Faction\t\n");
    return FlexPlayerDialog(playerid, "FactionMenuAdminManage", DIALOG_STYLE_TABLIST_HEADERS, "Faction Manage", string, "Select", "Close", factionid);
}

FlexDialog:FactionMenuAdminManage(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:ListOptions(playerid, factionid);
    if (IsStringSame(inputtext, "Set Leader")) return Faction:AdminMenuSetLeader(playerid, factionid);
    if (IsStringSame(inputtext, "Set Member Limit")) return Faction:AdminMenuSetMemberLimit(playerid, factionid);
    if (IsStringSame(inputtext, "Set Required Roleplay Score")) return Faction:AdminMenuSetRequiredRP(playerid, factionid);
    if (IsStringSame(inputtext, "Set Required Score")) return Faction:AdminSetRequiredScore(playerid, factionid);
    if (IsStringSame(inputtext, "Manage Rank")) return Faction:AdminMenuManageRank(playerid, factionid);
    if (IsStringSame(inputtext, "Manage Skin")) return Faction:AdminMenuManageSkin(playerid, factionid);
    if (IsStringSame(inputtext, "Manage Weapon")) return Faction:AdminMenuManageWeapon(playerid, factionid);
    if (IsStringSame(inputtext, "Update Color")) return Faction:AdminMenuUpdateColor(playerid, factionid);
    if (IsStringSame(inputtext, "Update Zone Data")) return Faction:AdminMenuUpdateZoneData(playerid, factionid);
    if (IsStringSame(inputtext, "Update Wage")) return Faction:AdminMenuUpdateWage(playerid, factionid);
    if (IsStringSame(inputtext, "Update VaultID")) return Faction:AdminMenuUpdateVaultID(playerid, factionid);
    if (IsStringSame(inputtext, "Rename Faction")) return Faction:AdminMenuRenameFaction(playerid, factionid);
    if (IsStringSame(inputtext, "Enable/Disable Auto Join")) {
        Faction:EnableDisableAutoJoin(playerid, factionid);
        return Faction:MenuAdminManage(playerid, factionid);
    }
    if (IsStringSame(inputtext, "Update Locker Position")) {
        DestroyDynamicPickup(Faction:Data[factionid][Faction_CP_ID]);
        new Float:xx, Float:yy, Float:zz, vw, int;
        GetPlayerPos(playerid, xx, yy, zz);
        vw = GetPlayerVirtualWorld(playerid);
        int = GetPlayerInterior(playerid);
        Faction:Data[factionid][Faction_CP][0] = xx;
        Faction:Data[factionid][Faction_CP][1] = yy;
        Faction:Data[factionid][Faction_CP][2] = zz;
        Faction:Data[factionid][Faction_CP_DATA][0] = vw;
        Faction:Data[factionid][Faction_CP_DATA][1] = int;
        Faction:Data[factionid][Faction_CP_ID] = CreateDynamicPickup(1275, 2, Faction:Data[factionid][Faction_CP][0], Faction:Data[factionid][Faction_CP][1], Faction:Data[factionid][Faction_CP][2], Faction:Data[factionid][Faction_CP_DATA][0], Faction:Data[factionid][Faction_CP_DATA][1]);
        mysql_tquery(Database, sprintf(
            "UPDATE `factions` SET `Faction_CP_X`='%f', `Faction_CP_Y`='%f', `Faction_CP_Z`='%f', `Faction_CP_VW`='%d', `Faction_CP_INT`='%d' WHERE `ID` = '%d'",
            Faction:Data[factionid][Faction_CP][0], Faction:Data[factionid][Faction_CP][1], Faction:Data[factionid][Faction_CP][2],
            Faction:Data[factionid][Faction_CP_DATA][0], Faction:Data[factionid][Faction_CP_DATA][1], factionid
        ));
        AlexaMsg(playerid, sprintf("you have updated locker position for faction {FFCC66}%s[%d]", Faction:GetName(factionid), factionid));
        return Faction:MenuAdminManage(playerid, factionid);
    }
    if (IsStringSame(inputtext, "Remove Faction")) {
        Faction:Data[factionid][ID] = -1;
        mysql_tquery(Database, sprintf("DELETE FROM `factions` WHERE `ID` = '%d'", factionid));
        mysql_tquery(Database, sprintf("DELETE FROM `factionRank` WHERE `FactionID` = '%d'", factionid));
        Iter_Remove(factions, factionid);
        return AlexaMsg(playerid, sprintf("you have Deleted Faction {FFCC66}%s[%d]", Faction:GetName(factionid), factionid));
    }
    return 1;
}

stock Faction:AdminMenuSetLeader(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminMenuSetLeader", DIALOG_STYLE_INPUT, "Faction: Set Leader",
        sprintf("Current Leader: %s\n\nEnter new leader name", Faction:GetLeaderName(factionid)),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionAdminMenuSetLeader(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newleader[MAX_PLAYER_NAME];
    if (sscanf(inputtext, "s[24]", newleader) || !IsAccountActive(newleader)) return Faction:AdminMenuSetLeader(playerid, factionid);
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Leader_Name`=\"%s\" WHERE `ID` = '%d'", newleader, factionid));
    Faction:Data[factionid][Leader_Name] = newleader;
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) leader to %s", Faction:GetName(factionid), factionid, newleader));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuSetMemberLimit(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminSetMemberLimit", DIALOG_STYLE_INPUT, "Faction: Update Member Limit",
        sprintf(
            "Current members in faction: %d\nCurrent limit: %d\n\nEnter max member limit, default is 10",
            Faction:GetMemberCount(factionid), Faction:GetMemberLimit(factionid)
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionAdminSetMemberLimit(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new memberlimit;
    if (sscanf(inputtext, "d", memberlimit) || memberlimit < 1 || memberlimit > MAX_PLAYERS) return Faction:AdminMenuSetMemberLimit(playerid, factionid);
    Faction:Data[factionid][Members_Limit] = memberlimit;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Members_Limit`='%d' WHERE `ID` = '%d'", memberlimit, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) member limit to %d", Faction:GetName(factionid), factionid, memberlimit));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuSetRequiredRP(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminSetRequiredRP", DIALOG_STYLE_INPUT, "Faction: Update RP",
        sprintf(
            "Current required roleplay score: %d\n\nEnter new required roleplay score",
            Faction:GetFactionRequiredRP(factionid)
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionAdminSetRequiredRP(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new roleplayscore;
    if (sscanf(inputtext, "d", roleplayscore) || roleplayscore < 0) return Faction:AdminMenuSetRequiredRP(playerid, factionid);
    Faction:Data[factionid][RpScoreRequired] = roleplayscore;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `RpScoreRequired`='%d' WHERE `ID` = '%d'", roleplayscore, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) required roleplay score %d", Faction:GetName(factionid), factionid, roleplayscore));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminSetRequiredScore(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminSetScore", DIALOG_STYLE_INPUT, "Faction: Update Score",
        sprintf(
            "Current required score: %d\n\nEnter new required score",
            Faction:GetFactionRequiredScore(factionid)
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionAdminSetScore(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newscore;
    if (sscanf(inputtext, "d", newscore) || newscore < 0) return Faction:AdminSetRequiredScore(playerid, factionid);
    Faction:Data[factionid][GameScoreRequired] = newscore;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `GameScoreRequired`='%d' WHERE `ID` = '%d'", newscore, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) required score %d", Faction:GetName(factionid), factionid, newscore));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuUpdateColor(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminUpdateColor", DIALOG_STYLE_INPUT, "Faction: Update Color",
        sprintf(
            "Current color: %06x\n\nEnter new color for faction. format: 0xFFFFFFAA",
            Faction:GetColor(factionid)
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionAdminUpdateColor(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newcolor;
    if (sscanf(inputtext, "N(0xFFFFFFAA)", newcolor)) return Faction:AdminMenuUpdateColor(playerid, factionid);
    Faction:Data[factionid][Faction_Color] = newcolor;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Faction_Color`='%d' WHERE `ID` = '%d'", newcolor, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) color to %06x", Faction:GetName(factionid), factionid, newcolor));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuUpdateZoneData(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionMenuUpdateZoneData", DIALOG_STYLE_INPUT, "Faction: Update Zone",
        "Enter Faction Zone Data\n[MinX] [MinY] [MaxX] [MaxY] [ZColor] [NColor] [BColor]",
        "Update", "Close", factionid
    );
}

FlexDialog:FactionMenuUpdateZoneData(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new Float:xMinX, Float:xMinY, Float:xMaxX, Float:xMaxY, xZColor, xNcolor, xBcolor;
    if (sscanf(inputtext, "ffffN(0xFFFFFFAA)N(0xFFFFFFAA)N(0xFFFFFFAA)", xMinX, xMinY, xMaxX, xMaxY, xZColor, xNcolor, xBcolor))
        return Faction:AdminMenuUpdateZoneData(playerid, factionid);

    Faction:Data[factionid][MinX] = xMinX;
    Faction:Data[factionid][MinY] = xMinY;
    Faction:Data[factionid][MaxX] = xMaxX;
    Faction:Data[factionid][MaxY] = xMaxY;
    Faction:Data[factionid][ZColor] = xZColor;
    Faction:Data[factionid][NColor] = xNcolor;
    Faction:Data[factionid][BColor] = xBcolor;
    DestroyZoneNumber(Faction:Data[factionid][ZoneID]);
    DestroyZoneBorders(Faction:Data[factionid][ZoneID]);
    DestroyZone(Faction:Data[factionid][ZoneID]);
    if (Faction:Data[factionid][MinX] != 0.0) {
        Faction:Data[factionid][ZoneID] = CreateZone(Faction:Data[factionid][MinX], Faction:Data[factionid][MinY], Faction:Data[factionid][MaxX], Faction:Data[factionid][MaxY]);
        CreateZoneNumber(Faction:Data[factionid][ZoneID], Faction:Data[factionid][ID]);
        CreateZoneBorders(Faction:Data[factionid][ZoneID]);
    }
    mysql_tquery(Database, sprintf(
        "update `factions` set `MinX` = \"%f\", `MinY` = \"%f\", `MaxX` = \"%f\", `MaxY` = \"%f\", `ZColor` = \"%d\", `NColor` = \"%d\", `BColor` = \"%d\" where `ID`=\"%d\"",
        xMinX, xMinY, xMaxX, xMaxY, xZColor, xNcolor, xBcolor, factionid
    ));
    ShowZoneForAll(Faction:Data[factionid][ZoneID], Faction:Data[factionid][ZColor], Faction:Data[factionid][NColor], Faction:Data[factionid][BColor]);
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) zone data", Faction:GetName(factionid), factionid));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuUpdateWage(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionMenuUpdateWage", DIALOG_STYLE_INPUT, "Faction: Update Wage",
        sprintf(
            "Current Wage: $%s\n\nEnter new wage for faction, wage calculation rate is per minute",
            FormatCurrency(Faction:GetWage(factionid))
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionMenuUpdateWage(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newwage;
    if (sscanf(inputtext, "d", newwage) || newwage < 0) return Faction:AdminMenuUpdateWage(playerid, factionid);
    Faction:Data[factionid][Faction_Wage] = newwage;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Faction_Wage`='%d' WHERE `ID` = '%d'", newwage, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) wage to $%s", Faction:GetName(factionid), factionid, FormatCurrency(Faction:GetWage(factionid))));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuUpdateVaultID(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionMenuUpdateVaultID", DIALOG_STYLE_INPUT, "Faction: Update VaultID",
        sprintf(
            "Current vault ID: %s (%d)\n\nEnter new vault id",
            vault:GetName(Faction:GetVaultID(factionid))
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionMenuUpdateVaultID(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newVaultID;
    if (sscanf(inputtext, "d", newVaultID) || !vault:isValidID(newVaultID)) return Faction:AdminMenuUpdateVaultID(playerid, factionid);
    Faction:Data[factionid][vaultID] = newVaultID;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `vaultID`='%d' WHERE `ID` = '%d'", newVaultID, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction %s (%d) vault to %s (%d)", Faction:GetName(factionid), factionid, vault:GetName(newVaultID), newVaultID));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuRenameFaction(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionMenuRenameFaction", DIALOG_STYLE_INPUT, "Faction: Update Name",
        sprintf(
            "Current name: %s\n\nEnter new name for faction",
            Faction:GetName(factionid)
        ),
        "Update", "Close", factionid
    );
}

FlexDialog:FactionMenuRenameFaction(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    new newName[50];
    if (sscanf(inputtext, "s[50]", newName)) return Faction:AdminMenuRenameFaction(playerid, factionid);
    Faction:Data[factionid][Name] = newName;
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `Name`=\"%s\" WHERE `ID` = '%d'", newName, factionid));
    AlexaMsg(playerid, sprintf("you have updated faction name to %s", Faction:GetName(factionid)));
    return Faction:MenuAdminManage(playerid, factionid);
}

stock Faction:AdminMenuManageRank(playerid, factionid) {
    new string[2000];
    strcat(string, "#\tName\tWage\n");
    for (new rankid = 1; rankid <= Faction:GetRankLimit(factionid); rankid++) {
        strcat(string, sprintf("%d\t%s\t$%s\n", rankid, Faction:GetRankName(factionid, rankid), FormatCurrency(Faction:GetRankWage(factionid, rankid))));
    }
    strcat(string, "Update\tRank\tLimit\n");
    return FlexPlayerDialog(
        playerid, "FactionAdminMenuManageRank", DIALOG_STYLE_TABLIST_HEADERS, "Faction: Manage Rank", string, "Select", "Close", factionid
    );
}

FlexDialog:FactionAdminMenuManageRank(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    if (IsStringSame(inputtext, "Update")) return Faction:AdminMenuSetRankLimit(playerid, factionid);
    new rankid = strval(inputtext);
    return Faction:AdminRankOptions(playerid, factionid, rankid);
}

stock Faction:AdminMenuSetRankLimit(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionAdminSetRankLimit", DIALOG_STYLE_INPUT, "Faction: Set Rank Limit",
        sprintf("Enter faction rank limit\nLimit: 1 to %d", Max_Faction_Rank),
        "Update", "Cancel", factionid
    );
}

FlexDialog:FactionAdminSetRankLimit(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageRank(playerid, factionid);
    new newRankLimit;
    if (sscanf(inputtext, "d", newRankLimit) || newRankLimit < 1 || newRankLimit > Max_Faction_Rank) return Faction:AdminMenuSetRankLimit(playerid, factionid);
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `RankLimit`='%d' WHERE `ID` = '%d'", newRankLimit, factionid));
    mysql_tquery(Database, sprintf("DELETE FROM `factionRank` WHERE `FactionID` = '%d'", factionid));
    Faction:Data[factionid][RankLimit] = newRankLimit;
    for (new i = 1; i <= newRankLimit; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionRank`(`FactionID`, `Faction_RankID`, `Name`) VALUES ('%d','%d','Rank %d')", factionid, i, i));
        new rv[50];
        format(rv, sizeof(rv), "Rank %d", i);
        Faction:RankData[factionid][i][Name] = rv;
        Faction:RankData[factionid][i][rank_wage] = 1;
    }
    return Faction:AdminMenuManageRank(playerid, factionid);
}

stock Faction:AdminRankOptions(playerid, factionid, rankid) {
    new string[512];
    strcat(string, sprintf("Rename Rank\t%s\n", Faction:GetRankName(factionid, rankid)));
    strcat(string, sprintf("Update Wage\t$%s\n", FormatCurrency(Faction:GetRankWage(factionid, rankid))));
    return FlexPlayerDialog(
        playerid, "FactionAdminRankOptions", DIALOG_STYLE_TABLIST, "Faction: Manage Rank", string, "Select", "Close", factionid, sprintf("%d", rankid));
}

FlexDialog:FactionAdminRankOptions(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageRank(playerid, factionid);
    new rankid = strval(payload);
    if (IsStringSame(inputtext, "Rename Rank")) return Faction:AdminMenuRankUpdateName(playerid, factionid, rankid);
    if (IsStringSame(inputtext, "Update Wage")) return Faction:AdminMenuRankUpdateWage(playerid, factionid, rankid);
    return 1;
}

stock Faction:AdminMenuRankUpdateName(playerid, factionid, rankid) {
    return FlexPlayerDialog(
        playerid, "FactionRankUpdateName", DIALOG_STYLE_INPUT, "Faction: Update Rank Name",
        sprintf("Current name: %s\n\nEnter new name for rank", Faction:GetRankName(factionid, rankid)),
        "Update", "Cancel", factionid, sprintf("%d", rankid)
    );
}

FlexDialog:FactionRankUpdateName(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new rankid = strval(payload);
    if (!response) return Faction:AdminRankOptions(playerid, factionid, rankid);
    new newRankName[50];
    if (sscanf(inputtext, "s[50]", newRankName)) return Faction:AdminMenuRankUpdateName(playerid, factionid, rankid);
    Faction:RankData[factionid][rankid][Name] = newRankName;
    mysql_tquery(Database, sprintf("UPDATE `factionRank` SET `Name`= \"%s\" WHERE `FactionID`='%d' AND`Faction_RankID`='%d'", newRankName, factionid, rankid));
    return Faction:AdminRankOptions(playerid, factionid, rankid);
}

stock Faction:AdminMenuRankUpdateWage(playerid, factionid, rankid) {
    return FlexPlayerDialog(
        playerid, "FactionRankUpdateWage", DIALOG_STYLE_INPUT, "Faction: Update Rank Wage",
        sprintf(
            "Current wage: $%s\n\nEnter new wage for rank %s\nLimit: $0 to $%s",
            FormatCurrency(Faction:GetRankWage(factionid, rankid)),
            Faction:GetRankName(factionid, rankid), FormatCurrency(Faction:GetWage(factionid))
        ), "Update", "Cancel", factionid, sprintf("%d", rankid)
    );
}

FlexDialog:FactionRankUpdateWage(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    new rankid = strval(payload);
    if (!response) return Faction:AdminRankOptions(playerid, factionid, rankid);
    new newRankWage;
    if (sscanf(inputtext, "d", newRankWage) || newRankWage < 0 || newRankWage > Faction:GetWage(factionid)) return Faction:AdminMenuRankUpdateWage(playerid, factionid, rankid);
    Faction:RankData[factionid][rankid][rank_wage] = newRankWage;
    mysql_tquery(Database, sprintf("UPDATE `factionRank` SET `Wage`= %d WHERE `FactionID`='%d' AND`Faction_RankID`='%d'", newRankWage, factionid, rankid));
    return Faction:AdminRankOptions(playerid, factionid, rankid);
}

stock Faction:AdminMenuManageSkin(playerid, factionid) {
    new string[2000];
    strcat(string, "#\tSkin ID\n");
    for (new slot = 1; slot <= Faction:GetSkinLimit(factionid); slot++) {
        strcat(string, sprintf("%d\t%d\n", slot, Faction:GetSkinBySlot(factionid, slot)));
    }
    strcat(string, "Update\tLimit\n");
    return FlexPlayerDialog(playerid, "FactionAdminMenuManageSkin", DIALOG_STYLE_TABLIST_HEADERS, "Faction: Manage Skin", string, "Select", "Close", factionid);
}

FlexDialog:FactionAdminMenuManageSkin(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    if (IsStringSame(inputtext, "Update")) return Faction:AdminUpdateSkinLimit(playerid, factionid);
    return Faction:AdminUpdateSkinID(playerid, factionid, strval(inputtext));
}

stock Faction:AdminUpdateSkinID(playerid, factionid, slot) {
    new skin = Faction:GetSkinBySlot(factionid, slot);
    return FlexPlayerDialog(
        playerid, "FactionAdminUpdateSkinID", DIALOG_STYLE_INPUT, "Faction: Update Skin",
        sprintf("Current skin: %s (%d)\n\nEnter new skin id between 0 to 311", GetSkinName(skin), skin),
        "Update", "Cancel", factionid, sprintf("%d", slot)
    );
}

FlexDialog:FactionAdminUpdateSkinID(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageSkin(playerid, factionid);
    new slot = strval(payload);
    new skinid;
    if (sscanf(inputtext, "d", skinid) || skinid < 0 || skinid > 311) return Faction:AdminUpdateSkinID(playerid, factionid, slot);
    mysql_tquery(Database, sprintf("UPDATE `factionSkinData` SET `SkinID`='%d' WHERE `FactionID`='%d' AND`Faction_SkinID_Slot`='%d'", skinid, factionid, slot));
    Faction:SkinData[factionid][slot][SkinID] = skinid;
    return Faction:AdminMenuManageSkin(playerid, factionid);
}

stock Faction:AdminUpdateSkinLimit(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionUpdateSkinLimit", DIALOG_STYLE_INPUT, "Faction: Update Skin Limit",
        sprintf("Curren skin limit: %d\n\nEnter new skin limit between 1 to %d", Faction:GetSkinLimit(factionid), Max_Faction_Skin),
        "Update", "Cancel", factionid
    );
}

FlexDialog:FactionUpdateSkinLimit(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageSkin(playerid, factionid);
    new newSkinLimit;
    if (sscanf(inputtext, "d", newSkinLimit) || newSkinLimit < 1 || newSkinLimit > Max_Faction_Skin) return Faction:AdminUpdateSkinLimit(playerid, factionid);
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `SkinLimit`='%d' WHERE `ID` = '%d'", newSkinLimit, factionid));
    mysql_tquery(Database, sprintf("DELETE FROM `factionSkinData` WHERE `FactionID` = '%d'", factionid));
    Faction:Data[factionid][SkinLimit] = newSkinLimit;
    for (new i = 1; i <= newSkinLimit; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionSkinData`(`FactionID`, `Faction_SkinID_Slot`, `SkinID`) VALUES ('%d','%d','%d')", factionid, i, i));
        Faction:SkinData[factionid][i][SkinID] = i;
    }
    return Faction:AdminMenuManageSkin(playerid, factionid);
}

stock Faction:AdminMenuManageWeapon(playerid, factionid) {
    new string[2000];
    format(string, sizeof string, "#\tWeapon\tAmmo\n");
    for (new slot = 1; slot <= Faction:GetWeaponLimit(factionid); slot++) {
        strcat(string, sprintf(
            "%d\t%d - %s\t%d",
            slot,
            Faction:GetWeaponBySlot(factionid, slot),
            GetWeaponNameEx(Faction:GetWeaponBySlot(factionid, slot)),
            Faction:GetWeaponSlotAmmo(factionid, slot)
        ));
    }
    strcat(string, "Update\tWeapon\tLimit");
    return FlexPlayerDialog(playerid, "FactionAdminManageWeapon", DIALOG_STYLE_TABLIST_HEADERS, "Faction: Manage Weapon", string, "Select", "Close", factionid);
}

FlexDialog:FactionAdminManageWeapon(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:MenuAdminManage(playerid, factionid);
    if (IsStringSame(inputtext, "Update")) return Faction:AdminUpdateWeaponLimit(playerid, factionid);
    return Faction:AdminUpdateWeaponAmmo(playerid, factionid, strval(inputtext));
}

stock Faction:AdminUpdateWeaponLimit(playerid, factionid) {
    return FlexPlayerDialog(
        playerid, "FactionUpdateWeaponLimit", DIALOG_STYLE_INPUT, "Faction: Update Weapon Limit",
        sprintf("Curren weapon limit: %d\n\nEnter new skin limit between 0 to %d", Faction:GetWeaponLimit(factionid), Max_Faction_Weapon),
        "Update", "Cancel", factionid
    );
}

FlexDialog:FactionUpdateWeaponLimit(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageWeapon(playerid, factionid);
    new newWeaponLimit;
    if (sscanf(inputtext, "d", newWeaponLimit) || newWeaponLimit < 1 || newWeaponLimit > Max_Faction_Weapon) return Faction:AdminUpdateWeaponLimit(playerid, factionid);
    mysql_tquery(Database, sprintf("UPDATE `factions` SET `WeaponLimit`='%d' WHERE `ID` = '%d'", newWeaponLimit, factionid));
    mysql_tquery(Database, sprintf("DELETE FROM `factionWeaponData` WHERE `FactionID` = '%d'", factionid));
    Faction:Data[factionid][WeaponLimit] = newWeaponLimit;
    for (new i = 1; i <= newWeaponLimit; i++) {
        mysql_tquery(Database, sprintf("INSERT INTO `factionWeaponData`(`FactionID`, `Faction_WeaponID_Slot`, `WeaponID`, `WeaponBullet`) VALUES ('%d','%d','%d','%d')", factionid, i, 24, 24));
        Faction:WeaponData[factionid][i][WeaponID] = 24;
        Faction:WeaponData[factionid][i][WeaponBullet] = 10;
    }
    return Faction:AdminMenuManageWeapon(playerid, factionid);
}

stock Faction:AdminUpdateWeaponAmmo(playerid, factionid, slot) {
    new weaponid = Faction:GetWeaponBySlot(factionid, slot);
    return FlexPlayerDialog(
        playerid, "FactionAdminUpdateAmmo", DIALOG_STYLE_INPUT, "Faction: Update Ammo",
        sprintf("Weapon: %d - %s\nCurrent ammo: %d\n\nEnter [weaponid] [ammo (Limit: 0-1000)]", weaponid, GetWeaponNameEx(weaponid), Faction:GetWeaponSlotAmmo(factionid, slot)),
        "Update", "Cancel", factionid, sprintf("%d", slot)
    );
}

FlexDialog:FactionAdminUpdateAmmo(playerid, response, listitem, const inputtext[], factionid, const payload[]) {
    if (!response) return Faction:AdminMenuManageWeapon(playerid, factionid);
    new slot = strval(payload);
    new newWeaponID, newAmmo;
    if (sscanf(inputtext, "dd", newWeaponID, newAmmo) || !IsValidWeaponID(newWeaponID) || newAmmo < 0 || newAmmo > 1000) return Faction:AdminUpdateWeaponAmmo(playerid, factionid, slot);
    mysql_tquery(
        Database,
        sprintf(
            "UPDATE `factionWeaponData` SET `WeaponID`='%d', `WeaponBullet`='%d' WHERE `FactionID`='%d' AND`Faction_WeaponID_Slot`='%d'",
            newWeaponID, newAmmo, factionid, slot
        )
    );
    Faction:WeaponData[factionid][slot][WeaponID] = newWeaponID;
    Faction:WeaponData[factionid][slot][WeaponBullet] = newAmmo;
    return Faction:AdminMenuManageWeapon(playerid, factionid);
}