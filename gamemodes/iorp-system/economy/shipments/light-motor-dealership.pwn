#define VehicleTypeLight_TrailerIncrease 1
#define VehicleTypeLight_ScoreRequired 25
#define VehicleTypeLight_ArrivalInSeconds 90
#define VehicleTypeLight_MinOrder 1
#define VehicleTypeLight_MaxOrder 10
#define VehicleTypeLight_ItemsCount 117
new VehicleTypeLight_ItemsID[VehicleTypeLight_ItemsCount] = { 357, 358, 359, 361, 362, 366, 367, 368, 369, 370, 372, 373, 375, 376, 377, 378, 379, 380, 381, 383, 386, 391, 393, 395, 396, 397, 399, 402, 408, 414, 415, 416, 423, 424, 427, 428, 431, 432, 434, 435, 436, 437, 439, 440, 442, 446, 447, 449, 451, 452, 453, 457, 459, 460, 461, 462, 463, 464, 473, 474, 475, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 497, 498, 499, 500, 502, 503, 504, 506, 507, 508, 509, 511, 512, 515, 516, 517, 518, 519, 522, 523, 524, 525, 528, 529, 531, 532, 533, 536, 537, 539, 540, 542, 544, 546, 553, 554, 555, 556, 557, 559, 560, 561, 562, 566 };
new VehicleTypeLight_ShipmentID[VehicleTypeLight_ItemsCount];
new VehicleTypeLight_ShipmentFee[VehicleTypeLight_ItemsCount];
new VehicleTypeLight_ExportID[VehicleTypeLight_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < VehicleTypeLight_ItemsCount; i++) {
        // pre
        new shopId = VehicleTypeLight_ItemsID[i];
        new trailerIncrease = VehicleTypeLight_TrailerIncrease;
        new scoreRequired = VehicleTypeLight_ScoreRequired;
        new arrivalSeconds = VehicleTypeLight_ArrivalInSeconds;
        new minOrder = VehicleTypeLight_MinOrder;
        new maxOrder = VehicleTypeLight_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Vehicle Type Light: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Vehicle Type Light: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Vehicle Type Light: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        VehicleTypeLight_ShipmentFee[i] = fee;
        VehicleTypeLight_ShipmentID[i] = shipmentId;
        VehicleTypeLight_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < VehicleTypeLight_ItemsCount; i++) {
        if (VehicleTypeLight_ExportID[i] == shipmentID) {
            new shopItemId = VehicleTypeLight_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf("sold %d quantity of Vehicle Type Helicopter: %s", quantity, DynamicShopBusinessItem:GetItemName(shopItemId)), Vault_ID_Government, -marginPayout, sprintf("%s sold %d quantity of Vehicle Type Helicopter: %s", GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)));
            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < VehicleTypeLight_ItemsCount; i++) {
        if (shipmentID == VehicleTypeLight_ShipmentID[i]) {
            if (PersonalVehicle:GetTotalVehicleOnSale() > 15) {
                AlexaMsg(playerid, "we are not accepting orders because there are more than 15 vehicles on sale");
                return ~1;
            }

            if (GetPlayerCash(playerid) < quantity * VehicleTypeLight_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * VehicleTypeLight_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d", DynamicShopBusinessItem:GetItemName(VehicleTypeLight_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * VehicleTypeLight_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(VehicleTypeLight_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < VehicleTypeLight_ItemsCount; i++) {
        new shopItemId = VehicleTypeLight_ItemsID[i];
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