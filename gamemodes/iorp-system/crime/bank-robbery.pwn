#define BankRobColumn "bankroblast"
#define MafiaSettingsID 0
#define RobMin 10
#define HostageFreezeTime 60*1000
#define CivilRequired 1
#define MedicRequired 1
#define LawRequired 3
#define RobbersRequired 3
#define lawAtBankRequired 2
#define cashReward 100000

new AllowedFaction[] = { 5, 7, 8, 9, 10 };
new AllowedLawFaction[] = { 0, 1, 2, 3 };

enum RobBankData {
    Float:robRange,
    Float:robBankPos[3],
    robBankName[100],
    robBankLocation[100],
    Float:robBankLockerFirst[3],
    Float:robBankLockerSecond[3]
}
new BankLocations[][RobBankData] = {
    {
        // world bank ls
        300.0,
        {
            2950.6941,
            -1026.4917,
            11.8258
        },
        "World Bank",
        "Los Santos",
        {
            2949.2920,
            -1042.2399,
            11.8258
        },
        {
            2955.5996,
            -1042.2969,
            11.8258
        }
    }
};

stock GetBankLocation(playerid) {
    for (new i; i < sizeof BankLocations; i++) {
        if (IsPlayerInRangeOfPoint(playerid, BankLocations[i][robRange] / 3, BankLocations[i][robBankPos][0], BankLocations[i][robBankPos][1], BankLocations[i][robBankPos][2])) return i;
    }
    return -1;
}

stock GetMafiaHqLocation(rFactionID, & Float:rPosX, & Float:rPosY, & Float:rPosZ) {
    if (rFactionID == 5) {
        rPosX = 1246.5486;
        rPosY = -812.7684;
        rPosZ = 84.1478;
    } else if (rFactionID == 7) {
        rPosX = 2808.8298;
        rPosY = -1183.5734;
        rPosZ = 25.3454;
    } else if (rFactionID == 8) {
        rPosX = 2499.8467;
        rPosY = -1684.6450;
        rPosZ = 13.4315;
    } else if (rFactionID == 9) {
        rPosX = 2000.3827;
        rPosY = -1119.9652;
        rPosZ = 26.7813;
    } else if (rFactionID == 10) {
        rPosX = 2755.9014;
        rPosY = -1962.6006;
        rPosZ = 13.5473;
    }
    return 1;
}

stock CanInitiateRobbery(playerid) {
    new rfactionID = Faction:GetPlayerFID(playerid);
    if (rfactionID == -1) return 0; // not a faction member
    if (!IsArrayContainNumber(AllowedFaction, rfactionID, sizeof AllowedFaction)) return 2; // not allowed faction
    if (!Faction:IsPlayerSigned(playerid)) return 3; // not signed in faction member
    new bankID = GetBankLocation(playerid);
    if (bankID == -1) return 4; // not near any bank
    if (GetMedicalStaffOnline() < MedicRequired) return 5; // not enough medic available
    new robbers = 0, civil = 0, law = 0;
    foreach(new i:Player) {
        if (IsArrayContainNumber(AllowedLawFaction, Faction:GetPlayerFID(i), sizeof AllowedLawFaction) && Faction:IsPlayerSigned(i)) law++;
        if (!IsPlayerInRangeOfPoint(i, BankLocations[bankID][robRange] / 3, BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2])) continue;
        if (Faction:GetPlayerFID(i) == rfactionID && Faction:IsPlayerSigned(i)) robbers++;
        if (!Faction:IsPlayerSigned(i)) civil++;
    }
    if (robbers < RobbersRequired) return 6; // not enough robbers
    if (civil < CivilRequired && CivilRequired != 0) return 7; // not enough civil
    if (law < LawRequired) return 8; // not enough law

    if ((gettime() - Database:GetInt("0", "id", BankRobColumn, SettingsTable)) < 6 * 60 * 60) return 9;
    // SendClientMessageToAll(-1, sprintf("robbers = %d, civil = %d, law = %d", robbers, civil, law));
    // InitiateRobbery(playerid, bankID, rfactionID);
    return 1; // yes can initaite roberry
}

