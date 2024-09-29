#define MAX_Hotel_Rooms 3
enum Hotel:playerdataenum {
    bool:Hotel:isInsideHotel,
    Hotel:roomType,
    Hotel:checkedInAt
}
new Hotel:playerData[MAX_PLAYERS][Hotel:playerdataenum];

new Float:Hotel:rooms[MAX_Hotel_Rooms][7] = {
    { 1394.8043, -9.7791, 1000.9383, 1389.6990, -10.5511, 1000.9383, 13.0 },
    { 1412.1044, -1475.9944, 125.3919, 1408.1686, -1479.6139, 125.3909, 3.0 },
    { 1398.4319, -13.8527, 1001.0000, 1394.2982, -44.6414, 1000.9001, 12.0 }
};

// end vars

// start funcs

stock Hotel:IsPlayerInHotel(playerid) {
    return Hotel:playerData[playerid][Hotel:isInsideHotel];
}

stock Hotel:SendPlayerInHotelRoom(playerid) {
    if (Hotel:playerData[playerid][Hotel:roomType] == -1) return 1;
    Hotel:playerData[playerid][Hotel:isInsideHotel] = true;
    new minLeft = (Hotel:playerData[playerid][Hotel:checkedInAt] + 60 * 60 - gettime()) / 60;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Hotel]: {FFFFEE}you have %d mins left to stay in hotel", floatround(minLeft)));

    if (Hotel:playerData[playerid][Hotel:roomType] == 2) {
        SetPlayerPosEx(playerid, Hotel:rooms[2][0], Hotel:rooms[2][1], Hotel:rooms[2][2]);
        SetPlayerVirtualWorldEx(playerid, 12345 + playerid);
        SetPlayerInteriorEx(playerid, floatround(Hotel:rooms[2][6]));
    } else if (Hotel:playerData[playerid][Hotel:roomType] == 1) {
        SetPlayerPosEx(playerid, Hotel:rooms[1][0], Hotel:rooms[1][1], Hotel:rooms[1][2]);
        SetPlayerVirtualWorldEx(playerid, 12345 + playerid);
        SetPlayerInteriorEx(playerid, floatround(Hotel:rooms[1][6]));
    } else {
        SetPlayerPosEx(playerid, Hotel:rooms[0][0], Hotel:rooms[0][1], Hotel:rooms[0][2]);
        SetPlayerVirtualWorldEx(playerid, 12345 + playerid);
        SetPlayerInteriorEx(playerid, floatround(Hotel:rooms[0][6]));
    }
    return 1;
}

stock Hotel:SendPlayerInLobbey(playerid) {
    Hotel:playerData[playerid][Hotel:isInsideHotel] = false;
    SetPlayerVirtualWorldEx(playerid, 0);
    SetPlayerPosEx(playerid, 1487.5601, -2286.4575, 13.6170);
    SetPlayerInteriorEx(playerid, 0);
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new playerid:Player) {
        if (Hotel:playerData[playerid][Hotel:roomType] != -1) {
            if (gettime() > Hotel:playerData[playerid][Hotel:checkedInAt] + 60 * 60) {
                Hotel:playerData[playerid][Hotel:roomType] = -1;
                Hotel:playerData[playerid][Hotel:checkedInAt] = 0;
                if (Hotel:IsPlayerInHotel(playerid)) Hotel:SendPlayerInLobbey(playerid);
                SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you are autometed checked out, reason: time's up");
            }
        }
    }
    return 1;
}

// end funcs

