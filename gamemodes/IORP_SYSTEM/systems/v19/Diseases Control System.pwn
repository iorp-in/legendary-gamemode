#define MaxDisease 20

enum Disease:DataEnum {
    Disease:OperationTime,
    Disease:Title[100]
}
enum Disease:PlayerDataEnum {
    Disease:level,
    Disease:lastsymtomtime
}

new Disease:Data[MaxDisease][Disease:DataEnum];
new Disease:PlayerData[MAX_PLAYERS][Disease:PlayerDataEnum];
new bool:Disease:PlayerSymtom[MAX_PLAYERS];
new bool:Disease:PlayerState[MAX_PLAYERS][MaxDisease];
new Iterator:diseases < MaxDisease > ;

hook OnPlayerConnect(playerid) {
    Disease:PlayerSymtom[playerid] = false;
    Disease:PlayerData[playerid][Disease:level] = 0;
    Disease:PlayerData[playerid][Disease:lastsymtomtime] = 0;
    return 1;
}

stock Disease:GetHealthLevel(playerid) {
    return Disease:PlayerData[playerid][Disease:level];
}

stock Disease:IsPlayerShowingSymtom(playerid) {
    return Disease:PlayerSymtom[playerid];
}

stock Disease:GetLastSymtomTime(playerid) {
    return Disease:PlayerData[playerid][Disease:lastsymtomtime];
}

stock Disease:SetHealthLevel(playerid, level) {
    Disease:PlayerData[playerid][Disease:level] = level;
    return 1;
}

stock Disease:IsValid(diseaseid) {
    if (Iter_Contains(diseases, diseaseid)) return 1;
    return 0;
}

/* 
    name - disesae name
    operationtime - operation time should be in seconds
*/
stock Disease:Add(const name[], operationtime) {
    new diseaseid = Iter_Free(diseases);
    if (diseaseid == INVALID_ITERATOR_SLOT) { print("Error: max disease overflow"); return -1; }
    format(Disease:Data[diseaseid][Disease:Title], 100, "%s", name);
    Disease:Data[diseaseid][Disease:OperationTime] = operationtime;
    Iter_Add(diseases, diseaseid);
    return diseaseid;
}

stock Disease:GetName(diseaseid) {
    new string[100];
    format(string, 100, "%s", Disease:Data[diseaseid][Disease:Title]);
    return string;
}

stock Disease:GetOperationTime(diseaseid) {
    return Disease:Data[diseaseid][Disease:OperationTime];
}

stock Disease:SetPlayerState(playerid, diseaseid, bool:status = false) {
    if (!Disease:IsValid(diseaseid)) return 1;
    Disease:PlayerState[playerid][diseaseid] = status;
    return 1;
}

stock Disease:GetPlayerState(playerid, diseaseid) {
    return Disease:PlayerState[playerid][diseaseid];
}

stock Disease:GetTotalActive(playerid) {
    new count = 0;
    foreach(new diseaseid:diseases) {
        if (Disease:PlayerState[playerid][diseaseid]) count++;
    }
    return count;
}

hook OnGameModeInit() {
    SetTimer("OnDiseaseStatusCheck", 5 * 60 * 1000, true);
    return 1;
}

forward OnDiseaseStatusCheck();
public OnDiseaseStatusCheck() {
    foreach(new playerid:Player) {
        if (WantedDatabase:IsInJail(playerid)) continue;
        if (Disease:GetTotalActive(playerid) == 0) {
            Disease:SetHealthLevel(playerid, 0);
            continue;
        }
        if (Disease:PlayerSymtom[playerid]) continue;
        if (Disease:GetHealthLevel(playerid) == 0) {
            Disease:SetHealthLevel(playerid, 1);
            Disease:StartSymptoms(playerid, 60);
            StartScreenTimer(playerid, 60);
        } else if (Disease:GetHealthLevel(playerid) == 1 && (gettime() - Disease:GetLastSymtomTime(playerid)) > 10 * 60) {
            Disease:SetHealthLevel(playerid, 2);
            new seconds = Random(120, 300);
            StartScreenTimer(playerid, seconds);
            Disease:StartSymptoms(playerid, seconds);
        } else if (Disease:GetHealthLevel(playerid) > 2 && (gettime() - Disease:GetLastSymtomTime(playerid)) > 20 * 60) {
            Disease:SetHealthLevel(playerid, 3);
            new seconds = Random(300, 900);
            StartScreenTimer(playerid, seconds);
            Disease:StartSymptoms(playerid, seconds);
        }
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (Disease:PlayerSymtom[playerid]) ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

forward Disease:StartSymptoms(playerid, timeinseconds);
public Disease:StartSymptoms(playerid, timeinseconds) {
    freeze(playerid);
    if (IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
    ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 1, 0, 0, 0, 0, 1);
    Disease:PlayerSymtom[playerid] = true;
    SetPreciseTimer("DiseaseStopSymptoms", timeinseconds * 1000, false, "d", playerid);
    return 1;
}

forward DiseaseStopSymptoms(playerid);
public DiseaseStopSymptoms(playerid) {
    Disease:PlayerSymtom[playerid] = false;
    Anim:Stop(playerid);
    unfreeze(playerid);
    Disease:PlayerData[playerid][Disease:lastsymtomtime] = gettime();
    return 1;
}