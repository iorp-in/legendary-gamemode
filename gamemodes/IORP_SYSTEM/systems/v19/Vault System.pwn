#define MaxVault 20

enum vault:dataenum {
    vault:balance,
    vault:name[50],
    vault:owner[50],
    vault:password[50],
    bool:vault:status
}
new vault:data[MaxVault][vault:dataenum];
new Iterator:vaults < MaxVault > ;

hook OnGameModeInit() {
    new query[1024];
    mysql_format(Database, query, sizeof(query), "CREATE TABLE IF NOT EXISTS `vaults` (\
	  	`ID` int(11) NOT NULL,\
	  	`Balance` int(11) NOT NULL,\
	  	`Status` int(11) NOT NULL,\
	  	`Name` text NOT NULL,\
	  	`Owner` text NOT NULL,\
	  	`Password` text NOT NULL,\
	  	`Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
        PRIMARY KEY  (`ID`))");
    mysql_tquery(Database, query);

    mysql_format(Database, query, sizeof(query), "CREATE TABLE IF NOT EXISTS `vaultTransactions` (\
	  	`ID` int(11) NOT NULL auto_increment,\
	  	`VaultID` int(11) NOT NULL,\
	  	`Type` int(11) NOT NULL,\
	  	`Amount` int(11) NOT NULL,\
	  	`Log` text NOT NULL,\
	  	`Date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
        PRIMARY KEY  (`ID`))");
    mysql_tquery(Database, query);

    mysql_tquery(Database, "SELECT * FROM `vaults`", "LoadVaults");
    return 1;
}

forward LoadVaults();
public LoadVaults() {
    new rows = cache_num_rows();
    new id, loaded;
    if (rows) {
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", id);
            cache_get_value_name_int(loaded, "Balance", vault:data[id][vault:balance]);
            cache_get_value_name_int(loaded, "Status", vault:data[id][vault:status]);
            cache_get_value_name(loaded, "Name", vault:data[id][vault:name], 50);
            cache_get_value_name(loaded, "Owner", vault:data[id][vault:owner], 50);
            cache_get_value_name(loaded, "Password", vault:data[id][vault:password], 50);
            Iter_Add(vaults, id);
            loaded++;
        }
    }
    printf("  [vaults] %d loaded.", loaded);
    return 1;
}

stock vault:isValidID(id) {
    return Iter_Contains(vaults, id);
}

stock vault:add() {
    new id = Iter_Free(vaults);
    if (id == INVALID_ITERATOR_SLOT) return -1;
    vault:data[id][vault:balance] = 0;
    vault:data[id][vault:status] = true;
    format(vault:data[id][vault:name], 50, "-");
    format(vault:data[id][vault:owner], 50, "-");
    format(vault:data[id][vault:password], 50, "-");
    mysql_tquery(Database, sprintf("INSERT INTO vaults (ID, Balance, Status, Name, Owner, Password) VALUES (%d, %d, %d, \"%s\", \"%s\", \"%s\")",
        id, vault:data[id][vault:balance], vault:data[id][vault:status], vault:data[id][vault:name], vault:data[id][vault:owner], vault:data[id][vault:password]));
    Iter_Add(vaults, id);
    return id;
}

stock vault:remove(id) {
    if (!vault:isValidID(id)) return 0;
    vault:data[id][vault:balance] = 0;
    vault:data[id][vault:status] = false;
    format(vault:data[id][vault:name], 50, "-");
    format(vault:data[id][vault:owner], 50, "-");
    format(vault:data[id][vault:password], 50, "-");
    mysql_tquery(Database, sprintf("delete from vaults where ID = %d", id));
    Iter_Remove(vaults, id);
    return 1;
}

stock vault:save(id) {
    if (!vault:isValidID(id)) return 0;
    mysql_tquery(Database, sprintf("update vaults set Balance = %d, Status = %d, Name = \"%s\", Owner = \"%s\", Password = \"%s\" where ID = %d",
        vault:data[id][vault:balance], vault:data[id][vault:status], vault:data[id][vault:name], vault:data[id][vault:owner], vault:data[id][vault:password], id));
    return 1;
}

