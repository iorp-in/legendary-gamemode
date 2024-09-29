new AllowedMafia[] = { 0, 1, 2, 3, 5, 7, 8, 9, 10 };

stock MafiaZoneSystem:IsFromMafiaFaction(playerid) {
    return IsArrayContainNumber(AllowedMafia, Faction:GetPlayerFID(playerid));
}

#define MAX_MAFIA_ZONE 10
#define MAX_MAFIA_PROP 100

enum MafiaZoneSystem:enumd {
    MafiaZoneSystem:title[50],
        Float:MafiaZoneSystem:position[10],
        MafiaZoneSystem:zoneColor,
        MafiaZoneSystem:OccupiedBy,
        MafiaZoneSystem:LastOccupiedTime,
        MafiaZoneSystem:LastMemberVisited,

        Text3D:MafiaZoneSystem:zoneMasterNodeText,
        MafiaZoneSystem:zoneObjectID,
        MafiaZoneSystem:zoneRectID,
        MafiaZoneSystem:MasterNodeObjectID,

        MafiaZoneSystem:MaxProp,
        MafiaZoneSystem:GoodProp,

        bool:MafiaZoneSystem:IsFlashing,
        MafiaZoneSystem:FlashStartedAt,
}
new MafiaZoneSystem:zonedata[MAX_MAFIA_ZONE][MafiaZoneSystem:enumd];
new Iterator:mafiazones < MAX_MAFIA_ZONE > ;

enum MafiaZoneSystem:enump {
    MafiaZoneSystem:pTitle[50],
        MafiaZoneSystem:pZoneID,
        Float:MafiaZoneSystem:pPos[6],
        MafiaZoneSystem:Revenue,
        Float:MafiaZoneSystem:pHealth,

        Text3D:MafiaZoneSystem:propText,
        MafiaZoneSystem:NodeObjectID,
        MafiaZoneSystem:FixingProperty,
}
new MafiaZoneSystem:zonepropdata[MAX_MAFIA_PROP][MafiaZoneSystem:enump];
new Iterator:mafiazoneprops < MAX_MAFIA_PROP > ;

// ================== Variables END ==================
// ================== public START ==================

hook OnGameModeInit() {
    new query[1000];
    mysql_format(Database, query, sizeof(query), "CREATE TABLE IF NOT EXISTS `mafiaZones` (\
	  	`id` int(11) NOT NULL,\
	  	`title` text NOT NULL,\
	  	`zoneColor` int NOT NULL,\
	  	`OccupiedBy` int NOT NULL,\
	  	`LastOccupiedTime` int NOT NULL,\
	  	`LastMemberVisited` int NOT NULL,\
	  	`pos_0` float NOT NULL,\
	  	`pos_1` float NOT NULL,\
	  	`pos_2` float NOT NULL,\
	  	`pos_3` float NOT NULL,\
	  	`pos_4` float NOT NULL,\
	  	`pos_5` float NOT NULL,\
	  	`pos_6` float NOT NULL,\
	  	`pos_7` float NOT NULL,\
	  	`pos_8` float NOT NULL,\
	  	`pos_9` float NOT NULL,\
        PRIMARY KEY  (`id`))");
    mysql_tquery(Database, query);
    mysql_format(Database, query, sizeof(query), "CREATE TABLE IF NOT EXISTS `mafiaZonesProp` (\
	  	`id` int(11) NOT NULL,\
	  	`pTitle` text NOT NULL,\
	  	`pZoneID` int NOT NULL,\
	  	`Revenue` int NOT NULL,\
	  	`pHealth` float NOT NULL,\
	  	`pos_0` float NOT NULL,\
	  	`pos_1` float NOT NULL,\
	  	`pos_2` float NOT NULL,\
	  	`pos_3` float NOT NULL,\
	  	`pos_4` float NOT NULL,\
	  	`pos_5` float NOT NULL,\
        PRIMARY KEY  (`id`))");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM `mafiaZones`", "LoadMafiaZones");
    mysql_tquery(Database, "SELECT * FROM `mafiaZonesProp`", "LoadMafiaZoneProps");
    SetTimer("MafiaMasterNodeUpdate", 3 * 1000, true);
    SetTimer("MafiaGenerateRevenue", 3 * 1000, true);
    SetTimer("MafiaPropHealthReduce", 10 * 1000, true);
    return 1;
}

