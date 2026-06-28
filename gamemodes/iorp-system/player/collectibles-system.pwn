new DIALOG_COLLECTIBLES_MENU, DIALOG_COLLECTIBLES_PROGRESS, DIALOG_COLLECTIBLES_PROGRESS_2, DIALOG_COLLECTIBLES_RESET, DIALOG_COLLECTIBLES_RESET_2;
#define     COLLECTIBLE_REWARD      (250)   	// $250 for each collectible collected
#define     COMPLETION_REWARD       (15000) 	// $15000 reward if somebody collects all collectibles of one type

enum E_COLLECTIBLE_TYPE {
    typeName[16],
        typeModel
}

enum E_COLLECTIBLE {
    colType,
    Float:colX,
    Float:colY,
    Float:colZ,
    colPickup
}

enum _:E_COLLECTIBLE_TYPE_REF {
    TYPE_OYSTER, // reference to CollectibleTypes index 0
    TYPE_HORSESHOE // reference to CollectibleTypes index 1
}

new CollectibleTypes[][E_COLLECTIBLE_TYPE] = {
    //  {name, model id}
    { "Oyster", 953 }, // index 0
    { "Horseshoe", 954 } // index 1
};

new CollectibleData[][E_COLLECTIBLE] = {
    //  {type, pos x, pos y, pos z}
    { TYPE_HORSESHOE, 1224.0, 2617.0, 11.0 },
    { TYPE_HORSESHOE, 2323.0, 1284.0, 97.0 },
    { TYPE_HORSESHOE, 2035.0, 2305.0, 18.0 },
    { TYPE_HORSESHOE, 2491.0, 2263.0, 15.0 },
    { TYPE_HORSESHOE, 1433.0, 2796.0, 20.0 },
    { TYPE_HORSESHOE, 2071.0, 712.0, 11.0 },
    { TYPE_HORSESHOE, 2239.0, 1839.0, 18.0 },
    { TYPE_HORSESHOE, 2583.0, 2387.0, 16.0 },
    { TYPE_HORSESHOE, 2864.0, 857.0, 13.0 },
    { TYPE_HORSESHOE, 2612.0, 2200.0, -1.0 },
    { TYPE_HORSESHOE, 2274.0, 1507.0, 24.0 },
    { TYPE_HORSESHOE, 2184.0, 2529.0, 11.0 },
    { TYPE_HORSESHOE, 1863.0, 2314.0, 15.0 },
    { TYPE_HORSESHOE, 2054.0, 2434.0, 166.0 },
    { TYPE_HORSESHOE, 1603.0, 1435.0, 11.0 },
    { TYPE_HORSESHOE, 1362.92, 1015.24, 11.0 },
    { TYPE_HORSESHOE, 2058.7, 2159.1, 16.0 },
    { TYPE_HORSESHOE, 2003.0, 1672.0, 12.0 },
    { TYPE_HORSESHOE, 2238.0, 1135.0, 49.0 },
    { TYPE_HORSESHOE, 1934.06, 988.79, 22.0 },
    { TYPE_HORSESHOE, 1768.0, 2847.0, 9.0 },
    { TYPE_HORSESHOE, 1084.0, 1076.0, 11.0 },
    { TYPE_HORSESHOE, 2879.0, 2522.0, 11.0 },
    { TYPE_HORSESHOE, 2371.0, 2009.0, 15.0 },
    { TYPE_HORSESHOE, 1521.0, 1690.0, 10.6 },
    { TYPE_HORSESHOE, 2417.0, 1281.0, 21.0 },
    { TYPE_HORSESHOE, 1376.0, 2304.0, 15.0 },
    { TYPE_HORSESHOE, 1393.0, 1832.0, 12.34 },
    { TYPE_HORSESHOE, 984.0, 2563.0, 12.0 },
    { TYPE_HORSESHOE, 1767.0, 601.0, 13.0 },
    { TYPE_HORSESHOE, 2108.0, 1003.0, 46.0 },
    { TYPE_HORSESHOE, 2705.98, 1862.52, 24.41 },
    { TYPE_HORSESHOE, 2493.0, 922.0, 16.0 },
    { TYPE_HORSESHOE, 1881.0, 2846.0, 11.0 },
    { TYPE_HORSESHOE, 2020.0, 2352.0, 11.0 },
    { TYPE_HORSESHOE, 1680.3, 2226.86, 16.11 },
    { TYPE_HORSESHOE, 1462.0, 936.0, 10.0 },
    { TYPE_HORSESHOE, 2125.5, 789.23, 11.45 },
    { TYPE_HORSESHOE, 2588.0, 1902.0, 15.0 },
    { TYPE_HORSESHOE, 919.0, 2070.0, 11.0 },
    { TYPE_HORSESHOE, 2173.0, 2465.0, 11.0 },
    { TYPE_HORSESHOE, 2031.25, 2207.33, 11.0 },
    { TYPE_HORSESHOE, 2509.0, 1144.0, 19.0 },
    { TYPE_HORSESHOE, 2215.0, 1968.0, 11.0 },
    { TYPE_HORSESHOE, 2626.0, 2841.0, 11.0 },
    { TYPE_HORSESHOE, 2440.08, 2161.07, 20.0 },
    { TYPE_HORSESHOE, 1582.0, 2401.0, 19.0 },
    { TYPE_HORSESHOE, 2077.0, 1912.0, 14.0 },
    { TYPE_HORSESHOE, 970.0, 1787.0, 11.0 },
    { TYPE_HORSESHOE, 1526.22, 751.0, 29.04 },
    { TYPE_OYSTER, 979.0, -2210.0, -3.0 },
    { TYPE_OYSTER, 2750.0, -2584.0, -5.0 },
    { TYPE_OYSTER, 1279.0, -806.0, 85.0 },
    { TYPE_OYSTER, 2945.13, -2051.93, -3.0 },
    { TYPE_OYSTER, 67.0, -1018.0, -5.0 },
    { TYPE_OYSTER, 2327.0, -2662.0, -5.0 },
    { TYPE_OYSTER, 2621.0, -2506.0, -5.0 },
    { TYPE_OYSTER, 1249.0, -2687.0, -1.0 },
    { TYPE_OYSTER, 725.0, -1849.0, -5.0 },
    { TYPE_OYSTER, 723.0, -1586.0, -3.0 },
    { TYPE_OYSTER, 155.0, -1975.0, -8.0 },
    { TYPE_OYSTER, 1968.0, -1203.0, 17.0 },
    { TYPE_OYSTER, -2657.0, 1564.0, -6.0 },
    { TYPE_OYSTER, -1252.0, 501.0, -8.0 },
    { TYPE_OYSTER, -1625.0, 4.0, -10.0 },
    { TYPE_OYSTER, -1484.0, 1489.0, -10.0 },
    { TYPE_OYSTER, -2505.406, 1543.724, -22.5553 },
    { TYPE_OYSTER, -2727.0, -469.0, -5.0 },
    { TYPE_OYSTER, -1266.0, 966.0, -10.0 },
    { TYPE_OYSTER, -1013.0, 478.0, -7.0 },
    { TYPE_OYSTER, -1364.0, 390.0, -5.0 },
    { TYPE_OYSTER, 2578.0, 2382.0, 16.0 },
    { TYPE_OYSTER, 2090.0, 1898.0, 8.0 },
    { TYPE_OYSTER, 2130.0, 1152.0, 7.0 },
    { TYPE_OYSTER, 2013.0, 1670.0, 7.0 },
    { TYPE_OYSTER, 2531.0, 1569.0, 9.0 },
    { TYPE_OYSTER, 2998.0, 2998.0, -10.0 },
    { TYPE_OYSTER, -832.0, 925.0, -2.0 },
    { TYPE_OYSTER, 486.0, -253.0, -4.0 },
    { TYPE_OYSTER, -90.0, -910.0, -5.0 },
    { TYPE_OYSTER, 26.43, -1320.94, -10.04 },
    { TYPE_OYSTER, -207.0, -1682.0, -8.0 },
    { TYPE_OYSTER, -1672.0, -1641.0, -2.0 },
    { TYPE_OYSTER, -1175.0, -2639.0, -2.5 },
    { TYPE_OYSTER, -1097.0, -2858.0, -8.0 },
    { TYPE_OYSTER, -2889.0, -1042.0, -9.0 },
    { TYPE_OYSTER, -659.0, 874.0, -2.0 },
    { TYPE_OYSTER, -955.0, 2628.0, 35.0 },
    { TYPE_OYSTER, -1066.0, 2197.0, 32.0 },
    { TYPE_OYSTER, 40.0, -531.0, -8.0 },
    { TYPE_OYSTER, -765.0, 247.0, -8.0 },
    { TYPE_OYSTER, 2098.0, -108.0, -2.0 },
    { TYPE_OYSTER, 2767.0, 470.0, -8.0 },
    { TYPE_OYSTER, -783.0, 2116.0, 35.0 },
    { TYPE_OYSTER, -821.0, 1374.0, -8.0 },
    { TYPE_OYSTER, -2110.5, 2329.72, -7.5 },
    { TYPE_OYSTER, -1538.0, 1708.0, -3.27 },
    { TYPE_OYSTER, -2685.0, 2153.0, -5.0 },
    { TYPE_OYSTER, 796.0, 2939.0, -5.0 },
    { TYPE_OYSTER, 2179.0, 235.0, -5.0 }
};