// Robbery Runtime Data
new bool:IsRobberyActive = false;
new bool:lootStarted = false;
new robberybankID = -1;
new robberyIniatedBy = -1;
new RobberyrfactionID = -1;
// new RobberyCivilionAvailable = 0;
// new RobberyRobbersAvailable = 0;
// new RobberyLawAvailable = 0;
new RobberyUpdatePlayerDataTimer = -1;
new STREAMER_TAG_CP:RobberyFirstLockerCP = -1;
new STREAMER_TAG_CP:RobberySecondLockerCP = -1;
new STREAMER_TAG_AREA:RobberyArea = -1;
new bool:IsFirstLockerTimerActive = false;
new bool:IsSecondLockerTimerActive = false;
new RobberyCheckFirstLockerTimer = -1;
new RobberyCheckSecondLockerTimer = -1;
new RobberyFirstLockerTime = -1;
new RobberySecondLockerTime = -1;
new FirstBagIsTakenBy = -1;
new SecondBagIsTakenBy = -1;
new FirstBagObjectID = -1;
new SecondBagObjectID = -1;
new STREAMER_TAG_CP:RobberyHqCP = -1;
new HostageKeepingTimer = -1;

forward UpdateRobberyPlayers();
public UpdateRobberyPlayers() {
    if (!IsRobberyActive) {
        KillTimer(RobberyUpdatePlayerDataTimer);
        RobberyUpdatePlayerDataTimer = -1;
        return 1;
    }
    new robbers = 0, civil = 0, law = 0, lawAtBank = 0, bankID = robberybankID, rfactionID = RobberyrfactionID;
    foreach(new i:Player) {
        if (IsArrayContainNumber(AllowedLawFaction, Faction:GetPlayerFID(i), sizeof AllowedLawFaction) && Faction:IsPlayerSigned(i) && !IsPlayerFreezedForDeath(i)) law++;
        if (!IsPlayerInRangeOfPoint(i, BankLocations[bankID][robRange], BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2]) && !IsPlayerFreezedForDeath(i)) continue;
        if (IsArrayContainNumber(AllowedLawFaction, Faction:GetPlayerFID(i), sizeof AllowedLawFaction) && Faction:IsPlayerSigned(i) && !IsPlayerFreezedForDeath(i)) lawAtBank++;
        if (Faction:GetPlayerFID(i) == rfactionID && Faction:IsPlayerSigned(i) && !IsPlayerFreezedForDeath(i)) robbers++;
        if (!Faction:IsPlayerSigned(i) && !IsPlayerFreezedForDeath(i)) civil++;
    }
    if (lawAtBank >= lawAtBankRequired && !lootStarted && FirstBagIsTakenBy == -1 && SecondBagIsTakenBy == -1) {
        lootStarted = true;
        RobberyFirstLockerCP = CreateDynamicCP(BankLocations[bankID][robBankLockerFirst][0], BankLocations[bankID][robBankLockerFirst][1], BankLocations[bankID][robBankLockerFirst][2], 1.0, 0, 0, -1, 20.0, -1, 0);
        RobberySecondLockerCP = CreateDynamicCP(BankLocations[bankID][robBankLockerSecond][0], BankLocations[bankID][robBankLockerSecond][1], BankLocations[bankID][robBankLockerSecond][2], 1.0, 0, 0, -1, 20.0, -1, 0);
        SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FF00FF}Send two members to collect money from the locker room and keep them safe while they are collecting money.");
    }

    if (FirstBagIsTakenBy == -1 && SecondBagIsTakenBy == -1) {
        if (civil == 0 && CivilRequired != 0) FailRobbery(1); // loss civilion
        else if (robbers == 0) FailRobbery(2); // all robbers killed or leaved robbery scene
    }
    // RobberyCivilionAvailable = civil;
    // RobberyRobbersAvailable = robbers;
    // RobberyLawAvailable = law;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if (!IsRobberyActive) return 1;
    if (FirstBagIsTakenBy == playerid || SecondBagIsTakenBy == playerid) FailRobbery(3); // money bag player get killed
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!IsRobberyActive) return 1;
    if (robberyIniatedBy == playerid) FailRobbery(4); // leader disconnected
    return 1;
}