forward LoadMafiaZones();
public LoadMafiaZones() {
    new rows = cache_num_rows();
    new zoneid, loaded;
    if (rows) {
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "id", zoneid);
            cache_get_value_name(loaded, "title", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title], 50);
            cache_get_value_name_int(loaded, "zoneColor", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
            cache_get_value_name_int(loaded, "OccupiedBy", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy]);
            cache_get_value_name_int(loaded, "LastOccupiedTime", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime]);
            cache_get_value_name_int(loaded, "LastMemberVisited", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited]);
            cache_get_value_name_float(loaded, "pos_0", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0]);
            cache_get_value_name_float(loaded, "pos_1", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1]);
            cache_get_value_name_float(loaded, "pos_2", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2]);
            cache_get_value_name_float(loaded, "pos_3", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3]);
            cache_get_value_name_float(loaded, "pos_4", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4]);
            cache_get_value_name_float(loaded, "pos_5", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5]);
            cache_get_value_name_float(loaded, "pos_6", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6]);
            cache_get_value_name_float(loaded, "pos_7", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7]);
            cache_get_value_name_float(loaded, "pos_8", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8]);
            cache_get_value_name_float(loaded, "pos_9", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9]);
            Iter_Add(mafiazones, zoneid);

            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText] = CreateDynamic3DTextLabel("Master Node", 0xFFFF00FF, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6], 10);
            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID] = CreateZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3]);
            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID] = CreateDynamicObject(16003, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9]);
            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneRectID] = CreateDynamicRectangle(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3], 0, 0);
            CreateZoneBorders(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
            ShowZoneForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
            MafiaZoneSystem:UpdateMasterNode(zoneid);

            loaded++;
        }
    }
    printf("  [mafia zones] %d loaded.", loaded);
    return 1;
}

forward LoadMafiaZoneProps();
public LoadMafiaZoneProps() {
    new rows = cache_num_rows();
    new propid, loaded;
    if (rows) {
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "id", propid);
            cache_get_value_name(loaded, "pTitle", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle], 50);
            cache_get_value_name_int(loaded, "pZoneID", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID]);
            cache_get_value_name_int(loaded, "Revenue", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue]);
            cache_get_value_name_float(loaded, "pHealth", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth]);
            cache_get_value_name_float(loaded, "pos_0", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0]);
            cache_get_value_name_float(loaded, "pos_1", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1]);
            cache_get_value_name_float(loaded, "pos_2", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2]);
            cache_get_value_name_float(loaded, "pos_3", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3]);
            cache_get_value_name_float(loaded, "pos_4", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4]);
            cache_get_value_name_float(loaded, "pos_5", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5]);
            Iter_Add(mafiazoneprops, propid);

            MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] = -1;
            MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText] = CreateDynamic3DTextLabel("Propery of Zone", 0xFFFF00FF, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2], 10);
            MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID] = CreateDynamicObject(1687, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5]);
            MafiaZoneSystem:UpdateSubNode(propid);

            loaded++;
        }
    }
    printf("  [mafia zone props] %d loaded.", loaded);
    return 1;
}


hook OnPlayerConnect(playerid) {
    foreach(new zoneid:mafiazones) {
        ShowZoneForPlayer(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing]) ZoneFlashForPlayer(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], 0xFF0000AA);
    }
    return 1;
}

forward MafiaMasterNodeUpdate();
public MafiaMasterNodeUpdate() {
    foreach(new zoneid:mafiazones) {
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing]) {
            if (gettime() - MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:FlashStartedAt] > 300) {
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing] = false;
                ZoneStopFlashForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
            }
        }

        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] != -1) {
            if (gettime() - MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] > 24 * 60 * 60) {
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] = -1;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime] = 0;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] = gettime();
                foreach(new propid:mafiazoneprops) {
                    if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] == zoneid) {
                        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] = 0;
                        MafiaZoneSystem:UpdateSubNode(propid);
                    }
                }
                SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFFFFF} no member has been in %s zone in while, the zone is auto reseted now", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
            }
        }
        new maxprop = 0, goodprop = 0;
        foreach(new propid:mafiazoneprops) {
            if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] == zoneid) {
                if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0.0) {
                    goodprop++;
                }
                maxprop++;
            }
        }
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MaxProp] = maxprop;
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:GoodProp] = goodprop;
        MafiaZoneSystem:UpdateMasterNode(zoneid);
        MafiaZoneSystem:DatabaseUpdateZone(zoneid);
    }
    return 1;
}

forward MafiaGenerateRevenue();
public MafiaGenerateRevenue() {
    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0.0 && MafiaZoneSystem:IsPropOccupied(propid)) {
            if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] < 2000) {
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] += Random(3, 6);
                MafiaZoneSystem:UpdateSubNode(propid);
            }
        }

        MafiaZoneSystem:DatabaseUpdateProp(propid);
    }
    return 1;
}

