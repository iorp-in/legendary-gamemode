#define MAX_OPERATIONS 10

new operation:Dialog;
enum { operation:Selection, operation:AskPatientID, operation:Stretcher };

enum operation:sDataEnum {
    operation:name[100],
        operation:timeforopinmins,
        operation:opfees
}
new operation:sData[MAX_OPERATIONS][operation:sDataEnum];
new Iterator:operations < MAX_OPERATIONS > ;

enum operation:PDataEnum {
    bool:operation:isInOperation,
    bool:operation:isDoctor,
    bool:operation:isPatient,
    operation:targetplayer,
    operation:operationid,
    operation:operationtimer
}
new operation:PData[MAX_PLAYERS][operation:PDataEnum];

hook OnGameModeInit() {
    operation:Dialog = Dialog:GetFreeID();
    return 1;
}

stock operation:addnew(const title[], timeinmins, fees) {
    new operation_id = Iter_Free(operations);
    if (operation_id == INVALID_ITERATOR_SLOT) return printf("overflow operations");
    format(operation:sData[operation_id][operation:name], 100, "%s", title);
    operation:sData[operation_id][operation:timeforopinmins] = timeinmins;
    operation:sData[operation_id][operation:opfees] = fees;
    Iter_Add(operations, operation_id);
    return operation_id;
}

stock operation:SetPatientOnOperationDesk(playerid) {
    freeze(playerid);
    SetPlayerPosEx(playerid, 1141.6062, -1332.8318, -6.1448);
    SetPlayerFacingAngle(playerid, 176.7672);
    ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
    return 1;
}

stock operation:SetDoctorInOperationPos(playerid) {
    freeze(playerid);
    SetPlayerPosEx(playerid, 1142.5214, -1332.8101, -7.1221);
    SetPlayerFacingAngle(playerid, 90.4357);
    ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}

stock operation:StartOperation(doctorid, patientid, operationid) {
    operation:SetPatientOnOperationDesk(patientid);
    operation:SetDoctorInOperationPos(doctorid);
    operation:PData[doctorid][operation:isInOperation] = true;
    operation:PData[doctorid][operation:isDoctor] = true;
    operation:PData[doctorid][operation:isPatient] = false;
    operation:PData[doctorid][operation:operationid] = operationid;
    operation:PData[doctorid][operation:targetplayer] = patientid;
    operation:PData[patientid][operation:isInOperation] = true;
    operation:PData[patientid][operation:isDoctor] = false;
    operation:PData[patientid][operation:isPatient] = true;
    operation:PData[patientid][operation:operationid] = operationid;
    operation:PData[patientid][operation:targetplayer] = doctorid;
    new rMin = Random(1, 5);
    StartScreenTimer(doctorid, rMin * 60);
    StartScreenTimer(patientid, rMin * 60);
    operation:PData[doctorid][operation:operationtimer] = SetTimerEx("OnOperationComplete", Random(1, 5) * 60 * 1000, false, "ddd", doctorid, patientid, operationid);
    operation:PData[patientid][operation:operationtimer] = operation:PData[doctorid][operation:operationtimer];
    return 1;
}

stock operation:resetPlayerData(playerid) {
    operation:PData[playerid][operation:isInOperation] = false;
    operation:PData[playerid][operation:isDoctor] = false;
    operation:PData[playerid][operation:isPatient] = false;
    operation:PData[playerid][operation:operationid] = -1;
    operation:PData[playerid][operation:targetplayer] = -1;
    operation:PData[playerid][operation:operationtimer] = -1;
    return 1;
}

stock operation:fail(playerid) {
    new doctorid, patientid;
    if (operation:PData[playerid][operation:isDoctor]) {
        doctorid = playerid;
        patientid = operation:PData[doctorid][operation:targetplayer];
    } else {
        patientid = playerid;
        doctorid = operation:PData[patientid][operation:targetplayer];
    }
    KillTimer(operation:PData[doctorid][operation:operationtimer]);
    CallRemoteFunction("OnOperationFailed", "ddd", doctorid, patientid, operation:PData[doctorid][operation:operationid]);
    return 1;
}

forward OnOperationComplete(doctorid, patientid, operationid);
public OnOperationComplete(doctorid, patientid, operationid) {
    unfreeze(doctorid);
    unfreeze(patientid);
    operation:resetPlayerData(doctorid);
    operation:resetPlayerData(patientid);
    SendClientMessage(doctorid, -1, "[Alexa]: operation successful");
    SendClientMessage(patientid, -1, "[Alexa]: operation successful");
    return 1;
}

forward OnOperationFailed(doctorid, patientid, operationid);
public OnOperationFailed(doctorid, patientid, operationid) {
    unfreeze(doctorid);
    unfreeze(patientid);
    operation:resetPlayerData(doctorid);
    operation:resetPlayerData(patientid);
    SendClientMessage(doctorid, -1, "[Alexa]: operation unsuccessful");
    SendClientMessage(patientid, -1, "[Alexa]: operation unsuccessful");
    return 1;
}

