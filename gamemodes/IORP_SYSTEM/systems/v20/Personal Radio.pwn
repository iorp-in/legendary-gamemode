enum PRadio:EnumData {
    PRadio:expireat,
    PRadio:frequency,
    PRadio:mute,
    PRadio:speaker,
}
new PRadio:PlayerData[MAX_PLAYERS][PRadio:EnumData];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "personalradio", "int", "0");
    Database:AddColumn("playerdata", "frequency", "int", "-1");
    Database:AddColumn("playerdata", "vcmute", "tinyint", "0");
    Database:AddColumn("playerdata", "vcspeaker", "tinyint", "0");
    return 1;
}

stock PRadio:IsUsingRadio(playerid) {
    return PRadio:PlayerData[playerid][PRadio:frequency] == -1 ? 0 : 1;
}

stock PRadio:GetFrequency(playerid) {
    return PRadio:PlayerData[playerid][PRadio:frequency];
}

stock PRadio:SetFrequency(playerid, frequency) {
    if (frequency < -1 || frequency > 49) PRadio:PlayerData[playerid][PRadio:frequency] = -1;
    else PRadio:PlayerData[playerid][PRadio:frequency] = frequency;
    Database:UpdateInt(frequency, GetPlayerNameEx(playerid), "username", "frequency");
    return 1;
}

stock EtShop:IsRadioActive(playerid) {
    return gettime() < PRadio:PlayerData[playerid][PRadio:expireat];
}

stock EtShop:GetRadio(playerid) {
    return PRadio:PlayerData[playerid][PRadio:expireat];
}

stock EtShop:SetRadio(playerid, expireAt) {
    PRadio:PlayerData[playerid][PRadio:expireat] = expireAt;
    return 1;
}

stock PRadio:onFrequency(frequency, const message[]) {
    new count = 0;
    if (frequency < 0 || frequency > 49) return count;
    foreach(new i:Player) {
        if (PRadio:IsUsingRadio(i)) {
            if (frequency == PRadio:GetFrequency(i)) {
                SendClientMessageEx(i, -1, message);
                count++;
            }
        }
    }
    return count;
}

stock PRadio:onRadio(playerid, const message[]) {
    if (!PRadio:IsUsingRadio(playerid)) return 1;
    LogNormal(sprintf("[PRadio][%d] [%s]: %s", PRadio:GetFrequency(playerid), GetPlayerNameEx(playerid), FormatMention(message)));
    return PRadio:onFrequency(PRadio:GetFrequency(playerid), FormatMention(message));
}

hook OnPlayerLogin(playerid) {
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "vcmute");
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "vcspeaker");
    return 1;
}

hook OnPlayerConnect(playerid) {
    PRadio:SetFrequency(playerid, -1);
    PRadio:PlayerData[playerid][PRadio:speaker] = false;
    PRadio:PlayerData[playerid][PRadio:mute] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    PRadio:SetFrequency(playerid, -1);
    Database:UpdateInt(EtShop:GetRadio(playerid), GetPlayerNameEx(playerid), "username", "personalradio");
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 36) return 1;
    if (EtShop:IsRadioActive(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have personal readio, no need to purchase it again until it expires."); return ~1; }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase personal readio"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    new expireAt = gettime() + 30 * 24 * 60 * 60;
    EtShop:SetRadio(playerid, expireAt);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased personal radio. Validity: 30 days");
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 0 || !PRadio:IsUsingRadio(playerid)) return 1;
    if (PRadio:PlayerData[playerid][PRadio:mute]) UCP:AddCommand(playerid, "0> Unmute Voice Chat", true);
    else UCP:AddCommand(playerid, "0> Mute Voice Chat", true);
    if (PRadio:PlayerData[playerid][PRadio:speaker]) UCP:AddCommand(playerid, "1> Open Speaker Voice Chat", true);
    else UCP:AddCommand(playerid, "1> Close Speaker Voice Chat", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0 || !PRadio:IsUsingRadio(playerid)) return 1;
    if (IsStringSame("0> Mute Voice Chat", inputtext)) {
        PRadio:PlayerData[playerid][PRadio:mute] = true;
        Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "vcmute");
        AlexaMsg(playerid, "your mic is now close at discord.");
        return ~1;
    }
    if (IsStringSame("0> Unmute Voice Chat", inputtext)) {
        PRadio:PlayerData[playerid][PRadio:mute] = false;
        Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "vcmute");
        AlexaMsg(playerid, "your mic is now open at discord.");
        return ~1;
    }
    if (IsStringSame("1> Close Speaker Voice Chat", inputtext)) {
        PRadio:PlayerData[playerid][PRadio:speaker] = true;
        Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "vcspeaker");
        AlexaMsg(playerid, "your speaker is now close at discord.");
        return ~1;
    }
    if (IsStringSame("1> Open Speaker Voice Chat", inputtext)) {
        PRadio:PlayerData[playerid][PRadio:speaker] = false;
        Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "vcspeaker");
        AlexaMsg(playerid, "your speaker is now open at discord.");
        return ~1;
    }
    return 1;
}

cmd:vcstatus(playerid, const params[]) {
    if (!PRadio:IsUsingRadio(playerid)) return AlexaMsg(playerid, "use /vcset to turn on voice chat");
    new frequency = PRadio:GetFrequency(playerid);
    AlexaMsg(playerid, FormatColors(sprintf("~y~Frequency: ~b~%d", frequency)));
    AlexaMsg(playerid, FormatColors(sprintf(
        "~y~Mic: %s ~y~Spearker: %s", PRadio:PlayerData[playerid][PRadio:mute] ? "~r~Close" : "~g~Open",
        PRadio:PlayerData[playerid][PRadio:speaker] ? "~r~Close" : "~g~Open"
    )));
    new count = 0;
    foreach(new i:Player) {
        if (PRadio:IsUsingRadio(i)) {
            if (frequency == PRadio:GetFrequency(i) && i != playerid) {
                AlexaMsg(playerid, FormatColors(sprintf("%s is your voice chat", GetPlayerNameEx(i))));
                count++;
            }
        }
    }
    if (count > 0) AlexaMsg(playerid, FormatColors(sprintf("~y~Total players in your voice chat: ~b~%d", count)));
    return 1;
}

cmd:vcset(playerid, const params[]) {
    if (!EtShop:IsRadioActive(playerid)) return AlexaMsg(playerid, "you don't have a radio, purchase one from an electronic store");
    new frequency;
    if (sscanf(params, "d", frequency) || frequency < -1 || frequency > 49) return AlexaMsg(playerid, "/vcset [frequency 0-49 and -1 to disable voice chat]");
    if (frequency == -1) SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are disconnect from radio chat.");
    else SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you are connected to frequency %d. Connect discord base voice chat for voice support.", frequency));
    PRadio:SetFrequency(playerid, frequency);
    PRadio:onFrequency(frequency, sprintf("[Personal Radio]: %s joined %d frequency, say hello", GetPlayerNameEx(playerid), frequency));
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "vcmute");
    return 1;
}

cmd:vc(playerid, const params[]) {
    if (!PRadio:IsUsingRadio(playerid)) return AlexaMsg(playerid, "use /vcset to turn on voice chat");
    new message[100];
    if (sscanf(params, "s[100]", message)) return AlexaMsg(playerid, "/vc [message]");
    PRadio:onRadio(playerid, sprintf("{FFFFFF}[Radio]%s:{FFFFFF} %s", GetPlayerNameEx(playerid), message));
    return 1;
}