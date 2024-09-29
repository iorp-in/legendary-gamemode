new LICENSE_TEST_FEE_LIGHT = 2000;
new LICENSE_TEST_FEE_HEAVY = 2000;
new LICENSE_TEST_FEE_TWO_WHEELER = 2000;
new LICENSE_TEST_FEE_HELI_FLYING = 2000;
new LICENSE_TEST_FEE_PLANE_FLYING = 2000;
new LICENSE_TEST_FEE_BOAT = 2000;

hook GlobalOneMinuteInterval() {
    LICENSE_TEST_FEE_LIGHT = Random(1000, 3000);
    LICENSE_TEST_FEE_HEAVY = Random(1000, 3000);
    LICENSE_TEST_FEE_TWO_WHEELER = Random(1000, 3000);
    LICENSE_TEST_FEE_HELI_FLYING = Random(1000, 3000);
    LICENSE_TEST_FEE_PLANE_FLYING = Random(1000, 3000);
    LICENSE_TEST_FEE_BOAT = Random(1000, 3000);
    return 1;
}

enum DriverLicenseEnum {
    bool:LightMotor,
    bool:HeavyMotor,
    bool:TwoWheelerMotor,
    bool:HelicopterMotor,
    bool:PlaneMotor,
    bool:BoatMotor,

    DL_LM_CheckpointID,
    DL_HM_CheckpointID,
    DL_TW_CheckpointID,
    DL_HL_CheckpointID,
    DL_PL_CheckpointID,
    DL_BT_CheckpointID,
    bool:teststatus,
    dl_vehicleid,
    Float:dl_originalpos[3],
    dl_player_int,
    dl_player_vw,
};
new DriverPlayerData[MAX_PLAYERS][DriverLicenseEnum];

forward IsPlayerHaveingDlTest(playerid);
public IsPlayerHaveingDlTest(playerid) {
    return DriverPlayerData[playerid][teststatus];
}

forward IsPlayerHaveLightLicense(playerid);
public IsPlayerHaveLightLicense(playerid) {
    return DriverPlayerData[playerid][LightMotor];
}

forward IsPlayerHaveHeavyLicense(playerid);
public IsPlayerHaveHeavyLicense(playerid) {
    return DriverPlayerData[playerid][HeavyMotor];
}

forward IsPlayerHaveTwoWheelerLicense(playerid);
public IsPlayerHaveTwoWheelerLicense(playerid) {
    return DriverPlayerData[playerid][TwoWheelerMotor];
}

forward IsPlayerHaveHeliCopterLicense(playerid);
public IsPlayerHaveHeliCopterLicense(playerid) {
    return DriverPlayerData[playerid][HelicopterMotor];
}

forward IsPlayerHavePlaneLicense(playerid);
public IsPlayerHavePlaneLicense(playerid) {
    return DriverPlayerData[playerid][PlaneMotor];
}

forward IsPlayerHaveBoatLicense(playerid);
public IsPlayerHaveBoatLicense(playerid) {
    return DriverPlayerData[playerid][BoatMotor];
}

forward Player_Driving_Data_Init(playerid);
public Player_Driving_Data_Init(playerid) {
    DriverPlayerData[playerid][LightMotor] = false;
    DriverPlayerData[playerid][HeavyMotor] = false;
    DriverPlayerData[playerid][TwoWheelerMotor] = false;
    DriverPlayerData[playerid][HelicopterMotor] = false;
    DriverPlayerData[playerid][PlaneMotor] = false;
    DriverPlayerData[playerid][BoatMotor] = false;
    DriverPlayerData[playerid][DL_LM_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_HM_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_TW_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_HL_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_PL_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_BT_CheckpointID] = -1;
    DriverPlayerData[playerid][teststatus] = false;
    DriverPlayerData[playerid][dl_vehicleid] = -1;
    new rows = cache_num_rows();
    if (rows) {
        if (rows) {
            cache_get_value_name_int(0, "LightDLStatus", DriverPlayerData[playerid][LightMotor]);
            cache_get_value_name_int(0, "HeavyDLStatus", DriverPlayerData[playerid][HeavyMotor]);
            cache_get_value_name_int(0, "TwoWheelerDLStatus", DriverPlayerData[playerid][TwoWheelerMotor]);
            cache_get_value_name_int(0, "HelicopterDLStatus", DriverPlayerData[playerid][HelicopterMotor]);
            cache_get_value_name_int(0, "PlaneDLStatus", DriverPlayerData[playerid][PlaneMotor]);
            cache_get_value_name_int(0, "BoatDLStatus", DriverPlayerData[playerid][BoatMotor]);
        }
    } else {
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO playerDataDrivingLicense SET Username=\"%s\", LightDLStatus = \"0\", HeavyDLStatus = \"0\", TwoWheelerDLStatus = \"0\", HelicopterDLStatus = \"0\", PlaneDLStatus = \"0\", BoatDLStatus = \"0\"", GetPlayerNameEx(playerid));
        mysql_tquery(Database, query);
    }
    return 1;
}

