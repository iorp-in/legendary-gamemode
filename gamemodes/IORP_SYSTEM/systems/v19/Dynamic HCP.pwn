new HCP:StringTop[MAX_PLAYERS][2000];
new HCP:String[MAX_PLAYERS][2000];

stock HCP:Init(playerid, page = 0) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    format(HCP:StringTop[playerid], 500, "");
    format(HCP:String[playerid], 2000, "");
    CallRemoteFunction("HcpOnInit", "dd", playerid, page);
    return 1;
}

forward HcpOnResponse(playerid, page, response, listitem, const inputtext[]);
public HcpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    return 1;
}

forward HcpOnInit(playerid, page);
public HcpOnInit(playerid, page) {
    SortString(HCP:StringTop[playerid], HCP:StringTop[playerid]);
    SortString(HCP:String[playerid], HCP:String[playerid]);
    if (!strlen(HCP:String[playerid])) format(HCP:String[playerid], 2000, "Nothing On This Page.");
    else HCP:AddCommand(playerid, "Next Page");
    if (page != 0) HCP:AddCommand(playerid, "Back Page");
    if (strlen(HCP:StringTop[playerid]) > 0) format(HCP:String[playerid], 2000, "%s\n%s", HCP:StringTop[playerid], HCP:String[playerid]);
    return FlexPlayerDialog(playerid, "HcpOnInit", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]:{FFFFEE}Help Panel | Page: %d", page), HCP:String[playerid], "Select", "Close", page);
}

FlexDialog:HcpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return HCP:Init(playerid, page);
        else if (IsStringSame("Next Page", inputtext)) return HCP:Init(playerid, page + 1);
        else if (IsStringSame("Back Page", inputtext)) return HCP:Init(playerid, page - 1);
    }
    return CallRemoteFunction("HcpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
}

stock HCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(HCP:StringTop[playerid])) format(HCP:StringTop[playerid], 2000, "%s", command);
        else format(HCP:StringTop[playerid], 2000, "%s\n%s", HCP:StringTop[playerid], command);
    } else {
        if (!strlen(HCP:String[playerid])) format(HCP:String[playerid], 2000, "%s", command);
        else format(HCP:String[playerid], 2000, "%s\n%s", HCP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("help", cmd)) return 1;
    HCP:Init(playerid);
    return ~1;
}

cmd:help(playerid, const params[]) {
    HCP:Init(playerid);
    return 1;
}

//#snippet init_hcp HCP:OnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tHCP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nHCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}