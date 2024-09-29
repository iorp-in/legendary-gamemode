#define MissionsTable "missionData"

#include "IORP_SYSTEM/systems/Missions/index.pwn"
#include <YSI_Coding\y_hooks>

#define MAX_Missions 100

enum E_Missions {
    ms_name[100],
        ms_desc[1000],
        ms_score
}

new Sys_Missions[MAX_Missions][E_Missions];
new bool:Sys_Mission_Data[MAX_PLAYERS][MAX_Missions];
new bool:Sys_Mission_Created[MAX_PLAYERS][MAX_Missions];
new bool:Sys_Mission_On[MAX_PLAYERS];
new Sys_Mission_OnMissionID[MAX_PLAYERS];
new Iterator:Sys_Missions_IT < MAX_Missions > ;

new MissionReCheckTimer;

hook OnGameModeInit() {
    Database:AddTable(MissionsTable, "username", "varchar(100)", "", false);
    CallRemoteFunction("OnMissionInit", "");
    MissionReCheckTimer = SetTimerEx("OnInitializeMissionsTimer", 5 * 60 * 1000, true, "");
    return 1;
}


hook OnGameModeExit() {
    KillTimer(MissionReCheckTimer);
    return 1;
}

forward OnInitializeMissionsTimer();
public OnInitializeMissionsTimer() {
    foreach(new playerid:Player) {
        if (IsPlayerConnected(playerid) && IsPlayerLoggedIn(playerid)) CallRemoteFunction("OnInitializeMissions", "d", playerid);
    }
    return 1;
}

forward OnInitializeMissions(playerid);
public OnInitializeMissions(playerid) {
    return 1;
}

forward OnMissionInit();
public OnMissionInit() {
    return 1;
}

stock AddMission(const name[], const desc[], score) {
    new missionID = Iter_Free(Sys_Missions_IT);
    if (missionID == INVALID_ITERATOR_SLOT) return print("MAX Mission Limit Reached");
    format(Sys_Missions[missionID][ms_name], 100, "%s", name);
    format(Sys_Missions[missionID][ms_desc], 1000, "%s", desc);
    Sys_Missions[missionID][ms_score] = score;
    Iter_Add(Sys_Missions_IT, missionID);
    return missionID;
}

stock InitMissionsList(playerid, page = 1) {
    new string[2000];
    strcat(string, "MissionID\tName\tScore Required\tStatus\n");
    new perPageRow = 10, totalRows = Iter_Count(Sys_Missions_IT);
    new leftRows = totalRows - (perPageRow * page);
    new skip = (page - 1) * perPageRow;
    new count = 0, skipped = 0;
    foreach(new missionID:Sys_Missions_IT) {
        if (skipped != skip) {
            skipped++;
            continue;
        }
        strcat(string, sprintf("%d\t%s\t%d\t%s\n", missionID, Sys_Missions[missionID][ms_name], Sys_Missions[missionID][ms_score], Sys_Mission_Data[playerid][missionID] ? "{80FF00}Passed{FFFFFF}"
            : GetPlayerScore(playerid) < Sys_Missions[missionID][ms_score] ? "{FF0000}Locked{FFFFFF}" : "{FF8000}Unlocked{FFFFFF}"));
        count++;
        if (count == perPageRow) break;
    }
    if (leftRows > 0 && totalRows > perPageRow) strcat(string, "Next Page");
    if (leftRows < 1 && totalRows > perPageRow && page != 1) strcat(string, "Back Page");
    return FlexPlayerDialog(playerid, "MissionMenuMain", DIALOG_STYLE_TABLIST_HEADERS, "Missions", string, "Select", "Cancel", page);
}

FlexDialog:MissionMenuMain(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return InitMissionsList(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return InitMissionsList(playerid, page - 1);
    return FlexPlayerDialog(playerid, "MissionMenuDesc", DIALOG_STYLE_MSGBOX,
        sprintf("Mission: %s", Sys_Missions[strval(inputtext)][ms_name]),
        sprintf("%s", Sys_Missions[strval(inputtext)][ms_desc]),
        "Go Back", ""
    );
}

FlexDialog:MissionMenuDesc(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    InitMissionsList(playerid);
    return 1;
}

stock GetMissionStatus(playerid, missionID) {
    return Sys_Mission_Data[playerid][missionID];
}

stock SetMissionStatus(playerid, missionID, bool:status) {
    Sys_Mission_Data[playerid][missionID] = status;
    return 1;
}

stock isMissionCreated(playerid, missionID) {
    return Sys_Mission_Created[playerid][missionID];
}

stock SetMissionCreatedStatus(playerid, missionID, bool:status) {
    Sys_Mission_Created[playerid][missionID] = status;
    if (status) SendClientMessage(playerid, -1, sprintf("{4286f4}[Mission]: {FFFFEE} new mission available - {FF5733}%s .", Sys_Missions[missionID][ms_name]));
    return 1;
}

stock TotalMissionCreated(playerid) {
    new countMission = 0;
    foreach(new missionID:Sys_Missions_IT) {
        if (isMissionCreated(playerid, missionID)) countMission++;
    }
    return countMission;
}

stock IsPlayerOnMission(playerid) {
    return Sys_Mission_On[playerid];
}

stock GetPlayerMissionID(playerid) {
    return Sys_Mission_OnMissionID[playerid];
}

stock MissionStart(playerid, missionID) {
    if (Sys_Mission_On[playerid]) return 1;
    SetMissionStatus(playerid, missionID, false);
    Sys_Mission_On[playerid] = true;
    Sys_Mission_OnMissionID[playerid] = missionID;
    GameTextForPlayer(playerid, sprintf("mission~n~~r~%s~n~~w~started", Sys_Missions[missionID][ms_name]), 3000, 4);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Mission]: {FFFFEE} %s started.", Sys_Missions[missionID][ms_name]));
    MissionTimerStop(playerid);
    CallRemoteFunction("OnMissionStart", "dd", playerid, missionID);
    return 1;
}

