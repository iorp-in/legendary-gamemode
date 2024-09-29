#define Max_Buyable_Skin 10

hook OnGameModeInit() {
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        Database:AddColumn("playerdata", sprintf("Skin_%d", i), "int", "-1");
    }
    return 1;
}

new SkinData[MAX_PLAYERS][Max_Buyable_Skin];

hook OnPlayerConnect(playerid) {
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        SkinData[playerid][i] = -1;
        SkinData[playerid][i] = Database:GetInt(GetPlayerNameEx(playerid), "username", sprintf("Skin_%d", i));
    }
    return 1;
}

stock TotalPurchasedSkins(playerid) {
    new count = 0;
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        if (SkinData[playerid][i] != -1) count++;
    }
    return count;
}

stock GetFreeSkinSlot(playerid) {
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        if (SkinData[playerid][i] == -1) return i;
    }
    return -1;
}

stock IsSkinExistInCloset(playerid, skinid) {
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        if (SkinData[playerid][i] == skinid) return 1;
    }
    return 0;
}

stock GetSkinClosetSlot(playerid, skinid) {
    for (new i = 0; i < Max_Buyable_Skin; i++) {
        if (SkinData[playerid][i] == skinid) return i;
    }
    return -1;
}

stock OpenClotheManage(playerid) {
    if (!House:IsPlayerInOwnHouse(playerid) && !Hotel:IsPlayerInHotel(playerid)) SendClientMessage(playerid, -1, "This closet does not have your clothes, please use your own closet");
    new string[500];
    if (TotalPurchasedSkins(playerid) > 0) strcat(string, "Change Clothe\n");
    strcat(string, "Change Accessories\n");
    return FlexPlayerDialog(playerid, "OpenClotheManage", DIALOG_STYLE_LIST, "[Manage Clothe]: Select item", string, "Select", "Close");
}

FlexDialog:OpenClotheManage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Change Clothe")) return ClothShopChange(playerid);
    if (IsStringSame(inputtext, "Change Accessories")) return DisplayClothing(playerid);
    return 1;
}

stock ClothShopChange(playerid) {
    if (IsAndroidPlayer(playerid)) {
        new string[2000];
        strcat(string, "ModelID\tName");
        for (new i; i < Max_Buyable_Skin; i++) {
            if (SkinData[playerid][i] != -1) strcat(string, sprintf("\n%d\tID: %d", SkinData[playerid][i], SkinData[playerid][i]));
        }
        return FlexPlayerDialog(playerid, "ClothShopChange", DIALOG_STYLE_TABLIST_HEADERS, "Select Skin", string, "Select", "Cancel");
    }
    new string[Max_Buyable_Skin * 16];
    if (string[0] == EOS) {
        for (new i; i < Max_Buyable_Skin; i++) {
            if (SkinData[playerid][i] != -1) strcat(string, sprintf("%i\tID: %i\n", SkinData[playerid][i], SkinData[playerid][i]));
        }
    }
    return FlexPlayerDialog(playerid, "ClothShopChange", DIALOG_STYLE_PREVIEW_MODEL, "Select Skin", string, "Select", "Cancel");
}

FlexDialog:ClothShopChange(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new modelid = strval(inputtext);
    new string[500];
    strcat(string, "Put On this clothe\n");
    strcat(string, "Sell this clothe\n");
    return FlexPlayerDialog(playerid, "ClothShopChangeSel", DIALOG_STYLE_LIST, "[Clothe Shop]: Select item", string, "Select", "Close", modelid);
}

FlexDialog:ClothShopChangeSel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ClothShopChange(playerid);
    if (IsStringSame(inputtext, "Put On this clothe")) {
        SetPlayerSkinEx(playerid, extraid);
        GameTextForPlayer(playerid, "~g~Look Changed!", 3000, 3);
        SendClientMessage(playerid, -1, "{4286f4}[Closet]: {FFFFFF}hope you like your new style :)");
        UpdateAutospawnSkin(playerid, extraid);
        return 1;
    }
    if (IsStringSame(inputtext, "Sell this clothe")) {
        if (GetPlayerSkin(playerid) == extraid) {
            SendClientMessage(playerid, -1, "{4286f4}[Closet]: {FFFFFF}please first, take of your clothe to sell!");
            OpenClotheManage(playerid);
            return ~1;
        }
        new scash = RandomEx(1000, 5000);
        new slot = GetSkinClosetSlot(playerid, extraid);
        if (slot == -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Closet]: {FFFFFF}looks like you don't have this clothe!");
            OpenClotheManage(playerid);
            return ~1;
        }
        SkinData[playerid][slot] = -1;
        Database:UpdateInt(-1, GetPlayerNameEx(playerid), "username", sprintf("Skin_%d", slot));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Closet]: {FFFFFF}your clothe has been sold for $%s :)", FormatCurrency(scash)));
        GivePlayerCash(playerid, scash, "sold clothe");
        OpenClotheManage(playerid);
        return 1;
    }
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Clothes) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase this firework"); return ~1; }
    new skinid = DynamicShopBusinessItem:GetItemModelID(shopItemId);
    new slot = GetFreeSkinSlot(playerid);
    if (slot == -1) { SendClientMessage(playerid, -1, "{4286f4}[Clothe Shop]: {FFFFFF}you don't have enough room in your closet to purchase new clothe"); return ~1; }
    if (IsSkinExistInCloset(playerid, skinid)) { SendClientMessage(playerid, -1, "{4286f4}[Clothe Shop]: {FFFFFF}you have already purchased this skin!"); return ~1; }
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased cloth item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    GivePlayerCash(playerid, -price, sprintf("Purchased %s clothe from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    SkinData[playerid][slot] = skinid;
    SetPlayerSkinEx(playerid, skinid);
    Database:UpdateInt(skinid, GetPlayerNameEx(playerid), "username", sprintf("Skin_%d", slot));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Clothe Shop]: {FFFFFF}you have purchased clothes from %s store", DynamicShopBusiness:GetName(shopid)));
    return ~1;
}