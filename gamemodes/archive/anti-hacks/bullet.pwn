

enum {
    BULLET_INVALID_WEAPON_ID,
    BULLET_INVALID_HIT_TYPE,
    BULLET_INVALID_HIT_ID,
    BULLET_OUT_OF_RANGE,
    BULLET_RAPID_SHOT
};

static s_iLastBulletShot[MAX_PLAYERS];
new SilentAimCount[MAX_PLAYERS], ProAimCount[MAX_PLAYERS], TintaApasata[MAX_PLAYERS];

stock static IsFirearmWeapon(weaponid) return (22 <= weaponid <= 34) || weaponid == 38;

hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    s_iLastBulletShot[playerid] = 0;
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
    new string[200];
    if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1) {
        new Float:cood[6], Float:DistantaAim, armaaim[128];
        GetPlayerPos(hitid, cood[0], cood[1], cood[2]);
        DistantaAim = GetPlayerDistanceFromPoint(playerid, cood[0], cood[1], cood[2]);
        GetWeaponName(weaponid, armaaim, sizeof(armaaim));

        if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && DistantaAim > 1 && DistantaAim < 31 && TintaApasata[playerid] == 1) {
            SilentAimCount[playerid]++;
            if(SilentAimCount[playerid] >= 10) {
                SilentAimCount[playerid] = 0;
                format(string, sizeof(string), "Warning: %s(%d) possible use Silent Aim cheat with %s (Distance: %i meters)", GetPlayerNameEx(playerid), playerid, armaaim, floatround(DistantaAim));
                SendAdminLogMessage(string);
            }
            return ~0;
        }
        GetPlayerLastShotVectors(playerid, cood[0], cood[1], cood[2], cood[3], cood[4], cood[5]);
        if(!IsPlayerInRangeOfPoint(hitid, 3.0, cood[3], cood[4], cood[5])) {
            ProAimCount[playerid]++;
            if(ProAimCount[playerid] >= 5) {
                ProAimCount[playerid] = 0;
                format(string, sizeof(string), "Warning: %s(%d) possible use ProAim cheat with: %s (Distance: %i meters)", GetPlayerNameEx(playerid), playerid, armaaim, floatround(DistantaAim));
                SendAdminLogMessage(string);
                return ~0;
            }
        }
    }
    new tick = GetTickCount();
    if((tick - s_iLastBulletShot[playerid]) <= 40 && weaponid != WEAPON_UZI && weaponid != WEAPON_TEC9 && weaponid != WEAPON_MP5 && weaponid != WEAPON_MINIGUN) return CallRemoteFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_RAPID_SHOT), 0;
    else if(!IsFirearmWeapon(weaponid)) return CallRemoteFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_WEAPON_ID), 0;
    else if(!(BULLET_HIT_TYPE_NONE <= hittype <= BULLET_HIT_TYPE_PLAYER_OBJECT)) return CallRemoteFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_HIT_TYPE), 0;
    else if((hittype == BULLET_HIT_TYPE_NONE) && GetPlayerDistanceFromPoint(playerid, fX, fY, fZ) > 300.0 && (fX != 0.0 && fY != 0.0 && fZ != 0.0)) return CallRemoteFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_OUT_OF_RANGE), 0;
    else if((hittype == BULLET_HIT_TYPE_PLAYER && !IsPlayerConnected(hitid)) || (hittype == BULLET_HIT_TYPE_VEHICLE && !IsValidVehicle(hitid)) || (hittype == BULLET_HIT_TYPE_OBJECT && !IsValidObject(hitid)) || (hittype == BULLET_HIT_TYPE_PLAYER_OBJECT && !IsValidPlayerObject(playerid, hitid))) return CallRemoteFunction("OnPlayerInvalidBulletShot", "ii", playerid, BULLET_INVALID_HIT_ID), 0;
    s_iLastBulletShot[playerid] = tick;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_HANDBRAKE && !IsPlayerInAnyVehicle(playerid)) TintaApasata[playerid] = 1;
    else if(oldkeys & KEY_HANDBRAKE) TintaApasata[playerid] = 0;
    return 1;
}

forward OnPlayerInvalidBulletShot(playerid, reason);
public OnPlayerInvalidBulletShot(playerid, reason) {
    new string[512];
    format(string, sizeof string, "Invalid Bullet Data PlayerID: %s, Reason: %d", GetPlayerNameEx(playerid), reason);
    SendAdminLogMessage(string);
    ResetPlayerWeaponsEx(playerid);
    format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Invalid bullet data has been detected, disarmed you for security precautions");
    SendClientMessageEx(playerid, COLOR_GREY, string);
    return 1;
}