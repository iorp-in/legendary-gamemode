#define MAX_TIME_TO_WAIT 20000 //A maximum of 20 seconds of waiting until they pick up / pick up the call
#define MAX_S3_MAIN_MENU 14
new Text:Galaxy3[16];
new Text:Galaxy3Start[2];
new Text:Galaxy3StartMenu[13];
new PlayerText:Galaxy3StartMenu2;
new Text:Galaxy3SMainMenu[MAX_S3_MAIN_MENU];
new TimerS3[MAX_PLAYERS][2];
new TimerWaitCalling[MAX_PLAYERS];
new Text:CalculatorTD[17];
new PlayerText:CalculatorTD2;
new var1[MAX_PLAYERS][10];
new var2[MAX_PLAYERS][10];
new Text:Galaxy3Gallery[13];
new Text:Galaxy3Camera[32];
new firstpersona[MAX_PLAYERS];
new Text:Galaxy3Maps[9];
new Text:Galaxy3Weather[3];
new Text:Galaxy3Radios[4];
new Text:Galaxy3KeyBoard[17];
new PlayerText:KeyBoard2;
new Text:Galaxy3Latitude[2];
new PlayerText:Galaxy3Latitude2;
new Text:Galaxy3MusicPlayer[7];
new Text:Galaxy3SlotMachine[2];
new SlotMachineTimer[MAX_PLAYERS][2];
new PlayerText:Galaxy3SlotMachine2[4];
new Phone:Slots[][] = {
    "ld_slot:bar1_o",
    "ld_slot:bar2_o",
    "ld_slot:bell",
    "ld_slot:cherry",
    "ld_slot:grapes",
    "ld_slot:r_69"
};
new randomvar[3];
new numberab[MAX_PLAYERS][9];
enum mobileplayer_enum {
    calling,
    caller,
    number
}
new MobilePlayer[MAX_PLAYERS][mobileplayer_enum];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "phone", "int", "0");
    SetTimer("UpdateTime", 1000, 1);
    Galaxy3[0] = TextDrawCreate(493.000000, 156.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3[0], 255);
    TextDrawFont(Galaxy3[0], 4);
    TextDrawLetterSize(Galaxy3[0], 0.500000, 1.000000);
    TextDrawColor(Galaxy3[0], -1);
    TextDrawSetOutline(Galaxy3[0], 0);
    TextDrawSetProportional(Galaxy3[0], 1);
    TextDrawSetShadow(Galaxy3[0], 1);
    TextDrawUseBox(Galaxy3[0], 1);
    TextDrawBoxColor(Galaxy3[0], 255);
    TextDrawTextSize(Galaxy3[0], 27.000000, 33.000000);
    TextDrawSetSelectable(Galaxy3[0], 0);

    Galaxy3[1] = TextDrawCreate(493.000000, 423.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3[1], 255);
    TextDrawFont(Galaxy3[1], 4);
    TextDrawLetterSize(Galaxy3[1], 0.500000, 1.000000);
    TextDrawColor(Galaxy3[1], -1);
    TextDrawSetOutline(Galaxy3[1], 0);
    TextDrawSetProportional(Galaxy3[1], 1);
    TextDrawSetShadow(Galaxy3[1], 1);
    TextDrawUseBox(Galaxy3[1], 1);
    TextDrawBoxColor(Galaxy3[1], 255);
    TextDrawTextSize(Galaxy3[1], 27.000000, -33.000000);
    TextDrawSetSelectable(Galaxy3[1], 0);

    Galaxy3[2] = TextDrawCreate(615.000000, 423.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3[2], 255);
    TextDrawFont(Galaxy3[2], 4);
    TextDrawLetterSize(Galaxy3[2], 0.500000, 1.000000);
    TextDrawColor(Galaxy3[2], -1);
    TextDrawSetOutline(Galaxy3[2], 0);
    TextDrawSetProportional(Galaxy3[2], 1);
    TextDrawSetShadow(Galaxy3[2], 1);
    TextDrawUseBox(Galaxy3[2], 1);
    TextDrawBoxColor(Galaxy3[2], 255);
    TextDrawTextSize(Galaxy3[2], -27.000000, -33.000000);
    TextDrawSetSelectable(Galaxy3[2], 0);

    Galaxy3[3] = TextDrawCreate(615.000000, 156.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3[3], 255);
    TextDrawFont(Galaxy3[3], 4);
    TextDrawLetterSize(Galaxy3[3], 0.500000, 1.000000);
    TextDrawColor(Galaxy3[3], -1);
    TextDrawSetOutline(Galaxy3[3], 0);
    TextDrawSetProportional(Galaxy3[3], 1);
    TextDrawSetShadow(Galaxy3[3], 1);
    TextDrawUseBox(Galaxy3[3], 1);
    TextDrawBoxColor(Galaxy3[3], 255);
    TextDrawTextSize(Galaxy3[3], -27.000000, 33.000000);
    TextDrawSetSelectable(Galaxy3[3], 0);

    Galaxy3[4] = TextDrawCreate(494.000000, 138.000000, "0");
    TextDrawBackgroundColor(Galaxy3[4], 255);
    TextDrawFont(Galaxy3[4], 1);
    TextDrawLetterSize(Galaxy3[4], 2.259998, 10.800010);
    TextDrawColor(Galaxy3[4], 255);
    TextDrawSetOutline(Galaxy3[4], 0);
    TextDrawSetProportional(Galaxy3[4], 1);
    TextDrawSetShadow(Galaxy3[4], 0);
    TextDrawSetSelectable(Galaxy3[4], 0);

    Galaxy3[5] = TextDrawCreate(565.500000, 138.000000, "0");
    TextDrawBackgroundColor(Galaxy3[5], 255);
    TextDrawFont(Galaxy3[5], 1);
    TextDrawLetterSize(Galaxy3[5], 2.259998, 10.800010);
    TextDrawColor(Galaxy3[5], 255);
    TextDrawSetOutline(Galaxy3[5], 0);
    TextDrawSetProportional(Galaxy3[5], 1);
    TextDrawSetShadow(Galaxy3[5], 0);
    TextDrawSetSelectable(Galaxy3[5], 0);

    Galaxy3[14] = TextDrawCreate(494.000000, 336.000000, "0");
    TextDrawBackgroundColor(Galaxy3[14], 255);
    TextDrawFont(Galaxy3[14], 1);
    TextDrawLetterSize(Galaxy3[14], 2.259998, 10.800010);
    TextDrawColor(Galaxy3[14], 255);
    TextDrawSetOutline(Galaxy3[14], 0);
    TextDrawSetProportional(Galaxy3[14], 1);
    TextDrawSetShadow(Galaxy3[14], 0);
    TextDrawSetSelectable(Galaxy3[14], 0);

    Galaxy3[15] = TextDrawCreate(565.500000, 335.000000, "0");
    TextDrawBackgroundColor(Galaxy3[15], 255);
    TextDrawFont(Galaxy3[15], 1);
    TextDrawLetterSize(Galaxy3[15], 2.259998, 10.800010);
    TextDrawColor(Galaxy3[15], 255);
    TextDrawSetOutline(Galaxy3[15], 0);
    TextDrawSetProportional(Galaxy3[15], 1);
    TextDrawSetShadow(Galaxy3[15], 0);
    TextDrawSetSelectable(Galaxy3[15], 0);

    Galaxy3[6] = TextDrawCreate(617.000000, 191.000000, "_");
    TextDrawBackgroundColor(Galaxy3[6], 255);
    TextDrawFont(Galaxy3[6], 1);
    TextDrawLetterSize(Galaxy3[6], 0.500000, 22.200000);
    TextDrawColor(Galaxy3[6], -1);
    TextDrawSetOutline(Galaxy3[6], 0);
    TextDrawSetProportional(Galaxy3[6], 1);
    TextDrawSetShadow(Galaxy3[6], 1);
    TextDrawUseBox(Galaxy3[6], 1);
    TextDrawBoxColor(Galaxy3[6], 255);
    TextDrawTextSize(Galaxy3[6], 491.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3[6], 0);

    Galaxy3[7] = TextDrawCreate(590.000000, 158.000000, "_");
    TextDrawBackgroundColor(Galaxy3[7], 255);
    TextDrawFont(Galaxy3[7], 1);
    TextDrawLetterSize(Galaxy3[7], 0.500000, 29.200004);
    TextDrawColor(Galaxy3[7], -1);
    TextDrawSetOutline(Galaxy3[7], 0);
    TextDrawSetProportional(Galaxy3[7], 1);
    TextDrawSetShadow(Galaxy3[7], 1);
    TextDrawUseBox(Galaxy3[7], 1);
    TextDrawBoxColor(Galaxy3[7], 255);
    TextDrawTextSize(Galaxy3[7], 518.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3[7], 0);

    Galaxy3[8] = TextDrawCreate(606.000000, 174.000000, "_");
    TextDrawBackgroundColor(Galaxy3[8], 255);
    TextDrawFont(Galaxy3[8], 1);
    TextDrawLetterSize(Galaxy3[8], 0.500000, 26.199996);
    TextDrawColor(Galaxy3[8], -1);
    TextDrawSetOutline(Galaxy3[8], 0);
    TextDrawSetProportional(Galaxy3[8], 1);
    TextDrawSetShadow(Galaxy3[8], 1);
    TextDrawUseBox(Galaxy3[8], 1);
    TextDrawBoxColor(Galaxy3[8], 255);
    TextDrawTextSize(Galaxy3[8], 498.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3[8], 0);

    Galaxy3[9] = TextDrawCreate(554.000000, 397.000000, "u");
    TextDrawBackgroundColor(Galaxy3[9], 255);
    TextDrawAlignment(Galaxy3[9], 2);
    TextDrawFont(Galaxy3[9], 2);
    TextDrawLetterSize(Galaxy3[9], 2.070000, 1.400000);
    TextDrawColor(Galaxy3[9], -1);
    TextDrawSetOutline(Galaxy3[9], 0);
    TextDrawSetProportional(Galaxy3[9], 1);
    TextDrawSetShadow(Galaxy3[9], 1);
    TextDrawTextSize(Galaxy3[9], 13.000000, 50.000000);
    TextDrawSetSelectable(Galaxy3[9], 1);

    Galaxy3[10] = TextDrawCreate(502.000000, 190.000000, "_");
    TextDrawBackgroundColor(Galaxy3[10], 255);
    TextDrawFont(Galaxy3[10], 1);
    TextDrawLetterSize(Galaxy3[10], 0.500000, 22.000003);
    TextDrawColor(Galaxy3[10], -1);
    TextDrawSetOutline(Galaxy3[10], 0);
    TextDrawSetProportional(Galaxy3[10], 1);
    TextDrawSetShadow(Galaxy3[10], 1);
    TextDrawUseBox(Galaxy3[10], 1);
    TextDrawBoxColor(Galaxy3[10], 842150655);
    TextDrawTextSize(Galaxy3[10], 606.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3[10], 0);

    Galaxy3[11] = TextDrawCreate(535.000000, 157.000000, "-");
    TextDrawBackgroundColor(Galaxy3[11], 255);
    TextDrawFont(Galaxy3[11], 1);
    TextDrawLetterSize(Galaxy3[11], 2.569999, 1.800000);
    TextDrawColor(Galaxy3[11], 842150655);
    TextDrawSetOutline(Galaxy3[11], 0);
    TextDrawSetProportional(Galaxy3[11], 1);
    TextDrawSetShadow(Galaxy3[11], 0);
    TextDrawSetSelectable(Galaxy3[11], 0);

    Galaxy3[12] = TextDrawCreate(568.000000, 163.000000, ".. o");
    TextDrawBackgroundColor(Galaxy3[12], 255);
    TextDrawFont(Galaxy3[12], 1);
    TextDrawLetterSize(Galaxy3[12], 0.400000, 1.400000);
    TextDrawColor(Galaxy3[12], 842150655);
    TextDrawSetOutline(Galaxy3[12], 0);
    TextDrawSetProportional(Galaxy3[12], 1);
    TextDrawSetShadow(Galaxy3[12], 0);
    TextDrawSetSelectable(Galaxy3[12], 0);

    Galaxy3[13] = TextDrawCreate(533.000000, 175.000000, "SAMSUNG");
    TextDrawBackgroundColor(Galaxy3[13], 255);
    TextDrawFont(Galaxy3[13], 1);
    TextDrawLetterSize(Galaxy3[13], 0.250000, 0.899999);
    TextDrawColor(Galaxy3[13], -1);
    TextDrawSetOutline(Galaxy3[13], 0);
    TextDrawSetProportional(Galaxy3[13], 1);
    TextDrawSetShadow(Galaxy3[13], 0);
    TextDrawSetSelectable(Galaxy3[13], 0);

    //GalaxySIII starter
    Galaxy3Start[0] = TextDrawCreate(553.000000, 235.000000, "SAMSUNG");
    TextDrawAlignment(Galaxy3Start[0], 2);
    TextDrawBackgroundColor(Galaxy3Start[0], 255);
    TextDrawFont(Galaxy3Start[0], 1);
    TextDrawLetterSize(Galaxy3Start[0], 0.559999, 1.600000);
    TextDrawColor(Galaxy3Start[0], -855703297);
    TextDrawSetOutline(Galaxy3Start[0], 0);
    TextDrawSetProportional(Galaxy3Start[0], 1);
    TextDrawSetShadow(Galaxy3Start[0], 0);
    TextDrawSetSelectable(Galaxy3Start[0], 0);

    Galaxy3Start[1] = TextDrawCreate(553.000000, 322.000000, "Samsung Galaxy SIII~n~designed for IORP~n~~n~LOADING");
    TextDrawAlignment(Galaxy3Start[1], 2);
    TextDrawBackgroundColor(Galaxy3Start[1], 255);
    TextDrawFont(Galaxy3Start[1], 1);
    TextDrawLetterSize(Galaxy3Start[1], 0.290000, 1.299999);
    TextDrawColor(Galaxy3Start[1], -1);
    TextDrawSetOutline(Galaxy3Start[1], 0);
    TextDrawSetProportional(Galaxy3Start[1], 1);
    TextDrawSetShadow(Galaxy3Start[1], 0);
    TextDrawSetSelectable(Galaxy3Start[1], 0);

    //GalaxySIII Current Menu
    Galaxy3StartMenu[0] = TextDrawCreate(500.000000, 187.000000, "ld_dual:backgnd");
    TextDrawBackgroundColor(Galaxy3StartMenu[0], 255);
    TextDrawFont(Galaxy3StartMenu[0], 4);
    TextDrawLetterSize(Galaxy3StartMenu[0], 0.500000, 1.000000);
    TextDrawColor(Galaxy3StartMenu[0], -1);
    TextDrawSetOutline(Galaxy3StartMenu[0], 0);
    TextDrawSetProportional(Galaxy3StartMenu[0], 1);
    TextDrawSetShadow(Galaxy3StartMenu[0], 1);
    TextDrawUseBox(Galaxy3StartMenu[0], 1);
    TextDrawBoxColor(Galaxy3StartMenu[0], 255);
    TextDrawTextSize(Galaxy3StartMenu[0], 108.000000, 204.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[0], 0);

    Galaxy3StartMenu[1] = TextDrawCreate(523.000000, 210.000000, "00:00");
    TextDrawBackgroundColor(Galaxy3StartMenu[1], 255);
    TextDrawFont(Galaxy3StartMenu[1], 2);
    TextDrawLetterSize(Galaxy3StartMenu[1], 0.559998, 2.599998);
    TextDrawColor(Galaxy3StartMenu[1], -1);
    TextDrawSetOutline(Galaxy3StartMenu[1], 0);
    TextDrawSetProportional(Galaxy3StartMenu[1], 1);
    TextDrawSetShadow(Galaxy3StartMenu[1], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[1], 0);

    Galaxy3StartMenu[2] = TextDrawCreate(592.000000, 364.000000, "...~n~...~n~...");
    TextDrawAlignment(Galaxy3StartMenu[2], 2);
    TextDrawBackgroundColor(Galaxy3StartMenu[2], 255);
    TextDrawFont(Galaxy3StartMenu[2], 1);
    TextDrawLetterSize(Galaxy3StartMenu[2], 0.400000, 0.800000);
    TextDrawColor(Galaxy3StartMenu[2], -1);
    TextDrawSetOutline(Galaxy3StartMenu[2], 0);
    TextDrawSetProportional(Galaxy3StartMenu[2], 1);
    TextDrawSetShadow(Galaxy3StartMenu[2], 0);
    TextDrawTextSize(Galaxy3StartMenu[2], 20.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[2], 1);

    Galaxy3StartMenu[3] = TextDrawCreate(528.000000, 231.000000, "00/MON/00");
    TextDrawBackgroundColor(Galaxy3StartMenu[3], 255);
    TextDrawFont(Galaxy3StartMenu[3], 2);
    TextDrawLetterSize(Galaxy3StartMenu[3], 0.219999, 1.299998);
    TextDrawColor(Galaxy3StartMenu[3], -1);
    TextDrawSetOutline(Galaxy3StartMenu[3], 0);
    TextDrawSetProportional(Galaxy3StartMenu[3], 1);
    TextDrawSetShadow(Galaxy3StartMenu[3], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[3], 0);

    Galaxy3StartMenu[4] = TextDrawCreate(571.000000, 315.000000, ".");
    TextDrawAlignment(Galaxy3StartMenu[4], 2);
    TextDrawBackgroundColor(Galaxy3StartMenu[4], 255);
    TextDrawFont(Galaxy3StartMenu[4], 1);
    TextDrawLetterSize(Galaxy3StartMenu[4], 2.579998, 9.000000);
    TextDrawColor(Galaxy3StartMenu[4], -1);
    TextDrawSetOutline(Galaxy3StartMenu[4], 0);
    TextDrawSetProportional(Galaxy3StartMenu[4], 1);
    TextDrawSetShadow(Galaxy3StartMenu[4], 0);
    TextDrawTextSize(Galaxy3StartMenu[4], 20.000000, 45.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[4], 0);

    Galaxy3StartMenu[5] = TextDrawCreate(545.000000, 369.000000, "SMS~n~_");
    TextDrawAlignment(Galaxy3StartMenu[5], 2);
    TextDrawBackgroundColor(Galaxy3StartMenu[5], 255);
    TextDrawFont(Galaxy3StartMenu[5], 1);
    TextDrawLetterSize(Galaxy3StartMenu[5], 0.250000, 0.800000);
    TextDrawColor(Galaxy3StartMenu[5], 255);
    TextDrawSetOutline(Galaxy3StartMenu[5], 0);
    TextDrawSetProportional(Galaxy3StartMenu[5], 1);
    TextDrawSetShadow(Galaxy3StartMenu[5], 0);
    TextDrawUseBox(Galaxy3StartMenu[5], 1);
    TextDrawBoxColor(Galaxy3StartMenu[5], -65281);
    TextDrawTextSize(Galaxy3StartMenu[5], 7.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[5], 1);

    Galaxy3StartMenu[6] = TextDrawCreate(515.000000, 369.000000, "Call~n~_");
    TextDrawAlignment(Galaxy3StartMenu[6], 2);
    TextDrawBackgroundColor(Galaxy3StartMenu[6], 255);
    TextDrawFont(Galaxy3StartMenu[6], 1);
    TextDrawLetterSize(Galaxy3StartMenu[6], 0.340000, 0.800000);
    TextDrawColor(Galaxy3StartMenu[6], 255);
    TextDrawSetOutline(Galaxy3StartMenu[6], 0);
    TextDrawSetProportional(Galaxy3StartMenu[6], 1);
    TextDrawSetShadow(Galaxy3StartMenu[6], 0);
    TextDrawUseBox(Galaxy3StartMenu[6], 1);
    TextDrawBoxColor(Galaxy3StartMenu[6], 16711935);
    TextDrawTextSize(Galaxy3StartMenu[6], 7.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[6], 1);

    Galaxy3StartMenu[7] = TextDrawCreate(610.000000, 189.000000, "_");
    TextDrawBackgroundColor(Galaxy3StartMenu[7], 255);
    TextDrawFont(Galaxy3StartMenu[7], 1);
    TextDrawLetterSize(Galaxy3StartMenu[7], 0.500000, 0.499998);
    TextDrawColor(Galaxy3StartMenu[7], -1);
    TextDrawSetOutline(Galaxy3StartMenu[7], 0);
    TextDrawSetProportional(Galaxy3StartMenu[7], 1);
    TextDrawSetShadow(Galaxy3StartMenu[7], 1);
    TextDrawUseBox(Galaxy3StartMenu[7], 1);
    TextDrawBoxColor(Galaxy3StartMenu[7], 842150655);
    TextDrawTextSize(Galaxy3StartMenu[7], 499.000000, 10.000000);
    TextDrawSetSelectable(Galaxy3StartMenu[7], 0);

    Galaxy3StartMenu[8] = TextDrawCreate(578.000000, 188.000000, "00:00");
    TextDrawBackgroundColor(Galaxy3StartMenu[8], 255);
    TextDrawFont(Galaxy3StartMenu[8], 1);
    TextDrawLetterSize(Galaxy3StartMenu[8], 0.289999, 0.699998);
    TextDrawColor(Galaxy3StartMenu[8], -1);
    TextDrawSetOutline(Galaxy3StartMenu[8], 0);
    TextDrawSetProportional(Galaxy3StartMenu[8], 1);
    TextDrawSetShadow(Galaxy3StartMenu[8], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[8], 0);

    Galaxy3StartMenu[9] = TextDrawCreate(504.000000, 188.000000, "_");
    TextDrawBackgroundColor(Galaxy3StartMenu[9], 255);
    TextDrawFont(Galaxy3StartMenu[9], 1);
    TextDrawLetterSize(Galaxy3StartMenu[9], 0.289999, 0.699998);
    TextDrawColor(Galaxy3StartMenu[9], -1);
    TextDrawSetOutline(Galaxy3StartMenu[9], 0);
    TextDrawSetProportional(Galaxy3StartMenu[9], 1);
    TextDrawSetShadow(Galaxy3StartMenu[9], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[9], 0);

    Galaxy3StartMenu[10] = TextDrawCreate(571.000000, 188.000000, "I");
    TextDrawBackgroundColor(Galaxy3StartMenu[10], 255);
    TextDrawFont(Galaxy3StartMenu[10], 1);
    TextDrawLetterSize(Galaxy3StartMenu[10], 0.539999, 0.699998);
    TextDrawColor(Galaxy3StartMenu[10], 16711935);
    TextDrawSetOutline(Galaxy3StartMenu[10], 0);
    TextDrawSetProportional(Galaxy3StartMenu[10], 1);
    TextDrawSetShadow(Galaxy3StartMenu[10], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[10], 0);
    //
    Galaxy3SMainMenu[0] = TextDrawCreate(503.000000, 198.000000, "_");
    TextDrawBackgroundColor(Galaxy3SMainMenu[0], 255);
    TextDrawFont(Galaxy3SMainMenu[0], 1);
    TextDrawLetterSize(Galaxy3SMainMenu[0], 0.500000, 21.300004);
    TextDrawColor(Galaxy3SMainMenu[0], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[0], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[0], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[0], 1);
    TextDrawUseBox(Galaxy3SMainMenu[0], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[0], 1347440895);
    TextDrawTextSize(Galaxy3SMainMenu[0], 606.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[0], 0);

    Galaxy3SMainMenu[1] = TextDrawCreate(529.000000, 211.000000, "CALCULATOR");
    TextDrawAlignment(Galaxy3SMainMenu[1], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[1], 255);
    TextDrawFont(Galaxy3SMainMenu[1], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[1], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[1], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[1], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[1], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[1], 0);
    TextDrawUseBox(Galaxy3SMainMenu[1], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[1], -16776961);
    TextDrawTextSize(Galaxy3SMainMenu[1], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[1], 1);

    Galaxy3SMainMenu[2] = TextDrawCreate(579.000000, 211.000000, "CLOCK");
    TextDrawAlignment(Galaxy3SMainMenu[2], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[2], 255);
    TextDrawFont(Galaxy3SMainMenu[2], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[2], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[2], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[2], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[2], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[2], 0);
    TextDrawUseBox(Galaxy3SMainMenu[2], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[2], 16711935);
    TextDrawTextSize(Galaxy3SMainMenu[2], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[2], 1);

    Galaxy3SMainMenu[3] = TextDrawCreate(579.000000, 234.000000, "CAMERA");
    TextDrawAlignment(Galaxy3SMainMenu[3], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[3], 255);
    TextDrawFont(Galaxy3SMainMenu[3], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[3], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[3], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[3], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[3], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[3], 0);
    TextDrawUseBox(Galaxy3SMainMenu[3], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[3], 65535);
    TextDrawTextSize(Galaxy3SMainMenu[3], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[3], 1);

    Galaxy3SMainMenu[4] = TextDrawCreate(529.000000, 234.000000, "GALLERY");
    TextDrawAlignment(Galaxy3SMainMenu[4], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[4], 255);
    TextDrawFont(Galaxy3SMainMenu[4], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[4], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[4], -16776961);
    TextDrawSetOutline(Galaxy3SMainMenu[4], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[4], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[4], 0);
    TextDrawUseBox(Galaxy3SMainMenu[4], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[4], -65281);
    TextDrawTextSize(Galaxy3SMainMenu[4], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[4], 1);

    Galaxy3SMainMenu[5] = TextDrawCreate(529.000000, 258.000000, "MAPS");
    TextDrawAlignment(Galaxy3SMainMenu[5], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[5], 255);
    TextDrawFont(Galaxy3SMainMenu[5], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[5], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[5], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[5], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[5], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[5], 0);
    TextDrawUseBox(Galaxy3SMainMenu[5], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[5], -16711681);
    TextDrawTextSize(Galaxy3SMainMenu[5], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[5], 1);

    Galaxy3SMainMenu[6] = TextDrawCreate(580.000000, 258.000000, "WEATHER");
    TextDrawAlignment(Galaxy3SMainMenu[6], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[6], 255);
    TextDrawFont(Galaxy3SMainMenu[6], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[6], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[6], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[6], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[6], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[6], 0);
    TextDrawUseBox(Galaxy3SMainMenu[6], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[6], 16777215);
    TextDrawTextSize(Galaxy3SMainMenu[6], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[6], 1);

    Galaxy3SMainMenu[7] = TextDrawCreate(529.000000, 281.000000, "RADIO");
    TextDrawAlignment(Galaxy3SMainMenu[7], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[7], 255);
    TextDrawFont(Galaxy3SMainMenu[7], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[7], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[7], 255);
    TextDrawSetOutline(Galaxy3SMainMenu[7], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[7], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[7], 0);
    TextDrawUseBox(Galaxy3SMainMenu[7], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[7], -1);
    TextDrawTextSize(Galaxy3SMainMenu[7], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[7], 1);

    Galaxy3SMainMenu[8] = TextDrawCreate(580.000000, 281.000000, "LATITUDE");
    TextDrawAlignment(Galaxy3SMainMenu[8], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[8], 255);
    TextDrawFont(Galaxy3SMainMenu[8], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[8], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[8], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[8], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[8], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[8], 0);
    TextDrawUseBox(Galaxy3SMainMenu[8], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[8], 255);
    TextDrawTextSize(Galaxy3SMainMenu[8], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[8], 1);

    Galaxy3SMainMenu[9] = TextDrawCreate(529.000000, 303.000000, "MUSIC");
    TextDrawAlignment(Galaxy3SMainMenu[9], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[9], 255);
    TextDrawFont(Galaxy3SMainMenu[9], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[9], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[9], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[9], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[9], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[9], 0);
    TextDrawUseBox(Galaxy3SMainMenu[9], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[9], -16776961);
    TextDrawTextSize(Galaxy3SMainMenu[9], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[9], 1);

    Galaxy3SMainMenu[10] = TextDrawCreate(580.000000, 303.000000, "GAMES");
    TextDrawAlignment(Galaxy3SMainMenu[10], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[10], 255);
    TextDrawFont(Galaxy3SMainMenu[10], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[10], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[10], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[10], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[10], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[10], 0);
    TextDrawUseBox(Galaxy3SMainMenu[10], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[10], 16711935);
    TextDrawTextSize(Galaxy3SMainMenu[10], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[10], 1);

    Galaxy3SMainMenu[11] = TextDrawCreate(554.000000, 371.000000, "BEHIND");
    TextDrawAlignment(Galaxy3SMainMenu[11], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[11], 255);
    TextDrawFont(Galaxy3SMainMenu[11], 1);
    TextDrawLetterSize(Galaxy3SMainMenu[11], 0.509999, 1.100000);
    TextDrawColor(Galaxy3SMainMenu[11], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[11], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[11], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[11], 0);
    TextDrawUseBox(Galaxy3SMainMenu[11], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[11], 255);
    TextDrawTextSize(Galaxy3SMainMenu[11], 15.000000, 94.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[11], 1);

    Galaxy3SMainMenu[12] = TextDrawCreate(529.000000, 326.000000, "WHATSAPP");
    TextDrawAlignment(Galaxy3SMainMenu[12], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[12], 255);
    TextDrawFont(Galaxy3SMainMenu[12], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[12], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[12], 255);
    TextDrawSetOutline(Galaxy3SMainMenu[12], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[12], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[12], 0);
    TextDrawUseBox(Galaxy3SMainMenu[12], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[12], -1);
    TextDrawTextSize(Galaxy3SMainMenu[12], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[12], 1);

    Galaxy3SMainMenu[13] = TextDrawCreate(580.000000, 326.000000, "CONTACT");
    TextDrawAlignment(Galaxy3SMainMenu[13], 2);
    TextDrawBackgroundColor(Galaxy3SMainMenu[13], 255);
    TextDrawFont(Galaxy3SMainMenu[13], 2);
    TextDrawLetterSize(Galaxy3SMainMenu[13], 0.140000, 1.000000);
    TextDrawColor(Galaxy3SMainMenu[13], -1);
    TextDrawSetOutline(Galaxy3SMainMenu[13], 0);
    TextDrawSetProportional(Galaxy3SMainMenu[13], 1);
    TextDrawSetShadow(Galaxy3SMainMenu[13], 0);
    TextDrawUseBox(Galaxy3SMainMenu[13], 1);
    TextDrawBoxColor(Galaxy3SMainMenu[13], 255);
    TextDrawTextSize(Galaxy3SMainMenu[13], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3SMainMenu[13], 1);

    //Calculator TD
    CalculatorTD[0] = TextDrawCreate(512.000000, 247.000000, "_");
    TextDrawBackgroundColor(CalculatorTD[0], 255);
    TextDrawFont(CalculatorTD[0], 1);
    TextDrawLetterSize(CalculatorTD[0], 0.500000, 2.599997);
    TextDrawColor(CalculatorTD[0], -1);
    TextDrawSetOutline(CalculatorTD[0], 0);
    TextDrawSetProportional(CalculatorTD[0], 1);
    TextDrawSetShadow(CalculatorTD[0], 1);
    TextDrawUseBox(CalculatorTD[0], 1);
    TextDrawBoxColor(CalculatorTD[0], 255);
    TextDrawTextSize(CalculatorTD[0], 595.000000, -20.000000);
    TextDrawSetSelectable(CalculatorTD[0], 0);

    CalculatorTD[1] = TextDrawCreate(519.000000, 292.000000, "7");
    TextDrawAlignment(CalculatorTD[1], 2);
    TextDrawBackgroundColor(CalculatorTD[1], 255);
    TextDrawFont(CalculatorTD[1], 1);
    TextDrawLetterSize(CalculatorTD[1], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[1], -1);
    TextDrawSetOutline(CalculatorTD[1], 0);
    TextDrawSetProportional(CalculatorTD[1], 1);
    TextDrawSetShadow(CalculatorTD[1], 0);
    TextDrawUseBox(CalculatorTD[1], 1);
    TextDrawBoxColor(CalculatorTD[1], 255);
    TextDrawTextSize(CalculatorTD[1], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[1], 1);

    CalculatorTD[2] = TextDrawCreate(543.000000, 292.000000, "8");
    TextDrawAlignment(CalculatorTD[2], 2);
    TextDrawBackgroundColor(CalculatorTD[2], 255);
    TextDrawFont(CalculatorTD[2], 1);
    TextDrawLetterSize(CalculatorTD[2], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[2], -1);
    TextDrawSetOutline(CalculatorTD[2], 0);
    TextDrawSetProportional(CalculatorTD[2], 1);
    TextDrawSetShadow(CalculatorTD[2], 0);
    TextDrawUseBox(CalculatorTD[2], 1);
    TextDrawBoxColor(CalculatorTD[2], 255);
    TextDrawTextSize(CalculatorTD[2], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[2], 1);

    CalculatorTD[3] = TextDrawCreate(564.000000, 292.000000, "9");
    TextDrawAlignment(CalculatorTD[3], 2);
    TextDrawBackgroundColor(CalculatorTD[3], 255);
    TextDrawFont(CalculatorTD[3], 1);
    TextDrawLetterSize(CalculatorTD[3], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[3], -1);
    TextDrawSetOutline(CalculatorTD[3], 0);
    TextDrawSetProportional(CalculatorTD[3], 1);
    TextDrawSetShadow(CalculatorTD[3], 0);
    TextDrawUseBox(CalculatorTD[3], 1);
    TextDrawBoxColor(CalculatorTD[3], 255);
    TextDrawTextSize(CalculatorTD[3], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[3], 1);

    CalculatorTD[4] = TextDrawCreate(588.000000, 292.000000, "/");
    TextDrawAlignment(CalculatorTD[4], 2);
    TextDrawBackgroundColor(CalculatorTD[4], 255);
    TextDrawFont(CalculatorTD[4], 1);
    TextDrawLetterSize(CalculatorTD[4], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[4], -1);
    TextDrawSetOutline(CalculatorTD[4], 0);
    TextDrawSetProportional(CalculatorTD[4], 1);
    TextDrawSetShadow(CalculatorTD[4], 0);
    TextDrawUseBox(CalculatorTD[4], 1);
    TextDrawBoxColor(CalculatorTD[4], 255);
    TextDrawTextSize(CalculatorTD[4], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[4], 1);

    CalculatorTD[5] = TextDrawCreate(588.000000, 313.000000, "X");
    TextDrawAlignment(CalculatorTD[5], 2);
    TextDrawBackgroundColor(CalculatorTD[5], 255);
    TextDrawFont(CalculatorTD[5], 1);
    TextDrawLetterSize(CalculatorTD[5], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[5], -1);
    TextDrawSetOutline(CalculatorTD[5], 0);
    TextDrawSetProportional(CalculatorTD[5], 1);
    TextDrawSetShadow(CalculatorTD[5], 0);
    TextDrawUseBox(CalculatorTD[5], 1);
    TextDrawBoxColor(CalculatorTD[5], 255);
    TextDrawTextSize(CalculatorTD[5], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[5], 1);

    CalculatorTD[6] = TextDrawCreate(588.000000, 334.000000, "-");
    TextDrawAlignment(CalculatorTD[6], 2);
    TextDrawBackgroundColor(CalculatorTD[6], 255);
    TextDrawFont(CalculatorTD[6], 1);
    TextDrawLetterSize(CalculatorTD[6], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[6], -1);
    TextDrawSetOutline(CalculatorTD[6], 0);
    TextDrawSetProportional(CalculatorTD[6], 1);
    TextDrawSetShadow(CalculatorTD[6], 0);
    TextDrawUseBox(CalculatorTD[6], 1);
    TextDrawBoxColor(CalculatorTD[6], 255);
    TextDrawTextSize(CalculatorTD[6], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[6], 1);

    CalculatorTD[7] = TextDrawCreate(588.000000, 355.000000, "+");
    TextDrawAlignment(CalculatorTD[7], 2);
    TextDrawBackgroundColor(CalculatorTD[7], 255);
    TextDrawFont(CalculatorTD[7], 1);
    TextDrawLetterSize(CalculatorTD[7], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[7], -1);
    TextDrawSetOutline(CalculatorTD[7], 0);
    TextDrawSetProportional(CalculatorTD[7], 1);
    TextDrawSetShadow(CalculatorTD[7], 0);
    TextDrawUseBox(CalculatorTD[7], 1);
    TextDrawBoxColor(CalculatorTD[7], 255);
    TextDrawTextSize(CalculatorTD[7], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[7], 1);

    CalculatorTD[8] = TextDrawCreate(564.000000, 313.000000, "6");
    TextDrawAlignment(CalculatorTD[8], 2);
    TextDrawBackgroundColor(CalculatorTD[8], 255);
    TextDrawFont(CalculatorTD[8], 1);
    TextDrawLetterSize(CalculatorTD[8], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[8], -1);
    TextDrawSetOutline(CalculatorTD[8], 0);
    TextDrawSetProportional(CalculatorTD[8], 1);
    TextDrawSetShadow(CalculatorTD[8], 0);
    TextDrawUseBox(CalculatorTD[8], 1);
    TextDrawBoxColor(CalculatorTD[8], 255);
    TextDrawTextSize(CalculatorTD[8], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[8], 1);

    CalculatorTD[9] = TextDrawCreate(543.000000, 313.000000, "5");
    TextDrawAlignment(CalculatorTD[9], 2);
    TextDrawBackgroundColor(CalculatorTD[9], 255);
    TextDrawFont(CalculatorTD[9], 1);
    TextDrawLetterSize(CalculatorTD[9], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[9], -1);
    TextDrawSetOutline(CalculatorTD[9], 0);
    TextDrawSetProportional(CalculatorTD[9], 1);
    TextDrawSetShadow(CalculatorTD[9], 0);
    TextDrawUseBox(CalculatorTD[9], 1);
    TextDrawBoxColor(CalculatorTD[9], 255);
    TextDrawTextSize(CalculatorTD[9], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[9], 1);

    CalculatorTD[10] = TextDrawCreate(519.000000, 313.000000, "4");
    TextDrawAlignment(CalculatorTD[10], 2);
    TextDrawBackgroundColor(CalculatorTD[10], 255);
    TextDrawFont(CalculatorTD[10], 1);
    TextDrawLetterSize(CalculatorTD[10], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[10], -1);
    TextDrawSetOutline(CalculatorTD[10], 0);
    TextDrawSetProportional(CalculatorTD[10], 1);
    TextDrawSetShadow(CalculatorTD[10], 0);
    TextDrawUseBox(CalculatorTD[10], 1);
    TextDrawBoxColor(CalculatorTD[10], 255);
    TextDrawTextSize(CalculatorTD[10], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[10], 1);

    CalculatorTD[11] = TextDrawCreate(519.000000, 334.000000, "1");
    TextDrawAlignment(CalculatorTD[11], 2);
    TextDrawBackgroundColor(CalculatorTD[11], 255);
    TextDrawFont(CalculatorTD[11], 1);
    TextDrawLetterSize(CalculatorTD[11], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[11], -1);
    TextDrawSetOutline(CalculatorTD[11], 0);
    TextDrawSetProportional(CalculatorTD[11], 1);
    TextDrawSetShadow(CalculatorTD[11], 0);
    TextDrawUseBox(CalculatorTD[11], 1);
    TextDrawBoxColor(CalculatorTD[11], 255);
    TextDrawTextSize(CalculatorTD[11], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[11], 1);

    CalculatorTD[12] = TextDrawCreate(543.000000, 334.000000, "2");
    TextDrawAlignment(CalculatorTD[12], 2);
    TextDrawBackgroundColor(CalculatorTD[12], 255);
    TextDrawFont(CalculatorTD[12], 1);
    TextDrawLetterSize(CalculatorTD[12], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[12], -1);
    TextDrawSetOutline(CalculatorTD[12], 0);
    TextDrawSetProportional(CalculatorTD[12], 1);
    TextDrawSetShadow(CalculatorTD[12], 0);
    TextDrawUseBox(CalculatorTD[12], 1);
    TextDrawBoxColor(CalculatorTD[12], 255);
    TextDrawTextSize(CalculatorTD[12], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[12], 1);

    CalculatorTD[13] = TextDrawCreate(564.000000, 334.000000, "3");
    TextDrawAlignment(CalculatorTD[13], 2);
    TextDrawBackgroundColor(CalculatorTD[13], 255);
    TextDrawFont(CalculatorTD[13], 1);
    TextDrawLetterSize(CalculatorTD[13], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[13], -1);
    TextDrawSetOutline(CalculatorTD[13], 0);
    TextDrawSetProportional(CalculatorTD[13], 1);
    TextDrawSetShadow(CalculatorTD[13], 0);
    TextDrawUseBox(CalculatorTD[13], 1);
    TextDrawBoxColor(CalculatorTD[13], 255);
    TextDrawTextSize(CalculatorTD[13], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[13], 1);

    CalculatorTD[14] = TextDrawCreate(519.000000, 355.000000, "0");
    TextDrawAlignment(CalculatorTD[14], 2);
    TextDrawBackgroundColor(CalculatorTD[14], 255);
    TextDrawFont(CalculatorTD[14], 1);
    TextDrawLetterSize(CalculatorTD[14], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[14], -1);
    TextDrawSetOutline(CalculatorTD[14], 0);
    TextDrawSetProportional(CalculatorTD[14], 1);
    TextDrawSetShadow(CalculatorTD[14], 0);
    TextDrawUseBox(CalculatorTD[14], 1);
    TextDrawBoxColor(CalculatorTD[14], 255);
    TextDrawTextSize(CalculatorTD[14], 10.000000, 14.000000);
    TextDrawSetSelectable(CalculatorTD[14], 1);

    CalculatorTD[15] = TextDrawCreate(553.000000, 355.000000, "=");
    TextDrawAlignment(CalculatorTD[15], 2);
    TextDrawBackgroundColor(CalculatorTD[15], 255);
    TextDrawFont(CalculatorTD[15], 1);
    TextDrawLetterSize(CalculatorTD[15], 0.340000, 1.100000);
    TextDrawColor(CalculatorTD[15], -1);
    TextDrawSetOutline(CalculatorTD[15], 0);
    TextDrawSetProportional(CalculatorTD[15], 1);
    TextDrawSetShadow(CalculatorTD[15], 0);
    TextDrawUseBox(CalculatorTD[15], 1);
    TextDrawBoxColor(CalculatorTD[15], 255);
    TextDrawTextSize(CalculatorTD[15], 10.000000, 35.000000);
    TextDrawSetSelectable(CalculatorTD[15], 1);

    CalculatorTD[16] = TextDrawCreate(554.000000, 209.000000, "CALCULATOR");
    TextDrawAlignment(CalculatorTD[16], 2);
    TextDrawBackgroundColor(CalculatorTD[16], 255);
    TextDrawFont(CalculatorTD[16], 2);
    TextDrawLetterSize(CalculatorTD[16], 0.310000, 1.300000);
    TextDrawColor(CalculatorTD[16], -16776961);
    TextDrawSetOutline(CalculatorTD[16], 0);
    TextDrawSetProportional(CalculatorTD[16], 1);
    TextDrawSetShadow(CalculatorTD[16], 0);
    TextDrawUseBox(CalculatorTD[16], 1);
    TextDrawBoxColor(CalculatorTD[16], 255);
    TextDrawTextSize(CalculatorTD[16], 602.000000, 92.000000);
    TextDrawSetSelectable(CalculatorTD[16], 0);

    Galaxy3StartMenu[11] = TextDrawCreate(528.000000, 231.000000, "00/MON/00");
    TextDrawBackgroundColor(Galaxy3StartMenu[11], 255);
    TextDrawFont(Galaxy3StartMenu[11], 2);
    TextDrawLetterSize(Galaxy3StartMenu[11], 0.219999, 1.299998);
    TextDrawColor(Galaxy3StartMenu[11], -1);
    TextDrawSetOutline(Galaxy3StartMenu[11], 0);
    TextDrawSetProportional(Galaxy3StartMenu[11], 1);
    TextDrawSetShadow(Galaxy3StartMenu[11], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[11], 0);

    Galaxy3StartMenu[12] = TextDrawCreate(523.000000, 210.000000, "00:00");
    TextDrawBackgroundColor(Galaxy3StartMenu[12], 255);
    TextDrawFont(Galaxy3StartMenu[12], 2);
    TextDrawLetterSize(Galaxy3StartMenu[12], 0.559998, 2.599998);
    TextDrawColor(Galaxy3StartMenu[12], -1);
    TextDrawSetOutline(Galaxy3StartMenu[12], 0);
    TextDrawSetProportional(Galaxy3StartMenu[12], 1);
    TextDrawSetShadow(Galaxy3StartMenu[12], 0);
    TextDrawSetSelectable(Galaxy3StartMenu[12], 0);

    //Gallery
    Galaxy3Gallery[0] = TextDrawCreate(506.000000, 231.000000, "loadsc2:loadsc2");
    TextDrawAlignment(Galaxy3Gallery[0], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[0], 255);
    TextDrawFont(Galaxy3Gallery[0], 4);
    TextDrawLetterSize(Galaxy3Gallery[0], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[0], -1);
    TextDrawSetOutline(Galaxy3Gallery[0], 0);
    TextDrawSetProportional(Galaxy3Gallery[0], 1);
    TextDrawSetShadow(Galaxy3Gallery[0], 1);
    TextDrawUseBox(Galaxy3Gallery[0], 1);
    TextDrawBoxColor(Galaxy3Gallery[0], 255);
    TextDrawTextSize(Galaxy3Gallery[0], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[0], 1);

    Galaxy3Gallery[1] = TextDrawCreate(557.000000, 231.000000, "loadsc11:loadsc11");
    TextDrawAlignment(Galaxy3Gallery[1], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[1], 255);
    TextDrawFont(Galaxy3Gallery[1], 4);
    TextDrawLetterSize(Galaxy3Gallery[1], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[1], -1);
    TextDrawSetOutline(Galaxy3Gallery[1], 0);
    TextDrawSetProportional(Galaxy3Gallery[1], 1);
    TextDrawSetShadow(Galaxy3Gallery[1], 1);
    TextDrawUseBox(Galaxy3Gallery[1], 1);
    TextDrawBoxColor(Galaxy3Gallery[1], 255);
    TextDrawTextSize(Galaxy3Gallery[1], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[1], 1);

    Galaxy3Gallery[2] = TextDrawCreate(557.000000, 277.000000, "loadsc12:loadsc12");
    TextDrawAlignment(Galaxy3Gallery[2], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[2], 255);
    TextDrawFont(Galaxy3Gallery[2], 4);
    TextDrawLetterSize(Galaxy3Gallery[2], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[2], -1);
    TextDrawSetOutline(Galaxy3Gallery[2], 0);
    TextDrawSetProportional(Galaxy3Gallery[2], 1);
    TextDrawSetShadow(Galaxy3Gallery[2], 1);
    TextDrawUseBox(Galaxy3Gallery[2], 1);
    TextDrawBoxColor(Galaxy3Gallery[2], 255);
    TextDrawTextSize(Galaxy3Gallery[2], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[2], 1);

    Galaxy3Gallery[3] = TextDrawCreate(506.000000, 277.000000, "loadsc3:loadsc3");
    TextDrawAlignment(Galaxy3Gallery[3], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[3], 255);
    TextDrawFont(Galaxy3Gallery[3], 4);
    TextDrawLetterSize(Galaxy3Gallery[3], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[3], -1);
    TextDrawSetOutline(Galaxy3Gallery[3], 0);
    TextDrawSetProportional(Galaxy3Gallery[3], 1);
    TextDrawSetShadow(Galaxy3Gallery[3], 1);
    TextDrawUseBox(Galaxy3Gallery[3], 1);
    TextDrawBoxColor(Galaxy3Gallery[3], 255);
    TextDrawTextSize(Galaxy3Gallery[3], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[3], 1);

    Galaxy3Gallery[4] = TextDrawCreate(506.000000, 325.000000, "loadsc4:loadsc4");
    TextDrawAlignment(Galaxy3Gallery[4], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[4], 255);
    TextDrawFont(Galaxy3Gallery[4], 4);
    TextDrawLetterSize(Galaxy3Gallery[4], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[4], -1);
    TextDrawSetOutline(Galaxy3Gallery[4], 0);
    TextDrawSetProportional(Galaxy3Gallery[4], 1);
    TextDrawSetShadow(Galaxy3Gallery[4], 1);
    TextDrawUseBox(Galaxy3Gallery[4], 1);
    TextDrawBoxColor(Galaxy3Gallery[4], 255);
    TextDrawTextSize(Galaxy3Gallery[4], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[4], 1);

    Galaxy3Gallery[5] = TextDrawCreate(557.000000, 325.000000, "loadsc7:loadsc7");
    TextDrawAlignment(Galaxy3Gallery[5], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[5], 255);
    TextDrawFont(Galaxy3Gallery[5], 4);
    TextDrawLetterSize(Galaxy3Gallery[5], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[5], -1);
    TextDrawSetOutline(Galaxy3Gallery[5], 0);
    TextDrawSetProportional(Galaxy3Gallery[5], 1);
    TextDrawSetShadow(Galaxy3Gallery[5], 1);
    TextDrawUseBox(Galaxy3Gallery[5], 1);
    TextDrawBoxColor(Galaxy3Gallery[5], 255);
    TextDrawTextSize(Galaxy3Gallery[5], 46.000000, 39.000000);
    TextDrawSetSelectable(Galaxy3Gallery[5], 1);

    Galaxy3Gallery[6] = TextDrawCreate(506.000000, 231.000000, "loadsc2:loadsc2");
    TextDrawAlignment(Galaxy3Gallery[6], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[6], 255);
    TextDrawFont(Galaxy3Gallery[6], 4);
    TextDrawLetterSize(Galaxy3Gallery[6], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[6], -1);
    TextDrawSetOutline(Galaxy3Gallery[6], 0);
    TextDrawSetProportional(Galaxy3Gallery[6], 1);
    TextDrawSetShadow(Galaxy3Gallery[6], 1);
    TextDrawUseBox(Galaxy3Gallery[6], 1);
    TextDrawBoxColor(Galaxy3Gallery[6], 255);
    TextDrawTextSize(Galaxy3Gallery[6], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[6], 1);

    Galaxy3Gallery[7] = TextDrawCreate(506.000000, 231.000000, "loadsc11:loadsc11");
    TextDrawAlignment(Galaxy3Gallery[7], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[7], 255);
    TextDrawFont(Galaxy3Gallery[7], 4);
    TextDrawLetterSize(Galaxy3Gallery[7], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[7], -1);
    TextDrawSetOutline(Galaxy3Gallery[7], 0);
    TextDrawSetProportional(Galaxy3Gallery[7], 1);
    TextDrawSetShadow(Galaxy3Gallery[7], 1);
    TextDrawUseBox(Galaxy3Gallery[7], 1);
    TextDrawBoxColor(Galaxy3Gallery[7], 255);
    TextDrawTextSize(Galaxy3Gallery[7], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[7], 1);

    Galaxy3Gallery[8] = TextDrawCreate(506.000000, 231.000000, "loadsc12:loadsc12");
    TextDrawAlignment(Galaxy3Gallery[8], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[8], 255);
    TextDrawFont(Galaxy3Gallery[8], 4);
    TextDrawLetterSize(Galaxy3Gallery[8], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[8], -1);
    TextDrawSetOutline(Galaxy3Gallery[8], 0);
    TextDrawSetProportional(Galaxy3Gallery[8], 1);
    TextDrawSetShadow(Galaxy3Gallery[8], 1);
    TextDrawUseBox(Galaxy3Gallery[8], 1);
    TextDrawBoxColor(Galaxy3Gallery[8], 255);
    TextDrawTextSize(Galaxy3Gallery[8], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[8], 1);

    Galaxy3Gallery[9] = TextDrawCreate(506.000000, 231.000000, "loadsc3:loadsc3");
    TextDrawAlignment(Galaxy3Gallery[9], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[9], 255);
    TextDrawFont(Galaxy3Gallery[9], 4);
    TextDrawLetterSize(Galaxy3Gallery[9], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[9], -1);
    TextDrawSetOutline(Galaxy3Gallery[9], 0);
    TextDrawSetProportional(Galaxy3Gallery[9], 1);
    TextDrawSetShadow(Galaxy3Gallery[9], 1);
    TextDrawUseBox(Galaxy3Gallery[9], 1);
    TextDrawBoxColor(Galaxy3Gallery[9], 255);
    TextDrawTextSize(Galaxy3Gallery[9], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[9], 1);

    Galaxy3Gallery[10] = TextDrawCreate(506.000000, 231.000000, "loadsc4:loadsc4");
    TextDrawAlignment(Galaxy3Gallery[10], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[10], 255);
    TextDrawFont(Galaxy3Gallery[10], 4);
    TextDrawLetterSize(Galaxy3Gallery[10], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[10], -1);
    TextDrawSetOutline(Galaxy3Gallery[10], 0);
    TextDrawSetProportional(Galaxy3Gallery[10], 1);
    TextDrawSetShadow(Galaxy3Gallery[10], 1);
    TextDrawUseBox(Galaxy3Gallery[10], 1);
    TextDrawBoxColor(Galaxy3Gallery[10], 255);
    TextDrawTextSize(Galaxy3Gallery[10], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[10], 1);

    Galaxy3Gallery[11] = TextDrawCreate(506.000000, 231.000000, "loadsc7:loadsc7");
    TextDrawAlignment(Galaxy3Gallery[11], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[11], 255);
    TextDrawFont(Galaxy3Gallery[11], 4);
    TextDrawLetterSize(Galaxy3Gallery[11], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Gallery[11], -1);
    TextDrawSetOutline(Galaxy3Gallery[11], 0);
    TextDrawSetProportional(Galaxy3Gallery[11], 1);
    TextDrawSetShadow(Galaxy3Gallery[11], 1);
    TextDrawUseBox(Galaxy3Gallery[11], 1);
    TextDrawBoxColor(Galaxy3Gallery[11], 255);
    TextDrawTextSize(Galaxy3Gallery[11], 97.000000, 133.000000);
    TextDrawSetSelectable(Galaxy3Gallery[11], 1);

    Galaxy3Gallery[12] = TextDrawCreate(554.000000, 209.000000, "GALLERY");
    TextDrawAlignment(Galaxy3Gallery[12], 2);
    TextDrawBackgroundColor(Galaxy3Gallery[12], 255);
    TextDrawFont(Galaxy3Gallery[12], 2);
    TextDrawLetterSize(Galaxy3Gallery[12], 0.310000, 1.300000);
    TextDrawColor(Galaxy3Gallery[12], -16776961);
    TextDrawSetOutline(Galaxy3Gallery[12], 0);
    TextDrawSetProportional(Galaxy3Gallery[12], 1);
    TextDrawSetShadow(Galaxy3Gallery[12], 0);
    TextDrawUseBox(Galaxy3Gallery[12], 1);
    TextDrawBoxColor(Galaxy3Gallery[12], 255);
    TextDrawTextSize(Galaxy3Gallery[12], 602.000000, 92.000000);
    TextDrawSetSelectable(Galaxy3Gallery[12], 0);

    //Camera
    Galaxy3Camera[0] = TextDrawCreate(493.000000, 156.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3Camera[0], 255);
    TextDrawFont(Galaxy3Camera[0], 4);
    TextDrawLetterSize(Galaxy3Camera[0], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Camera[0], -1);
    TextDrawSetOutline(Galaxy3Camera[0], 0);
    TextDrawSetProportional(Galaxy3Camera[0], 1);
    TextDrawSetShadow(Galaxy3Camera[0], 1);
    TextDrawUseBox(Galaxy3Camera[0], 1);
    TextDrawBoxColor(Galaxy3Camera[0], 255);
    TextDrawTextSize(Galaxy3Camera[0], 27.000000, 33.000000);
    TextDrawSetSelectable(Galaxy3Camera[0], 0);

    Galaxy3Camera[1] = TextDrawCreate(493.000000, 423.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3Camera[1], 255);
    TextDrawFont(Galaxy3Camera[1], 4);
    TextDrawLetterSize(Galaxy3Camera[1], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Camera[1], -1);
    TextDrawSetOutline(Galaxy3Camera[1], 0);
    TextDrawSetProportional(Galaxy3Camera[1], 1);
    TextDrawSetShadow(Galaxy3Camera[1], 1);
    TextDrawUseBox(Galaxy3Camera[1], 1);
    TextDrawBoxColor(Galaxy3Camera[1], 255);
    TextDrawTextSize(Galaxy3Camera[1], 27.000000, -33.000000);
    TextDrawSetSelectable(Galaxy3Camera[1], 0);

    Galaxy3Camera[2] = TextDrawCreate(615.000000, 423.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3Camera[2], 255);
    TextDrawFont(Galaxy3Camera[2], 4);
    TextDrawLetterSize(Galaxy3Camera[2], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Camera[2], -1);
    TextDrawSetOutline(Galaxy3Camera[2], 0);
    TextDrawSetProportional(Galaxy3Camera[2], 1);
    TextDrawSetShadow(Galaxy3Camera[2], 1);
    TextDrawUseBox(Galaxy3Camera[2], 1);
    TextDrawBoxColor(Galaxy3Camera[2], 255);
    TextDrawTextSize(Galaxy3Camera[2], -27.000000, -33.000000);
    TextDrawSetSelectable(Galaxy3Camera[2], 0);

    Galaxy3Camera[3] = TextDrawCreate(615.000000, 156.000000, "hud:radardisc");
    TextDrawBackgroundColor(Galaxy3Camera[3], 255);
    TextDrawFont(Galaxy3Camera[3], 4);
    TextDrawLetterSize(Galaxy3Camera[3], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Camera[3], -1);
    TextDrawSetOutline(Galaxy3Camera[3], 0);
    TextDrawSetProportional(Galaxy3Camera[3], 1);
    TextDrawSetShadow(Galaxy3Camera[3], 1);
    TextDrawUseBox(Galaxy3Camera[3], 1);
    TextDrawBoxColor(Galaxy3Camera[3], 255);
    TextDrawTextSize(Galaxy3Camera[3], -27.000000, 33.000000);
    TextDrawSetSelectable(Galaxy3Camera[3], 0);

    Galaxy3Camera[4] = TextDrawCreate(503.000000, 191.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[4], 255);
    TextDrawFont(Galaxy3Camera[4], 1);
    TextDrawLetterSize(Galaxy3Camera[4], 0.500000, 22.200000);
    TextDrawColor(Galaxy3Camera[4], -1);
    TextDrawSetOutline(Galaxy3Camera[4], 0);
    TextDrawSetProportional(Galaxy3Camera[4], 1);
    TextDrawSetShadow(Galaxy3Camera[4], 1);
    TextDrawUseBox(Galaxy3Camera[4], 1);
    TextDrawBoxColor(Galaxy3Camera[4], 255);
    TextDrawTextSize(Galaxy3Camera[4], 491.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3Camera[4], 0);

    Galaxy3Camera[5] = TextDrawCreate(591.000000, 158.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[5], 255);
    TextDrawFont(Galaxy3Camera[5], 1);
    TextDrawLetterSize(Galaxy3Camera[5], 0.500000, 3.000004);
    TextDrawColor(Galaxy3Camera[5], -1);
    TextDrawSetOutline(Galaxy3Camera[5], 0);
    TextDrawSetProportional(Galaxy3Camera[5], 1);
    TextDrawSetShadow(Galaxy3Camera[5], 1);
    TextDrawUseBox(Galaxy3Camera[5], 1);
    TextDrawBoxColor(Galaxy3Camera[5], 255);
    TextDrawTextSize(Galaxy3Camera[5], 518.000000, 5.000000);
    TextDrawSetSelectable(Galaxy3Camera[5], 0);

    Galaxy3Camera[6] = TextDrawCreate(502.000000, 149.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[6], 255);
    TextDrawFont(Galaxy3Camera[6], 1);
    TextDrawLetterSize(Galaxy3Camera[6], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[6], 255);
    TextDrawSetOutline(Galaxy3Camera[6], 0);
    TextDrawSetProportional(Galaxy3Camera[6], 1);
    TextDrawSetShadow(Galaxy3Camera[6], 0);
    TextDrawSetSelectable(Galaxy3Camera[6], 0);

    Galaxy3Camera[7] = TextDrawCreate(494.000000, 156.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[7], 255);
    TextDrawFont(Galaxy3Camera[7], 1);
    TextDrawLetterSize(Galaxy3Camera[7], 1.370000, 5.100000);
    TextDrawColor(Galaxy3Camera[7], 255);
    TextDrawSetOutline(Galaxy3Camera[7], 0);
    TextDrawSetProportional(Galaxy3Camera[7], 1);
    TextDrawSetShadow(Galaxy3Camera[7], 0);
    TextDrawSetSelectable(Galaxy3Camera[7], 0);

    Galaxy3Camera[8] = TextDrawCreate(584.000000, 156.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[8], 255);
    TextDrawFont(Galaxy3Camera[8], 1);
    TextDrawLetterSize(Galaxy3Camera[8], 1.370000, 5.100000);
    TextDrawColor(Galaxy3Camera[8], 255);
    TextDrawSetOutline(Galaxy3Camera[8], 0);
    TextDrawSetProportional(Galaxy3Camera[8], 1);
    TextDrawSetShadow(Galaxy3Camera[8], 0);
    TextDrawSetSelectable(Galaxy3Camera[8], 0);

    Galaxy3Camera[9] = TextDrawCreate(580.000000, 149.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[9], 255);
    TextDrawFont(Galaxy3Camera[9], 1);
    TextDrawLetterSize(Galaxy3Camera[9], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[9], 255);
    TextDrawSetOutline(Galaxy3Camera[9], 0);
    TextDrawSetProportional(Galaxy3Camera[9], 1);
    TextDrawSetShadow(Galaxy3Camera[9], 0);
    TextDrawSetSelectable(Galaxy3Camera[9], 0);

    Galaxy3Camera[10] = TextDrawCreate(617.000000, 190.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[10], 255);
    TextDrawFont(Galaxy3Camera[10], 1);
    TextDrawLetterSize(Galaxy3Camera[10], 0.500000, 22.299993);
    TextDrawColor(Galaxy3Camera[10], -1);
    TextDrawSetOutline(Galaxy3Camera[10], 0);
    TextDrawSetProportional(Galaxy3Camera[10], 1);
    TextDrawSetShadow(Galaxy3Camera[10], 1);
    TextDrawUseBox(Galaxy3Camera[10], 1);
    TextDrawBoxColor(Galaxy3Camera[10], 255);
    TextDrawTextSize(Galaxy3Camera[10], 606.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3Camera[10], 0);

    Galaxy3Camera[11] = TextDrawCreate(553.000000, 397.000000, "u");
    TextDrawAlignment(Galaxy3Camera[11], 2);
    TextDrawBackgroundColor(Galaxy3Camera[11], 255);
    TextDrawFont(Galaxy3Camera[11], 2);
    TextDrawLetterSize(Galaxy3Camera[11], 2.069999, 1.399999);
    TextDrawColor(Galaxy3Camera[11], -1);
    TextDrawSetOutline(Galaxy3Camera[11], 0);
    TextDrawSetProportional(Galaxy3Camera[11], 1);
    TextDrawSetShadow(Galaxy3Camera[11], 1);
    TextDrawSetSelectable(Galaxy3Camera[11], 0);

    Galaxy3Camera[12] = TextDrawCreate(580.000000, 379.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[12], 255);
    TextDrawFont(Galaxy3Camera[12], 1);
    TextDrawLetterSize(Galaxy3Camera[12], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[12], 255);
    TextDrawSetOutline(Galaxy3Camera[12], 0);
    TextDrawSetProportional(Galaxy3Camera[12], 1);
    TextDrawSetShadow(Galaxy3Camera[12], 0);
    TextDrawSetSelectable(Galaxy3Camera[12], 0);

    Galaxy3Camera[13] = TextDrawCreate(502.000000, 380.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[13], 255);
    TextDrawFont(Galaxy3Camera[13], 1);
    TextDrawLetterSize(Galaxy3Camera[13], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[13], 255);
    TextDrawSetOutline(Galaxy3Camera[13], 0);
    TextDrawSetProportional(Galaxy3Camera[13], 1);
    TextDrawSetShadow(Galaxy3Camera[13], 0);
    TextDrawSetSelectable(Galaxy3Camera[13], 0);

    Galaxy3Camera[14] = TextDrawCreate(535.000000, 157.000000, "-");
    TextDrawBackgroundColor(Galaxy3Camera[14], 255);
    TextDrawFont(Galaxy3Camera[14], 1);
    TextDrawLetterSize(Galaxy3Camera[14], 2.569998, 1.799999);
    TextDrawColor(Galaxy3Camera[14], 842150655);
    TextDrawSetOutline(Galaxy3Camera[14], 0);
    TextDrawSetProportional(Galaxy3Camera[14], 1);
    TextDrawSetShadow(Galaxy3Camera[14], 0);
    TextDrawSetSelectable(Galaxy3Camera[14], 0);

    Galaxy3Camera[15] = TextDrawCreate(568.000000, 163.000000, ".. o");
    TextDrawBackgroundColor(Galaxy3Camera[15], 255);
    TextDrawFont(Galaxy3Camera[15], 1);
    TextDrawLetterSize(Galaxy3Camera[15], 0.400000, 1.399999);
    TextDrawColor(Galaxy3Camera[15], 842150655);
    TextDrawSetOutline(Galaxy3Camera[15], 0);
    TextDrawSetProportional(Galaxy3Camera[15], 1);
    TextDrawSetShadow(Galaxy3Camera[15], 0);
    TextDrawSetSelectable(Galaxy3Camera[15], 0);

    Galaxy3Camera[16] = TextDrawCreate(533.000000, 175.000000, "SAMSUNG");
    TextDrawBackgroundColor(Galaxy3Camera[16], 255);
    TextDrawFont(Galaxy3Camera[16], 1);
    TextDrawLetterSize(Galaxy3Camera[16], 0.250000, 0.899999);
    TextDrawColor(Galaxy3Camera[16], -1);
    TextDrawSetOutline(Galaxy3Camera[16], 0);
    TextDrawSetProportional(Galaxy3Camera[16], 1);
    TextDrawSetShadow(Galaxy3Camera[16], 0);
    TextDrawSetSelectable(Galaxy3Camera[16], 0);

    Galaxy3Camera[17] = TextDrawCreate(495.000000, 372.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[17], 255);
    TextDrawFont(Galaxy3Camera[17], 1);
    TextDrawLetterSize(Galaxy3Camera[17], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[17], 255);
    TextDrawSetOutline(Galaxy3Camera[17], 0);
    TextDrawSetProportional(Galaxy3Camera[17], 1);
    TextDrawSetShadow(Galaxy3Camera[17], 0);
    TextDrawSetSelectable(Galaxy3Camera[17], 0);

    Galaxy3Camera[18] = TextDrawCreate(585.000000, 371.000000, "0");
    TextDrawBackgroundColor(Galaxy3Camera[18], 255);
    TextDrawFont(Galaxy3Camera[18], 1);
    TextDrawLetterSize(Galaxy3Camera[18], 1.350000, 5.200000);
    TextDrawColor(Galaxy3Camera[18], 255);
    TextDrawSetOutline(Galaxy3Camera[18], 0);
    TextDrawSetProportional(Galaxy3Camera[18], 1);
    TextDrawSetShadow(Galaxy3Camera[18], 0);
    TextDrawSetSelectable(Galaxy3Camera[18], 0);

    Galaxy3Camera[19] = TextDrawCreate(608.000000, 168.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[19], 255);
    TextDrawFont(Galaxy3Camera[19], 1);
    TextDrawLetterSize(Galaxy3Camera[19], 0.500000, 1.899999);
    TextDrawColor(Galaxy3Camera[19], -1);
    TextDrawSetOutline(Galaxy3Camera[19], 0);
    TextDrawSetProportional(Galaxy3Camera[19], 1);
    TextDrawSetShadow(Galaxy3Camera[19], 1);
    TextDrawUseBox(Galaxy3Camera[19], 1);
    TextDrawBoxColor(Galaxy3Camera[19], 255);
    TextDrawTextSize(Galaxy3Camera[19], 502.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3Camera[19], 0);

    Galaxy3Camera[20] = TextDrawCreate(608.000000, 395.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[20], 255);
    TextDrawFont(Galaxy3Camera[20], 1);
    TextDrawLetterSize(Galaxy3Camera[20], 0.500000, 1.899999);
    TextDrawColor(Galaxy3Camera[20], -1);
    TextDrawSetOutline(Galaxy3Camera[20], 0);
    TextDrawSetProportional(Galaxy3Camera[20], 1);
    TextDrawSetShadow(Galaxy3Camera[20], 1);
    TextDrawUseBox(Galaxy3Camera[20], 1);
    TextDrawBoxColor(Galaxy3Camera[20], 255);
    TextDrawTextSize(Galaxy3Camera[20], 502.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3Camera[20], 0);

    Galaxy3Camera[21] = TextDrawCreate(591.000000, 394.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[21], 255);
    TextDrawFont(Galaxy3Camera[21], 1);
    TextDrawLetterSize(Galaxy3Camera[21], 0.500000, 3.000004);
    TextDrawColor(Galaxy3Camera[21], -1);
    TextDrawSetOutline(Galaxy3Camera[21], 0);
    TextDrawSetProportional(Galaxy3Camera[21], 1);
    TextDrawSetShadow(Galaxy3Camera[21], 1);
    TextDrawUseBox(Galaxy3Camera[21], 1);
    TextDrawBoxColor(Galaxy3Camera[21], 255);
    TextDrawTextSize(Galaxy3Camera[21], 518.000000, 5.000000);
    TextDrawSetSelectable(Galaxy3Camera[21], 0);

    Galaxy3Camera[22] = TextDrawCreate(553.000000, 397.000000, "u");
    TextDrawAlignment(Galaxy3Camera[22], 2);
    TextDrawBackgroundColor(Galaxy3Camera[22], 255);
    TextDrawFont(Galaxy3Camera[22], 2);
    TextDrawLetterSize(Galaxy3Camera[22], 2.069998, 1.399999);
    TextDrawColor(Galaxy3Camera[22], -1);
    TextDrawSetOutline(Galaxy3Camera[22], 0);
    TextDrawSetProportional(Galaxy3Camera[22], 1);
    TextDrawSetShadow(Galaxy3Camera[22], 1);
    TextDrawSetSelectable(Galaxy3Camera[22], 0);

    Galaxy3Camera[23] = TextDrawCreate(555.000000, 261.000000, "II");
    TextDrawBackgroundColor(Galaxy3Camera[23], 255);
    TextDrawFont(Galaxy3Camera[23], 1);
    TextDrawLetterSize(Galaxy3Camera[23], 0.059999, 2.599999);
    TextDrawColor(Galaxy3Camera[23], -1);
    TextDrawSetOutline(Galaxy3Camera[23], 0);
    TextDrawSetProportional(Galaxy3Camera[23], 1);
    TextDrawSetShadow(Galaxy3Camera[23], 0);
    TextDrawSetSelectable(Galaxy3Camera[23], 0);

    Galaxy3Camera[24] = TextDrawCreate(547.000000, 270.000000, "-");
    TextDrawBackgroundColor(Galaxy3Camera[24], 255);
    TextDrawFont(Galaxy3Camera[24], 1);
    TextDrawLetterSize(Galaxy3Camera[24], 1.240000, 0.400000);
    TextDrawColor(Galaxy3Camera[24], -1);
    TextDrawSetOutline(Galaxy3Camera[24], 0);
    TextDrawSetProportional(Galaxy3Camera[24], 1);
    TextDrawSetShadow(Galaxy3Camera[24], 0);
    TextDrawSetSelectable(Galaxy3Camera[24], 0);

    Galaxy3Camera[25] = TextDrawCreate(501.000000, 381.000000, "F8 - Foto . Y  - Salir");
    TextDrawBackgroundColor(Galaxy3Camera[25], 255);
    TextDrawFont(Galaxy3Camera[25], 1);
    TextDrawLetterSize(Galaxy3Camera[25], 0.300000, 0.899999);
    TextDrawColor(Galaxy3Camera[25], -1);
    TextDrawSetOutline(Galaxy3Camera[25], 0);
    TextDrawSetProportional(Galaxy3Camera[25], 1);
    TextDrawSetShadow(Galaxy3Camera[25], 0);
    TextDrawSetSelectable(Galaxy3Camera[25], 0);

    Galaxy3Camera[27] = TextDrawCreate(610.000000, 189.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[27], 255);
    TextDrawFont(Galaxy3Camera[27], 1);
    TextDrawLetterSize(Galaxy3Camera[27], 0.500000, 0.499998);
    TextDrawColor(Galaxy3Camera[27], -1);
    TextDrawSetOutline(Galaxy3Camera[27], 0);
    TextDrawSetProportional(Galaxy3Camera[27], 1);
    TextDrawSetShadow(Galaxy3Camera[27], 1);
    TextDrawUseBox(Galaxy3Camera[27], 1);
    TextDrawBoxColor(Galaxy3Camera[27], 842150655);
    TextDrawTextSize(Galaxy3Camera[27], 499.000000, 10.000000);
    TextDrawSetSelectable(Galaxy3Camera[27], 0);

    Galaxy3Camera[28] = TextDrawCreate(579.000000, 188.000000, "17:24");
    TextDrawBackgroundColor(Galaxy3Camera[28], 255);
    TextDrawFont(Galaxy3Camera[28], 1);
    TextDrawLetterSize(Galaxy3Camera[28], 0.289999, 0.699998);
    TextDrawColor(Galaxy3Camera[28], -1);
    TextDrawSetOutline(Galaxy3Camera[28], 0);
    TextDrawSetProportional(Galaxy3Camera[28], 1);
    TextDrawSetShadow(Galaxy3Camera[28], 0);
    TextDrawSetSelectable(Galaxy3Camera[28], 0);

    Galaxy3Camera[29] = TextDrawCreate(504.000000, 188.000000, "3G");
    TextDrawBackgroundColor(Galaxy3Camera[29], 255);
    TextDrawFont(Galaxy3Camera[29], 1);
    TextDrawLetterSize(Galaxy3Camera[29], 0.289999, 0.699998);
    TextDrawColor(Galaxy3Camera[29], -1);
    TextDrawSetOutline(Galaxy3Camera[29], 0);
    TextDrawSetProportional(Galaxy3Camera[29], 1);
    TextDrawSetShadow(Galaxy3Camera[29], 0);
    TextDrawSetSelectable(Galaxy3Camera[29], 0);

    Galaxy3Camera[30] = TextDrawCreate(571.000000, 188.000000, "I");
    TextDrawBackgroundColor(Galaxy3Camera[30], 255);
    TextDrawFont(Galaxy3Camera[30], 1);
    TextDrawLetterSize(Galaxy3Camera[30], 0.539999, 0.699998);
    TextDrawColor(Galaxy3Camera[30], 16711935);
    TextDrawSetOutline(Galaxy3Camera[30], 0);
    TextDrawSetProportional(Galaxy3Camera[30], 1);
    TextDrawSetShadow(Galaxy3Camera[30], 0);
    TextDrawSetSelectable(Galaxy3Camera[30], 0);

    Galaxy3Camera[31] = TextDrawCreate(503.000000, 381.000000, "_");
    TextDrawBackgroundColor(Galaxy3Camera[31], 255);
    TextDrawFont(Galaxy3Camera[31], 1);
    TextDrawLetterSize(Galaxy3Camera[31], 0.500000, 1.000002);
    TextDrawColor(Galaxy3Camera[31], -1);
    TextDrawSetOutline(Galaxy3Camera[31], 0);
    TextDrawSetProportional(Galaxy3Camera[31], 1);
    TextDrawSetShadow(Galaxy3Camera[31], 1);
    TextDrawUseBox(Galaxy3Camera[31], 1);
    TextDrawBoxColor(Galaxy3Camera[31], 1347440895);
    TextDrawTextSize(Galaxy3Camera[31], 606.000000, 0.000000);
    TextDrawSetSelectable(Galaxy3Camera[31], 0);

    //MAPS
    Galaxy3Maps[0] = TextDrawCreate(555.000000, 203.000000, "MAPS");
    TextDrawAlignment(Galaxy3Maps[0], 2);
    TextDrawBackgroundColor(Galaxy3Maps[0], 255);
    TextDrawFont(Galaxy3Maps[0], 2);
    TextDrawLetterSize(Galaxy3Maps[0], 0.380000, 1.400000);
    TextDrawColor(Galaxy3Maps[0], -16776961);
    TextDrawSetOutline(Galaxy3Maps[0], 0);
    TextDrawSetProportional(Galaxy3Maps[0], 1);
    TextDrawSetShadow(Galaxy3Maps[0], 0);
    TextDrawUseBox(Galaxy3Maps[0], 1);
    TextDrawBoxColor(Galaxy3Maps[0], 255);
    TextDrawTextSize(Galaxy3Maps[0], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3Maps[0], 0);

    Galaxy3Maps[1] = TextDrawCreate(503.000000, 223.000000, "samaps:gtasamapbit1");
    TextDrawBackgroundColor(Galaxy3Maps[1], 255);
    TextDrawAlignment(Galaxy3Maps[1], 2);
    TextDrawFont(Galaxy3Maps[1], 4);
    TextDrawLetterSize(Galaxy3Maps[1], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[1], -1);
    TextDrawSetOutline(Galaxy3Maps[1], 0);
    TextDrawSetProportional(Galaxy3Maps[1], 1);
    TextDrawSetShadow(Galaxy3Maps[1], 1);
    TextDrawUseBox(Galaxy3Maps[1], 1);
    TextDrawBoxColor(Galaxy3Maps[1], 255);
    TextDrawTextSize(Galaxy3Maps[1], 52.000000, 49.000000);
    TextDrawSetSelectable(Galaxy3Maps[1], 1);

    Galaxy3Maps[2] = TextDrawCreate(555.000000, 223.000000, "samaps:gtasamapbit2");
    TextDrawAlignment(Galaxy3Maps[2], 2);
    TextDrawBackgroundColor(Galaxy3Maps[2], 255);
    TextDrawFont(Galaxy3Maps[2], 4);
    TextDrawLetterSize(Galaxy3Maps[2], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[2], -1);
    TextDrawSetOutline(Galaxy3Maps[2], 0);
    TextDrawSetProportional(Galaxy3Maps[2], 1);
    TextDrawSetShadow(Galaxy3Maps[2], 1);
    TextDrawUseBox(Galaxy3Maps[2], 1);
    TextDrawBoxColor(Galaxy3Maps[2], 255);
    TextDrawTextSize(Galaxy3Maps[2], 52.000000, 49.000000);
    TextDrawSetSelectable(Galaxy3Maps[2], 1);

    Galaxy3Maps[3] = TextDrawCreate(503.000000, 272.000000, "samaps:gtasamapbit3");
    TextDrawAlignment(Galaxy3Maps[3], 2);
    TextDrawBackgroundColor(Galaxy3Maps[3], 255);
    TextDrawFont(Galaxy3Maps[3], 4);
    TextDrawLetterSize(Galaxy3Maps[3], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[3], -1);
    TextDrawSetOutline(Galaxy3Maps[3], 0);
    TextDrawSetProportional(Galaxy3Maps[3], 1);
    TextDrawSetShadow(Galaxy3Maps[3], 1);
    TextDrawUseBox(Galaxy3Maps[3], 1);
    TextDrawBoxColor(Galaxy3Maps[3], 255);
    TextDrawTextSize(Galaxy3Maps[3], 52.000000, 49.000000);
    TextDrawSetSelectable(Galaxy3Maps[3], 1);

    Galaxy3Maps[4] = TextDrawCreate(555.000000, 272.000000, "samaps:gtasamapbit4");
    TextDrawAlignment(Galaxy3Maps[4], 2);
    TextDrawBackgroundColor(Galaxy3Maps[4], 255);
    TextDrawFont(Galaxy3Maps[4], 4);
    TextDrawLetterSize(Galaxy3Maps[4], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[4], -1);
    TextDrawSetOutline(Galaxy3Maps[4], 0);
    TextDrawSetProportional(Galaxy3Maps[4], 1);
    TextDrawSetShadow(Galaxy3Maps[4], 1);
    TextDrawUseBox(Galaxy3Maps[4], 1);
    TextDrawBoxColor(Galaxy3Maps[4], 255);
    TextDrawTextSize(Galaxy3Maps[4], 52.000000, 49.000000);
    TextDrawSetSelectable(Galaxy3Maps[4], 1);

    Galaxy3Maps[5] = TextDrawCreate(503.000000, 224.000000, "samaps:gtasamapbit1");
    TextDrawAlignment(Galaxy3Maps[5], 2);
    TextDrawBackgroundColor(Galaxy3Maps[5], 255);
    TextDrawFont(Galaxy3Maps[5], 4);
    TextDrawLetterSize(Galaxy3Maps[5], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[5], -1);
    TextDrawSetOutline(Galaxy3Maps[5], 0);
    TextDrawSetProportional(Galaxy3Maps[5], 1);
    TextDrawSetShadow(Galaxy3Maps[5], 1);
    TextDrawUseBox(Galaxy3Maps[5], 1);
    TextDrawBoxColor(Galaxy3Maps[5], 255);
    TextDrawTextSize(Galaxy3Maps[5], 104.000000, 97.000000);
    TextDrawSetSelectable(Galaxy3Maps[5], 1);

    Galaxy3Maps[6] = TextDrawCreate(503.000000, 224.000000, "samaps:gtasamapbit2");
    TextDrawAlignment(Galaxy3Maps[6], 2);
    TextDrawBackgroundColor(Galaxy3Maps[6], 255);
    TextDrawFont(Galaxy3Maps[6], 4);
    TextDrawLetterSize(Galaxy3Maps[6], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[6], -1);
    TextDrawSetOutline(Galaxy3Maps[6], 0);
    TextDrawSetProportional(Galaxy3Maps[6], 1);
    TextDrawSetShadow(Galaxy3Maps[6], 1);
    TextDrawUseBox(Galaxy3Maps[6], 1);
    TextDrawBoxColor(Galaxy3Maps[6], 255);
    TextDrawTextSize(Galaxy3Maps[6], 104.000000, 97.000000);
    TextDrawSetSelectable(Galaxy3Maps[6], 1);

    Galaxy3Maps[7] = TextDrawCreate(503.000000, 224.000000, "samaps:gtasamapbit3");
    TextDrawAlignment(Galaxy3Maps[7], 2);
    TextDrawBackgroundColor(Galaxy3Maps[7], 255);
    TextDrawFont(Galaxy3Maps[7], 4);
    TextDrawLetterSize(Galaxy3Maps[7], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[7], -1);
    TextDrawSetOutline(Galaxy3Maps[7], 0);
    TextDrawSetProportional(Galaxy3Maps[7], 1);
    TextDrawSetShadow(Galaxy3Maps[7], 1);
    TextDrawUseBox(Galaxy3Maps[7], 1);
    TextDrawBoxColor(Galaxy3Maps[7], 255);
    TextDrawTextSize(Galaxy3Maps[7], 104.000000, 97.000000);
    TextDrawSetSelectable(Galaxy3Maps[7], 1);

    Galaxy3Maps[8] = TextDrawCreate(503.000000, 224.000000, "samaps:gtasamapbit4");
    TextDrawAlignment(Galaxy3Maps[8], 2);
    TextDrawBackgroundColor(Galaxy3Maps[8], 255);
    TextDrawFont(Galaxy3Maps[8], 4);
    TextDrawLetterSize(Galaxy3Maps[8], 0.500000, 1.000000);
    TextDrawColor(Galaxy3Maps[8], -1);
    TextDrawSetOutline(Galaxy3Maps[8], 0);
    TextDrawSetProportional(Galaxy3Maps[8], 1);
    TextDrawSetShadow(Galaxy3Maps[8], 1);
    TextDrawUseBox(Galaxy3Maps[8], 1);
    TextDrawBoxColor(Galaxy3Maps[8], 255);
    TextDrawTextSize(Galaxy3Maps[8], 104.000000, 97.000000);
    TextDrawSetSelectable(Galaxy3Maps[8], 1);

    //weather
    Galaxy3Weather[0] = TextDrawCreate(555.000000, 203.000000, "THE WEATHER");
    TextDrawAlignment(Galaxy3Weather[0], 2);
    TextDrawBackgroundColor(Galaxy3Weather[0], 255);
    TextDrawFont(Galaxy3Weather[0], 2);
    TextDrawLetterSize(Galaxy3Weather[0], 0.379999, 1.399999);
    TextDrawColor(Galaxy3Weather[0], -16776961);
    TextDrawSetOutline(Galaxy3Weather[0], 0);
    TextDrawSetProportional(Galaxy3Weather[0], 1);
    TextDrawSetShadow(Galaxy3Weather[0], 0);
    TextDrawUseBox(Galaxy3Weather[0], 1);
    TextDrawBoxColor(Galaxy3Weather[0], 255);
    TextDrawTextSize(Galaxy3Weather[0], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3Weather[0], 0);

    Galaxy3Weather[1] = TextDrawCreate(555.000000, 238.000000, "~r~PLACE~n~~g~SAN ANDREAS~n~~n~~r~TEMPERATURE~n~~g~14C");
    TextDrawAlignment(Galaxy3Weather[1], 2);
    TextDrawBackgroundColor(Galaxy3Weather[1], 255);
    TextDrawFont(Galaxy3Weather[1], 2);
    TextDrawLetterSize(Galaxy3Weather[1], 0.290000, 1.200000);
    TextDrawColor(Galaxy3Weather[1], -1);
    TextDrawSetOutline(Galaxy3Weather[1], 0);
    TextDrawSetProportional(Galaxy3Weather[1], 1);
    TextDrawSetShadow(Galaxy3Weather[1], 0);
    TextDrawUseBox(Galaxy3Weather[1], 1);
    TextDrawBoxColor(Galaxy3Weather[1], 255);
    TextDrawTextSize(Galaxy3Weather[1], 0.000000, 98.000000);
    TextDrawSetSelectable(Galaxy3Weather[1], 0);

    Galaxy3Weather[2] = TextDrawCreate(555.000000, 322.000000, "VARIABLE");
    TextDrawAlignment(Galaxy3Weather[2], 2);
    TextDrawBackgroundColor(Galaxy3Weather[2], 255);
    TextDrawFont(Galaxy3Weather[2], 2);
    TextDrawLetterSize(Galaxy3Weather[2], 0.290000, 1.200000);
    TextDrawColor(Galaxy3Weather[2], -1);
    TextDrawSetOutline(Galaxy3Weather[2], 0);
    TextDrawSetProportional(Galaxy3Weather[2], 1);
    TextDrawSetShadow(Galaxy3Weather[2], 0);
    TextDrawUseBox(Galaxy3Weather[2], 1);
    TextDrawBoxColor(Galaxy3Weather[2], 255);
    TextDrawTextSize(Galaxy3Weather[2], 0.000000, 98.000000);
    TextDrawSetSelectable(Galaxy3Weather[2], 0);

    //Radio
    Galaxy3Radios[0] = TextDrawCreate(529.000000, 211.000000, "RADIO 1");
    TextDrawAlignment(Galaxy3Radios[0], 2);
    TextDrawBackgroundColor(Galaxy3Radios[0], 255);
    TextDrawFont(Galaxy3Radios[0], 2);
    TextDrawLetterSize(Galaxy3Radios[0], 0.140000, 1.000000);
    TextDrawColor(Galaxy3Radios[0], 255);
    TextDrawSetOutline(Galaxy3Radios[0], 0);
    TextDrawSetProportional(Galaxy3Radios[0], 1);
    TextDrawSetShadow(Galaxy3Radios[0], 0);
    TextDrawUseBox(Galaxy3Radios[0], 1);
    TextDrawBoxColor(Galaxy3Radios[0], -1);
    TextDrawTextSize(Galaxy3Radios[0], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3Radios[0], 1);

    Galaxy3Radios[1] = TextDrawCreate(579.000000, 211.000000, "RADIO 2");
    TextDrawAlignment(Galaxy3Radios[1], 2);
    TextDrawBackgroundColor(Galaxy3Radios[1], 255);
    TextDrawFont(Galaxy3Radios[1], 2);
    TextDrawLetterSize(Galaxy3Radios[1], 0.140000, 1.000000);
    TextDrawColor(Galaxy3Radios[1], 255);
    TextDrawSetOutline(Galaxy3Radios[1], 0);
    TextDrawSetProportional(Galaxy3Radios[1], 1);
    TextDrawSetShadow(Galaxy3Radios[1], 0);
    TextDrawUseBox(Galaxy3Radios[1], 1);
    TextDrawBoxColor(Galaxy3Radios[1], -1);
    TextDrawTextSize(Galaxy3Radios[1], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3Radios[1], 1);

    Galaxy3Radios[2] = TextDrawCreate(529.000000, 234.000000, "RADIO 3");
    TextDrawAlignment(Galaxy3Radios[2], 2);
    TextDrawBackgroundColor(Galaxy3Radios[2], 255);
    TextDrawFont(Galaxy3Radios[2], 2);
    TextDrawLetterSize(Galaxy3Radios[2], 0.140000, 1.000000);
    TextDrawColor(Galaxy3Radios[2], 255);
    TextDrawSetOutline(Galaxy3Radios[2], 0);
    TextDrawSetProportional(Galaxy3Radios[2], 1);
    TextDrawSetShadow(Galaxy3Radios[2], 0);
    TextDrawUseBox(Galaxy3Radios[2], 1);
    TextDrawBoxColor(Galaxy3Radios[2], -1);
    TextDrawTextSize(Galaxy3Radios[2], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3Radios[2], 1);

    Galaxy3Radios[3] = TextDrawCreate(579.000000, 234.000000, "RADIO 4");
    TextDrawAlignment(Galaxy3Radios[3], 2);
    TextDrawBackgroundColor(Galaxy3Radios[3], 255);
    TextDrawFont(Galaxy3Radios[3], 2);
    TextDrawLetterSize(Galaxy3Radios[3], 0.140000, 1.000000);
    TextDrawColor(Galaxy3Radios[3], 255);
    TextDrawSetOutline(Galaxy3Radios[3], 0);
    TextDrawSetProportional(Galaxy3Radios[3], 1);
    TextDrawSetShadow(Galaxy3Radios[3], 0);
    TextDrawUseBox(Galaxy3Radios[3], 1);
    TextDrawBoxColor(Galaxy3Radios[3], -1);
    TextDrawTextSize(Galaxy3Radios[3], 10.000000, 42.000000);
    TextDrawSetSelectable(Galaxy3Radios[3], 1);

    //Keys
    Galaxy3KeyBoard[0] = TextDrawCreate(514.000000, 279.000000, "1");
    TextDrawAlignment(Galaxy3KeyBoard[0], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[0], 255);
    TextDrawFont(Galaxy3KeyBoard[0], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[0], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[0], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[0], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[0], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[0], 0);
    TextDrawUseBox(Galaxy3KeyBoard[0], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[0], -1);
    TextDrawTextSize(Galaxy3KeyBoard[0], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[0], 1);

    Galaxy3KeyBoard[1] = TextDrawCreate(555.000000, 279.000000, "2");
    TextDrawAlignment(Galaxy3KeyBoard[1], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[1], 255);
    TextDrawFont(Galaxy3KeyBoard[1], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[1], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[1], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[1], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[1], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[1], 0);
    TextDrawUseBox(Galaxy3KeyBoard[1], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[1], -1);
    TextDrawTextSize(Galaxy3KeyBoard[1], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[1], 1);

    Galaxy3KeyBoard[2] = TextDrawCreate(596.000000, 279.000000, "3");
    TextDrawAlignment(Galaxy3KeyBoard[2], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[2], 255);
    TextDrawFont(Galaxy3KeyBoard[2], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[2], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[2], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[2], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[2], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[2], 0);
    TextDrawUseBox(Galaxy3KeyBoard[2], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[2], -1);
    TextDrawTextSize(Galaxy3KeyBoard[2], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[2], 1);

    Galaxy3KeyBoard[3] = TextDrawCreate(514.000000, 303.000000, "4");
    TextDrawAlignment(Galaxy3KeyBoard[3], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[3], 255);
    TextDrawFont(Galaxy3KeyBoard[3], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[3], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[3], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[3], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[3], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[3], 0);
    TextDrawUseBox(Galaxy3KeyBoard[3], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[3], -1);
    TextDrawTextSize(Galaxy3KeyBoard[3], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[3], 1);

    Galaxy3KeyBoard[4] = TextDrawCreate(555.000000, 303.000000, "5");
    TextDrawAlignment(Galaxy3KeyBoard[4], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[4], 255);
    TextDrawFont(Galaxy3KeyBoard[4], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[4], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[4], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[4], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[4], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[4], 0);
    TextDrawUseBox(Galaxy3KeyBoard[4], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[4], -1);
    TextDrawTextSize(Galaxy3KeyBoard[4], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[4], 1);

    Galaxy3KeyBoard[5] = TextDrawCreate(596.000000, 303.000000, "6");
    TextDrawAlignment(Galaxy3KeyBoard[5], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[5], 255);
    TextDrawFont(Galaxy3KeyBoard[5], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[5], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[5], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[5], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[5], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[5], 0);
    TextDrawUseBox(Galaxy3KeyBoard[5], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[5], -1);
    TextDrawTextSize(Galaxy3KeyBoard[5], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[5], 1);

    Galaxy3KeyBoard[6] = TextDrawCreate(514.000000, 328.000000, "7");
    TextDrawAlignment(Galaxy3KeyBoard[6], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[6], 255);
    TextDrawFont(Galaxy3KeyBoard[6], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[6], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[6], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[6], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[6], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[6], 0);
    TextDrawUseBox(Galaxy3KeyBoard[6], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[6], -1);
    TextDrawTextSize(Galaxy3KeyBoard[6], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[6], 1);

    Galaxy3KeyBoard[7] = TextDrawCreate(555.000000, 328.000000, "8");
    TextDrawAlignment(Galaxy3KeyBoard[7], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[7], 255);
    TextDrawFont(Galaxy3KeyBoard[7], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[7], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[7], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[7], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[7], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[7], 0);
    TextDrawUseBox(Galaxy3KeyBoard[7], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[7], -1);
    TextDrawTextSize(Galaxy3KeyBoard[7], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[7], 1);

    Galaxy3KeyBoard[8] = TextDrawCreate(596.000000, 328.000000, "9");
    TextDrawAlignment(Galaxy3KeyBoard[8], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[8], 255);
    TextDrawFont(Galaxy3KeyBoard[8], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[8], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[8], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[8], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[8], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[8], 0);
    TextDrawUseBox(Galaxy3KeyBoard[8], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[8], -1);
    TextDrawTextSize(Galaxy3KeyBoard[8], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[8], 1);

    Galaxy3KeyBoard[9] = TextDrawCreate(514.000000, 352.000000, "+");
    TextDrawAlignment(Galaxy3KeyBoard[9], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[9], 255);
    TextDrawFont(Galaxy3KeyBoard[9], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[9], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[9], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[9], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[9], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[9], 0);
    TextDrawUseBox(Galaxy3KeyBoard[9], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[9], -1);
    TextDrawTextSize(Galaxy3KeyBoard[9], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[9], 1);

    Galaxy3KeyBoard[10] = TextDrawCreate(555.000000, 352.000000, "0");
    TextDrawAlignment(Galaxy3KeyBoard[10], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[10], 255);
    TextDrawFont(Galaxy3KeyBoard[10], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[10], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[10], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[10], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[10], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[10], 0);
    TextDrawUseBox(Galaxy3KeyBoard[10], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[10], -1);
    TextDrawTextSize(Galaxy3KeyBoard[10], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[10], 1);

    Galaxy3KeyBoard[11] = TextDrawCreate(596.000000, 352.000000, "/");
    TextDrawAlignment(Galaxy3KeyBoard[11], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[11], 255);
    TextDrawFont(Galaxy3KeyBoard[11], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[11], 0.390000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[11], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[11], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[11], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[11], 0);
    TextDrawUseBox(Galaxy3KeyBoard[11], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[11], -1);
    TextDrawTextSize(Galaxy3KeyBoard[11], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[11], 1);

    Galaxy3KeyBoard[12] = TextDrawCreate(514.000000, 376.000000, "CALL");
    TextDrawAlignment(Galaxy3KeyBoard[12], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[12], 255);
    TextDrawFont(Galaxy3KeyBoard[12], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[12], 0.190000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[12], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[12], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[12], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[12], 0);
    TextDrawUseBox(Galaxy3KeyBoard[12], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[12], 16711935);
    TextDrawTextSize(Galaxy3KeyBoard[12], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[12], 1);

    Galaxy3KeyBoard[13] = TextDrawCreate(555.000000, 376.000000, "SMS");
    TextDrawAlignment(Galaxy3KeyBoard[13], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[13], 255);
    TextDrawFont(Galaxy3KeyBoard[13], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[13], 0.230000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[13], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[13], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[13], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[13], 0);
    TextDrawUseBox(Galaxy3KeyBoard[13], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[13], -65281);
    TextDrawTextSize(Galaxy3KeyBoard[13], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[13], 1);

    Galaxy3KeyBoard[14] = TextDrawCreate(596.000000, 376.000000, "~<~");
    TextDrawAlignment(Galaxy3KeyBoard[14], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[14], 255);
    TextDrawFont(Galaxy3KeyBoard[14], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[14], 0.230000, 1.400000);
    TextDrawColor(Galaxy3KeyBoard[14], 255);
    TextDrawSetOutline(Galaxy3KeyBoard[14], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[14], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[14], 0);
    TextDrawUseBox(Galaxy3KeyBoard[14], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[14], 255);
    TextDrawTextSize(Galaxy3KeyBoard[14], 15.000000, 15.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[14], 1);

    Galaxy3KeyBoard[15] = TextDrawCreate(555.000000, 203.000000, "KEYBOARD");
    TextDrawAlignment(Galaxy3KeyBoard[15], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[15], 255);
    TextDrawFont(Galaxy3KeyBoard[15], 2);
    TextDrawLetterSize(Galaxy3KeyBoard[15], 0.379999, 1.399999);
    TextDrawColor(Galaxy3KeyBoard[15], -16776961);
    TextDrawSetOutline(Galaxy3KeyBoard[15], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[15], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[15], 0);
    TextDrawUseBox(Galaxy3KeyBoard[15], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[15], 255);
    TextDrawTextSize(Galaxy3KeyBoard[15], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[15], 0);

    Galaxy3KeyBoard[16] = TextDrawCreate(553.000000, 220.000000, "BEHIND");
    TextDrawAlignment(Galaxy3KeyBoard[16], 2);
    TextDrawBackgroundColor(Galaxy3KeyBoard[16], 255);
    TextDrawFont(Galaxy3KeyBoard[16], 1);
    TextDrawLetterSize(Galaxy3KeyBoard[16], 0.470000, 1.100000);
    TextDrawColor(Galaxy3KeyBoard[16], -1);
    TextDrawSetOutline(Galaxy3KeyBoard[16], 0);
    TextDrawSetProportional(Galaxy3KeyBoard[16], 1);
    TextDrawSetShadow(Galaxy3KeyBoard[16], 1);
    TextDrawUseBox(Galaxy3KeyBoard[16], 1);
    TextDrawBoxColor(Galaxy3KeyBoard[16], 255);
    TextDrawTextSize(Galaxy3KeyBoard[16], 10.000000, 55.000000);
    TextDrawSetSelectable(Galaxy3KeyBoard[16], 1);
    //
    Galaxy3Latitude[0] = TextDrawCreate(555.000000, 203.000000, "LATITUDE");
    TextDrawAlignment(Galaxy3Latitude[0], 2);
    TextDrawBackgroundColor(Galaxy3Latitude[0], 255);
    TextDrawFont(Galaxy3Latitude[0], 2);
    TextDrawLetterSize(Galaxy3Latitude[0], 0.379999, 1.399999);
    TextDrawColor(Galaxy3Latitude[0], -16776961);
    TextDrawSetOutline(Galaxy3Latitude[0], 0);
    TextDrawSetProportional(Galaxy3Latitude[0], 1);
    TextDrawSetShadow(Galaxy3Latitude[0], 0);
    TextDrawUseBox(Galaxy3Latitude[0], 1);
    TextDrawBoxColor(Galaxy3Latitude[0], 255);
    TextDrawTextSize(Galaxy3Latitude[0], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3Latitude[0], 0);

    Galaxy3Latitude[1] = TextDrawCreate(555.000000, 238.000000, "~r~PLACE~n~~g~SAN ANDREAS~n~~n~~r~Zone~n~~g~GPS....");
    TextDrawAlignment(Galaxy3Latitude[1], 2);
    TextDrawBackgroundColor(Galaxy3Latitude[1], 255);
    TextDrawFont(Galaxy3Latitude[1], 2);
    TextDrawLetterSize(Galaxy3Latitude[1], 0.290000, 1.200000);
    TextDrawColor(Galaxy3Latitude[1], -1);
    TextDrawSetOutline(Galaxy3Latitude[1], 0);
    TextDrawSetProportional(Galaxy3Latitude[1], 1);
    TextDrawSetShadow(Galaxy3Latitude[1], 0);
    TextDrawUseBox(Galaxy3Latitude[1], 1);
    TextDrawBoxColor(Galaxy3Latitude[1], 255);
    TextDrawTextSize(Galaxy3Latitude[1], 0.000000, 98.000000);
    TextDrawSetSelectable(Galaxy3Latitude[1], 0);
    //Music player
    Galaxy3MusicPlayer[0] = TextDrawCreate(555.000000, 203.000000, "MUSIC");
    TextDrawAlignment(Galaxy3MusicPlayer[0], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[0], 255);
    TextDrawFont(Galaxy3MusicPlayer[0], 2);
    TextDrawLetterSize(Galaxy3MusicPlayer[0], 0.379999, 1.399999);
    TextDrawColor(Galaxy3MusicPlayer[0], -16776961);
    TextDrawSetOutline(Galaxy3MusicPlayer[0], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[0], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[0], 0);
    TextDrawUseBox(Galaxy3MusicPlayer[0], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[0], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[0], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[0], 0);

    Galaxy3MusicPlayer[1] = TextDrawCreate(555.000000, 239.000000, "PSY - Gangnam Style");
    TextDrawAlignment(Galaxy3MusicPlayer[1], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[1], 255);
    TextDrawFont(Galaxy3MusicPlayer[1], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[1], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[1], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[1], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[1], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[1], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[1], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[1], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[1], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[1], 1);

    Galaxy3MusicPlayer[2] = TextDrawCreate(555.000000, 251.000000, "Eric Prydz - Pjanoo");
    TextDrawAlignment(Galaxy3MusicPlayer[2], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[2], 255);
    TextDrawFont(Galaxy3MusicPlayer[2], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[2], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[2], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[2], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[2], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[2], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[2], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[2], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[2], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[2], 1);

    Galaxy3MusicPlayer[3] = TextDrawCreate(555.000000, 264.000000, "LMFAO - Party Rock");
    TextDrawAlignment(Galaxy3MusicPlayer[3], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[3], 255);
    TextDrawFont(Galaxy3MusicPlayer[3], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[3], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[3], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[3], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[3], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[3], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[3], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[3], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[3], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[3], 1);

    Galaxy3MusicPlayer[4] = TextDrawCreate(555.000000, 276.000000, "Safari Duo");
    TextDrawAlignment(Galaxy3MusicPlayer[4], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[4], 255);
    TextDrawFont(Galaxy3MusicPlayer[4], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[4], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[4], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[4], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[4], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[4], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[4], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[4], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[4], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[4], 1);

    Galaxy3MusicPlayer[5] = TextDrawCreate(555.000000, 288.000000, "Infinity");
    TextDrawAlignment(Galaxy3MusicPlayer[5], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[5], 255);
    TextDrawFont(Galaxy3MusicPlayer[5], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[5], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[5], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[5], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[5], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[5], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[5], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[5], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[5], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[5], 1);

    Galaxy3MusicPlayer[6] = TextDrawCreate(555.000000, 300.000000, "STOP");
    TextDrawAlignment(Galaxy3MusicPlayer[6], 2);
    TextDrawBackgroundColor(Galaxy3MusicPlayer[6], 255);
    TextDrawFont(Galaxy3MusicPlayer[6], 1);
    TextDrawLetterSize(Galaxy3MusicPlayer[6], 0.260000, 0.899999);
    TextDrawColor(Galaxy3MusicPlayer[6], -1);
    TextDrawSetOutline(Galaxy3MusicPlayer[6], 0);
    TextDrawSetProportional(Galaxy3MusicPlayer[6], 1);
    TextDrawSetShadow(Galaxy3MusicPlayer[6], 1);
    TextDrawUseBox(Galaxy3MusicPlayer[6], 1);
    TextDrawBoxColor(Galaxy3MusicPlayer[6], 255);
    TextDrawTextSize(Galaxy3MusicPlayer[6], 5.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3MusicPlayer[6], 1);

    //SlotMACHINE
    Galaxy3SlotMachine[0] = TextDrawCreate(555.000000, 203.000000, "GAMES");
    TextDrawAlignment(Galaxy3SlotMachine[0], 2);
    TextDrawBackgroundColor(Galaxy3SlotMachine[0], 255);
    TextDrawFont(Galaxy3SlotMachine[0], 2);
    TextDrawLetterSize(Galaxy3SlotMachine[0], 0.379999, 1.399999);
    TextDrawColor(Galaxy3SlotMachine[0], -16776961);
    TextDrawSetOutline(Galaxy3SlotMachine[0], 0);
    TextDrawSetProportional(Galaxy3SlotMachine[0], 1);
    TextDrawSetShadow(Galaxy3SlotMachine[0], 0);
    TextDrawUseBox(Galaxy3SlotMachine[0], 1);
    TextDrawBoxColor(Galaxy3SlotMachine[0], 255);
    TextDrawTextSize(Galaxy3SlotMachine[0], 0.000000, 100.000000);
    TextDrawSetSelectable(Galaxy3SlotMachine[0], 0);

    Galaxy3SlotMachine[1] = TextDrawCreate(555.000000, 312.000000, "_");
    TextDrawAlignment(Galaxy3SlotMachine[1], 2);
    TextDrawBackgroundColor(Galaxy3SlotMachine[1], -16776961);
    TextDrawFont(Galaxy3SlotMachine[1], 3);
    TextDrawLetterSize(Galaxy3SlotMachine[1], 0.500000, 1.300000);
    TextDrawColor(Galaxy3SlotMachine[1], -1);
    TextDrawSetOutline(Galaxy3SlotMachine[1], 1);
    TextDrawSetProportional(Galaxy3SlotMachine[1], 1);
    TextDrawUseBox(Galaxy3SlotMachine[1], 1);
    TextDrawBoxColor(Galaxy3SlotMachine[1], 255);
    TextDrawTextSize(Galaxy3SlotMachine[1], 10.000000, 99.000000);
    TextDrawSetSelectable(Galaxy3SlotMachine[1], 0);

    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `phoneNumbers` (`PHONE_NUMBER` int(11) NOT NULL,`USERNAME` varchar(24) NOT NULL, PRIMARY KEY (`PHONE_NUMBER`), UNIQUE KEY `USERNAME` (`USERNAME`))");
    mysql_tquery(Database, query);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    Galaxy3StartMenu2 = CreatePlayerTextDraw(playerid, 504.000000, 188.000000, "3G");
    PlayerTextDrawBackgroundColor(playerid, Galaxy3StartMenu2, 255);
    PlayerTextDrawFont(playerid, Galaxy3StartMenu2, 1);
    PlayerTextDrawLetterSize(playerid, Galaxy3StartMenu2, 0.289999, 0.699998);
    PlayerTextDrawColor(playerid, Galaxy3StartMenu2, -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3StartMenu2, 0);
    PlayerTextDrawSetProportional(playerid, Galaxy3StartMenu2, 1);
    PlayerTextDrawSetShadow(playerid, Galaxy3StartMenu2, 0);
    PlayerTextDrawSetSelectable(playerid, Galaxy3StartMenu2, 0);

    CalculatorTD2 = CreatePlayerTextDraw(playerid, 594.000000, 252.000000, "_");
    PlayerTextDrawAlignment(playerid, CalculatorTD2, 3);
    PlayerTextDrawBackgroundColor(playerid, CalculatorTD2, 255);
    PlayerTextDrawFont(playerid, CalculatorTD2, 2);
    PlayerTextDrawLetterSize(playerid, CalculatorTD2, 0.319999, 2.000000);
    PlayerTextDrawColor(playerid, CalculatorTD2, -1);
    PlayerTextDrawSetOutline(playerid, CalculatorTD2, 0);
    PlayerTextDrawSetProportional(playerid, CalculatorTD2, 1);
    PlayerTextDrawSetShadow(playerid, CalculatorTD2, 0);
    PlayerTextDrawSetSelectable(playerid, CalculatorTD2, 0);

    KeyBoard2 = CreatePlayerTextDraw(playerid, 555.000000, 239.000000, "_");
    PlayerTextDrawAlignment(playerid, KeyBoard2, 2);
    PlayerTextDrawBackgroundColor(playerid, KeyBoard2, 255);
    PlayerTextDrawFont(playerid, KeyBoard2, 2);
    PlayerTextDrawLetterSize(playerid, KeyBoard2, 0.390000, 1.400000);
    PlayerTextDrawColor(playerid, KeyBoard2, -1);
    PlayerTextDrawSetOutline(playerid, KeyBoard2, 0);
    PlayerTextDrawSetProportional(playerid, KeyBoard2, 1);
    PlayerTextDrawSetShadow(playerid, KeyBoard2, 1);
    PlayerTextDrawUseBox(playerid, KeyBoard2, 1);
    PlayerTextDrawBoxColor(playerid, KeyBoard2, 255);
    PlayerTextDrawTextSize(playerid, KeyBoard2, -4.000000, 98.000000);
    PlayerTextDrawSetSelectable(playerid, KeyBoard2, 0);

    Galaxy3Latitude2 = CreatePlayerTextDraw(playerid, 555.000000, 322.000000, "VARIABLE");
    PlayerTextDrawAlignment(playerid, Galaxy3Latitude2, 2);
    PlayerTextDrawBackgroundColor(playerid, Galaxy3Latitude2, 255);
    PlayerTextDrawFont(playerid, Galaxy3Latitude2, 2);
    PlayerTextDrawLetterSize(playerid, Galaxy3Latitude2, 0.290000, 1.200000);
    PlayerTextDrawColor(playerid, Galaxy3Latitude2, -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3Latitude2, 0);
    PlayerTextDrawSetProportional(playerid, Galaxy3Latitude2, 1);
    PlayerTextDrawSetShadow(playerid, Galaxy3Latitude2, 0);
    PlayerTextDrawUseBox(playerid, Galaxy3Latitude2, 1);
    PlayerTextDrawBoxColor(playerid, Galaxy3Latitude2, 255);
    PlayerTextDrawTextSize(playerid, Galaxy3Latitude2, 0.000000, 98.000000);
    PlayerTextDrawSetSelectable(playerid, Galaxy3Latitude2, 0);
    //
    Galaxy3SlotMachine2[0] = CreatePlayerTextDraw(playerid, 504.000000, 237.000000, "ld_slot:bar1_o");
    PlayerTextDrawBackgroundColor(playerid, Galaxy3SlotMachine2[0], 255);
    PlayerTextDrawFont(playerid, Galaxy3SlotMachine2[0], 4);
    PlayerTextDrawLetterSize(playerid, Galaxy3SlotMachine2[0], 0.370000, 6.099999);
    PlayerTextDrawColor(playerid, Galaxy3SlotMachine2[0], -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3SlotMachine2[0], 0);
    PlayerTextDrawSetProportional(playerid, Galaxy3SlotMachine2[0], 1);
    PlayerTextDrawSetShadow(playerid, Galaxy3SlotMachine2[0], 1);
    PlayerTextDrawUseBox(playerid, Galaxy3SlotMachine2[0], 1);
    PlayerTextDrawBoxColor(playerid, Galaxy3SlotMachine2[0], 255);
    PlayerTextDrawTextSize(playerid, Galaxy3SlotMachine2[0], 30.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Galaxy3SlotMachine2[0], 0);

    Galaxy3SlotMachine2[1] = CreatePlayerTextDraw(playerid, 540.000000, 237.000000, "ld_slot:bar2_o");
    PlayerTextDrawBackgroundColor(playerid, Galaxy3SlotMachine2[1], 255);
    PlayerTextDrawFont(playerid, Galaxy3SlotMachine2[1], 4);
    PlayerTextDrawLetterSize(playerid, Galaxy3SlotMachine2[1], 0.370000, 6.099999);
    PlayerTextDrawColor(playerid, Galaxy3SlotMachine2[1], -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3SlotMachine2[1], 0);
    PlayerTextDrawSetProportional(playerid, Galaxy3SlotMachine2[1], 1);
    PlayerTextDrawSetShadow(playerid, Galaxy3SlotMachine2[1], 1);
    PlayerTextDrawUseBox(playerid, Galaxy3SlotMachine2[1], 1);
    PlayerTextDrawBoxColor(playerid, Galaxy3SlotMachine2[1], 255);
    PlayerTextDrawTextSize(playerid, Galaxy3SlotMachine2[1], 30.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Galaxy3SlotMachine2[1], 0);

    Galaxy3SlotMachine2[2] = CreatePlayerTextDraw(playerid, 577.000000, 237.000000, "ld_slot:bell");
    PlayerTextDrawBackgroundColor(playerid, Galaxy3SlotMachine2[2], 255);
    PlayerTextDrawFont(playerid, Galaxy3SlotMachine2[2], 4);
    PlayerTextDrawLetterSize(playerid, Galaxy3SlotMachine2[2], 0.370000, 6.099999);
    PlayerTextDrawColor(playerid, Galaxy3SlotMachine2[2], -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3SlotMachine2[2], 0);
    PlayerTextDrawSetProportional(playerid, Galaxy3SlotMachine2[2], 1);
    PlayerTextDrawSetShadow(playerid, Galaxy3SlotMachine2[2], 1);
    PlayerTextDrawUseBox(playerid, Galaxy3SlotMachine2[2], 1);
    PlayerTextDrawBoxColor(playerid, Galaxy3SlotMachine2[2], 255);
    PlayerTextDrawTextSize(playerid, Galaxy3SlotMachine2[2], 30.000000, 100.000000);
    PlayerTextDrawSetSelectable(playerid, Galaxy3SlotMachine2[2], 0);

    Galaxy3SlotMachine2[3] = CreatePlayerTextDraw(playerid, 555.000000, 312.000000, "PLAY");
    PlayerTextDrawAlignment(playerid, Galaxy3SlotMachine2[3], 2);
    PlayerTextDrawBackgroundColor(playerid, Galaxy3SlotMachine2[3], -16776961);
    PlayerTextDrawFont(playerid, Galaxy3SlotMachine2[3], 3);
    PlayerTextDrawLetterSize(playerid, Galaxy3SlotMachine2[3], 0.500000, 1.300000);
    PlayerTextDrawColor(playerid, Galaxy3SlotMachine2[3], -1);
    PlayerTextDrawSetOutline(playerid, Galaxy3SlotMachine2[3], 1);
    PlayerTextDrawSetProportional(playerid, Galaxy3SlotMachine2[3], 1);
    PlayerTextDrawUseBox(playerid, Galaxy3SlotMachine2[3], 1);
    PlayerTextDrawBoxColor(playerid, Galaxy3SlotMachine2[3], 255);
    PlayerTextDrawTextSize(playerid, Galaxy3SlotMachine2[3], 10.000000, 99.000000);
    PlayerTextDrawSetSelectable(playerid, Galaxy3SlotMachine2[3], 1);
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetPhone(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "phone"));
    new query[148];
    format(query, sizeof query, "SELECT * FROM `phoneNumbers` WHERE `USERNAME` = \"%s\"", GetPlayerNameEx(playerid));
    new rows, Cache:result = mysql_query(Database, query);
    rows = cache_num_rows();
    if (rows) cache_get_value_int(0, "PHONE_NUMBER", MobilePlayer[playerid][number]);
    else {
        do MobilePlayer[playerid][number] = RandomEx(80123456, 98765432);
        while (NumberUsed(playerid));
        format(query, sizeof query, "INSERT INTO `phoneNumbers` (`PHONE_NUMBER`, `USERNAME`) VALUES ('%d',\"%s\")", MobilePlayer[playerid][number], GetPlayerNameEx(playerid));
        mysql_tquery(Database, query);
    }
    cache_delete(result);
    return 1;
}

