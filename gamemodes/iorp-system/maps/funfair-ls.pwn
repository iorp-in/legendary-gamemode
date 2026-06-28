new ff_Kart_Vehs[9],
    //Karts

    //Quads
    ff_Quad_Vehs[9],
    //Quads

    //Roller
    ff_Roller_Platform,
    ff_Roller_Unused[37],
    ff_Roller_Unused2[76],
    ff_Roller_Veh,
    //Roller

    //Carousel
    ff_Carousel_Base,
    ff_Carousel_Base2,
    ff_Carousel_Seats[4],
    ff_Carousel_Unused[12],
    //Carousel

    //Revolution
    ff_Revolution_Base,
    ff_Revolution_Base2,
    ff_Revolution_Platforms[4],
    ff_Revolution_Seats[4],
    ff_Revolution_Statue,
    ff_Revolution_Unused[5],
    //Revolution

    //TopGun
    Topgun_Base,
    Topgun_Platforms[7],
    Topgun_Unused[24],
    Topgun_Stairs[2],
    bool:ff_stair,
    //TopGun

    //TheJail
    Jail_Base,
    Jail_BasePlatform,
    Jail_Plataforms[29],
    Jail_Doors[2],
    Jail_Unused[4],
    Jail[5],
    Jail_Base2,
    bool:ff_door,
    //TheJail

    //Projekt
    Projekt_Base[3],
    Projekt_Platform[3],
    Projekt_Seats[12],
    Projekt_Unused[10],
    SuperProjekt_Base[4],
    Projekt_Letters[5],
    //Projekt

    //Observer
    Observer_Base,
    Observer_Seats[2],
    //Observer

    //FerrisWheel
    FerrisWheel_Base,
    FerrisWheel_Seats[10],
    //FerrisWheel

    //Cars
    Cars_Base[3],
    Cars_Unused[25],
    Cars_Vehs[4],
    //Cars

    //Caida Libre
    Caida_Base[2],
    Caida_Seats[12],
    Caida_Unused[34],
    //Caida Libre

    //Crazy Cow
    ff_Cow_Seats[4],
    ff_ret = -1;
#define BULL_TIME   (30000) //30 seconds
////Crazy Cow
new ff_virtualworld = 0;

