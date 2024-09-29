new rpId[MAX_PLAYERS] = {-1, ... };
#define MAX_RP_LINKS 10
new rpLinks[MAX_PLAYERS][MAX_RP_LINKS];

stock Roleplay:ResetLinks(playerid) {
    for (new i; i < MAX_RP_LINKS; i++) {
        rpLinks[playerid][i] = -1;
    }
    return 1;
}

stock Roleplay:GetFreeLinkId(playerid) {
    for (new i; i < MAX_RP_LINKS; i++) {
        if (rpLinks[playerid][i] == -1) {
            return i;
        }
    }
    return -1;
}

stock Roleplay:LinkRpID(playerid, slotId, rpid) {
    rpLinks[playerid][slotId] = rpid;
    return 1;
}

stock Roleplay:UnLinkRpID(playerid, rpid) {
    for (new i; i < MAX_RP_LINKS; i++) {
        if (rpLinks[playerid][i] == rpid) {
            rpLinks[playerid][i] = -1;
        }
    }
    return 1;
}

stock Roleplay:isLinked(playerid, rpid) {
    for (new i; i < MAX_RP_LINKS; i++) {
        if (rpLinks[playerid][i] == rpid) {
            return 1;
        }
    }
    return 0;
}

hook OnPlayerConnect(playerid) {
    rpId[playerid] = -1;
    Roleplay:ResetLinks(playerid);
    return 1;
}

hook GlobalFiveMinInterval() {
    foreach(new playerid: Player) {
        new string[512];
        for (new i; i < MAX_RP_LINKS; i++) {
            if (rpLinks[playerid][i] != -1) {
                strcat(string, sprintf("%d, ", rpLinks[playerid][i]));
                return 1;
            }
        }
        if (strlen(string) > 0) {
            AlexaMsg(playerid, sprintf("Linked roleplays: %s", string));
        }
    }
    return 1;
}

stock Roleplay:GetTotalRoleplay(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from roleplayPlayers where username = \"%s\" order by rpid desc", username));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock Roleplay:GetTotalRoleplayMessages(rpid) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from roleplayMessages where rpid = %d", rpid));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock Roleplay:GetPlayerRpId(playerid) {
    return rpId[playerid];
}

stock Roleplay:IsRateLimited(playerid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplays where username = \"%s\" and datetime > %d",
        GetPlayerNameEx(playerid), gettime() - 3600
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    if (rows > 5) return 1;
    return 0;
}

stock Roleplay:IsValidId(rpid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplays where id = %d", rpid
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    return rows ? 1 : 0;
}

stock Roleplay:IsOwner(playerid, rpid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplays where username = \"%s\" and id = %d",
        GetPlayerNameEx(playerid), rpid
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    return rows ? 1 : 0;
}

stock Roleplay:CanJoin(playerid, rpid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplayPlayers where username = \"%s\" and rpid = %d",
        GetPlayerNameEx(playerid), rpid
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    return rows ? 1 : 0;
}

stock Roleplay:CanJoinEx(const account[], rpid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplayPlayers where username = \"%s\" and rpid = %d",
        account, rpid
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    return rows ? 1 : 0;
}

stock Roleplay:Create(playerid, const title[]) {
    mysql_tquery(Database, sprintf(
        "insert into roleplays (title, username, datetime) values (\"%s\", \"%s\", %d)",
        title, GetPlayerNameEx(playerid), gettime()
    ), "OnRoleplayInsert", "d", playerid);
    return 1;
}

forward OnRoleplayInsert(playerid);
public OnRoleplayInsert(playerid) {
    new rpid = cache_insert_id();
    AlexaMsg(playerid, sprintf("created roleplay scene with id: %d", rpid));
    Roleplay:AddPlayer(GetPlayerNameEx(playerid), rpid);
    return 1;
}

stock Roleplay:AddPlayer(const account[], rpid) {
    mysql_tquery(Database, sprintf(
        "insert into roleplayPlayers (rpid, username, datetime) values (%d, \"%s\", %d)",
        rpid, account, gettime()
    ));
    return 1;
}

