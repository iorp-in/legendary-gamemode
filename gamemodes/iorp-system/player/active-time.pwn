hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerActiveTime` (\
	  `date` varchar(100) NOT NULL,\
	  `username` varchar(100) NOT NULL,\
	  `time` int(11) NOT NULL,\
	  UNIQUE KEY `date_2` (`date`,`username`),\
	  KEY `date` (`date`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

new ActiveTime[MAX_PLAYERS];

hook OnPlayerLogin(playerid) {
    new time = gettime();
    ActiveTime[playerid] = time;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerLoggedIn(playerid)) LogDailyActiveTime(playerid);
    return 1;
}

stock LogDailyActiveTime(playerid) {
    new Year, Month, Day, date[50];
    getdate(Year, Month, Day);
    new time = gettime();
    format(date, sizeof date, "%d/%d/%d", Day, Month, Year);
    new diff = time - ActiveTime[playerid];
    mysql_tquery(Database, sprintf("insert into playerActiveTime (date, username, time) values (\"%s\",\"%s\",%d) ON DUPLICATE KEY UPDATE time = time + %d", date, GetPlayerNameEx(playerid), diff, diff), "", "");
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `playerActiveTime` SET `username` = \"%s\" WHERE  `username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `playerActiveTime` WHERE `username` = \"%s\"", AccountName));
    return 1;
}