#define VehicleTypeBoat_TrailerIncrease 1
#define VehicleTypeBoat_ScoreRequired 25
#define VehicleTypeBoat_ArrivalInSeconds 90
#define VehicleTypeBoat_MinOrder 1
#define VehicleTypeBoat_MaxOrder 10
#define VehicleTypeBoat_ItemsCount 11
new VehicleTypeBoat_ItemsID[VehicleTypeBoat_ItemsCount] = { 387, 403, 409, 410, 411, 429, 430, 441, 450, 496, 552 };
new VehicleTypeBoat_ShipmentID[VehicleTypeBoat_ItemsCount];
new VehicleTypeBoat_ShipmentFee[VehicleTypeBoat_ItemsCount];
new VehicleTypeBoat_ExportID[VehicleTypeBoat_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < VehicleTypeBoat_ItemsCount; i++) {
        // pre
        new shopId = VehicleTypeBoat_ItemsID[i];
        new trailerIncrease = VehicleTypeBoat_TrailerIncrease;
        new scoreRequired = VehicleTypeBoat_ScoreRequired;
        new arrivalSeconds = VehicleTypeBoat_ArrivalInSeconds;
        new minOrder = VehicleTypeBoat_MinOrder;
        new maxOrder = VehicleTypeBoat_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Vehicle Type Boat: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Vehicle Type Boat: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Vehicle Type Boat: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        VehicleTypeBoat_ShipmentFee[i] = fee;
        VehicleTypeBoat_ShipmentID[i] = shipmentId;
        VehicleTypeBoat_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < VehicleTypeBoat_ItemsCount; i++) {
        if (shipmentID == VehicleTypeBoat_ShipmentID[i]) {
            if (PersonalVehicle:GetTotalVehicleOnSale() > 15) {
                AlexaMsg(playerid, "we are not accepting orders because there are more than 15 vehicles on sale");
                return ~1;
            }

            if (GetPlayerCash(playerid) < quantity * VehicleTypeBoat_ShipmentFee[i]) {
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

            vault:PlayerVault(
                playerid, -quantity * VehicleTypeBoat_ShipmentFee[i], sprintf(
                    "%s shipment order fee for quantity %d",
                    DynamicShopBusinessItem:GetItemName(VehicleTypeBoat_ItemsID[i]), quantity
                ), Vault_ID_Government, quantity * VehicleTypeBoat_ShipmentFee[i], sprintf(
                    "%s paid %s shipment fee for quantity %d",
                    GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(VehicleTypeBoat_ItemsID[i]), quantity
                )
            );
            return ~1;
        }
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < VehicleTypeBoat_ItemsCount; i++) {
        if (VehicleTypeBoat_ExportID[i] == shipmentID) {
            new shopItemId = VehicleTypeBoat_ItemsID[i];
            new inTrailer = TrailerStorage:GetResourceByShopId(trailerid, shopItemId);
            if (quantity < 0 || quantity > inTrailer) {
                return AlexaMsg(playerid, "The trailer doesn't have the given amount of resources");
            }

            new payout = quantity * DynamicShopBusinessItem:GetItemDefaultPrice(shopItemId);
            new marginPayout = GetPercentageOf(MaterialReselling:GetExchangeRate(), payout);
            if (marginPayout > payout) return AlexaMsg(playerid, "Currently, the market is down, please try again later");
            TrailerStorage:SetResourceByShopId(trailerid, shopItemId, inTrailer - quantity);
            vault:PlayerVault(playerid, marginPayout, sprintf(
                    "sold %d quantity of Vehicle Type Boat: %s",
                    quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
                ),
                Vault_ID_Government, -marginPayout, sprintf(
                    "%s sold %d quantity of Vehicle Type Boat: %s",
                    GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
                )
            );

            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < VehicleTypeBoat_ItemsCount; i++) {
        new shopItemId = VehicleTypeBoat_ItemsID[i];
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
            Crate:GetTrailerItemQuantity(crateId),
            DynamicShopBusinessItem:GetItemUnit(shopItemId),
            DynamicShopBusinessItem:GetItemName(shopItemId)
        ));
        break;
    }
    return 1;
}