stock MissionPassed(playerid, missionID) {
    SetMissionStatus(playerid, missionID, true);
    Sys_Mission_On[playerid] = false;
    Sys_Mission_OnMissionID[playerid] = -1;
    GameTextForPlayer(playerid, "mission passed~n~~w~   respect +", 3000, 4);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Mission]: {FFFFEE} %s passed.", Sys_Missions[missionID][ms_name]));
    MissionTimerStop(playerid);
    CallRemoteFunction("OnMissionPassed", "dd", playerid, missionID);
    return 1;
}

stock MissionFailed(playerid, missionID) {
    SetMissionStatus(playerid, missionID, false);
    Sys_Mission_On[playerid] = false;
    Sys_Mission_OnMissionID[playerid] = -1;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Mission]: {FFFFEE} %s failed.", Sys_Missions[missionID][ms_name]));
    GameTextForPlayer(playerid, "mission failed~n~~w~   respect -", 3000, 4);
    MissionTimerStop(playerid);
    CallRemoteFunction("OnMissionFailed", "dd", playerid, missionID);
    return 1;
}

forward OnMissionStart(playerid, missionID);
public OnMissionStart(playerid, missionID) {
    return 1;
}

forward OnMissionPassed(playerid, missionID);
public OnMissionPassed(playerid, missionID) {
    return 1;
}

forward OnMissionFailed(playerid, missionID);
public OnMissionFailed(playerid, missionID) {
    return 1;
}

// Mission Timer

new PlayerText:pTimerText[MAX_PLAYERS], pMissionTimerID[MAX_PLAYERS], pMissionTimerSeconds[MAX_PLAYERS];

stock MissionInitTimerTD(playerid) {
    pTimerText[playerid] = CreatePlayerTextDraw(playerid, 490.000000, 130.000000, "Mission Timer: 00:00");
    PlayerTextDrawColor(playerid, pTimerText[playerid], -1);
    PlayerTextDrawUseBox(playerid, pTimerText[playerid], 0);
    PlayerTextDrawBoxColor(playerid, pTimerText[playerid], 255);
    PlayerTextDrawBackgroundColor(playerid, pTimerText[playerid], 255);
    PlayerTextDrawAlignment(playerid, pTimerText[playerid], 1);
    PlayerTextDrawFont(playerid, pTimerText[playerid], 2);
    PlayerTextDrawLetterSize(playerid, pTimerText[playerid], 0.300000, 1.000000);
    PlayerTextDrawTextSize(playerid, pTimerText[playerid], 630.000000, 0.000000);
    PlayerTextDrawSetOutline(playerid, pTimerText[playerid], 1);
    PlayerTextDrawSetShadow(playerid, pTimerText[playerid], 1);
    PlayerTextDrawSetProportional(playerid, pTimerText[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, pTimerText[playerid], 0);
    PlayerTextDrawSetPreviewModel(playerid, pTimerText[playerid], 400);
    PlayerTextDrawSetPreviewRot(playerid, pTimerText[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, pTimerText[playerid], 0, 0);
    return 1;
}

hook OnPlayerLogin(playerid) {
    MissionInitTimerTD(playerid);
    Sys_Mission_OnMissionID[playerid] = -1;
    pMissionTimerID[playerid] = -1;
    Database:InitTable(MissionsTable, "username", GetPlayerNameEx(playerid));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    PlayerTextDrawDestroy(playerid, pTimerText[playerid]);
    return 1;
}

stock MissionStartTimer(playerid, seconds) {
    if (seconds < 1) return 1;
    pMissionTimerSeconds[playerid] = seconds;
    pMissionTimerID[playerid] = SetTimerEx("MissionTimerUpdate", 1000, true, "d", playerid);
    PlayerTextDrawShow(playerid, pTimerText[playerid]);
    return 1;
}

stock MissionTimerStop(playerid) {
    PlayerTextDrawHide(playerid, pTimerText[playerid]);
    KillTimer(pMissionTimerID[playerid]);
    pMissionTimerID[playerid] = -1;
    return 1;
}

forward MissionTimerUpdate(playerid);
public MissionTimerUpdate(playerid) {
    if (pMissionTimerSeconds[playerid] <= 0) return CallRemoteFunction("OnMissionTimerEnd", "d", playerid);
    pMissionTimerSeconds[playerid]--;
    PlayerTextDrawSetString(playerid, pTimerText[playerid], sprintf("Mission Timer: %d:%d", pMissionTimerSeconds[playerid] / (60) % 60, pMissionTimerSeconds[playerid] % 60));
    return 1;
}

forward OnMissionTimerEnd(playerid);
public OnMissionTimerEnd(playerid) {
    MissionTimerStop(playerid);
    return 1;
}

// On Account Action Performed

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("update missionData set username = \"%s\" where username = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("delete from missionData where username = \"%s\"", AccountName));
    return 1;
}
// UCP Mission

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Missions");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (strcmp("Missions", inputtext)) return 1;
    InitMissionsList(playerid);
    return ~1;
}

// Alexa Missions

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (!IsStringContainWords(text, "missions")) return 1;
    InitMissionsList(playerid);
    return ~1;
}