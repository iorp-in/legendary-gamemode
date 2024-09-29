#define DYNAMIC_SHOP_RESET_DAYS 180
#define MAX_DYNAMIC_SHOPS 100
#define MAX_DYNAMIC_SHOPS_TYPES 18

new DynamicShopBusiness:dialogid;

enum {
    DynamicShopBusiness:offsetAdminMenu,
    DynamicShopBusiness:offsetAdminCreate,
    DynamicShopBusiness:offsetOwnerMenu,
    DynamicShopBusiness:offsetPurchase,
    DynamicShopBusiness:offsetAdminManage,
    DynamicShopBusiness:offsetAdminManageOp,
    DynamicShopBusiness:offsetOwnerOptions,
    DynamicShopBusiness:offsetWithdraw,
    DynamicShopBusiness:offsetUpName,
    DynamicShopBusiness:offsetSellconfirm,
    DynamicShopBusiness:offsetAdminUpdateOwner,
    DynamicShopBusiness:offsetAdminUpdatePrice
}

new DynamicShopBusiness:TypesName[MAX_DYNAMIC_SHOPS_TYPES][100] = {
    "Farming Resources",
    "Farming Seeds",
    "General Grocery (Water, Food)",
    "Materials",
    "Electronic",
    "Clinic",
    "Firework",
    "Weapons",
    "Sex Toy",
    "Clothes",
    "Light Motor Dealership",
    "Heavy Motor Dealership",
    "Two Wheeler Dealership",
    "Helicopter Dealership",
    "Plane Dealership",
    "Boat Dealership",
    "Clothes Accessories",
    "Handy Tools"
};

enum DynamicShopBusiness:enumdata {
    DynamicShopBusiness:owner[50],
        DynamicShopBusiness:name[50],
        DynamicShopBusiness:Price,
        DynamicShopBusiness:Balance,
        DynamicShopBusiness:LastAccessedAt,
        DynamicShopBusiness:PurchasedAt,
        DynamicShopBusiness:type,
        Float:DynamicShopBusiness:position[6],
        DynamicShopBusiness:int[2],
        DynamicShopBusiness:vw[2],
        bool:DynamicShopBusiness:lock,
        bool:DynamicShopBusiness:Allowedloading,
        bool:DynamicShopBusiness:AllowedUnloading,

        STREAMER_TAG_3D_TEXT_LABEL:DynamicShopBusiness:textid,
        STREAMER_TAG_3D_TEXT_LABEL:DynamicShopBusiness:truckertextid,
        DynamicShopBusiness:mapIcon,
        DynamicShopBusiness:truckerObj,
        DynamicShopBusiness:shopObj,
}
new DynamicShopBusiness:data[MAX_DYNAMIC_SHOPS][DynamicShopBusiness:enumdata];
new Iterator:dynbusiness < MAX_DYNAMIC_SHOPS > ;

stock DynamicShopBusiness:IsValidShopID(shopid) {
    return Iter_Contains(dynbusiness, shopid);
}

stock DynamicShopBusiness:GetNearestShopID(playerid, Float:range = 2.0) {
    foreach(new shopid:dynbusiness) {
        if (IsPlayerInRangeOfPoint(playerid, range, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2])) return shopid;
    }
    return -1;
}

stock DynamicShopBusiness:GetNearestTruckerID(playerid, Float:range = 2.0) {
    foreach(new shopid:dynbusiness) {
        if (IsPlayerInRangeOfPoint(playerid, range, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5])) return shopid;
    }
    return -1;
}

stock DynamicShopBusiness:IsPlayerOwner(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return IsStringSame(GetPlayerNameEx(playerid), DynamicShopBusiness:GetOwner(shopid));
}

stock DynamicShopBusiness:GetTotalPurchased(playerid) {
    new count = 0;
    foreach(new shopid:dynbusiness) {
        if (IsStringSame(GetPlayerNameEx(playerid), DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner])) count++;
    }
    return count;
}

stock DynamicShopBusiness:SetOwner(shopid, const name[]) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner], 50, "%s", name);
    return 1;
}

stock DynamicShopBusiness:SetPrice(shopid, newprice) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price] = newprice;
    return 1;
}

stock DynamicShopBusiness:GetPrice(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price];
}

stock DynamicShopBusiness:GetPurchasedAt(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt];
}

stock DynamicShopBusiness:UpdatePurchasedAt(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt] = gettime();
    return 1;
}

stock DynamicShopBusiness:GetOwner(shopid) {
    new string[100];
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return string;
    format(string, sizeof string, "%s", DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner]);
    return string;
}

stock DynamicShopBusiness:GetPlayerMaxLimit(playerid) {
    if (GetPlayerVIPLevel(playerid) == 3) return 3;
    if (GetPlayerVIPLevel(playerid) == 2) return 2;
    if (GetPlayerVIPLevel(playerid) == 1) return 1;
    return 1;
}

stock DynamicShopBusiness:GetName(shopid) {
    new string[100];
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return string;
    format(string, sizeof string, "%s", DynamicShopBusiness:data[shopid][DynamicShopBusiness:name]);
    return string;
}

stock DynamicShopBusiness:IsPurchased(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    return strcmp(DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner], "-");
}

stock DynamicShopBusiness:GetType(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:type];
}

stock DynamicShopBusiness:GetBalance(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance];
}

