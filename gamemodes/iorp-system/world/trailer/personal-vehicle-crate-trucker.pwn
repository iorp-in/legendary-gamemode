stock PersonalVehicle:MaterialItemID(xid) {
    return PersonalVehicle:GetModelID(xid) - 43;
}

stock PersonalVehicle:GetNearestSaleCars(playerid) {
    new total = 0;
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPurchased(xid)) continue;
        if (PersonalVehicle:IsInRange(playerid, xid, 10.0)) total++;
    }
    return total;
}

stock PersonalVehicle:ConvertToCrate(playerid, trailerid) {
    new total = PersonalVehicle:GetNearestSaleCars(playerid);
    if (!total) return AlexaMsg(playerid, "park your trailer next to sale vehicle");
    new string[2000];
    strcat(string, "Plate\tNam\tPrice\n");
    foreach(new xid:xVehicles) {
        if (PersonalVehicle:IsPurchased(xid) || !PersonalVehicle:IsInRange(playerid, xid, 10.0)) continue;
        strcat(string, sprintf("%s\t%s\t$%s\n", PersonalVehicle:GetPlate(xid), PersonalVehicle:GetName(xid), FormatCurrency(PersonalVehicle:GetPrice(xid))));
    }
    return FlexPlayerDialog(
        playerid, "PersonalVehConvertToCrate", DIALOG_STYLE_TABLIST_HEADERS, "Select vehicle to load", string, "Select", "Close", trailerid
    );
}

FlexDialog:PersonalVehConvertToCrate(playerid, response, listitem, const inputtext[], trailerid, const payload[]) {
    if (!response) return 1;
    new xid = PersonalVehicle:GetIDByPlate(inputtext);
    if (!PersonalVehicle:IsValidID(xid) || PersonalVehicle:IsPurchased(xid)) return AlexaMsg(playerid, "can not found vehicle");
    new price = PersonalVehicle:GetPrice(xid);
    if (GetPlayerCash(playerid) < price) return AlexaMsg(playerid, sprintf("you need $%s cash to load this vehicle", FormatCurrency(price)));
    new string[2000];
    strcat(string, "{FFFFFF}----------[ Vehicle Information ]----------\n\n");
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Vehicle Name: {FFFFFF}%s\n", PersonalVehicle:GetName(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Vehicle Price: {FFFFFF}$%s\n", FormatCurrency(PersonalVehicle:GetPrice(xid))));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Plate Number: {FFFFFF}%s\n", PersonalVehicle:GetPlate(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Driven: {FFFFFF}%.2f Kilometers\n", PersonalVehicle:GetKilometers(xid)));
    strcat(string, sprintf("{F0AE0F}  > {ECE913}Registation Date: {FFFFFF}%s\n", UnixToHumanEx(PersonalVehicle:GetRegistrationTime(xid))));
    return FlexPlayerDialog(
        playerid, "ConfirmVehConvertToCrate", DIALOG_STYLE_MSGBOX, "Confirm Purchase", string, "Purchase", "Close", trailerid, sprintf("%d", xid)
    );
}

FlexDialog:ConfirmVehConvertToCrate(playerid, response, listitem, const inputtext[], trailerid, const payload[]) {
    if (!response) return 1;
    new xid = strval(payload);
    if (!PersonalVehicle:IsValidID(xid) || PersonalVehicle:IsPurchased(xid)) return AlexaMsg(playerid, "can not found vehicle");
    new price = PersonalVehicle:GetPrice(xid);
    if (GetPlayerCash(playerid) < price) return AlexaMsg(playerid, sprintf("you need $%s cash to load this vehicle", FormatCurrency(price)));
    vault:PlayerVault(
        playerid, -price, sprintf("loaded vehicle %s with plate %s into trailer", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)),
        Vault_ID_Government, price, sprintf(
            "%s: loaded vehicle %s with plate %s into trailer", GetPlayerNameEx(playerid), PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid)
        )
    );
    new materialid = PersonalVehicle:MaterialItemID(xid);
    PersonalVehicleRemove(xid);
    TrailerStorage:SetResourceByShopId(trailerid, materialid, TrailerStorage:GetResourceByShopId(trailerid, materialid) + 1);
    AlexaMsg(playerid, "vehicle loaded in your trailer");
    return 1;
}

hook DTruckOnInit(playerid, trailerid, page) {
    if (page != 0 || Faction:GetPlayerFID(playerid) != FACTION_ID_SATD || !Faction:IsPlayerSigned(playerid) || GetVehicleModel(trailerid) != 435) return 1;
    new total = PersonalVehicle:GetNearestSaleCars(playerid);
    if (total) DTruck:AddCommand(playerid, "Load Personal Sale Cars");
    return 1;
}

hook DTruckOnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Load Personal Sale Cars", inputtext)) {
        PersonalVehicle:ConvertToCrate(playerid, trailerid);
        return ~1;
    }
    return 1;
}