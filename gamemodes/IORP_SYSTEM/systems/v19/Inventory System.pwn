#define BackpackAttachIndex 7
#define BackpackModel 3026
#define MaxBackpacks 100
#define MaxBackpackItems 100
#define BackpackDB "backpack"

new BACKPACK_PURCHASE_PRICE = 10000, BACKPACK_SELLING_PRICE = 5000;

hook GlobalOneMinuteInterval() {
    BACKPACK_PURCHASE_PRICE = Random(6000, 10000);
    BACKPACK_SELLING_PRICE = Random(3000, 6000);
    return 1;
}

// Backpack Player ID state holder
new BackpackPlayer[MAX_PLAYERS];

stock Backpack:GetPlayerBackpackID(playerid) {
    return BackpackPlayer[playerid];
}

stock Backpack:SetPlayerBackpackID(playerid, backPackId) {
    BackpackPlayer[playerid] = backPackId;
    return 1;
}

// Init Backpack Data
enum EnumBackBackData {
    BPOwner[50],
        Float:BPPos[3],
        BpInt,
        BpVw,
        bool:isDroped,
        inventoryQuantitiy[MaxBackpackItems],

        BgObjectID,
        Text3D:BgLabel
}
new BackpackData[MaxBackpacks][EnumBackBackData];
new Iterator:BackpackIT < MaxBackpacks > ;

// Init Inventory Data
enum BgInventoryEnum {
    BgTitle[100],
        Bglimit
}
new BgInventoryData[MaxBackpackItems][BgInventoryEnum];
new Iterator:BgInventoryDataIT < MaxBackpackItems > ;

// Backpack functions

stock Backpack:Count(playerid) {
    new count = 0;
    foreach(new backPackId:BackpackIT) {
        if (IsStringSame(BackpackData[backPackId][BPOwner], GetPlayerNameEx(playerid))) count++;

    }
    return count;
}

stock Backpack:Add(playerid) {
    if (!IsPlayerConnected(playerid)) return -1;
    new backPackId = Iter_Free(BackpackIT);
    if (backPackId == INVALID_ITERATOR_SLOT) return -1;
    BackpackData[backPackId][BpInt] = GetPlayerInterior(playerid);
    BackpackData[backPackId][BpVw] = GetPlayerVirtualWorld(playerid);
    GetPlayerPos(playerid, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2]);
    GetPlayerName(playerid, BackpackData[backPackId][BPOwner], 50);
    Iter_Add(BackpackIT, backPackId);
    Backpack:DbInsert(backPackId);
    CallRemoteFunction("OnBackpackCreate", "d", backPackId);
    return backPackId;
}

stock Backpack:Save(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    CallRemoteFunction("OnBackpackSave", "d", backPackId);
    Backpack:DbSave(backPackId);
    return 1;
}

stock Backpack:Remove(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return -1;
    CallRemoteFunction("OnBackpackRemove", "d", backPackId);
    Backpack:DbRemove(backPackId);
    Iter_Remove(BackpackIT, backPackId);
    return 1;
}

stock Backpack:isValidBackpack(backPackId) {
    return Iter_Contains(BackpackIT, backPackId);
}

stock Backpack:isBackpackDropped(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    return BackpackData[backPackId][isDroped];
}

stock Backpack:SetBackpackDropState(backPackId, bool:status = false) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    BackpackData[backPackId][isDroped] = status;
    return 1;
}

stock Backpack:UpdateOwner(backPackId, playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    GetPlayerName(playerid, BackpackData[backPackId][BPOwner], 50);
    return 1;
}

stock Backpack:GetOwner(backPackId) {
    new string[100];
    if (!Backpack:isValidBackpack(backPackId)) return string;
    format(string, sizeof string, "%s", BackpackData[backPackId][BPOwner]);
    return string;
}

stock Backpack:GetInvItemQuantity(backPackId, inventoryId) {
    if (!Backpack:isValidBackpack(backPackId) || !Backpack:isValidInventoryItem(inventoryId)) return 0;
    return BackpackData[backPackId][inventoryQuantitiy][inventoryId];
}

