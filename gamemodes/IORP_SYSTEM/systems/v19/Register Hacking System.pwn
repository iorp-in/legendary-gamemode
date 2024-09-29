#define     MAX_CREGISTER   (50) 	// limit of cash registers
#define     CREG_MIN_MONEY  (1000)   // min. amount of money stolen from a cash register (Default:250)
#define     CREG_MAX_MONEY  (5000)  // max. amount of money stolen from a cash register (Default:1000)
#define     CREG_RESPAWN    (3600)   // time required for a cash register to become robbable again, in seconds (Default:180)
#define     CREG_ROBTIME    (30)     // time required to rob a cash register, in seconds (Default:5)

enum E_CREGISTER {
    // saved
    Float:regX,
    Float:regY,
    Float:regZ,
    Float:regRX,
    Float:regRY,
    Float:regRZ,
    regInt,
    regVW,
    // temp
    regTimeLeft,
    regObj,
    regPickup,
    regTimer,
    Text3D:regLabel,
    bool:regExists
}

new CashRegData[MAX_CREGISTER][E_CREGISTER];

new RobberyTimeLeft[MAX_PLAYERS],
    RobberyTimer[MAX_PLAYERS] = {-1, ... },
    EditingRegisterID[MAX_PLAYERS] = {-1, ... },
    PlayerText:CRegRobberyText[MAX_PLAYERS] = { PlayerText:  - 1, ... };


RegisterHacking:SetPlayerLookAt(playerid, Float:x, Float:y) {
    // somewhere on samp forums, couldn't find the source
    new Float:Px, Float:Py, Float:Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    Pa = floatabs(atan((y - Py) / (x - Px)));
    if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
    else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
    else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
    // nan check
    if (Pa == Pa) SetPlayerFacingAngle(playerid, Pa);
}

GetClosestRegister(playerid, Float:range = 1.5) {
    new id = -1, Float:dist = range, Float:tempdist;
    for (new i; i < MAX_CREGISTER; i++) {
        if (!CashRegData[i][regExists]) continue;
        if (CashRegData[i][regInt] != GetPlayerInterior(playerid) && CashRegData[i][regVW] != GetPlayerVirtualWorld(playerid)) continue;
        tempdist = GetPlayerDistanceFromPoint(playerid, CashRegData[i][regX], CashRegData[i][regY], CashRegData[i][regZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            id = i;
        }
    }

    return id;
}

RegisterHacking:FindFreeID() {
    for (new i; i < MAX_CREGISTER; i++)
        if (!CashRegData[i][regExists]) return i;
    return ~1;
}

RegisterHacking:BeingEdited(id) {
    if (!(0 <= id <= MAX_CREGISTER - 1)) return 0;
    if (!CashRegData[id][regExists]) return 0;
    for (new i, psize = GetPlayerPoolSize(); i <= psize; i++) {
        if (!IsPlayerConnected(i)) continue;
        if (EditingRegisterID[i] == id) return 1;
    }

    return 0;
}

RegisterHacking:PlayerInit(playerid) {
    RobberyTimeLeft[playerid] = 0;
    RobberyTimer[playerid] = EditingRegisterID[playerid] = -1;

    CRegRobberyText[playerid] = CreatePlayerTextDraw(playerid, 40.000000, 295.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, CRegRobberyText[playerid], 255);
    PlayerTextDrawFont(playerid, CRegRobberyText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, CRegRobberyText[playerid], 0.240000, 1.100000);
    PlayerTextDrawColor(playerid, CRegRobberyText[playerid], -1);
    PlayerTextDrawSetOutline(playerid, CRegRobberyText[playerid], 1);
    PlayerTextDrawSetProportional(playerid, CRegRobberyText[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, CRegRobberyText[playerid], 0);

    ApplyAnimation(playerid, "INT_SHOP", "null", 0.0, 0, 0, 0, 0, 0);
    return 1;
}

RegisterHackingResetPlayer(playerid) {
    if (RobberyTimer[playerid] != -1) {
        KillTimer(RobberyTimer[playerid]);
        ClearAnimations(playerid);
    }

    PlayerTextDrawHide(playerid, CRegRobberyText[playerid]);
    RobberyTimeLeft[playerid] = 0;
    RobberyTimer[playerid] = -1;
    return 1;
}

forward LoadRegister_Data();
public LoadRegister_Data() {
    new rows = cache_num_rows();
    if (rows) {
        new id, loaded, label[128];
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", id);
            cache_get_value_name_float(loaded, "PosX", CashRegData[id][regX]);
            cache_get_value_name_float(loaded, "PosY", CashRegData[id][regY]);
            cache_get_value_name_float(loaded, "PosZ", CashRegData[id][regZ]);
            cache_get_value_name_float(loaded, "PosRX", CashRegData[id][regRX]);
            cache_get_value_name_float(loaded, "PosRY", CashRegData[id][regRY]);
            cache_get_value_name_float(loaded, "PosRZ", CashRegData[id][regRZ]);
            cache_get_value_name_int(loaded, "RegInt", CashRegData[id][regInt]);
            cache_get_value_name_int(loaded, "RegVW", CashRegData[id][regVW]);

            CashRegData[id][regObj] = CreateDynamicObject(2941, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ], CashRegData[id][regRX], CashRegData[id][regRY], CashRegData[id][regRZ], CashRegData[id][regVW], CashRegData[id][regInt]);

            format(label, sizeof(label), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{2ECC71}Robbable", id);
            CashRegData[id][regLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ] + 0.25, 5.0);

            CashRegData[id][regExists] = true;

            loaded++;
        }

    }
    printf("  [Register Hacking System] Loaded %d Register's.", rows);
    return 1;
}

