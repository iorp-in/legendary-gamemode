#define MOD_PREVIEW_SECS 5

new ModShop:FeePaintJob = 500;
new ModShop:FeeColor = 500;
new ModShop:FeeHood = 500;
new ModShop:FeeVent = 500;
new ModShop:FeeLight = 500;
new ModShop:FeeExhaust = 500;
new ModShop:FeeFrontBumper = 500;
new ModShop:FeeRearBumper = 500;
new ModShop:FeeRoof = 500;
new ModShop:FeeSpoiler = 500;
new ModShop:FeeSideSkirt = 500;
new ModShop:FeeBullbar = 500;
new ModShop:FeeWheel = 500;
new ModShop:FeeCarStereo = 500;
new ModShop:FeeHydraulic = 500;
new ModShop:FeeNitrousOxide = 500;
new ModShop:FeeNeonLight = 500;

hook GlobalOneMinuteInterval() {
    ModShop:FeePaintJob = Random(1000, 5000);
    ModShop:FeeColor = Random(1000, 2000);
    ModShop:FeeHood = Random(1000, 5000);
    ModShop:FeeVent = Random(1000, 5000);
    ModShop:FeeLight = Random(1000, 5000);
    ModShop:FeeExhaust = Random(1000, 5000);
    ModShop:FeeFrontBumper = Random(1000, 5000);
    ModShop:FeeRearBumper = Random(1000, 5000);
    ModShop:FeeRoof = Random(1000, 5000);
    ModShop:FeeSpoiler = Random(1000, 5000);
    ModShop:FeeSideSkirt = Random(1000, 5000);
    ModShop:FeeBullbar = Random(1000, 5000);
    ModShop:FeeWheel = Random(1000, 5000);
    ModShop:FeeCarStereo = Random(1000, 2000);
    ModShop:FeeHydraulic = Random(1000, 2000);
    ModShop:FeeNitrousOxide = Random(1000, 2000);
    ModShop:FeeNeonLight = Random(1000, 5000);
    return 1;
}

stock ModShop:IsMechanicAvailable() {
    foreach(new playerid:Player) if (Faction:GetPlayerFID(playerid) == FACTION_ID_DOM && Faction:IsPlayerSigned(playerid)) return 1;
    return 0;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 2) return 1;
    if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ~1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid)) return ~1;
    ModShop:ShowRepairMenu(playerid);
    return ~1;
}

stock ModShop:ShowRepairMenu(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if (ModShop:IsMechanicAvailable() && (Faction:GetPlayerFID(playerid) != FACTION_ID_DOM || !Faction:IsPlayerSigned(playerid)))
        return AlexaMsg(playerid, "self repair is not available, please call a mechanic.", "Garage");

    new Float:vHealth;
    GetVehicleHealth(vehicleid, vHealth);
    if (vHealth > 995.0) return AlexaMsg(playerid, "Your Vehicle in good Health, Does not need Repair.", "Garage");

    new repaircost = mechanic:GetGarageRepairCost(GetVehicleHealthEx(GetPlayerVehicleID(playerid)));
    if (GetPlayerCash(playerid) < repaircost) return AlexaMsg(playerid, sprintf("You Need $%s to repair your vehicle.", FormatCurrency(repaircost)), "Garage");

    freeze(playerid);
    AlexaMsg(playerid, "welcome, let us check your vehicle for you.", "Garage");
    new string[512], Float:health = GetVehicleHealthEx(vehicleid);
    strcat(string, sprintf("Vehicle ID: %d\n", vehicleid));
    strcat(string, sprintf("Vehicle Name: %s\n", GetVehicleName(vehicleid)));
    strcat(string, sprintf("Repair Time: <1 minute>\n"));
    strcat(string, sprintf("Repair Cost: $%s\n", FormatCurrency(mechanic:GetGarageRepairCost(health))));
    strcat(string, sprintf("do you want to repair this vehicle?\n"));
    return FlexPlayerDialog(playerid, "RepairShopMenuBill", DIALOG_STYLE_MSGBOX, "Garage", string, "Yes", "No");
}

FlexDialog:RepairShopMenuBill(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) {
        unfreeze(playerid);
        return AlexaMsg(playerid, "repair cancelled", "Garage");
    }
    AlexaMsg(playerid, "Repairing your vehilce, Please wait...", "Garage");
    new seconds = Random(10, 60);
    StartScreenTimer(playerid, seconds);
    SetPreciseTimer("FinishRepairVehicle", seconds * 1000, false, "d", playerid);
    return 1;
}

