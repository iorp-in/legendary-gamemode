#define Max_Fuel_Tanks 4
#define Max_Fuel_Mining_Machines 17

enum OilCompany:PlayerDataEnum {
    OilCompany:FM_ID,
    OilCompany:FM_Timer,
    bool:OilCompany:WorkingOnFM
}
new OilCompany:PlayerData[MAX_PLAYERS][OilCompany:PlayerDataEnum];

stock OilCompany:GetTankerFuel(trailerid) {
    return TrailerStorage:GetResourceByName(trailerid, "Fuel");
}

stock OilCompany:GetTankerRemainingSpace(trailerid) {
    return TrailerStorage:GetResourceLimitByName("Fuel") - OilCompany:GetTankerFuel(trailerid);
}

stock OilCompany:SetTankerFuel(trailerid, fuel) {
    TrailerStorage:SetResourceByName(trailerid, "Fuel", fuel);
    return 1;
}

hook OnPlayerLogin(playerid) {
    OilCompany:PlayerData[playerid][OilCompany:FM_ID] = -1;
    OilCompany:PlayerData[playerid][OilCompany:FM_Timer] = -1;
    OilCompany:PlayerData[playerid][OilCompany:WorkingOnFM] = false;
    return 1;
}

enum OilCompany:Tanker_ENum {
    OilCompany:TK_FuelPrice,
    OilCompany:TK_LastRepair,
    OilCompany:TK_FuelStored,
    OilCompany:TK_FuelCapacity,
    Float:OilCompany:TK_TankerPos[3],
    Float:OilCompany:TK_WorkerPos[3],
    OilCompany:TK_State, // Required Maintance | Working | Requird Worker
    OilCompany:TK_Locked,

    bool:OilCompany:TK_InPossition,
    STREAMER_TAG_3D_TEXT_LABEL:OilCompany:TK_3dTextLabel,
    STREAMER_TAG_CP:OilCompany:TK_WorkerCP,
    bool:OilCompany:tankerfilling,
    OilCompany:lFuel,
    OilCompany:tankWorkerID,
    OilCompany:vehicleid,
    OilCompany:TrailerID,
    OilCompany:timerid,
    OilCompany:money,
    OilCompany:chargedmoney
}
new OilCompany:TankContainerData[Max_Fuel_Tanks][OilCompany:Tanker_ENum];
new Iterator:tankcontainers < Max_Fuel_Tanks > ;

enum OilCompany:Machines_ENum {
    OilCompany:FM_Tank,
    OilCompany:FM_LastRepair,
    OilCompany:FM_Locked,
    Float:OilCompany:FM_MachinePos[3],
    Float:OilCompany:FM_WorkerPos[4],
    OilCompany:FM_State,
    STREAMER_TAG_3D_TEXT_LABEL:OilCompany:FM_3dTextLabel,
}
new OilCompany:MineMachineData[Max_Fuel_Mining_Machines][OilCompany:Machines_ENum];
new Iterator:minemachines < Max_Fuel_Mining_Machines > ;

stock OilCompany:GetMachineStateName(machineid) {
    new string[50], stateCode = OilCompany:MineMachineData[machineid][OilCompany:FM_State];
    format(string, sizeof string, "unknown");
    if (OilCompany:MineMachineData[machineid][OilCompany:FM_Locked]) format(string, sizeof string, "Locked");
    else if (stateCode == 0) format(string, sizeof string, "Required Maintenance");
    else if (stateCode == 1) format(string, sizeof string, "Required Worker");
    else if (stateCode == 2) format(string, sizeof string, "Working");
    return string;
}

stock OilCompany:GetTankStateName(tankid) {
    new string[50], stateCode = OilCompany:TankContainerData[tankid][OilCompany:TK_State];
    format(string, sizeof string, "unknown");
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_Locked]) format(string, sizeof string, "Locked");
    else if (stateCode == 0) format(string, sizeof string, "Required Maintenance");
    else if (stateCode == 1) format(string, sizeof string, "Required Worker");
    else if (stateCode == 2) format(string, sizeof string, "Working");
    return string;
}