stock NumberUsed(playerid) {
    foreach(new i:Player)
    if (MobilePlayer[i][number] == MobilePlayer[playerid][number] && i != playerid) return 1;

    new query[148];
    format(query, sizeof query, "SELECT * FROM `phoneNumbers` WHERE `PHONE_NUMBER` = '%d'", MobilePlayer[playerid][number]);
    new rows, Cache:result = mysql_query(Database, query);
    rows = cache_num_rows();
    if (rows) return 1;
    cache_delete(result);
    return 0;
}

hook OnPlayerText(playerid, text[]) {
    if (MobilePlayer[playerid][calling] == 1) {
        new str[158];
        GetPlayerName(playerid, str, 24);
        format(str, sizeof(str), "%d (%s): %s", MobilePlayer[playerid][number], str, text);
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xBFC0C2FF, str);
        SendClientMessageEx(playerid, 0xBFC0C2FF, str);
        return -1;
    }
    if (MobilePlayer[playerid][calling] == 3) {
        new str[158];
        GetPlayerName(playerid, str, 24);
        format(str, sizeof(str), "New message from %d (%s) MESSAGE:", MobilePlayer[playerid][number], str);
        new str2[158];
        format(str2, sizeof(str2), "%s", text);
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xBFC0C2FF, str);
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xBFC0C2FF, str2);
        SendClientMessageEx(playerid, 0xBFC0C2FF, "Message sent!");
        KillTimer(TimerWaitCalling[playerid]);
        MobilePlayer[playerid][calling] = 0;
        return -1;
    }
    return 0;
}
forward EndCallBecauseWait(playerid);
public EndCallBecauseWait(playerid) {
    strdel(numberab[playerid], 0, 8);
    PlayerTextDrawSetString(playerid, KeyBoard2, "_");
    SendClientMessageEx(playerid, 0xFFFF00AA, "They did not answer!");
    SendClientMessageEx(MobilePlayer[playerid][caller], 0xFFFF00AA, "Canceled call!");
    MobilePlayer[MobilePlayer[playerid][caller]][calling] = 0;
    MobilePlayer[MobilePlayer[playerid][caller]][caller] = -1;
    MobilePlayer[playerid][calling] = 0;
    MobilePlayer[playerid][caller] = -1;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_YES) {
        if (GetPVarInt(playerid, "cameramode") == 1) {
            for (new i = 0; i < 32; i++) TextDrawHideForPlayer(playerid, Galaxy3Camera[i]);
            GalaxyS3Phone(playerid, 1);
            for (new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid, Galaxy3StartMenu[i]);
            PlayerTextDrawShow(playerid, Galaxy3StartMenu2);
            for (new i = 0; i < 13; i++) TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[i]);
            SelectTextDraw(playerid, 0x33AA33AA);
            DeletePVar(playerid, "cameramode");
            SetCameraBehindPlayer(playerid);
            DestroyDynamicObjectEx(firstpersona[playerid]);
            return ~1;
        }
    }
    return 1;
}

