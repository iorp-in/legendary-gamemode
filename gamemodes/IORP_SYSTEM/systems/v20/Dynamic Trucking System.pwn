/*
=== Funcs ===
AddTruckCommand(playerid, trailerid, "")

defaults:
    > Open Crate Loading
    > Close Crate Loading

=== Callbacks ===
> OnTruckStorageAccess(playerid, trailerid)
> OnTruckStorageResponse(playerid, trailerid, response, inputttext)
> OnTruckLoadCrate(playerid, trailerid, crateType, owner)
*/

new DTruck:string_top[MAX_PLAYERS][2000];
new DTruck:string[MAX_PLAYERS][2000];
stock DTruck:Init(playerid, trailerid, page = 0) {
    format(DTruck:string_top[playerid], 500, "");
    format(DTruck:string[playerid], 2000, "");
    CallRemoteFunction("DTruckOnInit", "ddd", playerid, trailerid, page);
    return 1;
}

forward DTruckOnResponse(playerid, trailerid, page, response, listitem, const inputtext[]);
public DTruckOnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    return 1;
}

forward DTruckOnInit(playerid, trailerid, page);
public DTruckOnInit(playerid, trailerid, page) {
    SortString(DTruck:string_top[playerid], DTruck:string_top[playerid]);
    SortString(DTruck:string[playerid], DTruck:string[playerid]);
    if (!strlen(DTruck:string[playerid])) format(DTruck:string[playerid], 2000, "Nothing On This Page.");
    else DTruck:AddCommand(playerid, "Next Page");
    if (page != 0) DTruck:AddCommand(playerid, "Back Page");
    format(DTruck:string[playerid], 2000, "%s\n%s", DTruck:string_top[playerid], DTruck:string[playerid]);
    return FlexPlayerDialog(playerid, "DTruckOnInit", DIALOG_STYLE_LIST, "{4286f4}[Alexa]:{FFFFEE}Access Trailer", DTruck:string[playerid], "Select", "Close", page, sprintf("%d", trailerid));
}

FlexDialog:DTruckOnInit(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Nothing On This Page.", inputtext) && response) DTruck:Init(playerid, extraid);
    else if (IsStringSame("Next Page", inputtext) && response) DTruck:Init(playerid, extraid + 1);
    else if (IsStringSame("Back Page", inputtext) && response) DTruck:Init(playerid, extraid - 1);
    else CallRemoteFunction("DTruckOnResponse", "ddddds", playerid, strval(payload), extraid, response, listitem, inputtext);
    return 1;
}

stock DTruck:AddCommand(playerid, const command[], bool:top = false) {
    if (!strlen(DTruck:string[playerid])) format(DTruck:string[playerid], 2000, "%s\n", command);
    else if (top) format(DTruck:string_top[playerid], 2000, "%s\n%s\n", command, DTruck:string_top[playerid]);
    else format(DTruck:string[playerid], 2000, "%s\n%s\n", DTruck:string[playerid], command);
    return 1;
}

forward OnTrailerCheckInit(playerid, trailerid);
public OnTrailerCheckInit(playerid, trailerid) {
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} trailer checkup complete.");
    return 1;
}

new DTruck_AllowedVehicleIds[] = { 592, 408, 413, 414, 422, 435, 440, 450, 455, 456, 478, 482, 498, 499, 524, 543, 554, 578, 584, 591, 605, 609 };

stock IsVehicleAllowedForStorage(vehicleid) {
    if (!StaticVehicle:IsValidID(StaticVehicle:GetID(vehicleid))) return 0;
    return IsArrayContainNumber(DTruck_AllowedVehicleIds, GetVehicleModel(vehicleid));
}

stock GetAllowedVehicleTrailerID(vehicleid) {
    if (!IsValidVehicle(vehicleid)) return -1;
    if (IsVehicleAllowedForStorage(vehicleid)) return vehicleid;
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid == 0) return -1;
    if (IsVehicleAllowedForStorage(trailerid)) return trailerid;
    return -1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (!IsPlayerInAnyVehicle(playerid)) return 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid != 0) vehicleid = trailerid;
    new vehicleModal = GetVehicleModel(vehicleid);
    if (!IsArrayContainNumber(DTruck_AllowedVehicleIds, vehicleModal)) return 1;
    UCP:AddCommand(playerid, "Access Trailer", true);
    UCP:AddCommand(playerid, "Check Trailer", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid != 0) vehicleid = trailerid;
    new vehicleModal = GetVehicleModel(vehicleid);
    if (!response || !IsPlayerInAnyVehicle(playerid) || !IsArrayContainNumber(DTruck_AllowedVehicleIds, vehicleModal)) return 1;

    if (IsStringSame("Access Trailer", inputtext)) {
        DTruck:Init(playerid, vehicleid);
        return ~1;
    }

    if (IsStringSame("Check Trailer", inputtext)) {
        CallRemoteFunction("OnTrailerCheckInit", "dd", playerid, vehicleid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsPlayerInAnyVehicle(playerid)) {
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    new trailerid = GetVehicleTrailer(vehicleid);
    if (trailerid != 0) vehicleid = trailerid;
    new vehicleModal = GetVehicleModel(vehicleid);
    if (!IsArrayContainNumber(DTruck_AllowedVehicleIds, vehicleModal)) {
        return 1;
    }

    if (IsStringContainWords(text, "access trailer")) {
        DTruck:Init(playerid, vehicleid);
        return ~1;
    }

    if (IsStringContainWords(text, "check trailer")) {
        CallRemoteFunction("OnTrailerCheckInit", "dd", playerid, vehicleid);
        return ~1;
    }
    return 1;
}

new DTruck_TrailerIDs[] = { 435, 450, 584, 591 };

stock GetPlayerNearestTrailerID(playerid, Float:range = 5.0) {
    foreach(new vehicleid:Vehicle) {
        if (IsValidVehicle(vehicleid)) {
            if (IsArrayContainNumber(DTruck_TrailerIDs, GetVehicleModel(vehicleid))) {
                if (IsPlayerInRangeOfVehicle(playerid, vehicleid, Float:range)) return vehicleid;
            }
        }
    }
    return -1;
}

//#snippet init_dtruck hook DTruckOnInit(playerid, trailerid, page) {\n\tif(page != 0) return 1;\n\tDTruck:AddCommand(playerid, "Command");\n\treturn 1;\n}\n\nhook DTruckOnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {\n\tif(!response) return 1;\n\tif(IsStringSame("Command", inputtext)) {\n\t\treturn ~1;\n\t}\n\treturn 1;\n}