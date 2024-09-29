#define     MAX_COP_OBJECTS     (300)
#define     SPEEDCAM_RANGE      (30.0)

new Iterator:COP_OBJECTS < MAX_COP_OBJECTS > ;

enum _:e_object_types {
    OBJECT_TYPE_ROADBLOCK,
    OBJECT_TYPE_SIGN,
    OBJECT_TYPE_POLICELINE,
    OBJECT_TYPE_SPIKE,
    OBJECT_TYPE_SPEEDCAM
}

enum e_object_data {
    Owner[MAX_PLAYER_NAME],
        Type,
        ObjData,
        ObjModel,
        Float:ObjX,
        Float:ObjY,
        Float:ObjZ,
        Float:ObjRX,
        Float:ObjRY,
        Float:ObjRZ,
        ObjInterior,
        ObjVirtualWorld,
        ObjID,
        Text3D:ObjLabel,
        ObjArea
}

new FactionObject:Data[MAX_COP_OBJECTS][e_object_data],
    EditingCopObjectID[MAX_PLAYERS] = {
        -1,
        ...
    };

new Float:zOffsets[5] = {
        1.35,
        3.25,
        0.35,
        0.4,
        5.35
    },
    Float:streamDistances[5] = {
        10.0,
        10.0,
        5.0,
        3.0,
        SPEEDCAM_RANGE
    };

stock FactionObject:EncodeTires(tire1, tire2, tire3, tire4) return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
new RoadblockList[] = { 1427, 1425, 1282, 1424, 1422, 1423, 1459, 978, 979, 981, 3091, 1238, 19425, 19467 };
new SignList[] = { 19948, 19949, 19950, 19951, 19952, 19953, 19954, 19955, 19956, 19957, 19958, 19959, 19960, 19961, 19962, 19963, 19964, 19965, 19966, 19967, 19968, 19969, 19970, 19971, 19972, 19973, 19974, 19975, 19976, 19977, 19978, 19979, 19982, 19983, 19984, 19985, 19986, 19987, 19988, 19989, 19990, 19991, 19992 };