stock DynamicShopBusiness:SetBalance(shopid, amount, const log[]) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    mysql_tquery(Database, sprintf("insert into dynamicShopTransactions (shopid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        shopid, amount, DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance], log, gettime()));
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance] = amount;
    DynamicShopBusiness:Update3dText(shopid, "updating...");
    return 1;
}

stock DynamicShopBusiness:IncreaseBalance(shopid, amount, const log[]) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    mysql_tquery(Database, sprintf("insert into dynamicShopTransactions (shopid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        shopid, amount, DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance], log, gettime()));
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance] += amount;
    DynamicShopBusiness:Update3dText(shopid, "updating...");
    return 1;
}

stock DynamicShopBusiness:DecreaseBalance(shopid, amount, const log[]) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    mysql_tquery(Database, sprintf("insert into dynamicShopTransactions (shopid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        shopid, amount * -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance], log, gettime()));
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance] -= amount;
    DynamicShopBusiness:Update3dText(shopid, "updating...");
    return 1;
}

stock DynamicShopBusiness:IsLocked(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 1;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock];
}

stock DynamicShopBusiness:IsAllowedLoading(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading];
}

stock DynamicShopBusiness:IsAllowedUnLoading(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    return DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading];
}

stock DynamicShopBusiness:Remove(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    DestroyDynamic3DTextLabel(DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid]);
    DestroyDynamic3DTextLabel(DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid]);
    DestroyDynamicMapIcon(DynamicShopBusiness:data[shopid][DynamicShopBusiness:mapIcon]);
    DestroyDynamicPickup(DynamicShopBusiness:data[shopid][DynamicShopBusiness:shopObj]);
    DestroyDynamicPickup(DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckerObj]);
    Iter_Remove(dynbusiness, shopid);
    DynamicShopBusiness:DatabaseRemove(shopid);
    return 1;
}

stock DynamicShopBusiness:Reset(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:name], 50, "My Shop");
    format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner], 50, "-");
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price] = Random(500000, 1000000);
    DynamicShopBusiness:SetBalance(shopid, 0, "shop reset");
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt] = gettime();
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt] = gettime();
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock] = false;
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading] = false;
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading] = false;
    DynamicShopBusiness:Update3dText(shopid, "updating...");
    return 1;
}

stock DynamicShopBusiness:Update3dText(shopid, const text[], bool:databaseupdate = true) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    if (databaseupdate) DynamicShopBusiness:DatabaseUpdate(shopid);
    new tstring[1000];
    strcat(tstring, sprintf("{FFFF00}%s{FFFFFF} [%d]\n", DynamicShopBusiness:GetName(shopid), shopid));
    strcat(tstring, "{00FF00}Trucker Point\n");
    strcat(tstring, sprintf("{FF0000}Owner: {FFFFFF}%s\n", DynamicShopBusiness:IsPurchased(shopid) ? DynamicShopBusiness:GetOwner(shopid) : ("San Andreas Government Department"), shopid));
    strcat(tstring, sprintf("{FF0000}Status: %s{FFFFFF}\n", DynamicShopBusiness:IsLocked(shopid) ? ("{FF0000}Closed") : ("{00FF00}Open")));
    strcat(tstring, sprintf("{FFFF00}Loading Allowed: %s{FFFFFF}\n", DynamicShopBusiness:IsAllowedLoading(shopid) ? ("{00FF00}Yes") : ("{FF0000}No")));
    strcat(tstring, sprintf("{FFFF00}Unloading Allowed: %s{FFFFFF}\n", DynamicShopBusiness:IsAllowedUnLoading(shopid) ? ("{00FF00}Yes") : ("{FF0000}No")));
    strcat(tstring, "\n{FFFF00}use /p > access trailer to open menu");
    UpdateDynamic3DTextLabelText(DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid], -1, tstring);
    if (!DynamicShopBusiness:IsPurchased(shopid)) {
        new string[2000];
        strcat(string, sprintf("{FFFF00}%s{FFFFFF} [%d]\n", DynamicShopBusiness:GetName(shopid), shopid));
        strcat(string, sprintf("{FF0000}Type:{FFFFFF} %s\n", DynamicShopBusiness:TypesName[DynamicShopBusiness:GetType(shopid)]));
        strcat(string, "{FF0000}Property Of:{FFFFFF} San Andreas Goverment Department\n");
        strcat(string, sprintf("{FFFF00}On Sale\n{FF0000}Price: {00FF00}$%s\n", FormatCurrency(DynamicShopBusiness:GetPrice(shopid))));
        strcat(string, "\n{FFFF00}press N to purchase this business");
        UpdateDynamic3DTextLabelText(DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid], -1, string);
        return 1;
    }
    new string[2000];
    strcat(string, sprintf("{FFFF00}%s{FFFFFF} [%d]\n", DynamicShopBusiness:GetName(shopid), shopid));
    strcat(string, sprintf("{FF0000}Type:{FFFFFF} %s\n", DynamicShopBusiness:TypesName[DynamicShopBusiness:GetType(shopid)]));
    strcat(string, sprintf("{FF0000}Property {FFFFFF}Of: %s\n", DynamicShopBusiness:GetOwner(shopid)));
    strcat(string, sprintf("{FF0000}Owner Last Visited:{FFFFFF} %s\n", UnixToHumanEx(DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt])));
    strcat(string, sprintf("{FF0000}Status: %s{FFFFFF}\n", DynamicShopBusiness:IsLocked(shopid) ? ("{FF0000}Closed") : ("{00FF00}Open")));
    strcat(string, sprintf("%s", text));
    strcat(string, "\n{FFFF00}press N to open menu");
    UpdateDynamic3DTextLabelText(DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid], -1, string);
    return 1;
}

