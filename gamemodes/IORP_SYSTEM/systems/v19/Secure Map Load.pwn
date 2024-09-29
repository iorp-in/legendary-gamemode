hook OnGameModeInit() {
    Database:AddColumn("playerdata", "safe_reboot", "boolean", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    SetPreciseTimer("CallOnPlayerMapLoad", 15000, false, "d", playerid);
    return 1;
}

forward CallOnPlayerMapLoad(playerid);
public CallOnPlayerMapLoad(playerid) {
    new bool:status = bool:Database:GetBool(GetPlayerNameEx(playerid), "username", "safe_reboot");
    if (status) AlexaMsg(playerid, "map is not loaded fully, to load map full map use /p > load full map");
    else CallRemoteFunction("OnPlayerMapLoad", "d", playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Database:GetBool(GetPlayerNameEx(playerid), "username", "safe_reboot")) UCP:AddCommand(playerid, "Load Full Map", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Load Full Map", inputtext)) {
        FlexPlayerDialog(playerid, "SecureMapLoadMenu", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]:{FFFFEE}confirm secure map load",
            "You are marked for safe map load\nThis happens when the server is rebooted\n\
        If you confirm this action, then it will remove the buildings from your game\n\
        Removing the building twice can crash your game\n\
        Deny only if you were in the server while reboot", "Confirm", "Deny");
        return ~1;
    }
    return 1;
}

FlexDialog:SecureMapLoadMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    CallRemoteFunction("OnPlayerMapLoad", "d", playerid);
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "safe_reboot");
    return 1;
}

forward OnPlayerMapLoad(playerid);
public OnPlayerMapLoad(playerid) {
    return 1;
}

hook OnServerReboot() {
    foreach(new playerid:Player) Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "safe_reboot");
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!IsPlayerLoggedIn(playerid)) return 1;
    if (reason == 0) Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "safe_reboot");
    return 1;
}