forward FactionLoadObjects();
public FactionLoadObjects() {
    new rows = cache_num_rows();
    if (rows) {
        new Id, loaded, label[96];
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", Id);
            cache_get_value_name(loaded, "owner", FactionObject:Data[Id][Owner], .max_len = MAX_PLAYER_NAME);
            cache_get_value_name_int(loaded, "type", FactionObject:Data[Id][Type]);
            cache_get_value_name_int(loaded, "data", FactionObject:Data[Id][ObjData]);
            cache_get_value_name_int(loaded, "model", FactionObject:Data[Id][ObjModel]);
            cache_get_value_name_float(loaded, "posx", FactionObject:Data[Id][ObjX]);
            cache_get_value_name_float(loaded, "posy", FactionObject:Data[Id][ObjY]);
            cache_get_value_name_float(loaded, "posz", FactionObject:Data[Id][ObjZ]);
            cache_get_value_name_float(loaded, "rotx", FactionObject:Data[Id][ObjRX]);
            cache_get_value_name_float(loaded, "roty", FactionObject:Data[Id][ObjRY]);
            cache_get_value_name_float(loaded, "rotz", FactionObject:Data[Id][ObjRZ]);
            cache_get_value_name_int(loaded, "interior", FactionObject:Data[Id][ObjInterior]);
            cache_get_value_name_int(loaded, "virtualworld", FactionObject:Data[Id][ObjVirtualWorld]);

            FactionObject:Data[Id][ObjID] = CreateDynamicObject(FactionObject:Data[Id][ObjModel], FactionObject:Data[Id][ObjX], FactionObject:Data[Id][ObjY], FactionObject:Data[Id][ObjZ], FactionObject:Data[Id][ObjRX], FactionObject:Data[Id][ObjRY], FactionObject:Data[Id][ObjRZ], FactionObject:Data[Id][ObjVirtualWorld], FactionObject:Data[Id][ObjInterior]);
            FactionObject:Data[Id][ObjArea] = -1;

            switch (FactionObject:Data[Id][Type]) {
                case OBJECT_TYPE_ROADBLOCK:
                    format(label, sizeof(label), "Roadblock (ID:%d)\n{FFFFFF}Placed by %s", Id, FactionObject:Data[Id][Owner]);
                case OBJECT_TYPE_SIGN:
                    format(label, sizeof(label), "Sign (ID:%d)\n{FFFFFF}Placed by %s", Id, FactionObject:Data[Id][Owner]);
                case OBJECT_TYPE_POLICELINE:
                    format(label, sizeof(label), "Police Line (ID:%d)\n{FFFFFF}Placed by %s", Id, FactionObject:Data[Id][Owner]);
                case OBJECT_TYPE_SPIKE:  {
                    format(label, sizeof(label), "Spike Strip (ID:%d)\n{FFFFFF}Placed by %s", Id, FactionObject:Data[Id][Owner]);
                    FactionObject:Data[Id][ObjArea] = CreateDynamicSphere(FactionObject:Data[Id][ObjX], FactionObject:Data[Id][ObjY], FactionObject:Data[Id][ObjZ], 2.5, FactionObject:Data[Id][ObjVirtualWorld], FactionObject:Data[Id][ObjInterior]);
                }

                case OBJECT_TYPE_SPEEDCAM:  {
                    format(label, sizeof(label), "Speed Camera (ID:%d)\n{FFFFFF}Speed Limit:{4286f4}%d\n{FFFFFF}Placed by %s", Id, FactionObject:Data[Id][ObjData], FactionObject:Data[Id][Owner]);
                    FactionObject:Data[Id][ObjArea] = CreateDynamicSphere(FactionObject:Data[Id][ObjX], FactionObject:Data[Id][ObjY], FactionObject:Data[Id][ObjZ], SPEEDCAM_RANGE, FactionObject:Data[Id][ObjVirtualWorld], FactionObject:Data[Id][ObjInterior]);
                }
            }

            FactionObject:Data[Id][ObjLabel] = CreateDynamic3DTextLabel(label, 0x3498DBFF, FactionObject:Data[Id][ObjX], FactionObject:Data[Id][ObjY], FactionObject:Data[Id][ObjZ] + zOffsets[FactionObject:Data[Id][Type]], streamDistances[FactionObject:Data[Id][Type]], _, _, _, FactionObject:Data[Id][ObjVirtualWorld], FactionObject:Data[Id][ObjInterior]);

            Iter_Add(COP_OBJECTS, Id);
            loaded++;
        }
    }
    printf("  [Police Faction Object System] Loaded %d Object's.", rows);
    return 1;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `factionObjects` (\
	  `ID` int(11) NOT NULL,\
	  `owner` varchar(32) NOT NULL,\
	  `type` int(11) NOT NULL,\
	  `data` int(11) NOT NULL,\
	  `model` int(11) NOT NULL,\
	  `posx` float NOT NULL,\
	  `posy` float NOT NULL,\
	  `posz` float NOT NULL,\
	  `rotx` float NOT NULL,\
	  `roty` float NOT NULL,\
	  `rotz` float NOT NULL,\
	  `interior` int(11) NOT NULL,\
	  `virtualworld` int(11) NOT NULL,\
	  PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    mysql_tquery(Database, "select * from factionObjects", "FactionLoadObjects", "");
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EditingCopObjectID[playerid] = -1;
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid) {
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        foreach(new i:COP_OBJECTS) {
            if (!Iter_Contains(COP_OBJECTS, i)) continue;
            if (areaid == FactionObject:Data[i][ObjArea]) {
                switch (FactionObject:Data[i][Type]) {
                    case OBJECT_TYPE_SPIKE:  {
                        new panels, doors, lights, tires;
                        GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
                        UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, FactionObject:EncodeTires(1, 1, 1, 1));
                        PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
                    }

                    case OBJECT_TYPE_SPEEDCAM:  {
                        new speed = GetVehicleSpeedEx(playerid);
                        if (speed > FactionObject:Data[i][ObjData]) {
                            // detected by a speed camera
                            new allow_faction[] = { 0, 1, 2, 3 };
                            if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
                                PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
                            } else {
                                if (IsTimePassedForPlayer(playerid, "speedCamLimit", 10)) {
                                    PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
                                    SendClientMessageEx(playerid, -1, "{0000DD}[SAPD]:{FFFFEE}You got busted! Slow down.");
                                    WantedDatabase:GiveWantedLevel(playerid, sprintf("Got Busted by camid %d", i));
                                }
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (EditingCopObjectID[playerid] != -1) {
        new sapdObjectID = EditingCopObjectID[playerid];

        switch (response) {
            case EDIT_RESPONSE_FINAL:  {
                FactionObject:Data[sapdObjectID][ObjX] = x;
                FactionObject:Data[sapdObjectID][ObjY] = y;
                FactionObject:Data[sapdObjectID][ObjZ] = z;
                FactionObject:Data[sapdObjectID][ObjRX] = rx;
                FactionObject:Data[sapdObjectID][ObjRY] = ry;
                FactionObject:Data[sapdObjectID][ObjRZ] = rz;
                SetDynamicObjectPos(objectid, x, y, z);
                SetDynamicObjectRot(objectid, rx, ry, rz);

                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, FactionObject:Data[sapdObjectID][ObjLabel], E_STREAMER_X, x);
                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, FactionObject:Data[sapdObjectID][ObjLabel], E_STREAMER_Y, y);
                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, FactionObject:Data[sapdObjectID][ObjLabel], E_STREAMER_Z, z + zOffsets[FactionObject:Data[sapdObjectID][Type]]);

                if (IsValidDynamicArea(FactionObject:Data[sapdObjectID][ObjArea])) {
                    Streamer_SetFloatData(STREAMER_TYPE_AREA, FactionObject:Data[sapdObjectID][ObjArea], E_STREAMER_X, x);
                    Streamer_SetFloatData(STREAMER_TYPE_AREA, FactionObject:Data[sapdObjectID][ObjArea], E_STREAMER_Y, y);
                    Streamer_SetFloatData(STREAMER_TYPE_AREA, FactionObject:Data[sapdObjectID][ObjArea], E_STREAMER_Z, z + zOffsets[FactionObject:Data[sapdObjectID][Type]]);
                }

                new query[512];
                mysql_format(Database, query, sizeof(query), "UPDATE `factionObjects` SET `posx`='%f',`posy`='%f',`posz`='%f',`rotx`='%f',`roty`='%f',`rotz`='%f' WHERE `ID`='%d'",
                    FactionObject:Data[sapdObjectID][ObjX], FactionObject:Data[sapdObjectID][ObjY], FactionObject:Data[sapdObjectID][ObjZ], FactionObject:Data[sapdObjectID][ObjRX], FactionObject:Data[sapdObjectID][ObjRY], FactionObject:Data[sapdObjectID][ObjRZ], sapdObjectID);
                mysql_tquery(Database, query);

                EditingCopObjectID[playerid] = -1;
            }

            case EDIT_RESPONSE_CANCEL:  {
                SetDynamicObjectPos(objectid, FactionObject:Data[sapdObjectID][ObjX], FactionObject:Data[sapdObjectID][ObjY], FactionObject:Data[sapdObjectID][ObjZ]);
                SetDynamicObjectRot(objectid, FactionObject:Data[sapdObjectID][ObjRX], FactionObject:Data[sapdObjectID][ObjRY], FactionObject:Data[sapdObjectID][ObjRZ]);
                EditingCopObjectID[playerid] = -1;
            }
        }
    }
    return 1;
}

stock SAPDObjectEdit(playerid, sapdObjectID) {
    if (!Iter_Contains(COP_OBJECTS, sapdObjectID)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Object Does not Exist.");
    if (EditingCopObjectID[playerid] != -1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already editing an object.");
    if (!IsPlayerInRangeOfPoint(playerid, 16.0, FactionObject:Data[sapdObjectID][ObjX], FactionObject:Data[sapdObjectID][ObjY], FactionObject:Data[sapdObjectID][ObjZ])) return SendClientMessageEx(playerid, -1, "ERROR:{FFFFFF}You're not near the object you want to edit.");
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    if (GetPlayerAdminLevel(playerid) < 1 && strcmp(FactionObject:Data[sapdObjectID][Owner], name)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}This object isn't yours, you can't edit it.");
    EditingCopObjectID[playerid] = sapdObjectID;
    EditDynamicObject(playerid, FactionObject:Data[sapdObjectID][ObjID]);
    return 1;
}

stock SAPDObjectRemove(playerid, sapdObjectID) {
    if (!Iter_Contains(COP_OBJECTS, sapdObjectID)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Object Does not Exist.");
    if (EditingCopObjectID[playerid] == sapdObjectID) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't remove an object you're editing.");
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    if (GetPlayerAdminLevel(playerid) < 1 && strcmp(FactionObject:Data[sapdObjectID][Owner], name)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}This object isn't yours, you can't remove it.");
    DestroyDynamicObjectEx(FactionObject:Data[sapdObjectID][ObjID]);
    DestroyDynamic3DTextLabel(FactionObject:Data[sapdObjectID][ObjLabel]);
    if (IsValidDynamicArea(FactionObject:Data[sapdObjectID][ObjArea])) DestroyDynamicArea(FactionObject:Data[sapdObjectID][ObjArea]);
    FactionObject:Data[sapdObjectID][ObjID] = -1;
    FactionObject:Data[sapdObjectID][ObjLabel] = Text3D:  - 1;
    FactionObject:Data[sapdObjectID][ObjArea] = -1;
    Iter_Remove(COP_OBJECTS, sapdObjectID);
    new query[512];
    mysql_format(Database, query, sizeof(query), "DELETE FROM `factionObjects` WHERE `ID`='%d'", sapdObjectID);
    mysql_tquery(Database, query);
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Object removed.");
    return 1;
}

stock FactionObject:AddSpeedcam(playerid, speedlimit) {
    new sapdObjectID = Iter_Free(COP_OBJECTS), limit = speedlimit;
    if (sapdObjectID == INVALID_ITERATOR_SLOT) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Cop object limit reached.");
    GetPlayerName(playerid, FactionObject:Data[sapdObjectID][Owner], MAX_PLAYER_NAME);
    FactionObject:Data[sapdObjectID][Type] = OBJECT_TYPE_SPEEDCAM;
    FactionObject:Data[sapdObjectID][ObjData] = limit;
    FactionObject:Data[sapdObjectID][ObjModel] = 18880;
    FactionObject:Data[sapdObjectID][ObjInterior] = GetPlayerInterior(playerid);
    FactionObject:Data[sapdObjectID][ObjVirtualWorld] = GetPlayerVirtualWorld(playerid);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (2.0 * floatsin(-a, degrees));
    y += (2.0 * floatcos(-a, degrees));
    FactionObject:Data[sapdObjectID][ObjX] = x;
    FactionObject:Data[sapdObjectID][ObjY] = y;
    FactionObject:Data[sapdObjectID][ObjZ] = z - 1.5;
    FactionObject:Data[sapdObjectID][ObjRX] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRY] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRZ] = 0.0;
    FactionObject:Data[sapdObjectID][ObjID] = CreateDynamicObject(18880, x, y, z - 1.5, 0.0, 0.0, 0.0, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]);
    FactionObject:Data[sapdObjectID][ObjArea] = CreateDynamicSphere(x, y, z - 1.5, SPEEDCAM_RANGE, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]);

    new string[128];
    format(string, sizeof(string), "Speed Camera (ID:%d)\n{FFFFFF}Speed Limit:{4286f4}%d\n{FFFFFF}Placed by %s", sapdObjectID, limit, FactionObject:Data[sapdObjectID][Owner]);
    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(string, 0x3498DBFF, x, y, z + 3.85, SPEEDCAM_RANGE, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]);

    Iter_Add(COP_OBJECTS, sapdObjectID);

    FactionObject:InsertDB(sapdObjectID);
    return sapdObjectID;
}