stock Phone:MakeCall(playerid, phoneNumber) {
    foreach(new i:Player) {
        if (IsPlayerConnected(i)) {
            if (MobilePlayer[i][number] == phoneNumber && phoneNumber != 0 && !MobilePlayer[i][calling] && i != playerid) {
                SendClientMessageEx(i, 0xFFFF00AA, sprintf("%d (%s) is calling you ...", MobilePlayer[playerid][number], GetPlayerNameEx(playerid)));
                SendClientMessageEx(playerid, 0xFFFFFFAA, sprintf("You are calling %d (%s) ...", phoneNumber, GetPlayerNameEx(i)));
                MobilePlayer[playerid][calling] = 0;
                MobilePlayer[playerid][caller] = i;
                MobilePlayer[i][calling] = 2;
                MobilePlayer[i][caller] = playerid;
                PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
                PlayerPlaySound(i, 20804, 0.0, 0.0, 0.0);
                TimerWaitCalling[playerid] = SetTimerEx("EndCallBecauseWait", MAX_TIME_TO_WAIT, 0, "i", playerid);
                return 1;
            }
        }
    }
    SendClientMessageEx(playerid, 0xFFFFFFAA, "The dialed number does not exist or is out of coverage. Try it again later");
    return 0;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == Galaxy3[9]) {
        if (!GetPVarInt(playerid, "phones3start")) GalaxyS3PhoneStarting(playerid, 1);
        else GalaxyS3Phone(playerid, 2), DeletePVar(playerid, "phones3start");
    }
    if (clickedid == Galaxy3StartMenu[2])
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[i]);
    if (clickedid == Galaxy3SMainMenu[2]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        TextDrawShowForPlayer(playerid, Galaxy3StartMenu[11]);
        TextDrawShowForPlayer(playerid, Galaxy3StartMenu[12]);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3StartMenu[5] || clickedid == Galaxy3StartMenu[6]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        for (new i = 0; i < 17; i++) TextDrawShowForPlayer(playerid, Galaxy3KeyBoard[i]);
        PlayerTextDrawShow(playerid, KeyBoard2);
    }
    if (clickedid == Galaxy3SMainMenu[5]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, Galaxy3Maps[i]);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3SMainMenu[8]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid, Galaxy3Latitude[i]);
        PlayerTextDrawShow(playerid, Galaxy3Latitude2);
        Phone:UpdatePlayerZone(playerid);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3SMainMenu[9]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 7; i++) TextDrawShowForPlayer(playerid, Galaxy3MusicPlayer[i]);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3SMainMenu[10]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid, Galaxy3SlotMachine[i]);
        for (new i = 0; i < 4; i++) PlayerTextDrawShow(playerid, Galaxy3SlotMachine2[i]);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3SMainMenu[12]) {
        Whatsapp:init(playerid);
    }
    if (clickedid == Galaxy3SMainMenu[13]) {
        ContactList:Menu(playerid);
    }
    if (clickedid == Galaxy3MusicPlayer[1]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/toc6d0gmwyf6m52/gangnamstyle.mp3?dl=1");
    }
    if (clickedid == Galaxy3MusicPlayer[2]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/3lj9dv77pp15opc/Pjanoo.mp3?dl=1");
    }
    if (clickedid == Galaxy3MusicPlayer[3]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xmo5nrwc6uvx90e/PartyLMFAO.mp3?dl=1");
    }
    if (clickedid == Galaxy3MusicPlayer[4]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/sx1pjsyp1u1v4lq/Safari.mp3?dl=1");
    }
    if (clickedid == Galaxy3MusicPlayer[5]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "https://dl.dropbox.com/s/xca4p49hvjtfajo/Inifinity.mp3?dl=1");
    }
    if (clickedid == Galaxy3MusicPlayer[6]) {
        StopAudioStreamForPlayer(playerid);
    }
    if (clickedid == Galaxy3SMainMenu[6]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 3; i++) TextDrawShowForPlayer(playerid, Galaxy3Weather[i]);
        ActualizarWEATHER();
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3KeyBoard[0]) {
        strcat(numberab[playerid], "1");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[1]) {
        strcat(numberab[playerid], "2");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[2]) {
        strcat(numberab[playerid], "3");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[3]) {
        strcat(numberab[playerid], "4");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[4]) {
        strcat(numberab[playerid], "5");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[5]) {
        strcat(numberab[playerid], "6");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[6]) {
        strcat(numberab[playerid], "7");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[7]) {
        strcat(numberab[playerid], "8");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[8]) {
        strcat(numberab[playerid], "9");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[10]) {
        strcat(numberab[playerid], "0");
        PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[12]) {
        if (MobilePlayer[playerid][calling] > 0) return 1;
        new size = strlen(numberab[playerid]);
        if (size == 3 && IsStringSame(numberab[playerid], "911")) {
            return Show911Menu(playerid);
        } else if (size == 8) {
            new name[24];
            GetPlayerName(playerid, name, 24);
            new phonenumb = strval(numberab[playerid]);
            strdel(numberab[playerid], 0, 8);
            PlayerTextDrawSetString(playerid, KeyBoard2, "_");
            Phone:MakeCall(playerid, phonenumb);
        } else AlexaMsg(playerid, "invalid phone number");
        return 1;
    }
    if (clickedid == Galaxy3KeyBoard[13]) {
        if (MobilePlayer[playerid][calling] > 0) return 1;
        new size = strlen(numberab[playerid]);
        if (size == 8) {
            new name[24];
            GetPlayerName(playerid, name, 24);
            new phonenumb = strval(numberab[playerid]);
            strdel(numberab[playerid], 0, 8);
            PlayerTextDrawSetString(playerid, KeyBoard2, "_");
            foreach(new i:Player) {
                if (IsPlayerConnected(i)) {
                    if (MobilePlayer[i][number] == phonenumb && phonenumb != 0 && !MobilePlayer[i][calling] && i != playerid) {
                        MobilePlayer[playerid][calling] = 3;
                        MobilePlayer[playerid][caller] = i;
                        MobilePlayer[i][caller] = playerid;
                        TimerWaitCalling[playerid] = SetTimerEx("EndCallBecauseWait", 20000, 0, "i", playerid);
                        SendClientMessageEx(playerid, -1, "Write your message");
                        return 1;
                    }
                }
            }
            SendClientMessageEx(playerid, 0xFFFFFFAA, "The dialed number does not exist or is out of coverage. Try it again later");
        }
    }
    if (clickedid == Galaxy3KeyBoard[14]) {
        new size = strlen(numberab[playerid]);
        if (size == 1) strdel(numberab[playerid], 0, 1), PlayerTextDrawSetString(playerid, KeyBoard2, "_");
        else if (size == 2) strdel(numberab[playerid], 1, 2), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 3) strdel(numberab[playerid], 2, 3), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 4) strdel(numberab[playerid], 3, 4), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 5) strdel(numberab[playerid], 3, 5), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 6) strdel(numberab[playerid], 3, 6), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 7) strdel(numberab[playerid], 3, 7), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
        else if (size == 8) strdel(numberab[playerid], 3, 8), PlayerTextDrawSetString(playerid, KeyBoard2, numberab[playerid]);
    }
    if (clickedid == Galaxy3KeyBoard[16]) {
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, Galaxy3KeyBoard[i]);
        PlayerTextDrawHide(playerid, KeyBoard2);
        if (MobilePlayer[playerid][calling] == 1 || MobilePlayer[playerid][calling] == 2) {
            SendClientMessageEx(playerid, 0xFFFF00AA, "You hung the call!");
            SendClientMessageEx(MobilePlayer[playerid][caller], 0xFFFF00AA, "They have hung call!");
            KillTimer(TimerWaitCalling[MobilePlayer[playerid][caller]]);
            KillTimer(TimerWaitCalling[playerid]);
            MobilePlayer[MobilePlayer[playerid][caller]][calling] = 0;
            MobilePlayer[MobilePlayer[playerid][caller]][caller] = -1;
            MobilePlayer[playerid][calling] = 0;
            MobilePlayer[playerid][caller] = -1;
            strdel(numberab[playerid], 0, 8);
            PlayerTextDrawSetString(playerid, KeyBoard2, "_");
        } else if (MobilePlayer[playerid][calling] == 3) {
            KillTimer(TimerWaitCalling[playerid]);
            MobilePlayer[MobilePlayer[playerid][caller]][calling] = 0;
            MobilePlayer[MobilePlayer[playerid][caller]][caller] = -1;
            MobilePlayer[playerid][calling] = 0;
            MobilePlayer[playerid][caller] = -1;
            strdel(numberab[playerid], 0, 8);
            PlayerTextDrawSetString(playerid, KeyBoard2, "_");
        }
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[i]);
    }
    if (clickedid == Galaxy3SMainMenu[7]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        for (new i = 0; i < 4; i++) TextDrawShowForPlayer(playerid, Galaxy3Radios[i]);
        SetPVarInt(playerid, "menusi", 1);
    }
    if (clickedid == Galaxy3Radios[0]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "http://somafm.com/tags.pls");
    }
    if (clickedid == Galaxy3Radios[1]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "http://stream2.beatproducciones.com:8012/listen.pls");
    }
    if (clickedid == Galaxy3Radios[2]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "http://194.169.201.177:8085/liveDial.mp3.m3u");
    }
    if (clickedid == Galaxy3Radios[3]) {
        StopAudioStreamForPlayer(playerid);
        PlayAudioStreamForPlayer(playerid, "http://bbc.co.uk/radio/listen/live/r1.asx");
    }
    if (clickedid == Galaxy3Maps[1]) {
        for (new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[0]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[5]);
    }
    if (clickedid == Galaxy3Maps[2]) {
        for (new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[0]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[6]);
    }
    if (clickedid == Galaxy3Maps[3]) {
        for (new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[0]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[7]);
    }
    if (clickedid == Galaxy3Maps[4]) {
        for (new i = 0; i < 5; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[0]);
        TextDrawShowForPlayer(playerid, Galaxy3Maps[8]);
    }
    if (clickedid == Galaxy3Maps[5]) {
        TextDrawHideForPlayer(playerid, Galaxy3Maps[5]);
        for (new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, Galaxy3Maps[i]);
    }
    if (clickedid == Galaxy3Maps[6]) {
        TextDrawHideForPlayer(playerid, Galaxy3Maps[6]);
        for (new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, Galaxy3Maps[i]);
    }
    if (clickedid == Galaxy3Maps[7]) {
        TextDrawHideForPlayer(playerid, Galaxy3Maps[7]);
        for (new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, Galaxy3Maps[i]);
    }
    if (clickedid == Galaxy3Maps[8]) {
        TextDrawHideForPlayer(playerid, Galaxy3Maps[8]);
        for (new i = 0; i < 5; i++) TextDrawShowForPlayer(playerid, Galaxy3Maps[i]);
    }
    if (clickedid == Galaxy3SMainMenu[3]) {
        GalaxyS3Phone(playerid, 3);
        for (new i = 0; i < 32; i++) TextDrawShowForPlayer(playerid, Galaxy3Camera[i]);
        firstpersona[playerid] = CreateDynamicObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachObjectToPlayer(firstpersona[playerid], playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, firstpersona[playerid]);
        SetPVarInt(playerid, "cameramode", 1);
    }
    if (clickedid == Galaxy3SMainMenu[4]) {
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
        TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
        SetPVarInt(playerid, "menusi", 1);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[12]);
    }
    if (clickedid == Galaxy3Gallery[0]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[6]);
    }
    if (clickedid == Galaxy3Gallery[1]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[7]);
    }
    if (clickedid == Galaxy3Gallery[2]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[8]);
    }
    if (clickedid == Galaxy3Gallery[3]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[9]);
    }
    if (clickedid == Galaxy3Gallery[4]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[10]);
    }
    if (clickedid == Galaxy3Gallery[5]) {
        for (new i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        TextDrawShowForPlayer(playerid, Galaxy3Gallery[11]);
    }
    if (clickedid == Galaxy3Gallery[6]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3Gallery[7]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3Gallery[8]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3Gallery[9]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3Gallery[10]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3Gallery[11]) {
        for (new i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, Galaxy3Gallery[i]);
    }
    if (clickedid == Galaxy3SMainMenu[11]) {
        if (!GetPVarInt(playerid, "menusi")) {
            for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
            PlayerTextDrawSetString(playerid, CalculatorTD2, "");
            for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
            PlayerTextDrawHide(playerid, CalculatorTD2);
            DeletePVar(playerid, "calcular");
            var1[playerid] = "";
            var2[playerid] = "";
            DeletePVar(playerid, "calcu");
            DeletePVar(playerid, "cuen");
            DeletePVar(playerid, "tovar");
            TextDrawHideForPlayer(playerid, Galaxy3StartMenu[11]);
            TextDrawHideForPlayer(playerid, Galaxy3StartMenu[12]);
            for (new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
            for (new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
            for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, Galaxy3Weather[i]);
            StopAudioStreamForPlayer(playerid);
            for (new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid, Galaxy3Radios[i]);
            for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Latitude[i]);
            PlayerTextDrawHide(playerid, Galaxy3Latitude2);
            StopAudioStreamForPlayer(playerid);
            for (new i = 0; i < 7; i++) TextDrawHideForPlayer(playerid, Galaxy3MusicPlayer[i]);
            for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3SlotMachine[i]);
            for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Galaxy3SlotMachine2[i]);
            KillTimer(SlotMachineTimer[playerid][0]);
            KillTimer(SlotMachineTimer[playerid][1]);
            DeletePVar(playerid, "phoneGame");
        } else {
            for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[i]);
            PlayerTextDrawSetString(playerid, CalculatorTD2, "");
            for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
            PlayerTextDrawHide(playerid, CalculatorTD2);
            DeletePVar(playerid, "calcular");
            var1[playerid] = "";
            var2[playerid] = "";
            DeletePVar(playerid, "calcu");
            DeletePVar(playerid, "cuen");
            DeletePVar(playerid, "tovar");
            TextDrawHideForPlayer(playerid, Galaxy3StartMenu[11]);
            TextDrawHideForPlayer(playerid, Galaxy3StartMenu[12]);
            for (new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
            for (new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
            for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, Galaxy3Weather[i]);
            StopAudioStreamForPlayer(playerid);
            for (new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid, Galaxy3Radios[i]);
            for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Latitude[i]);
            PlayerTextDrawHide(playerid, Galaxy3Latitude2);
            StopAudioStreamForPlayer(playerid);
            for (new i = 0; i < 7; i++) TextDrawHideForPlayer(playerid, Galaxy3MusicPlayer[i]);
            for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3SlotMachine[i]);
            for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Galaxy3SlotMachine2[i]);
            KillTimer(SlotMachineTimer[playerid][0]);
            KillTimer(SlotMachineTimer[playerid][1]);
            DeletePVar(playerid, "phoneGame");
            DeletePVar(playerid, "menusi");
        }
    }
    if (clickedid == Galaxy3SMainMenu[1]) {
        if (!GetPVarInt(playerid, "calcular")) {
            for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
            TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[0]);
            TextDrawShowForPlayer(playerid, Galaxy3SMainMenu[11]);
            for (new i = 0; i < 17; i++) TextDrawShowForPlayer(playerid, CalculatorTD[i]);
            PlayerTextDrawShow(playerid, CalculatorTD2);
            SetPVarInt(playerid, "calcular", 1);
            SetPVarInt(playerid, "menusi", 1);
        } else {
            PlayerTextDrawSetString(playerid, CalculatorTD2, "");
            for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
            PlayerTextDrawHide(playerid, CalculatorTD2);
            DeletePVar(playerid, "calcular");
            var1[playerid] = "";
            var2[playerid] = "";
            DeletePVar(playerid, "calcu");
            DeletePVar(playerid, "cuen");
            DeletePVar(playerid, "tovar");
        }
    }

    if (clickedid == CalculatorTD[1]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "7"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "7"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[2]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "8"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "8"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[3]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "9"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "9"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[4]) {
        if (GetPVarInt(playerid, "calcu") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "ERROR"), DeletePVar(playerid, "calcu");
        if (!GetPVarInt(playerid, "calcu"))
            if (GetPVarInt(playerid, "tovar") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "/"), SetPVarInt(playerid, "calcu", 1), SetPVarInt(playerid, "cuen", 1);
    }
    if (clickedid == CalculatorTD[5]) {
        if (GetPVarInt(playerid, "calcu") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "ERROR"), DeletePVar(playerid, "calcu");
        if (!GetPVarInt(playerid, "calcu"))
            if (GetPVarInt(playerid, "tovar") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "X"), SetPVarInt(playerid, "calcu", 1), SetPVarInt(playerid, "cuen", 2);
    }
    if (clickedid == CalculatorTD[6]) {
        if (GetPVarInt(playerid, "calcu") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "ERROR"), DeletePVar(playerid, "calcu");
        if (!GetPVarInt(playerid, "calcu"))
            if (GetPVarInt(playerid, "tovar") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "-"), SetPVarInt(playerid, "calcu", 1), SetPVarInt(playerid, "cuen", 3);
    }
    if (clickedid == CalculatorTD[7]) {
        if (GetPVarInt(playerid, "calcu") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "ERROR"), DeletePVar(playerid, "calcu");
        if (!GetPVarInt(playerid, "calcu"))
            if (GetPVarInt(playerid, "tovar") == 1) PlayerTextDrawSetString(playerid, CalculatorTD2, "+"), SetPVarInt(playerid, "calcu", 1), SetPVarInt(playerid, "cuen", 4);
    }
    if (clickedid == CalculatorTD[8]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "6"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "6"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[9]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "5"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "5"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[10]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "4"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "4"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[11]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "1"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "1"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[12]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "2"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "2"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[13]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "3"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) strcat(var2[playerid], "3"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
    }
    if (clickedid == CalculatorTD[14]) {
        if (!GetPVarInt(playerid, "calcu")) strcat(var1[playerid], "0"), PlayerTextDrawSetString(playerid, CalculatorTD2, var1[playerid]), SetPVarInt(playerid, "tovar", 1);
        if (GetPVarInt(playerid, "calcu") == 1) {
            if (GetPVarInt(playerid, "cuen") == 1) {
                SetPVarInt(playerid, "nodivide", 1);
                strcat(var2[playerid], "0"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
            } else {
                strcat(var2[playerid], "0"), PlayerTextDrawSetString(playerid, CalculatorTD2, var2[playerid]);
            }
        }
    }
    if (clickedid == CalculatorTD[15]) {
        if (!GetPVarInt(playerid, "calcu")) {
            PlayerTextDrawSetString(playerid, CalculatorTD2, "ERROR");
            var1[playerid] = "";
            var2[playerid] = "";
            DeletePVar(playerid, "calcu");
            DeletePVar(playerid, "cuen");
            DeletePVar(playerid, "tovar");
        }
        if (GetPVarInt(playerid, "calcu") == 1) {
            new str[64], nu1, nu2;
            nu1 = strval(var1[playerid]);
            nu2 = strval(var2[playerid]);
            if (GetPVarInt(playerid, "cuen") == 1) {
                if (GetPVarInt(playerid, "nodivide") == 1) {
                    PlayerTextDrawSetString(playerid, CalculatorTD2, "0");
                    DeletePVar(playerid, "nodivide");
                } else {
                    format(str, sizeof(str), "%d", nu1 / nu2);
                    PlayerTextDrawSetString(playerid, CalculatorTD2, str);
                }
            } else if (GetPVarInt(playerid, "cuen") == 2) {
                format(str, sizeof(str), "%d", nu1 * nu2);
                PlayerTextDrawSetString(playerid, CalculatorTD2, str);
            } else if (GetPVarInt(playerid, "cuen") == 3) {
                format(str, sizeof(str), "%d", nu1 - nu2);
                PlayerTextDrawSetString(playerid, CalculatorTD2, str);
            } else if (GetPVarInt(playerid, "cuen") == 4) {
                format(str, sizeof(str), "%d", nu1 + nu2);
                PlayerTextDrawSetString(playerid, CalculatorTD2, str);
            }
            var1[playerid] = "";
            var2[playerid] = "";
            DeletePVar(playerid, "calcu");
            DeletePVar(playerid, "cuen");
            DeletePVar(playerid, "tovar");
        }
    }
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (playertextid == Galaxy3SlotMachine2[3]) {
        if (!GetPVarInt(playerid, "phoneGame")) {
            SetPVarInt(playerid, "phoneGame", 1);
            SlotMachineTimer[playerid][0] = SetTimerEx("StartPhoneGame", 100, 1, "i", playerid);
            SlotMachineTimer[playerid][1] = SetTimerEx("EndPhoneGame", 8000, 0, "i", playerid);
        }
    }
    return 1;
}

