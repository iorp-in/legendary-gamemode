#define SAMD_ID 6

enum deathEnum {
    bool:freezedForDeath,
    bool:spawnDeathMode
}
new bool:PlayerDeathData[MAX_PLAYERS][deathEnum];

stock IsPlayerFreezedForDeath(playerid) {
    if (!IsPlayerConnected(playerid)) return true;
    return PlayerDeathData[playerid][freezedForDeath];
}

stock SetPlayerFreezeState(playerid, bool:nState = false) {
    PlayerDeathData[playerid][freezedForDeath] = nState;
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "DeathState", "boolean", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    PlayerDeathData[playerid][freezedForDeath] = false;
    PlayerDeathData[playerid][spawnDeathMode] = Database:GetBool(GetPlayerNameEx(playerid), "username", "DeathState");
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if (PlayerDeathData[playerid][spawnDeathMode]) DeathAdvisory(playerid);
    return 1;
}

stock DeathAdvisory(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{8B0000} --------------------- Health Advisory --------------------");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{8B0000} You are now laying death. You are bleeding to death. Remember that the medics can revive you. use /medic");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{8B0000} Remember that the medics can revive you. use /medic or /acceptdeath, if no medics are available.");
    PlayerDeathData[playerid][freezedForDeath] = true;
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "DeathState");
    return 1;
}

hook OnPlayerDeathSpawn(playerid) {
    if (Event:IsInEvent(playerid)) return 1;
    DeathAdvisory(playerid);
    return 1;
}

forward AutoDeath(playerid);
public AutoDeath(playerid) {
    if (!IsPlayerFreezedForDeath(playerid)) return 0;
    PlayerDeathCorp(playerid);
    PlayerDeathData[playerid][freezedForDeath] = false;
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "DeathState");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{8B0000} you can't hold more...");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{8B0000} your eyes are closing and you are falling into death.");
    new id = GetClosestHospital(playerid);
    ClosestHospital[playerid] = id;
    SetPlayerPosEx(playerid, HospitalData[id][coordX], HospitalData[id][coordY], HospitalData[id][coordZ]);
    SetPlayerFacingAngle(playerid, HospitalData[id][faceA]);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (IsPlayerFreezedForDeath(playerid)) {
        if (GetPlayerAnimationIndex(playerid)) {
            new animlib[32];
            new animname[32];
            GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, 32, animname, 32);
            if (strcmp(animname, "KO_SKID_FRONT")) ApplyAnimation(playerid, "PED", "KO_SKID_FRONT", 4.1, 0, 0, 0, 1, 0, 1);
        }
    }
    return 1;
}

cmd:acceptdeath(playerid, const params[]) {
    if (GetMedicalStaffOnline() > 0) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{8B0000} currently medic is available, please use /medic");
    new amount = RandomEx(500, 1000);
    GivePlayerCash(playerid, -amount, "medical treatment expense");
    vault:addcash(Vault_ID_Government, amount, Vault_Transaction_Cash_To_Vault, sprintf("%s medical treatment expense", GetPlayerNameEx(playerid)));
    return AutoDeath(playerid);
}

cmd:medic(playerid, const params[]) {
    if (!IsPlayerFreezedForDeath(playerid)) return 0;
    if (GetMedicalStaffOnline() < 1) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{8B0000} currently no medic is available, please use /acceptdeath");
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{8B0000} Emergency medical services is called, they will be here soon. Please stay alive");
    new Float:PlayerPosition[3], pZone[100], pCity[100];
    GetPlayerPos(playerid, PlayerPosition[0], PlayerPosition[1], PlayerPosition[2]);
    format(pZone, sizeof pZone, "%s", GetZoneName(PlayerPosition[0], PlayerPosition[1], PlayerPosition[2]));
    format(pCity, sizeof pCity, "%s", GetCityName(PlayerPosition[0], PlayerPosition[1], PlayerPosition[2]));
    foreach(new i:Player) {
        if (Faction:GetPlayerFID(i) == SAMD_ID && Faction:IsPlayerSigned(i)) {
            SendClientMessage(i, -1, sprintf("{4286f4}[San Andreas Medic Department]:{8B0000} %s required medic support immediately", GetPlayerNameEx(playerid)));
            SendClientMessage(i, -1, sprintf("{4286f4}[San Andreas Medic Department]:{8B0000} Patient Location: %s, %s", pZone, pCity));
        }
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    if (IsPlayerFreezedForDeath(playerid)) UCP:AddCommand(playerid, "Accept Death");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Accept Death", inputtext)) { callcmd::medic(playerid, ""); return ~1; }
    return 1;
}

/* Medical Faction Actions */
stock GetMedicalStaffOnline() {
    new count = 0;
    foreach(new playerid:Player) {
        if (Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) count++;
    }
    return count;
}

QuickActions:OnInit(playerid, patientid, page) {
    if (page != 0) return 1;
    if (
        Faction:GetPlayerFID(playerid) == SAMD_ID &&
        Faction:IsPlayerSigned(playerid) &&
        (IsPlayerFreezedForDeath(patientid) || Disease:IsPlayerShowingSymtom(patientid))
    ) QuickActions:AddCommand(playerid, "Give CPR");
    if (
        GetPlayerHealthEx(patientid) < 40 &&
        GetPlayerScore(patientid) > 10 &&
        !IsPlayerPaused(patientid) &&
        GetPlayerRPMode(playerid) &&
        GetPlayerRPMode(patientid)
    ) QuickActions:AddCommand(playerid, "Rob him/her");
    return 1;
}

hook QuickActionsOnResponse(playerid, patientid, page, response, listitem, const inputtext[]) {
    if (page != 0 || !response) return 1;
    if (IsStringSame("Rob him/her", inputtext)) {
        new tMoney = GetPlayerCash(patientid);
        GivePlayerCash(playerid, tMoney, sprintf("robbed %s", GetPlayerNameEx(patientid)));
        GivePlayerCash(patientid, -tMoney, sprintf("robbed by %s", GetPlayerNameEx(playerid)));
        GameTextForPlayer(patientid, "you are being ~r~robbed", 2000, 3);
        WantedDatabase:GiveWantedLevel(playerid, sprintf("robbed %s", GetPlayerNameEx(patientid)), 1, false);
        SendClientMessage(patientid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}%s robbed you, please call emercency services as soon possible. I have already reported him for this crime.", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}I have reported your crime for robbing %s", GetPlayerNameEx(patientid)));
        return ~1;
    }
    if (IsStringSame("Give CPR", inputtext)) {
        DoctorCashCprInput(playerid, patientid);
        return ~1;
    }
    return 1;
}