forward loadFuelFactoryTanks();
public loadFuelFactoryTanks() {
    new rows = cache_num_rows();
    if (rows) {
        new i, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", i);
            cache_get_value_name_int(loaded, "FuelStored", OilCompany:TankContainerData[i][OilCompany:TK_FuelStored]);
            cache_get_value_name_int(loaded, "FuelCapacity", OilCompany:TankContainerData[i][OilCompany:TK_FuelCapacity]);
            cache_get_value_name_int(loaded, "LastRepair", OilCompany:TankContainerData[i][OilCompany:TK_LastRepair]);
            cache_get_value_name_int(loaded, "FuelPrice", OilCompany:TankContainerData[i][OilCompany:TK_FuelPrice]);
            cache_get_value_name_int(loaded, "Locked", OilCompany:TankContainerData[i][OilCompany:TK_Locked]);
            cache_get_value_name_float(loaded, "TankerX", OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][0]);
            cache_get_value_name_float(loaded, "TankerY", OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][1]);
            cache_get_value_name_float(loaded, "TankerZ", OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][2]);
            cache_get_value_name_float(loaded, "WorkerX", OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][0]);
            cache_get_value_name_float(loaded, "WorkerY", OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][1]);
            cache_get_value_name_float(loaded, "WorkerZ", OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][2]);
            if (gettime() - OilCompany:TankContainerData[i][OilCompany:TK_LastRepair] > 7 * 24 * 60 * 60) OilCompany:TankContainerData[i][OilCompany:TK_State] = 0;
            else OilCompany:TankContainerData[i][OilCompany:TK_State] = 1;
            Iter_Add(tankcontainers, i);
            new string[512];
            strcat(string, sprintf("{00FF00}Oil Tank Status [%d]\n\n", i));
            strcat(string, sprintf("{DC143C}State: {FFFFFF}%s\n", OilCompany:GetTankStateName(i)));
            strcat(string, sprintf("{DC143C}Last Maintanance At: {FFFFFF}%s\n", UnixToHumanEx(OilCompany:TankContainerData[i][OilCompany:TK_LastRepair])));
            strcat(string, sprintf("{DC143C}Fuel Stored: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[i][OilCompany:TK_FuelStored]));
            strcat(string, sprintf("{DC143C}Fuel Capacity: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[i][OilCompany:TK_FuelCapacity]));
            strcat(string, sprintf("{DC143C}Fuel Price: {FFFFFF} $%s/gallon\n", FormatCurrency(OilCompany:TankContainerData[i][OilCompany:TK_FuelPrice])));
            strcat(string, "{FFFFFF}press N to start work");
            OilCompany:TankContainerData[i][OilCompany:TK_3dTextLabel] = CreateDynamic3DTextLabel(string, -1, OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][0], OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][1], OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][2], 10.0);
            OilCompany:TankContainerData[i][OilCompany:TK_WorkerCP] = CreateDynamicCP(OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][0], OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][1], OilCompany:TankContainerData[i][OilCompany:TK_TankerPos][2], 5, 0, 0, -1, 30.0);
            loaded++;
        }
    }
    printf("  [Fuel Factory] Loaded %d fuel tanks.", rows);
    return 1;
}

forward loadFuelFactoryMines();
public loadFuelFactoryMines() {
    new rows = cache_num_rows();
    if (rows) {
        new i, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", i);
            cache_get_value_name_int(loaded, "TankID", OilCompany:MineMachineData[i][OilCompany:FM_Tank]);
            cache_get_value_name_int(loaded, "LastRepair", OilCompany:MineMachineData[i][OilCompany:FM_LastRepair]);
            cache_get_value_name_int(loaded, "Locked", OilCompany:MineMachineData[i][OilCompany:FM_Locked]);
            cache_get_value_name_float(loaded, "MachinePosX", OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][0]);
            cache_get_value_name_float(loaded, "MachinePosY", OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][1]);
            cache_get_value_name_float(loaded, "MachinePosZ", OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][2]);
            cache_get_value_name_float(loaded, "WorkerPosX", OilCompany:MineMachineData[i][OilCompany:FM_WorkerPos][0]);
            cache_get_value_name_float(loaded, "WorkerPosY", OilCompany:MineMachineData[i][OilCompany:FM_WorkerPos][1]);
            cache_get_value_name_float(loaded, "WorkerPosZ", OilCompany:MineMachineData[i][OilCompany:FM_WorkerPos][2]);
            cache_get_value_name_float(loaded, "WorkerPosA", OilCompany:MineMachineData[i][OilCompany:FM_WorkerPos][2]);
            Iter_Add(minemachines, i);
            if (gettime() - OilCompany:MineMachineData[i][OilCompany:FM_LastRepair] > 7 * 24 * 60 * 60) OilCompany:MineMachineData[i][OilCompany:FM_State] = 0;
            else OilCompany:MineMachineData[i][OilCompany:FM_State] = 1;
            new string[512];
            strcat(string, sprintf("{00FF00}Oil Mill Machinery [%d]\n\n", i));
            strcat(string, sprintf("{DC143C}State: {FFFFFF}%s\n", OilCompany:GetMachineStateName(i)));
            strcat(string, sprintf("{DC143C}Last Maintanance At: {FFFFFF}%s\n", UnixToHumanEx(OilCompany:MineMachineData[i][OilCompany:FM_LastRepair])));
            strcat(string, sprintf("{DC143C}Tank: {FFFFFF}%d\n", OilCompany:MineMachineData[i][OilCompany:FM_Tank]));
            strcat(string, sprintf("{DC143C}Fuel Stored in Tank: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[OilCompany:MineMachineData[i][OilCompany:FM_Tank]][OilCompany:TK_FuelStored]));
            strcat(string, sprintf("{DC143C}Fuel Capacity in Tank: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[OilCompany:MineMachineData[i][OilCompany:FM_Tank]][OilCompany:TK_FuelCapacity]));
            strcat(string, "{FFFFFF}press N to start work");
            OilCompany:MineMachineData[i][OilCompany:FM_3dTextLabel] = CreateDynamic3DTextLabel(string, -1, OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][0], OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][1], OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][2], 10.0);
            loaded++;
        }
    }
    printf("  [Fuel Factory] Loaded %d fuel mines.", rows);
    return 1;
}

