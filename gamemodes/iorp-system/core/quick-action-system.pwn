QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    QuickActions:AddCommand(playerid, "Give Player Cash");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Give Player Cash", inputtext)) return GiveCashMenu(playerid, targetid);
    return 1;
}

stock GiveCashMenu(playerid, toplayerid) {
    return FlexPlayerDialog(
        playerid, "GiveCashMenu", DIALOG_STYLE_INPUT,
        sprintf("Give cash to %s", GetPlayerNameEx(toplayerid)),
        "Enter amount between $1 to $10,000\n\nyou can use bank to share large amount at once",
        "Give", "Cancel", toplayerid
    );
}

FlexDialog:GiveCashMenu(playerid, response, listitem, const inputtext[], toplayerid, const payload[]) {
    if (!response || !IsPlayerConnected(toplayerid)) return 1;
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > 10000 || GetPlayerCash(playerid) < amount) return GiveCashMenu(playerid, toplayerid);
    return FlexPlayerDialog(toplayerid, "GiveCashOffer", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]: {FFFFEE}Confirm Money Request",
        sprintf("%s send you $%s money\ndo you want to confirm or reject money", GetPlayerNameEx(playerid), FormatCurrency(amount)),
        "Accept", "Reject", playerid, sprintf("%d", amount)
    );
}

FlexDialog:GiveCashOffer(playerid, response, listitem, const inputtext[], fromplayerid, const payload[]) {
    new amount = strval(payload);
    if (!response || !IsPlayerConnected(fromplayerid) || amount < 1 || amount > 10000 || GetPlayerCash(fromplayerid) < amount) {
        AlexaMsg(playerid, "you have rejected cash offer");
        return AlexaMsg(fromplayerid, "the player rejected your cash offer");
    }
    if (!IsTimePassedForPlayer(fromplayerid, "GiveCashRateLimit", 120)) {
        AlexaMsg(playerid, "transaction cancelled....");
        AlexaMsg(fromplayerid, "the transaction cancelled by server, it's not allowed to do frequent, use bank to give large amount at once");
        AlexaMsg(fromplayerid, sprintf("try to use give cash offer after %s", UnixToHumanEx(GetLastTimeForPlayer(playerid, "GiveCashRateLimit") + 120)));
        return 1;
    }
    AlexaMsg(fromplayerid, sprintf("you have given $%s cash to %s", FormatCurrency(amount), GetPlayerNameEx(playerid)));
    AlexaMsg(playerid, sprintf("you have recieved $%s cash from %s", FormatCurrency(amount), GetPlayerNameEx(fromplayerid)));
    GivePlayerCash(playerid, amount, sprintf("receieved cash from %s", GetPlayerNameEx(fromplayerid)));
    GivePlayerCash(fromplayerid, -amount, sprintf("give cash to %s", GetPlayerNameEx(playerid)));
    return 1;
}