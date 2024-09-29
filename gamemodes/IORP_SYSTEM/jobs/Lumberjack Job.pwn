new Lumberjack_Menu;
enum {
    lumberjack_admin_menu = 0, lumberjack_admin_tree, lumberjack_admin_tree_edit, lumberjack_admin_tree_remove, lumberjack_admin_buyer, lumberjack_admin_buyer_create, lumberjack_admin_buyer_skin, lumberjack_admin_buyer_pos, lumberjack_admin_buyer_remove
};
#define     MAX_TREES       (100)   // tree limit
#define     MAX_LOGS        (300)   // dropped log limit
#define     MAX_BUYERS      (20)    // log buyer limit

#define     CUTTING_TIME    (8)		// required seconds to cut a tree down (Default:8)
#define     LOG_LIMIT     	(10)    // how many logs a player can load to a bobcat (if you change this, don't forget to modify LogAttachOffsets array) (Default:10)
#define     ATTACH_INDEX    (7)     // for setplayerattachedobject (Default:7)
#define     TREE_RESPAWN    (300)   // required seconds to respawn a tree (Default:300)
#define     LOG_LIFETIME	(120)   // life time of a dropped log, in seconds (Default:120)
// #define     LOG_PRICE       (50)    // price of a log (Default:50)
#define     CSAW_PRICE      (500)  	// price of a chainsaw (Default:500)

enum E_TREE {
    // loaded from db
    Float:treeX,
    Float:treeY,
    Float:treeZ,
    Float:treeRX,
    Float:treeRY,
    Float:treeRZ,
    // temp
    treeLogs,
    treeSeconds,
    bool:treeGettingCut,
    treeObjID,
    Text3D:treeLabel,
    treeTimer
}

enum E_LOG {
    // temp
    logDroppedBy[MAX_PLAYER_NAME],
        logSeconds,
        logObjID,
        logTimer,
        Text3D:logLabel
}

enum E_BUYER {
    // loaded from db
    buyerSkin,
    Float:buyerX,
    Float:buyerY,
    Float:buyerZ,
    Float:buyerA,
    // temp
    buyerActorID,
    Text3D:buyerLabel
}

new
LJJS_TreeData[MAX_TREES][E_TREE],
    LJJS_LogData[MAX_LOGS][E_LOG],
    LJJS_BuyerData[MAX_BUYERS][E_BUYER];

new
Iterator:LJJS_Trees < MAX_TREES > ,
    Iterator:LJJS_Logs < MAX_LOGS > ,
    Iterator:LJJS_Buyers < MAX_BUYERS > ;

new
LJJS_LogObjects[MAX_VEHICLES][LOG_LIMIT];

new
LJJS_CuttingTreeID[MAX_PLAYERS] = {
        -1,
        ...
    },
    LJJS_CuttingTimer[MAX_PLAYERS] = {
        -1,
        ...
    },
    PlayerBar:LJJS_CuttingBar[MAX_PLAYERS] = {
        INVALID_PLAYER_BAR_ID,
        ...
    },
    bool:LJJS_CarryingLog[MAX_PLAYERS],
    LJJS_EditingTreeID[MAX_PLAYERS] = {
        -1,
        ...
    };

new
Float:LJJS_LogAttachOffsets[LOG_LIMIT][4] = {
    {
        -0.223, -1.089, -0.230, -90.399
    },
    {
        -0.056,
        -1.091,
        -0.230,
        90.399
    },
    {
        0.116,
        -1.092,
        -0.230,
        -90.399
    },
    {
        0.293,
        -1.088,
        -0.230,
        90.399
    },
    {
        -0.123,
        -1.089,
        -0.099,
        -90.399
    },
    {
        0.043,
        -1.090,
        -0.099,
        90.399
    },
    {
        0.216,
        -1.092,
        -0.099,
        -90.399
    },
    {
        -0.033,
        -1.090,
        0.029,
        -90.399
    },
    {
        0.153,
        -1.089,
        0.029,
        90.399
    },
    {
        0.066,
        -1.091,
        0.150,
        -90.399
    }
};

// new LJJS_PointIcons[MAX_PLAYERS][MAX_RESOURCE_STORAGES][2];

// stock LJJS_DropLocationStart(playerid) {
//     if(!IsPlayerInAnyVehicle(playerid)) return 1;
//     if(LJJS_Vehicle_LogCount(GetPlayerVehicleID(playerid)) < 1) return 1;
//     foreach(new businessid:resourceStorages) {
//         if(ResourceStorageBusiness:isWoodStorageAllowed(businessid)) {
//             new Float:tpos[3];
//             ResourceStorageBusiness:GetBusinessTruckLocation(businessid, tpos[0], tpos[1], tpos[2]);
//             LJJS_PointIcons[playerid][businessid][0] = CreateDynamicMapIcon(tpos[0], tpos[1], tpos[2], 51, 0, _, _, playerid, 8000.0, MAPICON_GLOBAL);
//             LJJS_PointIcons[playerid][businessid][1] = CreateDynamicCP(tpos[0], tpos[1], tpos[2], 6.0);
//         }
//     }
//     return 1;
// }
// 
// stock LJJS_DropLocationStop(playerid) {
//     foreach(new businessid:resourceStorages) {
//         if(LJJS_PointIcons[playerid][businessid][0] != -1) DestroyDynamicMapIcon(LJJS_PointIcons[playerid][businessid][0]);
//         if(LJJS_PointIcons[playerid][businessid][1] != -1) DestroyDynamicCP(LJJS_PointIcons[playerid][businessid][1]);
//         LJJS_PointIcons[playerid][businessid][0] = -1;
//         LJJS_PointIcons[playerid][businessid][1] = -1;
//     }
// }
// 
// hook OnPlayerEnterDynamicCP(playerid, checkpointid) {
//     if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
//         // drop stop
//         new vehicleid = GetPlayerVehicleID(playerid);
//         if(LJJS_Vehicle_LogCount(vehicleid) > 0) SendClientMessageEx(playerid, 0x2ECC71FF, "WOOD:{FFFFFF} sell your wood to storage owner.");
//         LJJS_DropLocationStop(playerid);
//     }
//     return 1;
// }


