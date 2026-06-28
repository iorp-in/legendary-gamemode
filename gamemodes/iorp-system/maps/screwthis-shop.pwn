// 2420.1287, -1778.8909, 13.5391

hook OnPlayerMapLoad(playerid) {
    RemoveBuildingForPlayer(playerid, 17765, 2436.2188, -1788.5625, 15.0234, 0.25);
    RemoveBuildingForPlayer(playerid, 17523, 2436.2188, -1788.5625, 15.0234, 0.25);
    return 1;
}

hook OnGameModeInit() {
    new Walls[22];
    Walls[00] = CreateDynamicObject(19426, 2423.84009, -1791.05005, 14.29170, 0.00000, 0.00000, 0.00000);
    Walls[01] = CreateDynamicObject(19445, 2423.84009, -1785.43591, 11.19540, 0.00000, 0.00000, 0.00000);
    Walls[02] = CreateDynamicObject(19399, 2423.84009, -1775.80798, 11.19540, 0.00000, 0.00000, 0.00000);
    Walls[03] = CreateDynamicObject(19426, 2423.84009, -1773.40210, 14.29170, 0.00000, 0.00000, 0.00000);
    Walls[04] = CreateDynamicObject(19426, 2423.84009, -1791.05005, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[05] = CreateDynamicObject(19445, 2423.84009, -1785.43591, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[06] = CreateDynamicObject(19353, 2423.84009, -1775.80798, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[07] = CreateDynamicObject(19426, 2423.84009, -1773.40210, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[08] = CreateDynamicObject(19353, 2423.84009, -1779.01599, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[09] = CreateDynamicObject(19383, 2423.84009, -1779.01599, 14.29170, 0.00000, 0.00000, 0.00000);
    Walls[10] = CreateDynamicObject(19445, 2428.74316, -1772.68921, 14.29170, 0.00000, 0.00000, 90.00000);
    Walls[11] = CreateDynamicObject(19445, 2428.74316, -1772.68921, 17.78970, 0.00000, 180.00000, 90.00000);
    Walls[12] = CreateDynamicObject(19353, 2435.16113, -1772.68921, 14.29170, 0.00000, 0.00000, 90.00000);
    Walls[13] = CreateDynamicObject(19353, 2435.16113, -1772.68921, 17.78970, 0.00000, 180.00000, 90.00000);
    Walls[14] = CreateDynamicObject(19445, 2436.85352, -1777.41687, 14.29170, 0.00000, 0.00000, 0.00000);
    Walls[15] = CreateDynamicObject(19445, 2436.85352, -1787.03894, 14.29170, 0.00000, 0.00000, 0.00000);
    Walls[16] = CreateDynamicObject(19353, 2435.16113, -1791.76526, 14.29170, 0.00000, 0.00000, 90.00000);
    Walls[17] = CreateDynamicObject(19445, 2428.74316, -1791.76526, 14.29170, 0.00000, 0.00000, 90.00000);
    Walls[18] = CreateDynamicObject(19445, 2436.85352, -1777.41687, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[19] = CreateDynamicObject(19445, 2436.85352, -1787.03894, 17.78970, 0.00000, 180.00000, 0.00000);
    Walls[20] = CreateDynamicObject(19445, 2428.74316, -1791.76526, 17.78970, 0.00000, 180.00000, 90.00000);
    Walls[21] = CreateDynamicObject(19353, 2435.16113, -1791.76526, 17.78970, 0.00000, 180.00000, 90.00000);

    for (new i; i < sizeof(Walls); i++) {
        SetDynamicObjectMaterial(Walls[i], 0, 3582, "comedhos1_la", "Bow_dryclean_bricks", 0);
    }

    new Bench_Low[3], Bench_High[3];
    Bench_Low[0] = CreateDynamicObject(19445, 2431.97339, -1777.52319, 11.52270, 0.00000, 0.00000, 90.00000);
    Bench_Low[1] = CreateDynamicObject(19445, 2431.97339, -1776.09717, 11.52270, 0.00000, 0.00000, 90.00000);
    Bench_Low[2] = CreateDynamicObject(19426, 2427.06812, -1776.80908, 11.52270, 0.00000, 0.00000, 0.00000);
    Bench_High[0] = CreateDynamicObject(19426, 2428.17114, -1776.80908, 13.36070, 0.00000, 90.00000, 0.00000);
    Bench_High[1] = CreateDynamicObject(19426, 2431.67017, -1776.80908, 13.36070, 0.00000, 90.00000, 0.00000);
    Bench_High[2] = CreateDynamicObject(19426, 2435.16699, -1776.80908, 13.36070, 0.00000, 90.00000, 0.00000);

    for (new i; i < sizeof(Bench_Low); i++) {
        SetDynamicObjectMaterial(Bench_Low[i], 0, 18092, "ammu_twofloor", "gun_bacboard", 0);
    }

    for (new i; i < sizeof(Bench_High); i++) {
        SetDynamicObjectMaterial(Bench_High[i], 0, 18092, "ammu_twofloor", "plywood_gym", 0);
    }

    CreateDynamicObject(19899, 2435.18652, -1773.27429, 12.54190, 0.00000, 0.00000, -90.00000);
    CreateDynamicObject(19815, 2432.09375, -1772.77234, 13.94230, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19815, 2428.80591, -1772.77234, 13.94230, 0.00000, 0.00000, 0.00000);

    new Shelf_Low[7];
    Shelf_Low[0] = CreateDynamicObject(3431, 2424.30078, -1773.73523, 12.07060, 0.00000, 0.00000, 180.00000);
    Shelf_Low[1] = CreateDynamicObject(3431, 2424.30078, -1775.65515, 12.07060, 0.00000, 0.00000, 180.00000);
    Shelf_Low[2] = CreateDynamicObject(3431, 2425.63696, -1773.14917, 12.07060, 0.00000, 0.00000, 90.00000);
    Shelf_Low[3] = CreateDynamicObject(3431, 2427.55688, -1773.14917, 12.07060, 0.00000, 0.00000, 90.00000);
    Shelf_Low[4] = CreateDynamicObject(3431, 2429.47583, -1773.14917, 12.07060, 0.00000, 0.00000, 90.00000);
    Shelf_Low[5] = CreateDynamicObject(3431, 2431.39380, -1773.14917, 12.07060, 0.00000, 0.00000, 90.00000);
    Shelf_Low[6] = CreateDynamicObject(3431, 2433.31396, -1773.14917, 12.07060, 0.00000, 0.00000, 90.00000);

    for (new i; i < sizeof(Shelf_Low); i++) {
        SetDynamicObjectMaterial(Shelf_Low[i], 0, 18646, "matcolours", "black", 0);
    }

    new Boxes = CreateDynamicObject(2654, 2424.82300, -1773.13025, 12.90130, 0.00000, 0.00000, -90.00000);
    SetDynamicObjectMaterial(Boxes, 0, 1221, "boxes", "cardboxes_128", 0);
    SetDynamicObjectMaterial(Boxes, 1, 1221, "boxes", "cardboxes_128", 0);
    SetDynamicObjectMaterial(Boxes, 2, 1221, "boxes", "cardboxes_128", 0);

    new Roof[4];
    Roof[0] = CreateDynamicObject(19380, 2428.58716, -1777.86426, 19.43970, 0.00000, 90.00000, 90.00000);
    Roof[1] = CreateDynamicObject(19380, 2428.58716, -1786.58020, 19.44370, 0.00000, 90.00000, 90.00000);
    Roof[2] = CreateDynamicObject(19380, 2432.10327, -1777.86426, 19.43570, 0.00000, 90.00000, 90.00000);
    Roof[3] = CreateDynamicObject(19380, 2432.10327, -1786.58020, 19.44770, 0.00000, 90.00000, 90.00000);

    for (new i; i < sizeof(Roof); i++) {
        SetDynamicObjectMaterial(Roof[i], 0, 17519, "lae2newtempbx", "ws_rooftarmac1", 0);
    }

    new Floor[4];
    Floor[0] = CreateDynamicObject(19380, 2428.58716, -1777.86426, 12.46370, 0.00000, 90.00000, 90.00000);
    Floor[1] = CreateDynamicObject(19380, 2428.58716, -1786.58020, 12.46970, 0.00000, 90.00000, 90.00000);
    Floor[2] = CreateDynamicObject(19380, 2432.10327, -1786.58020, 12.46770, 0.00000, 90.00000, 90.00000);
    Floor[3] = CreateDynamicObject(19380, 2432.10327, -1777.86426, 12.46570, 0.00000, 90.00000, 90.00000);

    for (new i; i < sizeof(Floor); i++) {
        SetDynamicObjectMaterial(Floor[i], 0, 19855, "mihouse1", "la_carp3", 0);
    }

    new Sign_Back[5];
    Sign_Back[0] = CreateDynamicObject(19426, 2423.82300, -1775.20215, 17.25160, 90.00000, 0.00000, 0.00000);
    Sign_Back[1] = CreateDynamicObject(19426, 2423.82300, -1778.69031, 17.25160, 90.00000, 0.00000, 0.00000);
    Sign_Back[2] = CreateDynamicObject(19426, 2423.82300, -1782.18616, 17.25160, 90.00000, 0.00000, 0.00000);
    Sign_Back[3] = CreateDynamicObject(19426, 2423.82300, -1785.64233, 17.25160, 90.00000, 0.00000, 0.00000);
    Sign_Back[4] = CreateDynamicObject(19426, 2423.82300, -1789.12622, 17.25160, 90.00000, 0.00000, 0.00000);

    for (new i; i < sizeof(Sign_Back); i++) {
        SetDynamicObjectMaterial(Sign_Back[i], 0, 19809, "metaltray1", "CJ_POLISHED", 0);
    }

    new Screw_Head[4];
    Screw_Head[0] = CreateDynamicObject(1866, 2423.74292, -1773.70398, 17.83420, 0.00000, 90.00000, 0.00000);
    Screw_Head[1] = CreateDynamicObject(1866, 2423.74292, -1773.70398, 16.66720, 0.00000, 90.00000, 0.00000);
    Screw_Head[2] = CreateDynamicObject(1866, 2423.74292, -1790.67004, 16.66720, 0.00000, 90.00000, 0.00000);
    Screw_Head[3] = CreateDynamicObject(1866, 2423.74292, -1790.67004, 17.83720, 0.00000, 90.00000, 0.00000);

    for (new i; i < sizeof(Screw_Head); i++) {
        SetDynamicObjectMaterial(Screw_Head[i], 0, 19809, "metaltray1", "CJ_POLISHED", 0);
    }

    new Screw_Line[4];
    Screw_Line[0] = CreateDynamicObject(19565, 2423.96021, -1773.59961, 17.73580, 45.00000, 0.00000, 0.00000);
    Screw_Line[1] = CreateDynamicObject(19565, 2423.96021, -1773.59961, 16.56280, 45.00000, 0.00000, 0.00000);
    Screw_Line[2] = CreateDynamicObject(19565, 2423.96021, -1790.56763, 16.56280, 45.00000, 0.00000, 0.00000);
    Screw_Line[3] = CreateDynamicObject(19565, 2423.96021, -1790.56763, 17.73880, 45.00000, 0.00000, 0.00000);

    for (new i; i < sizeof(Screw_Line); i++) {
        SetDynamicObjectMaterial(Screw_Line[i], 0, 18646, "matcolours", "black", 0);
    }

    new Sign1 = CreateDynamicObject(19464, 2423.7980, -1782.22522, 17.3090, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(Sign1, 0, "SCREW THIS", 130, "Verdana", 55, 1, 0xFF000000, 0x00000000, 1);

    new Sign2 = CreateDynamicObject(19464, 2423.79810, -1787.4302, 16.7470, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterialText(Sign2, 0, "It's hammer time!", 100, "Ariel", 18, 1, 0xFF000000, 0x00000000, 1);

    new gen1 = CreateDynamicObject(920, 2424.32739, -1787.03223, 13.02400, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(gen1, 0, 19809, "metaltray1", "CJ_POLISHED", 0);
    SetDynamicObjectMaterial(gen1, 1, 18646, "matcolours", "black", 0);

    new gen2 = CreateDynamicObject(920, 2424.32739, -1785.84424, 13.02400, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(gen2, 0, 18646, "matcolours", "red", 0);
    SetDynamicObjectMaterial(gen2, 1, 18646, "matcolours", "black", 0);

    new gen3 = CreateDynamicObject(920, 2424.32739, -1788.22021, 13.02400, 0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(gen3, 0, 18646, "matcolours", "blue", 0);
    SetDynamicObjectMaterial(gen3, 1, 18646, "matcolours", "black", 0);

    new WindowTags[2];
    WindowTags[0] = CreateDynamicObject(19445, 2423.84009, -1785.43591, 14.16540, 0.00000, 0.00000, 0.00000);
    WindowTags[1] = CreateDynamicObject(19358, 2423.84009, -1775.80798, 14.16540, 0.00000, 0.00000, 0.00000);

    for (new i; i < sizeof(WindowTags); i++) {
        SetDynamicObjectMaterialText(WindowTags[i], 0, "<< SCREW THIS >>", 130, "Verdana", 20, 1, 0xFF000000, 0x00000000, 1);
    }

    CreateDynamicObject(13188, 2436.77661, -1786.72510, 13.84330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(13188, 2436.92554, -1786.72510, 13.84330, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19900, 2436.34766, -1778.96130, 12.54470, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19899, 2436.24438, -1781.91650, 12.54190, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(19900, 2436.31250, -1779.76099, 12.54470, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2007, 2424.51196, -1782.07263, 12.54690, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2007, 2424.51196, -1783.42261, 12.54690, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19900, 2436.34863, -1779.33044, 13.41770, 0.00000, 0.00000, 18.00000);
    CreateDynamicObject(1849, 2430.78223, -1786.57898, 12.54380, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(1849, 2429.99048, -1786.57898, 12.54380, 0.00000, 0.00000, -90.00000);
    CreateDynamicObject(1849, 2427.47705, -1791.23938, 12.54380, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(1849, 2433.36572, -1791.23938, 12.54380, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(19325, 2423.84546, -1783.10095, 14.42880, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19325, 2423.84546, -1788.48401, 14.42880, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19325, 2423.84546, -1775.52405, 14.42880, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(1886, 2436.42725, -1791.16418, 19.46820, 14.36000, 0.00000, 217.15401);
    CreateDynamicObject(19631, 2429.87720, -1784.89514, 12.88340, 0.00000, 90.00000, 0.00000);
    CreateDynamicObject(19631, 2430.03735, -1784.90088, 12.88340, 0.00000, 90.00000, 180.00000);
    CreateDynamicObject(19631, 2429.73706, -1784.89001, 12.88340, 0.00000, 90.00000, 180.00000);
    CreateDynamicObject(2228, 2430.06934, -1786.54895, 12.88340, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(2228, 2429.81396, -1786.45569, 12.88340, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(2228, 2429.95313, -1786.48267, 12.91740, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(18635, 2425.44531, -1791.41650, 14.14020, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18635, 2425.36743, -1791.23535, 14.14020, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18635, 2425.82764, -1791.22205, 14.14020, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18635, 2425.92456, -1791.46350, 14.14020, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18635, 2426.08569, -1791.34583, 14.14020, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2426.91382, -1791.32080, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2427.00586, -1791.39209, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2426.94214, -1791.24365, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2426.95190, -1791.16406, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2427.33276, -1791.34937, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(18644, 2427.42407, -1791.25928, 14.17350, 90.00000, 0.00000, 90.00000);
    CreateDynamicObject(19627, 2428.61890, -1791.34644, 14.16540, 0.00000, 0.00000, 341.85352);
    CreateDynamicObject(19627, 2428.43945, -1791.37305, 14.16540, 0.00000, 0.00000, 312.76682);
    CreateDynamicObject(19627, 2428.93970, -1791.37488, 14.16540, 0.00000, 0.00000, 341.85352);
    CreateDynamicObject(19627, 2428.71216, -1791.18286, 14.16540, 0.00000, 0.00000, 341.85352);
    CreateDynamicObject(19627, 2428.99512, -1791.25244, 14.16540, 0.00000, 0.00000, 351.13818);
    CreateDynamicObject(19627, 2429.28052, -1791.40210, 14.16540, 0.00000, 0.00000, 359.84970);
    CreateDynamicObject(18634, 2425.73413, -1791.19385, 13.73990, 0.00000, 90.00000, 90.00000);
    CreateDynamicObject(18634, 2425.97339, -1791.27673, 13.73990, 0.00000, 90.00000, 90.00000);
    CreateDynamicObject(18634, 2426.41284, -1791.36169, 13.73990, 0.00000, 90.00000, 90.00000);
    CreateDynamicObject(18634, 2426.79517, -1791.12537, 13.73990, 0.00000, 90.00000, 90.00000);
    CreateDynamicObject(18634, 2427.23486, -1791.24109, 13.73990, 0.00000, 90.00000, 102.39035);
    CreateDynamicObject(2478, 2428.96851, -1791.23547, 12.87229, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2478, 2427.49927, -1791.24573, 12.87229, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2478, 2425.94360, -1791.20569, 12.87229, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(18638, 2430.77563, -1787.95801, 14.62050, 0.00000, -90.00000, 241.68343);
    CreateDynamicObject(18638, 2430.77563, -1787.56006, 14.62050, 0.00000, -90.00000, 241.68340);
    CreateDynamicObject(18638, 2430.77563, -1787.17200, 14.62050, 0.00000, -90.00000, 241.68340);
    CreateDynamicObject(18638, 2430.77563, -1786.78406, 14.62050, 0.00000, -90.00000, 241.68340);
    CreateDynamicObject(19093, 2430.71606, -1785.43384, 14.52850, 0.00000, -90.00000, 302.00000);
    CreateDynamicObject(19160, 2430.71606, -1784.91174, 14.52850, 0.00000, -90.00000, 302.00000);
    CreateDynamicObject(19093, 2430.71606, -1785.15381, 14.52850, 0.00000, -90.00000, 302.00000);
    CreateDynamicObject(19904, 2430.83667, -1784.67896, 13.04200, -90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19904, 2430.86304, -1785.49927, 13.04200, -90.00000, 0.00000, 351.28250);
    CreateDynamicObject(19904, 2430.84863, -1786.25964, 13.04200, -90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19904, 2430.85425, -1787.01917, 13.04200, -90.00000, 0.00000, 31.90615);
    CreateDynamicObject(1885, 2424.35938, -1780.43420, 12.54740, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2811, 2435.97949, -1776.81299, 13.43930, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2478, 2433.63110, -1776.80127, 13.44736, 0.00000, 0.00000, 18.42786);
    CreateDynamicObject(19921, 2430.92993, -1786.14160, 13.39940, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19921, 2430.92993, -1785.34558, 13.39940, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19921, 2430.92993, -1788.13159, 13.39940, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(19804, 2431.06445, -1791.44983, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.05518, -1791.22913, 13.74590, 90.00000, 0.00000, 9.67222);
    CreateDynamicObject(19804, 2431.24438, -1791.45862, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.46631, -1791.45862, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.68848, -1791.45862, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.91040, -1791.45862, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2432.13232, -1791.45862, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.27710, -1791.22913, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.49927, -1791.22913, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.72119, -1791.22913, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(19804, 2431.94312, -1791.22913, 13.74590, 90.00000, 0.00000, 352.19095);
    CreateDynamicObject(19804, 2432.16528, -1791.22913, 13.74590, 90.00000, 0.00000, 0.00000);
    CreateDynamicObject(2476, 2431.47388, -1791.16455, 12.87230, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2476, 2432.25098, -1791.16455, 12.87230, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2476, 2433.02783, -1791.16455, 12.87230, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2476, 2434.47095, -1791.16455, 12.87230, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2228, 2434.82031, -1791.27869, 14.20280, 90.00000, 0.00000, 90.00000);
    return 1;
}