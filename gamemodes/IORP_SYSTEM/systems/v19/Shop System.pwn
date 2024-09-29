#define MAX_SHOPS 1000
new Shop:DebugID;
enum shop_system_enum {
    SS_Type,
    SS_Model_ID,
    Float:SS_CP_Size,
    SS_Pickup_Types,
    Float:SS_Pos[3],
    SS_Interior_ID,
    SS_Virtual_World_ID,
    Float:SS_StreamDistance,
    SS_ShopID,
    SS_Pickup_ID,
};
new Shop:Data[MAX_SHOPS][shop_system_enum];
new Iterator:ShopIds < MAX_SHOPS > ;

stock Shop:IsValidID(shopid) {
    return Iter_Contains(ShopIds, shopid);
}

stock Shop:GetTotal() {
    return Iter_Count(ShopIds);
}

stock Shop:GetRequestID(shopid) {
    return Shop:Data[shopid][SS_ShopID];
}

hook OnGameModeInit() {
    Shop:DebugID = Debug:GetID("Shop System");
    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `shops` (\
	  `ID` int(11) NOT NULL,\
	  `Type` int(11) NOT NULL,\
	  `ModelID` int(11) NOT NULL,\
	  `CP Size` FLOAT(11) NOT NULL,\
	  `Pickup Type` int(11) NOT NULL,\
	  `Pos X` FLOAT(11) NOT NULL,\
	  `Pos Y` FLOAT(11) NOT NULL,\
	  `Pos Z` FLOAT(11) NOT NULL,\
	  `InteriorID` int(11) NOT NULL,\
	  `VirtualWorldID` int(11) NOT NULL,\
	  `StreamDistance` FLOAT(11) NOT NULL,\
	  `ShopID` int(11) NOT NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "select * from `shops`", "LoadShops", "");
    return 1;
}

forward LoadShops();
public LoadShops() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, shopid, Temp_Type, Temp_ModelID, Float:Temp_CP_Size, Temp_Pickup_Type, Float:Temp_Pos_X, Float:Temp_Pos_Y, Float:Temp_Pos_Z, Temp_InteriorID, Temp_VirtualWorldID, Float:Temp_StreamDistance, Temp_ShopID;
        while (Count < rows) {
            cache_get_value_name_int(Count, "ID", shopid);
            cache_get_value_name_int(Count, "Type", Temp_Type);
            cache_get_value_name_int(Count, "ModelID", Temp_ModelID);
            cache_get_value_name_float(Count, "CP Size", Temp_CP_Size);
            cache_get_value_name_int(Count, "Pickup Type", Temp_Pickup_Type);
            cache_get_value_name_float(Count, "Pos X", Temp_Pos_X);
            cache_get_value_name_float(Count, "Pos Y", Temp_Pos_Y);
            cache_get_value_name_float(Count, "Pos Z", Temp_Pos_Z);
            cache_get_value_name_int(Count, "InteriorID", Temp_InteriorID);
            cache_get_value_name_int(Count, "VirtualWorldID", Temp_VirtualWorldID);
            cache_get_value_name_float(Count, "StreamDistance", Temp_StreamDistance);
            cache_get_value_name_int(Count, "ShopID", Temp_ShopID);
            Shop:Data[shopid][SS_Type] = Temp_Type;
            Shop:Data[shopid][SS_Model_ID] = Temp_ModelID;
            Shop:Data[shopid][SS_CP_Size] = Temp_CP_Size;
            Shop:Data[shopid][SS_Pickup_Types] = Temp_Pickup_Type;
            Shop:Data[shopid][SS_Pos][0] = Temp_Pos_X;
            Shop:Data[shopid][SS_Pos][1] = Temp_Pos_Y;
            Shop:Data[shopid][SS_Pos][2] = Temp_Pos_Z;
            Shop:Data[shopid][SS_Interior_ID] = Temp_InteriorID;
            Shop:Data[shopid][SS_Virtual_World_ID] = Temp_VirtualWorldID;
            Shop:Data[shopid][SS_StreamDistance] = Temp_StreamDistance;
            Shop:Data[shopid][SS_ShopID] = Temp_ShopID;
            Shop:Data[shopid][SS_Pickup_ID] = -1;
            if (Shop:Data[shopid][SS_Type] == 0) Shop:Data[shopid][SS_Pickup_ID] = CreateDynamicPickup(Shop:Data[shopid][SS_Model_ID], Shop:Data[shopid][SS_Pickup_Types], Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_Interior_ID], -1, Shop:Data[shopid][SS_StreamDistance]);
            else Shop:Data[shopid][SS_Pickup_ID] = CreateDynamicCP(Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_CP_Size], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_Interior_ID], -1, Shop:Data[shopid][SS_StreamDistance]);
            Iter_Add(ShopIds, shopid);
            Count++;
        }
    }
    printf("  [Shop System] Loaded %d shop's.", rows);
    return 1;
}

