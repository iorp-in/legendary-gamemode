#define MAX_CAMERA 100
enum CameraInterpolate:DataEnum {
    Float:Interpolate_Cord[12],
        bool:Interpolate_Available = false
}
new CameraInterpolate:Data[MAX_CAMERA][CameraInterpolate:DataEnum];

hook OnPlayerLogin(playerid) {
    CameraInterpolate:SetCameraID(playerid, -1);
    return 1;
}

stock CameraInterpolate:SetCameraID(playerid, camera_id) {
    SetPVarInt(playerid, "interpolate_camera_id", camera_id);
    return 1;
}

stock CameraInterpolate:GetCameraID(playerid) {
    new camera_id = GetPVarInt(playerid, "interpolate_camera_id");
    return camera_id;
}

stock CameraInterpolate:IsValidID(playerid) {
    new camera_id = CameraInterpolate:GetCameraID(playerid);
    if (camera_id > -1 && camera_id < MAX_CAMERA) return 1;
    return 0;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Camera Interpolate System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Camera Interpolate System", inputtext)) CameraInterpolate:Menu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "camera interpolate system") || !IsPlayerMasterAdmin(playerid)) return 1;
    CameraInterpolate:Menu(playerid);
    return ~1;
}

stock CameraInterpolate:Menu(playerid) {
    new string[512];
    strcat(string, "Set Current Camera ID\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "Set Interpolate Time\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "Start Position\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "End Position\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "Test Camera\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "Stop Camera Test\n");
    if (CameraInterpolate:IsValidID(playerid)) strcat(string, "Print Camera Cord\n");
    return FlexPlayerDialog(playerid, "CameraInterpolateMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}Update Interpolate", string, "Select", "Close");
}

FlexDialog:CameraInterpolateMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Set Current Camera ID")) return CameraInterpolate:SetCurrentCameraID(playerid);
    if (IsStringSame(inputtext, "Set Interpolate Time")) return CameraInterpolate:SetCurrentCameraTime(playerid);
    if (IsStringSame(inputtext, "Start Position")) {
        new camera_id = CameraInterpolate:GetCameraID(playerid);
        CameraInterpolate:Data[camera_id][Interpolate_Available] = true;
        GetPlayerCameraPos(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][0], CameraInterpolate:Data[camera_id][Interpolate_Cord][1], CameraInterpolate:Data[camera_id][Interpolate_Cord][2]);
        GetPlayerCameraLookAt(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][3], CameraInterpolate:Data[camera_id][Interpolate_Cord][4], CameraInterpolate:Data[camera_id][Interpolate_Cord][5]);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Updated CameraID: %d", camera_id));
        return CameraInterpolate:Menu(playerid);
    }
    if (IsStringSame(inputtext, "End Position")) {
        new camera_id = CameraInterpolate:GetCameraID(playerid);
        CameraInterpolate:Data[camera_id][Interpolate_Available] = true;
        GetPlayerCameraPos(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][6], CameraInterpolate:Data[camera_id][Interpolate_Cord][7], CameraInterpolate:Data[camera_id][Interpolate_Cord][8]);
        GetPlayerCameraLookAt(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][9], CameraInterpolate:Data[camera_id][Interpolate_Cord][10], CameraInterpolate:Data[camera_id][Interpolate_Cord][11]);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Updated CameraID: %d", camera_id));
        return CameraInterpolate:Menu(playerid);
    }
    if (IsStringSame(inputtext, "Test Camera")) {
        new camera_id = CameraInterpolate:GetCameraID(playerid);
        new camera_time = GetPVarInt(playerid, "Interpolate_Camera_Time");
        if (camera_time < 1) {
            SendClientMessage(playerid, -1, "{4286f4}[Interpolate Camera]: {FFFFEE}Current Camera Interpolate Time is Invalid");
            return CameraInterpolate:Menu(playerid);
        }
        if (!CameraInterpolate:Data[camera_id][Interpolate_Available]) return SendClientMessage(playerid, -1, "{4286f4}[Interpolate Camera]: {FFFFEE}Current Camera is not ready for Interpolate");
        Streamer_ToggleCameraUpdate(playerid, true);
        TogglePlayerSpectatingEx(playerid, true);
        InterpolateCameraPos(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][0], CameraInterpolate:Data[camera_id][Interpolate_Cord][1], CameraInterpolate:Data[camera_id][Interpolate_Cord][2], CameraInterpolate:Data[camera_id][Interpolate_Cord][6], CameraInterpolate:Data[camera_id][Interpolate_Cord][7], CameraInterpolate:Data[camera_id][Interpolate_Cord][8], camera_time, CAMERA_CUT);
        InterpolateCameraLookAt(playerid, CameraInterpolate:Data[camera_id][Interpolate_Cord][3], CameraInterpolate:Data[camera_id][Interpolate_Cord][4], CameraInterpolate:Data[camera_id][Interpolate_Cord][5], CameraInterpolate:Data[camera_id][Interpolate_Cord][9], CameraInterpolate:Data[camera_id][Interpolate_Cord][10], CameraInterpolate:Data[camera_id][Interpolate_Cord][11], camera_time, CAMERA_CUT);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Testing CameraID: %d", camera_id));
        return CameraInterpolate:Menu(playerid);
    }
    if (IsStringSame(inputtext, "Stop Camera Test")) {
        new camera_id = CameraInterpolate:GetCameraID(playerid);
        Streamer_ToggleCameraUpdate(playerid, false);
        TogglePlayerSpectatingEx(playerid, false);
        SetCameraBehindPlayer(playerid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Stoped CameraID: %d", camera_id));
        return CameraInterpolate:Menu(playerid);
    }
    if (IsStringSame(inputtext, "Print Camera Cord")) {
        new camera_id = CameraInterpolate:GetCameraID(playerid);
        new camera_time = GetPVarInt(playerid, "Interpolate_Camera_Time");
        if (camera_time < 1) return SendClientMessage(playerid, -1, "{4286f4}[Interpolate Camera]: {FFFFEE}Current Camera Interpolate Time is Invalid");
        if (!CameraInterpolate:Data[camera_id][Interpolate_Available]) return SendClientMessage(playerid, -1, "{4286f4}[Interpolate Camera]: {FFFFEE}Current Camera is not ready for Interpolate");
        SendClientMessage(playerid, -1, sprintf("ICP(playerid, %f, %f, %f, %f, %f, %f, %d);", CameraInterpolate:Data[camera_id][Interpolate_Cord][0], CameraInterpolate:Data[camera_id][Interpolate_Cord][1], CameraInterpolate:Data[camera_id][Interpolate_Cord][2], CameraInterpolate:Data[camera_id][Interpolate_Cord][6], CameraInterpolate:Data[camera_id][Interpolate_Cord][7], CameraInterpolate:Data[camera_id][Interpolate_Cord][8], camera_time));
        SendClientMessage(playerid, -1, sprintf("ICLA(playerid, %f, %f, %f, %f, %f, %f, %d);", CameraInterpolate:Data[camera_id][Interpolate_Cord][3], CameraInterpolate:Data[camera_id][Interpolate_Cord][4], CameraInterpolate:Data[camera_id][Interpolate_Cord][5], CameraInterpolate:Data[camera_id][Interpolate_Cord][9], CameraInterpolate:Data[camera_id][Interpolate_Cord][10], CameraInterpolate:Data[camera_id][Interpolate_Cord][11], camera_time));
        return CameraInterpolate:Menu(playerid);
    }
    return 1;
}