LJJS_SetPlayerLookAt(playerid, Float:x, Float:y) {
    // somewhere on samp forums, couldn't find the source
    new Float:Px, Float:Py, Float:Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    Pa = floatabs(atan((y - Py) / (x - Px)));
    if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
    else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
    else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
    SetPlayerFacingAngle(playerid, Pa);
}

LJJS_GetClosestTree(playerid, Float:range = 2.0) {
    new id = -1, Float:dist = range, Float:tempdist;
    foreach(new i:LJJS_Trees) {
        tempdist = GetPlayerDistanceFromPoint(playerid, LJJS_TreeData[i][treeX], LJJS_TreeData[i][treeY], LJJS_TreeData[i][treeZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            id = i;
        }
    }

    return id;
}

LJJS_GetClosestLog(playerid, Float:range = 2.0) {
    new id = -1, Float:dist = range, Float:tempdist, Float:pos[3];
    foreach(new i:LJJS_Logs) {
        GetDynamicObjectPos(LJJS_LogData[i][logObjID], pos[0], pos[1], pos[2]);
        tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            id = i;
        }
    }

    return id;
}

LJJS_IsPlayerNearALogBuyer(playerid) {
    foreach(new i:LJJS_Buyers) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, LJJS_BuyerData[i][buyerX], LJJS_BuyerData[i][buyerY], LJJS_BuyerData[i][buyerZ])) return 1;
    }

    return 0;
}

LJJS_Player_Init(playerid) {
    LJJS_CuttingTreeID[playerid] = -1;
    LJJS_CuttingTimer[playerid] = -1;
    LJJS_CarryingLog[playerid] = false;
    LJJS_EditingTreeID[playerid] = -1;

    LJJS_CuttingBar[playerid] = CreatePlayerProgressBar(playerid, 498.0, 104.0, 113.0, 6.2, 0x61381BFF, CUTTING_TIME, 0);
    ApplyAnimation(playerid, "CHAINSAW", "null", 0.0, 0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "CARRY", "null", 0.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

LJJS_Player_ResetCutting(playerid) {
    if (!IsPlayerConnected(playerid) || LJJS_CuttingTreeID[playerid] == -1) return 0;
    new id = LJJS_CuttingTreeID[playerid];
    LJJS_TreeData[id][treeGettingCut] = false;
    if (LJJS_TreeData[id][treeSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_TreeData[id][treeLabel], E_STREAMER_COLOR, 0x2ECC71FF);

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    LJJS_CuttingTreeID[playerid] = -1;

    if (LJJS_CuttingTimer[playerid] != -1) {
        KillTimer(LJJS_CuttingTimer[playerid]);
        LJJS_CuttingTimer[playerid] = -1;
    }

    SetPlayerProgressBarValue(playerid, LJJS_CuttingBar[playerid], 0.0);
    HidePlayerProgressBar(playerid, LJJS_CuttingBar[playerid]);
    return 1;
}

LJJS_Player_GiveLog(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    LJJS_CarryingLog[playerid] = true;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, ATTACH_INDEX, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);

    SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]:{FFFFFF}You can press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to drop your log.");
    return 1;
}

LJJS_Player_DropLog(playerid, death_drop = 0) {
    if (!IsPlayerConnected(playerid) || !LJJS_CarryingLog[playerid]) return 0;
    new id = Iter_Free(LJJS_Logs);
    if (id != INVALID_ITERATOR_SLOT) {
        new Float:x, Float:y, Float:z, Float:a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, LJJS_LogData[id][logDroppedBy], MAX_PLAYER_NAME);

        if (!death_drop) {
            x += (1.0 * floatsin(-a, degrees));
            y += (1.0 * floatcos(-a, degrees));

            ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
        }

        LJJS_LogData[id][logSeconds] = LOG_LIFETIME;
        LJJS_LogData[id][logObjID] = CreateDynamicObject(19793, x, y, z - 0.9, 0.0, 0.0, a);

        format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LJJS_LogData[id][logDroppedBy], ConvertToMinutes(LOG_LIFETIME));
        LJJS_LogData[id][logLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, x, y, z - 0.7, 5.0);

        LJJS_LogData[id][logTimer] = SetTimerEx("LJJS_RemoveLog", 1000, true, "i", id);
        Iter_Add(LJJS_Logs, id);
    }

    LJJS_Player_RemoveLog(playerid);
    return 1;
}

LJJS_Player_RemoveLog(playerid) {
    if (!IsPlayerConnected(playerid) || !LJJS_CarryingLog[playerid]) return 0;
    RemovePlayerAttachedObject(playerid, ATTACH_INDEX);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    LJJS_CarryingLog[playerid] = false;
    return 1;
}

LJJS_Vehicle_LogCount(vehicleid) {
    if (GetVehicleModel(vehicleid) == 0) return 0;
    new count;
    for (new i; i < LOG_LIMIT; i++)
        if (IsValidDynamicObject(LJJS_LogObjects[vehicleid][i])) count++;
    return count;
}

LJJS_Vehicle_RemoveLogs(vehicleid) {
    if (GetVehicleModel(vehicleid) == 0) return 0;
    for (new i; i < LOG_LIMIT; i++) {
        if (IsValidDynamicObject(LJJS_LogObjects[vehicleid][i])) {
            DestroyDynamicObjectEx(LJJS_LogObjects[vehicleid][i]);
            LJJS_LogObjects[vehicleid][i] = -1;
        }
    }

    return 1;
}

LJJS_Tree_BeingEdited(id) {
    if (!Iter_Contains(LJJS_Trees, id)) return 0;
    foreach(new i:Player) if (LJJS_EditingTreeID[i] == id) return 1;
    return 0;
}

LJJS_Tree_UpdateLogLabel(id) {
    if (!Iter_Contains(LJJS_Trees, id)) return 0;
    new label[96];

    if (LJJS_TreeData[id][treeLogs] > 0) {
        format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}LJJS_Logs:{F1C40F}%d\n{FFFFFF}Use {F1C40F}/log takefromtree {FFFFFF}to take a log.", id, LJJS_TreeData[id][treeLogs]);
        UpdateDynamic3DTextLabelText(LJJS_TreeData[id][treeLabel], -1, label);
    } else {
        LJJS_TreeData[id][treeTimer] = SetTimerEx("LJJS_RespawnTree", 1000, true, "i", id);

        format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}%s", id, ConvertToMinutes(LJJS_TreeData[id][treeSeconds]));
        UpdateDynamic3DTextLabelText(LJJS_TreeData[id][treeLabel], -1, label);
    }

    return 1;
}