forward FinishRepairVehicle(playerid);
public FinishRepairVehicle(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid)) return 1;
    new repaircost = mechanic:GetGarageRepairCost(GetVehicleHealthEx(vehicleid));
    GivePlayerCash(playerid, -repaircost, sprintf("charged for %s vehicle repair", GetVehicleName(vehicleid)));
    vault:addcash(Vault_ID_Mechanics, repaircost, Vault_Transaction_Cash_To_Vault, sprintf(
        "%s repaired %s", GetPlayerNameEx(playerid), GetVehicleName(vehicleid)
    ));
    ResetVehicleEx(vehicleid);
    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~y~~h~~h~Your Vehicle Repaired~n~~g~~h~~h~Drive Safe", 5000, 3);
    unfreeze(playerid);
    return 1;
}

stock ModShop:ShowModMenu(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return AlexaMsg(playerid, "do you want a robot arm or what, bring your vehicle for modification", "Garage");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return AlexaMsg(playerid, "you have to be on driver seat for modifications", "Garage");

    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    if (
        IsArrayContainNumber(LightMotor_Vehicles_RC, modelid) ||
        IsArrayContainNumber(HeavyMotor_Vehicles_2, modelid)
    ) return AlexaMsg(playerid, "sorry, this vehicle is blacklisted for modificaitons.", "Garage");

    if (!PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid)))
        return AlexaMsg(playerid, "sorry, we only allow to modify personal vehicles only.", "Garage");

    new Float:vHealth;
    GetVehicleHealth(GetPlayerVehicleID(playerid), vHealth);
    if (vHealth < 900.0) return AlexaMsg(playerid, "sorry, your vehicle is not in good heath, try repair first.", "Garage");

    new string[1024];
    strcat(string, "Mod Name\tCurrent Price\n");
    strcat(string, sprintf("Colors\t$%s\n", FormatCurrency(ModShop:FeeColor)));
    if (ModShop:IsModelSupportPaintJobs(modelid)) strcat(string, sprintf("Paint Jobs\t$%s\n", FormatCurrency(ModShop:FeePaintJob)));
    if (ModShop:IsModelSupportHoods(modelid)) strcat(string, sprintf("Hoods\t$%s\n", FormatCurrency(ModShop:FeeHood)));
    if (ModShop:IsModelSupportVents(modelid)) strcat(string, sprintf("Vents\t$%s\n", FormatCurrency(ModShop:FeeVent)));
    if (ModShop:IsModelSupportLights(modelid)) strcat(string, sprintf("Lights\t$%s\n", FormatCurrency(ModShop:FeeLight)));
    if (ModShop:IsModelSupportExhausts(modelid)) strcat(string, sprintf("Exhausts\t$%s\n", FormatCurrency(ModShop:FeeExhaust)));
    if (ModShop:IsModelSupportFrontBumpers(modelid)) strcat(string, sprintf("Front Bumpers\t$%s\n", FormatCurrency(ModShop:FeeFrontBumper)));
    if (ModShop:IsModelSupportRearBumpers(modelid)) strcat(string, sprintf("Rear Bumpers\t$%s\n", FormatCurrency(ModShop:FeeRearBumper)));
    if (ModShop:IsModelSupportRoofs(modelid)) strcat(string, sprintf("Roofs\t$%s\n", FormatCurrency(ModShop:FeeRoof)));
    if (ModShop:IsModelSupportSpoilers(modelid)) strcat(string, sprintf("Spoilers\t$%s\n", FormatCurrency(ModShop:FeeSpoiler)));
    if (ModShop:IsModelSupportSideSkirts(modelid)) strcat(string, sprintf("Side Skirts\t$%s\n", FormatCurrency(ModShop:FeeSideSkirt)));
    if (ModShop:IsModelSupportBullbars(modelid)) strcat(string, sprintf("Bullbars\t$%s\n", FormatCurrency(ModShop:FeeBullbar)));
    if (ModShop:IsModelSupportWheels(modelid)) strcat(string, sprintf("Wheels\t$%s\n", FormatCurrency(ModShop:FeeWheel)));
    if (ModShop:IsModelSupportCarStereo(modelid)) strcat(string, sprintf("Car Stereo\t$%s\n", FormatCurrency(ModShop:FeeCarStereo)));
    if (ModShop:IsModelSupportHydraulics(modelid)) strcat(string, sprintf("Hydraulics\t$%s\n", FormatCurrency(ModShop:FeeHydraulic)));
    if (ModShop:IsModelSupportNitrousOxide(modelid)) strcat(string, sprintf("Nitrous Oxide\t$%s\n", FormatCurrency(ModShop:FeeNitrousOxide)));
    if (ModShop:IsModelSupportNeonLight(modelid)) strcat(string, sprintf("Neon Light\t$%s\n", FormatCurrency(ModShop:FeeNeonLight)));
    strcat(string, "Remove All Mods\n");

    freeze(playerid);
    SetCameraBehindPlayer(playerid);
    return FlexPlayerDialog(playerid, "ShopModification", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[RepairShop]: {FFFFEE}Car Tuning Menu", string, "Select", "Close");
}

FlexDialog:ShopModification(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) {
        PersonalVehicle:SaveVehicleMod(GetPlayerVehicleID(playerid));
        return unfreeze(playerid);
    }
    SetPVarString(playerid, "mod_shop_component_type", inputtext);
    return ModShop:ShowSubMenu(playerid);
}

