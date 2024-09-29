new bool:IsPlayerAndroidState[MAX_PLAYERS];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "IsAndroidPlayer", "boolean", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    IsPlayerAndroidState[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", "IsAndroidPlayer");
    return 1;
}

stock IsAndroidPlayer(playerid) {
    return IsPlayerAndroidState[playerid];
}

forward OnAndroidModeEnabled(playerid);
public OnAndroidModeEnabled(playerid) {
    return 1;
}

forward OnAndroidModeDisabled(playerid);
public OnAndroidModeDisabled(playerid) {
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "enable android mode, disable android mode")) {
        if (IsPlayerAndroidState[playerid]) {
            IsPlayerAndroidState[playerid] = false;
            Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "IsAndroidPlayer");
            CallRemoteFunction("OnAndroidModeDisabled", "d", playerid);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}android mode disabled for you, remember use this command again to switch back.");
        } else {
            IsPlayerAndroidState[playerid] = true;
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "IsAndroidPlayer");
            CallRemoteFunction("OnAndroidModeEnabled", "d", playerid);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}android mode enabled for you, remember use this command again to switch back.");
        }
        return ~1;
    }
    return 1;
}