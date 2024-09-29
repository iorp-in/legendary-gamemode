enum acpenumdata {
    bool:requestedNameChange,
    requestedName[20]
};

new PlayerAcpData[MAX_PLAYERS][acpenumdata];

stock IsPlayerRequestNameChange(playerid) {
    return PlayerAcpData[playerid][requestedNameChange];
}

stock SetPlayerRequestNameChange(playerid, bool:status) {
    PlayerAcpData[playerid][requestedNameChange] = status;
    return PlayerAcpData[playerid][requestedNameChange];
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPlayerRequestNameChange(playerid, false);
    return 1;
}

cmd:changename(playerid, const params[]) {
    new nName[20];
    if (sscanf(params, "s[20]", nName)) return SyntaxMSG(playerid, "/changename [new name]");
    if (strlen(nName) < 6 || strlen(nName) > 19) return SyntaxMSG(playerid, "invalid name, try Firstname_Lastname format.");
    if (!RoleplayNameCheck(nName)) return SyntaxMSG(playerid, "invalid name, try Firstname_Lastname format.");
    if (IsValidAccount(nName)) return SyntaxMSG(playerid, "name is already in use, try another name.");
    if (IsPlayerRequestNameChange(playerid)) return SyntaxMSG(playerid, "you have already applied for name change.");
    SetPlayerRequestNameChange(playerid, true);
    format(PlayerAcpData[playerid][requestedName], 20, "%s", nName);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} remember, management only accept this request when you have applied on forum with same details.");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} your request has been sent to management, please wait until you hear from them.");
    Discord:SendStaff(sprintf("%s [%d] has requested name change to: %s\nto approve type this request type :approvename %s or :rejectname %s\n\n<@&597292999227211777>", GetPlayerNameEx(playerid), playerid, nName, GetPlayerNameEx(playerid), GetPlayerNameEx(playerid)));
    foreach(new i:Player) {
        if (GetPlayerAdminLevel(i) >= 5) {
            SendClientMessage(i, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} %s requested new name: %s", GetPlayerNameEx(playerid), nName));
        }
    }
    return 1;
}

DC_CMD:approvename(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new playerid;
    if (sscanf(params, "u", playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !approvename [PlayerName/PlayerID]");
    if (!IsPlayerConnected(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player is not connected to server");
    if (!IsPlayerRequestNameChange(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player did not requested name change");
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s name has been changed to %s", GetPlayerNameEx(playerid), PlayerAcpData[playerid][requestedName]));
    return 1;
}

DC_CMD:rejectname(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new playerid;
    if (sscanf(params, "u", playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !approvename [PlayerName/PlayerID]");
    if (!IsPlayerConnected(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player is not connected to server");
    if (!IsPlayerRequestNameChange(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: player did not requested name change");
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s name has been rejected", GetPlayerNameEx(playerid)));
    RejectNameChange(playerid);
    return 1;
}

stock RejectNameChange(playerid) {
    SetPlayerRequestNameChange(playerid, false);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} your name change request has been declined by admin.");
    return 1;
}

stock ApproveNameChange(playerid) {
    new nName[2][50];
    GetPlayerName(playerid, nName[0], 50);
    format(nName[1], 50, "%s", PlayerAcpData[playerid][requestedName]);
    SetPlayerRequestNameChange(playerid, false);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} your name change request has been accepted by admin %s", GetPlayerNameEx(playerid)));
    Discord:SendHelper(sprintf(":notepad_spiral: %s name updated with with %s", nName[0], nName[1]));
    SendAdminLogMessage(sprintf("{4286f4}[Alexa]:{FFFFEE} %s name updated with %s", GetPlayerNameEx(playerid), nName[0], nName[1]), false);
    Kick(playerid);
    AccountRename(nName[0], nName[1]);
    return 1;
}