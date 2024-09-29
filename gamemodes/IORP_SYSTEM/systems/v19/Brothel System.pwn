#define BITCHES 4
#define AKTORS 40

#define LMB 0
#define RMB 1

new Text:moviemod[2], Text:exctext, Text:bshadow, Text:gagnfuck;

enum e_Player {
    PlayerText:ExcBalken,
    pFuckedBitch[BITCHES],
    pMovieMod,
    pInArea,
    pBitch,
    keyOrder,
    excMod,
    excTimer,
    Float:pExcitement,
    pFail
}
new JMPlayer[MAX_PLAYERS][e_Player];

new ActorID[AKTORS];

enum e_bitches {
    bID,
    bBusy,
    Text3D:bLabel
}
new Bitch[BITCHES][e_bitches];

new Float:iActorPos[AKTORS][4] = {
    { 2241.8386, -1192.1924, 1029.7969, 179.0464 },
    { 2241.7595, -1193.3571, 1029.7969, 355.9131 },
    { 2244.6501, -1184.7622, 1029.7969, 134.5527 },
    { 2243.8542, -1185.4703, 1029.8043, 313.6265 },
    { 2252.5945, -1158.2295, 1030.4410, 260.4296 },
    { 2253.2141, -1158.3763, 1030.4410, 179.7338 },
    { 2253.7300, -1160.0260, 1029.7969, 21.6198 },
    { 2254.1301, -1160.5228, 1029.8234, 212.6288 },
    { 2251.2595, -1164.1918, 1029.7969, 308.2752 },
    { 2252.0063, -1163.6501, 1029.7969, 127.2379 },
    { 2251.3088, -1164.1071, 1029.7969, 307.9857 },
    { 2251.4631, -1163.4331, 1029.7969, 226.2047 },
    { 2251.7854, -1164.3396, 1029.7969, 2.5068 },
    { 2248.6479, -1185.4998, 1030.4155, 270.1193 },
    { 2248.2444, -1185.4559, 1030.4408, 268.8192 },
    { 2242.8718, -1149.5781, 1029.7969, 91.2535 },
    { 2241.9275, -1149.6183, 1029.7969, 270.6991 },
    { 2239.6919, -1159.2660, 1029.7969, 280.0941 },
    { 2243.8235, -1189.1289, 1029.90, 269.4104 },
    { 2244.50, -1189.0308, 1029.8043, 179.6376 },
    { 2233.0732, -1160.9913, 25.8906, 59.2685 },
    { 2209.1672, -1144.6469, 25.7964, 46.4236 },
    { 2232.4165, -1180.4719, 25.8906, 69.1516 },
    { 2232.1416, -1174.6890, 25.8972, 234.4017 },
    { 2233.2546, -1168.7101, 25.8972, 85.0362 },
    { 2218.9924, -1172.6731, 25.7266, 2.9911 },
    { 2209.3762, -1150.4557, 29.7969, 358.1461 },
    { 2202.5247, -1163.2509, 29.7969, 271.0621 },
    { 2223.6086, -1184.3351, 1030.2969, 302.8044 },
    { 2217.1760, -1145.3915, 1026.1833, 175.3461 },
    { 2215.8076, -1144.8032, 1026.1833, 281.5670 },
    { 2224.1853, -1181.6268, 1029.7969, 200.9700 },
    { 2223.5735, -1177.2275, 1030.4384, 179.2773 },
    { 2223.6733, -1177.0520, 1030.4913, 179.3792 },
    { 2231.7378, -1164.9625, 1029.7969, 179.9529 },
    { 2236.0391, -1154.4547, 1030.4943, 147.3170 },
    { 2235.4265, -1166.1948, 1030.4943, 220.4438 },
    { 2234.7705, -1166.8312, 1029.7969, 307.1024 },
    { 2230.8052, -1183.3383, 1030.5249, 75.9637 },
    { 2231.5518, -1183.2582, 1030.5249, 270.0039 }
};

new iActorAnimLib[AKTORS][2][128] = {
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_W" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_W" },
    { "BEACH", "ParkSit_W_Loop" },
    { "BEACH", "Lay_Bac_Loop" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "SWEET", "Sweet_injuredloop" },
    { "BLOWJOBZ", "BJ_STAND_LOOP_W" },
    { "BLOWJOBZ", "BJ_STAND_LOOP_P" },
    { "PAULNMAC", "wank_loop" },
    { "PAULNMAC", "wank_loop" },
    { "PAULNMAC", "wank_loop" },
    { "SNM", "SPANKINGW" },
    { "SNM", "SPANKINGP" },
    { "BLOWJOBZ", "BJ_STAND_LOOP_W" },
    { "WUZI", "Wuzi_stand_loop" },
    { "SMOKING", "F_smklean_loop" },
    { "CRACK", "crckidle1" },
    { "CRACK", "crckidle4" },
    { "WUZI", "Wuzi_stand_loop" },
    { "GRAVEYARD", "mrnF_loop" },
    { "SMOKING", "F_smklean_loop" },
    { "PED", "phone_talk" },
    { "SMOKING", "M_smk_drag" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "SMOKING", "F_smklean_loop" },
    { "PED", "phone_talk" },
    { "BEACH", "ParkSit_W_Loop" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "PED", "SEAT_IDLE" },
    { "BLOWJOBZ", "BJ_COUCH_LOOP_P" },
    { "CRACK", "crckidle2" },
    { "CRACK", "crckidle2" },
    { "PED", "SEAT_IDLE" },
    { "BEACH", "Lay_Bac_Loop" },
    { "CRACK", "crckidle4" },
    { "PAULNMAC", "wank_loop" },
    { "BEACH", "Lay_Bac_Loop" },
    { "SWEET", "Sweet_injuredloop" }
};

