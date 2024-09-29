#define     MAX_BANKERS     (20)
#define     MAX_ATMS        (100)

#define     BANKER_USE_MAPICON      			// comment or remove this line if you don't want bankers to have mapicons
#define     ATM_USE_MAPICON         			// comment or remove this line if you don't want atms to have mapicons
#define     BANKER_ICON_RANGE       (10.0)		// banker mapicon stream distance, you can remove this if you're not using banker icons (default:10.0)
#define     ATM_ICON_RANGE       	(100.0)		// atm mapicon stream distance, you can remove this if you're not using banker icons (default:100.0)
#define     ACCOUNT_PRICE           (100)      	// amount of money required to create a new bank account (default:100)
#define     ACCOUNT_CLIMIT          (3)         // a player can create x accounts, you can comment or remove this line if you don't want an account limit (default:5)
#define     ACCOUNT_LIMIT           (9999999) // how much money can a bank account have (default: 9,999,999)

#define     ATM_HEALTH              (350.0)     // health of an atm (Default:350.0)
#define     ATM_REGEN               (120)       // a robbed atm will start working after x seconds (Default:120)
#define     ATM_ROB_MIN  			(1500)   	// min. amount of money stolen from an atm (Default:1500)
#define     ATM_ROB_MAX  			(3500)  	// max. amount of money stolen from an atm (Default:3500)

enum _:E_BANK_LOGTYPE {
    TYPE_NONE,
    TYPE_LOGIN,
    TYPE_DEPOSIT,
    TYPE_WITHDRAW,
    TYPE_TRANSFER,
    TYPE_PASSCHANGE
}

enum _:E_ATMDATA {
    IDString[8],
        refID
}

enum E_BANKER {
    // saved
    Skin,
    Float:bankerX,
    Float:bankerY,
    Float:bankerZ,
    Float:bankerA,
    anim_lib[50],
    anim_name[50],
    anim_loop,
    // temp
    bankerActorID,
    bankerIconID,
    Text3D:bankerLabel
}

enum E_ATM {
    // saved
    Float:atmX,
    Float:atmY,
    Float:atmZ,
    Float:atmRX,
    Float:atmRY,
    Float:atmRZ,
    // temp
    atmObjID,
    atmIconID,

    Float:atmHealth,
    atmRegen,
    atmTimer,
    atmPickup,

    Text3D:atmLabel
}

new BankerData[MAX_BANKERS][E_BANKER],
    ATMData[MAX_ATMS][E_ATM];

new Iterator:Bankers < MAX_BANKERS > ,
    Iterator:ATMs < MAX_ATMS > ;

new CurrentAccountID[MAX_PLAYERS] = {
        -1,
        ...
    },
    LogListType[MAX_PLAYERS] = {
        TYPE_NONE,
        ...
    },
    LogListPage[MAX_PLAYERS],
    EditingATMID[MAX_PLAYERS] = {
        -1,
        ...
    };

stock Bank:IsNearBanker(playerid) {
    foreach(new i:Bankers) if (IsPlayerInRangeOfPoint(playerid, 3.0, BankerData[i][bankerX], BankerData[i][bankerY], BankerData[i][bankerZ])) return 1;
    return 0;
}

stock Bank:IsValidBanker(bankerid) {
    return Iter_Contains(Bankers, bankerid);
}

stock Bank:IsValidATM(atmid) {
    return Iter_Contains(ATMs, atmid);
}

stock Bank:GetClosestATM(playerid, Float:range = 3.0) {
    new id = -1, Float:dist = range, Float:tempdist;
    foreach(new i:ATMs) {
        tempdist = GetPlayerDistanceFromPoint(playerid, ATMData[i][atmX], ATMData[i][atmY], ATMData[i][atmZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) dist = tempdist, id = i;
    }

    return id;
}

stock Bank:SaveLog(playerid, type, accid, toaccid, amount, const reason[] = "-") {
    if (type == TYPE_NONE) return 1;
    mysql_tquery(Database, sprintf(
        "INSERT INTO bankTransactions (Amount, AccountID, ToAccountID, Type, Player, Date, balance, reason) \
        values (%d, %d, %d, %d, \"%s\", UNIX_TIMESTAMP(), (select balance from bankAccounts where id = %d), \"%s\")",
        amount, accid, toaccid, type, GetPlayerNameEx(playerid), accid, reason
    ));
    return 1;
}

stock Bank:SaveLogEx(const account[], type, accid, toaccid, amount, const reason[] = "-") {
    if (type == TYPE_NONE) return 1;
    mysql_tquery(Database, sprintf(
        "INSERT INTO bankTransactions (Amount, AccountID, ToAccountID, Type, Player, Date, balance, reason) \
        values (%d, %d, %d, %d, \"%s\", UNIX_TIMESTAMP(), (select balance from bankAccounts where id = %d), \"%s\")",
        amount, accid, toaccid, type, account, accid, reason
    ));
    return 1;
}

stock Bank:AccountCount(playerid) {
    new query[256], Cache:find_accounts;
    mysql_format(Database, query, sizeof(query), "SELECT null FROM bankAccounts WHERE Owner=\"%s\" && Disabled=0", GetPlayerNameEx(playerid));
    find_accounts = mysql_query(Database, query);

    new count = cache_num_rows();
    cache_delete(find_accounts);
    return count;
}

stock Bank:IsValidAccountID(accountid) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `bankAccounts` WHERE `ID` = %d LIMIT 1", accountid));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return 1;
}

stock Bank:IsAccountAcitve(accountid) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * FROM `bankAccounts` WHERE `ID` = %d && Disabled = 0 LIMIT 1", accountid));
    new rows = cache_num_rows();
    cache_delete(mysql_cache);
    if (!rows) return 0;
    else return 1;
}

stock Bank:IsUsingAtm(playerid) {
    return GetPVarInt(playerid, "usingATM");
}

stock Bank:GetBalance(accountid) {
    new query[256], Cache:get_balance;
    mysql_format(Database, query, sizeof(query), "SELECT Balance FROM bankAccounts WHERE ID=%d && Disabled=0", accountid);
    get_balance = mysql_query(Database, query);

    new balance;
    cache_get_value_name_int(0, "Balance", balance);
    cache_delete(get_balance);
    return balance;
}

stock Bank:GetOwner(accountid) {
    new query[256], owner[MAX_PLAYER_NAME], Cache:get_owner;
    mysql_format(Database, query, sizeof(query), "SELECT Owner FROM bankAccounts WHERE ID=%d && Disabled=0", accountid);
    get_owner = mysql_query(Database, query);

    cache_get_value_name(0, "Owner", owner);
    cache_delete(get_owner);
    return owner;
}

stock Bank:AtmDmgText(id) {
    new Float:health = ATMData[id][atmHealth], color, string[16];
    if (health < (ATM_HEALTH / 4)) color = -1;
    else if (health < (ATM_HEALTH / 2)) color = 0xF39C12FF;
    else color = 0x2ECC71FF;
    format(string, sizeof(string), "{%06x}%.2f%%", color >>> 8, (health * 100 / ATM_HEALTH));
    return string;
}

forward LoadBankers();
public LoadBankers() {
    new rows = cache_num_rows();
    if (rows) {
        new id, label_string[64];
        for (new i; i < rows; i++) {
            cache_get_value_name_int(i, "ID", id);
            cache_get_value_name_int(i, "Skin", BankerData[id][Skin]);
            cache_get_value_name_float(i, "PosX", BankerData[id][bankerX]);
            cache_get_value_name_float(i, "PosY", BankerData[id][bankerY]);
            cache_get_value_name_float(i, "PosZ", BankerData[id][bankerZ]);
            cache_get_value_name_float(i, "PosA", BankerData[id][bankerA]);
            cache_get_value_name(i, "Anim_Lib", BankerData[id][anim_lib], .max_len = 50);
            cache_get_value_name(i, "Anim_Name", BankerData[id][anim_name], .max_len = 50);
            cache_get_value_name_int(i, "Anim_Loop", BankerData[id][anim_loop]);

            BankerData[id][bankerActorID] = CreateDynamicActor(BankerData[id][Skin], BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA], .worldid = 0);
            if (!IsValidDynamicActor(BankerData[id][bankerActorID])) printf("  [Bank System] Couldn't create an actor for banker ID %d.", id);
            ApplyDynamicActorAnimation(BankerData[id][bankerActorID], BankerData[id][anim_lib], BankerData[id][anim_name], 4.1, BankerData[id][anim_loop], 0, 0, 1, 0);
            BankerData[id][bankerIconID] = CreateDynamicMapIcon(BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], 58, 0, .streamdistance = BANKER_ICON_RANGE);

            format(label_string, sizeof(label_string), "Banker (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open bank menu!!", id);
            BankerData[id][bankerLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ] + 0.25, 5.0);

            Iter_Add(Bankers, id);
        }
    }
    printf("  [Bank System] Loaded %d bankers.", Iter_Count(Bankers));
    return 1;
}

