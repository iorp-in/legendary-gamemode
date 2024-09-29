hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Garage) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) {
        AlexaMsg(playerid, "The store is out of stock, please contact the owner");
        return ~1;
    }
    PurchaseFuelMenu(playerid, shopid, shopItemId);
    return ~1;
}

stock PurchaseFuelMenu(playerid, shopid, shopItemId) {
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return AlexaMsg(playerid, "Fuel can only be purchased with a backpack");
    return FlexPlayerDialog(playerid, "PurchaseFuelMenu", DIALOG_STYLE_INPUT, "Purchase Fuel", "Enter amount of fuel you wish to purchase\nLimit: 1 to 20 liter", "Purchase", "Close", shopid, sprintf("%d", shopItemId));
}

FlexDialog:PurchaseFuelMenu(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return 1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return AlexaMsg(playerid, "Fuel can only be purchased with a backpack");
    new shopItemId = strval(payload);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > 20) return PurchaseFuelMenu(playerid, shopid, shopItemId);
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < amount) {
        AlexaMsg(playerid, "The shop does not have the requested stock");
        return PurchaseFuelMenu(playerid, shopid, shopItemId);
    }
    new bill = amount * DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < bill) {
        AlexaMsg(playerid, "Fuel is too expensive for you");
        return PurchaseFuelMenu(playerid, shopid, shopItemId);
    }
    if (Backpack:GetInvItemQuantity(backPackId, FuelInvID) + amount > 20) {
        AlexaMsg(playerid, "In your backpack, there is no room for more fuel");
        return PurchaseFuelMenu(playerid, shopid, shopItemId);
    }
    GivePlayerCash(playerid, -bill, sprintf(
        "Purchased %d liter fuel from %s [%s] [%d] store",
        amount,
        DynamicShopBusiness:GetName(shopid),
        DynamicShopBusiness:GetOwner(shopid),
        shopid
    ));
    DynamicShopBusiness:IncreaseBalance(shopid, bill, sprintf(
        "%s purchased %d liter fuel", GetPlayerNameEx(playerid), amount
    ));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - amount);
    Backpack:PushItem(backPackId, FuelInvID, amount);
    return 1;
}