forward OnBackpackCreate(backPackId);
public OnBackpackCreate(backPackId) {
    return 1;
}

forward OnBackpackSave(backPackId);
public OnBackpackSave(backPackId) {
    return 1;
}

forward OnBackpackRemove(backPackId);
public OnBackpackRemove(backPackId) {
    return 1;
}

forward OnBackpackLoad(backPackId);
public OnBackpackLoad(backPackId) {
    return 1;
}

// Inventory Functions

stock Backpack:AddInventoryItem(const title[], limit = 10) {
    new inventoryId = Iter_Free(BgInventoryDataIT);
    if (inventoryId == INVALID_ITERATOR_SLOT) return 0;
    format(BgInventoryData[inventoryId][BgTitle], 100, "%s", title);
    BgInventoryData[inventoryId][Bglimit] = limit;
    Iter_Add(BgInventoryDataIT, inventoryId);
    return inventoryId;
}

stock Backpack:RemoveInventoryItem(inventoryId) {
    if (!Backpack:isValidInventoryItem(inventoryId)) return 0;
    Iter_Remove(BgInventoryDataIT, inventoryId);
    return 1;
}

stock Backpack:isValidInventoryItem(inventoryId) {
    return Iter_Contains(BgInventoryDataIT, inventoryId);
}

stock Backpack:GetInvMaxLimit(inventoryId) {
    if (!Backpack:isValidInventoryItem(inventoryId)) return 0;
    return BgInventoryData[inventoryId][Bglimit];
}

stock Backpack:GetInvItemTitle(inventoryId) {
    new string[100];
    if (!Backpack:isValidInventoryItem(inventoryId)) return string;
    format(string, sizeof string, "%s", BgInventoryData[inventoryId][BgTitle]);
    return string;
}

// Push into back pack Function
stock Backpack:PushItem(backPackId, inventoryId, quantity) {
    if (!Backpack:isValidBackpack(backPackId) || !Backpack:isValidInventoryItem(inventoryId)) return 0;
    if (Backpack:GetInvMaxLimit(inventoryId) < (Backpack:GetInvItemQuantity(backPackId, inventoryId) + quantity)) return 0;
    BackpackData[backPackId][inventoryQuantitiy][inventoryId] = Backpack:GetInvItemQuantity(backPackId, inventoryId) + quantity;
    return 1;
}

stock Backpack:PopItem(backPackId, inventoryId, quantity) {
    if (!Backpack:isValidBackpack(backPackId) || !Backpack:isValidInventoryItem(inventoryId)) return 0;
    if (Backpack:GetInvItemQuantity(backPackId, inventoryId) < quantity) return 0;
    BackpackData[backPackId][inventoryQuantitiy][inventoryId] = Backpack:GetInvItemQuantity(backPackId, inventoryId) - quantity;
    return 1;
}

// Backpack Database functions

stock Backpack:DbInsert(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    new query[512];
    mysql_format(Database, query, sizeof(query), "INSERT INTO `backpack`(`ID`, `Username`, `COORD_X`, `COORD_Y`, `COORD_Z`, `BP_INT`, `BP_VW`) VALUES ('%d', \"%s\",'%f','%f','%f','%d','%d')",
        backPackId, BackpackData[backPackId][BPOwner], BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2], BackpackData[backPackId][BpInt], BackpackData[backPackId][BpVw]);
    mysql_tquery(Database, query);
    return backPackId;
}

stock Backpack:DbRemove(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    new query[512];
    mysql_format(Database, query, sizeof(query), "DELETE FROM `backpack` WHERE `ID`='%d'", backPackId);
    mysql_tquery(Database, query);
    return backPackId;
}

stock Backpack:DbSave(backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    new query[512];
    mysql_format(Database, query, sizeof(query), "update backpack SET `Username` = \"%s\", `COORD_X` = \"%f\", `COORD_Y` = \"%f\", `COORD_Z` = \"%f\", `BP_INT` = \"%d\", `BP_VW` = \"%d\" where ID=\"%d\"",
        BackpackData[backPackId][BPOwner], BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2], BackpackData[backPackId][BpInt], BackpackData[backPackId][BpVw], backPackId);
    mysql_tquery(Database, query);
    return backPackId;
}