forward LoadATMs();
public LoadATMs() {
    new rows = cache_num_rows();
    if (rows) {
        new id, label_string[64];
        new dataArray[E_ATMDATA];

        for (new i; i < rows; i++) {
            cache_get_value_name_int(i, "ID", id);
            cache_get_value_name_float(i, "PosX", ATMData[id][atmX]);
            cache_get_value_name_float(i, "PosY", ATMData[id][atmY]);
            cache_get_value_name_float(i, "PosZ", ATMData[id][atmZ]);
            cache_get_value_name_float(i, "RotX", ATMData[id][atmRX]);
            cache_get_value_name_float(i, "RotY", ATMData[id][atmRY]);
            cache_get_value_name_float(i, "RotZ", ATMData[id][atmRZ]);
            ATMData[id][atmObjID] = CreateDynamicObject(19324, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
            if (IsValidDynamicObject(ATMData[id][atmObjID])) {
                format(dataArray[IDString], 8, "atm_sys");
                dataArray[refID] = id;
                Streamer_SetArrayData(STREAMER_TYPE_OBJECT, ATMData[id][atmObjID], E_STREAMER_EXTRA_ID, dataArray);
            } else printf("  [Bank System] Couldn't create an ATM object for ATM ID %d.", id);
            ATMData[id][atmIconID] = CreateDynamicMapIcon(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], 52, 0, .streamdistance = ATM_ICON_RANGE);
            format(label_string, sizeof(label_string), "ATM (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open atm menu!", id);
            ATMData[id][atmLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ] + 0.85, 5.0);

            Iter_Add(ATMs, id);
        }
    }
    printf("  [Bank System] Loaded %d ATMs.", Iter_Count(ATMs));
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "lastAtmRobbery", "int", "0");
    new query[512];

    for (new i; i < MAX_BANKERS; i++) {
        BankerData[i][bankerActorID] = -1;
        BankerData[i][bankerIconID] = -1;
        BankerData[i][bankerLabel] = Text3D:  - 1;
    }

    for (new i; i < MAX_ATMS; i++) {
        ATMData[i][atmObjID] = -1;
        ATMData[i][atmIconID] = -1;
        ATMData[i][atmTimer] = ATMData[i][atmPickup] = -1;
        ATMData[i][atmHealth] = ATM_HEALTH;
        ATMData[i][atmLabel] = Text3D:  - 1;
    }

    // create tables if they don't exist
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `bankers` (\
	  `ID` int(11) NOT NULL,\
	  `Skin` smallint(3) NOT NULL,\
	  `PosX` float NOT NULL,\
	  `PosY` float NOT NULL,\
	  `PosZ` float NOT NULL,\
	  `PosA` float NOT NULL,\
	  `Anim_Lib` VARCHAR(50) NULL DEFAULT 'PED',\
	  `Anim_Name` VARCHAR(50) NULL DEFAULT 'STAND',\
	  `Anim_Loop` tinyint(1) NULL default '0',\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `bankAtms` (\
	  `ID` int(11) NOT NULL,\
	  `PosX` float NOT NULL,\
	  `PosY` float NOT NULL,\
	  `PosZ` float NOT NULL,\
	  `RotX` float NOT NULL,\
	  `RotY` float NOT NULL,\
	  `RotZ` float NOT NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `bankAccounts` (\
	  `ID` int(11) NOT NULL auto_increment,\
	  `Owner` varchar(24) NOT NULL,\
	  `Password` varchar(32) NOT NULL,\
	  `Balance` int(11) NOT NULL default 0,\
	  `CreatedOn` int(11) NOT NULL default 0,\
	  `LastAccess` int(11) NOT NULL default 0,\
	  `Disabled` smallint(1) NOT NULL default 0,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

    mysql_format(Database, query, sizeof(query), "CREATE TABLE IF NOT EXISTS `bankTransactions` (\
	  	`ID` int(11) NOT NULL auto_increment,\
	  	`AccountID` int(11) NOT NULL,\
	  	`ToAccountID` int(11) NOT NULL default '-1',\
	  	`Type` smallint(1) NOT NULL,\
	  	`Player` varchar(24) NOT NULL,\
	  	`Amount` int(11) NOT NULL default 0,\
	  	`Date` int(11) NOT NULL,\
	  ");

    mysql_format(Database, query, sizeof(query), "%s\
 		PRIMARY KEY  (`ID`),\
 		KEY `bank_logs_ibfk_1` (`AccountID`),\
 		CONSTRAINT `bank_logs_ibfk_1` FOREIGN KEY (`AccountID`) REFERENCES `bankAccounts` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE\
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;", query);

    mysql_tquery(Database, query);

    mysql_tquery(Database, "SELECT * FROM bankers", "LoadBankers");
    mysql_tquery(Database, "SELECT * FROM bankAtms", "LoadATMs");
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:Bankers) DestroyDynamicActor(BankerData[i][bankerActorID]);
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    CurrentAccountID[playerid] = -1;
    LogListType[playerid] = TYPE_NONE;
    LogListPage[playerid] = 0;
    EditingATMID[playerid] = -1;
    return 1;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (Iter_Contains(ATMs, EditingATMID[playerid])) {
        if (response == EDIT_RESPONSE_FINAL) {
            new id = EditingATMID[playerid];
            ATMData[id][atmX] = x;
            ATMData[id][atmY] = y;
            ATMData[id][atmZ] = z;
            ATMData[id][atmRX] = rx;
            ATMData[id][atmRY] = ry;
            ATMData[id][atmRZ] = rz;

            SetDynamicObjectPos(objectid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
            SetDynamicObjectRot(objectid, ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);

            Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, ATMData[id][atmIconID], E_STREAMER_X, ATMData[id][atmX]);
            Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, ATMData[id][atmIconID], E_STREAMER_Y, ATMData[id][atmY]);
            Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, ATMData[id][atmIconID], E_STREAMER_Z, ATMData[id][atmZ]);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_X, ATMData[id][atmX]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_Y, ATMData[id][atmY]);
            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ATMData[id][atmLabel], E_STREAMER_Z, ATMData[id][atmZ] + 0.85);

            new query[512];
            mysql_format(Database, query, sizeof(query), "UPDATE bankAtms SET PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f' WHERE ID=%d", x, y, z, rx, ry, rz, id);
            mysql_tquery(Database, query);

            EditingATMID[playerid] = -1;
        }

        if (response == EDIT_RESPONSE_CANCEL) {
            new id = EditingATMID[playerid];
            SetDynamicObjectPos(objectid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
            SetDynamicObjectRot(objectid, ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
            EditingATMID[playerid] = -1;
        }
    }
    return 1;
}

hook OnPlayerShootDynObj(playerid, weaponid, objectid, Float:x, Float:y, Float:z) {
    if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 19324) {
        new dataArray[E_ATMDATA];
        Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, dataArray);
        if (strlen(dataArray[IDString]) && IsStringSame(dataArray[IDString], "atm_sys") && Iter_Contains(ATMs, dataArray[refID]) && ATMData[dataArray[refID]][atmRegen] == 0) {
            new id = dataArray[refID], string[64], Float:damage = GetWeaponDamageFromDistance(weaponid, GetPlayerDistanceFromPoint(playerid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ])) / 1.5;
            ATMData[id][atmHealth] -= damage;

            if (ATMData[id][atmHealth] < 0.0) {
                ATMData[id][atmHealth] = 0.0;

                format(string, sizeof(string), "ATM (%d)\n\n{FFFFFF}Out of Service\n{4286f4}%s", id, ConvertToMinutes(ATM_REGEN));
                UpdateDynamic3DTextLabelText(ATMData[id][atmLabel], 0x1ABC9CFF, string);

                ATMData[id][atmRegen] = ATM_REGEN;
                ATMData[id][atmTimer] = SetTimerEx("ATM_Regen", 1000, true, "i", id);
                Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID, 2943);

                new Float:a = ATMData[id][atmRZ] + 180.0;
                ATMData[id][atmPickup] = CreateDynamicPickup(1212, 1, ATMData[id][atmX] + (1.25 * floatsin(-a, degrees)), ATMData[id][atmY] + (1.25 * floatcos(-a, degrees)), ATMData[id][atmZ] - 0.25);

                if (IsValidDynamicPickup(ATMData[id][atmPickup])) {
                    new pickupDataArray[E_ATMDATA];
                    format(pickupDataArray[IDString], 8, "atm_sys");
                    pickupDataArray[refID] = id;
                    Streamer_SetArrayData(STREAMER_TYPE_PICKUP, ATMData[id][atmPickup], E_STREAMER_EXTRA_ID, pickupDataArray);
                }

                Streamer_Update(playerid);
            } else {
                format(string, sizeof(string), "ATM (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open atm menu!\n%s", id, Bank:AtmDmgText(id));
                UpdateDynamic3DTextLabelText(ATMData[id][atmLabel], 0x1ABC9CFF, string);
            }

            PlayerPlaySound(playerid, 17802, 0.0, 0.0, 0.0);
        }
    }
    return 1;
}