new iActorModel[AKTORS] = { 101, 237, 3, 87, 237, 154, 87, 8, 139, 97, 154, 18, 146, 64, 18, 193, 33, 75, 257, 64, 163, 226, 237, 238, 243, 131, 85, 201, 63, 249, 85, 207, 139, 18, 245, 154, 237, 146, 97, 246 };

new Float:iBitchPos[BITCHES][27] = {
    //bX,bY,bZ,bAngle,bBusyAngle,pedX,pedY,pedZ,pedBusyAngle,camX,camY,camZ,camlookx,camlooky,camlookz,moviemaxX,moviemaxY,moviemaxZ,movieminX,movieminY,movieminZ,moviecamX,moviecamY,moviecamZ,movielookX,movielookY,movielookZ
    { 2204.2603, -1193.9603, 1030.5249, 269.3243, 87.7342, 2204.4917, -1193.9486, 1030.5249, 91.0367, 2204.0039, -1193.9689, 1030.7862, 2203.4665, -1193.9736, 1029.5133, 2211.3813, -1185.0820, 1036.0000, 2201.5852, -1202.9032, 1020.0000, 2202.0046, -1195.3774, 1030.0256, 2202.8659, -1194.8697, 1029.9411 }, //bitch in room no 7   
    { 2247.0784, -1193.2322, 1029.7969, 31.3569, 213.3587, 2247.7520, -1194.1115, 1029.7969, 28.9105, 2242.8777, -1192.4258, 1029.7969, 2247.7520, -1194.1115, 1029.4969, 2249.7195, -1179.9448, 1033.0021, 2238.8054, -1195.9973, 1028.0043, 2248.3386, -1193.9710, 1029.6519, 2247.6442, -1193.2555, 1029.728 }, //bitch in the waiting room  
    { 2239.0586, -1188.9985, 1033.7969, 1.3491, 1.3491, 2239.0454, -1188.0107, 1033.7969, 183.3017, 2243.4841, -1187.6042, 1035.6547, 2242.5664, -1187.6758, 1035.2642, 2245.2495, -1179.3004, 1037.6178, 2238.4856, -1195.7620, 1033.0021, 2238.8078, -1190.5073, 1033.6431, 2239.1151, -1189.5558, 1033.6402 }, //bitch on the waiting room balcony   
    { 2248.7563, -1165.9019, 1029.7969, 359.1815, 269.1816, 2248.5059, -1166.0874, 1029.8401, 100.8475, 2249.296875, -1165.490600, 1029.788330, 2248.516845, -1166.110229, 1029.875122, 2249.9209, -1161.5800, 1032.4417, 2243.0193, -1166.7590, 1029.7969, 2249.3161, -1167.3656, 1029.5098, 2249.1120, -1166.3887, 1029.5739 }
};

new iBitchModel[BITCHES] = { 214, 75, 131, 152 };

new iBitchCost[BITCHES] = { 2000, 500, 250 };

new iBitchHpArmor[BITCHES][2] = {
    { 100, 100 },
    { 100, 0 },
    { 30, 0 },
    { 100, 50 }
};

new iBitchLabel[BITCHES][128] = {
    "Anna: {FFFFFF}I'm so horny right now.. Come here!\nPress F for Sex\n{00FF00}$2000",
    "Jessica: {FFFFFF}Wanna have some fun, honey?\nPress F for a Blowjob\n{00FF00}$500",
    "Janet: {FFFFFF}I would love to get something tasty in my mouth.. NOW!\nPress F for a Blowjob\n{00FF00}$250",
    "Lena: {FFFFFF}I'm waiting for you, babe...\nPress F for Sex\n{00FF00}$1000"
};