// Backpack drop take functions

hook OnPlayerLogin(playerid) {
    Backpack:SetPlayerBackpackID(playerid, -1);
    return 1;
}

stock Backpack:Drop(playerid, backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    if (Backpack:isBackpackDropped(backPackId)) return 0;
    if (Backpack:GetPlayerBackpackID(playerid) != backPackId) return 0;
    BackpackData[backPackId][BpInt] = GetPlayerInterior(playerid);
    BackpackData[backPackId][BpVw] = GetPlayerVirtualWorld(playerid);
    GetPlayerPos(playerid, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2]);
    BackpackData[backPackId][BgObjectID] = CreateDynamicObject(BackpackModel, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 1, -90.0, 0.0, 0.0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
    BackpackData[backPackId][BgLabel] = CreateDynamic3DTextLabel(sprintf("{FFFFFF} Backpack:{FF6F00} %d\n{FFFFFF} Owner:{FF6F00} %s \n{FFFFFF}Take:{FF6F00} press N", backPackId, Backpack:GetOwner(backPackId)), 0x317CDFFF, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 0.5, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
    Backpack:SetPlayerBackpackID(playerid, -1);
    Backpack:SetBackpackDropState(backPackId, true);
    RemovePlayerAttachedObject(playerid, BackpackAttachIndex);
    Backpack:Save(backPackId);
    return 1;
}

stock Backpack:Take(playerid, backPackId) {
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    if (!Backpack:isBackpackDropped(backPackId)) return 0;
    if (IsValidDynamicObject(BackpackData[backPackId][BgObjectID])) DestroyDynamicObjectEx(BackpackData[backPackId][BgObjectID]);
    if (IsValidDynamic3DTextLabel(BackpackData[backPackId][BgLabel])) DestroyDynamic3DTextLabel(BackpackData[backPackId][BgLabel]);
    BackpackData[backPackId][BgObjectID] = -1;
    BackpackData[backPackId][BgLabel] = Text3D:  - 1;
    SetPlayerAttachedObject(playerid, BackpackAttachIndex, BackpackModel, 1, -0.165999, -0.040000, 0.000000, 0.000000, 0.000000, -3.199999, 1.000000, 1.000000, 1.000000);
    Backpack:SetPlayerBackpackID(playerid, backPackId);
    Backpack:SetBackpackDropState(backPackId, false);
    return 1;
}

stock GetPlayerNearestBackpack(playerid) {
    foreach(new backPackId:BackpackIT) {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2]) && BackpackData[backPackId][BpInt] == GetPlayerInterior(playerid) && BackpackData[backPackId][BpVw] == GetPlayerVirtualWorld(playerid)) return backPackId;
    }
    return -1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO) return 1;
    if (Backpack:GetPlayerBackpackID(playerid) != -1) return 1;
    new backPackId = GetPlayerNearestBackpack(playerid);
    if (backPackId == -1) return 1;
    Backpack:Take(playerid, backPackId);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!IsPlayerLoggedIn(playerid)) return 1;
    if (Backpack:GetPlayerBackpackID(playerid) != -1) Backpack:Drop(playerid, Backpack:GetPlayerBackpackID(playerid));
    return 1;
}

// Game Mode Init
hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `backpack` ( `ID` int(11) NOT NULL, PRIMARY KEY  (`ID`), `Username` varchar(50) NOT NULL, `COORD_X` float NOT NULL,`COORD_Y` float NOT NULL,`COORD_Z` float NOT NULL,`BP_INT` int(11) NOT NULL,`BP_VW` int(11) NOT NULL)");
    mysql_tquery(Database, "SELECT * FROM backpack", "LoadBackPackData", "");
    CallRemoteFunction("OnInventoryInit", "");
    return 1;
}

