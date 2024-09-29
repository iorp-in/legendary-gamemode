#define MAX_GUN_DROP 200

new const GunObjects[47] = { 0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324, 325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352, 353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 368, 371 };
enum GunDrop:DataEnum {
    bool:GunDrop:ObYes,
    Float:GunDrop:ObPos[3],
    GunDrop:ObID,
    GunDrop:ObData[2],
    Text3D:LabelGun,
    GunDrop:ObTime
};
new GunDrop:Data[MAX_GUN_DROP][GunDrop:DataEnum];
new Iterator:GunDrops < MAX_GUN_DROP > ;

stock GunDrop:IsValidID(gundropid) {
    return Iter_Contains(GunDrops, gundropid);
}

stock GunDrop:GetWeaponID(gundropid) {
    return GunDrop:Data[gundropid][GunDrop:ObData][0];
}

stock GunDrop:GetWeaponAmmo(gundropid) {
    return GunDrop:Data[gundropid][GunDrop:ObData][1];
}

new GunDrop:SysEnabled = 1;
hook OnGameModeInit() {
    for (new gundropid = 0; gundropid < MAX_GUN_DROP; gundropid++) {
        DestroyDynamicObjectEx(GunDrop:Data[gundropid][GunDrop:ObID]);
        GunDrop:Data[gundropid][GunDrop:ObData][1] = 0;
        GunDrop:Data[gundropid][GunDrop:ObPos][0] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObPos][1] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObPos][2] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObYes] = false;
        GunDrop:Data[gundropid][GunDrop:ObTime] = 0;
        GunDrop:Data[gundropid][GunDrop:ObID] = -1;
        DestroyDynamic3DTextLabel(GunDrop:Data[gundropid][LabelGun]);
        GunDrop:Data[gundropid][GunDrop:ObData][0] = 0;
    }
    return 1;
}

hook OnGameModeExit() {
    for (new gundropid = 0; gundropid < MAX_GUN_DROP; gundropid++) {
        DestroyDynamicObjectEx(GunDrop:Data[gundropid][GunDrop:ObID]);
        GunDrop:Data[gundropid][GunDrop:ObData][1] = 0;
        GunDrop:Data[gundropid][GunDrop:ObPos][0] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObPos][1] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObPos][2] = 0.0;
        GunDrop:Data[gundropid][GunDrop:ObYes] = false;
        GunDrop:Data[gundropid][GunDrop:ObTime] = 0;
        GunDrop:Data[gundropid][GunDrop:ObID] = -1;
        DestroyDynamic3DTextLabel(GunDrop:Data[gundropid][LabelGun]);
        GunDrop:Data[gundropid][GunDrop:ObData][0] = 0;
    }
    return 1;
}

stock GunDrop:PlaceWeapon(playerid, GunIDEx, GunAmmoEx, bool:withoutMsg = false) {
    if (!GunDrop:SysEnabled) return 1;
    new gundropid = Iter_Free(GunDrops);
    if (gundropid == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "unable to drop your gun");
    Iter_Add(GunDrops, gundropid);
    DestroyDynamicObjectEx(GunDrop:Data[gundropid][GunDrop:ObID]);
    GunDrop:Data[gundropid][GunDrop:ObData][1] = 0;
    GunDrop:Data[gundropid][GunDrop:ObPos][0] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObPos][1] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObPos][2] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObYes] = false;
    GunDrop:Data[gundropid][GunDrop:ObTime] = 0;
    GunDrop:Data[gundropid][GunDrop:ObID] = -1;
    DestroyDynamic3DTextLabel(GunDrop:Data[gundropid][LabelGun]);
    GunDrop:Data[gundropid][GunDrop:ObData][0] = 0;
    GunDrop:Data[gundropid][GunDrop:ObYes] = true;
    RemovePlayerWeapon(playerid, GunIDEx);
    GunDrop:Data[gundropid][GunDrop:ObData][0] = GunIDEx;
    GunDrop:Data[gundropid][GunDrop:ObData][1] = GunAmmoEx;
    GunDrop:Data[gundropid][GunDrop:ObTime] = GetTickCount();
    GetPlayerPos(playerid, GunDrop:Data[gundropid][GunDrop:ObPos][0], GunDrop:Data[gundropid][GunDrop:ObPos][1], GunDrop:Data[gundropid][GunDrop:ObPos][2]);
    GunDrop:Data[gundropid][GunDrop:ObID] = CreateDynamicObject(GunObjects[GunIDEx], GunDrop:Data[gundropid][GunDrop:ObPos][0], GunDrop:Data[gundropid][GunDrop:ObPos][1], GunDrop:Data[gundropid][GunDrop:ObPos][2] - 1, 93.7, 120.0, 120.0);
    GunDrop:Data[gundropid][LabelGun] = CreateDynamic3DTextLabel(sprintf("{FFFFFF} Weapon: {FF6F00}%s \n {FFFFFF} Thrown: {FF6F00} %s \n{FFFFFF}Submit: {FF6F00} N", GetWeaponNameEx(GunDrop:GetWeaponID(gundropid)), GetPlayerNameEx(playerid)), 0x317CDFFF, GunDrop:Data[gundropid][GunDrop:ObPos][0], GunDrop:Data[gundropid][GunDrop:ObPos][1], GunDrop:Data[gundropid][GunDrop:ObPos][2] - 0.5, 3.0);
    if (!withoutMsg) SendClientMessageEx(playerid, -1, sprintf("You dropped {FF6F00}%s", GetWeaponNameEx(GunDrop:GetWeaponID(gundropid))));
    if (!withoutMsg) GunDrop:ProxDetector(13.0, playerid, sprintf("%s put the weapon on the ground", GetPlayerNameEx(playerid)), 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF);
    return 1;
}

