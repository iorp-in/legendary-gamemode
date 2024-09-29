#define USE_SMOOTH_TURNS
new Path:autodrive_id[MAX_PLAYERS] = {
    Path:  - 1,
    ...
};
new autodrive_CurrentTarget[MAX_PLAYERS] = {
    0,
    ...
};
new autodrive_Timer[MAX_PLAYERS] = {
    -1,
    ...
};
new Float:autodrive_Speed[MAX_PLAYERS] = {
    0.30,
    ...
};
new bool:autodrive_Status[MAX_PLAYERS] = {
    false,
    ...
};


hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (autodrive_Timer[playerid] == 1) AutoDrive(playerid);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    autodrive_Timer[playerid] = -1;
    autodrive_id[playerid] = Path:  - 1;
    autodrive_CurrentTarget[playerid] = 0;
    return 1;
}

hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
    if (!autodrive_Status[playerid]) return 1;
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Please use an autodrive equipped vehicle");
    new Float:x, Float:y, Float:z, MapNode:start;
    GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    if (GetClosestMapNodeToPoint(x, y, z, start) == GPS_ERROR_INVALID_NODE) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive malfunction, please try again on another place");
        autodrive_Status[playerid] = false;
        return 1;
    }
    new MapNode:target;
    if (GetClosestMapNodeToPoint(fX, fY, fZ, target) == GPS_ERROR_INVALID_NODE) {
        autodrive_Status[playerid] = false;
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}{4286f4}[Alexa]: {FFFFEE}Autodrive malfunction, try another target location");
    }
    if (!FindPathThreaded(start, target, "OnAutoDriveEnable", "ii", playerid, GetTickCount())) {
        return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}{4286f4}[Alexa]: {FFFFEE}Autodrive malfunction, can not find a way to location");
    }
    return 1;
}

forward OnAutoDriveEnable(Path:pathid, playerid, start_time);
public OnAutoDriveEnable(Path:pathid, playerid, start_time) {
    if (!autodrive_Status[playerid]) return 1;
    autodrive_id[playerid] = pathid;
    autodrive_Timer[playerid] = 1;
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive will drive you now to your destination");
    autodrive_Status[playerid] = false;
    return 1;
}

forward Float:atan2VehicleZ(Float:Xb, Float:Yb, Float:Xe, Float:Ye); // Dunno how to ad_place_name it...
stock Float:atan2VehicleZ(Float:Xb, Float:Yb, Float:Xe, Float:Ye) {
    new Float:a = floatabs(360.0 - atan2(Xe - Xb, Ye - Yb));
    if (360 > a > 180) return a;
    return a - 360.0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (autodrive_Timer[playerid] == 1) AutodriveStopCommand(playerid);
    return 1;
}

forward AutoDrive(playerid);
public AutoDrive(playerid) {
    if (IsPlayerInAnyVehicle(playerid)) {
        new Float:pos[2][3];
        new vehicleid = GetPlayerVehicleID(playerid);
        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        if (GetVehicleFuelEx(vehicleid) < 1.0 || engine != VEHICLE_PARAMS_ON) return AutodriveStopCommand(playerid);
        if (autodrive_CurrentTarget[playerid] == 0) {
            autodrive_CurrentTarget[playerid]++;
            new MapNode:nodeid;
            GetPathNode(autodrive_id[playerid], autodrive_CurrentTarget[playerid], nodeid);
            GetMapNodePos(nodeid, pos[0][0], pos[0][1], pos[0][2]);
            SetVehiclePosEx(vehicleid, pos[0][0], pos[0][1], pos[0][2] + 2.0);
            return 1;
        }
        new size;
        new MapNode:nodeid;
        GetPathNode(autodrive_id[playerid], autodrive_CurrentTarget[playerid], nodeid);
        GetPathSize(autodrive_id[playerid], size);
        if ((autodrive_CurrentTarget[playerid] + 1) >= size) {
            DestroyPath(autodrive_id[playerid]);
            autodrive_Timer[playerid] = -1;
            autodrive_id[playerid] = Path:  - 1;
            autodrive_CurrentTarget[playerid] = 0;
            SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Destination reached, have a nice day.");
            return 1;
        }
        GetMapNodePos(nodeid, pos[1][0], pos[1][1], pos[1][2]);
        if (IsPlayerInRangeOfPoint(playerid, 10.0, pos[1][0], pos[1][1], pos[1][2])) {
            autodrive_CurrentTarget[playerid]++;
            return 1;
        }
        PullVehicleIntoDirection(vehicleid, pos[1][0], pos[1][1], pos[1][2], autodrive_Speed[playerid]);
    } else {
        autodrive_Timer[playerid] = -1;
        autodrive_id[playerid] = Path:  - 1;
        autodrive_CurrentTarget[playerid] = 0;
    }
    return 1;
}
#define DEPRECATE_Z
stock PullVehicleIntoDirection(vehicleid, Float:x, Float:y, Float:z, Float:speed) //Thanks to Miguel for supplying me with this function, I have edited it a bit
{
    new
    Float:distance,
    Float:vehicle_pos[3];

    GetVehiclePos(vehicleid, vehicle_pos[0], vehicle_pos[1], vehicle_pos[2]);
    #if defined USE_SMOOTH_TURNS
    new Float:oz = atan2VehicleZ(vehicle_pos[0], vehicle_pos[1], x, y);
    new Float:vz;
    GetVehicleZAngle(vehicleid, vz);
    if (oz < vz - 180) oz = oz + 360;
    if (vz < oz - 180) vz = vz + 360;
    new Float:cz = floatabs(vz - oz);
    #else
    SetVehicleZAngle(vehicleid, atan2VehicleZ(vehicle_pos[0], vehicle_pos[1], x, y));
    #endif
    x -= vehicle_pos[0];
    y -= vehicle_pos[1];
    z -= vehicle_pos[2];
    #if defined DEPRECATE_Z
    distance = floatsqroot((x * x) + (y * y));
    x = (speed * x) / distance;
    y = (speed * y) / distance;
    GetVehicleVelocity(vehicleid, vehicle_pos[0], vehicle_pos[0], z);
    #else
    z += 0.11;
    distance = floatsqroot((x * x) + (y * y) + (z * z));
    x = (speed * x) / distance;
    y = (speed * y) / distance;
    z = (speed * z) / distance;
    #endif
    #if defined USE_SMOOTH_TURNS
    if (cz > 0) {
        new Float:fz = cz * 0.0015;
        if (vz < oz) SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, fz);
        if (vz > oz) SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, -fz);
    }
    #endif
    SetVehicleVelocity(vehicleid, x, y, z);
}

