#define MAX_GATES   5000

enum DynamicGate:DataEnum {
    ObjectID,
    GName[50],
    Float:GPosOX,
    Float:GPosOY,
    Float:GPosOZ,
    Float:GPosORX,
    Float:GPosORY,
    Float:GPosORZ,
    Float:GPosCX,
    Float:GPosCY,
    Float:GPosCZ,
    Float:GPosCRX,
    Float:GPosCRY,
    Float:GPosCRZ,
    Float:Speed,
    Float:Distance,
    FactionID,
    bool:SignInRquired,
    PlayerID,
    ALevel,
    Tax,
    bool:Status,
    bool:Auto,

    GObjectID,
    bool:gstatus
}
new DynamicGate:Data[MAX_GATES][DynamicGate:DataEnum];
new Iterator:dynamicgates < MAX_GATES > ;
new bool:EditingoGate[MAX_PLAYERS];
new bool:EditingcGate[MAX_PLAYERS];
new EditingGate[MAX_PLAYERS];

stock DynamicGate:IsValid(gateid) {
    return Iter_Contains(dynamicgates, gateid);
}

forward LoadDynamicGates();
public LoadDynamicGates() {
    new rows = cache_num_rows();
    if (rows) {
        new Count = 0, gateid;
        while (Count < rows) {

            cache_get_value_name_int(Count, "ID", gateid);
            cache_get_value_name_int(Count, "ObjectID", DynamicGate:Data[gateid][ObjectID]);
            cache_get_value_name(Count, "GName", DynamicGate:Data[gateid][GName], .max_len = 50);
            cache_get_value_float(Count, "GPosOX", DynamicGate:Data[gateid][GPosOX]);
            cache_get_value_float(Count, "GPosOY", DynamicGate:Data[gateid][GPosOY]);
            cache_get_value_float(Count, "GPosOZ", DynamicGate:Data[gateid][GPosOZ]);
            cache_get_value_float(Count, "GPosORX", DynamicGate:Data[gateid][GPosORX]);
            cache_get_value_float(Count, "GPosORY", DynamicGate:Data[gateid][GPosORY]);
            cache_get_value_float(Count, "GPosORZ", DynamicGate:Data[gateid][GPosORZ]);
            cache_get_value_float(Count, "GPosCX", DynamicGate:Data[gateid][GPosCX]);
            cache_get_value_float(Count, "GPosCY", DynamicGate:Data[gateid][GPosCY]);
            cache_get_value_float(Count, "GPosCZ", DynamicGate:Data[gateid][GPosCZ]);
            cache_get_value_float(Count, "GPosCRX", DynamicGate:Data[gateid][GPosCRX]);
            cache_get_value_float(Count, "GPosCRY", DynamicGate:Data[gateid][GPosCRY]);
            cache_get_value_float(Count, "GPosCRZ", DynamicGate:Data[gateid][GPosCRZ]);
            cache_get_value_float(Count, "Speed", DynamicGate:Data[gateid][Speed]);
            cache_get_value_float(Count, "Distance", DynamicGate:Data[gateid][Distance]);
            cache_get_value_name_int(Count, "FactionID", DynamicGate:Data[gateid][FactionID]);
            cache_get_value_name_int(Count, "FactionSIR", DynamicGate:Data[gateid][SignInRquired]);
            cache_get_value_name_int(Count, "PlayerID", DynamicGate:Data[gateid][PlayerID]);
            cache_get_value_name_int(Count, "ALevel", DynamicGate:Data[gateid][ALevel]);
            cache_get_value_name_int(Count, "Tax", DynamicGate:Data[gateid][Tax]);
            cache_get_value_name_int(Count, "Status", DynamicGate:Data[gateid][Status]);
            cache_get_value_name_int(Count, "Auto", DynamicGate:Data[gateid][Auto]);
            DynamicGate:Data[gateid][GObjectID] = CreateDynamicObject(
                DynamicGate:Data[gateid][ObjectID], DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ],
                DynamicGate:Data[gateid][GPosCRX], DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ], -1, -1, -1
            );
            Iter_Add(dynamicgates, gateid);
            Count++;
        }
    }
    printf("  [Gate System] Loaded %d Gate's.", rows);
    return 1;
}

new TimerID_GateSystem;

hook OnGameModeExit() {
    DeletePreciseTimer(TimerID_GateSystem);
    return 1;
}