stock Phone:GetPlayerNumber(playerid) {
    return MobilePlayer[playerid][number];
}

forward StartPhoneGame(playerid);
public StartPhoneGame(playerid) {
    randomvar[0] = random(6);
    randomvar[1] = random(6);
    randomvar[2] = random(6);
    PlayerTextDrawSetString(playerid, Galaxy3SlotMachine2[0], Phone:Slots[randomvar[0]]);
    PlayerTextDrawSetString(playerid, Galaxy3SlotMachine2[1], Phone:Slots[randomvar[1]]);
    PlayerTextDrawSetString(playerid, Galaxy3SlotMachine2[2], Phone:Slots[randomvar[2]]);
    return 1;
}

forward EndPhoneGame(playerid);
public EndPhoneGame(playerid) {
    KillTimer(SlotMachineTimer[playerid][0]);
    DeletePVar(playerid, "phoneGame");
    if (randomvar[0] == randomvar[1] && randomvar[1] == randomvar[2]) {
        PlayerTextDrawSetString(playerid, Galaxy3SlotMachine2[3], "WON");
        vault:PlayerVault(playerid, 100, "won in phone game", Vault_ID_Government, -100, sprintf("%s won in phone game", GetPlayerNameEx(playerid)));
    } else {
        PlayerTextDrawSetString(playerid, Galaxy3SlotMachine2[3], "YOU LOST");
        vault:PlayerVault(playerid, -100, "loss in phone game", Vault_ID_Government, 100, sprintf("%s loss in phone game", GetPlayerNameEx(playerid)));
    }
    return 1;
}

