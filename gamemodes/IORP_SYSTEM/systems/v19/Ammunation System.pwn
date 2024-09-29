#define Ammo_9MM            (150)
#define Ammo_GRANATEN       (5)
#define Ammo_AK             (500)
#define Ammo_M4             (500)
#define Ammo_RPG            (5)
#define Ammo_SNIPER         (20)
#define Ammo_COUNTRY        (20)
#define Ammo_BASEBALL       (1)
#define Ammo_MP5            (500)
#define Ammo_MESSER         (1)
#define Ammo_MOLOTOV        (5)
#define Ammo_SD9MM          (120)
#define Ammo_DEAGLE         (50)
#define Ammo_COMBAT         (40)
#define Ammo_SAWN           (20)
#define Ammo_UZI            (500)
#define Ammo_TEC9           (500)
#define Ammo_SHOTGUN        (20)

#define Price_9MM           (6 * Ammo_9MM)
#define Price_GRANATEN      (600 * Ammo_GRANATEN)
#define Price_AK            (4 * Ammo_AK)
#define Price_M4            (4 * Ammo_M4)
#define Price_RPG           (100 * Ammo_RPG)
#define Price_SNIPER        (42 * Ammo_SNIPER)
#define Price_COUNTRY       (36 * Ammo_COUNTRY)
#define Price_BASEBALL      (486 * Ammo_BASEBALL)
#define Price_MP5           (4 * Ammo_MP5)
#define Price_MESSER        (279 * Ammo_MESSER)
#define Price_MOLOTOV       (600 * Ammo_MOLOTOV)
#define Price_SD9MM         (6 * Ammo_SD9MM)
#define Price_DEAGLE        (8 * Ammo_DEAGLE)
#define Price_COMBAT        (6 * Ammo_COMBAT)
#define Price_SAWN          (8 * Ammo_SAWN)
#define Price_UZI           (4 * Ammo_UZI)
#define Price_TEC9          (6 * Ammo_TEC9)
#define Price_SHOTGUN       (8 * Ammo_SHOTGUN)

new Text:AMSS_Textdraw[2 + 6 + 1], AMWeapSelect[MAX_PLAYERS], PlayerText:AMSS_Price[MAX_PLAYERS];

forward WeaponShopCheck();
public WeaponShopCheck() {
    foreach(new x:Player) {
        if (IsPlayerConnected(x)) {
            if (IsPlayerInRangeOfPoint(x, 1, 1412.4585, -1307.8866, 14.2059) || IsPlayerInRangeOfPoint(x, 1, 1412.13, -1316.44, 14.07) || IsPlayerInRangeOfPoint(x, 1, 1409.22, -1315.83, 13.70) ||
                IsPlayerInRangeOfPoint(x, 1, 1416.47, -1310.89, 14.20) || IsPlayerInRangeOfPoint(x, 1, 1412.03, -1315.55, 13.90) || IsPlayerInRangeOfPoint(x, 1, 1409.23, -1318.49, 13.70) ||
                IsPlayerInRangeOfPoint(x, 1, 1416.21, -1314.82, 13.86) || IsPlayerInRangeOfPoint(x, 1, 1413.05, -1315.57, 13.83) || IsPlayerInRangeOfPoint(x, 1, 1412.99, -1321.07, 14.17) ||
                IsPlayerInRangeOfPoint(x, 1, 1414.44, -1321.40, 14.19) || IsPlayerInRangeOfPoint(x, 1, 1412.16, -1317.49, 13.86) || IsPlayerInRangeOfPoint(x, 1, 1410.97, -1321.16, 14.16) ||
                IsPlayerInRangeOfPoint(x, 1, 1416.08, -1320.73, 14.19) || IsPlayerInRangeOfPoint(x, 1, 1412.97, -1309.29, 14.13) || IsPlayerInRangeOfPoint(x, 1, 1409.53, -1320.77, 14.14) ||
                IsPlayerInRangeOfPoint(x, 1, 1413.13, -1310.70, 14.15) || IsPlayerInRangeOfPoint(x, 1, 1413.05, -1317.05, 13.92) || IsPlayerInRangeOfPoint(x, 1, 1413.99, -1310.79, 14.20)) {
                TextDrawShowForPlayer(x, AMSS_Textdraw[0]);
                TextDrawShowForPlayer(x, AMSS_Textdraw[1]);
            } else {
                TextDrawHideForPlayer(x, AMSS_Textdraw[0]);
                TextDrawHideForPlayer(x, AMSS_Textdraw[1]);
            }
        }
    }
    return 1;
}

