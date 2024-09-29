new bool:NameTagAuth:SystemStatus;
new bool:NameTagAuth:PlayerData[MAX_PLAYERS];

hook OnGameModeInit() {
    NameTagAuth:SystemStatus = false;
    return 1;
}

stock NameTagAuth:GetSystemStatus() {
    return NameTagAuth:SystemStatus;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (NameTagAuth:SystemStatus) NameTagAuth:SetPlayer(playerid, true);
    else NameTagAuth:SetPlayer(playerid, false);
    return 1;
}

stock NameTagAuth:GetPlayer(playerid) {
    return NameTagAuth:PlayerData[playerid];
}

stock NameTagAuth:SetPlayer(playerid, bool:status) {
    NameTagAuth:PlayerData[playerid] = status;
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new playerid: Player) {
        foreach(new forplayerid: Player) {
            if (NameTagAuth:GetPlayer(playerid)) ShowPlayerNameTagForPlayer(forplayerid, playerid, false);
            else ShowPlayerNameTagForPlayer(forplayerid, playerid, true);

            if (NameTagAuth:GetPlayer(forplayerid)) ShowPlayerNameTagForPlayer(playerid, forplayerid, false);
            else ShowPlayerNameTagForPlayer(playerid, forplayerid, true);
        }
    }
    return 1;
}

stock NameTagAuth:Command(adminid, playerid) {
    if (!IsPlayerConnected(playerid)) return SendClientMessageEx(adminid, -1, "{4286f4}[Error]:{FFFFEE}Invalid playerid");
    if (NameTagAuth:GetPlayer(playerid)) {
        NameTagAuth:SetPlayer(playerid, false);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have deactivated %s name tag mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your name tag mode deactivated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    } else {
        NameTagAuth:SetPlayer(playerid, true);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have activated %s name tag mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your name tag mode activated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "name tag mode") || GetPlayerAdminLevel(playerid) < 8) return 1;
    if (NameTagAuth:SystemStatus) {
        NameTagAuth:SystemStatus = false;
        SendClientMessage(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} Invisible mode disabled");
        foreach(new i:Player) {
            NameTagAuth:SetPlayer(i, false);
        }
    } else {
        NameTagAuth:SystemStatus = true;
        SendClientMessage(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} Invisible mode enabled");
        foreach(new i:Player) {
            NameTagAuth:SetPlayer(i, true);
        }
    }
    return ~1;
}

hook OnPlayerEnableRPMODE(playerid) {
    if (!NameTagAuth:GetSystemStatus()) NameTagAuth:SetPlayer(playerid, true);
    return 1;
}

hook OnPlayerDisableRPMODE(playerid) {
    if (!NameTagAuth:GetSystemStatus()) NameTagAuth:SetPlayer(playerid, false);
    return 1;
}

APCP:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (GetPlayerAdminLevel(playerid) >= 9 && !NameTagAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Make Player Invisible");
    if (GetPlayerAdminLevel(playerid) >= 9 && NameTagAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Make Player Visible");
    return 1;
}

APCP:OnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Make Player Invisible", inputtext)) {
        NameTagAuth:Command(playerid, targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s name tag mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled name tag mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Make Player Visible", inputtext)) {
        NameTagAuth:Command(playerid, targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s name tag mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled name tag mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return 1;
}