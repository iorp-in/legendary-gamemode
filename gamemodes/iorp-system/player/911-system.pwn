enum callEnum {
    bool:isCalling,
    callType,
    cTimer
}
new cPlayerData[MAX_PLAYERS][callEnum];

hook OnPlayerConnect(playerid) {
    cPlayerData[playerid][isCalling] = false;
    cPlayerData[playerid][callType] = -1;
    cPlayerData[playerid][cTimer] = -1;
    return 1;
}

stock Show911Menu(playerid) {
    SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}what's your emergency?");
    new string[512];
    strcat(string, "Police\n"); // call type 0
    strcat(string, "Medic\n"); // call type 1
    strcat(string, "News Department\n"); // call type 2
    strcat(string, "Mechanic\n"); // call type 3
    return FlexPlayerDialog(playerid, "Show911Menu", DIALOG_STYLE_LIST, "{4286f4}[911]: {FFFFEE}service required?", string, "select", "End Call");
}

FlexDialog:Show911Menu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    initEmergencyCall(playerid, listitem);
    return 1;
}

stock initEmergencyCall(playerid, calltype) {
    if (cPlayerData[playerid][isCalling]) return 0;
    if (calltype < 0 || calltype > 3) return 1;
    new lawFactions[] = { 0, 1, 2, 3 };
    new bool:callMade = false;
    if (calltype == 0) {
        foreach(new playerID:Player) {
            if (playerID == playerid) continue;
            if (IsArrayContainNumber(lawFactions, Faction:GetPlayerFID(playerID)) && Faction:IsPlayerSigned(playerID)) {
                SendClientMessage(playerID, -1, sprintf("{4286f4}[911]: {FFFFEE}please repond to %s on his/her emergency. type /respond %d ", GetPlayerNameEx(playerid), playerid));
                callMade = true;
                cPlayerData[playerid][isCalling] = true;
                cPlayerData[playerid][callType] = calltype;
                cPlayerData[playerid][cTimer] = SetPreciseTimer("CallTimer911", 60 * 1000, false, "d", playerid);
            }
        }
        if (callMade) SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}please wait, we are transfering your call to our local police department...");
        else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}we can understand your emegency, but all our operatives are busy. please try again...");
    } else if (calltype == 1) {
        foreach(new playerID:Player) {
            if (playerID == playerid) continue;
            if (Faction:GetPlayerFID(playerID) == 6 && Faction:IsPlayerSigned(playerID)) {
                SendClientMessage(playerID, -1, sprintf("{4286f4}[911]: {FFFFEE}please repond to %s on his/her emergency. type /respond %d ", GetPlayerNameEx(playerid), playerid));
                callMade = true;
                cPlayerData[playerid][isCalling] = true;
                cPlayerData[playerid][callType] = calltype;
                cPlayerData[playerid][cTimer] = SetPreciseTimer("CallTimer911", 60 * 1000, false, "d", playerid);
            }
        }
        if (callMade) SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}please wait, we are transfering your call to our local medical department...");
        else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}we can understand your emegency, but all our operatives are busy. please try again...");
    } else if (calltype == 2) {
        foreach(new playerID:Player) {
            if (playerID == playerid) continue;
            if (Faction:GetPlayerFID(playerID) == 4 && Faction:IsPlayerSigned(playerID)) {
                SendClientMessage(playerID, -1, sprintf("{4286f4}[911]: {FFFFEE}please repond to %s on his/her emergency. type /respond %d ", GetPlayerNameEx(playerid), playerid));
                callMade = true;
                cPlayerData[playerid][isCalling] = true;
                cPlayerData[playerid][callType] = calltype;
                cPlayerData[playerid][cTimer] = SetPreciseTimer("CallTimer911", 60 * 1000, false, "d", playerid);
            }
        }
        if (callMade) SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}please wait, we are transfering your call to our local news department...");
        else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}we can understand your emegency, but all our operatives are busy. please try again...");
    } else if (calltype == 3) {
        foreach(new playerID:Player) {
            if (playerID == playerid) continue;
            if (Faction:GetPlayerFID(playerID) == 11 && Faction:IsPlayerSigned(playerID)) {
                SendClientMessage(playerID, -1, sprintf("{4286f4}[911]: {FFFFEE}please repond to %s on his/her emergency. type /respond %d ", GetPlayerNameEx(playerid), playerid));
                callMade = true;
                cPlayerData[playerid][isCalling] = true;
                cPlayerData[playerid][callType] = calltype;
                cPlayerData[playerid][cTimer] = SetPreciseTimer("CallTimer911", 60 * 1000, false, "d", playerid);
            }
        }
        if (callMade) SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}please wait, we are transfering your call to our local mechanic department...");
        else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}we can understand your emegency, but all our operatives are busy. please try again...");
    } else return 0;
    return 1;
}

