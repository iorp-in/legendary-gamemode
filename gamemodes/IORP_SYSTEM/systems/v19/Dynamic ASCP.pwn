new ASCP:StringTop[MAX_PLAYERS][2000];
new ASCP:String[MAX_PLAYERS][2000];
stock Ascp_Init(playerid, page = 0) {
    format(ASCP:StringTop[playerid], 500, "");
    format(ASCP:String[playerid], 2000, "");
    CallRemoteFunction("AscpOnInit", "dd", playerid, page);
    return 1;
}

forward AscpOnResponse(playerid, page, response, listitem, const inputtext[]);
public AscpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) Ascp_Init(playerid, page - 1);
    return 1;
}

forward AscpOnInit(playerid, page);
public AscpOnInit(playerid, page) {
    SortString(ASCP:StringTop[playerid], ASCP:StringTop[playerid]);
    SortString(ASCP:String[playerid], ASCP:String[playerid]);
    if (!strlen(ASCP:String[playerid])) format(ASCP:String[playerid], 2000, "Nothing On This Page.");
    else ASCP:AddCommand(playerid, "Next Page");
    if (page != 0) ASCP:AddCommand(playerid, "Back Page");
    if (strlen(ASCP:StringTop[playerid]) > 0) format(ASCP:String[playerid], 2000, "%s\n%s", ASCP:StringTop[playerid], ASCP:String[playerid]);
    return FlexPlayerDialog(playerid, "AscpOnInit", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin Systems Control Panel | Page: %d", page), ASCP:String[playerid], "Select", "Close", page);
}

FlexDialog:AscpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return Ascp_Init(playerid, page);
        else if (IsStringSame("Next Page", inputtext)) return Ascp_Init(playerid, page + 1);
        else if (IsStringSame("Back Page", inputtext)) return Ascp_Init(playerid, page - 1);
    }
    return CallRemoteFunction("AscpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
}

stock ASCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(ASCP:StringTop[playerid])) format(ASCP:StringTop[playerid], 2000, "%s", command);
        else format(ASCP:StringTop[playerid], 2000, "%s\n%s", ASCP:StringTop[playerid], command);
    } else {
        if (!strlen(ASCP:String[playerid])) format(ASCP:String[playerid], 2000, "%s", command);
        else format(ASCP:String[playerid], 2000, "%s\n%s", ASCP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("ascp", cmd) || GetPlayerAdminLevel(playerid) != 10) return 1;
    Ascp_Init(playerid);
    return ~1;
}

//#snippet init_ascp ACP:OnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tASCP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nACP:OnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}