stock OilCompany:SaveFuelTanksData(tankid) {
    mysql_tquery(Database, sprintf("update oilFactoryTanks set FuelStored = %d, LastRepair = %d, FuelPrice = %d, Locked = %d  where ID = %d",
        OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored], OilCompany:TankContainerData[tankid][OilCompany:TK_LastRepair],
        OilCompany:TankContainerData[tankid][OilCompany:TK_FuelPrice], OilCompany:TankContainerData[tankid][OilCompany:TK_Locked],
        tankid
    ));
    return 1;
}

stock OilCompany:SaveFuelMinesData(machineid) {
    mysql_tquery(Database, sprintf("update oilFactoryMines set LastRepair = %d, Locked = %d where ID = %d",
        OilCompany:MineMachineData[machineid][OilCompany:FM_LastRepair],
        OilCompany:MineMachineData[machineid][OilCompany:FM_Locked],
        machineid
    ));
    return 1;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "select * from oilFactoryTanks", "loadFuelFactoryTanks", "");
    mysql_tquery(Database, "select * from oilFactoryMines", "loadFuelFactoryMines", "");
    return 1;
}

stock OilCompany:GetPlayerNearestMachine(playerid, Float:range = 5.0) {
    foreach(new i:minemachines) {
        if (IsPlayerInRangeOfPoint(playerid, Float:range, OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][0], OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][1], OilCompany:MineMachineData[i][OilCompany:FM_MachinePos][2])) return i;
    }
    return -1;
}

stock OilCompany:GetPlayerNearestTankControl(playerid, Float:range = 5.0) {
    foreach(new i:tankcontainers) {
        if (IsPlayerInRangeOfPoint(playerid, Float:range, OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][0], OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][1], OilCompany:TankContainerData[i][OilCompany:TK_WorkerPos][2])) return i;
    }
    return -1;
}