stock ModShop:ShowSubMenu(playerid) {
    new component_type[50];
    GetPVarString(playerid, "mod_shop_component_type", component_type, sizeof component_type);
    if (IsStringSame("Paint Jobs", component_type)) return ModShop:ShowMenuPaintJobs(playerid);
    if (IsStringSame("Colors", component_type)) return ModShop:ShowMenuColors(playerid);
    if (IsStringSame("Neon Light", component_type)) return ModShop:ShowMenuNeon(playerid);
    if (IsStringSame("Hoods", component_type)) return ModShop:ShowMenuHood(playerid);
    if (IsStringSame("Vents", component_type)) return ModShop:ShowMenuVent(playerid);
    if (IsStringSame("Lights", component_type)) return ModShop:ShowMenuLights(playerid);
    if (IsStringSame("Exhausts", component_type)) return ModShop:ShowMenuExhausts(playerid);
    if (IsStringSame("Front Bumpers", component_type)) return ModShop:ShowMenuFrontBumpers(playerid);
    if (IsStringSame("Rear Bumpers", component_type)) return ModShop:ShowMenuRearBumpers(playerid);
    if (IsStringSame("Roofs", component_type)) return ModShop:ShowMenuRoofs(playerid);
    if (IsStringSame("Spoilers", component_type)) return ModShop:ShowMenuSpoilers(playerid);
    if (IsStringSame("Side Skirts", component_type)) return ModShop:ShowMenuSideSkirts(playerid);
    if (IsStringSame("Bullbars", component_type)) return ModShop:ShowMenuBullbars(playerid);
    if (IsStringSame("Wheels", component_type)) return ModShop:ShowMenuWheels(playerid);
    if (IsStringSame("Car Stereo", component_type)) return ModShop:ShowMenuStereo(playerid);
    if (IsStringSame("Hydraulics", component_type)) return ModShop:ShowMenuHydaulics(playerid);
    if (IsStringSame("Nitrous Oxide", component_type)) return ModShop:ShowMenuNOS(playerid);
    if (IsStringSame("Remove All Mods", component_type)) {
        unfreeze(playerid);
        new vehicleid = GetPlayerVehicleID(playerid);
        RemovePlayerFromVehicle(playerid);
        new xid = PersonalVehicle:GetID(vehicleid);
        if (PersonalVehicle:IsValidID(xid)) return PersonalVehicle:RemoveMod(xid);
        return 1;
    }
    return 1;
}

stock ModShop:ShowMenuPaintJobs(playerid) {
    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 30, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Paintjobs | Price: $%s", FormatCurrency(ModShop:FeePaintJob)), "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5", "Apply", "Close"
    );
}

stock ModShop:ShowMenuColors(playerid) {
    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 30, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Colors | Price: $%s", FormatCurrency(ModShop:FeeColor)), "Random\nBlack\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\nCustom Color", "Apply", "Close"
    );
}

stock ModShop:ShowMenuWheels(playerid) {
    new string[512];
    strcat(string, "Offroad\n");
    strcat(string, "Mega\n");
    strcat(string, "Wires\n");
    strcat(string, "Twist\n");
    strcat(string, "Grove\n");
    strcat(string, "Import\n");
    strcat(string, "Atomic\n");
    strcat(string, "Ahab\n");
    strcat(string, "Virtual\n");
    strcat(string, "Access\n");
    strcat(string, "Trance\n");
    strcat(string, "Shadow\n");
    strcat(string, "Rimshine\n");
    strcat(string, "Classic\n");
    strcat(string, "Cutter\n");
    strcat(string, "Switch\n");
    strcat(string, "Dollar\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 50, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Wheels | Price: $%s", FormatCurrency(ModShop:FeeWheel)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuStereo(playerid) {
    SetCameraBehindPlayer(playerid);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Car Stereo | Price: $%s", FormatCurrency(ModShop:FeeCarStereo)), "Bass Boost", "Apply", "Close"
    );
}

stock ModShop:ShowMenuHydaulics(playerid) {
    SetCameraBehindPlayer(playerid);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Hydaulics | Price: $%s", FormatCurrency(ModShop:FeeHydraulic)), "Hydaulics", "Apply", "Close"
    );
}

stock ModShop:ShowMenuNOS(playerid) {
    SetCameraBehindPlayer(playerid);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Nitrous Oxide | Price: $%s", FormatCurrency(ModShop:FeeNitrousOxide)), "2x Nitrous\n5x Nitrous\n10x Nitrous", "Apply", "Close"
    );
}

stock ModShop:ShowMenuNeon(playerid) {
    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 50, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Neon Light | Price: $%s", FormatCurrency(ModShop:FeeNeonLight)), "Blue\nRed\nGreen\nWhite\nPink\nYellow\nRemove All Neon", "Apply", "Close"
    );
}

