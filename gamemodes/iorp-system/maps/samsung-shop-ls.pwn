// 1422.3947,-1182.1415,26.0029
// 1422.1973,-1177.4004,25.9922

hook OnPlayerMapLoad(playerid) {
    RemoveBuildingForPlayer(playerid, 4629, 1405.1172, -1191.4063, 85.0313, 0.25);
    RemoveBuildingForPlayer(playerid, 4586, 1405.1172, -1191.4063, 85.0313, 0.25);
    return 1;
}

hook OnGameModeInit() {
    new ispredslikatasta = CreateDynamicObjectEx(19471, 1425.71838, -1180.31384, 27.85940, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterialText(ispredslikatasta, 0, "7", 140, "WINGDINGS", 220, 1, -1, 0, 1);
    new ispredslikaMIS = CreateDynamicObjectEx(19471, 1418.52991, -1180.31384, 27.85940, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterialText(ispredslikaMIS, 0, "8", 140, "WINGDINGS", 220, 1, -1, 0, 1);
    new slikicanaTV = CreateDynamicObjectEx(19471, 1417.49390, -1184.22192, 26.07472, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(slikicanaTV, 0, "m", 140, "WEBDINGS", 200, 0, -1, 0, 1);
    new samsungic = CreateDynamicObjectEx(19471, 1424.3209, -1184.1114, 24.5420, 0.0000, 0.0000, 90.0000);
    SetDynamicObjectMaterialText(samsungic, 0, "SAMSUNG", 140, "Arial", 80, 1, -8092540, 0, 1);
    new iphonicc = CreateDynamicObjectEx(19471, 1419.97278, -1184.11145, 24.54200, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterialText(iphonicc, 0, "IPHONE", 140, "Arial", 80, 1, -8092540, 0, 1);
    new superramoled = CreateDynamicObjectEx(19471, 1417.23779, -1186.91052, 24.87800, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(superramoled, 0, "SUPER AMOLED", 140, "Arial", 65, 1, 0xFF000000, 0, 1);
    new amoledd = CreateDynamicObjectEx(19471, 1417.23779, -1184.21802, 24.87800, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(amoledd, 0, "AMOLED", 140, "Arial", 80, 1, 0xFF000000, 0, 1);
    new tfttLcD = CreateDynamicObjectEx(19471, 1417.23779, -1181.59045, 24.87800, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(tfttLcD, 0, "TFT LCD", 140, "Arial", 80, 1, 0xFF000000, 0, 1);
    new asuss = CreateDynamicObjectEx(19353, 1427.13403, -1184.23877, 26.88290, 0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterialText(asuss, 0, "ASUS", 140, "Arial", 40, 1, -8092540, 0, 1);
    new lenovoo = CreateDynamicObjectEx(19353, 1427.1340, -1181.6110, 26.8829, 0.0000, 0.0000, 180.0000);
    SetDynamicObjectMaterialText(lenovoo, 0, "LENOVO", 140, "Arial", 40, 1, -8092540, 0, 1);
    new emishopentnatpd = CreateDynamicObjectEx(19353, 1421.87952, -1187.73462, 27.48280, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterialText(emishopentnatpd, 140, "Samsung SHOP 0", 80, "Comic Sans MS", 1, -8092540, 0, 1);
    new emminatpiss = CreateDynamicObjectEx(19353, 1418.8385, -1188.0003, 26.7229, 0.0000, 0.0000, 90.0000);
    SetDynamicObjectMaterialText(emminatpiss, 0, "Samsung", 140, "Comic Sans MS", 130, 1, -8092540, 0, 1);
    new shoppnatpis = CreateDynamicObjectEx(19353, 1418.14612, -1187.99170, 26.44280, -10.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterialText(shoppnatpis, 0, "Shop", 140, "Comic Sans MS", 96, 1, 0xFF0073e6, 0, 1);
    new emmishopa = CreateDynamicObjectEx(19353, 1422.1751, -1180.3770, 28.7065, 0.0000, 0.0000, 89.8485);
    SetDynamicObjectMaterialText(emmishopa, 0, "Shop - Samsung - ", 140, "Comic Sans MS", 85, 1, -8092540, 0, 1);
    new emmishopsmece = CreateDynamicObjectEx(19471, 1417.55298, -1179.66956, 24.68610, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(emmishopsmece, 0, "q", 140, "Webdings", 220, 0, -1, 0, 1);
    new emmishopsmecc = CreateDynamicObjectEx(19471, 1426.76367, -1179.73413, 24.68610, 0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterialText(emmishopsmecc, 0, "q", 140, "Webdings", 220, 0, -1, 0, 1);

    new emmishop;
    emmishop = CreateDynamicObjectEx(4586, 1405.11719, -1191.40625, 85.03130, 0.00000, 0.00000, 0.00000, 600.0, 600.0);
    SetDynamicObjectMaterial(emmishop, 9, 0, "none", "none", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(1714, 1421.14539, -1187.10352, 24.96390, 0.00000, 0.00000, 137.28000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(1714, 1423.25598, -1187.15454, 24.96390, 0.00000, 0.00000, 195.23999, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18869, 1421.29517, -1186.31140, 25.74800, 0.00000, 0.00000, -37.74000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(2684, 1423.49011, -1185.88281, 25.59142, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18868, 1425.07922, -1184.45447, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18868, 1424.78247, -1184.45447, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18868, 1424.30273, -1184.45447, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18868, 1424.14148, -1184.45447, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18868, 1423.54138, -1184.45447, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18867, 1425.07605, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18867, 1424.79199, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18867, 1424.04773, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18867, 1423.68384, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18870, 1419.16272, -1184.44397, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18870, 1419.56604, -1184.44397, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18870, 1420.16907, -1184.44397, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18870, 1420.59241, -1184.44397, 25.87600, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18866, 1419.38306, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18866, 1420.01453, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18866, 1420.19031, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(18866, 1420.65979, -1183.89819, 25.87600, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(19894, 1426.87512, -1181.23730, 26.13990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(19894, 1426.89038, -1183.57275, 26.13990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(19894, 1426.88940, -1184.89734, 26.13990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1426.51257, -1184.14954, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1426.51257, -1181.10583, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1422.15540, -1181.10583, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1417.79871, -1181.10583, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1417.79871, -1184.14954, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1417.79871, -1187.35156, 28.09950, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(1223, 1431.47559, -1175.91443, 24.66290, 0.00000, 0.00000, 125.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(1223, 1412.81506, -1175.82983, 24.66290, 0.00000, 0.00000, 35.00000, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(2671, 1418.34497, -1178.78931, 24.98280, 0.00000, 0.00000, -159.06010, 400.0, 400.0);
    emmishop = CreateDynamicObjectEx(957, 1422.14526, -1184.15381, 28.12521, 0.00000, 0.00000, 0.00000, 400.0, 400.0);

    new emmishopcrna[67];
    emmishopcrna[1] = CreateDynamicObjectEx(1897, 1427.08093, -1180.63513, 25.67540, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[2] = CreateDynamicObjectEx(1897, 1417.20740, -1180.63513, 27.91166, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[3] = CreateDynamicObjectEx(1897, 1427.08093, -1180.63513, 27.91170, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[4] = CreateDynamicObjectEx(1897, 1417.20740, -1180.63513, 25.67540, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[5] = CreateDynamicObjectEx(1897, 1420.92847, -1180.63513, 25.67540, -180.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[6] = CreateDynamicObjectEx(1897, 1419.02271, -1180.63513, 27.91020, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[7] = CreateDynamicObjectEx(1897, 1421.97217, -1180.53284, 24.91610, 90.00000, -90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[8] = CreateDynamicObjectEx(1897, 1423.39111, -1180.63513, 27.91020, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[9] = CreateDynamicObjectEx(1897, 1419.04614, -1180.63513, 25.67540, -180.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[10] = CreateDynamicObjectEx(1897, 1422.34741, -1180.55762, 24.91790, 90.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[11] = CreateDynamicObjectEx(1897, 1422.34741, -1180.55762, 27.31550, 90.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[12] = CreateDynamicObjectEx(18633, 1417.28064, -1181.67200, 26.32990, 0.00000, 0.00000, -35.76002, 400.0, 400.0);
    emmishopcrna[13] = CreateDynamicObjectEx(19089, 1427.82080, -1187.65100, 27.18220, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[14] = CreateDynamicObjectEx(18633, 1422.30078, -1180.33240, 25.97540, 90.00000, 180.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[15] = CreateDynamicObjectEx(18633, 1421.97668, -1180.33240, 25.97540, 90.00000, 180.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[16] = CreateDynamicObjectEx(18633, 1422.30078, -1180.72327, 25.97540, 90.00000, 180.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[17] = CreateDynamicObjectEx(1897, 1423.41516, -1180.63513, 25.67540, -180.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[18] = CreateDynamicObjectEx(1897, 1425.24866, -1180.63513, 27.91020, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[19] = CreateDynamicObjectEx(1897, 1425.27271, -1180.63513, 25.67540, -180.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[20] = CreateDynamicObjectEx(1897, 1420.90417, -1180.63513, 27.91020, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[21] = CreateDynamicObjectEx(1897, 1421.97217, -1180.53284, 27.31772, 90.00000, -90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[22] = CreateDynamicObjectEx(19377, 1428.71423, -1180.51770, 20.23600, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[23] = CreateDynamicObjectEx(19378, 1427.12341, -1185.83167, 20.30350, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[24] = CreateDynamicObjectEx(19378, 1412.46570, -1185.20349, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[25] = CreateDynamicObjectEx(19089, 1422.14490, -1180.53296, 27.41720, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[26] = CreateDynamicObjectEx(19089, 1425.43604, -1187.66772, 27.19620, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[27] = CreateDynamicObjectEx(19089, 1427.04944, -1187.65100, 27.19620, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[28] = CreateDynamicObjectEx(19089, 1427.82080, -1187.65100, 27.24770, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[29] = CreateDynamicObjectEx(19087, 1420.44470, -1187.65100, 29.68660, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[30] = CreateDynamicObjectEx(19087, 1427.04944, -1187.65100, 29.68660, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[31] = CreateDynamicObjectEx(19089, 1427.82080, -1187.65100, 25.01841, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[32] = CreateDynamicObjectEx(19089, 1422.02490, -1187.66772, 27.19620, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[33] = CreateDynamicObjectEx(19089, 1423.77783, -1187.66772, 27.19620, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[34] = CreateDynamicObjectEx(19087, 1422.02490, -1187.66772, 29.68660, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[35] = CreateDynamicObjectEx(19087, 1423.77783, -1187.66772, 29.68660, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[36] = CreateDynamicObjectEx(19087, 1425.43604, -1187.66772, 29.68660, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[37] = CreateDynamicObjectEx(19377, 1422.12903, -1180.51770, 32.85455, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[38] = CreateDynamicObjectEx(19377, 1422.12903, -1181.60315, 32.95460, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[39] = CreateDynamicObjectEx(19377, 1418.25061, -1186.59753, 32.95150, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[40] = CreateDynamicObjectEx(19377, 1422.12903, -1186.91565, 32.95460, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[41] = CreateDynamicObjectEx(19377, 1426.04602, -1186.59753, 32.95150, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[42] = CreateDynamicObjectEx(19089, 1420.08289, -1181.69409, 28.17000, 0.00000, 90.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[43] = CreateDynamicObjectEx(1863, 1422.14905, -1184.14587, 28.15800, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[44] = CreateDynamicObjectEx(19378, 1431.84778, -1182.53638, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[45] = CreateDynamicObjectEx(19378, 1412.46570, -1183.19946, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[46] = CreateDynamicObjectEx(19378, 1412.46570, -1182.53638, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[47] = CreateDynamicObjectEx(19378, 1412.46570, -1187.84509, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[48] = CreateDynamicObjectEx(19378, 1412.46570, -1180.63647, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[49] = CreateDynamicObjectEx(19378, 1412.46570, -1185.94397, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[50] = CreateDynamicObjectEx(19378, 1431.84778, -1180.63647, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[51] = CreateDynamicObjectEx(19378, 1431.84778, -1183.19946, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[52] = CreateDynamicObjectEx(19378, 1431.84778, -1185.20349, 23.83480, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[53] = CreateDynamicObjectEx(19089, 1420.44470, -1187.65100, 27.19620, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[54] = CreateDynamicObjectEx(19089, 1427.82080, -1187.65100, 28.08900, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[55] = CreateDynamicObjectEx(19089, -1181.33215, -1181.33215, 28.17000, 0.00000, 90.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[56] = CreateDynamicObjectEx(19089, 1422.14905, -1181.69409, 28.17000, 0.00000, 90.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[57] = CreateDynamicObjectEx(19089, 1424.21228, -1181.69409, 28.17000, 0.00000, 90.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[58] = CreateDynamicObjectEx(19377, 1415.60486, -1180.51770, 20.23600, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[59] = CreateDynamicObjectEx(19378, 1422.02161, -1187.97034, 20.30530, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopcrna[60] = CreateDynamicObjectEx(19378, 1417.19788, -1185.83167, 20.30350, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[61] = CreateDynamicObjectEx(18633, 1421.97668, -1180.72327, 25.97540, 90.00000, 180.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[62] = CreateDynamicObjectEx(18633, 1417.40417, -1186.86841, 26.32990, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopcrna[63] = CreateDynamicObjectEx(18633, 1417.15723, -1184.76636, 26.32990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishopcrna[64] = CreateDynamicObjectEx(18633, 1417.40417, -1186.95044, 26.32880, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopcrna[65] = CreateDynamicObjectEx(18633, 1417.15723, -1183.70557, 26.32990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishopcrna[66] = CreateDynamicObjectEx(18633, 1417.24231, -1181.39355, 26.32990, 0.00000, 0.00000, -136.23997, 400.0, 400.0);
    for (new i = 0; i < sizeof(emmishopcrna); i++) SetDynamicObjectMaterial(emmishopcrna[i], 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);

    new emmishopdrvo[27];
    emmishopdrvo[1] = CreateDynamicObjectEx(1744, 1420.89465, -1185.94250, 25.42480, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[2] = CreateDynamicObjectEx(1744, 1422.45605, -1185.94055, 25.42670, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[3] = CreateDynamicObjectEx(1744, 1422.61694, -1186.15015, 25.38030, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[4] = CreateDynamicObjectEx(19563, 1421.94897, -1185.95691, 25.76320, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[5] = CreateDynamicObjectEx(19563, 1420.86621, -1185.95691, 25.53998, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[6] = CreateDynamicObjectEx(19563, 1420.76685, -1185.95605, 25.28960, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[7] = CreateDynamicObjectEx(19561, 1421.24365, -1185.96826, 25.06810, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[8] = CreateDynamicObjectEx(19563, 1422.48645, -1185.95691, 25.14830, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[9] = CreateDynamicObjectEx(19561, 1423.13843, -1185.96826, 25.38230, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[10] = CreateDynamicObjectEx(19563, 1423.78784, -1185.95691, 25.52520, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[11] = CreateDynamicObjectEx(19563, 1423.51770, -1185.95691, 25.22610, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[12] = CreateDynamicObjectEx(1744, 1427.21631, -1181.10010, 25.80470, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishopdrvo[13] = CreateDynamicObjectEx(1744, 1427.21631, -1183.72021, 25.80470, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    emmishopdrvo[14] = CreateDynamicObjectEx(1744, 1424.78992, -1184.23560, 25.55270, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[15] = CreateDynamicObjectEx(1744, 1423.83337, -1184.10840, 25.55270, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[16] = CreateDynamicObjectEx(1744, 1419.48657, -1184.10840, 25.55270, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[17] = CreateDynamicObjectEx(1744, 1420.44080, -1184.23560, 25.55270, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[18] = CreateDynamicObjectEx(1744, 1417.07813, -1187.37732, 25.80470, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopdrvo[19] = CreateDynamicObjectEx(1744, 1417.07813, -1184.68970, 25.80470, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopdrvo[20] = CreateDynamicObjectEx(1744, 1417.07813, -1182.06848, 25.80466, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    emmishopdrvo[21] = CreateDynamicObjectEx(1744, 1420.44080, -1184.48938, 24.66980, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[22] = CreateDynamicObjectEx(1744, 1424.78992, -1184.48938, 24.66980, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[23] = CreateDynamicObjectEx(1744, 1423.48560, -1186.32385, 24.66980, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[24] = CreateDynamicObjectEx(1744, 1421.78235, -1186.32214, 24.66799, 0.00000, 0.00000, 180.00000, 400.0, 400.0);
    emmishopdrvo[25] = CreateDynamicObjectEx(2388, 1424.19531, -1179.63367, 24.29397, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    emmishopdrvo[26] = CreateDynamicObjectEx(2388, 1420.58203, -1179.63367, 24.29400, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    for (new i = 0; i < sizeof(emmishopdrvo); i++) SetDynamicObjectMaterial(emmishopdrvo[i], 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(19893, 1423.34180, -1186.33582, 25.76470, 0.00000, 0.00000, -44.52001, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19893, 1420.95508, -1186.41968, 25.76470, 0.00000, 0.00000, 16.85999, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19893, 1426.80713, -1184.19946, 26.13990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19893, 1426.80945, -1181.72412, 26.13990, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(19865, 1427.06091, -1182.60181, 25.70040, 90.00000, 0.00000, 180.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13724, "docg01_lahills", "concpanel_la", 0xFF999999);
    emmishop = CreateDynamicObjectEx(19865, 1427.06091, -1185.24072, 25.70040, 90.00000, 0.00000, 180.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13724, "docg01_lahills", "concpanel_la", 0xFF999999);
    emmishop = CreateDynamicObjectEx(19865, 1417.24438, -1185.88245, 25.70040, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13724, "docg01_lahills", "concpanel_la", 0xFF999999);
    emmishop = CreateDynamicObjectEx(19865, 1417.24438, -1183.16626, 25.70040, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13724, "docg01_lahills", "concpanel_la", 0xFF999999);
    emmishop = CreateDynamicObjectEx(19865, 1417.24438, -1180.55994, 25.70040, 90.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13724, "docg01_lahills", "concpanel_la", 0xFF999999);

    emmishop = CreateDynamicObjectEx(19377, 1417.16064, -1185.37268, 23.83480, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19377, 1422.02161, -1188.01123, 23.83480, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19377, 1427.15100, -1185.37268, 23.83480, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19443, 1424.31372, -1184.17151, 24.30320, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19443, 1422.15222, -1186.00549, 25.06480, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19443, 1419.96838, -1184.17151, 24.30320, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(18765, 1422.14697, -1185.57996, 30.70510, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(18766, 1417.72522, -1186.58655, 30.60220, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(18766, 1422.11755, -1181.08777, 30.60670, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(18766, 1422.11755, -1187.43799, 30.60550, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(18766, 1426.57617, -1186.58655, 30.60220, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(19787, 1417.34802, -1186.89990, 26.71930, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13816, "lahills_safe1", "gry_roof", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19786, 1417.38989, -1184.22437, 26.90150, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13816, "lahills_safe1", "gry_roof", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(19787, 1417.40649, -1181.53381, 26.69130, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13816, "lahills_safe1", "gry_roof", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(19325, 1423.77783, -1187.65100, 29.31042, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFF3399ff);
    emmishop = CreateDynamicObjectEx(19325, 1423.77783, -1187.65100, 25.11478, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFF3399ff);

    emmishop = CreateDynamicObjectEx(19325, 1424.24146, -1180.53052, 26.36200, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFF4da6ff);
    emmishop = CreateDynamicObjectEx(19325, 1417.59729, -1180.53052, 26.36200, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFF4da6ff);

    emmishop = CreateDynamicObjectEx(19325, 1422.14905, -1183.94299, 28.16620, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFFb3b3b3);
    emmishop = CreateDynamicObjectEx(19325, 1418.02100, -1183.94299, 28.16620, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFFb3b3b3);
    emmishop = CreateDynamicObjectEx(19325, 1426.27612, -1183.94299, 28.16620, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 19325, "lsmall_shops", "lsmall_window01", 0xFFb3b3b3);

    emmishop = CreateDynamicObjectEx(19376, 1422.13098, -1180.48987, 33.63890, 90.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(18762, 1424.65649, -1180.79553, 28.65330, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFF00aaff);
    emmishop = CreateDynamicObjectEx(18762, 1419.65674, -1180.79553, 28.65330, 0.00000, 90.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 18265, "w_town3cs_t", "ws_whitewall2_top", 0xFF00aaff);

    emmishop = CreateDynamicObjectEx(914, 1422.72095, -1180.55359, 28.16050, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFb3b3b3);
    emmishop = CreateDynamicObjectEx(914, 1421.55261, -1180.55505, 28.16050, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 4600, "theatrelan2", "sl_whitewash1", 0xFFb3b3b3);

    emmishop = CreateDynamicObjectEx(1453, 1423.95801, -1179.90222, 25.92384, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13681, "lahillshilhs1e", "veg_hedge1_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(emmishop, 1, 13681, "lahillshilhs1e", "veg_hedge1_256", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(1453, 1420.34094, -1179.90222, 25.92380, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 13681, "lahillshilhs1e", "veg_hedge1_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(emmishop, 1, 13681, "lahillshilhs1e", "veg_hedge1_256", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(2203, 1423.95227, -1179.89185, 24.88000, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 9495, "vict_sfw", "Grass_128HV", 0xFFFFFFFF); //trava
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF); //crna
    emmishop = CreateDynamicObjectEx(2203, 1420.34155, -1179.89185, 24.87999, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 9495, "vict_sfw", "Grass_128HV", 0xFFFFFFFF); //trava
    SetDynamicObjectMaterial(emmishop, 1, 1676, "wshxrefpump", "black64", 0xFFFFFFFF); //crna

    emmishop = CreateDynamicObjectEx(970, 1429.16895, -1175.90735, 25.47960, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 12959, "sw_library", "sjmornfnce", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(970, 1422.13806, -1175.90735, 25.47960, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 12959, "sw_library", "sjmornfnce", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(970, 1415.15930, -1175.90735, 25.47960, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 12959, "sw_library", "sjmornfnce", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(1280, 1415.26184, -1178.30066, 25.36442, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 16005, "des_stownmain2", "woodenpanels256", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(1280, 1429.37329, -1178.30066, 25.36440, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 1, 16005, "des_stownmain2", "woodenpanels256", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(2420, 1417.12305, -1179.52808, 24.94330, 0.00000, 0.00000, 90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
    SetDynamicObjectMaterial(emmishop, 1, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
    emmishop = CreateDynamicObjectEx(2420, 1427.19604, -1179.88293, 24.94330, 0.00000, 0.00000, -90.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
    SetDynamicObjectMaterial(emmishop, 1, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);

    emmishop = CreateDynamicObjectEx(18765, 1422.14697, -1185.57996, 22.50290, 0.00000, 0.00000, 0.00000, 400.0, 400.0);
    SetDynamicObjectMaterial(emmishop, 0, 16005, "des_stownmain2", "woodenpanels256", 0xFFFFFFFF);
    return 1;
}