forward LoadBackPackData();
public LoadBackPackData() {
    new rows = cache_num_rows();
    if (rows) {
        new count = 0, backPackId;
        while (count < rows) {
            cache_get_value_name_int(count, "ID", backPackId);
            cache_get_value_name(count, "username", BackpackData[backPackId][BPOwner], 50);
            cache_get_value_name_float(count, "COORD_X", BackpackData[backPackId][BPPos][0]);
            cache_get_value_name_float(count, "COORD_Y", BackpackData[backPackId][BPPos][1]);
            cache_get_value_name_float(count, "COORD_Z", BackpackData[backPackId][BPPos][2]);
            cache_get_value_name_int(count, "BP_INT", BackpackData[backPackId][BpInt]);
            cache_get_value_name_int(count, "BP_VW", BackpackData[backPackId][BpVw]);
            Iter_Add(BackpackIT, backPackId);
            BackpackData[backPackId][BgObjectID] = CreateDynamicObject(BackpackModel, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 1, -90.0, 0.0, 0.0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
            BackpackData[backPackId][BgLabel] = CreateDynamic3DTextLabel(sprintf("{FFFFFF} Backpack:{FF6F00} %d\n{FFFFFF} Owner:{FF6F00} %s \n{FFFFFF}Take:{FF6F00} press N", backPackId, Backpack:GetOwner(backPackId)), 0x317CDFFF, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 0.5, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
            Backpack:SetBackpackDropState(backPackId, true);
            count++;
        }
    }
    foreach(new backPackId:BackpackIT) {
        CallRemoteFunction("OnBackpackLoad", "d", backPackId);
    }
    printf("  [Inventory System] Loaded %d Backpacks.", rows);
    return 1;
}

forward OnInventoryInit();
public OnInventoryInit() {
    return 1;
}

// Bac Pack player functions

stock Backpack:ShowToPlayer(playerid, backPackId, page = 1) {
    new string[2000];
    strcat(string, "ID\tItem\tLimit\tQuantitiy\n");
    new perPageRow = 10, totalRows = Iter_Count(BgInventoryDataIT);
    new leftRows = totalRows - (perPageRow * page);
    new skip = (page - 1) * perPageRow;
    new count = 0, skipped = 0;
    foreach(new inventoryId:BgInventoryDataIT) {
        if (skipped != skip) {
            skipped++;
            continue;
        }
        strcat(string, sprintf("%d\t%s\t%d\t%d\n", inventoryId, Backpack:GetInvItemTitle(inventoryId), Backpack:GetInvMaxLimit(inventoryId), Backpack:GetInvItemQuantity(backPackId, inventoryId)));
        count++;
        if (count == perPageRow) break;
    }
    if (leftRows > 0 && totalRows > perPageRow) strcat(string, "Next Page");
    if (leftRows < 1 && totalRows > perPageRow && page != 1) strcat(string, "Back Page");
    return FlexPlayerDialog(playerid, "BackPackMenuMain", DIALOG_STYLE_TABLIST_HEADERS, "[Backpack]:Inventory", string, "Select", "Cancel", backPackId, sprintf("%d", page));
}

FlexDialog:BackPackMenuMain(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    new page = strval(payload);
    if (IsStringSame(inputtext, "Next Page")) return Backpack:ShowToPlayer(playerid, backPackId, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Backpack:ShowToPlayer(playerid, backPackId, page - 1);
    CallRemoteFunction("OnPlayerReqestBpItem", "ddd", playerid, backPackId, strval(inputtext));
    return 1;
}

stock Backpack:ShareToPlayer(playerid, targetid) {
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return 0;
    new string[2000];
    strcat(string, "ID\tItem\tLimit\tQuantitiy\n");
    foreach(new inventoryId:BgInventoryDataIT) {
        strcat(string, sprintf("%d\t%s\t%d\t%d\n", inventoryId, Backpack:GetInvItemTitle(inventoryId), Backpack:GetInvMaxLimit(inventoryId), Backpack:GetInvItemQuantity(backPackId, inventoryId)));
    }
    return FlexPlayerDialog(playerid, "BackPackMenuShare", DIALOG_STYLE_TABLIST_HEADERS, "[Backpack]:Inventory", string, "Share", "Cancel", targetid);
}

FlexDialog:BackPackMenuShare(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    CallRemoteFunction("OnPlayerShareBpItem", "ddd", playerid, backPackId, strval(inputtext));
    return 1;
}

// Handle Dialog Callback
forward OnPlayerReqestBpItem(playerid, backPackId, inventoryId);
public OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    return 1;
}

// don't forget to check that player has bagpack and get backpack id using player function

forward OnPlayerShareBpItem(playerid, targetid, inventoryId);
public OnPlayerShareBpItem(playerid, targetid, inventoryId) {
    return 1;
}

// Inventory Shop

stock IventoryShopOpen(playerid) {
    new string[2000];
    strcat(string, "Purchase Backpack {00FF00}($10,000)\n");
    strcat(string, "Sell Backpack {00FF00}($5,000)\n");
    return FlexPlayerDialog(playerid, "IventoryShopOpen", DIALOG_STYLE_LIST, "[Backpack]:Inventory", string, "Select", "Cancel");
}

FlexDialog:IventoryShopOpen(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) {
        if (GetPlayerCash(playerid) < 10000) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} you don't have enough money");
            return IventoryShopOpen(playerid);
        } else if (Backpack:GetPlayerBackpackID(playerid) != -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} please remove your current back pack to purchase new one");
            return IventoryShopOpen(playerid);
        }
        if (Backpack:Count(playerid) >= 3) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} you can not purchase more then 3 backpacks.");
            IventoryShopOpen(playerid);
        }
        new backPackId = Backpack:Add(playerid);
        if (backPackId == -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} we are out of stock, try again");
            return IventoryShopOpen(playerid);
        }
        Backpack:SetBackpackDropState(backPackId, false);
        BackpackData[backPackId][BgObjectID] = -1;
        BackpackData[backPackId][BgLabel] = Text3D:  - 1;
        Backpack:SetPlayerBackpackID(playerid, backPackId);
        GivePlayerCash(playerid, -BACKPACK_PURCHASE_PRICE, "purchased new back pack");
        vault:addcash(Vault_ID_Government, BACKPACK_PURCHASE_PRICE, Vault_Transaction_Cash_To_Vault, sprintf("%s purchased new back pack", GetPlayerNameEx(playerid)));
        SetPlayerAttachedObject(playerid, BackpackAttachIndex, BackpackModel, 1, -0.165999, -0.040000, 0.000000, 0.000000, 0.000000, -3.199999, 1.000000, 1.000000, 1.000000);
        return SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} congratulations, you have purchased brand new back pack.");
    }
    if (listitem == 1) {
        if (Backpack:GetPlayerBackpackID(playerid) == -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} please come back with your back pack to sell.");
            IventoryShopOpen(playerid);
            return ~1;
        }
        new backPackId = Backpack:Remove(Backpack:GetPlayerBackpackID(playerid));
        if (backPackId == -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} we can not accept this back at the movement, try again");
            IventoryShopOpen(playerid);
            return ~1;
        }
        RemovePlayerAttachedObject(playerid, BackpackAttachIndex);
        Backpack:SetPlayerBackpackID(playerid, -1);
        GivePlayerCash(playerid, BACKPACK_SELLING_PRICE, "sold back pack");
        vault:addcash(Vault_ID_Government, -BACKPACK_SELLING_PRICE, Vault_Transaction_Cash_To_Vault, sprintf("%s sold back pack", GetPlayerNameEx(playerid)));
        return SendClientMessage(playerid, -1, "{4286f4}[Inventory Shop]:{FFFFEE} congratulations, you have sold your back pack.");
    }
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 20) return 1;
    IventoryShopOpen(playerid);
    return ~1;
}