forward MafiaPropHealthReduce();
public MafiaPropHealthReduce() {
    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0.0 && MafiaZoneSystem:IsPropOccupied(propid)) {
            MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth]--;
            MafiaZoneSystem:UpdateSubNode(propid);
        }

        MafiaZoneSystem:DatabaseUpdateProp(propid);
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid) {
    foreach(new zoneid:mafiazones) {
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneRectID] == areaid) {
            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] = gettime();
            if (IsTimePassedForPlayer(playerid, "gangzonewarning", 60)) {
                SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have entered %s zone area, please be aware of citical gang activities.", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
            }
        }
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid) {
    foreach(new zoneid:mafiazones) {
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneRectID] == areaid) {
            MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] = gettime();
            if (IsTimePassedForPlayer(playerid, "gangzonewarning", 60)) {
                SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have leaved %s zone area.", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
            }
        }
    }
    return 1;
}

hook OnPlayerShootDynObj(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z) {
    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID] == objectid) {
            new Float:damage = GetWeaponDamageFromDistance(weaponid, GetPlayerDistanceFromPoint(playerid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2])) / 1.5;
            if (Float:damage < 0.0) damage = 0.0;
            MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] -= damage;
            MafiaZoneSystem:UpdateSubNode(propid);
            if (MafiaZoneSystem:IsPropOccupied(propid)) {
                new zoneid = MafiaZoneSystem:GetPropZoneID(propid);
                new propfaction = MafiaZoneSystem:getPropFactionID(propid);

                if (propfaction == Faction:GetPlayerFID(playerid)) {
                    continue;
                }

                foreach(new i:Player) {
                    if (propfaction == Faction:GetPlayerFID(i) && IsTimePassedForPlayer(i, "zoneAlert", 10)) {
                        GameTextForPlayer(i, sprintf("~r~Zone Under Attack~n~~w~zone:~g~%s", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]), 3000, 3);
                        SendClientMessage(i, -1, sprintf("{4286f4}[Alexa]:{FF0000} %s zone under attack, please secure your zone or you will lost it.", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
                    }
                }

                if (!MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing]) {
                    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing] = true;
                    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:FlashStartedAt] = gettime();
                    ZoneFlashForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], 0xFF0000AA);
                    SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FF0000} %s zone under attack", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
                    Discord:SendNotification(sprintf("⚔️ **%s** zone under attack ⚔️", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
                    Discord:SendFactionLobby(sprintf("⚔️ **%s** zone under attack ⚔️ @here", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
                }
            }
        }
    }

    foreach(new zoneid:mafiazones) {
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID] == objectid && MafiaZoneSystem:IsFromMafiaFaction(playerid) && Faction:IsPlayerSigned(playerid)) {
            new bool:timep = IsTimePassedForPlayer(playerid, "nodeWarning", 5);
            if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] == Faction:GetPlayerFID(playerid)) {
                // SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} destroy all properties to capture this zone.");
            } else if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:GoodProp] == 0) {
                new sinceCaptured = gettime() - MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime];
                if (sinceCaptured < 1800) {
                    new lastVisit[100];
                    UnixToHuman(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime] + 1800, lastVisit);
                    if (timep) SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} try to capture this zone after %s.", lastVisit));
                } else {
                    new factionid = Faction:GetPlayerFID(playerid);
                    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] = factionid;
                    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime] = gettime();
                    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:IsFlashing] = false;
                    ZoneStopFlashForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
                    MafiaZoneSystem:UpdateMasterNode(zoneid);
                    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} your team have captured this zone, for next 1:40 hour there will be no fight.");
                }
            } else {
                if (timep) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} destroy all properties to capture this zone.");
            }
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        new zoneid = MafiaZoneSystem:GetPlayerNearestMasterNode(playerid);
        if (zoneid != -1) {
            Faction:ShowLocker(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy]);
            return 1;
        }

        new propid = MafiaZoneSystem:GetPlayerNearestProp(playerid);
        if (propid != -1) {
            if (Faction:GetPlayerFID(playerid) == MafiaZoneSystem:zonedata[MafiaZoneSystem:GetPropZoneID(propid)][MafiaZoneSystem:OccupiedBy] && Faction:IsPlayerSigned(playerid)) {
                if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] < 0) {
                    if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] != -1) {
                        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] != playerid) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} someone already fixing it please wait...");
                        return 1;
                    }
                    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] = playerid;
                    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} fixing property please wait...");
                    new time = Random(5, 20);
                    StopScreenTimer(playerid, 1);
                    StartScreenTimer(playerid, time);
                    freezeEx(playerid, time * 1000);
                    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1);
                    SetTimerEx("HealZoneProperty", time * 1000, false, "dd", playerid, propid);
                    return ~1;
                } else if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] > 0) {
                    if (!IsTimePassedForPlayer(playerid, "mafiaPropWithdrawal", 10)) {
                        AlexaMsg(playerid, "please wait 1 minute...");
                        GameTextForPlayer(playerid, "~w~please wait~n~~r~10 Seconds", 3000, 3);
                        return ~1;
                    } else {
                        new factionid = MafiaZoneSystem:getPropFactionID(propid);
                        // new vaultid = Faction:GetVaultID(factionid);
                        new cash = MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue];
                        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] -= cash;
                        GivePlayerCash(playerid, cash, sprintf("taken from zone property [%d] [f - %d]", propid, factionid));
                        // if (vault:isValidID(vaultid)) {
                        // vault:addcash(vaultid, cash, Vault_Transaction_Cash_To_Vault, sprintf("deposited in vault %d by %s from zone property [%d]", vaultid, GetPlayerNameEx(playerid), propid));
                        // SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} money has been transfered to your faction vault.");
                        // } else {
                        // SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} your faction does not have vault, you can not collect money.");
                        // }
                        return ~1;
                    }
                }
            }
        }
    }
    return 1;
}

