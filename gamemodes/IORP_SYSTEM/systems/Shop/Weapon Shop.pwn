enum E_WEAPON_SHOP_DATA {
    WEAPON_MODELID,
    WEAPON_NAME[35],
    WEAPON_PRICE,
    WEAPON_AMMO,
    WEAPON_ID
};

new const WEAPON_SHOP[][E_WEAPON_SHOP_DATA] = {
    { 335, "Knife", 50, 1, WEAPON_KNIFE },
    { 341, "Chainsaw", 1500, 1, WEAPON_CHAINSAW },
    { 342, "Grenade", 1545, 1, WEAPON_GRENADE },
    { 343, "Moltove", 1745, 1, WEAPON_MOLTOV },
    { 347, "Silenced 9mm", 1500, 150, WEAPON_SILENCED },
    { 348, "Desert Eagle", 3199, 150, WEAPON_DEAGLE },
    { 350, "Sawed Off Shotgun", 4999, 100, WEAPON_SAWEDOFF },
    { 351, "Spas12 Shotgun", 3870, 100, WEAPON_SHOTGSPA },
    { 352, "Micro-UZI", 3500, 300, WEAPON_UZI },
    { 353, "MP5", 2999, 200, WEAPON_MP5 },
    { 372, "Tec-9", 3500, 300, WEAPON_TEC9 },
    { 358, "Sniper Rifle", 4999, 50, WEAPON_SNIPER },
    { 355, "Ak47", 2999, 200, WEAPON_AK47 },
    { 356, "M4", 3155, 200, WEAPON_M4 },
    { 359, "RPG", 1999, 1, WEAPON_ROCKETLAUNCHER },
    { 361, "Flamethrower", 3500, 350, WEAPON_FLAMETHROWER },
    //{362, "Minigun", 10000, 350, WEAPON_MINIGUN},
    { 363, "Satchel Charge", 1999, 2, WEAPON_SATCHEL },
    { 365, "Spray Can", 800, 200, WEAPON_SPRAYCAN },
    { 366, "Fire Extinguisher", 855, 200, WEAPON_FIREEXTINGUISHER }
};

stock WeaponShopMenu(playerid) {
    if (!WeaponLicense:IsHaveActiveLicense(playerid)) return AlexaMsg(playerid, "you need weapon license from sapd to purchase weapons!");
    if (!Event:IsInEvent(playerid) || Event:GetID(playerid) != COD_Event_ID) return AlexaMsg(playerid, "Weapon purchase not allowed from this shop!");

    if (IsAndroidPlayer(playerid)) {
        new string[2000];
        strcat(string, "Weapon\tPrice");
        for (new i; i < sizeof(WEAPON_SHOP); i++) {
            strcat(string, sprintf("\n%s\t$%s", WEAPON_SHOP[i][WEAPON_NAME], FormatCurrency(WEAPON_SHOP[i][WEAPON_PRICE])));
        }
        return FlexPlayerDialog(playerid, "WeaponShopMenu", DIALOG_STYLE_TABLIST_HEADERS, "Weapon Shop Dialog", string, "Purchase", "Cancel");
    }
    static string[sizeof(WEAPON_SHOP) * 64];
    if (string[0] == EOS) {
        for (new i; i < sizeof(WEAPON_SHOP); i++) {
            format(string, sizeof string, "%s%i(0.0, 0.0, -50.0, 1.5)\t%s~n~~g~~h~$%i\n", string, WEAPON_SHOP[i][WEAPON_MODELID], WEAPON_SHOP[i][WEAPON_NAME], WEAPON_SHOP[i][WEAPON_PRICE]);
        }
    }
    return FlexPlayerDialog(playerid, "WeaponShopMenu", DIALOG_STYLE_PREVIEW_MODEL, "Weapon Shop Dialog", string, "Purchase", "Cancel");
}

FlexDialog:WeaponShopMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    GiveExperiencePoint(playerid, -1, true);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[COD:MW]:{FFFFEE} %s weapon purchased, weapons take -1 exp of yours on every purchase.", WEAPON_SHOP[listitem][WEAPON_NAME]));
    SendClientMessage(playerid, -1, "{4286f4}[COD:MW]:{FFFFEE} you can earn more exp by playing COD. Good luck.");
    GivePlayerWeaponEx(playerid, WEAPON_SHOP[listitem][WEAPON_ID], WEAPON_SHOP[listitem][WEAPON_AMMO]);
    GameTextForPlayer(playerid, "~g~Gun Purchased!", 3000, 3);
    return WeaponShopMenu(playerid);
}

