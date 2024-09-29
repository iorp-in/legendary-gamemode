stock IsIpConnected(playerid) {
    new allip[33], playersip[33];
    GetPlayerIp(playerid, playersip, sizeof(playersip));
    foreach(new i:Player) {
        if (IsPlayerConnected(i) && !IsPlayerNPC(i) && i != playerid) {
            GetPlayerIp(i, allip, sizeof(allip));
            if (strcmp(allip, playersip, true) == 0) return true;
        }
    }
    return false;
}

stock IsIpOfNoneAdminConnected(playerid) {
    new allip[33], playersip[33];
    GetPlayerIp(playerid, playersip, sizeof(playersip));
    foreach(new i:Player) {
        if (IsPlayerConnected(i) && !IsPlayerNPC(i) && i != playerid) {
            if (GetPlayerAdminLevel(i) == 10) continue;
            GetPlayerIp(i, allip, sizeof(allip));
            if (strcmp(allip, playersip, true) == 0) return true;
        }
    }
    return false;
}

stock GetPlayerNameEx(playerid) {
    new string[MAX_PLAYER_NAME];
    format(string, sizeof string, "unknown");
    GetPlayerName(playerid, string, MAX_PLAYER_NAME);
    return string;
}

stock GetPlayerIpEx(playerid) {
    #pragma unused playerid
    new string[MAX_PLAYER_NAME];
    GetPlayerIp(playerid, string, MAX_PLAYER_NAME);
    // format(string, sizeof string, "-");
    return string;
}

stock FormatCurrency(money) {
    new string[50];
    format(string, sizeof(string), "%d", money);
    for (new i = (strlen(string) - 3); i > (money < 0 ? 1 : 0); i -= 3) strins(string[i], ",", 0);
    return string;
}

//Y_Less
stock RandomEx(min, max) {
    return random(max - min) + min;
}

stock FormatCurrencyEx(intVariable, iThousandSeparator = ',', iCurrencyChar = '$') {
    static s_szReturn[32],
        s_szThousandSeparator[2] = {
            ' ',
            EOS
        },
        s_szCurrencyChar[2] = {
            ' ',
            EOS
        },
        s_iVariableLen,
        s_iChar,
        s_iSepPos,
        bool:s_isNegative;

    format(s_szReturn, sizeof(s_szReturn), "%d", intVariable);

    if (s_szReturn[0] == '-')
        s_isNegative = true;
    else
        s_isNegative = false;

    s_iVariableLen = strlen(s_szReturn);

    if (s_iVariableLen >= 4 && iThousandSeparator) {
        s_szThousandSeparator[0] = iThousandSeparator;

        s_iChar = s_iVariableLen;
        s_iSepPos = 0;

        while (--s_iChar > _:s_isNegative) {
            if (++s_iSepPos == 3) {
                strins(s_szReturn, s_szThousandSeparator, s_iChar);

                s_iSepPos = 0;
            }
        }
    }
    if (iCurrencyChar) {
        s_szCurrencyChar[0] = iCurrencyChar;
        strins(s_szReturn, s_szCurrencyChar, _:s_isNegative);
    }
    return s_szReturn;
}

