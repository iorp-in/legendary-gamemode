enum radarEnum {
    bool:rIsEnabled,
    Float:rRangeLimit,
    rLastReport,
    Float:rMinSpeed
};
new radarStatus[MAX_PLAYERS][radarEnum];

hook OnPlayerConnect(playerid) {
    radarStatus[playerid][rIsEnabled] = false;
    radarStatus[playerid][rRangeLimit] = 50.0;
    radarStatus[playerid][rMinSpeed] = 50.0;
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (!IsTimePassedForPlayer(playerid, "radarUpdate", 5)) return 1;
    if (radarStatus[playerid][rIsEnabled]) {
        if (gettime() - radarStatus[playerid][rLastReport] > 5) {
            if (IsPlayerInAnyVehicle(playerid)) {
                new vehicleid = GetPlayerVehicleID(playerid);
                if (IsValidVehicle(vehicleid)) {
                    new rModelID = GetVehicleModel(vehicleid);
                    if (rModelID == 596 || rModelID == 597 || rModelID == 598 || rModelID == 599) {
                        new Float:rPos[3];
                        GetPlayerPos(playerid, rPos[0], rPos[1], rPos[2]);
                        foreach(new plID:Player) {
                            if (plID == playerid) continue;
                            if (IsPlayerInAnyVehicle(plID)) {
                                if (IsPlayerInRangeOfPoint(plID, radarStatus[playerid][rRangeLimit], rPos[0], rPos[1], rPos[2])) {
                                    if (GetPlayerVehicleSeat(plID) != 0) continue;
                                    new vID = GetPlayerVehicleID(plID);
                                    new Float:rSpeed = GetVehicleSpeed(vID);
                                    if (rSpeed > radarStatus[playerid][rMinSpeed]) {
                                        radarStatus[playerid][rLastReport] = gettime();
                                        SendClientMessage(playerid, -1, sprintf("{0859C6}[Speed Radar]:{ffffff} %s driving %s at %.0f", GetPlayerNameEx(plID), GetVehicleName(vID), rSpeed));
                                        continue;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return 1;
}

stock ShowSpeedRadarMenu(playerid) {
    new string[512];
    strcat(string, sprintf("Status\t%s\n", radarStatus[playerid][rIsEnabled] ? "{80C904}Enabled{FFFFFF}" : "{FF0000}Disabled{FFFFFF}"));
    strcat(string, sprintf("Range\t%d\n", floatround(radarStatus[playerid][rRangeLimit])));
    strcat(string, sprintf("Minimum Speed Limit\t%d\n", floatround(radarStatus[playerid][rMinSpeed])));
    return FlexPlayerDialog(playerid, "ShowSpeedRadarMenu", DIALOG_STYLE_TABLIST, "{0859C6}[Speed Radar]", string, "Select", "Close");
}

FlexDialog:ShowSpeedRadarMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) {
        radarStatus[playerid][rIsEnabled] = !radarStatus[playerid][rIsEnabled];
        return ShowSpeedRadarMenu(playerid);
    }
    if (listitem == 1) return RadarRangeInput(playerid);
    if (listitem == 2) return RadarSpeedLimitInput(playerid);
    return 1;
}

stock RadarRangeInput(playerid) {
    return FlexPlayerDialog(playerid, "RadarRangeInput", DIALOG_STYLE_INPUT, "{0859C6}[Speed Radar]", "enter radar range between 10 to 100 meters\ndefault range is 50 meter", "Select", "Close");
}

FlexDialog:RadarRangeInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowSpeedRadarMenu(playerid);
    new Float:radarLimit;
    if (sscanf(inputtext, "f", radarLimit) || radarLimit < 10.00 || radarLimit > 100.00) return RadarRangeInput(playerid);
    radarStatus[playerid][rRangeLimit] = radarLimit;
    return ShowSpeedRadarMenu(playerid);
}

stock RadarSpeedLimitInput(playerid) {
    return FlexPlayerDialog(playerid, "RadarSpeedLimitInput", DIALOG_STYLE_INPUT, "{0859C6}[Speed Radar]", "enter radar speed limit between 50 to 500 meters\ndefault speed is 50kmph", "Select", "Close");
}

FlexDialog:RadarSpeedLimitInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ShowSpeedRadarMenu(playerid);
    new Float:speedLimit;
    if (sscanf(inputtext, "f", speedLimit) || speedLimit < 50.00 || speedLimit > 500.00) return RadarSpeedLimitInput(playerid);
    radarStatus[playerid][rMinSpeed] = speedLimit;
    return ShowSpeedRadarMenu(playerid);
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    new allow_faction[] = { 0, 1, 2, 3 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
        if (IsPlayerInAnyVehicle(playerid)) {
            new rModelID = GetVehicleModel(GetPlayerVehicleID(playerid));
            if (rModelID == 596 || rModelID == 597 || rModelID == 598 || rModelID == 599) UCP:AddCommand(playerid, "Speed Radar", true);
        }
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Speed Radar", inputtext)) return ShowSpeedRadarMenu(playerid);
    return 1;
}