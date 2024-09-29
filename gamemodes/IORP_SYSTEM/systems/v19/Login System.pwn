new DIALOG_LOGIN_REG_SYS;
enum {
    DIALOG_PLAYER_STATS = 0, DIALOG_REGISTER, DIALOG_LOGIN, Dialog_Skin_Chnage_ID,
        DIALOG_RPNAME, DIALOG_UPDATE_RPNAME, DIALOG_UPDATE_RPNAME_Confirm
};
#define MAX_COUNTRY_NAME (200)
#define MAX_ZIP_LENGTH  (15)
#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney
new Corrupt_Check[MAX_PLAYERS];
enum ENUM_PLAYER_DATA {
    ID,
    Username[MAX_PLAYER_NAME],
    email[150],
    Password[65],
    Salt[11],
    Kills,
    Deaths,
    PlayedTime, //played time in seconds and also score
    PauseTime,
    Cash, // player Cash
    LastHealth, // player health
    LastArmour, // player armour
    AutoSpawn,
    adminLevel, // admin level
    VIPLevel, // VIP level
    WantedLevel, // player WantedLevel level
    Float:LastPosX, // last x position of player
    Float:LastPosY, // last y position of player
    Float:LastPosZ, // last z position of player
    Float:LastPosAngle, // last facing angle of player
    InteriorID, // interior ID of player
    VirtualWorldID, // Virtual World ID of player
    bool:AcStatus, // MasterAdmin
    bantime,
    bool:MasterAdmin, // MasterAdmin

    loginAt,
    lastlogin,

    PasswordFails,
    Cache:Player_Cache,
    bool:LoginStatus,
    bool:SpawnStatus,
    bool:DeathStatus,
    UpdateTimerID,
    ScoreTimerID,

    bool:muted,

    e_LookupIP[MAX_COUNTRY_NAME],
    e_LookupLoc[MAX_COUNTRY_NAME],
    e_LookupCountry[MAX_COUNTRY_NAME],
    e_LookupRegion[MAX_COUNTRY_NAME],
    e_LookupCity[MAX_COUNTRY_NAME],
    e_LookupISP[MAX_COUNTRY_NAME],
    e_LookupTimezone[MAX_COUNTRY_NAME],
    e_LookupZipcode[MAX_COUNTRY_NAME],
}

new pInfo[MAX_PLAYERS][ENUM_PLAYER_DATA];

stock GetPlayerLastLogin(playerid) {
    return pInfo[playerid][lastlogin];
}

stock GetLoginTime(playerid) {
    return pInfo[playerid][loginAt];
}

stock GetPlayerID(playerid) {
    return pInfo[playerid][ID];
}
stock SetPlayerID(playerid, data) {
    pInfo[playerid][ID] = data;
    return 1;
}
stock GetPlayerUsername(playerid) {
    new string[MAX_PLAYER_NAME];
    format(string, sizeof string, "%s", pInfo[playerid][Username]);
    return string;
}
stock SetPlayerUsername(playerid, const name[MAX_PLAYER_NAME]) {
    pInfo[playerid][Username] = name;
    return 1;
}
stock GetPlayerPassword(playerid) {
    new string[65];
    format(string, sizeof string, "%s", pInfo[playerid][Password]);
    return string;
}
stock SetPlayerPassword(playerid, const data[65]) {
    pInfo[playerid][Password] = data;
    return 1;
}
stock GetPlayerSalt(playerid) {
    new string[11];
    format(string, sizeof string, "%s", pInfo[playerid][Salt]);
    return string;
}
stock SetPlayerSalt(playerid, const data[11]) {
    pInfo[playerid][Salt] = data;
    return 1;
}
stock GetPlayerKills(playerid) {
    return pInfo[playerid][Kills];
}
stock SetPlayerKills(playerid, data) {
    pInfo[playerid][Kills] = data;
    return 1;
}
stock GetPlayerDeaths(playerid) {
    return pInfo[playerid][Deaths];
}
stock SetPlayerDeaths(playerid, data) {
    pInfo[playerid][Deaths] = data;
    return 1;
}
stock GetPlayerPlayedTime(playerid) {
    return pInfo[playerid][PlayedTime];
}
stock SetPlayerPlayedTime(playerid, data) {
    pInfo[playerid][PlayedTime] = data;
    return 1;
}
stock GetPlayerPauseTime(playerid) {
    return pInfo[playerid][PauseTime];
}
stock SetPlayerPauseTime(playerid, data) {
    pInfo[playerid][PauseTime] = data;
    return 1;
}
forward GetPlayerCash(playerid);
public GetPlayerCash(playerid) {
    return pInfo[playerid][Cash];
}

