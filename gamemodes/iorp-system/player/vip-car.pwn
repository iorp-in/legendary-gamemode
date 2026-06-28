new VipVehicleModObjects[MAX_VEHICLES][13];

hook OnVehicleDestroyed(vehicleid) {
    for (new i; i < 13; i++) {
        DestroyDynamicObject(VipVehicleModObjects[vehicleid][i]);
    }
    return 1;
}

stock SpawnVipVehicleFor(playerid, modalId) {
    new Float:pX, Float:pY, Float:pZ, Float:pAngle;
    GetPlayerPos(playerid, pX, pY, pZ);
    GetPlayerFacingAngle(playerid, pAngle);
    GetXYInFrontOfPlayer(playerid, pX, pY, 3);
    new vehicleid = CreateVehicle(modalId, pX, pY, pZ + 2.0, pAngle, 0, 0, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), true);
    ResetVehicleEx(vehicleid);
    SetVehicleFuelEx(vehicleid, 99.0);
    Iter_Add(ASpawnedVeh, vehicleid);

    if (modalId == 415) { // Cheetah
        VipVehicleModObjects[vehicleid][0] = CreateDynamicObject(2985, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][0], vehicleid, -0.450000, 0.824999, -0.599999, -27.000003, -0.000000, -269.999877);

        VipVehicleModObjects[vehicleid][1] = CreateDynamicObject(2985, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][1], vehicleid, 0.524999, 0.824999, -0.674999, 21.599998, -0.000000, -269.999877);

        VipVehicleModObjects[vehicleid][2] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][2], vehicleid, -1.049999, -0.150000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][3] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][3], vehicleid, 1.049999, -0.150000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][4] = CreateDynamicObject(1254, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][4], vehicleid, -0.000000, 2.100000, 0.000000, 67.500007, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][5] = CreateDynamicObject(19314, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][5], vehicleid, -0.000000, 0.000000, 0.599999, 70.200004, 89.099983, 0.000000);
    } else if (modalId == 411) { // Infernus
        VipVehicleModObjects[vehicleid][0] = CreateDynamicObject(19419, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][0], vehicleid, 0.000000, -2.100000, 0.300000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][1] = CreateDynamicObject(19419, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][1], vehicleid, 0.000000, -1.725000, 0.300000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][2] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][2], vehicleid, -1.049999, -0.150000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][3] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][3], vehicleid, 1.049999, -0.150000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][4] = CreateDynamicObject(18646, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][4], vehicleid, -0.449999, 0.000000, 0.749999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][5] = CreateDynamicObject(1247, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][5], vehicleid, -0.000000, 2.175000, 0.075000, 70.200004, -0.000001, -0.000001);
    } else if (modalId == 579) { // Huntley
        VipVehicleModObjects[vehicleid][0] = CreateDynamicObject(2985, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][0], vehicleid, -0.000000, 1.725000, -0.225000, 0.000001, 0.000000, 91.799980);

        VipVehicleModObjects[vehicleid][1] = CreateDynamicObject(19314, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][1], vehicleid, 0.000000, 0.225000, 1.200000, 91.799980, -89.099983, 0.000000);

        VipVehicleModObjects[vehicleid][2] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][2], vehicleid, -0.600000, -1.049999, 1.200000, -0.000001, -0.000001, 89.099983);

        VipVehicleModObjects[vehicleid][3] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][3], vehicleid, 0.674999, -1.049999, 1.200000, -0.000001, -0.000001, 89.099983);

        VipVehicleModObjects[vehicleid][4] = CreateDynamicObject(18652, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][4], vehicleid, -1.049999, 0.000000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][5] = CreateDynamicObject(18652, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][5], vehicleid, 1.049999, 0.000000, -0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][6] = CreateDynamicObject(1247, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][6], vehicleid, -1.125000, 0.899999, 0.150000, -5.399999, 0.000000, 89.099983);

        VipVehicleModObjects[vehicleid][7] = CreateDynamicObject(1247, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][7], vehicleid, 1.124999, 0.899999, 0.150000, -5.399999, 0.000000, 89.099983);

        VipVehicleModObjects[vehicleid][8] = CreateDynamicObject(1318, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][8], vehicleid, 0.000000, -0.899999, 1.350000, -264.599853, -359.100280, -359.100280);

        VipVehicleModObjects[vehicleid][9] = CreateDynamicObject(954, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][9], vehicleid, -0.000000, -2.700001, 0.749999, -21.600002, -0.000000, -0.000000);

        VipVehicleModObjects[vehicleid][10] = CreateDynamicObject(1254, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][10], vehicleid, 0.000000, 2.400000, 0.225000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][11] = CreateDynamicObject(19419, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][11], vehicleid, -0.000000, -2.250000, 1.125000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][12] = CreateDynamicObject(1248, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][12], vehicleid, -0.000000, -2.775001, 0.000000, 0.000000, 0.000000, 0.000000);

    } else if (modalId == 541) { // Bullet
        VipVehicleModObjects[vehicleid][0] = CreateDynamicObject(1254, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][0], vehicleid, -0.000000, 1.950000, 0.075000, 72.900001, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][1] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][1], vehicleid, -0.974999, 0.000000, -0.375000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][2] = CreateDynamicObject(18647, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][2], vehicleid, 0.974999, 0.000000, -0.375000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][3] = CreateDynamicObject(18749, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][3], vehicleid, -0.000000, -1.800000, 0.375000, -78.299995, -0.000001, 0.000000);

        VipVehicleModObjects[vehicleid][4] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][4], vehicleid, -0.300000, 0.000000, 0.599999, -0.000002, 0.000000, 89.099960);

        VipVehicleModObjects[vehicleid][5] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][5], vehicleid, 0.374999, 0.000000, 0.599999, -0.000002, 0.000000, 89.099960);

        VipVehicleModObjects[vehicleid][6] = CreateDynamicObject(18646, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][6], vehicleid, -0.000000, 0.000000, 0.674999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][7] = CreateDynamicObject(355, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][7], vehicleid, -0.149999, -2.324999, 0.000000, 5.399998, -16.200000, 5.400000);

        ChangeVehicleColor(vehicleid, 0, 3);
    } else if (modalId == 522) { // NRG
        VipVehicleModObjects[vehicleid][0] = CreateDynamicObject(18650, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][0], vehicleid, 0.000000, 0.000000, -0.674999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][1] = CreateDynamicObject(362, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][1], vehicleid, 0.075000, 0.600000, 0.675000, 5.399998, 24.300001, 99.899971);

        VipVehicleModObjects[vehicleid][2] = CreateDynamicObject(1254, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][2], vehicleid, -0.150000, 1.800000, 0.524999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][3] = CreateDynamicObject(18646, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][3], vehicleid, 0.000000, -0.899999, 0.599999, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][4] = CreateDynamicObject(19130, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][4], vehicleid, -0.675000, 0.000000, 0.824999, 40.500003, 0.000002, -80.999992);

        VipVehicleModObjects[vehicleid][5] = CreateDynamicObject(19130, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][5], vehicleid, 0.824999, 0.000000, 0.824999, 40.500003, 0.000002, -269.999877);

        VipVehicleModObjects[vehicleid][6] = CreateDynamicObject(18749, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][6], vehicleid, 0.000000, -1.125000, 0.300000, 0.000000, 0.000000, 0.000000);

        VipVehicleModObjects[vehicleid][7] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][7], vehicleid, -0.375000, 0.000000, 0.000000, 0.000000, 0.000000, 89.099983);

        VipVehicleModObjects[vehicleid][8] = CreateDynamicObject(359, 0, 0, -1000, 0, 0, 0);
        AttachDynamicObjectToVehicle(VipVehicleModObjects[vehicleid][8], vehicleid, 0.449999, 0.000000, 0.000000, 0.000000, 0.000000, 89.099983);

        ChangeVehicleColor(vehicleid, 0, 6);
    }

}

CMD:vipcar(playerid, const params[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 0;
    FlexPlayerDialog(playerid, "VipCar", DIALOG_STYLE_LIST, "Vip Vehicles", "Cheetah\nInfernus\nHuntley\nBullet\nNRG", "Spawn", "Cancel");
    return 1;
}

FlexDialog:VipCar(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;

    if (listitem == 0) {
        SpawnVipVehicleFor(playerid, 415);
        AlexaMsg(playerid, "you spawned a custom Cheetah!");
    } else if (listitem == 1) {
        SpawnVipVehicleFor(playerid, 411);
        AlexaMsg(playerid, "you spawned a custom Infernus!");
    } else if (listitem == 2) {
        SpawnVipVehicleFor(playerid, 579);
        AlexaMsg(playerid, "you spawned a custom Huntley!");
    } else if (listitem == 3) {
        SpawnVipVehicleFor(playerid, 541);
        AlexaMsg(playerid, "you spawned a custom Bullet!");
    } else if (listitem == 4) {
        SpawnVipVehicleFor(playerid, 522);
        AlexaMsg(playerid, "you spawned a custom NRG!");
    }

    return 1;
}