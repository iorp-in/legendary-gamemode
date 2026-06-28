QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new weaponid = GetPlayerWeapon(playerid);
    if (weaponid > 0 && weaponid < 47 && weaponid != 40 && weaponid != 38) QuickActions:AddCommand(playerid, "Give/Share Weapon/item");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Give/Share Weapon/item", inputtext)) return ShareWeaponAmmo(playerid, targetid);
    return 1;
}

stock ShareWeaponAmmo(playerid, toplayerid) {
    new weaponid = GetPlayerWeapon(playerid);
    if (!(weaponid > 0 && weaponid < 47 && weaponid != 40 && weaponid != 38)) return 1;
    return FlexPlayerDialog(playerid, "ShareWeaponAmmo", DIALOG_STYLE_INPUT, "Enter ammo", "How much ammo to share?\ntype 0 to share all", "Share", "Cancel", toplayerid);
}

FlexDialog:ShareWeaponAmmo(playerid, response, listitem, const inputtext[], toplayerid, const payload[]) {
    new weaponid = GetPlayerWeapon(playerid);
    if (!(weaponid > 0 && weaponid < 47 && weaponid != 40 && weaponid != 38) || !response || !IsPlayerConnected(toplayerid)) return 1;
    new ammo;
    if (sscanf(inputtext, "d", ammo) || ammo < 0 || ammo > 1000 || ammo > GetPlayerAmmo(playerid)) return ShareWeaponAmmo(playerid, toplayerid);
    if (ammo == 0) {
        ammo = GetPlayerAmmo(playerid);
        RemovePlayerWeapon(playerid, weaponid);
        GivePlayerWeaponEx(toplayerid, weaponid, ammo);
        AlexaMsg(playerid, sprintf("you have given %s with ammo %d to %s", GetWeaponNameEx(weaponid), ammo, GetPlayerNameEx(toplayerid)));
        AlexaMsg(toplayerid, sprintf("you have received %s with ammo %d from %s", GetWeaponNameEx(weaponid), ammo, GetPlayerNameEx(playerid)));
    } else {
        GivePlayerWeaponEx(playerid, weaponid, -ammo);
        GivePlayerWeaponEx(toplayerid, weaponid, ammo);
        AlexaMsg(playerid, sprintf("you have given %s with ammo %d to %s", GetWeaponNameEx(weaponid), ammo, GetPlayerNameEx(toplayerid)));
        AlexaMsg(toplayerid, sprintf("you have received %s with ammo %d from %s", GetWeaponNameEx(weaponid), ammo, GetPlayerNameEx(playerid)));
    }
    return 1;
}