forward CallTimer911(playerid);
public CallTimer911(playerid) {
    if (!cPlayerData[playerid][isCalling]) return 0;
    cPlayerData[playerid][isCalling] = false;
    cPlayerData[playerid][cTimer] = -1;
    SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}we can understand your emegency, but all our operatives are busy. please try again...");
    return 1;
}

cmd:respond(playerid, const params[]) {
    if (!Faction:IsPlayerSigned(playerid)) return 0;
    new allowedFactions[] = { 0, 1, 2, 3, 4, 6, 11 };
    if (!IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid))) return 0;
    new targetId = -1;
    if (sscanf(params, "u", targetId)) return SyntaxMSG(playerid, "/respond [playerid]");
    if (targetId == playerid) return SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}call may have cancelled or end by caller");
    if (!IsPlayerConnected(targetId)) return SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}call may have cancelled or end by caller");
    if (!cPlayerData[targetId][isCalling]) return SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}call may have answered or end from the caller end");
    if (cPlayerData[targetId][callType] == 0) {
        new lawFactions[] = { 0, 1, 2, 3 };
        if (IsArrayContainNumber(lawFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
            DeletePreciseTimer(cPlayerData[targetId][cTimer]);
            cPlayerData[targetId][cTimer] = -1;
            cPlayerData[targetId][isCalling] = false;
            MobilePlayer[playerid][calling] = 1;
            MobilePlayer[playerid][caller] = targetId;
            MobilePlayer[targetId][calling] = 1;
            MobilePlayer[targetId][caller] = playerid;
            SendClientMessage(playerid, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(targetId)));
            SendClientMessage(targetId, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(playerid)));
        } else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}you are not authorised to respond this call");
    } else if (cPlayerData[targetId][callType] == 1) {
        if (Faction:GetPlayerFID(playerid) == 6 && Faction:IsPlayerSigned(playerid)) {
            DeletePreciseTimer(cPlayerData[targetId][cTimer]);
            cPlayerData[targetId][cTimer] = -1;
            cPlayerData[targetId][isCalling] = false;
            MobilePlayer[playerid][calling] = 1;
            MobilePlayer[playerid][caller] = targetId;
            MobilePlayer[targetId][calling] = 1;
            MobilePlayer[targetId][caller] = playerid;
            SendClientMessage(playerid, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(targetId)));
            SendClientMessage(targetId, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(playerid)));
        } else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}you are not authorised to respond this call");
    } else if (cPlayerData[targetId][callType] == 2) {
        if (Faction:GetPlayerFID(playerid) == 4 && Faction:IsPlayerSigned(playerid)) {
            DeletePreciseTimer(cPlayerData[targetId][cTimer]);
            cPlayerData[targetId][cTimer] = -1;
            cPlayerData[targetId][isCalling] = false;
            MobilePlayer[playerid][calling] = 1;
            MobilePlayer[playerid][caller] = targetId;
            MobilePlayer[targetId][calling] = 1;
            MobilePlayer[targetId][caller] = playerid;
            SendClientMessage(playerid, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(targetId)));
            SendClientMessage(targetId, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(playerid)));
        } else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}you are not authorised to respond this call");
    } else if (cPlayerData[targetId][callType] == 3) {
        if (Faction:GetPlayerFID(playerid) == 11 && Faction:IsPlayerSigned(playerid)) {
            DeletePreciseTimer(cPlayerData[targetId][cTimer]);
            cPlayerData[targetId][cTimer] = -1;
            cPlayerData[targetId][isCalling] = false;
            MobilePlayer[playerid][calling] = 1;
            MobilePlayer[playerid][caller] = targetId;
            MobilePlayer[targetId][calling] = 1;
            MobilePlayer[targetId][caller] = playerid;
            SendClientMessage(playerid, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(targetId)));
            SendClientMessage(targetId, -1, sprintf("{4286f4}[911]: {FFFFEE}your call has been connected with %s", GetPlayerNameEx(playerid)));
        } else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}you are not authorised to respond this call");
    } else SendClientMessage(playerid, -1, "{4286f4}[911]: {FFFFEE}you are not authorised to respond this call");
    return 1;
}