#include "IORP_SYSTEM/core/prefix.pwn"
#include "IORP_SYSTEM/core/includes.pwn"
#include "IORP_SYSTEM/core/forwards.pwn"
#include "IORP_SYSTEM/utils/Mod Shop Funcs.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/core/mysql_config.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/core/color_definations.pwn"
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/utils/Useful Funcitons.pwn" /////===== Useful Functions Locator =====/////
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/core/Server Side Functions.pwn" /////===== Server Side Functions =====/////
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/core/Server Side Native.pwn" /////===== Server Side Native =====/////

main() {
    new year, month, day;
    getdate(year, month, day);
    printf("\n-----------------------------------------------------------------\n\tRunning Indian Ocean Roleplay - by Harry Potter\n\tVersion: v%d.%d.%d\n-----------------------------------------------------------------", year, month, day);
}


#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/systems.pwn" /////===== Systems. =====/////

public OnGameModeInit() {
    Database:AddColumn("playerdata", "chatmode", "boolean", "0");
    OnGameModeInitEx();
    return 1;
}

stock OnGameModeInitEx() {
    if (GetServerVarAsInt("port") == 7778) SendRconCommand("mapname SA|VC|LC");
    SendRconCommand("hostname Indian Ocean Roleplay - Open Source Server");
    SetPreciseTimer("RemovePassword", 60 * 1000, false);
    // SendRconCommand("hostname IORP TM [Phase 5] - Maintenance Mode");
    SendRconCommand("language English");
    new year, month, day;
    getdate(year, month, day);
    SetGameModeText(sprintf("v%d.%d.%d", year, month, day));
    SetNameTagDrawDistance(40.0);
    //ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    //UsePlayerPedAnims();
    ShowNameTags(1);
    EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    ManualVehicleEngineAndLights();
    ServerTimers();
    new blacklisted[] = { 280, 281, 282, 283, 284, 285, 286, 287, 288 };
    for (new i = 0; i < 300; i++) {
        if (IsArrayContainNumber(blacklisted, i)) continue;
        AddPlayerClass(i, 2035.2452, -1413.6796, 16.9922, 132.8350, 0, 0, 0, 0, 0, 0);
    }
    return 1;
}

forward RemovePassword();
public RemovePassword() {
    SendRconCommand("password 0");
    Discord:SendGeneral("all set, you can join server now...");
    return 1;
}

new TimerID_HpTimeLine;
new TimerID_CheckVehicleHealth;
new TimerID_ConsumeFuel;
new TimerID_OnPlayerUpdateEx;
new Global15SecondIntervalEx;
new Global30SecondIntervalEx;
new GlobalOneMinuteIntervalEx;
new GlobalFiveMinuteIntervalEx;

stock ServerTimers() {
    TimerID_HpTimeLine = SetPreciseTimer("UpdateClock", 1000, true);
    TimerID_CheckVehicleHealth = SetPreciseTimer("CheckVehicleHealthHack", 10000, true);
    TimerID_ConsumeFuel = SetPreciseTimer("ConsumeFuel", 1000, true);
    TimerID_OnPlayerUpdateEx = SetPreciseTimer("OnPlayerUpdateExTimer", 1000, true);
    Global15SecondIntervalEx = SetPreciseTimer("Global15SecondInterval", 15 * 1000, true);
    Global30SecondIntervalEx = SetPreciseTimer("Global30SecondInterval", 30 * 1000, true);
    GlobalOneMinuteIntervalEx = SetPreciseTimer("GlobalOneMinuteInterval", 60 * 1000, true);
    GlobalFiveMinuteIntervalEx = SetPreciseTimer("GlobalFiveMinInterval", 5 * 60 * 1000, true);
    return 1;
}

stock KillServerTimers() {
    DeletePreciseTimer(TimerID_HpTimeLine);
    DeletePreciseTimer(TimerID_CheckVehicleHealth);
    DeletePreciseTimer(TimerID_ConsumeFuel);
    DeletePreciseTimer(TimerID_OnPlayerUpdateEx);
    DeletePreciseTimer(Global15SecondIntervalEx);
    DeletePreciseTimer(Global30SecondIntervalEx);
    DeletePreciseTimer(GlobalOneMinuteIntervalEx);
    DeletePreciseTimer(GlobalFiveMinuteIntervalEx);
    return 1;
}

forward Global15SecondInterval();
public Global15SecondInterval() {
    return 1;
}

forward Global30SecondInterval();
public Global30SecondInterval() {
    return 1;
}

forward GlobalOneMinuteInterval();
public GlobalOneMinuteInterval() {
    mysql_tquery(Database, sprintf("insert into playerpeek(players) values (%d)", GetOnlinePlayerCount()));
    return 1;
}

