#define WALK_DEFAULT    0
#define WALK_NORMAL     1
#define WALK_PED        2
#define WALK_GANGSTA    3
#define WALK_GANGSTA2   4
#define WALK_OLD        5
#define WALK_FAT_OLD    6
#define WALK_FAT        7
#define WALK_LADY      	8
#define WALK_LADY2      9
#define WALK_WHORE      10
#define WALK_WHORE2     11
#define WALK_DRUNK     	12
#define WALK_BLIND     	13
new walktime[MAX_PLAYERS];
new WalkStyle[MAX_PLAYERS];

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (((newkeys & KEY_WALK && newkeys & KEY_UP) || (newkeys & KEY_WALK && newkeys & KEY_DOWN) || (newkeys & KEY_WALK && newkeys & KEY_LEFT) || (newkeys & KEY_WALK && newkeys & KEY_RIGHT)) ||
        ((oldkeys & KEY_WALK && newkeys & KEY_UP) || (oldkeys & KEY_WALK && newkeys & KEY_DOWN) || (oldkeys & KEY_WALK && newkeys & KEY_LEFT) || (oldkeys & KEY_WALK && newkeys & KEY_RIGHT)) ||
        ((newkeys & KEY_WALK && oldkeys & KEY_UP) || (newkeys & KEY_WALK && oldkeys & KEY_DOWN) || (newkeys & KEY_WALK && oldkeys & KEY_LEFT) || (newkeys & KEY_WALK && oldkeys & KEY_RIGHT)) &&
        GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
    }
    return 1;
}

forward WalkAnim(playerid);
public WalkAnim(playerid) {
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
    if (GetPlayerWalkingStyle(playerid) == WALK_NORMAL) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_player", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_PED) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_civi", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_GANGSTA) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_gang1", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_GANGSTA2) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_gang2", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_OLD) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_old", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_FAT_OLD) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_fatold", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_FAT) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_fat", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_LADY) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_LADY2) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_WHORE) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_WHORE2) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_DRUNK) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "WALK_drunk", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    } else if (GetPlayerWalkingStyle(playerid) == WALK_BLIND) {
        if ((keys & KEY_WALK && updown & KEY_UP) || (keys & KEY_WALK && updown & KEY_DOWN) || (keys & KEY_WALK && leftright & KEY_LEFT) || (keys & KEY_WALK && leftright & KEY_RIGHT)) {
            KillTimer(walktime[playerid]);
            ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.1, 1, 1, 1, 1, 1);
            walktime[playerid] = SetTimerEx("WalkAnim", 200, 0, "d", playerid);
        } else ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.0, 0, 0, 0, 0, 1), KillTimer(walktime[playerid]);
    }
    return 1;
}

stock SetPlayerWalkingStyle(playerid, style) {
    WalkStyle[playerid] = style;
    return 1;
}

stock GetPlayerWalkingStyle(playerid) {
    return WalkStyle[playerid];
}

SCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    SCP:AddCommand(playerid, "Set PED Style");
    return 1;
}

SCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Set PED Style", inputtext)) {
        PlayerWalkingStyleMenu(playerid);
        return ~1;
    }
    return 1;
}

stock PlayerWalkingStyleMenu(playerid) {
    return FlexPlayerDialog(
        playerid, "PlayerWalkingStyleMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}My Pocket", "Set Fighting Styles\nSet Walking Styles", "Select", "Close"
    );
}

FlexDialog:PlayerWalkingStyleMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Set Fighting Styles", inputtext)) return FlexPlayerDialog(playerid, "PlayerWalkingStyleMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}My Pocket", "Fight BOXING\nFight ELBOW\nFight KNEEHEAD\nFight KUNGFU\nFight GRABKICK\nFight NORMAL", "Select", "Close");
    if (IsStringSame("Set Walking Styles", inputtext)) return FlexPlayerDialog(playerid, "PlayerWalkingStyleMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}My Pocket", "Normal\nLow Walk\nGangsta\nGangsta2\nOld Walk\nOld Walk2\nNormal Walk2\nFemale Walk\nFemale Walk2\nWhore Walk\nFemale Walk3\nDrunk Walk\nBlind Walk\nDefault", "Select", "Close");
    if (IsStringSame("Fight BOXING", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
    if (IsStringSame("Fight ELBOW", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
    if (IsStringSame("Fight KNEEHEAD", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
    if (IsStringSame("Fight KUNGFU", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
    if (IsStringSame("Fight GRABKICK", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
    if (IsStringSame("Fight NORMAL", inputtext)) return SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
    if (IsStringSame("Normal", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_NORMAL);
    if (IsStringSame("Low Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_PED);
    if (IsStringSame("Gangsta", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_GANGSTA);
    if (IsStringSame("Gangsta2", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_GANGSTA2);
    if (IsStringSame("Old Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_OLD);
    if (IsStringSame("Old Walk2", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_FAT_OLD);
    if (IsStringSame("Normal Walk2", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_FAT);
    if (IsStringSame("Female Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_LADY);
    if (IsStringSame("Female Walk2", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_LADY2);
    if (IsStringSame("Whore Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_WHORE);
    if (IsStringSame("Female Walk3", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_WHORE2);
    if (IsStringSame("Drunk Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_DRUNK);
    if (IsStringSame("Blind Walk", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_BLIND);
    if (IsStringSame("Default", inputtext)) return SetPlayerWalkingStyle(playerid, WALK_DEFAULT);
    return 1;
}