hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 13744, 1272.589, -803.109, 86.359, 0.250);
    RemoveBuildingForPlayer(playerid, 13724, 1254.400, -803.171, 85.960, 0.250);
    RemoveBuildingForPlayer(playerid, 13783, 1254.400, -803.171, 85.960, 0.250);
    RemoveBuildingForPlayer(playerid, 13756, 1349.300, -809.140, 68.882, 0.250);
    RemoveBuildingForPlayer(playerid, 13879, 1349.300, -809.140, 68.882, 0.250);
    return 1;
}

hook OnGameModeInit() {
    new tmpobjid;
    tmpobjid = CreateObject(13744, 1272.589, -803.109, 86.359, 0.000, 0.000, 0.000, 600.000);
    SetObjectMaterial(tmpobjid, 0, 13699, "cunte2_lahills", "laposhfence3", -52);
    SetObjectMaterial(tmpobjid, 2, 3945, "bistro_alpha", "creme128", -13421773);
    SetObjectMaterial(tmpobjid, 4, 13699, "cunte2_lahills", "laposhfence3", 0);
    tmpobjid = CreateObject(13724, 1254.400, -803.171, 85.960, 0.000, 0.000, 0.000, 600.000);
    SetObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "brwall_128", -52);
    SetObjectMaterial(tmpobjid, 1, 4828, "airport3_las", "brwall_128", -52);
    SetObjectMaterial(tmpobjid, 2, 13691, "bevcunto2_lahills", "ws_patio1", 0);
    SetObjectMaterial(tmpobjid, 3, 13691, "bevcunto2_lahills", "ws_patio1", 0);
    SetObjectMaterial(tmpobjid, 4, 13691, "bevcunto2_lahills", "ws_patio1", 0);
    SetObjectMaterial(tmpobjid, 5, 4828, "airport3_las", "brwall_128", -52);
    SetObjectMaterial(tmpobjid, 7, 4833, "airprtrunway_las", "policeha02black_128", 0);
    SetObjectMaterial(tmpobjid, 8, 14738, "whorebar", "AH_cheapwindow", -103);
    SetObjectMaterial(tmpobjid, 9, 13691, "bevcunto2_lahills", "stonewall3_la", -52);
    SetObjectMaterial(tmpobjid, 10, 4828, "airport3_las", "brwall_128", -26317);
    SetObjectMaterial(tmpobjid, 14, 9514, "711_sfw", "ws_carpark2", 0);
    SetObjectMaterial(tmpobjid, 15, 9514, "711_sfw", "ws_carpark2", 0);
    tmpobjid = CreateObject(13756, 1349.300, -809.140, 68.882, 0.000, 0.000, 0.000, 600.000);
    SetObjectMaterial(tmpobjid, 1, 13691, "bevcunto2_lahills", "stonewall3_la", 0);
    SetObjectMaterial(tmpobjid, 7, 9514, "711_sfw", "ws_carpark2", 0);
    return 1;
}