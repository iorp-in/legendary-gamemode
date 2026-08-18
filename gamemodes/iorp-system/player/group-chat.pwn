
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