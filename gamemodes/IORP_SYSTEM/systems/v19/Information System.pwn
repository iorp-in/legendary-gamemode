#define Max_ITS 100
enum InformationTag:dataenum {
    InformationTag:text[1024],
        Float:InformationTag:cord[3],
        InformationTag:intVW[2],
        InformationTag:color,
        Float:InformationTag:drawDistance,
        Text3D:InformationTag:text3d,
        InformationTag:textPickup
}
new InformationTag:data[Max_ITS][InformationTag:dataenum];
new Iterator:ITsTexts < Max_ITS > ;

forward LoadInformationTexts();
public LoadInformationTexts() {
    new rows = cache_num_rows();
    if (rows) {
        new id, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", id);
            cache_get_value_name(loaded, "text", InformationTag:data[id][InformationTag:text], 1024);
            cache_get_value_name_int(loaded, "color", InformationTag:data[id][InformationTag:color]);
            cache_get_value_name_float(loaded, "drawDistance", InformationTag:data[id][InformationTag:drawDistance]);
            cache_get_value_name_float(loaded, "cordX", InformationTag:data[id][InformationTag:cord][0]);
            cache_get_value_name_float(loaded, "cordY", InformationTag:data[id][InformationTag:cord][1]);
            cache_get_value_name_float(loaded, "cordZ", InformationTag:data[id][InformationTag:cord][2]);
            cache_get_value_name_int(loaded, "cordInt", InformationTag:data[id][InformationTag:intVW][0]);
            cache_get_value_name_int(loaded, "cordVW", InformationTag:data[id][InformationTag:intVW][1]);

            InformationTag:data[id][InformationTag:text3d] = CreateDynamic3DTextLabel(
                InformationTag:data[id][InformationTag:text], InformationTag:data[id][InformationTag:color], InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1],
                InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:drawDistance], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
                InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]
            );
            InformationTag:data[id][InformationTag:textPickup] = CreateDynamicPickup(
                1239, 1, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2],
                InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]
            );
            Iter_Add(ITsTexts, id);
            loaded++;
        }
        printf("  [Information System] Loaded %d texts.", loaded);
    }
    return 1;
}

stock InformationTag:exists(id) {
    return Iter_Contains(ITsTexts, id);
}

stock InformationTag:create(playerid) {
    new id = Iter_Free(ITsTexts);
    if (id == INVALID_ITERATOR_SLOT) return -1;
    format(InformationTag:data[id][InformationTag:text], 1024, "[Notice][%d]\nHello There", id);
    InformationTag:data[id][InformationTag:color] = 0xFFFFFFFF;
    InformationTag:data[id][InformationTag:drawDistance] = 10.0;
    GetPlayerPos(playerid, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2]);
    InformationTag:data[id][InformationTag:intVW][0] = GetPlayerInterior(playerid);
    InformationTag:data[id][InformationTag:intVW][1] = GetPlayerVirtualWorldID(playerid);
    InformationTag:data[id][InformationTag:text3d] = STREAMER_TAG_3D_TEXT_LABEL:CreateDynamic3DTextLabel(
        InformationTag:data[id][InformationTag:text], InformationTag:data[id][InformationTag:color], InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1],
        InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:drawDistance], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
        InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]
    );
    InformationTag:data[id][InformationTag:textPickup] = CreateDynamicPickup(
        1239, 1, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1],
        InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]
    );
    Iter_Add(ITsTexts, id);
    mysql_tquery(Database, sprintf(
        "insert into informationTexts (ID, text, color, drawDistance, cordX, cordY, cordZ, cordInt, cordVW) VALUES(%d,\"%s\", %d, %f, %f, %f, %f,%d, %d)",
        id, InformationTag:data[id][InformationTag:text], InformationTag:data[id][InformationTag:color], InformationTag:data[id][InformationTag:drawDistance], InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1],
        InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:intVW][0], InformationTag:data[id][InformationTag:intVW][1]
    ));
    return id;
}

