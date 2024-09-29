hook OnGameModeInit() {
    Database:AddColumn("playerdata", "discordid", "varchar(100)", "");
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "update discordid")) return 1;
    new discordid[50];
    if (sscanf(GetNextWordFromString(text, "discordid"), "s[50]", discordid)) { SyntaxMSG(playerid, "/alexa update discordid <discord_id>"); return ~1; }
    if (_:DCC_FindUserById(discordid) == 0) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} given discord user does not exists int iorp discord server. please enter your discord id correctly."); return ~1; }
    new Cache:perm_data = mysql_query(Database, sprintf("select username from playerdata where discordid = \"%s\"", discordid));
    new rows = cache_num_rows();
    cache_delete(perm_data);
    if (rows > 0) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} given discord id is already used by someone, use !unverify at discord to remove it."); return ~1; }
    Database:UpdateString(discordid, GetPlayerNameEx(playerid), "username", "discordid");
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} your discord id is updated to %s", discordid));
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} type this command in discord to complete verification: /verify %s", GetPlayerNameEx(playerid)));
    return ~1;
}