forward HealZoneProperty(playerid, propid);
public HealZoneProperty(playerid, propid) {
    if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] == -1) return 1;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] = -1;
    if (!IsPlayerConnected(playerid)) return 1;
    if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0) return 1;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] = 5000;
    MafiaZoneSystem:UpdateSubNode(propid);
    SetPlayerSpecialAction(playerid, 0);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} property fixed, revenue generating restarted");
    return 1;
}


// hook OnPlayerEnterGangZone(playerid, zoneid) {
//     foreach(new zid:mafiazones) {
//         if(MafiaZoneSystem:zonedata[zid][MafiaZoneSystem:zoneObjectID] == zoneid) {
//             SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have entered %s zone area, please be aware of citical activities.", MafiaZoneSystem:zonedata[zid][MafiaZoneSystem:title]));
//         }
//     }
//     return 1;
// }
// 
// hook OnPlayerLeaveGangZone(playerid, zoneid) {
//     foreach(new zid:mafiazones) {
//         if(MafiaZoneSystem:zonedata[zid][MafiaZoneSystem:zoneObjectID] == zoneid) {
//             SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have leaved %s zone area, please be aware of citical activities.", MafiaZoneSystem:zonedata[zid][MafiaZoneSystem:title]));
//         }
//     }
//     return 1;
// }

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "mafia system") && GetPlayerAdminLevel(playerid) >= 8) {
        MafiaZoneSystem:AdminPanel(playerid);
        return 1;
    }
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (GetPlayerAdminLevel(playerid) < 8) return 1;
    foreach(new zoneid:mafiazones) {
        if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID] == objectid) {
            if (response == EDIT_RESPONSE_FINAL) {
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4] = x;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5] = y;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6] = z;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7] = rx;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8] = ry;
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9] = rz;
                SetDynamicObjectPos(objectid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6]);
                SetDynamicObjectRot(objectid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9]);
                DestroyDynamic3DTextLabel(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText]);
                MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText] = CreateDynamic3DTextLabel("Master Node", 0xFFFF00FF, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6], 10);
                MafiaZoneSystem:UpdateMasterNode(zoneid);
                SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} zone [%d] master node position has been updated", zoneid));
            } else if (response == EDIT_RESPONSE_CANCEL) {
                SetDynamicObjectPos(objectid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6]);
                SetDynamicObjectRot(objectid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9]);
            }
        }
    }

    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID] == objectid) {
            if (response == EDIT_RESPONSE_FINAL) {
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0] = x;
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1] = y;
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2] = z;
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3] = rx;
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4] = ry;
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5] = rz;
                SetDynamicObjectPos(objectid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2]);
                SetDynamicObjectRot(objectid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5]);
                DestroyDynamic3DTextLabel(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText]);
                MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText] = CreateDynamic3DTextLabel("Propery of Zone", 0xFFFF00FF, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2], 10);
                MafiaZoneSystem:UpdateSubNode(propid);
                SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} property [%d] sub node position has been updated", propid));
            } else if (response == EDIT_RESPONSE_CANCEL) {
                SetDynamicObjectPos(objectid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2]);
                SetDynamicObjectRot(objectid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5]);
            }
        }
    }
    return 1;
}

// ================== public END ==================

// ================== Database Start ==================

stock MafiaZoneSystem:DatabaseCreateZone(zoneid) {
    mysql_tquery(Database, sprintf("INSERT INTO mafiaZones (id, title, zoneColor, OccupiedBy, LastOccupiedTime, LastMemberVisited, pos_0, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6, pos_7, pos_8, pos_9) VALUES (%d, \"%s\", %d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)",
        zoneid,
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9]
    ));
    return 1;
}

stock MafiaZoneSystem:DatabaseUpdateZone(zoneid) {
    mysql_tquery(Database, sprintf("update mafiaZones set title = \"%s\", zoneColor = %d, OccupiedBy = %d, LastOccupiedTime = %d, LastMemberVisited = %d, pos_0 = %f, pos_1 = %f, pos_2 = %f, pos_3 = %f, pos_4 = %f, pos_5 = %f, pos_6 = %f, pos_7 = %f, pos_8 = %f, pos_9 = %f where id = %d",
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9],
        zoneid
    ));
    return 1;
}

