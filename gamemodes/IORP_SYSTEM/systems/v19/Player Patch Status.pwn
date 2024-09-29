#define HUD_COLUMN "hud_patch"
hook OnGameModeInit() {
    Database:AddColumn("playerdata", HUD_COLUMN, "boolean", "0");
    return 1;
}

stock Patch:GetHudStatus(playerid) {
    return Database:GetBool(GetPlayerNameEx(playerid), "username", HUD_COLUMN);
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "patch status") && GetPlayerVIPLevel(playerid) > 0) {
        Patch:Menu(playerid);
        return ~1;
    }
    return 1;
}

SCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    SCP:AddCommand(playerid, "Patch Settings");
    return 1;
}

SCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Patch Settings", inputtext)) return Patch:Menu(playerid);
    return 1;
}

stock Patch:Menu(playerid) {
    new string[512];
    strcat(string, "#\tStatus\n");
    strcat(string, sprintf("Hud\t%s\n", Database:GetBool(GetPlayerNameEx(playerid), "username", HUD_COLUMN) ? ("Active") : ("Inactive")));
    return FlexPlayerDialog(playerid, "PatchMenu", DIALOG_STYLE_TABLIST_HEADERS, "Patch Status", string, "Select", "Close");
}

FlexDialog:PatchMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Hud")) {
        new bool:status = Database:GetBool(GetPlayerNameEx(playerid), "username", HUD_COLUMN);
        if (status) {
            Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", HUD_COLUMN);
            AlexaMsg(playerid, "hud patch deactivated");
        } else {
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", HUD_COLUMN);
            AlexaMsg(playerid, "hud patch activated");
        }
        return Patch:Menu(playerid);
    }
    return 1;
}