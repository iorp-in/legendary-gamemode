new alexa_docid;

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "alexa", "int", "0");
    alexa_docid = Doc:GetFreeID();
    new string[2000];
    strcat(string, "{db6600}Alexa: {FFFFEE}Acess all alexa commands using this format - /alexa [cmd]\n\n");
    strcat(string, "{db6600}Chat Animation: {FFFFEE}enable/disable chat animation\n");
    strcat(string, "{db6600}GPS System: {FFFFEE}gps\n");
    strcat(string, "{db6600}Unbug System: {FFFFEE}i am buged, unbug me\n");
    Doc:Add(0, alexa_docid, "Alexa Commands", string);
    return 1;
}

new EtShop:DataAlexa[MAX_PLAYERS];

stock EtShop:IsAlexaActive(playerid) {
    return gettime() < EtShop:DataAlexa[playerid];
}

stock EtShop:GetAlexa(playerid) {
    return EtShop:DataAlexa[playerid];
}

stock EtShop:SetAlexa(playerid, expireAt) {
    EtShop:DataAlexa[playerid] = expireAt;
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetAlexa(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "alexa"));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(EtShop:GetAlexa(playerid), GetPlayerNameEx(playerid), "username", "alexa");
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 32) return 1;
    if (EtShop:IsAlexaActive(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have alexa kit, no need to purchase it again until it expires.");
        return ~1;
    }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase alexa kit"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetAlexa(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased alexa kit. Validity: 30 days");
    return ~1;
}

CMD:alexa(playerid, const params[]) {
    new string[144];
    sscanf(params, "s[144]", string);
    if (strlen(string) == 0) return CallRemoteFunction("OnAlexaResponse", "d", playerid);
    new cmd[50];
    GetWord(string, 0, cmd);
    return CallRemoteFunction("OnAlexaResponse", "dss", playerid, cmd, string);
}

forward OnAlexaCommand(playerid, const cmd[], const text[]);
public OnAlexaCommand(playerid, const cmd[], const text[]) {
    return 1;
}

forward OnAlexaResponse(playerid, const cmd[], const text[]);
public OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "i am buged, unbug me") && (!IsPlayerFreezed(playerid) || IsPlayerFreezedForDeath(playerid))) {
        unbug(playerid);
        return ~1;
    } else if (IsStringContainWords(text, "unbug player") && GetPlayerAdminLevel(playerid) > 0) {
        new extraid = INVALID_PLAYER_ID;
        if (sscanf(GetNextWordFromString(text, "player"), "u", extraid)) extraid = playerid;
        if (!IsPlayerConnected(extraid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Invalid PlayerID");
            return ~1;
        }
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have unbuged %s", GetPlayerNameEx(extraid)));
        SendClientMessageEx(extraid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}A Admin %s unbuged you", GetPlayerNameEx(playerid)));
        unbug(extraid, true);
        return ~1;
    }

    if (IsStringContainWords(text, "clear global chat")) {
        for (new i; i < 20; i++) SendClientMessageEx(playerid, -1, "");
        return ~1;
    }

    if (IsStringContainWords(text, "i want to suicide, please kill me")) {
        if (!IsTimePassedForPlayer(playerid, "suicide", 15 * 60)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} wait for 15 minutes to suicide again");
        SetPlayerHealthEx(playerid, -1);
        return ~1;
    }

    if (!EtShop:IsAlexaActive(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}you don't have alexa communcation kit, Get one from electronics shop");
    Alexa(playerid, text, 111);
    return 1;
    // GetWord(string, 0, alexa_cmd);
    // if(strcmp(alexa_cmd, "alexa_cmd")) return SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}%s", string));
    // GetWord(string, 1, alexa_cmd);
    // strreplace(string, "alexa_cmd ", "");
    // strreplace(string, sprintf("%s ", alexa_cmd), "");
    // return CallRemoteFunction("OnAlexaCommand", "dss", playerid, alexa_cmd, string);
    //callcmd::gc(playerid, text);
    //return 1;
}

hook OnAlexaReply(playerid, const response[], offset) {
    if (offset != 111) return 1;
    new string[512], alexa_cmd[100];
    format(string, sizeof string, "%s", response);
    GetWord(string, 0, alexa_cmd);
    if (strcmp(alexa_cmd, "alexa_cmd")) return SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}%s", string));
    GetWord(string, 1, alexa_cmd);
    strreplace(string, "alexa_cmd ", "");
    strreplace(string, sprintf("%s ", alexa_cmd), "");
    return CallRemoteFunction("OnAlexaCommand", "dss", playerid, alexa_cmd, string);
}