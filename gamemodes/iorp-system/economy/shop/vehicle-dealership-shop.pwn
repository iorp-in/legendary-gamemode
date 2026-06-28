hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_LightMotor && DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_HeavyMotor &&
        DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_TwoWheelerMotor && DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_HelicopterMotor &&
        DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_PlaneMotor && DynamicShopBusiness:GetType(shopid) != Shop_Type_Dealership_BoatMotor
    ) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase auto drive"); return ~1; }
    new vehicleModelID = shopItemId + 43;
    new resvlist[] = { 470, 472, 435, 450, 584, 591, 606, 607, 608, 610, 611, 592, 594, 601, 596, 597, 598, 599, 582, 577, 573, 574, 571, 570, 569, 564, 563, 557, 556, 552, 553, 548, 544, 539, 537, 538, 532, 528, 530, 524, 520, 523, 519, 512, 513, 514, 515, 511, 504, 502, 503, 501, 497, 488, 586, 476, 464, 465, 460, 455, 449, 448, 443, 441, 437, 435, 432, 433, 430, 431, 427, 425, 417, 416, 408, 407, 406, 403 };
    if (IsArrayContainNumber(resvlist, vehicleModelID)) {
        SendClientMessageEx(playerid, -1, "{FF0000}[!] {F0AE0F}You cant purchase this vehicle, it's blacklisted even shop has stock!");
        RemovePlayerFromVehicle(playerid);
        return ~1;
    }
    if (PersonalVehicle:GetPlayerVehicleCount(playerid) >= PersonalVehicle:GetPlayerVehicleLimit(playerid)) {
        SendClientMessageEx(playerid, -1, "{FF0000}[!] {F0AE0F}You have reached the limit! You can't buy more vehicle.");
        RemovePlayerFromVehicle(playerid);
        return ~1;
    }
    SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}You have succesfully bought this vehicle! You can manage your vehicles by using {ECB021}your pocket");
    new Float:x, Float:y, Float:z, Float:a;
    if (IsArrayContainNumber(HelicopterMotor_Vehicles, vehicleModelID || IsArrayContainNumber(PlaneMotor_Vehicles, vehicleModelID))) {
        Dealership_GetNearestAirportLoc(playerid, x, y, z, a);
    } else if (IsArrayContainNumber(BoatMotor_Vehicles, vehicleModelID)) {
        Dealership_GetNearestBoatLoc(playerid, x, y, z, a);
    } else {
        Dealership_GetNearestCarLoc(playerid, x, y, z, a);
    }
    SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}Transported your vehicle to the nearest pickup location");
    new xid = PersonalVehicle:CreateVehicle(vehicleModelID, sprintf("%s", GetPlayerNameEx(playerid)), price, x, y, z, a, -1, -1);
    if (!PersonalVehicle:IsValidID(xid)) {
        AlexaMsg(playerid, "your purchased is rejected by server itself, try again later");
        return ~1;
    }
    GivePlayerCash(playerid, -price,
        sprintf(
            "Purchased %s with plate %s (%d) vehicle item from %s [%s] store",
            PersonalVehicle:GetName(xid),
            PersonalVehicle:GetPlate(xid),
            xid,
            DynamicShopBusiness:GetName(shopid),
            DynamicShopBusiness:GetOwner(shopid)
        )
    );
    DynamicShopBusiness:IncreaseBalance(shopid, price,
        sprintf(
            "%s purchased vehicle item: %s with plate %s (%d)",
            GetPlayerNameEx(playerid),
            PersonalVehicle:GetName(xid),
            PersonalVehicle:GetPlate(xid),
            xid
        )
    );
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    return ~1;
}

#define Max_HELI_LOCATIONS 3
new Float:HelicopterDropPoints[Max_HELI_LOCATIONS][4] = {
    { 1925.00, -2430.00, 15.00, 94.00 },
    {-1304.7775, -20.6339, 14.1484, 127.8152 },
    { 1320.2742, 1312.4570, 10.5889, 357.0040 }
};

