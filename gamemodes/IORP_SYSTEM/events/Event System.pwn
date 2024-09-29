#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/Stunt World/stunt_world.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/Skyfall/skyfall_track.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/CSS/css_event.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/Race Track/race_track.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/COD/cod_event.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/PUBG/PUBG.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/Fallout/fallout.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/events/SUMO/sumo.pwn"
#include <YSI_Coding\y_hooks>

enum Event:DataEnum {
    Event:Name[50],
        bool:Event:Status,
        Event:MinimumScore
};

new Event:Data[][Event:DataEnum] = {
    { "Stunt World", true, 2 }, // 0
    { "Skyfall Track", true, 4 }, // 1
    { "Counter Strike Source", true, 5 }, // 2
    { "Race Track", true, 6 }, // 3
    { "Call of Duty:World War III", true, 10 }, // 4
    { "PlayerUnknown's Battlegrounds", true, 10 }, // 5
    { "Fall Out", true, 6 }, // 6
    { "SUMO", true, 2 } // 7
};

enum Event:PlayerDataEnum {
    Event:PdEventID,
    Event:PdSkinID,
    Float:Event:PdPosX,
    Float:Event:PdPosY,
    Float:Event:PdPosZ,
    Float:Event:PdPosA,
    Event:PdPosVW,
    Event:PdPosINT,
    bool:Event:PdVehicleSpawnAuth,

    Event:pHealth,
    Event:pArmour
};
new Event:PlayerData[MAX_PLAYERS][Event:PlayerDataEnum];

new Event:PlayerWeaponsData[MAX_PLAYERS][13][2];

stock bool:Event:GetVehicleAuth(playerid) {
    return Event:PlayerData[playerid][Event:PdVehicleSpawnAuth];
}

stock Event:SetVehicleAuth(playerid, bool:status) {
    Event:PlayerData[playerid][Event:PdVehicleSpawnAuth] = status;
    return 1;
}

stock Event:GetID(playerid) {
    return Event:PlayerData[playerid][Event:PdEventID];
}

stock Event:IsInEvent(playerid) {
    if (Event:GetID(playerid) == -1) return false;
    return true;
}

stock Event:SetID(playerid, eventid) {
    Event:PlayerData[playerid][Event:PdEventID] = eventid;
    return 1;
}

stock Event:IsValidID(eventid) {
    new count = 0;
    while (count < sizeof Event:Data) {
        if (count == eventid) return true;
        count++;
    }
    return false;
}

stock Event:GetOnlinePlayerIn(eventid) {
    new count = 0;
    foreach(new playerid:Player) {
        if (Event:IsInEvent(playerid)) {
            if (Event:GetID(playerid) == eventid) count++;
        }
    }
    return count;
}

stock Event:GetName(eventid) {
    new string[50];
    format(string, sizeof string, "%s", Event:Data[eventid][Event:Name]);
    return string;
}

stock Event:GetMinimumScore(eventid) {
    return Event:Data[eventid][Event:MinimumScore];
}

stock Event:GetStatus(eventid) {
    return Event:Data[eventid][Event:Status];
}

stock Event:SetStatus(eventid, bool:status) {
    return Event:Data[eventid][Event:Status] = status;
}

stock Event:Join(playerid, eventid) {
    new string[512];
    if (!Event:IsValidID(eventid)) return 0;
    if (Event:IsInEvent(playerid)) return format(string, sizeof string, "{4286f4}[Gaming Zone]:{FFFFEE}please leave your current event to join another", Event:GetName(eventid)), SendClientMessageEx(playerid, -1, string);
    if (!Event:GetStatus(eventid)) return format(string, sizeof string, "{4286f4}[Gaming Zone]:{FFFFEE}%s is disabled at the movement, try again", Event:GetName(eventid)), SendClientMessageEx(playerid, -1, string);
    Event:PlayerData[playerid][Event:pHealth] = GetPlayerHealthEx(playerid);
    Event:PlayerData[playerid][Event:pArmour] = GetPlayerArmourEx(playerid);
    GetPlayerPos(playerid, Event:PlayerData[playerid][Event:PdPosX], Event:PlayerData[playerid][Event:PdPosY], Event:PlayerData[playerid][Event:PdPosZ]);
    GetPlayerFacingAngle(playerid, Event:PlayerData[playerid][Event:PdPosA]);
    Event:PlayerData[playerid][Event:PdPosVW] = GetPlayerVirtualWorld(playerid);
    Event:PlayerData[playerid][Event:PdPosINT] = GetPlayerInterior(playerid);
    Event:PlayerData[playerid][Event:PdSkinID] = GetPlayerSkin(playerid);
    Faction:HideZoneToPlayer(playerid);
    Event:SetID(playerid, eventid);
    for (new i = 0; i <= 12; i++) GetPlayerWeaponData(playerid, i, Event:PlayerWeaponsData[playerid][i][0], Event:PlayerWeaponsData[playerid][i][1]);
    ResetPlayerWeaponsEx(playerid);
    format(string, sizeof string, "{4286f4}[Gaming Zone]:{FFFFEE}%s started playing %s", GetPlayerNameEx(playerid), Event:GetName(eventid));
    SendClientMessageToAll(-1, string);
    CallRemoteFunction("OnPlayerEventJoin", "ii", playerid, eventid);
    return 1;
}

