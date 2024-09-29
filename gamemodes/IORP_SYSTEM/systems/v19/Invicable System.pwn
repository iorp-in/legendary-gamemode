new bool:InvicableAuth:Data[MAX_PLAYERS];

stock InvicableAuth:SetPlayer(playerid, bool:status) {
    if (!IsPlayerConnected(playerid)) return 1;
    InvicableAuth:Data[playerid] = status;
    SetPlayerHealthEx(playerid, 100);
    SetPlayerHealth(playerid, Float:0x7F800000);
    return 1;
}

stock InvicableAuth:GetPlayer(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    return bool:InvicableAuth:Data[playerid];
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    InvicableAuth:SetPlayer(playerid, false);
    return 1;
}

APCP:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (GetPlayerAdminLevel(playerid) >= 9 && !InvicableAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Enable Player Invincible Mode");
    if (GetPlayerAdminLevel(playerid) >= 9 && InvicableAuth:GetPlayer(targetid)) APCP:AddCommand(playerid, "Disable Player Invincible Mode");
    return 1;
}

APCP:OnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("Enable Player Invincible Mode", inputtext)) {
        InvicableAuth:SetPlayer(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s invincible mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled invincible mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Player Invincible Mode", inputtext)) {
        InvicableAuth:SetPlayer(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s invincible mode", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled invincible mode for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return 1;
}