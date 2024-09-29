new SCP:StringTop[MAX_PLAYERS][2000];
new SCP:String[MAX_PLAYERS][2000];
stock SCP:Init(playerid, page = 0) {
    format(SCP:StringTop[playerid], 500, "");
    format(SCP:String[playerid], 2000, "");
    CallRemoteFunction("ScpOnInit", "dd", playerid, page);
    return 1;
}

forward ScpOnResponse(playerid, page, response, listitem, const inputtext[]);
public ScpOnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) SCP:Init(playerid, page - 1);
    return 1;
}

forward ScpOnInit(playerid, page);
public ScpOnInit(playerid, page) {
    SortString(SCP:StringTop[playerid], SCP:StringTop[playerid]);
    SortString(SCP:String[playerid], SCP:String[playerid]);
    if (!strlen(SCP:String[playerid])) format(SCP:String[playerid], 2000, "Nothing On This Page.");
    else SCP:AddCommand(playerid, "Next Page");
    if (page != 0) SCP:AddCommand(playerid, "Back Page");
    if (strlen(SCP:StringTop[playerid]) > 0) format(SCP:String[playerid], 2000, "%s\n%s", SCP:StringTop[playerid], SCP:String[playerid]);
    return FlexPlayerDialog(playerid, "ScpOnInit", DIALOG_STYLE_LIST,
        sprintf("{4286f4}[Alexa]:{FFFFEE}Settings Control Panel | Page: %d", page),
        SCP:String[playerid], "Select", "Close", page
    );
}

FlexDialog:ScpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Nothing On This Page.", inputtext) && response) return SCP:Init(playerid, page);
    else if (IsStringSame("Next Page", inputtext) && response) return SCP:Init(playerid, page + 1);
    else if (IsStringSame("Back Page", inputtext) && response) return SCP:Init(playerid, page - 1);
    else CallRemoteFunction("ScpOnResponse", "dddds", playerid, page, response, listitem, inputtext);
    return 1;
}

stock SCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(SCP:StringTop[playerid])) format(SCP:StringTop[playerid], 2000, "%s", command);
        else format(SCP:StringTop[playerid], 2000, "%s\n%s", SCP:StringTop[playerid], command);
    } else {
        if (!strlen(SCP:String[playerid])) format(SCP:String[playerid], 2000, "%s", command);
        else format(SCP:String[playerid], 2000, "%s\n%s", SCP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1 && GetPlayerAdminLevel(playerid) < 1) return 1;
    if (strcmp("scp", cmd)) return 1;
    SCP:Init(playerid);
    return ~1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 37) return 1;
    SCP:Init(playerid);
    return ~1;
}

//#snippet init_scp hook ScpOnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tSCP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook ScpOnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}