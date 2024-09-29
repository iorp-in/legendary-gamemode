// defines
#define Fridge_Food_Pizza_ID 0
#define Fridge_Food_Hotdog_ID 1
#define Fridge_Food_Cola_ID 2
#define Fridge_Food_Burger_ID 3
#define Fridge_Food_Fries_ID 4

// global variable
new HouseTimerPlayers[MAX_PLAYERS];

// global hook callbacks
hook OnPlayerConnect(playerid) {
    HouseTimerPlayers[playerid] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    if (HouseTimerPlayers[playerid] != -1) {
        KillTimer(HouseTimerPlayers[playerid]);
        HouseTimerPlayers[playerid] = -1;
    }
    return 1;
}

// for food purpose
stock GetHouseFridgePizza(houseid) { return HouseData[houseid][HousePizza]; }
stock SetHouseFridgePizza(houseid, quantity) { return HouseData[houseid][HousePizza] = quantity; }
stock GetHouseFridgeHotdog(houseid) { return HouseData[houseid][HouseHotdog]; }
stock SetHouseFridgeHotdog(houseid, quantity) { return HouseData[houseid][HouseHotdog] = quantity; }
stock GetHouseFridgeCola(houseid) { return HouseData[houseid][HouseCola]; }
stock SetHouseFridgeCola(houseid, quantity) { return HouseData[houseid][HouseCola] = quantity; }
stock GetHouseFridgeBurger(houseid) { return HouseData[houseid][HouseBurger]; }
stock SetHouseFridgeBurger(houseid, quantity) { return HouseData[houseid][HouseBurger] = quantity; }
stock GetHouseFridgeFries(houseid) { return HouseData[houseid][HouseFries]; }
stock SetHouseFridgeFries(houseid, quantity) { return HouseData[houseid][HouseFries] = quantity; }

// for storage purpose
stock GetHouseFridgeStorageWater(houseid) { return HouseData[houseid][HouseStorageWater]; }
stock SetHouseFridgeStorageWater(houseid, quantity) { return HouseData[houseid][HouseStorageWater] = quantity; }
stock GetHouseFridgeStorageCorn(houseid) { return HouseData[houseid][HouseStorageCorn]; }
stock SetHouseFridgeStorageCorn(houseid, quantity) { return HouseData[houseid][HouseStorageCorn] = quantity; }
stock GetHouseFridgeStorageWheat(houseid) { return HouseData[houseid][HouseStorageWheat]; }
stock SetHouseFridgeStorageWheat(houseid, quantity) { return HouseData[houseid][HouseStorageWheat] = quantity; }
stock GetHouseFridgeStorageOnion(houseid) { return HouseData[houseid][HouseStorageOnion]; }
stock SetHouseFridgeStorageOnion(houseid, quantity) { return HouseData[houseid][HouseStorageOnion] = quantity; }
stock GetHouseFridgeStoragePotato(houseid) { return HouseData[houseid][HouseStoragePotato]; }
stock SetHouseFridgeStoragePotato(houseid, quantity) { return HouseData[houseid][HouseStoragePotato] = quantity; }
stock GetHouseFridgeStorageGarlic(houseid) { return HouseData[houseid][HouseStorageGarlic]; }
stock SetHouseFridgeStorageGarlic(houseid, quantity) { return HouseData[houseid][HouseStorageGarlic] = quantity; }
stock GetHouseFridgeStorageVinegar(houseid) { return HouseData[houseid][HouseStorageVinegar]; }
stock SetHouseFridgeStorageVinegar(houseid, quantity) { return HouseData[houseid][HouseStorageVinegar] = quantity; }
stock GetHouseFridgeStorageTomato(houseid) { return HouseData[houseid][HouseStorageTomato]; }
stock SetHouseFridgeStorageTomato(houseid, quantity) { return HouseData[houseid][HouseStorageTomato] = quantity; }
stock GetHouseFridgeStorageRice(houseid) { return HouseData[houseid][HouseStorageRice]; }
stock SetHouseFridgeStorageRice(houseid, quantity) { return HouseData[houseid][HouseStorageRice] = quantity; }
stock GetHouseFridgeStorageMeet(houseid) { return HouseData[houseid][HouseStorageMeet]; }
stock SetHouseFridgeStorageMeet(houseid, quantity) { return HouseData[houseid][HouseStorageMeet] = quantity; }
stock GetHouseFridgeStorageMilk(houseid) { return HouseData[houseid][HouseStorageMilk]; }
stock SetHouseFridgeStorageMilk(houseid, quantity) { return HouseData[houseid][HouseStorageMilk] = quantity; }
stock GetHouseFridgeStorageCheese(houseid) { return HouseData[houseid][HouseStorageCheese]; }
stock SetHouseFridgeStorageCheese(houseid, quantity) { return HouseData[houseid][HouseStorageCheese] = quantity; }
stock GetHouseFridgeStorageEgg(houseid) { return HouseData[houseid][HouseStorageEgg]; }
stock SetHouseFridgeStorageEgg(houseid, quantity) { return HouseData[houseid][HouseStorageEgg] = quantity; }