stock Dealership_GetNearestAirportLoc(playerid, & Float:x, & Float:y, & Float:z, & Float:a) {
    new id = 0, Float:tempdist, Float:first;
    for (new i = 0; i < Max_HELI_LOCATIONS; i++) {
        tempdist = GetPlayerDistanceFromPoint(playerid, HelicopterDropPoints[i][0], HelicopterDropPoints[i][1], HelicopterDropPoints[i][2]);
        if (i == 0) first = tempdist, id = i;
        if (tempdist < first) first = tempdist, id = i;
    }
    x = HelicopterDropPoints[id][0];
    y = HelicopterDropPoints[id][1];
    z = HelicopterDropPoints[id][2];
    a = HelicopterDropPoints[id][3];
    return 1;
}

#define Max_Boat_LOCATIONS 2
new Float:BoatDropPoints[Max_Boat_LOCATIONS][4] = {
    { 220.00, -1925.00, 0.00, 185.00 },
    {-1566.1611, 170.4382, -0.6173, 355.1736 }
};

stock Dealership_GetNearestBoatLoc(playerid, & Float: x, & Float: y, & Float: z, & Float: a) {
    new id = 0, Float:tempdist, Float:first;
    for (new i = 0; i < Max_HELI_LOCATIONS; i++) {
        tempdist = GetPlayerDistanceFromPoint(playerid, BoatDropPoints[i][0], BoatDropPoints[i][1], BoatDropPoints[i][2]);
        if (i == 0) first = tempdist, id = i;
        if (tempdist < first) first = tempdist, id = i;
    }
    x = BoatDropPoints[id][0];
    y = BoatDropPoints[id][1];
    z = BoatDropPoints[id][2];
    a = BoatDropPoints[id][3];
    return 1;
}

#define Max_Car_LOCATIONS 4
new Float:CarDropPoints[Max_Car_LOCATIONS][4] = {
    { 1774.00, -1770.00, 15.00, 94.00 },
    { 1686.6382, -1575.6340, 13.8000, 180.9411 },
    { 1772.0970, -1770.2379, 13.7754, 93.00 },
    { 2599.7834, 773.3122, 10.6719, 89.1398 }
};

stock Dealership_GetNearestCarLoc(playerid, & Float: x, & Float: y, & Float: z, & Float: a) {
    new id = 0, Float:tempdist, Float:first;
    for (new i = 0; i < Max_HELI_LOCATIONS; i++) {
        tempdist = GetPlayerDistanceFromPoint(playerid, CarDropPoints[i][0], CarDropPoints[i][1], CarDropPoints[i][2]);
        if (i == 0) first = tempdist, id = i;
        if (tempdist < first) first = tempdist, id = i;
    }
    x = CarDropPoints[id][0];
    y = CarDropPoints[id][1];
    z = CarDropPoints[id][2];
    a = CarDropPoints[id][3];
    return 1;
}

