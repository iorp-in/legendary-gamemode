//#region variables
#define XVEHICLE_TABLE "xVehicle"
#define VEHICLE_RESET_DAY           (180)

#define MAX_Buyable_Limit	        (3)	// Maximum car amount that one player can buy.
#define MAX_Garage_Vehicle_Limit	(3)	// Maximum car amount that one player can put into the garage.


new ImpoundDriveTest[MAX_PLAYERS];

enum PersonalVehicle:eData {
    xv_Veh,
    xv_ModelID,
    xv_Color[2],
    Float:xv_Pos[4],
    xv_Paintjob,
    xv_Park[14],
    xv_Owner[24],
    xv_Plate[8],
    xv_InGarage,
    xv_Impound,
    xv_ImpoundBy[50],
    xv_ImpoundReason[100],
    xv_lastUsage,
    Float:xv_KiloMeters,
    xv_CreatedAt,
    xv_Xenon,
    xv_XenonExpireAt,
    xv_HalloweenExpireAt,
    xv_AutoReset,
    STREAMER_TAG_3D_TEXT_LABEL:xv_Text,
    xv_Price,
    xv_neon,
    Float:xv_fuel,
    Float:xv_health,

    xv_remove_mod,
};

new PersonalVehicle:Data[MAX_VEHICLES][PersonalVehicle:eData],
    offerTimer[MAX_PLAYERS],
    Iterator:xVehicles < MAX_VEHICLES > ,
    Iterator:xVehicleKeys < MAX_PLAYERS, MAX_VEHICLES > ;

new dealership_cp[MAX_PLAYERS];

//#endregion variables

stock PersonalVehicle:GetTotalVehicleOnSale() {
    new total = 0;
    foreach(new xid:xVehicles) {
        if (!PersonalVehicle:IsPurchased(xid)) {
            total++;
        }
    }
    return total;
}

stock PersonalVehicle:GetPlayerVehicleLimit(playerid) {
    if (IsPlayerMasterAdmin(playerid)) return 100;
    else if (GetPlayerVIPLevel(playerid) == 1) return 6;
    else if (GetPlayerVIPLevel(playerid) == 2) return 9;
    else if (GetPlayerVIPLevel(playerid) == 3) return 12;
    else return MAX_Buyable_Limit;
}

stock PersonalVehicle:IsPlayerOwner(playerid, xid) {
    return IsStringSame(GetPlayerNameEx(playerid), PersonalVehicle:Data[xid][xv_Owner]);
}

stock PersonalVehicle:GetOwner(xid) {
    new string[50];
    if (PersonalVehicle:IsPurchased(xid)) format(string, sizeof string, "%s", PersonalVehicle:Data[xid][xv_Owner]);
    else format(string, sizeof string, "San Andreas Government Department");
    return string;
}

stock PersonalVehicle:UpdateOwner(xid, const owner[], bool:savesql = true) {
    format(PersonalVehicle:Data[xid][xv_Owner], MAX_PLAYER_NAME, "%s", owner);
    if (savesql) PersonalVehicle:SaveID(xid);
    return 1;
}

stock PersonalVehicle:IsInRange(playerid, xid, Float:range = 10.0) {
    new vehicleid = PersonalVehicle:GetVehicleID(xid);
    if (!IsValidVehicle(vehicleid)) return 0;
    return IsPlayerInRangeOfVehicle(playerid, vehicleid, range);
}

stock PersonalVehicle:IsPurchased(xid) {
    return strlen(PersonalVehicle:Data[xid][xv_Owner]);
}

stock Float:PersonalVehicle:GetFuel(xid) {
    return PersonalVehicle:Data[xid][xv_fuel];
}

stock Float:PersonalVehicle:UpdateFuel(xid, Float:fuel) {
    return PersonalVehicle:Data[xid][xv_fuel] = fuel;
}

stock PersonalVehicle:SetAutoResetState(xid, newstate) {
    return PersonalVehicle:Data[xid][xv_AutoReset] = newstate;
}

stock PersonalVehicle:AutoResetState(xid) {
    return PersonalVehicle:Data[xid][xv_AutoReset];
}

stock PersonalVehicle:GetLastUsage(xid) {
    return PersonalVehicle:Data[xid][xv_lastUsage];
}

stock PersonalVehicle:UpdateLastUsage(xid) {
    return PersonalVehicle:Data[xid][xv_lastUsage] = gettime();
}

stock PersonalVehicle:GetRegistrationTime(xid) {
    return PersonalVehicle:Data[xid][xv_CreatedAt];
}

stock PersonalVehicle:SetRegistationTime(xid, time) {
    return PersonalVehicle:Data[xid][xv_CreatedAt] = time;
}

stock PersonalVehicle:GetXenon(xid) {
    if (PersonalVehicle:Data[xid][xv_XenonExpireAt] < gettime()) return 0;
    return PersonalVehicle:Data[xid][xv_Xenon];
}

stock PersonalVehicle:SetXenon(xid, color = 0, expireAt = 0) {
    PersonalVehicle:Data[xid][xv_Xenon] = color;
    PersonalVehicle:Data[xid][xv_XenonExpireAt] = expireAt;
    return 1;
}

stock PersonalVehicle:GetHalloween(xid) {
    if (PersonalVehicle:Data[xid][xv_HalloweenExpireAt] < gettime()) return 0;
    return 1;
}

stock PersonalVehicle:SetHalloween(xid, expireAt) {
    PersonalVehicle:Data[xid][xv_HalloweenExpireAt] = expireAt;
    return 1;
}

stock Float:PersonalVehicle:GetKilometers(xid) {
    return PersonalVehicle:Data[xid][xv_KiloMeters];
}

stock Float:PersonalVehicle:SetKilometers(xid, Float:amount) {
    return PersonalVehicle:Data[xid][xv_KiloMeters] = amount;
}

stock PersonalVehicle:RemoveAllPlayerFrom(xid) {
    new vehicleid = PersonalVehicle:GetVehicleID(xid);
    foreach(new playerid:Player) if (GetPlayerVehicleID(playerid) == vehicleid) RemovePlayerFromVehicle(playerid);
    return 1;
}

stock Float:PersonalVehicle:UpdateKilometers(xid, Float:amount) {
    return PersonalVehicle:Data[xid][xv_KiloMeters] += amount;
}

stock PersonalVehicle:SeizeVehicle(xid) {
    PersonalVehicle:UpdateOwner(xid, "");
    SetVehicleToRespawn(PersonalVehicle:GetVehicleID(xid));
    return 1;
}

stock PersonalVehicle:ImpoundedBy(xid) {
    new string[50];
    format(string, sizeof string, "%s", PersonalVehicle:Data[xid][xv_ImpoundBy]);
    return string;
}

stock PersonalVehicle:ImpoundedReason(xid) {
    new string[100];
    format(string, sizeof string, "%s", PersonalVehicle:Data[xid][xv_ImpoundReason]);
    return string;
}

stock PersonalVehicle:SetVehicleImpoundState(vehicleid, newstate) {
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:Data[xid][xv_Veh] == vehicleid) {
            PersonalVehicle:Data[xid][xv_Impound] = newstate;
            PersonalVehicle:SaveID(xid);
        }
    }
    return 1;
}

stock PersonalVehicle:IsImpounded(xid) {
    if (!PersonalVehicle:IsPurchased(xid)) return 0;
    return PersonalVehicle:Data[xid][xv_Impound];
}

stock SetXVehiclePos(xid, Float:x, Float:y, Float:z, Float:a) {
    PersonalVehicle:Data[xid][xv_Pos][0] = x;
    PersonalVehicle:Data[xid][xv_Pos][1] = y;
    PersonalVehicle:Data[xid][xv_Pos][2] = z;
    PersonalVehicle:Data[xid][xv_Pos][3] = a;
    return 1;
}

forward PersonalVehicleRemove(xid);
public PersonalVehicleRemove(xid) {
    Iter_Remove(xVehicles, xid);
    DestroyVehicleEx(PersonalVehicle:Data[xid][xv_Veh]);
    mysql_tquery(Database, sprintf("delete from xVehicleKeys where VehicleID=%d", xid));
    mysql_tquery(Database, sprintf("delete from xVehicle where id = %d", xid));
    return 1;
}

stock PersonalVehicle:IsPlateExist(const plate[]) {
    foreach(new i:xVehicles) {
        if (IsStringSame(plate, PersonalVehicle:Data[i][xv_Plate])) return 1;
    }
    return 0;
}

stock PersonalVehicle:CreateVehicle(modelid, const owner[], price, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:vz_angle, color1, color2) {
    new xid = Iter_Free(xVehicles);
    if (xid == INVALID_ITERATOR_SLOT) return -1;
    Iter_Add(xVehicles, xid);

    PersonalVehicle:Data[xid][xv_Veh] = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, vz_angle, color1, color2);
    SetVehicleHealthEx(PersonalVehicle:Data[xid][xv_Veh], 1000);
    PersonalVehicle:Data[xid][xv_health] = 1000;
    PersonalVehicle:Data[xid][xv_InGarage] = 0;
    PersonalVehicle:Data[xid][xv_Impound] = 0;
    SetVehicleFuelEx(PersonalVehicle:Data[xid][xv_Veh], 10.0);
    PersonalVehicle:UpdateFuel(xid, 10.0);
    PersonalVehicle:SetKilometers(xid, 0);
    PersonalVehicle:SetRegistationTime(xid, gettime());
    PersonalVehicle:Data[xid][xv_lastUsage] = gettime();

    PersonalVehicle:Data[xid][xv_AutoReset] = 1;
    PersonalVehicle:Data[xid][xv_ModelID] = modelid;
    PersonalVehicle:Data[xid][xv_Color][0] = color1;
    PersonalVehicle:Data[xid][xv_Color][1] = color2;
    PersonalVehicle:Data[xid][xv_Paintjob] = -1;
    PersonalVehicle:Data[xid][xv_Pos][0] = spawn_x;
    PersonalVehicle:Data[xid][xv_Pos][1] = spawn_y;
    PersonalVehicle:Data[xid][xv_Pos][2] = spawn_z;
    PersonalVehicle:Data[xid][xv_Pos][3] = vz_angle;
    PersonalVehicle:UpdateOwner(xid, owner, false);
    PersonalVehicle:Data[xid][xv_Price] = price;
    plate_check:format(PersonalVehicle:Data[xid][xv_Plate], 8, "%s", PersonalVehicle:CreatePlate());
    foreach(new i:xVehicles) {
        if (i != xid && IsStringSame(PersonalVehicle:Data[xid][xv_Plate], PersonalVehicle:Data[i][xv_Plate])) goto plate_check;
    }
    SetVehicleNumberPlate(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Plate]);
    SetVehicleToRespawn(PersonalVehicle:Data[xid][xv_Veh]);
    new query[256];
    format(query, sizeof(query),
        "INSERT INTO xVehicle (`ID`,Owner,`Price`,`X`,`Y`,`Z`,`A`,`Model`,`Color1`,`Color2`,`Plate`) VALUES ('%d',\"%s\",'%d','%f','%f','%f','%f','%d','%d','%d',\"%s\")",
        xid, owner, price, spawn_x, spawn_y, spawn_z, vz_angle, modelid, color1, color2, PersonalVehicle:Data[xid][xv_Plate]
    );
    mysql_tquery(Database, query);
    return xid;
}

stock PersonalVehicle:SaveVehicleID(vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    return PersonalVehicle:SaveID(xid);
}

