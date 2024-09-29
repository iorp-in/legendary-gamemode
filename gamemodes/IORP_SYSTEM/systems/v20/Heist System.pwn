/*

1. rob only when cops are live
2. if cops are in certain range, then random 5 to 10 min. if not then 7 to 15.
3. so if not arrested within time then cash will be rewarded to robber
4. members of government are not allowed to do this robberies, even when sign out.

to cops
    30% of robbery
    30% of fine
    random $100 to $1000 for each arrest.

*/

new copsFactions[] = { 0, 1, 2, 3 };

enum Heist:enumd {
    bool:Heist:inHeist,
    Heist:hPrice,
    Heist:pColor,
}

new Heist:data[MAX_PLAYERS][Heist:enumd];

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "LastHeist", "int", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    Heist:data[playerid][Heist:inHeist] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

hook OnPlayerCuffed(playerid) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

hook OnPlayerImairedRequest(playerid) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

hook OnPlayerVirtualWorld(playerid, newvirtualworld, oldvirtualworld) {
    if (IsPlayerInHeist(playerid)) {
        Heist:stop(playerid, false);
    }
    return 1;
}

stock IsPlayerInHeist(playerid) {
    return Heist:data[playerid][Heist:inHeist];
}

stock SetPlayerHeistStatus(playerid, bool:status) {
    Heist:data[playerid][Heist:inHeist] = status;
    return 1;
}

stock Heist:GetOnlineCops() {
    new count = 0;
    foreach(new playerid:Player) {
        if (IsArrayContainNumber(copsFactions, Faction:GetPlayerFID(playerid))) {
            if (Faction:IsPlayerSigned(playerid)) count++;
        }

    }
    return count;
}

stock Heist:StartCopsTimer(seconds = 5) {
    foreach(new playerid:Player) {
        if (IsArrayContainNumber(copsFactions, Faction:GetPlayerFID(playerid))) {
            if (Faction:IsPlayerSigned(playerid)) {
                StopScreenTimer(playerid, 1);
                StartScreenTimer(playerid, seconds);
                GameTextForPlayer(playerid, "~r~robbery in progress", 3 * 1000, 3);
                SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} robber location is marked on your map, catch the robber before timer hit to 0.");
                SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} you will get reward if you stop the robber from getting away.");
            }
        }

    }
    return 1;
}

stock Heist:GiveCopsReward(reward) {
    foreach(new playerid:Player) {
        if (IsArrayContainNumber(copsFactions, Faction:GetPlayerFID(playerid))) {
            if (Faction:IsPlayerSigned(playerid)) {
                vault:PlayerVault(playerid, reward, "reward to cop for heist", Vault_ID_Government, -reward, sprintf("%s reward to cop for heist", GetPlayerNameEx(playerid)));
                SendClientMessage(playerid, -1, sprintf("{FF0000}[Heist]:{FFFF00} you have earned $%s for preventing this heist.", FormatCurrency(reward)));
            } else {
                SendClientMessage(playerid, -1, sprintf("{FF0000}[Heist]:{FFFF00} participate heist and stay alive to get heist reward. you just missed $%s", FormatCurrency(reward)));
            }
        }

    }
    return 1;
}

