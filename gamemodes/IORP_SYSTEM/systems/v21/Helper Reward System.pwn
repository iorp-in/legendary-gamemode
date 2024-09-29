#define LastHelperRewardTimeTable "LastHelperRewardTime"
hook OnGameModeInit() {
    Database:AddColumn("playerdata", LastHelperRewardTimeTable, "int", "0");
    return 1;
}

cmd:rewardhelper(playerid, const params[]) {
    if (GetPlayerScore(playerid) > 10) return 0;
    new helperid;
    if (sscanf(params, "u", helperid)) return SyntaxMSG(playerid, "/rewardhelper [PlayerID]");
    if (!IsPlayerHelper(helperid)) return AlexaMsg(playerid, "mentioned player is not a helper.");
    if (!GetPlayerHelperStatus(helperid)) return AlexaMsg(playerid, "mentioned helper is not on active duty.");
    new lastTime = Database:GetInt(GetPlayerNameEx(playerid), "username", LastHelperRewardTimeTable);
    new currentTime = gettime();
    if (currentTime - lastTime < 24 * 60 * 60) return AlexaMsg(playerid, "you can use this command once in day to reward a helper.");
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "LastHelperRewardTimeTable");
    BitCoin:GiveOrTake(helperid, 5, sprintf("%s given helper reward", GetPlayerNameEx(playerid)));
    AlexaMsg(helperid, sprintf("%s given you 5 bitcoin reward for helping him as helper.", GetPlayerNameEx(playerid)));
    AlexaMsg(playerid, sprintf("you have rewarded %s with 5 Bitcoins for helping you about.", GetPlayerNameEx(helperid)));
    Discord:SendHelper(sprintf("``%s reward %s helper with 5 bitcoins``", GetPlayerNameEx(playerid), GetPlayerNameEx(helperid)));
    return 1;
}