hook OPPickUpDynPickup(playerid, pickupid) {
    if (Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_MODEL_ID) == 1212) {
        new dataArray[E_ATMDATA];
        Streamer_GetArrayData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID, dataArray);

        if (strlen(dataArray[IDString]) && IsStringSame(dataArray[IDString], "atm_sys")) {
            if (gettime() - Database:GetInt(GetPlayerNameEx(playerid), "username", "lastAtmRobbery") < 12 * 60 * 60) return SendClientMessage(playerid, 0x3498DBFF, "ATM: {FFFFFF}wait until 12 hours to rob atm again");
            Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "lastAtmRobbery");
            new money = RandomEx(ATM_ROB_MIN, ATM_ROB_MAX), string[64];
            format(string, sizeof(string), "ATM: {FFFFFF}You stole {2ECC71}%s {FFFFFF}from the ATM.", FormatCurrencyEx(money));
            SendClientMessageEx(playerid, 0x3498DBFF, string);
            vault:PlayerVault(playerid, money, "stole from atm", Vault_ID_Government, -money, sprintf("%s stoll from atm", GetPlayerNameEx(playerid)));
            Debt:GiveOrTake(playerid, GetPercentageOf(RandomEx(50, 70), money), "Robbed from ATM", 0);
            ATMData[dataArray[refID]][atmPickup] = -1;
            DestroyDynamicPickup(pickupid);
            format(string, sizeof(string), "stole %s from the ATM", FormatCurrencyEx(money));
            WantedDatabase:GiveWantedLevel(playerid, string, Random(5, 10), false);
        }
    }
    return 1;
}

