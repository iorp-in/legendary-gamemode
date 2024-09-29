//#region vars
#define FUEL_RESET_INTERVAL 30

#define UPDATE_RATE (30000)      // Fuel consume rate in milliseconds. (Default:1000)
#define Max_Fuel_Business_Purchase 1
#define MAX_Fuel_Store 30
#define MAX_Fuel_PUMPS 100

enum e_pump_business {
    Float:PumpBusiness:location[3],
        PumpBusiness:vwint[2],
        PumpBusiness:owner[50],
        PumpBusiness:saleprice,
        PumpBusiness:balance,
        PumpBusiness:lastAccessAt,
        PumpBusiness:PurchasedAt,
        STREAMER_TAG_3D_TEXT_LABEL:PumpBusiness:pumpLabel,
        PumpBusiness:pumpPickup,
        PumpBusiness:pumpMapIcon
}
new PumpBusiness:data[MAX_Fuel_Store][e_pump_business];
new Iterator:fuelBusiness < MAX_Fuel_Store > ;

enum e_pump {
    pumpStoreID,
    pumpFuelPrice,
    pumpStoredGallon,
    pumpStoredCapcity,
    bool:pumpRefill,
    bool:pumpfill,
    Float:pumpX,
    Float:pumpY,
    Float:pumpZ,
    pumpUser,
    Text3D:pumpLabel,
    pumpRefillFromTank[4]
}

new PumpData[MAX_Fuel_PUMPS][e_pump];
new Iterator:fuelpumps < MAX_Fuel_PUMPS > ;

new UsingPumpID[MAX_PLAYERS] = {-1, ... },
    RefuelTimer[MAX_PLAYERS] = {-1, ... },
    Float:FuelBought[MAX_PLAYERS],
    PlayerText:FuelText[MAX_PLAYERS];
//PlayerBar:FuelBar[MAX_PLAYERS] = {INVALID_PLAYER_BAR_ID, ...};

new Float:Fuel[MAX_VEHICLES] = { 10.0, ... },
    Float:VehicleLastCoords[MAX_VEHICLES][3];

//#endregion

stock Float:GetVehicleFuelEx(vehicleid) {
    return Fuel[vehicleid];
}

stock SetVehicleFuelEx(vehicleid, Float:fuel) {
    Fuel[vehicleid] = fuel;
    return 1;
}

stock IncreaseDecreaseVehicleFuel(vehicleid, Float:fuel) {
    Fuel[vehicleid] += fuel;
    return 1;
}

stock Float:PumpBusiness:GetFuelBought(playerid) {
    return FuelBought[playerid];
}

stock PumpBusiness:SetFuelBought(playerid, Float:fuel) {
    FuelBought[playerid] = fuel;
    return 1;
}

stock PumpBusiness:IncreaseDecreaseFuelBought(playerid, Float:fuel) {
    FuelBought[playerid] += fuel;
    return 1;
}

stock PumpBusiness:GetBalance(bussid) {
    return PumpBusiness:data[bussid][PumpBusiness:balance];
}

stock PumpBusiness:SetBalance(bussid, amount) {
    return PumpBusiness:data[bussid][PumpBusiness:balance] = amount;
}

