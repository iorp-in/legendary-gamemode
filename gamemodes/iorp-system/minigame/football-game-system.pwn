new fbs_ball, fbs_goals1, fbs_goals2, fbs_gol, fbs_shooter, fbs_gameTimer, fbs_footballTeam[MAX_PLAYERS];
new bool:fbs_footbalOn, fbs_animation[200], fbs_isAnimating[MAX_PLAYERS], fbs_gPlayerUsingLoopingAnim[MAX_PLAYERS];
new fbs_PlayerDataSkin[MAX_PLAYERS];
new Float:fbs_PlayerData[MAX_PLAYERS][4];

hook OnGameModeInit() {
    //========================= [football stadium] =============================
    new white[48], grass[10], pillar[8];
    white[0] = CreateDynamicObject(9339, 1384.6, 2125.3, 9.33, 0, 0, 0);
    white[1] = CreateDynamicObject(9339, 1384.6, 2151.3999, 9.33, 0, 0, 0);
    white[2] = CreateDynamicObject(9339, 1384.6, 2174.3999, 9.33, 0, 0, 0);
    white[3] = CreateDynamicObject(9339, 1311.4, 2125.3, 9.33, 0, 0, 0);
    white[4] = CreateDynamicObject(9339, 1311.4, 2148.3999, 9.33, 0, 0, 0);
    white[5] = CreateDynamicObject(9339, 1311.4, 2174.3999, 9.33, 0, 0, 0);
    white[6] = CreateDynamicObject(9339, 1371.7002, 2187.2998, 9.3299999, 0, 0, 90);
    white[7] = CreateDynamicObject(9339, 1350.4, 2187.3, 9.33, 0, 0, 90);
    white[8] = CreateDynamicObject(9339, 1324.3, 2187.3, 9.33, 0, 0, 90);
    white[9] = CreateDynamicObject(9339, 1371.7, 2112.3, 9.33, 0, 0, 90);
    white[10] = CreateDynamicObject(9339, 1345.7, 2112.3, 9.33, 0, 0, 90);
    white[11] = CreateDynamicObject(9339, 1324.4, 2112.3, 9.33, 0, 0, 90);
    white[12] = CreateDynamicObject(9339, 1324.5, 2149.6001, 9.33, 0, 0, 90);
    white[13] = CreateDynamicObject(9339, 1350.6, 2149.6001, 9.33, 0, 0, 90);
    white[14] = CreateDynamicObject(9339, 1371.6, 2149.6001, 9.33, 0, 0, 90);
    white[15] = CreateDynamicObject(16501, 1338.2998, 2115.7998, 7.8260002, 0, 0, 0);
    white[16] = CreateDynamicObject(16501, 1358, 2115.7998, 7.8249998, 0, 0, 0);
    white[17] = CreateDynamicObject(16501, 1341.7998, 2119.25, 7.8260002, 0, 0, 90);
    white[18] = CreateDynamicObject(16501, 1348.9004, 2119.25, 7.8260002, 0, 0, 90);
    white[19] = CreateDynamicObject(16501, 1354.5, 2119.25, 7.8260002, 0, 0, 90);
    white[20] = CreateDynamicObject(16501, 1369.2998, 2115.7998, 7.8249998, 0, 0, 0);
    white[21] = CreateDynamicObject(16501, 1369.2998, 2122.75, 7.8249998, 0, 0, 0);
    white[22] = CreateDynamicObject(16501, 1365.7002, 2126.2002, 7.8249998, 0, 0, 90);
    white[23] = CreateDynamicObject(16501, 1358.5996, 2126.2002, 7.8249998, 0, 0, 90);
    white[24] = CreateDynamicObject(16501, 1351.5, 2126.2002, 7.8249998, 0, 0, 90);
    white[25] = CreateDynamicObject(16501, 1344.5, 2126.2002, 7.8260002, 0, 0, 90);
    white[26] = CreateDynamicObject(16501, 1337.4004, 2126.2002, 7.8260002, 0, 0, 90);
    white[27] = CreateDynamicObject(16501, 1330.4004, 2126.2002, 7.8260002, 0, 0, 90);
    white[28] = CreateDynamicObject(16501, 1326.9404, 2122.7002, 7.8260002, 0, 0, 0);
    white[29] = CreateDynamicObject(16501, 1326.9404, 2115.7998, 7.8260002, 0, 0, 0);
    white[30] = CreateDynamicObject(16501, 1338.3, 2183.8, 7.8260002, 0, 0, 0);
    white[31] = CreateDynamicObject(16501, 1358, 2183.8, 7.8260002, 0, 0, 0);
    white[32] = CreateDynamicObject(16501, 1354.5, 2180.3501, 7.8260002, 0, 0, 90);
    white[33] = CreateDynamicObject(16501, 1347.4, 2180.3501, 7.8260002, 0, 0, 90);
    white[34] = CreateDynamicObject(16501, 1341.8, 2180.3501, 7.8260002, 0, 0, 90);
    white[35] = CreateDynamicObject(16501, 1326.9399, 2183.8999, 7.8260002, 0, 0, 0);
    white[36] = CreateDynamicObject(16501, 1326.9399, 2176.8999, 7.8260002, 0, 0, 0);
    white[37] = CreateDynamicObject(16501, 1330.4, 2173.3999, 7.8260002, 0, 0, 90);
    white[38] = CreateDynamicObject(16501, 1337.5, 2173.3999, 7.8260002, 0, 0, 90);
    white[39] = CreateDynamicObject(16501, 1344.6, 2173.3999, 7.8260002, 0, 0, 90);
    white[40] = CreateDynamicObject(16501, 1351.7, 2173.3999, 7.8260002, 0, 0, 90);
    white[41] = CreateDynamicObject(16501, 1358.8, 2173.3999, 7.8260002, 0, 0, 90);
    white[42] = CreateDynamicObject(16501, 1369.3, 2183.8, 7.8260002, 0, 0, 0);
    white[43] = CreateDynamicObject(16501, 1369.3, 2176.8701, 7.8260002, 0, 0, 0);
    white[44] = CreateDynamicObject(16501, 1365.8, 2173.3999, 7.8260002, 0, 0, 90);
    white[45] = CreateDynamicObject(18808, 1348.5, 2149.7, -14.96, 0, 0, 0);
    white[46] = CreateDynamicObject(18808, 1348.1, 2124.6001, -15, 1, 0, 0);
    white[47] = CreateDynamicObject(18808, 1349.1, 2175, -15, 359, 0, 0);
    for (new i = 0; i < sizeof(white); i++) { SetDynamicObjectMaterial(white[i], 0, 3924, "rc_warhoose", "white", 0xFFFFFFFF); }
    SetDynamicObjectMaterial(white[46], 1, 3924, "rc_warhoose", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(white[47], 1, 3924, "rc_warhoose", "white", 0xFFFFFFFF);
    grass[0] = CreateDynamicObject(4708, 1373.4, 2120.8999, -7.8629999, 0, 0, 0);
    grass[1] = CreateDynamicObject(4708, 1322.3, 2126.2998, -7.8639998, 0, 0, 0);
    grass[2] = CreateDynamicObject(4708, 1322.3, 2120.8999, -7.8610001, 0, 0, 0);
    grass[3] = CreateDynamicObject(4708, 1373.4, 2149.7, -7.8629999, 0, 0, 0);
    grass[4] = CreateDynamicObject(4708, 1339, 2148.3999, -7.8639998, 0, 0, 0);
    grass[5] = CreateDynamicObject(4708, 1322.3, 2149.7, -7.8610001, 0, 0, 0);
    grass[6] = CreateDynamicObject(4708, 1339, 2177.2, -7.8639998, 0, 0, 0);
    grass[7] = CreateDynamicObject(4708, 1373.4, 2177.2, -7.8610001, 0, 0, 0);
    grass[8] = CreateDynamicObject(4708, 1339, 2120.8999, -7.862, 0, 0, 0);
    grass[9] = CreateDynamicObject(4708, 1322.3, 2177.2, -7.862, 0, 0, 0);
    for (new i = 0; i < sizeof(grass); i++) {
        SetDynamicObjectMaterial(grass[i], 5, 10931, "traingen_sfse", "desgreengrass", 0xFFFFFFFF);
        SetDynamicObjectMaterial(grass[i], 9, 10931, "traingen_sfse", "desgreengrass", 0xFFFFFFFF);
    }
    pillar[0] = CreateDynamicObject(1251, 1350.1, 2187.3999, 13.302, 0, 0, 90);
    pillar[1] = CreateDynamicObject(1251, 1347.4, 2187.3999, 13.3, 0, 0, 90);
    pillar[2] = CreateDynamicObject(1251, 1344, 2187.3999, 9.8999996, 90, 0, 0);
    pillar[3] = CreateDynamicObject(1251, 1353.5, 2187.3, 9.8999996, 90, 0, 0);
    pillar[4] = CreateDynamicObject(1251, 1344, 2112.3, 9.8999996, 90, 0, 0);
    pillar[5] = CreateDynamicObject(1251, 1353.7, 2112.3999, 9.8999996, 90, 0, 0);
    pillar[6] = CreateDynamicObject(1251, 1347.4, 2112.3, 13.302, 0, 0, 90);
    pillar[7] = CreateDynamicObject(1251, 1350.3, 2112.3101, 13.302, 0, 0, 90);
    for (new i = 0; i < sizeof(pillar); i++) { SetDynamicObjectMaterial(pillar[i], 0, 3924, "rc_warhoose", "white", 0xFFFFFFFF); }
    CreateDynamicObject(2945, 1344, 2189.5, 11.4, 0, 0, 90);
    CreateDynamicObject(2945, 1353.5, 2189.5, 11.4, 0, 0, 90);
    CreateDynamicObject(2945, 1351.8, 2191.1001, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1349.6, 2191.1001, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1346.0996, 2191.1006, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1345.3, 2189.5, 13.3, 90, 0, 90);
    CreateDynamicObject(2945, 1348.6, 2189.5, 13.3, 90, 0, 90);
    CreateDynamicObject(2945, 1351.5996, 2189.5, 13.3, 90, 0, 90);
    CreateDynamicObject(2945, 1353.7, 2110.7, 11.4, 0, 0, 90);
    CreateDynamicObject(2945, 1344, 2110.7, 11.4, 0, 0, 90);
    CreateDynamicObject(2945, 1352, 2108.6001, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1349.8, 2108.6001, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1346.1, 2108.6001, 11.4, 0, 0, 0);
    CreateDynamicObject(2945, 1351.8, 2110.7, 13.3, 90, 0, 90);
    CreateDynamicObject(2945, 1345.3, 2110.7, 13.3, 90, 0, 90);
    CreateDynamicObject(2945, 1348.54, 2110.7, 13.3, 90, 0, 90);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    fbs_footballTeam[playerid] = 0;
    fbs_isAnimating[playerid] = 0;
    fbs_gPlayerUsingLoopingAnim[playerid] = 0;
    return 1;
}

hook OnPlayerSpawn(playerid) {
    fbs_isAnimating[playerid] = 0;
    if (fbs_gPlayerUsingLoopingAnim[playerid]) fbs_gPlayerUsingLoopingAnim[playerid] = 0;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    fbs_isAnimating[playerid] = 0;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (fbs_footballTeam[playerid] == 2 || fbs_footballTeam[playerid] == 1) {
        new Float:x, Float:y, Float:z;
        GetDynamicObjectPos(fbs_ball, x, y, z);
        if (newkeys & KEY_FIRE) {
            if (IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z)) {
                GetPlayerPos(playerid, x, y, z);
                GetXYInFrontOfPlayer(playerid, x, y, 8.0);
                MoveDynamicObject(fbs_ball, x, y, 10.2, 8.0, 0, 0, 0);
                fbs_shooter = playerid;
                LoopingAnim(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 1, 1, 0, 0);
                SetTimerEx("FootballAnimation", 1000, false, "d", playerid);
                return ~1;
            }
        }
    }
    return 1;
}

