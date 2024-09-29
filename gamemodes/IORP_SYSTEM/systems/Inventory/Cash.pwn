#define InvCash:%0 InvCash@
#define InvCashLimit 50000
#define BackpackInvColumn "Cash"

new InvCash:Id;
hook OnInventoryInit() {
    InvCash:Id = Backpack:AddInventoryItem("Cash", InvCashLimit);
    Database:AddColumn(BackpackDB, BackpackInvColumn, "int", "0");
    return 1;
}

hook OnBackpackLoad(backPackId) {
    Backpack:PushItem(backPackId, InvCash:Id, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn, BackpackDB));
    return 1;
}

hook OnBackpackSave(backPackId) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvCash:Id), sprintf("%d", backPackId), "id", BackpackInvColumn, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backPackId) {
    Backpack:PopItem(backPackId, InvCash:Id, Backpack:GetInvItemQuantity(backPackId, InvCash:Id));
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId != InvCash:Id) return 1;
    InvCash:Menu(playerid, backPackId);
    return ~1;
}

InvCash:Menu(playerid, backPackId) {
    new string[500];
    if (GetPlayerScore(playerid) > 10) strcat(string, "Put Cash\n");
    if (Backpack:GetInvItemQuantity(backPackId, InvCash:Id) > 0) strcat(string, "Take Cash\n");
    FlexPlayerDialog(playerid, "InvCashMenu", DIALOG_STYLE_LIST, "[Backpack]: Cash", string, "Select", "Close", backPackId);
    return 1;
}

FlexDialog:InvCashMenu(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Put Cash")) return InvCash:MenuPut(playerid, backPackId);
    if (IsStringSame(inputtext, "Take Cash")) return InvCash:MenuTake(playerid, backPackId);
    return 1;
}

InvCash:MenuPut(playerid, backPackId) {
    return FlexPlayerDialog(playerid, "InvCashMenuPut", DIALOG_STYLE_INPUT, "[Backpack]: Cash", sprintf("Enter ammunt between 1 to %d", GetPlayerCash(playerid)), "Put Cash", "Close", backPackId);
}

FlexDialog:InvCashMenuPut(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return InvCash:Menu(playerid, backPackId);
    new cash;
    if (sscanf(inputtext, "d", cash) || cash < 1 || cash > GetPlayerCash(playerid)) return InvCash:MenuPut(playerid, backPackId);

    // if backpack limit exceed
    if (Backpack:GetInvItemQuantity(backPackId, InvCash:Id) + cash > Backpack:GetInvMaxLimit(InvCash:Id)) {
        AlexaMsg(playerid, "In your backpack, there is no room for more money");
        return InvCash:MenuPut(playerid, backPackId);
    }

    // put money in backpack
    Backpack:PushItem(backPackId, InvCash:Id, cash);
    GivePlayerCash(playerid, -cash, sprintf("put money into backpack [%d] [%s]", backPackId, Backpack:GetOwner(backPackId)));
    AlexaMsg(playerid, sprintf("[Backpack]: You put $%s cash in backpack", FormatCurrency(cash)));
    return InvCash:Menu(playerid, backPackId);
}

InvCash:MenuTake(playerid, backPackId) {
    return FlexPlayerDialog(playerid, "InvCashMenuTake", DIALOG_STYLE_INPUT, "[Backpack]: Cash", sprintf("Enter ammunt between 1 to %d", Backpack:GetInvItemQuantity(backPackId, InvCash:Id)), "Take Cash", "Close", backPackId);
}

FlexDialog:InvCashMenuTake(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return InvCash:Menu(playerid, backPackId);
    new cash;
    if (sscanf(inputtext, "d", cash) || cash < 1 || Backpack:GetInvItemQuantity(backPackId, InvCash:Id) - cash < 0) return InvCash:MenuTake(playerid, backPackId);
    Backpack:PopItem(backPackId, InvCash:Id, cash);
    GivePlayerCash(playerid, cash, sprintf("taken from backpack [%d] [%s]", backPackId, Backpack:GetOwner(backPackId)));
    AlexaMsg(playerid, sprintf("[Backpack]: You take $%s cash from backpack", FormatCurrency(cash)));
    return InvCash:Menu(playerid, backPackId);
}

hook OnPlayerShareBpItem(playerid, targetid, inventoryId) {
    if (inventoryId != InvCash:Id) return 1;
    new playerBackPackId = Backpack:GetPlayerBackpackID(playerid);
    new targetBackPackId = Backpack:GetPlayerBackpackID(targetid);
    if (!Backpack:isValidBackpack(playerBackPackId) || !Backpack:isValidBackpack(targetBackPackId)) return 1;
    InvCash:ShareCash(playerid, targetid);
    return ~1;
}

InvCash:ShareCash(playerid, targetid) {
    new playerBackPackId = Backpack:GetPlayerBackpackID(playerid);
    return FlexPlayerDialog(
        playerid, "InvCashShareCash", DIALOG_STYLE_INPUT, "[Backpack]: Cash",
        sprintf("Enter ammunt between 1 to %d", Backpack:GetInvItemQuantity(playerBackPackId, InvCash:Id)),
        "Share Cash", "Close", targetid
    );
}

FlexDialog:InvCashShareCash(playerid, response, listitem, const inputtext[], targetid, const payload[]) {
    if (!response) return 1;
    new playerBackPackId = Backpack:GetPlayerBackpackID(playerid);
    new targetBackPackId = Backpack:GetPlayerBackpackID(targetid);
    new cash;
    if (sscanf(inputtext, "d", cash) || cash < 1 || Backpack:GetInvItemQuantity(playerBackPackId, InvCash:Id) - cash < 0) return InvCash:ShareCash(playerid, targetid);
    Backpack:PopItem(playerBackPackId, InvCash:Id, cash);
    Backpack:PushItem(targetBackPackId, InvCash:Id, cash);
    SendClientMessage(playerid, -1, sprintf("[Backpack]: You shared $%s cash from backpack", FormatCurrency(cash)));
    return 1;
}