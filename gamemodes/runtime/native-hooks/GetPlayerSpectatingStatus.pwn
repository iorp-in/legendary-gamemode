

new bool:SSNative_PlayerSpectatingStatus[MAX_PLAYERS];
stock bool:GetPlayerSpectatingStatus(playerid) {
    return SSNative_PlayerSpectatingStatus[playerid];
}

hook OnTogglePRSpectatingEx(playerid, bool:toggle) {
    SSNative_PlayerSpectatingStatus[playerid] = toggle;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    SSNative_PlayerSpectatingStatus[playerid] = false;
    return 1;
}