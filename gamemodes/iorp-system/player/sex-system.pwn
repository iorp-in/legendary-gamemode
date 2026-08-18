enum SexAnimEnum {
    PositionName[20],
        Anim_Woman_Name[20],
        Anim_Woman_Lib[20],
        Anim_Man_Name[20],
        Anim_Man_Lib[20],
        Float:distance_diff,
        Float:angle_diff
}

new SexPositions[][SexAnimEnum] = {
    // 0
    {
        "Position Mode",
        "SNM",
        "SPANKINGW",
        "SNM",
        "SPANKEDP",
        0.3,
        0.0
    },
    // 1
    {
        "Position Mode",
        "BLOWJOBZ",
        "BJ_COUCH_LOOP_W",
        "BLOWJOBZ",
        "BJ_COUCH_LOOP_P",
        0.8,
        180.0
    },
    // 2
    {
        "Position Mode",
        "BLOWJOBZ",
        "BJ_STAND_LOOP_W",
        "BLOWJOBZ",
        "BJ_STAND_LOOP_P",
        0.9,
        180.0
    },
    // 3
    {
        "Position Mode",
        "CRACK",
        "crckidle1",
        "SNM",
        "SPANKEDP",
        0.3,
        180.0
    },
    // 4
    {
        "Position Mode",
        "BLOWJOBZ",
        "BJ_COUCH_LOOP_W",
        "BLOWJOBZ",
        "BJ_COUCH_LOOP_P",
        0.5,
        180.0
    },
    // 5
    {
        "Position Mode",
        "BEACH",
        "ParkSit_W_Loop",
        "BEACH",
        "Lay_Bac_Loop",
        0.2,
        270.0
    },
    // 6
    {
        "Position Mode",
        "BLOWJOBZ",
        "BJ_STAND_LOOP_W",
        "BLOWJOBZ",
        "BJ_STAND_LOOP_P",
        0.9,
        180.0
    },
    // 7
    {
        "Position Mode",
        "SNM",
        "SPANKINGW",
        "SNM",
        "SPANKINGP",
        0.5,
        0.0
    },
    // 8
    {
        "Position Mode",
        "CRACK",
        "crckidle4",
        "CRACK",
        "crckidle1",
        0.4,
        270.0
    },
    // 9
    {
        "Position Mode",
        "CRACK",
        "crckidle2",
        "CRACK",
        "crckidle2",
        0.3,
        0.0
    },
    // 10
    {
        "Position Mode",
        "CRACK",
        "crckidle4",
        "PAULNMAC",
        "wank_loop",
        0.3,
        0.0
    }
};

enum SexDataEnum {
    bool:InSex,
    SexPartner,
    Float:Sex_Init_Pos_X,
    Float:Sex_Init_Pos_Y,
    Float:Sex_Init_Pos_Z,
    Float:Sex_Init_Pos_A
}
new SexPlayerData[MAX_PLAYERS][SexDataEnum];

stock bool:GetPlayerInSexStatus(playerid) {
    return SexPlayerData[playerid][InSex];
}

stock bool:SetPlayerInSexStatus(playerid, bool:status = false) {
    SexPlayerData[playerid][InSex] = status;
    return status;
}

stock GetPlayerSexPartner(playerid) {
    return SexPlayerData[playerid][SexPartner];
}

stock SetPlayerSexPartner(playerid, partnerid) {
    SexPlayerData[playerid][SexPartner] = partnerid;
    return partnerid;
}

stock GetPlayerSexPosition(playerid, & Float:xx, & Float:yy, & Float:zz, & Float:angle) {
    xx = SexPlayerData[playerid][Sex_Init_Pos_X];
    yy = SexPlayerData[playerid][Sex_Init_Pos_Y];
    zz = SexPlayerData[playerid][Sex_Init_Pos_Z];
    angle = SexPlayerData[playerid][Sex_Init_Pos_A];
    return 1;
}

stock SetPlayerSexPosition(playerid, Float:xx, Float:yy, Float:zz, Float:angle) {
    SexPlayerData[playerid][Sex_Init_Pos_X] = xx;
    SexPlayerData[playerid][Sex_Init_Pos_Y] = yy;
    SexPlayerData[playerid][Sex_Init_Pos_Z] = zz;
    SexPlayerData[playerid][Sex_Init_Pos_A] = angle;
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;

    // check if players are in same house
    if (
        (House:GetPlayerHouseID(playerid) != House:GetPlayerHouseID(targetid)) ||
        !House:IsValidID(House:GetPlayerHouseID(playerid))
    ) return 1;

    // check if they can do woo hoo
    if ((IsPlayerMale(playerid) && !IsPlayerMale(targetid)) || (IsPlayerMale(targetid) && !IsPlayerMale(playerid))) {
        QuickActions:AddCommand(playerid, "Do Woo-Hoo");
    }
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Do Woo-Hoo", inputtext)) {
        WooHooCommand(playerid, targetid);
        return ~1;
    }
    return 1;
}