stock ModShop:ShowMenuHood(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDHood(modelid, 0) != -1) strcat(string, "Fury\n");
    if (ModShop:GetModelCompIDHood(modelid, 1) != -1) strcat(string, "Champ\n");
    if (ModShop:GetModelCompIDHood(modelid, 2) != -1) strcat(string, "Race\n");
    if (ModShop:GetModelCompIDHood(modelid, 3) != -1) strcat(string, "Worx\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 0, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Hoods | Price: $%s", FormatCurrency(ModShop:FeeHood)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuVent(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDVent(modelid, 0) != -1) strcat(string, "Oval\n");
    if (ModShop:GetModelCompIDVent(modelid, 1) != -1) strcat(string, "Square\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, -45, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Vents | Price: $%s", FormatCurrency(ModShop:FeeVent)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuLights(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDLight(modelid, 0) != -1) strcat(string, "Round\n");
    if (ModShop:GetModelCompIDLight(modelid, 1) != -1) strcat(string, "Square\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 10, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Lights | Price: $%s", FormatCurrency(ModShop:FeeLight)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuExhausts(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDExhausts(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 2) != -1) strcat(string, "Low Co. Chromer exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 3) != -1) strcat(string, "Low Co. Slamin exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 4) != -1) strcat(string, "Transfender Large exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 5) != -1) strcat(string, "Transfender Medium exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 6) != -1) strcat(string, "Transfender Small exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 7) != -1) strcat(string, "Transfender Twin exhaust\n");
    if (ModShop:GetModelCompIDExhausts(modelid, 8) != -1) strcat(string, "Transfender Upswept exhaust\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 200, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Exhausts | Price: $%s", FormatCurrency(ModShop:FeeExhaust)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuFrontBumpers(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDFrontBumper(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien Bumper\n");
    if (ModShop:GetModelCompIDFrontBumper(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow Bumper\n");
    if (ModShop:GetModelCompIDFrontBumper(modelid, 2) != -1) strcat(string, "Low co. Chromer Bumper\n");
    if (ModShop:GetModelCompIDFrontBumper(modelid, 3) != -1) strcat(string, "Low co. Slamin Bumper\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 10, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Front Bumpers | Price: $%s", FormatCurrency(ModShop:FeeFrontBumper)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuRearBumpers(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDRearBumper(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien Bumper\n");
    if (ModShop:GetModelCompIDRearBumper(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow Bumper\n");
    if (ModShop:GetModelCompIDRearBumper(modelid, 2) != -1) strcat(string, "Low co. Chromer Bumper\n");
    if (ModShop:GetModelCompIDRearBumper(modelid, 3) != -1) strcat(string, "Low co. Slamin Bumper\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 200, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Rear Bumpers | Price: $%s", FormatCurrency(ModShop:FeeRearBumper)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuRoofs(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDRoof(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien\n");
    if (ModShop:GetModelCompIDRoof(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow\n");
    if (ModShop:GetModelCompIDRoof(modelid, 2) != -1) strcat(string, "Low Co. Hardtop Roof\n");
    if (ModShop:GetModelCompIDRoof(modelid, 3) != -1) strcat(string, "Low Co. Softtop Roof\n");
    if (ModShop:GetModelCompIDRoof(modelid, 4) != -1) strcat(string, "Transfender Roof Scoop\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, -45, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Roofs | Price: $%s", FormatCurrency(ModShop:FeeRoof)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuSpoilers(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDSpoiler(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 2) != -1) strcat(string, "Transfender Win Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 3) != -1) strcat(string, "Transfender Fury Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 4) != -1) strcat(string, "Transfender Alpha Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 5) != -1) strcat(string, "Transfender Pro Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 6) != -1) strcat(string, "Transfender Champ Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 7) != -1) strcat(string, "Transfender Race Spoiler\n");
    if (ModShop:GetModelCompIDSpoiler(modelid, 8) != -1) strcat(string, "Transfender Drag Spoiler\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 200, 3);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[RepairShop]: {FFFFEE}Spoilers | Price: $%s", FormatCurrency(ModShop:FeeSpoiler)), string, "Apply", "Close"
    );
}

stock ModShop:ShowMenuSideSkirts(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDSideSkirts(modelid, 0) != -1) strcat(string, "Wheel Arc. Alien Side Skirt\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 1) != -1) strcat(string, "Wheel Arc. X-Flow Side Skirt\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 2) != -1) strcat(string, "Locos Chrome Strip\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 3) != -1) strcat(string, "Locos Chrome Flames\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 4) != -1) strcat(string, "Locos Chrome Arches\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 5) != -1) strcat(string, "Locos Chrome Trim\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 6) != -1) strcat(string, "Locos Wheelcovers\n");
    if (ModShop:GetModelCompIDSideSkirts(modelid, 7) != -1) strcat(string, "Transfender Side Skirt\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 90, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST, "{4286f4}[RepairShop]: {FFFFEE}Side Skirts", string, "Apply", "Close");
}

stock ModShop:ShowMenuBullbars(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new string[512];
    if (ModShop:GetModelCompIDBullBar(modelid, 0) != -1) strcat(string, "Locos Chrome Grill\n");
    if (ModShop:GetModelCompIDBullBar(modelid, 1) != -1) strcat(string, "Locos Chrome Bars\n");
    if (ModShop:GetModelCompIDBullBar(modelid, 2) != -1) strcat(string, "Locos Chrome Lights\n");
    if (ModShop:GetModelCompIDBullBar(modelid, 3) != -1) strcat(string, "Locos Chrome Bullbar\n");

    SetCameraVehicleAngle(playerid, GetPlayerVehicleID(playerid), 8, 0, 0);
    return FlexPlayerDialog(playerid, "ShopRepairMenuModInput", DIALOG_STYLE_LIST, sprintf("{4286f4}[RepairShop]: {FFFFEE}Bullbars | Price: $%s", FormatCurrency(ModShop:FeeBullbar)), string, "Apply", "Close");
}

FlexDialog:ShopRepairMenuModInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ModShop:ShowModMenu(playerid);
    new component_type[50];
    GetPVarString(playerid, "mod_shop_component_type", component_type, sizeof component_type);
    if (strlen(component_type) < 1) return 1;
    new component_id_one = -1, component_id_two = -1, component_fee = 0, component_type_id, component_preinstalled_one = 0, component_preinstalled_two = 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    if (IsStringSame(component_type, "Paint Jobs")) {
        vault:PlayerVault(playerid, -ModShop:FeePaintJob, "vehicle paint job modification", Vault_ID_Mechanics, ModShop:FeePaintJob,
            sprintf("vehicle paint job modification fee from %s", GetPlayerNameEx(playerid))
        );
        ChangeVehiclePaintjob(vehicleid, listitem);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        AlexaMsg(playerid, "You have succesfully added paintjob", "Garage");
        CallRemoteFunction("OnVehiclePaintjob", "ddd", playerid, vehicleid, listitem);
        return ModShop:ShowSubMenu(playerid);
    }
    if (IsStringSame(component_type, "Colors")) {
        if (GetPlayerCash(playerid) < ModShop:FeeColor) {
            AlexaMsg(playerid, "You don't have enough money", "Garage");
            return ModShop:ShowSubMenu(playerid);
        }
        if (IsStringSame(inputtext, "Custom Color")) return RepairShopCustomColor(playerid);
        vault:PlayerVault(playerid, -ModShop:FeeColor, "vehicle color modification", Vault_ID_Mechanics, ModShop:FeeColor,
            sprintf("vehicle color modification fee from %s", GetPlayerNameEx(playerid))
        );

        enum Colours_Enum {
            colour_1,
            colour_2
        };
        new Colours[][Colours_Enum] = {
            {-1, -1 },
            { 0, 0 },
            { 1, 1 },
            { 3, 3 },
            { 79, 79 },
            { 86, 86 },
            { 6, 6 },
            { 126, 126 },
            { 66, 66 },
            { 24, 24 },
            { 123, 123 },
            { 53, 53 },
            { 93, 93 },
            { 83, 83 },
            { 60, 60 },
            { 161, 161 },
            { 153, 153 }
        };
        ChangeVehicleColor(vehicleid, Colours[listitem][colour_1], Colours[listitem][colour_2]);
        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
        AlexaMsg(playerid, "You have succesfully repainted your vehicle", "Garage");
        return ModShop:ShowSubMenu(playerid);
    }
    if (IsStringSame(component_type, "Neon Light")) {
        if (GetPlayerCash(playerid) < ModShop:FeeNeonLight) {
            AlexaMsg(playerid, "You don't have enough money", "Garage");
            return ModShop:ShowSubMenu(playerid);
        }
        vault:PlayerVault(playerid, -ModShop:FeeNeonLight, "vehicle neon lights modification",
            Vault_ID_Mechanics, ModShop:FeeNeonLight, sprintf("vehicle neon lights modification fee from %s", GetPlayerNameEx(playerid))
        );
        if (listitem == 0) SetVehicleNeonLights(vehicleid, true, BLUE_NEON);
        if (listitem == 1) SetVehicleNeonLights(vehicleid, true, RED_NEON);
        if (listitem == 2) SetVehicleNeonLights(vehicleid, true, GREEN_NEON);
        if (listitem == 3) SetVehicleNeonLights(vehicleid, true, WHITE_NEON);
        if (listitem == 4) SetVehicleNeonLights(vehicleid, true, PINK_NEON);
        if (listitem == 5) SetVehicleNeonLights(vehicleid, true, YELLOW_NEON);
        if (listitem == 6) SetVehicleNeonLights(vehicleid, false, WHITE_NEON);
        if (listitem == 6) PersonalVehicle:SetNeon(GetPlayerVehicleID(playerid), 0);
        else PersonalVehicle:SetNeon(GetPlayerVehicleID(playerid), listitem + 1);
        PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
        AlexaMsg(playerid, "Component successfully added", "Garage");
        return ModShop:ShowSubMenu(playerid);
    }
    if (IsStringSame(component_type, "Hoods")) {
        if (IsStringSame(inputtext, "Fury")) component_type_id = 0;
        if (IsStringSame(inputtext, "Champ")) component_type_id = 1;
        if (IsStringSame(inputtext, "Race")) component_type_id = 2;
        if (IsStringSame(inputtext, "Worx")) component_type_id = 3;
        component_id_one = ModShop:GetModelCompIDHood(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HOOD);
        component_fee = ModShop:FeeHood;
    }
    if (IsStringSame(component_type, "Vents")) {
        if (IsStringSame(inputtext, "Oval")) component_type_id = 0;
        if (IsStringSame(inputtext, "Square")) component_type_id = 1;
        component_id_one = ModShop:GetModelCompIDVent(modelid, component_type_id, VEH_MOD_SIDE_LEFT);
        component_id_two = ModShop:GetModelCompIDVent(modelid, component_type_id, VEH_MOD_SIDE_LEFT);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_LEFT);
        component_preinstalled_two = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_VENT_RIGHT);
        component_fee = ModShop:FeeVent;
    }
    if (IsStringSame(component_type, "Lights")) {
        if (IsStringSame(inputtext, "Round")) component_type_id = 0;
        if (IsStringSame(inputtext, "Square")) component_type_id = 1;
        component_id_one = ModShop:GetModelCompIDLight(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_LAMPS);
        component_fee = ModShop:FeeLight;
    }
    if (IsStringSame(component_type, "Exhausts")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien exhaust")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow exhaust")) component_type_id = 1;
        if (IsStringSame(inputtext, "Low Co. Chromer exhaust")) component_type_id = 2;
        if (IsStringSame(inputtext, "Low Co. Slamin exhaust")) component_type_id = 3;
        if (IsStringSame(inputtext, "Transfender Large exhaust")) component_type_id = 4;
        if (IsStringSame(inputtext, "Transfender Medium exhaust")) component_type_id = 5;
        if (IsStringSame(inputtext, "Transfender Small exhaust")) component_type_id = 6;
        if (IsStringSame(inputtext, "Transfender Twin exhaust")) component_type_id = 7;
        if (IsStringSame(inputtext, "Transfender Upswept exhaust")) component_type_id = 8;
        component_id_one = ModShop:GetModelCompIDExhausts(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_EXHAUST);
        component_fee = ModShop:FeeExhaust;
    }
    if (IsStringSame(component_type, "Front Bumpers")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien Bumper")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow Bumper")) component_type_id = 1;
        if (IsStringSame(inputtext, "Low co. Chromer Bumper")) component_type_id = 2;
        if (IsStringSame(inputtext, "Low co. Slamin Bumper")) component_type_id = 3;
        component_id_one = ModShop:GetModelCompIDFrontBumper(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_FRONT_BUMPER);
        component_fee = ModShop:FeeFrontBumper;
    }
    if (IsStringSame(component_type, "Rear Bumpers")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien Bumper")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow Bumper")) component_type_id = 1;
        if (IsStringSame(inputtext, "Low co. Chromer Bumper")) component_type_id = 2;
        if (IsStringSame(inputtext, "Low co. Slamin Bumper")) component_type_id = 3;
        component_id_one = ModShop:GetModelCompIDRearBumper(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_REAR_BUMPER);
        component_fee = ModShop:FeeRearBumper;
    }
    if (IsStringSame(component_type, "Roofs")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow")) component_type_id = 1;
        if (IsStringSame(inputtext, "Low Co. Hardtop Roof")) component_type_id = 2;
        if (IsStringSame(inputtext, "Low Co. Softtop Roof")) component_type_id = 3;
        if (IsStringSame(inputtext, "Transfender Roof Scoop")) component_type_id = 4;
        component_id_one = ModShop:GetModelCompIDRoof(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_ROOF);
        component_fee = ModShop:FeeRoof;
    }
    if (IsStringSame(component_type, "Spoilers")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien Spoiler")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow Spoiler")) component_type_id = 1;
        if (IsStringSame(inputtext, "Transfender Win Spoiler")) component_type_id = 2;
        if (IsStringSame(inputtext, "Transfender Fury Spoiler")) component_type_id = 3;
        if (IsStringSame(inputtext, "Transfender Alpha Spoiler")) component_type_id = 4;
        if (IsStringSame(inputtext, "Transfender Pro Spoiler")) component_type_id = 5;
        if (IsStringSame(inputtext, "Transfender Champ Spoiler")) component_type_id = 6;
        if (IsStringSame(inputtext, "Transfender Race Spoiler")) component_type_id = 7;
        if (IsStringSame(inputtext, "Transfender Drag Spoiler")) component_type_id = 8;
        component_id_one = ModShop:GetModelCompIDSpoiler(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SPOILER);
        component_fee = ModShop:FeeSpoiler;
    }
    if (IsStringSame(component_type, "Side Skirts")) {
        if (IsStringSame(inputtext, "Wheel Arc. Alien Side Skirt")) component_type_id = 0;
        if (IsStringSame(inputtext, "Wheel Arc. X-Flow Side Skirt")) component_type_id = 1;
        if (IsStringSame(inputtext, "Locos Chrome Strip")) component_type_id = 2;
        if (IsStringSame(inputtext, "Locos Chrome Flames")) component_type_id = 3;
        if (IsStringSame(inputtext, "Locos Chrome Arches")) component_type_id = 4;
        if (IsStringSame(inputtext, "Locos Chrome Trim")) component_type_id = 5;
        if (IsStringSame(inputtext, "Locos Wheelcovers")) component_type_id = 6;
        if (IsStringSame(inputtext, "Transfender Side Skirt")) component_type_id = 7;
        component_id_one = ModShop:GetModelCompIDSideSkirts(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_SIDESKIRT);
        component_fee = ModShop:FeeSideSkirt;
    }
    if (IsStringSame(component_type, "Bullbars")) {
        if (IsStringSame(inputtext, "Locos Chrome Grill")) component_type_id = 0;
        if (IsStringSame(inputtext, "Locos Chrome Bars")) component_type_id = 1;
        if (IsStringSame(inputtext, "Locos Chrome Lights")) component_type_id = 2;
        if (IsStringSame(inputtext, "Locos Chrome Bullbar")) component_type_id = 3;
        component_id_one = ModShop:GetModelCompIDBullBar(modelid, component_type_id);
        // unknown type
        component_preinstalled_one = 0;
        component_fee = ModShop:FeeBullbar;
    }
    if (IsStringSame(component_type, "Wheels")) {
        if (IsStringSame(inputtext, "Offroad")) component_type_id = 0;
        if (IsStringSame(inputtext, "Mega")) component_type_id = 1;
        if (IsStringSame(inputtext, "Wires")) component_type_id = 2;
        if (IsStringSame(inputtext, "Twist")) component_type_id = 3;
        if (IsStringSame(inputtext, "Grove")) component_type_id = 4;
        if (IsStringSame(inputtext, "Import")) component_type_id = 5;
        if (IsStringSame(inputtext, "Atomic")) component_type_id = 6;
        if (IsStringSame(inputtext, "Ahab")) component_type_id = 7;
        if (IsStringSame(inputtext, "Virtual")) component_type_id = 8;
        if (IsStringSame(inputtext, "Access")) component_type_id = 9;
        if (IsStringSame(inputtext, "Trance")) component_type_id = 10;
        if (IsStringSame(inputtext, "Shadow")) component_type_id = 11;
        if (IsStringSame(inputtext, "Rimshine")) component_type_id = 12;
        if (IsStringSame(inputtext, "Classic")) component_type_id = 13;
        if (IsStringSame(inputtext, "Cutter")) component_type_id = 14;
        if (IsStringSame(inputtext, "Switch")) component_type_id = 15;
        if (IsStringSame(inputtext, "Dollar")) component_type_id = 16;
        component_id_one = ModShop:GetModelWheel(component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_WHEELS);
        component_fee = ModShop:FeeBullbar;
    }
    if (IsStringSame(component_type, "Car Stereo")) {
        component_id_one = ModShop:GetModelCarStereo(modelid);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_STEREO);
        component_fee = ModShop:FeeCarStereo;
    }
    if (IsStringSame(component_type, "Hydraulics")) {
        component_id_one = ModShop:GetModelHydraulics(modelid);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_HYDRAULICS);
        component_fee = ModShop:FeeHydraulic;
    }
    if (IsStringSame(component_type, "Nitrous Oxide")) {
        if (IsStringSame(inputtext, "2x Nitrous")) component_type_id = 0;
        if (IsStringSame(inputtext, "5x Nitrous")) component_type_id = 1;
        if (IsStringSame(inputtext, "10x Nitrous")) component_type_id = 2;
        component_id_one = ModShop:GetModelNitro(modelid, component_type_id);
        component_preinstalled_one = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO);
        component_fee = ModShop:FeeNitrousOxide;
    }
    if (component_id_one == -1 && component_id_two == -1) {
        AlexaMsg(playerid, "You cannot install this component on your vehicleid.", "Garage");
        return ModShop:ShowSubMenu(playerid);
    }
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    if (component_id_one != -1) AddVehicleComponent(vehicleid, component_id_one);
    if (component_id_two != -1) AddVehicleComponent(vehicleid, component_id_two);
    GameTextForPlayer(playerid, "~r~preview", MOD_PREVIEW_SECS * 1000, 3);
    StartScreenTimer(playerid, MOD_PREVIEW_SECS);
    SetPreciseTimer(
        "EndModInstallPreview", MOD_PREVIEW_SECS * 1000, false,
        "ddddddss",
        playerid, component_id_one, component_id_two, component_preinstalled_one,
        component_preinstalled_two, component_fee, component_type, inputtext
    );
    return 1;
}

