new APCP:StringTop[MAX_PLAYERS][2000];
new APCP:String[MAX_PLAYERS][2000];
stock APCP:Init(playerid, targetid, page = 0) {
    if (GetPlayerAdminLevel(playerid) < 1) return 0;
    format(APCP:StringTop[playerid], 500, "");
    format(APCP:String[playerid], 2000, "");
    CallRemoteFunction("ApcpOnInit", "ddd", playerid, targetid, page);
    return 1;
}

forward ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]);
public ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    return 1;
}

forward ApcpOnInit(playerid, targetid, page);
public ApcpOnInit(playerid, targetid, page) {
    SortString(APCP:StringTop[playerid], APCP:StringTop[playerid]);
    SortString(APCP:String[playerid], APCP:String[playerid]);
    if (!strlen(APCP:String[playerid])) format(APCP:String[playerid], 2000, "Nothing On This Page.");
    else APCP:AddCommand(playerid, "Next Page");
    if (page != 0) APCP:AddCommand(playerid, "Back Page");
    if (strlen(APCP:StringTop[playerid]) > 0) format(APCP:String[playerid], 2000, "%s\n%s", APCP:StringTop[playerid], APCP:String[playerid]);
    return FlexPlayerDialog(playerid, "ApcpOnInit", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]:{FFFFEE} Manage %s | Page: %d", GetPlayerNameEx(targetid), page), APCP:String[playerid], "Select", "Close", page, sprintf("%d", targetid));
}

FlexDialog:ApcpOnInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new targetid = strval(payload);
    if (!IsPlayerConnected(targetid)) return AlexaMsg(playerid, sprintf("%s is not connected with server", GetPlayerNameEx(targetid)));
    if (response) {
        if (IsStringSame("Nothing On This Page.", inputtext)) return APCP:Init(playerid, targetid, page);
        else if (IsStringSame("Next Page", inputtext)) return APCP:Init(playerid, targetid, page + 1);
        else if (IsStringSame("Back Page", inputtext)) return APCP:Init(playerid, targetid, page - 1);
    }
    return CallRemoteFunction("ApcpOnResponse", "ddddds", playerid, targetid, page, response, listitem, inputtext);
}

stock APCP:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(APCP:StringTop[playerid])) format(APCP:StringTop[playerid], 2000, "%s", command);
        else format(APCP:StringTop[playerid], 2000, "%s\n%s", APCP:StringTop[playerid], command);
    } else {
        if (!strlen(APCP:String[playerid])) format(APCP:String[playerid], 2000, "%s", command);
        else format(APCP:String[playerid], 2000, "%s\n%s", APCP:String[playerid], command);
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "aplayer") && GetPlayerAdminLevel(playerid) > 0) {
        new targetid;
        if (sscanf(GetNextWordFromString(text, "aplayer"), "u", targetid)) targetid = playerid;
        if (!IsPlayerConnected(targetid)) targetid = playerid;
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return 1;
}

//#snippet init_apcp hook ApcpOnInit(playerid, targetid, page) {\n\tif(page != 0) return 1;\n\tAPCP:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}