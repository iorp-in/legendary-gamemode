//#snippet Discord:IDManagement DCC_Channel:Discord:IDManagement

new DCC_Channel:Discord:IDManagement;

#define CMD_PREFIX ":"
#define DC_CMD:%0(%1[],%2[]) forward dc_cmd_%0(%1[],%2[]); public dc_cmd_%0(%1[],%2[])

//#snippet init_dcmd DC_CMD:name(DCC_Message:message, const user[], const params[]) {\n\tnew DCC_Channel:channel;\n\tDCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);\n\tif (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;\n\tDCC_SendChannelMessage(DCC_Channel:channel, "Hello");\n\treturn 1;\n}

hook OnGameModeInit() {
    Discord:IDManagement = DCC_FindChannelById("588700430750711808");
    return 1;
}

stock Discord:SendManagement(const message[]) {
    DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendAnnoucement(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendNotification(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendFactionLobby(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendFactionLobbyLaw(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendFactionLobbyMafia(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendVerified(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendStaff(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendGeneral(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:SendHelper(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:LogVault(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:LogTransaction(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:LogAdmin(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:LogMultiAccount(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock Discord:LogJoinLeave(const message[]) {
    #pragma unused message
    // DCC_SendChannelMessage(Discord:IDManagement, message);
    return 1;
}

stock LogNormal(const message[]) {
    new year, month, day;
    getdate(year, month, day);
    log(message, sprintf("logs/iorp/%d-%d.txt", year, month));
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Discord:LogJoinLeave(sprintf("Join: %s (%d) (Total: %d)", GetPlayerNameEx(playerid), playerid, GetOnlinePlayerCount()));
    LogNormal(sprintf("[Join] [%s]: PlayerId: %d IP: %s", GetPlayerNameEx(playerid), playerid, GetPlayerIpEx(playerid)));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    Discord:LogJoinLeave(sprintf("Leave: %s (%d)", GetPlayerNameEx(playerid), playerid));
    LogNormal(sprintf("[Leave] [%s]: PlayerId: %d", GetPlayerNameEx(playerid), playerid));
    return 1;
}

hook OnPlayerLogin(playerid) {
    LogNormal(sprintf("[Login] [%s]: PlayerId: %d IP: %s", GetPlayerNameEx(playerid), playerid, GetPlayerIpEx(playerid)));
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (IsPlayerConnected(killerid)) {
        LogNormal(sprintf("[DEATH] [%s]: Killed By %s", GetPlayerNameEx(playerid), GetPlayerNameEx(killerid)));
    } else {
        LogNormal(sprintf("[DEATH] [%s]: Reason %d", GetPlayerNameEx(playerid), reason));
    }
    return 1;
}

public DCC_OnMessageCreate(DCC_Message:message) {
    new channel_name[100 + 1], user_name[DCC_USERNAME_SIZE], DCC_Channel:channel, DCC_User:author, msg[512], bool:is_bot;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    DCC_GetChannelName(DCC_Channel:channel, channel_name);
    DCC_GetMessageAuthor(DCC_Message:message, DCC_User:author);
    DCC_IsUserBot(DCC_User:author, is_bot);
    DCC_GetUserName(DCC_User:author, user_name);
    DCC_GetMessageContent(DCC_Message:message, msg);

    // Server Management Bot CMD
    if (channel == Discord:IDManagement && !is_bot) {
        if (strlen(msg) > 512) return DCC_SendChannelMessage(DCC_Channel:channel, "Error:Command exceed character limit 512");
        new isCmd[10];
        strmid(isCmd, msg, 0, 1);
        if (IsStringSame(isCmd, CMD_PREFIX, false, 1)) {
            new pos, funcname[160];
            while (msg[++pos] > ' ') {
                funcname[pos - 1] = tolower(msg[pos]);
            }
            if (strlen(funcname) >= 32) return DCC_SendChannelMessage(DCC_Channel:channel, "Error:Command exceed function name limit 32");
            if (strlen(msg[pos]) > 128) return DCC_SendChannelMessage(DCC_Channel:channel, "Error:Command exceed function parameter limit 128");

            format(funcname, sizeof(funcname), "dc_cmd_%s", funcname);
            while (msg[pos] == ' ') pos++;
            if (!msg[pos]) {
                CallRemoteFunction("OnDCCommandPerformed", "di", _:message, CallRemoteFunction(funcname, "dss", _:message, user_name, "\1"));
            } else CallRemoteFunction("OnDCCommandPerformed", "di", _:message, CallRemoteFunction(funcname, "dss", _:message, user_name, msg[pos]));
        }
    }
    return 1;
}

forward OnDCCommandPerformed(DCC_Message:message, success);
public OnDCCommandPerformed(DCC_Message:message, success) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    // if(!success) return DCC_SendChannelMessage(DCC_Channel:channel, "Command not found, check :cmds");
    return 1;
}

DC_CMD:cmds(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    DCC_SendChannelMessage(DCC_Channel:channel, "**[Alexa]:Available Discord Admin Commands**\n\
            ```[Alexa] :cmds | :asay | :players | :rcon | :stream```\n\
            ```[PMS] :changepassword | :setvip | :setfaction | :removefaction```\n\
            ```[PMS] :getadmins | :setadmin | :getmasteradmins | :setmasteradmin | :nonrpalert```\n\
            ```[PMS] :kick | :kickall | :disableaccount | :enableaccount | :ban | :unban | :updatename```\n\
            ```[Debt] :getalldebt :getplayerdebt :giveplayerdebt :resetplayerdebt :refund```\n\
            ```[Helper] :hsay :unbug```\n\
            ```[Bank] :setbankpassword :enablebankaccount :disablebankaccount```\n\
            ```[Bitcoin] :givebitcoin```\
        ");
    return 1;
}

DC_CMD:kick(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new playerid, reason[50];
    if (sscanf(params, "us[50]", playerid, reason)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !kick [PlayerName/PlayerID] [reason]");
    if (!IsPlayerConnected(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: play is not connected to server");
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s kicked from server", GetPlayerNameEx(playerid)));
    SendClientMessage(playerid, -1, sprintf("you are kicked by management for reason: %s", reason));
    KickPlayer(playerid);
    return 1;
}

DC_CMD:kickall(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    DCC_SendChannelMessage(DCC_Channel:channel, "all players from server are kicked");
    SendClientMessageToAll(-1, "{4286f4}[Alexa]:{FFFFEE} all players from server are kicked by management");
    foreach(new i:Player) {
        KickPlayer(i);
    }
    return 1;
}

DC_CMD:asay(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new msg[512];
    if (sscanf(params, "s[128]", msg)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: :asay [Message]");
    SendClientMessageToAll(COLOR_RED, sprintf("[Admin]: %s", FormatMention(msg)));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("Admin Message Sent: %s", FormatMention(msg)));
    return 1;
}

DC_CMD:players(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new count = 0, string[2000];
    strcat(string, "```");
    DCC_SendChannelMessage(DCC_Channel:channel, "IG Player List");
    foreach(new playerid:Player) {
        if (IsPlayerMasterAdmin(playerid) && DCC_Channel:channel != Discord:IDManagement) {
            strcat(string, sprintf(
                "Name: %s (%d) (%s)\nScore: %d - VIP: %d - IP: forbidden\n\n",
                GetPlayerNameEx(playerid), playerid, IsPlayerPaused(playerid) ? "Paused" : "Active",
                GetPlayerScore(playerid),
                GetPlayerVIPLevel(playerid)
            ));
        } else {
            strcat(string, sprintf(
                "Name: %s (%d) (%s)\nScore: %d - VIP: %d - IP: %s\n\n",
                GetPlayerNameEx(playerid), playerid, IsPlayerPaused(playerid) ? "Paused" : "Active",
                GetPlayerScore(playerid),
                GetPlayerVIPLevel(playerid),
                GetPlayerIpEx(playerid)
            ));
        }
        count++;
        if (count >= 20) {
            count = 0;
            strcat(string, "```");
            DCC_SendChannelMessage(DCC_Channel:channel, string);
            format(string, sizeof string, "```");
        }
    }
    strcat(string, "```");
    if (count == 0) DCC_SendChannelMessage(DCC_Channel:channel, "No Player Online");
    else DCC_SendChannelMessage(DCC_Channel:channel, string);
    return 1;
}

DC_CMD:rcon(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != Discord:IDManagement) return 0;
    new msg[512], cmd[10];
    if (sscanf(params, "s[50]", cmd)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: :rcon [Command] [Param]");
    format(msg, sizeof(msg), "%s", cmd);
    SendRconCommand(msg);
    DCC_SendChannelMessage(DCC_Channel:channel, "Rcon Executed Successfully");
    return 1;
}

forward kick(playerid);
public kick(playerid) {
    Kick(playerid);
}

forward kickall(playerid);
public kickall(playerid) {
    foreach(new i:Player) {
        if (i != playerid) Kick(i);
    }
}