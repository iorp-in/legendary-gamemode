new VehicleHalloweenMode:Supported[] = { 411, 415, 451, 579, 487, 475, 522 };
new VehicleHalloweenMode:Object[MAX_VEHICLES][13] = {-1, ... };

BitCoin:OnInit(playerid, page) {
    if (page != 0 || !IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (VehicleHalloweenMode:IsVehicleSupported(vehicleid) && PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid)))
        BitCoin:AddCommand(playerid, "Vehicle > Halloween Mode (15 BTC)");
    return 1;
}

BitCoin:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page != 0) return 1;
    if (IsStringSame(inputtext, "Vehicle > Halloween Mode (15 BTC)")) {
        new vehicleid = GetPlayerVehicleID(playerid);
        new xid = PersonalVehicle:GetID(vehicleid);
        if (!VehicleHalloweenMode:IsVehicleSupported(vehicleid) || !PersonalVehicle:IsValidID(xid))
            return AlexaMsg(playerid, "this vehicle is not supported for this mod, use personal car");

        if (BitCoin:Get(playerid) < 15)
            return AlexaMsg(playerid, "you need 15 bitcoins to install this mode");

        AlexaMsg(playerid, FormatColors("~y~remember this mode will expire after ~r~two weeks"));

        PersonalVehicle:SetHalloween(xid, gettime() + (2 * 7 * 24 * 60 * 60));
        VehicleHalloweenMode:Install(vehicleid);
        BitCoin:GiveOrTake(playerid, -15, sprintf("installed halloween mode in %s with plate %s (%d)", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
        PersonalVehicle:SaveID(xid);
        return ~1;
    }
    return 1;
}

hook OnMyVehicleSpawn(xid) {
    if (PersonalVehicle:GetHalloween(xid)) VehicleHalloweenMode:Install(PersonalVehicle:GetVehicleID(xid));
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    VehicleHalloweenMode:Remove(vehicleid);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    VehicleHalloweenMode:Remove(vehicleid);
    return 1;
}

stock VehicleHalloweenMode:IsVehicleSupported(vehicleid) {
    return IsArrayContainNumber(VehicleHalloweenMode:Supported, GetVehicleModel(vehicleid));
}

stock VehicleHalloweenMode:Remove(vehicleid) {
    for (new i; i < 13; i++) {
        if (IsValidDynamicObject(VehicleHalloweenMode:Object[vehicleid][i])) DestroyDynamicObjectEx(VehicleHalloweenMode:Object[vehicleid][i]);
        VehicleHalloweenMode:Object[vehicleid][i] = -1;
    }
    return 1;
}

stock VehicleHalloweenMode:Install(vehicleid) {
    VehicleHalloweenMode:Remove(vehicleid);
    switch (GetVehicleModel(vehicleid)) {
        case 411 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(19917, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, -0.020, 1.929, -0.354, -9.999, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, -0.160, 2.004, -0.292, -40.799, 8.499, 89.299);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.160, 2.004, -0.292, -40.799, -8.499, -89.299);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, 1.528, 1.929, -0.850, -27.100, 0.000, 92.000);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, -1.528, 1.929, -0.850, -27.100, 0.000, -92.000);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][5], 0, "ROAD\nTO", 130, "Segoe Script", 90, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, -0.029, -0.299, 0.678, -89.799, 19.400, 0.000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][6], 0, "HFГГ", 130, "Comic Sans MS", 130, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, 0.001, -1.874, 0.246, 179.600, -84.999, 88.100);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(19846, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 0, 16640, "a51", "a51_vent1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, 0.000, 2.582, -0.480, 0.000, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][8] = CreateDynamicObject(1003, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][8], vehicleid, 0.000, -2.292, 0.240, 0.000, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][9] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][9], vehicleid, -1.209, -1.514, 0.268, 0.000, 29.500, 94.499);
        }
        case 415 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(2661, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][0], 0, 3214, "quarry", "Was_swr_trolleycage", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, -0.312000, 0.646000, 0.371000, -70.699997, -89.300003, -178.899002);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, -0.270000, -4.365000, -0.016000, -67.699997, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.290000, -4.365000, -0.016000, -67.699997, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(2661, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 0, 3214, "quarry", "Was_swr_trolleycage", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, 0.312000, 0.646000, 0.371000, -70.699997, 89.300003, 178.899002);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][4], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, -0.340000, -2.382000, -0.431000, -63.699001, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][5], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, 0.400000, -2.382000, -0.431000, -63.699001, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, -0.841000, 0.797000, 0.098000, 96.099998, 22.499001, 92.999001);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, 0.774000, 0.686000, 0.095000, -98.799004, 337.500000, 36.098999);
            VehicleHalloweenMode:Object[vehicleid][8] = CreateDynamicObject(2662, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][8], 0, "O", 90, "GTAWEAPON3", 140, 0, 0xCC000000, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][8], vehicleid, -0.100000, 1.909000, 0.116000, 282.000000, 0.000000, 180.199997);
        }
        case 451 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(1738, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][0], 0, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][0], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, -0.060, 2.288, -0.345, -92.199, 0.299, 0.000);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][1], 0, "N", 130, "Wingdings", 199, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, -0.000, -0.550, 0.560, -89.800, 0.000, -90.599);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][2], 0, "N", 130, "Wingdings", 199, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(2593, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 0, 16093, "a51_ext", "des_dirttrack1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, 0.070, -2.732, -0.109, 0.000, 89.699, 0.000);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][4], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, -0.080, 0.426, 0.309, -20.099, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][5], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, 0.080, 0.426, 0.309, -20.099, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][6], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, -0.080, -1.500, 0.363, 20.099, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, 0.080, -1.500, 0.363, 20.099, 0.000, 0.000);
        }
        case 579 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][0], 0, "DEAD", 140, "Comic Sans MS", 150, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, 0.046, -0.596, 1.229, -89.600, 51.100, 0.000);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][1], 0, "TRAIN", 130, "Comic Sans MS", 100, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, -0.276, -1.014, 1.226, -89.600, 67.600, 0.000);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(2662, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][2], 0, 14612, "ab_abattoir_box", "ab_bloodfloor", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.008, 1.664, 0.491, -94.099, 2.699, 4.099);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(2597, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, -0.000, 2.594, 0.007, 41.099, -89.099, -1.200);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(2985, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, 0.000, -2.021, 0.360, 0.000, 0.000, -64.400);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(2842, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][5], 0, 10840, "bigshed_sfse", "ws_corr_metal2", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, -0.520, -2.902, 0.265, 63.199, 0.000, 0.000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(2842, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][6], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, -0.512, 0.217, 1.249, -49.399, -0.699, 0.000);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(2260, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 0, 6404, "beafron1_law2", "shingledblue_la", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 1, 6404, "beafron1_law2", "shingledblue_la", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, -1.659, -1.925, -0.128, -9.899, -77.200, -89.899);
            VehicleHalloweenMode:Object[vehicleid][8] = CreateDynamicObject(2260, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][8], 0, 6404, "beafron1_law2", "shingledblue_la", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][8], 1, 6404, "beafron1_law2", "shingledblue_la", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][8], vehicleid, 1.659, -1.925, -0.128, -9.899, 77.200, 90.599);
        }
        case 487 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][0], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, 1.061000, -1.780000, 0.400000, 0.000000, 0.000000, 341.199005);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(19848, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, 1.061000, 1.041000, -1.040000, 0.000000, 0.000000, 180.000000);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][2], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.300000, 0.040000, 1.370000, 90.000000, 0.000000, 90.000000);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(3790, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, -1.020000, 0.161000, 1.400000, 0.000000, 0.000000, -90.000000);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][4], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, -0.300000, 0.040000, 1.370000, 90.000000, 0.000000, -90.000000);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(19848, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, -1.061000, 1.041000, -1.040000, 0.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(3790, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][6], 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, 1.020000, 0.161000, 1.400000, 0.000000, 0.000000, 270.000000);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, 0.359000, -1.571000, 0.389000, 90.000000, 0.000000, 71.400002);
            VehicleHalloweenMode:Object[vehicleid][8] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][8], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][8], vehicleid, -1.056000, -1.780000, 0.400000, 0.000000, 0.000000, -161.199005);
            VehicleHalloweenMode:Object[vehicleid][9] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][9], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][9], vehicleid, 1.061000, -1.780000, 0.400000, 0.000000, 0.000000, 341.199005);
            VehicleHalloweenMode:Object[vehicleid][10] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][10], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][10], vehicleid, -0.359000, -1.571000, 0.389000, 90.000000, 0.000000, -71.400002);
            VehicleHalloweenMode:Object[vehicleid][11] = CreateDynamicObject(19294, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][11], vehicleid, 0.776600, -6.836300, 0.000000, 0.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][12] = CreateDynamicObject(19294, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][12], vehicleid, 0.776600, 6.836300, 0.000000, 0.000000, 0.000000, 0.000000);
        }
        case 475 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][0], 1, 2772, "airp_prop", "cj_chromepipe", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, 0.047000, 1.671000, -0.356000, 300.000000, 0.000000, 90.000000);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(2660, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(VehicleHalloweenMode:Object[vehicleid][1], 0, "O", 60, "GTAWEAPON3", 140, 0, 0xFF000000, 0, 1);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, 0.130000, -0.320000, 0.710000, 270.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(19587, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][2], 0, 16098, "des_boneyard", "Was_meshfence", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, 0.000000, 0.565000, 0.448000, -31.700001, 180.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 1, 2772, "airp_prop", "cj_chromepipe", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, -0.047000, 1.671000, -0.356000, 300.000000, 0.000000, -90.000000);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(19917, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][4], 0, 65535, "none", "none", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, 0.000000, 1.623000, -0.247000, -3.799000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][5] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][5], vehicleid, -0.610000, 0.150000, 0.709000, 270.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][6] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][6], vehicleid, 0.610000, 0.150000, 0.709000, 270.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][7] = CreateDynamicObject(2501, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][7], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][7], vehicleid, 0.000000, 2.580000, 0.000000, 270.000000, 90.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][8] = CreateDynamicObject(16732, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][8], 0, 1413, "break_f_mesh", "CJ_CORRIGATED", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][8], vehicleid, -0.390000, -0.030000, -0.610000, 270.000000, 0.000000, 0.000000);
            VehicleHalloweenMode:Object[vehicleid][9] = CreateDynamicObject(16732, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][9], 0, 1413, "break_f_mesh", "CJ_CORRIGATED", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][9], vehicleid, 0.390000, -0.030000, -0.610000, 270.000000, 0.000000, 0.000000);
        }
        case 522 :  {
            VehicleHalloweenMode:Object[vehicleid][0] = CreateDynamicObject(2891, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][0], 0, 19624, "case1", "cj_case_brown", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][0], vehicleid, -0.106000, 0.057000, 0.280000, 0.000000, 0.000000, 22.900000);
            VehicleHalloweenMode:Object[vehicleid][1] = CreateDynamicObject(2891, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][1], 0, 19624, "case1", "cj_case_brown", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][1], vehicleid, 0.106000, 0.057000, 0.280000, 0.000000, 0.000000, -22.900000);
            VehicleHalloweenMode:Object[vehicleid][2] = CreateDynamicObject(2495, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][2], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][2], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][2], vehicleid, -0.262000, 0.141000, -0.054000, -98.099998, -21.000000, 58.799000);
            VehicleHalloweenMode:Object[vehicleid][3] = CreateDynamicObject(2495, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(VehicleHalloweenMode:Object[vehicleid][3], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][3], vehicleid, 0.262000, 0.182000, -0.096000, -105.698997, 0.000000, -78.698997);
            VehicleHalloweenMode:Object[vehicleid][4] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(VehicleHalloweenMode:Object[vehicleid][4], vehicleid, 0.410000, 0.011000, 0.344000, 0.000000, 27.799000, 90.000000);
        }
    }
    return 1;
}