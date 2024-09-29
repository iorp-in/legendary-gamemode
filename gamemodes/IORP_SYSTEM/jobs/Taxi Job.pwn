

new TAXI_DIALOG, TAXI_DIALOG1, TAXI_DIALOG2, TAXI_DIALOG3, TAXI_DIALOG4, TAXI_DIALOG5;
#define TAXI_PRICEROUT		0.6
new TAXI_PRICERENT = 500;
#define MAX_TAXI            3

/*******************************************************************************/

new TaxiJob_CP[MAX_PLAYERS];
new bool:TaxiJobStarted[MAX_PLAYERS];
new bool:PlayerEnteredPoint[MAX_PLAYERS];
new bool:PlayerCalledTaxi[MAX_PLAYERS];
new bool:PlayerRentTaxi[MAX_PLAYERS];
new bool:PlayerTaxiStarted[MAX_PLAYERS];
new ExitCarTimer[MAX_PLAYERS];
new TaxiDialogTimer[MAX_PLAYERS];
new PlayerService[MAX_PLAYERS];
new GetPlayerRentTaxi[MAX_PLAYERS];
new PlayerExitCount[MAX_PLAYERS];
new Float:FIRSTPOS[MAX_PLAYERS][3];
new Float:LASTPOS[MAX_PLAYERS][3];
new TAXI_ID[MAX_TAXI];
new Text3D:TAXI_TEXT[MAX_TAXI];

enum tInfo {
    tModel,
    Float:tPosX,
    Float:tPosY,
    Float:tPosZ,
    Float:tPosA
};
new TaxiInfo[MAX_TAXI][tInfo] = {
    {
        420,
        1736.6744,
        -1859.7969,
        13.2723,
        270.0
    },
    {
        420,
        1745.0928,
        -1859.7969,
        13.2709,
        270.0
    },
    {
        420,
        1762.7397,
        -1859.7969,
        13.2713,
        270.0
    }
};

stock GetPlayerPoint(playerid) {
    new zone[32], bool:getzone;
    for (new i = 0; i < sizeof(SAZones); i++) {
        if (LASTPOS[playerid][0] >= SAZones[i][SAZONE_AREA][0] &&
            LASTPOS[playerid][0] <= SAZones[i][SAZONE_AREA][0] &&
            LASTPOS[playerid][1] >= SAZones[i][SAZONE_AREA][0] &&
            LASTPOS[playerid][1] <= SAZones[i][SAZONE_AREA][0]) {
            format(zone, sizeof(zone), SAZones[i][SAZONE_NAME]);
            getzone = true;
            break;
        }
    }
    if (!getzone) zone = "Unknown";
    return zone;
}

hook OnGameModeInit() {
    TAXI_DIALOG = Dialog:GetFreeID();
    TAXI_DIALOG1 = Dialog:GetFreeID();
    TAXI_DIALOG2 = Dialog:GetFreeID();
    TAXI_DIALOG3 = Dialog:GetFreeID();
    TAXI_DIALOG4 = Dialog:GetFreeID();
    TAXI_DIALOG5 = Dialog:GetFreeID();
    new str[32];
    for (new i = 0; i < MAX_TAXI; i++) {
        TAXI_ID[i] = CreateVehicle(TaxiInfo[i][tModel], TaxiInfo[i][tPosX], TaxiInfo[i][tPosY], TaxiInfo[i][tPosZ], TaxiInfo[i][tPosA], 6, 6, -1);
        format(str, sizeof(str), "{000000}TAXI %d", i + 1);
        SetVehicleNumberPlate(TAXI_ID[i], str);
        SetVehicleToRespawn(TAXI_ID[i]);
        TAXI_TEXT[i] = CreateDynamic3DTextLabel("[{FFFFFF}taxi {DEF200}] \n{13EB3A} is free", 0xDEF200FF, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, TAXI_ID[i], 1, -1, -1, -1);
    }
    return 1;
}

