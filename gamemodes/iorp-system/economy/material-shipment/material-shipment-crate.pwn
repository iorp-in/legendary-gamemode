#define Max_Crates 1000
new Iterator:crates < Max_Crates > ;

enum Crate:EnumData {
    Crate:TrailerItemId,
    Crate:TrailerItemQuantity,
    Float:Crate:pos[3],
    Crate:vw,
    Crate:int,

    Crate:Attached,
    Crate:objId
}
new Crate:Data[Max_Crates][Crate:EnumData];
new Crate:DebugID;

hook OnGameModeInit() {
    Crate:DebugID = Debug:GetID("Material Destroy Crate ID");
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new crateId:crates) {
        if (!IsValidDynamicObject(Crate:Data[crateId][Crate:objId])) {
            // Crate:Create(Crate:Data[crateId][materialShipmentId], Crate:Data[crateId][materialCrateowner]);
            Crate:Destroy(crateId);
        }
    }
    return 1;
}

stock Crate:GetNearest(playerid, Float:distance = 5.0) {
    foreach(new crateId:crates) {
        if (IsValidDynamicObject(Crate:Data[crateId][Crate:objId])) {
            new Float:cPos[3];
            GetDynamicObjectPos(Crate:Data[crateId][Crate:objId], Float:cPos[0], Float:cPos[1], Float:cPos[2]);
            if (IsPlayerInRangeOfPoint(playerid, distance, Float:cPos[0], Float:cPos[1], Float:cPos[2])) return crateId;
        }
    }
    return -1;
}

/**
    # create crate
*/
stock Crate:Create(traileritemId, crateQuantity = 1, Float:posx, Float:posy, Float:posz, vw = 0, int = 0) {
    new crateId = Iter_Free(crates);
    if (crateId == INVALID_ITERATOR_SLOT) return 0;
    Iter_Add(crates, crateId);
    if (IsValidDynamicObject(Crate:Data[crateId][Crate:objId])) DestroyDynamicObjectEx(Crate:Data[crateId][Crate:objId]);
    Crate:Data[crateId][Crate:TrailerItemId] = traileritemId;
    Crate:Data[crateId][Crate:TrailerItemQuantity] = crateQuantity;
    Crate:Data[crateId][Crate:pos][0] = posx;
    Crate:Data[crateId][Crate:pos][1] = posy;
    Crate:Data[crateId][Crate:pos][2] = posz;
    Crate:Data[crateId][Crate:vw] = vw;
    Crate:Data[crateId][Crate:int] = int;
    Crate:Data[crateId][Crate:Attached] = 0;

    Crate:Data[crateId][Crate:objId] = STREAMER_TAG_OBJECT:CreateDynamicObject(1271, posx, posy, posz, 0.0, 0.0, 0.0, vw, int);
    Debug:SendMessage(Crate:DebugID, sprintf("Debug:Create Crate:CrateID: %d OBJECTID: %d", crateId, Crate:Data[crateId][Crate:objId]));
    return 1;
}


stock Crate:GetIdByObject(objectID) {
    foreach(new crateId:crates) {
        if (Crate:Data[crateId][Crate:objId] == objectID) return crateId;
    }
    return -1;
}

stock Crate:GetObjectId(crateId) {
    if (!Crate:IsValidId(crateId)) return -1;
    return Crate:Data[crateId][Crate:objId];
}

stock Crate:GetTrailerItemId(crateId) {
    if (!Crate:IsValidId(crateId)) return -1;
    return Crate:Data[crateId][Crate:TrailerItemId];
}

stock Crate:GetTrailerItemQuantity(crateId) {
    if (!Crate:IsValidId(crateId)) return -1;
    return Crate:Data[crateId][Crate:TrailerItemQuantity];
}

stock Crate:IsValidId(crateId) {
    if (Iter_Contains(crates, crateId)) return 1;
    return 0;
}

stock Crate:Destroy(crateId) {
    Debug:SendMessage(Crate:DebugID, sprintf("Debug:Destroy Crate:CrateID: %d", crateId));
    if (!Crate:IsValidId(crateId)) return 0;
    if (IsValidDynamicObject(Crate:Data[crateId][Crate:objId])) {
        DestroyDynamicObjectEx(Crate:Data[crateId][Crate:objId]);
        Crate:Data[crateId][Crate:objId] = -1;
    }
    Iter_Remove(crates, crateId);
    return 1;
}


// AttachObjectToVehicle(objectid, vehicleid(forklift), 0.000000,0.599999,0.449999,0.000000,0.000000,0.000000);
new Crate:ForkLift[MAX_VEHICLES] = {-1, ... };

forward OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId);
public OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    Crate:ForkLift[forkliftVehID] = -1;
    Crate:Destroy(crateId);
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    Crate:ForkLift[vehicleid] = -1;
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    if (Crate:ForkLift[vehicleid] != -1) {
        Crate:Deattach(vehicleid);
        return 1;
    }
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    if (Crate:ForkLift[vehicleid] != -1) {
        Crate:Deattach(vehicleid);
        return 1;
    }
    return 1;
}

