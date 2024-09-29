#define MAX_WHATSAPP_MSGS 100

hook OnPlayerLogin(playerid) {
    new total = Whatsapp:totalMessage(GetPlayerNameEx(playerid));
    if (total != 0) SendClientMessageEx(playerid, -1, sprintf("{4286f4}[WhatsApp]: {FFFFFF}you have %d messages in your inbox.", total));
    return 1;
}

stock Whatsapp:totalMessage(const name[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from whatsapp where username =\"%s\"", name));
    new total = 0, rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock Whatsapp:init(playerid) {
    new string[512];
    strcat(string, "Action\t---\n");
    strcat(string, sprintf("Inbox\t%d\n", Whatsapp:totalMessage(GetPlayerNameEx(playerid))));
    strcat(string, "Compose\tMessage\n");
    return FlexPlayerDialog(playerid, "Whatsappinit", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[WhatsApp]: {FFFFFF}Menu", string, "Select", "Close");
}

FlexDialog:Whatsappinit(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Inbox")) return Whatsapp:ViewAll(playerid);
    if (IsStringSame(inputtext, "Compose")) return Whatsapp:Compose(playerid);
    return 1;
}

stock Whatsapp:Compose(playerid) {
    return FlexPlayerDialog(
        playerid, "WhatsappCompose", DIALOG_STYLE_INPUT, "{4286f4}[WhatsApp]: {FFFFFF}compose message",
        "Enter username of player, which you wish to send message.", "Send", "Back"
    );
}

FlexDialog:WhatsappCompose(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Whatsapp:init(playerid);
    new username[50];
    if (sscanf(inputtext, "s[50]", username) || !IsValidAccount(username) || IsStringSame(username, GetPlayerNameEx(playerid))) return Whatsapp:Compose(playerid);
    if (Whatsapp:totalMessage(username) >= MAX_WHATSAPP_MSGS) {
        AlexaMsg(playerid, "recipient inbox is full. try later", "WhatsApp");
        return Whatsapp:init(playerid);
    }
    return Whatsapp:ComposeMsg(playerid, username);
}

stock Whatsapp:ComposeMsg(playerid, const username[]) {
    return FlexPlayerDialog(
        playerid, "WhatsappComposeMsg", DIALOG_STYLE_INPUT, "{4286f4}[WhatsApp]: {FFFFFF}compose message",
        "Enter message, max message length: 120.", "Send", "Back", -1, username
    );
}

FlexDialog:WhatsappComposeMsg(playerid, response, listitem, const inputtext[], extraid, const username[]) {
    if (!response) return Whatsapp:Compose(playerid);
    new message[140];
    if (sscanf(inputtext, "s[140]", message)) return Whatsapp:ComposeMsg(playerid, username);
    mysql_tquery(Database, sprintf("insert into whatsapp (username, sender, message, status, createdAt) values (\"%s\", \"%s\", \"%s\", 0, %d)", username, GetPlayerNameEx(playerid), message, gettime()));
    AlexaMsg(playerid, sprintf("message has been sent to %s.", username), "Whatsapp");
    if (!IsPlayerInServerByName(username)) {
        Email:Send(
            ALERT_TYPE_WHATSAPP, username, sprintf("New whatsapp message from %s", GetPlayerNameEx(playerid)),
            sprintf("Player %s sent your new whatsapp message-n--n-Message: %s", GetPlayerNameEx(playerid), message)
        );
    }
    foreach(new i:Player) {
        if (IsStringSame(username, GetPlayerNameEx(i))) {
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}[WhatsApp]: {FFFFFF}you have new whatsapp message from %s.", GetPlayerNameEx(playerid)));
        }
    }
    return Whatsapp:init(playerid);
}

stock Whatsapp:ViewAll(playerid, page = 0) {
    new total = Whatsapp:totalMessage(GetPlayerNameEx(playerid));
    new perpage = 25;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new totalpages = floatround(total / perpage);

    new Cache:result = mysql_query(Database, sprintf("select * from whatsapp where username =\"%s\" limit %d, %d", GetPlayerNameEx(playerid), skip, perpage));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(result);
        SendClientMessageEx(playerid, -1, "{4286f4}[WhatsApp]: {FFFFFF}you don't have any messages in inbox.");
        return Whatsapp:init(playerid);
    }
    new string[2000], mID, mSender[50], mStatus, mDate;
    strcat(string, "ID\tUsername\tStatus\tDate\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "ID", mID);
        cache_get_value_name(i, "sender", mSender, 50);
        cache_get_value_name_int(i, "status", mStatus);
        cache_get_value_name_int(i, "createdAt", mDate);
        strcat(string, sprintf("%d\t%s\t%s\t%s\n", mID, mSender, mStatus == 0 ? "unread" : "-", UnixToHumanEx(mDate)));
    }
    cache_delete(result);
    if (remaining > 0) strcat(string, "Next\tPage\n");
    if (page > 0) strcat(string, "Back\tPage\n");
    return FlexPlayerDialog(
        playerid, "WhatsappViewAll", DIALOG_STYLE_TABLIST_HEADERS, sprintf("{4286f4}[WhatsApp]: {FFFFFF}Inbox (%d/%d)", page, totalpages), string, "View", "Close", page
    );
}

