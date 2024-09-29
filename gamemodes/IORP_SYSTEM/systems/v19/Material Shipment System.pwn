#define Max_Material_Shipment 2000
#define Max_ShipmentQueue 10
#define MAX_Shipment_Loc_Slot 3

new Float:Shipment:Locations[MAX_Shipment_Loc_Slot][3] = {
    { 2760.00, -2360.00, 13.63 },
    {-1547.00, 28.00, 17.32 },
    { 2760.00, -2360.00, 13.63 }
};

stock Shipment:GetClosestSlot(playerid) {
    new id, Float:tempdist[MAX_Shipment_Loc_Slot], i, Float:first;
    for (i = 0; i < MAX_Shipment_Loc_Slot; i++) {
        tempdist[i] = GetPlayerDistanceFromPoint(playerid, Shipment:Locations[i][0], Shipment:Locations[i][1], Shipment:Locations[i][2]);
        if (i == 0) first = tempdist[i], id = i;
        if (tempdist[i] < first) first = tempdist[i], id = i;
    }
    return id;
}

enum Shipment:DataEnum {
    Shipment:Title[100],
        Shipment:ShopItemId,
        Shipment:PerCrateQuantity,
        Shipment:OrderMin,
        Shipment:OrderMax,
        Shipment:OrderPrice,
        Shipment:Score,
        Shipment:ETA
}

new Shipment:Data[Max_Material_Shipment][Shipment:DataEnum];

new Iterator:shipments < Max_Material_Shipment > ;
new Iterator:shipmentqueues < Max_ShipmentQueue > ;

enum Shipment:qEnum {
    bool:Shipment:IsInQueue,
    Shipment:qPlacedAt,
    Shipment:qProcessAt,
    Shipment:qShipmentId,
    Shipment:orderQuantity,
    Shipment:locationSlot,
    Shipment:qPlacedBy[100]
}
new Shipment:qData[Max_ShipmentQueue][Shipment:qEnum];

hook GlobalOneMinuteInterval() {
    Shipment:ProcessQueue();
    return 1;
}

stock Shipment:register(const Title[], minquantity, maxquantity, priceforeachquantity, scorerequired, shipmentarrival, PerCrateQuantity = 1, shopItemId) {
    new shipmentID = Iter_Free(shipments);
    if (shipmentID == INVALID_ITERATOR_SLOT) return 0;
    format(Shipment:Data[shipmentID][Shipment:Title], 100, "%s", Title);
    Shipment:Data[shipmentID][Shipment:ShopItemId] = shopItemId;
    Shipment:Data[shipmentID][Shipment:PerCrateQuantity] = PerCrateQuantity;
    Shipment:Data[shipmentID][Shipment:OrderMin] = minquantity;
    Shipment:Data[shipmentID][Shipment:OrderMax] = maxquantity;
    Shipment:Data[shipmentID][Shipment:Score] = scorerequired;
    Shipment:Data[shipmentID][Shipment:OrderPrice] = priceforeachquantity;
    Shipment:Data[shipmentID][Shipment:ETA] = shipmentarrival;
    Iter_Add(shipments, shipmentID);
    return shipmentID;
}

stock Shipment:IsValidID(shipmentID) {
    if (Iter_Contains(shipments, shipmentID)) return 1;
    return 0;
}

stock Shipment:GetTitle(shipmentID) {
    new string[100];
    format(string, sizeof string, "%s", Shipment:Data[shipmentID][Shipment:Title]);
    return string;
}

stock Shipment:GetShopId(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:ShopItemId];
}

stock Shipment:GetPerItemUnit(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:PerCrateQuantity];
}

stock Shipment:GetMinQuantity(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:OrderMin];
}

stock Shipment:GetMaxQuantity(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:OrderMax];
}

stock Shipment:GetScoreRequired(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:Score];
}

stock Shipment:GetPrice(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:OrderPrice];
}

stock Shipment:GetETA(shipmentID) {
    return Shipment:Data[shipmentID][Shipment:ETA];
}

