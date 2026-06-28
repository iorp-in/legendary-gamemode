#define mechanical_faction 11
enum mechanic:playerdataenum {
    mechanic:repairvehicleid,
    Float:mechanic:health,
    mechanic:status,
    mechanic:timerid
}
new mechanic:playerdata[MAX_PLAYERS][mechanic:playerdataenum];

stock isPlayerNearTowTruck(playerid, Float:range = 20.0) {
    foreach(new vehicleid:Vehicle) {
        if (GetVehicleModel(vehicleid) == 525) {
            if (IsPlayerInRangeOfVehicle(playerid, vehicleid, range)) return 1;
        }
    }
    return 0;
}

stock mechanic:isRepairable(Float:health) {
    if (health > 400) return 1;
    return 0;
}

stock mechanic:GetRepairCost(Float:health) {
    if (health > 900) return Random(400, 500);
    if (health > 800) return Random(800, 1000);
    if (health > 600) return Random(1800, 2000);
    if (health > 400) return Random(3300, 3500);
    return Random(4700, 5000);
}

stock mechanic:GetGarageRepairCost(Float:health) {
    if (health > 900) return Random(200, 250);
    if (health > 800) return Random(400, 500);
    if (health > 600) return Random(800, 1000);
    if (health > 400) return Random(1200, 1500);
    return Random(2200, 2500);
}

stock mechanic:GetRepairTime(Float:health) {
    if (health > 900) return 15;
    if (health > 800) return 30;
    if (health > 600) return 40;
    if (health > 400) return 60;
    return 120;
}

hook OnPlayerLogin(playerid) {
    mechanic:playerdata[playerid][mechanic:status] = 0;
    mechanic:playerdata[playerid][mechanic:timerid] = -1;
    return 1;
}

hook OnPlayerUnfreezed(playerid) {
    if (mechanic:playerdata[playerid][mechanic:status] == 1) {
        freeze(playerid);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_SECONDARY_ATTACK) {
        if (mechanic:playerdata[playerid][mechanic:status] == 1) {
            Anim:Stop(playerid);
            KillTimer(mechanic:playerdata[playerid][mechanic:timerid]);
            mechanic:playerdata[playerid][mechanic:status] = 0;
            mechanic:playerdata[playerid][mechanic:timerid] = -1;
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}vehicle repair failed.");
            unfreeze(playerid);
        }
    }
    return 1;
}

forward FinishRepairing(playerid);
public FinishRepairing(playerid) {
    Anim:Stop(playerid);
    vault:addcash(Vault_ID_Mechanics, mechanic:GetRepairCost(mechanic:playerdata[playerid][mechanic:health]), Vault_Transaction_Cash_To_Vault, sprintf("vehicled repaired by %s", GetPlayerNameEx(playerid)));
    GivePlayerCash(playerid, -mechanic:GetRepairCost(mechanic:playerdata[playerid][mechanic:health]), "repair cost for mechanic");
    ResetVehicleEx(mechanic:playerdata[playerid][mechanic:repairvehicleid]);
    mechanic:playerdata[playerid][mechanic:status] = 0;
    mechanic:playerdata[playerid][mechanic:timerid] = -1;
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}vehicle repaired.");
    unfreeze(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new vehicleid = GetPlayerNearestVehicle(playerid);
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (!IsVehicleHasBonnet(GetVehicleModel(vehicleid))) bonnet = VEHICLE_PARAMS_ON;
    if (!IsPlayerInAnyVehicle(playerid) && bonnet == VEHICLE_PARAMS_ON && engine == VEHICLE_PARAMS_OFF && GetVehicleHealthEx(vehicleid) < 1000.0 && Faction:GetPlayerFID(playerid) == mechanical_faction && Faction:IsPlayerSigned(playerid) && isPlayerNearTowTruck(playerid)) UCP:AddCommand(playerid, "Repair Vehicle", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Repair Vehicle", inputtext)) {
        new vehicleid = GetPlayerNearestVehicle(playerid);
        if (vehicleid == -1) return ~1;
        new string[512], Float:health = GetVehicleHealthEx(vehicleid);
        // if(!mechanic:isRepairable(Float:health)) {
        //     SendClientMessage(playerid, -1, "this vehicle is not repairable here, take it to garage using tow truck.");
        //     return ~1;
        // }
        mechanic:playerdata[playerid][mechanic:repairvehicleid] = vehicleid;
        mechanic:playerdata[playerid][mechanic:health] = Float:health;
        mechanic:playerdata[playerid][mechanic:status] = 0;
        strcat(string, sprintf("Vehicle ID: %d\n", vehicleid));
        strcat(string, sprintf("Vehicle Name: %s\n", GetVehicleName(vehicleid)));
        strcat(string, sprintf("Repair Time: %d seconds\n", mechanic:GetRepairTime(health)));
        strcat(string, sprintf("Repair Cost: $%s\n", FormatCurrency(mechanic:GetRepairCost(health))));
        strcat(string, sprintf("do you want to repair this vehicle?\n"));
        FlexPlayerDialog(playerid, "MechanicRepairMenu", DIALOG_STYLE_MSGBOX, "Mechanic", string, "Yes", "No");
        return ~1;
    }
    return 1;
}

FlexDialog:MechanicRepairMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    mechanic:playerdata[playerid][mechanic:status] = 1;
    new seconds = mechanic:GetRepairTime(mechanic:playerdata[playerid][mechanic:health]);
    mechanic:playerdata[playerid][mechanic:timerid] = SetTimerEx("FinishRepairing", seconds * 1000, false, "d", playerid);
    StopScreenTimer(playerid, 1);
    StartScreenTimer(playerid, seconds);
    freeze(playerid);
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}