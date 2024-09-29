new Text:Spectate:playerInfoFrameTD[6];
new Text:Spectate:playerInfoTD[7];
new Text:Spectate:vehicleInfoFrameTD[2];
new Text:Spectate:vehicleInfoTD[4];

new PlayerText:Spectate:playerInfoPTD[MAX_PLAYERS][8];
new PlayerText:Spectate:vehicleInfoPTD[MAX_PLAYERS][5];

new Spectate:playerSpectateID[MAX_PLAYERS];
new bool:Spectate:playerSpectateTypeVehicle[MAX_PLAYERS];

new Iterator:Spectate_Players < MAX_PLAYERS > ;

new Spectate:playerVirtualWorld[MAX_PLAYERS];

new Spectate:oldPlayerVirtualWorld[MAX_PLAYERS];
new Spectate:oldPlayerInterior[MAX_PLAYERS];
new Float:Spectate:oldPlayerPosition[MAX_PLAYERS][4];
new Float:Spectate:oldPlayerHealth[MAX_PLAYERS];
new Float:Spectate:oldPlayerArmour[MAX_PLAYERS];

#define Spectate_BUTTON_PREVIOUS Spectate:playerInfoFrameTD[1]
#define Spectate_BUTTON_NEXT Spectate:playerInfoFrameTD[2]

