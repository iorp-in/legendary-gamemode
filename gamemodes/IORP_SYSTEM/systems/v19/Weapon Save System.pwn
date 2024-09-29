#define weaponDataTable "weaponData"

new WssPlayerWeapons[MAX_PLAYERS][13][2];
new bool:WssFirstSpawn[MAX_PLAYERS];

hook OnGameModeInit() {
    Database:AddTable(weaponDataTable, "username", "varchar(100)", "", false);
    Database:AddColumn(weaponDataTable, "Slot_0_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_0_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_1_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_1_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_2_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_2_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_3_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_3_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_4_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_4_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_5_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_5_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_6_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_6_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_7_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_7_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_8_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_8_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_9_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_9_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_10_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_10_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_11_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_11_tWeaponAmmo", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_12_WeaponID", "int", "0");
    Database:AddColumn(weaponDataTable, "Slot_12_tWeaponAmmo", "int", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    Database:InitTable(weaponDataTable, "username", GetPlayerNameEx(playerid));
    WssPlayerWeapons[playerid][0][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_0_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][0][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_0_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][1][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_1_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][1][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_1_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][2][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_2_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][2][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_2_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][3][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_3_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][3][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_3_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][4][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_4_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][4][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_4_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][5][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_5_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][5][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_5_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][6][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_6_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][6][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_6_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][7][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_7_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][7][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_7_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][8][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_8_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][8][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_8_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][9][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_9_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][9][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_9_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][10][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_10_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][10][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_10_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][11][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_11_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][11][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_11_tWeaponAmmo", weaponDataTable);
    WssPlayerWeapons[playerid][12][0] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_12_WeaponID", weaponDataTable);
    WssPlayerWeapons[playerid][12][1] = Database:GetInt(GetPlayerNameEx(playerid), "username", "Slot_12_tWeaponAmmo", weaponDataTable);
    WssFirstSpawn[playerid] = false;
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if (!WssFirstSpawn[playerid]) {
        for (new i = 0; i <= 12; i++) GivePlayerWeaponEx(playerid, WssPlayerWeapons[playerid][i][0], WssPlayerWeapons[playerid][i][1]);
    }
    WssFirstSpawn[playerid] = true;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!IsPlayerLoggedIn(playerid)) return 1;
    // if(Event:IsInEvent(playerid) || Faction:IsPlayerSigned(playerid)) {
    if (Event:IsInEvent(playerid)) {
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_0_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_0_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_1_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_1_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_2_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_2_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_3_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_3_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_4_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_4_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_5_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_5_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_6_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_6_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_7_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_7_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_8_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_8_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_9_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_9_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_10_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_10_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_11_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_11_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_12_WeaponID", weaponDataTable);
        Database:UpdateInt(0, GetPlayerNameEx(playerid), "username", "Slot_12_tWeaponAmmo", weaponDataTable);
    } else {
        for (new i = 0; i <= 12; i++) GetPlayerWeaponData(playerid, i, WssPlayerWeapons[playerid][i][0], WssPlayerWeapons[playerid][i][1]);
        Database:UpdateInt(WssPlayerWeapons[playerid][0][0], GetPlayerNameEx(playerid), "username", "Slot_0_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][0][1], GetPlayerNameEx(playerid), "username", "Slot_0_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][1][0], GetPlayerNameEx(playerid), "username", "Slot_1_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][1][1], GetPlayerNameEx(playerid), "username", "Slot_1_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][2][0], GetPlayerNameEx(playerid), "username", "Slot_2_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][2][1], GetPlayerNameEx(playerid), "username", "Slot_2_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][3][0], GetPlayerNameEx(playerid), "username", "Slot_3_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][3][1], GetPlayerNameEx(playerid), "username", "Slot_3_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][4][0], GetPlayerNameEx(playerid), "username", "Slot_4_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][4][1], GetPlayerNameEx(playerid), "username", "Slot_4_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][5][0], GetPlayerNameEx(playerid), "username", "Slot_5_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][5][1], GetPlayerNameEx(playerid), "username", "Slot_5_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][6][0], GetPlayerNameEx(playerid), "username", "Slot_6_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][6][1], GetPlayerNameEx(playerid), "username", "Slot_6_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][7][0], GetPlayerNameEx(playerid), "username", "Slot_7_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][7][1], GetPlayerNameEx(playerid), "username", "Slot_7_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][8][0], GetPlayerNameEx(playerid), "username", "Slot_8_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][8][1], GetPlayerNameEx(playerid), "username", "Slot_8_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][9][0], GetPlayerNameEx(playerid), "username", "Slot_9_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][9][1], GetPlayerNameEx(playerid), "username", "Slot_9_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][10][0], GetPlayerNameEx(playerid), "username", "Slot_10_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][10][1], GetPlayerNameEx(playerid), "username", "Slot_10_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][11][0], GetPlayerNameEx(playerid), "username", "Slot_11_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][11][1], GetPlayerNameEx(playerid), "username", "Slot_11_tWeaponAmmo", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][12][0], GetPlayerNameEx(playerid), "username", "Slot_12_WeaponID", weaponDataTable);
        Database:UpdateInt(WssPlayerWeapons[playerid][12][1], GetPlayerNameEx(playerid), "username", "Slot_12_tWeaponAmmo", weaponDataTable);
    }
    return 1;
}

// On Account Action Performed
hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("update weaponData set username = \"%s\" where username = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("delete from weaponData where username = \"%s\"", AccountName));
    return 1;
}