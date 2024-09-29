hook ApcpOnInit(playerid, targetid, page) {
    if (page != 1 || GetPlayerAdminLevel(playerid) < 10) return 1;
    APCP:AddCommand(playerid, "Manage Electronic Items");
    return 1;
}

hook ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (page != 1 || !response) return 1;
    if (IsStringSame("Manage Electronic Items", inputtext)) {
        ManageElectronicItem(playerid, targetid);
        return ~1;
    }
    return 1;
}

stock ManageElectronicItem(adminid, playerid) {
    new string[1024];
    strcat(string, "Item\tExpire At\n");
    strcat(string, sprintf("Alexa\t%s\n", UnixToHumanEx(EtShop:GetAlexa(playerid))));
    strcat(string, sprintf("GPS\t%s\n", UnixToHumanEx(EtShop:GetGps(playerid))));
    strcat(string, sprintf("MP3\t%s\n", UnixToHumanEx(EtShop:GetMp3(playerid))));
    strcat(string, sprintf("Phone\t%s\n", UnixToHumanEx(EtShop:GetPhone(playerid))));
    strcat(string, sprintf("Tablet\t%s\n", UnixToHumanEx(EtShop:GetTablet(playerid))));
    strcat(string, sprintf("Radio\t%s\n", UnixToHumanEx(EtShop:GetRadio(playerid))));
    return FlexPlayerDialog(
        adminid, "AcpElectronicIitems", DIALOG_STYLE_TABLIST_HEADERS, "Manage Electronic Devices", string, "Select", "Close", playerid
    );
}

FlexDialog:AcpElectronicIitems(adminid, response, listitem, const inputtext[], playerid, const payload[]) {
    if (!response || !IsPlayerConnected(playerid)) return 1;
    ManageElectronicInput(adminid, playerid, inputtext);
    return 1;
}

stock ManageElectronicInput(adminid, playerid, const device[]) {
    return FlexPlayerDialog(
        adminid, "ManageElectronicInput", DIALOG_STYLE_INPUT, "Update expire date",
        sprintf("Update the expiration date for the %s by adding seconds", device),
        "Update", "Cancel", playerid, device
    );
}

FlexDialog:ManageElectronicInput(adminid, response, listitem, const inputtext[], playerid, const device[]) {
    if (!response) return ManageElectronicItem(adminid, playerid);
    new seconds = 0;
    if (sscanf(inputtext, "d", seconds) || seconds < 0 || seconds > 31556952) return ManageElectronicInput(adminid, playerid, device);
    new expireAt = gettime() + seconds;
    if (IsStringSame(device, "Alexa")) EtShop:SetAlexa(playerid, expireAt);
    if (IsStringSame(device, "GPS")) EtShop:SetGps(playerid, expireAt);
    if (IsStringSame(device, "MP3")) EtShop:SetMp3(playerid, expireAt);
    if (IsStringSame(device, "Phone")) EtShop:SetPhone(playerid, expireAt);
    if (IsStringSame(device, "Tablet")) EtShop:SetTablet(playerid, expireAt);
    if (IsStringSame(device, "Radio")) EtShop:SetRadio(playerid, expireAt);
    ManageElectronicItem(adminid, playerid);
    return 1;
}