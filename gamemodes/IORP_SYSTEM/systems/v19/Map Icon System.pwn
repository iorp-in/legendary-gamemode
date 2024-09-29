#define Map_Icons 100
new Iterator:MapIcons < Map_Icons > ;

enum DefaultMapChar {
    ID,
    PickupID,
    IconID,
    Float:XX,
    Float:YY,
    Float:ZZ
}
new MapIcons:Data[Map_Icons][DefaultMapChar];

stock MapIcons:IsValidID(mapid) {
    return Iter_Contains(MapIcons, mapid);
}

forward LoadDefaulMapIcons();
public LoadDefaulMapIcons() {
    new rows = cache_num_rows();
    if (rows) {
        new count = 0, Id;
        while (count < rows) {
            cache_get_value_name_int(count, "ID", Id);
            cache_get_value_name_int(count, "ID", MapIcons:Data[Id][ID]);
            cache_get_value_name_int(count, "Map_ID", MapIcons:Data[Id][IconID]);
            cache_get_value_name_float(count, "COORD_X", MapIcons:Data[Id][XX]);
            cache_get_value_name_float(count, "COORD_Y", MapIcons:Data[Id][YY]);
            cache_get_value_name_float(count, "COORD_Z", MapIcons:Data[Id][ZZ]);
            MapIcons:Data[Id][PickupID] = CreateDynamicMapIcon(MapIcons:Data[Id][XX], MapIcons:Data[Id][YY], MapIcons:Data[Id][ZZ], MapIcons:Data[Id][IconID], -1, -1, -1, -1, 300);
            Iter_Add(MapIcons, Id);
            count++;
        }
    }
    printf("  [Map Icon System] Loaded %d Map Icons.", rows);
    return 1;
}

stock MapIcons:ClosestID(playerid) {
    new Id = -1, Float:tempdist[Map_Icons], Float:first = 0;
    foreach(new i:MapIcons) {
        tempdist[i] = GetPlayerDistanceFromPoint(playerid, MapIcons:Data[i][XX], MapIcons:Data[i][YY], MapIcons:Data[i][ZZ]);
        if (first == 0) first = tempdist[i];
        if (tempdist[i] < first) {
            first = tempdist[i];
            Id = i;
        }
    }
    if (Id != -1) return MapIcons:Data[Id][ID];
    return Id;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `mapIcons` (`ID` int(11) NOT NULL,`Map_ID` mediumint(7) NOT NULL,`COORD_X` float NOT NULL,`COORD_Y` float NOT NULL,`COORD_Z` float NOT NULL)");
    mysql_tquery(Database, "SELECT * FROM mapIcons", "LoadDefaulMapIcons");
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Map Icon System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Map Icon System", inputtext)) MapIcons:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "map icon system") || !IsPlayerMasterAdmin(playerid)) return 1;
    MapIcons:AdminPanel(playerid);
    return ~1;
}

stock MapIcons:AdminPanel(playerid) {
    new string[1024];
    strcat(string, sprintf("Closest Map ID\t%d\n", MapIcons:ClosestID(playerid)));
    strcat(string, "Manage Map Icon\n");
    strcat(string, "Create Map Icon\n");
    return FlexPlayerDialog(playerid, "MapIconsAdminPanel", DIALOG_STYLE_TABLIST, "{4286f4}[Map System]: {FFFFFF}Admin Control Panel", string, "Select", "Close");
}

FlexDialog:MapIconsAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage Map Icon")) return MapIcons:ManageInput(playerid);
    if (IsStringSame(inputtext, "Create Map Icon")) return MapIcons:CreateInput(playerid);
    return MapIcons:AdminPanel(playerid);
}

stock MapIcons:CreateInput(playerid) {
    return FlexPlayerDialog(playerid, "MapIconsCreateInput", DIALOG_STYLE_INPUT, "Map Icon System", "Enter icon id to create", "Create", "Close");
}

FlexDialog:MapIconsCreateInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return MapIcons:AdminPanel(playerid);
    new iconid;
    if (sscanf(inputtext, "d", iconid) || iconid < 0 || iconid > 63) return MapIcons:CreateInput(playerid);
    new mapid, Float:xx, Float:yy, Float:zz;
    mapid = Iter_Free(MapIcons);
    if (mapid == INVALID_ITERATOR_SLOT) return 1;
    GetPlayerPos(playerid, xx, yy, zz);
    MapIcons:Data[mapid][IconID] = iconid;
    MapIcons:Data[mapid][XX] = xx;
    MapIcons:Data[mapid][YY] = yy;
    MapIcons:Data[mapid][ZZ] = zz;
    MapIcons:Data[mapid][PickupID] = CreateDynamicMapIcon(MapIcons:Data[mapid][XX], MapIcons:Data[mapid][YY], MapIcons:Data[mapid][ZZ], MapIcons:Data[mapid][IconID], -1, -1, -1, -1, 300);
    Iter_Add(MapIcons, mapid);
    mysql_tquery(Database, sprintf(
        "INSERT INTO `mapIcons`(`ID`, `Map_ID`, `COORD_X`, `COORD_Y`, `COORD_Z`) VALUES ('%d','%d','%f','%f','%f')",
        mapid, iconid, xx, yy, zz
    ));
    AlexaMsg(playerid, sprintf("Created mapid: %d", mapid), "Map Icon System");
    return MapIcons:Manage(playerid, mapid);
}

stock MapIcons:ManageInput(playerid) {
    return FlexPlayerDialog(playerid, "MapIconsManageInput", DIALOG_STYLE_INPUT, "Map Icon System", "Enter mapid to manage", "Manage", "Close");
}

FlexDialog:MapIconsManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return MapIcons:AdminPanel(playerid);
    new mapid;
    if (sscanf(inputtext, "d", mapid) || !MapIcons:IsValidID(mapid)) return MapIcons:ManageInput(playerid);
    return MapIcons:Manage(playerid, mapid);
}

stock MapIcons:Manage(playerid, mapid) {
    new string[1024];
    strcat(string, "Teleport to map\n");
    strcat(string, "Remove Map\n");
    return FlexPlayerDialog(playerid, "MapIconsManage", DIALOG_STYLE_LIST, "Manage Map Icon", string, "Select", "Close", mapid);
}

FlexDialog:MapIconsManage(playerid, response, listitem, const inputtext[], mapid, const payload[]) {
    if (!response) return MapIcons:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Teleport to map")) {
        SetPlayerPosEx(playerid, MapIcons:Data[mapid][XX], MapIcons:Data[mapid][YY], MapIcons:Data[mapid][ZZ]);
        AlexaMsg(playerid, sprintf("Teleported to mapid: %d", mapid), "Map Icon System");
        return MapIcons:Manage(playerid, mapid);
    }
    if (IsStringSame(inputtext, "Remove Map")) {
        DestroyDynamicMapIcon(MapIcons:Data[mapid][PickupID]);
        MapIcons:Data[mapid][IconID] = -1;
        MapIcons:Data[mapid][XX] = -1;
        MapIcons:Data[mapid][YY] = -1;
        MapIcons:Data[mapid][ZZ] = -1;
        MapIcons:Data[mapid][PickupID] = -1;
        Iter_Remove(MapIcons, mapid);
        mysql_tquery(Database, sprintf("DELETE FROM `mapIcons` WHERE `ID`='%d'", mapid));
        AlexaMsg(playerid, sprintf("Map Icon Removed: %d", mapid), "Map Icon System");
    }
    return MapIcons:AdminPanel(playerid);
}