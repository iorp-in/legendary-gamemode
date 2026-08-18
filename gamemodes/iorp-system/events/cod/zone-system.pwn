new COD:Zone_Player_Flag[MAX_PLAYERS];

stock bool:COD:HasPlayerFlag(playerid) {
    if (COD:GetPlayerFlag(playerid) == -1) return false;
    else return true;
}

stock COD:GetPlayerFlag(playerid) {
    return COD:Zone_Player_Flag[playerid];
}

stock COD:SetPlayerFlag(playerid, data) {
    COD:Zone_Player_Flag[playerid] = data;
    return 1;
}

enum COD:CordZone_Data_Enum {
    COD:CordID,
    COD:CordName[50],
    Float:COD:CordPosX,
    Float:COD:CordPosY,
    Float:COD:CordPosZ,
    Float:COD:CordZone_MinX,
    Float:COD:CordZone_MinY,
    Float:COD:CordZone_MaxX,
    Float:COD:CordZone_MaxY,
    Float:COD:CordZone_SpawnX,
    Float:COD:CordZone_SpawnY,
    Float:COD:CordZone_SpawnZ,
    Float:COD:CordZone_SpawnA,
    COD:CordZone_ZColor,
    COD:CordZone_ID,
    COD:CordCapturedBy,
    COD:CordFlag_PickupID
};

new COD:CordZone_Data[][COD:CordZone_Data_Enum] = {
    { 0, "Zone 0", -768.724, 2764.73, 49.9618, -887.0, 2730.5, -713.0, 2786.5, -768.724, 2764.73, 49.9618, 0.0 },
    { 1, "Zone 1", 349.047, 2468.84, 44.0124, 57.0, 2397.5, 435.0, 2563.5, 349.047, 2468.84, 44.0124, 0.0 },
    { 2, "Zone 2", 693.62, 1963.56, 8.58115, 673.0, 1924.5, 736.0, 2009.5, 693.62, 1963.56, 8.58115, 0.0 },
    { 3, "Zone 3", 662.85, 1716.71, 10.2649, 596.0, 1666.5, 694.0, 1753.5, 662.85, 1716.71, 10.2649, 0.0 },
    { 4, "Zone 4", 245.387, 1410.5, 23.6003, 104.0, 1335.5, 290.0, 1490.5, 245.387, 1410.5, 23.6003, 0.0 },
    { 5, "Zone 5", -343.173, 1534.79, 79.3558, -404.0, 1506.5, -257.0, 1637.5, -343.173, 1534.79, 79.3558, 0.0 },
    { 6, "Zone 6", -308.228, 1769.24, 48.6383, -356.0, 1716.5, -256.0, 1816.5, -308.228, 1769.24, 48.6383, 0.0 },
    { 7, "Zone 7", -699.456, 939.735, 21.3956, -738.0, 910.5, -638.0, 1010.5, -699.456, 939.735, 21.3956, 0.0 },
    { 8, "Zone 8", -1470.63, 1858.32, 38.255, -1503.0, 1850.5, -1442.0, 1887.5, -1470.63, 1858.32, 38.255, 0.0 },
    { 9, "Zone 9", -1212.54, 1833.19, 47.7284, -1243.0, 1810.5, -1187.0, 1854.5, -1212.54, 1833.19, 47.7284, 0.0 },
    { 10, "Zone 10", -1946.18, 2389.53, 54.6478, -1968.0, 2346.5, -1905.0, 2415.5, -1946.18, 2389.53, 54.6478, 0.0 },
    { 11, "Zone 11", -1320.73, 2698.55, 51.8895, -1343.0, 2664.5, -1258.0, 2728.5, -1320.73, 2698.55, 51.8895, 0.0 },
    { 12, "zone 12", -546.719, 2594.01, 57.0694, -602.0, 2541.5, -498.0, 2640.5, -546.719, 2594.01, 57.0694, 0.0 },
    { 13, "Zone 13", -395.22, 2246.26, 49.0156, -445.0, 2187.5, -345.0, 2287.5, -395.22, 2246.26, 49.0156, 0.0 },
    { 14, "Zone 14", -329.818, 1307.49, 58.0351, -340.0, 1287.5, -281.0, 1337.5, -329.818, 1307.49, 58.0351, 0.0 },
    { 15, "Zone 15", 610.433, 1266.47, 36.5721, 553.0, 1196.5, 695.0, 1295.5, 610.433, 1266.47, 36.5721, 0.0 },
    { 16, "Zone 16", 966.295, 2134.28, 18.6539, 922.0, 2045.5, 1007.0, 2187.5, 966.295, 2134.28, 18.6539, 0.0 },
    { 17, "Zone 17", -904.63, 2686.09, 47.411, -935.0, 2663.5, -883.0, 2706.5, -904.63, 2686.09, 47.411, 0.0 },
    { 18, "Zone 18", -807.086, 1828.54, 22.8445, -890.0, 1826.5, -796.0, 1994.5, -807.086, 1828.54, 22.8445, 0.0 },
    { 19, "Zone 19", -624.845, 1837.95, 22.8445, -638.0, 1818.5, -567.0, 1999.5, -624.845, 1837.95, 22.8445, 0.0 },
    { 20, "Zone 20", -87.5469, 1378.59, 13.3659, -116.0, 1329.5, -73.0, 1389.5, -87.5469, 1378.59, 13.3659, 0.0 },
    { 21, "Zone 21", 941.126, 1733.38, 14.7641, 917.0, 1625.5, 1000.0, 1840.5, 941.126, 1733.38, 14.7641, 0.0 },
    { 22, "Zone 22", -1379.47, 1491.04, 20.1647, -1486.0, 1470.5, -1357.0, 1509.5, -1379.47, 1491.04, 20.1647, 0.0 },
    { 23, "Zone 23", -2299.23, 1544.94, 19.5453, -2526.0, 1522.5, -2297.0, 1570.5, -2299.23, 1544.94, 19.5453, 0.0 },
    { 24, "Zone 24", -810.172, 2428.96, 159.881, -819.0, 2390.5, -763.0, 2454.5, -810.172, 2428.96, 159.881, 0.0 },
    { 25, "Zone 25", -316.587, 829.601, 16.8954, -353.0, 801.5, -287.0, 861.5, -316.587, 829.601, 16.8954, 0.0 }
};

