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

new const g_SnakeColors[MAX_SNAKE_PLAYERS] = {
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
    SnakeGame:PlayerSnakeTextDrawMode
}

new SnakeGame:GameData[MAX_SNAKE_GAMES][SnakeGame:EnumGameData];
new SnakeGame:PlayerData[MAX_PLAYERS][e_PlayerSnakeData];
new SnakeGame:GameUpdateTimer = INVALID_SNAKE_TIMER;

//------------------------------------------------------------------------------
// Game Textdraws

#define MAX_SNAKE_GAME_GTD 7
enum E_SNAKE_GAME_GTD { // Generic Textdraws
    Text:SNAKE_GAME_GTD_BG,
    Text:SNAKE_GAME_GTD_BLOCK[SNAKE_GRID_SIZE],
    Text:SNAKE_GAME_GTD_PLAYER_COL,
    Text:SNAKE_GAME_GTD_SIZE_COL,
    Text:SNAKE_GAME_GTD_KILLS_COL,
    Text:SNAKE_GAME_GTD_ALIVE_COL,
}

#define MAX_SNAKE_GAME_PTD 6
enum E_SNAKE_GAME_PTD { // Player Textdraws
    PlayerText:SNAKE_GAME_PTD_COUNTDOWN,
    PlayerText:SNAKE_GAME_PTD_XKEYS,
    PlayerText:SNAKE_GAME_PTD_PLAYER_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SNAKE_GAME_PTD_SIZE_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SNAKE_GAME_PTD_KILLS_ROW[MAX_SNAKE_PLAYERS],
    PlayerText:SNAKE_GAME_PTD_ALIVE_ROW[MAX_SNAKE_PLAYERS]
}

new Text:g_SnakeGameGTextdraw[E_SNAKE_GAME_GTD];
new PlayerText:g_SnakeGamePTextdraw[MAX_PLAYERS][E_SNAKE_GAME_PTD];

//------------------------------------------------------------------------------
// Menu Textdraws

#define MAX_SNAKE_MENU_RBUTTONS 6
enum E_SNAKE_MENU_RBUTTONS { // Menu Row Buttons
    Text:SNAKE_MENU_RBUTTON_SP,
    Text:SNAKE_MENU_RBUTTON_MP,
    Text:SNAKE_MENU_RBUTTON_CREATE,
    Text:SNAKE_MENU_RBUTTON_JOIN,
    Text:SNAKE_MENU_RBUTTON_SCORE,
    Text:SNAKE_MENU_RBUTTON_KEYS
}

#define MAX_SNAKE_MENU_GTEXTDRAWS 4
enum E_SNAKE_MENU_GTEXTDRAWS { // Generic Textdraws
    Text:SNAKE_MENU_GTD_BG, // Background
    Text:SNAKE_MENU_GTD_TITLE, // Title / Caption
    Text:SNAKE_MENU_GTD_XBUTTON, // Close Button
    Text:SNAKE_MENU_GTD_RBUTTON[E_SNAKE_MENU_RBUTTONS] // Row Button
}

new Text:g_SnakeMenuGTextdraw[E_SNAKE_MENU_GTEXTDRAWS];

//------------------------------------------------------------------------------
// New Game Textdraws

#define MAX_SNAKE_NEWGAME_TBUTTONS 2
enum E_SNAKE_NEWGAME_TBUTTONS { // New Game Tiny Buttons
    Text:SNAKE_NEWGAME_TBUTTON_X, // Close
    Text:SNAKE_NEWGAME_TBUTTON_B // Back
}

#define MAX_SNAKE_NEWGAME_GTEXTDRAWS 4
enum E_SNAKE_NEWGAME_GTEXTDRAWS { // Generic Textdraws
    Text:SNAKE_NEWGAME_GTD_BG,
    Text:SNAKE_NEWGAME_GTD_TITLE,
    Text:SNAKE_NEWGAME_GTD_TBUTTON[E_SNAKE_NEWGAME_TBUTTONS], // Tiny Button
    Text:SNAKE_NEWGAME_GTD_PBUTTON[MAX_SNAKE_PLAYERS] // Player Button
}

new Text:g_SnakeNewGameGTextdraw[E_SNAKE_NEWGAME_GTEXTDRAWS];

//------------------------------------------------------------------------------
// Join Game Textdraws

#define MAX_SNAKE_JOINGAME_PAGESIZE 15

#define MIN_SNAKE_JOINGAME_PAGE 0

    #define MAX_SNAKE_JOINGAME_PAGE \
((MAX_SNAKE_GAMES - 1) / MAX_SNAKE_JOINGAME_PAGESIZE)

#define MAX_SNAKE_JOINGAME_PBUTTONS \
(MAX_SNAKE_PLAYERS * MAX_SNAKE_JOINGAME_PAGESIZE)

#define MAX_SNAKE_JOINGAME_TBUTTONS 6
enum E_SNAKE_JOINGAME_TBUTTONS { // Tiny Buttons
    Text:SNAKE_JOINGAME_TBUTTON_X, // Close
    Text:SNAKE_JOINGAME_TBUTTON_B, // Back
    Text:SNAKE_JOINGAME_TBUTTON_PAGE_F, // First Page
    Text:SNAKE_JOINGAME_TBUTTON_PAGE_P, // Previous Page
    Text:SNAKE_JOINGAME_TBUTTON_PAGE_N, // Next Page
    Text:SNAKE_JOINGAME_TBUTTON_PAGE_L // Last Page
}

#define MAX_SNAKE_JOINGAME_GTEXTDRAWS 5
enum E_SNAKE_JOINGAME_GTEXTDRAWS { // Generic Textdraws
    Text:SNAKE_JOINGAME_GTD_BG, // Background Box
    Text:SNAKE_JOINGAME_GTD_TITLE, // Title / Caption
    Text:SNAKE_JOINGAME_GTD_GCOL, // Game ID Column
    Text:SNAKE_JOINGAME_GTD_PCOL[MAX_SNAKE_PLAYERS], // Player Column
    Text:SNAKE_JOINGAME_GTD_TBUTTON[E_SNAKE_JOINGAME_TBUTTONS] // Tiny Button
}

#define MAX_SNAKE_JOINGAME_PTEXTDRAWS 3
enum E_SNAKE_JOINGAME_PTEXTDRAWS { // Player Textdraws
    PlayerText:SNAKE_JOINGAME_PTD_PAGE, // Current Page
    PlayerText:SNAKE_JOINGAME_PTD_GAMEROW[MAX_SNAKE_JOINGAME_PAGESIZE], // Game Row
    PlayerText:SNAKE_JOINGAME_PTD_PBUTTON[MAX_SNAKE_JOINGAME_PBUTTONS] // Player Button
}
new PlayerText:g_SnakeJoinGamePTextdraw[MAX_PLAYERS][E_SNAKE_JOINGAME_PTEXTDRAWS];

enum e_SnakeJoinGameData {
    e_SnakeJoinGamePage
}

new Text:g_SnakeJoinGameGTextdraw[E_SNAKE_JOINGAME_GTEXTDRAWS];
new g_SnakeJoinGameData[MAX_PLAYERS][e_SnakeJoinGameData];

//------------------------------------------------------------------------------
// Score Textdraws

#define MAX_SNAKE_SCORE_PAGESIZE 15

#define MAX_SNAKE_SCORE_QUERYLEN 1000

#define MIN_SNAKE_SCORE_PAGE 0

#define MAX_SNAKE_SCORE_PAGE 2147483646 // max 32 bit integer value - 1

#define MAX_SNAKE_SCORE_TBUTTONS 6
enum E_SNAKE_SCORE_TBUTTONS { // Tiny Buttons
    Text:SNAKE_SCORE_TBUTTON_X, // Close
    Text:SNAKE_SCORE_TBUTTON_B, // Back
    Text:SNAKE_SCORE_TBUTTON_PAGE_F, // First Page
    Text:SNAKE_SCORE_TBUTTON_PAGE_P, // Previous Page
    Text:SNAKE_SCORE_TBUTTON_PAGE_N, // Next Page
    Text:SNAKE_SCORE_TBUTTON_PAGE_L // Last Page

}

#define MAX_SNAKE_SCORE_COLUMNS 5
enum E_SNAKE_SCORE_COLUMNS { // Columns
    PlayerText:SNAKE_SCORE_COL_RANK,
    PlayerText:SNAKE_SCORE_COL_PLAYER,
    PlayerText:SNAKE_SCORE_COL_SIZE,
    PlayerText:SNAKE_SCORE_COL_KILLS,
    PlayerText:SNAKE_SCORE_COL_TIMEDATE

}

#define MAX_SNAKE_SCORE_GTEXTDRAWS 3
enum E_SNAKE_SCORE_GTEXTDRAWS { // Generic Textdraws
    Text:SNAKE_SCORE_GTD_BG, // Background Box
    Text:SNAKE_SCORE_GTD_TITLE, // Title / Caption
    Text:SNAKE_SCORE_GTD_TBUTTON[E_SNAKE_SCORE_TBUTTONS] // Tiny Buttons
}
new Text:g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS];


