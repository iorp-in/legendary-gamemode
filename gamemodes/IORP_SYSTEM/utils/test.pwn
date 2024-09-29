cmd:tanim(playerid, const params[]) {
    if (!BetaTester:GetStatus(playerid)) return 0;
    new animlib[100], animname[100], Float:fDelta, loop, lockx, locky, tfreeze, time, forcesync;
    if (sscanf(params, "s[100] s[100] f d d d d d d", animlib, animname, Float:fDelta, loop, lockx, locky, tfreeze, time, forcesync)) return SendClientMessage(playerid, -1, "[TEST CMD]]: ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)");
    ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, tfreeze, time, forcesync);
    SendClientMessage(playerid, -1, "[TEST CMD]: animation applied");
    return 1;
}

cmd:camera(playerid, const params[]) {
    if (!IsPlayerInAnyVehicle(playerid) || GetPlayerAdminLevel(playerid) < 8) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:distance, Float:angle, Float:zoffset, cut;
    if (sscanf(params, "fffd", distance, angle, zoffset, cut) || cut < 1 || cut > 2) return AlexaMsg(playerid, "/camera distance angle zoffset cameramode", "Usage");
    new Float:pos[5];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    GetXYOnAngleVehicle(vehicleid, pos[3], pos[4], distance, angle);
    SetPlayerCameraPos(playerid, pos[3], pos[4], pos[2] + zoffset);
    SetPlayerCameraLookAt(playerid, pos[0], pos[1], pos[2], cut);
    return 1;
}

cmd:cameraoff(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    SetCameraBehindPlayer(playerid);
    return 1;
}

cmd:testobject(playerid, const params[]) {
    if (!IsTimePassedForPlayer(playerid, "objtest", 5 * 60) && GetPlayerAdminLevel(playerid) == 0) return 0;
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 5.0);
    new objectid = STREAMER_TAG_OBJECT:CreateDynamicObject(2654, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0);
    SetPreciseTimer("DeleteMyObject", 5000, false, "d", objectid);
    return 1;
}

forward DeleteMyObject(objectid);
public DeleteMyObject(objectid) {
    DestroyDynamicObjectEx(objectid);
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (GetPlayerScore(playerid) <= 10) {
        AlexaMsg(playerid, "you are eligible for free rewards, use /free");
    }
    return 1;
}

cmd:free(playerid, const params[]) {
    if (GetPlayerScore(playerid) > 10) return 0;
    AlexaMsg(playerid, "Congratulations! You have claimed free electronic items. Please remember to purchase them next time.");
    new expireAt = gettime() + 60 * 60 * 24 * 7;
    EtShop:SetAlexa(playerid, expireAt);
    EtShop:SetGps(playerid, expireAt);
    EtShop:SetMp3(playerid, expireAt);
    EtShop:SetPhone(playerid, expireAt);
    EtShop:SetTablet(playerid, expireAt);
    EtShop:SetRadio(playerid, expireAt);
    return 1;
}

//
// cmd:resetmotive(playerid, const params[]) {
//     ResetMotiveStatus(playerid);
//     DiseaseStopSymptoms(playerid);
//     player_thirst_data[playerid][sleep_count] = player_thirst_data[playerid][awake_count];
//     SendClientMessage(playerid, -1, "[Alexa]: your player status has been restored");
//     return 1;
// }

// hook OnAlexaResponse(playerid, const cmd[], const text[]) {
//     if(!BetaTester:GetStatus(playerid)) return 1;
//     if(IsStringContainWords(text, "please add house here")) {
//         CreateHouseRandom(playerid);
//         return ~1;
//     } else if(IsStringContainWords(text, "please add business here")) {
//         CreateBusinessRandom(playerid);
//         return ~1;
//     }
//     return 1;
// }

