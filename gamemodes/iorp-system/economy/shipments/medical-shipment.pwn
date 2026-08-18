#define Medical_TrailerIncrease 1
#define Medical_ScoreRequired 25
#define Medical_ArrivalInSeconds 30
#define Medical_MinOrder 1
#define Medical_MaxOrder 10
#define Medical_ItemsCount 5
new Medical_ItemsID[Medical_ItemsCount] = { 39, 40, 41, 42, 43 };
new Medical_ShipmentID[Medical_ItemsCount];
new Medical_ShipmentFee[Medical_ItemsCount];
new Medical_ExportID[Medical_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < Medical_ItemsCount; i++) {
        // pre
        new shopId = Medical_ItemsID[i];
        new trailerIncrease = Medical_TrailerIncrease;
        new scoreRequired = Medical_ScoreRequired;
        new arrivalSeconds = Medical_ArrivalInSeconds;
        new minOrder = Medical_MinOrder;
        new maxOrder = Medical_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Medicine Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Medicine Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Medicine Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        Medical_ShipmentFee[i] = fee;
        Medical_ShipmentID[i] = shipmentId;
        Medical_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < Medical_ItemsCount; i++) {
        if (Medical_ExportID[i] == shipmentID) {
            new shopItemId = Medical_ItemsID[i];
            new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
            if (quantity < 0 || quantity > inTrailer) {
                return AlexaMsg(playerid, "The trailer doesn't have the given amount of resources");
            }

            new payout = quantity * DynamicShopBusinessItem:GetItemDefaultPrice(shopItemId);
            new marginPayout = GetPercentageOf(MaterialReselling:GetExchangeRate(), payout);
            if (marginPayout > payout) {
                return AlexaMsg(playerid, "Currently, the market is down, please try again later");
            }

            TrailerStorage:SetResourceByShopId(trailerid, shopItemId, inTrailer - quantity);
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Medicine Item: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Medicine Item: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < Medical_ItemsCount; i++) {
        if (shipmentID == Medical_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * Medical_ShipmentFee[i]) {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you don't have enough money to make this order");
                return ~1;
            }

            if (!PlaceShipment(playerid, shipmentID, quantity)) {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} failed to place order for your request.");
                return ~1;
            }

            AlexaMsg(playerid, sprintf(
                "order placed for your requested item. Quantity: %d Crate", quantity
            ));

            vault:PlayerVault(playerid, -quantity * Medical_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(Medical_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * Medical_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(Medical_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < Medical_ItemsCount; i++) {
        new shopItemId = Medical_ItemsID[i];
        new trailerItemId = TrailerStorage:GetIdFromShopItemID(shopItemId);
        if (trailerItemId == -1 || trailerItemId != Crate:GetTrailerItemId(crateId)) {
            continue;
        }

        new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
        if (inTrailer >= TrailerStorage:GetResourceLimit(trailerItemId)) {
            AlexaMsg(playerid, "There is not enough space in the trailer");
            return ~1;
        }

        if (inTrailer == 0 && TrailerStorage:GetResourceTypesLoaded(trailerid) >= 5) {
            AlexaMsg(playerid, "There is not enough space in the trailer");
            return ~1;
        }

        TrailerStorage:IncreaseResource(trailerid, trailerItemId, Crate:GetTrailerItemQuantity(crateId));
        SendClientMessage(playerid, -1, sprintf(
            "{4286f4}[Alexa]:{FFFFFF} %d %s of %s has been loaded into trailer.",
            Crate:GetTrailerItemQuantity(crateId), DynamicShopBusinessItem:GetItemUnit(shopItemId), DynamicShopBusinessItem:GetItemName(shopItemId)
        ));
        break;
    }
    return 1;
}