stock Heist:StopCopsTimer() {
    foreach(new playerid:Player) {
        if (IsArrayContainNumber(copsFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
            if (IsScreenTimerOn(playerid)) StopScreenTimer(playerid, 1);
        }
    }
    return 1;
}

stock IsSomeoneInHeist() {
    foreach(new playerid:Player) {
        if (IsPlayerInHeist(playerid)) return 1;
    }
    return 0;
}

stock Heist:start(playerid, price) {
    if (IsPlayerInHeist(playerid)) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you are already in a heist");
        return 0;
    }

    if (gettime() - Database:GetInt(GetPlayerNameEx(playerid), "username", "LastHeist") < 5 * 60 && GetPlayerAdminLevel(playerid) < 8) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you can rob only once in every 5 minutes");
        return 0;
    }

    if (GetPlayerInteriorID(playerid) != 0 || GetPlayerVirtualWorldID(playerid) != 0) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you are no in heist world :)");
        return 0;
    }

    if (Heist:GetOnlineCops() < 1) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because no cops are available");
        return 0;
    }

    if (Faction:IsPlayerSigned(playerid) && IsArrayContainNumber(copsFactions, Faction:GetPlayerFID(playerid))) {
        // SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you the cop dude.");
        Faction:SignOff(playerid);
    }

    if (IsSomeoneInHeist()) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because one heist is already in progress, wait until it finish");
        return 0;
    }

    new Float:pPos[9];
    GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
    new MapZone:mzoneid = MapZone:GetMapZoneAtPoint2D(pPos[0], pPos[1]);
    if (MapZone:mzoneid == INVALID_MAP_ZONE_ID || GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorldID(playerid) != 0) {
        SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} can not start heist because you are in unknow region");
        return 0;
    }

    GetMapZoneAreaPos(MapZone:mzoneid, pPos[3], pPos[4], pPos[5], pPos[6], pPos[7], pPos[8]);
    FlashZone:Create(pPos[3], pPos[4], pPos[6], pPos[7], 60);
    new zonename[50];
    GetMapZoneName(MapZone:mzoneid, zonename);
    SendClientMessageToAll(-1, sprintf("{FF0000}[Heist]:{FFFF00} robbery in progress at %s", zonename));
    StopScreenTimer(playerid, 1);
    new seconds = Random(200, 350);
    StartScreenTimer(playerid, seconds);
    Heist:StartCopsTimer(seconds);
    Heist:data[playerid][Heist:hPrice] = price;
    Heist:data[playerid][Heist:pColor] = GetPlayerColor(playerid);
    SetPlayerColor(playerid, 0xFF0000FF);
    SetPlayerHeistStatus(playerid, true);
    EnablePlayerRPMode(playerid);
    InvisibleAuth:SetPlayer(playerid, false);
    CallRemoteFunction("OnHeistStart", "dd", playerid, price);
    WantedDatabase:GiveWantedLevel(playerid, sprintf("heist worth $%s", FormatCurrency(price)), 6, false);

    Discord:SendNotification(sprintf("⚔️ robbery in progress at **%s** ⚔️", zonename));
    Discord:SendFactionLobbyLaw(sprintf("⚔️ robbery in progress at **%s** ⚔️ @here", zonename));
    return 1;
}

hook OnScreenTimerFinished(playerid, success) {
    if (success && IsPlayerInHeist(playerid)) Heist:stop(playerid, true);
    if (!success && IsPlayerInHeist(playerid)) Heist:stop(playerid, false);
    return 1;
}

stock Heist:stop(playerid, bool:successful = false) {
    if (!IsPlayerInHeist(playerid)) return 1;
    SetPlayerHeistStatus(playerid, false);
    SetPlayerColor(playerid, Heist:data[playerid][Heist:pColor]);
    CallRemoteFunction("OnHeistFinish", "ddd", playerid, Heist:data[playerid][Heist:hPrice], successful ? 1 : 0);
    Heist:StopCopsTimer();
    StopScreenTimer(playerid, 0);
    return 1;
}

forward OnHeistStart(playerid, price);
public OnHeistStart(playerid, price) {
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "LastHeist");
    WantedDatabase:GiveWantedLevel(playerid, "against heist", 2, false);
    SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} heist started. cops are informed and they are coming to arrest you. get out of this area and survive until your timer hits to 0.");
    SendClientMessage(playerid, -1, "{FF0000}[Heist]:{FFFF00} once the timer hit to 0, you will become invisible to everyone but make sure you have find a hidden spot so that cops can't find you.");
    return 1;
}

forward OnHeistFinish(playerid, price, successful);
public OnHeistFinish(playerid, price, successful) {
    if (successful == 1) {
        vault:PlayerVault(playerid, price, "earned from heist", Vault_ID_Government, -price, sprintf("%s earned from heist", GetPlayerNameEx(playerid)));
        SendClientMessageToAll(-1, sprintf("{FF0000}[Heist]:{FFFF00} a robber successfully robbed $%s from shop", FormatCurrency(price)));
        new debtAmount = GetPercentageOf(RandomEx(50, 80), price);
        Debt:GiveOrTake(playerid, debtAmount, sprintf("Robbed $%d from store", price), 0);
    } else {
        SendClientMessageToAll(-1, sprintf("{FF0000}[Heist]:{FFFF00} a robber failed to rob $%s from shop", FormatCurrency(price)));
        new copreward = GetPercentageOf(30, price);
        Heist:GiveCopsReward(copreward);
    }
    EnablePlayerRPMode(playerid);
    InvisibleAuth:SetPlayer(playerid, true);
    return 1;
}