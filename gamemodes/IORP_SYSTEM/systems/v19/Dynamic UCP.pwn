new UCP:StringTop[MAX_PLAYERS][2000];
new UCP:String[MAX_PLAYERS][2000];

stock UCP:Init(playerid, page = 0) {
    format(UCP:StringTop[playerid], 500, "");
    format(UCP:String[playerid], 2000, "");
    CallRemoteFunction("UcpOnInit", "dd", playerid, page);
    return 1;
}

forward UcpOnResponse(playerid, page, response, listitem, const inputtext[]);
public UcpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) UCP:Init(playerid, page - 1);
    return 1;
}

forward UcpOnInit(playerid, page);
public UcpOnInit(playerid, page) {
    SortString(UCP:StringTop[playerid], UCP:StringTop[playerid]);
    SortString(UCP:String[playerid], UCP:String[playerid]);
    if (!strlen(UCP:String[playerid])) UCP:AddCommand(playerid, ">> Nothing on this page");
    UCP:AddCommand(playerid, "Next Page");
    if (page != 0) UCP:AddCommand(playerid, "Back Page");
    if (strlen(UCP:StringTop[playerid]) > 0) format(UCP:String[playerid], 2000, "%s\n%s", UCP:StringTop[playerid], UCP:String[playerid]);
    return FlexPlayerDialog(playerid, "UCPMenuDialog", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]: {FFFFEE}Your Pocket | Page: %d", page), UCP:String[playerid], "Select", "Close", page);
}

FlexDialog:UCPMenuDialog(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (response) {
        if (IsStringSame(">> Nothing on this page", inputtext)) return UCP:Init(playerid, page);
        else if (IsStringSame("Next Page", inputtext)) return UCP:Init(playerid, page + 1);
        else if (IsStringSame("Back Page", inputtext)) return UCP:Init(playerid, page - 1);
    }
    return CallRemoteFunction("UcpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
}

stock UCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(UCP:StringTop[playerid])) format(UCP:StringTop[playerid], 2000, "%s", command);
        else format(UCP:StringTop[playerid], 2000, "%s\n%s", UCP:StringTop[playerid], command);
    } else {
        if (!strlen(UCP:String[playerid])) format(UCP:String[playerid], 2000, "%s", command);
        else format(UCP:String[playerid], 2000, "%s\n%s", UCP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("pocket", cmd) || GetPlayerAdminLevel(playerid) < 1) return 1;
    UCP:Init(playerid);
    return ~1;
}

CMD:p(playerid, const inputtext[]) {
    return UCP:PocketMenu(playerid);
}

CMD:pocket(playerid, const inputtext[]) {
    return UCP:PocketMenu(playerid);
}

new bool:PlayerUCPStatus[MAX_PLAYERS];
stock GetPlayerUCPStatus(playerid) {
    return PlayerUCPStatus[playerid];
}
stock SetPlayerUCPStatus(playerid, bool:status) {
    PlayerUCPStatus[playerid] = status;
    return PlayerUCPStatus[playerid];
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPlayerUCPStatus(playerid, false);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    // if(newkeys == KEY_NO && Pump_Closest(playerid) == -1 && GetPlayerNearestDropGun(playerid) == -1) SelectTextDraw(playerid, 0x00FF00FF);
    if (IsPlayerInAnyVehicle(playerid)) {
        if ((newkeys & KEY_CROUCH) && (newkeys & KEY_HANDBRAKE)) {
            UCP:PocketMenu(playerid);
            return ~1;
        }
    } else {
        if ((newkeys & KEY_CTRL_BACK) && (newkeys & KEY_SPRINT)) {
            UCP:PocketMenu(playerid);
            return ~1;
        }
    }
    return 1;
}

stock User_Panel(playerid) {
    SetPlayerUCPStatus(playerid, false);
    if (!GetPlayerUCPStatus(playerid)) return 1;
    return UCP:PocketMenu(playerid);
}

stock UCP:PocketMenu(playerid) {
    if (!IsPlayerAwaken(playerid)) {
        DeactivateSleep(playerid);
    }
    SetPlayerUCPStatus(playerid, true);
    UCP:Init(playerid);
    return 1;
}

// new Text:Ucp_Logo;
// hook OnGameModeInit() {
//     Dialog_UCP = Dialog:GetFreeID();
//     Ucp_Logo = TextDrawCreate(0.000000, 415.000000, "IORP");
//     Database:AddBool("ShowUcpIcon");
//     TextDrawColor(Text:Ucp_Logo, -1);
//     TextDrawUseBox(Text:Ucp_Logo, 0);
//     TextDrawBoxColor(Text:Ucp_Logo, 255);
//     TextDrawBackgroundColor(Text:Ucp_Logo, 0);
//     TextDrawAlignment(Text:Ucp_Logo, 0);
//     TextDrawFont(Text:Ucp_Logo, 5);
//     TextDrawLetterSize(Text:Ucp_Logo, 3.200000, 5.099999);
//     TextDrawTextSize(Text:Ucp_Logo, 30.000000, 30.000000);
//     TextDrawSetOutline(Text:Ucp_Logo, 0);
//     TextDrawSetShadow(Text:Ucp_Logo, 0);
//     TextDrawSetProportional(Text:Ucp_Logo, 0);
//     TextDrawSetSelectable(Text:Ucp_Logo, 1);
//     TextDrawSetPreviewModel(Text:Ucp_Logo, 19273);
//     TextDrawSetPreviewRot(Text:Ucp_Logo, 0.000000, 0.000000, 0.000000, 0.699999);
//     TextDrawSetPreviewVehCol(Text:Ucp_Logo, 0, 0);
//     return 1;
// }
// 
// hook OnPlayerLogin(playerid) {
//     if(IsAndroidPlayer(playerid)) ShowUcpTextDraw(playerid);
//     return 1;
// }
// 
// hook OnAndroidModeEnabled(playerid) {
//     ShowUcpTextDraw(playerid);
//     return 1;
// }
// 
// hook OnAndroidModeDisabled(playerid) {
//     HideUcpTextDraw(playerid);
//     return 1;
// }
// 
// hook OnPlayerDisconnect(playerid, reason) {
//     HideUcpTextDraw(playerid);
//     return 1;
// }
// 
// hook OnPlayerClickTextDraw(playerid, Text:clickedid) {
//     if(clickedid == Ucp_Logo) {
//         UCP:PocketMenu(playerid);
//         CancelSelectTextDraw(playerid);
//         return ~1;
//     }
//     return 1;
// }
// 
// stock ShowUcpTextDraw(playerid) {
//     TextDrawShowForPlayer(playerid, Text:Ucp_Logo);
//     return 1;
// }
// 
// stock HideUcpTextDraw(playerid) {
//     TextDrawHideForPlayer(playerid, Text:Ucp_Logo);
//     return 1;
// }

//#snippet init_ucp UCP:OnInit(playerid, page) {\n\tif (page != 0) return 1;\n\tUCP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nUCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif (!response || page != 0) return 1;\n\tif (IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}