stock SendMessageToRobbers(const msg[]) {
    if (!IsRobberyActive) return 1;
    foreach(new i:Player) {
        if (Faction:GetPlayerFID(i) == RobberyrfactionID && Faction:IsPlayerSigned(i)) SendClientMessage(i, -1, msg);
    }
    return 1;
}

stock SendMessageToLaw(const msg[]) {
    if (!IsRobberyActive) return 1;
    foreach(new i:Player) {
        if (IsArrayContainNumber(AllowedLawFaction, Faction:GetPlayerFID(i), sizeof AllowedLawFaction) && Faction:IsPlayerSigned(i)) SendClientMessage(i, -1, msg);
    }
    return 1;
}
stock SendMessageToCivil(const msg[]) {
    if (!IsRobberyActive) return 1;
    new bankID = robberybankID;
    foreach(new i:Player) {
        if (!IsPlayerInRangeOfPoint(i, BankLocations[bankID][robRange], BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2])) continue;
        if (!Faction:IsPlayerSigned(i)) SendClientMessage(i, -1, msg);
    }
    return 1;
}

stock InitiateRobbery(playerid, bankID, rfactionID) {
    IsRobberyActive = true;
    lootStarted = false;
    robberyIniatedBy = playerid;
    robberybankID = bankID;
    RobberyrfactionID = rfactionID;
    RobberyArea = STREAMER_TAG_AREA:CreateDynamicCircle(BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robRange], 0, 0, -1, 0);
    RobberyFirstLockerTime = RobMin * 60;
    RobberySecondLockerTime = RobMin * 60;
    FirstBagIsTakenBy = -1;
    SecondBagIsTakenBy = -1;
    FirstBagObjectID = -1;
    SecondBagObjectID = -1;
    UpdateRobberyPlayers();
    RobberyUpdatePlayerDataTimer = SetTimer("UpdateRobberyPlayers", 5000, true);
    HostageKeepingTimer = SetTimer("UpdateHostageState", 1000, true);
    SendClientMessageToAll(-1, sprintf("{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}A robbery in progress has be reported at %s, %s. ", BankLocations[bankID][robBankName], BankLocations[bankID][robBankLocation]));
    SendClientMessageToAll(-1, sprintf("{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}The robbers are identified as members of the %s.", Faction:GetName(RobberyrfactionID)));
    SendClientMessageToAll(-1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}all units, please respond to crime scene immediately.");
    foreach(new i:Player) {
        if (Faction:GetPlayerFID(i) == 6) SetPreciseTimer("SendMedicGuideTo", 10000, false, "d", i);
        if (IsArrayContainNumber(AllowedLawFaction, Faction:GetPlayerFID(i), sizeof AllowedLawFaction)) SetPreciseTimer("SendLawGuideTo", 10000, false, "d", i);
        if (!IsPlayerInRangeOfPoint(i, BankLocations[bankID][robRange], BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2])) continue;
        if (Faction:GetPlayerFID(i) == rfactionID && Faction:IsPlayerSigned(i)) SetPreciseTimer("SendRobGuideTo", 10000, false, "d", i);
        if (!Faction:IsPlayerSigned(i)) SetPreciseTimer("SendCivilGuideTo", 10000, false, "d", i);
    }
    // SendClientMessageToAll(-1, sprintf("robbery Iniated By player: %s", GetPlayerNameEx(robberyIniatedBy)));
    // SendClientMessageToAll(-1, sprintf("robbery Iniated By Faction: %s", Faction:GetName(RobberyrfactionID)));
    // SendClientMessageToAll(-1, sprintf("robbery Iniated at Bank: %s", BankLocations[robberybankID][robBankName]));
    // SendClientMessageToAll(-1, sprintf("Robebrs: %d, Civilions: %d, Law: %d", RobberyRobbersAvailable, RobberyCivilionAvailable, RobberyLawAvailable));
    return 1;
}

