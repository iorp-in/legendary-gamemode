#define Resource_TrailerIncrease 100
#define Resource_ScoreRequired 250
#define Resource_ArrivalInSeconds 30
#define Resource_MinOrder 1
#define Resource_MaxOrder 10
#define Resource_ItemsCount 32
new Resource_ItemsID[Resource_ItemsCount] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
new Resource_ShipmentID[Resource_ItemsCount];
new Resource_ShipmentFee[Resource_ItemsCount];
new Resource_ExportID[Resource_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < Resource_ItemsCount; i++) {
        // pre
        new shopId = Resource_ItemsID[i];
        new trailerIncrease = Resource_TrailerIncrease;
        new scoreRequired = Resource_ScoreRequired;
        new arrivalSeconds = Resource_ArrivalInSeconds;
        new minOrder = Resource_MinOrder;
        new maxOrder = Resource_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId) * Resource_TrailerIncrease;
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Resource: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Resource: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Resource: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        Resource_ShipmentFee[i] = fee;
        Resource_ShipmentID[i] = shipmentId;
        Resource_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < Resource_ItemsCount; i++) {
        if (Resource_ExportID[i] == shipmentID) {
            new shopItemId = Resource_ItemsID[i];
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
            vault:PlayerVault(
                playerid, marginPayout, sprintf(
                    "sold %d quantity of Resource: %s",
                    quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
                ),
                Vault_ID_Government, -marginPayout, sprintf(
                    "%s sold %d quantity of Resource: %s",
                    GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
                )
            );

            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < Resource_ItemsCount; i++) {
        if (shipmentID == Resource_ShipmentID[i]) {
            new shopItemId = Resource_ItemsID[i];
            new payment = quantity * Resource_ShipmentFee[i];
            if (GetPlayerCash(playerid) < payment) {
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

            vault:PlayerVault(playerid, -payment, sprintf(
                "%s shipment order fee for quantity %d",
                DynamicShopBusinessItem:GetItemName(shopItemId), quantity
            ), Vault_ID_Government, payment, sprintf(
                "%s paid %s shipment fee for quantity %d",
                GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < Resource_ItemsCount; i++) {
        new shopItemId = Resource_ItemsID[i];
        new trailerItemId = TrailerStorage:GetIdFromShopItemID(shopItemId);
        if (trailerItemId == -1 || trailerItemId != Crate:GetTrailerItemId(crateId)) continue;

        new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
        if (inTrailer >= TrailerStorage:GetResourceLimit(trailerItemId)) {
            AlexaMsg(playerid, "There is not enough space in the trailer");
            return ~1;
        }

        if (inTrailer == 0 && TrailerStorage:GetResourceTypesLoaded(trailerid) >= 8) {
            AlexaMsg(playerid, "There is not enough space in the trailer");
            return ~1;
        }

        TrailerStorage:IncreaseResource(trailerid, trailerItemId, Crate:GetTrailerItemQuantity(crateId));
        SendClientMessage(playerid, -1, sprintf(
            "{4286f4}[Alexa]:{FFFFFF} %d %s of %s has been loaded into trailer.",
            Crate:GetTrailerItemQuantity(crateId),
            DynamicShopBusinessItem:GetItemUnit(shopItemId),
            DynamicShopBusinessItem:GetItemName(shopItemId)
        ));
        break;
    }
    return 1;
}