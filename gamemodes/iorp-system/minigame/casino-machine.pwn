new machinecasino_info, machinecasino_bet, machinecasino_exit;
new PlayerText:machinecasino_casino[MAX_PLAYERS][25];
new machinecasino_PlayerWin[MAX_PLAYERS],
    machinecasino_GameOwer[MAX_PLAYERS],
    machinecasino_Mode[MAX_PLAYERS] = 1,
    machinecasino_InGame[MAX_PLAYERS] = 0,
    machinecasino_clicked_td[MAX_PLAYERS][25],
    machinecasino_Money_Win[MAX_PLAYERS];

stock info_casino(playerid) {
    new mes[1000];
    strcat(mes, "{FFFFFF}System description\n");
    strcat(mes, "The system has 3 game modes:\n");
    strcat(mes, "1. The player has 3 margin for error, after the third mistake the game ends, he loses everything.\n");
    strcat(mes, "Possible prizes:(10%, 25%, 50%, 100%).\n");
    strcat(mes, "2. The player has no margin for error, if he does not guess, then he loses everything.\n");
    strcat(mes, "Prizes increased:(25%, 50%, 75%, 150%).\n");
    strcat(mes, "3. A player can open all the cells, no lives, but the prizes will be equal to $10 for each loss\n");
    strcat(mes, "and the chances of getting the maximum prize are much less, the chances of losing are increased\n");
    strcat(mes, "Prizes:(5% 10% 25% 50%) \n");
    strcat(mes, "C you was grod I hope you enjoy\n");
    strcat(mes, "This is the budget version (ie) free, and not the one that is sold...\n");
    ShowPlayerDialogEx(playerid, machinecasino_info, 0, 0, "{FF6F00}INFORMATION", mes, "ok", "");
    return 1;
}


hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    td_casino(playerid);
    return 1;
}

