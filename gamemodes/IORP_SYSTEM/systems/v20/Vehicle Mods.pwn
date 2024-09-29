hook OnVehicleDestroyed(vehicleid) {
    RemoveTwinTurboText(vehicleid);
    RemoveSupreme(vehicleid);
    RemoveBikesMod(vehicleid);
    RemoveFutureMod(vehicleid);
    RemoveTaxiMod(vehicleid);
    RemoveHalloweenMod(vehicleid);
    RemoveLaunchMod(vehicleid);
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    RemoveTwinTurboText(vehicleid);
    RemoveSupreme(vehicleid);
    RemoveBikesMod(vehicleid);
    RemoveFutureMod(vehicleid);
    RemoveTaxiMod(vehicleid);
    RemoveHalloweenMod(vehicleid);
    RemoveLaunchMod(vehicleid);
    return 1;
}

cmd:installmod1(playerid, const params[]) { // twin turbo
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    TwinTurboText(GetPlayerVehicleID(playerid));
    return 1;
}

cmd:installmod2(playerid, const params[]) { // supreme
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    SupremeInstall(GetPlayerVehicleID(playerid), params);
    return 1;
}

cmd:installmod3(playerid, const params[]) { // bike
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    Install_BikesMod(GetPlayerVehicleID(playerid));
    return 1;
}

cmd:installmod4(playerid, const params[]) { // future
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    install_future_mod(GetPlayerVehicleID(playerid));
    return 1;
}

cmd:installmod5(playerid, const params[]) { // future
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    install_taxi_mod(GetPlayerVehicleID(playerid));
    return 1;
}

cmd:installmod6(playerid, const params[]) { // future
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    install_halloween_mod(GetPlayerVehicleID(playerid));
    return 1;
}

cmd:installmod7(playerid, const params[]) { // future
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    install_launch_mod(GetPlayerVehicleID(playerid));
    return 1;
}

new BikeInstallObject[MAX_VEHICLES][5] = {-1, ... };
stock RemoveBikesMod(vehicleid) {
    if (IsValidDynamicObject(BikeInstallObject[vehicleid][0])) DestroyDynamicObjectEx(BikeInstallObject[vehicleid][0]);
    if (IsValidDynamicObject(BikeInstallObject[vehicleid][1])) DestroyDynamicObjectEx(BikeInstallObject[vehicleid][1]);
    if (IsValidDynamicObject(BikeInstallObject[vehicleid][2])) DestroyDynamicObjectEx(BikeInstallObject[vehicleid][2]);
    if (IsValidDynamicObject(BikeInstallObject[vehicleid][3])) DestroyDynamicObjectEx(BikeInstallObject[vehicleid][3]);
    if (IsValidDynamicObject(BikeInstallObject[vehicleid][4])) DestroyDynamicObjectEx(BikeInstallObject[vehicleid][4]);
    return 1;
}

stock Install_BikesMod(vehicleid) {
    RemoveBikesMod(vehicleid);
    BikeInstallObject[vehicleid][0] = CreateDynamicObject(1112, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1); // Крылья
    BikeInstallObject[vehicleid][1] = CreateDynamicObject(1112, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1); // Крылья
    BikeInstallObject[vehicleid][2] = CreateDynamicObject(1254, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1); // Череп
    BikeInstallObject[vehicleid][3] = CreateDynamicObject(1575, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1); // Мешки 1575
    BikeInstallObject[vehicleid][4] = CreateDynamicObject(1575, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1); // Мешки 1575

    switch (GetVehicleModel(vehicleid)) {
        case 461 :  {
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][0], vehicleid, 0.189, 0.299, 0.184, 3.900, 92.700, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][1], vehicleid, -0.160, 0.328, 0.363, 0.000, -79.999, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][2], vehicleid, 0.000, 0.058, 0.469, -82.400, 0.000, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][3], vehicleid, 0.112, -0.909, 0.193, 0.000, 79.600, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][4], vehicleid, -0.109, -0.900, 0.236, 1.999, -82.599, 7.399);
            return 1;
        }
        case 463 :  {
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][0], vehicleid, -0.186, 0.327, 0.437, 9.599, -83.300, 20.399);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][1], vehicleid, 0.179, 0.369, 0.294, 10.600, 105.300, -14.499);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][2], vehicleid, 0.000, 0.095, 0.374, -54.299, 0.000, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][3], vehicleid, -0.136, -0.939, 0.116, 0.000, -49.500, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][4], vehicleid, 0.122, -0.899, 0.090, 4.499, 66.999, 0.000);
            return 1;
        }
        case 521 :  {
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][0], vehicleid, -0.190, 0.297, 0.499, 0.100, -90.299, 11.799);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][1], vehicleid, 0.135, 0.318, 0.409, 0.000, 107.399, -4.199);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][2], vehicleid, 0.000, -0.825, 0.477, -90.199, 0.000, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][3], vehicleid, -0.153, -0.830, 0.279, 0.000, -74.699, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][4], vehicleid, 0.188, -0.770, 0.300, 0.000, 77.099, 0.000);
            return 1;
        }
        case 522 :  {
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][0], vehicleid, -0.170, 0.330, 0.538, 2.500, -87.999, 6.899);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][1], vehicleid, 0.182, 0.337, 0.422, -0.499, 96.799, -11.199);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][2], vehicleid, 0.199, 0.249, -0.001, 7.399, 0.000, 91.200);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][3], vehicleid, 0.106, -0.900, 0.386, 0.000, 71.899, 0.000);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][4], vehicleid, -0.122, -0.840, 0.380, 0.000, -65.900, 0.000);
            return 1;
        }
        case 468 :  {
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][0]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][1]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][2]);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][3], vehicleid, 0.248, -0.826, 0.190, -90.499, -92.200, -4.999);
            AttachDynamicObjectToVehicle(BikeInstallObject[vehicleid][4], vehicleid, -0.276, -0.840, 0.197, 97.699, 0.000, 93.900);
            return 1;
        }
        default:  {
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][0]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][1]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][2]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][3]);
            DestroyDynamicObjectEx(BikeInstallObject[vehicleid][4]);
        }
    }
    return true;
}

new TwinTruboObject[MAX_VEHICLES][2] = {-1, ... };

stock RemoveTwinTurboText(vehicleid) {
    if (IsValidDynamicObject(TwinTruboObject[vehicleid][0])) DestroyDynamicObjectEx(TwinTruboObject[vehicleid][0]);
    if (IsValidDynamicObject(TwinTruboObject[vehicleid][1])) DestroyDynamicObjectEx(TwinTruboObject[vehicleid][1]);
    return 1;
}