stock Roleplay:RemovePlayer(const account[], rpid) {
    mysql_tquery(Database, sprintf(
        "delete from roleplayPlayers where rpid = %d and username = \"%s\"",
        rpid, account
    ));
    return 1;
}

stock Roleplay:Log(playerid, const message[], const type[]) {
    new time = gettime();
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) return 0;
    mysql_tquery(Database, sprintf(
        "insert into roleplayMessages (rpid, username, datetime, message, type) values (%d, \"%s\", %d, \"%s\", \"%s\")",
        rpid, GetPlayerNameEx(playerid), time, RemoveMalChars(message), type
    ));
    for (new i; i < MAX_RP_LINKS; i++) {
        if (rpLinks[playerid][i] != -1) {
            mysql_tquery(Database, sprintf(
                "insert into roleplayMessages (rpid, username, datetime, message, type) values (%d, \"%s\", %d, \"%s\", \"%s\")",
                rpLinks[playerid][i], GetPlayerNameEx(playerid), time, RemoveMalChars(message), type
            ));
        }
    }
    return 1;
}

Roleplay:CanFactionJoin(factionid, rpid) {
    new Cache:response_cache = mysql_query(Database, sprintf(
        "select * from roleplayFactions where factionid = %d and rpid = %d",
        factionid, rpid
    ));
    new rows = cache_num_rows();
    cache_delete(Cache:response_cache);
    return rows ? 1 : 0;
}

Roleplay:LinkFaction(factionid, rpid) {
    mysql_tquery(Database, sprintf(
        "insert into roleplayFactions (rpid, factionid, datetime) values (%d, %d, %d)",
        rpid, factionid, gettime()
    ));
    return 1;
}

Roleplay:RemoveFaction(factionid, rpid) {
    mysql_tquery(Database, sprintf(
        "delete from roleplayFactions where rpid = %d and factionid = %d",
        rpid, factionid
    ));
    return 1;
}

Roleplay:ChangeTitle(rpid, const newTitle[]) {
    mysql_tquery(Database, sprintf(
        "update roleplays set title = \"%s\" where id = %d",
        RemoveMalChars(newTitle), rpid
    ));
    return 1;
}

Roleplay:Verify(rpid, status) {
    mysql_tquery(Database, sprintf(
        "update roleplays set verified = %d where id = %d",
        status, rpid
    ));
    return 1;
}

cmd:rp(playerid, const params[]) {
    AlexaMsg(playerid, "New Generation Roleplay System", "Alexa", "4286f4", "f4b042");
    AlexaMsg(playerid, "=== Available Commands ===");
    AlexaMsg(playerid, "{FFFF00}/rpcreate [title]{FFFFFF} - create a roleplay scene");
    AlexaMsg(playerid, "{FFFF00}/rpjoin [rpid]{FFFFFF} - join a roleplay scene");
    AlexaMsg(playerid, "{FFFF00}/rpleave{FFFFFF} - leave the roleplay scene");
    AlexaMsg(playerid, "{FFFF00}/rpinvite [player]{FFFFFF} - invite a player in roleplay scene");
    AlexaMsg(playerid, "{FFFF00}/rpkick [player]{FFFFFF} - kick the player from roleplay scene");
    AlexaMsg(playerid, "{FFFF00}/rplink [rpid]{FFFFFF} - link a roleplay scene with other scene");
    AlexaMsg(playerid, "{FFFF00}/rpunlink [rpid]{FFFFFF} - unlink the roleplay scene from linked scene");
    AlexaMsg(playerid, "{FFFF00}/rpfactionlink [factionid]{FFFFFF} - link a roleplay scene to faction");
    AlexaMsg(playerid, "{FFFF00}/rpfactionunlink [factionid]{FFFFFF} - unlink the roleplay scene from faction");
    AlexaMsg(playerid, "{FFFF00}/rplist{FFFFFF} - manage your roleplay");
    AlexaMsg(playerid, "{FFFF00}/rptitle{FFFFFF} - change roleplay title");
    if (GetPlayerAdminLevel(playerid) > 0) {
        AlexaMsg(playerid, "{FFFF00}/arplist{FFFFFF} - view player roleplay list");
        AlexaMsg(playerid, "{FFFF00}/rpverify{FFFFFF} - un/verify a roleplay");
    }
    return 1;
}