hook OnGameModeInit() {
    new tmpObject = CreateDynamicObject(7313, 1367.17, -1279.99, 15.60, 0.0, 0.0, 270.0);
    SetDynamicObjectMaterialText(tmpObject, 0, "{ff0000}IORP - Ammunation", OBJECT_MATERIAL_SIZE_512x64, "Courier", 30, 1, 0x00000000, 0x00000001, 1);
    SetPreciseTimer("WeaponShopCheck", 1000, true);
    CreateDynamicObject(19375, 1411.77, -1307.68, 13.12, 0.00, 90.00, 0.00);
    CreateDynamicObject(19375, 1411.77, -1317.31, 13.12, 0.00, 90.00, 0.00);
    CreateDynamicObject(19375, 1401.27, -1307.68, 13.12, 0.00, 90.00, 0.00);
    CreateDynamicObject(19375, 1401.27, -1317.31, 13.12, 0.00, 90.00, 0.00);
    CreateDynamicObject(14877, 1408.16, -1300.99, 11.11, 0.00, 0.00, 180.00);
    CreateDynamicObject(14877, 1408.16, -1297.99, 11.11, 0.00, 0.00, 180.00);
    CreateDynamicObject(19389, 1404.19, -1302.96, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19451, 1412.21, -1302.96, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19432, 1406.59, -1302.96, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19451, 1403.27, -1307.73, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19359, 1404.93, -1307.09, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(17969, 1407.77, -1303.08, 14.81, 0.00, 0.00, 90.00);
    CreateDynamicObject(19451, 1416.95, -1307.86, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19405, 1416.95, -1314.28, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19389, 1416.95, -1317.49, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19408, 1417.10, -1320.70, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19451, 1412.21, -1322.18, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19451, 1402.58, -1322.18, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19451, 1408.47, -1317.36, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19359, 1412.22, -1307.09, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19359, 1415.43, -1307.09, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(3125, 1416.97, -1313.48, 14.30, 0.00, 30.00, 90.00);
    CreateDynamicObject(3125, 1416.97, -1313.53, 14.32, 0.00, -30.00, -90.00);
    CreateDynamicObject(1499, 1403.41, -1302.90, 13.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(19359, 1415.43, -1310.20, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19359, 1413.83, -1308.69, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19391, 1417.10, -1317.49, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19408, 1417.10, -1314.28, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19454, 1417.10, -1307.86, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19454, 1412.21, -1302.78, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1406.59, -1302.78, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19391, 1404.19, -1302.78, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(1497, 1417.07, -1318.23, 13.13, 0.00, 0.00, 90.00);
    CreateDynamicObject(19405, 1416.95, -1320.70, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19451, 1403.74, -1312.63, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(1271, 1413.01, -1317.34, 13.52, 0.00, 0.00, 0.00);
    CreateDynamicObject(1271, 1413.01, -1316.56, 13.52, 0.00, 0.00, 0.00);
    CreateDynamicObject(1271, 1413.01, -1315.76, 13.52, 0.00, 0.00, 0.00);
    CreateDynamicObject(1271, 1412.21, -1317.34, 13.52, 0.00, 0.00, -10.00);
    CreateDynamicObject(1271, 1412.21, -1316.40, 13.52, 0.00, 0.00, 10.00);
    CreateDynamicObject(2311, 1409.17, -1317.01, 13.21, 0.00, 0.00, 86.00);
    CreateDynamicObject(2311, 1409.23, -1319.53, 13.21, 0.00, 0.00, 93.00);
    CreateDynamicObject(18046, 1407.01, -1314.83, 13.21, 0.00, 0.00, -86.46);
    CreateDynamicObject(18092, 1411.30, -1321.16, 13.64, 0.00, 0.00, 176.00);
    CreateDynamicObject(4227, 1414.67, -1321.99, 14.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(2358, 1413.00, -1316.23, 13.97, 0.00, 0.00, 93.66);
    CreateDynamicObject(2358, 1412.22, -1315.62, 13.31, 0.00, 0.00, 207.60);
    CreateDynamicObject(2358, 1412.22, -1315.62, 13.55, 0.00, 0.00, 198.84);
    CreateDynamicObject(2358, 1412.22, -1315.62, 13.80, 0.00, 0.00, 181.98);
    CreateDynamicObject(2359, 1412.35, -1316.74, 14.07, 0.00, 0.00, -77.46);
    CreateDynamicObject(342, 1412.13, -1316.44, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.16, -1316.54, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.18, -1316.64, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.20, -1316.74, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.22, -1316.84, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.37, -1316.82, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(342, 1412.34, -1316.71, 14.07, 0.00, 90.00, 0.00);
    CreateDynamicObject(355, 1409.22, -1315.83, 13.70, 97.20, 41.46, -132.96);
    CreateDynamicObject(356, 1409.23, -1318.49, 13.70, 97.20, 41.46, -120.36);
    CreateDynamicObject(359, 1412.99, -1321.07, 14.17, 90.00, 0.00, 18.54);
    CreateDynamicObject(358, 1410.97, -1321.16, 14.16, 97.20, 41.46, -38.76);
    CreateDynamicObject(357, 1409.53, -1320.77, 14.14, 101.28, 41.82, -77.28);
    CreateDynamicObject(336, 1413.05, -1317.05, 13.92, 66.06, 11.10, -199.86);
    CreateDynamicObject(353, 1412.03, -1315.55, 13.90, 83.46, -80.22, 79.86);
    CreateDynamicObject(335, 1413.05, -1315.57, 13.83, 90.00, 0.00, 48.12);
    CreateDynamicObject(344, 1412.16, -1317.49, 13.86, 90.00, 0.00, -94.26);
    CreateDynamicObject(344, 1412.26, -1317.43, 13.86, 90.00, 0.00, -236.58);
    CreateDynamicObject(2358, 1409.36, -1315.58, 13.40, 0.00, 0.00, 48.24);
    CreateDynamicObject(2358, 1409.31, -1316.68, 13.40, 0.00, 0.00, 88.68);
    CreateDynamicObject(2358, 1409.33, -1318.20, 13.40, 0.00, 0.00, 97.92);
    CreateDynamicObject(2358, 1409.28, -1319.50, 13.40, 0.00, 0.00, 45.96);
    CreateDynamicObject(2358, 1409.21, -1318.79, 13.40, 0.00, 0.00, -8.94);
    CreateDynamicObject(2043, 1411.70, -1321.64, 14.26, 0.00, 90.00, 112.98);
    CreateDynamicObject(2043, 1411.10, -1321.55, 14.26, 0.00, 0.00, 73.32);
    CreateDynamicObject(2043, 1409.29, -1321.03, 14.26, 0.00, 0.00, 51.12);
    CreateDynamicObject(2040, 1409.67, -1321.36, 14.26, 0.00, 0.00, 135.78);
    CreateDynamicObject(3125, 1417.06, -1320.59, 13.99, 0.00, -70.00, -90.00);
    CreateDynamicObject(3125, 1417.06, -1320.48, 14.00, 0.00, 70.00, 90.00);
    CreateDynamicObject(19454, 1412.21, -1322.35, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19454, 1402.58, -1322.35, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1417.09, -1303.49, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1416.38, -1322.34, 14.89, 0.00, 0.00, 90.00);
    CreateDynamicObject(19377, 1411.77, -1307.68, 16.56, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1411.77, -1317.31, 16.56, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1401.27, -1317.31, 16.56, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1401.27, -1307.68, 16.56, 0.00, 90.00, 0.00);
    CreateDynamicObject(8650, 1401.92, -1322.02, 17.73, 0.00, 0.00, -90.00);
    CreateDynamicObject(8650, 1401.93, -1303.10, 17.73, 0.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1417.09, -1320.68, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1417.09, -1317.18, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1417.09, -1313.68, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1417.09, -1310.18, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1417.09, -1306.68, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(19435, 1417.08, -1304.44, 12.34, 90.00, 0.00, 0.00);
    CreateDynamicObject(14877, 1418.06, -1317.53, 11.12, 0.00, 0.00, 180.00);
    CreateDynamicObject(19435, 1415.28, -1322.35, 12.34, 90.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1411.78, -1322.35, 12.34, 90.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1408.28, -1322.35, 12.34, 90.00, 0.00, 90.00);
    CreateDynamicObject(19435, 1404.78, -1322.35, 12.34, 90.00, 0.00, 90.00);
    CreateDynamicObject(19377, 1411.77, -1317.45, 11.62, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1411.77, -1307.82, 11.62, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1401.27, -1317.45, 11.62, 0.00, 90.00, 0.00);
    CreateDynamicObject(19377, 1401.27, -1307.83, 11.62, 0.00, 90.00, 0.00);
    CreateDynamicObject(19359, 1410.70, -1305.57, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19432, 1410.71, -1303.84, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(19451, 1406.45, -1311.82, 14.89, 0.00, 0.00, 0.00);
    CreateDynamicObject(18092, 1413.51, -1308.64, 13.64, 0.00, 0.00, 90.00);
    CreateDynamicObject(346, 1413.11, -1308.11, 14.13, 89.10, -38.82, 157.38);
    CreateDynamicObject(347, 1412.97, -1309.29, 14.13, 89.10, -38.82, 103.62);
    CreateDynamicObject(348, 1413.13, -1310.70, 14.15, 89.10, -38.82, 165.60);
    CreateDynamicObject(18092, 1414.90, -1308.64, 13.64, 0.00, 0.00, 90.00);
    CreateDynamicObject(18092, 1416.29, -1308.64, 13.64, 0.00, 0.00, 90.00);
    CreateDynamicObject(349, 1413.99, -1310.79, 14.20, -96.30, 289.02, -93.78);
    CreateDynamicObject(351, 1416.47, -1310.89, 14.20, -96.30, 289.02, 87.72);
    CreateDynamicObject(1271, 1416.51, -1315.38, 13.52, 0.00, 0.00, 92.10);
    CreateDynamicObject(1271, 1416.51, -1315.38, 14.20, 0.00, 0.00, 92.10);
    CreateDynamicObject(1271, 1416.37, -1314.53, 13.52, 0.00, 0.00, 12.72);
    CreateDynamicObject(350, 1416.21, -1314.82, 13.86, 94.20, 486.84, 329.82);
    CreateDynamicObject(350, 1416.43, -1314.26, 13.86, 94.20, 486.84, 513.84);
    CreateDynamicObject(2311, 1415.99, -1321.00, 13.21, 0.00, 0.00, 196.38);
    CreateDynamicObject(2311, 1415.99, -1321.00, 13.69, 0.00, 0.00, 196.38);
    CreateDynamicObject(352, 1414.44, -1321.40, 14.19, 83.46, -80.22, 156.66);
    CreateDynamicObject(372, 1416.08, -1320.73, 14.19, 83.46, -80.22, -57.60);
    CreateDynamicObject(2358, 1414.67, -1321.35, 13.40, 0.00, 0.00, 214.86);
    CreateDynamicObject(2358, 1415.30, -1321.13, 13.40, 0.00, 0.00, 129.96);
    CreateDynamicObject(2358, 1415.90, -1320.90, 13.40, 0.00, 0.00, 246.24);
    CreateDynamicObject(2358, 1415.65, -1321.00, 13.87, 0.00, 0.00, 181.68);
    CreateDynamicObject(2049, 1406.57, -1310.95, 14.90, 0.00, 0.00, 90.00);
    CreateDynamicObject(2051, 1406.57, -1310.11, 14.54, 0.00, 10.00, 90.00);
    CreateDynamicObject(2055, 1406.57, -1311.19, 13.82, 0.00, -30.00, 90.00);
    CreateDynamicObject(2047, 1406.57, -1308.19, 15.14, 0.00, 10.00, 90.00);
    CreateDynamicObject(2048, 1408.60, -1315.15, 14.90, 0.00, 0.00, 90.00);
    CreateDynamicObject(2050, 1408.60, -1316.83, 15.02, 0.00, 50.00, 90.00);
    CreateDynamicObject(2056, 1408.60, -1317.43, 14.42, 0.00, 15.00, 90.00);
    CreateDynamicObject(3024, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3023, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3022, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3021, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3020, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3019, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3018, 1415.63, -1310.28, 17.95, 0.00, 0.00, 0.00);
    CreateDynamicObject(3024, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3023, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3022, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3021, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3020, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3019, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(3018, 1411.86, -1307.19, 17.13, 0.00, 0.00, 0.00);
    CreateDynamicObject(18647, 1404.95, -1302.69, 14.62, 90.00, 0.00, 0.00);
    CreateDynamicObject(18647, 1404.95, -1302.69, 12.63, 90.00, 0.00, 0.00);
    CreateDynamicObject(18647, 1403.39, -1302.69, 14.62, 90.00, 0.00, 0.00);
    CreateDynamicObject(18647, 1403.39, -1302.69, 12.70, 90.00, 0.00, 0.00);
    CreateDynamicObject(2068, 1412.98, -1316.03, 15.98, 0.00, 0.00, 0.00);
    CreateDynamicObject(1260, 1410.55, -1313.44, 29.26, 0.00, 0.00, -17.28);
    CreateDynamicObject(19377, 1409.09, -1302.43, 7.66, 0.00, 0.00, 90.00);

    AMSS_Textdraw[0] = TextDrawCreate(129.000000, 115.000000, "      ");
    TextDrawBackgroundColor(AMSS_Textdraw[0], 255);
    TextDrawFont(AMSS_Textdraw[0], 1);
    TextDrawLetterSize(AMSS_Textdraw[0], 0.500000, 1.000000);
    TextDrawColor(AMSS_Textdraw[0], -1);
    TextDrawSetOutline(AMSS_Textdraw[0], 0);
    TextDrawSetProportional(AMSS_Textdraw[0], 1);
    TextDrawSetShadow(AMSS_Textdraw[0], 1);
    TextDrawUseBox(AMSS_Textdraw[0], 1);
    TextDrawBoxColor(AMSS_Textdraw[0], 156);
    TextDrawTextSize(AMSS_Textdraw[0], 0.000000, 0.000000);

    AMSS_Textdraw[1] = TextDrawCreate(11.000000, 120.000000, "Use the button~r~ ENTER~w~~n~to look at this weapon");
    TextDrawBackgroundColor(AMSS_Textdraw[1], 255);
    TextDrawFont(AMSS_Textdraw[1], 2);
    TextDrawLetterSize(AMSS_Textdraw[1], 0.160000, 1.500000);
    TextDrawColor(AMSS_Textdraw[1], -1);
    TextDrawSetOutline(AMSS_Textdraw[1], 0);
    TextDrawSetProportional(AMSS_Textdraw[1], 1);
    TextDrawSetShadow(AMSS_Textdraw[1], 1);

    AMSS_Textdraw[2] = TextDrawCreate(551.000000, 141.000000, "                    ");
    TextDrawBackgroundColor(AMSS_Textdraw[2], 255);
    TextDrawFont(AMSS_Textdraw[2], 1);
    TextDrawLetterSize(AMSS_Textdraw[2], 0.500000, 1.000000);
    TextDrawColor(AMSS_Textdraw[2], -1);
    TextDrawSetOutline(AMSS_Textdraw[2], 0);
    TextDrawSetProportional(AMSS_Textdraw[2], 1);
    TextDrawSetShadow(AMSS_Textdraw[2], 1);
    TextDrawUseBox(AMSS_Textdraw[2], 1);
    TextDrawBoxColor(AMSS_Textdraw[2], 170);
    TextDrawTextSize(AMSS_Textdraw[2], 441.000000, 0.000000);

    AMSS_Textdraw[3] = TextDrawCreate(472.000000, 170.000000, "To buy");
    TextDrawBackgroundColor(AMSS_Textdraw[3], 255);
    TextDrawFont(AMSS_Textdraw[3], 1);
    TextDrawLetterSize(AMSS_Textdraw[3], 0.390000, 1.400000);
    TextDrawColor(AMSS_Textdraw[3], -1);
    TextDrawSetOutline(AMSS_Textdraw[3], 0);
    TextDrawSetProportional(AMSS_Textdraw[3], 1);
    TextDrawSetShadow(AMSS_Textdraw[3], 1);
    TextDrawUseBox(AMSS_Textdraw[3], 1);
    TextDrawBoxColor(AMSS_Textdraw[3], 255);
    TextDrawTextSize(AMSS_Textdraw[3], 516.000000, 20.000000);
    TextDrawSetSelectable(AMSS_Textdraw[3], true);

    AMSS_Textdraw[4] = TextDrawCreate(472.000000, 253.000000, " Abort");
    TextDrawBackgroundColor(AMSS_Textdraw[4], 255);
    TextDrawFont(AMSS_Textdraw[4], 1);
    TextDrawLetterSize(AMSS_Textdraw[4], 0.390000, 1.400000);
    TextDrawColor(AMSS_Textdraw[4], -1);
    TextDrawSetOutline(AMSS_Textdraw[4], 0);
    TextDrawSetProportional(AMSS_Textdraw[4], 1);
    TextDrawSetShadow(AMSS_Textdraw[4], 1);
    TextDrawUseBox(AMSS_Textdraw[4], 1);
    TextDrawBoxColor(AMSS_Textdraw[4], 255);
    TextDrawTextSize(AMSS_Textdraw[4], 516.000000, 20.000000);
    TextDrawSetSelectable(AMSS_Textdraw[4], true);

    AMSS_Textdraw[5] = TextDrawCreate(545.000000, 141.000000, ".");
    TextDrawBackgroundColor(AMSS_Textdraw[5], 255);
    TextDrawFont(AMSS_Textdraw[5], 1);
    TextDrawLetterSize(AMSS_Textdraw[5], -10.000000, 0.599999);
    TextDrawColor(AMSS_Textdraw[5], 16711935);
    TextDrawSetOutline(AMSS_Textdraw[5], 1);
    TextDrawSetProportional(AMSS_Textdraw[5], 1);

    AMSS_Textdraw[6] = TextDrawCreate(549.000000, 299.000000, ".");
    TextDrawBackgroundColor(AMSS_Textdraw[6], 255);
    TextDrawFont(AMSS_Textdraw[6], 1);
    TextDrawLetterSize(AMSS_Textdraw[6], -10.000000, 0.599999);
    TextDrawColor(AMSS_Textdraw[6], 16711935);
    TextDrawSetOutline(AMSS_Textdraw[6], 1);
    TextDrawSetProportional(AMSS_Textdraw[6], 0);

    AMSS_Textdraw[7] = TextDrawCreate(466.000000, 212.000000, "~>~IORP Ammunation~<~");
    TextDrawBackgroundColor(AMSS_Textdraw[7], 255);
    TextDrawFont(AMSS_Textdraw[7], 2);
    TextDrawLetterSize(AMSS_Textdraw[7], 0.129999, 1.000000);
    TextDrawColor(AMSS_Textdraw[7], 16711935);
    TextDrawSetOutline(AMSS_Textdraw[7], 1);
    TextDrawSetProportional(AMSS_Textdraw[7], 1);

    AMSS_Textdraw[8] = TextDrawCreate(565.000000, 315.000000, "    ");
    TextDrawBackgroundColor(AMSS_Textdraw[8], 255);
    TextDrawFont(AMSS_Textdraw[8], 1);
    TextDrawLetterSize(AMSS_Textdraw[8], 0.500000, 1.000000);
    TextDrawColor(AMSS_Textdraw[8], -1);
    TextDrawSetOutline(AMSS_Textdraw[8], 0);
    TextDrawSetProportional(AMSS_Textdraw[8], 1);
    TextDrawSetShadow(AMSS_Textdraw[8], 1);
    TextDrawUseBox(AMSS_Textdraw[8], 1);
    TextDrawBoxColor(AMSS_Textdraw[8], 170);
    TextDrawTextSize(AMSS_Textdraw[8], 429.000000, 121.000000);
    return 1;
}


hook OnGameModeExit() {
    new x = 0;
    for (; x < 8; x++) {
        TextDrawDestroy(AMSS_Textdraw[x]);
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    AMWeapSelect[playerid] = 0;
    AMSS_Price[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 323.000000, "~b~Price:~w~ 1000 $");
    PlayerTextDrawBackgroundColor(playerid, AMSS_Price[playerid], 255);
    PlayerTextDrawFont(playerid, AMSS_Price[playerid], 1);
    PlayerTextDrawLetterSize(playerid, AMSS_Price[playerid], 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, AMSS_Price[playerid], -1);
    PlayerTextDrawSetOutline(playerid, AMSS_Price[playerid], 0);
    PlayerTextDrawSetProportional(playerid, AMSS_Price[playerid], 1);
    PlayerTextDrawSetShadow(playerid, AMSS_Price[playerid], 1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    PlayerTextDrawDestroy(playerid, AMSS_Price[playerid]);
    return 1;
}

hook OnPlayerMapLoad(playerid) {
    RemoveBuildingForPlayer(playerid, 4711, 1392.1875, -1336.8047, 15.9844, 0.25);
    RemoveBuildingForPlayer(playerid, 1411, 1417.3125, -1321.3516, 14.1172, 0.25);
    RemoveBuildingForPlayer(playerid, 1411, 1417.3125, -1316.1016, 14.1172, 0.25);
    RemoveBuildingForPlayer(playerid, 1411, 1417.3125, -1310.8516, 14.1172, 0.25);
    RemoveBuildingForPlayer(playerid, 1411, 1417.3125, -1305.6016, 14.1172, 0.25);
    return 1;
}

stock AMSS_Show(playerid) {
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[2]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[3]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[4]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[5]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[6]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[7]);
    TextDrawShowForPlayer(playerid, AMSS_Textdraw[8]);
    PlayerTextDrawShow(playerid, AMSS_Price[playerid]);
    SelectTextDraw(playerid, 0xFF9600FF);
    GameTextForPlayer(playerid, "~w~Welcome~n~to~n~~r~IORP ~g~Ammunation", 1500, 3);
    return 1;
}
stock AMSS_Hide(playerid) {
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[2]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[3]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[4]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[5]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[6]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[7]);
    TextDrawHideForPlayer(playerid, AMSS_Textdraw[8]);
    PlayerTextDrawHide(playerid, AMSS_Price[playerid]);
    CancelSelectTextDraw(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == 16) {
        if (IsPlayerInRangeOfPoint(playerid, 1, 1412.4585, -1307.8866, 14.2059)) { // 9mm
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1412.6602, -1307.9674, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1413.6572, -1307.9955, 13.0456, CAMERA_MOVE);
            AMWeapSelect[playerid] = 1;
            AMSS_Show(playerid);
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_9MM);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1412.13, -1316.44, 14.07)) { // granaten
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1411.8259, -1316.7650, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1412.7979, -1316.5436, 12.8206, CAMERA_MOVE);
            AMWeapSelect[playerid] = 2;
            AMSS_Show(playerid);
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_GRANATEN);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1409.22, -1315.83, 13.70)) { // AK
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1409.5479, -1315.9816, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1408.5514, -1315.9559, 11.2556, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 3;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_AK);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1409.23, -1318.49, 13.70)) { //m4
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1409.6248, -1318.7303, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1408.6312, -1318.8138, 11.9156, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 4;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_M4);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1412.99, -1321.07, 14.17)) { // rpg
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1412.8986, -1320.7111, 15.2069);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1413.1106, -1321.6857, 13.1769, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 5;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_RPG);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1410.97, -1321.16, 14.16)) { // sniper
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1411.2620, -1320.8827, 15.2069);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1411.1959, -1321.8783, 13.1219, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 6;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_SNIPER);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1409.53, -1320.77, 14.14)) { // country rifle
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1410.0220, -1320.7468, 15.2069);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1409.3201, -1321.4567, 13.0269, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 7;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_COUNTRY);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1413.05, -1317.05, 13.92)) { // baseball
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1413.3904, -1317.0061, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1412.4858, -1316.5853, 12.3706, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 8;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_BASEBALL);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1412.03, -1315.55, 13.90)) { // mp5
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1412.1735, -1315.3153, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1412.1278, -1316.3119, 12.0856, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 9;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_MP5);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1413.05, -1315.57, 13.83)) { // messer
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1413.2974, -1315.5034, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1412.5745, -1316.1913, 7.1656, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 10;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_MESSER);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1412.16, -1317.49, 13.86)) { // molotov
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1411.9753, -1317.6621, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1412.5695, -1316.8610, 10.8706, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 11;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_MOLOTOV);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1412.97, -1309.29, 14.13)) { // silanced 9mm
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1412.6423, -1309.2140, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1413.6395, -1309.2222, 13.0356, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 12;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_SD9MM);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1413.13, -1310.70, 14.15)) { // deagle
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1412.6246, -1310.5668, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1413.6180, -1310.4795, 12.5656, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 13;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_DEAGLE);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1416.47, -1310.89, 14.20)) { // combat
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1416.1425, -1311.4272, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1416.1395, -1310.4296, 13.0756, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 14;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_COMBAT);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1416.21, -1314.82, 13.86)) { //  sawn off
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1415.7223, -1314.5798, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1416.7202, -1314.5867, 13.0206, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 15;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_SAWN);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1414.44, -1321.40, 14.19)) { // uzi
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1414.4873, -1320.9143, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1414.4150, -1321.9104, 12.5405, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 16;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_UZI);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1416.08, -1320.73, 14.19)) { //  tec-9
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1415.6978, -1320.6099, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1416.3220, -1321.3892, 12.0705, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 17;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_TEC9);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        } else if (IsPlayerInRangeOfPoint(playerid, 1, 1413.99, -1310.79, 14.20)) { //  shotgun
            TogglePlayerControllable(playerid, false);
            SetPlayerCameraPos(playerid, 1414.0562, -1311.0363, 15.2756);
            SetPlayerFacingAngle(playerid, 270.7324);
            SetPlayerCameraLookAt(playerid, 1414.5612, -1310.1750, 12.0555, CAMERA_MOVE);
            AMSS_Show(playerid);
            AMWeapSelect[playerid] = 18;
            new str1[50];
            format(str1, 50, "~b~Price:~w~%d", Price_SHOTGUN);
            PlayerTextDrawSetString(playerid, AMSS_Price[playerid], str1);
            return ~1;
        }
    }
    return 1;
}