Spectate:CreateTextDraws() {
    /*****************
     * PLAYER INFO FRAME
     *****************/
    Spectate:playerInfoFrameTD[0] = TextDrawCreate(218.0000, 330.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoFrameTD[0], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[0], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[0], 1094795775);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[0], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[0], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[0], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[0], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[0], 200.0000, 70.0000);

    Spectate:playerInfoFrameTD[1] = TextDrawCreate(219.0000, 331.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoFrameTD[1], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[1], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[1], 589505535);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[1], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[1], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[1], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[1], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[1], 30.0000, 68.0000);
    TextDrawSetSelectable(Spectate:playerInfoFrameTD[1], 1);

    Spectate:playerInfoFrameTD[2] = TextDrawCreate(387.0000, 331.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoFrameTD[2], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[2], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[2], 589505535);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[2], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[2], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[2], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[2], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[2], 30.0000, 68.0000);
    TextDrawSetSelectable(Spectate:playerInfoFrameTD[2], 1);

    Spectate:playerInfoFrameTD[3] = TextDrawCreate(250.0000, 331.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoFrameTD[3], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[3], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[3], 589505535);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[3], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[3], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[3], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[3], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[3], 136.0000, 68.0000);

    Spectate:playerInfoFrameTD[4] = TextDrawCreate(224.5000, 349.5000, "LD_BEAT:LEFT");
    TextDrawFont(Spectate:playerInfoFrameTD[4], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[4], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[4], 1684301055);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[4], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[4], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[4], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[4], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[4], 20.0000, 28.0000);

    Spectate:playerInfoFrameTD[5] = TextDrawCreate(393.5000, 349.5000, "LD_BEAT:RIGHT");
    TextDrawFont(Spectate:playerInfoFrameTD[5], 4);
    TextDrawLetterSize(Spectate:playerInfoFrameTD[5], 0.5000, 1.0000);
    TextDrawColor(Spectate:playerInfoFrameTD[5], 1684301055);
    TextDrawSetShadow(Spectate:playerInfoFrameTD[5], 0);
    TextDrawSetOutline(Spectate:playerInfoFrameTD[5], 0);
    TextDrawBackgroundColor(Spectate:playerInfoFrameTD[5], 255);
    TextDrawSetProportional(Spectate:playerInfoFrameTD[5], 1);
    TextDrawTextSize(Spectate:playerInfoFrameTD[5], 20.0000, 28.0000);

    /*****************
     * PLAYER INFO TEXTS
     *****************/
    Spectate:playerInfoTD[0] = TextDrawCreate(302.0000, 333.5000, "NOW SPECTATING:");
    TextDrawFont(Spectate:playerInfoTD[0], 1);
    TextDrawLetterSize(Spectate:playerInfoTD[0], 0.1399, 0.7999);
    TextDrawColor(Spectate:playerInfoTD[0], -1768515841);
    TextDrawSetShadow(Spectate:playerInfoTD[0], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[0], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[0], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[0], 1);
    TextDrawTextSize(Spectate:playerInfoTD[0], 640.0000, 0.0000);

    Spectate:playerInfoTD[1] = TextDrawCreate(252.0000, 333.5000, "PLAYER_MODEL");
    TextDrawFont(Spectate:playerInfoTD[1], 5);
    TextDrawLetterSize(Spectate:playerInfoTD[1], 0.2099, 1.1000);
    TextDrawColor(Spectate:playerInfoTD[1], -1768515841);
    TextDrawSetShadow(Spectate:playerInfoTD[1], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[1], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[1], 1684301055);
    TextDrawSetProportional(Spectate:playerInfoTD[1], 1);
    TextDrawTextSize(Spectate:playerInfoTD[1], 49.0000, 49.0000);
    TextDrawSetPreviewModel(Spectate:playerInfoTD[1], 0);
    TextDrawSetPreviewRot(Spectate:playerInfoTD[1], 0.0000, 0.0000, 0.0000, 1.0000);

    Spectate:playerInfoTD[2] = TextDrawCreate(252.0000, 392.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoTD[2], 4);
    TextDrawLetterSize(Spectate:playerInfoTD[2], 0.2099, 1.1000);
    TextDrawColor(Spectate:playerInfoTD[2], -1768515841);
    TextDrawSetShadow(Spectate:playerInfoTD[2], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[2], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[2], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[2], 1);
    TextDrawTextSize(Spectate:playerInfoTD[2], 64.0000, 3.0000);

    Spectate:playerInfoTD[3] = TextDrawCreate(252.0000, 392.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoTD[3], 4);
    TextDrawLetterSize(Spectate:playerInfoTD[3], 0.2099, 1.1000);
    TextDrawColor(Spectate:playerInfoTD[3], -16776961);
    TextDrawSetShadow(Spectate:playerInfoTD[3], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[3], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[3], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[3], 1);
    TextDrawTextSize(Spectate:playerInfoTD[3], 55.0000, 3.0000);

    Spectate:playerInfoTD[4] = TextDrawCreate(320.5000, 392.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoTD[4], 4);
    TextDrawLetterSize(Spectate:playerInfoTD[4], 0.2099, 1.1000);
    TextDrawColor(Spectate:playerInfoTD[4], -1768515841);
    TextDrawSetShadow(Spectate:playerInfoTD[4], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[4], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[4], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[4], 1);
    TextDrawTextSize(Spectate:playerInfoTD[4], 64.0000, 3.0000);

    Spectate:playerInfoTD[5] = TextDrawCreate(321.0000, 392.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:playerInfoTD[5], 4);
    TextDrawLetterSize(Spectate:playerInfoTD[5], 0.2099, 1.1000);
    TextDrawColor(Spectate:playerInfoTD[5], -1);
    TextDrawSetShadow(Spectate:playerInfoTD[5], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[5], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[5], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[5], 1);
    TextDrawTextSize(Spectate:playerInfoTD[5], 10.5000, 3.0000);

    Spectate:playerInfoTD[6] = TextDrawCreate(341.0000, 376.0000, "[maximum: 35.0 MPH]");
    TextDrawFont(Spectate:playerInfoTD[6], 1);
    TextDrawLetterSize(Spectate:playerInfoTD[6], 0.1199, 0.5999);
    TextDrawColor(Spectate:playerInfoTD[6], 1684301055);
    TextDrawSetShadow(Spectate:playerInfoTD[6], 0);
    TextDrawSetOutline(Spectate:playerInfoTD[6], 0);
    TextDrawBackgroundColor(Spectate:playerInfoTD[6], 255);
    TextDrawSetProportional(Spectate:playerInfoTD[6], 1);
    TextDrawTextSize(Spectate:playerInfoTD[6], 640.0000, 0.0000);

    /*****************
     * VEHICLE INFO FRAME
     *****************/
    Spectate:vehicleInfoFrameTD[0] = TextDrawCreate(218.0000, 403.5000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:vehicleInfoFrameTD[0], 4);
    TextDrawLetterSize(Spectate:vehicleInfoFrameTD[0], 0.5000, 1.0000);
    TextDrawColor(Spectate:vehicleInfoFrameTD[0], 1094795775);
    TextDrawSetShadow(Spectate:vehicleInfoFrameTD[0], 0);
    TextDrawSetOutline(Spectate:vehicleInfoFrameTD[0], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoFrameTD[0], 255);
    TextDrawSetProportional(Spectate:vehicleInfoFrameTD[0], 1);
    TextDrawTextSize(Spectate:vehicleInfoFrameTD[0], 200.0000, 32.0000);

    Spectate:vehicleInfoFrameTD[1] = TextDrawCreate(219.0000, 404.5000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:vehicleInfoFrameTD[1], 4);
    TextDrawLetterSize(Spectate:vehicleInfoFrameTD[1], 0.5000, 1.0000);
    TextDrawColor(Spectate:vehicleInfoFrameTD[1], 589505535);
    TextDrawSetShadow(Spectate:vehicleInfoFrameTD[1], 0);
    TextDrawSetOutline(Spectate:vehicleInfoFrameTD[1], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoFrameTD[1], 255);
    TextDrawSetProportional(Spectate:vehicleInfoFrameTD[1], 1);
    TextDrawTextSize(Spectate:vehicleInfoFrameTD[1], 198.0000, 30.0000);

    /*****************
     * VEHICLE INFO TEXTS
     *****************/
    Spectate:vehicleInfoTD[0] = TextDrawCreate(252.0000, 406.0000, "PLAYER VEHICLE INFO:");
    TextDrawFont(Spectate:vehicleInfoTD[0], 1);
    TextDrawLetterSize(Spectate:vehicleInfoTD[0], 0.1399, 0.7999);
    TextDrawColor(Spectate:vehicleInfoTD[0], -1768515841);
    TextDrawSetShadow(Spectate:vehicleInfoTD[0], 0);
    TextDrawSetOutline(Spectate:vehicleInfoTD[0], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoTD[0], 255);
    TextDrawSetProportional(Spectate:vehicleInfoTD[0], 1);
    TextDrawTextSize(Spectate:vehicleInfoTD[0], 640.0000, 0.0000);

    Spectate:vehicleInfoTD[1] = TextDrawCreate(220.5000, 406.5000, "PLAYER_MODEL");
    TextDrawFont(Spectate:vehicleInfoTD[1], 5);
    TextDrawLetterSize(Spectate:vehicleInfoTD[1], 0.2099, 1.1000);
    TextDrawColor(Spectate:vehicleInfoTD[1], -1);
    TextDrawSetShadow(Spectate:vehicleInfoTD[1], 0);
    TextDrawSetOutline(Spectate:vehicleInfoTD[1], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoTD[1], 842150655);
    TextDrawSetProportional(Spectate:vehicleInfoTD[1], 1);
    TextDrawTextSize(Spectate:vehicleInfoTD[1], 30.0000, 26.0000);
    TextDrawSetPreviewModel(Spectate:vehicleInfoTD[1], 456);
    TextDrawSetPreviewRot(Spectate:vehicleInfoTD[1], 0.0000, 0.0000, -50.0000, 1.0000);

    Spectate:vehicleInfoTD[2] = TextDrawCreate(320.5000, 429.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:vehicleInfoTD[2], 4);
    TextDrawLetterSize(Spectate:vehicleInfoTD[2], 0.2099, 1.1000);
    TextDrawColor(Spectate:vehicleInfoTD[2], -1768515841);
    TextDrawSetShadow(Spectate:vehicleInfoTD[2], 0);
    TextDrawSetOutline(Spectate:vehicleInfoTD[2], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoTD[2], 255);
    TextDrawSetProportional(Spectate:vehicleInfoTD[2], 1);
    TextDrawTextSize(Spectate:vehicleInfoTD[2], 94.5000, 3.0000);

    Spectate:vehicleInfoTD[3] = TextDrawCreate(320.5000, 429.0000, "LD_SPAC:WHITE");
    TextDrawFont(Spectate:vehicleInfoTD[3], 4);
    TextDrawLetterSize(Spectate:vehicleInfoTD[3], 0.2099, 1.1000);
    TextDrawColor(Spectate:vehicleInfoTD[3], -16776961);
    TextDrawSetShadow(Spectate:vehicleInfoTD[3], 0);
    TextDrawSetOutline(Spectate:vehicleInfoTD[3], 0);
    TextDrawBackgroundColor(Spectate:vehicleInfoTD[3], 255);
    TextDrawSetProportional(Spectate:vehicleInfoTD[3], 1);
    TextDrawTextSize(Spectate:vehicleInfoTD[3], 94.5000, 3.0000);
}

