cmd:rpgun(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    new Message[256], No_Weapons[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 39, 40, 41, 42, 43, 44, 45, 46 }, weaponid = GetPlayerWeapon(playerid);
    if (!IsArrayContainNumber(No_Weapons, weaponid)) format(Message, sizeof Message, "*%s puts him/her self in safe position and ready to fight with weapon %s.", GetPlayerNameEx(playerid), GetWeaponNameEx(weaponid));
    else format(Message, sizeof(Message), "*%s puts him/her self in safe position and ready to fight.", GetPlayerNameEx(playerid));
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, Message);
    return 1;
}

cmd:rpgunout(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    new Message[256], No_Weapons[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 39, 40, 41, 42, 43, 44, 45, 46 }, weaponid = GetPlayerWeapon(playerid);
    if (IsArrayContainNumber(No_Weapons, weaponid)) return 0;
    format(Message, sizeof Message, "*%s takes out a %s from his inner shirt pocket.", GetPlayerNameEx(playerid), GetWeaponNameEx(weaponid));
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, Message);
    return 1;
}

cmd:rpgunput(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    new Message[256], No_Weapons[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 39, 40, 41, 42, 43, 44, 45, 46 }, weaponid = GetPlayerWeapon(playerid);
    if (IsArrayContainNumber(No_Weapons, weaponid)) return 0;
    format(Message, sizeof Message, "*%s puts his %s in his inner shirt pocket.", GetPlayerNameEx(playerid), GetWeaponNameEx(weaponid));
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, Message);
    return 1;
}