enum { // Sort Modes
    SNAKE_SCORE_SORT_PLAYER_D, // Players in alphabetical order, descending
    SNAKE_SCORE_SORT_PLAYER_A, // Players in alphabetical order, ascending
    SNAKE_SCORE_SORT_SIZE_D, // Size in order, descending
    SNAKE_SCORE_SORT_SIZE_A, // Size in order, ascending
    SNAKE_SCORE_SORT_KILLS_D, // Kills in order, descending
    SNAKE_SCORE_SORT_KILLS_A, // Kills in order, ascending
    SNAKE_SCORE_SORT_TIMEDATE_D, // Time & Date in order, descending
    SNAKE_SCORE_SORT_TIMEDATE_A // Time & Date in order, ascending
}

enum e_SnakeScoreData {
    e_SnakeScorePage,
    e_SnakeScoreSort
}

#define MAX_SNAKE_SCORE_PTEXTDRAWS 7
enum E_SNAKE_SCORE_PTEXTDRAWS { // Player Textdraws
    PlayerText:SNAKE_SCORE_PTD_PAGE, // Page
    PlayerText:SNAKE_SCORE_PTD_COL[E_SNAKE_SCORE_COLUMNS], // Columns
    PlayerText:SNAKE_SCORE_PTD_RANK[MAX_SNAKE_SCORE_PAGESIZE], // Rank Row
    PlayerText:SNAKE_SCORE_PTD_PLAYER[MAX_SNAKE_SCORE_PAGESIZE], // Player Row
    PlayerText:SNAKE_SCORE_PTD_SIZE[MAX_SNAKE_SCORE_PAGESIZE], // Size Row
    PlayerText:SNAKE_SCORE_PTD_KILLS[MAX_SNAKE_SCORE_PAGESIZE], // Kill Rows
    PlayerText:SNAKE_SCORE_PTD_TIMEDATE[MAX_SNAKE_SCORE_PAGESIZE] // Time & Date Rows

}
new PlayerText:g_SnakeScorePTextdraw[MAX_PLAYERS][E_SNAKE_SCORE_PTEXTDRAWS];

new Text:g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS];
new g_SnakeScoreData[MAX_PLAYERS][e_SnakeScoreData];
new DB:SnakeGame:ScoreDB;
new g_SnakeScoreQuery[MAX_SNAKE_SCORE_QUERYLEN + 1];

//------------------------------------------------------------------------------
// Key Textdraws

#define MAX_SNAKE_KEY_TBUTTONS 2
enum E_SNAKE_KEY_TBUTTONS { // Tiny Buttons
    Text:SNAKE_KEY_TBUTTON_X, // Close
    Text:SNAKE_KEY_TBUTTON_B // Back
}

#define MAX_SNAKE_KEY_KEYACTIONS 5
enum E_SNAKE_KEY_KEYACTIONS { // Key + Action
    PlayerText:SNAKE_KEY_KEYACTION_L, // Left
    PlayerText:SNAKE_KEY_KEYACTION_R, // Right
    PlayerText:SNAKE_KEY_KEYACTION_D, // Down
    PlayerText:SNAKE_KEY_KEYACTION_U, // Up
    PlayerText:SNAKE_KEY_KEYACTION_X // Close
}

#define MAX_SNAKE_KEY_GTEXTDRAWS 6
enum E_SNAKE_KEY_GTEXTDRAWS { // Generic Textdraws
    Text:SNAKE_KEY_GTD_BG, // Background Box
    Text:SNAKE_KEY_GTD_TITLE, // Title / Caption
    Text:SNAKE_KEY_GTD_TBUTTON[E_SNAKE_KEY_TBUTTONS], // Tiny Buttons
    Text:SNAKE_KEY_GTD_KEY_COL, // Keystroke Column
    Text:SNAKE_KEY_GTD_ACTION_COL, // Action Column
    Text:SNAKE_KEY_GTD_ACTION_ROW[E_SNAKE_KEY_KEYACTIONS] // Action Row
}

#define MAX_SNAKE_KEY_PTEXTDRAWS 1
enum E_SNAKE_KEY_PTEXTDRAWS { // Player Textdraws
    PlayerText:SNAKE_KEY_PTD_KEY_ROW[E_SNAKE_KEY_KEYACTIONS] // Key Row
}

new Text:g_SnakeKeyGTextdraw[E_SNAKE_KEY_GTEXTDRAWS];
new PlayerText:g_SnakeKeyPTextdraw[MAX_PLAYERS][E_SNAKE_KEY_PTEXTDRAWS];

//------------------------------------------------------------------------------

CreateSnakeGameGTextdraws() {
    g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG] =
        TextDrawCreate(320.0, 49.0, "_");
    TextDrawAlignment(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG], 0.0, 39.2);
    TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG], 150);
    TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG], 0.0, 270.0);

    g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL] =
        TextDrawCreate(185.0, 329.0, "Player");
    TextDrawBackgroundColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 255);
    TextDrawFont(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 1);
    TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], -1);
    TextDrawSetOutline(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 1);
    TextDrawSetProportional(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 1);
    TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 1);
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], -206);
    TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL], 365.0, 0.0);

    g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL] =
        TextDrawCreate(368.0, 329.0, "Size");
    TextDrawBackgroundColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 255);
    TextDrawFont(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 1);
    TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], -1);
    TextDrawSetOutline(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 1);
    TextDrawSetProportional(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 1);
    TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 1);
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], -206);
    TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL], 395.0, 0.0);

    g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL] =
        TextDrawCreate(398.0, 329.0, "Kills");
    TextDrawBackgroundColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 255);
    TextDrawFont(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 1);
    TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], -1);
    TextDrawSetOutline(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 1);
    TextDrawSetProportional(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 1);
    TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 1);
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], -206);
    TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL], 425.0, 0.0);

    g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL] =
        TextDrawCreate(428.0, 329.0, "Alive");
    TextDrawBackgroundColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 255);
    TextDrawFont(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 1);
    TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], -1);
    TextDrawSetOutline(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 1);
    TextDrawSetProportional(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 1);
    TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 1);
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], -206);
    TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL], 455.0, 0.0);

    for (new block, x, y; block < SNAKE_GRID_SIZE; block++) {
        g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block] =
            TextDrawCreate(194.0 + (x * 18.0), 310.0 - (y * 17.0), "_");
        TextDrawAlignment(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], 2);
        TextDrawLetterSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], 0.0, 1.5);
        TextDrawUseBox(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], 1);
        TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], RGBA_WHITE);
        TextDrawTextSize(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], 0.0, 15.0);

        if (++x > MAX_SNAKE_WIDTH) {
            y++, x = 0;
        }
    }
}

DestroySnakeGameGTextdraws() {
    for (new td; td < MAX_SNAKE_GAME_GTD; td++) {
        TextDrawDestroy(g_SnakeGameGTextdraw[E_SNAKE_GAME_GTD:td]);
        g_SnakeGameGTextdraw[E_SNAKE_GAME_GTD:td] = Text:INVALID_TEXT_DRAW;
    }
}

CreateSnakeGamePTextdraws(playerid) {
    g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN] =
        CreatePlayerTextDraw(playerid, 320.0, 49.0, "_");
    PlayerTextDrawAlignment(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 2);
    PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 255);
    PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 2);
    PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 0.4, 2.0);
    PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], -1);
    PlayerTextDrawSetOutline(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawUseBox(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 1);
    PlayerTextDrawBoxColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], -206);
    PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], 0.0, 270.0);

    new keystr[108 + 1];

    switch (GetPlayerState(playerid)) {
        case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:  {
            keystr = "~w~press ~r~~k~~VEHICLE_ENTER_EXIT~~w~ + ~r~~k~~VEHICLE_HORN~~w~ + ~r~~k~~VEHICLE_BRAKE~~w~ to stop playing.";
        }
        default:  {
            keystr = "~w~press ~r~~k~~VEHICLE_ENTER_EXIT~~w~ + ~r~~k~~PED_DUCK~~w~ + ~r~~k~~PED_JUMPING~~w~ to stop playing.";
        }
    }

    g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS] =
        CreatePlayerTextDraw(playerid, 320.0, 393.0, keystr);
    PlayerTextDrawAlignment(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 2);
    PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 255);
    PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 2);
    PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 0.2, 1.0);
    PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], -1);
    PlayerTextDrawSetOutline(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 1);
    PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 1);
    PlayerTextDrawUseBox(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 1);
    PlayerTextDrawBoxColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], -206);
    PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS], 0.0, 270.0);

    for (new row, Float:y = 342.0; row < MAX_SNAKE_PLAYERS; row++, y += 13.0) {
        g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row] =
            CreatePlayerTextDraw(playerid, 185.0, y, "Player");
        PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], 365.0, 0.0);

        g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row] =
            CreatePlayerTextDraw(playerid, 368.0, y, "Size");
        PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_SIZE_ROW][row], 395.0, 0.0);

        g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row] =
            CreatePlayerTextDraw(playerid, 398.0, y, "Kills");
        PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_KILLS_ROW][row], 425.0, 0.0);

        g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row] =
            CreatePlayerTextDraw(playerid, 428.0, y, "Alive");
        PlayerTextDrawBackgroundColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 1);
        PlayerTextDrawTextSize(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], 455.0, 0.0);
    }
    return 1;
}