hook OnGameModeInit() {
    for (new i; i < MAX_CREGISTER; i++) {
        CashRegData[i][regObj] = CashRegData[i][regPickup] = CashRegData[i][regTimer] = -1;
        CashRegData[i][regLabel] = Text3D:  - 1;
    }

    for (new i, psize = GetPlayerPoolSize(); i <= psize; i++) {
        if (IsPlayerConnected(i)) RegisterHacking:PlayerInit(i);
    }

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `cashRegisters` (\
		`ID` int(11) NOT NULL,\
	  	`PosX` FLOAT NOT NULL,\
	  	`PosY` FLOAT NOT NULL,\
	  	`PosZ` FLOAT NOT NULL,\
	  	`PosRX` FLOAT NOT NULL,\
	  	`PosRY` FLOAT NOT NULL,\
	  	`PosRZ` FLOAT NOT NULL,\
		`RegInt` int(11) NOT NULL,\
		`RegVW` int(11) NOT NULL,\
	  	PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    mysql_tquery(Database, "SELECT * FROM cashRegisters", "LoadRegister_Data", "");

    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RegisterHacking:PlayerInit(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    RegisterHackingResetPlayer(playerid);

    EditingRegisterID[playerid] = -1;
    CRegRobberyText[playerid] = PlayerText:  - 1;
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    RegisterHackingResetPlayer(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO)) {
        new id = GetClosestRegister(playerid);

        if (id != -1 && !RegisterHacking:BeingEdited(id) && CashRegData[id][regTimer] == -1) {
            SetPlayerPosEx(playerid, CashRegData[id][regX] + (0.75 * floatsin(-CashRegData[id][regRZ], degrees)), CashRegData[id][regY] + (0.75 * floatcos(-CashRegData[id][regRZ], degrees)), CashRegData[id][regZ]);
            RegisterHacking:SetPlayerLookAt(playerid, CashRegData[id][regX], CashRegData[id][regY]);

            // disable cash register
            CashRegData[id][regTimeLeft] = CREG_RESPAWN;
            CashRegData[id][regTimer] = SetTimerEx("RegisterHackingReset", 1000, true, "ii", id, -1);

            new string[128];
            format(string, sizeof(string), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{4286f4}Robbable in %s", id, ConvertToMinutes(CREG_RESPAWN));
            UpdateDynamic3DTextLabelText(CashRegData[id][regLabel], 0xF1C40FFF, string);

            // start robbery
            ApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.0, 1, 0, 0, 0, 0);

            format(string, sizeof(string), "~b~~h~Cash Register Robbery~n~~n~Complete in ~r~%s", ConvertToMinutes(CREG_ROBTIME));
            PlayerTextDrawSetString(playerid, CRegRobberyText[playerid], string);
            PlayerTextDrawShow(playerid, CRegRobberyText[playerid]);

            RobberyTimeLeft[playerid] = CREG_ROBTIME;
            RobberyTimer[playerid] = SetTimerEx("RegisterHackingRob", 1000, true, "i", playerid);
            return ~1;
        }
    }

    return 1;
}

hook OnPlayerShootDynObj(playerid, weaponid, objectid, Float:x, Float:y, Float:z) {
    if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 2941) {
        new id = -1;
        for (new i; i < MAX_CREGISTER; i++) {
            if (!CashRegData[i][regExists]) continue;
            if (objectid == CashRegData[i][regObj]) {
                id = i;
                break;
            }
        }

        if (id != -1 && !RegisterHacking:BeingEdited(id) && CashRegData[id][regTimer] == -1) {
            new Float:a = CashRegData[id][regRZ] + 180.0;
            CashRegData[id][regPickup] = CreateDynamicPickup(1212, 1, CashRegData[id][regX] + (1.25 * floatsin(-a, degrees)), CashRegData[id][regY] + (1.25 * floatcos(-a, degrees)), CashRegData[id][regZ] - 0.5);
            PlayerPlaySound(playerid, 17802, 0.0, 0.0, 0.0);

            CashRegData[id][regTimeLeft] = CREG_RESPAWN;
            CashRegData[id][regTimer] = SetTimerEx("RegisterHackingReset", 1000, true, "ii", id, CreateDynamicObject(18703, CashRegData[id][regX] - (0.15 * floatsin(-a, degrees)), CashRegData[id][regY] - (0.15 * floatcos(-a, degrees)), CashRegData[id][regZ] - 1.65, 0.0, 0.0, 0.0, CashRegData[id][regVW], CashRegData[id][regInt]));

            new string[128];
            format(string, sizeof(string), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{4286f4}Robbable in %s", id, ConvertToMinutes(CREG_RESPAWN));
            UpdateDynamic3DTextLabelText(CashRegData[id][regLabel], 0xF1C40FFF, string);
            Streamer_Update(playerid);
        }
    }

    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (EditingRegisterID[playerid] != -1 && CashRegData[EditingRegisterID[playerid]][regExists]) {
        if (response == EDIT_RESPONSE_FINAL) {
            new id = EditingRegisterID[playerid];
            CashRegData[id][regX] = x;
            CashRegData[id][regY] = y;
            CashRegData[id][regZ] = z;
            CashRegData[id][regRX] = rx;
            CashRegData[id][regRY] = ry;
            CashRegData[id][regRZ] = rz;

            SetDynamicObjectPos(objectid, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ]);
            SetDynamicObjectRot(objectid, CashRegData[id][regRX], CashRegData[id][regRY], CashRegData[id][regRZ]);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, CashRegData[id][regLabel], E_STREAMER_X, CashRegData[id][regX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, CashRegData[id][regLabel], E_STREAMER_Y, CashRegData[id][regY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, CashRegData[id][regLabel], E_STREAMER_Z, CashRegData[id][regZ] + 0.25);

            new query[512];
            mysql_format(Database, query, sizeof(query), "UPDATE `cashRegisters` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosRX`='%f',`PosRY`='%f',`PosRZ`='%f',`RegInt`='%d',`RegVW`='%d' WHERE `ID`='%d'",
                CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ], CashRegData[id][regRX], CashRegData[id][regRY], CashRegData[id][regRZ], CashRegData[id][regInt], CashRegData[id][regVW], id);
            mysql_tquery(Database, query);

            EditingRegisterID[playerid] = -1;
        }

        if (response == EDIT_RESPONSE_CANCEL) {
            new id = EditingRegisterID[playerid];
            SetDynamicObjectPos(objectid, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ]);
            SetDynamicObjectRot(objectid, CashRegData[id][regRX], CashRegData[id][regRY], CashRegData[id][regRZ]);
            EditingRegisterID[playerid] = -1;
        }
    }

    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    if (Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_MODEL_ID) == 1212) {
        new id = -1;
        for (new i; i < MAX_CREGISTER; i++) {
            if (!CashRegData[i][regExists]) continue;
            if (pickupid == CashRegData[i][regPickup]) {
                id = i;
                break;
            }
        }

        if (id != -1) {
            new money = RandomEx(floatround(CREG_MIN_MONEY / 2), floatround(CREG_MAX_MONEY / 2)), string[128];
            Heist:start(playerid, money);
            format(string, sizeof(string), "[CASH REGISTER]: {FFFFFF}You stole {2ECC71}%s {FFFFFF}from the cash register.", FormatCurrencyEx(money));
            SendClientMessageEx(playerid, 0x3498DBFF, string);
            // GivePlayerCash(playerid, money, "stole from register safe");

            CashRegData[id][regPickup] = -1;
            DestroyDynamicPickup(pickupid);
        }
    }

    return 1;
}

