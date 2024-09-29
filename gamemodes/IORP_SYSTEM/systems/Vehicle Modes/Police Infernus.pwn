#define MAX_INFERNUS_OBJECTS 12

new policeInfernusObjectId[MAX_VEHICLES][MAX_INFERNUS_OBJECTS] = { INVALID_OBJECT_ID, ... };
new PoliceInfernus:State[MAX_VEHICLES] = { 0, ... };

stock PoliceInfernus:IsAllowed(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return 0;
    if (GetVehicleModel(vehicleid) != 411) return 0;
    new id = StaticVehicle:GetID(vehicleid);
    if (id == -1) return 0;
    new vehFactionId = StaticVehicle:GetFactionID(id);
    if (vehFactionId != FACTION_ID_SAGD && vehFactionId != FACTION_ID_SAAF && vehFactionId != FACTION_ID_SAPD) return 0;
    return 1;
}

stock PoliceInfernus:Destroy(vehicleid) {
    for (new i; i < MAX_INFERNUS_OBJECTS; i++) {
        if (policeInfernusObjectId[vehicleid][i] != INVALID_OBJECT_ID) {
            DestroyDynamicObjectEx(policeInfernusObjectId[vehicleid][i]);
            policeInfernusObjectId[vehicleid][i] = INVALID_OBJECT_ID;
        }
    }
    return 1;
}

stock PoliceInfernus:Install(vehicleid, enableDisable = 0) {
    PoliceInfernus:Destroy(vehicleid);

    policeInfernusObjectId[vehicleid][0] = CreateDynamicObject(19476, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
    SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][0], 0, !"POLICE", 120, !"Arial", 100, 1, -1, 0, 1);
    AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][0], vehicleid, -0.001276, 2.790166, -0.456286, 0.000000, 21.799999, 90.000000);

    policeInfernusObjectId[vehicleid][1] = CreateDynamicObject(19477, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
    SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][1], 0, !"POLICE", 130, !"Arial", 60, 1, -1, 0, 1);
    AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][1], vehicleid, 0.001995, -1.970654, 0.239949, 0.000000, -85.200073, -90.000000);

    policeInfernusObjectId[vehicleid][2] = CreateDynamicObject(19797, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);

    policeInfernusObjectId[vehicleid][3] = CreateDynamicObject(19797, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);

    policeInfernusObjectId[vehicleid][4] = CreateDynamicObject(19797, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);

    policeInfernusObjectId[vehicleid][5] = CreateDynamicObject(19797, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);

    policeInfernusObjectId[vehicleid][6] = CreateDynamicObject(19620, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
    AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][6], vehicleid, 0.000000, 0.159840, 0.709995, 0.000000, 0.000000, 0.000000);

    if (enableDisable) {
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][2], vehicleid, -0.623635, 2.719873, -0.489997, 17.100002, 0.000000, -168.299880);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][3], vehicleid, 0.623635, 2.719873, -0.489997, 17.100002, 180.000000, 168.299880);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][4], vehicleid, -0.778895, -2.520503, -0.455543, 22.600015, 180.000000, -4.399932);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][5], vehicleid, 0.778895, -2.520503, -0.455543, 22.600015, 0.000000, 4.399932);

        // flashes
        policeInfernusObjectId[vehicleid][7] = CreateDynamicObject(19419, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
        SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][7], 0, !"_", 130, !"Arial", 60, 0, 0, 0, 1);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][7], vehicleid, 0.000000, 0.159840, 0.709995, 0.000000, 0.000000, 180.000000);

        policeInfernusObjectId[vehicleid][8] = CreateDynamicObject(19419, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
        SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][8], 0, !"_", 130, !"Arial", 60, 0, 0, 0, 1);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][8], vehicleid, -0.100000, 2.820966, -0.900011, 0.000000, 0.000000, 10.0000);

        policeInfernusObjectId[vehicleid][9] = CreateDynamicObject(19419, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
        SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][9], 0, !"_", 130, !"Arial", 60, 0, 0, 0, 1);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][9], vehicleid, 0.10000, 2.820966, -0.900011, 0.000000, 0.000000, -190.0000);

        policeInfernusObjectId[vehicleid][10] = CreateDynamicObject(19419, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
        SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][10], 0, !"_", 130, !"Arial", 60, 0, 0, 0, 1);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][10], vehicleid, 0.10000, -2.637919, -0.900011, 0.000000, 0.000000, 190.0000);

        policeInfernusObjectId[vehicleid][11] = CreateDynamicObject(19419, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000);
        SetDynamicObjectMaterialText(policeInfernusObjectId[vehicleid][11], 0, !"_", 130, !"Arial", 60, 0, 0, 0, 1);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][11], vehicleid, -0.10000, -2.637919, -0.900011, 0.000000, 0.000000, -10.0000);

    } else {
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][2], vehicleid, -0.623635, 2.719873, -0.489997, 197.100002, 0.000000, -168.299880);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][3], vehicleid, 0.623635, 2.719873, -0.489997, 197.100002, 0.000000, 168.299880);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][4], vehicleid, -0.778895, -2.520503, -0.455543, 202.600015, 0.000000, -4.399932);
        AttachDynamicObjectToVehicle(policeInfernusObjectId[vehicleid][5], vehicleid, 0.778895, -2.520503, -0.455543, 202.600015, 0.000000, 4.399932);
        SetDynamicObjectMaterial(policeInfernusObjectId[vehicleid][6], 0, 19620, !"LightBar1", !"lightbar1", 0xFFFFFFFF);
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    if (!PoliceInfernus:IsAllowed(vehicleid)) return 1;
    PoliceInfernus:Install(vehicleid);
    return 1;
}

cmd:siren(playerid, const params[]) {
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsValidVehicle(vehicleid)) return 0;
    if (!PoliceInfernus:IsAllowed(vehicleid)) return 0;
    if (PoliceInfernus:State[vehicleid]) {
        PoliceInfernus:State[vehicleid] = 0;
        PoliceInfernus:Install(vehicleid, 0);
        AlexaMsg(playerid, "siren turned off");
    } else {
        PoliceInfernus:State[vehicleid] = 1;
        PoliceInfernus:Install(vehicleid, 1);
        AlexaMsg(playerid, "siren turned on");
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    if (!PoliceInfernus:IsAllowed(vehicleid)) return 1;
    PoliceInfernus:Destroy(vehicleid);
    return 1;
}