DestroySnakeGamePTextdraws(playerid) {
    for (new td; td < MAX_SNAKE_GAME_PTD; td++) {
        PlayerTextDrawDestroy(playerid, g_SnakeGamePTextdraw[playerid][E_SNAKE_GAME_PTD:td]);
        g_SnakeGamePTextdraw[playerid][E_SNAKE_GAME_PTD:td] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

//------------------------------------------------------------------------------

CreateSnakeMenuGTextdraws() {
    g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG] = TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG], 0.0, 13.4);
    TextDrawUseBox(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG], 100);
    TextDrawTextSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_BG], 0.0, 160.0);

    g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE] = TextDrawCreate(243.0, 103.0, "Snake Menu");
    TextDrawBackgroundColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], 255);
    TextDrawFont(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], 0);
    TextDrawLetterSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], -1);
    TextDrawSetOutline(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], 1);
    TextDrawSetProportional(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_TITLE], 1);

    for (new btn, Float:y = 132.0, str[22 + 1]; btn < MAX_SNAKE_MENU_RBUTTONS; btn++, y += 18.0) {
        switch (btn) {
            case SNAKE_MENU_RBUTTON_SP:  {
                str = "Singleplayer";
            }
            case SNAKE_MENU_RBUTTON_MP:  {
                str = "Multiplayer";
            }
            case SNAKE_MENU_RBUTTON_CREATE:  {
                str = "Create Game";
            }
            case SNAKE_MENU_RBUTTON_JOIN:  {
                str = "Join Game";
            }
            case SNAKE_MENU_RBUTTON_SCORE:  {
                str = "View Highscore";
            }
            case SNAKE_MENU_RBUTTON_KEYS:  {
                str = "Keys";
            }
            default:  {
                continue;
            }
        }

        g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn] = TextDrawCreate(320.0, y, str);
        TextDrawAlignment(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 2);
        TextDrawBackgroundColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 255);
        TextDrawFont(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 1);
        TextDrawLetterSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 0.3, 1.5);
        TextDrawColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], -1);
        TextDrawSetOutline(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 0);
        TextDrawSetProportional(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 1);
        TextDrawSetShadow(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 1);
        TextDrawUseBox(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 1);
        TextDrawBoxColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], -16777116);
        TextDrawTextSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 13.0, 160.0);
        TextDrawSetSelectable(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][E_SNAKE_MENU_RBUTTONS:btn], 1);
    }

    g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON] = TextDrawCreate(390.0, 115.0, "x");
    TextDrawAlignment(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 2);
    TextDrawBackgroundColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 255);
    TextDrawFont(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 2);
    TextDrawLetterSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 0.2, 1.1);
    TextDrawColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], -1);
    TextDrawSetOutline(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 1);
    TextDrawSetProportional(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 1);
    TextDrawUseBox(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 1);
    TextDrawBoxColor(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], -16777116);
    TextDrawTextSize(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 9.0, 20.0);
    TextDrawSetSelectable(g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON], 1);
}

DestroySnakeMenuGTextdraws() {
    for (new td; td < MAX_SNAKE_MENU_GTEXTDRAWS; td++) {
        TextDrawDestroy(g_SnakeMenuGTextdraw[E_SNAKE_MENU_GTEXTDRAWS:td]);
        g_SnakeMenuGTextdraw[E_SNAKE_MENU_GTEXTDRAWS:td] = Text:INVALID_TEXT_DRAW;
    }
}

//------------------------------------------------------------------------------

CreateSnakeNewGameGTextdraws() {
    g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG] = TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG], 0.0, 9.4);
    TextDrawUseBox(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG], 100);
    TextDrawTextSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_BG], 0.0, 200.0);

    g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE] = TextDrawCreate(221.0, 103.0, "Create Snake Game");
    TextDrawBackgroundColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], 255);
    TextDrawFont(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], 0);
    TextDrawLetterSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], -1);
    TextDrawSetOutline(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], 1);
    TextDrawSetProportional(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TITLE], 1);

    for (new btn, Float:y = 132.0, str[10 + 1]; btn < MAX_SNAKE_PLAYERS; btn++, y += 18.0) {
        format(str, sizeof str, "%i %s", btn + 1, (btn == 0) ? ("Player") : ("Players"));

        g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn] = TextDrawCreate(320.0, y, str);
        TextDrawAlignment(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 2);
        TextDrawBackgroundColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 255);
        TextDrawFont(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 1);
        TextDrawLetterSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 0.3, 1.5);
        TextDrawColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], -1);
        TextDrawSetOutline(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 0);
        TextDrawSetProportional(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 1);
        TextDrawSetShadow(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 1);
        TextDrawUseBox(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 1);
        TextDrawBoxColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], -16777116);
        TextDrawTextSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 13.0, 200.0);
        TextDrawSetSelectable(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn], 1);
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

        g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn] = TextDrawCreate(x, 115.0, str);
        TextDrawAlignment(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 2);
        TextDrawBackgroundColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 255);
        TextDrawFont(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 2);
        TextDrawLetterSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 0.2, 1.1);
        TextDrawColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], -1);
        TextDrawSetOutline(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 1);
        TextDrawSetProportional(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 1);
        TextDrawUseBox(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 1);
        TextDrawBoxColor(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], -16777116);
        TextDrawTextSize(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 10.0, 20.0);
        TextDrawSetSelectable(g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][E_SNAKE_NEWGAME_TBUTTONS:btn], 1);
    }
}

DestroySnakeNewGameGTextdraws() {
    for (new td; td < MAX_SNAKE_NEWGAME_GTEXTDRAWS; td++) {
        TextDrawDestroy(g_SnakeNewGameGTextdraw[E_SNAKE_NEWGAME_GTEXTDRAWS:td]);
        g_SnakeNewGameGTextdraw[E_SNAKE_NEWGAME_GTEXTDRAWS:td] = Text:INVALID_TEXT_DRAW;
    }
}

//------------------------------------------------------------------------------

CreateSnakeJoinGameGTextdraws() {
    g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG] = TextDrawCreate(320.0, 105.0, "_"); // Background
    TextDrawAlignment(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG], 0.0, 24.9);
    TextDrawUseBox(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG], 100);
    TextDrawTextSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_BG], 0.0, 364.0);

    g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE] = TextDrawCreate(140.0, 92.0, "Join Game"); // Title
    TextDrawBackgroundColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], 255);
    TextDrawFont(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], 0);
    TextDrawLetterSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], -1);
    TextDrawSetOutline(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], 1);
    TextDrawSetProportional(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TITLE], 1);

    g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL] = TextDrawCreate(140.0, 122.0, "Game ID"); // Game ID Column
    TextDrawBackgroundColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 255);
    TextDrawFont(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 1);
    TextDrawLetterSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 0.2, 1.0);
    TextDrawColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], -1);
    TextDrawSetOutline(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 1);
    TextDrawSetProportional(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 1);
    TextDrawUseBox(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 1);
    TextDrawBoxColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 0xFFFFFF32);
    TextDrawTextSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_GCOL], 180.0, 9.0);

    for (new col, Float:x, str[8 + 1]; col < MAX_SNAKE_PLAYERS; col++) {
        x = 180.0 + (col * 80.0);

        format(str, sizeof str, "Player %i", col + 1); // Player Column

        g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col] = TextDrawCreate(x + 4.0, 122.0, str);
        TextDrawBackgroundColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 255);
        TextDrawFont(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 1);
        TextDrawLetterSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 0.2, 1.0);
        TextDrawColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], g_SnakeColors[col]);
        TextDrawSetOutline(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 1);
        TextDrawSetProportional(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 1);
        TextDrawUseBox(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 1);
        TextDrawBoxColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], 0xFFFFFF32);
        TextDrawTextSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_PCOL][col], x + 80.0, 9.0);
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

        g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn] = TextDrawCreate(x, 105.0, str);
        TextDrawAlignment(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 2);
        TextDrawBackgroundColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 255);
        TextDrawFont(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 2);
        TextDrawLetterSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 0.2, 1.1);
        TextDrawColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], -1);
        TextDrawSetOutline(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 1);
        TextDrawSetProportional(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 1);
        TextDrawUseBox(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 1);
        TextDrawBoxColor(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], -16777116);
        TextDrawTextSize(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 9.0, 20.0);
        TextDrawSetSelectable(g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][E_SNAKE_JOINGAME_TBUTTONS:btn], 1);
    }
}

DestroySnakeJoinGameGTextdraws() {
    for (new td; td < MAX_SNAKE_JOINGAME_GTEXTDRAWS; td++) {
        TextDrawDestroy(g_SnakeJoinGameGTextdraw[E_SNAKE_JOINGAME_GTEXTDRAWS:td]);
        g_SnakeJoinGameGTextdraw[E_SNAKE_JOINGAME_GTEXTDRAWS:td] = Text:INVALID_TEXT_DRAW;
    }
}