forward GalaxyS3PhoneStart(playerid);
public GalaxyS3PhoneStart(playerid) {
    GalaxyS3PhoneStarting(playerid, 2);
    for (new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid, Galaxy3StartMenu[i]);
    PlayerTextDrawShow(playerid, Galaxy3StartMenu2);
    if (Phone:IsPlayerInArea(playerid, 44.60, -2892.90, 2997.00, -768.00)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "3G"); //LS
    if (Phone:IsPlayerInArea(playerid, 869.40, 596.30, 2997.00, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "5G"); //LV
    if (Phone:IsPlayerInArea(playerid, -480.50, 596.30, 869.40, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //BoneCounty
    if (Phone:IsPlayerInArea(playerid, -2997.40, 1659.60, -480.50, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //TierraRobada
    if (Phone:IsPlayerInArea(playerid, -1213.90, 596.30, -480.50, 1659.60)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //TierraRobada
    if (Phone:IsPlayerInArea(playerid, -2997.40, -1115.50, -1213.90, 1659.60)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "6G"); //SanFierro
    if (Phone:IsPlayerInArea(playerid, -1213.90, -768.00, 2997.00, 596.30)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //RedCountry
    if (Phone:IsPlayerInArea(playerid, -1213.90, -2892.90, 44.60, -768.00)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //FlintCounty
    if (Phone:IsPlayerInArea(playerid, -2997.40, -2892.90, -1213.90, -1115.50)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //Whetstone
    return 1;
}

forward UpdateTime();
public UpdateTime() {
    new Hour, Minute, Second;
    gettime(Hour, Minute, Second);
    new str[64];
    format(str, sizeof(str), "%02d:%02d", Hour, Minute);
    TextDrawSetString(Galaxy3StartMenu[1], str);
    TextDrawSetString(Galaxy3StartMenu[8], str);
    TextDrawSetString(Galaxy3StartMenu[12], str);
    TextDrawSetString(Galaxy3Camera[28], str);

    new Year, Month, Day;
    getdate(Year, Month, Day);
    new str2[64];
    format(str2, sizeof(str2), "%02d/%s/%s", Day, GetMonth(Month), GetYearFormat00(Year));
    TextDrawSetString(Galaxy3StartMenu[3], str2);
    TextDrawSetString(Galaxy3StartMenu[11], str2);
    return 1;
}

stock GalaxyS3Phone(playerid, current) {
    if (current == 0) {
        DeletePVar(playerid, "phones3");
        CancelSelectTextDraw(playerid);
        GalaxyS3PhoneStarting(playerid, 0);
        for (new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid, Galaxy3StartMenu[i]);
        PlayerTextDrawHide(playerid, Galaxy3StartMenu2);
        for (new i = 0; i < 16; i++) TextDrawHideForPlayer(playerid, Galaxy3[i]);
        //KillTimer(TimerS3[playerid][0]);
        KillTimer(TimerS3[playerid][1]);
        PlayerTextDrawSetString(playerid, CalculatorTD2, "");
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
        PlayerTextDrawHide(playerid, CalculatorTD2);
        DeletePVar(playerid, "calcular");
        var1[playerid] = "";
        var2[playerid] = "";
        DeletePVar(playerid, "calcu");
        DeletePVar(playerid, "cuen");
        DeletePVar(playerid, "tovar");
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[11]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[12]);
        for (new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 32; i++) TextDrawHideForPlayer(playerid, Galaxy3Camera[i]);
        if (GetPVarInt(playerid, "cameramode") == 1) {
            SetCameraBehindPlayer(playerid);
            DestroyDynamicObjectEx(firstpersona[playerid]);
            DeletePVar(playerid, "cameramode");
        }
        for (new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, Galaxy3Weather[i]);
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid, Galaxy3Radios[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Latitude[i]);
        PlayerTextDrawHide(playerid, Galaxy3Latitude2);
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, Galaxy3KeyBoard[i]);
        PlayerTextDrawHide(playerid, KeyBoard2);
        Phone:HangUp(playerid);
        strdel(numberab[playerid], 0, 8);
        PlayerTextDrawSetString(playerid, KeyBoard2, "_");
        strdel(numberab[playerid], 0, 8);
        MobilePlayer[playerid][calling] = 0;
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 7; i++) TextDrawHideForPlayer(playerid, Galaxy3MusicPlayer[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3SlotMachine[i]);
        for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Galaxy3SlotMachine2[i]);
        KillTimer(SlotMachineTimer[playerid][0]);
        KillTimer(SlotMachineTimer[playerid][1]);
        DeletePVar(playerid, "phoneGame");
    } else if (current == 1) {
        SetPVarInt(playerid, "phones3", 1);
        for (new i = 0; i < 16; i++) TextDrawShowForPlayer(playerid, Galaxy3[i]);
        SelectTextDraw(playerid, 0x33AA33AA);
    } else if (current == 2) {
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Start[i]);
        for (new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid, Galaxy3StartMenu[i]);
        PlayerTextDrawHide(playerid, Galaxy3StartMenu2);
        //KillTimer(TimerS3[playerid][0]);
        KillTimer(TimerS3[playerid][1]);
        PlayerTextDrawSetString(playerid, CalculatorTD2, "");
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
        PlayerTextDrawHide(playerid, CalculatorTD2);
        DeletePVar(playerid, "calcular");
        var1[playerid] = "";
        var2[playerid] = "";
        DeletePVar(playerid, "calcu");
        DeletePVar(playerid, "cuen");
        DeletePVar(playerid, "tovar");
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[11]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[12]);
        for (new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, Galaxy3Weather[i]);
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid, Galaxy3Radios[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Latitude[i]);
        PlayerTextDrawHide(playerid, Galaxy3Latitude2);
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, Galaxy3KeyBoard[i]);
        PlayerTextDrawHide(playerid, KeyBoard2);
        Phone:HangUp(playerid);
        strdel(numberab[playerid], 0, 8);
        PlayerTextDrawSetString(playerid, KeyBoard2, "_");
        strdel(numberab[playerid], 0, 8);
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 7; i++) TextDrawHideForPlayer(playerid, Galaxy3MusicPlayer[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3SlotMachine[i]);
        for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Galaxy3SlotMachine2[i]);
        KillTimer(SlotMachineTimer[playerid][0]);
        KillTimer(SlotMachineTimer[playerid][1]);
        DeletePVar(playerid, "phoneGame");
        MobilePlayer[playerid][calling] = 0;
    } else if (current == 3) {
        CancelSelectTextDraw(playerid);
        GalaxyS3PhoneStarting(playerid, 0);
        for (new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid, Galaxy3StartMenu[i]);
        PlayerTextDrawHide(playerid, Galaxy3StartMenu2);
        for (new i = 0; i < 16; i++) TextDrawHideForPlayer(playerid, Galaxy3[i]);
        //KillTimer(TimerS3[playerid][0]);
        KillTimer(TimerS3[playerid][1]);
        PlayerTextDrawSetString(playerid, CalculatorTD2, "");
        for (new i = 0; i < 17; i++) TextDrawHideForPlayer(playerid, CalculatorTD[i]);
        PlayerTextDrawHide(playerid, CalculatorTD2);
        DeletePVar(playerid, "calcular");
        var1[playerid] = "";
        var2[playerid] = "";
        DeletePVar(playerid, "calcu");
        DeletePVar(playerid, "cuen");
        DeletePVar(playerid, "tovar");
        for (new i = 0; i < MAX_S3_MAIN_MENU; i++) TextDrawHideForPlayer(playerid, Galaxy3SMainMenu[i]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[11]);
        TextDrawHideForPlayer(playerid, Galaxy3StartMenu[12]);
        for (new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, Galaxy3Gallery[i]);
        for (new i = 0; i < 32; i++) TextDrawHideForPlayer(playerid, Galaxy3Camera[i]);
        for (new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, Galaxy3Maps[i]);
        for (new i = 0; i < 3; i++) TextDrawHideForPlayer(playerid, Galaxy3Weather[i]);
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 4; i++) TextDrawHideForPlayer(playerid, Galaxy3Radios[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Latitude[i]);
        PlayerTextDrawHide(playerid, Galaxy3Latitude2);
        StopAudioStreamForPlayer(playerid);
        for (new i = 0; i < 7; i++) TextDrawHideForPlayer(playerid, Galaxy3MusicPlayer[i]);
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3SlotMachine[i]);
        for (new i = 0; i < 4; i++) PlayerTextDrawHide(playerid, Galaxy3SlotMachine2[i]);
        KillTimer(SlotMachineTimer[playerid][0]);
        KillTimer(SlotMachineTimer[playerid][1]);
        DeletePVar(playerid, "phoneGame");
        DeletePVar(playerid, "cameramode");
    }
    return 1;
}

stock GalaxyS3PhoneStarting(playerid, current) {
    if (current == 0) {
        DeletePVar(playerid, "phones3start");
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Start[i]);
    } else if (current == 1) {
        TimerS3[playerid][1] = SetTimerEx("GalaxyS3PhoneStart", 5000, 0, "i", playerid);
        for (new i = 0; i < 2; i++) TextDrawShowForPlayer(playerid, Galaxy3Start[i]);
        SetPVarInt(playerid, "phones3start", 1);
    } else if (current == 2) {
        for (new i = 0; i < 2; i++) TextDrawHideForPlayer(playerid, Galaxy3Start[i]);
    }
    return 1;
}