stock COD:CordCreateFlag(zoneid) {
    if (IsValidDynamicPickup(COD:CordZone_Data[zoneid][COD:CordFlag_PickupID])) DestroyDynamicPickup(COD:CordZone_Data[zoneid][COD:CordFlag_PickupID]);
    COD:CordZone_Data[zoneid][COD:CordFlag_PickupID] = CreateDynamicPickup(
        19306, 2, COD:CordZone_Data[zoneid][COD:CordPosX], COD:CordZone_Data[zoneid][COD:CordPosY], COD:CordZone_Data[zoneid][COD:CordPosZ], COD_Event_VirtualWorld
    );
    return 1;
}

stock COD:CordGetZoneColor(zoneid) {
    if (COD:CordZone_Data[zoneid][COD:CordCapturedBy] == -1) return COD:CordZone_Data[zoneid][COD:CordZone_ZColor];
    else return COD:GetTeamColor(COD:CordZone_Data[zoneid][COD:CordCapturedBy]);
}

stock COD:CordSetZoneTeam(zoneid, teamid) {
    COD:CordZone_Data[zoneid][COD:CordCapturedBy] = teamid;
    return 1;
}

stock COD:CordGetZoneTeam(zoneid) {
    return COD:CordZone_Data[zoneid][COD:CordCapturedBy];
}

stock COD:CordGetZoneName(zoneid) {
    new string[50];
    format(string, sizeof string, "%s", COD:CordZone_Data[zoneid][COD:CordName]);
    return string;
}

stock COD:CordZoneSpawn(playerid, const inputtext[]) {
    for (new zone; zone < sizeof COD:CordZone_Data; zone++) {
        if (!strcmp(COD:CordGetZoneName(zone), inputtext)) {
            SetPlayerPosEx(playerid, COD:CordZone_Data[zone][COD:CordZone_SpawnX], COD:CordZone_Data[zone][COD:CordZone_SpawnY], COD:CordZone_Data[zone][COD:CordZone_SpawnZ]);
            SetPlayerFacingAngle(playerid, COD:CordZone_Data[zone][COD:CordZone_SpawnA]);
            return 1;
        }
    }
    SendClientMessageEx(playerid, -1, "{4286f4}[COD:MW]: {FFFFEE}Invalid Spawn Location, Removing from Event");
    Event:Leave(playerid);
    return 1;
}

hook OnGameModeInit() {
    for (new i; i < sizeof COD:CordZone_Data; i++) {
        COD:CordSetZoneTeam(i, -1);
        COD:CordZone_Data[i][COD:CordFlag_PickupID] = -1;
        COD:CordZone_Data[i][COD:CordZone_ZColor] = 0x00FF00AA;
        COD:CordZone_Data[i][COD:CordZone_ID] = CreateZone(COD:CordZone_Data[i][COD:CordZone_MinX], COD:CordZone_Data[i][COD:CordZone_MinY], COD:CordZone_Data[i][COD:CordZone_MaxX], COD:CordZone_Data[i][COD:CordZone_MaxY]);
        //CreateZoneNumber(COD:CordZone_Data[i][COD:CordZone_ID],COD:CordZone_Data[i][COD:CordID]);
        CreateZoneBorders(COD:CordZone_Data[i][COD:CordZone_ID]);
        COD:CordCreateFlag(i);
    }
    return 1;
}

