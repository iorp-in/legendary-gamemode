#define RoleplayRange 10000.0
new bool:GlobalChatMode = true;
new bool:ManagementTag[MAX_PLAYERS] = { false, ... };
new bool:chatAnimation[MAX_PLAYERS] = { false, ... };

hook OnPlayerLogin(playerid) {
    ManagementTag[playerid] = false;
    chatAnimation[playerid] = true;
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "chat animation")) {
        if (chatAnimation[playerid]) {
            chatAnimation[playerid] = false;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}chat animation disabled");
        } else {
            chatAnimation[playerid] = true;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}chat animation enabled");
        }
        return ~1;
    }

    if (IsStringContainWords(text, "enable global chat, disable global chat") && GetPlayerAdminLevel(playerid) > 3) {
        if (GlobalChatMode) {
            GlobalChatMode = false;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}disabled global chat");
        } else {
            GlobalChatMode = true;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}enabled global chat");
        }
        return ~1;
    }

    if (IsStringContainWords(text, "enable management tag, disable management tag") && GetPlayerAdminLevel(playerid) > 0) {
        if (ManagementTag[playerid]) {
            ManagementTag[playerid] = false;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}disabled management tag");
        } else {
            ManagementTag[playerid] = true;
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}enabled management tag");
        }
        return ~1;
    }
    return 1;
}

CMD:me(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new tmp[256];
    if (sscanf(params, "s[128]", tmp)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/me [message]");
    }

    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MEDIUMPURPLE, sprintf("*%s %s", GetPlayerNameEx(playerid), FormatMention(tmp)));
    Roleplay:Log(playerid, sprintf("*%s %s", GetPlayerNameEx(playerid), FormatMention(tmp)), "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:my(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new tmp[256];
    if (sscanf(params, "s[128]", tmp)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/my [message]");
    }

    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MEDIUMPURPLE, sprintf("*%s's %s", GetPlayerNameEx(playerid), FormatMention(tmp)));
    Roleplay:Log(playerid, sprintf("*%s's %s", GetPlayerNameEx(playerid), FormatMention(tmp)), "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:do(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new tmp[256];
    if (sscanf(params, "s[128]", tmp)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/do [message]");
    }

    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MOCCASIN, sprintf("*%s (%s)", FormatMention(tmp), GetPlayerNameEx(playerid)));
    Roleplay:Log(playerid, sprintf("*%s (%s)", FormatMention(tmp), GetPlayerNameEx(playerid)), "do");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:fr(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new tmp[256], fplayername[25];
    if (sscanf(params, "s[25]s[128]", fplayername, tmp)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/fr [Fake Name] [message]");
    }

    SendRPMessageToAll(playerid, RoleplayRange, COLOR_ORANGE, sprintf("*%s %s", fplayername, FormatMention(tmp)));
    Roleplay:Log(playerid, sprintf("*%s %s", fplayername, FormatMention(tmp)), "fr");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:em(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new tmp[256], playername[25], Message[256];
    if (sscanf(params, "s[128]", tmp)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/em [message]");
    }

    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    format(Message, sizeof(Message), "*%s %s", playername, FormatMention(tmp));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MEDIUMPURPLE, Message);
    Roleplay:Log(playerid, Message, "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:say(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new msg[512], string[512];
    if (sscanf(params, "s[512]", msg)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/say [message]");
    }

    if (Faction:GetPlayerFID(playerid) != -1 && Faction:IsPlayerSigned(playerid)) format(string, sizeof string, "*{%s}%s said: %s", IntToHex(Faction:GetColor(Faction:GetPlayerFID(playerid))), GetPlayerNameEx(playerid), FormatMention(msg));
    else format(string, sizeof string, "*%s said: %s", GetPlayerNameEx(playerid), FormatMention(msg));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MOCCASIN, string);
    if (!IsPlayerInAnyVehicle(playerid)) {
        if (!Anim:IsPlayerUsing(playerid) && chatAnimation[playerid]) {
            ApplyAnimation(playerid, "ped", "IDLE_chat", 4.1, 1, 0, 0, 0, ((strlen(FormatMention(msg)) * 100) + 1000), 1);
            Anim:SetState(playerid, true);
        }
        SetPlayerChatBubble(playerid, FormatMention(msg), -1, 5, ((strlen(FormatMention(msg)) * 100) + 2000));
    }
    format(string, sizeof string, "*%s said: %s", GetPlayerNameEx(playerid), FormatMention(msg));
    Roleplay:Log(playerid, string, "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:shout(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new msg[512];
    if (sscanf(params, "s[512]", msg)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/shout [message]");
    }

    new string[512];
    format(string, sizeof string, "*%s shout: %s", GetPlayerNameEx(playerid), FormatMention(msg));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MOCCASIN, string);
    Roleplay:Log(playerid, string, "me");
    return 1;
}