Spectate:CreatePlayerTD(playerid) {
    /*****************
     * PLAYER INFO TEXTS
     *****************/
    Spectate:playerInfoPTD[playerid][0] = CreatePlayerTextDraw(playerid, 302.0000, 340.0000, "username");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][0], 0.2399, 1.3000);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][0], -7601921);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][0], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][0], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][0], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][1] = CreatePlayerTextDraw(playerid, 302.0000, 351.0000, "ID: 13");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][1], 0.1199, 0.5999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][1], 1684301055);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][1], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][1], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][1], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][2] = CreatePlayerTextDraw(playerid, 251.5000, 384.0000, "HEALTH: ~w~80");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][2], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][2], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][2], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][2], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][2], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][3] = CreatePlayerTextDraw(playerid, 320.5000, 384.0000, "ARMOUR: ~w~10");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][3], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][3], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][3], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][3], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][3], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][3], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][4] = CreatePlayerTextDraw(playerid, 302.0000, 360.5000, "WEAPON: ~w~M4 (144)");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][4], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][4], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][4], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][4], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][4], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][4], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][5] = CreatePlayerTextDraw(playerid, 302.0000, 368.0000, "MONEY: ~g~$~w~99,242,221");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][5], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][5], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][5], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][5], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][5], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][5], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][5], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][5], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][6] = CreatePlayerTextDraw(playerid, 302.0000, 375.0000, "SPEED: ~w~0.2 mps");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][6], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][6], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][6], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][6], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][6], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][6], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][6], 640.0000, 0.0000);

    Spectate:playerInfoPTD[playerid][7] = CreatePlayerTextDraw(playerid, 384.0000, 333.5000, "1/15");
    PlayerTextDrawFont(playerid, Spectate:playerInfoPTD[playerid][7], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:playerInfoPTD[playerid][7], 0.1399, 0.7999);
    PlayerTextDrawAlignment(playerid, Spectate:playerInfoPTD[playerid][7], 3);
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][7], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:playerInfoPTD[playerid][7], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:playerInfoPTD[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:playerInfoPTD[playerid][7], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:playerInfoPTD[playerid][7], 1);
    PlayerTextDrawTextSize(playerid, Spectate:playerInfoPTD[playerid][7], 640.0000, 0.0000);

    /*****************
     * VEHICLE INFO TEXTS
     *****************/
    Spectate:vehicleInfoPTD[playerid][0] = CreatePlayerTextDraw(playerid, 251.5000, 412.0000, "Truck");
    PlayerTextDrawFont(playerid, Spectate:vehicleInfoPTD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:vehicleInfoPTD[playerid][0], 0.2399, 1.3000);
    PlayerTextDrawColor(playerid, Spectate:vehicleInfoPTD[playerid][0], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:vehicleInfoPTD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:vehicleInfoPTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:vehicleInfoPTD[playerid][0], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:vehicleInfoPTD[playerid][0], 1);
    PlayerTextDrawTextSize(playerid, Spectate:vehicleInfoPTD[playerid][0], 640.0000, 0.0000);

    Spectate:vehicleInfoPTD[playerid][1] = CreatePlayerTextDraw(playerid, 251.5000, 423.5000, "MODELID: 456");
    PlayerTextDrawFont(playerid, Spectate:vehicleInfoPTD[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:vehicleInfoPTD[playerid][1], 0.1199, 0.5999);
    PlayerTextDrawColor(playerid, Spectate:vehicleInfoPTD[playerid][1], 1684301055);
    PlayerTextDrawSetShadow(playerid, Spectate:vehicleInfoPTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:vehicleInfoPTD[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:vehicleInfoPTD[playerid][1], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:vehicleInfoPTD[playerid][1], 1);
    PlayerTextDrawTextSize(playerid, Spectate:vehicleInfoPTD[playerid][1], 640.0000, 0.0000);

    Spectate:vehicleInfoPTD[playerid][2] = CreatePlayerTextDraw(playerid, 320.5000, 421.0000, "HELATH: ~w~1000/1000");
    PlayerTextDrawFont(playerid, Spectate:vehicleInfoPTD[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:vehicleInfoPTD[playerid][2], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:vehicleInfoPTD[playerid][2], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:vehicleInfoPTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:vehicleInfoPTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:vehicleInfoPTD[playerid][2], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:vehicleInfoPTD[playerid][2], 1);
    PlayerTextDrawTextSize(playerid, Spectate:vehicleInfoPTD[playerid][2], 640.0000, 0.0000);

    Spectate:vehicleInfoPTD[playerid][3] = CreatePlayerTextDraw(playerid, 320.5000, 406.0000, "SPEED: ~w~60 kps");
    PlayerTextDrawFont(playerid, Spectate:vehicleInfoPTD[playerid][3], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:vehicleInfoPTD[playerid][3], 0.1399, 0.7999);
    PlayerTextDrawColor(playerid, Spectate:vehicleInfoPTD[playerid][3], -1768515841);
    PlayerTextDrawSetShadow(playerid, Spectate:vehicleInfoPTD[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:vehicleInfoPTD[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:vehicleInfoPTD[playerid][3], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:vehicleInfoPTD[playerid][3], 1);
    PlayerTextDrawTextSize(playerid, Spectate:vehicleInfoPTD[playerid][3], 640.0000, 0.0000);

    Spectate:vehicleInfoPTD[playerid][4] = CreatePlayerTextDraw(playerid, 320.5000, 413.5000, "[maximum: 120 kps]");
    PlayerTextDrawFont(playerid, Spectate:vehicleInfoPTD[playerid][4], 1);
    PlayerTextDrawLetterSize(playerid, Spectate:vehicleInfoPTD[playerid][4], 0.1199, 0.5999);
    PlayerTextDrawColor(playerid, Spectate:vehicleInfoPTD[playerid][4], 1684301055);
    PlayerTextDrawSetShadow(playerid, Spectate:vehicleInfoPTD[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, Spectate:vehicleInfoPTD[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, Spectate:vehicleInfoPTD[playerid][4], 255);
    PlayerTextDrawSetProportional(playerid, Spectate:vehicleInfoPTD[playerid][4], 1);
    PlayerTextDrawTextSize(playerid, Spectate:vehicleInfoPTD[playerid][4], 640.0000, 0.0000);
}


stock Spectate:ShowPlayerInfo(playerid, targetid) {
    TextDrawSetPreviewModel(Spectate:playerInfoTD[1], GetPlayerSkin(targetid));
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][0], GetPlayerNameEx(targetid));
    PlayerTextDrawColor(playerid, Spectate:playerInfoPTD[playerid][0], ((GetPlayerColor(targetid) & ~0xFF) | 0xFF));
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][1], sprintf("ID: %i", targetid));
    for (new i = 0; i < sizeof(Spectate:playerInfoPTD[]); i++) PlayerTextDrawShow(playerid, Spectate:playerInfoPTD[playerid][i]);
    for (new i = 0; i < sizeof(Spectate:playerInfoFrameTD); i++) TextDrawShowForPlayer(playerid, Spectate:playerInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:playerInfoTD); i++) TextDrawShowForPlayer(playerid, Spectate:playerInfoTD[i]);
    return 1;
}

stock Spectate:HidePlayerInfo(playerid) {
    for (new i = 0; i < sizeof(Spectate:playerInfoPTD[]); i++) PlayerTextDrawHide(playerid, Spectate:playerInfoPTD[playerid][i]);
    for (new i = 0; i < sizeof(Spectate:playerInfoFrameTD); i++) TextDrawHideForPlayer(playerid, Spectate:playerInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:playerInfoTD); i++) TextDrawHideForPlayer(playerid, Spectate:playerInfoTD[i]);
    return 1;
}

