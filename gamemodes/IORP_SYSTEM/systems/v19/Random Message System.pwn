hook GlobalFiveMinInterval() {
    mysql_tquery(Database, "select * from randomMessages order by rand() limit 1", "HintMessageShow");
    return 1;
}

forward HintMessageShow();
public HintMessageShow() {
    new rows = cache_num_rows();
    if (!rows) return 1;
    new Message[150];
    cache_get_value_name(0, "message", Message);
    SendClientMessageToAll(-1, sprintf("{4286f4}[Hint]:{FFFFFF} %s", FormatColors(Message)));
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Hint Messages System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Hint Messages System", inputtext)) HintMessages:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "hint messages") || GetPlayerAdminLevel(playerid) < 8) return 1;
    HintMessages:AdminPanel(playerid);
    return ~1;
}

stock HintMessages:AdminPanel(playerid) {
    new string[1024];
    if (HintMessages:GetTotal() > 0) strcat(string, "View full list\n");
    strcat(string, "Add new message\n");
    return FlexPlayerDialog(
        playerid, "HintMessagesAdminPanel", DIALOG_STYLE_LIST, "Hint Messages", string, "Select", "Close"
    );
}

FlexDialog:HintMessagesAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "View full list")) return HintMessages:ViewAll(playerid);
    if (IsStringSame(inputtext, "Add new message")) return HintMessages:AddNew(playerid);
    return 1;
}

stock HintMessages:AddNew(playerid) {
    return FlexPlayerDialog(
        playerid, "HintMessagesAddNew", DIALOG_STYLE_INPUT, "Hint Messages",
        "Enter your message...............................................",
        "Add", "Cancel"
    );
}

FlexDialog:HintMessagesAddNew(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return HintMessages:AdminPanel(playerid);
    new message[110];
    if (sscanf(inputtext, "s[110]", message)) return HintMessages:AddNew(playerid);
    mysql_tquery(Database, sprintf(
        "insert into randomMessages (message, createdAt, createdBy) values (\"%s\", %d, \"%s\")",
        message, gettime(), GetPlayerNameEx(playerid)
    ));
    return HintMessages:AdminPanel(playerid);
}

stock HintMessages:GetTotal() {
    new Cache:result = mysql_query(Database, "select count(*) as total from randomMessages");
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock HintMessages:ViewAll(playerid, page = 0) {
    new total = HintMessages:GetTotal();
    new perpage = 10;
    new totalpage = floatround(total / perpage);
    new paged = (page + 1) * perpage;
    new skip = page * perpage;
    new remaining = total - paged;

    new Cache:mysql_cache = mysql_query(Database, sprintf("select * from randomMessages limit %d, %d", skip, perpage));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        AlexaMsg(playerid, "could not found any hint messsages");
        return HintMessages:AdminPanel(playerid);
    }

    new string[2000], messageid, message[150];
    format(string, sizeof(string), "ID\tMessage\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "id", messageid);
        cache_get_value_name(i, "message", message, sizeof message);
        strcat(string, sprintf("%d\t%s\n", messageid, FormatColors(message)));
    }
    cache_delete(mysql_cache);
    if (remaining > 0) strcat(string, "Next\tPage\n");
    if (page > 0) strcat(string, "Back\tPage\n");

    return FlexPlayerDialog(
        playerid, "HintMessagesViewAll", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Hint Messages: Page %d/%d", page, totalpage), string, "Select", "Close", page
    );
}

FlexDialog:HintMessagesViewAll(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return HintMessages:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Next")) return HintMessages:ViewAll(playerid, page + 1);
    if (IsStringSame(inputtext, "Back")) return HintMessages:ViewAll(playerid, page - 1);
    new messageid = strval(inputtext);
    return HintMessages:ManageHint(playerid, messageid);
}

stock HintMessages:ManageHint(playerid, messageid) {
    new string[512];
    strcat(string, "Edit\n");
    strcat(string, "Remove\n");
    return FlexPlayerDialog(
        playerid, "HintMessagesManageHint", DIALOG_STYLE_LIST, "Hint Messages", string, "Select", "Close", messageid
    );
}

FlexDialog:HintMessagesManageHint(playerid, response, listitem, const inputtext[], messageid, const payload[]) {
    if (!response) return HintMessages:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Edit")) return HintMessages:EditHint(playerid, messageid);
    if (IsStringSame(inputtext, "Remove")) {
        mysql_tquery(Database, sprintf("delete from randomMessages where id = %d", messageid));
        return HintMessages:AdminPanel(playerid);
    }
    return 1;
}

stock HintMessages:EditHint(playerid, messageid) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select * from randomMessages where id = %d", messageid));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        AlexaMsg(playerid, "hint not found");
        return HintMessages:AdminPanel(playerid);
    }
    new hint[150];
    cache_get_value_name(0, "message", hint);
    cache_delete(mysql_cache);

    new string[1024];
    strcat(string, sprintf("Hint: %s\n\n", hint));
    strcat(string, "Enter new message to update...................................................");
    return FlexPlayerDialog(playerid, "HintMessagesEditHint", DIALOG_STYLE_INPUT, "Update Hint", string, "Update", "Close", messageid);
}

FlexDialog:HintMessagesEditHint(playerid, response, listitem, const inputtext[], messageid, const payload[]) {
    if (!response) return HintMessages:ManageHint(playerid, messageid);
    new newHint[110];
    if (sscanf(inputtext, "s[110]", newHint)) return HintMessages:EditHint(playerid, messageid);
    mysql_tquery(Database, sprintf("update randomMessages set message = \"%s\" where id = %d", newHint, messageid));
    return HintMessages:ManageHint(playerid, messageid);
}