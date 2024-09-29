new GPSMarker[MAX_PLAYERS][2];

stock GetLastGpsTp(playerid) {
    return GPSMarker[playerid][1];
}

stock GPS:UpdateLastTeleportTime(playerid) {
    return GPSMarker[playerid][1] = gettime();
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "GPS", "int", "0");
    new query[512];
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS `gpsLocations` (\
	  `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `CatID` int(11) NOT NULL,\
	  `Place` varchar(50) NOT NULL,\
	  `PosX` float NOT NULL,\
	  `PosY` float NOT NULL,\
	  `PosZ` float NOT NULL,\
	  `InteriorID` int(11) NOT NULL,\
	  `VirtualWorldID` int(11) NOT NULL,\
	  PRIMARY KEY  (`ID`))");
    mysql_tquery(Database, query);
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS `gpsCategories` (\
	  `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `Name` varchar(50) NOT NULL,\
	  PRIMARY KEY  (`ID`))");
    mysql_tquery(Database, query);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (GPSMarker[playerid][0] != 0) DestroyDynamicMapIcon(GPSMarker[playerid][0]);
    GPSMarker[playerid][0] = 0;
    GPSMarker[playerid][1] = 0;
    return 1;
}

new EtShop:DataGps[MAX_PLAYERS];

stock EtShop:IsGpsActive(playerid) {
    return gettime() < EtShop:DataGps[playerid];
}

stock EtShop:GetGps(playerid) {
    return EtShop:DataGps[playerid];
}

stock EtShop:SetGps(playerid, expireAt) {
    EtShop:DataGps[playerid] = expireAt;
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetGps(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "GPS"));
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 34) return 1;
    if (EtShop:IsGpsActive(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have GPS, no need to purchase it again until it expires.");
        return ~1;
    }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase GPS"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetGps(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased GPS. Validity: 30 days");
    CompleteGpsMission(playerid);
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (EtShop:IsGpsActive(playerid)) UCP:AddCommand(playerid, "Open GPS");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Open GPS", inputtext)) GPS:ShowMenu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(cmd, "gps") || !EtShop:IsGpsActive(playerid)) return 1;
    GPS:ShowMenu(playerid);
    return ~1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (GPSMarker[playerid][0] != 0) DestroyDynamicMapIcon(GPSMarker[playerid][0]);
    GPSMarker[playerid][0] = 0;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(EtShop:GetGps(playerid), GetPlayerNameEx(playerid), "username", "GPS");
    return 1;
}

stock GPS:GetTotalCat() {
    new Cache:result = mysql_query(Database, "select count(*) as total from gpsCategories");
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock GPS:GetTotalSubCat(primaryCategory) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from gpsLocations where catid = %d", primaryCategory));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock GPS:ShowMenu(playerid) {
    new Cache:result;
    result = mysql_query(Database, "select gpsCategories.ID, gpsCategories.Name , COUNT(gpsLocations.ID) AS Count from gpsCategories left join gpsLocations on gpsCategories.ID = gpsLocations.CatID GROUP BY gpsCategories.ID, gpsCategories.Name");
    new rows = cache_num_rows();
    new gID, gName[50], gcount, string[2000];
    format(string, sizeof string, "ID\tCategory\tLocations\n");
    strcat(string, "Food\t-\t-\n");
    strcat(string, "Fuel\t-\t-\n");
    if (rows) {
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", gID);
            cache_get_value_name(i, "Name", gName, 50);
            cache_get_value_name_int(i, "Count", gcount);
            strcat(string, sprintf("{FFFFFF}%d\t%s\t%d\n", gID, gName, gcount));
        }
    }
    if (GPSMarker[playerid][0] != 0) format(string, sizeof string, "%s{FFFFFF}Turn off GPS\t-\t-\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%s{FFFFFF}Add\tNew\tCatergory\n", string);
    new title[512];
    format(title, sizeof title, "{F1C40F}IORP GPS: {FFFFFF}select category");
    cache_delete(result);
    return FlexPlayerDialog(playerid, "GpsShowMenu", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}IORP GPS: {FFFFFF}select category", string, "Select", "Close");
}