stock Shipment:Menu(playerid) {
    new string[512];
    strcat(string, "Order Shipment\n");
    strcat(string, "Check Order Status\n");
    return FlexPlayerDialog(
        playerid, "ShipmentOrderMenu", DIALOG_STYLE_LIST,
        "Material Shipment: Menu", "Order Shipment\nCheck Order Status",
        "Select", "Close"
    );
}

FlexDialog:ShipmentOrderMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Order Shipment")) return Shipment:MakeOrderCat(playerid);
    if (IsStringSame(inputtext, "Check Order Status")) return Shipment:CheckOrderInput(playerid);
    return 1;
}

stock Shipment:CheckOrderInput(playerid) {
    return FlexPlayerDialog(
        playerid, "ShipmentCheckOrderInput", DIALOG_STYLE_INPUT, "Shipment: Check Order",
        "Enter Order ID\nyou have given order id, when you placed your order. There is no other way to find it.",
        "Submit", "Close"
    );
}

FlexDialog:ShipmentCheckOrderInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Shipment:Menu(playerid);
    new orderid = -1;
    if (sscanf(inputtext, "d", orderid) || !Shipment:QueueIsValidID(orderid)) return Shipment:CheckOrderInput(playerid);
    Shipment:OrderStatus(playerid, orderid);
    return 1;
}

stock Shipment:OrderStatus(playerid, queueId) {
    new etaTime[100], etaTimeInSeconds = Shipment:qData[queueId][Shipment:qProcessAt] + (Shipment:qData[queueId][Shipment:orderQuantity] * Shipment:GetETA(Shipment:qData[queueId][Shipment:qShipmentId]));
    UnixToHuman(etaTimeInSeconds, etaTime);
    new string[512];
    strcat(string, sprintf("Shipment: %s\n", Shipment:GetTitle(Shipment:qData[queueId][Shipment:qShipmentId])));
    strcat(string, sprintf("ordered quantity: %d\n", Shipment:qData[queueId][Shipment:orderQuantity]));
    strcat(string, sprintf("total price: %d\n", Shipment:qData[queueId][Shipment:orderQuantity] * Shipment:GetPrice(Shipment:qData[queueId][Shipment:qShipmentId])));
    strcat(string, sprintf("Status: %s\n", Shipment:qData[queueId][Shipment:IsInQueue] ? "In Queue" : "On the way to dock"));
    strcat(string, sprintf("Placed By: %s\n", Shipment:qData[queueId][Shipment:qPlacedBy]));
    strcat(string, sprintf("ETA: %s\n", etaTime));
    FlexPlayerDialog(playerid, "ShipmentOrderStatus", DIALOG_STYLE_MSGBOX, "Material Shipment: Order Status", string, "", "Close");
    return 1;
}

FlexDialog:ShipmentOrderStatus(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    Shipment:Menu(playerid);
    return 1;
}

stock PlaceShipment(playerid, shipmentID, quantity) {
    new queueId = Iter_Free(shipmentqueues);
    if (queueId == INVALID_ITERATOR_SLOT) {
        AlexaMsg(playerid, "we have already lots of shipment request in progress, try again", "Shipment");
        return 0;
    }

    Iter_Add(shipmentqueues, queueId);
    format(Shipment:qData[queueId][Shipment:qPlacedBy], 100, "%s", GetPlayerNameEx(playerid));
    Shipment:qData[queueId][Shipment:IsInQueue] = true;
    Shipment:qData[queueId][Shipment:qPlacedAt] = gettime();
    Shipment:qData[queueId][Shipment:qProcessAt] = gettime();
    Shipment:qData[queueId][Shipment:qShipmentId] = shipmentID;
    Shipment:qData[queueId][Shipment:orderQuantity] = quantity;
    Shipment:qData[queueId][Shipment:locationSlot] = Shipment:GetClosestSlot(playerid);
    new etaTime[100], etaTimeInSeconds = Shipment:qData[queueId][Shipment:qPlacedAt] + (quantity * Shipment:GetETA(shipmentID));
    UnixToHuman(etaTimeInSeconds, etaTime);

    if (IsPlayerConnected(playerid)) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shipment]:{FFCC66} your order has been placed for shipment of %s", Shipment:GetTitle(shipmentID)));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shipment]:{FFCC66} your order ID: %d", queueId));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shipment]:{FFCC66} your order ETA: %s", etaTime));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shipment]:{FFCC66} remember your order id, to check status", etaTime));
    }

    Shipment:Menu(playerid);
    return 1;
}