hook OnGameModeInit() {
    TimerID_GateSystem = SetPreciseTimer("GateSystemCheck", 1000, true);
    new query[1024];
    strcat(query, "CREATE TABLE IF NOT EXISTS `gates` (\
	  `ID` int(11) NOT NULL,\
	  `ObjectID` int(11) NOT NULL,\
	  `GName` varchar(50) NOT NULL,\
	  `GPosOX` float NOT NULL,\
	  `GPosOY` float NOT NULL,\
	  `GPosOZ` float NOT NULL,\
	  `GPosORX` float NOT NULL,\
	  `GPosORY` float NOT NULL,\
	  `GPosORZ` float NOT NULL,\
	  `GPosCX` float NOT NULL,\
	  `GPosCY` float NOT NULL,\
	  `GPosCZ` float NOT NULL,\
	  `GPosCRX` float NOT NULL,\
	  `GPosCRY` float NOT NULL,\
	  `GPosCRZ` float NOT NULL,");
    strcat(query, "`Speed` float NOT NULL,\
	  `Distance` float NOT NULL,\
	  `FactionID` int(11) NOT NULL,\
	  `FactionSIR` tinyint(1) NOT NULL,\
	  `PlayerID` int(11) NOT NULL,\
	  `ALevel` int(11) NOT NULL,\
	  `Tax` int(11) NOT NULL,\
	  `Status` tinyint(1) NOT NULL,\
	  `Auto` tinyint(1) NOT NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "select * from gates", "LoadDynamicGates", "");
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (EditingoGate[playerid]) {
        switch (response) {
            case EDIT_RESPONSE_CANCEL:  {
                new gateid = EditingGate[playerid];
                //Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
                SetDynamicObjectPos(objectid, DynamicGate:Data[gateid][GPosOX], DynamicGate:Data[gateid][GPosOY], DynamicGate:Data[gateid][GPosOZ]);
                SetDynamicObjectRot(objectid, DynamicGate:Data[gateid][GPosORX], DynamicGate:Data[gateid][GPosORY], DynamicGate:Data[gateid][GPosORZ]);

                EditingoGate[playerid] = false;
                DynamicGate:Manage(playerid, gateid);
            }

            case EDIT_RESPONSE_FINAL:  {
                new gateid = EditingGate[playerid];
                //Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
                DynamicGate:Data[gateid][GPosOX] = x;
                DynamicGate:Data[gateid][GPosOY] = y;
                DynamicGate:Data[gateid][GPosOZ] = z;
                DynamicGate:Data[gateid][GPosORX] = rx;
                DynamicGate:Data[gateid][GPosORY] = ry;
                DynamicGate:Data[gateid][GPosORZ] = rz;
                SetDynamicObjectPos(objectid, DynamicGate:Data[gateid][GPosOX], DynamicGate:Data[gateid][GPosOY], DynamicGate:Data[gateid][GPosOZ]);
                SetDynamicObjectRot(objectid, DynamicGate:Data[gateid][GPosORX], DynamicGate:Data[gateid][GPosORY], DynamicGate:Data[gateid][GPosORZ]);
                //Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
                mysql_tquery(Database, sprintf(
                    "UPDATE `gates` SET `GPosOX`='%f',`GPosOY`='%f',`GPosOZ`='%f',`GPosORX`='%f',`GPosORY`='%f',`GPosORZ`='%f' WHERE `ID`='%d'",
                    DynamicGate:Data[gateid][GPosOX], DynamicGate:Data[gateid][GPosOY], DynamicGate:Data[gateid][GPosOZ], DynamicGate:Data[gateid][GPosORX],
                    DynamicGate:Data[gateid][GPosORY], DynamicGate:Data[gateid][GPosORZ], gateid
                ));
                EditingoGate[playerid] = false;
                DynamicGate:Manage(playerid, gateid);
            }
        }
    }
    if (EditingcGate[playerid]) {
        switch (response) {
            case EDIT_RESPONSE_CANCEL:  {
                new gateid = EditingGate[playerid];
                //Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
                SetDynamicObjectPos(objectid, DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ]);
                SetDynamicObjectRot(objectid, DynamicGate:Data[gateid][GPosCRX], DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ]);

                EditingcGate[playerid] = false;
                DynamicGate:Manage(playerid, gateid);
            }

            case EDIT_RESPONSE_FINAL:  {
                new gateid = EditingGate[playerid];
                //Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
                DynamicGate:Data[gateid][GPosCX] = x;
                DynamicGate:Data[gateid][GPosCY] = y;
                DynamicGate:Data[gateid][GPosCZ] = z;
                DynamicGate:Data[gateid][GPosCRX] = rx;
                DynamicGate:Data[gateid][GPosCRY] = ry;
                DynamicGate:Data[gateid][GPosCRZ] = rz;
                SetDynamicObjectPos(objectid, DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ]);
                SetDynamicObjectRot(objectid, DynamicGate:Data[gateid][GPosCRX], DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ]);
                //Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);

                mysql_tquery(Database, sprintf(
                    "UPDATE `gates` SET `GPosCX`='%f',`GPosCY`='%f',`GPosCZ`='%f',`GPosCRX`='%f',`GPosCRY`='%f',`GPosCRZ`='%f' WHERE `ID`='%d'",
                    DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ], DynamicGate:Data[gateid][GPosCRX],
                    DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ], gateid
                ));

                EditingcGate[playerid] = false;
                DynamicGate:Manage(playerid, gateid);
            }
        }
    }
    return 1;
}

