

new SSN_Player_Skin[MAX_PLAYERS];
forward OnPlayerSkinChange(playerid, newskin, oldskin);
public OnPlayerSkinChange(playerid, newskin, oldskin) {
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    new skin = GetPlayerSkin(playerid);
    if(skin != SSN_Player_Skin[playerid]) CallRemoteFunction("OnPlayerSkinChange", "udd", playerid, skin, SSN_Player_Skin[playerid]);
    SSN_Player_Skin[playerid] = skin;
    return 1;
}

hook OnPlayerSpawn(playerid) {
    SSN_Player_Skin[playerid] = GetPlayerSkin(playerid);
    return 1;
}

hook OnPlayerLogin(playerid) {
    SSN_Player_Skin[playerid] = GetPlayerAutoSpawn(playerid);
    return 1;
}