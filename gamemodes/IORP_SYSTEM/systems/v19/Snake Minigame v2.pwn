#define RGBA_WHITE                0xFFFFFFFF
#define RGBA_RED                  0xFF0000FF
#define RGBA_GREEN                0x00FF00FF
#define SNAKE_GRID_WIDTH          15
#define SNAKE_GRID_HEIGHT         15
#define SNAKE_GRID_SIZE           (SNAKE_GRID_WIDTH * SNAKE_GRID_HEIGHT)
#define MIN_SNAKE_WIDTH           0
#define MAX_SNAKE_WIDTH           (SNAKE_GRID_WIDTH - 1)
#define MIN_SNAKE_HEIGHT          0
#define MAX_SNAKE_HEIGHT          (SNAKE_GRID_HEIGHT - 1)
#define MAX_SNAKE_SIZE            SNAKE_GRID_SIZE
#define MAX_SNAKE_PLAYERS         4
#define MAX_SNAKE_GAMES           20
#define INVALID_SNAKE_GAME_BLOCK  -1
#define INVALID_SNAKE_TIMER       -1
#define INVALID_SNAKE_GAME        -1
#define INVALID_SNAKE_PLAYER_SLOT -1
#define INVALID_SNAKE_DIRECTION   -1
#define SNAKE_BLOCK_DATA_FOOD     -1
#define SNAKE_GAME_INTERVAL_MS    100
#define SNAKE_COUNTDOWN_S         10
#define SNAKE_COUNTOUT_S          5
#define MAX_SNAKE_SCORE_PAGESIZE 15
#define MAX_SNAKE_SCORE_QUERYLEN 1000
#define MIN_SNAKE_SCORE_PAGE 0
#define MAX_SNAKE_SCORE_PAGE 2147483646 // max 32 bit integer value - 1
#define MAX_SNAKE_JOINGAME_PAGESIZE 15
#define MIN_SNAKE_JOINGAME_PAGE 0
#define MAX_SNAKE_JOINGAME_PAGE ((MAX_SNAKE_GAMES - 1) / MAX_SNAKE_JOINGAME_PAGESIZE)
#define MAX_SNAKE_JOINGAME_PBUTTONS (MAX_SNAKE_PLAYERS * MAX_SNAKE_JOINGAME_PAGESIZE)

#define SNAKE_TDMODE_NONE 0
#define SNAKE_TDMODE_GAME 1
#define SNAKE_TDMODE_MENU 2
#define SNAKE_TDMODE_NEWGAME 3
#define SNAKE_TDMODE_JOINGAME 4
#define SNAKE_TDMODE_HIGHSCORE 5
#define SNAKE_TDMODE_KEYS 6

// Snake Game States
#define SNAKE_STATE_NONE 0
#define SNAKE_STATE_COUNTDOWN 1
#define SNAKE_STATE_STARTED 2
#define SNAKE_STATE_GAMEOVER 3

// Snake Heading Directions
#define SNAKE_DIRECTION_U 0
#define SNAKE_DIRECTION_D 1
#define SNAKE_DIRECTION_L 2
#define SNAKE_DIRECTION_R 3
#define MAX_SNAKE_DIRECTIONS 4

// sortings
#define SNAKE_SCORE_SORT_PLAYER_D 0
#define SNAKE_SCORE_SORT_PLAYER_A 1
#define SNAKE_SCORE_SORT_SIZE_D 2
#define SNAKE_SCORE_SORT_SIZE_A 3
#define SNAKE_SCORE_SORT_KILLS_D 4
#define SNAKE_SCORE_SORT_KILLS_A 5
#define SNAKE_SCORE_SORT_TIMEDATE_D 6
#define SNAKE_SCORE_SORT_TIMEDATE_A 7

// menu buttons
#define SNAKE_MENU_RBUTTON_SP 0
#define SNAKE_MENU_RBUTTON_MP 1
#define SNAKE_MENU_RBUTTON_CREATE 2
#define SNAKE_MENU_RBUTTON_JOIN 3
#define SNAKE_MENU_RBUTTON_SCORE 4
#define SNAKE_MENU_RBUTTON_KEYS 5

// snake tbutton
#define SNAKE_NEWGAME_TBUTTON_X 0
#define SNAKE_NEWGAME_TBUTTON_B 1

new const SnakeGame:Colors[MAX_SNAKE_PLAYERS] = {
    0xFF0000FF,
    0xFFFF00FF,
    0x0000FFFF,
    0xFF00FFFF
};

enum SnakeGame:EnumGameData {
    SnakeGame:GameState,
    SnakeGame:GameTime,
    SnakeGame:GameCurrentPlayerCount,
    SnakeGame:GameTargetPlayerCount,
    SnakeGame:GamePlayerSnakeID[MAX_SNAKE_PLAYERS],
    SnakeGame:GameSortedPlayers[MAX_SNAKE_PLAYERS],
    SnakeGame:GameBlockData[SNAKE_GRID_SIZE],
}