stock vault:setstatus(id, bool:status) {
    if (!vault:isValidID(id)) return 0;
    vault:data[id][vault:status] = bool:status;
    vault:save(id);
    return 1;
}

stock vault:getstatus(id) {
    if (!vault:isValidID(id)) return false;
    return vault:data[id][vault:status];
}

stock vault:getBalance(id) {
    if (!vault:isValidID(id)) return false;
    return vault:data[id][vault:balance];
}

stock vault:updateOwner(id, const owner[]) {
    if (!vault:isValidID(id)) return 0;
    format(vault:data[id][vault:owner], 50, "%s", owner);
    vault:save(id);
    return 1;
}

stock vault:updateName(id, const newname[]) {
    if (!vault:isValidID(id)) return 0;
    format(vault:data[id][vault:name], 50, "%s", newname);
    vault:save(id);
    return 1;
}

stock vault:GetName(id) {
    new string[50] = "Unknown";
    if (vault:isValidID(id)) format(string, sizeof string, "%s", vault:data[id][vault:name]);
    return string;
}

stock vault:isValidPassword(id, const password[]) {
    if (!vault:isValidID(id)) return 0;
    if (IsStringSame(vault:data[id][vault:password], password)) return 1;
    return 0;
}

stock vault:updatePasword(id, const password[]) {
    if (!vault:isValidID(id)) return 0;
    format(vault:data[id][vault:password], 50, "%s", password);
    vault:save(id);
    return 1;
}

stock vault:addcash(id, cash, type, const log[]) {
    if (!vault:isValidID(id)) return 0;
    vault:data[id][vault:balance] = vault:data[id][vault:balance] + cash;
    vault:save(id);
    mysql_tquery(Database, sprintf("INSERT INTO vaultTransactions (VaultID, Type, Amount, Log) VALUES (%d, %d, %d, \"%s\")", id, type, cash, log));
    return 1;
}

stock vault:PlayerVault(playerid, playeramount, const playerlog[], vaultid, vaultamount, const vaultlog[]) {
    if (!IsPlayerConnected(playerid)) {
        SendAdminLogMessage(sprintf("invalid vault [%d] transfer occured due inactive playerid [%d], investigation required", vaultid, playerid), true);
        SendAdminLogMessage(sprintf("[Player Log]: %s", playerlog), true);
        return 0;
    }
    if (!vault:isValidID(vaultid)) {
        SendAdminLogMessage(sprintf("invalid vault [%d] transfer occured, investigation required", vaultid), true);
        return 0;
    }
    GivePlayerCash(playerid, playeramount, playerlog);
    vault:addcash(vaultid, vaultamount, Vault_Transaction_Cash_To_Vault, vaultlog);
    return 1;
}

stock vault:login(playerid) {
    FlexPlayerDialog(playerid, "VaultLoginInput", DIALOG_STYLE_INPUT, "Vault: Login", "Enter vault id", "Submit", "Close");
    return 1;
}

FlexDialog:VaultLoginInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new vaultid;
    if (sscanf(inputtext, "d", vaultid) || !vault:isValidID(vaultid)) return vault:login(playerid);
    return vault:LoginPassInput(playerid, vaultid);
}

vault:LoginPassInput(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "VaultLoginPassInput", DIALOG_STYLE_INPUT, "Vault: Login", "Enter vault password", "Submit", "Close", vaultid);
}

FlexDialog:VaultLoginPassInput(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:login(playerid);
    new password[50];
    if (sscanf(inputtext, "s[50]", password) || !vault:isValidPassword(vaultid, password)) return vault:LoginPassInput(playerid, vaultid);
    return vault:access(playerid, vaultid);
}

