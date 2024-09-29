#define PUBG_Event_ID 5
#define PUBG_event_virtualworld 16
#include "IORP_SYSTEM/events/PUBG/area_cords.pwn"

new PUBG:UpdatePlayerTdTimer, PUBG:ZoneID, PUBG:PlaneObjectID, bool:PUBG:EventStatus, PUBG:MapShrinkCount;
new PUBG:PlayerInMapTimer, PUBG:MatchStartCountDown, PUBG:MapShrinkTimer;
new Iterator:PubgPlayers < MAX_PLAYERS > ;
new Iterator:PubgVehicles < MAX_PLAYERS > ;
new Iterator:PUBG_Pickups < MAX_PLAYERS > ;

enum PUBG:PlayerDataEnum {
    Kills,
    Deaths,
    Played,
    Wins,
    PlayerText:PUBG_TD_PInfoID,
    bool:inplane,
    bool:InMatch
};
new PUBG:PlayerData[MAX_PLAYERS][PUBG:PlayerDataEnum];

enum PUBG:PickupDataEnum {
    pubg_pickupid,
    pubg_pickuptype
};
new PUBG:PickupData[MAX_PLAYERS][PUBG:PickupDataEnum];

stock PUBG:GetPlayerKills(playerid) {
    return PUBG:PlayerData[playerid][Kills];
}

stock PUBG:SetPlayerKills(playerid, data) {
    PUBG:PlayerData[playerid][Kills] = data;
    return 1;
}

stock PUBG:GetPlayerDeaths(playerid) {
    return PUBG:PlayerData[playerid][Deaths];
}

stock PUBG:SetPlayerDeaths(playerid, data) {
    PUBG:PlayerData[playerid][Deaths] = data;
    return 1;
}

stock PUBG:GetPlayerPlayed(playerid) {
    return PUBG:PlayerData[playerid][Played];
}

stock PUBG:SetPlayerPlayed(playerid, data) {
    PUBG:PlayerData[playerid][Played] = data;
    return 1;
}

stock PUBG:GetPlayerWins(playerid) {
    return PUBG:PlayerData[playerid][Wins];
}

stock PUBG:SetPlayerWins(playerid, data) {
    PUBG:PlayerData[playerid][Wins] = data;
    return 1;
}

stock PUBG:IsPlayerInPlane(playerid) {
    return PUBG:PlayerData[playerid][inplane];
}

stock PUBG:SetPlayerInPlaneStatus(playerid, bool:data) {
    PUBG:PlayerData[playerid][inplane] = data;
    return 1;
}

stock PUBG:IsPlayerInMatch(playerid) {
    return PUBG:PlayerData[playerid][InMatch];
}

stock PUBG:SetPlayerInMatchStatus(playerid, bool:data) {
    PUBG:PlayerData[playerid][InMatch] = data;
    return 1;
}

stock PUBG:GetTotalAlive() {
    new count = 0;
    foreach(new i:PubgPlayers) {
        if (PUBG:IsPlayerInMatch(i)) count++;
    }
    return count;
}

