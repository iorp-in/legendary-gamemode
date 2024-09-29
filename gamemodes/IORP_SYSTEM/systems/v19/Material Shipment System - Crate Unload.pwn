enum Crate:uDataEnum {
    Crate:uMaxQuantity,
    Crate:uTrailerItemId,
    Crate:uTitle[50],
}
new Crate:uData[Max_Material_Shipment][Crate:uDataEnum];
new Iterator:uCrates < Max_Material_Shipment > ;

stock Crate:uGetTrailerItemId(uId) return Crate:uData[uId][Crate:uTrailerItemId];
stock Crate:uGetMaxQuantity(uId) return Crate:uData[uId][Crate:uMaxQuantity];
stock Crate:uGetTitle(uId) {
    new string[50];
    format(string, sizeof string, "%s", Crate:uData[uId][Crate:uTitle]);
    return string;
}

stock Crate:uRegister(const title[], trailerItemId, maxQuantity) {
    new uId = Iter_Free(uCrates);
    if (uId == INVALID_ITERATOR_SLOT) return -1;
    Iter_Add(uCrates, uId);
    format(Crate:uData[uId][Crate:uTitle], 50, "%s", title);
    Crate:uData[uId][Crate:uTrailerItemId] = trailerItemId;
    Crate:uData[uId][Crate:uMaxQuantity] = maxQuantity;
    return uId;
}

stock Crate:uMenu(playerid, trailerid, page = 0) {
    if (!IsValidVehicle(trailerid) || !IsVehicleAllowedForStorage(trailerid)) return 1;
    new string[2000];
    strcat(string, "#\tMaterial\tIn trailer\n");
    new total = Iter_Count(uCrates);
    new perPage = 25;
    new paged = (page + 1) * perPage;
    new remaining = total - paged;
    new skip = page * perPage;
    new count = 0;
    for (new uId; uId < total; uId++) {
        if (count >= perPage) break;
        if (skip > 0) {
            skip--;
            continue;
        }
        new inTrailer = TrailerStorage:GetResource(trailerid, Crate:uGetTrailerItemId(uId));
        if (inTrailer > 0) {
            strcat(string, sprintf(
                "%d\t%s\t%d %s\n",
                uId, Crate:uGetTitle(uId), inTrailer,
                TrailerStorage:GetUnit(Crate:uGetTrailerItemId(uId))
            ));
            count++;
        }
    }
    if (count == 0) return AlexaMsg(playerid, "There is nothing in the trailer");
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    FlexPlayerDialog(playerid, "UnloadCrateMenu", DIALOG_STYLE_TABLIST_HEADERS, "Unload Resource", string, "Select", "Close", page, sprintf("%d", trailerid));
    return 1;
}

FlexDialog:UnloadCrateMenu(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return Crate:uMenu(playerid, strval(payload), page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Crate:uMenu(playerid, strval(payload), page - 1);
    return Crate:UnloadMenuInput(playerid, page, strval(payload), strval(inputtext));
}

stock Crate:UnloadMenuInput(playerid, page, trailerid, uId) {
    new inTrailer = TrailerStorage:GetResource(trailerid, Crate:uGetTrailerItemId(uId));
    return FlexPlayerDialog(playerid, "UnloadMenuInput", DIALOG_STYLE_INPUT, "Unload Resource: How much?",
        sprintf(
            "Enter quantity of resource to unload\nIn Trailer: %d\nLimit: 1 to %d", inTrailer, Crate:uGetMaxQuantity(uId) > inTrailer ? inTrailer : Crate:uGetMaxQuantity(uId)
        ),
        "Submit", "Close", page, sprintf("%d %d", trailerid, uId)
    );
}

FlexDialog:UnloadMenuInput(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new uId, trailerid, quantity;
    sscanf(payload, "d d", trailerid, uId);
    if (!response) return Crate:uMenu(playerid, trailerid, page);

    new inTrailer = TrailerStorage:GetResource(trailerid, Crate:uGetTrailerItemId(uId));
    if (sscanf(inputtext, "d", quantity) || quantity < 1 || quantity > inTrailer || quantity > Crate:uGetMaxQuantity(uId)) {
        return Crate:UnloadMenuInput(playerid, page, trailerid, uId);
    }

    if (!IsPlayerInAnyVehicle(playerid)) return AlexaMsg(playerid, "Unload resources from trailer using a forklift");
    new forkLiftId = GetPlayerVehicleID(playerid);
    if (GetVehicleModel(forkLiftId) != 530 || !IsValidVehicle(trailerid) || Crate:IsForkLiftOccupied(forkLiftId)) return AlexaMsg(playerid, "Unload resources from trailer using a forklift");

    return CallRemoteFunction("OnRequestResourceUnload", "ddddd", playerid, uId, forkLiftId, trailerid, quantity);
}

forward OnRequestResourceUnload(playerid, uId, forkLiftId, trailerid, quantity);
public OnRequestResourceUnload(playerid, uId, forkLiftId, trailerid, quantity) {
    TrailerStorage:IncreaseResource(trailerid, Crate:uGetTrailerItemId(uId), -quantity);
    new Float:pos[3];
    GetVehiclePos(forkLiftId, pos[0], pos[1], pos[2]);
    new crateId = Crate:Create(Crate:uGetTrailerItemId(uId), quantity, pos[0], pos[1], pos[2] + 5.0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid));
    Crate:Attach(forkLiftId, crateId);
    return 1;
}