stock MafiaZoneSystem:DatabaseRemoveZone(zoneid) {
    mysql_tquery(Database, sprintf("delete from mafiaZones where id = %d", zoneid));
    return 1;
}


stock MafiaZoneSystem:DatabaseCreateProp(propid) {
    mysql_tquery(Database, sprintf("INSERT INTO mafiaZonesProp (id, pTitle, pZoneID, Revenue, pHealth, pos_0, pos_1, pos_2, pos_3, pos_4, pos_5) VALUES (%d, \"%s\", %d, %d, %f, %f, %f, %f, %f, %f, %f)",
        propid,
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5]
    ));
    return 1;
}

stock MafiaZoneSystem:DatabaseUpdateProp(propid) {
    mysql_tquery(Database, sprintf("update mafiaZonesProp set pTitle = \"%s\", pZoneID = %d, Revenue = %d, pHealth = %f, pos_0 = %f, pos_1 = %f, pos_2 = %f, pos_3 = %f, pos_4 = %f, pos_5 = %f where id = %d",
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5],
        propid
    ));
    return 1;
}

stock MafiaZoneSystem:DatabaseRemoveProp(propid) {
    mysql_tquery(Database, sprintf("delete from mafiaZonesProp where id = %d", propid));
    return 1;
}

stock MafiaZoneSystem:DatabaseRemoveAllProp(zoneid) {
    mysql_tquery(Database, sprintf("delete from mafiaZonesProp where pZoneID = %d", zoneid));
    return 1;
}

// ================== Database END ==================

// ================== STOCK START ==================

stock MafiaZoneSystem:IsValidZoneID(zoneid) {
    return Iter_Contains(mafiazones, zoneid);
}

stock MafiaZoneSystem:IsOccupied(zoneid) {
    return MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] == -1 ? 0 : 1;
}

stock MafiaZoneSystem:GetOccupier(zoneid) {
    return MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy];
}

stock MafiaZoneSystem:IsValidPropID(propid) {
    return Iter_Contains(mafiazoneprops, propid);
}

stock MafiaZoneSystem:IsPropOccupied(propid) {
    new zoneid = MafiaZoneSystem:GetPropZoneID(propid);
    return MafiaZoneSystem:IsOccupied(zoneid);
}

stock MafiaZoneSystem:getPropFactionID(propid) {
    new zoneid = MafiaZoneSystem:GetPropZoneID(propid);
    return MafiaZoneSystem:GetOccupier(zoneid);
}

stock MafiaZoneSystem:GetPropZoneID(propid) {
    return MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID];
}

stock MafiaZoneSystem:GetTotalProp(zoneid) {
    new count = 0;
    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] == zoneid) {
            count++;
        }
    }
    return count;
}

stock MafiaZoneSystem:GetPlayerNearestProp(playerid, Float:distance = 5.0) {
    foreach(new propid:mafiazoneprops) {
        if (IsPlayerInRangeOfPoint(playerid, distance, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2])) return propid;
    }
    return -1;
}

stock MafiaZoneSystem:GetPlayerNearestMasterNode(playerid, Float:distance = 5.0) {
    foreach(new zoneid:mafiazones) {
        if (IsPlayerInRangeOfPoint(playerid, distance, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6])) return zoneid;
    }
    return -1;
}

stock MafiaZoneSystem:UpdateMasterNode(zoneid) {
    if (!MafiaZoneSystem:IsValidZoneID(zoneid)) return 1;
    new string[512];
    new lastVisit[100];
    UnixToHuman(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited], lastVisit);
    strcat(string, sprintf("{FF0000}Master Node of %s Zone [%d]\n", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title], zoneid));
    strcat(string, sprintf("{ffff66}Property of:{3399ff} %s\n", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] == -1 ? sprintf("%s", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]) : Faction:GetName(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy])));
    strcat(string, sprintf("{ffff66}Last Member Visited At:{3399ff} %s\n", lastVisit));
    strcat(string, sprintf("{ffff66}Working Properties:{3399ff} %d out of %d\n", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:GoodProp], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MaxProp]));
    if (MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:GoodProp] == 0) strcat(string, sprintf("{FFAAAA}shoot this node to capture\n"));
    strcat(string, sprintf("{FFFF00}\nPress N to open faction locker\n"));
    UpdateDynamic3DTextLabelText(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText], -1, string);
    return 1;
}

