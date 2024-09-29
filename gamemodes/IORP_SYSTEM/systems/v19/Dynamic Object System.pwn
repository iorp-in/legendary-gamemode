#define MAX_Dynamic_Objects   10000
enum Dynamic_Object_Data {
    ID,
    ModelID,
    Float:PosX,
    Float:PosY,
    Float:PosZ,
    Float:PosRX,
    Float:PosRY,
    Float:PosRZ,
    WorldID,
    InteriorID,
    bool:isMaterial,
    MaterialIND,
    MaterialModel,
    txdName[25],
    textureName[25],
    MaterialColor[25],

    DynamicId
}
new DynObj[MAX_Dynamic_Objects][Dynamic_Object_Data];
new Iterator:DynObjCount < MAX_Dynamic_Objects > ;

enum Editing_Dynamic_Object_Data {
    ObjectId,
    ID,
    bool:Status
}
new EditingDynObj[MAX_PLAYERS][Editing_Dynamic_Object_Data];

forward LoadDynObjects();
public LoadDynObjects() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, Id;
        while (Count < rows) {

            cache_get_value_name_int(Count, "ID", Id);
            cache_get_value_name_int(Count, "ID", DynObj[Id][ID]);
            cache_get_value_name_int(Count, "ModelID", DynObj[Id][ModelID]);
            cache_get_value_float(Count, "PosX", DynObj[Id][PosX]);
            cache_get_value_float(Count, "PosY", DynObj[Id][PosY]);
            cache_get_value_float(Count, "PosZ", DynObj[Id][PosZ]);
            cache_get_value_float(Count, "PosRX", DynObj[Id][PosRX]);
            cache_get_value_float(Count, "PosRY", DynObj[Id][PosRY]);
            cache_get_value_float(Count, "PosRZ", DynObj[Id][PosRZ]);
            cache_get_value_name_int(Count, "WorldID", DynObj[Id][WorldID]);
            cache_get_value_name_int(Count, "InteriorID", DynObj[Id][InteriorID]);
            cache_get_value_name_int(Count, "isMaterial", DynObj[Id][isMaterial]);
            cache_get_value_name_int(Count, "MaterialIND", DynObj[Id][MaterialIND]);
            cache_get_value_name_int(Count, "MaterialModel", DynObj[Id][MaterialModel]);
            cache_get_value_name(Count, "txdName", DynObj[Id][txdName], .max_len = 25);
            cache_get_value_name(Count, "textureName", DynObj[Id][textureName], .max_len = 25);
            cache_get_value_name(Count, "MaterialColor", DynObj[Id][MaterialColor], .max_len = 25);
            Iter_Add(DynObjCount, DynObj[Id][ID]);
            Count++;
        }
    }
    ReloadDynObjects();
    printf("  [Dynamic Object System] Loaded %d Dyanamic Object's.", rows);
    return 1;
}

