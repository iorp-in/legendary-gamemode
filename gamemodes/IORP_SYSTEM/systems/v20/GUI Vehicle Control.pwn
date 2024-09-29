#define GUI_MAX_VEHICLE_PARAMS 6

new Text:TextDrawVehiclePanel[10], PlayerText:PlayerTextDrawPanel[MAX_PLAYERS];

new paramsName[GUI_MAX_VEHICLE_PARAMS][3][10] = {
    { "Engine", "On", "Off" },
    { "Lights", "On", "Off" },
    { "Alarm", "On", "Off" },
    { "Doors", "Unlock", "Lock" },
    { "Bonnet", "Close", "Open" },
    { "Boot", "Close", "Open" }
};

hook OnGameModeInit() {
    TextDrawVehiclePanel[0] = TextDrawCreate(4.000000, 230.000000, "usebox");
    TextDrawBackgroundColor(TextDrawVehiclePanel[0], 0);
    TextDrawFont(TextDrawVehiclePanel[0], 1);
    TextDrawLetterSize(TextDrawVehiclePanel[0], 0.500000, 9.699998);
    TextDrawColor(TextDrawVehiclePanel[0], 0);
    TextDrawSetOutline(TextDrawVehiclePanel[0], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[0], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[0], 1);
    TextDrawUseBox(TextDrawVehiclePanel[0], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[0], 150);
    TextDrawTextSize(TextDrawVehiclePanel[0], 101.000000, 0.000000);

    TextDrawVehiclePanel[1] = TextDrawCreate(5.000000, 232.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[1], 255);
    TextDrawFont(TextDrawVehiclePanel[1], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[1], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[1], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[1], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[1], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[1], 1);
    TextDrawUseBox(TextDrawVehiclePanel[1], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[1], 255);
    TextDrawTextSize(TextDrawVehiclePanel[1], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[1], 1);

    TextDrawVehiclePanel[2] = TextDrawCreate(5.000000, 246.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[2], 255);
    TextDrawFont(TextDrawVehiclePanel[2], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[2], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[2], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[2], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[2], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[2], 1);
    TextDrawUseBox(TextDrawVehiclePanel[2], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[2], 255);
    TextDrawTextSize(TextDrawVehiclePanel[2], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[2], 1);

    TextDrawVehiclePanel[3] = TextDrawCreate(5.000000, 260.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[3], 255);
    TextDrawFont(TextDrawVehiclePanel[3], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[3], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[3], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[3], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[3], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[3], 1);
    TextDrawUseBox(TextDrawVehiclePanel[3], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[3], 255);
    TextDrawTextSize(TextDrawVehiclePanel[3], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[3], 1);

    TextDrawVehiclePanel[4] = TextDrawCreate(5.000000, 274.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[4], 255);
    TextDrawFont(TextDrawVehiclePanel[4], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[4], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[4], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[4], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[4], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[4], 1);
    TextDrawUseBox(TextDrawVehiclePanel[4], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[4], 255);
    TextDrawTextSize(TextDrawVehiclePanel[4], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[4], 1);

    TextDrawVehiclePanel[5] = TextDrawCreate(5.000000, 288.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[5], 255);
    TextDrawFont(TextDrawVehiclePanel[5], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[5], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[5], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[5], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[5], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[5], 1);
    TextDrawUseBox(TextDrawVehiclePanel[5], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[5], 255);
    TextDrawTextSize(TextDrawVehiclePanel[5], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[5], 1);

    TextDrawVehiclePanel[6] = TextDrawCreate(5.000000, 302.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[6], 255);
    TextDrawFont(TextDrawVehiclePanel[6], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[6], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[6], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[6], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[6], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[6], 1);
    TextDrawUseBox(TextDrawVehiclePanel[6], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[6], 255);
    TextDrawTextSize(TextDrawVehiclePanel[6], 95.000000, 12.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[6], 1);

    new string[GUI_MAX_VEHICLE_PARAMS * 25];

    for (new id; id < GUI_MAX_VEHICLE_PARAMS; id++) {
        format(string, sizeof string, "%s%s~n~~n~", string, paramsName[id][0]);
    }

    TextDrawVehiclePanel[7] = TextDrawCreate(7.000000, 234.000000, string);
    TextDrawBackgroundColor(TextDrawVehiclePanel[7], 0);
    TextDrawFont(TextDrawVehiclePanel[7], 1);
    TextDrawLetterSize(TextDrawVehiclePanel[7], 0.189999, 0.783999);
    TextDrawColor(TextDrawVehiclePanel[7], -106);
    TextDrawSetOutline(TextDrawVehiclePanel[7], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[7], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[7], 1);

    TextDrawVehiclePanel[8] = TextDrawCreate(104.000000, 228.000000, "ld_dual:white");
    TextDrawBackgroundColor(TextDrawVehiclePanel[8], 255);
    TextDrawFont(TextDrawVehiclePanel[8], 4);
    TextDrawLetterSize(TextDrawVehiclePanel[8], 0.500000, 1.000000);
    TextDrawColor(TextDrawVehiclePanel[8], 252645375);
    TextDrawSetOutline(TextDrawVehiclePanel[8], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[8], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[8], 1);
    TextDrawUseBox(TextDrawVehiclePanel[8], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[8], 255);
    TextDrawTextSize(TextDrawVehiclePanel[8], 9.000000, 91.000000);
    TextDrawSetSelectable(TextDrawVehiclePanel[8], 1);

    TextDrawVehiclePanel[9] = TextDrawCreate(104.000000, 268.000000, "~<~");
    TextDrawBackgroundColor(TextDrawVehiclePanel[9], 0);
    TextDrawFont(TextDrawVehiclePanel[9], 2);
    TextDrawLetterSize(TextDrawVehiclePanel[9], 0.159999, 0.983999);
    TextDrawColor(TextDrawVehiclePanel[9], -206);
    TextDrawSetOutline(TextDrawVehiclePanel[9], 0);
    TextDrawSetProportional(TextDrawVehiclePanel[9], 1);
    TextDrawSetShadow(TextDrawVehiclePanel[9], 1);
    TextDrawUseBox(TextDrawVehiclePanel[9], 1);
    TextDrawBoxColor(TextDrawVehiclePanel[9], 0);
    TextDrawTextSize(TextDrawVehiclePanel[9], 101.000000, 10.000000);
    return 1;
}

