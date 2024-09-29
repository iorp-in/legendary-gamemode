#define COLOR_LGREEN 0xD7FFB3FF

new PlayerText:CasinoPTD[33],
    Text:CasinoTD[15],
    MineActive[MAX_PLAYERS][30],
    MineBomb[MAX_PLAYERS][30];

hook OnGameModeInit() {
    GlobalTextDraw();
    foreach(new i:Player) {
        if (IsPlayerConnected(i)) PlayerTextDraw(i);
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    PlayerTextDraw(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (GetPVarInt(playerid, "PlayMine") == 1) HideCasinoTDs(playerid);
    DeletePVar(playerid, "PlayMine");
    DeletePVar(playerid, "BetAmount");
    DeletePVar(playerid, "Mines");
    DeletePVar(playerid, "StartedGame");
    DeletePVar(playerid, "MineType");
    DeletePVar(playerid, "MoneyEarned");
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (GetPVarInt(playerid, "PlayMine") == 1) {
        if (GetPVarInt(playerid, "StartedGame") == 1 && GetPVarInt(playerid, "Loser") == 0) {
            new string[126];
            for (new i = 0; i < 30; i++) {
                if (playertextid == CasinoPTD[i] && MineActive[playerid][i] == 0) {
                    MineActive[playerid][i] = 1;
                    SetPVarInt(playerid, "Mines", 1 + GetPVarInt(playerid, "Mines"));
                    if (MineBomb[playerid][i] == 0) {
                        PlayerTextDrawBoxColor(playerid, CasinoPTD[i], 0x80FF00FF);
                        PlayerTextDrawShow(playerid, CasinoPTD[i]);
                        new money, bet = GetPVarInt(playerid, "BetAmount");
                        if (GetPVarInt(playerid, "MineType") == 1) money += bet / 8;
                        else if (GetPVarInt(playerid, "MineType") == 3) money += bet / 5;
                        else if (GetPVarInt(playerid, "MineType") == 6) money += bet / 3;
                        SetPVarInt(playerid, "MoneyEarned", money + GetPVarInt(playerid, "MoneyEarned"));

                        PlayerTextDrawSetString(playerid, CasinoPTD[30], "~g~You won! : )");
                        format(string, sizeof(string), "Played times: ~g~%d~w~~h~~n~Money earned: ~g~$%s", GetPVarInt(playerid, "Mines"), Msw_FormatNumber(GetPVarInt(playerid, "MoneyEarned")));
                        PlayerTextDrawSetString(playerid, CasinoPTD[31], string);
                    } else {
                        PlayerTextDrawSetString(playerid, CasinoPTD[30], "~r~You lose!~n~You can play in 5 seconds");

                        format(string, sizeof(string), "* %s lost $%s in Mine Sweeper.", GetPlayerNameEx(playerid), Msw_FormatNumber(GetPVarInt(playerid, "BetAmount")));
                        Msw_ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

                        for (new x = 0; x < 30; x++) {
                            if (MineBomb[playerid][x] == 1) {
                                PlayerTextDrawBoxColor(playerid, CasinoPTD[x], 0xFF0000FF);
                                PlayerTextDrawShow(playerid, CasinoPTD[x]);
                            }
                        }

                        format(string, sizeof(string), "Played times: ~g~%d~w~~h~~n~Money earned: ~g~$%s", GetPVarInt(playerid, "Mines"), Msw_FormatNumber(GetPVarInt(playerid, "MoneyEarned")));
                        PlayerTextDrawSetString(playerid, CasinoPTD[31], string);

                        SetTimerEx("ShowMine", 5000, 0, "i", playerid);
                        SetPVarInt(playerid, "Loser", 1);
                    }
                    PlayerTextDrawShow(playerid, CasinoPTD[30]);
                    PlayerTextDrawShow(playerid, CasinoPTD[31]);
                }
            }
        }
        if (playertextid == CasinoPTD[32] && GetPVarInt(playerid, "BetAmount") == 0) {
            FlexPlayerDialog(
                playerid, "MineSweeperMenu", DIALOG_STYLE_INPUT, "Bet amount",
                "Set the amount you want to play with.\nYou can put a minimum of $ 1,000 and a maximum of $ 50,000.",
                "Select", "Close"
            );
        }
    }
    return 1;
}

FlexDialog:MineSweeperMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new string[128];
    if (strval(inputtext) < 1000 || strval(inputtext) > 50000) return SendClientMessage(playerid, COLOR_LGREEN, "Error: Invalid amount! You can put a minimum of $1,000 and a maximum of $50,000.");
    if (GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid, COLOR_LGREEN, "Error: You do not have enough amount of money!");
    SetPVarInt(playerid, "BetAmount", strval(inputtext));
    vault:PlayerVault(playerid, -strval(inputtext), "bet Mine Sweeper", Vault_ID_Government, strval(inputtext), sprintf("%s bet Mine Sweeper", GetPlayerNameEx(playerid)));

    format(string, sizeof(string), "~w~~h~Bet: ~g~$%s", Msw_FormatNumber(strval(inputtext)));
    PlayerTextDrawSetString(playerid, CasinoPTD[32], string);
    PlayerTextDrawShow(playerid, CasinoPTD[32]);
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (GetPVarInt(playerid, "PlayMine") == 1 && GetPVarInt(playerid, "Loser") == 0) {
        new string[128];
        if (clickedid == CasinoTD[4]) {
            if (GetPVarInt(playerid, "StartedGame") == 1 && GetPVarInt(playerid, "Mines") > 0) return SendClientMessage(playerid, COLOR_LGREEN, "Eroare: Pentru a inchide jocul, trebuie sa dai 'Cash out'!");
            HideCasinoTDs(playerid);
        }
        if (clickedid == CasinoTD[6] && GetPVarInt(playerid, "StartedGame") == 1 && GetPVarInt(playerid, "Mines") > 0) {
            vault:PlayerVault(playerid, GetPVarInt(playerid, "MoneyEarned"), "win Mine Sweeper", Vault_ID_Government, -GetPVarInt(playerid, "MoneyEarned"), sprintf("%s win Mine Sweeper", GetPlayerNameEx(playerid)));
            format(string, sizeof(string), "* %s won $%s in Mine Sweeper.", GetPlayerNameEx(playerid), Msw_FormatNumber(GetPVarInt(playerid, "MoneyEarned")));
            Msw_ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
            format(string, sizeof(string), "~g~Congratulations! You won $%s.", Msw_FormatNumber(GetPVarInt(playerid, "MoneyEarned")));
            ShowCasinoTDs(playerid);
            PlayerTextDrawSetString(playerid, CasinoPTD[30], string);
            PlayerTextDrawShow(playerid, CasinoPTD[30]);
            format(string, sizeof(string), "Played times: ~g~%d~w~~h~~n~Money earned: ~g~$%s", GetPVarInt(playerid, "Mines"), Msw_FormatNumber(GetPVarInt(playerid, "MoneyEarned")));
            PlayerTextDrawSetString(playerid, CasinoPTD[31], string);
            PlayerTextDrawShow(playerid, CasinoPTD[31]);
            return 1;
        }
        if (GetPVarInt(playerid, "StartedGame") == 1) return SendClientMessage(playerid, COLOR_LGREEN, "Error: The game has started! No more changes can be made until you cash out.");
        if (clickedid == CasinoTD[9] && GetPVarInt(playerid, "MineType") == 0) SetPVarInt(playerid, "MineType", 1), TextDrawColor(CasinoTD[9], 0x80FF00FF), TextDrawShowForPlayer(playerid, CasinoTD[9]);
        if (clickedid == CasinoTD[7] && GetPVarInt(playerid, "MineType") == 0) SetPVarInt(playerid, "MineType", 3), TextDrawColor(CasinoTD[7], 0x80FF00FF), TextDrawShowForPlayer(playerid, CasinoTD[7]);
        if (clickedid == CasinoTD[12] && GetPVarInt(playerid, "MineType") == 0) SetPVarInt(playerid, "MineType", 6), TextDrawColor(CasinoTD[12], 0x80FF00FF), TextDrawShowForPlayer(playerid, CasinoTD[12]);

        if (clickedid == CasinoTD[5]) {
            if (GetPVarInt(playerid, "MineType") == 0 || GetPVarInt(playerid, "BetAmount") == 0) return SendClientMessage(playerid, COLOR_LGREEN, "Error: The game did not start because you did not bet a sum / did not choose the number of bombs.");
            for (new i = 0; i < 30; i++) MineBomb[playerid][i] = 0;
            new rand1 = random(30),
                rand2 = random(30),
                rand3 = random(30),
                rand4 = random(30),
                rand5 = random(30),
                rand6 = random(30);

            if (rand1 == rand2 || rand1 == rand3 || rand1 == rand4 || rand1 == rand5 || rand1 == rand6) rand1 = random(30);
            if (rand2 == rand1 || rand2 == rand3 || rand2 == rand4 || rand2 == rand5 || rand2 == rand6) rand2 = random(30);
            if (rand3 == rand1 || rand3 == rand2 || rand3 == rand4 || rand3 == rand5 || rand3 == rand6) rand3 = random(30);
            if (rand4 == rand1 || rand4 == rand2 || rand4 == rand3 || rand4 == rand5 || rand4 == rand6) rand4 = random(30);
            if (rand5 == rand1 || rand5 == rand2 || rand5 == rand3 || rand5 == rand4 || rand5 == rand6) rand5 = random(30);
            if (rand6 == rand1 || rand6 == rand2 || rand6 == rand3 || rand6 == rand4 || rand6 == rand5) rand6 = random(30);

            if (rand1 == rand2 || rand1 == rand3 || rand1 == rand4 || rand1 == rand5 || rand1 == rand6) rand1 = random(30);
            if (rand2 == rand1 || rand2 == rand3 || rand2 == rand4 || rand2 == rand5 || rand2 == rand6) rand2 = random(30);
            if (rand3 == rand1 || rand3 == rand2 || rand3 == rand4 || rand3 == rand5 || rand3 == rand6) rand3 = random(30);
            if (rand4 == rand1 || rand4 == rand2 || rand4 == rand3 || rand4 == rand5 || rand4 == rand6) rand4 = random(30);
            if (rand5 == rand1 || rand5 == rand2 || rand5 == rand3 || rand5 == rand4 || rand5 == rand6) rand5 = random(30);
            if (rand6 == rand1 || rand6 == rand2 || rand6 == rand3 || rand6 == rand4 || rand6 == rand5) rand6 = random(30);

            if (rand1 == rand2 || rand1 == rand3 || rand1 == rand4 || rand1 == rand5 || rand1 == rand6) rand1 = random(30);
            if (rand2 == rand1 || rand2 == rand3 || rand2 == rand4 || rand2 == rand5 || rand2 == rand6) rand2 = random(30);
            if (rand3 == rand1 || rand3 == rand2 || rand3 == rand4 || rand3 == rand5 || rand3 == rand6) rand3 = random(30);
            if (rand4 == rand1 || rand4 == rand2 || rand4 == rand3 || rand4 == rand5 || rand4 == rand6) rand4 = random(30);
            if (rand5 == rand1 || rand5 == rand2 || rand5 == rand3 || rand5 == rand4 || rand5 == rand6) rand5 = random(30);
            if (rand6 == rand1 || rand6 == rand2 || rand6 == rand3 || rand6 == rand4 || rand6 == rand5) rand6 = random(30);

            if (GetPVarInt(playerid, "MineType") >= 1) MineBomb[playerid][rand1] = 1;
            if (GetPVarInt(playerid, "MineType") >= 3) {
                MineBomb[playerid][rand2] = 1;
                MineBomb[playerid][rand3] = 1;
            }
            if (GetPVarInt(playerid, "MineType") == 6) {
                MineBomb[playerid][rand4] = 1;
                MineBomb[playerid][rand5] = 1;
                MineBomb[playerid][rand6] = 1;
            }

            SetPVarInt(playerid, "StartedGame", 1);
            PlayerTextDrawSetString(playerid, CasinoPTD[30], "Jocul a inceput!");
            PlayerTextDrawShow(playerid, CasinoPTD[30]);
        }
    }

    if (clickedid == Text:INVALID_TEXT_DRAW) {
        if (GetPVarInt(playerid, "PlayMine") == 1 || GetPVarInt(playerid, "StartedGame") == 1) SelectTextDraw(playerid, 0x80FF00FF);
    }
    return 1;
}

hook OnPlayerSpawn(playerid) {
    HideCasinoTDs(playerid);
    return 1;
}

stock cmd_minesweeper(playerid) {
    //if( !IsPlayerInRangeOfPoint( playerid, 100.0, 2016.1156,1017.1541,996.875 ) ) return SendClientMessage( playerid, -1, "Nu esti la casino!" );	
    if (GetPVarInt(playerid, "PlayMine") == 1) return 1;
    ShowCasinoTDs(playerid);
    SetPVarInt(playerid, "PlayMine", 1);
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 31) return 1;
    cmd_minesweeper(playerid);
    return ~1;
}