// start callbacks
hook OnPlayerConnect(playerid) {
    Hotel:playerData[playerid][Hotel:isInsideHotel] = false;
    Hotel:playerData[playerid][Hotel:roomType] = -1;
    Hotel:playerData[playerid][Hotel:checkedInAt] = 0;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_SECONDARY_ATTACK && IsPlayerInRangeOfPoint(playerid, 5.0, 1482.0011, -2275.5439, 13.6181)) {
        Hotel:reception(playerid);
    }
    if (newkeys == KEY_SECONDARY_ATTACK && IsPlayerInRangeOfPoint(playerid, 5.0, 1487.5601, -2286.4575, 13.6170)) {
        if (Hotel:playerData[playerid][Hotel:roomType] == -1) {
            SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you haven't checked in yet, goto reception for check in");
        } else {
            Hotel:SendPlayerInHotelRoom(playerid);
        }
    }
    if (newkeys == KEY_SECONDARY_ATTACK && Hotel:IsPlayerInHotel(playerid)) {
        for (new i; i < 3; i++) {
            if (IsPlayerInRangeOfPoint(playerid, 5.0, Hotel:rooms[i][0], Hotel:rooms[i][1], Hotel:rooms[i][2])) {
                Hotel:SendPlayerInLobbey(playerid);
            }
        }
    }
    if (newkeys == KEY_SECONDARY_ATTACK && Hotel:IsPlayerInHotel(playerid)) {
        for (new i; i < 3; i++) {
            if (IsPlayerInRangeOfPoint(playerid, 5.0, Hotel:rooms[i][3], Hotel:rooms[i][4], Hotel:rooms[i][5])) {
                OpenClotheManage(playerid);
            }
        }
    }
    return 1;
}

// end callbacks

// start dialog

stock Hotel:reception(playerid) {
    new string[512];
    if (Hotel:playerData[playerid][Hotel:roomType] != -1) strcat(string, "Check Out\n");
    else strcat(string, "Check In\n");
    return FlexPlayerDialog(playerid, "HotelReceptionMenu", DIALOG_STYLE_LIST, "{4286f4}[Hotel]: {FFFFEE}Reception", string, "Select", "Cancel");
}

FlexDialog:HotelReceptionMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Check In")) return Hotel:checkin(playerid);
    if (IsStringSame(inputtext, "Check Out")) {
        Hotel:playerData[playerid][Hotel:isInsideHotel] = false;
        Hotel:playerData[playerid][Hotel:roomType] = -1;
        Hotel:playerData[playerid][Hotel:checkedInAt] = 0;
        SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you have checked out");
        return 1;
    }
    return 1;
}

stock Hotel:checkin(playerid) {
    new string[512];
    strcat(string, "Type\tPrice($)\tDuration\n");
    strcat(string, "Standard\t$500\t1 hour\n");
    strcat(string, "Deluxe\t$1000\t1 hour\n");
    strcat(string, "Premium\t$2000\t1 hour\n");
    return FlexPlayerDialog(playerid, "HotelCheckinMenu", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Hotel]: {FFFFEE}Reception", string, "Select", "Cancel");
}

FlexDialog:HotelCheckinMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) {
        if (GetPlayerCash(playerid) < 500) {
            SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you don't have $500 to rent this room");
            return 1;
        }
        vault:PlayerVault(playerid, -500, "rent a room at hotel", Vault_ID_Government, 500, sprintf("%s rent a room at hotel", GetPlayerNameEx(playerid)));
        Hotel:playerData[playerid][Hotel:roomType] = 0;
        Hotel:playerData[playerid][Hotel:checkedInAt] = gettime();
        SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you have checked in for Standard room");
        return 1;
    }
    if (listitem == 1) {
        if (GetPlayerCash(playerid) < 1000) {
            SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you don't have $1000 to rent this room");
            return 1;
        }
        vault:PlayerVault(playerid, -1000, "rent a room at hotel", Vault_ID_Government, 1000, sprintf("%s rent a room at hotel", GetPlayerNameEx(playerid)));
        Hotel:playerData[playerid][Hotel:roomType] = 1;
        Hotel:playerData[playerid][Hotel:checkedInAt] = gettime();
        SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you have checked in for Deluxe room");
        return 1;
    }
    if (listitem == 2) {
        if (GetPlayerCash(playerid) < 2000) {
            SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you don't have $2000 to rent this room");
            return 1;
        }
        vault:PlayerVault(playerid, -2000, "rent a room at hotel", Vault_ID_Government, 2000, sprintf("%s rent a room at hotel", GetPlayerNameEx(playerid)));
        Hotel:playerData[playerid][Hotel:roomType] = 2;
        Hotel:playerData[playerid][Hotel:checkedInAt] = gettime();
        SendClientMessage(playerid, -1, "{4286f4}[Hotel]: {FFFFEE}you have checked in for Premium room");
        return 1;
    }
    return 1;
}
// end dialog