stock OilCompany:UpdateMachineData(machineid) {
    new string[512];
    strcat(string, sprintf("{00FF00}Oil Mill Machinery [%d]\n\n", machineid));
    strcat(string, sprintf("{DC143C}State: {FFFFFF}%s\n", OilCompany:GetMachineStateName(machineid)));
    strcat(string, sprintf("{DC143C}Last Maintanance At: {FFFFFF}%s\n", UnixToHumanEx(OilCompany:MineMachineData[machineid][OilCompany:FM_LastRepair])));
    strcat(string, sprintf("{DC143C}Tank: {FFFFFF}%d\n", OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]));
    strcat(string, sprintf("{DC143C}Fuel Stored in Tank: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]][OilCompany:TK_FuelStored]));
    strcat(string, sprintf("{DC143C}Fuel Capacity in Tank: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]][OilCompany:TK_FuelCapacity]));
    strcat(string, "{FFFFFF}press N to start work");
    UpdateDynamic3DTextLabelText(OilCompany:MineMachineData[machineid][OilCompany:FM_3dTextLabel], -1, string);
    return 1;
}

stock OilCompany:UpdateTankData(tankid) {
    new string[512];
    strcat(string, sprintf("{00FF00}Oil Tank Status [%d]\n\n", tankid));
    strcat(string, sprintf("{DC143C}State: {FFFFFF}%s\n", OilCompany:GetTankStateName(tankid)));
    strcat(string, sprintf("{DC143C}Last Maintanance At: {FFFFFF}%s\n", UnixToHumanEx(OilCompany:TankContainerData[tankid][OilCompany:TK_LastRepair])));
    strcat(string, sprintf("{DC143C}Fuel Stored: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored]));
    strcat(string, sprintf("{DC143C}Fuel Capacity: {FFFFFF}%d gallon\n", OilCompany:TankContainerData[tankid][OilCompany:TK_FuelCapacity]));
    strcat(string, sprintf("{DC143C}Fuel Price: {FFFFFF} $%s/gallon\n", FormatCurrency(OilCompany:TankContainerData[tankid][OilCompany:TK_FuelPrice])));
    strcat(string, "{FFFFFF}press N to start work");
    UpdateDynamic3DTextLabelText(OilCompany:TankContainerData[tankid][OilCompany:TK_3dTextLabel], -1, string);
    return 1;
}

stock OilCompany:StartWorkOnMachine(playerid, machineid) {
    if (OilCompany:MineMachineData[machineid][OilCompany:FM_Locked] == 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The machine is locked by IORP Owner.");
    if (OilCompany:MineMachineData[machineid][OilCompany:FM_State] == 0) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The machine could not start, required Maintenance.");
        return 1;
    }
    if (OilCompany:MineMachineData[machineid][OilCompany:FM_State] == 2) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The machine is occupied, try another machine.");
        return 1;
    }
    if (OilCompany:MineMachineData[machineid][OilCompany:FM_State] != 1) return 1;
    freeze(playerid);
    SetPlayerPosEx(playerid, OilCompany:MineMachineData[machineid][OilCompany:FM_MachinePos][0], OilCompany:MineMachineData[machineid][OilCompany:FM_MachinePos][1], OilCompany:MineMachineData[machineid][OilCompany:FM_MachinePos][2]);
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    Anim:SetState(playerid, true);
    OilCompany:PlayerData[playerid][OilCompany:FM_ID] = machineid;
    OilCompany:PlayerData[playerid][OilCompany:WorkingOnFM] = true;
    OilCompany:PlayerData[playerid][OilCompany:FM_Timer] = SetPreciseTimer("GenerateFuel", 1000, true, "dd", playerid, machineid);
    OilCompany:MineMachineData[machineid][OilCompany:FM_State] = 2;
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The machine is starting, press N to stop work.");
    OilCompany:UpdateMachineData(machineid);
    return 1;
}

stock OilCompany:StopWorkOnMachine(playerid) {
    if (IsPlayerConnected(playerid)) {
        Anim:Stop(playerid);
        unfreeze(playerid);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The machine is stopped, work again to start the machine.");
    }
    DeletePreciseTimer(OilCompany:PlayerData[playerid][OilCompany:FM_Timer]);
    OilCompany:MineMachineData[OilCompany:PlayerData[playerid][OilCompany:FM_ID]][OilCompany:FM_State] = 1;
    OilCompany:UpdateMachineData(OilCompany:PlayerData[playerid][OilCompany:FM_ID]);
    OilCompany:PlayerData[playerid][OilCompany:FM_Timer] = -1;
    OilCompany:PlayerData[playerid][OilCompany:FM_ID] = -1;
    OilCompany:PlayerData[playerid][OilCompany:WorkingOnFM] = false;
    return 1;
}

forward GenerateFuel(playerid, machineid);
public GenerateFuel(playerid, machineid) {
    if (!IsPlayerConnected(playerid)) OilCompany:StopWorkOnMachine(playerid);
    if (OilCompany:TankContainerData[OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]][OilCompany:TK_FuelStored] < OilCompany:TankContainerData[OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]][OilCompany:TK_FuelCapacity]) {
        OilCompany:TankContainerData[OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]][OilCompany:TK_FuelStored]++;
        OilCompany:UpdateMachineData(machineid);
        OilCompany:UpdateTankData(OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]);
        OilCompany:SaveFuelTanksData(OilCompany:MineMachineData[machineid][OilCompany:FM_Tank]);
    } else OilCompany:StopWorkOnMachine(playerid);
    return 1;
}

forward RepairMachine(playerid, machineid);
public RepairMachine(playerid, machineid) {
    OilCompany:MineMachineData[machineid][OilCompany:FM_State] = 1;
    OilCompany:MineMachineData[machineid][OilCompany:FM_LastRepair] = gettime();
    OilCompany:SaveFuelMinesData(machineid);
    OilCompany:UpdateMachineData(machineid);
    Anim:Stop(playerid);
    unfreeze(playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}good work, the machine is good now.");
    return 1;
}

