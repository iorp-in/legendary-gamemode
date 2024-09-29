new XenonMod:BlackListedModels[] = { 522, 462, 521, 461, 463, 581, 448, 586, 523, 468, 471, 509, 481, 510, 539, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 548, 425, 417, 487, 497, 563, 501, 465, 447, 469, 488, 520, 476, 593, 553, 513, 512, 577, 592, 511, 464, 519, 460 };
new XenonMod:Data[MAX_VEHICLES][4] = {-1, ... };

stock XenonMod:IsModelSupported(modelid) {
    return !IsArrayContainNumber(XenonMod:BlackListedModels, modelid);
}

stock XenonMod:IsVehicleSupport(vehicleid) {
    return XenonMod:IsModelSupported(GetVehicleModel(vehicleid));
}

hook OnMyVehicleSpawn(xid) {
    XenonMod:Install(PersonalVehicle:GetVehicleID(xid), PersonalVehicle:GetXenon(xid));
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    XenonMod:Uninstall(vehicleid);
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    XenonMod:Uninstall(vehicleid);
    return 1;
}

stock XenonMod:Uninstall(vehicleid) {
    if (vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 1;
    DestroyDynamicObjectEx(XenonMod:Data[vehicleid][0]);
    XenonMod:Data[vehicleid][0] = -1;
    DestroyDynamicObjectEx(XenonMod:Data[vehicleid][1]);
    XenonMod:Data[vehicleid][1] = -1;
    DestroyDynamicObjectEx(XenonMod:Data[vehicleid][2]);
    XenonMod:Data[vehicleid][2] = -1;
    DestroyDynamicObjectEx(XenonMod:Data[vehicleid][3]);
    XenonMod:Data[vehicleid][3] = -1;
    return 1;
}

stock XenonMod:Install(vehicleid, color) {
    if (color < 1 || color > 3) return 1;
    color--;
    XenonMod:Uninstall(vehicleid);
    new colors[] = { 19296, 19297, 19298 };

    XenonMod:Data[vehicleid][0] = CreateDynamicObject(colors[color], 0, 0, 0, 0, 0, 0);
    XenonMod:Data[vehicleid][1] = CreateDynamicObject(colors[color], 0, 0, 0, 0, 0, 0);
    XenonMod:Data[vehicleid][2] = CreateDynamicObject(colors[color], 0, 0, 0, 0, 0, 0);
    XenonMod:Data[vehicleid][3] = CreateDynamicObject(colors[color], 0, 0, 0, 0, 0, 0);
    AttachDynamicObjectToVehicle(XenonMod:Data[vehicleid][0], vehicleid, 0.0, 3.0, -0.8, 0.0, 0.0, 0.0);
    AttachDynamicObjectToVehicle(XenonMod:Data[vehicleid][1], vehicleid, 0.0, 5.0, -0.8, 0.0, 0.0, 0.0);
    AttachDynamicObjectToVehicle(XenonMod:Data[vehicleid][2], vehicleid, 0.0, 6.0, -0.8, 0.0, 0.0, 0.0);
    AttachDynamicObjectToVehicle(XenonMod:Data[vehicleid][3], vehicleid, 0.0, 7.0, -0.8, 0.0, 0.0, 0.0);
    return 1;
}

BitCoin:OnInit(playerid, page) {
    if (page != 0 || !IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    if (XenonMod:IsVehicleSupport(vehicleid) && PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid))) BitCoin:AddCommand(playerid, "Vehicle > Xenon Mode (15 BTC)");
    return 1;
}

BitCoin:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page != 0) return 1;
    if (IsStringSame(inputtext, "Vehicle > Xenon Mode (15 BTC)")) {
        XenonMod:Menu(playerid);
        return ~1;
    }
    return 1;
}

stock XenonMod:Menu(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return AlexaMsg(playerid, "use this command in a vehicle");
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!XenonMod:IsVehicleSupport(vehicleid) || !PersonalVehicle:IsValidID(PersonalVehicle:GetID(vehicleid)))
        return AlexaMsg(playerid, "this vehicle is not supported for this mod, use personal car");

    if (BitCoin:Get(playerid) < 15)
        return AlexaMsg(playerid, "you need 15 bitcoins to install this mode");

    new string[512];
    strcat(string, "Red\n");
    strcat(string, "Green\n");
    strcat(string, "Blue\n");
    AlexaMsg(playerid, FormatColors("~y~remember this mode will expire after ~r~two weeks"));
    return FlexPlayerDialog(playerid, "XenonModMenu", DIALOG_STYLE_LIST, "Xenon Mod", string, "Select", "Close", vehicleid);
}

FlexDialog:XenonModMenu(playerid, response, listitem, const inputtext[], vehicleid, const payload[]) {
    new xid = PersonalVehicle:GetID(vehicleid);
    if (!response || !PersonalVehicle:IsValidID(xid) || BitCoin:Get(playerid) < 15) return 1;
    BitCoin:GiveOrTake(playerid, -15, sprintf("installed xenon in %s with plate %s (%d)", PersonalVehicle:GetName(xid), PersonalVehicle:GetPlate(xid), xid));
    new color = listitem + 1;
    XenonMod:Install(vehicleid, color);
    PersonalVehicle:SetXenon(xid, color, gettime() + (2 * 7 * 24 * 60 * 60));
    PersonalVehicle:SaveID(xid);
    AlexaMsg(playerid, "xenon mod activated");
    return 1;
}