new CollectiblePicked[MAX_PLAYERS][sizeof(CollectibleData)];

stock GetCollectedCount(playerid, type) {
    new count = 0;
    for (new i; i < sizeof(CollectibleData); i++)
        if (CollectibleData[i][colType] == type && CollectiblePicked[playerid][i] > 0) count++;
    return count;
}

stock GetCollectibleCount(type) {
    new count = 0;
    for (new i; i < sizeof(CollectibleData); i++)
        if (CollectibleData[i][colType] == type) count++;
    return count;
}

stock LoadPlayerProgress(playerid) {
    for (new i; i < sizeof(CollectibleData); i++) CollectiblePicked[playerid][i] = 0;
    new query[512];
    mysql_format(Database, query, sizeof(query), "SELECT * FROM `collectables` WHERE `Name` = \"%s\"", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "LoadPlayerProgress2", "i", playerid);
    return 1;
}

stock Collectible_ShowMenu(playerid, menu_id = -1, extra_id = -1) {
    if (menu_id == DIALOG_COLLECTIBLES_PROGRESS) {
        new string[196];
        format(string, sizeof(string), "Type\tCollected\tTotal\n");
        for (new i; i < sizeof(CollectibleTypes); i++) format(string, sizeof(string), "%s%s\t%d\t%d\n", string, CollectibleTypes[i][typeName], GetCollectedCount(playerid, i), GetCollectibleCount(i));
        ShowPlayerDialogEx(playerid, menu_id, 0, DIALOG_STYLE_TABLIST_HEADERS, "Collectibles » {FFFFFF}Progress", string, "Select", "Back");
    } else if (menu_id == DIALOG_COLLECTIBLES_PROGRESS_2) {
        new string[2048], col_name[16], title[36];
        format(col_name, sizeof(col_name), "%s", CollectibleTypes[extra_id][typeName]);
        format(title, sizeof(title), "Collectibles » {FFFFFF}%ss", col_name);
        for (new i, idx; i < sizeof(CollectibleData); i++) {
            if (CollectibleData[i][colType] != extra_id) continue;
            format(string, sizeof(string), "%s%s %d\t%s\n", string, col_name, idx + 1, (CollectiblePicked[playerid][i]) ? ("{2ECC71}Collected") : ("{4286f4}Not Collected"));
            idx++;
        }
        ShowPlayerDialogEx(playerid, menu_id, 0, DIALOG_STYLE_TABLIST, title, string, "Back", "");
    } else if (menu_id == DIALOG_COLLECTIBLES_RESET) {
        new string[196];
        for (new i; i < sizeof(CollectibleTypes); i++) format(string, sizeof(string), "%sReset %s Progress\n", string, CollectibleTypes[i][typeName]);
        ShowPlayerDialogEx(playerid, menu_id, 0, DIALOG_STYLE_LIST, "Collectibles » {FFFFFF}Reset", string, "Continue", "Back");
    } else if (menu_id == DIALOG_COLLECTIBLES_RESET_2) {
        new string[128];
        format(string, sizeof(string), "{FFFFFF}Do you want to reset your {F1C40F}%s {FFFFFF}progress?\n\n{4286f4}It will be gone forever!", CollectibleTypes[extra_id][typeName]);
        ShowPlayerDialogEx(playerid, menu_id, 0, DIALOG_STYLE_MSGBOX, "Collectibles » {FFFFFF}Reset", string, "Reset", "Back");
    } else ShowPlayerDialogEx(playerid, menu_id, 0, DIALOG_STYLE_LIST, "Collectibles", "My Progress\nReset Progress", "Select", "Close");
    return 1;
}

