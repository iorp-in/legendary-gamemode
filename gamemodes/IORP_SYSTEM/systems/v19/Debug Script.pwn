#define Max_Debug_ID 1000
new Iterator:DebugIds < Max_Debug_ID > ;

new Debug:DataTitle[Max_Debug_ID][100];
stock Debug:GetID(const FunctionName[]) {
    new id = Iter_Free(DebugIds);
    if (id == INVALID_ITERATOR_SLOT) return Discord:SendManagement(sprintf("Invalid ScriptDebugID Passed:%d", id));
    Iter_Add(DebugIds, id);
    format(Debug:DataTitle[id], 100, "%s", FunctionName);
    return id;
}

stock Debug:GetName(debugid) {
    new string[100];
    format(string, sizeof string, "%s", Debug:DataTitle[debugid]);
    return string;
}

stock Debug:RemoveID(id) {
    if (!Iter_Contains(DebugIds, id)) return ~1;
    Iter_Remove(DebugIds, id);
    return 1;
}

stock Debug:GetTotal() {
    return Iter_Count(DebugIds);
}

stock Debug:IsValidID(id) {
    if (Iter_Contains(DebugIds, id)) return true;
    return false;
}
new bool:Debug:PlayerData[MAX_PLAYERS][Max_Debug_ID];


stock Debug:GetStatus(playerid, debugid) {
    return Debug:PlayerData[playerid][debugid];
}

stock Debug:SetStatus(playerid, debugid, bool:status) {
    Debug:PlayerData[playerid][debugid] = status;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    for (new i; i < Max_Debug_ID; i++) Debug:SetStatus(playerid, i, false);
    return 1;
}

stock Debug:SendMessage(debugid, const message[]) {
    new string[5][128];
    new line = MLM_GetMessages(message, string);
    foreach(new i:Player) {
        if (Debug:GetStatus(i, debugid)) {
            new count = 0;
            while (line > count) {
                SendClientMessage(i, -1, string[count]);
                count++;
            }
        }
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Debug System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Debug System", inputtext)) Debug:MainMenu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "debug system") || !IsPlayerMasterAdmin(playerid)) return 1;
    Debug:MainMenu(playerid);
    return ~1;
}

stock Debug:MainMenu(playerid) {
    new string[256];
    strcat(string, "DebugID List\n");
    strcat(string, "Enable/Disable DebugID\n");
    return FlexPlayerDialog(playerid, "DebugMainMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFFF}Debug System", string, "Select", "Close");
}

FlexDialog:DebugMainMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "DebugID List")) return Debug:ViewList(playerid);
    if (IsStringSame(inputtext, "Enable/Disable DebugID")) {}
    return 1;
}

stock Debug:MenuEnableDisable(playerid) {
    return FlexPlayerDialog(playerid, "DebugMenuEnableDisable", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Debug System", "Enter [DebugID]", "Submit", "Close");
}

FlexDialog:DebugMenuEnableDisable(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Debug:MainMenu(playerid);
    new debugid;
    if (sscanf(inputtext, "d", debugid) || !Debug:IsValidID(debugid)) return Debug:MenuEnableDisable(playerid);
    if (Debug:GetStatus(playerid, debugid)) {
        Debug:SetStatus(playerid, debugid, false);
        AlexaMsg(playerid, sprintf("disabled debug id: %s (%d)", Debug:GetName(debugid), debugid));
    } else {
        Debug:SetStatus(playerid, debugid, true);
        AlexaMsg(playerid, sprintf("enabled debug id: %s (%d)", Debug:GetName(debugid), debugid));
    }
    return Debug:MainMenu(playerid);
}

stock Debug:ViewList(playerid, page = 0) {
    new total = Debug:GetTotal();
    if (total == 0) {
        AlexaMsg(playerid, "currently there are no debug available");
        return Debug:MainMenu(playerid);
    }
    new perpage = 20;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new string[2000], count;
    strcat(string, "#\tName\tActive\n");
    foreach(new debugid:DebugIds) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf("%d\t%s\t%s\n", debugid, Debug:GetName(debugid), Debug:GetStatus(playerid, debugid) ? ("Yes") : ("No")));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "DebugViewList", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFFF}Debug System", string, "Select", "Close", page);
}

FlexDialog:DebugViewList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return Debug:MainMenu(playerid);
    if (IsStringSame(inputtext, "Next Page")) return Debug:ViewList(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Debug:ViewList(playerid, page - 1);
    new debugid = strval(inputtext);
    if (Debug:GetStatus(playerid, debugid)) {
        Debug:SetStatus(playerid, debugid, false);
        AlexaMsg(playerid, sprintf("disabled debug id: %s (%d)", Debug:GetName(debugid), debugid));
    } else {
        Debug:SetStatus(playerid, debugid, true);
        AlexaMsg(playerid, sprintf("enabled debug id: %s (%d)", Debug:GetName(debugid), debugid));
    }
    return Debug:ViewList(playerid, page);
}