forward LoadLumberJackTrees();
public LoadLumberJackTrees() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, Id, label[512];
        while (Count < rows) {
            cache_get_value_name_int(Count, "ID", Id);
            cache_get_value_float(Count, "PosX", LJJS_TreeData[Id][treeX]);
            cache_get_value_float(Count, "PosY", LJJS_TreeData[Id][treeY]);
            cache_get_value_float(Count, "PosZ", LJJS_TreeData[Id][treeZ]);
            cache_get_value_float(Count, "RotX", LJJS_TreeData[Id][treeRX]);
            cache_get_value_float(Count, "RotY", LJJS_TreeData[Id][treeRY]);
            cache_get_value_float(Count, "RotZ", LJJS_TreeData[Id][treeRZ]);

            LJJS_TreeData[Id][treeObjID] = CreateDynamicObject(657, LJJS_TreeData[Id][treeX], LJJS_TreeData[Id][treeY], LJJS_TreeData[Id][treeZ], LJJS_TreeData[Id][treeRX], LJJS_TreeData[Id][treeRY], LJJS_TreeData[Id][treeRZ]);

            format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", Id);
            LJJS_TreeData[Id][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, LJJS_TreeData[Id][treeX], LJJS_TreeData[Id][treeY], LJJS_TreeData[Id][treeZ] + 1.5, 5.0);

            Iter_Add(LJJS_Trees, Id);
            Count++;
        }
    }
    printf("  [LumberJack Job System] Loaded %d Tree's Data.", rows);
    return 1;
}

forward LoadLumberJackBuyers();
public LoadLumberJackBuyers() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, Id, label[512];
        while (Count < rows) {
            cache_get_value_name_int(Count, "ID", Id);
            cache_get_value_name_int(Count, "Skin", LJJS_BuyerData[Id][buyerSkin]);
            cache_get_value_float(Count, "PosX", LJJS_BuyerData[Id][buyerX]);
            cache_get_value_float(Count, "PosY", LJJS_BuyerData[Id][buyerY]);
            cache_get_value_float(Count, "PosZ", LJJS_BuyerData[Id][buyerZ]);
            cache_get_value_float(Count, "PosA", LJJS_BuyerData[Id][buyerA]);

            LJJS_BuyerData[Id][buyerActorID] = CreateDynamicActor(LJJS_BuyerData[Id][buyerSkin], LJJS_BuyerData[Id][buyerX], LJJS_BuyerData[Id][buyerY], LJJS_BuyerData[Id][buyerZ], LJJS_BuyerData[Id][buyerA], .worldid = 0);
            SetDynamicActorInvulnerable(LJJS_BuyerData[Id][buyerActorID], 1);

            format(label, sizeof(label), "Wood Man (%d)\n\n{FFFFFF}Use {F1C40F}/chainsaw {FFFFFF}to buy a chainsaw for {2ECC71}$%s.", Id, FormatCurrency(CSAW_PRICE));
            LJJS_BuyerData[Id][buyerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, LJJS_BuyerData[Id][buyerX], LJJS_BuyerData[Id][buyerY], LJJS_BuyerData[Id][buyerZ] + 0.25, 5.0);

            Iter_Add(LJJS_Buyers, Id);
            Count++;
        }
    }
    printf("  [LumberJack Job System] Loaded %d Buyer's Data.", rows);
    return 1;
}