stock GivePlayerCash(playerid, money, const log[], alertDiscord = 1) {
    // Alert Price 999,999
    if ((money > 299999 || money < -299999) && alertDiscord) {
        Discord:LogTransaction(
            sprintf(
                ":moneybag:** Transaction Alert** :moneybag:\n**Player:** %s [%d]\n**Amount:** $%s\n**Log:** %s\n\n<@&597292999227211777>",
                GetPlayerNameEx(playerid), playerid, FormatCurrency(money), log
            )
        );
    }
    pInfo[playerid][Cash] += money;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid, pInfo[playerid][Cash]);
    AddMoneyLog(playerid, money, log);
    return pInfo[playerid][Cash];
}
forward SetPlayerCash(playerid, money);
public SetPlayerCash(playerid, money) {
    pInfo[playerid][Cash] = money;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid, pInfo[playerid][Cash]);
    return pInfo[playerid][Cash];
}
forward ResetPlayerCash(playerid);
public ResetPlayerCash(playerid) {
    pInfo[playerid][Cash] = 0;
    ResetMoneyBar(playerid);
    UpdateMoneyBar(playerid, pInfo[playerid][Cash]);
    return pInfo[playerid][Cash];
}
forward GetPlayerLastHealth(playerid);
public GetPlayerLastHealth(playerid) {
    return pInfo[playerid][LastHealth];
}
forward SetPlayerLastHealth(playerid, data);
public SetPlayerLastHealth(playerid, data) {
    pInfo[playerid][LastHealth] = data;
    return 1;
}
forward GetPlayerLastArmour(playerid);
public GetPlayerLastArmour(playerid) {
    return pInfo[playerid][LastArmour];
}
forward SetPlayerLastArmour(playerid, data);
public SetPlayerLastArmour(playerid, data) {
    pInfo[playerid][LastArmour] = data;
    return 1;
}
forward GetPlayerAutoSpawn(playerid);
public GetPlayerAutoSpawn(playerid) {
    return pInfo[playerid][AutoSpawn];
}
forward SetPlayerAutoSpawn(playerid, data);
public SetPlayerAutoSpawn(playerid, data) {
    pInfo[playerid][AutoSpawn] = data;
    return 1;
}
forward GetPlayerAdminLevel(playerid);
public GetPlayerAdminLevel(playerid) {
    return pInfo[playerid][adminLevel];
}
forward SetPlayerAdminLevel(playerid, data);
public SetPlayerAdminLevel(playerid, data) {
    pInfo[playerid][adminLevel] = data;
    return 1;
}
forward GetPlayerVIPLevel(playerid);
public GetPlayerVIPLevel(playerid) {
    return pInfo[playerid][VIPLevel];
}
forward SetPlayerVIPLevel(playerid, data);
public SetPlayerVIPLevel(playerid, data) {
    pInfo[playerid][VIPLevel] = data;
    return 1;
}
forward GetPlayerWantedLevelEx(playerid);
public GetPlayerWantedLevelEx(playerid) {
    return pInfo[playerid][WantedLevel];
}
forward SetPlayerWantedLevelEx(playerid, data);
public SetPlayerWantedLevelEx(playerid, data) {
    pInfo[playerid][WantedLevel] = data;
    return 1;
}
stock Float:GetPlayerLastPosX(playerid) {
    new Float:data;
    data = pInfo[playerid][LastPosX];
    return data;
}
stock SetPlayerLastPosX(playerid, Float:data) {
    pInfo[playerid][LastPosX] = data;
    return 1;
}
stock Float:GetPlayerLastPosY(playerid) {
    new Float:data;
    data = pInfo[playerid][LastPosY];
    return data;
}
stock SetPlayerLastPosY(playerid, Float:data) {
    pInfo[playerid][LastPosY] = data;
    return 1;
}
stock Float:GetPlayerLastPosZ(playerid) {
    new Float:data;
    data = pInfo[playerid][LastPosZ];
    return data;
}
stock SetPlayerLastPosZ(playerid, Float:data) {
    pInfo[playerid][LastPosZ] = data;
    return 1;
}
stock Float:GetPlayerLastPosAngle(playerid) {
    new Float:data;
    data = pInfo[playerid][LastPosAngle];
    return data;
}
stock SetPlayerLastPosAngle(playerid, Float:data) {
    pInfo[playerid][LastPosAngle] = data;
    return 1;
}
forward GetPlayerInteriorID(playerid);
public GetPlayerInteriorID(playerid) {
    return pInfo[playerid][InteriorID];
}
forward SetPlayerInteriorID(playerid, data);
public SetPlayerInteriorID(playerid, data) {
    pInfo[playerid][InteriorID] = data;
    return 1;
}
forward GetPlayerVirtualWorldID(playerid);
public GetPlayerVirtualWorldID(playerid) {
    return pInfo[playerid][VirtualWorldID];
}
forward SetPlayerVirtualWorldID(playerid, data);
public SetPlayerVirtualWorldID(playerid, data) {
    pInfo[playerid][VirtualWorldID] = data;
    return 1;
}
forward IsPlayerMasterAdmin(playerid);
public IsPlayerMasterAdmin(playerid) {
    return pInfo[playerid][MasterAdmin];
}
forward SetPlayerMasterAdmin(playerid, bool:data);
public SetPlayerMasterAdmin(playerid, bool:data) {
    pInfo[playerid][MasterAdmin] = data;
    return 1;
}
forward IsPlayerAccountDisabled(playerid);
public IsPlayerAccountDisabled(playerid) {
    return !pInfo[playerid][AcStatus];
}
stock IsPlayerBanned(playerid) {
    return gettime() < pInfo[playerid][bantime] ? 1 : 0;
}
forward SetPlayerBanStatus(playerid, bool:data);
public SetPlayerBanStatus(playerid, bool:data) {
    pInfo[playerid][AcStatus] = data;
    return 1;
}
stock GetPlayerPasswordFails(playerid) {
    return pInfo[playerid][PasswordFails];
}
stock SetPlayerPasswordFails(playerid, data) {
    pInfo[playerid][PasswordFails] = data;
    return 1;
}
stock Cache:GetPlayerPlayer_Cache(playerid) {
    return pInfo[playerid][Player_Cache];
}
stock SetPlayerPlayer_Cache(playerid, Cache:data) {
    pInfo[playerid][Player_Cache] = data;
    return 1;
}
stock IsPlayerLoggedIn(playerid) {
    return GetPlayerLoginStatus(playerid);
}
stock GetPlayerLoginStatus(playerid) {
    return pInfo[playerid][LoginStatus];
}
stock SetPlayerLoginStatus(playerid, bool:data) {
    pInfo[playerid][LoginStatus] = data;
    return 1;
}
stock GetPlayerSpawnStatus(playerid) {
    return pInfo[playerid][SpawnStatus];
}
stock SetPlayerSpawnStatus(playerid, bool:data) {
    pInfo[playerid][SpawnStatus] = data;
    return 1;
}
stock GetPlayerDeathStatus(playerid) {
    return pInfo[playerid][DeathStatus];
}
stock SetPlayerDeathStatus(playerid, bool:data) {
    pInfo[playerid][DeathStatus] = data;
    return 1;
}
stock GetPlayerUpdateTimerID(playerid) {
    return pInfo[playerid][UpdateTimerID];
}
stock SetPlayerUpdateTimerID(playerid, data) {
    pInfo[playerid][UpdateTimerID] = data;
    return 1;
}
stock GetPlayerScoreTimerID(playerid) {
    return pInfo[playerid][ScoreTimerID];
}
stock SetPlayerScoreTimerID(playerid, data) {
    pInfo[playerid][ScoreTimerID] = data;
    return 1;
}

stock GetAdminsCount(level = 1) {
    new count = 0;
    foreach(new i:Player) {
        if (GetPlayerAdminLevel(i) >= level) count++;
    }
    return count;
}

stock LoginLog(playerid) {
    mysql_tquery(Database, sprintf(
        "INSERT INTO `loginLogs` set Username =\"%s\", ip = \"%s\", timestamp = %d, playedTime = (select playedTime from players where username = \"%s\")",
        GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), gettime(), GetPlayerNameEx(playerid)
    ));
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "lastlogin", "int", "0");
    Database:AddColumn("playerdata", "lastloginip", "text", "0.0.0.0");
    Database:AddColumn("playerdata", "autologin", "boolean", "0");
    Database:AddColumn("playerdata", "isMuted", "boolean", "0");
    DIALOG_LOGIN_REG_SYS = Dialog:GetFreeID();
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `loginLogs` (`Username` varchar(100) NOT NULL,`ip` varchar(100) NOT NULL, `timestamp` bigint NOT NULL)");
    new query[1024];
    strcat(query, "CREATE TABLE IF NOT EXISTS `players` (`ID` int(11) NOT NULL AUTO_INCREMENT,`Username` varchar(24) NOT NULL,`Password` char(65) NOT NULL,`Salt` char(11) NOT NULL,`PlayedTime` int(11),`PauseTime` int(11), `Kills` mediumint(7),");
    strcat(query, "`Cash` int(11) NOT NULL DEFAULT '0',`Deaths` mediumint(7) NOT NULL DEFAULT '0',`LastHealth` float NOT NULL DEFAULT '100',`LastArmour` float NOT NULL DEFAULT '0', `AutoSpawn` int(11), `adminLevel` mediumint(7) NOT NULL DEFAULT '0',`VIPLevel` mediumint(7) NOT NULL DEFAULT '0',");
    strcat(query, "`WantedLevel` mediumint(7) NOT NULL DEFAULT '0',`LastPosX` float NOT NULL DEFAULT '2035.2452',`LastPosY` float NOT NULL DEFAULT '-1413.6796',`LastPosZ` float NOT NULL DEFAULT '16.9922',`LastPosAngle` float NOT NULL DEFAULT '132.8350',");
    strcat(query, "`InteriorID` int(11) NOT NULL DEFAULT '0', `VirtualWorldID` int(11) NOT NULL DEFAULT '0', `Status` TINYINT NOT NULL DEFAULT true, `MasterAdmin` TINYINT NOT NULL DEFAULT false, PRIMARY KEY (`ID`), UNIQUE KEY `Username` (`Username`))");
    mysql_tquery(Database, query);
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:Player) if (IsPlayerConnected(i)) OnPlayerDisconnect(i, 1); // We do that so players wouldn't lose their data upon server's close.
    return 1;
}

forward UpdatePlayerDB(playerid);
public UpdatePlayerDB(playerid) {
    new DB_Query[512];
    format(
        DB_Query, sizeof DB_Query,
        "UPDATE `players` SET `PlayedTime` = %d, `PauseTime` = %d, `Cash` = %d, `Kills` = %d, \
        `Deaths` = %d, `LastHealth` = %d, `LastArmour` = %d, `WantedLevel` = %d, `LastPosX` = %f, \
        `LastPosY` = %f, `LastPosZ` = %f, `LastPosAngle` = %f, `InteriorID` = %d, \
        `VirtualWorldID` = %d WHERE `Username` = \"%s\" LIMIT 1",
        GetPlayerPlayedTime(playerid), GetPlayerPauseTime(playerid), GetPlayerCash(playerid),
        GetPlayerKills(playerid), GetPlayerDeaths(playerid), GetPlayerLastHealth(playerid),
        GetPlayerLastArmour(playerid), GetPlayerWantedLevelEx(playerid), GetPlayerLastPosX(playerid),
        GetPlayerLastPosY(playerid), GetPlayerLastPosZ(playerid),
        IsFloatNaN(GetPlayerLastPosAngle(playerid)) ? 0.0 : GetPlayerLastPosAngle(playerid),
        GetPlayerInteriorID(playerid), GetPlayerVirtualWorldID(playerid), GetPlayerNameEx(playerid)
    );
    mysql_tquery(Database, DB_Query);
    return 1;
}