stock InformationTag:update(id) {
    if (!InformationTag:exists(id)) return 0;
    DestroyDynamic3DTextLabel(InformationTag:data[id][InformationTag:text3d]);
    DestroyDynamicPickup(InformationTag:data[id][InformationTag:textPickup]);
    InformationTag:data[id][InformationTag:text3d] = STREAMER_TAG_3D_TEXT_LABEL:CreateDynamic3DTextLabel(InformationTag:data[id][InformationTag:text], InformationTag:data[id][InformationTag:color], InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:drawDistance], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]);
    InformationTag:data[id][InformationTag:textPickup] = CreateDynamicPickup(1239, 1, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:intVW][1], InformationTag:data[id][InformationTag:intVW][0]);
    mysql_tquery(Database, sprintf("update informationTexts set text = \"%s\", color = %d, drawDistance = %f, cordX = %f, cordY = %f, cordZ = %f, cordInt = %d, cordVW = %d where ID = %d",
        InformationTag:data[id][InformationTag:text], InformationTag:data[id][InformationTag:color], InformationTag:data[id][InformationTag:drawDistance], InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2], InformationTag:data[id][InformationTag:intVW][0], InformationTag:data[id][InformationTag:intVW][1], id), "", "");
    return 1;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "SELECT * FROM informationTexts", "LoadInformationTexts", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new id:ITsTexts) {
        DestroyDynamic3DTextLabel(InformationTag:data[id][InformationTag:text3d]);
        DestroyDynamicPickup(InformationTag:data[id][InformationTag:textPickup]);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "information system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    InformationTag:AdminPanel(playerid);
    return ~1;
}

stock InformationTag:AdminPanel(playerid) {
    new string[1024];
    strcat(string, "Create Text\n");
    strcat(string, "Manage Text\n");
    return FlexPlayerDialog(playerid, "InfoTagAdminPanel", DIALOG_STYLE_LIST, "Information System", string, "Select", "Close");
}

FlexDialog:InfoTagAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Text")) {
        new id = InformationTag:create(playerid);
        if (id == -1) {
            AlexaMsg(playerid, "max information tag limit reached, please increase limit");
            return InformationTag:AdminPanel(playerid);
        }
        AlexaMsg(playerid, sprintf("information text %d created", id));
        return InformationTag:Manage(playerid, id);
    }
    if (IsStringSame(inputtext, "Manage Text")) return InformationTag:ManageInput(playerid);
    return 1;
}

stock InformationTag:ManageInput(playerid) {
    return FlexPlayerDialog(playerid, "InfoTagManageInput", DIALOG_STYLE_INPUT, "Manage Information Tag", "Enter tag id", "Manage", "Close");
}

FlexDialog:InfoTagManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return InformationTag:AdminPanel(playerid);
    new id;
    if (sscanf(inputtext, "d", id) || !InformationTag:exists(id)) return InformationTag:ManageInput(playerid);
    return InformationTag:Manage(playerid, id);
}

stock InformationTag:Manage(playerid, id) {
    if (!InformationTag:exists(id)) return InformationTag:AdminPanel(playerid);
    new string[1024];
    strcat(string, "Update Text\n");
    strcat(string, "Update Text Color\n");
    strcat(string, "Update Draw Distance\n");
    strcat(string, "Update Coordinates\n");
    strcat(string, "Teleport to Coordinates\n");
    strcat(string, "Remove Text\n");
    return FlexPlayerDialog(playerid, "InformationTagManage", DIALOG_STYLE_LIST, "Information System", string, "Select", "Close", id);
}