forward GlobalFiveMinInterval();
public GlobalFiveMinInterval() {
    return 1;
}

forward GlobalHourInterval();
public GlobalHourInterval() {
    // global call every 1 am
    return 1;
}

forward GlobalOneAmInterval();
public GlobalOneAmInterval() {
    return 1;
}


public OnGameModeExit() {
    KillServerTimers();
    for (new vehicleid = 0; vehicleid < 2000; vehicleid++)
        if (IsValidVehicle(vehicleid)) DestroyVehicle(vehicleid);
    for (new objectid = 0; objectid < 1000; objectid++)
        if (IsValidObject(objectid)) DestroyObject(objectid);
    for (new i = 0; i < 4096; i++) DestroyObject(i);
    for (new i = 0; i < 1024; i++) Delete3DTextLabel(Text3D:i);
    for (new i = 0; i < 1024; i++) GangZoneDestroy(i);
    for (new i = 0; i < 128; i++) DestroyMenu(Menu:i);
    for (new i = 0; i < 1000; i++) DestroyActor(i);
    DestroyAllDynamicObjects();
    DestroyAllDynamicPickups();
    DestroyAllDynamicCPs();
    DestroyAllDynamicRaceCPs();
    DestroyAllDynamicMapIcons();
    DestroyAllDynamic3DTextLabels();
    DestroyAllDynamicAreas();
    mysql_close(Database); // Closing the database.
    Discord:SendManagement("Server Shutdown");
    return 1;
}

public OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) {
        new ip[50];
        GetPlayerIp(playerid, ip, sizeof ip);
        if (strcmp("127.0.0.1", ip)) Kick(playerid);
    }
    SetPlayerColor(playerid, Player_Color);
    return 1;
}

public OnPlayerRequestClass(playerid, classid) {
    if (IsPlayerNPC(playerid)) return 1;
    TogglePlayerSpectatingEx(playerid, true);
    if (IsPlayerLoggedIn(playerid)) {
        TogglePlayerSpectatingEx(playerid, false);
        SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerAutoSpawn(playerid), GetPlayerLastPosX(playerid), GetPlayerLastPosY(playerid), GetPlayerLastPosZ(playerid), GetPlayerLastPosAngle(playerid), -1, -1, -1, -1, -1, -1);
        SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorldID(playerid));
        SetPlayerInteriorEx(playerid, GetPlayerInteriorID(playerid));
        SpawnPlayer(playerid);
        return 1;
    }

    //if(!IsPlayerLoggedIn(playerid)) return 0; // Ignoring the request incase player isn't logged in.
    //    if(!GetPlayerDeathStatus(playerid) && GetPlayerAutoSpawn(playerid) != -1) {
    //        SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerAutoSpawn(playerid), GetPlayerLastPosX(playerid), GetPlayerLastPosY(playerid), GetPlayerLastPosZ(playerid), GetPlayerLastPosAngle(playerid), -1, -1, -1, -1, -1, -1);
    //        SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorldID(playerid));
    //        SetPlayerInteriorEx(playerid, GetPlayerInteriorID(playerid));
    //        SpawnPlayer(playerid);
    //        return 1;
    //    }

    //	SetPlayerInteriorEx(playerid,14);
    //	SetPlayerPosEx(playerid,258.4893,-41.4008,1002.0234);
    //	SetPlayerFacingAngle(playerid, 270.0);
    //	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
    //	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
    //this
    //SetPlayerPosEx(playerid, 1676.4998, 198.9426, 1276.4889);
    //SetPlayerFacingAngle(playerid, 90);
    //SetPlayerCameraPos(playerid, 1673, 198.9426, 1276.4889);
    //SetPlayerCameraLookAt(playerid, 1676.4998, 198.9426, 1276.4889, CAMERA_CUT);
    //Streamer_UpdateEx(playerid, 1676.4998, 198.9426, 1276.4889, 10, 1, -1);
    //ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 0, 0, 0, 0, 0);
    return 0;
}


public OnPlayerRequestSpawn(playerid) {
    if (!IsPlayerLoggedIn(playerid)) return 0; // Ignoring the request incase player isn't logged in.
    SetPlayerTeam(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorldID(playerid));
    SetPlayerInteriorEx(playerid, GetPlayerInteriorID(playerid));
    SetCameraBehindPlayer(playerid);
    SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerSkin(playerid), GetPlayerLastPosX(playerid), GetPlayerLastPosY(playerid), GetPlayerLastPosZ(playerid), GetPlayerLastPosAngle(playerid), -1, -1, -1, -1, -1, -1);
    return 1;
}

public OnPlayerSpawn(playerid) {
    if (!IsPlayerLoggedIn(playerid)) return 0; // Ignoring the request incase player isn't logged in.
    SetPlayerSpawnStatus(playerid, true);
    SetPlayerCash(playerid, GetPlayerCash(playerid));
    if (GetPlayerDeathStatus(playerid)) CallRemoteFunction("OnPlayerDeathSpawn", "d", playerid);
    return 1;
}

