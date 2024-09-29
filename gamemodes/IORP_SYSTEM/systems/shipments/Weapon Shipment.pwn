#define WeaponItem_TrailerIncrease 1
#define WeaponItem_ScoreRequired 25
#define WeaponItem_ArrivalInSeconds 30
#define WeaponItem_MinOrder 1
#define WeaponItem_MaxOrder 10
#define WeaponItem_ItemsCount 33
new WeaponItem_ItemsID[WeaponItem_ItemsCount] = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80 };
new WeaponItem_ShipmentID[WeaponItem_ItemsCount];
new WeaponItem_ShipmentFee[WeaponItem_ItemsCount];
new WeaponItem_ExportID[WeaponItem_ItemsCount];

stock WeaponItem_GetLimit(shopid) {
    switch (shopid) {
        case 61, 62, 63, 67, 68, 69, 70, 71, 75 : return 100;
        case 64, 65, 66, 72, 73, 74, 77, 78, 79, 80 : return 25;
    }
    return 1;
}

hook OnGameModeInit() {
    for (new i; i < WeaponItem_ItemsCount; i++) {
        // pre
        new shopId = WeaponItem_ItemsID[i];
        new trailerIncrease = WeaponItem_TrailerIncrease * WeaponItem_GetLimit(shopId);
        new scoreRequired = WeaponItem_ScoreRequired;
        new arrivalSeconds = WeaponItem_ArrivalInSeconds * WeaponItem_GetLimit(shopId);
        new minOrder = WeaponItem_MinOrder;
        new maxOrder = WeaponItem_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId) * WeaponItem_GetLimit(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Weapon: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Weapon: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Weapon: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        WeaponItem_ShipmentFee[i] = fee;
        WeaponItem_ShipmentID[i] = shipmentId;
        WeaponItem_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < WeaponItem_ItemsCount; i++) {
        if (WeaponItem_ExportID[i] == shipmentID) {
            new shopItemId = WeaponItem_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Weapon: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Weapon: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < WeaponItem_ItemsCount; i++) {
        if (shipmentID == WeaponItem_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * WeaponItem_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * WeaponItem_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(WeaponItem_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * WeaponItem_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(WeaponItem_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < WeaponItem_ItemsCount; i++) {
        new shopItemId = WeaponItem_ItemsID[i];
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