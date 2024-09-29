///=== Vehicle Health System ===///
new Float:AntiVehicleHealth[MAX_VEHICLES] = {
    1000.0,
    ...
};
forward Float:GetVehicleAntiHealthEx(vehicleid);
stock Float:GetVehicleAntiHealthEx(vehicleid) {
    return AntiVehicleHealth[vehicleid];
}
forward Float:GetVehicleHealthEx(vehicleid);
stock Float:GetVehicleHealthEx(vehicleid) {
    new Float:vHealth;
    GetVehicleHealth(vehicleid, vHealth);
    return vHealth;
}
forward CheckVehicleHealthHack();
public CheckVehicleHealthHack() {
    foreach(new playerid:Player) {
        if(IsPlayerInAnyVehicle(playerid)) {
            new vehicleid;
            vehicleid = GetPlayerVehicleID(playerid);
            if(GetVehicleHealthEx(vehicleid) > GetVehicleAntiHealthEx(vehicleid) || GetVehicleHealthEx(vehicleid) > 1001) {
                SetVehicleHealth(vehicleid, GetVehicleAntiHealthEx(vehicleid));
                OnPlayerVehicleRepair(playerid);
            }
            if(GetVehicleHealthEx(vehicleid) <= GetVehicleAntiHealthEx(vehicleid)) {
                SetVehicleHealthEx(vehicleid, GetVehicleHealthEx(vehicleid));
            }
        }
    }
    return 1;
}
forward ResetVehicleEx(vehicleid);
public ResetVehicleEx(vehicleid) {
    if(vehicleid < 0 || vehicleid > 2000) return 0;
    new Float:angle;
    GetVehicleZAngle(vehicleid, angle);
    SetVehicleZAngle(vehicleid, angle);
    SetVehicleHealthEx(vehicleid, 1000);
    RepairVehicle(vehicleid);
    CallRemoteFunction("OnVehicleReset", "d", vehicleid);
    return 1;
}
forward OnVehicleReset(vehicleid);
public OnVehicleReset(vehicleid) {
    return 1;
}
stock SetVehicleHealthEx(vehicleid, Float:vhealth) {
    if(vehicleid < 0 || vehicleid > 2000) return 0;
    AntiVehicleHealth[vehicleid] = vhealth;
    SetVehicleHealth(vehicleid, vhealth);
    return 1;
}

forward OnPlayerVehicleRepair(playerid);
public OnPlayerVehicleRepair(playerid) {
    new message[100], vehicleId;
    vehicleId = GetPlayerVehicleID(playerid);
    RemovePlayerFromVehicle(playerid);
    SetTimerEx("ResetVehicleEx", 3000, false, "i", vehicleId);
    SetTimerEx("SetVehicleToRespawnEx", 6000, false, "i", vehicleId);
    format(message, sizeof(message), "%s done a unauthorized vehicle repair", GetPlayerNameEx(playerid));
    SendAdminLogMessage(message);
    return 1;
}
forward OnSetVehicleToRespawnEx(vehicleid);
public OnSetVehicleToRespawnEx(vehicleid) {
    return 1;
}
forward SetVehicleToRespawnEx(vehicleid);
public SetVehicleToRespawnEx(vehicleid) {
    CallRemoteFunction("OnSetVehicleToRespawnEx", "d", vehicleid);
    return SetVehicleToRespawn(vehicleid);
}
///=== Anti Freeze System ===///
new bool:Controllable[MAX_PLAYERS], Float:FPlayerPos[MAX_PLAYERS][3];
stock IsPlayerFreezed(playerid) {
    return !Controllable[playerid];
}
new fz_timer[MAX_PLAYERS];
forward freezeEx(playerid, time);
public freezeEx(playerid, time) {
    freeze(playerid);
    KillTimer(fz_timer[playerid]);
    fz_timer[playerid] = SetTimerEx("unfreeze", time, false, "i", playerid);
    return 1;
}
forward freeze(playerid);
public freeze(playerid) {
    if(IsPlayerFreezed(playerid)) return 0;
    Controllable[playerid] = false;
    TogglePlayerControllable(playerid, false);
    GetPlayerPos(playerid, FPlayerPos[playerid][0], FPlayerPos[playerid][1], FPlayerPos[playerid][2]);
    CallRemoteFunction("OnPlayerfreezed", "d", playerid);
    return 1;
}
forward unfreeze(playerid);
public unfreeze(playerid) {
    if(!IsPlayerFreezed(playerid)) return 1;
    Controllable[playerid] = true;
    TogglePlayerControllable(playerid, true);
    CallRemoteFunction("OnPlayerUnfreezed", "d", playerid);
    return 1;
}
forward OnPlayerfreezed(playerid);
public OnPlayerfreezed(playerid) {
    return 1;
}
forward OnPlayerUnfreezed(playerid);
public OnPlayerUnfreezed(playerid) {
    return 1;
}

#include <YSI_Coding\y_hooks>
hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    Controllable[playerid] = true;
    fz_timer[playerid] = -1;
    return 1;
}

#include <YSI_Coding\y_hooks>
hook OnPlayerUpdateEx(playerid) {
    if(IsPlayerFreezed(playerid) && !IsPlayerInRangeOfPoint(playerid, 10.0, FPlayerPos[playerid][0], FPlayerPos[playerid][1], FPlayerPos[playerid][2])) {
        GetPlayerPos(playerid, FPlayerPos[playerid][0], FPlayerPos[playerid][1], FPlayerPos[playerid][2]);
        TogglePlayerControllable(playerid, false);
    }
    return 1;
}
///=== Weapon System ===///
new bool:Weapon[MAX_PLAYERS][47]; // weapon system