stock WooHooCommand(playerid, targetid) {
    new Float:xx, Float:yy, Float:zz, Float:angle;
    GetPlayerPos(playerid, Float:xx, Float:yy, Float:zz);
    GetPlayerFacingAngle(playerid, Float:angle);
    SetPlayerSexPosition(playerid, Float:xx, Float:yy, Float:zz, Float:angle);
    GetPlayerPos(targetid, Float:xx, Float:yy, Float:zz);
    GetPlayerFacingAngle(targetid, Float:angle);
    SetPlayerSexPosition(targetid, Float:xx, Float:yy, Float:zz, Float:angle);
    if (IsPlayerMale(playerid) && !IsPlayerMale(targetid)) {
        SetSexMode(playerid, targetid);
    } else if (IsPlayerMale(targetid) && !IsPlayerMale(playerid)) {
        SetSexMode(targetid, playerid);
    } else return 1;
    SetPlayerInSexStatus(playerid, true);
    SetPlayerInSexStatus(targetid, true);
    SetPlayerSexPartner(playerid, targetid);
    SetPlayerSexPartner(targetid, playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Woo-Hoo]: {FFFFEE}By pressing H, you can change your sex position");
    SendClientMessage(targetid, -1, "{4286f4}[Woo-Hoo]: {FFFFEE}By pressing H, you can change your sex position");
    return 1;
}

stock SetSexMode(maleid, femaleid, modeid = 0) {
    if (!IsPlayerMale(maleid) || IsPlayerMale(femaleid)) return 1;
    if (modeid < 0 || modeid >= sizeof SexPositions) return 1;
    new Float:xx, Float:yy, Float:zz, Float:angle, Float:xx2, Float:yy2, Float:angle2;
    GetPlayerSexPosition(maleid, Float:xx, Float:yy, Float:zz, Float:angle);
    xx2 = xx + (SexPositions[modeid][distance_diff] * floatsin(-angle, degrees));
    yy2 = yy + (SexPositions[modeid][distance_diff] * floatcos(-angle, degrees));
    angle2 = SexPositions[modeid][angle_diff];

    SetPlayerPos(maleid, Float:xx, Float:yy, Float:zz);
    SetPlayerFacingAngle(maleid, Float:angle);
    ApplyAnimation(maleid, SexPositions[modeid][Anim_Man_Name], SexPositions[modeid][Anim_Man_Lib], 4, 1, 0, 0, 1, 0, 1);
    Anim:SetState(maleid, true);

    SetPlayerPos(femaleid, Float:xx2, Float:yy2, Float:zz);
    SetPlayerFacingAngle(femaleid, Float:angle - Float:angle2);
    ApplyAnimation(femaleid, SexPositions[modeid][Anim_Woman_Name], SexPositions[modeid][Anim_Woman_Lib], 4, 1, 0, 0, 1, 0, 1);
    Anim:SetState(femaleid, true);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (!GetPlayerInSexStatus(playerid)) return 1;
    if (newkeys == KEY_SPRINT || newkeys == KEY_FIRE) {
        Anim:Stop(playerid);
        SetPlayerInSexStatus(playerid, false);
        if (IsPlayerConnected(GetPlayerSexPartner(playerid))) {
            Anim:Stop(GetPlayerSexPartner(playerid));
            SetPlayerInSexStatus(GetPlayerSexPartner(playerid), false);
            SetPlayerSexPartner(GetPlayerSexPartner(playerid), -1);
        }
        SetPlayerSexPartner(playerid, -1);
        return 1;
    }
    if (newkeys == KEY_CTRL_BACK) {
        ChangeSexPosCommand(playerid);
        return 1;
    }
    return 1;
}

stock ChangeSexPosCommand(playerid) {
    if (!GetPlayerInSexStatus(playerid)) return 1;
    new string[1024];
    strcat(string, "ID\tPosition\n");
    for (new i; i < sizeof SexPositions; i++) strcat(string, sprintf("%d\t%s\n", i, SexPositions[i][PositionName]));
    return FlexPlayerDialog(playerid, "ChangeSexPosCommand", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Woo Hoo]: {FFFFEE}Change Sex Position", string, "Change", "Close");
}

FlexDialog:ChangeSexPosCommand(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response || !GetPlayerInSexStatus(playerid)) return 1;
    new sexmode = strval(inputtext);
    if (IsPlayerMale(playerid)) SetSexMode(playerid, GetPlayerSexPartner(playerid), sexmode);
    else SetSexMode(GetPlayerSexPartner(playerid), playerid, sexmode);
    return 1;
}

// 
// new bactor_ids;
// cmd:sex1(playerid, const params[]) {
//     new Float:xx, Float:yy, Float:zz, Float:ang;
//     new Float:xx2, Float:yy2;
// 
//     new sid, Float:ang2, Float:TDis;
// 
//     if(sscanf(params, "dff", sid, Float:ang2, Float:TDis)) return SendClientMessage(playerid, -1, "id angle distance");
//     if(sid < 0 || sid >= sizeof SexPositions) return SendClientMessage(playerid, -1, "invalid id");
// 
//     GetPlayerPos(playerid, Float:xx, Float:yy, Float:zz);
//     GetPlayerFacingAngle(playerid, Float:ang);
//     GetXYInFrontOfPlayer(playerid, Float:xx2, Float:yy2, TDis);
// 
//     ApplyAnimation(playerid, SexPositions[sid][Anim_Man_Name], SexPositions[sid][Anim_Man_Lib], 4, 1, 0, 0, 1, 0, 1);
// 
//     bactor_ids = CreateDynamicActor(193, Float:xx2, Float:yy2, Float:zz, Float:ang - ang2);
//     ApplyDynamicActorAnimation(bactor_ids, SexPositions[sid][Anim_Woman_Name], SexPositions[sid][Anim_Woman_Lib], 4, 1, 0, 0, 1, 0);
//     Anim:SetState(playerid, true);
//     return 1;
// }
// 
// cmd:sex2(playerid, const params[]) {
//     DestroyDynamicActor(bactor_ids);
//     return 1;
// }