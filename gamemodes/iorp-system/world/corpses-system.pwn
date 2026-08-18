#define CorpSysTimer 60 * 1000

stock PlayerDeathCorp(playerid) {
    new Float:x, Float:y, Float:z, Float:r;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    GetPlayerFacingAngle(playerid, Float:r);
    new actorid = CreateDynamicActor(GetPlayerSkin(playerid), Float:x, Float:y, Float:z, Float:r, true, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    ApplyDynamicActorAnimation(actorid, "PED", "FLOOR_hit_f", 4.1, 0, 1, 1, 1, 1);
    SetPreciseTimer("RemoveCorp", CorpSysTimer, false, "d", actorid);
    return 1;
}

forward RemoveCorp(actorid);
public RemoveCorp(actorid) {
    DestroyDynamicActor(actorid);
    return 1;
}