forward OnBankAccountCreated(playerid, pass[]);
public OnBankAccountCreated(playerid, pass[]) {
    vault:PlayerVault(playerid, -ACCOUNT_PRICE, "charged for new bank account", Vault_ID_Government, ACCOUNT_PRICE, sprintf("%s charged for new bank account", GetPlayerNameEx(playerid)));
    new accountid = cache_insert_id();
    SendClientMessageEx(playerid, 0x3498DBFF, "BANK: {FFFFFF}Successfully created an account for you!");
    SendClientMessageEx(playerid, 0x3498DBFF, sprintf("BANK: {FFFFFF}Your account ID:{F1C40F}%d", accountid));
    SendClientMessageEx(playerid, 0x3498DBFF, sprintf("BANK: {FFFFFF}Your account password:{F1C40F}%s", pass));
    Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountLogin(playerid, id);
public OnBankAccountLogin(playerid, id) {
    if (cache_num_rows() > 0) {
        new string[128], owner[MAX_PLAYER_NAME], last_access, ldate[24];
        cache_get_value_name(0, "Owner", owner);
        cache_get_value_name_int(0, "LastAccess", last_access);
        cache_get_value_name(0, "Last", ldate);

        format(string, sizeof(string), "BANK: {FFFFFF}This account is owned by {F1C40F}%s.", owner);
        SendClientMessageEx(playerid, 0x3498DBFF, string);
        format(string, sizeof(string), "BANK: {FFFFFF}Last Accessed On:{F1C40F}%s", (last_access == 0) ? ("Never") : ldate);
        SendClientMessageEx(playerid, 0x3498DBFF, string);

        CurrentAccountID[playerid] = id;
        Bank:ShowMenu(playerid);

        if (!IsStringSame(GetPlayerNameEx(playerid), Bank:GetOwner(CurrentAccountID[playerid]))) Discord:LogTransaction(
            sprintf(
                ":moneybag:** Transaction Alert** :moneybag:\n**Player:** %s [%d]\n\
                **Log:** logged someone else account id %d (%s)",
                GetPlayerNameEx(playerid), playerid, CurrentAccountID[playerid], Bank:GetOwner(CurrentAccountID[playerid])
            )
        );

        new query[96];
        mysql_format(Database, query, sizeof(query), "UPDATE bankAccounts SET LastAccess=UNIX_TIMESTAMP() WHERE ID=%d && Disabled=0", id);
        mysql_tquery(Database, query);

        Bank:SaveLog(playerid, TYPE_LOGIN, id, -1, 0);
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Invalid credentials."), Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountDeposit(playerid, amount);
public OnBankAccountDeposit(playerid, amount) {
    if (cache_affected_rows() > 0) {
        SendClientMessageEx(playerid, 0x3498DBFF, sprintf("BANK: {FFFFFF}Successfully deposited {2ECC71}%s.", FormatCurrencyEx(amount)));
        GivePlayerCash(playerid, -amount, sprintf("deposit in bank account %d", CurrentAccountID[playerid]), 0);
        Bank:SaveLog(playerid, TYPE_DEPOSIT, CurrentAccountID[playerid], -1, amount);
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Transaction failed.");

    Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountWithdraw(playerid, amount);
public OnBankAccountWithdraw(playerid, amount) {
    if (cache_affected_rows() > 0) {
        SendClientMessageEx(playerid, 0x3498DBFF, sprintf("BANK: {FFFFFF}Successfully withdrawn {2ECC71}%s.", FormatCurrencyEx(amount)));
        GivePlayerCash(playerid, amount, sprintf("withdrawn from bank account %d", CurrentAccountID[playerid]), 0);
        Bank:SaveLog(playerid, TYPE_WITHDRAW, CurrentAccountID[playerid], -1, -amount);
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Transaction failed.");
    Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountPassChange(playerid, newpass[]);
public OnBankAccountPassChange(playerid, newpass[]) {
    if (cache_affected_rows() > 0) {
        new string[128];
        format(string, sizeof(string), "BANK: {FFFFFF}Account password set to {F1C40F}%s.", newpass);
        SendClientMessageEx(playerid, 0x3498DBFF, string);

        Bank:SaveLog(playerid, TYPE_PASSCHANGE, CurrentAccountID[playerid], -1, 0);
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Password change failed.");
    Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountDeleted(playerid, id, amount);
public OnBankAccountDeleted(playerid, id, amount) {
    if (cache_affected_rows() > 0) {
        GivePlayerCash(playerid, amount, "deleted bank account");
        foreach(new i:Player) {
            if (i == playerid) continue;
            if (CurrentAccountID[i] == id) CurrentAccountID[i] = -1;
        }
        new string[128];
        format(string, sizeof(string), "BANK: {FFFFFF}Account removed, you got the {2ECC71}%s {FFFFFF}left in the account.", FormatCurrencyEx(amount));
        SendClientMessageEx(playerid, 0x3498DBFF, string);
    } else SendClientMessageEx(playerid, 0xE74C3CFF, "{E74C3C}[ERROR]:{FFFFEE}Account removal failed.");
    CurrentAccountID[playerid] = -1;
    Bank:ShowMenu(playerid);
    return 1;
}

forward OnBankAccountAdminEdit(playerid);
public OnBankAccountAdminEdit(playerid) {
    if (cache_affected_rows() > 0) SendClientMessageEx(playerid, 0x3498DBFF, "BANK: {FFFFFF}Account edited.");
    else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Account editing failed. (No affected rows)");
    return 1;
}

forward ATM_Regen(id);
public ATM_Regen(id) {
    new string[64];

    if (ATMData[id][atmRegen] > 1) {
        ATMData[id][atmRegen]--;
        format(string, sizeof(string), "ATM (%d)\n\n{FFFFFF}Out of Service\n{4286f4}%s", id, ConvertToMinutes(ATMData[id][atmRegen]));
        UpdateDynamic3DTextLabelText(ATMData[id][atmLabel], 0x1ABC9CFF, string);
    } else if (ATMData[id][atmRegen] == 1) {
        if (IsValidDynamicPickup(ATMData[id][atmPickup])) DestroyDynamicPickup(ATMData[id][atmPickup]);
        KillTimer(ATMData[id][atmTimer]);

        ATMData[id][atmHealth] = ATM_HEALTH;
        ATMData[id][atmRegen] = 0;
        ATMData[id][atmTimer] = ATMData[id][atmPickup] = -1;

        Streamer_SetIntData(STREAMER_TYPE_OBJECT, ATMData[id][atmObjID], E_STREAMER_MODEL_ID, 19324);

        format(string, sizeof(string), "ATM (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open atm menu!", id);
        UpdateDynamic3DTextLabelText(ATMData[id][atmLabel], 0x1ABC9CFF, string);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || newkeys != KEY_NO) return 1;
    if (Bank:GetClosestATM(playerid) != -1) {
        SetPVarInt(playerid, "usingATM", 1);
        Bank:ShowMenu(playerid);
        return ~1;
    }
    if (Bank:IsNearBanker(playerid)) {
        SetPVarInt(playerid, "usingATM", 0);
        Bank:ShowMenu(playerid);
        return ~1;
    }
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Bank System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Bank System", inputtext)) Bank:AdminShowMenu(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "bank system") || !IsPlayerMasterAdmin(playerid)) return 1;
    Bank:AdminShowMenu(playerid);
    return ~1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `bankAccounts` SET `Owner` = \"%s\" WHERE  `Owner` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `bankTransactions` SET `Player` = \"%s\" WHERE  `Player` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `bankAccounts` WHERE `Owner` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `bankTransactions` WHERE `Player` = \"%s\"", AccountName));
    return 1;
}

DC_CMD:setbankpassword(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new accountid, newpassword[100];
    if (sscanf(params, "ds[100]", accountid, newpassword)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !setbankpassword [AccountID] [new password]");
    if (!Bank:IsAccountAcitve(accountid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: invalid bank account id");
    new query[512];
    mysql_format(Database, query, sizeof(query), "UPDATE bankAccounts SET Password=md5(\"%s\") WHERE ID=%d", RemoveMalChars(newpassword), accountid);
    mysql_tquery(Database, query);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("account id %d password has been set to ``%s``", accountid, newpassword));
    return 1;
}

DC_CMD:enablebankaccount(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new accountid;
    if (sscanf(params, "d", accountid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !enablebankaccount [AccountID]");
    if (!Bank:IsValidAccountID(accountid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: invalid bank account id");
    mysql_tquery(Database, sprintf("update bankAccounts SET Disabled = 0 WHERE ID=%d", accountid));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("account id %d has been enabled", accountid));
    return 1;
}

DC_CMD:disablebankaccount(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new accountid;
    if (sscanf(params, "d", accountid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: !disablebankaccount [AccountID]");
    if (!Bank:IsValidAccountID(accountid)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]: invalid bank account id");
    mysql_tquery(Database, sprintf("update bankAccounts SET Disabled = 1 WHERE ID=%d", accountid));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("account id %d has been disabled", accountid));
    return 1;
}

stock Bank:ShowMenu(playerid) {
    new IsUsingAtm = Bank:IsUsingAtm(playerid);
    new string[2000], title[100];
    format(title, sizeof title, "{F1C40F}Bank:{FFFFFF}Menu");
    strcat(string, sprintf("My Accounts\t{F1C40F}%d\n", Bank:AccountCount(playerid)));
    if (CurrentAccountID[playerid] != -1) {
        new balance = Bank:GetBalance(CurrentAccountID[playerid]);
        format(title, sizeof title, "{F1C40F}Bank:{FFFFFF}Menu (Account ID:{F1C40F}%d{FFFFFF})", CurrentAccountID[playerid]);
        strcat(string, sprintf("Deposit\t{2ECC71}%s\n", FormatCurrency(GetPlayerCash(playerid))));
        strcat(string, sprintf("Withdraw\t{2ECC71}%s\n", FormatCurrency(balance)));
        strcat(string, sprintf("Transfer\t{2ECC71}%s\n", FormatCurrency(balance)));
        strcat(string, sprintf("{%06x}Account Logs\n", (IsUsingAtm ? -1 >>> 8 : 0xFFFFFFFF >>> 8)));
        strcat(string, sprintf("{%06x}Change Password\n", (IsUsingAtm ? -1 >>> 8 : 0xFFFFFFFF >>> 8)));
        strcat(string, sprintf("Remove Account\n"));
        strcat(string, sprintf("Logout\n"));
    } else {
        strcat(string, sprintf("{%06x}Create Account\t{2ECC71}%s\n", (IsUsingAtm ? -1 >>> 8 : 0xFFFFFFFF >>> 8), (IsUsingAtm ? ("") : FormatCurrencyEx(ACCOUNT_PRICE))));
        strcat(string, "Account Login\n");
        strcat(string, "Access Vault\n");
    }
    return FlexPlayerDialog(playerid, "BankShowMenu", DIALOG_STYLE_TABLIST, title, string, "Choose", "Close");
}

FlexDialog:BankShowMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Access Vault")) return vault:login(playerid);
    if (IsStringSame(inputtext, "Create Account")) return Bank:CreateAccount(playerid);
    if (IsStringSame(inputtext, "Account Login")) return Bank:MenuLoginAccount(playerid);
    if (IsStringSame(inputtext, "My Accounts")) return Bank:MenuMyAccounts(playerid, GetPlayerNameEx(playerid));
    if (IsStringSame(inputtext, "Deposit")) return Bank:MenuDeposit(playerid);
    if (IsStringSame(inputtext, "Withdraw")) return Bank:MenuWithdraw(playerid);
    if (IsStringSame(inputtext, "Transfer")) return Bank:MenuTransfer(playerid);
    if (IsStringSame(inputtext, "Account Logs")) return Bank:MenuAccountLogs(playerid);
    if (IsStringSame(inputtext, "Change Password")) return Bank:MenuChangePassword(playerid);
    if (IsStringSame(inputtext, "Remove Account")) return Bank:MenuRemoveAccount(playerid);
    if (IsStringSame(inputtext, "Logout")) {
        SendClientMessageEx(playerid, 0x3498DBFF, "BANK: {FFFFFF}Successfully logged out.");
        CurrentAccountID[playerid] = -1;
    }
    return Bank:ShowMenu(playerid);
}

stock Bank:MenuDeposit(playerid) {
    new accountid = CurrentAccountID[playerid];
    if (!IsAccountActive(Bank:GetOwner(accountid))) {
        AlexaMsg(playerid, "This operation is not allowed while account holder is banned from server");
        return Bank:ShowMenu(playerid);
    }

    return FlexPlayerDialog(playerid, "BankMenuDeposit", DIALOG_STYLE_INPUT, "{F1C40F}Bank: {FFFFFF}Deposit",
        sprintf("How much money do you want to deposit?\nYour cash: $%s", FormatCurrency(GetPlayerCash(playerid))),
        "Deposit", "Back"
    );
}

FlexDialog:BankMenuDeposit(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > GetPlayerCash(playerid)) return Bank:MenuDeposit(playerid);
    // max limit 99,000,000
    if (amount > (Bank:IsUsingAtm(playerid) ? 50000 : 99000000)) {
        AlexaMsg(playerid, "{4286f4}You can't deposit less than $1 or more than $99,000,000 at once. ($50,000 at once on ATMs)");
        return Bank:MenuDeposit(playerid);
    }
    if ((amount + Bank:GetBalance(CurrentAccountID[playerid])) > ACCOUNT_LIMIT) {
        AlexaMsg(playerid, "{4286f4}Account reached maximum limit, you can not deposit more money in this account");
        return Bank:MenuDeposit(playerid);
    }
    if (!IsTimePassedForPlayer(playerid, "bankdeposit", 180)) {
        AlexaMsg(playerid, sprintf(
            "{4286f4}your last transaction is pending at bank end, please try after %s",
            UnixToHumanEx(GetLastTimeForPlayer(playerid, "bankdeposit") + 180)
        ));
        return Bank:MenuDeposit(playerid);
    }

    if (amount >= 30000) Discord:LogTransaction(
        sprintf(
            ":moneybag:** Transaction Alert** :moneybag:\n**Player:** %s [%d]\n**Amount:** $%s\n\
            **Log:** deposit in account id %d (%s) %s",
            GetPlayerNameEx(playerid), playerid, FormatCurrency(amount),
            CurrentAccountID[playerid], Bank:GetOwner(CurrentAccountID[playerid]),
            amount > 99000 ? ("\n\n<@&597292999227211777> confirm the source") : ("")
        )
    );

    mysql_tquery(
        Database, sprintf("UPDATE bankAccounts SET Balance=Balance+%d WHERE ID=%d && Disabled=0", amount, CurrentAccountID[playerid]),
        "OnBankAccountDeposit", "ii", playerid, amount
    );
    return 1;
}

stock Bank:MenuWithdraw(playerid) {
    new accountid = CurrentAccountID[playerid];
    if (!IsAccountActive(Bank:GetOwner(accountid))) {
        AlexaMsg(playerid, "This operation is not allowed while account holder is banned from server");
        return Bank:ShowMenu(playerid);
    }

    return FlexPlayerDialog(playerid, "BankMenuWithdraw", DIALOG_STYLE_INPUT, "{F1C40F}Bank: {FFFFFF}Withdraw",
        sprintf("How much money do you want to withdraw?\nIn Account: $%s", FormatCurrency(Bank:GetBalance(CurrentAccountID[playerid]))),
        "Withdraw", "Back"
    );
}

FlexDialog:BankMenuWithdraw(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > Bank:GetBalance(CurrentAccountID[playerid])) return Bank:MenuWithdraw(playerid);
    // max limit 99,000,000
    if (amount > (Bank:IsUsingAtm(playerid) ? 50000 : 99000000)) {
        AlexaMsg(playerid, "{4286f4}You can't withdraw less than $1 or more than $99,000,000 at once. ($50,000 at once on ATMs)");
        return Bank:MenuWithdraw(playerid);
    }
    if (!IsTimePassedForPlayer(playerid, "bankwithdraw", 180)) {
        AlexaMsg(playerid, sprintf(
            "{4286f4}your last transaction is pending at bank end, please try after %s",
            UnixToHumanEx(GetLastTimeForPlayer(playerid, "bankwithdraw") + 180)
        ));
        return Bank:MenuWithdraw(playerid);
    }
    if (amount >= 50000) Discord:LogTransaction(
        sprintf(
            ":moneybag:** Transaction Alert** :moneybag:\n**Player:** %s [%d]\n**Amount:** $%s\n\
            **Log:** withdraw from account id %d (%s) %s",
            GetPlayerNameEx(playerid), playerid, FormatCurrency(amount),
            CurrentAccountID[playerid], Bank:GetOwner(CurrentAccountID[playerid]),
            amount > 99000 ? ("\n\n<@&597292999227211777> confirm the source") : ("")
        )
    );

    mysql_tquery(
        Database, sprintf("UPDATE bankAccounts SET Balance=Balance-%d WHERE ID=%d && Disabled=0", amount, CurrentAccountID[playerid]),
        "OnBankAccountWithdraw", "ii", playerid, amount
    );
    return 1;
}

stock Bank:MenuTransfer(playerid) {
    new accountid = CurrentAccountID[playerid];
    if (!IsAccountActive(Bank:GetOwner(accountid))) {
        AlexaMsg(playerid, "This operation is not allowed while account holder is banned from server");
        return Bank:ShowMenu(playerid);
    }

    return FlexPlayerDialog(playerid, "BankMenuTransfer", DIALOG_STYLE_INPUT, "Transfer", "Enter receipent account id", "Next", "Close");
}

FlexDialog:BankMenuTransfer(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new toaccountid;
    if (sscanf(inputtext, "d", toaccountid) || !Bank:IsAccountAcitve(toaccountid) || CurrentAccountID[playerid] == toaccountid) return Bank:MenuTransfer(playerid);
    return Bank:MenuTransferAmount(playerid, toaccountid);
}

stock Bank:MenuTransferAmount(playerid, toaccountid) {
    return FlexPlayerDialog(
        playerid, "BankMenuTransferAmount", DIALOG_STYLE_INPUT,
        "Transfer",
        sprintf("Transfer to account %d\nYour balance: $%s\n\nEnter amount and purpose to transfer\nExample: [Amount] [Purpose]", toaccountid, FormatCurrency(Bank:GetBalance(CurrentAccountID[playerid]))),
        "Transfer", "Close", toaccountid
    );
}

FlexDialog:BankMenuTransferAmount(playerid, response, listitem, const inputtext[], toaccountid, const payload[]) {
    if (!response) return Bank:MenuTransfer(playerid);
    new amount, reason[50];
    if (sscanf(inputtext, "ds[50]", amount, reason) || amount < 1 || amount > Bank:GetBalance(CurrentAccountID[playerid])) return Bank:MenuTransferAmount(playerid, toaccountid);

    if ((amount + Bank:GetBalance(toaccountid)) > ACCOUNT_LIMIT) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't deposit any more money to the account you specified.");
        return Bank:MenuTransferAmount(playerid, toaccountid);
    }

    if (!IsTimePassedForPlayer(playerid, "banktransfer", 180)) {
        AlexaMsg(playerid, sprintf(
            "{4286f4}your last transaction is pending at bank end, please try after %s",
            UnixToHumanEx(GetLastTimeForPlayer(playerid, "banktransfer") + 180)
        ));
        return Bank:MenuTransferAmount(playerid, toaccountid);
    }

    if (amount >= 50000) Discord:LogTransaction(
        sprintf(
            ":moneybag:** Bank Transaction Alert** :moneybag:\n**Player:** %s [%d]\n**Amount:** $%s\n\
            **Log:** transfered from bank account id %d (%s) to account id %d (%s)\nReason: %s%s",
            GetPlayerNameEx(playerid), playerid, FormatCurrency(amount),
            CurrentAccountID[playerid], Bank:GetOwner(CurrentAccountID[playerid]),
            toaccountid, Bank:GetOwner(toaccountid), reason,
            amount > 99000 ? ("\n\n<@&597292999227211777> confirm the source") : ("")
        )
    );

    if (!Bank:IsAccountAcitve(toaccountid)) return AlexaMsg(playerid, "Transaction failed");
    AlexaMsg(playerid, sprintf("Successfully transferred {2ECC71}%s {FFFFFF}to account ID {F1C40F}%d.", "BANK", amount, toaccountid));
    mysql_tquery(Database, sprintf("UPDATE bankAccounts SET Balance=Balance+%d WHERE ID=%d && Disabled=0", amount, toaccountid));
    mysql_tquery(Database, sprintf("UPDATE bankAccounts SET Balance=Balance-%d WHERE ID=%d && Disabled=0", amount, CurrentAccountID[playerid]));
    Bank:SaveLog(playerid, TYPE_TRANSFER, CurrentAccountID[playerid], toaccountid, -amount, RemoveMalChars(reason));
    Bank:SaveLog(playerid, TYPE_TRANSFER, toaccountid, CurrentAccountID[playerid], amount, RemoveMalChars(reason));
    return 1;
}

stock Bank:MenuAccountLogs(playerid) {
    if (Bank:IsUsingAtm(playerid)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't do this at an ATM, visit a banker.");
        return Bank:ShowMenu(playerid);
    }
    LogListType[playerid] = TYPE_NONE;
    LogListPage[playerid] = 0;
    new string[512];
    strcat(string, "Deposited Money\n");
    strcat(string, "Withdrawn Money\n");
    strcat(string, "Transfers\n");
    strcat(string, "Logins\n");
    strcat(string, "Password Changes");
    return FlexPlayerDialog(playerid, "BankMenuAccountLogs", DIALOG_STYLE_LIST, "{F1C40F}Bank:{FFFFFF}Logs", string, "Show", "Back");
}

FlexDialog:BankMenuAccountLogs(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new typelist[6] = {
        TYPE_NONE,
        TYPE_DEPOSIT,
        TYPE_WITHDRAW,
        TYPE_TRANSFER,
        TYPE_LOGIN,
        TYPE_PASSCHANGE
    };
    LogListType[playerid] = typelist[listitem + 1];
    LogListPage[playerid] = 0;
    return Bank:ViewLogs(playerid);
}

stock Bank:ViewLogs(playerid) {
    new query[196], type = LogListType[playerid], Cache:bankTransactions;
    mysql_format(Database, query, sizeof(query), "SELECT *, FROM_UNIXTIME(Date, '%%d/%%m/%%Y %%H:%%i:%%s') as ActionDate FROM bankTransactions WHERE AccountID=%d && Type=%d ORDER BY Date DESC LIMIT %d, 15", CurrentAccountID[playerid], type, LogListPage[playerid] * 15);
    bankTransactions = mysql_query(Database, query);

    new rows = cache_num_rows();
    if (rows) {
        new list[1512], title[96], name[MAX_PLAYER_NAME], date[24];
        if (type == TYPE_LOGIN) {
            format(list, sizeof(list), "By\tAction Date\n");
            format(title, sizeof(title), "{F1C40F}Bank:{FFFFFF}Login History (Page %d)", LogListPage[playerid] + 1);
        }

        if (type == TYPE_DEPOSIT) {
            format(list, sizeof(list), "By\tAmount\tDeposit Date\n");
            format(title, sizeof(title), "{F1C40F}Bank:{FFFFFF}Deposit History (Page %d)", LogListPage[playerid] + 1);
        }

        if (type == TYPE_WITHDRAW) {
            format(list, sizeof(list), "By\tAmount\tWithdraw Date\n");
            format(title, sizeof(title), "{F1C40F}Bank:{FFFFFF}Withdraw History (Page %d)", LogListPage[playerid] + 1);
        }

        if (type == TYPE_TRANSFER) {
            format(list, sizeof(list), "By\tTo Account\tAmount\tTransfer Date\n");
            format(title, sizeof(title), "{F1C40F}Bank:{FFFFFF}Transfer History (Page %d)", LogListPage[playerid] + 1);
        }

        if (type == TYPE_PASSCHANGE) {
            format(list, sizeof(list), "By\tAction Date\n");
            format(title, sizeof(title), "{F1C40F}Bank:{FFFFFF}Password Changes (Page %d)", LogListPage[playerid] + 1);
        }

        new amount, to_acc_id;
        for (new i; i < rows; ++i) {
            cache_get_value_name(i, "Player", name);
            cache_get_value_name(i, "ActionDate", date);

            if (type == TYPE_LOGIN) {
                format(list, sizeof(list), "%s%s\t%s\n", list, name, date);
            }

            if (type == TYPE_DEPOSIT) {
                cache_get_value_name_int(i, "Amount", amount);
                format(list, sizeof(list), "%s%s\t{2ECC71}%s\t%s\n", list, name, FormatCurrencyEx(amount), date);
            }

            if (type == TYPE_WITHDRAW) {
                cache_get_value_name_int(i, "Amount", amount);
                format(list, sizeof(list), "%s%s\t{2ECC71}%s\t%s\n", list, name, FormatCurrencyEx(amount), date);
            }

            if (type == TYPE_TRANSFER) {
                cache_get_value_name_int(i, "ToAccountID", to_acc_id);
                cache_get_value_name_int(i, "Amount", amount);

                format(list, sizeof(list), "%s%s\t%d\t{2ECC71}%s\t%s\n", list, name, to_acc_id, FormatCurrencyEx(amount), date);
            }

            if (type == TYPE_PASSCHANGE) {
                format(list, sizeof(list), "%s%s\t%s\n", list, name, date);
            }
        }
        FlexPlayerDialog(playerid, "BankViewLogs", DIALOG_STYLE_TABLIST_HEADERS, title, list, "Next", "Previous");
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't find any more records."), Bank:MenuAccountLogs(playerid);
    cache_delete(bankTransactions);
    return 1;
}

FlexDialog:BankViewLogs(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) {
        LogListPage[playerid]--;
        if (LogListPage[playerid] < 0) return Bank:MenuAccountLogs(playerid);
    } else LogListPage[playerid]++;
    Bank:ViewLogs(playerid);
    return 1;
}

stock Bank:MenuChangePassword(playerid) {
    return FlexPlayerDialog(playerid, "BankMenuChangePassword", DIALOG_STYLE_INPUT, "{F1C40F}Bank: {FFFFFF}Change Password", "Write a new password:", "Change", "Back");
}

FlexDialog:BankMenuChangePassword(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new password[20];
    if (sscanf(inputtext, "s[20]", password)) return Bank:MenuChangePassword(playerid);
    mysql_tquery(Database, sprintf(
        "UPDATE bankAccounts SET Password=md5(\"%s\") WHERE ID=%d && Disabled=0", password, CurrentAccountID[playerid]
    ), "OnBankAccountPassChange", "is", playerid, inputtext);
    return 1;
}

stock Bank:MenuRemoveAccount(playerid) {
    return FlexPlayerDialog(
        playerid, "BankMenuRemoveAccount", DIALOG_STYLE_MSGBOX, "{F1C40F}Bank: {FFFFFF}Remove Account",
        "Are you sure? This account will get deleted {4286f4}permanently.", "Yes", "Back"
    );
}

FlexDialog:BankMenuRemoveAccount(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new accountid = CurrentAccountID[playerid];
    mysql_tquery(
        Database, sprintf("UPDATE bankAccounts SET Disabled=1 WHERE ID=%d", accountid),
        "OnBankAccountDeleted", "iii", playerid, accountid, Bank:GetBalance(accountid)
    );
    return 1;
}

stock Bank:MenuMyAccounts(playerid, const accountName[]) {
    new Cache:get_accounts = mysql_query(Database,
        sprintf(
            "SELECT ID, Balance, LastAccess, FROM_UNIXTIME(CreatedOn, '%%d/%%m/%%Y %%H:%%i:%%s') AS Created, FROM_UNIXTIME(LastAccess, '%%d/%%m/%%Y %%H:%%i:%%s') \
            AS Last FROM bankAccounts WHERE Owner=\"%s\" && Disabled=0 ORDER BY CreatedOn DESC", accountName
        )
    );
    new rows = cache_num_rows();

    if (rows) {
        new string[512], acc_id, balance, last_access, cdate[24], ldate[24];
        format(string, sizeof(string), "ID\tBalance\tCreated On\tLast Access\n");
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", acc_id);
            cache_get_value_name_int(i, "Balance", balance);
            cache_get_value_name_int(i, "LastAccess", last_access);
            cache_get_value_name(i, "Created", cdate);
            cache_get_value_name(i, "Last", ldate);

            format(string, sizeof(string), "%s{FFFFFF}%d\t{2ECC71}%s\t{FFFFFF}%s\t%s\n", string, acc_id, FormatCurrencyEx(balance), cdate, (last_access == 0) ? ("Never") : ldate);
        }
        FlexPlayerDialog(playerid, "BankMenuMyAccounts", DIALOG_STYLE_TABLIST_HEADERS, "{F1C40F}Bank:{FFFFFF}My Accounts", string, "Login", "Back");
    } else SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You don't have any bank accounts."), Bank:ShowMenu(playerid);
    cache_delete(get_accounts);
    return 1;
}

FlexDialog:BankMenuMyAccounts(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    return Bank:MenuLoginPassword(playerid, strval(inputtext));
}

stock Bank:MenuLoginAccount(playerid) {
    if (GetPlayerScore(playerid) < 10) {
        AlexaMsg(playerid, "you can not access this feature until score 10");
        return Bank:ShowMenu(playerid);
    }
    return FlexPlayerDialog(playerid, "BankMenuLoginAccount", DIALOG_STYLE_INPUT, "{F1C40F}Bank: {FFFFFF}Login", "Account ID:", "Continue", "Cancel");
}

FlexDialog:BankMenuLoginAccount(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new accountid;
    if (sscanf(inputtext, "d", accountid)) return Bank:MenuLoginAccount(playerid);
    return Bank:MenuLoginPassword(playerid, accountid);
}

stock Bank:MenuLoginPassword(playerid, accountid) {
    return FlexPlayerDialog(playerid, "BankMenuLoginPassword", DIALOG_STYLE_PASSWORD, "{F1C40F}Bank: {FFFFFF}Login", "Account Password:", "Login", "Cancel", accountid);
}

FlexDialog:BankMenuLoginPassword(playerid, response, listitem, const inputtext[], accountid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new password[100];
    if (sscanf(inputtext, "s[100]", password)) return Bank:MenuLoginPassword(playerid, accountid);
    return mysql_tquery(Database,
        sprintf(
            "SELECT Owner, LastAccess, FROM_UNIXTIME(LastAccess, '%%d/%%m/%%Y %%H:%%i:%%s') AS Last FROM bankAccounts WHERE ID=%d && Password=md5(\"%s\") && Disabled=0 LIMIT 1",
            accountid, password
        ),
        "OnBankAccountLogin", "ii", playerid, accountid
    );
}

stock Bank:CreateAccount(playerid) {
    new IsUsingAtm = Bank:IsUsingAtm(playerid);
    if (IsUsingAtm) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't do this at an ATM, visit a banker.");
        return Bank:ShowMenu(playerid);
    }
    if (GetPlayerCash(playerid) < ACCOUNT_PRICE) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You don't have enough money to create a bank account.");
        return Bank:ShowMenu(playerid);
    }
    if (Bank:AccountCount(playerid) >= ACCOUNT_CLIMIT && !IsPlayerMasterAdmin(playerid)) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You can't create any more bank accounts.");
        return Bank:ShowMenu(playerid);
    }
    return FlexPlayerDialog(playerid, "BankCreateAccount", DIALOG_STYLE_INPUT, "{F1C40F}Bank: {FFFFFF}Create Account", "Choose a password for your new bank account:", "Create", "Back");
}

FlexDialog:BankCreateAccount(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:ShowMenu(playerid);
    new password[20];
    if (sscanf(inputtext, "s[20]", password)) return Bank:CreateAccount(playerid);
    mysql_tquery(Database, sprintf(
            "INSERT INTO bankAccounts SET Owner=\"%s\", Password=md5(\"%s\"), CreatedOn=UNIX_TIMESTAMP()",
            GetPlayerNameEx(playerid), password
        ),
        "OnBankAccountCreated", "is", playerid, password
    );
    return 1;
}

stock Bank:AdminShowMenu(playerid) {
    new string[1024];
    strcat(string, "View Player Accounts\n"); // Bank:MenuMyAccounts(playerid, const accountName[])
    strcat(string, "Direct Login Account\n");
    strcat(string, "Manage Banker\n");
    strcat(string, "Manage ATM\n");
    return FlexPlayerDialog(playerid, "BankAdminShowMenu", DIALOG_STYLE_LIST, "Bank Admin Panel", string, "Select", "Close");
}

FlexDialog:BankAdminShowMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "View Player Accounts")) return Bank:AdminMenuFindAccount(playerid);
    if (IsStringSame(inputtext, "Direct Login Account")) return Bank:AdminMenuDirectLogin(playerid);
    if (IsStringSame(inputtext, "Manage Banker")) return Bank:AdminMenuManageBanker(playerid);
    if (IsStringSame(inputtext, "Manage ATM")) return Bank:AdminMenuManageATM(playerid);
    return 1;
}

stock Bank:AdminMenuFindAccount(playerid) {
    return FlexPlayerDialog(playerid, "BankAdminMenuFindAccount", DIALOG_STYLE_INPUT, "Bank: View Accounts", "Enter player name", "Find", "Back");
}

FlexDialog:BankAdminMenuFindAccount(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new player[100];
    if (sscanf(inputtext, "s[100]", player) || !IsValidAccount(player)) return Bank:AdminMenuFindAccount(playerid);
    return Bank:MenuMyAccounts(playerid, player);
}

stock Bank:AdminMenuDirectLogin(playerid) {
    return FlexPlayerDialog(playerid, "BankAdminMenuDirectLogin", DIALOG_STYLE_INPUT, "Bank: Direct Login", "Enter bank account id", "Login", "Back");
}

FlexDialog:BankAdminMenuDirectLogin(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new accountid;
    if (sscanf(inputtext, "d", accountid) || !Bank:IsValidAccountID(accountid)) return Bank:AdminMenuDirectLogin(playerid);
    SetPVarInt(playerid, "usingATM", 0);
    CurrentAccountID[playerid] = accountid;
    return Bank:ShowMenu(playerid);
}

stock Bank:AdminMenuManageBanker(playerid) {
    new string[512];
    strcat(string, "Alter Banker\n");
    strcat(string, "Create Banker\n");
    return FlexPlayerDialog(playerid, "BankAdminMenuManageBanker", DIALOG_STYLE_LIST, "Bank Admin: Banker", string, "Select", "Close");
}

FlexDialog:BankAdminMenuManageBanker(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Alter Banker")) return Bank:AdminInputBanker(playerid);
    if (IsStringSame(inputtext, "Create Banker")) return Bank:CreateBanker(playerid);
    return 1;
}

stock Bank:AdminInputBanker(playerid) {
    return FlexPlayerDialog(playerid, "BankAdminInputBanker", DIALOG_STYLE_INPUT, "{4286f4}[Bank System]:{FFFFEE}Alter Banker", "Enter Bank BankerID to Alter", "Alter", "Close");
}

FlexDialog:BankAdminInputBanker(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new bankerid;
    if (sscanf(inputtext, "d", bankerid) || !Bank:IsValidBanker(bankerid)) return Bank:AdminInputBanker(playerid);
    return Bank:AdminManageBanker(playerid, bankerid);
}

stock Bank:AdminManageBanker(playerid, bankerid) {
    new string[512];
    strcat(string, "Change Banker Position\n");
    strcat(string, "Set Banker Skin\n");
    strcat(string, "Set Banker Animimation\n");
    strcat(string, "Remove Banker\n");
    FlexPlayerDialog(playerid, "BankAdminManageBanker", DIALOG_STYLE_LIST, "{4286f4}[Bank System]:{FFFFEE}Alter Banker", string, "Select", "Close", bankerid);
    return 1;
}

FlexDialog:BankAdminManageBanker(playerid, response, listitem, const inputtext[], bankerid, const payload[]) {
    if (!response) return Bank:AdminInputBanker(playerid);
    if (IsStringSame(inputtext, "Set Banker Skin")) return Bank:AdminBankerChangeSkin(playerid, bankerid);
    if (IsStringSame(inputtext, "Set Banker Animimation")) return Bank:AdminBankerChangeAnim(playerid, bankerid);
    if (IsStringSame(inputtext, "Change Banker Position")) {
        GetPlayerPos(playerid, BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ]);
        GetPlayerFacingAngle(playerid, BankerData[bankerid][bankerA]);
        DestroyDynamicActor(BankerData[bankerid][bankerActorID]);
        BankerData[bankerid][bankerActorID] = CreateDynamicActor(BankerData[bankerid][Skin], BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA], .worldid = 0);
        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[bankerid][bankerIconID], E_STREAMER_X, BankerData[bankerid][bankerX]);
        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[bankerid][bankerIconID], E_STREAMER_Y, BankerData[bankerid][bankerY]);
        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[bankerid][bankerIconID], E_STREAMER_Z, BankerData[bankerid][bankerZ]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[bankerid][bankerLabel], E_STREAMER_X, BankerData[bankerid][bankerX]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[bankerid][bankerLabel], E_STREAMER_Y, BankerData[bankerid][bankerY]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[bankerid][bankerLabel], E_STREAMER_Z, BankerData[bankerid][bankerZ]);
        SetPlayerPosEx(playerid, BankerData[bankerid][bankerX] + (1.0 * floatsin(-BankerData[bankerid][bankerA], degrees)), BankerData[bankerid][bankerY] + (1.0 * floatcos(-BankerData[bankerid][bankerA], degrees)), BankerData[bankerid][bankerZ]);
        new query[512];
        mysql_format(Database, query, sizeof(query), "UPDATE bankers SET PosX='%f', PosY='%f', PosZ='%f', PosA='%f' WHERE ID=%d", BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA], bankerid);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}Banker Position Changed");
        return Bank:AdminManageBanker(playerid, bankerid);
    }
    if (IsStringSame(inputtext, "Remove Banker")) {
        if (IsValidDynamicActor(BankerData[bankerid][bankerActorID])) DestroyDynamicActor(BankerData[bankerid][bankerActorID]);
        BankerData[bankerid][bankerActorID] = -1;
        if (IsValidDynamicMapIcon(BankerData[bankerid][bankerIconID])) DestroyDynamicMapIcon(BankerData[bankerid][bankerIconID]);
        BankerData[bankerid][bankerIconID] = -1;
        if (IsValidDynamic3DTextLabel(BankerData[bankerid][bankerLabel])) DestroyDynamic3DTextLabel(BankerData[bankerid][bankerLabel]);
        BankerData[bankerid][bankerLabel] = Text3D:  - 1;
        Iter_Remove(Bankers, bankerid);
        new query[48];
        mysql_format(Database, query, sizeof(query), "DELETE FROM bankers WHERE ID=%d", bankerid);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}Banker Removed");
        return Bank:AdminMenuManageBanker(playerid);
    }
    return 1;
}

