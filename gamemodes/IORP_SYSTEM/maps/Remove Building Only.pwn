
hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    return 1;
}