stock Shop:UpdateDB(shopid) {
    new query[512], Cache:result;
    mysql_format(Database, query, sizeof query, "select * from `shops` where ID = %d", shopid);
    result = mysql_query(Database, query);
    new rows = cache_num_rows();
    cache_delete(result);
    if (rows != 0) {
        format(query, sizeof query, "update `shops` set Type=\"%d\", ModelID=\"%d\", `CP Size`=\"%f\", `Pickup Type`=\"%d\", `Pos X`=\"%f\", `Pos Y`=\"%f\", `Pos Z`=\"%f\", InteriorID=\"%d\", VirtualWorldID=\"%d\", StreamDistance=\"%f\", ShopID = \"%d\" where ID = %d",
            Shop:Data[shopid][SS_Type], Shop:Data[shopid][SS_Model_ID], Shop:Data[shopid][SS_CP_Size], Shop:Data[shopid][SS_Pickup_Types], Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_Interior_ID], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_StreamDistance], Shop:Data[shopid][SS_ShopID], shopid);
        mysql_tquery(Database, query);
        if (Shop:Data[shopid][SS_Type] == 0) {
            if (IsValidDynamicPickup(Shop:Data[shopid][SS_Pickup_ID])) DestroyDynamicPickup(Shop:Data[shopid][SS_Pickup_ID]);
            Shop:Data[shopid][SS_Pickup_ID] = CreateDynamicPickup(Shop:Data[shopid][SS_Model_ID], Shop:Data[shopid][SS_Pickup_Types], Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_Interior_ID], -1, Shop:Data[shopid][SS_StreamDistance]);
        } else {
            if (IsValidDynamicCP(Shop:Data[shopid][SS_Pickup_ID])) DestroyDynamicCP(Shop:Data[shopid][SS_Pickup_ID]);
            Shop:Data[shopid][SS_Pickup_ID] = CreateDynamicCP(Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_CP_Size], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_Interior_ID], -1, Shop:Data[shopid][SS_StreamDistance]);
        }
    } else {
        format(query, sizeof query, "INSERT INTO `shops`(ID, Type, ModelID, `CP Size`, `Pickup Type`, `Pos X`, `Pos Y`, `Pos Z`, InteriorID, VirtualWorldID, StreamDistance, ShopID)\
        VALUES (\"%d\",\"%d\",\"%d\",\"%f\",\"%d\",\"%f\",\"%f\",\"%f\",\"%d\",\"%d\",\"%f\",\"%d\")", shopid, Shop:Data[shopid][SS_Type], Shop:Data[shopid][SS_Model_ID], Shop:Data[shopid][SS_CP_Size], Shop:Data[shopid][SS_Pickup_Types], Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2], Shop:Data[shopid][SS_Interior_ID], Shop:Data[shopid][SS_Virtual_World_ID], Shop:Data[shopid][SS_StreamDistance], Shop:Data[shopid][SS_ShopID]);
        mysql_tquery(Database, query);
        Iter_Add(ShopIds, shopid);
    }
    return 1;
}

stock Shop:DropDB(shopid) {
    if (!Iter_Contains(ShopIds, shopid)) return 1;
    if (Shop:Data[shopid][SS_Type] == 0)
        if (IsValidDynamicPickup(Shop:Data[shopid][SS_Pickup_ID])) DestroyDynamicPickup(Shop:Data[shopid][SS_Pickup_ID]);
        else if (IsValidDynamicCP(Shop:Data[shopid][SS_Pickup_ID])) DestroyDynamicCP(Shop:Data[shopid][SS_Pickup_ID]);
    new query[256];
    format(query, sizeof query, "delete from `shops` where ID = %d", shopid);
    mysql_tquery(Database, query);
    DestroyDynamicCP(Shop:Data[shopid][SS_Pickup_ID]);
    Iter_Remove(ShopIds, shopid);
    return 1;
}