CMD:call(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new msg[512];
    if (sscanf(params, "s[512]", msg)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/call [message]");
    }

    new string[512];
    format(string, sizeof string, "*%s on call: %s", GetPlayerNameEx(playerid), FormatMention(msg));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_MOCCASIN, string);
    Roleplay:Log(playerid, string, "me");
    return 1;
}

CMD:w(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new pId, msg[512];
    if (sscanf(params, "us[512]", pId, msg)) {
        return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/w [PlayerID] [message]");
    }

    if (!IsPlayerConnected(pId)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFEE}Invalid PlayerID");
    }

    new string[512];
    format(string, sizeof string, "*%s Whisper to %s: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(pId), FormatMention(msg));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_ORANGE, string);
    Roleplay:Log(playerid, string, "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:t(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in roleplay scene, please use /rpjoin first");
    }

    if (GetPlayerMutedStatus(playerid)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    }

    new msg[512];
    if (sscanf(params, "s[512]", msg)) {
        return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/t [message]");
    }

    new string[512];
    format(string, sizeof string, "*%s thought: %s", GetPlayerNameEx(playerid), FormatMention(msg));
    SendRPMessageToAll(playerid, RoleplayRange, COLOR_ORANGE, string);
    Roleplay:Log(playerid, string, "me");
    IncreaseRpCount(playerid);
    return 1;
}

CMD:s(playerid, const params[]) {
    new msg[512];
    if (sscanf(params, "s[128]", msg)) {
        return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/s [message]");
    }

    new string[512], Float:x, Float:y, Float:z, bool:sucs, pintID = GetPlayerInterior(playerid), pvwID = GetPlayerVirtualWorld(playerid);
    GetPlayerPos(playerid, x, y, z);
    format(string, sizeof string, "{bc9060}%s said: {ffffff}%s", GetPlayerNameEx(playerid), FormatMention(msg));
    foreach(new i:Player) {
        if (IsPlayerInRangeOfPoint(i, 10, x, y, z) && i != playerid && pintID == GetPlayerInterior(i) && pvwID == GetPlayerVirtualWorld(i)) {
            SendClientMessageEx(i, Player_Color, string);
            sucs = true;
            // if (DJ:GetStatusTTS(i)) {
            //     new audio[252];
            //     format(audio, sizeof audio, "https://tts.iorp.in/%s", FormatMention(msg));
            //     PlayAudioStreamForPlayer(i, audio);
            // }
        }
    }

    if (sucs) {
        if (!IsPlayerInAnyVehicle(playerid)) {
            if (!Anim:IsPlayerUsing(playerid) && chatAnimation[playerid]) {
                ApplyAnimation(playerid, "ped", "IDLE_chat", 4.1, 1, 0, 0, 0, ((strlen(FormatMention(msg)) * 100) + 1000), 1);
                Anim:SetState(playerid, true);
            }
            SetPlayerChatBubble(playerid, FormatMention(msg), -1, 5, ((strlen(FormatMention(msg)) * 100) + 2000));
        }
        return SendClientMessageEx(playerid, Player_Color, string);
    }

    if (!sucs) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}No Player around you to listen your close message.");
    }

    return 1;
}

CMD:gc(playerid, const params[]) {
    if (GlobalChatMode && GetPlayerAdminLevel(playerid) < 1 && TotalPlayersInServer() > 30) {
        return AlexaMsg(playerid, "global chat is disabled for you, please use phone to contact your friends");
    }

    if (!GlobalChatMode) {
        return SendClientMessageEx(playerid, -1, "{db6600}[Alexa]: {FFFFEE}global chatmode is currently disabled, use /s to talk");
    }

    new text[128];
    if (sscanf(params, "s[128]", text)) {
        return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/gc [message]");
    }

    new string[256];
    format(string, sizeof string, "%s[%d]: {ffffff}%s", GetPlayerNameEx(playerid), playerid, FormatColors(FormatMention(text)));
    if (GetPlayerAdminLevel(playerid) > 0 && ManagementTag[playerid]) format(string, sizeof string, "{FF0000}[Management] {FFCC66}%s", string);

    if (isStringHasIP(string)) {
        SendClientMessageEx(playerid, -1, "{db6600}[Alexa]: {FFFFEE}Your message has been blocked due {FF0000}advertise suspect{FFFFFF}, staff has been alerted.");
        Discord:SendHelper(sprintf(":page_with_curl:**Report for %s: alexa detected advertisement **", GetPlayerNameEx(playerid)));
        Discord:SendHelper(sprintf("message: **%s", string));
        return 1;
    }

    if (GetPlayerScore(playerid) < 50) {
        if (!IsTimePassedForPlayer(playerid, "rateLimitGC", 10)) {
            SendClientMessageEx(playerid, -1, "{db6600}[Alexa]: {FFFFEE}You can send only one message per 10 seconds.");
            return 1;
        }
    }

    if (!GetPlayerMutedStatus(playerid)) {
        foreach(new i:Player) {
            if (IsPlayerLoggedIn(i)) {
                SendClientMessageEx(i, Player_Color, string);
            }
        }
    } else {
        SendClientMessageEx(playerid, -1, "{db6600}[Alexa]: {FFFFEE}You are currently muted by an administrator, please wait until you are unmuted.");
    }
    return 1;
}

