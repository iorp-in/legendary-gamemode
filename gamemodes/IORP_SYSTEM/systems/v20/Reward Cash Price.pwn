new STREAMER_TAG_3D_TEXT_LABEL:cashprice3dtext;

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "LastRewardClaimScore", "int", "0");
    cashprice3dtext = CreateDynamic3DTextLabel("press N to collect citizen relief fund\nhosted by San Andreas Government Department", 0xFFFF00FF, -474.7368, 289.6773, 2004.5850, 10.0);
    return 1;
}

hook OnGameModeExit() {
    DestroyDynamic3DTextLabel(cashprice3dtext);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (
        newkeys == KEY_NO &&
        GetPlayerState(playerid) == PLAYER_STATE_ONFOOT &&
        IsPlayerInRangeOfPoint(playerid, 2.0, -474.7368, 289.6773, 2004.5850) &&
        GetPlayerInteriorID(playerid) == 1
    ) {
        new lastscore = Database:GetInt(GetPlayerNameEx(playerid), "username", "LastRewardClaimScore");
        if (lastscore >= GetPlayerScore(playerid)) {
            SendClientMessage(playerid, -1, "{4286f4}[Faction System]:{FFFFFF} you are not eligible to claim reward. Try after increasing your score by +1");
        } else {
            new count = GetPlayerScore(playerid) - lastscore;
            new cash = Random(800, 1500) * count;
            vault:PlayerVault(playerid, cash, sprintf("got citizen relief fund at score %d", GetPlayerScore(playerid)), Vault_ID_Government, -cash, sprintf("%s got citizen relief fund at score %d", GetPlayerNameEx(playerid), GetPlayerScore(playerid)));
            Database:UpdateInt(GetPlayerScore(playerid), GetPlayerNameEx(playerid), "username", "LastRewardClaimScore");
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Faction System]:{FFFFFF} Congratulations, you have received $%s from SAGD for being citizen of IORP. Enjoy!", FormatCurrency(cash)));
        }
    }
    return 1;
}