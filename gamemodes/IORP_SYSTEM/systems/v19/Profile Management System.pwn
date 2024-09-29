stock IsAccountMasterAdmin(const Account[]) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `players` WHERE `Username` = \"%s\" and MasterAdmin = 1 LIMIT 1", Account));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return 1;
}

stock IsValidAccount(const Account[]) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `players` WHERE `Username` = \"%s\" LIMIT 1", Account));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return 1;
}

stock IsAccountLoggedInLast(const Account[], seconds = 24 * 60 * 60) {
    new Cache:mysql_cache = mysql_query(
        Database, sprintf(
            "select username from loginLogs where username = \"%s\" and timestamp >= %d group by username",
            Account, gettime() - seconds
        )
    );
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return 1;
}

stock IsAccountActive(const Account[]) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `players` WHERE `Username` = \"%s\" and bantime < UNIX_TIMESTAMP() and status = 1 LIMIT 1", Account));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (rows) return 1;
    return 0;
}

stock GetAccountAdminLevel(const Account[]) {
    new level;
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `players` WHERE `Username` = \"%s\" LIMIT 1", Account));
    new rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "adminLevel", level);
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return level;
}

stock GetAccountVIPLevel(const Account[]) {
    new level;
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `players` WHERE `Username` = \"%s\" LIMIT 1", Account));
    new rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "VIPLevel", level);
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return level;
}

stock AccountRename(const CurrentName[], const NewName[]) {
    if (!IsValidAccount(CurrentName)) return 0;
    if (IsValidAccount(NewName)) return 0;
    return CallRemoteFunction("OnAccountRename", "ss", CurrentName, NewName);
}

stock AccountDelete(const AccountName[]) {
    if (!IsValidAccount(AccountName)) return 0;
    return CallRemoteFunction("OnAccountDelete", "s", AccountName);
}

stock BanPlayer(playerid, mins, const reason[]) {
    if (!IsPlayerConnected(playerid)) return 0;
    new banfor = gettime() + mins * 60;
    new unbantime[100];
    UnixToHuman(banfor, unbantime);
    AddPlayerReportLog(GetPlayerNameEx(playerid), sprintf("banned till %s", unbantime), reason);
    mysql_tquery(Database, sprintf("UPDATE `players` set bantime = %d, banreason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", banfor, reason, GetPlayerNameEx(playerid)));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you are temporary banned from server. Reason: {FF0000}%s", reason));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you can join server again after {FF0000}%s", unbantime));
    KickPlayer(playerid, 3);
    return 1;
}

forward OnAccountRename(const OldName[], const NewName[]);
public OnAccountRename(const OldName[], const NewName[]) {
    return 1;
}
forward OnAccountDelete(const AccountName[]);
public OnAccountDelete(const AccountName[]) {
    return 1;
}

forward OnAccountEnabled(const Account[]);
public OnAccountEnabled(const Account[]) {
    return 1;
}

forward OnAccountDisabled(const Account[]);
public OnAccountDisabled(const Account[]) {
    return 1;
}

// DC_CMD

DC_CMD:getadmins(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Cache:mysql_cache = mysql_query(Database, "SELECT * FROM `players` Where adminLevel > 0 ORDER BY adminLevel DESC");
    new rows = cache_num_rows();
    if (rows) {
        DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Admin List");
        new level, uName[50], count;
        while (count < rows) {
            cache_get_value_name(count, "username", uName, sizeof uName);
            cache_get_value_name_int(count, "adminLevel", level);
            DCC_SendChannelMessage(DCC_Channel:channel, sprintf("Username: %s Admin Level: %d", uName, level));
            count++;
        }
    } else DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: No Admin Found");
    cache_delete(mysql_cache);
    return 1;
}

DC_CMD:ban(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], mins, banreason[100];
    if (sscanf(params, "s[50]ds[100]", Account, mins, banreason)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !ban [Account] [mins] [reason]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (mins < 1) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Invalid mins for ban");
    if (mins > 43800) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: can not ban account for more then one month, consider deactivation");
    new unbantime[50];
    UnixToHuman(gettime() + mins * 60, unbantime);
    if (!IsPlayerInServerByName(Account)) Email:Send(ALERT_TYPE_ACCOUNT, Account, "Your account has been temporarily banned",
        sprintf("your account has been temporarily banned by server management, -n--n-Unban time: %s-n-Reason: %s.-n--n-you can request for early unban of your account at forum.iorp.in only", unbantime, RemoveMalChars(banreason)));
    mysql_tquery(Database, sprintf("UPDATE `players` set bantime = %d, banreason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", gettime() + mins * 60, RemoveMalChars(banreason), Account));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s account has been banned", Account));
    AddPlayerReportLog(Account, sprintf("banned till %s", unbantime), banreason);
    foreach(new i:Player) {
        if (IsStringSame(Account, GetPlayerNameEx(i))) {
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} your account has been banned by management.");
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} apply for unban at forum.iorp.in.");
            KickPlayer(i);
            break;
        }
    }
    return 1;
}