FlexDialog:GpsShowMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Food", inputtext)) return FoodStall:ShowList(playerid);
    if (IsStringSame("Fuel", inputtext)) return PumpBusiness:ShowList(playerid);
    if (IsStringSame("Add", inputtext)) return GPS:AddCategory(playerid);
    if (IsStringSame("Turn off GPS", inputtext)) {
        if (GPSMarker[playerid][0] != 0) DestroyDynamicMapIcon(GPSMarker[playerid][0]);
        GPSMarker[playerid][0] = 0;
        AlexaMsg(playerid, "turned off", "GPS");
        GPS:ShowMenu(playerid);
        return 1;
    }
    new categoryid = strval(inputtext);
    return GPS:ViewSubMenu(playerid, categoryid);
}

stock GPS:AddCategory(playerid) {
    return FlexPlayerDialog(playerid, "GpsAddCategory", DIALOG_STYLE_INPUT, "IORP GPS: New Category", "Enter Category Name below", "Add", "Close");
}

FlexDialog:GpsAddCategory(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return GPS:ShowMenu(playerid);
    new catName[50];
    if (sscanf(inputtext, "s[50]", catName)) return GPS:AddCategory(playerid);
    mysql_tquery(Database, sprintf("insert into gpsCategories (Name) VALUES (\"%s\")", catName));
    AlexaMsg(playerid, sprintf("category %s added into gps", catName));
    return GPS:ShowMenu(playerid);
}

stock GPS:ViewSubMenu(playerid, categoryid) {
    new Cache:result = mysql_query(Database, sprintf("select * from gpsLocations where CatID = %d", categoryid));
    new rows = cache_num_rows();
    new string[2000], gID, gName[50], Float:gPos[3], Pos[2];
    format(string, sizeof string, "ID\tLocation\tDistance\n");
    if (rows) {
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", gID);
            cache_get_value_name(i, "Place", gName, 50);
            cache_get_value_name_float(i, "PosX", gPos[0]);
            cache_get_value_name_float(i, "PosY", gPos[1]);
            cache_get_value_name_float(i, "PosZ", gPos[2]);
            cache_get_value_name_int(i, "InteriorID", Pos[0]);
            cache_get_value_name_int(i, "VirtualWorldID", Pos[1]);
            format(string, sizeof string, "%s{FFFFFF}%d\t%s\t%.1f\n", string, gID, gName, GetPlayerDistanceFromPoint(playerid, gPos[0], gPos[1], gPos[2]));
        }
    }
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%s{FFFFFF}Rename\tCategory\t-\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%s{FFFFFF}Remove\tCategory\t-\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%s{FFFFFF}Add\tNew\tLocation\n", string);
    cache_delete(result);
    return FlexPlayerDialog(playerid, "GpsSubMenu", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}IORP GPS: {FFFFFF}select location", string, "Select", "Close", categoryid);
}

FlexDialog:GpsSubMenu(playerid, response, listitem, const inputtext[], categoryid, const payload[]) {
    if (!response) return GPS:ShowMenu(playerid);
    if (IsStringSame("Add", inputtext, false)) return GPS:MenuAddLocation(playerid, categoryid);
    if (IsStringSame("Rename", inputtext, false)) return GPS:MenuRenameCategory(playerid, categoryid);
    if (IsStringSame("Remove", inputtext, false)) {
        mysql_tquery(Database, sprintf("delete from gpsCategories where ID = %d", categoryid));
        mysql_tquery(Database, sprintf("delete from gpsLocations where CatID = %d", categoryid));
        AlexaMsg(playerid, sprintf("Deleted category %d", categoryid), "GPS");
        return GPS:ShowMenu(playerid);
    }
    new locationid = strval(inputtext);
    return GPS:MenuLocationOptions(playerid, locationid);
}

stock GPS:MenuAddLocation(playerid, categoryid) {
    return FlexPlayerDialog(playerid, "GPSMenuAddLocation", DIALOG_STYLE_INPUT, "IORP GPS: New Location", "Enter Location Name below", "Add", "Close", categoryid);
}

FlexDialog:GPSMenuAddLocation(playerid, response, listitem, const inputtext[], categoryid, const payload[]) {
    if (!response) return GPS:ShowMenu(playerid);
    new locationName[50];
    if (sscanf(inputtext, "s[50]", locationName)) return GPS:MenuAddLocation(playerid, categoryid);
    new Float:gPos[3], Pos[2];
    GetPlayerPos(playerid, gPos[0], gPos[1], gPos[2]);
    Pos[0] = GetPlayerInterior(playerid);
    Pos[1] = GetPlayerVirtualWorld(playerid);
    mysql_tquery(Database, sprintf(
        "INSERT INTO `gpsLocations`(CatID, Place, PosX, PosY, PosZ, InteriorID, VirtualWorldID) VALUES (\"%d\",\"%s\",\"%f\",\"%f\",\"%f\",\"%d\",\"%d\")",
        categoryid, locationName, gPos[0], gPos[1], gPos[2], Pos[0], Pos[1]
    ));
    AlexaMsg(playerid, sprintf("added location %s", locationName), "GPS");
    return GPS:ShowMenu(playerid);
}