hook OnGameModeInit() {
    new query[1024];
    strcat(query, "CREATE TABLE IF NOT EXISTS `dyanamicObjects` (\
	  `ID` int(11) NOT NULL,\
	  `ModelID` int(11) NOT NULL,\
	  `PosX` float NOT NULL,\
	  `PosY` float NOT NULL,\
	  `PosZ` float NOT NULL,\
	  `PosRX` float NOT NULL,\
	  `PosRY` float NOT NULL,\
	  `PosRZ` float NOT NULL,\
	  `WorldID` int(11) NOT NULL,\
	  `InteriorID` int(11) NOT NULL,");
    strcat(query, "`isMaterial` tinyint(1) NOT NULL,\
	  `MaterialIND` int(11) NOT NULL,\
	  `MaterialModel` int(11) NULL,\
	  `txdName` varchar(25) NULL,\
	  `textureName` varchar(25) NULL,\
	  `MaterialColor` varchar(25) NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "select * from dyanamicObjects", "LoadDynObjects", "");
    return 1;
}

stock ReloadDynObjects() {
    foreach(new Id:DynObjCount) {
        DestroyDynamicObjectEx(DynObj[Id][DynamicId]);
        DynObj[Id][DynamicId] = CreateDynamicObject(DynObj[Id][ModelID], DynObj[Id][PosX], DynObj[Id][PosY], DynObj[Id][PosZ], DynObj[Id][PosRX], DynObj[Id][PosRY], DynObj[Id][PosRZ],
            DynObj[Id][WorldID], DynObj[Id][InteriorID], -1);
        if (DynObj[Id][isMaterial]) {
            SetDynamicObjectMaterial(DynObj[Id][DynamicId], DynObj[Id][MaterialIND], DynObj[Id][MaterialModel], DynObj[Id][txdName], DynObj[Id][textureName], DynObj[Id][MaterialColor]);
        }
    }
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (EditingDynObj[playerid][Status]) {
        switch (response) {
            case EDIT_RESPONSE_CANCEL:  {
                new Id = EditingDynObj[playerid][ID];
                SetDynamicObjectPos(objectid, DynObj[Id][PosX], DynObj[Id][PosY], DynObj[Id][PosZ]);
                SetDynamicObjectRot(objectid, DynObj[Id][PosRX], DynObj[Id][PosRY], DynObj[Id][PosRZ]);

                EditingDynObj[playerid][Status] = false;
            }

            case EDIT_RESPONSE_FINAL:  {
                new Id = EditingDynObj[playerid][ID];
                DynObj[Id][PosX] = x;
                DynObj[Id][PosY] = y;
                DynObj[Id][PosZ] = z;
                DynObj[Id][PosRX] = rx;
                DynObj[Id][PosRY] = ry;
                DynObj[Id][PosRZ] = rz;
                SetDynamicObjectPos(objectid, DynObj[Id][PosX], DynObj[Id][PosY], DynObj[Id][PosZ]);
                SetDynamicObjectRot(objectid, DynObj[Id][PosRX], DynObj[Id][PosRY], DynObj[Id][PosRZ]);

                new query[512];
                mysql_format(
                    Database, query, sizeof(query),
                    "UPDATE `dyanamicObjects` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosRX`='%f',`PosRY`='%f',`PosRZ`='%f' WHERE `ID`='%d'",
                    DynObj[Id][PosX], DynObj[Id][PosY], DynObj[Id][PosZ], DynObj[Id][PosRX], DynObj[Id][PosRY], DynObj[Id][PosRZ], Id
                );
                mysql_tquery(Database, query);
                EditingDynObj[playerid][Status] = false;
            }
        }
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Dynamic Object System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Dynamic Object System", inputtext)) DynObjectAdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "object system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    DynObjectAdminPanel(playerid);
    return ~1;
}

stock DynObjectAdminPanel(playerid) {
    new string[1024];
    strcat(string, "Manage Dynamic Object\n");
    strcat(string, "Reload Dynamic Objects\n");
    strcat(string, "Create Dynamic Object\n");
    return FlexPlayerDialog(playerid, "DynObjectAdminPanel", DIALOG_STYLE_LIST, "{4286f4}[Dynamic Object System]:{FFFFEE}ACP", string, "Select", "Close");
}

FlexDialog:DynObjectAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage Dynamic Object")) return DynObjectMenuManage(playerid);
    if (IsStringSame(inputtext, "Create Dynamic Object")) return DynObjectCreate(playerid);
    if (IsStringSame(inputtext, "Reload Dynamic Objects")) {
        ReloadDynObjects();
        AlexaMsg(playerid, "reloaded dynamic objects");
        return DynObjectAdminPanel(playerid);
    }
    return 1;
}

stock DynObjectCreate(playerid) {
    return FlexPlayerDialog(playerid, "DynObjectCreate", DIALOG_STYLE_INPUT, "{4286f4}[Dynamic Object System]:{FFFFEE}ACP", "Enter Model ID", "Create", "Close");
}

FlexDialog:DynObjectCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (!response) return 1;
    new Id, mId, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, wid, iid;
    if (sscanf(inputtext, "i", mId)) return DynObjectCreate(playerid);
    GetPlayerPos(playerid, x, y, z);
    wid = GetPlayerVirtualWorld(playerid);
    iid = GetPlayerInterior(playerid);
    Id = Iter_Free(DynObjCount);
    if (Id == INVALID_ITERATOR_SLOT) return 1;
    DynObj[Id][ID] = Id;
    DynObj[Id][ModelID] = mId;
    DynObj[Id][PosX] = x;
    DynObj[Id][PosY] = y;
    DynObj[Id][PosZ] = z;
    DynObj[Id][PosRX] = 0;
    DynObj[Id][PosRY] = 0;
    DynObj[Id][PosRZ] = 0;
    DynObj[Id][WorldID] = wid;
    DynObj[Id][InteriorID] = iid;
    DynObj[Id][isMaterial] = false;
    DynObj[Id][MaterialIND] = 0;
    mysql_tquery(Database, sprintf(
        "INSERT INTO `dyanamicObjects`(`ID`, `ModelID`, `PosX`, `PosY`, `PosZ`, `PosRX`, `PosRY`, `PosRZ`, \
        `WorldID`, `InteriorID`, `isMaterial`,`MaterialModel`, `MaterialIND`, `txdName`, `textureName`, `MaterialColor`) \
 		VALUES ('%d','%d','%f','%f','%f','%f','%f','%f','%d','%d','%d','%d','%d',\"%s\",\"%s\",\"%s\")",
        Id, mId, x, y, z, rx, ry, rz, wid, iid, 0, 0, 0, 0, 0, 0
    ));
    AlexaMsg(playerid, sprintf("Object Inserted Id: %d", Id));
    Iter_Add(DynObjCount, DynObj[Id][ID]);
    ReloadDynObjects();
    DynObjectAdminPanel(playerid);
    return 1;
}

stock DynObjectIsValid(dynid) {
    return Iter_Contains(DynObjCount, dynid);
}