stock Msw_FormatNumber(fNum) {
    new Str[15];
    format(Str, 15, "%d", fNum);
    if (strlen(Str) < sizeof(Str)) {
        if (fNum >= 1000 && fNum < 10000) strins(Str, ",", 1, sizeof(Str));
        else if (fNum >= 10000 && fNum < 100000) strins(Str, ",", 2, sizeof(Str));
        else if (fNum >= 100000 && fNum < 1000000) strins(Str, ",", 3, sizeof(Str));
        else if (fNum >= 1000000 && fNum < 10000000) strins(Str, ",", 1, sizeof(Str)), strins(Str, ",", 5, sizeof(Str));
        else if (fNum >= 10000000 && fNum < 100000000) strins(Str, ",", 2, sizeof(Str)), strins(Str, ",", 6, sizeof(Str));
        else if (fNum >= 100000000 && fNum < 1000000000) strins(Str, ",", 3, sizeof(Str)), strins(Str, ",", 7, sizeof(Str));
        else if (fNum >= 1000000000 && fNum < 10000000000)
            strins(Str, ",", 1, sizeof(Str)),
            strins(Str, ",", 5, sizeof(Str)),
            strins(Str, ",", 9, sizeof(Str));
        else format(Str, 10, "%d", fNum);
    }
    return Str;
}

