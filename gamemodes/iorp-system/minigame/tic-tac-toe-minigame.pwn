#define ttt_winning_price 100
new ticbox[MAX_PLAYERS][9];
new PlayerText:TickTD[MAX_PLAYERS][17];
new TickOP[MAX_PLAYERS];
new TickType[MAX_PLAYERS];
new TickTurn[MAX_PLAYERS];
new TickRound[MAX_PLAYERS];
new TickWon[MAX_PLAYERS];

hook OnGameModeInit() {
    foreach(new p:Player) {
        if (IsPlayerConnected(p)) CreateTicTD(p);
    }
    return 1;
}

hook OnGameModeExit() {
    foreach(new p:Player) {
        if (IsPlayerConnected(p)) {
            for (new x = 0; x < 17; x++) PlayerTextDrawDestroy(p, TickTD[p][x]);
        }
    }
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    CreateTicTD(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    for (new x = 0; x < 17; x++) PlayerTextDrawDestroy(playerid, TickTD[playerid][x]);
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (_:playertextid != INVALID_TEXT_DRAW) {
        for (new x = 6; x < 15; x++) {
            if (playertextid == TickTD[playerid][x]) {
                if (TickTurn[playerid] == 0) SendClientMessageEx(playerid, -1, "Its not your turn");
                else if (ticbox[playerid][x - 6] != 0) SendClientMessageEx(playerid, -1, "You cant draw in this box");
                else tickbox(playerid, x - 6);
                break;
            }
        }
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (_:clickedid == INVALID_TEXT_DRAW) {
        if (GetPVarInt(playerid, "InTic")) TogglePlayerControllable(playerid, 0), SelectTextDraw(playerid, 0xFFFFFFFF);
    }
    return 1;
}

forward nexttic(pplayer1, pplayer2);
public nexttic(pplayer1, pplayer2) {
    if (TickRound[pplayer1] >= 3) {
        TogglePlayerControllable(pplayer1, 1);
        TogglePlayerControllable(pplayer2, 1);
        for (new x = 0; x < 17; x++) {
            PlayerTextDrawHide(pplayer1, TickTD[pplayer1][x]);
            PlayerTextDrawHide(pplayer2, TickTD[pplayer2][x]);
        }
        TickTurn[pplayer1] = 0;
        TickTurn[pplayer2] = 0;
        DeletePVar(pplayer1, "InTic");
        DeletePVar(pplayer2, "InTic");
        CancelSelectTextDraw(pplayer1);
        CancelSelectTextDraw(pplayer2);
        if (TickWon[pplayer1] > TickWon[pplayer2]) {
            new string[256];
            format(string, sizeof(string), " {A62CF2}-TTT-{492CF2} %s has beaten %s in the Tic-Tac-Toe game!", GetPlayerNameEx(pplayer1), GetPlayerNameEx(pplayer2));
            SendClientMessageToAll(-1, string);
            GivePlayerCash(pplayer1, ttt_winning_price, "win in tic tac toe");
            GivePlayerCash(pplayer2, -1 * ttt_winning_price, "loss in tic tac toe");

        } else if (TickWon[pplayer2] > TickWon[pplayer1]) {
            new string[256];
            format(string, sizeof(string), " {A62CF2}-TTT-{492CF2} %s has beaten %s in the Tic-Tac-Toe game!", GetPlayerNameEx(pplayer2), GetPlayerNameEx(pplayer1));
            SendClientMessageToAll(-1, string);
            GivePlayerCash(pplayer2, ttt_winning_price, "win in tic tac toe");
            GivePlayerCash(pplayer1, -1 * ttt_winning_price, "loss in tic tac toe");
        }
    } else {
        for (new x = 0; x < 9; x++) ticbox[pplayer1][x] = 0, ticbox[pplayer2][x] = 0;
        TogglePlayerControllable(pplayer1, 0);
        TogglePlayerControllable(pplayer2, 0);
        TickOP[pplayer1] = pplayer2;
        TickOP[pplayer2] = pplayer1;
        TickType[pplayer1] = 1;
        TickType[pplayer2] = 2;
        for (new x = 0; x < 17; x++) {
            PlayerTextDrawShow(pplayer1, TickTD[pplayer1][x]);
            PlayerTextDrawShow(pplayer2, TickTD[pplayer2][x]);
            if (x >= 6 && x <= 14) {
                PlayerTextDrawSetString(pplayer1, TickTD[pplayer1][x], "_");
                PlayerTextDrawSetString(pplayer2, TickTD[pplayer2][x], "_");
            }
        }
        PlayerTextDrawSetString(pplayer1, TickTD[pplayer1][15], "~g~Your Turn");
        PlayerTextDrawSetString(pplayer2, TickTD[pplayer2][15], "~p~Opponent's Turn");

        TickTurn[pplayer2] = 0;
        TickTurn[pplayer1] = 1;
        SelectTextDraw(pplayer1, 0xFFFFFFFF);
        SelectTextDraw(pplayer2, 0xFFFFFFFF);
    }
}

stock starttictac(pplayer1, pplayer2) {
    for (new x = 0; x < 9; x++) ticbox[pplayer1][x] = 0, ticbox[pplayer2][x] = 0;
    TogglePlayerControllable(pplayer1, 0);
    TogglePlayerControllable(pplayer2, 0);
    TickOP[pplayer1] = pplayer2;
    TickOP[pplayer2] = pplayer1;
    TickType[pplayer1] = 1;
    TickType[pplayer2] = 2;
    for (new x = 0; x < 17; x++) {
        PlayerTextDrawShow(pplayer1, TickTD[pplayer1][x]);
        PlayerTextDrawShow(pplayer2, TickTD[pplayer2][x]);
        if (x >= 6 && x <= 14) {
            PlayerTextDrawSetString(pplayer1, TickTD[pplayer1][x], "_");
            PlayerTextDrawSetString(pplayer2, TickTD[pplayer2][x], "_");
        }
    }
    PlayerTextDrawSetString(pplayer1, TickTD[pplayer1][15], "~g~Your Turn");
    PlayerTextDrawSetString(pplayer2, TickTD[pplayer2][15], "~p~Opponent's Turn");
    PlayerTextDrawSetString(pplayer2, TickTD[pplayer2][16], "Round I~n~~n~0:0");
    PlayerTextDrawSetString(pplayer1, TickTD[pplayer1][16], "Round I~n~~n~0:0");

    TickTurn[pplayer2] = 0;
    TickTurn[pplayer1] = 1;
    SelectTextDraw(pplayer1, 0xFFFFFFFF);
    SelectTextDraw(pplayer2, 0xFFFFFFFF);

    TickRound[pplayer1] = 0;
    TickRound[pplayer2] = 0;
    TickWon[pplayer1] = 0;
    TickWon[pplayer2] = 0;
    return 1;
}
stock tickbox(playerid, boxid) {
    TickTurn[playerid] = 0;
    TickTurn[TickOP[playerid]] = 1;
    PlayerTextDrawSetString(TickOP[playerid], TickTD[playerid][15], "~g~Your Turn");
    PlayerTextDrawSetString(playerid, TickTD[playerid][15], "~p~Opponent's Turn");
    new m = TickType[playerid];
    if (m == 1) {
        PlayerTextDrawSetString(playerid, TickTD[playerid][boxid + 6], "~y~X"), PlayerTextDrawSetString(TickOP[playerid], TickTD[playerid][boxid + 6], "~y~X");
        ticbox[playerid][boxid] = 1;
        ticbox[TickOP[playerid]][boxid] = 1;
        PlayerPlaySound(playerid, 1101, 0, 0, 0);
        PlayerPlaySound(TickOP[playerid], 1101, 0, 0, 0);
    } else {
        PlayerTextDrawSetString(playerid, TickTD[playerid][boxid + 6], "~y~O"), PlayerTextDrawSetString(TickOP[playerid], TickTD[playerid][boxid + 6], "~y~O");
        ticbox[playerid][boxid] = 2;
        ticbox[TickOP[playerid]][boxid] = 2;
        PlayerPlaySound(playerid, 1101, 0, 0, 0);
        PlayerPlaySound(TickOP[playerid], 1101, 0, 0, 0);
    }
    if ((ticbox[playerid][0] == m && ticbox[playerid][1] == m && ticbox[playerid][2] == m) ||
        (ticbox[playerid][3] == m && ticbox[playerid][4] == m && ticbox[playerid][5] == m) ||
        (ticbox[playerid][6] == m && ticbox[playerid][7] == m && ticbox[playerid][8] == m) ||
        (ticbox[playerid][0] == m && ticbox[playerid][4] == m && ticbox[playerid][8] == m) ||
        (ticbox[playerid][2] == m && ticbox[playerid][4] == m && ticbox[playerid][6] == m) ||
        (ticbox[playerid][0] == m && ticbox[playerid][3] == m && ticbox[playerid][6] == m) ||
        (ticbox[playerid][1] == m && ticbox[playerid][4] == m && ticbox[playerid][7] == m) ||
        (ticbox[playerid][2] == m && ticbox[playerid][5] == m && ticbox[playerid][8] == m)) {
        TickTurn[playerid] = 0;
        TickTurn[TickOP[playerid]] = 0;
        SendClientMessageEx(playerid, -1, "You Won");
        SendClientMessageEx(TickOP[playerid], -1, "You Lost");
        TickRound[playerid]++;
        TickRound[TickOP[playerid]]++;
        TickWon[playerid]++;
        SetTimerEx("nexttic", 3000, false, "dd", playerid, TickOP[playerid]);
        PlayerPlaySound(playerid, 31205, 0, 0, 0);
        PlayerPlaySound(TickOP[playerid], 31202, 0, 0, 0);
    } else {
        new a;
        for (new x = 0; x < 9; x++)
            if (ticbox[playerid][x] > 0) a++;
        if (a >= 9) {
            TickTurn[playerid] = 0;
            TickTurn[TickOP[playerid]] = 0;
            TickRound[playerid]++;
            TickRound[TickOP[playerid]]++;
            SetTimerEx("nexttic", 3000, false, "dd", playerid, TickOP[playerid]);
            SendClientMessageEx(playerid, -1, "Draw");
            SendClientMessageEx(TickOP[playerid], -1, "Draw");
        }
    }
    new string[50];
    if (TickRound[playerid] == 1) format(string, sizeof(string), "Round I~n~~n~%d:%d", TickWon[playerid], TickWon[TickOP[playerid]]);
    else if (TickRound[playerid] == 2) format(string, sizeof(string), "Round II~n~~n~%d:%d", TickWon[playerid], TickWon[TickOP[playerid]]);
    else format(string, sizeof(string), "Round III~n~~n~%d:%d", TickWon[playerid], TickWon[TickOP[playerid]]);
    PlayerTextDrawSetString(playerid, TickTD[playerid][16], string);
    return 1;
}
stock CreateTicTD(playerid) {
    TickTD[playerid][0] = CreatePlayerTextDraw(playerid, 190.000000, 151.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][0], 15.000000, 16.899999);
    PlayerTextDrawColor(playerid, TickTD[playerid][0], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][0], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][0], 150);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][0], 401.000000, 81.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][0], 0);

    TickTD[playerid][1] = CreatePlayerTextDraw(playerid, 189.000000, 237.000000, "-");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][1], 15.000000, 1.799998);
    PlayerTextDrawColor(playerid, TickTD[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][1], 0);

    TickTD[playerid][2] = CreatePlayerTextDraw(playerid, 269.000000, 168.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][2], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][2], 0.500000, 13.299997);
    PlayerTextDrawColor(playerid, TickTD[playerid][2], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][2], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][2], -1);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][2], 262.000000, 132.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][2], 0);

    TickTD[playerid][3] = CreatePlayerTextDraw(playerid, 330.500000, 168.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][3], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][3], 0.500000, 13.299997);
    PlayerTextDrawColor(playerid, TickTD[playerid][3], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][3], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][3], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][3], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][3], -1);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][3], 327.000000, 133.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][3], 0);

    TickTD[playerid][4] = CreatePlayerTextDraw(playerid, 231.000000, 141.000000, "~r~Tic-Tac-Toe");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][4], 3);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][4], 0.589999, 1.700000);
    PlayerTextDrawColor(playerid, TickTD[playerid][4], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][4], 0);

    TickTD[playerid][5] = CreatePlayerTextDraw(playerid, 189.000000, 187.000000, "-");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][5], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][5], 15.000000, 1.799998);
    PlayerTextDrawColor(playerid, TickTD[playerid][5], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][5], 0);

    TickTD[playerid][6] = CreatePlayerTextDraw(playerid, 226.000000, 167.000000, "~y~X");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][6], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][6], 0.829999, 3.099998);
    PlayerTextDrawColor(playerid, TickTD[playerid][6], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][6], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][6], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][6], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][6], 248.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][6], 1);

    TickTD[playerid][7] = CreatePlayerTextDraw(playerid, 283.000000, 167.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][7], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][7], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][7], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][7], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][7], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][7], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][7], 318.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][7], 1);

    TickTD[playerid][8] = CreatePlayerTextDraw(playerid, 344.000000, 167.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][8], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][8], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][8], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][8], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][8], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][8], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][8], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][8], 391.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][8], 1);

    TickTD[playerid][9] = CreatePlayerTextDraw(playerid, 224.000000, 212.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][9], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][9], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][9], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][9], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][9], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][9], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][9], 259.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][9], 1);

    TickTD[playerid][10] = CreatePlayerTextDraw(playerid, 284.000000, 212.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][10], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][10], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][10], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][10], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][10], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][10], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][10], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][10], 314.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][10], 1);

    TickTD[playerid][11] = CreatePlayerTextDraw(playerid, 345.000000, 212.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][11], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][11], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][11], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][11], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][11], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][11], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][11], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][11], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][11], 383.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][11], 1);

    TickTD[playerid][12] = CreatePlayerTextDraw(playerid, 225.000000, 258.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][12], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][12], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][12], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][12], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][12], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][12], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][12], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][12], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][12], 262.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][12], 1);

    TickTD[playerid][13] = CreatePlayerTextDraw(playerid, 284.000000, 258.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][13], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][13], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][13], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][13], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][13], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][13], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][13], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][13], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][13], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][13], 322.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][13], 1);

    TickTD[playerid][14] = CreatePlayerTextDraw(playerid, 345.000000, 259.000000, "~y~O");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][14], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][14], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][14], 0.829999, 3.099997);
    PlayerTextDrawColor(playerid, TickTD[playerid][14], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][14], 0);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, TickTD[playerid][14], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][14], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][14], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][14], 391.000000, 26.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][14], 1);

    TickTD[playerid][15] = CreatePlayerTextDraw(playerid, 268.000000, 309.000000, "~p~Your Turn");
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][15], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][15], 0.349999, 1.299998);
    PlayerTextDrawColor(playerid, TickTD[playerid][15], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][15], 0);

    TickTD[playerid][15] = CreatePlayerTextDraw(playerid, 296.000000, 309.000000, "~p~Your Turn");
    PlayerTextDrawAlignment(playerid, TickTD[playerid][15], 2);
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][15], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][15], 0.349999, 1.299998);
    PlayerTextDrawColor(playerid, TickTD[playerid][15], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][15], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][15], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][15], 0.000000, 113.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][15], 0);

    TickTD[playerid][16] = CreatePlayerTextDraw(playerid, 296.000000, 326.000000, "Round I~n~~n~1:1");
    PlayerTextDrawAlignment(playerid, TickTD[playerid][16], 2);
    PlayerTextDrawBackgroundColor(playerid, TickTD[playerid][16], 255);
    PlayerTextDrawFont(playerid, TickTD[playerid][16], 1);
    PlayerTextDrawLetterSize(playerid, TickTD[playerid][16], 0.250000, 0.699997);
    PlayerTextDrawColor(playerid, TickTD[playerid][16], -1);
    PlayerTextDrawSetOutline(playerid, TickTD[playerid][16], 1);
    PlayerTextDrawSetProportional(playerid, TickTD[playerid][16], 1);
    PlayerTextDrawUseBox(playerid, TickTD[playerid][16], 1);
    PlayerTextDrawBoxColor(playerid, TickTD[playerid][16], 0);
    PlayerTextDrawTextSize(playerid, TickTD[playerid][16], 0.000000, 113.000000);
    PlayerTextDrawSetSelectable(playerid, TickTD[playerid][16], 0);
    return 1;
}

