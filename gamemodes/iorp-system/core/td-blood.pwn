new Text:Blood[9];

hook OnGameModeInit() {
    // Blood Effects
    Blood[0] = TextDrawCreate(86.666648, 121.814811, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[0], 0.000000, 0.000000);
    TextDrawTextSize(Blood[0], 24.000000, 34.000000);
    TextDrawAlignment(Blood[0], 1);
    TextDrawColor(Blood[0], -1);
    TextDrawSetShadow(Blood[0], 0);
    TextDrawSetOutline(Blood[0], 0);
    TextDrawBackgroundColor(Blood[0], 255);
    TextDrawFont(Blood[0], 4);
    TextDrawSetProportional(Blood[0], 0);
    TextDrawSetShadow(Blood[0], 0);

    Blood[1] = TextDrawCreate(477.333312, 246.674102, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[1], 0.000000, 0.000000);
    TextDrawTextSize(Blood[1], 36.000000, 41.000000);
    TextDrawAlignment(Blood[1], 1);
    TextDrawColor(Blood[1], -1);
    TextDrawSetShadow(Blood[1], 0);
    TextDrawSetOutline(Blood[1], 0);
    TextDrawBackgroundColor(Blood[1], 255);
    TextDrawFont(Blood[1], 4);
    TextDrawSetProportional(Blood[1], 0);
    TextDrawSetShadow(Blood[1], 0);

    Blood[2] = TextDrawCreate(24.000041, 249.992660, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[2], 0.000000, 0.000000);
    TextDrawTextSize(Blood[2], 70.000000, 57.000000);
    TextDrawAlignment(Blood[2], 1);
    TextDrawColor(Blood[2], -1);
    TextDrawSetShadow(Blood[2], 0);
    TextDrawSetOutline(Blood[2], 0);
    TextDrawBackgroundColor(Blood[2], 255);
    TextDrawFont(Blood[2], 4);
    TextDrawSetProportional(Blood[2], 0);
    TextDrawSetShadow(Blood[2], 0);

    Blood[3] = TextDrawCreate(546.333374, 323.414916, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[3], 0.000000, 0.000000);
    TextDrawTextSize(Blood[3], 70.000000, 57.000000);
    TextDrawAlignment(Blood[3], 1);
    TextDrawColor(Blood[3], -1);
    TextDrawSetShadow(Blood[3], 0);
    TextDrawSetOutline(Blood[3], 0);
    TextDrawBackgroundColor(Blood[3], 255);
    TextDrawFont(Blood[3], 4);
    TextDrawSetProportional(Blood[3], 0);
    TextDrawSetShadow(Blood[3], 0);

    Blood[4] = TextDrawCreate(276.666717, 340.007568, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[4], 0.000000, 0.000000);
    TextDrawTextSize(Blood[4], 70.000000, 57.000000);
    TextDrawAlignment(Blood[4], 1);
    TextDrawColor(Blood[4], -1);
    TextDrawSetShadow(Blood[4], 0);
    TextDrawSetOutline(Blood[4], 0);
    TextDrawBackgroundColor(Blood[4], 255);
    TextDrawFont(Blood[4], 4);
    TextDrawSetProportional(Blood[4], 0);
    TextDrawSetShadow(Blood[4], 0);

    Blood[5] = TextDrawCreate(442.666748, 12.718672, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[5], 0.000000, 0.000000);
    TextDrawTextSize(Blood[5], 17.000000, 25.000000);
    TextDrawAlignment(Blood[5], 1);
    TextDrawColor(Blood[5], -1);
    TextDrawSetShadow(Blood[5], 0);
    TextDrawSetOutline(Blood[5], 0);
    TextDrawBackgroundColor(Blood[5], 255);
    TextDrawFont(Blood[5], 4);
    TextDrawSetProportional(Blood[5], 0);
    TextDrawSetShadow(Blood[5], 0);

    Blood[6] = TextDrawCreate(201.666732, 16.866807, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[6], 0.000000, 0.000000);
    TextDrawTextSize(Blood[6], 48.000000, 49.000000);
    TextDrawAlignment(Blood[6], 1);
    TextDrawColor(Blood[6], -1);
    TextDrawSetShadow(Blood[6], 0);
    TextDrawSetOutline(Blood[6], 0);
    TextDrawBackgroundColor(Blood[6], 255);
    TextDrawFont(Blood[6], 4);
    TextDrawSetProportional(Blood[6], 0);
    TextDrawSetShadow(Blood[6], 0);

    Blood[7] = TextDrawCreate(117.000106, 148.777893, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[7], 0.000000, 0.000000);
    TextDrawTextSize(Blood[7], 127.000000, 70.000000);
    TextDrawAlignment(Blood[7], 1);
    TextDrawColor(Blood[7], -1);
    TextDrawSetShadow(Blood[7], 0);
    TextDrawSetOutline(Blood[7], 0);
    TextDrawBackgroundColor(Blood[7], 255);
    TextDrawFont(Blood[7], 4);
    TextDrawSetProportional(Blood[7], 0);
    TextDrawSetShadow(Blood[7], 0);

    Blood[8] = TextDrawCreate(428.666717, 118.911254, "particle:bloodpool_64");
    TextDrawLetterSize(Blood[8], 0.000000, 0.000000);
    TextDrawTextSize(Blood[8], 59.000000, 50.000000);
    TextDrawAlignment(Blood[8], 1);
    TextDrawColor(Blood[8], -1);
    TextDrawSetShadow(Blood[8], 0);
    TextDrawSetOutline(Blood[8], 0);
    TextDrawBackgroundColor(Blood[8], 255);
    TextDrawFont(Blood[8], 4);
    TextDrawSetProportional(Blood[8], 0);
    TextDrawSetShadow(Blood[8], 0);
    return 1;
}

stock BloodTextDraw:Show(playerid) {
    for (new i = 0; i < 9; i++) {
        TextDrawShowForPlayer(playerid, Blood[i]);
    }
    return 1;
}

stock BloodTextDraw:Hide(playerid) {
    for (new i = 0; i < 9; i++) {
        TextDrawHideForPlayer(playerid, Blood[i]);
    }
    return 1;
}

forward HideBloodTextDraw(playerid);
public HideBloodTextDraw(playerid) {
    BloodTextDraw:Hide(playerid);
    return 1;
}

stock BloodTextDraw:HideTimer(playerid, time = 2000) {
    SetPreciseTimer("HideBloodTextDraw", time, false, "d", playerid);
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {
    if (IsTimePassedForPlayer(playerid, "bloodTxT", 10)) {
        if (GetPlayerHealthEx(playerid) < 30) {
            BloodTextDraw:Show(playerid);
            BloodTextDraw:HideTimer(playerid, 2000);
        }
    }

    return 1;
}