FlexDialog:WhatsappViewAll(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return Whatsapp:init(playerid);
    if (IsStringSame(inputtext, "Next")) return Whatsapp:ViewAll(playerid, page + 1);
    if (IsStringSame(inputtext, "Back")) return Whatsapp:ViewAll(playerid, page - 1);
    return Whatsapp:viewMessage(playerid, strval(inputtext));
}

stock Whatsapp:viewMessage(playerid, messageID) {
    new Cache:result = mysql_query(Database, sprintf("select * from whatsapp where ID = %d limit 1", messageID));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(result);
        SendClientMessageEx(playerid, -1, "{4286f4}[WhatsApp]: {FFFFFF}unable to read message :(");
        return Whatsapp:init(playerid);
    }
    new string[2000], mID, mSender[50], mMessage[512], mStatus, mDate, mTime[100];
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "ID", mID);
        cache_get_value_name(i, "message", mMessage, 512);
        cache_get_value_name(i, "sender", mSender, 50);
        cache_get_value_name_int(i, "status", mStatus);
        cache_get_value_name_int(i, "createdAt", mDate);
        UnixToHuman(mDate, mTime);
        strcat(string, sprintf("MesageID: %d\n", mID));
        strcat(string, sprintf("Sent By: %s\n", mSender));
        strcat(string, sprintf("Date: %s\n\n", mTime));
        strcat(string, sprintf("Message: %s\n\n", mMessage));
    }
    cache_delete(result);
    mysql_tquery(Database, sprintf("update whatsapp set status = 1 where ID = %d", messageID));
    return FlexPlayerDialog(
        playerid, "WhatsappViewMsg", DIALOG_STYLE_MSGBOX, sprintf("{4286f4}[WhatsApp]: {FFFFFF}Message from %s", mSender), string, "Delete", "Back", messageID
    );
}

FlexDialog:WhatsappViewMsg(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Whatsapp:init(playerid);
    mysql_tquery(Database, sprintf("delete from whatsapp where ID = %d", extraid));
    return Whatsapp:init(playerid);
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "whatsapp") && GetPlayerVIPLevel(playerid) > 0) {
        Whatsapp:init(playerid);
        return ~1;
    }
    return 1;
}

// group chat system

#define GC:%0 GcS@
enum GC:EnumData {
    GC:title[50],
        bool:GC:isPublic,
        bool:GC:status,

        GC:groupID,
        GC:inviteID
}

new GC:Data[MAX_PLAYERS][GC:EnumData];

stock GC:setGroupID(playerid, groupID) {
    GC:Data[playerid][GC:groupID] = groupID;
    return 1;
}

stock GC:getGroupID(playerid) {
    return GC:Data[playerid][GC:groupID];
}

stock GC:isGroupActive(groupID) {
    if (!IsPlayerConnected(groupID)) return 0;
    return GC:Data[groupID][GC:status];
}

hook OnPlayerConnect(playerid) {
    GC:setGroupID(playerid, -1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (GC:isGroupActive(GC:getGroupID(playerid))) {
        if (GC:getGroupID(playerid) == playerid) {
            foreach(new i:Player) {
                if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                    SendClientMessage(i, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}%s group closed", GC:Data[GC:getGroupID(playerid)][GC:title]));
                    GC:setGroupID(i, -1);
                }
            }
        } else {
            foreach(new i:Player) {
                if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                    SendClientMessage(i, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}%s leaved this group", GetPlayerNameEx(playerid)));
                }
            }
        }
    }
    GC:setGroupID(playerid, -1);
    return 1;
}