CreateSnakeJoinGamePTextdraws(playerid) {
    g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE] = CreatePlayerTextDraw(playerid, 320.0, 105.0, "page"); // Current Page Number
    PlayerTextDrawAlignment(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 2);
    PlayerTextDrawBackgroundColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 255);
    PlayerTextDrawFont(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 2);
    PlayerTextDrawLetterSize(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 0.2, 1.1);
    PlayerTextDrawColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], -1);
    PlayerTextDrawSetOutline(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 1);
    PlayerTextDrawSetProportional(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], 1);

    for (new row, Float:y = 135.0; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++, y += 13.0) {
        g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row] = CreatePlayerTextDraw(playerid, 140.0, y, "Game ID"); // Game ID Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], -1);
        PlayerTextDrawSetOutline(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 0);
        PlayerTextDrawSetProportional(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 0);
        PlayerTextDrawBoxColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], -16777116);
        PlayerTextDrawTextSize(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], 180.0, 9.0);
    }

    for (new idx, col, row, Float:x, Float:y; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        x = 180.0 + (col * 80.0);

        y = 135.0 + (row * 13.0);

        g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx] = CreatePlayerTextDraw(playerid, x + 4.0, y, "Player"); // Player Button
        PlayerTextDrawBackgroundColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 255);
        PlayerTextDrawFont(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], g_SnakeColors[col]);
        PlayerTextDrawSetOutline(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 0);
        PlayerTextDrawSetProportional(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 0);
        PlayerTextDrawBoxColor(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], -16777116);
        PlayerTextDrawTextSize(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], x + 80.0, 9.0);
        PlayerTextDrawSetSelectable(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], 1);

        if (++col == MAX_SNAKE_PLAYERS) {
            row++, col = 0;
        }
    }
}

DestroySnakeJoinGamePTextdraws(playerid) {
    for (new td; td < MAX_SNAKE_JOINGAME_PTEXTDRAWS; td++) {
        PlayerTextDrawDestroy(playerid, g_SnakeJoinGamePTextdraw[playerid][E_SNAKE_JOINGAME_PTEXTDRAWS:td]);
        g_SnakeJoinGamePTextdraw[playerid][E_SNAKE_JOINGAME_PTEXTDRAWS:td] = PlayerText:INVALID_TEXT_DRAW;
    }
}

ApplySnakeJoinGamePage(playerid) {
    new str[8 + 1];
    format(str, sizeof str, "page %i", g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] + 1);
    PlayerTextDrawSetString(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE], str);
}

ApplySnakeJoinGameIDs(playerid) {
    new offset = g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE;

    for (new row, gameid, str[2 + 1]; row < MAX_SNAKE_JOINGAME_PAGESIZE; row++) {
        gameid = offset + row;

        if (gameid >= 0 && gameid < MAX_SNAKE_GAMES) {
            format(str, sizeof str, "%i", gameid + 1);
            PlayerTextDrawSetString(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row], str);
            PlayerTextDrawShow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row]);
        } else {
            PlayerTextDrawHide(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_GAMEROW][row]);
        }
    }
}

ApplySnakeJoinGamePlayers(playerid) {
    new
    gameid = g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE,
        playerslot,
        name[MAX_PLAYER_NAME + 1],
        str[MAX_PLAYER_NAME + 1];

    for (new idx; idx < MAX_SNAKE_JOINGAME_PBUTTONS; idx++) {
        if (gameid < MAX_SNAKE_GAMES) {
            new snake_playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][playerslot];

            if (snake_playerid == INVALID_PLAYER_ID) {
                if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_COUNTDOWN && SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] < SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    PlayerTextDrawSetString(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], "<join game>");
                    PlayerTextDrawShow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx]);
                } else {
                    PlayerTextDrawHide(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx]);
                }
            } else {
                GetPlayerName(snake_playerid, name, MAX_PLAYER_NAME + 1);
                format(str, MAX_PLAYER_NAME + 1, "[%i] %s", snake_playerid, name);
                PlayerTextDrawSetString(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx], str);
                PlayerTextDrawShow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx]);
            }
        } else {
            PlayerTextDrawHide(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][idx]);
        }

        if (++playerslot == MAX_SNAKE_PLAYERS) {
            gameid++, playerslot = 0;
        }
    }
}

//------------------------------------------------------------------------------

CreateSnakeScoreGTextdraws() {
    g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG] =
        TextDrawCreate(320.0, 105.0, "_");
    TextDrawAlignment(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG], 0.0, 24.9);
    TextDrawUseBox(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG], 100);
    TextDrawTextSize(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_BG], 0.0, 364.0);

    g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE] =
        TextDrawCreate(140.0, 92.0, "Snake Highscore");
    TextDrawBackgroundColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], 255);
    TextDrawFont(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], 0);
    TextDrawLetterSize(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], -1);
    TextDrawSetOutline(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], 1);
    TextDrawSetProportional(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TITLE], 1);

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

        g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn] = TextDrawCreate(x, 105.0, str);
        TextDrawAlignment(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 2);
        TextDrawBackgroundColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 255);
        TextDrawFont(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 2);
        TextDrawLetterSize(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 0.2, 1.1);
        TextDrawColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], -1);
        TextDrawSetOutline(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 1);
        TextDrawSetProportional(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 1);
        TextDrawUseBox(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 1);
        TextDrawBoxColor(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], -16777116);
        TextDrawTextSize(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 9.0, 20.0);
        TextDrawSetSelectable(g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][E_SNAKE_SCORE_TBUTTONS:btn], 1);
    }
}

DestroySnakeScoreGTextdraws() {
    for (new td; td < MAX_SNAKE_SCORE_GTEXTDRAWS; td++) {
        TextDrawDestroy(g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS:td]);
        g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS:td] = Text:INVALID_TEXT_DRAW;
    }
}

CreateSnakeScorePTextdraws(playerid) {
    g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE] =
        CreatePlayerTextDraw(playerid, 320.0, 105.0, "page");
    PlayerTextDrawAlignment(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 2);
    PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 255);
    PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 2);
    PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 0.2, 1.1);
    PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], -1);
    PlayerTextDrawSetOutline(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 1);
    PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], 1);

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

        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col] = CreatePlayerTextDraw(playerid, x, 122.0, str); // Column
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], RGBA_WHITE);
        PlayerTextDrawSetOutline(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], 0xFFFFFF32);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], x_size, 9.0);
        PlayerTextDrawSetSelectable(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][E_SNAKE_SCORE_COLUMNS:col], selectable ? 1 : 0);
    }

    for (new row, Float:y = 135.0; row < MAX_SNAKE_SCORE_PAGESIZE; row++, y += 13.0) {
        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row] =
            CreatePlayerTextDraw(playerid, 140.0, y, "Rank"); // Rank Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 0);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], 230.0, 9.0);

        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row] =
            CreatePlayerTextDraw(playerid, 234.0, y, "Player"); // Player Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 0);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], 350.0, 9.0);

        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row] =
            CreatePlayerTextDraw(playerid, 354.0, y, "Size"); // Size Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 0);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], 380.0, 9.0);

        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row] =
            CreatePlayerTextDraw(playerid, 384.0, y, "Kills"); // Kills Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 0);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], 410.0, 9.0);

        g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row] =
            CreatePlayerTextDraw(playerid, 414.0, y, "Time & Date"); // Time & Date Row
        PlayerTextDrawBackgroundColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 255);
        PlayerTextDrawFont(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], -1);
        PlayerTextDrawSetProportional(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawUseBox(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 1);
        PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 0);
        PlayerTextDrawTextSize(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], 500.0, 9.0);
    }
}

DestroySnakeScorePTextdraws(playerid) {
    for (new td; td < MAX_SNAKE_SCORE_PTEXTDRAWS; td++) {
        PlayerTextDrawDestroy(playerid, g_SnakeScorePTextdraw[playerid][E_SNAKE_SCORE_PTEXTDRAWS:td]);
        g_SnakeScorePTextdraw[playerid][E_SNAKE_SCORE_PTEXTDRAWS:td] = PlayerText:INVALID_TEXT_DRAW;
    }
}

ApplySnakeScorePage(playerid) {
    new str[15 + 1];
    format(str, sizeof str, "page %i", g_SnakeScoreData[playerid][e_SnakeScorePage] + 1);
    PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE], str);
}

ApplySnakeScoreSorting(playerid) {
    PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_PLAYER], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_SIZE], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_KILLS], 0xFFFFFF32);
    PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_TIMEDATE], 0xFFFFFF32);

    switch (g_SnakeScoreData[playerid][e_SnakeScoreSort]) {
        case SNAKE_SCORE_SORT_PLAYER_D:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_PLAYER], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_PLAYER_A:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_PLAYER], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_SIZE_D:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_SIZE], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_SIZE_A:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_SIZE], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_KILLS_D:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_KILLS], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_KILLS_A:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_KILLS], 0xFF000032);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_D:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_TIMEDATE], 0x00FF0032);
        }
        case SNAKE_SCORE_SORT_TIMEDATE_A:  {
            PlayerTextDrawBoxColor(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_TIMEDATE], 0xFF000032);
        }
    }

    PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_PLAYER]);
    PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_SIZE]);
    PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_KILLS]);
    PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_TIMEDATE]);
}

ApplySnakeScoreRows(playerid) {
    new
    offset = g_SnakeScoreData[playerid][e_SnakeScorePage] * MAX_SNAKE_SCORE_PAGESIZE,
        DBResult:db_result,
        rows;

    switch (g_SnakeScoreData[playerid][e_SnakeScoreSort]) {
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

        PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row], rank);
        PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row], pname);
        PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row], size);
        PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row], kills);
        PlayerTextDrawSetString(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row], timedate);

        PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row]);
        PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row]);
        PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row]);
        PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row]);
        PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row]);
    }

    db_free_result(db_result);

    for (new row = rows; row < MAX_SNAKE_SCORE_PAGESIZE; row++) {
        PlayerTextDrawHide(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_RANK][row]);
        PlayerTextDrawHide(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PLAYER][row]);
        PlayerTextDrawHide(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_SIZE][row]);
        PlayerTextDrawHide(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_KILLS][row]);
        PlayerTextDrawHide(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_TIMEDATE][row]);
    }
}