stock vault:access(playerid, vaultid) {
    if (!vault:isValidID(vaultid)) return 0;
    new string[512];
    strcat(string, sprintf("Vault ID\t%d\n", vaultid));
    strcat(string, sprintf("Name\t%s\n", vault:data[vaultid][vault:name]));
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(vault:data[vaultid][vault:balance])));
    strcat(string, sprintf("Owner\t%s\n", vault:data[vaultid][vault:owner]));
    strcat(string, sprintf("Password\t%s\n", vault:data[vaultid][vault:password]));
    strcat(string, sprintf("Transfer\tFund\n"));
    strcat(string, sprintf("View\tLogs\n"));
    return FlexPlayerDialog(playerid, "VaultAccessMenu", DIALOG_STYLE_TABLIST, "Vault: Access", string, "Select", "Close", vaultid);
}

FlexDialog:VaultAccessMenu(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Password")) return vault:PasswordUpdateInput(playerid, vaultid);
    if (IsStringSame(inputtext, "Transfer")) return vault:transfer(playerid, vaultid);
    if (IsStringSame(inputtext, "View")) return vault:logview(playerid, vaultid);
    vault:access(playerid, vaultid);
    return 1;
}

vault:PasswordUpdateInput(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "VaultPasswordUpdateInput", DIALOG_STYLE_INPUT, "Vault: Password", "Enter new password for vault", "Submit", "Close", vaultid);
}

FlexDialog:VaultPasswordUpdateInput(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:access(playerid, vaultid);
    new vault_password[50];
    if (sscanf(inputtext, "s[50]", vault_password)) return vault:PasswordUpdateInput(playerid, vaultid);
    vault:updatePasword(vaultid, vault_password);
    vault:access(playerid, vaultid);
    return 1;
}

stock vault:GetLogsCount(vaultid) {
    new total = 0, Cache:vaultLogs = mysql_query(Database, sprintf("SELECT COUNT(*) as total FROM vaultTransactions where VaultID = %d", vaultid));
    new rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "total", total);
    cache_delete(vaultLogs);
    return total;
}

stock vault:logview(playerid, vaultid, page = 1, totalRows = -1, perPageRow = 10) {
    if (page == 1 && totalRows == -1) totalRows = vault:GetLogsCount(vaultid);
    if (totalRows == 0) {
        SendClientMessage(playerid, -1, "{4286f4}[Vault System]:{FFFFEE} vault does not have any transaction logs yet");
        vault:access(playerid, vaultid);
        return 1;
    }
    new leftRows = totalRows - (perPageRow * page);
    new skip = (page - 1) * perPageRow;
    new Cache:vaultLogs = mysql_query(Database, sprintf("select *, DATE_FORMAT(Date, '%%d/%%m/%%Y %%H:%%i:%%s') as ActionDate from vaultTransactions where VaultID = %d order by Date desc limit %d, %d", vaultid, skip, perPageRow));
    new rows = cache_num_rows();
    new string[2000];
    strcat(string, "Amount\tDetails\tTime\n");
    if (rows) {
        new amount, logx[150], time[100];
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "Amount", amount);
            cache_get_value_name(i, "Log", logx);
            cache_get_value_name(i, "ActionDate", time);
            strcat(string, sprintf("$%s\t%s\t%s\n", FormatCurrency(amount), logx, time));
        }
    }
    cache_delete(vaultLogs);
    if (leftRows > 0 && totalRows > perPageRow) strcat(string, "Next Page\n");
    if (page > 1) strcat(string, "Back Page");
    FlexPlayerDialog(playerid, "VaultLogView", DIALOG_STYLE_TABLIST_HEADERS, "Vaults: List", string, "Select", "Cancel", page, sprintf("%d %d", vaultid, totalRows));
    return 1;
}

FlexDialog:VaultLogView(playerid, response, listitem, const inputtext[], page, const payload[]) {
    new vaultid, totalrow;
    sscanf(payload, "dd", vaultid, totalrow);
    if (!response) return vault:access(playerid, vaultid);
    if (IsStringSame(inputtext, "Next Page")) return vault:logview(playerid, vaultid, page + 1, totalrow);
    if (IsStringSame(inputtext, "Back Page")) return vault:logview(playerid, vaultid, page - 1, totalrow);
    vault:logview(playerid, vaultid, page);
    return 1;
}

