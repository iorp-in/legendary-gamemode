new bool:InvisibleAuth:SystemStatus;
new bool:InvisibleAuth:PlayerData[MAX_PLAYERS];

hook OnGameModeInit() {
    InvisibleAuth:SystemStatus = false;
    return 1;
}

stock InvisibleAuth:GetSystemStatus() {
    return InvisibleAuth:SystemStatus;
}

hook GlobalOneMinuteInterval() {
    InvisibleUpdate();
    return 1;
}

forward InvisibleUpdate();
public InvisibleUpdate() {
    foreach(new i:Player) {
        foreach(new j:Player) {
            if (InvisibleAuth:GetPlayer(i)) SetPlayerMarkerForPlayer(j, i, (GetPlayerColor(i) & 0xFFFFFF00));
            else SetPlayerMarkerForPlayer(j, i, GetPlayerColor(i));
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    InvisibleAuth:SetPlayer(playerid, InvisibleAuth:SystemStatus);
    return 1;
}

stock InvisibleAuth:GetPlayer(playerid) {
    return InvisibleAuth:PlayerData[playerid];
}

stock InvisibleAuth:SetPlayer(playerid, bool:status) {
    InvisibleAuth:PlayerData[playerid] = status;
    return 1;
}

stock InvisibleAuth:Command(adminid, playerid) {
    if (!IsPlayerConnected(playerid)) return SendClientMessageEx(adminid, -1, "{4286f4}[Error]:{FFFFEE}Invalid playerid");
    if (InvisibleAuth:GetPlayer(playerid)) {
        InvisibleAuth:SetPlayer(playerid, false);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have deactivated %s invisible mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your invisible mode deactivated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    } else {
        InvisibleAuth:SetPlayer(playerid, true);
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you have activated %s invisible mode", GetPlayerNameEx(playerid));
        SendClientMessageEx(adminid, COLOR_GREY, string);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} your invisible mode activated by admin %s", GetPlayerNameEx(adminid));
        SendClientMessageEx(playerid, COLOR_GREY, string);
    }
    return 1;
}

hook OnPlayerEnableRPMODE(playerid) {
    if (!InvisibleAuth:GetSystemStatus()) InvisibleAuth:SetPlayer(playerid, true);
    return 1;
}

hook OnPlayerDisableRPMODE(playerid) {
    if (!InvisibleAuth:GetSystemStatus()) InvisibleAuth:SetPlayer(playerid, false);
    return 1;
}

APCP:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    APCP:AddCommand(playerid, InvisibleAuth:GetPlayer(targetid) ? "Make visible" : "Make invisible");
    return 1;
}

APCP:OnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Make visible", inputtext) || IsStringSame("Make invisible", inputtext)) {
        InvisibleAuth:Command(playerid, targetid);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerAdminLevel(playerid) != 3 || !IsStringSame(text, "invisible mode")) return 1;
    InvisibleAuth:SystemStatus = !InvisibleAuth:SystemStatus;
    AlexaMsg(playerid, InvisibleAuth:SystemStatus ? "Enabled" : "Disabled", "Invisible System");
    InvisibleUpdate();
    return ~1;
}