forward OnPlayerDeathSpawn(playerid);
public OnPlayerDeathSpawn(playerid) {
    SetPlayerDeathStatus(playerid, false);
    SetPlayerHealthEx(playerid, 30);
    SetPlayerArmourEx(playerid, 0);
    return 1;
}


public OnPlayerDisconnect(playerid, reason) {
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid) {
    return 1;
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z) {
    return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid) {
    return 1;
}

public OnIncomingConnection(playerid, ip_address[], port) {
    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ) {
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
    if (!GetPlayerDeathStatus(playerid)) CallRemoteFunction("OnPlayerKilled", "iii", playerid, killerid, reason);
    if (!IsAndroidPlayer(playerid)) GameTextForPlayer(playerid, "~r~Wasted", 5000, 2);
    SetPlayerDeathStatus(playerid, true);
    if (!Event:IsInEvent(playerid)) {
        new Float:pos_data[4];
        GetPlayerPos(playerid, pos_data[0], pos_data[1], pos_data[2]);
        GetPlayerFacingAngle(playerid, pos_data[3]);
        SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerSkin(playerid), pos_data[0], pos_data[1], pos_data[2], pos_data[3], -1, -1, -1, -1, -1, -1);
    } else {
        new id = GetClosestHospital(playerid);
        ClosestHospital[playerid] = id;
        SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerSkin(playerid), HospitalData[id][coordX], HospitalData[id][coordY], HospitalData[id][coordZ], HospitalData[id][faceA], -1, -1, -1, -1, -1, -1); //
    }
    if (gettime() - GetPVarInt(playerid, "PlayerLastDeath") < 1) Kick(playerid);
    SetPVarInt(playerid, "PlayerLastDeath", gettime());
    if (Event:IsInEvent(playerid)) return CallRemoteFunction("OnPlayerEventDeath", "dddd", playerid, killerid, reason, Event:GetID(playerid));
    else return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    return 1;
}

public OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (GetPlayerWeapon(playerid) == WEAPON_MINIGUN) Kick(playerid);
    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    return 1;
}

forward OnPlayerUpdateExTimer();
public OnPlayerUpdateExTimer() {
    foreach(new i:Player) {
        if (!IsPlayerPaused(i) && IsPlayerConnected(i) && IsPlayerLoggedIn(i)) CallRemoteFunction("OnPlayerUpdateEx", "d", i);
    }
    return 1;
}