stock MafiaZoneSystem:UpdateSubNode(propid) {
    if (!MafiaZoneSystem:IsValidPropID(propid)) return 1;
    new string[512], zoneid = MafiaZoneSystem:GetPropZoneID(propid);
    strcat(string, sprintf("{FF0000}%s [%d]\n", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle], propid));
    strcat(string, sprintf("{ffff66}Property of:{3399ff} %s zone\n", MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title]));
    strcat(string, sprintf("{ffff66}Status:{3399ff} %s\n", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0.0 ? sprintf("Generating Revenue ($%s)", FormatCurrency(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue])) : "Damaged"));
    if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] > 0.0) strcat(string, sprintf("{ffff66}Health:{3399ff} %.0f/5000\n\n{FFA500}press N to collect revenue", MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth]));
    else strcat(string, sprintf("{FFA500}press N to repair"));
    UpdateDynamic3DTextLabelText(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText], -1, string);
    return 1;
}

// ================== STOCK END ==================

stock MafiaZoneSystem:AdminPanel(playerid) {
    new string[512];
    strcat(string, "Create Zone\n");
    strcat(string, "Manage Zone\n");
    return FlexPlayerDialog(playerid, "MafiaZoneSystemAdminPanel", DIALOG_STYLE_LIST, "Mafia Zone System: Admin Panel", string, "Select", "Close");
}

FlexDialog:MafiaZoneSystemAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Zone")) return MafiaZoneSystem:CreateInput(playerid);
    if (IsStringSame(inputtext, "Manage Zone")) return MafiaZoneSystem:ManageInput(playerid);
    return 1;
}

stock MafiaZoneSystem:ManageInput(playerid) {
    return FlexPlayerDialog(playerid, "MafiaZoneManageZone", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter Zone ID", "Manage", "Back");
}

FlexDialog:MafiaZoneManageZone(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return MafiaZoneSystem:AdminPanel(playerid);
    new zoneid;
    if (sscanf(inputtext, "d", zoneid) || !MafiaZoneSystem:IsValidZoneID(zoneid)) return MafiaZoneSystem:ManageInput(playerid);
    return MafiaZoneSystem:ManageZone(playerid, zoneid);
}

stock MafiaZoneSystem:CreateInput(playerid) {
    return FlexPlayerDialog(playerid, "MafiaZoneSystemCreate", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "[MinX] [MinY] [MaxX] [MaxY] [Color Hex]", "Create", "Back");
}

FlexDialog:MafiaZoneSystemCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return MafiaZoneSystem:AdminPanel(playerid);
    new Float:zpos[4], zcolor;
    if (sscanf(inputtext, "ffffN(0xFFFFFFAA)", zpos[0], zpos[1], zpos[2], zpos[3], zcolor)) return MafiaZoneSystem:CreateInput(playerid);
    new zoneid = Iter_Free(mafiazones);
    if (zoneid == INVALID_ITERATOR_SLOT) return 1;
    Iter_Add(mafiazones, zoneid);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] = -1;
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime] = 0;
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] = gettime();
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor] = zcolor;
    format(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title], 50, "zone");
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0] = zpos[0];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1] = zpos[1];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2] = zpos[2];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3] = zpos[3];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][7] = 0.0;
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][8] = 0.0;
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][9] = 0.0;
    GetPlayerPos(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6]);
    TeleportInFront(playerid);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText] = CreateDynamic3DTextLabel("Master Node", 0xFFFF00FF, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6], 10);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID] = CreateZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3]);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID] = CreateDynamicObject(16003, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6], 0, 0, 0);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneRectID] = CreateDynamicRectangle(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3], 0, 0);
    CreateZoneBorders(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
    ShowZoneForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
    MafiaZoneSystem:UpdateMasterNode(zoneid);
    MafiaZoneSystem:DatabaseCreateZone(zoneid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}mafia zone created, you can check that by viewing your map.");
    return 1;
}

stock MafiaZoneSystem:ManageZone(playerid, zoneid) {
    new string[512];
    if (MafiaZoneSystem:IsOccupied(zoneid)) {
        strcat(string, "IsCaptured\tYes\n");
        strcat(string, sprintf("Current Occupier\t%s\n", Faction:GetName(MafiaZoneSystem:GetOccupier(zoneid))));
        strcat(string, "Reset Status To Unoccupied\n");
    } else {
        strcat(string, "IsCaptured\tNo\n");
    }
    strcat(string, "Update Zone Name\n");
    strcat(string, "Update Zone Cordinates\n");
    strcat(string, "Update Zone Color\n");
    strcat(string, "Update Master Node Coordinates\n");
    strcat(string, "Create Properties\n");
    strcat(string, "Manage Properties\n");
    strcat(string, "Remove Zone\n");
    return FlexPlayerDialog(playerid, "MafiaZoneSystemManageZone", DIALOG_STYLE_TABLIST, "Mafia Zone System: Admin Panel", string, "Select", "Close", zoneid);
}

