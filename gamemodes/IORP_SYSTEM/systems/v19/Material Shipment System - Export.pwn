//#region dialog
enum { MaterialReselling:DialogOffsetMain, MaterialReselling:DialogOffsetInput }
new Iterator:matresellresources < Max_Material_Shipment > ;
new MaterialReselling:exchangeRate = 50;
//#endregion

//#region dialog
enum MaterialReselling:enumdata {
    MaterialReselling:PriceForEachQuantity,
    MaterialReselling:MaterialID,
    MaterialReselling:Title[100]
}
new MaterialReselling:data[Max_Material_Shipment][MaterialReselling:enumdata];
//#endregion dialog

//#region hooks
hook GlobalOneMinuteInterval() {
    MaterialReselling:exchangeRate = RandomEx(20, 30);
    return 1;
}

stock CanUseResellingMenu(playerid) {
    return IsTimePassedForPlayer(playerid, "IntervalForResellingUsage", 10 * 60);
}

hook OnPlayerConnect(playerid) {
    CanUseResellingMenu(playerid);
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 34) return 1;
    if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ~1;
    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetAllowedVehicleTrailerID(vehicleid);
    if (!IsVehicleAllowedForStorage(trailerid)) return ~1;
    MaterialReselling:menu(playerid, trailerid);
    return ~1;
}
//#endregion

//#region public
forward OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page);
public OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    MaterialReselling:menu(playerid, trailerid, page);
    return 1;
}
//#endregion

//#region stocks
stock MaterialReselling:GetExchangeRate() {
    return MaterialReselling:exchangeRate;
}

stock MaterialReselling:register(const Title[], materialid, priceforeachquantity) {
    new shipmentID = Iter_Free(matresellresources);
    if (shipmentID == -1) return 0;
    format(MaterialReselling:data[shipmentID][MaterialReselling:Title], 100, "%s", Title);
    MaterialReselling:data[shipmentID][MaterialReselling:PriceForEachQuantity] = priceforeachquantity;
    MaterialReselling:data[shipmentID][MaterialReselling:MaterialID] = materialid;
    Iter_Add(matresellresources, shipmentID);
    return shipmentID;
}

stock MaterialReselling:menu(playerid, trailerid, page = 0) {
    if (!IsValidVehicle(trailerid)) return 1;
    if (!IsVehicleAllowedForStorage(trailerid)) return 1;
    freezeEx(playerid, 3000);
    new string[2000];
    strcat(string, "ID\tMaterial\tIn trailer\tPrice per quantity\n");
    new total = Iter_Count(matresellresources);
    new perPage = 25;
    new paged = (page + 1) * perPage;
    new remaining = total - paged;
    new skip = page * perPage;
    new count = 0;
    for (new shipmentID; shipmentID < total; shipmentID++) {
        if (count >= perPage) break;
        if (skip > 0) {
            skip--;
            continue;
        }
        new materialid = MaterialReselling:data[shipmentID][MaterialReselling:MaterialID];
        new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, materialid);
        if (inTrailer > 0) {
            new marginPayout = GetPercentageOf(MaterialReselling:GetExchangeRate(), DynamicShopBusinessItem:GetItemDefaultPrice(materialid));
            strcat(string, sprintf(
                "%d\t%s\t%d\t$%s\n",
                shipmentID,
                MaterialReselling:data[shipmentID][MaterialReselling:Title],
                inTrailer,
                FormatCurrency(marginPayout)
            ));
            count++;
        }
    }
    if (count == 0) return SendClientMessage(playerid, -1, "{FF0000}[Alexa]:{FFFFFF} your trailer is empty, load resource to export it.");
    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    FlexPlayerDialog(playerid, "ResellingPointList", DIALOG_STYLE_TABLIST_HEADERS, "Material Export: List", string, "Select", "Close", page, sprintf("%d", trailerid));
    return 1;
}

FlexDialog:ResellingPointList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Next Page")) return MaterialReselling:menu(playerid, strval(payload), page + 1);
    if (IsStringSame(inputtext, "Back Page")) return MaterialReselling:menu(playerid, strval(payload), page - 1);
    return ResellingPointUnload(playerid, page, strval(payload), strval(inputtext));
}

stock ResellingPointUnload(playerid, page, trailerid, shipmentID) {
    new materialid = MaterialReselling:data[shipmentID][MaterialReselling:MaterialID];
    new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, materialid);
    return FlexPlayerDialog(playerid, "ResellingPointUnload", DIALOG_STYLE_INPUT, "Material Export: How much?",
        sprintf(
            "Enter quantity of resource to export\nLimit: 1 to %d", inTrailer
        ),
        "Submit", "Close", page, sprintf("%d %d", trailerid, shipmentID)
    );
}

FlexDialog:ResellingPointUnload(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new shipmentID, trailerid, quantity;
    sscanf(payload, "d d", trailerid, shipmentID);
    if (!response) return MaterialReselling:menu(playerid, trailerid, page);

    new materialid = MaterialReselling:data[shipmentID][MaterialReselling:MaterialID];
    new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, materialid);

    if (sscanf(inputtext, "d", quantity) || quantity < 1 || quantity > inTrailer)
        return ResellingPointUnload(playerid, page, trailerid, shipmentID);

    if (!CanUseResellingMenu(playerid)) {
        AlexaMsg(playerid, "{4286f4}your export request has been declined, our ship is not returned yet on dock.", "Shipment Dock");
        AlexaMsg(playerid, sprintf(
            "{4286f4}please try after %s",
            UnixToHumanEx(GetLastTimeForPlayer(playerid, "IntervalForResellingUsage") + 10 * 60)
        ));
        return 1;
    }
    return CallRemoteFunction("OnRequestResourceExport", "ddddd", playerid, shipmentID, trailerid, quantity, page);
}

//#endregion