#define FOOD_SHOP_RESET_DAY 180

#define MAX_FOOD (100) // Maximum to load from database, you may change that.
#define PizzaResourceNeedWater 5
#define PizzaResourceNeedCorn 5
#define PizzaResourceNeedWheat 5
#define PizzaResourceNeedOnion 5
#define PizzaResourceNeedPotato 5
#define PizzaResourceNeedGarlic 5
#define PizzaResourceNeedVinegar 5
#define PizzaResourceNeedTomato 5
#define PizzaResourceNeedRice 5
#define PizzaResourceNeedMeet 5
#define PizzaResourceNeedMilk 5
#define PizzaResourceNeedCheese 5
#define PizzaResourceNeedEgg 5
#define FriesResourceNeedWater 5
#define FriesResourceNeedCorn 5
#define FriesResourceNeedWheat 5
#define FriesResourceNeedOnion 5
#define FriesResourceNeedPotato 5
#define FriesResourceNeedGarlic 5
#define FriesResourceNeedVinegar 5
#define FriesResourceNeedTomato 5
#define FriesResourceNeedRice 5
#define FriesResourceNeedMeet 5
#define FriesResourceNeedMilk 5
#define FriesResourceNeedCheese 5
#define FriesResourceNeedEgg 5
#define ColaResourceNeedWater 5
#define ColaResourceNeedCorn 5
#define ColaResourceNeedWheat 5
#define ColaResourceNeedOnion 5
#define ColaResourceNeedPotato 5
#define ColaResourceNeedGarlic 5
#define ColaResourceNeedVinegar 5
#define ColaResourceNeedTomato 5
#define ColaResourceNeedRice 5
#define ColaResourceNeedMeet 5
#define ColaResourceNeedMilk 5
#define ColaResourceNeedCheese 5
#define ColaResourceNeedEgg 5
#define BurgerResourceNeedWater 5
#define BurgerResourceNeedCorn 5
#define BurgerResourceNeedWheat 5
#define BurgerResourceNeedOnion 5
#define BurgerResourceNeedPotato 5
#define BurgerResourceNeedGarlic 5
#define BurgerResourceNeedVinegar 5
#define BurgerResourceNeedTomato 5
#define BurgerResourceNeedRice 5
#define BurgerResourceNeedMeet 5
#define BurgerResourceNeedMilk 5
#define BurgerResourceNeedCheese 5
#define BurgerResourceNeedEgg 5
#define HotDogResourceNeedWater 5
#define HotDogResourceNeedCorn 5
#define HotDogResourceNeedWheat 5
#define HotDogResourceNeedOnion 5
#define HotDogResourceNeedPotato 5
#define HotDogResourceNeedGarlic 5
#define HotDogResourceNeedVinegar 5
#define HotDogResourceNeedTomato 5
#define HotDogResourceNeedRice 5
#define HotDogResourceNeedMeet 5
#define HotDogResourceNeedMilk 5
#define HotDogResourceNeedCheese 5
#define HotDogResourceNeedEgg 5

enum FoodData {
    STREAMER_TAG_OBJECT:oid,
    fmodelid,
    ftext[50],
    Text3D:textid,
    Text3D:truckerTextId,
    truckerObjectId,

    FoodLastAccessAt,
    FoodPurchasedAt,
    FoodPrice,
    FoodBalance,
    FoodPIZZA_PRICE,
    FoodFRIES_PRICE,
    FoodCOLA_PRICE,
    FoodBURGER_PRICE,
    FoodHOTDOG_PRICE,

    FoodResourceStorageWater,
    FoodResourceStorageCorn,
    FoodResourceStorageWheat,
    FoodResourceStorageOnion,
    FoodResourceStoragePotato,
    FoodResourceStorageGarlic,
    FoodResourceStorageVinegar,
    FoodResourceStorageTomato,
    FoodResourceStorageRice,
    FoodResourceStorageMeet,
    FoodResourceStorageMilk,
    FoodResourceStorageCheese,
    FoodResourceStorageEgg,

    Float:ObjPosX,
    Float:ObjPosY,
    Float:ObjPosZ,
    Float:ObjRotX,
    Float:ObjRotY,
    Float:ObjRotZ,
    Float:TruckerPosX,
    Float:TruckerPosY,
    Float:TruckerPosZ,
    FoodTruckerInt,
    FoodTruckerVirtualWorld,

    FAMapIconID,
    fActorID,
    fActorSkin,
    Float:ActorX,
    Float:ActorY,
    Float:ActorZ,
    Float:ActorRot,
    food_interior,
    food_virtualworld
};


new FoodInfo[MAX_FOOD][FoodData],
    Iterator:Foods < MAX_FOOD > ,
    Text:Foodobj[15],
    bool:Isviewingobj[MAX_PLAYERS];

forward FallbackloadFoodStall();
public FallbackloadFoodStall() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, foodid, string[255];
        while (Count < rows) {
            cache_get_value_name_int(Count, "ID", foodid);
            cache_get_value_name_int(Count, "modelid", FoodInfo[foodid][fmodelid]);
            cache_get_value_name(Count, "ftext", FoodInfo[foodid][ftext], .max_len = 50);
            cache_get_value_name_int(Count, "Price", FoodInfo[foodid][FoodPrice]);
            cache_get_value_name_int(Count, "LastAccessAt", FoodInfo[foodid][FoodLastAccessAt]);
            cache_get_value_name_int(Count, "PurchasedAt", FoodInfo[foodid][FoodPurchasedAt]);
            cache_get_value_name_int(Count, "Balance", FoodInfo[foodid][FoodBalance]);
            cache_get_value_name_int(Count, "PIZZA", FoodInfo[foodid][FoodPIZZA_PRICE]);
            cache_get_value_name_int(Count, "FRIES", FoodInfo[foodid][FoodFRIES_PRICE]);
            cache_get_value_name_int(Count, "COLA", FoodInfo[foodid][FoodCOLA_PRICE]);
            cache_get_value_name_int(Count, "BURGER", FoodInfo[foodid][FoodBURGER_PRICE]);
            cache_get_value_name_int(Count, "HOTDOG", FoodInfo[foodid][FoodHOTDOG_PRICE]);
            cache_get_value_name_int(Count, "Storagewater", FoodInfo[foodid][FoodResourceStorageWater]);
            cache_get_value_name_int(Count, "StorageCorn", FoodInfo[foodid][FoodResourceStorageCorn]);
            cache_get_value_name_int(Count, "StorageWheat", FoodInfo[foodid][FoodResourceStorageWheat]);
            cache_get_value_name_int(Count, "StorageOnion", FoodInfo[foodid][FoodResourceStorageOnion]);
            cache_get_value_name_int(Count, "StoragePotato", FoodInfo[foodid][FoodResourceStoragePotato]);
            cache_get_value_name_int(Count, "StorageGarlic", FoodInfo[foodid][FoodResourceStorageGarlic]);
            cache_get_value_name_int(Count, "StorageVinegar", FoodInfo[foodid][FoodResourceStorageVinegar]);
            cache_get_value_name_int(Count, "StorageTomato", FoodInfo[foodid][FoodResourceStorageTomato]);
            cache_get_value_name_int(Count, "StorageRice", FoodInfo[foodid][FoodResourceStorageRice]);
            cache_get_value_name_int(Count, "StorageMeet", FoodInfo[foodid][FoodResourceStorageMeet]);
            cache_get_value_name_int(Count, "StorageMilk", FoodInfo[foodid][FoodResourceStorageMilk]);
            cache_get_value_name_int(Count, "StorageCheese", FoodInfo[foodid][FoodResourceStorageCheese]);
            cache_get_value_name_int(Count, "StorageEgg", FoodInfo[foodid][FoodResourceStorageEgg]);
            cache_get_value_name_int(Count, "TruckerInt", FoodInfo[foodid][FoodTruckerInt]);
            cache_get_value_name_int(Count, "TruckerVirtualWorld", FoodInfo[foodid][FoodTruckerVirtualWorld]);
            cache_get_value_name_float(Count, "TruckerPosX", FoodInfo[foodid][TruckerPosX]);
            cache_get_value_name_float(Count, "TruckerPosY", FoodInfo[foodid][TruckerPosY]);
            cache_get_value_name_float(Count, "TruckerPosZ", FoodInfo[foodid][TruckerPosZ]);
            cache_get_value_name_float(Count, "x", FoodInfo[foodid][ObjPosX]);
            cache_get_value_name_float(Count, "y", FoodInfo[foodid][ObjPosY]);
            cache_get_value_name_float(Count, "z", FoodInfo[foodid][ObjPosZ]);
            cache_get_value_name_float(Count, "rotx", FoodInfo[foodid][ObjRotX]);
            cache_get_value_name_float(Count, "roty", FoodInfo[foodid][ObjRotY]);
            cache_get_value_name_float(Count, "rotz", FoodInfo[foodid][ObjRotZ]);
            cache_get_value_name_int(Count, "fActorSkin", FoodInfo[foodid][fActorSkin]);
            cache_get_value_name_float(Count, "ActorX", FoodInfo[foodid][ActorX]);
            cache_get_value_name_float(Count, "ActorY", FoodInfo[foodid][ActorY]);
            cache_get_value_name_float(Count, "ActorZ", FoodInfo[foodid][ActorZ]);
            cache_get_value_name_float(Count, "ActorRot", FoodInfo[foodid][ActorRot]);
            cache_get_value_name_int(Count, "interior", FoodInfo[foodid][food_interior]);
            cache_get_value_name_int(Count, "virtualworld", FoodInfo[foodid][food_virtualworld]);
            Iter_Add(Foods, foodid);

            format(string, sizeof(string), "%s's Food Corner {F1C40F}(%d)\n\n{FFFFFF}press {F1C40F}N {FFFFFF}to open order menu.", FoodStall:GetOwner(foodid), foodid);
            FoodInfo[foodid][textid] = CreateDynamic3DTextLabel(string, -1, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
            format(string, sizeof(string), "%s's Food Corner {F1C40F}(%d)\n\n{FFFFFF}Trunking Point.", FoodStall:GetOwner(foodid), foodid);
            FoodInfo[foodid][truckerTextId] = CreateDynamic3DTextLabel(string, -1, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodInfo[foodid][FoodTruckerVirtualWorld], FoodInfo[foodid][FoodTruckerInt]);
            FoodInfo[foodid][oid] = CreateDynamicObject(FoodInfo[foodid][fmodelid], FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ], FoodInfo[foodid][ObjRotX], FoodInfo[foodid][ObjRotY], FoodInfo[foodid][ObjRotZ], FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
            FoodInfo[foodid][fActorID] = CreateDynamicActor(FoodInfo[foodid][fActorSkin], FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], FoodInfo[foodid][ActorRot], .worldid = FoodInfo[foodid][food_virtualworld], .interiorid = FoodInfo[foodid][food_interior]);
            FoodInfo[foodid][FAMapIconID] = CreateDynamicMapIcon(FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], 29, 5, FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
            FoodInfo[foodid][truckerObjectId] = CreateDynamicPickup(19832, 23, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ], FoodInfo[foodid][FoodTruckerVirtualWorld], FoodInfo[foodid][FoodTruckerInt]);

            FoodStall:UpdateText(foodid, false);
            Count++;
        }
    }
    printf("  [Food System] Loaded %d Food's Data.", rows);
    return 1;
}