forward OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check) {
    if (!IsPlayerConnected(playerid)) return 1;
    SetPlayerCameraPos(playerid, -894.3903, 727.4850, 53.2132);
    SetPlayerCameraLookAt(playerid, -895.3705, 727.6779, 53.1930, CAMERA_CUT);
    if (corrupt_check != Corrupt_Check[playerid]) return Kick(playerid);
    //if(corrupt_check != Corrupt_Check[playerid] || IsIpOfNoneAdminConnected(playerid)) return Kick(playerid);

    if (cache_num_rows() > 0) {
        new username[MAX_PLAYER_NAME];
        cache_get_value(0, "username", username, MAX_PLAYER_NAME);

        if (!IsStringSame(username, GetPlayerNameEx(playerid))) {
            ShowPlayerDialog(
                playerid, 999,
                DIALOG_STYLE_MSGBOX,
                "Invalid Username",
                sprintf("please login with: %s\nInstead of: %s", username, GetPlayerNameEx(playerid)),
                "Okay", ""
            );
            AlexaMsg(playerid, "Invalid username");
            AlexaMsg(playerid, sprintf("login with: %s", username));
            AlexaMsg(playerid, sprintf("instead of: %s", GetPlayerNameEx(playerid)));
            KickPlayer(playerid);
            return 1;
        }

        cache_get_value(0, "email", pInfo[playerid][email], 150);
        cache_get_value(0, "password", pInfo[playerid][Password], 65);
        cache_get_value(0, "salt", pInfo[playerid][Salt], 11);
        cache_get_value_name_bool(0, "status", pInfo[playerid][AcStatus]);
        cache_get_value_name_int(0, "bantime", pInfo[playerid][bantime]);
        new disablereason[100];
        cache_get_value(0, "disablereason", disablereason, 100);

        SetPlayerPlayer_Cache(playerid, cache_save());

        if (IsPlayerAccountDisabled(playerid)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} Your account has been deactivated, More information can be obtained from the IORP Administrators.");
            SendClientMessageEx(playerid, 0xFF0000FF, sprintf("Reason:{FFCC66} %s", disablereason));
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} Requests for reactivation of your account can be made at forum.iorp.in.");
            KickPlayer(playerid);
            return 1;
        } else if (IsPlayerBanned(playerid)) {
            new banreason[100];
            cache_get_value(0, "banreason", banreason, sizeof banreason);
            AlexaMsg(playerid, sprintf("You're banned from logging in until %s", UnixToHumanEx(pInfo[playerid][bantime])));
            SendClientMessageEx(playerid, -1, sprintf("{4286f4}Ban Reason:{FFCC66} %s.", banreason));
            AlexaMsg(playerid, "For an early unban, please submit a request on forum.iorp.in");
            KickPlayer(playerid, 1);
            return 1;
        } else if (Database:GetBool(GetPlayerNameEx(playerid), "username", "autologin")) {
            if (IsStringSame(GetPlayerIpEx(playerid), Database:GetString(GetPlayerNameEx(playerid), "username", "lastloginip"))) {
                AlexaMsg(playerid, "Congratulations! You have successfully logged in automatically.");
                AlexaMsg(playerid, "Initializing your account details. please wait..");
                SetTimerEx("ApproveLogin", 5 * 1000, false, "d", playerid);
                return 1;
            } else {
                AlexaMsg(playerid, "Attempt to log in automatically failed due to a new IP address.");
            }
        }
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof pname);
        SetPlayerName(playerid, "IORP_NEW_NAME");
        SetPlayerName(playerid, RoleplayNameFormat(pname));
        LoginMenu(playerid);
    } else {
        // SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}There is no registration with IORP Network for this account. Please register at iorp.in to proceed.");
        // SetTimerEx("kick", 1000, false, "d", playerid);
        Registration_Menu(playerid);
    }
    return 1;
}

forward UpdateRPName_Menu(playerid);
public UpdateRPName_Menu(playerid) {
    new String[1024];
    strcat(String, sprintf("Welcome %s.\n\n", GetPlayerNameEx(playerid)));
    strcat(String, "{0099FF}INFO:Please, follow this process carefully.\n");
    strcat(String, "{0099FF}INFO:Your name is not acceptable.\n");
    strcat(String, "{0099FF}INFO:It is mandatory to update your name to a roleplay name.\n");
    strcat(String, "{0099FF}INFO:If you cancel this update, you will be logged out of the server.\n");
    strcat(String, "{0099FF}INFO:After updating your name, you will be logged out of the server.\n");
    strcat(String, "{0099FF}INFO:After updating your name, login with new name.\n");
    strcat(String, "{0099FF}Hint:Your name must be in the format Firstname_Lastname.\n");
    strcat(String, "{0099FF}Please, Enter suitable roleplay name below to proceed to the game.\n\n");
    ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_UPDATE_RPNAME, DIALOG_STYLE_INPUT, "Login System", String, "Update", "");
    return 1;
}

forward UpdateRPName_Confirm(const OldName[], const NewName[]);
public UpdateRPName_Confirm(const OldName[], const NewName[]) {
    AccountRename(OldName, NewName);
    return 1;
}

stock RPName_Menu(playerid) {
    new String[512];
    strcat(String, sprintf("Welcome %s.\n\n", GetPlayerNameEx(playerid)));
    strcat(String, "{0099FF}INFO:Your name is not acceptable.\n");
    strcat(String, "{0099FF}Hint:Your name must be in the format Firstname_Lastname.\n");
    strcat(String, "{0099FF}Please, Enter suitable roleplay name below to proceed to the game.\n\n");
    ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_RPNAME, DIALOG_STYLE_INPUT, "Registration System", String, "Rename", "");
    return 1;
}

stock LoginMenu(playerid) {
    new String[512];
    strcat(String, sprintf("Welcome back, %s.\n\n", GetPlayerNameEx(playerid)));
    strcat(String, "{0099FF}This account is already registered.\n");
    strcat(String, "{0099FF}Please, input your Password below to proceed to the game.\n\n");
    ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login System", String, "Login", "Leave");
    return 1;
}

stock Registration_Menu(playerid) {
    new String[512];
    strcat(String, sprintf("{FFFFFF}Welcome %s.\n\n", GetPlayerNameEx(playerid)));
    strcat(String, "{0099FF}This account is not registered.\n");
    strcat(String, "{0099FF}Please, input your Password below to proceed to the game.\n\n");
    ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration System", String, "Register", "Leave");
    return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid) {
    pInfo[playerid][loginAt] = gettime();
    StopAudioStreamForPlayer(playerid);
    SetPlayerCash(playerid, GetPlayerCash(playerid));
    new pLastHealth = GetPlayerLastHealth(playerid);
    if (pLastHealth < 5) pLastHealth = 5;
    SetPlayerHealthEx(playerid, pLastHealth);
    SetPlayerArmourEx(playerid, GetPlayerLastArmour(playerid));
    SetPlayerScoreTimerID(playerid, SetTimerEx("scoresystem", 1000, true, "i", playerid));
    SetPlayerUpdateTimerID(playerid, SetTimerEx("UpdatePlayerDB", 10000, true, "i", playerid));
    SetPlayerColor(playerid, Player_Color);
    // SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}IORP wish you {FFFFFF}Happy {f4353d}73rd {76e460}Independce day{FFCC66}!");
    UpdateIpData(playerid);
    //    if(!GetPlayerDeathStatus(playerid) && GetPlayerAutoSpawn(playerid) != -1) {
    //        SetSpawnInfo(playerid, GetPlayerTeam(playerid), GetPlayerAutoSpawn(playerid), GetPlayerLastPosX(playerid), GetPlayerLastPosY(playerid), GetPlayerLastPosZ(playerid), GetPlayerLastPosAngle(playerid), -1, -1, -1, -1, -1, -1);
    //        SetPlayerVirtualWorldEx(playerid, GetPlayerVirtualWorldID(playerid));
    //        SetPlayerInteriorEx(playerid, GetPlayerInteriorID(playerid));
    //        SpawnPlayer(playerid);
    //    }
    // if(!RoleplayNameCheck(GetPlayerNameEx(playerid))) SetTimerEx("UpdateRPName_Menu", 60 * 1000, false, "d", playerid);
    Database:UpdateString(GetPlayerIpEx(playerid), GetPlayerNameEx(playerid), "username", "lastloginip");
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "lastlogin");
    LoginLog(playerid);
    pInfo[playerid][muted] = Database:GetBool(GetPlayerNameEx(playerid), "username", "isMuted");
    return 1;
}