stock UpdateSpeedCamLimit(playerid, sapdObjectID, speedlimit) {
    if (!Iter_Contains(COP_OBJECTS, sapdObjectID)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Object Does not Exist.");
    if (FactionObject:Data[sapdObjectID][Type] != OBJECT_TYPE_SPEEDCAM) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Object is not a speedcam.");
    FactionObject:Data[sapdObjectID][ObjData] = speedlimit;
    DestroyDynamic3DTextLabel(FactionObject:Data[sapdObjectID][ObjLabel]);
    new string[128];
    format(string, sizeof(string), "Speed Camera (ID:%d)\n{FFFFFF}Speed Limit:{4286f4}%d\n{FFFFFF}Placed by %s", sapdObjectID, speedlimit, FactionObject:Data[sapdObjectID][Owner]);
    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(string, 0x3498DBFF, FactionObject:Data[sapdObjectID][ObjX], FactionObject:Data[sapdObjectID][ObjY], FactionObject:Data[sapdObjectID][ObjZ] + 5.35, SPEEDCAM_RANGE, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]);
    new query[512];
    mysql_format(Database, query, sizeof(query), "UPDATE `factionObjects` SET `data` = '%d' WHERE `ID`='%d'", speedlimit, sapdObjectID);
    mysql_tquery(Database, query);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    new vehicleid = GetPlayerNearestVehicle(playerid, 10.0);
    new staticId = StaticVehicle:GetID(vehicleid);
    if (GetVehicleModel(vehicleid) != 433 || !StaticVehicle:IsValidID(staticId) || !IsArrayContainNumber(allow_faction, StaticVehicle:GetFactionID(staticId))) return 1;
    if (
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)
    ) UCP:AddCommand(playerid, "SAPD Objects", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("SAPD Objects", inputtext)) return FactionObject:CommandMenu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    new allow_faction[] = { 0, 1, 2, 3 };
    if (!IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) || !Faction:IsPlayerSigned(playerid)) return 1;
    if (IsStringContainWords(text, "sapd place")) {
        new object[40];
        if (!sscanf(GetNextWordFromString(text, "place"), "s[40]", object)) {
            if (IsStringSame("speedcam", object)) {
                SAPDObjectEdit(playerid, FactionObject:AddSpeedcam(playerid, 110));
                return ~1;
            }
        }
        FactionObject:CommandMenu(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "sapd edit")) {
        new objectID;
        if (sscanf(GetNextWordFromString(text, "edit"), "d", objectID)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}objectid required.");
            return ~1;
        }
        SAPDObjectEdit(playerid, objectID);
        return ~1;
    }
    if (IsStringContainWords(text, "sapd remove")) {
        new objectID;
        if (sscanf(GetNextWordFromString(text, "remove"), "d", objectID)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}objectid required.");
            return ~1;
        }
        SAPDObjectRemove(playerid, objectID);
        return ~1;
    }
    if (IsStringContainWords(text, "set speedcam limit")) {
        new speedcamID, speedcamLimit;
        if (sscanf(GetNextWordFromString(text, "speedcam"), "d", speedcamID)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Speedcam id required.");
            return ~1;
        }
        if (sscanf(GetNextWordFromString(text, "limit"), "d", speedcamLimit)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Speedcam limit required.");
            return ~1;
        }
        UpdateSpeedCamLimit(playerid, speedcamID, speedcamLimit);
        return ~1;
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `factionObjects` SET `owner` = \"%s\" WHERE  `owner` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `factionObjects` WHERE `owner` = \"%s\"", AccountName));
    return 1;
}

