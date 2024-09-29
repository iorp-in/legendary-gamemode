#define     MAX_SAFES       (25)
#define     MAX_NUMBER      (15)

#define     SAFE_TIME       (60*60)
#define     SAFE_MONEY_MIN  (1500)
#define     SAFE_MONEY_MAX  (5500)

enum E_SAFE {
    // from db
    Float:SafeX,
    Float:SafeY,
    Float:SafeZ,
    Float:SafeRX,
    Float:SafeRY,
    Float:SafeRZ,
    // temp
    SafeOccupiedBy,
    SafeMoney,
    SafeNumbers[3],
    bool:SafeLocks[3],
    SafeObject,
    Text3D:SafeLabel,
    // timer
    SafeTimeLeft,
    SafeTimer
}

new DiffColors[] = { 0xA6A6A6FF, 0xBFBFBFFF };
// index 0(first color) is the number itself

new SafeData[MAX_SAFES][E_SAFE],
    Iterator:Safes < MAX_SAFES > ;

new CrackingSafeID[MAX_PLAYERS] = {-1, ... },
    EditingSafeID[MAX_PLAYERS] = {-1, ... },
    CurSafeNumber[MAX_PLAYERS] = { 0, ... };

new Text:tdSafeCrackingBG,
Text:tdSafeCrackingTitleBG,
Text:tdSafeCrackingTitle,
Text:tdSafeCrackingPrev,
Text:tdSafeCrackingNext,
Text:tdSafeCrackingTry;

new PlayerText:tdSafeNumber[MAX_PLAYERS][3],
    PlayerText:tdSafeLock[MAX_PLAYERS][3];

Float:AngleToPoint(Float:X1, Float:Y1, Float:X2, Float:Y2) // By Nero_3D
return atan((Y2 - Y1) / (X2 - X1)) + ((X2 < X1) ? 90 : 270);

SafeHacking:GetLockIndex(safeid) {
    if (!Iter_Contains(Safes, safeid)) return -1;
    for (new i; i < 3; i++) {
        if (!SafeData[safeid][SafeLocks][i]) return i;
    }
    return -1;
}

SafeHacking:GetLockNumber(safeid) {
    if (!Iter_Contains(Safes, safeid)) return -1;
    for (new i; i < 3; i++) {
        if (!SafeData[safeid][SafeLocks][i]) return SafeData[safeid][SafeNumbers][i];
    }
    return -1;
}