cmd:gchat(playerid, const params[]) {
    if (IsStringContainWords(params, "helpme")) {
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}Commands.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat creategroup - to create your own group.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat joingroup [groupID] - to join a group with groupID.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat leavegroup - to leave your current group.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat closegroup - to close your current group.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat settitle - to change group name.");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat makeprivate - to change group state [0/1].");
        SendClientMessage(playerid, -1, "{FFFFEE}/gchat sendinvite - send invitation for private chat.");
        return 1;
    }
    if (IsStringContainWords(params, "sendinvite")) {
        if (!GC:isGroupActive(GC:getGroupID(playerid))) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you haven't created any group yet.");
            return 1;
        }
        new extraid;
        if (sscanf(GetNextWordFromString(params, "sendinvite"), "u", extraid)) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}invalid player name or id, can not send invitation.");
        }
        if (!IsPlayerConnected(playerid) || extraid == playerid) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}invalid player name or id, can not send invitation.");
        }
        GC:Data[extraid][GC:inviteID] = GC:getGroupID(playerid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}invitation sent to %s.", GetPlayerNameEx(extraid)));
        SendClientMessage(extraid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}%s invited you to %s Group.", GetPlayerNameEx(playerid), GC:Data[GC:getGroupID(playerid)][GC:title]));
        return 1;
    }
    if (IsStringContainWords(params, "makeprivate")) {
        if (!GC:isGroupActive(GC:getGroupID(playerid))) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you haven't created any group yet.");
            return 1;
        }
        if (GC:getGroupID(playerid) != playerid) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you can not set title of this group, because it is not your group.");
            return 1;
        }
        new bool:stateC;
        if (sscanf(GetNextWordFromString(params, "makeprivate"), "d", stateC)) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}invalid state given, try again.");
            return 1;
        }
        GC:Data[playerid][GC:isPublic] = stateC;
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}your group chat is now %s.", GC:Data[playerid][GC:isPublic] ? "PUBLIC" : "PRIVATE"));
        return 1;
    }
    if (IsStringContainWords(params, "settitle")) {
        if (!GC:isGroupActive(GC:getGroupID(playerid))) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you haven't created any group yet.");
            return 1;
        }
        if (GC:getGroupID(playerid) != playerid) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you can not set title of this group, because it is not your group.");
            return 1;
        }
        new string[30];
        if (sscanf(params, "s[30]", string)) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}invalid title for group name.");
            return 1;
        }
        strreplace(string, "settitle ", "");
        strreplace(string, "settitle", "");
        format(GC:Data[playerid][GC:title], 50, "%s", string);
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}group chat title updated.");
        return 1;
    }
    if (IsStringContainWords(params, "creategroup")) {
        if (GC:isGroupActive(GC:getGroupID(playerid))) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you are already in a active group, leave current group to create your own.");
            return 1;
        }
        GC:setGroupID(playerid, playerid);
        format(GC:Data[playerid][GC:title], 50, "%s's", GetPlayerNameEx(playerid));
        GC:Data[playerid][GC:isPublic] = true;
        GC:Data[playerid][GC:status] = true;
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}your group has been created.");
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}Group Title: %s", GC:Data[playerid][GC:title]));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}Group State: %s", GC:Data[playerid][GC:isPublic] ? "PUBLIC" : "PRIVATE"));
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}type /gchat helpme for manage your group.");
        return 1;
    }
    if (IsStringContainWords(params, "joingroup")) {
        if (GC:isGroupActive(GC:getGroupID(playerid))) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you are already in a active group, leave current group to create your own.");
            return 1;
        }
        new groupID;
        if (sscanf(GetNextWordFromString(params, "joingroup"), "d", groupID)) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}type /gchat joingroup [groupID].");
            return 1;
        }
        if (!GC:isGroupActive(groupID)) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}given group is not active, try to invited group or active public group.");
            return 1;
        }
        if (!GC:Data[playerid][GC:isPublic] && GC:Data[playerid][GC:inviteID] != groupID) {
            SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you can join private groups on invitation only.");
            return 1;
        }
        GC:setGroupID(playerid, groupID);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}joined %s.", GC:Data[groupID][GC:title]));
        foreach(new i:Player) {
            if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                SendClientMessage(i, -1, sprintf("{ffff99}[%s Group]: {FFFFEE}%s joined this group", GC:Data[GC:getGroupID(playerid)][GC:title], GetPlayerNameEx(playerid)));
            }
        }
        return 1;
    }
    if (IsStringContainWords(params, "leavegroup")) {
        if (GC:getGroupID(playerid) == playerid) {
            SendClientMessage(playerid, -1, "you can not leave this group, because it is your group. try /gchat closegroup");
            return 1;
        }
        foreach(new i:Player) {
            if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                SendClientMessage(i, -1, sprintf("{ffff99}[%s Group]: {FFFFEE}%s leaved this group", GetPlayerNameEx(playerid)));
            }
        }
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Group Chat]: {FFFFEE}leaved %s.", GC:Data[GC:getGroupID(playerid)][GC:title], GC:Data[GC:getGroupID(playerid)][GC:title]));
        GC:setGroupID(playerid, -1);
        return 1;
    }

    if (IsStringContainWords(params, "closegroup")) {
        if (GC:getGroupID(playerid) != playerid) {
            SendClientMessage(playerid, -1, "you can not close this group, because you can only close your group. try /gchat leavegroup");
            return 1;
        }
        foreach(new i:Player) {
            if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                SendClientMessage(i, -1, sprintf("{ffff99}[%s Group]: {FFFFEE}%s group closed", GC:Data[GC:getGroupID(playerid)][GC:title], GC:Data[GC:getGroupID(playerid)][GC:title]));
                GC:setGroupID(i, -1);
            }
        }
        GC:setGroupID(playerid, -1);
        return 1;
    }
    if (!GC:isGroupActive(GC:getGroupID(playerid))) {
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you are not in any group chat :(");
        SendClientMessage(playerid, -1, "{4286f4}[Group Chat]: {FFFFEE}you can join or create a group, type /gchat helpme for more infomration :)");
        return 1;
    } else {
        foreach(new i:Player) {
            if (GC:getGroupID(playerid) == GC:getGroupID(i)) {
                SendClientMessage(i, -1, sprintf("{ffff99}[%s Group][%s]: {FFFFEE}%s", GC:Data[GC:getGroupID(playerid)][GC:title], GetPlayerNameEx(playerid), params));
            }
        }
    }
    return 1;
}