DC_CMD:unban(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50];
    if (sscanf(params, "s[50]", Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !unban [Account]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (!IsPlayerInServerByName(Account)) Email:Send(ALERT_TYPE_ACCOUNT, Account, "Your account ban is removed", "your account ban is removed by server management. you can now login into iorp samp server.");
    mysql_tquery(Database, sprintf("UPDATE `players` set bantime = %d, banreason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", gettime(), "not provided", Account));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s account has been unbanned", Account));
    return 1;
}

DC_CMD:enableaccount(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50];
    if (sscanf(params, "s[50]", Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !enableaccount [Account]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (!IsPlayerInServerByName(Account)) Email:Send(ALERT_TYPE_ACCOUNT, Account, "Your account reactivated", "your account has been reactivated by server management. you can now login into iorp samp server.");
    mysql_tquery(Database, sprintf("UPDATE `players` set Status = true WHERE `Username` = \"%s\" LIMIT 1", Account));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s account has been activated", Account));
    CallRemoteFunction("OnAccountEnabled", "s", Account);
    return 1;
}

DC_CMD:disableaccount(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], disablereason[100];
    if (sscanf(params, "s[50]s[100]", Account, disablereason)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !disableaccount [Account] [Reason]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    mysql_tquery(Database, sprintf("UPDATE `players` set Status = false, disablereason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", RemoveMalChars(disablereason), Account));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s account has been deactivated", Account));
    CallRemoteFunction("OnAccountDisabled", "s", Account);
    AddPlayerReportLog(Account, "Disabled account permanently", disablereason);
    if (!IsPlayerInServerByName(Account)) {
        Email:Send(
            ALERT_TYPE_ACCOUNT, Account,
            "Your account permanently disabled",
            sprintf(
                "your account has been permanently disabled by server management, \
                Reason: %s.-n--n-you can request for reactivation of your account at forum.iorp.in only",
                RemoveMalChars(disablereason)
            )
        );
    }
    foreach(new i:Player) {
        if (IsStringSame(Account, GetPlayerNameEx(i))) {
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} your account has been disabled by management.");
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} apply for reactivation at forum.iorp.in.");
            KickPlayer(i);
            break;
        }
    }
    return 1;
}

DC_CMD:updatename(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new CurrentName[30], NewName[30];
    if (sscanf(params, "s[30]s[30]", CurrentName, NewName)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !updatename [account name] [new account name]");
    if (!IsValidAccount(RemoveMalChars(CurrentName))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (IsValidAccount(RemoveMalChars(NewName))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: new name is occupied, can't update name request.");
    foreach(new i:Player) {
        if (IsStringSame(GetPlayerNameEx(i), CurrentName)) {
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} your account has been renamed as per your request.");
            KickPlayer(i);
            break;
        }
    }
    AccountRename(CurrentName, NewName);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s account has been renamed to %s", CurrentName, NewName));
    return 1;
}

DC_CMD:getmasteradmins(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Cache:mysql_cache = mysql_query(Database, "SELECT * FROM `players` Where MasterAdmin = true");
    new rows = cache_num_rows();
    if (rows) {
        DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Master Admin List");
        new uName[50], count;
        while (count < rows) {
            cache_get_value_name(count, "username", uName, sizeof uName);
            DCC_SendChannelMessage(DCC_Channel:channel, sprintf("Username: %s", uName));
            count++;
        }
    } else DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: No Master Admin Found");
    cache_delete(mysql_cache);
    return 1;
}

DC_CMD:changepassword(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new AccountName[50], newpass[50];
    if (sscanf(params, "s[50]s[50]", AccountName, newpass)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Usage]: !changeofflineaccountpassword [AccountName] [Password]");
    if (!IsValidAccount(AccountName)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (strlen(newpass) < 8) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Passwords must be at least 8 characters long.");
    new nPassword[65], nSalt[11];
    for (new i = 0; i < 10; i++) nSalt[i] = random(79) + 47;
    nSalt[10] = 0;
    SHA256_PassHash(newpass, nSalt, nPassword, 65);
    new DB_Query[512];
    mysql_format(Database, DB_Query, sizeof(DB_Query), "UPDATE `players` SET `Password`=\"%s\",`Salt`=\"%s\" WHERE `Username`=\"%s\"", nPassword, RemoveMalChars(nSalt), AccountName);
    new Cache:result = mysql_query(Database, DB_Query, true);
    if (cache_affected_rows()) DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: you have changed %s login password with %s", AccountName, newpass));
    else DCC_SendChannelMessage(DCC_Channel:channel, "[Error]: Something went wrong or Account ID is invalid");
    cache_delete(result);
    return 1;
}

DC_CMD:nonrpalert(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50];
    if (sscanf(params, "s[50]", Account)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !nonrpalert [Account]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    Email:Send(ALERT_TYPE_ACCOUNT, Account, "Your account will be deactivated soon for non rp name",
        "your account has been marked for non rp name by server management. \
         Registering with non rp name is serious violation of our terms and conditions. \
         In order to prevent account deactivation, please apply for name change at forum.iorp.in, \
         you can reply to this email for further clarification.");
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: non rp name alert has been sent to %s", Account));
    foreach(new i:Player) {
        if (IsStringSame(Account, GetPlayerNameEx(i))) {
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} your account name is marked as non rp name, which is serious violation of our terms and conditions.");
            SendClientMessageEx(i, -1, "{4286f4}[Alexa]:{FF0000} In order to prevent account deactivation, please apply for name change at forum.iorp.in.");
            break;
        }
    }
    return 1;
}