hook OnGameModeInit() {
    Lumberjack_Menu = Dialog:GetFreeID();
    for (new i; i < MAX_TREES; i++) {
        LJJS_TreeData[i][treeObjID] = LJJS_TreeData[i][treeTimer] = -1;
        LJJS_TreeData[i][treeLabel] = Text3D:  - 1;
    }

    for (new i; i < MAX_LOGS; i++) {
        LJJS_LogData[i][logObjID] = LJJS_LogData[i][logTimer] = -1;
        LJJS_LogData[i][logLabel] = Text3D:  - 1;
    }

    for (new i; i < MAX_BUYERS; i++) {
        LJJS_BuyerData[i][buyerActorID] = -1;
        LJJS_BuyerData[i][buyerLabel] = Text3D:  - 1;
    }

    for (new i; i < MAX_VEHICLES; i++)
        for (new x; x < LOG_LIMIT; x++) LJJS_LogObjects[i][x] = -1;

    foreach(new i:Player) LJJS_Player_Init(i);

    new treesqery[512], buyyerquery[512];
    strcat(treesqery, "CREATE TABLE IF NOT EXISTS `lumberjackTrees` ( \
	  `ID` int(3) NOT NULL, \
	  `PosX` float NOT NULL, \
	  `PosY` float NOT NULL, \
	  `PosZ` float NOT NULL, \
	  `RotX` float NOT NULL, \
	  `RotY` float NOT NULL, \
	  `RotZ` float NOT NULL, \
	  PRIMARY KEY (`ID`) \
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
    mysql_tquery(Database, treesqery);
    mysql_tquery(Database, "SELECT * FROM lumberjackTrees", "LoadLumberJackTrees", "");
    strcat(buyyerquery, "CREATE TABLE IF NOT EXISTS `lumberjackBuyers` ( \
	  `ID` int(3) NOT NULL, \
	  `Skin` int(11) NOT NULL, \
	  `PosX` float NOT NULL, \
	  `PosY` float NOT NULL, \
	  `PosZ` float NOT NULL, \
	  `PosA` float NOT NULL, \
	  PRIMARY KEY (`ID`) \
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
    mysql_tquery(Database, buyyerquery);
    mysql_tquery(Database, "SELECT * FROM lumberjackBuyers", "LoadLumberJackBuyers", "");

    return 1;
}

hook OnGameModeExit() {
    foreach(new i:LJJS_Buyers) DestroyDynamicActor(LJJS_BuyerData[i][buyerActorID]);
    foreach(new i:Player) {
        LJJS_Player_ResetCutting(i);
        LJJS_Player_RemoveLog(i);

        DestroyPlayerProgressBar(i, LJJS_CuttingBar[i]);
    }

    print("  [Lumberjack] Unloaded.");
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    LJJS_Player_Init(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    // LJJS_DropLocationStop(playerid);
    LJJS_Player_ResetCutting(playerid);
    LJJS_Player_RemoveLog(playerid);

    LJJS_EditingTreeID[playerid] = -1;
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    LJJS_Vehicle_RemoveLogs(vehicleid);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    LJJS_Vehicle_RemoveLogs(vehicleid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    LJJS_Player_ResetCutting(playerid);
    LJJS_Player_DropLog(playerid, 1);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate != PLAYER_STATE_WASTED) {
        LJJS_Player_ResetCutting(playerid);
        LJJS_Player_RemoveLog(playerid);
    }

    // if(newstate == PLAYER_STATE_DRIVER) LJJS_DropLocationStart(playerid);
    // if(newstate == PLAYER_STATE_ONFOOT) LJJS_DropLocationStop(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO)) {
        // drop or load
        if (LJJS_CarryingLog[playerid]) {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0);
            if (IsValidVehicle(vehicleid) && GetVehicleModel(vehicleid) == 422) {
                if (!StaticVehicle:IsValidID(StaticVehicle:GetID(vehicleid))) {
                    SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}this vehicle is not supported for wood job");
                    return ~1;
                }

                if (TrailerStorage:GetResourceTypesLoaded(vehicleid) >= 2 || TrailerStorage:GetResourceByName(vehicleid, "Wood") >= 30) {
                    SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't load any more logs to this vehicle.");
                    return ~1;
                }

                for (new i; i < LOG_LIMIT; i++) {
                    if (!IsValidDynamicObject(LJJS_LogObjects[vehicleid][i])) {
                        LJJS_LogObjects[vehicleid][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                        AttachDynamicObjectToVehicle(LJJS_LogObjects[vehicleid][i], vehicleid, LJJS_LogAttachOffsets[i][0], LJJS_LogAttachOffsets[i][1], LJJS_LogAttachOffsets[i][2], 0.0, 0.0, LJJS_LogAttachOffsets[i][3]);
                        break;
                    }
                }

                TrailerStorage:IncreaseResourceByName(vehicleid, "Wood", 1);
                Streamer_Update(playerid);
                LJJS_Player_RemoveLog(playerid);
                SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Loaded a log.");
                GameTextForPlayer(playerid, "Log ~g~loaded", 3000, 3);
            } else {
                LJJS_Player_DropLog(playerid);
            }
            return ~1;
        }

        // take from ground
        new idx = LJJS_GetClosestLog(playerid);
        if (idx != -1) {
            LJJS_LogData[idx][logSeconds] = 1;
            LJJS_RemoveLog(idx);

            LJJS_Player_GiveLog(playerid);
            SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from ground.");
            GameTextForPlayer(playerid, "Log ~g~taken", 3000, 3);
            return ~1;
        }

        // take from a cut tree
        new idy = LJJS_GetClosestTree(playerid);
        if (idy != -1 && LJJS_TreeData[idy][treeSeconds] > 0 && LJJS_TreeData[idy][treeLogs] > 0) {
            LJJS_TreeData[idy][treeLogs]--;
            LJJS_Tree_UpdateLogLabel(idy);

            LJJS_Player_GiveLog(playerid);
            SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from the cut tree.");
            GameTextForPlayer(playerid, "Log ~g~taken", 3000, 3);
            return ~1;
        }

        // take from a bobcat
        new idz = GetNearestVehicleToPlayer(playerid, 3.0);
        if (GetVehicleModel(idz) == 422 && LJJS_Vehicle_LogCount(idz) > 0) {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(idz, x, y, z);
            for (new i = (LOG_LIMIT - 1); i >= 0; i--) {
                if (IsValidDynamicObject(LJJS_LogObjects[idz][i])) {
                    DestroyDynamicObjectEx(LJJS_LogObjects[idz][i]);
                    LJJS_LogObjects[idz][i] = -1;
                    TrailerStorage:IncreaseResourceByName(idz, "Wood", -1);
                    break;
                }
            }

            Streamer_Update(playerid);
            LJJS_Player_GiveLog(playerid);
            SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from the Bobcat.");
            GameTextForPlayer(playerid, "Log ~g~taken", 3000, 3);
            return ~1;
        }

        // cut tree
        if (LJJS_CuttingTreeID[playerid] == -1 && !LJJS_CarryingLog[playerid]) {
            new id = LJJS_GetClosestTree(playerid);

            if (id != -1) {
                if (!GetPlayerRPMode(playerid)) {
                    GameTextForPlayer(playerid, "Enable ~r~fight mode~w~~n~/p > fight mode", 3000, 3);
                    return ~1;
                }

                if (GetPlayerWeapon(playerid) != WEAPON_CHAINSAW) {
                    GameTextForPlayer(playerid, "use ~r~chainsaw~w~ to cut tree", 3000, 3);
                    return ~1;
                }

                if (!LJJS_Tree_BeingEdited(id) && !LJJS_TreeData[id][treeGettingCut] && LJJS_TreeData[id][treeSeconds] < 1) {
                    LJJS_SetPlayerLookAt(playerid, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY]);

                    Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_TreeData[id][treeLabel], E_STREAMER_COLOR, -1);
                    LJJS_CuttingTimer[playerid] = SetTimerEx("LJJS_CutTree", 1000, true, "i", playerid);
                    LJJS_CuttingTreeID[playerid] = id;
                    SetPlayerProgressBarValue(playerid, LJJS_CuttingBar[playerid], 0.0);
                    ShowPlayerProgressBar(playerid, LJJS_CuttingBar[playerid]);
                    TogglePlayerControllable(playerid, 0);
                    SetPlayerArmedWeapon(playerid, WEAPON_CHAINSAW);
                    ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);

                    LJJS_TreeData[id][treeGettingCut] = true;
                    return ~1;
                }
            }
        }
    }

    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (LJJS_EditingTreeID[playerid] != -1 && Iter_Contains(LJJS_Trees, LJJS_EditingTreeID[playerid])) {
        if (response == EDIT_RESPONSE_FINAL) {
            new id = LJJS_EditingTreeID[playerid];
            LJJS_TreeData[id][treeX] = x;
            LJJS_TreeData[id][treeY] = y;
            LJJS_TreeData[id][treeZ] = z;
            LJJS_TreeData[id][treeRX] = rx;
            LJJS_TreeData[id][treeRY] = ry;
            LJJS_TreeData[id][treeRZ] = rz;

            SetDynamicObjectPos(objectid, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ]);
            SetDynamicObjectRot(objectid, LJJS_TreeData[id][treeRX], LJJS_TreeData[id][treeRY], LJJS_TreeData[id][treeRZ]);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_TreeData[id][treeLabel], E_STREAMER_X, LJJS_TreeData[id][treeX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_TreeData[id][treeLabel], E_STREAMER_Y, LJJS_TreeData[id][treeY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_TreeData[id][treeLabel], E_STREAMER_Z, LJJS_TreeData[id][treeZ] + 1.5);

            LJJS_EditingTreeID[playerid] = -1;

            new query[512];
            mysql_format(Database, query, sizeof(query), "UPDATE `lumberjackTrees` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`RotX`='%f',`RotY`='%f',`RotZ`='%f' WHERE `ID`='%d'", x, y, z, rx, ry, rz, id);
            mysql_tquery(Database, query);
        }

        if (response == EDIT_RESPONSE_CANCEL) {
            new id = LJJS_EditingTreeID[playerid];
            SetDynamicObjectPos(objectid, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ]);
            SetDynamicObjectRot(objectid, LJJS_TreeData[id][treeRX], LJJS_TreeData[id][treeRY], LJJS_TreeData[id][treeRZ]);
            LJJS_EditingTreeID[playerid] = -1;
        }
    }

    return 1;
}