stock FactionObject:IsValid(sapdObjectID) {
    return Iter_Contains(COP_OBJECTS, sapdObjectID);
}

stock FactionObject:CommandMenu(playerid) {
    new string[512];
    strcat(string, "Place Object\n");
    strcat(string, "Manage Object\n");
    return FlexPlayerDialog(playerid, "FactionObjectMenu", DIALOG_STYLE_LIST, "SAPD Objects", string, "Select", "Close");
}

FlexDialog:FactionObjectMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Place Object")) return FactionObject:Place(playerid);
    if (IsStringSame(inputtext, "Manage Object")) return FactionObject:ManageInput(playerid);
    return 1;
}

stock FactionObject:ManageInput(playerid) {
    return FlexPlayerDialog(playerid, "FactionObjectManageInput", DIALOG_STYLE_INPUT, "SAPD: Manage Object", "Enter object id to manage", "Manage", "Close");
}

FlexDialog:FactionObjectManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FactionObject:CommandMenu(playerid);
    new sapdObjectID;
    if (sscanf(inputtext, "d", sapdObjectID) || !FactionObject:IsValid(sapdObjectID) || EditingCopObjectID[playerid] == sapdObjectID) return FactionObject:ManageInput(playerid);
    return FactionObject:Manage(playerid, sapdObjectID);
}

