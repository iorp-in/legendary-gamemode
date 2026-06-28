enum E_HMPLAYER {
    timesTargeted,
    placedHits,
    moneySpent,
    claimedBounties,
    claimedBountyAmount,
    // temp
    bool:hasBounty
};

enum E_PAYPHONE {
    Float:phoneX, // can
    Float:phoneY, // you
    Float:phoneZ, // hear
    Text3D:phoneLabel // me?
};

new PurgeTimer = -1;

new HitMarket:BountyData[MAX_PLAYERS][E_HMPLAYER];

new HitMarket:Phones[][E_PAYPHONE] = {
    {-1661.5938, 1398.0938, 6.8828 },
    {-1689.1172, 1359.5469, 6.8828 },
    {-1696.6875, 1334.4766, 6.8828 },
    {-1964.1406, 162.8672, 27.3516 },
    {-1965.2109, 162.8672, 27.3516 },
    {-1966.2812, 162.8672, 27.3516 },
    {-1967.3594, 162.8672, 27.3516 },
    {-2419.3516, 718.2109, 34.8594 },
    { 1709.9922, -1604.9141, 13.2266 },
    { 1711.3438, -1606.0391, 13.2266 },
    { 1721.6719, -1720.3906, 13.2266 },
    { 1721.6719, -1721.2891, 13.2266 },
    { 1722.6094, -1720.3906, 13.2266 },
    { 1722.6094, -1721.2891, 13.2266 },
    { 1805.4062, -1600.4609, 13.2266 },
    { 1806.3906, -1599.6172, 13.2266 },
    { 1807.3828, -1598.7812, 13.2266 },
    { 1808.3750, -1597.9219, 13.2266 },
    { 1809.3438, -1597.0859, 13.2266 },
    { 2068.9375, -1767.8359, 13.2109 },
    { 2069.0000, -1766.6641, 13.2109 },
    { 2165.9219, -1154.9609, 24.4141 },
    { 2165.9219, -1155.8047, 24.4141 },
    { 2257.6562, -1211.1875, 23.6797 },
    { 2259.2031, -1211.2109, 23.6797 },
    { 2279.2578, 2524.9844, 10.5391 },
    { 2279.2578, 2526.7344, 10.5391 },
    { 2279.2578, 2528.5547, 10.5391 },
    { 278.5547, -1630.6719, 32.9297 },
    { 279.1875, -1630.7812, 32.9297 },
    { 295.1641, -1573.0625, 33.1562 },
    { 296.7578, -1573.2969, 33.1562 },
    { 302.0859, -1593.2031, 32.5156 },
    { 303.0312, -1593.3125, 32.5156 },
    { 355.8047, -1364.9531, 14.1641 },
    { 356.3828, -1364.6797, 14.1641 },
    { 379.1094, -1717.0469, 23.0391 },
    { 379.1094, -1717.9141, 22.7734 },
    { 638.0312, -1228.0234, 17.8203 },
    { 638.0312, -1228.6641, 17.7891 },
    { 339.1875, -1398.0469, 14.2266 },
    { 523.1562, -1516.4219, 14.3438 },
    { 523.1562, -1525.6172, 14.3438 }
};

HitMarket:IsPlayerNearAPayphone(playerid) {
    for (new i; i < sizeof(HitMarket:Phones); i++) {
        if (IsPlayerInRangeOfPoint(playerid, 3.5, HitMarket:Phones[i][phoneX], HitMarket:Phones[i][phoneY], HitMarket:Phones[i][phoneZ])) return 1;
    }
    return 0;
}

HitMarket:PlayerInit(playerid) {
    new reset_enum[E_HMPLAYER];
    HitMarket:BountyData[playerid] = reset_enum;

    HitMarket:BountyData[playerid][timesTargeted] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HitsTimesTargeted");
    HitMarket:BountyData[playerid][placedHits] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HitsPlaced");
    HitMarket:BountyData[playerid][moneySpent] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HitsPlacedAmount");
    HitMarket:BountyData[playerid][claimedBounties] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HitsClaimed");
    HitMarket:BountyData[playerid][claimedBountyAmount] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HitsClaimedAmount");
    return 1;
}