stock TwinTurboText(vehicleid) {
    RemoveTwinTurboText(vehicleid);
    new twin, twin1;
    twin = CreateDynamicObject(19327, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    SetDynamicObjectMaterialText(twin, 0, "{ff5d49}/{f34f3e}/{f7372b}/", 140, "Ariel", 40, 1, 0, 0, 1);

    twin1 = CreateDynamicObject(19327, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    SetDynamicObjectMaterialText(twin1, 0, "{FFFFFF}TWINTURBO{FAAC58} PACKAGE", 130, "Ariel", 20, 1, 0, 0, 1);

    TwinTruboObject[vehicleid][0] = twin;
    TwinTruboObject[vehicleid][1] = twin1;

    switch (GetVehicleModel(vehicleid)) {
        case 400 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.435, -2.343, -0.137, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -2.344, -0.137, 0.000, 0.000, 0.000);
        }
        case 401 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -2.110, 0.334, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -2.111, 0.339, -90.000, 0.000, 0.000);
        }
        case 402 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.339, 0.266, -81.300, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.344, 0.266, -80.800, 0.000, 0.000);
        }
        case 404 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.405, 0.571, -25.300, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.428, 0.576, -26.700, 0.000, 0.000);
        }
        case 405 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.243, 0.253, -85.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -2.249, 0.258, -90.000, 0.000, 0.000);
        }
        case 409 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -3.380, 0.284, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -3.383, 0.284, -90.000, 0.000, 0.000);
        }
        case 410 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.400, -1.899, 0.363, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.130, -1.900, 0.360, -90.000, 0.000, 0.000);
        }
        case 411 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -1.376, 0.363, -59.300, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -1.380, 0.364, -60.000, 0.000, 0.000);
        }
        case 412 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, 0.913, -3.161, 0.153, -90.000, -90.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.919, -2.630, 0.162, -90.000, -90.000, 0.000);
        }
        case 413 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -2.626, -0.658, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.130, -2.619, -0.660, 0.000, 0.000, 0.000);
        }
        case 415 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.450, -1.062, 0.397, -21.400, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.060, -1.067, 0.390, -24.799, 0.000, 0.000);
        }
        case 418 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -2.673, -0.630, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -2.674, -0.630, 0.000, 0.000, 0.000);
        }
        case 419 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -1.605, 0.440, -48.299, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -1.604, 0.439, -48.200, 0.000, 0.000);
        }
        case 421 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -2.773, 0.088, -33.700, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.080, -2.780, 0.086, -34.999, 0.000, 0.000);
        }
        case 422 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -0.320, 0.470, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.080, -0.330, 0.470, 0.000, 0.000, 0.000);
        }
        case 426 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.390, -2.389, 0.270, -85.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.130, -2.390, 0.269, -84.100, 0.000, 0.000);
        }
        case 429 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -1.331, 0.370, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.080, -1.331, 0.370, 0.000, 0.000, 0.000);
        }
        case 434 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -1.180, 0.690, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -1.171, 0.690, 0.000, 0.000, 0.000);
        }
        case 436 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.429, -1.627, 0.467, -45.599, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -1.633, 0.471, -41.800, 0.000, 0.000);
        }
        case 439 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -2.178, 0.242, -82.600, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.120, -2.188, 0.244, -82.900, 0.000, 0.000);
        }
        case 445 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -2.432, 0.235, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.120, -2.440, 0.240, -90.000, 0.000, 0.000);
        }
        case 451 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -1.172, 0.487, -78.299, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -1.178, 0.500, -77.399, 0.000, 0.000);
        }
        case 458 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -2.862, 0.070, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.862, 0.070, 0.000, 0.000, 0.000);
        }
        case 466 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -2.153, 0.270, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.160, 0.280, -90.000, 0.000, 0.000);
        }
        case 467 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.449, -2.160, 0.280, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.080, -2.161, 0.280, -90.000, 0.000, 0.000);
        }
        case 474 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.400, -2.916, -0.187, 5.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.120, -2.921, -0.190, 0.000, 0.000, 0.000);
        }
        case 475 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.764, 0.005, -31.800, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -2.761, 0.000, -27.100, 0.000, 0.000);
        }
        case 477 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.380, -1.883, 0.433, -71.599, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.140, -1.881, 0.436, -72.199, 0.000, 0.000);
        }
        case 478 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -0.310, 0.600, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -0.320, 0.600, 0.000, 0.000, 0.000);
        }
        case 479 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.811, 0.000, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -2.812, 0.000, 0.000, 0.000, 0.000);
        }
        case 480 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -1.120, 0.420, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.060, -1.131, 0.420, 0.000, 0.000, 0.000);
        }
        case 482 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.370, -2.710, -0.590, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.160, -2.732, -0.590, 0.000, 0.000, 0.000);
        }
        case 489 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -2.678, 0.330, -24.800, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.120, -2.676, 0.327, -24.500, 0.000, 0.000);
        }
        case 491 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.380, -2.199, 0.260, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.150, -2.204, 0.260, -90.000, 0.000, 0.000);
        }
        case 492 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.450, -1.783, 0.584, -30.500, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -1.800, 0.582, -29.699, 0.000, 0.000);
        }
        case 494 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -1.775, 0.457, -57.599, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.110, -1.780, 0.456, -57.599, 0.000, 0.000);
        }
        case 495 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.450, -2.091, 0.607, -21.800, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -2.114, 0.613, -19.199, 0.000, 0.000);
        }
        case 496 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.440, -1.790, 0.564, -73.199, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -1.792, 0.563, -71.999, 0.000, 0.000);
        }
        case 500 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, 0.920, -1.600, 0.020, 0.000, 0.000, 90.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.920, -1.070, 0.020, 0.000, 0.000, 90.000);
        }
        case 502 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -1.596, 0.478, -59.099, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.109, -1.598, 0.482, -58.600, 0.000, 0.000);
        }
        case 503 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.450, -1.585, 0.509, -27.499, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.070, -1.602, 0.509, -26.499, 0.000, 0.000);
        }
        case 506 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.412, -2.518, -0.290, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.109, -2.523, -0.289, 5.199, 0.000, 0.000);
        }
        case 533 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -2.151, 0.290, -90.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.161, 0.290, -90.000, 0.000, 0.000);
        }
        case 541 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -1.711, 0.385, -77.699, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.090, -1.710, 0.380, -78.000, 0.000, 0.000);
        }
        case 559 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.450, -1.509, 0.545, -76.799, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -1.520, 0.550, -75.000, 0.000, 0.000);
        }
        case 560 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.410, -1.518, 0.482, -61.800, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.120, -1.521, 0.485, -61.600, 0.000, 0.000);
        }
        case 562 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.420, -1.399, 0.503, -59.500, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -1.399, 0.500, -58.600, 0.000, 0.000);
        }
        case 565 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.430, -2.120, -0.176, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.100, -2.120, -0.180, 0.000, 0.000, 0.000);
        }
        case 579 :  {
            AttachDynamicObjectToVehicle(twin, vehicleid, -0.210, -2.840, 0.140, 0.000, 0.000, 0.000);
            AttachDynamicObjectToVehicle(twin1, vehicleid, 0.330, -2.831, 0.130, 0.000, 0.000, 0.000);
        }
        default:  {
            DestroyDynamicObjectEx(twin);
            DestroyDynamicObjectEx(twin1);
        }
    }
    return true;
}

