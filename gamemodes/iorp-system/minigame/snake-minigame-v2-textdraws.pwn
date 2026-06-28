#define SNAKE_KEY_KEYACTION_L 0
#define SNAKE_KEY_KEYACTION_R 1
#define SNAKE_KEY_KEYACTION_D 2
#define SNAKE_KEY_KEYACTION_U 3
#define SNAKE_KEY_KEYACTION_X 4


#define MAX_SNAKE_SCORE_PAGESIZE 15
#define MAX_SNAKE_SCORE_QUERYLEN 1000
#define MIN_SNAKE_SCORE_PAGE 0
#define MAX_SNAKE_SCORE_PAGE 2147483646 // max 32 bit integer value - 1

#define SNAKE_SCORE_COL_RANK 0
#define SNAKE_SCORE_COL_PLAYER 1
#define SNAKE_SCORE_COL_SIZE 2
#define SNAKE_SCORE_COL_KILLS 3
#define SNAKE_SCORE_COL_TIMEDATE 4

#define MAX_SNAKE_SCORE_COLUMNS 5
enum SnakeGame:EnumTdDataPlayerScoreCol { // Columns
    PlayerText:SnakeGame:Td_SCORE_COL_RANK,
    PlayerText:SnakeGame:Td_SCORE_COL_PLAYER,
    PlayerText:SnakeGame:Td_SCORE_COL_SIZE,
    PlayerText:SnakeGame:Td_SCORE_COL_KILLS,
    PlayerText:SnakeGame:Td_SCORE_COL_TIMEDATE
}

#define MAX_SNAKE_SCORE_PTEXTDRAWS 7
enum SnakeGame:EnumTdDataPlayerScore { // Player Textdraws
    PlayerText:SnakeGame:Td_SCORE_PTD_PAGE, // Page
    PlayerText:SnakeGame:Td_SCORE_PTD_COL[SnakeGame:EnumTdDataPlayerScoreCol], // Columns
    PlayerText:SnakeGame:Td_SCORE_PTD_RANK[MAX_SNAKE_SCORE_PAGESIZE], // Rank Row
    PlayerText:SnakeGame:Td_SCORE_PTD_PLAYER[MAX_SNAKE_SCORE_PAGESIZE], // Player Row
    PlayerText:SnakeGame:Td_SCORE_PTD_SIZE[MAX_SNAKE_SCORE_PAGESIZE], // Size Row
    PlayerText:SnakeGame:Td_SCORE_PTD_KILLS[MAX_SNAKE_SCORE_PAGESIZE], // Kill Rows
    PlayerText:SnakeGame:Td_SCORE_PTD_TIMEDATE[MAX_SNAKE_SCORE_PAGESIZE] // Time & Date Rows

}
new PlayerText:SnakeGame:TextDrawDataPlayerScore[MAX_PLAYERS][SnakeGame:EnumTdDataPlayerScore];

stock SnakeGame:CreatePlayerTextdrawScore(playerid) {
    SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE] = CreatePlayerTextDraw(playerid, 320.0, 105.0, "page");
    PlayerTextDrawAlignment(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 2);
    PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 255);
    PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 2);
    PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 0.2, 1.1);
    PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], -1);
    PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 1);
    PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE], 1);

    for (new col, Float:x, Float:x_size, str[11 + 1], bool:selectable; col < MAX_SNAKE_SCORE_COLUMNS; col++) {
        switch (col) {
            case SNAKE_SCORE_COL_RANK:  {
                x = 140.0, x_size = 230.0, str = "Rank", selectable = false;
            }
            case SNAKE_SCORE_COL_PLAYER:  {
                x = 234.0, x_size = 350.0, str = "Player", selectable = true;
            }
            case SNAKE_SCORE_COL_SIZE:  {
                x = 354.0, x_size = 380.0, str = "Size", selectable = true;
            }
            case SNAKE_SCORE_COL_KILLS:  {
                x = 384.0, x_size = 410.0, str = "Kills", selectable = true;
            }
            case SNAKE_SCORE_COL_TIMEDATE:  {
                x = 414.0, x_size = 500.0, str = "Time & Date", selectable = true;
            }
            default:  {
                continue;
            }
        }

        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col] = CreatePlayerTextDraw(playerid, x, 122.0, str); // Column
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], RGBA_WHITE);
        PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], 0xFFFFFF32);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], x_size, 9.0);
        PlayerTextDrawSetSelectable(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col], selectable ? 1 : 0);
    }

    for (new row, Float:y = 135.0; row < MAX_SNAKE_SCORE_PAGESIZE; row++, y += 13.0) {
        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row] = CreatePlayerTextDraw(playerid, 140.0, y, "Rank"); // Rank Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 0);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], 230.0, 9.0);

        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row] = CreatePlayerTextDraw(playerid, 234.0, y, "Player"); // Player Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 0);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], 350.0, 9.0);

        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row] = CreatePlayerTextDraw(playerid, 354.0, y, "Size"); // Size Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 0);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], 380.0, 9.0);

        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row] = CreatePlayerTextDraw(playerid, 384.0, y, "Kills"); // Kills Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 0);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], 410.0, 9.0);

        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row] = CreatePlayerTextDraw(playerid, 414.0, y, "Time & Date"); // Time & Date Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 0);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], 500.0, 9.0);
    }
    return 1;
}