hook OnGameModeExit() {
    for (new i = 0; i < MAX_TAXI; i++) {
        DestroyVehicle(TAXI_ID[i]);
        TAXI_ID[i] = INVALID_VEHICLE_ID;
        DestroyDynamic3DTextLabel(TAXI_TEXT[i]);
    }
    foreach(new i:Player) {
        if (IsPlayerConnected(i)) {
            PlayerEnteredPoint[i] = false;
            GetPlayerRentTaxi[i] = INVALID_VEHICLE_ID;
            PlayerRentTaxi[i] = false;
            PlayerCalledTaxi[i] = false;
            TaxiJobStarted[i] = false;
            PlayerTaxiStarted[i] = false;
            PlayerService[i] = INVALID_PLAYER_ID;
            foreach(new d:Player) {
                if (IsPlayerConnected(d) && PlayerCalledTaxi[d]) RemovePlayerMapIcon(i, d);
            }
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    PlayerEnteredPoint[playerid] = false;
    GetPlayerRentTaxi[playerid] = INVALID_VEHICLE_ID;
    PlayerRentTaxi[playerid] = false;
    PlayerCalledTaxi[playerid] = false;
    TaxiJobStarted[playerid] = false;
    PlayerTaxiStarted[playerid] = false;
    PlayerService[playerid] = INVALID_PLAYER_ID;
    TaxiJob_CP[playerid] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsValidDynamicCP(TaxiJob_CP[playerid])) DestroyDynamicCP(TaxiJob_CP[playerid]);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    foreach(new i:Player) {
        if (IsPlayerConnected(i) && GetPlayerRentTaxi[i] == vehicleid) {
            SendClientMessageEx(i, -1, "{E63030}Your work machine was destroyed");
            KillTimer(ExitCarTimer[i]);
            GetPlayerRentTaxi[i] = INVALID_VEHICLE_ID;
            TaxiJobStarted[i] = false;
            PlayerTaxiStarted[i] = false;
            foreach(new d:Player) {
                if (IsPlayerConnected(d) && PlayerCalledTaxi[d]) RemovePlayerMapIcon(i, d);
            }
            break;
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    if (IsTaxiCar(vehicleid) && TaxiJobStarted[playerid] && GetPlayerRentTaxi[playerid] == vehicleid) {
        new Float:hp;
        GetVehicleHealth(vehicleid, hp);
        if (hp < 250) return 1;
        PlayerExitCount[playerid] = 10;
        SendClientMessageEx(playerid, -1, "{E63030} Get back in the taxi!");
        KillTimer(ExitCarTimer[playerid]);
        ExitCarTimer[playerid] = SetTimerEx("OnPlayerExitCar", 1000, true, "i", playerid);
        return 1;
    }
    if (GetPlayerCarDriver(playerid) == INVALID_PLAYER_ID) return 1;
    if (IsTaxiCar(vehicleid) && PlayerTaxiStarted[GetPlayerCarDriver(playerid)] && PlayerEnteredPoint[playerid]) {
        new string[128];
        if (IsValidDynamicCP(TaxiJob_CP[playerid])) DestroyDynamicCP(TaxiJob_CP[playerid]);
        if (IsValidDynamicCP(TaxiJob_CP[GetPlayerCarDriver(playerid)])) DestroyDynamicCP(TaxiJob_CP[GetPlayerCarDriver(playerid)]);
        GivePlayerCash(playerid, -GetPriceTaxiEx(playerid), "charged for taxi");
        GivePlayerCash(GetPlayerCarDriver(playerid), GetPriceTaxiEx(playerid), "earned from taxi job");
        format(string, sizeof(string), "~g~+%d$", GetPriceTaxiEx(playerid));
        GameTextForPlayer(GetPlayerCarDriver(playerid), string, 1000, 1);
        format(string, sizeof(string), "~r~-%d$", GetPriceTaxiEx(playerid));
        GameTextForPlayer(playerid, string, 1000, 1);
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, 24);
        format(string, sizeof(string), "{7FC0E3}Passenger {B7E1F7}%s {7FC0E3}left the taxi earlier than it was supposed to.", name);
        SendClientMessageEx(GetPlayerCarDriver(playerid), -1, string);
        SendClientMessageEx(playerid, -1, "You left the taxi earlier than it was supposed to.");
        PlayerTaxiStarted[GetPlayerCarDriver(playerid)] = false;
        for (new i = 0; i < MAX_TAXI; i++) {
            if (TAXI_ID[i] == GetPlayerVehicleID(GetPlayerCarDriver(playerid))) {
                UpdateDynamic3DTextLabelText(TAXI_TEXT[i], 0xDEF200FF, "[{FFFFFF} taxi {DEF200}] \n {13EB3A} is free");
                break;
            }
        }
        return 1;
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    new string[128], vehicleid = GetPlayerVehicleID(playerid);
    if (newstate == PLAYER_STATE_DRIVER && IsTaxiCar(vehicleid)) {
        if (GetPlayerRentTaxi[playerid] != vehicleid) {
            format(string, sizeof(string), "{FFFFFF}\
  			To work in a taxi, you need to rent it. \n \
			Rental price:{CECECE}%d$ \
			", TAXI_PRICERENT);
            ShowPlayerDialogEx(playerid, TAXI_DIALOG, 0, DIALOG_STYLE_MSGBOX, "Rent a taxi", string, "YES", "NO");
            PlayerRentTaxi[playerid] = true;
            TaxiDialogTimer[playerid] = SetTimerEx("OnPlayerShowTaxiDialog", 1000, true, "i", playerid);
        } else {
            KillTimer(ExitCarTimer[playerid]);
        }
    }
    if (newstate == PLAYER_STATE_PASSENGER && IsTaxiCar(vehicleid) && GetPlayerRentTaxi[playerid] != vehicleid) {
        new bool:owned;
        foreach(new i:Player) {
            if (IsPlayerConnected(i) && IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == 0 && GetPlayerRentTaxi[i] == vehicleid && TaxiJobStarted[i]) {
                owned = true;
                break;
            }
        }
        if (!owned) return RemovePlayerFromVehicle(playerid);
        new bool:onepass;
        foreach(new i:Player) {
            if (IsPlayerConnected(i) && IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) != 0 && i != playerid) {
                onepass = true;
                break;
            }
        }
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, 24);
        if (PlayerCalledTaxi[playerid]) {
            PlayerCalledTaxi[playerid] = false;
            foreach(new i:Player) {
                if (IsPlayerConnected(i) && TaxiJobStarted[i]) RemovePlayerMapIcon(i, playerid);
            }
        }
        if (onepass) {
            format(string, sizeof(string), "{7FC0E3}The passenger sat in a taxi {B7E1F7}%s", name);
            SendClientMessageEx(GetPlayerCarDriver(playerid), -1, string);
            return 1;
        }
        PlayerEnteredPoint[playerid] = false;
        format(string, sizeof(string), "{7FC0E3}A passenger {B7E1F7}%s {CECECE} has boarded a taxi for you (wait until he chooses a route)", name);
        SendClientMessageEx(GetPlayerCarDriver(playerid), -1, string);
        ShowPlayerDialogEx(playerid, TAXI_DIALOG5, 0, DIALOG_STYLE_MSGBOX, "Information", "{00FFFF}\
		Set the marker on the map to that place,\n\
		in which you need to go.", "Close", "");
    }
    return 1;
}

hook OnPlayerEnterCP(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if (PlayerTaxiStarted[playerid] && IsTaxiCar(vehicleid)) {
        new string[128];
        if (IsValidDynamicCP(TaxiJob_CP[playerid])) DestroyDynamicCP(TaxiJob_CP[playerid]);
        if (IsValidDynamicCP(TaxiJob_CP[GetPlayerCarPass(playerid)])) DestroyDynamicCP(TaxiJob_CP[GetPlayerCarPass(playerid)]);
        TogglePlayerControllable(playerid, false);
        SetTimerEx("OnPlayerFinishedRace", 700, false, "i", playerid);
        ShowPlayerDialogEx(GetPlayerCarPass(playerid), TAXI_DIALOG4, 0, DIALOG_STYLE_LIST, "How did you get serviced?", "\
		+ Excellent \n + Good \n + Bad \n + Terrible ", " Select ", " Cancel ");
        SendClientMessageEx(playerid, -1, "You have reached your destination.");
        SendClientMessageEx(GetPlayerCarPass(playerid), -1, "You have reached your destination.");
        GivePlayerCash(playerid, GetPriceTaxi(playerid), "earned from taxi job");
        GivePlayerCash(GetPlayerCarPass(playerid), -GetPriceTaxi(playerid), "charged for taxi");
        format(string, sizeof(string), "~g~+%d$", GetPriceTaxi(playerid));
        GameTextForPlayer(playerid, string, 1000, 1);
        format(string, sizeof(string), "~r~-%d$", GetPriceTaxi(playerid));
        GameTextForPlayer(GetPlayerCarPass(playerid), string, 1000, 1);
        PlayerTaxiStarted[playerid] = false;
        for (new i = 0; i < MAX_TAXI; i++) {
            if (TAXI_ID[i] == GetPlayerVehicleID(playerid)) {
                UpdateDynamic3DTextLabelText(TAXI_TEXT[i], 0xDEF200FF, "[{FFFFFF}taxi {DEF200}] \n {13EB3A}is free");
                break;
            }
        }
    }
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (IsPlayerInAnyVehicle(playerid)) {
        new Float:POS[3], vehicleid = GetPlayerVehicleID(playerid);
        if (TaxiJobStarted[playerid] && IsTaxiCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            foreach(new i:Player) {
                if (IsPlayerConnected(i) && PlayerCalledTaxi[i]) {
                    GetPlayerPos(i, POS[0], POS[1], POS[2]);
                    SetPlayerMapIcon(playerid, i, POS[0], POS[1], POS[2], 0, 0xF0F000FF, MAPICON_GLOBAL);
                }
            }
        }
    }
    return 1;
}

hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {

    if (IsPlayerInAnyVehicle(playerid)) {
        if (IsTaxiCar(GetPlayerVehicleID(playerid))) {
            if (GetPlayerCarDriver(playerid) == INVALID_PLAYER_ID) return 1;
            if (!PlayerEnteredPoint[playerid]) {
                GetPlayerPos(GetPlayerCarDriver(playerid), FIRSTPOS[GetPlayerCarDriver(playerid)][0], FIRSTPOS[GetPlayerCarDriver(playerid)][1], FIRSTPOS[GetPlayerCarDriver(playerid)][2]);
                GetPlayerPos(playerid, FIRSTPOS[playerid][0], FIRSTPOS[playerid][1], FIRSTPOS[playerid][2]);
                new MapNode:nodeid;
                if (GetClosestMapNodeToPoint(fX, fY, fZ, nodeid) == GPS_ERROR_INVALID_NODE) {
                    return ShowPlayerDialogEx(playerid, TAXI_DIALOG5, 0, DIALOG_STYLE_MSGBOX, "Information", "{00FFFF}\
					Unable to calculate fare, try another location,\n\
					Set the marker on the map to that place,\n\
					in which you need to go.", "Close", "");
                }
                GetMapNodePos(nodeid, fX, fY, fZ);
                LASTPOS[playerid][0] = fX;
                LASTPOS[GetPlayerCarDriver(playerid)][0] = fX;
                LASTPOS[playerid][1] = fY;
                LASTPOS[GetPlayerCarDriver(playerid)][1] = fY;
                LASTPOS[playerid][2] = fZ;
                LASTPOS[GetPlayerCarDriver(playerid)][2] = fZ;
                new string[256];
                format(string, sizeof(string), "{00FFFF}\
				Destination:{FFFFFF}%s\n\
				{00FFFF}Fare:{FFFFFF}%d$\n\
				{999999}To change the destination\n\
				click on the 'Back' button\
				", GetPlayerPoint(playerid), GetPriceTaxi(GetPlayerCarDriver(playerid)));
                return ShowPlayerDialogEx(playerid, TAXI_DIALOG1, 0, DIALOG_STYLE_MSGBOX, "Information", string, "Done", "Go back");
            }

        }
    }

    return 1;
}

hook GlobalOneMinuteInterval() {
    TAXI_PRICERENT = Random(500, 2000);
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid == TAXI_DIALOG) {
        PlayerRentTaxi[playerid] = false;
        if (response) {
            if (GetPlayerCash(playerid) < TAXI_PRICERENT) {
                new string[128];
                format(string, sizeof(string), "{27C400}You do not have enough cash to rent. Necessary{5BD93B} %d$", TAXI_PRICERENT);
                SendClientMessageEx(playerid, -1, string);
                RemovePlayerFromVehicle(playerid);
                return 1;
            }
            GivePlayerCash(playerid, -TAXI_PRICERENT, "charged for taxi rent");
            vault:addcash(Vault_ID_Government, TAXI_PRICERENT, Vault_Transaction_Cash_To_Vault, sprintf("%s charged for taxi rent", GetPlayerNameEx(playerid)));
            SendClientMessageEx(playerid, -1, "{0AA8A0}You have successfully rented a taxi. {999999}(use the /unrent command to cancel the lease)");
            GetPlayerRentTaxi[playerid] = GetPlayerVehicleID(playerid);
            TaxiJobStarted[playerid] = true;
        } else {
            return RemovePlayerFromVehicle(playerid);
        }
        return 1;
    } else if (dialogid == TAXI_DIALOG1) {
        if (response) {
            new string[512];
            if (GetPlayerCash(playerid) < GetPriceTaxi(playerid)) {
                SendClientMessageEx(playerid, -1, "{27C400}You do not have enough cash to travel. {5BD93B}Choose a different route.");
                format(string, sizeof(string), "{00FFFF}\
				Destination:{FFFFFF}%s\n\
				{00FFFF}Fare:{FFFFFF}%d$\n\
				{999999}To change the destination\n\
				click on the 'Back' button\
				", GetPlayerPoint(playerid), GetPriceTaxi(GetPlayerCarDriver(playerid)));
                ShowPlayerDialogEx(playerid, TAXI_DIALOG1, 0, DIALOG_STYLE_MSGBOX, "Information", string, "Done", "Go back");
                return 1;
            }
            format(string, sizeof(string), "{00FFFF}\
			Destination:{FFFFFF}%s\n\
			{00FFFF}Fare:{FFFFFF}%d$\n\
			{999999}To change the destination\n\
			click on the 'Back' button\
			", GetPlayerPoint(playerid), GetPriceTaxi(GetPlayerCarPass(playerid)));
            ShowPlayerDialogEx(GetPlayerCarDriver(playerid), TAXI_DIALOG2, 0, DIALOG_STYLE_MSGBOX, "Information", string, "Done", "Go back");
            SendClientMessageEx(playerid, -1, "{00FFFF}The route was successfully selected. Wait for the answer from the taxi driver");
            PlayerEnteredPoint[playerid] = true;
        } else {
            return ShowPlayerDialogEx(playerid, TAXI_DIALOG5, 0, DIALOG_STYLE_MSGBOX, "Information", "{00FFFF}\
			Set the marker on the map to that place,\n\
			in which you need to go.", "Close", "");

        }
        return 1;
    } else if (dialogid == TAXI_DIALOG2) {
        if (response) {
            new textraid = GetPlayerCarPass(playerid);
            if (!IsPlayerConnected(textraid)) return 1;
            PlayerTaxiStarted[playerid] = true;
            if (IsValidDynamicCP(TaxiJob_CP[playerid])) DestroyDynamicCP(TaxiJob_CP[playerid]);
            TaxiJob_CP[playerid] = CreateDynamicCP(LASTPOS[playerid][0], LASTPOS[playerid][1], LASTPOS[playerid][2], 5.0, -1, -1, playerid, 999999);
            if (IsValidDynamicCP(TaxiJob_CP[GetPlayerCarPass(playerid)])) DestroyDynamicCP(TaxiJob_CP[GetPlayerCarPass(playerid)]);
            TaxiJob_CP[GetPlayerCarPass(playerid)] = CreateDynamicCP(LASTPOS[playerid][0], LASTPOS[playerid][1], LASTPOS[playerid][2], 5.0, -1, -1, GetPlayerCarPass(playerid), 999999);
            SendClientMessageEx(GetPlayerCarPass(playerid), -1, "{00ED1C}The taxi driver agreed to take you to the destination.");
            SendClientMessageEx(playerid, -1, "{00ED1C}Go to the red marker on the map.");
            for (new i = 0; i < MAX_TAXI; i++) {
                if (TAXI_ID[i] == GetPlayerVehicleID(playerid)) {
                    UpdateDynamic3DTextLabelText(TAXI_TEXT[i], 0xDEF200FF, "[{FFFFFF}Taxi{DEF200}]\n{EB1313}busy");
                    break;
                }
            }
        } else {
            SendClientMessageEx(GetPlayerCarPass(playerid), -1, "{FF0000}The taxi driver refused to take you to the destination.");
            SendClientMessageEx(playerid, -1, "{FF0000}You refused to take the passenger.");
            RemovePlayerFromVehicle(GetPlayerCarPass(playerid));
        }
        return 1;
    } else if (dialogid == TAXI_DIALOG3) {
        if (!response) return 1;
        foreach(new d:Player) {
            if (IsPlayerConnected(d) && IsTaxiCar(GetPlayerVehicleID(d))) RemovePlayerFromVehicle(d);
        }
        SendClientMessageEx(playerid, -1, "{0AA8A0}Taxi rent has been successfully canceled.");
        KillTimer(ExitCarTimer[playerid]);
        TaxiJobStarted[playerid] = false;
        PlayerTaxiStarted[playerid] = false;
        SetVehicleToRespawn(GetPlayerRentTaxi[playerid]);
        GetPlayerRentTaxi[playerid] = INVALID_VEHICLE_ID;
        foreach(new d:Player) {
            if (IsPlayerConnected(d) && PlayerCalledTaxi[d]) RemovePlayerMapIcon(playerid, d);
        }
        return 1;
    } else if (dialogid == TAXI_DIALOG4) {
        if (!response) return 1;
        switch (listitem) {
            case 0:
                SendClientMessageEx(PlayerService[playerid], -1, "{00ED1C}Your client thinks that you served him well");
            case 1:
                SendClientMessageEx(PlayerService[playerid], -1, "{00ED1C}Your client thinks that you served him well");
            case 2:
                SendClientMessageEx(PlayerService[playerid], -1, "{00ED1C}Your client thinks that you served him Poorly");
            case 3:
                SendClientMessageEx(PlayerService[playerid], -1, "{00ED1C}Your client thinks that you served him awfully");
        }
        PlayerService[playerid] = INVALID_PLAYER_ID;
        return 1;
    }
    return 1;
}

