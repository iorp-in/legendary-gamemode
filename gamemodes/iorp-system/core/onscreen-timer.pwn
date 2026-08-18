enum PlayerTimerEnum {
    PlayerText:osTtextdrawid,
    bool:osTisTimerOn,
    osTseconds,
    osTtimerid
}
new OnScreenTimer[MAX_PLAYERS][PlayerTimerEnum];

hook OnPlayerConnect(playerid) {
    new PlayerText:pText = CreatePlayerTextDraw(playerid, 70.000000, 300.000000, "Time Left: 00:00 Mins");
    PlayerTextDrawColor(playerid, PlayerText:pText, -1);
    PlayerTextDrawUseBox(playerid, PlayerText:pText, 1);
    PlayerTextDrawBoxColor(playerid, PlayerText:pText, 170);
    PlayerTextDrawBackgroundColor(playerid, PlayerText:pText, 255);
    PlayerTextDrawAlignment(playerid, PlayerText:pText, 2);
    PlayerTextDrawFont(playerid, PlayerText:pText, 1);
    PlayerTextDrawLetterSize(playerid, PlayerText:pText, 0.200000, 1.000000);
    PlayerTextDrawTextSize(playerid, PlayerText:pText, 0.000000, 100.000000);
    PlayerTextDrawSetOutline(playerid, PlayerText:pText, 0);
    PlayerTextDrawSetShadow(playerid, PlayerText:pText, 0);
    PlayerTextDrawSetProportional(playerid, PlayerText:pText, 1);
    PlayerTextDrawSetSelectable(playerid, PlayerText:pText, 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerText:pText, 400);
    PlayerTextDrawSetPreviewRot(playerid, PlayerText:pText, 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerText:pText, 0, 0);
    OnScreenTimer[playerid][osTtextdrawid] = pText;
    OnScreenTimer[playerid][osTisTimerOn] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    PlayerTextDrawDestroy(playerid, OnScreenTimer[playerid][osTtextdrawid]);
    if (IsScreenTimerOn(playerid)) StopScreenTimer(playerid, 0);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (IsScreenTimerOn(playerid)) StopScreenTimer(playerid, 0);
    return 1;
}

stock IsScreenTimerOn(playerid) {
    return OnScreenTimer[playerid][osTisTimerOn];
}

stock ShowScreenTimer(playerid) {
    PlayerTextDrawShow(playerid, OnScreenTimer[playerid][osTtextdrawid]);
    return 1;
}

stock HideScreenTimer(playerid) {
    PlayerTextDrawHide(playerid, OnScreenTimer[playerid][osTtextdrawid]);
    return 1;
}

forward StartScreenTimer(playerid, seconds);
public StartScreenTimer(playerid, seconds) {
    if (seconds < 1) return 0;
    DeletePreciseTimer(OnScreenTimer[playerid][osTtimerid]);
    OnScreenTimer[playerid][osTtimerid] = -1;
    OnScreenTimer[playerid][osTisTimerOn] = true;
    OnScreenTimer[playerid][osTseconds] = seconds;
    OnScreenTimer[playerid][osTtimerid] = SetPreciseTimer("UpdateScreenTimer", 1000, true, "d", playerid);
    PlayerTextDrawSetString(playerid, OnScreenTimer[playerid][osTtextdrawid], sprintf("Time Left: %s Seconds", secondsToHms(seconds, 1)));
    ShowScreenTimer(playerid);
    CallRemoteFunction("OnScreenTimerStarted", "dd", playerid, seconds);
    return 1;
}

forward UpdateScreenTimer(playerid);
public UpdateScreenTimer(playerid) {
    if (!IsScreenTimerOn(playerid)) return 1;
    if (OnScreenTimer[playerid][osTseconds] < 1) {
        StopScreenTimer(playerid, 1);
        return 1;
    }
    OnScreenTimer[playerid][osTseconds]--;
    PlayerTextDrawSetString(playerid, OnScreenTimer[playerid][osTtextdrawid], sprintf("Time Left: %s Seconds", secondsToHms(OnScreenTimer[playerid][osTseconds], 1)));
    CallRemoteFunction("OnScreenTimerTick", "dd", playerid, OnScreenTimer[playerid][osTseconds]);
    return 1;
}

forward StopScreenTimer(playerid, success);
public StopScreenTimer(playerid, success) {
    if (!IsScreenTimerOn(playerid)) return 1;
    HideScreenTimer(playerid);
    DeletePreciseTimer(OnScreenTimer[playerid][osTtimerid]);
    OnScreenTimer[playerid][osTtimerid] = -1;
    OnScreenTimer[playerid][osTisTimerOn] = false;
    CallRemoteFunction("OnScreenTimerFinished", "dd", playerid, success);
    return 1;
}

forward OnScreenTimerStarted(playerid, seconds);
public OnScreenTimerStarted(playerid, seconds) {
    // SendClientMessage(playerid, -1, sprintf("OnScreenTimerStarted(%d, %d)", playerid, seconds));
    return 1;
}

forward OnScreenTimerTick(playerid, seconds);
public OnScreenTimerTick(playerid, seconds) {
    // SendClientMessage(playerid, -1, sprintf("OnScreenTimerTick(%d, %d)", playerid, seconds));
    return 1;
}

forward OnScreenTimerFinished(playerid, success);
public OnScreenTimerFinished(playerid, success) {
    // SendClientMessage(playerid, -1, sprintf("OnScreenTimerFinished(%d)", playerid));
    return 1;
}

// cmd:testtimer(playerid, const params[]) {
//     if(!IsPlayerMasterAdmin(playerid)) return 0;
//     new seconds;
//     if(sscanf(params, "d", seconds)) return SendClientMessage(playerid, -1, "/testtimer [seconds]");
//     if(seconds < 1) return SendClientMessage(playerid, -1, "/testtimer [seconds]");
//     StopScreenTimer(playerid, 1);
//     StartScreenTimer(playerid, seconds);
//     return 1;
// }