stock SnakeGame:DestroyPlayerTdScore(playerid) {
    PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE]);
    for (new col; col < MAX_SNAKE_SCORE_COLUMNS; col++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col]);
    }
    for (new row; row < MAX_SNAKE_SCORE_PAGESIZE; row++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row]);
    }
    return 1;
}

#define MAX_SNAKE_JOINGAME_PAGESIZE 15
#define MIN_SNAKE_JOINGAME_PAGE 0
#define MAX_SNAKE_JOINGAME_PAGE ((MAX_SNAKE_GAMES - 1) / MAX_SNAKE_JOINGAME_PAGESIZE)
#define MAX_SNAKE_JOINGAME_PBUTTONS (MAX_SNAKE_PLAYERS * MAX_SNAKE_JOINGAME_PAGESIZE)
#define MAX_SNAKE_JOINGAME_PTEXTDRAWS 3
enum SnakeGame:EnumTdDataPlayerJoin { // Player Textdraws
    PlayerText:SnakeGame:PlayerTdPAGE, // Current Page
    PlayerText:SnakeGame:PlayerTdGAMEROW[MAX_SNAKE_JOINGAME_PAGESIZE], // Game Row
    PlayerText:SnakeGame:PlayerTdPBUTTON[MAX_SNAKE_JOINGAME_PBUTTONS] // Player Button
}
new PlayerText:SnakeGame:TextDrawDataPlayerJoin[MAX_PLAYERS][SnakeGame:EnumTdDataPlayerJoin];

stock SnakeGame:CreatePlayerTextdrawJoin(playerid) {
    SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE] = CreatePlayerTextDraw(playerid, 320.0, 105.0, "page"); // Current Page Number
    PlayerTextDrawAlignment(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 2);
    PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 255);
    PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 2);
    PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 0.2, 1.1);
    PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], -1);
    PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 1);
    PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE], 1);

    for (new row, Float:y = 135.0; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++, y += 13.0) {
        SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row] = CreatePlayerTextDraw(playerid, 140.0, y, "Game ID"); // Game ID Row
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], -1);
        PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 0);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 0);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], -16777116);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], 180.0, 9.0);
    }

    for (new idx, col, row, Float:x, Float:y; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        x = 180.0 + (col * 80.0);

        y = 135.0 + (row * 13.0);

        SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx] = CreatePlayerTextDraw(playerid, x + 4.0, y, "Player"); // Player Button
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], SnakeGame:Colors[col]);
        PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 0);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 1);
        PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 0);
        PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], -16777116);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], x + 80.0, 9.0);
        PlayerTextDrawSetSelectable(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], 1);

        if (++col == MAX_SNAKE_PLAYERS) {
            row++, col = 0;
        }
    }
    return 1;
}

stock SnakeGame:ShowPlayerTextdrawJoin(playerid) {
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE]);
    for (new row; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++) {
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row]);
    }
    for (new idx; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
    }
    return 1;
}

stock SnakeGame:HidePlayerTextdrawJoin(playerid) {
    PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE]);
    for (new row; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row]);
    }
    for (new idx; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
    }
    return 1;
}

stock SnakeGame:DestroyPlayerTextdrawJoin(playerid) {
    PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE]);
    for (new row; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row]);
    }
    for (new idx; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
    }
    return 1;
}

#define MAX_SNAKE_KEY_KEYACTIONS 5
enum SnakeGame:EnumPlayerKeyActions { // Key + Action
    PlayerText:SnakeGame:KEY_KEYACTION_L, // Left
    PlayerText:SnakeGame:KEY_KEYACTION_R, // Right
    PlayerText:SnakeGame:KEY_KEYACTION_D, // Down
    PlayerText:SnakeGame:KEY_KEYACTION_U, // Up
    PlayerText:SnakeGame:KEY_KEYACTION_X // Close
}
new PlayerText:SnakeGame:TextDrawDataPlayerKeys[MAX_PLAYERS][SnakeGame:EnumPlayerKeyActions];

stock SnakeGame:CreatePlayerTextdrawKeys(playerid) {
    new bool:is_vehicle = bool:!!GetPlayerVehicleID(playerid);

    for (new key, Float:y = 142.0, str_key[100]; key < MAX_SNAKE_KEY_KEYACTIONS; key++, y += 13.0) {
        switch (key) {
            case SNAKE_KEY_KEYACTION_L:  { // Left
                str_key = is_vehicle ? ("~k~~VEHICLE_STEERLEFT~") : ("~k~~GO_LEFT~");
            }
            case SNAKE_KEY_KEYACTION_R:  { // Right
                str_key = is_vehicle ? ("~k~~VEHICLE_STEERRIGHT~") : ("~k~~GO_RIGHT~");
            }
            case SNAKE_KEY_KEYACTION_D:  { // Down
                str_key = is_vehicle ? ("~k~~VEHICLE_STEERDOWN~") : ("~k~~GO_BACK~");
            }
            case SNAKE_KEY_KEYACTION_U:  { // Up
                str_key = is_vehicle ? ("~k~~VEHICLE_STEERUP~") : ("~k~~GO_FORWARD~");
            }
            case SNAKE_KEY_KEYACTION_X:  { // Close
                str_key = is_vehicle ? ("~k~~VEHICLE_ENTER_EXIT~ + ~k~~VEHICLE_HORN~ + ~k~~VEHICLE_BRAKE~") : ("~k~~VEHICLE_ENTER_EXIT~ + ~k~~PED_DUCK~ + ~k~~PED_JUMPING~");
            }
            default:  {
                continue;
            }
        }

        SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key] = CreatePlayerTextDraw(playerid, 169.0, y, str_key);
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], -1);
        PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 0);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 1);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key], 318.0, 0.0);
    }
    return 1;
}

