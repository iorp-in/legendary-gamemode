#define Firework_TrailerIncrease 1
#define Firework_ScoreRequired 25
#define Firework_ArrivalInSeconds 30
#define Firework_MinOrder 1
#define Firework_MaxOrder 10
#define Firework_ItemsCount 4
new Firework_ItemsID[Firework_ItemsCount] = { 44, 45, 46, 47 };
new Firework_ShipmentID[Firework_ItemsCount];
new Firework_ShipmentFee[Firework_ItemsCount];
new Firework_ExportID[Firework_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < Firework_ItemsCount; i++) {
        // pre
        new shopId = Firework_ItemsID[i];
        new trailerIncrease = Firework_TrailerIncrease;
        new scoreRequired = Firework_ScoreRequired;
        new arrivalSeconds = Firework_ArrivalInSeconds;
        new minOrder = Firework_MinOrder;
        new maxOrder = Firework_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Firework Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Firework Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Firework Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        Firework_ShipmentFee[i] = fee;
        Firework_ShipmentID[i] = shipmentId;
        Firework_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < Firework_ItemsCount; i++) {
        if (Firework_ExportID[i] == shipmentID) {
            new shopItemId = Firework_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Firework Item: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Firework Item: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < Firework_ItemsCount; i++) {
        if (shipmentID == Firework_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * Firework_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * Firework_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(Firework_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * Firework_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(Firework_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < Firework_ItemsCount; i++) {
        new shopItemId = Firework_ItemsID[i];
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