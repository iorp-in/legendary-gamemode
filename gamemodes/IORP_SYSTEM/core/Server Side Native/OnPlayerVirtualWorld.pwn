

new vwc_player_vw[MAX_PLAYERS];

forward OnPlayerVirtualWorld(playerid, newvirtualworld, oldvirtualworld);
public OnPlayerVirtualWorld(playerid, newvirtualworld, oldvirtualworld) {
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    new vw = GetPlayerVirtualWorld(playerid);
    if(vw != vwc_player_vw[playerid]) CallRemoteFunction("OnPlayerVirtualWorld", "udd", playerid, vw, vwc_player_vw[playerid]);
    vwc_player_vw[playerid] = vw;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    vwc_player_vw[playerid] = 0;
    return 1;
}