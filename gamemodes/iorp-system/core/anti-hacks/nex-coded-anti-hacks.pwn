
// Invisible Hack // depends on specting system //

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(IsPlayerNPC(playerid)) return 1;
    if(newstate == PLAYER_STATE_SPECTATING && !GetPlayerSpectatingStatus(playerid)) SpawnPlayer(playerid);
    return 1;
}
// END
// Anti Skin Hack
new Nex_AntiSkinHack[MAX_PLAYERS];

hook OnSetPlayerSkin(playerid, skinid) {
    Nex_AntiSkinHack[playerid] = skinid;
    return 1;
}

hook OnPlayerSpawn(playerid) {
    Nex_AntiSkinHack[playerid] = GetPlayerSkin(playerid);
    return 1;
}

hook OnPlayerSkinChange(playerid, newskin, oldskin) {
    if(Nex_AntiSkinHack[playerid] != newskin) SetPlayerSkin(playerid, Nex_AntiSkinHack[playerid]);
    return 1;
}
// END
// Anti Interior Hack
new Nex_AntiInterior[MAX_PLAYERS];

hook OnSetPlayerInteriorEx(playerid, interiorid) {
    Nex_AntiInterior[playerid] = interiorid;
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    if(Nex_AntiInterior[playerid] != newinteriorid) SetPlayerInterior(playerid, Nex_AntiInterior[playerid]);
    return 1;
}
// Anti Virtual World Hack
new Nex_AntiVW[MAX_PLAYERS];

hook OnSetPlayerVWEx(playerid, worldid) {
    Nex_AntiVW[playerid] = worldid;
    return 1;
}

hook OnPlayerVirtualWorld(playerid, newvirtualworld, oldvirtualworld) {
    if(Nex_AntiVW[playerid] != newvirtualworld) SetPlayerVirtualWorld(playerid, Nex_AntiVW[playerid]);
    return 1;
}
// Vehicle Fly
new Nex_VFlyPosTick[MAX_PLAYERS];
new Float:Nex_VFlyPos[MAX_PLAYERS][3];

hook OnPlayerUpdate(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    if(gettime() - Nex_VFlyPosTick[playerid] < 2) return 1;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    new Float:ac_zDiff = z - Nex_VFlyPos[playerid][2];
    if(z > 10 && ac_zDiff > 50 && IsPlayerInAnyVehicle(playerid) && !IsPlayerInFlyableVehicle(playerid) && !Bit_Get(AC_SafeTP, playerid)) CallRemoteFunction("OnVehicleFlyHack", "df", playerid, ac_zDiff);
    Nex_VFlyPos[playerid][0] = x;
    Nex_VFlyPos[playerid][1] = y;
    Nex_VFlyPos[playerid][2] = z;
    Nex_VFlyPosTick[playerid] = gettime();
    return 1;
}

forward OnVehicleFlyHack(playerid, Float:distance);
public OnVehicleFlyHack(playerid, Float:distance) {
    GameTextForPlayer(playerid, "~r~Vehicle Fly Hack ~w~Detected", 3000, 3);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE} you have done unauthorised vehicle fly hack, distance: %f", distance));
    freezeEx(playerid, 10 * 1000);
    return 1;
}

// anti vehicle mod

hook OnVehicleMod(playerid, vehicleid, componentid) {
    if(!IsValidComponentForVehicle(vehicleid, componentid)) return Kick(playerid);
    return 1;
}