hook OnGameModeExit() {
    for (new i; i < sizeof COD:CordZone_Data; i++) {
        //DestroyZoneNumber(COD:CordZone_Data[i][COD:CordZone_ID]);
        DestroyZoneBorders(COD:CordZone_Data[i][COD:CordZone_ID]);
        DestroyZone(COD:CordZone_Data[i][COD:CordZone_ID]);
    }
    return 1;
}

stock COD:CordUpdateZonesForAll() {
    foreach(new playerid:Player) {
        if (Event:GetID(playerid) != COD_Event_ID) continue;
        COD:CordHideZonesToPlayer(playerid);
        COD:CordShowZonesToPlayer(playerid);
    }
    return 1;
}
stock COD:CordShowZonesToPlayer(playerid) {
    for (new i; i < sizeof COD:CordZone_Data; i++) ShowZoneForPlayer(playerid, COD:CordZone_Data[i][COD:CordZone_ID], COD:CordGetZoneColor(i), 0xFFFFFFFF, 0xFFFFFFFF);
    return 1;
}

stock COD:CordHideZonesToPlayer(playerid) {
    for (new i; i < sizeof COD:CordZone_Data; i++) HideZoneForPlayer(playerid, COD:CordZone_Data[i][COD:CordZone_ID]);
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != COD_Event_ID) return 1;
    COD:CordShowZonesToPlayer(playerid);
    COD:SetPlayerFlag(playerid, -1);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != COD_Event_ID) return 1;
    COD:CordHideZonesToPlayer(playerid);
    if (COD:HasPlayerFlag(playerid)) {
        new string[512];
        foreach(new i:Player) {
            if (Event:GetID(i) != COD_Event_ID) continue;
            format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE}[%s's %s]%s failed to secure %s zone flag", COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(COD:GetPlayerRank(playerid)), GetPlayerNameEx(playerid), COD:CordGetZoneName(COD:GetPlayerFlag(playerid)));
            SendClientMessageEx(i, -1, string);
        }
        COD:CordCreateFlag(COD:GetPlayerFlag(playerid));
        COD:SetPlayerFlag(playerid, -1);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (Event:GetID(playerid) != COD_Event_ID) return 1;
    if (COD:HasPlayerFlag(playerid)) {
        new string[512];
        foreach(new i:Player) {
            if (Event:GetID(i) != COD_Event_ID) continue;
            format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE}[%s's %s]%s failed to secure %s zone flag", COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(COD:GetPlayerRank(playerid)), GetPlayerNameEx(playerid), COD:CordGetZoneName(COD:GetPlayerFlag(playerid)));
            SendClientMessageEx(i, -1, string);
        }
        COD:CordCreateFlag(COD:GetPlayerFlag(playerid));
        COD:SetPlayerFlag(playerid, -1);
    }
    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    if (Event:GetID(playerid) != COD_Event_ID) return 1;
    for (new i; i < sizeof COD:CordZone_Data; i++) {
        if (COD:CordZone_Data[i][COD:CordFlag_PickupID] == pickupid) {
            if (COD:CordGetZoneTeam(i) == COD:GetPlayerTeam(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[COD:MW]: {FFFFEE}this zone is already belongs to your team.");
            new string[512];
            if (COD:CordZone_Data[i][COD:CordCapturedBy] == -1) format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE}[%s's %s]%s captured %s zone flag", COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(COD:GetPlayerRank(playerid)), GetPlayerNameEx(playerid), COD:CordGetZoneName(i));
            else format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE}[%s's %s]%s captured %s zone flag from %s", COD:GetTeamName(COD:GetPlayerTeam(playerid)), COD:GetRankName(COD:GetPlayerRank(playerid)), GetPlayerNameEx(playerid), COD:CordGetZoneName(i), COD:CordGetZoneTeam(i));
            foreach(new pid:Player) {
                if (Event:GetID(pid) != COD_Event_ID) continue;
                SendClientMessageEx(pid, -1, string);
            }
            format(string, sizeof string, "{4286f4}[COD:MW]: {FFFFEE} you have to secure the flag and return to your HQ");
            SendClientMessageEx(playerid, -1, string);
            DestroyDynamicPickup(pickupid);
            COD:SetPlayerFlag(playerid, i);
            return 1;
        }
    }
    return 1;
}