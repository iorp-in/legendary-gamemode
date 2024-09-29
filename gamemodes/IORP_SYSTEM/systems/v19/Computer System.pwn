#define MAX_TDCOM 28
#define MAX_TDFB 29
#define MAX_COMPUTERS  2000
#define loopco for( new i = 0; i < MAX_COMPUTERS; i++ )
#define loopp  for( new i = 0; i < MAX_PLAYERS; i++ )
#define loopz  for( new i = 0; i < max_z; i++ )
#define COMPUTER_OBJECT 19903
#define zlX 105.500000
#define zlY 274.750122
#define disfcom 1.8
#define barrespeed 10.00
#define ballspeed 4.50
#define cofolder "computers/computer%d.ini"
#define plfolder "computers/users/%s.ini"
#define fbfolder "computers/like.facebook"
#define load2 "computers/users/verify.vf"
#define load "computers/verify.vf"
#define computercost 550
#define ENG 0
#define FRA 1
#define DAR 2
#define dkdk 1.2
#define dkdk2 -15.7
#define USED_tch 16
#define max_z 16
#define USED_lang          8
#define USED_winico        607
#define USED_fbd           41
#define USED_fonddec       18
#define USED_databarre     10
#define Computer_MAX_ZONE_NAME      32
#define USED_menu          25
#define USED_zmenu         13
#define USED_gzmenu        12
#define USED_pzmenu        7
#define USED_map           12
#define USED_music         54
#define USED_SuperBall     12
#define USED_pSuperBall    3
#define USED_onglet        18
#define USED_fbn           5
enum computer_sinfo { complete1, complete2, complete }
new DIALOG_COMPUTERHELP, DIALOG_PLIST, DIALOG_Sendm, DIALOG_RCONL, DIALOG_RNAMED, DIALOG_RNAMEE, DIALOG_RNAMEGG, DIALOG_RNAMEG;
enum textdraw { Text:computer_id, used }
enum computer_cinfo { Float:cX, Float:cY, Float:cZ, Float:cA0, Float:cA1, Float:cA, cObject, Locked, cOwner[24], test, cCreated }
enum computer_pinfo {
    timework,
    Computer_selected,
    maxp,
    showpl,
    plsfb,
    chat1[128],
    winicoshow,
    barreshow,
    fondecshow,
    menushow,
    zmenushow,
    gpzmenushow,
    Zombiesshow,
    langshow,
    ongletshow,
    mapshow,
    musicshow,
    SuperBallshow,
    kidrob,
    notifshow,
    playershow,
    hhealth,
    usemusic,
    musicpos,
    playh,
    pcount,
    phscore,
    Float:yX,
    Float:pbX,
    Float:pbY,
    Float:bX,
    Float:bY,
    Float:sound,
    Float:bspeed,
    Float:kY,
    Float:kspeed,
    Float:nX,
    Float:nY,
    bright,
    bleft,
    bnone,
    bup,
    bdown,
    bfog,
    bt7t,
    pright,
    pleft,
    pnone,
    pup,
    pdown,
    usecom,
    showm,
    like,
    sshowfb,
    sshower,
    haveone,
    Float:com_damage,
    headshot,
    zmoney,
    zbuy,
    zscore,
    lang,
    computer
}
new Text3D:computer_ctext[MAX_COMPUTERS], ScriptInfo[computer_sinfo];
enum computer_zoneinfo { computer_zone_name[Computer_MAX_ZONE_NAME], Float:zone_minx, Float:zone_miny, Float:zone_minz, Float:zone_maxx, Float:zone_maxy, Float:zone_maxz }
new computer_zones[][computer_zoneinfo] = {
    { "'The Big Ear'", -410.00, 1403.30, -3.00, -137.90, 1681.20, 200.00 },
    { "Aldea Malvada", -1372.10, 2498.50, 0.00, -1277.50, 2615.30, 200.00 },
    { "Angel Pine", -2324.90, -2584.20, -6.10, -1964.20, -2212.10, 200.00 },
    { "Arco del Oeste", -901.10, 2221.80, 0.00, -592.00, 2571.90, 200.00 },
    { "Avispa Country Club", -2646.40, -355.40, 0.00, -2270.00, -222.50, 200.00 },
    { "Avispa Country Club", -2831.80, -430.20, -6.10, -2646.40, -222.50, 200.00 },
    { "Avispa Country Club", -2361.50, -417.10, 0.00, -2270.00, -355.40, 200.00 },
    { "Avispa Country Club", -2667.80, -302.10, -28.80, -2646.40, -262.30, 71.10 },
    { "Avispa Country Club", -2470.00, -355.40, 0.00, -2270.00, -318.40, 46.10 },
    { "Avispa Country Club", -2550.00, -355.40, 0.00, -2470.00, -318.40, 39.70 },
    { "Back o Beyond", -1166.90, -2641.10, 0.00, -321.70, -1856.00, 200.00 },
    { "Battery Point", -2741.00, 1268.40, -4.50, -2533.00, 1490.40, 200.00 },
    { "Bayside", -2741.00, 2175.10, 0.00, -2353.10, 2722.70, 200.00 },
    { "Bayside Marina", -2353.10, 2275.70, 0.00, -2153.10, 2475.70, 200.00 },
    { "Beacon Hill", -399.60, -1075.50, -1.40, -319.00, -977.50, 198.50 },
    { "Blackfield", 964.30, 1203.20, -89.00, 1197.30, 1403.20, 110.90 },
    { "Blackfield", 964.30, 1403.20, -89.00, 1197.30, 1726.20, 110.90 },
    { "Blackfield Chapel", 1375.60, 596.30, -89.00, 1558.00, 823.20, 110.90 },
    { "Blackfield Chapel", 1325.60, 596.30, -89.00, 1375.60, 795.00, 110.90 },
    { "Blackfield Intersection", 1197.30, 1044.60, -89.00, 1277.00, 1163.30, 110.90 },
    { "Blackfield Intersection", 1166.50, 795.00, -89.00, 1375.60, 1044.60, 110.90 },
    { "Blackfield Intersection", 1277.00, 1044.60, -89.00, 1315.30, 1087.60, 110.90 },
    { "Blackfield Intersection", 1375.60, 823.20, -89.00, 1457.30, 919.40, 110.90 },
    { "Blueberry", 104.50, -220.10, 2.30, 349.60, 152.20, 200.00 },
    { "Blueberry", 19.60, -404.10, 3.80, 349.60, -220.10, 200.00 },
    { "Blueberry Acres", -319.60, -220.10, 0.00, 104.50, 293.30, 200.00 },
    { "Caligula's Palace", 2087.30, 1543.20, -89.00, 2437.30, 1703.20, 110.90 },
    { "Caligula's Palace", 2137.40, 1703.20, -89.00, 2437.30, 1783.20, 110.90 },
    { "Calton Heights", -2274.10, 744.10, -6.10, -1982.30, 1358.90, 200.00 },
    { "Chinatown", -2274.10, 578.30, -7.60, -2078.60, 744.10, 200.00 },
    { "City Hall", -2867.80, 277.40, -9.10, -2593.40, 458.40, 200.00 },
    { "Come-A-Lot", 2087.30, 943.20, -89.00, 2623.10, 1203.20, 110.90 },
    { "Commerce", 1323.90, -1842.20, -89.00, 1701.90, -1722.20, 110.90 },
    { "Commerce", 1323.90, -1722.20, -89.00, 1440.90, -1577.50, 110.90 },
    { "Commerce", 1370.80, -1577.50, -89.00, 1463.90, -1384.90, 110.90 },
    { "Commerce", 1463.90, -1577.50, -89.00, 1667.90, -1430.80, 110.90 },
    { "Commerce", 1583.50, -1722.20, -89.00, 1758.90, -1577.50, 110.90 },
    { "Commerce", 1667.90, -1577.50, -89.00, 1812.60, -1430.80, 110.90 },
    { "Conference Center", 1046.10, -1804.20, -89.00, 1323.90, -1722.20, 110.90 },
    { "Conference Center", 1073.20, -1842.20, -89.00, 1323.90, -1804.20, 110.90 },
    { "Cranberry Station", -2007.80, 56.30, 0.00, -1922.00, 224.70, 100.00 },
    { "Creek", 2749.90, 1937.20, -89.00, 2921.60, 2669.70, 110.90 },
    { "Dillimore", 580.70, -674.80, -9.50, 861.00, -404.70, 200.00 },
    { "Doherty", -2270.00, -324.10, -0.00, -1794.90, -222.50, 200.00 },
    { "Doherty", -2173.00, -222.50, -0.00, -1794.90, 265.20, 200.00 },
    { "Downtown", -1982.30, 744.10, -6.10, -1871.70, 1274.20, 200.00 },
    { "Downtown", -1871.70, 1176.40, -4.50, -1620.30, 1274.20, 200.00 },
    { "Downtown", -1700.00, 744.20, -6.10, -1580.00, 1176.50, 200.00 },
    { "Downtown", -1580.00, 744.20, -6.10, -1499.80, 1025.90, 200.00 },
    { "Downtown", -2078.60, 578.30, -7.60, -1499.80, 744.20, 200.00 },
    { "Downtown", -1993.20, 265.20, -9.10, -1794.90, 578.30, 200.00 },
    { "Downtown Los Santos", 1463.90, -1430.80, -89.00, 1724.70, -1290.80, 110.90 },
    { "Downtown Los Santos", 1724.70, -1430.80, -89.00, 1812.60, -1250.90, 110.90 },
    { "Downtown Los Santos", 1463.90, -1290.80, -89.00, 1724.70, -1150.80, 110.90 },
    { "Downtown Los Santos", 1370.80, -1384.90, -89.00, 1463.90, -1170.80, 110.90 },
    { "Downtown Los Santos", 1724.70, -1250.90, -89.00, 1812.60, -1150.80, 110.90 },
    { "Downtown Los Santos", 1370.80, -1170.80, -89.00, 1463.90, -1130.80, 110.90 },
    { "Downtown Los Santos", 1378.30, -1130.80, -89.00, 1463.90, -1026.30, 110.90 },
    { "Downtown Los Santos", 1391.00, -1026.30, -89.00, 1463.90, -926.90, 110.90 },
    { "Downtown Los Santos", 1507.50, -1385.20, 110.90, 1582.50, -1325.30, 335.90 },
    { "East Beach", 2632.80, -1852.80, -89.00, 2959.30, -1668.10, 110.90 },
    { "East Beach", 2632.80, -1668.10, -89.00, 2747.70, -1393.40, 110.90 },
    { "East Beach", 2747.70, -1668.10, -89.00, 2959.30, -1498.60, 110.90 },
    { "East Beach", 2747.70, -1498.60, -89.00, 2959.30, -1120.00, 110.90 },
    { "East Los Santos", 2421.00, -1628.50, -89.00, 2632.80, -1454.30, 110.90 },
    { "East Los Santos", 2222.50, -1628.50, -89.00, 2421.00, -1494.00, 110.90 },
    { "East Los Santos", 2266.20, -1494.00, -89.00, 2381.60, -1372.00, 110.90 },
    { "East Los Santos", 2381.60, -1494.00, -89.00, 2421.00, -1454.30, 110.90 },
    { "East Los Santos", 2281.40, -1372.00, -89.00, 2381.60, -1135.00, 110.90 },
    { "East Los Santos", 2381.60, -1454.30, -89.00, 2462.10, -1135.00, 110.90 },
    { "East Los Santos", 2462.10, -1454.30, -89.00, 2581.70, -1135.00, 110.90 },
    { "Easter Basin", -1794.90, 249.90, -9.10, -1242.90, 578.30, 200.00 },
    { "Easter Basin", -1794.90, -50.00, -0.00, -1499.80, 249.90, 200.00 },
    { "Easter Bay  Airport", -1499.80, -50.00, -0.00, -1242.90, 249.90, 200.00 },
    { "Easter Bay  Airport", -1794.90, -730.10, -3.00, -1213.90, -50.00, 200.00 },
    { "Easter Bay  Airport", -1213.90, -730.10, 0.00, -1132.80, -50.00, 200.00 },
    { "Easter Bay  Airport", -1242.90, -50.00, 0.00, -1213.90, 578.30, 200.00 },
    { "Easter Bay  Airport", -1213.90, -50.00, -4.50, -947.90, 578.30, 200.00 },
    { "Easter Bay  Airport", -1315.40, -405.30, 15.40, -1264.40, -209.50, 25.40 },
    { "Easter Bay  Airport", -1354.30, -287.30, 15.40, -1315.40, -209.50, 25.40 },
    { "Easter Bay  Airport", -1490.30, -209.50, 15.40, -1264.40, -148.30, 25.40 },
    { "Easter Bay  Chemicals", -1132.80, -768.00, 0.00, -956.40, -578.10, 200.00 },
    { "Easter Bay  Chemicals", -1132.80, -787.30, 0.00, -956.40, -768.00, 200.00 },
    { "El Castillo del Diablo", -464.50, 2217.60, 0.00, -208.50, 2580.30, 200.00 },
    { "El Castillo del Diablo", -208.50, 2123.00, -7.60, 114.00, 2337.10, 200.00 },
    { "El Castillo del Diablo", -208.50, 2337.10, 0.00, 8.40, 2487.10, 200.00 },
    { "El Corona", 1812.60, -2179.20, -89.00, 1970.60, -1852.80, 110.90 },
    { "El Corona", 1692.60, -2179.20, -89.00, 1812.60, -1842.20, 110.90 },
    { "El Quebrados", -1645.20, 2498.50, 0.00, -1372.10, 2777.80, 200.00 },
    { "Esplanade East", -1620.30, 1176.50, -4.50, -1580.00, 1274.20, 200.00 },
    { "Esplanade East", -1580.00, 1025.90, -6.10, -1499.80, 1274.20, 200.00 },
    { "Esplanade East", -1499.80, 578.30, -79.60, -1339.80, 1274.20, 20.30 },
    { "Esplanade North", -2533.00, 1358.90, -4.50, -1996.60, 1501.20, 200.00 },
    { "Esplanade North", -1996.60, 1358.90, -4.50, -1524.20, 1592.50, 200.00 },
    { "Esplanade North", -1982.30, 1274.20, -4.50, -1524.20, 1358.90, 200.00 },
    { "Fallen Tree", -792.20, -698.50, -5.30, -452.40, -380.00, 200.00 },
    { "Fallow Bridge", 434.30, 366.50, 0.00, 603.00, 555.60, 200.00 },
    { "Fern Ridge", 508.10, -139.20, 0.00, 1306.60, 119.50, 200.00 },
    { "Financial", -1871.70, 744.10, -6.10, -1701.30, 1176.40, 300.00 },
    { "Fisher's Lagoon", 1916.90, -233.30, -100.00, 2131.70, 13.80, 200.00 },
    { "Flint Intersection", -187.70, -1596.70, -89.00, 17.00, -1276.60, 110.90 },
    { "Flint Range", -594.10, -1648.50, 0.00, -187.70, -1276.60, 200.00 },
    { "Fort Carson", -376.20, 826.30, -3.00, 123.70, 1220.40, 200.00 },
    { "Foster Valley", -2270.00, -430.20, -0.00, -2178.60, -324.10, 200.00 },
    { "Foster Valley", -2178.60, -599.80, -0.00, -1794.90, -324.10, 200.00 },
    { "Foster Valley", -2178.60, -1115.50, 0.00, -1794.90, -599.80, 200.00 },
    { "Foster Valley", -2178.60, -1250.90, 0.00, -1794.90, -1115.50, 200.00 },
    { "Frederick Bridge", 2759.20, 296.50, 0.00, 2774.20, 594.70, 200.00 },
    { "Gant Bridge", -2741.40, 1659.60, -6.10, -2616.40, 2175.10, 200.00 },
    { "Gant Bridge", -2741.00, 1490.40, -6.10, -2616.40, 1659.60, 200.00 },
    { "Ganton", 2222.50, -1852.80, -89.00, 2632.80, -1722.30, 110.90 },
    { "Ganton", 2222.50, -1722.30, -89.00, 2632.80, -1628.50, 110.90 },
    { "Garcia", -2411.20, -222.50, -0.00, -2173.00, 265.20, 200.00 },
    { "Garcia", -2395.10, -222.50, -5.30, -2354.00, -204.70, 200.00 },
    { "Garver Bridge", -1339.80, 828.10, -89.00, -1213.90, 1057.00, 110.90 },
    { "Garver Bridge", -1213.90, 950.00, -89.00, -1087.90, 1178.90, 110.90 },
    { "Garver Bridge", -1499.80, 696.40, -179.60, -1339.80, 925.30, 20.30 },
    { "Glen Park", 1812.60, -1449.60, -89.00, 1996.90, -1350.70, 110.90 },
    { "Glen Park", 1812.60, -1100.80, -89.00, 1994.30, -973.30, 110.90 },
    { "Glen Park", 1812.60, -1350.70, -89.00, 2056.80, -1100.80, 110.90 },
    { "Green Palms", 176.50, 1305.40, -3.00, 338.60, 1520.70, 200.00 },
    { "Greenglass College", 964.30, 1044.60, -89.00, 1197.30, 1203.20, 110.90 },
    { "Greenglass College", 964.30, 930.80, -89.00, 1166.50, 1044.60, 110.90 },
    { "Hampton Barns", 603.00, 264.30, 0.00, 761.90, 366.50, 200.00 },
    { "Hankypanky Point", 2576.90, 62.10, 0.00, 2759.20, 385.50, 200.00 },
    { "Harry Gold Parkway", 1777.30, 863.20, -89.00, 1817.30, 2342.80, 110.90 },
    { "Hashbury", -2593.40, -222.50, -0.00, -2411.20, 54.70, 200.00 },
    { "Hilltop Farm", 967.30, -450.30, -3.00, 1176.70, -217.90, 200.00 },
    { "Hunter Quarry", 337.20, 710.80, -115.20, 860.50, 1031.70, 203.70 },
    { "Idlewood", 1812.60, -1852.80, -89.00, 1971.60, -1742.30, 110.90 },
    { "Idlewood", 1812.60, -1742.30, -89.00, 1951.60, -1602.30, 110.90 },
    { "Idlewood", 1951.60, -1742.30, -89.00, 2124.60, -1602.30, 110.90 },
    { "Idlewood", 1812.60, -1602.30, -89.00, 2124.60, -1449.60, 110.90 },
    { "Idlewood", 2124.60, -1742.30, -89.00, 2222.50, -1494.00, 110.90 },
    { "Idlewood", 1971.60, -1852.80, -89.00, 2222.50, -1742.30, 110.90 },
    { "Jefferson", 1996.90, -1449.60, -89.00, 2056.80, -1350.70, 110.90 },
    { "Jefferson", 2124.60, -1494.00, -89.00, 2266.20, -1449.60, 110.90 },
    { "Jefferson", 2056.80, -1372.00, -89.00, 2281.40, -1210.70, 110.90 },
    { "Jefferson", 2056.80, -1210.70, -89.00, 2185.30, -1126.30, 110.90 },
    { "Jefferson", 2185.30, -1210.70, -89.00, 2281.40, -1154.50, 110.90 },
    { "Jefferson", 2056.80, -1449.60, -89.00, 2266.20, -1372.00, 110.90 },
    { "Julius Thruway East", 2623.10, 943.20, -89.00, 2749.90, 1055.90, 110.90 },
    { "Julius Thruway East", 2685.10, 1055.90, -89.00, 2749.90, 2626.50, 110.90 },
    { "Julius Thruway East", 2536.40, 2442.50, -89.00, 2685.10, 2542.50, 110.90 },
    { "Julius Thruway East", 2625.10, 2202.70, -89.00, 2685.10, 2442.50, 110.90 },
    { "Julius Thruway North", 2498.20, 2542.50, -89.00, 2685.10, 2626.50, 110.90 },
    { "Julius Thruway North", 2237.40, 2542.50, -89.00, 2498.20, 2663.10, 110.90 },
    { "Julius Thruway North", 2121.40, 2508.20, -89.00, 2237.40, 2663.10, 110.90 },
    { "Julius Thruway North", 1938.80, 2508.20, -89.00, 2121.40, 2624.20, 110.90 },
    { "Julius Thruway North", 1534.50, 2433.20, -89.00, 1848.40, 2583.20, 110.90 },
    { "Julius Thruway North", 1848.40, 2478.40, -89.00, 1938.80, 2553.40, 110.90 },
    { "Julius Thruway North", 1704.50, 2342.80, -89.00, 1848.40, 2433.20, 110.90 },
    { "Julius Thruway North", 1377.30, 2433.20, -89.00, 1534.50, 2507.20, 110.90 },
    { "Julius Thruway South", 1457.30, 823.20, -89.00, 2377.30, 863.20, 110.90 },
    { "Julius Thruway South", 2377.30, 788.80, -89.00, 2537.30, 897.90, 110.90 },
    { "Julius Thruway West", 1197.30, 1163.30, -89.00, 1236.60, 2243.20, 110.90 },
    { "Julius Thruway West", 1236.60, 2142.80, -89.00, 1297.40, 2243.20, 110.90 },
    { "Juniper Hill", -2533.00, 578.30, -7.60, -2274.10, 968.30, 200.00 },
    { "Juniper Hollow", -2533.00, 968.30, -6.10, -2274.10, 1358.90, 200.00 },
    { "K.A.C.C. MilitaryFuels", 2498.20, 2626.50, -89.00, 2749.90, 2861.50, 110.90 },
    { "Kincaid Bridge", -1339.80, 599.20, -89.00, -1213.90, 828.10, 110.90 },
    { "Kincaid Bridge", -1213.90, 721.10, -89.00, -1087.90, 950.00, 110.90 },
    { "Kincaid Bridge", -1087.90, 855.30, -89.00, -961.90, 986.20, 110.90 },
    { "King's", -2329.30, 458.40, -7.60, -1993.20, 578.30, 200.00 },
    { "King's", -2411.20, 265.20, -9.10, -1993.20, 373.50, 200.00 },
    { "King's", -2253.50, 373.50, -9.10, -1993.20, 458.40, 200.00 },
    { "LVA Freight Depot", 1457.30, 863.20, -89.00, 1777.40, 1143.20, 110.90 },
    { "LVA Freight Depot", 1375.60, 919.40, -89.00, 1457.30, 1203.20, 110.90 },
    { "LVA Freight Depot", 1277.00, 1087.60, -89.00, 1375.60, 1203.20, 110.90 },
    { "LVA Freight Depot", 1315.30, 1044.60, -89.00, 1375.60, 1087.60, 110.90 },
    { "LVA Freight Depot", 1236.60, 1163.40, -89.00, 1277.00, 1203.20, 110.90 },
    { "Las Barrancas", -926.10, 1398.70, -3.00, -719.20, 1634.60, 200.00 },
    { "Las Brujas", -365.10, 2123.00, -3.00, -208.50, 2217.60, 200.00 },
    { "Las Colinas", 1994.30, -1100.80, -89.00, 2056.80, -920.80, 110.90 },
    { "Las Colinas", 2056.80, -1126.30, -89.00, 2126.80, -920.80, 110.90 },
    { "Las Colinas", 2185.30, -1154.50, -89.00, 2281.40, -934.40, 110.90 },
    { "Las Colinas", 2126.80, -1126.30, -89.00, 2185.30, -934.40, 110.90 },
    { "Las Colinas", 2747.70, -1120.00, -89.00, 2959.30, -945.00, 110.90 },
    { "Las Colinas", 2632.70, -1135.00, -89.00, 2747.70, -945.00, 110.90 },
    { "Las Colinas", 2281.40, -1135.00, -89.00, 2632.70, -945.00, 110.90 },
    { "Las Payasadas", -354.30, 2580.30, 2.00, -133.60, 2816.80, 200.00 },
    { "Las VenturasAirport", 1236.60, 1203.20, -89.00, 1457.30, 1883.10, 110.90 },
    { "Las VenturasAirport", 1457.30, 1203.20, -89.00, 1777.30, 1883.10, 110.90 },
    { "Las VenturasAirport", 1457.30, 1143.20, -89.00, 1777.40, 1203.20, 110.90 },
    { "Las VenturasAirport", 1515.80, 1586.40, -12.50, 1729.90, 1714.50, 87.50 },
    { "Last Dime Motel", 1823.00, 596.30, -89.00, 1997.20, 823.20, 110.90 },
    { "Leafy Hollow", -1166.90, -1856.00, 0.00, -815.60, -1602.00, 200.00 },
    { "Lil' Probe Inn", -90.20, 1286.80, -3.00, 153.80, 1554.10, 200.00 },
    { "Linden Side", 2749.90, 943.20, -89.00, 2923.30, 1198.90, 110.90 },
    { "Linden Station", 2749.90, 1198.90, -89.00, 2923.30, 1548.90, 110.90 },
    { "Linden Station", 2811.20, 1229.50, -39.50, 2861.20, 1407.50, 60.40 },
    { "Little Mexico", 1701.90, -1842.20, -89.00, 1812.60, -1722.20, 110.90 },
    { "Little Mexico", 1758.90, -1722.20, -89.00, 1812.60, -1577.50, 110.90 },
    { "Los Flores", 2581.70, -1454.30, -89.00, 2632.80, -1393.40, 110.90 },
    { "Los Flores", 2581.70, -1393.40, -89.00, 2747.70, -1135.00, 110.90 },
    { "Los SantosInternational", 1249.60, -2394.30, -89.00, 1852.00, -2179.20, 110.90 },
    { "Los SantosInternational", 1852.00, -2394.30, -89.00, 2089.00, -2179.20, 110.90 },
    { "Los SantosInternational", 1382.70, -2730.80, -89.00, 2201.80, -2394.30, 110.90 },
    { "Los SantosInternational", 1974.60, -2394.30, -39.00, 2089.00, -2256.50, 60.90 },
    { "Los SantosInternational", 1400.90, -2669.20, -39.00, 2189.80, -2597.20, 60.90 },
    { "Los SantosInternational", 2051.60, -2597.20, -39.00, 2152.40, -2394.30, 60.90 },
    { "Marina", 647.70, -1804.20, -89.00, 851.40, -1577.50, 110.90 },
    { "Marina", 647.70, -1577.50, -89.00, 807.90, -1416.20, 110.90 },
    { "Marina", 807.90, -1577.50, -89.00, 926.90, -1416.20, 110.90 },
    { "Market", 787.40, -1416.20, -89.00, 1072.60, -1310.20, 110.90 },
    { "Market", 952.60, -1310.20, -89.00, 1072.60, -1130.80, 110.90 },
    { "Market", 1072.60, -1416.20, -89.00, 1370.80, -1130.80, 110.90 },
    { "Market", 926.90, -1577.50, -89.00, 1370.80, -1416.20, 110.90 },
    { "Market Station", 787.40, -1410.90, -34.10, 866.00, -1310.20, 65.80 },
    { "Martin Bridge", -222.10, 293.30, 0.00, -122.10, 476.40, 200.00 },
    { "Missionary Hill", -2994.40, -811.20, 0.00, -2178.60, -430.20, 200.00 },
    { "Montgomery", 1119.50, 119.50, -3.00, 1451.40, 493.30, 200.00 },
    { "Montgomery", 1451.40, 347.40, -6.10, 1582.40, 420.80, 200.00 },
    { "Montgomery Intersection", 1546.60, 208.10, 0.00, 1745.80, 347.40, 200.00 },
    { "Montgomery Intersection", 1582.40, 347.40, 0.00, 1664.60, 401.70, 200.00 },
    { "Mulholland", 1414.00, -768.00, -89.00, 1667.60, -452.40, 110.90 },
    { "Mulholland", 1281.10, -452.40, -89.00, 1641.10, -290.90, 110.90 },
    { "Mulholland", 1269.10, -768.00, -89.00, 1414.00, -452.40, 110.90 },
    { "Mulholland", 1357.00, -926.90, -89.00, 1463.90, -768.00, 110.90 },
    { "Mulholland", 1318.10, -910.10, -89.00, 1357.00, -768.00, 110.90 },
    { "Mulholland", 1169.10, -910.10, -89.00, 1318.10, -768.00, 110.90 },
    { "Mulholland", 768.60, -954.60, -89.00, 952.60, -860.60, 110.90 },
    { "Mulholland", 687.80, -860.60, -89.00, 911.80, -768.00, 110.90 },
    { "Mulholland", 737.50, -768.00, -89.00, 1142.20, -674.80, 110.90 },
    { "Mulholland", 1096.40, -910.10, -89.00, 1169.10, -768.00, 110.90 },
    { "Mulholland", 952.60, -937.10, -89.00, 1096.40, -860.60, 110.90 },
    { "Mulholland", 911.80, -860.60, -89.00, 1096.40, -768.00, 110.90 },
    { "Mulholland", 861.00, -674.80, -89.00, 1156.50, -600.80, 110.90 },
    { "Mulholland Intersection", 1463.90, -1150.80, -89.00, 1812.60, -768.00, 110.90 },
    { "North Rock", 2285.30, -768.00, 0.00, 2770.50, -269.70, 200.00 },
    { "Ocean Docks", 2373.70, -2697.00, -89.00, 2809.20, -2330.40, 110.90 },
    { "Ocean Docks", 2201.80, -2418.30, -89.00, 2324.00, -2095.00, 110.90 },
    { "Ocean Docks", 2324.00, -2302.30, -89.00, 2703.50, -2145.10, 110.90 },
    { "Ocean Docks", 2089.00, -2394.30, -89.00, 2201.80, -2235.80, 110.90 },
    { "Ocean Docks", 2201.80, -2730.80, -89.00, 2324.00, -2418.30, 110.90 },
    { "Ocean Docks", 2703.50, -2302.30, -89.00, 2959.30, -2126.90, 110.90 },
    { "Ocean Docks", 2324.00, -2145.10, -89.00, 2703.50, -2059.20, 110.90 },
    { "Ocean Flats", -2994.40, 277.40, -9.10, -2867.80, 458.40, 200.00 },
    { "Ocean Flats", -2994.40, -222.50, -0.00, -2593.40, 277.40, 200.00 },
    { "Ocean Flats", -2994.40, -430.20, -0.00, -2831.80, -222.50, 200.00 },
    { "Octane Springs", 338.60, 1228.50, 0.00, 664.30, 1655.00, 200.00 },
    { "Old Venturas Strip", 2162.30, 2012.10, -89.00, 2685.10, 2202.70, 110.90 },
    { "Palisades", -2994.40, 458.40, -6.10, -2741.00, 1339.60, 200.00 },
    { "Palomino Creek", 2160.20, -149.00, 0.00, 2576.90, 228.30, 200.00 },
    { "Paradiso", -2741.00, 793.40, -6.10, -2533.00, 1268.40, 200.00 },
    { "Pershing Square", 1440.90, -1722.20, -89.00, 1583.50, -1577.50, 110.90 },
    { "Pilgrim", 2437.30, 1383.20, -89.00, 2624.40, 1783.20, 110.90 },
    { "Pilgrim", 2624.40, 1383.20, -89.00, 2685.10, 1783.20, 110.90 },
    { "Pilson Intersection", 1098.30, 2243.20, -89.00, 1377.30, 2507.20, 110.90 },
    { "Pirates in Men's Pants", 1817.30, 1469.20, -89.00, 2027.40, 1703.20, 110.90 },
    { "Playa del Seville", 2703.50, -2126.90, -89.00, 2959.30, -1852.80, 110.90 },
    { "Prickle Pine", 1534.50, 2583.20, -89.00, 1848.40, 2863.20, 110.90 },
    { "Prickle Pine", 1117.40, 2507.20, -89.00, 1534.50, 2723.20, 110.90 },
    { "Prickle Pine", 1848.40, 2553.40, -89.00, 1938.80, 2863.20, 110.90 },
    { "Prickle Pine", 1938.80, 2624.20, -89.00, 2121.40, 2861.50, 110.90 },
    { "Queens", -2533.00, 458.40, 0.00, -2329.30, 578.30, 200.00 },
    { "Queens", -2593.40, 54.70, 0.00, -2411.20, 458.40, 200.00 },
    { "Queens", -2411.20, 373.50, 0.00, -2253.50, 458.40, 200.00 },
    { "Randolph IndustrialEstate", 1558.00, 596.30, -89.00, 1823.00, 823.20, 110.90 },
    { "Redsands East", 1817.30, 2011.80, -89.00, 2106.70, 2202.70, 110.90 },
    { "Redsands East", 1817.30, 2202.70, -89.00, 2011.90, 2342.80, 110.90 },
    { "Redsands East", 1848.40, 2342.80, -89.00, 2011.90, 2478.40, 110.90 },
    { "Redsands West", 1236.60, 1883.10, -89.00, 1777.30, 2142.80, 110.90 },
    { "Redsands West", 1297.40, 2142.80, -89.00, 1777.30, 2243.20, 110.90 },
    { "Redsands West", 1377.30, 2243.20, -89.00, 1704.50, 2433.20, 110.90 },
    { "Redsands West", 1704.50, 2243.20, -89.00, 1777.30, 2342.80, 110.90 },
    { "Regular Tom", -405.70, 1712.80, -3.00, -276.70, 1892.70, 200.00 },
    { "Richman", 647.50, -1118.20, -89.00, 787.40, -954.60, 110.90 },
    { "Richman", 647.50, -954.60, -89.00, 768.60, -860.60, 110.90 },
    { "Richman", 225.10, -1369.60, -89.00, 334.50, -1292.00, 110.90 },
    { "Richman", 225.10, -1292.00, -89.00, 466.20, -1235.00, 110.90 },
    { "Richman", 72.60, -1404.90, -89.00, 225.10, -1235.00, 110.90 },
    { "Richman", 72.60, -1235.00, -89.00, 321.30, -1008.10, 110.90 },
    { "Richman", 321.30, -1235.00, -89.00, 647.50, -1044.00, 110.90 },
    { "Richman", 321.30, -1044.00, -89.00, 647.50, -860.60, 110.90 },
    { "Richman", 321.30, -860.60, -89.00, 687.80, -768.00, 110.90 },
    { "Richman", 321.30, -768.00, -89.00, 700.70, -674.80, 110.90 },
    { "Robada Intersection", -1119.00, 1178.90, -89.00, -862.00, 1351.40, 110.90 },
    { "Roca Escalante", 2237.40, 2202.70, -89.00, 2536.40, 2542.50, 110.90 },
    { "Roca Escalante", 2536.40, 2202.70, -89.00, 2625.10, 2442.50, 110.90 },
    { "Rockshore East", 2537.30, 676.50, -89.00, 2902.30, 943.20, 110.90 },
    { "Rockshore West", 1997.20, 596.30, -89.00, 2377.30, 823.20, 110.90 },
    { "Rockshore West", 2377.30, 596.30, -89.00, 2537.30, 788.80, 110.90 },
    { "Rodeo", 72.60, -1684.60, -89.00, 225.10, -1544.10, 110.90 },
    { "Rodeo", 72.60, -1544.10, -89.00, 225.10, -1404.90, 110.90 },
    { "Rodeo", 225.10, -1684.60, -89.00, 312.80, -1501.90, 110.90 },
    { "Rodeo", 225.10, -1501.90, -89.00, 334.50, -1369.60, 110.90 },
    { "Rodeo", 334.50, -1501.90, -89.00, 422.60, -1406.00, 110.90 },
    { "Rodeo", 312.80, -1684.60, -89.00, 422.60, -1501.90, 110.90 },
    { "Rodeo", 422.60, -1684.60, -89.00, 558.00, -1570.20, 110.90 },
    { "Rodeo", 558.00, -1684.60, -89.00, 647.50, -1384.90, 110.90 },
    { "Rodeo", 466.20, -1570.20, -89.00, 558.00, -1385.00, 110.90 },
    { "Rodeo", 422.60, -1570.20, -89.00, 466.20, -1406.00, 110.90 },
    { "Rodeo", 466.20, -1385.00, -89.00, 647.50, -1235.00, 110.90 },
    { "Rodeo", 334.50, -1406.00, -89.00, 466.20, -1292.00, 110.90 },
    { "Royal Casino", 2087.30, 1383.20, -89.00, 2437.30, 1543.20, 110.90 },
    { "San Andreas Sound", 2450.30, 385.50, -100.00, 2759.20, 562.30, 200.00 },
    { "Santa Flora", -2741.00, 458.40, -7.60, -2533.00, 793.40, 200.00 },
    { "Santa Maria Beach", 342.60, -2173.20, -89.00, 647.70, -1684.60, 110.90 },
    { "Santa Maria Beach", 72.60, -2173.20, -89.00, 342.60, -1684.60, 110.90 },
    { "Shady Cabin", -1632.80, -2263.40, -3.00, -1601.30, -2231.70, 200.00 },
    { "Shady Creeks", -1820.60, -2643.60, -8.00, -1226.70, -1771.60, 200.00 },
    { "Shady Creeks", -2030.10, -2174.80, -6.10, -1820.60, -1771.60, 200.00 },
    { "Sobell Rail Yards", 2749.90, 1548.90, -89.00, 2923.30, 1937.20, 110.90 },
    { "Spinybed", 2121.40, 2663.10, -89.00, 2498.20, 2861.50, 110.90 },
    { "Starfish Casino", 2437.30, 1783.20, -89.00, 2685.10, 2012.10, 110.90 },
    { "Starfish Casino", 2437.30, 1858.10, -39.00, 2495.00, 1970.80, 60.90 },
    { "Starfish Casino", 2162.30, 1883.20, -89.00, 2437.30, 2012.10, 110.90 },
    { "Temple", 1252.30, -1130.80, -89.00, 1378.30, -1026.30, 110.90 },
    { "Temple", 1252.30, -1026.30, -89.00, 1391.00, -926.90, 110.90 },
    { "Temple", 1252.30, -926.90, -89.00, 1357.00, -910.10, 110.90 },
    { "Temple", 952.60, -1130.80, -89.00, 1096.40, -937.10, 110.90 },
    { "Temple", 1096.40, -1130.80, -89.00, 1252.30, -1026.30, 110.90 },
    { "Temple", 1096.40, -1026.30, -89.00, 1252.30, -910.10, 110.90 },
    { "The Camel's Toe", 2087.30, 1203.20, -89.00, 2640.40, 1383.20, 110.90 },
    { "The Clown's Pocket", 2162.30, 1783.20, -89.00, 2437.30, 1883.20, 110.90 },
    { "The Emerald Isle", 2011.90, 2202.70, -89.00, 2237.40, 2508.20, 110.90 },
    { "The Farm", -1209.60, -1317.10, 114.90, -908.10, -787.30, 251.90 },
    { "The Four Dragons Casino", 1817.30, 863.20, -89.00, 2027.30, 1083.20, 110.90 },
    { "The High Roller", 1817.30, 1283.20, -89.00, 2027.30, 1469.20, 110.90 },
    { "The Mako Span", 1664.60, 401.70, 0.00, 1785.10, 567.20, 200.00 },
    { "The Panopticon", -947.90, -304.30, -1.10, -319.60, 327.00, 200.00 },
    { "The Pink Swan", 1817.30, 1083.20, -89.00, 2027.30, 1283.20, 110.90 },
    { "The Sherman Dam", -968.70, 1929.40, -3.00, -481.10, 2155.20, 200.00 },
    { "The Strip", 2027.40, 863.20, -89.00, 2087.30, 1703.20, 110.90 },
    { "The Strip", 2106.70, 1863.20, -89.00, 2162.30, 2202.70, 110.90 },
    { "The Strip", 2027.40, 1783.20, -89.00, 2162.30, 1863.20, 110.90 },
    { "The Strip", 2027.40, 1703.20, -89.00, 2137.40, 1783.20, 110.90 },
    { "The Visage", 1817.30, 1863.20, -89.00, 2106.70, 2011.80, 110.90 },
    { "The Visage", 1817.30, 1703.20, -89.00, 2027.40, 1863.20, 110.90 },
    { "Unity Station", 1692.60, -1971.80, -20.40, 1812.60, -1932.80, 79.50 },
    { "Valle Ocultado", -936.60, 2611.40, 2.00, -715.90, 2847.90, 200.00 },
    { "Verdant Bluffs", 930.20, -2488.40, -89.00, 1249.60, -2006.70, 110.90 },
    { "Verdant Bluffs", 1073.20, -2006.70, -89.00, 1249.60, -1842.20, 110.90 },
    { "Verdant Bluffs", 1249.60, -2179.20, -89.00, 1692.60, -1842.20, 110.90 },
    { "Verdant Meadows", 37.00, 2337.10, -3.00, 435.90, 2677.90, 200.00 },
    { "Verona Beach", 647.70, -2173.20, -89.00, 930.20, -1804.20, 110.90 },
    { "Verona Beach", 930.20, -2006.70, -89.00, 1073.20, -1804.20, 110.90 },
    { "Verona Beach", 851.40, -1804.20, -89.00, 1046.10, -1577.50, 110.90 },
    { "Verona Beach", 1161.50, -1722.20, -89.00, 1323.90, -1577.50, 110.90 },
    { "Verona Beach", 1046.10, -1722.20, -89.00, 1161.50, -1577.50, 110.90 },
    { "Vinewood", 787.40, -1310.20, -89.00, 952.60, -1130.80, 110.90 },
    { "Vinewood", 787.40, -1130.80, -89.00, 952.60, -954.60, 110.90 },
    { "Vinewood", 647.50, -1227.20, -89.00, 787.40, -1118.20, 110.90 },
    { "Vinewood", 647.70, -1416.20, -89.00, 787.40, -1227.20, 110.90 },
    { "Whitewood Estates", 883.30, 1726.20, -89.00, 1098.30, 2507.20, 110.90 },
    { "Whitewood Estates", 1098.30, 1726.20, -89.00, 1197.30, 2243.20, 110.90 },
    { "Willowfield", 1970.60, -2179.20, -89.00, 2089.00, -1852.80, 110.90 },
    { "Willowfield", 2089.00, -2235.80, -89.00, 2201.80, -1989.90, 110.90 },
    { "Willowfield", 2089.00, -1989.90, -89.00, 2324.00, -1852.80, 110.90 },
    { "Willowfield", 2201.80, -2095.00, -89.00, 2324.00, -1989.90, 110.90 },
    { "Willowfield", 2541.70, -1941.40, -89.00, 2703.50, -1852.80, 110.90 },
    { "Willowfield", 2324.00, -2059.20, -89.00, 2541.70, -1852.80, 110.90 },
    { "Willowfield", 2541.70, -2059.20, -89.00, 2703.50, -1941.40, 110.90 },
    { "Yellow Bell Station", 1377.40, 2600.40, -21.90, 1492.40, 2687.30, 78.00 },
    // Main Zones
    { "Los Santos", 44.60, -2892.90, -242.90, 2997.00, -768.00, 900.00 },
    { "Las Venturas", 869.40, 596.30, -242.90, 2997.00, 2993.80, 900.00 },
    { "Bone County", -480.50, 596.30, -242.90, 869.40, 2993.80, 900.00 },
    { "Tierra Robada", -2997.40, 1659.60, -242.90, -480.50, 2993.80, 900.00 },
    { "Tierra Robada", -1213.90, 596.30, -242.90, -480.50, 1659.60, 900.00 },
    { "San Fierro", -2997.40, -1115.50, -242.90, -1213.90, 1659.60, 900.00 },
    { "Red County", -1213.90, -768.00, -242.90, 2997.00, 596.30, 900.00 },
    { "Flint County", -1213.90, -2892.90, -242.90, 44.60, -768.00, 900.00 },
    { "Whetstone", -2997.40, -2892.90, -242.90, -1213.90, -1115.50, 900.00 }
};
stock Computer_ReturnPlayerZone(playerid) {
    new playerzone[256] = "Desconocida";
    for (new j; j < sizeof(computer_zones); j++) {
        if(Computer_IsPlayerInZone(playerid, j)) {
            memcpy(playerzone, computer_zones[j][computer_zone_name], 0, 108);
            break;
        }
    }
    return playerzone;
}
stock Computer_IsPlayerInZone(playerid, zoneid) {
    if(zoneid == -1) return false;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(x >= computer_zones[zoneid][zone_minx] && x < computer_zones[zoneid][zone_maxx] && y >= computer_zones[zoneid][zone_miny] && y < computer_zones[zoneid][zone_maxy] && z >= computer_zones[zoneid][zone_minz] && z < computer_zones[zoneid][zone_maxz] && z < 900.0) return true;
    return false;
}
// Text Draws //
new Text:winico[USED_winico][textdraw];
new Text:fonddec[USED_fonddec];
new Text:loadwin[3];
new Text:barre;
new Text:tdhealth[3];
new Text:boxlang;
new Text:boxlike;
#define usedhg 15
#define usedhgg 13
new Text:Zombiesg[usedhg];


new PlayerText:databarre[USED_databarre];
new PlayerText:map2;
new PlayerText:explo2;
new PlayerText:fronl;
new PlayerText:tdchange[USED_tch];
new PlayerText:numlike;
new PlayerText:Zombiesgg[usedhgg];

enum zzz {
    showed,
    created,
    Float:Health,
    Float:Speed,
    Float:zX,
    Float:zY
}

new PlayerText:pZombie[max_z];
new PlayerText:hZombie[max_z][3];
new Zinfo[MAX_PLAYERS][max_z][zzz];

new PlayerText:rightleft[2];
new PlayerText:yajora[15];
new PlayerText:tdscore;
new PlayerText:fbname;
new PlayerText:pbarr[USED_pSuperBall];
new PlayerText:pball;
new PlayerText:musicsp;
new PlayerText:pzmenu[USED_pzmenu];

new Text:onglet[USED_onglet];
new Text:fbdata[USED_fbd];
new Text:menu[USED_menu];
new Text:zmenu[USED_zmenu];
new Text:gzmenu[USED_gzmenu];
new Text:tdlang[USED_lang];
new Text:music[USED_music];
new Text:fbnotif[USED_fbn];
new Text:SuperBall[USED_SuperBall];
new Text:map[USED_map];
///////////////

enum yinfo {
    Float:yjX,
    destroyed
}
// Infos //
new ComputerInfo[MAX_COMPUTERS][computer_cinfo];
new PlayerInfo[MAX_PLAYERS][computer_pinfo];
new Yjinfo[MAX_PLAYERS][15][yinfo];

new Time[MAX_PLAYERS];
new Time2[MAX_PLAYERS];
new fblike;
//////////

stock Computer_GetPlayerZone(playerid) {
    new string[256];
    format(string, sizeof(string), "%s", Computer_ReturnPlayerZone(playerid));
    PlayerTextDrawSetString(playerid, map2, string);
    return 1;
}

hook OnGameModeInit() {
    DIALOG_COMPUTERHELP = Dialog:GetFreeID();
    DIALOG_PLIST = Dialog:GetFreeID();
    DIALOG_Sendm = Dialog:GetFreeID();
    DIALOG_RCONL = Dialog:GetFreeID();
    DIALOG_RNAMED = Dialog:GetFreeID();
    DIALOG_RNAMEE = Dialog:GetFreeID();
    DIALOG_RNAMEGG = Dialog:GetFreeID();
    DIALOG_RNAMEG = Dialog:GetFreeID();
    if(!fexist(load)) dini_Create(load);
    if(!fexist(load2)) dini_Create(load2);
    if(!fexist(fbfolder)) dini_Create(fbfolder), fblike = 0, dini_IntSet(fbfolder, "likes", fblike);
    else fblike = dini_Int(fbfolder, "likes");

    if(fexist(load)) ScriptInfo[complete1] = true;
    else return ScriptInfo[complete1] = false, print("\n--------------------------------------"), print(" Computer System By IORP missing folder scriptfiles/computers"), print("--------------------------------------\n");
    if(fexist(load2)) ScriptInfo[complete2] = true;
    else return ScriptInfo[complete2] = false, print("\n--------------------------------------"), print(" Computer System By IORP missing folder scriptfiles/computers/users"), print("--------------------------------------\n");

    if(ScriptInfo[complete2] && ScriptInfo[complete1]) ScriptInfo[complete] = true;
    if(ScriptInfo[complete]) {
        ScriptInfo[complete] = true;
        loadcomputers();

        // barre doutil
        barre = TextDrawCreate(-10.500000, 391.999877, "ld_otb2:butnA");
        TextDrawLetterSize(barre, 0.000000, 0.000000);
        TextDrawTextSize(barre, 662.500000, 42.583293);
        TextDrawAlignment(barre, 1);
        TextDrawColor(barre, 10551295);
        TextDrawSetShadow(barre, 0);
        TextDrawSetOutline(barre, 0);
        TextDrawFont(barre, 4);
        // fonddec
        fonddec[0] = TextDrawCreate(0.000000, 0.000000, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[0], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[0], 19.000000, 448.000000);
        TextDrawAlignment(fonddec[0], 1);
        TextDrawColor(fonddec[0], 255);
        TextDrawSetShadow(fonddec[0], 0);
        TextDrawSetOutline(fonddec[0], 0);
        TextDrawFont(fonddec[0], 4);
        fonddec[1] = TextDrawCreate(0.000000, 423.500030, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[1], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[1], 640.000000, 26.250000);
        TextDrawAlignment(fonddec[1], 1);
        TextDrawColor(fonddec[1], 255);
        TextDrawSetShadow(fonddec[1], 0);
        TextDrawSetOutline(fonddec[1], 0);
        TextDrawFont(fonddec[1], 4);
        fonddec[2] = TextDrawCreate(19.000000, 0.000000, "load0uk:load0uk");
        TextDrawLetterSize(fonddec[2], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[2], 621.000000, 393.166687);
        TextDrawAlignment(fonddec[2], 1);
        TextDrawColor(fonddec[2], 16727807);
        TextDrawSetShadow(fonddec[2], 0);
        TextDrawSetOutline(fonddec[2], 0);
        TextDrawFont(fonddec[2], 4);
        fonddec[3] = TextDrawCreate(56.000000, 289.916687, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[3], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[3], 544.000000, 71.750000);
        TextDrawAlignment(fonddec[3], 1);
        TextDrawColor(fonddec[3], 255);
        TextDrawSetShadow(fonddec[3], 0);
        TextDrawSetOutline(fonddec[3], 0);
        TextDrawFont(fonddec[3], 4);
        fonddec[4] = TextDrawCreate(490.000000, 208.833343, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[4], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[4], 10.000000, 8.750000);
        TextDrawAlignment(fonddec[4], 1);
        TextDrawColor(fonddec[4], 255);
        TextDrawSetShadow(fonddec[4], 0);
        TextDrawSetOutline(fonddec[4], 0);
        TextDrawFont(fonddec[4], 4);
        fonddec[5] = TextDrawCreate(523.500000, 383.250091, "(c) 2019 by IORP");
        TextDrawLetterSize(fonddec[5], 0.320000, 0.812499);
        TextDrawAlignment(fonddec[5], 1);
        TextDrawColor(fonddec[5], 10027263);
        TextDrawSetShadow(fonddec[5], 0);
        TextDrawSetOutline(fonddec[5], 0);
        TextDrawBackgroundColor(fonddec[5], 51);
        TextDrawFont(fonddec[5], 1);
        TextDrawSetProportional(fonddec[5], 1);
        fonddec[6] = TextDrawCreate(215.500000, 237.416778, "Computer");
        TextDrawLetterSize(fonddec[6], 1.868500, 9.148324);
        TextDrawAlignment(fonddec[6], 1);
        TextDrawColor(fonddec[6], 10551551);
        TextDrawSetShadow(fonddec[6], 0);
        TextDrawSetOutline(fonddec[6], 1);
        TextDrawBackgroundColor(fonddec[6], 16465151);
        TextDrawFont(fonddec[6], 0);
        TextDrawSetProportional(fonddec[6], 1);
        fonddec[7] = TextDrawCreate(218.500000, 242.500076, "Computer");
        TextDrawLetterSize(fonddec[7], 1.691498, 8.314159);
        TextDrawAlignment(fonddec[7], 1);
        TextDrawColor(fonddec[7], 16721919);
        TextDrawSetShadow(fonddec[7], 0);
        TextDrawSetOutline(fonddec[7], 2);
        TextDrawBackgroundColor(fonddec[7], 255);
        TextDrawFont(fonddec[7], 0);
        TextDrawSetProportional(fonddec[7], 1);
        fonddec[8] = TextDrawCreate(327.000000, 315.583343, "System");
        TextDrawLetterSize(fonddec[8], 0.576500, 1.751667);
        TextDrawAlignment(fonddec[8], 1);
        TextDrawColor(fonddec[8], -1);
        TextDrawSetShadow(fonddec[8], 0);
        TextDrawSetOutline(fonddec[8], 1);
        TextDrawBackgroundColor(fonddec[8], 51);
        TextDrawFont(fonddec[8], 2);
        TextDrawSetProportional(fonddec[8], 1);
        fonddec[9] = TextDrawCreate(273.000000, 245.416641, "MultiPlayter");
        TextDrawLetterSize(fonddec[9], 0.319000, 1.378333);
        TextDrawAlignment(fonddec[9], 1);
        TextDrawColor(fonddec[9], 255);
        TextDrawSetShadow(fonddec[9], 0);
        TextDrawSetOutline(fonddec[9], 1);
        TextDrawBackgroundColor(fonddec[9], 16727295);
        TextDrawFont(fonddec[9], 2);
        TextDrawSetProportional(fonddec[9], 1);
        fonddec[10] = TextDrawCreate(615.000000, 2.916720, "hud:arrow");
        TextDrawLetterSize(fonddec[10], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[10], 24.500000, 26.833318);
        TextDrawAlignment(fonddec[10], 1);
        TextDrawColor(fonddec[10], -1);
        TextDrawSetShadow(fonddec[10], 0);
        TextDrawSetOutline(fonddec[10], 0);
        TextDrawFont(fonddec[10], 4);
        TextDrawSetSelectable(fonddec[10], true);
        fonddec[11] = TextDrawCreate(615.000000, 61.083320, "hud:radar_dateDisco");
        TextDrawLetterSize(fonddec[11], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[11], 24.500000, 26.833318);
        TextDrawAlignment(fonddec[11], 1);
        TextDrawColor(fonddec[11], -1);
        TextDrawSetShadow(fonddec[11], 0);
        TextDrawSetOutline(fonddec[11], 0);
        TextDrawFont(fonddec[11], 4);
        TextDrawSetSelectable(fonddec[11], true);
        fonddec[12] = TextDrawCreate(617.500000, 113.999816, "ld_pool:ball");
        TextDrawLetterSize(fonddec[12], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[12], 19.000000, 21.583314);
        TextDrawAlignment(fonddec[12], 1);
        TextDrawColor(fonddec[12], 16711935);
        TextDrawSetShadow(fonddec[12], 0);
        TextDrawSetOutline(fonddec[12], 0);
        TextDrawFont(fonddec[12], 4);
        TextDrawSetSelectable(fonddec[12], true);
        fonddec[13] = TextDrawCreate(617.000000, 165.666687, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[13], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[13], 22.000000, 23.333345);
        TextDrawAlignment(fonddec[13], 1);
        TextDrawColor(fonddec[13], 1900543);
        TextDrawSetShadow(fonddec[13], 0);
        TextDrawSetOutline(fonddec[13], 0);
        TextDrawFont(fonddec[13], 4);
        fonddec[14] = TextDrawCreate(628.000000, 166.833419, "f");
        TextDrawLetterSize(fonddec[14], 0.602000, 2.480834);
        TextDrawAlignment(fonddec[14], 1);
        TextDrawColor(fonddec[14], -1);
        TextDrawSetShadow(fonddec[14], 0);
        TextDrawSetOutline(fonddec[14], 1);
        TextDrawBackgroundColor(fonddec[14], 51);
        TextDrawFont(fonddec[14], 1);
        TextDrawSetProportional(fonddec[14], 1);
        fonddec[15] = TextDrawCreate(617.000000, 165.666656, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[15], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[15], 23.000000, 23.916687);
        TextDrawAlignment(fonddec[15], 1);
        TextDrawColor(fonddec[15], 65280);
        TextDrawSetShadow(fonddec[15], 0);
        TextDrawSetOutline(fonddec[15], 0);
        TextDrawFont(fonddec[15], 4);
        TextDrawSetSelectable(fonddec[15], true);
        fonddec[16] = TextDrawCreate(640.000000, 214.083374, "hud:radar_emmetGun");
        TextDrawLetterSize(fonddec[16], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[16], -25.500000, 28.583332);
        TextDrawAlignment(fonddec[16], 1);
        TextDrawColor(fonddec[16], -1);
        TextDrawSetShadow(fonddec[16], 0);
        TextDrawSetOutline(fonddec[16], 0);
        TextDrawFont(fonddec[16], 4);
        TextDrawSetSelectable(fonddec[16], true);
        fonddec[17] = TextDrawCreate(615.500000, 215.250000, "LD_SPAC:white");
        TextDrawLetterSize(fonddec[17], 0.000000, 0.000000);
        TextDrawTextSize(fonddec[17], 24.500000, 26.250000);
        TextDrawAlignment(fonddec[17], 1);
        TextDrawColor(fonddec[17], -1523963372);
        TextDrawSetShadow(fonddec[17], 0);
        TextDrawSetOutline(fonddec[17], 0);
        TextDrawFont(fonddec[17], 4);
        TextDrawSetSelectable(fonddec[17], true);

        boxlang = TextDrawCreate(563.500000, 394.333343, "LD_SPAC:white");
        TextDrawLetterSize(boxlang, 0.000000, 0.000000);
        TextDrawTextSize(boxlang, 23.500000, 28.583312);
        TextDrawAlignment(boxlang, 1);
        TextDrawColor(boxlang, -256);
        TextDrawSetShadow(boxlang, 0);
        TextDrawSetOutline(boxlang, 0);
        TextDrawFont(boxlang, 4);
        TextDrawSetSelectable(boxlang, true);
        boxlike = TextDrawCreate(336.000000, 286.416656, "LD_SPAC:white");
        TextDrawLetterSize(boxlike, 0.000000, 0.000000);
        TextDrawTextSize(boxlike, 22.500000, 12.833312);
        TextDrawAlignment(boxlike, 1);
        TextDrawColor(boxlike, 16776960);
        TextDrawSetShadow(boxlike, 0);
        TextDrawSetOutline(boxlike, 0);
        TextDrawFont(boxlike, 4);
        TextDrawSetSelectable(boxlike, true);

        // windows icon
        winico[0][computer_id] = TextDrawCreate(20.000000, 392.583251, "LD_POOL:ball");
        TextDrawLetterSize(winico[0][computer_id], 0.000000, 0.000000);
        TextDrawTextSize(winico[0][computer_id], 30.000000, 30.333353);
        TextDrawAlignment(winico[0][computer_id], 1);
        TextDrawColor(winico[0][computer_id], 10354687);
        TextDrawSetShadow(winico[0][computer_id], 0);
        TextDrawSetOutline(winico[0][computer_id], 0);
        TextDrawFont(winico[0][computer_id], 4);
        TextDrawSetSelectable(winico[0][computer_id], true);
        winico[1][computer_id] = TextDrawCreate(31, 386, ".");
        TextDrawTextSize(winico[1][computer_id], 1, 1);
        TextDrawSetShadow(winico[1][computer_id], 0);
        TextDrawFont(winico[1][computer_id], 2);
        TextDrawColor(winico[1][computer_id], 0x023462ff);
        winico[1][used] = 1;
        winico[2][computer_id] = TextDrawCreate(32, 386, ".");
        TextDrawTextSize(winico[2][computer_id], 1, 1);
        TextDrawSetShadow(winico[2][computer_id], 0);
        TextDrawFont(winico[2][computer_id], 2);
        TextDrawColor(winico[2][computer_id], 0x18476Fff);
        winico[2][used] = 1;
        winico[3][computer_id] = TextDrawCreate(33, 386, ".");
        TextDrawTextSize(winico[3][computer_id], 1, 1);
        TextDrawSetShadow(winico[3][computer_id], 0);
        TextDrawFont(winico[3][computer_id], 2);
        TextDrawColor(winico[3][computer_id], 0x2F5C83ff);
        winico[3][used] = 1;
        winico[4][computer_id] = TextDrawCreate(34, 386, ".");
        TextDrawTextSize(winico[4][computer_id], 1, 1);
        TextDrawSetShadow(winico[4][computer_id], 0);
        TextDrawFont(winico[4][computer_id], 2);
        TextDrawColor(winico[4][computer_id], 0x2A577Cff);
        winico[4][used] = 1;
        winico[5][computer_id] = TextDrawCreate(35, 386, ".");
        TextDrawTextSize(winico[5][computer_id], 1, 1);
        TextDrawSetShadow(winico[5][computer_id], 0);
        TextDrawFont(winico[5][computer_id], 2);
        TextDrawColor(winico[5][computer_id], 0x13426Bff);
        winico[5][used] = 1;
        winico[6][computer_id] = TextDrawCreate(36, 386, ".");
        TextDrawTextSize(winico[6][computer_id], 1, 1);
        TextDrawSetShadow(winico[6][computer_id], 0);
        TextDrawFont(winico[6][computer_id], 2);
        TextDrawColor(winico[6][computer_id], 0x01335Fff);
        winico[6][used] = 1;
        winico[7][computer_id] = TextDrawCreate(37, 386, ".");
        TextDrawTextSize(winico[7][computer_id], 1, 1);
        TextDrawSetShadow(winico[7][computer_id], 0);
        TextDrawFont(winico[7][computer_id], 2);
        TextDrawColor(winico[7][computer_id], 0x3D6080ff);
        winico[7][used] = 1;
        winico[8][computer_id] = TextDrawCreate(27, 387, ".");
        TextDrawTextSize(winico[8][computer_id], 1, 1);
        TextDrawSetShadow(winico[8][computer_id], 0);
        TextDrawFont(winico[8][computer_id], 2);
        TextDrawColor(winico[8][computer_id], 0x5A7897ff);
        winico[8][used] = 1;
        winico[9][computer_id] = TextDrawCreate(28, 387, ".");
        TextDrawTextSize(winico[9][computer_id], 1, 1);
        TextDrawSetShadow(winico[9][computer_id], 0);
        TextDrawFont(winico[9][computer_id], 2);
        TextDrawColor(winico[9][computer_id], 0x053863ff);
        winico[9][used] = 1;
        winico[10][computer_id] = TextDrawCreate(29, 387, ".");
        TextDrawTextSize(winico[10][computer_id], 1, 1);
        TextDrawSetShadow(winico[10][computer_id], 0);
        TextDrawFont(winico[10][computer_id], 2);
        TextDrawColor(winico[10][computer_id], 0x7995B1ff);
        winico[10][used] = 1;
        winico[11][computer_id] = TextDrawCreate(30, 387, ".");
        TextDrawTextSize(winico[11][computer_id], 1, 1);
        TextDrawSetShadow(winico[11][computer_id], 0);
        TextDrawFont(winico[11][computer_id], 2);
        TextDrawColor(winico[11][computer_id], 0x97AFC5ff);
        winico[11][used] = 1;
        winico[12][computer_id] = TextDrawCreate(31, 387, ".");
        TextDrawTextSize(winico[12][computer_id], 1, 1);
        TextDrawSetShadow(winico[12][computer_id], 0);
        TextDrawFont(winico[12][computer_id], 2);
        TextDrawColor(winico[12][computer_id], 0x90ADC0ff);
        winico[12][used] = 1;
        winico[13][computer_id] = TextDrawCreate(32, 387, ".");
        TextDrawTextSize(winico[13][computer_id], 1, 1);
        TextDrawSetShadow(winico[13][computer_id], 0);
        TextDrawFont(winico[13][computer_id], 2);
        TextDrawColor(winico[13][computer_id], 0x8EAAC0ff);
        winico[13][used] = 1;
        winico[14][computer_id] = TextDrawCreate(33, 387, ".");
        TextDrawTextSize(winico[14][computer_id], 1, 1);
        TextDrawSetShadow(winico[14][computer_id], 0);
        TextDrawFont(winico[14][computer_id], 2);
        TextDrawColor(winico[14][computer_id], 0x8EABBFff);
        winico[14][used] = 1;
        winico[15][computer_id] = TextDrawCreate(34, 387, ".");
        TextDrawTextSize(winico[15][computer_id], 1, 1);
        TextDrawSetShadow(winico[15][computer_id], 0);
        TextDrawFont(winico[15][computer_id], 2);
        TextDrawColor(winico[15][computer_id], 0x8FABBFff);
        winico[15][used] = 1;
        winico[16][computer_id] = TextDrawCreate(35, 387, ".");
        TextDrawTextSize(winico[16][computer_id], 1, 1);
        TextDrawSetShadow(winico[16][computer_id], 0);
        TextDrawFont(winico[16][computer_id], 2);
        TextDrawColor(winico[16][computer_id], 0x8FABC0ff);
        winico[16][used] = 1;
        winico[17][computer_id] = TextDrawCreate(36, 387, ".");
        TextDrawTextSize(winico[17][computer_id], 1, 1);
        TextDrawSetShadow(winico[17][computer_id], 0);
        TextDrawFont(winico[17][computer_id], 2);
        TextDrawColor(winico[17][computer_id], 0x93AEC2ff);
        winico[17][used] = 1;
        winico[18][computer_id] = TextDrawCreate(37, 387, ".");
        TextDrawTextSize(winico[18][computer_id], 1, 1);
        TextDrawSetShadow(winico[18][computer_id], 0);
        TextDrawFont(winico[18][computer_id], 2);
        TextDrawColor(winico[18][computer_id], 0x96AEC4ff);
        winico[18][used] = 1;
        winico[19][computer_id] = TextDrawCreate(38, 387, ".");
        TextDrawTextSize(winico[19][computer_id], 1, 1);
        TextDrawSetShadow(winico[19][computer_id], 0);
        TextDrawFont(winico[19][computer_id], 2);
        TextDrawColor(winico[19][computer_id], 0x6385A3ff);
        winico[19][used] = 1;
        winico[20][computer_id] = TextDrawCreate(39, 387, ".");
        TextDrawTextSize(winico[20][computer_id], 1, 1);
        TextDrawSetShadow(winico[20][computer_id], 0);
        TextDrawFont(winico[20][computer_id], 2);
        TextDrawColor(winico[20][computer_id], 0x002957ff);
        winico[20][used] = 1;
        winico[21][computer_id] = TextDrawCreate(26, 388, ".");
        TextDrawTextSize(winico[21][computer_id], 1, 1);
        TextDrawSetShadow(winico[21][computer_id], 0);
        TextDrawFont(winico[21][computer_id], 2);
        TextDrawColor(winico[21][computer_id], 0x002A59ff);
        winico[21][used] = 1;
        winico[22][computer_id] = TextDrawCreate(27, 388, ".");
        TextDrawTextSize(winico[22][computer_id], 1, 1);
        TextDrawSetShadow(winico[22][computer_id], 0);
        TextDrawFont(winico[22][computer_id], 2);
        TextDrawColor(winico[22][computer_id], 0x6A8AA7ff);
        winico[22][used] = 1;
        winico[23][computer_id] = TextDrawCreate(28, 388, ".");
        TextDrawTextSize(winico[23][computer_id], 1, 1);
        TextDrawSetShadow(winico[23][computer_id], 0);
        TextDrawFont(winico[23][computer_id], 2);
        TextDrawColor(winico[23][computer_id], 0x7692AEff);
        winico[23][used] = 1;
        winico[24][computer_id] = TextDrawCreate(29, 388, ".");
        TextDrawTextSize(winico[24][computer_id], 1, 1);
        TextDrawSetShadow(winico[24][computer_id], 0);
        TextDrawFont(winico[24][computer_id], 2);
        TextDrawColor(winico[24][computer_id], 0x748FABff);
        winico[24][used] = 1;
        winico[25][computer_id] = TextDrawCreate(30, 388, ".");
        TextDrawTextSize(winico[25][computer_id], 1, 1);
        TextDrawSetShadow(winico[25][computer_id], 0);
        TextDrawFont(winico[25][computer_id], 2);
        TextDrawColor(winico[25][computer_id], 0x738EABff);
        winico[25][used] = 1;
        winico[26][computer_id] = TextDrawCreate(31, 388, ".");
        TextDrawTextSize(winico[26][computer_id], 1, 1);
        TextDrawSetShadow(winico[26][computer_id], 0);
        TextDrawFont(winico[26][computer_id], 2);
        TextDrawColor(winico[26][computer_id], 0x738EA9ff);
        winico[26][used] = 1;
        winico[27][computer_id] = TextDrawCreate(32, 388, ".");
        TextDrawTextSize(winico[27][computer_id], 1, 1);
        TextDrawSetShadow(winico[27][computer_id], 0);
        TextDrawFont(winico[27][computer_id], 2);
        TextDrawColor(winico[27][computer_id], 0x748EABff);
        winico[27][used] = 1;
        winico[28][computer_id] = TextDrawCreate(33, 388, ".");
        TextDrawTextSize(winico[28][computer_id], 1, 1);
        TextDrawSetShadow(winico[28][computer_id], 0);
        TextDrawFont(winico[28][computer_id], 2);
        TextDrawColor(winico[28][computer_id], 0x758EACff);
        winico[28][used] = 1;
        winico[29][computer_id] = TextDrawCreate(34, 388, ".");
        TextDrawTextSize(winico[29][computer_id], 1, 1);
        TextDrawSetShadow(winico[29][computer_id], 0);
        TextDrawFont(winico[29][computer_id], 2);
        TextDrawColor(winico[29][computer_id], 0x7390ACff);
        winico[29][used] = 1;
        winico[30][computer_id] = TextDrawCreate(35, 388, ".");
        TextDrawTextSize(winico[30][computer_id], 1, 1);
        TextDrawSetShadow(winico[30][computer_id], 0);
        TextDrawFont(winico[30][computer_id], 2);
        TextDrawColor(winico[30][computer_id], 0x7390ADff);
        winico[30][used] = 1;
        winico[31][computer_id] = TextDrawCreate(37, 388, ".");
        TextDrawTextSize(winico[31][computer_id], 2, 1);
        TextDrawSetShadow(winico[31][computer_id], 0);
        TextDrawFont(winico[31][computer_id], 2);
        TextDrawColor(winico[31][computer_id], 0x7490ADff);
        winico[31][used] = 1;
        winico[32][computer_id] = TextDrawCreate(38, 388, ".");
        TextDrawTextSize(winico[32][computer_id], 1, 1);
        TextDrawSetShadow(winico[32][computer_id], 0);
        TextDrawFont(winico[32][computer_id], 2);
        TextDrawColor(winico[32][computer_id], 0x738FADff);
        winico[32][used] = 1;
        winico[33][computer_id] = TextDrawCreate(39, 388, ".");
        TextDrawTextSize(winico[33][computer_id], 1, 1);
        TextDrawSetShadow(winico[33][computer_id], 0);
        TextDrawFont(winico[33][computer_id], 2);
        TextDrawColor(winico[33][computer_id], 0x7A95AFff);
        winico[33][used] = 1;
        winico[34][computer_id] = TextDrawCreate(40, 388, ".");
        TextDrawTextSize(winico[34][computer_id], 1, 1);
        TextDrawSetShadow(winico[34][computer_id], 0);
        TextDrawFont(winico[34][computer_id], 2);
        TextDrawColor(winico[34][computer_id], 0x517498ff);
        winico[34][used] = 1;
        winico[35][computer_id] = TextDrawCreate(41, 388, ".");
        TextDrawTextSize(winico[35][computer_id], 1, 1);
        TextDrawSetShadow(winico[35][computer_id], 0);
        TextDrawFont(winico[35][computer_id], 2);
        TextDrawColor(winico[35][computer_id], 0x002956ff);
        winico[35][used] = 1;
        winico[36][computer_id] = TextDrawCreate(25, 389, ".");
        TextDrawTextSize(winico[36][computer_id], 1, 1);
        TextDrawSetShadow(winico[36][computer_id], 0);
        TextDrawFont(winico[36][computer_id], 2);
        TextDrawColor(winico[36][computer_id], 0x13446Eff);
        winico[36][used] = 1;
        winico[37][computer_id] = TextDrawCreate(26, 389, ".");
        TextDrawTextSize(winico[37][computer_id], 1, 1);
        TextDrawSetShadow(winico[37][computer_id], 0);
        TextDrawFont(winico[37][computer_id], 2);
        TextDrawColor(winico[37][computer_id], 0x617E9Cff);
        winico[37][used] = 1;
        winico[38][computer_id] = TextDrawCreate(27, 389, ".");
        TextDrawTextSize(winico[38][computer_id], 1, 1);
        TextDrawSetShadow(winico[38][computer_id], 0);
        TextDrawFont(winico[38][computer_id], 2);
        TextDrawColor(winico[38][computer_id], 0x5B7899ff);
        winico[38][used] = 1;
        winico[39][computer_id] = TextDrawCreate(28, 389, ".");
        TextDrawTextSize(winico[39][computer_id], 1, 1);
        TextDrawSetShadow(winico[39][computer_id], 0);
        TextDrawFont(winico[39][computer_id], 2);
        TextDrawColor(winico[39][computer_id], 0x5D7896ff);
        winico[39][used] = 1;
        winico[40][computer_id] = TextDrawCreate(29, 389, ".");
        TextDrawTextSize(winico[40][computer_id], 1, 1);
        TextDrawSetShadow(winico[40][computer_id], 0);
        TextDrawFont(winico[40][computer_id], 2);
        TextDrawColor(winico[40][computer_id], 0x5C7996ff);
        winico[40][used] = 1;
        winico[41][computer_id] = TextDrawCreate(30, 389, ".");
        TextDrawTextSize(winico[41][computer_id], 1, 1);
        TextDrawSetShadow(winico[41][computer_id], 0);
        TextDrawFont(winico[41][computer_id], 2);
        TextDrawColor(winico[41][computer_id], 0x5B7897ff);
        winico[41][used] = 1;
        winico[42][computer_id] = TextDrawCreate(31, 389, ".");
        TextDrawTextSize(winico[42][computer_id], 1, 1);
        TextDrawSetShadow(winico[42][computer_id], 0);
        TextDrawFont(winico[42][computer_id], 2);
        TextDrawColor(winico[42][computer_id], 0x5A7896ff);
        winico[42][used] = 1;
        winico[43][computer_id] = TextDrawCreate(32, 389, ".");
        TextDrawTextSize(winico[43][computer_id], 1, 1);
        TextDrawSetShadow(winico[43][computer_id], 0);
        TextDrawFont(winico[43][computer_id], 2);
        TextDrawColor(winico[43][computer_id], 0x5C7997ff);
        winico[43][used] = 1;
        winico[44][computer_id] = TextDrawCreate(33, 389, ".");
        TextDrawTextSize(winico[44][computer_id], 1, 1);
        TextDrawSetShadow(winico[44][computer_id], 0);
        TextDrawFont(winico[44][computer_id], 2);
        TextDrawColor(winico[44][computer_id], 0x5B7898ff);
        winico[44][used] = 1;
        winico[45][computer_id] = TextDrawCreate(34, 389, ".");
        TextDrawTextSize(winico[45][computer_id], 1, 1);
        TextDrawSetShadow(winico[45][computer_id], 0);
        TextDrawFont(winico[45][computer_id], 2);
        TextDrawColor(winico[45][computer_id], 0x5B7999ff);
        winico[45][used] = 1;
        winico[46][computer_id] = TextDrawCreate(35, 389, ".");
        TextDrawTextSize(winico[46][computer_id], 1, 1);
        TextDrawSetShadow(winico[46][computer_id], 0);
        TextDrawFont(winico[46][computer_id], 2);
        TextDrawColor(winico[46][computer_id], 0x5D7A99ff);
        winico[46][used] = 1;
        winico[47][computer_id] = TextDrawCreate(39, 389, ".");
        TextDrawTextSize(winico[47][computer_id], 4, 1);
        TextDrawSetShadow(winico[47][computer_id], 0);
        TextDrawFont(winico[47][computer_id], 2);
        TextDrawColor(winico[47][computer_id], 0x5C799Bff);
        winico[47][used] = 1;
        winico[48][computer_id] = TextDrawCreate(40, 389, ".");
        TextDrawTextSize(winico[48][computer_id], 1, 1);
        TextDrawSetShadow(winico[48][computer_id], 0);
        TextDrawFont(winico[48][computer_id], 2);
        TextDrawColor(winico[48][computer_id], 0x5C7999ff);
        winico[48][used] = 1;
        winico[49][computer_id] = TextDrawCreate(41, 389, ".");
        TextDrawTextSize(winico[49][computer_id], 1, 1);
        TextDrawSetShadow(winico[49][computer_id], 0);
        TextDrawFont(winico[49][computer_id], 2);
        TextDrawColor(winico[49][computer_id], 0x627E9Cff);
        winico[49][used] = 1;
        winico[50][computer_id] = TextDrawCreate(42, 389, ".");
        TextDrawTextSize(winico[50][computer_id], 1, 1);
        TextDrawSetShadow(winico[50][computer_id], 0);
        TextDrawFont(winico[50][computer_id], 2);
        TextDrawColor(winico[50][computer_id], 0x00305Eff);
        winico[50][used] = 1;
        winico[51][computer_id] = TextDrawCreate(24, 390, ".");
        TextDrawTextSize(winico[51][computer_id], 1, 1);
        TextDrawSetShadow(winico[51][computer_id], 0);
        TextDrawFont(winico[51][computer_id], 2);
        TextDrawColor(winico[51][computer_id], 0x13416Dff);
        winico[51][used] = 1;
        winico[52][computer_id] = TextDrawCreate(25, 390, ".");
        TextDrawTextSize(winico[52][computer_id], 1, 1);
        TextDrawSetShadow(winico[52][computer_id], 0);
        TextDrawFont(winico[52][computer_id], 2);
        TextDrawColor(winico[52][computer_id], 0x4B698Bff);
        winico[52][used] = 1;
        winico[53][computer_id] = TextDrawCreate(26, 390, ".");
        TextDrawTextSize(winico[53][computer_id], 1, 1);
        TextDrawSetShadow(winico[53][computer_id], 0);
        TextDrawFont(winico[53][computer_id], 2);
        TextDrawColor(winico[53][computer_id], 0x49658Bff);
        winico[53][used] = 1;
        winico[54][computer_id] = TextDrawCreate(27, 390, ".");
        TextDrawTextSize(winico[54][computer_id], 1, 1);
        TextDrawSetShadow(winico[54][computer_id], 0);
        TextDrawFont(winico[54][computer_id], 2);
        TextDrawColor(winico[54][computer_id], 0x49668Bff);
        winico[54][used] = 1;
        winico[55][computer_id] = TextDrawCreate(28, 390, ".");
        TextDrawTextSize(winico[55][computer_id], 1, 1);
        TextDrawSetShadow(winico[55][computer_id], 0);
        TextDrawFont(winico[55][computer_id], 2);
        TextDrawColor(winico[55][computer_id], 0x486487ff);
        winico[55][used] = 1;
        winico[56][computer_id] = TextDrawCreate(29, 390, ".");
        TextDrawTextSize(winico[56][computer_id], 1, 1);
        TextDrawSetShadow(winico[56][computer_id], 0);
        TextDrawFont(winico[56][computer_id], 2);
        TextDrawColor(winico[56][computer_id], 0x496483ff);
        winico[56][used] = 1;
        winico[57][computer_id] = TextDrawCreate(30, 390, ".");
        TextDrawTextSize(winico[57][computer_id], 1, 1);
        TextDrawSetShadow(winico[57][computer_id], 0);
        TextDrawFont(winico[57][computer_id], 2);
        TextDrawColor(winico[57][computer_id], 0x496482ff);
        winico[57][used] = 1;
        winico[58][computer_id] = TextDrawCreate(31, 390, ".");
        TextDrawTextSize(winico[58][computer_id], 1, 1);
        TextDrawSetShadow(winico[58][computer_id], 0);
        TextDrawFont(winico[58][computer_id], 2);
        TextDrawColor(winico[58][computer_id], 0x476483ff);
        winico[58][used] = 1;
        winico[59][computer_id] = TextDrawCreate(32, 390, ".");
        TextDrawTextSize(winico[59][computer_id], 1, 1);
        TextDrawSetShadow(winico[59][computer_id], 0);
        TextDrawFont(winico[59][computer_id], 2);
        TextDrawColor(winico[59][computer_id], 0x476481ff);
        winico[59][used] = 1;
        winico[60][computer_id] = TextDrawCreate(33, 390, ".");
        TextDrawTextSize(winico[60][computer_id], 1, 1);
        TextDrawSetShadow(winico[60][computer_id], 0);
        TextDrawFont(winico[60][computer_id], 2);
        TextDrawColor(winico[60][computer_id], 0x486384ff);
        winico[60][used] = 1;
        winico[61][computer_id] = TextDrawCreate(34, 390, ".");
        TextDrawTextSize(winico[61][computer_id], 1, 1);
        TextDrawSetShadow(winico[61][computer_id], 0);
        TextDrawFont(winico[61][computer_id], 2);
        TextDrawColor(winico[61][computer_id], 0x486586ff);
        winico[61][used] = 1;
        winico[62][computer_id] = TextDrawCreate(35, 390, ".");
        TextDrawTextSize(winico[62][computer_id], 1, 1);
        TextDrawSetShadow(winico[62][computer_id], 0);
        TextDrawFont(winico[62][computer_id], 2);
        TextDrawColor(winico[62][computer_id], 0x496688ff);
        winico[62][used] = 1;
        winico[63][computer_id] = TextDrawCreate(36, 390, ".");
        TextDrawTextSize(winico[63][computer_id], 1, 1);
        TextDrawSetShadow(winico[63][computer_id], 0);
        TextDrawFont(winico[63][computer_id], 2);
        TextDrawColor(winico[63][computer_id], 0x49668Cff);
        winico[63][used] = 1;
        winico[64][computer_id] = TextDrawCreate(39, 390, ".");
        TextDrawTextSize(winico[64][computer_id], 3, 1);
        TextDrawSetShadow(winico[64][computer_id], 0);
        TextDrawFont(winico[64][computer_id], 2);
        TextDrawColor(winico[64][computer_id], 0x48658Aff);
        winico[64][used] = 1;
        winico[65][computer_id] = TextDrawCreate(40, 390, ".");
        TextDrawTextSize(winico[65][computer_id], 1, 1);
        TextDrawSetShadow(winico[65][computer_id], 0);
        TextDrawFont(winico[65][computer_id], 2);
        TextDrawColor(winico[65][computer_id], 0x49658Aff);
        winico[65][used] = 1;
        winico[66][computer_id] = TextDrawCreate(41, 390, ".");
        TextDrawTextSize(winico[66][computer_id], 1, 1);
        TextDrawSetShadow(winico[66][computer_id], 0);
        TextDrawFont(winico[66][computer_id], 2);
        TextDrawColor(winico[66][computer_id], 0x48668Bff);
        winico[66][used] = 1;
        winico[67][computer_id] = TextDrawCreate(42, 390, ".");
        TextDrawTextSize(winico[67][computer_id], 1, 1);
        TextDrawSetShadow(winico[67][computer_id], 0);
        TextDrawFont(winico[67][computer_id], 2);
        TextDrawColor(winico[67][computer_id], 0x4D6B8Fff);
        winico[67][used] = 1;
        winico[68][computer_id] = TextDrawCreate(43, 390, ".");
        TextDrawTextSize(winico[68][computer_id], 1, 1);
        TextDrawSetShadow(winico[68][computer_id], 0);
        TextDrawFont(winico[68][computer_id], 2);
        TextDrawColor(winico[68][computer_id], 0x023360ff);
        winico[68][used] = 1;
        winico[69][computer_id] = TextDrawCreate(23, 391, ".");
        TextDrawTextSize(winico[69][computer_id], 1, 1);
        TextDrawSetShadow(winico[69][computer_id], 0);
        TextDrawFont(winico[69][computer_id], 2);
        TextDrawColor(winico[69][computer_id], 0x083966ff);
        winico[69][used] = 1;
        winico[70][computer_id] = TextDrawCreate(24, 391, ".");
        TextDrawTextSize(winico[70][computer_id], 1, 1);
        TextDrawSetShadow(winico[70][computer_id], 0);
        TextDrawFont(winico[70][computer_id], 2);
        TextDrawColor(winico[70][computer_id], 0x38597Bff);
        winico[70][used] = 1;
        winico[71][computer_id] = TextDrawCreate(25, 391, ".");
        TextDrawTextSize(winico[71][computer_id], 1, 1);
        TextDrawSetShadow(winico[71][computer_id], 0);
        TextDrawFont(winico[71][computer_id], 2);
        TextDrawColor(winico[71][computer_id], 0x36577Cff);
        winico[71][used] = 1;
        winico[72][computer_id] = TextDrawCreate(26, 391, ".");
        TextDrawTextSize(winico[72][computer_id], 1, 1);
        TextDrawSetShadow(winico[72][computer_id], 0);
        TextDrawFont(winico[72][computer_id], 2);
        TextDrawColor(winico[72][computer_id], 0x365679ff);
        winico[72][used] = 1;
        winico[73][computer_id] = TextDrawCreate(27, 391, ".");
        TextDrawTextSize(winico[73][computer_id], 1, 1);
        TextDrawSetShadow(winico[73][computer_id], 0);
        TextDrawFont(winico[73][computer_id], 2);
        TextDrawColor(winico[73][computer_id], 0x345576ff);
        winico[73][used] = 1;
        winico[74][computer_id] = TextDrawCreate(28, 391, ".");
        TextDrawTextSize(winico[74][computer_id], 1, 1);
        TextDrawSetShadow(winico[74][computer_id], 0);
        TextDrawFont(winico[74][computer_id], 2);
        TextDrawColor(winico[74][computer_id], 0x2F5273ff);
        winico[74][used] = 1;
        winico[75][computer_id] = TextDrawCreate(29, 391, ".");
        TextDrawTextSize(winico[75][computer_id], 1, 1);
        TextDrawSetShadow(winico[75][computer_id], 0);
        TextDrawFont(winico[75][computer_id], 2);
        TextDrawColor(winico[75][computer_id], 0x38516Fff);
        winico[75][used] = 1;
        winico[76][computer_id] = TextDrawCreate(30, 391, ".");
        TextDrawTextSize(winico[76][computer_id], 1, 1);
        TextDrawSetShadow(winico[76][computer_id], 0);
        TextDrawFont(winico[76][computer_id], 2);
        TextDrawColor(winico[76][computer_id], 0x6C5467ff);
        winico[76][used] = 1;
        winico[77][computer_id] = TextDrawCreate(31, 391, ".");
        TextDrawTextSize(winico[77][computer_id], 1, 1);
        TextDrawSetShadow(winico[77][computer_id], 0);
        TextDrawFont(winico[77][computer_id], 2);
        TextDrawColor(winico[77][computer_id], 0x824F60ff);
        winico[77][used] = 1;
        winico[78][computer_id] = TextDrawCreate(32, 391, ".");
        TextDrawTextSize(winico[78][computer_id], 1, 1);
        TextDrawSetShadow(winico[78][computer_id], 0);
        TextDrawFont(winico[78][computer_id], 2);
        TextDrawColor(winico[78][computer_id], 0x795266ff);
        winico[78][used] = 1;
        winico[79][computer_id] = TextDrawCreate(33, 391, ".");
        TextDrawTextSize(winico[79][computer_id], 1, 1);
        TextDrawSetShadow(winico[79][computer_id], 0);
        TextDrawFont(winico[79][computer_id], 2);
        TextDrawColor(winico[79][computer_id], 0x3D5070ff);
        winico[79][used] = 1;
        winico[80][computer_id] = TextDrawCreate(34, 391, ".");
        TextDrawTextSize(winico[80][computer_id], 1, 1);
        TextDrawSetShadow(winico[80][computer_id], 0);
        TextDrawFont(winico[80][computer_id], 2);
        TextDrawColor(winico[80][computer_id], 0x344F73ff);
        winico[80][used] = 1;
        winico[81][computer_id] = TextDrawCreate(35, 391, ".");
        TextDrawTextSize(winico[81][computer_id], 1, 1);
        TextDrawSetShadow(winico[81][computer_id], 0);
        TextDrawFont(winico[81][computer_id], 2);
        TextDrawColor(winico[81][computer_id], 0x365477ff);
        winico[81][used] = 1;
        winico[82][computer_id] = TextDrawCreate(36, 391, ".");
        TextDrawTextSize(winico[82][computer_id], 1, 1);
        TextDrawSetShadow(winico[82][computer_id], 0);
        TextDrawFont(winico[82][computer_id], 2);
        TextDrawColor(winico[82][computer_id], 0x365378ff);
        winico[82][used] = 1;
        winico[83][computer_id] = TextDrawCreate(37, 391, ".");
        TextDrawTextSize(winico[83][computer_id], 1, 1);
        TextDrawSetShadow(winico[83][computer_id], 0);
        TextDrawFont(winico[83][computer_id], 2);
        TextDrawColor(winico[83][computer_id], 0x365679ff);
        winico[83][used] = 1;
        winico[84][computer_id] = TextDrawCreate(38, 391, ".");
        TextDrawTextSize(winico[84][computer_id], 1, 1);
        TextDrawSetShadow(winico[84][computer_id], 0);
        TextDrawFont(winico[84][computer_id], 2);
        TextDrawColor(winico[84][computer_id], 0x35587Cff);
        winico[84][used] = 1;
        winico[85][computer_id] = TextDrawCreate(39, 391, ".");
        TextDrawTextSize(winico[85][computer_id], 1, 1);
        TextDrawSetShadow(winico[85][computer_id], 0);
        TextDrawFont(winico[85][computer_id], 2);
        TextDrawColor(winico[85][computer_id], 0x35577Cff);
        winico[85][used] = 1;
        winico[86][computer_id] = TextDrawCreate(40, 391, ".");
        TextDrawTextSize(winico[86][computer_id], 1, 1);
        TextDrawSetShadow(winico[86][computer_id], 0);
        TextDrawFont(winico[86][computer_id], 2);
        TextDrawColor(winico[86][computer_id], 0x35567Bff);
        winico[86][used] = 1;
        winico[87][computer_id] = TextDrawCreate(41, 391, ".");
        TextDrawTextSize(winico[87][computer_id], 1, 1);
        TextDrawSetShadow(winico[87][computer_id], 0);
        TextDrawFont(winico[87][computer_id], 2);
        TextDrawColor(winico[87][computer_id], 0x37557Bff);
        winico[87][used] = 1;
        winico[88][computer_id] = TextDrawCreate(42, 391, ".");
        TextDrawTextSize(winico[88][computer_id], 1, 1);
        TextDrawSetShadow(winico[88][computer_id], 0);
        TextDrawFont(winico[88][computer_id], 2);
        TextDrawColor(winico[88][computer_id], 0x36567Aff);
        winico[88][used] = 1;
        winico[89][computer_id] = TextDrawCreate(43, 391, ".");
        TextDrawTextSize(winico[89][computer_id], 1, 1);
        TextDrawSetShadow(winico[89][computer_id], 0);
        TextDrawFont(winico[89][computer_id], 2);
        TextDrawColor(winico[89][computer_id], 0x3A587Cff);
        winico[89][used] = 1;
        winico[90][computer_id] = TextDrawCreate(44, 391, ".");
        TextDrawTextSize(winico[90][computer_id], 1, 1);
        TextDrawSetShadow(winico[90][computer_id], 0);
        TextDrawFont(winico[90][computer_id], 2);
        TextDrawColor(winico[90][computer_id], 0x002E5Dff);
        winico[90][used] = 1;
        winico[91][computer_id] = TextDrawCreate(22, 392, ".");
        TextDrawTextSize(winico[91][computer_id], 1, 1);
        TextDrawSetShadow(winico[91][computer_id], 0);
        TextDrawFont(winico[91][computer_id], 2);
        TextDrawColor(winico[91][computer_id], 0x002C5Dff);
        winico[91][used] = 1;
        winico[92][computer_id] = TextDrawCreate(23, 392, ".");
        TextDrawTextSize(winico[92][computer_id], 1, 1);
        TextDrawSetShadow(winico[92][computer_id], 0);
        TextDrawFont(winico[92][computer_id], 2);
        TextDrawColor(winico[92][computer_id], 0x294C6Fff);
        winico[92][used] = 1;
        winico[93][computer_id] = TextDrawCreate(24, 392, ".");
        TextDrawTextSize(winico[93][computer_id], 1, 1);
        TextDrawSetShadow(winico[93][computer_id], 0);
        TextDrawFont(winico[93][computer_id], 2);
        TextDrawColor(winico[93][computer_id], 0x274A70ff);
        winico[93][used] = 1;
        winico[94][computer_id] = TextDrawCreate(25, 392, ".");
        TextDrawTextSize(winico[94][computer_id], 1, 1);
        TextDrawSetShadow(winico[94][computer_id], 0);
        TextDrawFont(winico[94][computer_id], 2);
        TextDrawColor(winico[94][computer_id], 0x274A6Cff);
        winico[94][used] = 1;
        winico[95][computer_id] = TextDrawCreate(26, 392, ".");
        TextDrawTextSize(winico[95][computer_id], 1, 1);
        TextDrawSetShadow(winico[95][computer_id], 0);
        TextDrawFont(winico[95][computer_id], 2);
        TextDrawColor(winico[95][computer_id], 0x264869ff);
        winico[95][used] = 1;
        winico[96][computer_id] = TextDrawCreate(27, 392, ".");
        TextDrawTextSize(winico[96][computer_id], 1, 1);
        TextDrawSetShadow(winico[96][computer_id], 0);
        TextDrawFont(winico[96][computer_id], 2);
        TextDrawColor(winico[96][computer_id], 0x204568ff);
        winico[96][used] = 1;
        winico[97][computer_id] = TextDrawCreate(28, 392, ".");
        TextDrawTextSize(winico[97][computer_id], 1, 1);
        TextDrawSetShadow(winico[97][computer_id], 0);
        TextDrawFont(winico[97][computer_id], 2);
        TextDrawColor(winico[97][computer_id], 0xC0404Dff);
        winico[97][used] = 1;
        winico[98][computer_id] = TextDrawCreate(29, 392, ".");
        TextDrawTextSize(winico[98][computer_id], 1, 1);
        TextDrawSetShadow(winico[98][computer_id], 0);
        TextDrawFont(winico[98][computer_id], 2);
        TextDrawColor(winico[98][computer_id], 0xC4424Aff);
        winico[98][used] = 1;
        winico[99][computer_id] = TextDrawCreate(30, 392, ".");
        TextDrawTextSize(winico[99][computer_id], 1, 1);
        TextDrawSetShadow(winico[99][computer_id], 0);
        TextDrawFont(winico[99][computer_id], 2);
        TextDrawColor(winico[99][computer_id], 0xC6484Bff);
        winico[99][used] = 1;
        winico[100][computer_id] = TextDrawCreate(31, 392, ".");
        TextDrawTextSize(winico[100][computer_id], 1, 1);
        TextDrawSetShadow(winico[100][computer_id], 0);
        TextDrawFont(winico[100][computer_id], 2);
        TextDrawColor(winico[100][computer_id], 0xCE4D4Dff);
        winico[100][used] = 1;
        winico[101][computer_id] = TextDrawCreate(32, 392, ".");
        TextDrawTextSize(winico[101][computer_id], 1, 1);
        TextDrawSetShadow(winico[101][computer_id], 0);
        TextDrawFont(winico[101][computer_id], 2);
        TextDrawColor(winico[101][computer_id], 0xCD504Fff);
        winico[101][used] = 1;
        winico[102][computer_id] = TextDrawCreate(33, 392, ".");
        TextDrawTextSize(winico[102][computer_id], 1, 1);
        TextDrawSetShadow(winico[102][computer_id], 0);
        TextDrawFont(winico[102][computer_id], 2);
        TextDrawColor(winico[102][computer_id], 0xD2504Cff);
        winico[102][used] = 1;
        winico[103][computer_id] = TextDrawCreate(34, 392, ".");
        TextDrawTextSize(winico[103][computer_id], 1, 1);
        TextDrawSetShadow(winico[103][computer_id], 0);
        TextDrawFont(winico[103][computer_id], 2);
        TextDrawColor(winico[103][computer_id], 0xBE5250ff);
        winico[103][used] = 1;
        winico[104][computer_id] = TextDrawCreate(35, 392, ".");
        TextDrawTextSize(winico[104][computer_id], 1, 1);
        TextDrawSetShadow(winico[104][computer_id], 0);
        TextDrawFont(winico[104][computer_id], 2);
        TextDrawColor(winico[104][computer_id], 0x294566ff);
        winico[104][used] = 1;
        winico[105][computer_id] = TextDrawCreate(36, 392, ".");
        TextDrawTextSize(winico[105][computer_id], 1, 1);
        TextDrawSetShadow(winico[105][computer_id], 0);
        TextDrawFont(winico[105][computer_id], 2);
        TextDrawColor(winico[105][computer_id], 0x274667ff);
        winico[105][used] = 1;
        winico[106][computer_id] = TextDrawCreate(37, 392, ".");
        TextDrawTextSize(winico[106][computer_id], 1, 1);
        TextDrawSetShadow(winico[106][computer_id], 0);
        TextDrawFont(winico[106][computer_id], 2);
        TextDrawColor(winico[106][computer_id], 0x254768ff);
        winico[106][used] = 1;
        winico[107][computer_id] = TextDrawCreate(38, 392, ".");
        TextDrawTextSize(winico[107][computer_id], 1, 1);
        TextDrawSetShadow(winico[107][computer_id], 0);
        TextDrawFont(winico[107][computer_id], 2);
        TextDrawColor(winico[107][computer_id], 0x274869ff);
        winico[107][used] = 1;
        winico[108][computer_id] = TextDrawCreate(39, 392, ".");
        TextDrawTextSize(winico[108][computer_id], 1, 1);
        TextDrawSetShadow(winico[108][computer_id], 0);
        TextDrawFont(winico[108][computer_id], 2);
        TextDrawColor(winico[108][computer_id], 0x26496Bff);
        winico[108][used] = 1;
        winico[109][computer_id] = TextDrawCreate(40, 392, ".");
        TextDrawTextSize(winico[109][computer_id], 1, 1);
        TextDrawSetShadow(winico[109][computer_id], 0);
        TextDrawFont(winico[109][computer_id], 2);
        TextDrawColor(winico[109][computer_id], 0x27496Bff);
        winico[109][used] = 1;
        winico[110][computer_id] = TextDrawCreate(41, 392, ".");
        TextDrawTextSize(winico[110][computer_id], 1, 1);
        TextDrawSetShadow(winico[110][computer_id], 0);
        TextDrawFont(winico[110][computer_id], 2);
        TextDrawColor(winico[110][computer_id], 0x27496Cff);
        winico[110][used] = 1;
        winico[111][computer_id] = TextDrawCreate(42, 392, ".");
        TextDrawTextSize(winico[111][computer_id], 1, 1);
        TextDrawSetShadow(winico[111][computer_id], 0);
        TextDrawFont(winico[111][computer_id], 2);
        TextDrawColor(winico[111][computer_id], 0x27496Dff);
        winico[111][used] = 1;
        winico[112][computer_id] = TextDrawCreate(43, 392, ".");
        TextDrawTextSize(winico[112][computer_id], 1, 1);
        TextDrawSetShadow(winico[112][computer_id], 0);
        TextDrawFont(winico[112][computer_id], 2);
        TextDrawColor(winico[112][computer_id], 0x27496Eff);
        winico[112][used] = 1;
        winico[113][computer_id] = TextDrawCreate(44, 392, ".");
        TextDrawTextSize(winico[113][computer_id], 1, 1);
        TextDrawSetShadow(winico[113][computer_id], 0);
        TextDrawFont(winico[113][computer_id], 2);
        TextDrawColor(winico[113][computer_id], 0x23486Eff);
        winico[113][used] = 1;
        winico[114][computer_id] = TextDrawCreate(45, 392, ".");
        TextDrawTextSize(winico[114][computer_id], 1, 1);
        TextDrawSetShadow(winico[114][computer_id], 0);
        TextDrawFont(winico[114][computer_id], 2);
        TextDrawColor(winico[114][computer_id], 0x002D5Bff);
        winico[114][used] = 1;
        winico[115][computer_id] = TextDrawCreate(22, 393, ".");
        TextDrawTextSize(winico[115][computer_id], 1, 1);
        TextDrawSetShadow(winico[115][computer_id], 0);
        TextDrawFont(winico[115][computer_id], 2);
        TextDrawColor(winico[115][computer_id], 0x123D6Bff);
        winico[115][used] = 1;
        winico[116][computer_id] = TextDrawCreate(23, 393, ".");
        TextDrawTextSize(winico[116][computer_id], 1, 1);
        TextDrawSetShadow(winico[116][computer_id], 0);
        TextDrawFont(winico[116][computer_id], 2);
        TextDrawColor(winico[116][computer_id], 0x18416Eff);
        winico[116][used] = 1;
        winico[117][computer_id] = TextDrawCreate(24, 393, ".");
        TextDrawTextSize(winico[117][computer_id], 1, 1);
        TextDrawSetShadow(winico[117][computer_id], 0);
        TextDrawFont(winico[117][computer_id], 2);
        TextDrawColor(winico[117][computer_id], 0x1A3F6Bff);
        winico[117][used] = 1;
        winico[118][computer_id] = TextDrawCreate(25, 393, ".");
        TextDrawTextSize(winico[118][computer_id], 1, 1);
        TextDrawSetShadow(winico[118][computer_id], 0);
        TextDrawFont(winico[118][computer_id], 2);
        TextDrawColor(winico[118][computer_id], 0x1B3D67ff);
        winico[118][used] = 1;
        winico[119][computer_id] = TextDrawCreate(26, 393, ".");
        TextDrawTextSize(winico[119][computer_id], 1, 1);
        TextDrawSetShadow(winico[119][computer_id], 0);
        TextDrawFont(winico[119][computer_id], 2);
        TextDrawColor(winico[119][computer_id], 0x183A5Eff);
        winico[119][used] = 1;
        winico[120][computer_id] = TextDrawCreate(27, 393, ".");
        TextDrawTextSize(winico[120][computer_id], 1, 1);
        TextDrawSetShadow(winico[120][computer_id], 0);
        TextDrawFont(winico[120][computer_id], 2);
        TextDrawColor(winico[120][computer_id], 0x213752ff);
        winico[120][used] = 1;
        winico[121][computer_id] = TextDrawCreate(28, 393, ".");
        TextDrawTextSize(winico[121][computer_id], 1, 1);
        TextDrawSetShadow(winico[121][computer_id], 0);
        TextDrawFont(winico[121][computer_id], 2);
        TextDrawColor(winico[121][computer_id], 0xC93942ff);
        winico[121][used] = 1;
        winico[122][computer_id] = TextDrawCreate(29, 393, ".");
        TextDrawTextSize(winico[122][computer_id], 1, 1);
        TextDrawSetShadow(winico[122][computer_id], 0);
        TextDrawFont(winico[122][computer_id], 2);
        TextDrawColor(winico[122][computer_id], 0xCB4843ff);
        winico[122][used] = 1;
        winico[123][computer_id] = TextDrawCreate(30, 393, ".");
        TextDrawTextSize(winico[123][computer_id], 1, 1);
        TextDrawSetShadow(winico[123][computer_id], 0);
        TextDrawFont(winico[123][computer_id], 2);
        TextDrawColor(winico[123][computer_id], 0xD25843ff);
        winico[123][used] = 1;
        winico[124][computer_id] = TextDrawCreate(31, 393, ".");
        TextDrawTextSize(winico[124][computer_id], 1, 1);
        TextDrawSetShadow(winico[124][computer_id], 0);
        TextDrawFont(winico[124][computer_id], 2);
        TextDrawColor(winico[124][computer_id], 0xD96543ff);
        winico[124][used] = 1;
        winico[125][computer_id] = TextDrawCreate(32, 393, ".");
        TextDrawTextSize(winico[125][computer_id], 1, 1);
        TextDrawSetShadow(winico[125][computer_id], 0);
        TextDrawFont(winico[125][computer_id], 2);
        TextDrawColor(winico[125][computer_id], 0xDE6C45ff);
        winico[125][used] = 1;
        winico[126][computer_id] = TextDrawCreate(33, 393, ".");
        TextDrawTextSize(winico[126][computer_id], 1, 1);
        TextDrawSetShadow(winico[126][computer_id], 0);
        TextDrawFont(winico[126][computer_id], 2);
        TextDrawColor(winico[126][computer_id], 0xDE6C46ff);
        winico[126][used] = 1;
        winico[127][computer_id] = TextDrawCreate(34, 393, ".");
        TextDrawTextSize(winico[127][computer_id], 1, 1);
        TextDrawSetShadow(winico[127][computer_id], 0);
        TextDrawFont(winico[127][computer_id], 2);
        TextDrawColor(winico[127][computer_id], 0xE56D47ff);
        winico[127][used] = 1;
        winico[128][computer_id] = TextDrawCreate(35, 393, ".");
        TextDrawTextSize(winico[128][computer_id], 1, 1);
        TextDrawSetShadow(winico[128][computer_id], 0);
        TextDrawFont(winico[128][computer_id], 2);
        TextDrawColor(winico[128][computer_id], 0x0D3453ff);
        winico[128][used] = 1;
        winico[129][computer_id] = TextDrawCreate(36, 393, ".");
        TextDrawTextSize(winico[129][computer_id], 1, 1);
        TextDrawSetShadow(winico[129][computer_id], 0);
        TextDrawFont(winico[129][computer_id], 2);
        TextDrawColor(winico[129][computer_id], 0x51735Dff);
        winico[129][used] = 1;
        winico[130][computer_id] = TextDrawCreate(37, 393, ".");
        TextDrawTextSize(winico[130][computer_id], 1, 1);
        TextDrawSetShadow(winico[130][computer_id], 0);
        TextDrawFont(winico[130][computer_id], 2);
        TextDrawColor(winico[130][computer_id], 0x14325Bff);
        winico[130][used] = 1;
        winico[131][computer_id] = TextDrawCreate(38, 393, ".");
        TextDrawTextSize(winico[131][computer_id], 1, 1);
        TextDrawSetShadow(winico[131][computer_id], 0);
        TextDrawFont(winico[131][computer_id], 2);
        TextDrawColor(winico[131][computer_id], 0x18395Aff);
        winico[131][used] = 1;
        winico[132][computer_id] = TextDrawCreate(39, 393, ".");
        TextDrawTextSize(winico[132][computer_id], 1, 1);
        TextDrawSetShadow(winico[132][computer_id], 0);
        TextDrawFont(winico[132][computer_id], 2);
        TextDrawColor(winico[132][computer_id], 0x1A3A5Aff);
        winico[132][used] = 1;
        winico[133][computer_id] = TextDrawCreate(40, 393, ".");
        TextDrawTextSize(winico[133][computer_id], 1, 1);
        TextDrawSetShadow(winico[133][computer_id], 0);
        TextDrawFont(winico[133][computer_id], 2);
        TextDrawColor(winico[133][computer_id], 0x1A3959ff);
        winico[133][used] = 1;
        winico[134][computer_id] = TextDrawCreate(41, 393, ".");
        TextDrawTextSize(winico[134][computer_id], 1, 1);
        TextDrawSetShadow(winico[134][computer_id], 0);
        TextDrawFont(winico[134][computer_id], 2);
        TextDrawColor(winico[134][computer_id], 0x17395Cff);
        winico[134][used] = 1;
        winico[135][computer_id] = TextDrawCreate(42, 393, ".");
        TextDrawTextSize(winico[135][computer_id], 1, 1);
        TextDrawSetShadow(winico[135][computer_id], 0);
        TextDrawFont(winico[135][computer_id], 2);
        TextDrawColor(winico[135][computer_id], 0x17365Eff);
        winico[135][used] = 1;
        winico[136][computer_id] = TextDrawCreate(43, 393, ".");
        TextDrawTextSize(winico[136][computer_id], 1, 1);
        TextDrawSetShadow(winico[136][computer_id], 0);
        TextDrawFont(winico[136][computer_id], 2);
        TextDrawColor(winico[136][computer_id], 0x1C3E62ff);
        winico[136][used] = 1;
        winico[137][computer_id] = TextDrawCreate(44, 393, ".");
        TextDrawTextSize(winico[137][computer_id], 1, 1);
        TextDrawSetShadow(winico[137][computer_id], 0);
        TextDrawFont(winico[137][computer_id], 2);
        TextDrawColor(winico[137][computer_id], 0x1A3E63ff);
        winico[137][used] = 1;
        winico[138][computer_id] = TextDrawCreate(45, 393, ".");
        TextDrawTextSize(winico[138][computer_id], 1, 1);
        TextDrawSetShadow(winico[138][computer_id], 0);
        TextDrawFont(winico[138][computer_id], 2);
        TextDrawColor(winico[138][computer_id], 0x063866ff);
        winico[138][used] = 1;
        winico[139][computer_id] = TextDrawCreate(21, 394, ".");
        TextDrawTextSize(winico[139][computer_id], 1, 1);
        TextDrawSetShadow(winico[139][computer_id], 0);
        TextDrawFont(winico[139][computer_id], 2);
        TextDrawColor(winico[139][computer_id], 0x003060ff);
        winico[139][used] = 1;
        winico[140][computer_id] = TextDrawCreate(22, 394, ".");
        TextDrawTextSize(winico[140][computer_id], 1, 1);
        TextDrawSetShadow(winico[140][computer_id], 0);
        TextDrawFont(winico[140][computer_id], 2);
        TextDrawColor(winico[140][computer_id], 0x10416Aff);
        winico[140][used] = 1;
        winico[141][computer_id] = TextDrawCreate(23, 394, ".");
        TextDrawTextSize(winico[141][computer_id], 1, 1);
        TextDrawSetShadow(winico[141][computer_id], 0);
        TextDrawFont(winico[141][computer_id], 2);
        TextDrawColor(winico[141][computer_id], 0x11406Cff);
        winico[141][used] = 1;
        winico[142][computer_id] = TextDrawCreate(24, 394, ".");
        TextDrawTextSize(winico[142][computer_id], 1, 1);
        TextDrawSetShadow(winico[142][computer_id], 0);
        TextDrawFont(winico[142][computer_id], 2);
        TextDrawColor(winico[142][computer_id], 0x0F3D6Cff);
        winico[142][used] = 1;
        winico[143][computer_id] = TextDrawCreate(25, 394, ".");
        TextDrawTextSize(winico[143][computer_id], 1, 1);
        TextDrawSetShadow(winico[143][computer_id], 0);
        TextDrawFont(winico[143][computer_id], 2);
        TextDrawColor(winico[143][computer_id], 0x103B63ff);
        winico[143][used] = 1;
        winico[144][computer_id] = TextDrawCreate(26, 394, ".");
        TextDrawTextSize(winico[144][computer_id], 1, 1);
        TextDrawSetShadow(winico[144][computer_id], 0);
        TextDrawFont(winico[144][computer_id], 2);
        TextDrawColor(winico[144][computer_id], 0x10365Cff);
        winico[144][used] = 1;
        winico[145][computer_id] = TextDrawCreate(27, 394, ".");
        TextDrawTextSize(winico[145][computer_id], 1, 1);
        TextDrawSetShadow(winico[145][computer_id], 0);
        TextDrawFont(winico[145][computer_id], 2);
        TextDrawColor(winico[145][computer_id], 0x774447ff);
        winico[145][used] = 1;
        winico[146][computer_id] = TextDrawCreate(28, 394, ".");
        TextDrawTextSize(winico[146][computer_id], 1, 1);
        TextDrawSetShadow(winico[146][computer_id], 0);
        TextDrawFont(winico[146][computer_id], 2);
        TextDrawColor(winico[146][computer_id], 0xCD4C39ff);
        winico[146][used] = 1;
        winico[147][computer_id] = TextDrawCreate(29, 394, ".");
        TextDrawTextSize(winico[147][computer_id], 1, 1);
        TextDrawSetShadow(winico[147][computer_id], 0);
        TextDrawFont(winico[147][computer_id], 2);
        TextDrawColor(winico[147][computer_id], 0xD7613Aff);
        winico[147][used] = 1;
        winico[148][computer_id] = TextDrawCreate(30, 394, ".");
        TextDrawTextSize(winico[148][computer_id], 1, 1);
        TextDrawSetShadow(winico[148][computer_id], 0);
        TextDrawFont(winico[148][computer_id], 2);
        TextDrawColor(winico[148][computer_id], 0xDF743Cff);
        winico[148][used] = 1;
        winico[149][computer_id] = TextDrawCreate(31, 394, ".");
        TextDrawTextSize(winico[149][computer_id], 1, 1);
        TextDrawSetShadow(winico[149][computer_id], 0);
        TextDrawFont(winico[149][computer_id], 2);
        TextDrawColor(winico[149][computer_id], 0xE3833Bff);
        winico[149][used] = 1;
        winico[150][computer_id] = TextDrawCreate(32, 394, ".");
        TextDrawTextSize(winico[150][computer_id], 1, 1);
        TextDrawSetShadow(winico[150][computer_id], 0);
        TextDrawFont(winico[150][computer_id], 2);
        TextDrawColor(winico[150][computer_id], 0xE68B39ff);
        winico[150][used] = 1;
        winico[151][computer_id] = TextDrawCreate(33, 394, ".");
        TextDrawTextSize(winico[151][computer_id], 1, 1);
        TextDrawSetShadow(winico[151][computer_id], 0);
        TextDrawFont(winico[151][computer_id], 2);
        TextDrawColor(winico[151][computer_id], 0xE78C38ff);
        winico[151][used] = 1;
        winico[152][computer_id] = TextDrawCreate(34, 394, ".");
        TextDrawTextSize(winico[152][computer_id], 1, 1);
        TextDrawSetShadow(winico[152][computer_id], 0);
        TextDrawFont(winico[152][computer_id], 2);
        TextDrawColor(winico[152][computer_id], 0xDC8846ff);
        winico[152][used] = 1;
        winico[153][computer_id] = TextDrawCreate(35, 394, ".");
        TextDrawTextSize(winico[153][computer_id], 1, 1);
        TextDrawSetShadow(winico[153][computer_id], 0);
        TextDrawFont(winico[153][computer_id], 2);
        TextDrawColor(winico[153][computer_id], 0x375A58ff);
        winico[153][used] = 1;
        winico[154][computer_id] = TextDrawCreate(36, 394, ".");
        TextDrawTextSize(winico[154][computer_id], 1, 1);
        TextDrawSetShadow(winico[154][computer_id], 0);
        TextDrawFont(winico[154][computer_id], 2);
        TextDrawColor(winico[154][computer_id], 0x8EB842ff);
        winico[154][used] = 1;
        winico[155][computer_id] = TextDrawCreate(37, 394, ".");
        TextDrawTextSize(winico[155][computer_id], 1, 1);
        TextDrawSetShadow(winico[155][computer_id], 0);
        TextDrawFont(winico[155][computer_id], 2);
        TextDrawColor(winico[155][computer_id], 0x7EAC45ff);
        winico[155][used] = 1;
        winico[156][computer_id] = TextDrawCreate(38, 394, ".");
        TextDrawTextSize(winico[156][computer_id], 1, 1);
        TextDrawSetShadow(winico[156][computer_id], 0);
        TextDrawFont(winico[156][computer_id], 2);
        TextDrawColor(winico[156][computer_id], 0x4D754Eff);
        winico[156][used] = 1;
        winico[157][computer_id] = TextDrawCreate(39, 394, ".");
        TextDrawTextSize(winico[157][computer_id], 1, 1);
        TextDrawSetShadow(winico[157][computer_id], 0);
        TextDrawFont(winico[157][computer_id], 2);
        TextDrawColor(winico[157][computer_id], 0x244846ff);
        winico[157][used] = 1;
        winico[158][computer_id] = TextDrawCreate(40, 394, ".");
        TextDrawTextSize(winico[158][computer_id], 1, 1);
        TextDrawSetShadow(winico[158][computer_id], 0);
        TextDrawFont(winico[158][computer_id], 2);
        TextDrawColor(winico[158][computer_id], 0x265147ff);
        winico[158][used] = 1;
        winico[159][computer_id] = TextDrawCreate(41, 394, ".");
        TextDrawTextSize(winico[159][computer_id], 1, 1);
        TextDrawSetShadow(winico[159][computer_id], 0);
        TextDrawFont(winico[159][computer_id], 2);
        TextDrawColor(winico[159][computer_id], 0x296244ff);
        winico[159][used] = 1;
        winico[160][computer_id] = TextDrawCreate(42, 394, ".");
        TextDrawTextSize(winico[160][computer_id], 1, 1);
        TextDrawSetShadow(winico[160][computer_id], 0);
        TextDrawFont(winico[160][computer_id], 2);
        TextDrawColor(winico[160][computer_id], 0x2A7842ff);
        winico[160][used] = 1;
        winico[161][computer_id] = TextDrawCreate(43, 394, ".");
        TextDrawTextSize(winico[161][computer_id], 1, 1);
        TextDrawSetShadow(winico[161][computer_id], 0);
        TextDrawFont(winico[161][computer_id], 2);
        TextDrawColor(winico[161][computer_id], 0x315B56ff);
        winico[161][used] = 1;
        winico[162][computer_id] = TextDrawCreate(44, 394, ".");
        TextDrawTextSize(winico[162][computer_id], 1, 1);
        TextDrawSetShadow(winico[162][computer_id], 0);
        TextDrawFont(winico[162][computer_id], 2);
        TextDrawColor(winico[162][computer_id], 0x103962ff);
        winico[162][used] = 1;
        winico[163][computer_id] = TextDrawCreate(45, 394, ".");
        TextDrawTextSize(winico[163][computer_id], 1, 1);
        TextDrawSetShadow(winico[163][computer_id], 0);
        TextDrawFont(winico[163][computer_id], 2);
        TextDrawColor(winico[163][computer_id], 0x103D6Cff);
        winico[163][used] = 1;
        winico[164][computer_id] = TextDrawCreate(46, 394, ".");
        TextDrawTextSize(winico[164][computer_id], 1, 1);
        TextDrawSetShadow(winico[164][computer_id], 0);
        TextDrawFont(winico[164][computer_id], 2);
        TextDrawColor(winico[164][computer_id], 0x002F5Eff);
        winico[164][used] = 1;
        winico[165][computer_id] = TextDrawCreate(21, 395, ".");
        TextDrawTextSize(winico[165][computer_id], 1, 1);
        TextDrawSetShadow(winico[165][computer_id], 0);
        TextDrawFont(winico[165][computer_id], 2);
        TextDrawColor(winico[165][computer_id], 0x053D69ff);
        winico[165][used] = 1;
        winico[166][computer_id] = TextDrawCreate(22, 395, ".");
        TextDrawTextSize(winico[166][computer_id], 1, 1);
        TextDrawSetShadow(winico[166][computer_id], 0);
        TextDrawFont(winico[166][computer_id], 2);
        TextDrawColor(winico[166][computer_id], 0x08426Dff);
        winico[166][used] = 1;
        winico[167][computer_id] = TextDrawCreate(23, 395, ".");
        TextDrawTextSize(winico[167][computer_id], 1, 1);
        TextDrawSetShadow(winico[167][computer_id], 0);
        TextDrawFont(winico[167][computer_id], 2);
        TextDrawColor(winico[167][computer_id], 0x093F6Cff);
        winico[167][used] = 1;
        winico[168][computer_id] = TextDrawCreate(24, 395, ".");
        TextDrawTextSize(winico[168][computer_id], 1, 1);
        TextDrawSetShadow(winico[168][computer_id], 0);
        TextDrawFont(winico[168][computer_id], 2);
        TextDrawColor(winico[168][computer_id], 0x08416Cff);
        winico[168][used] = 1;
        winico[169][computer_id] = TextDrawCreate(25, 395, ".");
        TextDrawTextSize(winico[169][computer_id], 1, 1);
        TextDrawSetShadow(winico[169][computer_id], 0);
        TextDrawFont(winico[169][computer_id], 2);
        TextDrawColor(winico[169][computer_id], 0x0A3F69ff);
        winico[169][used] = 1;
        winico[170][computer_id] = TextDrawCreate(26, 395, ".");
        TextDrawTextSize(winico[170][computer_id], 1, 1);
        TextDrawSetShadow(winico[170][computer_id], 0);
        TextDrawFont(winico[170][computer_id], 2);
        TextDrawColor(winico[170][computer_id], 0x033760ff);
        winico[170][used] = 1;
        winico[171][computer_id] = TextDrawCreate(27, 395, ".");
        TextDrawTextSize(winico[171][computer_id], 1, 1);
        TextDrawSetShadow(winico[171][computer_id], 0);
        TextDrawFont(winico[171][computer_id], 2);
        TextDrawColor(winico[171][computer_id], 0xC85130ff);
        winico[171][used] = 1;
        winico[172][computer_id] = TextDrawCreate(28, 395, ".");
        TextDrawTextSize(winico[172][computer_id], 1, 1);
        TextDrawSetShadow(winico[172][computer_id], 0);
        TextDrawFont(winico[172][computer_id], 2);
        TextDrawColor(winico[172][computer_id], 0xD56025ff);
        winico[172][used] = 1;
        winico[173][computer_id] = TextDrawCreate(29, 395, ".");
        TextDrawTextSize(winico[173][computer_id], 1, 1);
        TextDrawSetShadow(winico[173][computer_id], 0);
        TextDrawFont(winico[173][computer_id], 2);
        TextDrawColor(winico[173][computer_id], 0xDD7827ff);
        winico[173][used] = 1;
        winico[174][computer_id] = TextDrawCreate(30, 395, ".");
        TextDrawTextSize(winico[174][computer_id], 1, 1);
        TextDrawSetShadow(winico[174][computer_id], 0);
        TextDrawFont(winico[174][computer_id], 2);
        TextDrawColor(winico[174][computer_id], 0xE88E28ff);
        winico[174][used] = 1;
        winico[175][computer_id] = TextDrawCreate(31, 395, ".");
        TextDrawTextSize(winico[175][computer_id], 1, 1);
        TextDrawSetShadow(winico[175][computer_id], 0);
        TextDrawFont(winico[175][computer_id], 2);
        TextDrawColor(winico[175][computer_id], 0xE99B2Aff);
        winico[175][used] = 1;
        winico[176][computer_id] = TextDrawCreate(32, 395, ".");
        TextDrawTextSize(winico[176][computer_id], 1, 1);
        TextDrawSetShadow(winico[176][computer_id], 0);
        TextDrawFont(winico[176][computer_id], 2);
        TextDrawColor(winico[176][computer_id], 0xECA529ff);
        winico[176][used] = 1;
        winico[177][computer_id] = TextDrawCreate(33, 395, ".");
        TextDrawTextSize(winico[177][computer_id], 1, 1);
        TextDrawSetShadow(winico[177][computer_id], 0);
        TextDrawFont(winico[177][computer_id], 2);
        TextDrawColor(winico[177][computer_id], 0xEEA729ff);
        winico[177][used] = 1;
        winico[178][computer_id] = TextDrawCreate(34, 395, ".");
        TextDrawTextSize(winico[178][computer_id], 1, 1);
        TextDrawSetShadow(winico[178][computer_id], 0);
        TextDrawFont(winico[178][computer_id], 2);
        TextDrawColor(winico[178][computer_id], 0x6C5946ff);
        winico[178][used] = 1;
        winico[179][computer_id] = TextDrawCreate(35, 395, ".");
        TextDrawTextSize(winico[179][computer_id], 1, 1);
        TextDrawSetShadow(winico[179][computer_id], 0);
        TextDrawFont(winico[179][computer_id], 2);
        TextDrawColor(winico[179][computer_id], 0x91AC68ff);
        winico[179][used] = 1;
        winico[180][computer_id] = TextDrawCreate(36, 395, ".");
        TextDrawTextSize(winico[180][computer_id], 1, 1);
        TextDrawSetShadow(winico[180][computer_id], 0);
        TextDrawFont(winico[180][computer_id], 2);
        TextDrawColor(winico[180][computer_id], 0xA0C453ff);
        winico[180][used] = 1;
        winico[181][computer_id] = TextDrawCreate(37, 395, ".");
        TextDrawTextSize(winico[181][computer_id], 1, 1);
        TextDrawSetShadow(winico[181][computer_id], 0);
        TextDrawFont(winico[181][computer_id], 2);
        TextDrawColor(winico[181][computer_id], 0x95BC43ff);
        winico[181][used] = 1;
        winico[182][computer_id] = TextDrawCreate(38, 395, ".");
        TextDrawTextSize(winico[182][computer_id], 1, 1);
        TextDrawSetShadow(winico[182][computer_id], 0);
        TextDrawFont(winico[182][computer_id], 2);
        TextDrawColor(winico[182][computer_id], 0x81AF37ff);
        winico[182][used] = 1;
        winico[183][computer_id] = TextDrawCreate(39, 395, ".");
        TextDrawTextSize(winico[183][computer_id], 1, 1);
        TextDrawSetShadow(winico[183][computer_id], 0);
        TextDrawFont(winico[183][computer_id], 2);
        TextDrawColor(winico[183][computer_id], 0x679F38ff);
        winico[183][used] = 1;
        winico[184][computer_id] = TextDrawCreate(40, 395, ".");
        TextDrawTextSize(winico[184][computer_id], 1, 1);
        TextDrawSetShadow(winico[184][computer_id], 0);
        TextDrawFont(winico[184][computer_id], 2);
        TextDrawColor(winico[184][computer_id], 0x4E8F39ff);
        winico[184][used] = 1;
        winico[185][computer_id] = TextDrawCreate(41, 395, ".");
        TextDrawTextSize(winico[185][computer_id], 1, 1);
        TextDrawSetShadow(winico[185][computer_id], 0);
        TextDrawFont(winico[185][computer_id], 2);
        TextDrawColor(winico[185][computer_id], 0x38833Bff);
        winico[185][used] = 1;
        winico[186][computer_id] = TextDrawCreate(42, 395, ".");
        TextDrawTextSize(winico[186][computer_id], 1, 1);
        TextDrawSetShadow(winico[186][computer_id], 0);
        TextDrawFont(winico[186][computer_id], 2);
        TextDrawColor(winico[186][computer_id], 0x34823Cff);
        winico[186][used] = 1;
        winico[187][computer_id] = TextDrawCreate(43, 395, ".");
        TextDrawTextSize(winico[187][computer_id], 1, 1);
        TextDrawSetShadow(winico[187][computer_id], 0);
        TextDrawFont(winico[187][computer_id], 2);
        TextDrawColor(winico[187][computer_id], 0x083557ff);
        winico[187][used] = 1;
        winico[188][computer_id] = TextDrawCreate(44, 395, ".");
        TextDrawTextSize(winico[188][computer_id], 1, 1);
        TextDrawSetShadow(winico[188][computer_id], 0);
        TextDrawFont(winico[188][computer_id], 2);
        TextDrawColor(winico[188][computer_id], 0x083966ff);
        winico[188][used] = 1;
        winico[189][computer_id] = TextDrawCreate(45, 395, ".");
        TextDrawTextSize(winico[189][computer_id], 1, 1);
        TextDrawSetShadow(winico[189][computer_id], 0);
        TextDrawFont(winico[189][computer_id], 2);
        TextDrawColor(winico[189][computer_id], 0x073D69ff);
        winico[189][used] = 1;
        winico[190][computer_id] = TextDrawCreate(46, 395, ".");
        TextDrawTextSize(winico[190][computer_id], 1, 1);
        TextDrawSetShadow(winico[190][computer_id], 0);
        TextDrawFont(winico[190][computer_id], 2);
        TextDrawColor(winico[190][computer_id], 0x013664ff);
        winico[190][used] = 1;
        winico[191][computer_id] = TextDrawCreate(20, 396, ".");
        TextDrawTextSize(winico[191][computer_id], 1, 1);
        TextDrawSetShadow(winico[191][computer_id], 0);
        TextDrawFont(winico[191][computer_id], 2);
        TextDrawColor(winico[191][computer_id], 0x01325Dff);
        winico[191][used] = 1;
        winico[192][computer_id] = TextDrawCreate(21, 396, ".");
        TextDrawTextSize(winico[192][computer_id], 1, 1);
        TextDrawSetShadow(winico[192][computer_id], 0);
        TextDrawFont(winico[192][computer_id], 2);
        TextDrawColor(winico[192][computer_id], 0x023F6Cff);
        winico[192][used] = 1;
        winico[193][computer_id] = TextDrawCreate(22, 396, ".");
        TextDrawTextSize(winico[193][computer_id], 1, 1);
        TextDrawSetShadow(winico[193][computer_id], 0);
        TextDrawFont(winico[193][computer_id], 2);
        TextDrawColor(winico[193][computer_id], 0x08406Eff);
        winico[193][used] = 1;
        winico[194][computer_id] = TextDrawCreate(23, 396, ".");
        TextDrawTextSize(winico[194][computer_id], 1, 1);
        TextDrawSetShadow(winico[194][computer_id], 0);
        TextDrawFont(winico[194][computer_id], 2);
        TextDrawColor(winico[194][computer_id], 0x0A4571ff);
        winico[194][used] = 1;
        winico[195][computer_id] = TextDrawCreate(24, 396, ".");
        TextDrawTextSize(winico[195][computer_id], 1, 1);
        TextDrawSetShadow(winico[195][computer_id], 0);
        TextDrawFont(winico[195][computer_id], 2);
        TextDrawColor(winico[195][computer_id], 0x064574ff);
        winico[195][used] = 1;
        winico[196][computer_id] = TextDrawCreate(25, 396, ".");
        TextDrawTextSize(winico[196][computer_id], 1, 1);
        TextDrawSetShadow(winico[196][computer_id], 0);
        TextDrawFont(winico[196][computer_id], 2);
        TextDrawColor(winico[196][computer_id], 0x014169ff);
        winico[196][used] = 1;
        winico[197][computer_id] = TextDrawCreate(26, 396, ".");
        TextDrawTextSize(winico[197][computer_id], 1, 1);
        TextDrawSetShadow(winico[197][computer_id], 0);
        TextDrawFont(winico[197][computer_id], 2);
        TextDrawColor(winico[197][computer_id], 0x00385Fff);
        winico[197][used] = 1;
        winico[198][computer_id] = TextDrawCreate(27, 396, ".");
        TextDrawTextSize(winico[198][computer_id], 1, 1);
        TextDrawSetShadow(winico[198][computer_id], 0);
        TextDrawFont(winico[198][computer_id], 2);
        TextDrawColor(winico[198][computer_id], 0xDC5620ff);
        winico[198][used] = 1;
        winico[199][computer_id] = TextDrawCreate(28, 396, ".");
        TextDrawTextSize(winico[199][computer_id], 1, 1);
        TextDrawSetShadow(winico[199][computer_id], 0);
        TextDrawFont(winico[199][computer_id], 2);
        TextDrawColor(winico[199][computer_id], 0xDE7029ff);
        winico[199][used] = 1;
        winico[200][computer_id] = TextDrawCreate(29, 396, ".");
        TextDrawTextSize(winico[200][computer_id], 1, 1);
        TextDrawSetShadow(winico[200][computer_id], 0);
        TextDrawFont(winico[200][computer_id], 2);
        TextDrawColor(winico[200][computer_id], 0xE68D29ff);
        winico[200][used] = 1;
        winico[201][computer_id] = TextDrawCreate(30, 396, ".");
        TextDrawTextSize(winico[201][computer_id], 1, 1);
        TextDrawSetShadow(winico[201][computer_id], 0);
        TextDrawFont(winico[201][computer_id], 2);
        TextDrawColor(winico[201][computer_id], 0xEBA02Bff);
        winico[201][used] = 1;
        winico[202][computer_id] = TextDrawCreate(31, 396, ".");
        TextDrawTextSize(winico[202][computer_id], 1, 1);
        TextDrawSetShadow(winico[202][computer_id], 0);
        TextDrawFont(winico[202][computer_id], 2);
        TextDrawColor(winico[202][computer_id], 0xF0B12Bff);
        winico[202][used] = 1;
        winico[203][computer_id] = TextDrawCreate(32, 396, ".");
        TextDrawTextSize(winico[203][computer_id], 1, 1);
        TextDrawSetShadow(winico[203][computer_id], 0);
        TextDrawFont(winico[203][computer_id], 2);
        TextDrawColor(winico[203][computer_id], 0xEFBA29ff);
        winico[203][used] = 1;
        winico[204][computer_id] = TextDrawCreate(33, 396, ".");
        TextDrawTextSize(winico[204][computer_id], 1, 1);
        TextDrawSetShadow(winico[204][computer_id], 0);
        TextDrawFont(winico[204][computer_id], 2);
        TextDrawColor(winico[204][computer_id], 0xFAC12Aff);
        winico[204][used] = 1;
        winico[205][computer_id] = TextDrawCreate(34, 396, ".");
        TextDrawTextSize(winico[205][computer_id], 1, 1);
        TextDrawSetShadow(winico[205][computer_id], 0);
        TextDrawFont(winico[205][computer_id], 2);
        TextDrawColor(winico[205][computer_id], 0x052241ff);
        winico[205][used] = 1;
        winico[206][computer_id] = TextDrawCreate(35, 396, ".");
        TextDrawTextSize(winico[206][computer_id], 1, 1);
        TextDrawSetShadow(winico[206][computer_id], 0);
        TextDrawFont(winico[206][computer_id], 2);
        TextDrawColor(winico[206][computer_id], 0xC3D97Cff);
        winico[206][used] = 1;
        winico[207][computer_id] = TextDrawCreate(36, 396, ".");
        TextDrawTextSize(winico[207][computer_id], 1, 1);
        TextDrawSetShadow(winico[207][computer_id], 0);
        TextDrawFont(winico[207][computer_id], 2);
        TextDrawColor(winico[207][computer_id], 0xAFCA69ff);
        winico[207][used] = 1;
        winico[208][computer_id] = TextDrawCreate(37, 396, ".");
        TextDrawTextSize(winico[208][computer_id], 1, 1);
        TextDrawSetShadow(winico[208][computer_id], 0);
        TextDrawFont(winico[208][computer_id], 2);
        TextDrawColor(winico[208][computer_id], 0xA3C456ff);
        winico[208][used] = 1;
        winico[209][computer_id] = TextDrawCreate(38, 396, ".");
        TextDrawTextSize(winico[209][computer_id], 1, 1);
        TextDrawSetShadow(winico[209][computer_id], 0);
        TextDrawFont(winico[209][computer_id], 2);
        TextDrawColor(winico[209][computer_id], 0x94BB43ff);
        winico[209][used] = 1;
        winico[210][computer_id] = TextDrawCreate(39, 396, ".");
        TextDrawTextSize(winico[210][computer_id], 1, 1);
        TextDrawSetShadow(winico[210][computer_id], 0);
        TextDrawFont(winico[210][computer_id], 2);
        TextDrawColor(winico[210][computer_id], 0x79AB38ff);
        winico[210][used] = 1;
        winico[211][computer_id] = TextDrawCreate(40, 396, ".");
        TextDrawTextSize(winico[211][computer_id], 1, 1);
        TextDrawSetShadow(winico[211][computer_id], 0);
        TextDrawFont(winico[211][computer_id], 2);
        TextDrawColor(winico[211][computer_id], 0x5E963Aff);
        winico[211][used] = 1;
        winico[212][computer_id] = TextDrawCreate(41, 396, ".");
        TextDrawTextSize(winico[212][computer_id], 1, 1);
        TextDrawSetShadow(winico[212][computer_id], 0);
        TextDrawFont(winico[212][computer_id], 2);
        TextDrawColor(winico[212][computer_id], 0x448937ff);
        winico[212][used] = 1;
        winico[213][computer_id] = TextDrawCreate(42, 396, ".");
        TextDrawTextSize(winico[213][computer_id], 1, 1);
        TextDrawSetShadow(winico[213][computer_id], 0);
        TextDrawFont(winico[213][computer_id], 2);
        TextDrawColor(winico[213][computer_id], 0x458947ff);
        winico[213][used] = 1;
        winico[214][computer_id] = TextDrawCreate(43, 396, ".");
        TextDrawTextSize(winico[214][computer_id], 1, 1);
        TextDrawSetShadow(winico[214][computer_id], 0);
        TextDrawFont(winico[214][computer_id], 2);
        TextDrawColor(winico[214][computer_id], 0x033763ff);
        winico[214][used] = 1;
        winico[215][computer_id] = TextDrawCreate(44, 396, ".");
        TextDrawTextSize(winico[215][computer_id], 1, 1);
        TextDrawSetShadow(winico[215][computer_id], 0);
        TextDrawFont(winico[215][computer_id], 2);
        TextDrawColor(winico[215][computer_id], 0x093E67ff);
        winico[215][used] = 1;
        winico[216][computer_id] = TextDrawCreate(45, 396, ".");
        TextDrawTextSize(winico[216][computer_id], 1, 1);
        TextDrawSetShadow(winico[216][computer_id], 0);
        TextDrawFont(winico[216][computer_id], 2);
        TextDrawColor(winico[216][computer_id], 0x09406Cff);
        winico[216][used] = 1;
        winico[217][computer_id] = TextDrawCreate(46, 396, ".");
        TextDrawTextSize(winico[217][computer_id], 1, 1);
        TextDrawSetShadow(winico[217][computer_id], 0);
        TextDrawFont(winico[217][computer_id], 2);
        TextDrawColor(winico[217][computer_id], 0x013D68ff);
        winico[217][used] = 1;
        winico[218][computer_id] = TextDrawCreate(47, 396, ".");
        TextDrawTextSize(winico[218][computer_id], 1, 1);
        TextDrawSetShadow(winico[218][computer_id], 0);
        TextDrawFont(winico[218][computer_id], 2);
        TextDrawColor(winico[218][computer_id], 0x4D708Bff);
        winico[218][used] = 1;
        winico[219][computer_id] = TextDrawCreate(20, 397, ".");
        TextDrawTextSize(winico[219][computer_id], 1, 1);
        TextDrawSetShadow(winico[219][computer_id], 0);
        TextDrawFont(winico[219][computer_id], 2);
        TextDrawColor(winico[219][computer_id], 0x002D5Cff);
        winico[219][used] = 1;
        winico[220][computer_id] = TextDrawCreate(21, 397, ".");
        TextDrawTextSize(winico[220][computer_id], 1, 1);
        TextDrawSetShadow(winico[220][computer_id], 0);
        TextDrawFont(winico[220][computer_id], 2);
        TextDrawColor(winico[220][computer_id], 0x01426Eff);
        winico[220][used] = 1;
        winico[221][computer_id] = TextDrawCreate(22, 397, ".");
        TextDrawTextSize(winico[221][computer_id], 1, 1);
        TextDrawSetShadow(winico[221][computer_id], 0);
        TextDrawFont(winico[221][computer_id], 2);
        TextDrawColor(winico[221][computer_id], 0x004772ff);
        winico[221][used] = 1;
        winico[222][computer_id] = TextDrawCreate(24, 397, ".");
        TextDrawTextSize(winico[222][computer_id], 2, 1);
        TextDrawSetShadow(winico[222][computer_id], 0);
        TextDrawFont(winico[222][computer_id], 2);
        TextDrawColor(winico[222][computer_id], 0x004A75ff);
        winico[222][used] = 1;
        winico[223][computer_id] = TextDrawCreate(25, 397, ".");
        TextDrawTextSize(winico[223][computer_id], 1, 1);
        TextDrawSetShadow(winico[223][computer_id], 0);
        TextDrawFont(winico[223][computer_id], 2);
        TextDrawColor(winico[223][computer_id], 0x024672ff);
        winico[223][used] = 1;
        winico[224][computer_id] = TextDrawCreate(26, 397, ".");
        TextDrawTextSize(winico[224][computer_id], 1, 1);
        TextDrawSetShadow(winico[224][computer_id], 0);
        TextDrawFont(winico[224][computer_id], 2);
        TextDrawColor(winico[224][computer_id], 0x454955ff);
        winico[224][used] = 1;
        winico[225][computer_id] = TextDrawCreate(27, 397, ".");
        TextDrawTextSize(winico[225][computer_id], 1, 1);
        TextDrawSetShadow(winico[225][computer_id], 0);
        TextDrawFont(winico[225][computer_id], 2);
        TextDrawColor(winico[225][computer_id], 0xD45D22ff);
        winico[225][used] = 1;
        winico[226][computer_id] = TextDrawCreate(28, 397, ".");
        TextDrawTextSize(winico[226][computer_id], 1, 1);
        TextDrawSetShadow(winico[226][computer_id], 0);
        TextDrawFont(winico[226][computer_id], 2);
        TextDrawColor(winico[226][computer_id], 0xE88129ff);
        winico[226][used] = 1;
        winico[227][computer_id] = TextDrawCreate(29, 397, ".");
        TextDrawTextSize(winico[227][computer_id], 1, 1);
        TextDrawSetShadow(winico[227][computer_id], 0);
        TextDrawFont(winico[227][computer_id], 2);
        TextDrawColor(winico[227][computer_id], 0xF49E2Cff);
        winico[227][used] = 1;
        winico[228][computer_id] = TextDrawCreate(30, 397, ".");
        TextDrawTextSize(winico[228][computer_id], 1, 1);
        TextDrawSetShadow(winico[228][computer_id], 0);
        TextDrawFont(winico[228][computer_id], 2);
        TextDrawColor(winico[228][computer_id], 0xFBB42Bff);
        winico[228][used] = 1;
        winico[229][computer_id] = TextDrawCreate(31, 397, ".");
        TextDrawTextSize(winico[229][computer_id], 1, 1);
        TextDrawSetShadow(winico[229][computer_id], 0);
        TextDrawFont(winico[229][computer_id], 2);
        TextDrawColor(winico[229][computer_id], 0xF4C52Cff);
        winico[229][used] = 1;
        winico[230][computer_id] = TextDrawCreate(32, 397, ".");
        TextDrawTextSize(winico[230][computer_id], 1, 1);
        TextDrawSetShadow(winico[230][computer_id], 0);
        TextDrawFont(winico[230][computer_id], 2);
        TextDrawColor(winico[230][computer_id], 0xF3CA2Cff);
        winico[230][used] = 1;
        winico[231][computer_id] = TextDrawCreate(33, 397, ".");
        TextDrawTextSize(winico[231][computer_id], 1, 1);
        TextDrawSetShadow(winico[231][computer_id], 0);
        TextDrawFont(winico[231][computer_id], 2);
        TextDrawColor(winico[231][computer_id], 0xF9C832ff);
        winico[231][used] = 1;
        winico[232][computer_id] = TextDrawCreate(34, 397, ".");
        TextDrawTextSize(winico[232][computer_id], 1, 1);
        TextDrawSetShadow(winico[232][computer_id], 0);
        TextDrawFont(winico[232][computer_id], 2);
        TextDrawColor(winico[232][computer_id], 0x08364Aff);
        winico[232][used] = 1;
        winico[233][computer_id] = TextDrawCreate(35, 397, ".");
        TextDrawTextSize(winico[233][computer_id], 1, 1);
        TextDrawSetShadow(winico[233][computer_id], 0);
        TextDrawFont(winico[233][computer_id], 2);
        TextDrawColor(winico[233][computer_id], 0xC8DC88ff);
        winico[233][used] = 1;
        winico[234][computer_id] = TextDrawCreate(36, 397, ".");
        TextDrawTextSize(winico[234][computer_id], 1, 1);
        TextDrawSetShadow(winico[234][computer_id], 0);
        TextDrawFont(winico[234][computer_id], 2);
        TextDrawColor(winico[234][computer_id], 0xB9D277ff);
        winico[234][used] = 1;
        winico[235][computer_id] = TextDrawCreate(37, 397, ".");
        TextDrawTextSize(winico[235][computer_id], 1, 1);
        TextDrawSetShadow(winico[235][computer_id], 0);
        TextDrawFont(winico[235][computer_id], 2);
        TextDrawColor(winico[235][computer_id], 0xACCA67ff);
        winico[235][used] = 1;
        winico[236][computer_id] = TextDrawCreate(38, 397, ".");
        TextDrawTextSize(winico[236][computer_id], 1, 1);
        TextDrawSetShadow(winico[236][computer_id], 0);
        TextDrawFont(winico[236][computer_id], 2);
        TextDrawColor(winico[236][computer_id], 0x9DC24Fff);
        winico[236][used] = 1;
        winico[237][computer_id] = TextDrawCreate(39, 397, ".");
        TextDrawTextSize(winico[237][computer_id], 1, 1);
        TextDrawSetShadow(winico[237][computer_id], 0);
        TextDrawFont(winico[237][computer_id], 2);
        TextDrawColor(winico[237][computer_id], 0x89B43Bff);
        winico[237][used] = 1;
        winico[238][computer_id] = TextDrawCreate(40, 397, ".");
        TextDrawTextSize(winico[238][computer_id], 1, 1);
        TextDrawSetShadow(winico[238][computer_id], 0);
        TextDrawFont(winico[238][computer_id], 2);
        TextDrawColor(winico[238][computer_id], 0x6A9F3Aff);
        winico[238][used] = 1;
        winico[239][computer_id] = TextDrawCreate(41, 397, ".");
        TextDrawTextSize(winico[239][computer_id], 1, 1);
        TextDrawSetShadow(winico[239][computer_id], 0);
        TextDrawFont(winico[239][computer_id], 2);
        TextDrawColor(winico[239][computer_id], 0x4D8D37ff);
        winico[239][used] = 1;
        winico[240][computer_id] = TextDrawCreate(42, 397, ".");
        TextDrawTextSize(winico[240][computer_id], 1, 1);
        TextDrawSetShadow(winico[240][computer_id], 0);
        TextDrawFont(winico[240][computer_id], 2);
        TextDrawColor(winico[240][computer_id], 0x2A6556ff);
        winico[240][used] = 1;
        winico[241][computer_id] = TextDrawCreate(43, 397, ".");
        TextDrawTextSize(winico[241][computer_id], 1, 1);
        TextDrawSetShadow(winico[241][computer_id], 0);
        TextDrawFont(winico[241][computer_id], 2);
        TextDrawColor(winico[241][computer_id], 0x013F68ff);
        winico[241][used] = 1;
        winico[242][computer_id] = TextDrawCreate(44, 397, ".");
        TextDrawTextSize(winico[242][computer_id], 1, 1);
        TextDrawSetShadow(winico[242][computer_id], 0);
        TextDrawFont(winico[242][computer_id], 2);
        TextDrawColor(winico[242][computer_id], 0x004573ff);
        winico[242][used] = 1;
        winico[243][computer_id] = TextDrawCreate(45, 397, ".");
        TextDrawTextSize(winico[243][computer_id], 1, 1);
        TextDrawSetShadow(winico[243][computer_id], 0);
        TextDrawFont(winico[243][computer_id], 2);
        TextDrawColor(winico[243][computer_id], 0x014572ff);
        winico[243][used] = 1;
        winico[244][computer_id] = TextDrawCreate(46, 397, ".");
        TextDrawTextSize(winico[244][computer_id], 1, 1);
        TextDrawSetShadow(winico[244][computer_id], 0);
        TextDrawFont(winico[244][computer_id], 2);
        TextDrawColor(winico[244][computer_id], 0x024371ff);
        winico[244][used] = 1;
        winico[245][computer_id] = TextDrawCreate(47, 397, ".");
        TextDrawTextSize(winico[245][computer_id], 1, 1);
        TextDrawSetShadow(winico[245][computer_id], 0);
        TextDrawFont(winico[245][computer_id], 2);
        TextDrawColor(winico[245][computer_id], 0x043662ff);
        winico[245][used] = 1;
        winico[246][computer_id] = TextDrawCreate(20, 398, ".");
        TextDrawTextSize(winico[246][computer_id], 1, 1);
        TextDrawSetShadow(winico[246][computer_id], 0);
        TextDrawFont(winico[246][computer_id], 2);
        TextDrawColor(winico[246][computer_id], 0x003463ff);
        winico[246][used] = 1;
        winico[247][computer_id] = TextDrawCreate(21, 398, ".");
        TextDrawTextSize(winico[247][computer_id], 1, 1);
        TextDrawSetShadow(winico[247][computer_id], 0);
        TextDrawFont(winico[247][computer_id], 2);
        TextDrawColor(winico[247][computer_id], 0x014672ff);
        winico[247][used] = 1;
        winico[248][computer_id] = TextDrawCreate(22, 398, ".");
        TextDrawTextSize(winico[248][computer_id], 1, 1);
        TextDrawSetShadow(winico[248][computer_id], 0);
        TextDrawFont(winico[248][computer_id], 2);
        TextDrawColor(winico[248][computer_id], 0x004A7Cff);
        winico[248][used] = 1;
        winico[249][computer_id] = TextDrawCreate(23, 398, ".");
        TextDrawTextSize(winico[249][computer_id], 1, 1);
        TextDrawSetShadow(winico[249][computer_id], 0);
        TextDrawFont(winico[249][computer_id], 2);
        TextDrawColor(winico[249][computer_id], 0x014D7Bff);
        winico[249][used] = 1;
        winico[250][computer_id] = TextDrawCreate(24, 398, ".");
        TextDrawTextSize(winico[250][computer_id], 1, 1);
        TextDrawSetShadow(winico[250][computer_id], 0);
        TextDrawFont(winico[250][computer_id], 2);
        TextDrawColor(winico[250][computer_id], 0x004E7Cff);
        winico[250][used] = 1;
        winico[251][computer_id] = TextDrawCreate(25, 398, ".");
        TextDrawTextSize(winico[251][computer_id], 1, 1);
        TextDrawSetShadow(winico[251][computer_id], 0);
        TextDrawFont(winico[251][computer_id], 2);
        TextDrawColor(winico[251][computer_id], 0x014772ff);
        winico[251][used] = 1;
        winico[252][computer_id] = TextDrawCreate(26, 398, ".");
        TextDrawTextSize(winico[252][computer_id], 1, 1);
        TextDrawSetShadow(winico[252][computer_id], 0);
        TextDrawFont(winico[252][computer_id], 2);
        TextDrawColor(winico[252][computer_id], 0xB26141ff);
        winico[252][used] = 1;
        winico[253][computer_id] = TextDrawCreate(27, 398, ".");
        TextDrawTextSize(winico[253][computer_id], 1, 1);
        TextDrawSetShadow(winico[253][computer_id], 0);
        TextDrawFont(winico[253][computer_id], 2);
        TextDrawColor(winico[253][computer_id], 0x784C39ff);
        winico[253][used] = 1;
        winico[254][computer_id] = TextDrawCreate(28, 398, ".");
        TextDrawTextSize(winico[254][computer_id], 1, 1);
        TextDrawSetShadow(winico[254][computer_id], 0);
        TextDrawFont(winico[254][computer_id], 2);
        TextDrawColor(winico[254][computer_id], 0x0F2A44ff);
        winico[254][used] = 1;
        winico[255][computer_id] = TextDrawCreate(29, 398, ".");
        TextDrawTextSize(winico[255][computer_id], 1, 1);
        TextDrawSetShadow(winico[255][computer_id], 0);
        TextDrawFont(winico[255][computer_id], 2);
        TextDrawColor(winico[255][computer_id], 0x002143ff);
        winico[255][used] = 1;
        winico[256][computer_id] = TextDrawCreate(30, 398, ".");
        TextDrawTextSize(winico[256][computer_id], 1, 1);
        TextDrawSetShadow(winico[256][computer_id], 0);
        TextDrawFont(winico[256][computer_id], 2);
        TextDrawColor(winico[256][computer_id], 0x002043ff);
        winico[256][used] = 1;
        winico[257][computer_id] = TextDrawCreate(31, 398, ".");
        TextDrawTextSize(winico[257][computer_id], 1, 1);
        TextDrawSetShadow(winico[257][computer_id], 0);
        TextDrawFont(winico[257][computer_id], 2);
        TextDrawColor(winico[257][computer_id], 0x2C3141ff);
        winico[257][used] = 1;
        winico[258][computer_id] = TextDrawCreate(32, 398, ".");
        TextDrawTextSize(winico[258][computer_id], 1, 1);
        TextDrawSetShadow(winico[258][computer_id], 0);
        TextDrawFont(winico[258][computer_id], 2);
        TextDrawColor(winico[258][computer_id], 0xE5932Bff);
        winico[258][used] = 1;
        winico[259][computer_id] = TextDrawCreate(33, 398, ".");
        TextDrawTextSize(winico[259][computer_id], 1, 1);
        TextDrawSetShadow(winico[259][computer_id], 0);
        TextDrawFont(winico[259][computer_id], 2);
        TextDrawColor(winico[259][computer_id], 0xAE9140ff);
        winico[259][used] = 1;
        winico[260][computer_id] = TextDrawCreate(34, 398, ".");
        TextDrawTextSize(winico[260][computer_id], 1, 1);
        TextDrawSetShadow(winico[260][computer_id], 0);
        TextDrawFont(winico[260][computer_id], 2);
        TextDrawColor(winico[260][computer_id], 0x6E906Bff);
        winico[260][used] = 1;
        winico[261][computer_id] = TextDrawCreate(35, 398, ".");
        TextDrawTextSize(winico[261][computer_id], 1, 1);
        TextDrawSetShadow(winico[261][computer_id], 0);
        TextDrawFont(winico[261][computer_id], 2);
        TextDrawColor(winico[261][computer_id], 0xCEDC91ff);
        winico[261][used] = 1;
        winico[262][computer_id] = TextDrawCreate(36, 398, ".");
        TextDrawTextSize(winico[262][computer_id], 1, 1);
        TextDrawSetShadow(winico[262][computer_id], 0);
        TextDrawFont(winico[262][computer_id], 2);
        TextDrawColor(winico[262][computer_id], 0xC1D785ff);
        winico[262][used] = 1;
        winico[263][computer_id] = TextDrawCreate(37, 398, ".");
        TextDrawTextSize(winico[263][computer_id], 1, 1);
        TextDrawSetShadow(winico[263][computer_id], 0);
        TextDrawFont(winico[263][computer_id], 2);
        TextDrawColor(winico[263][computer_id], 0xB6CF71ff);
        winico[263][used] = 1;
        winico[264][computer_id] = TextDrawCreate(38, 398, ".");
        TextDrawTextSize(winico[264][computer_id], 1, 1);
        TextDrawSetShadow(winico[264][computer_id], 0);
        TextDrawFont(winico[264][computer_id], 2);
        TextDrawColor(winico[264][computer_id], 0xA5C55Aff);
        winico[264][used] = 1;
        winico[265][computer_id] = TextDrawCreate(39, 398, ".");
        TextDrawTextSize(winico[265][computer_id], 1, 1);
        TextDrawSetShadow(winico[265][computer_id], 0);
        TextDrawFont(winico[265][computer_id], 2);
        TextDrawColor(winico[265][computer_id], 0x91BA3Fff);
        winico[265][used] = 1;
        winico[266][computer_id] = TextDrawCreate(40, 398, ".");
        TextDrawTextSize(winico[266][computer_id], 1, 1);
        TextDrawSetShadow(winico[266][computer_id], 0);
        TextDrawFont(winico[266][computer_id], 2);
        TextDrawColor(winico[266][computer_id], 0x71A639ff);
        winico[266][used] = 1;
        winico[267][computer_id] = TextDrawCreate(41, 398, ".");
        TextDrawTextSize(winico[267][computer_id], 1, 1);
        TextDrawSetShadow(winico[267][computer_id], 0);
        TextDrawFont(winico[267][computer_id], 2);
        TextDrawColor(winico[267][computer_id], 0x569537ff);
        winico[267][used] = 1;
        winico[268][computer_id] = TextDrawCreate(42, 398, ".");
        TextDrawTextSize(winico[268][computer_id], 1, 1);
        TextDrawSetShadow(winico[268][computer_id], 0);
        TextDrawFont(winico[268][computer_id], 2);
        TextDrawColor(winico[268][computer_id], 0x074261ff);
        winico[268][used] = 1;
        winico[269][computer_id] = TextDrawCreate(43, 398, ".");
        TextDrawTextSize(winico[269][computer_id], 1, 1);
        TextDrawSetShadow(winico[269][computer_id], 0);
        TextDrawFont(winico[269][computer_id], 2);
        TextDrawColor(winico[269][computer_id], 0x004774ff);
        winico[269][used] = 1;
        winico[270][computer_id] = TextDrawCreate(44, 398, ".");
        TextDrawTextSize(winico[270][computer_id], 1, 1);
        TextDrawSetShadow(winico[270][computer_id], 0);
        TextDrawFont(winico[270][computer_id], 2);
        TextDrawColor(winico[270][computer_id], 0x004C7Aff);
        winico[270][used] = 1;
        winico[271][computer_id] = TextDrawCreate(45, 398, ".");
        TextDrawTextSize(winico[271][computer_id], 1, 1);
        TextDrawSetShadow(winico[271][computer_id], 0);
        TextDrawFont(winico[271][computer_id], 2);
        TextDrawColor(winico[271][computer_id], 0x004B79ff);
        winico[271][used] = 1;
        winico[272][computer_id] = TextDrawCreate(46, 398, ".");
        TextDrawTextSize(winico[272][computer_id], 1, 1);
        TextDrawSetShadow(winico[272][computer_id], 0);
        TextDrawFont(winico[272][computer_id], 2);
        TextDrawColor(winico[272][computer_id], 0x014876ff);
        winico[272][used] = 1;
        winico[273][computer_id] = TextDrawCreate(47, 398, ".");
        TextDrawTextSize(winico[273][computer_id], 1, 1);
        TextDrawSetShadow(winico[273][computer_id], 0);
        TextDrawFont(winico[273][computer_id], 2);
        TextDrawColor(winico[273][computer_id], 0x003766ff);
        winico[273][used] = 1;
        winico[274][computer_id] = TextDrawCreate(20, 399, ".");
        TextDrawTextSize(winico[274][computer_id], 1, 1);
        TextDrawSetShadow(winico[274][computer_id], 0);
        TextDrawFont(winico[274][computer_id], 2);
        TextDrawColor(winico[274][computer_id], 0x003E6Aff);
        winico[274][used] = 1;
        winico[275][computer_id] = TextDrawCreate(21, 399, ".");
        TextDrawTextSize(winico[275][computer_id], 1, 1);
        TextDrawSetShadow(winico[275][computer_id], 0);
        TextDrawFont(winico[275][computer_id], 2);
        TextDrawColor(winico[275][computer_id], 0x004D7Dff);
        winico[275][used] = 1;
        winico[276][computer_id] = TextDrawCreate(22, 399, ".");
        TextDrawTextSize(winico[276][computer_id], 1, 1);
        TextDrawSetShadow(winico[276][computer_id], 0);
        TextDrawFont(winico[276][computer_id], 2);
        TextDrawColor(winico[276][computer_id], 0x015284ff);
        winico[276][used] = 1;
        winico[277][computer_id] = TextDrawCreate(23, 399, ".");
        TextDrawTextSize(winico[277][computer_id], 1, 1);
        TextDrawSetShadow(winico[277][computer_id], 0);
        TextDrawFont(winico[277][computer_id], 2);
        TextDrawColor(winico[277][computer_id], 0x005284ff);
        winico[277][used] = 1;
        winico[278][computer_id] = TextDrawCreate(24, 399, ".");
        TextDrawTextSize(winico[278][computer_id], 1, 1);
        TextDrawSetShadow(winico[278][computer_id], 0);
        TextDrawFont(winico[278][computer_id], 2);
        TextDrawColor(winico[278][computer_id], 0x004F7Dff);
        winico[278][used] = 1;
        winico[279][computer_id] = TextDrawCreate(25, 399, ".");
        TextDrawTextSize(winico[279][computer_id], 1, 1);
        TextDrawSetShadow(winico[279][computer_id], 0);
        TextDrawFont(winico[279][computer_id], 2);
        TextDrawColor(winico[279][computer_id], 0x00456Fff);
        winico[279][used] = 1;
        winico[280][computer_id] = TextDrawCreate(26, 399, ".");
        TextDrawTextSize(winico[280][computer_id], 1, 1);
        TextDrawSetShadow(winico[280][computer_id], 0);
        TextDrawFont(winico[280][computer_id], 2);
        TextDrawColor(winico[280][computer_id], 0x3786C5ff);
        winico[280][used] = 1;
        winico[281][computer_id] = TextDrawCreate(27, 399, ".");
        TextDrawTextSize(winico[281][computer_id], 1, 1);
        TextDrawSetShadow(winico[281][computer_id], 0);
        TextDrawFont(winico[281][computer_id], 2);
        TextDrawColor(winico[281][computer_id], 0x4697CFff);
        winico[281][used] = 1;
        winico[282][computer_id] = TextDrawCreate(28, 399, ".");
        TextDrawTextSize(winico[282][computer_id], 1, 1);
        TextDrawSetShadow(winico[282][computer_id], 0);
        TextDrawFont(winico[282][computer_id], 2);
        TextDrawColor(winico[282][computer_id], 0x72A7D7ff);
        winico[282][used] = 1;
        winico[283][computer_id] = TextDrawCreate(29, 399, ".");
        TextDrawTextSize(winico[283][computer_id], 1, 1);
        TextDrawSetShadow(winico[283][computer_id], 0);
        TextDrawFont(winico[283][computer_id], 2);
        TextDrawColor(winico[283][computer_id], 0x98BBE2ff);
        winico[283][used] = 1;
        winico[284][computer_id] = TextDrawCreate(30, 399, ".");
        TextDrawTextSize(winico[284][computer_id], 1, 1);
        TextDrawSetShadow(winico[284][computer_id], 0);
        TextDrawFont(winico[284][computer_id], 2);
        TextDrawColor(winico[284][computer_id], 0xB7D4EFff);
        winico[284][used] = 1;
        winico[285][computer_id] = TextDrawCreate(31, 399, ".");
        TextDrawTextSize(winico[285][computer_id], 1, 1);
        TextDrawSetShadow(winico[285][computer_id], 0);
        TextDrawFont(winico[285][computer_id], 2);
        TextDrawColor(winico[285][computer_id], 0xD1E3F8ff);
        winico[285][used] = 1;
        winico[286][computer_id] = TextDrawCreate(32, 399, ".");
        TextDrawTextSize(winico[286][computer_id], 1, 1);
        TextDrawSetShadow(winico[286][computer_id], 0);
        TextDrawFont(winico[286][computer_id], 2);
        TextDrawColor(winico[286][computer_id], 0xCEE0EFff);
        winico[286][used] = 1;
        winico[287][computer_id] = TextDrawCreate(33, 399, ".");
        TextDrawTextSize(winico[287][computer_id], 1, 1);
        TextDrawSetShadow(winico[287][computer_id], 0);
        TextDrawFont(winico[287][computer_id], 2);
        TextDrawColor(winico[287][computer_id], 0x003961ff);
        winico[287][used] = 1;
        winico[288][computer_id] = TextDrawCreate(34, 399, ".");
        TextDrawTextSize(winico[288][computer_id], 1, 1);
        TextDrawSetShadow(winico[288][computer_id], 0);
        TextDrawFont(winico[288][computer_id], 2);
        TextDrawColor(winico[288][computer_id], 0x548758ff);
        winico[288][used] = 1;
        winico[289][computer_id] = TextDrawCreate(35, 399, ".");
        TextDrawTextSize(winico[289][computer_id], 1, 1);
        TextDrawSetShadow(winico[289][computer_id], 0);
        TextDrawFont(winico[289][computer_id], 2);
        TextDrawColor(winico[289][computer_id], 0xD8E699ff);
        winico[289][used] = 1;
        winico[290][computer_id] = TextDrawCreate(36, 399, ".");
        TextDrawTextSize(winico[290][computer_id], 1, 1);
        TextDrawSetShadow(winico[290][computer_id], 0);
        TextDrawFont(winico[290][computer_id], 2);
        TextDrawColor(winico[290][computer_id], 0xC6DA89ff);
        winico[290][used] = 1;
        winico[291][computer_id] = TextDrawCreate(37, 399, ".");
        TextDrawTextSize(winico[291][computer_id], 1, 1);
        TextDrawSetShadow(winico[291][computer_id], 0);
        TextDrawFont(winico[291][computer_id], 2);
        TextDrawColor(winico[291][computer_id], 0xB9D076ff);
        winico[291][used] = 1;
        winico[292][computer_id] = TextDrawCreate(38, 399, ".");
        TextDrawTextSize(winico[292][computer_id], 1, 1);
        TextDrawSetShadow(winico[292][computer_id], 0);
        TextDrawFont(winico[292][computer_id], 2);
        TextDrawColor(winico[292][computer_id], 0xA8C75Fff);
        winico[292][used] = 1;
        winico[293][computer_id] = TextDrawCreate(39, 399, ".");
        TextDrawTextSize(winico[293][computer_id], 1, 1);
        TextDrawSetShadow(winico[293][computer_id], 0);
        TextDrawFont(winico[293][computer_id], 2);
        TextDrawColor(winico[293][computer_id], 0x96BC45ff);
        winico[293][used] = 1;
        winico[294][computer_id] = TextDrawCreate(40, 399, ".");
        TextDrawTextSize(winico[294][computer_id], 1, 1);
        TextDrawSetShadow(winico[294][computer_id], 0);
        TextDrawFont(winico[294][computer_id], 2);
        TextDrawColor(winico[294][computer_id], 0x7DAC38ff);
        winico[294][used] = 1;
        winico[295][computer_id] = TextDrawCreate(41, 399, ".");
        TextDrawTextSize(winico[295][computer_id], 1, 1);
        TextDrawSetShadow(winico[295][computer_id], 0);
        TextDrawFont(winico[295][computer_id], 2);
        TextDrawColor(winico[295][computer_id], 0x609748ff);
        winico[295][used] = 1;
        winico[296][computer_id] = TextDrawCreate(42, 399, ".");
        TextDrawTextSize(winico[296][computer_id], 1, 1);
        TextDrawSetShadow(winico[296][computer_id], 0);
        TextDrawFont(winico[296][computer_id], 2);
        TextDrawColor(winico[296][computer_id], 0x004877ff);
        winico[296][used] = 1;
        winico[297][computer_id] = TextDrawCreate(43, 399, ".");
        TextDrawTextSize(winico[297][computer_id], 1, 1);
        TextDrawSetShadow(winico[297][computer_id], 0);
        TextDrawFont(winico[297][computer_id], 2);
        TextDrawColor(winico[297][computer_id], 0x025284ff);
        winico[297][used] = 1;
        winico[298][computer_id] = TextDrawCreate(44, 399, ".");
        TextDrawTextSize(winico[298][computer_id], 1, 1);
        TextDrawSetShadow(winico[298][computer_id], 0);
        TextDrawFont(winico[298][computer_id], 2);
        TextDrawColor(winico[298][computer_id], 0x005286ff);
        winico[298][used] = 1;
        winico[299][computer_id] = TextDrawCreate(45, 399, ".");
        TextDrawTextSize(winico[299][computer_id], 1, 1);
        TextDrawSetShadow(winico[299][computer_id], 0);
        TextDrawFont(winico[299][computer_id], 2);
        TextDrawColor(winico[299][computer_id], 0x005285ff);
        winico[299][used] = 1;
        winico[300][computer_id] = TextDrawCreate(46, 399, ".");
        TextDrawTextSize(winico[300][computer_id], 1, 1);
        TextDrawSetShadow(winico[300][computer_id], 0);
        TextDrawFont(winico[300][computer_id], 2);
        TextDrawColor(winico[300][computer_id], 0x024D7Fff);
        winico[300][used] = 1;
        winico[301][computer_id] = TextDrawCreate(47, 399, ".");
        TextDrawTextSize(winico[301][computer_id], 1, 1);
        TextDrawSetShadow(winico[301][computer_id], 0);
        TextDrawFont(winico[301][computer_id], 2);
        TextDrawColor(winico[301][computer_id], 0x004071ff);
        winico[301][used] = 1;
        winico[302][computer_id] = TextDrawCreate(20, 400, ".");
        TextDrawTextSize(winico[302][computer_id], 1, 1);
        TextDrawSetShadow(winico[302][computer_id], 0);
        TextDrawFont(winico[302][computer_id], 2);
        TextDrawColor(winico[302][computer_id], 0x004374ff);
        winico[302][used] = 1;
        winico[303][computer_id] = TextDrawCreate(21, 400, ".");
        TextDrawTextSize(winico[303][computer_id], 1, 1);
        TextDrawSetShadow(winico[303][computer_id], 0);
        TextDrawFont(winico[303][computer_id], 2);
        TextDrawColor(winico[303][computer_id], 0x015285ff);
        winico[303][used] = 1;
        winico[304][computer_id] = TextDrawCreate(22, 400, ".");
        TextDrawTextSize(winico[304][computer_id], 1, 1);
        TextDrawSetShadow(winico[304][computer_id], 0);
        TextDrawFont(winico[304][computer_id], 2);
        TextDrawColor(winico[304][computer_id], 0x005385ff);
        winico[304][used] = 1;
        winico[305][computer_id] = TextDrawCreate(23, 400, ".");
        TextDrawTextSize(winico[305][computer_id], 1, 1);
        TextDrawSetShadow(winico[305][computer_id], 0);
        TextDrawFont(winico[305][computer_id], 2);
        TextDrawColor(winico[305][computer_id], 0x015485ff);
        winico[305][used] = 1;
        winico[306][computer_id] = TextDrawCreate(24, 400, ".");
        TextDrawTextSize(winico[306][computer_id], 1, 1);
        TextDrawSetShadow(winico[306][computer_id], 0);
        TextDrawFont(winico[306][computer_id], 2);
        TextDrawColor(winico[306][computer_id], 0x004E7Fff);
        winico[306][used] = 1;
        winico[307][computer_id] = TextDrawCreate(25, 400, ".");
        TextDrawTextSize(winico[307][computer_id], 1, 1);
        TextDrawSetShadow(winico[307][computer_id], 0);
        TextDrawFont(winico[307][computer_id], 2);
        TextDrawColor(winico[307][computer_id], 0x185985ff);
        winico[307][used] = 1;
        winico[308][computer_id] = TextDrawCreate(26, 400, ".");
        TextDrawTextSize(winico[308][computer_id], 1, 1);
        TextDrawSetShadow(winico[308][computer_id], 0);
        TextDrawFont(winico[308][computer_id], 2);
        TextDrawColor(winico[308][computer_id], 0x3882BFff);
        winico[308][used] = 1;
        winico[309][computer_id] = TextDrawCreate(27, 400, ".");
        TextDrawTextSize(winico[309][computer_id], 1, 1);
        TextDrawSetShadow(winico[309][computer_id], 0);
        TextDrawFont(winico[309][computer_id], 2);
        TextDrawColor(winico[309][computer_id], 0x4293CDff);
        winico[309][used] = 1;
        winico[310][computer_id] = TextDrawCreate(28, 400, ".");
        TextDrawTextSize(winico[310][computer_id], 1, 1);
        TextDrawSetShadow(winico[310][computer_id], 0);
        TextDrawFont(winico[310][computer_id], 2);
        TextDrawColor(winico[310][computer_id], 0x6EA6D7ff);
        winico[310][used] = 1;
        winico[311][computer_id] = TextDrawCreate(29, 400, ".");
        TextDrawTextSize(winico[311][computer_id], 1, 1);
        TextDrawSetShadow(winico[311][computer_id], 0);
        TextDrawFont(winico[311][computer_id], 2);
        TextDrawColor(winico[311][computer_id], 0x91B9E2ff);
        winico[311][used] = 1;
        winico[312][computer_id] = TextDrawCreate(30, 400, ".");
        TextDrawTextSize(winico[312][computer_id], 1, 1);
        TextDrawSetShadow(winico[312][computer_id], 0);
        TextDrawFont(winico[312][computer_id], 2);
        TextDrawColor(winico[312][computer_id], 0xB3D1EBff);
        winico[312][used] = 1;
        winico[313][computer_id] = TextDrawCreate(31, 400, ".");
        TextDrawTextSize(winico[313][computer_id], 1, 1);
        TextDrawSetShadow(winico[313][computer_id], 0);
        TextDrawFont(winico[313][computer_id], 2);
        TextDrawColor(winico[313][computer_id], 0xC9DDF5ff);
        winico[313][used] = 1;
        winico[314][computer_id] = TextDrawCreate(32, 400, ".");
        TextDrawTextSize(winico[314][computer_id], 1, 1);
        TextDrawSetShadow(winico[314][computer_id], 0);
        TextDrawFont(winico[314][computer_id], 2);
        TextDrawColor(winico[314][computer_id], 0xD7EAFCff);
        winico[314][used] = 1;
        winico[315][computer_id] = TextDrawCreate(33, 400, ".");
        TextDrawTextSize(winico[315][computer_id], 1, 1);
        TextDrawSetShadow(winico[315][computer_id], 0);
        TextDrawFont(winico[315][computer_id], 2);
        TextDrawColor(winico[315][computer_id], 0x194A4Fff);
        winico[315][used] = 1;
        winico[316][computer_id] = TextDrawCreate(34, 400, ".");
        TextDrawTextSize(winico[316][computer_id], 1, 1);
        TextDrawSetShadow(winico[316][computer_id], 0);
        TextDrawFont(winico[316][computer_id], 2);
        TextDrawColor(winico[316][computer_id], 0x768C87ff);
        winico[316][used] = 1;
        winico[317][computer_id] = TextDrawCreate(35, 400, ".");
        TextDrawTextSize(winico[317][computer_id], 1, 1);
        TextDrawSetShadow(winico[317][computer_id], 0);
        TextDrawFont(winico[317][computer_id], 2);
        TextDrawColor(winico[317][computer_id], 0x003054ff);
        winico[317][used] = 1;
        winico[318][computer_id] = TextDrawCreate(36, 400, ".");
        TextDrawTextSize(winico[318][computer_id], 1, 1);
        TextDrawSetShadow(winico[318][computer_id], 0);
        TextDrawFont(winico[318][computer_id], 2);
        TextDrawColor(winico[318][computer_id], 0x396E57ff);
        winico[318][used] = 1;
        winico[319][computer_id] = TextDrawCreate(37, 400, ".");
        TextDrawTextSize(winico[319][computer_id], 1, 1);
        TextDrawSetShadow(winico[319][computer_id], 0);
        TextDrawFont(winico[319][computer_id], 2);
        TextDrawColor(winico[319][computer_id], 0x6B985Fff);
        winico[319][used] = 1;
        winico[320][computer_id] = TextDrawCreate(38, 400, ".");
        TextDrawTextSize(winico[320][computer_id], 1, 1);
        TextDrawSetShadow(winico[320][computer_id], 0);
        TextDrawFont(winico[320][computer_id], 2);
        TextDrawColor(winico[320][computer_id], 0x609052ff);
        winico[320][used] = 1;
        winico[321][computer_id] = TextDrawCreate(39, 400, ".");
        TextDrawTextSize(winico[321][computer_id], 1, 1);
        TextDrawSetShadow(winico[321][computer_id], 0);
        TextDrawFont(winico[321][computer_id], 2);
        TextDrawColor(winico[321][computer_id], 0x336D4Fff);
        winico[321][used] = 1;
        winico[322][computer_id] = TextDrawCreate(40, 400, ".");
        TextDrawTextSize(winico[322][computer_id], 1, 1);
        TextDrawSetShadow(winico[322][computer_id], 0);
        TextDrawFont(winico[322][computer_id], 2);
        TextDrawColor(winico[322][computer_id], 0x00425Bff);
        winico[322][used] = 1;
        winico[323][computer_id] = TextDrawCreate(41, 400, ".");
        TextDrawTextSize(winico[323][computer_id], 1, 1);
        TextDrawSetShadow(winico[323][computer_id], 0);
        TextDrawFont(winico[323][computer_id], 2);
        TextDrawColor(winico[323][computer_id], 0x014776ff);
        winico[323][used] = 1;
        winico[324][computer_id] = TextDrawCreate(42, 400, ".");
        TextDrawTextSize(winico[324][computer_id], 1, 1);
        TextDrawSetShadow(winico[324][computer_id], 0);
        TextDrawFont(winico[324][computer_id], 2);
        TextDrawColor(winico[324][computer_id], 0x015486ff);
        winico[324][used] = 1;
        winico[325][computer_id] = TextDrawCreate(43, 400, ".");
        TextDrawTextSize(winico[325][computer_id], 1, 1);
        TextDrawSetShadow(winico[325][computer_id], 0);
        TextDrawFont(winico[325][computer_id], 2);
        TextDrawColor(winico[325][computer_id], 0x01588Eff);
        winico[325][used] = 1;
        winico[326][computer_id] = TextDrawCreate(44, 400, ".");
        TextDrawTextSize(winico[326][computer_id], 1, 1);
        TextDrawSetShadow(winico[326][computer_id], 0);
        TextDrawFont(winico[326][computer_id], 2);
        TextDrawColor(winico[326][computer_id], 0x01588Dff);
        winico[326][used] = 1;
        winico[327][computer_id] = TextDrawCreate(45, 400, ".");
        TextDrawTextSize(winico[327][computer_id], 1, 1);
        TextDrawSetShadow(winico[327][computer_id], 0);
        TextDrawFont(winico[327][computer_id], 2);
        TextDrawColor(winico[327][computer_id], 0x01568Bff);
        winico[327][used] = 1;
        winico[328][computer_id] = TextDrawCreate(46, 400, ".");
        TextDrawTextSize(winico[328][computer_id], 1, 1);
        TextDrawSetShadow(winico[328][computer_id], 0);
        TextDrawFont(winico[328][computer_id], 2);
        TextDrawColor(winico[328][computer_id], 0x015384ff);
        winico[328][used] = 1;
        winico[329][computer_id] = TextDrawCreate(47, 400, ".");
        TextDrawTextSize(winico[329][computer_id], 1, 1);
        TextDrawSetShadow(winico[329][computer_id], 0);
        TextDrawFont(winico[329][computer_id], 2);
        TextDrawColor(winico[329][computer_id], 0x004376ff);
        winico[329][used] = 1;
        winico[330][computer_id] = TextDrawCreate(20, 401, ".");
        TextDrawTextSize(winico[330][computer_id], 1, 1);
        TextDrawSetShadow(winico[330][computer_id], 0);
        TextDrawFont(winico[330][computer_id], 2);
        TextDrawColor(winico[330][computer_id], 0x004378ff);
        winico[330][used] = 1;
        winico[331][computer_id] = TextDrawCreate(21, 401, ".");
        TextDrawTextSize(winico[331][computer_id], 1, 1);
        TextDrawSetShadow(winico[331][computer_id], 0);
        TextDrawFont(winico[331][computer_id], 2);
        TextDrawColor(winico[331][computer_id], 0x005486ff);
        winico[331][used] = 1;
        winico[332][computer_id] = TextDrawCreate(22, 401, ".");
        TextDrawTextSize(winico[332][computer_id], 1, 1);
        TextDrawSetShadow(winico[332][computer_id], 0);
        TextDrawFont(winico[332][computer_id], 2);
        TextDrawColor(winico[332][computer_id], 0x00558Cff);
        winico[332][used] = 1;
        winico[333][computer_id] = TextDrawCreate(23, 401, ".");
        TextDrawTextSize(winico[333][computer_id], 1, 1);
        TextDrawSetShadow(winico[333][computer_id], 0);
        TextDrawFont(winico[333][computer_id], 2);
        TextDrawColor(winico[333][computer_id], 0x00558Aff);
        winico[333][used] = 1;
        winico[334][computer_id] = TextDrawCreate(24, 401, ".");
        TextDrawTextSize(winico[334][computer_id], 1, 1);
        TextDrawSetShadow(winico[334][computer_id], 0);
        TextDrawFont(winico[334][computer_id], 2);
        TextDrawColor(winico[334][computer_id], 0x004F7Eff);
        winico[334][used] = 1;
        winico[335][computer_id] = TextDrawCreate(25, 401, ".");
        TextDrawTextSize(winico[335][computer_id], 1, 1);
        TextDrawSetShadow(winico[335][computer_id], 0);
        TextDrawFont(winico[335][computer_id], 2);
        TextDrawColor(winico[335][computer_id], 0x3E77ADff);
        winico[335][used] = 1;
        winico[336][computer_id] = TextDrawCreate(26, 401, ".");
        TextDrawTextSize(winico[336][computer_id], 1, 1);
        TextDrawSetShadow(winico[336][computer_id], 0);
        TextDrawFont(winico[336][computer_id], 2);
        TextDrawColor(winico[336][computer_id], 0x367FBEff);
        winico[336][used] = 1;
        winico[337][computer_id] = TextDrawCreate(27, 401, ".");
        TextDrawTextSize(winico[337][computer_id], 1, 1);
        TextDrawSetShadow(winico[337][computer_id], 0);
        TextDrawFont(winico[337][computer_id], 2);
        TextDrawColor(winico[337][computer_id], 0x3B90C8ff);
        winico[337][used] = 1;
        winico[338][computer_id] = TextDrawCreate(28, 401, ".");
        TextDrawTextSize(winico[338][computer_id], 1, 1);
        TextDrawSetShadow(winico[338][computer_id], 0);
        TextDrawFont(winico[338][computer_id], 2);
        TextDrawColor(winico[338][computer_id], 0x63A1D6ff);
        winico[338][used] = 1;
        winico[339][computer_id] = TextDrawCreate(29, 401, ".");
        TextDrawTextSize(winico[339][computer_id], 1, 1);
        TextDrawSetShadow(winico[339][computer_id], 0);
        TextDrawFont(winico[339][computer_id], 2);
        TextDrawColor(winico[339][computer_id], 0x86B3DEff);
        winico[339][used] = 1;
        winico[340][computer_id] = TextDrawCreate(30, 401, ".");
        TextDrawTextSize(winico[340][computer_id], 1, 1);
        TextDrawSetShadow(winico[340][computer_id], 0);
        TextDrawFont(winico[340][computer_id], 2);
        TextDrawColor(winico[340][computer_id], 0xA4C6E8ff);
        winico[340][used] = 1;
        winico[341][computer_id] = TextDrawCreate(31, 401, ".");
        TextDrawTextSize(winico[341][computer_id], 1, 1);
        TextDrawSetShadow(winico[341][computer_id], 0);
        TextDrawFont(winico[341][computer_id], 2);
        TextDrawColor(winico[341][computer_id], 0xBDD9F1ff);
        winico[341][used] = 1;
        winico[342][computer_id] = TextDrawCreate(32, 401, ".");
        TextDrawTextSize(winico[342][computer_id], 1, 1);
        TextDrawSetShadow(winico[342][computer_id], 0);
        TextDrawFont(winico[342][computer_id], 2);
        TextDrawColor(winico[342][computer_id], 0x80A8C6ff);
        winico[342][used] = 1;
        winico[343][computer_id] = TextDrawCreate(33, 401, ".");
        TextDrawTextSize(winico[343][computer_id], 1, 1);
        TextDrawSetShadow(winico[343][computer_id], 0);
        TextDrawFont(winico[343][computer_id], 2);
        TextDrawColor(winico[343][computer_id], 0x9B9F5Eff);
        winico[343][used] = 1;
        winico[344][computer_id] = TextDrawCreate(34, 401, ".");
        TextDrawTextSize(winico[344][computer_id], 1, 1);
        TextDrawSetShadow(winico[344][computer_id], 0);
        TextDrawFont(winico[344][computer_id], 2);
        TextDrawColor(winico[344][computer_id], 0xFCEAB2ff);
        winico[344][used] = 1;
        winico[345][computer_id] = TextDrawCreate(35, 401, ".");
        TextDrawTextSize(winico[345][computer_id], 1, 1);
        TextDrawSetShadow(winico[345][computer_id], 0);
        TextDrawFont(winico[345][computer_id], 2);
        TextDrawColor(winico[345][computer_id], 0xFFEB9Fff);
        winico[345][used] = 1;
        winico[346][computer_id] = TextDrawCreate(36, 401, ".");
        TextDrawTextSize(winico[346][computer_id], 1, 1);
        TextDrawSetShadow(winico[346][computer_id], 0);
        TextDrawFont(winico[346][computer_id], 2);
        TextDrawColor(winico[346][computer_id], 0xC0B377ff);
        winico[346][used] = 1;
        winico[347][computer_id] = TextDrawCreate(37, 401, ".");
        TextDrawTextSize(winico[347][computer_id], 1, 1);
        TextDrawSetShadow(winico[347][computer_id], 0);
        TextDrawFont(winico[347][computer_id], 2);
        TextDrawColor(winico[347][computer_id], 0x908A5Fff);
        winico[347][used] = 1;
        winico[348][computer_id] = TextDrawCreate(38, 401, ".");
        TextDrawTextSize(winico[348][computer_id], 1, 1);
        TextDrawSetShadow(winico[348][computer_id], 0);
        TextDrawFont(winico[348][computer_id], 2);
        TextDrawColor(winico[348][computer_id], 0x9C9052ff);
        winico[348][used] = 1;
        winico[349][computer_id] = TextDrawCreate(39, 401, ".");
        TextDrawTextSize(winico[349][computer_id], 1, 1);
        TextDrawSetShadow(winico[349][computer_id], 0);
        TextDrawFont(winico[349][computer_id], 2);
        TextDrawColor(winico[349][computer_id], 0xD9AD34ff);
        winico[349][used] = 1;
        winico[350][computer_id] = TextDrawCreate(40, 401, ".");
        TextDrawTextSize(winico[350][computer_id], 1, 1);
        TextDrawSetShadow(winico[350][computer_id], 0);
        TextDrawFont(winico[350][computer_id], 2);
        TextDrawColor(winico[350][computer_id], 0xFFB61Fff);
        winico[350][used] = 1;
        winico[351][computer_id] = TextDrawCreate(41, 401, ".");
        TextDrawTextSize(winico[351][computer_id], 1, 1);
        TextDrawSetShadow(winico[351][computer_id], 0);
        TextDrawFont(winico[351][computer_id], 2);
        TextDrawColor(winico[351][computer_id], 0x1C5F7Fff);
        winico[351][used] = 1;
        winico[352][computer_id] = TextDrawCreate(42, 401, ".");
        TextDrawTextSize(winico[352][computer_id], 1, 1);
        TextDrawSetShadow(winico[352][computer_id], 0);
        TextDrawFont(winico[352][computer_id], 2);
        TextDrawColor(winico[352][computer_id], 0x015C8Eff);
        winico[352][used] = 1;
        winico[353][computer_id] = TextDrawCreate(43, 401, ".");
        TextDrawTextSize(winico[353][computer_id], 1, 1);
        TextDrawSetShadow(winico[353][computer_id], 0);
        TextDrawFont(winico[353][computer_id], 2);
        TextDrawColor(winico[353][computer_id], 0x005E96ff);
        winico[353][used] = 1;
        winico[354][computer_id] = TextDrawCreate(44, 401, ".");
        TextDrawTextSize(winico[354][computer_id], 1, 1);
        TextDrawSetShadow(winico[354][computer_id], 0);
        TextDrawFont(winico[354][computer_id], 2);
        TextDrawColor(winico[354][computer_id], 0x015C95ff);
        winico[354][used] = 1;
        winico[355][computer_id] = TextDrawCreate(45, 401, ".");
        TextDrawTextSize(winico[355][computer_id], 1, 1);
        TextDrawSetShadow(winico[355][computer_id], 0);
        TextDrawFont(winico[355][computer_id], 2);
        TextDrawColor(winico[355][computer_id], 0x01598Eff);
        winico[355][used] = 1;
        winico[356][computer_id] = TextDrawCreate(46, 401, ".");
        TextDrawTextSize(winico[356][computer_id], 1, 1);
        TextDrawSetShadow(winico[356][computer_id], 0);
        TextDrawFont(winico[356][computer_id], 2);
        TextDrawColor(winico[356][computer_id], 0x01558Cff);
        winico[356][used] = 1;
        winico[357][computer_id] = TextDrawCreate(47, 401, ".");
        TextDrawTextSize(winico[357][computer_id], 1, 1);
        TextDrawSetShadow(winico[357][computer_id], 0);
        TextDrawFont(winico[357][computer_id], 2);
        TextDrawColor(winico[357][computer_id], 0x004578ff);
        winico[357][used] = 1;
        winico[358][computer_id] = TextDrawCreate(20, 402, ".");
        TextDrawTextSize(winico[358][computer_id], 1, 1);
        TextDrawSetShadow(winico[358][computer_id], 0);
        TextDrawFont(winico[358][computer_id], 2);
        TextDrawColor(winico[358][computer_id], 0x004277ff);
        winico[358][used] = 1;
        winico[359][computer_id] = TextDrawCreate(21, 402, ".");
        TextDrawTextSize(winico[359][computer_id], 1, 1);
        TextDrawSetShadow(winico[359][computer_id], 0);
        TextDrawFont(winico[359][computer_id], 2);
        TextDrawColor(winico[359][computer_id], 0x02558Eff);
        winico[359][used] = 1;
        winico[360][computer_id] = TextDrawCreate(22, 402, ".");
        TextDrawTextSize(winico[360][computer_id], 1, 1);
        TextDrawSetShadow(winico[360][computer_id], 0);
        TextDrawFont(winico[360][computer_id], 2);
        TextDrawColor(winico[360][computer_id], 0x005A8Eff);
        winico[360][used] = 1;
        winico[361][computer_id] = TextDrawCreate(23, 402, ".");
        TextDrawTextSize(winico[361][computer_id], 1, 1);
        TextDrawSetShadow(winico[361][computer_id], 0);
        TextDrawFont(winico[361][computer_id], 2);
        TextDrawColor(winico[361][computer_id], 0x00588Bff);
        winico[361][used] = 1;
        winico[362][computer_id] = TextDrawCreate(24, 402, ".");
        TextDrawTextSize(winico[362][computer_id], 1, 1);
        TextDrawSetShadow(winico[362][computer_id], 0);
        TextDrawFont(winico[362][computer_id], 2);
        TextDrawColor(winico[362][computer_id], 0x004B7Aff);
        winico[362][used] = 1;
        winico[363][computer_id] = TextDrawCreate(25, 402, ".");
        TextDrawTextSize(winico[363][computer_id], 1, 1);
        TextDrawSetShadow(winico[363][computer_id], 0);
        TextDrawFont(winico[363][computer_id], 2);
        TextDrawColor(winico[363][computer_id], 0x4378B6ff);
        winico[363][used] = 1;
        winico[364][computer_id] = TextDrawCreate(26, 402, ".");
        TextDrawTextSize(winico[364][computer_id], 1, 1);
        TextDrawSetShadow(winico[364][computer_id], 0);
        TextDrawFont(winico[364][computer_id], 2);
        TextDrawColor(winico[364][computer_id], 0x3479B8ff);
        winico[364][used] = 1;
        winico[365][computer_id] = TextDrawCreate(27, 402, ".");
        TextDrawTextSize(winico[365][computer_id], 1, 1);
        TextDrawSetShadow(winico[365][computer_id], 0);
        TextDrawFont(winico[365][computer_id], 2);
        TextDrawColor(winico[365][computer_id], 0x398AC5ff);
        winico[365][used] = 1;
        winico[366][computer_id] = TextDrawCreate(28, 402, ".");
        TextDrawTextSize(winico[366][computer_id], 1, 1);
        TextDrawSetShadow(winico[366][computer_id], 0);
        TextDrawFont(winico[366][computer_id], 2);
        TextDrawColor(winico[366][computer_id], 0x509AD1ff);
        winico[366][used] = 1;
        winico[367][computer_id] = TextDrawCreate(29, 402, ".");
        TextDrawTextSize(winico[367][computer_id], 1, 1);
        TextDrawSetShadow(winico[367][computer_id], 0);
        TextDrawFont(winico[367][computer_id], 2);
        TextDrawColor(winico[367][computer_id], 0x73A9D7ff);
        winico[367][used] = 1;
        winico[368][computer_id] = TextDrawCreate(30, 402, ".");
        TextDrawTextSize(winico[368][computer_id], 1, 1);
        TextDrawSetShadow(winico[368][computer_id], 0);
        TextDrawFont(winico[368][computer_id], 2);
        TextDrawColor(winico[368][computer_id], 0x8EB9E2ff);
        winico[368][used] = 1;
        winico[369][computer_id] = TextDrawCreate(31, 402, ".");
        TextDrawTextSize(winico[369][computer_id], 1, 1);
        TextDrawSetShadow(winico[369][computer_id], 0);
        TextDrawFont(winico[369][computer_id], 2);
        TextDrawColor(winico[369][computer_id], 0xA7C8E9ff);
        winico[369][used] = 1;
        winico[370][computer_id] = TextDrawCreate(32, 402, ".");
        TextDrawTextSize(winico[370][computer_id], 1, 1);
        TextDrawSetShadow(winico[370][computer_id], 0);
        TextDrawFont(winico[370][computer_id], 2);
        TextDrawColor(winico[370][computer_id], 0x1B527Dff);
        winico[370][used] = 1;
        winico[371][computer_id] = TextDrawCreate(33, 402, ".");
        TextDrawTextSize(winico[371][computer_id], 1, 1);
        TextDrawSetShadow(winico[371][computer_id], 0);
        TextDrawFont(winico[371][computer_id], 2);
        TextDrawColor(winico[371][computer_id], 0xF7E086ff);
        winico[371][used] = 1;
        winico[372][computer_id] = TextDrawCreate(34, 402, ".");
        TextDrawTextSize(winico[372][computer_id], 1, 1);
        TextDrawSetShadow(winico[372][computer_id], 0);
        TextDrawFont(winico[372][computer_id], 2);
        TextDrawColor(winico[372][computer_id], 0xF8E39Eff);
        winico[372][used] = 1;
        winico[373][computer_id] = TextDrawCreate(35, 402, ".");
        TextDrawTextSize(winico[373][computer_id], 1, 1);
        TextDrawSetShadow(winico[373][computer_id], 0);
        TextDrawFont(winico[373][computer_id], 2);
        TextDrawColor(winico[373][computer_id], 0xFBE090ff);
        winico[373][used] = 1;
        winico[374][computer_id] = TextDrawCreate(36, 402, ".");
        TextDrawTextSize(winico[374][computer_id], 1, 1);
        TextDrawSetShadow(winico[374][computer_id], 0);
        TextDrawFont(winico[374][computer_id], 2);
        TextDrawColor(winico[374][computer_id], 0xFEDB7Cff);
        winico[374][used] = 1;
        winico[375][computer_id] = TextDrawCreate(37, 402, ".");
        TextDrawTextSize(winico[375][computer_id], 1, 1);
        TextDrawSetShadow(winico[375][computer_id], 0);
        TextDrawFont(winico[375][computer_id], 2);
        TextDrawColor(winico[375][computer_id], 0xFFD860ff);
        winico[375][used] = 1;
        winico[376][computer_id] = TextDrawCreate(38, 402, ".");
        TextDrawTextSize(winico[376][computer_id], 1, 1);
        TextDrawSetShadow(winico[376][computer_id], 0);
        TextDrawFont(winico[376][computer_id], 2);
        TextDrawColor(winico[376][computer_id], 0xFFD43Bff);
        winico[376][used] = 1;
        winico[377][computer_id] = TextDrawCreate(39, 402, ".");
        TextDrawTextSize(winico[377][computer_id], 1, 1);
        TextDrawSetShadow(winico[377][computer_id], 0);
        TextDrawFont(winico[377][computer_id], 2);
        TextDrawColor(winico[377][computer_id], 0xFFC129ff);
        winico[377][used] = 1;
        winico[378][computer_id] = TextDrawCreate(40, 402, ".");
        TextDrawTextSize(winico[378][computer_id], 1, 1);
        TextDrawSetShadow(winico[378][computer_id], 0);
        TextDrawFont(winico[378][computer_id], 2);
        TextDrawColor(winico[378][computer_id], 0xE0A926ff);
        winico[378][used] = 1;
        winico[379][computer_id] = TextDrawCreate(41, 402, ".");
        TextDrawTextSize(winico[379][computer_id], 1, 1);
        TextDrawSetShadow(winico[379][computer_id], 0);
        TextDrawFont(winico[379][computer_id], 2);
        TextDrawColor(winico[379][computer_id], 0x00558Cff);
        winico[379][used] = 1;
        winico[380][computer_id] = TextDrawCreate(42, 402, ".");
        TextDrawTextSize(winico[380][computer_id], 1, 1);
        TextDrawSetShadow(winico[380][computer_id], 0);
        TextDrawFont(winico[380][computer_id], 2);
        TextDrawColor(winico[380][computer_id], 0x006299ff);
        winico[380][used] = 1;
        winico[381][computer_id] = TextDrawCreate(43, 402, ".");
        TextDrawTextSize(winico[381][computer_id], 1, 1);
        TextDrawSetShadow(winico[381][computer_id], 0);
        TextDrawFont(winico[381][computer_id], 2);
        TextDrawColor(winico[381][computer_id], 0x01649Dff);
        winico[381][used] = 1;
        winico[382][computer_id] = TextDrawCreate(44, 402, ".");
        TextDrawTextSize(winico[382][computer_id], 1, 1);
        TextDrawSetShadow(winico[382][computer_id], 0);
        TextDrawFont(winico[382][computer_id], 2);
        TextDrawColor(winico[382][computer_id], 0x02619Cff);
        winico[382][used] = 1;
        winico[383][computer_id] = TextDrawCreate(45, 402, ".");
        TextDrawTextSize(winico[383][computer_id], 1, 1);
        TextDrawSetShadow(winico[383][computer_id], 0);
        TextDrawFont(winico[383][computer_id], 2);
        TextDrawColor(winico[383][computer_id], 0x005D94ff);
        winico[383][used] = 1;
        winico[384][computer_id] = TextDrawCreate(46, 402, ".");
        TextDrawTextSize(winico[384][computer_id], 1, 1);
        TextDrawSetShadow(winico[384][computer_id], 0);
        TextDrawFont(winico[384][computer_id], 2);
        TextDrawColor(winico[384][computer_id], 0x01578Fff);
        winico[384][used] = 1;
        winico[385][computer_id] = TextDrawCreate(47, 402, ".");
        TextDrawTextSize(winico[385][computer_id], 1, 1);
        TextDrawSetShadow(winico[385][computer_id], 0);
        TextDrawFont(winico[385][computer_id], 2);
        TextDrawColor(winico[385][computer_id], 0x185785ff);
        winico[385][used] = 1;
        winico[386][computer_id] = TextDrawCreate(20, 403, ".");
        TextDrawTextSize(winico[386][computer_id], 1, 1);
        TextDrawSetShadow(winico[386][computer_id], 0);
        TextDrawFont(winico[386][computer_id], 2);
        TextDrawColor(winico[386][computer_id], 0x215F8Fff);
        winico[386][used] = 1;
        winico[387][computer_id] = TextDrawCreate(21, 403, ".");
        TextDrawTextSize(winico[387][computer_id], 1, 1);
        TextDrawSetShadow(winico[387][computer_id], 0);
        TextDrawFont(winico[387][computer_id], 2);
        TextDrawColor(winico[387][computer_id], 0x005890ff);
        winico[387][used] = 1;
        winico[388][computer_id] = TextDrawCreate(22, 403, ".");
        TextDrawTextSize(winico[388][computer_id], 1, 1);
        TextDrawSetShadow(winico[388][computer_id], 0);
        TextDrawFont(winico[388][computer_id], 2);
        TextDrawColor(winico[388][computer_id], 0x015C96ff);
        winico[388][used] = 1;
        winico[389][computer_id] = TextDrawCreate(23, 403, ".");
        TextDrawTextSize(winico[389][computer_id], 1, 1);
        TextDrawSetShadow(winico[389][computer_id], 0);
        TextDrawFont(winico[389][computer_id], 2);
        TextDrawColor(winico[389][computer_id], 0x00598Eff);
        winico[389][used] = 1;
        winico[390][computer_id] = TextDrawCreate(24, 403, ".");
        TextDrawTextSize(winico[390][computer_id], 1, 1);
        TextDrawSetShadow(winico[390][computer_id], 0);
        TextDrawFont(winico[390][computer_id], 2);
        TextDrawColor(winico[390][computer_id], 0x095682ff);
        winico[390][used] = 1;
        winico[391][computer_id] = TextDrawCreate(25, 403, ".");
        TextDrawTextSize(winico[391][computer_id], 1, 1);
        TextDrawSetShadow(winico[391][computer_id], 0);
        TextDrawFont(winico[391][computer_id], 2);
        TextDrawColor(winico[391][computer_id], 0x3667AAff);
        winico[391][used] = 1;
        winico[392][computer_id] = TextDrawCreate(26, 403, ".");
        TextDrawTextSize(winico[392][computer_id], 1, 1);
        TextDrawSetShadow(winico[392][computer_id], 0);
        TextDrawFont(winico[392][computer_id], 2);
        TextDrawColor(winico[392][computer_id], 0x3473B3ff);
        winico[392][used] = 1;
        winico[393][computer_id] = TextDrawCreate(27, 403, ".");
        TextDrawTextSize(winico[393][computer_id], 1, 1);
        TextDrawSetShadow(winico[393][computer_id], 0);
        TextDrawFont(winico[393][computer_id], 2);
        TextDrawColor(winico[393][computer_id], 0x3982BEff);
        winico[393][used] = 1;
        winico[394][computer_id] = TextDrawCreate(28, 403, ".");
        TextDrawTextSize(winico[394][computer_id], 1, 1);
        TextDrawSetShadow(winico[394][computer_id], 0);
        TextDrawFont(winico[394][computer_id], 2);
        TextDrawColor(winico[394][computer_id], 0x3A8EC9ff);
        winico[394][used] = 1;
        winico[395][computer_id] = TextDrawCreate(29, 403, ".");
        TextDrawTextSize(winico[395][computer_id], 1, 1);
        TextDrawSetShadow(winico[395][computer_id], 0);
        TextDrawFont(winico[395][computer_id], 2);
        TextDrawColor(winico[395][computer_id], 0x5A9DD2ff);
        winico[395][used] = 1;
        winico[396][computer_id] = TextDrawCreate(30, 403, ".");
        TextDrawTextSize(winico[396][computer_id], 1, 1);
        TextDrawSetShadow(winico[396][computer_id], 0);
        TextDrawFont(winico[396][computer_id], 2);
        TextDrawColor(winico[396][computer_id], 0x74AAD8ff);
        winico[396][used] = 1;
        winico[397][computer_id] = TextDrawCreate(31, 403, ".");
        TextDrawTextSize(winico[397][computer_id], 1, 1);
        TextDrawSetShadow(winico[397][computer_id], 0);
        TextDrawFont(winico[397][computer_id], 2);
        TextDrawColor(winico[397][computer_id], 0x92BBE6ff);
        winico[397][used] = 1;
        winico[398][computer_id] = TextDrawCreate(32, 403, ".");
        TextDrawTextSize(winico[398][computer_id], 1, 1);
        TextDrawSetShadow(winico[398][computer_id], 0);
        TextDrawFont(winico[398][computer_id], 2);
        TextDrawColor(winico[398][computer_id], 0x003954ff);
        winico[398][used] = 1;
        winico[399][computer_id] = TextDrawCreate(33, 403, ".");
        TextDrawTextSize(winico[399][computer_id], 1, 1);
        TextDrawSetShadow(winico[399][computer_id], 0);
        TextDrawFont(winico[399][computer_id], 2);
        TextDrawColor(winico[399][computer_id], 0xFFE588ff);
        winico[399][used] = 1;
        winico[400][computer_id] = TextDrawCreate(34, 403, ".");
        TextDrawTextSize(winico[400][computer_id], 1, 1);
        TextDrawSetShadow(winico[400][computer_id], 0);
        TextDrawFont(winico[400][computer_id], 2);
        TextDrawColor(winico[400][computer_id], 0xFDDE80ff);
        winico[400][used] = 1;
        winico[401][computer_id] = TextDrawCreate(35, 403, ".");
        TextDrawTextSize(winico[401][computer_id], 1, 1);
        TextDrawSetShadow(winico[401][computer_id], 0);
        TextDrawFont(winico[401][computer_id], 2);
        TextDrawColor(winico[401][computer_id], 0xFFDA74ff);
        winico[401][used] = 1;
        winico[402][computer_id] = TextDrawCreate(36, 403, ".");
        TextDrawTextSize(winico[402][computer_id], 1, 1);
        TextDrawSetShadow(winico[402][computer_id], 0);
        TextDrawFont(winico[402][computer_id], 2);
        TextDrawColor(winico[402][computer_id], 0xFFD862ff);
        winico[402][used] = 1;
        winico[403][computer_id] = TextDrawCreate(37, 403, ".");
        TextDrawTextSize(winico[403][computer_id], 1, 1);
        TextDrawSetShadow(winico[403][computer_id], 0);
        TextDrawFont(winico[403][computer_id], 2);
        TextDrawColor(winico[403][computer_id], 0xFFD446ff);
        winico[403][used] = 1;
        winico[404][computer_id] = TextDrawCreate(38, 403, ".");
        TextDrawTextSize(winico[404][computer_id], 1, 1);
        TextDrawSetShadow(winico[404][computer_id], 0);
        TextDrawFont(winico[404][computer_id], 2);
        TextDrawColor(winico[404][computer_id], 0xFFCA29ff);
        winico[404][used] = 1;
        winico[405][computer_id] = TextDrawCreate(39, 403, ".");
        TextDrawTextSize(winico[405][computer_id], 1, 1);
        TextDrawSetShadow(winico[405][computer_id], 0);
        TextDrawFont(winico[405][computer_id], 2);
        TextDrawColor(winico[405][computer_id], 0xF8B421ff);
        winico[405][used] = 1;
        winico[406][computer_id] = TextDrawCreate(40, 403, ".");
        TextDrawTextSize(winico[406][computer_id], 1, 1);
        TextDrawSetShadow(winico[406][computer_id], 0);
        TextDrawFont(winico[406][computer_id], 2);
        TextDrawColor(winico[406][computer_id], 0x96914Aff);
        winico[406][used] = 1;
        winico[407][computer_id] = TextDrawCreate(41, 403, ".");
        TextDrawTextSize(winico[407][computer_id], 1, 1);
        TextDrawSetShadow(winico[407][computer_id], 0);
        TextDrawFont(winico[407][computer_id], 2);
        TextDrawColor(winico[407][computer_id], 0x046197ff);
        winico[407][used] = 1;
        winico[408][computer_id] = TextDrawCreate(42, 403, ".");
        TextDrawTextSize(winico[408][computer_id], 1, 1);
        TextDrawSetShadow(winico[408][computer_id], 0);
        TextDrawFont(winico[408][computer_id], 2);
        TextDrawColor(winico[408][computer_id], 0x0468A3ff);
        winico[408][used] = 1;
        winico[409][computer_id] = TextDrawCreate(43, 403, ".");
        TextDrawTextSize(winico[409][computer_id], 1, 1);
        TextDrawSetShadow(winico[409][computer_id], 0);
        TextDrawFont(winico[409][computer_id], 2);
        TextDrawColor(winico[409][computer_id], 0x0068A5ff);
        winico[409][used] = 1;
        winico[410][computer_id] = TextDrawCreate(44, 403, ".");
        TextDrawTextSize(winico[410][computer_id], 1, 1);
        TextDrawSetShadow(winico[410][computer_id], 0);
        TextDrawFont(winico[410][computer_id], 2);
        TextDrawColor(winico[410][computer_id], 0x0067A1ff);
        winico[410][used] = 1;
        winico[411][computer_id] = TextDrawCreate(45, 403, ".");
        TextDrawTextSize(winico[411][computer_id], 1, 1);
        TextDrawSetShadow(winico[411][computer_id], 0);
        TextDrawFont(winico[411][computer_id], 2);
        TextDrawColor(winico[411][computer_id], 0x01629Eff);
        winico[411][used] = 1;
        winico[412][computer_id] = TextDrawCreate(46, 403, ".");
        TextDrawTextSize(winico[412][computer_id], 1, 1);
        TextDrawSetShadow(winico[412][computer_id], 0);
        TextDrawFont(winico[412][computer_id], 2);
        TextDrawColor(winico[412][computer_id], 0x00598Fff);
        winico[412][used] = 1;
        winico[413][computer_id] = TextDrawCreate(47, 403, ".");
        TextDrawTextSize(winico[413][computer_id], 1, 1);
        TextDrawSetShadow(winico[413][computer_id], 0);
        TextDrawFont(winico[413][computer_id], 2);
        TextDrawColor(winico[413][computer_id], 0x90ACC1ff);
        winico[413][used] = 1;
        winico[414][computer_id] = TextDrawCreate(21, 404, ".");
        TextDrawTextSize(winico[414][computer_id], 1, 1);
        TextDrawSetShadow(winico[414][computer_id], 0);
        TextDrawFont(winico[414][computer_id], 2);
        TextDrawColor(winico[414][computer_id], 0x015590ff);
        winico[414][used] = 1;
        winico[415][computer_id] = TextDrawCreate(22, 404, ".");
        TextDrawTextSize(winico[415][computer_id], 1, 1);
        TextDrawSetShadow(winico[415][computer_id], 0);
        TextDrawFont(winico[415][computer_id], 2);
        TextDrawColor(winico[415][computer_id], 0x006093ff);
        winico[415][used] = 1;
        winico[416][computer_id] = TextDrawCreate(23, 404, ".");
        TextDrawTextSize(winico[416][computer_id], 1, 1);
        TextDrawSetShadow(winico[416][computer_id], 0);
        TextDrawFont(winico[416][computer_id], 2);
        TextDrawColor(winico[416][computer_id], 0x015D92ff);
        winico[416][used] = 1;
        winico[417][computer_id] = TextDrawCreate(24, 404, ".");
        TextDrawTextSize(winico[417][computer_id], 1, 1);
        TextDrawSetShadow(winico[417][computer_id], 0);
        TextDrawFont(winico[417][computer_id], 2);
        TextDrawColor(winico[417][computer_id], 0x3B77A8ff);
        winico[417][used] = 1;
        winico[418][computer_id] = TextDrawCreate(25, 404, ".");
        TextDrawTextSize(winico[418][computer_id], 1, 1);
        TextDrawSetShadow(winico[418][computer_id], 0);
        TextDrawFont(winico[418][computer_id], 2);
        TextDrawColor(winico[418][computer_id], 0x335FA2ff);
        winico[418][used] = 1;
        winico[419][computer_id] = TextDrawCreate(26, 404, ".");
        TextDrawTextSize(winico[419][computer_id], 1, 1);
        TextDrawSetShadow(winico[419][computer_id], 0);
        TextDrawFont(winico[419][computer_id], 2);
        TextDrawColor(winico[419][computer_id], 0x356FB0ff);
        winico[419][used] = 1;
        winico[420][computer_id] = TextDrawCreate(27, 404, ".");
        TextDrawTextSize(winico[420][computer_id], 1, 1);
        TextDrawSetShadow(winico[420][computer_id], 0);
        TextDrawFont(winico[420][computer_id], 2);
        TextDrawColor(winico[420][computer_id], 0x2F7BBCff);
        winico[420][used] = 1;
        winico[421][computer_id] = TextDrawCreate(28, 404, ".");
        TextDrawTextSize(winico[421][computer_id], 1, 1);
        TextDrawSetShadow(winico[421][computer_id], 0);
        TextDrawFont(winico[421][computer_id], 2);
        TextDrawColor(winico[421][computer_id], 0x3586C5ff);
        winico[421][used] = 1;
        winico[422][computer_id] = TextDrawCreate(29, 404, ".");
        TextDrawTextSize(winico[422][computer_id], 1, 1);
        TextDrawSetShadow(winico[422][computer_id], 0);
        TextDrawFont(winico[422][computer_id], 2);
        TextDrawColor(winico[422][computer_id], 0x3F91C9ff);
        winico[422][used] = 1;
        winico[423][computer_id] = TextDrawCreate(30, 404, ".");
        TextDrawTextSize(winico[423][computer_id], 1, 1);
        TextDrawSetShadow(winico[423][computer_id], 0);
        TextDrawFont(winico[423][computer_id], 2);
        TextDrawColor(winico[423][computer_id], 0x529BD0ff);
        winico[423][used] = 1;
        winico[424][computer_id] = TextDrawCreate(31, 404, ".");
        TextDrawTextSize(winico[424][computer_id], 1, 1);
        TextDrawSetShadow(winico[424][computer_id], 0);
        TextDrawFont(winico[424][computer_id], 2);
        TextDrawColor(winico[424][computer_id], 0x6BA3D0ff);
        winico[424][used] = 1;
        winico[425][computer_id] = TextDrawCreate(32, 404, ".");
        TextDrawTextSize(winico[425][computer_id], 1, 1);
        TextDrawSetShadow(winico[425][computer_id], 0);
        TextDrawFont(winico[425][computer_id], 2);
        TextDrawColor(winico[425][computer_id], 0x5D7A54ff);
        winico[425][used] = 1;
        winico[426][computer_id] = TextDrawCreate(33, 404, ".");
        TextDrawTextSize(winico[426][computer_id], 1, 1);
        TextDrawSetShadow(winico[426][computer_id], 0);
        TextDrawFont(winico[426][computer_id], 2);
        TextDrawColor(winico[426][computer_id], 0xFFD862ff);
        winico[426][used] = 1;
        winico[427][computer_id] = TextDrawCreate(34, 404, ".");
        TextDrawTextSize(winico[427][computer_id], 1, 1);
        TextDrawSetShadow(winico[427][computer_id], 0);
        TextDrawFont(winico[427][computer_id], 2);
        TextDrawColor(winico[427][computer_id], 0xFFD860ff);
        winico[427][used] = 1;
        winico[428][computer_id] = TextDrawCreate(35, 404, ".");
        TextDrawTextSize(winico[428][computer_id], 1, 1);
        TextDrawSetShadow(winico[428][computer_id], 0);
        TextDrawFont(winico[428][computer_id], 2);
        TextDrawColor(winico[428][computer_id], 0xFFD653ff);
        winico[428][used] = 1;
        winico[429][computer_id] = TextDrawCreate(36, 404, ".");
        TextDrawTextSize(winico[429][computer_id], 1, 1);
        TextDrawSetShadow(winico[429][computer_id], 0);
        TextDrawFont(winico[429][computer_id], 2);
        TextDrawColor(winico[429][computer_id], 0xFFD33Cff);
        winico[429][used] = 1;
        winico[430][computer_id] = TextDrawCreate(37, 404, ".");
        TextDrawTextSize(winico[430][computer_id], 1, 1);
        TextDrawSetShadow(winico[430][computer_id], 0);
        TextDrawFont(winico[430][computer_id], 2);
        TextDrawColor(winico[430][computer_id], 0xFECB2Aff);
        winico[430][used] = 1;
        winico[431][computer_id] = TextDrawCreate(38, 404, ".");
        TextDrawTextSize(winico[431][computer_id], 1, 1);
        TextDrawSetShadow(winico[431][computer_id], 0);
        TextDrawFont(winico[431][computer_id], 2);
        TextDrawColor(winico[431][computer_id], 0xFAB823ff);
        winico[431][used] = 1;
        winico[432][computer_id] = TextDrawCreate(39, 404, ".");
        TextDrawTextSize(winico[432][computer_id], 1, 1);
        TextDrawSetShadow(winico[432][computer_id], 0);
        TextDrawFont(winico[432][computer_id], 2);
        TextDrawColor(winico[432][computer_id], 0xFBA91Fff);
        winico[432][used] = 1;
        winico[433][computer_id] = TextDrawCreate(40, 404, ".");
        TextDrawTextSize(winico[433][computer_id], 1, 1);
        TextDrawSetShadow(winico[433][computer_id], 0);
        TextDrawFont(winico[433][computer_id], 2);
        TextDrawColor(winico[433][computer_id], 0x3C7179ff);
        winico[433][used] = 1;
        winico[434][computer_id] = TextDrawCreate(41, 404, ".");
        TextDrawTextSize(winico[434][computer_id], 1, 1);
        TextDrawSetShadow(winico[434][computer_id], 0);
        TextDrawFont(winico[434][computer_id], 2);
        TextDrawColor(winico[434][computer_id], 0x0769A0ff);
        winico[434][used] = 1;
        winico[435][computer_id] = TextDrawCreate(42, 404, ".");
        TextDrawTextSize(winico[435][computer_id], 1, 1);
        TextDrawSetShadow(winico[435][computer_id], 0);
        TextDrawFont(winico[435][computer_id], 2);
        TextDrawColor(winico[435][computer_id], 0x086FACff);
        winico[435][used] = 1;
        winico[436][computer_id] = TextDrawCreate(43, 404, ".");
        TextDrawTextSize(winico[436][computer_id], 1, 1);
        TextDrawSetShadow(winico[436][computer_id], 0);
        TextDrawFont(winico[436][computer_id], 2);
        TextDrawColor(winico[436][computer_id], 0x0270AEff);
        winico[436][used] = 1;
        winico[437][computer_id] = TextDrawCreate(44, 404, ".");
        TextDrawTextSize(winico[437][computer_id], 1, 1);
        TextDrawSetShadow(winico[437][computer_id], 0);
        TextDrawFont(winico[437][computer_id], 2);
        TextDrawColor(winico[437][computer_id], 0x016AA4ff);
        winico[437][used] = 1;
        winico[438][computer_id] = TextDrawCreate(45, 404, ".");
        TextDrawTextSize(winico[438][computer_id], 1, 1);
        TextDrawSetShadow(winico[438][computer_id], 0);
        TextDrawFont(winico[438][computer_id], 2);
        TextDrawColor(winico[438][computer_id], 0x0064A1ff);
        winico[438][used] = 1;
        winico[439][computer_id] = TextDrawCreate(46, 404, ".");
        TextDrawTextSize(winico[439][computer_id], 1, 1);
        TextDrawSetShadow(winico[439][computer_id], 0);
        TextDrawFont(winico[439][computer_id], 2);
        TextDrawColor(winico[439][computer_id], 0x005693ff);
        winico[439][used] = 1;
        winico[440][computer_id] = TextDrawCreate(21, 405, ".");
        TextDrawTextSize(winico[440][computer_id], 1, 1);
        TextDrawSetShadow(winico[440][computer_id], 0);
        TextDrawFont(winico[440][computer_id], 2);
        TextDrawColor(winico[440][computer_id], 0x004F8Bff);
        winico[440][used] = 1;
        winico[441][computer_id] = TextDrawCreate(22, 405, ".");
        TextDrawTextSize(winico[441][computer_id], 1, 1);
        TextDrawSetShadow(winico[441][computer_id], 0);
        TextDrawFont(winico[441][computer_id], 2);
        TextDrawColor(winico[441][computer_id], 0x02649Eff);
        winico[441][used] = 1;
        winico[442][computer_id] = TextDrawCreate(23, 405, ".");
        TextDrawTextSize(winico[442][computer_id], 1, 1);
        TextDrawSetShadow(winico[442][computer_id], 0);
        TextDrawFont(winico[442][computer_id], 2);
        TextDrawColor(winico[442][computer_id], 0x00619Cff);
        winico[442][used] = 1;
        winico[443][computer_id] = TextDrawCreate(24, 405, ".");
        TextDrawTextSize(winico[443][computer_id], 1, 1);
        TextDrawSetShadow(winico[443][computer_id], 0);
        TextDrawFont(winico[443][computer_id], 2);
        TextDrawColor(winico[443][computer_id], 0x4086B9ff);
        winico[443][used] = 1;
        winico[444][computer_id] = TextDrawCreate(25, 405, ".");
        TextDrawTextSize(winico[444][computer_id], 1, 1);
        TextDrawSetShadow(winico[444][computer_id], 0);
        TextDrawFont(winico[444][computer_id], 2);
        TextDrawColor(winico[444][computer_id], 0x0A69A0ff);
        winico[444][used] = 1;
        winico[445][computer_id] = TextDrawCreate(26, 405, ".");
        TextDrawTextSize(winico[445][computer_id], 1, 1);
        TextDrawSetShadow(winico[445][computer_id], 0);
        TextDrawFont(winico[445][computer_id], 2);
        TextDrawColor(winico[445][computer_id], 0x065F93ff);
        winico[445][used] = 1;
        winico[446][computer_id] = TextDrawCreate(27, 405, ".");
        TextDrawTextSize(winico[446][computer_id], 1, 1);
        TextDrawSetShadow(winico[446][computer_id], 0);
        TextDrawFont(winico[446][computer_id], 2);
        TextDrawColor(winico[446][computer_id], 0x095F90ff);
        winico[446][used] = 1;
        winico[447][computer_id] = TextDrawCreate(28, 405, ".");
        TextDrawTextSize(winico[447][computer_id], 1, 1);
        TextDrawSetShadow(winico[447][computer_id], 0);
        TextDrawFont(winico[447][computer_id], 2);
        TextDrawColor(winico[447][computer_id], 0x086190ff);
        winico[447][used] = 1;
        winico[448][computer_id] = TextDrawCreate(29, 405, ".");
        TextDrawTextSize(winico[448][computer_id], 1, 1);
        TextDrawSetShadow(winico[448][computer_id], 0);
        TextDrawFont(winico[448][computer_id], 2);
        TextDrawColor(winico[448][computer_id], 0x03669Bff);
        winico[448][used] = 1;
        winico[449][computer_id] = TextDrawCreate(30, 405, ".");
        TextDrawTextSize(winico[449][computer_id], 1, 1);
        TextDrawSetShadow(winico[449][computer_id], 0);
        TextDrawFont(winico[449][computer_id], 2);
        TextDrawColor(winico[449][computer_id], 0x1C7FC0ff);
        winico[449][used] = 1;
        winico[450][computer_id] = TextDrawCreate(31, 405, ".");
        TextDrawTextSize(winico[450][computer_id], 1, 1);
        TextDrawSetShadow(winico[450][computer_id], 0);
        TextDrawFont(winico[450][computer_id], 2);
        TextDrawColor(winico[450][computer_id], 0x2C79A5ff);
        winico[450][used] = 1;
        winico[451][computer_id] = TextDrawCreate(32, 405, ".");
        TextDrawTextSize(winico[451][computer_id], 1, 1);
        TextDrawSetShadow(winico[451][computer_id], 0);
        TextDrawFont(winico[451][computer_id], 2);
        TextDrawColor(winico[451][computer_id], 0xDBC44Aff);
        winico[451][used] = 1;
        winico[452][computer_id] = TextDrawCreate(33, 405, ".");
        TextDrawTextSize(winico[452][computer_id], 1, 1);
        TextDrawSetShadow(winico[452][computer_id], 0);
        TextDrawFont(winico[452][computer_id], 2);
        TextDrawColor(winico[452][computer_id], 0xFFD237ff);
        winico[452][used] = 1;
        winico[453][computer_id] = TextDrawCreate(34, 405, ".");
        TextDrawTextSize(winico[453][computer_id], 1, 1);
        TextDrawSetShadow(winico[453][computer_id], 0);
        TextDrawFont(winico[453][computer_id], 2);
        TextDrawColor(winico[453][computer_id], 0xFED234ff);
        winico[453][used] = 1;
        winico[454][computer_id] = TextDrawCreate(35, 405, ".");
        TextDrawTextSize(winico[454][computer_id], 1, 1);
        TextDrawSetShadow(winico[454][computer_id], 0);
        TextDrawFont(winico[454][computer_id], 2);
        TextDrawColor(winico[454][computer_id], 0xFECD2Bff);
        winico[454][used] = 1;
        winico[455][computer_id] = TextDrawCreate(36, 405, ".");
        TextDrawTextSize(winico[455][computer_id], 1, 1);
        TextDrawSetShadow(winico[455][computer_id], 0);
        TextDrawFont(winico[455][computer_id], 2);
        TextDrawColor(winico[455][computer_id], 0xFFC327ff);
        winico[455][used] = 1;
        winico[456][computer_id] = TextDrawCreate(37, 405, ".");
        TextDrawTextSize(winico[456][computer_id], 1, 1);
        TextDrawSetShadow(winico[456][computer_id], 0);
        TextDrawFont(winico[456][computer_id], 2);
        TextDrawColor(winico[456][computer_id], 0xFAB524ff);
        winico[456][used] = 1;
        winico[457][computer_id] = TextDrawCreate(38, 405, ".");
        TextDrawTextSize(winico[457][computer_id], 1, 1);
        TextDrawSetShadow(winico[457][computer_id], 0);
        TextDrawFont(winico[457][computer_id], 2);
        TextDrawColor(winico[457][computer_id], 0xF6A923ff);
        winico[457][used] = 1;
        winico[458][computer_id] = TextDrawCreate(39, 405, ".");
        TextDrawTextSize(winico[458][computer_id], 1, 1);
        TextDrawSetShadow(winico[458][computer_id], 0);
        TextDrawFont(winico[458][computer_id], 2);
        TextDrawColor(winico[458][computer_id], 0xEF9E19ff);
        winico[458][used] = 1;
        winico[459][computer_id] = TextDrawCreate(40, 405, ".");
        TextDrawTextSize(winico[459][computer_id], 1, 1);
        TextDrawSetShadow(winico[459][computer_id], 0);
        TextDrawFont(winico[459][computer_id], 2);
        TextDrawColor(winico[459][computer_id], 0x0B6498ff);
        winico[459][used] = 1;
        winico[460][computer_id] = TextDrawCreate(41, 405, ".");
        TextDrawTextSize(winico[460][computer_id], 1, 1);
        TextDrawSetShadow(winico[460][computer_id], 0);
        TextDrawFont(winico[460][computer_id], 2);
        TextDrawColor(winico[460][computer_id], 0x0971ADff);
        winico[460][used] = 1;
        winico[461][computer_id] = TextDrawCreate(42, 405, ".");
        TextDrawTextSize(winico[461][computer_id], 1, 1);
        TextDrawSetShadow(winico[461][computer_id], 0);
        TextDrawFont(winico[461][computer_id], 2);
        TextDrawColor(winico[461][computer_id], 0x0977B3ff);
        winico[461][used] = 1;
        winico[462][computer_id] = TextDrawCreate(43, 405, ".");
        TextDrawTextSize(winico[462][computer_id], 1, 1);
        TextDrawSetShadow(winico[462][computer_id], 0);
        TextDrawFont(winico[462][computer_id], 2);
        TextDrawColor(winico[462][computer_id], 0x0973B2ff);
        winico[462][used] = 1;
        winico[463][computer_id] = TextDrawCreate(44, 405, ".");
        TextDrawTextSize(winico[463][computer_id], 1, 1);
        TextDrawSetShadow(winico[463][computer_id], 0);
        TextDrawFont(winico[463][computer_id], 2);
        TextDrawColor(winico[463][computer_id], 0x016FAAff);
        winico[463][used] = 1;
        winico[464][computer_id] = TextDrawCreate(45, 405, ".");
        TextDrawTextSize(winico[464][computer_id], 1, 1);
        TextDrawSetShadow(winico[464][computer_id], 0);
        TextDrawFont(winico[464][computer_id], 2);
        TextDrawColor(winico[464][computer_id], 0x0266A3ff);
        winico[464][used] = 1;
        winico[465][computer_id] = TextDrawCreate(46, 405, ".");
        TextDrawTextSize(winico[465][computer_id], 1, 1);
        TextDrawSetShadow(winico[465][computer_id], 0);
        TextDrawFont(winico[465][computer_id], 2);
        TextDrawColor(winico[465][computer_id], 0x156297ff);
        winico[465][used] = 1;
        winico[466][computer_id] = TextDrawCreate(22, 406, ".");
        TextDrawTextSize(winico[466][computer_id], 1, 1);
        TextDrawSetShadow(winico[466][computer_id], 0);
        TextDrawFont(winico[466][computer_id], 2);
        TextDrawColor(winico[466][computer_id], 0x01639Eff);
        winico[466][used] = 1;
        winico[467][computer_id] = TextDrawCreate(23, 406, ".");
        TextDrawTextSize(winico[467][computer_id], 1, 1);
        TextDrawSetShadow(winico[467][computer_id], 0);
        TextDrawFont(winico[467][computer_id], 2);
        TextDrawColor(winico[467][computer_id], 0x0269A5ff);
        winico[467][used] = 1;
        winico[468][computer_id] = TextDrawCreate(24, 406, ".");
        TextDrawTextSize(winico[468][computer_id], 1, 1);
        TextDrawSetShadow(winico[468][computer_id], 0);
        TextDrawFont(winico[468][computer_id], 2);
        TextDrawColor(winico[468][computer_id], 0x076CAAff);
        winico[468][used] = 1;
        winico[469][computer_id] = TextDrawCreate(25, 406, ".");
        TextDrawTextSize(winico[469][computer_id], 1, 1);
        TextDrawSetShadow(winico[469][computer_id], 0);
        TextDrawFont(winico[469][computer_id], 2);
        TextDrawColor(winico[469][computer_id], 0x0870ABff);
        winico[469][used] = 1;
        winico[470][computer_id] = TextDrawCreate(26, 406, ".");
        TextDrawTextSize(winico[470][computer_id], 1, 1);
        TextDrawSetShadow(winico[470][computer_id], 0);
        TextDrawFont(winico[470][computer_id], 2);
        TextDrawColor(winico[470][computer_id], 0x0A71AEff);
        winico[470][used] = 1;
        winico[471][computer_id] = TextDrawCreate(27, 406, ".");
        TextDrawTextSize(winico[471][computer_id], 1, 1);
        TextDrawSetShadow(winico[471][computer_id], 0);
        TextDrawFont(winico[471][computer_id], 2);
        TextDrawColor(winico[471][computer_id], 0x0C77AFff);
        winico[471][used] = 1;
        winico[472][computer_id] = TextDrawCreate(28, 406, ".");
        TextDrawTextSize(winico[472][computer_id], 1, 1);
        TextDrawSetShadow(winico[472][computer_id], 0);
        TextDrawFont(winico[472][computer_id], 2);
        TextDrawColor(winico[472][computer_id], 0x097AB2ff);
        winico[472][used] = 1;
        winico[473][computer_id] = TextDrawCreate(29, 406, ".");
        TextDrawTextSize(winico[473][computer_id], 1, 1);
        TextDrawSetShadow(winico[473][computer_id], 0);
        TextDrawFont(winico[473][computer_id], 2);
        TextDrawColor(winico[473][computer_id], 0x077BB0ff);
        winico[473][used] = 1;
        winico[474][computer_id] = TextDrawCreate(30, 406, ".");
        TextDrawTextSize(winico[474][computer_id], 1, 1);
        TextDrawSetShadow(winico[474][computer_id], 0);
        TextDrawFont(winico[474][computer_id], 2);
        TextDrawColor(winico[474][computer_id], 0x0879A9ff);
        winico[474][used] = 1;
        winico[475][computer_id] = TextDrawCreate(31, 406, ".");
        TextDrawTextSize(winico[475][computer_id], 1, 1);
        TextDrawSetShadow(winico[475][computer_id], 0);
        TextDrawFont(winico[475][computer_id], 2);
        TextDrawColor(winico[475][computer_id], 0x006FA6ff);
        winico[475][used] = 1;
        winico[476][computer_id] = TextDrawCreate(32, 406, ".");
        TextDrawTextSize(winico[476][computer_id], 1, 1);
        TextDrawSetShadow(winico[476][computer_id], 0);
        TextDrawFont(winico[476][computer_id], 2);
        TextDrawColor(winico[476][computer_id], 0xFFC026ff);
        winico[476][used] = 1;
        winico[477][computer_id] = TextDrawCreate(33, 406, ".");
        TextDrawTextSize(winico[477][computer_id], 1, 1);
        TextDrawSetShadow(winico[477][computer_id], 0);
        TextDrawFont(winico[477][computer_id], 2);
        TextDrawColor(winico[477][computer_id], 0xFEBB26ff);
        winico[477][used] = 1;
        winico[478][computer_id] = TextDrawCreate(34, 406, ".");
        TextDrawTextSize(winico[478][computer_id], 1, 1);
        TextDrawSetShadow(winico[478][computer_id], 0);
        TextDrawFont(winico[478][computer_id], 2);
        TextDrawColor(winico[478][computer_id], 0xFDBA26ff);
        winico[478][used] = 1;
        winico[479][computer_id] = TextDrawCreate(35, 406, ".");
        TextDrawTextSize(winico[479][computer_id], 1, 1);
        TextDrawSetShadow(winico[479][computer_id], 0);
        TextDrawFont(winico[479][computer_id], 2);
        TextDrawColor(winico[479][computer_id], 0xF9B524ff);
        winico[479][used] = 1;
        winico[480][computer_id] = TextDrawCreate(36, 406, ".");
        TextDrawTextSize(winico[480][computer_id], 1, 1);
        TextDrawSetShadow(winico[480][computer_id], 0);
        TextDrawFont(winico[480][computer_id], 2);
        TextDrawColor(winico[480][computer_id], 0xF6AD21ff);
        winico[480][used] = 1;
        winico[481][computer_id] = TextDrawCreate(37, 406, ".");
        TextDrawTextSize(winico[481][computer_id], 1, 1);
        TextDrawSetShadow(winico[481][computer_id], 0);
        TextDrawFont(winico[481][computer_id], 2);
        TextDrawColor(winico[481][computer_id], 0xF9A21Fff);
        winico[481][used] = 1;
        winico[482][computer_id] = TextDrawCreate(38, 406, ".");
        TextDrawTextSize(winico[482][computer_id], 1, 1);
        TextDrawSetShadow(winico[482][computer_id], 0);
        TextDrawFont(winico[482][computer_id], 2);
        TextDrawColor(winico[482][computer_id], 0xF39A1Aff);
        winico[482][used] = 1;
        winico[483][computer_id] = TextDrawCreate(39, 406, ".");
        TextDrawTextSize(winico[483][computer_id], 1, 1);
        TextDrawSetShadow(winico[483][computer_id], 0);
        TextDrawFont(winico[483][computer_id], 2);
        TextDrawColor(winico[483][computer_id], 0xBC9832ff);
        winico[483][used] = 1;
        winico[484][computer_id] = TextDrawCreate(40, 406, ".");
        TextDrawTextSize(winico[484][computer_id], 1, 1);
        TextDrawSetShadow(winico[484][computer_id], 0);
        TextDrawFont(winico[484][computer_id], 2);
        TextDrawColor(winico[484][computer_id], 0x066FAAff);
        winico[484][used] = 1;
        winico[485][computer_id] = TextDrawCreate(41, 406, ".");
        TextDrawTextSize(winico[485][computer_id], 1, 1);
        TextDrawSetShadow(winico[485][computer_id], 0);
        TextDrawFont(winico[485][computer_id], 2);
        TextDrawColor(winico[485][computer_id], 0x0E7AB6ff);
        winico[485][used] = 1;
        winico[486][computer_id] = TextDrawCreate(42, 406, ".");
        TextDrawTextSize(winico[486][computer_id], 1, 1);
        TextDrawSetShadow(winico[486][computer_id], 0);
        TextDrawFont(winico[486][computer_id], 2);
        TextDrawColor(winico[486][computer_id], 0x097CBEff);
        winico[486][used] = 1;
        winico[487][computer_id] = TextDrawCreate(43, 406, ".");
        TextDrawTextSize(winico[487][computer_id], 1, 1);
        TextDrawSetShadow(winico[487][computer_id], 0);
        TextDrawFont(winico[487][computer_id], 2);
        TextDrawColor(winico[487][computer_id], 0x0879B8ff);
        winico[487][used] = 1;
        winico[488][computer_id] = TextDrawCreate(44, 406, ".");
        TextDrawTextSize(winico[488][computer_id], 1, 1);
        TextDrawSetShadow(winico[488][computer_id], 0);
        TextDrawFont(winico[488][computer_id], 2);
        TextDrawColor(winico[488][computer_id], 0x0771AFff);
        winico[488][used] = 1;
        winico[489][computer_id] = TextDrawCreate(45, 406, ".");
        TextDrawTextSize(winico[489][computer_id], 1, 1);
        TextDrawSetShadow(winico[489][computer_id], 0);
        TextDrawFont(winico[489][computer_id], 2);
        TextDrawColor(winico[489][computer_id], 0x0063A0ff);
        winico[489][used] = 1;
        winico[490][computer_id] = TextDrawCreate(22, 407, ".");
        TextDrawTextSize(winico[490][computer_id], 1, 1);
        TextDrawSetShadow(winico[490][computer_id], 0);
        TextDrawFont(winico[490][computer_id], 2);
        TextDrawColor(winico[490][computer_id], 0x035F9Eff);
        winico[490][used] = 1;
        winico[491][computer_id] = TextDrawCreate(23, 407, ".");
        TextDrawTextSize(winico[491][computer_id], 1, 1);
        TextDrawSetShadow(winico[491][computer_id], 0);
        TextDrawFont(winico[491][computer_id], 2);
        TextDrawColor(winico[491][computer_id], 0x0471ABff);
        winico[491][used] = 1;
        winico[492][computer_id] = TextDrawCreate(24, 407, ".");
        TextDrawTextSize(winico[492][computer_id], 1, 1);
        TextDrawSetShadow(winico[492][computer_id], 0);
        TextDrawFont(winico[492][computer_id], 2);
        TextDrawColor(winico[492][computer_id], 0x0977B5ff);
        winico[492][used] = 1;
        winico[493][computer_id] = TextDrawCreate(25, 407, ".");
        TextDrawTextSize(winico[493][computer_id], 1, 1);
        TextDrawSetShadow(winico[493][computer_id], 0);
        TextDrawFont(winico[493][computer_id], 2);
        TextDrawColor(winico[493][computer_id], 0x0A7CBAff);
        winico[493][used] = 1;
        winico[494][computer_id] = TextDrawCreate(26, 407, ".");
        TextDrawTextSize(winico[494][computer_id], 1, 1);
        TextDrawSetShadow(winico[494][computer_id], 0);
        TextDrawFont(winico[494][computer_id], 2);
        TextDrawColor(winico[494][computer_id], 0x1082C0ff);
        winico[494][used] = 1;
        winico[495][computer_id] = TextDrawCreate(27, 407, ".");
        TextDrawTextSize(winico[495][computer_id], 1, 1);
        TextDrawSetShadow(winico[495][computer_id], 0);
        TextDrawFont(winico[495][computer_id], 2);
        TextDrawColor(winico[495][computer_id], 0x0988C5ff);
        winico[495][used] = 1;
        winico[496][computer_id] = TextDrawCreate(28, 407, ".");
        TextDrawTextSize(winico[496][computer_id], 1, 1);
        TextDrawSetShadow(winico[496][computer_id], 0);
        TextDrawFont(winico[496][computer_id], 2);
        TextDrawColor(winico[496][computer_id], 0x078CC9ff);
        winico[496][used] = 1;
        winico[497][computer_id] = TextDrawCreate(29, 407, ".");
        TextDrawTextSize(winico[497][computer_id], 1, 1);
        TextDrawSetShadow(winico[497][computer_id], 0);
        TextDrawFont(winico[497][computer_id], 2);
        TextDrawColor(winico[497][computer_id], 0x0A90C9ff);
        winico[497][used] = 1;
        winico[498][computer_id] = TextDrawCreate(30, 407, ".");
        TextDrawTextSize(winico[498][computer_id], 1, 1);
        TextDrawSetShadow(winico[498][computer_id], 0);
        TextDrawFont(winico[498][computer_id], 2);
        TextDrawColor(winico[498][computer_id], 0x098EC5ff);
        winico[498][used] = 1;
        winico[499][computer_id] = TextDrawCreate(31, 407, ".");
        TextDrawTextSize(winico[499][computer_id], 1, 1);
        TextDrawSetShadow(winico[499][computer_id], 0);
        TextDrawFont(winico[499][computer_id], 2);
        TextDrawColor(winico[499][computer_id], 0x038BC0ff);
        winico[499][used] = 1;
        winico[500][computer_id] = TextDrawCreate(32, 407, ".");
        TextDrawTextSize(winico[500][computer_id], 1, 1);
        TextDrawSetShadow(winico[500][computer_id], 0);
        TextDrawFont(winico[500][computer_id], 2);
        TextDrawColor(winico[500][computer_id], 0x0180B3ff);
        winico[500][used] = 1;
        winico[501][computer_id] = TextDrawCreate(33, 407, ".");
        TextDrawTextSize(winico[501][computer_id], 1, 1);
        TextDrawSetShadow(winico[501][computer_id], 0);
        TextDrawFont(winico[501][computer_id], 2);
        TextDrawColor(winico[501][computer_id], 0x96914Eff);
        winico[501][used] = 1;
        winico[502][computer_id] = TextDrawCreate(34, 407, ".");
        TextDrawTextSize(winico[502][computer_id], 1, 1);
        TextDrawSetShadow(winico[502][computer_id], 0);
        TextDrawFont(winico[502][computer_id], 2);
        TextDrawColor(winico[502][computer_id], 0xF5A81Eff);
        winico[502][used] = 1;
        winico[503][computer_id] = TextDrawCreate(35, 407, ".");
        TextDrawTextSize(winico[503][computer_id], 1, 1);
        TextDrawSetShadow(winico[503][computer_id], 0);
        TextDrawFont(winico[503][computer_id], 2);
        TextDrawColor(winico[503][computer_id], 0xFEA817ff);
        winico[503][used] = 1;
        winico[504][computer_id] = TextDrawCreate(36, 407, ".");
        TextDrawTextSize(winico[504][computer_id], 1, 1);
        TextDrawSetShadow(winico[504][computer_id], 0);
        TextDrawFont(winico[504][computer_id], 2);
        TextDrawColor(winico[504][computer_id], 0xFDA217ff);
        winico[504][used] = 1;
        winico[505][computer_id] = TextDrawCreate(37, 407, ".");
        TextDrawTextSize(winico[505][computer_id], 1, 1);
        TextDrawSetShadow(winico[505][computer_id], 0);
        TextDrawFont(winico[505][computer_id], 2);
        TextDrawColor(winico[505][computer_id], 0xF29C1Bff);
        winico[505][used] = 1;
        winico[506][computer_id] = TextDrawCreate(38, 407, ".");
        TextDrawTextSize(winico[506][computer_id], 1, 1);
        TextDrawSetShadow(winico[506][computer_id], 0);
        TextDrawFont(winico[506][computer_id], 2);
        TextDrawColor(winico[506][computer_id], 0xAD8F42ff);
        winico[506][used] = 1;
        winico[507][computer_id] = TextDrawCreate(39, 407, ".");
        TextDrawTextSize(winico[507][computer_id], 1, 1);
        TextDrawSetShadow(winico[507][computer_id], 0);
        TextDrawFont(winico[507][computer_id], 2);
        TextDrawColor(winico[507][computer_id], 0x257B96ff);
        winico[507][used] = 1;
        winico[508][computer_id] = TextDrawCreate(40, 407, ".");
        TextDrawTextSize(winico[508][computer_id], 1, 1);
        TextDrawSetShadow(winico[508][computer_id], 0);
        TextDrawFont(winico[508][computer_id], 2);
        TextDrawColor(winico[508][computer_id], 0x077FB9ff);
        winico[508][used] = 1;
        winico[509][computer_id] = TextDrawCreate(41, 407, ".");
        TextDrawTextSize(winico[509][computer_id], 1, 1);
        TextDrawSetShadow(winico[509][computer_id], 0);
        TextDrawFont(winico[509][computer_id], 2);
        TextDrawColor(winico[509][computer_id], 0x0F83BEff);
        winico[509][used] = 1;
        winico[510][computer_id] = TextDrawCreate(42, 407, ".");
        TextDrawTextSize(winico[510][computer_id], 1, 1);
        TextDrawSetShadow(winico[510][computer_id], 0);
        TextDrawFont(winico[510][computer_id], 2);
        TextDrawColor(winico[510][computer_id], 0x0D82C7ff);
        winico[510][used] = 1;
        winico[511][computer_id] = TextDrawCreate(43, 407, ".");
        TextDrawTextSize(winico[511][computer_id], 1, 1);
        TextDrawSetShadow(winico[511][computer_id], 0);
        TextDrawFont(winico[511][computer_id], 2);
        TextDrawColor(winico[511][computer_id], 0x077BBDff);
        winico[511][used] = 1;
        winico[512][computer_id] = TextDrawCreate(44, 407, ".");
        TextDrawTextSize(winico[512][computer_id], 1, 1);
        TextDrawSetShadow(winico[512][computer_id], 0);
        TextDrawFont(winico[512][computer_id], 2);
        TextDrawColor(winico[512][computer_id], 0x0471B2ff);
        winico[512][used] = 1;
        winico[513][computer_id] = TextDrawCreate(45, 407, ".");
        TextDrawTextSize(winico[513][computer_id], 1, 1);
        TextDrawSetShadow(winico[513][computer_id], 0);
        TextDrawFont(winico[513][computer_id], 2);
        TextDrawColor(winico[513][computer_id], 0x508DB6ff);
        winico[513][used] = 1;
        winico[514][computer_id] = TextDrawCreate(23, 408, ".");
        TextDrawTextSize(winico[514][computer_id], 1, 1);
        TextDrawSetShadow(winico[514][computer_id], 0);
        TextDrawFont(winico[514][computer_id], 2);
        TextDrawColor(winico[514][computer_id], 0x0066AAff);
        winico[514][used] = 1;
        winico[515][computer_id] = TextDrawCreate(24, 408, ".");
        TextDrawTextSize(winico[515][computer_id], 1, 1);
        TextDrawSetShadow(winico[515][computer_id], 0);
        TextDrawFont(winico[515][computer_id], 2);
        TextDrawColor(winico[515][computer_id], 0x087BBEff);
        winico[515][used] = 1;
        winico[516][computer_id] = TextDrawCreate(25, 408, ".");
        TextDrawTextSize(winico[516][computer_id], 1, 1);
        TextDrawSetShadow(winico[516][computer_id], 0);
        TextDrawFont(winico[516][computer_id], 2);
        TextDrawColor(winico[516][computer_id], 0x0F82C6ff);
        winico[516][used] = 1;
        winico[517][computer_id] = TextDrawCreate(26, 408, ".");
        TextDrawTextSize(winico[517][computer_id], 1, 1);
        TextDrawSetShadow(winico[517][computer_id], 0);
        TextDrawFont(winico[517][computer_id], 2);
        TextDrawColor(winico[517][computer_id], 0x0E88C7ff);
        winico[517][used] = 1;
        winico[518][computer_id] = TextDrawCreate(27, 408, ".");
        TextDrawTextSize(winico[518][computer_id], 1, 1);
        TextDrawSetShadow(winico[518][computer_id], 0);
        TextDrawFont(winico[518][computer_id], 2);
        TextDrawColor(winico[518][computer_id], 0x0791CEff);
        winico[518][used] = 1;
        winico[519][computer_id] = TextDrawCreate(28, 408, ".");
        TextDrawTextSize(winico[519][computer_id], 1, 1);
        TextDrawSetShadow(winico[519][computer_id], 0);
        TextDrawFont(winico[519][computer_id], 2);
        TextDrawColor(winico[519][computer_id], 0x0B96D4ff);
        winico[519][used] = 1;
        winico[520][computer_id] = TextDrawCreate(29, 408, ".");
        TextDrawTextSize(winico[520][computer_id], 1, 1);
        TextDrawSetShadow(winico[520][computer_id], 0);
        TextDrawFont(winico[520][computer_id], 2);
        TextDrawColor(winico[520][computer_id], 0x0B9AD6ff);
        winico[520][used] = 1;
        winico[521][computer_id] = TextDrawCreate(30, 408, ".");
        TextDrawTextSize(winico[521][computer_id], 1, 1);
        TextDrawSetShadow(winico[521][computer_id], 0);
        TextDrawFont(winico[521][computer_id], 2);
        TextDrawColor(winico[521][computer_id], 0x089ED5ff);
        winico[521][used] = 1;
        winico[522][computer_id] = TextDrawCreate(31, 408, ".");
        TextDrawTextSize(winico[522][computer_id], 1, 1);
        TextDrawSetShadow(winico[522][computer_id], 0);
        TextDrawFont(winico[522][computer_id], 2);
        TextDrawColor(winico[522][computer_id], 0x079ED5ff);
        winico[522][used] = 1;
        winico[523][computer_id] = TextDrawCreate(32, 408, ".");
        TextDrawTextSize(winico[523][computer_id], 1, 1);
        TextDrawSetShadow(winico[523][computer_id], 0);
        TextDrawFont(winico[523][computer_id], 2);
        TextDrawColor(winico[523][computer_id], 0x089ACEff);
        winico[523][used] = 1;
        winico[524][computer_id] = TextDrawCreate(33, 408, ".");
        TextDrawTextSize(winico[524][computer_id], 1, 1);
        TextDrawSetShadow(winico[524][computer_id], 0);
        TextDrawFont(winico[524][computer_id], 2);
        TextDrawColor(winico[524][computer_id], 0x0793C6ff);
        winico[524][used] = 1;
        winico[525][computer_id] = TextDrawCreate(34, 408, ".");
        TextDrawTextSize(winico[525][computer_id], 1, 1);
        TextDrawSetShadow(winico[525][computer_id], 0);
        TextDrawFont(winico[525][computer_id], 2);
        TextDrawColor(winico[525][computer_id], 0x008BBFff);
        winico[525][used] = 1;
        winico[526][computer_id] = TextDrawCreate(35, 408, ".");
        TextDrawTextSize(winico[526][computer_id], 1, 1);
        TextDrawSetShadow(winico[526][computer_id], 0);
        TextDrawFont(winico[526][computer_id], 2);
        TextDrawColor(winico[526][computer_id], 0x0084B7ff);
        winico[526][used] = 1;
        winico[527][computer_id] = TextDrawCreate(36, 408, ".");
        TextDrawTextSize(winico[527][computer_id], 1, 1);
        TextDrawSetShadow(winico[527][computer_id], 0);
        TextDrawFont(winico[527][computer_id], 2);
        TextDrawColor(winico[527][computer_id], 0x0080B5ff);
        winico[527][used] = 1;
        winico[528][computer_id] = TextDrawCreate(37, 408, ".");
        TextDrawTextSize(winico[528][computer_id], 1, 1);
        TextDrawSetShadow(winico[528][computer_id], 0);
        TextDrawFont(winico[528][computer_id], 2);
        TextDrawColor(winico[528][computer_id], 0x0080BAff);
        winico[528][used] = 1;
        winico[529][computer_id] = TextDrawCreate(38, 408, ".");
        TextDrawTextSize(winico[529][computer_id], 1, 1);
        TextDrawSetShadow(winico[529][computer_id], 0);
        TextDrawFont(winico[529][computer_id], 2);
        TextDrawColor(winico[529][computer_id], 0x0486BBff);
        winico[529][used] = 1;
        winico[530][computer_id] = TextDrawCreate(39, 408, ".");
        TextDrawTextSize(winico[530][computer_id], 1, 1);
        TextDrawSetShadow(winico[530][computer_id], 0);
        TextDrawFont(winico[530][computer_id], 2);
        TextDrawColor(winico[530][computer_id], 0x0988BFff);
        winico[530][used] = 1;
        winico[531][computer_id] = TextDrawCreate(40, 408, ".");
        TextDrawTextSize(winico[531][computer_id], 1, 1);
        TextDrawSetShadow(winico[531][computer_id], 0);
        TextDrawFont(winico[531][computer_id], 2);
        TextDrawColor(winico[531][computer_id], 0x078CC8ff);
        winico[531][used] = 1;
        winico[532][computer_id] = TextDrawCreate(41, 408, ".");
        TextDrawTextSize(winico[532][computer_id], 1, 1);
        TextDrawSetShadow(winico[532][computer_id], 0);
        TextDrawFont(winico[532][computer_id], 2);
        TextDrawColor(winico[532][computer_id], 0x0B89C7ff);
        winico[532][used] = 1;
        winico[533][computer_id] = TextDrawCreate(42, 408, ".");
        TextDrawTextSize(winico[533][computer_id], 1, 1);
        TextDrawSetShadow(winico[533][computer_id], 0);
        TextDrawFont(winico[533][computer_id], 2);
        TextDrawColor(winico[533][computer_id], 0x1085C8ff);
        winico[533][used] = 1;
        winico[534][computer_id] = TextDrawCreate(43, 408, ".");
        TextDrawTextSize(winico[534][computer_id], 1, 1);
        TextDrawSetShadow(winico[534][computer_id], 0);
        TextDrawFont(winico[534][computer_id], 2);
        TextDrawColor(winico[534][computer_id], 0x0B7DC1ff);
        winico[534][used] = 1;
        winico[535][computer_id] = TextDrawCreate(44, 408, ".");
        TextDrawTextSize(winico[535][computer_id], 1, 1);
        TextDrawSetShadow(winico[535][computer_id], 0);
        TextDrawFont(winico[535][computer_id], 2);
        TextDrawColor(winico[535][computer_id], 0x076FAFff);
        winico[535][used] = 1;
        winico[536][computer_id] = TextDrawCreate(24, 409, ".");
        TextDrawTextSize(winico[536][computer_id], 1, 1);
        TextDrawSetShadow(winico[536][computer_id], 0);
        TextDrawFont(winico[536][computer_id], 2);
        TextDrawColor(winico[536][computer_id], 0x0073B7ff);
        winico[536][used] = 1;
        winico[537][computer_id] = TextDrawCreate(25, 409, ".");
        TextDrawTextSize(winico[537][computer_id], 1, 1);
        TextDrawSetShadow(winico[537][computer_id], 0);
        TextDrawFont(winico[537][computer_id], 2);
        TextDrawColor(winico[537][computer_id], 0x1085C6ff);
        winico[537][used] = 1;
        winico[538][computer_id] = TextDrawCreate(26, 409, ".");
        TextDrawTextSize(winico[538][computer_id], 1, 1);
        TextDrawSetShadow(winico[538][computer_id], 0);
        TextDrawFont(winico[538][computer_id], 2);
        TextDrawColor(winico[538][computer_id], 0x0B8CCCff);
        winico[538][used] = 1;
        winico[539][computer_id] = TextDrawCreate(27, 409, ".");
        TextDrawTextSize(winico[539][computer_id], 1, 1);
        TextDrawSetShadow(winico[539][computer_id], 0);
        TextDrawFont(winico[539][computer_id], 2);
        TextDrawColor(winico[539][computer_id], 0x0993D3ff);
        winico[539][used] = 1;
        winico[540][computer_id] = TextDrawCreate(28, 409, ".");
        TextDrawTextSize(winico[540][computer_id], 1, 1);
        TextDrawSetShadow(winico[540][computer_id], 0);
        TextDrawFont(winico[540][computer_id], 2);
        TextDrawColor(winico[540][computer_id], 0x109AD7ff);
        winico[540][used] = 1;
        winico[541][computer_id] = TextDrawCreate(29, 409, ".");
        TextDrawTextSize(winico[541][computer_id], 1, 1);
        TextDrawSetShadow(winico[541][computer_id], 0);
        TextDrawFont(winico[541][computer_id], 2);
        TextDrawColor(winico[541][computer_id], 0x07A1DEff);
        winico[541][used] = 1;
        winico[542][computer_id] = TextDrawCreate(30, 409, ".");
        TextDrawTextSize(winico[542][computer_id], 1, 1);
        TextDrawSetShadow(winico[542][computer_id], 0);
        TextDrawFont(winico[542][computer_id], 2);
        TextDrawColor(winico[542][computer_id], 0x08A6E2ff);
        winico[542][used] = 1;
        winico[543][computer_id] = TextDrawCreate(31, 409, ".");
        TextDrawTextSize(winico[543][computer_id], 1, 1);
        TextDrawSetShadow(winico[543][computer_id], 0);
        TextDrawFont(winico[543][computer_id], 2);
        TextDrawColor(winico[543][computer_id], 0x0EABE2ff);
        winico[543][used] = 1;
        winico[544][computer_id] = TextDrawCreate(32, 409, ".");
        TextDrawTextSize(winico[544][computer_id], 1, 1);
        TextDrawSetShadow(winico[544][computer_id], 0);
        TextDrawFont(winico[544][computer_id], 2);
        TextDrawColor(winico[544][computer_id], 0x11ABDDff);
        winico[544][used] = 1;
        winico[545][computer_id] = TextDrawCreate(33, 409, ".");
        TextDrawTextSize(winico[545][computer_id], 1, 1);
        TextDrawSetShadow(winico[545][computer_id], 0);
        TextDrawFont(winico[545][computer_id], 2);
        TextDrawColor(winico[545][computer_id], 0x10A7DBff);
        winico[545][used] = 1;
        winico[546][computer_id] = TextDrawCreate(34, 409, ".");
        TextDrawTextSize(winico[546][computer_id], 1, 1);
        TextDrawSetShadow(winico[546][computer_id], 0);
        TextDrawFont(winico[546][computer_id], 2);
        TextDrawColor(winico[546][computer_id], 0x0EA3D7ff);
        winico[546][used] = 1;
        winico[547][computer_id] = TextDrawCreate(35, 409, ".");
        TextDrawTextSize(winico[547][computer_id], 1, 1);
        TextDrawSetShadow(winico[547][computer_id], 0);
        TextDrawFont(winico[547][computer_id], 2);
        TextDrawColor(winico[547][computer_id], 0x0AA0D1ff);
        winico[547][used] = 1;
        winico[548][computer_id] = TextDrawCreate(36, 409, ".");
        TextDrawTextSize(winico[548][computer_id], 1, 1);
        TextDrawSetShadow(winico[548][computer_id], 0);
        TextDrawFont(winico[548][computer_id], 2);
        TextDrawColor(winico[548][computer_id], 0x089DD3ff);
        winico[548][used] = 1;
        winico[549][computer_id] = TextDrawCreate(37, 409, ".");
        TextDrawTextSize(winico[549][computer_id], 1, 1);
        TextDrawSetShadow(winico[549][computer_id], 0);
        TextDrawFont(winico[549][computer_id], 2);
        TextDrawColor(winico[549][computer_id], 0x059CD0ff);
        winico[549][used] = 1;
        winico[550][computer_id] = TextDrawCreate(38, 409, ".");
        TextDrawTextSize(winico[550][computer_id], 1, 1);
        TextDrawSetShadow(winico[550][computer_id], 0);
        TextDrawFont(winico[550][computer_id], 2);
        TextDrawColor(winico[550][computer_id], 0x0398D2ff);
        winico[550][used] = 1;
        winico[551][computer_id] = TextDrawCreate(39, 409, ".");
        TextDrawTextSize(winico[551][computer_id], 1, 1);
        TextDrawSetShadow(winico[551][computer_id], 0);
        TextDrawFont(winico[551][computer_id], 2);
        TextDrawColor(winico[551][computer_id], 0x0B95D0ff);
        winico[551][used] = 1;
        winico[552][computer_id] = TextDrawCreate(40, 409, ".");
        TextDrawTextSize(winico[552][computer_id], 1, 1);
        TextDrawSetShadow(winico[552][computer_id], 0);
        TextDrawFont(winico[552][computer_id], 2);
        TextDrawColor(winico[552][computer_id], 0x0A94CEff);
        winico[552][used] = 1;
        winico[553][computer_id] = TextDrawCreate(41, 409, ".");
        TextDrawTextSize(winico[553][computer_id], 1, 1);
        TextDrawSetShadow(winico[553][computer_id], 0);
        TextDrawFont(winico[553][computer_id], 2);
        TextDrawColor(winico[553][computer_id], 0x098DCFff);
        winico[553][used] = 1;
        winico[554][computer_id] = TextDrawCreate(42, 409, ".");
        TextDrawTextSize(winico[554][computer_id], 1, 1);
        TextDrawSetShadow(winico[554][computer_id], 0);
        TextDrawFont(winico[554][computer_id], 2);
        TextDrawColor(winico[554][computer_id], 0x0F86C6ff);
        winico[554][used] = 1;
        winico[555][computer_id] = TextDrawCreate(43, 409, ".");
        TextDrawTextSize(winico[555][computer_id], 1, 1);
        TextDrawSetShadow(winico[555][computer_id], 0);
        TextDrawFont(winico[555][computer_id], 2);
        TextDrawColor(winico[555][computer_id], 0x0678BEff);
        winico[555][used] = 1;
        winico[556][computer_id] = TextDrawCreate(25, 410, ".");
        TextDrawTextSize(winico[556][computer_id], 1, 1);
        TextDrawSetShadow(winico[556][computer_id], 0);
        TextDrawFont(winico[556][computer_id], 2);
        TextDrawColor(winico[556][computer_id], 0x007AC0ff);
        winico[556][used] = 1;
        winico[557][computer_id] = TextDrawCreate(26, 410, ".");
        TextDrawTextSize(winico[557][computer_id], 1, 1);
        TextDrawSetShadow(winico[557][computer_id], 0);
        TextDrawFont(winico[557][computer_id], 2);
        TextDrawColor(winico[557][computer_id], 0x098DCEff);
        winico[557][used] = 1;
        winico[558][computer_id] = TextDrawCreate(27, 410, ".");
        TextDrawTextSize(winico[558][computer_id], 1, 1);
        TextDrawSetShadow(winico[558][computer_id], 0);
        TextDrawFont(winico[558][computer_id], 2);
        TextDrawColor(winico[558][computer_id], 0x0A95D7ff);
        winico[558][used] = 1;
        winico[559][computer_id] = TextDrawCreate(28, 410, ".");
        TextDrawTextSize(winico[559][computer_id], 1, 1);
        TextDrawSetShadow(winico[559][computer_id], 0);
        TextDrawFont(winico[559][computer_id], 2);
        TextDrawColor(winico[559][computer_id], 0x119CDAff);
        winico[559][used] = 1;
        winico[560][computer_id] = TextDrawCreate(29, 410, ".");
        TextDrawTextSize(winico[560][computer_id], 1, 1);
        TextDrawSetShadow(winico[560][computer_id], 0);
        TextDrawFont(winico[560][computer_id], 2);
        TextDrawColor(winico[560][computer_id], 0x09A5DFff);
        winico[560][used] = 1;
        winico[561][computer_id] = TextDrawCreate(30, 410, ".");
        TextDrawTextSize(winico[561][computer_id], 1, 1);
        TextDrawSetShadow(winico[561][computer_id], 0);
        TextDrawFont(winico[561][computer_id], 2);
        TextDrawColor(winico[561][computer_id], 0x0DAAE9ff);
        winico[561][used] = 1;
        winico[562][computer_id] = TextDrawCreate(31, 410, ".");
        TextDrawTextSize(winico[562][computer_id], 1, 1);
        TextDrawSetShadow(winico[562][computer_id], 0);
        TextDrawFont(winico[562][computer_id], 2);
        TextDrawColor(winico[562][computer_id], 0x10B1E7ff);
        winico[562][used] = 1;
        winico[563][computer_id] = TextDrawCreate(32, 410, ".");
        TextDrawTextSize(winico[563][computer_id], 1, 1);
        TextDrawSetShadow(winico[563][computer_id], 0);
        TextDrawFont(winico[563][computer_id], 2);
        TextDrawColor(winico[563][computer_id], 0x16B2E8ff);
        winico[563][used] = 1;
        winico[564][computer_id] = TextDrawCreate(33, 410, ".");
        TextDrawTextSize(winico[564][computer_id], 1, 1);
        TextDrawSetShadow(winico[564][computer_id], 0);
        TextDrawFont(winico[564][computer_id], 2);
        TextDrawColor(winico[564][computer_id], 0x1AB0E7ff);
        winico[564][used] = 1;
        winico[565][computer_id] = TextDrawCreate(34, 410, ".");
        TextDrawTextSize(winico[565][computer_id], 1, 1);
        TextDrawSetShadow(winico[565][computer_id], 0);
        TextDrawFont(winico[565][computer_id], 2);
        TextDrawColor(winico[565][computer_id], 0x14AFE6ff);
        winico[565][used] = 1;
        winico[566][computer_id] = TextDrawCreate(35, 410, ".");
        TextDrawTextSize(winico[566][computer_id], 1, 1);
        TextDrawSetShadow(winico[566][computer_id], 0);
        TextDrawFont(winico[566][computer_id], 2);
        TextDrawColor(winico[566][computer_id], 0x11ADE2ff);
        winico[566][used] = 1;
        winico[567][computer_id] = TextDrawCreate(36, 410, ".");
        TextDrawTextSize(winico[567][computer_id], 1, 1);
        TextDrawSetShadow(winico[567][computer_id], 0);
        TextDrawFont(winico[567][computer_id], 2);
        TextDrawColor(winico[567][computer_id], 0x0FACE3ff);
        winico[567][used] = 1;
        winico[568][computer_id] = TextDrawCreate(37, 410, ".");
        TextDrawTextSize(winico[568][computer_id], 1, 1);
        TextDrawSetShadow(winico[568][computer_id], 0);
        TextDrawFont(winico[568][computer_id], 2);
        TextDrawColor(winico[568][computer_id], 0x07A8E2ff);
        winico[568][used] = 1;
        winico[569][computer_id] = TextDrawCreate(38, 410, ".");
        TextDrawTextSize(winico[569][computer_id], 1, 1);
        TextDrawSetShadow(winico[569][computer_id], 0);
        TextDrawFont(winico[569][computer_id], 2);
        TextDrawColor(winico[569][computer_id], 0x08A2DDff);
        winico[569][used] = 1;
        winico[570][computer_id] = TextDrawCreate(39, 410, ".");
        TextDrawTextSize(winico[570][computer_id], 1, 1);
        TextDrawSetShadow(winico[570][computer_id], 0);
        TextDrawFont(winico[570][computer_id], 2);
        TextDrawColor(winico[570][computer_id], 0x0A9CD6ff);
        winico[570][used] = 1;
        winico[571][computer_id] = TextDrawCreate(40, 410, ".");
        TextDrawTextSize(winico[571][computer_id], 1, 1);
        TextDrawSetShadow(winico[571][computer_id], 0);
        TextDrawFont(winico[571][computer_id], 2);
        TextDrawColor(winico[571][computer_id], 0x0B96D8ff);
        winico[571][used] = 1;
        winico[572][computer_id] = TextDrawCreate(41, 410, ".");
        TextDrawTextSize(winico[572][computer_id], 1, 1);
        TextDrawSetShadow(winico[572][computer_id], 0);
        TextDrawFont(winico[572][computer_id], 2);
        TextDrawColor(winico[572][computer_id], 0x088ECFff);
        winico[572][used] = 1;
        winico[573][computer_id] = TextDrawCreate(42, 410, ".");
        TextDrawTextSize(winico[573][computer_id], 1, 1);
        TextDrawSetShadow(winico[573][computer_id], 0);
        TextDrawFont(winico[573][computer_id], 2);
        TextDrawColor(winico[573][computer_id], 0x1585C3ff);
        winico[573][used] = 1;
        winico[574][computer_id] = TextDrawCreate(26, 411, ".");
        TextDrawTextSize(winico[574][computer_id], 1, 1);
        TextDrawSetShadow(winico[574][computer_id], 0);
        TextDrawFont(winico[574][computer_id], 2);
        TextDrawColor(winico[574][computer_id], 0x3C9ED1ff);
        winico[574][used] = 1;
        winico[575][computer_id] = TextDrawCreate(27, 411, ".");
        TextDrawTextSize(winico[575][computer_id], 1, 1);
        TextDrawSetShadow(winico[575][computer_id], 0);
        TextDrawFont(winico[575][computer_id], 2);
        TextDrawColor(winico[575][computer_id], 0x048FD1ff);
        winico[575][used] = 1;
        winico[576][computer_id] = TextDrawCreate(28, 411, ".");
        TextDrawTextSize(winico[576][computer_id], 1, 1);
        TextDrawSetShadow(winico[576][computer_id], 0);
        TextDrawFont(winico[576][computer_id], 2);
        TextDrawColor(winico[576][computer_id], 0x109DD9ff);
        winico[576][used] = 1;
        winico[577][computer_id] = TextDrawCreate(29, 411, ".");
        TextDrawTextSize(winico[577][computer_id], 1, 1);
        TextDrawSetShadow(winico[577][computer_id], 0);
        TextDrawFont(winico[577][computer_id], 2);
        TextDrawColor(winico[577][computer_id], 0x0BA5DFff);
        winico[577][used] = 1;
        winico[578][computer_id] = TextDrawCreate(30, 411, ".");
        TextDrawTextSize(winico[578][computer_id], 1, 1);
        TextDrawSetShadow(winico[578][computer_id], 0);
        TextDrawFont(winico[578][computer_id], 2);
        TextDrawColor(winico[578][computer_id], 0x10ADE6ff);
        winico[578][used] = 1;
        winico[579][computer_id] = TextDrawCreate(31, 411, ".");
        TextDrawTextSize(winico[579][computer_id], 1, 1);
        TextDrawSetShadow(winico[579][computer_id], 0);
        TextDrawFont(winico[579][computer_id], 2);
        TextDrawColor(winico[579][computer_id], 0x18B4E7ff);
        winico[579][used] = 1;
        winico[580][computer_id] = TextDrawCreate(32, 411, ".");
        TextDrawTextSize(winico[580][computer_id], 1, 1);
        TextDrawSetShadow(winico[580][computer_id], 0);
        TextDrawFont(winico[580][computer_id], 2);
        TextDrawColor(winico[580][computer_id], 0x1BB6EDff);
        winico[580][used] = 1;
        winico[581][computer_id] = TextDrawCreate(34, 411, ".");
        TextDrawTextSize(winico[581][computer_id], 2, 1);
        TextDrawSetShadow(winico[581][computer_id], 0);
        TextDrawFont(winico[581][computer_id], 2);
        TextDrawColor(winico[581][computer_id], 0x21B5EAff);
        winico[581][used] = 1;
        winico[582][computer_id] = TextDrawCreate(35, 411, ".");
        TextDrawTextSize(winico[582][computer_id], 1, 1);
        TextDrawSetShadow(winico[582][computer_id], 0);
        TextDrawFont(winico[582][computer_id], 2);
        TextDrawColor(winico[582][computer_id], 0x18B4E6ff);
        winico[582][used] = 1;
        winico[583][computer_id] = TextDrawCreate(36, 411, ".");
        TextDrawTextSize(winico[583][computer_id], 1, 1);
        TextDrawSetShadow(winico[583][computer_id], 0);
        TextDrawFont(winico[583][computer_id], 2);
        TextDrawColor(winico[583][computer_id], 0x10B2E7ff);
        winico[583][used] = 1;
        winico[584][computer_id] = TextDrawCreate(37, 411, ".");
        TextDrawTextSize(winico[584][computer_id], 1, 1);
        TextDrawSetShadow(winico[584][computer_id], 0);
        TextDrawFont(winico[584][computer_id], 2);
        TextDrawColor(winico[584][computer_id], 0x0DADE8ff);
        winico[584][used] = 1;
        winico[585][computer_id] = TextDrawCreate(38, 411, ".");
        TextDrawTextSize(winico[585][computer_id], 1, 1);
        TextDrawSetShadow(winico[585][computer_id], 0);
        TextDrawFont(winico[585][computer_id], 2);
        TextDrawColor(winico[585][computer_id], 0x08A6DDff);
        winico[585][used] = 1;
        winico[586][computer_id] = TextDrawCreate(39, 411, ".");
        TextDrawTextSize(winico[586][computer_id], 1, 1);
        TextDrawSetShadow(winico[586][computer_id], 0);
        TextDrawFont(winico[586][computer_id], 2);
        TextDrawColor(winico[586][computer_id], 0x089DDAff);
        winico[586][used] = 1;
        winico[587][computer_id] = TextDrawCreate(40, 411, ".");
        TextDrawTextSize(winico[587][computer_id], 1, 1);
        TextDrawSetShadow(winico[587][computer_id], 0);
        TextDrawFont(winico[587][computer_id], 2);
        TextDrawColor(winico[587][computer_id], 0x0093D4ff);
        winico[587][used] = 1;
        winico[588][computer_id] = TextDrawCreate(41, 411, ".");
        TextDrawTextSize(winico[588][computer_id], 1, 1);
        TextDrawSetShadow(winico[588][computer_id], 0);
        TextDrawFont(winico[588][computer_id], 2);
        TextDrawColor(winico[588][computer_id], 0x81B6D2ff);
        winico[588][used] = 1;
        winico[589][computer_id] = TextDrawCreate(28, 412, ".");
        TextDrawTextSize(winico[589][computer_id], 1, 1);
        TextDrawSetShadow(winico[589][computer_id], 0);
        TextDrawFont(winico[589][computer_id], 2);
        TextDrawColor(winico[589][computer_id], 0x35A4D6ff);
        winico[589][used] = 1;
        winico[590][computer_id] = TextDrawCreate(29, 412, ".");
        TextDrawTextSize(winico[590][computer_id], 1, 1);
        TextDrawSetShadow(winico[590][computer_id], 0);
        TextDrawFont(winico[590][computer_id], 2);
        TextDrawColor(winico[590][computer_id], 0x0099DAff);
        winico[590][used] = 1;
        winico[591][computer_id] = TextDrawCreate(30, 412, ".");
        TextDrawTextSize(winico[591][computer_id], 1, 1);
        TextDrawSetShadow(winico[591][computer_id], 0);
        TextDrawFont(winico[591][computer_id], 2);
        TextDrawColor(winico[591][computer_id], 0x06A7E4ff);
        winico[591][used] = 1;
        winico[592][computer_id] = TextDrawCreate(31, 412, ".");
        TextDrawTextSize(winico[592][computer_id], 1, 1);
        TextDrawSetShadow(winico[592][computer_id], 0);
        TextDrawFont(winico[592][computer_id], 2);
        TextDrawColor(winico[592][computer_id], 0x13B2E8ff);
        winico[592][used] = 1;
        winico[593][computer_id] = TextDrawCreate(32, 412, ".");
        TextDrawTextSize(winico[593][computer_id], 1, 1);
        TextDrawSetShadow(winico[593][computer_id], 0);
        TextDrawFont(winico[593][computer_id], 2);
        TextDrawColor(winico[593][computer_id], 0x22B8EEff);
        winico[593][used] = 1;
        winico[594][computer_id] = TextDrawCreate(33, 412, ".");
        TextDrawTextSize(winico[594][computer_id], 1, 1);
        TextDrawSetShadow(winico[594][computer_id], 0);
        TextDrawFont(winico[594][computer_id], 2);
        TextDrawColor(winico[594][computer_id], 0x2CBCEEff);
        winico[594][used] = 1;
        winico[595][computer_id] = TextDrawCreate(34, 412, ".");
        TextDrawTextSize(winico[595][computer_id], 1, 1);
        TextDrawSetShadow(winico[595][computer_id], 0);
        TextDrawFont(winico[595][computer_id], 2);
        TextDrawColor(winico[595][computer_id], 0x26B8F0ff);
        winico[595][used] = 1;
        winico[596][computer_id] = TextDrawCreate(35, 412, ".");
        TextDrawTextSize(winico[596][computer_id], 1, 1);
        TextDrawSetShadow(winico[596][computer_id], 0);
        TextDrawFont(winico[596][computer_id], 2);
        TextDrawColor(winico[596][computer_id], 0x1AB5EBff);
        winico[596][used] = 1;
        winico[597][computer_id] = TextDrawCreate(36, 412, ".");
        TextDrawTextSize(winico[597][computer_id], 1, 1);
        TextDrawSetShadow(winico[597][computer_id], 0);
        TextDrawFont(winico[597][computer_id], 2);
        TextDrawColor(winico[597][computer_id], 0x0EB1E9ff);
        winico[597][used] = 1;
        winico[598][computer_id] = TextDrawCreate(37, 412, ".");
        TextDrawTextSize(winico[598][computer_id], 1, 1);
        TextDrawSetShadow(winico[598][computer_id], 0);
        TextDrawFont(winico[598][computer_id], 2);
        TextDrawColor(winico[598][computer_id], 0x03A8E6ff);
        winico[598][used] = 1;
        winico[599][computer_id] = TextDrawCreate(38, 412, ".");
        TextDrawTextSize(winico[599][computer_id], 1, 1);
        TextDrawSetShadow(winico[599][computer_id], 0);
        TextDrawFont(winico[599][computer_id], 2);
        TextDrawColor(winico[599][computer_id], 0x009CE0ff);
        winico[599][used] = 1;
        winico[600][computer_id] = TextDrawCreate(39, 412, ".");
        TextDrawTextSize(winico[600][computer_id], 1, 1);
        TextDrawSetShadow(winico[600][computer_id], 0);
        TextDrawFont(winico[600][computer_id], 2);
        TextDrawColor(winico[600][computer_id], 0x65B2D5ff);
        winico[600][used] = 1;
        winico[601][computer_id] = TextDrawCreate(31, 413, ".");
        TextDrawTextSize(winico[601][computer_id], 1, 1);
        TextDrawSetShadow(winico[601][computer_id], 0);
        TextDrawFont(winico[601][computer_id], 2);
        TextDrawColor(winico[601][computer_id], 0x7EC6E2ff);
        winico[601][used] = 1;
        winico[602][computer_id] = TextDrawCreate(32, 413, ".");
        TextDrawTextSize(winico[602][computer_id], 1, 1);
        TextDrawSetShadow(winico[602][computer_id], 0);
        TextDrawFont(winico[602][computer_id], 2);
        TextDrawColor(winico[602][computer_id], 0x31B0DFff);
        winico[602][used] = 1;
        winico[603][computer_id] = TextDrawCreate(33, 413, ".");
        TextDrawTextSize(winico[603][computer_id], 1, 1);
        TextDrawSetShadow(winico[603][computer_id], 0);
        TextDrawFont(winico[603][computer_id], 2);
        TextDrawColor(winico[603][computer_id], 0x1DAEE2ff);
        winico[603][used] = 1;
        winico[604][computer_id] = TextDrawCreate(34, 413, ".");
        TextDrawTextSize(winico[604][computer_id], 1, 1);
        TextDrawSetShadow(winico[604][computer_id], 0);
        TextDrawFont(winico[604][computer_id], 2);
        TextDrawColor(winico[604][computer_id], 0x20AEE3ff);
        winico[604][used] = 1;
        winico[605][computer_id] = TextDrawCreate(35, 413, ".");
        TextDrawTextSize(winico[605][computer_id], 1, 1);
        TextDrawSetShadow(winico[605][computer_id], 0);
        TextDrawFont(winico[605][computer_id], 2);
        TextDrawColor(winico[605][computer_id], 0x40B5DFff);
        winico[605][used] = 1;
        winico[606][computer_id] = TextDrawCreate(36, 413, ".");
        TextDrawTextSize(winico[606][computer_id], 1, 1);
        TextDrawSetShadow(winico[606][computer_id], 0);
        TextDrawFont(winico[606][computer_id], 2);
        TextDrawColor(winico[606][computer_id], 0x8ECBDFff);
        winico[606][used] = 1;
        //==================MAP===========================//

        map[0] = TextDrawCreate(292.500000, 15.166666, "samaps:gtasamapbit1");
        TextDrawLetterSize(map[0], 0.000000, 0.000000);
        TextDrawTextSize(map[0], 178.000000, 199.500030);
        TextDrawAlignment(map[0], 1);
        TextDrawColor(map[0], -1);
        TextDrawSetShadow(map[0], 0);
        TextDrawSetOutline(map[0], 0);
        TextDrawFont(map[0], 4);
        map[1] = TextDrawCreate(470.500000, 14.999996, "samaps:gtasamapbit2");
        TextDrawLetterSize(map[1], 0.000000, 0.000000);
        TextDrawTextSize(map[1], 165.000000, 199.500030);
        TextDrawAlignment(map[1], 1);
        TextDrawColor(map[1], -1);
        TextDrawSetShadow(map[1], 0);
        TextDrawSetOutline(map[1], 0);
        TextDrawFont(map[1], 4);
        map[2] = TextDrawCreate(292.500000, 214.333312, "samaps:gtasamapbit3");
        TextDrawLetterSize(map[2], 0.000000, 0.000000);
        TextDrawTextSize(map[2], 178.500000, 167.416625);
        TextDrawAlignment(map[2], 1);
        TextDrawColor(map[2], -1);
        TextDrawSetShadow(map[2], 0);
        TextDrawSetOutline(map[2], 0);
        TextDrawFont(map[2], 4);
        map[3] = TextDrawCreate(471.000000, 214.166656, "samaps:gtasamapbit4");
        TextDrawLetterSize(map[3], 0.000000, 0.000000);
        TextDrawTextSize(map[3], 164.500000, 167.416595);
        TextDrawAlignment(map[3], 1);
        TextDrawColor(map[3], -1);
        TextDrawSetShadow(map[3], 0);
        TextDrawSetOutline(map[3], 0);
        TextDrawFont(map[3], 4);
        map[4] = TextDrawCreate(641.000000, 9.666666, "usebox");
        TextDrawLetterSize(map[4], 0.000000, 41.683334);
        TextDrawTextSize(map[4], 285.500000, 0.000000);
        TextDrawAlignment(map[4], 1);
        TextDrawColor(map[4], 0);
        TextDrawUseBox(map[4], true);
        TextDrawBoxColor(map[4], 14352486);
        TextDrawSetShadow(map[4], 0);
        TextDrawSetOutline(map[4], 0);
        TextDrawFont(map[4], 0);
        map[5] = TextDrawCreate(606.000000, 8.166667, "LD_SPAC:white");
        TextDrawLetterSize(map[5], -0.018500, 0.000000);
        TextDrawTextSize(map[5], 33.000000, 13.416665);
        TextDrawAlignment(map[5], 1);
        TextDrawColor(map[5], -1);
        TextDrawSetShadow(map[5], 0);
        TextDrawSetOutline(map[5], 0);
        TextDrawFont(map[5], 4);
        TextDrawSetSelectable(map[5], true);
        map[6] = TextDrawCreate(622.500000, 11.083377, "x");
        TextDrawLetterSize(map[6], 0.321500, 0.800833);
        TextDrawTextSize(map[6], 0.000000, 27.999996);
        TextDrawAlignment(map[6], 2);
        TextDrawColor(map[6], -1);
        TextDrawUseBox(map[6], true);
        TextDrawBoxColor(map[6], -2147483393);
        TextDrawSetShadow(map[6], 0);
        TextDrawSetOutline(map[6], 1);
        TextDrawBackgroundColor(map[6], 51);
        TextDrawFont(map[6], 2);
        TextDrawSetProportional(map[6], 1);
        map[7] = TextDrawCreate(577.000000, 9.666673, "usebox");
        TextDrawLetterSize(map[7], 0.000000, 7.007407);
        TextDrawTextSize(map[7], 366.000000, 0.000000);
        TextDrawAlignment(map[7], 1);
        TextDrawColor(map[7], 0);
        TextDrawUseBox(map[7], true);
        TextDrawBoxColor(map[7], 58214);
        TextDrawSetShadow(map[7], 0);
        TextDrawSetOutline(map[7], 0);
        TextDrawFont(map[7], 0);
        map[8] = TextDrawCreate(572.500000, 16.666675, "box");
        TextDrawLetterSize(map[8], 0.000000, 5.351851);
        TextDrawTextSize(map[8], 371.000000, 0.000000);
        TextDrawAlignment(map[8], 1);
        TextDrawColor(map[8], 0);
        TextDrawUseBox(map[8], true);
        TextDrawBoxColor(map[8], -154);
        TextDrawSetShadow(map[8], 0);
        TextDrawSetOutline(map[8], 0);
        TextDrawFont(map[8], 0);
        map[9] = TextDrawCreate(408.500000, 23.916660, "");
        TextDrawLetterSize(map[9], 0.670000, 3.244999);
        TextDrawAlignment(map[9], 1);
        TextDrawColor(map[9], 16711935);
        TextDrawSetShadow(map[9], 0);
        TextDrawSetOutline(map[9], 2);
        TextDrawBackgroundColor(map[9], 255);
        TextDrawFont(map[9], 1);
        TextDrawSetProportional(map[9], 1);
        map[10] = TextDrawCreate(628.000000, 183.499969, "usebox");
        TextDrawLetterSize(map[10], 0.000000, 8.433337);
        TextDrawTextSize(map[10], 299.500000, 0.000000);
        TextDrawAlignment(map[10], 1);
        TextDrawColor(map[10], 0);
        TextDrawUseBox(map[10], true);
        TextDrawBoxColor(map[10], 65382);
        TextDrawSetShadow(map[10], 0);
        TextDrawSetOutline(map[10], 0);
        TextDrawFont(map[10], 0);
        map[11] = TextDrawCreate(631.000000, 186.833282, "usebox");
        TextDrawLetterSize(map[11], 0.000000, 8.433337);
        TextDrawTextSize(map[11], 301.500000, 0.000000);
        TextDrawAlignment(map[11], 1);
        TextDrawColor(map[11], 0);
        TextDrawUseBox(map[11], true);
        TextDrawBoxColor(map[11], 102);
        TextDrawSetShadow(map[11], 0);
        TextDrawSetOutline(map[11], 0);
        TextDrawFont(map[11], 0);
        //===================TD langue======================//
        tdlang[5] = TextDrawCreate(471.500000, 257.249877, "LD_SPAC:white");
        TextDrawLetterSize(tdlang[5], 0.000000, 0.000000);
        TextDrawTextSize(tdlang[5], 109.500000, 29.166667);
        TextDrawAlignment(tdlang[5], 1);
        TextDrawColor(tdlang[5], 65312);
        TextDrawSetShadow(tdlang[5], 0);
        TextDrawSetOutline(tdlang[5], 0);
        TextDrawFont(tdlang[5], 4);
        TextDrawSetSelectable(tdlang[5], true);
        tdlang[6] = TextDrawCreate(471.000000, 286.833404, "LD_SPAC:white");
        TextDrawLetterSize(tdlang[6], 0.000000, 0.000000);
        TextDrawTextSize(tdlang[6], 109.500000, 29.166667);
        TextDrawAlignment(tdlang[6], 1);
        TextDrawColor(tdlang[6], 65312);
        TextDrawSetShadow(tdlang[6], 0);
        TextDrawSetOutline(tdlang[6], 0);
        TextDrawFont(tdlang[6], 4);
        TextDrawSetSelectable(tdlang[6], true);
        tdlang[7] = TextDrawCreate(471.000000, 316.416656, "LD_SPAC:white");
        TextDrawLetterSize(tdlang[7], 0.000000, 0.000000);
        TextDrawTextSize(tdlang[7], 109.500000, 29.166667);
        TextDrawAlignment(tdlang[7], 1);
        TextDrawColor(tdlang[7], 65312);
        TextDrawSetShadow(tdlang[7], 0);
        TextDrawSetOutline(tdlang[7], 0);
        TextDrawFont(tdlang[7], 4);
        TextDrawSetSelectable(tdlang[7], true);
        tdlang[0] = TextDrawCreate(582.500000, 393.750000, "LD_SPAC:white");
        TextDrawLetterSize(tdlang[0], 0.000000, 0.000000);
        TextDrawTextSize(tdlang[0], -112.500000, -137.666641);
        TextDrawAlignment(tdlang[0], 1);
        TextDrawColor(tdlang[0], 65535);
        TextDrawSetShadow(tdlang[0], 0);
        TextDrawSetOutline(tdlang[0], 0);
        TextDrawFont(tdlang[0], 4);
        tdlang[1] = TextDrawCreate(471.000000, 256.666625, "LD_SPAC:white");
        TextDrawLetterSize(tdlang[1], 0.000000, 0.000000);
        TextDrawTextSize(tdlang[1], 111.000000, 135.916687);
        TextDrawAlignment(tdlang[1], 1);
        TextDrawColor(tdlang[1], -1);
        TextDrawSetShadow(tdlang[1], 0);
        TextDrawSetOutline(tdlang[1], 0);
        TextDrawFont(tdlang[1], 4);
        tdlang[2] = TextDrawCreate(481.000000, 263.083221, "ENG:___English");
        TextDrawLetterSize(tdlang[2], 0.295999, 1.465833);
        TextDrawAlignment(tdlang[2], 1);
        TextDrawColor(tdlang[2], 255);
        TextDrawSetShadow(tdlang[2], 0);
        TextDrawSetOutline(tdlang[2], 0);
        TextDrawBackgroundColor(tdlang[2], 51);
        TextDrawFont(tdlang[2], 2);
        TextDrawSetProportional(tdlang[2], 1);
        tdlang[3] = TextDrawCreate(480.500000, 293.250061, "FRA:___francais");
        TextDrawLetterSize(tdlang[3], 0.295999, 1.465833);
        TextDrawAlignment(tdlang[3], 1);
        TextDrawColor(tdlang[3], 255);
        TextDrawSetShadow(tdlang[3], 0);
        TextDrawSetOutline(tdlang[3], 0);
        TextDrawBackgroundColor(tdlang[3], 51);
        TextDrawFont(tdlang[3], 2);
        TextDrawSetProportional(tdlang[3], 1);
        tdlang[4] = TextDrawCreate(480.500000, 320.500305, "DAR:___darija");
        TextDrawLetterSize(tdlang[4], 0.295999, 1.465833);
        TextDrawAlignment(tdlang[4], 1);
        TextDrawColor(tdlang[4], 255);
        TextDrawSetShadow(tdlang[4], 0);
        TextDrawSetOutline(tdlang[4], 0);
        TextDrawBackgroundColor(tdlang[4], 51);
        TextDrawFont(tdlang[4], 2);
        TextDrawSetProportional(tdlang[4], 1);
        //=================Menu ===========================//

        menu[0] = TextDrawCreate(198.000000, 158.416656, "usebox");
        TextDrawLetterSize(menu[0], 0.000000, 25.903705);
        TextDrawTextSize(menu[0], 17.000000, 0.000000);
        TextDrawAlignment(menu[0], 1);
        TextDrawColor(menu[0], 12339712);
        TextDrawUseBox(menu[0], true);
        TextDrawBoxColor(menu[0], 6748006);
        TextDrawSetShadow(menu[0], 0);
        TextDrawSetOutline(menu[0], 0);
        TextDrawFont(menu[0], 0);
        menu[1] = TextDrawCreate(133.500000, 164.833297, "usebox");
        TextDrawLetterSize(menu[1], 0.000000, 24.864812);
        TextDrawTextSize(menu[1], 19.500000, 0.000000);
        TextDrawAlignment(menu[1], 1);
        TextDrawColor(menu[1], -1);
        TextDrawUseBox(menu[1], true);
        TextDrawBoxColor(menu[1], -1);
        TextDrawSetShadow(menu[1], 0);
        TextDrawSetOutline(menu[1], 0);
        TextDrawFont(menu[1], 0);
        menu[2] = TextDrawCreate(194.000000, 136.833343, "usebox");
        TextDrawLetterSize(menu[2], 0.000000, 4.544444);
        TextDrawTextSize(menu[2], 154.000000, 0.000000);
        TextDrawAlignment(menu[2], 1);
        TextDrawColor(menu[2], 0);
        TextDrawUseBox(menu[2], true);
        TextDrawBoxColor(menu[2], 13434726);
        TextDrawSetShadow(menu[2], 0);
        TextDrawSetOutline(menu[2], 0);
        TextDrawFont(menu[2], 0);
        menu[3] = TextDrawCreate(158.000000, 137.083343, "loadsc2:loadsc2");
        TextDrawLetterSize(menu[3], 0.000000, 0.000000);
        TextDrawTextSize(menu[3], 32.000000, 40.833312);
        TextDrawAlignment(menu[3], 1);
        TextDrawColor(menu[3], -1);
        TextDrawSetShadow(menu[3], 0);
        TextDrawSetOutline(menu[3], 0);
        TextDrawFont(menu[3], 4);
        menu[4] = TextDrawCreate(24.500000, 168.000000, "hud:arrow");
        TextDrawLetterSize(menu[4], 0.000000, 0.000000);
        TextDrawTextSize(menu[4], 19.500000, 24.500000);
        TextDrawAlignment(menu[4], 1);
        TextDrawColor(menu[4], -1);
        TextDrawSetShadow(menu[4], 0);
        TextDrawSetOutline(menu[4], 0);
        TextDrawFont(menu[4], 4);
        TextDrawSetSelectable(menu[4], true);
        menu[5] = TextDrawCreate(46.000000, 176.166732, "");
        TextDrawLetterSize(menu[5], 0.373500, 1.354999);
        TextDrawAlignment(menu[5], 1);
        TextDrawColor(menu[5], 16777215);
        TextDrawSetShadow(menu[5], 0);
        TextDrawSetOutline(menu[5], -1);
        TextDrawBackgroundColor(menu[5], 255);
        TextDrawFont(menu[5], 1);
        TextDrawSetProportional(menu[5], 1);
        menu[6] = TextDrawCreate(23.500000, 198.749954, "hud:radar_dateDisco");
        TextDrawLetterSize(menu[6], 0.000000, 0.000000);
        TextDrawTextSize(menu[6], 19.500000, 24.500000);
        TextDrawAlignment(menu[6], 1);
        TextDrawColor(menu[6], -1);
        TextDrawSetShadow(menu[6], 0);
        TextDrawSetOutline(menu[6], 0);
        TextDrawFont(menu[6], 4);
        TextDrawSetSelectable(menu[6], true);
        menu[7] = TextDrawCreate(44.500000, 204.583389, "");
        TextDrawLetterSize(menu[7], 0.373500, 1.354999);
        TextDrawAlignment(menu[7], 1);
        TextDrawColor(menu[7], 16777215);
        TextDrawSetShadow(menu[7], 0);
        TextDrawSetOutline(menu[7], -1);
        TextDrawBackgroundColor(menu[7], 255);
        TextDrawFont(menu[7], 1);
        TextDrawSetProportional(menu[7], 1);
        menu[8] = TextDrawCreate(135.500000, 372.750000, "LD_SPAC:white");
        TextDrawLetterSize(menu[8], 0.000000, 0.000000);
        TextDrawTextSize(menu[8], 56.500000, 18.666646);
        TextDrawAlignment(menu[8], 1);
        TextDrawColor(menu[8], -1);
        TextDrawSetShadow(menu[8], 0);
        TextDrawSetOutline(menu[8], 0);
        TextDrawFont(menu[8], 4);
        TextDrawSetSelectable(menu[8], true);
        //menu[9] = TextDrawCreate(163.500000, 375.666748, "");TextDrawLetterSize(menu[9], 0.196500, 1.366666);TextDrawTextSize(menu[9], 12.000000, -59.500026);TextDrawAlignment(menu[9], 2);TextDrawColor(menu[9], -1);TextDrawUseBox(menu[9], true);TextDrawBoxColor(menu[9], 26623);TextDrawSetShadow(menu[9], 0);TextDrawSetOutline(menu[9], 0);TextDrawBackgroundColor(menu[8], 51);TextDrawFont(menu[9], 2);TextDrawSetProportional(menu[9], 1);
        menu[10] = TextDrawCreate(194.000000, 374.250000, "usebox");
        TextDrawLetterSize(menu[10], 0.000000, 1.627777);
        TextDrawTextSize(menu[10], 133.500000, 0.000000);
        TextDrawAlignment(menu[10], 1);
        TextDrawColor(menu[10], 0);
        TextDrawUseBox(menu[10], true);
        TextDrawBoxColor(menu[10], 102);
        TextDrawSetShadow(menu[10], 0);
        TextDrawSetOutline(menu[10], 0);
        TextDrawFont(menu[10], 0);
        menu[11] = TextDrawCreate(23.500000, 232.166641, "LD_SPAC:white");
        TextDrawLetterSize(menu[11], 0.000000, 0.000000);
        TextDrawTextSize(menu[11], 19.500000, 24.500011);
        TextDrawAlignment(menu[11], 1);
        TextDrawColor(menu[11], -1);
        TextDrawSetShadow(menu[11], 0);
        TextDrawSetOutline(menu[11], 0);
        TextDrawFont(menu[11], 4);
        TextDrawSetSelectable(menu[11], true);
        menu[12] = TextDrawCreate(43.000000, 236.249877, "SuperBall");
        TextDrawLetterSize(menu[12], 0.449999, 1.600000);
        TextDrawAlignment(menu[12], 1);
        TextDrawColor(menu[12], 16777215);
        TextDrawSetShadow(menu[12], 0);
        TextDrawSetOutline(menu[12], 1);
        TextDrawBackgroundColor(menu[12], 255);
        TextDrawFont(menu[12], 1);
        TextDrawSetProportional(menu[12], 1);
        menu[13] = TextDrawCreate(25.500000, 243.250015, "-");
        TextDrawLetterSize(menu[13], 1.085000, 1.541666);
        TextDrawAlignment(menu[13], 1);
        TextDrawColor(menu[13], 255);
        TextDrawSetShadow(menu[13], 0);
        TextDrawSetOutline(menu[13], 1);
        TextDrawBackgroundColor(menu[13], 51);
        TextDrawFont(menu[13], 1);
        TextDrawSetProportional(menu[13], 1);
        menu[14] = TextDrawCreate(25.500000, 227.916778, "-");
        TextDrawLetterSize(menu[14], 1.085000, 1.541666);
        TextDrawAlignment(menu[14], 1);
        TextDrawColor(menu[14], 255);
        TextDrawSetShadow(menu[14], 0);
        TextDrawSetOutline(menu[14], 1);
        TextDrawBackgroundColor(menu[14], 51);
        TextDrawFont(menu[14], 1);
        TextDrawSetProportional(menu[14], 1);
        menu[15] = TextDrawCreate(28.500000, 243.250015, "LD_POOL:ball");
        TextDrawLetterSize(menu[15], 0.000000, 0.000000);
        TextDrawTextSize(menu[15], 3.500000, 4.083343);
        TextDrawAlignment(menu[15], 1);
        TextDrawColor(menu[15], 16711935);
        TextDrawSetShadow(menu[15], 0);
        TextDrawSetOutline(menu[15], 0);
        TextDrawFont(menu[15], 4);
        menu[16] = TextDrawCreate(24.500000, 259.583251, "ld_poke:cd9s");
        TextDrawLetterSize(menu[16], 0.000000, 0.000000);
        TextDrawTextSize(menu[16], 19.000000, 23.916645);
        TextDrawAlignment(menu[16], 1);
        TextDrawColor(menu[16], 4825343);
        TextDrawSetShadow(menu[16], 0);
        TextDrawSetOutline(menu[16], 0);
        TextDrawFont(menu[16], 4);
        TextDrawSetSelectable(menu[16], true);
        menu[17] = TextDrawCreate(25.500000, 259.999664, "ld_spac:white");
        TextDrawLetterSize(menu[17], 0.000000, 0.000000);
        TextDrawTextSize(menu[17], 17.500000, 21.583309);
        TextDrawAlignment(menu[17], 1);
        TextDrawColor(menu[17], 5153023);
        TextDrawSetShadow(menu[17], 0);
        TextDrawSetOutline(menu[17], 0);
        TextDrawFont(menu[17], 4);
        menu[18] = TextDrawCreate(31.000000, 259.583312, "f");
        TextDrawLetterSize(menu[18], 0.580500, 2.218334);
        TextDrawAlignment(menu[18], 1);
        TextDrawColor(menu[18], -1);
        TextDrawSetShadow(menu[18], 0);
        TextDrawSetOutline(menu[18], 1);
        TextDrawBackgroundColor(menu[18], 51);
        TextDrawFont(menu[18], 1);
        TextDrawSetProportional(menu[18], 1);
        menu[19] = TextDrawCreate(44.000000, 280.333312, "usebox");
        TextDrawLetterSize(menu[19], 0.000000, -0.207402);
        TextDrawTextSize(menu[19], 24.000000, 0.000000);
        TextDrawAlignment(menu[19], 1);
        TextDrawColor(menu[19], 14090240);
        TextDrawUseBox(menu[19], true);
        TextDrawBoxColor(menu[19], -154);
        TextDrawSetShadow(menu[19], 0);
        TextDrawSetOutline(menu[19], 0);
        TextDrawFont(menu[19], 0);
        menu[9] = TextDrawCreate(45.500000, 264.250091, "facebook");
        TextDrawLetterSize(menu[9], 0.449999, 1.600000);
        TextDrawAlignment(menu[9], 1);
        TextDrawColor(menu[9], 16777215);
        TextDrawSetShadow(menu[9], 0);
        TextDrawSetOutline(menu[9], 1);
        TextDrawBackgroundColor(menu[9], 255);
        TextDrawFont(menu[9], 1);
        TextDrawSetProportional(menu[9], 1);
        menu[20] = TextDrawCreate(23.500000, 287.583312, "LD_SPAC:white");
        TextDrawLetterSize(menu[20], 0.000000, 0.000000);
        TextDrawTextSize(menu[20], 22.000000, 25.666666);
        TextDrawAlignment(menu[20], 1);
        TextDrawColor(menu[20], -256);
        TextDrawSetShadow(menu[20], 0);
        TextDrawSetOutline(menu[20], 0);
        TextDrawFont(menu[20], 4);
        TextDrawSetSelectable(menu[20], true);
        menu[21] = TextDrawCreate(22.000000, 289.750000, "hud:radar_gangN");
        TextDrawLetterSize(menu[21], 0.000000, 0.000000);
        TextDrawTextSize(menu[21], 25.000000, 38.499988);
        TextDrawAlignment(menu[21], 1);
        TextDrawColor(menu[21], -1);
        TextDrawSetShadow(menu[21], 0);
        TextDrawSetOutline(menu[21], 0);
        TextDrawFont(menu[21], 4);
        menu[22] = TextDrawCreate(55.500000, 335.416687, "LD_SPAC:white");
        TextDrawLetterSize(menu[22], 0.000000, 0.000000);
        TextDrawTextSize(menu[22], -33.000000, -21.583374);
        TextDrawAlignment(menu[22], 1);
        TextDrawColor(menu[22], -1);
        TextDrawSetShadow(menu[22], 0);
        TextDrawSetOutline(menu[22], 0);
        TextDrawFont(menu[22], 4);
        menu[23] = TextDrawCreate(48.000000, 293.416625, "Zombies");
        TextDrawLetterSize(menu[23], 0.449999, 1.600000);
        TextDrawAlignment(menu[23], 1);
        TextDrawColor(menu[23], 16777215);
        TextDrawSetShadow(menu[23], 0);
        TextDrawSetOutline(menu[23], 1);
        TextDrawBackgroundColor(menu[23], 255);
        TextDrawFont(menu[23], 1);
        TextDrawSetProportional(menu[23], 1);
        menu[24] = TextDrawCreate(134.000000, 195.416641, "");
        TextDrawLetterSize(menu[24], 0.000000, 0.000000);
        TextDrawTextSize(menu[24], 15.500000, 18.083343);
        TextDrawAlignment(menu[24], 1);
        TextDrawColor(menu[24], -1);
        TextDrawSetShadow(menu[24], 0);
        TextDrawSetOutline(menu[24], 0);
        TextDrawFont(menu[24], 4);
        TextDrawSetSelectable(menu[24], true);

        //================ Music =======================//
        music[0] = TextDrawCreate(617.000000, 27.166667, "usebox");
        TextDrawLetterSize(music[0], 0.000000, 38.053703);
        TextDrawTextSize(music[0], 290.500000, 0.000000);
        TextDrawAlignment(music[0], 1);
        TextDrawColor(music[0], 0);
        TextDrawUseBox(music[0], true);
        TextDrawBoxColor(music[0], 5293926);
        TextDrawSetShadow(music[0], 0);
        TextDrawSetOutline(music[0], 0);
        TextDrawFont(music[0], 0);
        music[1] = TextDrawCreate(293.500000, 26.250000, "LD_SPAC:white");
        TextDrawLetterSize(music[1], 0.000000, 0.000000);
        TextDrawTextSize(music[1], 320.500000, 344.750000);
        TextDrawAlignment(music[1], 1);
        TextDrawColor(music[1], 255);
        TextDrawSetShadow(music[1], 0);
        TextDrawSetOutline(music[1], 0);
        TextDrawFont(music[1], 4);
        music[2] = TextDrawCreate(616.000000, 28.333332, "usebox");
        TextDrawLetterSize(music[2], 0.000000, 2.038888);
        TextDrawTextSize(music[2], 291.500000, 0.000000);
        TextDrawAlignment(music[2], 1);
        TextDrawColor(music[2], 0);
        TextDrawUseBox(music[2], true);
        TextDrawBoxColor(music[2], 65535);
        TextDrawSetShadow(music[2], 0);
        TextDrawSetOutline(music[2], 0);
        TextDrawFont(music[2], 0);
        music[3] = TextDrawCreate(615.500000, 44.083335, "usebox");
        TextDrawLetterSize(music[3], 0.000000, 0.266666);
        TextDrawTextSize(music[3], 292.500000, 0.000000);
        TextDrawAlignment(music[3], 1);
        TextDrawColor(music[3], 0);
        TextDrawUseBox(music[3], true);
        TextDrawBoxColor(music[3], 102);
        TextDrawSetShadow(music[3], 0);
        TextDrawSetOutline(music[3], 0);
        TextDrawFont(music[3], 0);
        music[4] = TextDrawCreate(574.500000, 27.416666, "LD_SPAC:white");
        TextDrawLetterSize(music[4], 0.000000, 0.000000);
        TextDrawTextSize(music[4], 38.500000, 11.666668);
        TextDrawAlignment(music[4], 1);
        TextDrawColor(music[4], -1);
        TextDrawSetShadow(music[4], 0);
        TextDrawSetOutline(music[4], 0);
        TextDrawFont(music[4], 4);
        TextDrawSetSelectable(music[4], true);
        music[5] = TextDrawCreate(593.500000, 30.333349, "X");
        TextDrawLetterSize(music[5], 0.448000, 0.637499);
        TextDrawTextSize(music[5], -2.500000, 33.250007);
        TextDrawAlignment(music[5], 2);
        TextDrawColor(music[5], -1);
        TextDrawUseBox(music[5], true);
        TextDrawBoxColor(music[5], -2147483393);
        TextDrawSetShadow(music[5], 0);
        TextDrawSetOutline(music[5], 1);
        TextDrawBackgroundColor(music[5], 51);
        TextDrawFont(music[5], 2);
        TextDrawSetProportional(music[5], 1);
        music[6] = TextDrawCreate(616.000000, 284.416687, "usebox");
        TextDrawLetterSize(music[6], 0.000000, 9.340736);
        TextDrawTextSize(music[6], 291.500000, 0.000000);
        TextDrawAlignment(music[6], 1);
        TextDrawColor(music[6], 0);
        TextDrawUseBox(music[6], true);
        TextDrawBoxColor(music[6], -1394218175);
        TextDrawSetShadow(music[6], 0);
        TextDrawSetOutline(music[6], 0);
        TextDrawFont(music[6], 0);
        music[7] = TextDrawCreate(337.500000, 29.166652, "Music");
        TextDrawLetterSize(music[7], 0.449999, 1.600000);
        TextDrawAlignment(music[7], 2);
        TextDrawColor(music[7], -1);
        TextDrawSetShadow(music[7], 0);
        TextDrawSetOutline(music[7], 1);
        TextDrawBackgroundColor(music[7], 51);
        TextDrawFont(music[7], 1);
        TextDrawSetProportional(music[7], 1);
        music[8] = TextDrawCreate(295.000000, 26.250000, "hud:radar_dateDisco");
        TextDrawLetterSize(music[8], 0.000000, 0.000000);
        TextDrawTextSize(music[8], 21.000000, 22.166664);
        TextDrawAlignment(music[8], 1);
        TextDrawColor(music[8], -1);
        TextDrawSetShadow(music[8], 0);
        TextDrawSetOutline(music[8], 0);
        TextDrawFont(music[8], 4);
        music[9] = TextDrawCreate(557.000000, 319.416687, "usebox");
        TextDrawLetterSize(music[9], 0.000000, 2.988888);
        TextDrawTextSize(music[9], 367.500000, 0.000000);
        TextDrawAlignment(music[9], 1);
        TextDrawColor(music[9], 0);
        TextDrawUseBox(music[9], true);
        TextDrawBoxColor(music[9], 11206758);
        TextDrawSetShadow(music[9], 0);
        TextDrawSetOutline(music[9], 0);
        TextDrawFont(music[9], 0);
        music[10] = TextDrawCreate(439.000000, 309.166687, "LD_POOL:ball");
        TextDrawLetterSize(music[10], 0.000000, 0.000000);
        TextDrawTextSize(music[10], 43.000000, 47.833312);
        TextDrawAlignment(music[10], 1);
        TextDrawColor(music[10], -1);
        TextDrawSetShadow(music[10], 0);
        TextDrawSetOutline(music[10], 0);
        TextDrawFont(music[10], 4);
        TextDrawSetSelectable(music[10], true);
        music[11] = TextDrawCreate(414.500000, 320.583312, "LD_POOL:ball");
        TextDrawLetterSize(music[11], 0.000000, 2.599999);
        TextDrawTextSize(music[11], 369.500000, 0.000000);
        TextDrawAlignment(music[11], 1);
        TextDrawColor(music[11], 0);
        TextDrawUseBox(music[11], true);
        TextDrawBoxColor(music[11], 102);
        TextDrawSetShadow(music[11], 0);
        TextDrawSetOutline(music[11], 0);
        TextDrawFont(music[11], 0);
        music[12] = TextDrawCreate(555.500000, 321.000091, "usebox");
        TextDrawLetterSize(music[12], 0.000000, 2.599999);
        TextDrawTextSize(music[12], 509.500000, 0.000000);
        TextDrawAlignment(music[12], 1);
        TextDrawColor(music[12], 0);
        TextDrawUseBox(music[12], true);
        TextDrawBoxColor(music[12], 102);
        TextDrawSetShadow(music[12], 0);
        TextDrawSetOutline(music[12], 0);
        TextDrawFont(music[12], 0);
        music[13] = TextDrawCreate(452.500000, 317.333312, "");
        TextDrawLetterSize(music[13], 0.645000, 3.157499);
        TextDrawAlignment(music[13], 1);
        TextDrawColor(music[13], -1);
        TextDrawSetShadow(music[13], 0);
        TextDrawSetOutline(music[13], 1);
        TextDrawBackgroundColor(music[13], 255);
        TextDrawFont(music[13], 1);
        TextDrawSetProportional(music[13], 1);
        music[14] = TextDrawCreate(376.000000, 318.500000, "LD_SPAC:white");
        TextDrawLetterSize(music[14], 0.000000, 0.000000);
        TextDrawTextSize(music[14], 30.500000, 28.000000);
        TextDrawAlignment(music[14], 1);
        TextDrawColor(music[14], -1);
        TextDrawSetShadow(music[14], 0);
        TextDrawSetOutline(music[14], 0);
        TextDrawFont(music[14], 4);
        TextDrawSetSelectable(music[14], true);
        music[15] = TextDrawCreate(517.500000, 318.916625, "LD_SPAC:white");
        TextDrawLetterSize(music[15], 0.000000, 0.000000);
        TextDrawTextSize(music[15], 30.500000, 28.000000);
        TextDrawAlignment(music[15], 1);
        TextDrawColor(music[15], -1);
        TextDrawSetShadow(music[15], 0);
        TextDrawSetOutline(music[15], 0);
        TextDrawFont(music[15], 4);
        TextDrawSetSelectable(music[15], true);
        music[16] = TextDrawCreate(346.000000, 81.666671, "hud:radar_LocoSyndicate");
        TextDrawLetterSize(music[16], 0.000000, 0.000000);
        TextDrawTextSize(music[16], 228.500000, 197.749969);
        TextDrawAlignment(music[16], 2);
        TextDrawColor(music[16], 6709759);
        TextDrawSetShadow(music[16], 0);
        TextDrawSetOutline(music[16], 0);
        TextDrawFont(music[16], 4);
        music[17] = TextDrawCreate(364.000000, 229.833389, "hud:fist");
        TextDrawLetterSize(music[17], 0.000000, 0.000000);
        TextDrawTextSize(music[17], 48.000000, 52.500000);
        TextDrawAlignment(music[17], 1);
        TextDrawColor(music[17], 1626669311);
        TextDrawSetShadow(music[17], 0);
        TextDrawSetOutline(music[17], 0);
        TextDrawFont(music[17], 4);
        music[18] = TextDrawCreate(551.000000, 230.833374, "hud:fist");
        TextDrawLetterSize(music[18], 0.000000, 0.000000);
        TextDrawTextSize(music[18], -42.000000, 54.250003);
        TextDrawAlignment(music[18], 1);
        TextDrawColor(music[18], 1626669311);
        TextDrawSetShadow(music[18], 0);
        TextDrawSetOutline(music[18], 0);
        TextDrawFont(music[18], 4);
        music[19] = TextDrawCreate(294.000000, 277.666687, "hud:radarRingPlane");
        TextDrawLetterSize(music[19], 0.000000, 0.000000);
        TextDrawTextSize(music[19], 319.500000, 12.250000);
        TextDrawAlignment(music[19], 1);
        TextDrawColor(music[19], -1);
        TextDrawSetShadow(music[19], 0);
        TextDrawSetOutline(music[19], 0);
        TextDrawFont(music[19], 4);
        music[20] = TextDrawCreate(472.000000, 182.000000, "LD_POOL:ball");
        TextDrawLetterSize(music[20], 0.000000, 0.000000);
        TextDrawTextSize(music[20], 32.000000, 36.750007);
        TextDrawAlignment(music[20], 1);
        TextDrawColor(music[20], -16776961);
        TextDrawSetShadow(music[20], 0);
        TextDrawSetOutline(music[20], 0);
        TextDrawFont(music[20], 4);
        music[21] = TextDrawCreate(412.500000, 181.833374, "LD_POOL:ball");
        TextDrawLetterSize(music[21], 0.000000, 0.000000);
        TextDrawTextSize(music[21], 32.000000, 36.750007);
        TextDrawAlignment(music[21], 1);
        TextDrawColor(music[21], 65535);
        TextDrawSetShadow(music[21], 0);
        TextDrawSetOutline(music[21], 0);
        TextDrawFont(music[21], 4);
        music[22] = TextDrawCreate(431.000000, 191.666656, "usebox");
        TextDrawLetterSize(music[22], 0.000000, 1.498149);
        TextDrawTextSize(music[22], 422.500000, 0.000000);
        TextDrawAlignment(music[22], 1);
        TextDrawColor(music[22], 0);
        TextDrawUseBox(music[22], true);
        TextDrawBoxColor(music[22], 102);
        TextDrawSetShadow(music[22], 0);
        TextDrawSetOutline(music[22], 0);
        TextDrawFont(music[22], 0);
        music[23] = TextDrawCreate(496.000000, 191.666656, "usebox");
        TextDrawLetterSize(music[23], 0.000000, 1.498149);
        TextDrawTextSize(music[23], 487.000000, 0.000000);
        TextDrawAlignment(music[23], 1);
        TextDrawColor(music[23], 0);
        TextDrawUseBox(music[23], true);
        TextDrawBoxColor(music[23], 102);
        TextDrawSetShadow(music[23], 0);
        TextDrawSetOutline(music[23], 0);
        TextDrawFont(music[23], 0);
        music[24] = TextDrawCreate(427.000000, 138.250030, "hud:radar_girlfriend");
        TextDrawLetterSize(music[24], 0.000000, 0.000000);
        TextDrawTextSize(music[24], 66.500000, 71.749977);
        TextDrawAlignment(music[24], 1);
        TextDrawColor(music[24], 14548991);
        TextDrawSetShadow(music[24], 0);
        TextDrawSetOutline(music[24], 0);
        TextDrawFont(music[24], 4);
        music[25] = TextDrawCreate(426.500000, 141.000015, "LD_SPAC:white");
        TextDrawLetterSize(music[25], 0.000000, 0.000000);
        TextDrawTextSize(music[25], 67.500000, 36.166599);
        TextDrawAlignment(music[25], 2);
        TextDrawColor(music[25], 5064192);
        TextDrawSetShadow(music[25], 0);
        TextDrawSetOutline(music[25], 0);
        TextDrawFont(music[25], 4);
        music[26] = TextDrawCreate(391.000000, 324.916717, "<<");
        TextDrawLetterSize(music[26], 0.449999, 1.600000);
        TextDrawTextSize(music[26], 12.500000, 26.250009);
        TextDrawAlignment(music[26], 2);
        TextDrawColor(music[26], 255);
        TextDrawUseBox(music[26], true);
        TextDrawBoxColor(music[26], 255);
        TextDrawSetShadow(music[26], 0);
        TextDrawSetOutline(music[26], 1);
        TextDrawBackgroundColor(music[26], 16711935);
        TextDrawFont(music[26], 3);
        TextDrawSetProportional(music[26], 1);
        music[27] = TextDrawCreate(532.500000, 325.916809, ">>");
        TextDrawLetterSize(music[27], 0.449999, 1.600000);
        TextDrawTextSize(music[27], 12.500000, 26.250009);
        TextDrawAlignment(music[27], 2);
        TextDrawColor(music[27], 255);
        TextDrawUseBox(music[27], true);
        TextDrawBoxColor(music[27], 255);
        TextDrawSetShadow(music[27], 0);
        TextDrawSetOutline(music[27], 1);
        TextDrawBackgroundColor(music[27], 16711935);
        TextDrawFont(music[27], 3);
        TextDrawSetProportional(music[27], 1);
        music[28] = TextDrawCreate(419.000000, 140.583343, "Music");
        TextDrawLetterSize(music[28], 1.020999, 4.901667);
        TextDrawAlignment(music[28], 1);
        TextDrawColor(music[28], 255);
        TextDrawSetShadow(music[28], 0);
        TextDrawSetOutline(music[28], 1);
        TextDrawBackgroundColor(music[28], -16776961);
        TextDrawFont(music[28], 0);
        TextDrawSetProportional(music[28], 1);
        music[29] = TextDrawCreate(435.000000, 173.250000, "LD_SPAC:white");
        TextDrawLetterSize(music[29], 0.000000, 0.000000);
        TextDrawTextSize(music[29], 3.500000, 4.666656);
        TextDrawAlignment(music[29], 1);
        TextDrawColor(music[29], -16776961);
        TextDrawSetShadow(music[29], 0);
        TextDrawSetOutline(music[29], 0);
        TextDrawFont(music[29], 4);
        music[30] = TextDrawCreate(443.500000, 173.666671, "LD_SPAC:white");
        TextDrawLetterSize(music[30], 0.000000, 0.000000);
        TextDrawTextSize(music[30], 3.500000, 4.666656);
        TextDrawAlignment(music[30], 1);
        TextDrawColor(music[30], -16776961);
        TextDrawSetShadow(music[30], 0);
        TextDrawSetOutline(music[30], 0);
        TextDrawFont(music[30], 4);
        music[31] = TextDrawCreate(479.000000, 172.916641, "LD_SPAC:white");
        TextDrawLetterSize(music[31], 0.000000, 0.000000);
        TextDrawTextSize(music[31], 3.500000, 4.666656);
        TextDrawAlignment(music[31], 1);
        TextDrawColor(music[31], -16776961);
        TextDrawSetShadow(music[31], 0);
        TextDrawSetOutline(music[31], 0);
        TextDrawFont(music[31], 4);
        music[32] = TextDrawCreate(536.000000, 27.416685, "LD_SPAC:white");
        TextDrawLetterSize(music[32], 0.000500, 0.320833);
        TextDrawTextSize(music[32], 38.000000, 11.666666);
        TextDrawAlignment(music[32], 1);
        TextDrawColor(music[32], -1);
        TextDrawSetShadow(music[32], 0);
        TextDrawSetOutline(music[32], 0);
        TextDrawFont(music[32], 4);
        TextDrawSetSelectable(music[32], true);
        music[33] = TextDrawCreate(555.000000, 30.333322, "-");
        TextDrawLetterSize(music[33], 0.475999, 0.608333);
        TextDrawTextSize(music[33], -26.500000, 32.083335);
        TextDrawAlignment(music[33], 2);
        TextDrawColor(music[33], -1);
        TextDrawUseBox(music[33], true);
        TextDrawBoxColor(music[33], 65535);
        TextDrawSetShadow(music[33], 0);
        TextDrawSetOutline(music[33], 1);
        TextDrawBackgroundColor(music[33], 51);
        TextDrawFont(music[33], 3);
        TextDrawSetProportional(music[33], 1);
        // Sound
        music[34] = TextDrawCreate(584.500000, 343.583312, "LD_SPAC:white");
        TextDrawLetterSize(music[34], 0.000000, 0.000000);
        TextDrawTextSize(music[34], 3.000000, 5.250000);
        TextDrawAlignment(music[34], 1);
        TextDrawColor(music[34], 255);
        TextDrawSetShadow(music[34], 0);
        TextDrawSetOutline(music[34], 0);
        TextDrawFont(music[34], 4);
        TextDrawSetSelectable(music[34], true);
        music[35] = TextDrawCreate(587.500000, 341.083282, "LD_SPAC:white");
        TextDrawLetterSize(music[35], -0.002500, 0.472499);
        TextDrawTextSize(music[35], 3.000000, 7.583333);
        TextDrawAlignment(music[35], 1);
        TextDrawColor(music[35], 255);
        TextDrawSetShadow(music[35], 0);
        TextDrawSetOutline(music[35], 0);
        TextDrawFont(music[35], 4);
        TextDrawSetSelectable(music[35], true);
        music[36] = TextDrawCreate(590.500000, 338.583221, "LD_SPAC:white");
        TextDrawLetterSize(music[36], -0.002500, 0.472499);
        TextDrawTextSize(music[36], 3.000000, 9.916666);
        TextDrawAlignment(music[36], 1);
        TextDrawColor(music[36], 255);
        TextDrawSetShadow(music[36], 0);
        TextDrawSetOutline(music[36], 0);
        TextDrawFont(music[36], 4);
        TextDrawSetSelectable(music[36], true);
        music[37] = TextDrawCreate(593.000000, 335.499816, "LD_SPAC:white");
        TextDrawLetterSize(music[37], -0.002500, 0.472499);
        TextDrawTextSize(music[37], 3.000000, 12.833331);
        TextDrawAlignment(music[37], 1);
        TextDrawColor(music[37], 255);
        TextDrawSetShadow(music[37], 0);
        TextDrawSetOutline(music[37], 0);
        TextDrawFont(music[37], 4);
        TextDrawSetSelectable(music[37], true);
        music[38] = TextDrawCreate(596.000000, 332.999816, "LD_SPAC:white");
        TextDrawLetterSize(music[38], -0.002500, 0.472499);
        TextDrawTextSize(music[38], 3.000000, 15.749996);
        TextDrawAlignment(music[38], 1);
        TextDrawColor(music[38], 255);
        TextDrawSetShadow(music[38], 0);
        TextDrawSetOutline(music[38], 0);
        TextDrawFont(music[38], 4);
        TextDrawSetSelectable(music[38], true);
        music[39] = TextDrawCreate(598.500000, 329.916442, "LD_SPAC:white");
        TextDrawLetterSize(music[39], 0.007500, -1.901666);
        TextDrawTextSize(music[39], 3.500000, 18.666666);
        TextDrawAlignment(music[39], 1);
        TextDrawColor(music[39], 255);
        TextDrawSetShadow(music[39], 0);
        TextDrawSetOutline(music[39], 0);
        TextDrawFont(music[39], 4);
        TextDrawSetSelectable(music[39], true);
        music[40] = TextDrawCreate(584.000000, 342.416748, "I");
        TextDrawLetterSize(music[40], 0.345000, 0.748333);
        TextDrawAlignment(music[40], 1);
        TextDrawColor(music[40], -65281);
        TextDrawSetShadow(music[40], 0);
        TextDrawSetOutline(music[40], 0);
        TextDrawBackgroundColor(music[40], 51);
        TextDrawFont(music[40], 1);
        TextDrawSetProportional(music[40], 1);
        TextDrawSetSelectable(music[40], false);
        music[41] = TextDrawCreate(587.000000, 339.333343, "I");
        TextDrawLetterSize(music[41], 0.345500, 1.110000);
        TextDrawAlignment(music[41], 1);
        TextDrawColor(music[41], -8519425);
        TextDrawSetShadow(music[41], 0);
        TextDrawSetOutline(music[41], 0);
        TextDrawBackgroundColor(music[41], 51);
        TextDrawFont(music[41], 1);
        TextDrawSetProportional(music[41], 1);
        TextDrawSetSelectable(music[41], false);
        music[42] = TextDrawCreate(590.000000, 336.249938, "I");
        TextDrawLetterSize(music[42], 0.300500, 1.535835);
        TextDrawAlignment(music[42], 1);
        TextDrawColor(music[42], -10878721);
        TextDrawSetShadow(music[42], 0);
        TextDrawSetOutline(music[42], 0);
        TextDrawBackgroundColor(music[42], 51);
        TextDrawFont(music[42], 1);
        TextDrawSetProportional(music[42], 1);
        TextDrawSetSelectable(music[42], false);
        music[43] = TextDrawCreate(592.500000, 332.583221, "I");
        TextDrawLetterSize(music[43], 0.345500, 1.990837);
        TextDrawAlignment(music[43], 1);
        TextDrawColor(music[43], -14084865);
        TextDrawSetShadow(music[43], 0);
        TextDrawSetOutline(music[43], 0);
        TextDrawBackgroundColor(music[43], 51);
        TextDrawFont(music[43], 1);
        TextDrawSetProportional(music[43], 1);
        TextDrawSetSelectable(music[43], false);
        music[44] = TextDrawCreate(595.500000, 328.333129, "I");
        TextDrawLetterSize(music[44], 0.302500, 2.539174);
        TextDrawAlignment(music[44], 1);
        TextDrawColor(music[44], -15662849);
        TextDrawSetShadow(music[44], 0);
        TextDrawSetOutline(music[44], 0);
        TextDrawBackgroundColor(music[44], 51);
        TextDrawFont(music[44], 1);
        TextDrawSetProportional(music[44], 1);
        TextDrawSetSelectable(music[44], false);
        music[45] = TextDrawCreate(598.000000, 324.083068, "I");
        TextDrawLetterSize(music[45], 0.302500, 3.087510);
        TextDrawAlignment(music[45], 1);
        TextDrawColor(music[45], -16776961);
        TextDrawSetShadow(music[45], 0);
        TextDrawSetOutline(music[45], 0);
        TextDrawBackgroundColor(music[45], 51);
        TextDrawFont(music[45], 1);
        TextDrawSetProportional(music[45], 1);
        TextDrawSetSelectable(music[45], false);
        ///////ZWA9////////
        music[46] = TextDrawCreate(615.500000, 359.666625, "usebox");
        TextDrawLetterSize(music[46], 0.000000, 0.914819);
        TextDrawTextSize(music[46], 292.000000, 0.000000);
        TextDrawAlignment(music[46], 1);
        TextDrawColor(music[46], 0);
        TextDrawUseBox(music[46], true);
        TextDrawBoxColor(music[46], 102);
        TextDrawSetShadow(music[46], 0);
        TextDrawSetOutline(music[46], 0);
        TextDrawFont(music[46], 0);
        music[47] = TextDrawCreate(427.500000, 294.583312, "LD_BEAT:cring");
        TextDrawLetterSize(music[47], 0.000000, 0.000000);
        TextDrawTextSize(music[47], 65.500000, 75.833282);
        TextDrawAlignment(music[47], 1);
        TextDrawColor(music[47], 255);
        TextDrawSetShadow(music[47], 0);
        TextDrawSetOutline(music[47], 0);
        TextDrawBackgroundColor(music[47], -5963521);
        TextDrawFont(music[47], 4);
        music[48] = TextDrawCreate(365.000000, 312.083312, "LD_SPAC:white");
        TextDrawLetterSize(music[48], 0.000000, 0.000000);
        TextDrawTextSize(music[48], 83.000000, 4.666687);
        TextDrawAlignment(music[48], 1);
        TextDrawColor(music[48], 255);
        TextDrawSetShadow(music[48], 0);
        TextDrawSetOutline(music[48], 0);
        TextDrawFont(music[48], 4);
        music[49] = TextDrawCreate(474.000000, 312.500091, "LD_SPAC:white");
        TextDrawLetterSize(music[49], 0.000000, 0.000000);
        TextDrawTextSize(music[49], 81.000000, 4.666687);
        TextDrawAlignment(music[49], 1);
        TextDrawColor(music[49], 255);
        TextDrawSetShadow(music[49], 0);
        TextDrawSetOutline(music[49], 0);
        TextDrawFont(music[49], 4);
        music[50] = TextDrawCreate(472.500000, 348.500030, "LD_SPAC:white");
        TextDrawLetterSize(music[50], 0.000000, 0.000000);
        TextDrawTextSize(music[50], 87.000000, 4.666687);
        TextDrawAlignment(music[50], 1);
        TextDrawColor(music[50], 255);
        TextDrawSetShadow(music[50], 0);
        TextDrawSetOutline(music[50], 0);
        TextDrawFont(music[50], 4);
        music[51] = TextDrawCreate(369.500000, 348.333282, "LD_SPAC:white");
        TextDrawLetterSize(music[51], 0.000000, 0.000000);
        TextDrawTextSize(music[51], 82.000000, 4.666687);
        TextDrawAlignment(music[51], 1);
        TextDrawColor(music[51], 255);
        TextDrawSetShadow(music[51], 0);
        TextDrawSetOutline(music[51], 0);
        TextDrawFont(music[51], 4);
        music[52] = TextDrawCreate(365.000000, 317.333404, "LD_SPAC:white");
        TextDrawLetterSize(music[52], 0.000000, 0.000000);
        TextDrawTextSize(music[52], 4.000000, 36.166694);
        TextDrawAlignment(music[52], 1);
        TextDrawColor(music[52], 255);
        TextDrawSetShadow(music[52], 0);
        TextDrawSetOutline(music[52], 0);
        TextDrawFont(music[52], 4);
        music[53] = TextDrawCreate(555.500000, 312.500091, "LD_SPAC:white");
        TextDrawLetterSize(music[53], 0.000000, 0.000000);
        TextDrawTextSize(music[53], 4.000000, 35.583354);
        TextDrawAlignment(music[53], 1);
        TextDrawColor(music[53], 255);
        TextDrawSetShadow(music[53], 0);
        TextDrawSetOutline(music[53], 0);
        TextDrawFont(music[53], 4);
        ///=============== SuperBall ========================//
        SuperBall[0] = TextDrawCreate(633.500000, 9.083333, "usebox");
        TextDrawLetterSize(SuperBall[0], 0.000000, 42.201850);
        TextDrawTextSize(SuperBall[0], 359.500000, 0.000000);
        TextDrawAlignment(SuperBall[0], 1);
        TextDrawColor(SuperBall[0], 0);
        TextDrawUseBox(SuperBall[0], true);
        TextDrawBoxColor(SuperBall[0], -1409286298);
        TextDrawSetShadow(SuperBall[0], 0);
        TextDrawSetOutline(SuperBall[0], 0);
        TextDrawFont(SuperBall[0], 0);
        SuperBall[1] = TextDrawCreate(633.000000, 9.666666, "usebox");
        TextDrawLetterSize(SuperBall[1], 0.000000, 1.757407);
        TextDrawTextSize(SuperBall[1], 360.000000, 0.000000);
        TextDrawAlignment(SuperBall[1], 1);
        TextDrawColor(SuperBall[1], 0);
        TextDrawUseBox(SuperBall[1], true);
        TextDrawBoxColor(SuperBall[1], 100697446);
        TextDrawSetShadow(SuperBall[1], 0);
        TextDrawSetOutline(SuperBall[1], 0);
        TextDrawFont(SuperBall[1], 0);
        SuperBall[2] = TextDrawCreate(364.000000, 13.999989, "-");
        TextDrawLetterSize(SuperBall[2], 0.967000, 1.506666);
        TextDrawAlignment(SuperBall[2], 1);
        TextDrawColor(SuperBall[2], 255);
        TextDrawSetShadow(SuperBall[2], 0);
        TextDrawSetOutline(SuperBall[2], 1);
        TextDrawBackgroundColor(SuperBall[2], 51);
        TextDrawFont(SuperBall[2], 1);
        TextDrawSetProportional(SuperBall[2], 1);
        SuperBall[3] = TextDrawCreate(364.000000, 2.166657, "-");
        TextDrawLetterSize(SuperBall[3], 0.967000, 1.506666);
        TextDrawAlignment(SuperBall[3], 1);
        TextDrawColor(SuperBall[3], 255);
        TextDrawSetShadow(SuperBall[3], 0);
        TextDrawSetOutline(SuperBall[3], 1);
        TextDrawBackgroundColor(SuperBall[3], 51);
        TextDrawFont(SuperBall[3], 1);
        TextDrawSetProportional(SuperBall[3], 1);
        SuperBall[4] = TextDrawCreate(366.500000, 15.166685, "ld_pool:ball");
        TextDrawLetterSize(SuperBall[4], 0.000000, 0.000000);
        TextDrawTextSize(SuperBall[4], 2.500000, 2.916664);
        TextDrawAlignment(SuperBall[4], 1);
        TextDrawColor(SuperBall[4], 16711935);
        TextDrawSetShadow(SuperBall[4], 0);
        TextDrawSetOutline(SuperBall[4], 0);
        TextDrawFont(SuperBall[4], 4);
        SuperBall[5] = TextDrawCreate(601.500000, 8.750000, "LD_SPAC:white");
        TextDrawLetterSize(SuperBall[5], 0.000000, 0.000000);
        TextDrawTextSize(SuperBall[5], 28.500000, 13.416667);
        TextDrawAlignment(SuperBall[5], 1);
        TextDrawColor(SuperBall[5], -1);
        TextDrawSetShadow(SuperBall[5], 0);
        TextDrawSetOutline(SuperBall[5], 0);
        TextDrawFont(SuperBall[5], 4);
        TextDrawSetSelectable(SuperBall[5], true);
        SuperBall[6] = TextDrawCreate(615.500000, 11.666669, "X");
        TextDrawLetterSize(SuperBall[6], 0.454999, 0.829999);
        TextDrawTextSize(SuperBall[6], -1.000000, 23.333332);
        TextDrawAlignment(SuperBall[6], 2);
        TextDrawColor(SuperBall[6], -1);
        TextDrawUseBox(SuperBall[6], true);
        TextDrawBoxColor(SuperBall[6], -2147483393);
        TextDrawSetShadow(SuperBall[6], 0);
        TextDrawSetOutline(SuperBall[6], 0);
        TextDrawBackgroundColor(SuperBall[6], 51);
        TextDrawFont(SuperBall[6], 2);
        TextDrawSetProportional(SuperBall[6], 1);
        SuperBall[7] = TextDrawCreate(382.500000, 8.750035, "SuperBall");
        TextDrawLetterSize(SuperBall[7], 0.449999, 1.600000);
        TextDrawAlignment(SuperBall[7], 1);
        TextDrawColor(SuperBall[7], -1);
        TextDrawSetShadow(SuperBall[7], 0);
        TextDrawSetOutline(SuperBall[7], 1);
        TextDrawBackgroundColor(SuperBall[7], 51);
        TextDrawFont(SuperBall[7], 1);
        TextDrawSetProportional(SuperBall[7], 1);
        SuperBall[8] = TextDrawCreate(362.000000, 28.583333, "LD_DUAL:backgnd");
        TextDrawLetterSize(SuperBall[8], 0.000000, 0.000000);
        TextDrawTextSize(SuperBall[8], 269.000000, 362.249969);
        TextDrawAlignment(SuperBall[8], 1);
        TextDrawColor(SuperBall[8], -1);
        TextDrawSetShadow(SuperBall[8], 0);
        TextDrawSetOutline(SuperBall[8], 0);
        TextDrawFont(SuperBall[8], 4);
        SuperBall[9] = TextDrawCreate(362.500000, 323.750000, "ld_shtr:bstars");
        TextDrawLetterSize(SuperBall[9], 0.000000, 0.000000);
        TextDrawTextSize(SuperBall[9], 268.000000, 66.499977);
        TextDrawAlignment(SuperBall[9], 1);
        TextDrawColor(SuperBall[9], -1);
        TextDrawSetShadow(SuperBall[9], 0);
        TextDrawSetOutline(SuperBall[9], 0);
        TextDrawFont(SuperBall[9], 4);
        SuperBall[10] = TextDrawCreate(363.000000, 322.000000, "ld_shtr:hbarm");
        TextDrawLetterSize(SuperBall[10], 0.000000, 0.000000);
        TextDrawTextSize(SuperBall[10], 267.000000, 5.833312);
        TextDrawAlignment(SuperBall[10], 1);
        TextDrawColor(SuperBall[10], -1);
        TextDrawSetShadow(SuperBall[10], 0);
        TextDrawSetOutline(SuperBall[10], 0);
        TextDrawFont(SuperBall[10], 4);
        SuperBall[11] = TextDrawCreate(536.000000, 379.166687, "Press Space to leave");
        TextDrawLetterSize(SuperBall[11], 0.273999, 1.115832);
        TextDrawAlignment(SuperBall[11], 1);
        TextDrawColor(SuperBall[11], -5963521);
        TextDrawSetShadow(SuperBall[11], 0);
        TextDrawSetOutline(SuperBall[11], 0);
        TextDrawBackgroundColor(SuperBall[11], 51);
        TextDrawFont(SuperBall[11], 1);
        TextDrawSetProportional(SuperBall[11], 1);
        // Health
        tdhealth[0] = TextDrawCreate(365.500000, 358.166687, "hud:radar_girlfriend");
        TextDrawLetterSize(tdhealth[0], 0.000000, 0.000000);
        TextDrawTextSize(tdhealth[0], 24.000000, 26.833312);
        TextDrawAlignment(tdhealth[0], 1);
        TextDrawColor(tdhealth[0], -1);
        TextDrawSetShadow(tdhealth[0], 0);
        TextDrawSetOutline(tdhealth[0], 0);
        TextDrawFont(tdhealth[0], 4);
        tdhealth[1] = TextDrawCreate(390.500000, 358.000000, "hud:radar_girlfriend");
        TextDrawLetterSize(tdhealth[1], 0.000000, 0.000000);
        TextDrawTextSize(tdhealth[1], 24.000000, 26.833312);
        TextDrawAlignment(tdhealth[1], 1);
        TextDrawColor(tdhealth[1], -1);
        TextDrawSetShadow(tdhealth[1], 0);
        TextDrawSetOutline(tdhealth[1], 0);
        TextDrawFont(tdhealth[1], 4);
        tdhealth[2] = TextDrawCreate(415.500000, 357.833251, "hud:radar_girlfriend");
        TextDrawLetterSize(tdhealth[2], 0.000000, 0.000000);
        TextDrawTextSize(tdhealth[2], 24.000000, 26.833312);
        TextDrawAlignment(tdhealth[2], 1);
        TextDrawColor(tdhealth[2], -1);
        TextDrawSetShadow(tdhealth[2], 0);
        TextDrawSetOutline(tdhealth[2], 0);
        TextDrawFont(tdhealth[2], 4);
        // Onglet
        onglet[0] = TextDrawCreate(641.500000, 1.500000, "usebox");
        TextDrawLetterSize(onglet[0], 0.000000, 43.303699);
        TextDrawTextSize(onglet[0], 321.500000, 0.000000);
        TextDrawAlignment(onglet[0], 1);
        TextDrawColor(onglet[0], 0);
        TextDrawUseBox(onglet[0], true);
        TextDrawBoxColor(onglet[0], 16777062);
        TextDrawSetShadow(onglet[0], 0);
        TextDrawSetOutline(onglet[0], 0);
        TextDrawFont(onglet[0], 0);
        onglet[1] = TextDrawCreate(639.500000, 3.833333, "usebox");
        TextDrawLetterSize(onglet[1], 0.000000, 42.785182);
        TextDrawTextSize(onglet[1], 323.500000, 0.000000);
        TextDrawAlignment(onglet[1], 1);
        TextDrawColor(onglet[1], -1378294017);
        TextDrawUseBox(onglet[1], true);
        TextDrawBoxColor(onglet[1], -1378294017);
        TextDrawSetShadow(onglet[1], 0);
        TextDrawSetOutline(onglet[1], 0);
        TextDrawFont(onglet[1], 0);
        onglet[2] = TextDrawCreate(326.000000, 2.333333, "LD_SPAC:white");
        TextDrawLetterSize(onglet[2], 0.000000, 0.000000);
        TextDrawTextSize(onglet[2], 311.000000, 388.499969);
        TextDrawAlignment(onglet[2], 1);
        TextDrawColor(onglet[2], 8650751);
        TextDrawSetShadow(onglet[2], 0);
        TextDrawSetOutline(onglet[2], 0);
        TextDrawFont(onglet[2], 4);
        onglet[3] = TextDrawCreate(327.000000, 3.500000, "ld_poke:cd8s");
        TextDrawLetterSize(onglet[3], 0.000000, 0.000000);
        TextDrawTextSize(onglet[3], 83.000000, 16.333326);
        TextDrawAlignment(onglet[3], 1);
        TextDrawColor(onglet[3], -1);
        TextDrawSetShadow(onglet[3], 0);
        TextDrawSetOutline(onglet[3], 0);
        TextDrawFont(onglet[3], 4);
        onglet[4] = TextDrawCreate(328.500000, 5.250000, "LD_SPAC:white");
        TextDrawLetterSize(onglet[4], 0.000000, 0.000000);
        TextDrawTextSize(onglet[4], 79.500000, 13.416664);
        TextDrawAlignment(onglet[4], 1);
        TextDrawColor(onglet[4], -337446657);
        TextDrawSetShadow(onglet[4], 0);
        TextDrawSetOutline(onglet[4], 0);
        TextDrawFont(onglet[4], 4);
        onglet[5] = TextDrawCreate(327.000000, 17.333324, "LD_SPAC:white");
        TextDrawLetterSize(onglet[5], 0.000000, 0.000000);
        TextDrawTextSize(onglet[5], 309.000000, 372.166717);
        TextDrawAlignment(onglet[5], 1);
        TextDrawColor(onglet[5], -337446657);
        TextDrawSetShadow(onglet[5], 0);
        TextDrawSetOutline(onglet[5], 0);
        TextDrawFont(onglet[5], 4);
        onglet[6] = TextDrawCreate(609.500000, 3.499999, "LD_SPAC:white");
        TextDrawLetterSize(onglet[6], 0.000000, 0.000000);
        TextDrawTextSize(onglet[6], 26.500000, 9.333332);
        TextDrawAlignment(onglet[6], 1);
        TextDrawColor(onglet[6], -1);
        TextDrawSetShadow(onglet[6], 0);
        TextDrawSetOutline(onglet[6], 0);
        TextDrawFont(onglet[6], 4);
        TextDrawSetSelectable(onglet[6], true);
        onglet[7] = TextDrawCreate(622.500000, 6.416660, "X");
        TextDrawLetterSize(onglet[7], 0.270499, 0.369166);
        TextDrawTextSize(onglet[7], -2.500000, 21.583333);
        TextDrawAlignment(onglet[7], 2);
        TextDrawColor(onglet[7], -1);
        TextDrawUseBox(onglet[7], true);
        TextDrawBoxColor(onglet[7], -1523963137);
        TextDrawSetShadow(onglet[7], 0);
        TextDrawSetOutline(onglet[7], 0);
        TextDrawBackgroundColor(onglet[7], 51);
        TextDrawFont(onglet[7], 1);
        TextDrawSetProportional(onglet[7], 1);
        onglet[8] = TextDrawCreate(328.000000, 25.666671, "ld_beat:left");
        TextDrawLetterSize(onglet[8], 0.000000, 0.000000);
        TextDrawTextSize(onglet[8], 13.000000, 12.250000);
        TextDrawAlignment(onglet[8], 1);
        TextDrawColor(onglet[8], -1);
        TextDrawSetShadow(onglet[8], 0);
        TextDrawSetOutline(onglet[8], 0);
        TextDrawFont(onglet[8], 4);
        onglet[9] = TextDrawCreate(342.500000, 25.500003, "ld_beat:right");
        TextDrawLetterSize(onglet[9], 0.000000, 0.000000);
        TextDrawTextSize(onglet[9], 13.000000, 12.250000);
        TextDrawAlignment(onglet[9], 1);
        TextDrawColor(onglet[9], -1);
        TextDrawSetShadow(onglet[9], 0);
        TextDrawSetOutline(onglet[9], 0);
        TextDrawFont(onglet[9], 4);
        onglet[10] = TextDrawCreate(370.000000, 24.500000, "hud:radar_triadsCasino");
        TextDrawLetterSize(onglet[10], 0.000000, 0.000000);
        TextDrawTextSize(onglet[10], -13.000000, 14.000000);
        TextDrawAlignment(onglet[10], 1);
        TextDrawColor(onglet[10], -2130738945);
        TextDrawSetShadow(onglet[10], 0);
        TextDrawSetOutline(onglet[10], 0);
        TextDrawFont(onglet[10], 4);
        onglet[11] = TextDrawCreate(386.500000, 22.750000, "hud:radar_propertyG");
        TextDrawLetterSize(onglet[11], 0.000000, 0.000000);
        TextDrawTextSize(onglet[11], -15.500000, 15.750002);
        TextDrawAlignment(onglet[11], 1);
        TextDrawColor(onglet[11], -1);
        TextDrawSetShadow(onglet[11], 0);
        TextDrawSetOutline(onglet[11], 0);
        TextDrawFont(onglet[11], 4);
        onglet[12] = TextDrawCreate(388.000000, 22.750000, "ld_poke:cd8s");
        TextDrawLetterSize(onglet[12], 0.000000, 0.000000);
        TextDrawTextSize(onglet[12], 228.500000, 15.166666);
        TextDrawAlignment(onglet[12], 1);
        TextDrawColor(onglet[12], -1061109505);
        TextDrawSetShadow(onglet[12], 0);
        TextDrawSetOutline(onglet[12], 0);
        TextDrawFont(onglet[12], 4);
        onglet[13] = TextDrawCreate(389.000000, 23.916667, "LD_SPAC:white");
        TextDrawLetterSize(onglet[13], 0.000000, 0.000000);
        TextDrawTextSize(onglet[13], 226.500000, 12.833332);
        TextDrawAlignment(onglet[13], 1);
        TextDrawColor(onglet[13], -1);
        TextDrawSetShadow(onglet[13], 0);
        TextDrawSetOutline(onglet[13], 0);
        TextDrawFont(onglet[13], 4);
        onglet[14] = TextDrawCreate(620.500000, 23.333288, "-~n~-~n~-");
        TextDrawLetterSize(onglet[14], 0.788000, 0.462500);
        TextDrawAlignment(onglet[14], 1);
        TextDrawColor(onglet[14], 255);
        TextDrawSetShadow(onglet[14], 0);
        TextDrawSetOutline(onglet[14], 1);
        TextDrawBackgroundColor(onglet[14], 51);
        TextDrawFont(onglet[14], 1);
        TextDrawSetProportional(onglet[14], 1);
        onglet[15] = TextDrawCreate(402.500000, 5.833334, "LD_SPAC:white");
        TextDrawLetterSize(onglet[15], 0.000000, 0.000000);
        TextDrawTextSize(onglet[15], 5.000000, 5.833332);
        TextDrawAlignment(onglet[15], 1);
        TextDrawColor(onglet[15], -538842113);
        TextDrawSetShadow(onglet[15], 0);
        TextDrawSetOutline(onglet[15], 0);
        TextDrawFont(onglet[15], 4);
        TextDrawSetSelectable(onglet[15], true);
        onglet[16] = TextDrawCreate(328.000000, 40.833335, "LD_SPAC:white");
        TextDrawLetterSize(onglet[16], 0.000000, 0.000000);
        TextDrawTextSize(onglet[16], 308.000000, 348.249969);
        TextDrawAlignment(onglet[16], 1);
        TextDrawColor(onglet[16], -1);
        TextDrawSetShadow(onglet[16], 0);
        TextDrawSetOutline(onglet[16], 0);
        TextDrawFont(onglet[16], 4);
        onglet[17] = TextDrawCreate(402.000000, 4.083327, "X");
        TextDrawLetterSize(onglet[17], 0.255000, 0.806665);
        TextDrawAlignment(onglet[17], 1);
        TextDrawColor(onglet[17], -2140372737);
        TextDrawSetShadow(onglet[17], 0);
        TextDrawSetOutline(onglet[17], 0);
        TextDrawBackgroundColor(onglet[17], 51);
        TextDrawFont(onglet[17], 1);
        TextDrawSetProportional(onglet[17], 1);
        ///////////////// FAcebook DATA ////////////////////////////
        fbdata[0] = TextDrawCreate(329.000000, 5.833333, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[0], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[0], 8.000000, 9.333333);
        TextDrawAlignment(fbdata[0], 1);
        TextDrawColor(fbdata[0], 1197385195);
        TextDrawSetShadow(fbdata[0], 0);
        TextDrawSetOutline(fbdata[0], 0);
        TextDrawFont(fbdata[0], 4);
        fbdata[1] = TextDrawCreate(330.500000, 5.250039, "f");
        TextDrawLetterSize(fbdata[1], 0.346500, 1.296666);
        TextDrawAlignment(fbdata[1], 1);
        TextDrawColor(fbdata[1], -1);
        TextDrawSetShadow(fbdata[1], 0);
        TextDrawSetOutline(fbdata[1], 0);
        TextDrawBackgroundColor(fbdata[1], 51);
        TextDrawFont(fbdata[1], 1);
        TextDrawSetProportional(fbdata[1], 1);
        fbdata[2] = TextDrawCreate(338.000000, 5.249990, "Facebook");
        TextDrawLetterSize(fbdata[2], 0.217000, 1.039999);
        TextDrawAlignment(fbdata[2], 1);
        TextDrawColor(fbdata[2], 255);
        TextDrawSetShadow(fbdata[2], 0);
        TextDrawSetOutline(fbdata[2], 0);
        TextDrawBackgroundColor(fbdata[2], 51);
        TextDrawFont(fbdata[2], 1);
        TextDrawSetProportional(fbdata[2], 1);
        fbdata[3] = TextDrawCreate(391.500000, 25.666702, "https:");
        TextDrawLetterSize(fbdata[3], 0.202499, 0.917499);
        TextDrawAlignment(fbdata[3], 1);
        TextDrawColor(fbdata[3], 8388863);
        TextDrawSetShadow(fbdata[3], 0);
        TextDrawSetOutline(fbdata[3], 0);
        TextDrawBackgroundColor(fbdata[3], 51);
        TextDrawFont(fbdata[3], 1);
        TextDrawSetProportional(fbdata[3], 1);
        fbdata[4] = TextDrawCreate(410.500000, 25.500034, "//");
        TextDrawLetterSize(fbdata[4], 0.202499, 0.917499);
        TextDrawAlignment(fbdata[4], 1);
        TextDrawColor(fbdata[4], -2139062017);
        TextDrawSetShadow(fbdata[4], 0);
        TextDrawSetOutline(fbdata[4], 0);
        TextDrawBackgroundColor(fbdata[4], 51);
        TextDrawFont(fbdata[4], 1);
        TextDrawSetProportional(fbdata[4], 1);
        fbdata[5] = TextDrawCreate(416.500000, 25.916700, "www.facebook.com");
        TextDrawLetterSize(fbdata[5], 0.202499, 0.917499);
        TextDrawAlignment(fbdata[5], 1);
        TextDrawColor(fbdata[5], 255);
        TextDrawSetShadow(fbdata[5], 0);
        TextDrawSetOutline(fbdata[5], 0);
        TextDrawBackgroundColor(fbdata[5], 51);
        TextDrawFont(fbdata[5], 1);
        TextDrawSetProportional(fbdata[5], 1);
        fbdata[6] = TextDrawCreate(637.031494, 42.916664, "usebox");
        TextDrawLetterSize(fbdata[6], 0.000000, 2.001852);
        TextDrawTextSize(fbdata[6], 325.031463, 0.000000);
        TextDrawAlignment(fbdata[6], 1);
        TextDrawColor(fbdata[6], 0);
        TextDrawUseBox(fbdata[6], true);
        TextDrawBoxColor(fbdata[6], 41215);
        TextDrawSetShadow(fbdata[6], 0);
        TextDrawSetOutline(fbdata[6], 0);
        TextDrawFont(fbdata[6], 0);
        fbdata[7] = TextDrawCreate(638.031494, 42.750015, "usebox");
        TextDrawLetterSize(fbdata[7], 0.000000, 1.951852);
        TextDrawTextSize(fbdata[7], 325.031463, 0.000000);
        TextDrawAlignment(fbdata[7], 1);
        TextDrawColor(fbdata[7], 9633791);
        TextDrawUseBox(fbdata[7], true);
        TextDrawBoxColor(fbdata[7], -149);
        TextDrawSetShadow(fbdata[7], 0);
        TextDrawSetOutline(fbdata[7], 0);
        TextDrawFont(fbdata[7], 0);
        fbdata[8] = TextDrawCreate(329.000000, 43.750000, "ld_poke:cd9s");
        TextDrawLetterSize(fbdata[8], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[8], 16.000000, 16.916667);
        TextDrawAlignment(fbdata[8], 1);
        TextDrawColor(fbdata[8], -1);
        TextDrawSetShadow(fbdata[8], 0);
        TextDrawSetOutline(fbdata[8], 0);
        TextDrawFont(fbdata[8], 4);
        fbdata[9] = TextDrawCreate(329.500000, 44.916664, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[9], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[9], 15.000000, 15.166667);
        TextDrawAlignment(fbdata[9], 1);
        TextDrawColor(fbdata[9], -1);
        TextDrawSetShadow(fbdata[9], 0);
        TextDrawSetOutline(fbdata[9], 0);
        TextDrawFont(fbdata[9], 4);
        fbdata[10] = TextDrawCreate(332.500000, 43.750057, "f");
        TextDrawLetterSize(fbdata[10], 0.661499, 2.165833);
        TextDrawAlignment(fbdata[10], 1);
        TextDrawColor(fbdata[10], 1702872063);
        TextDrawSetShadow(fbdata[10], 0);
        TextDrawSetOutline(fbdata[10], 0);
        TextDrawBackgroundColor(fbdata[10], 51);
        TextDrawFont(fbdata[10], 1);
        TextDrawSetProportional(fbdata[10], 1);
        fbdata[11] = TextDrawCreate(348.000000, 48.416664, "ld_poke:cd9s");
        TextDrawLetterSize(fbdata[11], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[11], 125.000000, 11.666668);
        TextDrawAlignment(fbdata[11], 1);
        TextDrawColor(fbdata[11], -1);
        TextDrawSetShadow(fbdata[11], 0);
        TextDrawSetOutline(fbdata[11], 0);
        TextDrawFont(fbdata[11], 4);
        fbdata[12] = TextDrawCreate(348.500000, 49.000000, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[12], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[12], 119.500000, 10.500000);
        TextDrawAlignment(fbdata[12], 1);
        TextDrawColor(fbdata[12], -1);
        TextDrawSetShadow(fbdata[12], 0);
        TextDrawSetOutline(fbdata[12], 0);
        TextDrawFont(fbdata[12], 4);
        fbdata[13] = TextDrawCreate(458.000000, 49.583335, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[13], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[13], 14.000000, 10.500001);
        TextDrawAlignment(fbdata[13], 1);
        TextDrawColor(fbdata[13], -403374081);
        TextDrawSetShadow(fbdata[13], 0);
        TextDrawSetOutline(fbdata[13], 0);
        TextDrawFont(fbdata[13], 4);
        fbdata[14] = TextDrawCreate(478.500000, 41.416664, "loadsc11:loadsc11");
        TextDrawLetterSize(fbdata[14], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[14], 22.500000, 19.833339);
        TextDrawAlignment(fbdata[14], 1);
        TextDrawColor(fbdata[14], -1);
        TextDrawSetShadow(fbdata[14], 0);
        TextDrawSetOutline(fbdata[14], 0);
        TextDrawFont(fbdata[14], 4);
        fbdata[15] = TextDrawCreate(476.000000, 40.833328, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[15], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[15], 11.000000, 20.416667);
        TextDrawAlignment(fbdata[15], 1);
        TextDrawColor(fbdata[15], 1952895743);
        TextDrawSetShadow(fbdata[15], 0);
        TextDrawSetOutline(fbdata[15], 0);
        TextDrawFont(fbdata[15], 4);
        fbdata[18] = TextDrawCreate(567.500000, 41.500022, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[18], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[18], 11.000000, 20.416667);
        TextDrawAlignment(fbdata[18], 1);
        TextDrawColor(fbdata[18], -195);
        TextDrawSetShadow(fbdata[18], 0);
        TextDrawSetOutline(fbdata[18], 0);
        TextDrawFont(fbdata[18], 4);
        TextDrawSetSelectable(fbdata[18], true);
        fbdata[19] = TextDrawCreate(555.000000, 55.833328, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[19], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[19], 12.500000, 6.416668);
        TextDrawAlignment(fbdata[19], 1);
        TextDrawColor(fbdata[19], 1952895743);
        TextDrawSetShadow(fbdata[19], 0);
        TextDrawSetOutline(fbdata[19], 0);
        TextDrawFont(fbdata[19], 4);
        fbdata[20] = TextDrawCreate(555.500000, 41.666687, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[20], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[20], 11.000000, 20.416667);
        TextDrawAlignment(fbdata[20], 1);
        TextDrawColor(fbdata[20], -195);
        TextDrawSetShadow(fbdata[20], 0);
        TextDrawSetOutline(fbdata[20], 0);
        TextDrawFont(fbdata[20], 4);
        TextDrawSetSelectable(fbdata[20], true);
        fbdata[16] = TextDrawCreate(557.000000, 46.083343, "hud:radar_gangB");
        TextDrawLetterSize(fbdata[16], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[16], 9.500000, 11.666667);
        TextDrawAlignment(fbdata[16], 1);
        TextDrawColor(fbdata[16], -1);
        TextDrawSetShadow(fbdata[16], 0);
        TextDrawSetOutline(fbdata[16], 0);
        TextDrawFont(fbdata[16], 4);
        fbdata[17] = TextDrawCreate(554.000000, 48.250007, "hud:radar_gangB");
        TextDrawLetterSize(fbdata[17], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[17], 9.500000, 11.666667);
        TextDrawAlignment(fbdata[17], 1);
        TextDrawColor(fbdata[17], -1);
        TextDrawSetShadow(fbdata[17], 0);
        TextDrawSetOutline(fbdata[17], 0);
        TextDrawFont(fbdata[17], 4);
        fbdata[21] = TextDrawCreate(568.500000, 50.166664, "ld_poke:cdback");
        TextDrawLetterSize(fbdata[21], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[21], 5.500000, 5.250000);
        TextDrawAlignment(fbdata[21], 1);
        TextDrawColor(fbdata[21], 41215);
        TextDrawSetShadow(fbdata[21], 0);
        TextDrawSetOutline(fbdata[21], 0);
        TextDrawFont(fbdata[21], 4);
        fbdata[22] = TextDrawCreate(571.000000, 47.083339, "ld_poke:cdback");
        TextDrawLetterSize(fbdata[22], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[22], 5.500000, 5.250000);
        TextDrawAlignment(fbdata[22], 1);
        TextDrawColor(fbdata[22], 41215);
        TextDrawSetShadow(fbdata[22], 0);
        TextDrawSetOutline(fbdata[22], 0);
        TextDrawFont(fbdata[22], 4);
        fbdata[23] = TextDrawCreate(579.500000, 41.500019, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[23], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[23], 11.000000, 20.416667);
        TextDrawAlignment(fbdata[23], 1);
        TextDrawColor(fbdata[23], -195);
        TextDrawSetShadow(fbdata[23], 0);
        TextDrawSetOutline(fbdata[23], 0);
        TextDrawFont(fbdata[23], 4);
        TextDrawSetSelectable(fbdata[23], true);
        fbdata[24] = TextDrawCreate(581.000000, 47.250000, "ld_dual:light");
        TextDrawLetterSize(fbdata[24], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[24], 8.000000, 8.166664);
        TextDrawAlignment(fbdata[24], 1);
        TextDrawColor(fbdata[24], 1268056063);
        TextDrawSetShadow(fbdata[24], 0);
        TextDrawSetOutline(fbdata[24], 0);
        TextDrawFont(fbdata[24], 4);
        fbdata[25] = TextDrawCreate(537.500000, 372.750030, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[25], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[25], 97.500000, 15.749978);
        TextDrawAlignment(fbdata[25], 1);
        TextDrawColor(fbdata[25], -1378294017);
        TextDrawSetShadow(fbdata[25], 0);
        TextDrawSetOutline(fbdata[25], 0);
        TextDrawFont(fbdata[25], 4);
        TextDrawSetSelectable(fbdata[25], true);
        fbdata[27] = TextDrawCreate(539.000000, 66.250000, "usebox");
        TextDrawLetterSize(fbdata[27], 0.000000, 35.590740);
        TextDrawTextSize(fbdata[27], 326.500000, 0.000000);
        TextDrawAlignment(fbdata[27], 1);
        TextDrawColor(fbdata[27], 36864);
        TextDrawUseBox(fbdata[27], true);
        TextDrawBoxColor(fbdata[27], 9028454);
        TextDrawSetShadow(fbdata[27], 0);
        TextDrawSetOutline(fbdata[27], 0);
        TextDrawFont(fbdata[27], 0);
        fbdata[28] = TextDrawCreate(637.000000, 66.083282, "usebox");
        TextDrawLetterSize(fbdata[28], 0.000000, 33.740749);
        TextDrawTextSize(fbdata[28], 535.500000, 0.000000);
        TextDrawAlignment(fbdata[28], 1);
        TextDrawColor(fbdata[28], 36864);
        TextDrawUseBox(fbdata[28], true);
        TextDrawBoxColor(fbdata[28], 9028454);
        TextDrawSetShadow(fbdata[28], 0);
        TextDrawSetOutline(fbdata[28], 0);
        TextDrawFont(fbdata[28], 0);
        fbdata[29] = TextDrawCreate(539.500000, 68.250000, "ld_none:force");
        TextDrawLetterSize(fbdata[29], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[29], 28.000000, 28.583328);
        TextDrawAlignment(fbdata[29], 1);
        TextDrawColor(fbdata[29], -1);
        TextDrawSetShadow(fbdata[29], 0);
        TextDrawSetOutline(fbdata[29], 0);
        TextDrawFont(fbdata[29], 4);
        fbdata[30] = TextDrawCreate(570.000000, 68.083358, "ld_grav:bumble");
        TextDrawLetterSize(fbdata[30], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[30], 28.000000, 28.583328);
        TextDrawAlignment(fbdata[30], 1);
        TextDrawColor(fbdata[30], -1);
        TextDrawSetShadow(fbdata[30], 0);
        TextDrawSetOutline(fbdata[30], 0);
        TextDrawFont(fbdata[30], 4);
        fbdata[31] = TextDrawCreate(601.000000, 67.916694, "ld_none:title");
        TextDrawLetterSize(fbdata[31], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[31], 28.000000, 28.583328);
        TextDrawAlignment(fbdata[31], 1);
        TextDrawColor(fbdata[31], -1);
        TextDrawSetShadow(fbdata[31], 0);
        TextDrawSetOutline(fbdata[31], 0);
        TextDrawFont(fbdata[31], 4);
        fbdata[32] = TextDrawCreate(333.500000, 85.166671, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[32], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[32], 193.500000, 216.416702);
        TextDrawAlignment(fbdata[32], 1);
        TextDrawColor(fbdata[32], -983041);
        TextDrawSetShadow(fbdata[32], 0);
        TextDrawSetOutline(fbdata[32], 0);
        TextDrawFont(fbdata[32], 4);
        fbdata[33] = TextDrawCreate(336.500000, 88.666625, "ld_tatt:5cross3");
        TextDrawLetterSize(fbdata[33], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[33], 26.000000, 30.333335);
        TextDrawAlignment(fbdata[33], 1);
        TextDrawColor(fbdata[33], -1);
        TextDrawSetShadow(fbdata[33], 0);
        TextDrawSetOutline(fbdata[33], 0);
        TextDrawFont(fbdata[33], 4);
        fbdata[34] = TextDrawCreate(366.000000, 88.083274, "Mr'Souhail El'Ninia");
        TextDrawLetterSize(fbdata[34], 0.261000, 1.191666);
        TextDrawAlignment(fbdata[34], 1);
        TextDrawColor(fbdata[34], 255);
        TextDrawSetShadow(fbdata[34], 0);
        TextDrawSetOutline(fbdata[34], 0);
        TextDrawBackgroundColor(fbdata[34], 51);
        TextDrawFont(fbdata[34], 1);
        TextDrawSetProportional(fbdata[34], 1);
        fbdata[35] = TextDrawCreate(333.500000, 377.250335, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[35], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[35], 191.500000, 11.666610);
        TextDrawAlignment(fbdata[35], 1);
        TextDrawColor(fbdata[35], -983041);
        TextDrawSetShadow(fbdata[35], 0);
        TextDrawSetOutline(fbdata[35], 0);
        TextDrawFont(fbdata[35], 4);
        fbdata[36] = TextDrawCreate(336.000000, 121.333335, "loadsc10:loadsc10");
        TextDrawLetterSize(fbdata[36], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[36], 188.000000, 162.749969);
        TextDrawAlignment(fbdata[36], 1);
        TextDrawColor(fbdata[36], -1);
        TextDrawSetShadow(fbdata[36], 0);
        TextDrawSetOutline(fbdata[36], 0);
        TextDrawFont(fbdata[36], 4);
        fbdata[37] = TextDrawCreate(337.000000, 285.833404, "");
        TextDrawLetterSize(fbdata[37], 0.301500, 1.343333);
        TextDrawAlignment(fbdata[37], 1);
        TextDrawColor(fbdata[37], -1);
        TextDrawSetShadow(fbdata[37], 0);
        TextDrawSetOutline(fbdata[37], 1);
        TextDrawBackgroundColor(fbdata[37], 51);
        TextDrawFont(fbdata[37], 1);
        TextDrawSetProportional(fbdata[37], 1);
        fbdata[38] = TextDrawCreate(333.500000, 301.583312, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[38], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[38], 193.500000, 37.916656);
        TextDrawAlignment(fbdata[38], 1);
        TextDrawColor(fbdata[38], -1025376257);
        TextDrawSetShadow(fbdata[38], 0);
        TextDrawSetOutline(fbdata[38], 0);
        TextDrawFont(fbdata[38], 4);
        fbdata[39] = TextDrawCreate(336.000000, 302.750030, "");
        TextDrawLetterSize(fbdata[39], 0.220499, 0.940831);
        TextDrawAlignment(fbdata[39], 1);
        TextDrawColor(fbdata[39], 65535);
        TextDrawSetShadow(fbdata[39], 0);
        TextDrawSetOutline(fbdata[39], 0);
        TextDrawBackgroundColor(fbdata[39], 51);
        TextDrawFont(fbdata[39], 1);
        TextDrawSetProportional(fbdata[39], 1);
        fbdata[40] = TextDrawCreate(337.000000, 313.833312, "loadsc11:loadsc11");
        TextDrawLetterSize(fbdata[40], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[40], 21.500000, 23.333374);
        TextDrawAlignment(fbdata[40], 1);
        TextDrawColor(fbdata[40], -1);
        TextDrawSetShadow(fbdata[40], 0);
        TextDrawSetOutline(fbdata[40], 0);
        TextDrawFont(fbdata[40], 4);
        fbdata[26] = TextDrawCreate(360.500000, 316.750000, "LD_SPAC:white");
        TextDrawLetterSize(fbdata[26], 0.000000, 0.000000);
        TextDrawTextSize(fbdata[26], 161.500000, 17.500000);
        TextDrawAlignment(fbdata[26], 1);
        TextDrawColor(fbdata[26], -1);
        TextDrawSetShadow(fbdata[26], 0);
        TextDrawSetOutline(fbdata[26], 0);
        TextDrawFont(fbdata[26], 4);

        /////////////////Facebook Notif//////////////////////
        fbnotif[0] = TextDrawCreate(592.500000, 65.666671, "usebox");
        TextDrawLetterSize(fbnotif[0], 0.000000, 5.257407);
        TextDrawTextSize(fbnotif[0], 475.000000, 0.000000);
        TextDrawAlignment(fbnotif[0], 1);
        TextDrawColor(fbnotif[0], 0);
        TextDrawUseBox(fbnotif[0], true);
        TextDrawBoxColor(fbnotif[0], 6332624);
        TextDrawSetShadow(fbnotif[0], 0);
        TextDrawSetOutline(fbnotif[0], 0);
        TextDrawFont(fbnotif[0], 0);
        fbnotif[1] = TextDrawCreate(478.000000, 66.500000, "ld_tatt:5cross3");
        TextDrawLetterSize(fbnotif[1], 0.000000, 0.000000);
        TextDrawTextSize(fbnotif[1], 22.000000, 24.500000);
        TextDrawAlignment(fbnotif[1], 1);
        TextDrawColor(fbnotif[1], 16777215);
        TextDrawSetShadow(fbnotif[1], 0);
        TextDrawSetOutline(fbnotif[1], 0);
        TextDrawFont(fbnotif[1], 4);
        fbnotif[2] = TextDrawCreate(501.000000, 65.916625, "Mr'Souhail El'Ninia");
        TextDrawLetterSize(fbnotif[2], 0.271000, 1.045832);
        TextDrawAlignment(fbnotif[2], 1);
        TextDrawColor(fbnotif[2], -1);
        TextDrawSetShadow(fbnotif[2], 0);
        TextDrawSetOutline(fbnotif[2], 1);
        TextDrawBackgroundColor(fbnotif[2], 255);
        TextDrawFont(fbnotif[2], 1);
        TextDrawSetProportional(fbnotif[2], 1);
        fbnotif[3] = TextDrawCreate(501.000000, 76.416664, "fb.com/SN.SwagBoy");
        TextDrawLetterSize(fbnotif[3], 0.271999, 0.637500);
        TextDrawAlignment(fbnotif[3], 1);
        TextDrawColor(fbnotif[3], 255);
        TextDrawSetShadow(fbnotif[3], 0);
        TextDrawSetOutline(fbnotif[3], 0);
        TextDrawBackgroundColor(fbnotif[3], 51);
        TextDrawFont(fbnotif[3], 1);
        TextDrawSetProportional(fbnotif[3], 1);
        fbnotif[4] = TextDrawCreate(501.500000, 83.416687, "");
        TextDrawLetterSize(fbnotif[4], 0.295000, 0.911665);
        TextDrawAlignment(fbnotif[4], 1);
        TextDrawColor(fbnotif[4], -1);
        TextDrawSetShadow(fbnotif[4], 0);
        TextDrawSetOutline(fbnotif[4], 0);
        TextDrawBackgroundColor(fbnotif[4], 51);
        TextDrawFont(fbnotif[4], 1);
        TextDrawSetProportional(fbnotif[4], 1);

        // Loading
        loadwin[0] = TextDrawCreate(0.000000, 0.000000, "ld_tatt:11dice");
        TextDrawLetterSize(loadwin[0], 0.000000, 0.000000);
        TextDrawTextSize(loadwin[0], 640.000000, 423.500000);
        TextDrawAlignment(loadwin[0], 1);
        TextDrawColor(loadwin[0], 32511);
        TextDrawSetShadow(loadwin[0], 0);
        TextDrawSetOutline(loadwin[0], 0);
        TextDrawFont(loadwin[0], 4);
        loadwin[1] = TextDrawCreate(175.500000, 104.416664, "Loading Windows 7");
        TextDrawLetterSize(loadwin[1], 0.942000, 5.659999);
        TextDrawAlignment(loadwin[1], 1);
        TextDrawColor(loadwin[1], 65535);
        TextDrawSetShadow(loadwin[1], 0);
        TextDrawSetOutline(loadwin[1], 1);
        TextDrawBackgroundColor(loadwin[1], -65281);
        TextDrawFont(loadwin[1], 1);
        TextDrawSetProportional(loadwin[1], 1);
        loadwin[2] = TextDrawCreate(177.000000, 159.833328, "LD_SPAC:white");
        TextDrawLetterSize(loadwin[2], 0.000000, 0.000000);
        TextDrawTextSize(loadwin[2], 314.000000, 31.500000);
        TextDrawAlignment(loadwin[2], 1);
        TextDrawColor(loadwin[2], -1);
        TextDrawSetShadow(loadwin[2], 0);
        TextDrawSetOutline(loadwin[2], 0);
        TextDrawFont(loadwin[2], 4);
        //Zombiesg
        Zombiesg[0] = TextDrawCreate(103.000000, 116.083343, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[0], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[0], 485.500000, 244.999984);
        TextDrawAlignment(Zombiesg[0], 1);
        TextDrawColor(Zombiesg[0], -1523963137);
        TextDrawSetShadow(Zombiesg[0], 0);
        TextDrawSetOutline(Zombiesg[0], 0);
        TextDrawFont(Zombiesg[0], 4);
        Zombiesg[1] = TextDrawCreate(104.500000, 117.833290, "ld_otb:trees");
        TextDrawLetterSize(Zombiesg[1], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[1], 482.500000, 241.499984);
        TextDrawAlignment(Zombiesg[1], 1);
        TextDrawColor(Zombiesg[1], -1638529281);
        TextDrawSetShadow(Zombiesg[1], 0);
        TextDrawSetOutline(Zombiesg[1], 0);
        TextDrawFont(Zombiesg[1], 4);
        Zombiesg[2] = TextDrawCreate(103.000000, 116.083328, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[2], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[2], 485.500000, 15.750002);
        TextDrawAlignment(Zombiesg[2], 1);
        TextDrawColor(Zombiesg[2], 65535);
        TextDrawSetShadow(Zombiesg[2], 0);
        TextDrawSetOutline(Zombiesg[2], 0);
        TextDrawFont(Zombiesg[2], 4);
        Zombiesg[3] = TextDrawCreate(103.000000, 117.833358, "hud:radar_gangN");
        TextDrawLetterSize(Zombiesg[3], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[3], 10.500000, 11.083312);
        TextDrawAlignment(Zombiesg[3], 1);
        TextDrawColor(Zombiesg[3], -1);
        TextDrawSetShadow(Zombiesg[3], 0);
        TextDrawSetOutline(Zombiesg[3], 0);
        TextDrawFont(Zombiesg[3], 4);
        Zombiesg[4] = TextDrawCreate(119.500000, 118.416679, "Zombies");
        TextDrawLetterSize(Zombiesg[4], 0.348500, 1.039999);
        TextDrawAlignment(Zombiesg[4], 1);
        TextDrawColor(Zombiesg[4], -1);
        TextDrawSetShadow(Zombiesg[4], 0);
        TextDrawSetOutline(Zombiesg[4], 0);
        TextDrawBackgroundColor(Zombiesg[4], 51);
        TextDrawFont(Zombiesg[4], 2);
        TextDrawSetProportional(Zombiesg[4], 1);
        Zombiesg[5] = TextDrawCreate(573.000000, 118.999992, "X");
        TextDrawLetterSize(Zombiesg[5], 0.430000, 0.555833);
        TextDrawTextSize(Zombiesg[5], 0.500000, 25.083339);
        TextDrawAlignment(Zombiesg[5], 2);
        TextDrawColor(Zombiesg[5], -1);
        TextDrawUseBox(Zombiesg[5], true);
        TextDrawBoxColor(Zombiesg[5], -2147483393);
        TextDrawSetShadow(Zombiesg[5], 0);
        TextDrawSetOutline(Zombiesg[5], 1);
        TextDrawBackgroundColor(Zombiesg[5], 51);
        TextDrawFont(Zombiesg[5], 1);
        TextDrawSetProportional(Zombiesg[5], 1);
        Zombiesg[6] = TextDrawCreate(537.500000, 310.916717, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[6], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[6], 16.000000, 17.500000);
        TextDrawAlignment(Zombiesg[6], 1);
        TextDrawColor(Zombiesg[6], -2139062017);
        TextDrawSetShadow(Zombiesg[6], 0);
        TextDrawSetOutline(Zombiesg[6], 0);
        TextDrawFont(Zombiesg[6], 4);
        Zombiesg[7] = TextDrawCreate(537.500000, 328.833312, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[7], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[7], 16.000000, 17.500000);
        TextDrawAlignment(Zombiesg[7], 1);
        TextDrawColor(Zombiesg[7], -2139062017);
        TextDrawSetShadow(Zombiesg[7], 0);
        TextDrawSetOutline(Zombiesg[7], 0);
        TextDrawFont(Zombiesg[7], 4);
        Zombiesg[8] = TextDrawCreate(554.000000, 328.666656, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[8], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[8], 16.000000, 17.500000);
        TextDrawAlignment(Zombiesg[8], 1);
        TextDrawColor(Zombiesg[8], -2139062017);
        TextDrawSetShadow(Zombiesg[8], 0);
        TextDrawSetOutline(Zombiesg[8], 0);
        TextDrawFont(Zombiesg[8], 4);
        Zombiesg[9] = TextDrawCreate(521.000000, 328.500000, "LD_SPAC:white");
        TextDrawLetterSize(Zombiesg[9], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[9], 16.000000, 17.500000);
        TextDrawAlignment(Zombiesg[9], 1);
        TextDrawColor(Zombiesg[9], -2139062017);
        TextDrawSetShadow(Zombiesg[9], 0);
        TextDrawSetOutline(Zombiesg[9], 0);
        TextDrawFont(Zombiesg[9], 4);
        Zombiesg[10] = TextDrawCreate(540.000000, 312.666564, "ld_beat:up");
        TextDrawLetterSize(Zombiesg[10], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[10], 10.500000, 13.416665);
        TextDrawAlignment(Zombiesg[10], 1);
        TextDrawColor(Zombiesg[10], -1);
        TextDrawSetShadow(Zombiesg[10], 0);
        TextDrawSetOutline(Zombiesg[10], 0);
        TextDrawFont(Zombiesg[10], 4);
        Zombiesg[11] = TextDrawCreate(557.000000, 331.166564, "ld_beat:right");
        TextDrawLetterSize(Zombiesg[11], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[11], 10.500000, 13.416665);
        TextDrawAlignment(Zombiesg[11], 1);
        TextDrawColor(Zombiesg[11], -1);
        TextDrawSetShadow(Zombiesg[11], 0);
        TextDrawSetOutline(Zombiesg[11], 0);
        TextDrawFont(Zombiesg[11], 4);
        Zombiesg[12] = TextDrawCreate(523.000000, 330.999908, "ld_beat:left");
        TextDrawLetterSize(Zombiesg[12], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[12], 10.500000, 13.416665);
        TextDrawAlignment(Zombiesg[12], 1);
        TextDrawColor(Zombiesg[12], -1);
        TextDrawSetShadow(Zombiesg[12], 0);
        TextDrawSetOutline(Zombiesg[12], 0);
        TextDrawFont(Zombiesg[12], 4);
        Zombiesg[13] = TextDrawCreate(540.000000, 331.416625, "ld_beat:down");
        TextDrawLetterSize(Zombiesg[13], 0.000000, 0.000000);
        TextDrawTextSize(Zombiesg[13], 10.500000, 13.416665);
        TextDrawAlignment(Zombiesg[13], 1);
        TextDrawColor(Zombiesg[13], -1);
        TextDrawSetShadow(Zombiesg[13], 0);
        TextDrawSetOutline(Zombiesg[13], 0);
        TextDrawFont(Zombiesg[13], 4);
        Zombiesg[14] = TextDrawCreate(453.500000, 330.166625, "Mouse +");
        TextDrawLetterSize(Zombiesg[14], 0.449999, 1.600000);
        TextDrawAlignment(Zombiesg[14], 1);
        TextDrawColor(Zombiesg[14], -1);
        TextDrawSetShadow(Zombiesg[14], 0);
        TextDrawSetOutline(Zombiesg[14], 1);
        TextDrawBackgroundColor(Zombiesg[14], 51);
        TextDrawFont(Zombiesg[14], 1);
        TextDrawSetProportional(Zombiesg[14], 1);

        //Zombie Menu
        zmenu[0] = TextDrawCreate(253.000000, 123.666679, "ld_poke:cd9s");
        TextDrawLetterSize(zmenu[0], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[0], 144.000000, 191.916656);
        TextDrawAlignment(zmenu[0], 1);
        TextDrawColor(zmenu[0], 7077887);
        TextDrawSetShadow(zmenu[0], 0);
        TextDrawSetOutline(zmenu[0], 0);
        TextDrawFont(zmenu[0], 4);
        zmenu[1] = TextDrawCreate(256.000000, 128.333374, "LD_SPAC:white");
        TextDrawLetterSize(zmenu[1], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[1], 138.000000, 183.166687);
        TextDrawAlignment(zmenu[1], 1);
        TextDrawColor(zmenu[1], 255);
        TextDrawSetShadow(zmenu[1], 0);
        TextDrawSetOutline(zmenu[1], 0);
        TextDrawFont(zmenu[1], 4);
        zmenu[2] = TextDrawCreate(256.500000, 165.083343, "ld_bum:bum2");
        TextDrawLetterSize(zmenu[2], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[2], 31.000000, -36.166679);
        TextDrawAlignment(zmenu[2], 1);
        TextDrawColor(zmenu[2], -16776961);
        TextDrawSetShadow(zmenu[2], 0);
        TextDrawSetOutline(zmenu[2], 0);
        TextDrawFont(zmenu[2], 4);
        zmenu[3] = TextDrawCreate(287.000000, 128.916732, "LD_SPAC:white");
        TextDrawLetterSize(zmenu[3], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[3], 107.000000, 36.166675);
        TextDrawAlignment(zmenu[3], 1);
        TextDrawColor(zmenu[3], 41215);
        TextDrawSetShadow(zmenu[3], 0);
        TextDrawSetOutline(zmenu[3], 0);
        TextDrawFont(zmenu[3], 4);
        zmenu[4] = TextDrawCreate(279.500000, 117.249938, "Zombies");
        TextDrawLetterSize(zmenu[4], 0.810999, 6.126661);
        TextDrawAlignment(zmenu[4], 1);
        TextDrawColor(zmenu[4], -2147483393);
        TextDrawSetShadow(zmenu[4], 0);
        TextDrawSetOutline(zmenu[4], 1);
        TextDrawBackgroundColor(zmenu[4], -16776961);
        TextDrawFont(zmenu[4], 1);
        TextDrawSetProportional(zmenu[4], 1);
        zmenu[5] = TextDrawCreate(257.000000, 166.250015, "ld_dual:power");
        TextDrawLetterSize(zmenu[5], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[5], 136.000000, 144.083343);
        TextDrawAlignment(zmenu[5], 1);
        TextDrawColor(zmenu[5], -1);
        TextDrawSetShadow(zmenu[5], 0);
        TextDrawSetOutline(zmenu[5], 0);
        TextDrawFont(zmenu[5], 4);
        zmenu[6] = TextDrawCreate(387.000000, 125.999977, "X");
        TextDrawLetterSize(zmenu[6], 0.238000, 0.701666);
        TextDrawTextSize(zmenu[6], -2.000000, 16.333333);
        TextDrawAlignment(zmenu[6], 2);
        TextDrawColor(zmenu[6], -1);
        TextDrawUseBox(zmenu[6], true);
        TextDrawBoxColor(zmenu[6], -2147483393);
        TextDrawSetShadow(zmenu[6], 0);
        TextDrawSetOutline(zmenu[6], 0);
        TextDrawBackgroundColor(zmenu[6], 51);
        TextDrawFont(zmenu[6], 1);
        TextDrawSetProportional(zmenu[6], 1);
        zmenu[7] = TextDrawCreate(290.500000, 133.583404, "ld_dual:ex2");
        TextDrawLetterSize(zmenu[7], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[7], 32.000000, 40.250003);
        TextDrawAlignment(zmenu[7], 1);
        TextDrawColor(zmenu[7], -16776961);
        TextDrawSetShadow(zmenu[7], 0);
        TextDrawSetOutline(zmenu[7], 0);
        TextDrawFont(zmenu[7], 4);
        zmenu[8] = TextDrawCreate(259.500000, 199.499938, "ld_dual:health");
        TextDrawLetterSize(zmenu[8], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[8], 131.000000, 22.166656);
        TextDrawAlignment(zmenu[8], 1);
        TextDrawColor(zmenu[8], -1);
        TextDrawSetShadow(zmenu[8], 0);
        TextDrawSetOutline(zmenu[8], 0);
        TextDrawFont(zmenu[8], 4);
        TextDrawSetSelectable(zmenu[8], true);
        zmenu[9] = TextDrawCreate(259.500000, 244.249923, "ld_dual:health");
        TextDrawLetterSize(zmenu[9], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[9], 131.000000, 22.166656);
        TextDrawAlignment(zmenu[9], 1);
        TextDrawColor(zmenu[9], -1);
        TextDrawSetShadow(zmenu[9], 0);
        TextDrawSetOutline(zmenu[9], 0);
        TextDrawFont(zmenu[9], 4);
        TextDrawSetSelectable(zmenu[9], true);
        zmenu[10] = TextDrawCreate(324.500000, 201.833221, "Play Again");
        TextDrawLetterSize(zmenu[10], 0.449999, 1.600000);
        TextDrawAlignment(zmenu[10], 2);
        TextDrawColor(zmenu[10], -1);
        TextDrawSetShadow(zmenu[10], 0);
        TextDrawSetOutline(zmenu[10], 1);
        TextDrawBackgroundColor(zmenu[10], 255);
        TextDrawFont(zmenu[10], 1);
        TextDrawSetProportional(zmenu[10], 1);
        zmenu[11] = TextDrawCreate(289.500000, 246.583251, "Upgrade");
        TextDrawLetterSize(zmenu[11], 0.449999, 1.600000);
        TextDrawAlignment(zmenu[11], 1);
        TextDrawColor(zmenu[11], -1);
        TextDrawSetShadow(zmenu[11], 0);
        TextDrawSetOutline(zmenu[11], 1);
        TextDrawBackgroundColor(zmenu[11], 255);
        TextDrawFont(zmenu[11], 1);
        TextDrawSetProportional(zmenu[11], 1);
        zmenu[12] = TextDrawCreate(377.500000, 124.250000, "LD_SPAC:white");
        TextDrawLetterSize(zmenu[12], 0.000000, 0.000000);
        TextDrawTextSize(zmenu[12], 19.500000, 9.916656);
        TextDrawAlignment(zmenu[12], 1);
        TextDrawColor(zmenu[12], -16777126);
        TextDrawSetShadow(zmenu[12], 0);
        TextDrawSetOutline(zmenu[12], 0);
        TextDrawFont(zmenu[12], 4);
        TextDrawSetSelectable(zmenu[12], true);

        gzmenu[0] = TextDrawCreate(156.500000, 126.583335, "ld_poke:cd9s");
        TextDrawLetterSize(gzmenu[0], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[0], 360.000000, 225.166656);
        TextDrawAlignment(gzmenu[0], 1);
        TextDrawColor(gzmenu[0], -1241513729);
        TextDrawSetShadow(gzmenu[0], 0);
        TextDrawSetOutline(gzmenu[0], 0);
        TextDrawFont(gzmenu[0], 4);
        gzmenu[1] = TextDrawCreate(164.500000, 131.833358, "LD_SPAC:white");
        TextDrawLetterSize(gzmenu[1], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[1], 344.000000, 214.666641);
        TextDrawAlignment(gzmenu[1], 1);
        TextDrawColor(gzmenu[1], -16776961);
        TextDrawSetShadow(gzmenu[1], 0);
        TextDrawSetOutline(gzmenu[1], 0);
        TextDrawFont(gzmenu[1], 4);
        gzmenu[2] = TextDrawCreate(266.000000, 126.583320, "Zombies");
        TextDrawLetterSize(gzmenu[2], 0.990499, 4.656665);
        TextDrawAlignment(gzmenu[2], 1);
        TextDrawColor(gzmenu[2], -2147483393);
        TextDrawSetShadow(gzmenu[2], 0);
        TextDrawSetOutline(gzmenu[2], 1);
        TextDrawBackgroundColor(gzmenu[2], 255);
        TextDrawFont(gzmenu[2], 1);
        TextDrawSetProportional(gzmenu[2], 1);
        gzmenu[3] = TextDrawCreate(164.500000, 183.166732, "Damage");
        TextDrawLetterSize(gzmenu[3], 0.244000, 1.885833);
        TextDrawAlignment(gzmenu[3], 1);
        TextDrawColor(gzmenu[3], -1);
        TextDrawSetShadow(gzmenu[3], 0);
        TextDrawSetOutline(gzmenu[3], 1);
        TextDrawBackgroundColor(gzmenu[3], 51);
        TextDrawFont(gzmenu[3], 1);
        TextDrawSetProportional(gzmenu[3], 1);
        gzmenu[4] = TextDrawCreate(198.500000, 186.666671, "ld_poke:cd9s");
        TextDrawLetterSize(gzmenu[4], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[4], 284.500000, 14.000008);
        TextDrawAlignment(gzmenu[4], 1);
        TextDrawColor(gzmenu[4], 255);
        TextDrawSetShadow(gzmenu[4], 0);
        TextDrawSetOutline(gzmenu[4], 0);
        TextDrawFont(gzmenu[4], 4);
        gzmenu[5] = TextDrawCreate(164.500000, 131.833343, "ld_dual:backgnd");
        TextDrawLetterSize(gzmenu[5], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[5], 344.000000, 214.666656);
        TextDrawAlignment(gzmenu[5], 1);
        TextDrawColor(gzmenu[5], -179);
        TextDrawSetShadow(gzmenu[5], 0);
        TextDrawSetOutline(gzmenu[5], 0);
        TextDrawFont(gzmenu[5], 4);
        gzmenu[6] = TextDrawCreate(288.000000, 141.750000, "ld_dual:dark");
        TextDrawLetterSize(gzmenu[6], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[6], 19.000000, 23.333343);
        TextDrawAlignment(gzmenu[6], 1);
        TextDrawColor(gzmenu[6], -16776961);
        TextDrawSetShadow(gzmenu[6], 0);
        TextDrawSetOutline(gzmenu[6], 0);
        TextDrawFont(gzmenu[6], 4);
        gzmenu[7] = TextDrawCreate(416.500000, 197.583389, "ld_poke:cd9s");
        TextDrawLetterSize(gzmenu[7], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[7], 66.500000, 30.916673);
        TextDrawAlignment(gzmenu[7], 1);
        TextDrawColor(gzmenu[7], 255);
        TextDrawSetShadow(gzmenu[7], 0);
        TextDrawSetOutline(gzmenu[7], 0);
        TextDrawFont(gzmenu[7], 4);
        gzmenu[8] = TextDrawCreate(485.500000, 183.166687, "+");
        TextDrawLetterSize(gzmenu[8], 0.540000, 1.932500);
        TextDrawAlignment(gzmenu[8], 1);
        TextDrawColor(gzmenu[8], 16777215);
        TextDrawSetShadow(gzmenu[8], 0);
        TextDrawSetOutline(gzmenu[8], 1);
        TextDrawBackgroundColor(gzmenu[8], 16777215);
        TextDrawFont(gzmenu[8], 1);
        TextDrawSetProportional(gzmenu[8], 1);
        gzmenu[9] = TextDrawCreate(482.000000, 181.250061, "ld_dual:dark");
        TextDrawLetterSize(gzmenu[9], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[9], 19.000000, 23.333343);
        TextDrawAlignment(gzmenu[9], 1);
        TextDrawColor(gzmenu[9], -16776961);
        TextDrawSetShadow(gzmenu[9], 0);
        TextDrawSetOutline(gzmenu[9], -46);
        TextDrawBackgroundColor(gzmenu[9], 16777215);
        TextDrawFont(gzmenu[9], 4);
        TextDrawSetSelectable(gzmenu[9], true);
        gzmenu[10] = TextDrawCreate(494.500000, 116.666664, "ld_pool:ball");
        TextDrawLetterSize(gzmenu[10], 0.000000, 0.000000);
        TextDrawTextSize(gzmenu[10], 25.000000, 28.583320);
        TextDrawAlignment(gzmenu[10], 1);
        TextDrawColor(gzmenu[10], -1392508673);
        TextDrawSetShadow(gzmenu[10], 0);
        TextDrawSetOutline(gzmenu[10], 0);
        TextDrawFont(gzmenu[10], 4);
        TextDrawSetSelectable(gzmenu[10], true);
        gzmenu[11] = TextDrawCreate(502.000000, 122.500045, "X");
        TextDrawLetterSize(gzmenu[11], 0.449999, 1.600000);
        TextDrawAlignment(gzmenu[11], 1);
        TextDrawColor(gzmenu[11], -1);
        TextDrawSetShadow(gzmenu[11], 0);
        TextDrawSetOutline(gzmenu[11], 1);
        TextDrawBackgroundColor(gzmenu[11], 51);
        TextDrawFont(gzmenu[11], 1);
        TextDrawSetProportional(gzmenu[11], 1);

        loopp {
            if(IsPlayerConnected(i)) loaddata(i);
        }
    }
    return 1;
}
stock loadcomputers() {
    new count;
    loopco {
        new file[64];
        format(file, 64, cofolder, i);
        if(fexist(file) && !ComputerInfo[i][cCreated]) {
            ComputerInfo[i][cX] = dini_Float(file, "X");
            ComputerInfo[i][cY] = dini_Float(file, "Y");
            ComputerInfo[i][cZ] = dini_Float(file, "Z");
            ComputerInfo[i][cA0] = dini_Float(file, "A0");
            ComputerInfo[i][cA1] = dini_Float(file, "A1");
            ComputerInfo[i][cA] = dini_Float(file, "A");
            ComputerInfo[i][Locked] = dini_Int(file, "Locked");
            format(ComputerInfo[i][cOwner], 24, dini_Get(file, "cOwner"));
            ComputerInfo[i][cObject] = CreateObject(COMPUTER_OBJECT, ComputerInfo[i][cX], ComputerInfo[i][cY], ComputerInfo[i][cZ], ComputerInfo[i][cA0], ComputerInfo[i][cA1], ComputerInfo[i][cA]);
            ComputerInfo[i][cCreated] = true;
            createclabel(i);
            count++;
        }
    }
    print(sprintf("[Computer System]: %d Loaded", count));
}

hook OnGameModeExit() {
    dini_IntSet(fbfolder, "likes", fblike);
    loopco {
        if(ComputerInfo[i][cCreated]) {
            DestroyObject(ComputerInfo[i][cObject]);
            Delete3DTextLabel(computer_ctext[i]);
        }
    }
    loopp { savedata(i); }
    return 1;
}

CMD:computer(playerid, const params[]) {
    if(!fexist(load)) dini_Create(load);
    if(!fexist(load2)) dini_Create(load2);
    if(!fexist(load)) return SM(playerid, "ERROR: Computer System By IORP missing folder scriptfiles/computers");
    if(!fexist(load2)) return SM(playerid, "ERROR: Computer System By IORP missing folder scriptfiles/computers/users");
    ShowPlayerDialogEx(playerid, DIALOG_COMPUTERHELP, 0, DIALOG_STYLE_LIST, "{00BFFF}Computer cmds", "{37FF00}Buy Computer 550$\n{84FF00}Edit Computer place\n{CCFF00}Sell Computer\n{FFEE00}Where is my computer?\n{FFEE00}Lock/Unlock\n{FF0000}RCON cmds", "Select", "Cancel");
    return 1;
}

stock destroy(playerid, const params[]) {
    new pfile[64];
    new cfile[64];
    new pid;
    format(pfile, 64, plfolder, params);
    pid = dini_Int(pfile, "PCID");
    format(cfile, 128, cofolder, pid);
    if(fexist(pfile)) {
        if(IsPlayerConnected(getid(params))) { rsellcom(getid(params)), MDES(playerid); } else { DestroyObject(ComputerInfo[pid][cObject]), Delete3DTextLabel(computer_ctext[pid]), dini_Remove(pfile), dini_Remove(cfile), rconlist(playerid); }
    } else ShowPlayerDialogEx(playerid, DIALOG_RNAMED, 0, DIALOG_STYLE_INPUT, "{4B05FC}Destroy Computer", "Type name of owner", "Destroy", "Cancel"), TDC(playerid);
    return 1;
}
stock reditc(playerid, const params[]) {
    new pfile[64];
    new cfile[64];
    new pid;
    format(pfile, 64, plfolder, params);
    pid = dini_Int(pfile, "PCID");
    format(cfile, 128, cofolder, pid);

    if(fexist(pfile)) {
        if(!IsPlayerInRangeOfPoint(playerid, disfcom * 2, ComputerInfo[pid][cX], ComputerInfo[pid][cY], ComputerInfo[pid][cZ])) return YNC(playerid);
        EditObject(playerid, ComputerInfo[pid][cObject]);
    } else ShowPlayerDialogEx(playerid, DIALOG_RNAMEE, 0, DIALOG_STYLE_INPUT, "{4B05FC}Edit Computer", "Type name of owner", "Edit", "Cancel"), TDC(playerid);
    return 1;
}
stock rgotoc(playerid, const params[]) {
    new pfile[64];
    new cfile[64];
    new pid;
    format(pfile, 64, plfolder, params);
    pid = dini_Int(pfile, "PCID");
    format(cfile, 128, cofolder, pid);

    if(fexist(pfile)) {
        if(!IsPlayerInAnyVehicle(playerid)) SetPlayerPos(playerid, ComputerInfo[pid][cX], ComputerInfo[pid][cY], ComputerInfo[pid][cZ] + 2);
        else SetVehiclePosEx(GetPlayerVehicleID(playerid), ComputerInfo[pid][cX], ComputerInfo[pid][cY], ComputerInfo[pid][cZ] + 2);
    } else ShowPlayerDialogEx(playerid, DIALOG_RNAMEG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Goto Computer", "Type name of owner", "Goto", "Cancel"), TDC(playerid);
    return 1;
}
stock getco(playerid, const params[]) {
    new pfile[64];
    new cfile[64];
    new pid;
    format(pfile, 64, plfolder, params);
    pid = dini_Int(pfile, "PCID");
    format(cfile, 128, cofolder, pid);

    new Float:pPos[4];
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    GetPlayerFacingAngle(playerid, pPos[3]);

    pPos[0] += (disfcom * floatsin(-pPos[3], degrees));
    pPos[1] += (disfcom * floatcos(-pPos[3], degrees));

    if(fexist(pfile)) {
        if(!IsPlayerInAnyVehicle(playerid)) {
            SetObjectPos(ComputerInfo[pid][cObject], pPos[0], pPos[1], pPos[2] - 1.1);
            SetObjectRot(ComputerInfo[pid][cObject], 0, 0, pPos[3] - 90.0);
            EditObject(playerid, ComputerInfo[pid][cObject]);
        } else return YTV(playerid);
    } else ShowPlayerDialogEx(playerid, DIALOG_RNAMEGG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Get Computer", "Type name of owner", "Get", "Cancel"), TDC(playerid);
    return 1;
}

stock buycom(playerid) {
    if(PlayerInfo[playerid][haveone]) return YAO(playerid);
    if(GetPlayerAdminLevel(playerid) == 10) {} else {
        if(GetPlayerMoney(playerid) < computercost) return NEM(playerid);
        GivePlayerCash(playerid, -computercost);
    }
    if(IsPlayerInAnyVehicle(playerid))
        return YTV(playerid);

    new Float:pPos[4];
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    GetPlayerFacingAngle(playerid, pPos[3]);

    pPos[0] += (disfcom * floatsin(-pPos[3], degrees));
    pPos[1] += (disfcom * floatcos(-pPos[3], degrees));

    CreateComputer(playerid, pPos[0], pPos[1], pPos[2] - 1.1, pPos[3] - 90.0);

    return 1;
}
stock editcomplace(playerid) {
    if(!PlayerInfo[playerid][haveone]) return YDC(playerid);
    if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) {
        EditObject(playerid, ComputerInfo[PlayerInfo[playerid][computer]][cObject]);
    } else YNTY(playerid);
    return 1;
}
stock sellcom(playerid) {
    if(!PlayerInfo[playerid][haveone]) return YDC(playerid);
    if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer]) && GetPlayerAdminLevel(playerid) == 10) {} else if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) {
        GivePlayerCash(playerid, computercost - 1);
    }
    if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) {
        DestroyObject(ComputerInfo[PlayerInfo[playerid][computer]][cObject]), ComputerInfo[PlayerInfo[playerid][computer]][cZ] += 1000;
        Delete3DTextLabel(computer_ctext[PlayerInfo[playerid][computer]]);
        removecomputer(playerid);
        PlayerInfo[playerid][haveone] = false;

    } else YNTY(playerid);
    return 1;
}
stock rsellcom(playerid) {
    if(!PlayerInfo[playerid][haveone]) return YDC(playerid);
    DestroyObject(ComputerInfo[PlayerInfo[playerid][computer]][cObject]), ComputerInfo[PlayerInfo[playerid][computer]][cZ] += 1000;
    Delete3DTextLabel(computer_ctext[PlayerInfo[playerid][computer]]);
    removecomputer(playerid);
    PlayerInfo[playerid][haveone] = false;
    return 1;
}

stock removecomputer(playerid) {
    removecom(PlayerInfo[playerid][computer]);
    ComputerInfo[PlayerInfo[playerid][computer]][cCreated] = false;
}
stock gpscom(playerid) {
    if(!PlayerInfo[playerid][haveone]) return YDC(playerid);
    if(!IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) {
        SetPlayerCheckpoint(playerid, ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ], disfcom);
    } else YCTY(playerid);
    return 1;
}
stock lockunlock(playerid) {
    new file[64];
    format(file, 64, cofolder, PlayerInfo[playerid][computer]);
    if(!PlayerInfo[playerid][haveone]) return YDC(playerid);
    if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) {
        if(ComputerInfo[PlayerInfo[playerid][computer]][Locked]) ComputerInfo[PlayerInfo[playerid][computer]][Locked] = false, YNTRR(playerid), dini_IntSet(file, "Locked", false);
        else ComputerInfo[PlayerInfo[playerid][computer]][Locked] = true, YNTRT(playerid), dini_IntSet(file, "Locked", true);
        refleshclabel(PlayerInfo[playerid][computer]);
    } else YNTY(playerid);
    return 1;
}

stock removecom(comid) {
    new file2[64];
    format(file2, 64, cofolder, comid);

    new file[64];
    format(file, 64, plfolder, dini_Get(file2, "cOwner"));

    if(fexist(file2)) dini_Remove(file2);
    if(fexist(file)) dini_Remove(file);

}
#define fspeed 3.000
stock CreateComputer(playerid, Float:x, Float:y, Float:z, Float:a) {
    loopco {

        new file[64];
        format(file, 64, cofolder, i);
        if(!fexist(file)) {
            ComputerInfo[i][cObject] = CreateObject(COMPUTER_OBJECT, x, y, z, 0, 0, a);

            format(ComputerInfo[i][cOwner], 24, "%s", Computer_PlayerName(playerid));
            ComputerInfo[i][Locked] = false;
            ComputerInfo[i][cX] = x;
            ComputerInfo[i][cY] = y;
            ComputerInfo[i][cZ] = z;
            ComputerInfo[i][cA] = a;
            //=================================Computer Info===========================
            dini_Create(file);
            dini_IntSet(file, "Computer_ID", i);
            dini_IntSet(file, "Locked", false);
            dini_FloatSet(file, "X", ComputerInfo[i][cX]);
            dini_FloatSet(file, "Y", ComputerInfo[i][cY]);
            dini_FloatSet(file, "Z", ComputerInfo[i][cZ]);
            dini_FloatSet(file, "A0", ComputerInfo[i][cA0]);
            dini_FloatSet(file, "A1", ComputerInfo[i][cA1]);
            dini_FloatSet(file, "A", ComputerInfo[i][cA]);
            dini_Set(file, "cOwner", ComputerInfo[i][cOwner]);
            EditObject(playerid, ComputerInfo[i][cObject]);
            ComputerInfo[i][cCreated] = true;
            //========================================================================
            //============================Player Info=================================
            new file2[64];
            format(file2, 64, plfolder, Computer_PlayerName(playerid));
            dini_Create(file2);
            dini_IntSet(file2, "PCID", i);
            dini_IntSet(file2, "LANG", ENG);
            dini_IntSet(file2, "Like", false);
            dini_FloatSet(file2, "KSPEED", fspeed);
            dini_FloatSet(file2, "DAMAGE", 1.000);
            dini_IntSet(file2, "HEADSHOT", 0);
            dini_IntSet(file2, "ZMONEY", 0);
            dini_IntSet(file2, "ZBUY", 1);
            dini_IntSet(file2, "ZSCORE", 0);
            PlayerInfo[playerid][computer] = i;
            PlayerInfo[playerid][like] = false;
            PlayerInfo[playerid][haveone] = true;
            PlayerInfo[playerid][kspeed] = fspeed;
            PlayerInfo[playerid][com_damage] = 1.000;
            PlayerInfo[playerid][headshot] = 0;
            PlayerInfo[playerid][zmoney] = 0;
            PlayerInfo[playerid][zbuy] = 1;
            PlayerInfo[playerid][zscore] = 0;
            //========================================================================
            createclabel(i);
            break;
        }
    }
}

hook OnPlayerDisconnect(playerid, reason) {
    if(IsPlayerNPC(playerid)) return 1;
    savedata(playerid);
    return 1;
}
savedata(playerid) {
    shutdown(playerid);

    new file2[64];
    format(file2, 64, plfolder, Computer_PlayerName(playerid));
    dini_IntSet(file2, "LANG", PlayerInfo[playerid][lang]);
    dini_IntSet(file2, "LIKE", PlayerInfo[playerid][like]);
    dini_FloatSet(file2, "KSPEED", PlayerInfo[playerid][kspeed]);
    dini_FloatSet(file2, "DAMAGE", PlayerInfo[playerid][com_damage]);
    dini_IntSet(file2, "HEADSHOT", PlayerInfo[playerid][headshot]);
    dini_IntSet(file2, "ZMONEY", PlayerInfo[playerid][zmoney]);
    dini_IntSet(file2, "ZBUY", PlayerInfo[playerid][zbuy]);
    dini_IntSet(file2, "ZSCORE", PlayerInfo[playerid][zscore]);
}
loaddata(playerid) {
    new file2[64];
    format(file2, 64, plfolder, Computer_PlayerName(playerid));

    if(fexist(file2)) {
        PlayerInfo[playerid][haveone] = true;
        PlayerInfo[playerid][computer] = dini_Int(file2, "PCID");
        PlayerInfo[playerid][lang] = dini_Int(file2, "LANG");
        PlayerInfo[playerid][like] = dini_Int(file2, "LIKE");
        PlayerInfo[playerid][kspeed] = dini_Float(file2, "KSPEED");
        PlayerInfo[playerid][com_damage] = dini_Int(file2, "DAMAGE");
        PlayerInfo[playerid][zmoney] = dini_Int(file2, "ZMONEY");
        PlayerInfo[playerid][zbuy] = dini_Int(file2, "ZBUY");
        PlayerInfo[playerid][zscore] = dini_Int(file2, "ZSCORE");
        PlayerInfo[playerid][headshot] = dini_Int(file2, "HEADSHOT");
    } else {
        PlayerInfo[playerid][computer] = -1;
        PlayerInfo[playerid][haveone] = false;
        PlayerInfo[playerid][like] = false;
        PlayerInfo[playerid][com_damage] = 1.000;
        PlayerInfo[playerid][zbuy] = 1;
    }
    PlayerInfo[playerid][Computer_selected] = -1;
    // barre doutil dettail
    databarre[0] = CreatePlayerTextDraw(playerid, 524.000000, 407.750000, "");
    PlayerTextDrawLetterSize(playerid, databarre[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, databarre[0], 4.500000, 4.666625);
    PlayerTextDrawAlignment(playerid, databarre[0], 1);
    PlayerTextDrawColor(playerid, databarre[0], -1);
    PlayerTextDrawSetShadow(playerid, databarre[0], 0);
    PlayerTextDrawSetOutline(playerid, databarre[0], 0);
    PlayerTextDrawFont(playerid, databarre[0], 4);
    databarre[1] = CreatePlayerTextDraw(playerid, 603.000000, 398.416687, "");
    PlayerTextDrawLetterSize(playerid, databarre[1], 0.180500, 0.829999);
    PlayerTextDrawAlignment(playerid, databarre[1], 1);
    PlayerTextDrawColor(playerid, databarre[1], -1);
    PlayerTextDrawSetShadow(playerid, databarre[1], 0);
    PlayerTextDrawSetOutline(playerid, databarre[1], 0);
    PlayerTextDrawBackgroundColor(playerid, databarre[1], 51);
    PlayerTextDrawFont(playerid, databarre[1], 2);
    PlayerTextDrawSetProportional(playerid, databarre[1], 1);
    databarre[2] = CreatePlayerTextDraw(playerid, 594.000000, 407.166625, "");
    PlayerTextDrawLetterSize(playerid, databarre[2], 0.196000, 1.016666);
    PlayerTextDrawAlignment(playerid, databarre[2], 1);
    PlayerTextDrawColor(playerid, databarre[2], -1);
    PlayerTextDrawSetShadow(playerid, databarre[2], 0);
    PlayerTextDrawSetOutline(playerid, databarre[2], 0);
    PlayerTextDrawBackgroundColor(playerid, databarre[2], 51);
    PlayerTextDrawFont(playerid, databarre[2], 1);
    PlayerTextDrawSetProportional(playerid, databarre[2], 1);
    databarre[3] = CreatePlayerTextDraw(playerid, 568.000000, 401.916625, "ENG");
    PlayerTextDrawLetterSize(playerid, databarre[3], 0.180500, 1.366665);
    PlayerTextDrawAlignment(playerid, databarre[3], 1);
    PlayerTextDrawColor(playerid, databarre[3], -1);
    PlayerTextDrawSetShadow(playerid, databarre[3], 0);
    PlayerTextDrawSetOutline(playerid, databarre[3], 0);
    PlayerTextDrawBackgroundColor(playerid, databarre[3], 51);
    PlayerTextDrawFont(playerid, databarre[3], 2);
    PlayerTextDrawSetProportional(playerid, databarre[3], 1);
    databarre[4] = CreatePlayerTextDraw(playerid, 538.500000, 408.333496, "I");
    PlayerTextDrawLetterSize(playerid, databarre[4], 0.431000, 0.456665);
    PlayerTextDrawAlignment(playerid, databarre[4], 1);
    PlayerTextDrawColor(playerid, databarre[4], -1);
    PlayerTextDrawSetShadow(playerid, databarre[4], 0);
    PlayerTextDrawSetOutline(playerid, databarre[4], 1);
    PlayerTextDrawBackgroundColor(playerid, databarre[4], 51);
    PlayerTextDrawFont(playerid, databarre[4], 2);
    PlayerTextDrawSetProportional(playerid, databarre[4], 1);
    databarre[5] = CreatePlayerTextDraw(playerid, 541.000000, 405.833465, "I");
    PlayerTextDrawLetterSize(playerid, databarre[5], 0.433500, 0.765832);
    PlayerTextDrawAlignment(playerid, databarre[5], 1);
    PlayerTextDrawColor(playerid, databarre[5], -1);
    PlayerTextDrawSetShadow(playerid, databarre[5], 0);
    PlayerTextDrawSetOutline(playerid, databarre[5], 1);
    PlayerTextDrawBackgroundColor(playerid, databarre[5], 51);
    PlayerTextDrawFont(playerid, databarre[5], 2);
    PlayerTextDrawSetProportional(playerid, databarre[5], 1);
    databarre[6] = CreatePlayerTextDraw(playerid, 543.500000, 403.916748, "I");
    PlayerTextDrawLetterSize(playerid, databarre[6], 0.433500, 0.999165);
    PlayerTextDrawAlignment(playerid, databarre[6], 1);
    PlayerTextDrawColor(playerid, databarre[6], -1);
    PlayerTextDrawSetShadow(playerid, databarre[6], 0);
    PlayerTextDrawSetOutline(playerid, databarre[6], 1);
    PlayerTextDrawBackgroundColor(playerid, databarre[6], 51);
    PlayerTextDrawFont(playerid, databarre[6], 2);
    PlayerTextDrawSetProportional(playerid, databarre[6], 1);
    databarre[7] = CreatePlayerTextDraw(playerid, 546.000000, 402.000030, "I");
    PlayerTextDrawLetterSize(playerid, databarre[7], 0.437000, 1.261665);
    PlayerTextDrawAlignment(playerid, databarre[7], 1);
    PlayerTextDrawColor(playerid, databarre[7], -1);
    PlayerTextDrawSetShadow(playerid, databarre[7], 0);
    PlayerTextDrawSetOutline(playerid, databarre[7], 1);
    PlayerTextDrawBackgroundColor(playerid, databarre[7], 51);
    PlayerTextDrawFont(playerid, databarre[7], 2);
    PlayerTextDrawSetProportional(playerid, databarre[7], 1);
    databarre[8] = CreatePlayerTextDraw(playerid, 548.500000, 399.500000, "I");
    PlayerTextDrawLetterSize(playerid, databarre[8], 0.437000, 1.594167);
    PlayerTextDrawAlignment(playerid, databarre[8], 1);
    PlayerTextDrawColor(playerid, databarre[8], -1);
    PlayerTextDrawSetShadow(playerid, databarre[8], 0);
    PlayerTextDrawSetOutline(playerid, databarre[8], 1);
    PlayerTextDrawBackgroundColor(playerid, databarre[8], 51);
    PlayerTextDrawFont(playerid, databarre[8], 2);
    PlayerTextDrawSetProportional(playerid, databarre[8], 1);
    databarre[9] = CreatePlayerTextDraw(playerid, 524.000000, 407.750000, "hud:radar_centre");
    PlayerTextDrawLetterSize(playerid, databarre[9], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, databarre[9], 4.500000, 4.666625);
    PlayerTextDrawAlignment(playerid, databarre[9], 1);
    PlayerTextDrawColor(playerid, databarre[9], -1);
    PlayerTextDrawSetShadow(playerid, databarre[9], 0);
    PlayerTextDrawSetOutline(playerid, databarre[9], 0);
    PlayerTextDrawFont(playerid, databarre[9], 4);

    // MAP2
    map2 = CreatePlayerTextDraw(playerid, 468.000000, 212.916641, "Maroc");
    PlayerTextDrawLetterSize(playerid, map2, 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, map2, 2);
    PlayerTextDrawColor(playerid, map2, 255);
    PlayerTextDrawSetShadow(playerid, map2, 0);
    PlayerTextDrawSetOutline(playerid, map2, 1);
    PlayerTextDrawBackgroundColor(playerid, map2, 16777215);
    PlayerTextDrawFont(playerid, map2, 2);
    PlayerTextDrawSetProportional(playerid, map2, 1);
    //load
    explo2 = CreatePlayerTextDraw(playerid, 177.500000, 160.416610, "ld_dual:power");
    PlayerTextDrawLetterSize(playerid, explo2, 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, explo2, 5.000000, 30.333383);
    PlayerTextDrawAlignment(playerid, explo2, 1);
    PlayerTextDrawColor(playerid, explo2, -1);
    PlayerTextDrawSetShadow(playerid, explo2, 0);
    PlayerTextDrawSetOutline(playerid, explo2, 0);
    PlayerTextDrawFont(playerid, explo2, 4);
    fronl = CreatePlayerTextDraw(playerid, 566.000000, 373.916564, "friends");
    PlayerTextDrawLetterSize(playerid, fronl, 0.352499, 1.296666);
    PlayerTextDrawAlignment(playerid, fronl, 1);
    PlayerTextDrawColor(playerid, fronl, 255);
    PlayerTextDrawSetShadow(playerid, fronl, 0);
    PlayerTextDrawSetOutline(playerid, fronl, 0);
    PlayerTextDrawBackgroundColor(playerid, fronl, 51);
    PlayerTextDrawFont(playerid, fronl, 1);
    PlayerTextDrawSetProportional(playerid, fronl, 1);
    // Stop Play
    musicsp = CreatePlayerTextDraw(playerid, 452.500000, 317.333312, "II");
    PlayerTextDrawLetterSize(playerid, musicsp, 0.645000, 3.157499);
    PlayerTextDrawAlignment(playerid, musicsp, 1);
    PlayerTextDrawColor(playerid, musicsp, -1);
    PlayerTextDrawSetShadow(playerid, musicsp, 0);
    PlayerTextDrawSetOutline(playerid, musicsp, 1);
    PlayerTextDrawBackgroundColor(playerid, musicsp, 255);
    PlayerTextDrawFont(playerid, musicsp, 1);
    PlayerTextDrawSetProportional(playerid, musicsp, 1);
    // Player SuperBall barre
    createpb(playerid);
    // Right left
    rightleft[0] = CreatePlayerTextDraw(playerid, 600.500000, 329.583312, "ld_beat:right");
    PlayerTextDrawLetterSize(playerid, rightleft[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, rightleft[0], 23.000000, 23.333374);
    PlayerTextDrawAlignment(playerid, rightleft[0], 1);
    PlayerTextDrawColor(playerid, rightleft[0], -65281);
    PlayerTextDrawSetShadow(playerid, rightleft[0], 0);
    PlayerTextDrawSetOutline(playerid, rightleft[0], 0);
    PlayerTextDrawFont(playerid, rightleft[0], 4);
    rightleft[1] = CreatePlayerTextDraw(playerid, 577.000000, 329.416656, "ld_beat:left");
    PlayerTextDrawLetterSize(playerid, rightleft[1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, rightleft[1], 23.000000, 23.333374);
    PlayerTextDrawAlignment(playerid, rightleft[1], 1);
    PlayerTextDrawColor(playerid, rightleft[1], -65281);
    PlayerTextDrawSetShadow(playerid, rightleft[1], 0);
    PlayerTextDrawSetOutline(playerid, rightleft[1], 0);
    PlayerTextDrawFont(playerid, rightleft[1], 4);
    // Create 14 yajora
    create14yajora(playerid);
    // Score Text Draw
    tdscore = CreatePlayerTextDraw(playerid, 364.500000, 328.416534, "Score: 0");
    PlayerTextDrawLetterSize(playerid, tdscore, 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, tdscore, 1);
    PlayerTextDrawColor(playerid, tdscore, 255);
    PlayerTextDrawSetShadow(playerid, tdscore, 0);
    PlayerTextDrawSetOutline(playerid, tdscore, 1);
    PlayerTextDrawBackgroundColor(playerid, tdscore, 16777215);
    PlayerTextDrawFont(playerid, tdscore, 1);
    PlayerTextDrawSetProportional(playerid, tdscore, 1);
    // Facebook Name
    fbname = CreatePlayerTextDraw(playerid, 501.500000, 48.416671, "123123123123123123123");
    PlayerTextDrawLetterSize(playerid, fbname, 0.108500, 0.923332);
    PlayerTextDrawAlignment(playerid, fbname, 1);
    PlayerTextDrawColor(playerid, fbname, -1);
    PlayerTextDrawSetShadow(playerid, fbname, 0);
    PlayerTextDrawSetOutline(playerid, fbname, 0);
    PlayerTextDrawBackgroundColor(playerid, fbname, 51);
    PlayerTextDrawFont(playerid, fbname, 1);
    PlayerTextDrawSetProportional(playerid, fbname, 1);
    // traduire===========================================
    tdchange[0] = CreatePlayerTextDraw(playerid, 163.500000, 375.666778, "Shut_Down");
    PlayerTextDrawLetterSize(playerid, tdchange[0], 0.195500, 1.389999);
    PlayerTextDrawTextSize(playerid, tdchange[0], -1.000000, -59.499977);
    PlayerTextDrawAlignment(playerid, tdchange[0], 2);
    PlayerTextDrawColor(playerid, tdchange[0], -1);
    PlayerTextDrawUseBox(playerid, tdchange[0], true);
    PlayerTextDrawBoxColor(playerid, tdchange[0], 2228223);
    PlayerTextDrawSetShadow(playerid, tdchange[0], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[0], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[0], 255);
    PlayerTextDrawFont(playerid, tdchange[0], 2);
    PlayerTextDrawSetProportional(playerid, tdchange[0], 1);
    tdchange[1] = CreatePlayerTextDraw(playerid, 501.500000, 83.416687, "Added image");
    PlayerTextDrawLetterSize(playerid, tdchange[1], 0.295000, 0.911665);
    PlayerTextDrawAlignment(playerid, tdchange[1], 1);
    PlayerTextDrawColor(playerid, tdchange[1], -1);
    PlayerTextDrawSetShadow(playerid, tdchange[1], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[1], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[1], 51);
    PlayerTextDrawFont(playerid, tdchange[1], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[1], 1);
    tdchange[2] = CreatePlayerTextDraw(playerid, 337.000000, 285.833404, "Like  Comment  Share");
    PlayerTextDrawLetterSize(playerid, tdchange[2], 0.301500, 1.343333);
    PlayerTextDrawAlignment(playerid, tdchange[2], 1);
    PlayerTextDrawColor(playerid, tdchange[2], -1);
    PlayerTextDrawSetShadow(playerid, tdchange[2], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[2], 1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[2], 51);
    PlayerTextDrawFont(playerid, tdchange[2], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[2], 1);
    tdchange[3] = CreatePlayerTextDraw(playerid, 408.500000, 23.916660, "Your Place");
    PlayerTextDrawLetterSize(playerid, tdchange[3], 0.670000, 3.244999);
    PlayerTextDrawAlignment(playerid, tdchange[3], 1);
    PlayerTextDrawColor(playerid, tdchange[3], 16711935);
    PlayerTextDrawSetShadow(playerid, tdchange[3], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[3], 2);
    PlayerTextDrawBackgroundColor(playerid, tdchange[3], 255);
    PlayerTextDrawFont(playerid, tdchange[3], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[3], 1);
    tdchange[4] = CreatePlayerTextDraw(playerid, 44.500000, 204.583389, "Music");
    PlayerTextDrawLetterSize(playerid, tdchange[4], 0.373500, 1.354999);
    PlayerTextDrawAlignment(playerid, tdchange[4], 1);
    PlayerTextDrawColor(playerid, tdchange[4], 16777215);
    PlayerTextDrawSetShadow(playerid, tdchange[4], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[4], -1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[4], 255);
    PlayerTextDrawFont(playerid, tdchange[4], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[4], 1);
    tdchange[5] = CreatePlayerTextDraw(playerid, 46.000000, 176.166732, "MAP");
    PlayerTextDrawLetterSize(playerid, tdchange[5], 0.373500, 1.354999);
    PlayerTextDrawAlignment(playerid, tdchange[5], 1);
    PlayerTextDrawColor(playerid, tdchange[5], 16777215);
    PlayerTextDrawSetShadow(playerid, tdchange[5], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[5], -1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[5], 255);
    PlayerTextDrawFont(playerid, tdchange[5], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[5], 1);
    tdchange[6] = CreatePlayerTextDraw(playerid, 628.000000, 30.916690, "5arita~n~~n~~n~~n~Mzika~n~~n~~n~~n~Superball~n~~n~~n~~n~facebook~n~~n~~n~~n~Zombies");
    PlayerTextDrawLetterSize(playerid, tdchange[6], 0.146500, 1.500834);
    PlayerTextDrawAlignment(playerid, tdchange[6], 2);
    PlayerTextDrawColor(playerid, tdchange[6], -1);
    PlayerTextDrawSetShadow(playerid, tdchange[6], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[6], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[6], 51);
    PlayerTextDrawFont(playerid, tdchange[6], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[6], 1);

    tdchange[7] = CreatePlayerTextDraw(playerid, 330.000000, 5.833383, "ERROR");
    PlayerTextDrawLetterSize(playerid, tdchange[7], 0.262499, 1.051666);
    PlayerTextDrawAlignment(playerid, tdchange[7], 1);
    PlayerTextDrawColor(playerid, tdchange[7], 255);
    PlayerTextDrawSetShadow(playerid, tdchange[7], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[7], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[7], 51);
    PlayerTextDrawFont(playerid, tdchange[7], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[7], 1);
    tdchange[8] = CreatePlayerTextDraw(playerid, 327.500000, 41.416667, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, tdchange[8], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, tdchange[8], 308.000000, 61.249988);
    PlayerTextDrawAlignment(playerid, tdchange[8], 1);
    PlayerTextDrawColor(playerid, tdchange[8], -16777147);
    PlayerTextDrawSetShadow(playerid, tdchange[8], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[8], 0);
    PlayerTextDrawFont(playerid, tdchange[8], 4);
    tdchange[9] = CreatePlayerTextDraw(playerid, 439.500000, 60.083316, "! ERROR !");
    PlayerTextDrawLetterSize(playerid, tdchange[9], 0.581500, 2.119167);
    PlayerTextDrawAlignment(playerid, tdchange[9], 1);
    PlayerTextDrawColor(playerid, tdchange[9], -1);
    PlayerTextDrawSetShadow(playerid, tdchange[9], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[9], 1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[9], 51);
    PlayerTextDrawFont(playerid, tdchange[9], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[9], 1);
    tdchange[10] = CreatePlayerTextDraw(playerid, 394.500000, 93.333404, "You must have an account");
    PlayerTextDrawLetterSize(playerid, tdchange[10], 0.332500, 1.010833);
    PlayerTextDrawAlignment(playerid, tdchange[10], 1);
    PlayerTextDrawColor(playerid, tdchange[10], -16776961);
    PlayerTextDrawSetShadow(playerid, tdchange[10], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[10], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[10], 51);
    PlayerTextDrawFont(playerid, tdchange[10], 2);
    PlayerTextDrawSetProportional(playerid, tdchange[10], 1);
    tdchange[11] = CreatePlayerTextDraw(playerid, 327.000000, 102.666671, "ld_chat:badchat");
    PlayerTextDrawLetterSize(playerid, tdchange[11], 0.026999, 0.233333);
    PlayerTextDrawTextSize(playerid, tdchange[11], 309.000000, 289.333404);
    PlayerTextDrawAlignment(playerid, tdchange[11], 1);
    PlayerTextDrawColor(playerid, tdchange[11], -1378294201);
    PlayerTextDrawSetShadow(playerid, tdchange[11], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[11], 0);
    PlayerTextDrawFont(playerid, tdchange[11], 4);
    tdchange[12] = CreatePlayerTextDraw(playerid, 343.000000, 131.833221, "How do I make an account ?");
    PlayerTextDrawLetterSize(playerid, tdchange[12], 0.294999, 1.518333);
    PlayerTextDrawAlignment(playerid, tdchange[12], 1);
    PlayerTextDrawColor(playerid, tdchange[12], 255);
    PlayerTextDrawSetShadow(playerid, tdchange[12], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[12], 1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[12], 51);
    PlayerTextDrawFont(playerid, tdchange[12], 2);
    PlayerTextDrawSetProportional(playerid, tdchange[12], 1);
    tdchange[13] = CreatePlayerTextDraw(playerid, 327.000000, 158.666671, "its easy You must buy computer");
    PlayerTextDrawLetterSize(playerid, tdchange[13], 0.294999, 1.518333);
    PlayerTextDrawAlignment(playerid, tdchange[13], 1);
    PlayerTextDrawColor(playerid, tdchange[13], 65535);
    PlayerTextDrawSetShadow(playerid, tdchange[13], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[13], 0);
    PlayerTextDrawBackgroundColor(playerid, tdchange[13], 51);
    PlayerTextDrawFont(playerid, tdchange[13], 2);
    PlayerTextDrawSetProportional(playerid, tdchange[13], 1);
    tdchange[14] = CreatePlayerTextDraw(playerid, 294.000000, 282.916687, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, tdchange[14], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, tdchange[14], 319.500000, 88.083312);
    PlayerTextDrawAlignment(playerid, tdchange[14], 1);
    PlayerTextDrawColor(playerid, tdchange[14], -16776970);
    PlayerTextDrawSetShadow(playerid, tdchange[14], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[14], 0);
    PlayerTextDrawFont(playerid, tdchange[14], 4);
    tdchange[15] = CreatePlayerTextDraw(playerid, 456.000000, 279.416442, "ERROR~n~You must to have an account~n~to create an account you must buy a computer");
    PlayerTextDrawLetterSize(playerid, tdchange[15], 0.221500, 1.506666);
    PlayerTextDrawAlignment(playerid, tdchange[15], 2);
    PlayerTextDrawColor(playerid, tdchange[15], -1);
    PlayerTextDrawSetShadow(playerid, tdchange[15], 0);
    PlayerTextDrawSetOutline(playerid, tdchange[15], 1);
    PlayerTextDrawBackgroundColor(playerid, tdchange[15], 51);
    PlayerTextDrawFont(playerid, tdchange[15], 1);
    PlayerTextDrawSetProportional(playerid, tdchange[15], 1);

    numlike = CreatePlayerTextDraw(playerid, 336.000000, 302.750030, "");
    PlayerTextDrawLetterSize(playerid, numlike, 0.220499, 0.940831);
    PlayerTextDrawAlignment(playerid, numlike, 1);
    PlayerTextDrawColor(playerid, numlike, 65535);
    PlayerTextDrawSetShadow(playerid, numlike, 0);
    PlayerTextDrawSetOutline(playerid, numlike, 0);
    PlayerTextDrawBackgroundColor(playerid, numlike, 51);
    PlayerTextDrawFont(playerid, numlike, 1);
    PlayerTextDrawSetProportional(playerid, numlike, 1);
    Zombiesgg[0] = CreatePlayerTextDraw(playerid, 562.500000, 271.333374, "hud:radar_gangN");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[0], 16.500000, 18.083351);
    PlayerTextDrawAlignment(playerid, Zombiesgg[0], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[0], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[0], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[0], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[0], 4);

    Zombiesgg[1] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] - 10.5, PlayerInfo[playerid][nY] - 12.25, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[1], 11.500000, 13.416671);
    PlayerTextDrawAlignment(playerid, Zombiesgg[1], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[1], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[1], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[1], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[1], 4);
    Zombiesgg[2] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] + 12.5, PlayerInfo[playerid][nY] - 12.416626, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[2], -11.500000, 13.416670);
    PlayerTextDrawAlignment(playerid, Zombiesgg[2], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[2], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[2], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[2], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[2], 4);
    Zombiesgg[3] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] + 12.5, PlayerInfo[playerid][nY] + 14.250122, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[3], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[3], -11.500000, -13.416661);
    PlayerTextDrawAlignment(playerid, Zombiesgg[3], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[3], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[3], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[3], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[3], 4);
    Zombiesgg[4] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] - 10.5, PlayerInfo[playerid][nY] + 14.083435, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[4], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[4], 11.500000, -13.416665);
    PlayerTextDrawAlignment(playerid, Zombiesgg[4], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[4], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[4], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[4], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[4], 4);

    Zombiesgg[5] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX], PlayerInfo[playerid][nY], "ld_pool:ball");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[5], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[5], 2.000000, 2.333333);
    PlayerTextDrawAlignment(playerid, Zombiesgg[5], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[5], 255);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[5], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[5], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[5], 4);

    Zombiesgg[6] = CreatePlayerTextDraw(playerid, 567.000000, 276.500000, "hud:radar_ammugun");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[6], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[6], -7.500000, 8.166687);
    PlayerTextDrawAlignment(playerid, Zombiesgg[6], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[6], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[6], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[6], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[6], 4);
    Zombiesgg[7] = CreatePlayerTextDraw(playerid, 559.500000, 275.333435, "ld_shtr:nmef");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[7], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[7], -12.000000, 7.583341);
    PlayerTextDrawAlignment(playerid, Zombiesgg[7], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[7], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[7], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[7], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[7], 4);

    Zombiesgg[8] = CreatePlayerTextDraw(playerid, 503.500000, 140.583389, "999999999999 ~n~_~n~~g~999999999999");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[8], 0.226499, 1.705000);
    PlayerTextDrawAlignment(playerid, Zombiesgg[8], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[8], 255);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[8], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[8], 1);
    PlayerTextDrawBackgroundColor(playerid, Zombiesgg[8], 16777215);
    PlayerTextDrawFont(playerid, Zombiesgg[8], 3);
    PlayerTextDrawSetProportional(playerid, Zombiesgg[8], 1);
    Zombiesgg[9] = CreatePlayerTextDraw(playerid, 485.000000, 134.749984, "ld_poke:cd9s");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[9], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[9], 101.500000, 57.750000);
    PlayerTextDrawAlignment(playerid, Zombiesgg[9], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[9], 230);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[9], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[9], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[9], 4);
    Zombiesgg[10] = CreatePlayerTextDraw(playerid, 490.000000, 175.000015, "hud:radar_cash");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[10], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[10], 10.500000, 12.250000);
    PlayerTextDrawAlignment(playerid, Zombiesgg[10], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[10], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[10], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[10], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[10], 4);
    Zombiesgg[11] = CreatePlayerTextDraw(playerid, 490.000000, 158.500030, "hud:radar_SWEET");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[11], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[11], 10.500000, 12.250000);
    PlayerTextDrawAlignment(playerid, Zombiesgg[11], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[11], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[11], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[11], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[11], 4);
    Zombiesgg[12] = CreatePlayerTextDraw(playerid, 489.500000, 142.333343, "hud:radar_LocoSyndicate");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[12], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[12], 11.500000, 12.833353);
    PlayerTextDrawAlignment(playerid, Zombiesgg[12], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[12], -1);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[12], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[12], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[12], 4);

    createzombie(playerid);

    pzmenu[0] = CreatePlayerTextDraw(playerid, 199.000000, 189.416625, "ld_dual:power");
    PlayerTextDrawLetterSize(playerid, pzmenu[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pzmenu[0], 283.000000, 8.166680);
    PlayerTextDrawAlignment(playerid, pzmenu[0], 1);
    PlayerTextDrawColor(playerid, pzmenu[0], -1);
    PlayerTextDrawSetShadow(playerid, pzmenu[0], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[0], 0);
    PlayerTextDrawFont(playerid, pzmenu[0], 4);
    pzmenu[1] = CreatePlayerTextDraw(playerid, 314.500000, 184.916641, "100%");
    PlayerTextDrawLetterSize(playerid, pzmenu[1], 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, pzmenu[1], 1);
    PlayerTextDrawColor(playerid, pzmenu[1], -16776961);
    PlayerTextDrawSetShadow(playerid, pzmenu[1], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[1], 0);
    PlayerTextDrawBackgroundColor(playerid, pzmenu[1], 51);
    PlayerTextDrawFont(playerid, pzmenu[1], 2);
    PlayerTextDrawSetProportional(playerid, pzmenu[1], 1);
    pzmenu[2] = CreatePlayerTextDraw(playerid, 449.000000, 206.499893, "500$");
    PlayerTextDrawLetterSize(playerid, pzmenu[2], 0.304000, 1.185833);
    PlayerTextDrawAlignment(playerid, pzmenu[2], 2);
    PlayerTextDrawColor(playerid, pzmenu[2], 255);
    PlayerTextDrawSetShadow(playerid, pzmenu[2], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[2], 1);
    PlayerTextDrawBackgroundColor(playerid, pzmenu[2], 16777215);
    PlayerTextDrawFont(playerid, pzmenu[2], 1);
    PlayerTextDrawSetProportional(playerid, pzmenu[2], 1);
    pzmenu[3] = CreatePlayerTextDraw(playerid, 481.500000, 334.250061, "hud:radar_cash");
    PlayerTextDrawLetterSize(playerid, pzmenu[3], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pzmenu[3], 16.000000, 17.499998);
    PlayerTextDrawAlignment(playerid, pzmenu[3], 1);
    PlayerTextDrawColor(playerid, pzmenu[3], -1);
    PlayerTextDrawSetShadow(playerid, pzmenu[3], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[3], 0);
    PlayerTextDrawFont(playerid, pzmenu[3], 4);
    pzmenu[4] = CreatePlayerTextDraw(playerid, 482.000000, 335.999938, "90000000000");
    PlayerTextDrawLetterSize(playerid, pzmenu[4], 0.449999, 1.600000);
    PlayerTextDrawAlignment(playerid, pzmenu[4], 3);
    PlayerTextDrawColor(playerid, pzmenu[4], 8388863);
    PlayerTextDrawSetShadow(playerid, pzmenu[4], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[4], 1);
    PlayerTextDrawBackgroundColor(playerid, pzmenu[4], 255);
    PlayerTextDrawFont(playerid, pzmenu[4], 1);
    PlayerTextDrawSetProportional(playerid, pzmenu[4], 1);
    pzmenu[5] = CreatePlayerTextDraw(playerid, 177.500000, 334.250274, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, pzmenu[5], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pzmenu[5], 318.500000, 18.083343);
    PlayerTextDrawAlignment(playerid, pzmenu[5], 1);
    PlayerTextDrawColor(playerid, pzmenu[5], -233);
    PlayerTextDrawSetShadow(playerid, pzmenu[5], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[5], 0);
    PlayerTextDrawFont(playerid, pzmenu[5], 4);
    pzmenu[6] = CreatePlayerTextDraw(playerid, 176.000000, 332.333343, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, pzmenu[6], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pzmenu[6], 321.500000, 18.666688);
    PlayerTextDrawAlignment(playerid, pzmenu[6], 1);
    PlayerTextDrawColor(playerid, pzmenu[6], -233);
    PlayerTextDrawSetShadow(playerid, pzmenu[6], 0);
    PlayerTextDrawSetOutline(playerid, pzmenu[6], 0);
    PlayerTextDrawFont(playerid, pzmenu[6], 4);
}
#define plX 562.500000
#define plY 271.333374

hook OnPlayerLogin(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    PlayerInfo[playerid][nX] = 111.000000;
    PlayerInfo[playerid][nY] = 271.250000;
    loaddata(playerid);
    return 1;
}
create14yajora(playerid) {
    PlayerInfo[playerid][yX] = 362.500000 - 17.5;
    for (new i = 0; i < 15; i++) {
        yajora[i] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][yX] += 17.5, 112.583335, "ld_otb2:butnBo");
        PlayerTextDrawLetterSize(playerid, yajora[i], 0.000000, 0.000000);
        PlayerTextDrawTextSize(playerid, yajora[i], 17.000000, 11.083328);
        PlayerTextDrawAlignment(playerid, yajora[i], 1);
        PlayerTextDrawColor(playerid, yajora[i], -1);
        PlayerTextDrawSetShadow(playerid, yajora[i], 0);
        PlayerTextDrawSetOutline(playerid, yajora[i], 0);
        PlayerTextDrawFont(playerid, yajora[i], 4);
        Yjinfo[playerid][i][yjX] = PlayerInfo[playerid][yX];
    }
}

hook OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ) {
    new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
    GetObjectPos(objectid, oldX, oldY, oldZ);
    GetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

    if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL) {
        loopco {

            if(objectid == ComputerInfo[i][cObject]) {
                new file[64];
                format(file, 64, cofolder, i);
                dini_FloatSet(file, "X", fX);
                dini_FloatSet(file, "Y", fY);
                dini_FloatSet(file, "Z", fZ);
                dini_IntSet(file, "Locked", ComputerInfo[i][Locked]);
                dini_FloatSet(file, "A0", fRotX);
                dini_FloatSet(file, "A1", fRotY);
                dini_FloatSet(file, "A", fRotZ);

                ComputerInfo[i][cX] = fX;
                ComputerInfo[i][cY] = fY;
                ComputerInfo[i][cZ] = fZ;
                ComputerInfo[i][cA0] = fRotX;
                ComputerInfo[i][cA1] = fRotY;
                ComputerInfo[i][cA] = fRotZ;

                DestroyObject(ComputerInfo[i][cObject]);
                ComputerInfo[i][cObject] = CreateObject(COMPUTER_OBJECT, fX, fY, fZ, fRotX, fRotY, fRotZ);
                Delete3DTextLabel(computer_ctext[i]);
                createclabel(i);
                break;
            }
        }

    }

}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if(dialogid == DIALOG_COMPUTERHELP) {

        if(!response) return 1;
        switch (listitem) {

            case 0:{
                buycom(playerid);
            }
            case 1:{
                editcomplace(playerid);
            }
            case 2:{
                sellcom(playerid);
            }
            case 3:{
                gpscom(playerid);
            }
            case 4:{
                lockunlock(playerid);
            }
            case 5:{
                if(GetPlayerAdminLevel(playerid) != 10) return pc_cmd_computer(playerid, ""), YNR(playerid);
                else rconlist(playerid);
            }

        }

    }
    if(dialogid == DIALOG_RCONL) {

        if(!response) return pc_cmd_computer(playerid, "");
        switch (listitem) {

            case 0:{
                ShowPlayerDialogEx(playerid, DIALOG_RNAMED, 0, DIALOG_STYLE_INPUT, "{4B05FC}Destroy Computer", "Type name of owner", "Destroy", "Cancel");
            }
            case 1:{
                ShowPlayerDialogEx(playerid, DIALOG_RNAMEE, 0, DIALOG_STYLE_INPUT, "{4B05FC}Edit Computer Place", "Type name of owner", "Edit", "Cancel");
            }
            case 2:{
                ShowPlayerDialogEx(playerid, DIALOG_RNAMEG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Goto Computer", "Type name of owner", "Goto", "Cancel");
            }
            case 3:{
                ShowPlayerDialogEx(playerid, DIALOG_RNAMEGG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Get Computer", "Type name of owner", "Get", "Cancel");
            }

        }

    }
    if(dialogid == DIALOG_PLIST) {

        if(!response) return PlayerInfo[playerid][Computer_selected] = -1, PlayerInfo[playerid][showpl] = false;
        switch (listitem) {

            default:{

                PlayerInfo[playerid][showpl] = true;
                new match = -1;
                new file[64];
                format(file, 64, plfolder, Computer_PlayerName(playerid));
                for (new i = 0; i < MAX_PLAYERS; i++) {
                    if(!IsPlayerConnected(i) || i == playerid) continue;
                    match++;
                    if(match == listitem) {
                        if(!PlayerInfo[i][sshowfb]) return TNO(playerid), ShowMsgPlayer(playerid);
                        PlayerInfo[playerid][Computer_selected] = i;
                        PlayerInfo[i][Computer_selected] = playerid;
                        ShowPlayerDialogEx(playerid, DIALOG_Sendm, 0, DIALOG_STYLE_INPUT, Computer_PlayerName(i), "Type Your Message Here", "Send", "Back");
                    }
                }

            }

        }

    }
    if(dialogid == DIALOG_Sendm) {
        format(PlayerInfo[playerid][chat1], 128, "{03FFEE}%s{03FF81}: {03FF24}%s\n", Computer_PlayerName(playerid), inputtext);
        format(PlayerInfo[PlayerInfo[playerid][Computer_selected]][chat1], 128, "{03FFEE}%s{03FF81}: {03FF24}%s\n", Computer_PlayerName(playerid), inputtext);
        if(!response) ShowMsgPlayer(playerid);
        else {
            if(!PlayerInfo[PlayerInfo[playerid][Computer_selected]][sshowfb]) return TNO(playerid);
            ShowPlayerDialogEx(PlayerInfo[playerid][Computer_selected], DIALOG_Sendm, 0, DIALOG_STYLE_INPUT, Computer_PlayerName(playerid), PlayerInfo[playerid][chat1], "Send", "Back");
            ShowPlayerDialogEx(playerid, DIALOG_Sendm, 0, DIALOG_STYLE_INPUT, Computer_PlayerName(PlayerInfo[playerid][Computer_selected]), PlayerInfo[PlayerInfo[playerid][Computer_selected]][chat1], "Send", "Back");
            PlayerInfo[playerid][showpl] = false;
            SendFBmsg(playerid, PlayerInfo[playerid][chat1]);
            SendFBmsg(PlayerInfo[playerid][Computer_selected], PlayerInfo[playerid][chat1]);
        }
    }
    if(dialogid == DIALOG_RNAMED) {
        if(!response) return rconlist(playerid);
        if(GetPlayerAdminLevel(playerid) != 10) return pc_cmd_computer(playerid, "");
        if(!strlen(inputtext))
            return ShowPlayerDialogEx(playerid, DIALOG_RNAMED, 0, DIALOG_STYLE_INPUT, "{4B05FC}Destroy Computer", "Type name of owner", "Destroy", "Cancel");
        destroy(playerid, inputtext);

    }
    if(dialogid == DIALOG_RNAMEE) {
        if(!response) return rconlist(playerid);
        if(GetPlayerAdminLevel(playerid) != 10) return pc_cmd_computer(playerid, "");
        if(!strlen(inputtext))
            return ShowPlayerDialogEx(playerid, DIALOG_RNAMEE, 0, DIALOG_STYLE_INPUT, "{4B05FC}Edit Computer place", "Type name of owner", "Edit", "Cancel");
        reditc(playerid, inputtext);

    }
    if(dialogid == DIALOG_RNAMEG) {
        if(!response) return rconlist(playerid);
        if(GetPlayerAdminLevel(playerid) != 10) return pc_cmd_computer(playerid, "");
        if(!strlen(inputtext))
            return ShowPlayerDialogEx(playerid, DIALOG_RNAMEG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Goto Computer", "Type name of owner", "Goto", "Cancel"), TDC(playerid);
        rgotoc(playerid, inputtext);

    }
    if(dialogid == DIALOG_RNAMEGG) {
        if(!response) return rconlist(playerid);
        if(GetPlayerAdminLevel(playerid) != 10) return pc_cmd_computer(playerid, "");
        if(!strlen(inputtext))
            return ShowPlayerDialogEx(playerid, DIALOG_RNAMEGG, 0, DIALOG_STYLE_INPUT, "{4B05FC}Get Computer", "Type name of owner", "Get", "Cancel"), TDC(playerid);
        getco(playerid, inputtext);

    }
    return 1;
}

IsPlayerCloseToComputer(playerid, comid) {

    if(IsPlayerInRangeOfPoint(playerid, disfcom, ComputerInfo[comid][cX], ComputerInfo[comid][cY], ComputerInfo[comid][cZ])) return true;
    if(!IsPlayerInRangeOfPoint(playerid, disfcom, ComputerInfo[comid][cX], ComputerInfo[comid][cY], ComputerInfo[comid][cZ])) return false;
    return 1;
}

hook OnPlayerEnterCP(playerid) {

    DisablePlayerCheckpoint(playerid);
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if(PlayerInfo[playerid][usecom] && !PlayerInfo[playerid][playh] && !PlayerInfo[playerid][Zombiesshow]) SelectTextDraw(playerid, 0xA3B4C5FF);
    if(!PlayerInfo[playerid][usecom] && IsPlayerCloseToAnyComputer(playerid)) GameTextForPlayer(playerid, "~w~Click ~r~N ~w~To Start.", 1000, 4);
    //=================Friends=====================//
    GetTotalOnline(playerid);
    return 1;
}

IsballInArea(playerid) {
    if(PlayerInfo[playerid][pbY] > PlayerInfo[playerid][bY] - 10.00 && PlayerInfo[playerid][bX] + 25.000 > PlayerInfo[playerid][pbX] > PlayerInfo[playerid][bX] - 10.5000) {
        if(PlayerInfo[playerid][bspeed] < ballspeed + 2.8) PlayerInfo[playerid][bspeed] += 0.19;
        PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
        return 1;
    }
    return 0;
}
IsballInyajora(playerid) {
    for (new i = 0; i < 15; i++) {
        if(106.750022 < PlayerInfo[playerid][pbY] <= 118.416633 && Yjinfo[playerid][i][yjX] + 16.000 > PlayerInfo[playerid][pbX] > Yjinfo[playerid][i][yjX] - 6.0000 && !Yjinfo[playerid][i][destroyed]) {
            PlayerTextDrawHide(playerid, yajora[i]);
            if(PlayerInfo[playerid][bt7t]) { PlayerInfo[playerid][bdown] = true, PlayerInfo[playerid][bup] = false; } else { PlayerInfo[playerid][bdown] = false, PlayerInfo[playerid][bup] = true; }
            Yjinfo[playerid][i][destroyed] = true;
            PlayerInfo[playerid][pcount] += 1;
            PlayerInfo[playerid][phscore] += 1;
            if(PlayerInfo[playerid][pcount] == 15) {
                hideSuperBall(playerid);
                PlayerInfo[playerid][playh] = false;
                MWIN(playerid);
            }
            new string[128];
            format(string, sizeof(string), "Score: %d", PlayerInfo[playerid][phscore]);
            PlayerTextDrawSetString(playerid, tdscore, string);
            PlayerPlaySound(playerid, 1135, 0.0, 0.0, 0.0);
        }
    }
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys == KEY_NO) {
        if(!PlayerInfo[playerid][usecom] && IsPlayerCloseToAnyComputer(playerid)) {
            StarComp(playerid);
            return ~1;
        }
    } else if(newkeys == KEY_SPRINT) {
        if(PlayerInfo[playerid][playh]) {
            hideSuperBall(playerid);
            PlayerInfo[playerid][playh] = false;
            return ~1;
        }
    }
    if(newkeys == KEY_FIRE && OnHeadShot(playerid) && PlayerInfo[playerid][Zombiesshow]) PlayerPlaySound(playerid, 1136, 0.0, 0.0, 0.0);
    if(newkeys == KEY_FIRE && OnBodyShot(playerid) && PlayerInfo[playerid][Zombiesshow]) PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
    return 1;
}
stock StarComp(playerid) {
    TogglePlayerControllable(playerid, false);
    SetPlayerCameraPos(playerid, -1707.1427, 856.1968, 23.1014);
    SetPlayerCameraLookAt(playerid, -1707.2754, 855.2012, 19.9688);
    showfonddec(playerid);
    showbarre(playerid);
    showwinico(playerid);
    if(!PlayerInfo[playerid][timework]) Time[playerid] = SetTimerEx("TRTR", 50, 1, "d", playerid), PlayerInfo[playerid][timework] = true;

}
#define pzcost PlayerInfo[playerid][zbuy]*133

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {
    if(clickedid == winico[0][computer_id]) { if(PlayerInfo[playerid][menushow]) { hidemenu(playerid); } else if(!PlayerInfo[playerid][menushow]) { showmenu(playerid); } }
    if(clickedid == boxlike) {
        // facebook like===========================

        if(!PlayerInfo[playerid][like]) {
            fblike += 1;
            PlayerInfo[playerid][like] = true;
        } else fblike -= 1, PlayerInfo[playerid][like] = false;

        new file2[64];
        format(file2, 64, plfolder, Computer_PlayerName(playerid));
        dini_IntSet(file2, "LIKE", PlayerInfo[playerid][like]);
        dini_IntSet(fbfolder, "likes", fblike);
    }
    //=======================================
    if(clickedid == tdlang[5]) tarjm(playerid, ENG);
    if(clickedid == tdlang[6]) tarjm(playerid, FRA);
    if(clickedid == tdlang[7]) tarjm(playerid, DAR);

    //Shut Down===================================
    if(clickedid == menu[8]) { shutdown(playerid); }
    //============================================
    //=======================================Show Hide================
    if(clickedid == menu[4] || clickedid == map[5] || clickedid == fonddec[10]) {
        hidepgzmenu(playerid), hidezmenu(playerid);
        hidelang(playerid);
        hidefbd(playerid);
        hidemusic(playerid);
        hideSuperBall(playerid);
        if(PlayerInfo[playerid][mapshow]) { hidemap(playerid); } else if(!PlayerInfo[playerid][mapshow]) { showmap(playerid), hidemenu(playerid); }
    }
    if(clickedid == menu[6] || clickedid == music[4] || clickedid == fonddec[11]) {
        hidepgzmenu(playerid), hidezmenu(playerid);
        hidelang(playerid);
        hidefbd(playerid);
        hidemap(playerid);
        hideSuperBall(playerid);
        if(PlayerInfo[playerid][musicshow]) { hidemusic(playerid), SetStop(playerid); } else if(!PlayerInfo[playerid][musicshow]) { showmusic(playerid), hidemenu(playerid); }
    }
    if(clickedid == music[32]) {
        hidelang(playerid);
        hidemap(playerid);
        hidefbd(playerid);
        hideSuperBall(playerid);
        if(PlayerInfo[playerid][musicshow]) { hidemusic(playerid); } else if(!PlayerInfo[playerid][musicshow]) { showmusic(playerid), hidemenu(playerid); }
    }
    if(clickedid == menu[11] || clickedid == SuperBall[5] || clickedid == fonddec[12]) {
        hidepgzmenu(playerid), hidezmenu(playerid);
        hidelang(playerid);
        hidemap(playerid);
        hidemusic(playerid);
        hidefbd(playerid);
        if(PlayerInfo[playerid][SuperBallshow]) { hideSuperBall(playerid); } else if(!PlayerInfo[playerid][SuperBallshow]) { showSuperBall(playerid), hidemenu(playerid); }
    }
    if(clickedid == menu[20] || clickedid == fonddec[17]) {
        hidepgzmenu(playerid), hidezmenu(playerid);
        hideSuperBall(playerid);
        hidelang(playerid);
        hidemap(playerid);
        hidemusic(playerid);
        hidefbd(playerid);
        if(PlayerInfo[playerid][Zombiesshow]) { hideZombies(playerid); } else if(!PlayerInfo[playerid][Zombiesshow]) { showZombies(playerid); }
    }
    if(clickedid == menu[16] || clickedid == onglet[6] || clickedid == onglet[15] || clickedid == fonddec[15]) {
        hidepgzmenu(playerid), hidezmenu(playerid);
        hidelang(playerid);
        hidemusic(playerid);
        hideSuperBall(playerid);
        hidemap(playerid);
        if(PlayerInfo[playerid][ongletshow]) { hideonglet(playerid), hidefbd(playerid); } else if(!PlayerInfo[playerid][ongletshow]) { showonglet(playerid), showfbd(playerid), hidemenu(playerid); }
    }
    //=================FaceBook========================================//
    if(clickedid == fbdata[23])
        if(!PlayerInfo[playerid][notifshow]) { shownotif(playerid); } else { hidenotif(playerid); }
    if(clickedid == fbdata[20]) ShowAllPlayer(playerid);
    if(clickedid == fbdata[25] || clickedid == fbdata[18]) ShowMsgPlayer(playerid);
    //===================" > _ ||"====================================
    if(clickedid == music[10]) spmusic(playerid);
    if(clickedid == music[14]) editmpos(playerid, -1);
    else if(clickedid == music[15]) editmpos(playerid, 1);
    //========================= Musics ==============================
    if(clickedid == music[34]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 5.500, musicplace(playerid);
    if(clickedid == music[35]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 4.500, musicplace(playerid);
    if(clickedid == music[36]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 3.500, musicplace(playerid);
    if(clickedid == music[37]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 2.500, musicplace(playerid);
    if(clickedid == music[38]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 1.500, musicplace(playerid);
    if(clickedid == music[39]) PlayerInfo[playerid][usemusic] = false, PlayerInfo[playerid][sound] = 0.000, musicplace(playerid);
    //========Zombie==================//
    if(clickedid == boxlang) {
        hidefbd(playerid);
        hidemusic(playerid);
        hideSuperBall(playerid);
        hidemap(playerid);
        if(PlayerInfo[playerid][langshow]) { hidelang(playerid); } else if(!PlayerInfo[playerid][langshow]) { showlang(playerid); }
    }
    if(clickedid == zmenu[12]) hidezmenu(playerid);
    if(clickedid == zmenu[8]) showZombies(playerid), hidezmenu(playerid);
    if(clickedid == zmenu[9]) showpgzmenu(playerid), hidezmenu(playerid);
    if(clickedid == gzmenu[10]) hidepgzmenu(playerid), Computer_showzmenu(playerid);
    if(clickedid == gzmenu[9]) {
        if(PlayerInfo[playerid][zmoney] < pzcost) return NEM(playerid);
        hidepgzmenu(playerid);
        PlayerInfo[playerid][zmoney] -= pzcost;
        PlayerInfo[playerid][zbuy] += 1;
        PlayerInfo[playerid][com_damage] += 1.00;
        showpgzmenu(playerid);
    }
    return 1;
}
stock createclabel(i) {
    new strring[128];
    if(ComputerInfo[i][Locked]) format(strring, sizeof(strring), "{4DFFBE}Owner : {F4FF21}%s\n{FF0000}Locked", ComputerInfo[i][cOwner]);
    else format(strring, sizeof(strring), "{4DFFBE}Owner : {F4FF21}%s\n{00FF26}Unocked", ComputerInfo[i][cOwner]);
    computer_ctext[i] = Create3DTextLabel(strring, 0x00FFFF, ComputerInfo[i][cX], ComputerInfo[i][cY], ComputerInfo[i][cZ] + 2, 30, 0);
}
stock refleshclabel(i) {
    Delete3DTextLabel(computer_ctext[i]);
    createclabel(i);
}
stock shutdown(playerid) {
    if(PlayerInfo[playerid][usecom]) {
        SetCameraBehindPlayer(playerid);
        if(PlayerInfo[playerid][usemusic]) StopAudioStreamForPlayer(playerid);
        if(PlayerInfo[playerid][timework]) KillTimer(Time[playerid]), PlayerInfo[playerid][timework] = false;
        PlayerInfo[playerid][sound] = 0.000;
        hideZombies(playerid);
        hidelang(playerid), hidefbd(playerid), hideonglet(playerid), hideSuperBall(playerid), hidemusic(playerid), hidewinico(playerid), hidemap(playerid), hidemenu(playerid), hidefonddec(playerid), hidebarre(playerid);
        TogglePlayerControllable(playerid, true);
    }
}

stock Computer_UpdateTime(i) {
    if(PlayerInfo[i][playh]) {
        if(PlayerInfo[i][hhealth] == 0) return PlayerInfo[i][playh] = false, hideSuperBall(i), MLOSE(i);

        if(PlayerInfo[i][pbY] < 107.333389) PlayerInfo[i][bfog] = true, PlayerInfo[i][bt7t] = false;
        else PlayerInfo[i][bt7t] = true, PlayerInfo[i][bfog] = false;

        if(PlayerInfo[i][pbY] <= 27.999982 + 5) PlayerInfo[i][bdown] = true, PlayerInfo[i][bup] = false, PlayerPlaySound(i, 1136, 0.0, 0.0, 0.0);
        else if(PlayerInfo[i][pbY] >= 316.166809 - 5) {
            PlayerInfo[i][bdown] = false, PlayerInfo[i][bup] = true;
            PlayerInfo[i][hhealth] -= 1;
            if(PlayerInfo[i][phscore] > 0) PlayerInfo[i][phscore] -= 1;
            TextDrawHideForPlayer(i, tdhealth[PlayerInfo[i][hhealth]]);
            PlayerPlaySound(i, 1148, 0.0, 0.0, 0.0);
            new string[128];
            format(string, sizeof(string), "Score: %d", PlayerInfo[i][phscore]);
            PlayerTextDrawSetString(i, tdscore, string);
        }

        if(PlayerInfo[i][pbX] <= 361.50) PlayerInfo[i][bright] = true, PlayerInfo[i][bleft] = false, PlayerInfo[i][pbX] += PlayerInfo[i][bspeed], PlayerPlaySound(i, 1136, 0.0, 0.0, 0.0);
        else if(PlayerInfo[i][pbX] >= 625.000 - 5) PlayerInfo[i][bright] = false, PlayerInfo[i][bleft] = true, PlayerInfo[i][pbX] -= PlayerInfo[i][bspeed], PlayerPlaySound(i, 1136, 0.0, 0.0, 0.0);

        if(IsballInArea(i) && PlayerInfo[i][pleft] && PlayerInfo[i][bnone]) PlayerInfo[i][bdown] = false, PlayerInfo[i][bup] = true, PlayerInfo[i][bleft] = true, PlayerInfo[i][bright] = false;
        else if(IsballInArea(i) && PlayerInfo[i][pright] && PlayerInfo[i][bnone]) PlayerInfo[i][bdown] = false, PlayerInfo[i][bup] = true, PlayerInfo[i][bleft] = false, PlayerInfo[i][bright] = true;
        else if(IsballInArea(i)) PlayerInfo[i][bdown] = false, PlayerInfo[i][bup] = true;

        if(PlayerInfo[i][bup]) { PlayerInfo[i][pbY] -= PlayerInfo[i][bspeed]; } else if(PlayerInfo[i][bdown]) { PlayerInfo[i][pbY] += PlayerInfo[i][bspeed]; }

        if(PlayerInfo[i][bright] && !PlayerInfo[i][bleft]) { PlayerInfo[i][pbX] += PlayerInfo[i][bspeed]; } else if(PlayerInfo[i][bleft] && !PlayerInfo[i][bright]) { PlayerInfo[i][pbX] -= PlayerInfo[i][bspeed]; }

        refleshballbar(i);

        new KEYS, UD, LR;
        GetPlayerKeys(i, KEYS, UD, LR);

        PlayerTextDrawHide(i, rightleft[0]);
        PlayerTextDrawHide(i, rightleft[1]);
        if(LR == KEY_RIGHT) {
            movepbarre(i, barrespeed, 0);
            PlayerInfo[i][pright] = true;
            PlayerInfo[i][pleft] = false;
            PlayerTextDrawColor(i, rightleft[0], -65281);
            PlayerTextDrawColor(i, rightleft[1], -1);
        } else if(LR == KEY_LEFT) {
            movepbarre(i, -barrespeed, 0);
            PlayerInfo[i][pleft] = true;
            PlayerInfo[i][pright] = false;
            PlayerTextDrawColor(i, rightleft[1], -65281);
            PlayerTextDrawColor(i, rightleft[0], -1);
        }
        PlayerTextDrawShow(i, rightleft[0]);
        PlayerTextDrawShow(i, rightleft[1]);
        IsballInyajora(i);

    }
    if(PlayerInfo[i][Zombiesshow]) {

        new KEYS, UD, LR;
        GetPlayerKeys(i, KEYS, UD, LR);
        if(UD == KEY_UP) { PlayerInfo[i][nY] -= PlayerInfo[i][kspeed]; } else if(UD == KEY_DOWN) { PlayerInfo[i][nY] += PlayerInfo[i][kspeed]; }
        if(LR == KEY_LEFT) { PlayerInfo[i][nX] -= PlayerInfo[i][kspeed]; } else if(LR == KEY_RIGHT) { PlayerInfo[i][nX] += PlayerInfo[i][kspeed]; }
        IsNinA(i);
        refleshallzombie(i);
    }
    if(PlayerInfo[i][usecom]) {
        tarjm(i, PlayerInfo[i][lang]);
        new Hour, Minute, Second;
        gettime(Hour, Minute, Second);
        new str1[64];
        format(str1, sizeof(str1), "%02d:%02d", Hour, Minute);
        PlayerTextDrawSetString(i, databarre[1], str1);

        new Year, Month, Day;
        getdate(Year, Month, Day);
        new str2[64];
        format(str2, sizeof(str2), "%02d/%02d/%02d", Day, Month, Year);
        PlayerTextDrawSetString(i, databarre[2], str2);

        //================WIFI=========================//

        for (new p = 4; p < 9; p++) { PlayerTextDrawHide(i, databarre[p]); }
        if(Computer_IsPlayerInArea(i, 44.60, -2892.90, 2997.00, -768.00)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -1); //  //LS
        if(Computer_IsPlayerInArea(i, 869.40, 596.30, 2997.00, 2993.80)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -1); // //LV
        if(Computer_IsPlayerInArea(i, -2997.40, -1115.50, -1213.90, 1659.60)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -1); // //SanFierro
        if(Computer_IsPlayerInArea(i, -480.50, 596.30, 869.40, 2993.80)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); // //BoneCounty
        if(Computer_IsPlayerInArea(i, -1213.90, 596.30, -480.50, 1659.60)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); // //TierraRobada
        if(Computer_IsPlayerInArea(i, -1213.90, -768.00, 2997.00, 596.30)) PlayerTextDrawColor(i, databarre[3 + 3], -1), PlayerTextDrawColor(i, databarre[4 + 3], -1), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); // //RedCountry
        if(Computer_IsPlayerInArea(i, -2997.40, 1659.60, -480.50, 2993.80)) PlayerTextDrawColor(i, databarre[3 + 3], -2139062017), PlayerTextDrawColor(i, databarre[4 + 3], -2139062017), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); //TierraRobada
        if(Computer_IsPlayerInArea(i, -1213.90, -2892.90, 44.60, -768.00)) PlayerTextDrawColor(i, databarre[3 + 3], -2139062017), PlayerTextDrawColor(i, databarre[4 + 3], -2139062017), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); //FlintCounty
        if(Computer_IsPlayerInArea(i, -2997.40, -2892.90, -1213.90, -1115.50)) PlayerTextDrawColor(i, databarre[3 + 3], -2139062017), PlayerTextDrawColor(i, databarre[4 + 3], -2139062017), PlayerTextDrawColor(i, databarre[5 + 3], -2139062017); //Whetstone

        for (new p = 4; p < 9; p++) { PlayerTextDrawShow(i, databarre[p]); }
        Computer_GetPlayerZone(i);
    }
    return 1;
}
refleshallzombie(playerid) {
    loopz {
        refleshzombie(playerid, i);
    }
}
Computer_IsPlayerInArea(playerid, Float:Computer_MinX, Float:Computer_MinY, Float:Computer_MaxX, Float:Computer_MaxY) {
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    if(X >= Computer_MinX && X <= Computer_MaxX && Y >= Computer_MinY && Y <= Computer_MaxY) {
        return 1;
    }
    return 0;
}
//////////////Computer_PlayerName//////////////
Computer_PlayerName(playerid) {
    new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    return pname;
}
//////////////Show SuperBall////////////////
stock showSuperBall(playerid) {

    if(!PlayerInfo[playerid][SuperBallshow]) {
        PlayerInfo[playerid][phscore] = 0;
        PlayerPlaySound(playerid, 1062, 0.0, 0.0, 0.0);
        new string[128];
        format(string, sizeof(string), "Score: %d", PlayerInfo[playerid][phscore]);
        PlayerTextDrawSetString(playerid, tdscore, string);

        for (new i = 0; i < 15; i++) {
            PlayerTextDrawShow(playerid, yajora[i]);
            Yjinfo[playerid][i][destroyed] = false;
        }

        PlayerInfo[playerid][pcount] = 0;
        PlayerInfo[playerid][hhealth] = 3;

        PlayerInfo[playerid][pbX] = 492.500000;
        PlayerInfo[playerid][pbY] = 278.250091;
        PlayerTextDrawShow(playerid, pball), PlayerTextDrawHide(playerid, pball);

        PlayerTextDrawDestroy(playerid, pbarr[0]);
        PlayerTextDrawDestroy(playerid, pbarr[1]);
        PlayerTextDrawDestroy(playerid, pbarr[2]);
        createpb(playerid);
        PlayerTextDrawShow(playerid, pbarr[0]);
        PlayerTextDrawShow(playerid, pbarr[1]);
        PlayerTextDrawShow(playerid, pbarr[2]);

        PlayerInfo[playerid][bspeed] = ballspeed + 2.8;
        PlayerInfo[playerid][bup] = true;
        PlayerInfo[playerid][bdown] = false;
        PlayerInfo[playerid][bleft] = false;
        PlayerInfo[playerid][bright] = false;
        PlayerInfo[playerid][bnone] = true;

        PlayerTextDrawColor(playerid, rightleft[0], -1);
        PlayerTextDrawColor(playerid, rightleft[1], -1);

        PlayerInfo[playerid][bX] = 487.500000;
        PlayerInfo[playerid][bY] = 284.083374 + 30.0;

        PlayerTextDrawShow(playerid, rightleft[0]);
        PlayerTextDrawShow(playerid, rightleft[1]);

        PlayerTextDrawShow(playerid, tdscore);

        for (new i = 0; i < USED_SuperBall; i++) { TextDrawShowForPlayer(playerid, SuperBall[i]); }

        TextDrawShowForPlayer(playerid, tdhealth[0]);
        TextDrawShowForPlayer(playerid, tdhealth[1]);
        TextDrawShowForPlayer(playerid, tdhealth[2]);
        PlayerTextDrawHide(playerid, tdchange[6]);

        pball = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][pbX], PlayerInfo[playerid][pbY], "ld_pool:ball");
        PlayerTextDrawLetterSize(playerid, pball, 0.000000, 0.000000);
        PlayerTextDrawTextSize(playerid, pball, 5.000000, 5.833312);
        PlayerTextDrawAlignment(playerid, pball, 1);
        PlayerTextDrawColor(playerid, pball, 16711935);
        PlayerTextDrawSetShadow(playerid, pball, 0);
        PlayerTextDrawSetOutline(playerid, pball, 0);
        PlayerTextDrawFont(playerid, pball, 4);
        showpbarre(playerid);
        CancelSelectTextDraw(playerid);
        PlayerInfo[playerid][SuperBallshow] = true;
    }
}
//////////////Hide SuperBall////////////////
stock hideSuperBall(playerid) {
    if(PlayerInfo[playerid][SuperBallshow]) {
        for (new i = 0; i < USED_SuperBall; i++) { TextDrawHideForPlayer(playerid, SuperBall[i]); }
        TextDrawHideForPlayer(playerid, tdhealth[0]);
        TextDrawHideForPlayer(playerid, tdhealth[1]);
        TextDrawHideForPlayer(playerid, tdhealth[2]);
        hidepbarre(playerid);
        PlayerInfo[playerid][pcount] = 0;
        PlayerTextDrawHide(playerid, rightleft[0]);
        PlayerTextDrawHide(playerid, rightleft[1]);

        PlayerTextDrawHide(playerid, tdscore);
        PlayerTextDrawDestroy(playerid, pball);
        PlayerInfo[playerid][SuperBallshow] = false;
        PlayerTextDrawShow(playerid, tdchange[6]);
        for (new i = 0; i < 15; i++) { PlayerTextDrawHide(playerid, yajora[i]); }
    }
    return 1;
}
//////////////Show Music////////////////
stock showmusic(playerid) {
    if(!PlayerInfo[playerid][musicshow]) {
        if(!PlayerInfo[playerid][haveone]) return YMHP(playerid);

        for (new i = 0; i < USED_music; i++) { TextDrawShowForPlayer(playerid, music[i]); }
        PlayerTextDrawShow(playerid, musicsp);
        SetStop(playerid);
        spmusic(playerid);
        PlayerInfo[playerid][musicshow] = true;
    }
    return 1;
}
/////////////Hide music//////////////////////
stock hidemusic(playerid) {
    if(PlayerInfo[playerid][musicshow]) {
        for (new i = 0; i < USED_music; i++) { TextDrawHideForPlayer(playerid, music[i]); }
        PlayerTextDrawHide(playerid, musicsp);
        PlayerInfo[playerid][musicshow] = false;
    }
}
/////////////Show Onglet////////////////
stock showonglet(playerid) {
    if(!PlayerInfo[playerid][ongletshow]) {
        for (new i = 0; i < USED_onglet; i++) { TextDrawShowForPlayer(playerid, onglet[i]); }
        PlayerTextDrawHide(playerid, tdchange[6]);
        PlayerInfo[playerid][ongletshow] = true;
    }
}
///////////////Show Notif////////////////
stock shownotif(playerid) {
    if(!PlayerInfo[playerid][notifshow]) {
        for (new i = 0; i < USED_fbn; i++) { TextDrawShowForPlayer(playerid, fbnotif[i]); }
        PlayerTextDrawShow(playerid, tdchange[1]);
        PlayerInfo[playerid][notifshow] = true;
    }
}
///////////////Hide Notif////////////////
stock hidenotif(playerid) {
    if(PlayerInfo[playerid][notifshow]) {
        for (new i = 0; i < USED_fbn; i++) { TextDrawHideForPlayer(playerid, fbnotif[i]); }
        PlayerTextDrawHide(playerid, tdchange[1]);
        PlayerInfo[playerid][notifshow] = false;
    }
}
/////////////Show fbdata////////////////
stock showfbd(playerid) {
    if(!PlayerInfo[playerid][haveone]) return showerd(playerid);
    for (new i = 0; i < USED_fbd; i++) { TextDrawShowForPlayer(playerid, fbdata[i]); }
    TextDrawShowForPlayer(playerid, boxlike);
    PlayerTextDrawShow(playerid, numlike);
    PlayerTextDrawShow(playerid, fbname), PlayerTextDrawSetString(playerid, fbname, Computer_PlayerName(playerid));
    PlayerTextDrawShow(playerid, fronl);
    PlayerTextDrawShow(playerid, tdchange[2]);
    PlayerInfo[playerid][sshowfb] = true;
    return 1;
}
/////////////Show Error//////////////////
stock showerd(playerid) {
    if(!PlayerInfo[playerid][sshower]) {
        for (new i = 7; i < 14; i++) {
            PlayerTextDrawShow(playerid, tdchange[i]);
            PlayerInfo[playerid][sshower] = true;
        }
    }
    return 1;
}
stock hideerd(playerid) {
    if(PlayerInfo[playerid][sshower]) {
        for (new i = 7; i < 14; i++) {
            PlayerTextDrawHide(playerid, tdchange[i]);
            PlayerInfo[playerid][sshower] = false;
        }
    }
    return 1;
}
/////////////Hide fbdata////////////////
stock hidefbd(playerid) {
    hidenotif(playerid);
    hideonglet(playerid);
    for (new i = 0; i < USED_fbd; i++) {
        TextDrawHideForPlayer(playerid, fbdata[i]);
    }
    PlayerTextDrawHide(playerid, fbname);
    TextDrawHideForPlayer(playerid, boxlike);
    PlayerTextDrawHide(playerid, numlike);
    PlayerTextDrawHide(playerid, fronl);
    PlayerTextDrawHide(playerid, tdchange[2]);
    PlayerInfo[playerid][sshowfb] = false;
}
/////////////Hide Onglet////////////////
stock hideonglet(playerid) {
    if(PlayerInfo[playerid][ongletshow]) {
        for (new i = 0; i < USED_onglet; i++) { TextDrawHideForPlayer(playerid, onglet[i]); }
        PlayerTextDrawShow(playerid, tdchange[6]);
        hideerd(playerid);
        PlayerInfo[playerid][ongletshow] = false;
    }
}
/////////////Show lang//////////////////
stock showlang(playerid) {
    if(!PlayerInfo[playerid][langshow]) {
        for (new i = 0; i < USED_lang; i++) { TextDrawShowForPlayer(playerid, tdlang[i]); }
        PlayerInfo[playerid][langshow] = true;
    }
}
/////////////Hide lang//////////////////
stock hidelang(playerid) {
    if(PlayerInfo[playerid][langshow]) {
        for (new i = 0; i < USED_lang; i++) { TextDrawHideForPlayer(playerid, tdlang[i]); }
        PlayerInfo[playerid][langshow] = false;
    }
}
/////////////Show Menu//////////////////
stock showmenu(playerid) {
    if(!PlayerInfo[playerid][menushow]) {
        for (new i = 0; i < USED_menu; i++) { TextDrawShowForPlayer(playerid, menu[i]); }
        PlayerTextDrawShow(playerid, tdchange[0]);
        PlayerTextDrawShow(playerid, tdchange[4]);
        PlayerTextDrawShow(playerid, tdchange[5]);
        PlayerInfo[playerid][menushow] = true;
    }
}
/////////////Show ZMenu//////////////////
stock Computer_showzmenu(playerid) {
    if(!PlayerInfo[playerid][zmenushow]) {
        for (new i = 0; i < USED_zmenu; i++) {
            TextDrawShowForPlayer(playerid, zmenu[i]);
        }
        PlayerInfo[playerid][zmenushow] = true;
    }
    return 1;
}
/////////////Show ZMenu//////////////////
stock showpgzmenu(playerid) {
    if(!PlayerInfo[playerid][gpzmenushow]) {
        for (new i = 0; i < USED_pzmenu; i++) { PlayerTextDrawShow(playerid, pzmenu[i]); }
        for (new i = 0; i < USED_gzmenu; i++) { TextDrawShowForPlayer(playerid, gzmenu[i]); }

        PlayerTextDrawHide(playerid, pzmenu[0]);
        PlayerTextDrawTextSize(playerid, pzmenu[0], PlayerInfo[playerid][com_damage] * 283.000000 / 100, 8.166680);
        new string[128];
        format(string, sizeof(string), "%f%", PlayerInfo[playerid][com_damage]);
        PlayerTextDrawSetString(playerid, pzmenu[1], string);
        format(string, sizeof(string), "%d$", pzcost);
        PlayerTextDrawSetString(playerid, pzmenu[2], string);
        format(string, sizeof(string), "%d", PlayerInfo[playerid][zmoney]);
        PlayerTextDrawSetString(playerid, pzmenu[4], string);
        PlayerTextDrawShow(playerid, pzmenu[0]);

        PlayerInfo[playerid][gpzmenushow] = true;
    }
}

/////////////Hide ZMenu//////////////////
stock hidepgzmenu(playerid) {
    if(PlayerInfo[playerid][gpzmenushow]) {
        for (new i = 0; i < USED_pzmenu; i++) { PlayerTextDrawHide(playerid, pzmenu[i]); }
        for (new i = 0; i < USED_gzmenu; i++) { TextDrawHideForPlayer(playerid, gzmenu[i]); }
        PlayerInfo[playerid][gpzmenushow] = false;
    }
}
/////////////Hide ZMenu//////////////////
stock hidezmenu(playerid) {
    if(PlayerInfo[playerid][zmenushow]) {
        for (new i = 0; i < USED_zmenu; i++) { TextDrawHideForPlayer(playerid, zmenu[i]); }
        PlayerInfo[playerid][zmenushow] = false;
    }
}
/////////////Hide Menu//////////////////////
stock hidemenu(playerid) {
    if(PlayerInfo[playerid][menushow]) {
        for (new i = 0; i < USED_menu; i++) { TextDrawHideForPlayer(playerid, menu[i]); }
        PlayerTextDrawHide(playerid, tdchange[0]);
        PlayerTextDrawHide(playerid, tdchange[4]);
        PlayerTextDrawHide(playerid, tdchange[5]);
        PlayerInfo[playerid][menushow] = false;
    }
}
///////////// Show barre d�tail ////////////////////
stock showdatafonddec(playerid) {
    for (new i = 0; i < USED_databarre; i++) { PlayerTextDrawShow(playerid, databarre[i]); }
    TextDrawShowForPlayer(playerid, boxlang);
}
///////////// Hide barre d�tail ////////////////////
stock hidedatafonddec(playerid) {
    for (new i = 0; i < USED_databarre; i++) { PlayerTextDrawHide(playerid, databarre[i]); }
    TextDrawHideForPlayer(playerid, boxlang);
}
///////////// Show fond d'�cran ////////////////////
stock showfonddec(playerid) {
    if(!PlayerInfo[playerid][fondecshow]) {
        for (new i = 0; i < USED_fonddec; i++) { TextDrawShowForPlayer(playerid, fonddec[i]); }
        PlayerInfo[playerid][fondecshow] = true;
    }
}
//////////// Hide fond d'�cran /////////////////////
stock hidefonddec(playerid) {
    if(PlayerInfo[playerid][fondecshow]) {
        for (new i = 0; i < USED_fonddec; i++) { TextDrawHideForPlayer(playerid, fonddec[i]); }
        PlayerTextDrawHide(playerid, tdchange[6]);
        PlayerInfo[playerid][fondecshow] = false;
    }
}
/////////////Show barre doutil//////////////////////
stock showbarre(playerid) {
    if(!PlayerInfo[playerid][barreshow]) {
        TextDrawShowForPlayer(playerid, barre);
        PlayerInfo[playerid][barreshow] = true;
    }
    return 1;
}
/////////////Hide barre doutil///////////////////
stock hidebarre(playerid) {
    if(PlayerInfo[playerid][barreshow]) {
        TextDrawHideForPlayer(playerid, barre);
        hidedatafonddec(playerid);
        PlayerInfo[playerid][barreshow] = false;
    }
    return 1;
}
////////////Show win icon/////////////////////////
stock showwinico(playerid) { //600 USED_winico
    if(!PlayerInfo[playerid][winicoshow]) {
        TextDrawShowForPlayer(playerid, loadwin[0]);
        TextDrawShowForPlayer(playerid, loadwin[1]);
        TextDrawShowForPlayer(playerid, loadwin[2]);
        PlayerTextDrawTextSize(playerid, explo2, 5.000000, 30.333383);
        PlayerTextDrawShow(playerid, explo2);
        for (new i = 0; i < USED_winico; i++) {
            PlayerTextDrawHide(playerid, explo2);
            PlayerTextDrawTextSize(playerid, explo2, i * 313.000000 / USED_winico, 30.333383);
            PlayerTextDrawShow(playerid, explo2);
            TextDrawShowForPlayer(playerid, winico[i][computer_id]);
        }

        TextDrawHideForPlayer(playerid, loadwin[0]);
        TextDrawHideForPlayer(playerid, loadwin[1]);
        TextDrawHideForPlayer(playerid, loadwin[2]);
        PlayerTextDrawHide(playerid, explo2);
        PlayerTextDrawShow(playerid, tdchange[6]);

        SelectTextDraw(playerid, 0xA3B4C5FF);
        showdatafonddec(playerid);
        PlayerInfo[playerid][usecom] = true;
        PlayerInfo[playerid][winicoshow] = true;
    }
}
////////////Hide win icon////////////////////////
stock hidewinico(playerid) {
    if(PlayerInfo[playerid][winicoshow]) {
        PlayerInfo[playerid][winicoshow] = false;
        for (new i = 0; i < USED_winico; i++) { TextDrawHideForPlayer(playerid, winico[i][computer_id]); }
        CancelSelectTextDraw(playerid), PlayerInfo[playerid][usecom] = false;
    }
}
/////////Show MAP/////////////////////////
stock showmap(playerid) {

    if(!PlayerInfo[playerid][mapshow]) {
        for (new i = 0; i < USED_map; i++) { TextDrawShowForPlayer(playerid, map[i]); }
        PlayerTextDrawShow(playerid, map2);
        PlayerTextDrawHide(playerid, tdchange[6]);
        PlayerTextDrawShow(playerid, tdchange[3]);
        PlayerInfo[playerid][mapshow] = true;
    }
}
/////////Show Zombies/////////////////////////
stock showZombies(playerid) {
    if(!PlayerInfo[playerid][haveone]) return YMHP(playerid);
    if(!PlayerInfo[playerid][Zombiesshow]) {
        for (new i = 0; i < usedhg; i++) { TextDrawShowForPlayer(playerid, Zombiesg[i]); }
        CancelSelectTextDraw(playerid);
        for (new i = 0; i < usedhgg; i++) { PlayerTextDrawShow(playerid, Zombiesgg[i]); }
        if(!PlayerInfo[playerid][kidrob]) PlayerTextDrawHide(playerid, Zombiesgg[7]);
        PlayerInfo[playerid][Zombiesshow] = true;
        hidemenu(playerid);
        Time2[playerid] = SetTimerEx("GETZ", 1000, 1, "d", playerid);
    }
    return 1;
}
/////////Hide Zombies/////////////////////////
stock hideZombies(playerid) {
    if(PlayerInfo[playerid][Zombiesshow]) {
        for (new i = 0; i < usedhg; i++) { TextDrawHideForPlayer(playerid, Zombiesg[i]); }
        SelectTextDraw(playerid, 0xA3B4C5FF);
        for (new i = 0; i < usedhgg; i++) { PlayerTextDrawHide(playerid, Zombiesgg[i]); }
        if(!PlayerInfo[playerid][kidrob]) PlayerTextDrawHide(playerid, Zombiesgg[7]);
        PlayerInfo[playerid][Zombiesshow] = false;
        hideallzombies(playerid);
        KillTimer(Time2[playerid]);
    }
    return 1;
}
/////////Hide map///////////////////
stock hidemap(playerid) {
    if(PlayerInfo[playerid][mapshow]) {
        for (new i = 0; i < USED_map; i++) { TextDrawHideForPlayer(playerid, map[i]); }
        PlayerTextDrawHide(playerid, map2);
        PlayerTextDrawHide(playerid, tdchange[3]);
        PlayerTextDrawShow(playerid, tdchange[6]);
        PlayerInfo[playerid][mapshow] = false;
    }
}
// /////// Stop Play musi //////////
stock spmusic(playerid) {
    if(!PlayerInfo[playerid][usemusic]) setPlay(playerid);
    else SetStop(playerid);
}
stock setPlay(playerid) {
    musicplace(playerid);
    PlayerInfo[playerid][usemusic] = true;
    PlayerTextDrawSetString(playerid, musicsp, "II");
}
stock SetStop(playerid) {
    StopAudioStreamForPlayer(playerid);
    PlayerInfo[playerid][usemusic] = false;
    PlayerTextDrawSetString(playerid, musicsp, ">");
}
//////////Musics Pos //////////////
#define MAX_MUSICS 10
#define MIN_MUSICS -1
stock musicplace(playerid) {
    StopAudioStreamForPlayer(playerid);
    if(!PlayerInfo[playerid][usemusic]) {
        if(PlayerInfo[playerid][musicpos] == 0) { PlayAudioStreamForPlayer(playerid, "http://hitradio-maroc.ice.infomaniak.ch/hitradio-maroc-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 1) { PlayAudioStreamForPlayer(playerid, "http://dancefloor.ice.infomaniak.ch/dancefloor-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 2) { PlayAudioStreamForPlayer(playerid, "http://buzz.ice.infomaniak.ch/buzz-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 3) { PlayAudioStreamForPlayer(playerid, "http://mgharba.ice.infomaniak.ch/mgharba-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 4) { PlayAudioStreamForPlayer(playerid, "http://rnb.ice.infomaniak.ch/rnb-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 5) { PlayAudioStreamForPlayer(playerid, "http://gold.ice.infomaniak.ch/gold-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 6) { PlayAudioStreamForPlayer(playerid, "http://cover2.ice.infomaniak.ch/cover2-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 7) { PlayAudioStreamForPlayer(playerid, "http://poprock.ice.infomaniak.ch/poprock-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 8) { PlayAudioStreamForPlayer(playerid, "http://french.ice.infomaniak.ch/french-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == 9) { PlayAudioStreamForPlayer(playerid, "http://latino.ice.infomaniak.ch/latino-128.mp3", ComputerInfo[PlayerInfo[playerid][computer]][cX], ComputerInfo[PlayerInfo[playerid][computer]][cY], ComputerInfo[PlayerInfo[playerid][computer]][cZ] + PlayerInfo[playerid][sound], disfcom * 3, 1); } else if(PlayerInfo[playerid][musicpos] == MAX_MUSICS) PlayerInfo[playerid][musicpos] = 0, musicplace(playerid);
        else if(PlayerInfo[playerid][musicpos] == MIN_MUSICS) PlayerInfo[playerid][musicpos] = MAX_MUSICS - 1, musicplace(playerid);
        PlayerInfo[playerid][usemusic] = true;
    }
}
stock editmpos(playerid, pos) {
    PlayerInfo[playerid][usemusic] = false;
    PlayerInfo[playerid][musicpos] += pos;
    setPlay(playerid);
    PlayerInfo[playerid][usemusic] = true;
}
//======= Show Player barre ==========//
stock showpbarre(playerid) {
    for (new i = 0; i < USED_pSuperBall; i++) {
        PlayerTextDrawShow(playerid, pbarr[i]);
    }
    PlayerInfo[playerid][playh] = true;
}
//======= show ball
stock showpball(playerid) {
    PlayerTextDrawShow(playerid, pball);
}
//======= Hide Player barre ==========//
stock hidepbarre(playerid) {
    for (new i = 0; i < USED_pSuperBall; i++) {
        PlayerTextDrawHide(playerid, pbarr[i]);
    }
    PlayerInfo[playerid][playh] = false;
    PlayerTextDrawHide(playerid, pball);
}
//======= X Player barre ==========//
stock destroybarre(playerid) {
    for (new i = 0; i < USED_pSuperBall; i++) {
        PlayerTextDrawDestroy(playerid, pbarr[i]);
    }
}
//============= X ball ===========================
stock refleshballbar(playerid) {
    PlayerTextDrawDestroy(playerid, pball);
    pball = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][pbX], PlayerInfo[playerid][pbY], "ld_pool:ball");
    PlayerTextDrawLetterSize(playerid, pball, 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pball, 5.000000, 5.833312);
    PlayerTextDrawAlignment(playerid, pball, 1);
    PlayerTextDrawColor(playerid, pball, 16711935);
    PlayerTextDrawSetShadow(playerid, pball, 0);
    PlayerTextDrawSetOutline(playerid, pball, 0);
    PlayerTextDrawFont(playerid, pball, 4);
    PlayerTextDrawShow(playerid, pball);
}
//==========Create barre 4 player ================//
stock createpb(playerid) {
    PlayerInfo[playerid][bX] = 487.500000;
    PlayerInfo[playerid][bY] = 284.083374 + 30.0;
    PlayerInfo[playerid][pbX] = 492.500000;
    PlayerInfo[playerid][pbY] = 278.250091;

    pbarr[0] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX], PlayerInfo[playerid][bY], "ld_shtr:cbarm");
    PlayerTextDrawLetterSize(playerid, pbarr[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[0], 18.000000, 7.000000);
    PlayerTextDrawAlignment(playerid, pbarr[0], 1);
    PlayerTextDrawColor(playerid, pbarr[0], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[0], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[0], 0);
    PlayerTextDrawFont(playerid, pbarr[0], 4);
    pbarr[1] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX] - 5.5000, PlayerInfo[playerid][bY] - 0.16681, "ld_shtr:cbarl");
    PlayerTextDrawLetterSize(playerid, pbarr[1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[1], 5.500000, 7.000000);
    PlayerTextDrawAlignment(playerid, pbarr[1], 1);
    PlayerTextDrawColor(playerid, pbarr[1], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[1], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[1], 0);
    PlayerTextDrawFont(playerid, pbarr[1], 4);
    pbarr[2] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX] + 18.000, PlayerInfo[playerid][bY] + 0.249877, "ld_shtr:cbarr");
    PlayerTextDrawLetterSize(playerid, pbarr[2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[2], 5.500000, 6.416666);
    PlayerTextDrawAlignment(playerid, pbarr[2], 1);
    PlayerTextDrawColor(playerid, pbarr[2], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[2], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[2], 0);
    PlayerTextDrawFont(playerid, pbarr[2], 4);
}
//==============Move barre 4 Player ===========//
stock movepbarre(playerid, Float:X, Float:Y) {
    destroybarre(playerid);

    PlayerInfo[playerid][bX] += X;
    PlayerInfo[playerid][bY] += Y;

    ///========================
    if(PlayerInfo[playerid][bX] <= 362.0) PlayerInfo[playerid][bX] -= X;
    else if(PlayerInfo[playerid][bX] + 10.000 >= 625.0) PlayerInfo[playerid][bX] -= X;
    else if(PlayerInfo[playerid][bY] >= 316.166687) PlayerInfo[playerid][bY] -= Y;
    else if(PlayerInfo[playerid][bY] <= 180.250045) PlayerInfo[playerid][bY] -= Y;

    pbarr[0] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX], PlayerInfo[playerid][bY], "ld_shtr:cbarm");
    PlayerTextDrawLetterSize(playerid, pbarr[0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[0], 18.000000, 7.000000);
    PlayerTextDrawAlignment(playerid, pbarr[0], 1);
    PlayerTextDrawColor(playerid, pbarr[0], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[0], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[0], 0);
    PlayerTextDrawFont(playerid, pbarr[0], 4);
    pbarr[1] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX] - 5.5000, PlayerInfo[playerid][bY] - 0.16681, "ld_shtr:cbarl");
    PlayerTextDrawLetterSize(playerid, pbarr[1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[1], 5.500000, 7.000000);
    PlayerTextDrawAlignment(playerid, pbarr[1], 1);
    PlayerTextDrawColor(playerid, pbarr[1], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[1], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[1], 0);
    PlayerTextDrawFont(playerid, pbarr[1], 4);
    pbarr[2] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][bX] + 18.000, PlayerInfo[playerid][bY] + 0.249877, "ld_shtr:cbarr");
    PlayerTextDrawLetterSize(playerid, pbarr[2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pbarr[2], 5.500000, 6.416666);
    PlayerTextDrawAlignment(playerid, pbarr[2], 1);
    PlayerTextDrawColor(playerid, pbarr[2], 16777215);
    PlayerTextDrawSetShadow(playerid, pbarr[2], 0);
    PlayerTextDrawSetOutline(playerid, pbarr[2], 0);
    PlayerTextDrawFont(playerid, pbarr[2], 4);
    showpball(playerid);

    showpbarre(playerid);
}
forward TRTR(playerid);
public TRTR(playerid) {
    Computer_UpdateTime(playerid);
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {
    if(PlayerInfo[playerid][usecom]) shutdown(playerid);
    return 1;
}
SendFBmsg(playerid, msg[]) {
    new string[128 * 2];
    format(string, sizeof(string), "{0000FF}[{0088FF}F{0000FF}ACE{0088FF}B{0000FF}OOK] {00FFB3}%s", msg);
    SM(playerid, string);
    return 1;
}
stock ShowAllPlayer(playerid) {
    if(PlayerInfo[playerid][plsfb] == 0) return onlineerror(playerid);
    PlayerInfo[playerid][showpl] = true;
    new string[MAX_PLAYERS * 2], String_Large[MAX_PLAYERS * 2];
    for (new i = -1; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && i != playerid) {
            if(PlayerInfo[i][sshowfb]) format(string, sizeof(String_Large), "{D5D0F2}(%d) %s {00FF00}� Online\n{D5D0F2}", i, Computer_PlayerName(i));
            else format(string, sizeof(String_Large), "{D5D0F2}(%d) %s {FF0000}� Offline\n{D5D0F2}", i, Computer_PlayerName(i));
            strcat(String_Large, string);
        }
    }
    return ShowPlayerDialogEx(playerid, DIALOG_PLIST, 0, DIALOG_STYLE_MSGBOX, "Players List", String_Large, "Okey", "");
}
stock ShowMsgPlayer(playerid) {
    if(PlayerInfo[playerid][plsfb] == 0) return onlineerror(playerid);
    PlayerInfo[playerid][showpl] = true;
    new string[MAX_PLAYERS * 2], String_Large[MAX_PLAYERS * 2];
    for (new i = -1; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && i != playerid) {
            if(PlayerInfo[i][sshowfb]) format(string, sizeof(String_Large), "{D5D0F2}(%d) %s {00FF00}� Online\n{D5D0F2}", i, Computer_PlayerName(i));
            else format(string, sizeof(String_Large), "{D5D0F2}(%d) %s {FF0000}� Offline\n{D5D0F2}", i, Computer_PlayerName(i));
            strcat(String_Large, string);
        }
    }
    return ShowPlayerDialogEx(playerid, DIALOG_PLIST, 0, DIALOG_STYLE_LIST, "Players List", String_Large, "Okey", "Cancel");
}

GetTotalOnline(playerid) {
    new fcount, fstring[128];
    for (new i = 0; i < MAX_PLAYERS; i++) {
        if(PlayerInfo[i][sshowfb] && i != playerid) fcount++;
    }
    if(PlayerInfo[playerid][lang] == ENG) format(fstring, sizeof(fstring), "friends (%d)", fcount);
    if(PlayerInfo[playerid][lang] == FRA) format(fstring, sizeof(fstring), "amis (%d)", fcount);
    if(PlayerInfo[playerid][lang] == DAR) format(fstring, sizeof(fstring), "s7abk (%d)", fcount);
    PlayerTextDrawSetString(playerid, fronl, fstring);
    new stringfb[128];
    if(PlayerInfo[playerid][lang] == ENG) format(stringfb, sizeof(stringfb), "%d like", fblike);
    if(PlayerInfo[playerid][lang] == FRA || PlayerInfo[playerid][lang] == DAR) format(stringfb, sizeof(stringfb), "%d j'aime", fblike);
    PlayerTextDrawSetString(playerid, numlike, stringfb);
    PlayerInfo[playerid][plsfb] = fcount;
    return 1;
}
stock SM(playerid, const msg[]) {
    return SendClientMessageEx(playerid, -1, msg);
}
stock rconlist(playerid) {
    return ShowPlayerDialogEx(playerid, DIALOG_RCONL, 0, DIALOG_STYLE_LIST, "RCON cmds", "{4B05FC}Destroy Computer\n{4B05FC}Edit Place\n{4B05FC}Goto computer\n{4B05FC}Get computer", "Okey", "Back");
}

stock getid(const params[]) {
    new Computer_ID, found, string[128], playername[MAX_PLAYER_NAME];
    for (new i = 0; i <= MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            GetPlayerName(i, playername, MAX_PLAYER_NAME);
            new namelen = strlen(playername);
            new bool:searched = false;
            for (new pos = 0; pos <= namelen; pos++) {
                if(searched != true) {
                    if(strfind(playername, params, true) == pos) {
                        found++;
                        format(string, sizeof(string), "%d. %s (Computer_ID %d)", found, playername, i);
                        searched = true;
                        Computer_ID = i;
                        break;
                    }
                }
            }
        }
    }
    if(found == 0) return ~1;
    else return Computer_ID;
}

stock barrelang(playerid, langue) {
    if(langue == ENG) {
        PlayerTextDrawSetString(playerid, databarre[3], "ENG");
        PlayerTextDrawSetString(playerid, tdchange[0], "Shut_down");
        PlayerTextDrawSetString(playerid, tdchange[1], "Added image");
        PlayerTextDrawSetString(playerid, tdchange[2], "Like  Comment  Share");
        PlayerTextDrawSetString(playerid, tdchange[3], "Your Place");
        PlayerTextDrawSetString(playerid, tdchange[4], "Music");
        PlayerTextDrawSetString(playerid, tdchange[5], "MAP");
        PlayerTextDrawSetString(playerid, tdchange[6], "MAP~n~~n~~n~~n~Music~n~~n~~n~~n~Superball~n~~n~~n~~n~facebook~n~~n~~n~~n~Zombies");

        PlayerTextDrawSetString(playerid, tdchange[7], "ERROR");
        PlayerTextDrawSetString(playerid, tdchange[9], "! ERROR !");
        PlayerTextDrawSetString(playerid, tdchange[10], "You must have an account");
        PlayerTextDrawSetString(playerid, tdchange[12], "How do I make an account ?");
        PlayerTextDrawSetString(playerid, tdchange[13], "its easy You must buy computer");
    } else if(langue == FRA) {
        PlayerTextDrawSetString(playerid, databarre[3], "FRA");
        PlayerTextDrawSetString(playerid, tdchange[0], "Eteindre");
        PlayerTextDrawSetString(playerid, tdchange[1], "ajout�e une image");
        PlayerTextDrawSetString(playerid, tdchange[2], "jaime  Commenter  Partager");
        PlayerTextDrawSetString(playerid, tdchange[3], "Votre place");
        PlayerTextDrawSetString(playerid, tdchange[4], "Musique");
        PlayerTextDrawSetString(playerid, tdchange[5], "Carte");
        PlayerTextDrawSetString(playerid, tdchange[6], "Carte~n~~n~~n~~n~Musique~n~~n~~n~~n~Superball~n~~n~~n~~n~facebook~n~~n~~n~~n~Zombies");

        PlayerTextDrawSetString(playerid, tdchange[7], "Erreur");
        PlayerTextDrawSetString(playerid, tdchange[9], "! Erreur !");
        PlayerTextDrawSetString(playerid, tdchange[10], "Vous devez avoir un compte");
        PlayerTextDrawSetString(playerid, tdchange[12], "Comment puis-je faire un compte ?");
        PlayerTextDrawSetString(playerid, tdchange[13], "Vous devez acheter un ordinateur");
    } else if(langue == DAR) {
        PlayerTextDrawSetString(playerid, databarre[3], "DAR");
        PlayerTextDrawSetString(playerid, tdchange[0], "Tfih");
        PlayerTextDrawSetString(playerid, tdchange[1], "law7 tswira");
        PlayerTextDrawSetString(playerid, tdchange[2], "jaime  Commenter  Partager");
        PlayerTextDrawSetString(playerid, tdchange[3], "Blastke");
        PlayerTextDrawSetString(playerid, tdchange[4], "Mzika");
        PlayerTextDrawSetString(playerid, tdchange[5], "5arita");
        PlayerTextDrawSetString(playerid, tdchange[6], "5arita~n~~n~~n~~n~Mzika~n~~n~~n~~n~Superball~n~~n~~n~~n~facebook~n~~n~~n~~n~Zombies");

        PlayerTextDrawSetString(playerid, tdchange[7], "eror");
        PlayerTextDrawSetString(playerid, tdchange[9], "! eror !");
        PlayerTextDrawSetString(playerid, tdchange[10], "5as ykon 3andk account");
        PlayerTextDrawSetString(playerid, tdchange[12], "kifax ymknlik dir account ?");
        PlayerTextDrawSetString(playerid, tdchange[13], "tari9a sahla mahla chri PC");
    }
}
stock tarjm(playerid, langue) {
    PlayerInfo[playerid][lang] = langue;
    barrelang(playerid, langue);
}
stock onlineerror(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "No Player Online on facebook");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Pas de joueur en ligne sur facebook");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "tawa7d ma 7al l facebook");
    return 1;
}
stock MWIN(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You Win :)");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous gagnez :)");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "rba7ti :)");
    return 1;
}
stock MLOSE(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You Lose :(");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Tu as perdu :(");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "5srti :(");
    return 1;
}
stock MDES(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "The Computer has been destroyed");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "L'ordinateur a �t� d�truit");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "l PC t7ayd");
    return 1;
}
stock TDC(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "This player does not have computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Ce joueur n'a pas l'ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "had l3ab ma3andoch PC");
    return 1;
}
stock YNC(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You are not close to this computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous n'�tes pas � proximit� de cet ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "nta ma9ribch mn lPC");
    return 1;
}
stock YAO(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You already have one");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous avez d�j� un ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "nta rah 3andk wa7d");
    return 1;
}
stock NEM(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "Not enough money");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Pas assez d'argent");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "ma3andkch lflouse");
    return 1;
}
stock YMHA(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You need an account to save options!");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous devez avoir un compte pour sauver les options!");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "5as ykon 3andk compte bach ytchjel lik scores!");
    return 1;
}
stock YMHP(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "you must to have an computer to access this page");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "vous devez avoir un ordinateur pour acc�der � cette page");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "5as ykon 3andk PC bach d5ol lhad sf7a");
    return 1;
}
stock YTV(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You need to exit your vehicle");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous devez quitter votre v�hicule");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "5roj mnl7dida");
    return 1;
}
stock YDC(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You don't have computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "?");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "ma3andkch PC");
    return 1;
}
stock YNTY(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You are not close to your computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous ne disposez pas de l'ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "nta ma9ribch mn lPC dialk");
    return 1;
}
stock YNTRT(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "you only can use it");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "vous �tes seulement qui peut l'utiliser");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "nta bo7dk li t9ad t5dm fih");
    return 1;
}
stock YNTRR(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "all can use this computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "tout le monde peut utiliser cet ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "kolchi y9ad y5dm fih");
    return 1;
}
stock YCTY(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You are close to your computer");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous etes disposez de l'ordinateur");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "nta rah 9rib mn lPC dialk");
    return 1;
}
stock YNR(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "You must to be RCON");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Vous devez �tre RCON");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "5ask tkon RCON");
    return 1;
}
stock TNO(playerid) {
    if(PlayerInfo[playerid][lang] == ENG) SM(playerid, "This player not online");
    else if(PlayerInfo[playerid][lang] == FRA) SM(playerid, "Ce joueur pas en ligne");
    else if(PlayerInfo[playerid][lang] == DAR) SM(playerid, "Hada machi online");
    return 1;
}
#define hBspeed 0.50

stock UpdateTextDrawKiller(playerid) {
    PlayerTextDrawDestroy(playerid, Zombiesgg[1]);
    PlayerTextDrawDestroy(playerid, Zombiesgg[2]);
    PlayerTextDrawDestroy(playerid, Zombiesgg[3]);
    PlayerTextDrawDestroy(playerid, Zombiesgg[4]);
    PlayerTextDrawDestroy(playerid, Zombiesgg[5]);

    Zombiesgg[1] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] - 10.5, PlayerInfo[playerid][nY] - 12.25, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[1], 11.500000, 13.416671);
    PlayerTextDrawAlignment(playerid, Zombiesgg[1], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[1], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[1], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[1], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[1], 4);
    Zombiesgg[2] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] + 12.5, PlayerInfo[playerid][nY] - 12.416626, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[2], -11.500000, 13.416670);
    PlayerTextDrawAlignment(playerid, Zombiesgg[2], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[2], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[2], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[2], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[2], 4);
    Zombiesgg[3] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] + 12.5, PlayerInfo[playerid][nY] + 14.250122, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[3], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[3], -11.500000, -13.416661);
    PlayerTextDrawAlignment(playerid, Zombiesgg[3], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[3], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[3], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[3], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[3], 4);
    Zombiesgg[4] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX] - 10.5, PlayerInfo[playerid][nY] + 14.083435, "hud:sitem16");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[4], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[4], 11.500000, -13.416665);
    PlayerTextDrawAlignment(playerid, Zombiesgg[4], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[4], -16776961);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[4], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[4], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[4], 4);
    Zombiesgg[5] = CreatePlayerTextDraw(playerid, PlayerInfo[playerid][nX], PlayerInfo[playerid][nY], "ld_pool:ball");
    PlayerTextDrawLetterSize(playerid, Zombiesgg[5], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, Zombiesgg[5], 2.000000, 2.333333);
    PlayerTextDrawAlignment(playerid, Zombiesgg[5], 1);
    PlayerTextDrawColor(playerid, Zombiesgg[5], 255);
    PlayerTextDrawSetShadow(playerid, Zombiesgg[5], 0);
    PlayerTextDrawSetOutline(playerid, Zombiesgg[5], 0);
    PlayerTextDrawFont(playerid, Zombiesgg[5], 4);

    new string[128];
    format(string, sizeof(string), "%d ~n~%d~n~~g~%d", PlayerInfo[playerid][headshot], PlayerInfo[playerid][zscore], PlayerInfo[playerid][zmoney]);
    PlayerTextDrawSetString(playerid, Zombiesgg[8], string);

    PlayerTextDrawShow(playerid, Zombiesgg[1]);
    PlayerTextDrawShow(playerid, Zombiesgg[2]);
    PlayerTextDrawShow(playerid, Zombiesgg[3]);
    PlayerTextDrawShow(playerid, Zombiesgg[4]);
    PlayerTextDrawShow(playerid, Zombiesgg[5]);
    return 1;
}
IsNinA(playerid) {
    if(PlayerInfo[playerid][nX] < 114.500) PlayerInfo[playerid][nX] += PlayerInfo[playerid][kspeed];
    if(PlayerInfo[playerid][nX] > plX) PlayerInfo[playerid][nX] -= PlayerInfo[playerid][kspeed];
    if(PlayerInfo[playerid][nY] < 143.500) PlayerInfo[playerid][nY] += PlayerInfo[playerid][kspeed];
    if(PlayerInfo[playerid][nY] > 343.50) PlayerInfo[playerid][nY] -= PlayerInfo[playerid][kspeed];
    return UpdateTextDrawKiller(playerid);
}

IsPlayerCloseToAnyComputer(playerid) {
    new yes = false;
    if(!IsPlayerSpawned(playerid) || !IsPlayerLoggedIn(playerid)) return false;
    loopco {
        if(GetPlayerAdminLevel(playerid) == 10 && IsPlayerCloseToComputer(playerid, i)) yes = true;
        if(IsPlayerCloseToComputer(playerid, i) && !ComputerInfo[i][Locked]) yes = true;
        if(PlayerInfo[playerid][haveone]) { if(IsPlayerCloseToComputer(playerid, PlayerInfo[playerid][computer])) yes = true; }
    }
    if(yes) return true;
    else return false;
}

#define zid 1.0
createzombie(playerid) {
    loopz {
        if(!Zinfo[playerid][i][created]) {
            Zinfo[playerid][i][zX] = 111.000000;
            Zinfo[playerid][i][zY] = 271.250000;
            Zinfo[playerid][i][Health] = 100.00;
            Zinfo[playerid][i][Speed] = random(2) + 0.5555;
            pZombie[i] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX], Zinfo[playerid][i][zY], "hud:radar_gangG");
            PlayerTextDrawLetterSize(playerid, pZombie[i], 0.000000, 0.000000);
            PlayerTextDrawTextSize(playerid, pZombie[i], 15.000000, 18.083349);
            PlayerTextDrawAlignment(playerid, pZombie[i], 1);
            PlayerTextDrawColor(playerid, pZombie[i], -1);
            PlayerTextDrawSetShadow(playerid, pZombie[i], 0);
            PlayerTextDrawSetOutline(playerid, pZombie[i], 0);
            PlayerTextDrawFont(playerid, pZombie[i], 4);
            hZombie[i][0] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.0, Zinfo[playerid][i][zY] - 8.74997, "LD_SPAC:white");
            PlayerTextDrawLetterSize(playerid, hZombie[i][0], 0.000000, 0.000000);
            PlayerTextDrawTextSize(playerid, hZombie[i][0], 20.500000, 8.166687);
            PlayerTextDrawAlignment(playerid, hZombie[i][0], 1);
            PlayerTextDrawColor(playerid, hZombie[i][0], 255);
            PlayerTextDrawSetShadow(playerid, hZombie[i][0], 0);
            PlayerTextDrawSetOutline(playerid, hZombie[i][0], 0);
            PlayerTextDrawFont(playerid, hZombie[i][0], 4);
            hZombie[i][1] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.5 + zid, Zinfo[playerid][i][zY] - 8.5, "ld_dual:health");
            PlayerTextDrawLetterSize(playerid, hZombie[i][1], 0.000000, 0.000000);
            PlayerTextDrawTextSize(playerid, hZombie[i][1], 19.500000, 7.000020);
            PlayerTextDrawAlignment(playerid, hZombie[i][1], 1);
            PlayerTextDrawColor(playerid, hZombie[i][1], -65281);
            PlayerTextDrawSetShadow(playerid, hZombie[i][1], 0);
            PlayerTextDrawSetOutline(playerid, hZombie[i][1], 0);
            PlayerTextDrawFont(playerid, hZombie[i][1], 4);
            hZombie[i][2] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.5 + zid, Zinfo[playerid][i][zY] - 8.5, "ld_dual:power");
            PlayerTextDrawLetterSize(playerid, hZombie[i][2], 0.000000, 0.000000);
            PlayerTextDrawTextSize(playerid, hZombie[i][2], 19.500000, 7.000020);
            PlayerTextDrawAlignment(playerid, hZombie[i][2], 1);
            PlayerTextDrawColor(playerid, hZombie[i][2], -65281);
            PlayerTextDrawSetShadow(playerid, hZombie[i][2], 0);
            PlayerTextDrawSetOutline(playerid, hZombie[i][2], 0);
            PlayerTextDrawFont(playerid, hZombie[i][2], 4);
            Zinfo[playerid][i][created] = true;
        }
    }
}
n9szhealth(playerid, i, Float:nldl) {
    PlayerInfo[playerid][zmoney] += 1;
    Zinfo[playerid][i][Health] -= nldl;
    return 1;
}

OnZombieDeath(playerid, i) {
    PlayerInfo[playerid][zmoney] += 100;
    Zinfo[playerid][i][zX] = zlX;
    Zinfo[playerid][i][zY] = zlY;
    Zinfo[playerid][i][Health] = 100.00;
    hidezombie(playerid, i);
    return 1;
}

OnHeadShot(playerid) {
    loopz {
        if(IsHeadShot(playerid, i)) n9szhealth(playerid, i, PlayerInfo[playerid][com_damage] * 2), PlayerInfo[playerid][headshot] += 1;
    }
    return 1;
}
OnBodyShot(playerid) {
    loopz {
        if(IsBodyShot(playerid, i)) n9szhealth(playerid, i, PlayerInfo[playerid][com_damage]);
    }
    return 1;
}

IsHeadShot(playerid, i) {
    new yes = false;
    if(Zinfo[playerid][i][zX] + 4.5 < PlayerInfo[playerid][nX] < Zinfo[playerid][i][zX] + 9.00 && Zinfo[playerid][i][zY] - 1.50 < PlayerInfo[playerid][nY] < Zinfo[playerid][i][zY] + 3.5) yes = true;
    return yes;
}
IsBodyShot(playerid, i) {
    new yes = false;
    if(Zinfo[playerid][i][zX] + 1.5 < PlayerInfo[playerid][nX] < Zinfo[playerid][i][zX] + 12.00 && Zinfo[playerid][i][zY] + 3.5 < PlayerInfo[playerid][nY] < Zinfo[playerid][i][zY] + 16.5) yes = true;
    return yes;
}

showzombie(playerid, i) {
    PlayerTextDrawShow(playerid, pZombie[i]);
    PlayerTextDrawShow(playerid, hZombie[i][0]);
    PlayerTextDrawShow(playerid, hZombie[i][1]);
    PlayerTextDrawShow(playerid, hZombie[i][2]);
    Zinfo[playerid][i][showed] = true;
}
hidezombie(playerid, i) {
    PlayerTextDrawHide(playerid, pZombie[i]);
    PlayerTextDrawHide(playerid, hZombie[i][0]);
    PlayerTextDrawHide(playerid, hZombie[i][1]);
    PlayerTextDrawHide(playerid, hZombie[i][2]);
    Zinfo[playerid][i][showed] = false;
}
givezombie(playerid) {
    loopz {
        if(zoco(playerid) < 14) {
            if(Zinfo[playerid][i][created] && !Zinfo[playerid][i][showed]) {
                Zinfo[playerid][i][zX] = zlX;
                randomY(playerid, i);
                showzombie(playerid, i);
                break;
            }
        }
    }
}
//319.2500 | 286.2500 | 259.2500 | 235.2500
randomY(playerid, i) {
    new rY = random(4);
    switch (rY) {
        case 0:
            Zinfo[playerid][i][zY] = 343.2500;
        case 1:
            Zinfo[playerid][i][zY] = 319.2500;
        case 2:
            Zinfo[playerid][i][zY] = 286.2500;
        case 3:
            Zinfo[playerid][i][zY] = 259.2500;
        case 4:
            Zinfo[playerid][i][zY] = 235.2500;
    }
}
destroyzombie(playerid, i) {
    PlayerTextDrawDestroy(playerid, pZombie[i]);
    PlayerTextDrawDestroy(playerid, hZombie[i][0]);
    PlayerTextDrawDestroy(playerid, hZombie[i][1]);
    PlayerTextDrawDestroy(playerid, hZombie[i][2]);
    Zinfo[playerid][i][showed] = false;
    Zinfo[playerid][i][created] = false;
}
createzombiea(playerid, i) {
    pZombie[i] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX], Zinfo[playerid][i][zY], "hud:radar_gangG");
    PlayerTextDrawLetterSize(playerid, pZombie[i], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, pZombie[i], 15.000000, 18.083349);
    PlayerTextDrawAlignment(playerid, pZombie[i], 1);
    PlayerTextDrawColor(playerid, pZombie[i], -1);
    PlayerTextDrawSetShadow(playerid, pZombie[i], 0);
    PlayerTextDrawSetOutline(playerid, pZombie[i], 0);
    PlayerTextDrawFont(playerid, pZombie[i], 4);
    hZombie[i][0] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.0, Zinfo[playerid][i][zY] - 8.74997, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, hZombie[i][0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, hZombie[i][0], 20.500000, 8.166687);
    PlayerTextDrawAlignment(playerid, hZombie[i][0], 1);
    PlayerTextDrawColor(playerid, hZombie[i][0], 255);
    PlayerTextDrawSetShadow(playerid, hZombie[i][0], 0);
    PlayerTextDrawSetOutline(playerid, hZombie[i][0], 0);
    PlayerTextDrawFont(playerid, hZombie[i][0], 4);
    hZombie[i][1] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.5 + zid, Zinfo[playerid][i][zY] - 8.5, "ld_dual:health");
    PlayerTextDrawLetterSize(playerid, hZombie[i][1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, hZombie[i][1], Zinfo[playerid][i][Health] * 19.500000 / 100, 7.000020);
    PlayerTextDrawAlignment(playerid, hZombie[i][1], 1);
    PlayerTextDrawColor(playerid, hZombie[i][1], -65281);
    PlayerTextDrawSetShadow(playerid, hZombie[i][1], 0);
    PlayerTextDrawSetOutline(playerid, hZombie[i][1], 0);
    PlayerTextDrawFont(playerid, hZombie[i][1], 4);
    hZombie[i][2] = CreatePlayerTextDraw(playerid, Zinfo[playerid][i][zX] - 2.5 + zid, Zinfo[playerid][i][zY] - 8.5, "ld_dual:power");
    PlayerTextDrawLetterSize(playerid, hZombie[i][2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, hZombie[i][2], Zinfo[playerid][i][Health] * 19.500000 / 100, 7.000020);
    PlayerTextDrawAlignment(playerid, hZombie[i][2], 1);
    PlayerTextDrawColor(playerid, hZombie[i][2], -65281);
    PlayerTextDrawSetShadow(playerid, hZombie[i][2], 0);
    PlayerTextDrawSetOutline(playerid, hZombie[i][2], 0);
    PlayerTextDrawFont(playerid, hZombie[i][2], 4);
    Zinfo[playerid][i][created] = true;
}
refleshzombie(playerid, i) {
    if(Zinfo[playerid][i][showed]) {
        destroyzombie(playerid, i);
        createzombiea(playerid, i);
        showzombie(playerid, i);

        if(Zinfo[playerid][i][zX] < plX) Zinfo[playerid][i][zX] += Zinfo[playerid][i][Speed];
        else return Zinfo[playerid][i][zX] -= Zinfo[playerid][i][Speed], hideZombies(playerid), Computer_showzmenu(playerid);
        if(Zinfo[playerid][i][zY] < plY) Zinfo[playerid][i][zY] += Zinfo[playerid][i][Speed];
        else Zinfo[playerid][i][zY] -= Zinfo[playerid][i][Speed];
        if(Zinfo[playerid][i][Health] < 1.00) return OnZombieDeath(playerid, i);
    }
    return 1;
}
zoco(playerid) {
    new zcount;
    loopz {
        if(Zinfo[playerid][i][showed]) zcount++;
    }
    return zcount;
}

hideallzombies(playerid) {
    loopz {
        hidezombie(playerid, i);
        Zinfo[playerid][i][Health] = 100.00;
        Zinfo[playerid][i][zX] = zlX;
        Zinfo[playerid][i][zY] = zlY;
    }
}
forward GETZ(playerid);
public GETZ(playerid) {
    givezombie(playerid);
    return 1;
}