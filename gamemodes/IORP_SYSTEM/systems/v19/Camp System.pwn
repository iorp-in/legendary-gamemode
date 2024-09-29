#define MAX_CAMP_DynamicObject (80)

enum Camp:DataEnum {
    bool:Camp:dStatus,
    Text3D:Camp:dLabel,
    Camp:dComponents[MAX_CAMP_DynamicObject]
};
new Camp:PlayerData[MAX_PLAYERS][Camp:DataEnum];

stock Camp:GetCampStatus(playerid) {
    return Camp:PlayerData[playerid][Camp:dStatus];
}

hook OnPlayerConnect(playerid) {
    if (Camp:GetCampStatus(playerid)) Camp:Remove(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (Camp:GetCampStatus(playerid)) Camp:Remove(playerid);
    return 1;
}

stock Camp:Create(playerid) {
    if (Camp:GetCampStatus(playerid)) return 1;
    Camp:PlayerData[playerid][Camp:dStatus] = true;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    GetPlayerFacingAngle(playerid, Float:a);
    x = x + (2.0 * floatsin(-a, degrees));
    y = y + (2.0 * floatcos(-a, degrees));
    Camp:PlayerData[playerid][Camp:dLabel] = CreateDynamic3DTextLabel(
        FormatColors(sprintf("~r~Camp\n~y~By: ~w~%s", GetPlayerNameEx(playerid))), -1, Float:x, Float:y, Float:z, 10.0
    );
    Camp:PlayerData[playerid][Camp:dComponents][0] = CreateDynamicObject(19300, 309.64999, 1827.71790, 16.63540, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][1] = CreateDynamicObject(841, 309.22369, 1831.88953, 16.69970, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][2] = CreateDynamicObject(841, 309.22369, 1831.88953, 16.69970, 0.00000, 0.00000, 76.00000);
    Camp:PlayerData[playerid][Camp:dComponents][3] = CreateDynamicObject(841, 309.22369, 1831.88953, 16.69970, 0.00000, 0.00000, 149.00000);
    Camp:PlayerData[playerid][Camp:dComponents][5] = CreateDynamicObject(18688, 309.12091, 1831.89697, 15.53580, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][6] = CreateDynamicObject(1281, 307.06400, 1825.51147, 17.43860, 0.00000, 0.00000, 90.00000);
    Camp:PlayerData[playerid][Camp:dComponents][7] = CreateDynamicObject(3119, 306.98322, 1825.67725, 17.72950, 0.00000, 0.00000, -55.00000);
    Camp:PlayerData[playerid][Camp:dComponents][8] = CreateDynamicObject(1370, 314.04535, 1824.03284, 17.20480, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][9] = CreateDynamicObject(1220, 313.99738, 1822.29041, 17.00860, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][10] = CreateDynamicObject(1220, 314.13629, 1823.18933, 17.00860, 0.00000, 0.00000, -11.00000);
    Camp:PlayerData[playerid][Camp:dComponents][11] = CreateDynamicObject(1220, 314.00919, 1827.55420, 17.00860, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][12] = CreateDynamicObject(1220, 310.41464, 1827.40930, 17.00860, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][13] = CreateDynamicObject(3119, 314.37982, 1830.49329, 16.94750, 0.00000, 0.00000, -156.00000);
    Camp:PlayerData[playerid][Camp:dComponents][14] = CreateDynamicObject(1220, 314.07486, 1828.73547, 17.00860, 0.00000, 0.00000, 40.00000);
    Camp:PlayerData[playerid][Camp:dComponents][15] = CreateDynamicObject(349, 312.55099, 1826.56604, 17.19990, 69.00000, -4.00000, 86.00000);
    Camp:PlayerData[playerid][Camp:dComponents][16] = CreateDynamicObject(347, 313.96811, 1827.36511, 17.34890, 69.00000, 33.00000, 86.00000);
    Camp:PlayerData[playerid][Camp:dComponents][17] = CreateDynamicObject(347, 314.11807, 1827.25049, 17.34890, 69.00000, 33.00000, 86.00000);
    Camp:PlayerData[playerid][Camp:dComponents][18] = CreateDynamicObject(1220, 309.07526, 1822.31531, 17.00860, 0.00000, 0.00000, 11.00000);
    Camp:PlayerData[playerid][Camp:dComponents][19] = CreateDynamicObject(1220, 309.11325, 1823.18738, 17.00860, 0.00000, 0.00000, -2.00000);
    Camp:PlayerData[playerid][Camp:dComponents][20] = CreateDynamicObject(2226, 307.81601, 1826.09961, 17.11780, 0.00000, 0.00000, 99.00000);
    Camp:PlayerData[playerid][Camp:dComponents][21] = CreateDynamicObject(1265, 309.27954, 1828.07727, 17.07260, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][22] = CreateDynamicObject(2674, 308.82733, 1828.01672, 16.67070, 0.00000, 0.00000, 280.00000);
    Camp:PlayerData[playerid][Camp:dComponents][23] = CreateDynamicObject(2674, 308.59909, 1822.75769, 16.67070, 0.00000, 0.00000, 280.00000);
    Camp:PlayerData[playerid][Camp:dComponents][24] = CreateDynamicObject(2675, 314.76166, 1826.96948, 16.71070, 0.00000, 0.00000, 215.00000);
    Camp:PlayerData[playerid][Camp:dComponents][25] = CreateDynamicObject(2674, 306.85934, 1831.50134, 16.67070, 0.00000, 0.00000, 280.00000);
    Camp:PlayerData[playerid][Camp:dComponents][26] = CreateDynamicObject(2674, 311.39514, 1832.03796, 16.67070, 0.00000, 0.00000, 280.00000);
    Camp:PlayerData[playerid][Camp:dComponents][27] = CreateDynamicObject(1544, 307.23172, 1830.62488, 17.20720, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][28] = CreateDynamicObject(1544, 311.27390, 1831.59717, 17.20720, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][29] = CreateDynamicObject(1544, 311.04810, 1832.66846, 16.64720, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][30] = CreateDynamicObject(1544, 311.44269, 1832.80554, 16.64720, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][31] = CreateDynamicObject(2114, 307.06149, 1826.76563, 16.75140, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][32] = CreateDynamicObject(2114, 306.64496, 1826.91589, 16.75140, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][33] = CreateDynamicObject(2805, 307.63596, 1833.62769, 17.18640, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][34] = CreateDynamicObject(2804, 309.65308, 1831.65540, 18.46040, -90.00000, 0.00000, -32.00000);
    Camp:PlayerData[playerid][Camp:dComponents][35] = CreateDynamicObject(2804, 309.31732, 1831.97778, 18.46040, -90.00000, 0.00000, -32.00000);
    Camp:PlayerData[playerid][Camp:dComponents][36] = CreateDynamicObject(2804, 308.98053, 1832.27246, 18.46040, -90.00000, 0.00000, -32.00000);
    Camp:PlayerData[playerid][Camp:dComponents][37] = CreateDynamicObject(18632, 306.55414, 1830.47681, 16.74740, 180.00000, 26.00000, 207.00000);
    Camp:PlayerData[playerid][Camp:dComponents][38] = CreateDynamicObject(18632, 306.60620, 1830.36890, 16.74740, 180.00000, 26.00000, 207.00000);
    Camp:PlayerData[playerid][Camp:dComponents][39] = CreateDynamicObject(18632, 306.64035, 1830.25195, 16.74740, 180.00000, 26.00000, 207.00000);
    Camp:PlayerData[playerid][Camp:dComponents][40] = CreateDynamicObject(2864, 306.93115, 1825.70532, 17.45210, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][41] = CreateDynamicObject(2863, 306.76468, 1825.27625, 17.45210, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][42] = CreateDynamicObject(2852, 310.45197, 1827.41333, 17.35810, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][43] = CreateDynamicObject(2844, 312.00867, 1826.49011, 16.65310, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][44] = CreateDynamicObject(2843, 310.91702, 1826.76746, 16.65310, 0.00000, 0.00000, -178.00000);
    Camp:PlayerData[playerid][Camp:dComponents][45] = CreateDynamicObject(323, 310.27969, 1823.99805, 16.94830, 0.00000, 90.00000, 76.00000);
    Camp:PlayerData[playerid][Camp:dComponents][46] = CreateDynamicObject(321, 310.41483, 1824.22131, 16.94830, 0.00000, 90.00000, 76.00000);
    //bolsos carpa
    Camp:PlayerData[playerid][Camp:dComponents][47] = CreateDynamicObject(1550, 310.25449, 1826.72754, 17.03370, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][48] = CreateDynamicObject(1550, 310.16809, 1826.17139, 16.82970, 0.00000, 90.00000, 265.00000);
    //sillas
    Camp:PlayerData[playerid][Camp:dComponents][49] = CreateDynamicObject(2121, 310.02151, 1829.67651, 17.15670, 0.00000, 0.00000, 179.00000);
    Camp:PlayerData[playerid][Camp:dComponents][50] = CreateDynamicObject(2121, 309.18134, 1829.70996, 17.15670, 0.00000, 0.00000, 200.00000);
    Camp:PlayerData[playerid][Camp:dComponents][51] = CreateDynamicObject(2121, 311.36627, 1831.60779, 17.15670, 0.00000, 0.00000, -112.00000);
    Camp:PlayerData[playerid][Camp:dComponents][52] = CreateDynamicObject(2121, 311.33826, 1832.58765, 17.15670, 0.00000, 0.00000, -91.00000);
    Camp:PlayerData[playerid][Camp:dComponents][53] = CreateDynamicObject(2121, 307.19360, 1830.67285, 17.15670, 0.00000, 0.00000, 113.00000);
    Camp:PlayerData[playerid][Camp:dComponents][54] = CreateDynamicObject(2121, 307.08627, 1831.59216, 17.15670, 0.00000, 0.00000, 76.00000);
    Camp:PlayerData[playerid][Camp:dComponents][55] = CreateDynamicObject(2121, 312.73245, 1826.76624, 17.15670, 0.00000, 0.00000, -90.00000);
    for (new index = 49; index < 56; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 0, 1281, "benches", "pierdoor02_law", -1);
    //cuerdas
    Camp:PlayerData[playerid][Camp:dComponents][56] = CreateDynamicObject(19087, 307.79419, 1833.44189, 18.78920, 0.00000, 90.00000, 135.00000);
    Camp:PlayerData[playerid][Camp:dComponents][57] = CreateDynamicObject(19087, 308.87219, 1832.36987, 18.78920, 0.00000, 90.00000, 135.00000);
    Camp:PlayerData[playerid][Camp:dComponents][58] = CreateDynamicObject(19089, 311.72137, 1828.64319, 19.62920, 0.00000, -42.00000, 90.00000);
    Camp:PlayerData[playerid][Camp:dComponents][59] = CreateDynamicObject(19089, 311.72141, 1822.50464, 19.62920, 0.00000, 42.00000, 90.00000);
    Camp:PlayerData[playerid][Camp:dComponents][60] = CreateDynamicObject(19089, 311.67493, 1823.13049, 19.86420, 0.00000, -53.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][61] = CreateDynamicObject(19089, 311.67303, 1827.79321, 19.86420, 0.00000, -53.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][62] = CreateDynamicObject(19089, 311.65009, 1827.76843, 19.86420, 0.00000, -53.00000, 180.00000);
    Camp:PlayerData[playerid][Camp:dComponents][63] = CreateDynamicObject(19089, 311.63867, 1823.11316, 19.86420, 0.00000, -53.00000, 180.00000);
    for (new index = 56; index < 64; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 0, -1, "none", "none", 0xFF808484);
    //palos fogata
    Camp:PlayerData[playerid][Camp:dComponents][64] = CreateDynamicObject(1251, 310.61270, 1830.58606, 15.53550, 90.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][65] = CreateDynamicObject(1251, 307.87411, 1833.35156, 15.53550, 90.00000, 0.00000, 0.00000);
    for (new index = 64; index < 67; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 0, 841, "gta_brokentrees", "CJ_bark", -1);
    //camas carpa
    Camp:PlayerData[playerid][Camp:dComponents][67] = CreateDynamicObject(1646, 310.20544, 1823.86487, 16.78320, 0.00000, 0.00000, 180.00000);
    Camp:PlayerData[playerid][Camp:dComponents][68] = CreateDynamicObject(1646, 312.31110, 1824.50134, 16.78320, 0.00000, 0.00000, -90.00000);
    Camp:PlayerData[playerid][Camp:dComponents][69] = CreateDynamicObject(1646, 312.31107, 1825.72351, 16.78320, 0.00000, 0.00000, -90.00000);
    Camp:PlayerData[playerid][Camp:dComponents][70] = CreateDynamicObject(1646, 314.25800, 1830.57471, 16.78320, 0.00000, 0.00000, -154.00000);
    for (new index = 67; index < 71; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 25, -1, "none", "none", -1);
    for (new index = 67; index < 71; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 26, -1, "none", "none", -1);
    //carpa
    Camp:PlayerData[playerid][Camp:dComponents][71] = CreateDynamicObject(19325, 312.76309, 1825.48145, 18.11690, 0.00000, -32.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][72] = CreateDynamicObject(19325, 310.53009, 1825.48145, 18.11690, 0.00000, 34.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][73] = CreateDynamicObject(19325, 311.59631, 1825.51514, 16.65890, 0.00000, 90.00000, 0.00000);
    for (new index = 71; index < 74; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 0, 3066, "ammotrx", "ammotrn92tarp128", -1);
    //entrada carpa
    Camp:PlayerData[playerid][Camp:dComponents][74] = CreateDynamicObject(2068, 310.92621, 1829.37927, 14.26150, 138.00000, 105.00000, 78.00000);
    Camp:PlayerData[playerid][Camp:dComponents][75] = CreateDynamicObject(2068, 312.47238, 1821.60352, 14.26150, 138.00000, 105.00000, 260.00000);
    Camp:PlayerData[playerid][Camp:dComponents][76] = CreateDynamicObject(2068, 312.40381, 1828.17834, 14.26150, 138.00000, 105.00000, -99.00000);
    Camp:PlayerData[playerid][Camp:dComponents][77] = CreateDynamicObject(2068, 311.01590, 1822.85583, 14.26150, 138.00000, 105.00000, 79.00000);
    for (new index = 74; index < 78; index++) SetDynamicObjectMaterial(Camp:PlayerData[playerid][Camp:dComponents][index], 0, -1, "none", "none", 0xFF808484);
    //luces carpa
    Camp:PlayerData[playerid][Camp:dComponents][78] = CreateDynamicObject(2074, 311.69241, 1824.52930, 19.50400, 0.00000, 0.00000, 0.00000);
    Camp:PlayerData[playerid][Camp:dComponents][79] = CreateDynamicObject(2074, 311.71283, 1826.09229, 19.50400, 0.00000, 0.00000, 0.00000);

    for (new index = 1; index < MAX_CAMP_DynamicObject; index++) {
        new Float:pos[2][6];
        GetDynamicObjectPos(Camp:PlayerData[playerid][Camp:dComponents][0], pos[0][0], pos[0][1], pos[0][2]);
        GetDynamicObjectPos(Camp:PlayerData[playerid][Camp:dComponents][index], pos[1][0], pos[1][1], pos[1][2]);
        GetDynamicObjectRot(Camp:PlayerData[playerid][Camp:dComponents][index], pos[1][3], pos[1][4], pos[1][5]);
        AttachDynamicObjectToObject(Camp:PlayerData[playerid][Camp:dComponents][index], Camp:PlayerData[playerid][Camp:dComponents][0], floatsub(pos[1][0], pos[0][0]), floatsub(pos[1][1], pos[0][1]), floatsub(pos[1][2], pos[0][2]), pos[1][3], pos[1][4], pos[1][5], 1);
    }
    SetDynamicObjectPos(Camp:PlayerData[playerid][Camp:dComponents][0], x, y, z - 0.9);
    SetDynamicObjectRot(Camp:PlayerData[playerid][Camp:dComponents][0], 0.00000, 0.00000, a - 180);
    return 1;
}

stock Camp:Remove(playerid) {
    Camp:PlayerData[playerid][Camp:dStatus] = false;
    DestroyDynamic3DTextLabel(Camp:PlayerData[playerid][Camp:dLabel]);
    for (new index = 0; index < MAX_CAMP_DynamicObject; index++) {
        DestroyDynamicObjectEx(Camp:PlayerData[playerid][Camp:dComponents][index]);
        Camp:PlayerData[playerid][Camp:dComponents][index] = -1;
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Camp:GetCampStatus(playerid)) UCP:AddCommand(playerid, "Remove Camp");
    new vehicleid = GetPlayerNearestVehicle(playerid, 10.0);
    if (!IsValidVehicle(vehicleid)) return 1;
    new modelid = GetVehicleModel(vehicleid);
    if (modelid != 508) return 1;
    if (!Camp:GetCampStatus(playerid)) UCP:AddCommand(playerid, "Put Camp");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Put Camp")) {
        AlexaMsg(playerid, "you have put your camp at this location, don't forget to remove it, enjoy camping :)");
        Camp:Create(playerid);
        return ~1;
    }
    if (IsStringSame(inputtext, "Remove Camp")) {
        AlexaMsg(playerid, "your camp has been taken away");
        Camp:Remove(playerid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "removecamp") || GetPlayerAdminLevel(playerid) < 1) return 1;
    new targetid;
    if (sscanf(GetNextWordFromString(text, "removecamp"), "u", targetid)) {
        AlexaMsg(playerid, "/alexa removecamp playerid", "Usage");
        return ~1;
    }
    if (!Camp:GetCampStatus(targetid)) {
        AlexaMsg(playerid, sprintf("%s does not have camp anywhere", GetPlayerNameEx(targetid)));
        return ~1;
    }
    AlexaMsg(playerid, sprintf("%s camp removed", GetPlayerNameEx(targetid)));
    AlexaMsg(targetid, sprintf("%s removed your camp", GetPlayerNameEx(playerid)));
    Camp:Remove(targetid);
    return ~1;
}