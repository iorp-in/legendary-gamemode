//#region vars
#define     HousePurchaseScore          (50)
#define     SAFE_MAX_PRICE              (50000)
#define     MAX_HOUSES                  (1000)
#define     MAX_Furniture               (1000)
#define     MAX_HOUSE_NAME              (48)
#define     MAX_HOUSE_PASSWORD          (16)
#define     MAX_HOUSE_ADDRESS           (48)
#define     MAX_INT_NAME                (32)
#define     INVALID_HOUSE_ID            (-1)
#define     HOUSE_COOLDOWN              (10)
#define     LIMIT_HOUSE_PER_PLAYER      (1)
#define     HOUSE_RESET_DAY             (180)

enum _:e_lockmodes {
    LOCK_MODE_NOLOCK,
    LOCK_MODE_PASSWORD,
    LOCK_MODE_KEYS,
    LOCK_MODE_OWNER
}

enum _:e_selectmodes {
    SELECT_MODE_NONE,
    SELECT_MODE_EDIT,
    SELECT_MODE_SELL
}

enum e_house {
    Name[MAX_HOUSE_NAME],
        Owner[MAX_PLAYER_NAME],
        Password[MAX_HOUSE_PASSWORD],
        Float:houseX,
        Float:houseY,
        Float:houseZ,
        Price,
        SalePrice,
        Interior,
        LockMode,
        SafeMoney,
        LastEntered,
        HAutoReset,
        HousePizza,
        HouseHotdog,
        HouseCola,
        HouseBurger,
        HouseFries,
        HouseStorageWater,
        HouseStorageCorn,
        HouseStorageWheat,
        HouseStorageOnion,
        HouseStoragePotato,
        HouseStorageGarlic,
        HouseStorageVinegar,
        HouseStorageTomato,
        HouseStorageRice,
        HouseStorageMeet,
        HouseStorageMilk,
        HouseStorageCheese,
        HouseStorageEgg,

        Text3D:HouseLabel,
        HousePickup,
        HouseIcon
};

enum e_interior {
    IntName[MAX_INT_NAME],
        Float:intX,
        Float:intY,
        Float:intZ,
        intID,
        Float:deviceX,
        Float:deviceY,
        Float:deviceZ,
        Float:closetX,
        Float:closetY,
        Float:closetZ,
        Float:fridgeX,
        Float:fridgeY,
        Float:fridgeZ,
        Float:stoveX,
        Float:stoveY,
        Float:stoveZ,

        Text3D:HDeviceLabel,
        Text3D:HClosetLabel,
        Text3D:HFridgeLabel,
        Text3D:HStoveLabel,
        Text3D:intLabel,
        intPickup
};

enum e_furnituredata {
    ModelID,
    Name[32],
    Price
};

enum e_furniture {
    FurnitureID,
    FurnitureHouseID,
    Float:FurnitureX,
    Float:FurnitureY,
    Float:FurnitureZ,
    Float:FurnitureRX,
    Float:FurnitureRY,
    Float:FurnitureRZ,
    FurnitureVW,
    FurnitureInt,

    FurnitureObjectID
};

new furnituredata[MAX_Furniture][e_furniture];
new Iterator:FurnitureIDs < MAX_Furniture > ;

new HouseData[MAX_HOUSES][e_house],
    Iterator:Houses < MAX_HOUSES > ,
    Iterator:HouseKeys[MAX_PLAYERS] < MAX_HOUSES > ,
    InHouse[MAX_PLAYERS] = { INVALID_HOUSE_ID, ... },
    SelectMode[MAX_PLAYERS] = { SELECT_MODE_NONE, ... },
    LastVisitedHouse[MAX_PLAYERS] = { INVALID_HOUSE_ID, ... },
    bool:EditingFurniture[MAX_PLAYERS] = { false, ... };

new HouseInteriors[][e_interior] = {
    // int name, x, y, z, intid, devicex, devicey, devicez, closetX, closetY, closetZ, fridgeX, fridgeY, fridgeZ, stoveX, stoveY, stoveZ
    { "Interior 0", 2233.4900, -1114.4435, 1050.8828, 5, 2234.7104, -1105.1825, 1050.8828, 2231.7358, -1112.1644, 1050.8828, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
    { "Interior 1", 2196.3943, -1204.1359, 1049.0234, 6, 2191.1919, -1201.3533, 1049.0234, 2187.9272, -1213.3463, 1049.0234, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
    { "Interior 2", 2318.1616, -1026.3762, 1050.2109, 9, 2326.9749, -1018.0592, 1050.2178, 2326.8936, -1015.4194, 1054.7111, 2312.9307, -1013.5900, 1050.2109, 2313.3198, -1008.1932, 1050.2109 },
    { "Interior 3", 225.5707, 1240.0643, 1082.1406, 2, 218.7307, 1239.1234, 1082.1481, 222.8923, 1249.3684, 1082.1406, 231.5587, 1243.9056, 1082.1406, 232.7137, 1248.7244, 1082.1406 },
    { "Interior 4", 2496.2087, -1692.3149, 1014.7422, 3, 2491.4500, -1694.8715, 1014.9249, 2492.3730, -1708.5681, 1018.3368, 2498.2329, -1711.3522, 1014.7422, 2499.0693, -1706.7737, 1014.7422 },
    { "Interior 5", 226.7545, 1114.4180, 1080.9952, 5, 243.1013, 1106.3848, 1080.9922, 234.8502, 1107.6761, 1085.0156, 240.1683, 1117.4976, 1080.9922, 235.7010, 1119.7861, 1080.9922 },
    { "Interior 6", 2269.9636, -1210.3275, 1047.5625, 10, 2255.5996, -1212.4526, 1049.0234, 2258.6692, -1220.2599, 1049.0234, 2248.1150, -1213.1010, 1049.0234, 2248.5405, -1207.5615, 1049.0234 },
    { "Interior 7", 2751.5693, 430.7137, 1578.6890, 3, 2743.9207, 429.8625, 1578.6868, 2749.1775, 430.0553, 1581.5059, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
    { "Interior 8", 1972.4739, -1552.5277, 2451.3450, 3, 1973.4042, -1545.6219, 2451.3420, 1972.3423, -1541.9785, 2451.3420, 1968.8038, -1544.5012, 2451.3420, 1966.4370, -1544.4183, 2451.3440 },
    { "Interior 9", 2439.1462, -96.6630, 1146.8767, 3, 2436.9314, -99.7551, 1146.8826, 2444.0317, -98.3390, 1146.8867, 2436.0808, -105.4347, 1146.8867, 2436.0579, -108.0041, 1146.8867 },
    { "Interior 10", 1396.9073, -1364.6455, 330.1432, 3, 1392.8208, -1354.1385, 330.1432, 1380.2910, -1372.0571, 330.1432, 1394.5825, -1371.5483, 330.1432, 1394.5763, -1367.7761, 330.1432 },
    { "Interior 11", 1412.1044, -1475.9944, 125.3919, 3, 1413.6001, -1482.8344, 125.3909, 1408.1686, -1479.6139, 125.3909, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
    { "Interior 12", 1398.4319, -13.8527, 1001.0000, 12, 1390.1078, -34.5370, 1000.9001, 1394.2982, -44.6414, 1000.9001, 1380.5472, -30.7020, 1000.9001, 1380.9006, -35.1168, 1000.9001 },
    { "Interior 13", 1394.8043, -9.7791, 1000.9383, 13, 1389.7511, -7.1243, 1000.9383, 1389.6990, -10.5511, 1000.9383, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
};

new HouseFurnitures[][e_furnituredata] = {
    // modelid, furniture name, price
    { 3111, "Building Plan", 500 },
    { 2894, "Book", 20 },
    { 2277, "Cat Picture", 100 },
    { 1753, "Leather Couch", 150 },
    { 1703, "Black Couch", 200 },
    { 1255, "Lounger", 75 },
    { 19581, "Frying Pan", 10 },
    { 19584, "Sauce Pan", 12 },
    { 19590, "Woozie's Sword", 1000 },
    { 19525, "Wedding Cake", 50 },
    { 1742, "Bookshelf", 80 },
    { 1518, "TV 1", 130 },
    { 19609, "Drum Kit", 500 },
    { 19787, "Small LCD TV", 2000 },
    { 19786, "Big LCD TV", 4000 },
    { 2627, "Treadmill", 130 }
};

new LockNames[4][32] = {
        "{2ECC71}Not Locked",
        "{4286f4}Password Locked",
        "{4286f4}Requires Keys",
        "{4286f4}Owner Only"
    },
    TransactionNames[2][16] = {
        "{4286f4}Taken",
        "{2ECC71}Added"
    };

//#endregion vars

stock House:LoadKeys(playerid) {
    Iter_Clear(HouseKeys[playerid]);
    mysql_tquery(Database, sprintf("SELECT * FROM houseKeys WHERE Player = \"%s\"", GetPlayerNameEx(playerid)), "LoadPlayerHouseKeys", "i", playerid);
    return 1;
}

forward LoadPlayerHouseKeys(playerid);
public LoadPlayerHouseKeys(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    new rows = cache_num_rows();
    if (rows) {
        new loaded, house_id;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "HouseID", house_id);
            Iter_Add(HouseKeys[playerid], house_id);
            loaded++;
        }
    }
    return 1;
}

stock House:IsValidFurnitureID(furnitureid) {
    return Iter_Contains(FurnitureIDs, furnitureid);
}

stock House:GetFurnitureObjectID(furnitureid) {
    return furnituredata[furnitureid][FurnitureObjectID];
}

stock House:GetFurnitureHouseID(furnitureid) {
    return furnituredata[furnitureid][FurnitureHouseID];
}

stock House:GetFurniturePrice(furnitureid) {
    return HouseFurnitures[furnituredata[furnitureid][FurnitureID]][Price];
}

stock House:GetStaticFurniturePrice(furnitureid) {
    return HouseFurnitures[furnitureid][Price];
}

stock House:GetFurnitureModelID(furnitureid) {
    return HouseFurnitures[furnituredata[furnitureid][FurnitureID]][ModelID];
}

stock House:GetFurnitureName(furnitureid) {
    new string[50];
    format(string, sizeof string, "%s", HouseFurnitures[furnituredata[furnitureid][FurnitureID]][Name]);
    return string;
}

stock House:GetStaticFurnitureName(furnitureid) {
    new string[50];
    format(string, sizeof string, "%s", HouseFurnitures[furnitureid][Name]);
    return string;
}

stock House:IsEditingFurniture(playerid) {
    return EditingFurniture[playerid];
}

stock House:SetEditingFurniture(playerid, bool:newstate) {
    return EditingFurniture[playerid] = newstate;
}

stock House:IsPlayerInAnyHouse(playerid) {
    return InHouse[playerid] != INVALID_HOUSE_ID;
}

stock House:GetPlayerHouseID(playerid) {
    return InHouse[playerid];
}

stock House:SetPlayerHouseID(playerid, houseid) {
    return InHouse[playerid] = houseid;
}

stock House:IsPlayerOwner(playerid, houseid) {
    return House:IsOwner(houseid, GetPlayerNameEx(playerid));
}

stock House:IsOwner(houseid, const username[]) {
    return IsStringSame(House:GetOwner(houseid), username);
}

stock House:IsPurchased(houseid) {
    if (!House:IsValidID(houseid)) return 0;
    return strcmp("-", HouseData[houseid][Owner]);
}

stock House:SetOwner(houseid, const owner[]) {
    format(HouseData[houseid][Owner], MAX_PLAYER_NAME, "%s", owner);
    return 1;
}

stock House:GetAddress(houseid) {
    new string[MAX_HOUSE_ADDRESS];
    format(string, sizeof string, "%d, %s, %s", houseid,
        GetZoneName(HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]),
        GetCityName(HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ])
    );
    return string;
}

stock House:GetOwner(houseid) {
    new string[100];
    format(string, sizeof string, "unknown");
    if (!House:IsValidID(houseid)) return string;
    format(string, sizeof string, "%s", HouseData[houseid][Owner]);
    return string;
}

stock House:GetPassword(houseid) {
    new string[100];
    format(string, sizeof string, "%s", HouseData[houseid][Password]);
    return string;
}

stock House:UpdatePassword(houseid, const newpassword[]) {
    format(HouseData[houseid][Password], MAX_HOUSE_PASSWORD, "%s", newpassword);
    return 1;
}

stock House:GetLockName(houseid) {
    new string[100];
    format(string, sizeof string, "%s", LockNames[House:GetLockMode(houseid)]);
    return string;

}

stock House:GetName(houseid) {
    new string[100];
    format(string, sizeof string, "unknown");
    if (!House:IsValidID(houseid)) return string;
    format(string, sizeof string, "%s", HouseData[houseid][Name]);
    return string;
}

stock House:UpdateName(houseid, const newname[]) {
    format(HouseData[houseid][Name], 48, "%s", newname);
    return 1;
}

stock House:IsValidID(houseid) {
    return Iter_Contains(Houses, houseid);
}

stock House:GetLastEntered(houseid) {
    return HouseData[houseid][LastEntered];
}

stock House:UpdateLastEntered(houseid) {
    return HouseData[houseid][LastEntered] = gettime();
}

stock House:GetPrice(houseid) {
    return HouseData[houseid][Price];
}

stock House:GetSalePrice(houseid) {
    return HouseData[houseid][SalePrice];
}

stock House:SetSalePrice(houseid, saleprice) {
    return HouseData[houseid][SalePrice] = saleprice;
}

stock House:GetInterior(houseid) {
    return HouseData[houseid][Interior];
}

stock House:GetAutoReset(houseid) {
    return HouseData[houseid][HAutoReset];
}

stock House:SetAutoReset(houseid, newstate) {
    return HouseData[houseid][HAutoReset] = newstate;
}

stock House:GetLockMode(houseid) {
    return HouseData[houseid][LockMode];
}

stock House:GetSafeMoney(houseid) {
    return HouseData[houseid][SafeMoney];
}

stock House:SetSafeMoney(houseid, newmoney) {
    return HouseData[houseid][SafeMoney] = newmoney;
}

stock House:IsPasswordValid(houseid, const password[]) {
    return IsStringSame(HouseData[houseid][Password], password);
}

stock House:GetInteriorID(houseid) {
    return HouseInteriors[House:GetInterior(houseid)][intID];
}

stock House:GetInteriorName(houseid) {
    new string[50];
    format(string, sizeof string, "%s", HouseInteriors[House:GetInterior(houseid)][IntName]);
    return string;
}

stock House:GetLastHouseID(playerid) {
    return LastVisitedHouse[playerid];
}

stock House:SetLastHouseID(playerid, houseid) {
    return LastVisitedHouse[playerid] = houseid;
}

stock House:IsHaveKey(playerid, houseid) {
    return Iter_Contains(HouseKeys[playerid], houseid);
}

stock House:GiveKey(playerid, houseid) {
    return Iter_Add(HouseKeys[playerid], houseid);
}

stock House:TakeKey(playerid, houseid) {
    return Iter_SafeRemove(HouseKeys[playerid], houseid, houseid);
}

stock House:GetLimit(playerid) {
    if (IsPlayerMasterAdmin(playerid)) return 100;
    else if (GetPlayerVIPLevel(playerid) == 1) return 3;
    else if (GetPlayerVIPLevel(playerid) == 2) return 5;
    else if (GetPlayerVIPLevel(playerid) == 3) return 10;
    else return LIMIT_HOUSE_PER_PLAYER;
}

stock House:GetOwnedCount(playerid) {
    new count;
    foreach(new houseid:Houses) if (House:IsPlayerOwner(playerid, houseid)) count++;
    return count;
}


stock House:GetPlayersInHouse(houseid) {
    new count = 0;
    if (!House:IsValidID(houseid)) return count;
    foreach(new playerid: Player) {
        if (House:GetPlayerHouseID(playerid) == houseid) count++;
    }
    return count;
}

stock House:WantedPlayersInHouse(houseid, bool:rpmode = false) {
    new count = 0;
    if (!House:IsValidID(houseid)) return count;
    foreach(new playerid: Player) {
        if (House:GetPlayerHouseID(playerid) == houseid && GetPlayerWantedLevelEx(playerid) > 0) {
            if (!rpmode) count++;
            else if (GetPlayerRPMode(playerid)) count++;
        }
    }
    return count;
}

stock House:GetFirstHouseAddress(playerid) {
    new string[100];
    format(string, sizeof string, "Unknown");
    foreach(new houseid:Houses) {
        if (House:IsPlayerOwner(playerid, houseid)) {
            format(string, sizeof string, "%s", House:GetAddress(houseid));
            break;
        }
    }
    return string;
}

stock House:IsPlayerInOwnHouse(playerid) {
    new houseid = House:GetPlayerHouseID(playerid);
    if (!House:IsValidID(houseid)) return 0;
    if (!House:IsPlayerOwner(playerid, houseid)) return 0;
    return 1;
}

stock House:SendTo(playerid, houseid) {
    if (!House:IsValidID(houseid)) return 0;
    SetPVarInt(playerid, "HousePickupCooldown", gettime() + HOUSE_COOLDOWN);
    SetPlayerVirtualWorldEx(playerid, houseid);
    SetPlayerInteriorEx(playerid, House:GetInteriorID(houseid));
    SetPlayerPosEx(
        playerid,
        HouseInteriors[HouseData[houseid][Interior]][intX],
        HouseInteriors[HouseData[houseid][Interior]][intY],
        HouseInteriors[HouseData[houseid][Interior]][intZ]
    );
    House:SetPlayerHouseID(playerid, houseid);
    AlexaMsg(playerid, sprintf("Welcome to %s's house, %s{FFFFFF}!", House:GetOwner(houseid), House:GetName(houseid)));

    if (House:IsPlayerOwner(playerid, houseid)) {
        House:UpdateLastEntered(houseid);
        House:UpdateLabel(houseid);
        AlexaMsg(playerid, "press {3498DB}N {FFFFFF}to open the house menu.", "House");
    }
    if (House:GetLockMode(houseid) == LOCK_MODE_NOLOCK && House:GetLastHouseID(playerid) != houseid) {
        mysql_tquery(Database, sprintf("INSERT INTO houseVisitors SET HouseID=%d, Visitor = \"%s\", Date=UNIX_TIMESTAMP()", houseid, GetPlayerNameEx(playerid)));
        House:SetLastHouseID(playerid, houseid);
    }
    return 1;
}

stock House:Reset(houseid) {
    if (!House:IsValidID(houseid)) return 0;
    format(HouseData[houseid][Name], MAX_HOUSE_NAME, "House For Sale");
    format(HouseData[houseid][Owner], MAX_PLAYER_NAME, "-");
    format(HouseData[houseid][Password], MAX_HOUSE_PASSWORD, "-");
    HouseData[houseid][LockMode] = LOCK_MODE_NOLOCK;
    HouseData[houseid][HAutoReset] = 1;
    HouseData[houseid][SalePrice] = HouseData[houseid][SafeMoney] = HouseData[houseid][LastEntered] = 0;

    UpdateDynamic3DTextLabelText(HouseData[houseid][HouseLabel], 0xFFFFFFFF, sprintf(
        "{2ECC71}House For Sale (ID:%d)\n{FFFFFF}%s\n{F1C40F}Price:{2ECC71}$%s",
        houseid, House:GetInteriorName(houseid), FormatCurrency(HouseData[houseid][Price])
    ));
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, HouseData[houseid][HousePickup], E_STREAMER_MODEL_ID, 1273);
    Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, HouseData[houseid][HouseIcon], E_STREAMER_TYPE, 31);

    foreach(new playerid:Player) {
        if (InHouse[playerid] == houseid) {
            House:SetPlayerHouseID(playerid, INVALID_HOUSE_ID);
            SetPVarInt(playerid, "HousePickupCooldown", gettime() + HOUSE_COOLDOWN);
            SetPlayerVirtualWorldEx(playerid, 0);
            SetPlayerInteriorEx(playerid, 0);
            SetPlayerPosEx(playerid, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
        }
        if (House:IsHaveKey(playerid, houseid)) Iter_Remove(HouseKeys[playerid], houseid);
    }

    mysql_tquery(Database, sprintf("DELETE FROM houseGuns WHERE HouseID=%d", houseid));

    foreach(new furnitureid:FurnitureIDs) {
        if (furnituredata[furnitureid][FurnitureHouseID] == houseid) {
            if (!IsValidDynamicObject(furnituredata[furnitureid][FurnitureObjectID])) continue;
            DestroyDynamicObjectEx(furnituredata[furnitureid][FurnitureObjectID]);
            furnituredata[furnitureid][FurnitureObjectID] = -1;
        }
    }

    mysql_tquery(Database, sprintf("DELETE FROM houseFurnitures WHERE HouseID=%d", houseid));
    mysql_tquery(Database, sprintf("DELETE FROM houseVisitors WHERE HouseID=%d", houseid));
    mysql_tquery(Database, sprintf("DELETE FROM houseKeys WHERE HouseID=%d", houseid));
    mysql_tquery(Database, sprintf("DELETE FROM houseSafeLogs WHERE HouseID=%d", houseid));
    return 1;
}