stock SnakeGame:ShowPlayerTextdrawKeys(playerid) {
    for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key]);
    }
    return 1;
}

stock SnakeGame:HidePlayerTextdrawKeys(playerid) {
    for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key]);
    }
    return 1;
}

stock SnakeGame:DestroyPlayerTextdrawKeys(playerid) {
    for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key]);
        SnakeGame:TextDrawDataPlayerKeys[playerid][SnakeGame:EnumPlayerKeyActions:key] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

#define MAX_SNAKE_GAME_PTD 6
enum SnakeGame:EnumTextDrawPlayerGame { // Player Textdraws
    PlayerText:SnakeGame:TD_PGAME_PTD_COUNTDOWN,
    PlayerText:SnakeGame:TD_PGAME_PTD_XKEYS,
    PlayerText:SnakeGame:TD_PGAME_PTD_PLAYER_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SnakeGame:TD_PGAME_PTD_SIZE_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SnakeGame:TD_PGAME_PTD_KILLS_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SnakeGame:TD_PGAME_PTD_ALIVE_ROW[MAX_SNAKE_PLAYERS]
}
new PlayerText:SnakeGame:TextDrawDataPlayerGame[MAX_PLAYERS][SnakeGame:EnumTextDrawPlayerGame];

stock SnakeGame:DestroyGameTextdraws(playerid) {
    PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN]);
    PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS]);
    for (new row; row < MAX_SNAKE_PLAYERS; row++) {
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row]);
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row]);
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row]);
        PlayerTextDrawDestroy(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row]);
    }
    return 1;
}

stock SnakeGame:ShowGameTextdraws(playerid) {
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN]);
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS]);
    for (new row; row < MAX_SNAKE_PLAYERS; row++) {
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row]);
    }
    return 1;
}

stock SnakeGame:HideGameTextdraws(playerid) {
    PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN]);
    PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS]);
    for (new row; row < MAX_SNAKE_PLAYERS; row++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row]);
    }
    return 1;
}

stock SnakeGame:CreateGameTextdraws(playerid) {
    SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN] = CreatePlayerTextDraw(playerid, 320.0, 49.0, "_");
    PlayerTextDrawAlignment(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 2);
    PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 255);
    PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 2);
    PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 0.4, 2.0);
    PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], -1);
    PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], -206);
    PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], 0.0, 270.0);

    new keystr[108 + 1];

    switch (GetPlayerState(playerid)) {
        case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:  {
            keystr = "~w~press ~r~~k~~VEHICLE_ENTER_EXIT~~w~ + ~r~~k~~VEHICLE_HORN~~w~ + ~r~~k~~VEHICLE_BRAKE~~w~ to stop playing.";
        }
        default:  {
            keystr = "~w~press ~r~~k~~VEHICLE_ENTER_EXIT~~w~ + ~r~~k~~PED_DUCK~~w~ + ~r~~k~~PED_JUMPING~~w~ to stop playing.";
        }
    }

    SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS] = CreatePlayerTextDraw(playerid, 320.0, 393.0, keystr);
    PlayerTextDrawAlignment(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 2);
    PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 255);
    PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 2);
    PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 0.2, 1.0);
    PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], -1);
    PlayerTextDrawSetOutline(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 1);
    PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 1);
    PlayerTextDrawUseBox(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 1);
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], -206);
    PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_XKEYS], 0.0, 270.0);

    for (new row, Float:y = 342.0; row < MAX_SNAKE_PLAYERS; row++, y += 13.0) {
        SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row] = CreatePlayerTextDraw(playerid, 185.0, y, "Player");
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], 365.0, 0.0);

        SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row] = CreatePlayerTextDraw(playerid, 368.0, y, "Size");
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], 395.0, 0.0);

        SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row] = CreatePlayerTextDraw(playerid, 398.0, y, "Kills");
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], 425.0, 0.0);

        SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row] = CreatePlayerTextDraw(playerid, 428.0, y, "Alive");
        PlayerTextDrawBackgroundColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 255);
        PlayerTextDrawFont(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], 455.0, 0.0);
    }
    return 1;
}

#define MAX_SNAKE_GAME_GTD 7
enum SnakeGame:EnumTextDrawGame { // Generic Textdraws
    Text:SnakeGame:TD_GAME_BG,
    Text:SnakeGame:TD_GAME_BLOCK[SNAKE_GRID_SIZE],
    Text:SnakeGame:TD_GAME_PLAYER_COL,
    Text:SnakeGame:TD_GAME_SIZE_COL,
    Text:SnakeGame:TD_GAME_KILLS_COL,
    Text:SnakeGame:TD_GAME_ALIVE_COL,
}
new Text:SnakeGame:TextDrawDataGame[SnakeGame:EnumTextDrawGame];