stock PersonalVehicle:SaveID(xid) {
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    new Float:xvHP;
    new vehicleid = PersonalVehicle:GetVehicleID(xid);
    if (IsValidVehicle(vehicleid)) {
        GetVehicleHealth(vehicleid, xvHP);
        GetVehiclePos(vehicleid, PersonalVehicle:Data[xid][xv_Pos][0], PersonalVehicle:Data[xid][xv_Pos][1], PersonalVehicle:Data[xid][xv_Pos][2]);
        GetVehicleZAngle(vehicleid, PersonalVehicle:Data[xid][xv_Pos][3]);
        GetVehicleColor(vehicleid, PersonalVehicle:Data[xid][xv_Color][0], PersonalVehicle:Data[xid][xv_Color][1]);
        PersonalVehicle:UpdateFuel(xid, GetVehicleFuelEx(vehicleid));
        if (xvHP < 250.00) xvHP = 250.00;
        PersonalVehicle:Data[xid][xv_health] = xvHP;
    }

    new query[2000];
    mysql_format(Database, query, sizeof(query),
        "UPDATE xVehicle SET Owner=\"%s\", Price=%d, neon=%d, fuel=%f, health=%f, X=%f, Y=%f, Z=%f, A=%f, \
        Model=%d, Color1=%d, Color2=%d, Plate= \"%s\", PJ=%d, InGarage=%d, impound=%d, impoundBy = \"%s\", impoundReason = \"%s\", \
        lastUsage=%d, kilometer=%f, createdAt=%d, xenon = %d, xenonExpireAt = %d, halloweenExpireAt = %d, \
        autoReset=%d, Park1=%d, Park2=%d, Park3=%d, Park4=%d, Park5=%d, Park6=%d, Park7=%d, Park8=%d, Park9=%d, Park10=%d, \
        Park11=%d, Park12=%d, Park13=%d, Park14=%d where ID=%d",
        PersonalVehicle:Data[xid][xv_Owner],
        PersonalVehicle:Data[xid][xv_Price],
        PersonalVehicle:Data[xid][xv_neon],
        PersonalVehicle:Data[xid][xv_fuel],
        PersonalVehicle:Data[xid][xv_health],
        PersonalVehicle:Data[xid][xv_Pos][0],
        PersonalVehicle:Data[xid][xv_Pos][1],
        PersonalVehicle:Data[xid][xv_Pos][2],
        PersonalVehicle:Data[xid][xv_Pos][3],
        PersonalVehicle:Data[xid][xv_ModelID],
        PersonalVehicle:Data[xid][xv_Color][0],
        PersonalVehicle:Data[xid][xv_Color][1],
        PersonalVehicle:Data[xid][xv_Plate],
        PersonalVehicle:Data[xid][xv_Paintjob],
        PersonalVehicle:Data[xid][xv_InGarage],
        PersonalVehicle:Data[xid][xv_Impound],
        PersonalVehicle:Data[xid][xv_ImpoundBy],
        PersonalVehicle:Data[xid][xv_ImpoundReason],
        PersonalVehicle:Data[xid][xv_lastUsage],
        PersonalVehicle:Data[xid][xv_KiloMeters],
        PersonalVehicle:Data[xid][xv_CreatedAt],
        PersonalVehicle:Data[xid][xv_Xenon],
        PersonalVehicle:Data[xid][xv_XenonExpireAt],
        PersonalVehicle:Data[xid][xv_HalloweenExpireAt],
        PersonalVehicle:Data[xid][xv_AutoReset],
        PersonalVehicle:Data[xid][xv_Park][0],
        PersonalVehicle:Data[xid][xv_Park][1],
        PersonalVehicle:Data[xid][xv_Park][2],
        PersonalVehicle:Data[xid][xv_Park][3],
        PersonalVehicle:Data[xid][xv_Park][4],
        PersonalVehicle:Data[xid][xv_Park][5],
        PersonalVehicle:Data[xid][xv_Park][6],
        PersonalVehicle:Data[xid][xv_Park][7],
        PersonalVehicle:Data[xid][xv_Park][8],
        PersonalVehicle:Data[xid][xv_Park][9],
        PersonalVehicle:Data[xid][xv_Park][10],
        PersonalVehicle:Data[xid][xv_Park][11],
        PersonalVehicle:Data[xid][xv_Park][12],
        PersonalVehicle:Data[xid][xv_Park][13],
        xid);
    mysql_tquery(Database, query);
    return 1;
}

stock PersonalVehicle:LoadMods(xid) {
    for (new c; c < 14; c++) AddVehicleComponent(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Park][c]);
    ChangeVehiclePaintjob(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Paintjob]);
    PersonalVehicle:LoadNeon(PersonalVehicle:GetVehicleID(xid));
    return 1;
}

stock PersonalVehicle:LoadKeysFor(playerid) {
    Iter_Clear(xVehicleKeys < playerid > );

    new query[72];
    mysql_format(Database, query, sizeof(query), "select * from xVehicleKeys where Isim = \"%s\"", GetPlayerNameEx(playerid));
    mysql_tquery(Database, query, "LoadCarKeys", "i", playerid);
    return 1;
}

stock PersonalVehicle:IsValidID(xid) {
    return Iter_Contains(xVehicles, xid);
}

stock PersonalVehicle:GetVehicleID(xid) {
    if (!PersonalVehicle:IsValidID(xid)) return -1;
    return PersonalVehicle:Data[xid][xv_Veh];
}

stock PersonalVehicle:IsInGarage(xid) {
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    return PersonalVehicle:Data[xid][xv_InGarage];
}

stock PersonalVehicle:GetName(xid) {
    new string[100];
    format(string, sizeof string, "Unknown");
    if (PersonalVehicle:IsValidID(xid)) format(string, sizeof string, "%s", GetVehicleModelName(PersonalVehicle:GetModelID(xid)));
    return string;
}

stock PersonalVehicle:SaveVehicleMod(vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid) || !IsValidVehicle(vehicleid)) return 1;
    PersonalVehicle:SaveMod(xid);
    return 1;
}

stock PersonalVehicle:GetID(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return -1;
    foreach(new i:xVehicles) {
        if (vehicleid == PersonalVehicle:Data[i][xv_Veh]) return i;
    }
    return -1;
}

stock PersonalVehicle:IsPlayerInAnyVehicle(playerid) {
    return PersonalVehicle:IsValidID(PersonalVehicle:GetID(GetPlayerVehicleID(playerid)));
}

stock PersonalVehicle:GetPrice(xid) {
    return PersonalVehicle:Data[xid][xv_Price];
}

stock PersonalVehicle:SetPrice(xid, newprice) {
    return PersonalVehicle:Data[xid][xv_Price] = newprice;
}

stock PersonalVehicle:GetModelID(xid) {
    return PersonalVehicle:Data[xid][xv_ModelID];
}

stock PersonalVehicle:IsHaveKey(playerid, xid) {
    return Iter_Contains(xVehicleKeys < playerid > , xid);
}

stock PersonalVehicle:GetPlate(xid) {
    new string[10];
    format(string, sizeof string, "%s", PersonalVehicle:Data[xid][xv_Plate]);
    return string;
}

stock PersonalVehicle:GetNeon(vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 0;
    return PersonalVehicle:Data[xid][xv_neon];
}

stock PersonalVehicle:SetNeon(vehicleid, neonid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 0;
    if (PersonalVehicle:IsValidID(xid)) PersonalVehicle:Data[xid][xv_neon] = neonid;
    return 1;
}

stock PersonalVehicle:LoadNeon(vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 0;
    if (PersonalVehicle:Data[xid][xv_neon] == 1) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, BLUE_NEON);
    if (PersonalVehicle:Data[xid][xv_neon] == 2) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, RED_NEON);
    if (PersonalVehicle:Data[xid][xv_neon] == 3) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, GREEN_NEON);
    if (PersonalVehicle:Data[xid][xv_neon] == 4) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, WHITE_NEON);
    if (PersonalVehicle:Data[xid][xv_neon] == 5) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, PINK_NEON);
    if (PersonalVehicle:Data[xid][xv_neon] == 6) SetVehicleNeonLights(PersonalVehicle:Data[xid][xv_Veh], true, YELLOW_NEON);
    return 1;
}

stock PersonalVehicle:GetIDByPlate(const plate[]) {
    foreach(new i:xVehicles) if (IsStringSame(plate, PersonalVehicle:Data[i][xv_Plate], true)) return i;
    return -1;
}

stock PersonalVehicle:CreatePlate() {
    const len = 7, hyphenpos = 4;
    new plate[len + 1];
    for (new i = 0; i < len; i++) {
        if (i + 1 == hyphenpos) {
            plate[i] = '-';
            continue;
        }
        if (random(2)) plate[i] = 'A' + random(26);
        else plate[i] = '0' + random(10);
    }
    return plate;
}

stock PersonalVehicle:SaveMod(xid) {
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    for (new i; i < 14; i++) {
        PersonalVehicle:Data[xid][xv_Park][i] = GetVehicleComponentInSlot(PersonalVehicle:Data[xid][xv_Veh], i);
    }
    PersonalVehicle:SaveID(xid);
    return 1;
}

stock PersonalVehicle:GetPlayerVehCount(const playername[]) {
    new count = 0;
    foreach(new xid:xVehicles) {
        if (IsStringSame(playername, PersonalVehicle:GetOwner(xid))) count++;
    }
    return count;
}

stock IsVehicleFlipped(vehicleid) {
    new Float:Quat[2];
    GetVehicleRotationQuat(vehicleid, Quat[0], Quat[1], Quat[0], Quat[0]);
    return (Quat[1] >= 0.60 || Quat[1] <= -0.60);
}

stock PersonalVehicle:GetPlayerVehicleCount(playerid) {
    new count;
    foreach(new xid:xVehicles) {
        if (IsStringSame(PersonalVehicle:GetOwner(xid), GetPlayerNameEx(playerid))) count++;
    }
    return count;
}

stock PersonalVehicle:GetGarageVehicleCount(playerid) {
    new count;
    foreach(new i:xVehicles) {
        if (PersonalVehicle:IsPlayerOwner(playerid, i) && PersonalVehicle:Data[i][xv_InGarage]) count++;
    }
    return count;
}

stock GetVehicleModelIDFromName(const vname[]) {
    for (new i = 0; i < 211; i++) {
        if (strfind(GetVehicleModelName(i + 400), vname, true) != -1)
            return i + 400;
    }
    return ~1;
}

stock split(const src[], dest[][], const delimiter) {
    new n_pos, num, old, string[1];
    string[0] = delimiter;
    while (n_pos != -1) {
        n_pos = strfind(src, string, false, n_pos + 1);
        strmid(dest[num++], src, (!num) ? 0 : old + 1, (n_pos == -1) ? strlen(src) : n_pos, 256);
        old = n_pos;
    }
    return 1;
}

stock PersonalVehicle:Menu(playerid) {
    new string[512];
    if (IsPlayerInAnyVehicle(playerid) && PersonalVehicle:GetID(GetPlayerVehicleID(playerid)) != 0) strcat(string, "{DCDC22}> {FFFB93}This Vehicle\n");
    strcat(string, "{DCDC22}> {FFFB93}My Own Vehicles\n");
    strcat(string, "{DCDC22}> {FFFB93}Vehicles That I Have Keys\n");
    if (GetPlayerAdminLevel(playerid) >= 8) strcat(string, "{DCDC22}> {FFFB93}Admin Panel\n");
    return FlexPlayerDialog(playerid, "PersonalVehicleMenu", DIALOG_STYLE_LIST, "Vehicle Menu", string, "Select", "Close");
}

FlexDialog:PersonalVehicleMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "> This Vehicle")) return PersonalVehicle:VehicleMenu(playerid, PersonalVehicle:GetID(GetPlayerVehicleID(playerid)));
    if (IsStringSame(inputtext, "> My Own Vehicles")) return PersonalVehicle:ShowOwnVehicles(playerid);
    if (IsStringSame(inputtext, "> Vehicles That I Have Keys")) return PersonalVehicle:ShowSharedVehicles(playerid);
    if (IsStringSame(inputtext, "> Admin Panel")) return PersonalVehicle:AdminPanel(playerid);
    return 1;
}

stock PersonalVehicle:ShowOwnVehicles(playerid) {
    return PersonalVehicle:ShowPlayerVehs(playerid, GetPlayerNameEx(playerid));
}

stock PersonalVehicle:ShowPlayerVehs(playerid, const playername[], page = 0) {
    new total = PersonalVehicle:GetPlayerVehCount(playername);
    if (total == 0) return AlexaMsg(playerid, sprintf("{FF0000}[!] {F0AE0F}%s don't have any vehicle!", playername));
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new string[2000], count = 0;
    strcat(string, "Plate Number\tVehicle Name\tState\n");
    foreach(new xid:xVehicles) {
        if (IsStringSame(PersonalVehicle:GetOwner(xid), playername)) {
            if (skip > 0) {
                skip--;
                continue;
            }
            count++;
            strcat(string, sprintf("%s\t%s\t%s\n",
                PersonalVehicle:GetPlate(xid),
                PersonalVehicle:GetName(xid),
                PersonalVehicle:IsInGarage(xid) ? ("{F0CE0F}In the Garage") : ("{8FE01F}On the Map")
            ));
        }
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, ">> Next Page");
    if (page > 0) strcat(string, ">> Previous Page");
    if (count == 0) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}There are no vehicles!");
    return FlexPlayerDialog(playerid, "PersonalVehVehicleSel", DIALOG_STYLE_TABLIST_HEADERS, "Vehicles List", string, "Select", "Back", page, sprintf("%s", playername));
}