new SupremeObject[MAX_VEHICLES] = {-1, ... };
stock RemoveSupreme(vehicleid) {
    if (IsValidDynamicObject(SupremeObject[vehicleid])) DestroyDynamicObjectEx(SupremeObject[vehicleid]);
    return 1;
}
stock SupremeInstall(vehicleid, const text[]) {
    RemoveSupreme(vehicleid);
    SupremeObject[vehicleid] = CreateDynamicObject(19476, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0);
    SetDynamicObjectMaterial(SupremeObject[vehicleid], 0, 3031, "wngdishx", "metal_leg", 0);
    SetDynamicObjectMaterial(SupremeObject[vehicleid], 1, 4552, "ammu_lan2", "newall4-4", 0);
    SetDynamicObjectMaterialText(SupremeObject[vehicleid], 0, text, 80, "Arial", 60, 1, -1, -65536, 1);

    switch (GetVehicleModel(vehicleid)) {
        case 451 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.002, -1.608, 0.369, -0.199, -68.999, -90.200);
        }
        case 490 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000095, -3.002873, 0.611099, 0.200000, -21.499990, -90.000000); //id vehicle:490
        }
        case 424 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.001187, 1.117468, 0.293685, -0.499999, -107.099975, -90.302452); //id vehicle:424
        }
        case 427 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 1.168139, -3.277455, 0.481842, 0.399999, 0.000000, 0.186294); //id vehicle:427
        }
        case 487 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.703163, -1.462407, 0.439449, -0.499999, -1.000000, -161.300003);
        }
        case 497 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.703163, -1.462407, 0.439449, -0.499999, -1.000000, -161.300003);
        }
        case 402 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.011, -1.695, 0.475, 0.000, -70.099, -89.699);
        }
        case 477 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000, -1.570, 0.540, 0.000, -74.399, -90.900);
        }
        case 411 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.003, -1.980, 0.243, 0.000, -91.299, -89.500);
        }
        case 541 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.008, -1.030, 0.514, 0.000, -79.699, -89.600);
        }
        case 445 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -1.691, 0.547, 37.299, 0.000, 0.000);
        }
        case 470 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.000111, -1.537731, 0.740984, -0.700000, -18.800037, -449.199890);
        }
        case 496 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.001707, -1.509199, 0.655676, -0.700000, -74.299995, -449.199890);
        }
        case 500 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000700, -1.745548, 0.667159, -0.700000, -23.400018, -449.199890);
        }
        case 419 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000, -1.990, 0.231, 3.699, 0.000, 0.000);
        }
        case 495 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.017, -2.085, 0.656, 0.000, -22.200, -89.299);
        }
        case 506 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -1.607, 0.376, 16.799, 0.000, 0.000);
        }
        case 559 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.005, -1.535, 0.556, 0.000, -77.099, -90.100);
        }
        case 560 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.000, -1.334, 0.588, 0.000, -62.699, -90.400);
        }
        case 434 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -1.973, -0.056, 69.400, 0.000, 0.000);
        }
        case 421 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -1.667, 0.463, 35.700, 0.000, 0.000);
        }
        case 533 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000, -2.411, 0.260, 0.000, 0.000, 0.000);
        }
        case 400 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.030, -2.220, 0.416, 65.099, 0.000, 0.000);
        }
        case 429 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.008, -1.890, 0.330, 0.000, -88.199, -90.399);
        }
        case 503 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -2.332, 0.274, 7.399, 0.000, 0.000);
        }
        case 502 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.020, -1.778, 0.382, 31.199, 0.000, 0.000);
        }
        case 579 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.002, -2.637, 0.876, 0.000, -29.400, -90.599);
        }
        case 489 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.042, -2.520, 0.695, 0.000, -28.199, -90.199);
        }
        case 547 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.016, -1.621, 0.619, 0.000, -47.799, -90.900);
        }
        case 527 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.048, -1.456, 0.584, 0.000, -66.099, -90.799);
        }
        case 526 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.033, -1.438, 0.407, 0.000, -67.799, -90.800);
        }
        case 412 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.020, -2.641, 0.159, 0.000, -90.599, -91.699);
        }
        case 542 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.035, -2.572, 0.356, 0.000, -79.399, -90.399);
        }
        case 404 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.024, -2.438, 0.611, 0.000, -27.099, -91.300);
        }
        case 444 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.000320, -0.476852, 1.350025, 0.000000, -7.499994, -90.000122);
        }
        case 494 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.000441, -2.401596, 0.278745, 0.000000, -87.999855, -89.999877);
        }
        case 562 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.001079, -1.840155, 0.379246, 0.000000, -86.900001, -90.000000);
        }
        case 573 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.000361, 1.999963, 1.479729, 0.000000, -90.300041, -90.000122);
        }
        case 480 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.000451, -1.579495, 0.261494, 0.000000, -89.499984, -90.000000);
        }
        case 415 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, -0.008822, -1.066270, 0.404319, 0.000000, -23.000015, -89.200271);
        }
        case 409 :  {
            AttachDynamicObjectToVehicle(SupremeObject[vehicleid], vehicleid, 0.025850, -3.212843, 0.286698, 0.000000, -89.400024, -89.200180);
        }
        default:  {

        }
    }
    return SupremeObject[vehicleid];
}

stock GetLaunchColor(vehicleid) {
    if (GetVehicleModel(vehicleid) == 411) return 0xFF000000;
    return 0xFF000000;
}

new LaunchObject[MAX_VEHICLES][9];
stock RemoveLaunchMod(vehicleid) {
    for (new i; i < 9; i++) {
        if (IsValidDynamicObject(LaunchObject[vehicleid][i])) DestroyDynamicObjectEx(LaunchObject[vehicleid][i]);
    }
    return 1;
}