stock FoodStall:Resetlabels(foodid) {
    new string[1024];
    DestroyDynamic3DTextLabel(FoodInfo[foodid][textid]);
    DestroyDynamic3DTextLabel(FoodInfo[foodid][truckerTextId]);
    format(string, sizeof(string), "%s's Food Corner {F1C40F}(%d)\n\n{FFFFFF}press {F1C40F}N {FFFFFF}to open order menu.", FoodStall:GetOwner(foodid), foodid);
    FoodInfo[foodid][textid] = CreateDynamic3DTextLabel(string, -1, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
    format(string, sizeof(string), "%s's Food Corner {F1C40F}(%d)\n\n{FFFFFF}Trunking Point.", FoodStall:GetOwner(foodid), foodid);
    FoodInfo[foodid][truckerTextId] = CreateDynamic3DTextLabel(string, -1, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodInfo[foodid][FoodTruckerVirtualWorld], FoodInfo[foodid][FoodTruckerInt]);
    return 1;
}

stock FoodStall:IsValidID(foodid) {
    return Iter_Contains(Foods, foodid);
}

stock FoodStall:IsPurchased(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    return strcmp(FoodInfo[foodid][ftext], "-");
}

stock FoodStall:GetPrice(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    return FoodInfo[foodid][FoodPrice];
}

stock FoodStall:SetPrice(foodid, newprice) {
    return FoodInfo[foodid][FoodPrice] = newprice;
}

stock FoodStall:GetBalance(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    return FoodInfo[foodid][FoodBalance];
}

stock FoodStall:UpdateBalance(foodid, amount, const log[]) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    mysql_tquery(Database, sprintf("insert into foodShopTransactions (storeid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        foodid, amount, FoodInfo[foodid][FoodBalance], log, gettime()));
    FoodInfo[foodid][FoodBalance] = amount;
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:GetOwner(foodid) {
    new string[50] = "San Andreas Goverment Department";
    if (!FoodStall:IsPurchased(foodid)) return string;
    format(string, sizeof string, "%s", FoodInfo[foodid][ftext]);
    return string;
}

stock FoodStall:GetTotal(playerid) {
    new count = 0;
    foreach(new foodid:Foods) {
        if (IsStringSame(GetPlayerNameEx(playerid), FoodInfo[foodid][ftext])) count++;
    }
    return count;
}

stock FoodStall:DatabaseInsert(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    new query[4000];
    format(
        query, sizeof query,
        "insert into foodStalls (ID,modelid,ftext,Price,LastAccessAt,PurchasedAt,Balance,\
        PIZZA,FRIES,COLA,BURGER,HOTDOG,Storagewater,StorageCorn,StorageWheat,StorageOnion,\
        StoragePotato,StorageGarlic,StorageVinegar,StorageTomato,StorageRice,StorageMeet,\
        StorageMilk,StorageCheese,StorageEgg,TruckerInt,TruckerVirtualWorld,TruckerPosX,\
        TruckerPosY,TruckerPosZ,x,y,z,rotx,roty,rotz,fActorSkin,ActorX,ActorY,ActorZ,\
        ActorRot,interior,virtualworld) Values (%d,%d,\"%s\",%d,%d,%d,%d,%d,%d,%d,%d,\
        %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%f,%f,%f,%f,%d,%d)",
        foodid,
        FoodInfo[foodid][fmodelid],
        FoodInfo[foodid][ftext],
        FoodInfo[foodid][FoodPrice],
        FoodInfo[foodid][FoodLastAccessAt],
        FoodInfo[foodid][FoodPurchasedAt],
        FoodInfo[foodid][FoodBalance],
        FoodInfo[foodid][FoodPIZZA_PRICE],
        FoodInfo[foodid][FoodFRIES_PRICE],
        FoodInfo[foodid][FoodCOLA_PRICE],
        FoodInfo[foodid][FoodBURGER_PRICE],
        FoodInfo[foodid][FoodHOTDOG_PRICE],
        FoodInfo[foodid][FoodResourceStorageWater],
        FoodInfo[foodid][FoodResourceStorageCorn],
        FoodInfo[foodid][FoodResourceStorageWheat],
        FoodInfo[foodid][FoodResourceStorageOnion],
        FoodInfo[foodid][FoodResourceStoragePotato],
        FoodInfo[foodid][FoodResourceStorageGarlic],
        FoodInfo[foodid][FoodResourceStorageVinegar],
        FoodInfo[foodid][FoodResourceStorageTomato],
        FoodInfo[foodid][FoodResourceStorageRice],
        FoodInfo[foodid][FoodResourceStorageMeet],
        FoodInfo[foodid][FoodResourceStorageMilk],
        FoodInfo[foodid][FoodResourceStorageCheese],
        FoodInfo[foodid][FoodResourceStorageEgg],
        FoodInfo[foodid][FoodTruckerInt],
        FoodInfo[foodid][FoodTruckerVirtualWorld],
        FoodInfo[foodid][TruckerPosX],
        FoodInfo[foodid][TruckerPosY],
        FoodInfo[foodid][TruckerPosZ],
        FoodInfo[foodid][ObjPosX],
        FoodInfo[foodid][ObjPosY],
        FoodInfo[foodid][ObjPosZ],
        FoodInfo[foodid][ObjRotX],
        FoodInfo[foodid][ObjRotY],
        FoodInfo[foodid][ObjRotZ],
        FoodInfo[foodid][fActorSkin],
        FoodInfo[foodid][ActorX],
        FoodInfo[foodid][ActorY],
        FoodInfo[foodid][ActorZ],
        FoodInfo[foodid][ActorRot],
        FoodInfo[foodid][food_interior],
        FoodInfo[foodid][food_virtualworld]
    );
    mysql_tquery(Database, query);
    return 1;
}

stock FoodStall:DatabaseUpdate(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    new query[4000];
    format(
        query, sizeof query,
        "update foodStalls set modelid = %d,ftext = \"%s\",Price = %d,LastAccessAt = %d,PurchasedAt = %d,\
        Balance = %d,PIZZA = %d,FRIES = %d,COLA = %d,BURGER = %d,HOTDOG = %d,Storagewater = %d,StorageCorn = %d,\
        StorageWheat = %d,StorageOnion = %d,StoragePotato = %d,StorageGarlic = %d,StorageVinegar = %d,\
        StorageTomato = %d,StorageRice = %d,StorageMeet = %d,StorageMilk = %d,StorageCheese = %d,StorageEgg = %d,\
        TruckerInt = %d,TruckerVirtualWorld = %d,TruckerPosX = %f,TruckerPosY = %f,TruckerPosZ = %f,x = %f,\
        y = %f,z = %f,rotx = %f,roty = %f,rotz = %f,fActorSkin = %d,ActorX = %f,ActorY = %f,ActorZ = %f,\
        ActorRot = %f,interior = %d,virtualworld = %d where ID = %d",
        FoodInfo[foodid][fmodelid],
        FoodInfo[foodid][ftext],
        FoodInfo[foodid][FoodPrice],
        FoodInfo[foodid][FoodLastAccessAt],
        FoodInfo[foodid][FoodPurchasedAt],
        FoodInfo[foodid][FoodBalance],
        FoodInfo[foodid][FoodPIZZA_PRICE],
        FoodInfo[foodid][FoodFRIES_PRICE],
        FoodInfo[foodid][FoodCOLA_PRICE],
        FoodInfo[foodid][FoodBURGER_PRICE],
        FoodInfo[foodid][FoodHOTDOG_PRICE],
        FoodInfo[foodid][FoodResourceStorageWater],
        FoodInfo[foodid][FoodResourceStorageCorn],
        FoodInfo[foodid][FoodResourceStorageWheat],
        FoodInfo[foodid][FoodResourceStorageOnion],
        FoodInfo[foodid][FoodResourceStoragePotato],
        FoodInfo[foodid][FoodResourceStorageGarlic],
        FoodInfo[foodid][FoodResourceStorageVinegar],
        FoodInfo[foodid][FoodResourceStorageTomato],
        FoodInfo[foodid][FoodResourceStorageRice],
        FoodInfo[foodid][FoodResourceStorageMeet],
        FoodInfo[foodid][FoodResourceStorageMilk],
        FoodInfo[foodid][FoodResourceStorageCheese],
        FoodInfo[foodid][FoodResourceStorageEgg],
        FoodInfo[foodid][FoodTruckerInt],
        FoodInfo[foodid][FoodTruckerVirtualWorld],
        FoodInfo[foodid][TruckerPosX],
        FoodInfo[foodid][TruckerPosY],
        FoodInfo[foodid][TruckerPosZ],
        FoodInfo[foodid][ObjPosX],
        FoodInfo[foodid][ObjPosY],
        FoodInfo[foodid][ObjPosZ],
        FoodInfo[foodid][ObjRotX],
        FoodInfo[foodid][ObjRotY],
        FoodInfo[foodid][ObjRotZ],
        FoodInfo[foodid][fActorSkin],
        FoodInfo[foodid][ActorX],
        FoodInfo[foodid][ActorY],
        FoodInfo[foodid][ActorZ],
        FoodInfo[foodid][ActorRot],
        FoodInfo[foodid][food_interior],
        FoodInfo[foodid][food_virtualworld],
        foodid
    );
    mysql_tquery(Database, query);
    return 1;
}

stock FoodStall:GetPurchaseAt(foodid) {
    return FoodInfo[foodid][FoodPurchasedAt];
}

stock FoodStall:UpdatePurchaseAt(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodPurchasedAt] = gettime();
    return 1;
}

stock FoodStall:GetLastAccess(foodid) {
    return FoodInfo[foodid][FoodLastAccessAt];
}

stock FoodStall:UpdateLastAccess(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodLastAccessAt] = gettime();
    return 1;
}

stock FoodStall:SetOwner(foodid, const ownername[]) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    format(FoodInfo[foodid][ftext], 50, "%s", ownername);
    return 1;
}

stock FoodStall:UpdateText(foodid, bool:dbupdate = true) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    new string[1024];
    strcat(string, sprintf("%s's Food Corner [%d]\n", FoodStall:GetOwner(foodid), foodid));
    strcat(string, sprintf("{F1C40F}Pizza:%s\n", FoodStall:IsHaveResourceForPizza(foodid) ? sprintf("{00FF00}$%s/per Order{FFFFFF}", FormatCurrency(FoodStall:GetPizzaPrice(foodid))) :  "{FF0000}Not Available{FFFFFF}"));
    strcat(string, sprintf("{F1C40F}Fries:%s\n", FoodStall:IsHaveResourceForFries(foodid) ? sprintf("{00FF00}$%s/per Order{FFFFFF}", FormatCurrency(FoodStall:GetFriesPrice(foodid))) :  "{FF0000}Not Available{FFFFFF}"));
    strcat(string, sprintf("{F1C40F}Cola:%s\n", FoodStall:IsHaveResourceForCola(foodid) ? sprintf("{00FF00}$%s/per Order{FFFFFF}", FormatCurrency(FoodStall:GetColaPrice(foodid))) :  "{FF0000}Not Available{FFFFFF}"));
    strcat(string, sprintf("{F1C40F}Burger:%s\n", FoodStall:IsHaveResourceForBurger(foodid) ? sprintf("{00FF00}$%s/per Order{FFFFFF}", FormatCurrency(FoodStall:GetBurgerPrice(foodid))) :  "{FF0000}Not Available{FFFFFF}"));
    strcat(string, sprintf("{F1C40F}HotDog:%s\n", FoodStall:IsHaveResourceForHotDog(foodid) ? sprintf("{00FF00}$%s/per Order{FFFFFF}", FormatCurrency(FoodStall:GetHotDogPrice(foodid))) :  "{FF0000}Not Available{FFFFFF}"));
    if (FoodStall:IsPurchased(foodid)) {
        strcat(string, sprintf("{FF0000}Owner Last Visited - %s\n", UnixToHumanEx(FoodInfo[foodid][FoodLastAccessAt])));
        strcat(string, "\n{FFFFFF}press {F1C40F}N {FFFFFF}to open order menu.");
    } else strcat(string, sprintf("{00FF00} On Sale:$%s\n{FFFFFF}press {F1C40F}N {FFFFFF}to purchase.", FormatCurrency(FoodStall:GetPrice(foodid))));
    UpdateDynamic3DTextLabelText(FoodInfo[foodid][textid], -1, string);
    UpdateDynamic3DTextLabelText(FoodInfo[foodid][truckerTextId], -1, sprintf("%s's Food Corner {F1C40F}(%d)\n\n{FFFFFF}Trunking Point.", FoodStall:GetOwner(foodid), foodid));
    if (dbupdate) FoodStall:DatabaseUpdate(foodid);
    return 1;
}

stock FoodStall:GetPizzaPrice(foodid) { if (!FoodStall:IsValidID(foodid)) return 0; return FoodInfo[foodid][FoodPIZZA_PRICE]; }
stock FoodStall:GetFriesPrice(foodid) { if (!FoodStall:IsValidID(foodid)) return 0; return FoodInfo[foodid][FoodFRIES_PRICE]; }
stock FoodStall:GetColaPrice(foodid) { if (!FoodStall:IsValidID(foodid)) return 0; return FoodInfo[foodid][FoodCOLA_PRICE]; }
stock FoodStall:GetBurgerPrice(foodid) { if (!FoodStall:IsValidID(foodid)) return 0; return FoodInfo[foodid][FoodBURGER_PRICE]; }
stock FoodStall:GetHotDogPrice(foodid) { if (!FoodStall:IsValidID(foodid)) return 0; return FoodInfo[foodid][FoodHOTDOG_PRICE]; }

stock FoodStall:SetPizzaPrice(foodid, amount) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodPIZZA_PRICE] = amount;
    return 1;
}
stock FoodStall:SetFriesPrice(foodid, amount) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodFRIES_PRICE] = amount;
    return 1;
}
stock FoodStall:SetColaPrice(foodid, amount) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodCOLA_PRICE] = amount;
    return 1;
}
stock FoodStall:SetBurgerPrice(foodid, amount) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodBURGER_PRICE] = amount;
    return 1;
}
stock FoodStall:SetHotDogPrice(foodid, amount) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodInfo[foodid][FoodHOTDOG_PRICE] = amount;
    return 1;
}

stock FoodStall:GetResourceWater(foodid) {
    return FoodInfo[foodid][FoodResourceStorageWater];
}
stock FoodStall:GetResourceCorn(foodid) {
    return FoodInfo[foodid][FoodResourceStorageCorn];
}
stock FoodStall:GetResourceWheat(foodid) {
    return FoodInfo[foodid][FoodResourceStorageWheat];
}
stock FoodStall:GetResourceOnion(foodid) {
    return FoodInfo[foodid][FoodResourceStorageOnion];
}
stock FoodStall:GetResourcePotato(foodid) {
    return FoodInfo[foodid][FoodResourceStoragePotato];
}
stock FoodStall:GetResourceGarlic(foodid) {
    return FoodInfo[foodid][FoodResourceStorageGarlic];
}
stock FoodStall:GetResourceVinegar(foodid) {
    return FoodInfo[foodid][FoodResourceStorageVinegar];
}
stock FoodStall:GetResourceTomato(foodid) {
    return FoodInfo[foodid][FoodResourceStorageTomato];
}
stock FoodStall:GetResourceRice(foodid) {
    return FoodInfo[foodid][FoodResourceStorageRice];
}
stock FoodStall:GetResourceMeet(foodid) {
    return FoodInfo[foodid][FoodResourceStorageMeet];
}
stock FoodStall:GetResourceMilk(foodid) {
    return FoodInfo[foodid][FoodResourceStorageMilk];
}
stock FoodStall:GetResourceCheese(foodid) {
    return FoodInfo[foodid][FoodResourceStorageCheese];
}
stock FoodStall:GetResourceEgg(foodid) {
    return FoodInfo[foodid][FoodResourceStorageEgg];
}

stock FoodStall:UpdateResourceWater(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageWater] = newvalue; return 1; }
stock FoodStall:UpdateResourceCorn(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageCorn] = newvalue; return 1; }
stock FoodStall:UpdateResourceWheat(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageWheat] = newvalue; return 1; }
stock FoodStall:UpdateResourceOnion(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageOnion] = newvalue; return 1; }
stock FoodStall:UpdateResourcePotato(foodid, newvalue) { FoodInfo[foodid][FoodResourceStoragePotato] = newvalue; return 1; }
stock FoodStall:UpdateResourceGarlic(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageGarlic] = newvalue; return 1; }
stock FoodStall:UpdateResourceVinegar(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageVinegar] = newvalue; return 1; }
stock FoodStall:UpdateResourceTomato(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageTomato] = newvalue; return 1; }
stock FoodStall:UpdateResourceRice(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageRice] = newvalue; return 1; }
stock FoodStall:UpdateResourceMeet(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageMeet] = newvalue; return 1; }
stock FoodStall:UpdateResourceMilk(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageMilk] = newvalue; return 1; }
stock FoodStall:UpdateResourceCheese(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageCheese] = newvalue; return 1; }
stock FoodStall:UpdateResourceEgg(foodid, newvalue) { FoodInfo[foodid][FoodResourceStorageEgg] = newvalue; return 1; }

