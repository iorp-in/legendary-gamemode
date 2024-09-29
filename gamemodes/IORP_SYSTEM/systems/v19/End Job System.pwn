new bool:playerJobStatus[MAX_PLAYERS];

stock SetPlayerJobStatus(playerid, bool:newstate) {
    return playerJobStatus[playerid] = newstate;
}

stock GetPlayerJobStatus(playerid) {
    return playerJobStatus[playerid];
}

hook OnPlayerConnect(playerid) {
    SetPlayerJobStatus(playerid, false);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (GetPlayerJobStatus(playerid)) EndJobCommand(playerid);
    return 1;
}

hook OnPlayerEventJoin(playerid, eventid) {
    if (GetPlayerJobStatus(playerid)) EndJobCommand(playerid);
    return 1;
}

hook OnPlayerJailed(playerid) {
    if (GetPlayerJobStatus(playerid)) EndJobCommand(playerid);
    return 1;
}

hook OnPlayerDeathSpawn(playerid) {
    if (GetPlayerJobStatus(playerid)) EndJobCommand(playerid);
    return 1;
}

stock EndJobCommand(playerid) {
    SetPlayerJobStatus(playerid, false);
    CallRemoteFunction("OnPlayerRequestEndJob", "d", playerid);
    return 1;
}

forward OnPlayerRequestEndJob(playerid);
public OnPlayerRequestEndJob(playerid) {
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (GetPlayerJobStatus(playerid)) UCP:AddCommand(playerid, "End job", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("End job", inputtext)) EndJobCommand(playerid);
    return 1;
}