stock PumpBusiness:IncreaseBalance(bussid, amount, const log[]) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    mysql_tquery(Database, sprintf("insert into fuelStationTransactions (bussid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        bussid, amount, PumpBusiness:data[bussid][PumpBusiness:balance], log, gettime()));
    PumpBusiness:data[bussid][PumpBusiness:balance] += amount;
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:DecreaseBalance(bussid, amount, const log[]) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    mysql_tquery(Database, sprintf("insert into fuelStationTransactions (bussid, amount, balance, log, time) values(%d, %d, %d, \"%s\", %d)",
        bussid, amount * -1, PumpBusiness:data[bussid][PumpBusiness:balance], log, gettime()));
    PumpBusiness:data[bussid][PumpBusiness:balance] -= amount;
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:IsValidID(bussid) {
    return Iter_Contains(fuelBusiness, bussid);
}

stock PumpBusiness:GetTotalPurchased(const name[]) {
    new count = 0;
    foreach(new bussid:fuelBusiness) {
        if (IsStringSame(name, PumpBusiness:data[bussid][PumpBusiness:owner])) count++;
    }
    return count;
}

stock PumpBusiness:IsPurchased(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    return strcmp(PumpBusiness:data[bussid][PumpBusiness:owner], "-");
}

stock PumpBusiness:GetPurchasedAt(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    return PumpBusiness:data[bussid][PumpBusiness:PurchasedAt];
}

stock PumpBusiness:UpdatePurchasedAt(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    PumpBusiness:data[bussid][PumpBusiness:PurchasedAt] = gettime();
    return 1;
}

stock PumpBusiness:IsPlayerOwner(playerid, bussid) {
    return IsStringSame(PumpBusiness:GetOwner(bussid), GetPlayerNameEx(playerid));
}

stock PumpBusiness:GetOwner(bussid) {
    new string[50];
    if (!PumpBusiness:IsValidID(bussid)) format(string, sizeof string, "-");
    else format(string, sizeof string, "%s", PumpBusiness:data[bussid][PumpBusiness:owner]);
    return string;
}

stock PumpBusiness:GetPrice(bussid) {
    return PumpBusiness:data[bussid][PumpBusiness:saleprice];
}

stock PumpBusiness:GetNearest(playerid, Float:range = 3.0) {
    foreach(new bussid:fuelBusiness) {
        if (IsPlayerInRangeOfPoint(playerid, Float:range, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2])) return bussid;
    }
    return -1;
}

stock PumpBusiness:Create(playerid) {
    new bussid = Iter_Free(fuelBusiness);
    if (bussid == INVALID_ITERATOR_SLOT) return -1;
    Iter_Add(fuelBusiness, bussid);
    GetPlayerPos(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
    PumpBusiness:data[bussid][PumpBusiness:vwint][0] = GetPlayerVirtualWorldID(playerid);
    PumpBusiness:data[bussid][PumpBusiness:vwint][1] = GetPlayerInteriorID(playerid);
    format(PumpBusiness:data[bussid][PumpBusiness:owner], 50, "-");
    PumpBusiness:data[bussid][PumpBusiness:saleprice] = Random(500000, 1000000);
    PumpBusiness:data[bussid][PumpBusiness:balance] = 0;
    PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] = gettime();
    PumpBusiness:data[bussid][PumpBusiness:PurchasedAt] = gettime();
    PumpBusiness:data[bussid][PumpBusiness:pumpLabel] = CreateDynamic3DTextLabel("Fuel Station", 0xF1C40FFF, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 7.5);
    PumpBusiness:data[bussid][PumpBusiness:pumpPickup] = CreateDynamicPickup(1210, 23, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
    PumpBusiness:data[bussid][PumpBusiness:pumpMapIcon] = CreateDynamicMapIcon(PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 51, 0);
    PumpBusiness:UpdateText(bussid, false);
    mysql_tquery(Database, sprintf("insert into fuelStations set X = %f, Y = %f, Z = %f, vwID = %d, intID = %d, saleprice = %d, balance = %d, lastAccessAt = %d, owner = \"%s\", ID = %d",
        PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], PumpBusiness:data[bussid][PumpBusiness:vwint][0], PumpBusiness:data[bussid][PumpBusiness:vwint][1],
        PumpBusiness:data[bussid][PumpBusiness:saleprice], PumpBusiness:data[bussid][PumpBusiness:balance], PumpBusiness:data[bussid][PumpBusiness:lastAccessAt], PumpBusiness:data[bussid][PumpBusiness:owner], bussid), "", "");
    return bussid;
}

stock PumpBusiness:Reset(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    format(PumpBusiness:data[bussid][PumpBusiness:owner], 50, "-");
    PumpBusiness:data[bussid][PumpBusiness:saleprice] = Random(500000, 1000000);
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:Remove(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    format(PumpBusiness:data[bussid][PumpBusiness:owner], 50, "-");
    DestroyDynamic3DTextLabel(PumpBusiness:data[bussid][PumpBusiness:pumpLabel]);
    DestroyDynamicPickup(PumpBusiness:data[bussid][PumpBusiness:pumpPickup]);
    DestroyDynamicMapIcon(PumpBusiness:data[bussid][PumpBusiness:pumpMapIcon]);
    Iter_Remove(fuelBusiness, bussid);
    mysql_tquery(Database, sprintf("delete from fuelStations where ID = %d", bussid));
    return 1;
}

stock PumpBusiness:UpdateCordinates(playerid, bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    GetPlayerPos(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
    PumpBusiness:data[bussid][PumpBusiness:vwint][0] = GetPlayerVirtualWorldID(playerid);
    PumpBusiness:data[bussid][PumpBusiness:vwint][1] = GetPlayerInteriorID(playerid);
    DestroyDynamic3DTextLabel(PumpBusiness:data[bussid][PumpBusiness:pumpLabel]);
    DestroyDynamicPickup(PumpBusiness:data[bussid][PumpBusiness:pumpPickup]);
    DestroyDynamicMapIcon(PumpBusiness:data[bussid][PumpBusiness:pumpMapIcon]);
    PumpBusiness:data[bussid][PumpBusiness:pumpLabel] = CreateDynamic3DTextLabel("Fuel Station", 0xF1C40FFF, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 7.5);
    PumpBusiness:data[bussid][PumpBusiness:pumpPickup] = CreateDynamicPickup(1210, 23, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
    PumpBusiness:data[bussid][PumpBusiness:pumpMapIcon] = CreateDynamicMapIcon(PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 51, 0);
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:UpdateOwner(bussid, const owner[]) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    format(PumpBusiness:data[bussid][PumpBusiness:owner], 50, "%s", owner);
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:UpdateDB(bussid) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    mysql_tquery(Database, sprintf(
        "update fuelStations set X = %f, Y = %f, Z = %f, vwID = %d, intID = %d, saleprice = %d, balance = %d,\
        lastAccessAt = %d, PurchasedAt = %d, owner = \"%s\" where ID = %d",
        PumpBusiness:data[bussid][PumpBusiness:location][0],
        PumpBusiness:data[bussid][PumpBusiness:location][1],
        PumpBusiness:data[bussid][PumpBusiness:location][2],
        PumpBusiness:data[bussid][PumpBusiness:vwint][0],
        PumpBusiness:data[bussid][PumpBusiness:vwint][1],
        PumpBusiness:data[bussid][PumpBusiness:saleprice],
        PumpBusiness:data[bussid][PumpBusiness:balance],
        PumpBusiness:data[bussid][PumpBusiness:lastAccessAt],
        PumpBusiness:data[bussid][PumpBusiness:PurchasedAt],
        PumpBusiness:data[bussid][PumpBusiness:owner],
        bussid
    ));
    return 1;
}

stock PumpBusiness:GetSalePrice(bussid) {
    return PumpBusiness:data[bussid][PumpBusiness:saleprice];
}

stock PumpBusiness:IsHaveFuel(bussid) {
    foreach(new pumpid:fuelpumps) {
        if (
            PumpBusiness:GetPumpBussID(pumpid) == bussid &&
            PumpBusiness:GetPumpFuel(pumpid) > 10.0
        ) {
            return 1;
        }
    }
    return 0;
}

stock PumpBusiness:UpdateSalePrice(bussid, newPrice) {
    PumpBusiness:data[bussid][PumpBusiness:saleprice] = newPrice;
    PumpBusiness:UpdateText(bussid);
    return 1;
}

stock PumpBusiness:UpdateText(bussid, bool:updatesql = true) {
    if (!PumpBusiness:IsValidID(bussid)) return 0;
    new lastVisit[100];
    UnixToHuman(PumpBusiness:data[bussid][PumpBusiness:lastAccessAt], lastVisit);
    if (PumpBusiness:IsPurchased(bussid)) UpdateDynamic3DTextLabelText(PumpBusiness:data[bussid][PumpBusiness:pumpLabel], 0xF1C40FFF, sprintf("Fuel Station [%d]\n\nOwner: %s\nLast Visited: %s\npress N to access", bussid, PumpBusiness:data[bussid][PumpBusiness:owner], lastVisit));
    else UpdateDynamic3DTextLabelText(
        PumpBusiness:data[bussid][PumpBusiness:pumpLabel], 0xF1C40FFF,
        sprintf(
            "Fuel Station [%d]\nProperty Of: San Andreas Government Department\n\non sale: $%s\npress N to purchase",
            bussid, FormatCurrency(PumpBusiness:GetSalePrice(bussid))
        )
    );
    if (updatesql) PumpBusiness:UpdateDB(bussid);
    return 1;
}

stock PumpBusiness:GetTotalPumps(bussid) {
    new count = 0;
    foreach(new pumpid:fuelpumps) {
        if (PumpData[pumpid][pumpStoreID] == bussid) count++;
    }
    return count;
}

stock PumpBusiness:GetPumpBussID(pumpid) {
    return PumpData[pumpid][pumpStoreID];
}

stock PumpBusiness:IsUsingByAnyone(pumpid) {
    if (IsPlayerConnected(PumpBusiness:GetPumpUser(pumpid))) return 1;
    return 0;
}

stock PumpBusiness:GetPumpUser(pumpid) {
    return PumpData[pumpid][pumpUser];
}

stock PumpBusiness:SetPumpUser(pumpid, playerid) {
    return PumpData[pumpid][pumpUser] = playerid;
}

stock PumpBusiness:IsValidPumpID(pumpid) {
    return Iter_Contains(fuelpumps, pumpid);
}

stock PumpBusiness:GetPumpFillingStatus(pumpid) {
    return PumpData[pumpid][pumpfill];
}

stock PumpBusiness:GetPumpRefillingStatus(pumpid) {
    return PumpData[pumpid][pumpRefill];
}

stock PumpBusiness:GetPumpFuel(pumpid) {
    return PumpData[pumpid][pumpStoredGallon];
}

stock PumpBusiness:UpdatePumpFuel(pumpid, fuel) {
    return PumpData[pumpid][pumpStoredGallon] = fuel;
}

stock PumpBusiness:IncreaseDecreasePumpFuel(pumpid, fuel) {
    return PumpData[pumpid][pumpStoredGallon] += fuel;
}

stock PumpBusiness:GetPumpFuelPrice(pumpid) {
    return PumpData[pumpid][pumpFuelPrice];
}

stock PumpBusiness:UpdatePumpFuelPrice(pumpid, newprice) {
    return PumpData[pumpid][pumpFuelPrice] = newprice;
}

stock PumpBusiness:GetPumpCapacity(pumpid) {
    return PumpData[pumpid][pumpStoredCapcity];
}

stock PumpBusiness:UpdatePumpCapacity(pumpid, capacity) {
    return PumpData[pumpid][pumpStoredCapcity] = capacity;
}

stock PumpBusiness:GetPlayerUsingPumpID(playerid) {
    return UsingPumpID[playerid];
}

stock PumpBusiness:SetPlayerUsingPumpID(playerid, pumpid) {
    return UsingPumpID[playerid] = pumpid;
}

stock IsVehicleHaveFuelTank(vehicleid) {
    if (IsVehicleModelCycle(vehicleid) || IsVehicleModelRC(vehicleid) || IsVehicleModelTrailer(vehicleid)) return 0;
    return 1;
}

stock PumpBusiness:UpdatePump(pumpid, bool:updatesql = true) {
    UpdateDynamic3DTextLabelText(PumpData[pumpid][pumpLabel], 0xF1C40FFF,
        sprintf(
            "Gas Pump [%d][%d]\n\n{2ECC71}$%s / Litre [remaining fuel: %d/%d]\nRefilling: %s\nFilling: %s\n%spress N",
            pumpid, PumpBusiness:GetPumpBussID(pumpid), FormatCurrency(PumpBusiness:GetPumpFuelPrice(pumpid)), PumpBusiness:GetPumpFuel(pumpid),
            PumpBusiness:GetPumpCapacity(pumpid), PumpBusiness:GetPumpRefillingStatus(pumpid) ? ("Enabled") : (" Disabled"),
            PumpBusiness:GetPumpFillingStatus(pumpid) ? ("Enabled") : ("Disabled"),
            (PumpBusiness:IsUsingByAnyone(pumpid)) ? ("{4286f4}") : ("{FFFFFF}")
        )
    );
    if (updatesql) mysql_tquery(Database,
        sprintf(
            "update fuelPumps set storeID = %d, cFuelPrice = %d, fuelStored = %d, fuelCapacity = %d, pumpRefill = %d, \
        pumpFill = %d, pumpX = %f, pumpY = %f, pumpZ = %f where ID = %d",
            PumpBusiness:GetPumpBussID(pumpid), PumpBusiness:GetPumpFuelPrice(pumpid), PumpBusiness:GetPumpFuel(pumpid), PumpBusiness:GetPumpCapacity(pumpid),
            PumpBusiness:GetPumpRefillingStatus(pumpid), PumpBusiness:GetPumpFillingStatus(pumpid), PumpData[pumpid][pumpX], PumpData[pumpid][pumpY], PumpData[pumpid][pumpZ], pumpid
        )
    );
    return 1;
}

stock PumpBusiness:FindClosest(playerid, Float:range = 6.0) {
    new id = -1, Float:dist = range, Float:tempdist;
    foreach(new pumpid:fuelpumps) {
        tempdist = GetPlayerDistanceFromPoint(playerid, PumpData[pumpid][pumpX], PumpData[pumpid][pumpY], PumpData[pumpid][pumpZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            id = pumpid;
        }
    }
    return id;
}

hook OnPlayerConnect(playerid) {
    PumpBusiness:InitPlayer(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    PlayerTextDrawDestroy(playerid, FuelText[playerid]);
    foreach(new pumpid:fuelpumps) {
        if (PumpData[pumpid][pumpRefillFromTank][0] == playerid && PumpBusiness:IsRefulingActive(pumpid)) PumpBusiness:KillRefuelingTimer(pumpid);
    }
    FuelText[playerid] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

/* Initialize fuel state of player */
stock PumpBusiness:InitPlayer(playerid) {
    PumpBusiness:SetPlayerUsingPumpID(playerid, -1);
    PumpBusiness:SetFuelBought(playerid, 0.0);
    RefuelTimer[playerid] = -1;

    FuelText[playerid] = CreatePlayerTextDraw(playerid, 500, 250, "~b~~h~Refueling...~n~~n~~w~Price: ~g~~h~$0 ~y~~h~(0.00L)");
    PlayerTextDrawBackgroundColor(playerid, FuelText[playerid], 255);
    PlayerTextDrawFont(playerid, FuelText[playerid], 1);
    PlayerTextDrawLetterSize(playerid, FuelText[playerid], 0.240000, 1.100000);
    PlayerTextDrawColor(playerid, FuelText[playerid], -1);
    PlayerTextDrawSetOutline(playerid, FuelText[playerid], 1);
    PlayerTextDrawSetProportional(playerid, FuelText[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, FuelText[playerid], 0);
    PlayerTextDrawHide(playerid, FuelText[playerid]);

    //FuelBar[playerid] = CreatePlayerProgressBar(playerid, 498.0, 104.0, 113.0, 6.2, 0xF1C40FFF, 100.0, 0);
    return 1;
}

stock PumpBusiness:ResetPlayer(playerid) {
    if (!IsValidPlayerID(playerid)) return 1;
    new pumpid = PumpBusiness:GetPlayerUsingPumpID(playerid);
    if (!PumpBusiness:IsValidPumpID(pumpid)) return 1;
    new Float:ToalFuelBought = PumpBusiness:GetFuelBought(playerid);
    if (Float:ToalFuelBought > 0.0 && RefuelTimer[playerid] != -1) {
        DeletePreciseTimer(RefuelTimer[playerid]);
        RefuelTimer[playerid] = -1;
        PlayerTextDrawHide(playerid, FuelText[playerid]);

        // process payment collected for fuel station
        new bool:transaction = false;
        new bussid = PumpBusiness:GetPumpBussID(pumpid);
        new cash = floatround(ToalFuelBought * PumpBusiness:GetPumpFuelPrice(pumpid));
        // deduct from player
        if (
            !PumpBusiness:IsPurchased(bussid) &&
            IsPlayerInAnyVehicle(playerid) &&
            Faction:IsPlayerSigned(playerid) &&
            Faction:GetPlayerFID(playerid) != -1 &&
            StaticVehicle:GetFactionID(StaticVehicle:GetID(GetPlayerVehicleID(playerid))) == Faction:GetPlayerFID(playerid) &&
            vault:isValidID(Faction:GetVaultID(Faction:GetPlayerFID(playerid))) &&
            vault:getBalance(Faction:GetVaultID(Faction:GetPlayerFID(playerid))) >= cash
        ) {
            AlexaMsg(playerid, "payment has been taken from faction vault, you may go.", "Fuel System");
            vault:addcash(
                Faction:GetVaultID(Faction:GetPlayerFID(playerid)), -cash, Vault_Transaction_Cash_To_Vault,
                sprintf("%s bought %.2f fuel from petrol pump", GetPlayerNameEx(playerid), ToalFuelBought)
            );
            transaction = true;
        } else {
            GivePlayerCash(playerid, -cash, sprintf("Refueling: bought %.2f liter fuel", ToalFuelBought));
            transaction = true;
        }

        if (transaction) {
            if (PumpBusiness:IsPurchased(bussid)) PumpBusiness:IncreaseBalance(bussid, cash, sprintf("%s bought %.2f liter fuel", GetPlayerNameEx(playerid), ToalFuelBought));
            else vault:addcash(Vault_ID_Government, cash, Vault_Transaction_Cash_To_Vault, sprintf("%s bought fuel from government pump", GetPlayerNameEx(playerid)));
        }
    }

    PumpBusiness:SetPlayerUsingPumpID(playerid, -1);
    PumpBusiness:SetFuelBought(playerid, 0.0);
    PumpBusiness:SetPumpUser(pumpid, -1);
    PumpBusiness:UpdatePump(pumpid);
    PumpBusiness:UpdateText(PumpBusiness:GetPumpBussID(pumpid));
    return 1;
}

stock VehicleEngineStart(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 0;
    if (GetVehicleFuelEx(vehicleid) < 0.1 && IsVehicleHaveFuelTank(vehicleid)) return 0;
    SetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE, 1);
    CallRemoteFunction("OnVehicleEngineStart", "d", vehicleid);
    return 1;
}

forward OnVehicleEngineStart(vehicleid);
public OnVehicleEngineStart(vehicleid) {
    return 1;
}

stock VehicleEngineStop(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 0;
    SetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE, 0);
    CallRemoteFunction("OnVehicleEngineStop", "d", vehicleid);
    return 1;
}

forward OnVehicleEngineStop(vehicleid);
public OnVehicleEngineStop(vehicleid) {
    return 1;
}

Float:Vehicle_GetSpeed(vehicleid) {
    new Float:vx, Float:vy, Float:vz, Float:vel;
    vel = GetVehicleVelocity(vehicleid, vx, vy, vz);
    vel = (floatsqroot(((vx * vx) + (vy * vy)) + (vz * vz)) * 181.5);
    return vel;
}

forward ConsumeFuel();
public ConsumeFuel() {
    new Float:mass, Float:speed, Float:dist;
    foreach(new vehicleid:Vehicle) {
        if (!IsValidVehicle(vehicleid) || vehicleid < 0 || vehicleid >= MAX_VEHICLES || !IsVehicleHaveFuelTank(vehicleid)) continue;
        if (!GetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE)) continue;
        dist = GetVehicleDistanceFromPoint(vehicleid, VehicleLastCoords[vehicleid][0], VehicleLastCoords[vehicleid][1], VehicleLastCoords[vehicleid][2]);
        mass = GetVehicleModelInfoAsFloat(GetVehicleModel(vehicleid), "fMass");
        speed = Vehicle_GetSpeed(vehicleid) + 0.001;
        new Float:consumefuel = ((mass / (mass * 4.5)) * ((speed / 60) + 0.015) / 30) * ((dist / 10) + 0.001);
        IncreaseDecreaseVehicleFuel(vehicleid, -consumefuel);
        if (GetVehicleFuelEx(vehicleid) < 0.1) VehicleEngineStop(vehicleid);
        GetVehiclePos(vehicleid, VehicleLastCoords[vehicleid][0], VehicleLastCoords[vehicleid][1], VehicleLastCoords[vehicleid][2]);
    }
    return 1;
}

forward loafFuelPumps();
public loafFuelPumps() {
    new rows = cache_num_rows();
    if (rows) {
        new Id, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", Id);
            cache_get_value_name_int(loaded, "storeID", PumpData[Id][pumpStoreID]);
            cache_get_value_name_int(loaded, "cFuelPrice", PumpData[Id][pumpFuelPrice]);
            cache_get_value_name_int(loaded, "fuelStored", PumpData[Id][pumpStoredGallon]);
            cache_get_value_name_int(loaded, "fuelCapacity", PumpData[Id][pumpStoredCapcity]);
            cache_get_value_name_int(loaded, "pumpRefill", PumpData[Id][pumpRefill]);
            cache_get_value_name_int(loaded, "pumpFill", PumpData[Id][pumpfill]);
            cache_get_value_name_float(loaded, "pumpX", PumpData[Id][pumpX]);
            cache_get_value_name_float(loaded, "pumpY", PumpData[Id][pumpY]);
            cache_get_value_name_float(loaded, "pumpZ", PumpData[Id][pumpZ]);
            Iter_Add(fuelpumps, Id);

            PumpData[Id][pumpRefillFromTank][0] = -1;
            PumpData[Id][pumpRefillFromTank][1] = -1;
            PumpData[Id][pumpRefillFromTank][2] = -1;
            PumpData[Id][pumpRefillFromTank][3] = -1;
            PumpData[Id][pumpUser] = INVALID_PLAYER_ID;
            PumpData[Id][pumpLabel] = CreateDynamic3DTextLabel("Gas Pump", 0xF1C40FFF, PumpData[Id][pumpX], PumpData[Id][pumpY], PumpData[Id][pumpZ] + 0.75, 7.5);
            PumpBusiness:UpdatePump(Id, false);
            loaded++;
        }
    }
    printf("  [Fuel System] Loaded %d fuel pumps.", rows);
    return 1;
}

forward loadFuelStations();
public loadFuelStations() {
    new rows = cache_num_rows();
    if (rows) {
        new bussid, loaded;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", bussid);
            cache_get_value_name_float(loaded, "X", PumpBusiness:data[bussid][PumpBusiness:location][0]);
            cache_get_value_name_float(loaded, "Y", PumpBusiness:data[bussid][PumpBusiness:location][1]);
            cache_get_value_name_float(loaded, "Z", PumpBusiness:data[bussid][PumpBusiness:location][2]);
            cache_get_value_name_int(loaded, "vwID", PumpBusiness:data[bussid][PumpBusiness:vwint][0]);
            cache_get_value_name_int(loaded, "intID", PumpBusiness:data[bussid][PumpBusiness:vwint][1]);
            cache_get_value_name_int(loaded, "saleprice", PumpBusiness:data[bussid][PumpBusiness:saleprice]);
            cache_get_value_name_int(loaded, "balance", PumpBusiness:data[bussid][PumpBusiness:balance]);
            cache_get_value_name_int(loaded, "lastAccessAt", PumpBusiness:data[bussid][PumpBusiness:lastAccessAt]);
            cache_get_value_name_int(loaded, "PurchasedAt", PumpBusiness:data[bussid][PumpBusiness:PurchasedAt]);
            cache_get_value_name(loaded, "owner", PumpBusiness:data[bussid][PumpBusiness:owner], 50);
            Iter_Add(fuelBusiness, bussid);
            PumpBusiness:data[bussid][PumpBusiness:pumpLabel] = CreateDynamic3DTextLabel("Fuel Station", 0xF1C40FFF, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 7.5);
            PumpBusiness:data[bussid][PumpBusiness:pumpPickup] = CreateDynamicPickup(1210, 23, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
            PumpBusiness:data[bussid][PumpBusiness:pumpMapIcon] = CreateDynamicMapIcon(PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], 51, 0);
            PumpBusiness:UpdateText(bussid, false);
            loaded++;
        }
    }
    printf("  [Fuel System] Loaded %d fuel stations.", rows);
    return 1;
}

hook OnGameModeInit() {
    mysql_tquery(Database, "select * from fuelStations", "loadFuelStations", "");
    mysql_tquery(Database, "select * from fuelPumps", "loafFuelPumps", "");
    foreach(new vehicleid:Vehicle) {
        if (!IsValidVehicle(vehicleid)) continue;
        if (!IsVehicleHaveFuelTank(vehicleid)) VehicleEngineStart(vehicleid);
    }
    return 1;
}

hook OnGameModeExit() {
    foreach(new playerid:Player) {
        if (!IsPlayerConnected(playerid)) continue;
        PumpBusiness:ResetPlayer(playerid);
    }
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new bussid:fuelBusiness) {
        if (PumpBusiness:IsPurchased(bussid) && gettime() - PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] > FUEL_RESET_INTERVAL * 86400) {
            if (!IsPlayerInServerByName(PumpBusiness:GetOwner(bussid))) {
                Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PumpBusiness:GetOwner(bussid), sprintf("fuel business [%d] has been auto reset!!", bussid),
                    sprintf("fuel business [%d] has been auto reset!! Your fuel business has been taken by government due to not used by you in long time.", bussid)
                );
            }
            Discord:SendNotification(sprintf("\
            **Property Auto Reset Alert**\n\
            ```\n\
            Owner: %s\n\
            Type: Fuel Station [%d]\n\
            Status: reseted\n\
            Reason: due to owner not active\n\
            ```\
            ", PumpBusiness:GetOwner(bussid), bussid));
            PumpBusiness:Reset(bussid);
        }
    }
    return 1;
}

