new D_CLOTHES;
enum {
    ON_CLOTHES_LIST,
    ON_CLOTHES_NONE,
    ON_CLOTHES_CHOSE,
    ON_CLOTHES_BONE,
    ON_CLOTHES_BUY
};
#define NEXT_PAGE_SLOT 50

/**************************************************************************************/
#define MAX_MODELS 10

enum _PLAYER_MODELS {
    cID,
    cModelID,
    cBoneID,
    Float:cOffsetX,
    Float:cOffsetY,
    Float:cOffsetZ,
    Float:cRotX,
    Float:cRotY,
    Float:cRotZ,
    Float:cScaleX,
    Float:cScaleY,
    Float:cScaleZ,
    bool:cOn,
}

new ClothesInfo[MAX_PLAYERS][MAX_MODELS][_PLAYER_MODELS];
new csx_msg[512], csx_query[512], dstr[500];
/**************************************************************************************/

enum _MODELS_INFO {
    modelID,
    modelName[128],
    modelPrice,
    modelBone
}

new ModelsInfo[][_MODELS_INFO] = {
    { 18926, "Army Hat", 700, 2 },
    { 18927, "Azure Hat", 700, 2 },
    { 18928, "Funky Hat", 700, 2 },
    { 18929, "Dark Gray Hat", 700, 2 },
    { 18930, "Fire Hat", 700, 2 },
    { 18931, "Dark Blue Hat", 700, 2 },
    { 18932, "Orange Hat", 700, 2 },
    { 18933, "Light Gray Hat", 700, 2 },
    { 18934, "Pink Hat", 700, 2 },
    { 18935, "Yellow Hat", 700, 2 },
    { 18944, "Fire Hat Boater", 1000, 2 },
    { 18945, "Gray Hat Boater", 1000, 2 },
    { 18946, "Gray Hat Boater 2", 1000, 2 },
    { 18947, "Black Hat Bowler", 1000, 2 },
    { 18948, "Azure Hat Bowler", 1000, 2 },
    { 18949, "Green Hat Bowler", 1000, 2 },
    { 18950, "Red Hat Bowler", 1000, 2 },
    { 18951, "Light Green Hat Bowler", 1000, 2 },
    { 19488, "White Hat Bowler", 1000, 2 },
    { 18967, "Simple Black Hat", 500, 2 },
    { 18968, "Simple Gray Hat", 500, 2 },
    { 18969, "Simple Orange Hat", 500, 2 },
    { 18970, "Tiger Hat", 1000, 2 },
    { 18971, "Black & White Cool Hat", 1000, 2 },
    { 18972, "Black & Orange Cool Hat", 1000, 2 },
    { 18973, "Black & Green Cool Hat", 1000, 2 },
    { 19066, "Santa Hat", 3000, 2 },
    { 19067, "Red Hoody Hat", 500, 2 },
    { 19068, "Tiger Hoody Hat", 500, 2 },
    { 19069, "Black Hoody Hat", 500, 2 },
    { 19093, "White Dude Hat", 1300, 2 },
    { 19095, "Brown Cowboy Hat", 1300, 2 },
    { 19096, "Black Cowboy Hat", 1300, 2 },
    { 19097, "Black Cowboy Hat 2", 1300, 2 },
    { 19098, "Brown Cowboy Hat 2", 1300, 2 },
    { 19352, "Black Top Hat", 2000, 2 },
    { 19487, "White Top Hat", 2000, 2 },
    { 18964, "Black Skully Cap", 700, 2 },
    { 18965, "Brown Skully Cap", 700, 2 },
    { 18966, "Funky Skully Cap", 700, 2 },
    { 18921, "Blue Beret", 500, 2 },
    { 18922, "Red Beret", 500, 2 },
    { 18923, "Dark Blue Beret", 500, 2 },
    { 18924, "Army Beret", 500, 2 },
    { 18925, "Red Army Beret", 500, 2 },
    { 18939, "Dark Blue CapBack", 1000, 2 },
    { 18940, "Azure CapBack", 1000, 2 },
    { 18941, "Black CapBack", 1000, 2 },
    { 18942, "Gray CapBack", 1000, 2 },
    { 18943, "Green CapBack", 1000, 2 },
    { 19006, "Red Glasses", 1000, 2 },
    { 19007, "Green Glasses", 1000, 2 },
    { 19008, "Yellow Glasses", 1000, 2 },
    { 19009, "Azure Glasses", 1000, 2 },
    { 19010, "Pink Glasses", 1000, 2 },
    { 19011, "Funky Glasses", 1000, 2 },
    { 19012, "Gray Glasses", 1000, 2 },
    { 19013, "Funky Glasses 2", 1000, 2 },
    { 19014, "Black & White Glasses", 1000, 2 },
    { 19015, "White Glasses", 1000, 2 },
    { 19016, "X-Ray Glasses", 3000, 2 },
    { 19017, "Covered Yellow Glasses", 1000, 2 },
    { 19018, "Covered Orange Glasses", 1000, 2 },
    { 19019, "Covered Red Glasses", 1000, 2 },
    { 19020, "Covered Blue Glasses", 1000, 2 },
    { 19021, "Covered Green Glasses", 1000, 2 },
    { 19022, "Cool Black Glasses", 1000, 2 },
    { 19023, "Cool Azure Glasses", 1000, 2 },
    { 19024, "Cool Blue Glasses", 1000, 2 },
    { 19025, "Cool Pink Glasses", 1000, 2 },
    { 19026, "Cool Red Glasses", 1000, 2 },
    { 19027, "Cool Orange Glasses", 1000, 2 },
    { 19028, "Cool Yellow Glasses", 1000, 2 },
    { 19029, "Cool Yellow Glasses", 1000, 2 },
    { 19030, "Pink Nerd Glasses", 1500, 2 },
    { 19031, "Green Nerd Glasses", 1500, 2 },
    { 19032, "Red Nerd Glasses", 1500, 2 },
    { 19033, "Black Nerd Glasses", 1500, 2 },
    { 19034, "Black & White Nerd Glasses", 1500, 2 },
    { 19035, "Ocean Nerd Glasses", 1500, 2 },
    { 18891, "Purple Bandana", 1200, 2 },
    { 18892, "Red Bandana", 1200, 2 },
    { 18893, "Red&White Bandana", 1200, 2 },
    { 18894, "Orange Bandana", 1200, 2 },
    { 18895, "Skull Bandana", 1200, 2 },
    { 18896, "Black Bandana", 1200, 2 },
    { 18897, "Blue Bandana", 1200, 2 },
    { 18898, "Green Bandana", 1200, 2 },
    { 18899, "Pink Bandana", 1200, 2 },
    { 18900, "Funky Bandana", 1200, 2 },
    { 18901, "Tiger Bandana", 1200, 2 },
    { 18902, "Yellow Bandana", 1200, 2 },
    { 18903, "Azure Bandana", 1200, 2 },
    { 18904, "Dark Blue Bandana", 1200, 2 },
    { 18905, "Olive Bandana", 1200, 2 },
    { 18906, "Orange&Yellow Bandana", 800, 2 },
    { 18907, "Funky Bandana 2", 800, 2 },
    { 18907, "Blue Bandana 2", 800, 2 },
    { 18907, "Azure Bandana 2", 800, 2 },
    { 18907, "Fire Bandana", 800, 2 },
    { 18911, "Skull Bandana Mask", 1200, 18 },
    { 18912, "Black Bandana Mask", 1200, 18 },
    { 18913, "Green Bandana Mask", 1200, 18 },
    { 18914, "Army Bandana Mask", 1200, 18 },
    { 18915, "Funky Bandana Mask", 1200, 18 },
    { 18916, "Light Bandana Mask", 1200, 18 },
    { 18917, "Dark Blue Bandana Mask", 1200, 18 },
    { 18918, "Gray Bandana Mask", 1200, 18 },
    { 18919, "White Bandana Mask", 1200, 18 },
    { 18920, "Colorful Bandana Mask", 1200, 18 },
    { 19421, "White Headphones", 2000, 2 },
    { 19422, "Black Headphones", 2000, 2 },
    { 19423, "Gray Headphones", 2000, 2 },
    { 19424, "Blue Headphones", 2000, 2 },
    { 19036, "White Hockey Mask", 1200, 2 },
    { 19037, "Red Hockey Mask", 1200, 2 },
    { 19038, "Green Hockey Mask", 1200, 2 },
    { 19472, "Gas Mask", 2000, 2 },
    { 2919, "Sports Bag", 1500, 5 },
    { 3026, "Jansport Backpack", 1500, 1 },
    { 18645, "Red&White Motorcycle Helmet", 4000, 2 },
    { 18976, "Blue Motorcycle Helmet", 4000, 2 },
    { 18977, "Red Motorcycle Helmet", 4000, 2 },
    { 18978, "White Motorcycle Helmet", 4000, 2 },
    { 18979, "Purple Motorcycle Helmet", 4000, 2 },
    { 19317, "Bass Guitar", 14000, 1 },
    { 19318, "Flying Guitar", 15000, 1 },
    { 19319, "Warlock Guitar", 16000, 1 }
};

