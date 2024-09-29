new Player_PM_Config_LastPM[MAX_PLAYERS][2];
new bool:Player_PM_AllowFrom[MAX_PLAYERS][MAX_PLAYERS];

stock PM:GetStatus(playerid, receiverid) {
    return Player_PM_AllowFrom[playerid][receiverid];
}

stock PM:SetStatus(playerid, receiverid, bool:status) {
    Player_PM_AllowFrom[playerid][receiverid] = status;
    return 1;
}

stock PM:GetLastPMPlayerID(playerid) {
    return Player_PM_Config_LastPM[playerid][0];
}

stock PM:SetLastPMPlayerID(playerid, receiverid) {
    Player_PM_Config_LastPM[playerid][0] = receiverid;
    return 1;
}

stock PM:EnableAll(playerid) {
    for (new i; i < MAX_PLAYERS; i++) {
        Player_PM_AllowFrom[playerid][i] = true;
    }
    return 1;
}

stock PM:DisableAll(playerid) {
    for (new i; i < MAX_PLAYERS; i++) {
        Player_PM_AllowFrom[playerid][i] = false;
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    PM:SetLastPMPlayerID(playerid, playerid);
    PM:EnableAll(playerid);
    Player_PM_Config_LastPM[playerid][1] = 1;
    return 1;
}

stock PM:Send(playerid, receiverid, const message[]) {
    if (!IsPlayerConnected(receiverid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Invalid Player nick/id.");
    if (receiverid == playerid) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You can not PM yourself.");
    if (GetPlayerMutedStatus(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use /pm while you are muted. request on forum.iorp.in for unmute.");
    if (!PM:GetStatus(receiverid, playerid)) return SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}%s [%d] is not accepting private messages at the moment.", GetPlayerNameEx(receiverid), receiverid));
    if (!PM:GetStatus(playerid, receiverid)) return SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}you are not accepting private messages from %s [%d].", GetPlayerNameEx(receiverid), receiverid));
    SendClientMessageEx(playerid, COLOR_YELLOW, sprintf("((PM to (%s): %s))", GetPlayerNameEx(receiverid), FormatMention(message)));
    SendClientMessageEx(receiverid, COLOR_YELLOW, sprintf("((PM from (%s): %s))", GetPlayerNameEx(playerid), FormatMention(message)));
    PM:SetLastPMPlayerID(receiverid, playerid);
    return 1;
}

CMD:nopm(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1 && Player_PM_Config_LastPM[playerid][1] == 0) return 0;
    new receiverid;
    if (sscanf(params, "d", receiverid)) {
        SyntaxMSG(playerid, "/nopm [playerid], use playerid = playerid to disable/enable pm");
        SyntaxMSG(playerid, "use playerid = -1 to disable all pm, playerid = -2 to enable all pm");
        return 1;
    }
    if (receiverid < -2 || receiverid >= MAX_PLAYERS) {
        SyntaxMSG(playerid, "/nopm [playerid], use playerid = playerid to disable/enable pm");
        SyntaxMSG(playerid, "use playerid = -1 to disable all pm, playerid = -2 to enable all pm");
        return 1;
    }
    if (receiverid == -1) {
        PM:DisableAll(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You are no longer accepting all private messages.");
        return 1;
    }
    if (receiverid == -2) {
        PM:EnableAll(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You are now accepting all private messages.");
        return 1;
    }
    if (PM:GetStatus(playerid, receiverid)) {
        PM:SetStatus(playerid, receiverid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}You are no longer accepting private messages from playerid %d.", receiverid));
    } else {
        PM:SetStatus(playerid, receiverid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}You are now accepting private messages from playerid %d.", receiverid));
    }
    return 1;
}

CMD:rpm(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1 && Player_PM_Config_LastPM[playerid][1] == 0) return 0;
    new message[100];
    if (sscanf(params, "s[100]", message)) return SyntaxMSG(playerid, "/rpm [message]");
    new receiverid = PM:GetLastPMPlayerID(playerid);
    return PM:Send(playerid, receiverid, message);
}

CMD:pm(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1 && Player_PM_Config_LastPM[playerid][1] == 0) return 0;
    new receiverid, message[100];
    if (sscanf(params, "ds[100]", receiverid, message)) return SyntaxMSG(playerid, "/pm [playerid] [message]");
    return PM:Send(playerid, receiverid, message);
}

hook ApcpOnInit(playerid, targetid, page) {
    if (page != 1 || GetPlayerAdminLevel(targetid) > 0) return 1;

    if (Player_PM_Config_LastPM[targetid][1]) {
        APCP:AddCommand(playerid, "Disable PM");
    } else {
        APCP:AddCommand(playerid, "Enable PM");
    }

    return 1;
}

hook ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || GetPlayerAdminLevel(targetid) > 0) return 1;

    if (IsStringSame("Enable PM", inputtext)) {
        Player_PM_Config_LastPM[targetid][1] = 1;
        AlexaMsg(playerid, sprintf("Enabled pm for %s", GetPlayerNameEx(targetid)));
        AlexaMsg(targetid, sprintf("Enabled pm by %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid, 1);
        return ~1;
    }

    if (IsStringSame("Disable PM", inputtext)) {
        Player_PM_Config_LastPM[targetid][1] = 0;
        AlexaMsg(playerid, sprintf("Disabled pm for %s", GetPlayerNameEx(targetid)));
        AlexaMsg(targetid, sprintf("Disabled pm by %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid, 1);
        return ~1;
    }
    return 1;
}