stock FactionObject:Manage(playerid, sapdObjectID) {
    new string[512];
    strcat(string, "Teleport to object\n");
    strcat(string, "Edit object\n");
    strcat(string, "Remove Object\n");
    return FlexPlayerDialog(playerid, "FactionObjectManage", DIALOG_STYLE_LIST, "Manage Object", string, "Select", "Close", sapdObjectID);
}

FlexDialog:FactionObjectManage(playerid, response, listitem, const inputtext[], sapdObjectID, const payload[]) {
    if (!response) return FactionObject:ManageInput(playerid);
    if (IsStringSame(inputtext, "Edit object")) return SAPDObjectEdit(playerid, sapdObjectID);
    if (IsStringSame(inputtext, "Teleport to object")) {
        SetPlayerPosEx(playerid, FactionObject:Data[sapdObjectID][ObjX] + 1, FactionObject:Data[sapdObjectID][ObjY] + 1, FactionObject:Data[sapdObjectID][ObjZ] + 1.75);
        SetPlayerInteriorEx(playerid, FactionObject:Data[sapdObjectID][ObjInterior]);
        SetPlayerVirtualWorldEx(playerid, FactionObject:Data[sapdObjectID][ObjVirtualWorld]);
        AlexaMsg(playerid, "Teleported to object");
        return FactionObject:Manage(playerid, sapdObjectID);
    }
    if (IsStringSame(inputtext, "Remove Object")) {
        SAPDObjectRemove(playerid, sapdObjectID);
        return FactionObject:CommandMenu(playerid);
    }
    return 1;
}

