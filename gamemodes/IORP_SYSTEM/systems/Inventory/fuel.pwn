#define BackpackInvColumn_Fuel "Fuel"
#define InvLimit_Fuel 20

new FuelInvID;

hook OnInventoryInit() {
    FuelInvID = Backpack:AddInventoryItem("Fuel", InvLimit_Fuel);
    Database:AddColumn(BackpackDB, BackpackInvColumn_Fuel, "int", "0");
    return 1;
}

hook OnBackpackLoad(backPackId) {
    Backpack:PushItem(backPackId, FuelInvID, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Fuel, BackpackDB));
    return 1;
}

hook OnBackpackSave(backPackId) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, FuelInvID), sprintf("%d", backPackId), "id", BackpackInvColumn_Fuel, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backPackId) {
    Backpack:PopItem(backPackId, FuelInvID, Backpack:GetInvItemQuantity(backPackId, FuelInvID));
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId != FuelInvID) return 1;
    if (Backpack:GetInvItemQuantity(backPackId, FuelInvID) < 1) {
        AlexaMsg(playerid, "There is no fuel in the backpack");
    } else {
        new vehicleid = GetPlayerNearestVehicle(playerid, 5.0);
        if (!IsValidVehicle(vehicleid) || !IsVehicleHaveFuelTank(vehicleid)) return AlexaMsg(playerid, "Stand next to the fuel tank of your vehicle to refuel with your backpack");
        RefuelFromBackPack(playerid, backPackId);
    }
    return ~1;
}

stock RefuelFromBackPack(playerid, backPackId) {
    new vehicleid = GetPlayerNearestVehicle(playerid, 5.0);
    if (!IsValidVehicle(vehicleid) || !IsVehicleHaveFuelTank(vehicleid)) return AlexaMsg(playerid, "Stand next to the fuel tank of your vehicle to refuel with your backpack");
    return FlexPlayerDialog(playerid, "RefuelFromBackPack", DIALOG_STYLE_INPUT, "Refuel Vehiclel",
        sprintf("Vehicle Model: %s\nEnter fuel between 1 to %d liter", GetVehicleName(vehicleid), Backpack:GetInvItemQuantity(backPackId, FuelInvID)),
        "Refuel", "Close", backPackId
    );
}

FlexDialog:RefuelFromBackPack(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    new amount, vehicleid = GetPlayerNearestVehicle(playerid, 5.0);
    if (!IsValidVehicle(vehicleid) || !IsVehicleHaveFuelTank(vehicleid)) return AlexaMsg(playerid, "Stand next to the fuel tank of your vehicle to refuel with your backpack");
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > Backpack:GetInvItemQuantity(backPackId, FuelInvID)) return RefuelFromBackPack(playerid, backPackId);
    if (GetVehicleFuelEx(vehicleid) + amount > 100.0) {
        AlexaMsg(playerid, "You cannot add more fuel to your vehicle's fuel tank");
        return RefuelFromBackPack(playerid, backPackId);
    }
    IncreaseDecreaseVehicleFuel(vehicleid, amount);
    Backpack:PopItem(backPackId, FuelInvID, amount);
    GameTextForPlayer(playerid, "~r~Refueling...", 3000, 3);
    return 1;
}