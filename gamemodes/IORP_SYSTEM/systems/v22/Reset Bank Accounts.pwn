ASCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    ASCP:AddCommand(playerid, "Reset Bank Accounts");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Reset Bank Accounts", inputtext)) {
        ResetBankAccountBal(playerid);
        return ~1;
    }
    return 1;
}

stock ResetBankAccountBal(playerid) {
    FlexPlayerDialog(playerid, "ResetBankAccountBal", DIALOG_STYLE_INPUT, "Reset Bank Accounts", "Enter [min amount] [reset amount] [limit]", "Submit", "Cancel");
    return 1;
}

FlexDialog:ResetBankAccountBal(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new minBalance, resetBalance, limit;
    if (
        sscanf(inputtext, "ddd", minBalance, resetBalance, limit) ||
        minBalance < 0 || resetBalance < 0 || limit < 1
    ) return ResetBankAccountBal(playerid);

    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM bankAccounts WHERE balance > %d limit %d", minBalance, limit));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        AlexaMsg(playerid, "zero account matched your criteria of query.");
        return 1;
    }

    AlexaMsg(playerid, sprintf("%d accounts match your reset criteria", rows));

    new accountId, balance, username[50];
    for (new i; i < rows; i++) {
        cache_get_value_name_int(i, "ID", accountId);
        cache_get_value_name_int(i, "Balance", balance);
        cache_get_value_name(i, "Owner", username);

        Email:Send(ALERT_TYPE_SERVER, username, sprintf("Great Reset: Bank Account (%d)", accountId), sprintf(
            "As part of the economic initiative, your bank account balance with account id %d has been reset to $%s from $%s. \
            Your contribution of $%s is deeply appreciated by us. For your contribution, we have a few perks for you. \
            You can check them out on the forums.",
            accountId, FormatCurrency(resetBalance), FormatCurrency(balance), FormatCurrency(balance - resetBalance)
        ));

        Bank:SaveLog(playerid, TYPE_WITHDRAW, accountId, -1, resetBalance - balance, "contribution to iorp economy");

        mysql_tquery(Database, sprintf(
            "update bankAccounts set balance = %d where id = %d", resetBalance, accountId
        ));
    }

    cache_delete(mysql_cache);
    return 1;
}