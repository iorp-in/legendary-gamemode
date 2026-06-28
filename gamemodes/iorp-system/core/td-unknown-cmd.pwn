new Text:UnknownTD[4];

hook OnGameModeInit() {
    // Unknwon Command Error textdraw
    UnknownTD[0] = TextDrawCreate(26.000000, 260.000000, "Error:");
    TextDrawBackgroundColor(UnknownTD[0], 255);
    TextDrawFont(UnknownTD[0], 2);
    TextDrawLetterSize(UnknownTD[0], 0.159999, 1.000000);
    TextDrawColor(UnknownTD[0], 0x5ee4ffff);
    TextDrawSetOutline(UnknownTD[0], 0);
    TextDrawSetProportional(UnknownTD[0], 1);
    TextDrawSetShadow(UnknownTD[0], 1);
    TextDrawSetSelectable(UnknownTD[0], 0);

    UnknownTD[1] = TextDrawCreate(26.000000, 269.000000, "Unknown Command, please check /help");
    TextDrawBackgroundColor(UnknownTD[1], 255);
    TextDrawFont(UnknownTD[1], 2);
    TextDrawLetterSize(UnknownTD[1], 0.149999, 0.899999);
    TextDrawColor(UnknownTD[1], -1);
    TextDrawSetOutline(UnknownTD[1], 0);
    TextDrawSetProportional(UnknownTD[1], 1);
    TextDrawSetShadow(UnknownTD[1], 1);
    TextDrawSetSelectable(UnknownTD[1], 0);

    UnknownTD[2] = TextDrawCreate(167.000000, 261.000000, "New Textdraw");
    TextDrawBackgroundColor(UnknownTD[2], 255);
    TextDrawFont(UnknownTD[2], 1);
    TextDrawLetterSize(UnknownTD[2], 0.000000, 1.000000);
    TextDrawColor(UnknownTD[2], -1);
    TextDrawSetOutline(UnknownTD[2], 0);
    TextDrawSetProportional(UnknownTD[2], 1);
    TextDrawSetShadow(UnknownTD[2], 1);
    TextDrawUseBox(UnknownTD[2], 1);
    TextDrawBoxColor(UnknownTD[2], 96);
    TextDrawTextSize(UnknownTD[2], -3.000000, 0.000000);
    TextDrawSetSelectable(UnknownTD[2], 0);

    UnknownTD[3] = TextDrawCreate(7.000000, 258.000000, "?");
    TextDrawBackgroundColor(UnknownTD[3], 255);
    TextDrawFont(UnknownTD[3], 2);
    TextDrawLetterSize(UnknownTD[3], 0.620000, 2.499999);
    TextDrawColor(UnknownTD[3], -1);
    TextDrawSetOutline(UnknownTD[3], 0);
    TextDrawSetProportional(UnknownTD[3], 1);
    TextDrawSetShadow(UnknownTD[3], 1);
    TextDrawSetSelectable(UnknownTD[3], 0);

    return 1;
}

stock UnknownCommand:Show(playerid) {
    for (new i = 0; i < 4; i++) {
        TextDrawShowForPlayer(playerid, UnknownTD[i]);
    }
    return 1;
}

stock UnknownCommand:Hide(playerid) {
    for (new i = 0; i < 4; i++) {
        TextDrawHideForPlayer(playerid, UnknownTD[i]);
    }
    return 1;
}

forward HideUnknwownCommand(playerid);
public HideUnknwownCommand(playerid) {
    UnknownCommand:Hide(playerid);
    return 1;
}

stock UnknownCommand:HideTimer(playerid, time = 5000) {
    SetPreciseTimer("HideUnknwownCommand", time, false, "d", playerid);
    return 1;
}