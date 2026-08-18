#define Max_Hospitals 8
new ClosestHospital[MAX_PLAYERS];
enum e_hospitals {
    Float:coordX,
    Float:coordY,
    Float:coordZ,
    Float:faceA
}

new Float:HospitalData[Max_Hospitals][e_hospitals] = {
    { 2035.2452, -1413.6796, 16.9922, 132.8350 },
    { 1178.3337, -1324.4294, 14.1149, 273.9930 },
    { 1244.3488, 331.4708, 19.5547, 336.0298 },
    {-2167.2720, -2320.6868, 30.6250, 226.1721 },
    {-2658.4807, 632.9044, 14.4531, 180.7813 },
    {-315.7048, 1053.0593, 20.3403, 0.6717 },
    {-1514.8309, 2522.9158, 55.8234, 1.8020 },
    { 1578.0823, 1768.4539, 10.8203, 87.1432 }
};

stock GetClosestHospital(playerid) {
    new id, Float:tempdist[Max_Hospitals], i, Float:first;
    for (i = 0; i < Max_Hospitals; i++) {
        tempdist[i] = GetPlayerDistanceFromPoint(playerid, HospitalData[i][coordX], HospitalData[i][coordY], HospitalData[i][coordZ]);
        if (i == 0) first = tempdist[i], id = i;
        if (tempdist[i] < first) first = tempdist[i], id = i;
    }
    return id;
}

stock IntToHex(n) {
    new str[10];
    format(str, sizeof(str), "%06x", n >>> 8);
    return str;
}