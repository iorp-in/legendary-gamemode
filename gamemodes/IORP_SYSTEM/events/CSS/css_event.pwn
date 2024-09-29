#define CSS_EVENT_ID 2
#define CSS_TEAM_RED 1
#define CSS_TEAM_BLUE 2
#define cs_virtualworldID 12
#define cs_InteriorID 0
enum CSS_EVENT_PLAYER_DATA_ENUM {
    bool:CSS_IsPlayerDeath
};
new CSS_EVENT_PLAYER_DATA[MAX_PLAYERS][CSS_EVENT_PLAYER_DATA_ENUM];
enum CSS_Bomb_Data_Enum {
    PickupID,
    TimerID,
    Float:C4_X,
    Float:C4_Y,
    Float:C4_Z,
};
new CSS_Bomb_Data[CSS_Bomb_Data_Enum];

hook OnGameModeInit() {
    CSS_Bomb_Data[PickupID] = -1;
    CSS_Bomb_Data[TimerID] = -1;
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != CSS_EVENT_ID) return 1;
    ResetPlayerWeaponsEx(playerid);
    FlexPlayerDialog(playerid, "CssEventJoinMenu", DIALOG_STYLE_LIST, "Counter Strike Source: Event", "Terrorists\nCounter-Terrorists", "Join", "Leave");
    return 1;
}

FlexDialog:CssEventJoinMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Event:Leave(playerid);
    new string[512];
    if (!strcmp("Terrorists", inputtext)) {
        format(string, sizeof(string), "{4286f4}[CSS Event]: {FFFFEE}%s has joined the Terrorist.", GetPlayerNameEx(playerid));
        SendClientMessageToAll(COLOR_RED, string);
        CSS_Spawn_TR(playerid);
        InvisibleAuth:SetPlayer(playerid, true);
        return 1;
    }
    if (!strcmp("Counter-Terrorists", inputtext)) {
        format(string, sizeof(string), "{4286f4}[CSS Event]: {FFFFEE}%s has joined the Counter-Terrorist.", GetPlayerNameEx(playerid));
        SendClientMessageToAll(COLOR_BLUE, string);
        CSS_Spawn_CT(playerid);
        InvisibleAuth:SetPlayer(playerid, true);
        return 1;
    }
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != CSS_EVENT_ID) return 1;
    ResetPlayerWeaponsEx(playerid);
    InvisibleAuth:SetPlayer(playerid, false);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    CSS_SetPDeathstatus(playerid, false);
    return 1;
}

hook OnPlayerEventDeath(playerid, killerid, reason, eventid) {
    if (eventid != CSS_EVENT_ID) return 1;
    SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerSkin(playerid), RandomEx(193, 198), RandomEx(1783, 1788), 18.0, 0, -1, -1, -1, -1, -1, -1);
    return 1;
}