FlexDialog:MafiaZoneSystemManageZone(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Reset Status To Unoccupied")) {
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:OccupiedBy] = -1;
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastOccupiedTime] = 0;
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:LastMemberVisited] = 0;
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}mafia zone has been reseted to normal, it will not generate revenue.");
        MafiaZoneSystem:ManageZone(playerid, zoneid);
        return 1;
    }
    if (IsStringSame(inputtext, "Update Master Node Coordinates")) {
        EditDynamicObject(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID]);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}location edit mode enabled, do not forget to click save once done.");
        // GetPlayerPos(playerid, MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][4], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][5], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][6]);
        // MafiaZoneSystem:ManageZone(playerid, zoneid);
        return 1;
    }
    if (IsStringSame(inputtext, "Remove Zone")) {
        foreach(new propid:mafiazoneprops) {
            if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] == zoneid) {
                DestroyDynamic3DTextLabel(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText]);
                DestroyDynamicObjectEx(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID]);
                Iter_SafeRemove(mafiazoneprops, propid, propid);
            }
        }
        DestroyZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
        DestroyDynamicArea(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneRectID]);
        DestroyDynamic3DTextLabel(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneMasterNodeText]);
        DestroyDynamicObjectEx(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:MasterNodeObjectID]);
        MafiaZoneSystem:DatabaseRemoveAllProp(zoneid);
        MafiaZoneSystem:DatabaseRemoveZone(zoneid);
        Iter_SafeRemove(mafiazones, zoneid, zoneid);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}zone has been removed.");
        MafiaZoneSystem:AdminPanel(playerid);
        return 1;
    }
    if (IsStringSame(inputtext, "Update Zone Cordinates")) return MafiaZoneSystem:MenuUpdateZoneCord(playerid, zoneid);
    if (IsStringSame(inputtext, "Update Zone Name")) return MafiaZoneSystem:MenuUpdateZoneName(playerid, zoneid);
    if (IsStringSame(inputtext, "Update Zone Color")) return MafiaZoneSystem:MenuUpdateZoneColor(playerid, zoneid);

    if (IsStringSame(inputtext, "Create Properties")) {
        if (MafiaZoneSystem:GetTotalProp(zoneid) >= 10) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}max properties created for this zone, delete or update current one.");
            MafiaZoneSystem:ManageZone(playerid, zoneid);
            return 1;
        }
        return MafiaZoneSystem:MenuCreateProp(playerid, zoneid);
    }
    if (IsStringSame(inputtext, "Manage Properties")) return MafiaZoneSystem:MenuManageProp(playerid, zoneid);
    MafiaZoneSystem:ManageZone(playerid, zoneid);
    return 1;
}

stock MafiaZoneSystem:MenuUpdateZoneCord(playerid, zoneid) {
    return FlexPlayerDialog(playerid, "MafiaMenuUpdateZoneCord", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "[MinX] [MinY] [MaxX] [MaxY]", "Update", "Back", zoneid);
}

FlexDialog:MafiaMenuUpdateZoneCord(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    new Float:zpos[4];
    if (sscanf(inputtext, "ffff", zpos[0], zpos[1], zpos[2], zpos[3])) return MafiaZoneSystem:MenuUpdateZoneCord(playerid, zoneid);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0] = zpos[0];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1] = zpos[1];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2] = zpos[2];
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3] = zpos[3];
    DestroyZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID] = CreateZone(
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1],
        MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3]
    );
    CreateZoneBorders(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
    ShowZoneForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}zone cordinates has been updated.");
    return MafiaZoneSystem:ManageZone(playerid, zoneid);
}

stock MafiaZoneSystem:MenuUpdateZoneName(playerid, zoneid) {
    return FlexPlayerDialog(playerid, "MafiaMenuUpdateZoneName", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter name", "Update", "Back", zoneid);
}

FlexDialog:MafiaMenuUpdateZoneName(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    new zTitle[50];
    if (sscanf(inputtext, "s[50]", zTitle)) return MafiaZoneSystem:MenuUpdateZoneName(playerid, zoneid);
    format(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:title], 50, "%s", zTitle);
    MafiaZoneSystem:UpdateMasterNode(zoneid);
    foreach(new propid:mafiazoneprops) {
        if (MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] == zoneid) {
            MafiaZoneSystem:UpdateSubNode(propid);
        }
    }
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}zone name has been updated to new, please verify the change.");
    return MafiaZoneSystem:ManageZone(playerid, zoneid);
}

stock MafiaZoneSystem:MenuUpdateZoneColor(playerid, zoneid) {
    return FlexPlayerDialog(playerid, "MafiaMenuUpdateZoneColor", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter color for faction zone", "Update", "Back", zoneid);
}

FlexDialog:MafiaMenuUpdateZoneColor(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    new zcolor;
    if (sscanf(inputtext, "N(0xFFFFFFAA)", zcolor)) return MafiaZoneSystem:MenuUpdateZoneColor(playerid, zoneid);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor] = zcolor;
    DestroyZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
    MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID] = CreateZone(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][0], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][1], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][2], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:position][3]);
    CreateZoneBorders(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID]);
    ShowZoneForAll(MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneObjectID], MafiaZoneSystem:zonedata[zoneid][MafiaZoneSystem:zoneColor]);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}zone color has been updated to new, please verify the change.");
    return MafiaZoneSystem:ManageZone(playerid, zoneid);
}

