new bool:InvisibleAuth:SystemStatus;
new bool:InvisibleAuth:PlayerData[MAX_PLAYERS];

hook OnGameModeInit() {
    InvisibleAuth:SystemStatus = false;
    return 1;
}

stock InvisibleAuth:GetSystemStatus() {
    return InvisibleAuth:SystemStatus;
}

hook GlobalOneMinuteInterval() {
    InvisibleUpdate();
    return 1;
}

forward InvisibleUpdate();
public InvisibleUpdate() {
    foreach(new i:Player) {
        foreach(new j:Player) {
            if (InvisibleAuth:GetPlayer(i)) SetPlayerMarkerForPlayer(j, i, (GetPlayerColor(i) & 0xFFFFFF00));
            else SetPlayerMarkerForPlayer(j, i, GetPlayerColor(i));
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (InvisibleAuth:SystemStatus) InvisibleAuth:SetPlayer(playerid, true);
    else InvisibleAuth:SetPlayer(playerid, true);
    return 1;
}

stock InvisibleAuth:GetPlayer(playerid) {
    return InvisibleAuth:PlayerData[playerid];
}

stock InvisibleAuth:SetPlayer(playerid, bool:status) {
    InvisibleAuth:PlayerData[playerid] = status;
    return 1;
}

stock InvisibleAuth:Command(adminid, playerid) {
    if (!IsPlayerConnected(playerid)) return SendClientMessageEx(adminid, -1, "{4286f4}[Error]:{FFFFEE}Invalid playerid");
    if (InvisibleAuth:GetPlayer(playerid)) {
        InvisibleAuth:SetPlayer(playerid, false);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have deactivated %s invisible mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your invisible mode deactivated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    } else {
        InvisibleAuth:SetPlayer(playerid, true);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have activated %s invisible mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your invisible mode activated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "invisible mode") || GetPlayerAdminLevel(playerid) < 8) return 1;
    if (InvisibleAuth:SystemStatus) {
        InvisibleAuth:SystemStatus = false;
        SendClientMessage(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} Invisible mode disabled");
        foreach(new i:Player) {
            InvisibleAuth:SetPlayer(i, false);
        }
    } else {
        InvisibleAuth:SystemStatus = true;
        SendClientMessage(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} Invisible mode enabled");
        foreach(new i:Player) {
            InvisibleAuth:SetPlayer(i, true);
        }
    }
    return ~1;
}

hook OnPlayerEnableRPMODE(playerid) {
    if (!InvisibleAuth:GetSystemStatus()) InvisibleAuth:SetPlayer(playerid, true);
    return 1;
}

hook OnPlayerDisableRPMODE(playerid) {
    if (!InvisibleAuth:GetSystemStatus()) InvisibleAuth:SetPlayer(playerid, false);
    return 1;
}

APCP:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (GetPlayerAdminLevel(playerid) >= 9 && !InvisibleAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Make Player Invisible");
    if (GetPlayerAdminLevel(playerid) >= 9 && InvisibleAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Make Player Visible");
    return 1;
}

APCP:OnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Make Player Invisible", inputtext)) {
        InvisibleAuth:Command(playerid, targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s invisible mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled invisible mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Make Player Visible", inputtext)) {
        InvisibleAuth:Command(playerid, targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s invisible mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled invisible mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return 1;
}