stock GunDrop:Remove(gundropid) {
    if (!GunDrop:IsValidID(gundropid)) return 1;
    Iter_Remove(GunDrops, gundropid);
    DestroyDynamicObjectEx(GunDrop:Data[gundropid][GunDrop:ObID]);
    GunDrop:Data[gundropid][GunDrop:ObData][1] = 0;
    GunDrop:Data[gundropid][GunDrop:ObPos][0] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObPos][1] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObPos][2] = 0.0;
    GunDrop:Data[gundropid][GunDrop:ObYes] = false;
    GunDrop:Data[gundropid][GunDrop:ObTime] = 0;
    GunDrop:Data[gundropid][GunDrop:ObID] = -1;
    GunDrop:Data[gundropid][GunDrop:ObData][0] = 0;
    DestroyDynamic3DTextLabel(GunDrop:Data[gundropid][LabelGun]);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (Event:IsInEvent(playerid)) return 1;
    new data_weaponid, data_ammo;
    // looping through all weapon slots (0 - 12)
    for (new i; i < 13; i++) {
        GetPlayerWeaponData(playerid, i, data_weaponid, data_ammo); // get weaponid and ammo
        if (!data_weaponid || !data_ammo) continue; // don't insert if there's no weapon in this slot
        GunDrop:PlaceWeapon(playerid, data_weaponid, data_ammo, true);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (IsPlayerFreezedForDeath(playerid)) return 1;
    if (newkeys == KEY_YES) {
        if (GetPlayerWeapon(playerid) != 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GunDrop:SysEnabled) {
            if (!IsPlayerConnected(playerid)) return 1;
            new GunIDEx = GetPlayerWeapon(playerid);
            new GunAmmoEx = GetPlayerAmmo(playerid);
            GunDrop:PlaceWeapon(playerid, GunIDEx, GunAmmoEx);
            return ~1;
        }
    } else if (newkeys == KEY_NO) {
        if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GunDrop:SysEnabled) {
            new gundropid = GunDrop:GetNearestDropWeapon(playerid);
            if (GunDrop:IsValidID(gundropid)) {
                GivePlayerWeaponEx(playerid, GunDrop:GetWeaponID(gundropid), GunDrop:GetWeaponAmmo(gundropid));
                if (IsTimePassedForPlayer(playerid, "DropWarn", 60)) GunDrop:ProxDetector(
                    13.0, playerid, sprintf("%s picked up the weapon from the ground", GetPlayerNameEx(playerid)),
                    0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF, 0xDD90FFFF
                );
                SendClientMessageEx(playerid, -1, sprintf("You have selected {FF6F00}%s", GetWeaponNameEx(GunDrop:GetWeaponID(gundropid))));
                GunDrop:Remove(gundropid);
                return ~1;
            }
        }
    }
    return 1;
}

stock GunDrop:GetNearestDropWeapon(playerid) {
    foreach(new gundropid: GunDrops) {
        if (IsPlayerInRangeOfPoint(playerid, 1.5, GunDrop:Data[gundropid][GunDrop:ObPos][0], GunDrop:Data[gundropid][GunDrop:ObPos][1], GunDrop:Data[gundropid][GunDrop:ObPos][2])) return gundropid;
    }
    return -1;
}

stock GunDrop:ProxDetector(Float:radius = 30.0, playerid, const text[], col1 = 0xFFFFFFFF, col2 = 0xCCCCCCFF, col3 = 0x999999FF, col4 = 0x666666FF, col5 = 0x333333FF) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Float:dist, virtualworld = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    foreach(new i:Player) {
        if (virtualworld != GetPlayerVirtualWorld(i) || interior != GetPlayerInterior(i)) continue;
        dist = GetPlayerDistanceFromPoint(i, x, y, z);
        if (dist < radius / 16) SendClientMessageEx(i, col1, text);
        else if (dist < radius / 8) SendClientMessageEx(i, col2, text);
        else if (dist < radius / 4) SendClientMessageEx(i, col3, text);
        else if (dist < radius / 2) SendClientMessageEx(i, col4, text);
        else if (dist < radius) SendClientMessageEx(i, col5, text);
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Drop Gun System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Drop Gun System", inputtext)) GunDrop:AdminMenu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "drop gun system") || !IsPlayerMasterAdmin(playerid)) return 1;
    GunDrop:AdminMenu(playerid);
    return ~1;
}

stock GunDrop:AdminMenu(playerid) {
    new string[512];
    strcat(string, sprintf("Remove Guns\t%d\n", Iter_Count(GunDrops)));
    strcat(string, sprintf("Script\t%s\n", (GunDrop:SysEnabled) ? ("Disconnect") : ("Enable")));
    return FlexPlayerDialog(playerid, "GunDropAdminMenu", DIALOG_STYLE_TABLIST, "Settings {0000FF} Drop Gun System", string, "Next", "Cancel");
}

FlexDialog:GunDropAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Remove Guns")) {
        foreach(new gundropid:GunDrops) GunDrop:Remove(gundropid);
        AlexaMsg(playerid, "removed all weapons");
    }
    if (IsStringSame(inputtext, "Script")) {
        GunDrop:SysEnabled = !GunDrop:SysEnabled;
    }
    return GunDrop:AdminMenu(playerid);
}