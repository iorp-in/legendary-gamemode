hook OnGameModeInit() {
    Database:AddColumn("playerdata", "vipLevel", "int", "0");
    Database:AddColumn("playerdata", "vipLevelExpireAt", "int", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    SetPreciseTimer("RestoreVipState", 10 * 1000, false, "d", playerid);
    return 1;
}

forward RestoreVipState(playerid);
public RestoreVipState(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    new vipLevel;
    new Cache:mysql_cache;
    mysql_cache = mysql_query(Database, sprintf("select vipLevel from playerdata where vipLevelExpireAt > unix_timestamp() AND `Username` = \"%s\"", GetPlayerNameEx(playerid)));
    new rows = cache_num_rows();
    if (!rows) vipLevel = 0;
    else cache_get_value_name_int(0, "vipLevel", vipLevel);
    cache_delete(mysql_cache);
    if (vipLevel > 0) {
        SetPlayerVIPLevel(playerid, vipLevel);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} your vip access level %d is granted", vipLevel));
    } else SetPlayerVIPLevel(playerid, 0);
    return 1;
}