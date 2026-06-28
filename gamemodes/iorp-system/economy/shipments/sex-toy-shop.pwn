#define SexToy_TrailerIncrease 1
#define SexToy_ScoreRequired 25
#define SexToy_ArrivalInSeconds 30
#define SexToy_MinOrder 1
#define SexToy_MaxOrder 10
#define SexToy_ItemsCount 5
new SexToy_ItemsID[SexToy_ItemsCount] = { 81, 82, 83, 84, 85 };
new SexToy_ShipmentID[SexToy_ItemsCount];
new SexToy_ShipmentFee[SexToy_ItemsCount];
new SexToy_ExportID[SexToy_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < SexToy_ItemsCount; i++) {
        // pre
        new shopId = SexToy_ItemsID[i];
        new trailerIncrease = SexToy_TrailerIncrease;
        new scoreRequired = SexToy_ScoreRequired;
        new arrivalSeconds = SexToy_ArrivalInSeconds;
        new minOrder = SexToy_MinOrder;
        new maxOrder = SexToy_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Sex Toy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Sex Toy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Sex Toy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        SexToy_ShipmentFee[i] = fee;
        SexToy_ShipmentID[i] = shipmentId;
        SexToy_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < SexToy_ItemsCount; i++) {
        if (SexToy_ExportID[i] == shipmentID) {
            new shopItemId = SexToy_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Sex Toy: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Sex Toy: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < SexToy_ItemsCount; i++) {
        if (shipmentID == SexToy_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * SexToy_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * SexToy_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(SexToy_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * SexToy_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(SexToy_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < SexToy_ItemsCount; i++) {
        new shopItemId = SexToy_ItemsID[i];
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