stock Bank:CreateBanker(playerid) {
    return FlexPlayerDialog(playerid, "BankCreateBanker", DIALOG_STYLE_INPUT, "{4286f4}[Bank System]:{FFFFEE}Create Banker", "Enter SkinID for Banker", "Create", "Close");
}

FlexDialog:BankCreateBanker(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:AdminMenuManageBanker(playerid);
    new bankerid = Iter_Free(Bankers);
    if (bankerid == INVALID_ITERATOR_SLOT) {
        SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't create any more bankers.");
        return Bank:CreateBanker(playerid);
    }
    new skin;
    if (sscanf(inputtext, "d", skin) || skin < 0 || skin > 311) return Bank:CreateBanker(playerid);
    BankerData[bankerid][Skin] = skin;
    GetPlayerPos(playerid, BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ]);
    GetPlayerFacingAngle(playerid, BankerData[bankerid][bankerA]);
    SetPlayerPosEx(playerid, BankerData[bankerid][bankerX] + (1.0 * floatsin(-BankerData[bankerid][bankerA], degrees)), BankerData[bankerid][bankerY] + (1.0 * floatcos(-BankerData[bankerid][bankerA], degrees)), BankerData[bankerid][bankerZ]);
    BankerData[bankerid][bankerActorID] = CreateDynamicActor(BankerData[bankerid][Skin], BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA], .worldid = 0);
    BankerData[bankerid][bankerIconID] = CreateDynamicMapIcon(BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], 58, 0, .streamdistance = BANKER_ICON_RANGE);
    new label_string[64];
    format(label_string, sizeof(label_string), "Banker (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open bank menu!!", bankerid);
    BankerData[bankerid][bankerLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ] + 0.25, 5.0);
    new query[256];
    mysql_format(Database, query, sizeof(query), "INSERT INTO bankers SET ID=%d, Skin=%d, PosX='%f', PosY='%f', PosZ='%f', PosA='%f'", bankerid, skin, BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA]);
    mysql_tquery(Database, query);
    Iter_Add(Bankers, bankerid);
    SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}Banker Created");
    return Bank:AdminManageBanker(playerid, bankerid);
}