new iBitchAnimLib[BITCHES][14][18] = { //{idlelib,idlename,busystartlib,busystartname,pedstartlib,pedstartname,busylib,busyname,pedbusylib,pedbusyname,busyendlib,busyendname,pedendlib,pedendname
    { "BEACH", "SitnWait_loop_W", "SNM", "SPANKING_IDLE_W", "WUZI", "Wuzi_stand_loop", "SNM", "SPANKINGW", "SNM", "SPANKEDP", "BLOWJOBZ", "BJ_STAND_END_W", "BLOWJOBZ", "BJ_STAND_END_P" },
    { "SMOKING", "M_smk_drag", "BLOWJOBZ", "BJ_COUCH_START_W", "BLOWJOBZ", "BJ_COUCH_START_P", "BLOWJOBZ", "BJ_COUCH_LOOP_W", "BLOWJOBZ", "BJ_COUCH_LOOP_P", "BLOWJOBZ", "BJ_COUCH_END_W", "BLOWJOBZ", "BJ_COUCH_END_P" },
    { "SMOKING", "F_smklean_loop", "BLOWJOBZ", "BJ_STAND_START_W", "BLOWJOBZ", "BJ_STAND_START_P", "BLOWJOBZ", "BJ_STAND_LOOP_W", "BLOWJOBZ", "BJ_STAND_LOOP_P", "BLOWJOBZ", "BJ_STAND_END_W", "BLOWJOBZ", "BJ_STAND_END_P" },
    { "SMOKING", "M_smk_drag", "CRACK", "crckidle1", "SNM", "SPANKEDP", "CRACK", "crckidle1", "SNM", "SPANKEDP", "BLOWJOBZ", "BJ_STAND_END_W", "BLOWJOBZ", "BJ_STAND_END_P" }
};


