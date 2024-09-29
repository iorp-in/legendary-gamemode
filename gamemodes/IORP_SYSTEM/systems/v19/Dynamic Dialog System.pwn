#define MAX_DIALOG_ID 2000
new Iterator:Dialog_IDs < MAX_DIALOG_ID > ;

stock Dialog:GetFreeID() {
    new id = Iter_Free(Dialog_IDs);
    Iter_Add(Dialog_IDs, id);
    if (id == INVALID_ITERATOR_SLOT) Discord:SendManagement(sprintf("Invalid DialogID Passed: %d", id));
    return id;
}

stock Dialog:RemoveID(id) {
    if (!Iter_Contains(Dialog_IDs, id)) return ~1;
    Iter_Remove(Dialog_IDs, id);
    return 1;
}

stock Dialog:TotalID() {
    return MAX_DIALOG_ID;
}

stock Dialog:GetTotalFreeID() {
    return MAX_DIALOG_ID - Iter_Count(Dialog_IDs);
}

stock Dialog:GetTotalUsedID() {
    return Iter_Count(Dialog_IDs);
}

stock bool:Dialog:IsValidID(id) {
    if (Iter_Contains(Dialog_IDs, id)) return true;
    return false;
}

enum dplayerEnum {
    ddsOffset,
    ddsExtraId,
    ddsStyle,
    ddsPayload[512],
    ddsInfo[2000]
}

new Player_Dialog_Offset[MAX_PLAYERS][dplayerEnum];

stock ShowPlayerDialogEx(playerid, dialogid, offsetid, style, const caption[], const info[], const button1[], const button2[], extraid = -1, const payload[] = "null") {
    if (!Dialog:IsValidID(dialogid)) return 0;
    Player_Dialog_Offset[playerid][ddsOffset] = offsetid;
    Player_Dialog_Offset[playerid][ddsExtraId] = extraid;
    Player_Dialog_Offset[playerid][ddsStyle] = style;
    format(Player_Dialog_Offset[playerid][ddsPayload], 512, "%s", payload);
    format(Player_Dialog_Offset[playerid][ddsInfo], 2000, "%s", info);
    return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    // printf("playerid: %d, dialogid: %d, response: %d, listitem: %d, inputtext: %s", playerid, dialogid, response, listitem, inputtext);
    if (!Dialog:IsValidID(dialogid)) return 0;
    new count, cinputText[512];
    format(cinputText, sizeof cinputText, "%s", inputtext);
    for (count = 0; count < strlen(cinputText); count++) {
        if (cinputText[count] == '%') strdel(cinputText, count, count + 1);
    }
    new offsetid = Player_Dialog_Offset[playerid][ddsOffset];
    new extraid = Player_Dialog_Offset[playerid][ddsExtraId];
    new style = Player_Dialog_Offset[playerid][ddsStyle];
    if (listitem < 0) listitem = 0;

    if (style == DIALOG_STYLE_TABLIST) {
        new fixMenuString[512];
        GetMenuList(Player_Dialog_Offset[playerid][ddsInfo], Player_Dialog_Offset[playerid][ddsInfo]);
        GetMenuString(Player_Dialog_Offset[playerid][ddsInfo], listitem, fixMenuString);
        format(cinputText, sizeof cinputText, "%s", fixMenuString);
    } else if (style == DIALOG_STYLE_TABLIST_HEADERS) {
        new fixMenuString[512];
        GetHeaderMenuList(Player_Dialog_Offset[playerid][ddsInfo], Player_Dialog_Offset[playerid][ddsInfo]);
        GetMenuString(Player_Dialog_Offset[playerid][ddsInfo], listitem, fixMenuString);
        format(cinputText, sizeof cinputText, "%s", fixMenuString);
    } else if (style == DIALOG_STYLE_LIST) {
        new fixMenuString[512];
        GetMenuList(Player_Dialog_Offset[playerid][ddsInfo], Player_Dialog_Offset[playerid][ddsInfo]);
        GetMenuString(Player_Dialog_Offset[playerid][ddsInfo], listitem, fixMenuString);
        format(cinputText, sizeof cinputText, "%s", fixMenuString);
    }
    if (strlen(cinputText) < 1) format(cinputText, sizeof cinputText, "null");
    if (strlen(Player_Dialog_Offset[playerid][ddsPayload]) < 1) format(Player_Dialog_Offset[playerid][ddsPayload], 512, "null");
    // printf("playerid: %d, style: %d, input: %s", playerid, style, cinputText);
    SetPreciseTimer("OnDialogResponseEx", 0, false, "dddddsds", playerid, dialogid, offsetid, response, listitem, cinputText, extraid, Player_Dialog_Offset[playerid][ddsPayload]);
    return 1;
}

forward OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]);
public OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    return 1;
}

hook OnPlayerConnect(playerid) {
    Player_Dialog_Offset[playerid][ddsOffset] = -1;
    Player_Dialog_Offset[playerid][ddsExtraId] = -1;
    Player_Dialog_Offset[playerid][ddsStyle] = 0;
    format(Player_Dialog_Offset[playerid][ddsPayload], 512, "null");
    format(Player_Dialog_Offset[playerid][ddsInfo], 2000, "null");
    return 1;
}

//#snippet init_dialogresponse hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {\n\tif(dialogid != ) return 1;\n\tif(offsetid == ) {\n\t\tif(!response) return ~1;\n\t\treturn ~1;\n\t}\n\treturn ~1;\n}
//#snippet init_dialogoffset if(offsetid == ) {\n\tif(!response) return ~1;\n\treturn ~1;\n}