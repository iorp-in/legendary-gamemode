UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new vehicleid = GetPlayerNearestVehicle(playerid, 10.0);
    new staticId = StaticVehicle:GetID(vehicleid);
    if (GetVehicleModel(vehicleid) != 433 || !StaticVehicle:IsValidID(staticId) || StaticVehicle:GetFactionID(staticId) != FACTION_ID_SAAF) return 1;
    if (Faction:GetPlayerFID(playerid) == FACTION_ID_SAAF && Faction:IsPlayerSigned(playerid)) UCP:AddCommand(playerid, "Mines");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Mines", inputtext)) {
        Mine:Menu(playerid);
        return ~1;
    }
    return 1;
}

stock Mine:Menu(playerid) {
    new string[2000];
    strcat(string, "Place mine\n");
    strcat(string, "Manage mines\n");
    FlexPlayerDialog(playerid, "MineMenu", DIALOG_STYLE_LIST, "Mines", string, "Select", "Close");
    return 1;
}

FlexDialog:MineMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Place mine")) return Mine:PlaceSelect(playerid);
    if (IsStringSame(inputtext, "Manage mines")) return Mine:ManageMenu(playerid);
    return 1;
}

stock Mine:PlaceSelect(playerid) {
    new string[512];
    strcat(string, "Standard\n");
    strcat(string, "Underwater\n");
    strcat(string, "Pizza\n");
    return FlexPlayerDialog(playerid, "MinePlaceSelect", DIALOG_STYLE_TABLIST, "Mine Type", string, "Select", "Close");
}

FlexDialog:MinePlaceSelect(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Mine:Menu(playerid);
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    new mineId = -1;
    switch (listitem) {

        case 1 :  {
            mineId = Mine:Create(
                GetPlayerNameEx(playerid), pos[0], pos[1], pos[2] - 0.10, 0.0, 0.0, 0.0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid),
                30, 1, -1, 0, 2, MINE_OBJECT_UNDERWATER
            );
        }
        case 2 :  {
            mineId = Mine:Create(
                GetPlayerNameEx(playerid), pos[0], pos[1], pos[2] - 0.05, 0.0, 0.0, 0.0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid),
                30, 1, -1, 0, 2, MINE_OBJECT_PIZZA
            );
        }
        default:  {
            mineId = Mine:Create(
                GetPlayerNameEx(playerid), pos[0], pos[1], pos[2] - 0.93, 0.0, 0.0, 0.0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid),
                30, 1, -1, 0, 2, MINE_OBJECT_STANDARD
            );
        }
    }
    if (mineId == -1) AlexaMsg(playerid, "Mine cannot be created, probably exceeded the limit");
    else AlexaMsg(playerid, sprintf("mine (id: %d) will be activated in 30 seconds, clear the area as quickly as possible", mineId));
    return Mine:Menu(playerid);
}

stock Mine:ManageMenu(playerid, page = 0) {
    new total = Mine:Total();
    new perpage = 10;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;

    new string[2000], count = 0;
    strcat(string, "#\tStatus\tLocation\n");
    foreach(new mineId:Mines) {
        if (skip > 0) {
            skip--;
            continue;
        }
        count++;
        strcat(string, sprintf("%d\t%s\t%s\n",
            mineId,
            Mine:GetStatusText(mineId),
            sprintf("%.2f, %.2f, %.2f", Mine:GetPosX(mineId), Mine:GetPosY(mineId), Mine:GetPosZ(mineId))
        ));
        if (count == perpage) break;
    }

    if (remaining > 0) strcat(string, ">> Next Page");
    if (page > 0) strcat(string, ">> Previous Page");
    if (count == 0) return AlexaMsg(playerid, "{FF0000}[!] {F0AE0F}There are no mines!");
    return FlexPlayerDialog(playerid, "ManageMines", DIALOG_STYLE_TABLIST_HEADERS, "Manage Mines", string, "Select", "Close", page);
}

FlexDialog:ManageMines(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return Mine:Menu(playerid);
    if (IsStringSame(inputtext, ">> Next Page")) return Mine:ManageMenu(playerid, page + 1);
    if (IsStringSame(inputtext, ">> Previous Page")) return Mine:ManageMenu(playerid, page - 1);
    Mine:ManageOptions(playerid, strval(inputtext));
    return 1;
}

stock Mine:ManageOptions(playerid, mineId) {
    new string[512];
    strcat(string, "Teleport To Mine\n");
    strcat(string, "Remove\n");
    return FlexPlayerDialog(playerid, "MineManageOptions", DIALOG_STYLE_LIST, "Mine Options", string, "Select", "Close", mineId);
}

FlexDialog:MineManageOptions(playerid, response, listitem, const inputtext[], mineId, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Teleport To Mine")) {
        SetPlayerPosEx(playerid, Mine:GetPosX(mineId), Mine:GetPosY(mineId), Mine:GetPosZ(mineId));
        SetPlayerVirtualWorldEx(playerid, Mine:GetWorldId(mineId));
        SetPlayerInteriorEx(playerid, Mine:GetInteriorId(mineId));
        return AlexaMsg(playerid, "you are teleported to the mine");
    }
    if (IsStringSame(inputtext, "Remove")) {
        Mine:Remove(mineId);
        AlexaMsg(playerid, "Mine removed");
        return Mine:ManageMenu(playerid);
    }
    return 1;
}