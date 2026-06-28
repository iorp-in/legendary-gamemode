enum PB_enum {
    PlayerBar:PB_ID,
    Float:PB_posX,
    Float:PB_posY,
    Float:PB_width,
    Float:PB_height,
    PB_colour,
    Float:PB_max,
    PB_direction,
    Float:PB_Value
}

// BAR_DIRECTION_RIGHT 0
// BAR_DIRECTION_LEFT 1
// BAR_DIRECTION_UP 2
// BAR_DIRECTION_DOWN 3

#define Max_PB 100
new PB_System[MAX_PLAYERS][Max_PB][PB_enum];
new Iterator:PB_Collection < Max_PB > ;

cmd:pbcreate(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId = Iter_Free(PB_Collection);
    if (pbId == INVALID_ITERATOR_SLOT) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}limit exceeded");
    PB_System[playerid][pbId][PB_ID] = CreatePlayerProgressBar(playerid, 320.0, 240.0, 55.5, 3.2, 0xFF1C1CFF, 100.0, BAR_DIRECTION_RIGHT);
    ShowPlayerProgressBar(playerid, PB_System[playerid][pbId][PB_ID]);
    PB_System[playerid][pbId][PB_posX] = 320.0;
    PB_System[playerid][pbId][PB_posY] = 240.0;
    PB_System[playerid][pbId][PB_width] = 55.5;
    PB_System[playerid][pbId][PB_height] = 3.2;
    PB_System[playerid][pbId][PB_colour] = 0xFF1C1CFF;
    PB_System[playerid][pbId][PB_max] = 100.0;
    PB_System[playerid][pbId][PB_direction] = BAR_DIRECTION_RIGHT;
    PB_System[playerid][pbId][PB_Value] = 25.0;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar created with id %d", pbId));
    Iter_Add(PB_Collection, pbId);
    return 1;
}
cmd:pbdestroy(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId;
    if (sscanf(params, "d", pbId)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbdestroy [id]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    DestroyPlayerProgressBar(playerid, PB_System[playerid][pbId][PB_ID]);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar destroyed for id %d", pbId));
    Iter_Remove(PB_Collection, pbId);
    return 1;
}
cmd:pbshow(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId;
    if (sscanf(params, "d", pbId)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbshow [id]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    ShowPlayerProgressBar(playerid, PB_System[playerid][pbId][PB_ID]);
    return 1;
}
cmd:pbhide(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId;
    if (sscanf(params, "d", pbId)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbhide [id]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    HidePlayerProgressBar(playerid, PB_System[playerid][pbId][PB_ID]);
    return 1;
}
cmd:pbpos(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, Float:xx, Float:yy;
    if (sscanf(params, "dff", pbId, xx, yy)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbpos [id] [x] [y]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_posX] = xx;
    PB_System[playerid][pbId][PB_posY] = yy;
    SetPlayerProgressBarPos(playerid, PB_System[playerid][pbId][PB_ID], xx, yy);
    return 1;
}
cmd:pbwidth(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, Float:width;
    if (sscanf(params, "df", pbId, width)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbwidth [id] [width]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_width] = width;
    SetPlayerProgressBarWidth(playerid, PB_System[playerid][pbId][PB_ID], width);
    return 1;
}
cmd:pbheight(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, Float:height;
    if (sscanf(params, "df", pbId, height)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbheight [id] [height]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_height] = height;
    SetPlayerProgressBarHeight(playerid, PB_System[playerid][pbId][PB_ID], height);
    return 1;
}
cmd:pbcolor(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, color;
    if (sscanf(params, "dN(0xFFFFFFAA)", pbId, color)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbcolor [id] [0xFFFFFFAA]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_colour] = color;
    SetPlayerProgressBarColour(playerid, PB_System[playerid][pbId][PB_ID], color);
    return 1;
}
cmd:pbmax(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, Float:maxVal;
    if (sscanf(params, "df", pbId, maxVal)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbmax [id] [Max]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_max] = maxVal;
    SetPlayerProgressBarMaxValue(playerid, PB_System[playerid][pbId][PB_ID], maxVal);
    return 1;
}
cmd:pbdirection(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, direct;
    if (sscanf(params, "dd", pbId, direct)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbdirection [id] [1-4]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_direction] = direct;
    SetPlayerProgressBarDirection(playerid, PB_System[playerid][pbId][PB_ID], direct);
    return 1;
}
cmd:pbset(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId, Float:set;
    if (sscanf(params, "df", pbId, set)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbset [id] [value]");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar Not Created");
    PB_System[playerid][pbId][PB_Value] = set;
    SetPlayerProgressBarValue(playerid, PB_System[playerid][pbId][PB_ID], set);
    return 1;
}
cmd:pbprint(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pbId;
    if (sscanf(params, "d", pbId)) return SendClientMessageEx(playerid, -1, "{db6600}[Usage]: {FFFFEE}/pbprint [id] ");
    if (!Iter_Contains(PB_Collection, pbId)) return SendClientMessageEx(playerid, -1, "{4286f4}[PB]: {FFFFFF}progress bar not created");
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar Printing %d", pbId));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar Position x: %f y: %f", PB_System[playerid][pbId][PB_posX], PB_System[playerid][pbId][PB_posY]));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar Position width: %f height: %f", PB_System[playerid][pbId][PB_width], PB_System[playerid][pbId][PB_height]));
    SendClientMessage(playerid, -1, sprintf("{4286f4}[PB]: {FFFFFF}Progress Bar Position color: %d max: %f direction: %d", PB_System[playerid][pbId][PB_colour], PB_System[playerid][pbId][PB_max], PB_System[playerid][pbId][PB_direction]));
    return 1;
}
cmd:pbh(playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    SendClientMessage(playerid, -1, "{4286f4}[PB]: {FFFFFF}/pbcreate /pbdestroy /pbshow /pbhide /pbpos /pbwidth /pbheight /pbcolor /pbmax");
    SendClientMessage(playerid, -1, "{4286f4}[PB]: {FFFFFF}/pbdirection /pbset /pbprint /pbh");
    return 1;
}