stock GetMonth(Month) {
    new MonthStr[15];
    switch (Month) {
        case 1:
            MonthStr = "ENE";
        case 2:
            MonthStr = "FEB";
        case 3:
            MonthStr = "MAR";
        case 4:
            MonthStr = "ABR";
        case 5:
            MonthStr = "MAY";
        case 6:
            MonthStr = "JUN";
        case 7:
            MonthStr = "JUL";
        case 8:
            MonthStr = "AGO";
        case 9:
            MonthStr = "SEP";
        case 10:
            MonthStr = "OCT";
        case 11:
            MonthStr = "NOV";
        case 12:
            MonthStr = "DIC";
    }
    return MonthStr;
}

stock GetYearFormat00(Year) {
    new YearStr[3];
    switch (Year) {
        case 2012:
            YearStr = "12";
        case 2013:
            YearStr = "13";
        case 2014:
            YearStr = "14";
        case 2015:
            YearStr = "15";
        case 2016:
            YearStr = "16";
        case 2017:
            YearStr = "17";
        case 2018:
            YearStr = "18";
        case 2019:
            YearStr = "19";
        case 2020:
            YearStr = "20";
        case 2021:
            YearStr = "21";
        case 2022:
            YearStr = "22";
        case 2023:
            YearStr = "23";
        case 2024:
            YearStr = "24";
        case 2025:
            YearStr = "25";
        case 2026:
            YearStr = "26";
        case 2027:
            YearStr = "27";
        case 2028:
            YearStr = "28";
        case 2029:
            YearStr = "29";
        case 2030:
            YearStr = "30";
    }
    return YearStr;
}

