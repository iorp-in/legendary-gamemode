#define ChangeSkinMissionTable "skinMission"

new SkinMissionID, SkinMissionScore = 0, SkinMissionCP[MAX_PLAYERS][3];

hook OnGameModeInit() {
    Database:AddColumn(MissionsTable, ChangeSkinMissionTable, "boolean", "0");
    return 1;
}

hook OnMissionInit() {
    SkinMissionID = AddMission("New Look", "change your skin using setting control panel, located in Cithall, commerce, Los Santos.", SkinMissionScore);
    return 1;
}

hook OnInitializeMissions(playerid) {
    if (TotalMissionCreated(playerid) >= 3) return 1;
    SkinMissionCreate(playerid);
    return 1;
}

forward SkinMissionCreate(playerid);
public SkinMissionCreate(playerid) {
    if (GetMissionStatus(playerid, GpsMissionID) && GetPlayerScore(playerid) >= SkinMissionScore && !GetMissionStatus(playerid, SkinMissionID) && !isMissionCreated(playerid, SkinMissionID)) {
        SkinMissionCP[playerid][0] = CreateDynamicCP(2459.3604, -1690.4001, 13.5463, 1, 0, 0, playerid);
        SkinMissionCP[playerid][1] = CreateDynamicMapIcon(2459.3604, -1690.4001, 20, 34, -1, 0, 0, playerid, 8000.0, MAPICON_GLOBAL);
        SetMissionCreatedStatus(playerid, SkinMissionID, true);
    }
    return 1;
}

new bool:MisSkinChangeData[MAX_PLAYERS];

hook OnPlayerLogin(playerid) {
    MisSkinChangeData[playerid] = false;
    MisSkinChangeData[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", ChangeSkinMissionTable, MissionsTable);
    SetMissionStatus(playerid, SkinMissionID, MisSkinChangeData[playerid]);
    SetMissionCreatedStatus(playerid, SkinMissionID, false);
    SkinMissionCP[playerid][0] = -1;
    SkinMissionCP[playerid][1] = -1;
    SkinMissionCP[playerid][2] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    MisSkinChangeData[playerid] = false;
    if (isMissionCreated(playerid, SkinMissionID)) {
        DestroyDynamicCP(SkinMissionCP[playerid][0]);
        DestroyDynamicMapIcon(SkinMissionCP[playerid][1]);
        SkinMissionCP[playerid][0] = -1;
        SkinMissionCP[playerid][1] = -1;
        SetMissionCreatedStatus(playerid, SkinMissionID, false);
    }
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == SkinMissionID) {
        MissionTimerStop(playerid);
        MissionFailed(playerid, SkinMissionID);
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (checkpointid == SkinMissionCP[playerid][0]) {
        DestroyDynamicCP(SkinMissionCP[playerid][0]);
        DestroyDynamicMapIcon(SkinMissionCP[playerid][1]);
        SkinMissionCP[playerid][0] = -1;
        SkinMissionCP[playerid][1] = -1;
        new string[500];
        strcat(string, "Welcome back homie,\n\n");
        strcat(string, "I hope your GPS mission was fantastic. I have another mission for you.\n");
        strcat(string, "you have to go cityhall located in commerce, los santos.\n");
        strcat(string, "you have to find settings control panel in there office and change your skin.\n");
        strcat(string, "if you selected good skin for you, I will reward you.\n");
        strcat(string, "Good luck homie - Ryder\n");
        FlexPlayerDialog(playerid, "SkinMissionStart", DIALOG_STYLE_MSGBOX, "MIssion: New Look", string, "Okay", "");
        return ~1;
    } else if (checkpointid == SkinMissionCP[playerid][2]) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Ryder]: {FFFFFF} great, you are on the location. now just go inside and complete the mission.");
        DestroyDynamicCP(SkinMissionCP[playerid][2]);
        SkinMissionCP[playerid][2] = -1;
        return ~1;
    }
    return 1;
}

FlexDialog:SkinMissionStart(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    MissionStart(playerid, SkinMissionID);
    MissionStartTimer(playerid, 5 * 60);
    return 1;
}

hook OnMissionTimerEnd(playerid) {
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == SkinMissionID) MissionFailed(playerid, SkinMissionID);
    return 1;
}

hook OnMissionStart(playerid, missionID) {
    if (SkinMissionID != missionID) return 1;
    SkinMissionCP[playerid][2] = CreateDynamicCP(1479.7668, -1738.8785, 13.5469, 1, 0, 0, playerid, 8000.0);
    return ~1;
}

hook OnMissionPassed(playerid, missionID) {
    if (SkinMissionID != missionID) return 1;
    MisSkinChangeData[playerid] = true;
    Database:UpdateInt(MisSkinChangeData[playerid], GetPlayerNameEx(playerid), "username", ChangeSkinMissionTable, MissionsTable);
    vault:PlayerVault(playerid, 1000, "earned from look mission", Vault_ID_Government, -1000, sprintf("%s earned from look mission", GetPlayerNameEx(playerid)));
    DestroyDynamicCP(SkinMissionCP[playerid][2]);
    SkinMissionCP[playerid][2] = -1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Mission]: {FFFFFF} you have earned $1000 for change skin mission");
    SetMissionCreatedStatus(playerid, SkinMissionID, false);
    return ~1;
}

hook OnMissionFailed(playerid, missionID) {
    if (SkinMissionID != missionID) return 1;
    DestroyDynamicCP(SkinMissionCP[playerid][2]);
    SkinMissionCP[playerid][2] = -1;
    SetMissionCreatedStatus(playerid, SkinMissionID, false);
    return ~1;
}

stock CompleteSkinMission(playerid) {
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == SkinMissionID) MissionPassed(playerid, SkinMissionID);
    return 1;
}