stock CSS_Spawn_CT(playerid) {
    SendClientMessageEx(playerid, COLOR_BLUE, "{4286f4}[CSS Event]: {FFFFEE}Your team is Team Blue or Counter-Terrorist");
    SendClientMessageEx(playerid, COLOR_BLUE, "{4286f4}[CSS Event]: {FFFFEE}Press F or Enter to defuse Bomb");
    SetPlayerVirtualWorldEx(playerid, cs_virtualworldID);
    SetPlayerInteriorEx(playerid, cs_InteriorID);
    SetPlayerPosEx(playerid, RandomEx(193, 198), RandomEx(1783, 1788), 42);
    SetPlayerTeam(playerid, CSS_TEAM_BLUE);
    SetPlayerColor(playerid, COLOR_BLUE);
    SetPlayerHealthEx(playerid, 100);
    SetPlayerArmourEx(playerid, 100);
    SetPlayerSkinEx(playerid, 285);
    ResetPlayerWeaponsEx(playerid);
    GivePlayerWeaponEx(playerid, 22, 10000);
    GivePlayerWeaponEx(playerid, 27, 10000);
    GivePlayerWeaponEx(playerid, 29, 10000);
    GivePlayerWeaponEx(playerid, 31, 10000);
    GivePlayerWeaponEx(playerid, 34, 10000);
    CSS_SetPDeathstatus(playerid, false);
    return 1;
}
stock CSS_Spawn_TR(playerid) {
    SendClientMessageEx(playerid, COLOR_RED, "{4286f4}[CSS Event]: {FFFFEE}Your team is Team Red or Terrorist");
    SendClientMessageEx(playerid, COLOR_RED, "{4286f4}[CSS Event]: {FFFFEE}Press F or Enter to place Bomb");
    SetPlayerVirtualWorldEx(playerid, cs_virtualworldID);
    SetPlayerInteriorEx(playerid, cs_InteriorID);
    SetPlayerPosEx(playerid, RandomEx(121, 126), RandomEx(1583, 1588), 50);
    SetPlayerTeam(playerid, CSS_TEAM_RED);
    SetPlayerColor(playerid, COLOR_RED);
    SetPlayerHealthEx(playerid, 100);
    SetPlayerArmourEx(playerid, 100);
    SetPlayerSkinEx(playerid, 179);
    ResetPlayerWeaponsEx(playerid);
    GivePlayerWeaponEx(playerid, 24, 10000);
    GivePlayerWeaponEx(playerid, 25, 10000);
    GivePlayerWeaponEx(playerid, 32, 10000);
    GivePlayerWeaponEx(playerid, 33, 10000);
    GivePlayerWeaponEx(playerid, 30, 10000);
    CSS_SetPDeathstatus(playerid, false);
    return 1;
}

forward CSS_Respawn();
public CSS_Respawn() {
    CSS_Bomb_Data[PickupID] = -1;
    CSS_Bomb_Data[TimerID] = -1;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_RED) CSS_Spawn_TR(playerid);
                if (GetPlayerTeam(playerid) == CSS_TEAM_BLUE) CSS_Spawn_CT(playerid);
            }
        }
    }
    return 1;
}

stock CSS_SetPDeathstatus(playerid, bool:status) {
    CSS_EVENT_PLAYER_DATA[playerid][CSS_IsPlayerDeath] = status;
    return 1;
}

stock CSS_GetPDeathstatus(playerid) {
    return CSS_EVENT_PLAYER_DATA[playerid][CSS_IsPlayerDeath];
}

stock CSS_GetPCountCT() {
    new count = 0;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_BLUE) count++;
            }
        }
    }
    return count;
}

stock CSS_GetPCountT() {
    new count = 0;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_RED) count++;
            }
        }
    }
    return count;
}

stock CSS_IsTeamBalanced() {
    if (CSS_GetPCountT() == 0 || CSS_GetPCountCT() == 0) return false;
    return true;
}

stock CSS_GetTPAliveCountCT() {
    new count = 0;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_BLUE) {
                    if (!CSS_GetPDeathstatus(playerid)) count++;
                }
            }
        }
    }
    return count;
}

stock CSS_GetTPAliveCountT() {
    new count = 0;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_RED) {
                    if (!CSS_GetPDeathstatus(playerid)) count++;
                }
            }
        }
    }
    return count;
}

stock CSS_TeamWinCT() {
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                GameTextForPlayer(playerid, "~b~Counter-Terrorist Win", 3000, 5);
                SetTimer("CSS_Respawn", 10000, false);
            }
        }
    }
    return 1;
}

stock CSS_TeamWinT() {
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                GameTextForPlayer(playerid, "~r~Terrorist Win", 3000, 5);
                SetTimer("CSS_Respawn", 10000, false);
            }
        }
    }
    return 1;
}