hook OnGameModeInit() {
    CreateDynamicObject(974, 2200.5, -1187, 1031.6, 0, 0, 272);
    CreateDynamicObject(2987, 2232.2, -1167, 1030, 0, 0, 112.498);
    CreateDynamicObject(323, 2235.1001, -1171.9, 1029.4, 0, 94, 299.75);
    CreateDynamicObject(1828, 2220.3999, -1150.6, 1024.8, 0, 0, 170);
    CreateDynamicObject(2819, 2240.5, -1150.9, 1028.8, 0, 0, 0);
    CreateDynamicObject(2846, 2241.7, -1170.3, 1028.8, 0, 0, 0);
    CreateDynamicObject(2845, 2233.7, -1167.2, 1028.8, 0, 0, 0);
    CreateDynamicObject(2987, 2239.3, -1159.8, 1030, 0, 0, 95.248);
    CreateDynamicObject(2773, 2201.5, -1189.3, 1029.3, 0, 0, 34);
    CreateDynamicObject(2773, 2201.8999, -1188.1, 1029.3, 0, 0, 351.997);
    CreateDynamicObject(971, 2214.8999, -1141.2, 1025, 90, 354.053, 95.947);
    CreateDynamicObject(2079, 2217.3, -1144.5, 1025.8, 0, 0, 90);
    CreateDynamicObject(2079, 2215.3999, -1144.9, 1025.8, 0, 0, 192);
    CreateDynamicObject(985, 2235.8999, -1156.6, 1028.7, 270, 180, 90);
    CreateDynamicObject(976, 2237.5, -1152.2, 1028.7, 270, 180, 180);
    CreateDynamicObject(985, 2253.7, -1160.2, 1028.7, 270, 180, 300.002);
    CreateDynamicObject(985, 2233.5, -1167.9, 1028.6, 270, 359.995, 0);
    CreateDynamicObject(976, 2238, -1192.6, 1032.7, 90, 5.446, 84.554);
    CreateDynamicObject(976, 2240.5, -1193.4004, 1028.7, 90, 6.01, 4.977);
    CreateDynamicObject(976, 2251.7, -1186.2, 1028.7, 90, 5.488, 173.241);
    CreateDynamicObject(976, 2238.3999, -1192.9, 1028.6, 90, 5.274, 40.704);
    CreateDynamicObject(985, 2228.5, -1180.5, 1028.6, 270, 180, 90);
    CreateDynamicObject(985, 2221.7, -1182.8, 1028.6, 270, 359.996, 270.002);
    CreateDynamicObject(985, 2221.8999, -1176.3, 1028.6, 270, 180, 90.005);
    CreateDynamicObject(976, 2209.6001, -1195.4, 1028.6, 90, 5.371, 174.623);
    CreateDynamicObject(985, 2248.3999, -1163, 1028.7, 270, 359.996, 120);

    moviemod[0] = TextDrawCreate(0.000000, 0.000000, "I");
    moviemod[1] = TextDrawCreate(1.000000, 340.000000, "I");
    TextDrawUseBox(moviemod[0], 1);
    TextDrawBoxColor(moviemod[0], 0x000000ff);
    TextDrawTextSize(moviemod[0], 641.000000, 15.000000);
    TextDrawUseBox(moviemod[1], 1);
    TextDrawBoxColor(moviemod[1], 0x000000ff);
    TextDrawTextSize(moviemod[1], 639.000000, 29.000000);
    TextDrawAlignment(moviemod[0], 0);
    TextDrawAlignment(moviemod[1], 0);
    TextDrawBackgroundColor(moviemod[0], 0x000000ff);
    TextDrawBackgroundColor(moviemod[1], 0x000000ff);
    TextDrawFont(moviemod[0], 3);
    TextDrawLetterSize(moviemod[0], 1.000000, 10.600008);
    TextDrawFont(moviemod[1], 3);
    TextDrawLetterSize(moviemod[1], 1.000000, 11.900006);
    TextDrawColor(moviemod[0], 0x000000ff);
    TextDrawColor(moviemod[1], 0x000000ff);
    TextDrawSetOutline(moviemod[0], 1);
    TextDrawSetOutline(moviemod[1], 1);
    TextDrawSetProportional(moviemod[0], 1);
    TextDrawSetProportional(moviemod[1], 1);

    bshadow = TextDrawCreate(541.000000, 109.000000, "_");
    TextDrawUseBox(bshadow, 1);
    TextDrawBoxColor(bshadow, 0x000000ff);
    TextDrawTextSize(bshadow, 625.000000, 0.000000);
    TextDrawAlignment(bshadow, 0);
    TextDrawBackgroundColor(bshadow, 0x00000000);
    TextDrawFont(bshadow, 0);
    TextDrawLetterSize(bshadow, -1.099999, 0.499998);
    TextDrawColor(bshadow, 0xffffffff);
    TextDrawSetOutline(bshadow, 1);
    TextDrawSetProportional(bshadow, 1);
    TextDrawSetShadow(bshadow, 1);

    exctext = TextDrawCreate(397.000000, 104.000000, "EXCITEMENT:");
    TextDrawAlignment(exctext, 0);
    TextDrawBackgroundColor(exctext, 0x000000ff);
    TextDrawFont(exctext, 2);
    TextDrawLetterSize(exctext, 0.499999, 1.500000);
    TextDrawColor(exctext, 0xffffffff);
    TextDrawSetOutline(exctext, 1);
    TextDrawSetProportional(exctext, 1);
    TextDrawSetShadow(exctext, 1);

    gagnfuck = TextDrawCreate(12.000000, 110.000000, "Press LMB and RMB in rhythm to gag her");
    TextDrawUseBox(gagnfuck, 1);
    TextDrawBoxColor(gagnfuck, 0x00000033);
    TextDrawTextSize(gagnfuck, 168.000000, 3.000000);
    TextDrawAlignment(gagnfuck, 0);
    TextDrawBackgroundColor(gagnfuck, 0x00000033);
    TextDrawFont(gagnfuck, 1);
    TextDrawLetterSize(gagnfuck, 0.399999, 1.400000);
    TextDrawColor(gagnfuck, 0xffffffff);
    TextDrawSetOutline(gagnfuck, 1);
    TextDrawSetProportional(gagnfuck, 1);

    for (new i; i < BITCHES; i++) {
        Bitch[i][bID] = -1;
        Bitch[i][bBusy] = -1;
    }

    for (new i; i < AKTORS; i++) {
        if (!iActorPos[i][0]) break;
        ActorID[i] = CreateDynamicActor(iActorModel[i], iActorPos[i][0], iActorPos[i][1], iActorPos[i][2], iActorPos[i][3], .worldid = 0);
        ApplyDynamicActorAnimation(ActorID[i], iActorAnimLib[i][0], iActorAnimLib[i][1], 4, 1, 0, 0, 1, 0);
    }
    for (new i; i < BITCHES; i++) {
        if (!iBitchPos[i][0]) break;
        Bitch[i][bID] = CreateDynamicActor(iBitchModel[i], iBitchPos[i][0], iBitchPos[i][1], iBitchPos[i][2], iBitchPos[i][3], .worldid = 0);
        ApplyDynamicActorAnimation(Bitch[i][bID], iBitchAnimLib[i][0], iBitchAnimLib[i][1], 4, 1, 0, 0, 1, 0);
        new Float:add[3];
        if (i == 0) {
            add[0] += 0.8;
            add[2] -= 0.5;
        } else {
            add[0] = 0;
            add[1] = 0;
            add[2] = 0;
        }
        Bitch[i][bLabel] = CreateDynamic3DTextLabel(iBitchLabel[i], 0xFF0000FF, iBitchPos[i][0] + add[0], iBitchPos[i][1] + add[1], iBitchPos[i][2] + add[2], 5.0);
        Bitch[i][bBusy] = -1;
    }
    SetTimer("isPlayerInArea", 1000, 1);
    return 1;
}

hook OnGameModeExit() {
    for (new i; i < AKTORS; i++) DestroyDynamicActor(ActorID[i]);
    for (new i; i < BITCHES; i++) DestroyDynamicActor(Bitch[i][bID]);
    return 1;
}

static s_animlibz[][] = {
    !"BLOWJOBZ",
    !"MISC",
    !"PED",
    !"GRAVEYARD",
    !"PED",
    !"STRIP",
    !"BEACH",
    !"SNM",
    !"PAULNMAC",
    !"BEACH",
    !"CRACK",
    !"SWEET",
    !"WUZI",
    !"SMOKING"
};