// Player CMD
stock AutodriveCommand(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Please use an autodrive equipped vehicle");
    if (autodrive_id[playerid] == Path:  - 1) {
        if (GetVehicleFuelEx(GetPlayerVehicleID(playerid)) < 1.0) SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}not enough fuel to actiavate auto drive");
        autodrive_Status[playerid] = true;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive is waiting for the route point, right click it from the map..");
        return 1;
    }
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive is already activated");
    return 1;
}

stock AutoDriveChangeSpeed(playerid, Float:speed) {
    if (autodrive_id[playerid] == Path:  - 1) {
        if (Float:speed < 0.01 || Float:speed > 0.50) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive speed must be between 0.01 and 0.50");
        autodrive_Speed[playerid] = speed;
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}Autodrive speed rate set to:%.2f", autodrive_Speed[playerid]);
        SendClientMessageEx(playerid, -1, string);
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive cannot change speed while driving");
    return 1;
}

stock AutodriveStopCommand(playerid) {
    if (autodrive_Timer[playerid] != (-1)) {
        DestroyPath(autodrive_id[playerid]);
        autodrive_Timer[playerid] = -1;
        autodrive_id[playerid] = Path:  - 1;
        autodrive_CurrentTarget[playerid] = 0;
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive disabled, you have the vehicle controls in your hand now");
        return 1;
    }
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Autodrive already disabled, you have the vehicle controls in your hand now");
    return 1;
}

new EtShop:DataAutoDrive[MAX_PLAYERS];

stock EtShop:IsAutoDriveActive(playerid) {
    return gettime() < EtShop:DataAutoDrive[playerid];
}

stock EtShop:GetAutoDrive(playerid) {
    return EtShop:DataAutoDrive[playerid];
}

stock EtShop:SetAutoDrive(playerid, expireAt) {
    EtShop:DataAutoDrive[playerid] = expireAt;
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "autodrive", "int", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetAutoDrive(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "autodrive"));
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 33) return 1;
    if (EtShop:IsAutoDriveActive(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have auto drive, no need to purchase it again until it expires."); return ~1; }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase auto drive"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetAutoDrive(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased auto drive. Validity: 30 days");
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsPlayerInAnyVehicle(playerid) && EtShop:IsAutoDriveActive(playerid)) UCP:AddCommand(playerid, "Auto Drive", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Auto Drive", inputtext)) AutodriveMenu(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (autodrive_Timer[playerid] != (-1)) {
        autodrive_Timer[playerid] = -1;
        autodrive_id[playerid] = Path:  - 1;
        autodrive_CurrentTarget[playerid] = 0;
    }
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(EtShop:GetAutoDrive(playerid), GetPlayerNameEx(playerid), "username", "autodrive");
    return 1;
}

stock AutodriveMenu(playerid) {
    new string[512];
    if (IsPlayerInAnyVehicle(playerid)) strcat(string, "Enable Auto Drive\n");
    if (IsPlayerInAnyVehicle(playerid)) strcat(string, "Disable Auto Drive\n");
    strcat(string, "Set Auto Drive Speed Rate\n");
    return FlexPlayerDialog(playerid, "AutodriveMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}Auto Drive Control Panel", string, "Select", "Close");
}

FlexDialog:AutodriveMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Enable Auto Drive", inputtext)) return AutodriveCommand(playerid);
    if (IsStringSame("Disable Auto Drive", inputtext)) return AutodriveStopCommand(playerid);
    if (IsStringSame("Set Auto Drive Speed Rate", inputtext)) return AutodriveMenuSpeed(playerid);
    return 1;
}

stock AutodriveMenuSpeed(playerid) {
    return FlexPlayerDialog(playerid, "AutodriveMenuSpeed", DIALOG_STYLE_INPUT, "Auto Drive Panel", "Enter [Speed] [0.01 to 0.50]\ndefault speed rate is: 0.30", "Submit", "Cancel");
}

FlexDialog:AutodriveMenuSpeed(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AutodriveMenu(playerid);
    new Float:speed = 0.30;
    if (sscanf(inputtext, "f", Float:speed) || Float:speed < 0.01 || Float:speed > 0.50) return AutodriveMenuSpeed(playerid);
    if (Float:speed < 0.01 || Float:speed > 0.50) return AutodriveMenuSpeed(playerid);
    AutoDriveChangeSpeed(playerid, Float:speed);
    return AutodriveMenu(playerid);
}