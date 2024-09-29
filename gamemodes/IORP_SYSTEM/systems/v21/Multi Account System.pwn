hook OnPlayerLogin(playerid) {
    if (
        IsStringSame(GetPlayerNameEx(playerid), "Harry_James") ||
        IsStringSame(GetPlayerNameEx(playerid), "Robert_James") ||
        IsStringSame(GetPlayerNameEx(playerid), "Vikram_Aditya") ||
        IsStringSame(GetPlayerNameEx(playerid), "Steve_Smith") ||
        IsStringSame(GetPlayerNameEx(playerid), "Dino_James")
    ) return 1;

    new Cache:mysql_cache = mysql_query(Database, sprintf("select username, ip, MAX(timestamp) as timestamp from loginLogs where ip = \"%s\" and username != \"%s\" and timestamp > %d group by username having COUNT(username) > 1", GetPlayerIpEx(playerid), GetPlayerNameEx(playerid), gettime() - 259200));
    new rows = cache_num_rows();
    new nName[50], timestamp, timeunix[50];
    if (rows > 0) {
        new string[2000];
        strcat(string, "```\n");
        strcat(string, sprintf("%s multiple account detected with same ip %s\n", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid)));
        for (new i = 0; i < rows; i++) {
            cache_get_value_name(i, "username", nName, sizeof nName);
            cache_get_value_name_int(i, "timestamp", timestamp);
            UnixToHuman(timestamp, timeunix);
            strcat(string, sprintf("     > accessed %s account at %s\n", nName, timeunix));
            SendAdminLogMessage(sprintf("%s logged %s account before current account at %s (multiple account detected)", GetPlayerNameEx(playerid), nName, timeunix), false);
        }
        strcat(string, "```");
        Discord:LogMultiAccount(string);
    }
    cache_delete(mysql_cache);
    return 1;
}