/*
new Vehicle_Purchase_Dialog;
enum Vehicle_Shop_Enum { ModelID, Price };
new VehicelShopData[][Vehicle_Shop_Enum] = {
    { 400, 80000 },
    { 401, 74000 },
    { 402, 99000 },
    { 403, 90000 },
    { 404, 55000 },
    { 405, 90000 },
    { 406, 85000 },
    { 407, 91000 },
    { 408, 87000 },
    { 409, 300000 },
    { 410, 73000 },
    { 411, 290000 },
    { 412, 105000 },
    { 413, 67000 },
    { 414, 79000 },
    { 415, 198000 },
    { 416, 72000 },
    { 417, 1330000 },
    { 418, 68000 },
    { 419, 88000 },
    { 420, 79000 },
    { 421, 81000 },
    { 422, 80000 },
    { 423, 83000 },
    { 424, 60000 },
    { 425, 1980000 },
    { 426, 79000 },
    { 427, 86000 },
    { 428, 82000 },
    { 429, 268000 },
    { 430, 190000 },
    { 431, 110000 },
    { 432, 3129000 },
    { 433, 111000 },
    { 434, 67000 },
    { 435, 50000 },
    { 436, 83000 },
    { 437, 109000 },
    { 438, 66000 },
    { 439, 134000 },
    { 440, 68500 },
    { 441, 2799 },
    { 442, 81000 },
    { 443, 88000 },
    { 444, 90900 },
    { 445, 79000 },
    { 446, 200700 },
    { 447, 1633000 },
    { 448, 38300 },
    { 449, 3130000 },
    { 450, 54890 },
    { 451, 275000 },
    { 452, 245000 },
    { 453, 389000 },
    { 454, 321000 },
    { 455, 98000 },
    { 456, 87000 },
    { 457, 63000 },
    { 458, 69000 },
    { 459, 58000 },
    { 460, 519000 },
    { 461, 115000 },
    { 462, 39000 },
    { 463, 70500 },
    { 464, 1200 },
    { 465, 900 },
    { 466, 81000 },
    { 467, 91000 },
    { 468, 72000 },
    { 469, 1499000 },
    { 470, 70000 },
    { 471, 81000 },
    { 472, 535000 },
    { 473, 78000 },
    { 474, 67000 },
    { 475, 78000 },
    { 476, 889000 },
    { 477, 145000 },
    { 478, 71000 },
    { 479, 81000 },
    { 480, 178000 },
    { 481, 3100 },
    { 482, 69200 },
    { 483, 81000 },
    { 484, 319000 },
    { 485, 49000 },
    { 486, 103900 },
    { 487, 1290000 },
    { 488, 1250000 },
    { 489, 97000 },
    { 490, 102000 },
    { 491, 79000 },
    { 492, 73000 },
    { 493, 370000 },
    { 494, 299000 },
    { 495, 188000 },
    { 496, 88000 },
    { 497, 1607900 },
    { 498, 71000 },
    { 499, 66000 },
    { 500, 63000 },
    { 501, 598 },
    { 502, 259000 },
    { 503, 273000 },
    { 504, 78000 },
    { 505, 98000 },
    { 506, 300000 },
    { 507, 76000 },
    { 508, 85900 },
    { 509, 1300 },
    { 510, 3099 },
    { 511, 1490000 },
    { 512, 1200000 },
    { 513, 1577000 },
    { 514, 82000 },
    { 515, 84799 },
    { 516, 72000 },
    { 517, 68000 },
    { 518, 69000 },
    { 519, 2110000 },
    { 520, 4322000 },
    { 521, 86000 },
    { 522, 129000 },
    { 523, 81000 },
    { 524, 95000 },
    { 525, 68000 },
    { 526, 81000 },
    { 527, 76000 },
    { 528, 80300 },
    { 529, 74000 },
    { 530, 31000 },
    { 531, 52000 },
    { 532, 60000 },
    { 533, 80000 },
    { 534, 74000 },
    { 535, 79000 },
    { 536, 76000 },
    { 537, 2289000 },
    { 538, 2200000 },
    { 539, 140000 },
    { 540, 79000 },
    { 541, 243000 },
    { 542, 70000 },
    { 543, 68000 },
    { 544, 100000 },
    { 545, 62000 },
    { 546, 73000 },
    { 547, 77000 },
    { 548, 2199000 },
    { 549, 71000 },
    { 550, 75900 },
    { 551, 77000 },
    { 552, 64000 },
    { 553, 3450000 },
    { 554, 68000 },
    { 555, 87000 },
    { 556, 88000 },
    { 557, 88700 },
    { 558, 83000 },
    { 559, 139000 },
    { 560, 92000 },
    { 561, 90000 },
    { 562, 85000 },
    { 563, 2099000 },
    { 564, 980 },
    { 565, 85000 },
    { 566, 79000 },
    { 567, 71000 },
    { 568, 48000 },
    { 569, 880000 },
    { 570, 1390000 },
    { 571, 12000 },
    { 572, 47000 },
    { 573, 58000 },
    { 574, 53000 },
    { 575, 70000 },
    { 576, 72000 },
    { 577, 470000 },
    { 578, 75000 },
    { 579, 81000 },
    { 580, 75500 },
    { 581, 90000 },
    { 582, 73000 },
    { 583, 47000 },
    { 584, 59000 },
    { 585, 78000 },
    { 586, 75000 },
    { 587, 178000 },
    { 588, 60000 },
    { 589, 77000 },
    { 590, 795000 },
    { 591, 55000 },
    { 592, 4180000 },
    { 593, 1500000 },
    { 594, 56 },
    { 595, 567000 },
    { 596, 83000 },
    { 597, 85000 },
    { 598, 81000 },
    { 599, 91000 },
    { 600, 73000 },
    { 601, 110000 },
    { 602, 200000 },
    { 603, 188000 },
    { 604, 50000 },
    { 605, 48000 },
    { 606, 33000 },
    { 607, 20000 },
    { 608, 28000 },
    { 609, 58000 },
    { 610, 35000 },
    { 611, 25000 }
};


hook OnGameModeInit() {
    Vehicle_Purchase_Dialog = Dialog:GetFreeID();
    return 1;
}

stock iorp_dealership_shop_menu(playerid) {
    if(IsAndroidPlayer(playerid)) {
        new string[2000];
        strcat(string, "ModelID\tName\tPrice");
        for (new i; i < 80; i++) {
            format(string, sizeof string, "%s\n%d\t%s\t$%d", string, VehicelShopData[i][ModelID], GetVehicleModelName(VehicelShopData[i][ModelID]), VehicelShopData[i][Price]);
        }
        strcat(string, "\n19134\tNext");
        return ShowPlayerDialogEx(playerid, Vehicle_Purchase_Dialog, 0, DIALOG_STYLE_TABLIST_HEADERS, "IORP Dealership: your ride partner", string, "Purchase", "Cancel");
    }

    static string[sizeof VehicelShopData * 256];
    if(string[0] == EOS) {
        for (new i; i < (sizeof VehicelShopData) / 2; i++) {
            format(string, sizeof string, "%s%i\t%s~n~~g~~h~$%i\n", string, VehicelShopData[i][ModelID], GetVehicleModelName(VehicelShopData[i][ModelID]), VehicelShopData[i][Price]);
        }
        strcat(string, "19134\tNext\n");
    }
    return ShowPlayerDialogEx(playerid, Vehicle_Purchase_Dialog, 0, DIALOG_STYLE_PREVIEW_MODEL, "IORP Dealership: your ride partner", string, "Purchase", "Cancel");
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if(dialogid != Vehicle_Purchase_Dialog) return 1;
    if(!response) return ~1;
    new modelid = strval(inputtext);
    if(modelid <= 400) return ~1;
    if(modelid == 19135) { iorp_dealership_shop_menu(playerid); return ~1; }
    if(modelid == 19136) {
        if(IsAndroidPlayer(playerid)) {
            new string[2000];
            strcat(string, "ModelID\tName\tPrice");
            for (new i = 160; i < 212; i++) {
                format(string, sizeof string, "%s\n%d\t%s\t$%d", string, VehicelShopData[i][ModelID], GetVehicleModelName(VehicelShopData[i][ModelID]), VehicelShopData[i][Price]);
            }
            strcat(string, "\n19135\tBack");
            ShowPlayerDialogEx(playerid, Vehicle_Purchase_Dialog, 0, DIALOG_STYLE_TABLIST_HEADERS, "IORP Dealership: your ride partner", string, "Purchase", "Cancel");
            return ~1;
        }
    }
    if(modelid == 19134) {
        if(IsAndroidPlayer(playerid)) {
            new string[2000];
            strcat(string, "ModelID\tName\tPrice");
            for (new i = 80; i < 160; i++) {
                format(string, sizeof string, "%s\n%d\t%s\t$%d", string, VehicelShopData[i][ModelID], GetVehicleModelName(VehicelShopData[i][ModelID]), VehicelShopData[i][Price]);
            }
            strcat(string, "\n19136\tNext");
            strcat(string, "\n19135\tBack");
            ShowPlayerDialogEx(playerid, Vehicle_Purchase_Dialog, 0, DIALOG_STYLE_TABLIST_HEADERS, "IORP Dealership: your ride partner", string, "Purchase", "Cancel");
            return ~1;
        }
        static string[sizeof VehicelShopData * 512];

        if(string[0] == EOS) {
            for (new i = (sizeof VehicelShopData) / 2; i < (sizeof VehicelShopData); i++) {
                format(string, sizeof string, "%s%i\t%s~n~~g~~h~$%i\n", string, VehicelShopData[i][ModelID], GetVehicleModelName(VehicelShopData[i][ModelID]), VehicelShopData[i][Price]);
            }
        }
        ShowPlayerDialogEx(playerid, Vehicle_Purchase_Dialog, 0, DIALOG_STYLE_PREVIEW_MODEL, "IORP Dealership: your ride partner", string, "Purchase", "Cancel");
        return ~1;
    }
    new VehID = modelid - 400;
    new resvlist[] = { 470, 472, 435, 450, 584, 591, 606, 607, 608, 610, 611, 592, 594, 601, 596, 597, 598, 599, 582, 577, 573, 574, 571, 570, 569, 564, 563, 557, 556, 552, 553, 548, 544, 539, 537, 538, 532, 528, 530, 524, 520, 523, 519, 512, 513, 514, 515, 511, 504, 502, 503, 501, 497, 488, 586, 476, 464, 465, 460, 455, 449, 448, 443, 441, 437, 435, 432, 433, 430, 431, 427, 425, 417, 416, 408, 407, 406, 403 };
    if(IsArrayContainNumber(resvlist, VehicelShopData[VehID][ModelID])) {
        SendClientMessageEx(playerid, -1, "{FF0000}[!] {F0AE0F}You cant purchase this vehicle!");
        RemovePlayerFromVehicle(playerid);
        return ~1;
    }
    if(PersonalVehicle:GetPlayerVehicleCount(playerid) >= PersonalVehicle:GetPlayerVehicleLimit(playerid)) {
        SendClientMessageEx(playerid, -1, "{FF0000}[!] {F0AE0F}You have reached the limit! You can't buy more vehicle.");
        RemovePlayerFromVehicle(playerid);
        return ~1;
    }
    if(GetPlayerCash(playerid) < VehicelShopData[VehID][Price]) {
        SendClientMessageEx(playerid, -1, "{FF0000}[!] {F0AE0F}You don't have enough money!");
        RemovePlayerFromVehicle(playerid);
        return ~1;
    }
    SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}You have succesfully bought this vehicle! You can manage your vehicles by using {ECB021}your pocket");
    GivePlayerCash(playerid, -VehicelShopData[VehID][Price], "bought new vehicle from dealership");
    new Float:x, Float:y, Float:z, Float:a;
    if(IsArrayContainNumber(HelicopterMotor_Vehicles, VehicelShopData[VehID][ModelID] || IsArrayContainNumber(PlaneMotor_Vehicles, VehicelShopData[VehID][ModelID]))) {
        x = 1925.00, y = -2430.00, z = 15.00, a = 94.00;
        SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}Transported your vehicle to the LS Airport pickup location");
    } else if(IsArrayContainNumber(BoatMotor_Vehicles, VehicelShopData[VehID][ModelID])) {
        x = 220.00, y = -1925.00, z = 0.00, a = 185.00;
        SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}Transported your vehicle to the LS Sant Maria Beach pickup location");
    } else {
        x = 1774.00, y = -1770.00, z = 15.00, a = 94.00;
        SendClientMessageEx(playerid, -1, "{00BD00}[!] {00FF00}Transported your vehicle to the dealership pickup location");
    }
    new xid = PersonalVehicle:CreateVehicle(VehicelShopData[VehID][ModelID], sprintf("%s", GetPlayerNameEx(playerid)), VehicelShopData[VehID][Price], x, y, z, a, -1, -1);
    DestroyDynamic3DTextLabel(xVehicle[xid][xv_Text]);
    return ~1;
}
*/