forward UpdateHostageState();
public UpdateHostageState() {
    if (!IsRobberyActive) {
        KillTimer(HostageKeepingTimer);
        HostageKeepingTimer = -1;
        return 1;
    }
    new bankID = robberybankID;
    foreach(new i:Player) {
        if (!IsPlayerInRangeOfPoint(i, BankLocations[bankID][robRange], BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2])) continue;
        new fID = Faction:GetPlayerFID(i);
        if (Faction:IsPlayerSigned(i)) {
            if (fID == RobberyrfactionID) {
                new targetID = GetPlayerTargetPlayer(i);
                if (IsPlayerConnected(targetID)) {
                    if (!Faction:IsPlayerSigned(targetID) && !IsPlayerFreezed(targetID)) {
                        freezeEx(targetID, HostageFreezeTime);
                        ApplyAnimation(targetID, "ped", "cower", 4.1, 1, 0, 0, 1, 0, 1);
                        SendClientMessage(targetID, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}stay down and do what they ask you to do.");
                    }
                }
            }
        }
    }
    return 1;
}

hook OnPlayerUnfreezed(playerid) {
    if (!IsRobberyActive) return 1;
    new bankID = robberybankID;
    if (!IsPlayerInRangeOfPoint(playerid, BankLocations[bankID][robRange], BankLocations[bankID][robBankPos][0], BankLocations[bankID][robBankPos][1], BankLocations[bankID][robBankPos][2])) return 1;
    Anim:Stop(playerid);
    return 1;
}

forward SendRobGuideTo(playerid);
public SendRobGuideTo(playerid) {
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have attempt to rob the bank, please follow this guidelines to complete the robbery.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have to keep the citizens as hostages until you get all the money from the locker room.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}If you kill any hostage, the amount of robbery will be reduced.");
    // SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Send two members to collect money from the locker room and keep them safe while they are collecting money.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Fight the law and do not let them enter the bank.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}To hold a citizen as hostage, please target them with your gun continuously.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}If you lose the hostages then the robbery will fail.");
    return 1;
}

forward SendCivilGuideTo(playerid);
public SendCivilGuideTo(playerid) {
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Please be patient, the escort team is on its way to save you.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Please do as the robbers tell you to do, so that you can keep yourself alive.");
    return 1;
}

forward SendLawGuideTo(playerid);
public SendLawGuideTo(playerid) {
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Your primary task is to rescue the citizens, who are taken as hostage by the robbers.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Send all the secured hostage to the nearest hospital in an ambulance for checkup.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}After you secure the hostages, arrest all the robbers and send them to jail..");
    return 1;
}

forward SendMedicGuideTo(playerid);
public SendMedicGuideTo(playerid) {
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Please respond immediately to the crime scene with full medical help..");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Rescuing our front line officers and hostage at the crime scene is your primary task.");
    SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {4286f4}[SAPD]: {FFFFFF}Take them to the hospital if the situation is serious.");
    return 1;
}

stock FailRobbery(reason = 0) {
    if (!IsRobberyActive) return 1;
    KillTimer(HostageKeepingTimer);
    HostageKeepingTimer = -1;
    if (IsValidDynamicCP(RobberyHqCP)) DestroyDynamicCP(RobberyHqCP);
    RobberyHqCP = -1;
    if (IsValidDynamicCP(RobberyFirstLockerCP)) DestroyDynamicCP(RobberyFirstLockerCP);
    RobberyFirstLockerCP = -1;
    if (IsValidDynamicCP(RobberySecondLockerCP)) DestroyDynamicCP(RobberySecondLockerCP);
    RobberySecondLockerCP = -1;
    if (IsValidDynamicArea(STREAMER_TAG_AREA:RobberyArea)) DestroyDynamicArea(STREAMER_TAG_AREA:RobberyArea);
    RobberyArea = -1;
    DestroyObject(FirstBagObjectID);
    DestroyObject(SecondBagObjectID);
    FirstBagObjectID = -1;
    SecondBagObjectID = -1;
    SendClientMessageToAll(-1, sprintf("{FFFF00}[Bank Robbery]: {FFFFFF}%s failed to loot %s", Faction:GetName(RobberyrfactionID), BankLocations[robberybankID][robBankName]));
    if (reason == 1) {
        SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}you failed because you do not have any hostages");
    } else if (reason == 2) {
        SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}you failed because all members of your group get killed");
    } else if (reason == 3) {
        SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}you failed because the player who has money bag get killed");
    } else if (reason == 4) {
        SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}the leader, who started robbery get disconnected");
    }
    SendClientMessageToAll(-1, "{FFFF00}[Bank Robbery]: {FFFFFF}SAPD has submitted their report to CBI for further investigation");
    IsRobberyActive = false;
    return 1;
}