HitMarket:ActiveHits(playerid = -1) {
    new query[512];
    if (playerid == -1) mysql_format(Database, query, sizeof(query), "SELECT count(*) as total FROM hitMarketHits WHERE Status=0");
    else mysql_format(Database, query, sizeof(query), "SELECT count(*) as total FROM hitMarketHits WHERE PlacedBy = \"%s\" && Status=0", GetPlayerNameEx(playerid));

    new Cache:result = mysql_query(Database, query);
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

HitMarket:RewardCount(playerid) {
    new Cache:result = mysql_query(Database, sprintf("SELECT count(*) as total FROM hitMarketHits WHERE CompletedBy = \"%s\" && Status=1", GetPlayerNameEx(playerid)));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

forward PurgeExpiredHits();
public PurgeExpiredHits() {
    mysql_tquery(Database, "DELETE FROM hitMarketHits WHERE PlacedOn + (86400 * 7) < UNIX_TIMESTAMP()");
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "HitsTimesTargeted", "int", "0");
    Database:AddColumn("playerdata", "HitsPlaced", "int", "0");
    Database:AddColumn("playerdata", "HitsPlacedAmount", "int", "0");
    Database:AddColumn("playerdata", "HitsClaimed", "int", "0");
    Database:AddColumn("playerdata", "HitsClaimedAmount", "int", "0");

    // set payphone label ids to -1
    for (new i; i < sizeof(HitMarket:Phones); i++) HitMarket:Phones[i][phoneLabel] = Text3D:  - 1;

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `hitMarketHits` (\
	  `Target` varchar(24) NOT NULL,\
	  `Bounty` int(11) NOT NULL,\
	  `PlacedBy` varchar(24) NOT NULL,\
	  `PlacedOn` int(11) NOT NULL,\
	  `CompletedBy` varchar(24),\
	  `CompletedOn` int(11) NOT NULL Default '0',\
	  `Status` tinyint(1) NOT NULL Default '0',\
	  PRIMARY KEY (`Target`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");

    // set purge timer
    PurgeTimer = SetPreciseTimer("PurgeExpiredHits", 180000, true);
    PurgeExpiredHits();

    // create payphone labels
    for (new i; i < sizeof(HitMarket:Phones); i++) HitMarket:Phones[i][phoneLabel] = CreateDynamic3DTextLabel("press N to us hitmarket", 0x27AE60FF, HitMarket:Phones[i][phoneX], HitMarket:Phones[i][phoneY], HitMarket:Phones[i][phoneZ] + 1.5, 5.0);
    return 1;
}

hook OnGameModeExit() {
    // remove payphone labels
    for (new i; i < sizeof(HitMarket:Phones); i++)
        if (HitMarket:Phones[i][phoneLabel] != Text3D:  - 1) DestroyDynamic3DTextLabel(HitMarket:Phones[i][phoneLabel]);

    // kill purge timer
    DeletePreciseTimer(PurgeTimer);
    return 1;
}

hook OnPlayerLogin(playerid) {
    HitMarket:PlayerInit(playerid);
    mysql_tquery(Database, sprintf("SELECT * FROM hitMarketHits WHERE Target = \"%s\" && Status = 0", GetPlayerNameEx(playerid)), "HitMarketHasBounty", "i", playerid);
    return 1;
}

forward HitMarketHasBounty(playerid);
public HitMarketHasBounty(playerid) {
    HitMarket:BountyData[playerid][hasBounty] = !!cache_num_rows();
    return 1;
}

hook OnPlayerKilled(playerid, killerid, weaponid) {
    HitMarket:OnPlayerDeath(playerid, killerid);
    return 1;
}

stock HitMarket:OnPlayerDeath(playerid, killerid) {
    if (IsPlayerConnected(killerid) && HitMarket:BountyData[playerid][hasBounty]) {
        HitMarket:BountyData[playerid][timesTargeted]++;
        HitMarket:BountyData[playerid][hasBounty] = false;

        mysql_tquery(Database, sprintf(
            "update hitMarketHits set CompletedOn = UNIX_TIMESTAMP(), CompletedBy = \"%s\", status = 1 where target = \"%s\"",
            GetPlayerNameEx(killerid), GetPlayerNameEx(playerid)
        ));

        Database:UpdateInt(HitMarket:BountyData[playerid][timesTargeted], GetPlayerNameEx(playerid), "username", "HitsTimesTargeted");
        SendClientMessageEx(killerid, 0x27AE60FF, "[HIT MARKET] {FFFFFF}The person you killed had a hit, find a payphone to claim your reward.");
    }

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    if (!IsPlayerInAnyVehicle(playerid) && HitMarket:IsPlayerNearAPayphone(playerid)) {
        HitMarket:ShowMarketMenu(playerid);
        return ~1;
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `hitMarketHits` SET `Target` = \"%s\" WHERE  `Target` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `hitMarketHits` SET `PlacedBy` = \"%s\" WHERE  `PlacedBy` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `hitMarketHits` SET `CompletedBy` = \"%s\" WHERE  `CompletedBy` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `hitMarketHits` WHERE `Target` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `hitMarketHits` WHERE `PlacedBy` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `hitMarketHits` WHERE `CompletedBy` = \"%s\"", AccountName));
    return 1;
}

HitMarket:ShowMarketMenu(playerid) {
    new string[512];
    strcat(string, sprintf("Hello,\t%s\n", GetPlayerNameEx(playerid)));
    strcat(string, "Place Hit\n");
    strcat(string, sprintf("Active Hits\t{F1C40F}(%d)\n", HitMarket:ActiveHits()));
    strcat(string, sprintf("My Hits\t{F1C40F}(%d)\n", HitMarket:ActiveHits(playerid)));
    strcat(string, sprintf("Claim Rewards\t{F1C40F}(%d)\n", HitMarket:RewardCount(playerid)));
    strcat(string, sprintf("My Stats\n"));
    return FlexPlayerDialog(playerid, "HitMarketShowMarketMenu", DIALOG_STYLE_TABLIST_HEADERS, "Hit Market", string, "Select", "Close");
}

FlexDialog:HitMarketShowMarketMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Place Hit")) return HitMarket:MenuPlaceHit(playerid);
    if (IsStringSame(inputtext, "Active Hits")) return HitMarket:MenuActiveHits(playerid);
    if (IsStringSame(inputtext, "My Hits")) return HitMarket:MenuMyHits(playerid);
    if (IsStringSame(inputtext, "Claim Rewards")) return HitMarket:MenuClaimRewards(playerid);
    if (IsStringSame(inputtext, "My Stats")) return HitMarket:MenuMyStats(playerid);
    return 1;
}

HitMarket:MenuPlaceHit(playerid) {
    return FlexPlayerDialog(playerid, "HitMarketMenuPlaceHit", DIALOG_STYLE_INPUT, "Hit Market  {FFFFFF}Place Hit (Step 1)", "Write the target's name:", "Next", "Back");
}

FlexDialog:HitMarketMenuPlaceHit(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return HitMarket:ShowMarketMenu(playerid);
    new targetName[50];
    if (sscanf(inputtext, "s[50]", targetName) || !IsAccountActive(targetName)) return HitMarket:MenuPlaceHit(playerid);
    return HitMarket:MenuPlaceHitPrice(playerid, targetName);
}

HitMarket:MenuPlaceHitPrice(playerid, const targetName[]) {
    return FlexPlayerDialog(
        playerid, "HitMarketMenuPlaceHitPrice", DIALOG_STYLE_INPUT,
        "Hit Market  {FFFFFF}Place Hit (Step 2)",
        "Write the amount you want to place on target's head:\n\n{4286f4}Amount must be between $5,000 - $5,000,000.",
        "Done", "Back", -1, targetName
    );
}

FlexDialog:HitMarketMenuPlaceHitPrice(playerid, response, listitem, const inputtext[], extraid, const targetName[]) {
    if (!response) return HitMarket:MenuPlaceHit(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 5000 || amount > 5000000) return HitMarket:MenuPlaceHitPrice(playerid, targetName);
    HitMarket:BountyData[playerid][placedHits]++;
    HitMarket:BountyData[playerid][moneySpent] += amount;

    mysql_tquery(Database, sprintf(
        "INSERT INTO hitMarketHits SET Target = \"%s\", Bounty=%d, PlacedBy = \"%s\", PlacedOn=UNIX_TIMESTAMP() ON DUPLICATE KEY UPDATE Bounty=Bounty+%d",
        targetName, amount, GetPlayerNameEx(playerid), amount
    ));

    Database:UpdateInt(HitMarket:BountyData[playerid][placedHits], GetPlayerNameEx(playerid), "username", "HitsPlaced");
    Database:UpdateInt(HitMarket:BountyData[playerid][moneySpent], GetPlayerNameEx(playerid), "username", "HitsPlacedAmount");

    new targetID = GetPlayerIDByName(targetName);
    if (IsPlayerConnected(targetID)) HitMarket:BountyData[targetID][hasBounty] = true;

    SendClientMessageToMafia("{FFFF00}A new hit has been placed, check the payphone for more information");
    SendClientMessageEx(playerid, 0x27AE60FF, sprintf("[HIT MARKET] {FFFFFF}Hit placed on %s.", targetName));
    GivePlayerCash(playerid, -amount, sprintf("[HIT MARKET]: Hit placed on %s.", targetName));
    return HitMarket:ShowMarketMenu(playerid);
}

HitMarket:MenuMyHits(playerid) {
    return HitMarket:MenuActiveHits(playerid, 1);
}

HitMarket:MenuActiveHits(playerid, onlymine = 0) {
    return FlexPlayerDialog(
        playerid, "HitMarketMenuActiveHits", DIALOG_STYLE_LIST, "Hit Market  {FFFFFF}Active Hits",
        "Sort By Bounty\nSort By Placement Date", "Select", "Back", onlymine
    );
}

FlexDialog:HitMarketMenuActiveHits(playerid, response, listitem, const inputtext[], onlymine, const payload[]) {
    if (!response) return HitMarket:ShowMarketMenu(playerid);
    return HitMarket:ShowActiveHits(playerid, 0, listitem, onlymine);
}

HitMarket:FormatTime(seconds) {
    new string[32], days = floatround((seconds % 2592000) / 86400, floatround_floor);
    if (seconds < 0) {
        format(string, sizeof(string), "Expired");
        return string;
    }

    if (days > 0) {
        format(string, sizeof(string), "%dd %02dh %02dm %02ds", days, floatround((seconds % 86400) / 3600, floatround_floor), floatround((seconds % 3600) / 60, floatround_floor), seconds % 60);
    } else {
        format(string, sizeof(string), "%02dh %02dm %02ds", floatround((seconds % 86400) / 3600, floatround_floor), floatround((seconds % 3600) / 60, floatround_floor), seconds % 60);
    }
    return string;
}

HitMarket:ShowActiveHits(playerid, page = 0, sortby = 0, onlymine = 0) {
    new perpage = 10;
    new total = HitMarket:ActiveHits();
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:active_query = mysql_query(Database, sprintf(
        "SELECT Target, Bounty, PlacedOn FROM hitMarketHits WHERE Status=0 %s ORDER BY %s DESC LIMIT %d, %d",
        onlymine ? sprintf("and PlacedBy = \"%s\"", GetPlayerNameEx(playerid)) : "",
        sortby ? "PlacedOn" : "Bounty", skip, perpage
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(active_query);
        SendClientMessageEx(playerid, -1, "[Error]:{FFFFFF}No active hits found.");
        return HitMarket:ShowMarketMenu(playerid);
    }

    new placed_on, Bounty, target[MAX_PLAYER_NAME], string[2000];
    format(string, sizeof(string), "Target\tBounty\tTime Left\n");
    for (new i; i < rows; i++) {
        cache_get_value_name(i, "Target", target, .max_len = 128);
        cache_get_value_name_int(i, "PlacedOn", placed_on);
        cache_get_value_name_int(i, "Bounty", Bounty);
        strcat(string, sprintf("%s\t{2ECC71}%s\t%s\n", target, FormatCurrencyEx(Bounty), HitMarket:FormatTime((placed_on + 604800) - gettime())));
    }
    cache_delete(active_query);

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(
        playerid, "HitMarketShowActiveHits", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Hit Market  {FFFFFF}Active Hits (%d)", total),
        string, "Select", "Close", page, sprintf("%d %d", sortby, onlymine)
    );
}

FlexDialog:HitMarketShowActiveHits(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new sortby, onlymine;
    sscanf(payload, "dd", sortby, onlymine);
    if (!response) return HitMarket:ShowMarketMenu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return HitMarket:ShowActiveHits(playerid, page + 1, sortby, onlymine);
    if (IsStringSame(inputtext, "Back Page")) return HitMarket:ShowActiveHits(playerid, page - 1, sortby, onlymine);
    return HitMarket:ShowHitInfo(playerid, inputtext, onlymine);
}

HitMarket:ShowHitInfo(playerid, const targetName[], onlymine = 0) {
    new Cache:hit_query = mysql_query(Database, sprintf(
        "SELECT Bounty, PlacedOn, FROM_UNIXTIME(PlacedOn, '%%d/%%m/%%Y %%H:%%i:%%s') AS PlaceDate FROM hitMarketHits WHERE Target = \"%s\" && Status=0", targetName
    ));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(hit_query);
        SendClientMessageEx(playerid, -1, "[Error]:{FFFFFF} Hit not found.");
        return HitMarket:ShowMarketMenu(playerid);
    }
    new string[384], last_loc[MAX_ZONE_NAME], placeint, Bounty, placedate[20];
    cache_get_value_name_int(0, "PlacedOn", placeint);
    cache_get_value_name(0, "PlaceDate", placedate, .max_len = 128);

    new id = GetPlayerIDByName(targetName);
    if (!IsPlayerConnected(id)) format(last_loc, sizeof(last_loc), "Unknown");
    else GetPlayer3DZone(id, last_loc, MAX_ZONE_NAME);
    cache_get_value_name_int(0, "Bounty", Bounty);

    format(string, sizeof(string),
        "{FFFFFF}Target: {F1C40F}%s\n{FFFFFF}Last Location: {F1C40F}%s\n{FFFFFF}Bounty: {2ECC71}%s\n\n{FFFFFF}Hit Placed On: {F1C40F}%s\n{FFFFFF}Time Left: {F1C40F}%s",
        targetName, last_loc, FormatCurrencyEx(Bounty), placedate, HitMarket:FormatTime((placeint + (86400 * 7)) - gettime())
    );
    return FlexPlayerDialog(
        playerid, "HitMarketShowHitInfo", DIALOG_STYLE_MSGBOX, "Hit Market  {FFFFFF}Target Info", string, onlymine ? "Cancel" : "Okay", "Back", onlymine, targetName
    );
}

FlexDialog:HitMarketShowHitInfo(playerid, response, listitem, const inputtext[], onlymine, const targetName[]) {
    if (onlymine) {
        mysql_tquery(Database, sprintf("DELETE FROM hitMarketHits WHERE Target = \"%s\" && PlacedBy = \"%s\" && Status=0", targetName, GetPlayerNameEx(playerid)));
        SendClientMessageEx(playerid, 0x27AE60FF, sprintf("[HIT MARKET] {FFFFFF}Hit on {F1C40F}%s {FFFFFF}cancelled.", targetName));
    }
    return HitMarket:ShowMarketMenu(playerid);
}

HitMarket:MenuMyStats(playerid) {
    new string[512];
    strcat(string, sprintf("Times Targeted\t%s", FormatCurrencyEx(HitMarket:BountyData[playerid][timesTargeted], .iCurrencyChar = '\0')));
    strcat(string, sprintf("Hit Placed\t%s {2ECC71}(%s)", FormatCurrencyEx(HitMarket:BountyData[playerid][placedHits], .iCurrencyChar = '\0'), FormatCurrencyEx(HitMarket:BountyData[playerid][moneySpent])));
    strcat(string, sprintf("Claims\t%s {2ECC71}(%s)", FormatCurrencyEx(HitMarket:BountyData[playerid][claimedBounties], .iCurrencyChar = '\0'), FormatCurrencyEx(HitMarket:BountyData[playerid][claimedBountyAmount])));
    return FlexPlayerDialog(playerid, "HitMarketMenuMyStats", DIALOG_STYLE_TABLIST, "Hit Market  {FFFFFF}Stats", string, "Select", "Back");
}

FlexDialog:HitMarketMenuMyStats(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    return HitMarket:ShowMarketMenu(playerid);
}

HitMarket:MenuClaimRewards(playerid, page = 0) {
    new perpage = 10;
    new total = HitMarket:RewardCount(playerid);
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:active_query = mysql_query(Database, sprintf(
        "SELECT Target, Bounty, FROM_UNIXTIME(CompletedOn, '%%d/%%m/%%Y %%H:%%i') as CompDate FROM hitMarketHits WHERE Status = 1 and CompletedBy = \"%s\" ORDER BY CompletedOn DESC LIMIT %d, %d",
        GetPlayerNameEx(playerid), skip, perpage
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(active_query);
        SendClientMessageEx(playerid, -1, "[Error]:{FFFFFF}No active hits found.");
        return HitMarket:ShowMarketMenu(playerid);
    }

    new target[MAX_PLAYER_NAME], date[20], string[2000], Bounty;
    format(string, sizeof(string), "Target\tBounty\tCompleted On\n");
    for (new i; i < rows; i++) {
        cache_get_value_name(i, "Target", target, .max_len = 128);
        cache_get_value_name(i, "CompDate", date, .max_len = 128);
        cache_get_value_name_int(i, "Bounty", Bounty);
        strcat(string, sprintf("%s\t{2ECC71}%s\t%s\n", target, FormatCurrencyEx(Bounty), date));
    }
    cache_delete(active_query);

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(
        playerid, "HitMarketMenuClaimRewards", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Hit Market  {FFFFFF}Claim Hits (%d)", total),
        string, "Claim", "Close", page
    );
}

FlexDialog:HitMarketMenuClaimRewards(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return HitMarket:ShowMarketMenu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return HitMarket:ShowActiveHits(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return HitMarket:ShowActiveHits(playerid, page - 1);
    return HitMarket:ClaimHit(playerid, inputtext);
}

HitMarket:ClaimHit(playerid, const targetName[]) {
    new Cache:hit_query = mysql_query(Database, sprintf(
        "SELECT * FROM hitMarketHits WHERE Status = 1 and CompletedBy = \"%s\" and Target = \"%s\" limit 1",
        GetPlayerNameEx(playerid), targetName
    ));

    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(hit_query);
        SendClientMessageEx(playerid, -1, "[Error]:{FFFFFF} Invalid claim.");
        return HitMarket:ShowMarketMenu(playerid);
    }

    new money;
    cache_get_value_name_int(0, "Bounty", money);
    cache_delete(hit_query);

    HitMarket:BountyData[playerid][claimedBounties]++;
    HitMarket:BountyData[playerid][claimedBountyAmount] += money;

    Database:UpdateInt(HitMarket:BountyData[playerid][claimedBounties], GetPlayerNameEx(playerid), "username", "HitsClaimed");
    Database:UpdateInt(HitMarket:BountyData[playerid][claimedBountyAmount], GetPlayerNameEx(playerid), "username", "HitsClaimedAmount");

    GivePlayerCash(playerid, money, sprintf("[HIT MARKET] Hit on %s completed for %s.", targetName, FormatCurrencyEx(money)));
    mysql_tquery(Database, sprintf("delete from hitMarketHits WHERE Status = 1 and CompletedBy = \"%s\" and Target = \"%s\" limit 1", GetPlayerNameEx(playerid), targetName));
    SendClientMessageEx(playerid, 0x27AE60FF, sprintf("[HIT MARKET] {FFFFFF}Hit on {F1C40F}%s {FFFFFF}completed for {2ECC71}%s.", targetName, FormatCurrencyEx(money)));

    return HitMarket:ShowMarketMenu(playerid);
}