hook OnGameModeInit() {
    PUBG:EventStatus = false;
    PUBG:MapShrinkCount = 0;
    PUBG:ZoneID = -1;
    PUBG:ZoneID = CreateZone(-1000, 600, 1200, 3000);
    CreateZoneBorders(PUBG:ZoneID);
    PUBG:UpdatePlayerTdTimer = SetPreciseTimer("PubgUpdatePlayerTd", 1000, true);
    EventStartCall();
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerDataPUBG` (\
	  `Username` varchar(50) NOT NULL,\
	  `Kills` int(11) NOT NULL,\
	  `Deaths` int(11) NOT NULL,\
	  `Played` int(11) NOT NULL,\
	  `Wins` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    return 1;
}

hook OnGameModeExit() {
    DestroyZone(PUBG:ZoneID);
    DestroyZoneBorders(PUBG:ZoneID);
    DeletePreciseTimer(PUBG:UpdatePlayerTdTimer);
    return 1;
}

forward PubgPlayerDataUpdate(playerid);
public PubgPlayerDataUpdate(playerid) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "update playerDataPUBG SET Kills = \"%d\", Deaths = \"%d\", Played = \"%d\", Wins = \"%d\" where Username=\"%s\"",
        PUBG:GetPlayerKills(playerid), PUBG:GetPlayerDeaths(playerid), PUBG:GetPlayerPlayed(playerid), PUBG:GetPlayerWins(playerid), GetPlayerNameEx(playerid));
    mysql_tquery(Database, query);
    return 1;
}

forward PubgPlayerDataInit(playerid);
public PubgPlayerDataInit(playerid) {
    PUBG:SetPlayerKills(playerid, 0);
    PUBG:SetPlayerDeaths(playerid, 0);
    PUBG:SetPlayerPlayed(playerid, 0);
    PUBG:SetPlayerWins(playerid, 0);
    new rows = cache_num_rows();
    if (rows) {
        if (rows) {
            new temp_kills, temp_deaths, temp_played, temp_wins;
            cache_get_value_name_int(0, "Kills", temp_kills);
            cache_get_value_name_int(0, "Deaths", temp_deaths);
            cache_get_value_name_int(0, "Played", temp_played);
            cache_get_value_name_int(0, "Wins", temp_wins);
            PUBG:SetPlayerKills(playerid, temp_kills);
            PUBG:SetPlayerDeaths(playerid, temp_played);
            PUBG:SetPlayerPlayed(playerid, temp_played);
            PUBG:SetPlayerWins(playerid, temp_kills);
        }
    } else {
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO playerDataPUBG SET Username=\"%s\", Kills = \"0\", Deaths = \"0\", Played = \"0\", Wins = \"0\"", GetPlayerNameEx(playerid));
        mysql_tquery(Database, query);
    }
    Iter_Add(PubgPlayers, playerid);
    PUBG:PlayerInfoCreateTd(playerid);
    PUBG:PlayerInfoShowTd(playerid);
    LobberySpawn(playerid);
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != PUBG_Event_ID) return 1;
    new query[512];
    mysql_format(Database, query, sizeof(query), "SELECT * FROM `playerDataPUBG` WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "PubgPlayerDataInit", "i", playerid);
    ResetPlayerWeaponsEx(playerid);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != PUBG_Event_ID) return 1;
    Iter_Remove(PubgPlayers, playerid);
    HideZoneForPlayer(playerid, PUBG:ZoneID);
    PUBG:PlayerInfoHideTd(playerid);
    PUBG:PlayerInfoDestroyTd(playerid);
    PubgPlayerDataUpdate(playerid);
    return 1;
}

stock PUBG:PlayerInfoCreateTd(playerid) {
    PUBG:PlayerData[playerid][PUBG_TD_PInfoID] = CreatePlayerTextDraw(playerid, 40.000000, 250.000000, "Online Players~n~~n~Kills~n~~n~Deaths~n~~n~Played~n~~n~Wins");
    PlayerTextDrawAlignment(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 1);
    PlayerTextDrawBackgroundColor(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 0);
    PlayerTextDrawFont(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 2);
    PlayerTextDrawLetterSize(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 0.210000, 0.799999);
    PlayerTextDrawColor(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], -186);
    PlayerTextDrawSetOutline(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 0);
    PlayerTextDrawSetProportional(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 1);
    PlayerTextDrawSetShadow(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 1);
    PlayerTextDrawSetSelectable(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID], 0);
    return 1;
}

stock LobberySpawn(playerid) {
    SetPlayerVirtualWorldEx(playerid, PUBG_event_virtualworld);
    new Float:pos[3];
    GetRandomPosAtLocation(20, 3581.4910, -901.2957, 11.6064, pos[0], pos[1], pos[2]);
    SetPlayerPosEx(playerid, pos[0], pos[1], pos[2]);
    GameTextForPlayer(playerid, "~w~Welcome in ~r~PUBG~n~~w~Spawned at Lobby", 3000, 3);
    ZoneStopFlashForPlayer(playerid, PUBG:ZoneID);
    PUBG:SetPlayerInPlaneStatus(playerid, false);
    PUBG:SetPlayerInMatchStatus(playerid, false);
    ShowZoneForPlayer(playerid, PUBG:ZoneID, 0xFF0000AA, 0xFFFFFFFF, 0xFFFFFFFF);
    return 1;
}

stock PUBG:PlayerInfoDestroyTd(playerid) {
    PlayerTextDrawDestroy(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID]);
    return 1;
}

stock PUBG:PlayerInfoShowTd(playerid) {
    PlayerTextDrawShow(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID]);
    return 1;
}

stock PUBG:PlayerInfoHideTd(playerid) {
    PlayerTextDrawHide(playerid, PUBG:PlayerData[playerid][PUBG_TD_PInfoID]);
    return 1;
}

forward PubgUpdatePlayerTd();
public PubgUpdatePlayerTd() {
    foreach(new i:PubgPlayers) {
        if (!IsPlayerConnected(i)) continue;
        if (Event:GetID(i) != PUBG_Event_ID) {
            Iter_SafeRemove(PubgPlayers, i, i);
            continue;
        }
        if (PUBG:IsPlayerInMatch(i)) {
            new string[512];
            format(string, sizeof string, "Online Players: %d~n~~n~Alive: %d~n~~n~Kills: %d~n~~n~Deaths: %d", Iter_Count(PubgPlayers), PUBG:GetTotalAlive(), PUBG:GetPlayerKills(i), PUBG:GetPlayerDeaths(i));
            PlayerTextDrawSetString(i, PUBG:PlayerData[i][PUBG_TD_PInfoID], string);
        } else {
            new string[512];
            format(string, sizeof string, "Online Players: %d~n~~n~Kills: %d~n~~n~Deaths: %d~n~~n~Played: %d~n~~n~Wins: %d", Iter_Count(PubgPlayers), PUBG:GetPlayerKills(i), PUBG:GetPlayerDeaths(i), PUBG:GetPlayerPlayed(i), PUBG:GetPlayerWins(i));
            PlayerTextDrawSetString(i, PUBG:PlayerData[i][PUBG_TD_PInfoID], string);
        }
    }
    if (PUBG:GetTotalAlive() < 2 && PUBG:EventStatus) PUBG:EndEvent();
    return 1;
}

stock PUBG:EventStart() {
    if (PUBG:EventStatus) return 1;
    PUBG:EventStatus = true;
    new Float:plx, Float:ply;
    new Float:PlanX, Float:PlanY, Float:PlanR;
    PlanX = -1600;
    PlanY = frandom(600, 3000, 0);
    plx = 1600;
    ply = 3000 - PlanY;
    PlanR = GetAngleBetweenPoints(PlanX, PlanY, plx, ply) - 180;
    if (IsValidDynamicObject(PUBG:PlaneObjectID)) {
        DestroyDynamicObjectEx(PUBG:PlaneObjectID);
        PUBG:PlaneObjectID = -1;
    }
    PUBG:PlaneObjectID = CreateDynamicObject(14553, PlanX, PlanY, 500.0, 13.6, 0.0, PlanR, PUBG_event_virtualworld, -1, -1, 500, 500);
    SetDynamicObjectMaterial(PUBG:PlaneObjectID, 1, 19339, "coffin01", "coffin_top01", 0x00000000);
    SetDynamicObjectMaterial(PUBG:PlaneObjectID, 2, 19339, "coffin01", "coffin_top01", 0x00000000);
    MoveDynamicObject(PUBG:PlaneObjectID, plx, ply, 500.0, 65.0);
    if (PlanR <= 225 && PlanR >= 135) {
        PlanX = PlanX - 130 + (PlanX * 0.065);
        PlanY = PlanY - 130;
        plx = plx - 130 + (PlanX * 0.065);
        ply = ply - 130;
    } else if (PlanR >= -45 && PlanR <= 45) {
        PlanX = PlanX - 130 + (PlanX * 0.065);
        PlanY = PlanY + 130;
        plx = plx - 130 + (PlanX * 0.065);
        ply = ply + 130;
    } else if (PlanR >= 45 && PlanR <= 135) {
        PlanY = PlanY - 130 + (PlanY * 0.07428571429);
        PlanX = PlanX - 130;
        ply = ply - 130 + (ply * 0.07428571429);
        plx = plx - 130;
    } else if (PlanR >= 225 && PlanR <= 315) {
        PlanY = PlanY - 130 + (PlanY * 0.07428571429);
        PlanX = PlanX + 130;
        ply = ply - 130 + (ply * 0.07428571429);
        plx = plx + 130;
    }
    foreach(new i:PubgPlayers) {
        TogglePlayerSpectatingEx(i, true);
        new pl = CreatePlayerObject(i, 19300, PlanX, PlanY, 525, 0.0, 0.0, PlanR);
        MovePlayerObject(i, pl, plx, ply, 525, 65.0);
        TogglePlayerControllable(i, true);
        AttachCameraToPlayerObject(i, pl);
        PUBG:SetPlayerInPlaneStatus(i, true);
        PUBG:SetPlayerInMatchStatus(i, true);
        GameTextForPlayer(i, "~w~press ~r~Enter ~w~to spawn", 2000, 3);
        ZoneFlashForPlayer(i, PUBG:ZoneID, 0xA3FF4AAA);
        SendClientMessageEx(i, -1, "{4286f4}[PUBG]: {FFFFFF}Event Started");
        PUBG:SetPlayerPlayed(i, PUBG:GetPlayerPlayed(i) + 1);
    }
    PUBG:SpawnVehicles();
    PUBG:SpawnPickups();
    PUBG:MapShrinkCount = 0;
    PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 15 * 1000, false);
    PUBG:PlayerInMapTimer = SetPreciseTimer("IsPlayerInMatchArea", 6 * 1000, true);
    return 1;
}

stock PUBG:EndEvent() {
    if (!PUBG:EventStatus) return 1;
    PUBG:EventStatus = false;
    DeletePreciseTimer(PUBG:PlayerInMapTimer);
    PUBG:PlayerInMapTimer = -1;
    DeletePreciseTimer(PUBG:MapShrinkTimer);
    PUBG:MapShrinkTimer = -1;
    foreach(new i:PubgPlayers) {
        if (PUBG:IsPlayerInMatch(i)) {
            SendClientMessageEx(i, -1, "{4286f4}[PUBG]: {FFFFFF} you won the match");
            GameTextForPlayer(i, "~r~you won the match", 1000, 3);
            PUBG:SetPlayerWins(i, PUBG:GetPlayerWins(i) + 1);
            if (IsPlayerInAnyVehicle(i)) RemovePlayerFromVehicle(i);
            SendClientMessageEx(i, -1, "{4286f4}[PUBG]: {FFFFFF}Event End");
        }
        LobberySpawn(i);
    }
    PUBG:DestroyVehicles();
    PUBG:DestroyPickups();
    EventStartCall();
    return 1;
}

forward MapShrinkActivate();
public MapShrinkActivate() {
    if (!PUBG:EventStatus) return PUBG:EndEvent();
    if (PUBG:MapShrinkCount == 0) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-1000, 600, 1200, 3000);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount += 1;
        PUBG:WarnForMapArea();
        PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 5 * 60 * 1000, false);
    } else if (PUBG:MapShrinkCount == 1) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-800, 800, 1000, 2800);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount += 1;
        PUBG:WarnForMapArea();
        PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 5 * 60 * 1000, false);
    } else if (PUBG:MapShrinkCount == 2) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-600, 1000, 800, 2600);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount += 1;
        PUBG:WarnForMapArea();
        PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 5 * 60 * 1000, false);
    } else if (PUBG:MapShrinkCount == 3) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-400, 1200, 600, 2400);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount += 1;
        PUBG:WarnForMapArea();
        PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 5 * 60 * 1000, false);
    } else if (PUBG:MapShrinkCount == 4) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-200, 1400, 400, 2200);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount += 1;
        PUBG:WarnForMapArea();
        PUBG:MapShrinkTimer = SetPreciseTimer("MapShrinkActivate", 5 * 60 * 1000, false);
    } else if (PUBG:MapShrinkCount == 5) {
        DestroyZone(PUBG:ZoneID);
        DestroyZoneBorders(PUBG:ZoneID);
        PUBG:ZoneID = CreateZone(-1000, 600, 1200, 3000);
        CreateZoneBorders(PUBG:ZoneID);
        PUBG:MapShrinkCount = 0;
        PUBG:EndEvent();
    }
    return 1;
}

stock PUBG:WarnForMapArea() {
    foreach(new i:PubgPlayers) {
        ShowZoneForPlayer(i, PUBG:ZoneID, 0xFF0000AA, 0xFFFFFFFF, 0xFFFFFFFF);
        if (PUBG:IsPlayerInMatch(i)) GameTextForPlayer(i, "~r~Map Shrinked~n~~w~Stay In PlayZone", 3000, 3);
    }
    return 1;
}

hook OnDynamicObjectMoved(objectid) {
    if (objectid == PUBG:PlaneObjectID) {
        foreach(new i:PubgPlayers) {
            if (PUBG:IsPlayerInPlane(i)) {
                new Float:X, Float:Y, Float:Z, Float:R;
                GetDynamicObjectPos(PUBG:PlaneObjectID, X, Y, Z);
                GetDynamicObjectRot(PUBG:PlaneObjectID, R, R, R);
                TogglePlayerSpectatingEx(i, false);
                TogglePlayerControllable(i, true);
                GivePlayerWeaponEx(i, 46, 1);
                SetPlayerFacingAngle(i, R + 180);
                SetCameraBehindPlayer(i);
                if (R <= 225 && R >= 135) {
                    X = X - 25 + (X * 0.0125);
                    Y = Y - 25;
                } else if (R >= -45 && R <= 45) {
                    X = X - 25 + (X * 0.0125);
                    Y = Y + 25;
                } else if (R >= 45 && R <= 135) {
                    Y = Y - 25 + (Y * 0.01428571429);
                    X = X - 25;
                } else if (R >= 225 && R <= 315) {
                    Y = Y - 25 + (Y * 0.01428571429);
                    X = X + 25;
                }
                SetPlayerPosEx(i, (X + 10) - random(20), (Y + 10) - random(20), 483 - random(6));
                PUBG:SetPlayerInPlaneStatus(i, false);
                GameTextForPlayer(i, "~r~Auto Spawned", 2000, 3);
                MoveDynamicObject(PUBG:PlaneObjectID, 0, 0, 500.0, 65.0);
                PubgDestroyPlane();
                return 1;
            }
        }
    }
    return 1;
}

forward PubgDestroyPlane();
public PubgDestroyPlane() {
    if (IsValidDynamicObject(PUBG:PlaneObjectID)) {
        DestroyDynamicObjectEx(PUBG:PlaneObjectID);
        PUBG:PlaneObjectID = -1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    if (PUBG:IsPlayerInPlane(playerid) && newkeys == KEY_SECONDARY_ATTACK) {
        new Float:X, Float:Y, Float:Z, Float:R;
        GetDynamicObjectPos(PUBG:PlaneObjectID, X, Y, Z);
        GetDynamicObjectRot(PUBG:PlaneObjectID, R, R, R);
        TogglePlayerSpectatingEx(playerid, false);
        TogglePlayerControllable(playerid, true);
        GivePlayerWeaponEx(playerid, 46, 1);
        SetPlayerFacingAngle(playerid, R + 180);
        SetCameraBehindPlayer(playerid);
        if (R <= 225 && R >= 135) {
            X = X - 25 + (X * 0.0125);
            Y = Y - 25;
        } else if (R >= -45 && R <= 45) {
            X = X - 25 + (X * 0.0125);
            Y = Y + 25;
        } else if (R >= 45 && R <= 135) {
            Y = Y - 25 + (Y * 0.01428571429);
            X = X - 25;
        } else if (R >= 225 && R <= 315) {
            Y = Y - 25 + (Y * 0.01428571429);
            X = X + 25;
        }
        SetPlayerPosEx(playerid, (X + 10) - random(20), (Y + 10) - random(20), 483 - random(6));
        PUBG:SetPlayerInPlaneStatus(playerid, false);
        return ~1;
    }
    return ~1;
}

stock PUBG:SpawnVehicles() {
    new Float:x, Float:y, Float:z;
    for (new i; i < Iter_Count(PubgPlayers) * 2; i++) {
        PUBG:GetRandomLocation(x, y, z);
        new vehicleid = CreateVehicle(RandomNumberFromArray(LightMotor_Vehicles), x, y, z, -1, -1, -1, -1, 0, PUBG_event_virtualworld, 0, true);
        ResetVehicleEx(vehicleid);
        Iter_Add(PubgVehicles, vehicleid);
    }
    return 1;
}

forward PUBG:DestroyVehicles();
public PUBG:DestroyVehicles() {
    foreach(new i:PubgVehicles) {
        if (IsValidVehicle(i)) DestroyVehicle(i);
        Iter_SafeRemove(PubgVehicles, i, i);
    }
    return 1;
}

stock PUBG:SpawnPickups() {
    new weapons[] = { 1, 4, 5, 6, 7, 8, 9, 16, 17, 18, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 39, 44, 45, 46 };
    for (new i; i < Iter_Count(PubgPlayers); i++) {
        for (new j; j < sizeof weapons; j++) {
            new weaponid = weapons[j];
            new Float:x, Float:y, Float:z;
            new id = Iter_Free(PUBG_Pickups);
            if (id == INVALID_ITERATOR_SLOT) break;
            PUBG:GetRandomLocation(x, y, z);
            z -= 1.5;
            PUBG:PickupData[id][pubg_pickupid] = CreateDynamicPickup(GetWeaponModel(weaponid), 1, x, y, z, PUBG_event_virtualworld, -1, -1);
            PUBG:PickupData[id][pubg_pickuptype] = weaponid;
            Iter_Add(PUBG_Pickups, id);
        }
    }
}

hook OPPickUpDynPickup(playerid, pickupid) {
    foreach(new i:PUBG_Pickups) {
        if (PUBG:PickupData[i][pubg_pickupid] != pickupid) continue;
        DestroyDynamicPickup(pickupid);
        Iter_SafeRemove(PUBG_Pickups, i, i);
        GivePlayerWeaponEx(playerid, PUBG:PickupData[i][pubg_pickuptype], 50);
        new string[256];
        format(string, sizeof string, "~w~picked ~r~%s", GetWeaponNameEx(PUBG:PickupData[i][pubg_pickuptype]));
        GameTextForPlayer(playerid, string, 1500, 3);
        break;
    }
    return 1;
}

forward PUBG:DestroyPickups();
public PUBG:DestroyPickups() {
    foreach(new i:PUBG_Pickups) {
        if (IsValidDynamicPickup(PUBG:PickupData[i][pubg_pickupid])) DestroyDynamicPickup(PUBG:PickupData[i][pubg_pickupid]);
        Iter_SafeRemove(PUBG_Pickups, i, i);
    }
    return 1;
}

forward IsPlayerInMatchArea();
public IsPlayerInMatchArea() {
    if (!PUBG:EventStatus) {
        DeletePreciseTimer(PUBG:PlayerInMapTimer);
        PUBG:PlayerInMapTimer = -1;
        return 1;
    }
    new Float:x, Float:y, Float:X, Float:Y;
    if (PUBG:MapShrinkCount == 0) x = -1000, y = 600, X = 1200, Y = 3000;
    if (PUBG:MapShrinkCount == 1) x = -800, y = 800, X = 1000, Y = 2800;
    if (PUBG:MapShrinkCount == 2) x = -600, y = 1000, X = 800, Y = 2600;
    if (PUBG:MapShrinkCount == 3) x = -400, y = 1200, X = 600, Y = 2400;
    if (PUBG:MapShrinkCount == 4) x = -200, y = 1400, X = 400, Y = 2200;
    foreach(new i:PubgPlayers) {
        if (!IsPlayerInArea(i, x, y, X, Y) && PUBG:IsPlayerInMatch(i) && !PUBG:IsPlayerInPlane(i)) {
            GameTextForPlayer(i, "~w~Get Back in PlayZone~n~Health ~r~-1", 1000, 3);
            SetPlayerHealthEx(i, GetPlayerHealthEx(i) - 2);
        }
        if (PUBG:IsPlayerInMatch(i)) ZoneFlashForPlayer(i, PUBG:ZoneID, 0xA3FF4AAA);
    }
    return 1;
}

forward EventStartCall();
public EventStartCall() {
    if (PUBG:EventStatus) return 1;
    if (PUBG:MatchStartCountDown <= 0) PUBG:MatchStartCountDown = 120;
    PUBG:MatchStartCountDown--;
    if (PUBG:MatchStartCountDown == 0) {
        if (Event:GetOnlinePlayerIn(PUBG_Event_ID) < 4) {
            foreach(new i:PubgPlayers) GameTextForPlayer(i, "~w~Not Enought ~r~Players~n~~w~to start event~n~~r~Required 4 players", 5000, 3);
        } else PUBG:EventStart();
    } else {
        foreach(new i:PubgPlayers) GameTextForPlayer(i, sprintf("~g~Next Round~n~~r~CountDown: ~w~%d", PUBG:MatchStartCountDown), 950, 3);
    }
    SetPreciseTimer("EventStartCall", 1000, false);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    if (Iter_Contains(PubgPlayers, playerid)) Iter_Remove(PubgPlayers, playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    return 1;
}

hook OnPlayerKilled(playerid, killerid, weaponid) {
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    if (PUBG:IsPlayerInMatch(playerid)) {
        GameTextForPlayer(playerid, "~w~Death Increase", 3000, 3);
        PUBG:SetPlayerDeaths(playerid, PUBG:GetPlayerDeaths(playerid) + 1);
    }
    if (PUBG:IsPlayerInMatch(playerid) && IsPlayerConnected(killerid)) {
        if (PUBG:IsPlayerInMatch(killerid)) {
            GameTextForPlayer(killerid, "~w~kills Increase", 3000, 3);
            PUBG:SetPlayerKills(killerid, PUBG:GetPlayerKills(killerid) + 1);
        }
    }
    PUBG:SetPlayerInMatchStatus(playerid, false);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    if (!PUBG:IsPlayerInMatch(playerid)) LobberySpawn(playerid);
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    if (Event:GetID(playerid) != PUBG_Event_ID) return 1;
    if (Event:IsInEvent(playerid)) Event:Leave(playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `playerDataPUBG` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `playerDataPUBG` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}