stock install_launch_mod(vehicleid) {
    RemoveLaunchMod(vehicleid);
    switch (GetVehicleModel(vehicleid)) {
        case 411 :  //инфа лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "77", 130, "Impact", 190, 1, 0xFF7C1300, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.000000, -0.160000, 0.674000, 0.000000, -90.899002, 90.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19475, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "RED LINE", 140, "Impact", 120, 0, 0xFF7C1300, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 1.038000, -0.930000, -0.487000, 0.000000, 2.799000, 0.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, -1.020200, 1.509120, 0.030710, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][3], 0, "=", 130, "Ariel", 190, 1, 0xFF7C1300, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 0.000000, -1.919000, 0.237000, 5.899000, 90.000000, 0.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "=", 100, "Ariel", 199, 1, 0xFF7C1300, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, 0.000000, 2.055000, 0.123000, -10.900000, 90.000000, 0.099000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, 1.151300, 1.509100, 0.048100, 0.000000, 0.000000, 0.000000);

        }
        case 541 :  //булет лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "9", 140, "Impact", 180, 1, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.020, -0.202, 0.602, -87.599, -179.799, 0.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "g", 140, "Wingdings", 40, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, -0.858, -0.930, 0.323, 0.000, 33.699, 0.000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, "GT", 140, "Impact", 70, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000, -1.673, 0.380, -78.700, 0.000, 0.000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][3], 0, "5000", 140, "Engravers MT", 30, 1, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 0.000, -1.780, 0.368, -75.799, 0.000, 0.000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "5000", 140, "Engravers MT", 30, 1, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, -0.970, 1.012, 0.000, 0.000, 0.000, 3.299);
            LaunchObject[vehicleid][6] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, 1.091, 1.004, 0.000, 0.000, 0.000, -3.299);
        }
        case 451 :  //турик лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(2771, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); //
            SetDynamicObjectMaterial(LaunchObject[vehicleid][0], 2, 10023, "bigwhitesfe", "bigwhite_6", 0);
            SetDynamicObjectMaterial(LaunchObject[vehicleid][0], 1, 3440, "airportpillar", "metalic_64", 0);
            SetDynamicObjectMaterial(LaunchObject[vehicleid][0], 0, 19655, "mattubes", "reddirt1", GetLaunchColor(vehicleid)); // тут заменить цвет
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.280000, -1.440000, 0.459000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "69", 130, "Impact", 190, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 0.000000, -0.550000, 0.549000, 0.000000, 90.499001, 90.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19917, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, -0.040000, -1.420000, 0.249000, 0.000000, 180.000000, 90.000000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, -0.943000, 1.052000, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(2771, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 3
            SetDynamicObjectMaterial(LaunchObject[vehicleid][4], 2, 10023, "bigwhitesfe", "bigwhite_6", 0);
            SetDynamicObjectMaterial(LaunchObject[vehicleid][4], 1, 3440, "airportpillar", "metalic_64", 0);
            SetDynamicObjectMaterial(LaunchObject[vehicleid][4], 0, 19655, "mattubes", "reddirt1", GetLaunchColor(vehicleid)); // тут заменить цвет
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -0.310000, -1.430000, 0.469000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(19475, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][5], 0, "GTF 120", 140, "Impact", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, -1.006000, -0.929000, 0.000000, 0.000000, -2.399000, 180.000000);
            LaunchObject[vehicleid][6] = CreateDynamicObject(19475, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][6], 0, "GTF 120", 140, "Impact", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, 1.009000, -0.919000, 0.000000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][7] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][7], vehicleid, 1.073100, 1.052000, 0.001000, 0.000000, 0.000000, 0.000000);
        }
        case 603 :  // феникс лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "%", 130, "GTAWEAPON3", 120, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.000, -1.441, 0.480, -73.000, 0.000, 0.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19482, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, ".", 90, "Courier New", 199, 1, -56320, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 0.026, -0.649, 0.751, 0.000, -70.399, -91.899);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1023, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000, -2.432, 0.100, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 1.152, 0.915, -0.080, 11.799, 3.999, -179.600);
            LaunchObject[vehicleid][4] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -1.282, 0.917, -0.073, 11.799, -6.799, 179.600);
        }
        case 480 :  // комет лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19939, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(LaunchObject[vehicleid][0], 0, 11145, "carrierint_sfs", "noodpot_64", 0);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.000000, 1.971000, -0.520000, 0.000000, 24.099001, 90.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "GT\nRS", 130, "Impact", 100, 0, 0xFFAADD00, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, -0.817000, -0.964000, 0.406000, 0.000000, -25.099001, 540.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1138, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000000, -2.410000, 0.019000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][3], 0, "GT\nRS", 130, "Impact", 100, 0, 0xFFAADD00, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 0.819000, -0.960000, 0.399000, 0.000000, -24.400000, 0.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "=", 100, "Ariel", 199, 1, 0xFFAADD00, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, 0.000000, 1.248000, 0.239000, -0.299000, 90.000000, 0.000000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, 1.059740, 1.027070, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][6] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, -0.931000, 1.027100, 0.001000, 0.000000, 0.000000, 0.000000);
        }
        case 415 :  //читаха лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "n", 130, "Webdings", 100, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.000000, -0.420000, 0.590000, -0.599000, 90.000000, 0.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "I", 130, "Ariel", 199, 1, 0xFF009246, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, -0.110000, 2.011000, 0.071000, 0.000000, 102.198997, 90.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, "I", 130, "Ariel", 199, 1, 0xFFCE2B37, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.140000, 2.013000, 0.071000, 0.000000, 102.399002, 90.000000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 1.008800, 1.123600, -0.058400, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(1014, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, 0.000000, -2.369000, 0.179000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][5], 0, "I", 130, "Ariel", 199, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, 0.019000, 2.013000, 0.071000, 0.000000, 102.198997, 90.000000);
            LaunchObject[vehicleid][6] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, -0.879600, 1.123590, -0.058440, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][7] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][7], 0, "88", 130, "Calibri", 69, 1, 0xFF000000, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][7], vehicleid, 0.000000, -0.421000, 0.593000, 0.000000, -90.499001, 90.000000);
            LaunchObject[vehicleid][8] = CreateDynamicObject(19475, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][8], 0, "Italy 1980", 140, "Calibri", 115, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][8], vehicleid, 0.000000, 1.167000, 0.200000, 0.000000, -83.499001, 450.000000);
        }
        case 402 :  // буфало лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(18663, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "17", 140, "Impact", 199, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.011, -1.642, 0.503, 0.000, 66.199, 89.200);
            LaunchObject[vehicleid][1] = CreateDynamicObject(18663, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, ".", 60, "Courier New", 199, 0, -5242880, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 0.016, 0.042, 0.741, 0.199, 88.499, 90.700);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, "DAKOTA", 140, "Impact", 50, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000, -0.557, 0.730, -87.999, 0.000, 0.000);
        }
        case 579 :  // хантли лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(1071, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 1.079, -0.910, -0.460, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(1069, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, -1.071, -0.920, -0.480, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1049, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000, -2.291, 1.180, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1037, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 0.020, -0.540, -0.090, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "||", 60, "Fixedsys", 150, 0, -1, 0, 2);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -0.420, -1.371, 1.224, -90.200, 0.000, 0.000);
        }
        case 429 :  // банша лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, -0.931, 1.125, 0.020, 15.500, 0.000, 2.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 1.060, 1.121, 0.020, 15.500, 0.000, -2.000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, ".", 90, "Courier New", 199, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, -1.011, 0.823, 0.201, 1.599, 0.000, -86.600);
            LaunchObject[vehicleid][3] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][3], 0, ".", 90, "Courier New", 199, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 1.011, 0.823, 0.201, 1.399, 0.000, 86.600);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "01", 140, "Impact", 60, 0, -16744448, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -1.004, 0.832, -0.180, 0.000, 0.000, -87.099);
            LaunchObject[vehicleid][5] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][5], 0, "01", 140, "Impact", 60, 0, -16744448, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, 1.003, 0.822, -0.180, 0.000, 0.000, 87.099);
            LaunchObject[vehicleid][6] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][6], 0, "RT", 140, "Impact", 40, 1, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, -0.988, -1.022, -0.400, 18.500, 0.000, -93.099);
            LaunchObject[vehicleid][7] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][7], 0, "RT", 140, "Impact", 40, 1, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][7], vehicleid, 0.988, -1.022, -0.400, 18.500, 0.000, 93.099);
        }
        case 560 :  // султан лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "AIien", 140, "Segoe Script", 90, 1, -16759516, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.000, -1.223, 0.639, -59.599, 0.000, 0.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "-17-", 140, "Segoe Script", 60, 1, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 0.000, -1.380, 0.570, -59.599, 0.000, 0.000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 1.131, 1.260, 0.080, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, -1.000, 1.260, 0.080, 0.000, 0.000, 0.000);
        }
        case 506 :  // супер гт лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, -0.944900, 0.985300, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "TEAM", 130, "Impact", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, -0.061000, -1.748000, 0.329000, 0.000000, -74.299004, 270.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19475, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, "GTJ", 140, "Impact", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 1.036000, -1.110000, -0.070000, 0.000000, 0.000000, 6.499000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 1.075200, 0.985300, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][4], 0, "GTJ", 140, "Impact", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -1.043000, -1.201000, -0.059000, 0.000000, 0.699000, 173.699005);
            LaunchObject[vehicleid][5] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][5], 0, "JDM", 120, "Impact", 50, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, -0.050000, -1.523000, 0.405000, 0.000000, -72.000000, 270.000000);
        }
        case 559 :  // джестер лаунч
        {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "J", 130, "GTAWEAPON3", 100, 0, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, 0.060000, -1.409000, 0.572000, 0.000000, -78.399002, 270.000000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 1.146300, 1.087100, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, -1.014600, 1.087100, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][3], 0, "~", 130, "Webdings", 120, 1, 0xFFD22519, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 0.060000, -1.471000, 0.556000, 0.000000, 77.999001, 90.000000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -1.014600, 1.087100, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][5] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][5], 0, "~", 130, "Webdings", 120, 1, 0xFFD22519, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][5], vehicleid, 0.060000, -1.471000, 0.556000, 0.000000, 77.999001, 90.000000);
            LaunchObject[vehicleid][6] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][6], vehicleid, -1.014600, 1.087100, 0.001000, 0.000000, 0.000000, 0.000000);
            LaunchObject[vehicleid][7] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][7], 0, "~", 130, "Webdings", 120, 1, 0xFFD22519, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][7], vehicleid, 0.060000, -1.471000, 0.556000, 0.000000, 77.999001, 90.000000);
        }
        case 562 :  {
            LaunchObject[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][0], 0, "s", 90, "Segoe Script", 155, 1, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][0], vehicleid, -0.089, -1.420, 0.487, -57.900, -79.500, 1.000);
            LaunchObject[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][1], 0, "POWER", 140, "Comic Sans MS", 70, 0, -1, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][1], vehicleid, 0.000, -1.246, 0.589, -57.899, 0.000, 0.000);
            LaunchObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(LaunchObject[vehicleid][2], 0, "GT", 90, "Segoe Script", 48, 1, -8388608, 0, 1);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][2], vehicleid, 0.000, -1.404, 0.502, -57.699, 0.000, 0.000);
            LaunchObject[vehicleid][3] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][3], vehicleid, 1.091, 1.181, -0.040, 0.000, 0.000, 0.000);
            LaunchObject[vehicleid][4] = CreateDynamicObject(1112, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(LaunchObject[vehicleid][4], vehicleid, -0.970, 1.181, -0.040, 0.000, 0.000, 0.000);
        }
    }
    return 1;
}

