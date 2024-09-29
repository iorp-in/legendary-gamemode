#define VehicleTypeHeavy_TrailerIncrease 1
#define VehicleTypeHeavy_ScoreRequired 25
#define VehicleTypeHeavy_ArrivalInSeconds 90
#define VehicleTypeHeavy_MinOrder 1
#define VehicleTypeHeavy_MaxOrder 10
#define VehicleTypeHeavy_ItemsCount 40
new VehicleTypeHeavy_ItemsID[VehicleTypeHeavy_ItemsCount] = { 360, 363, 364, 365, 371, 384, 385, 388, 389, 390, 394, 400, 401, 412, 413, 443, 455, 456, 465, 471, 472, 481, 501, 513, 514, 530, 535, 545, 558, 392, 406, 407, 458, 494, 495, 526, 527, 541, 547, 548 };
new VehicleTypeHeavy_ShipmentID[VehicleTypeHeavy_ItemsCount];
new VehicleTypeHeavy_ShipmentFee[VehicleTypeHeavy_ItemsCount];
new VehicleTypeHeavy_ExportID[VehicleTypeHeavy_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < VehicleTypeHeavy_ItemsCount; i++) {
        // pre
        new shopId = VehicleTypeHeavy_ItemsID[i];
        new trailerIncrease = VehicleTypeHeavy_TrailerIncrease;
        new scoreRequired = VehicleTypeHeavy_ScoreRequired;
        new arrivalSeconds = VehicleTypeHeavy_ArrivalInSeconds;
        new minOrder = VehicleTypeHeavy_MinOrder;
        new maxOrder = VehicleTypeHeavy_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Vehicle Type Heavy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Vehicle Type Heavy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Vehicle Type Heavy: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        VehicleTypeHeavy_ShipmentFee[i] = fee;
        VehicleTypeHeavy_ShipmentID[i] = shipmentId;
        VehicleTypeHeavy_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < VehicleTypeHeavy_ItemsCount; i++) {
        if (VehicleTypeHeavy_ExportID[i] == shipmentID) {
            new shopItemId = VehicleTypeHeavy_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Vehicle Type Heavy: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Vehicle Type Heavy: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < VehicleTypeHeavy_ItemsCount; i++) {
        if (shipmentID == VehicleTypeHeavy_ShipmentID[i]) {
            if (PersonalVehicle:GetTotalVehicleOnSale() > 15) {
                AlexaMsg(playerid, "we are not accepting orders because there are more than 15 vehicles on sale");
                return ~1;
            }

            if (GetPlayerCash(playerid) < quantity * VehicleTypeHeavy_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * VehicleTypeHeavy_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(VehicleTypeHeavy_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * VehicleTypeHeavy_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(VehicleTypeHeavy_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < VehicleTypeHeavy_ItemsCount; i++) {
        new shopItemId = VehicleTypeHeavy_ItemsID[i];
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