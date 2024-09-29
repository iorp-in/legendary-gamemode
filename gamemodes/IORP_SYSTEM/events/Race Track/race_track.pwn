
#define Race_Track_Event_ID 3
#define race_track_event_virtualworld 14
#define race_track_event_interior 4

hook OnPlayerEventJoin(playerid, eventid) {
    if(eventid != Race_Track_Event_ID) return 1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Event System]: {FFFFEE}type /alexa espawn vehicleid to spawn vehicle.");
    SetPlayerVirtualWorldEx(playerid, race_track_event_virtualworld);
    SetPlayerInteriorEx(playerid, race_track_event_interior);
    SetPlayerPosEx(playerid, RandomEx(-530, -520), RandomEx(-3755, -3752), 4);
    Event:SetVehicleAuth(playerid, true);
    return 1;
}