forward GateSystemCheck();
public GateSystemCheck() {
    foreach(new gateid:dynamicgates) {
        new bool:status = false;
        foreach(new playerid:Player) {
            if (IsPlayerConnected(playerid) && IsPlayerInRangeOfPoint(playerid, DynamicGate:Data[gateid][Distance], DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ])) {
                status = true;
                if (!IsTimePassedForPlayer(playerid, "gate system check", 5)) continue;
                if (DynamicGate:Data[gateid][gstatus]) {
                    new string[512];
                    if (!DynamicGate:Data[gateid][Status]) continue;
                    if (!DynamicGate:Data[gateid][Auto]) continue;
                    if (DynamicGate:Data[gateid][FactionID] != -1 && DynamicGate:Data[gateid][FactionID] != -2 && DynamicGate:Data[gateid][FactionID] != -3) {
                        if (DynamicGate:Data[gateid][FactionID] != Faction:GetPlayerFID(playerid)) {
                            format(string, sizeof(string), "{4286f4}[%s]:{FFFFFF} you are not authorized to access the gate[%d]", Faction:GetName(DynamicGate:Data[gateid][FactionID]), gateid);
                            SendClientMessageEx(playerid, -1, string);
                            continue;
                        }
                        if (DynamicGate:Data[gateid][SignInRquired] && DynamicGate:Data[gateid][FactionID] == Faction:GetPlayerFID(playerid) && !Faction:IsPlayerSigned(playerid)) {
                            format(string, sizeof(string), "{4286f4}[%s]:{FFFFFF} you need to sign in to access the gate[%d]", Faction:GetName(DynamicGate:Data[gateid][FactionID]), gateid);
                            SendClientMessageEx(playerid, -1, string);
                            continue;
                        }
                    }
                    if (DynamicGate:Data[gateid][FactionID] == -2 || DynamicGate:Data[gateid][FactionID] == -3) {
                        if (WantedDatabase:IsInJail(playerid)) continue;
                        new lawFactions[] = { 0, 1, 2, 3 };
                        new mafiaFactions[] = { 5, 7, 8, 9, 10 };

                        if (DynamicGate:Data[gateid][FactionID] == -2 && !IsArrayContainNumber(lawFactions, Faction:GetPlayerFID(playerid))) {
                            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you do not have access to this gate");
                            continue;
                        }
                        if (DynamicGate:Data[gateid][FactionID] == -3 && !IsArrayContainNumber(mafiaFactions, Faction:GetPlayerFID(playerid))) {
                            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you do not have access to this gate");
                            continue;
                        }
                        if (DynamicGate:Data[gateid][SignInRquired] && !Faction:IsPlayerSigned(playerid)) {
                            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you should be signed in to access this gate");
                            continue;
                        }
                    }
                    if (DynamicGate:Data[gateid][PlayerID] != GetPlayerID(playerid) && DynamicGate:Data[gateid][PlayerID] != -1) {
                        format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are not authorized to access the gate[%d], Kindly Request to player gateid:%d", gateid, DynamicGate:Data[gateid][PlayerID]);
                        SendClientMessageEx(playerid, -1, string);
                        continue;
                    }
                    if (GetPlayerAdminLevel(playerid) < DynamicGate:Data[gateid][ALevel] && DynamicGate:Data[gateid][ALevel] != -1) {
                        format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are not authorized to access the gate[%d], Kindly Request to Admin Player Having Level <= %d", gateid, DynamicGate:Data[gateid][ALevel]);
                        SendClientMessageEx(playerid, -1, string);
                        continue;
                    }
                    if (DynamicGate:Data[gateid][Tax] != 0) {
                        if (IsPlayerInAnyVehicle(playerid)) {
                            if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) continue;
                            if (GetPlayerCash(playerid) < DynamicGate:Data[gateid][Tax]) {
                                format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are required to have $%s to access this gate[%d]", FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid);
                                SendClientMessageEx(playerid, -1, string);
                                continue;
                            }
                            format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are charged with $%s for accessing this gate[%d]", FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid);
                            SendClientMessageEx(playerid, -1, string);
                            GivePlayerCash(playerid, -1 * DynamicGate:Data[gateid][Tax], sprintf("[Alexa]:you are charged with $%s for accessing gate [%d]", FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid));
                            vault:addcash(Vault_ID_Government, DynamicGate:Data[gateid][Tax], Vault_Transaction_Cash_To_Vault, sprintf("%s charged with $%s for accessing gate [%d]", GetPlayerNameEx(playerid), FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid));
                        }
                    }
                    MoveDynamicObject(
                        DynamicGate:Data[gateid][GObjectID], DynamicGate:Data[gateid][GPosOX], DynamicGate:Data[gateid][GPosOY],
                        DynamicGate:Data[gateid][GPosOZ], DynamicGate:Data[gateid][Speed], DynamicGate:Data[gateid][GPosORX],
                        DynamicGate:Data[gateid][GPosORY], DynamicGate:Data[gateid][GPosORZ]
                    );
                    format(string, sizeof(string), "~w~Opening ~r~%s~y~[%d] ~w~Gate", DynamicGate:Data[gateid][GName], gateid);
                    GameTextForPlayer(playerid, string, 1000, 3);
                    DynamicGate:Data[gateid][gstatus] = false;
                }
                continue;
            }
        }
        if (!DynamicGate:Data[gateid][gstatus] && !status) {
            MoveDynamicObject(
                DynamicGate:Data[gateid][GObjectID], DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY],
                DynamicGate:Data[gateid][GPosCZ], DynamicGate:Data[gateid][Speed], DynamicGate:Data[gateid][GPosCRX],
                DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ]
            );
            DynamicGate:Data[gateid][gstatus] = true;
        }
    }
    return 1;
}