enum SnakeGame:EnumPlayerData {
    SnakeGame:PlayerGameID,
    SnakeGame:PlayerSnakeSlot,
    SnakeGame:PlayerSnakeSize,
    SnakeGame:PlayerSnakeKills,
    SnakeGame:PlayerSnakeBlocks[MAX_SNAKE_SIZE],
    SnakeGame:PlayerSnakeNextDirection,
    SnakeGame:PlayerSnakeLastDirection,
    bool:SnakeGame:PlayerSnakeAlive,
    SnakeGame:PlayerSnakeTextDrawMode,

    SnakeGame:PlayerSnakeJoinGamePage,
    SnakeGame:PlayerSnakeScorePage,
    SnakeGame:PlayerSnakeScoreSort,
}

new SnakeGame:GameData[MAX_SNAKE_GAMES][SnakeGame:EnumGameData];
new SnakeGame:PlayerData[MAX_PLAYERS][SnakeGame:EnumPlayerData];
new SnakeGame:GameUpdateTimer = INVALID_SNAKE_TIMER;
new DB:SnakeGame:ScoreDB;

#include "IORP_SYSTEM/systems/v19/Snake Minigame v2 Textdraws.pwn" /////===== Snake Game System =====/////

stock SnakeGame:DefaultGameSnakeData(gameid) {
    SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_NONE;
    SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime();
    SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] = 0;
    SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = 0;

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p] = INVALID_PLAYER_ID;
        SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][p] = INVALID_PLAYER_ID;
    }

    for (new b; b < SNAKE_GRID_SIZE; b++) SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] = INVALID_PLAYER_ID;

    new random_block = random(SNAKE_GRID_SIZE);
    SnakeGame:GameData[gameid][SnakeGame:GameBlockData][random_block] = SNAKE_BLOCK_DATA_FOOD;
    return 1;
}

stock SnakeGame:DefaultPlayerSnakeData(playerid) {
    for (new b; b < MAX_SNAKE_SIZE; b++) {
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b] = 0;
    }
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] = 0;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeKills] = 0;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeNextDirection] = random(MAX_SNAKE_DIRECTIONS);
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeLastDirection] = INVALID_SNAKE_DIRECTION;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] = INVALID_SNAKE_GAME;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot] = INVALID_SNAKE_PLAYER_SLOT;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive] = false;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] = SNAKE_TDMODE_NONE;
    return 1;
}

hook OnGameModeInit() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        SnakeGame:DefaultGameSnakeData(gameid);
    }

    foreach(new playerid:Player) {
        SnakeGame:DefaultPlayerSnakeData(playerid);
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] = 0;
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] = 0;
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;
    }

    SnakeGame:GameUpdateTimer = SetPreciseTimer("OnSnakeUpdate", SNAKE_GAME_INTERVAL_MS, true);
    SnakeGame:ScoreDB = db_open("snake.db");
    if (SnakeGame:ScoreDB == DB:0) print("[Snake database] ERROR:could not be opened!");
    else {
        print("[Snake database] opened successfully.");
        db_free_result(db_query(SnakeGame:ScoreDB, "\
        CREATE TABLE IF NOT EXISTS snakescore \
            (\
            playername TEXT, \
            size INT, \
            kills INT, \
            scoretimedate TEXT DEFAULT (DATETIME('now'))\
            )\
        "));
    }

    SnakeGame:CreateTextDrawGame(); // Generic Game Textdraws
    SnakeGame:CreateTextDrawJoin(); // Generic Join Game Textdraws
    SnakeGame:CreateTextDrawKey(); // Generic Key Textdraws
    SnakeGame:CreateTextDrawMenu(); // Menu Textdraws
    SnakeGame:CreateTextDrawNewGame(); // New Game Textdraws
    SnakeGame:CreateTextDrawScore(); // Score Textdraws
    return 1;
}

hook OnGameModeExit() {
    DeletePreciseTimer(SnakeGame:GameUpdateTimer);
    foreach(new playerid:Player) {
        if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) SnakeGame:PlayerLeave(playerid);
        if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] != SNAKE_TDMODE_NONE) SnakeGame:HidePlayerTextdraws(playerid);
    }

    if (db_close(SnakeGame:ScoreDB)) print("  [Snake database] closed successfully.");
    else print("  [Snake database] ERROR: could not be closed!");

    SnakeGame:DestroyTextDrawGame(); // Generic Game Textdraws
    SnakeGame:DestroyTextDrawJoin(); // Generic Join Game Textdraws
    SnakeGame:DestroyTextDrawKey(); // Generic Key Textdraws
    SnakeGame:DestroyTextDrawMenu(); // Menu Textdraws
    SnakeGame:DestroyTextDrawNewGame(); // New Game Textdraws
    SnakeGame:DestroyTextDrawScore(); // Score Textdraws
    return 1;
}