forward RepairTank(playerid, tankid);
public RepairTank(playerid, tankid) {
    OilCompany:TankContainerData[tankid][OilCompany:TK_State] = 1;
    OilCompany:TankContainerData[tankid][OilCompany:TK_LastRepair] = gettime();
    OilCompany:SaveFuelTanksData(tankid);
    OilCompany:UpdateTankData(tankid);
    Anim:Stop(playerid);
    unfreeze(playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}good work, the tank looks good now.");
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new oilM = OilCompany:GetPlayerNearestMachine(playerid);
    if (oilM != -1) {
        if (Faction:GetPlayerFID(playerid) == FACTION_ID_DOM && Faction:IsPlayerSigned(playerid) && OilCompany:MineMachineData[oilM][OilCompany:FM_State] == 0) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}please wait, this will take a while to fix machine.");
            SetPreciseTimer("RepairMachine", 2 * 60 * 1000, false, "dd", playerid, oilM);
            StopScreenTimer(playerid, 1);
            StartScreenTimer(playerid, 2 * 60);
            freeze(playerid);
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
            Anim:SetState(playerid, true);
            return ~1;
        }
        if (Faction:GetPlayerFID(playerid) != FACTION_ID_IOPL || !Faction:IsPlayerSigned(playerid)) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}only indian oil staff is allowed to access this machine.");
            return ~1;
        }
        if (OilCompany:PlayerData[playerid][OilCompany:WorkingOnFM]) OilCompany:StopWorkOnMachine(playerid);
        else OilCompany:StartWorkOnMachine(playerid, oilM);
        return ~1;
    }
    new oilT = OilCompany:GetPlayerNearestTankControl(playerid);
    if (oilT != -1) {
        if (Faction:GetPlayerFID(playerid) == FACTION_ID_DOM && Faction:IsPlayerSigned(playerid) && OilCompany:TankContainerData[oilT][OilCompany:TK_State] == 0) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}please wait, this will take a while to fix tank.");
            SetPreciseTimer("RepairTank", 2 * 60 * 1000, false, "dd", playerid, oilT);
            StopScreenTimer(playerid, 1);
            StartScreenTimer(playerid, 2 * 60);
            freeze(playerid);
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
            Anim:SetState(playerid, true);
            return ~1;
        }
        if (Faction:GetPlayerFID(playerid) != FACTION_ID_IOPL || !Faction:IsPlayerSigned(playerid)) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}only indian oil staff is allowed to access this tank.");
            return ~1;
        }
        if (IsStringSame(GetPlayerNameEx(playerid), Faction:GetLeaderName(FACTION_ID_IOPL))) {
            OilCompany:AccessTankOwner(playerid, oilT);
            return ~1;
        }
        OilCompany:AccessTank(playerid, oilT);
        return ~1;
    }
    return 1;
}

stock OilCompany:AccessTank(playerid, tankid) {
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_Locked] == 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The tank is locked by IORP Owner.");
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_State] == 0) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The tank required Maintenance, call mechanic.");
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_State] == 2) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The tank is occupied, try another tank.");
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_State] != 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}The tank is I don't know, try another tank.");
    if (!IsValidVehicle(OilCompany:TankContainerData[tankid][OilCompany:vehicleid]) || !IsValidVehicle(OilCompany:TankContainerData[tankid][OilCompany:TrailerID])) {
        return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}trailer is not aligned in position.");
    }
    if (OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored] < 1) {
        return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}There is no fuel to load in the tank, try again after refueling tanks.");
    }
    return OilCompany:LoadFuelMenu(playerid, tankid);
}

stock OilCompany:StopFillingTanker(tankid) {
    if (IsPlayerConnected(OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID])) {
        if (OilCompany:TankContainerData[tankid][OilCompany:money] < OilCompany:TankContainerData[tankid][OilCompany:chargedmoney]) {
            new refundamount = OilCompany:TankContainerData[tankid][OilCompany:chargedmoney] - OilCompany:TankContainerData[tankid][OilCompany:money];
            vault:PlayerVault(
                OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID], refundamount, sprintf("iopl: fuel load charge refund from tank %d", tankid),
                Vault_ID_IndianOIL, -refundamount, sprintf(
                    "refunded to %s for fuel load early stopped refund from tank %d",
                    GetPlayerNameEx(OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID]), tankid
                )
            );
        }
        SendClientMessage(OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID], -1, "{4286f4}[Alexa]: {FFFFFF}tanker filling stopped.");
    }
    DeletePreciseTimer(OilCompany:TankContainerData[tankid][OilCompany:timerid]);
    OilCompany:TankContainerData[tankid][OilCompany:timerid] = -1;
    OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID] = -1;
    OilCompany:TankContainerData[tankid][OilCompany:lFuel] = 0;
    OilCompany:TankContainerData[tankid][OilCompany:money] = 0;
    OilCompany:TankContainerData[tankid][OilCompany:chargedmoney] = 0;
    OilCompany:TankContainerData[tankid][OilCompany:tankerfilling] = false;
    OilCompany:TankContainerData[tankid][OilCompany:TK_State] = 1;
    OilCompany:SaveFuelTanksData(tankid);
    return 1;
}

