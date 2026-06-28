stock LogPlayerEvent(playerid, const event[], const event_desc[]) {
    mysql_tquery(Database, sprintf("insert into playerEvents (username, time, event, description) values (\"%s\", %d, \"%s\", \"%s\")", GetPlayerNameEx(playerid), gettime(), event, event_desc));
    return 1;
}

stock CountPlayerEvent(playerid, const event[], after) {
    new Cache:mysql_cache;
    mysql_cache = mysql_query(Database, sprintf("SELECT * FROM playerEvents WHERE username = \"%s\" and event = \"%s\" and time >= %d", GetPlayerNameEx(playerid), event, after));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    return rows;
}