stock Crate:IsForkLiftOccupied(vehicleid) {
    return Crate:ForkLift[vehicleid] != -1;
}

stock Crate:Deattach(vehicleid) {
    new STREAMER_TAG_OBJECT:objectid = Crate:ForkLift[vehicleid];
    if (objectid == -1) return 1;
    if (!IsValidVehicle(vehicleid)) return 1;
    if (!IsValidDynamicObject(STREAMER_TAG_OBJECT:objectid)) return 1;
    new crateId = Crate:GetIdByObject(objectid);
    if (crateId == -1) return 1;
    DestroyDynamicObjectEx(STREAMER_TAG_OBJECT:objectid);
    new Float:pos[3];
    GetVehiclePos(vehicleid, Float:pos[0], Float:pos[1], Float:pos[2]);
    GetXYInFrontOfVehicle(vehicleid, Float:pos[0], Float:pos[1], 1.3);
    Crate:Data[crateId][Crate:objId] = CreateDynamicObject(1271, Float:pos[0], Float:pos[1], Float:pos[2], 0.0, 0.0, 0.0);
    Crate:ForkLift[vehicleid] = -1;
    Crate:Data[crateId][Crate:Attached] = 0;
    return 1;
}

stock Crate:Attach(forkLiftId, crateId) {
    new dobjectid = Crate:GetObjectId(crateId);
    Crate:ForkLift[forkLiftId] = dobjectid;
    Crate:Data[crateId][Crate:Attached] = 1;
    AttachDynamicObjectToVehicle(dobjectid, forkLiftId, 0.000000, 0.599999, 0.449999, 0.000000, 0.000000, 0.000000);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_CROUCH) return 1;
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (GetVehicleModel(vehicleid) != 530) return 1;
    if (Crate:ForkLift[vehicleid] != -1) {
        Crate:Deattach(vehicleid);
        return 1;
    } else {
        new crateId = Crate:GetNearest(playerid, 10.0);
        if (crateId != -1 && !Crate:Data[crateId][Crate:Attached]) {
            new dobjectid = Crate:GetObjectId(crateId);
            if (dobjectid != -1) {
                Crate:Attach(vehicleid, crateId);
                GameTextForPlayer(playerid, sprintf("~g~%s", TrailerStorage:GetName(Crate:GetTrailerItemId(crateId))), 2500, 3);
                return 1;
            }
        }
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (IsPlayerInAnyVehicle(playerid)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        new trailerid = GetPlayerNearestTrailerID(playerid, 10.0);
        if (GetVehicleModel(vehicleid) != 530 || trailerid == -1) return 1;

        // forklift with trailer options
        if (Crate:ForkLift[vehicleid] != -1) {
            new crateId = Crate:GetIdByObject(Crate:ForkLift[vehicleid]);
            if (crateId != -1) UCP:AddCommand(playerid, "Load Shipment In Trailer", true);
            else Crate:ForkLift[vehicleid] = -1;
        } else {
            if (TrailerStorage:GetResourceTypesLoaded(trailerid) > 0) UCP:AddCommand(playerid, "Unload Shipment From Trailer", true);
        }
    } else {
        new crateId = Crate:GetNearest(playerid, 5.0);
        if (Crate:IsValidId(crateId)) UCP:AddCommand(playerid, "Check crate receipt", true);
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsPlayerInAnyVehicle(playerid)) {

        new vehicleid = GetPlayerVehicleID(playerid);
        new trailerid = GetPlayerNearestTrailerID(playerid, 10.0);
        if (GetVehicleModel(vehicleid) != 530 || trailerid == -1) return 1;

        // forklift with trailer options handler
        if (IsStringSame(inputtext, "Load Shipment In Trailer") && Crate:ForkLift[vehicleid] != -1) {
            new crateId = Crate:GetIdByObject(Crate:ForkLift[vehicleid]);
            if (crateId != -1) CallRemoteFunction("OnTrailerLoadShipment", "dddd", playerid, vehicleid, trailerid, crateId);
            return ~1;
        }
        if (IsStringSame(inputtext, "Unload Shipment From Trailer")) {
            Crate:uMenu(playerid, trailerid);
            return ~1;
        }
    } else {
        if (IsStringSame(inputtext, "Check crate receipt")) {
            new crateId = Crate:GetNearest(playerid, 5.0);
            if (!Crate:IsValidId(crateId)) return ~1;
            new string[1024];
            strcat(string, sprintf("ID: %d\n", crateId));
            strcat(string, sprintf("Item Name: %s (%d)\n", TrailerStorage:GetName(Crate:GetTrailerItemId(crateId)), Crate:GetTrailerItemId(crateId)));
            strcat(string, sprintf("Item Quantity: %d %s\n", Crate:GetTrailerItemQuantity(crateId), TrailerStorage:GetUnit(Crate:GetTrailerItemId(crateId))));
            strcat(string, "Load this crate into a trailer with a forklift\n");
            FlexPlayerDialog(playerid, "CrateReceipt", DIALOG_STYLE_MSGBOX, "Crate Receipt", string, "Close", "");
            return ~1;
        }
    }
    return 1;
}