forward OnPlayerShowTaxiDialog(playerid);
public OnPlayerShowTaxiDialog(playerid) {
    if (PlayerRentTaxi[playerid]) {
        new string[128];
        format(string, sizeof(string), "{FFFFFF}\
  		To work in a taxi, you need to rent it.\n\
		Rent price:{CECECE}%d$\
		", TAXI_PRICERENT);
        ShowPlayerDialogEx(playerid, TAXI_DIALOG, 0, DIALOG_STYLE_MSGBOX, "Rent a taxi", string, "Yes", "No");
    } else {
        ShowPlayerDialogEx(playerid, 00000, 0, 0, "", "", "", "");
        KillTimer(TaxiDialogTimer[playerid]);
    }
    return 1;
}

forward OnPlayerFinishedRace(playerid);
public OnPlayerFinishedRace(playerid) {
    TogglePlayerControllable(playerid, true);
    PlayerService[GetPlayerCarPass(playerid)] = playerid;
    RemovePlayerFromVehicle(GetPlayerCarPass(playerid));
    return 1;
}
forward OnPlayerExitCar(playerid);
public OnPlayerExitCar(playerid) {
    new string[128];
    if (PlayerExitCount[playerid] > 3 && PlayerExitCount[playerid] < 11) {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d", PlayerExitCount[playerid]);
        GameTextForPlayer(playerid, string, 900, 3);
    }
    if (PlayerExitCount[playerid] > 0 && PlayerExitCount[playerid] < 4) {
        format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%d", PlayerExitCount[playerid]);
        GameTextForPlayer(playerid, string, 900, 3);
    }
    if (PlayerExitCount[playerid] < 1) {
        new vehicleid = GetPlayerRentTaxi[playerid];
        for (new i = 0; i < MAX_TAXI; i++) {
            if (TAXI_ID[i] == vehicleid) {
                UpdateDynamic3DTextLabelText(TAXI_TEXT[i], 0xDEF200FF, "[{FFFFFF} taxi {DEF200}] \n {13EB3A} is free");
                break;
            }
        }

        foreach(new d:Player) {
            if (IsPlayerConnected(d) && IsTaxiCar(GetPlayerVehicleID(d))) {
                if (IsValidDynamicCP(TaxiJob_CP[d])) DestroyDynamicCP(TaxiJob_CP[d]);
                RemovePlayerFromVehicle(d);
            }
        }
        if (IsValidDynamicCP(TaxiJob_CP[playerid])) DestroyDynamicCP(TaxiJob_CP[playerid]);
        SendClientMessageEx(playerid, -1, "{E63030}You've completed your itinerary");
        KillTimer(ExitCarTimer[playerid]);
        GetPlayerRentTaxi[playerid] = INVALID_VEHICLE_ID;
        TaxiJobStarted[playerid] = false;
        PlayerTaxiStarted[playerid] = false;
        SetVehicleToRespawn(vehicleid);
        foreach(new d:Player) {
            //if(IsPlayerConnected(d) && PlayerCalledTaxi[d]) {
            RemovePlayerMapIcon(playerid, d);
            if (IsValidDynamicCP(TaxiJob_CP[d])) DestroyDynamicCP(TaxiJob_CP[d]);
        }
    } else {
        PlayerExitCount[playerid] -= 1;
    }
    return 1;
}