stock FactionObject:Place(playerid) {
    new string[1024];
    strcat(string, "Roadblocks\n");
    strcat(string, "Signs\n");
    strcat(string, "Police Line\n");
    strcat(string, "Spike Strip\n");
    strcat(string, "Speed Camera\n");
    return FlexPlayerDialog(playerid, "FactionObjectPlace", DIALOG_STYLE_LIST, "Choose Category", string, "Select", "Close");
}

FlexDialog:FactionObjectPlace(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FactionObject:CommandMenu(playerid);
    if (IsStringSame(inputtext, "Roadblocks")) return FactionObject:PlaceRoadblock(playerid);
    if (IsStringSame(inputtext, "Signs")) return FactionObject:PlaceSign(playerid);
    if (IsStringSame(inputtext, "Speed Camera")) return FactionObject:PlaceSpeedcam(playerid);
    if (IsStringSame(inputtext, "Police Line")) return FactionObject:PlacePoliceLine(playerid);
    if (IsStringSame(inputtext, "Spike Strip")) return FactionObject:PlaceSpikeStrip(playerid);
    return 1;
}

stock FactionObject:PlacePoliceLine(playerid) {
    new sapdObjectID = Iter_Free(COP_OBJECTS);
    if (sapdObjectID == INVALID_ITERATOR_SLOT) {
        AlexaMsg(playerid, "maximum limit reached for objects, try removing some other obects");
        return FactionObject:Place(playerid);
    }
    GetPlayerName(playerid, FactionObject:Data[sapdObjectID][Owner], MAX_PLAYER_NAME);
    FactionObject:Data[sapdObjectID][Type] = OBJECT_TYPE_POLICELINE;
    FactionObject:Data[sapdObjectID][ObjModel] = 19834;
    FactionObject:Data[sapdObjectID][ObjInterior] = GetPlayerInterior(playerid);
    FactionObject:Data[sapdObjectID][ObjVirtualWorld] = GetPlayerVirtualWorld(playerid);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (2.0 * floatsin(-a, degrees));
    y += (2.0 * floatcos(-a, degrees));
    FactionObject:Data[sapdObjectID][ObjX] = x;
    FactionObject:Data[sapdObjectID][ObjY] = y;
    FactionObject:Data[sapdObjectID][ObjZ] = z;
    FactionObject:Data[sapdObjectID][ObjRX] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRY] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRZ] = a;
    FactionObject:Data[sapdObjectID][ObjArea] = -1;
    Iter_Add(COP_OBJECTS, sapdObjectID);

    FactionObject:Data[sapdObjectID][ObjID] = CreateDynamicObject(
        19834, x, y, z, 0.0, 0.0, a, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );

    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(
        sprintf("Police Line (ID:%d)\n{FFFFFF}Placed by %s", sapdObjectID, FactionObject:Data[sapdObjectID][Owner]),
        0x3498DBFF, x, y, z + 0.35, 5.0, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );

    FactionObject:InsertDB(sapdObjectID);
    return FactionObject:Place(playerid);
}