stock MafiaZoneSystem:MenuCreateProp(playerid, zoneid) {
    return FlexPlayerDialog(playerid, "MafiaMenuCreateProp", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter Property Name", "Submit", "Back", zoneid);
}

FlexDialog:MafiaMenuCreateProp(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    new pTitle[50];
    if (sscanf(inputtext, "s[50]", pTitle)) return MafiaZoneSystem:MenuCreateProp(playerid, zoneid);
    new propid = Iter_Free(mafiazoneprops);
    Iter_Add(mafiazoneprops, propid);
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:FixingProperty] = -1;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pHealth] = 5000.00;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pZoneID] = zoneid;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:Revenue] = 0;
    format(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle], 50, "%s", pTitle);
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][3] = 0.0;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][4] = 0.0;
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][5] = 0.0;
    GetPlayerPos(
        playerid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2]
    );
    TeleportInFront(playerid);
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText] = CreateDynamic3DTextLabel(
        "Propery of Zone", 0xFFFF00FF, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2], 10
    );
    MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID] = CreateDynamicObject(
        1687, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][0], MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][1],
        MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pPos][2], 0, 0, 0
    );
    MafiaZoneSystem:ManageZone(playerid, zoneid);
    MafiaZoneSystem:UpdateSubNode(propid);
    MafiaZoneSystem:DatabaseCreateProp(propid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}property created for current zone, please manage it to update reset details.");
    return MafiaZoneSystem:ManageZone(playerid, zoneid);
}

stock MafiaZoneSystem:MenuManageProp(playerid, zoneid) {
    return FlexPlayerDialog(playerid, "MafiaMenuManageProp", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter Propertie ID", "Submit", "Back", zoneid);
}

FlexDialog:MafiaMenuManageProp(playerid, response, listitem, const inputtext[], zoneid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    new propid;
    if (sscanf(inputtext, "d", propid) || !MafiaZoneSystem:IsValidPropID(propid)) return MafiaZoneSystem:MenuManageProp(playerid, zoneid);
    return MafiaZoneSystem:ManageProp(playerid, propid);
}

stock MafiaZoneSystem:ManageProp(playerid, propid) {
    new string[512];
    strcat(string, "Update Name\n");
    strcat(string, "Update Location\n");
    strcat(string, "Remove\n");
    return FlexPlayerDialog(playerid, "MafiaManageProp", DIALOG_STYLE_LIST, "Mafia Zone System: Admin Panel", string, "Submit", "Back", propid);
}

FlexDialog:MafiaManageProp(playerid, response, listitem, const inputtext[], propid, const payload[]) {
    new zoneid = MafiaZoneSystem:GetPropZoneID(propid);
    if (!response) return MafiaZoneSystem:ManageZone(playerid, zoneid);
    if (IsStringSame(inputtext, "Update Name")) return MafiaZoneSystem:MenuUpdatePropName(playerid, propid);
    if (IsStringSame(inputtext, "Update Location")) {
        EditDynamicObject(playerid, MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID]);
        return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}property location edit mode enabled.");
    }
    if (IsStringSame(inputtext, "Remove")) {
        DestroyDynamic3DTextLabel(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:propText]);
        DestroyDynamicObjectEx(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:NodeObjectID]);
        MafiaZoneSystem:DatabaseRemoveProp(propid);
        Iter_SafeRemove(mafiazoneprops, propid, propid);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}property name has been removed. 1 slot has been freezed for this zone.");
        return MafiaZoneSystem:ManageZone(playerid, zoneid);
    }
    return 1;
}

stock MafiaZoneSystem:MenuUpdatePropName(playerid, propid) {
    return FlexPlayerDialog(playerid, "MafiaMenuUpdatePropName", DIALOG_STYLE_INPUT, "Mafia Zone System: Admin Panel", "Enter new name for property", "Submit", "Back", propid);
}

FlexDialog:MafiaMenuUpdatePropName(playerid, response, listitem, const inputtext[], propid, const payload[]) {
    if (!response) return MafiaZoneSystem:ManageProp(playerid, propid);
    new pTitle[50];
    if (sscanf(inputtext, "s[50]", pTitle)) return MafiaZoneSystem:MenuUpdatePropName(playerid, propid);
    format(MafiaZoneSystem:zonepropdata[propid][MafiaZoneSystem:pTitle], 50, "%s", pTitle);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFFF}property name has been updated.");
    return MafiaZoneSystem:ManageProp(playerid, propid);
}