stock ConvertToMinutes(time) {
    new string[15]; //-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

stock GetVehicleSpeedEx(playerid) {
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    new Float:Pos[4];
    GetVehicleVelocity(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
    Pos[3] = floatsqroot(floatpower(floatabs(Pos[0]), 2) + floatpower(floatabs(Pos[1]), 2) + floatpower(floatabs(Pos[2]), 2)) * 181.5;
    return floatround(Pos[3]);
}

stock IsArrayContainNumber(const array[], number, size = sizeof array) {
    for (new i = 0; i < size; i++) {
        if (array[i] == number) return 1;
    }
    return 0;
}

stock GetArrayIndex(const array[], number, size = sizeof array) {
    for (new i = 0; i < size; i++) {
        if (array[i] == number) return i;
    }
    return -1;
}

stock RandomNumberFromArray(const array[], size = sizeof array) {
    return array[RandomEx(0, size)];
}

stock GetWeaponNameEx(weaponid) {
    new string[128];
    GetWeaponName(weaponid, string, sizeof string);
    return string;
}

stock GetNextWordFromString(const string[], const word[], pos = 1) {
    new data[10][100], count;
    count = strexplode(data, string, " ");
    for (new i = 0; i < count; i++) {
        if (!strcmp(word, data[i])) {
            if (strlen(data[i + pos]) == 0) break;
            else return data[i + pos];
        }
    }
    data[0] = "";
    return data[0];
}

stock GetOnlinePlayerCount() {
    new count = 0;
    foreach(new i:Player) count++;
    return count;
}

stock bool:IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY) {
    new Float:player_pos[3];
    GetPlayerPos(playerid, player_pos[0], player_pos[1], player_pos[2]);
    if (player_pos[0] > MinX && player_pos[0] < MaxX && player_pos[1] > MinY && player_pos[1] < MaxY) return true;
    return false;
}

stock bool:IsXYInArea(Float:x, Float:y, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY) {
    if (x > MinX && x < MaxX && y > MinY && y < MaxY) return true;
    return false;
}

stock Float:frandom(Float:min, Float:max, dp = 2) {
    new
    // Get the multiplication for storing fractional parts.
    Float:mul = floatpower(10.0, dp),
        // Get the max and min as integers, with extra dp.
        imin = floatround(min * mul),
        imax = floatround(max * mul);
    // Get a random int between two bounds and convert it to a float.
    return float(random(imax - imin) + imin) / mul;
}

stock GetRandomPosAtLocation(Float:distance, Float:X, Float:Y, Float:Z, & Float:x, & Float:y, & Float:z) {
    x = frandom(X, X + distance);
    y = frandom(Y, Y + distance);
    z = Z;
    return 1;
}

stock GetRandomPosInArea(Float:MinX, Float:MinY, Float:MaxX, Float:MaxY, & Float:x, & Float:y) {
    x = frandom(MinX, MinY);
    y = frandom(MaxX, MaxY);
    return 1;
}

stock Float:GetAngleBetweenPoints(Float:x, Float:y, Float:X, Float:Y) {
    new Float:fAngle;
    if (x > X && y > Y) fAngle = floatabs(atan2(floatsub(X, x), floatsub(Y, y)));
    if (x > X && y <= Y) fAngle = floatadd(floatabs(atan2(floatsub(y, Y), floatsub(X, x))), 270.0);
    if (x <= X && y > Y) fAngle = floatadd(floatabs(atan2(floatsub(Y, y), floatsub(x, X))), 90.0);
    if (x <= X && y <= Y) fAngle = floatadd(floatabs(atan2(floatsub(x, X), floatsub(y, Y))), 180.0);
    return fAngle >= 360.0 ? floatsub(fAngle, 360.0) : fAngle;
}

forward bool:IsTimePassedForPlayer(playerid, const Function_Name[], seconds);
public bool:IsTimePassedForPlayer(playerid, const Function_Name[], seconds) {
    new current_time = gettime();
    new last_time = GetPVarInt(playerid, Function_Name);
    if (current_time - (last_time + seconds) >= 0) {
        SetPVarInt(playerid, Function_Name, current_time);
        return true;
    }
    return false;
}

stock GetLastTimeForPlayer(playerid, const Function_Name[]) {
    return GetPVarInt(playerid, Function_Name);
}

stock GetPlayerGender(playerid) {
    new skin_woman[] = { 9, 10, 11, 12, 13, 31, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298 };
    new string[50];
    if (IsArrayContainNumber(skin_woman, GetPlayerSkin(playerid))) format(string, sizeof string, "Female");
    else format(string, sizeof string, "Male");
    return string;
}

stock bool:IsPlayerMale(playerid) {
    new skin_woman[] = { 9, 10, 11, 12, 13, 31, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298 };
    if (IsArrayContainNumber(skin_woman, GetPlayerSkin(playerid))) return false;
    else return true;
}

stock GetPlayerNearestVehicle(playerid, Float:range = 5.0) {
    foreach(new vehicleid:Vehicle) {
        new Float:x, Float:y, Float:z;
        GetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
        if (IsPlayerInRangeOfPoint(playerid, Float:range, x, y, z)) return vehicleid;
    }
    return -1;
}

stock SyntaxMSG(playerid, const message[]) {
    return SendClientMessage(playerid, -1, sprintf("{FF6600}USAGE: {FFFFFF} %s", message));
}

//#snippet sscanfdialog if(sscanf(inputtext, "")) return 1;
//#snippet alexamsgsprintf AlexaMsg(playerid, sprintf());
stock AlexaMsg(playerid, const message[], const sysname[] = "Alexa", const syshex[] = "4286f4", const msgcolor[] = "FFFFEE") {
    return SendClientMessage(playerid, -1, sprintf("{%s}[%s]:{%s} %s", syshex, sysname, msgcolor, FormatColors(message)));
}

stock IsValidWeaponID(weaponid) {
    // blacklisted 0 - fist
    // blacklisted 38 - minigun
    new weapons[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 39, 40, 41, 42, 43, 44, 45, 46 };
    return IsArrayContainNumber(weapons, weaponid);
}

stock Float:area(Float:x1, Float:y1, Float:x2, Float:y2, Float:x3, Float:y3) {
    return floatabs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0);
}

stock IsPlayerInRectange(playerid, Float:xx1, Float:yy1, Float:xx2, Float:yy2, Float:xx3, Float:yy3, Float:xx4, Float:yy4) {
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    new Float:x1 = floatround(Float:xx1),
        Float:y1 = floatround(Float:yy1),
        Float:x2 = floatround(Float:xx2),
        Float:y2 = floatround(Float:yy2),
        Float:x3 = floatround(Float:xx3),
        Float:y3 = floatround(Float:yy3),
        Float:x4 = floatround(Float:xx4),
        Float:y4 = floatround(Float:yy4),
        Float:x = floatround(Float:pos[0]),
        Float:y = floatround(Float:pos[1]);
    new Float:A = area(x1, y1, x2, y2, x3, y3) + area(x1, y1, x4, y4, x3, y3);
    new Float:A1 = area(x, y, x1, y1, x2, y2);
    new Float:A2 = area(x, y, x2, y2, x3, y3);
    new Float:A3 = area(x, y, x3, y3, x4, y4);
    new Float:A4 = area(x, y, x1, y1, x4, y4);
    return (A == A1 + A2 + A3 + A4);
}

stock FormatMention(const message[]) {
    new string[512];
    format(string, sizeof string, "%s", message);
    for (new playerid = MAX_PLAYERS - 1; playerid >= 0; playerid--) {
        if (IsPlayerConnected(playerid)) {
            strreplace(string, sprintf("@%d", playerid), sprintf("%s", GetPlayerNameEx(playerid)));
        }

    }
    return string;
}