forward EndModInstallPreview(
    playerid, component_id_one, component_id_two, component_preinstalled_one, component_preinstalled_two, component_fee, const component_type[], const component_name[]
);
public EndModInstallPreview(
    playerid, component_id_one, component_id_two, component_preinstalled_one, component_preinstalled_two, component_fee, const component_type[], const component_name[]
) {
    if (!IsPlayerConnected(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (component_id_one != -1) RemoveVehicleComponent(vehicleid, component_id_one);
    if (component_id_two != -1) RemoveVehicleComponent(vehicleid, component_id_two);
    if (component_preinstalled_one != 0) AddVehicleComponent(vehicleid, component_preinstalled_one);
    if (component_preinstalled_two != 0) AddVehicleComponent(vehicleid, component_preinstalled_two);
    return ModShopConfirmPurchase(playerid, component_id_one, component_id_two, component_fee, component_type, component_name);
}

stock ModShopConfirmPurchase(playerid, component_id_one, component_id_two, component_fee, const type[], const component_name[]) {
    new string[512];
    strcat(string, "{FFFFFF}--------------------[ Vehicle Component Details ]-------------------\n\n");
    strcat(string, sprintf("{FFFB93}Component Type: {ECB021}%s\n", type));
    strcat(string, sprintf("{FFFB93}Component Name: {ECB021}%s\n", component_name));
    strcat(string, sprintf("{FFFB93}Component Fee: {ECB021}$%s\n", FormatCurrency(component_fee)));
    strcat(string, "{FFFB93}Do you want to buy this component?\n\n");
    strcat(string, "{FFFFFF}----------------------------------------------------------------------------");
    return FlexPlayerDialog(playerid, "ModShopConfirmPurchase", DIALOG_STYLE_MSGBOX, "Confirm Purchase",
        string, "Yes", "No", component_fee, sprintf("%d %d", component_id_one, component_id_two)
    );
}

FlexDialog:ModShopConfirmPurchase(playerid, response, listitem, const inputtext[], component_fee, const payload[]) {
    new component_id_one, component_id_two;
    sscanf(payload, "dd", component_id_one, component_id_two);
    if (!response) return ModShop:ShowSubMenu(playerid);
    if (GetPlayerCash(playerid) < component_fee) {
        AlexaMsg(playerid, "You don't have enough money to install this component on your vehicleid.", "Garage");
        return ModShop:ShowSubMenu(playerid);
    }
    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
    new vehicleid = GetPlayerVehicleID(playerid);
    if (component_id_one != -1) AddVehicleComponent(vehicleid, component_id_one);
    if (component_id_two != -1) AddVehicleComponent(vehicleid, component_id_two);
    new component_name[50];
    GetPVarString(playerid, "mod_shop_component_type", component_name, sizeof component_name);
    if (component_fee > 0) vault:PlayerVault(playerid, -component_fee, sprintf("vehicle %s modification", component_name),
        Vault_ID_Mechanics, component_fee, sprintf("vehicle %s modification fee from %s", component_name, GetPlayerNameEx(playerid))
    );
    AlexaMsg(playerid, "Component successfully added", "Garage");
    return ModShop:ShowSubMenu(playerid);
}

stock RepairShopCustomColor(playerid) {
    return FlexPlayerDialog(playerid, "ShopRepairMenuCustomColor", DIALOG_STYLE_INPUT,
        "{4286f4}[RepairShop]: {FFFFEE}Custom Vehicle Color", "Enter [Color 1] [Color 2]\nfor random color, type: -1 -1", "Apply", "Close"
    );
}

FlexDialog:ShopRepairMenuCustomColor(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ModShop:ShowModMenu(playerid);
    new color1, color2;
    if (sscanf(inputtext, "dd", color1, color2)) return RepairShopCustomColor(playerid);
    if (GetPlayerCash(playerid) < ModShop:FeeColor) {
        AlexaMsg(playerid, "You don't have enough money", "Garage");
        return ModShop:ShowMenuColors(playerid);
    }
    vault:PlayerVault(playerid, -ModShop:FeeColor, "vehicle color modification",
        Vault_ID_Mechanics, ModShop:FeeColor, sprintf("vehicle color modification fee from %s", GetPlayerNameEx(playerid))
    );
    new vehicleid = GetPlayerVehicleID(playerid);
    ChangeVehicleColor(vehicleid, color1, color2);
    PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
    AlexaMsg(playerid, "You have succesfully repainted your vehicle", "Garage");
    return ModShop:ShowMenuColors(playerid);
}