FlexDialog:PersonalVehVehicleSel(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return PersonalVehicle:Menu(playerid);
    if (IsStringSame(inputtext, ">> Next Page")) return PersonalVehicle:ShowPlayerVehs(playerid, payload, page + 1);
    if (IsStringSame(inputtext, ">> Previous Page")) return PersonalVehicle:ShowPlayerVehs(playerid, payload, page - 1);
    new xid = PersonalVehicle:GetIDByPlate(inputtext);
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:ShowSharedVehicles(playerid, page = 0) {
    new total = Iter_Count(xVehicleKeys < playerid > );
    if (total == 0) return AlexaMsg(playerid, sprintf("{FF0000}[!] {F0AE0F}you don't have any shared vehicle!"));
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new string[2000], count = 0;
    strcat(string, "Plate Number\tVehicle Name\tState\n");
    foreach(new xid:xVehicleKeys < playerid > ) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf("%s\t%s\t%s\n",
            PersonalVehicle:GetPlate(xid),
            PersonalVehicle:GetName(xid),
            PersonalVehicle:IsInGarage(xid) ? ("{F0CE0F}In the Garage") : ("{8FE01F}On the Map")
        ));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, ">> Next Page");
    if (page > 0) strcat(string, ">> Previous Page");
    if (count == 0) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}There are no vehicles!");
    return FlexPlayerDialog(playerid, "SharedVehVehicleSel", DIALOG_STYLE_TABLIST_HEADERS, "Vehicles List", string, "Select", "Back", page);
}

FlexDialog:SharedVehVehicleSel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PersonalVehicle:Menu(playerid);
    new page = extraid;
    if (IsStringSame(inputtext, ">> Next Page")) return PersonalVehicle:ShowSharedVehicles(playerid, page + 1);
    if (IsStringSame(inputtext, ">> Previous Page")) return PersonalVehicle:ShowSharedVehicles(playerid, page - 1);
    new xid = PersonalVehicle:GetIDByPlate(inputtext);
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:VehicleMenu(playerid, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new string[1024];
    strcat(string, "{FFA500}> {FFFFFF} Where Is My Car?\n");
    // strcat(string, sprintf("%s\n", (PersonalVehicle:IsInGarage(xid)) ? (PersonalVehicle:IsPlayerOwner(playerid, xid)) ? ("{FFA500}> {FFFFFF} Take Out Vehicle From Garage") : ("{FFA500}> {FF0000} Take Out Vehicle From Garage") : (PersonalVehicle:IsPlayerOwner(playerid, xid)) ? ("{FFA500}> {FFFFFF} Put Vehicle In Garage") : ("{FFA500}> {FF0000} Put Vehicle In Garage")));
    strcat(string, sprintf("{FFA500}> {%s} Vehicle Keys\n", (!PersonalVehicle:IsPlayerOwner(playerid, xid)) ? ("FF0000") : ("FFFFFF")));
    strcat(string, sprintf("{FFA500}> {%s} Sell the Vehicle\n", (!PersonalVehicle:IsPlayerOwner(playerid, xid)) ? ("FF0000") : ("FFFFFF")));
    strcat(string, "{FFA500}> {CACACA} Vehicle Info\n");
    new allowedFaction[] = { 0, 1 };
    if (PersonalVehicle:IsPurchased(xid) && IsArrayContainNumber(allowedFaction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
        strcat(string, "{FFA500}> {CACACA} Seize Vehicle\n");
    }
    if (GetPlayerAdminLevel(playerid) >= 8) {
        strcat(string, "{FFA500}> {CACACA} Set Price\n");
        strcat(string, "{FFA500}> {CACACA} Remove Mods\n");
        strcat(string, "{FFA500}> {CACACA} Seize Vehicle Admin\n");
        if (!PersonalVehicle:IsInGarage(xid)) strcat(string, "{FFA500}> {CACACA} Remove from server\n");
        if (!PersonalVehicle:IsInGarage(xid)) strcat(string, "{FFA500}> {CACACA} Teleport to vehicle\n");
        if (!PersonalVehicle:IsInGarage(xid)) strcat(string, "{FFA500}> {CACACA} Teleport vehicle to you\n");
        if (PersonalVehicle:AutoResetState(xid)) strcat(string, "{FFA500}> {CACACA} Disable Auto Reset\n");
        else strcat(string, "{FFA500}> {CACACA} Enabled Auto Reset\n");
    }
    FlexPlayerDialog(playerid, "PersonalVehOptions", DIALOG_STYLE_LIST, "Vehicle Menu", string, "Select", "Back", xid);
    return 1;
}

FlexDialog:PersonalVehOptions(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PersonalVehicle:Menu(playerid);
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");

    if (IsStringSame(inputtext, ">  Seize Vehicle")) {
        if (!IsPlayerInServerByName(PersonalVehicle:GetOwner(xid))) {
            Email:Send(
                ALERT_TYPE_PROPERTY_EXPIRE,
                PersonalVehicle:GetOwner(xid),
                sprintf(
                    "Vehicle %s with plate %s [%d] has seized by %s (%s)!!",
                    PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid,
                    GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))
                ),
                sprintf(
                    "Vehicle %s with plate %s [%d] has seized by %s (%s)!! \
                    you can raise a case with justice department if this was not acknowledged by you before.",
                    PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid,
                    GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))
                )
            );
        }
        Discord:SendNotification(sprintf("\
        **Property Seized Alert**\n\
        ```\n\
        Owner: %s\n\
        Type: Vehicle\n\
        Model: %s\n\
        Plate: %s\n\
        Status: seized\n\
        Reason: seize by %s (%s)\n\
        ```", PersonalVehicle:GetOwner(xid), PersonalVehicle:GetName(xid),
            PersonalVehicle:GetPlate(xid),
            GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))
        ));
        PersonalVehicle:SeizeVehicle(xid);
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Remove Mods")) {
        PersonalVehicle:RemoveMod(xid);
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Remove from server")) {
        AlexaMsg(playerid, sprintf("you have removed %s with plate %s (%d) from server", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
        PersonalVehicleRemove(xid);
        return PersonalVehicle:Menu(playerid);
    }
    if (IsStringSame(inputtext, ">  Seize Vehicle Admin")) {
        PersonalVehicle:SeizeVehicle(xid);
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Teleport to vehicle")) {
        new vehicleid = PersonalVehicle:GetVehicleID(xid);
        new Float:x, Float:y, Float:z, Float:a;
        GetVehiclePos(vehicleid, x, y, z);
        GetXYInFrontOfVehicle(vehicleid, x, y, 5);
        GetVehicleZAngle(vehicleid, a);
        SetPlayerPosEx(playerid, x, y, z + 2);
        SetPlayerFacingAngle(playerid, a - 180);
        AlexaMsg(playerid, sprintf("you are teleported to vehicle %s", PersonalVehicle:GetPlate(xid)));
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Teleport vehicle to you")) {
        new vehicleid = PersonalVehicle:GetVehicleID(xid);
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetXYInFrontOfPlayer(playerid, x, y, 5);
        GetPlayerFacingAngle(playerid, a);
        SetVehiclePosEx(vehicleid, x, y, z);
        SetVehicleZAngle(vehicleid, a - 180);
        AlexaMsg(playerid, sprintf("vehicle %s teleported to your location", PersonalVehicle:GetPlate(xid)));
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Where Is My Car?")) {
        if (PersonalVehicle:IsInGarage(xid)) {
            if (PersonalVehicle:IsPlayerOwner(playerid, xid)) AlexaMsg(playerid, "{FFA500}This vehicle is in the garage. You can take it from the garage by choosing the option in the vehicle menu.");
            else AlexaMsg(playerid, "{FFA500}This vehicle is in the garage. Only the vehicle owner can take it out from the garage.");
        } else {
            if (IsValidDynamicCP(dealership_cp[playerid])) {
                DestroyDynamicCP(dealership_cp[playerid]);
                dealership_cp[playerid] = -1;
                AlexaMsg(playerid, "{00BD00}[!] {00FF00}Vehicle marker removed from the map!");
            } else {
                new Float:vpos[3];
                GetVehiclePos(PersonalVehicle:Data[xid][xv_Veh], vpos[0], vpos[1], vpos[2]);
                dealership_cp[playerid] = CreateDynamicCP(Float:vpos[0], vpos[1], vpos[2], 3.0, -1, -1, playerid, 999999);
                AlexaMsg(playerid, "{00BD00}[!] {00FF00}Vehicle has marked on the map!");
            }
        }
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }

    if (IsStringSame(inputtext, ">  Put Vehicle In Garage") || IsStringSame(inputtext, ">  Take Out Vehicle From Garage")) {
        if (!PersonalVehicle:IsPlayerOwner(playerid, xid)) {
            AlexaMsg(playerid, "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!");
            return PersonalVehicle:VehicleMenu(playerid, xid);
        }
        if (PersonalVehicle:IsInGarage(xid)) {
            PersonalVehicle:Data[xid][xv_Veh] = AddStaticVehicle(PersonalVehicle:Data[xid][xv_ModelID], PersonalVehicle:Data[xid][xv_Pos][0], PersonalVehicle:Data[xid][xv_Pos][1], PersonalVehicle:Data[xid][xv_Pos][2], PersonalVehicle:Data[xid][xv_Pos][3], PersonalVehicle:Data[xid][xv_Color][0], PersonalVehicle:Data[xid][xv_Color][1]);
            SetVehicleNumberPlate(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Plate]);
            SetVehicleToRespawn(PersonalVehicle:Data[xid][xv_Veh]);
            PersonalVehicle:Data[xid][xv_InGarage] = 0;
            PersonalVehicle:SaveID(xid);
            AlexaMsg(playerid, sprintf(
                "{ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number has taken from the garage!", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)
            ));
        } else {
            if (PersonalVehicle:IsImpounded(xid)) {
                AlexaMsg(playerid, "this vehicle is impounded by law enforcement, please contact 911 for more info");
                return PersonalVehicle:VehicleMenu(playerid, xid);
            }
            if (PersonalVehicle:GetGarageVehicleCount(playerid) >= PersonalVehicle:GetPlayerVehicleLimit(playerid)) {
                AlexaMsg(playerid, "{FF0000}[!] {DCDC22}You have reached the limit! You can't put more vehicles into the garage.");
                return PersonalVehicle:VehicleMenu(playerid, xid);
            }
            foreach(new i:Player) {
                if (IsPlayerInVehicle(i, PersonalVehicle:Data[xid][xv_Veh])) RemovePlayerFromVehicle(i);
            }
            PersonalVehicle:UpdateFuel(xid, GetVehicleFuelEx(PersonalVehicle:GetVehicleID(xid)));
            GetVehicleHealth(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_health]);
            if (PersonalVehicle:Data[xid][xv_health] < 250.00) PersonalVehicle:Data[xid][xv_health] = 250.00;
            DestroyVehicle(PersonalVehicle:Data[xid][xv_Veh]);
            PersonalVehicle:Data[xid][xv_InGarage] = 1;
            PersonalVehicle:Data[xid][xv_Veh] = -1;
            PersonalVehicle:SaveID(xid);
            AlexaMsg(playerid, sprintf(
                "{ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number has put into the garage!",
                PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)
            ));
        }
        PersonalVehicle:VehicleMenu(playerid, xid);
        return ~1;
    }
    if (IsStringSame(inputtext, ">  Vehicle Keys")) return PersonalVehicle:ManageKeys(playerid, xid);
    if (IsStringSame(inputtext, ">  Sell the Vehicle")) {
        if (!IsPlayerInRangeOfVehicle(playerid, PersonalVehicle:GetVehicleID(xid), 10.0)) {
            AlexaMsg(playerid, "you have to near vehicle to perform sale action");
            return PersonalVehicle:VehicleMenu(playerid, xid);
        }
        PersonalVehicle:SellMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Vehicle Info")) return PersonalVehicle:ShowVehicleInfo(playerid, xid);
    if (IsStringSame(inputtext, ">  Disable Auto Reset")) {
        PersonalVehicle:SetAutoResetState(xid, 0);
        AlexaMsg(playerid, sprintf("Auto reset disabled for %s (%s)", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)));
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Enabled Auto Reset")) {
        PersonalVehicle:SetAutoResetState(xid, 1);
        AlexaMsg(playerid, sprintf("Auto reset enabled for %s (%s)", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)));
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    if (IsStringSame(inputtext, ">  Set Price")) return PersonalVehicle:AdminMenuSetPrice(playerid, xid);
    return 1;
}