cmd:rpcreate(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) != -1) {
        return AlexaMsg(playerid, "you have already joined a roleplay scene, please use /rpleave first");
    }

    new title[100];
    if (sscanf(params, "s[100]", title)) {
        return AlexaMsg(playerid, sprintf("/rpcreate [title]"));
    }

    if (Roleplay:IsRateLimited(playerid)) {
        return AlexaMsg(playerid, "roleplay scene limit exceeded, please try again");
    }

    Roleplay:Create(playerid, RemoveMalChars(title));
    return 1;
}

cmd:rpjoin(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) != -1) {
        return AlexaMsg(playerid, "you have already joined a roleplay scene, please use /rpleave first");
    }

    new rpid;
    if (sscanf(params, "d", rpid)) {
        return AlexaMsg(playerid, sprintf("/rpjoin [rpid]"));
    }

    if (!Roleplay:CanJoin(playerid, rpid)) {
        return AlexaMsg(playerid, "you can not join given roleplay id, please make sure you have enough permissions");
    }

    rpId[playerid] = rpid;
    AlexaMsg(playerid, sprintf("Joined roleplay id: %d", rpid));
    return 1;
}

cmd:rpleave(playerid, const params[]) {
    if (Roleplay:GetPlayerRpId(playerid) == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    AlexaMsg(playerid, sprintf("leaving roleplay id: %d", Roleplay:GetPlayerRpId(playerid)));
    Roleplay:ResetLinks(playerid);
    rpId[playerid] = -1;
    return 1;
}

cmd:rpinvite(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    // if (!Roleplay:IsOwner(playerid, rpid)) {
    //     return AlexaMsg(playerid, "only roleplay scene owner can invite players");
    // }

    new Account[30];
    if (sscanf(params, "s[30]", Account) || !IsValidAccount(Account) || IsStringSame(Account, GetPlayerNameEx(playerid))) {
        return AlexaMsg(playerid, "/rpinvite [player name]");
    }

    if (Roleplay:CanJoinEx(Account, rpid)) {
        return AlexaMsg(playerid, sprintf("%s is already in this roleplay scene", Account));
    }

    Roleplay:AddPlayer(Account, rpid);
    AlexaMsg(playerid, sprintf("%s added into current roleplay scene", Account));
    SendClientMessageByName(Account, sprintf(
        "you have been invite in roleplay id %d by %s", rpid, GetPlayerNameEx(playerid)
    ));
    return 1;
}

cmd:rpkick(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    if (!Roleplay:IsOwner(playerid, rpid)) {
        return AlexaMsg(playerid, "only roleplay scene owner can kick players");
    }

    new Account[30];
    if (sscanf(params, "s[30]", Account) || !IsValidAccount(Account) || IsStringSame(Account, GetPlayerNameEx(playerid))) {
        return AlexaMsg(playerid, "/rpkick [player name]");
    }

    if (!Roleplay:CanJoinEx(Account, rpid)) {
        return AlexaMsg(playerid, sprintf("%s is not in this roleplay scene", Account));
    }

    Roleplay:RemovePlayer(Account, rpid);
    AlexaMsg(playerid, sprintf("%s removed from current roleplay scene", Account));
    SendClientMessageByName(Account, sprintf(
        "you have been removed from roleplay id %d by %s", rpid, GetPlayerNameEx(playerid)
    ));
    return 1;
}

cmd:rplink(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    new linkRpId;
    if (sscanf(params, "d", linkRpId) || linkRpId == rpid || !Roleplay:IsValidId(linkRpId)) {
        return AlexaMsg(playerid, "/rplink [rpid]");
    }

    if (Roleplay:CanJoin(playerid, linkRpId)) {
        return AlexaMsg(playerid, "You cannot join the requested rpid, ask the owner of the scene to invite you");
    }

    if (Roleplay:isLinked(playerid, linkRpId)) {
        return AlexaMsg(playerid, "Mentioned RpId, already linked");
    }

    new slotId = Roleplay:GetFreeLinkId(playerid);
    if (slotId == -1) {
        return AlexaMsg(playerid, "At a time, you can link up to 10 RP scenes");
    }

    Roleplay:LinkRpID(playerid, slotId, linkRpId);
    AlexaMsg(playerid, sprintf("RpId %d has been linked to current roleplay scene", linkRpId));
    return 1;
}

cmd:rpunlink(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    new linkRpId;
    if (sscanf(params, "d", linkRpId) || linkRpId == rpid || !Roleplay:isLinked(playerid, linkRpId)) {
        return AlexaMsg(playerid, "/rplink [rpid]");
    }

    Roleplay:UnLinkRpID(playerid, linkRpId);
    AlexaMsg(playerid, sprintf("RpId %d has been unlinked from current roleplay scene", linkRpId));
    return 1;
}

cmd:rpfactionlink(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    if (!Roleplay:IsOwner(playerid, rpid)) {
        return AlexaMsg(playerid, "only roleplay scene owner can link faction");
    }

    new factionid;
    if (sscanf(params, "d", factionid) || !Faction:IsValidID(factionid)) {
        return AlexaMsg(playerid, "/rplink [factionid]");
    }

    if (Roleplay:CanFactionJoin(factionid, rpid)) {
        return AlexaMsg(playerid, sprintf("faction %s is already in this roleplay scene", Faction:GetName(factionid)));
    }

    Roleplay:LinkFaction(factionid, rpid);
    AlexaMsg(playerid, sprintf("faction %s has been linked to current roleplay scene", Faction:GetName(factionid)));
    return 1;
}

cmd:rpfactionunlink(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    if (!Roleplay:IsOwner(playerid, rpid)) {
        return AlexaMsg(playerid, "only roleplay scene owner can unlink faction");
    }

    new factionid;
    if (sscanf(params, "d", factionid) || !Faction:IsValidID(factionid)) {
        return AlexaMsg(playerid, "/rpunlink [factionid]");
    }

    if (!Roleplay:CanFactionJoin(factionid, rpid)) {
        return AlexaMsg(playerid, sprintf("faction %s is not in this roleplay scene", Faction:GetName(factionid)));
    }

    Roleplay:RemoveFaction(factionid, rpid);
    AlexaMsg(playerid, sprintf("faction %s has been removed from current roleplay scene", Faction:GetName(factionid)));
    return 1;
}

cmd:rptitle(playerid, const params[]) {
    new rpid = Roleplay:GetPlayerRpId(playerid);
    if (rpid == -1) {
        return AlexaMsg(playerid, "you are not in any roleplay scene");
    }

    if (!Roleplay:IsOwner(playerid, rpid)) {
        return AlexaMsg(playerid, "only roleplay scene owner can change title");
    }

    new newTitle[100];
    if (sscanf(params, "s[100]", newTitle)) {
        return AlexaMsg(playerid, "/rptitle [new title]");
    }

    Roleplay:ChangeTitle(rpid, newTitle);
    AlexaMsg(playerid, sprintf("roleplay title changed to: %s", newTitle));
    return 1;
}

cmd:rpverify(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    new rpid, status;
    if (sscanf(params, "dd", rpid, status) || rpid < 1 || status < 0 || status > 1) {
        return AlexaMsg(playerid, "/rpverify [RPID] [0/1]");
    }
    Roleplay:Verify(rpid, status);
    if (status == 1) {
        Discord:SendHelper(sprintf("%s verified roleplay id: %d", GetPlayerNameEx(playerid), rpid));
        AlexaMsg(playerid, sprintf("roleplay %d status updated to verified", rpid));
    } else {
        Discord:SendHelper(sprintf("%s unverified roleplay id: %d", GetPlayerNameEx(playerid), rpid));
        AlexaMsg(playerid, sprintf("roleplay %d status updated to unverified", rpid));
    }
    return 1;
}

cmd:rplist(playerid, const params[]) {
    Roleplay:ShowRpList(playerid, GetPlayerNameEx(playerid));
    return 1;
}

cmd:arplist(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    new username[50];
    if (sscanf(params, "s[50]", username) || !IsValidAccount(username)) {
        return AlexaMsg(playerid, "/arplist [username]");
    }
    Roleplay:ShowRpList(playerid, username);
    return 1;
}

Roleplay:ShowRpList(playerid, const username[], page = 0) {
    new total = Roleplay:GetTotalRoleplay(username);
    if (!total) {
        return AlexaMsg(playerid, "The player did not participate in any roleplay scenes");
    }
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "select roleplays.id, roleplays.username, roleplays.title, FROM_UNIXTIME(roleplays.datetime) as datetime from roleplayPlayers \
        left join roleplays on roleplayPlayers.rpid = roleplays.id where roleplayPlayers.username = \"%s\" \
        order by roleplays.id desc limit %d, 10",
        username, skip
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        return AlexaMsg(playerid, "The player did not participate in any roleplay scenes");
    }

    new rpid, title[100], owner[50], datetime[100], string[2000];
    format(string, sizeof(string), "RpId\tTitle\tOwner\tTime\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "id", rpid);
        cache_get_value_name(i, "title", title);
        cache_get_value_name(i, "username", owner);
        cache_get_value_name(i, "datetime", datetime);
        strcat(string, sprintf("%d\t%s\t%s\t%s\n", rpid, title, owner, datetime));
    }
    cache_delete(mysql_cache);

    if (remaining > 0) format(string, sizeof(string), "%s{FFFFFF}Next Page\n", string);
    if (page > 0) format(string, sizeof(string), "%s{FFFFFF}Back Page\n", string);

    return FlexPlayerDialog(
        playerid, "ShowRoleplayList", DIALOG_STYLE_TABLIST_HEADERS,
        "{4286f4}[Alexa]:{0000CD}Roleplays", string, "Close", "Close",
        page, username
    );
}