stock SnakeGame:CreateTextDrawGame() {
    SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG] = TextDrawCreate(320.0, 49.0, "_");
    TextDrawAlignment(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG], 0.0, 39.2);
    TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG], 150);
    TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG], 0.0, 270.0);

    SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL] = TextDrawCreate(185.0, 329.0, "Player");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL], 365.0, 0.0);

    SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL] = TextDrawCreate(368.0, 329.0, "Size");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL], 395.0, 0.0);

    SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL] = TextDrawCreate(398.0, 329.0, "Kills");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL], 425.0, 0.0);

    SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL] = TextDrawCreate(428.0, 329.0, "Alive");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL], 455.0, 0.0);

    for (new block, x, y; block < SNAKE_GRID_SIZE; block++) {
        SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block] = TextDrawCreate(194.0 + (x * 18.0), 310.0 - (y * 17.0), "_");
        TextDrawAlignment(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], 2);
        TextDrawLetterSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], 0.0, 1.5);
        TextDrawUseBox(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], RGBA_WHITE);
        TextDrawTextSize(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], 0.0, 15.0);

        if (++x > MAX_SNAKE_WIDTH) {
            y++, x = 0;
        }
    }
    return 1;
}

#define SNAKE_JOINGAME_TBUTTON_X 0
#define SNAKE_JOINGAME_TBUTTON_B 1
#define SNAKE_JOINGAME_TBUTTON_PAGE_F 2
#define SNAKE_JOINGAME_TBUTTON_PAGE_P 3
#define SNAKE_JOINGAME_TBUTTON_PAGE_N 4
#define SNAKE_JOINGAME_TBUTTON_PAGE_L 5

#define MAX_SNAKE_JOINGAME_TBUTTONS 6
enum SnakeGame:EnumDataJoinBtns { // Tiny Buttons
    Text:SnakeGame:Join_TBUTTON_X, // Close
    Text:SnakeGame:Join_TBUTTON_B, // Back
    Text:SnakeGame:Join_TBUTTON_PAGE_F, // First Page
    Text:SnakeGame:Join_TBUTTON_PAGE_P, // Previous Page
    Text:SnakeGame:Join_TBUTTON_PAGE_N, // Next Page
    Text:SnakeGame:Join_TBUTTON_PAGE_L // Last Page
}

#define MAX_SNAKE_JOINGAME_GTEXTDRAWS 5
enum SnakeGame:EnumDataJoin { // Generic Textdraws
    Text:SnakeGame:DataJoin_BG, // Background Box
    Text:SnakeGame:DataJoin_TITLE, // Title / Caption
    Text:SnakeGame:DataJoin_GCOL, // Game ID Column
    Text:SnakeGame:DataJoin_PCOL[MAX_SNAKE_PLAYERS], // Player Column
    Text:SnakeGame:DataJoin_TBUTTON[SnakeGame:EnumDataJoinBtns] // Tiny Button
}
new Text:SnakeGame:TextDrawDataJoin[SnakeGame:EnumDataJoin];

stock SnakeGame:CreateTextDrawJoin() {
    SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG] = TextDrawCreate(320.0, 105.0, "_"); // Background
    TextDrawAlignment(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG], 0.0, 24.9);
    TextDrawUseBox(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG], 100);
    TextDrawTextSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG], 0.0, 364.0);

    SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE] = TextDrawCreate(140.0, 92.0, "Join Game"); // Title
    TextDrawBackgroundColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], 255);
    TextDrawFont(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], 0);
    TextDrawLetterSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], 0.6, 2.0);
    TextDrawColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE], 1);

    SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL] = TextDrawCreate(140.0, 122.0, "Game ID"); // Game ID Column
    TextDrawBackgroundColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 255);
    TextDrawFont(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 0xFFFFFF32);
    TextDrawTextSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL], 180.0, 9.0);

    for (new col, Float:x, str[8 + 1]; col < MAX_SNAKE_PLAYERS; col++) {
        x = 180.0 + (col * 80.0);

        format(str, sizeof str, "Player %i", col + 1); // Player Column

        SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col] = TextDrawCreate(x + 4.0, 122.0, str);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 255);
        TextDrawFont(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 1);
        TextDrawLetterSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 0.2, 1.0);
        TextDrawColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], SnakeGame:Colors[col]);
        TextDrawSetOutline(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 1);
        TextDrawSetProportional(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], 0xFFFFFF32);
        TextDrawTextSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col], x + 80.0, 9.0);
    }

    for (new btn, str[3 + 1], Float:x; btn < MAX_SNAKE_JOINGAME_TBUTTONS; btn++) {
        switch (btn) {
            case SNAKE_JOINGAME_TBUTTON_X:  {
                str = "x", x = 492.0;
            }
            case SNAKE_JOINGAME_TBUTTON_B:  {
                str = "<", x = 469.0;
            }
            case SNAKE_JOINGAME_TBUTTON_PAGE_F:  {
                str = "P<<", x = 377.0;
            }
            case SNAKE_JOINGAME_TBUTTON_PAGE_P:  {
                str = "P-", x = 400.0;
            }
            case SNAKE_JOINGAME_TBUTTON_PAGE_N:  {
                str = "P+", x = 423.0;
            }
            case SNAKE_JOINGAME_TBUTTON_PAGE_L:  {
                str = "P>>", x = 446.0;
            }
        }

        SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn] = TextDrawCreate(x, 105.0, str);
        TextDrawAlignment(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 2);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 255);
        TextDrawFont(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 2);
        TextDrawLetterSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 0.2, 1.1);
        TextDrawColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 1);
        TextDrawSetProportional(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], -16777116);
        TextDrawTextSize(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 9.0, 20.0);
        TextDrawSetSelectable(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn], 1);
    }
    return 1;
}

