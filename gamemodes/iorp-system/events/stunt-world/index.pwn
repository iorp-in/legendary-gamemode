#define STUNT_WORLD_EVENT_ID 0
#define stunt_world_event_virtualworld 13

hook OnPlayerEventJoin(playerid, eventid) {
    if (eventid != STUNT_WORLD_EVENT_ID) return 1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Event System]:{FFFFEE}type /alexa espawn vehicleid to spawn vehicle and + to repair vehicle.");
    SetPlayerVirtualWorldEx(playerid, stunt_world_event_virtualworld);
    show_event_locations(playerid);
    SetPlayerTeleportKickStatus(playerid, false);
    SetPlayerSpeedHackKickStatus(playerid, false);
    SetPlayerAutoRepairAuth(playerid, true);
    Event:SetVehicleAuth(playerid, true);
    return 1;
}

hook OnPlayerEventLeave(playerid, eventid) {
    if (eventid != STUNT_WORLD_EVENT_ID) return 1;
    SetPlayerTeleportKickStatus(playerid, true);
    SetPlayerSpeedHackKickStatus(playerid, true);
    SetPlayerAutoRepairAuth(playerid, false);
    Event:SetVehicleAuth(playerid, false);
    return 1;
}

stock show_event_locations(playerid) {
    new string[512] = \
        "Locations\tDescription\n\
    Los Santos Airport\tmulti purpose stunt location\n\
    Los Santos Temple\tNRG Basketball location\n\
    Los Santos Verona Beach\tBike Skill location\n\
    Abandoned Airport\tmulti purpose stunt location\n\
    San Fierro Esplanade Nort\tmulti purpose stunt location\n\
    San Fierro Mount Chillad\tmulti purpose stunt location\n\
    San Fierro Whetstone\tWater Part location\n\
    San Fierro Airport\tBike Skill location\n\
    Las Venturas Bone Country\tchristmas in las vegas";
    FlexPlayerDialog(playerid, "SelectStuntWorldLocation", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}Stunt World: {FFFFFF}locations", string, "Select", "Leave");
    return 1;
}

FlexDialog:SelectStuntWorldLocation(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Event:Leave(playerid);
    if (!strcmp("Los Santos Airport", inputtext)) SetPlayerPosEx(playerid, RandomEx(1930, 1940), RandomEx(-2450, -2440), 15);
    if (!strcmp("Los Santos Temple", inputtext)) SetPlayerPosEx(playerid, RandomEx(1230, 1240), RandomEx(-1210, -1200), 203);
    if (!strcmp("Los Santos Verona Beach", inputtext)) SetPlayerPosEx(playerid, RandomEx(835, 845), RandomEx(-2010, -2000), 15);
    if (!strcmp("Abandoned Airport", inputtext)) SetPlayerPosEx(playerid, RandomEx(355, 365), RandomEx(2500, 2510), 20);
    if (!strcmp("San Fierro Esplanade Nort", inputtext)) SetPlayerPosEx(playerid, RandomEx(-2520, -2510), RandomEx(1485, 1495), 8);
    if (!strcmp("San Fierro Mount Chillad", inputtext)) SetPlayerPosEx(playerid, RandomEx(-2340, -2330), RandomEx(-1640, -1630), 485);
    if (!strcmp("San Fierro Whetstone", inputtext)) SetPlayerPosEx(playerid, RandomEx(-2095, -2085), RandomEx(-2825, -2815), 5);
    if (!strcmp("San Fierro Airport", inputtext)) SetPlayerPosEx(playerid, RandomEx(-1520, -1505), RandomEx(325, 335), 54);
    if (!strcmp("Las Venturas Bone Country", inputtext)) SetPlayerPosEx(playerid, RandomEx(255, 265), RandomEx(2905, 2915), 10);
    SendClientMessageEx(playerid, -1, "{4286f4}[Event System]: {FFFFEE}use /stuntlocations to change locations.");
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Event:IsInEvent(playerid) && Event:GetID(playerid) == STUNT_WORLD_EVENT_ID) UCP:AddCommand(playerid, "Stunt World Locations", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (!strcmp("Stunt World Locations", inputtext)) show_event_locations(playerid);
    return 1;
}