stock DynamicGate:CommandOpen(playerid) {
    new string[512];
    foreach(new gateid:dynamicgates) {
        if (IsPlayerInRangeOfPoint(playerid, DynamicGate:Data[gateid][Distance], DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ])) {
            if (DynamicGate:Data[gateid][gstatus]) {
                if (!DynamicGate:Data[gateid][Status]) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFFF}Gate is not in service");
                if (DynamicGate:Data[gateid][Auto]) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFFF}Gate is automatic");
                if (DynamicGate:Data[gateid][FactionID] != -1 && DynamicGate:Data[gateid][FactionID] != -2 && DynamicGate:Data[gateid][FactionID] != -3) {
                    if (DynamicGate:Data[gateid][FactionID] != Faction:GetPlayerFID(playerid)) {
                        format(string, sizeof(string), "{4286f4}[%s]:{FFFFFF} you are not authorized to access the gate", Faction:GetName(DynamicGate:Data[gateid][FactionID]));
                        return SendClientMessageEx(playerid, -1, string);
                    }
                    if (DynamicGate:Data[gateid][SignInRquired] && DynamicGate:Data[gateid][FactionID] == Faction:GetPlayerFID(playerid) && !Faction:IsPlayerSigned(playerid)) {
                        format(string, sizeof(string), "{4286f4}[%s]:{FFFFFF} you need to sign in to access the gate", Faction:GetName(DynamicGate:Data[gateid][FactionID]));
                        return SendClientMessageEx(playerid, -1, string);
                    }
                }
                if (DynamicGate:Data[gateid][FactionID] == -2 || DynamicGate:Data[gateid][FactionID] == -3) {
                    if (WantedDatabase:IsInJail(playerid)) continue;
                    new lawFactions[] = { 0, 1, 2, 3 };
                    new mafiaFactions[] = { 5, 7, 8, 9, 10 };

                    if (DynamicGate:Data[gateid][FactionID] == -2 && !IsArrayContainNumber(lawFactions, Faction:GetPlayerFID(playerid))) {
                        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you do not have access to this gate");
                        continue;
                    }
                    if (DynamicGate:Data[gateid][FactionID] == -3 && !IsArrayContainNumber(mafiaFactions, Faction:GetPlayerFID(playerid))) {
                        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you do not have access to this gate");
                        continue;
                    }
                    if (DynamicGate:Data[gateid][SignInRquired] && !Faction:IsPlayerSigned(playerid)) {
                        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you should be signed in to access this gate");
                        continue;
                    }
                }
                if (DynamicGate:Data[gateid][PlayerID] != GetPlayerID(playerid) && DynamicGate:Data[gateid][PlayerID] != -1) {
                    format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are not authorized to access the gate, Kindly Request to player gateid:%d", DynamicGate:Data[gateid][PlayerID]);
                    return SendClientMessageEx(playerid, -1, string);
                }
                if (GetPlayerAdminLevel(playerid) < DynamicGate:Data[gateid][ALevel] && DynamicGate:Data[gateid][ALevel] != -1) {
                    format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are not authorized to access the gate, Kindly Request to Admin Player Having Level <= %d", DynamicGate:Data[gateid][ALevel]);
                    return SendClientMessageEx(playerid, -1, string);
                }
                if (DynamicGate:Data[gateid][Tax] != 0) {
                    if (IsPlayerInAnyVehicle(playerid)) {
                        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) continue;
                        if (GetPlayerCash(playerid) < DynamicGate:Data[gateid][Tax]) {
                            format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are required to have $%s to access this gate", FormatCurrency(DynamicGate:Data[gateid][Tax]));
                            return SendClientMessageEx(playerid, -1, string);
                        }
                        format(string, sizeof(string), "{4286f4}[Alexa]:{FFFFFF} you are charged with $%s for accessing this gate", FormatCurrency(DynamicGate:Data[gateid][Tax]));
                        SendClientMessageEx(playerid, -1, string);
                        GivePlayerCash(playerid, -1 * DynamicGate:Data[gateid][Tax], sprintf("[Alexa]:you are charged with $%s for accessing gate [%d]", FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid));
                        vault:addcash(Vault_ID_Government, DynamicGate:Data[gateid][Tax], Vault_Transaction_Cash_To_Vault, sprintf("%s charged with $%s for accessing gate [%d]", GetPlayerNameEx(playerid), FormatCurrency(DynamicGate:Data[gateid][Tax]), gateid));
                    }
                }
                MoveDynamicObject(DynamicGate:Data[gateid][GObjectID], DynamicGate:Data[gateid][GPosOX], DynamicGate:Data[gateid][GPosOY], DynamicGate:Data[gateid][GPosOZ], DynamicGate:Data[gateid][Speed], DynamicGate:Data[gateid][GPosORX], DynamicGate:Data[gateid][GPosORY], DynamicGate:Data[gateid][GPosORZ]);
                format(string, sizeof(string), "~w~Opening ~r~%s~y~[%d] ~w~Gate", DynamicGate:Data[gateid][GName], gateid);
                GameTextForPlayer(playerid, string, 1000, 3);
                DynamicGate:Data[gateid][gstatus] = false;
                return 1;
            }
        }
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Gate System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Gate System", inputtext)) DynamicGate:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "gate system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    DynamicGate:AdminPanel(playerid);
    return ~1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_SECONDARY_ATTACK) DynamicGate:CommandOpen(playerid);
    return 1;
}

