new WeaponLicense:dialogid;
new WeaponLicense:PlanPriceA = 3000, WeaponLicense:PlanPriceB = 6000, WeaponLicense:PlanPriceC = 10000;
enum {
    WeaponLicense:offsetApply,
    WeaponLicense:offsetShowLicense,
    WeaponLicense:offsetLaw,
    WeaponLicense:offsetViewApps,
    WeaponLicense:offsetAppResponse
}

stock WeaponLicense:IsHaveLicense(playerid) {
    return Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponLicenseIsHave");
}

stock WeaponLicense:IsLicenseExpired(playerid) {
    if (!WeaponLicense:IsHaveLicense(playerid)) return 1;
    if (gettime() > Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponLicenseExpireAt")) return 1;
    return 0;
}

stock WeaponLicense:IsHaveActiveLicense(playerid) {
    if (!WeaponLicense:IsHaveLicense(playerid)) return 0;
    if (gettime() < Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponLicenseExpireAt")) return 1;
    return 0;
}

stock WeaponLicense:GetAccountAppliedPlanID(const account[]) {
    if (!IsValidAccount(account)) return 0;
    new Cache:response_cache, total_app, weaponLicensePlan = 0;
    response_cache = mysql_query(Database, sprintf("SELECT username, WeaponLicenseApplied from playerdata where username = \"%s\"", account));
    total_app = cache_num_rows();
    if (total_app == 0) {
        cache_delete(response_cache);
        return weaponLicensePlan;
    }
    cache_get_value_name_int(0, "WeaponLicenseApplied", weaponLicensePlan);
    cache_delete(response_cache);
    return weaponLicensePlan;
}

stock WeaponLicense:TotalPendingApplications() {
    new Cache:response_cache, total_app;
    response_cache = mysql_query(Database, "SELECT username from playerdata where WeaponLicenseApplied != 0");
    total_app = cache_num_rows();
    cache_delete(response_cache);
    return total_app;
}

stock WeaponLicense:appmanage(playerid) {
    new total_app = WeaponLicense:TotalPendingApplications();
    if (total_app == 0) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} currently there is no weapon license applications active.");
        return 1;
    }
    WeaponLicense:viewApps(playerid);
    return 1;
}

stock WeaponLicense:viewApps(playerid, page = 0) {
    new string[2000];
    new Cache:response_cache, total_app;
    response_cache = mysql_query(Database, "SELECT username, WeaponLicenseApplied as plan from playerdata where WeaponLicenseApplied != 0");
    total_app = cache_num_rows();
    new paged = page * 20;
    new skip = page * 20;
    new count = 0;
    strcat(string, "Username\tPlan\n");
    for (new i; i < total_app; i++) {
        if (count >= 20) break;
        if (skip > 0) {
            skip--;
            continue;
        }
        new username[50], plan;
        cache_get_value_name(i, "username", username);
        cache_get_value_name_int(i, "plan", plan);
        strcat(string, sprintf("%s\t%s\n", username, plan == 3 ? "Long Term"
            : plan == 2 ? "Mid Term" : "Short Term"));
        count++;
    }
    if ((total_app - (paged + 20)) > 0) strcat(string, "{FFFFFF}Next Page\n");
    if (page > 0) strcat(string, "{FFFFFF}Back Page\n");
    ShowPlayerDialogEx(playerid, WeaponLicense:dialogid, WeaponLicense:offsetViewApps, DIALOG_STYLE_TABLIST_HEADERS, "SAPD: Weapon License Apps", string, "Select", "Close", page);
    cache_delete(response_cache);
    return 1;
}