stock vault:transfer(playerid, vaultid) {
    if (!vault:isValidID(vaultid)) return 0;
    new string[512];
    strcat(string, "Vault to Vault\n");
    strcat(string, "Cash to Vault\n");
    strcat(string, "Vault to Cash\n");
    FlexPlayerDialog(playerid, "VaultTransferMenu", DIALOG_STYLE_TABLIST, "Vault: Transfer", string, "Select", "Close", vaultid);
    return 1;
}

FlexDialog:VaultTransferMenu(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:access(playerid, vaultid);
    if (IsStringSame(inputtext, "Vault to Vault")) return vault:MenuVaultoVault(playerid, vaultid);
    if (IsStringSame(inputtext, "Cash to Vault")) return vault:MenuCastoVault(playerid, vaultid);
    if (IsStringSame(inputtext, "Vault to Cash")) return vault:MenuVaultoCash(playerid, vaultid);
    return 1;
}

vault:MenuVaultoVault(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "MenuVaultoVault", DIALOG_STYLE_INPUT, "Vault Transfer: Vault to Vault", "Enter Beneficiary [Vault ID] [Amount] [Reason]", "Submit", "Close", vaultid);
}

FlexDialog:MenuVaultoVault(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:transfer(playerid, vaultid);
    new toVaultId, cash, reason[50];
    if (
        sscanf(inputtext, "dds[50]", toVaultId, cash, reason) ||
        !vault:isValidID(toVaultId) || toVaultId == vaultid || cash < 1 ||
        vault:getBalance(vaultid) < cash
    ) return vault:MenuVaultoVault(playerid, vaultid);
    Discord:LogVault(sprintf(":money_with_wings: **%s transfered $%s to vault %s [%d] from vault %s [%d]**\nReason: ``%s``", GetPlayerNameEx(playerid), FormatCurrency(cash), vault:GetName(toVaultId), toVaultId, vault:GetName(vaultid), vaultid, reason));
    vault:addcash(toVaultId, cash, Vault_Transaction_Vault_To_Vault, sprintf("deposited in vault %d from vault %d by %s, Reason: %s", toVaultId, vaultid, GetPlayerNameEx(playerid), reason));
    vault:addcash(vaultid, -cash, Vault_Transaction_Vault_To_Vault, sprintf("deposited in vault %d from vault %d by %s, Reason: %s", toVaultId, vaultid, GetPlayerNameEx(playerid), reason));
    return vault:access(playerid, vaultid);
}

vault:MenuCastoVault(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "MenuCastoVault", DIALOG_STYLE_INPUT, "Vault Transfer: Cash to Vault", "Enter [amount] [reason]", "Submit", "Close", vaultid);
}

FlexDialog:MenuCastoVault(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:transfer(playerid, vaultid);
    new cash, reason[50];
    if (sscanf(inputtext, "ds[50]", cash, reason) || GetPlayerCash(playerid) < cash || cash < 1) return vault:MenuCastoVault(playerid, vaultid);
    Discord:LogVault(sprintf(":money_with_wings: **%s deposited $%s in vault %s [%d]**\nReason: ``%s``", GetPlayerNameEx(playerid), FormatCurrency(cash), vault:GetName(vaultid), vaultid, reason));
    GivePlayerCash(playerid, -cash, sprintf("deposited in vault %s [%d]", vault:GetName(vaultid), vaultid));
    vault:addcash(vaultid, cash, Vault_Transaction_Cash_To_Vault, sprintf("deposited in vault %s [%d] by %s, Reason: %s", vault:GetName(vaultid), vaultid, GetPlayerNameEx(playerid), reason));
    return vault:access(playerid, vaultid);
}

vault:MenuVaultoCash(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "MenuVaultoCash", DIALOG_STYLE_INPUT, "Vault Transfer: Vault to Cash", "Enter [amount] [reason]", "Submit", "Close", vaultid);
}