stock Spectate:UpdatePlayerInfo(playerid, targetid) {
    new Float:amount;
    GetPlayerHealth(targetid, amount);
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][2], sprintf("HEALTH: ~w~%i", floatround(amount)));
    TextDrawTextSize(Spectate:playerInfoTD[3], ((clamp(floatround(amount), 0, 100) / 100.0) * 64.0), 3.0000);
    TextDrawShowForPlayer(playerid, Spectate:playerInfoTD[3]);
    GetPlayerArmour(targetid, amount);
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][3], sprintf("ARMOUR: ~w~%i", floatround(amount)));
    TextDrawTextSize(Spectate:playerInfoTD[5], ((clamp(floatround(amount), 0, 100) / 100.0) * 64.0), 3.0000);
    TextDrawShowForPlayer(playerid, Spectate:playerInfoTD[5]);
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][4],
        sprintf("WEAPON: ~w~%s (%i)", GetWeaponNameEx(GetPlayerWeapon(targetid)), GetPlayerAmmo(targetid))
    );

    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][5], sprintf("MONEY: ~g~$~w~%s", FormatCurrency(GetPlayerMoney(targetid))));
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][6], sprintf("SPEED: ~w~%.0f KMPH", GetPlayerSpeed(targetid)));

    new index;
    foreach(new i:Spectate_Players) {
        ++index;
        if (i == targetid) break;
    }
    PlayerTextDrawSetString(playerid, Spectate:playerInfoPTD[playerid][7], sprintf("%i/%i", index, Iter_Count(Spectate_Players)));
    return 1;
}