forward LJJS_CutTree(playerid);
public LJJS_CutTree(playerid) {
    if (LJJS_CuttingTreeID[playerid] != -1) {
        new id = LJJS_CuttingTreeID[playerid], Float:value = GetPlayerProgressBarValue(playerid, LJJS_CuttingBar[playerid]) + 1.0;

        if (value >= CUTTING_TIME) {
            LJJS_Player_ResetCutting(playerid);
            MoveDynamicObject(LJJS_TreeData[id][treeObjID], LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ] + 0.03, 0.025, LJJS_TreeData[id][treeRX], LJJS_TreeData[id][treeRY] - 80.0, LJJS_TreeData[id][treeRZ]);

            LJJS_TreeData[id][treeLogs] = 5;
            LJJS_TreeData[id][treeSeconds] = TREE_RESPAWN;
            LJJS_Tree_UpdateLogLabel(id);
        } else {
            SetPlayerProgressBarValue(playerid, LJJS_CuttingBar[playerid], value);
        }
    }

    return 1;
}

forward LJJS_RespawnTree(id);
public LJJS_RespawnTree(id) {
    new label[96];
    if (LJJS_TreeData[id][treeSeconds] > 1) {
        LJJS_TreeData[id][treeSeconds]--;

        format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}%s", id, ConvertToMinutes(LJJS_TreeData[id][treeSeconds]));
        UpdateDynamic3DTextLabelText(LJJS_TreeData[id][treeLabel], -1, label);
    } else if (LJJS_TreeData[id][treeSeconds] == 1) {
        KillTimer(LJJS_TreeData[id][treeTimer]);

        LJJS_TreeData[id][treeLogs] = 0;
        LJJS_TreeData[id][treeSeconds] = 0;
        LJJS_TreeData[id][treeTimer] = -1;

        SetDynamicObjectPos(LJJS_TreeData[id][treeObjID], LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ]);
        SetDynamicObjectRot(LJJS_TreeData[id][treeObjID], LJJS_TreeData[id][treeRX], LJJS_TreeData[id][treeRY], LJJS_TreeData[id][treeRZ]);

        format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", id);
        UpdateDynamic3DTextLabelText(LJJS_TreeData[id][treeLabel], 0x2ECC71FF, label);
    }

    return 1;
}

forward LJJS_RemoveLog(id);
public LJJS_RemoveLog(id) {
    if (!Iter_Count(LJJS_Logs, id)) return 1;

    if (LJJS_LogData[id][logSeconds] > 1) {
        LJJS_LogData[id][logSeconds]--;

        new label[128];
        format(label, sizeof(label), "Log (%d)\n\n{FFFFFF}Dropped By {F1C40F}%s\n{FFFFFF}%s\nUse {F1C40F}/log take {FFFFFF}to take it.", id, LJJS_LogData[id][logDroppedBy], ConvertToMinutes(LJJS_LogData[id][logSeconds]));
        UpdateDynamic3DTextLabelText(LJJS_LogData[id][logLabel], 0xF1C40FFF, label);
    } else if (LJJS_LogData[id][logSeconds] == 1) {
        KillTimer(LJJS_LogData[id][logTimer]);
        DestroyDynamicObjectEx(LJJS_LogData[id][logObjID]);
        DestroyDynamic3DTextLabel(LJJS_LogData[id][logLabel]);

        LJJS_LogData[id][logTimer] = -1;
        LJJS_LogData[id][logObjID] = -1;
        LJJS_LogData[id][logLabel] = Text3D:  - 1;

        Iter_Remove(LJJS_Logs, id);
    }

    return 1;
}

