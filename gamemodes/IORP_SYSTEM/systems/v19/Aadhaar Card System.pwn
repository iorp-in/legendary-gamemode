hook OnGameModeInit() {
    Database:AddColumn("playerdata", "IsHaveAadhaar", "boolean", "0");
    Database:AddColumn("playerdata", "DOB", "text", "null");
    Database:AddColumn("playerdata", "Aadhaar Number", "text", "null");
    Database:AddColumn("playerdata", "Father Name", "text", "null");
    return 1;
}

stock bool:AadhaarCard:IsHave(playerid) {
    return Database:GetBool(GetPlayerNameEx(playerid), "username", "IsHaveAadhaar");
}

stock AadhaarCard:GetDateOfBirth(playerid) {
    new string[100];
    format(string, sizeof string, "%s", Database:GetString(GetPlayerNameEx(playerid), "username", "DOB"));
    return string;
}

stock AadhaarCard:GetNumber(playerid) {
    new string[100];
    format(string, sizeof string, "%s", Database:GetString(GetPlayerNameEx(playerid), "username", "Aadhaar Number"));
    return string;
}

stock AadhaarCard:GetFatherName(playerid) {
    new string[100];
    format(string, sizeof string, "%s", Database:GetString(GetPlayerNameEx(playerid), "username", "Father Name"));
    return string;
}

stock AadhaarCard:GetMotherName(playerid) {
    new string[100];
    format(string, sizeof string, "%s", Database:GetString(GetPlayerNameEx(playerid), "username", "Mother Name"));
    return string;
}

stock AadhaarCard:ShowCard(playerid, targetid) {
    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 1;
    if (!AadhaarCard:IsHave(targetid)) return AlexaMsg(playerid, sprintf("%s does not have aadhar card", GetPlayerNameEx(targetid)));
    new string[1024];
    strcat(string, sprintf("Aadhar Card Number: %s\n\n", Database:GetString(GetPlayerNameEx(targetid), "username", "Aadhaar Number")));
    strcat(string, sprintf("Name: %s\n", GetPlayerNameEx(targetid)));
    strcat(string, sprintf("Date of Birth: %s\n", Database:GetString(GetPlayerNameEx(targetid), "username", "DOB")));
    strcat(string, sprintf("Gender: %s\n", GetPlayerGender(targetid)));
    strcat(string, sprintf("Father Name: %s\n", Database:GetString(GetPlayerNameEx(targetid), "username", "Father Name")));
    strcat(string, sprintf("Mother Name: %s\n", Database:GetString(GetPlayerNameEx(targetid), "username", "Mother Name")));
    strcat(string, sprintf("Residence Address: %s\n", House:GetFirstHouseAddress(targetid)));
    return FlexPlayerDialog(playerid, "AadhaarMenuShowCard", DIALOG_STYLE_MSGBOX, sprintf("{4286f4}[Alexa]: {FFFFFF}%s's Aadhaar", GetPlayerNameEx(targetid)), string, "Okay", "");
}

FlexDialog:AadhaarMenuShowCard(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 17) return 1;
    AadhaarCard:ShopMenu(playerid);
    return ~1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (AadhaarCard:IsHave(playerid)) QuickActions:AddCommand(playerid, "Show Aadhaar Card");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Show Aadhaar Card", inputtext)) {
        AadhaarCard:ShowCard(targetid, playerid);
        return ~1;
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    if (AadhaarCard:IsHave(playerid)) UCP:AddCommand(playerid, "View Aadhar Card");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (strcmp("View Aadhar Card", inputtext)) return 1;
    AadhaarCard:ShowCard(playerid, playerid);
    return ~1;
}

stock AadhaarCard:ShopMenu(playerid) {
    new string[512];
    if (!AadhaarCard:IsHave(playerid)) {
        strcat(string, "Apply for Aadhaar Card");
    } else {
        strcat(string, "View Aadhaar Card\n");
        strcat(string, "Update Aadhaar Card");
    }
    return FlexPlayerDialog(playerid, "AadhaarShopMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarShopMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Apply for Aadhaar Card")) {
        if (AadhaarCard:IsHave(playerid)) {
            AlexaMsg(playerid, "you already have aadhaar card, you can update for correction any time.");
            return AadhaarCard:ShopMenu(playerid);
        }
        return AadhaarCard:MenuApply(playerid);
    }
    if (IsStringSame(inputtext, "View Aadhaar Card")) return AadhaarCard:ShowCard(playerid, playerid);
    if (IsStringSame(inputtext, "Update Aadhaar Card")) return AadhaarCard:MenuUpdate(playerid);
    return 1;
}

stock AadhaarCard:MenuApply(playerid) {
    new string[512];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, "\n\nEnter your date of birth in format: dd/mm/yyyy");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuApplyDOB", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuApplyDOB(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new dd, mm, yy;
    if (sscanf(inputtext, "p</>iii", dd, mm, yy) || dd < 1 || dd > 31 || mm < 1 || mm > 12 || yy < 1900 || yy > 2021) return AadhaarCard:MenuApply(playerid);
    Database:UpdateString(sprintf("%d/%d/%d", dd, mm, yy), GetPlayerNameEx(playerid), "username", "DOB");
    return AadhaarCard:MenuApplyFather(playerid);
}