stock DynamicGate:AdminPanel(playerid) {
    new string[1024];
    strcat(string, "Manage gate\n");
    strcat(string, "Create gate\n");
    return FlexPlayerDialog(playerid, "DynamicGateAdminPanel", DIALOG_STYLE_TABLIST, "Gate System", string, "Select", "Close");
}

FlexDialog:DynamicGateAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage gate")) return DynamicGate:ManageInput(playerid);
    if (IsStringSame(inputtext, "Create gate")) return DynamicGate:CreateInput(playerid);
    return 1;
}

stock DynamicGate:CreateInput(playerid) {
    return FlexPlayerDialog(playerid, "DynamicGateCreateInput", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter following Details\n[ObjectID] [GateName]\nInvalid Input", "Submit", "Close");
}

FlexDialog:DynamicGateCreateInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DynamicGate:AdminPanel(playerid);
    new objectID, gateName[50], Float:x, Float:y, Float:z;
    new gateid = Iter_Free(dynamicgates);
    if (gateid == INVALID_ITERATOR_SLOT || sscanf(inputtext, "is[50]", objectID, gateName) || objectID < 0) return DynamicGate:CreateInput(playerid);
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    SetPlayerPosEx(playerid, x, y + 2, z);
    DynamicGate:Data[gateid][ObjectID] = objectID;
    DynamicGate:Data[gateid][GName] = gateName;
    DynamicGate:Data[gateid][GPosOX] = x;
    DynamicGate:Data[gateid][GPosOY] = y;
    DynamicGate:Data[gateid][GPosOZ] = z;
    DynamicGate:Data[gateid][GPosORX] = 0;
    DynamicGate:Data[gateid][GPosORY] = 0;
    DynamicGate:Data[gateid][GPosORZ] = 0;
    DynamicGate:Data[gateid][GPosCX] = x;
    DynamicGate:Data[gateid][GPosCY] = y;
    DynamicGate:Data[gateid][GPosCZ] = z;
    DynamicGate:Data[gateid][GPosCRX] = 0;
    DynamicGate:Data[gateid][GPosCRY] = 0;
    DynamicGate:Data[gateid][GPosCRZ] = 0;
    DynamicGate:Data[gateid][Speed] = 1;
    DynamicGate:Data[gateid][Distance] = 10;
    DynamicGate:Data[gateid][FactionID] = -1;
    DynamicGate:Data[gateid][SignInRquired] = false;
    DynamicGate:Data[gateid][PlayerID] = -1;
    DynamicGate:Data[gateid][ALevel] = -1;
    DynamicGate:Data[gateid][Tax] = 0;
    DynamicGate:Data[gateid][Status] = TRUE;
    DynamicGate:Data[gateid][Auto] = TRUE;
    DynamicGate:Data[gateid][GObjectID] = CreateDynamicObject(objectID, x, y, z, 0, 0, 0, -1, -1, -1);
    mysql_tquery(Database, sprintf(
        "INSERT INTO `gates`(`ID`, `ObjectID`, `GName`, `GPosOX`, `GPosOY`, `GPosOZ`, `GPosORX`, `GPosORY`, `GPosORZ`, `GPosCX`, `GPosCY`, \
        `GPosCZ`, `GPosCRX`, `GPosCRY`, `GPosCRZ`, `Speed`, `Distance`, `FactionID`, `FactionSIR`, `PlayerID`, `ALevel`, `Tax`, `Status`, `Auto`) \
        VALUES ('%d','%d',\"%s\",'%f','%f','%f','%f','%f','%f','%f','%f','%f','%f','%f','%f','%f','%f','%d','%d','%d','%d','%d','%d', '%d')",
        gateid, DynamicGate:Data[gateid][ObjectID], DynamicGate:Data[gateid][GName], DynamicGate:Data[gateid][GPosOX],
        DynamicGate:Data[gateid][GPosOY], DynamicGate:Data[gateid][GPosOZ], DynamicGate:Data[gateid][GPosORX], DynamicGate:Data[gateid][GPosORY],
        DynamicGate:Data[gateid][GPosORZ], DynamicGate:Data[gateid][GPosCX], DynamicGate:Data[gateid][GPosCY], DynamicGate:Data[gateid][GPosCZ],
        DynamicGate:Data[gateid][GPosCRX], DynamicGate:Data[gateid][GPosCRY], DynamicGate:Data[gateid][GPosCRZ], DynamicGate:Data[gateid][Speed],
        DynamicGate:Data[gateid][Distance], DynamicGate:Data[gateid][FactionID], DynamicGate:Data[gateid][SignInRquired], DynamicGate:Data[gateid][PlayerID],
        DynamicGate:Data[gateid][ALevel], DynamicGate:Data[gateid][Tax], DynamicGate:Data[gateid][Status], DynamicGate:Data[gateid][Auto]
    ));
    Iter_Add(dynamicgates, gateid);
    AlexaMsg(playerid, sprintf("created gate id %d", gateid));
    return DynamicGate:AdminPanel(playerid);
}