stock UpdateIpData(playerid) {
    strpack(pInfo[playerid][e_LookupIP], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupLoc], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupCountry], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupRegion], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupCity], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupISP], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupTimezone], "Unknown", MAX_COUNTRY_NAME char);
    strpack(pInfo[playerid][e_LookupZipcode], "Unknown", MAX_COUNTRY_NAME char);
    IpInfo(playerid, GetPlayerIpEx(playerid), "0e9b053b179162", 111);
    return 1;
}

hook OnIpInfoResponse(playerid, const ip[], const loc[], const country[], const region[], const city[], const org[], const timezone[], const postal[], offset) {
    if (offset != 111) return 1;
    format(pInfo[playerid][e_LookupIP], MAX_COUNTRY_NAME, "%s", ip);
    format(pInfo[playerid][e_LookupLoc], MAX_COUNTRY_NAME, "%s", loc);
    format(pInfo[playerid][e_LookupCountry], MAX_COUNTRY_NAME, "%s", country);
    format(pInfo[playerid][e_LookupRegion], MAX_COUNTRY_NAME, "%s", region);
    format(pInfo[playerid][e_LookupCity], MAX_COUNTRY_NAME, "%s", city);
    format(pInfo[playerid][e_LookupISP], MAX_COUNTRY_NAME, "%s", org);
    format(pInfo[playerid][e_LookupTimezone], MAX_COUNTRY_NAME, "%s", timezone);
    format(pInfo[playerid][e_LookupZipcode], MAX_COUNTRY_NAME, "%s", postal);
    return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid) {
    for (new i = 0; i < 50; i++) SendClientMessageEx(playerid, -1, "");
    SetPlayerLoginStatus(playerid, true);
    SetPlayerLastPosX(playerid, 2035.25);
    SetPlayerLastPosY(playerid, -1413.68);
    SetPlayerLastPosZ(playerid, 16.9922);
    SetPlayerLastPosAngle(playerid, 132.835);
    SetPlayerHealthEx(playerid, 100);
    SetPlayerArmourEx(playerid, 100);
    beforeLoginApprove(playerid);
    CallRemoteFunction("OnPlayerLogin", "i", playerid);
    return 1;
}

hook OnPlayerConnect(playerid) {
    Connect_Login_Init(playerid);
    SetPlayerKilledBy(playerid, -1);
    return 1;
}

stock Connect_Login_Init(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    ///=== Resetting player information ===///
    pInfo[playerid][loginAt] = gettime();
    format(pInfo[playerid][email], 150, "indianoceanroleplay@gmail.com");
    SetPlayerID(playerid, -1);
    SetPlayerAdminLevel(playerid, 0);
    SetPlayerVIPLevel(playerid, 0);
    SetPlayerWantedLevelEx(playerid, 0);
    SetPlayerKills(playerid, 0);
    SetPlayerDeaths(playerid, 0);
    SetPlayerPasswordFails(playerid, 0);
    SetPlayerCash(playerid, 0);
    SetPlayerLastHealth(playerid, 100);
    SetPlayerLastArmour(playerid, 100);
    SetPlayerPlayedTime(playerid, 0);
    SetPlayerPauseTime(playerid, 0);
    SetPlayerAutoSpawn(playerid, 0);
    SetPlayerLastPosX(playerid, 1774.8698);
    SetPlayerLastPosY(playerid, -1665.1129);
    SetPlayerLastPosZ(playerid, 14.2167);
    SetPlayerLastPosAngle(playerid, 336.2490);
    SetPlayerLoginStatus(playerid, false);
    SetPlayerSpawnStatus(playerid, false);
    SetPlayerDeathStatus(playerid, false);
    SetPlayerMasterAdmin(playerid, false);
    SetPlayerBanStatus(playerid, false);
    // PlayAudioStreamForPlayer(playerid, "https://iorp.in/music/oxv21RJItP0");
    for (new i = 0; i < 50; i++) SendClientMessageEx(playerid, -1, "");
    SetTimerEx("OnPlayerLoginCheck", 5 * 60 * 1000, false, "i", playerid);

    ///=== Initialising Player Login information ===///
    new DB_Query[115];
    SetPlayerUsername(playerid, GetPlayerNameEx(playerid));
    Corrupt_Check[playerid]++;
    mysql_format(Database, DB_Query, sizeof(DB_Query), "SELECT * FROM `players` WHERE `Username` = \"%s\" LIMIT 1", GetPlayerUsername(playerid));
    mysql_tquery(Database, DB_Query, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);
    pInfo[playerid][lastlogin] = Database:GetInt(GetPlayerNameEx(playerid), "username", "lastlogin");
    return 1;
}

forward OnPlayerLoginCheck(playerid);
public OnPlayerLoginCheck(playerid) {
    if (!IsPlayerLoggedIn(playerid)) Kick(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    Corrupt_Check[playerid]++;
    if (IsPlayerLoggedIn(playerid)) UpdatePlayerDB(playerid);
    if (cache_is_valid(GetPlayerPlayer_Cache(playerid))) cache_delete(GetPlayerPlayer_Cache(playerid)), SetPlayerPlayer_Cache(playerid, MYSQL_INVALID_CACHE);
    KillTimer(GetPlayerUpdateTimerID(playerid));
    if (!IsPlayerLoggedIn(playerid)) return 1;
    if (reason == 0) SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFCC66} %s{FFFFEE} left. {ff9966}Possible Reason:{FFFFEE} Connection Lost or Game Crash", GetPlayerNameEx(playerid)));
    if (reason == 1) SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFCC66} %s{FFFFEE} left. {ff9966}Possible Reason:{FFFFEE} Be Right Back", GetPlayerNameEx(playerid)));
    if (reason == 2) SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFCC66} %s{FFFFEE} left. {ff9966}Possible Reason:{FFFFEE} Kicked by server", GetPlayerNameEx(playerid)));
    return 1;
}

// hook OnPlayerUpdate(playerid) {
//     if(playerid == 0) {
//         printf("Last Pos:%f, %f, %f", pInfo[playerid][LastPosX], pInfo[playerid][LastPosY], pInfo[playerid][LastPosZ]);
//     }
//     return 1;
// }

