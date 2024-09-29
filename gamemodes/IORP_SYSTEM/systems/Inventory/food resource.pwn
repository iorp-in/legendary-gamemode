#define InvLimitFoodResource 50

#define BackpackInvColumn_Corn "Resource_Corn"
#define BackpackInvColumn_Wheat "Resource_Wheat"
#define BackpackInvColumn_Onion "Resource_Onion"
#define BackpackInvColumn_Potato "Resource_Potato"
#define BackpackInvColumn_Garlic "Resource_Garlic"
#define BackpackInvColumn_Vinegar "Resource_Vinegar"
#define BackpackInvColumn_Tomato "Resource_Tomato"
#define BackpackInvColumn_Rice "Resource_Rice"
#define BackpackInvColumn_Water "Resource_Water"
#define BackpackInvColumn_Meet "Resource_Meet"
#define BackpackInvColumn_Milk "Resource_Milk"
#define BackpackInvColumn_Cheese "Resource_Cheese"
#define BackpackInvColumn_Egg "Resource_Egg"

new ResourceInvID_Corn;
new ResourceInvID_Wheat;
new ResourceInvID_Onion;
new ResourceInvID_Potato;
new ResourceInvID_Garlic;
new ResourceInvID_Vinegar;
new ResourceInvID_Tomato;
new ResourceInvID_Rice;
new ResourceInvID_Water;
new ResourceInvID_Meet;
new ResourceInvID_Milk;
new ResourceInvID_Cheese;
new ResourceInvID_Egg;

hook OnInventoryInit() {
    ResourceInvID_Corn = Backpack:AddInventoryItem("Corn", InvLimitFoodResource);
    ResourceInvID_Wheat = Backpack:AddInventoryItem("Wheat", InvLimitFoodResource);
    ResourceInvID_Onion = Backpack:AddInventoryItem("Onion", InvLimitFoodResource);
    ResourceInvID_Potato = Backpack:AddInventoryItem("Potato", InvLimitFoodResource);
    ResourceInvID_Garlic = Backpack:AddInventoryItem("Garlic", InvLimitFoodResource);
    ResourceInvID_Vinegar = Backpack:AddInventoryItem("Vinegar", InvLimitFoodResource);
    ResourceInvID_Tomato = Backpack:AddInventoryItem("Tomato", InvLimitFoodResource);
    ResourceInvID_Rice = Backpack:AddInventoryItem("Rice", InvLimitFoodResource);
    ResourceInvID_Water = Backpack:AddInventoryItem("Water", InvLimitFoodResource);
    ResourceInvID_Meet = Backpack:AddInventoryItem("Meet", InvLimitFoodResource);
    ResourceInvID_Milk = Backpack:AddInventoryItem("Milk", InvLimitFoodResource);
    ResourceInvID_Cheese = Backpack:AddInventoryItem("Cheese", InvLimitFoodResource);
    ResourceInvID_Egg = Backpack:AddInventoryItem("Egg", InvLimitFoodResource);
    Database:AddColumn(BackpackDB, BackpackInvColumn_Corn, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Wheat, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Onion, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Potato, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Garlic, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Vinegar, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Tomato, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Rice, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Water, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Meet, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Milk, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Cheese, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Egg, "int", "0");
    return 1;
}

hook OnBackpackLoad(backpackID) {
    Backpack:PushItem(backpackID, ResourceInvID_Corn, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Corn, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Wheat, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Wheat, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Onion, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Onion, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Potato, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Potato, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Garlic, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Garlic, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Vinegar, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Vinegar, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Tomato, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Tomato, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Rice, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Rice, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Water, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Water, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Meet, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Meet, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Milk, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Milk, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Cheese, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Cheese, BackpackDB));
    Backpack:PushItem(backpackID, ResourceInvID_Egg, Database:GetInt(sprintf("%d", backpackID), "id", BackpackInvColumn_Egg, BackpackDB));
    return 1;
}

hook OnBackpackSave(backpackID) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Corn), sprintf("%d", backpackID), "id", BackpackInvColumn_Corn, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Wheat), sprintf("%d", backpackID), "id", BackpackInvColumn_Wheat, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Onion), sprintf("%d", backpackID), "id", BackpackInvColumn_Onion, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Potato), sprintf("%d", backpackID), "id", BackpackInvColumn_Potato, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Garlic), sprintf("%d", backpackID), "id", BackpackInvColumn_Garlic, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Vinegar), sprintf("%d", backpackID), "id", BackpackInvColumn_Vinegar, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Tomato), sprintf("%d", backpackID), "id", BackpackInvColumn_Tomato, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Rice), sprintf("%d", backpackID), "id", BackpackInvColumn_Rice, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Water), sprintf("%d", backpackID), "id", BackpackInvColumn_Water, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Meet), sprintf("%d", backpackID), "id", BackpackInvColumn_Meet, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Milk), sprintf("%d", backpackID), "id", BackpackInvColumn_Milk, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Cheese), sprintf("%d", backpackID), "id", BackpackInvColumn_Cheese, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Egg), sprintf("%d", backpackID), "id", BackpackInvColumn_Egg, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backpackID) {
    Backpack:PopItem(backpackID, ResourceInvID_Corn, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Corn));
    Backpack:PopItem(backpackID, ResourceInvID_Wheat, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Wheat));
    Backpack:PopItem(backpackID, ResourceInvID_Onion, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Onion));
    Backpack:PopItem(backpackID, ResourceInvID_Potato, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Potato));
    Backpack:PopItem(backpackID, ResourceInvID_Garlic, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Garlic));
    Backpack:PopItem(backpackID, ResourceInvID_Vinegar, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Vinegar));
    Backpack:PopItem(backpackID, ResourceInvID_Tomato, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Tomato));
    Backpack:PopItem(backpackID, ResourceInvID_Rice, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Rice));
    Backpack:PopItem(backpackID, ResourceInvID_Water, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Water));
    Backpack:PopItem(backpackID, ResourceInvID_Meet, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Meet));
    Backpack:PopItem(backpackID, ResourceInvID_Milk, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Milk));
    Backpack:PopItem(backpackID, ResourceInvID_Cheese, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Cheese));
    Backpack:PopItem(backpackID, ResourceInvID_Egg, Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Egg));
    return 1;
}