// UCP Inventory

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Backpack:GetPlayerBackpackID(playerid) != -1) UCP:AddCommand(playerid, "Backpack");
    if (Backpack:GetPlayerBackpackID(playerid) == -1 && GetPlayerNearestBackpack(playerid) != -1) UCP:AddCommand(playerid, "Take backpack");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Take backpack", inputtext)) {
        if (Backpack:GetPlayerBackpackID(playerid) != -1) return ~1;
        new backPackId = GetPlayerNearestBackpack(playerid);
        if (backPackId == -1) return ~1;
        Backpack:Take(playerid, backPackId);
        return ~1;
    }
    if (IsStringSame("Backpack", inputtext)) {
        FlexPlayerDialog(playerid, "BackPackMenuOp", DIALOG_STYLE_LIST, "[Backpack]:Inventory", "Access Backpack\nPlace Backpack here", "Select", "Cancel");
        return ~1;
    }
    return 1;
}

FlexDialog:BackPackMenuOp(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) Backpack:ShowToPlayer(playerid, Backpack:GetPlayerBackpackID(playerid));
    if (listitem == 1) Backpack:Drop(playerid, Backpack:GetPlayerBackpackID(playerid));
    return 1;
}

// Quick Action

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new PlayerBpID = Backpack:GetPlayerBackpackID(playerid);
    new TargetBpID = Backpack:GetPlayerBackpackID(targetid);
    if (PlayerBpID != -1) {
        if (IsStringSame(GetPlayerNameEx(playerid), Backpack:GetOwner(PlayerBpID)) && TargetBpID == -1) QuickActions:AddCommand(playerid, "Give Backpack");
    }
    if (PlayerBpID != -1 && TargetBpID != -1) QuickActions:AddCommand(playerid, "Share Backpack Item");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (IsStringSame("Share Backpack Item", inputtext)) return Backpack:ShareToPlayer(playerid, targetid);
    if (strcmp("Give Backpack", inputtext)) return 1;
    if (!response) return -1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return -1;
    Backpack:UpdateOwner(backPackId, targetid);
    Backpack:SetPlayerBackpackID(targetid, backPackId);
    SetPlayerAttachedObject(targetid, BackpackAttachIndex, BackpackModel, 1, -0.165999, -0.040000, 0.000000, 0.000000, 0.000000, -3.199999, 1.000000, 1.000000, 1.000000);
    Backpack:SetPlayerBackpackID(playerid, -1);
    RemovePlayerAttachedObject(playerid, BackpackAttachIndex);
    Backpack:Save(backPackId);
    return ~1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `backpack` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    foreach(new backPackId:BackpackIT) {
        if (IsStringSame(BackpackData[backPackId][BPOwner], OldName)) {
            format(BackpackData[backPackId][BPOwner], 50, "%s", NewName);
        }
    }
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `backpack` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}