FlexDialog:InformationTagManage(playerid, response, listitem, const inputtext[], id, const payload[]) {
    if (!response) return InformationTag:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Update Text")) return InformationTag:MenuUpdateText(playerid, id);
    if (IsStringSame(inputtext, "Update Text Color")) return InformationTag:MenuUpdateColor(playerid, id);
    if (IsStringSame(inputtext, "Update Draw Distance")) return InformationTag:MenuUpdateDistance(playerid, id);
    if (IsStringSame(inputtext, "Update Coordinates")) {
        GetPlayerPos(playerid, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2]);
        InformationTag:data[id][InformationTag:intVW][0] = GetPlayerInterior(playerid);
        InformationTag:data[id][InformationTag:intVW][1] = GetPlayerVirtualWorldID(playerid);
        InformationTag:update(id);
        AlexaMsg(playerid, "coordinates updated", "Information System");
        return InformationTag:Manage(playerid, id);
    }
    if (IsStringSame(inputtext, "Teleport to Coordinates")) {
        if (IsPlayerInAnyVehicle(playerid)) SetVehiclePosEx(GetPlayerVehicleID(playerid), InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2]);
        else SetPlayerPosEx(playerid, InformationTag:data[id][InformationTag:cord][0], InformationTag:data[id][InformationTag:cord][1], InformationTag:data[id][InformationTag:cord][2]);
        return InformationTag:Manage(playerid, id);
    }
    if (IsStringSame(inputtext, "Remove Text")) {
        DestroyDynamic3DTextLabel(InformationTag:data[id][InformationTag:text3d]);
        DestroyDynamicPickup(InformationTag:data[id][InformationTag:textPickup]);
        Iter_Remove(ITsTexts, id);
        mysql_tquery(Database, sprintf("DELETE FROM informationTexts where ID = %d", id), "", "");
        AlexaMsg(playerid, "text removed", "Information System");
        return InformationTag:AdminPanel(playerid);
    }
    return 1;
}

stock InformationTag:MenuUpdateText(playerid, id) {
    new string[512];
    strcat(string, "Enter tag name.......\n");
    strcat(string, "To add custom color use -c- to open color tag and -d- to close color tag\n");
    strcat(string, "color codes are also available for format. -n- for newline");
    return FlexPlayerDialog(
        playerid, "InfoTagMenuUpdateText", DIALOG_STYLE_INPUT, "Information Tag System", string, "Update", "Back", id
    );
}

FlexDialog:InfoTagMenuUpdateText(playerid, response, listitem, const inputtext[], id, const payload[]) {
    if (!response) return InformationTag:Manage(playerid, id);
    new newText[1024];
    if (sscanf(inputtext, "s[1024]", newText)) return InformationTag:MenuUpdateText(playerid, id);
    format(InformationTag:data[id][InformationTag:text], 1024, "[%d] %s", id, FormatColors(newText));
    strreplace(InformationTag:data[id][InformationTag:text], "-n-", "\n");
    strreplace(InformationTag:data[id][InformationTag:text], "-c-", "{");
    strreplace(InformationTag:data[id][InformationTag:text], "-d-", "}");
    InformationTag:update(id);
    AlexaMsg(playerid, "text updated", "Information System");
    return InformationTag:Manage(playerid, id);
}

stock InformationTag:MenuUpdateColor(playerid, id) {
    return FlexPlayerDialog(playerid, "InfoTagMenuUpdateColor", DIALOG_STYLE_INPUT, "Information Tag System", "Enter color in format 0xFF1234FF", "Update", "Back", id);
}

FlexDialog:InfoTagMenuUpdateColor(playerid, response, listitem, const inputtext[], id, const payload[]) {
    if (!response) return InformationTag:Manage(playerid, id);
    new Color;
    if (sscanf(inputtext, "N(0xFFFFFFAA)", Color)) return InformationTag:MenuUpdateColor(playerid, id);
    InformationTag:data[id][InformationTag:color] = Color;
    InformationTag:update(id);
    AlexaMsg(playerid, "text updated", "Information System");
    return InformationTag:Manage(playerid, id);
}

stock InformationTag:MenuUpdateDistance(playerid, id) {
    return FlexPlayerDialog(playerid, "InfoTagMenuUpdateDistance", DIALOG_STYLE_INPUT, "Information Tag System", "Enter distance for tag", "Update", "Back", id);
}

FlexDialog:InfoTagMenuUpdateDistance(playerid, response, listitem, const inputtext[], id, const payload[]) {
    if (!response) return InformationTag:Manage(playerid, id);
    new Float:distance;
    if (sscanf(inputtext, "f", distance)) return InformationTag:MenuUpdateDistance(playerid, id);
    InformationTag:data[id][InformationTag:drawDistance] = distance;
    InformationTag:update(id);
    AlexaMsg(playerid, "text updated", "Information System");
    return InformationTag:Manage(playerid, id);
}