/**************************************************************************************/
stock Clothes_Accessories_Name(id) {
    new name[64];
    format(name, sizeof(name), "%s", ModelsInfo[id][modelName]);
    return name;
}

stock Clothes_Accessories_Price(id) {
    return ModelsInfo[id][modelPrice];
}

stock Clothes_Accessories_Model_ID(id) {
    return ModelsInfo[id][modelID];
}

stock Clothes_Accessories_Model_Name(cmodel) {
    new name[64];
    for (new i = 0; i < sizeof(ModelsInfo); i++) {
        if (cmodel == ModelsInfo[i][modelID]) {
            format(name, sizeof(name), "%s", ModelsInfo[i][modelName]);
        }
    }
    return name;
}

stock Clothes_Accessories_Real_ID(shopItemId) {
    for (new i; i < 128; i++) {
        if (shopItemId == (i + 569)) return i;
    }
    return -1;
}

hook OnGameModeInit() {
    D_CLOTHES = Dialog:GetFreeID();
    strcat(csx_query, "CREATE TABLE IF NOT EXISTS `clothes` (\
	`ID` int(11) NOT NULL auto_increment,\
	`holder` varchar(64) default NULL,\
	`cmodel` int(11) default NULL,\
	`bone` int(11) default NULL,\
	`offestx` float default NULL,\
	`offesty` float default NULL,\
	`offestz` float default NULL,");
    strcat(csx_query, "`rotx` float default NULL,\
	`roty` float default NULL,\
	`rotz` float default NULL,\
	`scalex` float default NULL,\
	`scaley` float default NULL,\
	`scalez` float default NULL,\
	PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, csx_query);
    return 1;
}

stock LoadPlayerClothes(playerid) {
    format(csx_query, sizeof(csx_query), "SELECT * FROM `clothes` WHERE `holder` = \"%s\"", GetPlayerNameEx(playerid));
    mysql_tquery(Database, csx_query, "OnClothesLoad", "i", playerid);
}

forward OnClothesLoad(playerid);
public OnClothesLoad(playerid) {
    new rows = cache_num_rows();
    if (rows) {
        for (new i = 0; i < rows; i++) {
            cache_get_value_name_int(i, "ID", ClothesInfo[playerid][i + 6][cID]);
            cache_get_value_name_int(i, "cmodel", ClothesInfo[playerid][i + 6][cModelID]);
            cache_get_value_name_int(i, "bone", ClothesInfo[playerid][i + 6][cBoneID]);
            cache_get_value_name_float(i, "offestx", ClothesInfo[playerid][i + 6][cOffsetX]);
            cache_get_value_name_float(i, "offesty", ClothesInfo[playerid][i + 6][cOffsetY]);
            cache_get_value_name_float(i, "offestz", ClothesInfo[playerid][i + 6][cOffsetZ]);
            cache_get_value_name_float(i, "rotx", ClothesInfo[playerid][i + 6][cRotX]);
            cache_get_value_name_float(i, "roty", ClothesInfo[playerid][i + 6][cRotY]);
            cache_get_value_name_float(i, "rotz", ClothesInfo[playerid][i + 6][cRotZ]);
            cache_get_value_name_float(i, "scalex", ClothesInfo[playerid][i + 6][cScaleX]);
            cache_get_value_name_float(i, "scaley", ClothesInfo[playerid][i + 6][cScaleY]);
            cache_get_value_name_float(i, "scalez", ClothesInfo[playerid][i + 6][cScaleZ]);
            ClothesInfo[playerid][i + 6][cOn] = true;
        }
    }
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    LoadPlayerClothes(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    SavePlayerClothes(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    ResetClothes(playerid);
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    new status = GetPVarInt(playerid, "DialogStatus");
    if (dialogid == D_CLOTHES) {
        switch (status) {
            case ON_CLOTHES_LIST:  {
                if (response) {
                    new i = listitem + 6;
                    if (!ClothesInfo[playerid][i][cOn]) {
                        ShowDialog(playerid, D_CLOTHES, DIALOG_STYLE_MSGBOX, "Clothing List", "Empty index...", "<<<", "", ON_CLOTHES_NONE);
                    } else {
                        SetPVarInt(playerid, "IndexChose", i);
                        ClothesEditDialog(playerid, i);
                    }
                }
            }
            case ON_CLOTHES_NONE:  {
                if (response || !response) {
                    DisplayClothing(playerid);
                }
            }
            case ON_CLOTHES_CHOSE:  {
                if (response) {
                    new slot = GetPVarInt(playerid, "IndexChose");
                    switch (listitem) {
                        case 0 :  {
                            EditClothing(playerid, slot);
                        }
                        case 1 :  {
                            ShowDialog(playerid, D_CLOTHES, DIALOG_STYLE_LIST, "Change The Bone Slot", "Spine\nHead\nLeft Upper Arm\nRight Upper Arm\nLeft Hand\nRight Hand\nLeft Thigh\nRight Thigh\nLeft Food\nRight Foot\nRight Calf\nLeft Calf\nLeft Forearm\nRight forearm\nLeft Clavicle\nRight Clavicle\nNeck\nJaw", "Select", "<<<", ON_CLOTHES_BONE);
                        }
                        case 2 :  {
                            PlaceClothing(playerid, slot);
                            ClothesEditDialog(playerid, slot);
                        }
                        case 3 :  {
                            format(csx_msg, sizeof(csx_msg), "You have dropped your {00FF00}%s{FFFFFF}, and will be no longer available.", Clothes_Accessories_Model_Name(ClothesInfo[playerid][slot][cModelID]));
                            SendClientMessageEx(playerid, -1, csx_msg);
                            RemoveFromSlot(playerid, slot);
                        }
                    }
                } else {
                    DisplayClothing(playerid);
                }
            }
            case ON_CLOTHES_BONE:  {
                new index = GetPVarInt(playerid, "IndexChose");
                if (response) {
                    new bone = listitem + 1;
                    format(csx_msg, sizeof(csx_msg), "You have adjusted your clothing index %d to bone %s.", index, GetBoneName(bone));
                    SendClientMessageEx(playerid, COLOR_WHITE, csx_msg);
                    ClothesInfo[playerid][index][cBoneID] = bone;
                    if (IsPlayerAttachedObjectSlotUsed(playerid, index)) {
                        ReplaceClothing(playerid, index);
                    }
                    ClothesEditDialog(playerid, index);
                } else {
                    ClothesEditDialog(playerid, index);
                }
            }
        }
    }
    return 1;
}

stock GetFreeSlot(playerid) {
    for (new i = 6; i < MAX_MODELS; i++) {
        if (!ClothesInfo[playerid][i][cOn])
            return i;
    }
    return ~1;
}

stock OnBuyClothes(playerid, index, cmodel, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ) {
    format(csx_query, sizeof(csx_query), "INSERT INTO `clothes` (holder, cmodel, bone, offestx, offesty, offestz, rotx, roty, rotz, scalex, scaley, scalez) VALUES (\"%s\", %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f)",
        GetPlayerNameEx(playerid), cmodel, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
    mysql_tquery(Database, csx_query, "OnFinishPurchase", "id", playerid, index);
}

forward OnFinishPurchase(playerid, index);
public OnFinishPurchase(playerid, index) {
    ClothesInfo[playerid][index][cID] = cache_insert_id();
    return 1;
}

stock ClothesEditDialog(playerid, index) {
    if (IsPlayerAttachedObjectSlotUsed(playerid, index)) {
        ShowDialog(playerid, D_CLOTHES, DIALOG_STYLE_LIST, "Clothing List", "Adjust The Item\nChange Bone Slot\nTake Off\nRemove Item", "Select", "<<<", ON_CLOTHES_CHOSE);
    } else {
        ShowDialog(playerid, D_CLOTHES, DIALOG_STYLE_LIST, "Clothing List", "Adjust The Item\nChange Bone Slot\nPlace On\nRemove Item", "Select", "<<<", ON_CLOTHES_CHOSE);
    }
}

hook OPEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ) {
    if (GetPVarInt(playerid, "EditingNow") == 1) {
        new i = GetPVarInt(playerid, "EditingSlot");
        if (response) {
            ClothesInfo[playerid][i][cOffsetX] = fOffsetX;
            ClothesInfo[playerid][i][cOffsetY] = fOffsetY;
            ClothesInfo[playerid][i][cOffsetZ] = fOffsetZ;
            ClothesInfo[playerid][i][cRotX] = fRotX;
            ClothesInfo[playerid][i][cRotY] = fRotY;
            ClothesInfo[playerid][i][cRotZ] = fRotZ;
            ClothesInfo[playerid][i][cScaleX] = fScaleX;
            ClothesInfo[playerid][i][cScaleY] = fScaleY;
            ClothesInfo[playerid][i][cScaleZ] = fScaleZ;
        }
        DeletePVar(playerid, "EditingSlot");
        DeletePVar(playerid, "EditingNow");
        ReplaceClothing(playerid, i);
    }
    if (GetPVarInt(playerid, "SelectedItem") == 1 && GetPVarInt(playerid, "EditingNow") == 0) {
        new shopid = GetPVarInt(playerid, "CSelectedShopID");
        new shopItemId = GetPVarInt(playerid, "CSelectedItemNum");
        new i = GetPVarInt(playerid, "ItemIndex");
        new slot = GetPVarInt(playerid, "FreeSlot");
        if (response) {
            OnBuyClothes(playerid, slot, ModelsInfo[i][modelID], ModelsInfo[i][modelBone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
            new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
            GivePlayerCash(playerid, -price, sprintf("Purchased %s clothes accessories from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
            DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased cloth accessories item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
            DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
            format(csx_msg, sizeof(csx_msg), "You have successfully purchased a {FFFF00}%s{FFFFFF} for ${FFFF00}%d", ModelsInfo[i][modelName], ModelsInfo[i][modelPrice]);
            SendClientMessageEx(playerid, -1, csx_msg);
            SyntaxMSG(playerid, "You can manage your clothes in the closet in your house");
            ClothesInfo[playerid][slot][cModelID] = ModelsInfo[i][modelID];
            ClothesInfo[playerid][slot][cBoneID] = ModelsInfo[i][modelBone];
            ClothesInfo[playerid][slot][cOffsetX] = fOffsetX;
            ClothesInfo[playerid][slot][cOffsetY] = fOffsetY;
            ClothesInfo[playerid][slot][cOffsetZ] = fOffsetZ;
            ClothesInfo[playerid][slot][cRotX] = fRotX;
            ClothesInfo[playerid][slot][cRotY] = fRotY;
            ClothesInfo[playerid][slot][cRotZ] = fRotZ;
            ClothesInfo[playerid][slot][cScaleX] = fScaleX;
            ClothesInfo[playerid][slot][cScaleY] = fScaleY;
            ClothesInfo[playerid][slot][cScaleZ] = fScaleZ;
            ClothesInfo[playerid][slot][cOn] = true;
            ReplaceClothing(playerid, slot);
        } else {
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "You've canceled the purchase of this item.");
            RemovePlayerAttachedObject(playerid, index);
        }
        DeletePVar(playerid, "CSelectedItemNum");
        DeletePVar(playerid, "CSelectedItemNum");
        DeletePVar(playerid, "SelectedItem");
        DeletePVar(playerid, "ItemIndex");
        DeletePVar(playerid, "FreeSlot");
    }
    return 1;
}

stock SavePlayerClothes(playerid) {
    for (new i = 6; i < MAX_MODELS; i++) {
        if (ClothesInfo[playerid][i][cOn]) {
            UpdatePlayerToy(playerid, i);
        }
    }
    return 1;
}

stock UpdatePlayerToy(playerid, slot) {
    format(csx_query, sizeof(csx_query), "UPDATE `clothes` SET `bone` = %d, `offestx` = %f, `offesty` = %f, `offestz` = %f, `rotx` = %f, `roty` = %f, `rotz` = %f, `scalex` = %f, `scaley` = %f, `scalez` = %f WHERE `ID` = %d",
        ClothesInfo[playerid][slot][cBoneID], ClothesInfo[playerid][slot][cOffsetX], ClothesInfo[playerid][slot][cOffsetY], ClothesInfo[playerid][slot][cOffsetZ], ClothesInfo[playerid][slot][cRotX], ClothesInfo[playerid][slot][cRotY], ClothesInfo[playerid][slot][cRotZ], ClothesInfo[playerid][slot][cScaleX], ClothesInfo[playerid][slot][cScaleY], ClothesInfo[playerid][slot][cScaleZ], ClothesInfo[playerid][slot][cID]);
    mysql_tquery(Database, csx_query);
    return 1;
}

stock EditClothing(playerid, index) {
    if (GetPVarInt(playerid, "EditingNow") == 1) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please finish the current operation.");
    format(csx_msg, sizeof(csx_msg), "Editing now your {00FF00}%s{FFFFFF} - Index {00FF00}%d{FFFFFF}.", Clothes_Accessories_Model_Name(ClothesInfo[playerid][index][cModelID]), index);
    SendClientMessageEx(playerid, -1, csx_msg);
    SetPVarInt(playerid, "EditingSlot", index);
    SetPVarInt(playerid, "EditingNow", 1);
    if (!IsPlayerAttachedObjectSlotUsed(playerid, index)) {
        SetPlayerAttachedObject(playerid, index, ClothesInfo[playerid][index][cModelID], ClothesInfo[playerid][index][cBoneID], ClothesInfo[playerid][index][cOffsetX], ClothesInfo[playerid][index][cOffsetY], ClothesInfo[playerid][index][cOffsetZ], ClothesInfo[playerid][index][cRotX], ClothesInfo[playerid][index][cRotY], ClothesInfo[playerid][index][cRotZ], ClothesInfo[playerid][index][cScaleX], ClothesInfo[playerid][index][cScaleY], ClothesInfo[playerid][index][cScaleZ]);
    }
    EditAttachedObject(playerid, index);
    return 1;
}

stock ReplaceClothing(playerid, index) {
    RemovePlayerAttachedObject(playerid, index);
    SetPlayerAttachedObject(playerid, index, ClothesInfo[playerid][index][cModelID], ClothesInfo[playerid][index][cBoneID], ClothesInfo[playerid][index][cOffsetX], ClothesInfo[playerid][index][cOffsetY], ClothesInfo[playerid][index][cOffsetZ], ClothesInfo[playerid][index][cRotX], ClothesInfo[playerid][index][cRotY], ClothesInfo[playerid][index][cRotZ], ClothesInfo[playerid][index][cScaleX], ClothesInfo[playerid][index][cScaleY], ClothesInfo[playerid][index][cScaleZ]);
}

stock PlaceClothing(playerid, index) {
    if (IsPlayerAttachedObjectSlotUsed(playerid, index)) {
        format(csx_msg, sizeof(csx_msg), "You have removed your {00FF00}%s{FFFFFF}.", Clothes_Accessories_Model_Name(ClothesInfo[playerid][index][cModelID]));
        SendClientMessageEx(playerid, -1, csx_msg);
        RemovePlayerAttachedObject(playerid, index);
    } else {
        format(csx_msg, sizeof(csx_msg), "You have placed your {00FF00}%s{FFFFFF}.", Clothes_Accessories_Model_Name(ClothesInfo[playerid][index][cModelID]));
        SendClientMessageEx(playerid, -1, csx_msg);
        SetPlayerAttachedObject(playerid, index, ClothesInfo[playerid][index][cModelID], ClothesInfo[playerid][index][cBoneID], ClothesInfo[playerid][index][cOffsetX], ClothesInfo[playerid][index][cOffsetY], ClothesInfo[playerid][index][cOffsetZ], ClothesInfo[playerid][index][cRotX], ClothesInfo[playerid][index][cRotY], ClothesInfo[playerid][index][cRotZ], ClothesInfo[playerid][index][cScaleX], ClothesInfo[playerid][index][cScaleY], ClothesInfo[playerid][index][cScaleZ]);
    }
    return 1;
}

stock DisplayClothing(playerid) {
    for (new i = 6; i < MAX_MODELS; i++) {
        if (ClothesInfo[playerid][i][cOn]) {
            format(csx_msg, sizeof(csx_msg), "%s (Index %d)\n", Clothes_Accessories_Model_Name(ClothesInfo[playerid][i][cModelID]), i);
            strcat(dstr, csx_msg);
        } else {
            format(csx_msg, sizeof(csx_msg), "EMPTY (Index %d)\n", i);
            strcat(dstr, csx_msg);
        }
    }
    ShowDialog(playerid, D_CLOTHES, DIALOG_STYLE_LIST, "Clothes List", dstr, "Select", "Cancel", ON_CLOTHES_LIST);
    return 1;
}

stock ShowDialog(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[], status) {
    SetPVarInt(playerid, "DialogStatus", status);
    ShowPlayerDialogEx(playerid, dialogid, 0, style, caption, info, button1, button2);
    dstr = "";
    return 1;
}

stock RemoveFromSlot(playerid, slot) {
    format(csx_query, sizeof(csx_query), "DELETE FROM `clothes` WHERE `ID` = %d", ClothesInfo[playerid][slot][cID]);
    mysql_tquery(Database, csx_query, "OnRemoveFromSlot", "id", playerid, slot);
}

forward OnRemoveFromSlot(playerid, slot);
public OnRemoveFromSlot(playerid, slot) {
    ClothesInfo[playerid][slot][cOn] = false;
    ClothesInfo[playerid][slot][cModelID] = 0;
    ClothesInfo[playerid][slot][cBoneID] = 0;
    ClothesInfo[playerid][slot][cOffsetX] = 0.0;
    ClothesInfo[playerid][slot][cOffsetY] = 0.0;
    ClothesInfo[playerid][slot][cOffsetZ] = 0.0;
    ClothesInfo[playerid][slot][cRotX] = 0.0;
    ClothesInfo[playerid][slot][cRotY] = 0.0;
    ClothesInfo[playerid][slot][cRotZ] = 0.0;
    ClothesInfo[playerid][slot][cScaleX] = 0.0;
    ClothesInfo[playerid][slot][cScaleY] = 0.0;
    ClothesInfo[playerid][slot][cScaleZ] = 0.0;
    RemovePlayerAttachedObject(playerid, slot);
    return 1;
}

stock ResetClothes(playerid) {
    for (new i = 6; i < MAX_MODELS; i++) {
        if (ClothesInfo[playerid][i][cOn] == true) {
            RemoveFromSlot(playerid, i);
        }
    }
}

stock GetBoneName(boneid) {
    new bone[64];
    switch (boneid) {
        case 1:
            bone = "Spine";
        case 2:
            bone = "Head";
        case 3:
            bone = "Left upper arm";
        case 4:
            bone = "Right upper arm";
        case 5:
            bone = "Left hand";
        case 6:
            bone = "Right hand";
        case 7:
            bone = "Left thigh";
        case 8:
            bone = "Right thigh";
        case 9:
            bone = "Left foot";
        case 10:
            bone = "Right foot";
        case 11:
            bone = "Right calf";
        case 12:
            bone = "Left calf";
        case 13:
            bone = "Left forearm";
        case 14:
            bone = "Right forearm";
        case 15:
            bone = "Left clavicle (shoulder)";
        case 16:
            bone = "Right clavicle (shoulder)";
        case 17:
            bone = "Neck";
        case 18:
            bone = "Jaw";
    }
    return bone;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Clothe_Accessories) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase this item"); return ~1; }
    new freeslot = GetFreeSlot(playerid);
    if (freeslot == -1) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Purchase failed, you do not possess any free slots."); return ~1; }
    new i = Clothes_Accessories_Real_ID(shopItemId);
    SendClientMessageEx(playerid, -1, "Before you complete the purchase you may take a look at the item and adjust it.");
    SendClientMessageEx(playerid, -1, "Press {FFFF00}ESC{FFFFFF} to cancel the purchase.");
    SetPVarInt(playerid, "CSelectedShopID", shopid);
    SetPVarInt(playerid, "CSelectedItemNum", shopItemId);
    SetPVarInt(playerid, "SelectedItem", 1);
    SetPVarInt(playerid, "ItemIndex", i);
    SetPVarInt(playerid, "FreeSlot", freeslot);
    SetPlayerAttachedObject(playerid, freeslot, ModelsInfo[i][modelID], ModelsInfo[i][modelBone]);
    EditAttachedObject(playerid, freeslot);
    return ~1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `clothes` SET `holder` = \"%s\" WHERE  `holder` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `clothes` WHERE `holder` = \"%s\"", AccountName));
    return 1;
}