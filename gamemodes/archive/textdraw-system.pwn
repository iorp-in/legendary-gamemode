enum TDSS_enum {
    bool:TDSS_Valid = false,
    PlayerText:TDSS_Text,
    Float:TDSS_Position[2],
    TDSS_Alignment,
    TDSS_Use_box,
    TDSS_Shadow,
    TDSS_Outline,
    TDSS_Font,
    TDSS_Proportional,
    TDSS_Selectable,
    TDSS_TextColor,
    TDSS_BoxColor,
    TDSS_BackgroundColor,
    Float:TDSS_LetterSize[2],
    Float:TDSS_TextSize[2],
    TDSS_String[256],
    TDSS_Pre_Int[3],
    Float:TDSS_Pre_Float[4]

}
#define Max_TDSS 100
new TDSS_System[MAX_PLAYERS][Max_TDSS][TDSS_enum];

stock TDSS_GetFreeID(playerid) {
    for (new i = 0; i < Max_TDSS; i++) {
        if(!TDSS_System[playerid][i][TDSS_Valid]) return i;
    }
    return -1;
}

stock TDSS_Create(playerid) {
    new tid = TDSS_GetFreeID(playerid);
    if(tid == -1) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Limit Exceed");
    format(TDSS_System[playerid][tid][TDSS_String], 256, "Welcome to my SA-MP server");
    TDSS_System[playerid][tid][TDSS_Position][0] = 320.0;
    TDSS_System[playerid][tid][TDSS_Position][1] = 240.0;
    TDSS_System[playerid][tid][TDSS_LetterSize][0] = 0.2;
    TDSS_System[playerid][tid][TDSS_LetterSize][1] = 1.0;
    TDSS_System[playerid][tid][TDSS_Alignment] = 0;
    TDSS_System[playerid][tid][TDSS_Use_box] = 0;
    TDSS_System[playerid][tid][TDSS_Shadow] = 0;
    TDSS_System[playerid][tid][TDSS_Outline] = 0;
    TDSS_System[playerid][tid][TDSS_Font] = 1;
    TDSS_System[playerid][tid][TDSS_Proportional] = 1;
    TDSS_System[playerid][tid][TDSS_Selectable] = 0;
    TDSS_System[playerid][tid][TDSS_TextColor] = 0xFFFFFFFF;
    TDSS_System[playerid][tid][TDSS_BoxColor] = 0x000000FF;
    TDSS_System[playerid][tid][TDSS_BackgroundColor] = 0x000000FF;
    TDSS_System[playerid][tid][TDSS_TextSize][0] = 2.0;
    TDSS_System[playerid][tid][TDSS_TextSize][1] = 3.6;
    TDSS_System[playerid][tid][TDSS_Pre_Int][0] = 400;
    TDSS_System[playerid][tid][TDSS_Pre_Int][1] = 0;
    TDSS_System[playerid][tid][TDSS_Pre_Int][2] = 0;
    TDSS_System[playerid][tid][TDSS_Pre_Float][0] = 0.0;
    TDSS_System[playerid][tid][TDSS_Pre_Float][1] = 0.0;
    TDSS_System[playerid][tid][TDSS_Pre_Float][2] = 0.0;
    TDSS_System[playerid][tid][TDSS_Pre_Float][3] = 1.0;
    TDSS_System[playerid][tid][TDSS_Text] = CreatePlayerTextDraw(playerid, TDSS_System[playerid][tid][TDSS_Position][0], TDSS_System[playerid][tid][TDSS_Position][1], TDSS_System[playerid][tid][TDSS_String]);
    TDSS_System[playerid][tid][TDSS_Valid] = true;
    TDSS_Update(playerid, tid);
    return tid;
}

