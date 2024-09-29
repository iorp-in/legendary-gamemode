#define COD_Event_ID 4
#define COD_Event_VirtualWorld 15
#include "IORP_SYSTEM/events/COD/cod_zone_system.pwn"
#include <YSI_Coding\y_hooks>
new COD:TdUpdateTimer;

enum COD_Player_Data_Enum {
    COD_TeamID,
    COD_RankID,
    COD_Kills,
    COD_Deaths,
    COD:Score,
    PlayerText:COD_TD_PInfoID
};
new COD:PlayerData[MAX_PLAYERS][COD_Player_Data_Enum];

enum COD:TeamData_Enum {
    COD_Team_ID,
    COD_Team_Name[50],
    Float:COD_PosX,
    Float:COD_PosY,
    Float:COD_PosZ,
    Float:COD_PosA,
    Float:COD_Zone_MinX,
    Float:COD_Zone_MinY,
    Float:COD_Zone_MaxX,
    Float:COD_Zone_MaxY,
    COD_ZColor,
    COD_Zone_ID,
    CodLockerCheckpointID,
    Text3D:CodMenuText
};
new COD:TeamData[][COD:TeamData_Enum] = {
    { 0, "USA", -98.4850, 1085.5391, 19.7422, 355.8038, -349.0, 1002.5, 104.0, 1248.5, 0xB78934AA },
    { 1, "RUSSIA", -854.8300, 1524.8617, 22.2243, 264.5836, -863.0, 1465.5, -729.0, 1613.5, 0xDAEE1DAA },
    { 2, "EUROPE", -250.0030, 2583.4219, 63.5703, 267.4111, -363.0, 2632.5, -141.0, 2786.5, 0xDB9ED6AA },
    { 3, "ASIA", -1405.1106, 2640.8032, 55.6875, 87.8495, -1584.0, 2540.5, -1396.0, 2692.5, 0x57976FAA },
    { 4, "ARAB", -2250.1868, 2318.8804, 4.8125, 97.3220, -2580.0, 2212.5, -2200.0, 2444.5, 0xEF43A2AA },
    { 5, "REBELS", 295.9804, 1906.6802, 17.6406, 270.5297, 57.0, 1783.5, 338.0, 2074.5, 0x0C9CDAAA }
};

enum COD:RankDataEnum {
    COD_RANK_ID,
    COD_RANK_Name[50],
    COD_RANK_Score
};
new COD:RankData[][COD:RankDataEnum] = {
    { 0, "Trainee", 0 },
    { 1, "Assault", 50 },
    { 2, "Sniper", 100 },
    { 3, "Pyroman", 200 },
    { 4, "Demolition", 400 },
    { 5, "Medic", 500 },
    { 6, "Pilot", 700 },
    { 7, "Paratrooper", 800 },
    { 8, "Engineer", 1000 },
    { 9, "Jettrooper", 1200 },
    { 10, "Support", 1500 },
    { 11, "Scout", 2000 },
    { 12, "Spy", 3000 },
    { 13, "Donor", 9999999 }
};

stock COD:GetPlayerScore(playerid) {
    return COD:PlayerData[playerid][COD:Score];
}
stock COD:SetPlayerScore(playerid, data) {
    COD:PlayerData[playerid][COD:Score] = data;
    return 1;
}
stock COD:GetPlayerDeaths(playerid) {
    return COD:PlayerData[playerid][COD_Deaths];
}
stock COD:SetPlayerDeaths(playerid, data) {
    COD:PlayerData[playerid][COD_Deaths] = data;
    return 1;
}
stock COD:GetPlayerKills(playerid) {
    return COD:PlayerData[playerid][COD_Kills];
}
stock COD:SetPlayerKills(playerid, data) {
    COD:PlayerData[playerid][COD_Kills] = data;
    return 1;
}

stock bool:COD:IsTeamValid(teamid) {
    for (new i; i < COD:TeamData; i++) {
        if (teamid == COD:TeamData[i][COD_Team_ID]) return 1;
    }
    return 0;
}

stock COD:GetTeamColor(teamid) {
    return COD:TeamData[teamid][COD_ZColor];
}

stock COD:GetTeamName(teamid) {
    new string[50];
    format(string, sizeof string, "%s", COD:TeamData[teamid][COD_Team_Name]);
    return string;
}

