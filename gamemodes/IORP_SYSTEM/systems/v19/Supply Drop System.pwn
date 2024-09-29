#define     MAX_DROPS       (50)
#define     DIST            (300.0)

// Config
#define		PLANE_TIME		(7)		// how many seconds does a plane need before flying (Default:7)
#define     REQ_COOLDOWN    (5)     // how many minutes does someone need to wait for requesting a supply drop again (Default:3)
#define     DROP_LIFE       (5)     // life time of a supply drop, in minutes (Default:5)
#define     AMMO_PRICE      (13350)	// price of ammo request (Default:750)
#define     HEALTH_PRICE    (3000)   // price of health kit request (Default:500)
#define     ARMOR_PRICE     (5000)   // price of body armor request (Default:450)
#define     AMMO_AMOUNT     (150)   // how much ammo will be given with a weapon/ammo drop (Default:150)

enum _:E_DROPTYPE {
    DROP_TYPE_WEAPON,
    DROP_TYPE_AMMO,
    DROP_TYPE_HEALTH,
    DROP_TYPE_ARMOR
}

enum E_WEPDATA {
    weaponID,
    weaponPrice
}

enum E_DROP {
    // objects
    planeObj,
    boxObj,
    paraObj,
    // pickup (created after drop is done)
    dropPickup,
    // label
    Text3D:dropLabel,
    // drop data
    dropType,
    dropData,
    // timer
    dropTimer,
    // other
    requestedBy
}

new SupplyData[MAX_DROPS][E_DROP],
    Iterator:SupplyDrops < MAX_DROPS > ;

new AvailableWeapons[][E_WEPDATA] = {
    // weapon id, price
    // you can get weapon ids from here:https://wiki.sa-mp.com/wiki/Weapons
    { WEAPON_SHOTGUN, 300 },
    { WEAPON_SAWEDOFF, 130 },
    { WEAPON_AK47, 500 }
};

stock ReturnDropPickupModel(id) {
    new model = 18631;

    switch (SupplyData[id][dropType]) {
        case DROP_TYPE_WEAPON:
            model = GetWeaponModel(SupplyData[id][dropData]);
        case DROP_TYPE_AMMO:
            model = 19832;
        case DROP_TYPE_HEALTH:
            model = 11738;
        case DROP_TYPE_ARMOR:
            model = 1242;
    }

    return model;
}

hook OnGameModeInit() {
    for (new i; i < MAX_DROPS; i++) {
        SupplyData[i][planeObj] = SupplyData[i][boxObj] = SupplyData[i][paraObj] = SupplyData[i][dropPickup] = SupplyData[i][dropTimer] = SupplyData[i][requestedBy] = -1;
        SupplyData[i][dropLabel] = Text3D:  - 1;
    }
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:SupplyDrops) {
        if (IsValidDynamicObject(SupplyData[i][planeObj])) DestroyDynamicObjectEx(SupplyData[i][planeObj]);
        if (IsValidDynamicObject(SupplyData[i][boxObj])) DestroyDynamicObjectEx(SupplyData[i][boxObj]);
        if (IsValidDynamicObject(SupplyData[i][paraObj])) DestroyDynamicObjectEx(SupplyData[i][paraObj]);

        if (SupplyData[i][dropPickup] != -1) DestroyDynamicPickup(SupplyData[i][dropPickup]);
        if (SupplyData[i][dropTimer] != -1) DeletePreciseTimer(SupplyData[i][dropTimer]);
        if (SupplyData[i][dropLabel] != Text3D:  - 1) DestroyDynamic3DTextLabel(SupplyData[i][dropLabel]);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    foreach(new i:SupplyDrops) if (SupplyData[i][requestedBy] == playerid) SupplyData[i][requestedBy] = -1;
    return 1;
}