stock House:Save(houseid) {
    new query[2000];
    mysql_format(
        Database, query, sizeof(query),
        "UPDATE houses SET HouseName=\"%s\", HouseOwner=\"%s\", HousePassword=\"%s\", HouseSalePrice=%d, HouseLock=%d, HouseMoney=%d, LastEntered=%d, HAutoReset=%d, \
        HousePizza=%d,HouseHotdog=%d,HouseCola=%d,HouseBurger=%d,HouseFries=%d,HouseStorageWater=%d,HouseStorageCorn=%d,HouseStorageWheat=%d,HouseStorageOnion=%d, \
        HouseStoragePotato=%d,HouseStorageGarlic=%d,HouseStorageVinegar=%d,HouseStorageTomato=%d,HouseStorageRice=%d,HouseStorageMeet=%d,HouseStorageMilk=%d, \
        HouseStorageCheese=%d,HouseStorageEgg=%d WHERE ID=%d",
        HouseData[houseid][Name], HouseData[houseid][Owner], HouseData[houseid][Password], HouseData[houseid][SalePrice], HouseData[houseid][LockMode],
        HouseData[houseid][SafeMoney], HouseData[houseid][LastEntered], HouseData[houseid][HAutoReset], HouseData[houseid][HousePizza], HouseData[houseid][HouseHotdog],
        HouseData[houseid][HouseCola], HouseData[houseid][HouseBurger], HouseData[houseid][HouseFries], HouseData[houseid][HouseStorageWater],
        HouseData[houseid][HouseStorageCorn], HouseData[houseid][HouseStorageWheat], HouseData[houseid][HouseStorageOnion], HouseData[houseid][HouseStoragePotato],
        HouseData[houseid][HouseStorageGarlic], HouseData[houseid][HouseStorageVinegar], HouseData[houseid][HouseStorageTomato], HouseData[houseid][HouseStorageRice],
        HouseData[houseid][HouseStorageMeet], HouseData[houseid][HouseStorageMilk], HouseData[houseid][HouseStorageCheese], HouseData[houseid][HouseStorageEgg], houseid);
    mysql_tquery(Database, query);
    return 1;
}

stock House:UpdateLabel(houseid) {
    if (!House:IsValidID(houseid)) return 0;
    if (!House:IsPurchased(houseid)) {
        UpdateDynamic3DTextLabelText(HouseData[houseid][HouseLabel], 0xFFFFFFFF, sprintf(
            "{2ECC71}House For Sale (ID:%d)\n{FFFFFF}%s\n{F1C40F}Price:{2ECC71}$%s",
            houseid, House:GetInteriorName(houseid), FormatCurrency(House:GetPrice(houseid))
        ));
    } else {
        if (House:GetSalePrice(houseid) > 0) {
            UpdateDynamic3DTextLabelText(HouseData[houseid][HouseLabel], 0xFFFFFFFF, sprintf(
                "{E67E22}%s's House For Sale (ID:%d)\n{FFFFFF}%s\n{FFFFFF}%s\n{F1C40F}Price:{2ECC71}$%s\n\npress N to purchase",
                House:GetOwner(houseid), houseid, House:GetName(houseid), House:GetInteriorName(houseid), FormatCurrency(House:GetSalePrice(houseid))
            ));
        } else {
            UpdateDynamic3DTextLabelText(HouseData[houseid][HouseLabel], 0xFFFFFFFF, sprintf(
                "{E67E22}%s's House (ID:%d)\n{FFFFFF}%s\n{FFFFFF}%s\n%s\n{FFFFFF}%s\nLast Visited:%s\n\npress N to enter",
                House:GetOwner(houseid), houseid, House:GetName(houseid), House:GetInteriorName(houseid),
                House:GetLockName(houseid), House:GetAddress(houseid), UnixToHumanEx(House:GetLastEntered(houseid))
            ));
        }
    }
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    House:SetPlayerHouseID(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "houseID"));
    House:SetLastHouseID(playerid, INVALID_HOUSE_ID);
    SelectMode[playerid] = SELECT_MODE_NONE;
    House:SetEditingFurniture(playerid, false);
    House:LoadKeys(playerid);
    mysql_tquery(Database, sprintf("SELECT * FROM houseSales WHERE OldOwner = \"%s\"", GetPlayerNameEx(playerid)), "HouseSaleMoney", "i", playerid);
    return 1;
}