hook GlobalHourInterval() {
    foreach(new bussid:fuelBusiness) {
        if (PumpBusiness:IsPurchased(bussid)) {
            new beforeDay = 1;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new houseWillResetAt = PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] + (FUEL_RESET_INTERVAL - beforeDay) * 86400;
            if (houseWillResetAt >= mintime && houseWillResetAt < maxtime) {
                if (!IsPlayerInServerByName(PumpBusiness:GetOwner(bussid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PumpBusiness:GetOwner(bussid), "Your fuel business will reset after 24 hours!!", "Your fuel business will reset after 24 hours!! Your fuel business will be taken by government due to long inactivity and no visit in business for long time. you can stop this reset by visiting your business within 24 hours.");
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Fuel Station [%d]\n\
                Status: will reset within 24 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", PumpBusiness:GetOwner(bussid), bussid));
            }
        }
    }
    foreach(new bussid:fuelBusiness) {
        if (PumpBusiness:IsPurchased(bussid)) {
            new beforeDay = 2;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new houseWillResetAt = PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] + (FUEL_RESET_INTERVAL - beforeDay) * 86400;
            if (houseWillResetAt >= mintime && houseWillResetAt < maxtime) {
                if (!IsPlayerInServerByName(PumpBusiness:GetOwner(bussid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PumpBusiness:GetOwner(bussid), "Your fuel business will reset after 48 hours!!", "Your fuel business will reset after 48 hours!! Your fuel business will be taken by government due to long inactivity and no visit in business for long time. you can stop this reset by visiting your business within 48 hours.");
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Fuel Station [%d]\n\
                Status: will reset within 48 hour\n\
                Reason: due to owner not active\n\
                ```\
                ", PumpBusiness:GetOwner(bussid), bussid));
            }
        }
    }
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return 1;
    if (GetPlayerVehicleSeat(playerid) != 0) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsVehicleHaveFuelTank(vehicleid)) return 1;
    if (GetVehicleFuelEx(vehicleid) < 15.0 && IsTimePassedForPlayer(playerid, "FuelWarning", 5 * 60)) {
        SendClientMessage(playerid, -1, "{4286f4}[Error]: {FFFFEE}low fuel, use GPS to find nearest fuel station");
        GameTextForPlayer(playerid, "~w~low ~r~fuel", 3000, 3);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    if (newstate == PLAYER_STATE_DRIVER) {
        if (!IsVehicleHaveFuelTank(GetPlayerVehicleID(playerid))) return VehicleEngineStart(GetPlayerVehicleID(playerid));
        if (GetPlayerScore(playerid) < 50) GameTextForPlayer(playerid, "~w~press ~r~Y~w~ to ~n~start engine", 3000, 3);
    }
    if (oldstate == PLAYER_STATE_DRIVER) PumpBusiness:ResetPlayer(playerid);
    new id = GetPlayerVehicleID(playerid);
    if (newstate == PLAYER_STATE_DRIVER) GetVehiclePos(GetPlayerVehicleID(playerid), VehicleLastCoords[id][0], VehicleLastCoords[id][1], VehicleLastCoords[id][2]);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        new bussid = PumpBusiness:GetNearest(playerid);
        if (bussid != -1) {
            if (PumpBusiness:IsPurchased(bussid)) {
                if (PumpBusiness:IsPlayerOwner(playerid, bussid)) {
                    PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] = gettime();
                    PumpBusiness:UpdateText(bussid);
                    PumpBusiness:Access(playerid, bussid);
                }
            } else {
                PumpBusiness:MenuPurchase(playerid, bussid);
            }
            return ~1;
        }
    }
    if (
        GetPlayerState(playerid) == PLAYER_STATE_DRIVER &&
        (newkeys & KEY_YES) &&
        bool:IsTimePassedForPlayer(playerid, "enginePressSpam", 3)
    ) {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (!IsVehicleHaveFuelTank(vehicleid)) return 1;

        new Float:Vhealth;
        GetVehicleHealth(vehicleid, Vhealth);
        if (GetVehicleParams(vehicleid, VEHICLE_TYPE_ENGINE) || (Vhealth < 450.00 && !Event:IsInEvent(playerid))) {
            VehicleEngineStop(vehicleid);
            SetPVarInt(playerid, "Engine", 0);
            GameTextForPlayer(playerid, "~w~Engine ~r~Stopped", 500, 3);
            return ~1;
        } else {
            VehicleEngineStart(vehicleid);
            SetPVarInt(playerid, "Engine", 1);
            GameTextForPlayer(playerid, "~w~Engine ~r~Started", 500, 3);
            if (PumpBusiness:IsValidPumpID(PumpBusiness:GetPlayerUsingPumpID(playerid))) {
                new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                //CreateExplosionForPlayer(playerid, x, y, z, 6, 8.0);
                CreateExplosion(x, y, z, 6, 8.0);
            }
            return ~1;
        }
    }
    if (
        GetPlayerState(playerid) == PLAYER_STATE_DRIVER &&
        newkeys == KEY_NO &&
        bool:IsTimePassedForPlayer(playerid, "refuelPressSpam", 5)
    ) {
        if (IsPlayerInAnyVehicle(playerid)) {
            new vehicleid = GetPlayerVehicleID(playerid);
            new modelid = GetVehicleModel(vehicleid);
            if (IsModelCycle(modelid)) return 1;
            new Float:defaultRange = 6.0;
            if (IsModelPlane(modelid) || IsModelHeli(modelid) || IsModelBoat(modelid)) defaultRange = 20.0;
            new pumpid = PumpBusiness:FindClosest(playerid, defaultRange);
            if (pumpid != -1) {
                new trailerid = GetVehicleTrailer(vehicleid);
                if (trailerid != 0 && !PumpBusiness:IsUsingByAnyone(pumpid)) {
                    if (GetVehicleModel(trailerid) == 584 && StaticVehicle:IsStatic(trailerid)) {
                        if (OilCompany:GetTankerFuel(trailerid) > 0) {
                            PumpBusiness:TruckerMenu(playerid, pumpid);
                            return ~1;
                        }
                    }
                }
                PumpBusiness:RefuelStart(playerid);
                return ~1;
            }
            return ~1;
        }
    }
    return 1;
}

stock PumpBusiness:IsRefulingActive(pumpid) {
    return PumpData[pumpid][pumpRefillFromTank][3] != -1;
}

stock PumpBusiness:KillRefuelingTimer(pumpid) {
    if (PumpData[pumpid][pumpRefillFromTank][3] == -1) return 1;
    DeletePreciseTimer(PumpData[pumpid][pumpRefillFromTank][3]);
    PumpData[pumpid][pumpRefillFromTank][0] = -1;
    PumpData[pumpid][pumpRefillFromTank][3] = -1;
    return 1;
}

forward ReFillPump(pumpid);
public ReFillPump(pumpid) {
    new playerid = PumpData[pumpid][pumpRefillFromTank][0], trailerid = PumpData[pumpid][pumpRefillFromTank][1], toFuel = PumpData[pumpid][pumpRefillFromTank][2];
    if (!IsPlayerConnected(playerid)) return PumpBusiness:KillRefuelingTimer(pumpid);
    if (toFuel <= 0) {
        AlexaMsg(playerid, "pump refilling completed", "Fuel System");
        PumpBusiness:KillRefuelingTimer(pumpid);
        unfreeze(playerid);
        PumpBusiness:UpdatePump(pumpid);
        return 1;
    }
    if (OilCompany:GetTankerFuel(trailerid) < 1) {
        AlexaMsg(playerid, "trailer does not have enough fuel, can not refill more fuel", "Fuel System");
        PumpBusiness:KillRefuelingTimer(pumpid);
        PumpBusiness:UpdatePump(pumpid);
        unfreeze(playerid);
        return 1;
    }
    if (PumpBusiness:GetPumpFuel(pumpid) >= PumpBusiness:GetPumpCapacity(pumpid)) {
        AlexaMsg(playerid, "fuel pump is at full capacity, can not refill more fuel", "Fuel System");
        PumpBusiness:KillRefuelingTimer(pumpid);
        PumpBusiness:UpdatePump(pumpid);
        unfreeze(playerid);
        return 1;
    }
    OilCompany:SetTankerFuel(trailerid, OilCompany:GetTankerFuel(trailerid) - 1);
    PumpBusiness:IncreaseDecreasePumpFuel(pumpid, 1);
    PumpData[pumpid][pumpRefillFromTank][2]--;
    PumpBusiness:UpdatePump(pumpid, false);
    return 1;
}

forward Refuel(playerid, vehicleid, pumpid);
public Refuel(playerid, vehicleid, pumpid) {
    if (
        (!IsPlayerConnected(playerid)) ||
        (!PumpBusiness:IsValidPumpID(pumpid) || !PumpBusiness:IsValidPumpID(PumpBusiness:GetPlayerUsingPumpID(playerid))) ||
        (!IsValidVehicle(vehicleid))
    ) {
        PumpBusiness:ResetPlayer(playerid);
        return 1;
    }
    new price = floatround(1.0 * PumpBusiness:GetPumpFuelPrice(pumpid));
    if (GetPlayerCash(playerid) < price) {
        GameTextForPlayer(playerid, "~w~You don't have enough ~r~money", 1000, 1);
        PumpBusiness:ResetPlayer(playerid);
        VehicleEngineStart(vehicleid);
        return 1;
    }
    if (PumpBusiness:GetPumpFuel(pumpid) < 1) {
        GameTextForPlayer(playerid, "~w~Fuel Pump ~r~Empty", 1000, 1);
        PumpBusiness:ResetPlayer(playerid);
        VehicleEngineStart(vehicleid);
        return 1;
    }
    PumpBusiness:IncreaseDecreasePumpFuel(pumpid, -1);
    PumpBusiness:IncreaseDecreaseFuelBought(playerid, 1.0);
    IncreaseDecreaseVehicleFuel(vehicleid, 1);
    PumpBusiness:UpdatePump(pumpid, false);

    new string[64];
    format(string, sizeof(string), "~b~~h~Refueling...~n~~n~~w~Price: ~g~~h~$%s ~y~~h~(%.2fL)", FormatCurrency(floatround(PumpBusiness:GetFuelBought(playerid) * PumpBusiness:GetPumpFuelPrice(PumpBusiness:GetPlayerUsingPumpID(playerid)))), PumpBusiness:GetFuelBought(playerid));
    PlayerTextDrawSetString(playerid, FuelText[playerid], string);

    if (GetVehicleFuelEx(vehicleid) > 100.0) {
        SetVehicleFuelEx(vehicleid, 100.0);
        PumpBusiness:ResetPlayer(playerid);
        VehicleEngineStart(vehicleid);
    }
    return 1;
}

stock PumpBusiness:RefuelStart(playerid) {
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return AlexaMsg(playerid, "You can't use this command if you're not a driver.", "Error", "4286f4", "FFFFEE");
    if (PumpBusiness:GetPlayerUsingPumpID(playerid) != -1) {
        PumpBusiness:ResetPlayer(playerid);
        VehicleEngineStart(GetPlayerVehicleID(playerid));
        return 1;
    }
    if (GetPlayerCash(playerid) < 1) return AlexaMsg(playerid, "You don't have enough money.", "Error", "4286f4", "FFFFEE");
    if (Fuel[GetPlayerVehicleID(playerid)] > 99.0) return AlexaMsg(playerid, "Your vehicle doesn't need a refuel.", "Error", "4286f4", "FFFFEE");
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new Float:defaultRange = 6.0;
    if (IsModelPlane(modelid) || IsModelHeli(modelid) || IsModelBoat(modelid)) defaultRange = 20.0;
    new pumpid = PumpBusiness:FindClosest(playerid, defaultRange);
    if (pumpid == -1) return AlexaMsg(playerid, "You're not near a gas pump.", "Error", "4286f4", "FFFFEE");
    if (PumpData[pumpid][pumpRefillFromTank][0] != -1) return AlexaMsg(playerid, "This fuel pump is closed, try another");
    if (!PumpBusiness:GetPumpFillingStatus(pumpid)) return AlexaMsg(playerid, "This fuel pump is closed, try another.", "Error", "4286f4", "FFFFEE");
    if (PumpBusiness:GetPumpFuel(pumpid) < 1) return AlexaMsg(playerid, "This fuel pump does not have enough fuel, try another.", "Error", "4286f4", "FFFFEE");
    if (PumpBusiness:IsUsingByAnyone(pumpid)) return AlexaMsg(playerid, "The pump you want to use is not available.", "Error", "4286f4", "FFFFEE");
    PumpBusiness:SetPlayerUsingPumpID(playerid, pumpid);
    PumpBusiness:SetPumpUser(pumpid, playerid);
    PumpBusiness:UpdatePump(pumpid);

    VehicleEngineStop(vehicleid);
    PlayerTextDrawSetString(playerid, FuelText[playerid], "~b~~h~Refueling...~n~~n~~w~Price: ~g~~h~$0 ~y~~h~(0.00L)");
    PlayerTextDrawShow(playerid, FuelText[playerid]);
    RefuelTimer[playerid] = SetPreciseTimer("Refuel", 500, true, "ddd", playerid, vehicleid, pumpid);

    AlexaMsg(playerid, "You can press N again to stop refueling.", "Fuel Station");
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Fuel System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Fuel System", inputtext)) {
        PumpBusiness:AdminMenu(playerid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "fuel system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    PumpBusiness:AdminMenu(playerid);
    return ~1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    foreach(new bussid:fuelBusiness) if (IsStringSame(PumpBusiness:GetOwner(bussid), OldName)) PumpBusiness:UpdateOwner(bussid, NewName);
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    foreach(new bussid:fuelBusiness) if (IsStringSame(PumpBusiness:GetOwner(bussid), AccountName)) PumpBusiness:Reset(bussid);
    return 1;
}

stock PumpBusiness:MenuPurchase(playerid, bussid) {
    new string[512];
    strcat(string, "Welcome, This fuel station is the property of San Andreas Government\n");
    strcat(string, "you can purchase this fuel station and also sale it to San Andreas Government\n");
    strcat(string, "remember you can earn money but make sure all your fuel staiton pumps have sufficient fuels in vehicle to fill fuel in vehicles tanks\n");
    strcat(string, sprintf("you will be charged $%s for this purchase\n", FormatCurrency(PumpBusiness:GetSalePrice(bussid))));
    strcat(string, "press enter to confirm the purchase\n");
    return FlexPlayerDialog(playerid, "PumpBusinessMenuPurchase", DIALOG_STYLE_MSGBOX, "{4286f4}[Fuel System]: {FFFFEE}Purchase", string, "Buy", "Cancel", bussid);
}

FlexDialog:PumpBusinessMenuPurchase(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return 1;

    // required 50 score
    if (GetPlayerScore(playerid) < 50)
        return AlexaMsg(playerid, "you need at least 50 score to purchase this business", "Fuel System");

    // already purchased   
    if (PumpBusiness:IsPurchased(bussid))
        return AlexaMsg(playerid, "this fuel station is not available for sale. contact station owner to purchase this station.", "Fuel System");

    // max limit reached
    if (PumpBusiness:GetTotalPurchased(GetPlayerNameEx(playerid)) >= Max_Fuel_Business_Purchase)
        return AlexaMsg(playerid, "you can purchase maximum one fuel station, purchase vip for more slots.", "Fuel System");

    new saleprice = PumpBusiness:GetSalePrice(bussid);
    // player don't have enough cash
    if (GetPlayerCash(playerid) < saleprice)
        return AlexaMsg(playerid, "you don't have enough money to purchase this business.", "Fuel System");

    // make vault transfer
    vault:PlayerVault(playerid, -saleprice, sprintf("purchased fuel station [%d]", bussid),
        Vault_ID_Government, saleprice, sprintf("sold fuel station [%d] to %s", bussid, GetPlayerNameEx(playerid))
    );

    AddPlayerLog(
        playerid,
        sprintf("Purchased a fuel station [%d] from the government for $%s", bussid, FormatCurrency(saleprice)),
        "business"
    );
    PumpBusiness:data[bussid][PumpBusiness:lastAccessAt] = gettime();
    PumpBusiness:data[bussid][PumpBusiness:PurchasedAt] = gettime();
    PumpBusiness:SetBalance(bussid, 0);
    foreach(new pumpid:fuelpumps) if (PumpBusiness:GetPumpBussID(pumpid) == bussid) PumpBusiness:UpdatePumpFuel(pumpid, 0);
    PumpBusiness:UpdateOwner(bussid, GetPlayerNameEx(playerid));
    AlexaMsg(playerid, "Congratulations on your purchase, press enter to access fuel station", "Fuel System");
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:TruckerMenu(playerid, pumpid) {
    if (PumpData[pumpid][pumpRefillFromTank][0] != -1) return AlexaMsg(playerid, "This fuel pump is closed, try another");
    new string[512];
    strcat(string, "Refill My Vehicle\n");
    strcat(string, "Refill Fuel Pump\n");
    return FlexPlayerDialog(playerid, "PumpBusinessTruckerMenu", DIALOG_STYLE_LIST, "{4286f4}[Fuel System]: {FFFFEE}Options", string, "Select", "Close", pumpid);
}

FlexDialog:PumpBusinessTruckerMenu(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Refill My Vehicle")) return PumpBusiness:RefuelStart(playerid);
    if (IsStringSame(inputtext, "Refill Fuel Pump")) {
        if (!PumpBusiness:GetPumpRefillingStatus(pumpid)) {
            AlexaMsg(playerid, "refilling is not allowed on this fuel pump", "Fuel Station");
            return PumpBusiness:TruckerMenu(playerid, pumpid);
        }
        return PumpBusiness:MenuTruckerRefill(playerid, pumpid);
    }
    return 1;
}

stock PumpBusiness:MenuTruckerRefill(playerid, pumpid) {
    return FlexPlayerDialog(playerid, "PumpMenuTruckerRefill", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Refill PUMP", "Enter fuel in gallon to refill in pump", "Refill", "Close", pumpid);
}

FlexDialog:PumpMenuTruckerRefill(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    if (!response) return PumpBusiness:TruckerMenu(playerid, pumpid);
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid)) return AlexaMsg(playerid, "can not find trailer", "Fuel Station");
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid == 0 || GetVehicleModel(trailerid) != 584) return AlexaMsg(playerid, "can not find trailer", "Fuel Station");
    if (OilCompany:GetTankerFuel(trailerid) < 1) return AlexaMsg(playerid, "not enough fuel in trailer, buy fuel from indian oil private limited", "Fuel Station");

    new toFuel;
    if (sscanf(inputtext, "d", toFuel) || toFuel < 1 || toFuel > OilCompany:GetTankerFuel(trailerid)) return PumpBusiness:MenuTruckerRefill(playerid, pumpid);
    freeze(playerid);
    PumpData[pumpid][pumpRefillFromTank][0] = playerid;
    PumpData[pumpid][pumpRefillFromTank][1] = trailerid;
    PumpData[pumpid][pumpRefillFromTank][2] = toFuel;
    PumpData[pumpid][pumpRefillFromTank][3] = SetPreciseTimer("ReFillPump", 200, true, "d", pumpid);
    AlexaMsg(playerid, "refuling pump... please wait...", "Fuel Station");
    return 1;
}

stock PumpBusiness:Access(playerid, bussid) {
    new string[512];
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(PumpBusiness:GetBalance(bussid))));
    if (PumpBusiness:GetTotalPumps(bussid) > 0) {
        strcat(string, "Open All Pumps\n");
        strcat(string, "Close All Pumps\n");
        strcat(string, "Manage Pumps\n");
    }
    if (PumpBusiness:IsPurchased(bussid) && gettime() - PumpBusiness:GetPurchasedAt(bussid) > 3 * 24 * 60 * 60) {
        strcat(string, "Sale To Friend\n");
        strcat(string, "Sale To Government\n");
    }
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Owner\t%s\n", PumpBusiness:GetOwner(bussid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Sale Price\t%s\n", FormatCurrency(PumpBusiness:GetSalePrice(bussid))));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Teleport To\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Update Cordinates\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Reset\n");
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, "Remove\n");
    return FlexPlayerDialog(playerid, "PumpMenuAccess", DIALOG_STYLE_TABLIST, "{4286f4}[Fuel System]: {FFFFEE}Manage Fuel Business", string, "Select", "Close", bussid);
}

FlexDialog:PumpMenuAccess(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Owner")) return PumpBusiness:MenuAdminUpdateOwner(playerid, bussid);
    if (IsStringSame(inputtext, "Sale Price")) return PumpBusiness:MenuAdminUpdateSalePrice(playerid, bussid);
    if (IsStringSame(inputtext, "Teleport To")) {
        SetPlayerPosEx(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AlexaMsg(playerid, "teleported to fuel station", "Fuel Station");
        return PumpBusiness:Access(playerid, bussid);
    }
    if (IsStringSame(inputtext, "Update Cordinates")) {
        new status = PumpBusiness:UpdateCordinates(playerid, bussid);
        if (!status) AlexaMsg(playerid, "unable to update fuel station coordinates", "Fuel Station");
        else AlexaMsg(playerid, "fuel station coordinates updated", "Fuel Station");
        return PumpBusiness:Access(playerid, bussid);
    }
    if (IsStringSame(inputtext, "Reset")) {
        new status = PumpBusiness:Reset(bussid);
        if (!status) AlexaMsg(playerid, "unable to reset fuel station", "Fuel Station");
        else AlexaMsg(playerid, "fuel station has been reset", "Fuel Station");
        return PumpBusiness:Access(playerid, bussid);
    }
    if (IsStringSame(inputtext, "Remove")) {
        new status = PumpBusiness:Remove(bussid);
        if (!status) AlexaMsg(playerid, "unable to remove fuel station", "Fuel Station");
        else AlexaMsg(playerid, "fuel station has been removed", "Fuel Station");
        return 1;
    }
    if (IsStringSame(inputtext, "Balance")) return PumpBusiness:MenuWithdraw(playerid, bussid);
    if (IsStringSame(inputtext, "Manage Pumps")) return PumpBusiness:MenuManagePumps(playerid, bussid);
    if (IsStringSame(inputtext, "Open All Pumps")) {
        foreach(new pumpid:fuelpumps) {
            if (PumpData[pumpid][pumpStoreID] == bussid) {
                PumpData[pumpid][pumpRefill] = true;
                PumpData[pumpid][pumpfill] = true;
                PumpBusiness:UpdatePump(pumpid);
            }
        }
        AlexaMsg(playerid, "all pumps of your has been opened", "Fuel Station");
        return PumpBusiness:Access(playerid, bussid);
    }
    if (IsStringSame(inputtext, "Close All Pumps")) {
        foreach(new pumpid:fuelpumps) {
            if (PumpData[pumpid][pumpStoreID] == bussid) {
                PumpData[pumpid][pumpRefill] = false;
                PumpData[pumpid][pumpfill] = false;
                PumpBusiness:UpdatePump(pumpid);
            }
        }
        AlexaMsg(playerid, "all pumps of your has been closed", "Fuel Station");
        return PumpBusiness:Access(playerid, bussid);
    }
    if (IsStringSame(inputtext, "Sale To Friend")) return PumpBusiness:MenuSaleToFriend(playerid, bussid);
    if (IsStringSame(inputtext, "Sale To Government")) return PumpBusiness:MenuSaleToGovn(playerid, bussid);
    return 1;
}

stock PumpBusiness:MenuAdminUpdateSalePrice(playerid, bussid) {
    return FlexPlayerDialog(playerid, "PumpMenuUpdateSalePrice", DIALOG_STYLE_INPUT, "Fuel Station: Update Owner", "Enter new owner name", "Update", "Close", bussid);
}

FlexDialog:PumpMenuUpdateSalePrice(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return PumpBusiness:Access(playerid, bussid);
    new newsaleprice;
    if (sscanf(inputtext, "d", newsaleprice) || newsaleprice < 1) return PumpBusiness:MenuAdminUpdateSalePrice(playerid, bussid);
    PumpBusiness:UpdateSalePrice(bussid, newsaleprice);
    PumpBusiness:UpdateText(bussid);
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:MenuAdminUpdateOwner(playerid, bussid) {
    return FlexPlayerDialog(playerid, "PumpMenuAdminUpdateOwner", DIALOG_STYLE_INPUT, "Fuel Station: Update Owner", "Enter new owner name", "Update", "Close", bussid);
}

FlexDialog:PumpMenuAdminUpdateOwner(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return PumpBusiness:Access(playerid, bussid);
    new account[100];
    if (sscanf(inputtext, "s[100]", account) || !IsValidAccount(account) || IsStringSame(PumpBusiness:GetOwner(bussid), account)) return PumpBusiness:MenuAdminUpdateOwner(playerid, bussid);
    PumpBusiness:UpdateOwner(bussid, account);
    PumpBusiness:UpdateText(bussid);
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:MenuWithdraw(playerid, bussid) {
    return FlexPlayerDialog(playerid, "PumpMenuWithdraw", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Withdraw Cash from business",
        sprintf("Enter amount between $1 to $%s", FormatCurrency(PumpBusiness:GetBalance(bussid))), "Update", "Close", bussid
    );
}

FlexDialog:PumpMenuWithdraw(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return PumpBusiness:Access(playerid, bussid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > PumpBusiness:GetBalance(bussid)) return PumpBusiness:MenuWithdraw(playerid, bussid);
    PumpBusiness:DecreaseBalance(bussid, amount, sprintf("%s withdrawl from fuel station", GetPlayerNameEx(playerid)));
    GivePlayerCash(playerid, amount, sprintf("withdrawal from fuel business [%d]", bussid));
    PumpBusiness:UpdateText(bussid);
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:MenuSaleToFriend(playerid, bussid) {
    new string[512];
    strcat(string, "Hi there, you are about to sell this fuel station to a friend\n");
    strcat(string, "remember, there is no going back if you confirm this sell\n");
    strcat(string, "press enter friend id to confirm the sell or esc to cancel\n");
    return FlexPlayerDialog(playerid, "PumpMenuSaleToFriend", DIALOG_STYLE_MSGBOX, "{4286f4}[Fuel System]: {FFFFEE}Purchase", string, "Confirm", "Cancel", bussid);
}

FlexDialog:PumpMenuSaleToFriend(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return 1;
    new friendid;
    if (
        sscanf(inputtext, "u", friendid) ||
        !IsPlayerInRangeOfPlayer(playerid, friendid, 10.0) ||
        PumpBusiness:GetTotalPurchased(GetPlayerNameEx(friendid)) >= Max_Fuel_Business_Purchase
    ) {
        AlexaMsg(playerid, "Make sure your friend is close and does not own a fuel station");
        return PumpBusiness:MenuSaleToFriend(playerid, bussid);
    }
    PumpBusiness:UpdatePurchasedAt(bussid);
    PumpBusiness:UpdateOwner(bussid, GetPlayerNameEx(friendid));
    PumpBusiness:UpdateText(bussid, true);
    AlexaMsg(playerid, sprintf("%s owns your fuel station now.", GetPlayerNameEx(friendid)));
    return 1;
}

stock PumpBusiness:MenuSaleToGovn(playerid, bussid) {
    new string[512];
    strcat(string, "Hi there, you are about to sell this fuel station to San Andreas Government\n");
    strcat(string, "remember, there is no going back if you confirm this sell\n");
    strcat(string, "you will recieved on going market value of this fuel station\n");
    strcat(string, "press enter to confirm the sell or esc to cancel\n");
    return FlexPlayerDialog(playerid, "PumpMenuSaleToGovn", DIALOG_STYLE_MSGBOX, "{4286f4}[Fuel System]: {FFFFEE}Purchase", string, "Confirm", "Cancel", bussid);
}

FlexDialog:PumpMenuSaleToGovn(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return PumpBusiness:Access(playerid, bussid);
    new cash = GetPercentageOf(Random(60, 80), PumpBusiness:GetSalePrice(bussid));
    if (cash > 0) {
        AddPlayerLog(
            playerid,
            sprintf("Sold a fuel station [%d] from the government for $%s", bussid, FormatCurrency(cash)),
            "business"
        );
        vault:PlayerVault(playerid, cash, sprintf("sold fuel station [%d] to government", bussid),
            Vault_ID_Government, -cash, sprintf("%s sold fuel station [%d] to government", GetPlayerNameEx(playerid), bussid)
        );
        AlexaMsg(playerid, sprintf("you have recieved $%s from fuel station sale", FormatCurrency(cash)), "Fuel Station");
    }
    AlexaMsg(playerid, "fuel station has been sold to government", "Fuel Station");
    return PumpBusiness:Reset(bussid);
}

stock PumpBusiness:MenuManagePumps(playerid, bussid) {
    new string[2000];
    strcat(string, "Pump ID\tRefilling\tFilling\n");
    foreach(new pumpid:fuelpumps) {
        if (PumpBusiness:GetPumpBussID(pumpid) == bussid) strcat(string, sprintf(
            "%d\t%s\t%s\n", pumpid, PumpBusiness:GetPumpRefillingStatus(pumpid) ? ("Enabled") : ("Disabled"),
            PumpBusiness:GetPumpFillingStatus(pumpid) ? ("Enabled") : ("Disabled")
        ));
    }
    return FlexPlayerDialog(playerid, "PumpMenuManagePumps", DIALOG_STYLE_TABLIST_HEADERS, "Fuel Pump: List", string, "Select", "Cancel", bussid);
}

FlexDialog:PumpMenuManagePumps(playerid, response, listitem, const inputtext[], bussid, const payload[]) {
    if (!response) return PumpBusiness:Access(playerid, bussid);
    return PumpBusiness:MenuManagePump(playerid, strval(inputtext));
}

stock PumpBusiness:MenuManagePump(playerid, pumpid) {
    new string[512];
    strcat(string, sprintf("Fuel Price\t$%s\n", FormatCurrency(PumpBusiness:GetPumpFuelPrice(pumpid))));
    strcat(string, sprintf("Refilling\t%s\n", PumpBusiness:GetPumpRefillingStatus(pumpid) ? ("Enabled") : ("Disabled")));
    strcat(string, sprintf("Filling\t%s\n", PumpBusiness:GetPumpFillingStatus(pumpid) ? ("Enabled") : ("Disabled")));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "Teleport To\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Store ID\t%d\n", PumpBusiness:GetPumpBussID(pumpid)));
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, sprintf("Stored Fuel\t%d\n", PumpBusiness:GetPumpFuel(pumpid)));
    if (GetPlayerAdminLevel(playerid) >= 10) strcat(string, sprintf("Max Capacity\t%d\n", PumpBusiness:GetPumpCapacity(pumpid)));
    return FlexPlayerDialog(playerid, "PumpMenuManagePump", DIALOG_STYLE_TABLIST, "{4286f4}[Fuel System]: {FFFFEE}Manage PUMP", string, "Select", "Close", pumpid);
}

FlexDialog:PumpMenuManagePump(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    new bussid = PumpBusiness:GetPumpBussID(pumpid);
    if (!response) return PumpBusiness:Access(playerid, bussid);
    if (IsStringSame(inputtext, "Fuel Price")) return PumpBusiness:MenuUpdatePumpPrice(playerid, pumpid);
    if (IsStringSame(inputtext, "Refilling")) {
        PumpData[pumpid][pumpRefill] = !PumpData[pumpid][pumpRefill];
        PumpBusiness:UpdatePump(pumpid);
        return PumpBusiness:MenuManagePump(playerid, pumpid);
    }
    if (IsStringSame(inputtext, "Filling")) {
        PumpData[pumpid][pumpfill] = !PumpData[pumpid][pumpfill];
        PumpBusiness:UpdatePump(pumpid);
        return PumpBusiness:MenuManagePump(playerid, pumpid);
    }
    if (IsStringSame(inputtext, "Teleport To")) {
        SetPlayerPosEx(playerid, PumpData[pumpid][pumpX] + 1.0, PumpData[pumpid][pumpY] + 1.0, PumpData[pumpid][pumpZ] + 1.0);
        SetPlayerInteriorEx(playerid, 0);
        SetPlayerVirtualWorldEx(playerid, 0);
        AlexaMsg(playerid, "teleported to fuel pump", "Fuel Station");
        return PumpBusiness:MenuManagePump(playerid, pumpid);
    }
    if (IsStringSame(inputtext, "Store ID")) return PumpBusiness:Access(playerid, bussid);
    if (IsStringSame(inputtext, "Stored Fuel")) return PumpBusiness:MenuUpdatePumpStoredFuel(playerid, pumpid);
    if (IsStringSame(inputtext, "Max Capacity")) return PumpBusiness:MenuUpdatePumpMaxCapcity(playerid, pumpid);
    return 1;
}

stock PumpBusiness:MenuUpdatePumpStoredFuel(playerid, pumpid) {
    return FlexPlayerDialog(playerid, "PumpMenuUpdateStoredFuel", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Update Stored Fuel", "Enter new fuel amount for pump", "Update", "Close", pumpid);
}

FlexDialog:PumpMenuUpdateStoredFuel(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    if (!response) return PumpBusiness:MenuManagePump(playerid, pumpid);
    new storedfuel;
    if (sscanf(inputtext, "d", storedfuel) || storedfuel < 1 || storedfuel > PumpBusiness:GetPumpCapacity(pumpid)) return PumpBusiness:MenuUpdatePumpStoredFuel(playerid, pumpid);
    PumpBusiness:UpdatePumpFuel(pumpid, storedfuel);
    PumpBusiness:UpdatePump(pumpid);
    return PumpBusiness:MenuManagePump(playerid, pumpid);
}

stock PumpBusiness:MenuUpdatePumpMaxCapcity(playerid, pumpid) {
    return FlexPlayerDialog(playerid, "MenuUpdateMaxCapcity", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Update Max Fuel Capacity", "Enter new max fuel capacity", "Update", "Close", pumpid);
}

FlexDialog:MenuUpdateMaxCapcity(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    if (!response) return PumpBusiness:MenuManagePump(playerid, pumpid);
    new newcaplimit;
    if (sscanf(inputtext, "d", newcaplimit) || newcaplimit < 1 || newcaplimit > 1000) return PumpBusiness:MenuUpdatePumpMaxCapcity(playerid, pumpid);
    PumpBusiness:UpdatePumpCapacity(pumpid, newcaplimit);
    PumpBusiness:UpdatePump(pumpid);
    return PumpBusiness:MenuManagePump(playerid, pumpid);
}

stock PumpBusiness:MenuUpdatePumpPrice(playerid, pumpid) {
    return FlexPlayerDialog(playerid, "PumpMenuUpdatePumpPrice", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Update Price", "Enter fuel price per gallon\nLimit: $1 to $100", "Update", "Close", pumpid);
}

FlexDialog:PumpMenuUpdatePumpPrice(playerid, response, listitem, const inputtext[], pumpid, const payload[]) {
    if (!response) return PumpBusiness:MenuManagePump(playerid, pumpid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1 || newprice > 100) return PumpBusiness:MenuUpdatePumpPrice(playerid, pumpid);
    PumpBusiness:UpdatePumpFuelPrice(pumpid, newprice);
    PumpBusiness:UpdatePump(pumpid);
    return PumpBusiness:MenuManagePump(playerid, pumpid);
}

stock PumpBusiness:AdminViewAllBuss(playerid, page = 0) {
    new total = Iter_Count(fuelBusiness);
    if (total == 0) return AlexaMsg(playerid, "there are zero fuel busienss", "Fuel Station");
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new count = 0;

    new string[2000];
    strcat(string, "#\tPumps\tOwner\tBalance\n");
    foreach(new bussid:fuelBusiness) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf(
            "%d\t%d\t%s\t%s\n",
            bussid, PumpBusiness:GetTotalPumps(bussid), PumpBusiness:GetOwner(bussid),
            FormatCurrency(PumpBusiness:GetSalePrice(bussid))
        ));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "MenuAdminViewAllBuss", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Fuel Business | Page: %d", page), string, "Select", "Close", page);
}

FlexDialog:MenuAdminViewAllBuss(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return PumpBusiness:AdminViewAllBuss(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return PumpBusiness:AdminViewAllBuss(playerid, page - 1);
    new bussid = strval(inputtext);
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:AdminViewAllPump(playerid, page = 0) {
    new total = Iter_Count(fuelpumps);
    if (total == 0) return AlexaMsg(playerid, "there are zero fuel pumps", "Fuel Station");
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new count = 0;

    new string[2000];
    strcat(string, "#\tStoreID\tRefilling\tFilling\n");
    foreach(new pumpid:fuelpumps) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf(
            "%d\t%d\t%s\t%s\n",
            pumpid, PumpBusiness:GetPumpBussID(pumpid), PumpBusiness:GetPumpRefillingStatus(pumpid) ? ("Enabled") : ("Disabled"),
            PumpBusiness:GetPumpFillingStatus(pumpid) ? ("Enabled") : ("Disabled")
        ));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "MenuAdminViewAllPump", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Fuel Pumps | Page: %d", page), string, "Select", "Close", page);
}

FlexDialog:MenuAdminViewAllPump(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return PumpBusiness:AdminViewAllPump(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return PumpBusiness:AdminViewAllPump(playerid, page - 1);
    new pumpid = strval(inputtext);
    return PumpBusiness:MenuManagePump(playerid, pumpid);
}

stock PumpBusiness:AdminMenu(playerid) {
    new string[512];
    strcat(string, "Manage Fuel Business\n");
    strcat(string, "Manage Fuel Station by ID\n");
    strcat(string, "Manage Fuel Pump\n");
    strcat(string, "Manage Fuel Pump by ID\n");
    strcat(string, "Refuel All Vehicle\n");
    strcat(string, "Refuel All Pump Station\n");
    strcat(string, "Create Business\n");
    return FlexPlayerDialog(playerid, "MenuAdminMenu", DIALOG_STYLE_LIST, "{4286f4}[Fuel System]: {FFFFEE}Admin Control Panel", string, "Select", "Close");
}

FlexDialog:MenuAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage Fuel Business")) return PumpBusiness:AdminViewAllBuss(playerid);
    if (IsStringSame(inputtext, "Manage Fuel Station by ID")) return PumpBusiness:AdminManageById(playerid);
    if (IsStringSame(inputtext, "Manage Fuel Pump")) return PumpBusiness:AdminViewAllPump(playerid);
    if (IsStringSame(inputtext, "Manage Fuel Pump by ID")) return PumpBusiness:AdminManagePumpById(playerid);
    if (IsStringSame(inputtext, "Refuel All Vehicle")) return PumpBusiness:AdminRefillAllVeh(playerid);
    if (IsStringSame(inputtext, "Refuel All Pump Station")) return PumpBusiness:AdminRefillAllPump(playerid);
    if (IsStringSame(inputtext, "Create Business")) {
        new bussid = PumpBusiness:Create(playerid);
        if (PumpBusiness:IsValidID(bussid)) AlexaMsg(playerid, "created fuel station", "Fuel Station");
        else AlexaMsg(playerid, "unable to create fuel station, maybe max limit reached", "Fuel Station");
        return PumpBusiness:AdminMenu(playerid);
    }
    return 1;
}

stock PumpBusiness:AdminRefillAllVeh(playerid) {
    return FlexPlayerDialog(playerid, "PumpAdminRefillAllVeh", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Refill All Vehicle", "Enter fuel amount to set", "Submit", "Close");
}

FlexDialog:PumpAdminRefillAllVeh(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    new Float:newamount;
    if (sscanf(inputtext, "f", newamount) || newamount < 1.0 || newamount > 100.0) return PumpBusiness:AdminRefillAllVeh(playerid);
    foreach(new vehicleid:Vehicle) if (IsValidVehicle(vehicleid)) SetVehicleFuelEx(vehicleid, newamount);
    AlexaMsg(playerid, sprintf("all vehicles fuel set to %.2f", newamount), "Fuel Station");
    return PumpBusiness:AdminMenu(playerid);
}

stock PumpBusiness:AdminRefillAllPump(playerid) {
    return FlexPlayerDialog(playerid, "PumpAdminRefillAllPump", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Manage Business", "Enter fuel amount to set for pumps", "Submit", "Close");
}

FlexDialog:PumpAdminRefillAllPump(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    new newamount;
    if (sscanf(inputtext, "d", newamount) || newamount < 1 || newamount > 1000) return PumpBusiness:AdminRefillAllPump(playerid);
    foreach(new pumpid:fuelpumps) PumpBusiness:UpdatePumpFuel(pumpid, newamount);
    AlexaMsg(playerid, sprintf("all fuel pump fuel set to %d", newamount), "Fuel Station");
    return PumpBusiness:AdminMenu(playerid);
}

stock PumpBusiness:AdminManageById(playerid) {
    return FlexPlayerDialog(playerid, "PumpAdminManageById", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Manage Business", "Enter fuel station id", "Submit", "Close");
}

FlexDialog:PumpAdminManageById(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    new bussid;
    if (sscanf(inputtext, "d", bussid) || !PumpBusiness:IsValidID(bussid)) return PumpBusiness:AdminManageById(playerid);
    return PumpBusiness:Access(playerid, bussid);
}

stock PumpBusiness:AdminManagePumpById(playerid) {
    return FlexPlayerDialog(playerid, "PumpAdminManagePumpById", DIALOG_STYLE_INPUT, "{4286f4}[Fuel System]: {FFFFEE}Manage Pump", "Enter fuel pump id", "Update", "Submit");
}

FlexDialog:PumpAdminManagePumpById(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PumpBusiness:AdminMenu(playerid);
    new pumpid;
    if (sscanf(inputtext, "d", pumpid) || !PumpBusiness:IsValidPumpID(pumpid)) return PumpBusiness:AdminManagePumpById(playerid);
    return PumpBusiness:MenuManagePump(playerid, pumpid);
}

stock PumpBusiness:ShowList(playerid, page = 0) {
    new total = Iter_Count(fuelBusiness);
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new string[2000];
    strcat(string, "ID\tOwner\tDistance - Location\tFuel\n");
    new count = 0;
    foreach(new bussid:fuelBusiness) {
        if (skip > 0) {
            skip--;
            continue;
        }

        strcat(string, sprintf(
            "{FFFFFF}%d\t%s\t%.1f - %s\t%s\n",
            bussid, PumpBusiness:GetOwner(bussid),
            GetPlayerDistanceFromPoint(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]),
            GetZoneName(PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]),
            PumpBusiness:IsHaveFuel(bussid) ? "{00FF00}YES" : "{FF0000}NO"
        ));

        count++;
        if (count >= perpage) break;
    }

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(
        playerid, "FuelMenuShowList", DIALOG_STYLE_TABLIST_HEADERS, "Fuel Station: List", string, "Select", "Close", page
    );
}

FlexDialog:FuelMenuShowList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) {
        return GPS:ShowMenu(playerid);
    }

    if (IsStringSame(inputtext, "Next Page")) return PumpBusiness:ShowList(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return PumpBusiness:ShowList(playerid, page - 1);
    new bussid = strval(inputtext);
    new string[512];
    strcat(string, "Turn on GPS\n");
    if (GetPlayerAdminLevel(playerid) > 8) {
        strcat(string, "Teleport Me\n");
        strcat(string, "Admin Panel\n");
    }

    FlexPlayerDialog(
        playerid, "FuelMenuShowListEx", DIALOG_STYLE_LIST, "Food Stall",
        string, "Select", "Close", bussid, sprintf("%d", page)
    );
    return 1;
}

FlexDialog:FuelMenuShowListEx(playerid, response, listitem, const inputtext[], bussid, const page[]) {
    if (!response) return PumpBusiness:ShowList(playerid, strval(page));

    if (IsStringSame(inputtext, "Teleport Me")) {
        TeleportPlayer(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2], PumpBusiness:data[bussid][PumpBusiness:vwint][0], PumpBusiness:data[bussid][PumpBusiness:vwint][1]);
        AlexaMsg(playerid, "you are teleported to gps location");
    }

    if (IsStringSame(inputtext, "Turn on GPS")) {
        MarkGPS(playerid, PumpBusiness:data[bussid][PumpBusiness:location][0], PumpBusiness:data[bussid][PumpBusiness:location][1], PumpBusiness:data[bussid][PumpBusiness:location][2]);
        AlexaMsg(playerid, "fuel station location has been marked on your map");
    }

    if (IsStringSame(inputtext, "Admin Panel")) return PumpBusiness:Access(playerid, bussid);
    return 1;
}