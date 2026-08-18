stock DTruck:GetNearestShareTruck(trailerid) {
    if (!IsValidVehicle(trailerid)) return -1;

    new Float:pos[6];
    GetVehiclePos(trailerid, pos[0], pos[1], pos[2]);
    foreach(new vehicleid: Vehicle) {
        GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
        if (
            GetDistanceBetweenPoints3D(pos[0], pos[1], pos[2], pos[3], pos[4], pos[5]) < ((IsVehicleModelPlane(trailerid) || IsVehicleModelPlane(vehicleid)) ? 20 : 10) &&
            IsVehicleAllowedForStorage(vehicleid) && vehicleid != trailerid
        ) return vehicleid;
    }
    return -1;
}

hook DTruckOnInit(playerid, trailerid, page) {
    if (page != 0 || Faction:GetPlayerFID(playerid) != FACTION_ID_SATD || !Faction:IsPlayerSigned(playerid)) return 1;
    new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
    if (nearTrailerId != -1 && GetPlayerAdminLevel(playerid) > 0) DTruck:AddCommand(playerid, "Transfer trailer items");
    return 1;
}

hook DTruckOnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Transfer trailer items", inputtext)) {
        new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
        if (nearTrailerId != -1) DTruck:TransferMenu(playerid, trailerid);
        return ~1;
    }
    return 1;
}

stock DTruck:TransferMenu(playerid, trailerid, page = 0) {
    new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
    if (nearTrailerId == -1) return 1;

    new total = TrailerStorage:GetResourceTypesLoaded(trailerid);
    if (total == 0) return AlexaMsg(playerid, "trailer does not have any resource to share");

    new perpage = 15;
    new paged = (page + 1) * perpage;
    new skip = page * perpage;
    new remaining = total - paged;

    new count = 0, string[2000];
    strcat(string, "#\tName\tIn Trailer\n");
    for (new trailerItemId; trailerItemId < MAXTRAILERITEMS; trailerItemId++) {
        if (skip > 0) {
            skip--;
            continue;
        }
        new shopItemId = TrailerStorage:GetShopItemId(trailerItemId);
        new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
        if (inTrailer < 1) continue;
        strcat(string, sprintf("%d\t%s\t%d %s\n", shopItemId, DynamicShopBusinessItem:GetItemName(shopItemId), inTrailer, DynamicShopBusinessItem:GetItemUnit(shopItemId)));
        count++;
        if (count == perpage) break;
    }
    if (page > 0) strcat(string, "Back Page\n");
    if (remaining > 0) strcat(string, "Next Page\n");
    FlexPlayerDialog(playerid, "TruckTransferMenu", DIALOG_STYLE_TABLIST_HEADERS, "Transfer resource", string, "Select", "Close", trailerid, sprintf("%d", page));
    return 1;
}

FlexDialog:TruckTransferMenu(playerid, response, listitem, const inputtext[], trailerid, const payload[]) {
    new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
    if (!response || nearTrailerId == -1) return 1;
    new page = strval(payload);
    if (IsStringSame(inputtext, "Back Page")) return DTruck:TransferMenu(playerid, trailerid, page - 1);
    if (IsStringSame(inputtext, "Next Page")) return DTruck:TransferMenu(playerid, trailerid, page + 1);
    DTruck:ShareResourceInput(playerid, trailerid, strval(inputtext));
    return 1;
}

stock DTruck:ShareResourceInput(playerid, trailerid, shopItemId) {
    new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
    new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
    if (inTrailer < 1 || nearTrailerId == -1) return 1;
    new inTrailerTarget = TrailerStorage:GetResourceByShopId(nearTrailerId, shopItemId);
    new string[512];
    strcat(string, sprintf("Transfer to %s\n", GetVehicleName(nearTrailerId)));
    strcat(string, sprintf("Amount in your trailer: %d %s\n", inTrailer, DynamicShopBusinessItem:GetItemUnit(shopItemId)));
    strcat(string, sprintf("Amount in target trailer: %d %s\n", inTrailerTarget, DynamicShopBusinessItem:GetItemUnit(shopItemId)));
    strcat(string, sprintf("Avaialble space in target trailer: %d %s\n", DynamicShopBusinessItem:GetItemMaxStorage(shopItemId) - inTrailerTarget, DynamicShopBusinessItem:GetItemUnit(shopItemId)));
    strcat(string, sprintf("Enter amount betweeen 1 to %d\n", inTrailer));
    return FlexPlayerDialog(
        playerid, "TruckShareResourceInput", DIALOG_STYLE_INPUT, "Transfer resource", string, "Transfer", "Cancel", trailerid, sprintf("%d", shopItemId)
    );
}

FlexDialog:TruckShareResourceInput(playerid, response, listitem, const inputtext[], trailerid, const payload[]) {
    new shopItemId = strval(payload);
    new nearTrailerId = DTruck:GetNearestShareTruck(trailerid);
    new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
    if (!response || nearTrailerId == -1) return 1;
    new maxLimit = DynamicShopBusinessItem:GetItemMaxStorage(shopItemId);
    new inTrailerTarget = TrailerStorage:GetResourceByShopId(nearTrailerId, shopItemId);

    new amount = 0;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > inTrailer || amount + inTrailerTarget > maxLimit) {
        return DTruck:ShareResourceInput(playerid, trailerid, shopItemId);
    }

    TrailerStorage:SetResourceByShopId(trailerid, shopItemId, inTrailer - amount);
    TrailerStorage:SetResourceByShopId(nearTrailerId, shopItemId, inTrailerTarget + amount);

    AlexaMsg(playerid, "transfered goods");
    DTruck:TransferMenu(playerid, trailerid);
    return 1;
}