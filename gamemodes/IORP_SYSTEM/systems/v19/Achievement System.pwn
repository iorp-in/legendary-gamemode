#define AchievementTable "achievement"

#include "IORP_SYSTEM/systems/Achievements/index.pwn"
#include <YSI_Coding\y_hooks>

#define MAX_ACHIEVEMENTS 100

hook OnGameModeInit() {
    Database:AddTable(AchievementTable, "username", "varchar(100)", "", false);
    return 1;
}

hook OnPlayerLogin(playerid) {
    Database:InitTable(AchievementTable, "username", GetPlayerNameEx(playerid));
    return 1;
}

enum Acs_Data_Enum {
    Acs_Title[200],
        Acs_Desc[1000]

}
new Acs_Data[MAX_ACHIEVEMENTS][Acs_Data_Enum];
new bool:Acs_Data_Player[MAX_PLAYERS][MAX_ACHIEVEMENTS];

new Iterator:Acs_Data_IT < MAX_ACHIEVEMENTS > ;

stock AddAchievement(const title[], const desc[]) {
    new archivementID = Iter_Free(Acs_Data_IT);
    if (archivementID == INVALID_ITERATOR_SLOT) return print("MAX Mission Limit Reached");
    format(Acs_Data[archivementID][Acs_Title], 200, "%s", title);
    format(Acs_Data[archivementID][Acs_Desc], 1000, "%s", desc);
    Iter_Add(Acs_Data_IT, archivementID);
    return archivementID;
}

stock GetAchievementStatus(playerid, archivementID) {
    return Acs_Data_Player[playerid][archivementID];
}

stock SetAchievementStatus(playerid, archivementID, bool:status) {
    Acs_Data_Player[playerid][archivementID] = status;
    return 1;
}

stock InitAchievementList(playerid, page = 1) {
    new string[2000];
    strcat(string, "AchievementID\tTitle\tStatus\n");
    new perPageRow = 10, totalRows = Iter_Count(Acs_Data_IT);
    new leftRows = totalRows - (perPageRow * page);
    new skip = (page - 1) * perPageRow;
    new count = 0, skipped = 0;
    foreach(new archivementID:Acs_Data_IT) {
        if (skipped != skip) {
            skipped++;
            continue;
        }
        strcat(string, sprintf("%d\t%s\t%s\n", archivementID, Acs_Data[archivementID][Acs_Title], Acs_Data_Player[playerid][archivementID] ? "{00FF00}Accomplished{FFFFFF}" : "{FF0000}Not Accomplished{FFFFFF}"));
        count++;
        if (count == perPageRow) break;
    }
    if (leftRows > 0 && totalRows > perPageRow) strcat(string, "Next Page\n");
    if (leftRows < 1 && totalRows > perPageRow && page != 1) strcat(string, "Back Page");
    FlexPlayerDialog(playerid, "AchievementMenu", DIALOG_STYLE_TABLIST_HEADERS, "Achievements: List", string, "Select", "Cancel", page);
    return 1;
}

FlexDialog:AchievementMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return InitAchievementList(playerid, extraid + 1);
    if (IsStringSame(inputtext, "Back Page")) return InitAchievementList(playerid, extraid - 1);
    FlexPlayerDialog(playerid, "AchievementSubMenu", DIALOG_STYLE_MSGBOX, "Achievements", sprintf("%s", Acs_Data[strval(inputtext)][Acs_Desc]), "Go Back", "");
    return 1;
}

FlexDialog:AchievementSubMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    InitAchievementList(playerid);
    return 1;
}

// On Account Action Performed

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("update achievement set username = \"%s\" where username = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("delete from achievement where username = \"%s\"", AccountName));
    return 1;
}

// UCP Achievement

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Achievements");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (strcmp("Achievements", inputtext)) return 1;
    InitAchievementList(playerid);
    return ~1;
}

// Alexa Achievement

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (!IsStringContainWords(text, "achievements")) return 1;
    InitAchievementList(playerid);
    return ~1;
}