forward FootballAnimation(playerid);
public FootballAnimation(playerid) {
    if (fbs_isAnimating[playerid] == 1) return SendClientMessageEx(playerid, -1, "You can't stop fbs_animation!");
    StopLoopingAnim(playerid);
    return 1;
}

forward GoalCount();
public GoalCount() {
    foreach(new i: Player) {
        if (fbs_footballTeam[i] == 1 || fbs_footballTeam[i] == 2) {
            SetPlayerHealth(i, 99.0);
        }
    }
    if (IsObjectInTheArea(fbs_ball, 1343.9974, 2108.0566, 1353.3119, 2112.6431)) {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(fbs_shooter, name, MAX_PLAYER_NAME);
        fbs_goals1++;
        if (fbs_footballTeam[fbs_shooter] == 1) {
            FootballMessage(sprintf("{4286f4}[Football]: {F81414}AUTOGOL! |{FFFFFF} Player %s (team 1) scored an own goal! |{FF0000} Team 1: %d, Team 2: %d", name, fbs_goals2, fbs_goals1));
        } else {
            FootballMessage(sprintf("{4286f4}[Football]: {F81414}GOOOOOL! |{FFFFFF} Player %s (team 2) scored a goal! |{FFFF00} Team 1: %d, Team 2: %d", name, fbs_goals2, fbs_goals1));
        }
        foreach(new i: Player) {
            if (fbs_footballTeam[i] == 1) {
                SetPlayerPosEx(i, 1348.9005, 2115.8665, 11.0364);
                SetPlayerInteriorEx(i, 0);
            } else if (fbs_footballTeam[i] == 2) {
                SetPlayerPosEx(i, 1348.7242, 2184.3674, 11.0344);
                SetPlayerFacingAngle(i, 180);
                SetPlayerInteriorEx(i, 0);
            }
        }
        DestroyDynamicObjectEx(fbs_ball);
        fbs_ball = CreateDynamicObject(2114, 1348.4065, 2149.4966, 10.2, 0, 0, 0);
        SetDynamicObjectMaterial(fbs_ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
    } else if (IsObjectInTheArea(fbs_ball, 1343.9312, 2186.9382, 1353.5435, 2191.6492)) {
        new name[MAX_PLAYER_NAME];
        GetPlayerName(fbs_shooter, name, MAX_PLAYER_NAME);
        fbs_goals2++;
        if (fbs_footballTeam[fbs_shooter] == 2) {
            FootballMessage(sprintf("{4286f4}[Football]: {F81414}OWNGOOOAL! |{FFFFFF} Player %s (team 2) scored and own goal! |{FF0000} Team 1: %d, Team 2: %d", name, fbs_goals2, fbs_goals1));
        } else {
            FootballMessage(sprintf("{4286f4}[Football]: {F81414}GOOOOAL! |{FFFFFF} Player %s (team 1) scored a goal! |{FFFF00} Team 1: %d, Team 2: %d", name, fbs_goals2, fbs_goals1));
        }
        foreach(new i: Player) {
            if (fbs_footballTeam[i] == 1) {
                SetPlayerPosEx(i, 1348.9005, 2115.8665, 11.0364);
                SetPlayerInteriorEx(i, 0);
            } else if (fbs_footballTeam[i] == 2) {
                SetPlayerPosEx(i, 1348.7242, 2184.3674, 11.0344);
                SetPlayerFacingAngle(i, 180);
                SetPlayerInteriorEx(i, 0);
            }
        }
        DestroyDynamicObjectEx(fbs_ball);
        fbs_ball = CreateDynamicObject(2114, 1348.4065, 2149.4966, 10.2, 0, 0, 0);
        SetDynamicObjectMaterial(fbs_ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
    } else if (!IsObjectInTheArea(fbs_ball, 1311.3945, 2112.2881, 1384.5884, 2187.2483)) {
        DestroyDynamicObjectEx(fbs_ball);
        fbs_ball = CreateDynamicObject(2114, 1348.4065, 2149.4966, 10.2, 0, 0, 0);
        SetDynamicObjectMaterial(fbs_ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
    }
    return 1;
}

forward FootbalTime();
public FootbalTime() {
    new string[128];
    foreach(new i: Player) {
        if (fbs_footballTeam[i] == 2 || fbs_footballTeam[i] == 1) {
            SetPlayerSkinEx(i, fbs_PlayerDataSkin[i]);
            SetPlayerFacingAngle(i, fbs_PlayerData[i][0]);
            SetPlayerPosEx(i, fbs_PlayerData[i][1], fbs_PlayerData[i][2], fbs_PlayerData[i][3]);
        }
        if (fbs_footballTeam[i] == 1) {
            format(string, sizeof string, "{4286f4}[Football]: {F81414}End of the game |{FFFFFF} You: %d | Them: %d", fbs_goals2, fbs_goals1);
            SendClientMessageEx(i, 0x00A2D7FF, string);
            fbs_footballTeam[i] = 0;
        } else if (fbs_footballTeam[i] == 2) {
            format(string, sizeof string, "{4286f4}[Football]: {F81414}End of the game |{FFFFFF} You: %d | Them: %d", fbs_goals1, fbs_goals2);
            SendClientMessageEx(i, 0x00A2D7FF, string);
            fbs_footballTeam[i] = 0;
        }
    }
    DestroyDynamicObjectEx(fbs_ball);
    fbs_footbalOn = false;
    fbs_goals1 = 0;
    fbs_goals2 = 0;
    DeletePreciseTimer(fbs_gol);
    return 1;
}

stock FootballMessage(const string[]) {
    foreach(new i: Player) {
        if (fbs_footballTeam[i] == 1 || fbs_footballTeam[i] == 2) {
            SendClientMessageEx(i, -1, string);
        }
    }
    return 1;
}

stock IsObjectInTheArea(objectid, Float:minx, Float:miny, Float:maxx, Float:maxy) {
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(objectid, x, y, z);
    if (x >= minx && x <= maxx && y >= miny && y <= maxy) return true;
    else return false;
}

stock LoopingAnim(playerid, const animlib[], const animname[], Float:vSpeed, looping, lockx, locky, lockz, lp) {
    fbs_gPlayerUsingLoopingAnim[playerid] = 1;
    ApplyAnimation(playerid, animlib, animname, vSpeed, looping, lockx, locky, lockz, lp);
    fbs_animation[playerid]++;
    return 1;
}

stock StopLoopingAnim(playerid) {
    fbs_gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

stock ShowFootBallMenu(playerid) {
    if (GetPlayerScore(playerid) < 50) return AlexaMsg(playerid, "you need 50 score to play football.");
    new string[128];
    strcat(string, "Invite\n");
    strcat(string, "Start\n");
    strcat(string, "Stop\n");
    return FlexPlayerDialog(playerid, "FootballMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}Football", string, "Select", "Close");
}

FlexDialog:FootballMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Invite")) return FootballMenuInvite(playerid);
    if (IsStringSame(inputtext, "Start")) return FootballMenuStart(playerid);
    if (IsStringSame(inputtext, "Stop")) {
        if (!fbs_footbalOn) {
            AlexaMsg(playerid, "football match is already off");
            return ShowFootBallMenu(playerid);
        }
        FootballMessage(sprintf("{4286f4}[Football]: {FFFFFF}Admin %s has stopped the game!", GetPlayerNameEx(playerid)));
        DeletePreciseTimer(fbs_gameTimer);
        FootbalTime();
        return 1;
    }
    return 1;
}

stock FootballMenuInvite(playerid) {
    return FlexPlayerDialog(playerid, "FootballMenuInvite", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFEE}Football", "Enter [playerid/name] [Team 1 - 2, 0 - kick]", "Submit", "Close");
}

FlexDialog:FootballMenuInvite(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowFootBallMenu(playerid);
    new friendid, team;
    if (sscanf(inputtext, "ud", friendid, team) || team < 0 || team > 2) return FootballMenuInvite(playerid);
    AlexaMsg(friendid, sprintf("{4286f4}[Football]: {FFFFFF}You have been called on game by  {ffffff}%s. | team %d", GetPlayerNameEx(playerid), team));
    AlexaMsg(playerid, sprintf("{4286f4}[Football]: {FFFFFF}You've called {ffffff}%s on football game. | Team {ffffff}%d", GetPlayerNameEx(friendid), team));
    fbs_footballTeam[friendid] = team;
    ResetPlayerWeaponsEx(friendid);
    fbs_PlayerDataSkin[friendid] = GetPlayerSkin(friendid);
    GetPlayerFacingAngle(friendid, fbs_PlayerData[friendid][0]);
    GetPlayerPos(friendid, fbs_PlayerData[friendid][1], fbs_PlayerData[friendid][2], fbs_PlayerData[friendid][3]);
    if (fbs_footbalOn) {
        if (fbs_footballTeam[friendid] == 1) {
            SetPlayerPosEx(friendid, 1348.9005, 2115.8665, 11.0364);
            SetPlayerInteriorEx(friendid, 0);
            SetPlayerSkinEx(friendid, 170);
        } else if (fbs_footballTeam[friendid] == 2) {
            SetPlayerPosEx(friendid, 1348.7242, 2184.3674, 11.0344);
            SetPlayerFacingAngle(friendid, 85);
            SetPlayerInteriorEx(friendid, 0);
            SetPlayerSkinEx(friendid, 250);
        }
    }
    return FootballMenuInvite(playerid);
}

stock FootballMenuStart(playerid) {
    return FlexPlayerDialog(playerid, "FootballMenuStart", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFEE}Football", "Enter [Time in minutes 1-20]", "Submit", "Close");
}

FlexDialog:FootballMenuStart(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowFootBallMenu(playerid);
    new time;
    if (sscanf(inputtext, "d", time) || time < 1 || time > 20) return FootballMenuStart(playerid);
    fbs_gameTimer = SetPreciseTimer("FootbalTime", time * 59999, false);
    fbs_gol = SetPreciseTimer("GoalCount", 499, true);
    foreach(new i: Player) {
        if (fbs_footballTeam[i] == 1) {
            SetPlayerPosEx(i, 1348.9005, 2115.8665, 11.0364);
            SetPlayerInteriorEx(i, 0);
            SetPlayerSkinEx(i, 170);
        } else if (fbs_footballTeam[i] == 2) {
            SetPlayerPosEx(i, 1348.7242, 2184.3674, 11.0344);
            SetPlayerFacingAngle(i, 180);
            SetPlayerInteriorEx(i, 0);
            SetPlayerSkinEx(i, 250);
        }
    }

    AlexaMsg(playerid, "football match started...");
    FootballMessage(sprintf("{4286f4}[Football]: {FFFFFF}Football game has started! | Started By: %s | Time: %d min", GetPlayerNameEx(playerid), time));
    fbs_ball = CreateDynamicObject(2114, 1348.4065, 2149.4966, 10.2, 0, 0, 0);
    SetDynamicObjectMaterial(fbs_ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
    fbs_footbalOn = true;
    return 1;
}