forward ShowMine(playerid);
public ShowMine(playerid) {
    if (GetPVarInt(playerid, "StartedGame") == 1) {
        ShowCasinoTDs(playerid);
        PlayerTextDrawSetString(playerid, CasinoPTD[31], "Played times: ~g~0~w~~h~~n~Money earned: ~g~0");
    }
    return 1;
}

forward ShowCasinoTDs(playerid);
public ShowCasinoTDs(playerid) {
    ResetColorTD(playerid);
    PlayerTextDrawSetString(playerid, CasinoPTD[32], "Enter bet amount");
    TextDrawColor(CasinoTD[9], -1);
    TextDrawColor(CasinoTD[7], -1);
    TextDrawColor(CasinoTD[12], -1);
    for (new i = 0; i < 33; i++) PlayerTextDrawShow(playerid, CasinoPTD[i]);
    for (new i = 0; i < 15; i++) TextDrawShowForPlayer(playerid, CasinoTD[i]);
    PlayerTextDrawHide(playerid, CasinoPTD[30]);
    SelectTextDraw(playerid, 0x80FF00FF);
    SetPVarInt(playerid, "MoneyEarned", 0);
    SetPVarInt(playerid, "Mines", 0);
    SetPVarInt(playerid, "MineType", 0);
    SetPVarInt(playerid, "BetAmount", 0);
    SetPVarInt(playerid, "StartedGame", 0);
    SetPVarInt(playerid, "Loser", 0);
    for (new i = 0; i < 30; i++) MineActive[playerid][i] = 0;
    return 1;
}