cmd:rpcuff(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s take out the cuffs from pocket and grab the hands of suspect on back and tried to cuff his/her hands.", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Do you resist? (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpsurrender(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s found him/her self trapped and in trouble and can't escape, surrenders him/her self", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Do you accept? (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpenginestart(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s twists the key and try to start vehicle engine", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Engine started... (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpenginestop(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s twists the key and try to stop vehicle engine", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Engine stopped... (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rphouseunlock(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s takes the key from the pocket, inserts and locks it and twist it to unlock his/her house door", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rphouselock(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s takes the key from the pocket, inserts and locks it and twist it to lock his/her house door", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpbath(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s walks in bathroom, turns on the shower and get a bath", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rparrest(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s taken a suspect in custody, s/he will be detained and charges will be executed.", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rphandsup(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s shouts hands in the air or s/he will shoot if he sees any unexpected movements", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Will you put your hands in the air? (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpbodycheck(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s put his gun on back and searching suspect body for any hidden weapons or items.", GetPlayerNameEx(playerid)));
    SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("Do you have anything hidden? (%s)", GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpapproach(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s aim his gun to head of suspect and slowly approaching him/her.", GetPlayerNameEx(playerid)));
    return 1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
cmd:arp(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return AlexaMsg(playerid, "purchase vip package to use autorp.");
    new rpcode[20];
    if (sscanf(RemoveMalChars(params), "s[20]", rpcode)) return SyntaxMSG(playerid, "/arp [rpcode]");
    return AutoRpPerform(playerid, rpcode);
}

stock AutoRpPerform(playerid, const rpcode[]) {
    return mysql_tquery(Database, sprintf("select * from autorp where username = \"%s\" and rpcode = \"%s\"", GetPlayerNameEx(playerid), rpcode), "AutoRpLoad", "d", playerid);
}

forward AutoRpLoad(playerid);
public AutoRpLoad(playerid) {
    new rows = cache_num_rows();
    if (!rows) return AlexaMsg(playerid, "you have entered invalid auto rp code, please verify your codes.");
    new merp[150], dorp[150];
    cache_get_value_name(0, "rp", merp);
    cache_get_value_name(0, "do", dorp);
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s %s.", GetPlayerNameEx(playerid), merp));
    if (strlen(dorp) > 3) SendRPMessageToAll(playerid, 100.0, COLOR_MOCCASIN, sprintf("%s (%s)", dorp, GetPlayerNameEx(playerid)));
    return 1;
}

cmd:rpmanage(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return AlexaMsg(playerid, "purchase vip package to use autorp.");
    return AutoRpMenu(playerid);
}

stock AutoRpMenu(playerid) {
    new string[512];
    strcat(string, "View List\n");
    strcat(string, "Add Auto RP\n");
    strcat(string, "Remove Auto RP\n");
    return FlexPlayerDialog(playerid, "AutoRpMenuMain", DIALOG_STYLE_LIST, "Auto RP", string, "Select", "Close");
}

FlexDialog:AutoRpMenuMain(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "View List")) return AutoRpMenuViewAll(playerid);
    if (IsStringSame(inputtext, "Add Auto RP")) return AutoRpMenuAddNew(playerid);
    if (IsStringSame(inputtext, "Remove Auto RP")) return AutoRpRemoveInput(playerid);
    return 1;
}

stock AutoRpRemoveInput(playerid) {
    return FlexPlayerDialog(playerid, "AutoRpRemoveInput", DIALOG_STYLE_INPUT, "Auto Roleplay: Remove", "Enter rpcode to remove", "Remove", "Back");
}

FlexDialog:AutoRpRemoveInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AutoRpMenu(playerid);
    new rpcode[100];
    if (sscanf(RemoveMalChars(inputtext), "s[100]", rpcode)) return AutoRpRemoveInput(playerid);
    if (!AutoRpCodeIsExist(playerid, rpcode)) AlexaMsg(playerid, "rpcode does not exist");
    else {
        AlexaMsg(playerid, "removed entered rpcode");
        mysql_tquery(Database, sprintf("delete from autorp where username = \"%s\" and rpcode = \"%s\"", GetPlayerNameEx(playerid), rpcode));
    }
    return AutoRpRemoveInput(playerid);
}

stock AutoRpMenuAddNew(playerid) {
    return FlexPlayerDialog(playerid, "AutoRpMenuAddNew", DIALOG_STYLE_INPUT, "Auto Roleplay: Add",
        "Enter auto rp code\nyou can create any custom string withing legth of 20 characters", "Next", "Back"
    );
}

FlexDialog:AutoRpMenuAddNew(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AutoRpMenu(playerid);
    new rpcode[20];
    if (sscanf(RemoveMalChars(inputtext), "s[20]", rpcode)) return AutoRpMenuAddNew(playerid);

    if (AutoRpCodeIsExist(playerid, rpcode)) {
        AlexaMsg(playerid, "rpcode already exist, try another code.");
        return AutoRpMenuAddNew(playerid);
    }

    return AutoRpMenuAddRp(playerid, rpcode);
}

stock AutoRpMenuAddRp(playerid, const rpcode[]) {
    return FlexPlayerDialog(playerid, "AutoRpMenuAdd", DIALOG_STYLE_INPUT, "Auto Roleplay: Add", "Enter /me line, enter without prefix.", "Next", "Back", 0, rpcode);
}

FlexDialog:AutoRpMenuAdd(playerid, response, listitem, const inputtext[], extraid, const rpcode[]) {
    if (!response) return AutoRpMenuAddNew(playerid);
    new rpline[100];
    if (sscanf(RemoveMalChars(inputtext), "s[100]", rpline)) return AutoRpMenuAddRp(playerid, rpcode);
    return AutoRpAddDo(playerid, rpcode, rpline);
}

stock AutoRpAddDo(playerid, const rpcode[], const rpline[]) {
    return FlexPlayerDialog(playerid, "AutoRpAddDo", DIALOG_STYLE_INPUT,
        "Auto Roleplay: Add", "Enter /do line, enter without prefix.\nif you don't want to add /do line then simply enter - (minus or dash)",
        "Next", "Back", -1, sprintf("%s=%s", rpcode, rpline)
    );
}

FlexDialog:AutoRpAddDo(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new rpcode[100], rpline[100];
    sscanf(payload, "p<=>s[100]s[100]", rpcode, rpline);
    if (!response) return AutoRpMenuAddRp(playerid, rpcode);
    new doline[100];
    if (sscanf(RemoveMalChars(inputtext), "s[100]", doline)) return AutoRpAddDo(playerid, rpcode, rpline);
    AlexaMsg(playerid, sprintf("Added rpcode: %s", rpcode));
    SendClientMessage(playerid, COLOR_MEDIUMPURPLE, sprintf("*%s %s.", GetPlayerNameEx(playerid), rpline));
    if (strlen(doline) > 3) SendClientMessage(playerid, COLOR_MOCCASIN, sprintf("%s (%s)", doline, GetPlayerNameEx(playerid)));
    new query[2000];
    mysql_format(Database, query, sizeof query,
        "insert into autorp (username, rpcode, rp, do, created) values(\"%s\", \"%s\", \"%s\", \"%s\", %d)",
        GetPlayerNameEx(playerid), rpcode, rpline, doline, gettime()
    );
    mysql_tquery(Database, query);
    return AutoRpMenu(playerid);
}

stock AutoRpCodeIsExist(playerid, const rpcode[]) {
    new total = 0;
    new Cache:response_cache = mysql_query(Database,
        sprintf("select count(*) as total from autorp where username = \"%s\" and rpcode = \"%s\" limit 1", GetPlayerNameEx(playerid), rpcode)
    );
    cache_get_value_name_int(0, "total", total);
    cache_delete(response_cache);
    return total;
}

stock AutoRpGetTotal(playerid) {
    new total = 0;
    new Cache:response_cache = mysql_query(Database, sprintf("select count(*) as total from autorp where username = \"%s\"", GetPlayerNameEx(playerid)));
    cache_get_value_name_int(0, "total", total);
    cache_delete(response_cache);
    return total;
}

stock AutoRpMenuViewAll(playerid) {
    new total = AutoRpGetTotal(playerid);
    if (total == 0) {
        AlexaMsg(playerid, "you don't have any auto rp, please add at least one to view it's code.");
        return AutoRpMenu(playerid);
    }
    return ViewAutoRpList(playerid, total);
}

stock ViewAutoRpList(playerid, total, page = 0) {
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * total;

    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from autorp where username = \"%s\" order by created desc limit %d,15",
        GetPlayerNameEx(playerid), skip
    ));
    new rows = cache_num_rows();

    new string[2000], rpcode[100], rp[150], dorp[150];
    strcat(string, "rpcode\trp\n");
    for (new i; i < rows; i++) {
        cache_get_value_name(i, "rpcode", rpcode);
        cache_get_value_name(i, "rp", rp);
        cache_get_value_name(i, "do", dorp);
        strcat(string, sprintf("%s\tme: %s\n", rpcode, rp));
        if (strlen(dorp) > 3) strcat(string, sprintf("%s\tdo: %s\n", rpcode, dorp));
    }
    cache_delete(response_cache);

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(playerid, "ViewAutoRpList", DIALOG_STYLE_TABLIST_HEADERS, "Auto Roleplay: List", string, "Select", "Close", total, sprintf("%d", page));
}

FlexDialog:ViewAutoRpList(playerid, response, listitem, const rpcode[], total, const payload[]) {
    new page = strval(payload);
    if (!response) return AutoRpMenu(playerid);
    if (IsStringSame(rpcode, "Next Page")) return ViewAutoRpList(playerid, total, page + 1);
    if (IsStringSame(rpcode, "Back Page")) return ViewAutoRpList(playerid, total, page - 1);
    return AutoRpPerform(playerid, rpcode);
}