FlexDialog:MenuVaultoCash(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:transfer(playerid, vaultid);
    new cash, reason[50];
    if (sscanf(inputtext, "ds[50]", cash, reason) || vault:getBalance(vaultid) < cash || cash < 1) return vault:MenuVaultoCash(playerid, vaultid);
    Discord:LogVault(sprintf(":money_with_wings: **%s withdrawal $%s from vault %s [%d]**\nReason: ``%s``", GetPlayerNameEx(playerid), FormatCurrency(cash), vault:GetName(vaultid), vaultid, reason));
    GivePlayerCash(playerid, cash, sprintf("withdrawal from vault %s [%d], Reason: %s", vault:GetName(vaultid), vaultid, reason));
    vault:addcash(vaultid, -cash, Vault_Transaction_Vault_To_Cash, sprintf("withdrawal from vault %s [%d] by %s", vault:GetName(vaultid), vaultid, GetPlayerNameEx(playerid)));
    return vault:access(playerid, vaultid);
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "vault system") || !IsPlayerMasterAdmin(playerid)) return 1;
    vault:adminpanel(playerid);
    return ~1;
}

stock vault:adminpanel(playerid) {
    new string[512];
    strcat(string, "Add New Vault\n");
    strcat(string, "Manage Vault\n");
    strcat(string, "List Vault\n");
    return FlexPlayerDialog(playerid, "VaultAdminPanel", DIALOG_STYLE_LIST, "Vault System: Admin Panel", string, "Select", "Close");
}

FlexDialog:VaultAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Add New Vault")) return vault:AdminAddInput(playerid);
    if (IsStringSame(inputtext, "Manage Vault")) return vault:AdminManageInput(playerid);
    if (IsStringSame(inputtext, "List Vault")) return vault:listvaults(playerid);
    return 1;
}

vault:AdminAddInput(playerid) {
    new id = vault:add();
    if (id == -1) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Vault System]:{FFFFEE} max limit reached"));
        return vault:adminpanel(playerid);
    }
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Vault System]:{FFFFEE}New Vault Created: %d", id));
    return vault:manage(playerid, id);
}

stock vault:listvaults(playerid, page = 1) {
    new string[2000];
    strcat(string, "VaultID\tTitle\tOwner\tStatus\n");
    new perPageRow = 10, totalRows = Iter_Count(vaults);
    if (totalRows == 0) {
        SendClientMessage(playerid, -1, "{4286f4}[Vault System]:{FFFFEE} no vault has been created yet");
        vault:adminpanel(playerid);
        return 1;
    }
    new leftRows = totalRows - (perPageRow * page);
    new skip = (page - 1) * perPageRow;
    new count = 0, skipped = 0;
    foreach(new id:vaults) {
        if (skipped != skip) {
            skipped++;
            continue;
        }
        strcat(string, sprintf("%d\t%s\t%s\t%s\n", id, vault:data[id][vault:name], vault:data[id][vault:owner], vault:data[id][vault:status] ? "{00FF00}Active{FFFFFF}" : "{FF0000}Inactive{FFFFFF}"));
        count++;
        if (count == perPageRow) break;
    }
    if (leftRows > 0 && totalRows > perPageRow) strcat(string, "Next Page");
    if (leftRows < 1 && totalRows > perPageRow && page != 1) strcat(string, "Back Page");
    FlexPlayerDialog(playerid, "VaultAdminList", DIALOG_STYLE_TABLIST_HEADERS, "Vaults: List", string, "Select", "Cancel", page);
    return 1;
}

FlexDialog:VaultAdminList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return vault:adminpanel(playerid);
    if (IsStringSame(inputtext, "Next Page")) return vault:listvaults(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return vault:listvaults(playerid, page - 1);
    return vault:manage(playerid, strval(inputtext));
}

vault:AdminManageInput(playerid) {
    return FlexPlayerDialog(playerid, "AdminManageInput", DIALOG_STYLE_INPUT, "Vault System: Admin Panel", "Enter vault id", "Submit", "Close");
}