CMD:asay(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1) {
        return 0;
    }

    new msg[128];
    sscanf(params, "s[128]", msg);
    if (strreplace(msg, "asay ", "", false, 0, 1) == 0) strreplace(msg, "asay", "", false, 0, 1);
    if (isnull(msg)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}what to send?");
    }

    SendClientMessageToAll(-1, sprintf("{bc0000}[Admin]: {e0000e}%s (%s)", FormatMention(msg), GetPlayerNameEx(playerid)));
    // foreach(new i:Player) if (DJ:GetStatusTTS(i)) PlayAudioStreamForPlayer(i, sprintf("https://tts.iorp.in/%s", FormatMention(msg)));
    return 1;
}

CMD:achat(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1) {
        return 0;
    }

    new string[128];
    sscanf(params, "s[128]", string);
    if (strreplace(string, "achat ", "", false, 0, 1) == 0) strreplace(string, "achat", "", false, 0, 1);
    if (isnull(string)) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}what to say?");
    }

    foreach(new i:Player) if (GetPlayerAdminLevel(i) > 0) SendClientMessageEx(i, -1, sprintf("{4286f4}[Admin Chat] %s: {FFFFFF} %s", GetPlayerNameEx(playerid), FormatMention(string)));
    return 1;
}

cmd:radio(playerid, const params[]) {
    new string[128];
    if (sscanf(params, "s[128]", string)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/radio [message]");
    }

    new allow_faction[] = { 0, 1, 2, 3 };
    if (!IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) || !Faction:IsPlayerSigned(playerid)) {
        return 0;
    }


    foreach(new i:Player) {
        if (!IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(i))) continue;
        else if (!Faction:IsPlayerSigned(i)) continue;
        else SendClientMessage(i, -1, sprintf("{4286f4}[Radio] %s: {FFFFFF}%s", GetPlayerNameEx(playerid), FormatMention(string)));
    }
    return 1;
}

cmd:pu(playerid, const params[]) {
    new targetid = -1;
    sscanf(params, "d", targetid);
    Faction:FactionPullOver(playerid, targetid);
    return 1;
}

cmd:fchat(playerid, const params[]) {
    if (Faction:GetPlayerFID(playerid) < 0 || !Faction:IsPlayerSigned(playerid)) {
        return 0;
    }

    if (isnull(params)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}what to send?");
        return 1;
    }
    new fid = Faction:GetPlayerFID(playerid);
    foreach(new i:Player) if (Faction:GetPlayerFID(i) == fid) SendClientMessageEx(i, -1, sprintf("{4286f4}[Faction Chat] %s: {FFFFFF}%s", GetPlayerNameEx(playerid), FormatMention(params)));
    return 1;
}

cmd:eject(playerid, const params[]) {
    if (!IsPlayerInAnyVehicle(playerid)) {
        return 0;
    }

    new otherID;
    if (sscanf(params, "d", otherID)) {
        return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Usage]: {FFFFEE}/eject [player]");
    }

    if (playerid == otherID) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0404}[ERROR] {FFFF00}You cannot eject yourself.");
    }

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0404}[ERROR] {FFFF00}You must be the driver to eject players.");
    }

    new vehicleID = GetPlayerVehicleID(playerid);
    if (!IsPlayerConnected(otherID)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0404}[ERROR] {FFFF00}The player your trying to eject isn't connected.");
    }

    if (!IsPlayerInAnyVehicle(otherID)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0404}[ERROR] {FFFF00}The player is not in your vehicle.");
    }

    if (GetPlayerVehicleID(otherID) != vehicleID) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0404}[ERROR] {FFFF00}The player is not in your vehicle.");
    }

    RemovePlayerFromVehicle(otherID);
    SendClientMessage(playerid, COLOR_WHITE, "{B7B7B7}[EJECTED] {FFFF00}The player has been ejected from your vehicle.");
    SendClientMessage(otherID, COLOR_WHITE, "{B7B7B7}[EJECTED] {FFFF00}You have been ejected from the vehicle.");
    return 1;
}