stock TDSS_Update(playerid, tid) {
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    PlayerTextDrawDestroy(playerid, TDSS_System[playerid][tid][TDSS_Text]);
    TDSS_System[playerid][tid][TDSS_Text] = CreatePlayerTextDraw(playerid, TDSS_System[playerid][tid][TDSS_Position][0], TDSS_System[playerid][tid][TDSS_Position][1], TDSS_System[playerid][tid][TDSS_String]);
    PlayerTextDrawColor(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_TextColor]);
    PlayerTextDrawUseBox(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Use_box]);
    PlayerTextDrawBoxColor(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_BoxColor]);
    PlayerTextDrawBackgroundColor(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_BackgroundColor]);
    PlayerTextDrawAlignment(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Alignment]);
    PlayerTextDrawFont(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Font]);
    PlayerTextDrawLetterSize(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_LetterSize][0], TDSS_System[playerid][tid][TDSS_LetterSize][1]);
    PlayerTextDrawTextSize(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_TextSize][0], TDSS_System[playerid][tid][TDSS_TextSize][1]);
    PlayerTextDrawSetOutline(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Outline]);
    PlayerTextDrawSetShadow(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Shadow]);
    PlayerTextDrawSetProportional(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Proportional]);
    PlayerTextDrawSetSelectable(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Selectable]);
    PlayerTextDrawSetPreviewModel(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Pre_Int][0]);
    PlayerTextDrawSetPreviewRot(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Pre_Float][0], TDSS_System[playerid][tid][TDSS_Pre_Float][1], TDSS_System[playerid][tid][TDSS_Pre_Float][2], TDSS_System[playerid][tid][TDSS_Pre_Float][3]);
    PlayerTextDrawSetPreviewVehCol(playerid, TDSS_System[playerid][tid][TDSS_Text], TDSS_System[playerid][tid][TDSS_Pre_Int][1], TDSS_System[playerid][tid][TDSS_Pre_Int][2]);
    PlayerTextDrawShow(playerid, TDSS_System[playerid][tid][TDSS_Text]);
    return 1;
}