stock COD:GetRankName(rankid) {
    new string[50];
    format(string, sizeof string, "%s", COD:RankData[rankid][COD_RANK_Name]);
    return string;
}

stock COD:GetRankRequireScore(rankid) {
    return COD:RankData[rankid][COD_RANK_Score];
}

stock COD:GetTotalPlayerInTeam(teamid) {
    new total;
    foreach(new i:Player) {
        if (COD:PlayerData[i][COD_TeamID] == teamid) total++;
    }
    return total;
}

stock COD:SetPlayerTeam(playerid, teamid) {
    COD:PlayerData[playerid][COD_TeamID] = teamid;
    return 1;
}

stock COD:GetPlayerRank(playerid) {
    return COD:PlayerData[playerid][COD_RankID];
}

stock COD:SetPlayerRank(playerid, rankid) {
    COD:PlayerData[playerid][COD_RankID] = rankid;
    return 1;
}

stock COD:GetPlayerTeam(playerid) {
    return COD:PlayerData[playerid][COD_TeamID];
}

forward CodUpdatePlayerData(playerid);
public CodUpdatePlayerData(playerid) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "update playerDataEventCOD SET Kills = \"%d\", Deaths = \"%d\", Score = \"%d\" where Username=\"%s\"",
        COD:GetPlayerKills(playerid), COD:GetPlayerDeaths(playerid), COD:GetPlayerScore(playerid), GetPlayerNameEx(playerid));
    mysql_tquery(Database, query);
    return 1;
}

forward CodInitPlayerData(playerid);
public CodInitPlayerData(playerid) {
    COD:PlayerInfoTDCreate(playerid);
    COD:SetPlayerTeam(playerid, -1);
    COD:SetPlayerRank(playerid, -1);
    COD:SetPlayerKills(playerid, 0);
    COD:SetPlayerDeaths(playerid, 0);
    COD:SetPlayerScore(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, COD_Event_VirtualWorld);
    new rows = cache_num_rows();
    if (rows) {
        if (rows) {
            new Temp_Kills, Temp_Deaths, Temp_Score;
            cache_get_value_name_int(0, "Kills", Temp_Kills);
            cache_get_value_name_int(0, "Deaths", Temp_Deaths);
            cache_get_value_name_int(0, "Score", Temp_Score);
            COD:SetPlayerKills(playerid, Temp_Kills);
            COD:SetPlayerDeaths(playerid, Temp_Deaths);
            COD:SetPlayerScore(playerid, Temp_Score);
        }
    } else {
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO playerDataEventCOD SET Username=\"%s\", Kills = \"0\", Deaths = \"0\", Score = \"0\"", GetPlayerNameEx(playerid));
        mysql_tquery(Database, query);
    }
    return COD:ShowTeamSelection(playerid);
}

hook OnPlayerConnect(playerid) {
    COD:SetPlayerFlag(playerid, -1);
    COD:SetPlayerTeam(playerid, -1);
    COD:SetPlayerRank(playerid, -1);
    COD:SetPlayerKills(playerid, 0);
    COD:SetPlayerDeaths(playerid, 0);
    COD:SetPlayerScore(playerid, 0);
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != COD_Event_ID) return 1;
    new query[512];
    mysql_format(Database, query, sizeof(query), "SELECT * FROM `playerDataEventCOD` WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "CodInitPlayerData", "i", playerid);
    FuelAuth:SetAutoActive(playerid, true);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != COD_Event_ID) return 1;
    CodUpdatePlayerData(playerid);
    COD:PlayerInfoTDDestroy(playerid);
    COD:HideZonesToPlayer(playerid);
    COD:SetPlayerTeam(playerid, -1);
    SetPlayerColor(playerid, Player_Color);
    FuelAuth:SetAutoActive(playerid, false);
    return 1;
}

forward CodSpawnMenu(playerid);
public CodSpawnMenu(playerid) {
    if (Event:GetID(playerid) != COD_Event_ID) return 1;
    return COD:SpawnSelection(playerid);
}