new HallowenObject[MAX_VEHICLES][13] = {-1, ... };
stock RemoveHalloweenMod(vehicleid) {
    for (new i; i < 13; i++) {
        if (IsValidDynamicObject(HallowenObject[vehicleid][i])) DestroyDynamicObjectEx(HallowenObject[vehicleid][i]);
    }
    return 1;
}
stock install_halloween_mod(vehicleid) {
    RemoveHalloweenMod(vehicleid);
    switch (GetVehicleModel(vehicleid)) {
        case 411 :  //инфа
        {
            HallowenObject[vehicleid][0] = CreateDynamicObject(19917, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, -0.020, 1.929, -0.354, -9.999, 0.000, 0.000);
            HallowenObject[vehicleid][1] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, -0.160, 2.004, -0.292, -40.799, 8.499, 89.299);
            HallowenObject[vehicleid][2] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.160, 2.004, -0.292, -40.799, -8.499, -89.299);
            HallowenObject[vehicleid][3] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, 1.528, 1.929, -0.850, -27.100, 0.000, 92.000);
            HallowenObject[vehicleid][4] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, -1.528, 1.929, -0.850, -27.100, 0.000, -92.000);
            HallowenObject[vehicleid][5] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][5], 0, "ROAD\nTO", 130, "Segoe Script", 90, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, -0.029, -0.299, 0.678, -89.799, 19.400, 0.000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][6], 0, "HFГГ", 130, "Comic Sans MS", 130, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, 0.001, -1.874, 0.246, 179.600, -84.999, 88.100);
            HallowenObject[vehicleid][7] = CreateDynamicObject(19846, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 0, 16640, "a51", "a51_vent1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, 0.000, 2.582, -0.480, 0.000, 0.000, 0.000);
            HallowenObject[vehicleid][8] = CreateDynamicObject(1003, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][8], vehicleid, 0.000, -2.292, 0.240, 0.000, 0.000, 0.000);
            HallowenObject[vehicleid][9] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][9], vehicleid, -1.209, -1.514, 0.268, 0.000, 29.500, 94.499);
        }
        case 415 :  //читаха
        {
            HallowenObject[vehicleid][0] = CreateDynamicObject(2661, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][0], 0, 3214, "quarry", "Was_swr_trolleycage", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, -0.312000, 0.646000, 0.371000, -70.699997, -89.300003, -178.899002);
            HallowenObject[vehicleid][1] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, -0.270000, -4.365000, -0.016000, -67.699997, 0.000000, 0.000000);
            HallowenObject[vehicleid][2] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.290000, -4.365000, -0.016000, -67.699997, 0.000000, 0.000000);
            HallowenObject[vehicleid][3] = CreateDynamicObject(2661, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 0, 3214, "quarry", "Was_swr_trolleycage", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, 0.312000, 0.646000, 0.371000, -70.699997, 89.300003, 178.899002);
            HallowenObject[vehicleid][4] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][4], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, -0.340000, -2.382000, -0.431000, -63.699001, 0.000000, 0.000000);
            HallowenObject[vehicleid][5] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][5], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, 0.400000, -2.382000, -0.431000, -63.699001, 0.000000, 0.000000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, -0.841000, 0.797000, 0.098000, 96.099998, 22.499001, 92.999001);
            HallowenObject[vehicleid][7] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, 0.774000, 0.686000, 0.095000, -98.799004, 337.500000, 36.098999);
            HallowenObject[vehicleid][8] = CreateDynamicObject(2662, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][8], 0, "O", 90, "GTAWEAPON3", 140, 0, 0xCC000000, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][8], vehicleid, -0.100000, 1.909000, 0.116000, 282.000000, 0.000000, 180.199997);
        }
        case 451 :  //турик
        {
            HallowenObject[vehicleid][0] = CreateDynamicObject(1738, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][0], 0, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][0], 1, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, -0.060, 2.288, -0.345, -92.199, 0.299, 0.000);
            HallowenObject[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][1], 0, "N", 130, "Wingdings", 199, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, -0.000, -0.550, 0.560, -89.800, 0.000, -90.599);
            HallowenObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][2], 0, "N", 130, "Wingdings", 199, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);
            HallowenObject[vehicleid][3] = CreateDynamicObject(2593, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 0, 16093, "a51_ext", "des_dirttrack1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, 0.070, -2.732, -0.109, 0.000, 89.699, 0.000);
            HallowenObject[vehicleid][4] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][4], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, -0.080, 0.426, 0.309, -20.099, 0.000, 0.000);
            HallowenObject[vehicleid][5] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][5], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, 0.080, 0.426, 0.309, -20.099, 0.000, 0.000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][6], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, -0.080, -1.500, 0.363, 20.099, 0.000, 0.000);
            HallowenObject[vehicleid][7] = CreateDynamicObject(19843, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, 0.080, -1.500, 0.363, 20.099, 0.000, 0.000);
        }
        case 579 :  {
            HallowenObject[vehicleid][0] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][0], 0, "DEAD", 140, "Comic Sans MS", 150, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, 0.046, -0.596, 1.229, -89.600, 51.100, 0.000);
            HallowenObject[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][1], 0, "TRAIN", 130, "Comic Sans MS", 100, 0, -5103070, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, -0.276, -1.014, 1.226, -89.600, 67.600, 0.000);
            HallowenObject[vehicleid][2] = CreateDynamicObject(2662, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][2], 0, 14612, "ab_abattoir_box", "ab_bloodfloor", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.008, 1.664, 0.491, -94.099, 2.699, 4.099);
            HallowenObject[vehicleid][3] = CreateDynamicObject(2597, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, -0.000, 2.594, 0.007, 41.099, -89.099, -1.200);
            HallowenObject[vehicleid][4] = CreateDynamicObject(2985, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, 0.000, -2.021, 0.360, 0.000, 0.000, -64.400);
            HallowenObject[vehicleid][5] = CreateDynamicObject(2842, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][5], 0, 10840, "bigshed_sfse", "ws_corr_metal2", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, -0.520, -2.902, 0.265, 63.199, 0.000, 0.000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(2842, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][6], 0, 3214, "quarry", "Was_swr_trolleycage", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, -0.512, 0.217, 1.249, -49.399, -0.699, 0.000);
            HallowenObject[vehicleid][7] = CreateDynamicObject(2260, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 0, 6404, "beafron1_law2", "shingledblue_la", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 1, 6404, "beafron1_law2", "shingledblue_la", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, -1.659, -1.925, -0.128, -9.899, -77.200, -89.899);
            HallowenObject[vehicleid][8] = CreateDynamicObject(2260, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][8], 0, 6404, "beafron1_law2", "shingledblue_la", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][8], 1, 6404, "beafron1_law2", "shingledblue_la", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][8], vehicleid, 1.659, -1.925, -0.128, -9.899, 77.200, 90.599);
        }
        case 487 :  {
            HallowenObject[vehicleid][0] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][0], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, 1.061000, -1.780000, 0.400000, 0.000000, 0.000000, 341.199005);
            HallowenObject[vehicleid][1] = CreateDynamicObject(19848, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, 1.061000, 1.041000, -1.040000, 0.000000, 0.000000, 180.000000);
            HallowenObject[vehicleid][2] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][2], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.300000, 0.040000, 1.370000, 90.000000, 0.000000, 90.000000);
            HallowenObject[vehicleid][3] = CreateDynamicObject(3790, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, -1.020000, 0.161000, 1.400000, 0.000000, 0.000000, -90.000000);
            HallowenObject[vehicleid][4] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][4], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, -0.300000, 0.040000, 1.370000, 90.000000, 0.000000, -90.000000);
            HallowenObject[vehicleid][5] = CreateDynamicObject(19848, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, -1.061000, 1.041000, -1.040000, 0.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(3790, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][6], 0, 1560, "7_11_door", "CJ_CHROME2", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, 1.020000, 0.161000, 1.400000, 0.000000, 0.000000, 270.000000);
            HallowenObject[vehicleid][7] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, 0.359000, -1.571000, 0.389000, 90.000000, 0.000000, 71.400002);
            HallowenObject[vehicleid][8] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][8], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][8], vehicleid, -1.056000, -1.780000, 0.400000, 0.000000, 0.000000, -161.199005);
            HallowenObject[vehicleid][9] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][9], 0, "D34D C0URS3", 120, "Arial", 90, 1, 0xFFAAAAAA, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][9], vehicleid, 1.061000, -1.780000, 0.400000, 0.000000, 0.000000, 341.199005);
            HallowenObject[vehicleid][10] = CreateDynamicObject(1434, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][10], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][10], vehicleid, -0.359000, -1.571000, 0.389000, 90.000000, 0.000000, -71.400002);
            HallowenObject[vehicleid][11] = CreateDynamicObject(19294, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][11], vehicleid, 0.776600, -6.836300, 0.000000, 0.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][12] = CreateDynamicObject(19294, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][12], vehicleid, 0.776600, 6.836300, 0.000000, 0.000000, 0.000000, 0.000000);
        }
        case 475 :  {
            HallowenObject[vehicleid][0] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][0], 1, 2772, "airp_prop", "cj_chromepipe", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, 0.047000, 1.671000, -0.356000, 300.000000, 0.000000, 90.000000);
            HallowenObject[vehicleid][1] = CreateDynamicObject(2660, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterialText(HallowenObject[vehicleid][1], 0, "O", 60, "GTAWEAPON3", 140, 0, 0xFF000000, 0, 1);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, 0.130000, -0.320000, 0.710000, 270.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][2] = CreateDynamicObject(19587, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][2], 0, 16098, "des_boneyard", "Was_meshfence", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, 0.000000, 0.565000, 0.448000, -31.700001, 180.000000, 0.000000);
            HallowenObject[vehicleid][3] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 1, 2772, "airp_prop", "cj_chromepipe", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, -0.047000, 1.671000, -0.356000, 300.000000, 0.000000, -90.000000);
            HallowenObject[vehicleid][4] = CreateDynamicObject(19917, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][4], 0, 65535, "none", "none", 0xFFFFFFFF);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, 0.000000, 1.623000, -0.247000, -3.799000, 0.000000, 0.000000);
            HallowenObject[vehicleid][5] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][5], vehicleid, -0.610000, 0.150000, 0.709000, 270.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][6] = CreateDynamicObject(18702, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][6], vehicleid, 0.610000, 0.150000, 0.709000, 270.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][7] = CreateDynamicObject(2501, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][7], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][7], vehicleid, 0.000000, 2.580000, 0.000000, 270.000000, 90.000000, 0.000000);
            HallowenObject[vehicleid][8] = CreateDynamicObject(16732, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][8], 0, 1413, "break_f_mesh", "CJ_CORRIGATED", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][8], vehicleid, -0.390000, -0.030000, -0.610000, 270.000000, 0.000000, 0.000000);
            HallowenObject[vehicleid][9] = CreateDynamicObject(16732, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][9], 0, 1413, "break_f_mesh", "CJ_CORRIGATED", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][9], vehicleid, 0.390000, -0.030000, -0.610000, 270.000000, 0.000000, 0.000000);
        }
        case 522 :  {
            HallowenObject[vehicleid][0] = CreateDynamicObject(2891, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][0], 0, 19624, "case1", "cj_case_brown", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][0], vehicleid, -0.106000, 0.057000, 0.280000, 0.000000, 0.000000, 22.900000);
            HallowenObject[vehicleid][1] = CreateDynamicObject(2891, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 1
            SetDynamicObjectMaterial(HallowenObject[vehicleid][1], 0, 19624, "case1", "cj_case_brown", 0xFFCCCCCC);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][1], vehicleid, 0.106000, 0.057000, 0.280000, 0.000000, 0.000000, -22.900000);
            HallowenObject[vehicleid][2] = CreateDynamicObject(2495, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(HallowenObject[vehicleid][2], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][2], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][2], vehicleid, -0.262000, 0.141000, -0.054000, -98.099998, -21.000000, 58.799000);
            HallowenObject[vehicleid][3] = CreateDynamicObject(2495, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 2
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 1, 2905, "dead_mantxd", "billyblood", 0);
            SetDynamicObjectMaterial(HallowenObject[vehicleid][3], 0, 19962, "samproadsigns", "materialtext1", 0);
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][3], vehicleid, 0.262000, 0.182000, -0.096000, -105.698997, 0.000000, -78.698997);
            HallowenObject[vehicleid][4] = CreateDynamicObject(362, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000); // 0
            AttachDynamicObjectToVehicle(HallowenObject[vehicleid][4], vehicleid, 0.410000, 0.011000, 0.344000, 0.000000, 27.799000, 90.000000);
        }
    }
    return 1;
}

