new GpsMissionID;
new GpsMissionScore = 0;
new GpsMissionCP[MAX_PLAYERS][3];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "gpsMission", "boolean", "0");
    return 1;
}

hook OnMissionInit() {
    GpsMissionID = AddMission("Find GPS", "Find and buy GPS from an electronic shop in Los Santos.", GpsMissionScore);
    return 1;
}

hook OnPlayerLogin(playerid) {
    new bool:ismissionPassed = bool:Database:GetBool(GetPlayerNameEx(playerid), "username", "gpsMission");
    SetMissionStatus(playerid, GpsMissionID, ismissionPassed);
    SetMissionCreatedStatus(playerid, GpsMissionID, false);
    GpsMissionCP[playerid][0] = -1;
    GpsMissionCP[playerid][1] = -1;
    GpsMissionCP[playerid][2] = -1;
    return 1;
}

hook OnInitializeMissions(playerid) {
    if (TotalMissionCreated(playerid) >= 3) return 1;
    GpsMissionCreate(playerid);
    return 1;
}

forward GpsMissionCreate(playerid);
public GpsMissionCreate(playerid) {
    if (GetPlayerScore(playerid) >= GpsMissionScore && !GetMissionStatus(playerid, GpsMissionID) && !isMissionCreated(playerid, GpsMissionID)) {
        GpsMissionCP[playerid][0] = CreateDynamicCP(2459.3604, -1690.4001, 13.5463, 1, 0, 0, playerid);
        GpsMissionCP[playerid][1] = CreateDynamicMapIcon(2459.3604, -1690.4001, 20, 34, -1, 0, 0, playerid, 8000.0, MAPICON_GLOBAL);
        SetMissionCreatedStatus(playerid, GpsMissionID, true);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (isMissionCreated(playerid, GpsMissionID)) {
        DestroyDynamicCP(GpsMissionCP[playerid][0]);
        DestroyDynamicMapIcon(GpsMissionCP[playerid][1]);
        GpsMissionCP[playerid][0] = -1;
        GpsMissionCP[playerid][1] = -1;
        SetMissionCreatedStatus(playerid, GpsMissionID, false);
    }
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == GpsMissionID) {
        MissionTimerStop(playerid);
        MissionFailed(playerid, GpsMissionID);
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (checkpointid == GpsMissionCP[playerid][0]) {
        DestroyDynamicCP(GpsMissionCP[playerid][0]);
        DestroyDynamicMapIcon(GpsMissionCP[playerid][1]);
        GpsMissionCP[playerid][0] = -1;
        GpsMissionCP[playerid][1] = -1;
        new string[500];
        strcat(string, "GPS - Global Positioning System\n\n");
        strcat(string, "Yo homie, how you doing. it's Ryder here, your childhood friend remember.\n");
        strcat(string, "You are a good player but without the proper equipment, you will not find your way to the right place.\n");
        strcat(string, "In this mission, you have to find an electronic shop in Downton, Los Santos and buy GPS within 5 minutes.\n\n");
        strcat(string, "Good luck homie.\n");
        FlexPlayerDialog(playerid, "GpsMissionStart", DIALOG_STYLE_MSGBOX, "MIssion: Find GPS", string, "Okay", "");
        return ~1;
    } else if (checkpointid == GpsMissionCP[playerid][2]) {
        DestroyDynamicCP(GpsMissionCP[playerid][2]);
        GpsMissionCP[playerid][2] = -1;
        SendClientMessageEx(playerid, -1, "{4286f4}[Ryder]: {FFFFFF} great, you are on the location. now just go inside and complete the mission.");
        return ~1;
    }
    return 1;
}

FlexDialog:GpsMissionStart(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    MissionStart(playerid, GpsMissionID);
    MissionStartTimer(playerid, 5 * 60);
    return 1;
}

hook OnMissionTimerEnd(playerid) {
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == GpsMissionID) MissionFailed(playerid, GpsMissionID);
    return 1;
}

hook OnMissionStart(playerid, missionID) {
    if (GpsMissionID != missionID) return 1;
    GpsMissionCP[playerid][2] = CreateDynamicCP(1422.7941, -1166.5621, 23.8244, 1, 0, 0, playerid, 8000.0);
    return ~1;
}

hook OnMissionPassed(playerid, missionID) {
    if (GpsMissionID != missionID) return 1;
    vault:PlayerVault(playerid, 1000, "earned from gps mission", Vault_ID_Government, -1000, sprintf("%s earned from gps mission", GetPlayerNameEx(playerid)));
    DestroyDynamicCP(GpsMissionCP[playerid][2]);
    GpsMissionCP[playerid][2] = -1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Mission]: {FFFFFF} you have earned $1000 for find gps mission");
    SetMissionCreatedStatus(playerid, GpsMissionID, false);
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "gpsMission");
    return ~1;
}

hook OnMissionFailed(playerid, missionID) {
    if (GpsMissionID != missionID) return 1;
    GpsMissionCreate(playerid);
    DestroyDynamicCP(GpsMissionCP[playerid][2]);
    GpsMissionCP[playerid][2] = -1;
    SetMissionCreatedStatus(playerid, GpsMissionID, false);
    return ~1;
}

stock CompleteGpsMission(playerid) {
    if (IsPlayerOnMission(playerid) && GetPlayerMissionID(playerid) == GpsMissionID) MissionPassed(playerid, GpsMissionID);
    return 1;
}