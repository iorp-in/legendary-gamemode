new bool:Player_Helper_Mode[MAX_PLAYERS];
new LastHelpAskedAt[MAX_PLAYERS];
new bool:Player_Helper_Mode_Status[MAX_PLAYERS];
stock IsPlayerHelper(playerid) {
    return Player_Helper_Mode[playerid];
}
stock GetPlayerHelperStatus(playerid) {
    return Player_Helper_Mode_Status[playerid];
}
stock SetPlayerHelperStatus(playerid, bool:status) {
    Player_Helper_Mode_Status[playerid] = status;
    return status;
}
stock SetPlayerHelper(playerid, bool:status) {
    Player_Helper_Mode[playerid] = status;
    Database:UpdateBool(status, GetPlayerNameEx(playerid), "username", "helper_role");
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "helper_role", "boolean", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    LastHelpAskedAt[playerid] = 0;
    Player_Helper_Mode_Status[playerid] = false;
    return 1;
}

hook OnPlayerLogin(playerid) {
    Player_Helper_Mode[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", "helper_role");
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (Player_Helper_Mode[playerid] && IsStringContainWords(text, "enable helper mode, disable helper mode, enable helper tag, disable helper tag")) {
        if (GetPlayerHelperStatus(playerid)) {
            SetPlayerHelperStatus(playerid, false);
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}disabled helper tag");
            return ~1;
        } else {
            SetPlayerHelperStatus(playerid, true);
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}enabled helper tag");
            return ~1;
        }
    }
    return 1;
}

stock IsPlayerAskedForHelp(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (gettime() - LastHelpAskedAt[playerid] < 60) return 1;
    return 0;
}

stock SendHelperMessage(const msg[]) {
    if (strlen(msg) < 1) return 1;
    foreach(new playerid:Player) {
        if (IsPlayerHelper(playerid)) {
            if (IsTimePassedForPlayer(playerid, "helperguidemsg", 5 * 60)) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFF00} use /helper [playerid] [message] to send your helper message, /helpergoto [playerid] to teleport yourself");
            SendClientMessage(playerid, -1, msg);
        }
    }
    return 1;
}

cmd:helpme(playerid, const params[]) {
    new message[100];
    if (sscanf(params, "s[100]", message)) return SyntaxMSG(playerid, "/helpme message");
    LastHelpAskedAt[playerid] = gettime();
    SendHelperMessage(sprintf("%s[%d] asked help: %s", GetPlayerNameEx(playerid), playerid, message));
    Discord:SendHelper(sprintf(":notepad_spiral:**%s [%d] asked help:** %s", GetPlayerNameEx(playerid), playerid, message));
    // Discord:SendGeneral(sprintf(":notepad_spiral:**%s asked help:** %s", GetPlayerNameEx(playerid), message));
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} request has been sent to higher authorities, they will react to your request soon");
    return 1;
}

CMD:hchat(playerid, const params[]) {
    if (!GetPlayerHelperStatus(playerid) && GetPlayerAdminLevel(playerid) < 1) return 0;
    new string[128];
    sscanf(params, "s[128]", string);
    if (strreplace(string, "hchat ", "", false, 0, 1) == 0) strreplace(string, "hchat", "", false, 0, 1);
    if (!strlen(string)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}what to say?");
    foreach(new i:Player) if (GetPlayerHelperStatus(i) || GetPlayerAdminLevel(i) > 0) SendClientMessageEx(i, -1, sprintf("{4286f4}[Helper Chat] %s: {FFFFFF} %s", GetPlayerNameEx(playerid), FormatMention(string)));
    return 1;
}

cmd:helper(playerid, const params[]) {
    if (!GetPlayerHelperStatus(playerid)) return 0;
    new plid, msg[100];
    if (sscanf(params, "us[100]", plid, msg)) return SyntaxMSG(playerid, "/helper [playerid] [message]");
    if (!IsPlayerConnected(plid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} invalid playerid");
    if (!IsPlayerAskedForHelp(plid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} player did not asked for help");
    Discord:SendHelper(sprintf(":envelope:**%s replied %s:** %s", GetPlayerNameEx(playerid), GetPlayerNameEx(plid), msg));
    SendHelperMessage(sprintf("{FF9A6F}[Helper] %s[%d] replied: {ffffff}%s", GetPlayerNameEx(playerid), playerid, msg));
    SendClientMessage(plid, -1, sprintf("{FF9A6F}[Helper] %s[%d] replied: {ffffff}%s", GetPlayerNameEx(playerid), playerid, msg));
    return 1;
}

cmd:helpergoto(playerid, const params[]) {
    if (!GetPlayerHelperStatus(playerid)) return 0;
    new extraid;
    if (sscanf(params, "u", extraid)) return SyntaxMSG(playerid, "/helpergoto [playerid]");
    if (!IsPlayerConnected(extraid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} invalid playerid");
    if (!IsPlayerAskedForHelp(extraid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} player did not asked for help");
    new Float:x, Float:y, Float:z, Float:a, int, worldid;
    int = GetPlayerInterior(extraid);
    worldid = GetPlayerVirtualWorld(extraid);
    GetPlayerPos(extraid, x, y, z);
    GetXYInFrontOfPlayer(extraid, x, y, 10);
    GetPlayerFacingAngle(extraid, a);
    SetPlayerVirtualWorldEx(playerid, worldid);
    SetPlayerInteriorEx(playerid, int);
    if (IsPlayerInAnyVehicle(playerid)) TeleportVehicleEx(GetPlayerVehicleID(playerid), x, y, z, a + 90, worldid, int);
    else SetPlayerPosEx(playerid, x, y, z);
    Discord:SendHelper(sprintf(":envelope:**%s teleported to %s for helper request**", GetPlayerNameEx(playerid), GetPlayerNameEx(extraid)));
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have teleported yourself to location of %s", GetPlayerNameEx(extraid)));
    SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} Helper %s teleported himself to your location", GetPlayerNameEx(playerid)));
    return 1;
}

DC_CMD:hsay(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel, user_name[DCC_USERNAME_SIZE], DCC_User:author;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    DCC_GetMessageAuthor(DCC_Message:message, DCC_User:author);
    DCC_GetUserName(DCC_User:author, user_name);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new playerid, msg[512];
    if (sscanf(params, "us[128]", playerid, msg)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: :hsay [playerid] [Message]");
    if (!IsPlayerConnected(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: invalid playerid");
    // if (!IsPlayerAskedForHelp(playerid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: player did not asked for help");
    SendClientMessage(playerid, -1, sprintf("{FF9A6F}[Helper] %s replied: {ffffff}%s", user_name, FormatMention(msg)));
    Discord:SendHelper(sprintf(":envelope:**%s replied %s:** %s", user_name, GetPlayerNameEx(playerid), FormatMention(msg)));
    // DCC_SendChannelMessage(DCC_Channel:channel, sprintf("Helper Message Sent to %s: %s", GetPlayerNameEx(playerid), FormatMention(msg)));
    return 1;
}