stock PersonalVehicle:AdminMenuSetPrice(playerid, xid) {
    return FlexPlayerDialog(
        playerid, "PersonalVehMenuSetPrice", DIALOG_STYLE_INPUT, "Update Price",
        sprintf("Current Price: $%s\nEnter new selling price", FormatCurrency(PersonalVehicle:GetPrice(xid))),
        "Update", "Cancel", xid
    );
}

FlexDialog:PersonalVehMenuSetPrice(playerid, response, listitem, const inputtext[], xid, const payload[]) {
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    new newprice;
    if (sscanf(inputtext, "d", newprice) || newprice < 1) return PersonalVehicle:AdminMenuSetPrice(playerid, xid);
    PersonalVehicle:SetPrice(xid, newprice);
    PersonalVehicle:SaveID(xid);
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:ManageKeys(playerid, xid) {
    if (!PersonalVehicle:IsPlayerOwner(playerid, xid)) {
        AlexaMsg(playerid, "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!");
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    new string[512];
    strcat(string, "{DCDC22}> {FFFB93}View Key Owners\n");
    strcat(string, "{DCDC22}> {FFFB93}Give Someone Key\n");
    strcat(string, "{DCDC22}> {FFFB93}Change the Lock\n");
    FlexPlayerDialog(playerid, "PersonalMenuManageKeys", DIALOG_STYLE_LIST, "Vehicle Keys", string, "Select", "Go Back", xid);
    return 1;
}

FlexDialog:PersonalMenuManageKeys(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    if (IsStringSame(inputtext, "> View Key Owners")) return PersonalVehicle:ViewOwners(playerid, xid);
    if (IsStringSame(inputtext, "> Give Someone Key")) return PersonalVehicle:GiveKeyMenu(playerid, xid);
    if (IsStringSame(inputtext, "> Change the Lock")) return PersonalVehicle:ChangeLock(playerid, xid);
    return 1;
}

stock PersonalVehicle:ViewOwners(playerid, xid, page = 0) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new skip = page * perpage;
    new Cache:keys = mysql_query(Database, sprintf("SELECT Isim FROM xVehicleKeys where VehicleID=%d ORDER BY VehicleID DESC LIMIT %d, %d", xid, skip, perpage));
    new total = cache_num_rows();
    new remaining = total - paged;
    if (total == 0) {
        cache_delete(keys);
        AlexaMsg(playerid, "No one has your vehicle's keys!");
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }

    // collect owners
    new owners[2000], pName[100];
    strcat(owners, "Player Name\n");
    for (new i; i < total; ++i) {
        cache_get_value_name(i, "Isim", pName);
        strcat(owners, sprintf("%s\n", pName));
    }
    if (remaining > 0) strcat(owners, "{F4D00B}>> Next Page\n");
    if (page > 0) strcat(owners, "{F4D00B}>> Previous Page\n");
    cache_delete(keys);
    return FlexPlayerDialog(playerid, "PersonalVehOwnersView", DIALOG_STYLE_TABLIST_HEADERS, sprintf("Key Owners (Page %d)", page), owners, "Select", "Back", xid, sprintf("%d", page));
}

FlexDialog:PersonalVehOwnersView(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid, page = strval(payload);
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (IsStringSame(inputtext, ">> Next Page")) return PersonalVehicle:ViewOwners(playerid, xid, page + 1);
    if (IsStringSame(inputtext, ">> Previous Page")) return PersonalVehicle:ViewOwners(playerid, xid, page - 1);

    new friendid = GetPlayerIDByName(inputtext);
    if (IsPlayerConnected(friendid)) {
        Iter_Remove(xVehicleKeys < friendid > , xid);
        if (IsPlayerInAnyVehicle(friendid)) {
            new vehicleid = GetPlayerVehicleID(friendid);
            if (vehicleid == PersonalVehicle:GetVehicleID(xid)) RemovePlayerFromVehicle(friendid);
        }
        AlexaMsg(friendid, sprintf("{ECEC13}%s {FFFB93}has took the keys of {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, back!",
            GetPlayerNameEx(playerid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)
        ));
    }

    mysql_tquery(Database, sprintf("delete from xVehicleKeys where VehicleID = %d AND Isim= \"%s\"", xid, inputtext));
    AlexaMsg(playerid, sprintf("You took the keys of {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, from {ECEC13}%s{FFFB93}",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), inputtext
    ));
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:GiveKeyMenu(playerid, xid) {
    return FlexPlayerDialog(playerid, "PersonalVehGiveKeyMenu", DIALOG_STYLE_INPUT,
        "Give Vehicle Key", "{FFFB93}Enter the player's ID or name that you want to give the key:", "Next", "Back", xid
    );
}

FlexDialog:PersonalVehGiveKeyMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    new friendid;
    if (sscanf(inputtext, "u", friendid) || friendid == playerid) return PersonalVehicle:GiveKeyMenu(playerid, xid);
    if (!PersonalVehicle:IsInRange(playerid, xid, 5.0)) {
        AlexaMsg(playerid, "You can only give keys when you and your friend are near to the vehicle.");
        return PersonalVehicle:GiveKeyMenu(playerid, xid);
    }
    if (!IsPlayerInRangeOfPlayer(playerid, friendid, 5.0)) {
        AlexaMsg(playerid, "The player is not near you, you can give keys only to nearest players.");
        return PersonalVehicle:GiveKeyMenu(playerid, xid);
    }
    if (PersonalVehicle:IsHaveKey(friendid, xid)) {
        AlexaMsg(playerid, "The player already have keys of this vehicle.");
        return PersonalVehicle:GiveKeyMenu(playerid, xid);
    }
    Iter_Add(xVehicleKeys < friendid > , xid);
    mysql_tquery(Database, sprintf("INSERT INTO xVehicleKeys SET VehicleID = %d, Isim= \"%s\"", xid, GetPlayerNameEx(friendid)));
    AlexaMsg(playerid, sprintf("You gave the keys of the {ECEC13}%s {FFFB93} with {ECEC13}%s {FFFB93}plate number, to {ECEC13}%s {FFFB93}successfully!",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), GetPlayerNameEx(friendid)
    ));
    AlexaMsg(friendid, sprintf("{ECEC13}%s {FFFB93}has gave you the keys of {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number!",
        GetPlayerNameEx(playerid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)
    ));

    AlexaMsg(playerid, sprintf("you have give the keys of {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number to %s!",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), GetPlayerNameEx(friendid)
    ));
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:ChangeLock(playerid, xid) {
    return FlexPlayerDialog(playerid, "PersonalVehChangeKey", DIALOG_STYLE_MSGBOX,
        "Change The Lock", "{FFFB93}Are you sure that you want to change the lock?\nAll keys will be removed from key owners.", "Confirm", "Cancel", xid
    );
}

FlexDialog:PersonalVehChangeKey(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);

    foreach(new i:Player) {
        if (IsPlayerInVehicle(i, PersonalVehicle:GetVehicleID(xid)) && !PersonalVehicle:IsPlayerOwner(i, xid)) {
            AlexaMsg(i, "{FF0000}[!] {DCDC22}You have removed from vehicle because of the owner of this vehicle has changed the lock.");
            RemovePlayerFromVehicle(i);
        }
        if (PersonalVehicle:IsHaveKey(i, xid)) Iter_Remove(xVehicleKeys < i > , xid);
    }
    mysql_tquery(Database, sprintf("delete from xVehicleKeys where VehicleID=%d", xid));
    AlexaMsg(playerid, "{00BD00}[!] {00FF00}You have succesfully changed vehicle's lock!");
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:SellMenu(playerid, xid) {
    if (!PersonalVehicle:IsPlayerOwner(playerid, xid) && GetPlayerAdminLevel(playerid) < 8) {
        AlexaMsg(playerid, "{FF0000}[ERROR] {FFA500}Only the vehicle owner can use this feature!");
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    new string[512];
    strcat(string, "{DCDC22}> {FFFB93}Sell To Government\n");
    strcat(string, "{DCDC22}> {FFFB93}Sell To Player\n");
    FlexPlayerDialog(playerid, "PersonalVehSellResp", DIALOG_STYLE_LIST, "Sell The Vehicle", string, "Select", "Back", xid);
    return 1;
}

FlexDialog:PersonalVehSellResp(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    if (IsStringSame(inputtext, "> Sell To Government")) {
        new Float:posx[4];
        Dealership_GetNearestCarLoc(playerid, posx[0], posx[1], posx[2], posx[3]);
        if (!IsPlayerInRangeOfPoint(playerid, 20.0, posx[0], posx[1], posx[2])) {
            AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}To sell your vehicle to SAGD, go to nearest dealership and use this function there!");
            return PersonalVehicle:SellMenu(playerid, xid);
        }
        return PersonalVehicle:SellVehicleToGovernment(playerid, xid);
    }
    if (IsStringSame(inputtext, "> Sell To Player")) return PersonalVehicle:SellVehicleToPlayer(playerid, xid);
    return 1;
}

stock PersonalVehicle:SellVehicleToPlayer(playerid, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (PersonalVehicle:IsInGarage(xid)) {
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Before you sell your vehicle, take it out from the garage!");
        return PersonalVehicle:VehicleMenu(playerid, xid);
    }
    return FlexPlayerDialog(playerid, "PersonalVehSaleToFriend", DIALOG_STYLE_INPUT, "Sell Vehicle to Player",
        "{FFFB93}Enter the name or ID of the player that you want to sell your vehicle:", "Next", "Back", xid
    );
}

FlexDialog:PersonalVehSaleToFriend(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    new friendid;
    if (sscanf(inputtext, "u", friendid) || friendid == playerid) return PersonalVehicle:SellVehicleToPlayer(playerid, xid);
    if (!IsPlayerInRangeOfPlayer(playerid, friendid, 10.0)) {
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}The player is not close to you, you can not sale the vehicle.");
        return PersonalVehicle:SellVehicleToPlayer(playerid, xid);
    }
    if (PersonalVehicle:GetPlayerVehicleCount(friendid) >= PersonalVehicle:GetPlayerVehicleLimit(friendid)) {
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}This player has reached the max limit! Can't have more vehicles.");
        return PersonalVehicle:SellVehicleToPlayer(playerid, xid);
    }
    return PersonalVehicle:SendSaleOffer(playerid, friendid, xid);
}