hook OnGameModeInit() {
    machinecasino_info = Dialog:GetFreeID();
    machinecasino_bet = Dialog:GetFreeID();
    machinecasino_exit = Dialog:GetFreeID();
    CreateDynamicObject(2754, 2019.0671400, 1003.2670900, 10.5988300, 0.0000000, 0.0000000, 178.7791900);
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (playertextid == machinecasino_casino[playerid][4]) {
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        info_casino(playerid);
    }
    if (playertextid == machinecasino_casino[playerid][8]) {
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        ShowPlayerDialogEx(playerid, machinecasino_bet, 0, 1, "Setting a bet for the game:", "The rate must be at least $100\nand no more than $3000. Enter the amount of the bid..", "Further", "Cancel");
        return true;
    }
    if (playertextid == machinecasino_casino[playerid][9]) {
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        if (machinecasino_InGame[playerid] == 1) return ShowPlayerDialogEx(playerid, machinecasino_info, 0, 0, "{FF6F00}FOOL", "During the game you can not change the Mode.", "ok", "");
        new string[25];
        machinecasino_Mode[playerid] += 1;
        if (machinecasino_Mode[playerid] > 3) {
            machinecasino_Mode[playerid] = 1;
        }
        format(string, sizeof(string), "Mode:~y~%d", machinecasino_Mode[playerid]);
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][7], string);
    }
    if (playertextid >= machinecasino_casino[playerid][13] && playertextid <= machinecasino_casino[playerid][24]) {
        if (machinecasino_Money_Win[playerid] == 0) return ShowPlayerDialogEx(playerid, machinecasino_info, 0, 0, "{FF6F00}FOOL", "First bet [BET]", "ok", "");
        new clicked;
        for (new t = 25; t-- != 13;) {
            if (playertextid == machinecasino_casino[playerid][t])
                clicked = t;
        }
        if (machinecasino_clicked_td[playerid][clicked])
            return true;
        machinecasino_InGame[playerid] = 1;
        PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
        new ran;
        ran = random(2);
        switch (ran) {
            case 0 :  {
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][clicked], "LD_CHAT:thumbup");
                PlayerWins(playerid);
            }
            case 1 :  {
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][clicked], "LD_CHAT:thumbdn");
                GameOwers(playerid);
            }
        }
        machinecasino_clicked_td[playerid][clicked] = 1;
    }
    if (playertextid == machinecasino_casino[playerid][10]) {
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        if (machinecasino_Money_Win[playerid] == 0) return ShowPlayerDialogEx(playerid, machinecasino_info, 0, 0, "{FF6F00}win", "You didn't win anything.", "ok", "");
        new string[15];
        format(string, sizeof(string), "~g~+$%s", FormatCurrency(machinecasino_Money_Win[playerid]));
        GameTextForPlayer(playerid, string, 3000, 6);
        vault:PlayerVault(playerid, machinecasino_Money_Win[playerid], "Casino Machine:winning money", Vault_ID_Government, -machinecasino_Money_Win[playerid], sprintf("%s Casino Machine:winning money", GetPlayerNameEx(playerid)));
        machinecasino_Money_Win[playerid] = 0;
        machinecasino_PlayerWin[playerid] = 0;
        machinecasino_InGame[playerid] = 0;
        format(string, sizeof(string), "BET:~y~0");
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][5], string);
        format(string, sizeof(string), "WIN:~y~%d", machinecasino_Money_Win[playerid]);
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
        PlayerTextDrawShow(playerid, machinecasino_casino[playerid][12]);
        for (new t = 13; t < 25; t++) PlayerTextDrawHide(playerid, machinecasino_casino[playerid][t]);
        PlayerPlaySound(playerid, 43001, 0.0, 0.0, 0.0);
    }
    if (playertextid == machinecasino_casino[playerid][11]) {
        if (machinecasino_Money_Win[playerid] > 0) return ShowPlayerDialogEx(playerid, machinecasino_exit, 0, 0, "{FFFFFF}A warning", "{FF0000}You have a bet, if you exit now, it will disappear\n\
		{FFFF00}Do you really want to leave the game?", "Yes", "No");
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        for (new x; x < 25; x++) PlayerTextDrawHide(playerid, machinecasino_casino[playerid][x]);
        CancelSelectTextDraw(playerid);
        machinecasino_Money_Win[playerid] = 0;
        machinecasino_PlayerWin[playerid] = 0;
        machinecasino_InGame[playerid] = 0;
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid == machinecasino_bet) {
        if (!response) return 1;
        if (strval(inputtext) < 100 || strval(inputtext) > 3000) return SendClientMessageEx(playerid, 0xAFAFAFAA, "Invalid bid");
        vault:PlayerVault(playerid, -strval(inputtext), "casino machine: charged for bid", Vault_ID_Government, strval(inputtext), sprintf("%s casino machine: charged for bid", GetPlayerNameEx(playerid)));
        machinecasino_Money_Win[playerid] += SetPVarInt(playerid, "w_m", strval(inputtext) / 100);
        new string[25];
        format(string, sizeof(string), "BET: ~y~%d", strval(inputtext));
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][5], string);
        PlayerTextDrawHide(playerid, machinecasino_casino[playerid][12]);
        for (new t = 13; t < 25; t++) {
            if (t < 25) machinecasino_clicked_td[playerid][t] = 0;
            PlayerTextDrawShow(playerid, machinecasino_casino[playerid][t]);
            PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][t], "LD_BEAT:cring");
        }
    }
    if (dialogid == machinecasino_exit) {
        if (!response) return 1;
        PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
        for (new x; x < 25; x++) PlayerTextDrawHide(playerid, machinecasino_casino[playerid][x]);
        CancelSelectTextDraw(playerid);
        machinecasino_Money_Win[playerid] = 0;
        machinecasino_PlayerWin[playerid] = 0;
        machinecasino_InGame[playerid] = 0;
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}
forward PlayerWins(playerid);
public PlayerWins(playerid) {
    new string[25];
    machinecasino_PlayerWin[playerid]++;
    switch (machinecasino_Mode[playerid]) {
        case 1 :  {
            switch (machinecasino_PlayerWin[playerid]) {
                case 1, 2:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 10;
                case 3:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 25;
                case 4:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 50;
                case 5..12:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 100;
            }
        }
        case 2 :  {
            switch (machinecasino_PlayerWin[playerid]) {
                case 1, 2:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 25;
                case 3:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 50;
                case 4:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 75;
                case 5..12:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 150;
            }
        }
        case 3 :  {
            switch (machinecasino_PlayerWin[playerid]) {
                case 1, 2:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 5;
                case 3:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 10;
                case 4:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 25;
                case 5..12:
                    machinecasino_Money_Win[playerid] += GetPVarInt(playerid, "w_m") * 50;
            }
        }
    }
    format(string, sizeof(string), "WIN: ~y~%d", machinecasino_Money_Win[playerid]);
    PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
    return 1;
}
forward GameOwers(playerid);
public GameOwers(playerid) {
    new string[25];
    machinecasino_GameOwer[playerid]++;
    switch (machinecasino_Mode[playerid]) {
        case 1 :  {
            if (machinecasino_GameOwer[playerid] >= 3) {

                machinecasino_Money_Win[playerid] = 0;
                machinecasino_PlayerWin[playerid] = 0;
                format(string, sizeof(string), "BET: ~y~0");
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][5], string);
                format(string, sizeof(string), "WIN: ~y~%d", machinecasino_Money_Win[playerid]);
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
                machinecasino_GameOwer[playerid] = 0;
                machinecasino_InGame[playerid] = 0;
                GameTextForPlayer(playerid, "~r~Game Over", 3000, 6);
                for (new t = 13; t < 25; t++) PlayerTextDrawHide(playerid, machinecasino_casino[playerid][t]);
                PlayerTextDrawShow(playerid, machinecasino_casino[playerid][12]);
                PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
            }
        }
        case 2 :  {
            if (machinecasino_GameOwer[playerid] >= 1) {

                machinecasino_Money_Win[playerid] = 0;
                machinecasino_PlayerWin[playerid] = 0;
                format(string, sizeof(string), "BET: ~y~0");
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][5], string);
                format(string, sizeof(string), "WIN: ~y~%d", machinecasino_Money_Win[playerid]);
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
                machinecasino_GameOwer[playerid] = 0;
                machinecasino_InGame[playerid] = 0;
                GameTextForPlayer(playerid, "~r~Game Over", 3000, 6);
                for (new t = 13; t < 25; t++) PlayerTextDrawHide(playerid, machinecasino_casino[playerid][t]);
                PlayerTextDrawShow(playerid, machinecasino_casino[playerid][12]);
                PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
            }
        }
        case 3 :  {
            if (machinecasino_GameOwer[playerid] >= 1) {

                machinecasino_Money_Win[playerid] = 10;
                machinecasino_GameOwer[playerid] = 0;
                format(string, sizeof(string), "WIN: ~y~%d", machinecasino_Money_Win[playerid]);
                PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
            }
        }
    }
    return 1;
}
stock td_casino(playerid) {
    machinecasino_casino[playerid][0] = CreatePlayerTextDraw(playerid, 217.999969, 171.733337, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][0], 200.333343, 225.659332);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][0], 1);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][0], 0xF6BD79AA);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][0], 0);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][0], 4);

    machinecasino_casino[playerid][1] = CreatePlayerTextDraw(playerid, 420.333343, 209.737030, "usebox");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][1], 0.000000, 0.052055);
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][1], 216.666671, 0.000000);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][1], 1);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][1], 0);
    PlayerTextDrawUseBox(playerid, machinecasino_casino[playerid][1], true);
    PlayerTextDrawBoxColor(playerid, machinecasino_casino[playerid][1], 102);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][1], 0);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][1], 0);

    machinecasino_casino[playerid][2] = CreatePlayerTextDraw(playerid, 420.333343, 369.440582, "usebox");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][2], 0.000000, 0.052055);
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][2], 216.666610, 0.000000);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][2], 1);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][2], 0);
    PlayerTextDrawUseBox(playerid, machinecasino_casino[playerid][2], true);
    PlayerTextDrawBoxColor(playerid, machinecasino_casino[playerid][2], 102);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][2], 0);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][2], 0);

    machinecasino_casino[playerid][3] = CreatePlayerTextDraw(playerid, 259.333343, 172.818511, "usebox");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][3], 0.000000, 3.739300);
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][3], 216.666671, 0.000000);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][3], 1);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][3], 0);
    PlayerTextDrawUseBox(playerid, machinecasino_casino[playerid][3], true);
    PlayerTextDrawBoxColor(playerid, machinecasino_casino[playerid][3], 102);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][3], 0);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][3], 0);

    machinecasino_casino[playerid][4] = CreatePlayerTextDraw(playerid, 218.333343, 172.148147, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][4], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][4], 38.000000, 35.259262);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][4], 1);
    PlayerTextDrawBackgroundColor(playerid, machinecasino_casino[playerid][4], 0xFFFFFF00);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][4], 0);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][4], 5);
    PlayerTextDrawSetSelectable(playerid, machinecasino_casino[playerid][4], true);
    PlayerTextDrawSetPreviewModel(playerid, machinecasino_casino[playerid][4], 1239);
    PlayerTextDrawSetPreviewRot(playerid, machinecasino_casino[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);

    machinecasino_casino[playerid][5] = CreatePlayerTextDraw(playerid, 263.666625, 173.392593, "bet: ~y~0$");
    machinecasino_casino[playerid][6] = CreatePlayerTextDraw(playerid, 263.666625, 189.985183, "win: ~y~0$");
    machinecasino_casino[playerid][7] = CreatePlayerTextDraw(playerid, 362.333312, 191.229629, "Mode: ~y~1");
    for (new i = 5; i < 8; i++) {
        PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][i], 0.337332, 1.508741);
        PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][i], 1);
        PlayerTextDrawColor(playerid, machinecasino_casino[playerid][i], -1);
        PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][i], 0);
        PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][i], 1);
        PlayerTextDrawBackgroundColor(playerid, machinecasino_casino[playerid][i], 51);
        PlayerTextDrawFont(playerid, machinecasino_casino[playerid][i], 2);
        PlayerTextDrawSetProportional(playerid, machinecasino_casino[playerid][i], 1);
    }
    machinecasino_casino[playerid][8] = CreatePlayerTextDraw(playerid, 226.999923, 377.481414, "bet");
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][8], 252.666656, 24.474069);
    machinecasino_casino[playerid][9] = CreatePlayerTextDraw(playerid, 263.333374, 377.481414, "Mode");
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][9], 301.000000, 15.348150);
    machinecasino_casino[playerid][10] = CreatePlayerTextDraw(playerid, 309.333374, 377.481445, "take win");
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][10], 374.000061, 8.711110);
    machinecasino_casino[playerid][11] = CreatePlayerTextDraw(playerid, 381.000091, 377.481414, "exit");
    PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][11], 412.333587, 8.711111);
    for (new x = 8; x < 12; x++) {
        PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][x], 0.306665, 1.512889);
        PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][x], 1);
        PlayerTextDrawColor(playerid, machinecasino_casino[playerid][x], -1);
        PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][x], 0);
        PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][x], 1);
        PlayerTextDrawBackgroundColor(playerid, machinecasino_casino[playerid][x], 51);
        PlayerTextDrawFont(playerid, machinecasino_casino[playerid][x], 2);
        PlayerTextDrawSetProportional(playerid, machinecasino_casino[playerid][x], 1);
        PlayerTextDrawSetSelectable(playerid, machinecasino_casino[playerid][x], true);
    }
    machinecasino_casino[playerid][12] = CreatePlayerTextDraw(playerid, 227.333236, 233.955368, "\tPLACE A BET~n~\t\t\t\t\tTO~n~START THE GAME");
    PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][12], 0.664333, 4.258965);
    PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][12], 1);
    PlayerTextDrawColor(playerid, machinecasino_casino[playerid][12], -1);
    PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][12], 0);
    PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][12], 1);
    PlayerTextDrawBackgroundColor(playerid, machinecasino_casino[playerid][12], 51);
    PlayerTextDrawFont(playerid, machinecasino_casino[playerid][12], 1);
    PlayerTextDrawSetProportional(playerid, machinecasino_casino[playerid][12], 1);
    machinecasino_casino[playerid][13] = CreatePlayerTextDraw(playerid, 234.000000, 229.370376, "LD_BEAT:cring");
    machinecasino_casino[playerid][14] = CreatePlayerTextDraw(playerid, 281.333343, 229.370376, "LD_BEAT:cring");
    machinecasino_casino[playerid][15] = CreatePlayerTextDraw(playerid, 326.333435, 228.370376, "LD_BEAT:cring");
    machinecasino_casino[playerid][16] = CreatePlayerTextDraw(playerid, 370.333526, 228.148117, "LD_BEAT:cring");

    machinecasino_casino[playerid][17] = CreatePlayerTextDraw(playerid, 234.000000, 275.437072, "LD_BEAT:cring");
    machinecasino_casino[playerid][18] = CreatePlayerTextDraw(playerid, 281.333343, 275.437072, "LD_BEAT:cring");
    machinecasino_casino[playerid][19] = CreatePlayerTextDraw(playerid, 326.333435, 275.437072, "LD_BEAT:cring");
    machinecasino_casino[playerid][20] = CreatePlayerTextDraw(playerid, 370.333526, 275.437072, "LD_BEAT:cring");

    machinecasino_casino[playerid][21] = CreatePlayerTextDraw(playerid, 234.000000, 321.481628, "LD_BEAT:cring");
    machinecasino_casino[playerid][22] = CreatePlayerTextDraw(playerid, 281.333343, 318.481628, "LD_BEAT:cring");
    machinecasino_casino[playerid][23] = CreatePlayerTextDraw(playerid, 326.333435, 318.481628, "LD_BEAT:cring");
    machinecasino_casino[playerid][24] = CreatePlayerTextDraw(playerid, 370.333526, 317.481628, "LD_BEAT:cring");
    for (new x = 13; x < 25; x++) {
        PlayerTextDrawLetterSize(playerid, machinecasino_casino[playerid][x], 0.000000, 0.000000);
        PlayerTextDrawTextSize(playerid, machinecasino_casino[playerid][x], 31.333358, 33.600006);
        PlayerTextDrawAlignment(playerid, machinecasino_casino[playerid][x], 1);
        PlayerTextDrawColor(playerid, machinecasino_casino[playerid][x], -1);
        PlayerTextDrawSetShadow(playerid, machinecasino_casino[playerid][x], 0);
        PlayerTextDrawSetOutline(playerid, machinecasino_casino[playerid][x], 0);
        PlayerTextDrawFont(playerid, machinecasino_casino[playerid][x], 4);
        PlayerTextDrawSetSelectable(playerid, machinecasino_casino[playerid][x], true);
    }
    return 1;
}

stock casinoplay_cmd(playerid) {
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 2020.2573, 1003.2549, 10.8203)) {
        SetPlayerCameraPos(playerid, 2020.461059, 1003.224975, 11.354500);
        SetPlayerCameraLookAt(playerid, 2015.511840, 1003.381774, 10.661425);
        new string[15];
        format(string, sizeof(string), "BET: ~y~0");
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][5], string);
        format(string, sizeof(string), "WIN: ~y~0", machinecasino_Money_Win[playerid]);
        PlayerTextDrawSetString(playerid, machinecasino_casino[playerid][6], string);
        for (new x = 0; x < 13; x++) PlayerTextDrawShow(playerid, machinecasino_casino[playerid][x]);
        SelectTextDraw(playerid, 0xF68879AA);
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 2020.2573, 1003.2549, 10.8203)) UCP:AddCommand(playerid, "Use Casino Machine", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Use Casino Machine", inputtext)) casinoplay_cmd(playerid);
    return 1;
}