stock WeaponLicense:apply(playerid) {
    new planid = WeaponLicense:GetAccountAppliedPlanID(GetPlayerNameEx(playerid));
    if (planid != 0) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you already have applied for weapon license. Wait until SAPD Officers check it.");
        return 1;
    }
    if (WeaponLicense:IsHaveActiveLicense(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you already have active weapon license. Come back when it's expire.");
        return 1;
    }
    new string[1024];
    strcat(string, "ID\tPlan Name\tExpire In\tPrice\n");
    strcat(string, sprintf("1\tShort Term\t15 Days\t$%s\n", FormatCurrency(WeaponLicense:PlanPriceA)));
    strcat(string, sprintf("2\tMid Term\t30 Days\t$%s\n", FormatCurrency(WeaponLicense:PlanPriceB)));
    strcat(string, sprintf("3\tLong Term\t60 Days\t$%s\n", FormatCurrency(WeaponLicense:PlanPriceC)));
    ShowPlayerDialogEx(playerid, WeaponLicense:dialogid, WeaponLicense:offsetApply, DIALOG_STYLE_TABLIST_HEADERS, "Weapon License: Apply", string, "Select", "Close");
    return 1;
}

stock WeaponLicense:ShowLicense(playerid, licenseof) {
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(licenseof)) return 1;
    if (!WeaponLicense:IsHaveLicense(playerid)) return 1;
    new string[1024], issuedon = Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponLicenseGrantAt"), expireat = Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponLicenseExpireAt"), issue[50], expire[50];
    UnixToHuman(issuedon, issue);
    UnixToHuman(expireat, expire);
    strcat(string, sprintf("{FFFF00}Name: {FFFFFF}%s\n", GetPlayerNameEx(licenseof)));
    strcat(string, sprintf("{FFFF00}Plan: {FFFFFF}%s\n", Database:GetString(GetPlayerNameEx(licenseof), "username", "WeaponLicensePlanName")));
    strcat(string, sprintf("{FFFF00}Issuer Officer: {FFFFFF}%s\n", Database:GetString(GetPlayerNameEx(licenseof), "username", "WeaponLicenseOfficerName")));
    strcat(string, sprintf("{FFFF00}Officer Faction: {FFFFFF}%s\n", Database:GetString(GetPlayerNameEx(licenseof), "username", "WeaponLicenseOfficerFaction")));
    strcat(string, sprintf("{FFFF00}Officer Rank: {FFFFFF}%s\n", Database:GetString(GetPlayerNameEx(licenseof), "username", "WeaponLicenseOfficerRank")));
    strcat(string, sprintf("{FFFF00}Issued On: {FFFFFF}%s\n", issue));
    strcat(string, sprintf("{FFFF00}Expire At: {FFFFFF}%s\n", expire));
    strcat(string, sprintf("{FFFF00}Status: {FFFFFF}%s\n", gettime() > expireat ? "Expired" : "Active"));
    ShowPlayerDialogEx(playerid, WeaponLicense:dialogid, WeaponLicense:offsetShowLicense, DIALOG_STYLE_MSGBOX, sprintf("Weapon License of %s", GetPlayerNameEx(licenseof)), string, "Okay", "Close");
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    if (WeaponLicense:IsHaveLicense(playerid)) UCP:AddCommand(playerid, "View Weapon License");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response || page != 1) return 1;
    if (IsStringSame("View Weapon License", inputtext)) {
        WeaponLicense:ShowLicense(playerid, playerid);
        return ~1;
    }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (WeaponLicense:IsHaveLicense(playerid)) QuickActions:AddCommand(playerid, "Show Weapon License");
    new allowedFactions[] = { 0, 1, 2, 3, 4 };
    if (IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) QuickActions:AddCommand(playerid, "Check Weapon License");
    if (IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid) && WeaponLicense:IsHaveLicense(targetid)) QuickActions:AddCommand(playerid, "Seize  Weapon License");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Show Weapon License", inputtext)) {
        WeaponLicense:ShowLicense(targetid, playerid);
        return ~1;
    }
    if (IsStringSame("Check Weapon License", inputtext)) {
        if (!WeaponLicense:IsHaveLicense(targetid)) {
            AlexaMsg(playerid, sprintf("%s does not have a weapon license", GetPlayerNameEx(targetid)));
            return ~1;
        }
        WeaponLicense:ShowLicense(playerid, targetid);
        return ~1;
    }
    if (IsStringSame("Seize  Weapon License", inputtext)) {
        mysql_tquery(Database, sprintf("update playerdata set WeaponLicenseIsHave = false where username = \"%s\"", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} your weapon license has been seized by officer %s", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have seized weapon license of %s", GetPlayerNameEx(targetid)));
        return ~1;
    }
    return 1;
}