stock PersonalVehicle:SendSaleOffer(playerid, friendid, xid) {
    if (!IsPlayerConnected(friendid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Player is not connected to server!");
    return FlexPlayerDialog(playerid, "PersonalVehSaleOfferPrice", DIALOG_STYLE_INPUT, "Sell The Vehicle",
        sprintf("{FFFB93}Selected player:{ECEC13}%s {ECB021}(%d)\n\n{FFFB93}Enter the price you want:", GetPlayerNameEx(friendid), friendid),
        "Send Offer", "Cancel", xid, sprintf("%d", friendid)
    );
}

FlexDialog:PersonalVehSaleOfferPrice(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    new friendid = strval(payload);
    if (!IsPlayerConnected(friendid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Player is not connected to server!");
    new offerprice;
    if (sscanf(inputtext, "d", offerprice) || offerprice < 1 || offerprice > 1000000) return PersonalVehicle:SendSaleOffer(playerid, friendid, xid);
    AlexaMsg(playerid, sprintf("{00BD00}[!] {FFFB93}Offer has sent to {ECEC13}%s", GetPlayerNameEx(friendid)));
    return PersonalVehicle:ShowSaleOffer(playerid, friendid, offerprice, xid);
}

stock PersonalVehicle:ShowSaleOffer(playerid, friendid, amount, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new string[512];
    strcat(string, "{FFFFFF}--------------------[ Vehicle Sale Offer ]-------------------\n\n");
    strcat(string, sprintf("{ECEC13}%s {FFFB93}has offering to sell you a vehicle.\n\n", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Vehicle Name:{ECB021}%s\n", PersonalVehicle:GetName(xid)));
    strcat(string, sprintf("{FFFB93}Plate Number:{ECB021}%s\n", PersonalVehicle:GetPlate(xid)));
    strcat(string, sprintf("{FFFB93}Price:{00E900}$%s\n\n", FormatCurrency(amount)));
    strcat(string, "{FFFB93}Do you want to buy this vehicle?\n\n");
    strcat(string, "{FFFFFF}----------------------------------------------------------------------------");
    return FlexPlayerDialog(friendid, "PersonalVehSaleOfferConfirm", DIALOG_STYLE_MSGBOX, "Vehicle Sale Offer", string, "Accept", "Reject", xid, sprintf("%d %d %d", playerid, amount, gettime()));
}

FlexDialog:PersonalVehSaleOfferConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new senderid, amount, offertime;
    if (sscanf(payload, "d d d", senderid, amount, offertime) || !IsPlayerConnected(senderid) || amount < 1 || amount > 1000000 || gettime() - offertime > 15 * 1000) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Offer expired!");
    if (!response) {
        AlexaMsg(senderid, "{FF0000}[!] {F0AE0F}Offer rejected!");
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Offer rejected!");
        return 1;
    }
    if (GetPlayerCash(playerid) < amount) {
        AlexaMsg(senderid, "{FF0000}[!] {F0AE0F}Offer cancelled!");
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}you don't have enough money to purchase this vehicle!");
        return 1;
    }

    // perform transfer
    GivePlayerCash(playerid, -amount, sprintf("bought vehicle from %s", GetPlayerNameEx(senderid)));
    GivePlayerCash(senderid, amount, sprintf("sold vehicle to %s", GetPlayerNameEx(playerid)));

    // update vehicle data
    PersonalVehicle:UpdateOwner(xid, GetPlayerNameEx(playerid));
    PersonalVehicle:Data[xid][xv_Price] = amount;
    PersonalVehicle:Data[xid][xv_AutoReset] = 1;
    PersonalVehicle:Data[xid][xv_lastUsage] = gettime();
    PersonalVehicle:SaveID(xid);

    // remove keys
    foreach(new i:Player) {
        if (PersonalVehicle:IsHaveKey(i, xid)) Iter_Remove(xVehicleKeys < i > , xid);
    }
    mysql_tquery(Database, sprintf("delete from xVehicleKeys where VehicleID=%d", xid));

    // show final confirmation to sender
    new string[512];
    format(string, sizeof string, "{FFFB93}You sold your {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number, to {ECEC13}%s{FFFB93}, for {00E900}$%s{FFFB93} succesfully!",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), GetPlayerNameEx(playerid), FormatCurrency(amount)
    );
    FlexPlayerDialog(senderid, "PersonalVehicleFinalConfirm", DIALOG_STYLE_MSGBOX, "Sell Vehicle", string, "OK", "");

    // show final confirmation to reciever
    format(string, sizeof string, "{FFFB93}You bought a {ECEC13}%s {FFFB93}with {ECEC13}%s {FFFB93}plate number, from {ECEC13}%s, for {00E900}$%s{FFFB93} succesfully!",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), GetPlayerNameEx(senderid), FormatCurrency(amount)
    );
    FlexPlayerDialog(playerid, "PersonalVehicleFinalConfirm", DIALOG_STYLE_MSGBOX, "Sell Vehicle", string, "OK", "");
    return 1;
}

FlexDialog:PersonalVehicleFinalConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    return 1;
}

stock PersonalVehicle:SellVehicleToGovernment(playerid, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new string[1024];
    strcat(string, "{ECCB13}Are you sure that you want to sell your vehicle to san andreas government department?\n");
    strcat(string, sprintf("{FFFB93}Amount of payment:{15EC13}$%s approx.\n\n", FormatCurrency(GetPercentageOf(RandomEx(50, 80), PersonalVehicle:GetPrice(xid)))));
    strcat(string, "{AAAAAA}(Payment is 50-80 percent of the price that you bought)");
    FlexPlayerDialog(playerid, "PersonalVehDirectSale", DIALOG_STYLE_MSGBOX, "Sell Vehicle To SAGD", string, "Confirm", "Back", xid);
    return 1;
}

FlexDialog:PersonalVehDirectSale(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    if (!response) return PersonalVehicle:VehicleMenu(playerid, xid);
    CallRemoteFunction("OnPersonalVehicleSold", "d", xid);

    new amount = GetPercentageOf(RandomEx(50, 80), PersonalVehicle:GetPrice(xid));
    if (amount > 0) {
        vault:PlayerVault(
            playerid, amount, sprintf("vehicle: %s with plate %s (%d) sold to sagd",
                GetVehicleName(PersonalVehicle:GetVehicleID(xid)), PersonalVehicle:GetPlate(xid), xid
            ),
            Vault_ID_Government, -amount, sprintf("%s: sold %s with plate %s (%d)",
                GetPlayerNameEx(playerid), GetVehicleName(PersonalVehicle:GetVehicleID(xid)), PersonalVehicle:GetPlate(xid), xid
            )
        );
    }

    foreach(new i:Player) {
        if (PersonalVehicle:IsHaveKey(i, xid)) Iter_Remove(xVehicleKeys < i > , xid);
    }

    PersonalVehicle:UpdateOwner(xid, "");
    PersonalVehicle:RemoveAllPlayerFrom(xid);

    new string[512];
    format(string, sizeof string,
        "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price:{00FF00}$%s",
        PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), FormatCurrency(PersonalVehicle:GetPrice(xid))
    );
    PersonalVehicle:Data[xid][xv_Text] = CreateDynamic3DTextLabel(string, 0x008080FF, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, PersonalVehicle:GetVehicleID(xid));

    mysql_tquery(Database, sprintf("delete from xVehicleKeys where VehicleID=%d", xid));
    AlexaMsg(playerid, "{00BD00}[!] {00FF00}You sold your vehicle!");
    return 1;
}

stock PersonalVehicle:ShowVehicleInfo(playerid, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    new string[2000];
    strcat(string, "{FFFFFF}----------[ Vehicle Information ]----------\n\n");
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Owner: {FFFFFF}%s\n", PersonalVehicle:GetOwner(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Vehicle Name: {FFFFFF}%s\n", PersonalVehicle:GetName(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Plate Number: {FFFFFF}%s\n", PersonalVehicle:GetPlate(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Driven: {FFFFFF}%.2f Kilometers\n", PersonalVehicle:GetKilometers(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Registation Date: {FFFFFF}%s\n", UnixToHumanEx(PersonalVehicle:GetRegistrationTime(xid))));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Last Used By Owner Time: {FFFFFF}%s\n", UnixToHumanEx(PersonalVehicle:GetLastUsage(xid))));
    if (PersonalVehicle:IsImpounded(xid)) strcat(string, sprintf("{F0AE0F}  > {ECE913}Impound Time: {FFFFFF}%s\n", UnixToHumanEx(PersonalVehicle:IsImpounded(xid))));
    if (PersonalVehicle:IsImpounded(xid)) strcat(string, sprintf("{F0AE0F}  > {ECE913}Impound By: {FFFFFF}%s\n", PersonalVehicle:ImpoundedBy(xid)));
    if (PersonalVehicle:IsImpounded(xid)) strcat(string, sprintf("{F0AE0F}  > {ECE913}Impound Reason: {FFFFFF}%s\n", PersonalVehicle:ImpoundedReason(xid)));
    FlexPlayerDialog(playerid, "PersonalVeh", DIALOG_STYLE_MSGBOX, " Vehicle Information", string, "Back", "", xid);
    return 1;
}

FlexDialog:PersonalVeh(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new xid = extraid;
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

stock PersonalVehicle:AdminPanel(playerid) {
    new string[1024];
    strcat(string, "{DCDC22}> {FFFB93}All Vehicles\n");
    strcat(string, "{DCDC22}> {FFFB93}Teleport all sale vehicles to your location\n");
    strcat(string, "{DCDC22}> {FFFB93}Remove all unused vehicles\n");
    strcat(string, "{DCDC22}> {FFFB93}Check players vehicle\n");
    strcat(string, "{DCDC22}> {FFFB93}Create Vehicle\n");
    return FlexPlayerDialog(playerid, "PersonalVehAdminRes", DIALOG_STYLE_LIST, "Personal Vehicle: Admin Panel", string, "Select", "Close");
}

FlexDialog:PersonalVehAdminRes(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "> Remove all unused vehicles")) {
        new count = 0;
        foreach(new xid:xVehicles) {
            if (!PersonalVehicle:IsPurchased(xid)) {
                SetPreciseTimer("PersonalVehicleRemove", (count + 1) * 1000, false, "d", xid);
                count++;
            }
        }
        AlexaMsg(playerid, sprintf("you have removed %d vehicles from server", count));
        PersonalVehicle:AdminPanel(playerid);
        return 1;
    }
    if (IsStringSame(inputtext, "> All Vehicles")) return PersonalVehicle:AdminAllVehicles(playerid);
    if (IsStringSame(inputtext, "> Teleport all sale vehicles to your location")) return PersonalVehicle:AdminGetAllSaleVeh(playerid);
    if (IsStringSame(inputtext, "> Check players vehicle")) return PersonalVehicle:AdminFindPlayerVehicles(playerid);
    if (IsStringSame(inputtext, "> Create Vehicle")) return PersonalVehicle:AdminCreateVehicle(playerid);
    return 1;
}

stock PersonalVehicle:AdminGetAllSaleVeh(playerid) {
    new string[2000];
    strcat(string, "[PerRow] [Row Distance] [Column Distance] [Vehicle Type] [Max Vehicles (0 for all)] [Skip (0 for none)]\n\n");
    strcat(string, "Vehicle Types:\n");
    strcat(string, "\tAll: -1\n");
    strcat(string, "\tCar: 0\n");
    strcat(string, "\tRC: 1\n");
    strcat(string, "\tTruck: 2\n");
    strcat(string, "\tTrailer: 3\n");
    strcat(string, "\tCycle: 4\n");
    strcat(string, "\tBike: 5\n");
    strcat(string, "\tHeli: 6\n");
    strcat(string, "\tPlane: 7\n");
    strcat(string, "\tBoat: 8\n");
    return FlexPlayerDialog(playerid, "AdminGetAllSaleVeh", DIALOG_STYLE_INPUT, "Teleport All Vehicles", string, "Submit", "Cancel");
}

FlexDialog:AdminGetAllSaleVeh(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PersonalVehicle:AdminPanel(playerid);

    new vehicleType = -1;
    new MaxVehicleTeleported = 0;
    new skip = 0;
    new row = 1;
    new perRowColumn = 20;
    new itemRowColumn = 1;
    new Float:rowDistance = 10.0;
    new Float:columnDistance = 10.0;
    if (
        sscanf(inputtext, "dffddd", perRowColumn, rowDistance, columnDistance, vehicleType, MaxVehicleTeleported, skip) ||
        perRowColumn < 1 || rowDistance < 1.0 || columnDistance < 1.0 || MaxVehicleTeleported < 0 || skip < 0 || vehicleType < -1 || vehicleType > 8
    ) return PersonalVehicle:AdminGetAllSaleVeh(playerid);

    new Float:x, Float:y, Float:z, Float:a, Float:faceangle;
    GetPlayerPos(playerid, x, y, z);
    if (IsPlayerInAnyVehicle(playerid)) {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
        GetVehicleZAngle(GetPlayerVehicleID(playerid), faceangle);
    } else {
        GetPlayerFacingAngle(playerid, a);
        GetPlayerFacingAngle(playerid, faceangle);
    }

    new totalVehicleTeleported = 0;
    GetXYInFrontOfPlayer(playerid, x, y, rowDistance);

    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPurchased(xid) || PersonalVehicle:IsInGarage(xid)) continue;
        if (skip > 0) {
            skip--;
            continue;
        }

        // validate vehicle type
        new vehicleid = PersonalVehicle:GetVehicleID(xid);
        new modelid = GetVehicleModel(vehicleid);
        if (vehicleType != -1 && !IsVehicleModelByType(modelid, vehicleType)) continue;

        // get row and column in row
        if (itemRowColumn >= perRowColumn) {
            itemRowColumn = 1, row++;
            GetXYInFrontOfPlayer(playerid, x, y, row * rowDistance);
        }

        // get next cordinates
        new Float:xx = x, Float:yy = y;
        GetXYOnAngleOfPos(xx, yy, a, 90.0, itemRowColumn * columnDistance);

        SetVehicleZAngle(vehicleid, faceangle - 180);
        SetVehiclePosEx(vehicleid, xx, yy, z);
        itemRowColumn++;
        totalVehicleTeleported++;

        if (MaxVehicleTeleported != 0 && totalVehicleTeleported >= MaxVehicleTeleported) break;
    }
    AlexaMsg(playerid, sprintf("teleported %d sale vehicles to your location", totalVehicleTeleported));
    return PersonalVehicle:AdminPanel(playerid);
}

