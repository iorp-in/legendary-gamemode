new VTrunk:StringTop[MAX_PLAYERS][2000];
new VTrunk:String[MAX_PLAYERS][2000];
stock VTrunk:Init(playerid, xid, page = 0) {
    format(VTrunk:StringTop[playerid], 500, "");
    format(VTrunk:String[playerid], 2000, "");
    CallRemoteFunction("VTrunkOnInit", "ddd", playerid, xid, page);
    return 1;
}

forward VTrunkOnResponse(playerid, xid, page, response, listitem, const inputtext[]);
public VTrunkOnResponse(playerid, xid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) VTrunk:Init(playerid, xid, page - 1);
    return 1;
}

forward VTrunkOnInit(playerid, xid, page);
public VTrunkOnInit(playerid, xid, page) {
    new vehicleid = PersonalVehicle:GetVehicleID(xid);
    if (!IsValidVehicle(vehicleid)) return 0;
    SortString(VTrunk:StringTop[playerid], VTrunk:StringTop[playerid]);
    SortString(VTrunk:String[playerid], VTrunk:String[playerid]);
    if (!strlen(VTrunk:String[playerid])) format(VTrunk:String[playerid], 2000, "Nothing On This Page.");
    else VTrunk:AddCommand(playerid, "Next Page");
    if (page != 0) VTrunk:AddCommand(playerid, "Back Page");
    if (strlen(VTrunk:StringTop[playerid]) > 0) format(VTrunk:String[playerid], 2000, "%s\n%s", VTrunk:StringTop[playerid], VTrunk:String[playerid]);
    return FlexPlayerDialog(
        playerid, "VehicleTruckMenu", DIALOG_STYLE_LIST, sprintf("{4286f4}[Alexa]: {FFFFEE}%s Trunk", GetVehicleName(vehicleid)),
        VTrunk:String[playerid], "Select", "Close", page, sprintf("%d", xid)
    );
}

FlexDialog:VehicleTruckMenu(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    new xid = strval(payload);
    if (IsStringSame("Nothing On This Page.", inputtext) && response) VTrunk:Init(playerid, xid, page);
    else if (IsStringSame("Next Page", inputtext) && response) VTrunk:Init(playerid, xid, page + 1);
    else if (IsStringSame("Back Page", inputtext) && response) VTrunk:Init(playerid, xid, page - 1);
    else CallRemoteFunction("VTrunkOnResponse", "ddddds", playerid, xid, page, response, listitem, inputtext);
    return 1;
}

stock VTrunk:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(VTrunk:StringTop[playerid])) format(VTrunk:StringTop[playerid], 2000, "%s", command);
        else format(VTrunk:StringTop[playerid], 2000, "%s\n%s", VTrunk:StringTop[playerid], command);
    } else {
        if (!strlen(VTrunk:String[playerid])) format(VTrunk:String[playerid], 2000, "%s", command);
        else format(VTrunk:String[playerid], 2000, "%s\n%s", VTrunk:String[playerid], command);
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new vehicleid = GetPlayerNearestVehicle(playerid, 4);
    if (IsValidVehicle(vehicleid)) {
        new Float:xxx, Float:yyy, Float:zzz;
        GetVehicleShiftPos(vehicleid, 1, Float:xxx, Float:yyy, Float:zzz, 2.0);
        if (IsPlayerInRangeOfPoint(playerid, 2, Float:xxx, Float:yyy, Float:zzz)) {
            new xid = PersonalVehicle:GetID(vehicleid);
            if (xid != 0) {
                if (IsVehicleHasBoot(GetVehicleModel(vehicleid))) {
                    if (IsVehicleBootOpened(vehicleid)) UCP:AddCommand(playerid, "Access Vehicle Trunk", true);
                }
            }
        }
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Access Vehicle Trunk", inputtext)) {
        new vehicleid = GetPlayerNearestVehicle(playerid, 4);
        if (IsValidVehicle(vehicleid)) {
            new Float:xxx, Float:yyy, Float:zzz;
            GetVehicleShiftPos(vehicleid, 1, Float:xxx, Float:yyy, Float:zzz, 2.0);
            if (IsPlayerInRangeOfPoint(playerid, 2, Float:xxx, Float:yyy, Float:zzz)) {
                new xid = PersonalVehicle:GetID(vehicleid);
                if (xid != 0) {
                    if (IsVehicleHasBoot(GetVehicleModel(vehicleid))) {
                        if (IsVehicleBootOpened(vehicleid)) VTrunk:Init(playerid, xid);
                    }
                }
            }
        }
        return ~1;
    }
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn(XVEHICLE_TABLE, "trunk", "json", "{}");
    return 1;
}

stock VTrunk:GetInt(const field[], xid, dDefault = 0) {
    if (!PersonalVehicle:IsValidID(xid)) return dDefault;
    return Database:GetJsonInt("trunk", field, dDefault, XVEHICLE_TABLE, "id", sprintf("%d", xid));
}

stock VTrunk:UpdateInt(const field[], xid, value) {
    if (!PersonalVehicle:IsValidID(xid)) return 0;
    Database:UpdateJsonInt(XVEHICLE_TABLE, "trunk", field, value, "id", sprintf("%d", xid));
    return 1;
}

//#snippet init_vtrunk VTrunk:OnInit(playerid, xid, page){if(page != 0) return 1;VTrunk:AddCommand(playerid, "Command");return 1;}VTrunk:OnResponse(playerid, xid, page, response, listitem, const inputtext[]) {if(!response) return 1; new vehicleid = PersonalVehicle:GetVehicleID(xid); if(!IsValidVehicle(vehicleid)) return 1; if(IsStringSame("Command", inputtext)) {return ~1;} return 1;}