hook GlobalOneMinuteInterval() {
    WeaponLicense:PlanPriceA = Random(2000, 3000);
    WeaponLicense:PlanPriceB = Random(3000, 6000);
    WeaponLicense:PlanPriceC = Random(6000, 10000);
    return 1;
}

hook OnGameModeInit() {
    WeaponLicense:dialogid = Dialog:GetFreeID();
    Database:AddColumn("playerdata", "WeaponLicenseIsHave", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponLicenseApplied", "int", "0");
    Database:AddColumn("playerdata", "WeaponLicensePlan", "int", "0");
    Database:AddColumn("playerdata", "WeaponLicenseGrantAt", "int", "0");
    Database:AddColumn("playerdata", "WeaponLicenseExpireAt", "int", "0");
    Database:AddColumn("playerdata", "WeaponLicensePlanName", "text", "0");
    Database:AddColumn("playerdata", "WeaponLicenseOfficerName", "text", "0");
    Database:AddColumn("playerdata", "WeaponLicenseOfficerRank", "text", "0");
    Database:AddColumn("playerdata", "WeaponLicenseOfficerFaction", "text", "0");
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != WeaponLicense:dialogid) return 1;
    if (offsetid == WeaponLicense:offsetApply) {
        if (!response) return ~1;
        new license = listitem + 1;
        if (license == 1) {
            if (GetPlayerCash(playerid) < WeaponLicense:PlanPriceA) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you don't have enough money to apply for this license."); return ~1; }
            Database:UpdateInt(1, GetPlayerNameEx(playerid), "username", "WeaponLicenseApplied");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you have applied for license plan Short Term.");
            GivePlayerCash(playerid, -WeaponLicense:PlanPriceA, "weapon license fee");
            vault:addcash(Vault_ID_SAPD, WeaponLicense:PlanPriceA, Vault_Transaction_Cash_To_Vault, sprintf("weapon license fee from %s", GetPlayerNameEx(playerid)));
            return ~1;
        }
        if (license == 2) {
            if (GetPlayerCash(playerid) < WeaponLicense:PlanPriceB) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you don't have enough money to apply for this license."); return ~1; }
            Database:UpdateInt(2, GetPlayerNameEx(playerid), "username", "WeaponLicenseApplied");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you have applied for license plan Mid Term.");
            GivePlayerCash(playerid, -WeaponLicense:PlanPriceB, "weapon license fee");
            vault:addcash(Vault_ID_SAPD, WeaponLicense:PlanPriceB, Vault_Transaction_Cash_To_Vault, sprintf("weapon license fee from %s", GetPlayerNameEx(playerid)));
            return ~1;
        }
        if (license == 3) {
            if (GetPlayerCash(playerid) < WeaponLicense:PlanPriceC) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you don't have enough money to apply for this license."); return ~1; }
            Database:UpdateInt(3, GetPlayerNameEx(playerid), "username", "WeaponLicenseApplied");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} you have applied for license plan Long Term.");
            GivePlayerCash(playerid, -WeaponLicense:PlanPriceC, "weapon license fee");
            vault:addcash(Vault_ID_SAPD, WeaponLicense:PlanPriceC, Vault_Transaction_Cash_To_Vault, sprintf("weapon license fee from %s", GetPlayerNameEx(playerid)));
            return ~1;
        }
        return ~1;
    }
    if (offsetid == WeaponLicense:offsetLaw) {
        if (!response) return ~1;
        if (IsStringSame(inputtext, "Accept/Reject License Requests")) {
            WeaponLicense:appmanage(playerid);
            return ~1;
        }
        if (IsStringSame(inputtext, "Apply For License")) { WeaponLicense:apply(playerid); return ~1; }
        return ~1;
    }
    if (offsetid == WeaponLicense:offsetViewApps) {
        if (!response) return ~1;
        if (IsStringSame(inputtext, "Next Page")) {
            WeaponLicense:viewApps(playerid, extraid + 1);
            return ~1;
        }
        if (IsStringSame(inputtext, "Back Page")) {
            WeaponLicense:viewApps(playerid, extraid - 1);
            return ~1;
        }
        if (!IsValidAccount(inputtext)) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} Selected username is invalid.");
            return ~1;
        }
        ShowPlayerDialogEx(playerid, WeaponLicense:dialogid, WeaponLicense:offsetAppResponse, DIALOG_STYLE_LIST, sprintf("%s weapon license app", inputtext), "Accept\nReject", "Select", "Cancel", -1, inputtext);
        return ~1;
    }
    if (offsetid == WeaponLicense:offsetAppResponse) {
        if (!response) return ~1;
        if (IsStringSame(inputtext, "Accept")) {
            new planid = WeaponLicense:GetAccountAppliedPlanID(payload);
            if (planid == 0) {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} player does not have applied for license.");
                return ~1;
            }
            new issuedon = gettime();
            new expireat = planid == 3 ? issuedon + 60 * 24 * 60 * 60 : planid == 2 ? issuedon + 30 * 24 * 60 * 60 : issuedon + 15 * 24 * 60 * 60;
            new squery[1024];
            mysql_format(Database, squery, sizeof squery, "update playerdata set WeaponLicenseIsHave = true, WeaponLicensePlan = %d, WeaponLicenseGrantAt = %d, WeaponLicenseExpireAt = %d, WeaponLicensePlanName = \"%s\", WeaponLicenseOfficerName = \"%s\", WeaponLicenseOfficerFaction = \"%s\", WeaponLicenseOfficerRank = \"%s\", WeaponLicenseApplied = 0 where username = \"%s\"",
                planid, issuedon, expireat, planid == 3 ? "Long Term"
                : planid == 2 ? "Mid Term" : "Short Term", GetPlayerNameEx(playerid), Faction:GetName(Faction:GetPlayerFID(playerid)), Faction:GetRankName(Faction:GetPlayerFID(playerid), Faction:GetPlayerRankID(playerid)), payload);
            mysql_tquery(Database, squery);
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} %s application has been accepted.", payload));
            SendClientMessageByName(payload, sprintf("{4286f4}[Alexa]:{FFFFFF} %s accepted your weapon license application", GetPlayerNameEx(playerid)));
            return ~1;
        }
        if (IsStringSame(inputtext, "Reject")) {
            if (!IsValidAccount(payload)) {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} Selected username is invalid.");
                return ~1;
            }
            mysql_tquery(Database, sprintf("update playerdata set WeaponLicenseApplied = 0 where username = \"%s\"", payload));
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} %s application has been rejected.", payload));
            SendClientMessageByName(payload, sprintf("{4286f4}[Alexa]:{FFFFFF} %s rejected your weapon license application", GetPlayerNameEx(playerid)));
            return ~1;
        }
        return ~1;
    }
    return ~1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 33) return 1;
    new allowedFactions[] = { 0, 1, 2, 3, 4 };
    if (Faction:IsPlayerSigned(playerid) && IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) && Faction:GetPlayerRankID(playerid) <= 4) {
        new string[512];
        strcat(string, "Accept/Reject License Requests\n");
        strcat(string, "Apply For License\n");
        ShowPlayerDialogEx(playerid, WeaponLicense:dialogid, WeaponLicense:offsetLaw, DIALOG_STYLE_LIST, "SAPD: License Management", string, "Select", "Close");
        return ~1;
    }
    WeaponLicense:apply(playerid);
    return ~1;
}