stock operation:ShowMenu(playerid) {
    new string[1024];
    strcat(string, "ID\tFor Disease\tEstimated Time\tFee Required\n");
    foreach(new i:operations) {
        strcat(string, sprintf("%d\t%s\t%d\t$%s\n", i, operation:sData[i][operation:name], operation:sData[i][operation:timeforopinmins], FormatCurrency(operation:sData[i][operation:opfees])));
    }
    ShowPlayerDialogEx(playerid, operation:Dialog, operation:Selection, DIALOG_STYLE_TABLIST_HEADERS, "Operation List", string, "Select", "Cancel");
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != operation:Dialog) return 1;
    if (offsetid == operation:Selection) {
        if (!response) return ~1;
        new operationid = strval(inputtext);
        ShowPlayerDialogEx(playerid, operation:Dialog, operation:AskPatientID, DIALOG_STYLE_INPUT, "who is your patient?", "Enter patient id, make sure your patient is ready for operation", "Inspect", "Back", operationid);
        return ~1;
    }
    if (offsetid == operation:AskPatientID) {
        if (!response) {
            operation:ShowMenu(playerid);
            return ~1;
        }
        new patientid, operationid = extraid;
        if (sscanf(inputtext, "u", patientid)) {
            ShowPlayerDialogEx(playerid, operation:Dialog, operation:AskPatientID, DIALOG_STYLE_INPUT, "who is your patient?", "Enter patient id, make sure your patient is ready for operation", "Inspect", "Back", operationid);
            return ~1;
        }
        if (!IsPlayerConnected(patientid) || patientid == playerid || !IsPlayerInRangeOfPoint(playerid, 30.00, 1143.2677, -1331.6532, -7.1295)) {
            ShowPlayerDialogEx(playerid, operation:Dialog, operation:AskPatientID, DIALOG_STYLE_INPUT, "who is your patient?", "Enter patient id, make sure your patient is ready for operation", "Inspect", "Back", operationid);
            return ~1;
        }
        if (Disease:GetTotalActive(patientid) < 1) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your patient condition does not meet operation criteria, cure him/her with required medicines.");
            return ~1;
        }
        operation:StartOperation(playerid, patientid, operationid);
        return ~1;
    }
    //    if(offsetid == operation:Stretcher) {
    //        if(!response) return ~1;
    //        if(listitem == 0) {
    //            stretcher:spawn(playerid);
    //            return ~1;
    //        }
    //        if(listitem == 1) {
    //            stretcher:leave(playerid);
    //            return ~1;
    //        }
    //        if(listitem == 2) {
    //            stretcher:grab(playerid);
    //            return ~1;
    //        }
    //        if(listitem == 3) {
    //            stretcher:destroy(playerid);
    //            return ~1;
    //        }
    //        return ~1;
    //    }
    return ~1;
}