FlexDialog:AdminManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return vault:adminpanel(playerid);
    new vault:id;
    if (sscanf(inputtext, "d", vault:id) || !vault:isValidID(vault:id)) return vault:AdminManageInput(playerid);
    return vault:manage(playerid, vault:id);
}

stock vault:manage(playerid, vaultid) {
    if (!vault:isValidID(vaultid)) return 0;
    new string[512];
    strcat(string, sprintf("Vault ID\t%d\n", vaultid));
    strcat(string, sprintf("Name\t%s\n", vault:data[vaultid][vault:name]));
    strcat(string, sprintf("Balance\t$%s\n", FormatCurrency(vault:data[vaultid][vault:balance])));
    strcat(string, sprintf("Owner\t%s\n", vault:data[vaultid][vault:owner]));
    strcat(string, sprintf("Password\t%s\n", vault:data[vaultid][vault:password]));
    strcat(string, sprintf("Access\tVault\n"));
    if (vault:data[vaultid][vault:status]) strcat(string, sprintf("Disable\tVault\n"));
    else strcat(string, sprintf("Enable\tVault\n"));
    strcat(string, sprintf("Delete\tVault\n"));
    FlexPlayerDialog(playerid, "VaultAdminManage", DIALOG_STYLE_TABLIST, "Vault System: Admin Panel", string, "Select", "Close", vaultid);
    return 1;
}

FlexDialog:VaultAdminManage(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:adminpanel(playerid);
    if (IsStringSame(inputtext, "Name")) return vault:MenuUpdateName(playerid, vaultid);
    if (IsStringSame(inputtext, "Owner")) return vault:MenuUpdateOwner(playerid, vaultid);
    if (IsStringSame(inputtext, "Password")) return vault:PasswordUpdateInput(playerid, vaultid);
    if (IsStringSame(inputtext, "Access")) return vault:access(playerid, vaultid);
    if (IsStringSame(inputtext, "Enable")) {
        vault:setstatus(vaultid, true);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Vault System]:{FFFFEE} vault %d has been activated", vaultid));
        return vault:manage(playerid, vaultid);
    }
    if (IsStringSame(inputtext, "Disable")) {
        vault:setstatus(vaultid, false);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Vault System]:{FFFFEE} vault %d has been deactivated", vaultid));
        return vault:manage(playerid, vaultid);
    }
    if (IsStringSame(inputtext, "Delete")) {
        vault:remove(vaultid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Vault System]:{FFFFEE} vault %d has been deleted", vaultid));
        return vault:adminpanel(playerid);
    }
    return vault:manage(playerid, vaultid);
}

vault:MenuUpdateName(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "VaultMenuUpdateName", DIALOG_STYLE_INPUT, "Vault System: Admin Panel", "Enter new name for vault", "Submit", "Close", vaultid);
}

FlexDialog:VaultMenuUpdateName(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:manage(playerid, vaultid);
    new vault_name[50];
    if (sscanf(inputtext, "s[50]", vault_name)) return vault:MenuUpdateName(playerid, vaultid);
    vault:updateName(vaultid, vault_name);
    return vault:manage(playerid, vaultid);
}

vault:MenuUpdateOwner(playerid, vaultid) {
    return FlexPlayerDialog(playerid, "VaultMenuUpdateOwner", DIALOG_STYLE_INPUT, "Vault System: Admin Panel", "Enter new owner for vault", "Submit", "Close", vaultid);
}

FlexDialog:VaultMenuUpdateOwner(playerid, response, listitem, const inputtext[], vaultid, const payload[]) {
    if (!response) return vault:manage(playerid, vaultid);
    new vault_owner[50];
    if (sscanf(inputtext, "s[50]", vault_owner) || !IsValidAccount(vault_owner)) return vault:MenuUpdateOwner(playerid, vaultid);
    vault:updateOwner(vaultid, vault_owner);
    return vault:manage(playerid, vaultid);
}