hook OnPlayerUpdateEx(playerid) {
    if (!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || IsPlayerPaused(playerid) || !Tryg3D::IsPlayerSpawned(playerid)) return 1;
    GetPlayerPos(playerid, pInfo[playerid][LastPosX], pInfo[playerid][LastPosY], pInfo[playerid][LastPosZ]);
    GetPlayerFacingAngle(playerid, pInfo[playerid][LastPosAngle]);
    SetPlayerInteriorID(playerid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorldID(playerid, GetPlayerVirtualWorld(playerid));
    SetPlayerWantedLevel(playerid, GetPlayerWantedLevelEx(playerid));
    return 1;
}

stock GetPlayerLookupIP(playerid) {
    new country[MAX_COUNTRY_NAME];
    strunpack(country, pInfo[playerid][e_LookupIP], MAX_COUNTRY_NAME);
    return country;
}

stock GetPlayerLookupLoc(playerid) {
    new country[MAX_COUNTRY_NAME];
    strunpack(country, pInfo[playerid][e_LookupLoc], MAX_COUNTRY_NAME);
    return country;
}

stock GetPlayerCountry(playerid) {
    new country[MAX_COUNTRY_NAME];
    strunpack(country, pInfo[playerid][e_LookupCountry], MAX_COUNTRY_NAME);
    return country;
}

stock GetPlayerRegion(playerid) {
    new region[MAX_COUNTRY_NAME];
    strunpack(region, pInfo[playerid][e_LookupRegion], MAX_COUNTRY_NAME);
    return region;
}

stock GetPlayerCity(playerid) {
    new city[MAX_COUNTRY_NAME];
    strunpack(city, pInfo[playerid][e_LookupCity], MAX_COUNTRY_NAME);
    return city;
}

stock GetPlayerISP(playerid) {
    new isp[MAX_COUNTRY_NAME];
    strunpack(isp, pInfo[playerid][e_LookupISP], MAX_COUNTRY_NAME);
    return isp;
}

stock GetPlayerTimezone(playerid) {
    new timezone[MAX_COUNTRY_NAME];
    strunpack(timezone, pInfo[playerid][e_LookupTimezone], MAX_COUNTRY_NAME);
    return timezone;
}

stock GetPlayerZipcode(playerid) {
    new zipcode[MAX_ZIP_LENGTH];
    strunpack(zipcode, pInfo[playerid][e_LookupZipcode], MAX_ZIP_LENGTH);
    return zipcode;
}

forward ApproveLogin(playerid);
public ApproveLogin(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    // We will activate the cache of player to make use of it e.g.
    // Retrieve their data.

    if (!cache_is_valid(GetPlayerPlayer_Cache(playerid))) return Kick(playerid);
    cache_set_active(GetPlayerPlayer_Cache(playerid));

    // Okay, we are retrieving the information now..
    cache_get_value_int(0, "id", pInfo[playerid][ID]);

    cache_get_value_int(0, "kills", pInfo[playerid][Kills]);
    cache_get_value_int(0, "deaths", pInfo[playerid][Deaths]);

    cache_get_value_int(0, "playedTime", pInfo[playerid][PlayedTime]);
    cache_get_value_int(0, "pauseTime", pInfo[playerid][PauseTime]);
    cache_get_value_int(0, "cash", pInfo[playerid][Cash]);

    cache_get_value_int(0, "autoSpawn", pInfo[playerid][AutoSpawn]);

    cache_get_value_int(0, "lastHealth", pInfo[playerid][LastHealth]);
    cache_get_value_int(0, "lastArmour", pInfo[playerid][LastArmour]);

    cache_get_value_int(0, "adminLevel", pInfo[playerid][adminLevel]);
    cache_get_value_int(0, "vipLevel", pInfo[playerid][VIPLevel]);
    cache_get_value_int(0, "wantedLevel", pInfo[playerid][WantedLevel]);

    cache_get_value_float(0, "lastPosX", pInfo[playerid][LastPosX]);
    cache_get_value_float(0, "lastPosY", pInfo[playerid][LastPosY]);
    cache_get_value_float(0, "lastPosZ", pInfo[playerid][LastPosZ]);
    cache_get_value_float(0, "lastPosAngle", pInfo[playerid][LastPosAngle]);
    cache_get_value_int(0, "interiorId", pInfo[playerid][InteriorID]);
    cache_get_value_int(0, "virtualWorldId", pInfo[playerid][VirtualWorldID]);
    cache_get_value_name_bool(0, "masterAdmin", pInfo[playerid][MasterAdmin]);
    // So, we have successfully retrieved data? Now deactivating the cache.
    cache_delete(GetPlayerPlayer_Cache(playerid));
    SetPlayerPlayer_Cache(playerid, MYSQL_INVALID_CACHE);
    beforeLoginApprove(playerid);
    SetPlayerLoginStatus(playerid, true);
    CallRemoteFunction("OnPlayerLogin", "i", playerid);
    return 1;
}

stock beforeLoginApprove(playerid) {
    for (new i = 0; i < 50; i++) SendClientMessageEx(playerid, -1, "");
    SendClientMessageEx(playerid, 0x00FF00FF, "Logged in to the account.");
    SendClientMessageToAll(-1, sprintf("{4286f4}[Alexa]:{FFCC66}%s {FFFFFF}joined {f4353d}Indian {e1e1e1}Oc{7087ff}e{e1e1e1}an {76e460}Roleplay {FFFFFF}Server.", GetPlayerNameEx(playerid)));
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}Enjoy your stay in the community!");
    // SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}we wish you happy diwali, use /happydiwali to claim diwali gifts from us.");
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != DIALOG_LOGIN_REG_SYS) return 1;
    if (offsetid == DIALOG_LOGIN) {
        if (!response) return Kick(playerid);

        new Salted_Key[65];
        SHA256_PassHash(inputtext, GetPlayerSalt(playerid), Salted_Key, 65);

        if (strcmp(Salted_Key, GetPlayerPassword(playerid)) == 0) {
            // Now, password should be correct as well as the strings
            // Matched with each other, so nothing is wrong until now.
            SetTimerEx("ApproveLogin", 5 * 1000, false, "d", playerid);
            return 1;
        } else {
            new String[150];

            SetPlayerPasswordFails(playerid, GetPlayerPasswordFails(playerid) + 1);
            printf("%s has been failed to login. (%d)", GetPlayerNameEx(playerid), GetPlayerPasswordFails(playerid));
            // Printing the message that someone has failed to login to his account.

            if (GetPlayerPasswordFails(playerid) >= 3) // If the fails exceeded the limit we kick the player.
            {
                format(String, sizeof(String), "{4286f4}[Alexa]:{969696}%s has been kicked Reason:{FF0000}(%d/3) Login fails.", GetPlayerNameEx(playerid), GetPlayerPasswordFails(playerid));
                SendClientMessageToAll(0x969696FF, String);
                Kick(playerid);
            } else {
                // If the player didn't exceed the limits we send him a message that the password is wrong.
                format(String, sizeof(String), "Wrong password, you have %d out of 3 tries.", GetPlayerPasswordFails(playerid));
                SendClientMessageEx(playerid, 0xFF0000FF, String);

                LoginMenu(playerid);
            }
        }
    }
    if (offsetid == DIALOG_REGISTER) {
        if (!response) return Registration_Menu(playerid);

        if (strlen(inputtext) <= 5 || strlen(inputtext) > 60) {
            // If the password length is less than or equal to 5 and more than 60
            // It repeats the process and shows error message as seen below.
            SendClientMessageEx(playerid, 0x969696FF, "Invalid password length, should be 5 - 60.");
            Registration_Menu(playerid);
        } else {
            // Salting the player's password using SHA256 for a better security.
            for (new i = 0; i < 10; i++) {
                pInfo[playerid][Salt][i] = random(79) + 47;
                if (pInfo[playerid][Salt][i] == 92) pInfo[playerid][Salt][i] = 93;
            }

            pInfo[playerid][Salt][10] = 0;
            SHA256_PassHash(inputtext, pInfo[playerid][Salt], pInfo[playerid][Password], 65);

            new DB_Query[512];

            // Storing player's information if everything goes right.
            mysql_format(
                Database, DB_Query, sizeof(DB_Query),
                "INSERT INTO `playerdata` (`username`) VALUES (\"%s\")",
                GetPlayerNameEx(playerid)
            );
            mysql_tquery(Database, DB_Query);

            // email password referral salt username      
            mysql_format(
                Database, DB_Query, sizeof(DB_Query),
                "INSERT INTO `players` (`email`, `username`, `password`, `salt`) \
			    VALUES (\"%s\", \"%s\", \"%s\", \"%s\")",
                "indianoceanroleplay@gmail.com",
                GetPlayerNameEx(playerid),
                pInfo[playerid][Password],
                pInfo[playerid][Salt]
            );
            mysql_tquery(Database, DB_Query, "OnPlayerRegister", "d", playerid);
        }
    }
    if (offsetid == DIALOG_RPNAME) {
        if (!response) return RPName_Menu(playerid);
        if (strlen(inputtext) < 5) return RPName_Menu(playerid);
        if (!RoleplayNameCheck(inputtext)) return RPName_Menu(playerid);
        SetPlayerName(playerid, "IORP_NEW_NAME");
        SetPlayerName(playerid, RoleplayNameFormat(inputtext));
        if (IsValidAccount(inputtext)) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}This account already exists, login to proceed...");
            return Connect_Login_Init(playerid);
        }
        if (!RoleplayNameCheck(GetPlayerNameEx(playerid))) return RPName_Menu(playerid);
        else Registration_Menu(playerid);
    }
    if (offsetid == DIALOG_UPDATE_RPNAME) {
        if (!response) return UpdateRPName_Menu(playerid);
        if (strlen(inputtext) < 5) return UpdateRPName_Menu(playerid);
        if (!RoleplayNameCheck(inputtext)) return UpdateRPName_Menu(playerid);
        if (IsValidAccount(inputtext)) return UpdateRPName_Menu(playerid);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Your account update initiated...");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Your are about to logout...");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Rejoin server with your new name.");
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}Your new account name is: %s", RoleplayNameFormat(inputtext)));
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}Thanks with love - IORP.");
        ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_UPDATE_RPNAME_Confirm, DIALOG_STYLE_MSGBOX, "Login System", "{4286f4}[Alexa]:{FFFFEE}Confirm account upgrade.", "Confirm", "Change Name", -1, RoleplayNameFormat(inputtext));
        return 1;
    }
    if (offsetid == DIALOG_UPDATE_RPNAME_Confirm) {
        if (!response) return UpdateRPName_Menu(playerid);
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof pname);
        kick(playerid);
        UpdateRPName_Confirm(pname, payload);
        return 1;
    }
    if (offsetid == Dialog_Skin_Chnage_ID) {
        if (!response) return 1;
        SetPlayerSkinEx(playerid, listitem);
        GameTextForPlayer(playerid, "~g~Skin Changed!", 3000, 3);
        SetPlayerAutoSpawn(playerid, listitem);
        mysql_tquery(Database, sprintf("UPDATE `players` SET `AutoSpawn`=%d WHERE `Username` = \"%s\"  LIMIT 1", GetPlayerAutoSpawn(playerid), GetPlayerNameEx(playerid)));
        CompleteSkinMission(playerid);
        return 1;
    }
    return 1;
}