hook OnPlayerConnect(playerid) {
    SnakeGame:DefaultPlayerSnakeData(playerid);
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] = 0;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] = 0;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;

    SnakeGame:CreateGameTextdraws(playerid);
    SnakeGame:CreatePlayerTextdrawScore(playerid);
    SnakeGame:CreatePlayerTextdrawJoin(playerid);
    SnakeGame:CreatePlayerTextdrawKeys(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) SnakeGame:PlayerLeave(playerid);
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] != SNAKE_TDMODE_NONE) SnakeGame:HidePlayerTextdraws(playerid);

    SnakeGame:DestroyGameTextdraws(playerid);
    SnakeGame:DestroyPlayerTdScore(playerid);
    SnakeGame:DestroyPlayerTextdrawJoin(playerid);
    SnakeGame:DestroyPlayerTextdrawKeys(playerid);
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) SnakeGame:ApplyDirection(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME && (newkeys & KEY_SECONDARY_ATTACK) && (newkeys & KEY_CROUCH) && (newkeys & KEY_JUMP)) {
        SnakeGame:PlayerLeave(playerid);
        return 1;
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == Text:INVALID_TEXT_DRAW) {
        switch (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode]) {
            case SNAKE_TDMODE_MENU, SNAKE_TDMODE_NEWGAME, SNAKE_TDMODE_JOINGAME, SNAKE_TDMODE_HIGHSCORE, SNAKE_TDMODE_KEYS:  {
                SnakeGame:HidePlayerTextdraws(playerid);
            }
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_MENU) {
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SP]) {
            new create_gameid = SnakeGame:FindEmptyGame();

            if (create_gameid == INVALID_SNAKE_GAME) {
                return 1;
            }

            if (!SnakeGame:JoinGame(playerid, create_gameid, .playerslot = 0)) {
                return 1;
            }

            SnakeGame:GameData[create_gameid][SnakeGame:GameTargetPlayerCount] = 1;
            SnakeGame:GameData[create_gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_MP]) {
            new gameid = SnakeGame:FindGameToJoin();

            if (gameid != INVALID_SNAKE_GAME) {
                new playerslot = SnakeGame:GetSnakeFreePlayerSlot(gameid);

                if (SnakeGame:JoinGame(playerid, gameid, playerslot)) {
                    CancelSelectTextDraw(playerid);
                    return 1;
                }
            }

            gameid = SnakeGame:FindEmptyGame();

            if (gameid != INVALID_SNAKE_GAME && SnakeGame:JoinGame(playerid, gameid, .playerslot = 0)) {
                SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = 2;
                SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

                CancelSelectTextDraw(playerid);
                return 1;
            }

            SendClientMessageEx(playerid, RGBA_RED, "ERROR: A game could not be found right now!");
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_CREATE]) {
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_NEWGAME);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_JOIN]) {
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_JOINGAME);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_SCORE]) {
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_HIGHSCORE);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_RBUTTON_KEYS]) {
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_KEYS);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataMenu[SnakeGame:TD_MENU_GTD_XBUTTON]) {
            SnakeGame:HidePlayerTextdraws(playerid);
            CancelSelectTextDraw(playerid);
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_NEWGAME) {
        for (new btn; btn < MAX_SNAKE_PLAYERS; btn++) {
            if (clickedid == SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_PBUTTON][btn]) {
                new gameid = SnakeGame:FindEmptyGame();

                if (gameid != INVALID_SNAKE_GAME && SnakeGame:JoinGame(playerid, gameid, .playerslot = 0)) {
                    SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = btn + 1;
                    SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

                    CancelSelectTextDraw(playerid);
                }
                return 1;
            }
        }

        if (clickedid == SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:TDNewGameBTN_TBUTTON_X]) { // Close
            SnakeGame:HidePlayerTextdraws(playerid);
            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataNewGame[SnakeGame:TD_NEWGAME_TBUTTON][SnakeGame:TDNewGameBTN_TBUTTON_B]) { // Back
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_JOINGAME) {
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_X]) { // Close
            SnakeGame:HidePlayerTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_B]) { // Back
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_PAGE_F]) { // First Page
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] > MIN_SNAKE_JOINGAME_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] = MIN_SNAKE_JOINGAME_PAGE;
                SnakeGame:ApplyJoinGamePage(playerid);
                SnakeGame:ApplyJoinGameID(playerid);
                SnakeGame:ApplyJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_PAGE_P]) { // Previous Page
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] > MIN_SNAKE_JOINGAME_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage]--;
                SnakeGame:ApplyJoinGamePage(playerid);
                SnakeGame:ApplyJoinGameID(playerid);
                SnakeGame:ApplyJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_PAGE_N]) { // Next Page
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] < MAX_SNAKE_JOINGAME_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage]++;
                SnakeGame:ApplyJoinGamePage(playerid);
                SnakeGame:ApplyJoinGameID(playerid);
                SnakeGame:ApplyJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataJoin[SnakeGame:DataJoin_TBUTTON][SnakeGame:Join_TBUTTON_PAGE_L]) { // Last Page
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] < MAX_SNAKE_JOINGAME_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] = MAX_SNAKE_JOINGAME_PAGE;
                SnakeGame:ApplyJoinGamePage(playerid);
                SnakeGame:ApplyJoinGameID(playerid);
                SnakeGame:ApplyJoinGamePlayers(playerid);
            }
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_HIGHSCORE) {
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_X]) {
            SnakeGame:HidePlayerTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_B]) {
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_PAGE_F]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] > MIN_SNAKE_SCORE_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] = MIN_SNAKE_SCORE_PAGE;
                SnakeGame:ApplyScorePage(playerid);
                SnakeGame:ApplyScoreRow(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_PAGE_P]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] > MIN_SNAKE_SCORE_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage]--;
                SnakeGame:ApplyScorePage(playerid);
                SnakeGame:ApplyScoreRow(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_PAGE_N]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] < MAX_SNAKE_SCORE_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage]++;
                SnakeGame:ApplyScorePage(playerid);
                SnakeGame:ApplyScoreRow(playerid);
            }
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataScore[SnakeGame:TD_SCORE_TBUTTON][SnakeGame:TD_SCORE_TBTN_PAGE_L]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] < MAX_SNAKE_SCORE_PAGE) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] = MAX_SNAKE_SCORE_PAGE;
                SnakeGame:ApplyScorePage(playerid);
                SnakeGame:ApplyScoreRow(playerid);
            }
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_KEYS) {
        if (clickedid == SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:KEY_TBUTTON_X]) { // Close
            SnakeGame:HidePlayerTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == SnakeGame:TextDrawDataKeys[SnakeGame:Td_Keys_TBUTTON][SnakeGame:KEY_TBUTTON_B]) { // Back
            SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_JOINGAME) {
        for (new btn; btn < MAX_SNAKE_JOINGAME_PBUTTONS; btn++) {
            if (playertextid == SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][btn]) {
                new gameid = (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE) + btn / MAX_SNAKE_PLAYERS;

                if (gameid >= MAX_SNAKE_GAMES) {
                    return 1;
                }

                if (SnakeGame:GameData[gameid][SnakeGame:GameState] != SNAKE_STATE_COUNTDOWN) {
                    return 1;
                }

                if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] >= SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    return 1;
                }

                new playerslot = btn % MAX_SNAKE_PLAYERS;

                if (SnakeGame:JoinGame(playerid, gameid, playerslot)) {
                    CancelSelectTextDraw(playerid);
                }

                return 1;
            }
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_HIGHSCORE) {
        if (playertextid == SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_PLAYER]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] == SNAKE_SCORE_SORT_PLAYER_D) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_PLAYER_A;
            } else {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_PLAYER_D;
            }
            SnakeGame:ApplyScoreSorting(playerid);
            SnakeGame:ApplyScoreRow(playerid);
            return 1;
        }
        if (playertextid == SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_SIZE]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] == SNAKE_SCORE_SORT_SIZE_D) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_A;
            } else {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;
            }
            SnakeGame:ApplyScoreSorting(playerid);
            SnakeGame:ApplyScoreRow(playerid);
            return 1;
        }
        if (playertextid == SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_KILLS]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] == SNAKE_SCORE_SORT_KILLS_D) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_KILLS_A;
            } else {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_KILLS_D;
            }
            SnakeGame:ApplyScoreSorting(playerid);
            SnakeGame:ApplyScoreRow(playerid);
            return 1;
        }
        if (playertextid == SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_TIMEDATE]) {
            if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] == SNAKE_SCORE_SORT_TIMEDATE_D) {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_TIMEDATE_A;
            } else {
                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort] = SNAKE_SCORE_SORT_TIMEDATE_D;
            }
            SnakeGame:ApplyScoreSorting(playerid);
            SnakeGame:ApplyScoreRow(playerid);
            return 1;
        }
    }
    return 1;
}