stock CompleteRobbery(reason = 0) {
    if (!IsRobberyActive) return 1;
    if (reason == 1) {
        // SendClientMessageToAll(-1, sprintf("robbery Iniated By player: %s", GetPlayerNameEx(robberyIniatedBy)));
        SendClientMessageToAll(-1, sprintf("{FFFF00}[Bank Robbery]: {FFFFFF}%s successfully looted $%s from the %s", Faction:GetName(RobberyrfactionID), FormatCurrency(cashReward), BankLocations[robberybankID][robBankName]));
        SendClientMessageToAll(-1, "{FFFF00}[Bank Robbery]: {FFFFFF}SAPD has submitted their report to CBI for further investigation");
    }
    vault:PlayerVault(robberyIniatedBy, cashReward, "earned from bank robbery", Vault_ID_Government, -cashReward, sprintf("%s earned from bank robbery", GetPlayerNameEx(robberyIniatedBy)));
    SendMessageToRobbers(sprintf("{FFFF00}[Bank Robbery]: {FFFFFF}%s has $999,999 for this robbery", GetPlayerNameEx(robberyIniatedBy)));
    IsRobberyActive = false;
    lootStarted = false;
    KillTimer(HostageKeepingTimer);
    HostageKeepingTimer = -1;
    if (IsValidDynamicCP(RobberyHqCP)) DestroyDynamicCP(RobberyHqCP);
    RobberyHqCP = -1;
    if (IsValidDynamicCP(RobberyFirstLockerCP)) DestroyDynamicCP(RobberyFirstLockerCP);
    RobberyFirstLockerCP = -1;
    if (IsValidDynamicCP(RobberySecondLockerCP)) DestroyDynamicCP(RobberySecondLockerCP);
    RobberySecondLockerCP = -1;
    if (IsValidDynamicArea(STREAMER_TAG_AREA:RobberyArea)) DestroyDynamicArea(STREAMER_TAG_AREA:RobberyArea);
    RobberyArea = -1;
    Database:UpdateInt(gettime(), "0", "id", BankRobColumn, SettingsTable);
    return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid) {
    if (!IsRobberyActive) return 1;
    if (areaid == RobberyArea) {
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have entered the robbery zone, Please be careful");
        return ~1;
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, STREAMER_TAG_AREA:areaid) {
    if (!IsRobberyActive) return 1;
    if (areaid == RobberyArea) {
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have leaved the robbery zone");
        return ~1;
    }
    return 1;
}

forward UpdateFirstLockerTime(playerid);
public UpdateFirstLockerTime(playerid) {
    if (!IsRobberyActive) return 1;
    if (RobberyFirstLockerTime > 0) RobberyFirstLockerTime--;
    if (RobberyFirstLockerTime < 1) {
        if (SecondBagIsTakenBy == playerid) return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You already have a bag, send another member to pick up this one.");
        KillTimer(RobberyCheckFirstLockerTimer);
        RobberyCheckFirstLockerTimer = -1;
        if (IsValidDynamicCP(RobberyFirstLockerCP)) DestroyDynamicCP(RobberyFirstLockerCP);
        RobberyFirstLockerCP = -1;
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}All the money is collected in your bag");
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please carry this bag safely to your headquarters to complete the robbery");
        FirstBagIsTakenBy = playerid;
        FirstBagObjectID = CreateObject(1550, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachObjectToPlayer(FirstBagObjectID, playerid, -0.027000, -0.251999, 0.200000, 1.000000, 1.000000, 1.000000);
        if (FirstBagIsTakenBy != -1 && SecondBagIsTakenBy != -1) CompleteBankLoot();
        return 1;
    }
    GameTextForPlayer(playerid, sprintf("Time Left: %02d:%02d", RobberyFirstLockerTime / (60) % 60, RobberyFirstLockerTime % 60), 1000, 3);
    return 1;
}

forward UpdateSecondLockerTime(playerid);
public UpdateSecondLockerTime(playerid) {
    if (!IsRobberyActive) return 1;
    if (RobberySecondLockerTime > 0) RobberySecondLockerTime--;
    if (RobberySecondLockerTime < 1) {
        if (FirstBagIsTakenBy == playerid) return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You already have a bag, send another member to pick up this one.");
        KillTimer(RobberyCheckSecondLockerTimer);
        RobberyCheckSecondLockerTimer = -1;
        if (IsValidDynamicCP(RobberySecondLockerCP)) DestroyDynamicCP(RobberySecondLockerCP);
        RobberySecondLockerCP = -1;
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}All the money is collected in your bag");
        SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please carry this bag safely to your headquarters to complete the robbery");
        SecondBagIsTakenBy = playerid;
        SecondBagObjectID = CreateObject(1550, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachObjectToPlayer(SecondBagObjectID, playerid, -0.027000, -0.251999, 0.200000, 1.000000, 1.000000, 1.000000);
        if (FirstBagIsTakenBy != -1 && SecondBagIsTakenBy != -1) CompleteBankLoot();
        return 1;
    }
    GameTextForPlayer(playerid, sprintf("Time Left: %02d:%02d", RobberySecondLockerTime / (60) % 60, RobberySecondLockerTime % 60), 1000, 3);
    return 1;
}

stock CompleteBankLoot() {
    if (!IsRobberyActive) return 1;
    KillTimer(RobberyUpdatePlayerDataTimer);
    RobberyUpdatePlayerDataTimer = -1;
    KillTimer(HostageKeepingTimer);
    HostageKeepingTimer = -1;
    lootStarted = false;
    new Float:rLPos[3];
    GetMafiaHqLocation(RobberyrfactionID, rLPos[0], rLPos[1], rLPos[2]);
    RobberyHqCP = STREAMER_TAG_CP:CreateDynamicCP(rLPos[0], rLPos[1], rLPos[2], 1.0, 0, 0, -1, 100, STREAMER_TAG_AREA:  - 1, 0);
    SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}All the money has been collected, now find the way to your headquarters to complete the robbery");
    SendMessageToRobbers("{FFFF00}[Bank Robbery]: {FFFFFF}Ensure that members who have money do not get murdered or arrested.");
    SendMessageToLaw("{FFFF00}[Bank Robbery]: {FFFFFF}The robbers have collected all the money, now stop them from running away");
    SendMessageToCivil("{FFFF00}[Bank Robbery]: {FFFFFF}The robbers attention is diverted to escape, please find a safe way for the escort team");
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (!IsRobberyActive) return 1;
    if (checkpointid == RobberyFirstLockerCP) {
        if (Faction:GetPlayerFID(playerid) == RobberyrfactionID && Faction:IsPlayerSigned(playerid)) {
            if (!IsFirstLockerTimerActive) {
                IsFirstLockerTimerActive = true;
                RobberyCheckFirstLockerTimer = SetTimerEx("UpdateFirstLockerTime", 1000, true, "d", playerid);
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have started collecting money from the lockers.");
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please stop here and do not proceed until you have collected all the money in your bag.");
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1); // Place Bomb
                Anim:SetState(playerid, true);
            }
        }
        return ~1;
    } else if (checkpointid == RobberySecondLockerCP) {
        if (Faction:GetPlayerFID(playerid) == RobberyrfactionID && Faction:IsPlayerSigned(playerid)) {
            if (!IsSecondLockerTimerActive) {
                IsSecondLockerTimerActive = true;
                RobberyCheckSecondLockerTimer = SetTimerEx("UpdateSecondLockerTime", 1000, true, "d", playerid);
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}You have started collecting money from the lockers.");
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please stop here and do not proceed until you have collected all the money in your bag.");
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 0, 0, 0, 0, 1); // Place Bomb
                Anim:SetState(playerid, true);
            }
        }
        return ~1;
    } else if (checkpointid == RobberyHqCP) {
        if (FirstBagIsTakenBy == -1 || SecondBagIsTakenBy == -1) return 1;
        if (playerid == FirstBagIsTakenBy) {
            DestroyObject(FirstBagObjectID);
            FirstBagObjectID = -1;
            SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Congratulations, you have successfully brought money bag to your headquarter.");
            FirstBagIsTakenBy = -2;
        } else if (playerid == SecondBagIsTakenBy) {
            DestroyObject(SecondBagObjectID);
            SecondBagObjectID = -1;
            SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Congratulations, you have successfully brought money bag to your headquarter.");
            SecondBagIsTakenBy = -2;
        }
        if (FirstBagIsTakenBy == -2 && SecondBagIsTakenBy == -2) CompleteRobbery(1);
        return ~1;
    }
    return 1;
}

