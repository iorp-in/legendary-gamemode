new bool:RP_Mode[MAX_PLAYERS];

stock GetPlayerRPMode(playerid) {
    return RP_Mode[playerid];
}

forward SetPlayerRPMode(playerid, bool:status);
public SetPlayerRPMode(playerid, bool:status) {
    RP_Mode[playerid] = status;
    return RP_Mode[playerid];
}

forward EnablePlayerRPMode(playerid);
public EnablePlayerRPMode(playerid) {
    SetPlayerRPMode(playerid, true);
    GameTextForPlayer(playerid, "~w~Fight Mode ~g~Enabled", 2000, 3);
    if (GetPlayerScore(playerid) < 50) {
        AlexaMsg(playerid, "The players who are in fight mode cannot be seen in your map, and those who can be seen are not fighting.");
        AlexaMsg(playerid, "The server will ban you if you kill a player who is not in fight mode due to a deathmatch.");
        AlexaMsg(playerid, "You are permitted to engage in combat with other players who are also in fight mode.");
        AlexaMsg(playerid, "By turning on fight mode, you acknowledge that you accept our terms.");
    }
    CallRemoteFunction("OnPlayerEnableRPMODE", "d", playerid);
    return 1;
}

forward DisablePlayerRPMode(playerid);
public DisablePlayerRPMode(playerid) {
    SetPlayerRPMode(playerid, false);
    GameTextForPlayer(playerid, "~w~Fight Mode ~r~Disabled", 2000, 3);
    CallRemoteFunction("OnPlayerDisableRPMODE", "d", playerid);
    return 1;
}

forward OnPlayerEnableRPMODE(playerid);
public OnPlayerEnableRPMODE(playerid) {
    return 1;
}

forward OnPlayerDisableRPMODE(playerid);
public OnPlayerDisableRPMODE(playerid) {
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPlayerRPMode(playerid, true);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (GetPlayerRPMode(playerid)) return DisablePlayerRPMode(playerid);
    return 1;
}

CMD:fightmode(playerid, const params[]) {
    if (IsPlayerInHeist(playerid) || Event:IsInEvent(playerid)) return GameTextForPlayer(playerid, "~w~Fight Mode ~r~Not Allowed", 2000, 3);
    if (
        GetPlayerWantedLevelEx(playerid) > 0 && GetPlayerRPMode(playerid)
    ) return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Alexa] When you are a wanted player, you cannot disable fight mode.");
    // if (Faction:IsPlayerSigned(playerid) && GetPlayerRPMode(playerid)) return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Alexa] you can not disable fight mode when you are sign in.");
    if (
        gettime() - GetLastGpsTp(playerid) < 3 * 60
    ) return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Alexa] The fight mode can't be used after GPS teleportation, you need to wait three minutes.");
    if (!IsTimePassedForPlayer(playerid, "RpModeCMDCD", 60)) return SendClientMessage(playerid, COLOR_LIGHTYELLOW, "[Alexa] Wait one minute before using fight mode again, it's not allowed to use it frequently.");
    if (GetPlayerRPMode(playerid)) return DisablePlayerRPMode(playerid);
    EnablePlayerRPMode(playerid);
    SendRPMessageToAll(playerid, 100.0, COLOR_MEDIUMPURPLE, sprintf("*%s puts him/her self in defensive position and ready to engage in fight.", GetPlayerNameEx(playerid)));
    return 1;
}

new NonRPWeapons[] = { 0, 1, 2, 3, 5, 6, 7, 10, 11, 12, 13, 14, 15, 18, 41, 42, 43, 44, 45, 46 };

hook OnPlayerUpdate(playerid) {
    if (!GetPlayerRPMode(playerid) && !Event:IsInEvent(playerid)) {
        new weaponid = GetPlayerWeapon(playerid);
        if (!IsArrayContainNumber(NonRPWeapons, weaponid)) {
            EnablePlayerRPMode(playerid);
        }
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Enable/Disable Fight Mode");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Enable/Disable Fight Mode", inputtext)) {
        callcmd::fightmode(playerid, "");
        return ~1;
    }
    return 1;
}