forward HouseSaleMoney(playerid);
public HouseSaleMoney(playerid) {
    new rows = cache_num_rows();
    if (rows) {
        new new_owner[MAX_PLAYER_NAME], price, tnxid;
        for (new i; i < rows; i++) {
            cache_get_value_name(i, "NewOwner", new_owner);
            cache_get_value_name_int(i, "Price", price);
            cache_get_value_name_int(i, "ID", tnxid);
            AlexaMsg(playerid, sprintf("You sold a house to %s for $%s. (Transaction ID:#%d)", new_owner, FormatCurrency(price), tnxid));
            AddPlayerLog(
                playerid,
                sprintf("You sold a house to %s for $%s. (Transaction ID:#%d)", new_owner, FormatCurrency(price), tnxid),
                "business"
            );
            GivePlayerCash(playerid, price, sprintf("You sold a house to %s for $%s. (Transaction ID:#%d)", new_owner, FormatCurrency(price), tnxid));
        }
        mysql_tquery(Database, sprintf("DELETE FROM houseSales WHERE OldOwner = \"%s\"", GetPlayerNameEx(playerid)));
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(House:GetPlayerHouseID(playerid), GetPlayerNameEx(playerid), "username", "houseID");
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    House:SetPlayerHouseID(playerid, INVALID_HOUSE_ID);
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new houseid:Houses) {
        if (House:IsPurchased(houseid)) {
            if (House:GetLastEntered(houseid) > 0 && gettime() - House:GetLastEntered(houseid) > HOUSE_RESET_DAY * 86400 && House:GetAutoReset(houseid)) {
                if (!IsPlayerInServerByName(House:GetOwner(houseid))) {
                    Email:Send(
                        ALERT_TYPE_PROPERTY_EXPIRE, House:GetOwner(houseid), sprintf("House %s has been auto reset!!", House:GetName(houseid)),
                        sprintf("House %s [%d] has been auto reset!! Your house has been taken by government due to long inactivity and no visit in house for long time.",
                            House:GetName(houseid), houseid
                        )
                    );
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: House %s [%d]\n\
                Status: reseted\n\
                Reason: due to owner not active\n\
                ```\
                ", House:GetOwner(houseid), House:GetName(houseid), houseid));
                House:Reset(houseid);
            }
        }
        House:Save(houseid);
    }
    return 1;
}

hook GlobalHourInterval() {
    foreach(new houseid:Houses) {
        if (House:IsPurchased(houseid)) {
            new beforeDay = 1;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new houseWillResetAt = House:GetLastEntered(houseid) + (HOUSE_RESET_DAY - beforeDay) * 86400;
            if (houseWillResetAt >= mintime && houseWillResetAt < maxtime && House:GetAutoReset(houseid)) {
                if (!IsPlayerInServerByName(House:GetOwner(houseid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, House:GetOwner(houseid), sprintf("House %s [%d] will reset after 24 hours!!", House:GetName(houseid), houseid),
                        sprintf("House %s [%d] will reset after 24 hours!! Your house will be taken by government due to long inactivity and no visit in house for long time. you can stop this reset by visiting your house within 24 hours.", House:GetName(houseid), houseid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: House %s [%d]\n\
                Status: will reset within 24 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", House:GetOwner(houseid), House:GetName(houseid), houseid));
            }
        }
    }
    foreach(new houseid:Houses) {
        if (House:IsPurchased(houseid)) {
            new beforeDay = 2;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new houseWillResetAt = House:GetLastEntered(houseid) + (HOUSE_RESET_DAY - beforeDay) * 86400;
            if (houseWillResetAt >= mintime && houseWillResetAt < maxtime && House:GetAutoReset(houseid)) {
                if (!IsPlayerInServerByName(House:GetOwner(houseid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, House:GetOwner(houseid), sprintf("House %s [%d] will reset after 48 hours!!", House:GetName(houseid), houseid),
                        sprintf("House %s [%d] will reset after 48 hours!! Your house will be taken by government due to long inactivity and no visit in house for long time. \
                        you can stop this reset by visiting your house within 48 hours.", House:GetName(houseid), houseid)
                    );
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: House %s [%d]\n\
                Status: will reset within 48 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", House:GetOwner(houseid), House:GetName(houseid), houseid));
            }
        }
    }
    return 1;
}

forward LoadHouses();
public LoadHouses() {
    new rows = cache_num_rows();
    if (rows) {
        new houseid, loaded, for_sale, label[512];
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", houseid);
            cache_get_value_name(loaded, "HouseName", HouseData[houseid][Name], MAX_HOUSE_NAME);
            cache_get_value_name(loaded, "HouseOwner", HouseData[houseid][Owner], MAX_PLAYER_NAME);
            cache_get_value_name(loaded, "HousePassword", HouseData[houseid][Password], MAX_HOUSE_PASSWORD);
            cache_get_value_name_float(loaded, "HouseX", HouseData[houseid][houseX]);
            cache_get_value_name_float(loaded, "HouseY", HouseData[houseid][houseY]);
            cache_get_value_name_float(loaded, "HouseZ", HouseData[houseid][houseZ]);
            cache_get_value_name_int(loaded, "HousePrice", HouseData[houseid][Price]);
            cache_get_value_name_int(loaded, "HouseSalePrice", HouseData[houseid][SalePrice]);
            cache_get_value_name_int(loaded, "HouseInterior", HouseData[houseid][Interior]);
            cache_get_value_name_int(loaded, "HouseLock", HouseData[houseid][LockMode]);
            cache_get_value_name_int(loaded, "HouseMoney", HouseData[houseid][SafeMoney]);
            cache_get_value_name_int(loaded, "LastEntered", HouseData[houseid][LastEntered]);
            cache_get_value_name_int(loaded, "HAutoReset", HouseData[houseid][HAutoReset]);
            cache_get_value_name_int(loaded, "HousePizza", HouseData[houseid][HousePizza]);
            cache_get_value_name_int(loaded, "HouseHotdog", HouseData[houseid][HouseHotdog]);
            cache_get_value_name_int(loaded, "HouseCola", HouseData[houseid][HouseCola]);
            cache_get_value_name_int(loaded, "HouseBurger", HouseData[houseid][HouseBurger]);
            cache_get_value_name_int(loaded, "HouseFries", HouseData[houseid][HouseFries]);
            cache_get_value_name_int(loaded, "HouseStorageWater", HouseData[houseid][HouseStorageWater]);
            cache_get_value_name_int(loaded, "HouseStorageCorn", HouseData[houseid][HouseStorageCorn]);
            cache_get_value_name_int(loaded, "HouseStorageWheat", HouseData[houseid][HouseStorageWheat]);
            cache_get_value_name_int(loaded, "HouseStorageOnion", HouseData[houseid][HouseStorageOnion]);
            cache_get_value_name_int(loaded, "HouseStoragePotato", HouseData[houseid][HouseStoragePotato]);
            cache_get_value_name_int(loaded, "HouseStorageGarlic", HouseData[houseid][HouseStorageGarlic]);
            cache_get_value_name_int(loaded, "HouseStorageVinegar", HouseData[houseid][HouseStorageVinegar]);
            cache_get_value_name_int(loaded, "HouseStorageTomato", HouseData[houseid][HouseStorageTomato]);
            cache_get_value_name_int(loaded, "HouseStorageRice", HouseData[houseid][HouseStorageRice]);
            cache_get_value_name_int(loaded, "HouseStorageMeet", HouseData[houseid][HouseStorageMeet]);
            cache_get_value_name_int(loaded, "HouseStorageMilk", HouseData[houseid][HouseStorageMilk]);
            cache_get_value_name_int(loaded, "HouseStorageCheese", HouseData[houseid][HouseStorageCheese]);
            cache_get_value_name_int(loaded, "HouseStorageEgg", HouseData[houseid][HouseStorageEgg]);
            Iter_Add(Houses, houseid);

            if (House:IsPurchased(houseid)) {
                if (House:GetSalePrice(houseid) > 0) {
                    for_sale = 1;
                    format(label, sizeof(label), "{E67E22}%s's House For Sale (ID:%d)\n{FFFFFF}%s\n{FFFFFF}%s\n{F1C40F}Price:{2ECC71}$%s",
                        House:GetOwner(houseid), houseid, House:GetName(houseid), House:GetInteriorName(houseid), FormatCurrency(House:GetSalePrice(houseid))
                    );
                } else {
                    for_sale = 0;
                    format(label, sizeof(label),
                        "{E67E22}%s's House (ID:%d)\n{FFFFFF}%s\n{FFFFFF}%s\n%s\n{FFFFFF}%s\nLast Visited:%s",
                        House:GetOwner(houseid), houseid, House:GetName(houseid), House:GetInteriorName(houseid),
                        House:GetLockName(houseid), House:GetAddress(houseid), UnixToHumanEx(House:GetLastEntered(houseid))
                    );
                }
            } else {
                for_sale = 1;
                format(label, sizeof(label), "{2ECC71}House For Sale (ID:%d)\n{FFFFFF}%s\n{F1C40F}Price:{2ECC71}$%s",
                    houseid, House:GetInteriorName(houseid), FormatCurrency(House:GetPrice(houseid))
                );
            }

            HouseData[houseid][HousePickup] = CreateDynamicPickup((!for_sale) ? 19522 : 1273, 23, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
            HouseData[houseid][HouseIcon] = CreateDynamicMapIcon(HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ], (!for_sale) ? 32 : 31, 0);
            HouseData[houseid][HouseLabel] = CreateDynamic3DTextLabel(label, 0xFFFFFFFF, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ] + 0.35, 2.0);
            loaded++;
        }
        printf("  [House System] Loaded %d houses.", loaded);
    }
    return 1;
}

forward LoadFurnitures();
public LoadFurnitures() {
    new rows = cache_num_rows();
    if (rows) {
        new houseid, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", houseid);
            cache_get_value_name_int(loaded, "FurnitureID", furnituredata[houseid][FurnitureID]);
            cache_get_value_name_int(loaded, "HouseID", furnituredata[houseid][FurnitureHouseID]);
            cache_get_value_name_float(loaded, "FurnitureX", furnituredata[houseid][FurnitureX]);
            cache_get_value_name_float(loaded, "FurnitureY", furnituredata[houseid][FurnitureY]);
            cache_get_value_name_float(loaded, "FurnitureZ", furnituredata[houseid][FurnitureZ]);
            cache_get_value_name_float(loaded, "FurnitureRX", furnituredata[houseid][FurnitureRX]);
            cache_get_value_name_float(loaded, "FurnitureRY", furnituredata[houseid][FurnitureRY]);
            cache_get_value_name_float(loaded, "FurnitureRZ", furnituredata[houseid][FurnitureRZ]);
            cache_get_value_name_int(loaded, "FurnitureVW", furnituredata[houseid][FurnitureVW]);
            cache_get_value_name_int(loaded, "FurnitureInt", furnituredata[houseid][FurnitureInt]);

            furnituredata[houseid][FurnitureObjectID] = CreateDynamicObject(
                HouseFurnitures[furnituredata[houseid][FurnitureID]][ModelID],
                furnituredata[houseid][FurnitureX],
                furnituredata[houseid][FurnitureY],
                furnituredata[houseid][FurnitureZ],
                furnituredata[houseid][FurnitureRX],
                furnituredata[houseid][FurnitureRY],
                furnituredata[houseid][FurnitureRZ],
                furnituredata[houseid][FurnitureVW],
                furnituredata[houseid][FurnitureInt]
            );
            Iter_Add(FurnitureIDs, houseid);
            loaded++;
        }
        printf("  [House System] Loaded %d furnitures.", loaded);
    }

    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "houseID", "int", "-1");
    new query[1024];
    for (new houseid; houseid < MAX_HOUSES; ++houseid) {
        HouseData[houseid][HouseLabel] = Text3D:INVALID_3DTEXT_ID;
        HouseData[houseid][HousePickup] = -1;
        HouseData[houseid][HouseIcon] = -1;
    }

    for (new i; i < sizeof(HouseInteriors); ++i) {
        HouseInteriors[i][HDeviceLabel] = CreateDynamic3DTextLabel(
            "{ffffff}press {E67E22}N {ffffff}to open house menu",
            0xE67E22FF, HouseInteriors[i][deviceX], HouseInteriors[i][deviceY], HouseInteriors[i][deviceZ] + 0.35, 2.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, HouseInteriors[i][intID], -1
        );
        if (HouseInteriors[i][closetX] != 0.0) HouseInteriors[i][HClosetLabel] = CreateDynamic3DTextLabel(
            "{ffffff}press {E67E22}N {ffffff}to open closet", 0xE67E22FF,
            HouseInteriors[i][closetX], HouseInteriors[i][closetY], HouseInteriors[i][closetZ] + 0.35, 2.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, HouseInteriors[i][intID], -1
        );
        if (HouseInteriors[i][fridgeX] != 0.0) HouseInteriors[i][HFridgeLabel] = CreateDynamic3DTextLabel(
            "{ffffff}press {E67E22}N {ffffff}to open fridge", 0xE67E22FF,
            HouseInteriors[i][fridgeX], HouseInteriors[i][fridgeY], HouseInteriors[i][fridgeZ] + 0.35, 2.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, HouseInteriors[i][intID], -1
        );
        if (HouseInteriors[i][stoveX] != 0.0) HouseInteriors[i][HStoveLabel] = CreateDynamic3DTextLabel(
            "{ffffff}press {E67E22}N {ffffff}to cook food", 0xE67E22FF,
            HouseInteriors[i][stoveX], HouseInteriors[i][stoveY], HouseInteriors[i][stoveZ] + 0.35, 2.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, HouseInteriors[i][intID], -1
        );
        HouseInteriors[i][intLabel] = CreateDynamic3DTextLabel(
            "Leave House", 0xE67E22FF, HouseInteriors[i][intX], HouseInteriors[i][intY], HouseInteriors[i][intZ] + 0.35, 2.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, HouseInteriors[i][intID], -1
        );
        HouseInteriors[i][intPickup] = CreateDynamicPickup(
            19130, 23, HouseInteriors[i][intX], HouseInteriors[i][intY], HouseInteriors[i][intZ], .interiorid = HouseInteriors[i][intID]
        );
    }

    Iter_Init(HouseKeys);
    /* Create Tables */
    strcat(query, "CREATE TABLE IF NOT EXISTS `houses` (\
	  `ID` int(11) NOT NULL,\
	  `HouseName` varchar(48) NOT NULL default 'House For Sale',\
	  `HouseOwner` varchar(24) NOT NULL default '-',\
	  `HousePassword` varchar(16) NOT NULL default '-',\
	  `HouseX` float NOT NULL,\
	  `HouseY` float NOT NULL,\
	  `HouseZ` float NOT NULL,\
	  `HousePrice` int(11) NOT NULL,\
	  `HouseInterior` tinyint(4) NOT NULL default '0',\
	  `HouseLock` tinyint(4) NOT NULL default '0',\
	  `HouseMoney` int(11) NOT NULL default '0',");

    strcat(query, "`LastEntered` int(11) NOT NULL default '0',\
	      `HouseSalePrice` int(11) NOT NULL default '0',\
	      `HAutoReset` int(11) NOT NULL default '1',\
		  PRIMARY KEY  (`ID`),\
		  UNIQUE KEY `ID_2` (`ID`),\
		  KEY `ID` (`ID`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_tquery(Database, query);

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseFurnitures` (\
	  `ID` int(11) NOT NULL,\
	  `HouseID` int(11) NOT NULL,\
	  `FurnitureID` tinyint(11) NOT NULL,\
	  `FurnitureX` float NOT NULL,\
	  `FurnitureY` float NOT NULL,\
	  `FurnitureZ` float NOT NULL,\
	  `FurnitureRX` float NULL,\
	  `FurnitureRY` float NULL,\
	  `FurnitureRZ` float NULL,\
	  `FurnitureVW` int(11) NOT NULL,\
	  `FurnitureInt` int(11) NOT NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseGuns` (\
	  `HouseID` int(11) NOT NULL,\
	  `WeaponID` tinyint(4) NOT NULL,\
	  `Ammo` int(11) NOT NULL,\
	  UNIQUE KEY `HouseID_2` (`HouseID`,`WeaponID`),\
	  KEY `HouseID` (`HouseID`),\
	  CONSTRAINT `houseguns_ibfk_1` FOREIGN KEY (`HouseID`) REFERENCES `houses` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseVisitors` (\
	  `HouseID` int(11) NOT NULL,\
	  `Visitor` varchar(24) NOT NULL,\
	  `Date` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseKeys` (\
	  `HouseID` int(11) NOT NULL,\
	  `Player` varchar(24) NOT NULL,\
	  `Date` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseSafeLogs` (\
	  `HouseID` int(11) NOT NULL,\
	  `Type` int(11) NOT NULL,\
	  `Amount` int(11) NOT NULL,\
	  `Date` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `houseSales` (\
	  `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `OldOwner` varchar(24) NOT NULL,\
	  `NewOwner` varchar(24) NOT NULL,\
	  `Price` int(11) NOT NULL,\
	  PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    /* Loading & Stuff */
    mysql_tquery(Database, "SELECT * FROM houses", "LoadHouses", "");
    mysql_tquery(Database, "SELECT * FROM houseFurnitures", "LoadFurnitures", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new houseid:Houses) House:Save(houseid);
    return 1;
}

stock GetNearestHouseID(playerid) {
    foreach(new houseid:Houses) {
        if (IsPlayerInRangeOfPoint(playerid, 2, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ])) return houseid;
    }
    return -1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || GetPVarInt(playerid, "HousePickupCooldown") > gettime()) return 1;
    if (House:IsPlayerInAnyHouse(playerid) && House:IsValidID(House:GetPlayerHouseID(playerid))) {
        new houseid = House:GetPlayerHouseID(playerid);
        new houseIntId = House:GetInterior(houseid);
        if (
            House:IsPlayerOwner(playerid, houseid) &&
            IsPlayerInRangeOfPoint(playerid, 1.0, HouseInteriors[houseIntId][deviceX], HouseInteriors[houseIntId][deviceY], HouseInteriors[houseIntId][deviceZ])
        ) {
            House:AccessMenu(playerid, houseid);
            return ~1;
        } else if (
            IsPlayerInRangeOfPoint(playerid, 1.0, HouseInteriors[houseIntId][closetX], HouseInteriors[houseIntId][closetY], HouseInteriors[houseIntId][closetZ]) &&
            HouseInteriors[houseIntId][closetX] != 0.0
        ) {
            OpenClotheManage(playerid);
            return ~1;
        } else if (
            IsPlayerInRangeOfPoint(playerid, 1.0, HouseInteriors[houseIntId][fridgeX], HouseInteriors[houseIntId][fridgeY], HouseInteriors[houseIntId][fridgeZ]) &&
            HouseInteriors[houseIntId][fridgeX] != 0.0
        ) {
            HouseOpenFridge(playerid);
            return ~1;
        } else if (
            IsPlayerInRangeOfPoint(playerid, 1.0, HouseInteriors[houseIntId][stoveX], HouseInteriors[houseIntId][stoveY], HouseInteriors[houseIntId][stoveZ]) &&
            HouseInteriors[houseIntId][stoveX] != 0.0
        ) {
            HouseOpenCookMenu(playerid);
            return ~1;
        }
        for (new i; i < sizeof(HouseInteriors); ++i) {
            if (IsPlayerInRangeOfPoint(playerid, 2, HouseInteriors[i][intX], HouseInteriors[i][intY], HouseInteriors[i][intZ])) {
                SetPVarInt(playerid, "HousePickupCooldown", gettime() + HOUSE_COOLDOWN);
                House:SetPlayerHouseID(playerid, INVALID_HOUSE_ID);
                SetPlayerVirtualWorldEx(playerid, 0);
                SetPlayerInteriorEx(playerid, 0);
                SetPlayerPosEx(playerid, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
                return ~1;
            }
        }
    } else {
        new houseid = GetNearestHouseID(playerid);
        if (House:IsValidID(houseid)) {
            SetPVarInt(playerid, "HousePickupCooldown", gettime() + HOUSE_COOLDOWN);
            if (!House:IsPurchased(houseid)) {
                if (GetPlayerScore(playerid) < HousePurchaseScore)
                    AlexaMsg(playerid, "you need at least 50 score to purchase house.", "Error", "4286f4");
                else House:MenuBuyOffer(playerid, houseid);
                return ~1;
            } else {
                if (House:GetSalePrice(houseid) > 0 && !House:IsPlayerOwner(playerid, houseid)) {
                    if (GetPlayerScore(playerid) < HousePurchaseScore)
                        AlexaMsg(playerid, "you need at least 50 score to purchase house.", "Error", "4286f4");
                    else House:MenuSaleOffer(playerid, houseid);
                    return ~1;
                }

                new allowedFactions[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
                if (
                    GetPlayerRPMode(playerid) &&
                    IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) &&
                    Faction:IsPlayerSigned(playerid) && Faction:GetPlayerRankID(playerid) < 4 &&
                    House:WantedPlayersInHouse(houseid, true) > 0 && GetPlayerWeapon(playerid) == 31
                ) {
                    AlexaMsg(playerid, "you have entered this house in roleplay mode, the house lock system has been bypassed");
                    House:SendTo(playerid, houseid);
                    return ~1;
                }

                switch (House:GetLockMode(houseid)) {
                    case LOCK_MODE_NOLOCK:
                        House:SendTo(playerid, houseid);
                    case LOCK_MODE_PASSWORD:
                        House:MenuPasswordAsk(playerid, houseid);
                    case LOCK_MODE_KEYS:  {
                        if (House:IsPlayerOwner(playerid, houseid) || House:IsHaveKey(playerid, houseid)) House:SendTo(playerid, houseid);
                        else AlexaMsg(playerid, "You don't have keys for this house, you can't enter.", "Error", "4286f4");
                    }
                    case LOCK_MODE_OWNER:  {
                        if (House:IsPlayerOwner(playerid, houseid)) House:SendTo(playerid, houseid);
                        else AlexaMsg(playerid, "Sorry, only the owner can enter this house.", "Error", "4286f4");
                    }
                }
                return ~1;
            }
        }
    }
    return 1;
}

hook OnPlayerSelectDynObj(playerid, objectid, modelid, Float:x, Float:y, Float:z) {
    switch (SelectMode[playerid]) {
        case SELECT_MODE_EDIT:  {
            new bool:fstatus = false, furnitureid;
            foreach(new i:FurnitureIDs) {
                if (furnituredata[i][FurnitureObjectID] == objectid) {
                    furnitureid = i;
                    fstatus = true;
                }
            }
            if (!fstatus) return AlexaMsg(playerid, "You can not edit this furniture.", "Error", "4286f4");
            SetPVarInt(playerid, "SelectedFurnitureID", furnitureid);
            House:SetEditingFurniture(playerid, false);
            EditDynamicObject(playerid, objectid);
        }
        case SELECT_MODE_SELL: House:MenuSellFurniture(playerid, objectid);
    }
    SelectMode[playerid] = SELECT_MODE_NONE;
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (EditingFurniture[playerid]) {
        switch (response) {
            case EDIT_RESPONSE_CANCEL:  {
                new furnitureid = GetPVarInt(playerid, "SelectedFurnitureID");
                if (!House:IsValidFurnitureID(furnitureid)) return 1;
                SetDynamicObjectPos(objectid, furnituredata[furnitureid][FurnitureX], furnituredata[furnitureid][FurnitureY], furnituredata[furnitureid][FurnitureZ]);
                SetDynamicObjectRot(objectid, furnituredata[furnitureid][FurnitureRX], furnituredata[furnitureid][FurnitureRY], furnituredata[furnitureid][FurnitureRZ]);
                House:SetEditingFurniture(playerid, false);
            }

            case EDIT_RESPONSE_FINAL:  {
                new furnitureid = GetPVarInt(playerid, "SelectedFurnitureID");
                if (!House:IsValidFurnitureID(furnitureid)) return 1;
                furnituredata[furnitureid][FurnitureX] = x;
                furnituredata[furnitureid][FurnitureY] = y;
                furnituredata[furnitureid][FurnitureZ] = z;
                furnituredata[furnitureid][FurnitureRX] = rx;
                furnituredata[furnitureid][FurnitureRY] = ry;
                furnituredata[furnitureid][FurnitureRZ] = rz;
                SetDynamicObjectPos(objectid, furnituredata[furnitureid][FurnitureX], furnituredata[furnitureid][FurnitureY], furnituredata[furnitureid][FurnitureZ]);
                SetDynamicObjectRot(objectid, furnituredata[furnitureid][FurnitureRX], furnituredata[furnitureid][FurnitureRY], furnituredata[furnitureid][FurnitureRZ]);

                mysql_tquery(Database, sprintf(
                    "UPDATE houseFurnitures SET FurnitureX=%f, FurnitureY=%f, FurnitureZ=%f, FurnitureRX=%f, FurnitureRY=%f, FurnitureRZ=%f WHERE ID=%d",
                    furnituredata[furnitureid][FurnitureX],
                    furnituredata[furnitureid][FurnitureY],
                    furnituredata[furnitureid][FurnitureZ],
                    furnituredata[furnitureid][FurnitureRX],
                    furnituredata[furnitureid][FurnitureRY],
                    furnituredata[furnitureid][FurnitureRZ],
                    furnitureid
                ));

                House:SetEditingFurniture(playerid, false);
            }
        }
    }
    return 1;
}

hook OnPlayerImairedRequest(playerid) {
    House:SetPlayerHouseID(playerid, INVALID_HOUSE_ID);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `houseKeys` SET `Player` = \"%s\" WHERE  `Player` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `houses` SET `HouseOwner` = \"%s\" WHERE  `HouseOwner` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `houseSales` SET `OldOwner` = \"%s\" WHERE  `OldOwner` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `houseSales` SET `NewOwner` = \"%s\" WHERE  `NewOwner` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `houseVisitors` SET `Visitor` = \"%s\" WHERE  `Visitor` = \"%s\"", NewName, OldName));
    foreach(new houseid:Houses) {
        if (House:IsOwner(houseid, OldName)) {
            House:SetOwner(houseid, NewName);
            House:UpdateLabel(houseid);
        }
    }
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    foreach(new houseid:Houses) if (House:IsOwner(houseid, AccountName)) House:Reset(houseid);
    mysql_tquery(Database, sprintf("DELETE FROM `houseKeys` WHERE `Player` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `houses` WHERE `HouseOwner` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `houseSales` WHERE `OldOwner` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `houseSales` WHERE `NewOwner` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `houseVisitors` WHERE `Visitor` = \"%s\"", AccountName));
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "house system") && GetPlayerAdminLevel(playerid) >= 8) {
        House:AdminMenu(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "viphouseint")) {
        if (GetPlayerVIPLevel(playerid) < 2) { AlexaMsg(playerid, "you required level 2+ access for this action", "Error", "4286f4"); return ~1; }
        new houseid = House:GetPlayerHouseID(playerid);
        if (!House:IsPlayerInOwnHouse(playerid)) { AlexaMsg(playerid, "you are not in your house", "House"); return ~1; }
        new interior;
        if (sscanf(GetNextWordFromString(text, "viphouseint"), "d", interior)) {
            AlexaMsg(playerid, "Provide Interior ID", "House");
            return ~1;
        }
        if (interior < 0 || interior >= sizeof HouseInteriors) { AlexaMsg(playerid, "Invalid Interior ID", "House"); return ~1; }
        HouseData[houseid][Interior] = interior;
        mysql_tquery(Database, sprintf("UPDATE houses SET HouseInterior=%d WHERE ID=%d", interior, houseid));
        House:UpdateLabel(houseid);
        House:SendTo(playerid, houseid);
        House:Save(houseid);
        AlexaMsg(playerid, "House Interior Updated", "House");
        return ~1;
    }
    return 1;
}

stock House:MenuSellFurniture(playerid, objectid) {
    if (!House:IsPlayerInAnyHouse(playerid) || !House:IsPlayerOwner(playerid, House:GetPlayerHouseID(playerid))) return 1;
    new bool:fstatus = false, furnitureid;
    foreach(new i:FurnitureIDs) {
        if (furnituredata[i][FurnitureObjectID] == objectid) {
            furnitureid = i;
            fstatus = true;
        }
    }
    if (!fstatus) return AlexaMsg(playerid, "You can not sell this furniture", "Error", "4286f4");
    CancelEdit(playerid);

    SetPVarInt(playerid, "SelectedFurniture", furnitureid);
    FlexPlayerDialog(playerid, "HouseFurnitureSellConfirm", DIALOG_STYLE_MSGBOX, "Confirm Sale",
        sprintf("Do you want to sell your %s?\nYou'll get {2ECC71}$%s.", House:GetFurnitureName(furnitureid), FormatCurrency(House:GetFurniturePrice(furnitureid))),
        "Sell", "Close"
    );
    return 1;
}

FlexDialog:HouseFurnitureSellConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (!House:IsPlayerInAnyHouse(playerid) || !House:IsPlayerOwner(playerid, House:GetPlayerHouseID(playerid))) return 1;
    new furnitureid = GetPVarInt(playerid, "SelectedFurniture");
    if (!House:IsValidFurnitureID(furnitureid)) return AlexaMsg(playerid, "can not find your furniture.", "House");
    if (House:GetSalePrice(House:GetFurnitureHouseID(furnitureid)) > 0) return AlexaMsg(playerid, "You can't use this feature while the house is for sale.", "House");
    new price = GetPercentageOf(RandomEx(50, 80), House:GetFurniturePrice(furnitureid));
    if (price > 0) vault:PlayerVault(playerid, price, sprintf("sold furniture: %s", House:GetFurnitureName(furnitureid)),
        Vault_ID_Government, price, sprintf("%s sold furniture: %s", GetPlayerNameEx(playerid), House:GetFurnitureName(furnitureid))
    );
    mysql_tquery(Database, sprintf("DELETE FROM houseFurnitures WHERE ID=%d", furnitureid));
    DestroyDynamicObjectEx(furnituredata[furnitureid][FurnitureObjectID]);
    furnituredata[furnitureid][FurnitureObjectID] = -1;
    DeletePVar(playerid, "SelectedFurniture");
    Iter_Remove(FurnitureIDs, furnitureid);
    return 1;
}

stock House:MenuPasswordAsk(playerid, houseid) {
    return FlexPlayerDialog(
        playerid, "HouseMenuPassword", DIALOG_STYLE_INPUT, "House Password", "This house is password protected.\n\nEnter house password:", "Done", "Close", houseid
    );
}

FlexDialog:HouseMenuPassword(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return 1;
    if (!House:IsValidID(houseid)) return 1;
    if (!IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ])) {
        return AlexaMsg(playerid, "You're not near any house.", "Error", "4286f4", "E74C3C");
    }
    if (!(1 <= strlen(inputtext) <= MAX_HOUSE_PASSWORD)) return House:MenuPasswordAsk(playerid, houseid);
    if (!House:IsPasswordValid(houseid, inputtext)) {
        AlexaMsg(playerid, "Invalid Password, try again", "House");
        return House:MenuPasswordAsk(playerid, houseid);
    }
    return House:SendTo(playerid, houseid);
}

stock House:MenuBuyOffer(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuBuyOffer", DIALOG_STYLE_MSGBOX, "House For Sale",
        sprintf("This house is for sale!\n\nPrice: {2ECC71}$%s", FormatCurrency(House:GetPrice(houseid))),
        "Buy", "Close", houseid
    );
}

FlexDialog:HouseMenuBuyOffer(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return 1;
    if (House:IsPurchased(houseid)) return AlexaMsg(playerid, "someone already bought the house", "House");
    if (House:GetOwnedCount(playerid) >= House:GetLimit(playerid)) return AlexaMsg(playerid, "your house limit reached, buy vip to extend limit", "House");
    if (GetPlayerCash(playerid) < House:GetPrice(houseid)) return AlexaMsg(playerid, "You can't afford this house.", "House");
    vault:PlayerVault(
        playerid, -House:GetPrice(houseid), sprintf("bought new house, address: %s", House:GetAddress(houseid)),
        Vault_ID_Government, House:GetPrice(houseid), sprintf("%s: bought new house, address: %s", GetPlayerNameEx(playerid), House:GetAddress(houseid))
    );
    House:SetOwner(houseid, GetPlayerNameEx(playerid));
    HouseData[houseid][LockMode] = LOCK_MODE_NOLOCK;
    HouseData[houseid][LastEntered] = gettime();
    HouseData[houseid][HAutoReset] = 1;

    House:UpdateLabel(houseid);
    House:Save(houseid);
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, HouseData[houseid][HousePickup], E_STREAMER_MODEL_ID, 19522);
    Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, HouseData[houseid][HouseIcon], E_STREAMER_TYPE, 32);
    House:SendTo(playerid, houseid);
    return 1;
}

stock House:MenuSaleOffer(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuSaleOffer", DIALOG_STYLE_MSGBOX, "House For Sale",
        sprintf("This house is for sale!\n\nPrice: {2ECC71}$%s", FormatCurrency(House:GetSalePrice(houseid))),
        "Buy", "Close", houseid
    );
}

FlexDialog:HouseMenuSaleOffer(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return 1;
    if (!House:IsPurchased(houseid)) return AlexaMsg(playerid, "house is property of government department, you can't buy it", "House");
    if (House:GetOwnedCount(playerid) >= House:GetLimit(playerid)) return AlexaMsg(playerid, "your house limit reached, buy vip to extend limit", "House");
    if (GetPlayerCash(playerid) < House:GetSalePrice(houseid)) return AlexaMsg(playerid, "You can't afford this house.", "House");

    new ownerid = GetPlayerIDByName(House:GetOwner(houseid));
    if (IsPlayerConnected(ownerid)) {
        GivePlayerCash(ownerid, House:GetSalePrice(houseid), sprintf("house sold on sale by %s, address: %s", GetPlayerNameEx(playerid), House:GetAddress(houseid)));
        AlexaMsg(ownerid, sprintf("%s (%d) has bought your house at %s for $%s", GetPlayerNameEx(playerid), House:GetAddress(houseid), House:GetSalePrice(houseid)), "House");
    } else {
        mysql_tquery(Database, sprintf(
            "INSERT INTO houseSales SET OldOwner = \"%s\", NewOwner = \"%s\", Price=%d",
            House:GetOwner(houseid), GetPlayerNameEx(playerid), House:GetSalePrice(houseid)
        ));
    }

    vault:PlayerVault(
        playerid, -House:GetSalePrice(houseid), sprintf("bought house from %s, address: %s", House:GetOwner(houseid), House:GetAddress(houseid)),
        Vault_ID_Government, House:GetSalePrice(houseid), sprintf(
            "%s: bought house from %s, address: %s", GetPlayerNameEx(playerid), House:GetOwner(houseid), House:GetAddress(houseid)
        )
    );

    House:SetOwner(houseid, GetPlayerNameEx(playerid));
    HouseData[houseid][SafeMoney] = 0;
    HouseData[houseid][LockMode] = LOCK_MODE_NOLOCK;
    HouseData[houseid][LastEntered] = gettime();
    HouseData[houseid][HAutoReset] = 1;

    House:UpdateLabel(houseid);
    House:Save(houseid);
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, HouseData[houseid][HousePickup], E_STREAMER_MODEL_ID, 19522);
    Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, HouseData[houseid][HouseIcon], E_STREAMER_TYPE, 32);
    House:SendTo(playerid, houseid);

    mysql_tquery(Database, sprintf("DELETE FROM houseVisitors WHERE HouseID=%d", houseid));
    mysql_tquery(Database, sprintf("DELETE FROM houseKeys WHERE HouseID=%d", houseid));
    mysql_tquery(Database, sprintf("DELETE FROM houseSafeLogs WHERE HouseID=%d", houseid));
    return 1;
}

stock House:AccessMenu(playerid, houseid) {
    new string[1024];
    strcat(string, sprintf("House Name\t%s\n", House:GetName(houseid)));
    strcat(string, sprintf("Password\t%s\n", House:GetPassword(houseid)));
    strcat(string, sprintf("Lock\t%s\n", House:GetLockName(houseid)));
    strcat(string, sprintf("House Safe\t{2ECC71}($%s)\n", FormatCurrency(House:GetSafeMoney(houseid))));
    strcat(string, "Furnitures\n");
    strcat(string, "Guns\n");
    strcat(string, "Visitors\n");
    strcat(string, "Keys\n");
    strcat(string, "Kick Everybody\n");
    strcat(string, "Sell House\n");
    return FlexPlayerDialog(playerid, "HouseAccessMenu", DIALOG_STYLE_TABLIST, "House Menu", string, "Select", "Close", houseid);
}

FlexDialog:HouseAccessMenu(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "House Name")) return House:MenuUpdateName(playerid, houseid);
    if (IsStringSame(inputtext, "Password")) return House:MenuUpdatePassword(playerid, houseid);
    if (IsStringSame(inputtext, "Lock")) return House:MenuUpdateLock(playerid, houseid);
    if (IsStringSame(inputtext, "House Safe")) return House:MenuSafe(playerid, houseid);
    if (IsStringSame(inputtext, "Furnitures")) return House:MenuFurnitures(playerid, houseid);
    if (IsStringSame(inputtext, "Guns")) return House:MenuGuns(playerid, houseid);
    if (IsStringSame(inputtext, "Visitors")) return House:MenuVistors(playerid, houseid);
    if (IsStringSame(inputtext, "Keys")) return House:MenuKeys(playerid, houseid);
    if (IsStringSame(inputtext, "Kick Everybody")) {
        foreach(new i:Player) {
            if (i == playerid) continue;
            if (House:GetPlayerHouseID(i) == houseid) {
                House:SetPlayerHouseID(i, INVALID_HOUSE_ID);
                SetPVarInt(i, "HousePickupCooldown", gettime() + HOUSE_COOLDOWN);
                SetPlayerVirtualWorldEx(i, 0);
                SetPlayerInteriorEx(i, 0);
                SetPlayerPosEx(i, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
                AlexaMsg(i, sprintf("%s kicked everybody from the house.", GetPlayerNameEx(playerid)), "House");
            }
        }
        AlexaMsg(playerid, "You kicked everybody from your house.", "House");
        return House:AccessMenu(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Sell House")) {
        if (!House:IsPlayerOwner(playerid, houseid)) {
            AlexaMsg(playerid, "Only house owner can sell house.", "House");
            return House:AccessMenu(playerid, houseid);
        }
        House:SellMenu(playerid, houseid);
    }
    return 1;
}

stock House:MenuFurnitures(playerid, houseid) {
    new string[512];
    strcat(string, "Buy Furniture\n");
    strcat(string, "Edit Furniture\n");
    strcat(string, "Sell Furniture\n");
    strcat(string, "Sell All Furnitures\n");
    return FlexPlayerDialog(playerid, "HouseMenuFurnitures", DIALOG_STYLE_LIST, "Furnitures", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuFurnitures(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "Buy Furniture")) return House:MenuBuyFurniture(playerid, houseid);
    if (IsStringSame(inputtext, "Edit Furniture")) {
        SelectMode[playerid] = SELECT_MODE_EDIT;
        SelectObject(playerid);
        return AlexaMsg(playerid, "click on the furniture you want to edit.", "House");
    }
    if (IsStringSame(inputtext, "Sell Furniture")) {
        SelectMode[playerid] = SELECT_MODE_SELL;
        SelectObject(playerid);
        return AlexaMsg(playerid, "click on the furniture you want to sell.", "House");
    }
    if (IsStringSame(inputtext, "Sell All Furnitures")) return House:SellAllFurniture(playerid, houseid);
    return 1;
}

stock House:MenuBuyFurniture(playerid, houseid) {
    new string[512];
    strcat(string, "#\tFurniture Name\tPrice\n");
    for (new staticFurnitureID; staticFurnitureID < (sizeof HouseFurnitures); staticFurnitureID++) {
        strcat(string, sprintf("%d\t%s\t$%s\n",
            staticFurnitureID,
            House:GetStaticFurnitureName(staticFurnitureID),
            FormatCurrency(House:GetStaticFurniturePrice(staticFurnitureID))
        ));
    }
    return FlexPlayerDialog(playerid, "HousePurchaseFurniture", DIALOG_STYLE_TABLIST_HEADERS, "Buy Furniture", string, "Buy", "Back", houseid);
}

FlexDialog:HousePurchaseFurniture(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuFurnitures(playerid, houseid);
    new staticFurnitureID = listitem;
    new furnitureid = Iter_Free(FurnitureIDs);
    if (furnitureid == INVALID_ITERATOR_SLOT) {
        return AlexaMsg(playerid, "Current furniture limit in server exceeded, Contact In-Game admin for more support.", "House");
    }
    Iter_Add(FurnitureIDs, furnitureid);

    GivePlayerCash(playerid, -House:GetStaticFurniturePrice(staticFurnitureID),
        sprintf("bought furniture (%s) in house [%d] at %s", House:GetStaticFurnitureName(staticFurnitureID), houseid, House:GetAddress(houseid))
    );
    vault:addcash(Vault_ID_Government, House:GetStaticFurniturePrice(staticFurnitureID), Vault_Transaction_Cash_To_Vault,
        sprintf("%s bought furniture (%s) in house [%d] at %s", GetPlayerNameEx(playerid), House:GetStaticFurnitureName(staticFurnitureID), houseid, House:GetAddress(houseid))
    );

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    GetXYInFrontOfPlayer(playerid, x, y, 3.0);
    new objectid = CreateDynamicObject(HouseFurnitures[listitem][ModelID], x, y, z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    mysql_tquery(Database,
        sprintf(
            "INSERT INTO houseFurnitures SET ID = %d, HouseID=%d, FurnitureID=%d, FurnitureX=%f, FurnitureY=%f, FurnitureZ=%f, FurnitureVW=%d, \
            FurnitureInt=%d, FurnitureRX = 0.0, FurnitureRY = 0.0, FurnitureRZ = 0.0",
            furnitureid, houseid, staticFurnitureID, x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)
        )
    );

    furnituredata[furnitureid][FurnitureID] = staticFurnitureID;
    furnituredata[furnitureid][FurnitureHouseID] = houseid;
    furnituredata[furnitureid][FurnitureX] = x;
    furnituredata[furnitureid][FurnitureY] = y;
    furnituredata[furnitureid][FurnitureZ] = z;
    furnituredata[furnitureid][FurnitureRX] = 0.0;
    furnituredata[furnitureid][FurnitureRY] = 0.0;
    furnituredata[furnitureid][FurnitureRZ] = 0.0;
    furnituredata[furnitureid][FurnitureVW] = GetPlayerVirtualWorld(playerid);
    furnituredata[furnitureid][FurnitureInt] = GetPlayerInterior(playerid);
    furnituredata[furnitureid][FurnitureObjectID] = objectid;

    EditingFurniture[playerid] = true;
    EditDynamicObject(playerid, objectid);
    return 1;
}

stock House:SellAllFurniture(playerid, houseid) {
    if (House:GetSalePrice(houseid) > 0) {
        AlexaMsg(playerid, "You can't use this feature while the house is for sale.", "House");
        return House:MenuFurnitures(playerid, houseid);
    }
    DeletePVar(playerid, "SelectedFurniture");

    new soldcount = 0, earnamount = 0;
    foreach(new furnitureid:FurnitureIDs) {
        if (House:GetFurnitureHouseID(furnitureid) == houseid) {
            soldcount++;
            new price = GetPercentageOf(RandomEx(50, 80), House:GetFurniturePrice(furnitureid));
            if (price > 0) earnamount += price;
            DestroyDynamicObjectEx(furnituredata[furnitureid][FurnitureObjectID]);
            furnituredata[furnitureid][FurnitureObjectID] = -1;
            mysql_tquery(Database, sprintf("DELETE FROM houseFurnitures WHERE ID = %d", furnitureid));
            AlexaMsg(playerid, sprintf("sold %s", House:GetFurnitureName(furnitureid)), "House");
            Iter_SafeRemove(FurnitureIDs, furnitureid, furnitureid);
        }
    }

    if (earnamount > 0) vault:PlayerVault(
        playerid, earnamount, sprintf("sold total %d furnitures to government from house [%d] at %s", soldcount, houseid, House:GetAddress(houseid)),
        Vault_ID_Government, earnamount, sprintf(
            "%s: sold total %d furnitures to government from house [%d] at %s", GetPlayerNameEx(playerid), soldcount, houseid, House:GetAddress(houseid)
        )
    );

    AlexaMsg(playerid, sprintf("sold total %d furnitures to government from house [%d] at %s", soldcount, houseid, House:GetAddress(houseid)), "House");
    return House:MenuFurnitures(playerid, houseid);
}

stock House:GetWeaponAmmo(houseid, weaponid) {
    if (!IsValidWeaponID(weaponid)) return 0;
    new Cache:weapon = mysql_query(Database, sprintf("select ammo from houseGuns where HouseID = %d and WeaponID = %d limit 1", houseid, weaponid));
    new rows = cache_num_rows();
    new ammo = 0;
    if (rows) cache_get_value_name_int(0, "ammo", ammo);
    cache_delete(Cache:weapon);
    return ammo;
}

stock House:IncreaseWeaponAmmo(houseid, weaponid, ammo) {
    mysql_tquery(Database, sprintf("insert into houseGuns values (%d, %d, %d) on duplicate key update ammo = ammo + %d", houseid, weaponid, ammo, ammo));
    return 1;
}

stock House:MenuGuns(playerid, houseid) {
    new string[512];
    strcat(string, "Put Gun\n");
    strcat(string, "Take Gun\n");
    return FlexPlayerDialog(playerid, "HouseMenuGuns", DIALOG_STYLE_LIST, "Guns", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuGuns(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "Put Gun")) return House:MenuPutGun(playerid, houseid);
    if (IsStringSame(inputtext, "Take Gun")) return House:MenuTakeGun(playerid, houseid);
    return 1;
}

stock House:MenuTakeGun(playerid, houseid) {
    new Cache:weapons = mysql_query(Database, sprintf("SELECT WeaponID, Ammo FROM houseGuns WHERE HouseID=%d ORDER BY WeaponID ASC", houseid));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(Cache:weapons);
        AlexaMsg(playerid, "There is no weapon in house safe.", "House");
        return House:MenuGuns(playerid, houseid);
    }

    new string[2000], weaponid, weapon_ammo;
    strcat(string, "#\tWeapon Name\tAmmo\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "WeaponID", weaponid);
        cache_get_value_name_int(i, "Ammo", weapon_ammo);
        strcat(string, sprintf("%d\t%s\t%s\n", weaponid, GetWeaponNameEx(weaponid), FormatCurrency(weapon_ammo)));
    }
    return FlexPlayerDialog(playerid, "HouseMenuTakeGun", DIALOG_STYLE_TABLIST_HEADERS, "Take Gun", string, "Take", "Cancel", houseid);
}

// uncomplete
FlexDialog:HouseMenuTakeGun(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    new weaponid = strval(inputtext);
    if (!response || !IsValidWeaponID(weaponid)) return House:MenuGuns(playerid, houseid);
    return House:MenuTakeGunAmmo(playerid, houseid, weaponid);
}

stock House:MenuTakeGunAmmo(playerid, houseid, weaponid) {
    if (!IsValidWeaponID(weaponid)) return House:MenuGuns(playerid, houseid);
    new houseammo = House:GetWeaponAmmo(houseid, weaponid);
    if (houseammo < 1 || houseammo > 8000) {
        AlexaMsg(playerid, "house does not have ammo for selected weapon, please put some ammo first.", "House");
        return House:MenuGuns(playerid, houseid);
    }
    return FlexPlayerDialog(playerid, "HouseMenuTakeGunAmmo", DIALOG_STYLE_INPUT, sprintf("Take out %s", GetWeaponNameEx(weaponid)),
        sprintf("Enter ammo between 1 and %d", houseammo), "Take", "Cancel", houseid, sprintf("%d", weaponid)
    );
}

FlexDialog:HouseMenuTakeGunAmmo(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    new weaponid = strval(payload);
    new houseammo = House:GetWeaponAmmo(houseid, weaponid);
    if (!response || !IsValidWeaponID(weaponid)) return House:MenuGuns(playerid, houseid);
    new takeammo;
    if (sscanf(inputtext, "d", takeammo) || takeammo < 1 || takeammo > houseammo) return House:MenuTakeGunAmmo(playerid, houseid, weaponid);
    GivePlayerWeaponEx(playerid, weaponid, takeammo);
    House:IncreaseWeaponAmmo(houseid, weaponid, -takeammo);
    AlexaMsg(playerid, sprintf("you have taken %s weapon with ammo %d from house safe", GetWeaponNameEx(weaponid), takeammo), "House");
    return House:MenuGuns(playerid, houseid);
}

stock House:MenuPutGun(playerid, houseid) {
    new weaponid = GetPlayerWeapon(playerid);
    new ammo = GetPlayerAmmo(playerid);
    if (!IsValidWeaponID(weaponid) || GetPlayerAmmo(playerid) < 1) {
        AlexaMsg(playerid, "Take a weapon in your hand to put in house safe.", "House");
        return House:MenuGuns(playerid, houseid);
    }
    return FlexPlayerDialog(playerid, "HouseMenuPutGun", DIALOG_STYLE_INPUT, sprintf("Put %s in house", GetWeaponNameEx(weaponid)),
        sprintf("Enter ammo between 1 to %d to put in house", ammo), "Put", "Cancel", houseid
    );
}

FlexDialog:HouseMenuPutGun(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuGuns(playerid, houseid);
    new weaponid = GetPlayerWeapon(playerid);
    new ammo = GetPlayerAmmo(playerid);
    if (!IsValidWeaponID(weaponid) || GetPlayerAmmo(playerid) < 1) {
        AlexaMsg(playerid, "Take a weapon in your hand to put in house safe.", "House");
        return House:MenuGuns(playerid, houseid);
    }
    new putammo = 0;
    if (sscanf(inputtext, "d", putammo) || putammo < 1 || putammo > ammo) return House:MenuPutGun(playerid, houseid);
    new houseammo = House:GetWeaponAmmo(houseid, weaponid);
    if (houseammo + putammo > 8000) {
        AlexaMsg(playerid, sprintf("maximum ammo in house reached, you can not store more ammo of %s weapon.", GetWeaponNameEx(weaponid)), "House");
        return House:MenuPutGun(playerid, houseid);
    }
    if (ammo == putammo) RemovePlayerWeapon(playerid, weaponid);
    else GivePlayerWeaponEx(playerid, weaponid, -putammo);
    House:IncreaseWeaponAmmo(houseid, weaponid, putammo);
    AlexaMsg(playerid, sprintf("you have put %s weapon with ammo %d in house safe", GetWeaponNameEx(weaponid), putammo), "House");
    return House:MenuGuns(playerid, houseid);
}

stock House:MenuKeys(playerid, houseid) {
    new string[512];
    strcat(string, "View Key Owners\n");
    strcat(string, "Change Locks\n");
    strcat(string, "Manage Keys\n");
    return FlexPlayerDialog(playerid, "HouseMenuKeys", DIALOG_STYLE_LIST, "Keys", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuKeys(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "View Key Owners")) {
        new total = House:GetTotalKeyOwners(houseid);
        if (total == 0) {
            AlexaMsg(playerid, "Can't find any key owners.", "House");
            return House:MenuKeys(playerid, houseid);
        }
        return House:MenuViewKeyOwners(playerid, houseid, total);
    }
    if (IsStringSame(inputtext, "Change Locks")) return House:MenuChangeLock(playerid, houseid);
    if (IsStringSame(inputtext, "Manage Keys")) return House:MenuManageKey(playerid, houseid);
    return 1;
}

stock House:MenuViewKeyOwners(playerid, houseid, total = 0, page = 0) {
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:keyowners = mysql_query(Database, sprintf(
        "SELECT Player, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i') as KeyDate FROM houseKeys WHERE HouseID=%d ORDER BY Date DESC LIMIT %d, %d",
        houseid, skip, perpage
    ));

    new rows = cache_num_rows();
    if (total == 0 || rows == 0) {
        cache_delete(Cache:keyowners);
        AlexaMsg(playerid, "Can't find any key owners.", "House");
        return House:MenuKeys(playerid, houseid);
    }

    new string[2000], key_name[MAX_PLAYER_NAME], key_date[20];
    strcat(string, "Key Owner\tKey Given On\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name(i, "Player", key_name);
        cache_get_value_name(i, "KeyDate", key_date);
        strcat(string, sprintf("%s\t%s\n", key_name, key_date));
    }
    cache_delete(Cache:keyowners);

    if (remaining > 0) strcat(string, "Next Page");
    if (page > 0) strcat(string, "Back Page");
    return FlexPlayerDialog(
        playerid, "HouseMenuViewKeyOwners", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Key Owners | Page: %d", page), string, "Select", "Close",
        houseid, sprintf("%d %d", page, total)
    );
}

FlexDialog:HouseMenuViewKeyOwners(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    new page, total;
    sscanf(payload, "d d", page, total);
    if (!response) return House:MenuKeys(playerid, houseid);
    if (IsStringSame(inputtext, "Next Page")) return House:MenuViewKeyOwners(playerid, houseid, total, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return House:MenuViewKeyOwners(playerid, houseid, total, page - 1);
    return House:MenuKeys(playerid, houseid);
}

stock House:MenuChangeLock(playerid, houseid) {
    foreach(new i:Player) {
        if (House:IsHaveKey(i, houseid)) {
            House:TakeKey(i, houseid);
            AlexaMsg(i, sprintf("House owner %s has taken your keys for their house %s.", House:GetOwner(houseid), House:GetName(houseid)));
        }
    }
    mysql_tquery(Database, sprintf("DELETE FROM houseKeys WHERE HouseID = %d", houseid));
    AlexaMsg(playerid, "house lock changed, all keys taken from players.", "House");
    return House:MenuKeys(playerid, houseid);
}

stock House:MenuManageKey(playerid, houseid) {
    new string[512];
    strcat(string, "Give House Keys\n");
    strcat(string, "Take House Keys\n");
    return FlexPlayerDialog(playerid, "HouseMenuManageKey", DIALOG_STYLE_LIST, "Manage Keys", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuManageKey(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuKeys(playerid, houseid);
    if (IsStringSame(inputtext, "Give House Keys")) return House:MenuGiveKey(playerid, houseid);
    if (IsStringSame(inputtext, "Take House Keys")) return House:MenuTakeKey(playerid, houseid);
    return 1;
}

stock House:IsAccountHaveKey(houseid, const account[]) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select count(*) as total from houseKeys where HouseID = %d and Player = \"%s\"", houseid, account));
    new total = -1;
    cache_get_value_name_int(0, "total", total);
    cache_delete(mysql_cache);
    return total;

}

stock House:GetTotalKeyOwners(houseid) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select count(*) as total from houseKeys where HouseID = %d", houseid));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(mysql_cache);
    return total;
}

stock House:MenuGiveKey(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuGiveKey", DIALOG_STYLE_INPUT, "Give Key", "Enter player name to give keys", "Submit", "Cancel", houseid);
}

FlexDialog:HouseMenuGiveKey(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuManageKey(playerid, houseid);
    new account[100];
    if (sscanf(inputtext, "s[100]", account) || IsStringSame(GetPlayerNameEx(playerid), account) || !IsValidAccount(account)) return House:MenuGiveKey(playerid, houseid);
    if (House:IsAccountHaveKey(houseid, account)) AlexaMsg(playerid, sprintf("%s already have your house key", account), "House");
    else {
        new friendid = GetPlayerIDByName(account);
        if (IsPlayerConnected(friendid)) {
            House:GiveKey(friendid, houseid);
            AlexaMsg(friendid, sprintf("Now you have keys for %s's house, %s.", House:GetOwner(houseid), House:GetName(houseid)));
        }
        mysql_tquery(Database, sprintf("INSERT INTO houseKeys SET HouseID = %d, Player = \"%s\", Date = UNIX_TIMESTAMP()", houseid, account));
        AlexaMsg(playerid, sprintf("You've given keys to %s for this house.", account));
    }
    return House:MenuManageKey(playerid, houseid);
}

stock House:MenuTakeKey(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuTakeKey", DIALOG_STYLE_INPUT, "Take Key", "Enter player name to take keys", "Submit", "Cancel", houseid);
}

FlexDialog:HouseMenuTakeKey(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuManageKey(playerid, houseid);
    new account[100];
    if (sscanf(inputtext, "s[100]", account) || IsStringSame(GetPlayerNameEx(playerid), account) || !IsValidAccount(account)) return House:MenuGiveKey(playerid, houseid);
    if (!House:IsAccountHaveKey(houseid, account)) AlexaMsg(playerid, sprintf("%s doesn't have keys for this house", account), "House");
    else {
        new friendid = GetPlayerIDByName(account);
        if (IsPlayerConnected(friendid)) {
            House:TakeKey(friendid, houseid);
            AlexaMsg(friendid, sprintf("House owner %s has taken your keys for their house %s.", House:GetOwner(houseid), House:GetName(houseid)));
        }
        mysql_tquery(Database, sprintf("delete from houseKeys where HouseID = %d and Player = \"%s\"", houseid, account));
        AlexaMsg(playerid, sprintf("You've takens keys from %s for this house.", account));
    }
    return House:MenuManageKey(playerid, houseid);
}

stock House:MenuVistors(playerid, houseid) {
    new string[512];
    strcat(string, "Look Visitor History\n");
    strcat(string, "Clear Visitor History\n");
    return FlexPlayerDialog(playerid, "HouseMenuVistors", DIALOG_STYLE_LIST, "Visitors", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuVistors(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "Look Visitor History")) return House:MenuViewVistors(playerid, houseid);
    if (IsStringSame(inputtext, "Clear Visitor History")) {
        mysql_tquery(Database, sprintf("DELETE FROM houseVisitors WHERE HouseID = %d", houseid));
        AlexaMsg(playerid, "vistor history cleared", "House");
        return House:MenuVistors(playerid, houseid);
    }
    return 1;
}

stock House:GetVisitorEnteriesTotal(houseid) {
    new Cache:visitors = mysql_query(Database, sprintf("SELECT count(*) as total FROM houseVisitors WHERE HouseID = %d", houseid));
    new total;
    cache_get_value_name_int(0, "total", total);
    cache_delete(visitors);
    return total;
}

stock House:MenuViewVistors(playerid, houseid) {
    new totalEnteries = House:GetVisitorEnteriesTotal(houseid);
    if (totalEnteries == 0) {
        AlexaMsg(playerid, "You didn't had any visitors.");
        return House:MenuVistors(playerid, houseid);
    }
    return House:MenuShowVistors(playerid, houseid, totalEnteries);
}

stock House:MenuShowVistors(playerid, houseid, total = 0, page = 0) {
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new Cache:visitors = mysql_query(Database,
        sprintf(
            "SELECT Visitor, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i') as VisitDate FROM houseVisitors WHERE HouseID=%d ORDER BY Date DESC LIMIT %d, %d",
            houseid, skip, perpage
        )
    );
    new rows = cache_num_rows();
    if (total == 0 || rows == 0) {
        cache_delete(visitors);
        AlexaMsg(playerid, "You didn't had any visitors.");
        return House:MenuVistors(playerid, houseid);
    }
    new list[2000], visitor_name[MAX_PLAYER_NAME], visit_date[20];
    format(list, sizeof(list), "Visitor Name\tDate\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name(i, "Visitor", visitor_name);
        cache_get_value_name(i, "VisitDate", visit_date);
        format(list, sizeof(list), "%s%s\t%s\n", list, visitor_name, visit_date);
    }

    if (remaining > 0) strcat(list, "Next Page");
    if (page > 0) strcat(list, "Back Page");

    cache_delete(visitors);
    return FlexPlayerDialog(playerid, "HouseMenuShowVistors", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("House Visitors (Page %d)", page), list, "Next", "Previous", houseid, sprintf("%d %d", page, total)
    );
}

FlexDialog:HouseMenuShowVistors(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuVistors(playerid, houseid);
    new page, total;
    sscanf(payload, "d d", page, total);
    if (IsStringSame(inputtext, "Next Page")) return House:MenuShowVistors(playerid, houseid, total, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return House:MenuShowVistors(playerid, houseid, total, page - 1);
    return House:MenuVistors(playerid, houseid);
}

stock House:MenuSafe(playerid, houseid) {
    if (House:GetSalePrice(houseid) > 0) {
        AlexaMsg(playerid, "you can't use safe while house is on sale", "House");
        return House:AccessMenu(playerid, houseid);
    }
    new string[512];
    strcat(string, sprintf("Take Money From Safe\t{2ECC71}($%s)\n", FormatCurrency(House:GetSafeMoney(houseid))));
    strcat(string, sprintf("Put Money To Safe\t{2ECC71}($%s)\n", FormatCurrency(GetPlayerMoney(playerid))));
    strcat(string, "View Safe History\n");
    strcat(string, "Clear Safe History\n");
    return FlexPlayerDialog(playerid, "HouseMenuSafe", DIALOG_STYLE_TABLIST, "House Safe", string, "Select", "Close", houseid);
}

FlexDialog:HouseMenuSafe(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "Take Money From Safe")) return House:MenuSafeTakeMoney(playerid, houseid);
    if (IsStringSame(inputtext, "Put Money To Safe")) return House:MenuSafePutMoney(playerid, houseid);
    if (IsStringSame(inputtext, "View Safe History")) {
        new total = House:TotalSafeEntries(houseid);
        if (total == 0) {
            AlexaMsg(playerid, "Can't find any safe history", "House");
            return House:MenuSafe(playerid, houseid);
        }
        return House:MenuSafeViewHistory(playerid, houseid, 0, total);
    }
    if (IsStringSame(inputtext, "Clear Safe History")) {
        mysql_tquery(Database, sprintf("DELETE FROM houseSafeLogs WHERE HouseID = %d", houseid));
        AlexaMsg(playerid, "safe history cleared", "House");
        return House:MenuSafe(playerid, houseid);
    }
    return 1;
}

stock House:MenuSafeTakeMoney(playerid, houseid) {
    if (House:GetSafeMoney(houseid) < 1) {
        AlexaMsg(playerid, "safe is empty, try to put some cash and then unload", "House");
        return House:MenuSafe(playerid, houseid);
    }
    return FlexPlayerDialog(playerid, "HouseMenuSafeTakeMoney", DIALOG_STYLE_INPUT, "Safe: Take Money",
        sprintf("Safe Balance: $%s\nWrite the amount you want to take from safe:", FormatCurrency(House:GetSafeMoney(houseid))), "Take", "Close", houseid
    );
}

FlexDialog:HouseMenuSafeTakeMoney(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuSafe(playerid, houseid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > House:GetSafeMoney(houseid)) return House:MenuSafeTakeMoney(playerid, houseid);
    House:SetSafeMoney(houseid, House:GetSafeMoney(houseid) - amount);
    GivePlayerCash(playerid, amount, sprintf("withdrawl from house [%d] safe at %s", houseid, House:GetAddress(houseid)));
    mysql_tquery(Database, sprintf("INSERT INTO houseSafeLogs SET HouseID=%d, Type=0, Amount=%d, Date=UNIX_TIMESTAMP()", houseid, amount));
    return House:MenuSafe(playerid, houseid);
}

stock House:MenuSafePutMoney(playerid, houseid) {
    if (House:GetSafeMoney(houseid) >= 50000) {
        AlexaMsg(playerid, "safe is full, try to take some cash", "House");
        return House:MenuSafe(playerid, houseid);
    }
    return FlexPlayerDialog(playerid, "HouseMenuSafePutMoney", DIALOG_STYLE_INPUT, "Safe: Put Money",
        sprintf("Safe Balance: $%s\nWrite the amount you want to put in safe:", FormatCurrency(House:GetSafeMoney(houseid))), "Put", "Close", houseid
    );
}

FlexDialog:HouseMenuSafePutMoney(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuSafe(playerid, houseid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || House:GetSafeMoney(houseid) + amount > 50000) return House:MenuSafePutMoney(playerid, houseid);
    House:SetSafeMoney(houseid, House:GetSafeMoney(houseid) + amount);
    GivePlayerCash(playerid, -amount, sprintf("deposit in house [%d] safe at %s", houseid, House:GetAddress(houseid)));
    mysql_tquery(Database, sprintf("INSERT INTO houseSafeLogs SET HouseID=%d, Type=1, Amount=%d, Date=UNIX_TIMESTAMP()", houseid, amount));
    return House:MenuSafe(playerid, houseid);
}

stock House:TotalSafeEntries(houseid) {
    new Cache:safelog = mysql_query(Database,
        sprintf("SELECT count(*) as total FROM houseSafeLogs WHERE HouseID = %d", houseid)
    );
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(safelog);
    return total;
}

stock House:MenuSafeViewHistory(playerid, houseid, page = 0, total = 0) {
    new perpage = 15;
    new totalpages = floatround(total / perpage);
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    if (total == 0) return AlexaMsg(playerid, "Can't find any safe history", "House");

    new Cache:safelog = mysql_query(Database,
        sprintf(
            "SELECT Type, Amount, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i') as TransactionDate FROM houseSafeLogs WHERE HouseID=%d ORDER BY Date DESC LIMIT %d, 15",
            houseid, skip
        )
    );
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(safelog);
        AlexaMsg(playerid, "Can't find any safe history", "House");
        return House:MenuSafe(playerid, houseid);
    }
    new string[2000], type, amount, date[20];
    format(string, sizeof(string), "Action\tMoney\tDate\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name_int(i, "Type", type);
        cache_get_value_name_int(i, "Amount", amount);
        cache_get_value_name(i, "TransactionDate", date);
        strcat(string, sprintf("%s\t%s\t%s\n", TransactionNames[type], FormatCurrency(amount), date));
    }
    cache_delete(safelog);

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(
        playerid, "HouseMenuSafeViewHistory", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Safe History (Page %d/%d)", page, totalpages),
        string, "Select", "Close", houseid, sprintf("%d %d", page, total)
    );
}

FlexDialog:HouseMenuSafeViewHistory(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:MenuSafe(playerid, houseid);
    new page, total;
    sscanf(payload, "d d", page, total);
    if (IsStringSame(inputtext, "Next Page")) return House:MenuSafeViewHistory(playerid, houseid, page + 1, total);
    if (IsStringSame(inputtext, "Back Page")) return House:MenuSafeViewHistory(playerid, houseid, page - 1, total);
    return House:MenuSafe(playerid, houseid);
}


stock House:MenuUpdatePassword(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuUpdatePassword", DIALOG_STYLE_INPUT, "House: Update Password", "Enter new password for house", "Update", "Cancel", houseid);
}

FlexDialog:HouseMenuUpdatePassword(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    new newpassword[MAX_HOUSE_PASSWORD];
    if (sscanf(inputtext, "s[16]", newpassword)) return House:MenuUpdatePassword(playerid, houseid);
    House:UpdatePassword(houseid, newpassword);
    return House:AccessMenu(playerid, houseid);
}

stock House:MenuUpdateLock(playerid, houseid) {
    new string[512];
    strcat(string, "Not Locked\n");
    strcat(string, "Password Lock\n");
    strcat(string, "Keys\n");
    strcat(string, "Owner Only\n");
    FlexPlayerDialog(playerid, "HouseMenuUpdateLock", DIALOG_STYLE_LIST, "House Lock", string, "Select", "Close", houseid);
    return 1;
}

FlexDialog:HouseMenuUpdateLock(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    HouseData[houseid][LockMode] = listitem;
    House:UpdateLabel(houseid);
    House:Save(houseid);
    return House:AccessMenu(playerid, houseid);
}

stock House:MenuUpdateName(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseMenuUpdateName", DIALOG_STYLE_INPUT, "Update house name", "Enter house name", "Update", "Cancel", houseid);
}

FlexDialog:HouseMenuUpdateName(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    new newname[48];
    if (sscanf(inputtext, "s[48]", newname)) return House:MenuUpdateName(playerid, houseid);
    House:UpdateName(houseid, newname);
    House:UpdateLabel(houseid);
    House:Save(houseid);
    return House:AccessMenu(playerid, houseid);
}

stock House:SellMenu(playerid, houseid) {
    new string[512];
    strcat(string, sprintf("Sell Instantly\t{2ECC71}$%s\n", FormatCurrency(GetPercentageOf(70, House:GetPrice(houseid)))));
    strcat(string, sprintf("%s", House:GetSalePrice(houseid) > 0 ? ("Remove From Sale") : ("Put For Sale")));
    return FlexPlayerDialog(playerid, "HouseSellMenu", DIALOG_STYLE_LIST, "Sell Options", string, "Select", "Close", houseid);
}

FlexDialog:HouseSellMenu(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AccessMenu(playerid, houseid);
    if (IsStringSame(inputtext, "Sell Instantly")) {
        if (House:GetSafeMoney(houseid) > 0) {
            GivePlayerCash(playerid, House:GetSafeMoney(houseid), sprintf("taken from house [%d] at %s on direct sell", houseid, House:GetAddress(houseid)));
            AlexaMsg(playerid, sprintf("withdrawl $%s from house safe", FormatCurrency(House:GetSafeMoney(houseid))), "House");
        }
        new sellcash = GetPercentageOf(70, House:GetPrice(houseid));
        GivePlayerCash(playerid, sellcash, sprintf("House: sold house [%d] at %s directly", houseid, House:GetAddress(houseid)));
        vault:addcash(Vault_ID_Government, -sellcash, Vault_Transaction_Cash_To_Vault,
            sprintf("%s: sold house [%d] at %s directly", GetPlayerNameEx(playerid), houseid, House:GetAddress(houseid))
        );
        House:Reset(houseid);
        House:Save(houseid);
        return AlexaMsg(playerid, sprintf("sold house [%d] at %s to government for $%s", FormatCurrency(sellcash)), "House");
    }
    if (IsStringSame(inputtext, "Put For Sale")) return House:PutOnSale(playerid, houseid);
    if (IsStringSame(inputtext, "Remove From Sale")) {
        House:SetSalePrice(houseid, 0);
        House:UpdateLabel(houseid);
        House:Save(houseid);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, HouseData[houseid][HousePickup], E_STREAMER_MODEL_ID, 19522);
        Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, HouseData[houseid][HouseIcon], E_STREAMER_TYPE, 32);
        AlexaMsg(playerid, "Your house is no longer for sale.", "House");
        return House:SellMenu(playerid, houseid);
    }
    return 1;
}

stock House:PutOnSale(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HousePutOnSale", DIALOG_STYLE_INPUT, "Put On Sale", "Enter sale price for your house", "Confirm", "Cancel", houseid);
}

FlexDialog:HousePutOnSale(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:SellMenu(playerid, houseid);
    new saleprice;
    if (sscanf(inputtext, "d", saleprice) || saleprice < 1 || saleprice > 99000000) return House:PutOnSale(playerid, houseid);
    House:SetSalePrice(houseid, saleprice);
    House:UpdateLabel(houseid);
    House:Save(houseid);
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, HouseData[houseid][HousePickup], E_STREAMER_MODEL_ID, 19522);
    Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, HouseData[houseid][HouseIcon], E_STREAMER_TYPE, 32);
    AlexaMsg(playerid, sprintf("You put your house for sale for $%s.", FormatCurrency(saleprice)), "House");
    return House:SellMenu(playerid, houseid);
}

stock House:AdminMenu(playerid) {
    new string[512];
    strcat(string, "Alter House\n");
    strcat(string, "Create House\n");
    strcat(string, "Create Random House\n");
    FlexPlayerDialog(playerid, "HouseAdminMenu", DIALOG_STYLE_LIST, "House System: Admin", string, "Select", "Close");
    return 1;
}

FlexDialog:HouseAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Alter House")) return House:AdminMenuAlterHouse(playerid);
    if (IsStringSame(inputtext, "Create House")) return House:AdminMenuCreateHouse(playerid);
    if (IsStringSame(inputtext, "Create Random House")) {
        House:CreateRandomHouse(playerid);
        return House:AdminMenu(playerid);
    }
    return 1;
}

stock House:AdminMenuCreateHouse(playerid) {
    return FlexPlayerDialog(playerid, "HouseAdminMenuCreateHouse", DIALOG_STYLE_INPUT, "House System", "Enter [Price] [InteriorID]", "Create", "Close");
}

FlexDialog:HouseAdminMenuCreateHouse(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return House:AdminMenu(playerid);
    new price, interior;
    if (sscanf(inputtext, "dd", price, interior) || price < 1 || interior < 0 || interior >= sizeof HouseInteriors) return House:AdminMenuCreateHouse(playerid);
    return House:CreateHouse(playerid, price, interior);
}

stock House:CreateRandomHouse(playerid) {
    new price = RandomEx(100000, 500000);
    new interior = RandomEx(0, sizeof(HouseInteriors) - 1);
    return House:CreateHouse(playerid, price, interior);
}

stock House:CreateHouse(playerid, price, interior) {
    new houseid = Iter_Free(Houses);
    if (houseid == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "You can't create more houses, max house limit reached", "House");
    format(HouseData[houseid][Name], MAX_HOUSE_NAME, "House For Sale");
    format(HouseData[houseid][Owner], MAX_PLAYER_NAME, "-");
    format(HouseData[houseid][Password], MAX_HOUSE_PASSWORD, "-");
    GetPlayerPos(playerid, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
    HouseData[houseid][Price] = price;
    HouseData[houseid][Interior] = interior;
    HouseData[houseid][LockMode] = LOCK_MODE_NOLOCK;
    HouseData[houseid][SalePrice] = HouseData[houseid][SafeMoney] = HouseData[houseid][LastEntered] = 0;
    HouseData[houseid][HAutoReset] = 1;
    HouseData[houseid][HouseLabel] = CreateDynamic3DTextLabel(
        sprintf(
            "{2ECC71}House For Sale (ID: %d)\n{FFFFFF}%s\n{F1C40F}Price: {2ECC71}$%s",
            houseid, HouseInteriors[interior][IntName], FormatCurrency(price)
        ), 0xFFFFFFFF, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ] + 0.35, 2.0
    );
    HouseData[houseid][HousePickup] = CreateDynamicPickup(1273, 23, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
    HouseData[houseid][HouseIcon] = CreateDynamicMapIcon(HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ], 31, 0);
    mysql_tquery(Database, sprintf("INSERT INTO houses SET ID=%d, HouseX=%f, HouseY=%f, HouseZ=%f, HousePrice=%d, HouseInterior=%d", houseid, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ], price, interior));
    Iter_Add(Houses, houseid);
    AlexaMsg(playerid, "House created", "House");
    return 1;
}

stock House:AdminMenuAlterHouse(playerid) {
    return FlexPlayerDialog(playerid, "HouseAdminMenuAlterHouse", DIALOG_STYLE_INPUT, "Alter House", "Enter house id to manage", "Submit", "Close");
}

FlexDialog:HouseAdminMenuAlterHouse(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return House:AdminMenu(playerid);
    new houseid;
    if (sscanf(inputtext, "d", houseid) || !House:IsValidID(houseid)) return House:AdminMenuAlterHouse(playerid);
    return House:AdminMenuManage(playerid, houseid);
}

stock House:AdminMenuManage(playerid, houseid) {
    new string[1024];
    strcat(string, "Teleport to House\n");
    if (House:IsPurchased(houseid)) strcat(string, "Teleport to Inside House\n");
    strcat(string, "Set House Interior\n");
    strcat(string, "Set House Price\n");
    if (House:GetAutoReset(houseid)) strcat(string, "Disable auto reset\n");
    else strcat(string, "Enable auto reset\n");
    strcat(string, "Fill House Fridge\n");
    strcat(string, "Empty House Fridge\n");
    strcat(string, "Reset House\n");
    strcat(string, "Remove House\n");
    return FlexPlayerDialog(playerid, "HouseAdminMenuManage", DIALOG_STYLE_LIST, sprintf("Manage House: %d", houseid), string, "Select", "Close", houseid);
}

FlexDialog:HouseAdminMenuManage(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AdminMenu(playerid);
    if (IsStringSame(inputtext, "Teleport to House")) {
        SetPlayerPosEx(playerid, HouseData[houseid][houseX], HouseData[houseid][houseY], HouseData[houseid][houseZ]);
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AlexaMsg(playerid, "teleported to house", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Teleport to Inside House")) {
        if (!House:IsPurchased(houseid)) return 1;
        AlexaMsg(playerid, "teleported to house", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Disable auto reset")) {
        House:SetAutoReset(houseid, 0);
        House:Save(houseid);
        AlexaMsg(playerid, "House auto reset disabled, it will not expire if not used.", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Enable auto reset")) {
        House:SetAutoReset(houseid, 1);
        House:Save(houseid);
        AlexaMsg(playerid, "House auto reset enabled, it will expire if not used.", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Fill House Fridge")) {
        SetHouseFridgePizza(houseid, 25);
        SetHouseFridgeHotdog(houseid, 25);
        SetHouseFridgeCola(houseid, 25);
        SetHouseFridgeBurger(houseid, 25);
        SetHouseFridgeFries(houseid, 25);
        SetHouseFridgeStorageWater(houseid, 100);
        SetHouseFridgeStorageCorn(houseid, 100);
        SetHouseFridgeStorageWheat(houseid, 100);
        SetHouseFridgeStorageOnion(houseid, 100);
        SetHouseFridgeStoragePotato(houseid, 100);
        SetHouseFridgeStorageGarlic(houseid, 100);
        SetHouseFridgeStorageVinegar(houseid, 100);
        SetHouseFridgeStorageTomato(houseid, 100);
        SetHouseFridgeStorageRice(houseid, 100);
        SetHouseFridgeStorageMeet(houseid, 100);
        SetHouseFridgeStorageMilk(houseid, 100);
        SetHouseFridgeStorageCheese(houseid, 100);
        SetHouseFridgeStorageEgg(houseid, 100);
        House:Save(houseid);
        AlexaMsg(playerid, "fridge is filled", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Empty House Fridge")) {
        SetHouseFridgePizza(houseid, 0);
        SetHouseFridgeHotdog(houseid, 0);
        SetHouseFridgeCola(houseid, 0);
        SetHouseFridgeBurger(houseid, 0);
        SetHouseFridgeFries(houseid, 0);
        SetHouseFridgeStorageWater(houseid, 0);
        SetHouseFridgeStorageCorn(houseid, 0);
        SetHouseFridgeStorageWheat(houseid, 0);
        SetHouseFridgeStorageOnion(houseid, 0);
        SetHouseFridgeStoragePotato(houseid, 0);
        SetHouseFridgeStorageGarlic(houseid, 0);
        SetHouseFridgeStorageVinegar(houseid, 0);
        SetHouseFridgeStorageTomato(houseid, 0);
        SetHouseFridgeStorageRice(houseid, 0);
        SetHouseFridgeStorageMeet(houseid, 0);
        SetHouseFridgeStorageMilk(houseid, 0);
        SetHouseFridgeStorageCheese(houseid, 0);
        SetHouseFridgeStorageEgg(houseid, 0);
        House:Save(houseid);
        AlexaMsg(playerid, "fridge is reseted", "House");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Reset House")) {
        House:Reset(houseid);
        AlexaMsg(playerid, "reseted", "house");
        return House:AdminMenuManage(playerid, houseid);
    }
    if (IsStringSame(inputtext, "Remove House")) {
        House:Reset(houseid);
        House:Save(houseid);
        DestroyDynamic3DTextLabel(HouseData[houseid][HouseLabel]);
        DestroyDynamicPickup(HouseData[houseid][HousePickup]);
        DestroyDynamicMapIcon(HouseData[houseid][HouseIcon]);
        Iter_Remove(Houses, houseid);
        HouseData[houseid][HouseLabel] = Text3D:INVALID_3DTEXT_ID;
        HouseData[houseid][HousePickup] = HouseData[houseid][HouseIcon] = -1;
        mysql_tquery(Database, sprintf("DELETE FROM houses WHERE ID=%d", houseid));
        AlexaMsg(playerid, "removed", "house");
        return House:AdminMenu(playerid);
    }
    if (IsStringSame(inputtext, "Set House Interior")) return House:AdminMenuSetInterior(playerid, houseid);
    if (IsStringSame(inputtext, "Set House Price")) return House:AdminMenuSetPrice(playerid, houseid);
    return 1;
}

stock House:AdminMenuSetInterior(playerid, houseid) {
    return FlexPlayerDialog(
        playerid, "HouseAdminMenuSetInterior", DIALOG_STYLE_INPUT, "House: Update Interior",
        sprintf("Enter new interior id between 0 to %d", sizeof HouseInteriors), "Update", "Cancel", houseid
    );
}

FlexDialog:HouseAdminMenuSetInterior(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AdminMenuManage(playerid, houseid);
    new interior;
    if (sscanf(inputtext, "d", interior) || interior < 0 || interior >= sizeof HouseInteriors) return House:AdminMenuSetInterior(playerid, houseid);
    HouseData[houseid][Interior] = interior;
    mysql_tquery(Database, sprintf("UPDATE houses SET HouseInterior=%d WHERE ID=%d", interior, houseid));
    House:UpdateLabel(houseid);
    House:Save(houseid);
    AlexaMsg(playerid, "Interior updated", "house");
    return House:AdminMenuManage(playerid, houseid);
}

stock House:AdminMenuSetPrice(playerid, houseid) {
    return FlexPlayerDialog(playerid, "HouseAdminMenuSetPrice", DIALOG_STYLE_INPUT, "House: Update Price", "Enter new price selling price", "Update", "Cancel", houseid);
}

FlexDialog:HouseAdminMenuSetPrice(playerid, response, listitem, const inputtext[], houseid, const payload[]) {
    if (!response) return House:AdminMenuManage(playerid, houseid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1) return House:AdminMenuSetPrice(playerid, houseid);
    mysql_tquery(Database, sprintf("UPDATE houses SET HousePrice=%d WHERE ID=%d", newprice, houseid));
    House:UpdateLabel(houseid);
    House:Save(houseid);
    AlexaMsg(playerid, "price updated", "house");
    return House:AdminMenuManage(playerid, houseid);
}