SafeHacking:InitPlayer(playerid) {
    // variables
    CrackingSafeID[playerid] = EditingSafeID[playerid] = -1;
    CurSafeNumber[playerid] = 0;

    // textdraws
    tdSafeNumber[playerid][0] = CreatePlayerTextDraw(playerid, 277.000000, 338.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, tdSafeNumber[playerid][0], 255);
    PlayerTextDrawFont(playerid, tdSafeNumber[playerid][0], 3);
    PlayerTextDrawLetterSize(playerid, tdSafeNumber[playerid][0], 0.409999, 2.000000);
    PlayerTextDrawColor(playerid, tdSafeNumber[playerid][0], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeNumber[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeNumber[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, tdSafeNumber[playerid][0], 0);

    tdSafeNumber[playerid][1] = CreatePlayerTextDraw(playerid, 317.000000, 334.000000, "_");
    PlayerTextDrawAlignment(playerid, tdSafeNumber[playerid][1], 2);
    PlayerTextDrawBackgroundColor(playerid, tdSafeNumber[playerid][1], 255);
    PlayerTextDrawFont(playerid, tdSafeNumber[playerid][1], 3);
    PlayerTextDrawLetterSize(playerid, tdSafeNumber[playerid][1], 0.409999, 2.000000);
    PlayerTextDrawColor(playerid, tdSafeNumber[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeNumber[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeNumber[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, tdSafeNumber[playerid][1], 0);

    tdSafeNumber[playerid][2] = CreatePlayerTextDraw(playerid, 357.000000, 338.000000, "_");
    PlayerTextDrawAlignment(playerid, tdSafeNumber[playerid][2], 3);
    PlayerTextDrawBackgroundColor(playerid, tdSafeNumber[playerid][2], 255);
    PlayerTextDrawFont(playerid, tdSafeNumber[playerid][2], 3);
    PlayerTextDrawLetterSize(playerid, tdSafeNumber[playerid][2], 0.409999, 2.000000);
    PlayerTextDrawColor(playerid, tdSafeNumber[playerid][2], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeNumber[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeNumber[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, tdSafeNumber[playerid][2], 0);

    tdSafeLock[playerid][0] = CreatePlayerTextDraw(playerid, 267.000000, 362.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, tdSafeLock[playerid][0], 0);
    PlayerTextDrawFont(playerid, tdSafeLock[playerid][0], 5);
    PlayerTextDrawLetterSize(playerid, tdSafeLock[playerid][0], 0.0, 0.0);
    PlayerTextDrawColor(playerid, tdSafeLock[playerid][0], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeLock[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeLock[playerid][0], 1);
    PlayerTextDrawUseBox(playerid, tdSafeLock[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, tdSafeLock[playerid][0], 0);
    PlayerTextDrawTextSize(playerid, tdSafeLock[playerid][0], 20.000000, 20.000000);
    PlayerTextDrawSetPreviewModel(playerid, tdSafeLock[playerid][0], 19804);
    PlayerTextDrawSetPreviewRot(playerid, tdSafeLock[playerid][0], 0.000000, 0.000000, 0.000000, 0.65);
    PlayerTextDrawSetSelectable(playerid, tdSafeLock[playerid][0], 0);

    tdSafeLock[playerid][1] = CreatePlayerTextDraw(playerid, 307.000000, 362.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, tdSafeLock[playerid][1], 0);
    PlayerTextDrawFont(playerid, tdSafeLock[playerid][1], 5);
    PlayerTextDrawLetterSize(playerid, tdSafeLock[playerid][1], 0.0, 0.0);
    PlayerTextDrawColor(playerid, tdSafeLock[playerid][1], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeLock[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeLock[playerid][1], 1);
    PlayerTextDrawUseBox(playerid, tdSafeLock[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, tdSafeLock[playerid][1], 0);
    PlayerTextDrawTextSize(playerid, tdSafeLock[playerid][1], 20.000000, 20.000000);
    PlayerTextDrawSetPreviewModel(playerid, tdSafeLock[playerid][1], 19804);
    PlayerTextDrawSetPreviewRot(playerid, tdSafeLock[playerid][1], 0.000000, 0.000000, 0.000000, 0.65);
    PlayerTextDrawSetSelectable(playerid, tdSafeLock[playerid][1], 0);

    tdSafeLock[playerid][2] = CreatePlayerTextDraw(playerid, 347.000000, 362.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, tdSafeLock[playerid][2], 0);
    PlayerTextDrawFont(playerid, tdSafeLock[playerid][2], 5);
    PlayerTextDrawLetterSize(playerid, tdSafeLock[playerid][2], 0.0, 0.0);
    PlayerTextDrawColor(playerid, tdSafeLock[playerid][2], -1);
    PlayerTextDrawSetOutline(playerid, tdSafeLock[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, tdSafeLock[playerid][2], 1);
    PlayerTextDrawUseBox(playerid, tdSafeLock[playerid][2], 1);
    PlayerTextDrawBoxColor(playerid, tdSafeLock[playerid][2], 0);
    PlayerTextDrawTextSize(playerid, tdSafeLock[playerid][2], 20.000000, 20.000000);
    PlayerTextDrawSetPreviewModel(playerid, tdSafeLock[playerid][2], 19804);
    PlayerTextDrawSetPreviewRot(playerid, tdSafeLock[playerid][2], 0.000000, 0.000000, 0.000000, 0.65);
    PlayerTextDrawSetSelectable(playerid, tdSafeLock[playerid][2], 0);

    // preload anim lib

    Anim:SetState(playerid, true);
    ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
    return 1;
}

SafeHacking:SetUIState(playerid, show, nocancel = 0) {
    if (show) {
        TextDrawShowForPlayer(playerid, tdSafeCrackingBG);
        TextDrawShowForPlayer(playerid, tdSafeCrackingTitleBG);
        TextDrawShowForPlayer(playerid, tdSafeCrackingTitle);
        TextDrawShowForPlayer(playerid, tdSafeCrackingPrev);
        TextDrawShowForPlayer(playerid, tdSafeCrackingNext);
        TextDrawShowForPlayer(playerid, tdSafeCrackingTry);

        for (new i; i < 3; i++) {
            PlayerTextDrawShow(playerid, tdSafeNumber[playerid][i]);
            PlayerTextDrawShow(playerid, tdSafeLock[playerid][i]);
        }

        SafeHacking:SetNumber(playerid, 0);
        SafeHacking:UpdateLocks(playerid);
        SelectTextDraw(playerid, 0x03A9F4FF);
    } else {
        TextDrawHideForPlayer(playerid, tdSafeCrackingBG);
        TextDrawHideForPlayer(playerid, tdSafeCrackingTitleBG);
        TextDrawHideForPlayer(playerid, tdSafeCrackingTitle);
        TextDrawHideForPlayer(playerid, tdSafeCrackingPrev);
        TextDrawHideForPlayer(playerid, tdSafeCrackingNext);
        TextDrawHideForPlayer(playerid, tdSafeCrackingTry);

        for (new i; i < 3; i++) {
            PlayerTextDrawHide(playerid, tdSafeNumber[playerid][i]);
            PlayerTextDrawHide(playerid, tdSafeLock[playerid][i]);
        }

        if (!nocancel) CancelSelectTextDraw(playerid);
    }

    return 1;
}

SafeHacking:SetNumber(playerid, number) {
    CurSafeNumber[playerid] = number;

    new string[4], value, difference, actual_number = SafeHacking:GetLockNumber(CrackingSafeID[playerid]);
    for (new i; i < 3; i++) {
        // probably spaghetti
        switch (i) {
            case 0 :  {
                // left
                value = number - 1;
                if (value < 0) value = MAX_NUMBER;
            }

            case 1 :  {
                // middle
                value = number;
            }

            case 2 :  {
                // right
                value = number + 1;
                if (value > MAX_NUMBER) value = 0;
            }
        }

        // current number
        format(string, sizeof(string), "%02d", value);
        PlayerTextDrawSetString(playerid, tdSafeNumber[playerid][i], string);

        // difference to safe lock number
        difference = floatround(floatabs(value - actual_number));
        if (difference < sizeof(DiffColors)) {
            PlayerTextDrawColor(playerid, tdSafeNumber[playerid][i], DiffColors[difference]);
        } else {
            PlayerTextDrawColor(playerid, tdSafeNumber[playerid][i], -1);
        }

        // show td again
        PlayerTextDrawShow(playerid, tdSafeNumber[playerid][i]);
    }

    return 1;
}

SafeHacking:UpdateLocks(playerid) {
    if (Iter_Contains(Safes, CrackingSafeID[playerid])) {
        for (new i; i < 3; i++) {
            PlayerTextDrawColor(playerid, tdSafeLock[playerid][i], (SafeData[CrackingSafeID[playerid]][SafeLocks][i]) ? 0x2ECC71FF :  - 1);
            PlayerTextDrawShow(playerid, tdSafeLock[playerid][i]);
        }
    }

    return 1;
}

SafeHacking:ResetPlayer(playerid, nocancel = 0) {
    if (Iter_Contains(Safes, CrackingSafeID[playerid])) SafeData[CrackingSafeID[playerid]][SafeOccupiedBy] = -1;
    SafeHacking:SetUIState(playerid, 0, nocancel);

    CrackingSafeID[playerid] = -1;
    CurSafeNumber[playerid] = 0;
    return 1;
}

SafeHacking:UnlockSafe(safeid) {
    if (!Iter_Contains(Safes, safeid)) return -1;
    Streamer_SetIntData(STREAMER_TYPE_OBJECT, SafeData[safeid][SafeObject], E_STREAMER_MODEL_ID, 1829);
    SetDynamicObjectMaterial(SafeData[safeid][SafeObject], 1, 19478, "signsurf", "sign", 0xFFFFFFFF);

    SafeData[safeid][SafeOccupiedBy] = -1;
    SafeData[safeid][SafeMoney] = RandomEx(SAFE_MONEY_MIN, SAFE_MONEY_MAX);
    SafeData[safeid][SafeTimeLeft] = SAFE_TIME;

    new label[128];
    format(label, sizeof(label), "Safe(%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_YES~ {FFFFFF}to steal {2ECC71}%s.\n{4286f4}Cracked (%s)", safeid, FormatCurrencyEx(SafeData[safeid][SafeMoney]), ConvertToMinutes(SafeData[safeid][SafeTimeLeft]));
    UpdateDynamic3DTextLabelText(SafeData[safeid][SafeLabel], 0xF1C40FFF, label);

    SafeData[safeid][SafeTimer] = SetTimerEx("Safe_Lock", 1000, true, "i", safeid);
    return 1;
}

GetClosestSafe(playerid, Float:range = 2.0) {
    new safeid = -1, Float:dist = range, Float:tempdist;
    foreach(new i:Safes) {
        tempdist = GetPlayerDistanceFromPoint(playerid, SafeData[i][SafeX], SafeData[i][SafeY], SafeData[i][SafeZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            safeid = i;
        }
    }

    return safeid;
}

forward Safe_Lock(safeid);
public Safe_Lock(safeid) {
    new label[128];
    if (SafeData[safeid][SafeTimeLeft] > 1) {
        SafeData[safeid][SafeTimeLeft]--;

        if (!SafeData[safeid][SafeMoney]) {
            format(label, sizeof(label), "Safe(%d)\n\n{4286f4}Cracked (%s)", safeid, ConvertToMinutes(SafeData[safeid][SafeTimeLeft]));
        } else {
            format(label, sizeof(label), "Safe(%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_YES~ {FFFFFF}to steal {2ECC71}%s.\n{4286f4}Cracked (%s)", safeid, FormatCurrencyEx(SafeData[safeid][SafeMoney]), ConvertToMinutes(SafeData[safeid][SafeTimeLeft]));
        }

        UpdateDynamic3DTextLabelText(SafeData[safeid][SafeLabel], 0xF1C40FFF, label);
    } else if (SafeData[safeid][SafeTimeLeft] == 1) {
        for (new i; i < 3; i++) {
            SafeData[safeid][SafeNumbers][i] = RandomEx(0, MAX_NUMBER);
            SafeData[safeid][SafeLocks][i] = false;
        }

        KillTimer(SafeData[safeid][SafeTimer]);
        SafeData[safeid][SafeTimer] = -1;

        DestroyDynamicObjectEx(SafeData[safeid][SafeObject]);
        SafeData[safeid][SafeObject] = CreateDynamicObject(2332, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ], SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]);

        format(label, sizeof(label), "Safe(%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to crack.\n{2ECC71}Crackable", safeid);
        UpdateDynamic3DTextLabelText(SafeData[safeid][SafeLabel], 0xF1C40FFF, label);
    }

    return 1;
}

forward LoadSafe_Data();
public LoadSafe_Data() {
    new rows = cache_num_rows();
    if (rows) {
        new safeid, loaded, label[128];
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", safeid);
            cache_get_value_name_float(loaded, "PosX", SafeData[safeid][SafeX]);
            cache_get_value_name_float(loaded, "PosY", SafeData[safeid][SafeY]);
            cache_get_value_name_float(loaded, "PosZ", SafeData[safeid][SafeZ]);
            cache_get_value_name_float(loaded, "PosRX", SafeData[safeid][SafeRX]);
            cache_get_value_name_float(loaded, "PosRY", SafeData[safeid][SafeRY]);
            cache_get_value_name_float(loaded, "PosRZ", SafeData[safeid][SafeRZ]);

            for (new i; i < 3; i++) SafeData[safeid][SafeNumbers][i] = RandomEx(0, MAX_NUMBER);

            SafeData[safeid][SafeObject] = CreateDynamicObject(2332, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ], SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]);

            format(label, sizeof(label), "Safe(%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to crack.\n{2ECC71}Crackable", safeid);
            SafeData[safeid][SafeLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ] + 0.8, 10.0);

            Iter_Add(Safes, safeid);
            loaded++;
        }

    }
    printf("  [Safe Hacking System] Loaded %d Safe's.", rows);
    return 1;
}


hook OnGameModeInit() {
    // reset variables
    for (new i; i < MAX_SAFES; i++) {
        SafeData[i][SafeOccupiedBy] = SafeData[i][SafeObject] = SafeData[i][SafeTimer] = -1;
        SafeData[i][SafeLabel] = Text3D:  - 1;

        for (new x; x < 3; x++) SafeData[i][SafeNumbers][x] = SafeData[i][SafeLocks][x] = !!0;
    }

    // create textdraws
    tdSafeCrackingBG = TextDrawCreate(235.000000, 320.000000, "_");
    TextDrawBackgroundColor(tdSafeCrackingBG, 255);
    TextDrawFont(tdSafeCrackingBG, 1);
    TextDrawLetterSize(tdSafeCrackingBG, 0.500000, 7.000000);
    TextDrawColor(tdSafeCrackingBG, -1);
    TextDrawSetOutline(tdSafeCrackingBG, 0);
    TextDrawSetProportional(tdSafeCrackingBG, 1);
    TextDrawSetShadow(tdSafeCrackingBG, 1);
    TextDrawUseBox(tdSafeCrackingBG, 1);
    TextDrawBoxColor(tdSafeCrackingBG, 168430200);
    TextDrawTextSize(tdSafeCrackingBG, 401.000000, 0.000000);
    TextDrawSetSelectable(tdSafeCrackingBG, 0);

    tdSafeCrackingTitleBG = TextDrawCreate(235.000000, 320.000000, "_");
    TextDrawBackgroundColor(tdSafeCrackingTitleBG, 255);
    TextDrawFont(tdSafeCrackingTitleBG, 1);
    TextDrawLetterSize(tdSafeCrackingTitleBG, 0.270000, 1.400000);
    TextDrawColor(tdSafeCrackingTitleBG, -1);
    TextDrawSetOutline(tdSafeCrackingTitleBG, 1);
    TextDrawSetProportional(tdSafeCrackingTitleBG, 1);
    TextDrawUseBox(tdSafeCrackingTitleBG, 1);
    TextDrawBoxColor(tdSafeCrackingTitleBG, 168430335);
    TextDrawTextSize(tdSafeCrackingTitleBG, 401.000000, 0.000000);
    TextDrawSetSelectable(tdSafeCrackingTitleBG, 0);

    tdSafeCrackingTitle = TextDrawCreate(237.000000, 321.000000, "Safe Cracking");
    TextDrawBackgroundColor(tdSafeCrackingTitle, 255);
    TextDrawFont(tdSafeCrackingTitle, 2);
    TextDrawLetterSize(tdSafeCrackingTitle, 0.200000, 1.100000);
    TextDrawColor(tdSafeCrackingTitle, -1);
    TextDrawSetOutline(tdSafeCrackingTitle, 1);
    TextDrawSetProportional(tdSafeCrackingTitle, 1);
    TextDrawSetSelectable(tdSafeCrackingTitle, 0);

    tdSafeCrackingPrev = TextDrawCreate(240.000000, 340.000000, "LD_BEAT:left");
    TextDrawBackgroundColor(tdSafeCrackingPrev, 255);
    TextDrawFont(tdSafeCrackingPrev, 4);
    TextDrawLetterSize(tdSafeCrackingPrev, 0.200000, 1.100000);
    TextDrawColor(tdSafeCrackingPrev, -1);
    TextDrawSetOutline(tdSafeCrackingPrev, 1);
    TextDrawSetProportional(tdSafeCrackingPrev, 1);
    TextDrawUseBox(tdSafeCrackingPrev, 1);
    TextDrawBoxColor(tdSafeCrackingPrev, 255);
    TextDrawTextSize(tdSafeCrackingPrev, 16.000000, 16.000000);
    TextDrawSetSelectable(tdSafeCrackingPrev, 1);

    tdSafeCrackingNext = TextDrawCreate(380.000000, 340.000000, "LD_BEAT:right");
    TextDrawBackgroundColor(tdSafeCrackingNext, 255);
    TextDrawFont(tdSafeCrackingNext, 4);
    TextDrawLetterSize(tdSafeCrackingNext, 0.200000, 1.100000);
    TextDrawColor(tdSafeCrackingNext, -1);
    TextDrawSetOutline(tdSafeCrackingNext, 1);
    TextDrawSetProportional(tdSafeCrackingNext, 1);
    TextDrawUseBox(tdSafeCrackingNext, 1);
    TextDrawBoxColor(tdSafeCrackingNext, 255);
    TextDrawTextSize(tdSafeCrackingNext, 16.000000, 16.000000);
    TextDrawSetSelectable(tdSafeCrackingNext, 1);

    tdSafeCrackingTry = TextDrawCreate(379.000000, 321.000000, " Try");
    TextDrawBackgroundColor(tdSafeCrackingTry, 255);
    TextDrawFont(tdSafeCrackingTry, 2);
    TextDrawLetterSize(tdSafeCrackingTry, 0.200000, 1.100000);
    TextDrawColor(tdSafeCrackingTry, -1);
    TextDrawSetOutline(tdSafeCrackingTry, 1);
    TextDrawSetProportional(tdSafeCrackingTry, 1);
    TextDrawUseBox(tdSafeCrackingTry, 1);
    TextDrawBoxColor(tdSafeCrackingTry, -872414977);
    TextDrawTextSize(tdSafeCrackingTry, 400.000000, 10.000000);
    TextDrawSetSelectable(tdSafeCrackingTry, 1);

    // create player textdraws
    foreach(new i:Player) if (IsPlayerConnected(i)) SafeHacking:InitPlayer(i);

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `cashSafes` (\
		`ID` int(11) NOT NULL,\
	  	`PosX` FLOAT NOT NULL,\
	  	`PosY` FLOAT NOT NULL,\
	  	`PosZ` FLOAT NOT NULL,\
	  	`PosRX` FLOAT NOT NULL,\
	  	`PosRY` FLOAT NOT NULL,\
	  	`PosRZ` FLOAT NOT NULL,\
	  	PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    mysql_tquery(Database, "SELECT * FROM cashSafes", "LoadSafe_Data", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:Player) {
        if (IsPlayerConnected(i)) {
            SafeHacking:SetUIState(i, 0);

            for (new x; x < 3; x++) {
                PlayerTextDrawDestroy(i, tdSafeNumber[i][x]);
                PlayerTextDrawDestroy(i, tdSafeLock[i][x]);
            }
        }
    }

    TextDrawDestroy(tdSafeCrackingBG);
    TextDrawDestroy(tdSafeCrackingTitleBG);
    TextDrawDestroy(tdSafeCrackingTitle);
    TextDrawDestroy(tdSafeCrackingPrev);
    TextDrawDestroy(tdSafeCrackingNext);
    TextDrawDestroy(tdSafeCrackingTry);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SafeHacking:InitPlayer(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    SafeHacking:ResetPlayer(playerid, 1);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    SafeHacking:ResetPlayer(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if (newkeys & KEY_NO) {
            // safe cracking
            new safeid = GetClosestSafe(playerid);
            if (safeid != -1) {
                if (IsPlayerConnected(SafeData[safeid][SafeOccupiedBy])) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}Someone else is cracking this safe.");
                if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, SafeData[safeid][SafeObject], E_STREAMER_MODEL_ID) == 1829) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}This safe is cracked.");
                SafeData[safeid][SafeOccupiedBy] = playerid;

                CrackingSafeID[playerid] = safeid;
                SafeHacking:SetUIState(playerid, 1);

                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerFacingAngle(playerid, AngleToPoint(x, y, SafeData[safeid][SafeX], SafeData[safeid][SafeY]));

                Anim:SetState(playerid, true);
                ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.0, 1, 0, 0, 0, 0);
                return ~1;
            }
        }

        if (newkeys & KEY_YES) {
            // money stealing
            new safeid = GetClosestSafe(playerid);
            if (safeid != -1) {
                if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, SafeData[safeid][SafeObject], E_STREAMER_MODEL_ID) != 1829) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}This safe isn't cracked.");
                if (!SafeData[safeid][SafeMoney]) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}This safe is empty.");
                SetDynamicObjectMaterial(SafeData[safeid][SafeObject], 2, 19478, "signsurf", "sign", 0xFFFFFFFF);

                UpdateDynamic3DTextLabelText(SafeData[safeid][SafeLabel], 0xF1C40FFF, sprintf(
                    "Safe(%d)\n\n{4286f4}Cracked (%s)", safeid, ConvertToMinutes(SafeData[safeid][SafeTimeLeft])
                ));
                Streamer_Update(playerid);

                new started = Heist:start(playerid, SafeData[safeid][SafeMoney]);
                if (started) AlexaMsg(playerid, sprintf(
                    "You stole {2ECC71}%s {FFFFFF}from the safe", FormatCurrencyEx(SafeData[safeid][SafeMoney])
                ), "SAFE");
                SafeData[safeid][SafeMoney] = 0;
                return ~1;
            }
        }
    }

    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == Text:INVALID_TEXT_DRAW) {
        SafeHacking:ResetPlayer(playerid, 1);
        return 1;
    } else {
        if (clickedid == tdSafeCrackingPrev) {
            SafeHacking:SetNumber(playerid, (CurSafeNumber[playerid] - 1 < 0) ? MAX_NUMBER : CurSafeNumber[playerid] - 1);
            PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
            return 1;
        }

        if (clickedid == tdSafeCrackingNext) {
            SafeHacking:SetNumber(playerid, (CurSafeNumber[playerid] + 1 > MAX_NUMBER) ? 0 : CurSafeNumber[playerid] + 1);
            PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
            return 1;
        }

        if (clickedid == tdSafeCrackingTry) {
            new safeid = CrackingSafeID[playerid];
            if (safeid == -1) return SafeHacking:SetUIState(playerid, 0);
            if (CurSafeNumber[playerid] == SafeHacking:GetLockNumber(safeid)) {
                // correct number, open a lock/crack the safe if no locks left
                new idx = SafeHacking:GetLockIndex(safeid);
                if (idx == -1) {
                    SafeHacking:UnlockSafe(safeid);
                    SafeHacking:ResetPlayer(playerid);
                    Streamer_Update(playerid);
                } else {
                    SafeData[safeid][SafeLocks][idx] = true;

                    // update textdraws
                    SafeHacking:UpdateLocks(playerid);

                    // reset number
                    SafeHacking:SetNumber(playerid, 0);

                    // lock check
                    if (SafeHacking:GetLockIndex(safeid) == -1) {
                        SafeHacking:UnlockSafe(safeid);
                        SafeHacking:ResetPlayer(playerid);
                        Streamer_Update(playerid);
                    }
                }

                PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
            } else {
                // incorrect number, reset locks
                for (new i; i < 3; i++) {
                    SafeData[safeid][SafeNumbers][i] = RandomEx(0, MAX_NUMBER);
                    SafeData[safeid][SafeLocks][i] = false;
                }

                SafeHacking:UpdateLocks(playerid);
                SafeHacking:SetNumber(playerid, 0);

                SendClientMessageEx(playerid, 0x3498DBFF, "[SAFE]: {FFFFFF}Wrong number, safe password changed.");
                PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
            }

            return 1;
        }
    }

    return 0;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    switch (response) {
        case EDIT_RESPONSE_CANCEL:  {
            if ((Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 2332 || Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 1829) && Iter_Contains(Safes, EditingSafeID[playerid])) {
                new safeid = EditingSafeID[playerid];
                SetDynamicObjectPos(objectid, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ]);
                SetDynamicObjectRot(objectid, SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]);

                EditingSafeID[playerid] = -1;
            }
        }

        case EDIT_RESPONSE_FINAL:  {
            if ((Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 2332 || Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 1829) && Iter_Contains(Safes, EditingSafeID[playerid])) {
                new safeid = EditingSafeID[playerid];
                SafeData[safeid][SafeX] = x;
                SafeData[safeid][SafeY] = y;
                SafeData[safeid][SafeZ] = z;
                SafeData[safeid][SafeRX] = rx;
                SafeData[safeid][SafeRY] = ry;
                SafeData[safeid][SafeRZ] = rz;

                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, SafeData[safeid][SafeLabel], E_STREAMER_X, SafeData[safeid][SafeX]);
                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, SafeData[safeid][SafeLabel], E_STREAMER_Y, SafeData[safeid][SafeY]);
                Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, SafeData[safeid][SafeLabel], E_STREAMER_Z, SafeData[safeid][SafeZ] + 0.8);

                SetDynamicObjectPos(objectid, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ]);
                SetDynamicObjectRot(objectid, SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]);

                new query[512];
                mysql_format(Database, query, sizeof(query), "UPDATE `cashSafes` SET `PosX`='%f',`PosY`='%f',`PosZ`='%f',`PosRX`='%f',`PosRY`='%f',`PosRZ`='%f' WHERE `ID`='%d'",
                    SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ], SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ], safeid);
                mysql_tquery(Database, query);

                EditingSafeID[playerid] = -1;
            }
        }
    }

    return 1;
}