stock FormatColors(const message[]) {
    new string[1024];
    format(string, sizeof string, "%s", message);
    strreplace(string, "~y~", "{FFFF00}");
    strreplace(string, "~w~", "{FFFFFF}");
    strreplace(string, "~r~", "{FF0000}");
    strreplace(string, "~g~", "{00FF00}");
    strreplace(string, "~b~", "{0000FF}");
    strreplace(string, "~0~", "{000000}");
    strreplace(string, "~o~", "{FF8000}");
    strreplace(string, "~p~", "{FF007F}");
    strreplace(string, "~m~", "{FF00FF}");
    return string;
}

stock FormatMyNumber(playerid, const message[]) {
    new string[512];
    format(string, sizeof string, "%s", message);
    strreplace(string, "@mynum", sprintf("%s", GetPlayerPhoneNumber(playerid)));
    return string;
}

stock IsStringSame(const str1[], const str2[], bool:ignorecase = false, length = cellmax) {
    if (strlen(str1) == strlen(str2) && strcmp(str1, str2, ignorecase, length) == 0) return 1;
    return 0;
}

stock RemoveMalChars(const message[]) {
    new string[1024];
    format(string, sizeof string, "%s", message);
    strreplace(string, "\\", "");
    strreplace(string, "\"", "");
    strreplace(string, "\'", "");
    strreplace(string, "`", "");
    return string;
}

stock RoleplayNameCheck(const rpname[]) {
    return RegMatch("^[A-Z][a-z]{2,9}_[A-Z][a-z]{2,9}$", rpname);
}

// stock RoleplayNameCheck(const rpname[]) {
//     new pname[MAX_PLAYER_NAME];
//     format(pname, sizeof pname, "%s", rpname);
//     if(strfind(pname, "[", true) != (-1)) return 0;
//     else if(strfind(pname, ".", true) != (-1)) return 0;
//     else if(strfind(pname, ",", true) != (-1)) return 0;
//     else if(strfind(pname, "<", true) != (-1)) return 0;
//     else if(strfind(pname, ">", true) != (-1)) return 0;
//     else if(strfind(pname, "'", true) != (-1)) return 0;
//     else if(strfind(pname, "/", true) != (-1)) return 0;
//     else if(strfind(pname, "?", true) != (-1)) return 0;
//     else if(strfind(pname, "+", true) != (-1)) return 0;
//     else if(strfind(pname, "%", true) != (-1)) return 0;
//     else if(strfind(pname, "#", true) != (-1)) return 0;
//     else if(strfind(pname, "@", true) != (-1)) return 0;
//     else if(strfind(pname, "$", true) != (-1)) return 0;
//     else if(strfind(pname, "!", true) != (-1)) return 0;
//     else if(strfind(pname, "^", true) != (-1)) return 0;
//     else if(strfind(pname, "&", true) != (-1)) return 0;
//     else if(strfind(pname, "(", true) != (-1)) return 0;
//     else if(strfind(pname, ")", true) != (-1)) return 0;
//     else if(strfind(pname, "-", true) != (-1)) return 0;
//     else if(strfind(pname, "*", true) != (-1)) return 0;
//     else if(strfind(pname, "-", true) != (-1)) return 0;
//     else if(strfind(pname, "\\", true) != (-1)) return 0;
//     else if(strfind(pname, "]", true) != (-1)) return 0;
//     else if(strfind(pname, "$", true) != (-1)) return 0;
//     else if(strfind(pname, "(", true) != (-1)) return 0;
//     else if(strfind(pname, ")", true) != (-1)) return 0;
//     else if(strfind(pname, "=", true) != (-1)) return 0;
//     else if(strfind(pname, "@", true) != (-1)) return 0;
//     else if(strfind(pname, "0", true) != (-1)) return 0;
//     else if(strfind(pname, "1", true) != (-1)) return 0;
//     else if(strfind(pname, "2", true) != (-1)) return 0;
//     else if(strfind(pname, "3", true) != (-1)) return 0;
//     else if(strfind(pname, "4", true) != (-1)) return 0;
//     else if(strfind(pname, "5", true) != (-1)) return 0;
//     else if(strfind(pname, "6", true) != (-1)) return 0;
//     else if(strfind(pname, "7", true) != (-1)) return 0;
//     else if(strfind(pname, "8", true) != (-1)) return 0;
//     else if(strfind(pname, "9", true) != (-1)) return 0;
//     else if(strfind(pname, "hack", true) != (-1)) return 0;
//     else if(strfind(pname, "fuck", true) != (-1)) return 0;
//     else if(strfind(pname, "FUCK", true) != (-1)) return 0;
//     else if(strfind(pname, "Boobies", true) != (-1)) return 0;
//     else if(strfind(pname, "Tupac_Shakur", true) != (-1)) return 0;
//     else if(strfind(pname, "Pussy", true) != (-1)) return 0;
//     else if(strfind(pname, "Rape", true) != (-1)) return 0;
//     else if(strfind(pname, "kill", true) != (-1)) return 0;
//     else if(strfind(pname, "shit", true) != (-1)) return 0;
//     else if(strfind(pname, "ass", true) != (-1)) return 0;
//     else if(strfind(pname, "Jack_Black", true) != (-1)) return 0;
//     else if(strfind(pname, "Max_Kenton", true) != (-1)) return 0;
//     else if(strfind(pname, "Will_Smith", true) != (-1)) return 0;
//     else if(strfind(pname, "Jaden_Smith", true) != (-1)) return 0;
//     else if(strfind(pname, "Megan_Fox", true) != (-1)) return 0;
//     else if(strfind(pname, "Charlie_Kenton", true) != (-1)) return 0;
//     else if(strfind(pname, "Hugh_Hefner", true) != (-1)) return 0;
//     else if(strfind(pname, "Paris_Hilton", true) != (-1)) return 0;
//     else if(strfind(pname, "Marshall_Mathers", true) != (-1)) return 0;
//     else if(strfind(pname, "Sheldon_Cooper", true) != (-1)) return 0;
//     else if(strfind(pname, "Jet_Lee", true) != (-1)) return 0;
//     else if(strfind(pname, "Jackie_Chan", true) != (-1)) return 0;
//     else if(strfind(pname, "Chuck_Norris", true) != (-1)) return 0;
//     else if(strfind(pname, "Peter_Parker", true) != (-1)) return 0;
//     else if(strfind(pname, "Spider_Man", true) != (-1)) return 0;
//     else if(strfind(pname, "Bat_Man", true) != (-1)) return 0;
//     else if(strfind(pname, "Emma_Stone", true) != (-1)) return 0;
//     else if(strfind(pname, "whore", true) != (-1)) return 0;
//     else if(strfind(pname, "Hugh_Jackman", true) != (-1)) return 0;
//     else if(strfind(pname, "Charles_Kenton", true) != (-1)) return 0;
//     else if(strfind(pname, "Harry_Potter", true) != (-1)) return 0;
//     else if(strfind(pname, "Chris_Hemsworth", true) != (-1)) return 0;
//     else if(strfind(pname, "Penis", true) != (-1)) return 0;
//     else if(strfind(pname, "_Dick", true) != (-1)) return 0;
//     else if(strfind(pname, "Vagina", true) != (-1)) return 0;
//     else if(strfind(pname, "Cock", true) != (-1)) return 0;
//     else if(strfind(pname, "Rectum", true) != (-1)) return 0;
//     else if(strfind(pname, "Sperm", true) != (-1)) return 0;
//     else if(strfind(pname, "Rektum", true) != (-1)) return 0;
//     else if(strfind(pname, "Pistol", true) != (-1)) return 0;
//     else if(strfind(pname, "AK47", true) != (-1)) return 0;
//     else if(strfind(pname, "Shotgun", true) != (-1)) return 0;
//     else if(strfind(pname, "Cum", true) != (-1)) return 0;
//     else if(strfind(pname, "Hitler", true) != (-1)) return 0;
//     else if(strfind(pname, "Jesus", true) != (-1)) return 0;
//     else if(strfind(pname, "God", true) != (-1)) return 0;
//     else if(strfind(pname, "Shotgun", true) != (-1)) return 0;
//     else if(strfind(pname, "Desert_Eagle", true) != (-1)) return 0;
//     else if(strfind(pname, "fucker", true) != (-1)) return 0;
//     else if(strfind(pname, "Retard", true) != (-1)) return 0;
//     else if(strfind(pname, "Tarded", true) != (-1)) return 0;
//     else if(strfind(pname, "fanny", true) != (-1)) return 0;
//     else if(strfind(pname, "Daniel_Hardy", true) != (-1)) return 0;
//     else if(strfind(pname, "abcdefghijklmnopqrstuvwxyz", true) != (-1)) return 0;
//     new maxname = strlen(pname), underline = 0, next_index = 0;
//     for (new i = 0; i < maxname; i++) {
//         if(pname[i] == '_') next_index = i, underline++;
//     }
//     if(underline != 1 || next_index < 2 || next_index > 24 || strlen(pname[next_index + 1]) == 0) return 0;
//     return 1;
// }