forward RegisterHackingReset(id, smokeid);
public RegisterHackingReset(id, smokeid) {
    new string[128];

    if (CashRegData[id][regTimeLeft] > 1) {
        CashRegData[id][regTimeLeft]--;

        format(string, sizeof(string), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{4286f4}Robbable in %s", id, ConvertToMinutes(CashRegData[id][regTimeLeft]));
        UpdateDynamic3DTextLabelText(CashRegData[id][regLabel], 0xF1C40FFF, string);
    } else if (CashRegData[id][regTimeLeft] == 1) {
        if (smokeid != -1) DestroyDynamicObjectEx(smokeid);
        DestroyDynamicPickup(CashRegData[id][regPickup]);
        KillTimer(CashRegData[id][regTimer]);
        CashRegData[id][regTimeLeft] = 0;
        CashRegData[id][regPickup] = CashRegData[id][regTimer] = -1;

        format(string, sizeof(string), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{2ECC71}Robbable", id);
        UpdateDynamic3DTextLabelText(CashRegData[id][regLabel], 0xF1C40FFF, string);
    }

    return 1;
}

forward RegisterHackingRob(playerid);
public RegisterHackingRob(playerid) {
    new string[128];

    if (RobberyTimeLeft[playerid] > 1) {
        RobberyTimeLeft[playerid]--;

        format(string, sizeof(string), "~b~~h~Cash Register Robbery~n~~n~Complete in ~r~%s", ConvertToMinutes(RobberyTimeLeft[playerid]));
        PlayerTextDrawSetString(playerid, CRegRobberyText[playerid], string);
    } else if (RobberyTimeLeft[playerid] == 1) {
        new money = RandomEx(CREG_MIN_MONEY, CREG_MAX_MONEY);
        RegisterHackingResetPlayer(playerid);

        format(string, sizeof(string), "[CASH REGISTER]: {FFFFFF}You stole {2ECC71}%s {FFFFFF}from the cash register.", FormatCurrencyEx(money));
        SendClientMessageEx(playerid, 0x3498DBFF, string);
        Heist:start(playerid, money);
        // GivePlayerCash(playerid, money, "stole from register safe hack");
    }

    return 1;
}

stock RegisterHacking:AdminPanel(playerid) {
    new string[512];
    strcat(string, "Create Register\n");
    strcat(string, "Edit Register\n");
    strcat(string, "Remove Register\n");
    return FlexPlayerDialog(
        playerid, "RegisterAdminPanel", DIALOG_STYLE_LIST, "{4286f4}[Register Hacking System]: {FFFFEE}Admin Control Panel", string, "Select", "Close"
    );
}

FlexDialog:RegisterAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Create Register", inputtext)) {
        new id = RegisterHacking:FindFreeID();
        if (id == -1) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}Server cash register limit reached.");
        GetPlayerPos(playerid, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ]);
        GetPlayerFacingAngle(playerid, CashRegData[id][regRZ]);
        CashRegData[id][regX] += (1.25 * floatsin(-CashRegData[id][regRZ], degrees));
        CashRegData[id][regY] += (1.25 * floatcos(-CashRegData[id][regRZ], degrees));
        CashRegData[id][regInt] = GetPlayerInterior(playerid);
        CashRegData[id][regVW] = GetPlayerVirtualWorld(playerid);
        CashRegData[id][regRX] = 0.0;
        CashRegData[id][regRY] = 0.0;
        CashRegData[id][regRZ] += 180.0;
        CashRegData[id][regTimeLeft] = 0;
        CashRegData[id][regObj] = CreateDynamicObject(2941, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ], 0.0, 0.0, CashRegData[id][regRZ], CashRegData[id][regVW], CashRegData[id][regInt]);
        new label[128];
        format(label, sizeof(label), "Cash Register (%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to rob.\n{2ECC71}Robbable", id);
        CashRegData[id][regLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ] + 0.25, 5.0);
        CashRegData[id][regExists] = true;
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO `cashRegisters`(`ID`, `PosX`, `PosY`, `PosZ`, `PosRX`, `PosRY`, `PosRZ`, `RegInt`, `RegVW`) VALUES ('%d','%f','%f','%f','%f','%f','%f','%d','%d')",
            id, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ], CashRegData[id][regRX], CashRegData[id][regRY], CashRegData[id][regRZ], CashRegData[id][regInt], CashRegData[id][regVW]);
        mysql_tquery(Database, query);
        EditingRegisterID[playerid] = id;
        EditDynamicObject(playerid, CashRegData[id][regObj]);
        SendClientMessageEx(playerid, 0x3498DBFF, "[CASH REGISTER]: {FFFFFF}Register created.");
        SendClientMessageEx(playerid, 0x3498DBFF, "[CASH REGISTER]: {FFFFFF}You can edit it right now, or cancel editing and edit it some other time.");
        return 1;
    }
    if (IsStringSame("Edit Register", inputtext)) return RegisterHacking:EditMenu(playerid);
    if (IsStringSame("Remove Register", inputtext)) return RegisterHacking:RemoveMenu(playerid);
    return 1;
}