cmd:findbackpack(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    new found = 0;
    foreach(new backPackId:BackpackIT) {
        if (IsStringSame(GetPlayerNameEx(playerid), Backpack:GetOwner(backPackId))) {
            AlexaMsg(playerid, sprintf("Backpack [%d], x: %f, y: %f, z: %f, int: %d, vw: %d", backPackId, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2], BackpackData[backPackId][BpInt], BackpackData[backPackId][BpVw]));
            found++;
        }
    }
    if (found == 0) AlexaMsg(playerid, "do you even have a backpack?");
    return 1;
}

ACP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Backpack System");
    return 1;
}

ACP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Backpack System", inputtext)) {
        Backpack:AdminMenu(playerid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "backpack system") && GetPlayerAdminLevel(playerid) > 8) {
        Backpack:AdminMenu(playerid);
        return ~1;
    }
    return 1;
}

Backpack:AdminMenu(playerid) {
    return FlexPlayerDialog(
        playerid, "BackpackAdminMenu", DIALOG_STYLE_LIST, "Backpack System", "Manage Backpack\nFind Player Backpack", "Select", "Close"
    );
}

FlexDialog:BackpackAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage Backpack")) {
        return Backpack:AdminManageBackpackInput(playerid);
    }
    if (IsStringSame(inputtext, "Find Player Backpack")) {
        return Backpack:AdminMenuPlayerInput(playerid);
    }
    return 1;
}

Backpack:AdminManageBackpackInput(playerid) {
    return FlexPlayerDialog(
        playerid, "AdminManageBackpackInput", DIALOG_STYLE_INPUT, "Backpack System", "Enter backpack id", "Submit", "Close"
    );
}

FlexDialog:AdminManageBackpackInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Backpack:AdminMenu(playerid);
    new backPackId;
    if (sscanf(inputtext, "d", backPackId) || !Backpack:isValidBackpack(backPackId)) {
        return Backpack:AdminManageBackpackInput(playerid);
    }
    Backpack:AdminManageBackpack(playerid, backPackId);
    return 1;
}