stock RoleplayNameFormat(const rpname[]) {
    new pname[MAX_PLAYER_NAME];
    format(pname, sizeof pname, "%s", rpname);
    if (strlen(pname) < 1) {
        format(pname, sizeof pname, "null");
        return pname;
    }
    new maxname = strlen(pname);
    pname[0] = toupper(pname[0]);
    for (new x = 1; x < maxname; x++) {
        if (pname[x] == '_') pname[x + 1] = toupper(pname[x + 1]);
        else if (pname[x] != '_' && pname[x - 1] != '_') pname[x] = tolower(pname[x]);
    }
    return pname;
}

stock secondsToHms(seconds, formatStyle = 0) {
    new h = floatround(seconds / 3600);
    new m = floatround(seconds % 3600 / 60);
    new s = floatround(seconds % 3600 % 60);

    new string[512];
    if (h > 0) {
        if (formatStyle == 0) format(string, sizeof string, "%d hours, %d minutes, %d seconds", h, m, s);
        else format(string, sizeof string, "%02d:%02d:%02d", h, m, s);
    } else if (m > 0) {
        if (formatStyle == 0) format(string, sizeof string, "%d minutes, %d seconds", m, s);
        else format(string, sizeof string, "%02d:%02d", m, s);
    } else {
        if (formatStyle == 0) format(string, sizeof string, "%d seconds", s);
        else format(string, sizeof string, "%02d", s);
    }
    return string;
}

stock secondsToDHM(seconds) {
    new d = floatround(seconds / 86400);
    new h = floatround(seconds % 86400 / 3600);
    new m = floatround(seconds % 3600 / 60);

    new string[512];
    if (d > 0) {
        format(string, sizeof string, "%d days, %d hours, %d minutes", d, h, m);
    } else {
        format(string, sizeof string, "%d hours, %d minutes", h, m);
    }
    return string;
}