hook OnPlayerLeaveDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (checkpointid == RobberyFirstLockerCP) {
        if (Faction:GetPlayerFID(playerid) == RobberyrfactionID && Faction:IsPlayerSigned(playerid)) {
            if (IsFirstLockerTimerActive) {
                IsFirstLockerTimerActive = false;
                KillTimer(RobberyCheckFirstLockerTimer);
                RobberyCheckFirstLockerTimer = -1;
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please go back to the checkpoint to collect money");
            }
        }
        return ~1;
    } else if (checkpointid == RobberySecondLockerCP) {
        if (Faction:GetPlayerFID(playerid) == RobberyrfactionID && Faction:IsPlayerSigned(playerid)) {
            if (IsSecondLockerTimerActive) {
                IsSecondLockerTimerActive = false;
                KillTimer(RobberyCheckSecondLockerTimer);
                RobberyCheckSecondLockerTimer = -1;
                SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}Please go back to the checkpoint to collect money");
            }
        }
        return ~1;
    }
    return 1;
}

hook OnGameModeInit() {
    IsRobberyActive = false;
    Database:AddTable(SettingsTable, "id", "int", "", true);
    // Database:InitTable(SettingsTable, "id", "0");
    Database:AddColumn(SettingsTable, BankRobColumn, "int", "0");
    return 1;
}

