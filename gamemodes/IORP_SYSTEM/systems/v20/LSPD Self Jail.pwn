hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 35) return 1;
    if (GetPlayerWantedLevelEx(playerid) < 1) { SendClientMessage(playerid, -1, "{4286f4}[SAPD]:{0000CD} you don't have any criminal records, you clean. Have a good day."); return ~1; }
    if (Heist:GetOnlineCops() > 0) { SendClientMessage(playerid, -1, "{4286f4}[SAPD]:{0000CD} you can not self surrender when cops are online, please contact 911."); return ~1; }
    SelfJailMenu(playerid);
    return ~1;
}

stock SelfJailMenu(playerid) {
    new string[512];
    strcat(string, "do you want to surrender yourself?\n");
    strcat(string, "if you select yes then we will send you to maximum security jail to spend your all crimes,\n");
    strcat(string, "you will not get out unless you have spent jail for all your remaining crimes.");
    return FlexPlayerDialog(playerid, "SelfJailMenu", DIALOG_STYLE_MSGBOX, "{4286f4}[SAPD]:{0000CD} Jail", string, "Yes", "No");
}

FlexDialog:SelfJailMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    WantedDatabase:SendJail(playerid);
    WantedDatabase:JailPlayer(playerid);
    return AlexaMsg(playerid, "you are sent to maximum security prison, if you try to break out, you will face the punishment", "SAPD");
}