hook OnPlayerConnect(playerid) {
    PlayerTextDrawPanel[playerid] = CreatePlayerTextDraw(playerid, 65.000000, 234.000000, "OFF~n~~n~OFF~n~~n~OFF~n~~n~OFF~n~~n~OFF~n~~n~OFF");
    PlayerTextDrawBackgroundColor(playerid, PlayerTextDrawPanel[playerid], 0);
    PlayerTextDrawFont(playerid, PlayerTextDrawPanel[playerid], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTextDrawPanel[playerid], 0.149999, 0.783999);
    PlayerTextDrawColor(playerid, PlayerTextDrawPanel[playerid], -206);
    PlayerTextDrawSetOutline(playerid, PlayerTextDrawPanel[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTextDrawPanel[playerid], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTextDrawPanel[playerid], 1);
    return 1;
}

stock ShowTextDrawsPanel(playerid) {
    if (GetPVarInt(playerid, "p_Panel")) return 0;
    for (new textdraw; textdraw < sizeof TextDrawVehiclePanel; textdraw++) TextDrawShowForPlayer(playerid, TextDrawVehiclePanel[textdraw]);
    new p_vehid = GetPlayerVehicleID(playerid);
    FixUnsetParameters(p_vehid);
    UpdatePlayerVehicleParams(playerid);
    PlayerTextDrawShow(playerid, PlayerTextDrawPanel[playerid]);
    SelectTextDraw(playerid, 0x222222FF);
    SetPVarInt(playerid, "p_panel", 1);
    return 1;
}

stock HideTextDrawsPanel(playerid) {
    if (!GetPVarInt(playerid, "p_Panel")) return 0;
    for (new textdraw; textdraw < sizeof TextDrawVehiclePanel; textdraw++) TextDrawHideForPlayer(playerid, TextDrawVehiclePanel[textdraw]);
    PlayerTextDrawHide(playerid, PlayerTextDrawPanel[playerid]);
    CancelSelectTextDraw(playerid);
    DeletePVar(playerid, "p_panel");
    return 1;
}

stock UpdatePlayerVehicleParams(playerid) {
    new p_vehparams[GUI_MAX_VEHICLE_PARAMS + 1];
    new p_vehid = GetPlayerVehicleID(playerid);
    GetVehicleParamsEx(p_vehid, p_vehparams[0], p_vehparams[1], p_vehparams[2], p_vehparams[3], p_vehparams[4], p_vehparams[5], p_vehparams[6]);
    new string[GUI_MAX_VEHICLE_PARAMS * 25];
    for (new params; params < GUI_MAX_VEHICLE_PARAMS; params++) format(string, sizeof string, "%s%s~n~ ~n~", string, p_vehparams[params] ? paramsName[params][1] : paramsName[params][2]);
    PlayerTextDrawSetString(playerid, PlayerTextDrawPanel[playerid], string);
    return 1;
}

stock UpdateVehicleParams(playerid, param) {
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    if (param == 0) switch_engine(playerid);
    if (param == 1) switch_lights(playerid);
    if (param == 2) switch_alarm(playerid);
    if (param == 3) switch_doors(playerid);
    if (param == 4) switch_bonnet(playerid);
    if (param == 5) switch_boot(playerid);
    UpdatePlayerVehicleParams(playerid);
    if (param == 3) PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys & KEY_LOOK_BEHIND) && (newkeys & KEY_HANDBRAKE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVIPLevel(playerid) > 0) ShowTextDrawsPanel(playerid);
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (GetPVarInt(playerid, "p_panel")) {
        if (clickedid == TextDrawVehiclePanel[8] || clickedid == Text:INVALID_TEXT_DRAW) {
            HideTextDrawsPanel(playerid);
            return 1;
        }

        new id = GUI_MAX_VEHICLE_PARAMS;
        while (id--) {
            if (clickedid == TextDrawVehiclePanel[id + 1]) {
                UpdateVehicleParams(playerid, id);
                break;
            }
        }
    }
    return 1;
}

stock FixUnsetParameters(vehicleid) {
    new params[7];
    GetVehicleParamsEx(vehicleid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
    SetVehicleParamsEx(vehicleid,
        params[0] < 0 ? 1 : params[0], // Motor
        params[1] < 0 ? 0 : params[1], // Svjetla
        params[2] < 0 ? 0 : params[2], // Alarm
        params[3] < 0 ? 0 : params[3], // Vrata
        params[4] < 0 ? 0 : params[4], // Hauba
        params[5] < 0 ? 0 : params[5], // Gepek
        params[6]); // Objective
    return 1;
}