forward OnPlayerEventJoin(playerid, eventid);
public OnPlayerEventJoin(playerid, eventid) {
    return 1;
}

forward OnPlayerEventLeave(playerid, eventid);
public OnPlayerEventLeave(playerid, eventid) {
    return 1;
}

forward OnPlayerEventDeath(playerid, killerid, reason, eventid);
public OnPlayerEventDeath(playerid, killerid, reason, eventid) {
    return 1;
}

stock Event:Leave(playerid) {
    CallRemoteFunction("OnPlayerEventLeave", "ii", playerid, Event:GetID(playerid));
    new string[512];
    format(string, sizeof string, "{4286f4}[Gaming Zone]:{FFFFEE} you have leaved the game");
    SendClientMessageEx(playerid, -1, string);
    SetPlayerTeam(playerid, 0);
    SetPlayerColor(playerid, Player_Color);
    SetPlayerHealthEx(playerid, Event:PlayerData[playerid][Event:pHealth]);
    SetPlayerArmourEx(playerid, Event:PlayerData[playerid][Event:pArmour]);
    SetPlayerPosEx(playerid, Event:PlayerData[playerid][Event:PdPosX], Event:PlayerData[playerid][Event:PdPosY], Event:PlayerData[playerid][Event:PdPosZ]);
    SetPlayerFacingAngle(playerid, Event:PlayerData[playerid][Event:PdPosA]);
    SetPlayerVirtualWorldEx(playerid, Event:PlayerData[playerid][Event:PdPosVW]);
    SetPlayerInteriorEx(playerid, Event:PlayerData[playerid][Event:PdPosINT]);
    SetPlayerSkinEx(playerid, Event:PlayerData[playerid][Event:PdSkinID]);
    SetCameraBehindPlayer(playerid);
    Event:SetID(playerid, -1);
    Faction:ShowZoneToPlayer(playerid);
    Event:SetVehicleAuth(playerid, false);
    ResetPlayerWeaponsEx(playerid);
    for (new i = 0; i <= 12; i++) GivePlayerWeaponEx(playerid, Event:PlayerWeaponsData[playerid][i][0], Event:PlayerWeaponsData[playerid][i][1]);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Event:SetID(playerid, -1);
    Event:SetVehicleAuth(playerid, false);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    return 1;
}

stock Event:MainMenu(playerid) {
    new string[2000];
    strcat(string, "#\tName\tStatus\tMin Score Required\n");
    for (new eventid; eventid < sizeof Event:Data; eventid++) {
        strcat(string, sprintf(
            "%d\t%s\t%s\t%d\n",
            eventid, Event:GetName(eventid),
            (Event:GetStatus(eventid)) ? ("Enabled") : ("Disabled"),
            Event:GetMinimumScore(eventid)
        ));
    }
    if (Event:IsInEvent(playerid)) strcat(string, "Leave\tEvent\n");
    return FlexPlayerDialog(playerid, "EventMainMenu", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}Gaming Zone: {FFFFFF}Games List", string, "Join", "Close");
}

FlexDialog:EventMainMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new eventid = listitem;
    if (IsStringSame("Leave", inputtext)) return Event:Leave(playerid);
    if (GetPlayerAdminLevel(playerid) > 3) return Event:AdminMenu(playerid, eventid);
    if (GetPlayerScore(playerid) < Event:GetMinimumScore(eventid)) {
        SendClientMessage(playerid, -1, "{F1C40F}Gaming Zone:{FFFFFF} you does not have minimum score required for this event.");
        Event:MainMenu(playerid);
        return ~1;
    }
    //    if (Faction:IsPlayerSigned(playerid)) {
    //        SendClientMessage(playerid, -1, "{F1C40F}Gaming Zone:{FFFFFF} you can not join event on duty, please sign off.");
    //        Event:MainMenu(playerid);
    //        return ~1;
    //    }
    //    if (GetPlayerRPMode(playerid)) {
    //        SendClientMessage(playerid, -1, "{F1C40F}Gaming Zone:{FFFFFF} you can not join event while you are in fight mode.");
    //        Event:MainMenu(playerid);
    //        return ~1;
    //    }
    return Event:Join(playerid, eventid);
}