// stracher system
// 
// #define stretcher_player_index 9
// 
// enum stretcher:PlayerDataEnum {
//     bool:stretcher:isSpawned,
//     bool:stretcher:isAttached,
//     bool:stretcher:isCreated,
//     stretcher:modelID
// }
// new stretcher:PlayerData[MAX_PLAYERS][stretcher:PlayerDataEnum];
// 
// stock stretcher:spawn(playerid) {
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned]) return 0;
//     new Float:X, Float:Y, Float:Z;
//     GetPlayerPos(playerid, X, Y, Z);
//     foreach(new i:Vehicle) { // vehicleid start at 1
//         if(GetVehicleModel(i) == 416 && GetVehicleDistanceFromPoint(i, X, Y, Z) < 10.0) {
//             SetPlayerAttachedObject(playerid, stretcher_player_index, 1997, 1, -1.106504, 1.504988, 0.031584, 0.000000, 89.566635, 0.000000);
//             stretcher:PlayerData[playerid][stretcher:isAttached] = true;
//             stretcher:PlayerData[playerid][stretcher:isSpawned] = true;
//             return true; // stop the loop
//         }
//     }
//     SendClientMessage(playerid, -1, "[Alexa]: You need to be next to an ambulance");
//     return 1;
// }
// 
// stock stretcher:leave(playerid) {
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned] && stretcher:PlayerData[playerid][stretcher:isAttached]) {
//         new Float:X, Float:Y, Float:Z;
//         GetPlayerPos(playerid, X, Y, Z);
//         if(IsPlayerAttachedObjectSlotUsed(playerid, stretcher_player_index)) {
//             new Float:A;
//             GetPlayerFacingAngle(playerid, A);
//             stretcher:PlayerData[playerid][stretcher:modelID] = CreateObject(1997, X - floatsin(A, degrees), Y + floatcos(A, degrees), Z - 1.0, 0.0, 0.0, A, 50.0);
//             RemovePlayerAttachedObject(playerid, stretcher_player_index);
//             stretcher:PlayerData[playerid][stretcher:isAttached] = false;
//             stretcher:PlayerData[playerid][stretcher:isCreated] = true;
//         }
//     }
// }
// 
// stock stretcher:grab(playerid) {
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned] && stretcher:PlayerData[playerid][stretcher:isCreated]) {
//         DestroyObject(stretcher:PlayerData[playerid][stretcher:modelID]);
//         stretcher:PlayerData[playerid][stretcher:isCreated] = false;
//         if(stretcher:PlayerData[playerid][stretcher:isSpawned] && !stretcher:PlayerData[playerid][stretcher:isAttached] && !stretcher:PlayerData[playerid][stretcher:isCreated]) {
//             SetPlayerAttachedObject(playerid, stretcher_player_index, 1997, 1, -1.106504, 1.504988, 0.031584, 0.000000, 89.566635, 0.000000);
//             stretcher:PlayerData[playerid][stretcher:isAttached] = true;
//         }
//     }
// }
// 
// stock stretcher:destroy(playerid) {
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned] && stretcher:PlayerData[playerid][stretcher:isAttached]) RemovePlayerAttachedObject(playerid, stretcher_player_index);
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned] && stretcher:PlayerData[playerid][stretcher:isCreated]) DestroyObject(stretcher:PlayerData[playerid][stretcher:modelID]);
//     stretcher:PlayerData[playerid][stretcher:isAttached] = false;
//     stretcher:PlayerData[playerid][stretcher:isCreated] = false;
//     stretcher:PlayerData[playerid][stretcher:isSpawned] = false;
//     return 1;
// }
// 
// hook OnPlayerConnect(playerid) {
//     stretcher:destroy(playerid);
//     return 1;
// }
// 
// hook OnPlayerDisconnect(playerid, reason) {
//     stretcher:destroy(playerid);
//     if(operation:PData[playerid][operation:isInOperation]) operation:fail(playerid);
//     return 1;
// }
// 
// hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
//     if(stretcher:PlayerData[playerid][stretcher:isSpawned]) stretcher:destroy(playerid);
//     return 1;
// }
// 
// hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
//     if(newkeys == KEY_SECONDARY_ATTACK) {
//         if(operation:PData[playerid][operation:isInOperation]) operation:fail(playerid);
//     }
//     return 1;
// }
// 
// stock cmd_stretcher(playerid) {
//     new string[512];
//     strcat(string, "take out from ambulance\n");
//     strcat(string, "leave here\n");
//     strcat(string, "grab stretcher\n");
//     strcat(string, "put in ambulance\n");
//     ShowPlayerDialogEx(playerid, operation:Dialog, operation:Stretcher, DIALOG_STYLE_LIST, "Stretcher", string, "Select", "Close");
//     return 1;
// }
// 
// UCP:OnInit(playerid, page) {
//     if(page != 0) return 1;
//     if(Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) UCP:AddCommand(playerid, "Stretcher");
//     return 1;
// }
// 
// UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
//     if(!response || page != 0) return 1;
//     if(IsStringSame(inputtext, "Stretcher")) {
//         cmd_stretcher(playerid);
//         return ~1;
//     }
//     return 1;
// }
// 

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid == 30 && Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) { operation:ShowMenu(playerid); return ~1; }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) {
        new vehicleid = GetPlayerNearestVehicle(playerid);
        if (GetVehicleModel(vehicleid) == 416) QuickActions:AddCommand(playerid, "Put in Ambulance");
        if (IsPlayerInRangeOfPoint(playerid, 30.00, 1193.5244, -1325.6492, 13.3984)) QuickActions:AddCommand(playerid, "Send Patient in Operation Theator");
    }
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (IsStringSame(inputtext, "Send Patient in Operation Theator")) {
        SetPlayerPosEx(targetid, 1143.2677, -1331.6532, -7.1295);
        SendClientMessage(playerid, -1, sprintf("{00afff}Alexa:{FFFFFF} you have put %s in opeartion theator room", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("{00afff}Alexa:{FFFFFF} you have been put in opeation theator room by doctor %s", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (IsStringSame(inputtext, "Put in Ambulance")) {
        if (Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) {
            new vehicleid = GetPlayerNearestVehicle(playerid);
            if (GetVehicleModel(vehicleid) == 416) {
                new pasSeat = GetVehicleNextSeat(vehicleid);
                if (pasSeat != INVALID_SEAT_ID) {
                    PutPlayerInVehicleEx(targetid, vehicleid, pasSeat);
                    SendClientMessage(playerid, -1, sprintf("{00afff}Alexa:{FFFFFF} you have put %s in ambulance, take the patient to hospital", GetPlayerNameEx(targetid)));
                    SendClientMessage(targetid, -1, sprintf("{00afff}Alexa:{FFFFFF} you have been put in abulance by doctor %s", GetPlayerNameEx(playerid)));
                }
            }
        }
        return ~1;
    }
    return 1;
}