cmd:tdcreate(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[TDSS]: {FFFFFF}Textdraw Created: %d", TDSS_Create(playerid)));
    return 1;
}
cmd:tddestroy(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid;
    if(sscanf(params, "d", tid)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tddestroy [id]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    PlayerTextDrawDestroy(playerid, TDSS_System[playerid][tid][TDSS_Text]);
    TDSS_System[playerid][tid][TDSS_Valid] = false;
    return 1;
}
cmd:tdhide(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid;
    if(sscanf(params, "d", tid)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdhide [id]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    PlayerTextDrawHide(playerid, TDSS_System[playerid][tid][TDSS_Text]);
    return 1;
}
cmd:tdshow(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid;
    if(sscanf(params, "d", tid)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdshow [id]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    PlayerTextDrawShow(playerid, TDSS_System[playerid][tid][TDSS_Text]);
    return 1;
}
cmd:tdtext(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, text[150];
    if(sscanf(params, "ds[150]", tid, text)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdtext [id] [text]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    format(TDSS_System[playerid][tid][TDSS_String], 256, "%s", text);
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdpos(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, Float:pos[2];
    if(sscanf(params, "dff", tid, pos[0], pos[1])) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdpos [id] [x] [y]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Position][0] = pos[0];
    TDSS_System[playerid][tid][TDSS_Position][1] = pos[1];
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdalig(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdalig [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Alignment] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdusebox(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdusebox [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Use_box] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdshadow(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdshadow [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Shadow] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdoutline(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdoutline [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Outline] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdfont(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdfont [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Font] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdprop(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdprop [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Proportional] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdselec(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dd", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdselec [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Selectable] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdtextcolor(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dN(0xFFFFFFAA)", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdtextcolor [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_TextColor] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdboxcolor(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dN(0xFFFFFFAA)", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdboxcolor [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_BoxColor] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdbgcolor(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data;
    if(sscanf(params, "dN(0xFFFFFFAA)", tid, data)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdbgcolor [id] [data]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_BackgroundColor] = data;
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdlettersize(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, Float:size[2];
    if(sscanf(params, "dff", tid, size[0], size[1])) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdlettersize [id] [x] [y]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_LetterSize][0] = size[0];
    TDSS_System[playerid][tid][TDSS_LetterSize][1] = size[1];
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdtextsize(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, Float:size[2];
    if(sscanf(params, "dff", tid, size[0], size[1])) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdtextsize [id] [x] [y]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_TextSize][0] = size[0];
    TDSS_System[playerid][tid][TDSS_TextSize][1] = size[1];
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdpreview(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, data[3];
    if(sscanf(params, "dddd", tid, data[0], data[1], data[2])) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdpreview [id] [modelid] [color1] [color2]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Pre_Int][0] = data[0];
    TDSS_System[playerid][tid][TDSS_Pre_Int][1] = data[1];
    TDSS_System[playerid][tid][TDSS_Pre_Int][2] = data[2];
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdpreviewrot(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid, Float:data[4];
    if(sscanf(params, "dffff", tid, data[0], data[1], data[2], data[3])) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdpreviewrot [id] [x] [y] [z] [zoom]");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    TDSS_System[playerid][tid][TDSS_Pre_Float][0] = data[0];
    TDSS_System[playerid][tid][TDSS_Pre_Float][1] = data[1];
    TDSS_System[playerid][tid][TDSS_Pre_Float][2] = data[2];
    TDSS_System[playerid][tid][TDSS_Pre_Float][3] = data[3];
    TDSS_Update(playerid, tid);
    return 1;
}
cmd:tdprint(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    new tid;
    if(sscanf(params, "d", tid)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/tdtextsize [id] ");
    if(TDSS_System[playerid][tid][TDSS_Valid] == false) return SendClientMessageEx(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}TDSS Not Created");
    SendClientMessage(playerid, -1, sprintf("{4286f4}[TDSS]: {FFFFFF}TDSS Printing %d", tid));
    SendClientMessage(playerid, -1, sprintf("new PlayerText:pText = CreatePlayerTextDraw(playerid, %f, %f, %s);", TDSS_System[playerid][tid][TDSS_Position][0], TDSS_System[playerid][tid][TDSS_Position][1], TDSS_System[playerid][tid][TDSS_String]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawColor(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_TextColor]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawUseBox(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Use_box]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawBoxColor(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_BoxColor]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawBackgroundColor(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_BackgroundColor]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawAlignment(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Alignment]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawFont(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Font]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawLetterSize(playerid, PlayerText:pText, %f, %f);", TDSS_System[playerid][tid][TDSS_LetterSize][0], TDSS_System[playerid][tid][TDSS_LetterSize][1]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawTextSize(playerid, PlayerText:pText, %f, %f);", TDSS_System[playerid][tid][TDSS_TextSize][0], TDSS_System[playerid][tid][TDSS_TextSize][1]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetOutline(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Outline]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetShadow(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Shadow]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetProportional(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Proportional]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetSelectable(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Selectable]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetPreviewModel(playerid, PlayerText:pText, %d);", TDSS_System[playerid][tid][TDSS_Pre_Int][0]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetPreviewRot(playerid, PlayerText:pText, %f, %f, %f, %f);", TDSS_System[playerid][tid][TDSS_Pre_Float][0], TDSS_System[playerid][tid][TDSS_Pre_Float][1], TDSS_System[playerid][tid][TDSS_Pre_Float][2], TDSS_System[playerid][tid][TDSS_Pre_Float][3]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawSetPreviewVehCol(playerid, PlayerText:pText, %d, %d);", TDSS_System[playerid][tid][TDSS_Pre_Int][1], TDSS_System[playerid][tid][TDSS_Pre_Int][2]));
    SendClientMessage(playerid, -1, sprintf("PlayerTextDrawShow(playerid, PlayerText:pText);"));
    return 1;
}
cmd:tdss(playerid, const params[]) {
    if(!IsPlayerMasterAdmin(playerid)) return 0;
    SendClientMessage(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}/tdss /tdcreate /tddestroy /tdhide /tdshow /tdtext /tdpos /tdalig /tdusebox");
    SendClientMessage(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}/tdshadow /tdoutline /tdfont /tdprop /tdselec /tdtextcolor /tdboxcolor");
    SendClientMessage(playerid, -1, "{4286f4}[TDSS]: {FFFFFF}/tdbgcolor /tdlettersize /tdtextsize /tdpreview /tdpreviewrot /tdprint");
    return 1;
}