forward OnPlayerUpdateEx(playerid);
public OnPlayerUpdateEx(playerid) {
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z) {
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {
    if (weaponid == 38) return Kick(issuerid);
    if (!IsPlayerConnected(issuerid)) return 1;
    if (!IsPlayerHaveWeapon(issuerid, weaponid)) return -1;
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {
    if (!IsPlayerConnected(playerid)) return 1;
    if (!IsPlayerHaveWeapon(playerid, weaponid)) return -1;
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
    return 1;
}

public OnPlayerEnterCheckpoint(playerid) {
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid) {
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid) {
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
    if (hittype != BULLET_HIT_TYPE_NONE) {
        if ((fX <= -1000.0 || fX >= 1000.0) || (fY <= -1000.0 || fY >= 1000.0) || (fZ <= -1000.0 || fZ >= 1000.0) || (hittype < 0 || hittype > 4)) {
            return Kick(playerid);
        }
    } else {
        if (weaponid <= 0 || weaponid > 46 || weaponid == 38) Kick(playerid); // Kick(playerid);
    }

    if (!IsPlayerHaveWeapon(playerid, weaponid)) {
        return -1;
    }

    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
    return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid) {
    return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid) {
    return 1;
}

public OnVehicleDeath(vehicleid, killerid) {
    return 1;
}

public OnVehicleSirenStateChange(playerid, vehicleid, newstate) {
    CallRemoteFunction("OnSirenStateChange", "ddd", playerid, vehicleid, newstate);
    return 1;
}

forward OnSirenStateChange(playerid, vehicleid, newstate);
public OnSirenStateChange(playerid, vehicleid, newstate) {
    return 1;
}

public OnVehicleSpawn(vehicleid) {
    ResetVehicleEx(vehicleid);
    ToggleUnoccupiedVehicleDamage(vehicleid, true);
    return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid) {
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
    return 1;
}

public OnVehicleCreated(vehicleid) {
    return 1;
}

public OnVehicleDestroyed(vehicleid) {
    return 1;
}

public OnTrailerHooked(playerid, vehicleid, trailerid) {
    GameTextForPlayer(playerid, "~r~Trailer ~w~Attached", 1000, 3);
    return 1;
}

public OnTrailerUnhooked(playerid, vehicleid, trailerid) {
    GameTextForPlayer(playerid, "~r~Trailer ~w~Deattached", 1000, 3);
    return 1;
}

public OnVehicleBombDeactivate(vehicleid) {
    return 1;
}

public OnVehicleBombExplode(vehicleid) {
    return 1;
}

public OnPlayerShotVehicle(playerid, vehicleid, weaponid, Float:amount, bodypart) {
    return 1;
}

public OnPlayerEditVehicle(playerid, vehicleid, response, Float:fX, Float:fY, Float:fZ, Float:fRotZ) {
    return 1;
}

public OnPlayerEditVehicleObject(playerid, vehicleid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    return 1;
}

public OnPlayerReachSpeedCapLimit(playerid, vehicleid, Float:speed) {
    return 1;
}

public OnVehicleBombActivate(vehicleid) {
    return 1;
}

public OnVehicleModEx(playerid, vehicleid, componentid, price, illegal) {
    return 1;
}

public OnVehicleFuelChange(vehicleid, newfuel, oldfuel) {
    return 1;
}

public OnObjectMoved(objectid) {
    return 1;
}

public OnDynamicObjectMoved(objectid) {
    return 1;
}

public OnVehicleHealthChange(vehicleid, Float:newhealth, Float:oldhealth) {
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) {
    if (!IsPlayerLoggedIn(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are not connected with server, login to proceed.");
        return 0;
    }

    Anti_Spam_Count[playerid]++;
    if (Anti_Spam_Count[playerid] > 1) {
        Anti_Spam_Warn[playerid]++;
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{8B0000}Warning[%d] you are few message away from being kicked!", Anti_Spam_Warn[playerid]));
        if (Anti_Spam_Warn[playerid] > 3) Kick(playerid);
        return 0;
    }

    ResetChatSpamTimer(playerid);
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags) {
    LogNormal(sprintf("[CMD] [%s][%s]: %s", GetPlayerNameEx(playerid), cmd, FormatMention(params)));

    if (result != 1) {
        UnknownCommand:Show(playerid);
        UnknownCommand:HideTimer(playerid);
        PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
    }

    return 1;
}

new bool:chatmod_config[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    chatmod_config[playerid] = false;
    return 1;
}

hook OnFirstLogin(playerid) {
    chatmod_config[playerid] = true;
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "chatmode");
    return 1;
}

hook OnPlayerLogin(playerid) {
    SetPreciseTimer("OnPlayerRequestClass", 100, false, "ii", playerid, 0);
    chatmod_config[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", "chatmode");
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "chatmode, chat mode")) return 1;
    if (!chatmod_config[playerid]) {
        chatmod_config[playerid] = true;
        Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "chatmode");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Disabled chat mode.");
    } else {
        chatmod_config[playerid] = false;
        Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "chatmode");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Enabled chat mode.");
    }
    return -2;
}

public OnPlayerText(playerid, text[]) {
    if (!IsPlayerLoggedIn(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are not connected with server, login to proceed.");
        return 0;
    }

    if (!chatmod_config[playerid]) {
        if (GetPlayerScore(playerid) >= 10) {
            if (IsTimePassedForPlayer(playerid, "gc_s_alert", 5 * 60)) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} by default, your chat mode is setted to /s. use /gc for global chat.");
            callcmd::s(playerid, text);
        } else {
            callcmd::gc(playerid, text);
        }
    } else {
        callcmd::alexa(playerid, text);
    }

    LogNormal(sprintf("[Text] [%s]: %s", GetPlayerNameEx(playerid), FormatMention(text)));
    return 0;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid) {
    return 1;
}

public OnActorStreamIn(actorid, forplayerid) {
    return 1;
}

public OnRconCommand(cmd[]) {
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success) {
    if (!success) //If the password was incorrect
    {
        Discord:SendManagement(sprintf("FAILED RCON LOGIN BY IP %s USING PASSWORD %s", ip, password));
        new pip[16];
        foreach(new i:Player) //Loop through all players
        {
            GetPlayerIp(i, pip, sizeof(pip));
            if (!strcmp(ip, pip, true)) //If a player's IP is the IP that failed the login
            {
                Kick(i); //They are now kicked.
            }
        }
    }
    BlockIpAddress(ip, 10 * 60 * 1000);
    return 1;
}

stock SendAdminLogMessage(const message[], bool:discord = true) {
    foreach(new i:Player) if (GetPlayerAdminLevel(i) > 0) SendClientMessage(i, -1, sprintf("{4286f4}[Admin Log]:{FFCC66}%s", message));
    if (discord) Discord:LogAdmin(sprintf("[Admin Log]: %s", message));
    return 1;
}

#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/utils/001.pwn"