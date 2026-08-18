

new Anti_Spam_Count[MAX_PLAYERS];
new Anti_Spam_Timer[MAX_PLAYERS];
new Anti_Spam_Warn[MAX_PLAYERS];
stock ResetChatSpamTimer(playerid) {
    if(Anti_Spam_Timer[playerid] != -1) KillTimer(Anti_Spam_Timer[playerid]), Anti_Spam_Timer[playerid] = -1;
    Anti_Spam_Timer[playerid] = SetTimerEx("ResetChatSpam", 1000, false, "d", playerid);
    return 1;
}
forward ResetChatSpam(playerid);
public ResetChatSpam(playerid) {
    Anti_Spam_Count[playerid] = 0;
    Anti_Spam_Timer[playerid] = -1;
    Anti_Spam_Warn[playerid] = 0;
    return 1;
}

hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    ResetChatSpam(playerid);
    return 1;
}

hook OnPlayerText(playerid, text[]) {
    Anti_Spam_Count[playerid]++;
    if(Anti_Spam_Count[playerid] > 1) {
        Anti_Spam_Warn[playerid]++;
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {8B0000}Warning[%d] you are few message away from being kicked!", Anti_Spam_Warn[playerid]));
        if(Anti_Spam_Warn[playerid] > 3) Kick(playerid);
        return -1;
    }
    ResetChatSpamTimer(playerid);
    return 0;
}