#define SNAKE_KEY_TBUTTON_X 0
#define SNAKE_KEY_TBUTTON_B 1

#define MAX_SNAKE_KEY_TBUTTONS 2
enum SnakeGame:EnumKeyTbtn { // Tiny Buttons
    Text:SnakeGame:KEY_TBUTTON_X, // Close
    Text:SnakeGame:KEY_TBUTTON_B // Back
}

#define MAX_SNAKE_KEY_KEYACTIONS 5
enum SnakeGame:Enum_KEY_KEYACTIONS { // Key + Action
    PlayerText:SnakeGame:KEY_KEYACTION_L, // Left
    PlayerText:SnakeGame:KEY_KEYACTION_R, // Right
    PlayerText:SnakeGame:KEY_KEYACTION_D, // Down
    PlayerText:SnakeGame:KEY_KEYACTION_U, // Up
    PlayerText:SnakeGame:KEY_KEYACTION_X // Close
}

#define MAX_SNAKE_KEY_GTEXTDRAWS 6
enum SnakeGame:EnumTdKeys { // Generic Textdraws
    Text:SnakeGame:Td_Keys_BG, // Background Box
    Text:SnakeGame:Td_Keys_TITLE, // Title / Caption
    Text:SnakeGame:Td_Keys_TBUTTON[SnakeGame:EnumKeyTbtn], // Tiny Buttons
    Text:SnakeGame:Td_Keys_KEY_COL, // Keystroke Column
    Text:SnakeGame:Td_Keys_ACTION_COL, // Action Column
    Text:SnakeGame:Td_Keys_ACTION_ROW[SnakeGame:Enum_KEY_KEYACTIONS] // Action Row
}
new Text:SnakeGame:TextDrawDataKeys[SnakeGame:EnumTdKeys];

stock SnakeGame:CreateTextDrawKey() {
    SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG] = TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG], 0.0, 9.8);
    TextDrawUseBox(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG], 100);
    TextDrawTextSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG], 0.0, 302.0);

    SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE] = TextDrawCreate(173.0, 103.0, "Snake Keys");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], 255);
    TextDrawFont(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], 0);
    TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], 0.6, 2.0);
    TextDrawColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE], 1);

    for (new btn, Float:x, str[2]; btn < MAX_SNAKE_KEY_TBUTTONS; btn++) {
        switch (btn) {
            case SNAKE_KEY_TBUTTON_X:  { // Close
                x = 461.0, str = "x";
            }
            case SNAKE_KEY_TBUTTON_B:  { // Back
                x = 438.0, str = "<";
            }
        }

        SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn] = TextDrawCreate(x, 115.0, str);
        TextDrawAlignment(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 2);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 255);
        TextDrawFont(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 2);
        TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 0.2, 1.1);
        TextDrawColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 1);
        TextDrawSetProportional(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], -16777116);
        TextDrawTextSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 9.0, 20.0);
        TextDrawSetSelectable(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn], 1);
    }

    SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL] = TextDrawCreate(169.0, 129.0, "Key");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 318.0, 300.0);
    TextDrawSetSelectable(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL], 0);

    SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL] = TextDrawCreate(322.0, 129.0, "Action");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 255);
    TextDrawFont(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 1);
    TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 0.2, 1.0);
    TextDrawColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], -206);
    TextDrawTextSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 471.0, 300.0);
    TextDrawSetSelectable(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL], 0);

    for (new key, Float:y = 142.0, str_action[100]; key < MAX_SNAKE_KEY_KEYACTIONS; key++, y += 13.0) {
        switch (key) {
            case SNAKE_KEY_KEYACTION_L:  { // Left
                str_action = "Move Snake Left";
            }
            case SNAKE_KEY_KEYACTION_R:  { // Right
                str_action = "Move Snake Right";
            }
            case SNAKE_KEY_KEYACTION_D:  { // Down
                str_action = "Move Snake Down";
            }
            case SNAKE_KEY_KEYACTION_U:  { // Up
                str_action = "Move Snake Up";
            }
            case SNAKE_KEY_KEYACTION_X:  { // Close
                str_action = "Close Game";
            }
            default:  {
                continue;
            }
        }

        SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key] = TextDrawCreate(322.0, y, str_action);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 255);
        TextDrawFont(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 1);
        TextDrawLetterSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 0.2, 1.0);
        TextDrawColor(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 0);
        TextDrawSetProportional(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 1);
        TextDrawSetShadow(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 1);
        TextDrawTextSize(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key], 471.0, 0.0);
    }
    return 1;
}

#define MAX_SNAKE_MENU_RBUTTON 6
#define MAX_SNAKE_MENU_GTEXTDRAWS 9
enum SnakeGame:EnumTextDrawMenu { // Generic Textdraws
    Text:SnakeGame:TD_MENU_GTD_BG, // Background //0
    Text:SnakeGame:TD_MENU_GTD_TITLE, // Title / Caption //1
    Text:SnakeGame:TD_MENU_GTD_XBUTTON, // Close Button //2
    Text:SnakeGame:TD_MENU_RBUTTON_SP, //3
    Text:SnakeGame:TD_MENU_RBUTTON_MP, //4
    Text:SnakeGame:TD_MENU_RBUTTON_CREATE, //5
    Text:SnakeGame:TD_MENU_RBUTTON_JOIN, //6
    Text:SnakeGame:TD_MENU_RBUTTON_SCORE, //7
    Text:SnakeGame:TD_MENU_RBUTTON_KEYS //8
}
new Text:SnakeGame:TextDrawDataMenu[SnakeGame:EnumTextDrawMenu];