stock Spectate:ShowVehicleInfo(playerid, vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 1;
    new modelid = GetVehicleModel(vehicleid);
    TextDrawSetPreviewModel(Spectate:vehicleInfoTD[1], modelid);
    PlayerTextDrawSetString(playerid, Spectate:vehicleInfoPTD[playerid][0], sprintf("%s", GetVehicleName(vehicleid)));
    PlayerTextDrawSetString(playerid, Spectate:vehicleInfoPTD[playerid][1], sprintf("MODELID: %i", GetVehicleModelName(modelid)));
    PlayerTextDrawSetString(playerid, Spectate:vehicleInfoPTD[playerid][4], sprintf("[maximum: %0.1f km/h]", GetVehicleModelTopSpeed(modelid)));
    for (new i = 0; i < sizeof(Spectate:vehicleInfoPTD[]); i++) PlayerTextDrawShow(playerid, Spectate:vehicleInfoPTD[playerid][i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoFrameTD); i++) TextDrawShowForPlayer(playerid, Spectate:vehicleInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoTD); i++) TextDrawShowForPlayer(playerid, Spectate:vehicleInfoTD[i]);
    return 1;
}

stock Spectate:HideVehicleInfo(playerid) {
    for (new i = 0; i < sizeof(Spectate:vehicleInfoPTD[]); i++) PlayerTextDrawHide(playerid, Spectate:vehicleInfoPTD[playerid][i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoFrameTD); i++) TextDrawHideForPlayer(playerid, Spectate:vehicleInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoTD); i++) TextDrawHideForPlayer(playerid, Spectate:vehicleInfoTD[i]);
    return 1;
}