stock startBankRob(playerid) {
    new code = CanInitiateRobbery(playerid);
    if (code == 1) {
        new bankID = GetBankLocation(playerid);
        if (bankID == -1) return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}you should be inside a bank to rob");
        InitiateRobbery(playerid, bankID, Faction:GetPlayerFID(playerid));
        return 1;
    } else if (code == 0) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}join a faction to start robbery");
    } else if (code == 2) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}your faction is not allowed to rob bank");
    } else if (code == 3) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}you should sign in first to rob bank");
    } else if (code == 4) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}you should be near to a bank");
    } else if (code == 5) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}not enough medical officers online to start robbery");
    } else if (code == 6) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}not enough robbers in bank to start robbery");
    } else if (code == 7) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}not enough civilians in bank to start robbery");
    } else if (code == 8) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}not enough law officers available to start robbery");
    } else if (code == 9) {
        return SendClientMessage(playerid, -1, "{FFFF00}[Bank Robbery]: {FFFFFF}wait for few hours to initiate robbery again");
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new bankID = GetBankLocation(playerid);
    if (bankID != -1 && Faction:IsPlayerSigned(playerid) && !IsRobberyActive) UCP:AddCommand(playerid, "Start Bank Robbery", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page != 0 || !response) return 1;
    if (!strcmp(inputtext, "Start Bank Robbery")) {
        startBankRob(playerid);
        return ~1;
    }
    return 1;
}