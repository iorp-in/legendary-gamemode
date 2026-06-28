#define RpCountTable "RpCount"
new RpAchievementID[8], RpCount[MAX_PLAYERS];

hook OnGameModeInit() {
    Database:AddColumn(AchievementTable, RpCountTable, "int", "0");
    RpAchievementID[0] = AddAchievement("Do your first roleplay", "Do your first roleplay using roleplay command to earn this achievement");
    RpAchievementID[1] = AddAchievement("Complete 10 roleplay", "Complete 10 roleplay using roleplay command to earn this achievement");
    RpAchievementID[2] = AddAchievement("Complete 100 roleplay", "Complete 100 roleplay using roleplay command to earn this achievement");
    RpAchievementID[3] = AddAchievement("Complete 1K roleplay", "Complete 1K roleplay using roleplay command to earn this achievement");
    RpAchievementID[4] = AddAchievement("Complete 10K roleplay", "Complete 10K roleplay using roleplay command to earn this achievement");
    RpAchievementID[5] = AddAchievement("Complete 100K roleplay", "Complete 100K roleplay using roleplay command to earn this achievement");
    RpAchievementID[6] = AddAchievement("Complete 500K roleplay", "Complete 500K roleplay using roleplay command to earn this achievement");
    RpAchievementID[7] = AddAchievement("Complete 1M roleplay", "Complete 1M roleplay using roleplay command to earn this achievement");
    return 1;
}

hook OnPlayerLogin(playerid) {
    RpCount[playerid] = Database:GetInt(GetPlayerNameEx(playerid), "username", RpCountTable, AchievementTable);
    if (RpCount[playerid] >= 1) SetAchievementStatus(playerid, RpAchievementID[0], true);
    else SetAchievementStatus(playerid, RpAchievementID[0], false);
    if (RpCount[playerid] >= 10) SetAchievementStatus(playerid, RpAchievementID[1], true);
    else SetAchievementStatus(playerid, RpAchievementID[1], false);
    if (RpCount[playerid] >= 100) SetAchievementStatus(playerid, RpAchievementID[2], true);
    else SetAchievementStatus(playerid, RpAchievementID[2], false);
    if (RpCount[playerid] >= 1000) SetAchievementStatus(playerid, RpAchievementID[3], true);
    else SetAchievementStatus(playerid, RpAchievementID[3], false);
    if (RpCount[playerid] >= 10000) SetAchievementStatus(playerid, RpAchievementID[4], true);
    else SetAchievementStatus(playerid, RpAchievementID[4], false);
    if (RpCount[playerid] >= 100000) SetAchievementStatus(playerid, RpAchievementID[5], true);
    else SetAchievementStatus(playerid, RpAchievementID[5], false);
    if (RpCount[playerid] >= 500000) SetAchievementStatus(playerid, RpAchievementID[6], true);
    else SetAchievementStatus(playerid, RpAchievementID[6], false);
    if (RpCount[playerid] >= 1000000) SetAchievementStatus(playerid, RpAchievementID[7], true);
    else SetAchievementStatus(playerid, RpAchievementID[7], false);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerLoggedIn(playerid)) Database:UpdateInt(RpCount[playerid], GetPlayerNameEx(playerid), "username", RpCountTable, AchievementTable);
    RpCount[playerid] = 0;
    return 1;
}

stock IncreaseRpCount(playerid) {
    if (IsTimePassedForPlayer(playerid, "rpexp", 60)) GiveExperiencePoint(playerid, 1, false);
    RpCount[playerid]++;
    if (RpCount[playerid] == 1 && !GetAchievementStatus(playerid, RpAchievementID[0])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[0], true);
        vault:PlayerVault(playerid, 500, "Achievement:Do your first roleplay", Vault_ID_Government, -500, sprintf("%s Achievement:Do your first roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}you have accomplished achievement - {FF5733}Do your first roleplay");
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}wish you all the best with $500 for your future and congratulate you for this achievement.");
    } else if (RpCount[playerid] == 10 && !GetAchievementStatus(playerid, RpAchievementID[1])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[1], true);
        vault:PlayerVault(playerid, 500, "Achievement:Complete 10 roleplay", Vault_ID_Government, -500, sprintf("%s Achievement:Complete 10 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 10 roleplay ($500)");
    } else if (RpCount[playerid] == 100 && !GetAchievementStatus(playerid, RpAchievementID[2])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[2], true);
        vault:PlayerVault(playerid, 500, "Achievement:Complete 100 roleplay", Vault_ID_Government, -500, sprintf("%s Achievement:Complete 100 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 100 roleplay ($500)");
    } else if (RpCount[playerid] == 1000 && !GetAchievementStatus(playerid, RpAchievementID[3])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[3], true);
        vault:PlayerVault(playerid, 1000, "Achievement:Complete 1000 roleplay", Vault_ID_Government, -1000, sprintf("%s Achievement:Complete 1000 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 1K roleplay ($1000)");
    } else if (RpCount[playerid] == 10000 && !GetAchievementStatus(playerid, RpAchievementID[4])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[4], true);
        vault:PlayerVault(playerid, 10000, "Achievement:Complete 10000 roleplay", Vault_ID_Government, -10000, sprintf("%s Achievement:Complete 10000 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 10K roleplay ($10000)");
    } else if (RpCount[playerid] == 100000 && !GetAchievementStatus(playerid, RpAchievementID[5])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[5], true);
        vault:PlayerVault(playerid, 10000, "Achievement:Complete 100000 roleplay", Vault_ID_Government, -10000, sprintf("%s Achievement:Complete 100000 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 100K roleplay ($100000)");
    } else if (RpCount[playerid] == 500000 && !GetAchievementStatus(playerid, RpAchievementID[6])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[6], true);
        vault:PlayerVault(playerid, 10000, "Achievement:Complete 500000 roleplay", Vault_ID_Government, -10000, sprintf("%s Achievement:Complete 500000 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 500K roleplay ($500000)");
    } else if (RpCount[playerid] == 1000000 && !GetAchievementStatus(playerid, RpAchievementID[7])) {
        GameTextForPlayer(playerid, "achievement~n~~w~   respect +", 3000, 4);
        SetAchievementStatus(playerid, RpAchievementID[7], true);
        vault:PlayerVault(playerid, 10000, "Achievement:Complete 1000000 roleplay", Vault_ID_Government, -10000, sprintf("%s Achievement:Complete 1000000 roleplay", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, "{4286f4}[Achievement]: {FFFFEE}congratulate, you have accomplished achievement - {FF5733}Complete 1M roleplay ($1000000)");
    }
    return 1;
}

stock GetPlayerRpScore(playerid) {
    return RpCount[playerid];
}