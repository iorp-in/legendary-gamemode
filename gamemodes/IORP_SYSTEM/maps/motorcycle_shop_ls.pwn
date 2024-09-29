hook OnPlayerMapLoad(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    RemoveBuildingForPlayer(playerid, 4177, 1686.437, -1570.148, 18.031, 0.250);
    RemoveBuildingForPlayer(playerid, 4176, 1686.437, -1570.148, 18.031, 0.250);
    return 1;
}

hook OnGameModeInit() {
    new tmpobjid1;
    tmpobjid1 = CreateDynamicObjectEx(18981, 1680.462, -1569.986, 12.052, 0.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3979, "civic01_lan", "crazy paving", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1705.429, -1569.983, 12.045, 0.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3979, "civic01_lan", "crazy paving", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1705.090, -1570.090, 7.000, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1692.990, -1558.099, 7.000, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1680.357, -1558.041, 7.000, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1668.422, -1570.011, 7.000, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1672.377, -1563.202, 10.300, 0.000, 0.000, 0.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1679.005, -1563.217, 10.300, 0.000, 0.000, 0.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1695.497, -1563.336, 10.300, 0.000, 0.000, 0.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1701.661, -1563.359, 10.300, 0.000, 0.000, 0.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(19380, 1675.617, -1562.943, 16.600, 0.000, 90.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 9507, "boxybld2_sfw", "boxybox_sf3z", 0);
    tmpobjid1 = CreateDynamicObjectEx(19380, 1673.552, -1562.907, 16.579, 0.000, 90.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 9507, "boxybld2_sfw", "boxybox_sf3z", 0);
    tmpobjid1 = CreateDynamicObjectEx(19380, 1699.998, -1562.907, 16.579, 0.000, 90.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 9507, "boxybld2_sfw", "boxybox_sf3z", 0);
    tmpobjid1 = CreateDynamicObjectEx(19380, 1683.817, -1562.960, 13.199, 45.000, 90.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 9507, "boxybld2_sfw", "boxybox_sf3z", 0);
    tmpobjid1 = CreateDynamicObjectEx(19380, 1691.786, -1562.879, 13.199, -45.000, 90.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 9507, "boxybld2_sfw", "boxybox_sf3z", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1687.087, -1565.680, 10.100, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1687.039, -1561.022, 10.090, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1688.435, -1565.670, 10.090, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(18764, 1688.489, -1561.093, 10.085, 0.000, 0.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1672.213, -1582.519, 13.300, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1672.228, -1582.496, 17.399, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1678.839, -1582.519, 13.300, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1678.839, -1582.519, 17.399, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19454, 1682.397, -1582.432, 14.600, 90.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19454, 1689.349, -1582.432, 14.600, 90.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19435, 1685.856, -1582.433, 18.600, 90.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19435, 1685.856, -1582.433, 16.999, 90.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19435, 1685.856, -1582.425, 15.800, 90.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1694.300, -1582.519, 13.300, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1700.930, -1582.519, 13.300, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19454, 1703.570, -1582.518, 14.600, 90.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1694.300, -1582.519, 17.399, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19325, 1700.930, -1582.519, 17.399, 0.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 14846, "genintintpoliceb", "pol_galss1a", 0);
    tmpobjid1 = CreateDynamicObjectEx(19454, 1669.691, -1582.475, 14.600, 90.000, 0.000, 90.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObject(19454, 1688.74597, -1582.40955, 14.60000, 90.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1680.436, -1569.940, 19.399, 0.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18981, 1693.084, -1569.932, 19.379, 0.000, 90.000, 0.000, 300.000, 300.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 10765, "airportgnd_sfse", "white", 0);
    tmpobjid1 = CreateDynamicObjectEx(18763, 1686.637, -1575.962, 10.300, 0.000, 0.000, 0.000);
    SetDynamicObjectMaterial(tmpobjid1, 0, 3922, "bistro", "rest_wall4", 0);
    tmpobjid1 = CreateDynamicObjectEx(19482, 1686.105, -1582.524, 17.802, 0.000, 0.000, 270.000, 300.000, 300.000);
    SetDynamicObjectMaterialText(tmpobjid1, 0, "IORP", 90, "Segoe Keycaps", 50, 1, -1280, 0, 1);
    tmpobjid1 = CreateDynamicObjectEx(19482, 1686.095, -1582.535, 16.732, 0.000, 0.000, 270.000, 300.000, 300.000);
    SetDynamicObjectMaterialText(tmpobjid1, 0, "MOTO", 90, "Segoe Keycaps", 50, 1, -512, 0, 1);
    CreateDynamicObject(970, 1684.911, -1568.248, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1680.761, -1568.258, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1676.622, -1568.273, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1672.499, -1568.271, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1670.865, -1568.276, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1689.085, -1568.249, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1693.209, -1568.259, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1697.354, -1568.264, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1701.462, -1568.244, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(970, 1702.488, -1568.240, 13.000, 0.000, 0.000, 0.000);
    tmpobjid1 = CreateDynamicObject(1502, 1684.11597, -1582.47803, 12.54300, 0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(tmpobjid1, 1, 1569, "adam_v_doort", "ws_guardhousedoor");
    tmpobjid1 = CreateDynamicObject(1502, 1687.10706, -1582.46460, 12.54300, 0.00000, 0.00000, -180.00000);
    SetDynamicObjectMaterial(tmpobjid1, 1, 1569, "adam_v_doort", "ws_guardhousedoor");
    CreateDynamicObject(1714, 1671.859, -1575.461, 12.541, 0.000, 0.000, 90.000);
    CreateDynamicObject(2184, 1673.431, -1576.484, 12.541, 0.000, 0.000, 90.000);
    CreateDynamicObject(2190, 1673.269, -1576.573, 13.312, 0.000, 0.000, -127.000);
    CreateDynamicObject(1715, 1674.424, -1574.054, 12.541, 0.000, 0.000, 0.000);
    CreateDynamicObject(1715, 1674.576, -1576.750, 12.541, 0.000, 0.000, 207.000);
    CreateDynamicObject(1723, 1679.724, -1580.649, 12.544, 0.000, 0.000, 180.000);
    CreateDynamicObject(1723, 1680.918, -1577.241, 12.544, 0.000, 0.000, -90.000);
    CreateDynamicObject(1724, 1676.692, -1578.452, 12.542, 0.000, 0.000, 55.000);
    CreateDynamicObject(1724, 1677.683, -1577.174, 12.542, 0.000, 0.000, 55.000);
    CreateDynamicObject(2184, 1699.924, -1574.806, 12.541, 0.000, 0.000, -90.000);
    CreateDynamicObject(1714, 1701.863, -1575.818, 12.541, 0.000, 0.000, -90.000);
    CreateDynamicObject(2190, 1699.899, -1576.664, 13.312, 0.000, 0.000, -244.000);
    CreateDynamicObject(1715, 1698.766, -1573.973, 12.541, 0.000, 0.000, 0.000);
    CreateDynamicObject(1715, 1698.802, -1577.147, 12.541, 0.000, 0.000, 207.000);
    CreateDynamicObject(1723, 1696.181, -1577.720, 12.544, 0.000, 0.000, -90.000);
    CreateDynamicObject(1723, 1694.843, -1580.752, 12.544, 0.000, 0.000, 180.000);
    CreateDynamicObject(1724, 1692.281, -1576.849, 12.542, 0.000, 0.000, 55.000);
    CreateDynamicObject(1724, 1691.515, -1577.892, 12.542, 0.000, 0.000, 55.000);
    CreateDynamicObject(646, 1669.369, -1581.499, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1670.001, -1569.250, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1684.272, -1568.865, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1691.155, -1568.813, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1703.799, -1568.692, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1703.882, -1581.510, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1687.907, -1581.646, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(646, 1683.860, -1581.519, 13.899, 0.000, 0.000, 0.000);
    CreateDynamicObject(1827, 1678.734, -1578.564, 12.545, 0.000, 0.000, 0.000);
    CreateDynamicObject(1827, 1694.160, -1578.786, 12.545, 0.000, 0.000, 0.000);
    CreateDynamicObject(2164, 1668.968, -1577.477, 12.544, 0.000, 0.000, 90.000);
    CreateDynamicObject(2161, 1668.973, -1573.937, 12.550, 0.000, 0.000, 90.000);
    CreateDynamicObject(2162, 1668.968, -1575.705, 12.544, 0.000, 0.000, 90.000);
    CreateDynamicObject(2162, 1704.597, -1575.488, 12.544, 0.000, 0.000, -90.000);
    CreateDynamicObject(2161, 1704.543, -1577.262, 12.550, 0.000, 0.000, -90.000);
    CreateDynamicObject(2164, 1704.535, -1573.730, 12.544, 0.000, 0.000, -90.000);
    CreateDynamicObject(996, 1676.345, -1587.034, 13.100, 0.000, 0.000, 0.000);
    CreateDynamicObject(996, 1688.637, -1587.015, 13.110, 0.000, 0.000, 0.000);
    CreateDynamicObject(19122, 1683.978, -1587.085, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(19122, 1687.818, -1587.014, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(996, 1668.231, -1587.149, 13.100, 0.000, 0.000, 1.000);
    CreateDynamicObject(996, 1696.734, -1587.055, 13.100, 0.000, 0.000, -3.000);
    CreateDynamicObject(19121, 1704.489, -1587.432, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(19121, 1667.282, -1587.181, 13.000, 0.000, 0.000, 0.000);
    CreateDynamicObject(2773, 1688.398, -1575.905, 13.050, 0.000, 0.000, 0.000);
    CreateDynamicObject(2773, 1686.517, -1577.885, 13.050, 0.000, 0.000, 90.000);
    CreateDynamicObject(2773, 1686.693, -1574.297, 13.050, 0.000, 0.000, 90.000);
    CreateDynamicObject(2773, 1684.943, -1575.844, 13.050, 0.000, 0.000, 0.000);
    CreateDynamicObject(2816, 1678.819, -1578.529, 12.971, 0.000, 0.000, 0.000);
    CreateDynamicObject(2816, 1694.224, -1578.786, 12.967, 0.000, 0.000, 0.000);
    CreateDynamicObject(673, 1668.225, -1583.178, 12.539, 0.000, 0.000, 0.000);
    CreateDynamicObject(673, 1681.174, -1583.141, 12.539, 0.000, 0.000, 0.000);
    CreateDynamicObject(673, 1690.439, -1583.161, 12.539, 0.000, 0.000, 0.000);
    CreateDynamicObject(673, 1704.766, -1583.323, 12.539, 0.000, 0.000, 0.000);
    return 1;
}