stock IsTaxiCar(vehicleid) {
    for (new i = 0; i < MAX_TAXI; i++) {
        if (vehicleid == TAXI_ID[i]) return 1;
    }
    return 0;
}

stock GetPriceTaxi(playerid) {
    if (!IsPlayerConnected(playerid)) return floatround(0.0);
    new Float:dist = floatsqroot(floatpower(floatabs(floatsub(LASTPOS[playerid][0], FIRSTPOS[playerid][0])), 2) +
        floatpower(floatabs(floatsub(LASTPOS[playerid][1], FIRSTPOS[playerid][1])), 2) +
        floatpower(floatabs(floatsub(LASTPOS[playerid][2], FIRSTPOS[playerid][2])), 2));
    return floatround(dist * TAXI_PRICEROUT);
}

stock GetPriceTaxiEx(playerid) {
    if (!IsPlayerConnected(playerid)) return floatround(0.0);
    new Float:POS[3];
    GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
    new Float:dist = floatsqroot(floatpower(floatabs(floatsub(POS[0], FIRSTPOS[playerid][0])), 2) +
        floatpower(floatabs(floatsub(POS[1], FIRSTPOS[playerid][1])), 2) +
        floatpower(floatabs(floatsub(POS[2], FIRSTPOS[playerid][2])), 2));
    return floatround(dist * TAXI_PRICEROUT);
}

stock GetPlayerCarDriver(playerid) {
    if (!IsPlayerConnected(playerid)) return floatround(0.0);
    foreach(new i:Player) {
        if (IsPlayerConnected(i) && GetPlayerVehicleSeat(i) == 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid) && TaxiJobStarted[i]) return i;
    }
    return INVALID_PLAYER_ID;
}

stock GetPlayerCarPass(playerid) {
    if (!IsPlayerConnected(playerid)) return floatround(0.0);
    foreach(new i:Player) {
        if (IsPlayerConnected(i) && GetPlayerVehicleSeat(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) return i;
    }
    return INVALID_PLAYER_ID;
}