// new bool:diwaliReward[MAX_PLAYERS] = { false, ... };
// hook OnGameModeInit() {
//     Database:AddBool("diwalireward", false);
//     return 1;
// }
// 
// hook OnPlayerConnect(playerid) {
//     diwaliReward[playerid] = Database:GetBool(playerid, "diwalireward");
//     return 1;
// }
// 
// cmd:happydiwali(playerid, const params[]) {
//     SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}Hey, Happy Diwali. Let's celeberate it togather with amazing rewards from IORP");
//     if(diwaliReward[playerid]) {
//         SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}you have already claimed your diwali gift, which includes free VIP for two week and 1 lakh cash.");
//         return 1;
//     }
//     if(GetPlayerVIPLevel(playerid) != 0) {
//         new DB_Query[512];
//         format(DB_Query, sizeof DB_Query, "UPDATE playerdata SET vipLevelExpireAt = vipLevelExpireAt + (%d * 1000)  WHERE Username = \"%s\"", 14 * 24 * 60 * 60, GetPlayerNameEx(playerid));
//         mysql_tquery(Database, DB_Query);
//         SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}your vip level extended by 14 days for diwali reward.");
//     } else {
//         SetPlayerVIPLevel(playerid, 2);
//         new DB_Query[512];
//         format(DB_Query, sizeof DB_Query, "UPDATE playerdata SET vipLevel = 2, vipLevelExpireAt = (%d * 1000)  WHERE Username = \"%s\"", gettime() + 14 * 24 * 60 * 60, GetPlayerNameEx(playerid));
//         mysql_tquery(Database, DB_Query);
//         SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}you have recieved level 2 VIP access for 14 days as diwali reward.");
//     }
//     SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}you have recieved 1 lakh cash of diwali reward.");
//     GivePlayerCash(playerid, 100000, "Diwali Reward");
//     diwaliReward[playerid] = true;
//     Database:UpdateBool(playerid, "diwalireward", true);
//     SendClientMessage(playerid, -1, "{F1C40F}[Alexa]: {FFFFFF}Thank you for choosing IORP for your pricious day. Enjoy your diwali with joy and happiness.");
//     return 1;
// }


// #include "Include/sampvoice"
// 
// new SV_GSTREAM:gstream = SV_NULL;
// new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
// 
// /*
//     The public OnPlayerActivationKeyPress and OnPlayerActivationKeyRelease
//     are needed in order to redirect the player's audio traffic to the
//     corresponding streams when the corresponding keys are pressed.
// */
// 
// public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) {
//     // Attach player to local stream as speaker if 'B' key is pressed
//     if(keyid == 0x42 && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);
//     // Attach the player to the global stream as a speaker if the 'Z' key is pressed
//     if(keyid == 0x5A && gstream) SvAttachSpeakerToStream(gstream, playerid);
// }
// 
// public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid) {
//     // Detach the player from the local stream if the 'B' key is released
//     if(keyid == 0x42 && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
//     // Detach the player from the global stream if the 'Z' key is released
//     if(keyid == 0x5A && gstream) SvDetachSpeakerFromStream(gstream, playerid);
// }
// 
// hook OnPlayerConnect(playerid) {
//     // Checking for plugin availability
//     if(SvGetVersion(playerid) == SV_NULL) {
//         SendClientMessage(playerid, -1, "Could not find plugin sampvoice.");
//     }
//     // Checking for a microphone
//     else if(SvHasMicro(playerid) == SV_FALSE) {
//         SendClientMessage(playerid, -1, "The microphone could not be found.");
//     }
//     // Create a local stream with an audibility distance of 40.0, an unlimited number of listeners
//     // and the name 'Local' (the name 'Local' will be displayed in red in the players' speakerlist)
//     else if((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Local"))) {
//         SendClientMessage(playerid, -1, "Press Z to talk to global chat and B to talk to local chat.");
// 
//         // Attach the player to the global stream as a listener
//         if(gstream) SvAttachListenerToStream(gstream, playerid);
// 
//         // Assign microphone activation keys to the player
//         SvAddKey(playerid, 0x42);
//         SvAddKey(playerid, 0x5A);
//     }
// }
// 
// hook OnPlayerDisconnect(playerid, reason) {
//     // Removing the player's local stream after disconnecting
//     if(lstream[playerid]) {
//         SvDeleteStream(lstream[playerid]);
//         lstream[playerid] = SV_NULL;
//     }
// }
// 
// hook OnGameModeInit() {
//     // Uncomment the line to enable debug mode
//     // SvDebug(SV_TRUE);
// 
//     gstream = SvCreateGStream(0xffff0000, "Global");
// }
// 
// hook OnGameModeExit() {
//     if(gstream) SvDeleteStream(gstream);
// }