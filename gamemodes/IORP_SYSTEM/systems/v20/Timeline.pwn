UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Add Timeline");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Add Timeline", inputtext)) {
        AddTimelineMenu(playerid);
        return ~1;
    }
    return 1;
}

stock AddTimelineMenu(playerid) {
    return FlexPlayerDialog(playerid, "AddTimelineMenu", DIALOG_STYLE_INPUT, "Add Timeline", "Enter timeline.", "Add", "Cancel");
}

FlexDialog:AddTimelineMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new title[144];
    if (sscanf(inputtext, "s[144]", title) || strlen(title) < 5) return AddTimelineMenu(playerid);
    AddPlayerLog(playerid, title, "all");
    AlexaMsg(playerid, "Your timeline has been updated. View it at iorp.in");
    return 1;
}