forward OnSnakeUpdate();
public OnSnakeUpdate() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        switch (SnakeGame:GameData[gameid][SnakeGame:GameState]) {
            case SNAKE_STATE_NONE:  {
                continue;
            }
            case SNAKE_STATE_COUNTDOWN:  {
                if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] < SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    new countdown_str[50];

                    format(countdown_str, sizeof countdown_str,
                        "waiting for players %i/%i", SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount], SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]
                    );

                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], countdown_str);
                        }
                    }
                } else if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] == SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    new timeleft = SnakeGame:GameData[gameid][SnakeGame:GameTime] - gettime(), countdown_str[6 + 1];

                    if (timeleft > 0) {
                        format(countdown_str, sizeof countdown_str, "%i", timeleft);
                    } else {
                        countdown_str = "Go!";

                        SnakeGame:GameData[gameid][SnakeGame:GameState]++;
                        SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime() + 1;
                    }

                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], countdown_str);
                        }
                    }
                }
            }
            case SNAKE_STATE_STARTED:  {
                new bool:foodeaten = false;

                if (gettime() == SnakeGame:GameData[gameid][SnakeGame:GameTime]) {
                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], "_");
                        }
                    }
                }

                for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                    new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                    if (playerid == INVALID_PLAYER_ID) {
                        continue;
                    }

                    if (!SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
                        continue;
                    }

                    new head_block = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][0],
                        direction = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeNextDirection],
                        next_block = SnakeGame:GetNextBlock(head_block, direction),
                        next_block_data = SnakeGame:GameData[gameid][SnakeGame:GameBlockData][next_block],
                        size = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize],
                        tail_block = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][size - 1];

                    if (next_block_data == SNAKE_BLOCK_DATA_FOOD) { // Next Block = Food
                        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize]++;

                        PlayerPlaySound(playerid, 5205, 0.0, 0.0, 0.0);

                        foodeaten = true;
                    } else if (next_block_data != INVALID_PLAYER_ID) { // Next Block = Player
                        new enemyid = next_block_data; // Next Block Player = Enemy

                        if (enemyid != playerid) { // Enemy = Another Player
                            SnakeGame:PlayerData[enemyid][SnakeGame:PlayerSnakeKills]++;

                            new
                            enemy_head_block = SnakeGame:PlayerData[enemyid][SnakeGame:PlayerSnakeBlocks][0],
                                enemy_direction = SnakeGame:PlayerData[enemyid][SnakeGame:PlayerSnakeNextDirection],
                                enemy_next_block = SnakeGame:GetNextBlock(enemy_head_block, enemy_direction),
                                enemy_next_block_data = SnakeGame:GameData[gameid][SnakeGame:GameBlockData][enemy_next_block];

                            if (enemy_next_block_data == playerid) {
                                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeKills]++;

                                SnakeGame:KillSnake(enemyid);

                                PlayerPlaySound(enemyid, 5206, 0.0, 0.0, 0.0);
                            }
                        }

                        SnakeGame:KillSnake(playerid);

                        PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);
                    } else { // Next Block = Empty
                        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][tail_block] = INVALID_PLAYER_ID;

                        SnakeGame:HideGameBlock(gameid, tail_block);
                    }

                    if (!SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
                        continue;
                    }

                    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] > 1) {
                        for (new b = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] - 1; b > 0; b--) {
                            SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b] = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b - 1];
                        }
                    }

                    SnakeGame:ShowGameBlock(gameid, next_block, SnakeGame:Colors[SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot]]);

                    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][0] = next_block;
                    SnakeGame:GameData[gameid][SnakeGame:GameBlockData][next_block] = playerid;

                    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeLastDirection] = direction;
                }

                if (foodeaten && SnakeGame:GetFoodBlocks(gameid) == 0) {
                    new random_block = SnakeGame:GetRandomEmptyBlock(gameid);

                    if (random_block != INVALID_SNAKE_GAME_BLOCK) {
                        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][random_block] = SNAKE_BLOCK_DATA_FOOD;

                        SnakeGame:ShowGameBlock(gameid, random_block, RGBA_WHITE);
                    }
                }

                if (foodeaten) {
                    SnakeGame:SortSnakePlayers(gameid), SnakeGame:RefreshSnakePlayers(gameid);
                }
            }
            case SNAKE_STATE_GAMEOVER:  {
                new timeleft = SnakeGame:GameData[gameid][SnakeGame:GameTime] - gettime();

                if (timeleft > 0) {
                    new countdown_str[2 + 1];

                    format(countdown_str, sizeof countdown_str, "%i", timeleft);

                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerGame[playerid][SnakeGame:TD_PGAME_PTD_COUNTDOWN], countdown_str);
                        }
                    }
                } else {
                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            SnakeGame:PlayerLeave(playerid);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

stock SnakeGame:BlockToPos(block, & x, & y) {
    x = block % SNAKE_GRID_WIDTH;
    y = block / SNAKE_GRID_WIDTH;
    return 1;
}

stock SnakeGame:PosToBlock(x, y) {
    return x + (y * SNAKE_GRID_WIDTH);
}

stock SnakeGame:GetNextBlock(block, direction) {
    new x, y;
    SnakeGame:BlockToPos(block, x, y);
    switch (direction) {
        case SNAKE_DIRECTION_U:  { if (++y > MAX_SNAKE_HEIGHT) { y = MIN_SNAKE_HEIGHT; } }
        case SNAKE_DIRECTION_D:  { if (--y < MIN_SNAKE_HEIGHT) { y = MAX_SNAKE_HEIGHT; } }
        case SNAKE_DIRECTION_L:  { if (--x < MIN_SNAKE_WIDTH) { x = MAX_SNAKE_WIDTH; } }
        case SNAKE_DIRECTION_R:  { if (++x > MAX_SNAKE_WIDTH) { x = MIN_SNAKE_WIDTH; } }
    }
    return SnakeGame:PosToBlock(x, y);
}

stock SnakeGame:KillSnake(playerid) {
    new gameid = SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID];
    if (gameid == INVALID_SNAKE_GAME) return 0;
    if (!SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) return 0;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive] = false;
    for (new b; b < SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize]; b++) {
        new block = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b];
        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][block] = SNAKE_BLOCK_DATA_FOOD;
        SnakeGame:ShowGameBlock(gameid, block, 0xFFFFFFFF);
    }

    SnakeGame:InsertScore(playerid);

    if (SnakeGame:GetAlivePlayers(gameid) <= 1) {
        SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_GAMEOVER;
        SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime() + SNAKE_COUNTOUT_S;
    }
    SnakeGame:SortSnakePlayers(gameid), SnakeGame:RefreshSnakePlayers(gameid);
    return 1;
}