new FutureObject[MAX_VEHICLES][10] = {-1, ... };
stock RemoveFutureMod(vehicleid) {
    for (new i; i < 10; i++) {
        if (IsValidDynamicObject(FutureObject[vehicleid][i])) DestroyDynamicObjectEx(FutureObject[vehicleid][i]);
    }
    return 1;
}
stock install_future_mod(vehicleid) {
    RemoveFutureMod(vehicleid);
    switch (GetVehicleModel(vehicleid)) {
        case 411 :  //инфа
        {
            FutureObject[vehicleid][0] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][0], vehicleid, 0.290, 2.262, 0.060, -13.900, 0.000, 0.000);
            FutureObject[vehicleid][1] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][1], vehicleid, -0.290, 2.262, 0.060, -13.900, 0.000, 0.000);
            FutureObject[vehicleid][2] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][2], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][2], vehicleid, 0.290, 2.027, 0.117, -5.899, 0.000, 0.000);
            FutureObject[vehicleid][3] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][3], vehicleid, -0.290, 2.027, 0.117, -5.899, 0.000, 0.000);
            FutureObject[vehicleid][4] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][4], vehicleid, 0.290, 1.701, 0.151, -5.899, 0.000, 0.000);
            FutureObject[vehicleid][5] = CreateDynamicObject(1006, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 0, 10101, "2notherbuildsfe", "ferry_build14", -1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][5], vehicleid, -0.290, 1.701, 0.151, -5.899, 0.000, 0.000);
            FutureObject[vehicleid][6] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(FutureObject[vehicleid][6], 0, "33", 130, "Impact", 199, 1, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][6], vehicleid, 0.000, -0.119, 0.674, -90.699, 2.599, -177.300);
            FutureObject[vehicleid][7] = CreateDynamicObject(19327, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterialText(FutureObject[vehicleid][7], 0, "NSX", 140, "Arial", 160, 0, -16777216, 0, 1);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][7], vehicleid, 0.000, -1.920, 0.248, -85.199, 0.000, 0.000);
        }
        case 463 :  {
            FutureObject[vehicleid][0] = CreateDynamicObject(19559, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 0, 14802, "lee_bdupsflat", "USAflag", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][0], vehicleid, 0.000, -1.091, 0.099, -49.299, 0.000, 0.000);
            FutureObject[vehicleid][1] = CreateDynamicObject(19319, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][1], vehicleid, 0.052, -1.170, 0.292, -44.499, 31.500, 0.000);
        }
        case 451 :  {
            FutureObject[vehicleid][0] = CreateDynamicObject(2422, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 0, 16640, "a51", "Metal3_128", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 1, 1692, "moregenroofstuff", "solar_panel_1", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 2, 1692, "moregenroofstuff", "solar_panel_1", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][0], vehicleid, -0.101, -0.220, 0.489, 0.000, -2.599, 0.000);
            FutureObject[vehicleid][1] = CreateDynamicObject(2422, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 0, 16640, "a51", "Metal3_128", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 1, 1692, "moregenroofstuff", "solar_panel_1", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 2, 1692, "moregenroofstuff", "solar_panel_1", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][1], vehicleid, 0.635, -0.230, 0.461, 0.000, 2.899, 0.000);
            FutureObject[vehicleid][2] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][2], 1, 8423, "pirateship01", "tislandwall04_64", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][2], vehicleid, -0.733, 1.301, -0.361, 0.000, 86.699, 0.000);
            FutureObject[vehicleid][3] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 1, 8423, "pirateship01", "tislandwall04_64", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][3], vehicleid, 0.733, 1.301, -0.361, 0.000, -86.699, 0.000);
            FutureObject[vehicleid][4] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 1, 8423, "pirateship01", "tislandwall04_64", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][4], vehicleid, 0.735, -1.691, -0.321, 0.000, -86.699, 0.000);
            FutureObject[vehicleid][5] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 1, 8423, "pirateship01", "tislandwall04_64", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][5], vehicleid, -0.734, -1.691, -0.351, 0.000, 86.699, 0.000);
            FutureObject[vehicleid][6] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][6], vehicleid, -0.993, -1.757, -0.458, 0.000, 95.799, 179.099);
            FutureObject[vehicleid][7] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][7], vehicleid, 0.993, -1.757, -0.458, 0.000, -95.799, -179.099);
            FutureObject[vehicleid][8] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][8], vehicleid, -0.990, 1.476, -0.464, 178.600, 95.799, -179.099);
            FutureObject[vehicleid][9] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][9], vehicleid, 0.990, 1.476, -0.464, 178.600, -95.799, 179.099);
        }
        case 429 :  {
            // new banshfunt[10];
            FutureObject[vehicleid][0] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 0, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 1, 1259, "billbrd", "ws_oldpainted2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 2, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][0], 3, 1259, "billbrd", "ws_oldpainted2", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][0], vehicleid, -0.758, 1.562, -0.315, 3.100, 84.999, 0.700);
            FutureObject[vehicleid][1] = CreateDynamicObject(2422, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 0, 16640, "a51", "Metal3_128", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 1, 1692, "moregenroofstuff", "solar_panel_1", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][1], 2, 1692, "moregenroofstuff", "solar_panel_1", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][1], vehicleid, 0.236, -1.938, 0.280, 0.000, -3.299, -179.599);
            FutureObject[vehicleid][2] = CreateDynamicObject(2422, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][2], 0, 16640, "a51", "Metal3_128", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][2], 1, 1692, "moregenroofstuff", "solar_panel_1", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][2], 2, 1692, "moregenroofstuff", "solar_panel_1", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][2], vehicleid, -0.746, -1.933, 0.250, 0.000, 3.299, 179.599);
            FutureObject[vehicleid][3] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 0, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 1, 1259, "billbrd", "ws_oldpainted2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 2, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][3], 3, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][3], vehicleid, 0.758, 1.562, -0.315, 3.100, -84.999, -0.700);
            FutureObject[vehicleid][4] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 0, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 1, 1259, "billbrd", "ws_oldpainted2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 2, 1560, "7_11_door", "CJ_CHROME2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][4], 3, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][4], vehicleid, 0.758, -1.562, -0.315, -3.100, -84.999, 0.700);
            FutureObject[vehicleid][5] = CreateDynamicObject(19061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 0, 14581, "ab_mafiasuitea", "barbersmir1", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 1, 1259, "billbrd", "ws_oldpainted2", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 2, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
            SetDynamicObjectMaterial(FutureObject[vehicleid][5], 3, 1560, "7_11_door", "CJ_CHROME2", 0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][5], vehicleid, -0.768, -1.562, -0.316, -3.100, 84.999, -0.700);
            FutureObject[vehicleid][6] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][6], vehicleid, 1.072, 1.731, -0.299, -0.299, -86.499, -1.199);
            FutureObject[vehicleid][7] = CreateDynamicObject(1114, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][7], vehicleid, -1.072, 1.731, -0.299, -0.299, 86.499, 1.199);
            FutureObject[vehicleid][8] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][8], vehicleid, -1.073, -1.741, -0.299, 0.299, 86.499, 174.599);
            FutureObject[vehicleid][9] = CreateDynamicObject(1114, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.000000);
            AttachDynamicObjectToVehicle(FutureObject[vehicleid][9], vehicleid, 1.073, -1.741, -0.299, 0.299, -86.499, -174.599);
        }
    }
    return true;
}