stock DynamicGate:ManageInput(playerid) {
    return FlexPlayerDialog(playerid, "DynamicGateManageInput", DIALOG_STYLE_INPUT, "Manage Gate", "Enter gate id", "Manage", "Close");
}

FlexDialog:DynamicGateManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DynamicGate:AdminPanel(playerid);
    new gateid;
    if (sscanf(inputtext, "d", gateid) || !DynamicGate:IsValid(gateid)) return DynamicGate:ManageInput(playerid);
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:Manage(playerid, gateid) {
    new string[1024];
    strcat(string, "Teleport to Gate\n");
    strcat(string, "Set Gate Open Position\n");
    strcat(string, "Set Gate Close Position\n");
    strcat(string, "Set Gate Speed\n");
    strcat(string, "Set Gate Distance\n");
    strcat(string, "Set Gate Name\n");
    strcat(string, "Set Gate Faction\n");
    strcat(string, "Set Gate Faction Sign Required\n");
    strcat(string, "Set Gate Player\n");
    strcat(string, "Set Gate Admin Level\n");
    strcat(string, "Set Gate Tax\n");
    strcat(string, "Set Gate Type\n");
    strcat(string, "Set Gate Status\n");
    strcat(string, "Remove Gate\n");
    return FlexPlayerDialog(playerid, "DynamicGateManage", DIALOG_STYLE_LIST, "Manage Gate", string, "Select", "Close", gateid);
}