stock IsAnyShipmentInQueue() {
    foreach(new queueId:shipmentqueues) {
        if (Shipment:qData[queueId][Shipment:IsInQueue] == false) {
            return 1;
        }
    }
    return 0;
}

stock GetQueueShipmentID() {
    foreach(new queueId:shipmentqueues) {
        if (Shipment:qData[queueId][Shipment:IsInQueue] == false) {
            return queueId;
        }
    }
    return -1;
}

stock Shipment:QueueIsValidID(queueId) {
    if (Iter_Contains(shipmentqueues, queueId)) {
        return 1;
    }
    return 0;
}

stock QueueProcessNextShipment() {
    foreach(new queueId:shipmentqueues) {
        if (Shipment:qData[queueId][Shipment:IsInQueue]) {
            Shipment:qData[queueId][Shipment:IsInQueue] = false;
            Shipment:qData[queueId][Shipment:qProcessAt] = gettime();
            new etaTime[100], etaTimeInSeconds = Shipment:qData[queueId][Shipment:qProcessAt] + (Shipment:qData[queueId][Shipment:orderQuantity] * Shipment:GetETA(Shipment:qData[queueId][Shipment:qShipmentId]));
            UnixToHuman(etaTimeInSeconds, etaTime);
            new playerid = GetPlayerIDByName(Shipment:qData[queueId][Shipment:qPlacedBy]);
            if (IsPlayerConnected(playerid)) {
                AlexaMsg(
                    playerid,
                    sprintf(
                        "your %s order has been processed from hub, current ETA is %s",
                        Shipment:GetTitle(Shipment:qData[queueId][Shipment:qShipmentId]),
                        etaTime
                    ),
                    "Shipment"
                );
            }
            break;
        }
    }
}

stock Shipment:DeliverShipment(queueId) {
    if (!Shipment:QueueIsValidID(queueId)) return 0;
    new slot = Shipment:qData[queueId][Shipment:locationSlot];
    new row = 1, iter = 0;
    for (new i; i < Shipment:qData[queueId][Shipment:orderQuantity]; i++) {
        Crate:Create(
            TrailerStorage:GetIdFromShopItemID(Shipment:GetShopId(Shipment:qData[queueId][Shipment:qShipmentId])),
            Shipment:GetPerItemUnit(Shipment:qData[queueId][Shipment:qShipmentId]),
            Shipment:Locations[slot][0] + (iter * 2.00),
            Shipment:Locations[slot][1] + row * 2.00,
            Shipment:Locations[slot][2]
        );

        // calc next location
        iter++;
        new newRow = floatround(i / 10) + 1;
        if (newRow != row) {
            row = newRow;
            iter = 0;
        }
    }

    // inform player
    new playerid = GetPlayerIDByName(Shipment:qData[queueId][Shipment:qPlacedBy]);
    if (IsPlayerConnected(playerid)) {
        AlexaMsg(
            playerid,
            sprintf(
                "your %s shipment is arrived at dock, please collect it as soon as possible",
                Shipment:GetTitle(Shipment:qData[queueId][Shipment:qShipmentId])
            ),
            "Shipment"
        );
        AlexaMsg(playerid, "we will not be responsible, if your shipment get stolen", "Shipment");
    }
    Iter_Remove(shipmentqueues, queueId);
    return 1;
}