stock FactionObject:PlaceSpikeStrip(playerid) {
    new sapdObjectID = Iter_Free(COP_OBJECTS);
    if (sapdObjectID == INVALID_ITERATOR_SLOT) {
        AlexaMsg(playerid, "maximum limit reached for objects, try removing some other obects");
        return FactionObject:Place(playerid);
    }
    GetPlayerName(playerid, FactionObject:Data[sapdObjectID][Owner], MAX_PLAYER_NAME);
    FactionObject:Data[sapdObjectID][Type] = OBJECT_TYPE_SPIKE;
    FactionObject:Data[sapdObjectID][ObjModel] = 2899;
    FactionObject:Data[sapdObjectID][ObjInterior] = GetPlayerInterior(playerid);
    FactionObject:Data[sapdObjectID][ObjVirtualWorld] = GetPlayerVirtualWorld(playerid);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (2.0 * floatsin(-a, degrees));
    y += (2.0 * floatcos(-a, degrees));

    FactionObject:Data[sapdObjectID][ObjX] = x;
    FactionObject:Data[sapdObjectID][ObjY] = y;
    FactionObject:Data[sapdObjectID][ObjZ] = z - 0.85;
    FactionObject:Data[sapdObjectID][ObjRX] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRY] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRZ] = a + 90.0;

    FactionObject:Data[sapdObjectID][ObjID] = CreateDynamicObject(
        2899, x, y, z - 0.85, 0.0, 0.0, a + 90.0, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );

    FactionObject:Data[sapdObjectID][ObjArea] = CreateDynamicSphere(
        x, y, z - 0.85, 2.5, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );

    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(
        sprintf("Spike Strip (ID:%d)\n{FFFFFF}Placed by %s", sapdObjectID, FactionObject:Data[sapdObjectID][Owner]),
        0x3498DBFF, x, y, z - 0.4, 3.0, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );

    Iter_Add(COP_OBJECTS, sapdObjectID);
    FactionObject:InsertDB(sapdObjectID);
    return FactionObject:Place(playerid);
}

stock FactionObject:InsertDB(sapdObjectID) {
    mysql_tquery(Database, sprintf(
        "INSERT INTO `factionObjects`(`ID`, `owner`, `type`, `data`, `model`, `posx`, `posy`, `posz`, `rotx`, `roty`, `rotz`, `interior`, `virtualworld`) VALUES\
        ('%d',\"%s\",'%d','%d','%d','%f','%f','%f','%f','%f','%f','%d','%d')",
        sapdObjectID, FactionObject:Data[sapdObjectID][Owner], FactionObject:Data[sapdObjectID][Type], FactionObject:Data[sapdObjectID][ObjData],
        FactionObject:Data[sapdObjectID][ObjModel], FactionObject:Data[sapdObjectID][ObjX], FactionObject:Data[sapdObjectID][ObjY], FactionObject:Data[sapdObjectID][ObjZ],
        FactionObject:Data[sapdObjectID][ObjRX], FactionObject:Data[sapdObjectID][ObjRY], FactionObject:Data[sapdObjectID][ObjRZ],
        FactionObject:Data[sapdObjectID][ObjInterior], FactionObject:Data[sapdObjectID][ObjVirtualWorld]
    ));
    return 1;
}

stock FactionObject:PlaceSpeedcam(playerid) {
    return FlexPlayerDialog(playerid, "FactionObjectPlaceSpeedcam", DIALOG_STYLE_INPUT, "Speed Camera Setup", "Write a speed limit for this speed camera\nLimit: 10 to 300", "Create", "Cancel");
}

FlexDialog:FactionObjectPlaceSpeedcam(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FactionObject:Place(playerid);
    new limit;
    if (sscanf(inputtext, "d", limit) || limit < 10 || limit > 300) return FactionObject:PlaceSpeedcam(playerid);
    FactionObject:AddSpeedcam(playerid, limit);
    return FactionObject:Place(playerid);
}

stock FactionObject:PlaceRoadblock(playerid) {
    new string[sizeof RoadblockList * 64];
    for (new i; i < sizeof RoadblockList; i++) {
        strcat(string, sprintf("%d\tID: %d\n", RoadblockList[i], RoadblockList[i]));
    }
    return FlexPlayerDialog(playerid, "SapdPlaceRoadblock", IsAndroidPlayer(playerid) ? (DIALOG_STYLE_TABLIST) : (DIALOG_STYLE_PREVIEW_MODEL), "Select Object", string, "Select", "Close");
}