stock SendClientMessageByName(const playerName[], const msg[]) {
    foreach(new playerid:Player) {
        if (!strcmp(playerName, GetPlayerNameEx(playerid))) return SendClientMessage(playerid, -1, msg);
    }
    return 1;
}

stock GetPlayerIDByName(const playerName[]) {
    foreach(new playerid:Player) {
        if (IsStringSame(playerName, GetPlayerNameEx(playerid))) return playerid;
    }
    return -1;
}

stock IsPlayerInRangeOfPlayer(playerid, secondplayerid, Float:range) {
    new Float:rPosPl[3];
    GetPlayerPos(secondplayerid, rPosPl[0], rPosPl[1], rPosPl[2]);
    if (IsPlayerInRangeOfPoint(playerid, range, rPosPl[0], rPosPl[1], rPosPl[2])) return 1;
    return 0;
}

stock IsPlayerInRangeOfVehicle(playerid, vehicleid, Float:range) {
    if (!IsValidVehicle(vehicleid)) return 0;
    new Float:rPosPl[3];
    GetVehiclePos(vehicleid, rPosPl[0], rPosPl[1], rPosPl[2]);
    if (IsPlayerInRangeOfPoint(playerid, range, rPosPl[0], rPosPl[1], rPosPl[2])) return 1;
    return 0;
}

stock TeleportInFront(playerid, Float:distance = 10.0) {
    new Float:xPx, Float:yPy, Float:zPz;
    GetPlayerPos(playerid, xPx, yPy, zPz);
    GetXYInFrontOfPlayer(playerid, xPx, yPy, Float:distance);
    SetPlayerPosEx(playerid, xPx, yPy, zPz);
    return 1;
}

stock GetNearestPlayer(playerid, Float:range = 5.0) {
    new nearest = INVALID_PLAYER_ID;
    foreach(new secondplayerid:Player) {
        if (secondplayerid == playerid) continue;
        if (IsPlayerInRangeOfPlayer(playerid, secondplayerid, Float:range)) {
            nearest = secondplayerid;
            break;
        }
    }
    return nearest;
}