FlexDialog:ShowRoleplayList(playerid, response, listitem, const inputtext[], page, const username[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return Roleplay:ShowRpList(playerid, username, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Roleplay:ShowRpList(playerid, username, page - 1);
    return Roleplay:ShowRpMessages(playerid, strval(inputtext), username);
}

Roleplay:ShowRpMessages(playerid, rpid, const username[], page = 0) {
    new total = Roleplay:GetTotalRoleplayMessages(rpid);
    if (!total) {
        Roleplay:ShowRpList(playerid, username);
        return AlexaMsg(playerid, "There are no roleplay messages in selected roleplay scenes");
    }
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "select FROM_UNIXTIME(datetime) as created, message from roleplayMessages where rpid = %d order by datetime asc limit %d, 10", rpid, skip
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        Roleplay:ShowRpList(playerid, username);
        return AlexaMsg(playerid, "There are no roleplay messages in selected roleplay scenes");
    }

    new Created[50], type[50], Message[150], string[2000];
    format(string, sizeof(string), "Time\tRoleplay Line\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name(i, "created", Created);
        cache_get_value_name(i, "message", Message);
        cache_get_value_name(i, "type", type);
        strcat(string, sprintf("{FFFFFF}%s\t%s%s\n", Created, (IsStringSame(type, "me") ? "{9370DB}" : "{FFE4B5}"), Message));
    }
    cache_delete(mysql_cache);

    if (remaining > 0) format(string, sizeof(string), "%s{FFFFFF}Next Page\n", string);
    if (page > 0) format(string, sizeof(string), "%s{FFFFFF}Back Page\n", string);

    return FlexPlayerDialog(
        playerid, "ShowRoleplayMessages", DIALOG_STYLE_TABLIST_HEADERS,
        "{4286f4}[Alexa]: Roleplay Scene", string, "Close", "Close",
        page, sprintf("%d %s", rpid, username)
    );
}

FlexDialog:ShowRoleplayMessages(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new rpid, username[100];
    sscanf(payload, "ds[100]", rpid, username);
    if (!response) {
        return Roleplay:ShowRpList(playerid, username);
    }
    if (IsStringSame(inputtext, "Next Page")) return Roleplay:ShowRpMessages(playerid, rpid, username, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Roleplay:ShowRpMessages(playerid, rpid, username, page - 1);
    return Roleplay:ShowRpMessages(playerid, rpid, username, page);
}