stock SnakeGame:InsertScore(playerid) {
    db_free_result(db_query(SnakeGame:ScoreDB,
        sprintf(
            "INSERT INTO snakescore (playername, size, kills) VALUES ('%q', '%i', '%i')",
            GetPlayerNameEx(playerid), SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize], SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeKills]
        )
    ));
    return 1;
}

stock SnakeGame:GetAlivePlayers(gameid) {
    new p_count;
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];
        if (playerid != INVALID_PLAYER_ID && SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) { p_count++; }
    }
    return p_count;
}

stock SnakeGame:ShowGameBlock(gameid, block, color) {
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], color);
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];
        if (playerid != INVALID_PLAYER_ID) {
            TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block]);
        }
    }
    return 1;
}

stock SnakeGame:HideGameBlock(gameid, block) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];
        if (playerid != INVALID_PLAYER_ID) {
            TextDrawHideForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block]);
        }
    }
    return 1;
}

stock SnakeGame:GetFoodBlocks(gameid) {
    new b_count;
    for (new b; b < SNAKE_GRID_SIZE; b++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] == SNAKE_BLOCK_DATA_FOOD) { b_count++; }
    }
    return b_count;
}

stock SnakeGame:GetEmptyBlock(gameid, block_array[], block_limit) {
    new block_count;
    for (new block; block < SNAKE_GRID_SIZE; block++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][block] == INVALID_PLAYER_ID) {
            if (block_count >= block_limit) { return block_count; }
            block_array[block_count++] = block;
        }
    }
    return block_count;
}