stock offensiveWordCount(const input[]) {
    new count1 = regexMatchCount("\\b(4r5e|5h1t|5hit|a55|anal|anus|ar5e|arrse|arse|ass|ass-fucker|asses|assfucker|assfukka|asshole|assholes|asswhole|a_s_s|b!tch\
    |b00bs|b17ch|b1tch|ballbag|balls|ballsack|bastard|beastial|beastiality|bellend|bestial|bestiality|bi+ch|biatch|bitch|bitcher|bitchers|bitches|bitchin|bitching|\
    bloody|blow job|blowjob|blowjobs|boiolas|bollock|bollok|boner|boob|boobs|booobs|boooobs|booooobs|booooooobs|breasts|buceta|bugger|bum|bunny fucker|butt|butthole|\
    buttmuch|buttplug|c0ck|c0cksucker|carpet muncher|cawk|chink|cipa|cl1t|clit|clitoris|clits|cnut|cock|cock-sucker|cockface|cockhead|cockmunch|cockmuncher|cocks|\
    cocksuck|cocksucked|cocksucker|cocksucking|cocksucks|cocksuka|cocksukka|cok|cokmuncher|coksucka|coon|cox|crap|cum|cummer|cumming|cums|cumshot|cunilingus|cunillingus|\
    cunnilingus|cunt|cuntlick|cuntlicker|cuntlicking|cunts|cyalis|cyberfuc|cyberfuck|cyberfucked|cyberfucker|cyberfuckers|cyberfucking|d1ck|damn|dick|dickhead|dildo|\
    dildos|dink|dinks|dirsa|dlck|dog-fucker|doggin|dogging|donkeyribber|doosh|duche|dyke|ejaculate|ejaculated|ejaculates|ejaculating|ejaculatings|ejaculation|ejakulate|\
    f u c k|f u c k e r|f4nny|fag|fagging|faggitt|faggot|faggs|fagot|fagots|fags|fanny|fannyflaps|fannyfucker|fanyy|fatass|fcuk|fcuker|fcuking|feck|fecker|felching|\
    fellate|fellatio|fingerfuck|fingerfucked|fingerfucker|fingerfuckers|fingerfucking|fingerfucks|fistfuck|fistfucked|fistfucker|fistfuckers|fistfucking|fistfuckings|\
    fistfucks|flange|fook|fooker|fuck|fucka|fucked|fucker|fuckers|fuckhead|fuckheads|fuckin|fucking|fuckings|fuckingshitmotherfucker|fuckme|fucks|fuckwhit|fuckwit|\
    fudge packer|fudgepacker|fuk|fuker|fukker|fukkin|fuks|fukwhit|fukwit|fux|fux0r|f_u_c_k|gangbang|gangbanged|gangbangs|gaylord|gaysex|goatse|God|god-dam|\
    god-damned|goddamn|goddamned|hardcoresex|hell|heshe|hoar|hoare|hoer|homo|hore|horniest|horny|hotsex|jack-off|jackoff|jap|jerk-off|jism|jiz|jizm|jizz|kawk|knob|\
    knobead|knobed|knobend|knobhead|knobjocky|knobjokey|kock|kondum|kondums|kum|kummer|kumming|kums|kunilingus|l3i+ch|l3itch|labia|lust|lusting|m0f0|m0fo|m45terbate|\
    ma5terb8|ma5terbate|masochist|master-bate|masterb8|masterbat*|masterbat3|masterbate|masterbation|masterbations|masturbate|mo-fo|mof0|mofo|mothafuck|mothafucka|\
    mothafuckas|mothafuckaz|mothafucked|mothafucker|mothafuckers|mothafuckin|mothafucking|mothafuckings|mothafucks|mother fucker|motherfuck|motherfucked|motherfucker|\
    motherfuckers|motherfuckin|motherfucking|motherfuckings|motherfuckka|motherfucks|muff|mutha|muthafecker|muthafuckker|muther|mutherfucker|n1gga|n1gger|nazi|nigg3r|\
    nigg4h|nigga|niggah|niggas|niggaz|nigger|niggers|\nob|nob jokey|nobhead|nobjocky|nobjokey|numbnuts|nutsack|orgasim|orgasims|orgasm|orgasms|p0rn|pawn|pecker|penis|\
    penisfucker|phonesex|phuck|phuk|phuked|phuking|phukked|phukking|phuks|phuq|pigfucker|pimpis|piss|pissed|pisser|pissers|pisses|pissflaps|pissin|pissing|pissoff|\
    poop|porn|porno|pornography|pornos|prick|pricks|pron|pube|pusse|pussi|pussies|pussy|pussys|rectum|retard|rimjaw|rimming|s hit|s.o.b.|sadist|schlong|screwing|scroat|\
    scrote|scrotum|semen|sex|sh!+|sh!t|sh1t|shag|shagger|shaggin|shagging|shemale|shi+|shit|shitdick|shite|shited|shitey|shitfuck|shitfull|shithead|shiting|shitings|\
    shits|shitted|shitter|shitters|shitting|shittings|shitty|skank|slut|sluts|smegma|smut|snatch|son-of-a-bitch|spac|spunk|s_h_i_t|t1tt1e5|t1tties|teets|teez|testical|\
    testicle|tit|titfuck|tits|titt|tittie5|tittiefucker|titties|tittyfuck|tittywank|titwank|tosser|turd|tw4t|twat|twathead|twatty|twunt|twunter|v14gra|v1gra|vagina|\
    viagra|vulva|w00se|wang|wank|wanker|wanky|whoar|whore|willies|willy|xrated|xxx|bsdk|mc|bkl|gandu|mkct|tatto|aand|aandu|balatkar|beti chod|bhadva|bhadve|bhandve|\
    bhootni ke|bhosad|bhosadi ke|boobe|chakke|chinaal|chinki|chod|chodu|chodu bhagat|chooche|choochi|choot|choot ke baal|chootia|chootiya|chuche|chuchi|chudai khanaa|\
    chudan chudai|chut|chut ke baal|chut ke dhakkan)\\b", input);
    new count2 = regexMatchCount("\\b(chut maarli|chutad|chutadd|chutan|chutia|chutiya|gaand|gaandfat|gaandmasti|gaandufad|gandu|gashti|gasti|ghassa|ghasti|\
    harami|haramzade|hawas|hawas ke pujari|hijda|hijra|jhant|jhant chaatu|jhant ke baal|jhantu|kamine|kaminey|kanjar|kutta|kutta kamina|kutte ki aulad|\
    kutte ki jat|kuttiya|loda|lodu|lund|lund choos|lund khajoor|lundtopi|lundure|maa ki chut|maal|madar chod|mooh mein le|mutth|najayaz|najayaz aulaad|\
    najayaz paidaish|paki|pataka|patakha|raand|randi|saala|saala kutta|saali kutti|saali randi|suar|suar ki aulad|tatte|tatti|teri maa ka bhosada|\
    teri maa ka boba chusu|teri maa ki chut|tharak|tharki|baiser|bander|bigornette|bite|bitte|bloblos|bordel|bosser|bourré|bourrée|brackmard|branlage|\
    branler|branlette|branleur|branleuse|brouter le cresson|caca|cailler|chatte|chiasse|chier|chiottes|clito|clitoris|con|connard|connasse|conne|couilles|cramouille|\
    cul|déconne|déconner|drague|emmerdant|emmerder|emmerdeur|emmerdeuse|enculé|enculée|enculeur|enculeurs|enfoiré|enfoirée|étron|fille de pute|fils de pute|folle|\
    foutre|gerbe|gerber|gouine|grande folle|grogniasse|gueule|jouir|la putain de ta mère|MALPT|ménage à trois|merde|merdeuse|merdeux|meuf|nègre|nique ta mère|\
    nique ta race|palucher|pédale|pédé|péter|pipi|pisser|pouffiasse|pousse-crotte|putain|pute|ramoner|sac à merde|salaud|salope|suce|tapette|teuf|tringler|trique|\
    trou du cul|turlute|veuve|zigounette|zizi|randwe|rand|bhadwe|kutte|gand|fck|fuc you|lode|bad server|poor server|bhosdi|bhosdiwala|bc|betichod|battakhchod|chutiye|\
    lawda|gotiya|bencod|mia khalifa|chadarmod|ramdibazii|ramdi|bhenchod|bhomsdike|chodambazzi|chodamchadi|chodam chadi|gamdu|sunni|punda|koodhi|thayoli|daioli|\
    ommala|thevadiya|mairu)\\b", input);
    return count1 + count2;
}

stock isStringHasIP(const input[]) {
    return regexMatchCount("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", input) == 0 ? 0 : 1;
}

stock KickPlayer(playerid, seconds = 1) {
    SetTimerEx("kick", seconds * 1000, false, "d", playerid);
    return 1;
}

