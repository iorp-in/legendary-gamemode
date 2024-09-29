new ETShop_Player_Tablet[MAX_PLAYERS];
#define DIALOG_TABLETCHAT 7742
new Text:TabletWin8[23];
new Text:TabletWin8Start[51];
new Text:TabletWin8UserLog[12];
new PlayerText:TabletWin8UserLog2;
new Text:TabletWin8Pag[3];
new PlayerText:TabletWin8Pag2;
new PlayerText:Escritorio[4];
new Text:TabletPhotos[12];
new PlayerText:TabletTime[2];
new Text:TabletMusicPlayer[11];
new Text:CameraTD[24];
new Text:MapsTD[8];
new Text:Games;
new PlayerText:TabletWeather[3];
new PlayerText:Tragaperras[5];
new Text:TwoBut[2];
new TabletTimer[MAX_PLAYERS][8];
new lda[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];
new chattext[MAX_PLAYERS][2048];
new chatid[MAX_PLAYERS];
new tablet_slots[][] = {
    "ld_slot:bar1_o",
    "ld_slot:bar2_o",
    "ld_slot:bell",
    "ld_slot:cherry",
    "ld_slot:grapes",
    "ld_slot:r_69"
};
new tablet_randomvar[3];

new temperature[][] = {
    "14 C",
    "16 C",
    "8 C",
    "6 C",
    "20 C",
    "2 C"
};

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "tablet", "int", "0");
    TabletWin8[0] = TextDrawCreate(122.000000, 93.000000, "O____________iiO~n~~n~~n~O____________iiO~n~~n~~n~O____________iiO");
    TextDrawBackgroundColor(TabletWin8[0], 255);
    TextDrawFont(TabletWin8[0], 1);
    TextDrawLetterSize(TabletWin8[0], 1.600000, 8.299999);
    TextDrawColor(TabletWin8[0], 255);
    TextDrawSetOutline(TabletWin8[0], 1);
    TextDrawSetProportional(TabletWin8[0], 1);
    TextDrawSetSelectable(TabletWin8[0], 0);

    TabletWin8[1] = TextDrawCreate(122.000000, 139.000000, "_");
    TextDrawBackgroundColor(TabletWin8[1], 255);
    TextDrawFont(TabletWin8[1], 1);
    TextDrawLetterSize(TabletWin8[1], 0.500000, 24.300001);
    TextDrawColor(TabletWin8[1], -1);
    TextDrawSetOutline(TabletWin8[1], 0);
    TextDrawSetProportional(TabletWin8[1], 1);
    TextDrawSetShadow(TabletWin8[1], 1);
    TextDrawUseBox(TabletWin8[1], 1);
    TextDrawBoxColor(TabletWin8[1], 255);
    TextDrawTextSize(TabletWin8[1], 549.000000, 10.000000);
    TextDrawSetSelectable(TabletWin8[1], 0);

    TabletWin8[2] = TextDrawCreate(120.000000, 387.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8[2], 255);
    TextDrawFont(TabletWin8[2], 4);
    TextDrawLetterSize(TabletWin8[2], 0.500000, 1.000000);
    TextDrawColor(TabletWin8[2], -1);
    TextDrawSetOutline(TabletWin8[2], 0);
    TextDrawSetProportional(TabletWin8[2], 1);
    TextDrawSetShadow(TabletWin8[2], 1);
    TextDrawUseBox(TabletWin8[2], 1);
    TextDrawBoxColor(TabletWin8[2], 255);
    TextDrawTextSize(TabletWin8[2], 27.000000, -33.000000);
    TextDrawSetSelectable(TabletWin8[2], 0);

    TabletWin8[3] = TextDrawCreate(551.000000, 388.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8[3], 255);
    TextDrawFont(TabletWin8[3], 4);
    TextDrawLetterSize(TabletWin8[3], 0.500000, 1.000000);
    TextDrawColor(TabletWin8[3], -1);
    TextDrawSetOutline(TabletWin8[3], 0);
    TextDrawSetProportional(TabletWin8[3], 1);
    TextDrawSetShadow(TabletWin8[3], 1);
    TextDrawUseBox(TabletWin8[3], 1);
    TextDrawBoxColor(TabletWin8[3], 255);
    TextDrawTextSize(TabletWin8[3], -27.000000, -33.000000);
    TextDrawSetSelectable(TabletWin8[3], 0);

    TabletWin8[4] = TextDrawCreate(551.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8[4], 255);
    TextDrawFont(TabletWin8[4], 4);
    TextDrawLetterSize(TabletWin8[4], 0.500000, 1.000000);
    TextDrawColor(TabletWin8[4], -1);
    TextDrawSetOutline(TabletWin8[4], 0);
    TextDrawSetProportional(TabletWin8[4], 1);
    TextDrawSetShadow(TabletWin8[4], 1);
    TextDrawUseBox(TabletWin8[4], 1);
    TextDrawBoxColor(TabletWin8[4], 255);
    TextDrawTextSize(TabletWin8[4], -27.000000, 33.000000);
    TextDrawSetSelectable(TabletWin8[4], 0);

    TabletWin8[5] = TextDrawCreate(120.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8[5], 255);
    TextDrawFont(TabletWin8[5], 4);
    TextDrawLetterSize(TabletWin8[5], 0.500000, 1.000000);
    TextDrawColor(TabletWin8[5], -1);
    TextDrawSetOutline(TabletWin8[5], 0);
    TextDrawSetProportional(TabletWin8[5], 1);
    TextDrawSetShadow(TabletWin8[5], 1);
    TextDrawUseBox(TabletWin8[5], 1);
    TextDrawBoxColor(TabletWin8[5], 255);
    TextDrawTextSize(TabletWin8[5], 27.000000, 33.000000);
    TextDrawSetSelectable(TabletWin8[5], 0);

    TabletWin8[6] = TextDrawCreate(148.000000, 106.000000, "_");
    TextDrawBackgroundColor(TabletWin8[6], 255);
    TextDrawFont(TabletWin8[6], 1);
    TextDrawLetterSize(TabletWin8[6], 0.500000, 30.999998);
    TextDrawColor(TabletWin8[6], -1);
    TextDrawSetOutline(TabletWin8[6], 0);
    TextDrawSetProportional(TabletWin8[6], 1);
    TextDrawSetShadow(TabletWin8[6], 1);
    TextDrawUseBox(TabletWin8[6], 1);
    TextDrawBoxColor(TabletWin8[6], 255);
    TextDrawTextSize(TabletWin8[6], 522.000000, 0.000000);
    TextDrawSetSelectable(TabletWin8[6], 0);

    TabletWin8[7] = TextDrawCreate(149.000000, 139.000000, "_");
    TextDrawBackgroundColor(TabletWin8[7], 255);
    TextDrawFont(TabletWin8[7], 1);
    TextDrawLetterSize(TabletWin8[7], 0.500000, 24.200004);
    TextDrawColor(TabletWin8[7], -1);
    TextDrawSetOutline(TabletWin8[7], 0);
    TextDrawSetProportional(TabletWin8[7], 1);
    TextDrawSetShadow(TabletWin8[7], 1);
    TextDrawUseBox(TabletWin8[7], 1);
    TextDrawBoxColor(TabletWin8[7], 1718026239);
    TextDrawTextSize(TabletWin8[7], 522.000000, 10.000000);
    TextDrawSetSelectable(TabletWin8[7], 0);

    TabletWin8[8] = TextDrawCreate(203.000000, 208.000000, "_");
    TextDrawAlignment(TabletWin8[8], 2);
    TextDrawBackgroundColor(TabletWin8[8], 255);
    TextDrawFont(TabletWin8[8], 1);
    TextDrawLetterSize(TabletWin8[8], 0.500000, 2.900000);
    TextDrawColor(TabletWin8[8], -1);
    TextDrawSetOutline(TabletWin8[8], 0);
    TextDrawSetProportional(TabletWin8[8], 1);
    TextDrawSetShadow(TabletWin8[8], 1);
    TextDrawUseBox(TabletWin8[8], 1);
    TextDrawBoxColor(TabletWin8[8], -1);
    TextDrawTextSize(TabletWin8[8], 0.000000, 39.000000);
    TextDrawSetSelectable(TabletWin8[8], 0);

    TabletWin8[9] = TextDrawCreate(203.000000, 241.000000, "_");
    TextDrawAlignment(TabletWin8[9], 2);
    TextDrawBackgroundColor(TabletWin8[9], 255);
    TextDrawFont(TabletWin8[9], 1);
    TextDrawLetterSize(TabletWin8[9], 0.500000, 2.900000);
    TextDrawColor(TabletWin8[9], -1);
    TextDrawSetOutline(TabletWin8[9], 0);
    TextDrawSetProportional(TabletWin8[9], 1);
    TextDrawSetShadow(TabletWin8[9], 1);
    TextDrawUseBox(TabletWin8[9], 1);
    TextDrawBoxColor(TabletWin8[9], -1);
    TextDrawTextSize(TabletWin8[9], 0.000000, 39.000000);
    TextDrawSetSelectable(TabletWin8[9], 0);

    TabletWin8[10] = TextDrawCreate(248.000000, 241.000000, "_");
    TextDrawAlignment(TabletWin8[10], 2);
    TextDrawBackgroundColor(TabletWin8[10], 255);
    TextDrawFont(TabletWin8[10], 1);
    TextDrawLetterSize(TabletWin8[10], 0.500000, 2.900000);
    TextDrawColor(TabletWin8[10], -1);
    TextDrawSetOutline(TabletWin8[10], 0);
    TextDrawSetProportional(TabletWin8[10], 1);
    TextDrawSetShadow(TabletWin8[10], 1);
    TextDrawUseBox(TabletWin8[10], 1);
    TextDrawBoxColor(TabletWin8[10], -1);
    TextDrawTextSize(TabletWin8[10], 0.000000, 39.000000);
    TextDrawSetSelectable(TabletWin8[10], 0);

    TabletWin8[11] = TextDrawCreate(248.000000, 208.000000, "_");
    TextDrawAlignment(TabletWin8[11], 2);
    TextDrawBackgroundColor(TabletWin8[11], 255);
    TextDrawFont(TabletWin8[11], 1);
    TextDrawLetterSize(TabletWin8[11], 0.500000, 2.900000);
    TextDrawColor(TabletWin8[11], -1);
    TextDrawSetOutline(TabletWin8[11], 0);
    TextDrawSetProportional(TabletWin8[11], 1);
    TextDrawSetShadow(TabletWin8[11], 1);
    TextDrawUseBox(TabletWin8[11], 1);
    TextDrawBoxColor(TabletWin8[11], -1);
    TextDrawTextSize(TabletWin8[11], 0.000000, 39.000000);
    TextDrawSetSelectable(TabletWin8[11], 0);

    TabletWin8[12] = TextDrawCreate(281.000000, 208.000000, "Windows 8");
    TextDrawBackgroundColor(TabletWin8[12], 255);
    TextDrawFont(TabletWin8[12], 1);
    TextDrawLetterSize(TabletWin8[12], 1.159999, 5.799995);
    TextDrawColor(TabletWin8[12], -1);
    TextDrawSetOutline(TabletWin8[12], 0);
    TextDrawSetProportional(TabletWin8[12], 1);
    TextDrawSetShadow(TabletWin8[12], 0);
    TextDrawSetSelectable(TabletWin8[12], 0);

    TabletWin8[13] = TextDrawCreate(332.000000, 301.000000, ".");
    TextDrawBackgroundColor(TabletWin8[13], 255);
    TextDrawFont(TabletWin8[13], 1);
    TextDrawLetterSize(TabletWin8[13], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[13], -1);
    TextDrawSetOutline(TabletWin8[13], 0);
    TextDrawSetProportional(TabletWin8[13], 1);
    TextDrawSetShadow(TabletWin8[13], 0);
    TextDrawSetSelectable(TabletWin8[13], 0);

    TabletWin8[14] = TextDrawCreate(328.000000, 304.000000, ".");
    TextDrawBackgroundColor(TabletWin8[14], 255);
    TextDrawFont(TabletWin8[14], 1);
    TextDrawLetterSize(TabletWin8[14], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[14], -1);
    TextDrawSetOutline(TabletWin8[14], 0);
    TextDrawSetProportional(TabletWin8[14], 1);
    TextDrawSetShadow(TabletWin8[14], 0);
    TextDrawSetSelectable(TabletWin8[14], 0);

    TabletWin8[15] = TextDrawCreate(326.000000, 309.000000, ".");
    TextDrawBackgroundColor(TabletWin8[15], 255);
    TextDrawFont(TabletWin8[15], 1);
    TextDrawLetterSize(TabletWin8[15], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[15], -1);
    TextDrawSetOutline(TabletWin8[15], 0);
    TextDrawSetProportional(TabletWin8[15], 1);
    TextDrawSetShadow(TabletWin8[15], 0);
    TextDrawSetSelectable(TabletWin8[15], 0);

    TabletWin8[16] = TextDrawCreate(328.000000, 314.000000, ".");
    TextDrawBackgroundColor(TabletWin8[16], 255);
    TextDrawFont(TabletWin8[16], 1);
    TextDrawLetterSize(TabletWin8[16], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[16], -1);
    TextDrawSetOutline(TabletWin8[16], 0);
    TextDrawSetProportional(TabletWin8[16], 1);
    TextDrawSetShadow(TabletWin8[16], 0);
    TextDrawSetSelectable(TabletWin8[16], 0);

    TabletWin8[17] = TextDrawCreate(332.000000, 316.000000, ".");
    TextDrawBackgroundColor(TabletWin8[17], 255);
    TextDrawFont(TabletWin8[17], 1);
    TextDrawLetterSize(TabletWin8[17], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[17], -1);
    TextDrawSetOutline(TabletWin8[17], 0);
    TextDrawSetProportional(TabletWin8[17], 1);
    TextDrawSetShadow(TabletWin8[17], 0);
    TextDrawSetSelectable(TabletWin8[17], 0);

    TabletWin8[18] = TextDrawCreate(336.000000, 314.000000, ".");
    TextDrawBackgroundColor(TabletWin8[18], 255);
    TextDrawFont(TabletWin8[18], 1);
    TextDrawLetterSize(TabletWin8[18], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[18], -1);
    TextDrawSetOutline(TabletWin8[18], 0);
    TextDrawSetProportional(TabletWin8[18], 1);
    TextDrawSetShadow(TabletWin8[18], 0);
    TextDrawSetSelectable(TabletWin8[18], 0);

    TabletWin8[19] = TextDrawCreate(338.000000, 309.000000, ".");
    TextDrawBackgroundColor(TabletWin8[19], 255);
    TextDrawFont(TabletWin8[19], 1);
    TextDrawLetterSize(TabletWin8[19], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[19], -1);
    TextDrawSetOutline(TabletWin8[19], 0);
    TextDrawSetProportional(TabletWin8[19], 1);
    TextDrawSetShadow(TabletWin8[19], 0);
    TextDrawSetSelectable(TabletWin8[19], 0);

    TabletWin8[20] = TextDrawCreate(337.000000, 304.000000, ".");
    TextDrawBackgroundColor(TabletWin8[20], 255);
    TextDrawFont(TabletWin8[20], 1);
    TextDrawLetterSize(TabletWin8[20], 0.300000, 0.800000);
    TextDrawColor(TabletWin8[20], -1);
    TextDrawSetOutline(TabletWin8[20], 0);
    TextDrawSetProportional(TabletWin8[20], 1);
    TextDrawSetShadow(TabletWin8[20], 0);
    TextDrawSetSelectable(TabletWin8[20], 0);

    TabletWin8[21] = TextDrawCreate(137.000000, 124.000000, "_");
    TextDrawBackgroundColor(TabletWin8[21], 255);
    TextDrawFont(TabletWin8[21], 1);
    TextDrawLetterSize(TabletWin8[21], 0.500000, 1.200000);
    TextDrawColor(TabletWin8[21], -1);
    TextDrawSetOutline(TabletWin8[21], 0);
    TextDrawSetProportional(TabletWin8[21], 1);
    TextDrawSetShadow(TabletWin8[21], 1);
    TextDrawUseBox(TabletWin8[21], 1);
    TextDrawBoxColor(TabletWin8[21], 255);
    TextDrawTextSize(TabletWin8[21], 539.000000, 192.000000);
    TextDrawSetSelectable(TabletWin8[21], 0);

    TabletWin8[22] = TextDrawCreate(137.000000, 362.000000, "_");
    TextDrawBackgroundColor(TabletWin8[22], 255);
    TextDrawFont(TabletWin8[22], 1);
    TextDrawLetterSize(TabletWin8[22], 0.500000, 1.200000);
    TextDrawColor(TabletWin8[22], -1);
    TextDrawSetOutline(TabletWin8[22], 0);
    TextDrawSetProportional(TabletWin8[22], 1);
    TextDrawSetShadow(TabletWin8[22], 1);
    TextDrawUseBox(TabletWin8[22], 1);
    TextDrawBoxColor(TabletWin8[22], 255);
    TextDrawTextSize(TabletWin8[22], 539.000000, 192.000000);
    TextDrawSetSelectable(TabletWin8[22], 0);

    //Inicio
    TabletWin8Start[0] = TextDrawCreate(122.000000, 93.000000, "O____________iiO~n~~n~~n~O____________iiO~n~~n~~n~O____________iiO");
    TextDrawBackgroundColor(TabletWin8Start[0], 255);
    TextDrawFont(TabletWin8Start[0], 1);
    TextDrawLetterSize(TabletWin8Start[0], 1.600000, 8.299999);
    TextDrawColor(TabletWin8Start[0], 255);
    TextDrawSetOutline(TabletWin8Start[0], 1);
    TextDrawSetProportional(TabletWin8Start[0], 1);
    TextDrawSetSelectable(TabletWin8Start[0], 0);

    TabletWin8Start[1] = TextDrawCreate(122.000000, 139.000000, "_");
    TextDrawBackgroundColor(TabletWin8Start[1], 255);
    TextDrawFont(TabletWin8Start[1], 1);
    TextDrawLetterSize(TabletWin8Start[1], 0.500000, 24.300001);
    TextDrawColor(TabletWin8Start[1], -1);
    TextDrawSetOutline(TabletWin8Start[1], 0);
    TextDrawSetProportional(TabletWin8Start[1], 1);
    TextDrawSetShadow(TabletWin8Start[1], 1);
    TextDrawUseBox(TabletWin8Start[1], 1);
    TextDrawBoxColor(TabletWin8Start[1], 255);
    TextDrawTextSize(TabletWin8Start[1], 549.000000, 10.000000);
    TextDrawSetSelectable(TabletWin8Start[1], 0);

    TabletWin8Start[2] = TextDrawCreate(120.000000, 387.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8Start[2], 255);
    TextDrawFont(TabletWin8Start[2], 4);
    TextDrawLetterSize(TabletWin8Start[2], 0.500000, 1.000000);
    TextDrawColor(TabletWin8Start[2], -1);
    TextDrawSetOutline(TabletWin8Start[2], 0);
    TextDrawSetProportional(TabletWin8Start[2], 1);
    TextDrawSetShadow(TabletWin8Start[2], 1);
    TextDrawUseBox(TabletWin8Start[2], 1);
    TextDrawBoxColor(TabletWin8Start[2], 255);
    TextDrawTextSize(TabletWin8Start[2], 27.000000, -33.000000);
    TextDrawSetSelectable(TabletWin8Start[2], 0);

    TabletWin8Start[3] = TextDrawCreate(551.000000, 388.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8Start[3], 255);
    TextDrawFont(TabletWin8Start[3], 4);
    TextDrawLetterSize(TabletWin8Start[3], 0.500000, 1.000000);
    TextDrawColor(TabletWin8Start[3], -1);
    TextDrawSetOutline(TabletWin8Start[3], 0);
    TextDrawSetProportional(TabletWin8Start[3], 1);
    TextDrawSetShadow(TabletWin8Start[3], 1);
    TextDrawUseBox(TabletWin8Start[3], 1);
    TextDrawBoxColor(TabletWin8Start[3], 255);
    TextDrawTextSize(TabletWin8Start[3], -27.000000, -33.000000);
    TextDrawSetSelectable(TabletWin8Start[3], 0);

    TabletWin8Start[4] = TextDrawCreate(551.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8Start[4], 255);
    TextDrawFont(TabletWin8Start[4], 4);
    TextDrawLetterSize(TabletWin8Start[4], 0.500000, 1.000000);
    TextDrawColor(TabletWin8Start[4], -1);
    TextDrawSetOutline(TabletWin8Start[4], 0);
    TextDrawSetProportional(TabletWin8Start[4], 1);
    TextDrawSetShadow(TabletWin8Start[4], 1);
    TextDrawUseBox(TabletWin8Start[4], 1);
    TextDrawBoxColor(TabletWin8Start[4], 255);
    TextDrawTextSize(TabletWin8Start[4], -27.000000, 33.000000);
    TextDrawSetSelectable(TabletWin8Start[4], 0);

    TabletWin8Start[5] = TextDrawCreate(120.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(TabletWin8Start[5], 255);
    TextDrawFont(TabletWin8Start[5], 4);
    TextDrawLetterSize(TabletWin8Start[5], 0.500000, 1.000000);
    TextDrawColor(TabletWin8Start[5], -1);
    TextDrawSetOutline(TabletWin8Start[5], 0);
    TextDrawSetProportional(TabletWin8Start[5], 1);
    TextDrawSetShadow(TabletWin8Start[5], 1);
    TextDrawUseBox(TabletWin8Start[5], 1);
    TextDrawBoxColor(TabletWin8Start[5], 255);
    TextDrawTextSize(TabletWin8Start[5], 27.000000, 33.000000);
    TextDrawSetSelectable(TabletWin8Start[5], 0);

    TabletWin8Start[6] = TextDrawCreate(148.000000, 106.000000, "_");
    TextDrawBackgroundColor(TabletWin8Start[6], 255);
    TextDrawFont(TabletWin8Start[6], 1);
    TextDrawLetterSize(TabletWin8Start[6], 0.500000, 30.999998);
    TextDrawColor(TabletWin8Start[6], -1);
    TextDrawSetOutline(TabletWin8Start[6], 0);
    TextDrawSetProportional(TabletWin8Start[6], 1);
    TextDrawSetShadow(TabletWin8Start[6], 1);
    TextDrawUseBox(TabletWin8Start[6], 1);
    TextDrawBoxColor(TabletWin8Start[6], 255);
    TextDrawTextSize(TabletWin8Start[6], 522.000000, 0.000000);
    TextDrawSetSelectable(TabletWin8Start[6], 0);

    TabletWin8Start[7] = TextDrawCreate(149.000000, 139.000000, "_");
    TextDrawBackgroundColor(TabletWin8Start[7], 255);
    TextDrawFont(TabletWin8Start[7], 1);
    TextDrawLetterSize(TabletWin8Start[7], 0.500000, 24.200004);
    TextDrawColor(TabletWin8Start[7], -1);
    TextDrawSetOutline(TabletWin8Start[7], 0);
    TextDrawSetProportional(TabletWin8Start[7], 1);
    TextDrawSetShadow(TabletWin8Start[7], 1);
    TextDrawUseBox(TabletWin8Start[7], 1);
    TextDrawBoxColor(TabletWin8Start[7], 1711315455);
    TextDrawTextSize(TabletWin8Start[7], 522.000000, 10.000000);
    TextDrawSetSelectable(TabletWin8Start[7], 0);

    TabletWin8Start[8] = TextDrawCreate(201.000000, 173.000000, "_");
    TextDrawAlignment(TabletWin8Start[8], 2);
    TextDrawBackgroundColor(TabletWin8Start[8], 255);
    TextDrawFont(TabletWin8Start[8], 1);
    TextDrawLetterSize(TabletWin8Start[8], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[8], -1);
    TextDrawSetOutline(TabletWin8Start[8], 0);
    TextDrawSetProportional(TabletWin8Start[8], 1);
    TextDrawSetShadow(TabletWin8Start[8], 1);
    TextDrawUseBox(TabletWin8Start[8], 1);
    TextDrawBoxColor(TabletWin8Start[8], 1724697855);
    TextDrawTextSize(TabletWin8Start[8], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[8], 0);

    TabletWin8Start[9] = TextDrawCreate(201.000000, 220.000000, "_");
    TextDrawAlignment(TabletWin8Start[9], 2);
    TextDrawBackgroundColor(TabletWin8Start[9], 255);
    TextDrawFont(TabletWin8Start[9], 1);
    TextDrawLetterSize(TabletWin8Start[9], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[9], -1);
    TextDrawSetOutline(TabletWin8Start[9], 0);
    TextDrawSetProportional(TabletWin8Start[9], 1);
    TextDrawSetShadow(TabletWin8Start[9], 1);
    TextDrawUseBox(TabletWin8Start[9], 1);
    TextDrawBoxColor(TabletWin8Start[9], -6749953);
    TextDrawTextSize(TabletWin8Start[9], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[9], 0);

    TabletWin8Start[10] = TextDrawCreate(201.000000, 266.000000, "_");
    TextDrawAlignment(TabletWin8Start[10], 2);
    TextDrawBackgroundColor(TabletWin8Start[10], 255);
    TextDrawFont(TabletWin8Start[10], 1);
    TextDrawLetterSize(TabletWin8Start[10], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[10], -1);
    TextDrawSetOutline(TabletWin8Start[10], 0);
    TextDrawSetProportional(TabletWin8Start[10], 1);
    TextDrawSetShadow(TabletWin8Start[10], 1);
    TextDrawUseBox(TabletWin8Start[10], 1);
    TextDrawBoxColor(TabletWin8Start[10], -1724671489);
    TextDrawTextSize(TabletWin8Start[10], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[10], 0);

    TabletWin8Start[11] = TextDrawCreate(165.000000, 310.000000, "loadsc2:loadsc2");
    TextDrawAlignment(TabletWin8Start[11], 2);
    TextDrawBackgroundColor(TabletWin8Start[11], 255);
    TextDrawFont(TabletWin8Start[11], 4);
    TextDrawLetterSize(TabletWin8Start[11], 0.500000, 0.299998);
    TextDrawColor(TabletWin8Start[11], -1);
    TextDrawSetOutline(TabletWin8Start[11], 0);
    TextDrawSetProportional(TabletWin8Start[11], 1);
    TextDrawSetShadow(TabletWin8Start[11], 1);
    TextDrawUseBox(TabletWin8Start[11], 1);
    TextDrawBoxColor(TabletWin8Start[11], -1724671489);
    TextDrawTextSize(TabletWin8Start[11], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletWin8Start[11], 0);

    TabletWin8Start[12] = TextDrawCreate(163.000000, 139.000000, "Start");
    TextDrawBackgroundColor(TabletWin8Start[12], 255);
    TextDrawFont(TabletWin8Start[12], 1);
    TextDrawLetterSize(TabletWin8Start[12], 0.759999, 3.299999);
    TextDrawColor(TabletWin8Start[12], -1);
    TextDrawSetOutline(TabletWin8Start[12], 0);
    TextDrawSetProportional(TabletWin8Start[12], 1);
    TextDrawSetShadow(TabletWin8Start[12], 0);
    TextDrawSetSelectable(TabletWin8Start[12], 0);

    TabletWin8Start[13] = TextDrawCreate(277.000000, 173.000000, "_");
    TextDrawAlignment(TabletWin8Start[13], 2);
    TextDrawBackgroundColor(TabletWin8Start[13], 255);
    TextDrawFont(TabletWin8Start[13], 1);
    TextDrawLetterSize(TabletWin8Start[13], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[13], -1);
    TextDrawSetOutline(TabletWin8Start[13], 0);
    TextDrawSetProportional(TabletWin8Start[13], 1);
    TextDrawSetShadow(TabletWin8Start[13], 1);
    TextDrawUseBox(TabletWin8Start[13], 1);
    TextDrawBoxColor(TabletWin8Start[13], -1728013825);
    TextDrawTextSize(TabletWin8Start[13], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[13], 0);

    TabletWin8Start[14] = TextDrawCreate(241.000000, 218.000000, "load0uk:load0uk");
    TextDrawAlignment(TabletWin8Start[14], 2);
    TextDrawBackgroundColor(TabletWin8Start[14], 255);
    TextDrawFont(TabletWin8Start[14], 4);
    TextDrawLetterSize(TabletWin8Start[14], 0.500000, 0.299998);
    TextDrawColor(TabletWin8Start[14], -1);
    TextDrawSetOutline(TabletWin8Start[14], 0);
    TextDrawSetProportional(TabletWin8Start[14], 1);
    TextDrawSetShadow(TabletWin8Start[14], 1);
    TextDrawUseBox(TabletWin8Start[14], 1);
    TextDrawBoxColor(TabletWin8Start[14], -1724671489);
    TextDrawTextSize(TabletWin8Start[14], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletWin8Start[14], 0);

    TabletWin8Start[15] = TextDrawCreate(277.000000, 266.000000, "_");
    TextDrawAlignment(TabletWin8Start[15], 2);
    TextDrawBackgroundColor(TabletWin8Start[15], 255);
    TextDrawFont(TabletWin8Start[15], 1);
    TextDrawLetterSize(TabletWin8Start[15], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[15], -1);
    TextDrawSetOutline(TabletWin8Start[15], 0);
    TextDrawSetProportional(TabletWin8Start[15], 1);
    TextDrawSetShadow(TabletWin8Start[15], 1);
    TextDrawUseBox(TabletWin8Start[15], 1);
    TextDrawBoxColor(TabletWin8Start[15], 16711935);
    TextDrawTextSize(TabletWin8Start[15], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[15], 0);

    TabletWin8Start[16] = TextDrawCreate(277.000000, 313.000000, "_");
    TextDrawAlignment(TabletWin8Start[16], 2);
    TextDrawBackgroundColor(TabletWin8Start[16], 255);
    TextDrawFont(TabletWin8Start[16], 1);
    TextDrawLetterSize(TabletWin8Start[16], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[16], -1);
    TextDrawSetOutline(TabletWin8Start[16], 0);
    TextDrawSetProportional(TabletWin8Start[16], 1);
    TextDrawSetShadow(TabletWin8Start[16], 1);
    TextDrawUseBox(TabletWin8Start[16], 1);
    TextDrawBoxColor(TabletWin8Start[16], 16777215);
    TextDrawTextSize(TabletWin8Start[16], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[16], 0);

    TabletWin8Start[17] = TextDrawCreate(334.000000, 173.000000, "_");
    TextDrawAlignment(TabletWin8Start[17], 2);
    TextDrawBackgroundColor(TabletWin8Start[17], 255);
    TextDrawFont(TabletWin8Start[17], 1);
    TextDrawLetterSize(TabletWin8Start[17], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[17], -1);
    TextDrawSetOutline(TabletWin8Start[17], 0);
    TextDrawSetProportional(TabletWin8Start[17], 1);
    TextDrawSetShadow(TabletWin8Start[17], 1);
    TextDrawUseBox(TabletWin8Start[17], 1);
    TextDrawBoxColor(TabletWin8Start[17], -1721316097);
    TextDrawTextSize(TabletWin8Start[17], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[17], 0);

    TabletWin8Start[18] = TextDrawCreate(372.000000, 173.000000, "_");
    TextDrawAlignment(TabletWin8Start[18], 2);
    TextDrawBackgroundColor(TabletWin8Start[18], 255);
    TextDrawFont(TabletWin8Start[18], 1);
    TextDrawLetterSize(TabletWin8Start[18], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[18], -1);
    TextDrawSetOutline(TabletWin8Start[18], 0);
    TextDrawSetProportional(TabletWin8Start[18], 1);
    TextDrawSetShadow(TabletWin8Start[18], 1);
    TextDrawUseBox(TabletWin8Start[18], 1);
    TextDrawBoxColor(TabletWin8Start[18], 16711935);
    TextDrawTextSize(TabletWin8Start[18], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[18], 0);

    TabletWin8Start[19] = TextDrawCreate(372.000000, 219.000000, "_");
    TextDrawAlignment(TabletWin8Start[19], 2);
    TextDrawBackgroundColor(TabletWin8Start[19], 255);
    TextDrawFont(TabletWin8Start[19], 1);
    TextDrawLetterSize(TabletWin8Start[19], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[19], -1);
    TextDrawSetOutline(TabletWin8Start[19], 0);
    TextDrawSetProportional(TabletWin8Start[19], 1);
    TextDrawSetShadow(TabletWin8Start[19], 1);
    TextDrawUseBox(TabletWin8Start[19], 1);
    TextDrawBoxColor(TabletWin8Start[19], 65535);
    TextDrawTextSize(TabletWin8Start[19], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[19], 0);

    TabletWin8Start[20] = TextDrawCreate(334.000000, 220.000000, "_");
    TextDrawAlignment(TabletWin8Start[20], 2);
    TextDrawBackgroundColor(TabletWin8Start[20], 255);
    TextDrawFont(TabletWin8Start[20], 1);
    TextDrawLetterSize(TabletWin8Start[20], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[20], -1);
    TextDrawSetOutline(TabletWin8Start[20], 0);
    TextDrawSetProportional(TabletWin8Start[20], 1);
    TextDrawSetShadow(TabletWin8Start[20], 1);
    TextDrawUseBox(TabletWin8Start[20], 1);
    TextDrawBoxColor(TabletWin8Start[20], -1724671489);
    TextDrawTextSize(TabletWin8Start[20], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[20], 0);

    TabletWin8Start[21] = TextDrawCreate(137.000000, 124.000000, "_");
    TextDrawBackgroundColor(TabletWin8Start[21], 255);
    TextDrawFont(TabletWin8Start[21], 1);
    TextDrawLetterSize(TabletWin8Start[21], 0.500000, 1.200000);
    TextDrawColor(TabletWin8Start[21], -1);
    TextDrawSetOutline(TabletWin8Start[21], 0);
    TextDrawSetProportional(TabletWin8Start[21], 1);
    TextDrawSetShadow(TabletWin8Start[21], 1);
    TextDrawUseBox(TabletWin8Start[21], 1);
    TextDrawBoxColor(TabletWin8Start[21], 255);
    TextDrawTextSize(TabletWin8Start[21], 539.000000, 192.000000);
    TextDrawSetSelectable(TabletWin8Start[21], 0);

    TabletWin8Start[22] = TextDrawCreate(137.000000, 362.000000, "_");
    TextDrawBackgroundColor(TabletWin8Start[22], 255);
    TextDrawFont(TabletWin8Start[22], 1);
    TextDrawLetterSize(TabletWin8Start[22], 0.500000, 1.200000);
    TextDrawColor(TabletWin8Start[22], -1);
    TextDrawSetOutline(TabletWin8Start[22], 0);
    TextDrawSetProportional(TabletWin8Start[22], 1);
    TextDrawSetShadow(TabletWin8Start[22], 1);
    TextDrawUseBox(TabletWin8Start[22], 1);
    TextDrawBoxColor(TabletWin8Start[22], 255);
    TextDrawTextSize(TabletWin8Start[22], 539.000000, 192.000000);
    TextDrawSetSelectable(TabletWin8Start[22], 0);

    TabletWin8Start[23] = TextDrawCreate(353.000000, 266.000000, "_");
    TextDrawAlignment(TabletWin8Start[23], 2);
    TextDrawBackgroundColor(TabletWin8Start[23], 255);
    TextDrawFont(TabletWin8Start[23], 1);
    TextDrawLetterSize(TabletWin8Start[23], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[23], -1);
    TextDrawSetOutline(TabletWin8Start[23], 0);
    TextDrawSetProportional(TabletWin8Start[23], 1);
    TextDrawSetShadow(TabletWin8Start[23], 1);
    TextDrawUseBox(TabletWin8Start[23], 1);
    TextDrawBoxColor(TabletWin8Start[23], -1728013825);
    TextDrawTextSize(TabletWin8Start[23], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[23], 0);

    TabletWin8Start[24] = TextDrawCreate(353.000000, 313.000000, "_");
    TextDrawAlignment(TabletWin8Start[24], 2);
    TextDrawBackgroundColor(TabletWin8Start[24], 255);
    TextDrawFont(TabletWin8Start[24], 1);
    TextDrawLetterSize(TabletWin8Start[24], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[24], -1);
    TextDrawSetOutline(TabletWin8Start[24], 0);
    TextDrawSetProportional(TabletWin8Start[24], 1);
    TextDrawSetShadow(TabletWin8Start[24], 1);
    TextDrawUseBox(TabletWin8Start[24], 1);
    TextDrawBoxColor(TabletWin8Start[24], -16776961);
    TextDrawTextSize(TabletWin8Start[24], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[24], 0);

    TabletWin8Start[25] = TextDrawCreate(419.000000, 170.000000, "ld_dual:backgnd");
    TextDrawBackgroundColor(TabletWin8Start[25], 255);
    TextDrawFont(TabletWin8Start[25], 4);
    TextDrawLetterSize(TabletWin8Start[25], 0.500000, 1.000000);
    TextDrawColor(TabletWin8Start[25], -1);
    TextDrawSetOutline(TabletWin8Start[25], 0);
    TextDrawSetProportional(TabletWin8Start[25], 1);
    TextDrawSetShadow(TabletWin8Start[25], 1);
    TextDrawUseBox(TabletWin8Start[25], 1);
    TextDrawBoxColor(TabletWin8Start[25], 255);
    TextDrawTextSize(TabletWin8Start[25], 72.000000, 43.000000);
    TextDrawSetSelectable(TabletWin8Start[25], 0);

    TabletWin8Start[26] = TextDrawCreate(455.000000, 220.000000, "_");
    TextDrawAlignment(TabletWin8Start[26], 2);
    TextDrawBackgroundColor(TabletWin8Start[26], 255);
    TextDrawFont(TabletWin8Start[26], 1);
    TextDrawLetterSize(TabletWin8Start[26], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[26], -1);
    TextDrawSetOutline(TabletWin8Start[26], 0);
    TextDrawSetProportional(TabletWin8Start[26], 1);
    TextDrawSetShadow(TabletWin8Start[26], 1);
    TextDrawUseBox(TabletWin8Start[26], 1);
    TextDrawBoxColor(TabletWin8Start[26], 65535);
    TextDrawTextSize(TabletWin8Start[26], 5.000000, 68.000000);
    TextDrawSetSelectable(TabletWin8Start[26], 0);

    TabletWin8Start[27] = TextDrawCreate(437.000000, 266.000000, "_");
    TextDrawAlignment(TabletWin8Start[27], 2);
    TextDrawBackgroundColor(TabletWin8Start[27], 255);
    TextDrawFont(TabletWin8Start[27], 1);
    TextDrawLetterSize(TabletWin8Start[27], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[27], -1);
    TextDrawSetOutline(TabletWin8Start[27], 0);
    TextDrawSetProportional(TabletWin8Start[27], 1);
    TextDrawSetShadow(TabletWin8Start[27], 1);
    TextDrawUseBox(TabletWin8Start[27], 1);
    TextDrawBoxColor(TabletWin8Start[27], 16711935);
    TextDrawTextSize(TabletWin8Start[27], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[27], 0);

    TabletWin8Start[28] = TextDrawCreate(437.000000, 313.000000, "_");
    TextDrawAlignment(TabletWin8Start[28], 2);
    TextDrawBackgroundColor(TabletWin8Start[28], 255);
    TextDrawFont(TabletWin8Start[28], 1);
    TextDrawLetterSize(TabletWin8Start[28], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[28], -1);
    TextDrawSetOutline(TabletWin8Start[28], 0);
    TextDrawSetProportional(TabletWin8Start[28], 1);
    TextDrawSetShadow(TabletWin8Start[28], 1);
    TextDrawUseBox(TabletWin8Start[28], 1);
    TextDrawBoxColor(TabletWin8Start[28], -6749953);
    TextDrawTextSize(TabletWin8Start[28], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[28], 0);

    TabletWin8Start[29] = TextDrawCreate(474.000000, 266.000000, "_");
    TextDrawAlignment(TabletWin8Start[29], 2);
    TextDrawBackgroundColor(TabletWin8Start[29], 255);
    TextDrawFont(TabletWin8Start[29], 1);
    TextDrawLetterSize(TabletWin8Start[29], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[29], -1);
    TextDrawSetOutline(TabletWin8Start[29], 0);
    TextDrawSetProportional(TabletWin8Start[29], 1);
    TextDrawSetShadow(TabletWin8Start[29], 1);
    TextDrawUseBox(TabletWin8Start[29], 1);
    TextDrawBoxColor(TabletWin8Start[29], -872375809);
    TextDrawTextSize(TabletWin8Start[29], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[29], 0);

    TabletWin8Start[30] = TextDrawCreate(474.000000, 313.000000, "_");
    TextDrawAlignment(TabletWin8Start[30], 2);
    TextDrawBackgroundColor(TabletWin8Start[30], 255);
    TextDrawFont(TabletWin8Start[30], 1);
    TextDrawLetterSize(TabletWin8Start[30], 0.500000, 4.199998);
    TextDrawColor(TabletWin8Start[30], -1);
    TextDrawSetOutline(TabletWin8Start[30], 0);
    TextDrawSetProportional(TabletWin8Start[30], 1);
    TextDrawSetShadow(TabletWin8Start[30], 1);
    TextDrawUseBox(TabletWin8Start[30], 1);
    TextDrawBoxColor(TabletWin8Start[30], -16776961);
    TextDrawTextSize(TabletWin8Start[30], 273.000000, 31.000000);
    TextDrawSetSelectable(TabletWin8Start[30], 0);

    TabletWin8Start[31] = TextDrawCreate(187.000000, 198.000000, "Mail");
    TextDrawBackgroundColor(TabletWin8Start[31], 255);
    TextDrawAlignment(TabletWin8Start[31], 2);
    TextDrawFont(TabletWin8Start[31], 1);
    TextDrawLetterSize(TabletWin8Start[31], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[31], -1);
    TextDrawSetOutline(TabletWin8Start[31], 0);
    TextDrawSetProportional(TabletWin8Start[31], 1);
    TextDrawSetShadow(TabletWin8Start[31], 0);
    TextDrawTextSize(TabletWin8Start[31], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[31], 1);

    TabletWin8Start[32] = TextDrawCreate(193.000000, 245.000000, "Contacts");
    TextDrawBackgroundColor(TabletWin8Start[32], 255);
    TextDrawAlignment(TabletWin8Start[32], 2);
    TextDrawFont(TabletWin8Start[32], 1);
    TextDrawLetterSize(TabletWin8Start[32], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[32], -1);
    TextDrawSetOutline(TabletWin8Start[32], 0);
    TextDrawSetProportional(TabletWin8Start[32], 1);
    TextDrawSetShadow(TabletWin8Start[32], 0);
    TextDrawTextSize(TabletWin8Start[32], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[32], 1);

    TabletWin8Start[33] = TextDrawCreate(193.000000, 291.000000, "Messages");
    TextDrawBackgroundColor(TabletWin8Start[33], 255);
    TextDrawAlignment(TabletWin8Start[33], 2);
    TextDrawFont(TabletWin8Start[33], 1);
    TextDrawLetterSize(TabletWin8Start[33], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[33], -1);
    TextDrawSetOutline(TabletWin8Start[33], 0);
    TextDrawSetProportional(TabletWin8Start[33], 1);
    TextDrawSetShadow(TabletWin8Start[33], 0);
    TextDrawTextSize(TabletWin8Start[33], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[33], 1);

    TabletWin8Start[34] = TextDrawCreate(193.000000, 337.000000, "Desktop");
    TextDrawBackgroundColor(TabletWin8Start[34], 255);
    TextDrawAlignment(TabletWin8Start[34], 2);
    TextDrawFont(TabletWin8Start[34], 1);
    TextDrawLetterSize(TabletWin8Start[34], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[34], -1);
    TextDrawSetOutline(TabletWin8Start[34], 0);
    TextDrawSetProportional(TabletWin8Start[34], 1);
    TextDrawSetShadow(TabletWin8Start[34], 0);
    TextDrawTextSize(TabletWin8Start[34], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[34], 1);

    TabletWin8Start[35] = TextDrawCreate(273.000000, 198.000000, "Clock");
    TextDrawBackgroundColor(TabletWin8Start[35], 255);
    TextDrawAlignment(TabletWin8Start[35], 2);
    TextDrawFont(TabletWin8Start[35], 1);
    TextDrawLetterSize(TabletWin8Start[35], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[35], -1);
    TextDrawSetOutline(TabletWin8Start[35], 0);
    TextDrawSetProportional(TabletWin8Start[35], 1);
    TextDrawSetShadow(TabletWin8Start[35], 0);
    TextDrawTextSize(TabletWin8Start[35], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[35], 1);

    TabletWin8Start[36] = TextDrawCreate(273.000000, 246.000000, "Photos");
    TextDrawBackgroundColor(TabletWin8Start[36], 255);
    TextDrawAlignment(TabletWin8Start[36], 2);
    TextDrawFont(TabletWin8Start[36], 1);
    TextDrawLetterSize(TabletWin8Start[36], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[36], -1);
    TextDrawSetOutline(TabletWin8Start[36], 0);
    TextDrawSetProportional(TabletWin8Start[36], 1);
    TextDrawSetShadow(TabletWin8Start[36], 0);
    TextDrawTextSize(TabletWin8Start[36], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[36], 1);

    TabletWin8Start[37] = TextDrawCreate(273.000000, 291.000000, "Finanzes");
    TextDrawBackgroundColor(TabletWin8Start[37], 255);
    TextDrawAlignment(TabletWin8Start[37], 2);
    TextDrawFont(TabletWin8Start[37], 1);
    TextDrawLetterSize(TabletWin8Start[37], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[37], -1);
    TextDrawSetOutline(TabletWin8Start[37], 0);
    TextDrawSetProportional(TabletWin8Start[37], 1);
    TextDrawSetShadow(TabletWin8Start[37], 0);
    TextDrawTextSize(TabletWin8Start[37], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[37], 1);

    TabletWin8Start[38] = TextDrawCreate(273.000000, 338.000000, "Weather");
    TextDrawBackgroundColor(TabletWin8Start[38], 255);
    TextDrawAlignment(TabletWin8Start[38], 2);
    TextDrawFont(TabletWin8Start[38], 1);
    TextDrawLetterSize(TabletWin8Start[38], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[38], -1);
    TextDrawSetOutline(TabletWin8Start[38], 0);
    TextDrawSetProportional(TabletWin8Start[38], 1);
    TextDrawSetShadow(TabletWin8Start[38], 0);
    TextDrawTextSize(TabletWin8Start[38], 10, 55);
    TextDrawSetSelectable(TabletWin8Start[38], 1);

    TabletWin8Start[39] = TextDrawCreate(324.000000, 198.000000, "IE");
    TextDrawBackgroundColor(TabletWin8Start[39], 255);
    TextDrawAlignment(TabletWin8Start[39], 2);
    TextDrawFont(TabletWin8Start[39], 1);
    TextDrawLetterSize(TabletWin8Start[39], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[39], -1);
    TextDrawSetOutline(TabletWin8Start[39], 0);
    TextDrawSetProportional(TabletWin8Start[39], 1);
    TextDrawSetShadow(TabletWin8Start[39], 0);
    TextDrawTextSize(TabletWin8Start[39], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[39], 1);

    TabletWin8Start[40] = TextDrawCreate(333.000000, 245.000000, "Maps");
    TextDrawBackgroundColor(TabletWin8Start[40], 255);
    TextDrawAlignment(TabletWin8Start[40], 2);
    TextDrawFont(TabletWin8Start[40], 1);
    TextDrawLetterSize(TabletWin8Start[40], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[40], -1);
    TextDrawSetOutline(TabletWin8Start[40], 0);
    TextDrawSetProportional(TabletWin8Start[40], 1);
    TextDrawSetShadow(TabletWin8Start[40], 0);
    TextDrawTextSize(TabletWin8Start[40], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[40], 1);

    TabletWin8Start[41] = TextDrawCreate(341.000000, 291.000000, "Sports");
    TextDrawBackgroundColor(TabletWin8Start[41], 255);
    TextDrawAlignment(TabletWin8Start[41], 2);
    TextDrawFont(TabletWin8Start[41], 1);
    TextDrawLetterSize(TabletWin8Start[41], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[41], -1);
    TextDrawSetOutline(TabletWin8Start[41], 0);
    TextDrawSetProportional(TabletWin8Start[41], 1);
    TextDrawSetShadow(TabletWin8Start[41], 0);
    TextDrawTextSize(TabletWin8Start[41], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[41], 1);

    TabletWin8Start[42] = TextDrawCreate(339.000000, 338.000000, "News");
    TextDrawBackgroundColor(TabletWin8Start[42], 255);
    TextDrawAlignment(TabletWin8Start[42], 2);
    TextDrawFont(TabletWin8Start[42], 1);
    TextDrawLetterSize(TabletWin8Start[42], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[42], -1);
    TextDrawSetOutline(TabletWin8Start[42], 0);
    TextDrawSetProportional(TabletWin8Start[42], 1);
    TextDrawSetShadow(TabletWin8Start[42], 0);
    TextDrawTextSize(TabletWin8Start[42], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[42], 1);

    TabletWin8Start[43] = TextDrawCreate(371.000000, 198.000000, "Store");
    TextDrawBackgroundColor(TabletWin8Start[43], 255);
    TextDrawAlignment(TabletWin8Start[43], 2);
    TextDrawFont(TabletWin8Start[43], 1);
    TextDrawLetterSize(TabletWin8Start[43], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[43], -1);
    TextDrawSetOutline(TabletWin8Start[43], 0);
    TextDrawSetProportional(TabletWin8Start[43], 1);
    TextDrawSetShadow(TabletWin8Start[43], 0);
    TextDrawTextSize(TabletWin8Start[43], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[43], 1);

    TabletWin8Start[44] = TextDrawCreate(371.000000, 245.000000, "SkyDw");
    TextDrawBackgroundColor(TabletWin8Start[44], 255);
    TextDrawAlignment(TabletWin8Start[44], 2);
    TextDrawFont(TabletWin8Start[44], 1);
    TextDrawLetterSize(TabletWin8Start[44], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[44], -1);
    TextDrawSetOutline(TabletWin8Start[44], 0);
    TextDrawSetProportional(TabletWin8Start[44], 1);
    TextDrawSetShadow(TabletWin8Start[44], 0);
    TextDrawTextSize(TabletWin8Start[44], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[44], 1);

    TabletWin8Start[45] = TextDrawCreate(435.000000, 198.000000, "Bing");
    TextDrawBackgroundColor(TabletWin8Start[45], 255);
    TextDrawAlignment(TabletWin8Start[45], 2);
    TextDrawFont(TabletWin8Start[45], 1);
    TextDrawLetterSize(TabletWin8Start[45], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[45], -1);
    TextDrawSetOutline(TabletWin8Start[45], 0);
    TextDrawSetProportional(TabletWin8Start[45], 1);
    TextDrawSetShadow(TabletWin8Start[45], 0);
    TextDrawTextSize(TabletWin8Start[45], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[45], 1);

    TabletWin8Start[46] = TextDrawCreate(440.000000, 245.000000, "Travels");
    TextDrawBackgroundColor(TabletWin8Start[46], 255);
    TextDrawAlignment(TabletWin8Start[46], 2);
    TextDrawFont(TabletWin8Start[46], 1);
    TextDrawLetterSize(TabletWin8Start[46], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[46], -1);
    TextDrawSetOutline(TabletWin8Start[46], 0);
    TextDrawSetProportional(TabletWin8Start[46], 1);
    TextDrawSetShadow(TabletWin8Start[46], 0);
    TextDrawTextSize(TabletWin8Start[46], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[46], 1);

    TabletWin8Start[47] = TextDrawCreate(436.000000, 293.000000, "Games");
    TextDrawBackgroundColor(TabletWin8Start[47], 255);
    TextDrawAlignment(TabletWin8Start[47], 2);
    TextDrawFont(TabletWin8Start[47], 1);
    TextDrawLetterSize(TabletWin8Start[47], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[47], -1);
    TextDrawSetOutline(TabletWin8Start[47], 0);
    TextDrawSetProportional(TabletWin8Start[47], 1);
    TextDrawSetShadow(TabletWin8Start[47], 0);
    TextDrawTextSize(TabletWin8Start[47], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[47], 1);

    TabletWin8Start[48] = TextDrawCreate(474.000000, 293.000000, "Camera");
    TextDrawBackgroundColor(TabletWin8Start[48], 255);
    TextDrawAlignment(TabletWin8Start[48], 2);
    TextDrawFont(TabletWin8Start[48], 1);
    TextDrawLetterSize(TabletWin8Start[48], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[48], -1);
    TextDrawSetOutline(TabletWin8Start[48], 0);
    TextDrawSetProportional(TabletWin8Start[48], 1);
    TextDrawSetShadow(TabletWin8Start[48], 0);
    TextDrawTextSize(TabletWin8Start[48], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[48], 1);

    TabletWin8Start[49] = TextDrawCreate(436.000000, 338.000000, "Music");
    TextDrawBackgroundColor(TabletWin8Start[49], 255);
    TextDrawAlignment(TabletWin8Start[49], 2);
    TextDrawFont(TabletWin8Start[49], 1);
    TextDrawLetterSize(TabletWin8Start[49], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[49], -1);
    TextDrawSetOutline(TabletWin8Start[49], 0);
    TextDrawSetProportional(TabletWin8Start[49], 1);
    TextDrawSetShadow(TabletWin8Start[49], 0);
    TextDrawTextSize(TabletWin8Start[49], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[49], 1);

    TabletWin8Start[50] = TextDrawCreate(473.000000, 338.000000, "Video");
    TextDrawBackgroundColor(TabletWin8Start[50], 255);
    TextDrawAlignment(TabletWin8Start[50], 2);
    TextDrawFont(TabletWin8Start[50], 1);
    TextDrawLetterSize(TabletWin8Start[50], 0.300000, 1.200000);
    TextDrawColor(TabletWin8Start[50], -1);
    TextDrawSetOutline(TabletWin8Start[50], 0);
    TextDrawSetProportional(TabletWin8Start[50], 1);
    TextDrawSetShadow(TabletWin8Start[50], 0);
    TextDrawTextSize(TabletWin8Start[50], 10, 40);
    TextDrawSetSelectable(TabletWin8Start[50], 1);

    //PAGES [ESTE]
    TabletWin8Pag[0] = TextDrawCreate(152.000000, 143.000000, "_");
    TextDrawBackgroundColor(TabletWin8Pag[0], 255);
    TextDrawFont(TabletWin8Pag[0], 1);
    TextDrawLetterSize(TabletWin8Pag[0], 0.600000, 23.200004);
    TextDrawColor(TabletWin8Pag[0], -1);
    TextDrawSetOutline(TabletWin8Pag[0], 0);
    TextDrawSetProportional(TabletWin8Pag[0], 1);
    TextDrawSetShadow(TabletWin8Pag[0], 1);
    TextDrawUseBox(TabletWin8Pag[0], 1);
    TextDrawBoxColor(TabletWin8Pag[0], -859006465);
    TextDrawTextSize(TabletWin8Pag[0], 517.000000, 80.000000);
    TextDrawSetSelectable(TabletWin8Pag[0], 0);

    TabletWin8Pag[1] = TextDrawCreate(328.000000, 262.000000, "information: this filterscript is under construction~n~~n~BY IORP");
    TextDrawAlignment(TabletWin8Pag[1], 2);
    TextDrawBackgroundColor(TabletWin8Pag[1], 255);
    TextDrawFont(TabletWin8Pag[1], 1);
    TextDrawLetterSize(TabletWin8Pag[1], 0.310000, 1.599999);
    TextDrawColor(TabletWin8Pag[1], -1);
    TextDrawSetOutline(TabletWin8Pag[1], 0);
    TextDrawSetProportional(TabletWin8Pag[1], 1);
    TextDrawSetShadow(TabletWin8Pag[1], 0);
    TextDrawUseBox(TabletWin8Pag[1], 1);
    TextDrawBoxColor(TabletWin8Pag[1], 255);
    TextDrawTextSize(TabletWin8Pag[1], 2.000000, 268.000000);
    TextDrawSetSelectable(TabletWin8Pag[1], 0);

    TabletWin8Pag[2] = TextDrawCreate(508.000000, 144.000000, "X");
    TextDrawAlignment(TabletWin8Pag[2], 2);
    TextDrawBackgroundColor(TabletWin8Pag[2], 255);
    TextDrawFont(TabletWin8Pag[2], 1);
    TextDrawLetterSize(TabletWin8Pag[2], 0.509999, 2.400000);
    TextDrawColor(TabletWin8Pag[2], -16776961);
    TextDrawSetOutline(TabletWin8Pag[2], 0);
    TextDrawSetProportional(TabletWin8Pag[2], 1);
    TextDrawSetShadow(TabletWin8Pag[2], 0);
    TextDrawTextSize(TabletWin8Pag[2], 20, 10);
    TextDrawSetSelectable(TabletWin8Pag[2], 1);
    //Fotos
    TabletPhotos[0] = TextDrawCreate(165.000000, 178.000000, "loadsc2:loadsc2");
    TextDrawAlignment(TabletPhotos[0], 2);
    TextDrawBackgroundColor(TabletPhotos[0], 255);
    TextDrawFont(TabletPhotos[0], 4);
    TextDrawLetterSize(TabletPhotos[0], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[0], -1);
    TextDrawSetOutline(TabletPhotos[0], 0);
    TextDrawSetProportional(TabletPhotos[0], 1);
    TextDrawSetShadow(TabletPhotos[0], 1);
    TextDrawUseBox(TabletPhotos[0], 1);
    TextDrawBoxColor(TabletPhotos[0], -1724671489);
    TextDrawTextSize(TabletPhotos[0], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[0], 0);

    TabletPhotos[1] = TextDrawCreate(246.000000, 178.000000, "loadsc1:loadsc1");
    TextDrawAlignment(TabletPhotos[1], 2);
    TextDrawBackgroundColor(TabletPhotos[1], 255);
    TextDrawFont(TabletPhotos[1], 4);
    TextDrawLetterSize(TabletPhotos[1], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[1], -1);
    TextDrawSetOutline(TabletPhotos[1], 0);
    TextDrawSetProportional(TabletPhotos[1], 1);
    TextDrawSetShadow(TabletPhotos[1], 1);
    TextDrawUseBox(TabletPhotos[1], 1);
    TextDrawBoxColor(TabletPhotos[1], -1724671489);
    TextDrawTextSize(TabletPhotos[1], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[1], 0);

    TabletPhotos[2] = TextDrawCreate(327.000000, 178.000000, "loadsc10:loadsc10");
    TextDrawAlignment(TabletPhotos[2], 2);
    TextDrawBackgroundColor(TabletPhotos[2], 255);
    TextDrawFont(TabletPhotos[2], 4);
    TextDrawLetterSize(TabletPhotos[2], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[2], -1);
    TextDrawSetOutline(TabletPhotos[2], 0);
    TextDrawSetProportional(TabletPhotos[2], 1);
    TextDrawSetShadow(TabletPhotos[2], 1);
    TextDrawUseBox(TabletPhotos[2], 1);
    TextDrawBoxColor(TabletPhotos[2], -1724671489);
    TextDrawTextSize(TabletPhotos[2], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[2], 0);

    TabletPhotos[3] = TextDrawCreate(409.000000, 178.000000, "loadsc11:loadsc11");
    TextDrawAlignment(TabletPhotos[3], 2);
    TextDrawBackgroundColor(TabletPhotos[3], 255);
    TextDrawFont(TabletPhotos[3], 4);
    TextDrawLetterSize(TabletPhotos[3], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[3], -1);
    TextDrawSetOutline(TabletPhotos[3], 0);
    TextDrawSetProportional(TabletPhotos[3], 1);
    TextDrawSetShadow(TabletPhotos[3], 1);
    TextDrawUseBox(TabletPhotos[3], 1);
    TextDrawBoxColor(TabletPhotos[3], -1724671489);
    TextDrawTextSize(TabletPhotos[3], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[3], 0);

    TabletPhotos[4] = TextDrawCreate(409.000000, 232.000000, "loadsc12:loadsc12");
    TextDrawAlignment(TabletPhotos[4], 2);
    TextDrawBackgroundColor(TabletPhotos[4], 255);
    TextDrawFont(TabletPhotos[4], 4);
    TextDrawLetterSize(TabletPhotos[4], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[4], -1);
    TextDrawSetOutline(TabletPhotos[4], 0);
    TextDrawSetProportional(TabletPhotos[4], 1);
    TextDrawSetShadow(TabletPhotos[4], 1);
    TextDrawUseBox(TabletPhotos[4], 1);
    TextDrawBoxColor(TabletPhotos[4], -1724671489);
    TextDrawTextSize(TabletPhotos[4], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[4], 0);

    TabletPhotos[5] = TextDrawCreate(327.000000, 232.000000, "loadsc13:loadsc13");
    TextDrawAlignment(TabletPhotos[5], 2);
    TextDrawBackgroundColor(TabletPhotos[5], 255);
    TextDrawFont(TabletPhotos[5], 4);
    TextDrawLetterSize(TabletPhotos[5], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[5], -1);
    TextDrawSetOutline(TabletPhotos[5], 0);
    TextDrawSetProportional(TabletPhotos[5], 1);
    TextDrawSetShadow(TabletPhotos[5], 1);
    TextDrawUseBox(TabletPhotos[5], 1);
    TextDrawBoxColor(TabletPhotos[5], -1724671489);
    TextDrawTextSize(TabletPhotos[5], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[5], 0);

    TabletPhotos[6] = TextDrawCreate(246.000000, 232.000000, "loadsc14:loadsc14");
    TextDrawAlignment(TabletPhotos[6], 2);
    TextDrawBackgroundColor(TabletPhotos[6], 255);
    TextDrawFont(TabletPhotos[6], 4);
    TextDrawLetterSize(TabletPhotos[6], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[6], -1);
    TextDrawSetOutline(TabletPhotos[6], 0);
    TextDrawSetProportional(TabletPhotos[6], 1);
    TextDrawSetShadow(TabletPhotos[6], 1);
    TextDrawUseBox(TabletPhotos[6], 1);
    TextDrawBoxColor(TabletPhotos[6], -1724671489);
    TextDrawTextSize(TabletPhotos[6], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[6], 0);

    TabletPhotos[7] = TextDrawCreate(165.000000, 232.000000, "loadsc3:loadsc3");
    TextDrawAlignment(TabletPhotos[7], 2);
    TextDrawBackgroundColor(TabletPhotos[7], 255);
    TextDrawFont(TabletPhotos[7], 4);
    TextDrawLetterSize(TabletPhotos[7], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[7], -1);
    TextDrawSetOutline(TabletPhotos[7], 0);
    TextDrawSetProportional(TabletPhotos[7], 1);
    TextDrawSetShadow(TabletPhotos[7], 1);
    TextDrawUseBox(TabletPhotos[7], 1);
    TextDrawBoxColor(TabletPhotos[7], -1724671489);
    TextDrawTextSize(TabletPhotos[7], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[7], 0);

    TabletPhotos[8] = TextDrawCreate(165.000000, 289.000000, "loadsc4:loadsc4");
    TextDrawAlignment(TabletPhotos[8], 2);
    TextDrawBackgroundColor(TabletPhotos[8], 255);
    TextDrawFont(TabletPhotos[8], 4);
    TextDrawLetterSize(TabletPhotos[8], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[8], -1);
    TextDrawSetOutline(TabletPhotos[8], 0);
    TextDrawSetProportional(TabletPhotos[8], 1);
    TextDrawSetShadow(TabletPhotos[8], 1);
    TextDrawUseBox(TabletPhotos[8], 1);
    TextDrawBoxColor(TabletPhotos[8], -1724671489);
    TextDrawTextSize(TabletPhotos[8], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[8], 0);

    TabletPhotos[9] = TextDrawCreate(247.000000, 289.000000, "loadsc5:loadsc5");
    TextDrawAlignment(TabletPhotos[9], 2);
    TextDrawBackgroundColor(TabletPhotos[9], 255);
    TextDrawFont(TabletPhotos[9], 4);
    TextDrawLetterSize(TabletPhotos[9], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[9], -1);
    TextDrawSetOutline(TabletPhotos[9], 0);
    TextDrawSetProportional(TabletPhotos[9], 1);
    TextDrawSetShadow(TabletPhotos[9], 1);
    TextDrawUseBox(TabletPhotos[9], 1);
    TextDrawBoxColor(TabletPhotos[9], -1724671489);
    TextDrawTextSize(TabletPhotos[9], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[9], 0);

    TabletPhotos[10] = TextDrawCreate(327.000000, 289.000000, "loadsc6:loadsc6");
    TextDrawAlignment(TabletPhotos[10], 2);
    TextDrawBackgroundColor(TabletPhotos[10], 255);
    TextDrawFont(TabletPhotos[10], 4);
    TextDrawLetterSize(TabletPhotos[10], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[10], -1);
    TextDrawSetOutline(TabletPhotos[10], 0);
    TextDrawSetProportional(TabletPhotos[10], 1);
    TextDrawSetShadow(TabletPhotos[10], 1);
    TextDrawUseBox(TabletPhotos[10], 1);
    TextDrawBoxColor(TabletPhotos[10], -1724671489);
    TextDrawTextSize(TabletPhotos[10], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[10], 0);

    TabletPhotos[11] = TextDrawCreate(410.000000, 289.000000, "loadsc7:loadsc7");
    TextDrawAlignment(TabletPhotos[11], 2);
    TextDrawBackgroundColor(TabletPhotos[11], 255);
    TextDrawFont(TabletPhotos[11], 4);
    TextDrawLetterSize(TabletPhotos[11], 0.500000, 0.299998);
    TextDrawColor(TabletPhotos[11], -1);
    TextDrawSetOutline(TabletPhotos[11], 0);
    TextDrawSetProportional(TabletPhotos[11], 1);
    TextDrawSetShadow(TabletPhotos[11], 1);
    TextDrawUseBox(TabletPhotos[11], 1);
    TextDrawBoxColor(TabletPhotos[11], -1724671489);
    TextDrawTextSize(TabletPhotos[11], 72.000000, 42.000000);
    TextDrawSetSelectable(TabletPhotos[11], 0);

    //Music Player
    TabletMusicPlayer[0] = TextDrawCreate(330.000000, 184.000000, "PSY - Gangnam Style");
    TextDrawAlignment(TabletMusicPlayer[0], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[0], 255);
    TextDrawFont(TabletMusicPlayer[0], 1);
    TextDrawLetterSize(TabletMusicPlayer[0], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[0], -1);
    TextDrawSetOutline(TabletMusicPlayer[0], 0);
    TextDrawSetProportional(TabletMusicPlayer[0], 1);
    TextDrawSetShadow(TabletMusicPlayer[0], 0);
    TextDrawTextSize(TabletMusicPlayer[0], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[0], 1);

    TabletMusicPlayer[1] = TextDrawCreate(330.000000, 198.000000, "Eric Prydz - Pjanoo");
    TextDrawAlignment(TabletMusicPlayer[1], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[1], 255);
    TextDrawFont(TabletMusicPlayer[1], 1);
    TextDrawLetterSize(TabletMusicPlayer[1], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[1], -1);
    TextDrawSetOutline(TabletMusicPlayer[1], 0);
    TextDrawSetProportional(TabletMusicPlayer[1], 1);
    TextDrawSetShadow(TabletMusicPlayer[1], 0);
    TextDrawTextSize(TabletMusicPlayer[1], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[1], 1);

    TabletMusicPlayer[2] = TextDrawCreate(330.000000, 211.000000, "Tacabro - Tacata");
    TextDrawAlignment(TabletMusicPlayer[2], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[2], 255);
    TextDrawFont(TabletMusicPlayer[2], 1);
    TextDrawLetterSize(TabletMusicPlayer[2], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[2], -1);
    TextDrawSetOutline(TabletMusicPlayer[2], 0);
    TextDrawSetProportional(TabletMusicPlayer[2], 1);
    TextDrawSetShadow(TabletMusicPlayer[2], 0);
    TextDrawTextSize(TabletMusicPlayer[2], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[2], 1);

    TabletMusicPlayer[3] = TextDrawCreate(330.000000, 225.000000, "P Holla - Do it for love");
    TextDrawAlignment(TabletMusicPlayer[3], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[3], 255);
    TextDrawFont(TabletMusicPlayer[3], 1);
    TextDrawLetterSize(TabletMusicPlayer[3], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[3], -1);
    TextDrawSetOutline(TabletMusicPlayer[3], 0);
    TextDrawSetProportional(TabletMusicPlayer[3], 1);
    TextDrawSetShadow(TabletMusicPlayer[3], 0);
    TextDrawTextSize(TabletMusicPlayer[3], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[3], 1);

    TabletMusicPlayer[4] = TextDrawCreate(330.000000, 238.000000, "Gustavo Lima - Balada Boa");
    TextDrawAlignment(TabletMusicPlayer[4], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[4], 255);
    TextDrawFont(TabletMusicPlayer[4], 1);
    TextDrawLetterSize(TabletMusicPlayer[4], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[4], -1);
    TextDrawSetOutline(TabletMusicPlayer[4], 0);
    TextDrawSetProportional(TabletMusicPlayer[4], 1);
    TextDrawSetShadow(TabletMusicPlayer[4], 0);
    TextDrawTextSize(TabletMusicPlayer[4], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[4], 1);

    TabletMusicPlayer[5] = TextDrawCreate(330.000000, 251.000000, "LMFAO - Party Rock");
    TextDrawAlignment(TabletMusicPlayer[5], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[5], 255);
    TextDrawFont(TabletMusicPlayer[5], 1);
    TextDrawLetterSize(TabletMusicPlayer[5], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[5], -1);
    TextDrawSetOutline(TabletMusicPlayer[5], 0);
    TextDrawSetProportional(TabletMusicPlayer[5], 1);
    TextDrawSetShadow(TabletMusicPlayer[5], 0);
    TextDrawTextSize(TabletMusicPlayer[5], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[5], 1);

    TabletMusicPlayer[6] = TextDrawCreate(330.000000, 265.000000, "LMFAO - Sexy and I know");
    TextDrawAlignment(TabletMusicPlayer[6], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[6], 255);
    TextDrawFont(TabletMusicPlayer[6], 1);
    TextDrawLetterSize(TabletMusicPlayer[6], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[6], -1);
    TextDrawSetOutline(TabletMusicPlayer[6], 0);
    TextDrawSetProportional(TabletMusicPlayer[6], 1);
    TextDrawSetShadow(TabletMusicPlayer[6], 0);
    TextDrawTextSize(TabletMusicPlayer[6], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[6], 1);

    TabletMusicPlayer[7] = TextDrawCreate(330.000000, 279.000000, "Played a live - Safari Duo");
    TextDrawAlignment(TabletMusicPlayer[7], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[7], 255);
    TextDrawFont(TabletMusicPlayer[7], 1);
    TextDrawLetterSize(TabletMusicPlayer[7], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[7], -1);
    TextDrawSetOutline(TabletMusicPlayer[7], 0);
    TextDrawSetProportional(TabletMusicPlayer[7], 1);
    TextDrawSetShadow(TabletMusicPlayer[7], 0);
    TextDrawTextSize(TabletMusicPlayer[7], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[7], 1);

    TabletMusicPlayer[8] = TextDrawCreate(330.000000, 293.000000, "Guru Josh Project - Infinity");
    TextDrawAlignment(TabletMusicPlayer[8], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[8], 255);
    TextDrawFont(TabletMusicPlayer[8], 1);
    TextDrawLetterSize(TabletMusicPlayer[8], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[8], -1);
    TextDrawSetOutline(TabletMusicPlayer[8], 0);
    TextDrawSetProportional(TabletMusicPlayer[8], 1);
    TextDrawSetShadow(TabletMusicPlayer[8], 0);
    TextDrawTextSize(TabletMusicPlayer[8], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[8], 1);

    TabletMusicPlayer[9] = TextDrawCreate(330.000000, 307.000000, "Quiero rayos de sol - Jose..");
    TextDrawAlignment(TabletMusicPlayer[9], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[9], 255);
    TextDrawFont(TabletMusicPlayer[9], 1);
    TextDrawLetterSize(TabletMusicPlayer[9], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[9], -1);
    TextDrawSetOutline(TabletMusicPlayer[9], 0);
    TextDrawSetProportional(TabletMusicPlayer[9], 1);
    TextDrawSetShadow(TabletMusicPlayer[9], 0);
    TextDrawTextSize(TabletMusicPlayer[9], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[9], 1);

    TabletMusicPlayer[10] = TextDrawCreate(330.000000, 321.000000, "II");
    TextDrawAlignment(TabletMusicPlayer[10], 2);
    TextDrawBackgroundColor(TabletMusicPlayer[10], 255);
    TextDrawFont(TabletMusicPlayer[10], 1);
    TextDrawLetterSize(TabletMusicPlayer[10], 0.460000, 1.500000);
    TextDrawColor(TabletMusicPlayer[10], -1);
    TextDrawSetOutline(TabletMusicPlayer[10], 0);
    TextDrawSetProportional(TabletMusicPlayer[10], 1);
    TextDrawSetShadow(TabletMusicPlayer[10], 0);
    TextDrawTextSize(TabletMusicPlayer[10], 10.000000, 250.000000);
    TextDrawSetSelectable(TabletMusicPlayer[10], 1);

    //TwoBut
    TwoBut[0] = TextDrawCreate(149.000000, 139.000000, "_");
    TextDrawBackgroundColor(TwoBut[0], 255);
    TextDrawFont(TwoBut[0], 1);
    TextDrawLetterSize(TwoBut[0], 0.500000, 24.200000);
    TextDrawColor(TwoBut[0], -1);
    TextDrawSetOutline(TwoBut[0], 0);
    TextDrawSetProportional(TwoBut[0], 1);
    TextDrawSetShadow(TwoBut[0], 1);
    TextDrawUseBox(TwoBut[0], 1);
    TextDrawBoxColor(TwoBut[0], 842150655);
    TextDrawTextSize(TwoBut[0], 522.000000, 30.000000);
    TextDrawSetSelectable(TwoBut[0], 0);

    TwoBut[1] = TextDrawCreate(526.000000, 238.000000, "LD_BEAT:square");
    TextDrawAlignment(TwoBut[1], 2);
    TextDrawBackgroundColor(TwoBut[1], 255);
    TextDrawFont(TwoBut[1], 4);
    TextDrawLetterSize(TwoBut[1], 0.460000, 1.700000);
    TextDrawColor(TwoBut[1], -1);
    TextDrawSetOutline(TwoBut[1], 0);
    TextDrawSetProportional(TwoBut[1], 1);
    TextDrawSetShadow(TwoBut[1], 0);
    TextDrawUseBox(TwoBut[1], 1);
    TextDrawBoxColor(TwoBut[1], 255);
    TextDrawTextSize(TwoBut[1], 18.000000, 22.000000);
    TextDrawSetSelectable(TwoBut[1], 1);

    //Camara TextDraw
    CameraTD[0] = TextDrawCreate(122.000000, 93.000000, "O____________iiO~n~~n~~n~O____________iiO~n~~n~~n~O____________iiO");
    TextDrawBackgroundColor(CameraTD[0], 255);
    TextDrawFont(CameraTD[0], 1);
    TextDrawLetterSize(CameraTD[0], 1.600000, 8.299999);
    TextDrawColor(CameraTD[0], 255);
    TextDrawSetOutline(CameraTD[0], 1);
    TextDrawSetProportional(CameraTD[0], 1);
    TextDrawSetSelectable(CameraTD[0], 0);

    CameraTD[1] = TextDrawCreate(122.000000, 132.000000, "_");
    TextDrawBackgroundColor(CameraTD[1], 255);
    TextDrawFont(CameraTD[1], 1);
    TextDrawLetterSize(CameraTD[1], 0.050000, 24.400005);
    TextDrawColor(CameraTD[1], -1);
    TextDrawSetOutline(CameraTD[1], 0);
    TextDrawSetProportional(CameraTD[1], 1);
    TextDrawSetShadow(CameraTD[1], 1);
    TextDrawUseBox(CameraTD[1], 1);
    TextDrawBoxColor(CameraTD[1], 255);
    TextDrawTextSize(CameraTD[1], 146.000000, 10.000000);
    TextDrawSetSelectable(CameraTD[1], 0);

    CameraTD[2] = TextDrawCreate(120.000000, 387.000000, "hud:radardisc");
    TextDrawBackgroundColor(CameraTD[2], 255);
    TextDrawFont(CameraTD[2], 4);
    TextDrawLetterSize(CameraTD[2], 0.500000, 1.000000);
    TextDrawColor(CameraTD[2], -1);
    TextDrawSetOutline(CameraTD[2], 0);
    TextDrawSetProportional(CameraTD[2], 1);
    TextDrawSetShadow(CameraTD[2], 1);
    TextDrawUseBox(CameraTD[2], 1);
    TextDrawBoxColor(CameraTD[2], 255);
    TextDrawTextSize(CameraTD[2], 27.000000, -33.000000);
    TextDrawSetSelectable(CameraTD[2], 0);

    CameraTD[3] = TextDrawCreate(551.000000, 388.000000, "hud:radardisc");
    TextDrawBackgroundColor(CameraTD[3], 255);
    TextDrawFont(CameraTD[3], 4);
    TextDrawLetterSize(CameraTD[3], 0.500000, 1.000000);
    TextDrawColor(CameraTD[3], -1);
    TextDrawSetOutline(CameraTD[3], 0);
    TextDrawSetProportional(CameraTD[3], 1);
    TextDrawSetShadow(CameraTD[3], 1);
    TextDrawUseBox(CameraTD[3], 1);
    TextDrawBoxColor(CameraTD[3], 255);
    TextDrawTextSize(CameraTD[3], -27.000000, -33.000000);
    TextDrawSetSelectable(CameraTD[3], 0);

    CameraTD[4] = TextDrawCreate(551.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(CameraTD[4], 255);
    TextDrawFont(CameraTD[4], 4);
    TextDrawLetterSize(CameraTD[4], 0.500000, 1.000000);
    TextDrawColor(CameraTD[4], -1);
    TextDrawSetOutline(CameraTD[4], 0);
    TextDrawSetProportional(CameraTD[4], 1);
    TextDrawSetShadow(CameraTD[4], 1);
    TextDrawUseBox(CameraTD[4], 1);
    TextDrawBoxColor(CameraTD[4], 255);
    TextDrawTextSize(CameraTD[4], -27.000000, 33.000000);
    TextDrawSetSelectable(CameraTD[4], 0);

    CameraTD[5] = TextDrawCreate(120.000000, 104.000000, "hud:radardisc");
    TextDrawBackgroundColor(CameraTD[5], 255);
    TextDrawFont(CameraTD[5], 4);
    TextDrawLetterSize(CameraTD[5], 0.500000, 1.000000);
    TextDrawColor(CameraTD[5], -1);
    TextDrawSetOutline(CameraTD[5], 0);
    TextDrawSetProportional(CameraTD[5], 1);
    TextDrawSetShadow(CameraTD[5], 1);
    TextDrawUseBox(CameraTD[5], 1);
    TextDrawBoxColor(CameraTD[5], 255);
    TextDrawTextSize(CameraTD[5], 27.000000, 33.000000);
    TextDrawSetSelectable(CameraTD[5], 0);

    CameraTD[6] = TextDrawCreate(537.000000, 134.000000, "_");
    TextDrawAlignment(CameraTD[6], 2);
    TextDrawBackgroundColor(CameraTD[6], 255);
    TextDrawFont(CameraTD[6], 1);
    TextDrawLetterSize(CameraTD[6], 0.050000, 24.400005);
    TextDrawColor(CameraTD[6], -1);
    TextDrawSetOutline(CameraTD[6], 0);
    TextDrawSetProportional(CameraTD[6], 1);
    TextDrawSetShadow(CameraTD[6], 1);
    TextDrawUseBox(CameraTD[6], 1);
    TextDrawBoxColor(CameraTD[6], 255);
    TextDrawTextSize(CameraTD[6], 146.000000, 24.000000);
    TextDrawSetSelectable(CameraTD[6], 0);

    CameraTD[7] = TextDrawCreate(149.000000, 139.000000, "_");
    TextDrawBackgroundColor(CameraTD[7], 255);
    TextDrawFont(CameraTD[7], 1);
    TextDrawLetterSize(CameraTD[7], 0.470000, -0.099999);
    TextDrawColor(CameraTD[7], -1);
    TextDrawSetOutline(CameraTD[7], 0);
    TextDrawSetProportional(CameraTD[7], 1);
    TextDrawSetShadow(CameraTD[7], 1);
    TextDrawUseBox(CameraTD[7], 1);
    TextDrawBoxColor(CameraTD[7], 1711315455);
    TextDrawTextSize(CameraTD[7], 522.000000, 10.000000);
    TextDrawSetSelectable(CameraTD[7], 0);

    CameraTD[8] = TextDrawCreate(526.000000, 106.000000, "_");
    TextDrawBackgroundColor(CameraTD[8], 255);
    TextDrawFont(CameraTD[8], 1);
    TextDrawLetterSize(CameraTD[8], 0.060000, 3.200005);
    TextDrawColor(CameraTD[8], -1);
    TextDrawSetOutline(CameraTD[8], 0);
    TextDrawSetProportional(CameraTD[8], 1);
    TextDrawSetShadow(CameraTD[8], 1);
    TextDrawUseBox(CameraTD[8], 1);
    TextDrawBoxColor(CameraTD[8], 255);
    TextDrawTextSize(CameraTD[8], 145.000000, 10.000000);
    TextDrawSetSelectable(CameraTD[8], 0);

    CameraTD[9] = TextDrawCreate(526.000000, 355.000000, "_");
    TextDrawBackgroundColor(CameraTD[9], 255);
    TextDrawFont(CameraTD[9], 1);
    TextDrawLetterSize(CameraTD[9], 0.060000, 3.200005);
    TextDrawColor(CameraTD[9], -1);
    TextDrawSetOutline(CameraTD[9], 0);
    TextDrawSetProportional(CameraTD[9], 1);
    TextDrawSetShadow(CameraTD[9], 1);
    TextDrawUseBox(CameraTD[9], 1);
    TextDrawBoxColor(CameraTD[9], 255);
    TextDrawTextSize(CameraTD[9], 145.000000, 10.000000);
    TextDrawSetSelectable(CameraTD[9], 0);

    CameraTD[10] = TextDrawCreate(149.000000, 352.000000, "_");
    TextDrawBackgroundColor(CameraTD[10], 255);
    TextDrawFont(CameraTD[10], 1);
    TextDrawLetterSize(CameraTD[10], 0.470000, -0.099999);
    TextDrawColor(CameraTD[10], -1);
    TextDrawSetOutline(CameraTD[10], 0);
    TextDrawSetProportional(CameraTD[10], 1);
    TextDrawSetShadow(CameraTD[10], 1);
    TextDrawUseBox(CameraTD[10], 1);
    TextDrawBoxColor(CameraTD[10], 1711315455);
    TextDrawTextSize(CameraTD[10], 522.000000, 10.000000);
    TextDrawSetSelectable(CameraTD[10], 0);

    CameraTD[11] = TextDrawCreate(152.000000, 334.000000, "_");
    TextDrawBackgroundColor(CameraTD[11], 255);
    TextDrawFont(CameraTD[11], 1);
    TextDrawLetterSize(CameraTD[11], 0.570000, 1.400006);
    TextDrawColor(CameraTD[11], -1);
    TextDrawSetOutline(CameraTD[11], 0);
    TextDrawSetProportional(CameraTD[11], 1);
    TextDrawSetShadow(CameraTD[11], 1);
    TextDrawUseBox(CameraTD[11], 1);
    TextDrawBoxColor(CameraTD[11], -859006465);
    TextDrawTextSize(CameraTD[11], 518.000000, 80.000000);
    TextDrawSetSelectable(CameraTD[11], 0);

    CameraTD[12] = TextDrawCreate(149.000000, 142.000000, "_");
    TextDrawBackgroundColor(CameraTD[12], 255);
    TextDrawFont(CameraTD[12], 1);
    TextDrawLetterSize(CameraTD[12], 0.470000, 23.000007);
    TextDrawColor(CameraTD[12], -1);
    TextDrawSetOutline(CameraTD[12], 0);
    TextDrawSetProportional(CameraTD[12], 1);
    TextDrawSetShadow(CameraTD[12], 1);
    TextDrawUseBox(CameraTD[12], 1);
    TextDrawBoxColor(CameraTD[12], 1711315455);
    TextDrawTextSize(CameraTD[12], 148.000000, 20.000000);
    TextDrawSetSelectable(CameraTD[12], 0);

    CameraTD[13] = TextDrawCreate(526.000000, 141.000000, "_");
    TextDrawBackgroundColor(CameraTD[13], 255);
    TextDrawFont(CameraTD[13], 1);
    TextDrawLetterSize(CameraTD[13], 0.470000, 23.000007);
    TextDrawColor(CameraTD[13], -1);
    TextDrawSetOutline(CameraTD[13], 0);
    TextDrawSetProportional(CameraTD[13], 1);
    TextDrawSetShadow(CameraTD[13], 1);
    TextDrawUseBox(CameraTD[13], 1);
    TextDrawBoxColor(CameraTD[13], 1711315455);
    TextDrawTextSize(CameraTD[13], 518.000000, 20.000000);
    TextDrawSetSelectable(CameraTD[13], 0);

    CameraTD[14] = TextDrawCreate(328.000000, 334.000000, "Press F8 to take photo, press Y to exit");
    TextDrawAlignment(CameraTD[14], 2);
    TextDrawBackgroundColor(CameraTD[14], 255);
    TextDrawFont(CameraTD[14], 1);
    TextDrawLetterSize(CameraTD[14], 0.309999, 1.200000);
    TextDrawColor(CameraTD[14], -1);
    TextDrawSetOutline(CameraTD[14], 0);
    TextDrawSetProportional(CameraTD[14], 1);
    TextDrawSetShadow(CameraTD[14], 0);
    TextDrawSetSelectable(CameraTD[14], 0);

    CameraTD[15] = TextDrawCreate(130.000000, 116.000000, "I");
    TextDrawBackgroundColor(CameraTD[15], 255);
    TextDrawFont(CameraTD[15], 1);
    TextDrawLetterSize(CameraTD[15], 1.970000, 2.299999);
    TextDrawColor(CameraTD[15], 255);
    TextDrawSetOutline(CameraTD[15], 0);
    TextDrawSetProportional(CameraTD[15], 1);
    TextDrawSetShadow(CameraTD[15], 0);
    TextDrawSetSelectable(CameraTD[15], 0);

    CameraTD[16] = TextDrawCreate(129.000000, 344.000000, "I");
    TextDrawBackgroundColor(CameraTD[16], 255);
    TextDrawFont(CameraTD[16], 1);
    TextDrawLetterSize(CameraTD[16], 1.970000, 4.199998);
    TextDrawColor(CameraTD[16], 255);
    TextDrawSetOutline(CameraTD[16], 0);
    TextDrawSetProportional(CameraTD[16], 1);
    TextDrawSetShadow(CameraTD[16], 0);
    TextDrawSetSelectable(CameraTD[16], 0);

    CameraTD[17] = TextDrawCreate(517.000000, 344.000000, "I");
    TextDrawBackgroundColor(CameraTD[17], 255);
    TextDrawFont(CameraTD[17], 1);
    TextDrawLetterSize(CameraTD[17], 1.970000, 4.199998);
    TextDrawColor(CameraTD[17], 255);
    TextDrawSetOutline(CameraTD[17], 0);
    TextDrawSetProportional(CameraTD[17], 1);
    TextDrawSetShadow(CameraTD[17], 0);
    TextDrawSetSelectable(CameraTD[17], 0);

    CameraTD[18] = TextDrawCreate(517.000000, 103.000000, "I");
    TextDrawBackgroundColor(CameraTD[18], 255);
    TextDrawFont(CameraTD[18], 1);
    TextDrawLetterSize(CameraTD[18], 1.970000, 4.199998);
    TextDrawColor(CameraTD[18], 255);
    TextDrawSetOutline(CameraTD[18], 0);
    TextDrawSetProportional(CameraTD[18], 1);
    TextDrawSetShadow(CameraTD[18], 0);
    TextDrawSetSelectable(CameraTD[18], 0);

    CameraTD[19] = TextDrawCreate(328.000000, 222.000000, "I");
    TextDrawBackgroundColor(CameraTD[19], 255);
    TextDrawFont(CameraTD[19], 1);
    TextDrawLetterSize(CameraTD[19], 0.210000, 3.299999);
    TextDrawColor(CameraTD[19], -1);
    TextDrawSetOutline(CameraTD[19], 0);
    TextDrawSetProportional(CameraTD[19], 1);
    TextDrawSetShadow(CameraTD[19], 0);
    TextDrawSetSelectable(CameraTD[19], 0);

    CameraTD[20] = TextDrawCreate(311.000000, 236.000000, "I");
    TextDrawBackgroundColor(CameraTD[20], 255);
    TextDrawFont(CameraTD[20], 1);
    TextDrawLetterSize(CameraTD[20], 2.999999, 0.299999);
    TextDrawColor(CameraTD[20], -1);
    TextDrawSetOutline(CameraTD[20], 0);
    TextDrawSetProportional(CameraTD[20], 1);
    TextDrawSetShadow(CameraTD[20], 0);
    TextDrawSetSelectable(CameraTD[20], 0);

    CameraTD[21] = TextDrawCreate(152.000000, 143.000000, "_");
    TextDrawBackgroundColor(CameraTD[21], 255);
    TextDrawFont(CameraTD[21], 1);
    TextDrawLetterSize(CameraTD[21], 0.570000, 1.400006);
    TextDrawColor(CameraTD[21], -1);
    TextDrawSetOutline(CameraTD[21], 0);
    TextDrawSetProportional(CameraTD[21], 1);
    TextDrawSetShadow(CameraTD[21], 1);
    TextDrawUseBox(CameraTD[21], 1);
    TextDrawBoxColor(CameraTD[21], -859006465);
    TextDrawTextSize(CameraTD[21], 518.000000, 80.000000);
    TextDrawSetSelectable(CameraTD[21], 0);

    CameraTD[22] = TextDrawCreate(328.000000, 141.000000, "CAMERA");
    TextDrawAlignment(CameraTD[22], 2);
    TextDrawBackgroundColor(CameraTD[22], 255);
    TextDrawFont(CameraTD[22], 1);
    TextDrawLetterSize(CameraTD[22], 0.459999, 1.600000);
    TextDrawColor(CameraTD[22], -1);
    TextDrawSetOutline(CameraTD[22], 0);
    TextDrawSetProportional(CameraTD[22], 1);
    TextDrawSetShadow(CameraTD[22], 0);
    TextDrawSetSelectable(CameraTD[22], 0);

    CameraTD[23] = TextDrawCreate(508.000000, 138.000000, "X");
    TextDrawAlignment(CameraTD[23], 2);
    TextDrawBackgroundColor(CameraTD[23], 255);
    TextDrawFont(CameraTD[23], 1);
    TextDrawLetterSize(CameraTD[23], 0.509998, 2.400000);
    TextDrawColor(CameraTD[23], -16776961);
    TextDrawSetOutline(CameraTD[23], 0);
    TextDrawSetProportional(CameraTD[23], 1);
    TextDrawSetShadow(CameraTD[23], 0);
    TextDrawSetSelectable(CameraTD[23], 1);

    //Maps TD
    MapsTD[0] = TextDrawCreate(250.000000, 182.000000, "samaps:gtasamapbit1");
    TextDrawAlignment(MapsTD[0], 2);
    TextDrawBackgroundColor(MapsTD[0], 255);
    TextDrawFont(MapsTD[0], 4);
    TextDrawLetterSize(MapsTD[0], 0.470000, 0.699999);
    TextDrawColor(MapsTD[0], -1);
    TextDrawSetOutline(MapsTD[0], 0);
    TextDrawSetProportional(MapsTD[0], 1);
    TextDrawSetShadow(MapsTD[0], 1);
    TextDrawUseBox(MapsTD[0], 1);
    TextDrawBoxColor(MapsTD[0], 255);
    TextDrawTextSize(MapsTD[0], 80.000000, 80.000000);
    TextDrawSetSelectable(MapsTD[0], 1);

    MapsTD[1] = TextDrawCreate(330.000000, 182.000000, "samaps:gtasamapbit2");
    TextDrawAlignment(MapsTD[1], 2);
    TextDrawBackgroundColor(MapsTD[1], 255);
    TextDrawFont(MapsTD[1], 4);
    TextDrawLetterSize(MapsTD[1], 0.470000, 0.699999);
    TextDrawColor(MapsTD[1], -1);
    TextDrawSetOutline(MapsTD[1], 0);
    TextDrawSetProportional(MapsTD[1], 1);
    TextDrawSetShadow(MapsTD[1], 1);
    TextDrawUseBox(MapsTD[1], 1);
    TextDrawBoxColor(MapsTD[1], 255);
    TextDrawTextSize(MapsTD[1], 80.000000, 80.000000);
    TextDrawSetSelectable(MapsTD[1], 1);

    MapsTD[2] = TextDrawCreate(250.000000, 262.000000, "samaps:gtasamapbit3");
    TextDrawAlignment(MapsTD[2], 2);
    TextDrawBackgroundColor(MapsTD[2], 255);
    TextDrawFont(MapsTD[2], 4);
    TextDrawLetterSize(MapsTD[2], 0.470000, 0.699999);
    TextDrawColor(MapsTD[2], -1);
    TextDrawSetOutline(MapsTD[2], 0);
    TextDrawSetProportional(MapsTD[2], 1);
    TextDrawSetShadow(MapsTD[2], 1);
    TextDrawUseBox(MapsTD[2], 1);
    TextDrawBoxColor(MapsTD[2], 255);
    TextDrawTextSize(MapsTD[2], 80.000000, 80.000000);
    TextDrawSetSelectable(MapsTD[2], 1);

    MapsTD[3] = TextDrawCreate(330.000000, 262.000000, "samaps:gtasamapbit4");
    TextDrawAlignment(MapsTD[3], 2);
    TextDrawBackgroundColor(MapsTD[3], 255);
    TextDrawFont(MapsTD[3], 4);
    TextDrawLetterSize(MapsTD[3], 0.470000, 0.699999);
    TextDrawColor(MapsTD[3], -1);
    TextDrawSetOutline(MapsTD[3], 0);
    TextDrawSetProportional(MapsTD[3], 1);
    TextDrawSetShadow(MapsTD[3], 1);
    TextDrawUseBox(MapsTD[3], 1);
    TextDrawBoxColor(MapsTD[3], 255);
    TextDrawTextSize(MapsTD[3], 80.000000, 80.000000);
    TextDrawSetSelectable(MapsTD[3], 1);

    MapsTD[4] = TextDrawCreate(250.000000, 182.000000, "samaps:gtasamapbit1");
    TextDrawAlignment(MapsTD[4], 2);
    TextDrawBackgroundColor(MapsTD[4], 255);
    TextDrawFont(MapsTD[4], 4);
    TextDrawLetterSize(MapsTD[4], 0.470000, 0.699999);
    TextDrawColor(MapsTD[4], -1);
    TextDrawSetOutline(MapsTD[4], 0);
    TextDrawSetProportional(MapsTD[4], 1);
    TextDrawSetShadow(MapsTD[4], 1);
    TextDrawUseBox(MapsTD[4], 1);
    TextDrawBoxColor(MapsTD[4], 255);
    TextDrawTextSize(MapsTD[4], 160.000000, 160.000000);
    TextDrawSetSelectable(MapsTD[4], 1);

    MapsTD[5] = TextDrawCreate(250.000000, 182.000000, "samaps:gtasamapbit2");
    TextDrawAlignment(MapsTD[5], 2);
    TextDrawBackgroundColor(MapsTD[5], 255);
    TextDrawFont(MapsTD[5], 4);
    TextDrawLetterSize(MapsTD[5], 0.470000, 0.699999);
    TextDrawColor(MapsTD[5], -1);
    TextDrawSetOutline(MapsTD[5], 0);
    TextDrawSetProportional(MapsTD[5], 1);
    TextDrawSetShadow(MapsTD[5], 1);
    TextDrawUseBox(MapsTD[5], 1);
    TextDrawBoxColor(MapsTD[5], 255);
    TextDrawTextSize(MapsTD[5], 160.000000, 160.000000);
    TextDrawSetSelectable(MapsTD[5], 1);

    MapsTD[6] = TextDrawCreate(250.000000, 182.000000, "samaps:gtasamapbit3");
    TextDrawAlignment(MapsTD[6], 2);
    TextDrawBackgroundColor(MapsTD[6], 255);
    TextDrawFont(MapsTD[6], 4);
    TextDrawLetterSize(MapsTD[6], 0.470000, 0.699999);
    TextDrawColor(MapsTD[6], -1);
    TextDrawSetOutline(MapsTD[6], 0);
    TextDrawSetProportional(MapsTD[6], 1);
    TextDrawSetShadow(MapsTD[6], 1);
    TextDrawUseBox(MapsTD[6], 1);
    TextDrawBoxColor(MapsTD[6], 255);
    TextDrawTextSize(MapsTD[6], 160.000000, 160.000000);
    TextDrawSetSelectable(MapsTD[6], 1);

    MapsTD[7] = TextDrawCreate(250.000000, 182.000000, "samaps:gtasamapbit4");
    TextDrawAlignment(MapsTD[7], 2);
    TextDrawBackgroundColor(MapsTD[7], 255);
    TextDrawFont(MapsTD[7], 4);
    TextDrawLetterSize(MapsTD[7], 0.470000, 0.699999);
    TextDrawColor(MapsTD[7], -1);
    TextDrawSetOutline(MapsTD[7], 0);
    TextDrawSetProportional(MapsTD[7], 1);
    TextDrawSetShadow(MapsTD[7], 1);
    TextDrawUseBox(MapsTD[7], 1);
    TextDrawBoxColor(MapsTD[7], 255);
    TextDrawTextSize(MapsTD[7], 160.000000, 160.000000);
    TextDrawSetSelectable(MapsTD[7], 1);

    //Games
    Games = TextDrawCreate(328.000000, 192.000000, "slot machine");
    TextDrawAlignment(Games, 2);
    TextDrawBackgroundColor(Games, 255);
    TextDrawFont(Games, 3);
    TextDrawLetterSize(Games, 0.450000, 1.600001);
    TextDrawColor(Games, -1);
    TextDrawSetOutline(Games, 0);
    TextDrawSetProportional(Games, 1);
    TextDrawSetShadow(Games, 0);
    TextDrawUseBox(Games, 1);
    TextDrawBoxColor(Games, 255);
    TextDrawTextSize(Games, 10.000000, 112.000000);
    TextDrawSetSelectable(Games, 1);

    //User loader [ESTE]
    TabletWin8UserLog[0] = TextDrawCreate(223.000000, 173.000000, "_");
    TextDrawAlignment(TabletWin8UserLog[0], 2);
    TextDrawBackgroundColor(TabletWin8UserLog[0], 255);
    TextDrawFont(TabletWin8UserLog[0], 1);
    TextDrawLetterSize(TabletWin8UserLog[0], 0.500000, 16.100004);
    TextDrawColor(TabletWin8UserLog[0], -1);
    TextDrawSetOutline(TabletWin8UserLog[0], 0);
    TextDrawSetProportional(TabletWin8UserLog[0], 1);
    TextDrawSetShadow(TabletWin8UserLog[0], 1);
    TextDrawUseBox(TabletWin8UserLog[0], 1);
    TextDrawBoxColor(TabletWin8UserLog[0], -859006465);
    TextDrawTextSize(TabletWin8UserLog[0], 0.000000, 112.000000);
    TextDrawSetSelectable(TabletWin8UserLog[0], 0);

    TabletWin8UserLog[1] = TextDrawCreate(217.000000, 151.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[1], 255);
    TextDrawFont(TabletWin8UserLog[1], 1);
    TextDrawLetterSize(TabletWin8UserLog[1], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[1], -1);
    TextDrawSetOutline(TabletWin8UserLog[1], 0);
    TextDrawSetProportional(TabletWin8UserLog[1], 1);
    TextDrawSetShadow(TabletWin8UserLog[1], 0);
    TextDrawSetSelectable(TabletWin8UserLog[1], 0);

    TabletWin8UserLog[2] = TextDrawCreate(211.000000, 196.000000, "I");
    TextDrawBackgroundColor(TabletWin8UserLog[2], 255);
    TextDrawFont(TabletWin8UserLog[2], 1);
    TextDrawLetterSize(TabletWin8UserLog[2], 1.700000, 7.299999);
    TextDrawColor(TabletWin8UserLog[2], -1);
    TextDrawSetOutline(TabletWin8UserLog[2], 0);
    TextDrawSetProportional(TabletWin8UserLog[2], 1);
    TextDrawSetShadow(TabletWin8UserLog[2], 0);
    TextDrawSetSelectable(TabletWin8UserLog[2], 0);

    TabletWin8UserLog[3] = TextDrawCreate(200.000000, 236.000000, "I");
    TextDrawBackgroundColor(TabletWin8UserLog[3], 255);
    TextDrawFont(TabletWin8UserLog[3], 1);
    TextDrawLetterSize(TabletWin8UserLog[3], 1.700000, 7.299999);
    TextDrawColor(TabletWin8UserLog[3], -1);
    TextDrawSetOutline(TabletWin8UserLog[3], 0);
    TextDrawSetProportional(TabletWin8UserLog[3], 1);
    TextDrawSetShadow(TabletWin8UserLog[3], 0);
    TextDrawSetSelectable(TabletWin8UserLog[3], 0);

    TabletWin8UserLog[4] = TextDrawCreate(223.000000, 236.000000, "I");
    TextDrawBackgroundColor(TabletWin8UserLog[4], 255);
    TextDrawFont(TabletWin8UserLog[4], 1);
    TextDrawLetterSize(TabletWin8UserLog[4], 1.700000, 7.299999);
    TextDrawColor(TabletWin8UserLog[4], -1);
    TextDrawSetOutline(TabletWin8UserLog[4], 0);
    TextDrawSetProportional(TabletWin8UserLog[4], 1);
    TextDrawSetShadow(TabletWin8UserLog[4], 0);
    TextDrawSetSelectable(TabletWin8UserLog[4], 0);

    TabletWin8UserLog[5] = TextDrawCreate(174.000000, 217.000000, "I");
    TextDrawBackgroundColor(TabletWin8UserLog[5], 255);
    TextDrawFont(TabletWin8UserLog[5], 1);
    TextDrawLetterSize(TabletWin8UserLog[5], 7.959995, 2.299999);
    TextDrawColor(TabletWin8UserLog[5], -1);
    TextDrawSetOutline(TabletWin8UserLog[5], 0);
    TextDrawSetProportional(TabletWin8UserLog[5], 1);
    TextDrawSetShadow(TabletWin8UserLog[5], 0);
    TextDrawSetSelectable(TabletWin8UserLog[5], 0);

    TabletWin8UserLog[6] = TextDrawCreate(208.000000, 157.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[6], 255);
    TextDrawFont(TabletWin8UserLog[6], 1);
    TextDrawLetterSize(TabletWin8UserLog[6], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[6], -1);
    TextDrawSetOutline(TabletWin8UserLog[6], 0);
    TextDrawSetProportional(TabletWin8UserLog[6], 1);
    TextDrawSetShadow(TabletWin8UserLog[6], 0);
    TextDrawSetSelectable(TabletWin8UserLog[6], 0);

    TabletWin8UserLog[7] = TextDrawCreate(298.000000, 211.000000, "Loading...~n~ Homepage");
    TextDrawBackgroundColor(TabletWin8UserLog[7], 255);
    TextDrawFont(TabletWin8UserLog[7], 1);
    TextDrawLetterSize(TabletWin8UserLog[7], 0.580000, 2.600000);
    TextDrawColor(TabletWin8UserLog[7], -1);
    TextDrawSetOutline(TabletWin8UserLog[7], 0);
    TextDrawSetProportional(TabletWin8UserLog[7], 1);
    TextDrawSetShadow(TabletWin8UserLog[7], 0);
    TextDrawSetSelectable(TabletWin8UserLog[7], 0);

    TabletWin8UserLog[8] = TextDrawCreate(208.000000, 170.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[8], 255);
    TextDrawFont(TabletWin8UserLog[8], 1);
    TextDrawLetterSize(TabletWin8UserLog[8], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[8], -1);
    TextDrawSetOutline(TabletWin8UserLog[8], 0);
    TextDrawSetProportional(TabletWin8UserLog[8], 1);
    TextDrawSetShadow(TabletWin8UserLog[8], 0);
    TextDrawSetSelectable(TabletWin8UserLog[8], 0);

    TabletWin8UserLog[9] = TextDrawCreate(217.000000, 179.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[9], 255);
    TextDrawFont(TabletWin8UserLog[9], 1);
    TextDrawLetterSize(TabletWin8UserLog[9], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[9], -1);
    TextDrawSetOutline(TabletWin8UserLog[9], 0);
    TextDrawSetProportional(TabletWin8UserLog[9], 1);
    TextDrawSetShadow(TabletWin8UserLog[9], 0);
    TextDrawSetSelectable(TabletWin8UserLog[9], 0);

    TabletWin8UserLog[10] = TextDrawCreate(227.000000, 170.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[10], 255);
    TextDrawFont(TabletWin8UserLog[10], 1);
    TextDrawLetterSize(TabletWin8UserLog[10], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[10], -1);
    TextDrawSetOutline(TabletWin8UserLog[10], 0);
    TextDrawSetProportional(TabletWin8UserLog[10], 1);
    TextDrawSetShadow(TabletWin8UserLog[10], 0);
    TextDrawSetSelectable(TabletWin8UserLog[10], 0);

    TabletWin8UserLog[11] = TextDrawCreate(227.000000, 157.000000, ".");
    TextDrawBackgroundColor(TabletWin8UserLog[11], 255);
    TextDrawFont(TabletWin8UserLog[11], 1);
    TextDrawLetterSize(TabletWin8UserLog[11], 0.870000, 3.700000);
    TextDrawColor(TabletWin8UserLog[11], -1);
    TextDrawSetOutline(TabletWin8UserLog[11], 0);
    TextDrawSetProportional(TabletWin8UserLog[11], 1);
    TextDrawSetShadow(TabletWin8UserLog[11], 0);
    TextDrawSetSelectable(TabletWin8UserLog[11], 0);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    TabletWin8UserLog2 = CreatePlayerTextDraw(playerid, 223.000000, 303.000000, "NAME");
    PlayerTextDrawAlignment(playerid, TabletWin8UserLog2, 2);
    PlayerTextDrawBackgroundColor(playerid, TabletWin8UserLog2, 255);
    PlayerTextDrawFont(playerid, TabletWin8UserLog2, 1);
    PlayerTextDrawLetterSize(playerid, TabletWin8UserLog2, 0.500000, 1.400004);
    PlayerTextDrawColor(playerid, TabletWin8UserLog2, -1);
    PlayerTextDrawSetOutline(playerid, TabletWin8UserLog2, 0);
    PlayerTextDrawSetProportional(playerid, TabletWin8UserLog2, 1);
    PlayerTextDrawSetShadow(playerid, TabletWin8UserLog2, 1);
    PlayerTextDrawUseBox(playerid, TabletWin8UserLog2, 1);
    PlayerTextDrawBoxColor(playerid, TabletWin8UserLog2, 255);
    PlayerTextDrawTextSize(playerid, TabletWin8UserLog2, 0.000000, 110.000000);
    PlayerTextDrawSetSelectable(playerid, TabletWin8UserLog2, 0);
    //Escritorio [ESTE]
    Escritorio[0] = CreatePlayerTextDraw(playerid, 147.000000, 137.000000, "loadsc2:loadsc2");
    PlayerTextDrawAlignment(playerid, Escritorio[0], 2);
    PlayerTextDrawBackgroundColor(playerid, Escritorio[0], 255);
    PlayerTextDrawFont(playerid, Escritorio[0], 4);
    PlayerTextDrawLetterSize(playerid, Escritorio[0], 0.500000, 0.299998);
    PlayerTextDrawColor(playerid, Escritorio[0], -1);
    PlayerTextDrawSetOutline(playerid, Escritorio[0], 0);
    PlayerTextDrawSetProportional(playerid, Escritorio[0], 1);
    PlayerTextDrawSetShadow(playerid, Escritorio[0], 1);
    PlayerTextDrawUseBox(playerid, Escritorio[0], 1);
    PlayerTextDrawBoxColor(playerid, Escritorio[0], -1724671489);
    PlayerTextDrawTextSize(playerid, Escritorio[0], 377.000000, 223.000000);
    PlayerTextDrawSetSelectable(playerid, Escritorio[0], 0);

    Escritorio[1] = CreatePlayerTextDraw(playerid, 149.000000, 343.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, Escritorio[1], 255);
    PlayerTextDrawFont(playerid, Escritorio[1], 1);
    PlayerTextDrawLetterSize(playerid, Escritorio[1], 0.500000, 1.600000);
    PlayerTextDrawColor(playerid, Escritorio[1], -1);
    PlayerTextDrawSetOutline(playerid, Escritorio[1], 0);
    PlayerTextDrawSetProportional(playerid, Escritorio[1], 1);
    PlayerTextDrawSetShadow(playerid, Escritorio[1], 1);
    PlayerTextDrawUseBox(playerid, Escritorio[1], 1);
    PlayerTextDrawBoxColor(playerid, Escritorio[1], 869072895);
    PlayerTextDrawTextSize(playerid, Escritorio[1], 522.000000, 0.000000);
    PlayerTextDrawSetSelectable(playerid, Escritorio[1], 0);

    Escritorio[2] = CreatePlayerTextDraw(playerid, 475.000000, 343.000000, "00:00");
    PlayerTextDrawBackgroundColor(playerid, Escritorio[2], 255);
    PlayerTextDrawFont(playerid, Escritorio[2], 1);
    PlayerTextDrawLetterSize(playerid, Escritorio[2], 0.390000, 1.300000);
    PlayerTextDrawColor(playerid, Escritorio[2], -1);
    PlayerTextDrawSetOutline(playerid, Escritorio[2], 0);
    PlayerTextDrawSetProportional(playerid, Escritorio[2], 1);
    PlayerTextDrawSetShadow(playerid, Escritorio[2], 0);
    PlayerTextDrawSetSelectable(playerid, Escritorio[2], 0);

    Escritorio[3] = CreatePlayerTextDraw(playerid, 173.000000, 343.000000, "START");
    PlayerTextDrawAlignment(playerid, Escritorio[3], 2);
    PlayerTextDrawBackgroundColor(playerid, Escritorio[3], 255);
    PlayerTextDrawFont(playerid, Escritorio[3], 1);
    PlayerTextDrawLetterSize(playerid, Escritorio[3], 0.390000, 1.300000);
    PlayerTextDrawColor(playerid, Escritorio[3], -1);
    PlayerTextDrawSetOutline(playerid, Escritorio[3], 0);
    PlayerTextDrawSetProportional(playerid, Escritorio[3], 1);
    PlayerTextDrawSetShadow(playerid, Escritorio[3], 0);
    PlayerTextDrawTextSize(playerid, Escritorio[3], 10.000000, 30.000000);
    PlayerTextDrawSetSelectable(playerid, Escritorio[3], 1);

    //Tablet Time [ESTE]
    TabletTime[0] = CreatePlayerTextDraw(playerid, 270.000000, 201.000000, "00/00/00");
    PlayerTextDrawBackgroundColor(playerid, TabletTime[0], 255);
    PlayerTextDrawFont(playerid, TabletTime[0], 3);
    PlayerTextDrawLetterSize(playerid, TabletTime[0], 0.519999, 1.400000);
    PlayerTextDrawColor(playerid, TabletTime[0], -1);
    PlayerTextDrawSetOutline(playerid, TabletTime[0], 1);
    PlayerTextDrawSetProportional(playerid, TabletTime[0], 1);
    PlayerTextDrawSetSelectable(playerid, TabletTime[0], 0);

    TabletTime[1] = CreatePlayerTextDraw(playerid, 270.000000, 179.000000, "00:00:00");
    PlayerTextDrawBackgroundColor(playerid, TabletTime[1], 255);
    PlayerTextDrawFont(playerid, TabletTime[1], 3);
    PlayerTextDrawLetterSize(playerid, TabletTime[1], 0.799999, 2.499999);
    PlayerTextDrawColor(playerid, TabletTime[1], -1);
    PlayerTextDrawSetOutline(playerid, TabletTime[1], 1);
    PlayerTextDrawSetProportional(playerid, TabletTime[1], 1);
    PlayerTextDrawSetSelectable(playerid, TabletTime[1], 0);

    //Tragaperras [ESTE]
    Tragaperras[4] = CreatePlayerTextDraw(playerid, 475.000000, 192.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, Tragaperras[4], 255);
    PlayerTextDrawFont(playerid, Tragaperras[4], 1);
    PlayerTextDrawLetterSize(playerid, Tragaperras[4], 0.500000, 14.500001);
    PlayerTextDrawColor(playerid, Tragaperras[4], -1);
    PlayerTextDrawSetOutline(playerid, Tragaperras[4], 0);
    PlayerTextDrawSetProportional(playerid, Tragaperras[4], 1);
    PlayerTextDrawSetShadow(playerid, Tragaperras[4], 1);
    PlayerTextDrawUseBox(playerid, Tragaperras[4], 1);
    PlayerTextDrawBoxColor(playerid, Tragaperras[4], 842150600);
    PlayerTextDrawTextSize(playerid, Tragaperras[4], 180.000000, 0.000000);
    PlayerTextDrawSetSelectable(playerid, Tragaperras[4], 0);

    Tragaperras[0] = CreatePlayerTextDraw(playerid, 206.000000, 210.000000, "ld_slot:bar1_o");
    PlayerTextDrawBackgroundColor(playerid, Tragaperras[0], 255);
    PlayerTextDrawFont(playerid, Tragaperras[0], 4);
    PlayerTextDrawLetterSize(playerid, Tragaperras[0], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, Tragaperras[0], -1);
    PlayerTextDrawSetOutline(playerid, Tragaperras[0], 0);
    PlayerTextDrawSetProportional(playerid, Tragaperras[0], 1);
    PlayerTextDrawSetShadow(playerid, Tragaperras[0], 1);
    PlayerTextDrawUseBox(playerid, Tragaperras[0], 1);
    PlayerTextDrawBoxColor(playerid, Tragaperras[0], 255);
    PlayerTextDrawTextSize(playerid, Tragaperras[0], 70.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Tragaperras[0], 0);

    Tragaperras[1] = CreatePlayerTextDraw(playerid, 293.000000, 210.000000, "ld_slot:bar2_o");
    PlayerTextDrawBackgroundColor(playerid, Tragaperras[1], 255);
    PlayerTextDrawFont(playerid, Tragaperras[1], 4);
    PlayerTextDrawLetterSize(playerid, Tragaperras[1], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, Tragaperras[1], -1);
    PlayerTextDrawSetOutline(playerid, Tragaperras[1], 0);
    PlayerTextDrawSetProportional(playerid, Tragaperras[1], 1);
    PlayerTextDrawSetShadow(playerid, Tragaperras[1], 1);
    PlayerTextDrawUseBox(playerid, Tragaperras[1], 1);
    PlayerTextDrawBoxColor(playerid, Tragaperras[1], 255);
    PlayerTextDrawTextSize(playerid, Tragaperras[1], 70.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Tragaperras[1], 0);

    Tragaperras[2] = CreatePlayerTextDraw(playerid, 380.000000, 210.000000, "ld_slot:bell");
    PlayerTextDrawBackgroundColor(playerid, Tragaperras[2], 255);
    PlayerTextDrawFont(playerid, Tragaperras[2], 4);
    PlayerTextDrawLetterSize(playerid, Tragaperras[2], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, Tragaperras[2], -1);
    PlayerTextDrawSetOutline(playerid, Tragaperras[2], 0);
    PlayerTextDrawSetProportional(playerid, Tragaperras[2], 1);
    PlayerTextDrawSetShadow(playerid, Tragaperras[2], 1);
    PlayerTextDrawUseBox(playerid, Tragaperras[2], 1);
    PlayerTextDrawBoxColor(playerid, Tragaperras[2], 255);
    PlayerTextDrawTextSize(playerid, Tragaperras[2], 70.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Tragaperras[2], 0);

    Tragaperras[3] = CreatePlayerTextDraw(playerid, 328.000000, 291.000000, "LUCK");
    PlayerTextDrawAlignment(playerid, Tragaperras[3], 2);
    PlayerTextDrawBackgroundColor(playerid, Tragaperras[3], 255);
    PlayerTextDrawFont(playerid, Tragaperras[3], 3);
    PlayerTextDrawLetterSize(playerid, Tragaperras[3], 0.519999, 1.900000);
    PlayerTextDrawColor(playerid, Tragaperras[3], -1);
    PlayerTextDrawSetOutline(playerid, Tragaperras[3], 0);
    PlayerTextDrawSetProportional(playerid, Tragaperras[3], 1);
    PlayerTextDrawSetShadow(playerid, Tragaperras[3], 0);
    PlayerTextDrawUseBox(playerid, Tragaperras[3], 1);
    PlayerTextDrawBoxColor(playerid, Tragaperras[3], 255);
    PlayerTextDrawTextSize(playerid, Tragaperras[3], 10.000000, 240.000000);
    PlayerTextDrawSetSelectable(playerid, Tragaperras[3], 1);

    //Tablet Time [ESTE]
    TabletWeather[0] = CreatePlayerTextDraw(playerid, 475.000000, 192.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TabletWeather[0], 255);
    PlayerTextDrawFont(playerid, TabletWeather[0], 1);
    PlayerTextDrawLetterSize(playerid, TabletWeather[0], 0.500000, 14.500000);
    PlayerTextDrawColor(playerid, TabletWeather[0], -1);
    PlayerTextDrawSetOutline(playerid, TabletWeather[0], 0);
    PlayerTextDrawSetProportional(playerid, TabletWeather[0], 1);
    PlayerTextDrawSetShadow(playerid, TabletWeather[0], 1);
    PlayerTextDrawUseBox(playerid, TabletWeather[0], 1);
    PlayerTextDrawBoxColor(playerid, TabletWeather[0], 842150600);
    PlayerTextDrawTextSize(playerid, TabletWeather[0], 180.000000, 0.000000);
    PlayerTextDrawSetSelectable(playerid, TabletWeather[0], 0);

    TabletWeather[1] = CreatePlayerTextDraw(playerid, 328.000000, 291.000000, "Soleado");
    PlayerTextDrawAlignment(playerid, TabletWeather[1], 2);
    PlayerTextDrawBackgroundColor(playerid, TabletWeather[1], 255);
    PlayerTextDrawFont(playerid, TabletWeather[1], 3);
    PlayerTextDrawLetterSize(playerid, TabletWeather[1], 0.559999, 1.700000);
    PlayerTextDrawColor(playerid, TabletWeather[1], -1);
    PlayerTextDrawSetOutline(playerid, TabletWeather[1], 0);
    PlayerTextDrawSetProportional(playerid, TabletWeather[1], 1);
    PlayerTextDrawSetShadow(playerid, TabletWeather[1], 1);
    PlayerTextDrawUseBox(playerid, TabletWeather[1], 1);
    PlayerTextDrawBoxColor(playerid, TabletWeather[1], 255);
    PlayerTextDrawTextSize(playerid, TabletWeather[1], 0.000000, 240.000000);
    PlayerTextDrawSetSelectable(playerid, TabletWeather[1], 0);

    TabletWeather[2] = CreatePlayerTextDraw(playerid, 335.000000, 199.000000, "~y~PLACE~n~~g~SAN ANDREAS~n~~n~~y~TEMPERATURE~n~~g~0 C");
    PlayerTextDrawAlignment(playerid, TabletWeather[2], 2);
    PlayerTextDrawBackgroundColor(playerid, TabletWeather[2], 255);
    PlayerTextDrawFont(playerid, TabletWeather[2], 1);
    PlayerTextDrawLetterSize(playerid, TabletWeather[2], 0.449997, 1.800000);
    PlayerTextDrawColor(playerid, TabletWeather[2], -65281);
    PlayerTextDrawSetOutline(playerid, TabletWeather[2], 0);
    PlayerTextDrawSetProportional(playerid, TabletWeather[2], 1);
    PlayerTextDrawSetShadow(playerid, TabletWeather[2], 0);
    PlayerTextDrawSetSelectable(playerid, TabletWeather[2], 0);

    //
    TabletWin8Pag2 = CreatePlayerTextDraw(playerid, 328.000000, 145.000000, "BB~n~AA");
    PlayerTextDrawAlignment(playerid, TabletWin8Pag2, 2);
    PlayerTextDrawBackgroundColor(playerid, TabletWin8Pag2, 255);
    PlayerTextDrawFont(playerid, TabletWin8Pag2, 1);
    PlayerTextDrawLetterSize(playerid, TabletWin8Pag2, 0.679999, 3.000000);
    PlayerTextDrawColor(playerid, TabletWin8Pag2, -1);
    PlayerTextDrawSetOutline(playerid, TabletWin8Pag2, 0);
    PlayerTextDrawSetProportional(playerid, TabletWin8Pag2, 1);
    PlayerTextDrawSetShadow(playerid, TabletWin8Pag2, 0);
    PlayerTextDrawSetSelectable(playerid, TabletWin8Pag2, 0);
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid == DIALOG_TABLETCHAT) {
        if (response) {
            if (!strlen(inputtext)) return ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT, 0, DIALOG_STYLE_INPUT, "{FF0000}Player ID:", "Write the Player ID (ID)", "Search", "Cancel");
            if (IsNumeric(inputtext)) {
                new id = strval(inputtext);
                if (id == playerid) {
                    ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT, 0, DIALOG_STYLE_INPUT, "{FF0000}Speak with yourself? no!         .", "Write the Player ID (ID)", "Search", "Cancel");
                } else {
                    if (IsPlayerConnected(id)) {
                        chatid[playerid] = 0;
                        chatid[id] = 1;
                        new str[64];
                        new name[MAX_PLAYER_NAME];
                        GetPlayerName(playerid, name, sizeof(name));
                        format(str, sizeof(str), "%s invited to you to start a private chat", name);
                        ShowPlayerDialogEx(id, DIALOG_TABLETCHAT + 1, 0, DIALOG_STYLE_MSGBOX, "{FF0000}Chat invitation", str, "Accept", "Reject");
                        new name2[MAX_PLAYER_NAME];
                        GetPlayerName(playerid, name2, sizeof(name2));
                        SetPVarString(id, "sendername", name2);
                        new name3[MAX_PLAYER_NAME];
                        GetPlayerName(id, name3, sizeof(name3));
                        SetPVarString(playerid, "sendername2", name3);
                        SetPVarInt(id, "playeronid", playerid);
                        SetPVarInt(playerid, "therplayeronid", id);
                    } else {
                        ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT, 0, DIALOG_STYLE_INPUT, "{FF0000}Error: Player ID is invalid", "Write the player ID (ID)           .", "Search", "Cancel");
                    }
                }
            } else {
                ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT, 0, DIALOG_STYLE_INPUT, "{FF0000}Write the Player ID", "Write Player ID (ID)", "Search", "Cancel");
            }
        }
    }
    if (dialogid == DIALOG_TABLETCHAT + 1) {
        if (response) {
            if (chatid[playerid] == 1) {
                new asd[24];
                GetPVarString(playerid, "sendername", asd, 24);
                new str[64];
                format(str, sizeof(str), "{FF0000}Chat sesion - %s", asd);
                ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT + 2, 0, DIALOG_STYLE_INPUT, str, "Write here your message:", "Send", "Exit");
            }
        } else {
            new name[24];
            GetPlayerName(playerid, name, 24);
            new str[64];
            chatid[playerid] = 0;
            chatid[GetPVarInt(playerid, "therplayeronid")] = 0;
            format(str, sizeof(str), "%s don�t accept your chat invitation.\n\n", name);
            ShowPlayerDialogEx(GetPVarInt(playerid, "playeronid"), 0, DIALOG_TABLETCHAT + 3, DIALOG_STYLE_MSGBOX, "{FF0000}Chat sesion", str, "Exit", "");
        }
    }
    if (dialogid == DIALOG_TABLETCHAT + 2) {
        if (response) {
            new string[128];
            new name[24];
            GetPlayerName(playerid, name, 24);
            if (chatid[playerid] == 1) {
                new str[64];
                format(string, sizeof(string), "{990099}%s: %s\n", name, inputtext);
                strcat(chattext[playerid], string);
                strcat(chattext[GetPVarInt(playerid, "playeronid")], string);
                new asd[24];
                GetPVarString(playerid, "sendername", asd, 24);
                format(str, sizeof(str), "{FF0000}Chat sesion - %s", asd);
                ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT + 2, 0, DIALOG_STYLE_INPUT, str, chattext[playerid], "Send", "Exit");
                new str2[64];
                format(str2, sizeof(str2), "{FF0000}Chat sesion - %s", name);
                ShowPlayerDialogEx(GetPVarInt(playerid, "playeronid"), 0, DIALOG_TABLETCHAT + 2, DIALOG_STYLE_INPUT, str2, chattext[GetPVarInt(playerid, "playeronid")], "Send", "Exit");
            } else {
                new str[64];
                format(string, sizeof(string), "{FF0000}%s: %s\n", name, inputtext);
                strcat(chattext[playerid], string);
                strcat(chattext[GetPVarInt(playerid, "therplayeronid")], string);
                new asd[24];
                GetPVarString(playerid, "sendername2", asd, 24);
                format(str, sizeof(str), "{FF0000}Chat sesion - %s", asd);
                ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT + 2, 0, DIALOG_STYLE_INPUT, str, chattext[playerid], "Send", "Exit");
                new str2[64];
                format(str2, sizeof(str2), "{FF0000}Chat sesion - %s", name);
                ShowPlayerDialogEx(GetPVarInt(playerid, "therplayeronid"), 0, DIALOG_TABLETCHAT + 2, DIALOG_STYLE_INPUT, str2, chattext[GetPVarInt(playerid, "therplayeronid")], "Send", "Exit");
            }
        } else {
            if (chatid[playerid] == 1) {
                new name[24];
                GetPlayerName(playerid, name, 24);
                new str[64];
                chattext[playerid] = "";
                chattext[GetPVarInt(playerid, "playeronid")] = "";
                format(str, sizeof(str), "%s quit the conversation.", name);
                ShowPlayerDialogEx(GetPVarInt(playerid, "playeronid"), 0, DIALOG_TABLETCHAT + 3, DIALOG_STYLE_MSGBOX, "{FF0000}Chat sesion", str, "Exit", "");
            } else {
                new name[24];
                GetPlayerName(playerid, name, 24);
                new str[64];
                chattext[playerid] = "";
                chattext[GetPVarInt(playerid, "therplayeronid")] = "";
                chatid[playerid] = 0;
                chatid[GetPVarInt(playerid, "therplayeronid")] = 0;
                format(str, sizeof(str), "%s quit the conversation.", name);
                ShowPlayerDialogEx(GetPVarInt(playerid, "therplayeronid"), 0, DIALOG_TABLETCHAT + 3, DIALOG_STYLE_MSGBOX, "{FF0000}Chat sesion", str, "Exit", "");
            }
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_YES) {
        if (GetPVarInt(playerid, "camara")) {
            CameraMode(playerid, 0);
            ShowStartMenuTablet(playerid);
            SelectTextDraw(playerid, 0x33AA33AA);
            DeletePVar(playerid, "camara");
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == TwoBut[1]) {
        if (!GetPVarInt(playerid, "onoff")) {
            SetPVarInt(playerid, "onoff", 1);
            TextDrawHideForPlayer(playerid, TabletWin8Start[0]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[1]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[2]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[3]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[4]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[5]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[6]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[7]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[8]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[9]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[10]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[21]);
            TextDrawHideForPlayer(playerid, TabletWin8Start[22]);
            TextDrawHideForPlayer(playerid, TwoBut[0]);
            CancelSelectTextDraw(playerid);
            ShowTabletForPlayer(playerid);
            TabletTimer[playerid][0] = SetTimerEx("LoaderAnimation", 50, 1, "i", playerid);
            TabletTimer[playerid][4] = SetTimerEx("StartWin8", 5000, 0, "i", playerid);
        } else {
            if (GetPVarInt(playerid, "onoff")) {
                HidePagForItems(playerid);
                HideTabletForPlayer(playerid);
                HidePhotosForPlayer(playerid);
                HideTabletWeather(playerid);
                HideClockForPlayer(playerid);
                HideTabletMusicPlayer(playerid);
                HideGames(playerid);
                HideSlotMachine(playerid);
                HideStartMenuTablet(playerid);
                HideUserLogTablet(playerid);
                CameraMode(playerid, 2);
                HideEscritorioForPlayer(playerid);
                KillTimer(TabletTimer[playerid][0]);
                KillTimer(TabletTimer[playerid][1]);
                KillTimer(TabletTimer[playerid][2]);
                KillTimer(TabletTimer[playerid][3]);
                KillTimer(TabletTimer[playerid][4]);
                KillTimer(TabletTimer[playerid][5]);
                DeletePVar(playerid, "onoff");
                TextDrawShowForPlayer(playerid, TabletWin8Start[0]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[1]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[2]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[3]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[4]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[5]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[6]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[7]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[8]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[9]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[10]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[21]);
                TextDrawShowForPlayer(playerid, TabletWin8Start[22]);
                TextDrawShowForPlayer(playerid, TwoBut[0]);
                TextDrawShowForPlayer(playerid, TwoBut[1]);
                SelectTextDraw(playerid, 0x33AA33AA);
            }
        }
    }
    if (clickedid == TabletWin8Start[31]) ShowPage(playerid, 0);
    if (clickedid == TabletWin8Start[32]) ShowPage(playerid, 1);
    if (clickedid == TabletWin8Start[33]) ShowPage(playerid, 2);
    if (clickedid == TabletWin8Start[34]) ShowPage(playerid, 3);
    if (clickedid == TabletWin8Start[35]) ShowPage(playerid, 4);
    if (clickedid == TabletWin8Start[36]) ShowPage(playerid, 5);
    if (clickedid == TabletWin8Start[37]) ShowPage(playerid, 6);
    if (clickedid == TabletWin8Start[38]) ShowPage(playerid, 7);
    if (clickedid == TabletWin8Start[39]) ShowPage(playerid, 8);
    if (clickedid == TabletWin8Start[40]) ShowPage(playerid, 9);
    if (clickedid == TabletWin8Start[41]) ShowPage(playerid, 10);
    if (clickedid == TabletWin8Start[42]) ShowPage(playerid, 11);
    if (clickedid == TabletWin8Start[43]) ShowPage(playerid, 12);
    if (clickedid == TabletWin8Start[44]) ShowPage(playerid, 13);
    if (clickedid == TabletWin8Start[45]) ShowPage(playerid, 14);
    if (clickedid == TabletWin8Start[46]) ShowPage(playerid, 15);
    if (clickedid == TabletWin8Start[47]) ShowPage(playerid, 16);
    if (clickedid == TabletWin8Start[48]) ShowPage(playerid, 17);
    if (clickedid == TabletWin8Start[49]) ShowPage(playerid, 18);
    if (clickedid == TabletWin8Start[50]) ShowPage(playerid, 19);
    if (clickedid == TabletMusicPlayer[0]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/toc6d0gmwyf6m52/gangnamstyle.mp3?dl=1"); //PSY - Gangnam Style
    if (clickedid == TabletMusicPlayer[1]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/3lj9dv77pp15opc/Pjanoo.mp3?dl=1"); //Eric Prydz - Pjanoo
    if (clickedid == TabletMusicPlayer[2]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/atfmpu8eupiv138/Tacata.mp3?dl=1"); //Tacabro - Tacata
    if (clickedid == TabletMusicPlayer[3]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/bxh0ap2k7nkk3za/DoitForLove.mp3?dl=1"); //P Holla - Do it for love
    if (clickedid == TabletMusicPlayer[4]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/i5xrqh704s4zo2j/Balada.mp3?dl=1"); //Gustavo Lima - Balada Boa
    if (clickedid == TabletMusicPlayer[5]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xmo5nrwc6uvx90e/PartyLMFAO.mp3?dl=1"); //LMFAO - Party Rock
    if (clickedid == TabletMusicPlayer[6]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/pgjx0r47wma4yvd/SexyLMFAO.mp3?dl=1"); //LMFAO - Sexy and I know
    if (clickedid == TabletMusicPlayer[7]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/sx1pjsyp1u1v4lq/Safari.mp3?dl=1"); //Played a live - Safari Duo
    if (clickedid == TabletMusicPlayer[8]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xca4p49hvjtfajo/Inifinity.mp3?dl=1"); //Guru Josh Project - Infinity
    if (clickedid == TabletMusicPlayer[9]) PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/eopqegiekf5p09a/Rayos.mp3?dl=1"); //Quiero rayos de sol - Jose de rico
    if (clickedid == TabletMusicPlayer[10]) StopAudioStreamForPlayer(playerid);
    //Maps TD
    if (clickedid == MapsTD[0]) {
        TextDrawHideForPlayer(playerid, MapsTD[0]);
        TextDrawHideForPlayer(playerid, MapsTD[1]);
        TextDrawHideForPlayer(playerid, MapsTD[2]);
        TextDrawHideForPlayer(playerid, MapsTD[3]);
        TextDrawShowForPlayer(playerid, MapsTD[4]);
    }
    if (clickedid == MapsTD[1]) {
        TextDrawHideForPlayer(playerid, MapsTD[0]);
        TextDrawHideForPlayer(playerid, MapsTD[1]);
        TextDrawHideForPlayer(playerid, MapsTD[2]);
        TextDrawHideForPlayer(playerid, MapsTD[3]);
        TextDrawShowForPlayer(playerid, MapsTD[5]);
    }
    if (clickedid == MapsTD[2]) {
        TextDrawHideForPlayer(playerid, MapsTD[0]);
        TextDrawHideForPlayer(playerid, MapsTD[1]);
        TextDrawHideForPlayer(playerid, MapsTD[2]);
        TextDrawHideForPlayer(playerid, MapsTD[3]);
        TextDrawShowForPlayer(playerid, MapsTD[6]);
    }
    if (clickedid == MapsTD[3]) {
        TextDrawHideForPlayer(playerid, MapsTD[0]);
        TextDrawHideForPlayer(playerid, MapsTD[1]);
        TextDrawHideForPlayer(playerid, MapsTD[2]);
        TextDrawHideForPlayer(playerid, MapsTD[3]);
        TextDrawShowForPlayer(playerid, MapsTD[7]);
    }
    if (clickedid == MapsTD[4]) {
        TextDrawShowForPlayer(playerid, MapsTD[0]);
        TextDrawShowForPlayer(playerid, MapsTD[1]);
        TextDrawShowForPlayer(playerid, MapsTD[2]);
        TextDrawShowForPlayer(playerid, MapsTD[3]);
        TextDrawHideForPlayer(playerid, MapsTD[4]);
    }
    if (clickedid == MapsTD[5]) {
        TextDrawShowForPlayer(playerid, MapsTD[0]);
        TextDrawShowForPlayer(playerid, MapsTD[1]);
        TextDrawShowForPlayer(playerid, MapsTD[2]);
        TextDrawShowForPlayer(playerid, MapsTD[3]);
        TextDrawHideForPlayer(playerid, MapsTD[5]);
    }
    if (clickedid == MapsTD[6]) {
        TextDrawShowForPlayer(playerid, MapsTD[0]);
        TextDrawShowForPlayer(playerid, MapsTD[1]);
        TextDrawShowForPlayer(playerid, MapsTD[2]);
        TextDrawShowForPlayer(playerid, MapsTD[3]);
        TextDrawHideForPlayer(playerid, MapsTD[6]);
    }
    if (clickedid == MapsTD[7]) {
        TextDrawShowForPlayer(playerid, MapsTD[0]);
        TextDrawShowForPlayer(playerid, MapsTD[1]);
        TextDrawShowForPlayer(playerid, MapsTD[2]);
        TextDrawShowForPlayer(playerid, MapsTD[3]);
        TextDrawHideForPlayer(playerid, MapsTD[7]);
    }
    if (clickedid == Games) HideGames(playerid), ShowSlotMachine(playerid);
    if (clickedid == TabletWin8Pag[2]) {
        HidePagForItems(playerid);
        HidePhotosForPlayer(playerid);
        HideClockForPlayer(playerid);
        HideTabletMusicPlayer(playerid);
        HideTabletMap(playerid);
        HideSlotMachine(playerid);
        HideTabletWeather(playerid);
        ShowStartMenuTablet(playerid);
    }
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (playertextid == Escritorio[3]) {
        HidePagForItems(playerid);
        HideEscritorioForPlayer(playerid);
        ShowStartMenuTablet(playerid);
    }
    if (playertextid == Tragaperras[3]) {
        if (!GetPVarInt(playerid, "tragagoes")) {
            SetPVarInt(playerid, "tragagoes", 1);
            TabletTimer[playerid][6] = SetTimerEx("TragaperrasGO", 100, 1, "i", playerid);
            TabletTimer[playerid][7] = SetTimerEx("TragaperrasEND", 8000, 0, "i", playerid);
        }
    }
    return 1;
}
forward TragaperrasGO(playerid);
public TragaperrasGO(playerid) {
    tablet_randomvar[0] = random(6);
    tablet_randomvar[1] = random(6);
    tablet_randomvar[2] = random(6);
    PlayerTextDrawSetString(playerid, Tragaperras[0], tablet_slots[tablet_randomvar[0]]);
    PlayerTextDrawSetString(playerid, Tragaperras[1], tablet_slots[tablet_randomvar[1]]);
    PlayerTextDrawSetString(playerid, Tragaperras[2], tablet_slots[tablet_randomvar[2]]);
    return 1;
}
forward TragaperrasEND(playerid);
public TragaperrasEND(playerid) {
    KillTimer(TabletTimer[playerid][6]);
    DeletePVar(playerid, "tragagoes");
    if (tablet_randomvar[0] == tablet_randomvar[1] && tablet_randomvar[1] == tablet_randomvar[2]) {
        PlayerTextDrawSetString(playerid, Tragaperras[3], "YOU WIN");
        vault:PlayerVault(playerid, 100, "win in table game", Vault_ID_Government, -100, sprintf("%s win in table game", GetPlayerNameEx(playerid)));
    } else {
        vault:PlayerVault(playerid, -100, "win in table game", Vault_ID_Government, 100, sprintf("%s win in table game", GetPlayerNameEx(playerid)));
        PlayerTextDrawSetString(playerid, Tragaperras[3], "LOSER");
    }
    return 1;
}
forward LoaderAnimation(playerid);
public LoaderAnimation(playerid) {
    if (lda[playerid] == 0) TextDrawShowForPlayer(playerid, TabletWin8[13]), lda[playerid] = 1;
    else if (lda[playerid] == 1) TextDrawShowForPlayer(playerid, TabletWin8[14]), lda[playerid] = 2;
    else if (lda[playerid] == 2) TextDrawShowForPlayer(playerid, TabletWin8[15]), lda[playerid] = 3;
    else if (lda[playerid] == 3) TextDrawShowForPlayer(playerid, TabletWin8[16]), lda[playerid] = 4;
    else if (lda[playerid] == 4) TextDrawShowForPlayer(playerid, TabletWin8[17]), lda[playerid] = 5;
    else if (lda[playerid] == 5) TextDrawShowForPlayer(playerid, TabletWin8[18]), lda[playerid] = 6;
    else if (lda[playerid] == 6) TextDrawShowForPlayer(playerid, TabletWin8[19]), lda[playerid] = 7;
    else if (lda[playerid] == 7) TextDrawShowForPlayer(playerid, TabletWin8[20]), lda[playerid] = 9;
    else if (lda[playerid] == 9) TextDrawHideForPlayer(playerid, TabletWin8[13]), lda[playerid] = 10;
    else if (lda[playerid] == 10) TextDrawHideForPlayer(playerid, TabletWin8[14]), lda[playerid] = 11;
    else if (lda[playerid] == 11) TextDrawHideForPlayer(playerid, TabletWin8[15]), lda[playerid] = 12;
    else if (lda[playerid] == 12) TextDrawHideForPlayer(playerid, TabletWin8[16]), lda[playerid] = 13;
    else if (lda[playerid] == 13) TextDrawHideForPlayer(playerid, TabletWin8[17]), lda[playerid] = 14;
    else if (lda[playerid] == 14) TextDrawHideForPlayer(playerid, TabletWin8[18]), lda[playerid] = 15;
    else if (lda[playerid] == 15) TextDrawHideForPlayer(playerid, TabletWin8[19]), lda[playerid] = 16;
    else if (lda[playerid] == 16) TextDrawHideForPlayer(playerid, TabletWin8[20]), lda[playerid] = 0;
    return 1;
}
forward StartWin8(playerid);
public StartWin8(playerid) {
    lda[playerid] = 0;
    KillTimer(TabletTimer[playerid][0]);
    HideTabletForPlayer(playerid);
    ShowUserLogTablet(playerid);
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    PlayerTextDrawSetString(playerid, TabletWin8UserLog2, name);
    TabletTimer[playerid][1] = SetTimerEx("LoaderAnimation2", 50, 1, "i", playerid);
    TabletTimer[playerid][5] = SetTimerEx("Win8GO", 3000, 0, "i", playerid);
    TextDrawShowForPlayer(playerid, TabletWin8Start[0]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[1]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[2]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[3]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[4]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[5]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[6]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[7]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[8]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[9]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[10]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[21]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[22]);
    return 1;
}
forward LoaderAnimation2(playerid);
public LoaderAnimation2(playerid) {
    if (lda[playerid] == 0) TextDrawShowForPlayer(playerid, TabletWin8UserLog[1]), lda[playerid] = 1;
    else if (lda[playerid] == 1) TextDrawShowForPlayer(playerid, TabletWin8UserLog[6]), lda[playerid] = 2;
    else if (lda[playerid] == 2) TextDrawShowForPlayer(playerid, TabletWin8UserLog[8]), lda[playerid] = 3;
    else if (lda[playerid] == 3) TextDrawShowForPlayer(playerid, TabletWin8UserLog[9]), lda[playerid] = 4;
    else if (lda[playerid] == 4) TextDrawShowForPlayer(playerid, TabletWin8UserLog[10]), lda[playerid] = 5;
    else if (lda[playerid] == 5) TextDrawShowForPlayer(playerid, TabletWin8UserLog[11]), lda[playerid] = 6;
    else if (lda[playerid] == 6) TextDrawHideForPlayer(playerid, TabletWin8UserLog[1]), lda[playerid] = 7;
    else if (lda[playerid] == 7) TextDrawHideForPlayer(playerid, TabletWin8UserLog[6]), lda[playerid] = 8;
    else if (lda[playerid] == 8) TextDrawHideForPlayer(playerid, TabletWin8UserLog[8]), lda[playerid] = 9;
    else if (lda[playerid] == 9) TextDrawHideForPlayer(playerid, TabletWin8UserLog[9]), lda[playerid] = 10;
    else if (lda[playerid] == 10) TextDrawHideForPlayer(playerid, TabletWin8UserLog[10]), lda[playerid] = 11;
    else if (lda[playerid] == 11) TextDrawHideForPlayer(playerid, TabletWin8UserLog[11]), lda[playerid] = 0;
    return 1;
}
forward Win8GO(playerid);
public Win8GO(playerid) {
    KillTimer(TabletTimer[playerid][1]);
    lda[playerid] = 0;
    HideUserLogTablet(playerid);
    ShowStartMenuTablet(playerid);
    SelectTextDraw(playerid, 0x33AA33AA);
    return 1;
}
forward tablet_UpdateTime(playerid);
public tablet_UpdateTime(playerid) {
    new Hour, Minute, Second;
    gettime(Hour, Minute, Second);
    new str[64];
    format(str, sizeof(str), "%02d:%02d", Hour, Minute);
    PlayerTextDrawSetString(playerid, Escritorio[2], str);
    return 1;
}
forward tablet_UpdateTime2(playerid);
public tablet_UpdateTime2(playerid) {
    new Hour, Minute, Second;
    gettime(Hour, Minute, Second);
    new Year, Month, Day;
    getdate(Year, Month, Day);
    new str2[64];
    format(str2, sizeof(str2), "%02d/%s/%s", Day, GetMonth(Month), GetYearFormat00(Year));
    PlayerTextDrawSetString(playerid, TabletTime[0], str2);
    new str[64];
    format(str, sizeof(str), "%02d:%02d:%02d", Hour, Minute, Second);
    PlayerTextDrawSetString(playerid, TabletTime[1], str);
    return 1;
}
//Tablet ON/OFF
stock ShowTabletForPlayer(playerid) {
    for (new i = 0; i < 23; i++) TextDrawShowForPlayer(playerid, TabletWin8[i]);
    TextDrawHideForPlayer(playerid, TabletWin8[13]);
    TextDrawHideForPlayer(playerid, TabletWin8[14]);
    TextDrawHideForPlayer(playerid, TabletWin8[15]);
    TextDrawHideForPlayer(playerid, TabletWin8[16]);
    TextDrawHideForPlayer(playerid, TabletWin8[17]);
    TextDrawHideForPlayer(playerid, TabletWin8[18]);
    TextDrawHideForPlayer(playerid, TabletWin8[19]);
    TextDrawHideForPlayer(playerid, TabletWin8[20]);
    return 1;
}
stock HideTabletForPlayer(playerid) {
    for (new i = 0; i < 23; i++) TextDrawHideForPlayer(playerid, TabletWin8[i]);
    return 1;
}

//UserLogin
stock ShowUserLogTablet(playerid) {
    PlayerTextDrawShow(playerid, TabletWin8UserLog2);
    for (new i = 0; i < 12; i++) TextDrawShowForPlayer(playerid, TabletWin8UserLog[i]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[1]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[6]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[8]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[9]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[10]);
    TextDrawHideForPlayer(playerid, TabletWin8UserLog[11]);
    return 1;
}
stock HideUserLogTablet(playerid) {
    for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, TabletWin8UserLog[i]);
    PlayerTextDrawHide(playerid, TabletWin8UserLog2);
    return 1;
}

//StartMenu
stock ShowStartMenuTablet(playerid) {
    for (new i = 0; i < 51; i++) TextDrawShowForPlayer(playerid, TabletWin8Start[i]);
    return 1;
}
stock HideStartMenuTablet(playerid) {
    for (new i = 0; i < 51; i++) TextDrawHideForPlayer(playerid, TabletWin8Start[i]);
    return 1;
}

//PagForItem
stock ShowPagForItems(playerid) {
    PlayerTextDrawShow(playerid, TabletWin8Pag2);
    for (new i = 0; i < 3; i++) TextDrawShowForPlayer(playerid, TabletWin8Pag[i]);
    return 1;
}
stock HidePagForItems(playerid) {
    PlayerTextDrawHide(playerid, TabletWin8Pag2);
    for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, TabletWin8Pag[i]);
    return 1;
}

//Escritorio
stock ShowEscritorioForPlayer(playerid) {
    for (new i = 0; i < 4; i++) PlayerTextDrawShow(playerid, Escritorio[i]);
    TabletTimer[playerid][2] = SetTimerEx("tablet_UpdateTime", 1000, 1, "i", playerid);
    return 1;
}
stock HideEscritorioForPlayer(playerid) {
    for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Escritorio[i]);
    KillTimer(TabletTimer[playerid][2]);
    return 1;
}

//Photos
stock ShowPhotosForPlayer(playerid) {
    for (new i = 0; i < 12; i++) TextDrawShowForPlayer(playerid, TabletPhotos[i]);
    return 1;
}
stock HidePhotosForPlayer(playerid) {
    for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, TabletPhotos[i]);
    return 1;
}
//Reloj
stock ShowClockForPlayer(playerid) {
    for (new i = 0; i < 2; i++) PlayerTextDrawShow(playerid, TabletTime[i]);
    TabletTimer[playerid][3] = SetTimerEx("tablet_UpdateTime2", 1000, 1, "i", playerid);
    return 1;
}
stock HideClockForPlayer(playerid) {
    for (new i = 0; i < 2; i++) PlayerTextDrawHide(playerid, TabletTime[i]);
    KillTimer(TabletTimer[playerid][3]);
    return 1;
}

//TabletMusicPlayer
stock ShowTabletMusicPlayer(playerid) {
    for (new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid, TabletMusicPlayer[i]);
    return 1;
}
stock HideTabletMusicPlayer(playerid) {
    for (new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid, TabletMusicPlayer[i]);
    StopAudioStreamForPlayer(playerid);
    return 1;
}

//CameraMode:
stock CameraMode(playerid, type) {
    if (type == 0) {
        ShowStartMenuTablet(playerid);
        SelectTextDraw(playerid, 0x33AA33AA);
        for (new i = 0; i < 24; i++) TextDrawHideForPlayer(playerid, CameraTD[i]);
        SetCameraBehindPlayer(playerid);
        DestroyDynamicObjectEx(firstperson[playerid]);
    } else if (type == 1) {
        CancelSelectTextDraw(playerid);
        SetPVarInt(playerid, "camara", 1);
        HideStartMenuTablet(playerid);
        for (new i = 0; i < 24; i++) TextDrawShowForPlayer(playerid, CameraTD[i]);
        firstperson[playerid] = CreateDynamicObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachObjectToPlayer(firstperson[playerid], playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, firstperson[playerid]);
    } else if (type == 2) {
        for (new i = 0; i < 24; i++) TextDrawHideForPlayer(playerid, CameraTD[i]);
        SetCameraBehindPlayer(playerid);
        DestroyDynamicObjectEx(firstperson[playerid]);
    }
    return 1;
}

//Maps TD
stock ShowTabletMap(playerid) {
    TextDrawShowForPlayer(playerid, MapsTD[0]);
    TextDrawShowForPlayer(playerid, MapsTD[1]);
    TextDrawShowForPlayer(playerid, MapsTD[2]);
    TextDrawShowForPlayer(playerid, MapsTD[3]);
    return 1;
}
stock HideTabletMap(playerid) {
    for (new i = 0; i < 8; i++) TextDrawHideForPlayer(playerid, MapsTD[i]);
    return 1;
}

//Games TD
stock ShowGames(playerid) {
    TextDrawShowForPlayer(playerid, Games);
    return 1;
}
stock HideGames(playerid) {
    TextDrawHideForPlayer(playerid, Games);
    return 1;
}
//SlotMachine TD
stock ShowSlotMachine(playerid) {
    PlayerTextDrawShow(playerid, Tragaperras[4]);
    for (new i = 0; i < 4; i++) PlayerTextDrawShow(playerid, Tragaperras[i]);
    return 1;
}
stock HideSlotMachine(playerid) {
    PlayerTextDrawSetString(playerid, Tragaperras[3], "LUCK");
    DeletePVar(playerid, "tragagoes");
    for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Tragaperras[i]);
    PlayerTextDrawHide(playerid, Tragaperras[4]);
    KillTimer(TabletTimer[playerid][6]);
    KillTimer(TabletTimer[playerid][7]);
    return 1;
}
//Show Weather
stock ShowTabletWeather(playerid) {
    new str[64];
    format(str, sizeof(str), "~y~PLACE~n~~g~SAN ANDREAS~n~~n~~y~TEMPERATURE~n~~g~%s", temperature[random(sizeof(temperature))]);
    PlayerTextDrawSetString(playerid, TabletWeather[2], str);
    new weather[64], id;
    GetServerVarAsString("weather", weather, sizeof(weather));
    id = strval(weather);
    if (id >= 0 && id <= 7) PlayerTextDrawSetString(playerid, TabletWeather[1], "SUNNY");
    else if (id == 8) PlayerTextDrawSetString(playerid, TabletWeather[1], "STORMY");
    else if (id == 9) PlayerTextDrawSetString(playerid, TabletWeather[1], "FOG");
    else if (id == 10) PlayerTextDrawSetString(playerid, TabletWeather[1], "SUNNY");
    else if (id == 11) PlayerTextDrawSetString(playerid, TabletWeather[1], "VERY HOT");
    else if (id >= 12 && id <= 15) PlayerTextDrawSetString(playerid, TabletWeather[1], "BORRING");
    else if (id == 16) PlayerTextDrawSetString(playerid, TabletWeather[1], "FOG AND RAIN");
    else if (id >= 17 && id <= 18) PlayerTextDrawSetString(playerid, TabletWeather[1], "HOT");
    else if (id == 19) PlayerTextDrawSetString(playerid, TabletWeather[1], "SANDSTORM");
    else if (id == 20) PlayerTextDrawSetString(playerid, TabletWeather[1], "GREEN FOG");
    else if (id == 21) PlayerTextDrawSetString(playerid, TabletWeather[1], "DARK");
    else if (id == 22) PlayerTextDrawSetString(playerid, TabletWeather[1], "DARK");
    else if (id >= 23 && id <= 26) PlayerTextDrawSetString(playerid, TabletWeather[1], "PALID ORANGE");
    else if (id >= 27 && id <= 29) PlayerTextDrawSetString(playerid, TabletWeather[1], "FRESH BLUE");
    else if (id >= 30 && id <= 32) PlayerTextDrawSetString(playerid, TabletWeather[1], "DARK");
    else if (id == 33) PlayerTextDrawSetString(playerid, TabletWeather[1], "DARK");
    else if (id == 34) PlayerTextDrawSetString(playerid, TabletWeather[1], "BLUE");
    else if (id == 35) PlayerTextDrawSetString(playerid, TabletWeather[1], "BROWN");
    else if (id >= 36 && id <= 38) PlayerTextDrawSetString(playerid, TabletWeather[1], "BRIGHT");
    else if (id == 39) PlayerTextDrawSetString(playerid, TabletWeather[1], "VERY BRIGHT");
    else if (id >= 40 && id <= 42) PlayerTextDrawSetString(playerid, TabletWeather[1], "BLUE/PURPLE");
    else if (id == 43) PlayerTextDrawSetString(playerid, TabletWeather[1], "TOXIC");
    else if (id == 44) PlayerTextDrawSetString(playerid, TabletWeather[1], "BLACK");
    else if (id == 45) PlayerTextDrawSetString(playerid, TabletWeather[1], "BLACK");
    for (new i = 0; i < 3; i++) PlayerTextDrawShow(playerid, TabletWeather[i]);
    return 1;
}
stock HideTabletWeather(playerid) {
    for (new i = 0; i < 3; i++) PlayerTextDrawHide(playerid, TabletWeather[i]);
    return 1;
}
//Only for menu no bug
stock ShowPage(playerid, page) {
    HideStartMenuTablet(playerid);
    TextDrawShowForPlayer(playerid, TabletWin8Start[0]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[1]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[2]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[3]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[4]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[5]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[6]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[7]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[8]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[9]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[10]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[21]);
    TextDrawShowForPlayer(playerid, TabletWin8Start[22]);
    if (page == 0) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "EMAIL");
    else if (page == 1) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "CONTACTS");
    else if (page == 2) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "MESSAGES"), ShowPlayerDialogEx(playerid, DIALOG_TABLETCHAT, 0, DIALOG_STYLE_INPUT, "{FF0000}Write The Player ID", "Put the Player ID (ID)", "Search", "Cancel"), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 3) return ShowEscritorioForPlayer(playerid);
    else if (page == 4) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "CLOCK"), ShowClockForPlayer(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 5) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "PHOTOS"), ShowPhotosForPlayer(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 6) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "FINANZES");
    else if (page == 7) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "WEATHER"), ShowTabletWeather(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 8) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "INTERNET~n~EXPLORER");
    else if (page == 9) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "MAPS"), ShowTabletMap(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 10) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "SPORTS");
    else if (page == 11) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "NEWS");
    else if (page == 12) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "STORE");
    else if (page == 13) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "SkyDrive");
    else if (page == 14) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "BING");
    else if (page == 15) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "TRAVELS");
    else if (page == 16) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "GAMES"), ShowGames(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 17) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "CAMERA"), CameraMode(playerid, 1);
    else if (page == 18) return PlayerTextDrawSetString(playerid, TabletWin8Pag2, "MUSIC"), ShowTabletMusicPlayer(playerid), ShowPagForItems(playerid), TextDrawHideForPlayer(playerid, TabletWin8Pag[1]);
    else if (page == 19) PlayerTextDrawSetString(playerid, TabletWin8Pag2, "VIDEO");
    ShowPagForItems(playerid);
    return 1;
}
stock IsNumeric(const string[]) {
    for (new i = 0, j = strlen(string); i < j; i++) {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}
stock tablet_cmd(playerid) {
    if (!GetPVarInt(playerid, "tablet")) {
        SetPVarInt(playerid, "tablet", 1);
        TextDrawShowForPlayer(playerid, TabletWin8Start[0]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[1]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[2]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[3]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[4]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[5]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[6]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[7]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[8]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[9]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[10]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[21]);
        TextDrawShowForPlayer(playerid, TabletWin8Start[22]);
        TextDrawShowForPlayer(playerid, TwoBut[0]);
        TextDrawShowForPlayer(playerid, TwoBut[1]);
        SelectTextDraw(playerid, 0x33AA33AA);
    } else {
        HidePagForItems(playerid);
        HideTabletForPlayer(playerid);
        HidePhotosForPlayer(playerid);
        HideClockForPlayer(playerid);
        HideTabletMusicPlayer(playerid);
        HideStartMenuTablet(playerid);
        HideUserLogTablet(playerid);
        HideTabletWeather(playerid);
        HideEscritorioForPlayer(playerid);
        HideGames(playerid);
        HideSlotMachine(playerid);
        CancelSelectTextDraw(playerid);
        CameraMode(playerid, 2);
        HideTabletMap(playerid);
        TextDrawHideForPlayer(playerid, TwoBut[0]);
        TextDrawHideForPlayer(playerid, TwoBut[1]);
        KillTimer(TabletTimer[playerid][0]);
        KillTimer(TabletTimer[playerid][1]);
        KillTimer(TabletTimer[playerid][2]);
        KillTimer(TabletTimer[playerid][3]);
        KillTimer(TabletTimer[playerid][4]);
        KillTimer(TabletTimer[playerid][5]);
        DeletePVar(playerid, "tablet");
        DeletePVar(playerid, "onoff");
        DeletePVar(playerid, "camara");
    }
    return 1;
}

new EtShop:DataTablet[MAX_PLAYERS];

stock EtShop:IsTabletActive(playerid) {
    return gettime() < EtShop:DataTablet[playerid];
}

stock EtShop:GetTablet(playerid) {
    return EtShop:DataTablet[playerid];
}

stock EtShop:SetTablet(playerid, expireAt) {
    EtShop:DataTablet[playerid] = expireAt;
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetTablet(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "tablet"));
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 38) return 1;
    if (EtShop:IsTabletActive(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have tablet, no need to purchase it again until it expires."); return ~1; }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase tablet"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetTablet(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased tablet. Validity: 30 days");
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 1 || !EtShop:IsTabletActive(playerid)) return 1;
    UCP:AddCommand(playerid, "Use Tablet");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Use Tablet", inputtext)) tablet_cmd(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    PlayerTextDrawDestroy(playerid, TabletWin8UserLog2);
    PlayerTextDrawDestroy(playerid, TabletWin8Pag2);
    for (new i = 0; i < 4; i++) PlayerTextDrawDestroy(playerid, Escritorio[i]);
    for (new i = 0; i < 2; i++) PlayerTextDrawDestroy(playerid, TabletTime[i]);
    for (new i = 0; i < 3; i++) PlayerTextDrawDestroy(playerid, TabletWeather[i]);
    for (new i = 0; i < 5; i++) PlayerTextDrawDestroy(playerid, Tragaperras[i]);
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(ETShop_Player_Tablet[playerid], GetPlayerNameEx(playerid), "username", "tablet");
    return 1;
}