stock Bank:AdminBankerChangeSkin(playerid, bankerid) {
    return FlexPlayerDialog(playerid, "BankAdminBankerChangeSkin", DIALOG_STYLE_INPUT, "{4286f4}[Bank System]:{FFFFEE}Alter Banker", "Enter Banker SkinID", "Alter", "Close", bankerid);
}

FlexDialog:BankAdminBankerChangeSkin(playerid, response, listitem, const inputtext[], bankerid, const payload[]) {
    if (!response) return Bank:AdminManageBanker(playerid, bankerid);
    new skinid;
    if (sscanf(inputtext, "d", skinid) || skinid < 0 || skinid > 311) return Bank:AdminBankerChangeSkin(playerid, bankerid);
    BankerData[bankerid][Skin] = skinid;
    if (IsValidDynamicActor(BankerData[bankerid][bankerActorID])) DestroyDynamicActor(BankerData[bankerid][bankerActorID]);
    BankerData[bankerid][bankerActorID] = CreateDynamicActor(BankerData[bankerid][Skin], BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA], .worldid = 0);
    new query[48];
    mysql_format(Database, query, sizeof(query), "UPDATE bankers SET Skin=%d WHERE ID=%d", BankerData[bankerid][Skin], bankerid);
    mysql_tquery(Database, query);
    SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}Banker Skin Updated");
    return Bank:AdminManageBanker(playerid, bankerid);
}