stock PersonalVehicle:AdminFindPlayerVehicles(playerid) {
    return FlexPlayerDialog(playerid, "PersonalVehAdFindPlsVehs", DIALOG_STYLE_INPUT, "Player Vehicles", "Enter player name to show vehicle list", "Find", "Close");
}

FlexDialog:PersonalVehAdFindPlsVehs(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PersonalVehicle:AdminPanel(playerid);
    new playername[50];
    if (sscanf(inputtext, "s[50]", playername) || !IsValidAccount(playername)) {
        AlexaMsg(playerid, "Player does not exist");
        return PersonalVehicle:AdminFindPlayerVehicles(playerid);
    }

    new total = PersonalVehicle:GetPlayerVehCount(playername);
    if (!total) {
        AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}player don't have any personal vehicle!");
        return PersonalVehicle:AdminPanel(playerid);
    }

    return PersonalVehicle:ShowPlayerVehs(playerid, playername);
}

stock PersonalVehicle:AdminCreateVehicle(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) {
        AlexaMsg(playerid, "you are not in any vehicle, to create vehicle seat as driver and use this option.");
        return PersonalVehicle:AdminPanel(playerid);
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    new modelid = GetVehicleModel(vehicleid);
    new Float:ppos[4];
    GetVehiclePos(vehicleid, ppos[0], ppos[1], ppos[2]);
    GetVehicleZAngle(vehicleid, ppos[3]);
    new xid = PersonalVehicle:CreateVehicle(modelid, "", DynamicShopBusinessItem:GetVehicleDefaultPrice(modelid), ppos[0], ppos[1], ppos[2], ppos[3], -1, -1);
    SetVehicleToRespawnEx(PersonalVehicle:GetVehicleID(xid));
    GetXYInFrontOfVehicle(vehicleid, ppos[0], ppos[1], 10.0);
    SetVehiclePosEx(vehicleid, ppos[0], ppos[1], ppos[2]);
    SetVehicleZAngle(vehicleid, ppos[3] - 180);

    SendClientMessageEx(playerid, -1, "------------------------------------------------------------------------------------------------------------");
    SendClientMessageEx(playerid, -1, sprintf("{00FF00}[!] Vehicle {ECEC13}%s {ECB021}(%d) {FFFB93}has been created", PersonalVehicle:GetName(xid), modelid));
    SendClientMessageEx(playerid, -1, sprintf("{FFFB93}Plate number:{ECEC13}%s, {FFFB93}Vehicle xID:{ECB021}%d, {FFFB93}Price:{ECB021}$%s",
        PersonalVehicle:GetPlate(xid), xid, FormatCurrency(PersonalVehicle:GetPrice(xid))
    ));
    SendClientMessageEx(playerid, -1, "{FFFB93}To change the location of the vehicle, get into vehicle, go wherever you want and type {ECEC13}/park");
    SendClientMessageEx(playerid, -1, "------------------------------------------------------------------------------------------------------------");
    return PersonalVehicle:AdminPanel(playerid);
}

FlexDialog:PersonalVehAdCreateVeh(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    return 1;
}

stock PersonalVehicle:GetTotalPage() {
    new totalVehs = Iter_Count(xVehicles);
    new perpage = 25;
    return floatround(totalVehs / perpage);
}

stock PersonalVehicle:AdminAllVehicles(playerid, page = 0) {
    new total = Iter_Count(xVehicles);
    new perpage = 25;
    new count = 0;
    new paged = page * perpage;
    new skip = page * perpage;
    new remaining = total - paged;
    new string[2000];
    strcat(string, "Plate Number\tVehicle Name\tOwner\n");
    foreach(new xid:xVehicles) {
        if (skip > 0) {
            skip--;
            continue;
        }
        strcat(string, sprintf("%s\t%s\t%s\n", PersonalVehicle:GetPlate(xid), PersonalVehicle:GetName(xid), PersonalVehicle:GetOwner(xid)));
        count++;
        if (count == perpage) break;
    }
    if (remaining > 0) strcat(string, "{F4D00B}>> Next Page\n");
    if (page > 0) strcat(string, "{F4D00B}>> Previous Page\n");
    if (total > 50) strcat(string, "{F4D00B}>> Goto Page\n");
    return FlexPlayerDialog(playerid, "PersonalVehAdAllVehicle", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Vehicle List (Page %d/%d)", page, PersonalVehicle:GetTotalPage()), string, "Select", "Back", page
    );
}

FlexDialog:PersonalVehAdAllVehicle(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return PersonalVehicle:AdminPanel(playerid);
    new page = extraid;
    if (IsStringSame(inputtext, ">> Next Page")) return PersonalVehicle:AdminAllVehicles(playerid, page + 1);
    if (IsStringSame(inputtext, ">> Previous Page")) return PersonalVehicle:AdminAllVehicles(playerid, page - 1);
    if (IsStringSame(inputtext, ">> Goto Page")) return FlexPlayerDialog(playerid, "PersonalVehAdGotoPage", DIALOG_STYLE_INPUT, "Go to page",
        sprintf("Enter page betweeen 0 to %d", PersonalVehicle:GetTotalPage()), "Go", "Cancel", page);
    new xid = PersonalVehicle:GetIDByPlate(inputtext);
    if (!PersonalVehicle:IsValidID(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}Couldn't find the vehicle!");
    return PersonalVehicle:VehicleMenu(playerid, xid);
}

FlexDialog:PersonalVehAdGotoPage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new page = extraid;
    if (!response) return PersonalVehicle:AdminAllVehicles(playerid, page);
    new newpage;
    if (sscanf(inputtext, "d", newpage) || newpage < 0 || newpage > PersonalVehicle:GetTotalPage()) newpage = page;
    PersonalVehicle:AdminAllVehicles(playerid, newpage);
    return 1;
}

stock PersonalVehicle:ShowPurchaseMenu(playerid, xid) {
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    new string[1024];
    format(string, sizeof string, "{FFFFFF}---------------------------[Vehicle For Sale]---------------------------\n", string);
    format(string, sizeof string, "%s\n", string);
    format(string, sizeof string, "%s{00D700}This Vehicle Is For Sale!\n", string);
    format(string, sizeof string, "%s\n{0098FF}Vehicle Name:{FFFF00}%s\n", string, PersonalVehicle:GetName(xid));
    format(string, sizeof string, "%s{0098FF}Plate Number:{FFFF00}%s\n", string, PersonalVehicle:GetPlate(xid));
    format(string, sizeof string, "%s{0098FF}Price:{FFFF00}$%s\n", string, FormatCurrency(PersonalVehicle:GetPrice(xid)));
    format(string, sizeof string, "%s\n{FF8000}Do you want to buy this vehicle?{00D700}\n", string);
    format(string, sizeof string, "%s\n{FFFFFF}-------------------------------------------------------------------------", string);
    FlexPlayerDialog(playerid, "PersonalVehDirectPurchase", DIALOG_STYLE_MSGBOX, "Vehicle For Sale", string, "Buy", "Close", xid);
    return 1;
}

FlexDialog:PersonalVehDirectPurchase(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) {
        if (GetPlayerAdminLevel(playerid) < 8) RemovePlayerFromVehicle(playerid);
        return 1;
    }
    new xid = PersonalVehicle:GetID(GetPlayerVehicleID(playerid));
    if (!PersonalVehicle:IsValidID(xid) || PersonalVehicle:IsPurchased(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}vehicle not found");
    if (PersonalVehicle:GetPlayerVehicleCount(playerid) >= PersonalVehicle:GetPlayerVehicleLimit(playerid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}You have reached the limit! You can't buy more vehicle."), RemovePlayerFromVehicle(playerid);
    if (GetPlayerCash(playerid) < PersonalVehicle:GetPrice(xid)) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}You don't have enough money!"), RemovePlayerFromVehicle(playerid);

    new amount = PersonalVehicle:GetPrice(xid);
    vault:PlayerVault(
        playerid, -amount, sprintf("vehicle: %s with plate %s (%d) purchased from sagd",
            GetVehicleName(PersonalVehicle:GetVehicleID(xid)), PersonalVehicle:GetPlate(xid), xid
        ),
        Vault_ID_Government, amount, sprintf("%s: purchased %s with plate %s (%d)",
            GetPlayerNameEx(playerid), GetVehicleName(PersonalVehicle:GetVehicleID(xid)), PersonalVehicle:GetPlate(xid), xid
        )
    );

    PersonalVehicle:Data[xid][xv_AutoReset] = 1;
    PersonalVehicle:Data[xid][xv_Impound] = 0;
    PersonalVehicle:Data[xid][xv_lastUsage] = gettime();
    PersonalVehicle:UpdateOwner(xid, GetPlayerNameEx(playerid));
    DestroyDynamic3DTextLabel(PersonalVehicle:Data[xid][xv_Text]);
    return AlexaMsg(playerid, "{00BD00}[!] {00FF00}You have succesfully bought this vehicle! You can manage your vehicles by using {ECB021}your pocket");
}