forward FillFuelInTanker(tankid);
public FillFuelInTanker(tankid) {
    if (!OilCompany:TankContainerData[tankid][OilCompany:tankerfilling]) return 1;
    if (!IsValidVehicle(OilCompany:TankContainerData[tankid][OilCompany:vehicleid]) || !IsValidVehicle(OilCompany:TankContainerData[tankid][OilCompany:TrailerID]) || OilCompany:TankContainerData[tankid][OilCompany:lFuel] < 1 || !IsPlayerConnected(OilCompany:TankContainerData[tankid][OilCompany:tankWorkerID])) {
        OilCompany:StopFillingTanker(tankid);
        return 1;
    }
    if (!IsVehicleInRangeOfPoint(OilCompany:TankContainerData[tankid][OilCompany:vehicleid], 10.0, OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][0], OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][1], OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][2]) || !IsVehicleInRangeOfPoint(OilCompany:TankContainerData[tankid][OilCompany:TrailerID], 20.0, OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][0], OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][1], OilCompany:TankContainerData[tankid][OilCompany:TK_TankerPos][2])) {
        OilCompany:StopFillingTanker(tankid);
        return 1;
    }
    if (OilCompany:GetTankerFuel(OilCompany:TankContainerData[tankid][OilCompany:TrailerID]) >= TrailerStorage:GetResourceLimit(TrailerStorage:GetID("Fuel"))) {
        OilCompany:StopFillingTanker(tankid);
        return 1;
    }
    OilCompany:TankContainerData[tankid][OilCompany:TK_State] = 2;
    OilCompany:TankContainerData[tankid][OilCompany:lFuel]--;
    OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored]--;
    TrailerStorage:IncreaseResourceByName(OilCompany:TankContainerData[tankid][OilCompany:TrailerID], "Fuel", 1);
    OilCompany:TankContainerData[tankid][OilCompany:money] += OilCompany:TankContainerData[tankid][OilCompany:TK_FuelPrice];
    OilCompany:UpdateTankData(tankid);
    return 1;
}

hook OnTrailerHooked(playerid, vehicleid, trailerid) {
    if (GetVehicleModel(trailerid) == 584) {
        if (OilCompany:GetTankerFuel(trailerid) > 0) {
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}this tailer has %d gallon stored inside.", OilCompany:GetTankerFuel(trailerid)));
        }
    }
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if (ispassenger) return 1;
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid != 0) {
        if (GetVehicleModel(trailerid) == 584) {
            if (OilCompany:GetTankerFuel(trailerid) > 0) {
                SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}this tailer has %d gallon stored inside.", OilCompany:GetTankerFuel(trailerid)));
            }
        }
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    foreach(new i:tankcontainers) {
        if (checkpointid == OilCompany:TankContainerData[i][OilCompany:TK_WorkerCP]) {
            if (IsPlayerInAnyVehicle(playerid) && Faction:GetPlayerFID(playerid) == FACTION_ID_SATD && Faction:IsPlayerSigned(playerid)) {
                new vehicleid = GetPlayerVehicleID(playerid);
                new trailerID = GetVehicleTrailer(vehicleid);
                if (trailerID != 0) {
                    if (GetVehicleModel(trailerID) == 584 && StaticVehicle:IsStatic(trailerID)) {
                        if (TrailerStorage:GetResourceTypesLoaded(trailerID) > 1) {
                            AlexaMsg(playerid, "your trailer have some unwanted resource, please unload them first");
                            return ~1;
                        }
                        OilCompany:TankContainerData[i][OilCompany:vehicleid] = vehicleid;
                        OilCompany:TankContainerData[i][OilCompany:TrailerID] = trailerID;
                        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}park your tanker here, to load fuel.");
                    }
                }
            }
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    foreach(new i:tankcontainers) {
        if (checkpointid == OilCompany:TankContainerData[i][OilCompany:TK_WorkerCP]) {
            if (IsPlayerInAnyVehicle(playerid)) {
                new vehicleid = GetPlayerVehicleID(playerid);
                new trailerID = GetVehicleTrailer(vehicleid);
                if (trailerID != 0) {
                    if (GetVehicleModel(trailerID) == 584 && StaticVehicle:IsStatic(trailerID)) {
                        OilCompany:TankContainerData[i][OilCompany:vehicleid] = -1;
                        OilCompany:TankContainerData[i][OilCompany:TrailerID] = -1;
                        if (OilCompany:TankContainerData[i][OilCompany:tankerfilling]) OilCompany:StopFillingTanker(i);
                    }
                }
            }
            return ~1;
        }
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "fuel factory") && GetPlayerAdminLevel(playerid) >= 8) {
        return OilCompany:admin(playerid);
    }
    return 1;
}

