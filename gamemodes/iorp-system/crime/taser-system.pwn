#define     TASER_BASETIME  (30)         // player will get tased for at least 3 seconds
#define     TASER_INDEX     (5)         // setplayerattachedobject index for taser object

enum e_taser {
    bool:TaserEnabled,
    TaserCountdown,
    GetupTimer,
    TaserUpdate,
    bool:TaserCharged,
    ChargeTimer
};

new TaserData[MAX_PLAYERS][e_taser], PlayerBar:ChargeBar[MAX_PLAYERS];

new RGY[100] = { 0xFF0000FF, 0xFF0500FF, 0xFF0A00FF, 0xFF0F00FF, 0xFF1400FF, 0xFF1900FF, 0xFF1E00FF, 0xFF2300FF, 0xFF2800FF, 0xFF2D00FF, 0xFF3300FF, 0xFF3800FF, 0xFF3D00FF, 0xFF4200FF, 0xFF4700FF, 0xFF4C00FF, 0xFF5100FF, 0xFF5600FF, 0xFF5B00FF, 0xFF6000FF, 0xFF6600FF, 0xFF6B00FF, 0xFF7000FF, 0xFF7500FF, 0xFF7A00FF, 0xFF7F00FF, 0xFF8400FF, 0xFF8900FF, 0xFF8E00FF, 0xFF9300FF, 0xFF9900FF, 0xFF9E00FF, 0xFFA300FF, 0xFFA800FF, 0xFFAD00FF, 0xFFB200FF, 0xFFB700FF, 0xFFBC00FF, 0xFFC100FF, 0xFFC600FF, 0xFFCC00FF, 0xFFD100FF, 0xFFD600FF, 0xFFDB00FF, 0xFFE000FF, 0xFFE500FF, 0xFFEA00FF, 0xFFEF00FF, 0xFFF400FF, 0xFFF900FF, 0xFFFF00FF, 0xF9FF00FF, 0xF4FF00FF, 0xEFFF00FF, 0xEAFF00FF, 0xE4FF00FF, 0xDFFF00FF, 0xDAFF00FF, 0xD5FF00FF, 0xD0FF00FF, 0xCAFF00FF, 0xC5FF00FF, 0xC0FF00FF, 0xBBFF00FF, 0xB6FF00FF, 0xB0FF00FF, 0xABFF00FF, 0xA6FF00FF, 0xA1FF00FF, 0x9CFF00FF, 0x96FF00FF, 0x91FF00FF, 0x8CFF00FF, 0x87FF00FF, 0x82FF00FF, 0x7CFF00FF, 0x77FF00FF, 0x72FF00FF, 0x6DFF00FF, 0x68FF00FF, 0x62FF00FF, 0x5DFF00FF, 0x58FF00FF, 0x53FF00FF, 0x4EFF00FF, 0x48FF00FF, 0x43FF00FF, 0x3EFF00FF, 0x39FF00FF, 0x34FF00FF, 0x2EFF00FF, 0x29FF00FF, 0x24FF00FF, 0x1FFF00FF, 0x1AFF00FF, 0x14FF00FF, 0x0FFF00FF, 0x0AFF00FF, 0x05FF00FF, 0x00FF00FF };

hook OnGameModeInit() {
    for (new i; i < GetMaxPlayers(); ++i) {
        if (!IsPlayerConnected(i)) continue;
        TaserData[i][TaserEnabled] = false;
        TaserData[i][TaserCharged] = true;
        TaserData[i][TaserCountdown] = 0;
        TaserData[i][GetupTimer] = -1;
        TaserData[i][ChargeTimer] = -1;
        ApplyAnimation(i, "KNIFE", "null", 0.0, 0, 0, 0, 0, 0, 0);
        ApplyAnimation(i, "CRACK", "null", 0.0, 0, 0, 0, 0, 0, 0);
    }
    return 1;
}

