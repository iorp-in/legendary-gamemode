new bool:ScoreTimerStatus[MAX_PLAYERS];
new ExperiencePoint[MAX_PLAYERS];

new PlayerBar:scoreBar[MAX_PLAYERS], PlayerText:scoreTextdraw[MAX_PLAYERS][3];

stock CreateGUIScore(playerid) {
    scoreBar[playerid] = CreatePlayerProgressBar(playerid, 322.000000, 13.000000, 150.000000, 3.200000, 0x00BBFFFF, 100.0);

    scoreTextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 300.000000, 10.000000, "1");
    PlayerTextDrawColor(playerid, PlayerText:scoreTextdraw[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerText:scoreTextdraw[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerText:scoreTextdraw[playerid][0], 12320767);
    PlayerTextDrawBackgroundColor(playerid, PlayerText:scoreTextdraw[playerid][0], 255);
    PlayerTextDrawAlignment(playerid, PlayerText:scoreTextdraw[playerid][0], 2);
    PlayerTextDrawFont(playerid, PlayerText:scoreTextdraw[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, PlayerText:scoreTextdraw[playerid][0], 0.500000, 3.000000);
    PlayerTextDrawTextSize(playerid, PlayerText:scoreTextdraw[playerid][0], 30.000000, 30.000000);
    PlayerTextDrawSetOutline(playerid, PlayerText:scoreTextdraw[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, PlayerText:scoreTextdraw[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, PlayerText:scoreTextdraw[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerText:scoreTextdraw[playerid][0], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerText:scoreTextdraw[playerid][0], 400);
    PlayerTextDrawSetPreviewRot(playerid, PlayerText:scoreTextdraw[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerText:scoreTextdraw[playerid][0], 0, 0);

    scoreTextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 20.000000, "RANK 1");
    PlayerTextDrawColor(playerid, PlayerText:scoreTextdraw[playerid][1], 12320767);
    PlayerTextDrawUseBox(playerid, PlayerText:scoreTextdraw[playerid][1], 0);
    PlayerTextDrawBoxColor(playerid, PlayerText:scoreTextdraw[playerid][1], 255);
    PlayerTextDrawBackgroundColor(playerid, PlayerText:scoreTextdraw[playerid][1], 255);
    PlayerTextDrawAlignment(playerid, PlayerText:scoreTextdraw[playerid][1], 1);
    PlayerTextDrawFont(playerid, PlayerText:scoreTextdraw[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, PlayerText:scoreTextdraw[playerid][1], 0.500000, 1.000000);
    PlayerTextDrawTextSize(playerid, PlayerText:scoreTextdraw[playerid][1], 200.000000, 200.000000);
    PlayerTextDrawSetOutline(playerid, PlayerText:scoreTextdraw[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, PlayerText:scoreTextdraw[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, PlayerText:scoreTextdraw[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerText:scoreTextdraw[playerid][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerText:scoreTextdraw[playerid][1], 400);
    PlayerTextDrawSetPreviewRot(playerid, PlayerText:scoreTextdraw[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerText:scoreTextdraw[playerid][1], 0, 0);

    scoreTextdraw[playerid][2] = CreatePlayerTextDraw(playerid, 320.000000, 30.000000, "50/150");
    PlayerTextDrawColor(playerid, PlayerText:scoreTextdraw[playerid][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerText:scoreTextdraw[playerid][2], 0);
    PlayerTextDrawBoxColor(playerid, PlayerText:scoreTextdraw[playerid][2], 255);
    PlayerTextDrawBackgroundColor(playerid, PlayerText:scoreTextdraw[playerid][2], 255);
    PlayerTextDrawAlignment(playerid, PlayerText:scoreTextdraw[playerid][2], 1);
    PlayerTextDrawFont(playerid, PlayerText:scoreTextdraw[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, PlayerText:scoreTextdraw[playerid][2], 0.300000, 0.600000);
    PlayerTextDrawTextSize(playerid, PlayerText:scoreTextdraw[playerid][2], 2.000000, 3.599999);
    PlayerTextDrawSetOutline(playerid, PlayerText:scoreTextdraw[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, PlayerText:scoreTextdraw[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, PlayerText:scoreTextdraw[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerText:scoreTextdraw[playerid][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerText:scoreTextdraw[playerid][2], 400);
    PlayerTextDrawSetPreviewRot(playerid, PlayerText:scoreTextdraw[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerText:scoreTextdraw[playerid][2], 0, 0);
    return 1;
}

stock DestroyGUIScore(playerid) {
    DestroyPlayerProgressBar(playerid, PlayerBar:scoreBar[playerid]);
    PlayerTextDrawDestroy(playerid, PlayerText:scoreTextdraw[playerid][0]);
    PlayerTextDrawDestroy(playerid, PlayerText:scoreTextdraw[playerid][1]);
    PlayerTextDrawDestroy(playerid, PlayerText:scoreTextdraw[playerid][2]);
    return 1;
}

forward ShowGUIScore(playerid);
public ShowGUIScore(playerid) {
    ShowPlayerProgressBar(playerid, PlayerBar:scoreBar[playerid]);
    PlayerTextDrawShow(playerid, PlayerText:scoreTextdraw[playerid][0]);
    PlayerTextDrawShow(playerid, PlayerText:scoreTextdraw[playerid][1]);
    PlayerTextDrawShow(playerid, PlayerText:scoreTextdraw[playerid][2]);
    return 1;
}

forward HideGUIScore(playerid);
public HideGUIScore(playerid) {
    HidePlayerProgressBar(playerid, PlayerBar:scoreBar[playerid]);
    PlayerTextDrawHide(playerid, PlayerText:scoreTextdraw[playerid][0]);
    PlayerTextDrawHide(playerid, PlayerText:scoreTextdraw[playerid][1]);
    PlayerTextDrawHide(playerid, PlayerText:scoreTextdraw[playerid][2]);
    return 1;
}

stock UpdateGUIScore(playerid) {
    new exp = GetExperiencePoint(playerid);
    new level = getLevel(exp);
    new currentLevelExp = getLevelExp(level - 1);
    new nextLevelExp = getLevelExp(level);
    new diff = nextLevelExp - currentLevelExp;
    new cExp = exp - currentLevelExp;
    SetPlayerProgressBarValue(playerid, PlayerBar:scoreBar[playerid], cExp * 100 / diff);
    PlayerTextDrawSetString(playerid, PlayerText:scoreTextdraw[playerid][0], sprintf("%d", level));
    PlayerTextDrawSetString(playerid, PlayerText:scoreTextdraw[playerid][1], sprintf("%s", GetLevelName(level)));
    PlayerTextDrawSetString(playerid, PlayerText:scoreTextdraw[playerid][2], sprintf("%d/%d", exp, nextLevelExp));
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "experiencePoint", "int", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    ScoreTimerStatus[playerid] = false;
    return 1;
}

forward scoresystem(playerid);
public scoresystem(playerid) {
    if (GetScoreTimerStatus(playerid) && IsPlayerLoggedIn(playerid)) SetPlayerPlayedTime(playerid, GetPlayerPlayedTime(playerid) + 1);
    // SetPlayerScoreEx(playerid, getLevel(GetExperiencePoint(playerid)));
    SetPlayerScoreEx(playerid, CalculateScore(GetPlayerPlayedTime(playerid)));
    UpdateGUIScore(playerid);
    return 1;
}

stock GetScoreTimerStatus(playerid) {
    return ScoreTimerStatus[playerid];
}

stock ScoreTimerDisable(playerid) {
    ScoreTimerStatus[playerid] = false;
    return 1;
}

stock ScoreTimerEnable(playerid) {
    ScoreTimerStatus[playerid] = true;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    KillTimer(GetPlayerScoreTimerID(playerid));
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(ExperiencePoint[playerid], GetPlayerNameEx(playerid), "username", "experiencePoint");
    DestroyGUIScore(playerid);
    return 1;
}

hook OnPlayerLogin(playerid) {
    SetPlayerScoreEx(playerid, CalculateScore(GetPlayerPlayedTime(playerid)));
    ExperiencePoint[playerid] = Database:GetInt(GetPlayerNameEx(playerid), "username", "experiencePoint");
    CreateGUIScore(playerid);
    UpdateGUIScore(playerid);
    return 1;
}

stock GetExperiencePoint(playerid) {
    return ExperiencePoint[playerid];
}

stock GiveExperiencePoint(playerid, experiencepoint, bool:announce = true) {
    ExperiencePoint[playerid] += experiencepoint;
    if (announce) GameTextForPlayer(playerid, sprintf("~w~%s%d ~r~exp", (experiencepoint > 0) ? "+" : "-", experiencepoint), 200, 3);
    UpdateGUIScore(playerid);
    ShowGUIScore(playerid);
    SetPreciseTimer("HideGUIScore", 5 * 1000, false, "d", playerid);
    return ExperiencePoint[playerid];
}

stock SetExperiencePoint(playerid, experiencepoint) {
    ExperiencePoint[playerid] = experiencepoint;
    UpdateGUIScore(playerid);
    return ExperiencePoint[playerid];
}

stock CalculateScore(timeInSeconds = 0) {
    new seconds = timeInSeconds, minutes = 0, hours = 0, days = 0;
    while (seconds > 59) {
        seconds -= 60;
        minutes++;
    }
    while (minutes > 59) {
        minutes -= 60;
        hours++;
    }
    while (hours > 23) {
        hours -= 24;
        days++;
    }
    return days * 24 + hours;
}

stock getLevel(exp) {
    new i = 0, t1 = 0, t2 = 50, nextTerm = 0;
    while (nextTerm <= exp) {
        nextTerm = t1 + t2;
        t1 = t2;
        t2 = nextTerm;
        i++;
    }
    return i;
}

stock getLevelExp(level) {
    if (level <= 0) return 0;
    new i = 0, t1 = 0, t2 = 50, nextTerm = 0;
    while (i <= level) {
        nextTerm = t1 + t2;
        t1 = t2;
        t2 = nextTerm;
        i++;
    }
    return t1;
}

stock GetLevelName(level) {
    new string[50];
    format(string, sizeof string, "Untrained");
    if (level < 0) format(string, sizeof string, "Untrained");
    else if (level == 0 || level == 1) format(string, sizeof string, "Untrained");
    else if (level == 2) format(string, sizeof string, "Rookie");
    else if (level == 3) format(string, sizeof string, "Trainee");
    else if (level == 4) format(string, sizeof string, "Amature");
    else if (level == 5) format(string, sizeof string, "Bolt");
    else if (level == 6) format(string, sizeof string, "Hero");
    else if (level == 7) format(string, sizeof string, "Pro");
    else if (level == 8) format(string, sizeof string, "Crown");
    else if (level == 9) format(string, sizeof string, "Master");
    else if (level == 10) format(string, sizeof string, "Champion");
    else if (level >= 11) format(string, sizeof string, "Legendary");
    return string;
}