QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    QuickActions:AddCommand(playerid, "Give Player Cash");
    new skin_woman[] = { 9, 10, 11, 12, 13, 31, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298 };
    if (!IsArrayContainNumber(skin_woman, GetPlayerSkin(playerid))) {
        if (IsArrayContainNumber(skin_woman, GetPlayerSkin(targetid))) {
            new Float:phealth, Float:rhealth;
            GetPlayerHealth(playerid, Float:phealth);
            GetPlayerHealth(targetid, Float:rhealth);
            if (phealth > 80.00 && rhealth < 20.00 && rhealth > 5.00) QuickActions:AddCommand(playerid, "Rape Her");
        }
    }
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Give Player Cash", inputtext)) return GiveCashMenu(playerid, targetid);
    if (IsStringSame("Rape Her", inputtext)) {
        GameTextForPlayer(targetid, "you are raped", 2500, 3);
        SetPlayerHealthEx(targetid, 4.50);
        // new cash = GetPlayerCash(targetid);
        // GivePlayerCash(targetid, -cash, sprintf("rapped by %s", GetPlayerNameEx(playerid)));
        // GivePlayerCash(playerid, cash, sprintf("rapped %s", GetPlayerNameEx(targetid)));
        new string[512];
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}%s raped you, your health is now bad, call any emercency services as soon possible", GetPlayerNameEx(playerid));
        SendClientMessageEx(targetid, -1, string);
        format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}You just used force to have sex with %s. You are now on SAPD wanted list.", GetPlayerNameEx(targetid));
        SendClientMessageEx(playerid, -1, string);
        format(string, sizeof string, "raped %s", GetPlayerNameEx(targetid));
        WantedDatabase:GiveWantedLevel(playerid, string, Random(10, 20), false);
        return 1;
    }
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