stock UpdateAutospawnSkin(playerid, skinid) {
    SetPlayerAutoSpawn(playerid, skinid);
    mysql_tquery(Database, sprintf("UPDATE `players` SET `AutoSpawn`=%d WHERE `Username` = \"%s\"  LIMIT 1", GetPlayerAutoSpawn(playerid), GetPlayerNameEx(playerid)));
    return 1;
}

stock LogoutCommand(playerid) {
    new string[512];
    format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE} you are succesfully logged out."), SendClientMessageEx(playerid, -1, string);
    SetTimerEx("kick", 1000, false, "i", playerid);
    return 1;
}

stock AutospawnCommand(playerid) {
    new string[512], DB_Query[512];
    if (GetPlayerAutoSpawn(playerid) == -1) {
        SetPlayerAutoSpawn(playerid, GetPlayerSkin(playerid));
        format(DB_Query, sizeof DB_Query, "UPDATE `players` SET `AutoSpawn`=%d WHERE `Username` = \"%s\"  LIMIT 1", GetPlayerAutoSpawn(playerid), GetPlayerNameEx(playerid));
        mysql_tquery(Database, DB_Query);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}Auto Spawn enabled for your account with current skin ID, use SCP to disable", GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, -1, string);
    } else {
        SetPlayerAutoSpawn(playerid, -1);
        format(DB_Query, sizeof DB_Query, "UPDATE `players` SET `AutoSpawn`=%d WHERE `Username` = \"%s\" LIMIT 1", GetPlayerAutoSpawn(playerid), GetPlayerNameEx(playerid));
        mysql_tquery(Database, DB_Query);
        format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}Auto Spawn disabled for your account, use SCP to reactivate", GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, -1, string);
    }
    return 1;
}

stock MasterAdminCommand(playerid) {
    if (IsPlayerMasterAdmin(playerid)) {
        SetPlayerMasterAdmin(playerid, false);
        mysql_tquery(Database, sprintf("UPDATE `players` SET `MasterAdmin`= false WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid)));
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}Your access to the master administrator is restricted", GetPlayerNameEx(playerid)));
    } else {
        SetPlayerMasterAdmin(playerid, true);
        mysql_tquery(Database, sprintf("UPDATE `players` SET `MasterAdmin`= true WHERE `Username` = \"%s\" LIMIT 1", GetPlayerNameEx(playerid)));
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFFF}Your access to the master administrator is granted", GetPlayerNameEx(playerid)));
    }
    return 1;
}

DC_CMD:setmasteradmin(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], bool:status;
    if (sscanf(params, "s[50]b", Account, status)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !setmasteradminlist [Account] [true/false]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");

    new playerid = GetPlayerIDByName(Account);
    if (playerid != -1) {
        MasterAdminCommand(playerid);
    } else {
        mysql_tquery(Database, sprintf("UPDATE `players` set MasterAdmin = %d WHERE `Username` = \"%s\" LIMIT 1", status, Account));
    }
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %s MasterAdmin status updated to %d", Account, status));
    return 1;
}

DC_CMD:setadmin(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], level;
    if (sscanf(params, "s[50]i", Account, level)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Usage]:!setadmin [Player] [level 0-10]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (level < 0 || level > 10) return DCC_SendChannelMessage(DCC_Channel:channel, "[Error]:Invalid Admin Level:0-10");

    mysql_tquery(Database, sprintf("UPDATE `players` SET `adminLevel`=\"%d\"  WHERE `Username`=\"%s\"", level, Account));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("You have set %s Admin level to %i", Account, level));

    new playerid = GetPlayerIDByName(Account);
    if (playerid != -1) {
        SetPlayerAdminLevel(playerid, level);
        AlexaMsg(playerid, sprintf("Your Admin level has been set to {FF0033}%i {FFFFFF}by {FFCC66} %s", level, user));
    }
    return 1;
}

DC_CMD:setvip(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new Account[50], level, days;
    if (sscanf(params, "s[50]id", Account, level, days)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Usage]:!setvip [PlayerID] [level 0-3] [Days]");
    if (!IsValidAccount(RemoveMalChars(Account))) return DCC_SendChannelMessage(DCC_Channel:channel, "[Alexa]: Account not Found");
    if (level < 0 || level > 3) return DCC_SendChannelMessage(DCC_Channel:channel, "[Error]:Invalid Admin Level:0-3");
    if (days < 0 || days > 365) return DCC_SendChannelMessage(DCC_Channel:channel, "[Error]:Invalid Days: 0-365");

    new DB_Query[512];
    format(DB_Query, sizeof DB_Query, "UPDATE playerdata SET vipLevel = %d, vipLevelExpireAt = %d  WHERE Username = \"%s\"", level, gettime() + days * 24 * 60 * 60, Account);
    mysql_tquery(Database, DB_Query);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]:You have set %s VIP level to %i", Account, level));

    new playerid = GetPlayerIDByName(Account);
    if (playerid != -1) {
        SetPlayerVIPLevel(playerid, level);
        AlexaMsg(playerid, sprintf("Your VIP level has been set to {FF0033}%i {FFFFFF}by {FFCC66} %s", level, user));
    } else {
        Email:Send(ALERT_TYPE_ACCOUNT, Account, "VIP Alert", sprintf(
            "you account has been upgraded to vip level %d for %d days.", level, days
        ));
    }
    return 1;
}