forward Shipment:ProcessQueue();
public Shipment:ProcessQueue() {
    if (IsAnyShipmentInQueue()) {
        new queueId = GetQueueShipmentID();
        if (Shipment:QueueIsValidID(queueId)) {
            new etaTimeInSeconds = Shipment:qData[queueId][Shipment:qProcessAt] + (Shipment:qData[queueId][Shipment:orderQuantity] * Shipment:GetETA(Shipment:qData[queueId][Shipment:qShipmentId]));
            if (gettime() > etaTimeInSeconds) Shipment:DeliverShipment(queueId);
        }
    } else {
        QueueProcessNextShipment();
    }
    return 1;
}

stock Shipment:GetTotalPage() {
    new total = Iter_Count(shipments);
    new perPage = 25;
    return floatround(total / perPage);
}

stock Shipment:MakeOrderCat(playerid) {
    new string[1024];
    strcat(string, "Food\n");
    strcat(string, "Electrical\n");
    strcat(string, "Medicine\n");
    strcat(string, "Firework\n");
    strcat(string, "Clothes\n");
    strcat(string, "Clothes Accessories\n");
    strcat(string, "Clothes Accessories\n");
    strcat(string, "Weapon\n");
    strcat(string, "Vehicle: Light\n");
    strcat(string, "Vehicle: Heavy\n");
    strcat(string, "Vehicle: Bike\n");
    strcat(string, "Vehicle: Helicopter\n");
    strcat(string, "Vehicle: Plane\n");
    strcat(string, "Vehicle: Boat\n");
    FlexPlayerDialog(
        playerid, "ShipmentCategory", DIALOG_STYLE_LIST, "Material Shipment: Category",
        string, "Select", "Close"
    );
    return 1;
}

FlexDialog:ShipmentCategory(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) {
        return Shipment:Menu(playerid);
    }

    if (IsStringSame(inputtext, "Food")) return Shipment:MakeOrder(playerid, 0);
    if (IsStringSame(inputtext, "Electrical")) return Shipment:MakeOrder(playerid, 1);
    if (IsStringSame(inputtext, "Medicine")) return Shipment:MakeOrder(playerid, 1);
    if (IsStringSame(inputtext, "Firework")) return Shipment:MakeOrder(playerid, 1);
    if (IsStringSame(inputtext, "Clothes")) return Shipment:MakeOrder(playerid, 1);
    if (IsStringSame(inputtext, "Clothes Accessories")) return Shipment:MakeOrder(playerid, 14);
    if (IsStringSame(inputtext, "Weapon")) return Shipment:MakeOrder(playerid, 12);
    if (IsStringSame(inputtext, "Vehicle: Light")) return Shipment:MakeOrder(playerid, 19);
    if (IsStringSame(inputtext, "Vehicle: Heavy")) return Shipment:MakeOrder(playerid, 24);
    if (IsStringSame(inputtext, "Vehicle: Bike")) return Shipment:MakeOrder(playerid, 25);
    if (IsStringSame(inputtext, "Vehicle: Helicopter")) return Shipment:MakeOrder(playerid, 26);
    if (IsStringSame(inputtext, "Vehicle: Plane")) return Shipment:MakeOrder(playerid, 26);
    if (IsStringSame(inputtext, "Vehicle: Boat")) return Shipment:MakeOrder(playerid, 27);
    return 1;
}