stock SnakeGame:CreateTextDrawMenu() {
    SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG] = TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG], 0.0, 13.4);
    TextDrawUseBox(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG], 100);
    TextDrawTextSize(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG], 0.0, 160.0);

    SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE] = TextDrawCreate(243.0, 103.0, "Snake Menu");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], 255);
    TextDrawFont(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], 0);
    TextDrawLetterSize(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE], 1);

    SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON] = TextDrawCreate(390.0, 115.0, "x");
    TextDrawAlignment(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 2);
    TextDrawBackgroundColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 255);
    TextDrawFont(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 0.2, 1.1);
    TextDrawColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 1);
    TextDrawUseBox(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], -16777116);
    TextDrawTextSize(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 9.0, 20.0);
    TextDrawSetSelectable(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON], 1);


    for (new btn, Float:y = 132.0, str[22 + 1]; btn < MAX_SNAKE_MENU_RBUTTON; btn++, y += 18.0) {
        switch (btn) {
            case SNAKE_MENU_RBUTTON_SP: str = "Singleplayer";
            case SNAKE_MENU_RBUTTON_MP: str = "Multiplayer";
            case SNAKE_MENU_RBUTTON_CREATE: str = "Create Game";
            case SNAKE_MENU_RBUTTON_JOIN: str = "Join Game";
            case SNAKE_MENU_RBUTTON_SCORE: str = "View Highscore";
            case SNAKE_MENU_RBUTTON_KEYS: str = "Keys";
        }

        new Text:id = TextDrawCreate(320.0, y, str);
        TextDrawAlignment(Text:id, 2);
        TextDrawBackgroundColor(Text:id, 255);
        TextDrawFont(Text:id, 1);
        TextDrawLetterSize(Text:id, 0.3, 1.5);
        TextDrawColor(Text:id, -1);
        TextDrawSetOutline(Text:id, 0);
        TextDrawSetProportional(Text:id, 1);
        TextDrawSetShadow(Text:id, 1);
        TextDrawUseBox(Text:id, 1);
        TextDrawBoxColor(Text:id, -16777116);
        TextDrawTextSize(Text:id, 13.0, 160.0);
        TextDrawSetSelectable(Text:id, 1);

        switch (btn) {
            case SNAKE_MENU_RBUTTON_SP: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SP] = Text:id;
            case SNAKE_MENU_RBUTTON_MP: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_MP] = Text:id;
            case SNAKE_MENU_RBUTTON_CREATE: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_CREATE] = Text:id;
            case SNAKE_MENU_RBUTTON_JOIN: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_JOIN] = Text:id;
            case SNAKE_MENU_RBUTTON_SCORE: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SCORE] = Text:id;
            case SNAKE_MENU_RBUTTON_KEYS: SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_KEYS] = Text:id;
        }
    }
    return 1;
}

#define MAX_SNAKE_NEWGAME_TBUTTONS 2
enum SnakeGame:EnumTDNewGameBTN { // New Game Tiny Buttons
    Text:SnakeGame:TDNewGameBTN_TBUTTON_X, // Close
    Text:SnakeGame:TDNewGameBTN_TBUTTON_B // Back
}

#define MAX_SNAKE_NEWGAME_GTEXTDRAWS 4
enum SnakeGame:EnumTextDrawNewGame { // Generic Textdraws
    Text:SnakeGame:TD_NEWGAME_BG,
    Text:SnakeGame:TD_NEWGAME_TITLE,
    Text:SnakeGame:TD_NEWGAME_TBUTTON[SnakeGame:EnumTDNewGameBTN], // Tiny Button
    Text:SnakeGame:TD_NEWGAME_PBUTTON[MAX_SNAKE_PLAYERS] // Player Button
}
new Text:SnakeGame:TextDrawDataNewGame[SnakeGame:EnumTextDrawNewGame];
stock SnakeGame:CreateTextDrawNewGame() {
    SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG] = TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG], 0.0, 9.4);
    TextDrawUseBox(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG], 100);
    TextDrawTextSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG], 0.0, 200.0);

    SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE] = TextDrawCreate(221.0, 103.0, "Create Snake Game");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], 255);
    TextDrawFont(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], 0);
    TextDrawLetterSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], 0.6, 2.0);
    TextDrawColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE], 1);

    for (new btn, Float:y = 132.0, str[10 + 1]; btn < MAX_SNAKE_PLAYERS; btn++, y += 18.0) {
        format(str, sizeof str, "%i %s", btn + 1, (btn == 0) ? ("Player") : ("Players"));

        SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn] = TextDrawCreate(320.0, y, str);
        TextDrawAlignment(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 2);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 255);
        TextDrawFont(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 1);
        TextDrawLetterSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 0.3, 1.5);
        TextDrawColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 0);
        TextDrawSetProportional(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 1);
        TextDrawSetShadow(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], -16777116);
        TextDrawTextSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 13.0, 200.0);
        TextDrawSetSelectable(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn], 1);
    }

    for (new btn, Float:x, str[2]; btn < MAX_SNAKE_NEWGAME_TBUTTONS; btn++) {
        switch (btn) {
            case SNAKE_NEWGAME_TBUTTON_X:  { // Close
                x = 410.0, str = "x";
            }
            case SNAKE_NEWGAME_TBUTTON_B:  { // Back
                x = 387.0, str = "<";
            }
            default:  {
                continue;
            }
        }

        SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn] = TextDrawCreate(x, 115.0, str);
        TextDrawAlignment(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 2);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 255);
        TextDrawFont(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 2);
        TextDrawLetterSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 0.2, 1.1);
        TextDrawColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 1);
        TextDrawSetProportional(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], -16777116);
        TextDrawTextSize(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 10.0, 20.0);
        TextDrawSetSelectable(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn], 1);
    }
    return 1;
}