// new AmmunationAllowedFaction[] = { 0, 1, 2, 3 };

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    if (clickedid == AMSS_Textdraw[3]) {
        if (!Faction:IsPlayerSigned(playerid)) {
            return AlexaMsg(playerid, "only faction members are allowed to purchase weapons from here");
        }

        switch (AMWeapSelect[playerid]) {
            case 1 :  {
                if (GetPlayerCash(playerid) >= Price_9MM) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~9MM ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 22, Ammo_9MM);
                    GivePlayerCash(playerid, -Price_9MM, "Ammunation: bought 9MM");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 2 :  {
                if (GetPlayerCash(playerid) >= Price_GRANATEN) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Granaten ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 16, Ammo_GRANATEN);
                    GivePlayerCash(playerid, -Price_GRANATEN, "Ammunation: bought GRANATEN");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 3 :  {
                if (GetPlayerCash(playerid) >= Price_AK) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~AK-47 ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 30, Ammo_AK);
                    GivePlayerCash(playerid, -Price_AK, "Ammunation: bought AK");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 4 :  {
                if (GetPlayerCash(playerid) >= Price_M4) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~M4 ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 31, Ammo_M4);
                    GivePlayerCash(playerid, -Price_M4, "Ammunation: bought M4");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 5 :  {
                if (GetPlayerCash(playerid) >= Price_RPG) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~RPG bought ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 35, Ammo_RPG);
                    GivePlayerCash(playerid, -Price_RPG, "Ammunation: bought RPG");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 6 :  {
                if (GetPlayerCash(playerid) >= Price_SNIPER) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Sniper Rifle ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 34, Ammo_SNIPER);
                    GivePlayerCash(playerid, -Price_SNIPER, "Ammunation: bought SNIPER");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 7 :  {
                if (GetPlayerCash(playerid) >= Price_COUNTRY) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Country Rifle ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 33, Ammo_COUNTRY);
                    GivePlayerCash(playerid, -Price_COUNTRY, "Ammunation: bought COUNTRY");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 8 :  {
                if (GetPlayerCash(playerid) >= Price_BASEBALL) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Baseball Bat ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 5, Ammo_BASEBALL);
                    GivePlayerCash(playerid, -Price_BASEBALL, "Ammunation: bought BASEBALL");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 9 :  {
                if (GetPlayerCash(playerid) >= Price_MP5) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~MP5 ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 29, Ammo_MP5);
                    GivePlayerCash(playerid, -Price_MP5, "Ammunation: bought MP5");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 10 :  {
                if (GetPlayerCash(playerid) >= Price_MESSER) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Messer ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 4, Ammo_MESSER);
                    GivePlayerCash(playerid, -Price_MESSER, "Ammunation: bought MESSER");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 11 :  {
                if (GetPlayerCash(playerid) >= Price_MOLOTOV) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Molotov Cocktail ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 18, Ammo_MOLOTOV);
                    GivePlayerCash(playerid, -Price_MOLOTOV, "Ammunation: bought MOLOTOV");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 12 :  {
                if (GetPlayerCash(playerid) >= Price_SD9MM) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Silenced 9mm ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 23, Ammo_SD9MM);
                    GivePlayerCash(playerid, -Price_SD9MM, "Ammunation: bought SD9MM");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 13 :  {
                if (GetPlayerCash(playerid) >= Price_DEAGLE) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Desert Eagle ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 24, Ammo_DEAGLE);
                    GivePlayerCash(playerid, -Price_DEAGLE, "Ammunation: bought DEAGLE");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 14 :  {
                if (GetPlayerCash(playerid) >= Price_COMBAT) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Combat Shotgun ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 27, Ammo_COMBAT);
                    GivePlayerCash(playerid, -Price_COMBAT, "Ammunation: bought COMBAT");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 15 :  {
                if (GetPlayerCash(playerid) >= Price_SAWN) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Sawn Off ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 26, Ammo_SAWN);
                    GivePlayerCash(playerid, -Price_SAWN, "Ammunation: bought SAWN");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 16 :  {
                if (GetPlayerCash(playerid) >= Price_UZI) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Uzi ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 28, Ammo_UZI);
                    GivePlayerCash(playerid, -Price_UZI, "Ammunation: bought UZI");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 17 :  {
                if (GetPlayerCash(playerid) >= Price_TEC9) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Tec-9 ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 32, Ammo_TEC9);
                    GivePlayerCash(playerid, -Price_TEC9, "Ammunation: bought TEC9");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
            case 18 :  {
                if (GetPlayerCash(playerid) >= Price_SHOTGUN) {
                    GameTextForPlayer(playerid, "~w~Weapon ~r~Shotgun ~g~bought", 1500, 3);
                    GivePlayerWeaponEx(playerid, 25, Ammo_SHOTGUN);
                    GivePlayerCash(playerid, -Price_SHOTGUN, "Ammunation: bought SHOTGUN");
                } else {
                    GameTextForPlayer(playerid, "~r~You don't have enough money", 1500, 3);
                }
            }
        }
    } else if (clickedid == AMSS_Textdraw[4]) {
        GameTextForPlayer(playerid, "~w~come ~r~soon", 1500, 3);
        AMSS_Hide(playerid);
        TogglePlayerControllable(playerid, true);
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}