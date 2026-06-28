#define Max_Flash_Zone 20
enum FlashZone:enumd {
    FlashZone:StartedAt,
    FlashZone:FlashSeconds,
    FlashZone:zoneID
}
new FlashZone:data[Max_Flash_Zone][FlashZone:enumd];
new Iterator:flashZones < Max_Flash_Zone > ;

hook OnGameModeInit() {
    SetPreciseTimer("FlashingZoneTimer", 5 * 1000, true);
    return 1;
}

hook OnPlayerConnect(playerid) {
    foreach(new id:flashZones) {
        if (FlashZone:data[id][FlashZone:zoneID] != -1) {
            ShowZoneForPlayer(playerid, FlashZone:data[id][FlashZone:zoneID], 0xFFFF00AA, 0xFFFFFFFF, 0x5050FFFF);
            ZoneFlashForPlayer(playerid, FlashZone:data[id][FlashZone:zoneID], 0xFF0000AA);
            ZoneBordersFlashForPlayer(playerid, FlashZone:data[id][FlashZone:zoneID], 0x5050FFAA);
        }
    }
    return 1;
}

forward FlashingZoneTimer();
public FlashingZoneTimer() {
    if (Iter_Count(flashZones) < 1) return 1;
    foreach(new id:flashZones) {
        if (gettime() - FlashZone:data[id][FlashZone:StartedAt] > FlashZone:data[id][FlashZone:FlashSeconds]) {
            FlashZone:Remove(id);
            Iter_SafeRemove(flashZones, id, id);
        }
    }
    return 1;
}

stock FlashZone:Create(Float:minX, Float:minY, Float:maxX, Float:maxY, durationInSeconds = 60) {
    new id = Iter_Free(flashZones);
    if (id == INVALID_ITERATOR_SLOT) return -1;
    Iter_Add(flashZones, id);
    new zoneid = CreateZone(Float:minX, Float:minY, Float:maxX, Float:maxY);
    ShowZoneForAll(zoneid, 0xFFFF00AA, 0xFFFFFFFF, 0x5050FFFF);
    ZoneBordersFlashForAll(zoneid, 0x5050FFAA);
    ZoneFlashForAll(zoneid, 0xFF0000AA);
    FlashZone:data[id][FlashZone:zoneID] = zoneid;
    FlashZone:data[id][FlashZone:StartedAt] = gettime();
    FlashZone:data[id][FlashZone:FlashSeconds] = durationInSeconds;
    return zoneid;
}

stock FlashZone:Remove(id) {
    if (FlashZone:data[id][FlashZone:zoneID] != -1) DestroyZone(FlashZone:data[id][FlashZone:zoneID]);
    FlashZone:data[id][FlashZone:zoneID] = -1;
    FlashZone:data[id][FlashZone:StartedAt] = 0;
    FlashZone:data[id][FlashZone:FlashSeconds] = 0;
    return 1;
}

// cmd:testflash(playerid, const params[]) {
//     new Float:pPos[9];
//     GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
//     new MapZone:mzoneid = MapZone:GetMapZoneAtPoint2D(pPos[0], pPos[1]);
//     if(MapZone:mzoneid == INVALID_MAP_ZONE_ID || GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorldID(playerid) != 0) {
//         SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you are in unknow region");
//         return 1;
//     }
//     GetMapZoneAreaPos(MapZone:mzoneid, pPos[3], pPos[4], pPos[5], pPos[6], pPos[7], pPos[8]);
//     FlashZone:Create(pPos[3], pPos[4], pPos[6], pPos[7], 10);
//     return 1;
// }