#define SNAKE_SCORE_TBUTTON_X 0
#define SNAKE_SCORE_TBUTTON_B 1
#define SNAKE_SCORE_TBUTTON_PAGE_F 2
#define SNAKE_SCORE_TBUTTON_PAGE_P 3
#define SNAKE_SCORE_TBUTTON_PAGE_N 4
#define SNAKE_SCORE_TBUTTON_PAGE_L 5

#define MAX_SNAKE_SCORE_TBUTTONS 6
enum SnakeGame:EnumTextDrawScore_TBTN { // Tiny Buttons
    Text:SnakeGame:TD_SCORE_TBTN_X, // Close
    Text:SnakeGame:TD_SCORE_TBTN_B, // Back
    Text:SnakeGame:TD_SCORE_TBTN_PAGE_F, // First Page
    Text:SnakeGame:TD_SCORE_TBTN_PAGE_P, // Previous Page
    Text:SnakeGame:TD_SCORE_TBTN_PAGE_N, // Next Page
    Text:SnakeGame:TD_SCORE_TBTN_PAGE_L // Last Page

}

#define MAX_SNAKE_SCORE_GTEXTDRAWS 3
enum SnakeGame:EnumTextDrawScore { // Generic Textdraws
    Text:SnakeGame:TD_SCORE_BG, // Background Box
    Text:SnakeGame:TD_SCORE_TITLE, // Title / Caption
    Text:SnakeGame:TD_SCORE_TBUTTON[SnakeGame:EnumTextDrawScore_TBTN] // Tiny Buttons
}
new Text:SnakeGame:TextDrawDataScore[SnakeGame:EnumTextDrawScore];

stock SnakeGame:CreateTextDrawScore() {
    SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG] = TextDrawCreate(320.0, 105.0, "_");
    TextDrawAlignment(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG], 2);
    TextDrawLetterSize(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG], 0.0, 24.9);
    TextDrawUseBox(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG], 1);
    TextDrawBoxColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG], 100);
    TextDrawTextSize(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG], 0.0, 364.0);

    SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE] = TextDrawCreate(140.0, 92.0, "Snake Highscore");
    TextDrawBackgroundColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], 255);
    TextDrawFont(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], 0);
    TextDrawLetterSize(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], 0.6, 2.0);
    TextDrawColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], -1);
    TextDrawSetOutline(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], 1);
    TextDrawSetProportional(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE], 1);

    for (new btn, Float:x, str[3 + 1]; btn < MAX_SNAKE_SCORE_TBUTTONS; btn++) {
        switch (btn) {
            case SNAKE_SCORE_TBUTTON_X:  {
                x = 492.0, str = "x";
            }
            case SNAKE_SCORE_TBUTTON_B:  {
                x = 469.0, str = "<";
            }
            case SNAKE_SCORE_TBUTTON_PAGE_F:  {
                x = 377.0, str = "P<<";
            }
            case SNAKE_SCORE_TBUTTON_PAGE_P:  {
                x = 400.0, str = "P-";
            }
            case SNAKE_SCORE_TBUTTON_PAGE_N:  {
                x = 423.0, str = "P+";
            }
            case SNAKE_SCORE_TBUTTON_PAGE_L:  {
                x = 446.0, str = "P>>";
            }
            default:  {
                continue;
            }
        }

        SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn] = TextDrawCreate(x, 105.0, str);
        TextDrawAlignment(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 2);
        TextDrawBackgroundColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 255);
        TextDrawFont(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 2);
        TextDrawLetterSize(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 0.2, 1.1);
        TextDrawColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], -1);
        TextDrawSetOutline(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 1);
        TextDrawSetProportional(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 1);
        TextDrawUseBox(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 1);
        TextDrawBoxColor(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], -16777116);
        TextDrawTextSize(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 9.0, 20.0);
        TextDrawSetSelectable(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn], 1);
    }
    return 1;
}

stock SnakeGame:DestroyTextDrawGame() {
    TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL]);
    TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL]);
    TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL]);
    TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL]);

    for (new block; block < SNAKE_GRID_SIZE; block++) {
        TextDrawDestroy(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block]);
    }
    return 1;
}

stock SnakeGame:DestroyTextDrawJoin() {
    TextDrawDestroy(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE]);
    TextDrawDestroy(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL]);
    for (new col; col < MAX_SNAKE_PLAYERS; col++) {
        TextDrawDestroy(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col]);
    }
    for (new btn; btn < MAX_SNAKE_JOINGAME_TBUTTONS; btn++) {
        TextDrawDestroy(SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn]);
    }
    return 1;
}

