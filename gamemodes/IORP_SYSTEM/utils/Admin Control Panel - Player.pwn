#define PlayerAdmin:%0 plAd@
new PlayerAdmin:dialogid;
enum {
    PlayerAdmin:OffsetSetSePlFa,
    PlayerAdmin:OffsetSetKiPl,
    PlayerAdmin:OffsetSetBaPl,
    PlayerAdmin:OffsetSetSpVeh,
    PlayerAdmin:OffsetSetSeVehCol,
    PlayerAdmin:OffsetSetGiWep,
    PlayerAdmin:OffsetSetGiMon,
    PlayerAdmin:OffsetSetSeMon,
    PlayerAdmin:OffsetSetSeHel,
    PlayerAdmin:OffsetSetSeArm,
    PlayerAdmin:OffsetSetSeScore,
    PlayerAdmin:OffsetSetSeSkin,
    PlayerAdmin:OffsetSetSeInt,
    PlayerAdmin:OffsetSetSeViWo,
    PlayerAdmin:OffsetSetSeWaLe
}

hook OnGameModeInit() {
    PlayerAdmin:dialogid = Dialog:GetFreeID();
    return 1;
}

APCP:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 1;
    if (GetPlayerAdminLevel(playerid) >= 1 && !IsPlayerFreezed(targetid)) APCP:AddCommand(playerid, "freeze");
    if (GetPlayerAdminLevel(playerid) >= 1 && IsPlayerFreezed(targetid)) APCP:AddCommand(playerid, "unfreeze");
    if (GetPlayerAdminLevel(playerid) >= 5 && IsPlayerRequestNameChange(targetid)) APCP:AddCommand(playerid, "accept name change request");
    if (GetPlayerAdminLevel(playerid) >= 5 && IsPlayerRequestNameChange(targetid)) APCP:AddCommand(playerid, "reject name change request");
    if (GetPlayerAdminLevel(playerid) >= 9 && !GetPlayerRepairAuth(targetid)) APCP:AddCommand(playerid, "Enable Vehicle Repair");
    if (GetPlayerAdminLevel(playerid) >= 9 && GetPlayerRepairAuth(targetid)) APCP:AddCommand(playerid, "Disable Vehicle Repair");
    if (GetPlayerAdminLevel(playerid) >= 9 && !GetPlayerAutoRepairAuth(targetid)) APCP:AddCommand(playerid, "Enable Automatic Vehicle Repair");
    if (GetPlayerAdminLevel(playerid) >= 9 && GetPlayerAutoRepairAuth(targetid)) APCP:AddCommand(playerid, "Disable Automatic Vehicle Repair");
    if (GetPlayerAdminLevel(playerid) >= 9 && !FuelAuth:IsActive(targetid)) APCP:AddCommand(playerid, "Enable Vehicle Refuel");
    if (GetPlayerAdminLevel(playerid) >= 9 && FuelAuth:IsActive(targetid)) APCP:AddCommand(playerid, "Disable Vehicle Refuel");
    if (GetPlayerAdminLevel(playerid) >= 9 && !FuelAuth:IsAutoActive(targetid)) APCP:AddCommand(playerid, "Enable Automatic Vehicle Refuel");
    if (GetPlayerAdminLevel(playerid) >= 9 && FuelAuth:IsAutoActive(targetid)) APCP:AddCommand(playerid, "Disable Automatic Vehicle Refuel");
    if (GetPlayerAdminLevel(playerid) >= 9 && !GetPlayerTPAuth(targetid)) APCP:AddCommand(playerid, "Enable Quick Teleportation");
    if (GetPlayerAdminLevel(playerid) >= 9 && GetPlayerTPAuth(targetid)) APCP:AddCommand(playerid, "Disable Quick Teleportation");
    if (GetPlayerAdminLevel(playerid) >= 5 && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) APCP:AddCommand(playerid, "Spectate");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Get Player to your location");
    if (GetPlayerAdminLevel(playerid) >= 10 && IsCuff_Player(targetid)) APCP:AddCommand(playerid, "Uncuff Player");
    else if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Cuff Player");
    if (GetPlayerAdminLevel(playerid) >= 10 && IsCES_FollowPlayer(targetid)) APCP:AddCommand(playerid, "Disable Follow up Player");
    else if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Enable Follow up Player");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Teleport to Player");
    if (!GetPlayerTeleportKickStatus(targetid) && GetPlayerAdminLevel(playerid) >= 8) APCP:AddCommand(playerid, "Enable Teleport Kick");
    if (GetPlayerTeleportKickStatus(targetid) && GetPlayerAdminLevel(playerid) >= 8) APCP:AddCommand(playerid, "Disable Teleport Kick");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Set Interior");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Set Virtual World");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Set Wanted Level");
    if (GetPlayerAdminLevel(playerid) >= 1) APCP:AddCommand(playerid, "Jail Player");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Spawn Vehicle");
    if (GetPlayerAdminLevel(playerid) >= 8) APCP:AddCommand(playerid, "Set Vehicle Color");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Give Weapon");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Give Money");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Set Money");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Set Health");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Set Armour");
    if (IsPlayerMasterAdmin(playerid)) APCP:AddCommand(playerid, "Set Score");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Set Skin");
    if (GetPlayerAdminLevel(playerid) >= 5) APCP:AddCommand(playerid, "Disarm Player");
    if (GetPlayerAdminLevel(playerid) >= 5) APCP:AddCommand(playerid, "Kick Player");
    if (GetPlayerAdminLevel(playerid) >= 5) APCP:AddCommand(playerid, "Ban Player");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Give All License");
    if (GetPlayerAdminLevel(playerid) >= 10) APCP:AddCommand(playerid, "Remove All License");
    if (GetPlayerAdminLevel(playerid) >= 8 && !BetaTester:IsPlayer(targetid)) APCP:AddCommand(playerid, "Set Player As Beta Tester");
    if (GetPlayerAdminLevel(playerid) >= 8 && BetaTester:IsPlayer(targetid)) APCP:AddCommand(playerid, "Remove Player As Beta Tester");
    if (GetPlayerAdminLevel(playerid) >= 8 && !IsPlayerHelper(targetid)) APCP:AddCommand(playerid, "Set Player As Helper");
    if (GetPlayerAdminLevel(playerid) >= 8 && IsPlayerHelper(targetid)) APCP:AddCommand(playerid, "Remove Player As Helper");
    if (GetPlayerAdminLevel(playerid) >= 8 && !DJ:IsPlayer(targetid)) APCP:AddCommand(playerid, "Set Player As DJ");
    if (GetPlayerAdminLevel(playerid) >= 8 && DJ:IsPlayer(targetid)) APCP:AddCommand(playerid, "Remove Player As DJ");
    if (GetPlayerAdminLevel(playerid) >= 5 && !GetPlayerMutedStatus(targetid)) APCP:AddCommand(playerid, "Mute Player");
    if (GetPlayerAdminLevel(playerid) >= 5 && GetPlayerMutedStatus(targetid)) APCP:AddCommand(playerid, "UnMute Player");
    if (GetPlayerAdminLevel(playerid) >= 8 && Faction:GetPlayerFID(targetid) == -1) APCP:AddCommand(playerid, "Set Player Faction");
    if (GetPlayerAdminLevel(playerid) >= 8 && Faction:GetPlayerFID(targetid) != -1) APCP:AddCommand(playerid, "Show Faction Locker");
    if (GetPlayerAdminLevel(playerid) >= 8 && Faction:GetPlayerFID(targetid) != -1) APCP:AddCommand(playerid, "Remove Player from his Faction");
    return 1;
}

