#include "IORP_SYSTEM/systems/v19/pong.pwn"
#include <YSI_Coding\y_hooks>

new TMPPlayerObjectID[MAX_PLAYERS];
hook OnGameModeInit() {
    CreatePongGame(2490.420166, -1697.212280, 1015.730041, 0.0, 90.0, 3, 0); // CJ's House
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    TMPPlayerObjectID[playerid] = -1;
    return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ) {
    if (playerobject && TMPPlayerObjectID[playerid] == objectid) {
        if (!IsPlayerAdmin(playerid)) {
            DestroyPlayerObject(playerid, objectid);
            TMPPlayerObjectID[playerid] = -1;
            return 1;
        }
        switch (response) {
            case EDIT_RESPONSE_FINAL:  {
                DestroyPlayerObject(playerid, objectid);
                TMPPlayerObjectID[playerid] = -1;
                new int = GetPlayerInterior(playerid), vw = GetPlayerVirtualWorld(playerid);
                if (CreatePongGame(fX, fY, fZ, fRotX, fRotZ, int, vw) == -1) SendClientMessageEx(playerid, 0xFF0000FF, "Failed to create Pong Game.");
                else SendClientMessageEx(playerid, 0x00FF00FF, "Successfully created Pong Game.");
                printf("\nCreatePongGame(%f, %f, %f, %f, %f, %d, %d);\n", fX, fY, fZ, fRotX, fRotZ, int, vw);
            }
            case EDIT_RESPONSE_CANCEL:  {
                DestroyPlayerObject(playerid, objectid);
                TMPPlayerObjectID[playerid] = -1;
                SendClientMessageEx(playerid, -1, "Cancelled Pong Game Creation.");
            }
        }
    }
    return 1;
}

CMD:pexit(playerid, params[]) // Debug CMD for exiting a Pong Game without stopping it
{
    TogglePlayerSpectatingEx(playerid, false);
    SetPlayerPos(playerid, PlayerPongInfo[playerid][ppgX], PlayerPongInfo[playerid][ppgY], PlayerPongInfo[playerid][ppgZ]);
    SetPlayerFacingAngle(playerid, PlayerPongInfo[playerid][ppgA]);
    SetCameraBehindPlayer(playerid);
    SetPlayerInteriorEx(playerid, PlayerPongInfo[playerid][ppgInterior]);
    SetPlayerVirtualWorldEx(playerid, PlayerPongInfo[playerid][ppgVirtualWorld]);
    return 1;
}

CMD:phost(playerid, params[]) {
    new id = GetPlayerPongArea(playerid);
    if (id == -1 || !HostPongGame(id, playerid)) SendClientMessageEx(playerid, -1, "There's no Pong Game nearby.");
    return 1;
}

CMD:phostlocal(playerid, params[]) {
    new id = GetPlayerPongArea(playerid);
    if (id == -1 || !HostPongGame(id, playerid, playerid)) SendClientMessageEx(playerid, -1, "There's no Pong Game nearby.");
    return 1;
}

CMD:pjoin(playerid, params[]) {
    new id = GetPlayerPongArea(playerid);
    if (id == -1 || !PutPlayerInPongGame(playerid, id)) SendClientMessageEx(playerid, -1, "There's no Pong Game nearby.");
    return 1;
}

CMD:pstart(playerid, params[]) {
    new id = GetPlayerPongID(playerid);
    if (!IsValidPongGame(id)) return SendClientMessageEx(playerid, -1, "You are in no Pong Game.");
    StartPongGame(id);
    return 1;
}

CMD:pscore(playerid, params[]) {
    new id = GetPlayerPongID(playerid), playerid_a;
    GetPongPlayers(id, playerid_a);
    if (!IsValidPongGame(id) || playerid_a != playerid) return SendClientMessageEx(playerid, -1, "You are not the Host of a Pong Game.");
    if (!strlen(params) || !strlen(params) || strlen(params) > 5) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    new val = strval(params);
    if (val < 1 || val > 20) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    SetPongGameScore(id, val);
    SendClientMessageEx(playerid, -1, "[PONG] Score updated.");
    return 1;
}