cmd:setvip(DCC_Message:message, playerid, const params[]) {
    if (!IsPlayerMasterAdmin(playerid)) return 0;
    new pID, level, days;
    if (sscanf(params, "uid", pID, level, days)) return SendClientMessage(playerid, -1, "[Usage]:!setvip [PlayerID] [level 1-10] [Days]");
    else if (level < 0 || level > 10) return SendClientMessage(playerid, -1, "[Error]:Invalid Admin Level:0-10");
    else if (days < 1 || days > 365) return SendClientMessage(playerid, -1, "[Error]:Invalid Days:0-365");
    else if (pID == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "[Error]:Invalid PlayerID");
    else if (GetPlayerVIPLevel(pID) == level) return SendClientMessage(playerid, -1, "[Error]:Player already on this level");
    SetPlayerVIPLevel(pID, level);
    new DB_Query[512];
    format(DB_Query, sizeof DB_Query, "UPDATE playerdata SET vipLevel = %d, vipLevelExpireAt = %d  WHERE Username = \"%s\"", level, gettime() + days * 24 * 60 * 60, GetPlayerNameEx(pID));
    mysql_tquery(Database, DB_Query);
    new string[512];
    format(string, sizeof string, "[Alexa]:You have set %s VIP level to %i", GetPlayerNameEx(pID), level);
    SendClientMessage(playerid, -1, string);
    format(string, sizeof string, "{4286f4}[Alexa]:{FFFFEE}Your VIP level has been set to {FF0033}%i {FFFFFF}by {FFCC66} %s", level, GetPlayerNameEx(playerid));
    SendClientMessageEx(pID, COLOR_GREY, string);
    return 1;
}

stock GetPlayerMutedStatus(playerid) {
    return pInfo[playerid][muted];
}

stock SetPlayerMutedStatus(playerid, bool:status) {
    pInfo[playerid][muted] = status;
    return 1;
}

stock MuteCommand(playerid, pID, bool:status) {
    if (!IsPlayerConnected(pID)) return SendClientMessageEx(playerid, COLOR_GREY, "{4286f4}[Alexa]:{FFFFEE} Invalid PlayerID");
    if (status == true) {
        pInfo[pID][muted] = true;
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}%s now muted", GetPlayerNameEx(pID)));
        SendClientMessageEx(pID, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}A Admin %s muted you", GetPlayerNameEx(playerid)));
        Database:UpdateBool(true, GetPlayerNameEx(pID), "username", "isMuted");
    } else {
        pInfo[pID][muted] = false;
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}%s now unmuted", GetPlayerNameEx(pID)));
        SendClientMessageEx(pID, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}A Admin %s unmuted you", GetPlayerNameEx(playerid)));
        Database:UpdateBool(false, GetPlayerNameEx(pID), "username", "isMuted");
    }
    return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {
    // printf("Give:playerid = %d, damagedid = %d, Float:amount = %f, weaponid = %d, bodypart = %d", playerid, damagedid, amount, weaponid, bodypart);
    if (!IsPlayerStreamedIn(playerid, damagedid) || !IsPlayerStreamedIn(damagedid, playerid)) return 0;
    if (weaponid == 38) return Kick(playerid);
    if (GetPlayerHealthEx(playerid) < 0) return ~0;
    new temp = floatround(amount, floatround_round);
    new tempH = floatround(pInfo[damagedid][LastHealth], floatround_round);
    new tempA = floatround(pInfo[damagedid][LastArmour], floatround_round);
    new temponlyarmour = tempA - temp;
    new temphealthandarmour = tempH - temp;
    if (temphealthandarmour >= 0 && weaponid == 34 && bodypart == 9) {
        temphealthandarmour = 0;
        GameTextForPlayer(playerid, "Nice HeadShot", 2000, 4);
    }
    if (temponlyarmour > -1) SetPlayerArmourEx(damagedid, temponlyarmour);
    if (temphealthandarmour > 0 && temponlyarmour < 0) {
        SetPlayerArmourEx(damagedid, 0);
        SetPlayerHealthEx(damagedid, temphealthandarmour);
    }
    if (temphealthandarmour <= 0) {
        SetPlayerArmourEx(damagedid, 0);
        SetPlayerHealthEx(damagedid, 0);
        if (!GetPlayerDeathStatus(damagedid)) CallRemoteFunction("OnPlayerKilled", "iii", damagedid, playerid, weaponid);
        SetPlayerDeathStatus(damagedid, true);
    }
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {
    // printf("Take:playerid = %d, issuerid = %d, Float:amount = %f, weaponid = %d, bodypart = %d", playerid, issuerid, amount, weaponid, bodypart);
    return 1;
}

new DataKilledBy[MAX_PLAYERS];
forward SetPlayerKilledBy(playerid, killerid);
public SetPlayerKilledBy(playerid, killerid) {
    DataKilledBy[playerid] = killerid;
    return 1;
}

stock GetPlayerKilledBy(playerid) {
    return DataKilledBy[playerid];
}

forward OnPlayerKilled(playerid, killerid, weaponid);
public OnPlayerKilled(playerid, killerid, weaponid) {
    SendDeathMessage(killerid, playerid, weaponid);
    if (IsPlayerConnected(killerid)) pInfo[killerid][Kills]++;
    if (IsPlayerConnected(playerid)) pInfo[playerid][Deaths]++;
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(killerid)) return 1;
    // if (!Event:IsInEvent(playerid) || !Event:IsInEvent(killerid)) {
    //     if (!GetPlayerRPMode(playerid) || !GetPlayerRPMode(killerid)) {
    //         LogPlayerEvent(killerid, "DEATHMATCH", sprintf("%s deathmatch", GetPlayerNameEx(playerid)));
    //         new string[512], wepaonname[50];
    //         GetWeaponName(weaponid, wepaonname, sizeof wepaonname);
    //         format(string, sizeof string, "killed %s with %s", GetPlayerNameEx(playerid), wepaonname);
    //         WantedDatabase:GiveWantedLevel(killerid, string, 1, false);
    //         SetPlayerKilledBy(playerid, killerid);
    //         SetTimerEx("SetPlayerKilledBy", 60 * 1000, false, "dd", playerid, -1);
    //         AlexaMsg(playerid, sprintf("%s has killed you without reason, would you like to report this deathmatch?", GetPlayerNameEx(killerid)));
    //         if (GetPlayerScore(playerid) < 10) {
    //             AlexaMsg(playerid, "To send him/her to admin jail, use /alexa yes.");
    //         } else {
    //             AlexaMsg(playerid, "To send him/her to admin jail, use /alexa yes.");
    //             AlexaMsg(playerid, "To ban him/her from the server, use /alexa ban.");
    //         }
    //         AlexaMsg(playerid, "If you are okay with it, ignore this message.");
    //     }
    // }
    return 1;
}

// hook OnAlexaResponse(playerid, const cmd[], const text[]) {
//     new killerid = GetPlayerKilledBy(playerid);
//     if (!IsPlayerConnected(killerid)) return 1;
//     if (IsStringContainWords(text, "yes") && killerid != -1 && IsPlayerConnected(killerid)) {
//         WantedDatabase:GiveWantedLevel(killerid, sprintf("Deathmatch of %s", GetPlayerNameEx(playerid)), Random(3, 6), false);
//         WantedDatabase:SendJail(killerid);
//         WantedDatabase:JailPlayer(killerid);
//         SetPlayerKilledBy(playerid, -1);
//         return ~1;
//     }
//     if (IsStringContainWords(text, "ban") && killerid != -1 && IsPlayerConnected(killerid) && GetPlayerScore(playerid) >= 10) {
//         if (CountPlayerEvent(killerid, "DEATHMATCH", gettime() - (7 * 24 * 60 * 60)) >= 7) {
//             BanPlayer(killerid, 7 * 24 * 60, sprintf("Extended ban: Deathmatch of %s", GetPlayerNameEx(playerid)));
//         } else if (CountPlayerEvent(killerid, "DEATHMATCH", gettime() - (24 * 60 * 60)) >= 3) {
//             BanPlayer(killerid, 24 * 60, sprintf("Extended ban: Deathmatch of %s", GetPlayerNameEx(playerid)));
//         } else {
//             BanPlayer(killerid, Random(10, 20), sprintf("Deathmatch of %s", GetPlayerNameEx(playerid)));
//             Discord:SendHelper(sprintf(":page_with_curl:** %s banned %s for deathmatch. **", GetPlayerNameEx(playerid), GetPlayerNameEx(killerid)));
//             SetPlayerKilledBy(playerid, -1);
//         }
//         return ~1;
//     }
//     return 1;
// }

