#define Electrical_TrailerIncrease 1
#define Electrical_ScoreRequired 25
#define Electrical_ArrivalInSeconds 30
#define Electrical_MinOrder 1
#define Electrical_MaxOrder 10
#define Electrical_ItemsCount 7
new Electrical_ItemsID[Electrical_ItemsCount] = { 32, 33, 34, 35, 36, 37, 38 };
new Electrical_ShipmentID[Electrical_ItemsCount];
new Electrical_ShipmentFee[Electrical_ItemsCount];
new Electrical_ExportID[Electrical_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < Electrical_ItemsCount; i++) {
        // pre
        new shopId = Electrical_ItemsID[i];
        new trailerIncrease = Electrical_TrailerIncrease;
        new scoreRequired = Electrical_ScoreRequired;
        new arrivalSeconds = Electrical_ArrivalInSeconds;
        new minOrder = Electrical_MinOrder;
        new maxOrder = Electrical_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Electrical Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Electrical Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Electrical Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        Electrical_ShipmentFee[i] = fee;
        Electrical_ShipmentID[i] = shipmentId;
        Electrical_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < Electrical_ItemsCount; i++) {
        if (Electrical_ExportID[i] == shipmentID) {
            new shopItemId = Electrical_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Electrical Item: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Electrical Item: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < Electrical_ItemsCount; i++) {
        if (shipmentID == Electrical_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * Electrical_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * Electrical_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(Electrical_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * Electrical_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(Electrical_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < Electrical_ItemsCount; i++) {
        new shopItemId = Electrical_ItemsID[i];
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