FlexDialog:SapdPlaceRoadblock(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FactionObject:Place(playerid);
    new modelid = strval(inputtext);
    new sapdObjectID = Iter_Free(COP_OBJECTS);
    if (sapdObjectID == INVALID_ITERATOR_SLOT) {
        AlexaMsg(playerid, "maximum limit reached for objects, try removing some other obects");
        return FactionObject:Place(playerid);
    }
    GetPlayerName(playerid, FactionObject:Data[sapdObjectID][Owner], MAX_PLAYER_NAME);
    FactionObject:Data[sapdObjectID][Type] = OBJECT_TYPE_ROADBLOCK;
    FactionObject:Data[sapdObjectID][ObjModel] = modelid;
    FactionObject:Data[sapdObjectID][ObjInterior] = GetPlayerInterior(playerid);
    FactionObject:Data[sapdObjectID][ObjVirtualWorld] = GetPlayerVirtualWorld(playerid);
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (2.0 * floatsin(-a, degrees));
    y += (2.0 * floatcos(-a, degrees));
    FactionObject:Data[sapdObjectID][ObjX] = x;
    FactionObject:Data[sapdObjectID][ObjY] = y;
    FactionObject:Data[sapdObjectID][ObjZ] = z;
    FactionObject:Data[sapdObjectID][ObjRX] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRY] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRZ] = a;
    FactionObject:Data[sapdObjectID][ObjID] = CreateDynamicObject(
        modelid, x, y, z, 0.0, 0.0, a, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );
    FactionObject:Data[sapdObjectID][ObjArea] = -1;
    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(
        sprintf("Roadblock (ID:%d)\n{FFFFFF}Placed by %s", sapdObjectID, FactionObject:Data[sapdObjectID][Owner]),
        0x3498DBFF, x, y, z + 1.35, 10.0, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );
    Iter_Add(COP_OBJECTS, sapdObjectID);
    FactionObject:InsertDB(sapdObjectID);
    return FactionObject:Place(playerid);
}

stock FactionObject:PlaceSign(playerid) {
    new string[sizeof SignList * 64];
    for (new i; i < sizeof SignList; i++) {
        strcat(string, sprintf("%d\tID: %d\n", SignList[i], SignList[i]));
    }
    return FlexPlayerDialog(
        playerid, "SapdPlaceSign", IsAndroidPlayer(playerid) ? (DIALOG_STYLE_TABLIST) : (DIALOG_STYLE_PREVIEW_MODEL),
        "Select Object", string, "Select", "Close"
    );
}

FlexDialog:SapdPlaceSign(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FactionObject:Place(playerid);
    new modelid = strval(inputtext);
    new sapdObjectID = Iter_Free(COP_OBJECTS);
    if (sapdObjectID == INVALID_ITERATOR_SLOT) {
        AlexaMsg(playerid, "maximum limit reached for objects, try removing some other obects");
        return FactionObject:Place(playerid);
    }
    GetPlayerName(playerid, FactionObject:Data[sapdObjectID][Owner], MAX_PLAYER_NAME);
    FactionObject:Data[sapdObjectID][Type] = OBJECT_TYPE_SIGN;
    FactionObject:Data[sapdObjectID][ObjModel] = modelid;
    FactionObject:Data[sapdObjectID][ObjInterior] = GetPlayerInterior(playerid);
    FactionObject:Data[sapdObjectID][ObjVirtualWorld] = GetPlayerVirtualWorld(playerid);
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += (2.0 * floatsin(-a, degrees));
    y += (2.0 * floatcos(-a, degrees));
    FactionObject:Data[sapdObjectID][ObjX] = x;
    FactionObject:Data[sapdObjectID][ObjY] = y;
    FactionObject:Data[sapdObjectID][ObjZ] = z - 1.25;
    FactionObject:Data[sapdObjectID][ObjRX] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRY] = 0.0;
    FactionObject:Data[sapdObjectID][ObjRZ] = a;
    FactionObject:Data[sapdObjectID][ObjID] = CreateDynamicObject(
        modelid, x, y, z - 1.25, 0.0, 0.0, a, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );
    FactionObject:Data[sapdObjectID][ObjArea] = -1;
    FactionObject:Data[sapdObjectID][ObjLabel] = CreateDynamic3DTextLabel(
        sprintf("Sign (ID:%d)\n{FFFFFF}Placed by %s", sapdObjectID, FactionObject:Data[sapdObjectID][Owner]),
        0x3498DBFF, x, y, z + 2.0, 10.0, _, _, _, FactionObject:Data[sapdObjectID][ObjVirtualWorld], FactionObject:Data[sapdObjectID][ObjInterior]
    );
    Iter_Add(COP_OBJECTS, sapdObjectID);
    FactionObject:InsertDB(sapdObjectID);
    return FactionObject:Place(playerid);
}