stock SafeHacking:AdminPanel(playerid) {
    new string[512];
    strcat(string, "Create Safe\n");
    strcat(string, "Manage Safe\n");
    return FlexPlayerDialog(
        playerid, "SafeAdminPanel", DIALOG_STYLE_LIST, "{4286f4}[Safe Hacking System]: {FFFFEE}Admin Control Panel", string, "Select", "Close"
    );
}

FlexDialog:SafeAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Safe")) {
        new safeid = Iter_Free(Safes);
        if (safeid == INVALID_ITERATOR_SLOT) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}Safe limit reached.");
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        x += 1.5 * floatsin(-a, degrees);
        y += 1.5 * floatcos(-a, degrees);
        z -= 0.5;

        SafeData[safeid][SafeX] = x;
        SafeData[safeid][SafeY] = y;
        SafeData[safeid][SafeZ] = z;
        SafeData[safeid][SafeRX] = 0.0;
        SafeData[safeid][SafeRY] = 0.0;
        SafeData[safeid][SafeRZ] = a;
        SafeData[safeid][SafeOccupiedBy] = SafeData[safeid][SafeTimer] = -1;
        SafeData[safeid][SafeMoney] = SafeData[safeid][SafeTimeLeft] = 0;

        for (new i; i < 3; i++) {
            SafeData[safeid][SafeNumbers][i] = RandomEx(0, MAX_NUMBER);
            SafeData[safeid][SafeLocks][i] = false;
        }

        SafeData[safeid][SafeObject] = CreateDynamicObject(
            2332, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ], SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]
        );

        new label[96];
        format(label, sizeof(label), "Safe(%d)\n\n{FFFFFF}Press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to crack.\n{2ECC71}Crackable", safeid);
        SafeData[safeid][SafeLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ] + 0.8, 10.0);

        Iter_Add(Safes, safeid);

        EditingSafeID[playerid] = safeid;
        EditDynamicObject(playerid, SafeData[safeid][SafeObject]);

        mysql_tquery(Database, sprintf(
            "INSERT INTO `cashSafes`(`ID`, `PosX`, `PosY`, `PosZ`, `PosRX`, `PosRY`, `PosRZ`) VALUES ('%d','%f','%f','%f','%f','%f','%f')",
            safeid, SafeData[safeid][SafeX], SafeData[safeid][SafeY], SafeData[safeid][SafeZ], SafeData[safeid][SafeRX], SafeData[safeid][SafeRY], SafeData[safeid][SafeRZ]
        ));
        SendClientMessageEx(playerid, 0x3498DBFF, "[SAFE]: {FFFFFF}Safe created.");
        return 1;
    }
    if (IsStringSame(inputtext, "Manage Safe")) return SafeHacking:ManageSafeInput(playerid);
    return 1;
}

