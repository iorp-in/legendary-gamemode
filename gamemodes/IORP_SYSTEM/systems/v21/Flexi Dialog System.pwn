//#snippet ShowFlexDialog FlexPlayerDialog(playerid, const dialogFunc[], style, const caption[], const info[], const button1[], const button2[], extraid = -1, const payload[] = "null")
//#snippet FlexDialog FlexDialog:dialog(playerid, response, listitem, const inputtext[], extraid, const payload[]) {\n\tif (!response) return 1;\n\treturn 1;\n}
//#snippet flexinput stock InputMenu(playerid) {\n\treturn FlexPlayerDialog(playerid, "InputMenu", DIALOG_STYLE_INPUT, "Menu", "Enter", "Submit", "Cancel");\n}\n\nFlexDialog:InputMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {\n\t    if (!response) return 1;\n\treturn 1;\n}

new FlexDialogID;
new FlexDialogData[MAX_PLAYERS][100];

stock FlexPlayerDialog(playerid, const dialogFunc[], style, const caption[], const info[], const button1[], const button2[], extraid = -1, const payload[] = "null") {
    if (strlen(dialogFunc) < 1) return 0;
    format(FlexDialogData[playerid], 100, "%s", dialogFunc);
    return ShowPlayerDialogEx(playerid, FlexDialogID, 0, style, caption, info, button1, button2, extraid, payload);
}

hook OnGameModeInit() {
    FlexDialogID = Dialog:GetFreeID();
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != FlexDialogID) return 1;
    if (offsetid == 0) {
        SetPreciseTimer(sprintf("FlD@%s", FlexDialogData[playerid]), 0, false, "dddsds", playerid, response, listitem, RemoveMalChars(inputtext), extraid, payload);
        return ~1;
    }
    return ~1;
}