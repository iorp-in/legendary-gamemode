hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `backpackGuns` (\
	  `BackpackID` int(11) NOT NULL,\
	  `WeaponID` tinyint(4) NOT NULL,\
	  `Ammo` int(11) NOT NULL,\
	  UNIQUE KEY `BackpackID_2` (`BackpackID`,`WeaponID`),\
	  KEY `BackpackID` (`BackpackID`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

new GunsInvItemID;
hook OnInventoryInit() {
    GunsInvItemID = Backpack:AddInventoryItem("Guns", 0);
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId != GunsInvItemID) return 1;
    FlexPlayerDialog(playerid, "InvGunMenu", DIALOG_STYLE_LIST, "Guns", "Put Gun\nTake Gun", "Choose", "Back", backPackId);
    return ~1;
}

FlexDialog:InvGunMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) {
        if (GetPlayerWeapon(playerid) == 0) return SendClientMessageEx(playerid, 0xE74C3CFF, "You can't put your fists in your backpack.");
        new weapon = GetPlayerWeapon(playerid), ammo = GetPlayerAmmo(playerid);
        RemovePlayerWeapon(playerid, weapon);
        mysql_tquery(Database, sprintf("INSERT INTO backpackGuns VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE Ammo=Ammo+%d", extraid, weapon, ammo, ammo), "", "");
        SendClientMessageEx(playerid, 0xE74C3CFF, sprintf("You have put %s in your backpack.", GetWeaponNameEx(weapon)));
        return ~1;
    }
    if (listitem == 1) {
        new Cache:weapons;
        weapons = mysql_query(Database, sprintf("SELECT WeaponID, Ammo FROM backpackGuns WHERE BackpackID=%d ORDER BY WeaponID ASC", extraid));
        new rows = cache_num_rows();
        if (rows) {
            new list[512], weapname[32], weapon_id, weapon_ammo;
            format(list, sizeof(list), "#\tWeapon Name\tAmmo\n");
            for (new i; i < rows; ++i) {
                cache_get_value_name_int(i, "WeaponID", weapon_id);
                cache_get_value_name_int(i, "Ammo", weapon_ammo);
                GetWeaponName(weapon_id, weapname, sizeof(weapname));
                format(list, sizeof(list), "%s%d\t%s\t%s\n", list, i + 1, weapname, FormatCurrency(weapon_ammo));
            }
            FlexPlayerDialog(playerid, "InvGunTakeMenu", DIALOG_STYLE_TABLIST_HEADERS, "Backpack Guns", list, "Take", "Back", extraid);
        } else {
            SendClientMessageEx(playerid, 0xE74C3CFF, "You don't have any guns in your backpack.");
        }
        cache_delete(weapons);
    }
    return 1;
}

FlexDialog:InvGunTakeMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new Cache:weapon;
    weapon = mysql_query(Database, sprintf("SELECT WeaponID, Ammo FROM backpackGuns WHERE BackpackID=%d ORDER BY WeaponID ASC LIMIT %d, 1", extraid, listitem));
    new rows = cache_num_rows();
    if (rows) {
        new string[64], weapname[32], weaponid, ammo;
        cache_get_value_name_int(0, "WeaponID", weaponid);
        cache_get_value_name_int(0, "Ammo", ammo);
        GetWeaponName(weaponid, weapname, sizeof(weapname));
        GivePlayerWeaponEx(playerid, weaponid, ammo);
        format(string, sizeof(string), "You've taken a %s from your backpack.", weapname);
        SendClientMessageEx(playerid, 0xFFFFFFFF, string);
        mysql_tquery(Database, sprintf("DELETE FROM backpackGuns WHERE BackpackID=%d AND WeaponID=%d", extraid, weaponid), "", "");
    } else {
        SendClientMessageEx(playerid, 0xE74C3CFF, "Can't find that weapon.");
    }
    cache_delete(weapon);
    return 1;
}