forward LoadPlayerProgress2(playerid);
public LoadPlayerProgress2(playerid) {
    new rows = cache_num_rows();
    if (rows) {
        new id, CBID;
        while (CBID < rows) {
            cache_get_value_name_int(CBID, "CollectibleID", id);
            CollectiblePicked[playerid][id] = 1;
            CBID++;
        }
    }
    return 1;
}

stock SaveProgress(playerid, CollectibleID, CollectibleType) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "INSERT INTO `collectables` SET `Name`=\"%s\",`CollectibleID`=%d,`CollectibleType`=%d", GetPlayerNameEx(playerid), CollectibleID, CollectibleType);
    mysql_tquery(Database, query);
    return 0;
}

stock ResetProgress(playerid) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "DELETE FROM `collectables` WHERE `Name`=\"%s\"", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query);
    return 0;
}


hook OnGameModeInit() {
    DIALOG_COLLECTIBLES_MENU = Dialog:GetFreeID();
    DIALOG_COLLECTIBLES_PROGRESS = Dialog:GetFreeID();
    DIALOG_COLLECTIBLES_PROGRESS_2 = Dialog:GetFreeID();
    DIALOG_COLLECTIBLES_RESET = Dialog:GetFreeID();
    DIALOG_COLLECTIBLES_RESET_2 = Dialog:GetFreeID();
    for (new i; i < sizeof(CollectibleData); i++) CollectibleData[i][colPickup] = CreateDynamicPickup(CollectibleTypes[CollectibleData[i][colType]][typeModel], 1, CollectibleData[i][colX], CollectibleData[i][colY], CollectibleData[i][colZ], -1);
    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `collectables` (`ID` int(11) NOT NULL auto_increment, `Name` varchar(24) NOT NULL,\
		`CollectibleID` int(11) NOT NULL, `CollectibleType` int(11) NOT NULL, PRIMARY KEY  (`ID`)) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    return 1;
}