FlexDialog:DynamicGateManage(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Teleport to Gate")) {
        SetPlayerPosEx(playerid, DynamicGate:Data[gateid][GPosCX] + 1, DynamicGate:Data[gateid][GPosCY] + 1, DynamicGate:Data[gateid][GPosCZ] + 1);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF} you are teleported to gate.");
        return DynamicGate:Manage(playerid, gateid);
    }
    if (IsStringSame(inputtext, "Set Gate Open Position")) {
        EditDynamicObject(playerid, DynamicGate:Data[gateid][GObjectID]);
        EditingoGate[playerid] = true;
        EditingGate[playerid] = gateid;
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Gate Opening Position Chnaged.");
    }
    if (IsStringSame(inputtext, "Set Gate Close Position")) {
        EditingcGate[playerid] = true;
        EditingGate[playerid] = gateid;
        EditDynamicObject(playerid, DynamicGate:Data[gateid][GObjectID]);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Gate Closing Position Chnaged.");
    }
    if (IsStringSame(inputtext, "Set Gate Speed")) return DynamicGate:InputSetGateSpeed(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Distance")) return DynamicGate:InputSetGateDistance(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Name")) return DynamicGate:InputSetGateName(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Faction")) return DynamicGate:InputSetGateFaction(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Faction Sign Required")) return DynamicGate:InputSetGateFactionSign(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Player")) return DynamicGate:InputSetGatePlayer(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Admin Level")) return DynamicGate:InputSetGateAdminLevel(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Tax")) return DynamicGate:InputSetGateTax(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Type")) return DynamicGate:InputSetGateType(playerid, gateid);
    if (IsStringSame(inputtext, "Set Gate Status")) return DynamicGate:InputSetGateStatus(playerid, gateid);
    if (IsStringSame(inputtext, "Remove Gate")) {
        mysql_tquery(Database, sprintf("delete from gates where id = %d", gateid));
        DestroyDynamicObjectEx(DynamicGate:Data[gateid][GObjectID]);
        Iter_Remove(dynamicgates, gateid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}Gate Removed.");
        return DynamicGate:AdminPanel(playerid);
    }
    return 1;
}