//------------------------------------------------------------------------------

CreateSnakeKeyGTextdraws() {
    g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG] =
        TextDrawCreate(320.0, 115.0, "_");
    TextDrawAlignment(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG], 2);
    TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG], 0.0, 9.8);
    TextDrawUseBox(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG], 1);
    TextDrawBoxColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG], 100);
    TextDrawTextSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_BG], 0.0, 302.0);

    g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE] =
        TextDrawCreate(173.0, 103.0, "Snake Keys");
    TextDrawBackgroundColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], 255);
    TextDrawFont(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], 0);
    TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], 0.6, 2.0);
    TextDrawColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], -1);
    TextDrawSetOutline(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], 1);
    TextDrawSetProportional(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TITLE], 1);

    for (new btn, Float:x, str[2]; btn < MAX_SNAKE_KEY_TBUTTONS; btn++) {
        switch (btn) {
            case SNAKE_KEY_TBUTTON_X:  { // Close
                x = 461.0, str = "x";
            }
            case SNAKE_KEY_TBUTTON_B:  { // Back
                x = 438.0, str = "<";
            }
        }

        g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn] = TextDrawCreate(x, 115.0, str);
        TextDrawAlignment(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 2);
        TextDrawBackgroundColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 255);
        TextDrawFont(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 2);
        TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 0.2, 1.1);
        TextDrawColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], -1);
        TextDrawSetOutline(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 1);
        TextDrawSetProportional(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 1);
        TextDrawUseBox(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 1);
        TextDrawBoxColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], -16777116);
        TextDrawTextSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 9.0, 20.0);
        TextDrawSetSelectable(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][E_SNAKE_KEY_TBUTTONS:btn], 1);
    }

    g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL] =
        TextDrawCreate(169.0, 129.0, "Key");
    TextDrawBackgroundColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 255);
    TextDrawFont(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 1);
    TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], -1);
    TextDrawSetOutline(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 1);
    TextDrawSetProportional(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 1);
    TextDrawUseBox(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 1);
    TextDrawBoxColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], -206);
    TextDrawTextSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 318.0, 300.0);
    TextDrawSetSelectable(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_KEY_COL], 0);

    g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL] =
        TextDrawCreate(322.0, 129.0, "Action");
    TextDrawBackgroundColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 255);
    TextDrawFont(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 1);
    TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 0.2, 1.0);
    TextDrawColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], -1);
    TextDrawSetOutline(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 1);
    TextDrawSetProportional(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 1);
    TextDrawUseBox(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 1);
    TextDrawBoxColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], -206);
    TextDrawTextSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 471.0, 300.0);
    TextDrawSetSelectable(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_COL], 0);

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

        g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key] = TextDrawCreate(322.0, y, str_action);
        TextDrawBackgroundColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 255);
        TextDrawFont(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        TextDrawLetterSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 0.2, 1.0);
        TextDrawColor(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], -1);
        TextDrawSetOutline(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 0);
        TextDrawSetProportional(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        TextDrawSetShadow(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        TextDrawTextSize(g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_ACTION_ROW][E_SNAKE_KEY_KEYACTIONS:key], 471.0, 0.0);
    }
}

DestroySnakeKeyGTextdraws() {
    for (new td; td < MAX_SNAKE_KEY_GTEXTDRAWS; td++) {
        TextDrawDestroy(g_SnakeKeyGTextdraw[E_SNAKE_KEY_GTEXTDRAWS:td]);
        g_SnakeKeyGTextdraw[E_SNAKE_KEY_GTEXTDRAWS:td] = Text:INVALID_TEXT_DRAW;
    }
}

CreateSnakeKeyPTextdraws(playerid) {
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

        g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key] = CreatePlayerTextDraw(playerid, 169.0, y, str_key);
        PlayerTextDrawBackgroundColor(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 255);
        PlayerTextDrawFont(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        PlayerTextDrawLetterSize(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 0.2, 1.0);
        PlayerTextDrawColor(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], -1);
        PlayerTextDrawSetOutline(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 0);
        PlayerTextDrawSetProportional(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        PlayerTextDrawSetShadow(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 1);
        PlayerTextDrawTextSize(playerid, g_SnakeKeyPTextdraw[playerid][SNAKE_KEY_PTD_KEY_ROW][E_SNAKE_KEY_KEYACTIONS:key], 318.0, 0.0);
    }
}

DestroySnakeKeyPTextdraws(playerid) {
    for (new td; td < MAX_SNAKE_KEY_PTEXTDRAWS; td++) {
        PlayerTextDrawDestroy(playerid, g_SnakeKeyPTextdraw[playerid][E_SNAKE_KEY_PTEXTDRAWS:td]);
        g_SnakeKeyPTextdraw[playerid][E_SNAKE_KEY_PTEXTDRAWS:td] = PlayerText:INVALID_TEXT_DRAW;
    }
}

//------------------------------------------------------------------------------

ShowSnakeTextdraws(playerid, tdmode) {
    if (tdmode == SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode]) {
        return 0;
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] != SNAKE_TDMODE_NONE) {
        HideSnakeTextdraws(playerid);
    }

    switch (tdmode) {
        case SNAKE_TDMODE_GAME:  {
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BG]);
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_PLAYER_COL]);
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_SIZE_COL]);
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_KILLS_COL]);
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_ALIVE_COL]);

            CreateSnakeGamePTextdraws(playerid);
            PlayerTextDrawShow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN]);
            PlayerTextDrawShow(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_XKEYS]);
        }
        case SNAKE_TDMODE_MENU:  {
            for (new td; td < MAX_SNAKE_MENU_GTEXTDRAWS; td++) {
                TextDrawShowForPlayer(playerid, g_SnakeMenuGTextdraw[E_SNAKE_MENU_GTEXTDRAWS:td]);
            }
        }
        case SNAKE_TDMODE_NEWGAME:  {
            for (new td; td < MAX_SNAKE_NEWGAME_GTEXTDRAWS; td++) {
                TextDrawShowForPlayer(playerid, g_SnakeNewGameGTextdraw[E_SNAKE_NEWGAME_GTEXTDRAWS:td]);
            }
        }
        case SNAKE_TDMODE_JOINGAME:  {
            for (new td; td < MAX_SNAKE_JOINGAME_GTEXTDRAWS; td++) {
                TextDrawShowForPlayer(playerid, g_SnakeJoinGameGTextdraw[E_SNAKE_JOINGAME_GTEXTDRAWS:td]);
            }

            CreateSnakeJoinGamePTextdraws(playerid);
            PlayerTextDrawShow(playerid, g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PAGE]);

            ApplySnakeJoinGameIDs(playerid);
            ApplySnakeJoinGamePage(playerid);
            ApplySnakeJoinGamePlayers(playerid);
        }
        case SNAKE_TDMODE_HIGHSCORE:  {
            for (new td; td < MAX_SNAKE_SCORE_GTEXTDRAWS; td++) {
                TextDrawShowForPlayer(playerid, g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS:td]);
            }

            CreateSnakeScorePTextdraws(playerid);
            PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_PAGE]);
            PlayerTextDrawShow(playerid, g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_RANK]);

            ApplySnakeScorePage(playerid);
            ApplySnakeScoreSorting(playerid);
            ApplySnakeScoreRows(playerid);
        }
        case SNAKE_TDMODE_KEYS:  {
            for (new td; td < MAX_SNAKE_KEY_GTEXTDRAWS; td++) {
                TextDrawShowForPlayer(playerid, g_SnakeKeyGTextdraw[E_SNAKE_KEY_GTEXTDRAWS:td]);
            }

            CreateSnakeKeyPTextdraws(playerid);

            for (new td; td < MAX_SNAKE_KEY_PTEXTDRAWS; td++) {
                PlayerTextDrawShow(playerid, g_SnakeKeyPTextdraw[playerid][E_SNAKE_KEY_PTEXTDRAWS:td]);
            }
        }
        default:  {
            return 0;
        }
    }

    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] = tdmode;

    return 1;
}

HideSnakeTextdraws(playerid) {
    switch (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode]) {
        case SNAKE_TDMODE_NONE:  {
            return 0;
        }
        case SNAKE_TDMODE_GAME:  {
            for (new td; td < MAX_SNAKE_GAME_GTD; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeGameGTextdraw[E_SNAKE_GAME_GTD:td]);
            }

            DestroySnakeGamePTextdraws(playerid);
        }
        case SNAKE_TDMODE_MENU:  {
            for (new td; td < MAX_SNAKE_MENU_GTEXTDRAWS; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeMenuGTextdraw[E_SNAKE_MENU_GTEXTDRAWS:td]);
            }
        }
        case SNAKE_TDMODE_NEWGAME:  {
            for (new td; td < MAX_SNAKE_NEWGAME_GTEXTDRAWS; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeNewGameGTextdraw[E_SNAKE_NEWGAME_GTEXTDRAWS:td]);
            }
        }
        case SNAKE_TDMODE_JOINGAME:  {
            for (new td; td < MAX_SNAKE_JOINGAME_GTEXTDRAWS; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeJoinGameGTextdraw[E_SNAKE_JOINGAME_GTEXTDRAWS:td]);
            }

            DestroySnakeJoinGamePTextdraws(playerid);
        }
        case SNAKE_TDMODE_HIGHSCORE:  {
            for (new td; td < MAX_SNAKE_SCORE_GTEXTDRAWS; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeScoreGTextdraw[E_SNAKE_SCORE_GTEXTDRAWS:td]);
            }

            DestroySnakeScorePTextdraws(playerid);
        }
        case SNAKE_TDMODE_KEYS:  {
            for (new td; td < MAX_SNAKE_KEY_GTEXTDRAWS; td++) {
                TextDrawHideForPlayer(playerid, g_SnakeKeyGTextdraw[E_SNAKE_KEY_GTEXTDRAWS:td]);
            }

            DestroySnakeKeyPTextdraws(playerid);
        }
    }

    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] = SNAKE_TDMODE_NONE;
    return 1;
}