stock static JHPreloadAnimLib(playerid) {
    for (new i; i < sizeof(s_animlibz); i++) {
        ApplyAnimation(playerid, s_animlibz[i], "null", 0.0, 0, 0, 0, 0, 0);
    }
}

hook OnPlayerSpawn(playerid) {
    JMPlayer[playerid][pBitch] = -1;
    JMPlayer[playerid][pInArea] = -1;
    JMPlayer[playerid][pMovieMod] = 0;
    JMPlayer[playerid][pInArea] = -1;
    JMPlayer[playerid][pBitch] = -1;
    JMPlayer[playerid][keyOrder] = 0;
    JMPlayer[playerid][excMod] = -1;
    JMPlayer[playerid][excTimer] = -1;
    JMPlayer[playerid][pExcitement] = 0.0;
    JMPlayer[playerid][pFail] = 0;
    for (new b; b < BITCHES; b++) {
        JMPlayer[playerid][pFuckedBitch][b] = 0;
    }
    JHPreloadAnimLib(playerid);
    return 1;
}

forward Excitement(playerid, bitchid);
public Excitement(playerid, bitchid) {
    new Float:phealth;
    GetPlayerHealth(playerid, phealth);
    if (JMPlayer[playerid][excMod] == 0) {
        JMPlayer[playerid][excMod] = 1;
    } else if (JMPlayer[playerid][excMod] == 1) {
        JMPlayer[playerid][excMod] = 2;
        if (bitchid != 1) {
            JMPlayer[playerid][excMod] = 3;
        }
    } else if (JMPlayer[playerid][excMod] == 2) {
        JMPlayer[playerid][excMod] = 3;
    } else if (JMPlayer[playerid][excMod] == 3) {
        JMPlayer[playerid][pExcitement] = 0.0;
        if ((bitchid == 0) || (bitchid == 3)) TextDrawSetString(gagnfuck, "Press LMB and RMB in rhythm to fuck her.");
        else TextDrawSetString(gagnfuck, "Press LMB and RMB in rhythm to gag her.");
        TextDrawShowForPlayer(playerid, gagnfuck);
        TextDrawShowForPlayer(playerid, exctext);
        TextDrawShowForPlayer(playerid, bshadow);
        if (bitchid == 3) {
            ClearAnimations(playerid);
            ClearDynamicActorAnimations(Bitch[bitchid][bID]);
        }
        ApplyAnimation(playerid, iBitchAnimLib[bitchid][8], iBitchAnimLib[bitchid][9], 4, 1, 0, 0, 1, 0, 1);
        ApplyDynamicActorAnimation(Bitch[bitchid][bID], iBitchAnimLib[bitchid][6], iBitchAnimLib[bitchid][7], 4.3, 1, 0, 0, 0, 0);
        PlayerTextDrawShow(playerid, JMPlayer[playerid][ExcBalken]);
        JMPlayer[playerid][excMod] = 4;
    } else if (JMPlayer[playerid][excMod] == 4) {
        if (JMPlayer[playerid][pExcitement] > 0) {
            JMPlayer[playerid][pExcitement] -= 3.0;
        }
        if (JMPlayer[playerid][pExcitement] < 86.0) //sex/bj NOT complete
        {
            PlayerTextDrawHide(playerid, JMPlayer[playerid][ExcBalken]);
            PlayerTextDrawTextSize(playerid, JMPlayer[playerid][ExcBalken], JMPlayer[playerid][pExcitement] + 538.0, 2.0);
            PlayerTextDrawShow(playerid, JMPlayer[playerid][ExcBalken]);
            if (bitchid == 0) {
                new rand = random(12);
                if (rand == 5) {
                    SetPlayerCameraPos(playerid, 2204.203857, -1192.829101, 1029.686279);
                    SetPlayerCameraLookAt(playerid, 2204.066650, -1194.023681, 1029.513305);
                } else if (rand == 8) {
                    SetPlayerCameraPos(playerid, 2205.703857, -1194.029052, 1029.986328);
                    SetPlayerCameraLookAt(playerid, 2203.466552, -1193.973632, 1029.513305);
                } else if (rand == 9) //kap?d?sar?, oturarak sikerken
                {
                    SetPlayerCameraPos(playerid, 2210.591552, -1189.841796, 1030.527587);
                    SetPlayerCameraLookAt(playerid, 2209.8275, -1190.473, 1030.395);
                } else if (rand == 11) {
                    SetPlayerCameraPos(playerid, 2204.003906, -1193.968994, 1030.786254);
                    SetPlayerCameraLookAt(playerid, 2203.466552, -1193.973632, 1029.513305);
                }
            }
        } else //sex/bj complete
        {
            if (bitchid == 0) {
                DestroyDynamicActor(Bitch[bitchid][bID]);
                Bitch[bitchid][bID] = CreateDynamicActor(iBitchModel[bitchid], iBitchPos[bitchid][0], iBitchPos[bitchid][1], iBitchPos[bitchid][2], iBitchPos[bitchid][3], .worldid = 0); //0.3.7 Rotatebug-fix
                SetPlayerCameraPos(playerid, 2203.701416, -1191.710449, 1029.431396);
                SetPlayerCameraLookAt(playerid, 2204.286865, -1192.479858, 1029.686767, CAMERA_MOVE);
                SetPlayerPosEx(playerid, 2205.2502, -1193.9957, 1030.5249);
                SetPlayerFacingAngle(playerid, 85.7275);
            } else if (bitchid == 3) {
                DestroyDynamicActor(Bitch[bitchid][bID]);
                Bitch[bitchid][bID] = CreateDynamicActor(iBitchModel[bitchid], iBitchPos[bitchid][0], iBitchPos[bitchid][1], iBitchPos[bitchid][2], iBitchPos[bitchid][3], .worldid = 0); //0.3.7 Rotatebug-fix
                SetPlayerCameraPos(playerid, 2245.8842, -1166.4392, 1030.9814);
                SetPlayerCameraLookAt(playerid, 2246.7126, -1166.0609, 1030.5684);
                SetPlayerPosEx(playerid, 2248.7732, -1164.9709, 1029.8754);
                SetPlayerFacingAngle(playerid, 185.7614);
            } else {
                SetPlayerCameraPos(playerid, iBitchPos[bitchid][9], iBitchPos[bitchid][10], iBitchPos[bitchid][11]);
                SetPlayerCameraLookAt(playerid, iBitchPos[bitchid][12], iBitchPos[bitchid][13], iBitchPos[bitchid][14], CAMERA_MOVE);
            }
            PlayerTextDrawHide(playerid, JMPlayer[playerid][ExcBalken]);
            PlayerTextDrawTextSize(playerid, JMPlayer[playerid][ExcBalken], 624.0, 2.0);
            PlayerTextDrawShow(playerid, JMPlayer[playerid][ExcBalken]);
            ApplyAnimation(playerid, iBitchAnimLib[bitchid][12], iBitchAnimLib[bitchid][13], 4, 0, 0, 0, 1, 0, 1);
            ApplyDynamicActorAnimation(Bitch[bitchid][bID], iBitchAnimLib[bitchid][10], iBitchAnimLib[bitchid][11], 4, 0, 0, 0, 1, 0);
            JMPlayer[playerid][excMod] = 5;
        }
    } else if (JMPlayer[playerid][excMod] == 5) {
        JMPlayer[playerid][excMod] = 6;
    } else if (JMPlayer[playerid][excMod] == 6) {
        JMPlayer[playerid][excMod] = 7;
    } else if (JMPlayer[playerid][excMod] == 7) {
        JMPlayer[playerid][excMod] = 8;
    } else if (JMPlayer[playerid][excMod] == 8) {
        JMPlayer[playerid][excMod] = 9;
        if (bitchid != 1) {
            JMPlayer[playerid][excMod] = 11;
        }
    } else if (JMPlayer[playerid][excMod] == 9) {
        JMPlayer[playerid][excMod] = 10;
    } else if (JMPlayer[playerid][excMod] == 10) {
        JMPlayer[playerid][excMod] = 11;
    } else if (JMPlayer[playerid][excMod] == 11) {
        if (!JMPlayer[playerid][pFail]) {
            new Float:addhp;
            if (phealth + iBitchHpArmor[bitchid][0] > 100) {
                addhp = 100;
            } else {
                addhp += iBitchHpArmor[bitchid][0];
            }
            //SetPlayerHealthEx(playerid,addhp);
            GetPlayerArmour(playerid, phealth);
            if (phealth + iBitchHpArmor[bitchid][1] > 100) {
                addhp = 100;
            } else {
                addhp += iBitchHpArmor[bitchid][1];
            }
            //SetPlayerArmourEx(playerid,addhp);
            ClearAnimations(playerid);
            ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4, 0, 1, 1, 0, 0);
            if (bitchid == 0) {
                SetPlayerPosEx(playerid, 2208.2087, -1190.9595, 1029.7969);
                SetPlayerFacingAngle(playerid, 292.6569);
            }
            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
        }
        PlayerTextDrawDestroy(playerid, JMPlayer[playerid][ExcBalken]);
        TogglePlayerMovieMod(playerid, 0);
        Bitch[bitchid][bLabel] = CreateDynamic3DTextLabel(iBitchLabel[bitchid], 0xFF0000FF, iBitchPos[bitchid][0], iBitchPos[bitchid][1], iBitchPos[bitchid][2], 5.0);
        TextDrawHideForPlayer(playerid, gagnfuck);
        TextDrawHideForPlayer(playerid, bshadow);
        TextDrawHideForPlayer(playerid, exctext);
        DestroyDynamicActor(Bitch[bitchid][bID]);
        Bitch[bitchid][bID] = CreateDynamicActor(iBitchModel[bitchid], iBitchPos[bitchid][0], iBitchPos[bitchid][1], iBitchPos[bitchid][2], iBitchPos[bitchid][3], .worldid = 0); //0.3.7 Rotatebug-fix
        ApplyDynamicActorAnimation(Bitch[bitchid][bID], iBitchAnimLib[bitchid][0], iBitchAnimLib[bitchid][1], 4, 1, 0, 0, 1, 0);
        KillTimer(JMPlayer[playerid][excTimer]);
        JMPlayer[playerid][pFuckedBitch][bitchid] = 1;
        Bitch[bitchid][bBusy] = -1;
        JMPlayer[playerid][excMod] = 0;
        JMPlayer[playerid][pFail] = 0;
        JMPlayer[playerid][pBitch] = -1;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (JMPlayer[playerid][pBitch] > -1) {
        JMPlayer[playerid][pFail] = 1;
        JMPlayer[playerid][excMod] = 11;
        KillTimer(JMPlayer[playerid][excTimer]);
        Excitement(playerid, JMPlayer[playerid][pBitch]);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (JMPlayer[playerid][pBitch] > -1) {
        JMPlayer[playerid][pFail] = 1;
        JMPlayer[playerid][excMod] = 11;
        KillTimer(JMPlayer[playerid][excTimer]);
        Excitement(playerid, JMPlayer[playerid][pBitch]);
    }
    JMPlayer[playerid][pMovieMod] = 0;
    TextDrawHideForPlayer(playerid, moviemod[0]);
    TextDrawHideForPlayer(playerid, moviemod[1]);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_SECONDARY_ATTACK) {
        for (new i = 0; i < BITCHES; i++) {
            if (IsPlayerInRangeOfPoint(playerid, 3.0, iBitchPos[i][0], iBitchPos[i][1], iBitchPos[i][2]) && (Bitch[i][bBusy] == -1) && (!JMPlayer[playerid][pFuckedBitch][i])) {
                if (GetPlayerCash(playerid) >= iBitchCost[i]) {
                    JMPlayer[playerid][pBitch] = i;
                    Bitch[i][bBusy] = playerid;
                    PlayerPlaySound(playerid, 1150, 0, 0, 0);
                    vault:PlayerVault(playerid, -iBitchCost[i], "charged for whore", Vault_ID_Government, iBitchCost[i], sprintf("%s charged for whore", GetPlayerNameEx(playerid)));
                    DestroyDynamic3DTextLabel(Bitch[i][bLabel]);
                    TogglePlayerControllable(playerid, 0);
                    DestroyDynamicActor(Bitch[i][bID]);
                    if (i == 3) {
                        Bitch[i][bID] = CreateDynamicActor(iBitchModel[i], 2248.3857, -1166.1635, 1030.6276, 269.1816, .worldid = 0); //0.3.7 Rotatebug-fix
                    } else {
                        Bitch[i][bID] = CreateDynamicActor(iBitchModel[i], iBitchPos[i][0], iBitchPos[i][1], iBitchPos[i][2], iBitchPos[i][4], .worldid = 0); //0.3.7 Rotatebug-fix
                    }
                    SetPlayerPosEx(playerid, iBitchPos[i][5], iBitchPos[i][6], iBitchPos[i][7]);
                    SetPlayerFacingAngle(playerid, iBitchPos[i][8]);
                    TogglePlayerMovieMod(playerid, 1);
                    SetPlayerCameraPos(playerid, iBitchPos[i][9], iBitchPos[i][10], iBitchPos[i][11]);
                    SetPlayerCameraLookAt(playerid, iBitchPos[i][12], iBitchPos[i][13], iBitchPos[i][14], CAMERA_MOVE);
                    ApplyAnimation(playerid, iBitchAnimLib[i][4], iBitchAnimLib[i][5], 4, 0, 0, 0, 1, 0, 1);
                    ApplyDynamicActorAnimation(Bitch[i][bID], iBitchAnimLib[i][2], iBitchAnimLib[i][3], 4, 0, 0, 0, 1, 0);
                    JMPlayer[playerid][ExcBalken] = CreatePlayerTextDraw(playerid, 543.000000, 110.000000, "_");
                    PlayerTextDrawUseBox(playerid, JMPlayer[playerid][ExcBalken], 1);
                    PlayerTextDrawBoxColor(playerid, JMPlayer[playerid][ExcBalken], 0xffffff99);
                    PlayerTextDrawTextSize(playerid, JMPlayer[playerid][ExcBalken], 624.000000, 2.000000);
                    PlayerTextDrawAlignment(playerid, JMPlayer[playerid][ExcBalken], 0);
                    PlayerTextDrawBackgroundColor(playerid, JMPlayer[playerid][ExcBalken], 0x000000ff);
                    PlayerTextDrawFont(playerid, JMPlayer[playerid][ExcBalken], 3);
                    PlayerTextDrawLetterSize(playerid, JMPlayer[playerid][ExcBalken], 1.000000, 0.299999);
                    PlayerTextDrawColor(playerid, JMPlayer[playerid][ExcBalken], 0xffffffff);
                    PlayerTextDrawSetOutline(playerid, JMPlayer[playerid][ExcBalken], 1);
                    PlayerTextDrawSetProportional(playerid, JMPlayer[playerid][ExcBalken], 1);
                    PlayerTextDrawSetShadow(playerid, JMPlayer[playerid][ExcBalken], 1);
                    JMPlayer[playerid][excMod] = 0;
                    JMPlayer[playerid][excTimer] = SetTimerEx("Excitement", 1000, 1, "dd", playerid, i);
                    return ~1;
                }
            }
        }
    }
    if ((JMPlayer[playerid][pBitch] > -1) && (JMPlayer[playerid][excMod] >= 3)) {
        if ((newkeys & KEY_FIRE) && (JMPlayer[playerid][keyOrder] == LMB)) {
            JMPlayer[playerid][pExcitement] += 1.0;
            JMPlayer[playerid][keyOrder] = RMB;
        }
        if ((newkeys & KEY_HANDBRAKE) && (JMPlayer[playerid][keyOrder] == RMB)) {
            JMPlayer[playerid][pExcitement] += 1.0;
            JMPlayer[playerid][keyOrder] = LMB;
        }
    }
    return 1;
}