stock SnakeGame:GetRandomEmptyBlock(gameid) {
    new empty_block_array[SNAKE_GRID_SIZE], empty_block_count;
    empty_block_count = SnakeGame:GetEmptyBlock(gameid, empty_block_array, SNAKE_GRID_SIZE);
    if (empty_block_count == 0) { return INVALID_SNAKE_GAME_BLOCK; }
    new random_index = random(empty_block_count), random_block = empty_block_array[random_index];
    return random_block;
}

stock SnakeGame:SortSnakePlayers(gameid) {
    for (new p1; p1 < MAX_SNAKE_PLAYERS; p1++) {
        new playerid_1 = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p1];
        if (playerid_1 == INVALID_PLAYER_ID) { continue; }

        new bool:alive_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeAlive],
            size_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeSize],
            kills_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeKills],
            pos_1;

        for (new p2; p2 < MAX_SNAKE_PLAYERS; p2++) {
            new playerid_2 = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p2];
            if (playerid_2 == INVALID_PLAYER_ID) { continue; }

            new bool:alive_2 = SnakeGame:PlayerData[playerid_2][SnakeGame:PlayerSnakeAlive],
                size_2 = SnakeGame:PlayerData[playerid_2][SnakeGame:PlayerSnakeSize],
                kills_2 = SnakeGame:PlayerData[playerid_2][SnakeGame:PlayerSnakeKills];

            if (size_2 > size_1) {
                pos_1++;
            } else if (size_1 > size_2) {

            } else if (kills_2 > kills_1) {
                pos_1++;
            } else if (kills_1 > kills_2) {

            } else if (alive_2 && !alive_1) {
                pos_1++;
            } else if (!alive_2 && alive_1) {

            } else if (p1 > p2) {
                pos_1++;
            }
        }
        if (pos_1 < MAX_SNAKE_PLAYERS) { SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][pos_1] = playerid_1; }
    }
    return 1;
}

stock SnakeGame:RefreshPlrForPlr(td_playerid) {
    new gameid = SnakeGame:PlayerData[td_playerid][SnakeGame:PlayerGameID];
    if (gameid == INVALID_SNAKE_GAME) { return 0; }

    for (new row; row < SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]; row++) {
        new row_playerid = SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][row];
        if (row_playerid == INVALID_PLAYER_ID) { continue; }

        new bool:alive = SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeAlive],
            slot = SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeSlot],
            color = SnakeGame:Colors[slot],
            player_str[6 + MAX_PLAYER_NAME + 1],
            size_str[10 + 1],
            kills_str[10 + 1];

        format(player_str, sizeof player_str, "[%i] %s", row_playerid, GetPlayerNameEx(row_playerid));
        PlayerTextDrawSetString(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], player_str);
        PlayerTextDrawColor(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row], color);
        PlayerTextDrawShow(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row]);

        format(size_str, sizeof size_str, "%i", SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeSize]);
        PlayerTextDrawSetString(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], size_str);
        PlayerTextDrawColor(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row], color);
        PlayerTextDrawShow(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row]);

        format(kills_str, sizeof kills_str, "%i", SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeKills]);
        PlayerTextDrawSetString(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], kills_str);
        PlayerTextDrawColor(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row], color);
        PlayerTextDrawShow(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row]);

        PlayerTextDrawSetString(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], alive ? ("Yes") : ("No"));
        PlayerTextDrawColor(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row], color);
        PlayerTextDrawShow(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row]);
    }

    for (new row = SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]; row < MAX_SNAKE_PLAYERS; row++) {
        PlayerTextDrawHide(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_PLAYER_ROW][row]);
        PlayerTextDrawHide(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_SIZE_ROW][row]);
        PlayerTextDrawHide(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_KILLS_ROW][row]);
        PlayerTextDrawHide(td_playerid, SnakeGame:TextDrawDataPlayerGame[td_playerid][SnakeGame:TD_PGAME_PTD_ALIVE_ROW][row]);
    }

    return 1;
}

