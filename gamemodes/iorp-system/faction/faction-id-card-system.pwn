stock Faction:ShowID(playerid, targetid) {
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 1;
    if (!Faction:IsValidID(Faction:GetPlayerFID(playerid))) return 1;
    new string[512];
    strcat(string, sprintf("Name: %s\n", GetPlayerNameEx(targetid)));
    strcat(string, sprintf("Gender: %s\n", GetPlayerGender(targetid)));
    strcat(string, sprintf("Faction: %s\n", Faction:GetName(Faction:GetPlayerFID(targetid))));
    strcat(string, sprintf("Rank: %s\n", Faction:GetRankName(Faction:GetPlayerFID(targetid), Faction:GetPlayerRankID(playerid))));
    return FlexPlayerDialog(playerid, "FactionIdCard", DIALOG_STYLE_MSGBOX, sprintf("{4286f4}[%s]: {FFFFFF}ID Card", Faction:GetName(Faction:GetPlayerFID(targetid))), string, "Okay", "");
}

FlexDialog:FactionIdCard(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3, 4 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid))) QuickActions:AddCommand(playerid, "Show Faction ID Card");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Show Faction ID Card", inputtext)) {
        Faction:ShowID(targetid, playerid);
        return ~1;
    }
    return 1;
}