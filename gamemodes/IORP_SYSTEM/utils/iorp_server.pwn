native IORP_ExecuteCallback(type, { Float, _ }:...);
native bool:IORP_IsUsingPlugin(playerid);
native TogglePlayerDriveOnWater(playerid, bool:toggle);
native IORP_Start();
native ToggleVoiceChat(playerid, bool:toggle);

new bool:StateSea[MAX_PLAYERS] = { false, ... };

cmd:seadrive(playerid, const params[]) {
    StateSea[playerid] = !StateSea[playerid];
    TogglePlayerDriveOnWater(playerid, StateSea[playerid]);
    SendClientMessage(playerid, -1, sprintf("Alexa: Sea Drive %s", StateSea[playerid] ? "Enabled" :"Disabled"));
    return 1;
}

cmd:voicechat(playerid, const params[]) {
    ToggleVoiceChat(playerid, true);
    ToggleVoiceChat(playerid, false);
    SendClientMessage(playerid, -1, "voice chat packet sent");
    return 1;
}

forward OnPlayerClick(playerid, type, X, Y);
forward OnKeyDown(playerid, key);
forward OnKeyUp(playerid, key);

hook OnGameModeInit() {
    print("starting iorp server v2");
    IORP_Start();
    return 1;
}

hook OnPlayerConnect(playerid) {
    IORP_ExecuteCallback(0, playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    IORP_ExecuteCallback(1, playerid);
    return 1;
}

public OnPlayerClick(playerid, type, X, Y) {
    // SendClientMessage(playerid, -1, sprintf("OnPlayerClick, type:%d, X:%d, Y:%d ", type, X, Y));
    return 1;
}

public OnKeyDown(playerid, key) {
    // SendClientMessage(playerid, -1, sprintf("OnKeyDown: %d", key));
    return 1;
}

public OnKeyUp(playerid, key) {
    // SendClientMessage(playerid, -1, sprintf("OnKeyUp: %d", key));
    return 1;
}