stock RegisterHacking:EditMenu(playerid) {
    return FlexPlayerDialog(
        playerid, "RegisterEditMenu", DIALOG_STYLE_INPUT, "{4286f4}[Register Hacking System]: {FFFFEE}Admin Control Panel",
        "Enter register id to edit it's position", "Edit", "Close"
    );
}

FlexDialog:RegisterEditMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return RegisterHacking:AdminPanel(playerid);
    new id;
    if (
        sscanf(inputtext, "d", id) || !(0 <= id <= MAX_CREGISTER - 1) || !CashRegData[id][regExists] ||
        !IsPlayerInRangeOfPoint(playerid, 20.0, CashRegData[id][regX], CashRegData[id][regY], CashRegData[id][regZ]) ||
        RegisterHacking:BeingEdited(id)
    ) return RegisterHacking:EditMenu(playerid);
    EditingRegisterID[playerid] = id;
    EditDynamicObject(playerid, CashRegData[id][regObj]);
    return 1;
}

stock RegisterHacking:RemoveMenu(playerid) {
    return FlexPlayerDialog(
        playerid, "RegisterRemoveMenu", DIALOG_STYLE_INPUT, "{4286f4}[Register Hacking System]: {FFFFEE}Admin Control Panel",
        "Enter register id to remove it", "Remove", "Close"
    );
}