hook OnGameModeExit() {
    for (new i; i < GetMaxPlayers(); ++i) {
        if (!IsPlayerConnected(i)) continue;
        if (!TaserData[i][TaserEnabled]) continue;
        RemovePlayerAttachedObject(i, TASER_INDEX);
        DestroyPlayerProgressBar(i, ChargeBar[i]);
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    TaserData[playerid][TaserEnabled] = false;
    TaserData[playerid][TaserCharged] = true;
    TaserData[playerid][TaserCountdown] = 0;
    TaserData[playerid][GetupTimer] = -1;
    TaserData[playerid][ChargeTimer] = -1;

    ApplyAnimation(playerid, "KNIFE", "null", 0.0, 0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "CRACK", "null", 0.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (TaserData[playerid][GetupTimer] != -1) {
        KillTimer(TaserData[playerid][GetupTimer]);
        TaserData[playerid][GetupTimer] = -1;
    }

    if (TaserData[playerid][ChargeTimer] != -1) {
        KillTimer(TaserData[playerid][ChargeTimer]);
        TaserData[playerid][ChargeTimer] = -1;
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (TaserData[playerid][TaserEnabled] && TaserData[playerid][TaserUpdate] < tickcount()) {
        if (GetWeaponSlot(GetPlayerWeapon(playerid)) == 0) {
            SetPlayerAttachedObject(playerid, TASER_INDEX, 18642, 6, 0.0795, 0.015, 0.0295, 180.0, 0.0, 0.0);
        } else {
            RemovePlayerAttachedObject(playerid, TASER_INDEX);
        }
        TaserData[playerid][TaserUpdate] = tickcount() + 100;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetWeaponSlot(GetPlayerWeapon(playerid)) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged]) {
        TaserData[playerid][TaserCharged] = false;

        new Float:x, Float:y, Float:z, Float:health, string[64];
        GetPlayerPos(playerid, x, y, z);
        PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
        ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
        SetPlayerProgressBarColour(playerid, ChargeBar[playerid], RGY[0]);
        SetPlayerProgressBarValue(playerid, ChargeBar[playerid], 0.0);
        TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 100, true, "i", playerid);

        foreach(new i:Player) {
            if (playerid == i) continue;
            if (TaserData[i][TaserCountdown] != 0) continue;
            if (IsPlayerInAnyVehicle(i)) continue;
            if (GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
            ClearAnimations(i, 1);
            TogglePlayerControllable(i, false);
            ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
            PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);
            GetPlayerHealth(i, health);
            TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
            format(string, sizeof(string), "TASER: {FFFFFF}You got tased for %d seconds!", TaserData[i][TaserCountdown]);
            SendClientMessageEx(i, 0x3498DBFF, string);
            format(string, sizeof(string), "~n~~n~~n~~b~~h~~h~Taser:~g~~h~~h~%d", TaserData[i][TaserCountdown]);
            GameTextForPlayer(i, string, 1000, 3);
            TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
            return ~1;
        }
    }
    return 1;
}

forward TaserGetUp(playerid);
public TaserGetUp(playerid) {
    if (TaserData[playerid][TaserCountdown] > 1) {
        new string[48];
        TaserData[playerid][TaserCountdown]--;
        format(string, sizeof(string), "~n~~n~~n~~b~~h~~h~Taser:~g~~h~~h~%d", TaserData[playerid][TaserCountdown]);
        GameTextForPlayer(playerid, string, 1000, 3);
    } else {
        TogglePlayerControllable(playerid, true);
        ClearAnimations(playerid, 1);
        KillTimer(TaserData[playerid][GetupTimer]);
        TaserData[playerid][GetupTimer] = -1;
        TaserData[playerid][TaserCountdown] = 0;
        GameTextForPlayer(playerid, "~n~~n~~n~~g~~h~~h~Taser Effect Clear", 1000, 3);
    }
    return 1;
}

forward ChargeUp(playerid);
public ChargeUp(playerid) {
    new Float:charge = GetPlayerProgressBarValue(playerid, ChargeBar[playerid]);
    charge++;
    if (charge >= 100.0) {
        charge = 100.0;
        TaserData[playerid][TaserCharged] = true;
        KillTimer(TaserData[playerid][ChargeTimer]);
        TaserData[playerid][ChargeTimer] = -1;
        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
        SendClientMessageEx(playerid, 0x3498DBFF, "TASER: {FFFFFF}Taser charged and ready to use.");
    }

    if (charge < 100.0) SetPlayerProgressBarColour(playerid, ChargeBar[playerid], RGY[floatround(charge)]);
    SetPlayerProgressBarValue(playerid, ChargeBar[playerid], charge);
    return 1;
}

stock TaserCommand(playerid) {
    if (!TaserData[playerid][TaserCharged]) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't use this command while your taser is charging.");
    TaserData[playerid][TaserEnabled] = !TaserData[playerid][TaserEnabled];
    new string[64];
    format(string, sizeof(string), "TASER: {FFFFFF}Taser %s.", (TaserData[playerid][TaserEnabled]) ? ("{2ECC71}on") : ("{4286f4}off"));
    SendClientMessageEx(playerid, 0x3498DBFF, string);

    if (TaserData[playerid][TaserEnabled]) {
        SetPlayerArmedWeapon(playerid, 0);
        SetPlayerAttachedObject(playerid, TASER_INDEX, 18642, 6, 0.0795, 0.015, 0.0295, 180.0, 0.0, 0.0);
        TaserData[playerid][TaserUpdate] = tickcount() + 100;

        ChargeBar[playerid] = CreatePlayerProgressBar(playerid, 550.000000, 110.000000, 60.000000, 3.000000, 0x00FF00FF, 100.0, 0);
        SetPlayerProgressBarValue(playerid, ChargeBar[playerid], 100.0);
        ShowPlayerProgressBar(playerid, ChargeBar[playerid]);
    } else {
        RemovePlayerAttachedObject(playerid, TASER_INDEX);
        DestroyPlayerProgressBar(playerid, ChargeBar[playerid]);
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && IsPlayerInAnyVehicle(playerid) && Faction:IsPlayerSigned(playerid)) {
        new allow_vehicle[] = { 497, 523, 596, 597, 598, 599 };
        if (IsArrayContainNumber(allow_vehicle, GetVehicleModel(GetPlayerVehicleID(playerid)))) UCP:AddCommand(playerid, "Taser");
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Taser", inputtext)) TaserCommand(playerid);
    return 1;
}