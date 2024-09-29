#define MAX_ENTRANCES (100)
#define MAX_ENTRANCE_NAME (25)

new Iterator:Entrances < MAX_ENTRANCES > ;

enum Entrance:DataEnum {
    ID,
    Name[MAX_ENTRANCE_NAME],
    Float:Enter[3],
    Float:Exit[3],
    Float:FAngle,
    Float:EFAngle,
    Interior,
    VirtualW,
    EInterior,
    EVirtualW,

    Text3D:EnterLabel,
    EnterPickup,
    Text3D:ExitLabel,
    ExitPickup
}
new Entrance:Data[MAX_ENTRANCES][Entrance:DataEnum];

forward LoadEntrance();
public LoadEntrance() {
    new rows = cache_num_rows();
    if (rows) {
        new string[512], Count = 0, Id;
        while (Count < rows) {
            cache_get_value_name_int(Count, "ID", Id);
            cache_get_value_name_int(Count, "ID", Entrance:Data[Id][ID]);
            cache_get_value_name(Count, "Name", Entrance:Data[Id][Name], .max_len = MAX_ENTRANCE_NAME);
            cache_get_value_float(Count, "X", Entrance:Data[Id][Enter][0]);
            cache_get_value_float(Count, "Y", Entrance:Data[Id][Enter][1]);
            cache_get_value_float(Count, "Z", Entrance:Data[Id][Enter][2]);
            cache_get_value_float(Count, "exitX", Entrance:Data[Id][Exit][0]);
            cache_get_value_float(Count, "exitY", Entrance:Data[Id][Exit][1]);
            cache_get_value_float(Count, "exitZ", Entrance:Data[Id][Exit][2]);
            cache_get_value_float(Count, "FAngle", Entrance:Data[Id][FAngle]);
            cache_get_value_float(Count, "EFAngle", Entrance:Data[Id][EFAngle]);
            cache_get_value_name_int(Count, "Interior", Entrance:Data[Id][Interior]);
            cache_get_value_name_int(Count, "VirtualW", Entrance:Data[Id][VirtualW]);
            cache_get_value_name_int(Count, "EInterior", Entrance:Data[Id][EInterior]);
            cache_get_value_name_int(Count, "EVirtualW", Entrance:Data[Id][EVirtualW]);

            format(string, sizeof(string), "Entrance[%d]:%s!\nPress N to enter!", Entrance:Data[Id][ID], Entrance:Data[Id][Name]);
            Entrance:Data[Id][EnterLabel] = CreateDynamic3DTextLabel(string, YELLOW, Entrance:Data[Id][Enter][0], Entrance:Data[Id][Enter][1], Entrance:Data[Id][Enter][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Entrance:Data[Id][VirtualW], Entrance:Data[Id][Interior], -1, 50.0);
            Entrance:Data[Id][EnterPickup] = CreateDynamicPickup(19130, 23, Entrance:Data[Id][Enter][0], Entrance:Data[Id][Enter][1], Entrance:Data[Id][Enter][2], Entrance:Data[Id][VirtualW], Entrance:Data[Id][Interior], -1, 50.0);

            format(string, sizeof(string), "Entrance[%d]:%s!\nPress N to exit!", Entrance:Data[Id][ID], Entrance:Data[Id][Name]);
            Entrance:Data[Id][ExitLabel] = CreateDynamic3DTextLabel(string, YELLOW, Entrance:Data[Id][Exit][0], Entrance:Data[Id][Exit][1], Entrance:Data[Id][Exit][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Entrance:Data[Id][EVirtualW], Entrance:Data[Id][EInterior], -1, 50.0);
            Entrance:Data[Id][ExitPickup] = CreateDynamicPickup(19130, 23, Entrance:Data[Id][Exit][0], Entrance:Data[Id][Exit][1], Entrance:Data[Id][Exit][2], Entrance:Data[Id][EVirtualW], Entrance:Data[Id][EInterior], -1, 50.0);
            Iter_Add(Entrances, Id);
            Count++;
        }
    }
    printf("  [Entrance System] Loaded %d Entrance.", rows);
    return 1;
}


hook OnGameModeInit() {
    // Database:AddInt("entranceID");
    new entrancequery[1024];
    strcat(entrancequery, "CREATE TABLE IF NOT EXISTS `entrances` ( \
	  `ID` int(3) NOT NULL, \
	  `Name` varchar(25) NOT NULL, \
	  `X` float NOT NULL, \
	  `Y` float NOT NULL, \
	  `Z` float NOT NULL,");
    strcat(entrancequery, "  `exitX` float NOT NULL default '0', \
	  `exitY` float NOT NULL default '0', \
	  `exitZ` float NOT NULL default '0', \
	  `FAngle` float NOT NULL default '0', \
	  `EFAngle` float NOT NULL default '0', \
	  `Interior` int(5) NOT NULL default '0', \
	  `VirtualW` int(3) NOT NULL default '0',\
	  `EInterior` int(5) NOT NULL default '0', \
	  `EVirtualW` int(3) NOT NULL default '0',\
	   PRIMARY KEY (`ID`) \
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
    mysql_tquery(Database, entrancequery);
    mysql_tquery(Database, "SELECT * FROM entrances", "LoadEntrance", "");
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        foreach(new i:Entrances) {
            if (IsPlayerInRangeOfPoint(playerid, 2, Entrance:Data[i][Enter][0], Entrance:Data[i][Enter][1], Entrance:Data[i][Enter][2]) && GetPlayerVirtualWorld(playerid) == Entrance:Data[i][VirtualW] && GetPlayerInterior(playerid) == Entrance:Data[i][Interior]) {
                SetPlayerVirtualWorldEx(playerid, Entrance:Data[i][EVirtualW]);
                SetPlayerInteriorEx(playerid, Entrance:Data[i][EInterior]);
                SetPlayerFacingAngle(playerid, Entrance:Data[i][EFAngle]);
                SetPlayerPosEx(playerid, Entrance:Data[i][Exit][0], Entrance:Data[i][Exit][1], Entrance:Data[i][Exit][2] + 0.5);
                // SetPVarInt(playerid, "entranceID", i); // Need for exit
                SetCameraBehindPlayer(playerid);
                return ~1;
            } else if (IsPlayerInRangeOfPoint(playerid, 2, Entrance:Data[i][Exit][0], Entrance:Data[i][Exit][1], Entrance:Data[i][Exit][2]) && GetPlayerVirtualWorld(playerid) == Entrance:Data[i][EVirtualW] && GetPlayerInterior(playerid) == Entrance:Data[i][EInterior]) {
                SetPlayerVirtualWorldEx(playerid, Entrance:Data[i][VirtualW]);
                SetPlayerInteriorEx(playerid, Entrance:Data[i][Interior]);
                SetPlayerFacingAngle(playerid, Entrance:Data[i][FAngle]);
                SetPlayerPosEx(playerid, Entrance:Data[i][Enter][0], Entrance:Data[i][Enter][1], Entrance:Data[i][Enter][2] + 0.5);
                SetCameraBehindPlayer(playerid);
                return ~1;
            }
        }
    }
    return 1;
}

stock Entrance:UpdateDB(entranceID) {
    new query[512];
    if (Iter_Contains(Entrances, entranceID)) {
        format(query, sizeof(query), "UPDATE `entrances` Set `Name`=\"%s\",`X`='%f',`Y`='%f',`Z`='%f',`exitX`='%f',`exitY`='%f',`exitZ`='%f',`FAngle`='%f',`EFAngle`='%f',`Interior`='%d',`VirtualW`='%d',`EInterior`='%d',`EVirtualW`='%d' \
		WHERE `ID`='%d'", Entrance:Data[entranceID][Name], Entrance:Data[entranceID][Enter][0], Entrance:Data[entranceID][Enter][1], Entrance:Data[entranceID][Enter][2],
            Entrance:Data[entranceID][Exit][0], Entrance:Data[entranceID][Exit][1], Entrance:Data[entranceID][Exit][2], Entrance:Data[entranceID][FAngle], Entrance:Data[entranceID][EFAngle], Entrance:Data[entranceID][Interior], Entrance:Data[entranceID][VirtualW], Entrance:Data[entranceID][EInterior], Entrance:Data[entranceID][EVirtualW], Entrance:Data[entranceID][ID]);
        mysql_tquery(Database, query);
    } else {
        if (Entrance:Data[entranceID][ID] < 0) return 1;
        format(query, sizeof(query), "INSERT INTO `entrances` (`ID`,`Name`,`X`,`Y`,`Z`,`exitX`,`exitY`,`exitZ`,`FAngle`,`EFAngle`,`Interior`,`VirtualW`,`EInterior`,`EVirtualW`)\
		VALUES (%d,\"%s\",%f,%f,%f,%f,%f,%f,%f,%f,%d,%d,%d,%d)", Entrance:Data[entranceID][ID], Entrance:Data[entranceID][Name], Entrance:Data[entranceID][Enter][0], Entrance:Data[entranceID][Enter][1], Entrance:Data[entranceID][Enter][2],
            Entrance:Data[entranceID][Exit][0], Entrance:Data[entranceID][Exit][1], Entrance:Data[entranceID][Exit][2], Entrance:Data[entranceID][FAngle], Entrance:Data[entranceID][EFAngle], Entrance:Data[entranceID][Interior], Entrance:Data[entranceID][VirtualW], Entrance:Data[entranceID][EInterior], Entrance:Data[entranceID][EVirtualW]);
        mysql_tquery(Database, query);
        Iter_Add(Entrances, entranceID);
    }
    new string[512];
    DestroyDynamic3DTextLabel(Entrance:Data[entranceID][EnterLabel]);
    DestroyDynamicPickup(Entrance:Data[entranceID][EnterPickup]);
    format(string, sizeof(string), "Entrance[%d]: %s!\nPress N to enter!", Entrance:Data[entranceID][ID], Entrance:Data[entranceID][Name]);
    Entrance:Data[entranceID][EnterLabel] = CreateDynamic3DTextLabel(string, YELLOW, Entrance:Data[entranceID][Enter][0], Entrance:Data[entranceID][Enter][1], Entrance:Data[entranceID][Enter][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Entrance:Data[entranceID][VirtualW], Entrance:Data[entranceID][Interior], -1, 50.0);
    Entrance:Data[entranceID][EnterPickup] = CreateDynamicPickup(19130, 23, Entrance:Data[entranceID][Enter][0], Entrance:Data[entranceID][Enter][1], Entrance:Data[entranceID][Enter][2], Entrance:Data[entranceID][VirtualW], Entrance:Data[entranceID][Interior], -1, 50.0);

    DestroyDynamic3DTextLabel(Entrance:Data[entranceID][ExitLabel]);
    DestroyDynamicPickup(Entrance:Data[entranceID][ExitPickup]);
    format(string, sizeof(string), "Entrance[%d]: %s!\nPress N to exit!", Entrance:Data[entranceID][ID], Entrance:Data[entranceID][Name]);
    Entrance:Data[entranceID][ExitLabel] = CreateDynamic3DTextLabel(string, YELLOW, Entrance:Data[entranceID][Exit][0], Entrance:Data[entranceID][Exit][1], Entrance:Data[entranceID][Exit][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Entrance:Data[entranceID][EVirtualW], Entrance:Data[entranceID][EInterior], -1, 50.0);
    Entrance:Data[entranceID][ExitPickup] = CreateDynamicPickup(19130, 23, Entrance:Data[entranceID][Exit][0], Entrance:Data[entranceID][Exit][1], Entrance:Data[entranceID][Exit][2], Entrance:Data[entranceID][EVirtualW], Entrance:Data[entranceID][EInterior], -1, 50.0);
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Entrance System");
    return 1;
}

ACP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Entrance System", inputtext)) Entrance:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "entrance system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    Entrance:AdminPanel(playerid);
    return ~1;
}

stock Entrance:AdminPanel(playerid) {
    new string[512];
    strcat(string, "Alter Entrance\n");
    strcat(string, "Create Entrance\n");
    return FlexPlayerDialog(playerid, "EntranceAdminPanel", DIALOG_STYLE_TABLIST, "{4286f4}[Entrance System]: {FFFFEE}Control Panel", string, "Select", "Close");
}

FlexDialog:EntranceAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Alter Entrance")) return Entrance:MenuAlter(playerid);
    if (IsStringSame(inputtext, "Create Entrance")) return Entrance:MenuCreate(playerid);
    return 1;
}

stock Entrance:MenuCreate(playerid) {
    return FlexPlayerDialog(
        playerid, "EntranceMenuCreate", DIALOG_STYLE_INPUT, "{4286f4}[Entrance System]: {FFFFEE}Alter Entrance",
        "Enter Entrance Name\nCharater limit 25 Exceed", "Create", "Close"
    );
}

FlexDialog:EntranceMenuCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Entrance:AdminPanel(playerid);
    new entranceName[25];
    if (sscanf(inputtext, "s[25]", entranceName)) return Entrance:MenuCreate(playerid);
    new entranceID = Iter_Free(Entrances);
    if (entranceID == INVALID_ITERATOR_SLOT) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Entrance Limit Exceed");
        return Entrance:MenuCreate(playerid);
    }
    new entData[2], Float:entPOS[4];
    GetPlayerPos(playerid, entPOS[0], entPOS[1], entPOS[2]);
    GetPlayerFacingAngle(playerid, entPOS[3]);
    entData[0] = GetPlayerInterior(playerid);
    entData[1] = GetPlayerVirtualWorld(playerid);
    Entrance:Data[entranceID][ID] = entranceID;
    Entrance:Data[entranceID][Name] = entranceName;
    Entrance:Data[entranceID][Enter][0] = entPOS[0];
    Entrance:Data[entranceID][Enter][1] = entPOS[1];
    Entrance:Data[entranceID][Enter][2] = entPOS[2];
    Entrance:Data[entranceID][Exit][0] = entPOS[0];
    Entrance:Data[entranceID][Exit][1] = entPOS[1];
    Entrance:Data[entranceID][Exit][2] = entPOS[2];
    Entrance:Data[entranceID][FAngle] = entPOS[3];
    Entrance:Data[entranceID][EFAngle] = entPOS[3];
    Entrance:Data[entranceID][Interior] = entData[0];
    Entrance:Data[entranceID][VirtualW] = entData[1];
    Entrance:Data[entranceID][EInterior] = entData[0];
    Entrance:Data[entranceID][EVirtualW] = entData[1];
    Entrance:UpdateDB(entranceID);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Entrance System]: {FFFFEE}Entrance[%d] Created", entranceID));
    return Entrance:MenuManage(playerid, entranceID);
}