APCP:OnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response || page != 0) return 1;
    if (IsStringSame("freeze", inputtext)) {
        if (!Tryg3D::IsPlayerSpawned(targetid)) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Error]:{FFFFEE} wait for the player to spawn");
            APCP:Init(playerid, targetid);
            return ~1;
        }
        if (IsPlayerFreezed(targetid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}player already freezed");
            APCP:Init(playerid, targetid);
            return ~1;
        }
        freeze(targetid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have freezed %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}You has been freezed by Admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("unfreeze", inputtext)) {
        if (!Tryg3D::IsPlayerSpawned(targetid)) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Error]:{FFFFEE} wait for the player to spawn");
            APCP:Init(playerid, targetid);
            return ~1;
        }
        if (!IsPlayerFreezed(targetid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}player already unfreezed");
            APCP:Init(playerid, targetid);
            return ~1;
        }
        unfreeze(targetid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have unfreezed %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}You has been unfreezed by Admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("accept name change request", inputtext)) {
        ApproveNameChange(targetid);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("reject name change request", inputtext)) {
        RejectNameChange(targetid);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Vehicle Repair", inputtext)) {
        SetPlayerRepairAuth(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s quick vehicle repair", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled quick vehicle repair for you, press 2/+ to repair vehicle", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Vehicle Repair", inputtext)) {
        SetPlayerRepairAuth(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s quick vehicle repair", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled quick vehicle repair for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Automatic Vehicle Repair", inputtext)) {
        SetPlayerAutoRepairAuth(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s automatic vehicle repair", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled automatic vehicle repair for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Automatic Vehicle Repair", inputtext)) {
        SetPlayerAutoRepairAuth(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s automatic vehicle repair", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled automatic vehicle repair for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Vehicle Refuel", inputtext)) {
        FuelAuth:SetActive(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s quick vehicle refuel", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled quick vehicle refuel for you, press 2/+ to refuel vehicle", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Vehicle Refuel", inputtext)) {
        FuelAuth:SetActive(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s quick vehicle refuel", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled quick vehicle refuel", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Automatic Vehicle Refuel", inputtext)) {
        FuelAuth:SetAutoActive(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled %s automatic vehicle refuel", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s enabled automatic vehicle refuel for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Automatic Vehicle Refuel", inputtext)) {
        FuelAuth:SetAutoActive(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s automatic vehicle refuel", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled automatic vehicle refuel for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Quick Teleportation", inputtext)) {
        SetPlayerTPAuth(playerid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s quick teleportation", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled quick teleportation for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Quick Teleportation", inputtext)) {
        SetPlayerTPAuth(playerid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled %s quick teleportation", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s disabled quick teleportation for you", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Spectate", inputtext)) {
        Spectate:Start(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Get Player to your location", inputtext)) {
        if (!Tryg3D::IsPlayerSpawned(targetid)) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Error]:{FFFFEE} wait for the player to spawn");
            return ~1;
        }
        new Float:x, Float:y, Float:z, Float:a, int, worldid;
        int = GetPlayerInterior(playerid);
        worldid = GetPlayerVirtualWorld(playerid);
        GetPlayerPos(playerid, x, y, z);
        GetXYInFrontOfPlayer(playerid, x, y, 10);
        GetPlayerFacingAngle(playerid, a);
        SetPlayerVirtualWorldEx(targetid, worldid);
        SetPlayerInteriorEx(targetid, int);
        if (IsPlayerInAnyVehicle(targetid)) TeleportVehicleEx(GetPlayerVehicleID(targetid), x, y, z, a + 90, worldid, int);
        else SetPlayerPosEx(targetid, x, y, z);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have teleported %s to yourself", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s teleported you to himself", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Uncuff Player", inputtext)) {
        Uncuff_Player(targetid);
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you has been uncuffed by admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Cuff Player", inputtext)) {
        Cuff_Player(targetid);
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you has been cuffed by admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Follow up Player", inputtext)) {
        CES_StopFollowPlayer(targetid);
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you are not following anyone (admin %s)", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Follow up Player", inputtext)) {
        CES_FollowPlayer(targetid, playerid);
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you are following admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Teleport to Player", inputtext)) {
        if (!Tryg3D::IsPlayerSpawned(targetid)) { SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Error]:{FFFFEE} wait for the player to spawn"); return ~1; }
        new Float:x, Float:y, Float:z, Float:a, int, worldid;
        int = GetPlayerInterior(targetid);
        worldid = GetPlayerVirtualWorld(targetid);
        GetPlayerPos(targetid, x, y, z);
        GetXYInFrontOfPlayer(targetid, x, y, 10);
        GetPlayerFacingAngle(targetid, a);
        SetPlayerVirtualWorldEx(playerid, worldid);
        SetPlayerInteriorEx(playerid, int);
        if (IsPlayerInAnyVehicle(playerid)) TeleportVehicleEx(GetPlayerVehicleID(playerid), x, y, z, a + 90, worldid, int);
        else SetPlayerPosEx(playerid, x, y, z);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have teleported to %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s teleported himself to your location", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Enable Teleport Kick", inputtext)) {
        SetPlayerTeleportKickStatus(targetid, true);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have enabled unauthorised teleport for %s ", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}you are granted permission by %s for unauthorised teleports", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disable Teleport Kick", inputtext)) {
        SetPlayerTeleportKickStatus(targetid, false);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disabled unauthorised teleport for %s ", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}you are disabled permission by %s for unauthorised teleports", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Jail Player", inputtext)) {
        WantedDatabase:SendJail(targetid);
        WantedDatabase:JailPlayer(targetid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you are sent %s to jail", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} You has been sent to jail by Admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Disarm Player", inputtext)) {
        ResetPlayerWeaponsEx(targetid);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have disarmed %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you has been disarmed by admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Give All License", inputtext)) {
        DriverPlayerData[targetid][LightMotor] = true;
        DriverPlayerData[targetid][HeavyMotor] = true;
        DriverPlayerData[targetid][TwoWheelerMotor] = true;
        DriverPlayerData[targetid][HelicopterMotor] = true;
        DriverPlayerData[targetid][PlaneMotor] = true;
        DriverPlayerData[targetid][BoatMotor] = true;
        Player_Driving_Data_Update(targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have given all license to %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s gives you all license", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Remove All License", inputtext)) {
        DriverPlayerData[targetid][LightMotor] = false;
        DriverPlayerData[targetid][HeavyMotor] = false;
        DriverPlayerData[targetid][TwoWheelerMotor] = false;
        DriverPlayerData[targetid][HelicopterMotor] = false;
        DriverPlayerData[targetid][PlaneMotor] = false;
        DriverPlayerData[targetid][BoatMotor] = false;
        Player_Driving_Data_Update(targetid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have removed all license to %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s removed your all license", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Set Player As Beta Tester", inputtext)) {
        BetaTester:SetPlayer(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s as Beta Tester of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s set you as Beta Tester of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Remove Player As Beta Tester", inputtext)) {
        BetaTester:SetPlayer(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have removed %s as Beta Tester of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s removed you as Beta Tester of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Set Player As Helper", inputtext)) {
        SetPlayerHelper(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s as Helper of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s set you as Helper of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Remove Player As Helper", inputtext)) {
        SetPlayerHelper(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have removed %s as Helper of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s removed you as Helper of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Set Player As DJ", inputtext)) {
        DJ:SetPlayerAsDj(targetid, true);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s as DJ of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s set you as DJ of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Remove Player As DJ", inputtext)) {
        DJ:SetPlayerAsDj(targetid, false);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have removed %s as DJ of server", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s removed you as DJ of server", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Mute Player", inputtext)) {
        MuteCommand(playerid, targetid, true);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("UnMute Player", inputtext)) {
        MuteCommand(playerid, targetid, false);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Show Faction Locker", inputtext)) {
        Faction:ShowLocker(targetid, Faction:GetPlayerFID(targetid));
        return ~1;
    }
    if (IsStringSame("Remove Player from his Faction", inputtext)) {
        Faction:RemovePlayerFaction(playerid, targetid);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Set Player Faction", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Kick Player", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetKiPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Reason]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Ban Player", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetBaPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Mins] [Reason]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Spawn Vehicle", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSpVeh, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VehicleID / VehicleName] [Color 1] [Color 2]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Vehicle Color", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeVehCol, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Color 1] [Color 2]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Give Weapon", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiWep, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponID] [Ammo]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Give Money", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Money", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Health", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeHel, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Armour", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Score", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeScore, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Score]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Skin", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Interior", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeInt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [InteriorID]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Virtual World", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeViWo, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VirtualWorldID]", "Submit", "Close", targetid);
        return ~1;
    }
    if (IsStringSame("Set Wanted Level", inputtext)) {
        ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeWaLe, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Levels] [Fineable? 0/1] [Reason]", "Submit", "Close", targetid);
        return ~1;
    }
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], targetid, const payload[]) {
    if (dialogid != PlayerAdmin:dialogid) return 1;
    if (offsetid == PlayerAdmin:OffsetSetSePlFa) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new FId, RankId;
        if (sscanf(inputtext, "ii", FId, RankId)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { SendClientMessageEx(playerid, -1, "{4286f4}[Faction System]:{FFCC66}player not connected"); return ~1; }
        if (!Iter_Contains(factions, FId)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid); return ~1; }
        if (RankId < 1 || RankId > Faction:GetRankLimit(FId)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid); return ~1; }
        if (Faction:GetMemberCount(FId) == Faction:GetMemberLimit(FId)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid); return ~1; }
        if (Faction:GetPlayerFID(targetid) == FId) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSePlFa, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Faction Panel", "Enter [FactionID] [RankID]", "Submit", "Close", targetid); return ~1; }
        Faction:SetPlayer(targetid, FId, RankId);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Faction System]:{FFCC66}%s{FFFFFF} faction now {FFCC66}%s{FFFFFF} with rank {FFCC66}%s", GetPlayerNameEx(targetid), Faction:GetName(FId), Faction:GetRankName(FId, RankId)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Faction System]: {FFFFFF}your faction now {FFCC66}%s{FFFFFF} with rank {FFCC66}%s", Faction:GetName(FId), Faction:GetRankName(FId, RankId)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetKiPl) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new reason[512];
        if (sscanf(inputtext, "s[512]", reason)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetKiPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Reason]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetKiPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Reason]", "Submit", "Close", targetid); return ~1; }
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s kicked %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason));
        Discord:SendHelper(sprintf("[Alexa]: Admin %s kicked %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason));
        SetTimerEx("kick", 1000, false, "i", targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetBaPl) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new mins, reason[100];
        if (sscanf(inputtext, "ds[100]", mins, reason)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetBaPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Mins] [Reason]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetBaPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Mins] [Reason]", "Submit", "Close", targetid); return ~1; }
        if (mins < 1 || mins > 43800) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetBaPl, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Mins] [Reason]", "Submit", "Close", targetid); return ~1; }
        new unbantime[100];
        UnixToHuman(gettime() + mins * 60, unbantime);
        mysql_tquery(Database, sprintf("UPDATE `players` set bantime = %d, banreason = \"%s\" WHERE `Username` = \"%s\" LIMIT 1", gettime() + mins * 60, reason, GetPlayerNameEx(targetid)));
        SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFEE}Admin %s banned %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason));
        Discord:SendHelper(sprintf("[Alexa]: Admin %s banned %s till %s for %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), unbantime, reason));
        KickPlayer(targetid);
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSpVeh) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new Vehicle[32], VehicleID, ColorOne, ColorTwo;
        if (sscanf(inputtext, "s[32]D(1)D(1)", Vehicle, ColorOne, ColorTwo)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSpVeh, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VehicleID / VehicleName] [Color 1] [Color 2]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSpVeh, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VehicleID / VehicleName] [Color 1] [Color 2]", "Submit", "Close", targetid); return ~1; }
        if (isNumeric(Vehicle)) VehicleID = strval(Vehicle);
        else {
            new vcount = 0, ovtl[5];
            for (new d = 0; d < 212; d++) {
                if (strfind(GetVehicleModelName(d + 400), Vehicle, true) != -1 || strval(Vehicle) == d + 400) {
                    VehicleID = d + 400;
                    if (vcount < 5) ovtl[vcount] = VehicleID;
                    else {
                        SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}More than 5 results with that name were found.");
                        return ~1;
                    }
                    vcount++;
                }
            }
            if (vcount > 1) {
                for (new e = 0; e < vcount; e++) {
                    if (e == 0) SendClientMessageEx(playerid, -1, "{4286f4}[Error]: {FFFFFF}we got many vehicles with this name, here's the list..");
                    SendClientMessageEx(playerid, -1, sprintf(" %s [Model - %d]", GetVehicleModelName(ovtl[e]), ovtl[e]));
                }
                return ~1;
            }
        }
        if (VehicleID < 400 || VehicleID > 611) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFFF}You entered an invalid vehiclename!");
            return ~1;
        }
        if (VehicleID == 611) {
            SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]: {FFFFFF}This vehicle can not be spawned!!");
            return ~1;
        }
        new Float:pX, Float:pY, Float:pZ, Float:pAngle, vehicleid;
        GetPlayerPos(targetid, pX, pY, pZ);
        GetPlayerFacingAngle(targetid, pAngle);
        GetXYInFrontOfPlayer(targetid, pX, pY, 3);
        vehicleid = CreateVehicle(VehicleID, pX, pY, pZ + 2.0, pAngle, ColorOne, ColorTwo, -1, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(targetid), true);
        ResetVehicleEx(vehicleid);
        Iter_Add(ASpawnedVeh, vehicleid);
        if (!IsPlayerInAnyVehicle(targetid)) PutPlayerInVehicleEx(targetid, vehicleid, 0);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you spawned %s for %s", GetVehicleModelName(VehicleID), GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}This %s spawned for you by Admin %s", GetVehicleModelName(VehicleID), GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeVehCol) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new ColorOne, ColorTwo;
        if (sscanf(inputtext, "D(1)D(1)", ColorOne, ColorTwo)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeVehCol, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Color 1] [Color 2]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeVehCol, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Color 1] [Color 2]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerInAnyVehicle(targetid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Player not in vehicle");
            return ~1;
        }
        ChangeVehicleColor(GetPlayerVehicleID(targetid), ColorOne, ColorTwo);
        if (playerid == targetid) SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} you reset your vehicle color");
        else SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you reset vehicle color of %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE}Your vehicle color has been reset by admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetGiWep) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new WeaponId, ammo;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiWep, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponID] [Ammo]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "ii", WeaponId, ammo)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiWep, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponID] [Ammo]", "Submit", "Close", targetid); return ~1; }
        if (WeaponId < 1 || WeaponId == 19 || WeaponId == 20 || WeaponId == 21 || WeaponId == 38 || WeaponId > 46) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiWep, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponID] [Ammo]", "Submit", "Close", targetid); return ~1; }
        if (ammo < 0 || ammo > 1000) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiWep, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [WeaponID] [Ammo]", "Submit", "Close", targetid); return ~1; }
        GivePlayerWeaponEx(targetid, WeaponId, ammo);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have gived %s a %s weapon with ammo %d", GetPlayerNameEx(targetid), GetWeaponNameEx(WeaponId), ammo));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have received weapon %s with ammo %d from Admin %s", GetWeaponNameEx(WeaponId), ammo, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetGiMon) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new money;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "i", money)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        if (money > 9999999) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetGiMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        GivePlayerCash(targetid, money, sprintf("admin %s given money", GetPlayerNameEx(playerid)));
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have give %s money %d", GetPlayerNameEx(targetid), money));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have recieved %d money by Admin %s", money, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeMon) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new money;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "i", money)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        if (money > 999999999) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeMon, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Money]", "Submit", "Close", targetid); return ~1; }
        SetPlayerCash(targetid, money);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s money to %d", GetPlayerNameEx(targetid), money));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} your money has been reset to %d by Admin %s", money, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeHel) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new health;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeHel, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "i", health)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeHel, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close", targetid); return ~1; }
        if (health > 100 || health < 0) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeHel, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Health]", "Submit", "Close", targetid); return ~1; }
        SetPlayerHealthEx(targetid, health);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s health to %d", GetPlayerNameEx(targetid), health));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} your health has been reset to %d by Admin %s", health, GetPlayerNameEx(playerid)));
        if (IsPlayerFreezedForDeath(targetid)) {
            SetPlayerFreezeState(targetid, false);
            ApplyAnimation(targetid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        }
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeArm) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new armour;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "i", armour)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close", targetid); return ~1; }
        if (armour > 100 || armour < 0) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeArm, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Armour]", "Submit", "Close", targetid); return ~1; }
        SetPlayerArmourEx(targetid, armour);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s armour to %d", GetPlayerNameEx(targetid), armour));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} your armour has been reset to %d by Admin %s", armour, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeScore) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new score;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeScore, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Score]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "i", score)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeScore, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Score]", "Submit", "Close", targetid); return ~1; }
        SetExperiencePoint(playerid, score);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have set %s score to %d", GetPlayerNameEx(targetid), score));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} your score has been reset to %d by Admin %s", score, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeSkin) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new skinid;
        if (sscanf(inputtext, "i", skinid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close", targetid); return ~1; }
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close", targetid); return ~1; }
        if (skinid < 0 || skinid > 299) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeSkin, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [SkinID]", "Submit", "Close", targetid); return ~1; }
        SetPlayerSkinEx(targetid, skinid);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have reset skin of %s", GetPlayerNameEx(targetid)));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Your skin has been reset by Admin %s", GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeInt) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new int;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeInt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [InteriorID]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "d", int)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeInt, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [InteriorID]", "Submit", "Close", targetid); return ~1; }
        SetPlayerInteriorEx(targetid, int);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have reset %s interior to %d", GetPlayerNameEx(targetid), int));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} your interior has been reset to %d by admin %s", int, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeViWo) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new int;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeViWo, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VirtualWorldID]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "d", int)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeViWo, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [VirtualWorldID]", "Submit", "Close", targetid); return ~1; }
        SetPlayerVirtualWorldEx(targetid, int);
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} you have reset %s virtual world to %d", GetPlayerNameEx(targetid), int));
        SendClientMessageEx(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} your virtual world has been reset to %d by admin %s", int, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    if (offsetid == PlayerAdmin:OffsetSetSeWaLe) {
        if (!response) { APCP:Init(playerid, targetid); return ~1; }
        new reason[150], levels, bool:fineable;
        if (!IsPlayerConnected(targetid)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeWaLe, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Levels] [Fineable? 0/1] [Reason]", "Submit", "Close", targetid); return ~1; }
        if (sscanf(inputtext, "dbs[512]", levels, fineable, reason)) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeWaLe, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Levels] [Fineable? 0/1] [Reason]", "Submit", "Close", targetid); return ~1; }
        if (levels < 1 || levels > 500) { ShowPlayerDialogEx(playerid, PlayerAdmin:dialogid, PlayerAdmin:OffsetSetSeWaLe, DIALOG_STYLE_INPUT, "{4286f4}[Alexa]:{FFFFEE}Admin Control Panel", "Enter [Levels] [Fineable? 0/1] [Reason]", "Submit", "Close", targetid); return ~1; }
        WantedDatabase:GiveWantedLevel(targetid, sprintf("admin %s reported %s", GetPlayerNameEx(playerid), reason), levels, fineable);
        SendClientMessageEx(playerid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you have increased %s wanted level for %s", GetPlayerNameEx(targetid), reason));
        SendClientMessageEx(targetid, COLOR_GREY, sprintf("{4286f4}[Alexa]:{FFFFEE} you are wanted for %s by admin %s", reason, GetPlayerNameEx(playerid)));
        APCP:Init(playerid, targetid);
        return ~1;
    }
    return ~1;
}