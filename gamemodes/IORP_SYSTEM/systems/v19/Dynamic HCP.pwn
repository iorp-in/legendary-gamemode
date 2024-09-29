#define MAX_HELP_DOC_ID 2000
new Iterator:HelpDocIds < MAX_HELP_DOC_ID > ;

stock Doc:GetFreeID() {
    new id = Iter_Free(HelpDocIds);
    Iter_Add(HelpDocIds, id);
    if (id == INVALID_ITERATOR_SLOT) Discord:SendManagement(sprintf("Invalid HelpDocID Passed: %d", id));
    return id;
}

stock Doc:RemoveID(id) {
    if (!Iter_Contains(HelpDocIds, id)) return ~1;
    Iter_Remove(HelpDocIds, id);
    return 1;
}

stock Doc:TotalID() {
    return MAX_HELP_DOC_ID;
}

stock Doc:GetTotalFreeID() {
    return MAX_HELP_DOC_ID - Iter_Count(HelpDocIds);
}

stock Doc:GetTotalUsedID() {
    return Iter_Count(HelpDocIds);
}

stock bool:Doc:IsValidID(id) {
    if (Iter_Contains(HelpDocIds, id)) return true;
    return false;
}

enum Doc:StringEnum {
    HCP_page,
    hcp_Title[100],
    hcp_body[2000]
};
new Doc:String[MAX_HELP_DOC_ID][Doc:StringEnum];

stock Doc:Add(page, docid, const DocTitle[], const DocData[]) {
    if (!Doc:IsValidID(docid)) return printf("Invalid DocID: %d", docid);
    Doc:String[docid][HCP_page] = page;
    format(Doc:String[docid][hcp_Title], 100, "%s", DocTitle);
    format(Doc:String[docid][hcp_body], 2000, "%s", DocData);
    return 1;
}

stock Doc:View(playerid, docid) {
    if (!Doc:IsValidID(docid)) return SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE} Invalid DocID: %d", docid));
    return FlexPlayerDialog(
        playerid, "DocView", DIALOG_STYLE_MSGBOX,
        sprintf("{4286f4}[Documentation]: {FFFFEE} %s", Doc:String[docid][hcp_Title]), Doc:String[docid][hcp_body],
        "Thanks", "", docid
    );
}

FlexDialog:DocView(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    return CallRemoteFunction("DocOnResponse", "dddd", playerid, extraid, response);
}

stock Doc:Init(playerid, page = 0) {
    new string[2000];
    foreach(new docid:HelpDocIds) {
        if (!Doc:IsValidID(docid)) continue;
        if (Doc:String[docid][HCP_page] != page) continue;
        strcat(string, sprintf("%d\t%s\n", docid, Doc:String[docid][hcp_Title]));
    }
    if (!strlen(string)) format(string, sizeof string, "Nothing On This Page\n");
    else strcat(string, "Next Page\n");
    if (page != 0) strcat(string, "Back Page\n");
    format(string, sizeof string, "Doc ID\tDoc Title\n%s", string);
    return FlexPlayerDialog(
        playerid, "DocInit", DIALOG_STYLE_TABLIST_HEADERS, sprintf("{4286f4}[Alexa]: {FFFFEE}Documentation | Page: %d", page), string, "Thanks", "", page
    );
}

FlexDialog:DocInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (IsStringSame("Nothing On This Page", inputtext) && response) return Doc:Init(playerid, page);
    else if (IsStringSame("Next Page", inputtext) && response) return Doc:Init(playerid, page + 1);
    else if (IsStringSame("Back Page", inputtext) && response) return Doc:Init(playerid, page - 1);
    else if (!response && page > 0) return Doc:Init(playerid, page - 1);
    else if (response) return Doc:View(playerid, strval(inputtext));
    return 1;
}

forward DocOnResponse(playerid, docid, response);
public DocOnResponse(playerid, docid, response) {
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringSame("help", cmd)) {
        if (!IsPlayerAwaken(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You can't use help desk at bedtime.");
        Doc:Init(playerid);
        return ~1;
    }

    if (IsStringSame("doc", cmd)) {
        if (!IsPlayerAwaken(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You can't use help desk at bedtime.");
        new string[128];
        GetSubString(text, cmd, string);
        Doc:View(playerid, strval(string));
        return ~1;
    }

    return 1;
}

cmd:help(playerid, const params[]) {
    if (!IsPlayerAwaken(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You can't use help desk at bedtime.");
    Doc:Init(playerid);
    return 1;
}

//#snippet init_hcp hook Hcp_OnInit(playerid, page) {\n\tif(page != 0) return 1;\n\tHcp_AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook DocOnResponse(playerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}