stock SnakeGame:RefreshSnakePlayers(gameid) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new l_playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];
        if (l_playerid != INVALID_PLAYER_ID) { SnakeGame:RefreshPlrForPlr(l_playerid); }
    }
    return 1;
}

stock SnakeGame:JoinGame(j_playerid, gameid, playerslot) {
    if (SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) return 0;
    new random_block = SnakeGame:GetRandomEmptyBlock(gameid);
    if (random_block == INVALID_SNAKE_GAME_BLOCK) return 0;
    if (playerslot < 0 || playerslot >= MAX_SNAKE_PLAYERS) return 0;
    if (SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][playerslot] != INVALID_PLAYER_ID) return 0;
    SnakeGame:ShowTextdraws(j_playerid, SNAKE_TDMODE_GAME);

    SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][playerslot] = j_playerid;
    SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]++;
    SnakeGame:GameData[gameid][SnakeGame:GameBlockData][random_block] = j_playerid;
    SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime() + SNAKE_COUNTDOWN_S;

    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeSlot] = playerslot;
    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerGameID] = gameid;
    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeAlive] = true;
    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeSize] = 1;
    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeKills] = 0;
    SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeBlocks][0] = random_block;

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new l_playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];
        if (l_playerid == INVALID_PLAYER_ID || l_playerid == j_playerid) continue;
        SnakeGame:ShowBlockForPlayer(j_playerid, SnakeGame:PlayerData[l_playerid][SnakeGame:PlayerSnakeBlocks][0], SnakeGame:Colors[p]); // Show other snakes for joined player
    }

    SnakeGame:ShowGameBlock(gameid, SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeBlocks][0], SnakeGame:Colors[playerslot]); // Show joined snake for all players

    for (new b; b < SNAKE_GRID_SIZE; b++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] == SNAKE_BLOCK_DATA_FOOD) {
            SnakeGame:ShowBlockForPlayer(j_playerid, b, RGBA_WHITE); // Show food for joined player
        }
    }

    TogglePlayerControllable(j_playerid, false);
    PlayerPlaySound(j_playerid, 1068, 0.0, 0.0, 0.0);
    SnakeGame:SortSnakePlayers(gameid), SnakeGame:RefreshSnakePlayers(gameid);
    return 1;
}

stock SnakeGame:ShowBlockForPlayer(playerid, block, color) {
    TextDrawBoxColor(SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block], color);
    TextDrawShowForPlayer(playerid, SnakeGame:TextDrawDataGame[SnakeGame:TD_GAME_BLOCK][block]);
    return 1;
}

stock SnakeGame:FindGameToJoin() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_COUNTDOWN && SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] < SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
            return gameid;
        }
    }
    return INVALID_SNAKE_GAME;
}

stock SnakeGame:FindEmptyGame() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_NONE) {
            return gameid;
        }
    }
    return INVALID_SNAKE_GAME;
}

stock SnakeGame:GetSnakeFreePlayerSlot(gameid) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p] == INVALID_PLAYER_ID) {
            return p;
        }
    }
    return INVALID_SNAKE_PLAYER_SLOT;
}

stock SnakeGame:ApplyJoinGamePage(playerid) {
    PlayerTextDrawSetString(
        playerid,
        SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPAGE],
        sprintf("page %i", SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] + 1)
    );
    return 1;
}

stock SnakeGame:ApplyJoinGameID(playerid) {
    new offset = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE;
    for (new row, gameid, str[2 + 1]; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++) {
        gameid = offset + row;
        if (gameid >= 0 && gameid < MAX_SNAKE_GAMES) {
            format(str, sizeof str, "%i", gameid + 1);
            PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row], str);
            PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row]);
        } else {
            PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdGAMEROW][row]);
        }
    }
    return 1;
}

stock SnakeGame:ApplyJoinGamePlayers(playerid) {
    new gameid = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE, playerslot;

    for (new idx; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        if (gameid < MAX_SNAKE_GAMES) {
            new snake_playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][playerslot];

            if (snake_playerid == INVALID_PLAYER_ID) {
                if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_COUNTDOWN && SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] < SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx], "<join game>");
                    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
                } else {
                    PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
                }
            } else {
                PlayerTextDrawSetString(
                    playerid,
                    SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx],
                    sprintf("[%i] %s", snake_playerid, GetPlayerNameEx(snake_playerid))
                );
                PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
            }
        } else {
            PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerJoin[playerid][SnakeGame:PlayerTdPBUTTON][idx]);
        }

        if (++playerslot == MAX_SNAKE_PLAYERS) {
            gameid++, playerslot = 0;
        }
    }
    return 1;
}

stock SnakeGame:ApplyScorePage(playerid) {
    PlayerTextDrawSetString(
        playerid,
        SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PAGE],
        sprintf("page %i", SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] + 1)
    );
    return 1;
}