// Player Commands
CMD:chainsaw(playerid, const params[]) {
    if (Faction:IsPlayerSigned(playerid)) return SendClientMessageEx(playerid, 0xE88732FF, "[Error]: {FFFFFF}Sign off from your faction to work on this job");
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't use this command in a vehicle.");
    if (!LJJS_IsPlayerNearALogBuyer(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a Log Buyer.");
    if (GetPlayerCash(playerid) < CSAW_PRICE) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You don't have enough money.");
    vault:PlayerVault(playerid, -CSAW_PRICE, sprintf("Job:Lumberjack: charged -$%s for chainsaw", FormatCurrency(CSAW_PRICE)), Vault_ID_Government, CSAW_PRICE, sprintf("%s charged for chainsaw", GetPlayerNameEx(playerid)));
    GivePlayerWeaponEx(playerid, WEAPON_CHAINSAW, 1);

    new string[64];
    format(string, sizeof(string), "[LUMBERJACK]: {FFFFFF}Bought a chainsaw for {2ECC71}$%s.", FormatCurrency(CSAW_PRICE));
    SendClientMessageEx(playerid, 0x3498DBFF, string);
    return 1;
}

forward OnWoodloadinTrailer(trailerid, amount);
public OnWoodloadinTrailer(trailerid, amount) {
    new count = amount;
    if (LJJS_Vehicle_LogCount(trailerid) >= LOG_LIMIT) return 1;
    for (new i = 0; i < LOG_LIMIT; i++) {
        if (!IsValidDynamicObject(LJJS_LogObjects[trailerid][i])) {
            LJJS_LogObjects[trailerid][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(LJJS_LogObjects[trailerid][i], trailerid, LJJS_LogAttachOffsets[i][0], LJJS_LogAttachOffsets[i][1], LJJS_LogAttachOffsets[i][2], 0.0, 0.0, LJJS_LogAttachOffsets[i][3]);
            count--;
            if (count == 0) break;
        }
    }
    return 1;
}

forward OnWoodUnloadFromTrailer(trailerid, amount);
public OnWoodUnloadFromTrailer(trailerid, amount) {
    new count = amount;
    if (LJJS_Vehicle_LogCount(trailerid) < 1) return 1;
    for (new i = (LOG_LIMIT - 1); i >= 0; i--) {
        if (IsValidDynamicObject(LJJS_LogObjects[trailerid][i])) {
            DestroyDynamicObjectEx(LJJS_LogObjects[trailerid][i]);
            LJJS_LogObjects[trailerid][i] = -1;
            count--;
            if (count == 0) break;
        }
    }
    return 1;
}

CMD:log(playerid, const params[]) {
    if (Faction:IsPlayerSigned(playerid)) return SendClientMessageEx(playerid, 0xE88732FF, "[Error]: {FFFFFF}Sign off from your faction to work on this job");
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't use this command in a vehicle.");
    if (isnull(params)) return SendClientMessageEx(playerid, 0xE88732FF, "{db6600}[Usage]:{FFFFEE}/log [load/take/takefromcar/takefromtree]");

    if (!strcmp(params, "load", true)) {
        // loading to a bobcat
        if (!LJJS_CarryingLog[playerid]) {
            return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not carrying a log.");
        }

        new id = GetNearestVehicleToPlayer(playerid);
        if (GetVehicleModel(id) != 422) {
            return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a Bobcat.");
        }

        if (!StaticVehicle:IsValidID(StaticVehicle:GetID(id))) {
            return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}this vehicle is not supported for wood job");
        }

        new Float:x, Float:y, Float:z;
        //GetVehicleBoot(id, x, y, z);
        GetVehiclePos(id, x, y, z);

        if (!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) {
            return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a Bobcat's back.");
        }

        if (TrailerStorage:GetResourceTypesLoaded(id) >= 2 || TrailerStorage:GetResourceByName(id, "Wood") >= 30) {
            return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't load any more logs to this vehicle.");
        }

        for (new i; i < LOG_LIMIT; i++) {
            if (!IsValidDynamicObject(LJJS_LogObjects[id][i])) {
                LJJS_LogObjects[id][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(LJJS_LogObjects[id][i], id, LJJS_LogAttachOffsets[i][0], LJJS_LogAttachOffsets[i][1], LJJS_LogAttachOffsets[i][2], 0.0, 0.0, LJJS_LogAttachOffsets[i][3]);
                break;
            }
        }

        TrailerStorage:IncreaseResourceByName(id, "Wood", 1);
        Streamer_Update(playerid);
        LJJS_Player_RemoveLog(playerid);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Loaded a log.");
        // done
    } else if (!strcmp(params, "take")) {
        // taking from ground
        if (LJJS_CarryingLog[playerid]) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already carrying a log.");
        new id = LJJS_GetClosestLog(playerid);
        if (id == -1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a log.");
        LJJS_LogData[id][logSeconds] = 1;
        LJJS_RemoveLog(id);

        LJJS_Player_GiveLog(playerid);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from ground.");
        // done
    } else if (!strcmp(params, "takefromcar")) {
        // taking from a bobcat
        if (LJJS_CarryingLog[playerid]) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already carrying a log.");
        new id = GetNearestVehicleToPlayer(playerid);
        if (GetVehicleModel(id) != 422) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a Bobcat.");
        new Float:x, Float:y, Float:z;
        //GetVehicleBoot(id, x, y, z);
        GetVehiclePos(id, x, y, z);
        if (!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a Bobcat's back.");
        if (LJJS_Vehicle_LogCount(id) < 1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}This Bobcat doesn't have any logs.");
        for (new i = (LOG_LIMIT - 1); i >= 0; i--) {
            if (IsValidDynamicObject(LJJS_LogObjects[id][i])) {
                DestroyDynamicObjectEx(LJJS_LogObjects[id][i]);
                LJJS_LogObjects[id][i] = -1;
                TrailerStorage:IncreaseResourceByName(id, "Wood", -1);
                break;
            }
        }

        Streamer_Update(playerid);
        LJJS_Player_GiveLog(playerid);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from the Bobcat.");
        // done
    } else if (!strcmp(params, "takefromtree")) {
        // taking from a cut tree
        if (LJJS_CarryingLog[playerid]) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already carrying a log.");
        new id = LJJS_GetClosestTree(playerid);
        if (id == -1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near a tree.");
        if (LJJS_TreeData[id][treeSeconds] < 1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}This tree isn't cut.");
        if (LJJS_TreeData[id][treeLogs] < 1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}This tree doesn't have any logs.");
        LJJS_TreeData[id][treeLogs]--;
        LJJS_Tree_UpdateLogLabel(id);

        LJJS_Player_GiveLog(playerid);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You've taken a log from the cut tree.");
        // done
    }
    return 1;
}
// Admin Commands - LJJS_Trees
stock lumberjack_admin_panel(playerid) {
    return ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_menu, DIALOG_STYLE_LIST, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Manage Tree\nManage Buyer", "Select", "Close");
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, inputtext[], extraid, payload[]) {
    if (dialogid != Lumberjack_Menu) return 1;
    if (offsetid == lumberjack_admin_menu) {
        if (!response) return ~1;
        if (!strcmp("Manage Tree", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree, DIALOG_STYLE_LIST, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Create Tree\nEdit Tree\nRemove Tree", "Select", "Close");
            return ~1;
        }
        if (!strcmp("Manage Buyer", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer, DIALOG_STYLE_LIST, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Create Buyer\nChange Buyer Skin\nSet Buyer Position\nRemove Buyer", "Select", "Close");
            return ~1;
        }
        return ~1;
    }
    if (offsetid == lumberjack_admin_tree) {
        if (!response) return 1;
        if (!strcmp("Create Tree", inputtext)) {
            new id = Iter_Free(LJJS_Trees);
            if (id == INVALID_ITERATOR_SLOT) {
                SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't add any more trees.");
                return ~1;
            }
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            x += (3.0 * floatsin(-a, degrees));
            y += (3.0 * floatcos(-a, degrees));
            z -= 1.0;
            LJJS_TreeData[id][treeX] = x;
            LJJS_TreeData[id][treeY] = y;
            LJJS_TreeData[id][treeZ] = z;
            LJJS_TreeData[id][treeRX] = LJJS_TreeData[id][treeRY] = LJJS_TreeData[id][treeRZ] = 0.0;
            LJJS_TreeData[id][treeObjID] = CreateDynamicObject(657, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ], LJJS_TreeData[id][treeRX], LJJS_TreeData[id][treeRY], LJJS_TreeData[id][treeRZ]);
            new label[96];
            format(label, sizeof(label), "Tree (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cut down.", id);
            LJJS_TreeData[id][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ] + 1.5, 5.0);
            Iter_Add(LJJS_Trees, id);
            new query[512];
            mysql_format(Database, query, sizeof(query), "INSERT INTO `lumberjackTrees`(`ID`, `PosX`, `PosY`, `PosZ`, `RotX`, `RotY`, `RotZ`) VALUES ('%d','%f','%f','%f','%f','%f','%f')", id, x, y, z, 0, 0, 0);
            mysql_tquery(Database, query);
            LJJS_EditingTreeID[playerid] = id;
            EditDynamicObject(playerid, LJJS_TreeData[id][treeObjID]);
            SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Tree created.");
            SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}You can edit it right now, or cancel editing and edit it some other time.");
            return ~1;
        }
        if (!strcmp("Edit Tree", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_edit, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID", "Edit", "Close");
            return ~1;
        }
        if (!strcmp("Remove Tree", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID", "Remove", "Close");
            return ~1;
        }
        return ~1;
    }
    if (offsetid == lumberjack_admin_tree_edit) {
        if (!response) return ~1;
        if (LJJS_EditingTreeID[playerid] != -1) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already editing a tree.");
            return ~1;
        }
        new id;
        if (sscanf(inputtext, "i", id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_edit, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID", "Edit", "Close");
            return ~1;
        }
        if (!Iter_Contains(LJJS_Trees, id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_edit, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID\nInvalidID", "Edit", "Close");
            return ~1;
        }
        if (LJJS_TreeData[id][treeGettingCut]) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't edit specified tree because its getting cut down.");
            return ~1;
        }
        if (!IsPlayerInRangeOfPoint(playerid, 30.0, LJJS_TreeData[id][treeX], LJJS_TreeData[id][treeY], LJJS_TreeData[id][treeZ])) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near the tree you want to edit.");
            return ~1;
        }
        LJJS_EditingTreeID[playerid] = id;
        EditDynamicObject(playerid, LJJS_TreeData[id][treeObjID]);
        return ~1;
    }
    if (offsetid == lumberjack_admin_tree_remove) {
        if (!response) return ~1;
        new id;
        if (sscanf(inputtext, "i", id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID", "Remove", "Close");
            return ~1;
        }
        if (!Iter_Contains(LJJS_Trees, id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_tree_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter TreeID\nInvalidID", "Remove", "Close");
            return ~1;
        }
        if (LJJS_TreeData[id][treeGettingCut]) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't remove specified tree because its getting cut down.");
            return ~1;
        }
        if (LJJS_Tree_BeingEdited(id)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't remove specified tree because its being edited.");
            return ~1;
        }
        DestroyDynamicObjectEx(LJJS_TreeData[id][treeObjID]);
        DestroyDynamic3DTextLabel(LJJS_TreeData[id][treeLabel]);
        if (LJJS_TreeData[id][treeTimer] != -1) KillTimer(LJJS_TreeData[id][treeTimer]);
        LJJS_TreeData[id][treeLogs] = LJJS_TreeData[id][treeSeconds] = 0;
        LJJS_TreeData[id][treeObjID] = LJJS_TreeData[id][treeTimer] = -1;
        LJJS_TreeData[id][treeLabel] = Text3D:  - 1;
        Iter_Remove(LJJS_Trees, id);
        new query[512];
        mysql_format(Database, query, sizeof(query), "DELETE FROM `lumberjackTrees` WHERE `ID`='%d'", id);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Tree removed.");
        return ~1;
    }
    if (offsetid == lumberjack_admin_buyer) {
        if (!response) return ~1;
        if (!strcmp("Create Buyer", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_create, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter SkinID", "Create", "Close");
            return ~1;
        }
        if (!strcmp("Change Buyer Skin", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_skin, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter [BuyerID] [SkinID]", "Change", "Close");
            return ~1;
        }
        if (!strcmp("Set Buyer Position", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_pos, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID", "Submit", "Close");
            return ~1;
        }
        if (!strcmp("Remove Buyer", inputtext)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID", "Remove", "Close");
            return ~1;
        }
        return ~1;
    }
    if (offsetid == lumberjack_admin_buyer_create) {
        if (!response) return ~1;
        new skin;
        if (sscanf(inputtext, "i", skin)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_create, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter SkinID", "Create", "Close");
            return ~1;
        }
        if (!(0 <= skin <= 311)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_create, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter SkinID\nInvalid SkinID", "Create", "Close");
            return ~1;
        }
        new id = Iter_Free(LJJS_Buyers);
        if (id == INVALID_ITERATOR_SLOT) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't add any more log buyers.");
            return ~1;
        }
        GetPlayerPos(playerid, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ]);
        GetPlayerFacingAngle(playerid, LJJS_BuyerData[id][buyerA]);
        LJJS_BuyerData[id][buyerActorID] = CreateDynamicActor(skin, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ], LJJS_BuyerData[id][buyerA], .worldid = 0);
        SetDynamicActorInvulnerable(LJJS_BuyerData[id][buyerActorID], 1);
        new label[172];
        format(label, sizeof(label), "Wood Man (%d)\n\n{FFFFFF}Use {F1C40F}/chainsaw {FFFFFF}to buy a chainsaw for {2ECC71}$%s.", id, FormatCurrency(CSAW_PRICE));
        LJJS_BuyerData[id][buyerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ] + 0.25, 5.0);
        Iter_Add(LJJS_Buyers, id);
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO `lumberjackBuyers`(`ID`, `Skin`, `PosX`, `PosY`, `PosZ`, `PosA`) VALUES ('%d','%d','%f','%f','%f','%f')", id, skin, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ], LJJS_BuyerData[id][buyerA]);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Buyer created.");
        SetPlayerPosEx(playerid, LJJS_BuyerData[id][buyerX] + (1.5 * floatsin(-LJJS_BuyerData[id][buyerA], degrees)), LJJS_BuyerData[id][buyerY] + (1.5 * floatcos(-LJJS_BuyerData[id][buyerA], degrees)), LJJS_BuyerData[id][buyerZ]);
        return 1;
    }
    if (offsetid == lumberjack_admin_buyer_skin) {
        if (!response) return ~1;
        new id, skin;
        if (sscanf(inputtext, "ii", id, skin)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_skin, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter [BuyerID] [SkinID]", "Change", "Close");
            return ~1;
        }
        if (!Iter_Contains(LJJS_Buyers, id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_skin, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter [BuyerID] [SkinID]\nInvalid BuyerID", "Change", "Close");
            return ~1;
        }
        if (!(0 <= skin <= 311)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_skin, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter [BuyerID] [SkinID]\nInvalid SkinID", "Change", "Close");
            return ~1;
        }
        LJJS_BuyerData[id][buyerSkin] = skin;
        DestroyDynamicActor(LJJS_BuyerData[id][buyerActorID]);
        LJJS_BuyerData[id][buyerActorID] = CreateDynamicActor(skin, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ], LJJS_BuyerData[id][buyerA], .worldid = 0);
        SetDynamicActorInvulnerable(LJJS_BuyerData[id][buyerActorID], 1);
        new query[512];
        mysql_format(Database, query, sizeof(query), "UPDATE `lumberjackBuyers` SET `Skin`='%d' WHERE `ID`='%d'", skin, id);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Buyer updated.");
        return 1;
    }
    if (offsetid == lumberjack_admin_buyer_pos) {
        if (!response) return ~1;
        new id;
        if (sscanf(inputtext, "i", id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_pos, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID", "Submit", "Close");
            return ~1;
        }
        if (!Iter_Contains(LJJS_Buyers, id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_pos, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID\nInvalid BuyerID", "Submit", "Close");
            return ~1;
        }
        GetPlayerPos(playerid, LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ]);
        GetPlayerFacingAngle(playerid, LJJS_BuyerData[id][buyerA]);
        DestroyDynamicActor(LJJS_BuyerData[id][buyerActorID]);
        LJJS_BuyerData[id][buyerActorID] = CreateDynamicActor(LJJS_BuyerData[id][buyerSkin], LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ], LJJS_BuyerData[id][buyerA], .worldid = 0);
        SetDynamicActorInvulnerable(LJJS_BuyerData[id][buyerActorID], 1);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_BuyerData[id][buyerLabel], E_STREAMER_X, LJJS_BuyerData[id][buyerX]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_BuyerData[id][buyerLabel], E_STREAMER_Y, LJJS_BuyerData[id][buyerY]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, LJJS_BuyerData[id][buyerLabel], E_STREAMER_Z, LJJS_BuyerData[id][buyerZ] + 0.25);
        new query[512];
        mysql_format(Database, query, sizeof(query), "UPDATE `lumberjackBuyers` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosA`='%f' WHERE `ID`='%d'", LJJS_BuyerData[id][buyerX], LJJS_BuyerData[id][buyerY], LJJS_BuyerData[id][buyerZ], LJJS_BuyerData[id][buyerA], id);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Buyer updated.");
        SetPlayerPosEx(playerid, LJJS_BuyerData[id][buyerX] + (1.5 * floatsin(-LJJS_BuyerData[id][buyerA], degrees)), LJJS_BuyerData[id][buyerY] + (1.5 * floatcos(-LJJS_BuyerData[id][buyerA], degrees)), LJJS_BuyerData[id][buyerZ]);
        return 1;
    }
    if (offsetid == lumberjack_admin_buyer_remove) {
        if (!response) return ~1;
        new id;
        if (sscanf(inputtext, "i", id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID", "Remove", "Close");
            return ~1;
        }
        if (!Iter_Contains(LJJS_Buyers, id)) {
            ShowPlayerDialogEx(playerid, Lumberjack_Menu, lumberjack_admin_buyer_remove, DIALOG_STYLE_INPUT, "{4286f4}[Lumberjack System]:{FFFFEE}Admin Control Panel", "Enter BuyerID\nInvalid BuyerID", "Remove", "Close");
            return ~1;
        }
        DestroyDynamicActor(LJJS_BuyerData[id][buyerActorID]);
        DestroyDynamic3DTextLabel(LJJS_BuyerData[id][buyerLabel]);
        LJJS_BuyerData[id][buyerActorID] = -1;
        LJJS_BuyerData[id][buyerLabel] = Text3D:  - 1;
        Iter_Remove(LJJS_Buyers, id);
        new query[512];
        mysql_format(Database, query, sizeof(query), "DELETE FROM `lumberjackBuyers` WHERE `ID`='%d'", id);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[LUMBERJACK]: {FFFFFF}Buyer removed.");
        return ~1;
    }
    return ~1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Lumberjack System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (!strcmp("Lumberjack System", inputtext)) lumberjack_admin_panel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "lumberjack system") || !IsPlayerMasterAdmin(playerid)) return 1;
    lumberjack_admin_panel(playerid);
    return ~1;
}