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
    if (GetPlayerVIPLevel(playerid) == 0 || !IsStringSame(text, "whatsapp")) return 1;
    Whatsapp:init(playerid);
    return ~1;
}