cmd:refund(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new username[50], amount, reason[100];
    if (sscanf(params, "s[50]ds[100]", username, amount, reason)) return SendClientMessage(playerid, -1, "[USAGE]: /refund [playername] [amount] [reason]");
    if (!IsValidAccount(username)) return SendClientMessage(playerid, -1, "[ERROR]: Invalid account.");
    if (amount < 1) return SendClientMessage(playerid, -1, "[ERROR]: Refund amount must be greater than $0.");
    if (amount > 9900000) return SendClientMessage(playerid, -1, "[ERROR]: Refund amount cannot exceed $9,900,000.");
    if (strlen(reason) < 5) return SendClientMessage(playerid, -1, "[ERROR]: Reason must be at least 5 characters long.");

    mysql_tquery(Database, sprintf(
        "INSERT INTO refunds (username, amount, reason, givenby, createdat) VALUES (\"%s\", %d, \"%s\", \"%s\", %d)",
        username,
        amount,
        reason,
        GetPlayerNameEx(playerid),
        gettime()
    ));

    SendClientMessage(playerid, -1, sprintf("$%s refund has been added for %s | Reason: %s", FormatCurrency(amount), username, reason));

    new targetid = GetPlayerIDByName(username);
    if (IsPlayerConnected(targetid)) {
        AlexaMsg(targetid, sprintf("refund for $%s available at cityhall, you can collect it", FormatCurrency(amount)));
    } else {
        Email:Send(
            ALERT_TYPE_ACCOUNT,
            username,
            sprintf("Refund of $%s!!", FormatCurrency(amount)),
            sprintf("San Andreas Government Department initiated refund of $%s for reason: %s-n--n-you can visit cityhall to collect it.", FormatCurrency(amount), reason)
        );
    }

    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != SHOP_ID_REFUND) return 1;
    Refund:ShowRefunds(playerid);
    return ~1;
}

stock Refund:ShowRefunds(playerid) {
    new string[2000];
    strcat(string, sprintf("Hello, %s\n\n", GetPlayerNameEx(playerid)));
    strcat(string, "welcome to San Andreas Government Department refund progress, let me tell you brief discussion about this program.\n");
    strcat(string, "When server management or the government itself decide to give you some money, they use this program to do that\n\n");
    strcat(string, "How this work?\n");
    strcat(string, "when there is a refund from government side issued to you, a alert mail has been sent to you on your email account.\n");
    strcat(string, "you can come back to the locations of refund programs where you can collect this monies, you just have to select the refund to claim it.\n\n");
    strcat(string, "Click on check to check your refunds\n");
    return FlexPlayerDialog(playerid, "RefundShowRefunds", DIALOG_STYLE_MSGBOX, "SAGD: Refund", string, "Check", "Close");
}

FlexDialog:RefundShowRefunds(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    Refund:ViewRefunds(playerid);
    return 1;
}

stock Refund:GetTotal(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from refunds where username =\"%s\" and claimed = 0", username));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock Refund:ViewRefunds(playerid, page = 0) {
    new total = Refund:GetTotal(GetPlayerNameEx(playerid));
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "select * from refunds where username=\"%s\" and claimed = 0 order by createdat desc limit %d, %d",
        GetPlayerNameEx(playerid), skip, perpage
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        return SendClientMessageEx(playerid, -1, "{4286f4}[SAGD]:{0000CD} could not found any refunds for you");
    }

    new string[2000], reason[250], givenby[50], amount, time, refundid;
    format(string, sizeof(string), "#\tAmount\tReason\tGiven By | Time\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "id", refundid);
        cache_get_value_name_int(i, "amount", amount);
        cache_get_value_name(i, "reason", reason, sizeof reason);
        cache_get_value_name(i, "givenby", givenby, sizeof givenby);
        cache_get_value_name_int(i, "createdat", time);
        strcat(string, sprintf("%d\t$%s\t%s\t%s | %s\n", refundid, FormatCurrency(amount), reason, givenby, UnixToHumanEx(time)));
    }
    cache_delete(mysql_cache);

    if (page > 0) strcat(string, "Back Page");
    if (remaining > 0) strcat(string, "Next Page");

    return FlexPlayerDialog(
        playerid, "RefundViewRefunds", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[SAGD]:{0000CD} Refunds", string, "Claim", "Close", page
    );
}

FlexDialog:RefundViewRefunds(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return Refund:ViewRefunds(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Refund:ViewRefunds(playerid, page - 1);
    new refundid;
    if (sscanf(inputtext, "d", refundid)) return 1;
    Refund:Claim(playerid, refundid);
    return 1;
}

stock Refund:Claim(playerid, refundid) {
    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "select * from refunds where username=\"%s\" and claimed = 0 and id = %d", GetPlayerNameEx(playerid), refundid
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        return SendClientMessageEx(playerid, -1, "{4286f4}[SAGD]:{0000CD} could not found refund");
    }

    new reason[250], amount;
    cache_get_value_name_int(0, "amount", amount);
    cache_get_value_name(0, "reason", reason, sizeof reason);
    cache_delete(mysql_cache);

    AlexaMsg(playerid, sprintf(FormatColors("you have claimed ~g~$%s~w~ refund from san andreas government department"), FormatCurrency(amount)));
    AlexaMsg(playerid, sprintf(FormatColors("~r~Reason: ~y~%s"), reason));

    vault:PlayerVault(
        playerid, amount, sprintf("refund for %s", reason),
        Vault_ID_Government, -amount, sprintf("%s: refund for %s", GetPlayerNameEx(playerid), reason)
    );

    mysql_tquery(Database, sprintf("update refunds set claimed = 1 where id = %d", refundid));
    return 1;
}