stock ActualizarWEATHER() {
    new weather[64], idwea;
    GetServerVarAsString("weather", weather, sizeof(weather));
    idwea = strval(weather);
    if (idwea >= 0 && idwea <= 7) TextDrawSetString(Galaxy3Weather[2], "SUNNY");
    else if (idwea == 8) TextDrawSetString(Galaxy3Weather[2], "STORMY");
    else if (idwea == 9) TextDrawSetString(Galaxy3Weather[2], "FOG");
    else if (idwea == 10) TextDrawSetString(Galaxy3Weather[2], "SUNNY");
    else if (idwea == 11) TextDrawSetString(Galaxy3Weather[2], "MUCH HOT");
    else if (idwea >= 12 && idwea <= 15) TextDrawSetString(Galaxy3Weather[2], "BORING");
    else if (idwea == 16) TextDrawSetString(Galaxy3Weather[2], "CLOUDY WITH RAIN");
    else if (idwea >= 17 && idwea <= 18) TextDrawSetString(Galaxy3Weather[2], "HOT");
    else if (idwea == 19) TextDrawSetString(Galaxy3Weather[2], "SANDSTORM");
    else if (idwea == 20) TextDrawSetString(Galaxy3Weather[2], "GREEN FOG");
    else if (idwea == 21) TextDrawSetString(Galaxy3Weather[2], "VERY DARK");
    else if (idwea == 22) TextDrawSetString(Galaxy3Weather[2], "VERY DARK");
    else if (idwea >= 23 && idwea <= 26) TextDrawSetString(Galaxy3Weather[2], "PALE ORANGE");
    else if (idwea >= 27 && idwea <= 29) TextDrawSetString(Galaxy3Weather[2], "BLUE FRESH");
    else if (idwea >= 30 && idwea <= 32) TextDrawSetString(Galaxy3Weather[2], "DARK");
    else if (idwea == 33) TextDrawSetString(Galaxy3Weather[2], "DARK");
    else if (idwea == 34) TextDrawSetString(Galaxy3Weather[2], "BLUE");
    else if (idwea == 35) TextDrawSetString(Galaxy3Weather[2], "BROWN");
    else if (idwea >= 36 && idwea <= 38) TextDrawSetString(Galaxy3Weather[2], "SPARKLY");
    else if (idwea == 39) TextDrawSetString(Galaxy3Weather[2], "VERY BRIGHT");
    else if (idwea >= 40 && idwea <= 42) TextDrawSetString(Galaxy3Weather[2], "PURPLE BLUE");
    else if (idwea == 43) TextDrawSetString(Galaxy3Weather[2], "TOXIC");
    else if (idwea == 44) TextDrawSetString(Galaxy3Weather[2], "BLACK");
    else if (idwea == 45) TextDrawSetString(Galaxy3Weather[2], "BLACK");
    return 1;
}

