new mmlsspeed = 10;

forward elevator();
new podjem, elevat, pickup_buy[2];
new status_el = 0, status_pod = 0;

hook OnGameModeInit() {
    new lift_virtualworld = 0;
    CreateDynamicObject(18770, -2329.9521484, -1473.8632812, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -1273.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -1073.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -873.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -673.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -473.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -273.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2329.9521484, -73.8691406, 490.9100037, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, 24.0000000, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2329.9521484, -1589.0175781, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2339.9492188, -1589.0175781, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2319.9570312, -1589.0175781, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2339.9492188, -1579.0195312, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2329.9521484, -1579.0195312, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2319.9570312, -1579.0195312, 484.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2319.9570312, -1579.0195312, 479.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2329.9528809, -1579.0200195, 479.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, -1571.5195312, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, -1566.5195312, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2330.0683594, -1598.3398438, 483.9299927, 294.9938965, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2344.4492188, -1589.0175781, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.6513672, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2340.9453125, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2338.1562500, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2334.6591797, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2343.4492188, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2333.0693359, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2336.5097656, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2334.0693359, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.6513672, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2342.4521484, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2337.4528809, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2338.1562500, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2334.6591797, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2332.4521484, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2340.9453125, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2336.5097656, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2344.4492188, -1579.0195312, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2342.4521484, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2337.4521484, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2332.4521484, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.1992188, -1574.1494141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2335.4492188, -1574.5195312, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2337.6992188, -1574.1494141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2343.4492188, -1574.5195312, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2341.8994141, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(1649, -2337.4599609, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(1649, -2341.8994141, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2337.4599609, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.1992188, -1574.1494141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2337.6992188, -1574.1494141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.0195312, -1579.0195312, 486.7999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.0195312, -1579.0195312, 490.2999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.0195312, -1589.0175781, 486.7999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.0195312, -1589.0175781, 490.2999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2315.4580078, -1589.0175781, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18765, -2319.9570312, -1589.0175781, 479.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2315.4580078, -1579.0195312, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2327.4541016, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2322.4565430, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2317.4577637, -1589.0146484, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2317.4577637, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2322.4565430, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2327.4541016, -1579.0195312, 492.0000000, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2316.4589844, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2327.0673828, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2326.0693359, -1593.5166016, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2324.6000977, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2317.5996094, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2321.0996094, -1593.8994141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2317.6000977, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2321.1000977, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2324.6000977, -1593.8994141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2319.0500488, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2323.4919434, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2319.0500488, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2323.4919434, -1593.8994141, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, -1571.5195312, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, -1566.5195312, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, -1566.9873047, 480.7300110, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -1376.0000000, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2316.4589844, -1574.5195312, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2324.4521484, -1574.5195312, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2318.6992188, -1574.1494141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2322.1992188, -1574.1494141, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2318.6999512, -1574.1494141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2322.1999512, -1574.1494141, 491.2000122, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2322.5500488, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(1649, -2318.1093750, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(1649, -2318.1101074, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2322.5498047, -1574.1396484, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.8798828, -1579.0195312, 486.7999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.8798828, -1579.0195312, 490.2999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.8798828, -1589.0175781, 490.2999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.8798828, -1589.0175781, 486.7999878, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.9521484, -1589.0175781, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.9169922, -1579.0195312, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19121, -2326.4492188, -1564.1660156, 487.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19121, -2333.4492188, -1564.1660156, 487.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2330.0683594, -1598.9639893, 484.1000061, 0.0000000, 65.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -1376.0000000, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -1376.0000000, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -1175.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -1175.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -1175.9000244, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4499512, -1175.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4499512, -1175.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -975.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -975.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -975.8994141, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4499512, -975.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -975.8994141, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -975.8994141, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -975.8994141, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -975.8994141, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -1175.9000244, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -775.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -775.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -775.9000244, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -775.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -775.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -775.9000244, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -775.9000244, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -575.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -575.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -575.9000244, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -575.9000244, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -575.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -575.9000244, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -375.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -375.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -375.8999939, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -375.8999939, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -375.8999939, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -375.8999939, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -375.8999939, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -375.8999939, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -175.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -175.8994141, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -175.8999939, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -175.8999939, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -175.8999939, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, -175.8994141, 291.3999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, -175.8994141, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, -175.8999939, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, 24.0000000, 391.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2329.9521484, 24.0000000, 490.8999939, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, 24.0000000, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, 24.0000000, 191.9100037, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2326.4492188, 24.0000000, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18770, -2333.4492188, 24.0000000, -8.0900002, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 20.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 10.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 15.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 20.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 15.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9499512, 10.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 20.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 15.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 10.5000000, 486.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2333.4492188, 10.5000000, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2326.4492188, 10.5000000, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 10.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 15.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 20.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 10.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 15.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 20.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2344.4492188, 15.5000000, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.1992188, 8.5000000, 486.7999878, 90.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.4492188, 10.0000000, 486.7999878, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2343.4492188, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2344.4492188, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2337.6992188, 8.5000000, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2335.4492188, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2341.1992188, 8.5000000, 491.2000122, 90.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2337.6992188, 8.5000000, 491.2000122, 90.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.4492188, 10.0000000, 491.2000122, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2341.8994141, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2337.4599609, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2341.8994141, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2337.4599609, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2344.4492188, 11.0000000, 488.8999939, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2344.4492188, 11.0000000, 488.8999939, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 10.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 15.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 20.5000000, 492.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2315.4580078, 15.5000000, 489.0000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2315.4580078, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2316.4589844, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2324.4499512, 8.5000000, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2322.1992188, 8.5000000, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2318.6992188, 8.5000000, 486.7999878, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2318.6992188, 8.5000000, 491.2000122, 90.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2322.1992188, 8.5000000, 491.2000122, 90.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2318.1093750, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2322.5498047, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2318.1093750, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2322.5498047, 8.5000000, 488.8999939, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.4580078, 10.0000000, 486.7999878, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.4580078, 10.0000000, 491.2000122, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2315.4580078, 11.0000000, 488.8999939, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2315.4580078, 11.0000000, 488.8999939, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2333.4492188, 15.5000000, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2326.4492188, 15.5000000, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.9521484, 20.5000000, 486.4200134, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -175.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -175.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -375.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -375.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -575.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -575.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -775.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -775.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -975.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -975.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -1175.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -1175.8994141, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2333.4492188, -1376.0000000, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19126, -2326.4492188, -1376.0000000, 492.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2339.9492188, 22.4980469, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2334.4499512, 22.4990005, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.4492188, 20.8400002, 486.7999878, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2344.4492188, 20.8400002, 491.2000122, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2344.4492188, 20.0000000, 488.8999939, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2344.4492188, 20.0000000, 488.8999939, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2319.9521484, 22.4980469, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2325.4492188, 22.4980469, 489.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.4580078, 20.8400002, 486.7999878, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2315.4580078, 20.8400002, 491.2000122, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2315.4580078, 20.0000000, 488.8999939, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(1649, -2315.4580078, 20.0000000, 488.8999939, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 20.4990234, 34.7000008, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.9521484, 11.3240004, 34.6899986, 0.0000000, 283.9965820, 270.0000000, lift_virtualworld);
    CreateDynamicObject(2413, -2342.4750977, 15.5000000, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2434, -2342.3671875, 17.1064453, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2435, -2342.3676758, 14.5640001, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2435, -2343.5000000, 17.2705078, 486.5000000, 0.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(2369, -2342.6992188, 14.7597656, 487.4299927, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(3026, -2342.6398926, 16.2420006, 487.1300049, 270.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(371, -2342.4299316, 15.8109999, 487.1300049, 270.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(3026, -2342.6398926, 15.3900003, 487.1300049, 269.9945068, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19273, -2326.6699219, 23.0791016, 488.0000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19273, -2327.3701172, 24.0000000, 36.7999992, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2319.9521484, 21.6298828, 487.0180054, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2316.3259277, 15.5000000, 487.0180054, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2339.9492188, 21.6298828, 487.0180054, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(2413, -2342.4750977, -1588.7070312, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2434, -2342.3671875, -1586.1673584, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2435, -2343.5000000, -1586.0019531, 486.5000000, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(2435, -2342.3671875, -1587.0976562, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2413, -2342.4746094, -1590.3212891, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2435, -2342.3676758, -1591.2600098, 486.5000000, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(2369, -2342.6992188, -1586.9000244, 487.4299927, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(3026, -2342.6499023, -1589.6500244, 487.1199951, 270.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(371, -2342.4299316, -1588.7189941, 487.1199951, 270.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(371, -2342.4299316, -1588.1149902, 487.1199951, 270.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(3026, -2342.6499023, -1590.3199463, 487.1199951, 270.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2343.5878906, -1579.0195312, 487.0180054, 0.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2339.3000488, -1578.5699463, 487.0180054, 0.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(3657, -2339.3000488, -1579.4699707, 487.0180054, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2339.3000488, -1579.0195312, 486.5899963, 90.0000000, 0.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19273, -2326.4492188, 23.0799999, 36.7999992, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 15.5000000, 34.7000008, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2333.4492188, 15.5000000, 36.5000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 20.4990234, 39.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18766, -2329.9521484, 15.5000000, 39.0000000, 90.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(18762, -2326.4492188, 15.5000000, 36.5000000, 0.0000000, 0.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.9521484, 22.1875000, 35.1199989, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.0046387, 8.8100004, 34.2639999, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2325.5048828, 8.8100004, 34.2639999, 0.0000000, 90.0000000, 0.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2322.9528809, 8.8100004, 34.2639999, 0.0000000, 90.0000000, 90.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2330.8449707, 11.3240004, 34.3959999, 90.0000000, 0.0000000, 180.0000000, lift_virtualworld);
    CreateDynamicObject(19435, -2329.0581055, 11.3240004, 34.3959999, 90.0000000, 0.0000000, 179.9945068, lift_virtualworld);
    CreateDynamicObject(19273, -2327.3701172, 24.0000000, 488.0000000, 0.0000000, 0.0000000, 270.0000000, lift_virtualworld);
    pickup_buy[0] = CreateDynamicPickup(1310, 2, -2341.5500488281, 15.819999694824, 487.20001220703, lift_virtualworld);
    pickup_buy[1] = CreateDynamicPickup(1310, 2, -2341.5500488281, -1588.3699951172, 487.20001220703, lift_virtualworld);
    CreateDynamic3DTextLabel("{FFFFFF}Use the elevator: \n{f99a00}/tlift", 0xFFFFFFF, -2326.44921875, 24, 488, 6.0, -1, -1, 0, lift_virtualworld);
    CreateDynamic3DTextLabel("{FFFFFF}Use the elevator: \n{f99a00}/tlift", 0xFFFFFFF, -2326.44921875, 24, 36.799999237061, 6.0, -1, -1, 0, lift_virtualworld);
    podjem = CreateDynamicObject(18763, -2329.9521484375, 24.498046875, 33.701999664307, 90.0, 0.0, 90.0, lift_virtualworld);
    elevat = CreateDynamicObject(5837, -2329.9521484375, 12.69921875, 488.2200012207, 0.0, 0.0, 90, lift_virtualworld);
    SetTimer("elevator", 160000, 1);
    return 1;
}

public elevator() {
    if (status_el == 0) {
        MoveDynamicObject(elevat, -2329.9521484375, -1569.1796875, 488.2200012207, mmlsspeed, 0.0, 0.0, 90.0);
        status_el = 1;
    } else {
        MoveDynamicObject(elevat, -2329.9521484375, 12.69921875, 488.2200012207, mmlsspeed, 0.0, 0.0, 90);
        status_el = 0;
    }
}

hook OPPickUpDynPickup(playerid, pickupid) {
    if (pickupid == pickup_buy[0] || pickupid == pickup_buy[1]) {
        FlexPlayerDialog(playerid, "ParachuteShopPurchase", DIALOG_STYLE_LIST, "Parachute shop", "Buy SkySA's parachute: It's worth $ 500", "Select", "Cancel");
    }
    return 1;
}

FlexDialog:ParachuteShopPurchase(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    SendClientMessageEx(playerid, 0xFFFFFFFF, "You purchased SkySA's parachute for $500.");
    GivePlayerWeaponEx(playerid, 46, 1);
    vault:PlayerVault(playerid, -500, "purchased SkySA's parachute for $500", Vault_ID_Government, 500, sprintf("%s purchased SkySA's parachute for $500", GetPlayerNameEx(playerid)));
    return 1;
}

stock MillenniumMountLiftCommand(playerid) {
    if (status_pod == 0) {
        MoveDynamicObject(podjem, -2329.9521484375, 24.498046875, 485.00698852539, mmlsspeed, 90.0, 0.0, 90.0);
        status_pod = 1;
    } else {
        MoveDynamicObject(podjem, -2329.9521484375, 24.498046875, 33.701999664307, mmlsspeed, 90.0, 0.0, 90);
        status_pod = 0;
    }
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} you have requested for Millennium Mountain Lift");
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_SECONDARY_ATTACK) {
        if (IsPlayerInRangeOfPoint(playerid, 10, -2328.7188, 23.9426, 36.2020) || IsPlayerInRangeOfPoint(playerid, 10, -2328.7188, 23.9426, 487.5070)) {
            MillenniumMountLiftCommand(playerid);
            return ~1;
        }
    }
    return 1;
}