stock DynamicShopBusiness:DatabaseCreate(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    new query[2000];
    format(query, sizeof query, "insert into dynamicShop (shopid, shoptype, data) Values (%d, %d, '{}')", shopid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:type]);
    mysql_tquery(Database, query);
    return 1;
}

stock DynamicShopBusiness:DatabaseUpdate(shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    new query[2000];
    format(
        query, sizeof query, "update dynamicShop set owner = \"%s\", name = \"%s\",price = %d,balance = %d,\
        lastaccessedat = %d, PurchasedAt = %d, shoptype = %d,shoplock = %d,aloading = %d,aunloading = %d,\
        pos_0 = %f,pos_1 = %f,pos_2 = %f,pos_3 = %f,pos_4 = %f,pos_5 = %f,int_0 = %d,int_1 = %d,vw_0 = %d,\
        vw_1 = %d where shopid = %d",
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:name],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:type],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0],
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1],
        shopid
    );
    mysql_tquery(Database, query);
    return 1;
}

stock DynamicShopBusiness:DatabaseRemove(shopid) {
    mysql_tquery(Database, sprintf("Delete from `dynamicShop` where `shopid` = %d", shopid));
    return 1;
}

stock DynamicShopBusiness:DatabaseUpdateItem(shopid, const column[], newvalue) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    mysql_tquery(Database, sprintf("UPDATE `dynamicShop` SET data = JSON_MERGE_PATCH(data, '{\"%s\": %d}') WHERE `shopid` = %d LIMIT 1", column, newvalue, shopid));
    return 1;
}

stock DynamicShopBusiness:DatabaseGetItem(shopid, const column[], vdefault) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    new Cache:mysql_cache;
    mysql_cache = mysql_query(Database, sprintf(
        "select IFNULL(JSON_EXTRACT(data, '$.%s'), %d) as value from dynamicShop WHERE `shopid` = %d limit 1", column, vdefault, shopid
    ));
    new rows = cache_num_rows();
    new data;
    if (!rows) data = 0;
    else cache_get_value_name_int(0, "value", data);
    cache_delete(mysql_cache);
    return data;
}

stock DynamicShopBusiness:RequestUpdate(shopid, bool:databaseupdate = true) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    CallRemoteFunction("OnDyShopRequestUpdate", "db", shopid, databaseupdate);
    return 1;
}

forward OnDyShopRequestUpdate(shopid, bool:databaseupdate);
public OnDyShopRequestUpdate(shopid, bool:databaseupdate) {
    return 1;
}

stock DynamicShopBusiness:RequestShopMenu(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    CallRemoteFunction("OnDyShopRequestMenu", "dd", playerid, shopid);
    return 1;
}

forward OnDyShopRequestMenu(playerid, shopid);
public OnDyShopRequestMenu(playerid, shopid) {
    return 1;
}

stock DynamicShopBusiness:RequestUpdatePricing(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    CallRemoteFunction("OnDyShopRequestPriceU", "dd", playerid, shopid);
    return 1;
}

forward OnDyShopRequestPriceU(playerid, shopid);
public OnDyShopRequestPriceU(playerid, shopid) {
    return 1;
}

stock DynamicShopBusiness:RequestResetPricing(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    CallRemoteFunction("OnDyShopReqResetPrice", "dd", playerid, shopid);
    return 1;
}

forward OnDyShopReqResetPrice(playerid, shopid);
public OnDyShopReqResetPrice(playerid, shopid) {
    return 1;
}

stock DynamicShopBusiness:RequestTruckerMenu(playerid, trailerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    CallRemoteFunction("OnDyShopRequestTrucker", "ddd", playerid, trailerid, shopid);
    return 1;
}

forward OnDyShopRequestTrucker(playerid, trailerid, shopid);
public OnDyShopRequestTrucker(playerid, trailerid, shopid) {
    return 1;
}

DTruck:OnInit(playerid, trailerid, page) {
    if (page != 0) return 1;
    new shopid = DynamicShopBusiness:GetNearestTruckerID(playerid, 10.0);
    if (shopid != -1) DTruck:AddCommand(playerid, "Access Store Trucker Point");
    return 1;
}

DTruck:OnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Access Store Trucker Point", inputtext)) {
        new shopid = DynamicShopBusiness:GetNearestTruckerID(playerid, 10.0);
        if (shopid == -1) return ~1;
        DynamicShopBusiness:RequestTruckerMenu(playerid, trailerid, shopid);
        return ~1;
    }
    return 1;
}

stock DynamicShopBusiness:OwnerMenu(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt] = gettime();
    DynamicShopBusiness:RequestUpdate(shopid);
    new string[2000];
    strcat(string, "Open Shop Menu\n");
    strcat(string, "Manage Shop\n");
    ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetOwnerMenu, DIALOG_STYLE_LIST, "Your Business", string, "Select", "Close", shopid);
    return 1;
}