BlockToPos(block, & x, & y) {
    x = block % SNAKE_GRID_WIDTH;
    y = block / SNAKE_GRID_WIDTH;
}

PosToBlock(x, y) {
    return x + (y * SNAKE_GRID_WIDTH);
}

GetEmptySnakeBlocks(gameid, block_array[], block_limit) {
    new block_count;
    for (new block; block < SNAKE_GRID_SIZE; block++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][block] == INVALID_PLAYER_ID) {
            if (block_count >= block_limit) {
                return block_count;
            }
            block_array[block_count++] = block;
        }
    }
    return block_count;
}

GetRandomEmptyBlock(gameid) {
    new empty_block_array[SNAKE_GRID_SIZE], empty_block_count;

    empty_block_count = GetEmptySnakeBlocks(gameid, empty_block_array, SNAKE_GRID_SIZE);

    if (empty_block_count == 0) {
        return INVALID_SNAKE_GAME_BLOCK;
    }

    new
    random_index = random(empty_block_count),
        random_block = empty_block_array[random_index];

    return random_block;
}

GetFoodSnakeBlocks(gameid) {
    new b_count;

    for (new b; b < SNAKE_GRID_SIZE; b++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] == SNAKE_BLOCK_DATA_FOOD) {
            b_count++;
        }
    }

    return b_count;
}

GetSnakeAlivePlayers(gameid) {
    new p_count;

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

        if (playerid != INVALID_PLAYER_ID && SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
            p_count++;
        }
    }

    return p_count;
}

DefaultPlayerSnakeData(playerid) {
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
}

DefaultGameSnakeData(gameid) {
    SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_NONE;
    SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime();
    SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] = 0;
    SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = 0;

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p] = INVALID_PLAYER_ID;
    }

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][p] = INVALID_PLAYER_ID;
    }

    for (new b; b < SNAKE_GRID_SIZE; b++) {
        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] = INVALID_PLAYER_ID;
    }

    new random_block = random(SNAKE_GRID_SIZE);
    SnakeGame:GameData[gameid][SnakeGame:GameBlockData][random_block] = SNAKE_BLOCK_DATA_FOOD;
}

IsSnakeDirectionAllowed(direction, last_direction) {
    if (direction == SNAKE_DIRECTION_D && last_direction == SNAKE_DIRECTION_U) {
        return 0;
    }

    if (direction == SNAKE_DIRECTION_U && last_direction == SNAKE_DIRECTION_D) {
        return 0;
    }

    if (direction == SNAKE_DIRECTION_L && last_direction == SNAKE_DIRECTION_R) {
        return 0;
    }

    if (direction == SNAKE_DIRECTION_R && last_direction == SNAKE_DIRECTION_L) {
        return 0;
    }

    return 1;
}

ApplySnakeDirection(playerid) {
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

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] == 1 || IsSnakeDirectionAllowed(direction, SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeLastDirection])) {
        SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeNextDirection] = direction;
    }

    return 1;
}

GetSnakeNextBlock(block, direction) {
    new x, y;

    BlockToPos(block, x, y);

    switch (direction) {
        case SNAKE_DIRECTION_U:  {
            if (++y > MAX_SNAKE_HEIGHT) {
                y = MIN_SNAKE_HEIGHT;
            }
        }
        case SNAKE_DIRECTION_D:  {
            if (--y < MIN_SNAKE_HEIGHT) {
                y = MAX_SNAKE_HEIGHT;
            }
        }
        case SNAKE_DIRECTION_L:  {
            if (--x < MIN_SNAKE_WIDTH) {
                x = MAX_SNAKE_WIDTH;
            }
        }
        case SNAKE_DIRECTION_R:  {
            if (++x > MAX_SNAKE_WIDTH) {
                x = MIN_SNAKE_WIDTH;
            }
        }
    }

    return PosToBlock(x, y);
}

SortSnakePlayers(gameid) {
    for (new p1; p1 < MAX_SNAKE_PLAYERS; p1++) {
        new playerid_1 = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p1];

        if (playerid_1 == INVALID_PLAYER_ID) {
            continue;
        }

        new
        bool:alive_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeAlive],
            size_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeSize],
            kills_1 = SnakeGame:PlayerData[playerid_1][SnakeGame:PlayerSnakeKills],
            pos_1;

        for (new p2; p2 < MAX_SNAKE_PLAYERS; p2++) {
            new playerid_2 = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p2];

            if (playerid_2 == INVALID_PLAYER_ID) {
                continue;
            }

            new
            bool:alive_2 = SnakeGame:PlayerData[playerid_2][SnakeGame:PlayerSnakeAlive],
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

        if (pos_1 < MAX_SNAKE_PLAYERS) {
            SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][pos_1] = playerid_1;
        }
    }
}

RefreshSnakePlayersForPlayer(td_playerid) {
    new gameid = SnakeGame:PlayerData[td_playerid][SnakeGame:PlayerGameID];

    if (gameid == INVALID_SNAKE_GAME) {
        return 0;
    }

    for (new row; row < SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]; row++) {
        new row_playerid = SnakeGame:GameData[gameid][SnakeGame:GameSortedPlayers][row];

        if (row_playerid == INVALID_PLAYER_ID) {
            continue;
        }

        new
        bool:alive = SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeAlive],
            slot = SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeSlot],
            color = g_SnakeColors[slot],
            name[MAX_PLAYER_NAME + 1],
            player_str[6 + MAX_PLAYER_NAME + 1],
            size_str[10 + 1],
            kills_str[10 + 1];

        GetPlayerName(row_playerid, name, MAX_PLAYER_NAME + 1);
        format(player_str, sizeof player_str, "[%i] %s", row_playerid, name);
        PlayerTextDrawSetString(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], player_str);
        PlayerTextDrawColor(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_PLAYER_ROW][row], color);
        PlayerTextDrawShow(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_PLAYER_ROW][row]);

        format(size_str, sizeof size_str, "%i", SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeSize]);
        PlayerTextDrawSetString(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_SIZE_ROW][row], size_str);
        PlayerTextDrawColor(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_SIZE_ROW][row], color);
        PlayerTextDrawShow(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_SIZE_ROW][row]);

        format(kills_str, sizeof kills_str, "%i", SnakeGame:PlayerData[row_playerid][SnakeGame:PlayerSnakeKills]);
        PlayerTextDrawSetString(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_KILLS_ROW][row], kills_str);
        PlayerTextDrawColor(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_KILLS_ROW][row], color);
        PlayerTextDrawShow(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_KILLS_ROW][row]);

        PlayerTextDrawSetString(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], alive ? ("Yes") : ("No"));
        PlayerTextDrawColor(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_ALIVE_ROW][row], color);
        PlayerTextDrawShow(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_ALIVE_ROW][row]);
    }

    for (new row = SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]; row < MAX_SNAKE_PLAYERS; row++) {
        PlayerTextDrawHide(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_PLAYER_ROW][row]);
        PlayerTextDrawHide(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_SIZE_ROW][row]);
        PlayerTextDrawHide(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_KILLS_ROW][row]);
        PlayerTextDrawHide(td_playerid, g_SnakeGamePTextdraw[td_playerid][SNAKE_GAME_PTD_ALIVE_ROW][row]);
    }

    return 1;
}

RefreshSnakePlayersForGame(gameid) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new l_playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

        if (l_playerid != INVALID_PLAYER_ID) {
            RefreshSnakePlayersForPlayer(l_playerid);
        }
    }
}

ShowSnakeBlockForPlayer(playerid, block, color) {
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], color);
    TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block]);
}

ShowSnakeBlockForGame(gameid, block, color) {
    TextDrawBoxColor(g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block], color);

    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

        if (playerid != INVALID_PLAYER_ID) {
            TextDrawShowForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block]);
        }
    }
}

HideSnakeBlockForGame(gameid, block) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

        if (playerid != INVALID_PLAYER_ID) {
            TextDrawHideForPlayer(playerid, g_SnakeGameGTextdraw[SNAKE_GAME_GTD_BLOCK][block]);
        }
    }
}

GetSnakeFreePlayerSlot(gameid) {
    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p] == INVALID_PLAYER_ID) {
            return p;
        }
    }
    return INVALID_SNAKE_PLAYER_SLOT;
}

