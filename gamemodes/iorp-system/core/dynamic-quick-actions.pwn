new QuickActions:StringTop[MAX_PLAYERS][2000];
new QuickActions:String[MAX_PLAYERS][2000];
stock QuickActions:Init(playerid, targetid, page = 0) {
    if (!IsPlayerConnected(targetid)) return 1;
    format(QuickActions:StringTop[playerid], 500, "");
    format(QuickActions:String[playerid], 2000, "");
    CallRemoteFunction("QuickActionsOnInit", "ddd", playerid, targetid, page);
    return 1;
}

forward QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]);
public QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    return 1;
}

forward QuickActionsOnInit(playerid, targetid, page);
public QuickActionsOnInit(playerid, targetid, page) {
    if (!IsPlayerConnected(targetid)) return 1;
    SortString(QuickActions:StringTop[playerid], QuickActions:StringTop[playerid]);
    SortString(QuickActions:String[playerid], QuickActions:String[playerid]);
    if (!strlen(QuickActions:String[playerid])) format(QuickActions:String[playerid], 2000, "Nothing On This Page.");
    else QuickActions:AddCommand(playerid, "Next Page");
    if (page != 0) QuickActions:AddCommand(playerid, "Back Page");
    if (strlen(QuickActions:StringTop[playerid]) > 0) format(QuickActions:String[playerid], 2000, "%s\n%s", QuickActions:StringTop[playerid], QuickActions:String[playerid]);
    return FlexPlayerDialog(
        playerid, "QuickActionsOnInit", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[Alexa]: {FFFFEE}Quick Actions for %s | Page: %d", GetPlayerNameEx(targetid), page),
        QuickActions:String[playerid], "Select", "Close", page, GetPlayerNameEx(targetid)
    );
}

FlexDialog:QuickActionsOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new targetid;
    if (sscanf(payload, "u", targetid) || !IsPlayerConnected(targetid)) return 1;
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return QuickActions:Init(playerid, targetid, page);
        if (IsStringSame("Next Page", inputtext)) return QuickActions:Init(playerid, targetid, page + 1);
        if (IsStringSame("Back Page", inputtext)) return QuickActions:Init(playerid, targetid, page - 1);
    }
    return CallRemoteFunction("QuickActionsOnResponse", "ddddds", playerid, targetid, page, response, listitem, inputtext);
}

stock QuickActions:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(QuickActions:StringTop[playerid])) format(QuickActions:StringTop[playerid], 2000, "%s", command);
        else format(QuickActions:StringTop[playerid], 2000, "%s\n%s", QuickActions:StringTop[playerid], command);
    } else {
        if (!strlen(QuickActions:String[playerid])) format(QuickActions:String[playerid], 2000, "%s", command);
        else format(QuickActions:String[playerid], 2000, "%s\n%s", QuickActions:String[playerid], command);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (IsPlayerInAnyVehicle(playerid)) return 1;
    if ((newkeys & KEY_HANDBRAKE) && (newkeys & KEY_SPRINT)) {
        new targetplayer = GetPlayerTargetPlayer(playerid);
        if (targetplayer == INVALID_PLAYER_ID) return 1;
        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, Float:px, Float:py, Float:pz);
        if (IsPlayerInRangeOfPoint(targetplayer, 2, Float:px, Float:py, Float:pz) && playerid != targetplayer) {
            QuickActions:Init(playerid, targetplayer);
            return ~1;
        }
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsAndroidPlayer(playerid) && GetNearestPlayer(playerid, 2.0) != INVALID_PLAYER_ID) UCP:AddCommand(playerid, "Quick Player Options");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Quick Player Options", inputtext) && IsAndroidPlayer(playerid)) {
        new targetplayer = GetNearestPlayer(playerid, 2.0);
        if (targetplayer == INVALID_PLAYER_ID || targetplayer == playerid) return ~1;
        QuickActions:Init(playerid, targetplayer);
        return ~1;
    }
    return 1;
}

//#snippet init_quick_actions hook QuickActionsOnInit(playerid, targetid, page) {\n\tif(page != 0) return 1;\n\tQuickActions:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}