forward ResetColorTD(playerid);
public ResetColorTD(playerid) {
    for (new i = 0; i < 33; i++) {
        PlayerTextDrawBoxColor(playerid, CasinoPTD[i], -123);
        PlayerTextDrawShow(playerid, CasinoPTD[i]);
    }
    return 1;
}

forward HideCasinoTDs(playerid);
public HideCasinoTDs(playerid) {
    for (new i = 0; i < 33; i++) PlayerTextDrawHide(playerid, CasinoPTD[i]);
    for (new i = 0; i < 15; i++) TextDrawHideForPlayer(playerid, CasinoTD[i]);
    CancelSelectTextDraw(playerid);
    SetPVarInt(playerid, "PlayMine", 0);
    SetPVarInt(playerid, "BetAmount", 0);
    SetPVarInt(playerid, "Mines", 0);
    SetPVarInt(playerid, "StartedGame", 0);
    SetPVarInt(playerid, "MineType", 0);
    return 1;
}

forward GlobalTextDraw();
public GlobalTextDraw() {
    CasinoTD[0] = TextDrawCreate(156.666671, 160.962982, "box");
    TextDrawLetterSize(CasinoTD[0], 0.000000, 19.700004);
    TextDrawTextSize(CasinoTD[0], 461.000000, 0.000000);
    TextDrawAlignment(CasinoTD[0], 1);
    TextDrawColor(CasinoTD[0], -1);
    TextDrawUseBox(CasinoTD[0], 1);
    TextDrawBoxColor(CasinoTD[0], 103);
    TextDrawSetShadow(CasinoTD[0], 0);
    TextDrawSetOutline(CasinoTD[0], 0);
    TextDrawBackgroundColor(CasinoTD[0], 255);
    TextDrawFont(CasinoTD[0], 1);
    TextDrawSetProportional(CasinoTD[0], 1);
    TextDrawSetShadow(CasinoTD[0], 0);

    CasinoTD[1] = TextDrawCreate(155.000000, 159.303726, "box");
    TextDrawLetterSize(CasinoTD[1], 0.000000, 20.094011);
    TextDrawTextSize(CasinoTD[1], 462.949951, 0.000000);
    TextDrawAlignment(CasinoTD[1], 1);
    TextDrawColor(CasinoTD[1], -1);
    TextDrawUseBox(CasinoTD[1], 1);
    TextDrawBoxColor(CasinoTD[1], 103);
    TextDrawSetShadow(CasinoTD[1], 0);
    TextDrawSetOutline(CasinoTD[1], 0);
    TextDrawBackgroundColor(CasinoTD[1], 255);
    TextDrawFont(CasinoTD[1], 1);
    TextDrawSetProportional(CasinoTD[1], 1);
    TextDrawSetShadow(CasinoTD[1], 0);

    CasinoTD[2] = TextDrawCreate(170.000061, 182.948135, "box");
    TextDrawLetterSize(CasinoTD[2], 0.000000, 15.033333);
    TextDrawTextSize(CasinoTD[2], 275.000000, 0.000000);
    TextDrawAlignment(CasinoTD[2], 1);
    TextDrawColor(CasinoTD[2], -1);
    TextDrawUseBox(CasinoTD[2], 1);
    TextDrawBoxColor(CasinoTD[2], 100);
    TextDrawSetShadow(CasinoTD[2], 0);
    TextDrawSetOutline(CasinoTD[2], 0);
    TextDrawBackgroundColor(CasinoTD[2], 255);
    TextDrawFont(CasinoTD[2], 1);
    TextDrawSetProportional(CasinoTD[2], 1);
    TextDrawSetShadow(CasinoTD[2], 0);

    CasinoTD[3] = TextDrawCreate(308.000061, 146.444427, "Casino - Mine Sweeper");
    TextDrawLetterSize(CasinoTD[3], 0.463999, 1.828148);
    TextDrawAlignment(CasinoTD[3], 2);
    TextDrawColor(CasinoTD[3], -1);
    TextDrawSetShadow(CasinoTD[3], 0);
    TextDrawSetOutline(CasinoTD[3], 1);
    TextDrawBackgroundColor(CasinoTD[3], 82);
    TextDrawFont(CasinoTD[3], 0);
    TextDrawSetProportional(CasinoTD[3], 1);
    TextDrawSetShadow(CasinoTD[3], 0);

    CasinoTD[4] = TextDrawCreate(457.333343, 153.755554, "LD_BEAT:cross");
    TextDrawLetterSize(CasinoTD[4], 0.000000, 0.000000);
    TextDrawTextSize(CasinoTD[4], 11.000000, 13.000000);
    TextDrawAlignment(CasinoTD[4], 1);
    TextDrawColor(CasinoTD[4], -1);
    TextDrawSetShadow(CasinoTD[4], 0);
    TextDrawSetOutline(CasinoTD[4], 0);
    TextDrawBackgroundColor(CasinoTD[4], 255);
    TextDrawFont(CasinoTD[4], 4);
    TextDrawSetProportional(CasinoTD[4], 0);
    TextDrawSetShadow(CasinoTD[4], 0);
    TextDrawSetSelectable(CasinoTD[4], true);

    CasinoTD[5] = TextDrawCreate(366.666748, 263.007293, "Start game");
    TextDrawLetterSize(CasinoTD[5], 0.363999, 1.562666);
    TextDrawTextSize(CasinoTD[5], 15.000000, 105.000000);
    TextDrawAlignment(CasinoTD[5], 2);
    TextDrawColor(CasinoTD[5], -1);
    TextDrawUseBox(CasinoTD[5], 1);
    TextDrawBoxColor(CasinoTD[5], 16711935);
    TextDrawSetShadow(CasinoTD[5], 0);
    TextDrawSetOutline(CasinoTD[5], 1);
    TextDrawBackgroundColor(CasinoTD[5], 255);
    TextDrawFont(CasinoTD[5], 2);
    TextDrawSetProportional(CasinoTD[5], 1);
    TextDrawSetShadow(CasinoTD[5], 0);
    TextDrawSetSelectable(CasinoTD[5], true);

    CasinoTD[6] = TextDrawCreate(366.666748, 285.822204, "Cash out");
    TextDrawLetterSize(CasinoTD[6], 0.363999, 1.562666);
    TextDrawTextSize(CasinoTD[6], 15.000000, 105.000000);
    TextDrawAlignment(CasinoTD[6], 2);
    TextDrawColor(CasinoTD[6], -1);
    TextDrawUseBox(CasinoTD[6], 1);
    TextDrawBoxColor(CasinoTD[6], -16776961);
    TextDrawSetShadow(CasinoTD[6], 0);
    TextDrawSetOutline(CasinoTD[6], 1);
    TextDrawBackgroundColor(CasinoTD[6], 255);
    TextDrawFont(CasinoTD[6], 2);
    TextDrawSetProportional(CasinoTD[6], 1);
    TextDrawSetShadow(CasinoTD[6], 0);
    TextDrawSetSelectable(CasinoTD[6], true);

    CasinoTD[7] = TextDrawCreate(350.666534, 194.562988, "3x");
    TextDrawLetterSize(CasinoTD[7], 0.400000, 1.600000);
    TextDrawTextSize(CasinoTD[7], 368.000000, 15.000000);
    TextDrawAlignment(CasinoTD[7], 1);
    TextDrawColor(CasinoTD[7], -1);
    TextDrawSetShadow(CasinoTD[7], 0);
    TextDrawSetOutline(CasinoTD[7], 1);
    TextDrawBackgroundColor(CasinoTD[7], 255);
    TextDrawFont(CasinoTD[7], 1);
    TextDrawSetProportional(CasinoTD[7], 1);
    TextDrawSetShadow(CasinoTD[7], 0);
    TextDrawSetSelectable(CasinoTD[7], true);

    CasinoTD[8] = TextDrawCreate(315.666931, 192.074050, "box");
    TextDrawLetterSize(CasinoTD[8], 0.000000, 1.866665);
    TextDrawTextSize(CasinoTD[8], 418.000000, 0.000000);
    TextDrawAlignment(CasinoTD[8], 1);
    TextDrawColor(CasinoTD[8], -1);
    TextDrawUseBox(CasinoTD[8], 1);
    TextDrawBoxColor(CasinoTD[8], -233);
    TextDrawSetShadow(CasinoTD[8], 0);
    TextDrawSetOutline(CasinoTD[8], 0);
    TextDrawBackgroundColor(CasinoTD[8], 255);
    TextDrawFont(CasinoTD[8], 1);
    TextDrawSetProportional(CasinoTD[8], 1);
    TextDrawSetShadow(CasinoTD[8], 0);

    CasinoTD[9] = TextDrawCreate(316.999969, 194.562942, "1x");
    TextDrawLetterSize(CasinoTD[9], 0.400000, 1.600000);
    TextDrawTextSize(CasinoTD[9], 350.000000, 15.000000);
    TextDrawAlignment(CasinoTD[9], 1);
    TextDrawColor(CasinoTD[9], -1);
    TextDrawSetShadow(CasinoTD[9], 0);
    TextDrawSetOutline(CasinoTD[9], 1);
    TextDrawBackgroundColor(CasinoTD[9], 255);
    TextDrawFont(CasinoTD[9], 1);
    TextDrawSetProportional(CasinoTD[9], 1);
    TextDrawSetShadow(CasinoTD[9], 0);
    TextDrawSetSelectable(CasinoTD[9], true);

    CasinoTD[10] = TextDrawCreate(302.666717, 167.859405, "");
    TextDrawLetterSize(CasinoTD[10], 0.000000, 0.000000);
    TextDrawTextSize(CasinoTD[10], 89.000000, 68.000000);
    TextDrawAlignment(CasinoTD[10], 1);
    TextDrawColor(CasinoTD[10], -1);
    TextDrawSetShadow(CasinoTD[10], 0);
    TextDrawSetOutline(CasinoTD[10], 0);
    TextDrawBackgroundColor(CasinoTD[10], 0);
    TextDrawFont(CasinoTD[10], 5);
    TextDrawSetProportional(CasinoTD[10], 0);
    TextDrawSetShadow(CasinoTD[10], 0);
    TextDrawSetPreviewModel(CasinoTD[10], 342);
    TextDrawSetPreviewRot(CasinoTD[10], 0.000000, 0.000000, 0.000000, 1.000000);

    CasinoTD[11] = TextDrawCreate(338.333312, 167.444595, "");
    TextDrawLetterSize(CasinoTD[11], 0.000000, 0.000000);
    TextDrawTextSize(CasinoTD[11], 89.000000, 68.000000);
    TextDrawAlignment(CasinoTD[11], 1);
    TextDrawColor(CasinoTD[11], -1);
    TextDrawSetShadow(CasinoTD[11], 0);
    TextDrawSetOutline(CasinoTD[11], 0);
    TextDrawBackgroundColor(CasinoTD[11], 0);
    TextDrawFont(CasinoTD[11], 5);
    TextDrawSetProportional(CasinoTD[11], 0);
    TextDrawSetShadow(CasinoTD[11], 0);
    TextDrawSetPreviewModel(CasinoTD[11], 342);
    TextDrawSetPreviewRot(CasinoTD[11], 0.000000, 0.000000, 0.000000, 1.000000);

    CasinoTD[12] = TextDrawCreate(385.333190, 194.562988, "6x");
    TextDrawLetterSize(CasinoTD[12], 0.400000, 1.600000);
    TextDrawTextSize(CasinoTD[12], 400.000000, 15.000000);
    TextDrawAlignment(CasinoTD[12], 1);
    TextDrawColor(CasinoTD[12], -1);
    TextDrawSetShadow(CasinoTD[12], 0);
    TextDrawSetOutline(CasinoTD[12], 1);
    TextDrawBackgroundColor(CasinoTD[12], 255);
    TextDrawFont(CasinoTD[12], 1);
    TextDrawSetProportional(CasinoTD[12], 1);
    TextDrawSetShadow(CasinoTD[12], 0);
    TextDrawSetSelectable(CasinoTD[12], true);

    CasinoTD[13] = TextDrawCreate(372.000030, 167.444610, "");
    TextDrawLetterSize(CasinoTD[13], 0.000000, 0.000000);
    TextDrawTextSize(CasinoTD[13], 89.000000, 68.000000);
    TextDrawAlignment(CasinoTD[13], 1);
    TextDrawColor(CasinoTD[13], -1);
    TextDrawSetShadow(CasinoTD[13], 0);
    TextDrawSetOutline(CasinoTD[13], 0);
    TextDrawBackgroundColor(CasinoTD[13], 0);
    TextDrawFont(CasinoTD[13], 5);
    TextDrawSetProportional(CasinoTD[13], 0);
    TextDrawSetShadow(CasinoTD[13], 0);
    TextDrawSetPreviewModel(CasinoTD[13], 342);
    TextDrawSetPreviewRot(CasinoTD[13], 0.000000, 0.000000, 0.000000, 1.000000);

    CasinoTD[14] = TextDrawCreate(315.666931, 214.059249, "box");
    TextDrawLetterSize(CasinoTD[14], 0.000000, 1.866665);
    TextDrawTextSize(CasinoTD[14], 418.000000, 0.000000);
    TextDrawAlignment(CasinoTD[14], 1);
    TextDrawColor(CasinoTD[14], -1);
    TextDrawUseBox(CasinoTD[14], 1);
    TextDrawBoxColor(CasinoTD[14], -233);
    TextDrawSetShadow(CasinoTD[14], 0);
    TextDrawSetOutline(CasinoTD[14], 0);
    TextDrawBackgroundColor(CasinoTD[14], 255);
    TextDrawFont(CasinoTD[14], 1);
    TextDrawSetProportional(CasinoTD[14], 1);
    TextDrawSetShadow(CasinoTD[14], 0);
    return 1;
}