hook GlobalOneMinuteInterval() {
    foreach(new xid:xVehicles) {
        PersonalVehicle:SaveID(xid);
        if (PersonalVehicle:IsPurchased(xid) && gettime() > 1621123200) {
            if (gettime() - PersonalVehicle:GetLastUsage(xid) > VEHICLE_RESET_DAY * 86400 && PersonalVehicle:AutoResetState(xid)) {
                if (!IsPlayerInServerByName(PersonalVehicle:GetOwner(xid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PersonalVehicle:GetOwner(xid), sprintf("Vehicle %s with plate %s [%d] has been auto reset!!",
                            PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid),
                        sprintf("Vehicle %s with plate %s [%d] has been auto reset!! Your vehicle has been taken by government due to not driven in long time.",
                            PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Vehicle\n\
                Model: %s\n\
                Plate: %s\n\
                Status: reseted\n\
                Reason: due to not driven in long time\n\
                ```\
                ", PersonalVehicle:GetOwner(xid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)));
                PersonalVehicle:SeizeVehicle(xid);
            }
        }
    }
    return 1;
}

hook GlobalHourInterval() {
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPurchased(xid) && gettime() > 1621123200) {
            new beforeDay = 1;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new vehicleWillResetAt = PersonalVehicle:GetLastUsage(xid) + (VEHICLE_RESET_DAY - beforeDay) * 86400;
            if (vehicleWillResetAt >= mintime && vehicleWillResetAt < maxtime && PersonalVehicle:AutoResetState(xid)) {
                if (!IsPlayerInServerByName(PersonalVehicle:GetOwner(xid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PersonalVehicle:GetOwner(xid), sprintf("Vehicle %s with plate %s [%d] will reset after 24 hours!!",
                            PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid),
                        sprintf("Vehicle %s with plate %s [%d] will reset after 24 hours!! Your vehicle will be taken by government due to not driven in long time.\
                         you can stop this reset by driving your vehicle within 24 hours.", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Vehicle\n\
                Model: %s\n\
                Plate: %s\n\
                Status: will reset within 24 hour.\n\
                Reason: due to not driven in long time\n\
                ```\
                ", PersonalVehicle:GetOwner(xid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)));
            }
        }
    }
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPurchased(xid) && gettime() > 1621123200) {
            new beforeDay = 2;
            new currenttime = gettime();
            new mintime = currenttime;
            new maxtime = currenttime + 60 * 60;
            new vehicleWillResetAt = PersonalVehicle:GetLastUsage(xid) + (VEHICLE_RESET_DAY - beforeDay) * 86400;
            if (vehicleWillResetAt >= mintime && vehicleWillResetAt < maxtime && PersonalVehicle:AutoResetState(xid)) {
                if (!IsPlayerInServerByName(PersonalVehicle:GetOwner(xid))) {
                    Email:Send(ALERT_TYPE_PROPERTY_EXPIRE, PersonalVehicle:GetOwner(xid), sprintf("Vehicle %s with plate %s [%d] will reset after 48 hours!!",
                            PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid),
                        sprintf("Vehicle %s with plate %s [%d] will reset after 48 hours!! Your vehicle will be taken by government due to not driven in long time.\
                         you can stop this reset by driving your vehicle within 48 hours.", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
                }
                Discord:SendNotification(sprintf("\
                **Property Auto Reset Alert**\n\
                ```\n\
                Owner: %s\n\
                Type: Vehicle\n\
                Model: %s\n\
                Plate: %s\n\
                Status: will reset within 48 hour.\n\
                Reason: due to not driven in long time\n\
                ```\
                ", PersonalVehicle:GetOwner(xid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)));
            }
        }
    }
    return 1;
}

hook OnGameModeInit() {
    new query[1024];
    strcat(query, "CREATE TABLE IF NOT EXISTS xVehicle (\
	  `ID` int(11),\
	  Owner varchar(48) default '',\
	  `Price` int(11) default '0',\
	  `neon` int(11) default '0',\
	  `fuel` float default '10',\
	  `health` float default '1000',\
	  `X` float default '0',\
	  `Y` float default '0',\
	  `Z` float default '0',\
	  `A` float default '0',\
	  `FastPark` int(2) default '0',\
	  `Model` int(5) default '0',\
	  `Color1` int(5) default '0',\
	  `Color2` int(5) default '0',\
	  `Plate` varchar(8),\
	  `InGarage` int(2) default '0',\
	  `PJ` int(5) default '-1',");

    strcat(query, "`Park1` int(8) default '0',\
	  `Park2` int(8) default '0',\
	  `Park3` int(8) default '0',\
	  `Park4` int(8) default '0',\
	  `Park5` int(8) default '0',\
	  `Park6` int(8) default '0',\
	  `Park7` int(8) default '0',\
	  `Park8` int(8) default '0',");


    strcat(query, "`Park9` int(8) default '0',\
	  `Park10` int(8) default '0',\
	  `Park11` int(8) default '0',\
	  `Park12` int(8) default '0',\
	  `Park13` int(8) default '0',\
	  `Park14` int(8) default '0',\
	    PRIMARY KEY  (`ID`),\
		UNIQUE KEY `ID_2` (`ID`),\
		KEY `ID` (`ID`)\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_tquery(Database, query);

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS xVehicleKeys (\
	  `VehicleID` int(11) NOT NULL,\
	  Isim varchar(24) NOT NULL\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_tquery(Database, "select * from xVehicle", "LoadxVehicles");
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPVarInt(playerid, "xv_bid_id", INVALID_PLAYER_ID);
    SetPVarInt(playerid, "xv_bid_sender", INVALID_PLAYER_ID);
    dealership_cp[playerid] = -1;
    ImpoundDriveTest[playerid] = 0;
    return 1;
}

new Float:KileMeterCounter[MAX_VEHICLES][3];
hook OnPlayerUpdate(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    new Float:oldX = KileMeterCounter[vehicleid][0], Float:oldY = KileMeterCounter[vehicleid][1], Float:oldZ = KileMeterCounter[vehicleid][2];
    new Float:newX, Float:newY, Float:newZ;
    GetVehiclePos(vehicleid, newX, newY, newZ);

    new Float:dX = newX - oldX;
    new Float:dY = newY - oldY;
    new Float:dZ = newZ - oldZ;

    new Float:kmCount = floatsqroot((dX * dX) + (dY * dY) + (dZ * dZ)) * 0.001;
    if (kmCount > 0 && kmCount < 20) PersonalVehicle:UpdateKilometers(xid, kmCount);

    KileMeterCounter[vehicleid][0] = newX;
    KileMeterCounter[vehicleid][1] = newY;
    KileMeterCounter[vehicleid][2] = newZ;
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    PersonalVehicle:LoadKeysFor(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (GetPVarInt(playerid, "xv_bid_sender") != INVALID_PLAYER_ID) {
        new sender = GetPVarInt(playerid, "xv_bid_sender");
        KillTimer(offerTimer[playerid]);
        SetPVarInt(sender, "xv_bid_id", INVALID_PLAYER_ID);
        SendClientMessageEx(sender, -1, "{FF0000}[!] {DCDC22}Your vehicle offer has cancelled because of the player that you offered has disconnected.");
    }

    if (GetPVarInt(playerid, "xv_bid_id") != INVALID_PLAYER_ID) {
        new alan = GetPVarInt(playerid, "xv_bid_id");
        SetPVarInt(alan, "xv_bid_sender", INVALID_PLAYER_ID);
        DeletePVar(alan, "xv_bid_xid");
        DeletePVar(alan, "xv_bid_price");
        KillTimer(offerTimer[alan]);
        SendClientMessageEx(alan, -1, "{FF0000}[!] {DCDC22}The offer has cancelled because of the player that make the offer has disconnected.");
    }

    // despawn vehicles when player leave server
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPlayerOwner(playerid, xid) && !PersonalVehicle:IsInGarage(xid)) {
            if (IsValidVehicle(PersonalVehicle:Data[xid][xv_Veh])) {
                PersonalVehicle:SaveID(xid);
            }
        }
    }

    // where is my car cp destory
    if (IsValidDynamicCP(dealership_cp[playerid])) {
        DestroyDynamicCP(dealership_cp[playerid]);
        dealership_cp[playerid] = -1;
    }
    return 1;
}

stock GetPackerInRange(playerid, Float:range = 20.0) {
    foreach(new vehicleid:Vehicle) {
        if (GetVehicleModel(vehicleid) != 443) continue;
        if (IsPlayerInRangeOfVehicle(playerid, vehicleid, range)) {
            return vehicleid;
        }
    }
    return -1;
}

hook OnScreenTimerFinished(playerid, success) {
    if (ImpoundDriveTest[playerid]) {
        ImpoundDriveTest[playerid] = 0;
        RemovePlayerFromVehicle(playerid);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (newstate == PLAYER_STATE_ONFOOT) {
        if (ImpoundDriveTest[playerid]) {
            ImpoundDriveTest[playerid] = 0;
            StopScreenTimer(playerid, 0);
        }
    }

    if (newstate == PLAYER_STATE_PASSENGER) {
        new xid = PersonalVehicle:GetID(GetPlayerVehicleID(playerid));
        if (!PersonalVehicle:IsValidID(xid) || PersonalVehicle:IsInGarage(xid)) return 1;

        if (PersonalVehicle:Data[xid][xv_health] > 200.00) SetVehicleHealthEx(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_health]);
        else SetVehicleHealthEx(PersonalVehicle:Data[xid][xv_Veh], 250.00);
    }

    if (newstate == PLAYER_STATE_DRIVER) {
        new xid = PersonalVehicle:GetID(GetPlayerVehicleID(playerid));
        if (!PersonalVehicle:IsValidID(xid) || PersonalVehicle:IsInGarage(xid)) return 1;

        if (PersonalVehicle:Data[xid][xv_health] > 200.00) SetVehicleHealthEx(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_health]);
        else SetVehicleHealthEx(PersonalVehicle:Data[xid][xv_Veh], 250.00);

        if (PersonalVehicle:IsImpounded(xid)) {
            new allowedFaction[] = { 0, 1, 2 };
            if (IsArrayContainNumber(allowedFaction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid) && IsTimePassedForPlayer(playerid, "ImpoundVehicleDrive", 60)) {
                new vehicleid = GetPackerInRange(playerid);
                if (IsValidVehicle(vehicleid)) {
                    ImpoundDriveTest[playerid] = 1;
                    AlexaMsg(playerid, sprintf("You have 15 seconds to park this vehicle in the packer"));
                    StartScreenTimer(playerid, 20);
                    return 1;
                }
            }
            if (GetPlayerAdminLevel(playerid) < 1) RemovePlayerFromVehicle(playerid);
            AlexaMsg(playerid, "this vehicle is impounded by law enforcement, please contact 911 for more info");
            return 1;
        }

        if (!PersonalVehicle:IsPurchased(xid)) {
            PersonalVehicle:ShowPurchaseMenu(playerid, xid);
            return 1;
        }

        if (!PersonalVehicle:IsPlayerOwner(playerid, xid) && !PersonalVehicle:IsHaveKey(playerid, xid)) {
            AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}You don't have this car's keys!");
            if (GetPlayerAdminLevel(playerid) < 8) RemovePlayerFromVehicle(playerid);
            return 1;
        } else {
            if (PersonalVehicle:IsPlayerOwner(playerid, xid)) PersonalVehicle:UpdateLastUsage(xid);
            if (IsTimePassedForPlayer(playerid, "warnpocketpvehcile", 60)) AlexaMsg(playerid, "{00FF00}[!] {DCDC22}Use {ECB021}your pocket {DCDC22}for the vehicle menu.");
            return 1;
        }
    }
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) PersonalVehicle:SaveID(xid);
    return 1;
}

stock PersonalVehicle:RemoveMod(xid) {
    new vehicleid = PersonalVehicle:GetVehicleID(xid);
    foreach(new playerid:Player) {
        if (IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == vehicleid) RemovePlayerFromVehicle(playerid);
    }
    PersonalVehicle:Data[xid][xv_remove_mod] = 444;
    PersonalVehicle:SetNeon(vehicleid, 0);
    SetVehicleToRespawn(vehicleid);
    SetTimerEx("RemoveModSave", 3000, false, "d", xid);
    return 1;
}

forward RemoveModSave(xid);
public RemoveModSave(xid) {
    PersonalVehicle:SaveMod(xid);
    PersonalVehicle:Data[xid][xv_remove_mod] = 0;
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        DestroyDynamic3DTextLabel(PersonalVehicle:Data[xid][xv_Text]);
        DestroyVehicle(PersonalVehicle:GetVehicleID(xid));
        PersonalVehicle:Data[xid][xv_Veh] = AddStaticVehicle(PersonalVehicle:Data[xid][xv_ModelID], PersonalVehicle:Data[xid][xv_Pos][0], PersonalVehicle:Data[xid][xv_Pos][1], PersonalVehicle:Data[xid][xv_Pos][2], PersonalVehicle:Data[xid][xv_Pos][3], PersonalVehicle:Data[xid][xv_Color][0], PersonalVehicle:Data[xid][xv_Color][1]);
        SetVehicleNumberPlate(PersonalVehicle:GetVehicleID(xid), PersonalVehicle:Data[xid][xv_Plate]);
        if (PersonalVehicle:Data[xid][xv_remove_mod] != 444) PersonalVehicle:LoadMods(xid);
        CallRemoteFunction("OnMyVehicleSpawn", "d", xid);
        if (!PersonalVehicle:IsPurchased(xid)) {
            new string[512];
            format(string, sizeof string,
                "{00FF00}This Vehicle Is For Sale!\n{FFA500}Vehicle Name: {FFFFFF}%s\n{FFA500}Plate Number: {FFFFFF}%s\n{FFA500}Price:{00FF00}$%s",
                PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), FormatCurrency(PersonalVehicle:GetPrice(xid))
            );
            PersonalVehicle:Data[xid][xv_Text] = CreateDynamic3DTextLabel(string, 0x008080FF, 0.0, 0.0, 0.0, 10.0, INVALID_PLAYER_ID, PersonalVehicle:GetVehicleID(xid));
        }
    }
    return 1;
}

forward OnMyVehicleSpawn(xid);
public OnMyVehicleSpawn(xid) {
    SetVehicleFuelEx(PersonalVehicle:GetVehicleID(xid), PersonalVehicle:GetFuel(xid));
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    PersonalVehicle:Data[xid][xv_health] = 275.0;
    return 1;
}

hook OnVehicleRespray(playerid, vehicleid, color1, color2) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        PersonalVehicle:Data[xid][xv_Color][0] = color1;
        PersonalVehicle:Data[xid][xv_Color][1] = color2;
    }
    return 1;
}

hook OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    PersonalVehicle:Data[xid][xv_Paintjob] = paintjobid;
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (checkpointid != dealership_cp[playerid]) return 1;
    if (IsValidDynamicCP(dealership_cp[playerid])) {
        DestroyDynamicCP(dealership_cp[playerid]);
        dealership_cp[playerid] = -1;
    }
    return 1;
}