forward CSS_Bomb(Float:X, Float:Y, Float:Z, type, Float:Radius);
public CSS_Bomb(Float:X, Float:Y, Float:Z, type, Float:Radius) {
    DestroyDynamicObjectEx(CSS_Bomb_Data[PickupID]);
    new count;
    for (count = 0; count <= 20; count++) {
        CreateExplosion(X, Y, Z, type, Radius);
    }
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                SendClientMessageEx(playerid, COLOR_RED, "{4286f4}[CSS Event]: {FFFFEE}Bomb exploded. Terrorist win");
            }
        }
    }
    CSS_TeamWinT();
    return 1;
}

forward CSS_Defuse_Bomb();
public CSS_Defuse_Bomb() {
    KillTimer(CSS_Bomb_Data[TimerID]);
    DestroyDynamicObjectEx(CSS_Bomb_Data[PickupID]);
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                SendClientMessageEx(playerid, COLOR_BLUE, "{4286f4}[CSS Event]: {FFFFEE}Bomb defused. Counter-Terrorist win");
            }
        }
    }
    CSS_TeamWinCT();
    return 1;
}
stock CSS_IsBombPlanted() {
    if (CSS_Bomb_Data[TimerID] != -1) return true;
    return false;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (Event:IsInEvent(playerid)) {
        if (Event:GetID(playerid) == CSS_EVENT_ID) {
            CSS_SetPDeathstatus(playerid, true);
            if (CSS_IsTeamBalanced() && !CSS_IsBombPlanted()) {
                if (CSS_GetTPAliveCountCT() != 0 && CSS_GetTPAliveCountT() == 0) {
                    CSS_TeamWinCT();
                }
                if (CSS_GetTPAliveCountCT() == 0 && CSS_GetTPAliveCountT() != 0) {
                    CSS_TeamWinT();
                }
            }
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_SECONDARY_ATTACK) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == CSS_EVENT_ID) {
                if (GetPlayerTeam(playerid) == CSS_TEAM_RED) {
                    if (IsPlayerInRangeOfPoint(playerid, 10, 230, 1800, 55) || IsPlayerInRangeOfPoint(playerid, 10, 65, 1805, 45)) {
                        if (CSS_IsTeamBalanced() && !CSS_IsBombPlanted()) {
                            new worldid, interiorid;
                            GetPlayerPos(playerid, CSS_Bomb_Data[C4_X], CSS_Bomb_Data[C4_Y], CSS_Bomb_Data[C4_Z]);
                            worldid = GetPlayerVirtualWorld(playerid);
                            interiorid = GetPlayerInterior(playerid);
                            CSS_Bomb_Data[PickupID] = CreateDynamicObject(1252, CSS_Bomb_Data[C4_X], CSS_Bomb_Data[C4_Y], CSS_Bomb_Data[C4_Z], 0, 0, 0, worldid, interiorid);
                            CSS_Bomb_Data[TimerID] = SetTimerEx("CSS_Bomb", 30000, false, "fffif", CSS_Bomb_Data[C4_X], CSS_Bomb_Data[C4_Y], CSS_Bomb_Data[C4_Z], 6, 150.0);
                            foreach(new pID:Player) {
                                if (Event:IsInEvent(pID)) {
                                    if (Event:GetID(pID) == CSS_EVENT_ID) {
                                        SendClientMessageEx(pID, COLOR_RED, "{4286f4}[CSS Event]: {FFFFEE}Bomb planted. 30 seconds to blow.");
                                    }
                                }
                            }
                            return ~1;
                        }
                    }
                }
                if (GetPlayerTeam(playerid) == CSS_TEAM_BLUE) {
                    if (CSS_IsBombPlanted()) {
                        if (IsPlayerInRangeOfPoint(playerid, 5, CSS_Bomb_Data[C4_X], CSS_Bomb_Data[C4_Y], CSS_Bomb_Data[C4_Z])) {
                            SendClientMessageEx(playerid, COLOR_BLUE, "{4286f4}[CSS Event]: {FFFFEE}Bomb defusing in 5 seconds.");
                            SetTimer("CSS_Defuse_Bomb", 5000, false);
                        }
                        return ~1;
                    }
                }
            }
        }
    }
    return 1;
}