forward PlayerTextDraw(playerid);
public PlayerTextDraw(playerid) {
    CasinoPTD[0] = CreatePlayerTextDraw(playerid, 183.333343, 190.000000, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[0], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[0], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[0], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[0], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[0], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[0], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[0], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[0], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[0], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[0], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[0], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[0], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[0], true);

    CasinoPTD[1] = CreatePlayerTextDraw(playerid, 202.666671, 190.000000, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[1], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[1], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[1], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[1], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[1], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[1], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[1], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[1], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[1], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[1], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[1], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[1], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[1], true);

    CasinoPTD[2] = CreatePlayerTextDraw(playerid, 222.333419, 190.000000, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[2], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[2], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[2], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[2], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[2], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[2], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[2], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[2], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[2], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[2], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[2], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[2], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[2], true);

    CasinoPTD[3] = CreatePlayerTextDraw(playerid, 242.333480, 190.000030, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[3], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[3], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[3], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[3], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[3], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[3], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[3], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[3], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[3], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[3], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[3], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[3], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[3], true);

    CasinoPTD[4] = CreatePlayerTextDraw(playerid, 261.333465, 190.000030, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[4], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[4], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[4], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[4], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[4], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[4], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[4], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[4], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[4], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[4], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[4], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[4], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[4], true);

    CasinoPTD[5] = CreatePlayerTextDraw(playerid, 183.333450, 211.985229, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[5], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[5], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[5], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[5], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[5], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[5], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[5], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[5], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[5], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[5], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[5], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[5], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[5], true);

    CasinoPTD[6] = CreatePlayerTextDraw(playerid, 202.666793, 211.570388, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[6], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[6], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[6], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[6], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[6], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[6], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[6], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[6], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[6], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[6], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[6], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[6], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[6], true);

    CasinoPTD[7] = CreatePlayerTextDraw(playerid, 222.333465, 211.570373, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[7], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[7], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[7], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[7], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[7], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[7], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[7], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[7], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[7], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[7], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[7], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[7], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[7], true);

    CasinoPTD[8] = CreatePlayerTextDraw(playerid, 242.333480, 211.570388, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[8], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[8], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[8], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[8], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[8], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[8], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[8], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[8], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[8], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[8], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[8], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[8], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[8], true);

    CasinoPTD[9] = CreatePlayerTextDraw(playerid, 261.666778, 211.570388, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[9], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[9], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[9], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[9], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[9], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[9], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[9], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[9], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[9], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[9], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[9], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[9], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[9], true);

    CasinoPTD[10] = CreatePlayerTextDraw(playerid, 183.333435, 233.555557, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[10], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[10], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[10], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[10], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[10], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[10], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[10], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[10], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[10], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[10], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[10], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[10], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[10], true);

    CasinoPTD[11] = CreatePlayerTextDraw(playerid, 202.666763, 233.555557, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[11], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[11], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[11], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[11], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[11], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[11], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[11], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[11], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[11], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[11], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[11], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[11], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[11], true);

    CasinoPTD[12] = CreatePlayerTextDraw(playerid, 222.333419, 233.555572, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[12], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[12], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[12], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[12], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[12], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[12], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[12], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[12], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[12], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[12], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[12], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[12], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[12], true);

    CasinoPTD[13] = CreatePlayerTextDraw(playerid, 242.333404, 233.555572, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[13], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[13], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[13], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[13], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[13], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[13], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[13], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[13], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[13], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[13], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[13], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[13], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[13], true);

    CasinoPTD[14] = CreatePlayerTextDraw(playerid, 261.333435, 233.555572, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[14], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[14], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[14], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[14], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[14], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[14], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[14], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[14], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[14], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[14], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[14], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[14], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[14], true);

    CasinoPTD[15] = CreatePlayerTextDraw(playerid, 183.333419, 255.125930, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[15], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[15], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[15], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[15], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[15], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[15], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[15], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[15], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[15], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[15], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[15], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[15], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[15], true);

    CasinoPTD[16] = CreatePlayerTextDraw(playerid, 203.000091, 255.125930, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[16], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[16], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[16], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[16], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[16], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[16], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[16], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[16], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[16], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[16], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[16], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[16], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[16], true);

    CasinoPTD[17] = CreatePlayerTextDraw(playerid, 222.333450, 255.125930, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[17], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[17], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[17], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[17], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[17], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[17], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[17], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[17], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[17], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[17], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[17], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[17], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[17], true);

    CasinoPTD[18] = CreatePlayerTextDraw(playerid, 242.333450, 255.125930, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[18], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[18], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[18], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[18], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[18], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[18], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[18], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[18], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[18], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[18], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[18], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[18], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[18], true);

    CasinoPTD[19] = CreatePlayerTextDraw(playerid, 261.000122, 255.125930, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[19], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[19], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[19], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[19], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[19], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[19], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[19], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[19], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[19], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[19], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[19], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[19], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[19], true);

    CasinoPTD[20] = CreatePlayerTextDraw(playerid, 183.333480, 276.281433, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[20], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[20], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[20], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[20], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[20], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[20], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[20], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[20], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[20], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[20], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[20], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[20], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[20], true);

    CasinoPTD[21] = CreatePlayerTextDraw(playerid, 203.333465, 276.281433, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[21], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[21], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[21], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[21], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[21], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[21], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[21], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[21], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[21], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[21], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[21], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[21], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[21], true);

    CasinoPTD[22] = CreatePlayerTextDraw(playerid, 222.666793, 276.696228, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[22], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[22], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[22], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[22], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[22], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[22], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[22], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[22], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[22], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[22], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[22], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[22], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[22], true);

    CasinoPTD[23] = CreatePlayerTextDraw(playerid, 242.333465, 276.696228, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[23], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[23], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[23], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[23], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[23], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[23], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[23], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[23], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[23], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[23], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[23], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[23], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[23], true);

    CasinoPTD[24] = CreatePlayerTextDraw(playerid, 261.333404, 276.696228, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[24], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[24], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[24], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[24], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[24], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[24], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[24], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[24], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[24], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[24], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[24], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[24], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[24], true);

    CasinoPTD[25] = CreatePlayerTextDraw(playerid, 183.333404, 297.436981, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[25], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[25], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[25], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[25], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[25], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[25], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[25], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[25], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[25], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[25], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[25], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[25], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[25], true);

    CasinoPTD[26] = CreatePlayerTextDraw(playerid, 203.666656, 297.436981, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[26], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[26], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[26], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[26], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[26], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[26], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[26], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[26], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[26], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[26], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[26], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[26], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[26], true);

    CasinoPTD[27] = CreatePlayerTextDraw(playerid, 222.666671, 297.436981, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[27], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[27], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[27], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[27], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[27], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[27], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[27], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[27], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[27], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[27], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[27], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[27], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[27], true);

    CasinoPTD[28] = CreatePlayerTextDraw(playerid, 242.333282, 297.436981, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[28], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[28], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[28], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[28], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[28], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[28], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[28], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[28], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[28], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[28], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[28], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[28], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[28], true);

    CasinoPTD[29] = CreatePlayerTextDraw(playerid, 261.333282, 297.436950, "box");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[29], 0.000000, 1.633334);
    PlayerTextDrawTextSize(playerid, CasinoPTD[29], 15.000000, 13.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[29], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[29], -1);
    PlayerTextDrawUseBox(playerid, CasinoPTD[29], 1);
    PlayerTextDrawBoxColor(playerid, CasinoPTD[29], -123);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[29], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[29], 0);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[29], 255);
    PlayerTextDrawFont(playerid, CasinoPTD[29], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[29], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[29], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[29], true);

    CasinoPTD[30] = CreatePlayerTextDraw(playerid, 367.000061, 312.785186, "~r~Ai pierdut! :( ");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[30], 0.254666, 1.085628);
    PlayerTextDrawAlignment(playerid, CasinoPTD[30], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[30], -1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[30], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[30], 1);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[30], 136);
    PlayerTextDrawFont(playerid, CasinoPTD[30], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[30], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[30], 0);

    CasinoPTD[31] = CreatePlayerTextDraw(playerid, 366.666961, 236.044342, "Played times: 0~n~Money earned: ~g~$0~w~~h~~n~");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[31], 0.254666, 1.085628);
    PlayerTextDrawAlignment(playerid, CasinoPTD[31], 2);
    PlayerTextDrawColor(playerid, CasinoPTD[31], -1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[31], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[31], 1);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[31], 136);
    PlayerTextDrawFont(playerid, CasinoPTD[31], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[31], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[31], 0);

    CasinoPTD[32] = CreatePlayerTextDraw(playerid, 318.999969, 217.377777, "Enter bet amount");
    PlayerTextDrawLetterSize(playerid, CasinoPTD[32], 0.252000, 1.098074);
    PlayerTextDrawTextSize(playerid, CasinoPTD[32], 396.000000, 10.000000);
    PlayerTextDrawAlignment(playerid, CasinoPTD[32], 1);
    PlayerTextDrawColor(playerid, CasinoPTD[32], -1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[32], 0);
    PlayerTextDrawSetOutline(playerid, CasinoPTD[32], 1);
    PlayerTextDrawBackgroundColor(playerid, CasinoPTD[32], 122);
    PlayerTextDrawFont(playerid, CasinoPTD[32], 1);
    PlayerTextDrawSetProportional(playerid, CasinoPTD[32], 1);
    PlayerTextDrawSetShadow(playerid, CasinoPTD[32], 0);
    PlayerTextDrawSetSelectable(playerid, CasinoPTD[32], true);
    return 1;
}