JoinSnake(j_playerid, gameid, playerslot) {
    if (SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) {
        return 0;
    }

    new random_block = GetRandomEmptyBlock(gameid);

    if (random_block == INVALID_SNAKE_GAME_BLOCK) {
        return 0;
    }

    if (playerslot < 0 || playerslot >= MAX_SNAKE_PLAYERS) {
        return 0;
    }

    if (SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][playerslot] != INVALID_PLAYER_ID) {
        return 0;
    }

    ShowSnakeTextdraws(j_playerid, SNAKE_TDMODE_GAME);

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

        if (l_playerid == INVALID_PLAYER_ID || l_playerid == j_playerid) {
            continue;
        }

        ShowSnakeBlockForPlayer(j_playerid, SnakeGame:PlayerData[l_playerid][SnakeGame:PlayerSnakeBlocks][0], g_SnakeColors[p]); // Show other snakes for joined player
    }

    ShowSnakeBlockForGame(gameid, SnakeGame:PlayerData[j_playerid][SnakeGame:PlayerSnakeBlocks][0], g_SnakeColors[playerslot]); // Show joined snake for all players

    for (new b; b < SNAKE_GRID_SIZE; b++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameBlockData][b] == SNAKE_BLOCK_DATA_FOOD) {
            ShowSnakeBlockForPlayer(j_playerid, b, RGBA_WHITE); // Show food for joined player
        }
    }

    TogglePlayerControllable(j_playerid, false);

    PlayerPlaySound(j_playerid, 1068, 0.0, 0.0, 0.0);

    SortSnakePlayers(gameid), RefreshSnakePlayersForGame(gameid);
    return 1;
}

KillSnake(playerid) {
    new gameid = SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID];

    if (gameid == INVALID_SNAKE_GAME) {
        return 0;
    }

    if (!SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
        return 0;
    }

    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive] = false;

    for (new b; b < SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize]; b++) {
        new block = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b];

        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][block] = SNAKE_BLOCK_DATA_FOOD;

        ShowSnakeBlockForGame(gameid, block, 0xFFFFFFFF);
    }

    InsertSnakeScore(playerid);

    if (GetSnakeAlivePlayers(gameid) <= 1) {
        SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_GAMEOVER;
        SnakeGame:GameData[gameid][SnakeGame:GameTime] = gettime() + SNAKE_COUNTOUT_S;
    }

    SortSnakePlayers(gameid), RefreshSnakePlayersForGame(gameid);
    return 1;
}

LeaveSnake(playerid) {
    new gameid = SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID];

    if (gameid == INVALID_SNAKE_GAME) {
        return 0;
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
        KillSnake(playerid);
    } else {
        SortSnakePlayers(gameid), RefreshSnakePlayersForGame(gameid);
    }

    SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount]--;
    SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot]] = INVALID_PLAYER_ID;

    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot] = INVALID_SNAKE_PLAYER_SLOT;
    SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] = INVALID_SNAKE_GAME;

    HideSnakeTextdraws(playerid);

    PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0); // Stop music

    TogglePlayerControllable(playerid, true);

    if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] <= 0) {
        DefaultGameSnakeData(gameid);
    }

    return 1;
}

FindSnakeGameToJoin() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_COUNTDOWN && SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] < SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
            return gameid;
        }
    }
    return INVALID_SNAKE_GAME;
}

FindEmptySnakeGame() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        if (SnakeGame:GameData[gameid][SnakeGame:GameState] == SNAKE_STATE_NONE) {
            return gameid;
        }
    }
    return INVALID_SNAKE_GAME;
}

InsertSnakeScore(playerid) {
    new playername[MAX_PLAYER_NAME + 1];

    GetPlayerName(playerid, playername, MAX_PLAYER_NAME + 1);

    format(g_SnakeScoreQuery, MAX_SNAKE_SCORE_QUERYLEN + 1, "INSERT INTO snakescore (playername, size, kills) VALUES ('%q', '%i', '%i')", playername, SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize], SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeKills]);

    db_free_result(db_query(SnakeGame:ScoreDB, g_SnakeScoreQuery));
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
                            PlayerTextDrawSetString(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], countdown_str);
                        }
                    }
                } else if (SnakeGame:GameData[gameid][SnakeGame:GameCurrentPlayerCount] == SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount]) {
                    new
                    timeleft = SnakeGame:GameData[gameid][SnakeGame:GameTime] - gettime(),
                        countdown_str[6 + 1];

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
                            PlayerTextDrawSetString(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], countdown_str);
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
                            PlayerTextDrawSetString(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], "_");
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

                    new
                    head_block = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][0],
                        direction = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeNextDirection],
                        next_block = GetSnakeNextBlock(head_block, direction),
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
                                enemy_next_block = GetSnakeNextBlock(enemy_head_block, enemy_direction),
                                enemy_next_block_data = SnakeGame:GameData[gameid][SnakeGame:GameBlockData][enemy_next_block];

                            if (enemy_next_block_data == playerid) {
                                SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeKills]++;

                                KillSnake(enemyid);

                                PlayerPlaySound(enemyid, 5206, 0.0, 0.0, 0.0);
                            }
                        }

                        KillSnake(playerid);

                        PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);
                    } else { // Next Block = Empty
                        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][tail_block] = INVALID_PLAYER_ID;

                        HideSnakeBlockForGame(gameid, tail_block);
                    }

                    if (!SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeAlive]) {
                        continue;
                    }

                    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] > 1) {
                        for (new b = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSize] - 1; b > 0; b--) {
                            SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b] = SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][b - 1];
                        }
                    }

                    ShowSnakeBlockForGame(gameid, next_block, g_SnakeColors[SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeSlot]]);

                    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeBlocks][0] = next_block;
                    SnakeGame:GameData[gameid][SnakeGame:GameBlockData][next_block] = playerid;

                    SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeLastDirection] = direction;
                }

                if (foodeaten && GetFoodSnakeBlocks(gameid) == 0) {
                    new random_block = GetRandomEmptyBlock(gameid);

                    if (random_block != INVALID_SNAKE_GAME_BLOCK) {
                        SnakeGame:GameData[gameid][SnakeGame:GameBlockData][random_block] = SNAKE_BLOCK_DATA_FOOD;

                        ShowSnakeBlockForGame(gameid, random_block, RGBA_WHITE);
                    }
                }

                if (foodeaten) {
                    SortSnakePlayers(gameid), RefreshSnakePlayersForGame(gameid);
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
                            PlayerTextDrawSetString(playerid, g_SnakeGamePTextdraw[playerid][SNAKE_GAME_PTD_COUNTDOWN], countdown_str);
                        }
                    }
                } else {
                    for (new p; p < MAX_SNAKE_PLAYERS; p++) {
                        new playerid = SnakeGame:GameData[gameid][SnakeGame:GamePlayerSnakeID][p];

                        if (playerid != INVALID_PLAYER_ID) {
                            LeaveSnake(playerid);
                        }
                    }
                }
            }
        }
    }
}

//------------------------------------------------------------------------------


hook OnGameModeInit() {
    for (new gameid; gameid < MAX_SNAKE_GAMES; gameid++) {
        DefaultGameSnakeData(gameid);
    }

    for (new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid++) {
        if (IsPlayerConnected(playerid)) {
            DefaultPlayerSnakeData(playerid);

            g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] = 0;
            g_SnakeScoreData[playerid][e_SnakeScorePage] = 0;
            g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;
        }
    }

    SnakeGame:GameUpdateTimer = SetTimer("OnSnakeUpdate", SNAKE_GAME_INTERVAL_MS, true);

    SnakeGame:ScoreDB = db_open("snake.db");

    if (SnakeGame:ScoreDB == DB:0) {
        print("[Snake database] ERROR:could not be opened!");
    } else {
        print("[Snake database] opened successfully.");

        g_SnakeScoreQuery = "\
            CREATE TABLE IF NOT EXISTS snakescore \
            (\
            playername TEXT, \
            size INT, \
            kills INT, \
            scoretimedate TEXT DEFAULT (DATETIME('now'))\
            )\
        ";

        db_free_result(db_query(SnakeGame:ScoreDB, g_SnakeScoreQuery));
    }

    CreateSnakeGameGTextdraws(); // Generic Game Textdraws
    CreateSnakeJoinGameGTextdraws(); // Generic Join Game Textdraws
    CreateSnakeKeyGTextdraws(); // Generic Key Textdraws
    CreateSnakeMenuGTextdraws(); // Menu Textdraws
    CreateSnakeNewGameGTextdraws(); // New Game Textdraws
    CreateSnakeScoreGTextdraws(); // Score Textdraws
    return 1;
}