stock Spectate:UpdateVehicleInfo(playerid, vehicleid) {
    new Float:amount;
    GetVehicleHealth(vehicleid, amount);
    PlayerTextDrawSetString(playerid, Spectate:vehicleInfoPTD[playerid][2], sprintf("HEALTH: ~w~%.0f/1000", amount));
    TextDrawTextSize(Spectate:vehicleInfoTD[3], ((clamp(floatround(amount), 0, 1000) / 1000.0) * 94.5), 3.0000);
    TextDrawShowForPlayer(playerid, Spectate:vehicleInfoTD[3]);
    PlayerTextDrawSetString(playerid, Spectate:vehicleInfoPTD[playerid][3], sprintf("SPEED: ~w~%0.1f KM/H", GetVehicleSpeed(vehicleid)));
    return 1;
}

stock Spectate:GetNextPlayer(current) {
    new next = INVALID_PLAYER_ID;
    if (Iter_Count(Spectate_Players) > 1) {
        if (Iter_Contains(Spectate_Players, current)) {
            next = Iter_Next(Spectate_Players, current);
            if (next == Iter_End(Spectate_Players)) {
                next = Iter_First(Spectate_Players);
            }
        }
    }
    return next;
}

stock Spectate:GetPreviousPlayer(current) {
    new prev = INVALID_PLAYER_ID;
    if (Iter_Count(Spectate_Players) > 1) {
        if (Iter_Contains(Spectate_Players, current)) {
            prev = Iter_Prev(Spectate_Players, current);
            if (prev == Iter_Begin(Spectate_Players)) {
                prev = Iter_Last(Spectate_Players);
            }
        }
    }
    return prev;
}

stock Spectate:StartSpectate(playerid, targetid) {
    if (playerid == targetid) return 1;
    TogglePlayerSpectatingEx(playerid, true);
    SetPlayerInteriorEx(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorld(targetid));
    new vehicleid = GetPlayerVehicleID(targetid);
    if (vehicleid != 0) {
        PlayerSpectateVehicle(playerid, vehicleid, SPECTATE_MODE_NORMAL);
        Spectate:ShowPlayerInfo(playerid, targetid);
        Spectate:ShowVehicleInfo(playerid, vehicleid);
    } else {
        PlayerSpectatePlayer(playerid, targetid, SPECTATE_MODE_NORMAL);
        Spectate:ShowPlayerInfo(playerid, targetid);
        Spectate:HideVehicleInfo(playerid);
    }
    Spectate:playerSpectateID[playerid] = targetid;
    Spectate:playerSpectateTypeVehicle[playerid] = (vehicleid != 0);
    return SelectTextDraw(playerid, 0xAA0000FF);
}

