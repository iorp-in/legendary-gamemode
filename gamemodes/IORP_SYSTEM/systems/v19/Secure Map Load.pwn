new bool:g_SafeReboot[MAX_PLAYERS];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "safe_reboot", "boolean", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    g_SafeReboot[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", "safe_reboot");
    if (g_SafeReboot[playerid]) return AlexaMsg(playerid, "You are reconnecting. Full map loading is disabled to prevent duplicate building removal.");
    CallRemoteFunction("OnPlayerMapLoad", "d", playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (g_SafeReboot[playerid]) UCP:AddCommand(playerid, "Load Full Map", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0 || !g_SafeReboot[playerid]) return 1;
    if (IsStringSame("Load Full Map", inputtext)) {
        FlexPlayerDialog(playerid, "SecureMapLoadMenu", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]:{FFFFEE} confirm secure map load",
            "You are being prompted for a safe map load.\n\
            This happens when your previous session ended unexpectedly or you reconnected.\n\n\
            If you confirm, the server will remove map buildings from your game.\n\
            Removing buildings twice can cause crashes or visual bugs.\n\n\
            Only proceed if you are sure the map has NOT already been loaded in this session.",
            "Confirm", "Deny");
        return ~1;
    }
    return 1;
}

FlexDialog:SecureMapLoadMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    CallRemoteFunction("OnPlayerMapLoad", "d", playerid);
    return 1;
}

forward OnPlayerMapLoad(playerid);
public OnPlayerMapLoad(playerid) {
    g_SafeReboot[playerid] = false;
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "safe_reboot");
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateBool(reason == 0, GetPlayerNameEx(playerid), "username", "safe_reboot");
    return 1;
}