stock IsVehicleHasBonnet(modelid) {
    new modelIds[] = { 400, 401, 402, 403, 404, 405, 408, 409, 410, 411, 412, 413, 414, 415, 416, 418, 419, 420, 421, 422, 423, 424, 426, 427, 428, 429, 433, 436, 438, 439, 440, 442, 443, 444, 445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475, 477, 478, 479, 480, 482, 489, 490, 491, 492, 494, 495, 496, 498, 499, 500, 502, 503, 504, 505, 506, 507, 508, 514, 515, 516, 517, 518, 524, 525, 526, 527, 528, 529, 531, 533, 534, 535, 536, 540, 541, 542, 543, 545, 546, 547, 549, 550, 551, 552, 554, 555, 556, 557, 558, 559, 560, 561, 562, 565, 566, 567, 575, 576, 579, 580, 582, 585, 587, 589, 596, 597, 598, 599, 600, 602, 603, 604, 605, 609 };
    if (IsArrayContainNumber(modelIds, modelid)) return 1;
    return 0;
}

stock IsVehicleHasBoot(modelid) {
    new modelIds[] = { 400, 401, 402, 404, 405, 409, 410, 412, 415, 419, 420, 421, 426, 429, 436, 438, 439, 442, 445, 458, 466, 467, 470, 474, 475, 479, 480, 489, 490, 491, 492, 496, 504, 505, 506, 507, 516, 517, 518, 526, 527, 529, 533, 534, 536, 540, 541, 542, 545, 546, 547, 529, 550, 551, 555, 558, 559, 560, 561, 562, 565, 566, 567, 575, 576, 579, 580, 585, 587, 589, 596, 597, 598, 599, 600, 602, 603, 604 };
    if (IsArrayContainNumber(modelIds, modelid)) return 1;
    return 0;
}

stock IsVehicleBootOpened(vehicleid) {
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (boot == VEHICLE_PARAMS_ON) return 1;
    return 0;
}

stock GetVehicleShiftPos(vehicleid, style, & Float:x, & Float:y, & Float:z, Float:distance) {
    if (!IsValidVehicle(vehicleid)) return 0;
    new Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    switch (style) {
        case 0 :  {
            x += (distance * floatsin(-a, degrees));
            y += (distance * floatcos(-a, degrees));
        }
        case 1 :  {
            x -= (distance * floatsin(-a, degrees));
            y -= (distance * floatcos(-a, degrees));
        }
        case 2 :  {
            a += 90.0;
            x -= (distance * floatsin(-a, degrees));
            y -= (distance * floatcos(-a, degrees));
        }
        case 3 :  {
            a -= 90.0;
            x -= (distance * floatsin(-a, degrees));
            y -= (distance * floatcos(-a, degrees));
        }
        default:
            return 0;
    }
    return 1;
}

stock UnixToHumanEx(unix) {
    new string[50];
    UnixToHuman(unix, string);
    return string;
}

stock TotalPlayersInServer() {
    new count = 0;
    foreach(new i:Player) {
        count++;
    }
    return count;
}

stock IsValidPlayerID(playerid) {
    if (playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    return 1;
}

stock TeleportPlayer(playerid, Float:x, Float:y, Float:z, worldid, int) {
    if (!IsPlayerConnected(playerid)) return 0;
    new Float:a;
    GetPlayerFacingAngle(playerid, a);
    if (IsPlayerInAnyVehicle(playerid)) TeleportVehicleEx(GetPlayerVehicleID(playerid), x, y, z, a + 90, worldid, int);
    else {
        SetPlayerVirtualWorldID(playerid, worldid);
        SetPlayerInteriorID(playerid, int);
        SetPlayerPosEx(playerid, x, y, z);
    }
    return 1;
}

stock IsPlayerInServerByName(const username[]) {
    foreach(new playerid:Player) {
        if (!strcmp(GetPlayerNameEx(playerid), username)) return 1;
    }
    return 0;
}

stock Float:RectRandomFloat(Float:min, Float:max, accuracy = 4) {
    if (min >= max) return 0.0;
    if (min < 0.0 || max < 0.0) return 0.0;
    if (accuracy < 1 || accuracy > 6) accuracy = 4;
    new divValue = floatround(floatpower(10.0, accuracy));
    return random(floatround(max) - floatround(min)) + min + (random(divValue) / divValue);
}

stock Float:DistanceBetweenPlayers(player1, player2) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(player2, x, y, z);
    return GetPlayerDistanceFromPoint(player1, x, y, z);
}

stock RandomPointInRectangle(Float:minx, Float:miny, Float:maxx, Float:maxy, & Float:tx, & Float:ty) {
    tx = RectRandomFloat(0.0, floatsqroot(floatpower(minx - maxx, 2)), 6) + minx;
    ty = RectRandomFloat(0.0, floatsqroot(floatpower(miny - maxy, 2)), 6) + miny;
    return 1;
}

stock GetXYOnAnglePlayer(playerid, & Float:x, & Float:y, Float:distance, Float:angle) {
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    x += (distance * floatsin(-a + angle, degrees));
    y += (distance * floatcos(-a + angle, degrees));
    return 1;
}

stock GetXYOnAngleVehicle(vehicleid, & Float:x, & Float:y, Float:distance, Float:angle) {
    new Float:a;
    GetVehiclePos(vehicleid, x, y, a);
    GetVehicleZAngle(vehicleid, a);
    x += (distance * floatsin(-a + angle, degrees));
    y += (distance * floatcos(-a + angle, degrees));
    return 1;
}