stock Bank:AdminBankerChangeAnim(playerid, bankerid) {
    return FlexPlayerDialog(playerid, "BankAdminBankerChangeAnim", DIALOG_STYLE_INPUT, "{4286f4}[Bank System]:{FFFFEE}Alter Banker", "Enter Banker Animation\n[AnimLib] [AnimName] [AnimLoop]", "Alter", "Close", bankerid);
}

FlexDialog:BankAdminBankerChangeAnim(playerid, response, listitem, const inputtext[], bankerid, const payload[]) {
    if (!response) return Bank:AdminManageBanker(playerid, bankerid);
    new animlib[50], animname[50], loop;
    if (sscanf(inputtext, "s[50]s[50]d", animlib, animname, loop)) return Bank:AdminBankerChangeAnim(playerid, bankerid);
    BankerData[bankerid][anim_lib] = animlib;
    BankerData[bankerid][anim_name] = animname;
    BankerData[bankerid][anim_loop] = loop;
    if (IsValidDynamicActor(BankerData[bankerid][bankerActorID])) DestroyDynamicActor(BankerData[bankerid][bankerActorID]);
    BankerData[bankerid][bankerActorID] = CreateDynamicActor(BankerData[bankerid][Skin], BankerData[bankerid][bankerX], BankerData[bankerid][bankerY], BankerData[bankerid][bankerZ], BankerData[bankerid][bankerA], .worldid = 0);
    ApplyDynamicActorAnimation(BankerData[bankerid][bankerActorID], BankerData[bankerid][anim_lib], BankerData[bankerid][anim_name], 4.1, BankerData[bankerid][anim_loop], 0, 0, 0, 0);
    new query[512];
    mysql_format(Database, query, sizeof(query), "UPDATE bankers SET `Anim_Lib`=\"%s\", `Anim_Name`=\"%s\", `Anim_Loop`='%d' WHERE ID=%d", animlib, animname, loop, bankerid);
    mysql_tquery(Database, query);
    SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}Banker Animation Updated");
    return Bank:AdminManageBanker(playerid, bankerid);
}