hook OnGameModeInit() {
    for (new Id; Id < sizeof COD:TeamData; Id++) {
        COD:TeamData[Id][COD_Zone_ID] = CreateZone(COD:TeamData[Id][COD_Zone_MinX], COD:TeamData[Id][COD_Zone_MinY], COD:TeamData[Id][COD_Zone_MaxX], COD:TeamData[Id][COD_Zone_MaxY]);
        //CreateZoneNumber(COD:TeamData[Id][COD_Zone_ID],COD:TeamData[Id][COD_Team_ID]);
        CreateZoneBorders(COD:TeamData[Id][COD_Zone_ID]);
        COD:TeamData[Id][CodMenuText] = CreateDynamic3DTextLabel(
            sprintf(FormatColors("~y~Headquater: ~g~%s"), COD:TeamData[Id][COD_Team_Name]), 0, COD:TeamData[Id][COD_PosX] + 5, COD:TeamData[Id][COD_PosY] + 5, COD:TeamData[Id][COD_PosZ], 10.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, COD_Event_VirtualWorld, 0
        );
        COD:TeamData[Id][CodLockerCheckpointID] = STREAMER_TAG_CP:CreateDynamicCP(
            COD:TeamData[Id][COD_PosX] + 5, COD:TeamData[Id][COD_PosY] + 5, COD:TeamData[Id][COD_PosZ], 1.0, COD_Event_VirtualWorld, 0, -1, 10.0
        );
    }
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerDataEventCOD` (\
	  `Username` varchar(50) NOT NULL,\
	  `Kills` int(11) NOT NULL,\
	  `Deaths` int(11) NOT NULL,\
	  `Score` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    COD:TdUpdateTimer = SetPreciseTimer("CodPlayerInfoTDUpdate", 5000, true);
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid) {
    if (Event:GetID(playerid) != COD_Event_ID) return 1;
    if (checkpointid != COD:TeamData[COD:GetPlayerTeam(playerid)][CodLockerCheckpointID]) return 1;
    return COD:HqMenu(playerid);
}

hook OnGameModeExit() {
    for (new Id; Id < sizeof COD:TeamData; Id++) {
        //DestroyZoneNumber(COD:TeamData[Id][COD_Zone_ID]);
        DestroyZoneBorders(COD:TeamData[Id][COD_Zone_ID]);
        DestroyZone(COD:TeamData[Id][COD_Zone_ID]);
    }
    DeletePreciseTimer(COD:TdUpdateTimer);
    return 1;
}

stock COD:ShowZonesToPlayer(playerid) {
    for (new i; i < sizeof COD:TeamData; i++) ShowZoneForPlayer(playerid, COD:TeamData[i][COD_Zone_ID], COD:TeamData[i][COD_ZColor], 0xFFFFFFFF, 0xFFFFFFFF);
    return 1;
}

stock COD:HideZonesToPlayer(playerid) {
    for (new i; i < sizeof COD:TeamData; i++) HideZoneForPlayer(playerid, COD:TeamData[i][COD_Zone_ID]);
    return 1;
}

hook OnPlayerKilled(playerid, killerid, weaponid) {
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(killerid)) return 1;
    if (Event:GetID(playerid) != COD_Event_ID && Event:GetID(killerid) != COD_Event_ID) return 1;
    COD:SetPlayerKills(killerid, COD:GetPlayerKills(killerid) + 1);
    COD:SetPlayerScore(killerid, COD:GetPlayerScore(killerid) + 1);
    new string[512];
    if (COD:GetPlayerTeam(playerid) == COD:GetPlayerTeam(killerid)) {
        GiveExperiencePoint(playerid, -3, true);
        format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE} you have lost -3 exp for killing your team member");
    } else {
        GiveExperiencePoint(playerid, 3, true);
        format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE} you have awarded with +3 exp for killing your enemy");
    }
    SendClientMessageEx(killerid, -1, string);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (Event:GetID(playerid) != COD_Event_ID) return 1;
    COD:SetPlayerDeaths(playerid, COD:GetPlayerDeaths(playerid) + 1);
    GiveExperiencePoint(playerid, -2, true);
    SendClientMessageEx(playerid, -1, "{4286f4}[COD:MW]: {FFFFEE} you have lost -2 exp for medical treatment");
    SetPreciseTimer("CodSpawnMenu", 5000, false, "i", playerid);
    return 1;
}

stock COD:PlayerInfoTDCreate(playerid) {
    COD:PlayerData[playerid][COD_TD_PInfoID] = CreatePlayerTextDraw(playerid, 40.000000, 200.000000, "TEAM~n~~n~RANK~n~~n~SCORE~n~~n~KILLS~n~~n~DEATHS");
    PlayerTextDrawAlignment(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 1);
    PlayerTextDrawBackgroundColor(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 0);
    PlayerTextDrawFont(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 2);
    PlayerTextDrawLetterSize(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 0.210000, 0.799999);
    PlayerTextDrawColor(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], -186);
    PlayerTextDrawSetOutline(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 0);
    PlayerTextDrawSetProportional(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 1);
    PlayerTextDrawSetShadow(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 1);
    PlayerTextDrawSetSelectable(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], 0);
    return 1;
}

stock COD:PlayerInfoTDDestroy(playerid) {
    PlayerTextDrawDestroy(playerid, COD:PlayerData[playerid][COD_TD_PInfoID]);
    return 1;
}

stock COD:PlayerInfoTDShow(playerid) {
    PlayerTextDrawShow(playerid, COD:PlayerData[playerid][COD_TD_PInfoID]);
    return 1;
}

stock COD:PlayerInfoTDHide(playerid) {
    PlayerTextDrawHide(playerid, COD:PlayerData[playerid][COD_TD_PInfoID]);
    return 1;
}

forward CodPlayerInfoTDUpdate();
public CodPlayerInfoTDUpdate() {
    new totalPlayers = Event:GetOnlinePlayerIn(COD_Event_ID);
    foreach(new playerid:Player) {
        if (Event:GetID(playerid) != COD_Event_ID) continue;
        if (COD:GetPlayerTeam(playerid) == -1 || COD:GetPlayerRank(playerid) == -1) continue;
        PlayerTextDrawSetString(playerid, COD:PlayerData[playerid][COD_TD_PInfoID], sprintf(
            "Players In COD: %d~n~~n~TEAM: %s~n~~n~RANK: %s~n~~n~SCORE: %d~n~~n~KILLS: %d~n~~n~DEATHS: %d",
            totalPlayers,
            COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(COD:GetPlayerRank(playerid)),
            COD:GetPlayerScore(playerid), COD:GetPlayerKills(playerid), COD:GetPlayerDeaths(playerid)
        ));
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `playerDataEventCOD` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `playerDataEventCOD` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}

stock COD:ShowTeamSelection(playerid) {
    new string[512];
    strcat(string, "ID\tTeam\tTotal Player\n");
    for (new team; team < sizeof COD:TeamData; team++) {
        strcat(string, sprintf("{FFFFFF}%d\t%s\t%d\n", team, COD:GetTeamName(team), COD:GetTotalPlayerInTeam(team)));
    }
    return FlexPlayerDialog(playerid, "CodShowTeamSelection", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[COD:MW]:{FFFFEE}Select Your Team", string, "Select", "Close");
}

FlexDialog:CodShowTeamSelection(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Event:Leave(playerid);
    new team = strval(inputtext);
    COD:SetPlayerTeam(playerid, team);
    SetPlayerColor(playerid, COD:GetTeamColor(team));
    COD:ShowZonesToPlayer(playerid);
    return COD:ShowRankSelection(playerid);
}

stock COD:ShowRankSelection(playerid) {
    new string[512];
    strcat(string, "ID\tRank Name\tRequire Score\n");
    for (new rank; rank < sizeof COD:RankData; rank++) {
        strcat(string, sprintf("{FFFFFF}%d\t%s\t%d\n", COD:RankData[rank][COD_RANK_ID], COD:RankData[rank][COD_RANK_Name], COD:RankData[rank][COD_RANK_Score]));
    }
    return FlexPlayerDialog(playerid, "CodShowRankSelection", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[COD:MW]:{FFFFEE}Select Your Rank", string, "Select", "Close");
}

FlexDialog:CodShowRankSelection(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Event:Leave(playerid);
    new rankid = strval(inputtext);
    if (COD:GetPlayerScore(playerid) < COD:GetRankRequireScore(rankid)) {
        AlexaMsg(playerid, sprintf("you need %d score for %s rank, select another", COD:GetRankRequireScore(rankid), COD:GetRankName(rankid)), "COD:MW");
        return COD:ShowRankSelection(playerid);
    }
    COD:SetPlayerRank(playerid, rankid);
    Event:SendMessageToAll(COD_Event_ID, sprintf(
        "{4286f4}[COD:MW]:{FFFFEE}%s joined %s Team with rank %s",
        GetPlayerNameEx(playerid), COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(rankid)
    ));
    return COD:SpawnSelection(playerid);
}

stock COD:SpawnSelection(playerid) {
    new new_string[512];
    strcat(new_string, "Team Headquarter\n", sizeof new_string);
    for (new zoneid; zoneid < sizeof COD:CordZone_Data; zoneid++) {
        if (COD:CordGetZoneTeam(zoneid) == COD:GetPlayerTeam(playerid)) format(new_string, sizeof new_string, "%s%s\n", new_string, COD:CordGetZoneName(zoneid));
    }
    return FlexPlayerDialog(playerid, "CodSpawnSelection", DIALOG_STYLE_LIST, "{4286f4}[COD:MW]:{FFFFEE}Available Spawn Locations", new_string, "Select", "Close");
}

FlexDialog:CodSpawnSelection(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Event:Leave(playerid);

    if (IsStringSame("Team Headquarter", inputtext)) {
        new team = COD:GetPlayerTeam(playerid);
        SetPlayerPosEx(playerid, COD:TeamData[team][COD_PosX], COD:TeamData[team][COD_PosY], COD:TeamData[team][COD_PosZ]);
        SetPlayerFacingAngle(playerid, COD:TeamData[team][COD_PosA]);
    } else COD:CordZoneSpawn(playerid, inputtext);

    return COD:PlayerInfoTDShow(playerid);
}

stock COD:HqMenu(playerid) {
    new string[512];
    strcat(string, "Take Health and Armour\n");
    strcat(string, "Take Weapons\n");
    if (COD:HasPlayerFlag(playerid)) strcat(string, "Take Over Zone\n");
    return FlexPlayerDialog(playerid, "CodHqMenu", DIALOG_STYLE_LIST, "{4286f4}[COD:MW]: {FFFFEE}Team Locker", string, "Select", "Close");
}

FlexDialog:CodHqMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Take Weapons", inputtext)) return WeaponShopMenu(playerid);
    if (IsStringSame("Take Health and Armour", inputtext)) {
        if (!IsTimePassedForPlayer(playerid, "CodHealth", 3 * 60)) {
            AlexaMsg(playerid, "health is not available try after few minutes");
            return COD:HqMenu(playerid);
        }
        SetPlayerHealthEx(playerid, 100);
        SetPlayerArmourEx(playerid, 100);
        AlexaMsg(playerid, "your health and armour is full");
        return COD:HqMenu(playerid);
    }
    if (IsStringSame("Take Over Zone", inputtext)) {
        if (!COD:HasPlayerFlag(playerid)) return 1;
        foreach(new i:Player) {
            if (Event:GetID(i) != COD_Event_ID) continue;
            AlexaMsg(i, sprintf(
                "[%s's %s] %s secured %s zone flag. %s taken %s zone",
                COD:GetTeamName(COD:GetPlayerTeam(playerid)),
                COD:GetRankName(COD:GetPlayerRank(playerid)),
                GetPlayerNameEx(playerid),
                COD:CordGetZoneName(COD:GetPlayerFlag(playerid)),
                COD:GetTeamName(COD:GetPlayerTeam(playerid)),
                COD:CordGetZoneName(COD:GetPlayerFlag(playerid))
            ), "COD:MW");
            if (COD:GetPlayerTeam(playerid) == COD:GetPlayerTeam(i) && playerid != i) {
                COD:SetPlayerScore(i, COD:GetPlayerScore(i) + 1);
                GiveExperiencePoint(playerid, 10, true);
                AlexaMsg(i, sprintf(
                    "You have awarded with +10 exp and +1 score because your team taken %s zone",
                    COD:CordGetZoneName(COD:GetPlayerFlag(playerid))
                ), "COD:MW");
            }
        }
        COD:CordSetZoneTeam(COD:GetPlayerFlag(playerid), COD:GetPlayerTeam(playerid));
        COD:CordCreateFlag(COD:GetPlayerFlag(playerid));
        COD:CordUpdateZonesForAll();
        GiveExperiencePoint(playerid, 15, true);
        COD:SetPlayerScore(playerid, COD:GetPlayerScore(playerid) + 10);
        AlexaMsg(playerid, sprintf(
            "You have awarded with +15 exp and +10 score for capturing zone %s",
            COD:CordGetZoneName(COD:GetPlayerFlag(playerid))
        ), "COD:MW");
        COD:SetPlayerFlag(playerid, -1);
        return COD:HqMenu(playerid);
    }
    return 1;
}