ASCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    ASCP:AddCommand(playerid, "Reset In Hand Money");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Reset In Hand Money", inputtext)) {
        ResetInHandMoney(playerid);
        return ~1;
    }
    return 1;
}

stock ResetInHandMoney(playerid) {
    FlexPlayerDialog(playerid, "ResetInHandMoney", DIALOG_STYLE_INPUT, "Reset In Hand Money", "Enter [min amount] [reset amount] [limit]", "Submit", "Cancel");
    return 1;
}

FlexDialog:ResetInHandMoney(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new minBalance, resetAmount, limit;
    if (sscanf(inputtext, "ddd", minBalance, resetAmount, limit) ||
        minBalance < 0 || resetAmount < 0 || limit < 1
    ) return ResetInHandMoney(playerid);

    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT username, cash FROM players WHERE cash >  %d limit %d", minBalance, limit));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        AlexaMsg(playerid, "zero account matched your criteria of query.");
        return 1;
    }

    AlexaMsg(playerid, sprintf("%d accounts match your reset criteria", rows));

    new cash, username[50];
    for (new i; i < rows; i++) {
        cache_get_value_name_int(i, "cash", cash);
        cache_get_value_name(i, "username", username);

        Email:Send(ALERT_TYPE_SERVER, username, "Great Reset: In Hand Money", sprintf(
            "As part of the economic initiative, your in hand cash has been reset to $%s from $%s. \
            Your contribution of $%s is deeply appreciated by us. For your contribution, we have a few perks for you. \
            You can check them out on the forums.",
            FormatCurrency(resetAmount), FormatCurrency(cash), FormatCurrency(cash - resetAmount)
        ));

        mysql_tquery(Database, sprintf(
            "insert into playerLogMoney (username, amount, balance, transaction) VALUES (\"%s\", %d, %d, \"%s\")",
            username, resetAmount - cash, cash, "contribution to iorp economy"
        ));

        mysql_tquery(Database, sprintf(
            "update players set cash = %d where username = \"%s\"", resetAmount, username
        ));
    }

    cache_delete(mysql_cache);
    return 1;
}