stock DoctorCashCprInput(doctorid, patientid) {
    return FlexPlayerDialog(
        doctorid, "DoctorCprCash", DIALOG_STYLE_INPUT, "Ask for fee",
        "Enter your fee for patient, it will be charged for cpr\nLimit: $0 to $6,000",
        "Revive", "Cancel", patientid
    );
}

FlexDialog:DoctorCprCash(doctorid, response, listitem, const inputtext[], patientid, const payload[]) {
    if (!response) return 1;
    new fee = 0;
    if (sscanf(inputtext, "d", fee) || fee < 0 || fee > 6000) return DoctorCashCprInput(doctorid, patientid);
    if (fee == 0) return StartCPR(doctorid, patientid);
    new string[1024];
    strcat(string, "----------Doctor Prescription----------\n");
    strcat(string, sprintf("Doctor Name: %s\n", GetPlayerNameEx(doctorid)));
    strcat(string, sprintf("Cause of Death: unknown\n"));
    strcat(string, sprintf("Treatment Fee: %s\n", FormatCurrency(fee)));
    strcat(string, "\ndo you want to accept doctor prescription?\n");
    FlexPlayerDialog(
        patientid, "DoctorCprOffer", DIALOG_STYLE_MSGBOX, "Doctor Prescription",
        string, "Accept", "Reject", doctorid, sprintf("%d", fee)
    );
    return 1;
}

FlexDialog:DoctorCprOffer(patientid, response, listitem, const inputtext[], doctorid, const payload[]) {
    if (!response) {
        AlexaMsg(doctorid, "patient rejected your prescription");
        return 1;
    }
    StartCPR(doctorid, patientid, strval(payload));
    return 1;
}

stock StartCPR(doctorid, patientid, fee = 0) {
    if (!IsPlayerConnected(doctorid) || !IsPlayerConnected(patientid)) return 1;
    if (!IsPlayerFreezedForDeath(patientid) && !Disease:IsPlayerShowingSymtom(patientid)) return AlexaMsg(doctorid, "patient is alright!");
    ApplyAnimation(doctorid, "MEDIC", "CPR", 4.1, 1, 0, 0, 1, 0, 1);
    SendClientMessage(doctorid, -1, "{4286f4}[Alexa]: {FFFFEE}Patient health is critical, please wait");
    SetCameraBehindPlayer(doctorid);
    new seconds = Random(20, 60);
    StartScreenTimer(patientid, seconds);
    StartScreenTimer(doctorid, seconds);
    SetPreciseTimer("CRPFinished", seconds * 1000, false, "ddd", patientid, doctorid, fee);
    return 1;
}

forward CRPFinished(patientid, doctorid, fee);
public CRPFinished(patientid, doctorid, fee) {
    if (!IsPlayerConnected(patientid)) return 1;
    if (IsPlayerConnected(doctorid)) {
        if (fee > 0) {
            if (GetPlayerCash(patientid) < 0) {
                Discord:LogTransaction(sprintf(
                    "** Medic revived a player with minus money **\n\
                    ```\
                    Amount: $%s\n\
                    Doctor: %s ($%s)\n\
                    Patient: %s ($%s)\n\
                    <@&597292999227211777>\n\
                    ```", FormatCurrency(fee),
                    GetPlayerNameEx(doctorid), FormatCurrency(GetPlayerCash(doctorid)),
                    GetPlayerNameEx(patientid), FormatCurrency(GetPlayerCash(patientid))
                ));
            }
            GivePlayerCash(doctorid, fee, sprintf("revive fee from %s", GetPlayerNameEx(patientid)));
            GivePlayerCash(patientid, -fee, sprintf("revive fee paid to %s", GetPlayerNameEx(doctorid)));
        }
        ClearAnimations(doctorid, 1);
        SendClientMessage(doctorid, -1, "{4286f4}[Alexa]: {FFFFEE}Patient health is restored, Thank you doctor");
    }
    DiseaseStopSymptoms(patientid);
    PlayerDeathData[patientid][freezedForDeath] = false;
    Database:UpdateBool(false, GetPlayerNameEx(patientid), "username", "DeathState");
    ApplyAnimation(patientid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
    SendClientMessageEx(patientid, -1, "{4286f4}[Alexa]:{8B0000} --------------------- Health Advisory --------------------");
    SendClientMessageEx(patientid, -1, "{4286f4}[Alexa]:{8B0000} Your life is saved by one of the doctor from san andreas medical department.");
    SendClientMessageEx(patientid, -1, "{4286f4}[Alexa]:{8B0000} Remember, always call san andreas medical department whenever you feel unwell");
    SendClientMessageEx(patientid, -1, "{4286f4}[Alexa]:{8B0000} You can restore your remaining health by taking some fresh food.");
    SendClientMessageEx(patientid, -1, "{4286f4}[Alexa]:{8B0000} --------------------------------------------------------");
    return 1;
}