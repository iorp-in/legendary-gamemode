stock ShowMiniGameMenu(playerid) {
    new string[512];
    strcat(string, "Names\n");
    strcat(string, "Snake Game\n");
    strcat(string, "Tic Tac Toe Game\n");
    strcat(string, "Football\n");
    strcat(string, "Lottery\n");
    return FlexPlayerDialog(playerid, "MinigameMenu", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFEE}Minigames", string, "Select", "Close");
}

FlexDialog:MinigameMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Snake Game", inputtext)) return SnakeGame:Start(playerid);
    if (IsStringSame("Tic Tac Toe Game", inputtext)) return ShowTicTacToeMenu(playerid);
    if (IsStringSame("Football", inputtext)) return ShowFootBallMenu(playerid);
    if (IsStringSame("Lottery", inputtext)) return ShowLotteryMenu(playerid);
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 22) return 1;
    ShowMiniGameMenu(playerid);
    return ~1;
}