stock Shop:AdminPanel(playerid) {
    new string[256];
    strcat(string, "List Shop\n");
    strcat(string, "Alter Shop\n");
    strcat(string, "Create Shop\n");
    return FlexPlayerDialog(playerid, "ShopAdminPanel", DIALOG_STYLE_LIST, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", string, "Select", "Close");
}

FlexDialog:ShopAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "List Shop")) return Shop:AdminViewAll(playerid);
    if (IsStringSame(inputtext, "Alter Shop")) return Shop:AdminMenuAlter(playerid);
    if (IsStringSame(inputtext, "Create Shop")) return Shop:AdminMenuCreateType(playerid);
    return 1;
}

stock Shop:AdminViewAll(playerid, page = 0) {
    new total = Shop:GetTotal();
    if (total == 0) {
        AlexaMsg(playerid, "currently there are no shop available");
        return Shop:AdminPanel(playerid);
    }
    new perpage = 20;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new string[2000], count;
    strcat(string, "#\tRequest ID\n");
    foreach(new shopid:ShopIds) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf("%d\t%d\n", shopid, Shop:GetRequestID(shopid)));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "ShopAdminViewAll", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFFF}Shop System", string, "Select", "Close", page);
}

FlexDialog:ShopAdminViewAll(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return Shop:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Next Page")) return Shop:AdminViewAll(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Shop:AdminViewAll(playerid, page - 1);
    return Shop:AdminMenuManage(playerid, strval(inputtext));
}