stock Shipment:MakeOrder(playerid, page = 0) {
    new string[2000];
    strcat(string, "ID\tMaterial\tMin/Max Quantity (Per quantity unit)\tPrice per quantity\n");
    new total = Iter_Count(shipments);
    new perPage = 25;
    new paged = page * perPage;
    new skip = page * perPage;
    new count = 0;
    for (new i; i < total; i++) {
        if (count >= perPage) break;
        if (skip > 0) {
            skip--;
            continue;
        }

        strcat(string,
            sprintf(
                "%d\t%s\t%d/%d (%d)\t$%s\n",
                i,
                Shipment:Data[i][Shipment:Title],
                Shipment:GetMinQuantity(i),
                Shipment:GetMaxQuantity(i),
                Shipment:GetPerItemUnit(i),
                FormatCurrency(Shipment:Data[i][Shipment:OrderPrice])
            )
        );

        count++;
    }

    if ((total - (paged + perPage)) > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");
    strcat(string, "Go to Page\n");
    FlexPlayerDialog(
        playerid, "ShipmentMakeOrder", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Material Shipment: List (%d/%d)", page, Shipment:GetTotalPage()),
        string, "Select", "Close", page
    );
    return 1;
}

stock Shipment:GotoPage(playerid, page) {
    return FlexPlayerDialog(
        playerid, "ShipmentGoTo", DIALOG_STYLE_INPUT, "Material Shipment", sprintf("Enter page between 0 to %d", Shipment:GetTotalPage()), "Go", "Close", page
    );
}

FlexDialog:ShipmentGoTo(playerid, response, listitem, const inputtext[], cpage, const payload[]) {
    if (!response) return Shipment:MakeOrder(playerid, cpage);
    new page = 0;
    if (sscanf(inputtext, "d", page) || page < 0 || page > Shipment:GetTotalPage()) page = 0;
    Shipment:MakeOrder(playerid, page);
    return 1;
}

FlexDialog:ShipmentMakeOrder(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) { Shipment:Menu(playerid); return ~1; }
    if (IsStringSame(inputtext, "Next Page")) return Shipment:MakeOrder(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return Shipment:MakeOrder(playerid, page - 1);
    if (IsStringSame(inputtext, "Go to Page")) return Shipment:GotoPage(playerid, page);
    new shipmentID = strval(inputtext);
    if (
        GetPlayerScore(playerid) < Shipment:GetScoreRequired(shipmentID) &&
        (Faction:GetPlayerFID(playerid) != FACTION_ID_SATD || !Faction:IsPlayerSigned(playerid))
    ) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Shipment]:{FFCC66} you have to required %d score to make this order.", Shipment:GetScoreRequired(shipmentID)));
        Shipment:Menu(playerid);
        return ~1;
    }
    Shipment:OrderQuantityInput(playerid, shipmentID);
    return 1;
}

stock Shipment:OrderQuantityInput(playerid, shipmentID) {
    new string[512];
    strcat(string, sprintf("Shipment: %s\n", Shipment:GetTitle(shipmentID)));
    strcat(string, sprintf("Per quantity units: %d\n", Shipment:GetPerItemUnit(shipmentID)));
    strcat(string, sprintf("Minimum order quantity: %d\n", Shipment:GetMinQuantity(shipmentID)));
    strcat(string, sprintf("Maximum order quantity: %d\n", Shipment:GetMaxQuantity(shipmentID)));
    strcat(string, sprintf("Price for each quantity: $%s\n", FormatCurrency(Shipment:GetPrice(shipmentID))));
    return FlexPlayerDialog(
        playerid, "ShipmentOrderQntInput", DIALOG_STYLE_INPUT, "Material Shipment: Quantity", string, "Confirm", "Cancel", shipmentID
    );
}

FlexDialog:ShipmentOrderQntInput(playerid, response, listitem, const inputtext[], shipmentID, const payload[]) {
    if (!response) return Shipment:Menu(playerid);
    new orderQuantity;
    if (sscanf(inputtext, "d", orderQuantity) || orderQuantity < Shipment:GetMinQuantity(shipmentID) || orderQuantity > Shipment:GetMaxQuantity(shipmentID)) {
        SendClientMessage(playerid, -1, "{4286f4}[Shipment]:{FFCC66} you have entered invalid quantity, you can try again");
        return Shipment:OrderQuantityInput(playerid, shipmentID);
    }
    CallRemoteFunction("OnRequestShipment", "ddd", playerid, shipmentID, orderQuantity);
    return 1;
}

forward OnRequestShipment(playerid, shipmentID, quantity);
public OnRequestShipment(playerid, shipmentID, quantity) {
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 28) return 1;
    Shipment:Menu(playerid);
    return ~1;
}