stock OilCompany:LoadFuelMenu(playerid, tankid) {
    return FlexPlayerDialog(playerid, "OilMenuLoadFuel", DIALOG_STYLE_INPUT, "{4286f4}[Indian Oil]: {FFFFFF}Load Fuel",
        sprintf("Enter Fuel to load in tanker\nLimit: 1 to %d", OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored]),
        "Load", "Close", tankid
    );
}

FlexDialog:OilMenuLoadFuel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new loadfuelamount, tankid = extraid;
    if (sscanf(inputtext, "d", loadfuelamount) || loadfuelamount < 1 || loadfuelamount > OilCompany:TankContainerData[tankid][OilCompany:TK_FuelStored]) {
        return OilCompany:LoadFuelMenu(playerid, tankid);
    }
    if (loadfuelamount > OilCompany:GetTankerRemainingSpace(OilCompany:TankContainerData[extraid][OilCompany:TrailerID])) {
        AlexaMsg(playerid, "fuel trailer does not have enough storage, try lower value");
        return OilCompany:LoadFuelMenu(playerid, tankid);
    }
    new cashrequired = loadfuelamount * OilCompany:TankContainerData[tankid][OilCompany:TK_FuelPrice];
    if (cashrequired > GetPlayerCash(playerid)) {
        AlexaMsg(playerid, "you don't have enough money to purchase fuel");
        return OilCompany:LoadFuelMenu(playerid, tankid);
    }
    vault:PlayerVault(
        playerid, -cashrequired, sprintf("indian OilCompany: %d liter fuel load from tank %d charge", loadfuelamount, tankid),
        Vault_ID_IndianOIL, cashrequired, sprintf(
            "collected from %s for %d liter fuel load from tank %d",
            GetPlayerNameEx(playerid), loadfuelamount, tankid
        )
    );
    OilCompany:TankContainerData[extraid][OilCompany:tankerfilling] = true;
    OilCompany:TankContainerData[extraid][OilCompany:tankWorkerID] = playerid;
    OilCompany:TankContainerData[extraid][OilCompany:lFuel] = loadfuelamount;
    OilCompany:TankContainerData[extraid][OilCompany:money] = 0;
    OilCompany:TankContainerData[extraid][OilCompany:chargedmoney] = cashrequired;
    OilCompany:TankContainerData[extraid][OilCompany:timerid] = SetPreciseTimer("FillFuelInTanker", 250, true, "d", extraid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}tanker filling started.");
    return 1;
}

stock OilCompany:AccessTankOwner(playerid, tankid) {
    new string[512];
    strcat(string, "Access Tank\n");
    strcat(string, "Update Fuel Price\n");
    strcat(string, "Lock All Tanks\n");
    strcat(string, "Unlock All Tanks\n");
    strcat(string, "Lock All Machines\n");
    strcat(string, "Unlock All Machines\n");
    FlexPlayerDialog(playerid, "OilMenuOwner", DIALOG_STYLE_LIST, "Indian Oil: Tank", string, "Select", "Close", tankid);
    return 1;
}