stock SafeHacking:ManageSafeInput(playerid) {
    return FlexPlayerDialog(
        playerid, "SafeManageSafeInput", DIALOG_STYLE_INPUT, "{4286f4}[Safe Hacking System]: {FFFFEE}Admin Control Panel",
        "Enter safe id", "Edit", "Close"
    );
}

FlexDialog:SafeManageSafeInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return SafeHacking:AdminPanel(playerid);
    new safeid;
    if (sscanf(inputtext, "d", safeid) || !Iter_Contains(Safes, safeid)) return SafeHacking:ManageSafeInput(playerid);
    SafeHacking:ManageSafe(playerid, safeid);
    return 1;
}

stock SafeHacking:ManageSafe(playerid, safeid) {
    if (!Iter_Contains(Safes, safeid)) return SafeHacking:ManageSafeInput(playerid);
    new string[512];
    strcat(string, "View Code\n");
    strcat(string, "Edit position\n");
    strcat(string, "Remove position\n");
    return FlexPlayerDialog(
        playerid, "SafeManageSafe", DIALOG_STYLE_LIST, "{4286f4}[Safe Hacking System]: {FFFFEE}Admin Control Panel", string, "Select", "Close", safeid
    );
}

FlexDialog:SafeManageSafe(playerid, response, listitem, const inputtext[], safeid, const payload[]) {
    if (!response || !Iter_Contains(Safes, safeid)) return SafeHacking:ManageSafeInput(playerid);
    if (IsStringSame(inputtext, "View Code")) {
        AlexaMsg(playerid, sprintf(
            "[SAFE]: {FFFFFF}Code of Safe(%d): {F1C40F}%02d %02d %02d",
            safeid, SafeData[safeid][SafeNumbers][0], SafeData[safeid][SafeNumbers][1], SafeData[safeid][SafeNumbers][2]
        ));
        return SafeHacking:ManageSafe(playerid, safeid);
    }
    if (IsStringSame(inputtext, "Edit position")) {
        EditingSafeID[playerid] = safeid;
        EditDynamicObject(playerid, SafeData[safeid][SafeObject]);
        return 1;
    }
    if (IsStringSame(inputtext, "Remove position")) {
        // if there is someone cracking the specified safe, cancel their cracking
        foreach(new i:Player) if (CrackingSafeID[i] == safeid) SafeHacking:ResetPlayer(i);
        // destroy safe
        DestroyDynamicObjectEx(SafeData[safeid][SafeObject]);
        DestroyDynamic3DTextLabel(SafeData[safeid][SafeLabel]);
        if (SafeData[safeid][SafeTimer] != -1) KillTimer(SafeData[safeid][SafeTimer]);
        // reset variables
        SafeData[safeid][SafeOccupiedBy] = SafeData[safeid][SafeObject] = SafeData[safeid][SafeTimer] = -1;
        SafeData[safeid][SafeLabel] = Text3D:  - 1;
        SafeData[safeid][SafeMoney] = SafeData[safeid][SafeTimeLeft] = 0;
        for (new x; x < 3; x++) SafeData[safeid][SafeNumbers][x] = SafeData[safeid][SafeLocks][x] = !!0;
        Iter_Remove(Safes, safeid);
        new query[512];
        mysql_format(Database, query, sizeof(query), "DELETE FROM `cashSafes` WHERE `ID`='%d'", safeid);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, 0x3498DBFF, "[SAFE]: {FFFFFF}Safe created.");
        return SafeHacking:ManageSafeInput(playerid);
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Safe Hack system");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Safe Hack system", inputtext)) SafeHacking:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "safe hack system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    SafeHacking:AdminPanel(playerid);
    return ~1;
}