stock Backpack:AdminManageBackpack(playerid, backPackId) {
    new string[512];
    strcat(string, "Goto\n");
    strcat(string, "Get\n");
    strcat(string, "Location\n");
    return FlexPlayerDialog(
        playerid, "AdminManageBackpack", DIALOG_STYLE_LIST, "Backpack System", string, "Submit", "Close", backPackId
    );
}

FlexDialog:AdminManageBackpack(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return Backpack:AdminManageBackpackInput(playerid);
    if (IsStringSame(inputtext, "Goto")) {
        SetPlayerVirtualWorldEx(playerid, BackpackData[backPackId][BpVw]);
        SetPlayerInteriorEx(playerid, BackpackData[backPackId][BpInt]);
        SetPlayerPosEx(playerid, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2]);
    }
    if (IsStringSame(inputtext, "Get")) {
        if (!Backpack:isBackpackDropped(backPackId)) {
            AlexaMsg(playerid, "backpack is not placed, it is used by some player");
        } else {
            new Float:pos[3];
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            BackpackData[backPackId][BPPos][0] = pos[0];
            BackpackData[backPackId][BPPos][1] = pos[1];
            BackpackData[backPackId][BPPos][2] = pos[2];
            BackpackData[backPackId][BpVw] = GetPlayerVirtualWorldID(playerid);
            BackpackData[backPackId][BpInt] = GetPlayerInteriorID(playerid);
            if (IsValidDynamicObject(BackpackData[backPackId][BgObjectID])) DestroyDynamicObjectEx(BackpackData[backPackId][BgObjectID]);
            if (IsValidDynamic3DTextLabel(BackpackData[backPackId][BgLabel])) DestroyDynamic3DTextLabel(BackpackData[backPackId][BgLabel]);
            BackpackData[backPackId][BgObjectID] = CreateDynamicObject(BackpackModel, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 1, -90.0, 0.0, 0.0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
            BackpackData[backPackId][BgLabel] = CreateDynamic3DTextLabel(sprintf("{FFFFFF} Backpack:{FF6F00} %d\n{FFFFFF} Owner:{FF6F00} %s \n{FFFFFF}Take:{FF6F00} press N", backPackId, Backpack:GetOwner(backPackId)), 0x317CDFFF, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2] - 0.5, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BackpackData[backPackId][BpVw], BackpackData[backPackId][BpInt]);
        }
    }
    if (IsStringSame(inputtext, "Location")) {
        AlexaMsg(playerid, sprintf("Backpack [%d], x: %f, y: %f, z: %f, int: %d, vw: %d", backPackId, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2], BackpackData[backPackId][BpInt], BackpackData[backPackId][BpVw]));
    }
    return Backpack:AdminManageBackpack(playerid, backPackId);
}

Backpack:AdminMenuPlayerInput(playerid) {
    return FlexPlayerDialog(
        playerid, "BackpackMenuPlayerInput", DIALOG_STYLE_INPUT, "Backpack System", "Enter playername", "Submit", "Close"
    );
}

FlexDialog:BackpackMenuPlayerInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Backpack:AdminMenu(playerid);
    new username[50];
    if (sscanf(inputtext, "s[50]", username) || !IsValidAccount(username)) {
        return Backpack:AdminMenuPlayerInput(playerid);
    }
    new found = 0;
    foreach(new backPackId:BackpackIT) {
        if (IsStringSame(username, Backpack:GetOwner(backPackId))) {
            AlexaMsg(playerid, sprintf("Backpack [%d], x: %f, y: %f, z: %f, int: %d, vw: %d", backPackId, BackpackData[backPackId][BPPos][0], BackpackData[backPackId][BPPos][1], BackpackData[backPackId][BPPos][2], BackpackData[backPackId][BpInt], BackpackData[backPackId][BpVw]));
            found++;
        }
    }
    if (found == 0) AlexaMsg(playerid, "maybe player does not have a backpack");
    return Backpack:AdminMenu(playerid);
}


// Import all inventory itemds
#include "IORP_SYSTEM/systems/Inventory/index.pwn"