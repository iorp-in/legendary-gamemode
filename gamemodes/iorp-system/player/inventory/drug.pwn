#define BackpackInvColumn_Drug "Drug"
#define InvLimit_Drug 200

new DrugInvID;

hook OnInventoryInit() {
    DrugInvID = Backpack:AddInventoryItem("Drug", InvLimit_Drug);
    Database:AddColumn(BackpackDB, BackpackInvColumn_Drug, "int", "0");
    return 1;
}

hook OnBackpackLoad(backPackId) {
    Backpack:PushItem(backPackId, DrugInvID, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Drug, BackpackDB));
    return 1;
}

hook OnBackpackSave(backPackId) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, DrugInvID), sprintf("%d", backPackId), "id", BackpackInvColumn_Drug, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backPackId) {
    Backpack:PopItem(backPackId, DrugInvID, Backpack:GetInvItemQuantity(backPackId, DrugInvID));
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId != DrugInvID) return 1;
    if (Backpack:GetInvItemQuantity(backPackId, DrugInvID) < 1) {
        AlexaMsg(playerid, "There is no drug in the backpack");
    } else {
        Drug:BackpackMenu(playerid, backPackId);
    }
    return ~1;
}

stock Drug:BackpackMenu(playerid, backPackId) {
    new string[512];
    strcat(string, sprintf("Take\t%d grams\n", Backpack:GetInvItemQuantity(backPackId, DrugInvID)));
    strcat(string, sprintf("Put\t%d grams\n", Drug:Get(playerid)));
    return FlexPlayerDialog(playerid, "DrugBackpackMenu", DIALOG_STYLE_TABLIST, "Backpack > Drug", string, "Select", "Close", backPackId);
}

FlexDialog:DrugBackpackMenu(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Take")) return Drug:BackpackMenuTake(playerid, backPackId);
    if (IsStringSame(inputtext, "Put")) return Drug:BackpackMenuPut(playerid, backPackId);
    return 1;
}

stock Drug:BackpackMenuTake(playerid, backPackId) {
    if (Drug:Get(playerid) >= DRUG_CARRY_LIMIT) {
        AlexaMsg(playerid, "The number of drugs you can hold is limited");
        return Drug:BackpackMenu(playerid, backPackId);
    }

    new limit = Backpack:GetInvItemQuantity(backPackId, DrugInvID);
    if (limit > DRUG_CARRY_LIMIT - Drug:Get(playerid)) limit = DRUG_CARRY_LIMIT - Drug:Get(playerid);

    return FlexPlayerDialog(playerid, "DrugBackpackMenuTake", DIALOG_STYLE_INPUT, "Backpack > Drug",
        sprintf("Enter amount of drugs you want to take from backpack\nLimit: 1 to %d", limit),
        "Take", "Close", backPackId
    );
}

FlexDialog:DrugBackpackMenuTake(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    new limit = Backpack:GetInvItemQuantity(backPackId, DrugInvID);
    if (limit > DRUG_CARRY_LIMIT - Drug:Get(playerid)) limit = DRUG_CARRY_LIMIT - Drug:Get(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > limit) return Drug:BackpackMenuTake(playerid, backPackId);
    Backpack:PopItem(backPackId, DrugInvID, amount);
    Drug:Increase(playerid, amount);
    AlexaMsg(playerid, sprintf("You have taken %d grams of drugs from your backpack", amount));
    return 1;
}

stock Drug:BackpackMenuPut(playerid, backPackId) {
    if (Drug:Get(playerid) < 1) {
        AlexaMsg(playerid, "There are no drugs in your hand");
        return Drug:BackpackMenu(playerid, backPackId);
    }

    new limit = InvLimit_Drug - Backpack:GetInvItemQuantity(backPackId, DrugInvID);
    if (limit > Drug:Get(playerid)) limit = Drug:Get(playerid);

    return FlexPlayerDialog(playerid, "DrugBackpackMenuPut", DIALOG_STYLE_INPUT, "Backpack > Drug",
        sprintf("Enter amount of drugs you want to put in backpack\nLimit: 1 to %d", limit),
        "Put", "Close", backPackId
    );
}

FlexDialog:DrugBackpackMenuPut(playerid, response, listitem, const inputtext[], backPackId, const payload[]) {
    if (!response) return 1;
    new limit = InvLimit_Drug - Backpack:GetInvItemQuantity(backPackId, DrugInvID);
    if (limit > Drug:Get(playerid)) limit = Drug:Get(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > limit) return Drug:BackpackMenuPut(playerid, backPackId);
    Backpack:PushItem(backPackId, DrugInvID, amount);
    Drug:Increase(playerid, -amount);
    AlexaMsg(playerid, sprintf("You have stored %d grams of drugs in your backpack", amount));
    return 1;
}