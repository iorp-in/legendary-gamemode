new AllowedTrunkWeapons[] = { 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 };

stock VTrunk:GetWeapon(xVehicleID, weaponid) {
    if (!PersonalVehicle:IsValidID(xVehicleID)) return 0;
    if (weaponid == 22) return VTrunk:GetInt("WEAPON_COLT45", xVehicleID);
    if (weaponid == 23) return VTrunk:GetInt("WEAPON_SILENCED", xVehicleID);
    if (weaponid == 24) return VTrunk:GetInt("WEAPON_DEAGLE", xVehicleID);
    if (weaponid == 25) return VTrunk:GetInt("WEAPON_SHOTGUN", xVehicleID);
    if (weaponid == 26) return VTrunk:GetInt("WEAPON_SAWEDOFF", xVehicleID);
    if (weaponid == 27) return VTrunk:GetInt("WEAPON_SHOTGSPA", xVehicleID);
    if (weaponid == 28) return VTrunk:GetInt("WEAPON_UZI", xVehicleID);
    if (weaponid == 29) return VTrunk:GetInt("WEAPON_MP5", xVehicleID);
    if (weaponid == 30) return VTrunk:GetInt("WEAPON_AK47", xVehicleID);
    if (weaponid == 31) return VTrunk:GetInt("WEAPON_M4", xVehicleID);
    if (weaponid == 32) return VTrunk:GetInt("WEAPON_TEC9", xVehicleID);
    if (weaponid == 33) return VTrunk:GetInt("WEAPON_RIFLE", xVehicleID);
    if (weaponid == 34) return VTrunk:GetInt("WEAPON_SNIPER", xVehicleID);
    if (weaponid == 35) return VTrunk:GetInt("WEAPON_ROCKETLAUNCHER", xVehicleID);
    if (weaponid == 36) return VTrunk:GetInt("WEAPON_HEATSEEKER", xVehicleID);
    if (weaponid == 37) return VTrunk:GetInt("WEAPON_FLAMETHROWER", xVehicleID);
    return 0;
}

stock VTrunk:StoreWeapon(xVehicleID, weaponid, ammo) {
    if (!PersonalVehicle:IsValidID(xVehicleID)) return 0;

    if (weaponid == 22) return VTrunk:UpdateInt("WEAPON_COLT45", xVehicleID, ammo);
    if (weaponid == 23) return VTrunk:UpdateInt("WEAPON_SILENCED", xVehicleID, ammo);
    if (weaponid == 24) return VTrunk:UpdateInt("WEAPON_DEAGLE", xVehicleID, ammo);
    if (weaponid == 25) return VTrunk:UpdateInt("WEAPON_SHOTGUN", xVehicleID, ammo);
    if (weaponid == 26) return VTrunk:UpdateInt("WEAPON_SAWEDOFF", xVehicleID, ammo);
    if (weaponid == 27) return VTrunk:UpdateInt("WEAPON_SHOTGSPA", xVehicleID, ammo);
    if (weaponid == 28) return VTrunk:UpdateInt("WEAPON_UZI", xVehicleID, ammo);
    if (weaponid == 29) return VTrunk:UpdateInt("WEAPON_MP5", xVehicleID, ammo);
    if (weaponid == 30) return VTrunk:UpdateInt("WEAPON_AK47", xVehicleID, ammo);
    if (weaponid == 31) return VTrunk:UpdateInt("WEAPON_M4", xVehicleID, ammo);
    if (weaponid == 32) return VTrunk:UpdateInt("WEAPON_TEC9", xVehicleID, ammo);
    if (weaponid == 33) return VTrunk:UpdateInt("WEAPON_RIFLE", xVehicleID, ammo);
    if (weaponid == 34) return VTrunk:UpdateInt("WEAPON_SNIPER", xVehicleID, ammo);
    if (weaponid == 35) return VTrunk:UpdateInt("WEAPON_ROCKETLAUNCHER", xVehicleID, ammo);
    if (weaponid == 36) return VTrunk:UpdateInt("WEAPON_HEATSEEKER", xVehicleID, ammo);
    if (weaponid == 37) return VTrunk:UpdateInt("WEAPON_FLAMETHROWER", xVehicleID, ammo);
    return 0;
}

VTrunk:OnInit(playerid, xVehicleID, page) {
    if (page != 0) return 1;
    VTrunk:AddCommand(playerid, "Put Guns");
    VTrunk:AddCommand(playerid, "Take Guns");
    return 1;
}

VTrunk:OnResponse(playerid, xVehicleID, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    new vehicleid = PersonalVehicle:GetVehicleID(xVehicleID);
    if (!IsValidVehicle(vehicleid)) return 1;
    if (IsStringSame("Put Guns", inputtext)) {
        VTrunk:PutGun(playerid, xVehicleID);
        return ~1;
    }
    if (IsStringSame("Take Guns", inputtext)) {
        VTrunk:TakeGun(playerid, xVehicleID);
        return ~1;
    }
    return 1;
}

stock VTrunk:IsWeaponAllowed(weaponid) {
    return IsArrayContainNumber(AllowedTrunkWeapons, weaponid);
}