forward Player_Driving_Data_Update(playerid);
public Player_Driving_Data_Update(playerid) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "update playerDataDrivingLicense SET LightDLStatus = \"%d\", HeavyDLStatus = \"%d\", TwoWheelerDLStatus = \"%d\", HelicopterDLStatus = \"%d\", PlaneDLStatus = \"%d\", BoatDLStatus = \"%d\" where Username=\"%s\"",
        DriverPlayerData[playerid][LightMotor], DriverPlayerData[playerid][HeavyMotor], DriverPlayerData[playerid][TwoWheelerMotor], DriverPlayerData[playerid][HelicopterMotor], DriverPlayerData[playerid][PlaneMotor], DriverPlayerData[playerid][BoatMotor], GetPlayerNameEx(playerid));
    mysql_tquery(Database, query);
    return 1;
}


hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    new query[512];
    mysql_format(Database, query, sizeof(query), "SELECT * FROM `playerDataDrivingLicense` WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "Player_Driving_Data_Init", "i", playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    ResetDLStatus(playerid);
    return 1;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `playerDataDrivingLicense` (\
	  `Username` varchar(50) NOT NULL,\
	  `LightDLStatus` BOOLEAN NOT NULL,\
	  `HeavyDLStatus` BOOLEAN NOT NULL,\
	  `TwoWheelerDLStatus` BOOLEAN NOT NULL,\
	  `HelicopterDLStatus` BOOLEAN NOT NULL,\
	  `PlaneDLStatus` BOOLEAN NOT NULL,\
	  `BoatDLStatus` BOOLEAN NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_ONFOOT && IsPlayerHaveingDlTest(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
        SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
        SetTimerEx("ResetLocation", 3000, false, "i", playerid);
        DriverPlayerData[playerid][teststatus] = false;
        GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you have leaved vehicle without completing test");
    }
    if (newstate != PLAYER_STATE_DRIVER) return 1;
    if (IsPlayerHaveingDlTest(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (IsArrayContainNumber(HeavyMotor_Vehicles, GetVehicleModel(vehicleid)) || IsArrayContainNumber(HeavyMotor_Vehicles_2, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHaveHeavyLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Heavy Motor License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    if (IsArrayContainNumber(TwoWheelerMotor_Vehicles, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHaveTwoWheelerLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Two wheeler License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    if (IsArrayContainNumber(HelicopterMotor_Vehicles, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHaveHeliCopterLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Helicopter Flying License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    if (IsArrayContainNumber(PlaneMotor_Vehicles, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHavePlaneLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Plane Flying License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    if (IsArrayContainNumber(BoatMotor_Vehicles, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHaveBoatLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Boat Driving License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    if (IsArrayContainNumber(LightMotor_Vehicles, GetVehicleModel(vehicleid)) || IsArrayContainNumber(LightMotor_Vehicles_RC, GetVehicleModel(vehicleid))) {
        if (!IsPlayerHaveLightLicense(playerid) && IsTimePassedForPlayer(playerid, "License Warning", 5 * 60)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you don't have Light Motor License, If you choose to drive, the police can catch you and send you to jail");
            //return RemovePlayerFromVehicle(playerid);
            return 1;
        }
        return 1;
    }
    return 1;
}

forward ResetDLStatus(playerid);
public ResetDLStatus(playerid) {
    if (IsValidVehicle(DriverPlayerData[playerid][dl_vehicleid])) DestroyVehicle(DriverPlayerData[playerid][dl_vehicleid]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_LM_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_LM_CheckpointID]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_HM_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_HM_CheckpointID]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_TW_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_TW_CheckpointID]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_HL_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_HL_CheckpointID]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_PL_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_PL_CheckpointID]);
    if (IsValidDynamicRaceCP(DriverPlayerData[playerid][DL_BT_CheckpointID])) DestroyDynamicRaceCP(DriverPlayerData[playerid][DL_BT_CheckpointID]);
    DriverPlayerData[playerid][DL_LM_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_HM_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_TW_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_HL_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_PL_CheckpointID] = -1;
    DriverPlayerData[playerid][DL_BT_CheckpointID] = -1;
    return 1;
}

forward ResetLocation(playerid);
public ResetLocation(playerid) {
    SetPlayerInteriorEx(playerid, DriverPlayerData[playerid][dl_player_int]);
    SetPlayerVirtualWorldEx(playerid, DriverPlayerData[playerid][dl_player_vw]);
    SetPlayerPosEx(playerid, DriverPlayerData[playerid][dl_originalpos][0], DriverPlayerData[playerid][dl_originalpos][1], DriverPlayerData[playerid][dl_originalpos][2]);
    GameTextForPlayer(playerid, "~r~Teleported to Last Location", 1500, 3);
    return 1;
}

hook OnPlayerEnterDynRaceCP(playerid, checkpointid) {
    if (checkpointid == DriverPlayerData[playerid][DL_LM_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHaveLightLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Light Motor License");
            else {
                DriverPlayerData[playerid][LightMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Light Motor license test, you can now drive Light Vehicles");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    if (checkpointid == DriverPlayerData[playerid][DL_HM_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHaveHeavyLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Heavy Motor License");
            else {
                DriverPlayerData[playerid][HeavyMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Heavy Motor license test, you can now drive Heavy Vehicles");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    if (checkpointid == DriverPlayerData[playerid][DL_TW_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHaveTwoWheelerLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Two Wheeler License");
            else {
                DriverPlayerData[playerid][TwoWheelerMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Two Wheeler license test, you can now drive Two Wheeler Vehicles");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    if (checkpointid == DriverPlayerData[playerid][DL_HL_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHaveHeliCopterLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Helicopter Flying License");
            else {
                DriverPlayerData[playerid][HelicopterMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Helicopter Flying License test, you can now fly Helicopters");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    if (checkpointid == DriverPlayerData[playerid][DL_PL_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHavePlaneLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Plane Flying License");
            else {
                DriverPlayerData[playerid][PlaneMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Plane Flying License test, you can now fly Planes");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    if (checkpointid == DriverPlayerData[playerid][DL_BT_CheckpointID]) {
        DriverPlayerData[playerid][teststatus] = false;
        if (IsPlayerInAnyVehicle(playerid)) {
            new Float:dlv_health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), Float:dlv_health);
            if (dlv_health < 950.00) {
                GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, vehicle is damaged too much, try to drive safe next time");
            } else if (IsPlayerHaveBoatLicense(playerid)) GameTextForPlayer(playerid, "~r~License Test Failed", 2500, 3), SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}test failed because, you already have Boat Driving License");
            else {
                DriverPlayerData[playerid][BoatMotor] = true;
                GameTextForPlayer(playerid, "~g~License Test Passed", 2500, 3);
                SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have seccessfully passed your Boat Driving License test, you can now drive Boats");
            }
            RemovePlayerFromVehicle(playerid);
            SetTimerEx("ResetDLStatus", 3000, false, "i", playerid);
            SetTimerEx("ResetLocation", 3000, false, "i", playerid);
            Player_Driving_Data_Update(playerid);
        }
        return 1;
    }
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 19) return 1;
    dltest_cmd(playerid);
    return 1;
}

stock dltest_cmd(playerid) {
    new string[512];
    format(string, sizeof string, "%sLicense\tStatus\tFees\n", string);
    format(string, sizeof string, "%sLight Motor License\t%s\t500\n", string, ((IsPlayerHaveLightLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sHeavy Motor License\t%s\t500\n", string, ((IsPlayerHaveHeavyLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sTwo Wheeler Motor License\t%s\t500\n", string, ((IsPlayerHaveTwoWheelerLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sHelicopter Flying License\t%s\t500\n", string, ((IsPlayerHaveHeliCopterLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sPlane Flying License\t%s\t500\n", string, ((IsPlayerHavePlaneLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sBoat Driving License\t%s\t500\n", string, ((IsPlayerHaveBoatLicense(playerid)) ? ("Yes") : ("No")));
    return FlexPlayerDialog(playerid, "DrivingLicenseTestMenu", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFEE}License Status", string, "Apply", "Close");
}

FlexDialog:DrivingLicenseTestMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return User_Panel(playerid);
    DriverPlayerData[playerid][dl_player_int] = GetPlayerInterior(playerid);
    DriverPlayerData[playerid][dl_player_vw] = GetPlayerVirtualWorldID(playerid);
    GetPlayerPos(playerid, DriverPlayerData[playerid][dl_originalpos][0], DriverPlayerData[playerid][dl_originalpos][1], DriverPlayerData[playerid][dl_originalpos][2]);
    if (IsStringSame("Light Motor License", inputtext)) {
        if (IsPlayerHaveLightLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Light Motor License");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Light Motor License license");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_LIGHT, "charged for light motor license", Vault_ID_Government, LICENSE_TEST_FEE_LIGHT, sprintf("%s charged for light motor license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        new MapNode:nodeid, MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z;
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerPosEx(playerid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        GetClosestMapNodeToPoint(Float:d_X, Float:d_Y, Float:d_Z, MapNode:second_nodeid, MapNode:nodeid);
        GetMapNodePos(MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(LightMotor_Vehicles), Float:d_X, Float:d_Y, Float:d_Z + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][DL_LM_CheckpointID] = CreateDynamicRaceCP(1, Float:d_X, Float:d_Y, Float:d_Z, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Light Motor license test started, please follow the marker on map to get your license");
    }
    if (IsStringSame("Heavy Motor License", inputtext)) {
        if (IsPlayerHaveHeavyLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Heavy Motor license");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Heavy Motor license");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_HEAVY, "charged for heavy motor license", Vault_ID_Government, LICENSE_TEST_FEE_HEAVY, sprintf("%s charged for heavy motor license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        new MapNode:nodeid, MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z;
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerPosEx(playerid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        GetClosestMapNodeToPoint(Float:d_X, Float:d_Y, Float:d_Z, MapNode:second_nodeid, MapNode:nodeid);
        GetMapNodePos(MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(HeavyMotor_Vehicles), Float:d_X, Float:d_Y, Float:d_Z + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][DL_HM_CheckpointID] = CreateDynamicRaceCP(1, Float:d_X, Float:d_Y, Float:d_Z, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Heavy Motor license test started, please follow the marker on map to get your license");
    }
    if (IsStringSame("Two Wheeler Motor License", inputtext)) {
        if (IsPlayerHaveTwoWheelerLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Two Wheeler license");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Two Wheeler license");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_TWO_WHEELER, "charged for two wheeler license", Vault_ID_Government, LICENSE_TEST_FEE_TWO_WHEELER, sprintf("%s charged for two wheeler license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        new MapNode:nodeid, MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z;
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerPosEx(playerid, Float:d_X, Float:d_Y, Float:d_Z);
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        GetClosestMapNodeToPoint(Float:d_X, Float:d_Y, Float:d_Z, MapNode:second_nodeid, MapNode:nodeid);
        GetMapNodePos(MapNode:second_nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(TwoWheelerMotor_Vehicles), Float:d_X, Float:d_Y, Float:d_Z + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        GetRandomMapNode(MapNode:nodeid);
        GetMapNodePos(MapNode:nodeid, Float:d_X, Float:d_Y, Float:d_Z);
        DriverPlayerData[playerid][DL_TW_CheckpointID] = CreateDynamicRaceCP(1, Float:d_X, Float:d_Y, Float:d_Z, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Two Wheeler license test started, please follow the marker on map to get your license");
    }
    if (IsStringSame("Helicopter Flying License", inputtext)) {
        if (IsPlayerHaveHeliCopterLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Helicopter Flying License");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Helicopter Flying License");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_HELI_FLYING, "charged for helicopter flying license", Vault_ID_Government, LICENSE_TEST_FEE_HELI_FLYING, sprintf("%s charged for helicopter flying license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(HelicopterMotor_Vehicles), 2092.7100, 2416.0964, 74.5786 + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        DriverPlayerData[playerid][DL_HL_CheckpointID] = CreateDynamicRaceCP(1, -2336.6248, -1654.0929, 483.7031, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Helicopter Flying License test started, please follow the marker on map to get your license");
    }
    if (IsStringSame("Plane Flying License", inputtext)) {
        if (IsPlayerHavePlaneLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Plane Flying License");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Plane Flying License");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_PLANE_FLYING, "charged for plane flying license", Vault_ID_Government, LICENSE_TEST_FEE_PLANE_FLYING, sprintf("%s charged for plane flying license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(PlaneMotor_Vehicles), 1923.2404, -2435.6062, 13.5391 + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        DriverPlayerData[playerid][DL_PL_CheckpointID] = CreateDynamicRaceCP(1, 348.5798, 2504.8035, 16.4844, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Plane Flying License test started, please follow the marker on map to get your license");
    }
    if (IsStringSame("Boat Driving License", inputtext)) {
        if (IsPlayerHaveBoatLicense(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you already have Boat Driving License");
        DriverPlayerData[playerid][teststatus] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you are charged with $500 for new Boat Driving License");
        vault:PlayerVault(playerid, -LICENSE_TEST_FEE_BOAT, "charged for boat license", Vault_ID_Government, LICENSE_TEST_FEE_BOAT, sprintf("%s charged for boat license", GetPlayerNameEx(playerid)));
        SetPlayerVirtualWorldEx(playerid, 0);
        SetPlayerInteriorEx(playerid, 0);
        DriverPlayerData[playerid][dl_vehicleid] = CreateVehicle(RandomNumberFromArray(BoatMotor_Vehicles), 437.3438, -2066.8740, -0.4860 + 1, RandomEx(0, 360), RandomEx(0, 300), RandomEx(0, 0), 1800, 0, 0, 0, true);
        ResetVehicleEx(DriverPlayerData[playerid][dl_vehicleid]);
        PutPlayerInVehicleEx(playerid, DriverPlayerData[playerid][dl_vehicleid], 0);
        SetVehicleFuelEx(DriverPlayerData[playerid][dl_vehicleid], 99);
        DriverPlayerData[playerid][DL_BT_CheckpointID] = CreateDynamicRaceCP(1, -2180.6128, 2464.7683, -0.4602, 0, 0, 0, 3, 0, 0, playerid, 999999);
        GameTextForPlayer(playerid, "~w~License Test Started", 2500, 3);
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Boat Driving License test started, please follow the marker on map to get your license");
    }
    return 1;
}

stock showdl_cmd(playerid, targetid) {
    new string[512];
    format(string, sizeof string, "%sLicense\tStatus\n", string);
    format(string, sizeof string, "%sLight Motor License\t%s\n", string, ((IsPlayerHaveLightLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sHeavy Motor License\t%s\n", string, ((IsPlayerHaveHeavyLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sTwo Wheeler Motor License\t%s\n", string, ((IsPlayerHaveTwoWheelerLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sHelicopter Flying License\t%s\n", string, ((IsPlayerHaveHeliCopterLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sPlane Flying License\t%s\n", string, ((IsPlayerHavePlaneLicense(playerid)) ? ("Yes") : ("No")));
    format(string, sizeof string, "%sBoat Driving License\t%s\n", string, ((IsPlayerHaveBoatLicense(playerid)) ? ("Yes") : ("No")));
    return FlexPlayerDialog(targetid, "DrivingLicenseView", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFEE}License Status", string, "", "Close");
}

FlexDialog:DrivingLicenseView(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    return 1;
}

stock IsPlayerInFlyableVehicle(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return false;
    new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
    new Flyable_Vehicles[] = { 417, 425, 447, 469, 487, 488, 497, 548, 563, 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593 };
    if (IsArrayContainNumber(Flyable_Vehicles, vehiclemodel)) return true;
    return false;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "License");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("License", inputtext)) showdl_cmd(playerid, playerid);
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 1) return 1;
    QuickActions:AddCommand(playerid, "Show License");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Show License", inputtext)) return showdl_cmd(playerid, targetid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (IsStringContainWords(text, "license")) return showdl_cmd(playerid, playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `playerDataDrivingLicense` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `playerDataDrivingLicense` WHERE `Username` = \"%s\"", AccountName));
    return 1;
}