stock DynamicShopBusiness:AccessShop(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    new string[2000];
    strcat(string, sprintf("Name\t%s\n", DynamicShopBusiness:GetName(shopid)));
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(DynamicShopBusiness:GetBalance(shopid))));
    strcat(string, "Update Pricing\tMenu\n");
    strcat(string, "Reset Default Prices\n");
    if (!DynamicShopBusiness:IsLocked(shopid)) strcat(string, "Lock\tShop\n");
    if (DynamicShopBusiness:IsLocked(shopid)) strcat(string, "Unlock\tShop\n");
    if (!DynamicShopBusiness:IsAllowedLoading(shopid)) strcat(string, "Allow Trucker Loading\n");
    if (DynamicShopBusiness:IsAllowedLoading(shopid)) strcat(string, "Disable Trucker Loading\n");
    if (!DynamicShopBusiness:IsAllowedUnLoading(shopid)) strcat(string, "Allow Trucker Unloading\n");
    if (DynamicShopBusiness:IsAllowedUnLoading(shopid)) strcat(string, "Disable Trucker Unloading\n");
    if (DynamicShopBusiness:IsPurchased(shopid) && gettime() - DynamicShopBusiness:GetPurchasedAt(shopid) > 3 * 24 * 60 * 60) {
        strcat(string, "Sale To Friend\n");
        strcat(string, "Sale To Government\n");
    }
    ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetOwnerOptions, DIALOG_STYLE_TABLIST, "Your Business", string, "Select", "Close", shopid);
    return 1;
}

stock DynamicShopBusiness:AdminPanel(playerid) {
    new string[2000];
    strcat(string, "Create Business\n");
    strcat(string, "Manage Business\n");
    ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminMenu, DIALOG_STYLE_LIST, "Dynamic Business System", string, "Select", "Close");
    return 1;
}

stock DynamicShopBusiness:AdminManage(playerid, shopid) {
    if (!DynamicShopBusiness:IsValidShopID(shopid)) return 0;
    new string[2000];
    strcat(string, sprintf("Owner\t%s\n", DynamicShopBusiness:GetOwner(shopid)));
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(DynamicShopBusiness:GetBalance(shopid))));
    strcat(string, "Access\n");
    strcat(string, "Teleport\n");
    strcat(string, "Set Shop Price\n");
    strcat(string, "Refill Stocks\n");
    strcat(string, "Reset Stocks\n");
    strcat(string, "Update Coordinate\n");
    strcat(string, "Update Trucker Coordinate\n");
    strcat(string, "Reset\n");
    strcat(string, "Remove\n");
    ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminManageOp, DIALOG_STYLE_TABLIST, "Dynamic Business System", string, "Select", "Close", shopid);
    return 1;
}

forward LoadAllShopsData();
public LoadAllShopsData() {
    new rows = cache_num_rows();
    if (rows) {
        new i;
        while (i < rows) {
            new shopid;
            cache_get_value_name_int(i, "shopid", shopid);
            cache_get_value_name(i, "name", DynamicShopBusiness:data[shopid][DynamicShopBusiness:name], 50);
            cache_get_value_name(i, "owner", DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner], 50);
            cache_get_value_name_int(i, "price", DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price]);
            cache_get_value_name_int(i, "balance", DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance]);
            cache_get_value_name_int(i, "lastaccessedat", DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt]);
            cache_get_value_name_int(i, "PurchasedAt", DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt]);
            cache_get_value_name_int(i, "shoptype", DynamicShopBusiness:data[shopid][DynamicShopBusiness:type]);
            cache_get_value_name_int(i, "shoplock", DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock]);
            cache_get_value_name_int(i, "aloading", DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading]);
            cache_get_value_name_int(i, "aunloading", DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading]);
            cache_get_value_name_float(i, "pos_0", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0]);
            cache_get_value_name_float(i, "pos_1", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1]);
            cache_get_value_name_float(i, "pos_2", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2]);
            cache_get_value_name_float(i, "pos_3", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3]);
            cache_get_value_name_float(i, "pos_4", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4]);
            cache_get_value_name_float(i, "pos_5", DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5]);
            cache_get_value_name_int(i, "int_0", DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            cache_get_value_name_int(i, "int_1", DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1]);
            cache_get_value_name_int(i, "vw_0", DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0]);
            cache_get_value_name_int(i, "vw_1", DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1]);
            Iter_Add(dynbusiness, shopid);
            i++;
        }
        foreach(new shopid:dynbusiness) {
            DynamicShopBusiness:Create3dText(shopid);
            DynamicShopBusiness:RequestUpdate(shopid, false);
        }
        printf("  [Dnamic Shops] Loaded %d Dnamic Shops", i);
    }
    return 1;
}

stock DynamicShopBusiness:Create3dText(shopid) {
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid] = CreateDynamic3DTextLabel(sprintf("My Shop [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid] = CreateDynamic3DTextLabel(sprintf("Trucker Point [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1]);
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:mapIcon] = CreateDynamicMapIcon(DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 8, -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:shopObj] = CreateDynamicPickup(1210, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
    DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckerObj] = CreateDynamicPickup(19832, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
    return 1;
}

