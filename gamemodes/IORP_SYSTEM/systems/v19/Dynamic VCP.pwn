new VCP:StringTop[MAX_PLAYERS][2000];
new VCP:String[MAX_PLAYERS][2000];
stock VCP:Init(playerid, page = 0) {
    format(VCP:StringTop[playerid], 500, "");
    format(VCP:String[playerid], 2000, "");
    CallRemoteFunction("VcpOnInit", "dd", playerid, page);
    return 1;
}

forward VcpOnResponse(playerid, page, response, listitem, const inputtext[]);
public VcpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) VCP:Init(playerid, page - 1);
    return 1;
}

forward VcpOnInit(playerid, page);
public VcpOnInit(playerid, page) {
    SortString(VCP:StringTop[playerid], VCP:StringTop[playerid]);
    SortString(VCP:String[playerid], VCP:String[playerid]);
    if (!strlen(VCP:String[playerid])) format(VCP:String[playerid], 2000, "Nothing On This Page.");
    else VCP:AddCommand(playerid, "Next Page");
    if (page != 0) VCP:AddCommand(playerid, "Back Page");
    if (strlen(VCP:StringTop[playerid]) > 0) format(VCP:String[playerid], 2000, "%s\n%s", VCP:StringTop[playerid], VCP:String[playerid]);
    return FlexPlayerDialog(playerid, "VcpOnInit", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]: {FFFFEE}VIP Control | Page: %d", page), VCP:String[playerid], "Select", "Close", page);
}

FlexDialog:VcpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return VCP:Init(playerid, page);
        if (IsStringSame("Next Page", inputtext)) return VCP:Init(playerid, page + 1);
        if (IsStringSame("Back Page", inputtext)) return VCP:Init(playerid, page - 1);
    }
    return CallRemoteFunction("VcpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
}

stock VCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(VCP:StringTop[playerid])) format(VCP:StringTop[playerid], 2000, "%s", command);
        else format(VCP:StringTop[playerid], 2000, "%s\n%s", VCP:StringTop[playerid], command);
    } else {
        if (!strlen(VCP:String[playerid])) format(VCP:String[playerid], 2000, "%s", command);
        else format(VCP:String[playerid], 2000, "%s\n%s", VCP:String[playerid], command);
    }
    return 1;
}

stock VCP:PanelMenu(playerid) {
    if (!IsPlayerAwaken(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You can't use vip commands at bedtime.");
    if (GetPlayerVIPLevel(playerid) < 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}please purchase vip access from iorp.in to continue");
    VCP:Init(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("vip", cmd)) return 1;
    VCP:PanelMenu(playerid);
    return ~1;
}

CMD:vip(playerid, const inputtext[]) {
    return VCP:PanelMenu(playerid);
}

//#snippet init_vip hook VIP_OnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tVIP_AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook VIP_OnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}