hook OnDynObjectMoved(objectid) {
    switch (GetDynamicObjectModel(objectid)) {
        case 1681 :  {
            // it's a plane, validate it & remove
            foreach(new i:SupplyDrops) {
                if (SupplyData[i][planeObj] == objectid) {
                    DestroyDynamicObjectEx(SupplyData[i][planeObj]);
                    SupplyData[i][planeObj] = -1;
                    break;
                }
            }
        }

        case 2975 :  {
            // it's a supply drop, validate it, create pickup then remove
            foreach(new i:SupplyDrops) {
                if (SupplyData[i][boxObj] == objectid) {
                    new Float:x, Float:y, Float:z, string[48];
                    switch (SupplyData[i][dropType]) {
                        case DROP_TYPE_WEAPON:  {
                            new weap_name[24];
                            GetWeaponName(SupplyData[i][dropData], weap_name, sizeof(weap_name));
                            format(string, sizeof(string), "Supply Drop\n\n{FFFFFF}%s", weap_name);
                        }

                        case DROP_TYPE_AMMO:
                            format(string, sizeof(string), "Supply Drop\n\n{FFFFFF}Ammo");
                        case DROP_TYPE_HEALTH:
                            format(string, sizeof(string), "Supply Drop\n\n{FFFFFF}Health");
                        case DROP_TYPE_ARMOR:
                            format(string, sizeof(string), "Supply Drop\n\n{FFFFFF}Body Armor");
                    }

                    GetDynamicObjectPos(objectid, x, y, z);
                    SupplyData[i][dropPickup] = CreateDynamicPickup(ReturnDropPickupModel(i), 1, x, y, z + 0.85);
                    SupplyData[i][dropLabel] = CreateDynamic3DTextLabel(string, 0xF1C40FFF, x, y, z + 1.65, 10.0);

                    DestroyDynamicObjectEx(SupplyData[i][paraObj]);
                    DestroyDynamicObjectEx(SupplyData[i][boxObj]);
                    SupplyData[i][boxObj] = SupplyData[i][paraObj] = -1;
                    SupplyData[i][dropTimer] = SetPreciseTimer("RemoveDrop", DROP_LIFE * 60000, false, "i", i);

                    if (IsPlayerConnected(SupplyData[i][requestedBy])) SendClientMessageEx(SupplyData[i][requestedBy], 0x3498DBFF, "[SUPPLY DROP]: {FFFFFF}Drop complete.");
                    break;
                }
            }
        }
    }

    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    foreach(new i:SupplyDrops) {
        if (pickupid == SupplyData[i][dropPickup]) {
            switch (SupplyData[i][dropType]) {
                case DROP_TYPE_WEAPON:
                    GivePlayerWeaponEx(playerid, SupplyData[i][dropData], AMMO_AMOUNT);

                case DROP_TYPE_AMMO:  {
                    new weapon, ammo;
                    for (new x = 2; x <= 7; x++) {
                        GetPlayerWeaponData(playerid, x, weapon, ammo);
                        SetPlayerAmmo(playerid, weapon, ammo + AMMO_AMOUNT);
                    }
                }

                case DROP_TYPE_HEALTH:
                    SetPlayerHealthEx(playerid, 100.0);
                case DROP_TYPE_ARMOR:
                    SetPlayerArmourEx(playerid, 100.0);
            }

            DestroyDynamicPickup(SupplyData[i][dropPickup]);
            DestroyDynamic3DTextLabel(SupplyData[i][dropLabel]);
            DeletePreciseTimer(SupplyData[i][dropTimer]);

            SupplyData[i][dropPickup] = SupplyData[i][requestedBy] = SupplyData[i][dropTimer] = -1;
            SupplyData[i][dropLabel] = Text3D:  - 1;

            Iter_Remove(SupplyDrops, i);
            break;
        }
    }

    return 1;
}

forward FlyPlane(id, Float:x, Float:y, Float:z, angle);
public FlyPlane(id, Float:x, Float:y, Float:z, angle) {
    SupplyData[id][planeObj] = CreateDynamicObject(1681, x + (DIST * -floatsin(-angle, degrees)), y + (DIST * -floatcos(-angle, degrees)), z + 75.0, 0.0, 0.0, angle);
    new time = MoveDynamicObject(SupplyData[id][planeObj], x + (DIST * floatsin(-angle, degrees)), y + (DIST * floatcos(-angle, degrees)), z + 75.0, 60.0);

    SupplyData[id][dropTimer] = SetPreciseTimer("MakeDrop", floatround(time / 2.5), false, "ifff", id, x, y, z);

    if (IsPlayerConnected(SupplyData[id][requestedBy])) SendClientMessageEx(SupplyData[id][requestedBy], 0x3498DBFF, "[PILOT]: {FFFFFF}I'm getting close.");
    return 1;
}

