hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 16094, 191.1406, 1870.0391, 21.4766, 0.25);
    RemoveBuildingForPlayer(playerid, 968, -2436.8125, 495.4688, 29.6797, 0.25); //swat faction gate
    return 1;
}

hook OnGameModeInit() {
    CreateDynamicObject(19312, 191.14101, 1870.04004, 21.47660, 0.00000, 0.00000, 0.00000);
    return 1;
}