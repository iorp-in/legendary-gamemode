new ACP:StringTop[MAX_PLAYERS][2000];
new ACP:String[MAX_PLAYERS][2000];

stock ACP:Init(playerid, page = 0) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    format(ACP:StringTop[playerid], 500, "");
    format(ACP:String[playerid], 2000, "");
    CallRemoteFunction("AcpOnInit", "dd", playerid, page);
    return 1;
}

forward AcpOnResponse(playerid, page, response, listitem, const inputtext[]);
public AcpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    return 1;
}

forward AcpOnInit(playerid, page);
public AcpOnInit(playerid, page) {
    SortString(ACP:StringTop[playerid], ACP:StringTop[playerid]);
    SortString(ACP:String[playerid], ACP:String[playerid]);
    if (!strlen(ACP:String[playerid])) format(ACP:String[playerid], 2000, "Nothing On This Page.");
    else ACP:AddCommand(playerid, "Next Page");
    if (page != 0) ACP:AddCommand(playerid, "Back Page");
    if (strlen(ACP:StringTop[playerid]) > 0) format(ACP:String[playerid], 2000, "%s\n%s", ACP:StringTop[playerid], ACP:String[playerid]);
    return FlexPlayerDialog(playerid, "AcpOnInit", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin Control Panel | Page: %d", page), ACP:String[playerid], "Select", "Close", page);
}

FlexDialog:AcpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return ACP:Init(playerid, page);
        else if (IsStringSame("Next Page", inputtext)) return ACP:Init(playerid, page + 1);
        else if (IsStringSame("Back Page", inputtext)) return ACP:Init(playerid, page - 1);
    }
    return CallRemoteFunction("AcpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
}

stock ACP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(ACP:StringTop[playerid])) format(ACP:StringTop[playerid], 2000, "%s", command);
        else format(ACP:StringTop[playerid], 2000, "%s\n%s", ACP:StringTop[playerid], command);
    } else {
        if (!strlen(ACP:String[playerid])) format(ACP:String[playerid], 2000, "%s", command);
        else format(ACP:String[playerid], 2000, "%s\n%s", ACP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("acp", cmd) || GetPlayerAdminLevel(playerid) < 1) return 1;
    ACP:Init(playerid);
    return ~1;
}

//#snippet init_acp hook AcpOnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tACP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook AcpOnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}