stock ShowTicTacToeMenu(playerid) {
    new string[512];
    if (GetPVarInt(playerid, "TikInvited")) strcat(string, "Accept Invitation of TTT\n");
    if (GetPVarInt(playerid, "InTic")) strcat(string, "Leave Game TTT\n");
    strcat(string, "Play Tic Tac Toe\n");
    return FlexPlayerDialog(playerid, "ShowTicTacToeMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}Tic Tac Toe", string, "Select", "Close");
}

FlexDialog:ShowTicTacToeMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Play Tic Tac Toe")) return TicTacToeInviteMenu(playerid);
    if (IsStringSame(inputtext, "Accept Invitation of TTT")) {
        if (!GetPVarInt(playerid, "TikInvited")) {
            AlexaMsg(playerid, " -Warning- You have not been invited for a Tic-Tac-Toe challenge!", "Alexa", "E60000");
            return ShowTicTacToeMenu(playerid);
        }
        new a = GetPVarInt(playerid, "TikChallenge");
        SendClientMessageToAll(-1, sprintf(" {A62CF2}-TTT-{492CF2} %s is playing Tic-Tac-Toe against %s", GetPlayerNameEx(playerid), GetPlayerNameEx(a)));
        starttictac(playerid, a);
        DeletePVar(playerid, "TikChallenge");
        DeletePVar(playerid, "TikInvited");
        SetPVarInt(playerid, "InTic", true);
        SetPVarInt(a, "InTic", true);
        TickRound[playerid] = 1;
        TickRound[a] = 1;
        return 1;
    }
    if (IsStringSame(inputtext, "Leave Game TTT")) {
        if (GetPVarInt(playerid, "InTic")) {
            DeletePVar(playerid, "InTic");
            DeletePVar(TickOP[playerid], "InTic");
            TogglePlayerControllable(playerid, 1);
            TogglePlayerControllable(TickOP[playerid], 1);
            for (new x = 0; x < 17; x++) {
                PlayerTextDrawHide(playerid, TickTD[playerid][x]);
                PlayerTextDrawHide(TickOP[playerid], TickTD[TickOP[playerid]][x]);
            }
            TickTurn[playerid] = 0;
            TickTurn[TickOP[playerid]] = 0;
            CancelSelectTextDraw(playerid);
            CancelSelectTextDraw(TickOP[playerid]);
            SendClientMessageEx(TickOP[playerid], -1, "Your opponent has quit the game!");
            if (TickRound[playerid] > 1 && TickWon[TickOP[playerid]] > TickWon[playerid]) {
                GivePlayerCash(TickOP[playerid], ttt_winning_price, "win in tic tac toe");
                GivePlayerCash(playerid, -1 * ttt_winning_price, "loss in tic tac toe");
            }
        }
        return ShowTicTacToeMenu(playerid);
    }
    return 1;
}

stock TicTacToeInviteMenu(playerid) {
    return FlexPlayerDialog(playerid, "TicTacToeInviteMenu", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFEE}Tic Tac Toe", "Enter [PlayerID]", "Submit", "Close");
}

FlexDialog:TicTacToeInviteMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowTicTacToeMenu(playerid);
    new friendid;
    if (sscanf(inputtext, "u", friendid)) return TicTacToeInviteMenu(playerid);
    SendClientMessageEx(friendid, -1, sprintf(" {A62CF2}-TTT-{492CF2} %s is challenging you in a Tic-Tac-Toe game! Type (/Accept) to play against him!", GetPlayerNameEx(playerid)));
    SendClientMessageEx(playerid, -1, " {A62CF2}-TTT-{492CF2} Invitation sent");
    SetPVarInt(friendid, "TikInvited", true);
    SetPVarInt(friendid, "TikChallenge", playerid);
    ShowTicTacToeMenu(friendid);
    return ShowTicTacToeMenu(playerid);
}