stock Spectate:StopSpectate(playerid) {
    TogglePlayerSpectatingEx(playerid, false);
    Spectate:HidePlayerInfo(playerid);
    Spectate:HideVehicleInfo(playerid);
    Spectate:playerSpectateID[playerid] = INVALID_PLAYER_ID;
    Spectate:playerSpectateTypeVehicle[playerid] = false;
    return CancelSelectTextDraw(playerid);
}

hook OnGameModeInit() {
    Spectate:CreateTextDraws();
    return 1;
}

hook OnGameModeExit() {
    for (new i = 0; i < sizeof(Spectate:playerInfoFrameTD); i++) TextDrawDestroy(Spectate:playerInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:playerInfoTD); i++) TextDrawDestroy(Spectate:playerInfoTD[i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoFrameTD); i++) TextDrawDestroy(Spectate:vehicleInfoFrameTD[i]);
    for (new i = 0; i < sizeof(Spectate:vehicleInfoTD); i++) TextDrawDestroy(Spectate:vehicleInfoTD[i]);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Spectate:playerSpectateID[playerid] = INVALID_PLAYER_ID;
    Spectate:playerSpectateTypeVehicle[playerid] = false;
    Spectate:CreatePlayerTD(playerid);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
        new vehicleid = GetPlayerVehicleID(playerid);
        foreach(new i:Player) {
            if (Spectate:playerSpectateID[i] == playerid) {
                PlayerSpectateVehicle(i, vehicleid, SPECTATE_MODE_NORMAL);
                Spectate:ShowVehicleInfo(i, vehicleid);
                Spectate:playerSpectateTypeVehicle[i] = true;
            }
        }
    } else if (newstate == PLAYER_STATE_ONFOOT) {
        foreach(new i:Player) {
            if (Spectate:playerSpectateID[i] == playerid) {
                PlayerSpectatePlayer(i, playerid, SPECTATE_MODE_NORMAL);
                Spectate:HideVehicleInfo(i);
                Spectate:playerSpectateTypeVehicle[i] = false;
            }
        }
    } else if (newstate == PLAYER_STATE_SPECTATING) {
        new prev = Spectate:GetPreviousPlayer(playerid);
        if (prev == INVALID_PLAYER_ID) {
            foreach(new i:Player) {
                if (Spectate:playerSpectateID[i] == playerid) {
                    Spectate:StopSpectate(i);
                }
            }
        } else {
            foreach(new i:Player) {
                if (Spectate:playerSpectateID[i] == playerid) {
                    Spectate:StartSpectate(i, prev);
                }
            }
        }
        Iter_Remove(Spectate_Players, playerid);
    }
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    foreach(new i:Player) if (Spectate:playerSpectateID[i] == playerid) SetPlayerInteriorEx(i, newinteriorid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    new prev = Spectate:GetPreviousPlayer(playerid);
    if (prev == INVALID_PLAYER_ID) {
        foreach(new i:Player) if (Spectate:playerSpectateID[i] == playerid) Spectate:StopSpectate(i);
    } else {
        foreach(new i:Player) if (Spectate:playerSpectateID[i] == playerid) Spectate:StartSpectate(i, prev);
    }
    Iter_Remove(Spectate_Players, playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Float:cx, Float:cy, Float:cz;
    GetPlayerCameraPos(playerid, cx, cy, cz);
    cz += !GetPlayerInterior(playerid) ? (5.0) : (0.5);
    foreach(new i:Player) {
        if (Spectate:playerSpectateID[i] == playerid) {
            SetPlayerCameraPos(i, cx, cy, cz);
            SetPlayerCameraLookAt(i, x, y, z);
        }
    }
    Iter_Remove(Spectate_Players, playerid);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    Iter_Add(Spectate_Players, playerid);
    foreach(new i:Player) {
        if (Spectate:playerSpectateID[i] == playerid) Spectate:StartSpectate(i, playerid);
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (Spectate:playerSpectateID[playerid] != INVALID_PLAYER_ID) {
        if (clickedid == Text:INVALID_TEXT_DRAW) return SelectTextDraw(playerid, 0xAA0000FF);
        if (clickedid == Spectate_BUTTON_PREVIOUS) {
            new prev = Spectate:GetPreviousPlayer(Spectate:playerSpectateID[playerid]);
            if (prev == INVALID_PLAYER_ID) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
            else Spectate:StartSpectate(playerid, prev);
        } else if (clickedid == Spectate_BUTTON_NEXT) {
            new next = Spectate:GetNextPlayer(Spectate:playerSpectateID[playerid]);
            if (next == INVALID_PLAYER_ID) PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
            else Spectate:StartSpectate(playerid, next);
        }
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    new worldid = GetPlayerVirtualWorld(playerid);
    if (Spectate:playerVirtualWorld[playerid] != worldid) {
        Spectate:playerVirtualWorld[playerid] = worldid;
        foreach(new i:Player) {
            if (Spectate:playerSpectateID[i] == playerid) SetPlayerVirtualWorldEx(i, worldid);
        }
    }
    if (Spectate:playerSpectateID[playerid] != INVALID_PLAYER_ID) {
        Spectate:UpdatePlayerInfo(playerid, Spectate:playerSpectateID[playerid]);
        if (Spectate:playerSpectateTypeVehicle[playerid]) {
            Spectate:UpdateVehicleInfo(playerid, GetPlayerVehicleID(Spectate:playerSpectateID[playerid]));
        }
    }
    return 1;
}

new Spectate:WeaponData[MAX_PLAYERS][13][2];
new Spectate:player_skin[MAX_PLAYERS];
stock Spectate:Start(playerid, targetid) {
    if (GetPlayerState(targetid) == PLAYER_STATE_WASTED || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING) return SendClientMessageEx(playerid, 0xBB0000FF, "Error: Player isn't spwaned yet.");
    Spectate:oldPlayerVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
    Spectate:oldPlayerInterior[playerid] = GetPlayerInterior(playerid);
    GetPlayerPos(playerid, Spectate:oldPlayerPosition[playerid][0], Spectate:oldPlayerPosition[playerid][1], Spectate:oldPlayerPosition[playerid][2]);
    GetPlayerFacingAngle(playerid, Spectate:oldPlayerPosition[playerid][3]);
    GetPlayerHealth(playerid, Spectate:oldPlayerHealth[playerid]);
    GetPlayerArmour(playerid, Spectate:oldPlayerArmour[playerid]);
    Spectate:player_skin[playerid] = GetPlayerSkin(playerid);
    for (new i = 0; i <= 12; i++) GetPlayerWeaponData(playerid, i, Spectate:WeaponData[playerid][i][0], Spectate:WeaponData[playerid][i][1]);
    ResetPlayerWeaponsEx(playerid);
    Spectate:StartSpectate(playerid, targetid);
    return 1;
}

stock Spectate:Stop(playerid) {
    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) return SendClientMessageEx(playerid, 0xBB0000FF, "{4286f4}[Error]: {FFFFEE}You appear to be not spectating at the moment.");
    Spectate:StopSpectate(playerid);
    SetPlayerVirtualWorldEx(playerid, Spectate:oldPlayerVirtualWorld[playerid]);
    SetPlayerInteriorEx(playerid, Spectate:oldPlayerInterior[playerid]);
    SetPlayerPosEx(playerid, Spectate:oldPlayerPosition[playerid][0], Spectate:oldPlayerPosition[playerid][1], Spectate:oldPlayerPosition[playerid][2]);
    SetPlayerFacingAngle(playerid, Spectate:oldPlayerPosition[playerid][3]);
    SetPlayerHealth(playerid, Spectate:oldPlayerHealth[playerid]);
    SetPlayerArmour(playerid, Spectate:oldPlayerArmour[playerid]);
    SetPlayerSkinEx(playerid, Spectate:player_skin[playerid]);
    ResetPlayerWeaponsEx(playerid);
    for (new i = 0; i <= 12; i++) GivePlayerWeaponEx(playerid, Spectate:WeaponData[playerid][i][0], Spectate:WeaponData[playerid][i][1]);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (GetPlayerAdminLevel(playerid) >= 5 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) UCP:AddCommand(playerid, "Spectate Stop", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Spectate Stop", inputtext)) Spectate:Stop(playerid);
    return 1;
}