stock FoodStall:IsHaveResourceForPizza(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    if (FoodStall:GetResourceWater(foodid) >= PizzaResourceNeedWater &&
        FoodStall:GetResourceCorn(foodid) >= PizzaResourceNeedCorn &&
        FoodStall:GetResourceWheat(foodid) >= PizzaResourceNeedWheat &&
        FoodStall:GetResourceOnion(foodid) >= PizzaResourceNeedOnion &&
        FoodStall:GetResourcePotato(foodid) >= PizzaResourceNeedPotato &&
        FoodStall:GetResourceGarlic(foodid) >= PizzaResourceNeedGarlic &&
        FoodStall:GetResourceVinegar(foodid) >= PizzaResourceNeedVinegar &&
        FoodStall:GetResourceTomato(foodid) >= PizzaResourceNeedTomato &&
        FoodStall:GetResourceRice(foodid) >= PizzaResourceNeedRice &&
        FoodStall:GetResourceMeet(foodid) >= PizzaResourceNeedMeet &&
        FoodStall:GetResourceMilk(foodid) >= PizzaResourceNeedMilk &&
        FoodStall:GetResourceCheese(foodid) >= PizzaResourceNeedCheese &&
        FoodStall:GetResourceEgg(foodid) >= PizzaResourceNeedEgg
    ) return 1;
    return 0;
}

stock FoodStall:IsHaveResourceForFries(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    if (FoodStall:GetResourceWater(foodid) > FriesResourceNeedWater &&
        FoodStall:GetResourceCorn(foodid) > FriesResourceNeedCorn &&
        FoodStall:GetResourceWheat(foodid) > FriesResourceNeedWheat &&
        FoodStall:GetResourceOnion(foodid) > FriesResourceNeedOnion &&
        FoodStall:GetResourcePotato(foodid) > FriesResourceNeedPotato &&
        FoodStall:GetResourceGarlic(foodid) > FriesResourceNeedGarlic &&
        FoodStall:GetResourceVinegar(foodid) > FriesResourceNeedVinegar &&
        FoodStall:GetResourceTomato(foodid) > FriesResourceNeedTomato &&
        FoodStall:GetResourceRice(foodid) > FriesResourceNeedRice &&
        FoodStall:GetResourceMeet(foodid) > FriesResourceNeedMeet &&
        FoodStall:GetResourceMilk(foodid) > FriesResourceNeedMilk &&
        FoodStall:GetResourceCheese(foodid) > FriesResourceNeedCheese &&
        FoodStall:GetResourceEgg(foodid) > FriesResourceNeedEgg
    ) return 1;
    return 0;
}

stock FoodStall:IsHaveResourceForCola(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    if (FoodStall:GetResourceWater(foodid) > ColaResourceNeedWater &&
        FoodStall:GetResourceCorn(foodid) > ColaResourceNeedCorn &&
        FoodStall:GetResourceWheat(foodid) > ColaResourceNeedWheat &&
        FoodStall:GetResourceOnion(foodid) > ColaResourceNeedOnion &&
        FoodStall:GetResourcePotato(foodid) > ColaResourceNeedPotato &&
        FoodStall:GetResourceGarlic(foodid) > ColaResourceNeedGarlic &&
        FoodStall:GetResourceVinegar(foodid) > ColaResourceNeedVinegar &&
        FoodStall:GetResourceTomato(foodid) > ColaResourceNeedTomato &&
        FoodStall:GetResourceRice(foodid) > ColaResourceNeedRice &&
        FoodStall:GetResourceMeet(foodid) > ColaResourceNeedMeet &&
        FoodStall:GetResourceMilk(foodid) > ColaResourceNeedMilk &&
        FoodStall:GetResourceCheese(foodid) > ColaResourceNeedCheese &&
        FoodStall:GetResourceEgg(foodid) > ColaResourceNeedEgg
    ) return 1;
    return 0;
}

stock FoodStall:IsHaveResourceForBurger(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    if (FoodStall:GetResourceWater(foodid) > BurgerResourceNeedWater &&
        FoodStall:GetResourceCorn(foodid) > BurgerResourceNeedCorn &&
        FoodStall:GetResourceWheat(foodid) > BurgerResourceNeedWheat &&
        FoodStall:GetResourceOnion(foodid) > BurgerResourceNeedOnion &&
        FoodStall:GetResourcePotato(foodid) > BurgerResourceNeedPotato &&
        FoodStall:GetResourceGarlic(foodid) > BurgerResourceNeedGarlic &&
        FoodStall:GetResourceVinegar(foodid) > BurgerResourceNeedVinegar &&
        FoodStall:GetResourceTomato(foodid) > BurgerResourceNeedTomato &&
        FoodStall:GetResourceRice(foodid) > BurgerResourceNeedRice &&
        FoodStall:GetResourceMeet(foodid) > BurgerResourceNeedMeet &&
        FoodStall:GetResourceMilk(foodid) > BurgerResourceNeedMilk &&
        FoodStall:GetResourceCheese(foodid) > BurgerResourceNeedCheese &&
        FoodStall:GetResourceEgg(foodid) > BurgerResourceNeedEgg
    ) return 1;
    return 0;
}

stock FoodStall:IsHaveResourceForHotDog(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    if (FoodStall:GetResourceWater(foodid) > HotDogResourceNeedWater &&
        FoodStall:GetResourceCorn(foodid) > HotDogResourceNeedCorn &&
        FoodStall:GetResourceWheat(foodid) > HotDogResourceNeedWheat &&
        FoodStall:GetResourceOnion(foodid) > HotDogResourceNeedOnion &&
        FoodStall:GetResourcePotato(foodid) > HotDogResourceNeedPotato &&
        FoodStall:GetResourceGarlic(foodid) > HotDogResourceNeedGarlic &&
        FoodStall:GetResourceVinegar(foodid) > HotDogResourceNeedVinegar &&
        FoodStall:GetResourceTomato(foodid) > HotDogResourceNeedTomato &&
        FoodStall:GetResourceRice(foodid) > HotDogResourceNeedRice &&
        FoodStall:GetResourceMeet(foodid) > HotDogResourceNeedMeet &&
        FoodStall:GetResourceMilk(foodid) > HotDogResourceNeedMilk &&
        FoodStall:GetResourceCheese(foodid) > HotDogResourceNeedCheese &&
        FoodStall:GetResourceEgg(foodid) > HotDogResourceNeedEgg
    ) return 1;
    return 0;
}

stock FoodStall:IsHaveResource(foodid) {
    return FoodStall:IsHaveResourceForPizza(foodid) ||
        FoodStall:IsHaveResourceForFries(foodid) ||
        FoodStall:IsHaveResourceForCola(foodid) ||
        FoodStall:IsHaveResourceForBurger(foodid) ||
        FoodStall:IsHaveResourceForHotDog(foodid);
}