stock Entrance:MenuAlter(playerid) {
    return FlexPlayerDialog(
        playerid, "EntranceMenuAlter", DIALOG_STYLE_INPUT, "{4286f4}[Entrance System]: {FFFFEE}Alter Entrance",
        "Enter entrance id", "Manage", "Close"
    );
}

FlexDialog:EntranceMenuAlter(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Entrance:AdminPanel(playerid);
    new entranceID;
    if (sscanf(inputtext, "d", entranceID) || !Iter_Contains(Entrances, entranceID)) return Entrance:MenuAlter(playerid);
    return Entrance:MenuManage(playerid, entranceID);
}

stock Entrance:MenuManage(playerid, entranceID) {
    new string[1024];
    strcat(string, "Teleport to Enterance\n");
    strcat(string, "Teleport to Exit\n");
    strcat(string, "Rename Entrance\n");
    strcat(string, "Set Enter Position\n");
    strcat(string, "Set Exit Position\n");
    strcat(string, "Remove Entrance\n");
    return FlexPlayerDialog(
        playerid, "EntranceMenuManage", DIALOG_STYLE_LIST, "Entrance System", string, "Select", "Close", entranceID
    );
}

FlexDialog:EntranceMenuManage(playerid, response, listitem, const inputtext[], entranceID, const payload[]) {
    if (!response) return Entrance:AdminPanel(playerid);
    if (IsStringSame("Rename Entrance", inputtext)) return Entrance:MenuUpdateName(playerid, entranceID);
    if (IsStringSame("Teleport to Enterance", inputtext)) {
        SetPlayerVirtualWorldEx(playerid, Entrance:Data[entranceID][VirtualW]);
        SetPlayerInteriorEx(playerid, Entrance:Data[entranceID][Interior]);
        SetPlayerFacingAngle(playerid, Entrance:Data[entranceID][FAngle]);
        SetPlayerPosEx(playerid, Entrance:Data[entranceID][Enter][0], Entrance:Data[entranceID][Enter][1], Entrance:Data[entranceID][Enter][2]);
        SetCameraBehindPlayer(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Teleported to Entrance");
        return Entrance:MenuManage(playerid, entranceID);
    }
    if (IsStringSame("Teleport to Exit", inputtext)) {
        SetPlayerVirtualWorldEx(playerid, Entrance:Data[entranceID][EVirtualW]);
        SetPlayerInteriorEx(playerid, Entrance:Data[entranceID][EInterior]);
        SetPlayerFacingAngle(playerid, Entrance:Data[entranceID][EFAngle]);
        SetPlayerPosEx(playerid, Entrance:Data[entranceID][Exit][0], Entrance:Data[entranceID][Exit][1], Entrance:Data[entranceID][Exit][2]);
        SetCameraBehindPlayer(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Teleported to Exit of Entrance");
        return Entrance:MenuManage(playerid, entranceID);
    }
    if (IsStringSame("Set Enter Position", inputtext)) {
        new entData[2], Float:entPOS[4];
        GetPlayerPos(playerid, entPOS[0], entPOS[1], entPOS[2]);
        GetPlayerFacingAngle(playerid, entPOS[3]);
        entData[0] = GetPlayerInterior(playerid);
        entData[1] = GetPlayerVirtualWorld(playerid);
        Entrance:Data[entranceID][Enter][0] = entPOS[0];
        Entrance:Data[entranceID][Enter][1] = entPOS[1];
        Entrance:Data[entranceID][Enter][2] = entPOS[2];
        Entrance:Data[entranceID][FAngle] = entPOS[3];
        Entrance:Data[entranceID][Interior] = entData[0];
        Entrance:Data[entranceID][VirtualW] = entData[1];
        Entrance:UpdateDB(entranceID);
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Entrance Updated");
        return Entrance:MenuManage(playerid, entranceID);
    }
    if (IsStringSame("Set Exit Position", inputtext)) {
        new entData[2], Float:entPOS[4];
        GetPlayerPos(playerid, entPOS[0], entPOS[1], entPOS[2]);
        GetPlayerFacingAngle(playerid, entPOS[3]);
        entData[0] = GetPlayerInterior(playerid);
        entData[1] = GetPlayerVirtualWorld(playerid);
        Entrance:Data[entranceID][Exit][0] = entPOS[0];
        Entrance:Data[entranceID][Exit][1] = entPOS[1];
        Entrance:Data[entranceID][Exit][2] = entPOS[2];
        Entrance:Data[entranceID][EFAngle] = entPOS[3];
        Entrance:Data[entranceID][EInterior] = entData[0];
        Entrance:Data[entranceID][EVirtualW] = entData[1];
        Entrance:UpdateDB(entranceID);
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Entrance Updated");
        return Entrance:MenuManage(playerid, entranceID);
    }
    if (IsStringSame("Remove Entrance", inputtext)) {
        Entrance:Data[entranceID][ID] = -1;
        Entrance:Data[entranceID][Name] = -1;
        Entrance:Data[entranceID][Enter][0] = -1;
        Entrance:Data[entranceID][Enter][1] = -1;
        Entrance:Data[entranceID][Enter][2] = -1;
        Entrance:Data[entranceID][Exit][0] = -1;
        Entrance:Data[entranceID][Exit][1] = -1;
        Entrance:Data[entranceID][Exit][2] = -1;
        Entrance:Data[entranceID][FAngle] = -1;
        Entrance:Data[entranceID][EFAngle] = -1;
        Entrance:Data[entranceID][Interior] = -1;
        Entrance:Data[entranceID][VirtualW] = -1;
        Entrance:Data[entranceID][EInterior] = -1;
        Entrance:Data[entranceID][EVirtualW] = -1;
        DestroyDynamic3DTextLabel(Entrance:Data[entranceID][EnterLabel]);
        DestroyDynamicPickup(Entrance:Data[entranceID][EnterPickup]);
        DestroyDynamic3DTextLabel(Entrance:Data[entranceID][ExitLabel]);
        DestroyDynamicPickup(Entrance:Data[entranceID][ExitPickup]);
        mysql_tquery(Database, sprintf("DELETE FROM entrances WHERE ID=%d", entranceID));
        Iter_Remove(Entrances, entranceID);
        SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Entrance Removed");
    }
    return Entrance:AdminPanel(playerid);
}

stock Entrance:MenuUpdateName(playerid, entranceID) {
    return FlexPlayerDialog(
        playerid, "EntranceMenuUpdateName", DIALOG_STYLE_INPUT, "Entrance System", "Enter new name", "Update", "Close", entranceID
    );
}

FlexDialog:EntranceMenuUpdateName(playerid, response, listitem, const inputtext[], entranceID, const payload[]) {
    if (!response) return Entrance:MenuManage(playerid, entranceID);
    new entName[25];
    if (sscanf(inputtext, "s[25]", entName)) return Entrance:MenuUpdateName(playerid, entranceID);
    Entrance:Data[entranceID][Name] = entName;
    Entrance:UpdateDB(entranceID);
    SendClientMessageEx(playerid, -1, "{4286f4}[Entrance System]: {FFFFEE}Entrance Renamed");
    return Entrance:MenuManage(playerid, entranceID);
}