stock SnakeGame:ApplyScoreRow(playerid) {
    new offset = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScorePage] * MAX_SNAKE_SCORE_PAGESIZE,
        DBResult:db_result,
        rows, g_SnakeScoreQuery[512];

    switch (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort]) {
        case SNAKE_SCORE_SORT_PLAYER_D:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY playername DESC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_PLAYER_A:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY playername ASC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_SIZE_D:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY size DESC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_SIZE_A:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY size ASC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_KILLS_D:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY kills DESC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_KILLS_A:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY kills ASC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_D:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY scoretimedate DESC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_A:  {
            format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "SELECT *, (DATETIME(scoretimedate, 'localtime')) AS localscoretimedate FROM snakescore ORDER BY scoretimedate ASC LIMIT %i OFFSET %i", MAX_SNAKE_SCORE_PAGESIZE, offset);
        }
    }

    db_result = db_query(SnakeGame:ScoreDB, g_SnakeScoreQuery);

    rows = db_num_rows(db_result);

    for (new row, rank[10 + 1], pname[MAX_PLAYER_NAME + 1], size[10 + 1], kills[10 + 1], timedate[19 + 1]; row < rows; row++) {
        format(rank, sizeof rank, "%i", offset + row + 1);
        db_get_field_assoc(db_result, "playername", pname, MAX_PLAYER_NAME + 1);
        db_get_field_assoc(db_result, "size", size, sizeof size);
        db_get_field_assoc(db_result, "kills", kills, sizeof kills);
        db_get_field_assoc(db_result, "localscoretimedate", timedate, sizeof timedate);
        db_next_row(db_result);

        PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row], rank);
        PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row], pname);
        PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row], size);
        PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row], kills);
        PlayerTextDrawSetString(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row], timedate);

        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row]);
        PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row]);
    }

    db_free_result(db_result);

    for (new row = rows; row < MAX_SNAKE_SCORE_PAGESIZE; row++) {
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_RANK][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_PLAYER][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_SIZE][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_KILLS][row]);
        PlayerTextDrawHide(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_TIMEDATE][row]);
    }
    return 1;
}

stock SnakeGame:ApplyScoreSorting(playerid) {
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_PLAYER], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_SIZE], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_KILLS], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_TIMEDATE], 0xFFFFFF32);

    switch (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeScoreSort]) {
        case SNAKE_SCORE_SORT_PLAYER_D:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_PLAYER], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_PLAYER_A:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_PLAYER], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_SIZE_D:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_SIZE], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_SIZE_A:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_SIZE], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_KILLS_D:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_KILLS], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_KILLS_A:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_KILLS], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_D:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_TIMEDATE], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_A:  {
            PlayerTextDrawBoxColor(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_TIMEDATE], 0xFF000032);
        }
    }

    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_PLAYER]);
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_SIZE]);
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_KILLS]);
    PlayerTextDrawShow(playerid, SnakeGame:TextDrawDataPlayerScore[playerid][SnakeGame:Td_SCORE_PTD_COL][SnakeGame:Td_SCORE_COL_TIMEDATE]);
    return 1;
}

stock SnakeGame:IsDirectionAllowed(direction, last_direction) {
    if (direction == SNAKE_DIRECTION_D && last_direction == SNAKE_DIRECTION_U) return 0;
    if (direction == SNAKE_DIRECTION_U && last_direction == SNAKE_DIRECTION_D) return 0;
    if (direction == SNAKE_DIRECTION_L && last_direction == SNAKE_DIRECTION_R) return 0;
    if (direction == SNAKE_DIRECTION_R && last_direction == SNAKE_DIRECTION_L) return 0;
    return 1;
}

stock SnakeGame:ApplyDirection(playerid) {
    new keys, ud, lr, direction;
    GetPlayerKeys(playerid, keys, ud, lr);

    if (ud == KEY_UP) {
        direction = SNAKE_DIRECTION_U;
    } else if (ud == KEY_DOWN) {
        direction = SNAKE_DIRECTION_D;
    } else if (lr == KEY_LEFT) {
        direction = SNAKE_DIRECTION_L;
    } else if (lr == KEY_RIGHT) {
        direction = SNAKE_DIRECTION_R;
    } else {
        return 1;
    }

    if (
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] == 1 ||
        SnakeGame:IsDirectionAllowed(direction, SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeLastDirection])
    ) {
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeNextDirection] = direction;
    }
    return 1;
}

stock SnakeGame:PlayerLeave(playerid) {
    new gameid = SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID];

    if (gameid == INVALID_SNAKE_GAME) {
        return 0;
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
        SnakeGame:KillSnake(playerid);
    } else {
        SnakeGame:SortSnakePlayers(gameid), SnakeGame:RefreshSnakePlayers(gameid);
    }

    SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]--;
    SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot]] = INVALID_PLAYER_ID;

    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot] = INVALID_SNAKE_PLAYER_SLOT;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] = INVALID_SNAKE_GAME;

    SnakeGame:HidePlayerTextdraws(playerid);
    PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0); // Stop music
    TogglePlayerControllable(playerid, true);
    if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] <= 0) {
        SnakeGame:DefaultGameSnakeData(gameid);
    }
    return 1;
}

stock SnakeGame:Start(playerid) {
    SnakeGame:ShowTextdraws(playerid, SNAKE_TDMODE_MENU);
    SelectTextDraw(playerid, RGBA_RED);
    return 1;
}