hook GlobalHourInterval() {
    foreach(new shopid:dynbusiness) {
        if (DynamicShopBusiness:IsPurchased(shopid)) {
            new beforeDay = 1;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new lastAccessedAt = DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt];
            new shopWillResetAt = lastAccessedAt + (DYNAMIC_SHOP_RESET_DAYS - beforeDay) * 86400;
            if (shopWillResetAt >= mintime && shopWillResetAt < maxtime) {
                if (!IsPlayerInServerByName(DynamicShopBusiness:GetOwner(shopid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, DynamicShopBusiness:GetOwner(shopid), sprintf("Shop %s [%d] will reset after 24 hours!!", DynamicShopBusiness:GetName(shopid), shopid),
                        sprintf("Shop %s [%d] will reset after 24 hours!! Your shop will be taken by government due to long inactivity and no visit in shop for long time. you can stop this reset by visiting your shop within 24 hours.", DynamicShopBusiness:GetName(shopid), shopid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Shop %s [%d]\n\
                Status: will reset within 24 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", DynamicShopBusiness:GetOwner(shopid), DynamicShopBusiness:GetName(shopid), shopid));
            }
        }
    }
    foreach(new shopid:dynbusiness) {
        if (DynamicShopBusiness:IsPurchased(shopid)) {
            new beforeDay = 2;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new lastAccessedAt = DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt];
            new shopWillResetAt = lastAccessedAt + (DYNAMIC_SHOP_RESET_DAYS - beforeDay) * 86400;
            if (shopWillResetAt >= mintime && shopWillResetAt < maxtime) {
                if (!IsPlayerInServerByName(DynamicShopBusiness:GetOwner(shopid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, DynamicShopBusiness:GetOwner(shopid), sprintf("Shop %s [%d] will reset after 48 hours!!",
                            DynamicShopBusiness:GetName(shopid), shopid),
                        sprintf("Shop %s [%d] will reset after 48 hours!! Your shop will be taken by government due to long inactivity and no visit in shop for long time.\
                         you can stop this reset by visiting your shop within 48 hours.", DynamicShopBusiness:GetName(shopid), shopid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Shop %s [%d]\n\
                Status: will reset within 48 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", DynamicShopBusiness:GetOwner(shopid), DynamicShopBusiness:GetName(shopid), shopid));
            }
        }
    }
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new shopid:dynbusiness) {
        if (!DynamicShopBusiness:IsPurchased(shopid)) continue;
        new lastAccessedAt = DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt];
        if (gettime() - lastAccessedAt > DYNAMIC_SHOP_RESET_DAYS * 86400) {
            if (!IsPlayerInServerByName(DynamicShopBusiness:GetOwner(shopid))) {
                Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, DynamicShopBusiness:GetOwner(shopid), sprintf("Shop %s [%d] has been auto reset!!", DynamicShopBusiness:GetName(shopid), shopid),
                    sprintf("Shop %s [%d] has been auto reset!! Your shop has been taken by government due to long inactivity and no visit in shop for long time.", DynamicShopBusiness:GetName(shopid), shopid));
            }
            Discord:SendNotification(sprintf("\
            **Property Auto Reset Alert**\n\
            ```\n\
            Owner: %s\n\
            Type: Shop %s [%d]\n\
            Status: reseted\n\
            Reason: due to owner not active\n\
            ```\
            ", DynamicShopBusiness:GetOwner(shopid), DynamicShopBusiness:GetName(shopid), shopid));
            DynamicShopBusiness:Reset(shopid);
        }
    }
    return 1;
}

hook OnGameModeInit() {
    DynamicShopBusiness:dialogid = Dialog:GetFreeID();
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS dynamicShop (shopid int not null default 0,owner varchar(50) not null default \"-\",name varchar(50) not null default \"My Shop\",price int not null default 1000,balance int not null default 0,lastaccessedat int not null default 0,shoptype int not null default 0,shoplock int not null default 0,aloading tinyint not null default 0,aunloading tinyint not null default 0,pos_0 float not null default 0.0,pos_1 float not null default 0.0,pos_2 float not null default 0.0,pos_3 float not null default 0.0,pos_4 float not null default 0.0,pos_5 float not null default 0.0,int_0 int not null default 0,int_1 int not null default 0,vw_0 int not null default 0,vw_1 int not null default 0, data JSON) Engine = MyISAM");
    mysql_tquery(Database, "select * from dynamicShop", "LoadAllShopsData", "");
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        new shopid = DynamicShopBusiness:GetNearestShopID(playerid);
        if (shopid != -1) {
            if (!DynamicShopBusiness:IsPurchased(shopid)) {
                DynamicShopBusiness:DirectMenu(playerid, shopid);
                return ~1;
            }
            if (DynamicShopBusiness:IsPlayerOwner(playerid, shopid)) {
                DynamicShopBusiness:OwnerMenu(playerid, shopid);
                return ~1;
            }
            DynamicShopBusiness:RequestShopMenu(playerid, shopid);
            return ~1;
        }
    }
    return 1;
}

stock DynamicShopBusiness:DirectMenu(playerid, shopid) {
    new string[512];
    strcat(string, "Order Menu\n");
    strcat(string, "Purchase Shop\n");
    FlexPlayerDialog(playerid, "BusinessDirect", DIALOG_STYLE_LIST, "Bussiness", string, "Select", "Close", shopid);
    return 1;
}

FlexDialog:BusinessDirect(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Order Menu")) {
        DynamicShopBusiness:RequestShopMenu(playerid, shopid);
        return 1;
    }
    if (IsStringSame(inputtext, "Purchase Shop")) {
        new string[512];
        strcat(string, "Welcome, This shop is the property of San Andreas Government\n");
        strcat(string, "you can purchase this shop and also sale it to San Andreas Government\n");
        strcat(string, sprintf("you will be charged $%s for this purchase\n", FormatCurrency(DynamicShopBusiness:GetPrice(shopid))));
        strcat(string, "press enter to confirm the purchase\n");
        ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetPurchase, DIALOG_STYLE_MSGBOX, "{4286f4}[Shop]:{FFFFEE}Purchase", string, "Yes", "No", shopid);
        return 1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerAdminLevel(playerid) >= 8 && IsStringContainWords(text, "business system")) {
        DynamicShopBusiness:AdminPanel(playerid);
        return ~1;
    }
    return 1;
}