stock SnakeGame:DestroyTextDrawKey() {
    TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE]);
    for (new btn; btn < MAX_SNAKE_KEY_TBUTTONS; btn++) {
        TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn]);
    }
    TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL]);
    TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL]);
    for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
        TextDrawDestroy(SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key]);
    }
    return 1;
}

stock SnakeGame:DestroyTextDrawMenu() {
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SP]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_MP]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_CREATE]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_JOIN]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SCORE]);
    TextDrawDestroy(SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_KEYS]);
    return 1;
}

stock SnakeGame:DestroyTextDrawNewGame() {
    TextDrawDestroy(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE]);
    for (new btn; btn < MAX_SNAKE_PLAYERS; btn++) {
        TextDrawDestroy(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn]);
    }
    for (new btn; btn < MAX_SNAKE_NEWGAME_TBUTTONS; btn++) {
        TextDrawDestroy(SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn]);
    }
    return 1;
}

stock SnakeGame:DestroyTextDrawScore() {
    TextDrawDestroy(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_BG]);
    TextDrawDestroy(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE]);
    for (new btn; btn < MAX_SNAKE_SCORE_TBUTTONS; btn++) {
        TextDrawDestroy(SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn]);
    }
    return 1;
}

stock SnakeGame:HidePlayerTextdraws(playerid) {
    // hide join
    SnakeGame:HidePlayerTextdrawJoin(playerid);

    // score rows
    PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE]);
    for (new col; col < MAX_SNAKE_SCORE_COLUMNS; col++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:EnumTdDataPlayerScoreCol:col]);
    }
    for (new row; row < MAX_SNAKE_SCORE_PAGESIZE; row++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row]);
    }

    // join textdraws
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL]);
    for (new col; col < MAX_SNAKE_PLAYERS; col++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col]);
    }
    for (new btn; btn < MAX_SNAKE_JOINGAME_TBUTTONS; btn++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn]);
    }

    // keys
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE]);
    for (new btn; btn < MAX_SNAKE_KEY_TBUTTONS; btn++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn]);
    }
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL]);
    for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key]);
    }

    // hide player keys textdraw for games
    SnakeGame:HidePlayerTextdrawKeys(playerid);

    // new in game
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE]);
    for (new btn; btn < MAX_SNAKE_PLAYERS; btn++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn]);
    }
    for (new btn; btn < MAX_SNAKE_NEWGAME_TBUTTONS; btn++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn]);
    }

    // hide score
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE]);
    for (new btn; btn < MAX_SNAKE_SCORE_TBUTTONS; btn++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn]);
    }

    // hide game
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL]);
    for (new block; block < SNAKE_GRID_SIZE; block++) {
        TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block]);
    }

    // hide player game
    SnakeGame:HideGameTextdraws(playerid);

    // hide menu
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SP]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_MP]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_CREATE]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_JOIN]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SCORE]);
    TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_KEYS]);
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] = SNAKE_TDMODE_NONE;
    return 1;
}

stock SnakeGame:ShowTextdraws(playerid, tdmode) {
    if (tdmode == SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode]) return 0;
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] != SNAKE_TDMODE_NONE) SnakeGame:HidePlayerTextdraws(playerid);
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] = tdmode;

    switch (tdmode) {
        case SNAKE_TDMODE_GAME:  {
            // show global player td
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BG]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_PLAYER_COL]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_SIZE_COL]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_KILLS_COL]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_ALIVE_COL]);

            // show player td
            SnakeGame:ShowGameTextdraws(playerid);
        }
        case SNAKE_TDMODE_MENU:  {
            // show global menu td
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_BG]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_TITLE]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SP]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_MP]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_CREATE]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_JOIN]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SCORE]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_KEYS]);
        }
        case SNAKE_TDMODE_NEWGAME:  {
            // show global new game
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_BG]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TITLE]);
            for (new btn; btn < MAX_SNAKE_PLAYERS; btn++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn]);
            }
            for (new btn; btn < MAX_SNAKE_NEWGAME_TBUTTONS; btn++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:EnumTDNewGameBTN:btn]);
            }
        }
        case SNAKE_TDMODE_JOINGAME:  {
            // show global join td
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_BG]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TITLE]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_GCOL]);
            for (new col; col < MAX_SNAKE_PLAYERS; col++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_PCOL][col]);
            }
            for (new btn; btn < MAX_SNAKE_JOINGAME_TBUTTONS; btn++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:EnumDataJoinBtns:btn]);
            }
        }
        case SNAKE_TDMODE_HIGHSCORE:  {
            // show global score td
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TITLE]);
            for (new btn; btn < MAX_SNAKE_SCORE_TBUTTONS; btn++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:EnumTextDrawScore_TBTN:btn]);
            }
        }
        case SNAKE_TDMODE_KEYS:  {
            // show global keys td
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_BG]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TITLE]);
            for (new btn; btn < MAX_SNAKE_KEY_TBUTTONS; btn++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:EnumKeyTbtn:btn]);
            }
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_KEY_COL]);
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_COL]);
            for (new key; key < MAX_SNAKE_KEY_KEYACTIONS; key++) {
                TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_ACTION_ROW][SnakeGame:Enum_KEY_KEYACTIONS:key]);
            }

            // show keys to player
            SnakeGame:ShowPlayerTextdrawKeys(playerid);
        }
        default: return 0;
    }
    return 1;
}