stock Phone:UpdatePlayerZone(playerid) {
    new string[256];
    format(string, sizeof(string), "%s", GetPlayerZoneName(playerid));
    PlayerTextDrawSetString(playerid, Galaxy3Latitude2, string);
    return 1;
}

Phone:IsPlayerInArea(playerid, Float:ps_MinX, Float:ps_MinY, Float:ps_MaxX, Float:ps_MaxY) {
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    if (X >= ps_MinX && X <= ps_MaxX && Y >= ps_MinY && Y <= ps_MaxY) {
        return 1;
    }
    return 0;
}

stock sel_Phone:Show(playerid) {
    ActualizarWEATHER();
    Phone:UpdatePlayerZone(playerid);
    if (Phone:IsPlayerInArea(playerid, 44.60, -2892.90, 2997.00, -768.00)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "3G"); //LS
    if (Phone:IsPlayerInArea(playerid, 869.40, 596.30, 2997.00, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "4G"); //LV
    if (Phone:IsPlayerInArea(playerid, -480.50, 596.30, 869.40, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //BoneCounty
    if (Phone:IsPlayerInArea(playerid, -2997.40, 1659.60, -480.50, 2993.80)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //TierraRobada
    if (Phone:IsPlayerInArea(playerid, -1213.90, 596.30, -480.50, 1659.60)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //TierraRobada
    if (Phone:IsPlayerInArea(playerid, -2997.40, -1115.50, -1213.90, 1659.60)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "3G"); //SanFierro
    if (Phone:IsPlayerInArea(playerid, -1213.90, -768.00, 2997.00, 596.30)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "G"); //RedCountry
    if (Phone:IsPlayerInArea(playerid, -1213.90, -2892.90, 44.60, -768.00)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //FlintCounty
    if (Phone:IsPlayerInArea(playerid, -2997.40, -2892.90, -1213.90, -1115.50)) PlayerTextDrawSetString(playerid, Galaxy3StartMenu2, "E"); //Whetstone
    SelectTextDraw(playerid, 0x33AA33AA);
    return 1;
}

stock Phone:Show(playerid) {
    if (!GetPVarInt(playerid, "phones3")) GalaxyS3Phone(playerid, 1);
    else GalaxyS3Phone(playerid, 0);
    HideHPTL(playerid);
    ShowHPTL(playerid);
    return 1;
}
stock Phone:Answer(playerid) {
    if (MobilePlayer[playerid][calling] == 2) {
        KillTimer(TimerWaitCalling[MobilePlayer[playerid][caller]]);
        MobilePlayer[playerid][calling] = 1;
        MobilePlayer[MobilePlayer[playerid][caller]][calling] = 1;
        SendClientMessageEx(playerid, 0xFFFF00AA, "Call initiated!");
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xFFFF00AA, "Call initiated!");
    }
    return 1;
}
stock Phone:HangUp(playerid) {
    if (MobilePlayer[playerid][calling] == 1) {
        KillTimer(TimerWaitCalling[MobilePlayer[playerid][caller]]);
        KillTimer(TimerWaitCalling[playerid]);
        SendClientMessageEx(playerid, 0xFFFF00AA, "You have hung up the call!");
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xFFFF00AA, "They hung up the call!");
        MobilePlayer[MobilePlayer[playerid][caller]][calling] = 0;
        MobilePlayer[MobilePlayer[playerid][caller]][caller] = -1;
        MobilePlayer[playerid][calling] = 0;
        MobilePlayer[playerid][caller] = -1;
    } else if (MobilePlayer[playerid][calling] == 2) {
        KillTimer(TimerWaitCalling[playerid]);
        KillTimer(TimerWaitCalling[MobilePlayer[playerid][caller]]);
        SendClientMessageEx(playerid, 0xFFFF00AA, "You rejected the call!");
        SendClientMessageEx(MobilePlayer[playerid][caller], 0xFFFF00AA, "They did not take the call...");
        MobilePlayer[MobilePlayer[playerid][caller]][calling] = 0;
        MobilePlayer[MobilePlayer[playerid][caller]][caller] = -1;
        MobilePlayer[playerid][calling] = 0;
        MobilePlayer[playerid][caller] = -1;
    }
    return 1;
}

new EtShop:DataPhone[MAX_PLAYERS];

stock EtShop:IsPhoneActive(playerid) {
    return gettime() < EtShop:DataPhone[playerid];
}

stock EtShop:GetPhone(playerid) {
    return EtShop:DataPhone[playerid];
}

stock EtShop:SetPhone(playerid, expireAt) {
    EtShop:DataPhone[playerid] = expireAt;
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 37) return 1;
    if (EtShop:IsPhoneActive(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have phone, no need to purchase it again until it expires."); return ~1; }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase phone"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetPhone(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased phone. Validity: 30 days");
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page == 0) {
        if (MobilePlayer[playerid][calling] == 2) UCP:AddCommand(playerid, "Answer Call", true);
        if (MobilePlayer[playerid][calling] == 1 || MobilePlayer[playerid][calling] == 2) UCP:AddCommand(playerid, "Hangup Call", true);
    } else if (page == 1 && EtShop:IsPhoneActive(playerid)) {
        UCP:AddCommand(playerid, "Use Phone");
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Answer Call", inputtext)) Phone:Answer(playerid);
    if (IsStringSame("Hangup Call", inputtext)) Phone:HangUp(playerid);
    if (IsStringSame("Use Phone", inputtext)) Phone:Show(playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `phoneNumbers` SET `USERNAME` = \"%s\" WHERE  `USERNAME` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `phoneNumbers` WHERE `USERNAME` = \"%s\"", AccountName));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    PlayerTextDrawDestroy(playerid, CalculatorTD2);
    if (MobilePlayer[playerid][calling] == 1 || MobilePlayer[playerid][calling] == 2) Phone:HangUp(playerid);
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(EtShop:GetPhone(playerid), GetPlayerNameEx(playerid), "username", "phone");
    return 1;
}