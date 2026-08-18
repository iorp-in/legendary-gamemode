new AdvertisementMessage[MAX_PLAYERS][150];

CMD:ad(playerid, const params[]) {
    if (GetPlayerMutedStatus(playerid)) return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can't use this command while you are muted. request on forum.iorp.in for unmute.");
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 756.6661, -1374.3679, 14.2329)) return SendClientMessage(playerid, COLOR_WHITE, "please go to advertisement office to use this command");
    new msg[100];
    if (sscanf(params, "s[100]", msg)) return SyntaxMSG(playerid, "/ad [advertisement]");
    if (GetPlayerCash(playerid) < 500) return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Alexa]: {FFFFEE}you don't have $500 to pay for advertisement");
    if (!EtShop:IsPhoneActive(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Alexa]: {FFFFEE}you don't have phone to send advertisement");
    if (!IsTimePassedForPlayer(playerid, "AdCommand", 5 * 60)) return SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Alexa]: {FFFFEE}wait for 5 min to send advertisement again");
    SendClientMessageEx(playerid, COLOR_WHITE, "{db6600}[Alexa]: {FFFFEE}you have payed $500 for advertisement");
    vault:PlayerVault(playerid, -500, "charged for advertisement", Vault_ID_Government, 500, sprintf("%s charged for advertisement", GetPlayerNameEx(playerid)));
    format(AdvertisementMessage[playerid], 150, "*advertisement: %s (%s: %d)", FormatMention(msg), GetPlayerNameEx(playerid), Phone:GetPlayerNumber(playerid));
    SendClientMessageToAll(COLOR_YELLOW, AdvertisementMessage[playerid]);
    SetTimerEx("SendAdvertisement", 1 * 60 * 1000, false, "d", playerid);
    SetTimerEx("SendAdvertisement", 2 * 60 * 1000, false, "d", playerid);
    SetTimerEx("SendAdvertisement", 3 * 60 * 1000, false, "d", playerid);
    SetTimerEx("SendAdvertisement", 4 * 60 * 1000, false, "d", playerid);
    IncreaseRpCount(playerid);
    return 1;
}

forward SendAdvertisement(playerid);
public SendAdvertisement(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    SendClientMessageToAll(COLOR_YELLOW, AdvertisementMessage[playerid]);
    return 1;
}