forward LoadxVehicles();
public LoadxVehicles() {
    new rows = cache_num_rows();
    new xid, loaded;
    if (rows) {
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", xid);
            cache_get_value_name(loaded, "Owner", PersonalVehicle:Data[xid][xv_Owner], MAX_PLAYER_NAME);
            cache_get_value_name_int(loaded, "Price", PersonalVehicle:Data[xid][xv_Price]);
            cache_get_value_name_int(loaded, "neon", PersonalVehicle:Data[xid][xv_neon]);
            cache_get_value_name_float(loaded, "fuel", PersonalVehicle:Data[xid][xv_fuel]);
            cache_get_value_name_float(loaded, "health", PersonalVehicle:Data[xid][xv_health]);
            cache_get_value_name_float(loaded, "X", PersonalVehicle:Data[xid][xv_Pos][0]);
            cache_get_value_name_float(loaded, "Y", PersonalVehicle:Data[xid][xv_Pos][1]);
            cache_get_value_name_float(loaded, "Z", PersonalVehicle:Data[xid][xv_Pos][2]);
            cache_get_value_name_float(loaded, "A", PersonalVehicle:Data[xid][xv_Pos][3]);
            cache_get_value_name_int(loaded, "Model", PersonalVehicle:Data[xid][xv_ModelID]);
            cache_get_value_name_int(loaded, "Color1", PersonalVehicle:Data[xid][xv_Color][0]);
            cache_get_value_name_int(loaded, "Color2", PersonalVehicle:Data[xid][xv_Color][1]);
            cache_get_value_name(loaded, "Plate", PersonalVehicle:Data[xid][xv_Plate], 8);
            cache_get_value_name_int(loaded, "InGarage", PersonalVehicle:Data[xid][xv_InGarage]);
            cache_get_value_name_int(loaded, "impound", PersonalVehicle:Data[xid][xv_Impound]);
            cache_get_value_name(loaded, "impoundBy", PersonalVehicle:Data[xid][xv_ImpoundBy], 50);
            cache_get_value_name(loaded, "impoundReason", PersonalVehicle:Data[xid][xv_ImpoundReason], 100);
            cache_get_value_name_int(loaded, "lastUsage", PersonalVehicle:Data[xid][xv_lastUsage]);
            cache_get_value_name_float(loaded, "kilometer", PersonalVehicle:Data[xid][xv_KiloMeters]);
            cache_get_value_name_int(loaded, "createdAt", PersonalVehicle:Data[xid][xv_CreatedAt]);
            cache_get_value_name_int(loaded, "xenon", PersonalVehicle:Data[xid][xv_Xenon]);
            cache_get_value_name_int(loaded, "xenonExpireAt", PersonalVehicle:Data[xid][xv_XenonExpireAt]);
            cache_get_value_name_int(loaded, "halloweenExpireAt", PersonalVehicle:Data[xid][xv_HalloweenExpireAt]);
            cache_get_value_name_int(loaded, "autoReset", PersonalVehicle:Data[xid][xv_AutoReset]);
            cache_get_value_name_int(loaded, "PJ", PersonalVehicle:Data[xid][xv_Paintjob]);
            cache_get_value_name_int(loaded, "Park1", PersonalVehicle:Data[xid][xv_Park][0]);
            cache_get_value_name_int(loaded, "Park2", PersonalVehicle:Data[xid][xv_Park][1]);
            cache_get_value_name_int(loaded, "Park3", PersonalVehicle:Data[xid][xv_Park][2]);
            cache_get_value_name_int(loaded, "Park4", PersonalVehicle:Data[xid][xv_Park][3]);
            cache_get_value_name_int(loaded, "Park5", PersonalVehicle:Data[xid][xv_Park][4]);
            cache_get_value_name_int(loaded, "Park6", PersonalVehicle:Data[xid][xv_Park][5]);
            cache_get_value_name_int(loaded, "Park7", PersonalVehicle:Data[xid][xv_Park][6]);
            cache_get_value_name_int(loaded, "Park8", PersonalVehicle:Data[xid][xv_Park][7]);
            cache_get_value_name_int(loaded, "Park9", PersonalVehicle:Data[xid][xv_Park][8]);
            cache_get_value_name_int(loaded, "Park10", PersonalVehicle:Data[xid][xv_Park][9]);
            cache_get_value_name_int(loaded, "Park11", PersonalVehicle:Data[xid][xv_Park][10]);
            cache_get_value_name_int(loaded, "Park12", PersonalVehicle:Data[xid][xv_Park][11]);
            cache_get_value_name_int(loaded, "Park13", PersonalVehicle:Data[xid][xv_Park][12]);
            cache_get_value_name_int(loaded, "Park14", PersonalVehicle:Data[xid][xv_Park][13]);
            Iter_Add(xVehicles, xid);
            loaded++;

            // spawn vehicle
            if (!PersonalVehicle:IsInGarage(xid)) {
                PersonalVehicle:Data[xid][xv_Veh] = AddStaticVehicle(PersonalVehicle:Data[xid][xv_ModelID], PersonalVehicle:Data[xid][xv_Pos][0], PersonalVehicle:Data[xid][xv_Pos][1], PersonalVehicle:Data[xid][xv_Pos][2], PersonalVehicle:Data[xid][xv_Pos][3], PersonalVehicle:Data[xid][xv_Color][0], PersonalVehicle:Data[xid][xv_Color][1]);
                SetVehicleNumberPlate(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Plate]);
                SetVehicleToRespawn(PersonalVehicle:Data[xid][xv_Veh]);
            }

        }
    }
    printf("  [xVehicle] %d vehicle loaded.", loaded);
    return 1;
}

forward BidBitir(sender, alan);
public BidBitir(sender, alan) {
    SetPVarInt(alan, "xv_bid_sender", INVALID_PLAYER_ID);
    DeletePVar(alan, "xv_bid_xid");
    DeletePVar(alan, "xv_bid_price");
    if (IsPlayerConnected(sender)) SetPVarInt(sender, "xv_bid_id", INVALID_PLAYER_ID), SendClientMessageEx(sender, -1, "{FF0000}[!] {DCDC22}The vehicle sale offer has cancelled because of the player didn't respond.");
    return 1;
}

forward LoadCarKeys(playerid);
public LoadCarKeys(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    new rows = cache_num_rows();
    if (rows) {
        new loaded, vehid;
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "VehicleID", vehid);
            Iter_Add(xVehicleKeys < playerid > , vehid);
            loaded++;
        }
    }

    return 1;
}

forward OnPersonalVehicleSold(xid);
public OnPersonalVehicleSold(xid) {
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page == 1) UCP:AddCommand(playerid, "My Cars");
    new allowedFaction[] = { 0, 1, 2 };
    if (Faction:IsPlayerSigned(playerid) && IsArrayContainNumber(allowedFaction, Faction:GetPlayerFID(playerid))) {
        new vehicleid = GetPlayerNearestVehicle(playerid);
        new xid = PersonalVehicle:GetID(vehicleid);
        if (PersonalVehicle:IsValidID(xid) && PersonalVehicle:IsPurchased(xid)) {
            if (!PersonalVehicle:IsImpounded(xid)) UCP:AddCommand(playerid, ">> Impound Vehicle");
            else {
                UCP:AddCommand(playerid, ">> Release Impounded Vehicle");
                UCP:AddCommand(playerid, ">> Park Impounded Vehicle");
            }
        }
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("My Cars", inputtext)) {
        PersonalVehicle:Menu(playerid);
        return ~1;
    }

    new vehicleid = GetPlayerNearestVehicle(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (PersonalVehicle:IsValidID(xid)) {
        if (IsStringSame(">> Impound Vehicle", inputtext)) {
            if (PersonalVehicle:IsImpounded(xid)) AlexaMsg(playerid, "vehicle already impounded");
            else PersonalVehicle:XvImpoundReason(playerid, xid);
            return ~1;
        }
        if (IsStringSame(">> Release Impounded Vehicle", inputtext)) {
            if (!PersonalVehicle:IsImpounded(xid)) AlexaMsg(playerid, "vehicle is not impounded");
            else {
                PersonalVehicle:SetVehicleImpoundState(vehicleid, 0);
                AlexaMsg(playerid, "vehicle released");
            }
            return ~1;
        }
    }
    return 1;
}

stock PersonalVehicle:XvImpoundReason(playerid, xid) {
    return FlexPlayerDialog(
        playerid, "XvImpoundReason", DIALOG_STYLE_INPUT, sprintf("Impound %s", PersonalVehicle:GetPlate(xid)),
        "Enter impound reason", "Impound", "Close", xid
    );
}

FlexDialog:XvImpoundReason(playerid, response, listitem, const inputtext[], xid, const payload[]) {
    if (!response) return 1;
    new impoundReason[100];
    if (sscanf(inputtext, "s[100]", impoundReason)) return PersonalVehicle:XvImpoundReason(playerid, xid);
    if (!IsPlayerInServerByName(PersonalVehicle:GetOwner(xid))) {
        Email:Send(
            ALERT_TYPE_PROPERTY_EXPIRE,
            PersonalVehicle:GetOwner(xid),
            sprintf(
                "Vehicle %s with plate %s [%d] has impounded by %s (%s)!!",
                PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid,
                GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid))
            ),
            sprintf(
                "Vehicle %s with plate %s [%d] has impounded by %s (%s)!! \
                -n-Reason: %s\
                you can raise a case with justice department if this was not acknowledged by you before.",
                PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid,
                GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid)),
                impoundReason
            )
        );
    }
    Discord:SendNotification(sprintf("\
        **Property Impounded Alert**\n\
        ```\n\
        Owner: %s\n\
        Type: Vehicle\n\
        Model: %s\n\
        Plate: %s\n\
        Status: impounded\n\
        Reason: impound by %s (%s) cuase of %s\n\
        ```", PersonalVehicle:GetOwner(xid), PersonalVehicle:GetName(xid),
        PersonalVehicle:GetPlate(xid),
        GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid)), impoundReason
    ));

    format(PersonalVehicle:Data[xid][xv_ImpoundBy], 50, "%s", GetPlayerNameEx(playerid));
    format(PersonalVehicle:Data[xid][xv_ImpoundReason], 100, "%s", impoundReason);
    PersonalVehicle:SetVehicleImpoundState(PersonalVehicle:GetVehicleID(xid), gettime());
    AlexaMsg(playerid, "vehicle impounded");
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Dealership System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Dealership System", inputtext)) PersonalVehicle:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "dealership system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    PersonalVehicle:AdminPanel(playerid);
    return ~1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE xVehicle SET Owner = \"%s\" where Owner = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE xVehicleKeys SET Isim = \"%s\" where Isim = \"%s\"", NewName, OldName));
    foreach(new xid:xVehicles) {
        if (IsStringSame(PersonalVehicle:GetOwner(xid), OldName)) PersonalVehicle:UpdateOwner(xid, NewName);
    }
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("delete from xVehicle where Owner = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("delete from xVehicleKeys where Isim = \"%s\"", AccountName));
    return 1;
}

BitCoin:OnInit(playerid, page) {
    if (page != 0 || !IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid))) BitCoin:AddCommand(playerid, "Vehicle > Number Plate (15 BTC)");
    return 1;
}

BitCoin:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page != 0) return 1;
    if (IsStringSame(inputtext, "Vehicle > Number Plate (15 BTC)")) {
        PersonalVehicle:CustomNumberPlate(playerid);
        return ~1;
    }
    return 1;
}

stock PersonalVehicle:CustomNumberPlate(playerid) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid)) return 1;
    new string[512];
    strcat(string, sprintf("Vehicle: %s\n", PersonalVehicle:GetName(xid)));
    strcat(string, sprintf("Plate: %s\n", PersonalVehicle:GetPlate(xid)));
    strcat(string, "Cost for custom plate: 15 BTC\n\n");
    strcat(string, "Enter text to write on number plate, min length is 3 and maximum length is 8\n");
    return FlexPlayerDialog(
        playerid, "CustomNumberPlate", DIALOG_STYLE_INPUT, "Custom Vehicle Plate", string, "Update", "Cancel"
    );
}

FlexDialog:CustomNumberPlate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!PersonalVehicle:IsValidID(xid) || !response) return 1;
    new newPlate[8];
    if (sscanf(inputtext, "s[8]", newPlate) || strlen(newPlate) < 3 || BitCoin:Get(playerid) < 15) return PersonalVehicle:CustomNumberPlate(playerid);
    if (PersonalVehicle:IsPlateExist(newPlate)) {
        AlexaMsg(playerid, "plate already registered, try another number");
        return PersonalVehicle:CustomNumberPlate(playerid);
    }
    BitCoin:GiveOrTake(playerid, -15, sprintf("updated vehicle %s number plate from %s to %s", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), newPlate));
    PersonalVehicle:RemoveAllPlayerFrom(xid);
    format(PersonalVehicle:Data[xid][xv_Plate], 8, "%s", newPlate);
    PersonalVehicle:SaveID(xid);
    SetVehicleNumberPlate(PersonalVehicle:Data[xid][xv_Veh], PersonalVehicle:Data[xid][xv_Plate]);
    SetVehicleToRespawn(PersonalVehicle:Data[xid][xv_Veh]);
    AlexaMsg(playerid, "custom number plate installed");
    return 1;
}