stock DynamicGate:InputSetGateSpeed(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateSpeed", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate speed", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateSpeed(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new Float:gatespeed;
    if (sscanf(inputtext, "f", gatespeed)) return DynamicGate:InputSetGateSpeed(playerid, gateid);
    DynamicGate:Data[gateid][Speed] = gatespeed;
    mysql_tquery(Database, sprintf("UPDATE gates SET Speed = %f WHERE ID = %d", DynamicGate:Data[gateid][Speed], gateid));
    AlexaMsg(playerid, "gate speed updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateDistance(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateDistance", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate distance", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateDistance(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new Float:gatedistance;
    if (sscanf(inputtext, "f", gatedistance)) return DynamicGate:InputSetGateDistance(playerid, gateid);
    DynamicGate:Data[gateid][Distance] = gatedistance;
    mysql_tquery(Database, sprintf("UPDATE gates SET Distance = %f WHERE ID = %d", DynamicGate:Data[gateid][Distance], gateid));
    AlexaMsg(playerid, "gate distance updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateName(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateName", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate name", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateName(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new gatename[50];
    if (sscanf(inputtext, "s[50]", gatename)) return DynamicGate:InputSetGateName(playerid, gateid);
    DynamicGate:Data[gateid][GName] = gatename;
    mysql_tquery(Database, sprintf("UPDATE gates SET GName = \"%s\" WHERE ID = %d", DynamicGate:Data[gateid][GName], gateid));
    AlexaMsg(playerid, "gate name updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateFaction(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateFaction", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate faction", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateFaction(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new factionid;
    if (sscanf(inputtext, "d", factionid)) return DynamicGate:InputSetGateFaction(playerid, gateid);
    DynamicGate:Data[gateid][FactionID] = factionid;
    mysql_tquery(Database, sprintf("UPDATE gates SET FactionID = %d WHERE ID = %d", DynamicGate:Data[gateid][FactionID], gateid));
    AlexaMsg(playerid, "gate faction updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateFactionSign(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateFactionSign", DIALOG_STYLE_INPUT, "Update Gate", "Enter faction required or not?", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateFactionSign(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new bool:status;
    if (sscanf(inputtext, "l", status)) return DynamicGate:InputSetGateFactionSign(playerid, gateid);
    DynamicGate:Data[gateid][SignInRquired] = status;
    mysql_tquery(Database, sprintf("UPDATE gates SET FactionSIR = %d WHERE ID = %d", DynamicGate:Data[gateid][SignInRquired], gateid));
    AlexaMsg(playerid, "gate speed updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGatePlayer(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGatePlayer", DIALOG_STYLE_INPUT, "Update Gate", "Enter playerid or name", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGatePlayer(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new pId;
    if (sscanf(inputtext, "d", pId) || !IsPlayerConnected(pId) && pId != (-1)) return DynamicGate:InputSetGatePlayer(playerid, gateid);
    if (pId == (-1)) DynamicGate:Data[gateid][PlayerID] = -1;
    if (pId != (-1)) DynamicGate:Data[gateid][PlayerID] = GetPlayerID(pId);
    mysql_tquery(Database, sprintf("UPDATE gates SET PlayerID = %d WHERE ID = %d", DynamicGate:Data[gateid][PlayerID], gateid));
    AlexaMsg(playerid, "gate playerid updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateAdminLevel(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateAdminLevel", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate admin level", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateAdminLevel(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new adminLevelx;
    if (sscanf(inputtext, "f", adminLevelx)) return DynamicGate:InputSetGateAdminLevel(playerid, gateid);
    DynamicGate:Data[gateid][ALevel] = adminLevelx;
    mysql_tquery(Database, sprintf("UPDATE gates SET ALevel = %d WHERE ID = %d", DynamicGate:Data[gateid][ALevel], gateid));
    AlexaMsg(playerid, "gate admin level updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateTax(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateTax", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate fee", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateTax(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new tax;
    if (sscanf(inputtext, "d", tax)) return DynamicGate:InputSetGateTax(playerid, gateid);
    DynamicGate:Data[gateid][Tax] = tax;
    mysql_tquery(Database, sprintf("UPDATE gates SET Tax = %d WHERE ID = %d", DynamicGate:Data[gateid][Tax], gateid));
    AlexaMsg(playerid, "gate tax updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateType(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateType", DIALOG_STYLE_INPUT, "Update Gate", "Entet gate type", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateType(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new bool:type;
    if (sscanf(inputtext, "l", type)) return DynamicGate:InputSetGateType(playerid, gateid);
    DynamicGate:Data[gateid][Auto] = type;
    mysql_tquery(Database, sprintf("UPDATE gates SET Auto = %d WHERE ID = %d", DynamicGate:Data[gateid][Auto], gateid));
    AlexaMsg(playerid, "gate speed updated");
    return DynamicGate:Manage(playerid, gateid);
}

stock DynamicGate:InputSetGateStatus(playerid, gateid) {
    return FlexPlayerDialog(playerid, "GateInputSetGateStatus", DIALOG_STYLE_INPUT, "Update Gate", "Enter gate status", "Update", "Cancel", gateid);
}

FlexDialog:GateInputSetGateStatus(playerid, response, listitem, const inputtext[], gateid, const payload[]) {
    if (!response) return DynamicGate:Manage(playerid, gateid);
    new bool:status;
    if (sscanf(inputtext, "l", status)) return DynamicGate:InputSetGateStatus(playerid, gateid);
    DynamicGate:Data[gateid][Status] = status;
    mysql_tquery(Database, sprintf("UPDATE gates SET Status = %d WHERE ID = %d", DynamicGate:Data[gateid][Status], gateid));
    AlexaMsg(playerid, "gate speed updated");
    return DynamicGate:Manage(playerid, gateid);
}