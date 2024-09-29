hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 4828, 1474.4141, -2286.7969, 26.3594, 0.25);
    RemoveBuildingForPlayer(playerid, 4832, 1610.7969, -2285.8359, 52.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 4942, 1474.4141, -2286.7969, 26.3594, 0.25);
    RemoveBuildingForPlayer(playerid, 4948, 1610.7969, -2285.8359, 52.7500, 0.25);
    RemoveBuildingForPlayer(playerid, 4985, 1394.9453, -2286.1563, 17.5391, 0.25);
    return 1;
}

hook OnGameModeInit() {
    new idealhotel_texture[75];
    idealhotel_texture[0] = CreateDynamicObjectEx(6099, 1476.18896, -2286.74756, 29.25520, 0.00000, 0.00000, 1.04620, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[0], 0, 10871, "blacksky_sfse", "ws_skywinsgreen", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 1, 17588, "lae2coast_alpha", "plainglass", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 2, 17588, "lae2coast_alpha", "plainglass", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 4, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 6, 9906, "sfe_builda", "ws_carpark2", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 3, 3895, "inditaly", "mottled_grey_64HV", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 5, 3895, "inditaly", "mottled_grey_64HV", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[0], 7, 3895, "inditaly", "mottled_grey_64HV", 0xFFFFFFFF);
    idealhotel_texture[1] = CreateDynamicObjectEx(18765, 1483.48523, -2301.30005, 10.12210, 0.06000, 0.00000, 1.16420, 300.0, 300.0);
    idealhotel_texture[2] = CreateDynamicObjectEx(18765, 1483.29065, -2291.62842, 10.12210, 0.06000, 0.00000, 1.16420, 300.0, 300.0);
    idealhotel_texture[3] = CreateDynamicObjectEx(18765, 1483.09241, -2281.67847, 10.12210, 0.06000, 0.00000, 1.16420, 300.0, 300.0);
    idealhotel_texture[4] = CreateDynamicObjectEx(18765, 1482.89392, -2271.70972, 10.12210, 0.06000, 0.00000, 1.16420, 300.0, 300.0);
    idealhotel_texture[5] = CreateDynamicObjectEx(18765, 1468.90625, -2272.03369, 10.12210, 0.06000, 0.00000, 1.26621, 300.0, 300.0);
    idealhotel_texture[6] = CreateDynamicObjectEx(18765, 1469.12708, -2282.00366, 10.12210, 0.06000, 0.00000, 1.26620, 300.0, 300.0);
    idealhotel_texture[7] = CreateDynamicObjectEx(18765, 1469.34961, -2291.98926, 10.12210, 0.06000, 0.00000, 1.26620, 300.0, 300.0);
    idealhotel_texture[8] = CreateDynamicObjectEx(18765, 1469.56848, -2301.96606, 10.12210, 0.06000, 0.00000, 1.26620, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[1], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[2], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[3], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[4], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[5], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[6], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[7], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[8], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    idealhotel_texture[9] = CreateDynamicObjectEx(8661, 1476.25293, -2286.54517, 12.57190, 0.00000, 0.00000, 90.98930, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[9], 0, 10412, "hotel1", "carpet_red_256", 0xFFFFFFFF);
    idealhotel_texture[10] = CreateDynamicObjectEx(19377, 1476.32764, -2286.83105, 12.56900, 0.00000, 90.00000, 1.32741, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[10], 0, 9169, "vgslowbuild", "concpanel_la", 0xFFFFFFFF);
    idealhotel_texture[11] = CreateDynamicObjectEx(19373, 1476.27673, -2286.81665, 12.58140, 0.00000, 90.00000, 1.04620, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[11], 0, 6487, "councl_law2", "grassdeep256", 0xFFFFFFFF);
    idealhotel_texture[12] = CreateDynamicObjectEx(19372, 1474.55774, -2286.81274, 10.93950, 0.00000, 0.00000, 1.02960, 300.0, 300.0);
    idealhotel_texture[13] = CreateDynamicObjectEx(19372, 1476.24280, -2288.33789, 11.07050, 90.00000, 0.00000, 91.00000, 300.0, 300.0);
    idealhotel_texture[14] = CreateDynamicObjectEx(19372, 1477.99829, -2286.79492, 10.93950, 0.00000, 0.00000, 1.02960, 300.0, 300.0);
    idealhotel_texture[15] = CreateDynamicObjectEx(19372, 1476.30298, -2285.27026, 11.07050, 90.00000, 0.00000, 91.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[12], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[13], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[14], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[15], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[16] = CreateDynamicObjectEx(19453, 1465.74512, -2285.23462, 13.65690, 90.00000, 0.00000, 1.21310, 300.0, 300.0);
    idealhotel_texture[17] = CreateDynamicObjectEx(19453, 1465.82336, -2288.73022, 13.65690, 90.00000, 0.00000, 1.21310, 300.0, 300.0);
    idealhotel_texture[18] = CreateDynamicObjectEx(19453, 1462.35852, -2285.25342, 13.65690, 90.00000, 0.00000, 0.91210, 300.0, 300.0);
    idealhotel_texture[19] = CreateDynamicObjectEx(19453, 1462.41541, -2288.73730, 13.65690, 90.00000, 0.00000, 0.91210, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[16], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[17], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[18], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[19], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    idealhotel_texture[20] = CreateDynamicObjectEx(19454, 1464.14343, -2290.40967, 13.67170, 90.00000, 0.00000, 90.16112, 300.0, 300.0);
    idealhotel_texture[21] = CreateDynamicObjectEx(19454, 1464.01135, -2283.56885, 13.67170, 90.00000, 0.00000, 90.16112, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[20], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    SetDynamicObjectMaterial(idealhotel_texture[21], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    idealhotel_texture[23] = CreateDynamicObjectEx(19325, 1464.51746, -2297.47632, 15.50100, 90.00000, 0.00000, 1.00000, 300.0, 300.0);
    idealhotel_texture[24] = CreateDynamicObjectEx(19325, 1463.94861, -2272.41553, 15.50100, 90.08000, -0.18000, 1.16300, 300.0, 300.0);
    idealhotel_texture[25] = CreateDynamicObjectEx(19325, 1464.37939, -2289.24243, 15.50100, 90.12000, -0.18000, 1.16301, 300.0, 300.0);
    idealhotel_texture[26] = CreateDynamicObjectEx(19325, 1464.44995, -2293.36426, 15.50100, 90.12000, -0.18000, 1.16301, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[23], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[24], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[25], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[26], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    idealhotel_texture[27] = CreateDynamicObjectEx(19543, 1481.36401, -2284.37402, 18.45340, -0.02000, -0.02000, 0.99480, 300.0, 300.0);
    idealhotel_texture[28] = CreateDynamicObjectEx(19543, 1471.62585, -2284.55005, 18.45340, -0.02000, 0.00000, 0.99480, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[27], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[28], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    idealhotel_texture[29] = CreateDynamicObjectEx(8661, 1473.47302, -2269.68872, -0.40377, 0.00000, 90.00000, 270.85675, 300.0, 300.0);
    idealhotel_texture[30] = CreateDynamicObjectEx(8661, 1478.53430, -2303.78540, -0.40380, 0.00000, 90.00000, 91.24635, 300.0, 300.0);
    idealhotel_texture[31] = CreateDynamicObjectEx(8661, 1477.81604, -2269.62646, -0.40380, 0.00000, 90.00000, 270.85681, 300.0, 300.0);
    idealhotel_texture[32] = CreateDynamicObjectEx(8661, 1474.43665, -2303.87891, -0.40380, 0.00000, 90.00000, 91.24640, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[29], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[30], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[31], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[32], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    idealhotel_texture[33] = CreateDynamicObjectEx(8661, 1488.19495, -2296.77124, -0.40380, 0.00000, 90.00000, 181.13539, 300.0, 300.0);
    idealhotel_texture[34] = CreateDynamicObjectEx(8661, 1488.69629, -2286.95068, 12.64706, 90.00000, 0.00000, 91.00000, 300.0, 300.0);
    idealhotel_texture[35] = CreateDynamicObjectEx(8661, 1487.84949, -2279.42847, -0.40380, 0.00000, 90.00000, 181.13539, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[33], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[34], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[35], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    idealhotel_texture[36] = CreateDynamicObjectEx(19377, 1443.80774, -2287.03198, 12.47100, 0.00000, 90.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[37] = CreateDynamicObjectEx(19377, 1454.29822, -2287.04028, 12.47100, 0.00000, 90.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[38] = CreateDynamicObjectEx(19377, 1464.79944, -2287.03857, 12.47100, 0.00000, 90.00000, 0.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[36], 0, 8671, "vegassland62", "ws_stonewall", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[37], 0, 8671, "vegassland62", "ws_stonewall", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[38], 0, 8671, "vegassland62", "ws_stonewall", 0xFFFFFFFF);
    idealhotel_texture[39] = CreateDynamicObjectEx(19454, 1463.80566, -2268.57568, 17.01435, 90.00000, 0.00000, 1.15668, 300.0, 300.0);
    idealhotel_texture[40] = CreateDynamicObjectEx(19454, 1464.59753, -2305.33545, 17.01435, 90.00000, 0.00000, 1.15668, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[39], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[40], 0, 18233, "cuntwshopscs_t", "orange1", 0xFFFFFFFF);
    idealhotel_texture[41] = CreateDynamicObjectEx(19373, 1464.16150, -2285.70215, 18.49421, 0.00000, 90.00000, 0.54219, 300.0, 300.0);
    idealhotel_texture[42] = CreateDynamicObjectEx(19373, 1464.12097, -2285.14282, 18.49421, 0.00000, 90.00000, 0.54219, 300.0, 300.0);
    idealhotel_texture[43] = CreateDynamicObjectEx(19373, 1464.19263, -2288.88062, 18.49421, 0.00000, 90.00000, 0.54219, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[41], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    SetDynamicObjectMaterial(idealhotel_texture[42], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    SetDynamicObjectMaterial(idealhotel_texture[43], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    idealhotel_texture[44] = CreateDynamicObjectEx(19373, 1475.84521, -2269.58350, 15.75462, 0.00000, 0.00000, 270.95569, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[44], 0, 11631, "mp_ranchcut", "CJ_PAINTING20", 0xFFFFFFFF);
    idealhotel_texture[45] = CreateDynamicObjectEx(19353, 1477.54053, -2303.84229, 16.35840, 0.00000, 0.00000, 271.22131, 300.0, 300.0);
    idealhotel_texture[46] = CreateDynamicObjectEx(19353, 1475.10938, -2303.89331, 16.35840, 0.00000, 0.00000, 271.22131, 300.0, 300.0);
    SetDynamicObjectMaterialText(idealhotel_texture[45], 0, "{FFFFFF} IORP", 130, "Arial Black", 110, 1, -1, 0, 1);
    SetDynamicObjectMaterialText(idealhotel_texture[46], 0, "{FFFFFF} HOTEL", 130, "Arial Black", 110, 1, -1, 0, 1);
    idealhotel_texture[47] = CreateDynamicObjectEx(14855, 1486.26697, -2275.77563, 16.92431, 0.00000, 0.00000, 220.15617, 300.0, 300.0);
    SetDynamicObjectMaterialText(idealhotel_texture[47], 1, "{FF0000} IORP HOTEL", 130, "Arial", 75, 1, -1, 0xFFFFFF, 1);
    idealhotel_texture[48] = CreateDynamicObjectEx(19325, 1464.01807, -2276.51611, 15.50100, 90.12000, -0.18000, 1.16301, 300.0, 300.0);
    idealhotel_texture[49] = CreateDynamicObjectEx(19325, 1464.08728, -2280.61792, 15.50100, 90.12000, -0.18000, 1.16300, 300.0, 300.0);
    idealhotel_texture[50] = CreateDynamicObjectEx(19325, 1464.15723, -2284.73730, 15.50100, 90.12000, -0.18000, 1.16300, 300.0, 300.0);
    idealhotel_texture[51] = CreateDynamicObjectEx(19325, 1464.58972, -2301.57568, 15.50101, 90.00000, 0.00000, 1.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[48], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[49], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[50], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    SetDynamicObjectMaterial(idealhotel_texture[51], 0, 2361, "lsmall_shops", "lsmall_window01", 0xFF353534);
    idealhotel_texture[52] = CreateDynamicObjectEx(1251, 1464.04871, -2278.98462, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[53] = CreateDynamicObjectEx(1251, 1463.94458, -2274.46265, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[52], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[53], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[54] = CreateDynamicObjectEx(1251, 1464.32117, -2294.96680, 15.19600, 89.98000, -0.12000, 1.49630, 300.0, 300.0);
    idealhotel_texture[55] = CreateDynamicObjectEx(1251, 1464.40063, -2299.52979, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[54], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[55], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[56] = CreateDynamicObjectEx(1251, 1463.94092, -2274.36255, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[57] = CreateDynamicObjectEx(1251, 1464.04883, -2278.88306, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[58] = CreateDynamicObjectEx(1251, 1464.33276, -2294.89600, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[59] = CreateDynamicObjectEx(1251, 1464.41187, -2299.44702, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[56], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[57], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[58], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[59], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[60] = CreateDynamicObjectEx(1251, 1464.33325, -2294.93604, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    idealhotel_texture[61] = CreateDynamicObjectEx(1251, 1464.41626, -2299.50708, 15.19596, 90.00000, 0.00000, 0.00000, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[60], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[61], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[62] = CreateDynamicObjectEx(19454, 1462.36609, -2287.01172, 10.51640, 90.00000, 0.00000, 1.02440, 300.0, 300.0);
    idealhotel_texture[63] = CreateDynamicObjectEx(19454, 1465.79773, -2286.94043, 10.58840, 90.00000, 0.00000, 1.02440, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[62], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    SetDynamicObjectMaterial(idealhotel_texture[63], 0, 2361, "shopping_freezers", "white", 0xFFD0CFCF);
    idealhotel_texture[64] = CreateDynamicObjectEx(2269, 1483.31506, -2274.91138, 13.53920, 0.00000, 0.00000, 111.24430, 300.0, 300.0);
    idealhotel_texture[65] = CreateDynamicObjectEx(2040, 1482.87195, -2275.10425, 13.34000, 0.00000, 0.00000, 21.37790, 300.0, 300.0);
    idealhotel_texture[66] = CreateDynamicObjectEx(2228, 1482.89172, -2275.05981, 12.99560, 0.00000, 0.00000, 291.15549, 300.0, 300.0);
    idealhotel_texture[67] = CreateDynamicObjectEx(2269, 1482.43054, -2275.24243, 13.53920, -0.02000, 0.00000, 291.46851, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[64], 0, 9818, "ship_brijsfw", "ship_greenscreen1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[64], 1, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[65], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[66], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[67], 0, 2361, "shopping_freezers", "white", 0xFF000000);
    SetDynamicObjectMaterial(idealhotel_texture[67], 1, 2361, "shopping_freezers", "white", 0xFF000000);
    idealhotel_texture[68] = CreateDynamicObjectEx(19377, 1469.90796, -2315.54712, 18.47920, 0.00000, 90.00000, 1.12530, 300.0, 300.0);
    idealhotel_texture[69] = CreateDynamicObjectEx(19377, 1480.38635, -2315.33179, 18.47920, 0.00000, 90.00000, 1.12530, 300.0, 300.0);
    idealhotel_texture[70] = CreateDynamicObjectEx(19377, 1484.12390, -2315.29175, 18.47920, 0.00000, 89.92000, 1.12530, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[68], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[69], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    SetDynamicObjectMaterial(idealhotel_texture[70], 0, 2361, "shopping_freezers", "white", 0xFFFFFFFF);
    idealhotel_texture[71] = CreateDynamicObjectEx(8661, 1475.26282, -2270.49365, 12.55990, 0.00000, 0.00000, 89.64303, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[71], 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    idealhotel_texture[72] = CreateDynamicObjectEx(8323, 1463.60828, -2283.02881, 47.59415, 0.00000, 0.00000, 183.81683, 300.0, 300.0);
    SetDynamicObjectMaterialText(idealhotel_texture[72], 0, "{0A5ABD}HOTEL", 130, "Haettenschweiler", 130, 1, -1, 0, 1);
    idealhotel_texture[73] = CreateDynamicObjectEx(8323, 1463.84998, -2296.72070, 46.37730, 0.00000, 0.00000, 183.81680, 300.0, 300.0);
    SetDynamicObjectMaterialText(idealhotel_texture[73], 0, "{FFFFFF}IORP", 130, "Britannic Bold", 60, 1, -1, 0, 1);
    idealhotel_texture[74] = CreateDynamicObjectEx(870, 1476.28650, -2286.81616, 12.88820, 0.00000, 0.00000, 304.94260, 300.0, 300.0);
    SetDynamicObjectMaterial(idealhotel_texture[74], 0, 4811, "beach_las", "sm_minipalm1", 0x00000000);
    CreateDynamicObjectEx(1808, 1470.71558, -2303.70801, 12.62223, 0.00000, 0.00000, 180.75758, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.34717, -2270.72949, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.48096, -2277.65674, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.60071, -2284.50610, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.70264, -2291.25073, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.84570, -2298.09937, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(11727, 1462.94800, -2304.84326, 45.01122, 0.00000, 0.00000, 269.39972, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1468.41150, -2252.54102, 41.70215, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1483.66980, -2252.09937, 41.85770, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1468.41150, -2252.54102, 36.59679, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1468.41150, -2252.54102, 30.68177, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1468.41150, -2252.54102, 25.70950, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1483.66980, -2252.09937, 25.70950, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1483.66980, -2252.09937, 31.17208, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1485.56360, -2320.90112, 41.15480, 0.00000, 0.00000, 271.63159, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1483.66980, -2252.09937, 36.82018, 0.00000, 0.00000, 271.12146, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1467.68823, -2321.27954, 41.23705, 0.00000, 0.00000, 270.39694, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1485.56360, -2320.90112, 36.82018, 0.00000, 0.00000, 271.63159, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1485.56360, -2320.90112, 30.20941, 0.00000, 0.00000, 271.63159, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1485.56360, -2320.90112, 27.13884, 0.00000, 0.00000, 271.63159, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1467.68823, -2321.27954, 27.13884, 0.00000, 0.00000, 270.39694, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1467.68823, -2321.27954, 31.58960, 0.00000, 0.00000, 270.39694, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1467.68823, -2321.27954, 35.89728, 0.00000, 0.00000, 270.39694, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1454.94885, -2252.60742, 11.32074, 0.00000, 0.00000, 202.81023, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1454.64075, -2320.07178, 11.32074, 0.00000, 0.00000, 338.90491, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1445.50354, -2313.76709, 11.32074, 0.00000, 0.00000, 311.97998, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1439.23645, -2300.60742, 11.32074, 0.00000, 0.00000, 280.90015, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1439.08899, -2272.44263, 11.32074, 0.00000, 0.00000, 261.72400, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1445.13391, -2259.44873, 11.32074, 0.00000, 0.00000, 232.68253, 300.0, 300.0);
    CreateDynamicObjectEx(16132, 1469.86987, -2284.29810, 39.12900, 0.00000, 0.00000, 1.02840, 300.0, 300.0);
    CreateDynamicObjectEx(3472, 1446.60791, -2272.86060, 12.86010, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3472, 1445.48523, -2302.61426, 12.86010, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1509.02991, -2269.98291, 11.07963, 0.00000, 0.00000, 280.60809, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1507.47327, -2307.30762, 11.07963, 0.00000, 0.00000, 249.69984, 300.0, 300.0);
    CreateDynamicObjectEx(1231, 1510.15137, -2287.66895, 11.07963, 0.00000, 0.00000, 271.41608, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1462.12866, -2317.93408, 25.61715, 0.00000, 0.00000, 1.04849, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1460.93091, -2255.94385, 25.24136, 0.00000, 0.00000, 1.86057, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1460.93091, -2255.94385, 30.78926, 0.00000, 0.00000, 1.86057, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1460.93091, -2255.94385, 35.53048, 0.00000, 0.00000, 1.86057, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1491.35901, -2316.98657, 41.48487, 0.00000, 0.00000, 1.00248, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1462.12866, -2317.93408, 40.87025, 0.00000, 0.00000, 1.04849, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1462.14868, -2317.93457, 35.69814, 0.00000, 0.00000, 1.04849, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1462.12866, -2317.93408, 30.35837, 0.00000, 0.00000, 1.04849, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1460.93091, -2255.94385, 41.17326, 0.00000, 0.00000, 1.86057, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1490.28149, -2255.61304, 41.17326, 0.00000, 0.00000, 0.79332, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1490.28149, -2255.61304, 35.21063, 0.00000, 0.00000, 0.79332, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1490.28149, -2255.61304, 31.20949, 0.00000, 0.00000, 0.79332, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1490.28149, -2255.61304, 25.24685, 0.00000, 0.00000, 0.79332, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1491.35901, -2316.98657, 25.24685, 0.00000, 0.00000, 1.00248, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1491.35901, -2316.98657, 31.36911, 0.00000, 0.00000, 1.00248, 300.0, 300.0);
    CreateDynamicObjectEx(19325, 1491.35901, -2316.98657, 35.96437, 0.00000, 0.00000, 1.00248, 300.0, 300.0);
    CreateDynamicObjectEx(9019, 1501.24609, -2287.18213, 14.20574, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(8623, 1499.29431, -2267.96631, 13.15386, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(8623, 1499.59961, -2305.97583, 13.15386, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(1364, 1505.67102, -2288.10913, 13.33070, 0.00000, 0.00000, 269.30273, 300.0, 300.0);
    CreateDynamicObjectEx(1364, 1497.57813, -2287.56641, 13.33070, 0.00000, 0.00000, 89.13950, 300.0, 300.0);
    CreateDynamicObjectEx(837, 1501.46838, -2287.66064, 12.97630, 0.00000, 0.00000, 249.14688, 300.0, 300.0);
    CreateDynamicObjectEx(748, 1499.58289, -2260.56348, 12.32060, 0.00000, 0.00000, 19.58215, 300.0, 300.0);
    CreateDynamicObjectEx(748, 1497.12317, -2314.25659, 12.32060, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(9833, 1498.49060, -2267.92505, 10.35478, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(9833, 1498.79309, -2306.03833, 10.35478, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(837, 1450.39148, -2304.69727, 12.90410, 0.00000, 0.00000, 316.28845, 300.0, 300.0);
    CreateDynamicObjectEx(837, 1448.61877, -2269.38965, 12.90410, 0.00000, 0.00000, 27.18958, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1461.14526, -2319.34692, 12.51530, 0.00000, 0.00000, 183.43213, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.64722, -2254.76294, 12.51530, 0.00000, 0.00000, 1.41323, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1440.69543, -2271.61548, 12.51530, 0.00000, 0.00000, 348.48471, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1443.13037, -2265.06250, 12.51530, 0.00000, 0.00000, 333.88983, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1447.22803, -2259.39478, 12.51530, 0.00000, 0.00000, 320.79990, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1452.44287, -2254.98096, 12.51530, 0.00000, 0.00000, 303.03522, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1459.11963, -2252.58887, 12.51530, 0.00000, 0.00000, 281.81949, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.58972, -2260.42358, 12.51530, 0.00000, 0.00000, 1.41323, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.58179, -2266.40527, 12.51530, 0.00000, 0.00000, 1.41323, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.62354, -2272.27002, 12.51530, 0.00000, 0.00000, 1.41323, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.76270, -2278.18896, 12.51530, 0.00000, 0.00000, 1.41323, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1442.31641, -2280.26636, 13.15410, 0.00000, 0.00000, 81.09890, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1447.65479, -2280.46484, 13.15410, 0.00000, 0.00000, 81.09890, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1452.55811, -2280.61279, 13.15410, 0.00000, 0.00000, 81.09890, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1457.83081, -2280.61011, 13.15410, 0.00000, 0.00000, 81.09890, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1456.40796, -2262.80273, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1447.48328, -2263.84888, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1451.76245, -2263.17383, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1452.50195, -2257.85815, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1443.58545, -2273.92578, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1456.56396, -2276.72998, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1450.87720, -2273.40161, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1445.78723, -2297.35132, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1439.72559, -2278.28784, 12.51530, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1439.66187, -2295.38721, 12.51530, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1440.54626, -2302.00732, 12.51530, 0.00000, 0.00000, 9.28460, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1442.73987, -2307.97754, 12.51530, 0.00000, 0.00000, 29.20053, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1446.45007, -2313.15552, 12.51530, 0.00000, 0.00000, 42.97737, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1451.36548, -2317.15283, 12.51530, 0.00000, 0.00000, 56.78021, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1457.63940, -2320.14282, 12.51530, 0.00000, 0.00000, 72.31458, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.96667, -2313.37427, 12.51530, 0.00000, 0.00000, 183.43213, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.88562, -2307.45117, 12.51530, 0.00000, 0.00000, 183.43213, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.84412, -2301.39380, 12.51530, 0.00000, 0.00000, 183.43213, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1460.93604, -2295.95752, 12.51530, 0.00000, 0.00000, 183.43213, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1442.81677, -2293.99658, 13.15410, 0.00000, 0.00000, 81.09890, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1448.14673, -2294.14722, 13.15410, 0.00000, 0.00000, 82.36715, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1453.14832, -2294.15234, 13.15410, 0.00000, 0.00000, 82.36715, 300.0, 300.0);
    CreateDynamicObjectEx(3532, 1458.12756, -2294.18384, 13.15410, 0.00000, 0.00000, 82.36715, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1448.01489, -2277.17651, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1456.11011, -2297.77344, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1444.05774, -2305.57813, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1457.05701, -2308.07227, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1448.22766, -2311.83276, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1452.67493, -2310.91455, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1450.98242, -2299.35693, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1442.48486, -2300.88110, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(861, 1456.49988, -2315.94067, 12.53340, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1439.68347, -2291.88989, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1443.08301, -2291.85718, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1446.57568, -2291.80713, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1449.99316, -2291.76074, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1453.13257, -2291.77588, 13.11870, 0.00000, 0.00000, 90.46126, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1456.24963, -2291.78906, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1459.58850, -2291.79980, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1462.81726, -2291.73950, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1439.83398, -2282.23779, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1443.24609, -2282.22046, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1446.63892, -2282.17651, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1449.94519, -2282.16919, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1453.08838, -2282.13257, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1456.20947, -2282.12427, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1459.34814, -2282.06909, 13.11870, 0.00000, 0.00000, 90.36464, 300.0, 300.0);
    CreateDynamicObjectEx(2773, 1462.50867, -2282.09180, 13.11870, 0.00000, 0.00000, 91.17030, 300.0, 300.0);
    CreateDynamicObjectEx(19802, 1488.15540, -2293.60864, 12.61909, 0.00000, 0.00000, 90.72327, 300.0, 300.0);
    CreateDynamicObjectEx(19802, 1488.22827, -2296.92871, 12.61909, 0.00000, 0.00000, 90.72327, 300.0, 300.0);
    CreateDynamicObjectEx(19802, 1488.29028, -2300.25293, 12.61909, 0.00000, 0.00000, 90.72327, 300.0, 300.0);
    CreateDynamicObjectEx(19802, 1488.09851, -2290.53247, 12.61909, 0.00000, 0.00000, 90.72327, 300.0, 300.0);
    CreateDynamicObjectEx(19802, 1488.02600, -2287.45361, 12.61909, 0.00000, 0.00000, 90.72327, 300.0, 300.0);
    CreateDynamicObjectEx(1723, 1484.46143, -2297.89917, 12.62174, 0.00000, 0.00000, 179.75516, 300.0, 300.0);
    CreateDynamicObjectEx(1723, 1482.52002, -2294.79297, 12.62174, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(2311, 1482.64539, -2296.37817, 12.62232, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(1723, 1468.30237, -2295.20532, 12.62174, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(2311, 1468.56921, -2296.85913, 12.62232, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(1723, 1470.32715, -2298.76465, 12.62174, 0.00000, 0.00000, 179.75516, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1464.49390, -2298.78369, 11.00010, 0.00000, 0.00000, 1.21511, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1464.07520, -2278.72827, 11.00010, 0.00000, 0.00000, 1.21511, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1464.28357, -2289.26465, 11.00010, 0.00000, 0.00000, 1.21511, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1463.99719, -2275.11084, 11.00010, 0.00000, 0.00000, 1.21511, 300.0, 300.0);
    CreateDynamicObjectEx(14455, 1487.76965, -2274.48096, 14.27155, 0.00000, 0.00000, 91.29996, 300.0, 300.0);
    CreateDynamicObjectEx(2164, 1487.71045, -2276.31982, 12.62072, 0.00000, 0.00000, 271.74652, 300.0, 300.0);
    CreateDynamicObjectEx(2167, 1487.78650, -2278.35645, 12.62357, 0.00000, 0.00000, 271.52087, 300.0, 300.0);
    CreateDynamicObjectEx(1714, 1484.53760, -2274.48926, 12.61851, 0.00000, 0.00000, 288.35962, 300.0, 300.0);
    CreateDynamicObjectEx(1210, 1483.43750, -2276.43115, 13.55600, 0.00000, 0.00000, 29.67130, 300.0, 300.0);
    CreateDynamicObjectEx(948, 1487.59436, -2282.55566, 12.61928, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(16779, 1476.06494, -2286.75049, 18.44460, 0.00000, 0.00000, 359.69699, 300.0, 300.0);
    CreateDynamicObjectEx(18075, 1475.98279, -2295.83838, 18.40850, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(18075, 1475.84656, -2277.18286, 18.42170, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(19859, 1465.89978, -2288.41821, 13.87080, 0.00000, 0.00000, 91.01442, 300.0, 300.0);
    CreateDynamicObjectEx(19859, 1465.84644, -2285.42676, 13.87080, 0.00000, 0.00000, 270.92136, 300.0, 300.0);
    CreateDynamicObjectEx(19859, 1462.24426, -2285.52539, 13.79880, 0.00000, 0.00000, 271.23627, 300.0, 300.0);
    CreateDynamicObjectEx(19859, 1462.30872, -2288.49072, 13.79880, 0.00000, 0.00000, 91.01440, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1443.31299, -2291.83618, 10.82570, 0.00000, 0.00000, 90.56180, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1452.92981, -2282.14136, 10.82570, 0.00000, 0.00000, 90.15879, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1462.34338, -2282.12256, 10.82570, 0.00000, 0.00000, 90.05678, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1443.35193, -2282.21167, 10.82570, 0.00000, 0.00000, 90.56180, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1452.88782, -2291.78418, 10.82570, 0.00000, 0.00000, 90.05170, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1443.31299, -2291.83618, 10.82570, 0.00000, 0.00000, 90.56180, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1462.46960, -2291.77856, 10.82570, 0.00000, 0.00000, 90.05170, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1474.42664, -2296.58643, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1475.76794, -2282.04077, 10.90920, 0.00000, 0.00000, 271.29010, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1476.75769, -2291.63623, 10.90920, 0.00000, 0.00000, 91.09433, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1476.69897, -2282.01855, 10.90920, 0.00000, 0.00000, 271.29010, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1475.99805, -2291.64893, 10.90920, 0.00000, 0.00000, 91.09430, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1481.54639, -2286.81592, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1471.15527, -2286.90796, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1473.85266, -2271.23047, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1477.96326, -2271.13086, 10.90920, 0.00000, -0.06000, 181.11623, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1473.97998, -2277.17236, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1474.55225, -2301.98242, 10.90920, 0.00000, -0.06000, 1.34700, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1478.07690, -2277.09424, 10.90920, 0.00000, -0.06000, 181.11623, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1478.50793, -2301.69873, 10.90920, 0.00000, -0.06000, 181.11623, 300.0, 300.0);
    CreateDynamicObjectEx(19450, 1478.40857, -2296.50269, 10.90920, 0.00000, -0.06000, 181.11623, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1471.93311, -2312.81763, 12.54080, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1471.80627, -2316.95825, 12.54080, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1475.02246, -2316.79785, 12.54080, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1477.98865, -2311.71606, 12.54080, 0.00000, 0.00000, 276.45468, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1475.09204, -2312.78369, 12.54080, 0.00000, 0.00000, 0.00000, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1477.03516, -2315.43994, 12.54080, 0.00000, 0.00000, 276.45468, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1478.80408, -2316.96729, 12.54080, 0.00000, 0.00000, 179.29561, 300.0, 300.0);
    CreateDynamicObjectEx(3520, 1476.88708, -2318.87061, 12.54080, 0.00000, 0.00000, 276.45468, 300.0, 300.0);
    return 1;
}