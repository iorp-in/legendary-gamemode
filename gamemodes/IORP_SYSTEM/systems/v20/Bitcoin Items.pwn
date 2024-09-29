BitCoin:OnInit(playerid, page) {
    if (page != 0) return 1;
    // BitCoin:AddCommand(playerid, "Get 10k player money (10 BTC)");
    BitCoin:AddCommand(playerid, "Reset Hygiene, Thrist, Bladder  Motive (5 BTC)");
    BitCoin:AddCommand(playerid, "Reset Player All Disease (10 BTC)");
    BitCoin:AddCommand(playerid, "Reset Player Sleep (5 BTC)");
    BitCoin:AddCommand(playerid, "Refuel Current Vehicle to 100 (5 BTC)");
    BitCoin:AddCommand(playerid, "Reset Current Vehicle Health to 1000 (5 BTC)");
    return 1;
}

BitCoin:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    //    if(IsStringSame("Get 10k player money (10 BTC)", inputtext)) {
    //        if(BitCoin:Get(playerid) < 10) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
    //        BitCoin:GiveOrTake(playerid, -10, "purchased 10k player money");
    //        GivePlayerCash(playerid, 10000, "purchased 10k player money from btc");
    //        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you have purchased 10k player money. BTC Charged: 10 BTC.");
    //        return ~1;
    //    }
    if (IsStringSame("Reset Hygiene, Thrist, Bladder  Motive (5 BTC)", inputtext)) {
        if (BitCoin:Get(playerid) < 5) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
        BitCoin:GiveOrTake(playerid, -5, "hygiene, thrist, bladder motive reset");
        ResetMotiveStatus(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} your player hygiene, thrist, bladder motive has been reseted.  BTC Charged: 5 BTC.");
        return ~1;
    }
    if (IsStringSame("Reset Player All Disease (10 BTC)", inputtext)) {
        if (BitCoin:Get(playerid) < 10) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
        BitCoin:GiveOrTake(playerid, -10, "all disease resets");
        ResetMotiveDisease(playerid);
        DiseaseStopSymptoms(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} your player all disease has been reseted. BTC Charged: 10 BTC.");
        return ~1;
    }
    if (IsStringSame("Reset Player Sleep (5 BTC)", inputtext)) {
        if (BitCoin:Get(playerid) < 5) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
        BitCoin:GiveOrTake(playerid, -5, "sleep reset");
        ResetPlayerSleep(playerid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} your player sleep has been reseted. BTC Charged: 5 BTC.");
        return ~1;
    }
    if (IsStringSame("Refuel Current Vehicle to 100 (5 BTC)", inputtext)) {
        if (BitCoin:Get(playerid) < 5) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
        if (!IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you are not driving any vehicle."); return ~1; }
        BitCoin:GiveOrTake(playerid, -5, sprintf("refueled vehicle %s", GetVehicleName(GetPlayerVehicleID(playerid))));
        SetVehicleFuelEx(GetPlayerVehicleID(playerid), 100);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFCC66} you have refueled vehicle %s, BTC Charged: 5 BTC.", GetVehicleName(GetPlayerVehicleID(playerid))));
        return ~1;
    }
    if (IsStringSame("Reset Current Vehicle Health to 1000 (5 BTC)", inputtext)) {
        if (BitCoin:Get(playerid) < 5) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you don't have enough bitcoins, please reload your account at iorp.in"); return ~1; }
        if (!IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you are not driving any vehicle."); return ~1; }
        BitCoin:GiveOrTake(playerid, -5, sprintf("repaired vehicle %s", GetVehicleName(GetPlayerVehicleID(playerid))));
        SetVehicleHealthEx(GetPlayerVehicleID(playerid), 1000);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFCC66} you have repaired vehicle %s, BTC Charged: 5 BTC.", GetVehicleName(GetPlayerVehicleID(playerid))));
        return ~1;
    }
    return 1;
}