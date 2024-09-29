hook OnGameModeInit() {
    Database:AddColumn("playerdata", "Debt", "int", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    new debt = Debt:Get(playerid);
    if (debt > 0) AlexaMsg(playerid, sprintf("you have to pay $%s debt to goverment.", FormatCurrency(debt)));
    return 1;
}

hook OnCopBodySearch(playerid, suspectid) {
    new debt = Debt:Get(suspectid);
    if (debt > 0) AlexaMsg(playerid, sprintf("Debt: $%s.", FormatCurrency(debt)), "SAPD");
    return 1;
}

stock Debt:Get(playerid) {
    return Database:GetInt(GetPlayerNameEx(playerid), "username", "Debt");
}

stock Debt:GiveOrTake(playerid, amount, const log[], warn = 1) {
    Database:UpdateInt(Debt:Get(playerid) + amount, GetPlayerNameEx(playerid), "username", "Debt");
    AddDebtLog(playerid, amount, log);
    new debt = Debt:Get(playerid);
    if (debt > 0 && warn) AlexaMsg(playerid, sprintf("you have to pay $%s debt to goverment..", FormatCurrency(amount)));
    return 1;
}

stock Debt:OfflineGiveOrTake(username[], amount, const log[]) {
    if (!IsValidAccount(username)) return 1;
    mysql_tquery(Database, sprintf("UPDATE `playerdata` SET Debt = Debt + %d WHERE `Username` = \"%s\" LIMIT 1", amount, username));
    AddDebtLogOffline(username, amount, log);
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 36) return 1;
    DebtPayMenu(playerid);
    return ~1;
}

stock DebtPayMenu(playerid) {
    new debt = Debt:Get(playerid);
    if (debt < 1) return AlexaMsg(playerid, "{4286f4}[Alexa]:{FFFFEE} you don't have any debt, enjoy :)");
    new string[512];
    strcat(string, sprintf("you own $%s to san andreas government department\n", FormatCurrency(debt)));
    strcat(string, "you can check your debt logs at iorp.in for information regarding your debt.\n");
    strcat(string, "enter amount of debt you want to self pay.\n");
    return FlexPlayerDialog(playerid, "MenuPayDebtConfirm", DIALOG_STYLE_INPUT, "Pay your debt", string, "Pay", "Close");
}

FlexDialog:MenuPayDebtConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new debt = Debt:Get(playerid);
    if (debt < 1) return AlexaMsg(playerid, "{4286f4}[Alexa]:{FFFFEE} you don't have any debt, enjoy :)");
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > debt) return DebtPayMenu(playerid);

    if (GetPlayerCash(playerid) < amount) {
        AlexaMsg(playerid, "{4286f4}[Alexa]:{FFFFEE} you don't have enough money to pay your debt");
        return DebtPayMenu(playerid);
    }

    vault:PlayerVault(playerid, -amount, sprintf("payed debt of $%s debt", FormatCurrency(debt)),
        Vault_ID_Government, amount, sprintf("%s payed debt of $%s debt", GetPlayerNameEx(playerid), FormatCurrency(debt))
    );
    Debt:GiveOrTake(playerid, -amount, sprintf("self payed debt of $%s debt", FormatCurrency(debt)), 0);
    AlexaMsg(playerid, sprintf("{4286f4}[Alexa]:{FFFFEE} you have payed $%s of $%s debt to government, check iorp.in for confirmation", FormatCurrency(amount), FormatCurrency(debt)));
    return 1;
}

DC_CMD:getalldebt(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Cache:cache_id = Cache:mysql_query(Database, "select username, debt from playerdata where debt > 0 order by debt desc");
    new total = cache_num_rows();
    if (total == 0) {
        cache_delete(Cache:cache_id);
        DCC_SendChannelMessage(DCC_Channel:channel, "No player have debt, all are clear.");
        return 1;
    }
    new string[2000], name[100], debt, count = 0;
    strcat(string, "```");
    for (new i; i < total; i++) {
        cache_get_value_name(i, "username", name);
        cache_get_value_name_int(i, "debt", debt);
        strcat(string, sprintf("username: %s\nDebt: $%s\n\n", name, FormatCurrency(debt)));
        count++;
        if (count >= 20) {
            count = 0;
            strcat(string, "```");
            cache_delete(Cache:cache_id);
            DCC_SendChannelMessage(DCC_Channel:channel, string);
            format(string, sizeof string, "```");
            return 1;
        }
    }
    strcat(string, "```");
    cache_delete(Cache:cache_id);
    DCC_SendChannelMessage(DCC_Channel:channel, string);
    return 1;
}

