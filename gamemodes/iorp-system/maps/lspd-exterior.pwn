hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 4063, 1578.4688, -1676.4219, 13.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 4064, 1571.6016, -1675.7500, 35.6797, 0.25);
    RemoveBuildingForPlayer(playerid, 1525, 1549.8906, -1714.5234, 15.1016, 0.25);
    RemoveBuildingForPlayer(playerid, 4228, 1568.2891, -1677.7813, 10.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 1266, 1538.5234, -1609.8047, 19.8438, 0.25);
    RemoveBuildingForPlayer(playerid, 1266, 1565.4141, -1722.3125, 25.0391, 0.25);
    RemoveBuildingForPlayer(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
    RemoveBuildingForPlayer(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
    RemoveBuildingForPlayer(playerid, 1260, 1565.4141, -1722.3125, 25.0391, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1541.4453, -1713.3047, 14.4297, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1709.6406, 13.0469, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1541.2969, -1702.6016, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1546.6016, -1693.3906, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1689.9844, 13.0469, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1546.8672, -1687.1016, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 646, 1545.5234, -1678.8438, 14.0000, 0.25);
    RemoveBuildingForPlayer(playerid, 1536, 1555.9297, -1677.1250, 15.1797, 0.25);
    RemoveBuildingForPlayer(playerid, 646, 1553.8672, -1677.7266, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 4032, 1568.2891, -1677.7813, 10.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 4232, 1568.2891, -1677.7813, 10.8203, 0.25);
    RemoveBuildingForPlayer(playerid, 1536, 1555.8906, -1674.1094, 15.1797, 0.25);
    RemoveBuildingForPlayer(playerid, 646, 1553.8672, -1673.4609, 16.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 646, 1545.5625, -1672.2188, 14.0000, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1546.6016, -1664.6250, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1546.8672, -1658.3438, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1661.0313, 13.0469, 0.25);
    RemoveBuildingForPlayer(playerid, 3975, 1578.4688, -1676.4219, 13.0703, 0.25);
    RemoveBuildingForPlayer(playerid, 3976, 1571.6016, -1675.7500, 35.6797, 0.25);
    RemoveBuildingForPlayer(playerid, 4192, 1591.6953, -1674.8516, 20.4922, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1541.4766, -1648.4531, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1642.0313, 13.0469, 0.25);
    RemoveBuildingForPlayer(playerid, 647, 1541.7422, -1638.9141, 14.4375, 0.25);
    RemoveBuildingForPlayer(playerid, 1260, 1538.5234, -1609.8047, 19.8438, 0.25);
    return 1;
}

hook OnGameModeInit() {
    new objekt;
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1550.1920, -1667.4255, 20.2528, 0.0, 0.0, 0.0, -1, -1, -1), 0, "LOS", 140, "Arial", 125, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1550.1920, -1669.6853, 20.2528, 0.0, 0.0, 0.0, -1, -1, -1), 0, "SANTOS", 140, "Arial", 125, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1550.1920, -1672.5449, 20.2528, 0.0, 0.0, 0.0, -1, -1, -1), 0, "POLICE", 140, "Arial", 125, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1550.1920, -1675.3432, 20.2528, 0.0, 0.0, 0.0, -1, -1, -1), 0, "DEPART", 140, "Arial", 125, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1550.1920, -1677.7067, 20.2528, 0.0, 0.0, 0.0, -1, -1, -1), 0, "MENT", 140, "Arial", 125, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1569.2938, -1638.6083, 16.7404, 0.0, 0.0, 90.0, -1, -1, -1), 0, "Los Santos", 140, "Arial", 90, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1566.5972, -1638.6083, 16.7304, 0.0, 0.0, 90.0, -1, -1, -1), 0, "Police Dep", 140, "Arial", 90, 1, 0xFF000000, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1564.4572, -1638.6083, 16.7404, 0.0, 0.0, 90.0, -1, -1, -1), 0, "artment", 140, "Arial", 90, 1, 0xFF000000, 0x0, 1);

    objekt = CreateObject(6387, 1632.82640, -1631.42505, 8.82000, 0.0, 0.0, 90.0, 2000.0); // Garage , NICHT DYNAMISCH!
    SetObjectMaterial(objekt, 7, 3167, "trailers", "trail_wall4", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(16773, 1665.84143, -1627.25684, 8.9987, 0.0, 0.0, 90.0, -1, -1, -1), 0, 3167, "trailers", "trail_wall4", 0xFFFFFFFF); // Garage Fixing
    SetDynamicObjectMaterial(CreateDynamicObject(18981, 1552.04492, -1656.14465, 12.08310, 0.0, 90.0, 0.0, -1, -1, -1), 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF); // Boden vor dem Police Department Haupteingang
    SetDynamicObjectMaterial(CreateDynamicObject(18981, 1552.04492, -1681.13916, 12.08310, 0.0, 90.0, 0.0, -1, -1, -1), 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF); // Boden vor dem Police Department Haupteingang
    SetDynamicObjectMaterial(CreateDynamicObject(18981, 1552.04492, -1706.13159, 12.08310, 0.0, 90.0, 0.0, -1, -1, -1), 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF); // Boden vor dem Police Department Haupteingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1544.73547, -1669.81934, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1541.24536, -1669.81934, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1544.73547, -1673.00391, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1544.73547, -1676.17371, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1541.24536, -1676.17371, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1541.24536, -1673.00317, 12.49830, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden bei den Treppen zum Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1544.34155, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1553.97131, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1563.59875, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1573.19775, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1582.80408, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1592.43201, -1719.74255, 12.50840, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1598.93237, -1719.74255, 12.51240, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1606.50623, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1683.48254, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1673.85034, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1664.24072, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1654.61316, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1644.98572, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1635.35156, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1625.73914, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1616.12927, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1693.10193, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1601.15784, -1702.72461, 12.51240, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1598.93237, -1712.75940, 12.51240, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1598.93237, -1716.24597, 12.51240, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1598.93237, -1709.28235, 12.51240, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1555.92993, -1713.18481, 12.50840, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1555.92993, -1703.57275, 12.50840, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Boden rechts rum um das Geb�ude
    CreateDynamicObject(14387, 1548.81226, -1670.62964, 14.84250, 0.0, 0.0, 180.0, -1, -1, -1); // Treppen
    CreateDynamicObject(14387, 1545.96948, -1670.62964, 12.88070, 0.0, 0.0, 180.0, -1, -1, -1); // Treppen
    CreateDynamicObject(14387, 1545.96948, -1675.33911, 12.88070, 0.0, 0.0, 180.0, -1, -1, -1); // Treppen
    CreateDynamicObject(14387, 1548.81226, -1675.33911, 14.84250, 0.0, 0.0, 180.0, -1, -1, -1); // Treppen
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1551.80066, -1677.62256, 12.26800, 60.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // St�tzen bei der Treppe am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1551.80066, -1668.34985, 12.26800, 60.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // St�tzen bei der Treppe am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(9131, 1545.16345, -1668.35901, 13.46680, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nderungsobjekt am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(9131, 1545.16345, -1677.62085, 13.46680, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nderungsobjekt am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1550.19531, -1670.86389, 17.52220, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8494, "vgslowbuild1", "vgnmetalwall3_256", 0xFFFFFFFF); // T�r Haupteingang
    SetDynamicObjectMaterial(CreateDynamicObject(19360, 1550.19531, -1675.05042, 17.52220, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8494, "vgslowbuild1", "vgnmetalwall3_256", 0xFFFFFFFF); // T�r Haupteingang
    CreateDynamicObject(1232, 1545.15173, -1668.33521, 12.00094, 0.0, 0.0, 0.0, -1, -1, -1); // Lampen am Eingang
    CreateDynamicObject(1232, 1545.17078, -1677.65393, 12.00094, 0.0, 0.0, 0.0, -1, -1, -1); // Lampen am Eingang
    CreateDynamicObject(1215, 1545.42700, -1673.00574, 13.11851, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1539.67749, -1673.00574, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.68018, -1673.00574, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1543.52588, -1673.00574, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1543.52588, -1677.64404, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.68018, -1677.64404, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1539.67749, -1677.64404, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1543.52588, -1668.35156, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.68018, -1668.35156, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1539.67749, -1668.35156, 13.11850, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1539.97815, -1602.51392, 13.04901, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1579.16675, -1602.50977, 13.08581, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1565.04749, -1622.73364, 13.10598, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1568.98975, -1622.73364, 13.10600, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1567.06799, -1622.73364, 13.10600, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1563.37659, -1632.87744, 12.92510, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1565.63599, -1632.89026, 12.92510, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1568.23657, -1632.89026, 12.92510, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1570.73840, -1632.89026, 12.92510, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.76550, -1646.31226, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.81323, -1665.07227, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1547.97766, -1665.11633, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1548.05664, -1660.22498, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1552.74597, -1660.15320, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1552.80505, -1651.33679, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1557.12378, -1651.30225, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1557.13281, -1646.27502, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.72229, -1680.24023, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1544.88757, -1680.23645, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1548.35803, -1683.16003, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1551.82654, -1685.97620, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1551.83643, -1714.55334, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1548.68311, -1714.57983, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1545.18103, -1711.77063, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1541.70825, -1708.77637, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1548.49695, -1685.96484, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1544.99756, -1683.16223, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1545.13770, -1708.81470, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    CreateDynamicObject(1215, 1548.67432, -1711.80737, 13.63771, 0.0, 0.0, 0.0, -1, -1, -1); // Bollardlight am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1541.63940, -1660.51526, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1541.63940, -1650.88745, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1546.36768, -1646.15369, 11.33480, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1552.56873, -1646.15771, 11.33480, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1551.94141, -1700.26074, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1551.94141, -1709.88184, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1548.58069, -1709.91980, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1545.10413, -1707.12585, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1551.94141, -1690.62512, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1548.46252, -1687.80432, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1541.63940, -1684.86841, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1548.14941, -1660.51526, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1552.95471, -1655.54907, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1541.63940, -1694.49292, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1541.63940, -1704.11523, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19454, 1544.98999, -1684.86841, 11.33480, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1550.26440, -1714.65173, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1546.78015, -1711.85168, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1546.78857, -1683.06946, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1543.31018, -1680.12537, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1557.29065, -1647.83179, 12.29000, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1557.29456, -1649.71423, 12.29000, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1555.62146, -1651.39001, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1552.13782, -1651.39001, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1551.27795, -1660.28137, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1547.82544, -1660.28137, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1543.31018, -1665.25452, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1546.48596, -1665.25854, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1543.31921, -1708.84656, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1550.27734, -1685.87769, 12.29000, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(18766, 1542.09204, -1712.19763, 10.07323, 0.0, 90.0, 90.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(18766, 1544.07837, -1715.18982, 10.07320, 0.0, 90.0, 0.0, -1, -1, -1), 0, 13691, "bevcunto2_lahills", "adeta", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1542.09985, -1711.76453, 12.49709, 90.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1542.09595, -1713.50000, 12.49710, 90.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1543.75745, -1715.17578, 12.49710, 90.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1544.41748, -1715.17883, 12.49710, 90.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Versch�nerungen bei den Pflanzen am Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.37854, -1647.73218, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.37854, -1650.93250, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.37854, -1654.13220, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.39856, -1657.33655, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.37854, -1660.53735, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1543.37854, -1663.63782, 13.07480, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1546.41101, -1663.63782, 13.07980, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1546.41101, -1660.43738, 13.07980, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1549.89600, -1658.67517, 13.07980, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1551.16040, -1658.67517, 13.07680, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1546.86670, -1647.73218, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1550.34875, -1647.73218, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1553.82764, -1647.73218, 13.07780, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1555.54724, -1647.73218, 13.07980, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1555.54724, -1649.81104, 13.07580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1553.82764, -1649.81104, 13.08280, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1551.16040, -1652.92566, 13.07580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1551.16040, -1655.92517, 13.07380, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1551.13843, -1650.09155, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1547.68286, -1650.69189, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1544.20044, -1650.69189, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1547.75732, -1653.88831, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1547.75110, -1657.05054, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1544.31543, -1653.89197, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1544.30835, -1657.05444, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1546.41895, -1660.18970, 13.08580, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1543.30505, -1684.89880, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1543.30505, -1694.49292, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1543.30505, -1704.11523, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1546.78345, -1687.83008, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1550.28040, -1690.63635, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1546.78345, -1697.45850, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1546.78345, -1707.08777, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1550.28040, -1700.26074, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19456, 1550.28040, -1709.88184, 13.01090, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1584.73279, -1606.86829, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1597.23816, -1637.68677, 12.49950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1576.26501, -1637.68677, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1586.75195, -1637.68677, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1576.26501, -1647.31433, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1586.75195, -1647.31433, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1607.84253, -1649.52551, 12.49950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1607.86182, -1639.90881, 12.51950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1607.86182, -1638.72925, 12.52450, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1584.73279, -1617.97937, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1595.19092, -1617.97937, 12.49950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1595.19092, -1606.86829, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1584.73279, -1611.65430, 12.47550, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19381, 1595.19092, -1611.65430, 12.47550, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1561.40955, -1642.06055, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1561.40955, -1638.87671, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1561.40955, -1635.67786, 12.47950, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1561.40955, -1634.47009, 12.48450, 0.0, 90.0, 0.0, -1, -1, -1), 0, 12924, "sw_block06", "Bow_church_grass_alt", 0xFFFFFFFF); // Gras beim Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1589.86230, -1647.01245, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1593.34656, -1643.71143, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1594.59741, -1642.28235, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1655.59998, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1684.47534, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1674.85010, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1583.73596, -1643.71143, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1574.11707, -1643.71143, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1554.91235, -1657.93225, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.74121, -1713.19409, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.74524, -1706.94812, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.74524, -1697.32373, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.64673, -1692.48669, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1583.72266, -1717.92822, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1574.10303, -1717.92822, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1564.47205, -1717.92822, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1589.92419, -1717.93225, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1594.65344, -1713.19812, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1594.62170, -1708.44080, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1703.70752, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1694.09058, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1554.91235, -1687.75684, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1554.95020, -1682.93738, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1550.21887, -1678.19263, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1550.21594, -1673.21130, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1550.21887, -1667.42175, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1554.95020, -1662.69104, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.64673, -1653.18469, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1559.74524, -1648.44800, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1564.48206, -1643.71143, 20.48740, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35742, -1665.22046, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19375, 1599.35437, -1647.00513, 20.48740, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1594.59741, -1642.28235, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1655.59998, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35437, -1647.00513, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1674.85010, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1665.22046, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1583.73596, -1643.71143, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1594.62170, -1708.44080, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1589.92419, -1717.93225, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1594.65344, -1713.19812, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.74524, -1648.44800, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1564.48206, -1643.71143, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.64673, -1653.18469, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1554.91235, -1657.93225, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1554.95020, -1662.69104, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1550.21887, -1667.42175, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1550.21887, -1678.19263, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1550.21594, -1673.21130, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1554.95020, -1682.93738, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1554.91235, -1687.75684, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.64673, -1692.48669, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.74524, -1697.32373, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.74524, -1706.94812, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1559.74121, -1713.19409, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1564.47205, -1717.92822, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1574.10303, -1717.92822, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1583.72266, -1717.92822, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1703.70752, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1694.09058, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1554.95020, -1662.69104, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1574.11707, -1643.71143, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1599.35742, -1684.47534, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1589.86230, -1647.01245, 9.99120, 0.0, 0.0, 0.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19377, 1593.34656, -1643.71143, 9.99120, 0.0, 0.0, 90.0, -1, -1, -1), 0, 4568, "skyscrap2_lan2", "sl_marblewall2", 0xFFFFFFFF); // Mauer PD (oben)
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1703.05701, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1693.44690, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1683.82910, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1594.48462, -1708.49646, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1594.70374, -1712.40552, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1565.06201, -1718.00647, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1574.69373, -1718.00647, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1584.29370, -1718.00647, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1590.70105, -1718.00647, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1593.10229, -1718.00647, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1554.86169, -1687.05945, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1559.87195, -1653.14648, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1555.32410, -1662.63770, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1554.84802, -1658.05420, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1559.71863, -1648.63330, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1594.56836, -1642.26038, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1565.05725, -1643.65930, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1574.67285, -1643.65930, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1584.30298, -1643.65930, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1593.92334, -1643.65930, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1555.74402, -1682.97925, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1560.34180, -1692.51453, 19.39810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1559.65820, -1712.72864, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1559.65820, -1703.11646, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1559.65820, -1693.49536, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1674.20251, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1664.59119, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.40234, -1654.98425, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1599.39734, -1647.18420, 19.39810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Mittig LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1591.48596, -1642.26038, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.80981, -1642.26440, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1584.70190, -1643.65930, 24.19961, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1588.18823, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1581.20557, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1577.70459, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1574.20691, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1570.70532, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1567.21313, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1563.71814, -1643.65930, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.71570, -1646.19739, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.71570, -1649.69556, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1557.41040, -1653.15381, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1560.90649, -1653.15381, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.87268, -1659.03918, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.87268, -1662.51709, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1556.00317, -1662.67065, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1552.52795, -1662.67065, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17468, -1665.08704, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17468, -1668.57532, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17468, -1672.04834, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17468, -1675.52576, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17468, -1679.00879, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.17773, -1681.31812, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1706.13708, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1702.66052, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1699.16187, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1695.69226, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1692.21594, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1688.74719, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1685.24438, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1681.76147, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1678.27856, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1674.79651, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1671.31995, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1667.84546, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1664.36108, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1660.87415, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1657.39185, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1653.90881, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1650.43701, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1646.96326, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1565.15381, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1568.64636, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1572.11963, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1575.58301, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1579.07568, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1582.53271, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1586.01697, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1589.48425, -1718.01001, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.85352, -1687.16919, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.85352, -1683.69275, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1552.41296, -1682.99121, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1555.90051, -1682.99121, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1557.08215, -1692.51807, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1560.56067, -1692.51807, 24.19960, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1697.96448, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1704.93335, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1701.44983, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1708.40076, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1711.90955, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1715.82703, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1712.35754, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1708.89355, 24.19960, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Oben LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1715.82703, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1712.35754, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.68372, -1708.89355, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1597.13025, -1708.48523, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1593.65283, -1708.48523, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1597.70520, -1642.28040, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1594.80981, -1642.26440, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1591.48596, -1642.26038, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1570.70532, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1584.70190, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1563.44568, -1643.65930, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1561.80737, -1643.65527, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1574.20691, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1577.70459, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1581.20557, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1588.18823, -1643.65930, 14.43880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.71570, -1646.19739, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.71570, -1649.69556, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.71570, -1653.19409, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1557.41040, -1653.15381, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1560.90649, -1653.15381, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1552.52795, -1662.67065, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1556.00317, -1662.67065, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.87268, -1655.55200, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.87268, -1659.03918, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.87268, -1662.51709, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.19006, -1665.12219, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.19006, -1668.60254, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.19006, -1680.71753, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1550.19006, -1677.23682, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1552.41296, -1682.99121, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1555.90051, -1682.99121, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1557.08215, -1692.51807, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1560.56067, -1692.51807, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.85352, -1683.69275, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.85352, -1687.16919, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1554.85352, -1690.65002, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1715.65967, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1712.16956, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1708.68066, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1705.19336, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1701.70984, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1698.22449, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1694.73938, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1559.68408, -1691.23511, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1561.67017, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1565.15381, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1568.64636, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1572.11963, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1575.58301, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1579.07568, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1582.53271, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1586.01697, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1589.48425, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1592.90845, -1718.01001, 14.45880, 90.0, 90.0, 0.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1706.13708, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1702.66052, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1699.16187, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1695.69226, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1692.21594, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1688.74719, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1685.24438, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1681.76147, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1678.27856, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1674.79651, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1671.31995, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1667.84546, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1664.36108, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1660.87415, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1657.39185, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1653.90881, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1650.43701, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39575, -1646.96326, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(19431, 1599.39978, -1644.09668, 14.45880, 90.0, 90.0, 90.0, -1, -1, -1), 0, 13746, "lahillshilhs1z", "marinawindow1_256", 0xFFFFFFFF); // Fenster Unten LSPD Geb�ude
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1599.06824, -1708.13525, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1594.35461, -1717.61035, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1560.00684, -1717.65039, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1555.22314, -1692.17615, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1550.56555, -1682.63574, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1550.56555, -1662.95496, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1555.19971, -1653.48169, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1560.04150, -1644.00134, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1598.99561, -1642.59070, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1590.19934, -1642.60217, 13.35950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete Ecken
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1550.60962, -1672.86182, 20.26263, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete LSPD Schrift
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1550.60962, -1667.87769, 20.26260, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete LSPD Schrift
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1550.60962, -1677.85095, 20.26260, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Concrete LSPD Schrift
    SetDynamicObjectMaterial(CreateDynamicObject(18766, 1568.20496, -1643.54065, 16.73000, 90.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Dachobjekt Police Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(18766, 1565.89563, -1643.53662, 16.73500, 90.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Dachobjekt Police Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(3440, 1563.73608, -1638.87122, 14.46990, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Dachobjekt Police Eingang
    SetDynamicObjectMaterial(CreateDynamicObject(3440, 1570.37878, -1638.87122, 14.46990, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF); // Dachobjekt Police Eingang
    SetObjectMaterial(CreateObject(19378, 1565.75940, -1637.21423, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(19378, 1565.75940, -1627.59412, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(19378, 1555.26697, -1627.59412, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(19378, 1555.28528, -1637.21423, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(19378, 1544.78369, -1637.21423, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(19378, 1544.78369, -1627.58594, 12.31450, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz Mitte
    SetObjectMaterial(CreateObject(3578, 1539.59802, -1627.92725, 11.62480, 0.0, 0.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark3", 0xFFFFFFFF);
    SetObjectMaterial(CreateObject(3578, 1612.85583, -1659.49084, 11.78110, 0.0, 0.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark3", 0xFFFFFFFF);
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1717.15601, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1706.66431, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1696.17261, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1685.68640, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1675.18579, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1664.68579, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19378, 1608.21716, -1654.18799, 12.47450, 0.0, 90.0, 90.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Fix LSPD Hinten
    SetObjectMaterial(CreateObject(19377, 1576.28296, -1618.04028, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1576.28296, -1608.41602, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1576.28296, -1607.04724, 12.47000, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1565.78064, -1618.04028, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1565.78064, -1608.41602, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1565.78064, -1607.04724, 12.47000, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1544.79724, -1607.04724, 12.47000, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1555.29236, -1618.04028, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1555.29236, -1608.41602, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1555.29236, -1607.04724, 12.47000, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1544.79724, -1618.04028, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1544.79724, -1608.41602, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Parkplatz
    SetObjectMaterial(CreateObject(19377, 1544.79724, -1637.73328, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19377, 1555.29236, -1637.73326, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19377, 1544.79724, -1647.34741, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19377, 1555.29236, -1647.34741, 12.47440, 0.0, 90.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1557.57703, -1632.97937, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1554.28113, -1632.97937, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1550.99084, -1632.97937, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1547.69678, -1632.97937, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1544.42175, -1632.97937, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19425, 1541.91492, -1632.97534, 12.44110, 5.0, 0.0, 180.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Mitarbeiterparkplatz
    SetObjectMaterial(CreateObject(19458, 1572.67639, -1622.87378, 12.01260, 0.0, -80.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1572.67639, -1632.49536, 12.01260, 0.0, -80.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1576.08252, -1632.49536, 11.25830, 0.0, -75.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1576.08252, -1622.87378, 11.25830, 0.0, -75.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1579.40869, -1622.87378, 10.36700, 0.0, -75.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1579.40869, -1632.49536, 10.36700, 0.0, -75.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1582.74622, -1632.49536, 9.38000, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1582.74622, -1622.87378, 9.38000, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1586.06372, -1632.49536, 8.29810, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1586.06372, -1622.87378, 8.29810, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1589.36707, -1622.86243, 7.22040, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1589.38354, -1632.49536, 7.22040, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1592.69702, -1622.87378, 6.14350, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1592.69702, -1632.49536, 6.14350, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1596.01709, -1632.49536, 5.46307, 0.0, -85.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1596.01709, -1622.87378, 5.46310, 0.0, -85.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1596.01709, -1622.87378, 5.03354, 0.0, -72.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark2", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1598.13354, -1632.49536, 5.31170, 0.0, 270.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark3", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19458, 1598.13354, -1622.87378, 5.31850, 0.0, 270.0, 0.0), 0, 4032, "lanpolicecp", "ws_carpark3", 0xFFFFFFFF); // Boden Richtung Garage
    SetObjectMaterial(CreateObject(19379, 1566.78491, -1647.31531, 12.33450, 0.0, 90.0, 0.0), 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF); // Boden Richtung Police Eingang
    SetObjectMaterial(CreateObject(19379, 1566.78491, -1637.68506, 12.33450, 0.0, 90.0, 0.0), 0, 10932, "station_sfse", "ws_stationfloor", 0xFFFFFFFF); // Boden Richtung Police Eingang
    objekt = CreateDynamicObject(974, 1599.50085, -1628.73022, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1599.50085, -1635.38037, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1599.50085, -1638.72559, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1549.60449, -1602.08313, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1556.22522, -1602.08313, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1562.88806, -1602.08313, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1569.51196, -1602.08313, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1576.21399, -1602.08350, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1556.29236, -1643.64075, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1549.63013, -1643.64075, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1542.94153, -1643.64075, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1539.60693, -1636.97607, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1539.60693, -1640.30896, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1539.60693, -1618.78174, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1539.60693, -1612.10083, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1539.60693, -1605.42004, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1542.93945, -1602.08313, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1579.56189, -1605.42175, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1579.56189, -1612.07837, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1579.56189, -1615.40198, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1582.91296, -1618.73889, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1589.52954, -1618.73889, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1596.16052, -1618.73889, 14.29300, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    objekt = CreateDynamicObject(974, 1599.50085, -1622.06763, 14.29300, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 1676, "wshxrefpump", "black64", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 11100, "bendytunnel_sfse", "fencekb_64h", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1620.35327, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1635.37585, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1615.36243, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1610.37366, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1605.38611, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63574, -1604.54810, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1542.04590, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63977, -1640.36023, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1539.63574, -1641.18787, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1542.04651, -1643.59326, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1547.04163, -1643.59326, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1547.02881, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1552.00830, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1557.00806, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1561.98926, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1566.94775, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1552.02551, -1643.59326, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1557.02515, -1643.59326, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1559.61255, -1635.37585, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1559.61255, -1640.36023, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1559.61646, -1641.18787, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1552.21936, -1622.75854, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1557.16992, -1622.75854, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1562.15186, -1622.75854, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1571.84180, -1622.77832, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1576.17529, -1622.77441, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1577.11768, -1622.77844, 12.25770, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1582.02795, -1618.72681, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1586.89282, -1618.72681, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1591.87488, -1618.72681, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1540.90234, -1622.75854, 10.50760, 90.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1541.64038, -1622.75854, 10.50760, 90.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1579.49561, -1609.53613, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1579.49561, -1614.52112, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1579.49561, -1619.51917, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1579.49255, -1620.33752, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1540.15735, -1622.75854, 10.50758, 90.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1571.93115, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1576.91138, -1602.14221, 12.52630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1579.49561, -1604.54199, 12.52630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1542.37939, -1622.75854, 10.50760, 90.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1596.86902, -1618.72681, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1599.44849, -1621.13562, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1599.44849, -1626.13342, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1599.44849, -1631.13379, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1599.44849, -1636.11011, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1599.44446, -1639.63879, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1606.25354, -1654.26575, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1610.62305, -1654.26172, 12.52330, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1613.06921, -1651.84607, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1613.06921, -1636.88208, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1613.06921, -1646.85413, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1613.06921, -1641.87280, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19866, 1613.06519, -1636.38318, 12.52330, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(9131, 1539.89209, -1622.49646, 13.46680, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(9131, 1539.89209, -1633.23816, 13.46680, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(9131, 1559.59314, -1633.23816, 13.46680, 0.0, 0.0, 0.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1566.22986, -1622.76929, 10.81160, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(19373, 1567.74902, -1622.77527, 10.81160, 0.0, 0.0, 90.0, -1, -1, -1), 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF); // Kleine Mauern Parkplatz
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37732, -1623.72583, 7.81230, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.38428, -1632.04724, 7.81230, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37732, -1622.73682, 7.81230, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.38428, -1633.04150, 7.81232, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37732, -1622.73682, 2.82660, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37732, -1623.72583, 2.82660, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.38428, -1632.04724, 2.82660, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.38428, -1633.04150, 2.82660, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1625.37524, 9.78230, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1630.37585, 9.78230, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1625.37524, 10.76220, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1625.37524, 11.74210, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1630.37585, 10.76220, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.35913, -1630.37585, 11.74210, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37915, -1630.37585, 12.09250, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.37915, -1625.37524, 12.09250, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.73181, -1631.66809, 7.74890, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.73181, -1624.16077, 7.74890, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.76331, -1629.66956, 10.30740, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18762, 1599.76733, -1626.16602, 10.30740, 0.0, 90.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1575.82166, -1632.94238, 10.81806, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1585.44104, -1632.94238, 10.79810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1575.79297, -1622.78027, 10.81810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1585.41504, -1622.78027, 10.81810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1585.41504, -1622.78027, 7.32450, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1585.44104, -1632.94238, 7.32450, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.05750, -1632.94238, 7.32450, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.05750, -1632.94238, 3.82000, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.05750, -1622.78027, 3.82000, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.03748, -1622.78027, 7.32450, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.05750, -1632.94238, 10.79810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1595.03748, -1622.78027, 10.81810, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1571.07703, -1637.68579, 10.81810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1571.07703, -1647.30762, 10.81810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1563.07471, -1637.66479, 10.81810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19460, 1563.07471, -1647.27954, 10.81810, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8532, "tikigrass", "ceaserwall06_128", 0xFFFFFFFF);
    CreateDynamicObject(7091, 1550.15369, -1680.28748, 20.24821, 0.0, 0.0, 180.0, -1, -1, -1); // Flaage
    CreateDynamicObject(7091, 1550.15369, -1665.10803, 20.24820, 0.0, 0.0, 180.0, -1, -1, -1); // Flaage
    // Sitzbank
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1558.83716, -1715.38135, 13.21835, 0.0, 0.0, 0.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1558.83716, -1707.35522, 13.21840, 0.0, 0.0, 0.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1558.83716, -1700.03540, 13.21840, 0.0, 0.0, 0.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1552.95300, -1700.03540, 13.21840, 0.0, 0.0, 180.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1552.95300, -1707.35522, 13.21840, 0.0, 0.0, 180.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1552.95300, -1715.38135, 13.21840, 0.0, 0.0, 180.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1570.36401, -1635.85291, 13.05520, 0.0, 0.0, 0.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1563.76013, -1635.85291, 13.05520, 0.0, 0.0, 180.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1570.36401, -1641.22949, 13.05520, 0.0, 0.0, 0.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(1256, 1563.76013, -1641.22949, 13.05520, 0.0, 0.0, 180.0, -1, -1, -1), 0, "Los Santos\nPolice Department", 130, "Times New Roman", 55, 0, 0xFF000000, 0xFFFFFFFF, 1);
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1558.96948, -1622.46655, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1574.39075, -1622.44678, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1579.12268, -1620.75220, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1569.65979, -1620.77527, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1572.76050, -1620.77527, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1576.04065, -1620.77527, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1572.76050, -1617.57971, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1569.65979, -1617.57971, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1576.04065, -1617.57971, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1579.12268, -1617.57971, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1574.03064, -1602.46338, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1564.41772, -1602.46338, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1554.79102, -1602.46338, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19450, 1545.18164, -1602.46338, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1578.76208, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1569.30725, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1572.46741, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1575.69629, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1578.76208, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1575.69629, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1572.46741, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1569.30725, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1559.71033, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1562.92786, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1566.12720, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1566.12720, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1562.92786, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1559.71033, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1550.02002, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1553.12585, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1556.40955, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1556.40955, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1553.12585, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1550.02002, -1607.33020, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1540.46777, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1543.49585, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1546.64697, -1604.13025, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1546.64697, -1607.34216, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1543.49585, -1607.34216, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1540.46777, -1607.34216, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1552.56433, -1622.46655, 10.82630, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1563.70361, -1620.84058, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1551.04065, -1620.84058, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    SetDynamicObjectMaterial(CreateDynamicObject(19358, 1557.32080, -1620.84058, 10.82630, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8395, "pyramid", "white", 0xFFFFFFFF); // Parkstreifen
    // Schranken und Tore
    CreateDynamicObject(967, 1541.46387, -1621.39685, 12.53248, 0.0, 0.0, -135.0, -1, -1, -1);
    objekt = CreateDynamicObject(966, 1540.23718, -1625.16516, 12.37620, 0.0, 0.0, 90.0, -1, -1, -1);
    SetDynamicObjectMaterial(objekt, 0, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF), SetDynamicObjectMaterial(objekt, 1, 12862, "sw_block03", "sw_wall02", 0xFFFFFFFF);
    // Parkplatzbezeichnungen
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1557.1549, -1640.6669, 12.4881, 0.0, 90.0, 270.0, -1, -1, -1), 0, "�", 100, "Webdings", 255, 0, 0xFFFFFFFF, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1542.3131, -1640.6669, 12.4881, 0.0, 90.0, 270.0, -1, -1, -1), 0, "�", 100, "Webdings", 255, 0, 0xFFFFFFFF, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1546.02355, -1640.6669, 12.4881, 0.0, 90.0, 270.0, -1, -1, -1), 0, "�", 100, "Webdings", 255, 0, 0xFFFFFFFF, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1549.7340, -1640.6669, 12.4881, 0.0, 90.0, 270.0, -1, -1, -1), 0, "�", 100, "Webdings", 255, 0, 0xFFFFFFFF, 0x0, 1);
    SetDynamicObjectMaterialText(CreateDynamicObject(19353, 1553.44445, -1640.6669, 12.4881, 0.0, 90.0, 270.0, -1, -1, -1), 0, "�", 100, "Webdings", 255, 0, 0xFFFFFFFF, 0x0, 1);
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1552.02295, -1721.91125, 12.76620, 0.0, 90.0, 0.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1577.00098, -1721.90710, 12.76320, 0.0, 90.0, 0.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1591.25024, -1721.90710, 12.76620, 0.0, 90.0, 0.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1603.25342, -1708.92981, 12.76620, 0.0, 90.0, 90.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1603.25342, -1683.94995, 12.76620, 0.0, 90.0, 90.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1603.25342, -1658.95532, 12.76620, 0.0, 90.0, 90.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    SetDynamicObjectMaterial(CreateDynamicObject(18980, 1603.25342, -1633.95923, 12.76620, 0.0, 90.0, 90.0, -1, -1, -1), 0, 18202, "w_towncs_t", "plaintarmac1", 0xFFFFFFFF); // Mauern rechts und hinten
    // Dach
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1564.91089, -1683.59607, 27.16050, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19438, 1564.91089, -1677.44287, 27.16050, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1564.92639, -1681.87976, 29.53940, 90.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1564.92639, -1678.39478, 29.53940, 90.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19435, 1564.92444, -1683.44617, 29.53940, 90.0, 90.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1566.44324, -1685.12524, 28.58760, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1566.44324, -1685.12524, 25.10360, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1569.64001, -1685.12524, 25.10360, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1569.64001, -1685.12524, 28.58760, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15906, -1683.59143, 25.10360, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15906, -1683.59143, 28.58760, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1569.64001, -1676.72046, 25.10360, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1569.64001, -1676.72046, 28.58760, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1566.44324, -1676.72046, 28.58760, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1566.44324, -1676.72046, 25.10360, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15918, -1678.25281, 25.10360, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15625, -1680.91248, 25.10360, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15625, -1680.91248, 28.58760, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1571.15918, -1678.25281, 28.58760, 0.0, 0.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1566.58875, -1680.90332, 30.28000, 0.0, 90.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19448, 1569.48389, -1680.90332, 30.28500, 0.0, 90.0, 0.0, -1, -1, -1), 0, 8399, "vgs_shops", "vgsclubwall08_256", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1564.95557, -1648.51770, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1560.13403, -1658.00220, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1555.48865, -1667.52637, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1555.48865, -1678.10413, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1555.48865, -1673.03516, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1560.13196, -1687.68958, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1564.98169, -1697.15918, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1564.98169, -1706.77795, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1564.98169, -1713.14856, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1575.46228, -1713.14856, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1585.94971, -1713.14856, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1589.46594, -1713.14856, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1703.65576, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1694.04041, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1684.42078, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1674.80334, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1665.19226, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1655.57800, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1575.43848, -1648.51770, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1565.94177, -1667.52637, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1565.94177, -1673.03516, 25.66290, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1565.94177, -1678.10413, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1585.92346, -1648.51770, 25.65890, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(19380, 1594.14417, -1648.51941, 25.65490, 0.0, 90.0, 0.0, -1, -1, -1), 0, 6338, "sunset01_law2", "ws_rooftarmac1", 0xFFFFFFFF);
    CreateDynamicObject(18981, 1577.15149, -1664.47607, 25.26490, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(18981, 1577.15149, -1697.13525, 25.26490, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(18981, 1577.15149, -1680.89209, 25.25990, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3934, 1568.90234, -1656.97864, 25.76390, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3934, 1568.90234, -1665.76208, 25.76390, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3934, 1568.90234, -1704.48999, 25.76390, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3934, 1568.90234, -1695.97522, 25.76390, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1560.02295, -1643.85889, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1555.10791, -1653.31506, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1550.47485, -1662.80615, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1550.50928, -1682.79114, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1555.10681, -1692.35876, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1559.88135, -1717.84167, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.12366, -1653.79126, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.12146, -1660.32556, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.18604, -1662.60767, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.13318, -1669.10510, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.48059, -1653.74988, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.47974, -1660.30054, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.45715, -1662.56653, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.47668, -1669.11572, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.15637, -1692.83044, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.10693, -1699.32227, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.15125, -1701.29846, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1565.17505, -1707.82166, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.39600, -1707.88306, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.40247, -1701.27832, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.36475, -1699.34131, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1572.39783, -1692.78125, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1594.41797, -1717.75867, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1599.16467, -1708.31311, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1599.09753, -1642.41443, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(3526, 1590.10461, -1642.42456, 25.92798, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(19368, 1561.55078, -1632.93616, 10.80493, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(19425, 1599.86169, -1629.53564, 5.30300, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(19425, 1599.86169, -1626.25500, 5.30300, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(19425, 1544.78088, -1622.80676, 12.44110, 5.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(19425, 1548.07739, -1622.80676, 12.44110, 5.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(4199, 1607.37000, -1618.10718, 14.55750, 0.0, 0.0, 0.0, -1, -1, -1);
    SetDynamicObjectMaterial(CreateDynamicObject(19365, 1567.07019, -1643.69275, 14.0908, 0.0, 0.0, 90.0, -1, -1, -1), 0, 8494, "vgslowbuild1", "vgnmetalwall3_256", 0xFFFFFFFF); // T�r Police Eingang
    CreateDynamicObject(1549, 1569.46277, -1643.31555, 12.42000, 0.0, 0.0, 60.30000, -1, -1, -1);
    CreateDynamicObject(1549, 1564.73389, -1643.31555, 12.42000, 0.0, 0.0, -56.10000, -1, -1, -1);
    CreateDynamicObject(874, 1576.86987, -1643.34375, 13.81053, 0.0, 0.0, 532.68005, -1, -1, -1);
    CreateDynamicObject(874, 1586.03369, -1643.47107, 13.81053, 0.0, 0.0, 532.68005, -1, -1, -1);
    CreateDynamicObject(874, 1592.78052, -1643.37170, 13.81053, 0.0, 0.0, 532.68005, -1, -1, -1);
    CreateDynamicObject(808, 1581.56799, -1635.07104, 13.88028, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(808, 1588.15405, -1634.79883, 13.88028, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(808, 1596.75806, -1635.06311, 13.88028, 0.0, 0.0, -17.16000, -1, -1, -1);
    CreateDynamicObject(19455, 1611.40552, -1629.01843, 12.51450, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(19455, 1611.39075, -1621.30029, 12.51450, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(19455, 1611.39111, -1613.46423, 12.51450, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(19455, 1611.39880, -1607.08105, 12.51450, 0.0, 90.0, 0.0, -1, -1, -1);
    CreateDynamicObject(808, 1561.44104, -1640.11792, 13.88028, 0.0, 0.0, -165.06001, -1, -1, -1);
    CreateDynamicObject(808, 1561.48132, -1635.62378, 13.88028, 0.0, 0.0, -165.06001, -1, -1, -1);
    CreateDynamicObject(680, 1585.18933, -1633.86914, 12.56170, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(680, 1593.65820, -1633.86914, 12.56168, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(746, 1573.38049, -1635.02026, 12.56322, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(680, 1577.16370, -1633.86914, 12.56170, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(808, 1581.66174, -1621.03625, 13.88028, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(808, 1596.16858, -1621.03625, 13.88030, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(808, 1589.24854, -1621.03625, 13.88030, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(748, 1585.53943, -1621.14954, 12.56270, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(748, 1592.96094, -1620.97717, 12.56270, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(807, 1543.07458, -1647.85339, 13.22687, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(807, 1543.95996, -1647.87903, 13.22687, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(746, 1550.31909, -1657.33582, 13.11976, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(808, 1554.43140, -1648.81506, 14.35731, 0.0, 0.0, -165.06001, -1, -1, -1);
    CreateDynamicObject(808, 1545.01331, -1662.55115, 14.35731, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(811, 1543.56909, -1648.85718, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(811, 1542.82251, -1651.66846, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(811, 1546.24609, -1648.20789, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(751, 1544.61011, -1650.75195, 13.11980, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(680, 1545.94775, -1652.25366, 12.82641, 0.0, 0.0, -44.28001, -1, -1, -1);
    CreateDynamicObject(802, 1547.55981, -1658.23560, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1548.26489, -1656.25354, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.10706, -1659.66882, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.36646, -1658.00830, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1547.08081, -1656.45032, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1548.42029, -1655.01941, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.12561, -1654.74036, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(807, 1548.33215, -1647.44763, 13.22687, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(802, 1555.85974, -1647.14160, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1552.38049, -1646.88416, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1551.22070, -1647.50586, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.51306, -1646.83240, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.35718, -1647.37170, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(808, 1550.82153, -1650.63489, 14.35731, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(808, 1547.71448, -1652.43201, 14.35731, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(808, 1544.23889, -1655.43445, 14.35731, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(746, 1544.04822, -1659.21375, 13.11976, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(802, 1542.70544, -1653.95581, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.79944, -1662.03271, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(19984, 1571.00366, -1632.60437, 12.27952, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(19984, 1600.37415, -1624.16541, 5.18707, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(19966, 1540.20996, -1632.44238, 12.33825, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(19955, 1549.75806, -1622.98108, 12.33830, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(19956, 1549.79810, -1622.98108, 12.33830, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(746, 1543.65186, -1684.96387, 13.11976, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(746, 1545.76160, -1706.82483, 13.11976, 0.0, 0.0, -37.50000, -1, -1, -1);
    CreateDynamicObject(746, 1549.30554, -1709.38257, 13.11976, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(808, 1545.88904, -1688.15222, 14.19012, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(808, 1546.22815, -1692.71765, 14.19012, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(808, 1549.18567, -1689.25684, 14.19012, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(680, 1542.71216, -1681.79187, 12.82641, 0.0, 0.0, -44.28001, -1, -1, -1);
    CreateDynamicObject(680, 1542.50891, -1707.50989, 12.82641, 0.0, 0.0, -44.28001, -1, -1, -1);
    CreateDynamicObject(680, 1550.85083, -1713.90063, 12.82641, 0.0, 0.0, -44.28001, -1, -1, -1);
    CreateDynamicObject(680, 1551.07861, -1686.44006, 12.82641, 0.0, 0.0, -44.28001, -1, -1, -1);
    CreateDynamicObject(807, 1542.88367, -1707.37024, 13.22678, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(807, 1542.99536, -1681.34644, 13.22678, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.72046, -1687.84851, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.68970, -1689.20813, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.03455, -1690.77612, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.60205, -1690.42603, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.68848, -1691.91125, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.62085, -1693.10742, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.58765, -1691.92603, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.95679, -1693.31750, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(811, 1543.20630, -1695.16516, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(811, 1543.15088, -1697.22681, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(811, 1543.13574, -1699.31567, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.52356, -1701.14966, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.47913, -1701.88965, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.42725, -1702.29175, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.29443, -1703.57422, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.48486, -1703.13086, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.58813, -1704.18909, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.22229, -1704.87585, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1542.58752, -1705.10938, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1543.28760, -1706.05493, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(808, 1546.41272, -1700.02356, 14.19012, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(808, 1546.05750, -1704.30896, 14.19012, 0.0, 0.0, -215.94003, -1, -1, -1);
    CreateDynamicObject(811, 1550.62390, -1711.90479, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(811, 1550.67493, -1706.38293, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(811, 1550.59448, -1693.03516, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(746, 1548.86670, -1690.65649, 13.11976, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(811, 1550.69897, -1688.34839, 14.05362, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.85632, -1704.78833, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.41724, -1703.53796, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.01733, -1702.25916, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.43994, -1701.22900, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.01367, -1699.98657, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.49890, -1698.94702, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.22131, -1697.54688, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.53162, -1696.57959, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1550.34534, -1695.35718, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1549.78027, -1694.49170, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.26672, -1710.81641, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.67908, -1709.93213, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.44946, -1709.36633, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1547.35718, -1684.01892, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1547.64648, -1685.17664, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.29224, -1685.15369, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.13208, -1686.27686, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(802, 1546.17493, -1684.04932, 13.50076, 0.0, 0.0, -215.94000, -1, -1, -1);
    CreateDynamicObject(749, 1547.06348, -1696.64636, 13.28750, 0.0, 0.0, -64.86000, -1, -1, -1);
    CreateDynamicObject(806, 1606.11450, -1652.16553, 15.84748, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(806, 1607.56836, -1650.88867, 15.84748, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1608.31995, -1649.27649, 13.21477, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(748, 1610.15369, -1651.75391, 12.56181, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1610.95361, -1649.05273, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1610.83521, -1646.76611, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1610.72437, -1644.29517, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1610.73401, -1641.83582, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(748, 1610.59692, -1638.98206, 12.68180, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(806, 1606.49890, -1649.75610, 15.84748, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1608.21008, -1644.29407, 13.59480, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1608.17004, -1646.02136, 13.59480, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(806, 1608.68823, -1639.26892, 16.04750, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(806, 1607.22681, -1637.38342, 15.84748, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(806, 1606.38708, -1639.71912, 16.14750, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1608.18091, -1647.78613, 13.63480, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1607.99304, -1642.65283, 13.59480, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(811, 1608.07312, -1641.00049, 13.59480, 0.0, 0.0, -62.64000, -1, -1, -1);
    CreateDynamicObject(753, 1605.86450, -1641.15015, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1606.10828, -1643.36938, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1606.04834, -1645.54272, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(753, 1606.12891, -1647.79724, 12.46222, 0.0, 0.0, -33.72000, -1, -1, -1);
    CreateDynamicObject(748, 1597.34656, -1604.22046, 12.42350, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(748, 1582.38916, -1616.09875, 12.42350, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(745, 1589.96350, -1609.89539, 12.42350, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1597.78821, -1616.79639, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1595.64673, -1616.98267, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1597.81531, -1614.73474, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1581.45789, -1605.76404, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1581.42493, -1603.65698, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(753, 1583.26318, -1603.72131, 12.53066, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(680, 1588.42834, -1607.95569, 12.56170, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(808, 1596.98914, -1606.93567, 13.88028, 0.0, 0.0, -165.06001, -1, -1, -1);
    CreateDynamicObject(808, 1594.40393, -1604.86975, 13.88028, 0.0, 0.0, -165.06001, -1, -1, -1);
    CreateDynamicObject(811, 1583.09033, -1605.94617, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(811, 1584.78003, -1604.15344, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(800, 1593.02710, -1609.29004, 12.69365, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(829, 1584.29089, -1609.89404, 12.74745, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(843, 1588.73779, -1605.14771, 12.74740, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(842, 1589.07861, -1603.90784, 12.74740, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(811, 1581.60547, -1609.80652, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(811, 1581.90967, -1612.02539, 13.88030, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(801, 1585.15051, -1615.94031, 12.34762, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(801, 1588.59900, -1615.49207, 12.34762, 0.0, 0.0, -165.06000, -1, -1, -1);
    CreateDynamicObject(801, 1591.26245, -1616.41296, 12.34762, 0.0, 0.0, -205.37999, -1, -1, -1);
    SetDynamicObjectMaterial(CreateDynamicObject(18755, 1566.88916, -1680.02869, 27.63950, 0.0, 0.0, 0.0, -1, -1, -1), 1, 3042, "ct_ventx", "liftdoorsac128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18756, 1566.88916, -1680.02869, 27.69950, 0.0, 0.0, 0.0, -1, -1, -1), 1, 3042, "ct_ventx", "liftdoorsac128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(CreateDynamicObject(18757, 1566.88916, -1680.02869, 27.69950, 0.0, 0.0, 0.0, -1, -1, -1), 0, 3042, "ct_ventx", "liftdoorsac128", 0xFFFFFFFF);
    CreateDynamicObject(1533, 1564.79138, -1682.88208, 25.66430, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(2921, 1550.19165, -1681.66748, 23.00260, 0.0, 0.0, -14.28000, -1, -1, -1);
    CreateDynamicObject(2921, 1550.09668, -1663.69141, 23.00260, 0.0, 0.0, 20.46000, -1, -1, -1);
    CreateDynamicObject(2921, 1550.09668, -1663.69141, 23.00260, 0.0, 0.0, -31.14001, -1, -1, -1);
    CreateDynamicObject(2921, 1560.86292, -1643.68469, 21.40779, 0.0, 0.0, -78.72000, -1, -1, -1);
    CreateDynamicObject(2921, 1598.66321, -1632.29663, 12.10765, 0.0, 0.0, -8.52000, -1, -1, -1);
    CreateDynamicObject(2921, 1600.20618, -1623.72656, 10.50844, 14.64000, -33.90000, 182.03995, -1, -1, -1);
    CreateDynamicObject(2921, 1665.70422, -1645.67297, 11.59180, 0.0, 0.0, -46.98000, -1, -1, -1);
    CreateDynamicObject(2921, 1644.31335, -1645.94080, 10.96153, 0.0, 0.0, -53.04001, -1, -1, -1);
    CreateDynamicObject(2921, 1618.85999, -1647.80798, 11.05086, 0.0, 0.0, -61.38000, -1, -1, -1);
    CreateDynamicObject(2921, 1559.72705, -1644.75659, 21.40779, 0.0, 0.0, -18.42000, -1, -1, -1);
    CreateDynamicObject(2921, 1559.72498, -1716.82813, 23.00260, 0.0, 0.0, -12.30000, -1, -1, -1);
    CreateDynamicObject(2921, 1593.60718, -1717.93884, 23.10817, 0.0, 0.0, 62.94003, -1, -1, -1);
    CreateDynamicObject(2921, 1599.31531, -1643.41541, 23.00626, 0.0, 0.0, 150.84003, -1, -1, -1);
    CreateDynamicObject(2921, 1598.18335, -1642.20142, 23.00626, 0.0, 0.0, 233.58005, -1, -1, -1);
    CreateDynamicObject(2921, 1564.93542, -1676.69690, 30.03671, 0.0, 0.0, -62.46000, -1, -1, -1);
    CreateDynamicObject(2921, 1571.17090, -1685.15857, 30.03671, 0.0, 0.0, 113.39999, -1, -1, -1);
    CreateDynamicObject(1687, 1574.81079, -1646.91284, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1687, 1571.52783, -1646.91284, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1687, 1568.39087, -1646.91284, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1687, 1568.39087, -1714.03467, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1687, 1571.52783, -1714.03467, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1687, 1574.81079, -1714.03467, 26.46660, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1689, 1565.56812, -1713.62451, 26.62390, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1689, 1565.56812, -1647.81702, 26.62390, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1691, 1555.82971, -1687.27979, 25.86970, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(1691, 1555.82971, -1658.14331, 25.86970, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(1690, 1553.72400, -1665.95691, 26.22870, 0.0, 0.0, 180.0, -1, -1, -1);
    CreateDynamicObject(1696, 1554.49390, -1672.49866, 26.77560, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(1690, 1553.72400, -1679.75330, 26.22870, 0.0, 0.0, 180.0, -1, -1, -1);
    CreateDynamicObject(914, 1592.24158, -1718.08289, 24.17650, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(914, 1562.30872, -1718.06543, 24.17650, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(2921, 1561.02039, -1717.83301, 23.10817, 0.0, 0.0, 62.94003, -1, -1, -1);
    CreateDynamicObject(914, 1559.61658, -1714.51758, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(1623, 1559.64795, -1715.95630, 24.32322, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(914, 1559.61658, -1695.24609, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(1623, 1559.64795, -1693.86890, 24.32320, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(914, 1554.79309, -1689.69116, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(914, 1554.79309, -1690.84485, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(914, 1554.79309, -1655.04578, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(914, 1554.79309, -1656.21082, 24.17650, 0.0, 0.0, 270.0, -1, -1, -1);
    CreateDynamicObject(1623, 1559.62488, -1652.25452, 24.32322, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(914, 1561.28589, -1643.58789, 24.17650, 0.0, 0.0, 180.0, -1, -1, -1);
    CreateDynamicObject(914, 1597.51147, -1642.13330, 24.17650, 0.0, 0.0, 180.0, -1, -1, -1);
    CreateDynamicObject(914, 1599.49646, -1644.12146, 24.17650, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(914, 1597.59692, -1708.58691, 24.17650, 0.0, 0.0, 0.0, -1, -1, -1);
    CreateDynamicObject(1623, 1596.08252, -1708.54565, 24.26300, 0.0, 0.0, 90.0, -1, -1, -1);
    CreateDynamicObject(1690, 1565.83643, -1680.95984, 30.86941, 0.0, 0.0, 180.0, -1, -1, -1);
    CreateDynamicObject(1690, 1569.61597, -1680.95984, 30.86940, 0.0, 0.0, 180.0, -1, -1, -1);
    return 1;
}