hook OnGameModeInit() {
    CreateDynamicPickup(19607, 23, 848.3717, -1858.6498, 12.8672, 0, 0);
    CreateDynamicObject(18765, 986.25751, -1990.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -1990.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -1990.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 986.25751, -2000.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 986.25751, -2010.19666, 3.31327, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 986.25751, -2020.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -2000.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -2010.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -2020.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2000.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2010.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2020.19666, 3.31570, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -1990.19666, -1.59869, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -1990.19666, -1.59870, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2000.19666, -1.59870, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2010.19666, -1.59870, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 966.25751, -2020.19666, -1.59870, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 976.25751, -2020.19666, -1.59870, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(978, 989.18512, -2002.44910, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(978, 989.18512, -2011.44910, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(978, 984.40649, -2016.19604, 6.48500, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(979, 984.40063, -2006.00903, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 979.68512, -2011.44910, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(979, 984.40057, -2006.00903, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(979, 979.72046, -2001.30835, 6.48500, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(979, 974.94873, -2006.21753, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(979, 974.94873, -2015.71753, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 974.84045, -2023.99561, 6.48500, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(979, 979.68512, -2019.21753, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(978, 970.02325, -2019.16553, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(979, 970.30939, -2009.77966, 6.48500, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(979, 965.54352, -2014.47925, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 966.60413, -2023.99561, 6.48500, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(978, 961.95697, -2019.11511, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 961.95697, -2009.61511, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 961.95697, -2000.11511, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(978, 961.95697, -1990.61511, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(979, 965.54352, -2009.61511, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(979, 965.54352, -2000.11511, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(979, 965.54352, -1994.61511, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(978, 966.63574, -1985.87036, 6.48500, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(978, 971.39581, -1990.73413, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(979, 970.30939, -2001.30835, 6.48500, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(979, 975.04352, -1996.61511, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(978, 976.01642, -1985.90137, 6.48500, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(978, 984.51642, -1985.90137, 6.48500, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(978, 989.18512, -1991.76025, 6.48500, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(979, 979.49670, -1991.89783, 6.48500, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(979, 984.28693, -1996.62146, 6.48500, 0.00000, 0.00000, -90.00000, ff_virtualworld);

    ff_Kart_Vehs[0] = CreateVehicle(571, 983.0297, -1999.7695, 6.0669, 0.0000, -1, -1, 100);
    ff_Kart_Vehs[1] = CreateVehicle(571, 981.5297, -1999.7695, 6.0669, 0.0000, -1, -1, 100);
    ff_Kart_Vehs[2] = CreateVehicle(571, 980.0297, -1999.7695, 6.0669, 0.0000, -1, -1, 100);
    ff_Kart_Vehs[3] = CreateVehicle(571, 978.5297, -1999.7695, 6.0669, 0.0000, -1, -1, 100);
    ff_Kart_Vehs[4] = CreateVehicle(571, 977.0297, -1999.7695, 6.0669, 0.0000, -1, -1, 100);
    ff_Kart_Vehs[5] = CreateVehicle(571, 987.9070, -1999.2396, 6.0669, 180.0000, -1, -1, 100);
    ff_Kart_Vehs[6] = CreateVehicle(571, 985.9070, -1999.2396, 6.0669, 180.0000, -1, -1, 100);
    ff_Kart_Vehs[7] = CreateVehicle(571, 985.9070, -1997.2396, 6.0669, 180.0000, -1, -1, 100);
    ff_Kart_Vehs[8] = CreateVehicle(571, 987.9070, -1997.2396, 6.0669, 180.0000, -1, -1, 100);
    for (new i = 0; i != 9; i++) SetVehicleHealth(ff_Kart_Vehs[i], 99999999);
    //Karts

    //Quads
    CreateDynamicObject(973, 978.18152, -1937.30115, 4.13970, 0.00000, -14.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(973, 987.27844, -1937.26526, 6.38287, 0.00000, -14.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(973, 973.88135, -1941.85059, 2.80475, 0.00000, -2.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(973, 973.88129, -1951.35059, 2.19532, 0.00000, -3.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(973, 973.88129, -1960.85059, 1.68635, 0.00000, -3.50000, 90.00000, ff_virtualworld);
    CreateDynamicObject(973, 978.53253, -1965.78027, 2.84011, 0.00000, 15.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(973, 987.54639, -1966.15564, 5.12711, 0.00000, 15.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(973, 992.23163, -1961.51367, 6.59243, 0.00000, 2.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(973, 992.23163, -1952.01367, 6.92406, 0.00000, 2.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(973, 992.23163, -1942.01367, 7.25504, 0.00000, 2.00000, -90.00000, ff_virtualworld);

    ff_Quad_Vehs[0] = CreateVehicle(471, 991.0148, -1940.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[1] = CreateVehicle(471, 991.0148, -1943.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[2] = CreateVehicle(471, 991.0148, -1946.4045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[3] = CreateVehicle(471, 991.0148, -1948.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[4] = CreateVehicle(471, 991.0148, -1951.4045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[5] = CreateVehicle(471, 991.0148, -1953.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[6] = CreateVehicle(471, 991.0148, -1956.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[7] = CreateVehicle(471, 991.0148, -1959.9045, 6.9977, 0.0000, -1, -1, 100);
    ff_Quad_Vehs[8] = CreateVehicle(471, 991.0148, -1962.9045, 6.9977, 0.0000, -1, -1, 100);
    for (new i = 0; i != 9; i++) SetVehicleHealth(ff_Quad_Vehs[i], 99999999);
    //Quads

    //Roller
    CreateDynamicObject(18765, 939.09448, -1883.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 939.09448, -1883.77051, 0.03976, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 944.65936, -1881.75574, 15.74265, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 948.65942, -1881.75574, 15.74270, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 948.65942, -1885.75574, 15.74270, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 944.65942, -1885.75574, 15.74270, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    //ff_Roller_Unused[0] = CreateDynamicObject(18763, 946.62622, -1883.74084, 25.56243,   90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[1] = CreateDynamicObject(18763, 951.62622, -1883.74084, 25.56240, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[2] = CreateDynamicObject(18763, 956.32819, -1883.74084, 25.13470, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[3] = CreateDynamicObject(18763, 960.44019, -1883.74084, 23.63512, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[4] = CreateDynamicObject(18763, 963.80621, -1883.74084, 20.79988, 140.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[5] = CreateDynamicObject(18763, 967.93018, -1883.74084, 17.34300, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[6] = CreateDynamicObject(18763, 965.98218, -1883.74084, 18.73766, 130.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[7] = CreateDynamicObject(18763, 972.96222, -1883.74084, 15.50106, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[8] = CreateDynamicObject(18763, 970.78619, -1883.74084, 16.09898, 110.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[9] = CreateDynamicObject(18763, 977.58618, -1883.74084, 15.10216, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[10] = CreateDynamicObject(18763, 982.61823, -1883.74084, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[11] = CreateDynamicObject(18763, 986.86383, -1884.44348, 15.10220, 90.00000, 0.00000, 70.00000, ff_virtualworld);
    ff_Roller_Unused[12] = CreateDynamicObject(18763, 990.60205, -1886.58801, 15.10220, 90.00000, 0.00000, 50.00000, ff_virtualworld);
    ff_Roller_Unused[13] = CreateDynamicObject(18763, 993.31451, -1889.81384, 15.10220, 90.00000, 0.00000, 30.00000, ff_virtualworld);
    ff_Roller_Unused[14] = CreateDynamicObject(18763, 994.74469, -1893.89795, 15.10220, 90.00000, 0.00000, 10.00000, ff_virtualworld);
    ff_Roller_Unused[15] = CreateDynamicObject(18763, 994.12146, -1897.51135, 15.10220, 90.00000, 0.00000, -30.00000, ff_virtualworld);
    ff_Roller_Unused[16] = CreateDynamicObject(18763, 991.32495, -1900.82092, 15.10220, 90.00000, 0.00000, -50.00000, ff_virtualworld);
    ff_Roller_Unused[17] = CreateDynamicObject(18763, 987.53528, -1902.99988, 15.10220, 90.00000, 0.00000, -70.00000, ff_virtualworld);
    ff_Roller_Unused[18] = CreateDynamicObject(18763, 983.21869, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[19] = CreateDynamicObject(18763, 978.32269, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[20] = CreateDynamicObject(18763, 973.42670, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[21] = CreateDynamicObject(18763, 968.39471, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[22] = CreateDynamicObject(18763, 963.49872, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[23] = CreateDynamicObject(18763, 958.60272, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[24] = CreateDynamicObject(18763, 953.70673, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[25] = CreateDynamicObject(18763, 948.81073, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[26] = CreateDynamicObject(18763, 943.91467, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[27] = CreateDynamicObject(18763, 939.01868, -1903.72949, 15.10220, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[28] = CreateDynamicObject(18763, 938.03302, -1900.17139, 14.74232, 82.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[29] = CreateDynamicObject(18763, 938.03870, -1895.61304, 13.68268, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[30] = CreateDynamicObject(18763, 938.06989, -1891.73145, 11.68325, 52.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[31] = CreateDynamicObject(18763, 938.07275, -1888.41235, 8.57151, 42.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[32] = CreateDynamicObject(18763, 938.10522, -1885.92908, 7.40855, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[33] = CreateDynamicObject(18763, 938.10016, -1882.81494, 6.53630, 78.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[34] = CreateDynamicObject(18763, 938.10022, -1877.91895, 6.02390, 90.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused[35] = CreateDynamicObject(18763, 941.66687, -1876.93127, 6.02390, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused[36] = CreateDynamicObject(18763, 942.66663, -1879.69263, 6.02390, 90.00000, 0.00000, 0.00000, ff_virtualworld);
    for (new i = 0; i != 37; i++) SetDynamicObjectMaterial(ff_Roller_Unused[i], 0, 18646, "MatColours", "red", 0xFFFFFF10);

    ff_Roller_Unused2[0] = CreateDynamicObject(18762, 951.64813, -1881.76379, 27.10643, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[1] = CreateDynamicObject(18762, 956.51886, -1881.76831, 26.64994, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[2] = CreateDynamicObject(18762, 961.00690, -1881.76831, 25.05888, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[3] = CreateDynamicObject(18762, 964.54291, -1881.76831, 22.05386, 140.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[4] = CreateDynamicObject(18762, 969.43890, -1881.76831, 18.14202, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[5] = CreateDynamicObject(18762, 966.85492, -1881.76831, 19.78080, 130.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[6] = CreateDynamicObject(18762, 971.88690, -1881.76831, 17.27161, 110.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[7] = CreateDynamicObject(18762, 975.01489, -1881.76831, 16.52710, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[8] = CreateDynamicObject(18762, 977.32690, -1881.76831, 16.69397, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[9] = CreateDynamicObject(18762, 982.22290, -1881.76831, 16.69400, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[10] = CreateDynamicObject(18762, 987.41614, -1882.48718, 16.68307, 90.00000, 0.00000, 70.00000, ff_virtualworld);
    ff_Roller_Unused2[11] = CreateDynamicObject(18762, 991.92761, -1885.02759, 16.68310, 90.00000, 0.00000, 50.00000, ff_virtualworld);
    ff_Roller_Unused2[12] = CreateDynamicObject(18762, 995.12799, -1888.74170, 16.68310, 90.00000, 0.00000, 30.00000, ff_virtualworld);
    ff_Roller_Unused2[13] = CreateDynamicObject(18762, 996.81372, -1893.47314, 16.68310, 90.00000, 0.00000, 10.00000, ff_virtualworld);
    ff_Roller_Unused2[14] = CreateDynamicObject(18762, 995.91785, -1898.47717, 16.68310, 90.00000, 0.00000, -30.00000, ff_virtualworld);
    ff_Roller_Unused2[15] = CreateDynamicObject(18762, 992.62354, -1902.33582, 16.68310, 90.00000, 0.00000, -50.00000, ff_virtualworld);
    ff_Roller_Unused2[16] = CreateDynamicObject(18762, 988.24457, -1904.92651, 16.68310, 90.00000, 0.00000, -70.00000, ff_virtualworld);
    ff_Roller_Unused2[17] = CreateDynamicObject(18762, 983.24182, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[18] = CreateDynamicObject(18762, 978.20978, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[19] = CreateDynamicObject(18762, 973.31378, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[20] = CreateDynamicObject(18762, 968.41779, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[21] = CreateDynamicObject(18762, 963.65778, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[22] = CreateDynamicObject(18762, 958.76178, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[23] = CreateDynamicObject(18762, 953.86578, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[24] = CreateDynamicObject(18762, 949.10577, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[25] = CreateDynamicObject(18762, 944.20978, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[26] = CreateDynamicObject(18762, 939.17780, -1905.74182, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[27] = CreateDynamicObject(18762, 936.04132, -1903.72974, 16.68310, 90.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[28] = CreateDynamicObject(18762, 936.04132, -1899.92175, 16.37538, 82.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[29] = CreateDynamicObject(18762, 936.04132, -1895.16174, 15.25594, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[30] = CreateDynamicObject(18762, 936.04132, -1890.94568, 13.05960, 52.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[31] = CreateDynamicObject(18762, 936.04132, -1887.40967, 9.76702, 42.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[32] = CreateDynamicObject(18762, 936.04132, -1884.96167, 8.80804, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[33] = CreateDynamicObject(18762, 936.04132, -1880.88171, 7.76197, 78.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[34] = CreateDynamicObject(18762, 936.04132, -1877.88965, 7.76200, 90.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[35] = CreateDynamicObject(18762, 939.03644, -1874.88184, 7.76200, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[36] = CreateDynamicObject(18762, 941.89240, -1874.88184, 7.76200, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[37] = CreateDynamicObject(18762, 944.67462, -1878.04126, 7.76200, 90.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[38] = CreateDynamicObject(18762, 940.63806, -1878.94751, 5.60867, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[39] = CreateDynamicObject(18762, 940.03802, -1878.93018, 5.60870, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[40] = CreateDynamicObject(18762, 940.63812, -1879.89954, 5.60870, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[41] = CreateDynamicObject(18762, 940.63812, -1880.85144, 5.60870, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[42] = CreateDynamicObject(18762, 940.09204, -1879.91199, 5.60870, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[43] = CreateDynamicObject(18762, 940.15179, -1880.85876, 5.60870, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[44] = CreateDynamicObject(18762, 940.09229, -1880.88171, 7.76200, 78.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[45] = CreateDynamicObject(18762, 940.09229, -1884.96167, 8.80800, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[46] = CreateDynamicObject(18762, 940.09229, -1887.40967, 9.76700, 42.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[47] = CreateDynamicObject(18762, 940.09229, -1890.94568, 13.05960, 52.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[48] = CreateDynamicObject(18762, 940.09229, -1895.16174, 15.25590, 72.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[49] = CreateDynamicObject(18762, 940.09229, -1899.92175, 16.37540, 82.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Roller_Unused2[50] = CreateDynamicObject(18762, 944.20978, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[51] = CreateDynamicObject(18762, 949.10577, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[52] = CreateDynamicObject(18762, 953.86578, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[53] = CreateDynamicObject(18762, 958.76178, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[54] = CreateDynamicObject(18762, 963.65778, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[55] = CreateDynamicObject(18762, 968.41779, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[56] = CreateDynamicObject(18762, 973.31378, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[57] = CreateDynamicObject(18762, 978.20978, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[58] = CreateDynamicObject(18762, 983.24182, -1901.74353, 16.68310, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    //ff_Roller_Unused2[59] = CreateDynamicObject(18762, 986.83881, -1901.13696, 16.68310,   90.00000, 0.00000, -70.00000, ff_virtualworld);
    //ff_Roller_Unused2[60] = CreateDynamicObject(18762, 989.81622, -1899.42200, 16.68310,   90.00000, 0.00000, -50.00000, ff_virtualworld);
    //ff_Roller_Unused2[61] = CreateDynamicObject(18762, 992.26324, -1896.78784, 16.68310,   90.00000, 0.00000, -30.00000, ff_virtualworld);
    //ff_Roller_Unused2[62] = CreateDynamicObject(18762, 992.73187, -1893.12891, 16.68310,   90.00000, 0.00000, 10.00000, ff_virtualworld);
    //ff_Roller_Unused2[63] = CreateDynamicObject(18762, 991.54510, -1890.59839, 16.68310,   90.00000, 0.00000, 30.00000, ff_virtualworld);
    //ff_Roller_Unused2[64] = CreateDynamicObject(18762, 989.40851, -1888.33936, 16.68310,   90.00000, 0.00000, 50.00000, ff_virtualworld);
    //ff_Roller_Unused2[65] = CreateDynamicObject(18762, 986.31360, -1886.46533, 16.68307,   90.00000, 0.00000, 70.00000, ff_virtualworld);
    ff_Roller_Unused2[66] = CreateDynamicObject(18762, 982.22290, -1885.71228, 16.69400, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[67] = CreateDynamicObject(18762, 977.32690, -1885.71228, 16.69400, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[68] = CreateDynamicObject(18762, 975.01489, -1885.71228, 16.52710, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[69] = CreateDynamicObject(18762, 971.88690, -1885.71228, 17.27160, 110.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[70] = CreateDynamicObject(18762, 969.43890, -1885.71228, 18.14200, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[71] = CreateDynamicObject(18762, 966.85492, -1885.71228, 19.78080, 130.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[72] = CreateDynamicObject(18762, 964.54291, -1885.71228, 22.05390, 140.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[73] = CreateDynamicObject(18762, 961.00690, -1885.71228, 25.05890, 120.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[74] = CreateDynamicObject(18762, 956.51892, -1885.71228, 26.64990, 100.00000, 0.00000, 90.00000, ff_virtualworld);
    ff_Roller_Unused2[75] = CreateDynamicObject(18762, 951.64807, -1885.71228, 27.10640, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    for (new i = 0; i != 76; i++) SetDynamicObjectMaterial(ff_Roller_Unused2[i], 0, 18646, "MatColours", "samporange");

    ff_Roller_Platform = CreateDynamicObject(18763, 946.62622, -1883.74084, 5.97849, 90.00000, 0.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(ff_Roller_Platform, 0, 18646, "MatColours", "red", 0xFFFFFF10);
    ff_Roller_Veh = CreateVehicle(539, 942.7711, -1877.6741, 7.8697, 180.0000, -1, -1, 100);
    SetVehicleHealth(ff_Roller_Veh, 99999999);

    CreateDynamicObject(18762, 987.41614, -1882.48718, 17.69363, 90.00000, 0.00000, 70.00000, ff_virtualworld);
    CreateDynamicObject(18762, 991.92761, -1885.02759, 17.69360, 90.00000, 0.00000, 50.00000, ff_virtualworld);
    CreateDynamicObject(18762, 995.12799, -1888.74170, 17.69360, 90.00000, 0.00000, 30.00000, ff_virtualworld);
    CreateDynamicObject(18762, 996.81372, -1893.47314, 17.69360, 90.00000, 0.00000, 10.00000, ff_virtualworld);
    CreateDynamicObject(18762, 995.91779, -1898.47717, 17.69360, 90.00000, 0.00000, -30.00000, ff_virtualworld);
    CreateDynamicObject(18762, 992.62347, -1902.33582, 17.69360, 90.00000, 0.00000, -50.00000, ff_virtualworld);
    CreateDynamicObject(18762, 988.24463, -1904.92651, 17.69360, 90.00000, 0.00000, -70.00000, ff_virtualworld);
    CreateDynamicObject(18762, 983.24182, -1905.74182, 17.69360, 90.00000, 0.00000, 90.00000, ff_virtualworld);

    CreateDynamicObject(18980, 951.28955, -1883.38281, 14.14821, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 959.28961, -1883.38281, 12.90271, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 969.28961, -1883.38281, 5.15340, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 983.28961, -1883.38281, 3.93727, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 994.28961, -1894.38281, 3.75210, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 990.01013, -1884.97156, 3.75210, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 988.83362, -1901.39954, 3.75210, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 982.84314, -1904.01978, 3.50621, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 971.34308, -1904.01978, 3.50620, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 957.34308, -1904.01978, 3.50620, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 937.84308, -1904.01978, 3.50620, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 937.84308, -1896.01978, -0.03330, 0.00000, 0.00000, 0.00000, ff_virtualworld);

    //Roller

    //Carousel
    ff_Carousel_Unused[0] = CreateDynamicObject(18765, 907.59454, -1876.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[1] = CreateDynamicObject(18765, 897.59448, -1876.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[2] = CreateDynamicObject(18765, 917.59448, -1876.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[3] = CreateDynamicObject(18765, 907.59448, -1886.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[4] = CreateDynamicObject(18765, 917.59448, -1886.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[5] = CreateDynamicObject(18765, 897.59448, -1886.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[6] = CreateDynamicObject(18765, 917.59448, -1866.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[7] = CreateDynamicObject(18765, 907.59448, -1866.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[8] = CreateDynamicObject(18765, 897.59448, -1866.77051, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[9] = CreateDynamicObject(18765, 897.59448, -1886.77051, 0.02220, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[10] = CreateDynamicObject(18765, 907.59448, -1886.77051, 0.02220, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Unused[11] = CreateDynamicObject(18765, 917.59448, -1886.77051, 0.02220, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    for (new i = 0; i != 12; i++) SetDynamicObjectMaterial(ff_Carousel_Unused[i], 0, 18646, "MatColours", "green");

    ff_Carousel_Base = CreateDynamicObject(19278, 907.63007, -1877.14453, -35.72582, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Carousel_Base2 = CreateDynamicObject(19278, 907.63007, -1877.14453, -41.37026, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Carousel_Base2, ff_Carousel_Base, 0, 0, -5.6445, 0, 0, 0);

    ff_Carousel_Seats[0] = CreateDynamicObject(16442, 908.34973, -1872.45020, 10.02538, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Carousel_Seats[0], ff_Carousel_Base, 0.7196, 4.6943, 45.7512, 0, 0, 0);
    ff_Carousel_Seats[1] = CreateDynamicObject(16442, 908.34967, -1881.45020, 10.02540, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Carousel_Seats[1], ff_Carousel_Base, -0.7196, -4.6943, 45.7512, 0, 0, 180);
    ff_Carousel_Seats[2] = CreateDynamicObject(16442, 912.34967, -1876.95020, 10.02540, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Carousel_Seats[2], ff_Carousel_Base, 4.6943, 0.7196, 45.7512, 0, 0, -90);
    ff_Carousel_Seats[3] = CreateDynamicObject(16442, 902.84967, -1876.95020, 10.02540, 0.00000, 0.00000, 90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Carousel_Seats[3], ff_Carousel_Base, -4.6943, -0.7196, 45.7512, 0, 0, 90);
    //Carousel

    //Revolution
    CreateDynamicObject(19128, 875.96594, -1867.31836, 7.53690, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(19128, 865.89386, -1876.91614, 7.53690, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(19128, 875.91583, -1886.70874, 7.53690, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(19128, 885.87018, -1877.04871, 7.53690, 0.00000, 0.00000, 0.00000, ff_virtualworld);

    ff_Revolution_Unused[0] = CreateDynamicObject(18765, 875.91437, -1876.93079, 4.98012, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Revolution_Unused[1] = CreateDynamicObject(18765, 875.90234, -1886.87134, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Revolution_Unused[2] = CreateDynamicObject(18765, 875.91443, -1866.93079, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Revolution_Unused[3] = CreateDynamicObject(18765, 885.91443, -1876.93079, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Revolution_Unused[4] = CreateDynamicObject(18765, 865.91443, -1876.93079, 4.98010, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18765, 875.90234, -1886.87134, 0.10408, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    for (new i = 0; i != 5; i++) SetDynamicObjectMaterial(ff_Revolution_Unused[i], 0, 18646, "MatColours", "red");
    CreateDynamicObject(18764, 875.9321, -1876.9152, 5.8495, 0.00000, 0.00000, 0.00000, ff_virtualworld);

    ff_Revolution_Base = CreateDynamicObject(13649, 875.91345, -1877.00439, 8.06837, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    ff_Revolution_Base2 = CreateDynamicObject(13649, 875.91345, -1877.00439, 9.22711, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Base2, ff_Revolution_Base, 0, 0, 1.1587, 0, 0, 0);

    ff_Revolution_Statue = CreateDynamicObject(14467, 876.17511, -1877.41479, 11.85857, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Statue, ff_Revolution_Base, 0.2616, -0.4104, 3.7902, 0, 0, 0);

    ff_Revolution_Platforms[0] = CreateDynamicObject(1232, 875.99805, -1881.88306, 8.63261, 103.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Platforms[0], ff_Revolution_Base, 0.0845, -4.8787, 0.5945, 103, 0, 0);
    ff_Revolution_Platforms[1] = CreateDynamicObject(1232, 871.03119, -1876.95117, 8.63260, 103.00000, 0.00000, -90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Platforms[1], ff_Revolution_Base, -4.8787, 0.0845, 0.5945, 103, 0, -90);
    ff_Revolution_Platforms[2] = CreateDynamicObject(1232, 875.99799, -1871.88306, 8.63260, 103.00000, 0.00000, 180.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Platforms[2], ff_Revolution_Base, -0.0845, 4.8787, 0.5945, 103, 0, 180);
    ff_Revolution_Platforms[3] = CreateDynamicObject(1232, 881.03119, -1876.95117, 8.63260, 103.00000, 0.00000, 90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Platforms[3], ff_Revolution_Base, 4.8787, -0.0845, 0.5945, 103, 0, 90);

    ff_Revolution_Seats[0] = CreateDynamicObject(1562, 875.53699, -1884.53552, 8.31260, 0.00000, -15.00000, -90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Seats[0], ff_Revolution_Base, -0.3765, -7.5311, 0.5, 0, -15, -90);
    ff_Revolution_Seats[1] = CreateDynamicObject(1562, 868.39508, -1876.50562, 8.31260, 0.00000, -15.00000, 180.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Seats[1], ff_Revolution_Base, -7.5311, 0.3765, 0.5, 0, -15, 180);
    ff_Revolution_Seats[2] = CreateDynamicObject(1562, 876.43402, -1869.29211, 8.31260, 0.00000, -15.00000, 90.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Seats[2], ff_Revolution_Base, 0.3765, 7.5311, 0.5, 0, -15, 90);
    ff_Revolution_Seats[3] = CreateDynamicObject(1562, 883.71088, -1877.38330, 8.31260, 0.00000, -15.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(ff_Revolution_Seats[3], ff_Revolution_Base, 7.5311, -0.3765, 0.5, 0, -15, 0);
    //Revolution

    //TopGun
    CreateDynamicObject(982, 834.34, -1888.07, 12.56, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(984, 842.77, -1904.43, 12.56, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(982, 834.34, -1888.07, 12.56, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(984, 842.77, -1904.43, 12.56, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 842.77, -1870.93, 12.56, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 842.77, -1870.93, 12.56, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(982, 850.84, -1888.07, 12.56, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(982, 850.84, -1888.07, 12.56, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1876.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1880.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1884.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1888.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1892.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1896.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 836.49, -1900.91, 11.86, 0.00, 0.00, 90.00, ff_virtualworld);
    Topgun_Stairs[0] = CreateDynamicObject(8614, 838.82, -1880.40, 14.40, 0.00, 0.00, -90.00, ff_virtualworld);
    Topgun_Stairs[1] = CreateDynamicObject(8614, 845.65, -1896.19, 14.40, 0.00, 0.00, 90.00, ff_virtualworld);
    ff_stair = false;

    Topgun_Unused[0] = CreateDynamicObject(18762, 843.56, -1874.58, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[1] = CreateDynamicObject(18762, 842.56, -1874.58, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[2] = CreateDynamicObject(18762, 841.56, -1874.58, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[3] = CreateDynamicObject(18762, 841.56, -1874.58, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[4] = CreateDynamicObject(18762, 841.56, -1874.58, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[5] = CreateDynamicObject(18762, 841.56, -1874.58, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[6] = CreateDynamicObject(18762, 842.56, -1874.58, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[7] = CreateDynamicObject(18762, 842.56, -1874.58, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[8] = CreateDynamicObject(18762, 842.55, -1874.60, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[9] = CreateDynamicObject(18762, 843.56, -1874.58, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[10] = CreateDynamicObject(18762, 843.56, -1874.58, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[11] = CreateDynamicObject(18762, 843.56, -1874.58, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[12] = CreateDynamicObject(18762, 841.56, -1901.94, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[13] = CreateDynamicObject(18762, 842.56, -1901.94, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[14] = CreateDynamicObject(18762, 843.56, -1901.94, 28.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[15] = CreateDynamicObject(18762, 843.56, -1901.94, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[16] = CreateDynamicObject(18762, 842.56, -1901.94, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[17] = CreateDynamicObject(18762, 841.56, -1901.94, 23.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[18] = CreateDynamicObject(18762, 843.56, -1901.94, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[19] = CreateDynamicObject(18762, 842.56, -1901.94, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[20] = CreateDynamicObject(18762, 841.56, -1901.94, 18.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[21] = CreateDynamicObject(18762, 841.56, -1901.94, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[22] = CreateDynamicObject(18762, 842.55, -1901.94, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    Topgun_Unused[23] = CreateDynamicObject(18762, 843.56, -1901.94, 13.09, 0.00, 0.00, 0.00, ff_virtualworld);
    for (new i = 0; i != 24; i++) SetDynamicObjectMaterial(Topgun_Unused[i], 0, 18646, "MatColours", "samporange");

    Topgun_Base = CreateDynamicObject(18980, 842.24, -1888.27, 28.39, 0.00, 90.00, 90.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Base, 0, 18646, "MatColours", "blue");

    Topgun_Platforms[0] = CreateDynamicObject(18980, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[0], 0, 18646, "MatColours", "yellow");
    AttachDynamicObjectToObject(Topgun_Platforms[0], Topgun_Base, 1.23, 0.53, -12.56, 0.0000, -90.0000, 0.0000);

    Topgun_Platforms[1] = CreateDynamicObject(18980, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[1], 0, 18646, "MatColours", "yellow");
    AttachDynamicObjectToObject(Topgun_Platforms[1], Topgun_Base, 1.23, -0.47, -12.56, 0.0000, -90.0000, 0.0000);

    Topgun_Platforms[2] = CreateDynamicObject(18980, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[2], 0, 18646, "MatColours", "yellow");
    AttachDynamicObjectToObject(Topgun_Platforms[2], Topgun_Base, 1.23, -0.47, 12.44, 0.0000, -90.0000, 0.0000);

    Topgun_Platforms[3] = CreateDynamicObject(18980, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[3], 0, 18646, "MatColours", "yellow");
    AttachDynamicObjectToObject(Topgun_Platforms[3], Topgun_Base, 1.23, 0.53, 12.44, 0.0000, -90.0000, 0.0000);

    Topgun_Platforms[4] = CreateDynamicObject(18766, 0.00, 0.00, 0.00, 90.00, 0.00, 90.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[4], 0, 18646, "MatColours", "redlaser");
    AttachDynamicObjectToObject(Topgun_Platforms[4], Topgun_Base, 13.24, 0, -3.03, 0.00, 90.00, 90.00, 0);
    // z   x   y
    Topgun_Platforms[5] = CreateDynamicObject(18766, 0.00, 0.00, 0.00, 90.00, 0.00, 90.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[5], 0, 18646, "MatColours", "redlaser");
    AttachDynamicObjectToObject(Topgun_Platforms[5], Topgun_Base, 13.24, 0, -7.03, 0.00, 90.00, 90.00, 0);

    Topgun_Platforms[6] = CreateDynamicObject(18766, 0.00, 0.00, 0.00, 90.00, 0.00, 90.00, ff_virtualworld);
    SetDynamicObjectMaterial(Topgun_Platforms[6], 0, 18646, "MatColours", "redlaser");
    AttachDynamicObjectToObject(Topgun_Platforms[6], Topgun_Base, 13.24, 0, 6.97, 0.00, 90.00, 90.00, 0);
    //TopGun

    //TheJail
    CreateDynamicObject(19128, 840.91, -2064.93, 13.59, -90.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 841.91, -2064.95, 12.59, -90.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 842.91, -2064.97, 11.59, -90.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 834.41, -2064.93, 13.59, -90.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 833.41, -2064.95, 12.59, -90.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 832.41, -2064.96, 11.59, -90.00, 0.00, 0.00, ff_virtualworld);


    Jail_Base2 = CreateDynamicObject(18878, 837.54, -2060.57, 27.11, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Jail_Base2, 3, 0, "MatColours", "samporange");

    Jail_Unused[0] = CreateDynamicObject(18980, 838.52, -2064.80, 18.93, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Unused[1] = CreateDynamicObject(18980, 837.52, -2064.80, 18.93, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Unused[2] = CreateDynamicObject(18980, 836.52, -2064.80, 18.93, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Jail_Unused[0], 0, 18646, "MatColours", "samporange");
    SetDynamicObjectMaterial(Jail_Unused[1], 0, 18646, "MatColours", "red");
    SetDynamicObjectMaterial(Jail_Unused[2], 0, 18646, "MatColours", "samporange");
    Jail_Base = CreateDynamicObject(18980, 837.52, -2063.30, 26.06, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Jail_Base, 0, 18646, "MatColours", "red-2");

    Jail[0] = CreateDynamicObject(19353, 0.00, 0.00, 0.00, 0.0000, 0.0000, 0, ff_virtualworld);
    SetDynamicObjectMaterialText(Jail[0], 0, "J", 10, "Impact", 29, 0, -1, 0, 1);
    AttachDynamicObjectToObject(Jail[0], Jail_Base, -0.0307, 0.4546, 5.24, 0, 0, 90, 1);

    Jail[1] = CreateDynamicObject(19353, 0.00, 0.00, 0.00, 0.0000, 0.0000, 0, ff_virtualworld);
    SetDynamicObjectMaterialText(Jail[1], 0, "A", 10, "Impact", 29, 0, -1, 0, 1);
    AttachDynamicObjectToObject(Jail[1], Jail_Base, -0.0307, 0.4546, 5.24 - 3, 0, 0, 90, 1);

    Jail[2] = CreateDynamicObject(19353, 0.00, 0.00, 0.00, 0.0000, 0.0000, 0, ff_virtualworld);
    SetDynamicObjectMaterialText(Jail[2], 0, "I", 10, "Impact", 29, 0, -1, 0, 1);
    AttachDynamicObjectToObject(Jail[2], Jail_Base, -0.0307, 0.4546, 5.24 - 6, 0, 0, 90, 1);

    Jail[3] = CreateDynamicObject(19353, 0.00, 0.00, 0.00, 0.0000, 0.0000, 0, ff_virtualworld);
    SetDynamicObjectMaterialText(Jail[3], 0, "L", 10, "Impact", 29, 0, -1, 0, 1);
    AttachDynamicObjectToObject(Jail[3], Jail_Base, -0.0307, 0.4546, 5.24 - 9, 0, 0, 90, 1);

    Jail[4] = CreateDynamicObject(19353, 837.4500, -2064.3171, 22.0772, 0.0000, 0.0000, 90, ff_virtualworld);
    SetDynamicObjectMaterialText(Jail[4], 0, "The Jail", 140, "Arial Black", 90, 0, -16468988, 0, 1);

    Jail_BasePlatform = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Jail_BasePlatform, Jail_Base, 0, 0.5104, -10.198, 0, 0, 0, 0);

    Jail_Plataforms[0] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[1] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[2] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[3] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[4] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[5] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Jail_Plataforms[0], Jail_BasePlatform, 3.5, 0, 0, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[1], Jail_BasePlatform, -3.5, 0, 0, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[2], Jail_BasePlatform, 5.2415, 1.7112, 0, 0, 0, 90, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[3], Jail_BasePlatform, -5.2415, 1.7112, 0, 0, 0, 90, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[4], Jail_BasePlatform, 3.5, 3.5, 0, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[5], Jail_BasePlatform, -3.5, 3.5, 0, 0, 0, 0, 1);
    //
    Jail_Plataforms[6] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[7] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[8] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[9] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[10] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[11] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[12] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Jail_Plataforms[6], Jail_BasePlatform, 3.5, 0, -1.2245, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[7], Jail_BasePlatform, -3.5, 0, -1.2245, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[8], Jail_BasePlatform, 5.2415, 1.7112, -1.2245, 0, 0, 90, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[9], Jail_BasePlatform, -5.2415, 1.7112, -1.2245, 0, 0, 90, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[10], Jail_BasePlatform, 3.5, 3.5, -1.2245, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[11], Jail_BasePlatform, -3.5, 3.5, -1.2245, 0, 0, 0, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[12], Jail_BasePlatform, 0, 0, -1.2245, 0, 0, 0, 1);
    //
    Jail_Plataforms[13] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[14] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[15] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[16] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[17] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[18] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[19] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[20] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Jail_Plataforms[13], Jail_BasePlatform, 4.6395, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[14], Jail_BasePlatform, 3.3845, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[15], Jail_BasePlatform, 2.1295, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[16], Jail_BasePlatform, 0.8745, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[17], Jail_BasePlatform, -0.3805, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[18], Jail_BasePlatform, -1.6355, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[19], Jail_BasePlatform, -2.8905, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[20], Jail_BasePlatform, -4.1455, 1.7112, 0.6068, 90.0000, 0.0000, 90.0000, 1);
    //
    Jail_Plataforms[21] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[22] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[23] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[24] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[25] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[26] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[27] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Plataforms[28] = CreateDynamicObject(19304, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Jail_Plataforms[21], 0, 18646, "MatColours", "blue");
    SetDynamicObjectMaterial(Jail_Plataforms[22], 0, 18646, "MatColours", "green");
    SetDynamicObjectMaterial(Jail_Plataforms[23], 0, 18646, "MatColours", "lightblue");
    SetDynamicObjectMaterial(Jail_Plataforms[24], 0, 18646, "MatColours", "orange");
    SetDynamicObjectMaterial(Jail_Plataforms[25], 0, 18646, "MatColours", "red");
    SetDynamicObjectMaterial(Jail_Plataforms[26], 0, 18646, "MatColours", "yellow");
    SetDynamicObjectMaterial(Jail_Plataforms[27], 0, 18646, "MatColours", "samporange");
    SetDynamicObjectMaterial(Jail_Plataforms[28], 0, 18646, "MatColours", "white");
    AttachDynamicObjectToObject(Jail_Plataforms[21], Jail_BasePlatform, 4.6395, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[22], Jail_BasePlatform, 3.3845, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[23], Jail_BasePlatform, 2.1295, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[24], Jail_BasePlatform, 0.8745, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[25], Jail_BasePlatform, -0.3805, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[26], Jail_BasePlatform, -1.6355, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[27], Jail_BasePlatform, -2.8905, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    AttachDynamicObjectToObject(Jail_Plataforms[28], Jail_BasePlatform, -4.1455, 1.7112, -1.8277, 90.0000, 0.0000, 90.0000, 1);
    //Jail_Doors
    Jail_Doors[0] = CreateDynamicObject(19303, 838.4160 + 1.5, -2059.2896, 15.2527, 0.00, 0.00, 0.00, ff_virtualworld);
    Jail_Doors[1] = CreateDynamicObject(19302, 836.6460 - 1.5, -2059.2896, 15.2527, 0.00, 0.00, 0.00, ff_virtualworld);
    ff_door = true;
    //TheJail

    //Projekt
    Projekt_Letters[0] = CreateDynamicObject(19353, 835.2254, -1974.9293, 29.3883, 0.0000, 0.0000, -180, ff_virtualworld);
    SetDynamicObjectMaterialText(Projekt_Letters[0], 0, "1", 140, "Impact", 255, 1, -256, 0, 1);

    Projekt_Letters[1] = CreateDynamicObject(19353, 833.3474, -1966.4117, 12.4387, 0.0000, -90.0000, 180, ff_virtualworld);
    SetDynamicObjectMaterialText(Projekt_Letters[1], 0, "prokekt 1", 140, "Impact", 140, 1, -32256, 0, 1);

    Projekt_Letters[2] = CreateDynamicObject(19353, 833.3474, -1966.4117 - 5, 12.4387, 0.0000, -90.0000, 180, ff_virtualworld);
    SetDynamicObjectMaterialText(Projekt_Letters[2], 0, "prokekt 1", 140, "Impact", 140, 1, -32256, 0, 1);

    Projekt_Letters[3] = CreateDynamicObject(19353, 833.3474, -1966.4117 - 5 * 2, 12.4387, 0.0000, -90.0000, 180, ff_virtualworld);
    SetDynamicObjectMaterialText(Projekt_Letters[3], 0, "prokekt 1", 140, "Impact", 140, 1, -32256, 0, 1);

    Projekt_Letters[4] = CreateDynamicObject(19353, 833.3474, -1966.4117 - 5 * 3, 12.4387, 0.0000, -90.0000, 180, ff_virtualworld);
    SetDynamicObjectMaterialText(Projekt_Letters[4], 0, "prokekt 1", 140, "Impact", 140, 1, -32256, 0, 1);

    SuperProjekt_Base[0] = CreateDynamicObject(18980, 831.33, -1984.52, 19.6652, -45.00, 20.00, 0.00, ff_virtualworld);
    SuperProjekt_Base[1] = CreateDynamicObject(18980, 841.81, -1984.52, 19.6652, -45.00, -20.00, 0.00, ff_virtualworld);
    SuperProjekt_Base[2] = CreateDynamicObject(18980, 831.33, -1965.52, 19.6652, 45.00, 20.00, 0.00, ff_virtualworld);
    SuperProjekt_Base[3] = CreateDynamicObject(18980, 841.81, -1965.52, 19.6652, 45.00, -20.00, 0.00, ff_virtualworld);
    for (new i = 0; i != 4; i++) SetDynamicObjectMaterial(SuperProjekt_Base[i], 0, 18646, "MatColours", "blue");
    Projekt_Unused[0] = CreateDynamicObject(18886, 836.77, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[1] = CreateDynamicObject(18886, 836.99, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[2] = CreateDynamicObject(18886, 837.21, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Base[0] = CreateDynamicObject(18886, 837.43, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Projekt_Base[0], 0, 18646, "MatColours", "red");
    SetDynamicObjectMaterial(Projekt_Base[0], 1, 18646, "MatColours", "samporange");
    SetDynamicObjectMaterial(Projekt_Base[0], 3, 18646, "MatColours", "red");
    Projekt_Unused[3] = CreateDynamicObject(18886, 837.66, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[4] = CreateDynamicObject(18886, 837.88, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[5] = CreateDynamicObject(18886, 836.21, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[6] = CreateDynamicObject(18886, 836.44, -1974.91, 29.3000, 0.00, 90.00, 0.00, ff_virtualworld);
    Projekt_Unused[7] = CreateDynamicObject(18886, 836.224243, -1974.898437, 29.252134, 0.000000, -90.00, 0.000000, ff_virtualworld);
    Projekt_Unused[8] = CreateDynamicObject(18886, 836.457275, -1974.864990, 29.276523, 0.000000, -90.00, 0.000000, ff_virtualworld);
    Projekt_Unused[9] = CreateDynamicObject(18886, 836.727539, -1974.893676, 29.264974, 0.000000, -90.00, 0.000000, ff_virtualworld);
    for (new i = 0; i != 10; i++) {
        SetDynamicObjectMaterial(Projekt_Unused[i], 0, 18646, "MatColours", "red");
        SetDynamicObjectMaterial(Projekt_Unused[i], 1, 18646, "MatColours", "samporange");
        SetDynamicObjectMaterial(Projekt_Unused[i], 3, 18646, "MatColours", "red");
    }

    Projekt_Platform[0] = CreateDynamicObject(18762, 0.00, 10.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Projekt_Platform[0], 0, 18646, "MatColours", "lightblue");
    AttachDynamicObjectToObject(Projekt_Platform[0], Projekt_Base[0], 3.82, 0.0521, -1.00, 0.00, 90.00, 0.00);
    Projekt_Platform[1] = CreateDynamicObject(18762, 0.00, 10.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Projekt_Platform[1], 0, 18646, "MatColours", "lightblue");
    AttachDynamicObjectToObject(Projekt_Platform[1], Projekt_Base[0], 8.82, 0.0521, -1.00, 0.00, 90.00, 0.00);
    Projekt_Platform[2] = CreateDynamicObject(18762, 0.00, 10.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Projekt_Platform[2], 0, 18646, "MatColours", "lightblue");
    AttachDynamicObjectToObject(Projekt_Platform[2], Projekt_Base[0], 13.82, 0.0521, -1.00, 0.00, 90.00, 0.00);

    Projekt_Base[1] = CreateDynamicObject(18886, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Base[1], Projekt_Base[0], 14.8962, 0.0, -1.040, 0.0000, -90.0000, 0.0000);
    Projekt_Base[2] = CreateDynamicObject(18886, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Base[2], Projekt_Base[1], 0.00, 0.00, -2.1052, 180.0000, 0.0000, 0.0000);

    Projekt_Seats[0] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[0], Projekt_Base[1], -0.6162, 2.0824, -0.9604, 0.0000, 0.0000, 195.0000);
    Projekt_Seats[1] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[1], Projekt_Base[1], -1.4831, 1.4819, -0.9604, 0.0000, 0.0000, 225.0000);
    Projekt_Seats[2] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[2], Projekt_Base[1], -2.1035, 0.5745, -0.9604, 0.0000, 0.0000, 255.0000);
    Projekt_Seats[3] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[3], Projekt_Base[1], -2.1016, -0.5955, -0.9604, 0.0000, 0.0000, 285.0000);
    Projekt_Seats[4] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[4], Projekt_Base[1], -1.5044, -1.5795, -0.9604, 0.0000, 0.0000, 315.0000);
    Projekt_Seats[5] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[5], Projekt_Base[1], -0.5645, -2.1727, -0.9604, 0.0000, 0.0000, 345.0000);
    Projekt_Seats[6] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[6], Projekt_Base[1], 0.573, -2.1273, -0.9604, 0.0000, 0.0000, -345.0000);
    Projekt_Seats[7] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[7], Projekt_Base[1], 1.5295, -1.5389, -0.9604, 0.0000, 0.0000, -315.0000);
    Projekt_Seats[8] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[8], Projekt_Base[1], 2.1129, -0.5817, -0.9604, 0.0000, 0.0000, -285.0000);
    Projekt_Seats[9] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[9], Projekt_Base[1], 2.0814, 0.5617, -0.9604, 0.0000, 0.0000, -255.0000);
    Projekt_Seats[10] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[10], Projekt_Base[1], 1.5124, 1.5704, -0.9604, 0.0000, 0.0000, -225.0000);
    Projekt_Seats[11] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Projekt_Seats[11], Projekt_Base[1], 0.5522, 2.0793, -0.9604, 0.0000, 0.0000, -195.0000);
    //Projekt

    //Observer
    CreateDynamicObject(18763, 811.57709, -1879.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(19278, 811.50995, -1879.43152, -41.69551, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 808.57709, -1879.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 808.57709, -1882.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 811.57709, -1882.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 814.57709, -1879.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 814.57709, -1882.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 808.57709, -1876.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 811.57709, -1876.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18763, 814.57709, -1876.37842, 3.59470, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(8615, 814.54871, -1872.88013, 6.15357, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(18980, 801.97620, -1879.02612, -4.13480, 0.00000, 20.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18980, 811.60822, -1888.93835, -4.13480, 0.00000, 20.00000, 90.00000, ff_virtualworld);
    CreateDynamicObject(18980, 821.15430, -1879.26160, -4.13480, 0.00000, 20.00000, 180.00000, ff_virtualworld);
    CreateDynamicObject(18980, 811.28381, -1869.85706, -4.13480, 0.00000, 20.00000, -90.00000, ff_virtualworld);

    Observer_Base = CreateDynamicObject(19278, 811.50995, -1879.43152, -38.23802, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    Observer_Seats[0] = CreateDynamicObject(19316, 809.98859, -1882.72485, 10.99730, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    AttachDynamicObjectToObject(Observer_Seats[0], Observer_Base, -1.5213, -3.2934, 49.2353, 0, 0, 0, 1);
    Observer_Seats[1] = CreateDynamicObject(19316, 812.98859, -1876.22485, 10.99730, 0.00000, 0.00000, 180.00000, ff_virtualworld);
    AttachDynamicObjectToObject(Observer_Seats[1], Observer_Base, 1.5213, 3.2934, 49.2353, 0, 0, 180, 1);
    //Observer

    //FerrisWheel
    CreateDynamicObject(18878, 844.54, -2033.57, 27.11, 0.00, 0.00, 90.00, ff_virtualworld);
    FerrisWheel_Base = CreateDynamicObject(18877, 844.53, -2033.59, 27.11, 0.00, 0.00, 90.00, ff_virtualworld);
    FerrisWheel_Seats[0] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[0], FerrisWheel_Base, 0.0699, 0.0600, -11.7500, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[1] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[1], FerrisWheel_Base, -6.9100, -0.0899, -9.5000, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[2] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[2], FerrisWheel_Base, 11.1600, 0.0000, -3.6300, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[3] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[3], FerrisWheel_Base, -11.1600, -0.0399, 3.6499, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[4] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[4], FerrisWheel_Base, -6.9100, -0.0899, 9.4799, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[5] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[5], FerrisWheel_Base, 0.0699, 0.0600, 11.7500, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[6] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[6], FerrisWheel_Base, 6.9599, 0.0100, -9.5000, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[7] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[7], FerrisWheel_Base, -11.1600, -0.0399, -3.6300, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[8] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[8], FerrisWheel_Base, 11.1600, 0.0000, 3.6499, 0.0000, 0.0000, 90.0000, 0);
    FerrisWheel_Seats[9] = CreateDynamicObject(19316, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(FerrisWheel_Seats[9], FerrisWheel_Base, 7.0399, -0.0200, 9.3600, 0.0000, 0.0000, 90.0000, 0);
    //FerrisWheel

    //Cars
    Cars_Vehs[0] = CreateVehicle(539, 795.6931, -1864.1338, 8.8227, 0.0000, -1, -1, 100);
    SetVehicleHealth(Cars_Vehs[0], 99999999);
    Cars_Vehs[1] = CreateVehicle(539, 795.6931, -1858.1338, 8.8227, 0.0000, -1, -1, 100);
    SetVehicleHealth(Cars_Vehs[1], 99999999);
    Cars_Vehs[2] = CreateVehicle(539, 795.6931, -1852.1338, 8.8227, 0.0000, -1, -1, 100);
    SetVehicleHealth(Cars_Vehs[2], 99999999);
    Cars_Vehs[3] = CreateVehicle(539, 795.6931, -1846.6338, 8.8227, 0.0000, -1, -1, 100);
    SetVehicleHealth(Cars_Vehs[3], 99999999);

    Cars_Base[0] = CreateDynamicObject(18981, 805.56824, -1854.58850, 7.89529, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Base[0], 0, 18646, "MatColours", "grey-80-percent");

    Cars_Base[1] = CreateDynamicObject(18981, 805.56824, -1854.58850, 12.6336, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Base[1], 0, 18772, "TunnelSections", "metalflooring44-2");

    Cars_Base[2] = CreateDynamicObject(18981, 805.56824, -1854.58850, 13.6411, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Base[2], 0, 18646, "MatColours", "green");

    Cars_Unused[0] = CreateDynamicObject(18762, 795.57037, -1841.59644, 8.50696, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[0], 0, 18646, "MatColours", "blue");
    Cars_Unused[1] = CreateDynamicObject(18762, 799.07037, -1841.59644, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[1], 0, 18646, "MatColours", "green");
    Cars_Unused[2] = CreateDynamicObject(18762, 803.57037, -1841.59644, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[2], 0, 18646, "MatColours", "grey");
    Cars_Unused[3] = CreateDynamicObject(18762, 808.57037, -1841.59644, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[3], 0, 18646, "MatColours", "lightblue");
    Cars_Unused[4] = CreateDynamicObject(18762, 813.57037, -1841.59644, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[4], 0, 18646, "MatColours", "orange");
    Cars_Unused[5] = CreateDynamicObject(18762, 818.57037, -1841.59644, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[5], 0, 18646, "MatColours", "red");
    Cars_Unused[6] = CreateDynamicObject(18762, 818.57037, -1844.59644, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[6], 0, 18646, "MatColours", "samporange");
    Cars_Unused[7] = CreateDynamicObject(18762, 818.57037, -1849.59644, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[7], 0, 18646, "MatColours", "white");
    Cars_Unused[8] = CreateDynamicObject(18762, 818.57037, -1854.59644, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[8], 0, 18646, "MatColours", "yellow");
    Cars_Unused[9] = CreateDynamicObject(18762, 818.57037, -1859.59644, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[9], 0, 18646, "MatColours", "blue");
    Cars_Unused[10] = CreateDynamicObject(18762, 818.57037, -1864.59644, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[10], 0, 18646, "MatColours", "green");
    Cars_Unused[11] = CreateDynamicObject(18762, 815.69415, -1866.60876, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[11], 0, 18646, "MatColours", "grey");
    Cars_Unused[12] = CreateDynamicObject(18762, 810.69421, -1866.60876, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[12], 0, 18646, "MatColours", "lightblue");
    Cars_Unused[13] = CreateDynamicObject(18762, 805.69421, -1866.60876, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[13], 0, 18646, "MatColours", "orange");
    Cars_Unused[14] = CreateDynamicObject(18762, 800.69421, -1866.60876, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[14], 0, 18646, "MatColours", "red");
    Cars_Unused[15] = CreateDynamicObject(18762, 795.69421, -1866.60876, 8.50700, 0.00000, 90.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[15], 0, 18646, "MatColours", "samporange");
    Cars_Unused[16] = CreateDynamicObject(18762, 793.70789, -1863.64575, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[16], 0, 18646, "MatColours", "white");
    Cars_Unused[17] = CreateDynamicObject(18762, 793.70789, -1859.14575, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[17], 0, 18646, "MatColours", "yellow");
    Cars_Unused[18] = CreateDynamicObject(18762, 793.70789, -1854.14575, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[18], 0, 18646, "MatColours", "blue");
    Cars_Unused[19] = CreateDynamicObject(18762, 793.70789, -1849.14575, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[19], 0, 18646, "MatColours", "green");
    Cars_Unused[20] = CreateDynamicObject(18762, 793.70789, -1844.14575, 8.50700, 0.00000, 90.00000, 90.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[20], 0, 18646, "MatColours", "grey");

    CreateDynamicObject(11472, 799.66150, -1840.49182, 5.96356, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(11472, 812.16150, -1840.49182, 5.96360, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(11472, 814.16150, -1840.49182, 5.96360, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(11472, 801.66150, -1840.49182, 5.96360, 0.00000, 0.00000, -90.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1842.51160, 5.73792, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1847.01160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1851.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1856.01160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1861.01160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 793.60577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 798.10577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 803.60577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 808.60577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 814.60577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 818.10577, -1866.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 818.10577, -1861.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 818.10577, -1857.51160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    CreateDynamicObject(18762, 818.10577, -1851.01160, 5.73790, 0.00000, 0.00000, 0.00000, ff_virtualworld);

    Cars_Unused[21] = CreateDynamicObject(18762, 793.69147, -1866.56787, 10.82597, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[21], 0, 18646, "MatColours", "blue");
    Cars_Unused[22] = CreateDynamicObject(18762, 817.19153, -1866.56787, 10.82600, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[22], 0, 18646, "MatColours", "blue");
    Cars_Unused[23] = CreateDynamicObject(18762, 793.69153, -1842.56787, 10.82600, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[23], 0, 18646, "MatColours", "blue");
    Cars_Unused[24] = CreateDynamicObject(18762, 817.69153, -1842.56787, 10.82600, 0.00000, 0.00000, 0.00000, ff_virtualworld);
    SetDynamicObjectMaterial(Cars_Unused[24], 0, 18646, "MatColours", "blue");
    //Cars

    //Caida Libre
    //parcela
    CreateDynamicObject(983, 832.40, -2008.64, 12.59, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(983, 837.57, -2013.86, 12.59, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(983, 842.81, -2008.66, 12.59, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(983, 837.57, -2003.86, 12.59, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(983, 842.81, -2008.66, 12.59, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(983, 837.57, -2013.86, 12.59, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(983, 832.40, -2008.64, 12.59, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(983, 837.57, -2003.86, 12.59, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 837.44, -2006.33, 11.85, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 837.44, -2011.33, 11.85, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 839.94, -2008.83, 11.85, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19425, 834.94, -2008.83, 11.85, 0.00, 0.00, 90.00, ff_virtualworld);

    Caida_Unused[0] = CreateDynamicObject(18980, 837.52, -2007.80, 18.93, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[0], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[1] = CreateDynamicObject(18980, 836.98, -2008.01, 18.93, 0.00, 0.00, 40.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[1], 0, 18646, "MatColours", "blue");
    Caida_Unused[2] = CreateDynamicObject(18980, 836.71, -2008.53, 18.93, 0.00, 0.00, 80.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[2], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[3] = CreateDynamicObject(18980, 836.82, -2009.10, 18.93, 0.00, 0.00, 120.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[3], 0, 18646, "MatColours", "blue");
    Caida_Unused[4] = CreateDynamicObject(18980, 837.28, -2009.49, 18.93, 0.00, 0.00, 160.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[4], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[5] = CreateDynamicObject(18980, 837.89, -2009.48, 18.93, 0.00, 0.00, 200.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[5], 0, 18646, "MatColours", "blue");
    Caida_Unused[6] = CreateDynamicObject(18980, 838.33, -2009.10, 18.93, 0.00, 0.00, 240.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[6], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[7] = CreateDynamicObject(18980, 838.42, -2008.51, 18.93, 0.00, 0.00, 280.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[7], 0, 18646, "MatColours", "blue");
    Caida_Unused[8] = CreateDynamicObject(18980, 838.08, -2007.99, 18.93, 0.00, 0.00, 320.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[8], 0, 18646, "MatColours", "lightblue");
    //++
    Caida_Unused[9] = CreateDynamicObject(18980, 837.52, -2007.80, 18.93 + 24.9862, 0.00, 0.00, 0.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[9], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[10] = CreateDynamicObject(18980, 836.98, -2008.01, 18.93 + 24.9862, 0.00, 0.00, 40.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[10], 0, 18646, "MatColours", "blue");
    Caida_Unused[11] = CreateDynamicObject(18980, 836.71, -2008.53, 18.93 + 24.9862, 0.00, 0.00, 80.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[11], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[12] = CreateDynamicObject(18980, 836.82, -2009.10, 18.93 + 24.9862, 0.00, 0.00, 120.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[12], 0, 18646, "MatColours", "blue");
    Caida_Unused[13] = CreateDynamicObject(18980, 837.28, -2009.49, 18.93 + 24.9862, 0.00, 0.00, 160.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[13], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[14] = CreateDynamicObject(18980, 837.89, -2009.48, 18.93 + 24.9862, 0.00, 0.00, 200.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[14], 0, 18646, "MatColours", "blue");
    Caida_Unused[15] = CreateDynamicObject(18980, 838.33, -2009.10, 18.93 + 24.9862, 0.00, 0.00, 240.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[15], 0, 18646, "MatColours", "lightblue");
    Caida_Unused[16] = CreateDynamicObject(18980, 838.42, -2008.51, 18.93 + 24.9862, 0.00, 0.00, 280.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[16], 0, 18646, "MatColours", "blue");
    Caida_Unused[17] = CreateDynamicObject(18980, 838.08, -2007.99, 18.93 + 24.9862, 0.00, 0.00, 320.00, ff_virtualworld);
    SetDynamicObjectMaterial(Caida_Unused[17], 0, 18646, "MatColours", "lightblue");

    Caida_Unused[18] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 0.00, ff_virtualworld);
    Caida_Unused[19] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 2.50, ff_virtualworld);
    Caida_Unused[20] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 5.50, ff_virtualworld);
    Caida_Unused[21] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 11.50, ff_virtualworld);
    Caida_Unused[22] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 19.00, ff_virtualworld);
    Caida_Unused[23] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 32.00, ff_virtualworld);
    Caida_Unused[24] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 48.00, ff_virtualworld);
    Caida_Unused[25] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 62.50, ff_virtualworld);
    Caida_Unused[26] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 78.50, ff_virtualworld);
    Caida_Unused[27] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 93.50, ff_virtualworld);
    Caida_Unused[28] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 108.00, ff_virtualworld);
    Caida_Unused[29] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 114.50, ff_virtualworld);
    Caida_Unused[30] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 124.50, ff_virtualworld);
    Caida_Unused[31] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 141.00, ff_virtualworld);
    Caida_Unused[32] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 165.00, ff_virtualworld);
    Caida_Unused[33] = CreateDynamicObject(18764, 837.61, -2008.76, 58.92, 0.00, 0.00, 174.50, ff_virtualworld);
    for (new i = 18; i != 34; i++) SetDynamicObjectMaterial(Caida_Unused[i], 0, 18646, "MatColours", "samporange");

    //prosigamos
    Caida_Base[0] = CreateDynamicObject(18886, 837.60, -2008.66, 13.52, 0.00, 0.00, 0.00, ff_virtualworld);
    Caida_Base[1] = CreateDynamicObject(18886, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Base[1], Caida_Base[0], 0, 0, -2.1052, 180.0000, 0.0000, 0.0000);

    Caida_Seats[0] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[0], Caida_Base[0], -0.6162, 2.0824, -0.9604, 0.0000, 0.0000, 195.0000);
    Caida_Seats[1] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[1], Caida_Base[0], -1.4831, 1.4819, -0.9604, 0.0000, 0.0000, 225.0000);
    Caida_Seats[2] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[2], Caida_Base[0], -2.1035, 0.5745, -0.9604, 0.0000, 0.0000, 255.0000);
    Caida_Seats[3] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[3], Caida_Base[0], -2.1016, -0.5955, -0.9604, 0.0000, 0.0000, 285.0000);
    Caida_Seats[4] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[4], Caida_Base[0], -1.5044, -1.5795, -0.9604, 0.0000, 0.0000, 315.0000);
    Caida_Seats[5] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[5], Caida_Base[0], -0.5645, -2.1727, -0.9604, 0.0000, 0.0000, 345.0000);
    Caida_Seats[6] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[6], Caida_Base[0], 0.573, -2.1273, -0.9604, 0.0000, 0.0000, -345.0000);
    Caida_Seats[7] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[7], Caida_Base[0], 1.5295, -1.5389, -0.9604, 0.0000, 0.0000, -315.0000);
    Caida_Seats[8] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[8], Caida_Base[0], 2.1129, -0.5817, -0.9604, 0.0000, 0.0000, -285.0000);
    Caida_Seats[9] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[9], Caida_Base[0], 2.0814, 0.5617, -0.9604, 0.0000, 0.0000, -255.0000);
    Caida_Seats[10] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[10], Caida_Base[0], 1.5124, 1.5704, -0.9604, 0.0000, 0.0000, -225.0000);
    Caida_Seats[11] = CreateDynamicObject(1562, 0, 0, 0, 0.00, 0.00, 0.00, ff_virtualworld);
    AttachDynamicObjectToObject(Caida_Seats[11], Caida_Base[0], 0.5522, 2.0793, -0.9604, 0.0000, 0.0000, -195.0000);
    //Caida Libre

    //Crazy Cow
    CreateDynamicObject(18886, 827.79, -1941.21, 13.25, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1941.21, 12.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1938.21, 13.25, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1935.21, 13.25, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1932.21, 13.25, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1938.21, 12.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1935.21, 12.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(18886, 827.79, -1932.21, 12.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(983, 828.06, -1928.82, 12.54, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(984, 835.73, -1936.96, 12.54, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(14409, 834.93, -1932.74, 9.32, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(14409, 834.93, -1936.74, 9.32, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(14409, 834.93, -1940.74, 9.32, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 835.73, -1936.96, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(983, 828.06, -1928.82, 12.54, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(983, 828.06, -1944.82, 12.54, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(983, 828.06, -1944.82, 12.54, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 823.23, -1936.96, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(984, 823.23, -1936.96, 12.54, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(19362, 832.21, -1942.79, 10.76, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 832.24, -1930.73, 10.76, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.05, -1939.54, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.05, -1939.54, 12.64, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.05, -1936.54, 12.64, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.04, -1933.46, 12.64, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.04, -1933.46, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.05, -1936.54, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.05, -1942.54, 12.64, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 828.04, -1930.46, 12.64, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 825.05, -1941.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 825.05, -1937.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 825.05, -1933.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 825.05, -1931.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 828.43, -1943.48, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 825.67, -1943.46, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 824.15, -1941.87, 10.89, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 824.15, -1938.37, 10.89, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 824.15, -1934.87, 10.89, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 824.15, -1931.37, 10.89, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(2631, 831.05, -1941.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 831.05, -1937.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 831.05, -1933.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2631, 831.05, -1931.54, 12.64, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 829.21, -1942.79, 10.76, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 830.39, -1943.46, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 828.43, -1929.48, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 830.35, -1929.50, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 825.67, -1929.48, 10.89, 0.00, 0.00, 90.00, ff_virtualworld);

    ff_Cow_Seats[0] = CreateDynamicObject(16442, 828.37, -1940.99, 13.79, 0.00, 0.00, 0.00, ff_virtualworld);
    ff_Cow_Seats[1] = CreateDynamicObject(16442, 828.37, -1937.99, 13.79, 0.00, 0.00, 0.00, ff_virtualworld);
    ff_Cow_Seats[2] = CreateDynamicObject(16442, 828.37, -1934.99, 13.79, 0.00, 0.00, 0.00, ff_virtualworld);
    ff_Cow_Seats[3] = CreateDynamicObject(16442, 828.37, -1931.99, 13.79, 0.00, 0.00, 0.00, ff_virtualworld);
    //Crazy Cow

    //Funfair
    CreateDynamicObject(982, 826.52, -1974.96, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(984, 836.25, -1993.16, 12.54, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(982, 826.52, -1974.96, 12.54, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(984, 836.25, -1993.16, 12.54, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 836.25, -1956.66, 12.54, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(984, 836.25, -1956.66, 12.54, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(982, 846.02, -1974.96, 12.54, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(982, 846.02, -1974.96, 12.54, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 842.63, -1959.18, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 839.13, -1959.18, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 835.63, -1959.18, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 832.13, -1959.18, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 832.13, -1990.68, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 835.63, -1990.68, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 839.13, -1990.68, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19425, 842.63, -1990.68, 11.86, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(14409, 829.20, -1966.46, 9.32, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(14409, 829.20, -1970.46, 9.32, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(14409, 829.20, -1974.46, 9.32, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(14409, 829.20, -1978.46, 9.32, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(14409, 829.20, -1982.46, 9.32, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(14409, 834.74, -1987.99, 9.32, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(14409, 838.74, -1987.99, 9.32, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(14409, 834.74, -1960.99, 9.32, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(14409, 838.74, -1960.99, 9.32, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 832.75, -1962.88, 10.76, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1966.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 831.08, -1984.45, 10.76, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 832.75, -1985.88, 10.76, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 840.75, -1985.88, 10.76, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 840.75, -1962.88, 10.76, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 831.08, -1964.45, 10.76, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1966.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1969.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1972.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.46, -1975.06, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1978.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1981.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 834.45, -1984.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1969.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1972.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1975.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1978.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.96, -1981.06, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 837.95, -1984.08, 12.42, 0.00, 90.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.16, -1964.42, 10.75, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.15, -1984.40, 10.75, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1982.90, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1979.90, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1976.90, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1973.90, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1970.90, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1968.40, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19362, 839.65, -1965.40, 10.75, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 836.18, -1981.23, 12.51, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(19128, 836.18, -1968.23, 12.51, 0.00, 0.00, 0.00, ff_virtualworld);
    //adornos total funfair
    CreateDynamicObject(10838, 836.33, -1830.35, 25.84, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(6299, 843.55, -1856.95, 13.71, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(620, 836.82, -1842.31, 11.44, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(620, 836.82, -1915.81, 11.44, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(620, 836.82, -1950.31, 11.44, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(620, 836.82, -1997.81, 11.44, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(620, 836.82, -2043.81, 11.44, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(6050, 823.62, -1912.54, 13.48, 0.00, 0.00, 0.00, ff_virtualworld);
    CreateDynamicObject(6299, 830.57, -2016.44, 13.71, 0.00, 0.00, 180.00, ff_virtualworld);
    CreateDynamicObject(2232, 840.02, -1902.25, 12.47, 0.00, 0.00, 230.00, ff_virtualworld);
    CreateDynamicObject(2232, 839.55, -1902.83, 12.47, 0.00, 0.00, 230.00, ff_virtualworld);
    CreateDynamicObject(2232, 839.82, -1902.61, 13.58, 0.00, 0.00, 230.00, ff_virtualworld);
    CreateDynamicObject(2232, 832.41, -1930.10, 12.47, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2232, 832.41, -1943.60, 12.47, 0.00, 0.00, 90.00, ff_virtualworld);
    CreateDynamicObject(2232, 833.35, -1984.56, 13.04, 0.00, 0.00, -142.00, ff_virtualworld);
    CreateDynamicObject(2232, 832.01, -1985.55, 12.45, 0.00, 0.00, -90.00, ff_virtualworld);
    CreateDynamicObject(2232, 841.09, -2023.61, 13.56, 0.00, 0.00, -69.00, ff_virtualworld);
    CreateVehicle(588, 825.7172, -2049.7195, 12.7904, 40.0000, -1, -1, 100);
    //Funfair
    return 1;
}

hook OnDynamicObjectMoved(objectid) {
    //Roller
    if (objectid == ff_Roller_Platform) {
        new Float:pos[3];
        GetDynamicObjectPos(ff_Roller_Platform, pos[0], pos[1], pos[2]);
        if (pos[2] == 25.5624) SetTimer("DownRollerBase", 5000, 0);
    }
    //Roller

    //TopGun
    if (objectid == Topgun_Stairs[0]) {
        if (ff_stair) {
            new Float:pos[3];
            GetDynamicObjectPos(Topgun_Base, pos[0], pos[1], pos[2]);
            new Float:rot[3];
            GetDynamicObjectRot(Topgun_Base, rot[0], rot[1], rot[2]);
            if (rot[0] == 0.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, -180.00, 90.00, 90.00);
        }
    }
    //TopGun

    //Crazy Cow
    if (objectid == ff_Cow_Seats[0]) {
        new Float:pos[12];
        GetDynamicObjectPos(ff_Cow_Seats[0], pos[0], pos[1], pos[2]);
        GetDynamicObjectPos(ff_Cow_Seats[1], pos[3], pos[4], pos[5]);
        GetDynamicObjectPos(ff_Cow_Seats[2], pos[6], pos[7], pos[8]);
        GetDynamicObjectPos(ff_Cow_Seats[3], pos[9], pos[10], pos[11]);

        if (ff_ret == -1) return 1;
        else if (ff_ret == 0) {
            MoveDynamicObject(ff_Cow_Seats[0], pos[0], pos[1], pos[2] - 0.05, 0.5, -random(10), -random(10), -random(5));
            MoveDynamicObject(ff_Cow_Seats[1], pos[3], pos[4], pos[5] - 0.05, 0.5, -random(10), -random(10), -random(5));
            MoveDynamicObject(ff_Cow_Seats[2], pos[6], pos[7], pos[8] - 0.05, 0.5, -random(10), -random(10), -random(5));
            MoveDynamicObject(ff_Cow_Seats[3], pos[9], pos[10], pos[11] - 0.05, 0.5, -random(10), -random(10), -random(5));
            ff_ret = 1;
        } else if (ff_ret == 1) {
            MoveDynamicObject(ff_Cow_Seats[0], pos[0], pos[1], pos[2] + 0.05, 0.5, random(10), random(10), random(5));
            MoveDynamicObject(ff_Cow_Seats[1], pos[3], pos[4], pos[5] + 0.05, 0.5, random(10), random(10), random(5));
            MoveDynamicObject(ff_Cow_Seats[2], pos[6], pos[7], pos[8] + 0.05, 0.5, random(10), random(10), random(5));
            MoveDynamicObject(ff_Cow_Seats[3], pos[9], pos[10], pos[11] + 0.05, 0.5, random(10), random(10), random(5));
            ff_ret = 0;
        }
    }
    //Crazy Cow
    return 1;
}

hook OnDynObjectMoved(objectid) {
    //Carousel
    if (objectid == ff_Carousel_Base) {
        new Float:pos[3];
        GetDynamicObjectPos(ff_Carousel_Base, pos[0], pos[1], pos[2]);

        new Float:rot[3];
        GetDynamicObjectRot(ff_Carousel_Base, rot[0], rot[1], rot[2]);

        if (rot[2] == 180) MoveDynamicObject(ff_Carousel_Base, pos[0], pos[1], pos[2] - 0.1005, 0.01, 0.00, 0.00, 360.00);
        else if (rot[2] == 360) MoveDynamicObject(ff_Carousel_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, 0.00, 0.00, 0.00);
    }
    //Carousel

    //Revolution
    if (objectid == ff_Revolution_Base) {
        new Float:pos[3];
        GetDynamicObjectPos(ff_Revolution_Base, pos[0], pos[1], pos[2]);

        new Float:rot[3];
        GetDynamicObjectRot(ff_Revolution_Base, rot[0], rot[1], rot[2]);

        if (rot[2] == 180) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] - 0.1005, 0.02, 0.00, 0.00, 360.00);
        else if (rot[2] == 360) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] + 0.1005, 0.033, 0.00, 0.00, -170.00);
        else if (rot[2] == -170) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] - 0.1005, 0.03, 0.00, 0.00, -350.00);
        else if (rot[2] == -350) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] + 0.1005, 0.02, 0.00, 0.00, -150.00);
        else if (rot[2] == -150) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] - 0.1005, 0.1, 0.00, 0.00, -180.00);
        else if (rot[2] == -180) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, 0.00, 0.00, 0.00);
    }
    //Revolution

    //TopGun
    if (objectid == Topgun_Base) {
        new Float:pos[3];
        GetDynamicObjectPos(Topgun_Base, pos[0], pos[1], pos[2]);
        new Float:rot[3];
        GetDynamicObjectRot(Topgun_Base, rot[0], rot[1], rot[2]);
        if (rot[0] == -180.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] - 0.1005, 0.02, -360.00, 90.00, 90.00);
        else if (rot[0] == -360.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] + 0.1005, 0.03, -181.00, 90.00, 90.00);
        else if (rot[0] == -181.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] + 0.1005, 0.05, -361.00, 90.00, 90.00);
        else if (rot[0] == -361.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] - 0.1005, 0.04, -182.00, 90.00, 90.00);
        else if (rot[0] == -182.00) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] - 0.1005, 0.02, -5.0, 90.00, 90.00);
        else if (rot[0] == -5.0) MoveDynamicObject(Topgun_Base, pos[0], pos[1], pos[2] + 0.1005, 0.1, 0.00, 90.00, 90.00);
        else if (rot[0] == 0.0) {
            new Float:posa[6];
            GetDynamicObjectPos(Topgun_Stairs[0], posa[0], posa[1], posa[2]);
            GetDynamicObjectPos(Topgun_Stairs[1], posa[3], posa[4], posa[5]);
            MoveDynamicObject(Topgun_Stairs[0], posa[0], posa[1], posa[2] + 3.5, 1.5);
            MoveDynamicObject(Topgun_Stairs[1], posa[3], posa[4], posa[5] + 3.5, 1.5);
            ff_stair = false;
        }
    }
    //TopGun

    //TheJail
    if (objectid == Jail_Doors[0]) {
        if (!ff_door) {
            if (IsObjectMoving(Jail_Base)) return 1;
            if (IsObjectMoving(Jail_Doors[0])) return 1;
            new Float:pos[3];
            GetDynamicObjectPos(Jail_Base, pos[0], pos[1], pos[2]);
            new Float:rot[3];
            GetDynamicObjectRot(Jail_Base, rot[0], rot[1], rot[2]);
            AttachDynamicObjectToObject(Jail_Doors[0], Jail_BasePlatform, 0.894, 3.5, -0.6093, 0, 0, 0, 1);
            AttachDynamicObjectToObject(Jail_Doors[1], Jail_BasePlatform, -0.894, 3.5, -0.6093, 0, 0, 0, 1);
            if (rot[1] == 0.00) MoveDynamicObject(Jail_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, 0.0, 180.0, 0);
        }
    }

    if (objectid == Jail_Base) {
        new Float:t[3];
        GetDynamicObjectRot(Jail_Base, t[0], t[1], t[2]);
        if (t[0] == 0.0 && t[1] == 180.0 && t[2] == 0.0) {
            new Float:pos[3];
            GetDynamicObjectPos(Jail_Base, pos[0], pos[1], pos[2]);
            MoveDynamicObject(Jail_Base, pos[0], pos[1], pos[2] - 0.1005, 0.01, 0.0, -359.0, 0);
        } else if (t[0] == 0.0 && t[1] == -359.0 && t[2] == 0.0) {
            new Float:pos[3];
            GetDynamicObjectPos(Jail_Base, pos[0], pos[1], pos[2]);
            MoveDynamicObject(Jail_Base, pos[0], pos[1], pos[2] - 0.005, 0.1, 0.0, 0.0, 0);
        } else if (t[0] == 0.0 && t[1] == 0.0 && t[2] == 0.0) {
            new Float:pos[6];
            GetDynamicObjectPos(Jail_Doors[0], pos[0], pos[1], pos[2]);
            GetDynamicObjectPos(Jail_Doors[1], pos[3], pos[4], pos[5]);
            DestroyDynamicObjectEx(Jail_Doors[0]);
            DestroyDynamicObjectEx(Jail_Doors[1]);
            Jail_Doors[0] = CreateDynamicObject(19303, pos[0], pos[1], pos[2], 0.00, 0.00, 0.00, ff_virtualworld);
            Jail_Doors[1] = CreateDynamicObject(19302, pos[3], pos[4], pos[5], 0.00, 0.00, 0.00, ff_virtualworld);
            new Float:pos2[3];
            GetDynamicObjectPos(Jail_Doors[0], pos2[0], pos2[1], pos2[2]);
            MoveDynamicObject(Jail_Doors[0], pos2[0] + 1.5, pos2[1], pos2[2], 1.5);
            new Float:pos3[3];
            GetDynamicObjectPos(Jail_Doors[1], pos3[0], pos3[1], pos3[2]);
            MoveDynamicObject(Jail_Doors[1], pos3[0] - 1.5, pos3[1], pos3[2], 1.5);
            ff_door = true;
        }
    }
    //TheJail

    //Projekt
    if (objectid == Projekt_Base[0]) {
        new Float:pos[3];
        GetDynamicObjectPos(Projekt_Base[0], pos[0], pos[1], pos[2]);
        new Float:rot[3];
        GetDynamicObjectRot(Projekt_Base[0], rot[0], rot[1], rot[2]);
        if (rot[0] == 10.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.3, 12.00, 90.00, 0.00);
        else if (rot[0] == 12.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.11, -20.00, 90.00, 0.00);
        else if (rot[0] == -20.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.33, -22.00, 90.00, 0.00);
        else if (rot[0] == -22.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, 30.00, 90.00, 0.00);
        else if (rot[0] == 30.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 32.00, 90.00, 0.00);
        else if (rot[0] == 32.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, -50.00, 90.00, 0.00);
        else if (rot[0] == -50.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, -52.00, 90.00, 0.00);
        else if (rot[0] == -52.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, 70.00, 90.00, 0.00);
        else if (rot[0] == 70.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 73.00, 90.00, 0.00);
        else if (rot[0] == 73.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, -1.00, 90.00, 0.00);
        else if (rot[0] == -1.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.12, -95, 90.00, 0.00);
        else if (rot[0] == -95.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.333, -98.00, 90.00, 0.00);
        else if (rot[0] == -98.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.12, 5.00, 90.00, 0.00);
        else if (rot[0] == 5.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, 100.00, 90.00, 0.00);
        else if (rot[0] == 100.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 103.00, 90.00, 0.00);
        else if (rot[0] == 103.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, -5.00, 90.00, 0.00);
        else if (rot[0] == -5.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.12, -150.00, 90.00, 0.00);
        else if (rot[0] == -150.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.333, -153.00, 90.00, 0.00);
        else if (rot[0] == -153.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.12, 6.00, 90.00, 0.00);
        else if (rot[0] == 6.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, 90.00, 90.00, 0.00);
        else if (rot[0] == 90.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 93.00, 90.00, 0.00);
        else if (rot[0] == 93.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.12, -60.00, 90.00, 0.00);
        else if (rot[0] == -60.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, -63.00, 90.00, 0.00);
        else if (rot[0] == -63.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.11, 40.00, 90.00, 0.00);
        else if (rot[0] == 40.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 43.00, 90.00, 0.00);
        else if (rot[0] == 43.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.11, -21.00, 90.00, 0.00);
        else if (rot[0] == -21.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, -23.00, 90.00, 0.00);
        else if (rot[0] == -23.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.11, 9.00, 90.00, 0.00);
        else if (rot[0] == 9.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.333, 11.00, 90.00, 0.00);
        else if (rot[0] == 11.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.10, -3.00, 90.00, 0.00);
        else if (rot[0] == -3.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] - 0.1005, 0.10, 0.00, 90.00, 0.00);
    }
    //Projekt

    //Observer
    if (objectid == Observer_Base) {
        new Float:rot[3];
        GetDynamicObjectRot(Observer_Base, rot[0], rot[1], rot[2]);
        if (rot[2] == 180) SetTimer("DownObserver_Base", 5000, 0);
        else if (rot[2] == 360) SetDynamicObjectRot(Observer_Base, 0, 0, 0);
    }
    //Observer

    //FerrisWheel
    if (objectid == FerrisWheel_Base) {
        new Float:pos[3];
        GetDynamicObjectPos(FerrisWheel_Base, pos[0], pos[1], pos[2]);
        new Float:rot[3];
        GetDynamicObjectRot(FerrisWheel_Base, rot[0], rot[1], rot[2]);
        if (rot[1] == 180.00) MoveDynamicObject(FerrisWheel_Base, pos[0], pos[1], pos[2] - 0.05, 0.01, 0.00, 360.00, 90.00);
        else if (rot[1] == 360.00) MoveDynamicObject(FerrisWheel_Base, pos[0], pos[1], pos[2] + 0.05, 0.01, 0.00, 0.00, 90.00);
    }
    //FerrisWheel

    //Caida Libre
    if (objectid == Caida_Base[0]) {
        new Float:pos[3];
        GetDynamicObjectPos(Caida_Base[0], pos[0], pos[1], pos[2]);
        if (pos[2] == 19.0200) MoveDynamicObject(Caida_Base[0], pos[0], pos[1], pos[2] + 34.5, 2.5);
        else if (pos[2] == 53.52) MoveDynamicObject(Caida_Base[0], pos[0], pos[1], pos[2] + 2.5993, 1.5);
        else if (pos[2] == 56.1193) SetTimer("DownCaida_Base", 3000, 0);
        else if (pos[2] == 18.52) MoveDynamicObject(Caida_Base[0], pos[0], pos[1], pos[2] - 5, 1.5);
    }
    //Caida Libre
    return 1;
}

//Roller
forward DownRollerBase();
public DownRollerBase() {
    new Float:pos[3];
    GetDynamicObjectPos(ff_Roller_Platform, pos[0], pos[1], pos[2]);
    MoveDynamicObject(ff_Roller_Platform, pos[0], pos[1], 5.97849, 2.5);
    return 1;
}
//Roller

//Observer
forward DownObserver_Base();
public DownObserver_Base() {
    new Float:pos[3];
    GetDynamicObjectPos(Observer_Base, pos[0], pos[1], pos[2]);
    MoveDynamicObject(Observer_Base, pos[0], pos[1], pos[2] - 95.61682, 15.5, 0, 0, 360);
    return 1;
}
//Observer

//Caida Libre
forward DownCaida_Base();
public DownCaida_Base() {
    new Float:pos[3];
    GetDynamicObjectPos(Caida_Base[0], pos[0], pos[1], pos[2]);
    MoveDynamicObject(Caida_Base[0], pos[0], pos[1], pos[2] - 37.5993, 15.5);
    return 1;
}
//Caida Libre

//Crazy Cow
forward StopBull();
public StopBull() {
    new Float:pos[12];
    GetDynamicObjectPos(ff_Cow_Seats[0], pos[0], pos[1], pos[2]);
    GetDynamicObjectPos(ff_Cow_Seats[1], pos[3], pos[4], pos[5]);
    GetDynamicObjectPos(ff_Cow_Seats[2], pos[6], pos[7], pos[8]);
    GetDynamicObjectPos(ff_Cow_Seats[3], pos[9], pos[10], pos[11]);
    if (ff_ret == 0) {
        MoveDynamicObject(ff_Cow_Seats[0], pos[0], pos[1], pos[2] - 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[1], pos[3], pos[4], pos[5] - 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[2], pos[6], pos[7], pos[8] - 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[3], pos[9], pos[10], pos[11] - 0.05, 0.5, 0.00, 0.00, 0.00);
        ff_ret = -1;
    } else if (ff_ret == 1) {
        MoveDynamicObject(ff_Cow_Seats[0], pos[0], pos[1], pos[2] + 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[1], pos[3], pos[4], pos[5] + 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[2], pos[6], pos[7], pos[8] + 0.05, 0.5, 0.00, 0.00, 0.00);
        MoveDynamicObject(ff_Cow_Seats[3], pos[9], pos[10], pos[11] + 0.05, 0.5, 0.00, 0.00, 0.00);
        ff_ret = -1;
    }
    return 1;
}

stock ff_roller() {
    if (IsDynamicObjectMoving(ff_Roller_Platform)) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(ff_Roller_Platform, pos[0], pos[1], pos[2]);
    if (pos[2] == 5.97849) MoveDynamicObject(ff_Roller_Platform, pos[0], pos[1], 25.5624, 2.5);
    return 1;
}
stock ff_carousel() {
    if (IsObjectMoving(ff_Carousel_Base)) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(ff_Carousel_Base, pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(ff_Carousel_Base, rot[0], rot[1], rot[2]);
    if (rot[2] == 0.0) MoveDynamicObject(ff_Carousel_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, 0.00, 0.00, 180.00);
    return 1;
}
stock ff_revolution() {
    if (IsObjectMoving(ff_Revolution_Base)) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(ff_Revolution_Base, pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(ff_Revolution_Base, rot[0], rot[1], rot[2]);
    if (rot[2] == 0) MoveDynamicObject(ff_Revolution_Base, pos[0], pos[1], pos[2] + 0.1005, 0.01, 0.00, 0.00, 180.00);
    return 1;
}
stock ff_topgun() {
    if (IsDynamicObjectMoving(Topgun_Stairs[0])) return 1;
    if (IsObjectMoving(Topgun_Base)) return 1;
    new Float:pos[6];
    GetDynamicObjectPos(Topgun_Stairs[0], pos[0], pos[1], pos[2]);
    GetDynamicObjectPos(Topgun_Stairs[1], pos[3], pos[4], pos[5]);
    MoveDynamicObject(Topgun_Stairs[0], pos[0], pos[1], pos[2] - 3.5, 1.5);
    MoveDynamicObject(Topgun_Stairs[1], pos[3], pos[4], pos[5] - 3.5, 1.5);
    ff_stair = true;
    return 1;
}
stock ff_thejail() {
    if (IsObjectMoving(Jail_Base)) return 1;
    if (IsObjectMoving(Jail_Doors[0])) return 1;
    new Float:pos2[3];
    GetDynamicObjectPos(Jail_Doors[0], pos2[0], pos2[1], pos2[2]);
    MoveDynamicObject(Jail_Doors[0], pos2[0] - 1.5, pos2[1], pos2[2], 1.5);
    new Float:pos3[3];
    GetDynamicObjectPos(Jail_Doors[1], pos3[0], pos3[1], pos3[2]);
    MoveDynamicObject(Jail_Doors[1], pos3[0] + 1.5, pos3[1], pos3[2], 1.5);
    ff_door = false;
    return 1;
}
stock ff_project() {
    if (IsObjectMoving(Projekt_Base[0])) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(Projekt_Base[0], pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(Projekt_Base[0], rot[0], rot[1], rot[2]);
    if (rot[0] == 0.00) MoveDynamicObject(Projekt_Base[0], pos[0], pos[1], pos[2] + 0.1005, 0.1, 10.00, 90.00, 0.00);
    return 1;
}
stock ff_observer() {
    if (IsObjectMoving(Observer_Base)) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(Observer_Base, pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(Observer_Base, rot[0], rot[1], rot[2]);
    if (rot[2] == 0) MoveDynamicObject(Observer_Base, pos[0], pos[1], pos[2] + 95.61682, 5.5, 0, 0, 180);
    return 1;
}
stock ff_ferriswheel() {
    if (IsObjectMoving(FerrisWheel_Base)) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(FerrisWheel_Base, pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(FerrisWheel_Base, rot[0], rot[1], rot[2]);
    if (rot[1] == 0.00) MoveDynamicObject(FerrisWheel_Base, pos[0], pos[1], pos[2] + 0.05, 0.01, 0.00, 180.00, 90.00);
    return 1;
}
stock ff_drop() {
    if (IsObjectMoving(Caida_Base[0])) return 1;
    new Float:pos[3];
    GetDynamicObjectPos(Caida_Base[0], pos[0], pos[1], pos[2]);
    if (pos[2] == 13.52) MoveDynamicObject(Caida_Base[0], pos[0], pos[1], pos[2] + 5.5, 1.5);
    return 1;
}
stock ff_cow() {
    if (IsDynamicObjectMoving(ff_Cow_Seats[0])) return 1;
    new Float:pos[12];
    GetDynamicObjectPos(ff_Cow_Seats[0], pos[0], pos[1], pos[2]);
    new Float:rot[3];
    GetDynamicObjectRot(ff_Cow_Seats[0], rot[0], rot[1], rot[2]);
    MoveDynamicObject(ff_Cow_Seats[0], pos[0], pos[1], pos[2] + 0.05, 0.5, random(10), random(10), random(5));
    MoveDynamicObject(ff_Cow_Seats[1], pos[3], pos[4], pos[5] + 0.05, 0.5, random(10), random(10), random(5));
    MoveDynamicObject(ff_Cow_Seats[2], pos[6], pos[7], pos[8] + 0.05, 0.5, random(10), random(10), random(5));
    MoveDynamicObject(ff_Cow_Seats[3], pos[9], pos[10], pos[11] + 0.05, 0.5, random(10), random(10), random(5));
    ff_ret = 0;
    SetTimer("StopBull", BULL_TIME, 0);
    return 1;
}

stock LsFunFairControl(playerid) {
    if (GetPlayerVirtualWorld(playerid) != 0) return 0;
    new string[512] = \
        "Rides\tOperation\n\
	Roller\tselect to run\n\
	Carousel\tselect to run\n\
	Revolution\tselect to run\n\
	Top Gun\tselect to run\n\
	The Jail\tselect to run\n\
	Project\tselect to run\n\
	Observer\tselect to run\n\
	Ferris Wheel\tselect to run\n\
	Drop\tselect to run\n\
	Cow\tselect to run\n\
	Start All Rides\tselect to run";
    FlexPlayerDialog(playerid, "LsFunFairMenu", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}IORP: {FFFFFF}LS Fun Fair", string, "Run", "Cancel");
    return 1;
}

FlexDialog:LsFunFairMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (!strcmp("Roller", inputtext)) {
        ff_roller();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Roller Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Carousel", inputtext)) {
        ff_carousel();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Carousel Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Revolution", inputtext)) {
        ff_revolution();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Revolution Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Top Gun", inputtext)) {
        ff_topgun();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Top Gun Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("The Jail", inputtext)) {
        ff_thejail();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Jail Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Project", inputtext)) {
        ff_project();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Project Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Observer", inputtext)) {
        ff_observer();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Observer Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Ferris Wheel", inputtext)) {
        ff_ferriswheel();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Ferris Wheel Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Drop", inputtext)) {
        ff_drop();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Drop Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Cow", inputtext)) {
        ff_cow();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Bull Ride Started");
        SendClientMessageEx(playerid, -1, string);
    }
    if (!strcmp("Start All Rides", inputtext)) {
        ff_roller();
        ff_carousel();
        ff_revolution();
        ff_topgun();
        ff_thejail();
        ff_project();
        ff_observer();
        ff_ferriswheel();
        ff_drop();
        ff_cow();
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}All Ride's Started");
        SendClientMessageEx(playerid, -1, string);
    }
    return 1;
}

stock IsPlayerNearLSFunFairControl(playerid) {
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 848.3717, -1858.6498, 12.8672)) return true;
    else return false;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys & KEY_SECONDARY_ATTACK && IsPlayerNearLSFunFairControl(playerid)) {
        LsFunFairControl(playerid);
        return ~1;
    }
    return 1;
}