stock GetWeaponIDFromItemID(shopItemId) {
    if (shopItemId == 48) return 1;
    if (shopItemId == 49) return 2;
    if (shopItemId == 50) return 3;
    if (shopItemId == 51) return 4;
    if (shopItemId == 52) return 5;
    if (shopItemId == 53) return 6;
    if (shopItemId == 54) return 7;
    if (shopItemId == 55) return 8;
    if (shopItemId == 56) return 9;
    if (shopItemId == 57) return 15;
    if (shopItemId == 58) return 16;
    if (shopItemId == 59) return 17;
    if (shopItemId == 60) return 18;
    if (shopItemId == 61) return 22;
    if (shopItemId == 62) return 23;
    if (shopItemId == 63) return 24;
    if (shopItemId == 64) return 25;
    if (shopItemId == 65) return 26;
    if (shopItemId == 66) return 27;
    if (shopItemId == 67) return 28;
    if (shopItemId == 68) return 29;
    if (shopItemId == 69) return 30;
    if (shopItemId == 70) return 31;
    if (shopItemId == 71) return 32;
    if (shopItemId == 72) return 33;
    if (shopItemId == 73) return 34;
    if (shopItemId == 74) return 35;
    if (shopItemId == 75) return 36;
    if (shopItemId == 76) return 37;
    if (shopItemId == 77) return 41;
    if (shopItemId == 78) return 42;
    if (shopItemId == 79) return 43;
    if (shopItemId == 80) return 46;
    if (shopItemId == 81) return 10;
    if (shopItemId == 82) return 11;
    if (shopItemId == 83) return 12;
    if (shopItemId == 84) return 13;
    if (shopItemId == 85) return 14;
    return -1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) == Shop_Type_Weapons) {
        WeaponPurchaseFromBuss(playerid, shopid, shopItemId);
        return ~1;
    }
    if (DynamicShopBusiness:GetType(shopid) == Shop_Type_Sex_Toy) {
        new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
        if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
        new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
        if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase this item"); return ~1; }
        new weaponid = GetWeaponIDFromItemID(shopItemId);
        if (weaponid == -1) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your purchase has been cancelled"); return ~1; }
        GivePlayerWeaponEx(playerid, weaponid, 1);
        DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased sex toy: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
        DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
        GivePlayerCash(playerid, -price, sprintf("Purchased %s sex toy from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shop]: {FFFFFF}you have purchased sex toy from %s store", DynamicShopBusiness:GetName(shopid)));
        return ~1;
    }
    return 1;
}

stock WeaponPurchaseFromBuss(playerid, shopid, shopItemId) {
    return FlexPlayerDialog(
        playerid, "WeaponPurchaseFromBuss", DIALOG_STYLE_INPUT, "Purchase Weapon", "Enter ammo, you need",
        "Purchase", "Cancel", shopid, sprintf("%d", shopItemId)
    );
}

FlexDialog:WeaponPurchaseFromBuss(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new ammo, shopid = extraid, shopItemId = strval(payload);
    new weaponid = GetWeaponIDFromItemID(shopItemId);
    new stockPrice = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    new ammoStock = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (sscanf(inputtext, "d", ammo)) return WeaponPurchaseFromBuss(playerid, shopid, shopItemId);
    if (ammo < 1 || ammo > 500 || ammo > ammoStock) return WeaponPurchaseFromBuss(playerid, shopid, shopItemId);
    new requiredCash = stockPrice * ammo;
    if (GetPlayerCash(playerid) < requiredCash) return WeaponPurchaseFromBuss(playerid, shopid, shopItemId);
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, ammoStock - ammo);
    DynamicShopBusiness:IncreaseBalance(shopid, requiredCash, sprintf("%s purchased weapon item: %s with ammo %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId), ammo));
    GivePlayerCash(playerid, -requiredCash, sprintf("purchased %s weapon with %d ammo", GetWeaponNameEx(weaponid), ammo));
    GivePlayerWeaponEx(playerid, weaponid, ammo);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Shop]: {FFFFFF} you have purchased %s weapon with %d ammo", GetWeaponNameEx(weaponid), ammo));
    return 1;
}