stock GPS:MenuRenameCategory(playerid, categoryid) {
    return FlexPlayerDialog(playerid, "GPSMenuRenameCategory", DIALOG_STYLE_INPUT, "IORP GPS: Rename Category", "Enter Category Name, below", "Rename", "Close", categoryid);
}

FlexDialog:GPSMenuRenameCategory(playerid, response, listitem, const inputtext[], categoryid, const payload[]) {
    if (!response) return GPS:ShowMenu(playerid);
    new newCatName[50];
    if (sscanf(inputtext, "s[50]", newCatName)) return GPS:MenuRenameCategory(playerid, categoryid);
    mysql_tquery(Database, sprintf("update gpsCategories set name = \"%s\" where id = %d", newCatName, categoryid));
    AlexaMsg(playerid, sprintf("updated category name to %s", newCatName), "GPS");
    return GPS:ShowMenu(playerid);
}

stock GPS:MenuLocationOptions(playerid, locationid) {
    new string[1024];
    if (GPSMarker[playerid][0] == 0) format(string, sizeof string, "Turn on GPS\n");
    if (GPSMarker[playerid][0] != 0) format(string, sizeof string, "Turn off GPS\n");
    if (
        GetPlayerVIPLevel(playerid) > 2 &&
        // !GetPlayerRPMode(playerid) &&
        !IsPlayerInHeist(playerid) &&
        !Event:IsInEvent(playerid)
    ) format(string, sizeof string, "%sTeleport Me\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%sTeleport to Location\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%sRename Location\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%sReplace Coordinate\n", string);
    if (GetPlayerAdminLevel(playerid) >= 8) format(string, sizeof string, "%sRemove Location\n", string);
    return FlexPlayerDialog(playerid, "GPSMenuLocationOptions", DIALOG_STYLE_LIST, "IORP GPS: What to do", string, "Select", "Close", locationid);
}

stock GPS:GetLocation(locationid, & Float:x, & Float:y, & Float:z, & int, & vw, title[], titleSize = sizeof title) {
    new Cache:result = mysql_query(Database, sprintf("select * from gpsLocations where id = %d limit 1", locationid));
    if (!cache_num_rows()) {
        cache_delete(result);
        return 0;
    }
    cache_get_value_name(0, "Place", title, titleSize);
    cache_get_value_name_float(0, "PosX", x);
    cache_get_value_name_float(0, "PosY", y);
    cache_get_value_name_float(0, "PosZ", z);
    cache_get_value_name_int(0, "InteriorID", int);
    cache_get_value_name_int(0, "VirtualWorldID", vw);
    cache_delete(result);
    return 1;
}

stock GPS:SendToLocation(playerid, locationid) {
    if (!IsPlayerConnected(playerid)) return 1;

    new title[50], Float:pos[3], int, vw;
    if (!GPS:GetLocation(locationid, pos[0], pos[1], pos[2], int, vw, title)) {
        AlexaMsg(playerid, "The location is unavailable at the movement", "GPS");
        return 0;
    }

    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (OresVehicleLoadedOres(vehicleid) > 0 || TrailerStorage:GetResourceTypesLoaded(vehicleid) > 0) {
            return AlexaMsg(playerid, "The teleporation request was declined");
        }
        TeleportVehicleEx(GetPlayerVehicleID(playerid), pos[0], pos[1], pos[2], 0, vw, int), SetPlayerVirtualWorldEx(playerid, vw), SetPlayerInteriorEx(playerid, int);
    } else {
        SetPlayerVirtualWorldEx(playerid, vw), SetPlayerInteriorEx(playerid, int), SetPlayerPosEx(playerid, pos[0], pos[1], pos[2]);
    }

    GPS:UpdateLastTeleportTime(playerid);
    AlexaMsg(playerid, sprintf("you are teleported to %s", title), "GPS");
    return 1;
}