stock GetXYOnAngleOfPos( & Float:x, & Float:y, & Float:currentangle, Float:nextposangle, Float:distance) {
    x += (distance * floatsin(-currentangle + nextposangle, degrees));
    y += (distance * floatcos(-currentangle + nextposangle, degrees));
    return 1;
}

stock GetXYInFrontOfPlayer(playerid, & Float:x, & Float:y, Float:distance) {
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
    return 1;
}

stock GetXYInBackOfPlayer(playerid, & Float:x, & Float:y, Float:distance) {
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid)) GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    x -= (distance * floatsin(-a, degrees));
    y -= (distance * floatcos(-a, degrees));
    return 1;
}

stock GetXYInFrontOfVehicle(vehicleid, & Float:x, & Float:y, Float:distance) {
    new Float:a;
    GetVehiclePos(vehicleid, x, y, a);
    GetVehicleZAngle(vehicleid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
    return 1;
}

stock GetXYInBackOfVehicle(vehicleid, & Float:x, & Float:y, Float:distance) {
    new Float:a;
    GetVehiclePos(vehicleid, x, y, a);
    GetVehicleZAngle(vehicleid, a);
    x -= (distance * floatsin(-a, degrees));
    y -= (distance * floatcos(-a, degrees));
    return 1;
}

stock SetCameraVehicleAngle(playerid, vehicleid, Float:distance, Float:angle, Float:zoffset) {
    if (!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid)) return 1;
    new Float:pos[5];
    GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
    GetXYOnAngleVehicle(vehicleid, pos[3], pos[4], distance, angle);
    SetPlayerCameraPos(playerid, pos[3], pos[4], pos[2] + zoffset);
    SetPlayerCameraLookAt(playerid, pos[0], pos[1], pos[2], CAMERA_MOVE);
    return 1;
}

// Epsilon (a very small number)
#if !defined EPSILON
    #define  EPSILON 0.0001
#endif

#define IsFloatZero%1(%0)   ((EPSILON >= (%0)) && ((-EPSILON) <= (%0)))
#define IsFloatNaN%1(%0)   ((%0) != (%0))
#define IsNullVector2%2(%0,%1) (IsFloatZero(%0) && IsFloatZero(%1))

/*
 * Safer version, also for packed strings.
 */
// stock IsNull(const string[]) {
//     if (string[0] > 255)
//         return string { 0 } == '\0' || (string[0] & 0xFFFF0000) == 0x01000000;
//     else
//         return string[0] == '\0' || string[0] == '\1' && string[1] == '\0';
// }
// 
// stock IsFloatNan(Float:number) {
//     return (number != number) || !(number <= 0.0 || number > 0.0);
// }

// Vector (2D) structure
enum EVector2 {
    Float:EVector2_x, // X
    Float:EVector2_y // Y
}

// Vector (3D) structure
enum EVector3 {
    Float:EVector3_x, // X
    Float:EVector3_y, // Y
    Float:EVector3_z // Z
}

stock NormalizeVector2(Float:x, Float:y, & Float:resultX, & Float:resultY) {
    if (IsNullVector2(x, y)) {
        resultX = 0.0;
        resultY = 0.0;
    } else {
        new Float:mag = floatsqroot((x * x) + (y * y));
        resultX = x / mag;
        resultY = y / mag;
    }
    return 1;
}

stock Float:Wrap(Float:x, Float:min, Float:max) {
    new Float:ret = x, Float:delta = max - min;
    if (delta > 0.0) {
        while (ret < min) ret += delta;
        while (ret > max) ret -= delta;
    } else if (delta <= 0.0) {
        ret = min;
    }
    return x;
}

stock RotationToForwardVector(Float:angle, & Float:x, & Float:y) {
    // GTA rotation to radians
    //new Float:phi = ((360.0 - Wrap(angle, 0.0, 360.0)) * 3.14159265) / 180.0;
    new Float:phi = (Wrap(angle, 0.0, 360.0) * 3.14159265) / 180.0;
    x = floatcos(phi) - floatsin(phi);
    y = floatsin(phi) + floatcos(phi);
    return 1;
}

stock IsVehicleDrivingBackwards(vehicleid) {
    new ret = false;
    if (IsValidVehicle(vehicleid)) {
        new v1[EVector3], v2[EVector2], v3[EVector2], Float:rot;
        GetVehicleVelocity(vehicleid, v1[EVector3_x], v1[EVector3_y], v1[EVector3_z]);
        NormalizeVector2(v1[EVector3_x], v1[EVector3_y], v1[EVector3_x], v1[EVector3_y]);
        GetVehicleZAngle(vehicleid, rot);
        RotationToForwardVector(rot, v2[EVector2_x], v2[EVector2_y]);
        v3[EVector2_x] = v1[EVector3_x] + v2[EVector2_x];
        v3[EVector2_y] = v1[EVector3_y] + v2[EVector2_y];
        ret = (((v3[EVector2_x] * v3[EVector2_x]) + (v3[EVector2_y] * v3[EVector2_y])) < 2.0);
    }
    return ret;
}

stock SendClientMessageToMafia(const message[]) {
    new allowedFaction[] = { 5, 10 };
    foreach(new playerid: Player) {
        if (IsArrayContainNumber(allowedFaction, Faction:GetPlayerFID(playerid))) {
            SendClientMessage(playerid, -1, message);
        }
    }
    return 1;
}

stock DestroyDynamicObjectEx(objectid) {
    return DestroyDynamicObject(objectid);
}