FlexDialog:OilMenuOwner(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new tankid = extraid;
    if (IsStringSame(inputtext, "Access Tank")) return OilCompany:AccessTank(playerid, tankid);
    if (IsStringSame(inputtext, "Update Fuel Price")) return OilCompany:MenuUpdateFuelPrice(playerid, tankid);
    if (IsStringSame(inputtext, "Lock All Tanks")) {
        foreach(new i:tankcontainers) {
            OilCompany:TankContainerData[i][OilCompany:TK_Locked] = 1;
            OilCompany:UpdateTankData(i);
            OilCompany:SaveFuelTanksData(i);
        }
        return AlexaMsg(playerid, "All tanks are locked, they can not be used by iopl workers now.");
    }
    if (IsStringSame(inputtext, "Unlock All Tanks")) {
        foreach(new i:tankcontainers) {
            OilCompany:TankContainerData[i][OilCompany:TK_Locked] = 0;
            OilCompany:UpdateTankData(i);
            OilCompany:SaveFuelTanksData(i);
        }
        return AlexaMsg(playerid, "All tanks are unlocked, they can be used by iopl workers now.");
    }
    if (IsStringSame(inputtext, "Lock All Machines")) {
        foreach(new i:minemachines) {
            OilCompany:MineMachineData[i][OilCompany:FM_Locked] = 1;
            OilCompany:UpdateMachineData(i);
            OilCompany:SaveFuelMinesData(i);
        }
        return AlexaMsg(playerid, "All machines are locked, they can not be used by iopl workers now.");
    }
    if (IsStringSame(inputtext, "Unlock All Machines")) {
        foreach(new i:minemachines) {
            OilCompany:MineMachineData[i][OilCompany:FM_Locked] = 0;
            OilCompany:UpdateMachineData(i);
            OilCompany:SaveFuelMinesData(i);
        }
        return AlexaMsg(playerid, "All machines are unlocked, they can be used by iopl workers now.");
    }
    return 1;
}

stock OilCompany:MenuUpdateFuelPrice(playerid, tankid) {
    return FlexPlayerDialog(playerid, "OilMenuUpdateFuelPrice", DIALOG_STYLE_INPUT, "Indian Oil: Tank", "Enter new fuel price", "Update", "Close", tankid);
}

FlexDialog:OilMenuUpdateFuelPrice(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new tankid = extraid;
    if (!response) return OilCompany:AccessTankOwner(playerid, tankid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1 || newprice > 50) return OilCompany:MenuUpdateFuelPrice(playerid, tankid);
    OilCompany:TankContainerData[tankid][OilCompany:TK_FuelPrice] = newprice;
    OilCompany:UpdateTankData(tankid);
    OilCompany:SaveFuelTanksData(tankid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}tank fuel reselling price has been updated.");
    OilCompany:AccessTankOwner(playerid, tankid);
    return 1;
}

stock OilCompany:admin(playerid) {
    new string[512];
    strcat(string, "Set Fuel in Oil Tanks\n");
    strcat(string, "Reset Maintenance\n");
    return FlexPlayerDialog(playerid, "oilAdminMenu", DIALOG_STYLE_LIST, "{4286f4}[Indian Oil]: {FFFFFF}Admin Access", string, "Select", "Close");
}

FlexDialog:oilAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Set Fuel in Oil Tanks")) return OilCompany:AdminMenuSetFuel(playerid);
    if (IsStringSame(inputtext, "Reset Maintenance")) {
        foreach(new i:tankcontainers) {
            OilCompany:TankContainerData[i][OilCompany:TK_State] = 1;
            OilCompany:TankContainerData[i][OilCompany:TK_LastRepair] = gettime();
            OilCompany:UpdateTankData(i);
            OilCompany:SaveFuelTanksData(i);
        }
        foreach(new i:minemachines) {
            OilCompany:MineMachineData[i][OilCompany:FM_State] = 1;
            OilCompany:MineMachineData[i][OilCompany:FM_LastRepair] = gettime();
            OilCompany:UpdateMachineData(i);
            OilCompany:SaveFuelMinesData(i);
        }
        AlexaMsg(playerid, "iopl maintance has been reseted, all machines and tank are available now.");
        return OilCompany:admin(playerid);
    }
    return 1;
}

stock OilCompany:AdminMenuSetFuel(playerid) {
    return FlexPlayerDialog(playerid, "OilAdminSetFuel", DIALOG_STYLE_INPUT, "{4286f4}[Indian Oil]: {FFFFFF}Admin Access", "Enter fuel to set in oil tanks\nLimit 1 to 10,000", "Select", "Close");
}

FlexDialog:OilAdminSetFuel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return OilCompany:admin(playerid);
    new fuelamount;
    if (sscanf(inputtext, "d", fuelamount) || fuelamount < 1 || fuelamount > 10000) return OilCompany:AdminMenuSetFuel(playerid);
    foreach(new i:tankcontainers) {
        OilCompany:TankContainerData[i][OilCompany:TK_FuelStored] = fuelamount;
        OilCompany:UpdateTankData(i);
    }
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}fuel tank has been reset to %d.", fuelamount));
    return OilCompany:admin(playerid);
}