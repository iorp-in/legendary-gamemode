#define MAX_Missiles 1000
#define MAX_Missile_Points 100
#define max_flight_height 400.0

enum Missile_Enum {
    bool:Missile_Site_Status,
    bool:Missile_Launch_In_Progress,
    bool:Missile_Launched,
    Launch_TimerID
}
new NuclearSite[Missile_Enum];
new Iterator:Missiles < MAX_Missiles > ;
enum Enum_Missile_Targets {
    Float:EM_Pos[3],
        Emis_ObjectID[4],
        current_step,
        move_timerid
}
new Missile_Targets[MAX_Missiles][Enum_Missile_Targets];

enum Enum_SMissiles {
    Float:SM_Pos[6]
}
new SMissiles[MAX_Missiles + 100][Enum_SMissiles];


hook OnGameModeInit() {
    for (new i; i < 11; i++) {
        for (new j; j < 4; j++) {
            new Float:xx = 730.00 + (i * 46);
            new Float:yy = 4150.00 + (j * 88);
            CreateDynamicObject(8419, xx, yy, -8.00000, 0.00000, 0.00000, 0.00000);
        }
    }
    new counter = 0;
    for (new i; i < 40; i++) {
        for (new j; j < 25; j++) {
            new Float:xx = 1155.00 - (i * 10);
            new Float:yy = 4175.00 + (j * 10);

            CreateDynamicObject(3277, xx, yy, 4.34000, 0.00000, 0.00000, 78.00000);
            CreateDynamicObject(3267, xx, yy, 4.40000, 0.00000, 0.00000, 180.00000);
            SMissiles[counter][SM_Pos][0] = xx;
            SMissiles[counter][SM_Pos][1] = yy;
            SMissiles[counter][SM_Pos][2] = 4.40000;
            SMissiles[counter][SM_Pos][3] = 0.0;
            SMissiles[counter][SM_Pos][4] = 0.0;
            SMissiles[counter][SM_Pos][5] = 180.00000;
            counter++;
        }
    }

    CreateDynamicObject(7479, 723.18579, 4264.53760, 3.82000, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(7336, 979.33539, 4153.06592, 3.83390, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(7479, 1065.61609, 4134.54688, 3.82000, 0.00000, 0.00000, 180.00000);
    CreateDynamicObject(7336, 1174.10742, 4266.44971, 3.82000, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(7479, 1195.55432, 4325.87988, 3.82000, 0.00000, 0.00000, 270.00000);
    CreateDynamicObject(7336, 902.73181, 4434.38135, 3.82000, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(7336, 1062.70251, 4434.39404, 3.82000, 0.00000, 0.00000, 90.00000);
    CreateDynamicObject(7479, 853.20172, 4455.85986, 3.82000, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(7336, 741.71191, 4343.19922, 3.82000, 0.00000, 0.00000, 0.00000);
    CreateDynamicObject(6990, 837.79858, 4124.54785, 3.84000, 0.00000, 0.00000, 180.00000);

    NuclearSite[Missile_Site_Status] = false;
    NuclearSite[Missile_Launch_In_Progress] = false;
    NuclearSite[Missile_Launched] = false;
    //SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Requesting all miltery personals to get into a safety zone, nuclear missiles are about to launch");
    return 1;
}

stock NuclearLaunchSite:AddMissile(playerid) {
    if (NuclearSite[Missile_Launched] || NuclearSite[Missile_Launch_In_Progress] || !NuclearSite[Missile_Site_Status]) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Unable to contact control center, please try again.");
    new missileid = Iter_Free(Missiles);
    if (missileid == INVALID_ITERATOR_SLOT) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}No Missile is free to target this location. Contact Control for more informations.");
    if (!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    else GetVehiclePos(GetPlayerVehicleID(playerid), Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    if (Missile_Targets[missileid][EM_Pos][2] > max_flight_height || Missile_Targets[missileid][EM_Pos][2] < 0) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Can not target this location, Reason: Out of range location");
    Iter_Add(Missiles, missileid);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[NLS]: {FFFFEE}Missile number %d is targeting this location, please leave are immediately.", missileid));
    return 1;
}

stock NuclearLaunchSite:RemoveMissile(playerid, missileid) {
    if (NuclearSite[Missile_Launched] || NuclearSite[Missile_Launch_In_Progress] || !NuclearSite[Missile_Site_Status]) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Unable to contact control center, please try again.");
    if (!Iter_Contains(Missiles, missileid)) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Missile is not set to any target.");
    SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Missile is now free to set target again.");
    Iter_SafeRemove(Missiles, missileid, missileid);
    return 1;
}

stock NuclearLaunchSite:StartLaunchSequence(playerid) {
    if (Iter_Count(Missiles) < 1) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Not enough targets are available to start the launch sequence.");
    NuclearSite[Launch_TimerID] = SetPreciseTimer("NlsLaunchMissiles", 10 * 1000, false, "d", playerid);
    SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Missile launch sequence started.");
    NuclearSite[Missile_Launch_In_Progress] = true;
    return 1;
}

stock NuclearLaunchSite:CancelLaunchSequence(playerid) {
    DeletePreciseTimer(NuclearSite[Launch_TimerID]);
    NuclearSite[Missile_Launch_In_Progress] = false;
    SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Missile launch sequence cancelled.");
    return 1;
}

forward NlsLaunchMissiles(playerid);
public NlsLaunchMissiles(playerid) {
    new total_targets = Iter_Count(Missiles);
    if (total_targets < 1) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Not enough targets are available to start the launch sequence.");
    NuclearSite[Missile_Launch_In_Progress] = false;
    NuclearSite[Missile_Launched] = true;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[NLS]: {FFFFEE} Nuclear launch site launched %d missiles.", total_targets));
    foreach(new missileid:Missiles) NuclearLaunchSite:LaunchMissile(missileid);
    return 1;
}

stock NuclearLaunchSite:HitTarget(missileid) {
    SetPreciseTimer("CreateMissileExplosion", 100, false, "fff", Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    SetPreciseTimer("CreateMissileExplosion", 1000, false, "fff", Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    SetPreciseTimer("CreateMissileExplosion", 2000, false, "fff", Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    SetPreciseTimer("CreateMissileExplosion", 3000, false, "fff", Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    SetPreciseTimer("CreateMissileExplosion", 4000, false, "fff", Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2]);
    new missile_count = Iter_Count(Missiles);
    if ((missile_count - 1) == 0) NuclearLaunchSite:LaunchComplete();
    SendClientMessageToAll(-1, sprintf("{4286f4}[NLS]: {FFFFEE}Missile %d hit the target at %s", missileid, GetCityName(Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2])));
    Iter_SafeRemove(Missiles, missileid, missileid);
    return 1;
}

forward CreateMissileExplosion(Float:xx, Float:yy, Float:zz);
public CreateMissileExplosion(Float:xx, Float:yy, Float:zz) {
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 0, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 1, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 2, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 5, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 10, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 0, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 1, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 2, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 5, 20);
    CreateExplosion(Float:xx + RandomEx(-30, 30), Float:yy + RandomEx(-30, 30), Float:zz + RandomEx(0, 5), 10, 20);
    return 1;
}

stock NuclearLaunchSite:LaunchComplete() {
    foreach(new i:Missiles) Iter_SafeRemove(Missiles, i, i);
    NuclearSite[Missile_Launched] = false;
    SendClientMessageToAll(-1, "{4286f4}[NLS]: {FFFFEE} All missiles hit there targets");
    return 1;
}

stock NuclearLaunchSite:LaunchMissile(missileid) {
    if (!Iter_Contains(Missiles, missileid) || (missileid < 0) || (missileid > sizeof SMissiles)) return 0;
    Missile_Targets[missileid][current_step] = 0;
    Missile_Targets[missileid][Emis_ObjectID][0] = CreateDynamicObject(3790, SMissiles[missileid][SM_Pos][0], SMissiles[missileid][SM_Pos][1], SMissiles[missileid][SM_Pos][2], SMissiles[missileid][SM_Pos][3], SMissiles[missileid][SM_Pos][4], SMissiles[missileid][SM_Pos][5], 0, 0);
    Missile_Targets[missileid][Emis_ObjectID][1] = CreateDynamicObject(3790, SMissiles[missileid][SM_Pos][0], SMissiles[missileid][SM_Pos][1] + 2, SMissiles[missileid][SM_Pos][2], SMissiles[missileid][SM_Pos][3], SMissiles[missileid][SM_Pos][4], SMissiles[missileid][SM_Pos][5], 0, 0);
    Missile_Targets[missileid][Emis_ObjectID][2] = CreateDynamicObject(3790, SMissiles[missileid][SM_Pos][0] + 2, SMissiles[missileid][SM_Pos][1], SMissiles[missileid][SM_Pos][2] + 2, SMissiles[missileid][SM_Pos][3], SMissiles[missileid][SM_Pos][4], SMissiles[missileid][SM_Pos][5], 0, 0);
    Missile_Targets[missileid][Emis_ObjectID][3] = CreateDynamicObject(3790, SMissiles[missileid][SM_Pos][0] + 2, SMissiles[missileid][SM_Pos][1] + 2, SMissiles[missileid][SM_Pos][2] + 2, SMissiles[missileid][SM_Pos][3], SMissiles[missileid][SM_Pos][4], SMissiles[missileid][SM_Pos][5], 0, 0);
    Missile_Targets[missileid][move_timerid] = SetPreciseTimer("MoveMissile", 2000, false, "d", missileid);
    return 1;
}

forward MoveMissile(missileid);
public MoveMissile(missileid) {
    if (!Iter_Contains(Missiles, missileid) || !IsValidDynamicObject(Missile_Targets[missileid][Emis_ObjectID][0]) || Missile_Targets[missileid][current_step] < 0) return 1;
    if (Missile_Targets[missileid][current_step] >= MAX_Missile_Points) {
        DestroyDynamicObjectEx(Missile_Targets[missileid][Emis_ObjectID][0]);
        DestroyDynamicObjectEx(Missile_Targets[missileid][Emis_ObjectID][1]);
        DestroyDynamicObjectEx(Missile_Targets[missileid][Emis_ObjectID][2]);
        DestroyDynamicObjectEx(Missile_Targets[missileid][Emis_ObjectID][3]);
        NuclearLaunchSite:HitTarget(missileid);
        DeletePreciseTimer(Missile_Targets[missileid][move_timerid]);
        return 1;
    }

    new Float:xx, Float:yy, Float:zz, Float:ryy, Float:rzz;
    NuclearLaunchSite:GetMissileNextCord(SMissiles[missileid][SM_Pos][0], SMissiles[missileid][SM_Pos][1], SMissiles[missileid][SM_Pos][2], Missile_Targets[missileid][EM_Pos][0], Missile_Targets[missileid][EM_Pos][1], Missile_Targets[missileid][EM_Pos][2], Missile_Targets[missileid][current_step], xx, yy, zz, ryy, rzz);
    new movetime = MoveDynamicObject(Missile_Targets[missileid][Emis_ObjectID][0], xx, yy, zz, 30, 0.0, ryy, (rzz - 90.0));
    MoveDynamicObject(Missile_Targets[missileid][Emis_ObjectID][1], xx, yy + 2, zz, 30, 0.0, ryy, (rzz - 90.0));
    MoveDynamicObject(Missile_Targets[missileid][Emis_ObjectID][2], xx + 2, yy, zz + 2, 20, 0.0, ryy, (rzz - 90.0));
    MoveDynamicObject(Missile_Targets[missileid][Emis_ObjectID][3], xx + 2, yy + 2, zz + 2, 30, 0.0, ryy, (rzz - 90.0));
    Missile_Targets[missileid][current_step]++;
    SetPreciseTimer("MoveMissile", movetime - 100, false, "d", missileid);
    return 1;
}

stock NuclearLaunchSite:GetMissileNextCord(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, step, & Float:xx, & Float:yy, & Float:zz, & Float:ryy, & Float:rzz) {
    new Float:points[MAX_Missile_Points][3];
    GetArcPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, 0.0, max_flight_height, Float:points);
    if (step + 1 >= MAX_Missile_Points) {
        xx = x2, yy = y2, zz = z2;
        GetRotationFor2Point3D(points[step][0], points[step][1], points[step][2], xx, yy, zz, Float:ryy, Float:rzz);
    } else {
        xx = points[step + 1][0], yy = points[step + 1][1], zz = points[step + 1][2];
        GetRotationFor2Point3D(points[step][0], points[step][1], points[step][2], points[step + 1][0], points[step + 1][1], points[step + 1][2], Float:ryy, Float:rzz);
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1 };
    new vehicleid = GetPlayerNearestVehicle(playerid, 10.0);
    new staticId = StaticVehicle:GetID(vehicleid);
    if (
        StaticVehicle:IsValidID(staticId) && GetVehicleModel(vehicleid) == 433 &&
        IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)
    ) UCP:AddCommand(playerid, "Target Nuclear Missile");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Target Nuclear Missile", inputtext)) {
        NuclearLaunchSite:AddMissile(playerid);
        return ~1;
    }
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 18) return 1;
    MissileStartCommand(playerid);
    return ~1;
}

stock MissileStartCommand(playerid) {
    if (strcmp(Faction:GetLeaderName(0), GetPlayerNameEx(playerid)) && strcmp(Faction:GetLeaderName(1), GetPlayerNameEx(playerid))) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}The President and General has the power to access nuclear launch site.");
    if (!Faction:IsPlayerSigned(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Sign in required to access nuclear launch site.");
    new string[512];
    if (!NuclearSite[Missile_Site_Status]) strcat(string, "Activate Nuclear Launch Site\n");
    else if (NuclearSite[Missile_Launch_In_Progress]) {
        strcat(string, "Cancel Missile's\n");
    } else if (!NuclearSite[Missile_Launched]) {
        strcat(string, "Remove Target\n");
        strcat(string, "Launch Missile's\n");
        strcat(string, "Deactivate Nuclear Launch Site\n");
    } else {
        return SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Missile launched, please wait till all the missiles hit there targets.");
    }
    return FlexPlayerDialog(playerid, "MissileStartCommand", DIALOG_STYLE_LIST, "{4286f4}[NLS]: {FFFFEE}Controls", string, "Select", "Close");
}

FlexDialog:MissileStartCommand(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Activate Nuclear Launch Site")) {
        NuclearSite[Missile_Site_Status] = true;
        SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Activated Nuclear Launch Site");
        return MissileStartCommand(playerid);
    }
    if (IsStringSame(inputtext, "Deactivate Nuclear Launch Site")) {
        NuclearSite[Missile_Site_Status] = false;
        SendClientMessage(playerid, -1, "{4286f4}[NLS]: {FFFFEE}Deactivated Nuclear Launch Site");
        return MissileStartCommand(playerid);
    }
    if (IsStringSame(inputtext, "Launch Missile's")) {
        NuclearLaunchSite:StartLaunchSequence(playerid);
        new allow_faction[] = {
            0,
            1
        };
        foreach(new i:Player) {
            if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(i)) && Faction:IsPlayerSigned(i)) SendClientMessage(i, -1, "{4286f4}[NLS]: {FFFFEE}Nuclear Missile launch in proccess, all military personnel advised to visit safe place.");
        }
        return MissileStartCommand(playerid);
    }
    if (IsStringSame(inputtext, "Cancel Missile's")) {
        NuclearLaunchSite:CancelLaunchSequence(playerid);
        return MissileStartCommand(playerid);
    }
    if (IsStringSame(inputtext, "Remove Target")) return NlsRemoveTarget(playerid);
    return 1;
}

stock NlsRemoveTarget(playerid) {
    return FlexPlayerDialog(playerid, "NlsRemoveTarget", DIALOG_STYLE_INPUT, "{4286f4}[NLS]: {FFFFEE}Controls", "Enter targeted missile Id", "Remove", "Close");
}

FlexDialog:NlsRemoveTarget(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return MissileStartCommand(playerid);
    NuclearLaunchSite:RemoveMissile(playerid, strval(inputtext));
    return MissileStartCommand(playerid);
}