stock VTrunk:PutGun(playerid, xVehicleID) {
    new weaponid = GetPlayerWeapon(playerid), weaponammo = GetPlayerAmmo(playerid);
    if (!VTrunk:IsWeaponAllowed(weaponid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} trunk can not store your current weapon.");
    if (weaponammo < 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you don't have enough ammo to store in vehicle");
    return FlexPlayerDialog(playerid, "VTrunkPutGun", DIALOG_STYLE_INPUT, "Put Weapon in Trunk", sprintf("Enter ammo of %s weapon to store", GetWeaponNameEx(weaponid)), "Store", "Close", xVehicleID);
}

FlexDialog:VTrunkPutGun(playerid, response, listitem, const inputtext[], xVehicleID, const payload[]) {
    if (!response) return 1;
    new weaponid = GetPlayerWeapon(playerid), weaponammo = GetPlayerAmmo(playerid);
    if (!VTrunk:IsWeaponAllowed(weaponid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} trunk can not store your current weapon.");
    if (weaponammo < 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you don't have enough ammo to store in vehicle");
    new vehicleid = PersonalVehicle:GetVehicleID(xVehicleID);
    if (!IsValidVehicle(vehicleid)) return 1;
    new ammo = 0, trunkammo = VTrunk:GetWeapon(xVehicleID, weaponid);
    if (sscanf(inputtext, "d", ammo) || ammo < 1 || ammo > weaponammo || ammo + trunkammo > 5000) return VTrunk:PutGun(playerid, xVehicleID);
    GivePlayerWeaponEx(playerid, weaponid, -ammo);
    VTrunk:StoreWeapon(xVehicleID, weaponid, trunkammo + ammo);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have stored %d ammo of %s weapon into this vehicle trunk", ammo, GetWeaponNameEx(weaponid)));
    return 1;
}

stock VTrunk:TakeGun(playerid, xVehicleID) {
    new vehicleid = PersonalVehicle:GetVehicleID(xVehicleID);
    if (!IsValidVehicle(vehicleid)) return 1;
    new string[1024];
    strcat(string, "Weapon ID\tWeapon Name\tWeapon Ammo\n");
    strcat(string, sprintf("22\tCOLT45\t%d\n", VTrunk:GetWeapon(xVehicleID, 22)));
    strcat(string, sprintf("23\tSILENCED\t%d\n", VTrunk:GetWeapon(xVehicleID, 23)));
    strcat(string, sprintf("24\tDEAGLE\t%d\n", VTrunk:GetWeapon(xVehicleID, 24)));
    strcat(string, sprintf("25\tSHOTGUN\t%d\n", VTrunk:GetWeapon(xVehicleID, 25)));
    strcat(string, sprintf("26\tSAWEDOFF\t%d\n", VTrunk:GetWeapon(xVehicleID, 26)));
    strcat(string, sprintf("27\tSHOTGSPA\t%d\n", VTrunk:GetWeapon(xVehicleID, 27)));
    strcat(string, sprintf("28\tUZI\t%d\n", VTrunk:GetWeapon(xVehicleID, 28)));
    strcat(string, sprintf("29\tMP5\t%d\n", VTrunk:GetWeapon(xVehicleID, 29)));
    strcat(string, sprintf("30\tAK47\t%d\n", VTrunk:GetWeapon(xVehicleID, 30)));
    strcat(string, sprintf("31\tM4\t%d\n", VTrunk:GetWeapon(xVehicleID, 31)));
    strcat(string, sprintf("32\tTEC9\t%d\n", VTrunk:GetWeapon(xVehicleID, 32)));
    strcat(string, sprintf("33\tRIFLE\t%d\n", VTrunk:GetWeapon(xVehicleID, 33)));
    strcat(string, sprintf("34\tSNIPER\t%d\n", VTrunk:GetWeapon(xVehicleID, 34)));
    strcat(string, sprintf("35\tROCKETLAUNCHER\t%d\n", VTrunk:GetWeapon(xVehicleID, 35)));
    strcat(string, sprintf("36\tHEATSEEKER\t%d\n", VTrunk:GetWeapon(xVehicleID, 36)));
    strcat(string, sprintf("37\tFLAMETHROWER\t%d\n", VTrunk:GetWeapon(xVehicleID, 37)));
    return FlexPlayerDialog(playerid, "VTrunkTakeGun", DIALOG_STYLE_TABLIST_HEADERS, "Take Weapon from Trunk", string, "Take", "Close", xVehicleID);
}

FlexDialog:VTrunkTakeGun(playerid, response, listitem, const inputtext[], xVehicleID, const payload[]) {
    if (!response) return 1;
    new vehicleid = PersonalVehicle:GetVehicleID(xVehicleID);
    if (!IsValidVehicle(vehicleid)) return 1;
    new weaponid = strval(inputtext);
    new trunkammo = VTrunk:GetWeapon(xVehicleID, weaponid);
    if (trunkammo < 1) return SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} trunk does not have any ammo for %s weapon", GetWeaponNameEx(weaponid)));
    return VTrunk:TakeGunAmmo(playerid, xVehicleID, weaponid, trunkammo);
}

stock VTrunk:TakeGunAmmo(playerid, xVehicleID, weaponid, trunkammo) {
    return FlexPlayerDialog(
        playerid, "VTrunkTakeGunAmmo", DIALOG_STYLE_INPUT, "Put Weapon in Trunk",
        sprintf("Enter ammo of %s weapon to take\nAmmo Available to take: %d", GetWeaponNameEx(weaponid), trunkammo),
        "Take", "Close", xVehicleID, sprintf("%d", weaponid)
    );
}

FlexDialog:VTrunkTakeGunAmmo(playerid, response, listitem, const inputtext[], xVehicleID, const payload[]) {
    if (!response) return 1;
    new weaponid = strval(payload), ammo = 0;
    new trunkammo = VTrunk:GetWeapon(xVehicleID, weaponid);
    if (sscanf(inputtext, "d", ammo) || ammo < 1 || ammo > trunkammo) return VTrunk:TakeGunAmmo(playerid, xVehicleID, weaponid, trunkammo);
    GivePlayerWeaponEx(playerid, weaponid, ammo);
    VTrunk:StoreWeapon(xVehicleID, weaponid, trunkammo - ammo);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have took %d ammo of %s weapon from this vehicle trunk", ammo, GetWeaponNameEx(weaponid)));
    return 1;
}