stock Bank:AdminMenuManageATM(playerid) {
    new string[512];
    strcat(string, "Alter ATM\n");
    strcat(string, "Create ATM\n");
    return FlexPlayerDialog(playerid, "BankAdminMenuManageATM", DIALOG_STYLE_LIST, "Bank Admin: ATM", string, "Select", "Close");
}

FlexDialog:BankAdminMenuManageATM(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:AdminShowMenu(playerid);
    if (IsStringSame(inputtext, "Alter ATM")) return Bank:AdminInputAtmID(playerid);
    if (IsStringSame(inputtext, "Create ATM")) {
        new atmid = Iter_Free(ATMs);
        if (atmid == INVALID_ITERATOR_SLOT) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}Can't create any more ATMs.");
            return ~1;
        }
        ATMData[atmid][atmRX] = ATMData[atmid][atmRY] = 0.0;
        GetPlayerPos(playerid, ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ]);
        GetPlayerFacingAngle(playerid, ATMData[atmid][atmRZ]);
        ATMData[atmid][atmX] += (2.0 * floatsin(-ATMData[atmid][atmRZ], degrees));
        ATMData[atmid][atmY] += (2.0 * floatcos(-ATMData[atmid][atmRZ], degrees));
        ATMData[atmid][atmZ] -= 0.3;
        ATMData[atmid][atmObjID] = CreateDynamicObject(19324, ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ], ATMData[atmid][atmRX], ATMData[atmid][atmRY], ATMData[atmid][atmRZ]);
        if (IsValidDynamicObject(ATMData[atmid][atmObjID])) {
            new dataArray[E_ATMDATA];
            format(dataArray[IDString], 8, "atm_sys");
            dataArray[refID] = atmid;
            Streamer_SetArrayData(STREAMER_TYPE_OBJECT, ATMData[atmid][atmObjID], E_STREAMER_EXTRA_ID, dataArray);
            EditingATMID[playerid] = atmid;
            EditDynamicObject(playerid, ATMData[atmid][atmObjID]);
        }
        ATMData[atmid][atmIconID] = CreateDynamicMapIcon(ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ], 52, 0, .streamdistance = ATM_ICON_RANGE);
        new label_string[64];
        format(label_string, sizeof(label_string), "ATM (%d)\n\n{FFFFFF}press {F1C40F}N{FFFFFF} to open atm menu!", atmid);
        ATMData[atmid][atmLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ] + 0.85, 5.0);
        new query[512];
        mysql_format(Database, query, sizeof(query), "INSERT INTO bankAtms SET ID=%d, PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f'", atmid, ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ], ATMData[atmid][atmRX], ATMData[atmid][atmRY], ATMData[atmid][atmRZ]);
        mysql_tquery(Database, query);
        Iter_Add(ATMs, atmid);
        SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}ATM Created");
        return 1;
    }
    return 1;
}

stock Bank:AdminInputAtmID(playerid) {
    return FlexPlayerDialog(playerid, "BankAdminInputAtmID", DIALOG_STYLE_INPUT, "{4286f4}[Bank System]:{FFFFEE}Alter ATM", "Enter Bank ATM ID to Alter", "Alter", "Close");
}

FlexDialog:BankAdminInputAtmID(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Bank:AdminMenuManageATM(playerid);
    new atmid;
    if (sscanf(inputtext, "d", atmid) || !Bank:IsValidATM(atmid)) return Bank:AdminInputAtmID(playerid);
    return Bank:AdminManageAtmID(playerid, atmid);
}

stock Bank:AdminManageAtmID(playerid, atmid) {
    new string[512];
    strcat(string, "Edit Mode\n");
    strcat(string, "Remove ATM\n");
    return FlexPlayerDialog(playerid, "BankAdminManageATM", DIALOG_STYLE_LIST, "{4286f4}[Bank System]:{FFFFEE}Alter ATM", string, "Select", "Close", atmid);
}

FlexDialog:BankAdminManageATM(playerid, response, listitem, const inputtext[], atmid, const payload[]) {
    if (!response) return Bank:AdminInputAtmID(playerid);
    if (IsStringSame(inputtext, "Edit Mode")) {
        if (!IsPlayerInRangeOfPoint(playerid, 30.0, ATMData[atmid][atmX], ATMData[atmid][atmY], ATMData[atmid][atmZ])) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're not near the ATM you want to edit.");
            return Bank:AdminManageAtmID(playerid, atmid);
        }
        if (EditingATMID[playerid] != -1) return SendClientMessageEx(playerid, -1, "{4286f4}[Error]:{FFFFEE}You're already editing an ATM.");
        EditingATMID[playerid] = atmid;
        EditDynamicObject(playerid, ATMData[atmid][atmObjID]);
        SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE} you are now in Edit Mode");
        return 1;
    }
    if (IsStringSame(inputtext, "Remove ATM")) {
        if (IsValidDynamicObject(ATMData[atmid][atmObjID])) DestroyDynamicObjectEx(ATMData[atmid][atmObjID]);
        ATMData[atmid][atmObjID] = -1;
        if (IsValidDynamicMapIcon(ATMData[atmid][atmIconID])) DestroyDynamicMapIcon(ATMData[atmid][atmIconID]);
        ATMData[atmid][atmIconID] = -1;
        if (IsValidDynamic3DTextLabel(ATMData[atmid][atmLabel])) DestroyDynamic3DTextLabel(ATMData[atmid][atmLabel]);
        ATMData[atmid][atmLabel] = Text3D:  - 1;
        if (ATMData[atmid][atmTimer] != -1) KillTimer(ATMData[atmid][atmTimer]);
        ATMData[atmid][atmTimer] = -1;
        if (IsValidDynamicPickup(ATMData[atmid][atmPickup])) DestroyDynamicPickup(ATMData[atmid][atmPickup]);
        ATMData[atmid][atmPickup] = -1;
        ATMData[atmid][atmHealth] = ATM_HEALTH;
        ATMData[atmid][atmRegen] = 0;
        Iter_Remove(ATMs, atmid);
        new query[48];
        mysql_format(Database, query, sizeof(query), "DELETE FROM bankAtms WHERE ID=%d", atmid);
        mysql_tquery(Database, query);
        SendClientMessageEx(playerid, -1, "{4286f4}[Bank System]:{FFFFEE}ATM Removed");
        return Bank:AdminMenuManageATM(playerid);
    }
    return 1;
}