stock AadhaarCard:MenuApplyFather(playerid) {
    new string[1024];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Date of Birth: %s", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, "\n\nEnter your father name in roleplay name format\nEg. First_Last");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuApplyFather", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuApplyFather(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AadhaarCard:MenuApply(playerid);
    new father[100];
    if (sscanf(inputtext, "s[100]", father) || !RoleplayNameCheck(father)) return AadhaarCard:MenuApplyFather(playerid);
    Database:UpdateString(father, GetPlayerNameEx(playerid), "username", "Father Name");
    return AadhaarCard:MenuApplyMother(playerid);
}

stock AadhaarCard:MenuApplyMother(playerid) {
    new string[1024];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Date of Birth: %s", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, sprintf("Father Name: %s", AadhaarCard:GetFatherName(playerid)));
    strcat(string, "\n\nEnter your mother name in roleplay name format\nEg. First_Last");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuApplyMother", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuApplyMother(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AadhaarCard:MenuApplyFather(playerid);
    new mother[100];
    if (sscanf(inputtext, "s[100]", mother) || !RoleplayNameCheck(mother)) return AadhaarCard:MenuApplyFather(playerid);
    AlexaMsg(playerid, "your aadhar card generated successfully");
    Database:UpdateString(mother, GetPlayerNameEx(playerid), "username", "Mother Name");
    Database:UpdateString(sprintf("%d", gettime()), GetPlayerNameEx(playerid), "username", "Aadhaar Number");
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "IsHaveAadhaar");
    return AadhaarCard:ShopMenu(playerid);
}

stock AadhaarCard:MenuUpdate(playerid) {
    if (!AadhaarCard:IsHave(playerid)) {
        AlexaMsg(playerid, "you don't have a aadhaar card.");
        return AadhaarCard:ShopMenu(playerid);
    }
    new string[1024];
    strcat(string, "Action\tStatus\n");
    strcat(string, sprintf("Date of Birth\t%s\n", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, sprintf("Father Name\t%s\n", AadhaarCard:GetFatherName(playerid)));
    strcat(string, sprintf("Mother Name\t%s\n", AadhaarCard:GetMotherName(playerid)));
    strcat(string, sprintf("Residence Address\t%s\n", House:GetFirstHouseAddress(playerid)));
    return FlexPlayerDialog(playerid, "AadhaarCardMenuUpdate", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFFF}Update Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuUpdate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Date of Birth")) return AadhaarCard:MenuUpdateDOB(playerid);
    if (IsStringSame(inputtext, "Father Name")) return AadhaarCard:MenuUpdateFather(playerid);
    if (IsStringSame(inputtext, "Mother Name")) return AadhaarCard:MenuUpdateMother(playerid);
    return 1;
}

stock AadhaarCard:MenuUpdateDOB(playerid) {
    new string[512];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Date of Birth: %s", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, "\n\nEnter your date of birth in format: dd/mm/yyyy");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuUpdateDOB", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuUpdateDOB(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AadhaarCard:MenuUpdate(playerid);
    new dd, mm, yy;
    if (sscanf(inputtext, "p</>iii", dd, mm, yy) || dd < 1 || dd > 31 || mm < 1 || mm > 12 || yy < 1900 || yy > 2021) return AadhaarCard:MenuUpdateDOB(playerid);
    Database:UpdateString(sprintf("%d/%d/%d", dd, mm, yy), GetPlayerNameEx(playerid), "username", "DOB");
    return AadhaarCard:MenuUpdate(playerid);
}

stock AadhaarCard:MenuUpdateFather(playerid) {
    new string[512];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Date of Birth: %s", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, sprintf("Father: %s", AadhaarCard:GetFatherName(playerid)));
    strcat(string, "\n\nEnter your father name in roleplay name format\nEg. First_Last");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuUpdateFather", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuUpdateFather(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AadhaarCard:MenuUpdate(playerid);
    new father[100];
    if (sscanf(inputtext, "s[100]", father) || !RoleplayNameCheck(father)) return AadhaarCard:MenuUpdateFather(playerid);
    Database:UpdateString(father, GetPlayerNameEx(playerid), "username", "Father Name");
    return AadhaarCard:MenuUpdate(playerid);
}

stock AadhaarCard:MenuUpdateMother(playerid) {
    new string[512];
    strcat(string, sprintf("Name: %s", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Date of Birth: %s", AadhaarCard:GetDateOfBirth(playerid)));
    strcat(string, sprintf("Mother: %s", AadhaarCard:GetMotherName(playerid)));
    strcat(string, "\n\nEnter your mother name in roleplay name format\nEg. First_Last");
    return FlexPlayerDialog(playerid, "AadhaarCardMenuUpdateMother", DIALOG_STYLE_INPUT, "{4286f4}[Alexa]: {FFFFFF}Your Aadhaar", string, "Submit", "Close");
}

FlexDialog:AadhaarCardMenuUpdateMother(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return AadhaarCard:MenuUpdate(playerid);
    new mother[100];
    if (sscanf(inputtext, "s[100]", mother) || !RoleplayNameCheck(mother)) return AadhaarCard:MenuUpdateMother(playerid);
    Database:UpdateString(mother, GetPlayerNameEx(playerid), "username", "Mother Name");
    return AadhaarCard:MenuUpdate(playerid);
}