// open fridge
stock HouseOpenFridge(playerid) {
    new string[512];
    strcat(string, "Take Food\nCheck Storage\n");
    new backpackID = Backpack:GetPlayerBackpackID(playerid);
    if (Backpack:isValidBackpack(backpackID)) strcat(string, "Put Resource From Backpack");
    FlexPlayerDialog(playerid, "HouseFridge", DIALOG_STYLE_LIST, "House Fridge", string, "Select", "Close");
    return 1;
}

FlexDialog:HouseFridge(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Take Food")) return HouseOpenFridgeTakeFood(playerid);
    if (IsStringSame(inputtext, "Check Storage")) return HouseOpenFridgeCheckStorage(playerid);
    if (IsStringSame(inputtext, "Put Resource From Backpack")) return HouseLoadFromBackpack(playerid);
    return 1;
}

// backpack to fridge menu
stock HouseLoadFromBackpack(playerid) {
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;
    new backpackID = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backpackID)) return 0;
    new string[512];
    strcat(string, "Resource\tIn Backpack\n");
    strcat(string, sprintf("Water\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Water)));
    strcat(string, sprintf("Corn\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Corn)));
    strcat(string, sprintf("Wheat\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Wheat)));
    strcat(string, sprintf("Onion\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Onion)));
    strcat(string, sprintf("Potato\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Potato)));
    strcat(string, sprintf("Garlic\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Garlic)));
    strcat(string, sprintf("Vinegar\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Vinegar)));
    strcat(string, sprintf("Tomato\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Tomato)));
    strcat(string, sprintf("Rice\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Rice)));
    strcat(string, sprintf("Meet\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Meet)));
    strcat(string, sprintf("Milk\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Milk)));
    strcat(string, sprintf("Cheese\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Cheese)));
    strcat(string, sprintf("Egg\t%d KG\n", Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Egg)));
    FlexPlayerDialog(playerid, "BackpackToFridgeInput", DIALOG_STYLE_TABLIST_HEADERS, "Load From Backpack", string, "Load", "Cancel");
    return 1;
}

FlexDialog:BackpackToFridgeInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 0;
    FlexPlayerDialog(playerid, "BackpackToFridge", DIALOG_STYLE_INPUT, "Load From Backpack", "Enter quantity to load in fridge", "Load", "Cancel", -1, inputtext);
    return 1;
}

FlexDialog:BackpackToFridge(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 0;
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;
    new backpackID = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backpackID)) return 0;

    new quantity;
    if (sscanf(inputtext, "d", quantity) || quantity < 1 || quantity > 50) return FlexPlayerDialog(playerid, "BackpackToFridge", DIALOG_STYLE_INPUT, "Load From Backpack", "Enter quantity to load in fridge", "Load", "Cancel", -1, payload);
    if (IsStringSame(payload, "Water")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Water);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageWater(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Water, quantity);
    }
    if (IsStringSame(payload, "Corn")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Corn);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageCorn(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Corn, quantity);
    }
    if (IsStringSame(payload, "Wheat")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Wheat);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageWheat(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Wheat, quantity);
    }
    if (IsStringSame(payload, "Onion")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Onion);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageOnion(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Onion, quantity);
    }
    if (IsStringSame(payload, "Potato")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Potato);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStoragePotato(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Potato, quantity);
    }
    if (IsStringSame(payload, "Garlic")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Garlic);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageGarlic(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Garlic, quantity);
    }
    if (IsStringSame(payload, "Vinegar")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Vinegar);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageVinegar(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Vinegar, quantity);
    }
    if (IsStringSame(payload, "Tomato")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Tomato);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageTomato(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Tomato, quantity);
    }
    if (IsStringSame(payload, "Rice")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Rice);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageRice(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Rice, quantity);
    }
    if (IsStringSame(payload, "Meet")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Meet);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageMeet(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Meet, quantity);
    }
    if (IsStringSame(payload, "Milk")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Milk);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageMilk(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Milk, quantity);
    }
    if (IsStringSame(payload, "Cheese")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Cheese);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageCheese(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Cheese, quantity);
    }
    if (IsStringSame(payload, "Egg")) {
        new insideBackPackQuantity = Backpack:GetInvItemQuantity(backpackID, ResourceInvID_Egg);
        if (insideBackPackQuantity < quantity) { AlexaMsg(playerid, "Backpack does not have requested resource"); return HouseLoadFromBackpack(playerid); }
        if (GetHouseFridgeStorageEgg(houseid) + quantity > 100) { AlexaMsg(playerid, "Fridge does have enough space to store more resource"); return HouseLoadFromBackpack(playerid); }
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) + quantity);
        Backpack:PopItem(backpackID, ResourceInvID_Egg, quantity);
    }

    HouseLoadFromBackpack(playerid);
    return 1;
}

// fridge take food menu
stock HouseOpenFridgeTakeFood(playerid) {
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;
    new string[2000];
    strcat(string, "Item\tQuantity\n");
    strcat(string, sprintf("Pizza\t%d\n", GetHouseFridgePizza(houseid)));
    strcat(string, sprintf("Hotdog\t%d\n", GetHouseFridgeHotdog(houseid)));
    strcat(string, sprintf("Cola\t%d\n", GetHouseFridgeCola(houseid)));
    strcat(string, sprintf("Burger\t%d\n", GetHouseFridgeBurger(houseid)));
    strcat(string, sprintf("Fries\t%d\n", GetHouseFridgeFries(houseid)));
    return FlexPlayerDialog(playerid, "HouseFridgeTakeFood", DIALOG_STYLE_TABLIST_HEADERS, "Take Food", string, "Take", "Close");
}

FlexDialog:HouseFridgeTakeFood(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) HouseOpenFridge(playerid);

    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;

    if (listitem == Fridge_Food_Pizza_ID) {
        if (GetHouseFridgePizza(houseid) < 1) return AlexaMsg(playerid, "you don't have any food in fridge to eat, please cook some!");
        FoodActionPizza(playerid);
        SetHouseFridgePizza(houseid, GetHouseFridgePizza(houseid) - 1);
    }
    if (listitem == Fridge_Food_Hotdog_ID) {
        if (GetHouseFridgeHotdog(houseid) < 1) return AlexaMsg(playerid, "you don't have any food in fridge to eat, please cook some!");
        FoodActionHotDog(playerid);
        SetHouseFridgeHotdog(houseid, GetHouseFridgeHotdog(houseid) - 1);
    }
    if (listitem == Fridge_Food_Cola_ID) {
        if (GetHouseFridgeCola(houseid) < 1) return AlexaMsg(playerid, "you don't have any food in fridge to eat, please cook some!");
        FoodActionCola(playerid);
        CallDrinkWater(playerid);
        SetHouseFridgeCola(houseid, GetHouseFridgeCola(houseid) - 1);
    }
    if (listitem == Fridge_Food_Burger_ID) {
        if (GetHouseFridgeBurger(houseid) < 1) return AlexaMsg(playerid, "you don't have any food in fridge to eat, please cook some!");
        FoodActionBurger(playerid);
        SetHouseFridgeBurger(houseid, GetHouseFridgeBurger(houseid) - 1);
    }
    if (listitem == Fridge_Food_Fries_ID) {
        if (GetHouseFridgeFries(houseid) < 1) return AlexaMsg(playerid, "you don't have any food in fridge to eat, please cook some!");
        FoodActionFries(playerid);
        SetHouseFridgeFries(houseid, GetHouseFridgeFries(houseid) - 1);
    }
    SetTimerEx("OnPlayerEatFoodFromFridge", 3000, false, "dd", playerid, listitem);
    return 1;
}

forward OnPlayerEatFoodFromFridge(playerid, foodid);
public OnPlayerEatFoodFromFridge(playerid, foodid) {
    new Float:h;
    GetPlayerHealth(playerid, h);
    if (h < 100 && h >= 89) SetPlayerHealthEx(playerid, 100);
    if (h < 89) SetPlayerHealthEx(playerid, h + RandomEx(5, 15));
    return 1;
}

// fridge check storage menu
stock HouseOpenFridgeCheckStorage(playerid) {
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;

    new string[2000];
    strcat(string, "Item\tQuantity\n");
    strcat(string, sprintf("Water\t%d\n", GetHouseFridgeStorageWater(houseid)));
    strcat(string, sprintf("Corn\t%d\n", GetHouseFridgeStorageCorn(houseid)));
    strcat(string, sprintf("Wheat\t%d\n", GetHouseFridgeStorageWheat(houseid)));
    strcat(string, sprintf("Onion\t%d\n", GetHouseFridgeStorageOnion(houseid)));
    strcat(string, sprintf("Potato\t%d\n", GetHouseFridgeStoragePotato(houseid)));
    strcat(string, sprintf("Garlic\t%d\n", GetHouseFridgeStorageGarlic(houseid)));
    strcat(string, sprintf("Vinegar\t%d\n", GetHouseFridgeStorageVinegar(houseid)));
    strcat(string, sprintf("Tomato\t%d\n", GetHouseFridgeStorageTomato(houseid)));
    strcat(string, sprintf("Rice\t%d\n", GetHouseFridgeStorageRice(houseid)));
    strcat(string, sprintf("Meet\t%d\n", GetHouseFridgeStorageMeet(houseid)));
    strcat(string, sprintf("Milk\t%d\n", GetHouseFridgeStorageMilk(houseid)));
    strcat(string, sprintf("Cheese\t%d\n", GetHouseFridgeStorageCheese(houseid)));
    strcat(string, sprintf("Egg\t%d\n", GetHouseFridgeStorageEgg(houseid)));
    return FlexPlayerDialog(playerid, "HouseFridgeCheckStorage", DIALOG_STYLE_TABLIST_HEADERS, "Fridge Storage", string, "Okay", "");
}

FlexDialog:HouseFridgeCheckStorage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    HouseOpenFridge(playerid);
    return 1;
}

// Cook Menu
stock HouseOpenCookMenu(playerid) {
    new string[2000];
    strcat(string, "Food\tQuantity\tTime\n");
    strcat(string, "Cook Pizza\t2\t1 Minute\n");
    strcat(string, "Cook Hotdog\t2\t2 Minute\n");
    strcat(string, "Cook Cola\t3\t1 Minute\n");
    strcat(string, "Cook Burger\t2\t1 Minute\n");
    strcat(string, "Cook Fries\t5\t2 Minute\n");
    FlexPlayerDialog(playerid, "HouseStove", DIALOG_STYLE_TABLIST_HEADERS, "House Stove", string, "Select", "Close");
    return 1;
}

FlexDialog:HouseStove(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 0;
    if (IsStringSame(inputtext, "Cook Pizza")) return HouseCookInfo(playerid, Fridge_Food_Pizza_ID);
    if (IsStringSame(inputtext, "Cook Hotdog")) return HouseCookInfo(playerid, Fridge_Food_Hotdog_ID);
    if (IsStringSame(inputtext, "Cook Cola")) return HouseCookInfo(playerid, Fridge_Food_Cola_ID);
    if (IsStringSame(inputtext, "Cook Burger")) return HouseCookInfo(playerid, Fridge_Food_Burger_ID);
    if (IsStringSame(inputtext, "Cook Fries")) return HouseCookInfo(playerid, Fridge_Food_Fries_ID);
    return 1;
}

// show cook info and resource requirement
stock HouseCookInfo(playerid, foodid) {
    new string[2000];
    if (foodid == Fridge_Food_Pizza_ID) {
        strcat(string, "Food: Pizza\n");
        strcat(string, "Quantity Cooked: 2\n");
        strcat(string, "Time Required: 1 minute\n");
        strcat(string, "Resource Required:\n");
        strcat(string, "     > Water    : 2KG\n");
        strcat(string, "     > Corn     : 2KG\n");
        strcat(string, "     > Wheat    : 2KG\n");
        strcat(string, "     > Onion    : 2KG\n");
        strcat(string, "     > Potato   : 2KG\n");
        strcat(string, "     > Garlic   : 2KG\n");
        strcat(string, "     > Vinegar  : 2KG\n");
        strcat(string, "     > Tomato   : 2KG\n");
        strcat(string, "     > Rice     : 2KG\n");
        strcat(string, "     > Meet     : 2KG\n");
        strcat(string, "     > Milk     : 2KG\n");
        strcat(string, "     > Cheese   : 2KG\n");
        strcat(string, "     > Egg      : 2KG\n");
        FlexPlayerDialog(playerid, "CookFoodInfo", DIALOG_STYLE_MSGBOX, "Cook Pizza", string, "Cook", "Cancel", Fridge_Food_Pizza_ID);
    }
    if (foodid == Fridge_Food_Hotdog_ID) {
        strcat(string, "Food: Hotdog\n");
        strcat(string, "Quantity Cooked: 2\n");
        strcat(string, "Time Required: 2 minute\n");
        strcat(string, "Resource Required:\n");
        strcat(string, "     > Water    : 3KG\n");
        strcat(string, "     > Corn     : 3KG\n");
        strcat(string, "     > Wheat    : 3KG\n");
        strcat(string, "     > Onion    : 3KG\n");
        strcat(string, "     > Potato   : 3KG\n");
        strcat(string, "     > Garlic   : 3KG\n");
        strcat(string, "     > Vinegar  : 3KG\n");
        strcat(string, "     > Tomato   : 3KG\n");
        strcat(string, "     > Rice     : 3KG\n");
        strcat(string, "     > Meet     : 3KG\n");
        strcat(string, "     > Milk     : 3KG\n");
        strcat(string, "     > Cheese   : 3KG\n");
        strcat(string, "     > Egg      : 3KG\n");
        FlexPlayerDialog(playerid, "CookFoodInfo", DIALOG_STYLE_MSGBOX, "Cook Hotdog", string, "Cook", "Cancel", Fridge_Food_Hotdog_ID);
    }
    if (foodid == Fridge_Food_Cola_ID) {
        strcat(string, "Food: Cola\n");
        strcat(string, "Quantity Cooked: 3\n");
        strcat(string, "Time Required: 1 minute\n");
        strcat(string, "Resource Required:\n");
        strcat(string, "     > Water    : 2KG\n");
        strcat(string, "     > Corn     : 2KG\n");
        strcat(string, "     > Wheat    : 2KG\n");
        strcat(string, "     > Onion    : 2KG\n");
        strcat(string, "     > Potato   : 2KG\n");
        strcat(string, "     > Garlic   : 2KG\n");
        strcat(string, "     > Vinegar  : 2KG\n");
        strcat(string, "     > Tomato   : 2KG\n");
        strcat(string, "     > Rice     : 2KG\n");
        strcat(string, "     > Meet     : 2KG\n");
        strcat(string, "     > Milk     : 2KG\n");
        strcat(string, "     > Cheese   : 2KG\n");
        strcat(string, "     > Egg      : 2KG\n");
        FlexPlayerDialog(playerid, "CookFoodInfo", DIALOG_STYLE_MSGBOX, "Cook Cola", string, "Cook", "Cancel", Fridge_Food_Cola_ID);
    }
    if (foodid == Fridge_Food_Burger_ID) {
        strcat(string, "Food: Burger\n");
        strcat(string, "Quantity Cooked: 2\n");
        strcat(string, "Time Required: 1 minute\n");
        strcat(string, "Resource Required:\n");
        strcat(string, "     > Water    : 2KG\n");
        strcat(string, "     > Corn     : 2KG\n");
        strcat(string, "     > Wheat    : 2KG\n");
        strcat(string, "     > Onion    : 2KG\n");
        strcat(string, "     > Potato   : 2KG\n");
        strcat(string, "     > Garlic   : 2KG\n");
        strcat(string, "     > Vinegar  : 2KG\n");
        strcat(string, "     > Tomato   : 2KG\n");
        strcat(string, "     > Rice     : 2KG\n");
        strcat(string, "     > Meet     : 2KG\n");
        strcat(string, "     > Milk     : 2KG\n");
        strcat(string, "     > Cheese   : 2KG\n");
        strcat(string, "     > Egg      : 2KG\n");
        FlexPlayerDialog(playerid, "CookFoodInfo", DIALOG_STYLE_MSGBOX, "Cook Burger", string, "Cook", "Cancel", Fridge_Food_Burger_ID);
    }
    if (foodid == Fridge_Food_Fries_ID) {
        strcat(string, "Food: Fries\n");
        strcat(string, "Quantity Cooked: 5\n");
        strcat(string, "Time Required: 2 minute\n");
        strcat(string, "Resource Required:\n");
        strcat(string, "     > Water    : 3KG\n");
        strcat(string, "     > Corn     : 3KG\n");
        strcat(string, "     > Wheat    : 3KG\n");
        strcat(string, "     > Onion    : 3KG\n");
        strcat(string, "     > Potato   : 3KG\n");
        strcat(string, "     > Garlic   : 3KG\n");
        strcat(string, "     > Vinegar  : 3KG\n");
        strcat(string, "     > Tomato   : 3KG\n");
        strcat(string, "     > Rice     : 3KG\n");
        strcat(string, "     > Meet     : 3KG\n");
        strcat(string, "     > Milk     : 3KG\n");
        strcat(string, "     > Cheese   : 3KG\n");
        strcat(string, "     > Egg      : 3KG\n");
        FlexPlayerDialog(playerid, "CookFoodInfo", DIALOG_STYLE_MSGBOX, "Cook Fries", string, "Cook", "Cancel", Fridge_Food_Fries_ID);
    }
    return 1;
}

FlexDialog:CookFoodInfo(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new foodid = extraid;

    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;

    if (foodid == Fridge_Food_Pizza_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water to cook this food.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn to cook this food.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat to cook this food.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion to cook this food.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato to cook this food.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic to cook this food.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar to cook this food.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato to cook this food.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice to cook this food.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet to cook this food.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk to cook this food.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese to cook this food.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg to cook this food.");
        HouseStartCooking(playerid, foodid);
        return 1;
    }
    if (foodid == Fridge_Food_Hotdog_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Water to cook this food.");
        if (GetHouseFridgeStorageCorn(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Corn to cook this food.");
        if (GetHouseFridgeStorageWheat(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Wheat to cook this food.");
        if (GetHouseFridgeStorageOnion(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Onion to cook this food.");
        if (GetHouseFridgeStoragePotato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Potato to cook this food.");
        if (GetHouseFridgeStorageGarlic(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Garlic to cook this food.");
        if (GetHouseFridgeStorageVinegar(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Vinegar to cook this food.");
        if (GetHouseFridgeStorageTomato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Tomato to cook this food.");
        if (GetHouseFridgeStorageRice(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Rice to cook this food.");
        if (GetHouseFridgeStorageMeet(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Meet to cook this food.");
        if (GetHouseFridgeStorageMilk(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Milk to cook this food.");
        if (GetHouseFridgeStorageCheese(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Cheese to cook this food.");
        if (GetHouseFridgeStorageEgg(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Egg to cook this food.");
        HouseStartCooking(playerid, foodid);
        return 1;
    }
    if (foodid == Fridge_Food_Cola_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water to cook this food.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn to cook this food.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat to cook this food.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion to cook this food.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato to cook this food.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic to cook this food.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar to cook this food.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato to cook this food.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice to cook this food.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet to cook this food.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk to cook this food.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese to cook this food.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg to cook this food.");
        HouseStartCooking(playerid, foodid);
        return 1;
    }
    if (foodid == Fridge_Food_Burger_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water to cook this food.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn to cook this food.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat to cook this food.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion to cook this food.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato to cook this food.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic to cook this food.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar to cook this food.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato to cook this food.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice to cook this food.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet to cook this food.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk to cook this food.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese to cook this food.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg to cook this food.");
        HouseStartCooking(playerid, foodid);
        return 1;
    }
    if (foodid == Fridge_Food_Fries_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Water to cook this food.");
        if (GetHouseFridgeStorageCorn(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Corn to cook this food.");
        if (GetHouseFridgeStorageWheat(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Wheat to cook this food.");
        if (GetHouseFridgeStorageOnion(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Onion to cook this food.");
        if (GetHouseFridgeStoragePotato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Potato to cook this food.");
        if (GetHouseFridgeStorageGarlic(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Garlic to cook this food.");
        if (GetHouseFridgeStorageVinegar(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Vinegar to cook this food.");
        if (GetHouseFridgeStorageTomato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Tomato to cook this food.");
        if (GetHouseFridgeStorageRice(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Rice to cook this food.");
        if (GetHouseFridgeStorageMeet(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Meet to cook this food.");
        if (GetHouseFridgeStorageMilk(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Milk to cook this food.");
        if (GetHouseFridgeStorageCheese(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Cheese to cook this food.");
        if (GetHouseFridgeStorageEgg(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Egg to cook this food.");
        HouseStartCooking(playerid, foodid);
        return 1;
    }
    return 1;
}

// start cooking
stock HouseStartCooking(playerid, foodid) {
    // validate houseid
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;

    new seconds = RandomEx(30, 80);
    CreateCookingFlameInFront(playerid, seconds);
    freezeEx(playerid, seconds * 1000);
    GameTextForPlayer(playerid, "~r~cooking ~y~food~n~~w~wait...", seconds * 1000, 3);
    StartScreenTimer(playerid, seconds);
    AlexaMsg(playerid, "cooking food, please wait...");
    ApplyAnimation(playerid, "MISC", "Idle_Chat_02", 4.1, 1, 0, 0, 0, 0, 1);
    HouseTimerPlayers[playerid] = SetTimerEx("OnHouseCookingComplete", seconds * 1000, false, "dd", playerid, foodid);
    return 1;
}

stock CreateCookingFlameInFront(playerid, seconds) {
    new Float:cpos[3];
    GetPlayerPos(playerid, cpos[0], cpos[1], cpos[2]);
    GetXYInFrontOfPlayer(playerid, cpos[0], cpos[1], 1.0);
    new cint = GetPlayerInteriorID(playerid);
    new cvw = GetPlayerVirtualWorldID(playerid);
    new objectid = STREAMER_TAG_OBJECT:CreateDynamicObject(18688, cpos[0], cpos[1], cpos[2] - 2.0, 0.0, 0.0, 0.0, cvw, cint);
    SetTimerEx("RemoveHouseFlame", seconds * 1000, false, "d", objectid);
    return 1;
}

forward RemoveHouseFlame(objectid);
public RemoveHouseFlame(objectid) {
    DestroyDynamicObjectEx(objectid);
    return 1;
}

// cooking callback
forward OnHouseCookingComplete(playerid, foodid);
public OnHouseCookingComplete(playerid, foodid) {
    HouseTimerPlayers[playerid] = -1;
    ClearAnimations(playerid);

    // validate houseid
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;

    if (foodid == Fridge_Food_Pizza_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water, cooking failed.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn, cooking failed.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat, cooking failed.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion, cooking failed.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato, cooking failed.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic, cooking failed.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar, cooking failed.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato, cooking failed.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice, cooking failed.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet, cooking failed.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk, cooking failed.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese, cooking failed.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg, cooking failed.");
    }
    if (foodid == Fridge_Food_Hotdog_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Water, cooking failed.");
        if (GetHouseFridgeStorageCorn(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Corn, cooking failed.");
        if (GetHouseFridgeStorageWheat(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Wheat, cooking failed.");
        if (GetHouseFridgeStorageOnion(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Onion, cooking failed.");
        if (GetHouseFridgeStoragePotato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Potato, cooking failed.");
        if (GetHouseFridgeStorageGarlic(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Garlic, cooking failed.");
        if (GetHouseFridgeStorageVinegar(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Vinegar, cooking failed.");
        if (GetHouseFridgeStorageTomato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Tomato, cooking failed.");
        if (GetHouseFridgeStorageRice(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Rice, cooking failed.");
        if (GetHouseFridgeStorageMeet(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Meet, cooking failed.");
        if (GetHouseFridgeStorageMilk(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Milk, cooking failed.");
        if (GetHouseFridgeStorageCheese(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Cheese, cooking failed.");
        if (GetHouseFridgeStorageEgg(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Egg, cooking failed.");
    }
    if (foodid == Fridge_Food_Cola_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water, cooking failed.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn, cooking failed.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat, cooking failed.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion, cooking failed.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato, cooking failed.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic, cooking failed.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar, cooking failed.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato, cooking failed.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice, cooking failed.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet, cooking failed.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk, cooking failed.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese, cooking failed.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg, cooking failed.");
    }
    if (foodid == Fridge_Food_Burger_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Water, cooking failed.");
        if (GetHouseFridgeStorageCorn(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Corn, cooking failed.");
        if (GetHouseFridgeStorageWheat(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Wheat, cooking failed.");
        if (GetHouseFridgeStorageOnion(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Onion, cooking failed.");
        if (GetHouseFridgeStoragePotato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Potato, cooking failed.");
        if (GetHouseFridgeStorageGarlic(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Garlic, cooking failed.");
        if (GetHouseFridgeStorageVinegar(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Vinegar, cooking failed.");
        if (GetHouseFridgeStorageTomato(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Tomato, cooking failed.");
        if (GetHouseFridgeStorageRice(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Rice, cooking failed.");
        if (GetHouseFridgeStorageMeet(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Meet, cooking failed.");
        if (GetHouseFridgeStorageMilk(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Milk, cooking failed.");
        if (GetHouseFridgeStorageCheese(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Cheese, cooking failed.");
        if (GetHouseFridgeStorageEgg(houseid) < 2) return AlexaMsg(playerid, "you don't have enough Egg, cooking failed.");
    }
    if (foodid == Fridge_Food_Fries_ID) {
        if (GetHouseFridgeStorageWater(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Water, cooking failed.");
        if (GetHouseFridgeStorageCorn(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Corn, cooking failed.");
        if (GetHouseFridgeStorageWheat(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Wheat, cooking failed.");
        if (GetHouseFridgeStorageOnion(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Onion, cooking failed.");
        if (GetHouseFridgeStoragePotato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Potato, cooking failed.");
        if (GetHouseFridgeStorageGarlic(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Garlic, cooking failed.");
        if (GetHouseFridgeStorageVinegar(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Vinegar, cooking failed.");
        if (GetHouseFridgeStorageTomato(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Tomato, cooking failed.");
        if (GetHouseFridgeStorageRice(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Rice, cooking failed.");
        if (GetHouseFridgeStorageMeet(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Meet, cooking failed.");
        if (GetHouseFridgeStorageMilk(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Milk, cooking failed.");
        if (GetHouseFridgeStorageCheese(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Cheese, cooking failed.");
        if (GetHouseFridgeStorageEgg(houseid) < 3) return AlexaMsg(playerid, "you don't have enough Egg, cooking failed.");
    }

    AlexaMsg(playerid, "cooking complete... food stored in fridge, you can eat from fridge.");

    if (foodid == Fridge_Food_Pizza_ID) {
        SetHouseFridgePizza(houseid, GetHouseFridgePizza(houseid) + 2);
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) - 2);
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) - 2);
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) - 2);
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) - 2);
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) - 2);
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) - 2);
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) - 2);
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) - 2);
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) - 2);
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) - 2);
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) - 2);
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) - 2);
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) - 2);
    }
    if (foodid == Fridge_Food_Hotdog_ID) {
        SetHouseFridgeHotdog(houseid, GetHouseFridgeHotdog(houseid) + 2);
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) - 2);
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) - 2);
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) - 2);
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) - 2);
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) - 2);
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) - 2);
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) - 2);
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) - 2);
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) - 2);
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) - 2);
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) - 2);
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) - 2);
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) - 2);
    }
    if (foodid == Fridge_Food_Cola_ID) {
        SetHouseFridgeCola(houseid, GetHouseFridgeCola(houseid) + 3);
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) - 3);
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) - 3);
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) - 3);
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) - 3);
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) - 3);
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) - 3);
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) - 3);
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) - 3);
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) - 3);
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) - 3);
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) - 3);
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) - 3);
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) - 3);
    }
    if (foodid == Fridge_Food_Burger_ID) {
        SetHouseFridgeBurger(houseid, GetHouseFridgeBurger(houseid) + 2);
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) - 2);
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) - 2);
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) - 2);
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) - 2);
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) - 2);
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) - 2);
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) - 2);
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) - 2);
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) - 2);
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) - 2);
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) - 2);
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) - 2);
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) - 2);
    }
    if (foodid == Fridge_Food_Fries_ID) {
        SetHouseFridgeFries(houseid, GetHouseFridgeFries(houseid) + 5);
        SetHouseFridgeStorageWater(houseid, GetHouseFridgeStorageWater(houseid) - 3);
        SetHouseFridgeStorageCorn(houseid, GetHouseFridgeStorageCorn(houseid) - 3);
        SetHouseFridgeStorageWheat(houseid, GetHouseFridgeStorageWheat(houseid) - 3);
        SetHouseFridgeStorageOnion(houseid, GetHouseFridgeStorageOnion(houseid) - 3);
        SetHouseFridgeStoragePotato(houseid, GetHouseFridgeStoragePotato(houseid) - 3);
        SetHouseFridgeStorageGarlic(houseid, GetHouseFridgeStorageGarlic(houseid) - 3);
        SetHouseFridgeStorageVinegar(houseid, GetHouseFridgeStorageVinegar(houseid) - 3);
        SetHouseFridgeStorageTomato(houseid, GetHouseFridgeStorageTomato(houseid) - 3);
        SetHouseFridgeStorageRice(houseid, GetHouseFridgeStorageRice(houseid) - 3);
        SetHouseFridgeStorageMeet(houseid, GetHouseFridgeStorageMeet(houseid) - 3);
        SetHouseFridgeStorageMilk(houseid, GetHouseFridgeStorageMilk(houseid) - 3);
        SetHouseFridgeStorageCheese(houseid, GetHouseFridgeStorageCheese(houseid) - 3);
        SetHouseFridgeStorageEgg(houseid, GetHouseFridgeStorageEgg(houseid) - 3);
    }

    House:Save(houseid);
    return 1;
}