new TaxiObject[MAX_VEHICLES][4] = {-1, ... };
stock RemoveTaxiMod(vehicleid) {
    for (new i; i < 4; i++) {
        if (IsValidDynamicObject(TaxiObject[vehicleid][i])) DestroyDynamicObjectEx(TaxiObject[vehicleid][i]);
    }
    return 1;
}
stock install_taxi_mod(vehicleid) {
    RemoveTaxiMod(vehicleid);
    switch (GetVehicleModel(vehicleid)) {
        case 411 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, 0.000, 0.000, 0.779, 0.000, 0.000, -92.499);
        }
        case 541 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, -0.005, -0.160, 0.720, 0.000, 0.000, -92.199);
        }
        case 415 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, -0.038, -0.388, 0.710, 0.000, 0.000, 86.899);
        }
        case 579 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, 0.003, -0.200, 1.320, 0.000, 0.000, 91.000);
            TaxiObject[vehicleid][1] = CreateDynamicObject(19327, 0.000000, 0.000000, -1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.0); // 1
            SetDynamicObjectMaterialText(TaxiObject[vehicleid][1], 0, "- 666 -", 130, "Ariel", 47, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][1], vehicleid, 0.000000, -2.717000, 0.672000, -26.698999, 0.000000, 0.000000);
            TaxiObject[vehicleid][2] = CreateDynamicObject(19327, 0.000000, 0.000000, -1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.0); // 1
            SetDynamicObjectMaterialText(TaxiObject[vehicleid][2], 0, "ЗВОНИТЕ ПО НОМЕРУ", 130, "Ariel", 20, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][2], vehicleid, 0.000000, -2.642000, 0.814000, -23.799999, 0.000000, 0.000000);
            TaxiObject[vehicleid][3] = CreateDynamicObject(19327, 0.000000, 0.000000, -1000.000000, 0.000000, 0.000000, 0.000000, -1, -1, -1, 150.0); // 1
            SetDynamicObjectMaterialText(TaxiObject[vehicleid][3], 0, "FAKE TAXI", 130, "Ariel", 34, 1, 0xFFFFFFFF, 0, 1);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][3], vehicleid, 0.000000, -2.596000, 0.903000, -27.600000, 0.000000, 0.000000);
        }
        case 560 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, 0.000, 0.070, 0.930, 0.000, 0.000, 89.499);
        }
        case 495 :  {
            TaxiObject[vehicleid][0] = CreateDynamicObject(19308, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, -1, -1, -1, 300.0);
            AttachDynamicObjectToVehicle(TaxiObject[vehicleid][0], vehicleid, -0.004, -0.511, 1.120, 0.000, 0.000, -90.499);
        }
    }
    return true;
}