stock DynObjectMenuManage(playerid) {
    return FlexPlayerDialog(playerid, "DynObjectMenuManage", DIALOG_STYLE_INPUT, "{4286f4}[Dynamic Object System]:{FFFFEE}ACP", "Enter Dynamic Object ID", "Submit", "Close");
}

FlexDialog:DynObjectMenuManage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DynObjectAdminPanel(playerid);
    new dynid;
    if (sscanf(inputtext, "d", dynid) || !DynObjectIsValid(dynid)) return DynObjectMenuManage(playerid);
    return DynObjectManage(playerid, dynid);
}

stock DynObjectManage(playerid, dynid) {
    new string[512];
    strcat(string, "Teleport to Object\n");
    strcat(string, "Edit Position\n");
    strcat(string, "Set Material\n");
    strcat(string, "Remove Object\n");
    return FlexPlayerDialog(playerid, "DynObjectManage", DIALOG_STYLE_LIST, "Dynamic Object", string, "Select", "Cancel", dynid);
}

FlexDialog:DynObjectManage(playerid, response, listitem, const inputtext[], dynid, const payload[]) {
    if (!response) return DynObjectMenuManage(playerid);
    if (IsStringSame(inputtext, "Set Material")) return DynObjectUpdateMat(playerid, dynid);
    if (IsStringSame(inputtext, "Teleport to Object")) {
        SetPlayerPosEx(playerid, DynObj[dynid][PosX] + 1, DynObj[dynid][PosY] + 1, DynObj[dynid][PosZ] + 1);
        AlexaMsg(playerid, sprintf("{db6600}[Object System]: {FFFFEE}Teleported to dynamic object: %d", dynid));
        return DynObjectManage(playerid, dynid);
    }
    if (IsStringSame(inputtext, "Edit Position")) {
        if (!IsPlayerInRangeOfPoint(playerid, 50.0, DynObj[dynid][PosX], DynObj[dynid][PosY], DynObj[dynid][PosZ])) {
            AlexaMsg(playerid, sprintf("{db6600}[Object System]: {FFFFEE}you are too far from objectid %d", dynid));
            return DynObjectManage(playerid, dynid);
        }
        AlexaMsg(playerid, sprintf("{db6600}[Object System]: {FFFFEE}Editting %d", dynid));
        EditingDynObj[playerid][ID] = dynid;
        EditingDynObj[playerid][ObjectId] = DynObj[dynid][DynamicId];
        EditingDynObj[playerid][Status] = true;
        EditDynamicObject(playerid, EditingDynObj[playerid][ObjectId]);
        return 1;
    }
    if (IsStringSame(inputtext, "Remove Object")) {
        DestroyDynamicObjectEx(DynObj[dynid][DynamicId]);
        mysql_tquery(Database, sprintf("DELETE FROM `dyanamicObjects` WHERE `ID` = '%d'", dynid));
        Iter_Remove(DynObjCount, dynid);
        AlexaMsg(playerid, sprintf("{db6600}[Object System]: {FFFFEE}Object Removed Id: %d", dynid));
        return DynObjectAdminPanel(playerid);
    }
    return 1;
}

stock DynObjectUpdateMat(playerid, dynid) {
    return FlexPlayerDialog(
        playerid, "DynObjectUpdateMat", DIALOG_STYLE_INPUT, "{4286f4}[Dynamic Object System]: {FFFFEE}ACP",
        "Enter Following Details\n[IsMaterial] [MatIndex] [MatModel] [TxDName] [TextureName] [MaterialColor]",
        "Submit", "Close", dynid
    );
}

FlexDialog:DynObjectUpdateMat(playerid, response, listitem, const inputtext[], dynid, const payload[]) {
    if (!response) return DynObjectManage(playerid, dynid);
    new Id = dynid, bool:ismat, matind, matmodel, txdname[25], txturename[25], matcol[25];
    if (sscanf(inputtext, "liis[25]s[25]s[25]", ismat, matind, matmodel, txdname, txturename, matcol)) return DynObjectUpdateMat(playerid, dynid);
    DynObj[Id][isMaterial] = ismat;
    DynObj[Id][MaterialIND] = matind;
    DynObj[Id][MaterialModel] = matmodel;
    DynObj[Id][txdName] = txdname;
    DynObj[Id][textureName] = txturename;
    DynObj[Id][MaterialColor] = matcol;
    mysql_tquery(
        Database,
        sprintf(
            "UPDATE `dyanamicObjects` SET `isMaterial`='%d',`MaterialIND`='%d',`MaterialModel`='%d',`txdName`=\"%s\", \
            `textureName`=\"%s\",`MaterialColor`= \"%s\" WHERE `ID` = '%d'",
            ismat, matind, matmodel, txdname, txturename, matcol, Id
        )
    );
    ReloadDynObjects();
    AlexaMsg(playerid, sprintf("{db6600}[Object System]: {FFFFEE}Dynamic object %d updated", dynid));
    return DynObjectManage(playerid, dynid);
}