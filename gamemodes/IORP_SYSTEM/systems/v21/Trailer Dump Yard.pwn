hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 42) return 1;
    if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ~1;
    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetAllowedVehicleTrailerID(vehicleid);
    if (!IsVehicleAllowedForStorage(trailerid)) return ~1;
    TrailerStorage:DumpMenu(playerid, trailerid);
    return ~1;
}

TrailerStorage:DumpMenu(playerid, trailerid, page = 0) {
    new total = TrailerStorage:GetResourceTypesLoaded(trailerid);
    if (total == 0) return AlexaMsg(playerid, "There is nothing to dump in your trailer");

    new string[2000];
    strcat(string, "#\tMaterial\tIn trailer\n");
    new perPage = 25;
    new paged = (page + 1) * perPage;
    new remaining = total - paged;
    new skip = page * perPage;
    new count = 0;
    for (new trailerItemId; trailerItemId < total; trailerItemId++) {
        if (count >= perPage) break;
        if (skip > 0) {
            skip--;
            continue;
        }
        new inTrailer = TrailerStorage:GetResource(trailerid, trailerItemId);
        if (inTrailer > 0) {
            strcat(string, sprintf(
                "%d\t%s\t%d %s\n",
                trailerItemId, TrailerStorage:GetName(trailerItemId), inTrailer,
                TrailerStorage:GetUnit(trailerItemId)
            ));
            count++;
        }
    }
    if (count == 0) return AlexaMsg(playerid, "There is nothing to dump in your trailer");
    strcat(string, "Dump All\n");
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    return FlexPlayerDialog(playerid, "TrailerDumpMenuConfirm", DIALOG_STYLE_TABLIST_HEADERS, "Dump Resource", string, "Select", "Close", page, sprintf("%d", trailerid));
}

FlexDialog:TrailerDumpMenuConfirm(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    new trailerid = strval(payload);
    if (IsStringSame(inputtext, "Next Page")) return TrailerStorage:DumpMenu(playerid, trailerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return TrailerStorage:DumpMenu(playerid, trailerid, page - 1);
    if (IsStringSame(inputtext, "Dump All")) {
        for (new trailerItemId; trailerItemId < MAXTRAILERITEMS; trailerItemId++) TrailerStorage:SetResource(trailerid, trailerItemId, 0);
        GameTextForPlayer(playerid, "~r~Dumping...", 3000, 3);
        return 1;
    }
    return TrailerStorage:DumpMenuInput(playerid, trailerid, strval(inputtext));
}

TrailerStorage:DumpMenuInput(playerid, trailerid, trailerItemId) {
    return FlexPlayerDialog(
        playerid, "DumpMenuInput", DIALOG_STYLE_INPUT, "Dump Resource",
        sprintf("Enter resource amount to dump\nLimit: 1 to %d", TrailerStorage:GetResource(trailerid, trailerItemId)),
        "Dump", "Cancel", trailerid, sprintf("%d", trailerItemId)
    );
}

FlexDialog:DumpMenuInput(playerid, response, listitem, const inputtext[], trailerid, const payload[]) {
    if (!response) return TrailerStorage:DumpMenu(playerid, trailerid);
    new amount, trailerItemId = strval(payload);
    if (
        sscanf(inputtext, "d", amount) || amount < 1 || amount > TrailerStorage:GetResource(trailerid, trailerItemId)
    ) return TrailerStorage:DumpMenuInput(playerid, trailerid, trailerItemId);
    GameTextForPlayer(playerid, "~r~Dumping...", 3000, 3);
    TrailerStorage:IncreaseResource(trailerid, trailerItemId, -amount);
    return TrailerStorage:DumpMenu(playerid, trailerid);
}