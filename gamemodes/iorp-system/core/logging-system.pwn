hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerLogs` (\
      `ID` BIGINT NOT NULL AUTO_INCREMENT,\
	  `username` varchar(100) NOT NULL,\
	  `log` TEXT NOT NULL,\
	  `description` TEXT NOT NULL,\
	  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
      PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerLogMoney` (\
      `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `username` varchar(100) NOT NULL,\
	  `amount` BIGINT NOT NULL,\
	  `balance` BIGINT NOT NULL,\
	  `transaction` TEXT NOT NULL,\
	  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
      PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerLogBitcoins` (\
      `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `username` varchar(100) NOT NULL,\
	  `amount` BIGINT NOT NULL,\
	  `balance` BIGINT NOT NULL,\
	  `transaction` TEXT NOT NULL,\
	  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
      PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

stock AddPlayerLog(playerid, const title[], const type[]) {
    mysql_tquery(Database, sprintf(
        "insert into playerLogs (username, title, type) VALUES (\"%s\", \"%s\", \"%s\")",
        GetPlayerNameEx(playerid), title, type
    ));
    return 1;
}

stock AddPlayerReportLog(const username[], const punishment[], const reason[]) {
    mysql_tquery(Database, sprintf(
        "insert into playerReports (username, punishment, reason) VALUES (\"%s\", \"%s\", \"%s\")",
        username, punishment, reason
    ));
    return 1;
}

stock AddMoneyLog(playerid, amount, const log[]) {
    mysql_tquery(Database, sprintf("insert into playerLogMoney (username, amount, balance, transaction) VALUES (\"%s\", %d, %d, \"%s\")", GetPlayerNameEx(playerid), amount, GetPlayerCash(playerid), log), "", "");
    return 1;
}

stock AddDebtLog(playerid, amount, const log[]) {
    mysql_tquery(Database, sprintf("insert into playerLogDebts (username, amount, balance, transaction) VALUES (\"%s\", %d, (select Debt from playerdata where username = \"%s\" limit 1), \"%s\")", GetPlayerNameEx(playerid), amount, GetPlayerNameEx(playerid), log));
    return 1;
}

stock AddDebtLogOffline(const username[], amount, const log[]) {
    mysql_tquery(Database, sprintf("insert into playerLogDebts (username, amount, balance, transaction) VALUES (\"%s\", %d, (select Debt from playerdata where username = \"%s\" limit 1), \"%s\")", username, amount, username, log));
    return 1;
}

stock AddBTCLog(playerid, amount, const log[]) {
    mysql_tquery(Database, sprintf("insert into playerLogBitcoins (username, amount, balance, transaction) VALUES (\"%s\", %d, %d, \"%s\")", GetPlayerNameEx(playerid), amount, BitCoin:Get(playerid), log), "", "");
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `playerLogs` SET `username` = \"%s\" WHERE  `username` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `playerLogMoney` SET `username` = \"%s\" WHERE  `username` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `playerLogBitcoins` SET `username` = \"%s\" WHERE  `username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `playerLogs` WHERE `username` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `playerLogMoney` WHERE `username` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `playerLogBitcoins` WHERE `username` = \"%s\"", AccountName));
    return 1;
}