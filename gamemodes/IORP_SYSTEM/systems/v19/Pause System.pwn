enum E_PLAYER_PAUSED {
    E_PLAYER_PAUSED_LAST_TICKCOUNT,
    E_PLAYER_PAUSED_TIMER,
    bool:E_PLAYER_PAUSED_TOGGLE
};
static playerPauseData[MAX_PLAYERS][E_PLAYER_PAUSED];

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    playerPauseData[playerid][E_PLAYER_PAUSED_LAST_TICKCOUNT] = GetTickCount();
    playerPauseData[playerid][E_PLAYER_PAUSED_TIMER] = SetTimerEx("__OnPlayerPSYSTimerUpdate", 250, true, "i", playerid);
    playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE] = false;
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE]) {
        OnPlayerResume(playerid, (GetTickCount() - playerPauseData[playerid][E_PLAYER_PAUSED_LAST_TICKCOUNT]));
        playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE] = false;
        playerPauseData[playerid][E_PLAYER_PAUSED_TIMER] = SetTimerEx("__OnPlayerPSYSTimerUpdate", 250, true, "i", playerid);
    }
    playerPauseData[playerid][E_PLAYER_PAUSED_LAST_TICKCOUNT] = GetTickCount();
    return 1;
}

forward __OnPlayerPSYSTimerUpdate(playerid);
public __OnPlayerPSYSTimerUpdate(playerid) {
    new tick = GetTickCount();

    if ((tick - playerPauseData[playerid][E_PLAYER_PAUSED_LAST_TICKCOUNT]) >= 5000) { // if player hasn't updated in 5 seconds
        playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE] = true;
        OnPlayerPause(playerid);
        KillTimer(playerPauseData[playerid][E_PLAYER_PAUSED_TIMER]);
    }
}

stock IsPlayerPaused(playerid) {
    return (playerid < 0 || playerid >= MAX_PLAYERS) ? (true) : (playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE]);
}

stock GetPlayerPausedTime(playerid) {
    return ((playerid < 0 || playerid >= MAX_PLAYERS) || !playerPauseData[playerid][E_PLAYER_PAUSED_TOGGLE]) ? (0) : (GetTickCount() - playerPauseData[playerid][E_PLAYER_PAUSED_LAST_TICKCOUNT]);
}

forward OnPlayerPause(playerid);
public OnPlayerPause(playerid) {
    ScoreTimerDisable(playerid);
    return 1;
}

forward OnPlayerResume(playerid, pausedtime);
public OnPlayerResume(playerid, pausedtime) {
    SetPlayerPauseTime(playerid, GetPlayerPauseTime(playerid) + pausedtime);
    ScoreTimerEnable(playerid);
    GameTextForPlayer(playerid, sprintf("~w~Resume, paused time ~r~%02d:%02d:%02d", pausedtime / 3600000 % 60, pausedtime / 60000 % 60, pausedtime / 1000 % 60), 1500, 3);
    return 1;
}