CMD:prounds(playerid, params[]) {
    new id = GetPlayerPongID(playerid), playerid_a;
    GetPongPlayers(id, playerid_a);
    if (!IsValidPongGame(id) || playerid_a != playerid) return SendClientMessageEx(playerid, -1, "You are not the Host of a Pong Game.");
    if (!strlen(params) || !strlen(params) || strlen(params) > 5) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    new val = strval(params);
    if (val < 1 || val > 20) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    SetPongGameRounds(id, val);
    SendClientMessageEx(playerid, -1, "[PONG] Num. Rounds updated.");
    return 1;
}

CMD:pspeed(playerid, params[]) {
    new id = GetPlayerPongID(playerid), playerid_a;
    GetPongPlayers(id, playerid_a);
    if (!IsValidPongGame(id) || playerid_a != playerid) return SendClientMessageEx(playerid, -1, "You are not the Host of a Pong Game.");
    if (!strlen(params) || !strlen(params) || strlen(params) > 5) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    new Float:val = floatstr(params);
    if (val < 0.5 || val > 5.0) return SendClientMessageEx(playerid, -1, "Invalid Value.");
    SetPongGameSpeed(id, val);
    SendClientMessageEx(playerid, -1, "[PONG] Game Speed updated.");
    return 1;
}

CMD:pcreate(playerid, params[]) {
    if (GetPlayerAdminLevel(playerid) != 10) return 1;
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    x += 1.7 * floatsin(-a, degrees);
    y += 1.7 * floatcos(-a, degrees);
    TMPPlayerObjectID[playerid] = CreatePlayerObject(playerid, PONG_MODEL, x, y, z, 0.0, 0.0, a, 999.0);
    if (IsValidPlayerObject(playerid, TMPPlayerObjectID[playerid])) EditPlayerObject(playerid, TMPPlayerObjectID[playerid]);
    else TMPPlayerObjectID[playerid] = -1;
    return 1;
}

CMD:pend(playerid, params[]) {
    new id = GetPlayerPongID(playerid);
    if (!IsValidPongGame(id)) id = GetPlayerPongArea(playerid);
    if (id == -1) return SendClientMessageEx(playerid, -1, "There's no Pong Game nearby.");
    EndPongGame(id);
    return 1;
}

CMD:pdestroy(playerid, params[]) {
    if (GetPlayerAdminLevel(playerid) != 10) return 1;
    if (!strlen(params) || strlen(params) > 5) return SendClientMessageEx(playerid, -1, "Invalid ID.");
    new id = strval(params);
    if (!IsValidPongGame(id)) return SendClientMessageEx(playerid, -1, "ID does not exist.");
    DestroyPongGame(id);
    return 1;
}

CMD:pinfo(playerid, params[]) {
    if (GetPlayerAdminLevel(playerid) != 10) return 1;
    new id = GetPlayerPongArea(playerid);
    if (id == -1) return SendClientMessageEx(playerid, -1, "There's no Pong Game nearby.");
    new text[80];
    format(text, sizeof(text), "Pong Game ID: %d, State: %d, Int: %d, VW: %d", id, GetPongGameState(id), GetPongGameInterior(id), GetPongGameVirtualWorld(id));
    SendClientMessageEx(playerid, 0x99FF00AA, text);
    return 1;
}

CMD:phelp(playerid, params[]) {
    SendClientMessageEx(playerid, 0xCCFFDD56, "[PONG] Commands");
    SendClientMessageEx(playerid, 0xCCFFDD56, "/phost|phostlocal|pjoin|pstart|pexit|pend");
    SendClientMessageEx(playerid, 0xCCFFDD56, "/pscore|prounds|pspeed [value]");
    if (GetPlayerAdminLevel(playerid) == 10) {
        SendClientMessageEx(playerid, 0xAAFFCC88, "[PONG] Admin Commands");
        SendClientMessageEx(playerid, 0xAAFFCC88, "/pcreate|pinfo");
        SendClientMessageEx(playerid, 0xAAFFCC88, "/pdestroy [id]");
    }
    return 1;
}