stock MarkGPS(playerid, Float:posX, Float:posY, Float:posZ) {
    if (GPSMarker[playerid][0] != 0) DestroyDynamicMapIcon(GPSMarker[playerid][0]);
    GPSMarker[playerid][0] = CreateDynamicMapIcon(Float:posX, Float:posY, Float:posZ, 41, 0, -1, -1, playerid, 100000.0);
    Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, GPSMarker[playerid][0], E_STREAMER_STYLE, MAPICON_GLOBAL);
    Streamer_Update(playerid);
    return 1;
}

FlexDialog:GPSMenuLocationOptions(playerid, response, listitem, const inputtext[], locationid, const payload[]) {
    if (!response) return GPS:ShowMenu(playerid);
    if (IsStringSame(inputtext, "Rename Location")) return GPS:MenuRenameLocation(playerid, locationid);
    if (IsStringSame(inputtext, "Teleport to Location")) return GPS:MenuTeleportSomone(playerid, locationid);
    if (IsStringSame(inputtext, "Teleport Me")) {
        GPS:SendToLocation(playerid, locationid);
        return GPS:MenuLocationOptions(playerid, locationid);
    }
    if (IsStringSame(inputtext, "Turn on GPS")) {
        new title[50], Float:pos[3], int, vw;
        if (!GPS:GetLocation(locationid, pos[0], pos[1], pos[2], int, vw, title)) {
            AlexaMsg(playerid, "The location is unavailable at the movement", "GPS");
            return GPS:MenuLocationOptions(playerid, locationid);
        }
        MarkGPS(playerid, pos[0], pos[1], pos[2]);
        AlexaMsg(playerid, sprintf("coordinates marked on your map for %s", title));
        return 1;
    }
    if (IsStringSame(inputtext, "Turn off GPS")) {
        if (GPSMarker[playerid][0] != 0) DestroyDynamicMapIcon(GPSMarker[playerid][0]);
        GPSMarker[playerid][0] = 0;
        AlexaMsg(playerid, "turned off", "GPS");
        return GPS:MenuLocationOptions(playerid, locationid);
    }
    if (IsStringSame(inputtext, "Replace Coordinate")) {
        new Float:pos[3];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        new int = GetPlayerInterior(playerid);
        new vw = GetPlayerVirtualWorld(playerid);
        mysql_tquery(Database, sprintf(
            "update gpsLocations set posx = %f, posy = %f, posz = %f, interiorid = %d, virtualworldid = %d where id = %d",
            pos[0], pos[1], pos[2], int, vw, locationid
        ));
        AlexaMsg(playerid, sprintf("location updated for id %d", locationid), "GPS");
        return GPS:MenuLocationOptions(playerid, locationid);
    }
    if (IsStringSame(inputtext, "Remove Location")) {
        mysql_tquery(Database, sprintf("delete from gpsLocations where id = %d", locationid));
        AlexaMsg(playerid, sprintf("removed location %d", locationid), "GPS");
        return GPS:ShowMenu(playerid);
    }
    return 1;
}

stock GPS:MenuRenameLocation(playerid, locationid) {
    return FlexPlayerDialog(playerid, "GPSMenuRenameLocation", DIALOG_STYLE_INPUT, "Update Location Name", "Enter location new name", "Update", "Cancel", locationid);
}

FlexDialog:GPSMenuRenameLocation(playerid, response, listitem, const inputtext[], locationid, const payload[]) {
    if (!response) return GPS:MenuLocationOptions(playerid, locationid);
    new newName[50];
    if (sscanf(inputtext, "s[50]", newName)) return GPS:MenuRenameLocation(playerid, locationid);
    mysql_tquery(Database, sprintf("update gpsLocations set Place = \"%s\" where ID = %d", newName, locationid));
    return GPS:MenuLocationOptions(playerid, locationid);
}

stock GPS:MenuTeleportSomone(playerid, locationid) {
    return FlexPlayerDialog(playerid, "GPSMenuTeleportSomone", DIALOG_STYLE_INPUT, "Teleport player", "Enter playerid or name to teleport", "Teleport", "Cancel", locationid);
}

FlexDialog:GPSMenuTeleportSomone(playerid, response, listitem, const inputtext[], locationid, const payload[]) {
    if (!response) return GPS:MenuLocationOptions(playerid, locationid);
    new toplayer;
    if (sscanf(inputtext, "u", toplayer) || !IsPlayerConnected(toplayer)) return GPS:MenuTeleportSomone(playerid, locationid);
    GPS:SendToLocation(toplayer, locationid);
    if (playerid != toplayer) GPS:MenuLocationOptions(playerid, locationid);
    return 1;
}