stock Event:AdminMenu(playerid, eventid) {
    new string[512];
    if (Event:GetStatus(eventid)) {
        strcat(string, "Join\n");
        strcat(string, "Disable\n");
    } else {
        strcat(string, "Enable\n");
    }
    return FlexPlayerDialog(playerid, "EventAdminMenu", DIALOG_STYLE_LIST, "{F1C40F}Gaming Zone: {FFFFFF}Games List", string, "Select", "Close", eventid);
}

FlexDialog:EventAdminMenu(playerid, response, listitem, const inputtext[], eventid, const payload[]) {
    if (!response) return Event:MainMenu(playerid);
    if (IsStringSame(inputtext, "Join")) return Event:Join(playerid, eventid);
    if (IsStringSame(inputtext, "Disable") || IsStringSame(inputtext, "Enable")) {
        Event:SetStatus(eventid, !Event:GetStatus(eventid));
        Event:AdminMenu(playerid, eventid);
    }
    return 1;
}

stock Event:SpawnVehicle(playerid, const Vehicle[], VehicleID, ColorOne, ColorTwo) {
    if (!Event:IsInEvent(playerid)) return 0;
    if (!Event:GetVehicleAuth(playerid)) return 0;
    new string[512];
    if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
    else {
        new vcount = 0, ovtl[5];
        for (new d = 0; d < 212; d++) {
            if (strfind(GetVehicleModelName(d + 400), Vehicle, true) != -1 || strval(Vehicle) == d + 400) {
                VehicleID = d + 400;
                if (vcount < 5) ovtl[vcount] = VehicleID;
                else return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}More than 5 results with that name were found.");
                vcount++;
            }
        }
        if (vcount > 1) {
            for (new e = 0; e < vcount; e++) {
                if (e == 0) SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}we got many vehicles with this name, here's the list..");
                format(string, 64, " %s [Model - %d]", GetVehicleModelName(ovtl[e]), ovtl[e]);
                SendClientMessageEx(playerid, -1, string);
            }
            return 1;
        }
    }
    if (VehicleID < 400 || VehicleID > 611) return SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Gaming Zone]: {FFFFFF}You entered an invalid vehiclename!");
    if (VehicleID == 611) return SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Gaming Zone]: {FFFFFF}This vehicle can not be spawned!!");
    new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
    GetPlayerPos(playerid, pX, pY, pZ);
    GetPlayerFacingAngle(playerid, pAngle);
    GetXYInFrontOfPlayer(playerid, pX, pY, 3);
    vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), true);
    ResetVehicleEx(vehicleid);
    SetVehicleFuelEx(vehicleid, 99.0);
    Iter_Add(ASpawnedVeh, vehicleid);
    PutPlayerInVehicleEx(playerid, vehicleid, 0);
    format(string, sizeof string, "{4286f4}[Gaming Zone]:{FFFFEE} you spawned %s", GetVehicleModelName(VehicleID));
    SendClientMessageEx(playerid, COLOR_GREY, string);
    return 1;
}

stock Event:SendMessage(playerid, eventid, const message[]) {
    if (Event:GetID(playerid) != eventid) return 0;
    return SendClientMessageEx(playerid, -1, message);
}

stock Event:SendMessageToAll(eventid, const message[]) {
    foreach(new i:Player) Event:SendMessage(i, eventid, message);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Event:IsInEvent(playerid)) UCP:AddCommand(playerid, "Leave Game", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Leave Game", inputtext)) return Event:Leave(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!Event:IsInEvent(playerid) || !Event:GetVehicleAuth(playerid) || strcmp(cmd, "espawn")) return 1;
    new Vehicle[50], VehicleID, ColorOne = -1, ColorTwo = -1;
    sscanf(GetNextWordFromString(text, "espawn", 1), "s[32]", Vehicle);
    sscanf(GetNextWordFromString(text, "espawn", 2), "D(1)", ColorOne);
    sscanf(GetNextWordFromString(text, "espawn", 3), "D(1)", ColorTwo);
    if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
    Event:SpawnVehicle(playerid, Vehicle, VehicleID, ColorOne, ColorTwo);
    return ~1;
}

hook OnPlayerImairedRequest(playerid) {
    if (Event:IsInEvent(playerid)) Event:Leave(playerid);
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    new worlds[] = { STUNT_WORLD_EVENT_ID, SKYFALL_EVENT_ID };
    if (!Event:IsInEvent(playerid) || !IsArrayContainNumber(worlds, Event:GetID(playerid))) return 1;
    if (Iter_Contains(ASpawnedVeh, vehicleid)) {
        SetPreciseTimer("DestroyVehicleEx", 5 * 1000, false, "d", vehicleid);
        Iter_Remove(ASpawnedVeh, vehicleid);
    }
    return 1;
}