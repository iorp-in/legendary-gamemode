#define MAX_CREDIT_DATA_ID 2000
new Iterator:CreditData_ID < MAX_CREDIT_DATA_ID > ;
enum Credit:Data_Enum {
    Credit:Data_Page,
    Credit:Data_Script[100],
    Credit:Data_Author[100]
};
new Credit:Data[MAX_CREDIT_DATA_ID][Credit:Data_Enum];

stock Credit:GetFreeID(page, const Script[], const Author[]) {
    new id = Iter_Free(CreditData_ID);
    Iter_Add(CreditData_ID, id);
    if (id == INVALID_ITERATOR_SLOT) Discord:SendManagement(sprintf("Invalid CreditDataID Passed: %d", id));
    Credit:Data[id][Credit:Data_Page] = page;
    format(Credit:Data[id][Credit:Data_Script], 100, "%s", Script);
    format(Credit:Data[id][Credit:Data_Author], 100, "%s", Author);
    return id;
}

stock Credit:RemoveID(id) {
    if (!Iter_Contains(CreditData_ID, id)) return ~1;
    Iter_Remove(CreditData_ID, id);
    return 1;
}

stock Credit:TotalID() {
    return MAX_CREDIT_DATA_ID;
}

stock Credit:GetTotalFreeID() {
    return MAX_CREDIT_DATA_ID - Iter_Count(CreditData_ID);
}

stock Credit:GetTotalUsedID() {
    return Iter_Count(CreditData_ID);
}

stock bool:Credit:IsValidID(id) {
    if (Iter_Contains(CreditData_ID, id)) return true;
    return false;
}

hook OnGameModeInit() {
    Credit:GetFreeID(0, "IORP", "Root");
    Credit:GetFreeID(0, "IORP", "Harry");
    return 1;
}

stock Credit:Init(playerid, page = 0) {
    new string[2000];
    foreach(new i: CreditData_ID) {
        if (Credit:Data[i][Credit:Data_Page] != page) continue;
        strcat(string, sprintf("%d\t%s\t%s\n", i, Credit:Data[i][Credit:Data_Script], Credit:Data[i][Credit:Data_Author]));
    }
    if (!strlen(string)) format(string, sizeof string, "Nothing On This Page\n");
    else strcat(string, "Next Page\n");
    if (page != 0) strcat(string, "Back Page\n");
    format(string, sizeof string, "ID\tScript Title\tAuthor\n%s", string);
    return FlexPlayerDialog(playerid, "CreditInit", DIALOG_STYLE_TABLIST_HEADERS, sprintf("{4286f4}[Alexa]: {FFFFEE}Credit's | Page: %d", page), string, "Select", "Thanks", page);
}

FlexDialog:CreditInit(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Nothing On This Page", inputtext) && response) return Credit:Init(playerid, page);
    else if (IsStringSame("Next Page", inputtext) && response) return Credit:Init(playerid, page + 1);
    else if (IsStringSame("Back Page", inputtext) && response) return Credit:Init(playerid, page - 1);
    if (!response && page > 0) return Credit:Init(playerid, page - 1);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (strcmp("credits", cmd)) return 1;
    Credit:Init(playerid);
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 2) return 1;
    UCP:AddCommand(playerid, "Credits");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 2) return 1;
    if (IsStringSame("Credits", inputtext)) {
        Credit:Init(playerid);
        return ~1;
    }
    return 1;
}