stock GivePlayerWeaponEx(playerid, weaponid, ammo) {
    Weapon[playerid][weaponid] = true;
    return GivePlayerWeapon(playerid, weaponid, ammo);
}
stock ResetPlayerWeaponsEx(playerid) {
    for (new i = 0; i < 47; i++) Weapon[playerid][i] = false;
    ResetPlayerWeapons(playerid);
    return 1;
}

stock RemovePlayerWeapon(playerid, weapon) {
    new Weapon_Data[13][2];
    for (new i = 0; i <= 12; i++) GetPlayerWeaponData(playerid, i, Weapon_Data[i][0], Weapon_Data[i][1]);
    ResetPlayerWeaponsEx(playerid);
    for (new i = 0; i <= 12; i++) {
        if(Weapon_Data[i][0] != weapon) GivePlayerWeaponEx(playerid, Weapon_Data[i][0], Weapon_Data[i][1]);
    }
    return 1;
}

stock IsPlayerHaveWeapon(playerid, weaponid) {
    if(!IsPlayerConnected(playerid)) return false;
    else if(weaponid < 0 || weaponid > 47) return false;
    else if(weaponid == 0 || weaponid == 46 || weaponid == 40) return true;
    else return Weapon[playerid][weaponid];
}

#include <YSI_Coding\y_hooks>
hook OnPlayerConnect(playerid) {
    if(IsPlayerNPC(playerid)) return 1;
    ResetPlayerWeaponsEx(playerid);
    return 1;
}

#include <YSI_Coding\y_hooks>
hook OnPlayerDisconnect(playerid, reason) {
    if(IsPlayerNPC(playerid)) return 1;
    ResetPlayerWeaponsEx(playerid);
    return 1;
}
///=== Money System ===///

#include <YSI_Coding\y_hooks>
hook OnPlayerUpdateEx(playerid) {
    if(IsPlayerConnected(playerid)) {
        if(GetPlayerCash(playerid) != GetPlayerMoney(playerid) && Tryg3D::IsPlayerSpawned(playerid)) {
            ResetMoneyBar(playerid); //Resets the money in the original moneybar, Do not remove!
            UpdateMoneyBar(playerid, GetPlayerCash(playerid)); //Sets the money in the moneybar to the serverside cash, Do not remove!
        }
    }
    return 1;
}

///=== Health System ===///
new BitArray:AT_SafeHealth < MAX_PLAYERS > ;
new ResetHealthBitTimer[MAX_PLAYERS];

#include <YSI_Coding\y_hooks>
hook OnPlayerUpdate(playerid) {
    if(Bit_Get(AT_SafeHealth, playerid) || InvicableAuth:GetPlayer(playerid)) return 1;
    new Float:Health, Float:SHealth;
    GetPlayerHealth(playerid, Health);
    SHealth = GetPlayerLastHealth(playerid);
    if(Health != SHealth) {
        if(Health < SHealth) SetPlayerHealthEx(playerid, Health);
        if(Health > SHealth) SetPlayerHealthEx(playerid, SHealth);
    }
    return 1;
}

stock SetPlayerHealthEx(playerid, Float:sHealth) {
    Bit_Set(AT_SafeHealth, playerid, true);
    new nHealth = floatround(sHealth, floatround_round);
    SetPlayerLastHealth(playerid, nHealth);
    SetPlayerHealth(playerid, nHealth);
    ResetHealthBit(playerid);
    return 1;
}

stock GetPlayerHealthEx(playerid) {
    return GetPlayerLastHealth(playerid);
}

stock ResetHealthBit(playerid) {
    KillTimer(ResetHealthBitTimer[playerid]);
    ResetHealthBitTimer[playerid] = SetTimerEx("ResetHealthBitCall", 3000, false, "d", playerid);
    return 1;
}

forward ResetHealthBitCall(playerid);
public ResetHealthBitCall(playerid) {
    Bit_Set(AT_SafeHealth, playerid, false);
    return 1;
}
///=== Armour System ===///
new ResetArmourBitTimer[MAX_PLAYERS];
new BitArray:AT_SafeArmour < MAX_PLAYERS > ;

#include <YSI_Coding\y_hooks>
hook OnPlayerUpdate(playerid) {
    if(Bit_Get(AT_SafeArmour, playerid)) return 1;
    new Float:Armour, Float:SArmour;
    GetPlayerArmour(playerid, Float:Armour);
    SArmour = GetPlayerLastArmour(playerid);
    if(Armour != SArmour) {
        if(Armour < SArmour) SetPlayerArmourEx(playerid, Armour);
        if(Armour > SArmour) {
            SetPlayerArmourEx(playerid, SArmour);
        }
    }
    return 1;
}

stock SetPlayerArmourEx(playerid, Float:varmour) {
    Bit_Set(AT_SafeArmour, playerid, true);
    new narmour = floatround(varmour, floatround_round);
    SetPlayerLastArmour(playerid, narmour);
    SetPlayerArmour(playerid, narmour);
    ResetArmourBit(playerid);
    return 1;
}

stock GetPlayerArmourEx(playerid) {
    return GetPlayerLastArmour(playerid);
}

stock ResetArmourBit(playerid) {
    KillTimer(ResetArmourBitTimer[playerid]);
    ResetArmourBitTimer[playerid] = SetTimerEx("ResetArmourBitCall", 3000, false, "d", playerid);
    return 1;
}

forward ResetArmourBitCall(playerid);
public ResetArmourBitCall(playerid) {
    Bit_Set(AT_SafeArmour, playerid, false);
    return 1;
}