forward RefillShopStock(playerid, shopid);
public RefillShopStock(playerid, shopid) {
    return 1;
}

forward ResetShopStock(playerid, shopid);
public ResetShopStock(playerid, shopid) {
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != DynamicShopBusiness:dialogid) return 1;
    if (offsetid == DynamicShopBusiness:offsetUpName) {
        if (!response) return ~1;
        new shopid = extraid;
        new newname[50];
        if (sscanf(inputtext, "s[50]", newname)) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetUpName, DIALOG_STYLE_INPUT, "{4286f4}[Shop]:{FFFFEE}Update Business Name", "Enter business name", "Update", "Cancel", shopid); return ~1; }
        format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:name], 50, "%s", RemoveMalChars(newname));
        DynamicShopBusiness:RequestUpdate(shopid);
        DynamicShopBusiness:AccessShop(playerid, shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetWithdraw) {
        if (!response) return ~1;
        new shopid = extraid;
        new amount;
        if (sscanf(inputtext, "d", amount) || amount < 100 || amount > DynamicShopBusiness:GetBalance(shopid)) {
            ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetWithdraw, DIALOG_STYLE_INPUT, "{4286f4}[Shop]:{FFFFEE}Withdraw Balance", sprintf("Enter Amount (Minimum 100) to withdraw\nBalance: %d", DynamicShopBusiness:GetBalance(shopid)), "Withdraw", "Cancel", shopid);
            return ~1;
        }
        new tax = GetPercentageOf(18, amount);
        new finalPayout = amount - tax;
        vault:addcash(Vault_ID_TAX, tax, Vault_Transaction_Cash_To_Vault, sprintf("%s payed tax for shop [%d]", GetPlayerNameEx(playerid), shopid));
        GivePlayerCash(playerid, finalPayout, sprintf("Withdrawl from shop [%d] (tax: %d)", shopid, tax));
        DynamicShopBusiness:DecreaseBalance(shopid, amount, sprintf("%s withdrawl from shop", GetPlayerNameEx(playerid)));
        DynamicShopBusiness:AccessShop(playerid, shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetOwnerOptions) {
        if (!response) return ~1;
        new shopid = extraid;
        if (IsStringSame(inputtext, "Name")) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetUpName, DIALOG_STYLE_INPUT, "{4286f4}[Shop]:{FFFFEE}Update Business Name", "Enter business name", "Update", "Cancel", shopid); return ~1; }
        if (IsStringSame(inputtext, "Balance")) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetWithdraw, DIALOG_STYLE_INPUT, "{4286f4}[Shop]:{FFFFEE}Withdraw Balance", sprintf("Enter Amount to withdraw\nBalance: %d", DynamicShopBusiness:GetBalance(shopid)), "Withdraw", "Cancel", shopid); return ~1; }
        if (IsStringSame(inputtext, "Update Pricing")) {
            DynamicShopBusiness:RequestUpdatePricing(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Reset Default Prices")) {
            DynamicShopBusiness:RequestResetPricing(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Lock")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock] = true;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Unlock")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock] = false;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Allow Trucker Loading")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading] = true;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Disable Trucker Loading")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading] = false;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Allow Trucker Unloading")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading] = true;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Disable Trucker Unloading")) {
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading] = false;
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Sale To Friend")) {
            DynamicShopBusiness:SaleToFriendMenu(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Sale To Government")) {
            new string[512];
            strcat(string, "Hi there, you are about to sell this business to San Andreas Government\n");
            strcat(string, "remember, there is no going back if you confirm this sell\n");
            strcat(string, "you will recieved on going market value of this business\n");
            strcat(string, "press enter to confirm the sell or esc to cancel\n");
            ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetSellconfirm, DIALOG_STYLE_MSGBOX, "Sale Business", string, "Yes", "No", shopid);
            return ~1;
        }
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetSellconfirm) {
        if (!response) return ~1;
        new shopid = extraid;
        new cash = GetPercentageOf(RandomEx(60, 80), DynamicShopBusiness:GetPrice(shopid));
        if (cash > 0) {
            AddPlayerLog(
                playerid,
                sprintf("Sold a business [%d] from the government for $%s", shopid, FormatCurrency(cash)),
                "business"
            );
            vault:PlayerVault(playerid, cash, sprintf("sold shop business [%d] to government", shopid), Vault_ID_Government, -cash, sprintf("%s sold shop business [%d] to government", GetPlayerNameEx(playerid), shopid));
            SendClientMessage(playerid, -1, sprintf("{0080FF}[Shop Business]: {FFFFEE}you have recieved $%s from shop business sale", FormatCurrency(cash)));
        }
        DynamicShopBusiness:Reset(shopid);
        DynamicShopBusiness:RequestUpdate(shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetAdminUpdatePrice) {
        new shopid = extraid, newprice;
        if (!response) {
            DynamicShopBusiness:AdminManage(playerid, shopid);
            return ~1;
        }
        if (sscanf(inputtext, "d", newprice) || newprice < 1) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminUpdatePrice, DIALOG_STYLE_INPUT, "Update Shop Price", "Enter shop price\nInvalid price", "Submit", "Cancel", shopid); return ~1; }
        DynamicShopBusiness:SetPrice(shopid, newprice);
        DynamicShopBusiness:RequestUpdate(shopid);
        DynamicShopBusiness:AdminManage(playerid, shopid);
    }
    if (offsetid == DynamicShopBusiness:offsetAdminUpdateOwner) {
        new shopid = extraid, owner[50];
        if (!response) {
            DynamicShopBusiness:AdminManage(playerid, shopid);
            return ~1;
        }
        if (sscanf(inputtext, "s[50]", owner)) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminUpdateOwner, DIALOG_STYLE_INPUT, "Update Owner", "Enter new owner name\nInvalid Name", "Submit", "Cancel", shopid); return ~1; }
        if (!IsValidAccount(owner)) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminUpdateOwner, DIALOG_STYLE_INPUT, "Update Owner", "Enter new owner name\nInvalid Name", "Submit", "Cancel", shopid); return ~1; }
        DynamicShopBusiness:SetOwner(shopid, owner);
        DynamicShopBusiness:RequestUpdate(shopid);
        DynamicShopBusiness:AdminManage(playerid, shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetAdminManageOp) {
        if (!response) return ~1;
        new shopid = extraid;
        if (IsStringSame(inputtext, "Owner")) {
            ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminUpdateOwner, DIALOG_STYLE_INPUT, "Update Owner", "Enter new owner name", "Submit", "Cancel", shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Set Shop Price")) {
            ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminUpdatePrice, DIALOG_STYLE_INPUT, "Update Shop Price", "Enter shop price", "Submit", "Cancel", shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Teleport")) {
            TeleportPlayer(playerid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            return ~1;
        }
        if (IsStringSame(inputtext, "Refill Stocks")) {
            DynamicShopBusiness:AdminManage(playerid, shopid);
            CallRemoteFunction("RefillShopStock", "dd", playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Reset Stocks")) {
            DynamicShopBusiness:AdminManage(playerid, shopid);
            CallRemoteFunction("ResetShopStock", "dd", playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Access")) {
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Update Coordinate")) {
            GetPlayerPos(playerid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0] = GetPlayerInteriorID(playerid);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0] = GetPlayerVirtualWorldID(playerid);
            DestroyDynamic3DTextLabel(DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid] = CreateDynamic3DTextLabel(sprintf("My Shop [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            DestroyDynamicMapIcon(DynamicShopBusiness:data[shopid][DynamicShopBusiness:mapIcon]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:mapIcon] = CreateDynamicMapIcon(DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 8, -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            DestroyDynamicPickup(DynamicShopBusiness:data[shopid][DynamicShopBusiness:shopObj]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:shopObj] = CreateDynamicPickup(1210, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AdminManage(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Update Trucker Coordinate")) {
            GetPlayerPos(playerid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1] = GetPlayerInteriorID(playerid);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1] = GetPlayerVirtualWorldID(playerid);
            DestroyDynamic3DTextLabel(DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid] = CreateDynamic3DTextLabel(sprintf("Trucker Point [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1]);
            DestroyDynamicPickup(DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckerObj]);
            DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckerObj] = CreateDynamicPickup(19832, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
            DynamicShopBusiness:RequestUpdate(shopid);
            DynamicShopBusiness:AdminManage(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Reset")) {
            DynamicShopBusiness:Reset(shopid);
            DynamicShopBusiness:AdminManage(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Remove")) {
            DynamicShopBusiness:Remove(shopid);
            return ~1;
        }
        DynamicShopBusiness:AdminManage(playerid, shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetAdminMenu) {
        if (!response) return ~1;
        if (IsStringSame(inputtext, "Create Business")) {
            new string[2000];
            for (new type; type < MAX_DYNAMIC_SHOPS_TYPES; type++) strcat(string, sprintf("%s\n", DynamicShopBusiness:TypesName[type]));
            ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminCreate, DIALOG_STYLE_LIST, "Dynamic Business System", string, "Select", "Close");
            return ~1;
        }
        if (IsStringSame(inputtext, "Manage Business")) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminManage, DIALOG_STYLE_INPUT, "Dynamic Business System", "Enter shop id to manage", "Submit", "Close"); return ~1; }
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetAdminManage) {
        if (!response) return ~1;
        new shopid = -1;
        if (sscanf(inputtext, "d", shopid)) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminManage, DIALOG_STYLE_INPUT, "Dynamic Business System", "Enter shop id to manage", "Submit", "Close"); return ~1; }
        if (!DynamicShopBusiness:IsValidShopID(shopid)) { ShowPlayerDialogEx(playerid, DynamicShopBusiness:dialogid, DynamicShopBusiness:offsetAdminManage, DIALOG_STYLE_INPUT, "Dynamic Business System", "Enter shop id to manage", "Submit", "Close"); return ~1; }
        DynamicShopBusiness:AdminManage(playerid, shopid);
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetOwnerMenu) {
        if (!response) return ~1;
        new shopid = extraid;
        if (IsStringSame(inputtext, "Open Shop Menu")) {
            DynamicShopBusiness:RequestShopMenu(playerid, shopid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Manage Shop")) {
            DynamicShopBusiness:AccessShop(playerid, shopid);
            return ~1;
        }
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetAdminCreate) {
        if (!response) return ~1;
        new type = listitem;
        new shopid = Iter_Free(dynbusiness);
        if (shopid == INVALID_ITERATOR_SLOT) { SendClientMessage(playerid, 0xFF0000FF, "[Error]:{FFFFFF} max limit of dynamic shops exceed"); return ~1; }
        Iter_Add(dynbusiness, shopid);
        DynamicShopBusiness:Reset(shopid);
        format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:name], 50, "My Shop");
        format(DynamicShopBusiness:data[shopid][DynamicShopBusiness:owner], 50, "-");
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Price] = Random(500000, 1000000);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Balance] = 0;
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt] = gettime();
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt] = gettime();
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:lock] = false;
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:Allowedloading] = false;
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:AllowedUnloading] = false;
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:type] = type;
        GetPlayerPos(playerid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2]);
        GetPlayerPos(playerid, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5]);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0] = GetPlayerInteriorID(playerid);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1] = GetPlayerInteriorID(playerid);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0] = GetPlayerVirtualWorldID(playerid);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1] = GetPlayerVirtualWorldID(playerid);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:textid] = CreateDynamic3DTextLabel(sprintf("My Shop [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckertextid] = CreateDynamic3DTextLabel(sprintf("Trucker Point [%d]", shopid), -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][1]);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:mapIcon] = CreateDynamicMapIcon(DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], 8, -1, DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:shopObj] = CreateDynamicPickup(1210, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][1], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][2], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:truckerObj] = CreateDynamicPickup(19832, 23, DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][3], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][4], DynamicShopBusiness:data[shopid][DynamicShopBusiness:position][5], DynamicShopBusiness:data[shopid][DynamicShopBusiness:vw][0], DynamicShopBusiness:data[shopid][DynamicShopBusiness:int][0]);
        DynamicShopBusiness:DatabaseCreate(shopid);
        DynamicShopBusiness:RequestUpdate(shopid);
        SendClientMessage(playerid, -1, "[Alexa]: created dynamic shop");
        return ~1;
    }
    if (offsetid == DynamicShopBusiness:offsetPurchase) {
        if (!response) return ~1;
        new shopid = extraid;
        if (DynamicShopBusiness:IsPurchased(shopid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Shop]: {FFFFEE}this shop is already purchased"); return ~1; }
        if (DynamicShopBusiness:GetTotalPurchased(playerid) >= DynamicShopBusiness:GetPlayerMaxLimit(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Shop]: {FFFFEE}you can purchase max 1 Shop only"); return ~1; }
        if (GetPlayerCash(playerid) < DynamicShopBusiness:GetPrice(shopid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Shop]: {FFFFEE}you don't have enough money to purchase this unit"); return ~1; }
        vault:PlayerVault(playerid, -DynamicShopBusiness:GetPrice(shopid), sprintf("purchased Shop [%d]", shopid), Vault_ID_Government, DynamicShopBusiness:GetPrice(shopid), sprintf("sold Shop [%d] to %s", shopid, GetPlayerNameEx(playerid)));
        AddPlayerLog(
            playerid,
            sprintf("Purchased a business [%d] from the government for $%s", shopid, FormatCurrency(DynamicShopBusiness:GetPrice(shopid))),
            "business"
        );
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:LastAccessedAt] = gettime();
        DynamicShopBusiness:data[shopid][DynamicShopBusiness:PurchasedAt] = gettime();
        DynamicShopBusiness:SetOwner(shopid, GetPlayerNameEx(playerid));
        DynamicShopBusiness:RequestUpdate(shopid);
        CallRemoteFunction("ResetShopStock", "dd", -1, shopid);
        SendClientMessage(playerid, -1, "{4286f4}[Shop]:{FFFFFF} you have purchased this Shop.");
        return ~1;
    }
    return ~1;
}

stock DynamicShopBusiness:SaleToFriendMenu(playerid, shopid) {
    new string[512];
    strcat(string, "Hi there, you are about to sell this business to a friend\n");
    strcat(string, "remember, there is no going back if you confirm this sell\n");
    strcat(string, "press enter friend id to confirm the sell or esc to cancel\n");
    FlexPlayerDialog(playerid, "ShopSaleToFriend", DIALOG_STYLE_INPUT, "Sale Business", string, "Yes", "No", shopid);
    return 1;
}

FlexDialog:ShopSaleToFriend(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return 1;
    new friendid;
    if (
        sscanf(inputtext, "u", friendid) ||
        !IsPlayerInRangeOfPlayer(playerid, friendid, 10.0) ||
        DynamicShopBusiness:GetTotalPurchased(friendid) > 0
    ) {
        AlexaMsg(playerid, "Make sure your friend is close and does not own a shop");
        return DynamicShopBusiness:SaleToFriendMenu(playerid, shopid);
    }
    DynamicShopBusiness:UpdatePurchasedAt(shopid);
    DynamicShopBusiness:SetOwner(shopid, GetPlayerNameEx(friendid));
    DynamicShopBusiness:Update3dText(shopid, "updating...", true);
    AlexaMsg(playerid, sprintf("%s owns your shop now.", GetPlayerNameEx(friendid)));
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    foreach(new shopid:dynbusiness) {
        if (IsStringSame(DynamicShopBusiness:GetOwner(shopid), OldName)) {
            DynamicShopBusiness:SetOwner(shopid, NewName);
            DynamicShopBusiness:RequestUpdate(shopid);
        }
    }
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    foreach(new shopid:dynbusiness) {
        if (IsStringSame(DynamicShopBusiness:GetOwner(shopid), AccountName)) {
            DynamicShopBusiness:Reset(shopid);
            DynamicShopBusiness:RequestUpdate(shopid);
        }
    }
    return 1;
}