cmd:admins(playerid, const params[]) {
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}online {FF0000}Management");
    new bool:isOnlineAdmin = false;
    foreach(new i:Player) {
        if (GetPlayerAdminLevel(i) > 0) {
            isOnlineAdmin = true;
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}%s [%d]", GetPlayerNameEx(i), i));
        }
    }
    if (!isOnlineAdmin) SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}currently no manager is online please goto iorp.in if you have any query");
    else SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}if you have any more query please goto iorp.in");
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 2) return 1;
    UCP:AddCommand(playerid, "Unbug me");
    UCP:AddCommand(playerid, "Clean Screen");
    UCP:AddCommand(playerid, "Fix Screen");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 2) return 1;
    if (!strcmp("Clean Screen", inputtext)) { clean_screen(playerid); return ~1; }
    if (!strcmp("Fix Screen", inputtext)) { fix_screen(playerid); return ~1; }
    if (!strcmp("Unbug me", inputtext)) { unbug(playerid); return ~1; }
    return 1;
}

stock clean_screen(playerid) {
    HideVSAS(playerid);
    HideHPTL(playerid);
    return 1;
}

stock fix_screen(playerid) {
    HideVSAS(playerid);
    HideHPTL(playerid);
    ShowHPTL(playerid);
    return 1;
}

cmd:unbug(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;

    new account[50];
    if (sscanf(params, "s[50]", account)) return SendClientMessage(playerid, -1, "[USAGE]: /unbug [Player Name]");
    if (!IsValidAccount(account)) return SendClientMessage(playerid, -1, "[ERROR]: Invalid player account.");

    new targetid = GetPlayerIDByName(account);
    if (IsPlayerConnected(targetid)) {
        unbug(targetid, true);
        AlexaMsg(targetid, "Management has forcely unbugged you, if this does not work then relog");
        SendClientMessage(playerid, -1, sprintf("%s has been online unbugged", account));
    } else {
        mysql_tquery(Database, sprintf("UPDATE players SET LastPosX = -160.00, LastPosY = 396.00, LastPosZ = 13.00 WHERE username = \"%s\"", account));
        SendClientMessage(playerid, -1, sprintf("%s has been offline unbugged", account));
    }

    return 1;
}

stock unbug(playerid, bool:force = false) {
    if (!force) {
        if (!IsTimePassedForPlayer(playerid, "RpModeCMDCD", 30)) {
            return GameTextForPlayer(playerid, "~r~NOT ~w~ALLOWED", 1000, 3);
        }
    }
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}You are sent to nearest hospital on your impaired request");
    GameTextForPlayer(playerid, "~r~unbuged", 1000, 3);
    SetPlayerInteriorEx(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, 0);
    new id = GetClosestHospital(playerid);
    SetPlayerFacingAngle(playerid, HospitalData[id][faceA]);
    SetPlayerPosEx(playerid, HospitalData[id][coordX], HospitalData[id][coordY], HospitalData[id][coordZ]);
    SetCameraBehindPlayer(playerid);
    CallRemoteFunction("OnPlayerImairedRequest", "d", playerid);
    return 1;
}

forward OnPlayerImairedRequest(playerid);
public OnPlayerImairedRequest(playerid) {
    return 1;
}

cmd:report(playerid, const params[]) {
    new pName[50], rReason[100];
    if (sscanf(params, "s[50]s[100]", pName, rReason)) {
        return SyntaxMSG(playerid, "/report username reason");
    }

    if (!IsValidAccount(pName)) {
        return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} invalid username, report can't be forwarded to administators");
    }

    SendAdminLogMessage(sprintf("Report for %s by %s", pName, GetPlayerNameEx(playerid)), false);
    SendAdminLogMessage(sprintf("Report: %s", rReason), false);
    Discord:SendHelper(sprintf(":page_with_curl:**Report for %s by %s**", pName, GetPlayerNameEx(playerid)));
    Discord:SendHelper(sprintf("**Report:** %s", rReason));
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} report forwarded to higher authorities, they will react to your report soon");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} this command only send alerts does not file reports on forum, you have to file forum report yourself.");
    return 1;
}

cmd:forum(playerid, const params[]) {
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} from applying faction, reading newbie guides to doing many more things, create account on forum and connect with us.");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} forum link: https://forum.iorp.in");
    return 1;
}

cmd:discord(playerid, const params[]) {
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}let's connect to more players who are not active right now and build a storage gang/team to do some fucking hard rp");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} discord link: https://discord.gg/Xq9k3hr");
    return 1;
}