forward isPlayerInArea();
public isPlayerInArea() {
    foreach(new i:Player) {
        if (GetPlayerInterior(i) != 15) continue;
        for (new b; b < BITCHES; b++) {
            if (!IsDynamicActorStreamedIn(Bitch[b][bID], i)) continue;
            new Float:ppos[3];
            GetPlayerPos(i, ppos[0], ppos[1], ppos[2]);
            if ((ppos[0] <= iBitchPos[b][15]) && (ppos[0] >= iBitchPos[b][18]) && (ppos[1] <= iBitchPos[b][16]) && (ppos[1] >= iBitchPos[b][19]) && (ppos[2] <= iBitchPos[b][17]) && (ppos[2] >= iBitchPos[b][20]) && (!JMPlayer[i][pFuckedBitch][b])) {
                if (Bitch[b][bBusy] == -1) {
                    //bX,bY,bZ,bAngle,bBusyAngle,pedX,pedY,pedZ,pedBusyAngle,camX,camY,camZ,camlookx,camlooky,camlookz,moviemaxX,moviemaxY,moviemaxZ,movieminX,movieminY,movieminZ,moviecamX,moviecamY,moviecamZ,movielookX,movielookY,movielookZ
                    if (!JMPlayer[i][pMovieMod] && (JMPlayer[i][pInArea] != b)) {
                        JMPlayer[i][pInArea] = b;
                        SetPlayerCameraPos(i, iBitchPos[b][21], iBitchPos[b][22], iBitchPos[b][23]);
                        SetPlayerCameraLookAt(i, iBitchPos[b][24], iBitchPos[b][25], iBitchPos[b][26], CAMERA_MOVE);
                        TogglePlayerMovieMod(i, 1);
                        return 1;
                    }
                }
            } else {
                if (JMPlayer[i][pMovieMod] && (JMPlayer[i][pInArea] == b)) {
                    JMPlayer[i][pInArea] = -1;
                    TogglePlayerMovieMod(i, 0);
                    SetCameraBehindPlayer(i);
                    return 1;
                }
            }
        }
    }
    return 1;
}

stock TogglePlayerMovieMod(playerid, mod) {
    if (!mod) {
        JMPlayer[playerid][pMovieMod] = 0;
        TextDrawHideForPlayer(playerid, moviemod[0]);
        TextDrawHideForPlayer(playerid, moviemod[1]);
    } else {
        JMPlayer[playerid][pMovieMod] = 1;
        TextDrawShowForPlayer(playerid, moviemod[0]);
        TextDrawShowForPlayer(playerid, moviemod[1]);
    }
    return 1;
}

hook Global15SecondInterval() {
    syncActors();
    return 1;
}

// synch bug fix
forward syncActors();
public syncActors() {
    for (new i; i < AKTORS; i++) {
        if (!IsValidDynamicActor(ActorID[i])) continue;
        SetDynamicActorPos(ActorID[i], iActorPos[i][0], iActorPos[i][1], iActorPos[i][2]);
    }
    for (new i; i < BITCHES; i++) {
        if (!IsValidDynamicActor(Bitch[i][bID]) || (Bitch[i][bBusy] > -1)) continue;
        SetDynamicActorPos(Bitch[i][bID], iBitchPos[i][0], iBitchPos[i][1], iBitchPos[i][2]);
    }
    return 1;
}