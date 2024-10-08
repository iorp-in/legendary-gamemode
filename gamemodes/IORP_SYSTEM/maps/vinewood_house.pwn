hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 710, 1070.1094, -781.0703, 119.4219, 0.25);
    RemoveBuildingForPlayer(playerid, 710, 1064.5078, -805.0781, 107.2031, 0.25);
    RemoveBuildingForPlayer(playerid, 13855, 1100.7578, -825.1719, 103.4688, 0.25);
    RemoveBuildingForPlayer(playerid, 617, 1071.7344, -826.6719, 83.8047, 0.25);
    RemoveBuildingForPlayer(playerid, 656, 1062.6875, -818.6484, 84.9297, 0.25);
    RemoveBuildingForPlayer(playerid, 617, 1080.8125, -809.5781, 94.0547, 0.25);
    RemoveBuildingForPlayer(playerid, 13725, 1100.7578, -825.1719, 103.4688, 0.25);
    return 1;
}

hook OnGameModeInit() {
    //1098.1471 -812.8081 107.2248
    //1094.1322 -807.5092 107.2248
    new home;
    home = CreateDynamicObject(9131, 1098.95593, -829.77527, 107.54700, 0.00000, 0.00000, 8.88000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(9131, 1098.95593, -829.77533, 109.81310, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19379, 1095.28430, -819.58929, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "bathtile02_int", 0);
    home = CreateDynamicObject(19458, 1094.53979, -813.53717, 106.50900, 0.00000, 90.00000, 279.95981);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19378, 1105.57654, -817.89404, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19378, 1096.77979, -828.98761, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19378, 1107.11792, -827.34113, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19378, 1104.82190, -814.92511, 106.50500, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19458, 1113.99524, -826.25610, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19458, 1112.47546, -816.77173, 106.50900, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "flooringwd02_int", 0);
    home = CreateDynamicObject(19455, 1097.26086, -835.50684, 106.50900, 0.00000, 90.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0);
    home = CreateDynamicObject(19455, 1106.77026, -833.99896, 106.50900, 0.00000, 90.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0);
    home = CreateDynamicObject(19455, 1112.38306, -833.09821, 106.50600, 0.00000, 90.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0);
    home = CreateDynamicObject(19361, 1116.28064, -829.10229, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19361, 1115.78333, -825.94318, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19361, 1115.71130, -825.38611, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19361, 1114.49353, -816.60822, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19446, 1111.07935, -825.47363, 108.27627, 0.00000, 0.00000, -80.63998);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19446, 1106.81555, -819.96796, 108.27630, 0.00000, 0.00000, -4.14000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19446, 1109.33752, -814.81134, 108.27630, 0.00000, 0.00000, -81.04000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19361, 1114.00378, -813.46570, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19366, 1107.03711, -832.17291, 108.28390, 0.00000, 0.00000, 98.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19439, 1110.85779, -831.52289, 108.28390, -360.00000, 360.00000, 99.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19439, 1115.88000, -830.70117, 108.28390, -360.00000, 360.00000, 99.00000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19462, 1116.48328, -828.58429, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19462, 1114.44482, -816.38861, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19462, 1103.05542, -810.36243, 110.63400, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1091.40051, -829.43024, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19456, 1091.58423, -829.65759, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1115.92957, -825.88245, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(19462, 1093.59741, -811.84460, 108.27268, 0.00000, 0.00000, -81.00002);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1108.51257, -809.48132, 108.22610, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1114.05713, -813.40704, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1116.46326, -828.58429, 108.22610, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19462, 1089.52600, -817.29419, 108.27270, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19370, 1090.51001, -823.60022, 108.27270, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19370, 1090.99988, -826.74237, 108.27270, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19650, 1102.99707, -822.95660, 103.21110, 0.00000, 0.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "rooftiles1", 0);
    home = CreateDynamicObject(19458, 1089.52002, -817.29999, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1090.98999, -826.70648, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1091.89685, -832.49481, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1093.46375, -811.84882, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1102.94507, -810.35107, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1108.66321, -809.44952, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1114.08960, -813.41437, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1115.55530, -822.78790, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1116.49268, -828.64783, 104.75180, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1097.31274, -836.44360, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1106.80054, -834.94183, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19458, 1112.55774, -834.06555, 104.75180, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(18770, 1116.15320, -832.55579, 3.57380, 0.00000, 180.00000, 9.54000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "rooftiles1", 0);
    home = CreateDynamicObject(18770, 1093.40845, -836.02802, 3.57380, 0.00000, 180.00000, 9.54000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "rooftiles1", 0);
    home = CreateDynamicObject(18770, 1089.91614, -813.37738, 3.57380, 0.00000, 180.00000, 9.54000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "rooftiles1", 0);
    home = CreateDynamicObject(18770, 1112.57751, -809.89630, 3.57380, 0.00000, 180.00000, 10.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "rooftiles1", 0);
    home = CreateDynamicObject(19455, 1094.95947, -812.27362, 106.33430, 0.00000, 90.00000, 9.22000);
    SetDynamicObjectMaterial(home, 0, 13711, "mullho03_lahills", "des_flatlogs", 0);
    home = CreateDynamicObject(19455, 1094.70142, -812.31360, 106.33500, 0.00000, 90.00000, 9.22000);
    SetDynamicObjectMaterial(home, 0, 13711, "mullho03_lahills", "des_flatlogs", 0);
    home = CreateDynamicObject(19462, 1100.28296, -818.42792, 108.27207, 0.00000, 0.00000, 11.94000);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19462, 1092.03491, -820.53168, 108.27210, 0.00000, 0.00000, -10.80000);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19462, 1095.20801, -817.31427, 108.27210, 0.00000, 0.00000, -78.00000);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19370, 1096.72900, -823.99908, 108.33529, 0.00000, 0.00000, -78.66002);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19370, 1093.61646, -824.64069, 108.27210, 0.00000, 0.00000, -78.66000);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19370, 1092.26025, -824.92328, 108.27210, 0.00000, 0.00000, -78.66000);
    SetDynamicObjectMaterial(home, 0, 18031, "cj_exp", "mp_cloth_wall", 0x00000000);
    home = CreateDynamicObject(19458, 1113.97546, -826.19952, 110.09878, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19379, 1095.28430, -819.58929, 110.01000, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19458, 1094.53979, -813.53717, 110.09880, 0.00000, 90.00000, 279.95981);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19378, 1105.55420, -817.77606, 110.09880, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19378, 1096.72705, -828.93848, 110.09880, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19378, 1107.07043, -827.28796, 110.09880, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19378, 1104.82190, -814.92511, 110.03000, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19458, 1112.45740, -816.67334, 110.09880, 0.00000, 90.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 15059, "labigsave", "ah_wallstyle1", 0);
    home = CreateDynamicObject(19462, 1093.58496, -811.83142, 110.63400, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1102.97034, -810.33582, 110.63400, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1108.52734, -809.42200, 110.63400, 0.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1114.03711, -813.40698, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1115.53027, -822.83881, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1116.48328, -828.58429, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19360, 1092.40649, -835.67719, 108.27270, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "sjmlahus21", 0);
    home = CreateDynamicObject(19360, 1092.37061, -835.68323, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19462, 1089.92969, -819.97351, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19370, 1089.02173, -814.09802, 110.63400, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19650, 1102.99707, -822.95660, 112.60747, 0.00000, 0.00000, 9.00000);
    SetDynamicObjectMaterial(home, 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0);
    home = CreateDynamicObject(19443, 1114.97253, -830.84009, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1111.53711, -831.39008, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1108.10742, -831.94800, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1107.15637, -832.11377, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1114.97253, -830.82013, 111.58760, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1111.53711, -831.37012, 111.58760, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1108.10742, -831.92798, 111.58760, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1107.15637, -832.09381, 111.58760, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1103.69104, -832.63300, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1100.28589, -833.16852, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1096.84180, -833.71759, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1093.99438, -834.16632, 110.81700, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1093.99438, -834.14630, 111.59400, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1096.84180, -833.69757, 111.59400, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1100.28589, -833.14850, 111.59400, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19443, 1103.69104, -832.61298, 111.59400, 90.00000, 0.00000, -81.00000);
    SetDynamicObjectMaterial(home, 0, 3607, "bevmans01_la", "adeta", 0);
    home = CreateDynamicObject(19366, 1103.87292, -832.66638, 108.28390, 0.00000, 0.00000, 98.94000);
    SetDynamicObjectMaterial(home, 0, 14707, "labig3int2", "HS2_3Wall7", 0);
    home = CreateDynamicObject(2314, 1103.37097, -832.28503, 106.59200, 0.00000, 0.00000, 9.12000);
    SetDynamicObjectMaterial(home, 0, 10938, "skyscrap_sfse", "ws_skyscraperwin1", 0);
    CreateDynamicObject(2229, 1105.44739, -832.35236, 106.58480, 0.00000, 0.00000, -171.06006);
    CreateDynamicObject(2229, 1102.35791, -832.80768, 106.58480, 0.00000, 0.00000, -171.06006);
    home = CreateDynamicObject(19174, 1104.19177, -832.50421, 108.22421, 0.00000, 0.00000, 8.94000);
    SetDynamicObjectMaterial(home, 1, 10938, "skyscrap_sfse", "ws_skyscraperwin1", 0);
    CreateDynamicObject(1785, 1104.75537, -831.97821, 107.19330, 0.00000, 0.00000, 9.18000);
    CreateDynamicObject(2824, 1103.91150, -832.12164, 107.10100, 0.00000, 0.00000, 0.00000);
    home = CreateDynamicObject(19174, 1110.60168, -814.70178, 108.23161, 0.00000, 0.00000, 189.06001);
    SetDynamicObjectMaterial(home, 1, 10938, "skyscrap_sfse", "ws_skyscraperwin1", 0);
    CreateDynamicObject(2256, 1110.44226, -825.44629, 108.54298, 0.00000, 0.00000, 189.36020);
    CreateDynamicObject(1828, 1112.78735, -821.01819, 106.59690, 0.00000, 0.00000, 5.34000);
    CreateDynamicObject(638, 1114.41357, -818.83179, 107.24980, 0.00000, 0.00000, 8.51999);
    CreateDynamicObject(2310, 1095.68762, -820.71918, 107.06672, 0.00000, 0.00000, 99.36002);
    CreateDynamicObject(2310, 1096.57471, -820.54370, 107.06672, 0.00000, 0.00000, 99.36002);
    CreateDynamicObject(2310, 1096.77148, -822.05634, 107.06672, 0.00000, 0.00000, -79.97994);
    CreateDynamicObject(2289, 1096.21375, -823.94983, 108.65884, 0.00000, 0.00000, -168.72009);
    CreateDynamicObject(2284, 1094.69617, -823.81897, 108.30867, 0.00000, 0.00000, -167.94009);
    CreateDynamicObject(2251, 1096.13513, -821.36218, 108.09533, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(638, 1092.05823, -822.78650, 107.35774, 0.00000, 0.00000, -11.22000);
    CreateDynamicObject(1491, 1098.27893, -823.67798, 106.58440, 0.00000, 0.00000, 10.98000);
    CreateDynamicObject(1491, 1101.17175, -823.08160, 106.58440, 0.00000, 0.00000, 190.85989);
    CreateDynamicObject(2256, 1092.12720, -820.66809, 108.79665, 0.00000, 0.00000, 79.20001);
    CreateDynamicObject(2024, 1095.78784, -821.93262, 106.69158, 0.00000, 0.00000, 10.44000);
    CreateDynamicObject(2310, 1095.94238, -822.19391, 107.06672, 0.00000, 0.00000, -79.97994);
    CreateDynamicObject(2069, 1092.98340, -818.28833, 106.72081, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(638, 1092.57605, -820.17499, 107.35774, 0.00000, 0.00000, -11.22000);
    CreateDynamicObject(1734, 1094.10132, -823.08856, 110.05237, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1093.47607, -820.08679, 110.03977, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1097.46582, -822.33649, 110.11494, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1096.79712, -819.41388, 110.06260, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1661, 1095.42346, -821.43243, 109.60899, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19325, 1115.25708, -821.16455, 108.54467, 0.00000, 0.00000, 8.70002);
    CreateDynamicObject(1799, 1113.30310, -821.49518, 106.66240, 0.00000, 0.00000, 189.24001);
    CreateDynamicObject(1720, 1112.06470, -824.75922, 106.59270, 0.00000, 0.00000, -172.85989);
    CreateDynamicObject(2069, 1114.52930, -824.55518, 106.64810, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1742, 1106.61133, -822.20111, 106.60160, 0.00000, 0.00000, 85.92000);
    CreateDynamicObject(19462, 1094.69995, -814.77710, 108.31664, 0.00000, 0.00000, -78.00003);
    CreateDynamicObject(19370, 1091.89099, -813.76233, 108.15530, 0.00000, 0.00000, 9.96000);
    CreateDynamicObject(2267, 1094.01880, -814.80048, 108.77255, 0.00000, 0.00000, 191.58005);
    CreateDynamicObject(2283, 1096.52026, -814.27167, 108.76573, 0.00000, 0.00000, -167.87997);
    CreateDynamicObject(19439, 1101.67651, -816.01678, 108.33530, 0.00000, 0.00000, -81.18000);
    CreateDynamicObject(19439, 1100.65112, -816.17273, 108.33530, 0.00000, 0.00000, -81.18000);
    CreateDynamicObject(1649, 1102.96179, -815.86005, 110.74870, 0.00000, 0.00000, 9.84000);
    CreateDynamicObject(2069, 1092.70361, -814.78442, 106.79120, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1702, 1092.67383, -814.38708, 106.68900, 0.00000, 0.00000, 99.84000);
    CreateDynamicObject(19366, 1100.60596, -814.73047, 108.33530, 0.00000, 0.00000, 52.62000);
    CreateDynamicObject(19366, 1100.87537, -814.95746, 108.33530, 0.00000, 0.00000, 52.62000);
    CreateDynamicObject(2284, 1101.18896, -814.45715, 108.27934, 0.00000, 0.00000, 142.38004);
    CreateDynamicObject(1734, 1093.88452, -814.54657, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1649, 1102.96155, -815.77911, 110.74870, 0.00000, 0.00000, 187.80000);
    CreateDynamicObject(1734, 1103.05737, -815.37378, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1113.15283, -818.11041, 110.06255, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1112.80518, -822.87500, 110.06255, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1108.99243, -817.26074, 110.06255, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1108.69324, -822.53772, 110.06255, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1649, 1099.13464, -823.55981, 110.72470, 0.00000, 0.00000, 12.12000);
    CreateDynamicObject(1649, 1099.08887, -823.46002, 110.72470, 0.00000, 0.00000, 191.27980);
    CreateDynamicObject(1649, 1106.49915, -824.06537, 110.71810, 0.00000, 0.00000, 265.98013);
    CreateDynamicObject(1649, 1106.57922, -824.06561, 110.71810, 0.00000, 0.00000, 85.92000);
    CreateDynamicObject(3858, 1099.36633, -833.41577, 107.16180, -0.12000, 0.00000, 53.94000);
    CreateDynamicObject(638, 1097.07825, -824.45215, 107.22763, 0.00000, 0.00000, -78.12009);
    CreateDynamicObject(19443, 1101.97058, -822.95251, 108.33530, 0.00000, 0.00000, -80.88000);
    CreateDynamicObject(2256, 1102.27771, -817.70624, 108.79955, 0.00000, 0.00000, 97.14021);
    CreateDynamicObject(2267, 1102.64478, -820.71796, 108.76095, 0.00000, 0.00000, 96.36004);
    CreateDynamicObject(2254, 1105.52087, -815.55743, 108.60791, 0.00000, 0.00000, 10.02000);
    CreateDynamicObject(2261, 1105.96057, -823.69373, 108.11737, 0.00000, 0.00000, -94.14001);
    CreateDynamicObject(0, 1102.44189, -816.64490, 110.15590, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(0, 1103.12317, -822.10901, 110.15590, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1105.13086, -816.86401, 110.15588, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1105.76953, -821.61835, 110.15588, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19443, 1102.67639, -822.11603, 108.33530, 0.00000, 0.00000, 6.54000);
    CreateDynamicObject(19443, 1102.50012, -820.53717, 108.33530, 0.00000, 0.00000, 6.54000);
    CreateDynamicObject(19443, 1102.31921, -818.94708, 108.33530, 0.00000, 0.00000, 6.54000);
    CreateDynamicObject(19443, 1102.13647, -817.37500, 108.33530, 0.00000, 0.00000, 6.54000);
    CreateDynamicObject(19443, 1102.06372, -816.74908, 108.33530, 0.00000, 0.00000, 6.54000);
    CreateDynamicObject(1742, 1107.03174, -817.57758, 106.59200, 0.00000, 0.00000, 265.85989);
    CreateDynamicObject(2262, 1106.10925, -821.73950, 108.20730, 0.00000, 0.00000, -94.14000);
    CreateDynamicObject(2268, 1106.23279, -819.93518, 108.18742, 0.00000, 0.00000, -94.31998);
    CreateDynamicObject(1753, 1115.50867, -826.75739, 106.59150, 0.00000, 0.00000, -81.66000);
    CreateDynamicObject(2229, 1115.67126, -825.14447, 106.58480, 0.00000, 0.00000, -32.46001);
    CreateDynamicObject(2267, 1115.88306, -827.47437, 108.78741, 0.00000, 0.00000, -81.17999);
    CreateDynamicObject(1734, 1114.97449, -827.89142, 110.20708, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1104.25732, -829.57410, 110.13967, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1098.43762, -830.51819, 110.25021, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1109.63538, -828.72882, 110.18449, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(638, 1093.56116, -833.89966, 107.26150, 0.00000, 0.00000, -81.06010);
    CreateDynamicObject(2630, 1096.37781, -835.04767, 106.73290, 0.00000, 0.00000, 8.34000);
    CreateDynamicObject(2627, 1098.50574, -834.94958, 106.75990, 0.00000, 0.00000, -170.99998);
    CreateDynamicObject(2628, 1101.26477, -834.28009, 106.75330, 0.00000, 0.00000, 7.98000);
    CreateDynamicObject(1985, 1114.68799, -832.73035, 110.10596, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2256, 1107.12964, -832.02844, 108.79163, 0.00000, 0.00000, 188.81993);
    CreateDynamicObject(2269, 1096.98779, -824.56024, 108.39791, 0.00000, 0.00000, 11.88000);
    CreateDynamicObject(2282, 1102.13965, -823.50256, 108.30482, 0.00000, 0.00000, 9.12000);
    CreateDynamicObject(2024, 1113.73486, -827.57819, 106.60160, 0.00000, 0.00000, -80.88000);
    CreateDynamicObject(19172, 1107.10120, -832.26251, 108.49262, 0.00000, 0.00000, 9.24000);
    CreateDynamicObject(1255, 1093.55029, -835.43707, 107.28676, 0.00000, 0.00000, -55.74000);
    CreateDynamicObject(1255, 1094.96045, -835.22186, 107.28676, 0.00000, 0.00000, -55.74000);
    CreateDynamicObject(713, 1071.96240, -780.08875, 103.25539, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1670, 1114.48962, -827.96979, 107.15050, 0.00000, 0.00000, -64.80000);
    CreateDynamicObject(1550, 1115.48474, -826.08405, 106.91545, 0.00000, 0.00000, -95.93999);
    CreateDynamicObject(19325, 1101.41016, -810.59418, 108.20918, 0.00000, 0.00000, 98.99999);
    CreateDynamicObject(19370, 1096.75061, -824.11603, 108.33529, 0.00000, 0.00000, -78.66002);
    CreateDynamicObject(638, 1115.17468, -823.36780, 107.24980, 0.00000, 0.00000, 8.51999);
    CreateDynamicObject(1419, 1096.20789, -809.25055, 106.89523, 0.00000, 0.00000, -80.53999);
    CreateDynamicObject(1419, 1092.54968, -809.82941, 106.89523, 0.00000, 0.00000, -80.53999);
    CreateDynamicObject(1536, 1093.95593, -811.66809, 106.38945, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(1536, 1094.02588, -811.91852, 106.58950, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(19369, 1094.19604, -826.22455, 108.27270, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(1523, 1092.86548, -828.03284, 106.58440, 0.00000, 0.00000, 1449.25940);
    CreateDynamicObject(2526, 1091.54871, -825.74402, 106.65440, 0.00000, 0.00000, -80.94000);
    CreateDynamicObject(19369, 1091.11328, -826.66797, 108.27270, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(19442, 1092.10315, -828.10297, 108.27270, 0.00000, 0.00000, -80.52002);
    CreateDynamicObject(19369, 1095.84180, -825.92181, 108.27270, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(1734, 1094.92664, -826.00348, 110.25021, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1091.93054, -827.24023, 110.25021, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1093.37952, -825.08093, 110.25021, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19369, 1094.15710, -826.16815, 106.54900, 0.00000, 90.00000, 9.00000);
    CreateDynamicObject(19369, 1092.77869, -826.42682, 106.56900, 0.00000, 90.00000, 9.00000);
    CreateDynamicObject(1649, 1093.91760, -827.84497, 110.74470, 0.00000, 0.00000, 1449.25940);
    CreateDynamicObject(1649, 1093.90466, -827.79376, 110.72470, 0.00000, 0.00000, 1268.77771);
    CreateDynamicObject(19325, 1091.68604, -831.34119, 108.54467, 0.00000, 0.00000, -171.11998);
    CreateDynamicObject(19325, 1113.37781, -831.15979, 108.54467, 0.00000, 0.00000, -81.18001);
    CreateDynamicObject(1502, 1108.59155, -831.93945, 106.58440, 0.00000, 0.00000, 9.18000);
    CreateDynamicObject(1502, 1106.49707, -824.68274, 106.58440, 0.00000, 0.00000, -94.20000);
    CreateDynamicObject(1502, 1103.97534, -815.65009, 106.58440, 0.00000, 0.00000, -171.72000);
    CreateDynamicObject(1734, 1092.32153, -831.44672, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1097.60291, -825.68372, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1103.48035, -824.73260, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1093.46191, -812.39447, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1099.07275, -811.21918, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1099.55188, -813.40167, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1103.02185, -812.89172, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1734, 1102.76257, -810.65503, 110.25020, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11724, 1107.05969, -831.78705, 107.10982, 0.00000, 0.00000, -170.76004);
    CreateDynamicObject(11725, 1107.06128, -831.74097, 106.99376, 0.00000, 0.00000, 8.40000);
    CreateDynamicObject(11734, 1110.49426, -826.34204, 106.61349, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19173, 1112.69019, -825.32141, 108.78740, 0.00000, 0.00000, 9.12000);
    CreateDynamicObject(19174, 1108.61267, -825.98853, 108.60658, 0.00000, 0.00000, 9.30000);
    CreateDynamicObject(2244, 1106.55286, -826.50812, 106.87469, 0.00000, 0.00000, 9.00000);
    CreateDynamicObject(2244, 1114.64734, -825.17102, 106.87469, 0.00000, 0.00000, 9.00000);
    CreateDynamicObject(646, 1115.91553, -830.11346, 107.98222, 0.00000, 0.00000, 15.36000);
    CreateDynamicObject(646, 1107.48621, -815.40344, 107.98222, 0.00000, 0.00000, 75.90001);
    CreateDynamicObject(1419, 1115.33228, -834.38611, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1117.05261, -832.04291, 107.11560, 0.00000, 0.00000, -81.06000);
    CreateDynamicObject(1419, 1111.32275, -835.03180, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1107.30359, -835.67310, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1103.29163, -836.30322, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1099.26672, -836.93671, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1095.26404, -837.58838, 107.11561, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(1419, 1092.45630, -835.95703, 107.11560, 0.00000, 0.00000, -81.06000);
    CreateDynamicObject(644, 1093.10168, -837.66858, 106.81943, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1649, 1108.67505, -831.91437, 110.72470, 0.00000, 0.00000, 9.42000);
    CreateDynamicObject(1649, 1108.62708, -831.91425, 110.72470, 0.00000, 0.00000, -170.76001);
    CreateDynamicObject(19370, 1093.93970, -824.65900, 108.33529, 0.00000, 0.00000, -80.15999);
    CreateDynamicObject(19370, 1092.42883, -825.00037, 108.33529, 0.00000, 0.00000, -80.15999);
    CreateDynamicObject(2818, 1094.55176, -826.07715, 106.67770, 0.00000, 0.00000, -80.94000);
    CreateDynamicObject(2255, 1095.26807, -826.08337, 108.30480, 0.00000, 0.00000, -80.82000);
    CreateDynamicObject(2257, 1092.61877, -825.10583, 108.39591, 0.00000, 0.00000, 9.89999);
    CreateDynamicObject(1723, 1093.77405, -818.21307, 106.59410, 0.00000, 0.00000, 12.06000);
    CreateDynamicObject(2275, 1094.84680, -818.01471, 108.59425, 0.00000, 0.00000, 11.88000);
    CreateDynamicObject(2135, 1098.42737, -817.24097, 106.58850, 0.00000, 0.00000, 11.82000);
    CreateDynamicObject(2138, 1099.39941, -817.04523, 106.58850, 0.00000, 0.00000, 11.82000);
    CreateDynamicObject(2136, 1099.53137, -817.68109, 106.58850, 0.00000, 0.00000, -78.00001);
    CreateDynamicObject(2138, 1099.93835, -819.63477, 106.58850, 0.00000, 0.00000, -78.00000);
    CreateDynamicObject(2140, 1097.45825, -817.45532, 106.58850, 0.00000, 0.00000, 11.82000);
    CreateDynamicObject(2850, 1096.10632, -821.02771, 107.22410, 0.00000, 0.00000, -134.94003);
    CreateDynamicObject(19581, 1098.56982, -817.26233, 107.67790, 0.00000, 0.00000, -112.80000);
    CreateDynamicObject(11743, 1099.74915, -817.14246, 107.64240, 0.00000, 0.00000, -78.47997);
    CreateDynamicObject(11722, 1098.95935, -816.85620, 107.77697, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(11723, 1099.14734, -816.82867, 107.77700, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19586, 1099.72510, -817.78741, 107.65500, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2829, 1100.09790, -819.39600, 107.63070, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2001, 1100.31970, -820.39862, 106.56788, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2270, 1100.34106, -821.60126, 108.60655, 0.00000, 0.00000, -78.00003);
    CreateDynamicObject(2841, 1092.45557, -826.04779, 106.67090, 0.00000, 0.00000, -78.05999);
    CreateDynamicObject(1208, 1093.69482, -825.33533, 106.65195, 0.00000, 0.00000, 99.11997);
    CreateDynamicObject(2386, 1093.69751, -825.31506, 107.66580, 0.00000, 0.00000, 11.16000);
    CreateDynamicObject(2524, 1093.54919, -825.89264, 106.63960, 0.00000, 0.00000, -80.70000);
    CreateDynamicObject(2525, 1094.92114, -825.08008, 106.64320, 0.00000, 0.00000, 9.06000);
    CreateDynamicObject(11707, 1092.12158, -827.92542, 108.10709, 0.00000, 0.00000, -170.22005);
    CreateDynamicObject(19366, 1103.87292, -832.66638, 108.28390, 0.00000, 0.00000, 98.94000);
    CreateDynamicObject(1726, 1102.79175, -830.21527, 106.58905, 0.00000, 0.00000, 9.18000);
    CreateDynamicObject(1727, 1101.53772, -830.92975, 106.58910, 0.00000, 0.00000, 33.60000);
    CreateDynamicObject(1727, 1105.23438, -829.90460, 106.58910, 0.00000, 0.00000, -17.34000);
    CreateDynamicObject(2239, 1110.80237, -831.13031, 106.60550, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19439, 1104.74573, -815.51910, 108.33530, 0.00000, 0.00000, -78.72000);
    CreateDynamicObject(19563, 1099.90393, -817.78052, 107.64290, 0.00000, 0.00000, -80.16001);
    CreateDynamicObject(1523, 1094.48596, -827.76166, 106.58440, 0.00000, 0.00000, 1449.25940);
    CreateDynamicObject(2265, 1099.83411, -829.64410, 108.14505, 0.00000, 0.00000, 99.30000);
    CreateDynamicObject(2270, 1098.82019, -828.90082, 108.14510, 0.00000, 0.00000, -170.94003);
    CreateDynamicObject(2001, 1098.41345, -829.91724, 106.56033, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2562, 1107.39563, -820.21570, 106.58868, 0.00000, 0.00000, 85.61999);
    CreateDynamicObject(1671, 1108.10803, -819.26508, 107.01199, 0.00000, 0.00000, -73.20000);
    CreateDynamicObject(19893, 1107.33459, -818.69354, 107.41150, 0.00000, 0.00000, 60.96000);
    CreateDynamicObject(2828, 1107.32385, -817.63116, 107.43140, 0.00000, 0.00000, -127.80000);
    CreateDynamicObject(19458, 1115.55530, -822.78790, 104.75180, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(19458, 1114.38538, -817.31909, 104.85180, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(19458, 1114.52209, -817.28790, 104.85180, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(638, 1114.37756, -818.40479, 107.24980, 0.00000, 0.00000, 8.51999);
    CreateDynamicObject(2229, 1112.60706, -814.35046, 106.58480, 0.00000, 0.00000, -351.84012);
    CreateDynamicObject(2229, 1109.21179, -814.89563, 106.58480, 0.00000, 0.00000, -351.84012);
    CreateDynamicObject(2257, 1114.27893, -816.23114, 108.65668, 0.00000, 0.00000, -80.81998);
    CreateDynamicObject(2261, 1113.08484, -814.84747, 108.23069, 0.00000, 0.00000, 9.18000);
    CreateDynamicObject(19175, 1107.01685, -818.72241, 108.77110, 0.00000, 0.00000, 85.86000);
    CreateDynamicObject(19366, 1105.34949, -813.70654, 108.33530, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(19366, 1105.04700, -811.72729, 108.33530, 0.00000, 0.00000, 8.94000);
    CreateDynamicObject(2257, 1105.06274, -812.73254, 108.56799, 0.00000, 0.00000, -81.24001);
    CreateDynamicObject(638, 1104.74756, -812.76862, 107.24980, 0.00000, 0.00000, 8.51999);
    return 1;
}