stock CameraInterpolate:SetCurrentCameraID(playerid) {
    return FlexPlayerDialog(
        playerid, "SetCurrentCameraID", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFEE}Update Interpolate", "Enter Camera ID: Limit 0-99", "Submit", "Close"
    );
}

FlexDialog:SetCurrentCameraID(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return CameraInterpolate:Menu(playerid);
    new camera_id;
    if (sscanf(inputtext, "d", camera_id) || camera_id < 0 || camera_id > 99) return CameraInterpolate:Menu(playerid);
    CameraInterpolate:SetCameraID(playerid, camera_id);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Updated Current Camera ID to %d", camera_id));
    return CameraInterpolate:Menu(playerid);
}

stock CameraInterpolate:SetCurrentCameraTime(playerid) {
    return FlexPlayerDialog(
        playerid, "SetCurrentCameraTime", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFEE}Update Interpolate", "Enter Interpolate Time", "Submit", "Close"
    );
}

FlexDialog:SetCurrentCameraTime(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return CameraInterpolate:Menu(playerid);
    new camera_time;
    if (sscanf(inputtext, "d", camera_time) || camera_time < 0) return CameraInterpolate:Menu(playerid);
    SetPVarInt(playerid, "Interpolate_Camera_Time", camera_time);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Interpolate Camera]: {FFFFEE}Updated Current Interpolate Number to %d", camera_time));
    return CameraInterpolate:Menu(playerid);
}