stock FoodStall:DeductResourceForPizza(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) - PizzaResourceNeedWater);
    FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) - PizzaResourceNeedCorn);
    FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) - PizzaResourceNeedWheat);
    FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) - PizzaResourceNeedOnion);
    FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) - PizzaResourceNeedPotato);
    FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) - PizzaResourceNeedGarlic);
    FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) - PizzaResourceNeedVinegar);
    FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) - PizzaResourceNeedTomato);
    FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) - PizzaResourceNeedRice);
    FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) - PizzaResourceNeedMeet);
    FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) - PizzaResourceNeedMilk);
    FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) - PizzaResourceNeedCheese);
    FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) - PizzaResourceNeedEgg);
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:DeductResourceForFries(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) - FriesResourceNeedWater);
    FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) - FriesResourceNeedCorn);
    FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) - FriesResourceNeedWheat);
    FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) - FriesResourceNeedOnion);
    FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) - FriesResourceNeedPotato);
    FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) - FriesResourceNeedGarlic);
    FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) - FriesResourceNeedVinegar);
    FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) - FriesResourceNeedTomato);
    FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) - FriesResourceNeedRice);
    FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) - FriesResourceNeedMeet);
    FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) - FriesResourceNeedMilk);
    FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) - FriesResourceNeedCheese);
    FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) - FriesResourceNeedEgg);
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:DeductResourceForCola(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) - ColaResourceNeedWater);
    FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) - ColaResourceNeedCorn);
    FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) - ColaResourceNeedWheat);
    FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) - ColaResourceNeedOnion);
    FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) - ColaResourceNeedPotato);
    FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) - ColaResourceNeedGarlic);
    FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) - ColaResourceNeedVinegar);
    FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) - ColaResourceNeedTomato);
    FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) - ColaResourceNeedRice);
    FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) - ColaResourceNeedMeet);
    FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) - ColaResourceNeedMilk);
    FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) - ColaResourceNeedCheese);
    FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) - ColaResourceNeedEgg);
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:DeductResourceForBurger(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) - BurgerResourceNeedWater);
    FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) - BurgerResourceNeedCorn);
    FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) - BurgerResourceNeedWheat);
    FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) - BurgerResourceNeedOnion);
    FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) - BurgerResourceNeedPotato);
    FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) - BurgerResourceNeedGarlic);
    FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) - BurgerResourceNeedVinegar);
    FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) - BurgerResourceNeedTomato);
    FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) - BurgerResourceNeedRice);
    FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) - BurgerResourceNeedMeet);
    FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) - BurgerResourceNeedMilk);
    FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) - BurgerResourceNeedCheese);
    FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) - BurgerResourceNeedEgg);
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:DeductResourceForHotDog(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 0;
    FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) - HotDogResourceNeedWater);
    FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) - HotDogResourceNeedCorn);
    FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) - HotDogResourceNeedWheat);
    FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) - HotDogResourceNeedOnion);
    FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) - HotDogResourceNeedPotato);
    FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) - HotDogResourceNeedGarlic);
    FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) - HotDogResourceNeedVinegar);
    FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) - HotDogResourceNeedTomato);
    FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) - HotDogResourceNeedRice);
    FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) - HotDogResourceNeedMeet);
    FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) - HotDogResourceNeedMilk);
    FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) - HotDogResourceNeedCheese);
    FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) - HotDogResourceNeedEgg);
    FoodStall:UpdateText(foodid);
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new foodid:Foods) {
        if (FoodStall:IsPurchased(foodid)) {
            if (gettime() - FoodStall:GetLastAccess(foodid) > FOOD_SHOP_RESET_DAY * 86400 && !IsStringSame(FoodStall:GetOwner(foodid), "Harry_James")) {
                if (!IsPlayerInServerByName(FoodStall:GetOwner(foodid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, FoodStall:GetOwner(foodid), sprintf("food stall [%d] has been auto reset!!", foodid),
                        sprintf("food stall [%d] has been auto reset!! Your food stall has been taken by government due to not used by you in long time.", foodid)
                    );
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Food Stall [%d]\n\
                Status: reseted\n\
                Reason: due to not used in long time\n\
                ```\
                ", FoodStall:GetOwner(foodid), foodid));
                FoodStall:Reset(foodid);
            }
        }
    }
    return 1;
}

hook GlobalHourInterval() {
    foreach(new foodid:Foods) {
        if (FoodStall:IsPurchased(foodid)) {
            new beforeDay = 1;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new stallWillResetAt = FoodStall:GetLastAccess(foodid) + (FOOD_SHOP_RESET_DAY - beforeDay) * 86400;
            if (stallWillResetAt >= mintime && stallWillResetAt < maxtime && !IsStringSame(FoodStall:GetOwner(foodid), "Harry_James")) {
                if (!IsPlayerInServerByName(FoodStall:GetOwner(foodid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, FoodStall:GetOwner(foodid), sprintf("food stall [%d] will reset after 24 hours!!", foodid),
                        sprintf("food stall [%d] will reset after 24 hours!! you can stop this reset by visitng your food stall within 24 hours.", foodid)
                    );
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Food Stall [%d]\n\
                Status: will reset within 24 hours\n\
                Reason: due to not used in long time\n\
                ```\
                ", FoodStall:GetOwner(foodid), foodid));
            }
        }
    }
    foreach(new foodid:Foods) {
        if (FoodStall:IsPurchased(foodid)) {
            new beforeDay = 2;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new stallWillResetAt = FoodStall:GetLastAccess(foodid) + (FOOD_SHOP_RESET_DAY - beforeDay) * 86400;
            if (stallWillResetAt >= mintime && stallWillResetAt < maxtime && !IsStringSame(FoodStall:GetOwner(foodid), "Harry_James")) {
                if (!IsPlayerInServerByName(FoodStall:GetOwner(foodid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, FoodStall:GetOwner(foodid), sprintf("food stall [%d] will reset after 48 hours!!", foodid),
                        sprintf("food stall [%d] will reset after 24 hours!! you can stop this reset by visitng your food stall within 48 hours.", foodid)
                    );
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Food Stall [%d]\n\
                Status: will reset within 48 hours\n\
                Reason: due to not used in long time\n\
                ```\
                ", FoodStall:GetOwner(foodid), foodid));
            }
        }
    }
    return 1;
}

hook OnGameModeInit() {
    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `foodStalls` (\
	`ID` int(11) NOT NULL,\
		`modelid` int(11) NOT NULL,\
	    `ftext` varchar(32) NOT NULL,\
	  	`x` FLOAT NOT NULL,\
	  	`y` FLOAT NOT NULL,\
	  	`z` FLOAT NOT NULL,\
	  	`rotx` FLOAT NOT NULL,\
	  	`roty` FLOAT NOT NULL,\
	  	`rotz` FLOAT NOT NULL,\
		`fActorSkin` int(11) NOT NULL,\
	  	`ActorX` FLOAT NOT NULL,\
	  	`ActorY` FLOAT NOT NULL,\
	  	`ActorZ` FLOAT NOT NULL,\
	  	`ActorRot` FLOAT NOT NULL,");
    strcat(query, "`interior` int(11) NOT NULL default '-1',\
	`virtualworld` int(11) NOT NULL default '-1',\
	PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM foodStalls", "FallbackloadFoodStall", "");

    Foodobj[1] = TextDrawCreate(192.699951, 118.449996, "");
    TextDrawLetterSize(Foodobj[1], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[1], 248.000000, 209.000000);
    TextDrawAlignment(Foodobj[1], 1);
    TextDrawColor(Foodobj[1], 255);
    TextDrawSetShadow(Foodobj[1], 0);
    TextDrawSetOutline(Foodobj[1], 0);
    TextDrawBackgroundColor(Foodobj[1], 0);
    TextDrawFont(Foodobj[1], 5);
    TextDrawSetProportional(Foodobj[1], 0);
    TextDrawSetShadow(Foodobj[1], 0);
    TextDrawSetPreviewModel(Foodobj[1], 1895);
    TextDrawSetPreviewRot(Foodobj[1], 0.000000, 0.000000, 0.000000, 1.000000);

    Foodobj[0] = TextDrawCreate(278.500000, 120.000000, "box");
    TextDrawLetterSize(Foodobj[0], 0.000000, 15.299999);
    TextDrawTextSize(Foodobj[0], 350.000000, 0.000000);
    TextDrawAlignment(Foodobj[0], 1);
    TextDrawColor(Foodobj[0], -1);
    TextDrawUseBox(Foodobj[0], 1);
    TextDrawBoxColor(Foodobj[0], -935582209);
    TextDrawSetShadow(Foodobj[0], 0);
    TextDrawSetOutline(Foodobj[0], 0);
    TextDrawBackgroundColor(Foodobj[0], 255);
    TextDrawFont(Foodobj[0], 1);
    TextDrawSetProportional(Foodobj[0], 1);
    TextDrawSetShadow(Foodobj[0], 0);

    Foodobj[2] = TextDrawCreate(219.500000, 206.187500, "");
    TextDrawLetterSize(Foodobj[2], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[2], 186.000000, 81.000000);
    TextDrawAlignment(Foodobj[2], 1);
    TextDrawColor(Foodobj[2], 255);
    TextDrawSetShadow(Foodobj[2], 0);
    TextDrawSetOutline(Foodobj[2], 0);
    TextDrawBackgroundColor(Foodobj[2], 0);
    TextDrawFont(Foodobj[2], 5);
    TextDrawSetProportional(Foodobj[2], 0);
    TextDrawSetShadow(Foodobj[2], 0);
    TextDrawSetPreviewModel(Foodobj[2], 19134);
    TextDrawSetPreviewRot(Foodobj[2], 0.000000, 0.000000, 90.000000, 1.000000);

    Foodobj[3] = TextDrawCreate(296.500000, 144.062500, "FAST~n~~n~~n~MENU");
    TextDrawLetterSize(Foodobj[3], 0.400000, 1.600000);
    TextDrawAlignment(Foodobj[3], 1);
    TextDrawColor(Foodobj[3], -54630401);
    TextDrawSetShadow(Foodobj[3], 0);
    TextDrawSetOutline(Foodobj[3], 0);
    TextDrawBackgroundColor(Foodobj[3], 255);
    TextDrawFont(Foodobj[3], 1);
    TextDrawSetProportional(Foodobj[3], 1);
    TextDrawSetShadow(Foodobj[3], 0);

    Foodobj[4] = TextDrawCreate(287.500000, 162.000000, "FOOD");
    TextDrawLetterSize(Foodobj[4], 0.539499, 1.888749);
    TextDrawAlignment(Foodobj[4], 1);
    TextDrawColor(Foodobj[4], -1);
    TextDrawSetShadow(Foodobj[4], 0);
    TextDrawSetOutline(Foodobj[4], 0);
    TextDrawBackgroundColor(Foodobj[4], 255);
    TextDrawFont(Foodobj[4], 1);
    TextDrawSetProportional(Foodobj[4], 1);
    TextDrawSetShadow(Foodobj[4], 0);

    Foodobj[5] = TextDrawCreate(183.500000, 120.000000, "");
    TextDrawLetterSize(Foodobj[5], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[5], 90.000000, 90.000000);
    TextDrawAlignment(Foodobj[5], 1);
    TextDrawColor(Foodobj[5], -1);
    TextDrawSetShadow(Foodobj[5], 0);
    TextDrawSetOutline(Foodobj[5], 0);
    TextDrawBackgroundColor(Foodobj[5], 0);
    TextDrawFont(Foodobj[5], 5);
    TextDrawSetProportional(Foodobj[5], 0);
    TextDrawSetShadow(Foodobj[5], 0);
    TextDrawSetSelectable(Foodobj[5], true);
    TextDrawSetPreviewModel(Foodobj[5], 2702);
    TextDrawSetPreviewRot(Foodobj[5], 0.000000, -60.000000, 90.000000, 1.000000);

    Foodobj[6] = TextDrawCreate(221.500000, 197.875000, "PIZZA~n~~g~");
    TextDrawLetterSize(Foodobj[6], 0.282500, 0.865000);
    TextDrawAlignment(Foodobj[6], 1);
    TextDrawColor(Foodobj[6], -1);
    TextDrawSetShadow(Foodobj[6], 0);
    TextDrawSetOutline(Foodobj[6], 0);
    TextDrawBackgroundColor(Foodobj[6], 255);
    TextDrawFont(Foodobj[6], 2);
    TextDrawSetProportional(Foodobj[6], 1);
    TextDrawSetShadow(Foodobj[6], 0);

    Foodobj[7] = TextDrawCreate(183.000000, 193.500000, "");
    TextDrawLetterSize(Foodobj[7], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[7], 83.000000, 101.000000);
    TextDrawAlignment(Foodobj[7], 1);
    TextDrawColor(Foodobj[7], -1);
    TextDrawSetShadow(Foodobj[7], 0);
    TextDrawSetOutline(Foodobj[7], 0);
    TextDrawBackgroundColor(Foodobj[7], 0);
    TextDrawFont(Foodobj[7], 5);
    TextDrawSetProportional(Foodobj[7], 0);
    TextDrawSetShadow(Foodobj[7], 0);
    TextDrawSetSelectable(Foodobj[7], true);
    TextDrawSetPreviewModel(Foodobj[7], 2858);
    TextDrawSetPreviewRot(Foodobj[7], 0.000000, 0.000000, 270.000000, 1.000000);

    Foodobj[8] = TextDrawCreate(227.500000, 260.875000, "FRIES~n~~g~");
    TextDrawLetterSize(Foodobj[8], 0.282500, 0.865000);
    TextDrawAlignment(Foodobj[8], 1);
    TextDrawColor(Foodobj[8], -1);
    TextDrawSetShadow(Foodobj[8], 0);
    TextDrawSetOutline(Foodobj[8], 0);
    TextDrawBackgroundColor(Foodobj[8], 255);
    TextDrawFont(Foodobj[8], 2);
    TextDrawSetProportional(Foodobj[8], 1);
    TextDrawSetShadow(Foodobj[8], 0);

    Foodobj[9] = TextDrawCreate(282.000000, 239.437500, "");
    TextDrawLetterSize(Foodobj[9], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[9], 58.000000, 66.000000);
    TextDrawAlignment(Foodobj[9], 1);
    TextDrawColor(Foodobj[9], -1);
    TextDrawSetShadow(Foodobj[9], 0);
    TextDrawSetOutline(Foodobj[9], 0);
    TextDrawBackgroundColor(Foodobj[9], 0);
    TextDrawFont(Foodobj[9], 5);
    TextDrawSetProportional(Foodobj[9], 0);
    TextDrawSetShadow(Foodobj[9], 0);
    TextDrawSetSelectable(Foodobj[9], true);
    TextDrawSetPreviewModel(Foodobj[9], 2647);
    TextDrawSetPreviewRot(Foodobj[9], 0.000000, 0.000000, 270.000000, 1.000000);

    Foodobj[10] = TextDrawCreate(300.000000, 294.562500, "COLA~n~~g~");
    TextDrawLetterSize(Foodobj[10], 0.282500, 0.865000);
    TextDrawAlignment(Foodobj[10], 1);
    TextDrawColor(Foodobj[10], -1);
    TextDrawSetShadow(Foodobj[10], 0);
    TextDrawSetOutline(Foodobj[10], 0);
    TextDrawBackgroundColor(Foodobj[10], 255);
    TextDrawFont(Foodobj[10], 2);
    TextDrawSetProportional(Foodobj[10], 1);
    TextDrawSetShadow(Foodobj[10], 0);

    Foodobj[11] = TextDrawCreate(360.000000, 213.625000, "");
    TextDrawLetterSize(Foodobj[11], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[11], 58.000000, 66.000000);
    TextDrawAlignment(Foodobj[11], 1);
    TextDrawColor(Foodobj[11], -1);
    TextDrawSetShadow(Foodobj[11], 0);
    TextDrawSetOutline(Foodobj[11], 0);
    TextDrawBackgroundColor(Foodobj[11], 0);
    TextDrawFont(Foodobj[11], 5);
    TextDrawSetProportional(Foodobj[11], 0);
    TextDrawSetShadow(Foodobj[11], 0);
    TextDrawSetSelectable(Foodobj[11], true);
    TextDrawSetPreviewModel(Foodobj[11], 2880);
    TextDrawSetPreviewRot(Foodobj[11], 180.000000, 90.000000, 360.000000, 1.000000);

    Foodobj[12] = TextDrawCreate(374.500000, 249.500000, "BURGER~n~~g~");
    TextDrawLetterSize(Foodobj[12], 0.282500, 0.865000);
    TextDrawAlignment(Foodobj[12], 1);
    TextDrawColor(Foodobj[12], -1);
    TextDrawSetShadow(Foodobj[12], 0);
    TextDrawSetOutline(Foodobj[12], 0);
    TextDrawBackgroundColor(Foodobj[12], 255);
    TextDrawFont(Foodobj[12], 2);
    TextDrawSetProportional(Foodobj[12], 1);
    TextDrawSetShadow(Foodobj[12], 0);

    Foodobj[13] = TextDrawCreate(292.500000, 95.500000, "");
    TextDrawLetterSize(Foodobj[13], 0.000000, 0.000000);
    TextDrawTextSize(Foodobj[13], 165.000000, 125.000000);
    TextDrawAlignment(Foodobj[13], 1);
    TextDrawColor(Foodobj[13], -1);
    TextDrawSetShadow(Foodobj[13], 0);
    TextDrawSetOutline(Foodobj[13], 0);
    TextDrawBackgroundColor(Foodobj[13], 0);
    TextDrawFont(Foodobj[13], 5);
    TextDrawSetProportional(Foodobj[13], 0);
    TextDrawSetShadow(Foodobj[13], 0);
    TextDrawSetSelectable(Foodobj[13], true);
    TextDrawSetPreviewModel(Foodobj[13], 2769);
    TextDrawSetPreviewRot(Foodobj[13], 0.000000, 60.000000, 90.000000, 1.000000);

    Foodobj[14] = TextDrawCreate(364.000000, 192.625000, "Hot-dog~n~~g~");
    TextDrawLetterSize(Foodobj[14], 0.282500, 0.865000);
    TextDrawAlignment(Foodobj[14], 1);
    TextDrawColor(Foodobj[14], -1);
    TextDrawSetShadow(Foodobj[14], 0);
    TextDrawSetOutline(Foodobj[14], 0);
    TextDrawBackgroundColor(Foodobj[14], 255);
    TextDrawFont(Foodobj[14], 2);
    TextDrawSetProportional(Foodobj[14], 1);
    TextDrawSetShadow(Foodobj[14], 0);
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:Foods) {
        DestroyDynamicActor(FoodInfo[i][fActorID]);
        DestroyDynamicMapIcon(FoodInfo[i][FAMapIconID]);
        DestroyDynamicObjectEx(FoodInfo[i][oid]);
    }
    for (new o = 0; o < 15; o++) {
        TextDrawDestroy(Foodobj[o]);
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EnablePlayerCameraTarget(playerid, true);
    SetPVarInt(playerid, "FOOD_SYSTEM_EDITING_ID", -1);
    return 1;
}

stock FoodStall:Reset(foodid) {
    if (!FoodStall:IsValidID(foodid)) return 1;
    format(FoodInfo[foodid][ftext], 50, "-");
    FoodInfo[foodid][FoodPrice] = Random(500000, 1000000);
    FoodInfo[foodid][FoodBalance] = 0;
    FoodInfo[foodid][FoodLastAccessAt] = gettime();
    FoodInfo[foodid][FoodPurchasedAt] = gettime();
    FoodInfo[foodid][FoodPIZZA_PRICE] = 100;
    FoodInfo[foodid][FoodFRIES_PRICE] = 100;
    FoodInfo[foodid][FoodCOLA_PRICE] = 100;
    FoodInfo[foodid][FoodBURGER_PRICE] = 100;
    FoodInfo[foodid][FoodHOTDOG_PRICE] = 100;
    FoodInfo[foodid][FoodResourceStorageWater] = 0;
    FoodInfo[foodid][FoodResourceStorageCorn] = 0;
    FoodInfo[foodid][FoodResourceStorageWheat] = 0;
    FoodInfo[foodid][FoodResourceStorageOnion] = 0;
    FoodInfo[foodid][FoodResourceStoragePotato] = 0;
    FoodInfo[foodid][FoodResourceStorageGarlic] = 0;
    FoodInfo[foodid][FoodResourceStorageVinegar] = 0;
    FoodInfo[foodid][FoodResourceStorageTomato] = 0;
    FoodInfo[foodid][FoodResourceStorageRice] = 0;
    FoodInfo[foodid][FoodResourceStorageMeet] = 0;
    FoodInfo[foodid][FoodResourceStorageMilk] = 0;
    FoodInfo[foodid][FoodResourceStorageCheese] = 0;
    FoodInfo[foodid][FoodResourceStorageEgg] = 0;
    FoodStall:UpdateText(foodid);
    return 1;
}

stock FoodStall:Remove(foodid) {
    DestroyDynamicObjectEx(FoodInfo[foodid][oid]);
    DestroyDynamicMapIcon(FoodInfo[foodid][FAMapIconID]);
    DestroyDynamic3DTextLabel(FoodInfo[foodid][textid]);
    DestroyDynamic3DTextLabel(FoodInfo[foodid][truckerTextId]);
    DestroyDynamicPickup(FoodInfo[foodid][truckerObjectId]);
    DestroyDynamicActor(FoodInfo[foodid][fActorID]);
    mysql_tquery(Database, sprintf("delete from foodStalls where id = %d", foodid));
    Iter_Remove(Foods, foodid);
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == Text:INVALID_TEXT_DRAW) //if escape button is pressed
    {
        if (Isviewingobj[playerid] == true) {
            HidefoodTD(playerid);
            Isviewingobj[playerid] = false;
        }
    }
    if (clickedid == Foodobj[5]) {
        new foodid = FoodStall:GetNearestStallID(playerid);
        if (foodid == -1) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You have gone too far from food stall"); return ~1; }
        if (!FoodStall:IsHaveResourceForPizza(foodid)) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} This food is unavailable right now, come back later."); return ~1; }
        if (GetPlayerCash(playerid) < FoodStall:GetPizzaPrice(foodid)) return SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You don't have money to buy that food");
        GivePlayerCash(playerid, -FoodStall:GetPizzaPrice(foodid), sprintf("Food[%d]:charged for pizza", foodid));
        FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) + FoodStall:GetPizzaPrice(foodid), sprintf("%s purchased pizza", GetPlayerNameEx(playerid)));
        FoodStall:DeductResourceForPizza(foodid);

        SetPlayerArmedWeapon(playerid, 0);
        HidefoodTD(playerid);

        new actorid = GetPlayerCameraTargetDynActor(playerid);
        ApplyDynamicActorAnimation(actorid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        FoodActionPizza(playerid);
        return ~1;
    }
    if (clickedid == Foodobj[7]) {
        new foodid = FoodStall:GetNearestStallID(playerid);
        if (foodid == -1) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You have gone too far from food stall"); return ~1; }
        if (!FoodStall:IsHaveResourceForFries(foodid)) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} This food is unavailable right now, come back later."); return ~1; }
        if (GetPlayerCash(playerid) < FoodStall:GetFriesPrice(foodid)) return SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You don't have money to buy that food");
        GivePlayerCash(playerid, -FoodStall:GetFriesPrice(foodid), sprintf("Food[%d]:charged for fries", foodid));
        FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) + FoodStall:GetFriesPrice(foodid), sprintf("%s purchased fries", GetPlayerNameEx(playerid)));
        FoodStall:DeductResourceForFries(foodid);
        SetPlayerArmedWeapon(playerid, 0);
        HidefoodTD(playerid);
        new actorid = GetPlayerCameraTargetDynActor(playerid);
        ApplyDynamicActorAnimation(actorid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
        FoodActionFries(playerid);
        return ~1;
    }
    if (clickedid == Foodobj[9]) {
        new foodid = FoodStall:GetNearestStallID(playerid);
        if (foodid == -1) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You have gone too far from food stall"); return ~1; }
        if (!FoodStall:IsHaveResourceForCola(foodid)) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} This food is unavailable right now, come back later."); return ~1; }
        if (GetPlayerCash(playerid) < FoodStall:GetColaPrice(foodid)) return SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You don't have money to buy that food");
        GivePlayerCash(playerid, -FoodStall:GetColaPrice(foodid), sprintf("Food[%d]:charged for cola", foodid));
        FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) + FoodStall:GetColaPrice(foodid), sprintf("%s purchased cola", GetPlayerNameEx(playerid)));
        FoodStall:DeductResourceForCola(foodid);
        SetPlayerArmedWeapon(playerid, 0);
        CallDrinkWater(playerid);
        HidefoodTD(playerid);

        new actorid = GetPlayerCameraTargetDynActor(playerid);
        ApplyDynamicActorAnimation(actorid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
        FoodActionCola(playerid);
        return ~1;
    }
    if (clickedid == Foodobj[11]) {
        new foodid = FoodStall:GetNearestStallID(playerid);
        if (foodid == -1) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You have gone too far from food stall"); return ~1; }
        if (!FoodStall:IsHaveResourceForBurger(foodid)) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} This food is unavailable right now, come back later."); return ~1; }
        if (GetPlayerCash(playerid) < FoodStall:GetBurgerPrice(foodid)) return SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You don't have money to buy that food");
        GivePlayerCash(playerid, -FoodStall:GetBurgerPrice(foodid), sprintf("Food[%d]:charged for burger", foodid));
        FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) + FoodStall:GetBurgerPrice(foodid), sprintf("%s purchased burger", GetPlayerNameEx(playerid)));
        FoodStall:DeductResourceForBurger(foodid);
        SetPlayerArmedWeapon(playerid, 0);
        HidefoodTD(playerid);

        new actorid = GetPlayerCameraTargetDynActor(playerid);
        ApplyDynamicActorAnimation(actorid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        FoodActionBurger(playerid);
        return ~1;
    }
    if (clickedid == Foodobj[13]) {
        new foodid = FoodStall:GetNearestStallID(playerid);
        if (foodid == -1) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You have gone too far from food stall"); return ~1; }
        if (!FoodStall:IsHaveResourceForHotDog(foodid)) { SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} This food is unavailable right now, come back later."); return ~1; }
        if (GetPlayerCash(playerid) < FoodStall:GetHotDogPrice(foodid)) return SendClientMessageEx(playerid, 0xFF0000FF, "[Error]{FFFFFF} You don't have money to buy that food");
        GivePlayerCash(playerid, -FoodStall:GetHotDogPrice(foodid), sprintf("Food[%d]:charged for hot dog", foodid));
        FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) + FoodStall:GetHotDogPrice(foodid), sprintf("%s purchased hot dog", GetPlayerNameEx(playerid)));
        FoodStall:DeductResourceForHotDog(foodid);
        HidefoodTD(playerid);

        new actorid = GetPlayerCameraTargetDynActor(playerid);
        ApplyDynamicActorAnimation(actorid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

        FoodActionHotDog(playerid);
        return ~1;
    }
    return 1;
}

stock CallPlayerFoodEat(playerid) {
    CallRemoteFunction("OnPlayerEatFood", "d", playerid);
    return 1;
}

stock FoodActionPizza(playerid) {
    new freeindex = FindFreeObjectSlot(playerid);
    SetPlayerAttachedObject(playerid, freeindex, 2702, 6, 0.138999, 0.046999, 0.021999, 0.000000, -7.300000, -90.100006, 1.000000, 1.000000, 1.000000);
    ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("RemoveObject", 3000, false, "dd", playerid, freeindex);
    return 1;
}

stock FoodActionHotDog(playerid) {
    new freeindex = FindFreeObjectSlot(playerid);
    SetPlayerAttachedObject(playerid, freeindex, 2769, 6, 0.109999, 0.034999, 0.009000, 11.599999, 0.000000, -12.899994, 1.000000, 1.000000, 1.000000);
    ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("RemoveObject", 3000, false, "dd", playerid, freeindex);
    return 1;
}

stock FoodActionFries(playerid) {
    new freeindex = FindFreeObjectSlot(playerid);
    SetPlayerAttachedObject(playerid, freeindex, 2858, 6, 0.127000, 0.005999, 0.019999, 0.000000, -97.199974, 0.000000, 0.243000, 0.248000, 0.934000);
    ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("RemoveObject", 3000, false, "dd", playerid, freeindex);
    return 1;
}

stock FoodActionCola(playerid) {
    new freeindex = FindFreeObjectSlot(playerid);
    SetPlayerAttachedObject(playerid, freeindex, 2647, 5, 0.147000, 0.036000, -0.009999, -45.299995, -95.299987, 0.000000, 0.715999, 0.839999, 0.786000);
    ApplyAnimation(playerid, "VENDING", "VEND_Drink_P", 4.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("RemoveObject", 3000, false, "dd", playerid, freeindex);
    return 1;
}

stock FoodActionBurger(playerid) {
    new freeindex = FindFreeObjectSlot(playerid);
    SetPlayerAttachedObject(playerid, freeindex, 2880, 6, 0.111999, 0.178000, 0.007999, 0.000000, 0.000000, -157.000045, 1.000000, 1.000000, 1.000000);
    ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("RemoveObject", 3000, false, "dd", playerid, freeindex);
    return 1;
}

forward OnPlayerEatFood(playerid);
public OnPlayerEatFood(playerid) {
    new Float:h;
    GetPlayerHealth(playerid, h);
    if (h < 100 && h >= 89) SetPlayerHealthEx(playerid, 100);
    if (h < 89) SetPlayerHealthEx(playerid, h + Random(12, 22));
    return 1;
}

forward RemoveObject(playerid, indexid);
public RemoveObject(playerid, indexid) {
    RemovePlayerAttachedObject(playerid, indexid);
    ClearAnimations(playerid);
    CallPlayerFoodEat(playerid);
    return 1;
}

stock ShowfoodTD(playerid) {
    new foodid = FoodStall:GetNearestStallID(playerid);
    if (foodid == -1) return 1;
    for (new i = 0; i < 15; i++) TextDrawShowForPlayer(playerid, Foodobj[i]);
    SelectTextDraw(playerid, 0x00FF00FF);
    return 1;
}
stock HidefoodTD(playerid) {
    for (new i = 0; i < 15; i++) TextDrawHideForPlayer(playerid, Foodobj[i]);
    CancelSelectTextDraw(playerid);
    return 1;
}

stock GetXYInFrontOfActor(actorid, & Float:x, & Float:y, Float:distance) {
    new Float:a;
    GetDynamicActorPos(actorid, x, y, a);
    GetActorFacingAngle(actorid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
    return 1;
}

stock FindFreeObjectSlot(playerid) {
    new objid;
    for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) {
        if (IsPlayerAttachedObjectSlotUsed(playerid, i)) continue;
        objid = i;
    }
    return objid;
}

stock IsPlayerNearFood(playerid) {
    foreach(new foodid:Foods) {
        if (IsPlayerInRangeOfPoint(playerid, 3, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ])) return 1;
    }
    return 0;
}

stock FoodStall:GetNearestStallID(playerid, Float:range = 3.0) {
    foreach(new foodid:Foods) {
        if (IsPlayerInRangeOfPoint(playerid, range, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ]) && GetPlayerInteriorID(playerid) == FoodInfo[foodid][food_interior] && GetPlayerVirtualWorldID(playerid) == FoodInfo[foodid][food_virtualworld]) return foodid;
    }
    return -1;
}

stock FoodStall:GetNearestStallTruckerID(playerid, Float:range = 3.0) {
    foreach(new foodid:Foods) {
        if (IsPlayerInRangeOfPoint(playerid, range, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ]) && GetPlayerInteriorID(playerid) == FoodInfo[foodid][FoodTruckerInt] && GetPlayerVirtualWorldID(playerid) == FoodInfo[foodid][FoodTruckerVirtualWorld]) return foodid;
    }
    return -1;
}

stock FoodStall:OrderMenu(playerid) {
    if (Isviewingobj[playerid] == false) {
        ShowfoodTD(playerid);
        Isviewingobj[playerid] = true;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    new foodid = FoodStall:GetNearestStallID(playerid);
    if (newkeys == KEY_NO && foodid != -1 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if (!FoodStall:IsPurchased(foodid)) {
            FlexPlayerDialog(playerid, "FoodStallOffer", DIALOG_STYLE_LIST, "Food Stall", "Order Menu\nPurchase Stall", "Select", "Close", foodid);
            return ~1;
        }
        if (IsStringSame(GetPlayerNameEx(playerid), FoodStall:GetOwner(foodid))) {
            FoodStall:ShowMenuOwner(playerid, foodid);
            return ~1;
        }
        FoodStall:OrderMenu(playerid);
        return ~1;
    }
    return 1;
}

FlexDialog:FoodStallOffer(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Order Menu")) {
        FoodStall:OrderMenu(playerid);
    }
    if (IsStringSame(inputtext, "Purchase Stall")) {
        FoodStall:ShowMenuPurchase(playerid, foodid);
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    foreach(new foodid:Foods) {
        if (IsStringSame(OldName, FoodInfo[foodid][ftext])) {
            format(FoodInfo[foodid][ftext], 50, "%s", NewName);
            FoodStall:UpdateText(foodid);
        }
    }
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    foreach(new foodid:Foods) {
        if (IsStringSame(AccountName, FoodInfo[foodid][ftext])) {
            FoodStall:Reset(foodid);
            FoodStall:UpdateText(foodid);
        }
    }
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    new foodid = GetPVarInt(playerid, "FOOD_SYSTEM_EDITING_ID");
    if (!FoodStall:IsValidID(foodid) || objectid != FoodInfo[foodid][oid]) return 1;

    if (response == EDIT_RESPONSE_UPDATE) {
        // to update it so others may see it.
        SetDynamicObjectPos(objectid, x, y, z);
        SetDynamicObjectRot(objectid, rx, ry, rz);
    }

    if (response == EDIT_RESPONSE_FINAL) {
        FoodInfo[foodid][ObjPosX] = x;
        FoodInfo[foodid][ObjPosY] = y;
        FoodInfo[foodid][ObjPosZ] = z;

        FoodInfo[foodid][ObjRotX] = rx;
        FoodInfo[foodid][ObjRotY] = ry;
        FoodInfo[foodid][ObjRotZ] = rz;
        SetDynamicObjectPos(objectid, x, y, z);
        SetDynamicObjectRot(objectid, rx, ry, rz);
        FoodStall:Resetlabels(foodid);
        FoodStall:UpdateText(foodid);
        FoodStall:Access(playerid, foodid);
        SetPVarInt(playerid, "FOOD_SYSTEM_EDITING_ID", -1);
    }
    return 1;
}

DTruck:OnInit(playerid, trailerid, page) {
    new foodid = FoodStall:GetNearestStallTruckerID(playerid, 20.0);
    if (FoodStall:IsValidID(foodid)) DTruck:AddCommand(playerid, "Access Food Stall Storage");
    return 1;
}

DTruck:OnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Access Food Stall Storage")) {
        new foodid = FoodStall:GetNearestStallTruckerID(playerid, 20.0);
        if (FoodStall:IsValidID(foodid)) {
            FoodStall:TrailerMenu(playerid, foodid, trailerid);
            return ~1;
        }
        return ~1;
    }
    return 1;
}

stock FoodStall:GetResourceByName(foodid, const foodName[]) {
    if (IsStringSame(foodName, "Water")) return FoodStall:GetResourceWater(foodid);
    if (IsStringSame(foodName, "Corn")) return FoodStall:GetResourceCorn(foodid);
    if (IsStringSame(foodName, "Wheat")) return FoodStall:GetResourceWheat(foodid);
    if (IsStringSame(foodName, "Onion")) return FoodStall:GetResourceOnion(foodid);
    if (IsStringSame(foodName, "Potato")) return FoodStall:GetResourcePotato(foodid);
    if (IsStringSame(foodName, "Garlic")) return FoodStall:GetResourceGarlic(foodid);
    if (IsStringSame(foodName, "Vinegar")) return FoodStall:GetResourceVinegar(foodid);
    if (IsStringSame(foodName, "Tomato")) return FoodStall:GetResourceTomato(foodid);
    if (IsStringSame(foodName, "Rice")) return FoodStall:GetResourceRice(foodid);
    if (IsStringSame(foodName, "Meet")) return FoodStall:GetResourceMeet(foodid);
    if (IsStringSame(foodName, "Milk")) return FoodStall:GetResourceMilk(foodid);
    if (IsStringSame(foodName, "Cheese")) return FoodStall:GetResourceCheese(foodid);
    if (IsStringSame(foodName, "Egg")) return FoodStall:GetResourceEgg(foodid);
    return 0;
}

stock FoodStall:UpdateResourceByName(foodid, const foodName[], amount) {
    if (IsStringSame(foodName, "Water")) return FoodStall:UpdateResourceWater(foodid, FoodStall:GetResourceWater(foodid) + amount);
    if (IsStringSame(foodName, "Corn")) return FoodStall:UpdateResourceCorn(foodid, FoodStall:GetResourceCorn(foodid) + amount);
    if (IsStringSame(foodName, "Wheat")) return FoodStall:UpdateResourceWheat(foodid, FoodStall:GetResourceWheat(foodid) + amount);
    if (IsStringSame(foodName, "Onion")) return FoodStall:UpdateResourceOnion(foodid, FoodStall:GetResourceOnion(foodid) + amount);
    if (IsStringSame(foodName, "Potato")) return FoodStall:UpdateResourcePotato(foodid, FoodStall:GetResourcePotato(foodid) + amount);
    if (IsStringSame(foodName, "Garlic")) return FoodStall:UpdateResourceGarlic(foodid, FoodStall:GetResourceGarlic(foodid) + amount);
    if (IsStringSame(foodName, "Vinegar")) return FoodStall:UpdateResourceVinegar(foodid, FoodStall:GetResourceVinegar(foodid) + amount);
    if (IsStringSame(foodName, "Tomato")) return FoodStall:UpdateResourceTomato(foodid, FoodStall:GetResourceTomato(foodid) + amount);
    if (IsStringSame(foodName, "Rice")) return FoodStall:UpdateResourceRice(foodid, FoodStall:GetResourceRice(foodid) + amount);
    if (IsStringSame(foodName, "Meet")) return FoodStall:UpdateResourceMeet(foodid, FoodStall:GetResourceMeet(foodid) + amount);
    if (IsStringSame(foodName, "Milk")) return FoodStall:UpdateResourceMilk(foodid, FoodStall:GetResourceMilk(foodid) + amount);
    if (IsStringSame(foodName, "Cheese")) return FoodStall:UpdateResourceCheese(foodid, FoodStall:GetResourceCheese(foodid) + amount);
    if (IsStringSame(foodName, "Egg")) return FoodStall:UpdateResourceEgg(foodid, FoodStall:GetResourceEgg(foodid) + amount);
    return 0;
}


stock FoodStall:GetTrailerResourceByName(trailerid, const foodName[]) {
    if (IsStringSame(foodName, "Water")) return TrailerStorage:GetResourceByName(trailerid, "Water");
    if (IsStringSame(foodName, "Corn")) return TrailerStorage:GetResourceByName(trailerid, "Corn");
    if (IsStringSame(foodName, "Wheat")) return TrailerStorage:GetResourceByName(trailerid, "Wheat");
    if (IsStringSame(foodName, "Onion")) return TrailerStorage:GetResourceByName(trailerid, "Onion");
    if (IsStringSame(foodName, "Potato")) return TrailerStorage:GetResourceByName(trailerid, "Potato");
    if (IsStringSame(foodName, "Garlic")) return TrailerStorage:GetResourceByName(trailerid, "Garlic");
    if (IsStringSame(foodName, "Vinegar")) return TrailerStorage:GetResourceByName(trailerid, "Vinegar");
    if (IsStringSame(foodName, "Tomato")) return TrailerStorage:GetResourceByName(trailerid, "Tomato");
    if (IsStringSame(foodName, "Rice")) return TrailerStorage:GetResourceByName(trailerid, "Rice");
    if (IsStringSame(foodName, "Meet")) return TrailerStorage:GetResourceByName(trailerid, "Meet");
    if (IsStringSame(foodName, "Milk")) return TrailerStorage:GetResourceByName(trailerid, "Milk");
    if (IsStringSame(foodName, "Cheese")) return TrailerStorage:GetResourceByName(trailerid, "Cheese");
    if (IsStringSame(foodName, "Egg")) return TrailerStorage:GetResourceByName(trailerid, "Egg");
    return 0;
}

stock FoodStall:UpdateTrailerResourceByName(trailerid, const foodName[], amount) {
    if (IsStringSame(foodName, "Water")) return TrailerStorage:IncreaseResourceByName(trailerid, "Water", amount);
    if (IsStringSame(foodName, "Corn")) return TrailerStorage:IncreaseResourceByName(trailerid, "Corn", amount);
    if (IsStringSame(foodName, "Wheat")) return TrailerStorage:IncreaseResourceByName(trailerid, "Wheat", amount);
    if (IsStringSame(foodName, "Onion")) return TrailerStorage:IncreaseResourceByName(trailerid, "Onion", amount);
    if (IsStringSame(foodName, "Potato")) return TrailerStorage:IncreaseResourceByName(trailerid, "Potato", amount);
    if (IsStringSame(foodName, "Garlic")) return TrailerStorage:IncreaseResourceByName(trailerid, "Garlic", amount);
    if (IsStringSame(foodName, "Vinegar")) return TrailerStorage:IncreaseResourceByName(trailerid, "Vinegar", amount);
    if (IsStringSame(foodName, "Tomato")) return TrailerStorage:IncreaseResourceByName(trailerid, "Tomato", amount);
    if (IsStringSame(foodName, "Rice")) return TrailerStorage:IncreaseResourceByName(trailerid, "Rice", amount);
    if (IsStringSame(foodName, "Meet")) return TrailerStorage:IncreaseResourceByName(trailerid, "Meet", amount);
    if (IsStringSame(foodName, "Milk")) return TrailerStorage:IncreaseResourceByName(trailerid, "Milk", amount);
    if (IsStringSame(foodName, "Cheese")) return TrailerStorage:IncreaseResourceByName(trailerid, "Cheese", amount);
    if (IsStringSame(foodName, "Egg")) return TrailerStorage:IncreaseResourceByName(trailerid, "Egg", amount);
    return 0;
}

stock FoodStall:TrailerMenu(playerid, foodid, trailerid) {
    new string[2000];
    strcat(string, "Resource\tIn Storage\tIn Trailer\n");
    strcat(string, sprintf("Water\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Water"), FoodStall:GetTrailerResourceByName(trailerid, "Water")));
    strcat(string, sprintf("Corn\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Corn"), FoodStall:GetTrailerResourceByName(trailerid, "Corn")));
    strcat(string, sprintf("Wheat\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Wheat"), FoodStall:GetTrailerResourceByName(trailerid, "Wheat")));
    strcat(string, sprintf("Onion\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Onion"), FoodStall:GetTrailerResourceByName(trailerid, "Onion")));
    strcat(string, sprintf("Potato\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Potato"), FoodStall:GetTrailerResourceByName(trailerid, "Potato")));
    strcat(string, sprintf("Garlic\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Garlic"), FoodStall:GetTrailerResourceByName(trailerid, "Garlic")));
    strcat(string, sprintf("Vinegar\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Vinegar"), FoodStall:GetTrailerResourceByName(trailerid, "Vinegar")));
    strcat(string, sprintf("Tomato\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Tomato"), FoodStall:GetTrailerResourceByName(trailerid, "Tomato")));
    strcat(string, sprintf("Rice\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Rice"), FoodStall:GetTrailerResourceByName(trailerid, "Rice")));
    strcat(string, sprintf("Meet\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Meet"), FoodStall:GetTrailerResourceByName(trailerid, "Meet")));
    strcat(string, sprintf("Milk\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Milk"), FoodStall:GetTrailerResourceByName(trailerid, "Milk")));
    strcat(string, sprintf("Cheese\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Cheese"), FoodStall:GetTrailerResourceByName(trailerid, "Cheese")));
    strcat(string, sprintf("Egg\t%d/KG\t%d/KG\n", FoodStall:GetResourceByName(foodid, "Egg"), FoodStall:GetTrailerResourceByName(trailerid, "Egg")));
    return FlexPlayerDialog(playerid, "FoodMenuTrailer", DIALOG_STYLE_TABLIST_HEADERS, "Food Stall Storage", string, "Select", "Close", foodid, sprintf("%d", trailerid));
}

FlexDialog:FoodMenuTrailer(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return 1;
    new amountInTrailer = FoodStall:GetTrailerResourceByName(trailerid, inputtext);
    if (amountInTrailer < 1) return FoodStall:TrailerMenu(playerid, foodid, trailerid);
    return FoodStall:ShowMenuTrailerInput(playerid, foodid, trailerid, inputtext);
}

stock FoodStall:ShowMenuTrailerInput(playerid, foodid, trailerid, const selectedFood[]) {
    new amountInTrailer = FoodStall:GetTrailerResourceByName(trailerid, selectedFood);
    return FlexPlayerDialog(playerid, "ShowMenuTrailerInput", DIALOG_STYLE_INPUT, "Unload Food",
        sprintf("Enter amount of %s to unload\nAvailable In Trailer: %dKG", selectedFood, amountInTrailer), "Unload", "Cancel",
        foodid, sprintf("%d,%s", trailerid, selectedFood)
    );
}

FlexDialog:ShowMenuTrailerInput(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    new trailerid, selectedFood[100];
    sscanf(payload, "p<,>ds[100]", trailerid, selectedFood);
    if (!response) return FoodStall:TrailerMenu(playerid, foodid, trailerid);
    new amountInTrailer = FoodStall:GetTrailerResourceByName(trailerid, selectedFood);
    new unloadamount;

    if (sscanf(inputtext, "d", unloadamount) || unloadamount < 1 || unloadamount > amountInTrailer) {
        return FoodStall:ShowMenuTrailerInput(playerid, foodid, trailerid, selectedFood);
    }

    new InFoodStallStorage = FoodStall:GetResourceByName(foodid, selectedFood);
    if (InFoodStallStorage + unloadamount > 1000) {
        AlexaMsg(playerid, "food stall does not have enough storage, please check storage before unloading.");
        return FoodStall:ShowMenuTrailerInput(playerid, foodid, trailerid, selectedFood);
    }

    FoodStall:UpdateResourceByName(foodid, selectedFood, unloadamount);
    FoodStall:UpdateTrailerResourceByName(trailerid, selectedFood, -unloadamount);

    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, sprintf("you have unloaded %dKG of %s into food stall [%d]", unloadamount, selectedFood, foodid));
    return FoodStall:TrailerMenu(playerid, foodid, trailerid);
}

stock FoodStall:ShowMenuPurchase(playerid, foodid) {
    AlexaMsg(playerid, "This food stall is available for purchase only", "Food Stall");
    new string[512];
    strcat(string, "Welcome, This food stall is the property of San Andreas Government\n");
    strcat(string, "you can purchase this food stall and also sale it to San Andreas Government\n");
    strcat(string, sprintf("you will be charged $%s for this purchase\n", FormatCurrency(FoodStall:GetPrice(foodid))));
    strcat(string, "press enter to confirm the purchase\n");
    return FlexPlayerDialog(playerid, "FoodMenuPurchase", DIALOG_STYLE_MSGBOX, "{4286f4}[Food Stall]:{FFFFEE}Purchase", string, "Yes", "No", foodid);
}

FlexDialog:FoodMenuPurchase(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return 1;
    if (FoodStall:GetTotal(playerid) > 0) return AlexaMsg(playerid, "maximum food stall limit reached, purchase vip for extra slots", "Food Stall");
    if (FoodStall:IsPurchased(foodid)) return AlexaMsg(playerid, "this food stall is already purchased", "Food Stall");
    if (GetPlayerCash(playerid) < FoodStall:GetPrice(foodid)) return AlexaMsg(playerid, "you don't have enough money to purchase this food stall", "Food Stall");
    vault:PlayerVault(
        playerid, -FoodStall:GetPrice(foodid), sprintf("purchased food stall [%d]", foodid),
        Vault_ID_Government, FoodStall:GetPrice(foodid), sprintf("sold food stall [%d] to %s", foodid, GetPlayerNameEx(playerid))
    );
    AddPlayerLog(
        playerid,
        sprintf("Purchased a food stall [%d] from the government for $%s", foodid, FormatCurrency(FoodStall:GetPrice(foodid))),
        "business"
    );
    new bal = FoodStall:GetBalance(foodid);
    if (bal > 0) {
        vault:addcash(Vault_ID_Government, bal, Vault_Transaction_Cash_To_Vault, sprintf("balance transfer, food stall purchased by %s", GetPlayerNameEx(playerid)));
        FoodStall:UpdateBalance(foodid, -bal, sprintf("transfer to SAGD vault on purchase by %s", GetPlayerNameEx(playerid)));
    }

    FoodInfo[foodid][FoodPIZZA_PRICE] = 100;
    FoodInfo[foodid][FoodFRIES_PRICE] = 100;
    FoodInfo[foodid][FoodCOLA_PRICE] = 100;
    FoodInfo[foodid][FoodBURGER_PRICE] = 100;
    FoodInfo[foodid][FoodHOTDOG_PRICE] = 100;
    FoodInfo[foodid][FoodResourceStorageWater] = 0;
    FoodInfo[foodid][FoodResourceStorageCorn] = 0;
    FoodInfo[foodid][FoodResourceStorageWheat] = 0;
    FoodInfo[foodid][FoodResourceStorageOnion] = 0;
    FoodInfo[foodid][FoodResourceStoragePotato] = 0;
    FoodInfo[foodid][FoodResourceStorageGarlic] = 0;
    FoodInfo[foodid][FoodResourceStorageVinegar] = 0;
    FoodInfo[foodid][FoodResourceStorageTomato] = 0;
    FoodInfo[foodid][FoodResourceStorageRice] = 0;
    FoodInfo[foodid][FoodResourceStorageMeet] = 0;
    FoodInfo[foodid][FoodResourceStorageMilk] = 0;
    FoodInfo[foodid][FoodResourceStorageCheese] = 0;
    FoodInfo[foodid][FoodResourceStorageEgg] = 0;
    FoodStall:UpdateLastAccess(foodid);
    FoodStall:SetOwner(foodid, GetPlayerNameEx(playerid));
    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, "you have purchased this food stall", "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:ShowMenuOwner(playerid, foodid) {
    FoodStall:UpdateLastAccess(foodid);
    FoodStall:UpdateText(foodid);
    new string[512];
    strcat(string, "Open Food Menu\n");
    strcat(string, "Manage Business\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Admin Panel\n");
    return FlexPlayerDialog(playerid, "ShowMenuOwner", DIALOG_STYLE_LIST, "Food Stall", string, "Select", "Close", foodid);
}

FlexDialog:ShowMenuOwner(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Open Food Menu")) return FoodStall:OrderMenu(playerid);
    if (IsStringSame(inputtext, "Manage Business")) return FoodStall:Access(playerid, foodid);
    if (IsStringSame(inputtext, "Admin Panel")) return FoodStall:AdminMenu(playerid);
    return 1;
}

stock FoodStall:Access(playerid, foodid) {
    new string[2000];
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(FoodStall:GetBalance(foodid))));
    strcat(string, sprintf("Pizza Price\t$%s\n", FormatCurrency(FoodStall:GetPizzaPrice(foodid))));
    strcat(string, sprintf("Fries Price\t$%s\n", FormatCurrency(FoodStall:GetFriesPrice(foodid))));
    strcat(string, sprintf("Cola Price\t$%s\n", FormatCurrency(FoodStall:GetColaPrice(foodid))));
    strcat(string, sprintf("Burger Price\t$%s\n", FormatCurrency(FoodStall:GetBurgerPrice(foodid))));
    strcat(string, sprintf("HotDog Price\t$%s\n", FormatCurrency(FoodStall:GetHotDogPrice(foodid))));
    strcat(string, sprintf("Storage of Water\t%d/KG\n", FoodStall:GetResourceWater(foodid)));
    strcat(string, sprintf("Storage of Corn\t%d/KG\n", FoodStall:GetResourceCorn(foodid)));
    strcat(string, sprintf("Storage of Wheat\t%d/KG\n", FoodStall:GetResourceWheat(foodid)));
    strcat(string, sprintf("Storage of Onion\t%d/KG\n", FoodStall:GetResourceOnion(foodid)));
    strcat(string, sprintf("Storage of Potato\t%d/KG\n", FoodStall:GetResourcePotato(foodid)));
    strcat(string, sprintf("Storage of Garlic\t%d/KG\n", FoodStall:GetResourceGarlic(foodid)));
    strcat(string, sprintf("Storage of Vinegar\t%d/KG\n", FoodStall:GetResourceVinegar(foodid)));
    strcat(string, sprintf("Storage of Tomato\t%d/KG\n", FoodStall:GetResourceTomato(foodid)));
    strcat(string, sprintf("Storage of Rice\t%d/KG\n", FoodStall:GetResourceRice(foodid)));
    strcat(string, sprintf("Storage of Meet\t%d/KG\n", FoodStall:GetResourceMeet(foodid)));
    strcat(string, sprintf("Storage of Milk\t%d/KG\n", FoodStall:GetResourceMilk(foodid)));
    strcat(string, sprintf("Storage of Cheese\t%d/KG\n", FoodStall:GetResourceCheese(foodid)));
    strcat(string, sprintf("Storage of Egg\t%d/KG\n", FoodStall:GetResourceEgg(foodid)));
    if (gettime() - FoodStall:GetPurchaseAt(foodid) > 24 * 60 * 60) {
        strcat(string, "Sell to friend\n");
        strcat(string, "Sell to Government\n");
    }
    if (GetPlayerAdminLevel(playerid) >= 8) {
        strcat(string, sprintf("Owner\t%s\n", FoodStall:GetOwner(foodid)));
        strcat(string, sprintf("Price\t$%s\n", FormatCurrency(FoodStall:GetPrice(foodid))));
        strcat(string, "Refill Stock\n");
        strcat(string, "Update Actor Skin\n");
        strcat(string, "Update Trucker Position\n");
        strcat(string, "Update Actor Position\n");
        strcat(string, "Update Stall Position\n");
        strcat(string, "Reset\n");
        strcat(string, "Remove\n");
    }
    return FlexPlayerDialog(playerid, "FoodStallMenuAccess", DIALOG_STYLE_TABLIST, "Food Stall", string, "Select", "Close", foodid);
}

FlexDialog:FoodStallMenuAccess(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Pizza Price")) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, "Pizza");
    if (IsStringSame(inputtext, "Fries Price")) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, "Fries");
    if (IsStringSame(inputtext, "Cola Price")) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, "Cola");
    if (IsStringSame(inputtext, "Burger Price")) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, "Burger");
    if (IsStringSame(inputtext, "HotDog Price")) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, "HotDog");
    if (IsStringSame(inputtext, "Balance")) return FoodStall:MenuWithdraw(playerid, foodid);
    if (gettime() - FoodStall:GetPurchaseAt(foodid) > 3 * 24 * 60 * 60) {
        if (IsStringSame(inputtext, "Sell to friend")) return FoodStall:SellToFriend(playerid, foodid);
        if (IsStringSame(inputtext, "Sell to Government")) return FoodStall:SellToSAGD(playerid, foodid);
    }
    if (IsStringSame(inputtext, "Owner")) return FoodStall:AdminMenuUpdateOwner(playerid, foodid);
    if (IsStringSame(inputtext, "Price")) return FoodStall:AdminMenuUpdatePrice(playerid, foodid);
    if (IsStringSame(inputtext, "Refill Stock")) return FoodStall:AdminMenuUpdateStock(playerid, foodid);
    if (IsStringSame(inputtext, "Update Trucker Position")) {
        new Float:x, Float:y, Float:z, Float:ang;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, ang);
        FoodInfo[foodid][FoodTruckerVirtualWorld] = GetPlayerVirtualWorld(playerid);
        FoodInfo[foodid][FoodTruckerInt] = GetPlayerInteriorID(playerid);
        FoodInfo[foodid][TruckerPosX] = x;
        FoodInfo[foodid][TruckerPosY] = y;
        FoodInfo[foodid][TruckerPosZ] = z;

        DestroyDynamic3DTextLabel(FoodInfo[foodid][truckerTextId]);
        FoodInfo[foodid][truckerTextId] = CreateDynamic3DTextLabel("food stall trucker point", -1, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, FoodInfo[foodid][FoodTruckerVirtualWorld], FoodInfo[foodid][FoodTruckerInt]);
        DestroyDynamicPickup(FoodInfo[foodid][truckerObjectId]);
        FoodInfo[foodid][truckerObjectId] = CreateDynamicPickup(19832, 23, FoodInfo[foodid][TruckerPosX], FoodInfo[foodid][TruckerPosY], FoodInfo[foodid][TruckerPosZ], FoodInfo[foodid][FoodTruckerVirtualWorld], FoodInfo[foodid][FoodTruckerInt]);

        AlexaMsg(playerid, "updated food stall trucker position");
        FoodStall:UpdateText(foodid);

        GetXYOnAnglePlayer(playerid, x, y, 2.0, 90);
        SetPlayerPosEx(playerid, x, y, z);
        return FoodStall:Access(playerid, foodid);
    }
    if (IsStringSame(inputtext, "Update Actor Position")) {
        new Float:x, Float:y, Float:z, Float:ang;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, ang);
        FoodInfo[foodid][food_virtualworld] = GetPlayerVirtualWorld(playerid);
        FoodInfo[foodid][food_interior] = GetPlayerInteriorID(playerid);
        FoodInfo[foodid][ActorX] = x;
        FoodInfo[foodid][ActorY] = y;
        FoodInfo[foodid][ActorZ] = z;
        DestroyDynamicActor(FoodInfo[foodid][fActorID]);
        FoodInfo[foodid][fActorID] = CreateDynamicActor(FoodInfo[foodid][fActorSkin], FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], FoodInfo[foodid][ActorRot], .worldid = FoodInfo[foodid][food_virtualworld], .interiorid = FoodInfo[foodid][food_interior]);
        DestroyDynamicMapIcon(FoodInfo[foodid][FAMapIconID]);
        FoodInfo[foodid][FAMapIconID] = CreateDynamicMapIcon(FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], 29, 5, FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
        AlexaMsg(playerid, "updated food stall position");
        FoodStall:UpdateText(foodid);

        GetXYOnAnglePlayer(playerid, x, y, 2.0, 90);
        SetPlayerPosEx(playerid, x, y, z);
        return FoodStall:Access(playerid, foodid);
    }
    if (IsStringSame(inputtext, "Update Actor Skin")) return FoodStall:AdminMenuUpdateSkin(playerid, foodid);
    if (IsStringSame(inputtext, "Update Stall Position")) {
        new nfoodid = FoodStall:GetNearestStallID(playerid, 20.0);
        if (foodid != nfoodid) {
            AlexaMsg(playerid, "you can update food stall location only when you are near to food stall");
            return FoodStall:Access(playerid, foodid);
        }
        SetPVarInt(playerid, "FOOD_SYSTEM_EDITING_ID", foodid);
        EditDynamicObject(playerid, FoodInfo[foodid][oid]);
        return 1;
    }
    if (IsStringSame(inputtext, "Reset")) {
        FoodStall:Reset(foodid);
        return FoodStall:Access(playerid, foodid);
    }
    if (IsStringSame(inputtext, "Remove")) {
        FoodStall:Remove(foodid);
        AlexaMsg(playerid, sprintf("removed food stall %d", foodid), "Food Stall");
        return FoodStall:AdminMenu(playerid);
    }
    return 1;
}

stock FoodStall:AdminMenuUpdateSkin(playerid, foodid) {
    new skins[] = { 161, 167, 168, 169, 171, 172 };
    new string[sizeof skins * 64];
    for (new i; i < sizeof skins; i++) format(string, sizeof string, "%s%i\tID:%i\n\n", string, skins[i], skins[i]);
    return FlexPlayerDialog(playerid, "AdminMenuUpdateSkin", DIALOG_STYLE_PREVIEW_MODEL, "Select Actor Skin", string, "Select", "Close", foodid);
}

FlexDialog:AdminMenuUpdateSkin(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new actorModelID = strval(inputtext);
    FoodInfo[foodid][fActorSkin] = actorModelID;
    DestroyDynamicActor(FoodInfo[foodid][fActorID]);
    FoodInfo[foodid][fActorID] = CreateDynamicActor(FoodInfo[foodid][fActorSkin], FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], FoodInfo[foodid][ActorRot], .worldid = FoodInfo[foodid][food_virtualworld], .interiorid = FoodInfo[foodid][food_interior]);
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:AdminMenuUpdateStock(playerid, foodid) {
    return FlexPlayerDialog(playerid, "AdminMenuUpdateStock", DIALOG_STYLE_INPUT, "Food Stall", "Enter new stock amount\nLimit: 1 to 1000", "Update", "Cancel", foodid);
}

FlexDialog:AdminMenuUpdateStock(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new newamount;
    if (sscanf(inputtext, "d", newamount) || newamount < 1 || newamount > 1000) return FoodStall:AdminMenuUpdateStock(playerid, foodid);

    FoodStall:UpdateResourceWater(foodid, newamount);
    FoodStall:UpdateResourceCorn(foodid, newamount);
    FoodStall:UpdateResourceWheat(foodid, newamount);
    FoodStall:UpdateResourceOnion(foodid, newamount);
    FoodStall:UpdateResourcePotato(foodid, newamount);
    FoodStall:UpdateResourceGarlic(foodid, newamount);
    FoodStall:UpdateResourceVinegar(foodid, newamount);
    FoodStall:UpdateResourceTomato(foodid, newamount);
    FoodStall:UpdateResourceRice(foodid, newamount);
    FoodStall:UpdateResourceMeet(foodid, newamount);
    FoodStall:UpdateResourceMilk(foodid, newamount);
    FoodStall:UpdateResourceCheese(foodid, newamount);
    FoodStall:UpdateResourceEgg(foodid, newamount);
    GameTextForPlayer(playerid, "~b~~h~Food Stall~r~ Resource Refilled!", 3000, 3);

    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, "updated food stall stocks", "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:AdminMenuUpdatePrice(playerid, foodid) {
    return FlexPlayerDialog(playerid, "AdminMenuUpdatePrice", DIALOG_STYLE_INPUT, "Food Stall", "Enter new selling price", "Update", "Cancel", foodid);
}

FlexDialog:AdminMenuUpdatePrice(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1) return FoodStall:AdminMenuUpdatePrice(playerid, foodid);
    FoodStall:SetPrice(foodid, newprice);
    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, sprintf("new food stall price is: $%s", FormatCurrency(newprice)), "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:AdminMenuUpdateOwner(playerid, foodid) {
    return FlexPlayerDialog(playerid, "AdminMenuUpdateOwner", DIALOG_STYLE_INPUT, "Food Stall", "Enter new owner name", "Update", "Cancel", foodid);
}

FlexDialog:AdminMenuUpdateOwner(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new newowner[100];
    if (sscanf(inputtext, "s[100]", newowner) || !IsValidAccount(newowner)) return FoodStall:AdminMenuUpdateOwner(playerid, foodid);
    FoodStall:SetOwner(foodid, newowner);
    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, sprintf("new food stall owner is: %s", newowner), "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:SellToFriend(playerid, foodid) {
    new string[1024];
    strcat(string, "Hi there, you are about to sell this food stall\n");
    strcat(string, "remember, there is no going back if you confirm this sell\n");
    strcat(string, "press enter nearby playerid to confirm the sell or esc to cancel\n");
    return FlexPlayerDialog(playerid, "SellToFriend", DIALOG_STYLE_INPUT, "Sell Food Stall", string, "Sell", "Cancel", foodid);
}

FlexDialog:SellToFriend(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new friendid;
    if (
        sscanf(inputtext, "u", friendid) ||
        !IsPlayerInRangeOfPlayer(playerid, friendid, 10.0) ||
        FoodStall:GetTotal(friendid) > 0
    ) {
        AlexaMsg(playerid, "Make sure your friend is close and does not own a food stall");
        return FoodStall:SellToFriend(playerid, foodid);
    }
    FoodStall:UpdatePurchaseAt(foodid);
    FoodStall:SetOwner(foodid, GetPlayerNameEx(friendid));
    FoodStall:UpdateText(foodid, true);
    return AlexaMsg(playerid, sprintf("%s owns your stall now.", GetPlayerNameEx(friendid)), "Food Stall");
}

stock FoodStall:SellToSAGD(playerid, foodid) {
    new string[1024];
    strcat(string, "Hi there, you are about to sell this food stall to San Andreas Government\n");
    strcat(string, "remember, there is no going back if you confirm this sell\n");
    strcat(string, "you will recieved on going market value of this food stall\n");
    strcat(string, "press enter to confirm the sell or esc to cancel\n");
    return FlexPlayerDialog(playerid, "SellToSAGD", DIALOG_STYLE_MSGBOX, "Sell Food Stall", string, "Sell", "Cancel", foodid);
}

FlexDialog:SellToSAGD(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new cash = GetPercentageOf(RandomEx(60, 80), FoodStall:GetPrice(foodid));
    if (cash > 0) {
        AddPlayerLog(
            playerid,
            sprintf("Sold a food stall [%d] from the government for $%s", foodid, FormatCurrency(cash)),
            "business"
        );
        vault:PlayerVault(
            playerid, cash, sprintf("sold food stall [%d] to government", foodid),
            Vault_ID_Government, -cash, sprintf("%s sold food stall [%d] to government", GetPlayerNameEx(playerid), foodid)
        );
        AlexaMsg(playerid, sprintf("you have recieved $%s from food stall sale", FormatCurrency(cash)), "Food Stall");
    }
    FoodStall:Reset(foodid);
    return AlexaMsg(playerid, "you have sold the food stall.", "Food Stall");
}

stock FoodStall:MenuWithdraw(playerid, foodid) {
    new balance = FoodStall:GetBalance(foodid);
    if (balance < 1) return FoodStall:Access(playerid, foodid);
    return FlexPlayerDialog(playerid, "FoodStallMenuWithdraw", DIALOG_STYLE_INPUT, "Food Stall: Withdraw",
        sprintf("Enter amount to withdraw\nLimit: $1 to $%s", FormatCurrency(balance)), "withdraw", "Cancel", foodid
    );
}

FlexDialog:FoodStallMenuWithdraw(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new balance = FoodStall:GetBalance(foodid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > balance) return FoodStall:MenuWithdraw(playerid, foodid);
    FoodStall:UpdateBalance(foodid, FoodStall:GetBalance(foodid) - amount, sprintf("%s withdrawl from food stall business", GetPlayerNameEx(playerid)));
    GivePlayerCash(playerid, amount, sprintf("withdrawl from food stall business [%d]", foodid));
    AlexaMsg(playerid, sprintf("you have withdrawl $%s from food stall business", FormatCurrency(amount)), "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:UpdateFoodPriceByName(foodid, const foodName[], amount) {
    if (IsStringSame(foodName, "Pizza")) return FoodStall:SetPizzaPrice(foodid, amount);
    if (IsStringSame(foodName, "Fries")) return FoodStall:SetFriesPrice(foodid, amount);
    if (IsStringSame(foodName, "Cola")) return FoodStall:SetColaPrice(foodid, amount);
    if (IsStringSame(foodName, "Burger")) return FoodStall:SetBurgerPrice(foodid, amount);
    if (IsStringSame(foodName, "HotDog")) return FoodStall:SetHotDogPrice(foodid, amount);
    return 1;
}

stock FoodStall:MenuUpdateFoodPrice(playerid, foodid, const selectedFood[]) {
    return FlexPlayerDialog(playerid, "MenuUpdateFoodPrice", DIALOG_STYLE_INPUT, "Food Stall",
        sprintf("Enter new selling price for %s\nLimit $1 to $500", selectedFood), "Update", "Close", foodid, selectedFood
    );
}

FlexDialog:MenuUpdateFoodPrice(playerid, response, listitem, const inputtext[], foodid, const selectedFood[]) {
    if (!response) return FoodStall:Access(playerid, foodid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1 || newprice > 500) return FoodStall:MenuUpdateFoodPrice(playerid, foodid, selectedFood);
    FoodStall:UpdateFoodPriceByName(foodid, selectedFood, newprice);
    FoodStall:UpdateText(foodid);
    AlexaMsg(playerid, sprintf("updated %s price to $%s", selectedFood, FormatCurrency(newprice)), "Food Stall");
    return FoodStall:Access(playerid, foodid);
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Food System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Food System", inputtext)) {
        FoodStall:AdminMenu(playerid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "food system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    FoodStall:AdminMenu(playerid);
    return ~1;
}

stock FoodStall:AdminMenu(playerid) {
    new string[1024];
    strcat(string, "Refill all Food Stall\n");
    strcat(string, "View All Food Stalls\n");
    strcat(string, "Manage Food Stall by ID\n");
    strcat(string, "Create Food Stall\n");
    return FlexPlayerDialog(playerid, "FoodMenuAdminMain", DIALOG_STYLE_LIST, "Food Stall", string, "Select", "Close");
}

FlexDialog:FoodMenuAdminMain(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Refill all Food Stall")) {
        foreach(new foodid:Foods) {
            FoodStall:UpdateResourceWater(foodid, 1000);
            FoodStall:UpdateResourceCorn(foodid, 1000);
            FoodStall:UpdateResourceWheat(foodid, 1000);
            FoodStall:UpdateResourceOnion(foodid, 1000);
            FoodStall:UpdateResourcePotato(foodid, 1000);
            FoodStall:UpdateResourceGarlic(foodid, 1000);
            FoodStall:UpdateResourceVinegar(foodid, 1000);
            FoodStall:UpdateResourceTomato(foodid, 1000);
            FoodStall:UpdateResourceRice(foodid, 1000);
            FoodStall:UpdateResourceMeet(foodid, 1000);
            FoodStall:UpdateResourceMilk(foodid, 1000);
            FoodStall:UpdateResourceCheese(foodid, 1000);
            FoodStall:UpdateResourceEgg(foodid, 1000);
            FoodStall:UpdateText(foodid);
        }

        GameTextForPlayer(playerid, "~b~~h~All Food Stall~r~ Resource Refilled!", 3000, 3);
        AlexaMsg(playerid, "updated food all stocks to 1000", "Food Stall");
        return 1;
    }
    if (IsStringSame(inputtext, "View All Food Stalls")) return FoodStall:ShowList(playerid);
    if (IsStringSame(inputtext, "Manage Food Stall by ID")) return FoodStall:AdminMenuByID(playerid);
    if (IsStringSame(inputtext, "Create Food Stall")) return FoodStall:ShowMenuCreateNew(playerid);
    return 1;
}

stock FoodStall:AdminMenuByID(playerid) {
    return FlexPlayerDialog(playerid, "AdminMenuByID", DIALOG_STYLE_INPUT, "Food Stall", "Enter food stall id", "Manage", "Close");
}

FlexDialog:AdminMenuByID(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FoodStall:AdminMenu(playerid);
    new foodid;
    if (sscanf(inputtext, "d", foodid) || !FoodStall:IsValidID(foodid)) return FoodStall:AdminMenuByID(playerid);
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:ShowMenuCreateNew(playerid) {
    new objects[] = { 956, 1340, 1342, 1776, 2219, 2221, 2355, 2814 };
    new string[sizeof objects * 64];
    for (new i; i < sizeof objects; i++) format(string, sizeof string, "%s%i\tID:%i\n\n", string, objects[i], objects[i]);
    new foodid = Iter_Free(Foods);
    if (foodid == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "maximum food stall limit reached, can not add more food stalls");
    return FlexPlayerDialog(playerid, "FoodMenuCreateNew", DIALOG_STYLE_PREVIEW_MODEL, "Select Object", string, "Select", "Close", foodid);
}

FlexDialog:FoodMenuCreateNew(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response) return FoodStall:AdminMenu(playerid);
    new skins[] = { 161, 167, 168, 169, 171, 172 };
    new string[sizeof skins * 64];
    for (new i; i < sizeof skins; i++) format(string, sizeof string, "%s%i\tID:%i\n\n", string, skins[i], skins[i]);
    return FlexPlayerDialog(
        playerid, "FoodMenuCreateNewActor", DIALOG_STYLE_PREVIEW_MODEL, "Select Actor Skin", string, "Select", "Close",
        foodid, sprintf("%d", strval(inputtext))
    );
}

FlexDialog:FoodMenuCreateNewActor(playerid, response, listitem, const inputtext[], foodid, const payload[]) {
    if (!response || FoodStall:IsValidID(foodid)) return FoodStall:ShowMenuCreateNew(playerid);
    new actorModelID = strval(inputtext);
    new modelid = strval(payload);

    // create
    Iter_Add(Foods, foodid);
    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);
    FoodInfo[foodid][food_virtualworld] = GetPlayerVirtualWorld(playerid);
    FoodInfo[foodid][food_interior] = GetPlayerInteriorID(playerid);

    // create actor
    FoodInfo[foodid][ActorX] = x;
    FoodInfo[foodid][ActorY] = y;
    FoodInfo[foodid][ActorZ] = z;
    FoodInfo[foodid][TruckerPosX] = x;
    FoodInfo[foodid][TruckerPosY] = y;
    FoodInfo[foodid][TruckerPosZ] = z;
    FoodInfo[foodid][fActorSkin] = actorModelID;
    FoodInfo[foodid][fActorID] = CreateDynamicActor(FoodInfo[foodid][fActorSkin], FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], FoodInfo[foodid][ActorRot], .worldid = FoodInfo[foodid][food_virtualworld], .interiorid = FoodInfo[foodid][food_interior]);
    FoodInfo[foodid][FAMapIconID] = CreateDynamicMapIcon(FoodInfo[foodid][ActorX], FoodInfo[foodid][ActorY], FoodInfo[foodid][ActorZ], 29, 5, FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);

    //create stall
    GetXYInFrontOfPlayer(playerid, x, y, 2.0);
    FoodInfo[foodid][ObjPosX] = x;
    FoodInfo[foodid][ObjPosY] = y;
    FoodInfo[foodid][ObjPosZ] = z;
    FoodInfo[foodid][fmodelid] = modelid;
    FoodInfo[foodid][oid] = CreateDynamicObject(FoodInfo[foodid][fmodelid], FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ], FoodInfo[foodid][ObjRotX], FoodInfo[foodid][ObjRotY], FoodInfo[foodid][ObjRotZ], FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);

    // initdata
    FoodInfo[foodid][FoodPrice] = Random(500000, 1000000);
    FoodInfo[foodid][FoodLastAccessAt] = gettime();
    FoodInfo[foodid][FoodPurchasedAt] = gettime();
    FoodInfo[foodid][FoodBalance] = 0;
    FoodInfo[foodid][FoodPIZZA_PRICE] = 100;
    FoodInfo[foodid][FoodFRIES_PRICE] = 100;
    FoodInfo[foodid][FoodCOLA_PRICE] = 100;
    FoodInfo[foodid][FoodBURGER_PRICE] = 100;
    FoodInfo[foodid][FoodHOTDOG_PRICE] = 100;
    FoodInfo[foodid][FoodResourceStorageWater] = 0;
    FoodInfo[foodid][FoodResourceStorageCorn] = 0;
    FoodInfo[foodid][FoodResourceStorageWheat] = 0;
    FoodInfo[foodid][FoodResourceStorageOnion] = 0;
    FoodInfo[foodid][FoodResourceStoragePotato] = 0;
    FoodInfo[foodid][FoodResourceStorageGarlic] = 0;
    FoodInfo[foodid][FoodResourceStorageVinegar] = 0;
    FoodInfo[foodid][FoodResourceStorageTomato] = 0;
    FoodInfo[foodid][FoodResourceStorageRice] = 0;
    FoodInfo[foodid][FoodResourceStorageMeet] = 0;
    FoodInfo[foodid][FoodResourceStorageMilk] = 0;
    FoodInfo[foodid][FoodResourceStorageCheese] = 0;
    FoodInfo[foodid][FoodResourceStorageEgg] = 0;
    FoodInfo[foodid][ActorRot] = ang;
    FoodInfo[foodid][FoodTruckerInt] = FoodInfo[foodid][food_interior];
    FoodInfo[foodid][FoodTruckerVirtualWorld] = FoodInfo[foodid][food_virtualworld];
    FoodStall:DatabaseInsert(foodid);

    AlexaMsg(playerid, sprintf("food id: %d created, don't forget to update it's location", foodid));
    GetXYOnAnglePlayer(playerid, x, y, 2.0, 90);
    SetPlayerPosEx(playerid, x, y, z);
    return FoodStall:Access(playerid, foodid);
}

stock FoodStall:ShowList(playerid, page = 0) {
    new total = Iter_Count(Foods);
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new string[2000];
    strcat(string, "ID\tOwner\tDistance - Location\tFood\n");
    new count = 0;
    foreach(new foodid:Foods) {
        if (skip > 0) {
            skip--;
            continue;
        }

        strcat(string, sprintf(
            "{FFFFFF}%d\t%s\t%.1f - %s\t%s\n",
            foodid, FoodStall:GetOwner(foodid),
            GetPlayerDistanceFromPoint(playerid, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ]),
            GetZoneName(FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ]),
            FoodStall:IsHaveResource(foodid) ? "{00FF00}YES" : "{FF0000}NO"
        ));

        count++;
        if (count >= perpage) break;
    }
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "FoodMenuShowList", DIALOG_STYLE_TABLIST_HEADERS, "Food Stall: List", string, "Select", "Close", page);
}

FlexDialog:FoodMenuShowList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) {
        return GPS:ShowMenu(playerid);
    }

    if (IsStringSame(inputtext, "Next Page")) return FoodStall:ShowList(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return FoodStall:ShowList(playerid, page - 1);
    new foodid = strval(inputtext);
    new string[512];
    strcat(string, "Turn on GPS\n");
    if (GetPlayerAdminLevel(playerid) > 8) {
        strcat(string, "Teleport Me\n");
        strcat(string, "Admin Panel\n");
    }

    FlexPlayerDialog(
        playerid, "FoodMenuShowListEx", DIALOG_STYLE_LIST, "Food Stall",
        string, "Select", "Close", foodid, sprintf("%d", page)
    );
    return 1;
}

FlexDialog:FoodMenuShowListEx(playerid, response, listitem, const inputtext[], foodid, const page[]) {
    if (!response) return FoodStall:ShowList(playerid, strval(page));

    if (IsStringSame(inputtext, "Teleport Me")) {
        TeleportPlayer(playerid, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ], FoodInfo[foodid][food_virtualworld], FoodInfo[foodid][food_interior]);
        AlexaMsg(playerid, "you are teleported to gps location");
    }

    if (IsStringSame(inputtext, "Turn on GPS")) {
        MarkGPS(playerid, FoodInfo[foodid][ObjPosX], FoodInfo[foodid][ObjPosY], FoodInfo[foodid][ObjPosZ]);
        AlexaMsg(playerid, "food stall location has been marked on your map");
    }

    if (IsStringSame(inputtext, "Admin Panel")) return FoodStall:Access(playerid, foodid);
    return 1;
}

// sync fix
hook Global15SecondInterval() {
    foreach(new foodid: Foods) {
        if (IsValidDynamicActor(FoodInfo[foodid][fActorID])) {
            SetDynamicActorPos(
                FoodInfo[foodid][fActorID],
                FoodInfo[foodid][ActorX],
                FoodInfo[foodid][ActorY],
                FoodInfo[foodid][ActorZ]
            );
        }
    }
    return 1;
}