forward MakeDrop(id, Float:x, Float:y, Float:z);
public MakeDrop(id, Float:x, Float:y, Float:z) {
    new Float:plx, Float:ply, Float:plz;
    GetDynamicObjectPos(SupplyData[id][planeObj], plx, ply, plz);

    SupplyData[id][boxObj] = CreateDynamicObject(2975, plx, ply, plz - 15.0, 0.0, 0.0, 0.0);
    SupplyData[id][paraObj] = CreateDynamicObject(18849, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    SetDynamicObjectMaterial(SupplyData[id][paraObj], 2, 19478, "signsurf", "sign", 0xFFFFFFFF);
    AttachDynamicObjectToObject(SupplyData[id][paraObj], SupplyData[id][boxObj], 0.0, -0.05, 7.5, 0.0, 0.0, 0.0);
    MoveDynamicObject(SupplyData[id][boxObj], x, y, z, 8.0);

    if (IsPlayerConnected(SupplyData[id][requestedBy])) SendClientMessageEx(SupplyData[id][requestedBy], 0x3498DBFF, "[PILOT]: {FFFFFF}Supplies dropped.");
    return 1;
}

forward RemoveDrop(id);
public RemoveDrop(id) {
    DestroyDynamicPickup(SupplyData[id][dropPickup]);
    DestroyDynamic3DTextLabel(SupplyData[id][dropLabel]);

    SupplyData[id][dropPickup] = SupplyData[id][requestedBy] = SupplyData[id][dropTimer] = -1;
    SupplyData[id][dropLabel] = Text3D:  - 1;

    Iter_Remove(SupplyDrops, id);
    return 1;
}

stock DropCommand(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't use this command on foot.");
    new cooldown = GetPVarInt(playerid, "supply_Cooldown");
    if (cooldown > gettime()) {
        new string[72];
        format(string, sizeof(string), "[Error]: {FFFFFF}Please wait %s more to request a supply drop again.", ConvertToMinutes(cooldown - gettime()));
        return SendClientMessageEx(playerid, -1, string);
    }
    ShowDropMenu(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && IsPlayerInAnyVehicle(playerid) && Faction:IsPlayerSigned(playerid)) {
        new allow_vehicle[] = { 497, 523, 596, 597, 598, 599 };
        if (IsArrayContainNumber(allow_vehicle, GetVehicleModel(GetPlayerVehicleID(playerid)))) UCP:AddCommand(playerid, "Call Air Drop");
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Call Air Drop", inputtext)) DropCommand(playerid);
    return 1;
}

stock ShowDropMenu(playerid) {
    new string[1024];
    strcat(string, "Request Weapons\t\n");
    strcat(string, sprintf("Request Ammo\t{2ECC71}$%s\n", FormatCurrency(AMMO_PRICE)));
    strcat(string, sprintf("Request Health Kit\t{2ECC71}$%s\n", FormatCurrency(HEALTH_PRICE)));
    strcat(string, sprintf("Request Body Armor\t{2ECC71}$%s\n", FormatCurrency(ARMOR_PRICE)));
    return FlexPlayerDialog(playerid, "ShowDropMenu", DIALOG_STYLE_TABLIST, "Supply Drop", string, "Request", "Close");
}

FlexDialog:ShowDropMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    SetPVarInt(playerid, "supply_ReqType", listitem);
    if (listitem == 0) {
        MenuSupplyDropWeapons(playerid);
    } else {
        new price;
        switch (listitem) {
            case DROP_TYPE_AMMO:
                price = AMMO_PRICE;
            case DROP_TYPE_HEALTH:
                price = HEALTH_PRICE;
            case DROP_TYPE_ARMOR:
                price = ARMOR_PRICE;
        }
        if (price > GetPlayerCash(playerid)) {
            SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't afford this request.");
            return ShowDropMenu(playerid);
        }
        SetPVarInt(playerid, "supply_Price", price);
        ShowConfirmDialog(playerid);
    }
    return 1;
}

stock MenuSupplyDropWeapons(playerid) {
    new string[512], wname[24];
    format(string, sizeof(string), "Weapon\tPrice\n");

    for (new i; i < sizeof(AvailableWeapons); i++) {
        GetWeaponName(AvailableWeapons[i][weaponID], wname, sizeof(wname));
        format(string, sizeof(string), "%s%s\t{2ECC71}%s\n", string, wname, FormatCurrencyEx(AvailableWeapons[i][weaponPrice]));
    }
    return FlexPlayerDialog(playerid, "MenuSupplyDropWeapons", DIALOG_STYLE_TABLIST_HEADERS, "Supply Drop {FFFFFF}Weapons", string, "Request", "Back");
}

FlexDialog:MenuSupplyDropWeapons(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (!response) return ShowDropMenu(playerid);
    new price = AvailableWeapons[listitem][weaponPrice];
    if (price > GetPlayerCash(playerid)) {
        SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't afford this weapon.");
        return MenuSupplyDropWeapons(playerid);
    }
    SetPVarInt(playerid, "supply_WepIndex", listitem);
    SetPVarInt(playerid, "supply_Price", price);
    ShowConfirmDialog(playerid);
    return 1;
}

stock ShowConfirmDialog(playerid) {
    if (GetPVarInt(playerid, "supply_Price") > GetPlayerCash(playerid)) return 1;
    new string[128];

    switch (GetPVarInt(playerid, "supply_ReqType")) {
        case DROP_TYPE_WEAPON:  {
            new wname[24];
            GetWeaponName(AvailableWeapons[GetPVarInt(playerid, "supply_WepIndex")][weaponID], wname, sizeof(wname));
            format(string, sizeof(string), "{FFFFFF}You're about to order a supply drop for {F1C40F}%s.\n\n{FFFFFF}Price:{2ECC71}%s", wname, FormatCurrencyEx(GetPVarInt(playerid, "supply_Price")));
        }

        case DROP_TYPE_AMMO:  {
            format(string, sizeof(string), "{FFFFFF}You're about to order a supply drop for {F1C40F}Ammo.\n\n{FFFFFF}Price:{2ECC71}%s", FormatCurrencyEx(GetPVarInt(playerid, "supply_Price")));
        }

        case DROP_TYPE_HEALTH:  {
            format(string, sizeof(string), "{FFFFFF}You're about to order a supply drop for {F1C40F}Health Kit.\n\n{FFFFFF}Price:{2ECC71}%s", FormatCurrencyEx(GetPVarInt(playerid, "supply_Price")));
        }

        case DROP_TYPE_ARMOR:  {
            format(string, sizeof(string), "{FFFFFF}You're about to order a supply drop for {F1C40F}Body Armor.\n\n{FFFFFF}Price:{2ECC71}%s", FormatCurrencyEx(GetPVarInt(playerid, "supply_Price")));
        }
    }
    return FlexPlayerDialog(playerid, "ShowConfirmDialog", DIALOG_STYLE_MSGBOX, "Supply Drop {FFFFFF}Confirmation", string, "Confirm", "Cancel");
}

FlexDialog:ShowConfirmDialog(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowDropMenu(playerid);
    new price = GetPVarInt(playerid, "supply_Price");
    if (price > GetPlayerCash(playerid)) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't afford this drop.");
    new cooldown = GetPVarInt(playerid, "supply_Cooldown");
    if (cooldown > gettime()) {
        new string[72];
        format(string, sizeof(string), "[Error]: {FFFFFF}Please wait %s more to request a supply drop again.", ConvertToMinutes(cooldown - gettime()));
        return SendClientMessageEx(playerid, -1, string);
    }
    new id = Iter_Free(SupplyDrops);
    if (id == INVALID_ITERATOR_SLOT) return SendClientMessageEx(playerid, -1, "[Error]: {FFFFFF}You can't request a supply drop right now.");
    vault:PlayerVault(playerid, -price, "charged for supply drop", Vault_ID_Government, price, sprintf("%s charged for supply drop", GetPlayerNameEx(playerid)));
    new Float:x, Float:y, Float:z;
    if (!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, x, y, z);
    else GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SupplyData[id][requestedBy] = playerid;
    SupplyData[id][dropType] = GetPVarInt(playerid, "supply_ReqType");
    SupplyData[id][dropData] = AvailableWeapons[GetPVarInt(playerid, "supply_WepIndex")][weaponID];
    SupplyData[id][dropTimer] = SetPreciseTimer("FlyPlane", PLANE_TIME * 1000, false, "ifffi", id, x, y, z, random(360));
    Iter_Add(SupplyDrops, id);
    SendClientMessageEx(playerid, 0x3498DBFF, "[PILOT]: {FFFFFF}Request received.");
    SetPVarInt(playerid, "supply_Cooldown", gettime() + REQ_COOLDOWN * 60);
    return 1;
}