new resourceids[] = { 0, 1, 2, 3, 4, 5, 6, 7, 16, 17, 18, 19, 20 };
hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_General_Items && DynamicShopBusiness:GetType(shopid) != Shop_Type_Farming_Resources) return 1;
    if (!IsArrayContainNumber(resourceids, shopItemId)) return 1;
    new backpackID = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backpackID)) return AlexaMsg(playerid, "you need backpack to purchase this item");
    AlexaMsg(playerid, sprintf("purchasing %s", DynamicShopBusinessItem:GetItemName(shopItemId)));

    // normal check
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase auto drive"); return ~1; }

    // show menu to enter quantity
    FlexPlayerDialog(playerid, "PurResForBackPack", DIALOG_STYLE_INPUT, "Enter quantity", sprintf("Enter quantity between 1 and %d to purchase from store", stockCount > 25 ? 25 : stockCount), "Purchase", "Cancel", shopid, sprintf("%d", shopItemId));
    return 1;
}

FlexDialog:PurResForBackPack(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new backpackID = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backpackID)) return AlexaMsg(playerid, "you need backpack to purchase this item");
    new shopid = extraid;
    new shopItemId = strval(payload);
    new quantity;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (sscanf(inputtext, "d", quantity) || quantity < 1 || quantity > 25 || quantity > stockCount) return FlexPlayerDialog(playerid, "PurResForBackPack", DIALOG_STYLE_INPUT, "Enter quantity", sprintf("Enter quantity between 1 and %d to purchase from store", stockCount > 25 ? 25 : stockCount), "Purchase", "Cancel", shopid, sprintf("%d", shopItemId));

    // check backpack storage
    if (shopItemId == 0 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Corn) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 1 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Wheat) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 2 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Onion) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 3 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Potato) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 4 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Garlic) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 5 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Vinegar) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 6 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Tomato) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 7 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Rice) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 16 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Water) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 17 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Meet) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 18 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Milk) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 19 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Cheese) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");
    if (shopItemId == 20 && Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Egg) + quantity > InvLimitFoodResource) return AlexaMsg(playerid, "your backpack does not have sufficient storage");

    // made the purchase
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId) * quantity;
    if (GetPlayerCash(playerid) < price) {
        AlexaMsg(playerid, "you don't have enough money to purchase given quantity");
        return FlexPlayerDialog(playerid, "PurResForBackPack", DIALOG_STYLE_INPUT, "Enter quantity", sprintf("Enter quantity between 1 and %d to purchase from store", stockCount > 25 ? 25 : stockCount), "Purchase", "Cancel", shopid, sprintf("%d", shopItemId));
    }
    GivePlayerCash(playerid, -price, sprintf("Purchased %d KG %s from %s [%s] store", quantity, DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased food item: %dKG of %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - quantity);
    AlexaMsg(playerid, sprintf("you have purchased %d KG of %s from %s [%s] store", quantity, DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));

    // update backpack
    if (shopItemId == 0) Backpack:PushItem(backpackID, ResourceInvID_Corn, quantity);
    if (shopItemId == 1) Backpack:PushItem(backpackID, ResourceInvID_Wheat, quantity);
    if (shopItemId == 2) Backpack:PushItem(backpackID, ResourceInvID_Onion, quantity);
    if (shopItemId == 3) Backpack:PushItem(backpackID, ResourceInvID_Potato, quantity);
    if (shopItemId == 4) Backpack:PushItem(backpackID, ResourceInvID_Garlic, quantity);
    if (shopItemId == 5) Backpack:PushItem(backpackID, ResourceInvID_Vinegar, quantity);
    if (shopItemId == 6) Backpack:PushItem(backpackID, ResourceInvID_Tomato, quantity);
    if (shopItemId == 7) Backpack:PushItem(backpackID, ResourceInvID_Rice, quantity);
    if (shopItemId == 16) Backpack:PushItem(backpackID, ResourceInvID_Water, quantity);
    if (shopItemId == 17) Backpack:PushItem(backpackID, ResourceInvID_Meet, quantity);
    if (shopItemId == 18) Backpack:PushItem(backpackID, ResourceInvID_Milk, quantity);
    if (shopItemId == 19) Backpack:PushItem(backpackID, ResourceInvID_Cheese, quantity);
    if (shopItemId == 20) Backpack:PushItem(backpackID, ResourceInvID_Egg, quantity);
    return 1;
}