forward Msw_ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5);
public Msw_ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5) {
    new Float:posx, Float:posy, Float:posz;
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    foreach(new i:Player) {
        if (GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
            GetPlayerPos(i, posx, posy, posz);
            tempposx = (oldposx - posx);
            tempposy = (oldposy - posy);
            tempposz = (oldposz - posz);
            if (((tempposx < radi / 16) && (tempposx > -radi / 16)) && ((tempposy < radi / 16) && (tempposy > -radi / 16)) && ((tempposz < radi / 16) && (tempposz > -radi / 16)))
                SendClientMessage(i, col1, string);
            else if (((tempposx < radi / 8) && (tempposx > -radi / 8)) && ((tempposy < radi / 8) && (tempposy > -radi / 8)) && ((tempposz < radi / 8) && (tempposz > -radi / 8)))
                SendClientMessage(i, col2, string);
            else if (((tempposx < radi / 4) && (tempposx > -radi / 4)) && ((tempposy < radi / 4) && (tempposy > -radi / 4)) && ((tempposz < radi / 4) && (tempposz > -radi / 4)))
                SendClientMessage(i, col3, string);
            else if (((tempposx < radi / 2) && (tempposx > -radi / 2)) && ((tempposy < radi / 2) && (tempposy > -radi / 2)) && ((tempposz < radi / 2) && (tempposz > -radi / 2)))
                SendClientMessage(i, col4, string);
            else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                SendClientMessage(i, col5, string);
        }
    }
    return 1;
}