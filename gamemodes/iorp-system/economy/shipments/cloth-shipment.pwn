#define ShopCloth_TrailerIncrease 1
#define ShopCloth_ScoreRequired 25
#define ShopCloth_ArrivalInSeconds 30
#define ShopCloth_MinOrder 1
#define ShopCloth_MaxOrder 10
#define ShopCloth_ItemsCount 271
new ShopCloth_ItemsID[ShopCloth_ItemsCount] = { 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356 };
new ShopCloth_ShipmentID[ShopCloth_ItemsCount];
new ShopCloth_ShipmentFee[ShopCloth_ItemsCount];
new ShopCloth_ExportID[ShopCloth_ItemsCount];

hook OnGameModeInit() {
    for (new i; i < ShopCloth_ItemsCount; i++) {
        // pre
        new shopId = ShopCloth_ItemsID[i];
        new trailerIncrease = ShopCloth_TrailerIncrease;
        new scoreRequired = ShopCloth_ScoreRequired;
        new arrivalSeconds = ShopCloth_ArrivalInSeconds;
        new minOrder = ShopCloth_MinOrder;
        new maxOrder = ShopCloth_MaxOrder;

        // main
        new fee = DynamicShopBusinessItem:GetItemDefaultPrice(shopId);
        fee = GetPercentageOf(60, fee);
        if (fee < 1) fee = 1;
        new shipmentId = Shipment:register(
            sprintf("Cloth Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            minOrder, maxOrder, fee, scoreRequired, arrivalSeconds, trailerIncrease, shopId
        );

        new exportId = MaterialReselling:register(
            sprintf("Cloth Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            shopId, DynamicShopBusinessItem:GetItemDefaultPrice(shopId)
        );

        Crate:uRegister(
            sprintf("Cloth Item: %s", DynamicShopBusinessItem:GetItemName(shopId)),
            TrailerStorage:GetIdFromShopItemID(shopId), trailerIncrease
        );

        // post
        ShopCloth_ShipmentFee[i] = fee;
        ShopCloth_ShipmentID[i] = shipmentId;
        ShopCloth_ExportID[i] = exportId;
    }
    return 1;
}

hook OnRequestShipment(playerid, shipmentID, quantity) {
    for (new i; i < ShopCloth_ItemsCount; i++) {
        if (shipmentID == ShopCloth_ShipmentID[i]) {
            if (GetPlayerCash(playerid) < quantity * ShopCloth_ShipmentFee[i]) {
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

            vault:PlayerVault(playerid, -quantity * ShopCloth_ShipmentFee[i], sprintf(
                "%s shipment order fee for quantity %d",
                DynamicShopBusinessItem:GetItemName(ShopCloth_ItemsID[i]), quantity
            ), Vault_ID_Government, quantity * ShopCloth_ShipmentFee[i], sprintf(
                "%s paid %s shipment fee for quantity %d",
                GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(ShopCloth_ItemsID[i]), quantity
            ));
            return ~1;
        }
    }
    return 1;
}

hook OnRequestResourceExport(playerid, shipmentID, trailerid, quantity, page) {
    for (new i; i < ShopCloth_ItemsCount; i++) {
        if (ShopCloth_ExportID[i] == shipmentID) {
            new shopItemId = ShopCloth_ItemsID[i];
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
            vault:PlayerVault(playerid, marginPayout, sprintf(
                "sold %d quantity of Cloth Item: %s",
                quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
            ), Vault_ID_Government, -marginPayout, sprintf(
                "%s sold %d quantity of Cloth Item: %s",
                GetPlayerNameEx(playerid), quantity, DynamicShopBusinessItem:GetItemName(shopItemId)
            ));

            AlexaMsg(playerid, sprintf("your shipment worth $%s", FormatCurrency(marginPayout)));
            return 1;
        }
    }
    return 1;
}

hook OnTrailerLoadShipment(playerid, forkliftVehID, trailerid, crateId) {
    for (new i; i < ShopCloth_ItemsCount; i++) {
        new shopItemId = ShopCloth_ItemsID[i];
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