hook OnPlayerClickPlayer(playerid, clickedplayerid, source) {
    if (source != CLICK_SOURCE_SCOREBOARD) return 1;
    new PlayerStatus[2000];
    strcat(PlayerStatus, sprintf("Name: %s[%d]\t", GetPlayerNameEx(clickedplayerid), GetPlayerID(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Admin Level's: %d\t", GetPlayerAdminLevel(clickedplayerid)));
    strcat(PlayerStatus, sprintf("VIP Level's: %d\n", GetPlayerVIPLevel(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Wanted Levels: %d\t", GetPlayerWantedLevelEx(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Kill's: %d\t", pInfo[clickedplayerid][Kills]));
    strcat(PlayerStatus, sprintf("Death's: %d\n", pInfo[clickedplayerid][Deaths]));
    strcat(PlayerStatus, sprintf("Roleplay Score: %d\n", GetPlayerRpScore(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Experience Point: %d\n", GetExperiencePoint(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Skin Id: %d\t", GetPlayerSkin(clickedplayerid)));
    strcat(PlayerStatus, sprintf("Awake Time: Hour: %02d Minute: %02d\t", GetPlayerAwakeTime(clickedplayerid) / 60, GetPlayerAwakeTime(clickedplayerid) % 60));
    strcat(PlayerStatus, sprintf("Sleep Time: Hour: %02d Minute: %02d\n", GetPlayerSleepTime(clickedplayerid) / 60, GetPlayerSleepTime(clickedplayerid) % 60));
    new playtime = pInfo[clickedplayerid][PlayedTime];
    strcat(PlayerStatus, sprintf("Active Time:Year: %02d Month: %02d Week: %02d Days: %02d Hour: %02d Minute: %02d Second: %02d\n",
        playtime / (365 * 24 * 60 * 60) % 365, playtime / (30 * 24 * 60 * 60) % 30, playtime / (7 * 24 * 60 * 60) % 7, playtime / (24 * 60 * 60) % 24, playtime / (60 * 60) % 24, playtime / (60) % 60, playtime % 60));
    new pausetime = pInfo[clickedplayerid][PauseTime] / 1000;
    strcat(PlayerStatus, sprintf("Inactive Time:Year: %02d Month: %02d Week: %02d Days: %02d Hour: %02d Minute: %02d Second: %02d\n",
        pausetime / (365 * 24 * 60 * 60) % 365, pausetime / (30 * 24 * 60 * 60) % 30, pausetime / (7 * 24 * 60 * 60) % 7, pausetime / (24 * 60 * 60) % 24, pausetime / (60 * 60) % 24, pausetime / (60) % 60, pausetime % 60));
    strcat(PlayerStatus, sprintf("Faction: %s, Rank: %s\n", Faction:GetName(Faction:GetPlayerFID(clickedplayerid)), Faction:GetRankName(Faction:GetPlayerFID(clickedplayerid), Faction:GetPlayerRankID(clickedplayerid))));
    if (GetPlayerAdminLevel(playerid) >= 1 || GetPlayerHelperStatus(playerid)) {
        strcat(PlayerStatus, sprintf("Location: %s, Interior: %d, Virtual World: %d\n\n", GetPlayerZoneName(clickedplayerid), GetPlayerInterior(clickedplayerid), GetPlayerVirtualWorld(clickedplayerid)));
        strcat(PlayerStatus, sprintf("Phone Number: %d\n", Phone:GetPlayerNumber(clickedplayerid)));
        strcat(PlayerStatus, sprintf("Driving License Status\n"));
        strcat(PlayerStatus, sprintf("\tLight Motor License: %s\n", (IsPlayerHaveLightLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("\tHeavy Motor License: %s\n", (IsPlayerHaveHeavyLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("\tTwo Wheeler License: %s\n", (IsPlayerHaveTwoWheelerLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("\tHelicopter License: %s\n", (IsPlayerHaveHeliCopterLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("\tPlane Flying License: %s\n", (IsPlayerHavePlaneLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("\tBoat Driving License: %s\n\n", (IsPlayerHaveBoatLicense(clickedplayerid)) ? ("Yes") : ("No")));
        strcat(PlayerStatus, sprintf("Money: %d\n", GetPlayerCash(clickedplayerid)));
        if (GetPlayerAdminLevel(playerid) == 10) {
            strcat(PlayerStatus, sprintf("Email: %s\n", pInfo[clickedplayerid][email]));
            new ip[50];
            GetPlayerIp(clickedplayerid, ip, sizeof ip);
            strcat(PlayerStatus, sprintf("IP: %s\n", ip));
            strcat(PlayerStatus, sprintf("IP LookupIP: %s\n", GetPlayerLookupIP(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP LookupLoc: %s\n", GetPlayerLookupLoc(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP Country: %s\n", GetPlayerCountry(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP Region: %s\n", GetPlayerRegion(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP City: %s\n", GetPlayerCity(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP ISP: %s\n", GetPlayerISP(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP Timezone: %s\n", GetPlayerTimezone(clickedplayerid)));
            strcat(PlayerStatus, sprintf("IP Zipcode: %s\n", GetPlayerZipcode(clickedplayerid)));
        }
    }
    ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, DIALOG_PLAYER_STATS, DIALOG_STYLE_MSGBOX, "Alexa:Player Status", PlayerStatus, "Thanks", "");
    return 1;
}

stock ChangeSkin(playerid) {
    const MAX_SKINS = 312;
    new string[MAX_SKINS * 16];
    if (GetPlayerVIPLevel(playerid) > 1) {
        AlexaMsg(playerid, "It is forbidden for you to use faction skin. If you do, your VIP status will be deactivated.");
        if (string[0] == EOS) {
            for (new i; i < MAX_SKINS; i++) {
                format(string, sizeof string, "%s%i\tID: %i\n", string, i, i);
            }
        }
    } else {
        new skinids[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
        if (string[0] == EOS) {
            for (new i; i < sizeof skinids; i++) {
                format(string, sizeof string, "%s%i\tID: %i\n", string, skinids[i], skinids[i]);
            }
        }
    }
    return ShowPlayerDialogEx(playerid, DIALOG_LOGIN_REG_SYS, Dialog_Skin_Chnage_ID, DIALOG_STYLE_PREVIEW_MODEL, "Skin Selection", string, "Select", "Cancel");
}

stock AutoLoginCommand(playerid) {
    if (Database:GetBool(GetPlayerNameEx(playerid), "username", "autologin")) {
        Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "autologin");
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}You have disabled auto-login for your account.");
    } else {
        Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "autologin");
        SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}You have enabled auto-login for your account.");
    }
    return 1;
}

SCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    SCP:AddCommand(playerid, "Change Skin");
    SCP:AddCommand(playerid, "Enable/Disable Auto Login");
    // if(GetPlayerAutoSpawn(playerid) == -1) SCP:AddCommand(playerid, "Enable AutoSpawn");
    // if(GetPlayerAutoSpawn(playerid) != -1) SCP:AddCommand(playerid, "Disable AutoSpawn");
    SCP:AddCommand(playerid, "Logout");
    return 1;
}

SCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Change Skin", inputtext)) ChangeSkin(playerid);
    if (IsStringSame("Enable AutoSpawn", inputtext)) AutospawnCommand(playerid);
    if (IsStringSame("Disable AutoSpawn", inputtext)) AutospawnCommand(playerid);
    if (IsStringSame("Logout", inputtext)) LogoutCommand(playerid);
    if (IsStringSame("Enable/Disable Auto Login", inputtext)) AutoLoginCommand(playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `players` set `Username` = \"%s\" WHERE `Username` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `players` set `Username` = \"%s\" WHERE `Username` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `loginLogs` set `Username` = \"%s\" WHERE `Username` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `players` WHERE `Username` = \"%s\" LIMIT 1", AccountName));
    return 1;
}