hook OnGameModeExit() {
    for (new i; i < sizeof(CollectibleData); i++) DestroyDynamicPickup(CollectibleData[i][colPickup]);
    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    for (new i; i < sizeof(CollectibleData); i++) {
        if (pickupid == CollectibleData[i][colPickup]) {
            if (!CollectiblePicked[playerid][i]) {
                SaveProgress(playerid, i, CollectibleData[i][colType]);
                CollectiblePicked[playerid][i] = 1;
                new string[80], type = CollectibleData[i][colType], collected = GetCollectedCount(playerid, type), max_col = GetCollectibleCount(type);
                format(string, sizeof(string), "~w~%ss %d out of %d", CollectibleTypes[type][typeName], collected, max_col);
                GameTextForPlayer(playerid, string, 5000, 3);
                vault:PlayerVault(playerid, COLLECTIBLE_REWARD, "collectible reward", Vault_ID_Government, -COLLECTIBLE_REWARD, sprintf("%s collectible reward", GetPlayerNameEx(playerid)));
                if (collected == max_col) {
                    format(string, sizeof(string), "Congratulations! You collected every {F1C40F}%s {FFFFFF}around the map.", CollectibleTypes[type][typeName]);
                    SendClientMessageEx(playerid, -1, string);
                    format(string, sizeof(string), "Here's your well earned {2ECC71}$%s.", FormatCurrency(COMPLETION_REWARD));
                    SendClientMessageEx(playerid, -1, string);
                    vault:PlayerVault(playerid, COMPLETION_REWARD, sprintf("Congratulations! You collected every {F1C40F}%s {FFFFFF}around the map.", CollectibleTypes[type][typeName]), Vault_ID_Government, -COMPLETION_REWARD, sprintf("%s collectible completion reward", GetPlayerNameEx(playerid)));
                }
            } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFEE}Couldn't collect collectible.");
            break;
        }
    }
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid == DIALOG_COLLECTIBLES_MENU) {
        if (!response) return 1;
        if (listitem == 0) return Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_PROGRESS);
        if (listitem == 1) return Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_RESET);
    } else if (dialogid == DIALOG_COLLECTIBLES_PROGRESS) {
        if (!response) return Collectible_ShowMenu(playerid);
        Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_PROGRESS_2, listitem);
        return 1;
    } else if (dialogid == DIALOG_COLLECTIBLES_PROGRESS_2) {
        Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_PROGRESS);
        return 1;
    } else if (dialogid == DIALOG_COLLECTIBLES_RESET) {
        if (!response) return Collectible_ShowMenu(playerid);
        SetPVarInt(playerid, "progResetType", listitem);
        Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_RESET_2, listitem);
        return 1;
    } else if (dialogid == DIALOG_COLLECTIBLES_RESET_2) {
        if (!response) return Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_RESET);
        new res_type = GetPVarInt(playerid, "progResetType");
        ResetProgress(playerid);
        for (new i; i < sizeof(CollectibleData); i++)
            if (CollectibleData[i][colType] == res_type) CollectiblePicked[playerid][i] = 0;
        new string[64];
        format(string, sizeof(string), "%s {FFFFFF}progress reset.", CollectibleTypes[res_type][typeName]);
        SendClientMessageEx(playerid, 0xF1C40FFF, string);
        return 1;
    }
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    LoadPlayerProgress(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    UCP:AddCommand(playerid, "Collectibles");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Collectibles", inputtext)) Collectible_ShowMenu(playerid, DIALOG_COLLECTIBLES_MENU);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `collectables` SET `Name` = \"%s\" WHERE  `Name` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `collectables` WHERE `Name` = \"%s\"", AccountName));
    return 1;
}