stock Shop:AdminMenuCreateType(playerid) {
    new string[512];
    strcat(string, "Pickup\n");
    strcat(string, "Checkpoint\n");
    return FlexPlayerDialog(playerid, "ShopAdminMenuCreateType", DIALOG_STYLE_LIST, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", string, "Create", "Close");
}

FlexDialog:ShopAdminMenuCreateType(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Shop:AdminPanel(playerid);
    new shopid = Iter_Free(ShopIds);
    if (shopid == INVALID_ITERATOR_SLOT) return SendClientMessageEx(playerid, -1, "{4286f4}[Shop System]:{FFFFEE}Max Limit Reached");
    new Float:x, Float:y, Float:z, type = listitem;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    new ss_int = GetPlayerInteriorID(playerid);
    new ss_vw = GetPlayerVirtualWorld(playerid);
    Shop:Data[shopid][SS_Type] = type;
    Shop:Data[shopid][SS_Model_ID] = 1210;
    Shop:Data[shopid][SS_CP_Size] = 1;
    Shop:Data[shopid][SS_Pickup_Types] = 2;
    Shop:Data[shopid][SS_Pos][0] = x;
    Shop:Data[shopid][SS_Pos][1] = y;
    Shop:Data[shopid][SS_Pos][2] = z;
    Shop:Data[shopid][SS_Interior_ID] = ss_int;
    Shop:Data[shopid][SS_Virtual_World_ID] = ss_vw;
    Shop:Data[shopid][SS_StreamDistance] = 10;
    Shop:Data[shopid][SS_ShopID] = 0;
    Shop:Data[shopid][SS_Pickup_ID] = -1;
    Shop:UpdateDB(shopid);
    new string[512];
    format(string, sizeof string, "{4286f4}[Shop System]:{FFFFEE}Created new Shop:%d", shopid);
    SendClientMessageEx(playerid, -1, string);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:AdminMenuAlter(playerid) {
    return FlexPlayerDialog(playerid, "ShopAdminMenuAlter", DIALOG_STYLE_INPUT, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", "Enter Shop ID", "Update", "Close");
}

FlexDialog:ShopAdminMenuAlter(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Shop:AdminPanel(playerid);
    new shopid;
    if (sscanf(inputtext, "d", shopid) || !Shop:IsValidID(shopid)) return Shop:AdminMenuAlter(playerid);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:AdminMenuManage(playerid, shopid) {
    if (!Iter_Contains(ShopIds, shopid)) return 1;
    new string[512];
    strcat(string, "Data\tValue\n");
    if (Shop:Data[shopid][SS_Type] == 0) strcat(string, sprintf("Model ID\t%d\n", Shop:Data[shopid][SS_Model_ID]));
    if (Shop:Data[shopid][SS_Type] == 1) strcat(string, sprintf("CP Size\t%f\n", Shop:Data[shopid][SS_CP_Size]));
    if (Shop:Data[shopid][SS_Type] == 0) strcat(string, sprintf("Pickup Type\t%d\n", Shop:Data[shopid][SS_Pickup_Types]));
    strcat(string, sprintf("Pos X\t%f\n", Shop:Data[shopid][SS_Pos][0]));
    strcat(string, sprintf("Pos Y\t%f\n", Shop:Data[shopid][SS_Pos][1]));
    strcat(string, sprintf("Pos Z\t%f\n", Shop:Data[shopid][SS_Pos][2]));
    strcat(string, sprintf("Interior ID\t%d\n", Shop:Data[shopid][SS_Interior_ID]));
    strcat(string, sprintf("VirtualWorld ID\t%d\n", Shop:Data[shopid][SS_Virtual_World_ID]));
    strcat(string, sprintf("Stream Distance\t%f\n", Shop:Data[shopid][SS_StreamDistance]));
    strcat(string, sprintf("ShopID\t%d\n", Shop:Data[shopid][SS_ShopID]));
    strcat(string, sprintf("Teleport to Shop\tNone\n", Shop:Data[shopid][SS_ShopID]));
    strcat(string, sprintf("Remove Shop\tNone\n", Shop:Data[shopid][SS_ShopID]));
    return FlexPlayerDialog(playerid, "ShopAdminMenuManage", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", string, "Select", "Close", shopid);
}

FlexDialog:ShopAdminMenuManage(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminPanel(playerid);
    if (IsStringSame("Model ID", inputtext)) return Shop:UpdateModelID(playerid, shopid);
    if (IsStringSame("CP Size", inputtext)) return Shop:UpdateCpSize(playerid, shopid);
    if (IsStringSame("Pickup Type", inputtext)) return Shop:UpdateType(playerid, shopid);
    if (IsStringSame("Stream Distance", inputtext)) return Shop:UpdateStreamDistance(playerid, shopid);
    if (IsStringSame("ShopID", inputtext)) return Shop:UpdateRequestID(playerid, shopid);
    if (IsStringSame("Pos X", inputtext) || IsStringSame("Pos Y", inputtext) || IsStringSame("Pos Z", inputtext) || IsStringSame("Interior ID", inputtext) || IsStringSame("VirtualWorld ID", inputtext)) {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, Float:x, Float:y, Float:z);
        Shop:Data[shopid][SS_Pos][0] = x;
        Shop:Data[shopid][SS_Pos][1] = y;
        Shop:Data[shopid][SS_Pos][2] = z;
        Shop:Data[shopid][SS_Interior_ID] = GetPlayerInteriorID(playerid);
        Shop:Data[shopid][SS_Virtual_World_ID] = GetPlayerVirtualWorld(playerid);
        Shop:UpdateDB(shopid);
        AlexaMsg(playerid, sprintf("updated position for: %d", shopid));
        return Shop:AdminMenuManage(playerid, shopid);
    }
    if (IsStringSame("Teleport to Shop", inputtext)) {
        SetPlayerVirtualWorldEx(playerid, Shop:Data[shopid][SS_Virtual_World_ID]);
        SetPlayerInteriorEx(playerid, Shop:Data[shopid][SS_Interior_ID]);
        SetPlayerPosEx(playerid, Shop:Data[shopid][SS_Pos][0], Shop:Data[shopid][SS_Pos][1], Shop:Data[shopid][SS_Pos][2]);
        return Shop:AdminMenuManage(playerid, shopid);
    }
    if (IsStringSame("Remove Shop", inputtext)) {
        Shop:DropDB(shopid);
        AlexaMsg(playerid, sprintf("removed shop id: %d", shopid));
        return Shop:AdminPanel(playerid);
    }
    return 1;
}

stock Shop:UpdateType(playerid, shopid) {
    new string[512];
    strcat(string, "Pickup\n");
    strcat(string, "Checkpoint\n");
    return FlexPlayerDialog(playerid, "ShopUpdateType", DIALOG_STYLE_LIST, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", string, "Update", "Close", shopid);
}

FlexDialog:ShopUpdateType(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminMenuManage(playerid, shopid);
    Shop:Data[shopid][SS_Pickup_Types] = listitem;
    Shop:UpdateDB(shopid);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:UpdateModelID(playerid, shopid) {
    return FlexPlayerDialog(playerid, "ShopUpdateModelID", DIALOG_STYLE_INPUT, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", "Enter Model ID", "Update", "Close", shopid);
}

FlexDialog:ShopUpdateModelID(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminMenuManage(playerid, shopid);
    new modelid;
    if (sscanf(inputtext, "d", modelid) || modelid < 1) return Shop:UpdateModelID(playerid, shopid);
    Shop:Data[shopid][SS_Model_ID] = strval(inputtext);
    Shop:UpdateDB(shopid);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:UpdateCpSize(playerid, shopid) {
    return FlexPlayerDialog(playerid, "ShopUpdateCpSize", DIALOG_STYLE_INPUT, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", "Enter checkpoint size", "Update", "Close", shopid);
}

FlexDialog:ShopUpdateCpSize(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminMenuManage(playerid, shopid);
    new Float:size;
    if (sscanf(inputtext, "f", size) || size < 0.1 || size > 100) return Shop:UpdateCpSize(playerid, shopid);
    Shop:Data[shopid][SS_CP_Size] = size;
    Shop:UpdateDB(shopid);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:UpdateStreamDistance(playerid, shopid) {
    return FlexPlayerDialog(playerid, "ShopUpdateStreamDistance", DIALOG_STYLE_INPUT, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", "Enter distance", "Update", "Close", shopid);
}

FlexDialog:ShopUpdateStreamDistance(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminMenuManage(playerid, shopid);
    new Float:distance;
    if (sscanf(inputtext, "f", distance) || distance < 0.1 || distance > 5000) return Shop:UpdateStreamDistance(playerid, shopid);
    Shop:Data[shopid][SS_StreamDistance] = distance;
    Shop:UpdateDB(shopid);
    return Shop:AdminMenuManage(playerid, shopid);
}

stock Shop:UpdateRequestID(playerid, shopid) {
    return FlexPlayerDialog(playerid, "ShopUpdateRequestID", DIALOG_STYLE_INPUT, "{4286f4}[Shop System]:{FFFFEE}Admin Panel", "Enter shop request id", "Update", "Close", shopid);
}

FlexDialog:ShopUpdateRequestID(playerid, response, listitem, const inputtext[], shopid, const payload[]) {
    if (!response) return Shop:AdminMenuManage(playerid, shopid);
    new requestid;
    if (sscanf(inputtext, "d", requestid)) return Shop:UpdateRequestID(playerid, shopid);
    Shop:Data[shopid][SS_ShopID] = requestid;
    Shop:UpdateDB(shopid);
    return Shop:AdminMenuManage(playerid, shopid);
}


hook OnPlayerEnterDynamicCP(playerid, checkpointid) {
    foreach(new shopid:ShopIds) {
        if (checkpointid == Shop:Data[shopid][SS_Pickup_ID] && Shop:Data[shopid][SS_Type] == 1) {
            Debug:SendMessage(Shop:DebugID, sprintf("Debug:Shop System:Shop ID:%d", shopid));
            return Shop:RequestID(playerid, Shop:Data[shopid][SS_ShopID]);
        }
    }
    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    foreach(new shopid:ShopIds) {
        if (pickupid == Shop:Data[shopid][SS_Pickup_ID] && Shop:Data[shopid][SS_Type] == 0) {
            Debug:SendMessage(Shop:DebugID, sprintf("Debug:Shop System:Shop ID:%d", shopid));
            return Shop:RequestID(playerid, Shop:Data[shopid][SS_ShopID]);
        }
    }
    return 1;
}

stock Shop:RequestID(playerid, shopid) {
    CallRemoteFunction("OnPlayerRequestShop", "dd", playerid, shopid);
    return 1;
}

forward OnPlayerRequestShop(playerid, shopid);
public OnPlayerRequestShop(playerid, shopid) {
    if (shopid == 0) return WeaponShopMenu(playerid);
    if (shopid == 3) return ModShop:ShowModMenu(playerid);
    if (shopid == 6) return Event:MainMenu(playerid);
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Shop System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Shop System", inputtext)) Shop:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "shop system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    Shop:AdminPanel(playerid);
    return ~1;
}