hook OnGameModeExit() {
    KillTimer(SnakeGame:GameUpdateTimer);

    for (new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid++) {
        if (!IsPlayerConnected(playerid)) {
            continue;
        }

        if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) {
            LeaveSnake(playerid);
        }

        if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] != SNAKE_TDMODE_NONE) {
            HideSnakeTextdraws(playerid);
        }
    }

    if (db_close(SnakeGame:ScoreDB)) {
        print("  [Snake database] closed successfully.");
    } else {
        print("  [Snake database] ERROR: could not be closed!");
    }

    DestroySnakeGameGTextdraws();
    DestroySnakeJoinGameGTextdraws();
    DestroySnakeKeyGTextdraws();
    DestroySnakeMenuGTextdraws();
    DestroySnakeNewGameGTextdraws();
    DestroySnakeScoreGTextdraws();
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    DefaultPlayerSnakeData(playerid);

    g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] = 0;
    g_SnakeScoreData[playerid][e_SnakeScorePage] = 0;
    g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) {
        LeaveSnake(playerid);
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME) {
        ApplySnakeDirection(playerid);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerGameID] != INVALID_SNAKE_GAME && (newkeys & KEY_SECONDARY_ATTACK) && (newkeys & KEY_CROUCH) && (newkeys & KEY_JUMP)) {
        LeaveSnake(playerid);
        return 1;
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == Text:INVALID_TEXT_DRAW) {
        switch (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode]) {
            case SNAKE_TDMODE_MENU, SNAKE_TDMODE_NEWGAME, SNAKE_TDMODE_JOINGAME, SNAKE_TDMODE_HIGHSCORE, SNAKE_TDMODE_KEYS:  {
                HideSnakeTextdraws(playerid);
            }
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_MENU) {
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_SP]) {
            new create_gameid = FindEmptySnakeGame();

            if (create_gameid == INVALID_SNAKE_GAME) {
                return 1;
            }

            if (!JoinSnake(playerid, create_gameid, .playerslot = 0)) {
                return 1;
            }

            SnakeGame:GameData[create_gameid][SnakeGame:GameTargetPlayerCount] = 1;
            SnakeGame:GameData[create_gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_MP]) {
            new gameid = FindSnakeGameToJoin();

            if (gameid != INVALID_SNAKE_GAME) {
                new playerslot = GetSnakeFreePlayerSlot(gameid);

                if (JoinSnake(playerid, gameid, playerslot)) {
                    CancelSelectTextDraw(playerid);
                    return 1;
                }
            }

            gameid = FindEmptySnakeGame();

            if (gameid != INVALID_SNAKE_GAME && JoinSnake(playerid, gameid, .playerslot = 0)) {
                SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = 2;
                SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

                CancelSelectTextDraw(playerid);
                return 1;
            }

            SendClientMessageEx(playerid, RGBA_RED, "ERROR: A game could not be found right now!");
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_CREATE]) {
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_NEWGAME);
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_JOIN]) {
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_JOINGAME);
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_SCORE]) {
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_HIGHSCORE);
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_RBUTTON][SNAKE_MENU_RBUTTON_KEYS]) {
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_KEYS);
            return 1;
        }
        if (clickedid == g_SnakeMenuGTextdraw[SNAKE_MENU_GTD_XBUTTON]) {
            HideSnakeTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_NEWGAME) {
        for (new btn; btn < MAX_SNAKE_PLAYERS; btn++) {
            if (clickedid == g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_PBUTTON][btn]) {
                new gameid = FindEmptySnakeGame();

                if (gameid != INVALID_SNAKE_GAME && JoinSnake(playerid, gameid, .playerslot = 0)) {
                    SnakeGame:GameData[gameid][SnakeGame:GameTargetPlayerCount] = btn + 1;
                    SnakeGame:GameData[gameid][SnakeGame:GameState] = SNAKE_STATE_COUNTDOWN;

                    CancelSelectTextDraw(playerid);
                }
                return 1;
            }
        }

        if (clickedid == g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][SNAKE_NEWGAME_TBUTTON_X]) { // Close
            HideSnakeTextdraws(playerid);
            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == g_SnakeNewGameGTextdraw[SNAKE_NEWGAME_GTD_TBUTTON][SNAKE_NEWGAME_TBUTTON_B]) { // Back
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_JOINGAME) {
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_X]) { // Close
            HideSnakeTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_B]) { // Back
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_PAGE_F]) { // First Page
            if (g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] > MIN_SNAKE_JOINGAME_PAGE) {
                g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] = MIN_SNAKE_JOINGAME_PAGE;
                ApplySnakeJoinGamePage(playerid);
                ApplySnakeJoinGameIDs(playerid);
                ApplySnakeJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_PAGE_P]) { // Previous Page
            if (g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] > MIN_SNAKE_JOINGAME_PAGE) {
                g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage]--;
                ApplySnakeJoinGamePage(playerid);
                ApplySnakeJoinGameIDs(playerid);
                ApplySnakeJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_PAGE_N]) { // Next Page
            if (g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] < MAX_SNAKE_JOINGAME_PAGE) {
                g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage]++;
                ApplySnakeJoinGamePage(playerid);
                ApplySnakeJoinGameIDs(playerid);
                ApplySnakeJoinGamePlayers(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeJoinGameGTextdraw[SNAKE_JOINGAME_GTD_TBUTTON][SNAKE_JOINGAME_TBUTTON_PAGE_L]) { // Last Page
            if (g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] < MAX_SNAKE_JOINGAME_PAGE) {
                g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] = MAX_SNAKE_JOINGAME_PAGE;
                ApplySnakeJoinGamePage(playerid);
                ApplySnakeJoinGameIDs(playerid);
                ApplySnakeJoinGamePlayers(playerid);
            }
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_HIGHSCORE) {
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_X]) {
            HideSnakeTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_B]) {
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_PAGE_F]) {
            if (g_SnakeScoreData[playerid][e_SnakeScorePage] > MIN_SNAKE_SCORE_PAGE) {
                g_SnakeScoreData[playerid][e_SnakeScorePage] = MIN_SNAKE_SCORE_PAGE;
                ApplySnakeScorePage(playerid);
                ApplySnakeScoreRows(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_PAGE_P]) {
            if (g_SnakeScoreData[playerid][e_SnakeScorePage] > MIN_SNAKE_SCORE_PAGE) {
                g_SnakeScoreData[playerid][e_SnakeScorePage]--;
                ApplySnakeScorePage(playerid);
                ApplySnakeScoreRows(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_PAGE_N]) {
            if (g_SnakeScoreData[playerid][e_SnakeScorePage] < MAX_SNAKE_SCORE_PAGE) {
                g_SnakeScoreData[playerid][e_SnakeScorePage]++;
                ApplySnakeScorePage(playerid);
                ApplySnakeScoreRows(playerid);
            }
            return 1;
        }
        if (clickedid == g_SnakeScoreGTextdraw[SNAKE_SCORE_GTD_TBUTTON][SNAKE_SCORE_TBUTTON_PAGE_L]) {
            if (g_SnakeScoreData[playerid][e_SnakeScorePage] < MAX_SNAKE_SCORE_PAGE) {
                g_SnakeScoreData[playerid][e_SnakeScorePage] = MAX_SNAKE_SCORE_PAGE;
                ApplySnakeScorePage(playerid);
                ApplySnakeScoreRows(playerid);
            }
            return 1;
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_KEYS) {
        if (clickedid == g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][SNAKE_KEY_TBUTTON_X]) { // Close
            HideSnakeTextdraws(playerid);

            CancelSelectTextDraw(playerid);
            return 1;
        }
        if (clickedid == g_SnakeKeyGTextdraw[SNAKE_KEY_GTD_TBUTTON][SNAKE_KEY_TBUTTON_B]) { // Back
            ShowSnakeTextdraws(playerid, SNAKE_TDMODE_MENU);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerClickPlayerTDEx(playerid, PlayerText:playertextid) {
    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_JOINGAME) {
        for (new btn; btn < MAX_SNAKE_JOINGAME_PBUTTONS; btn++) {
            if (playertextid == g_SnakeJoinGamePTextdraw[playerid][SNAKE_JOINGAME_PTD_PBUTTON][btn]) {
                new gameid = (g_SnakeJoinGameData[playerid][e_SnakeJoinGamePage] * MAX_SNAKE_JOINGAME_PAGESIZE) + btn / MAX_SNAKE_PLAYERS;

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

                if (JoinSnake(playerid, gameid, playerslot)) {
                    CancelSelectTextDraw(playerid);
                }

                return 1;
            }
        }
    }

    if (SnakeGame:PlayerData[playerid][SnakeGame:PlayerSnakeTextDrawMode] == SNAKE_TDMODE_HIGHSCORE) {
        if (playertextid == g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_PLAYER]) {
            if (g_SnakeScoreData[playerid][e_SnakeScoreSort] == SNAKE_SCORE_SORT_PLAYER_D) {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_PLAYER_A;
            } else {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_PLAYER_D;
            }
            ApplySnakeScoreSorting(playerid);
            ApplySnakeScoreRows(playerid);
            return 1;
        }
        if (playertextid == g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_SIZE]) {
            if (g_SnakeScoreData[playerid][e_SnakeScoreSort] == SNAKE_SCORE_SORT_SIZE_D) {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_A;
            } else {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_SIZE_D;
            }
            ApplySnakeScoreSorting(playerid);
            ApplySnakeScoreRows(playerid);
            return 1;
        }
        if (playertextid == g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_KILLS]) {
            if (g_SnakeScoreData[playerid][e_SnakeScoreSort] == SNAKE_SCORE_SORT_KILLS_D) {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_KILLS_A;
            } else {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_KILLS_D;
            }
            ApplySnakeScoreSorting(playerid);
            ApplySnakeScoreRows(playerid);
            return 1;
        }
        if (playertextid == g_SnakeScorePTextdraw[playerid][SNAKE_SCORE_PTD_COL][SNAKE_SCORE_COL_TIMEDATE]) {
            if (g_SnakeScoreData[playerid][e_SnakeScoreSort] == SNAKE_SCORE_SORT_TIMEDATE_D) {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_TIMEDATE_A;
            } else {
                g_SnakeScoreData[playerid][e_SnakeScoreSort] = SNAKE_SCORE_SORT_TIMEDATE_D;
            }
            ApplySnakeScoreSorting(playerid);
            ApplySnakeScoreRows(playerid);
            return 1;
        }
    }
    return 1;
}

stock start_snake_cmd(playerid) {
    ShowSnakeTextdraws(playerid, SNAKE_TDMODE_MENU);
    SelectTextDraw(playerid, RGBA_RED);
    return 1;
}