DC_CMD:getplayerdebt(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new account[100];
    if (sscanf(params, "s[100]", account)) return DCC_SendChannelMessage(DCC_Channel:channel, "```:getplayerdebt [player name]```");
    if (!IsValidAccount(account)) return DCC_SendChannelMessage(DCC_Channel:channel, "invalid player id");

    // check debt amount
    new Cache:cache_id = Cache:mysql_query(Database, sprintf("select debt from playerdata where username = \"%s\" and debt > 0 order by debt desc", account));
    new total = cache_num_rows();
    if (total == 0) {
        cache_delete(Cache:cache_id);
        DCC_SendChannelMessage(DCC_Channel:channel, "player don't have any debt.");
        return 1;
    }

    new debt;
    cache_get_value_name_int(0, "debt", debt);
    cache_delete(Cache:cache_id);

    // load last 10 records
    new Cache:rcache_id = Cache:mysql_query(Database, sprintf("select * from playerLogDebts where username = \"%s\" order by id desc limit 10", account));
    new rtotal = cache_num_rows();

    new string[2000], rdebt, transaction[100], created[30];
    for (new i; i < rtotal; i++) {
        cache_get_value_name_int(i, "amount", rdebt);
        cache_get_value_name(i, "transaction", transaction);
        cache_get_value_name(i, "created", created);
        strcat(string, sprintf("> %s: $%s: %s\n", created, FormatCurrency(rdebt), transaction));
    }
    cache_delete(Cache:rcache_id);

    // prepare final message
    new finalMessage[2000];
    format(finalMessage, sizeof finalMessage, "```\n\
    Player: %s\n\
    Debt: $%s\n\n\
    Recent Logs\n\
    %s```", account, FormatCurrency(debt), string);
    DCC_SendChannelMessage(DCC_Channel:channel, finalMessage);
    return 1;
}

DC_CMD:giveplayerdebt(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new account[100], debt, reason[100];
    if (sscanf(params, "s[100]ds[100]", account, debt, reason) || debt < 1) return DCC_SendChannelMessage(DCC_Channel:channel, "```:giveplayerdebt [player name] [amount] [reason]```");
    if (!IsValidAccount(account)) return DCC_SendChannelMessage(DCC_Channel:channel, "invalid player id");
    mysql_tquery(Database, sprintf("UPDATE `playerdata` SET Debt = Debt + %d WHERE `Username` = \"%s\" LIMIT 1", debt, account));
    AddDebtLogOffline(account, debt, reason);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("assigned debt of $%s to %s for %s", FormatCurrency(debt), account, reason));
    new playerid = GetPlayerIDByName(account);
    if (IsPlayerConnected(playerid)) {
        AlexaMsg(playerid, sprintf("Management assigned $%s amount of debt on your account", FormatCurrency(debt)));
        AlexaMsg(playerid, sprintf("Reason: %s", reason));
    } else {
        new mail[1024];
        strcat(mail, "Management has assigned debt on your account-n--n-");
        strcat(mail, sprintf("Debt: $%s-n-", FormatCurrency(debt)));
        strcat(mail, sprintf("Reason: %s-n--n-", reason));
        strcat(mail, "you can raise complain against this debt on forum.iorp.in");
        Email:Send(ALERT_TYPE_ACCOUNT, account, sprintf("Management assigned debt of $%s", FormatCurrency(debt)), mail);
    }

    return 1;
}

DC_CMD:resetplayerdebt(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new account[100], reason[1000];
    if (sscanf(params, "s[100]s[100]", account, reason)) return DCC_SendChannelMessage(DCC_Channel:channel, "```:resetplayerdebt [player name] [reason]```");
    if (!IsValidAccount(account)) return DCC_SendChannelMessage(DCC_Channel:channel, "invalid player id");

    // check debt amount
    new Cache:cache_id = Cache:mysql_query(Database, sprintf("select debt from playerdata where username = \"%s\" and debt > 0 order by debt desc", account));
    new total = cache_num_rows();
    if (total == 0) {
        cache_delete(Cache:cache_id);
        DCC_SendChannelMessage(DCC_Channel:channel, "player don't have any debt.");
        return 1;
    }

    mysql_tquery(Database, sprintf("UPDATE `playerdata` SET Debt = 0 WHERE `Username` = \"%s\" LIMIT 1", account));
    AddDebtLogOffline(account, 0, sprintf("debt reseted by %s: %s", user, reason));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("reseted debt of %s", account));
    new playerid = GetPlayerIDByName(account);
    if (IsPlayerConnected(playerid)) {
        AlexaMsg(playerid, "Management has reseted debt of your account");
        AlexaMsg(playerid, sprintf("Reason: %s", reason));
    } else {
        new mail[1024];
        strcat(mail, "Management has reseted debt of your account-n--n-");
        strcat(mail, sprintf("Reason: %s-n--n-", reason));
        strcat(mail, "you can raise complain against this debt reset on forum.iorp.in");
        Email:Send(ALERT_TYPE_ACCOUNT, account, "Management has reseted debt of your account", mail);
    }
    return 1;
}