FlexDialog:RegisterRemoveMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return RegisterHacking:AdminPanel(playerid);
    new id;
    if (
        sscanf(inputtext, "d", id) || !(0 <= id <= MAX_CREGISTER - 1) || !CashRegData[id][regExists] || RegisterHacking:BeingEdited(id)
    ) return 1;
    DestroyDynamicObjectEx(CashRegData[id][regObj]);
    DestroyDynamic3DTextLabel(CashRegData[id][regLabel]);
    DestroyDynamicPickup(CashRegData[id][regPickup]);
    if (CashRegData[id][regTimer] != -1) KillTimer(CashRegData[id][regTimer]);
    CashRegData[id][regObj] = CashRegData[id][regPickup] = CashRegData[id][regTimer] = -1;
    CashRegData[id][regLabel] = Text3D:  - 1;
    CashRegData[id][regExists] = false;
    new query[512];
    mysql_format(Database, query, sizeof(query), "DELETE FROM `cashRegisters` WHERE `ID`='%d'", id);
    mysql_tquery(Database, query);
    SendClientMessageEx(playerid, 0x3498DBFF, "[CASH REGISTER]: {FFFFFF}Cash register removed.");
    RegisterHacking:AdminPanel(playerid);
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Register Hack System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Register Hack System", inputtext)) RegisterHacking:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "register hack system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    RegisterHacking:AdminPanel(playerid);
    return ~1;
}