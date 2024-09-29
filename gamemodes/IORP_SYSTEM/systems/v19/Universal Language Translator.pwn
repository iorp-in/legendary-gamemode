#define NATIVE_LANGUAGE_MAX 16
#define NATIVE_LANGUAGE_ENGLISH 0
#define NATIVE_LANGUAGE_RUSSIAN 1
#define NATIVE_LANGUAGE_CZECH 2
#define NATIVE_LANGUAGE_FRENCH 3
#define NATIVE_LANGUAGE_SERBIAN 4
#define NATIVE_LANGUAGE_ITALIAN 5
#define NATIVE_LANGUAGE_HINDI 6
#define NATIVE_LANGUAGE_PORTUGUESE 7
#define NATIVE_LANGUAGE_TURKISH 8
#define NATIVE_LANGUAGE_SLOVAK 9
#define NATIVE_LANGUAGE_FILIPINO 10
#define NATIVE_LANGUAGE_BOSNIAN 11
#define NATIVE_LANGUAGE_UKRAINIAN 12
#define NATIVE_LANGUAGE_SPANISH 13
#define NATIVE_LANGUAGE_MALAYALAM 14
#define NATIVE_LANGUAGE_TELUGU 15

enum LANG_ENUM {
    native_lang,
    in_lang[50],
    out_lang[50],
    bool:in_data,
    bool:out_data,
    bool:om_status
};

new Player_Lang_Data[MAX_PLAYERS][LANG_ENUM];

enum Lang_Array_ENUM {
    LANG_ID,
    LANG_Name[50],
    LANG_Country[50]
};

stock Lang_Array[][Lang_Array_ENUM] = {
    { NATIVE_LANGUAGE_ENGLISH, "ENGLISH", "United Kingdom" },
    { NATIVE_LANGUAGE_RUSSIAN, "RUSSIAN", "Russia" },
    { NATIVE_LANGUAGE_CZECH, "CZECH", "Czechia" },
    { NATIVE_LANGUAGE_FRENCH, "FRENCH", "France" },
    { NATIVE_LANGUAGE_SERBIAN, "SERBIAN", "Serbia" },
    { NATIVE_LANGUAGE_ITALIAN, "ITALIAN", "Italy" },
    { NATIVE_LANGUAGE_HINDI, "HINDI", "India" },
    { NATIVE_LANGUAGE_PORTUGUESE, "PORTUGUESE", "Portugal" },
    { NATIVE_LANGUAGE_TURKISH, "TURKISH", "Turkey" },
    { NATIVE_LANGUAGE_SLOVAK, "SLOVAK", "Slovakia" },
    { NATIVE_LANGUAGE_FILIPINO, "FILIPINO", "Philippines" },
    { NATIVE_LANGUAGE_BOSNIAN, "BOSNIAN", "Bosnia and Herzegovina" },
    { NATIVE_LANGUAGE_UKRAINIAN, "Ukrainian", "Ukraine" },
    { NATIVE_LANGUAGE_SPANISH, "SPANISH", "Spain" },
    { NATIVE_LANGUAGE_MALAYALAM, "MALAYALAM", "India" },
    { NATIVE_LANGUAGE_TELUGU, "TELUGU", "India" }
};

stock GetPlayerNativeLang(playerid) {
    return Player_Lang_Data[playerid][native_lang];
}

stock SetPlayerNativeLang(playerid, lang) {
    Player_Lang_Data[playerid][native_lang] = lang;
    return 1;
}

stock GetNativeLangName(langid) {
    new string[50];
    format(string, sizeof string, "%s", Lang_Array[langid][LANG_Name]);
    return string;
}

stock EnableIncomingTranslation(playerid, const lang[]) {
    new string[50];
    format(string, sizeof string, "%s", lang);
    Player_Lang_Data[playerid][in_lang] = string;
    Player_Lang_Data[playerid][in_data] = true;
    return 1;
}

stock DisableIncomingTranslation(playerid) {
    Player_Lang_Data[playerid][in_data] = false;
    Player_Lang_Data[playerid][in_lang] = GetNativeLangName(GetPlayerNativeLang(playerid));
    return 1;
}

stock bool:GetPlayerInTranslationStatus(playerid) {
    return Player_Lang_Data[playerid][in_data];
}

stock GetPlayerInTranslationLang(playerid) {
    new output[50];
    format(output, sizeof output, "%s", Player_Lang_Data[playerid][in_lang]);
    return output;
}

stock EnableOutgoingTranslation(playerid, const lang[]) {
    new string[50];
    format(string, sizeof string, "%s", lang);
    Player_Lang_Data[playerid][out_lang] = string;
    Player_Lang_Data[playerid][out_data] = true;
    return 1;
}

stock DisableOutgoingTranslation(playerid) {
    Player_Lang_Data[playerid][out_data] = false;
    Player_Lang_Data[playerid][out_lang] = GetNativeLangName(GetPlayerNativeLang(playerid));
    return 1;
}

stock bool:GetPlayerOutTranslationStatus(playerid) {
    return Player_Lang_Data[playerid][out_data];
}

stock bool:GetPlayerTranslationOMStatus(playerid) {
    return Player_Lang_Data[playerid][om_status];
}

stock SetPlayerTranslationOMStatus(playerid, bool:status) {
    Player_Lang_Data[playerid][om_status] = status;
    return 1;
}

stock GetPlayerOutTranslationLang(playerid) {
    new output[50];
    format(output, sizeof output, "%s", Player_Lang_Data[playerid][out_lang]);
    return output;
}

stock Lang_Data() {
    new string[1024];
    strcat(string, "Language Code\tLanguage Name\tCountry\n");
    for (new i = 0; i < sizeof Lang_Array; i++) {
        strcat(string, sprintf("%d\t%s\t%s\n", Lang_Array[i][LANG_ID], Lang_Array[i][LANG_Name], Lang_Array[i][LANG_Country]));
    }
    return string;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPlayerNativeLang(playerid, NATIVE_LANGUAGE_ENGLISH);
    DisableIncomingTranslation(playerid);
    DisableOutgoingTranslation(playerid);
    SetPlayerTranslationOMStatus(playerid, false);
    return 1;
}

SCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    SCP:AddCommand(playerid, "Universal Language Translator");
    return 1;
}

SCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Universal Language Translator", inputtext)) UniLangTranslator(playerid);
    return 1;
}


stock UniLangTranslator(playerid) {
    new string[512], message[128];
    format(message, sizeof message, "Action\tStatus\n");
    strcat(string, message);
    format(message, sizeof message, "Change Native Language\t%s\n", Lang_Array[GetPlayerNativeLang(playerid)][LANG_Name]);
    strcat(string, message);
    if (!GetPlayerInTranslationStatus(playerid)) {
        format(message, sizeof message, "Enable In Coming Message Translation\tInactive\n");
        strcat(string, message);
    }
    if (GetPlayerInTranslationStatus(playerid)) {
        format(message, sizeof message, "Disable In Coming Message Translation\tActive\n");
        strcat(string, message);
    }
    if (!GetPlayerOutTranslationStatus(playerid)) {
        format(message, sizeof message, "Enable Out Going Message Translation\tInactive\n");
        strcat(string, message);
    }
    if (GetPlayerOutTranslationStatus(playerid)) {
        format(message, sizeof message, "Disable Out Going Message Translation\tActive\n");
        strcat(string, message);
    }
    if (!GetPlayerTranslationOMStatus(playerid)) {
        format(message, sizeof message, "Enable Original Message of Translation\tInactive\n");
        strcat(string, message);
    }
    if (GetPlayerTranslationOMStatus(playerid)) {
        format(message, sizeof message, "Disable Original Message of Translation\tActive\n");
        strcat(string, message);
    }
    return FlexPlayerDialog(playerid, "UniLangTranslator", DIALOG_STYLE_TABLIST_HEADERS, "Universal Language Translator", string, "Select", "Close");
}

FlexDialog:UniLangTranslator(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Change Native Language", inputtext)) return UniLangChangeNative(playerid);
    if (IsStringSame("Enable In Coming Message Translation", inputtext)) return UniLangInComingMsg(playerid);
    if (IsStringSame("Enable Out Going Message Translation", inputtext)) return UniLangOutGomingMsg(playerid);
    if (IsStringSame("Disable In Coming Message Translation", inputtext)) {
        AlexaMsg(playerid, "You have enabled incoming message translation", "ULT");
        DisableIncomingTranslation(playerid);
        return UniLangTranslator(playerid);
    }
    if (IsStringSame("Disable Out Going Message Translation", inputtext)) {
        AlexaMsg(playerid, "You have disabled outgoing message translation", "ULT");
        DisableOutgoingTranslation(playerid);
        return UniLangTranslator(playerid);
    }
    if (IsStringSame("Enable Original Message of Translation", inputtext)) {
        AlexaMsg(playerid, "You have enabled Original Message of Translation", "ULT");
        SetPlayerTranslationOMStatus(playerid, true);
        return UniLangTranslator(playerid);
    }
    if (IsStringSame("Disable Original Message of Translation", inputtext)) {
        AlexaMsg(playerid, "You have disabled Original Message of Translation", "ULT");
        SetPlayerTranslationOMStatus(playerid, false);
        return UniLangTranslator(playerid);
    }
    return 1;
}

stock UniLangChangeNative(playerid) {
    return FlexPlayerDialog(playerid, "UniLangChangeNative", DIALOG_STYLE_TABLIST_HEADERS, "Universal Language Translator", Lang_Data(), "Select", "Close");
}

FlexDialog:UniLangChangeNative(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return UniLangTranslator(playerid);
    AlexaMsg(playerid, "You have changed your native language", "ULT");
    SetPlayerNativeLang(playerid, strval(inputtext));
    return UniLangTranslator(playerid);
}

stock UniLangInComingMsg(playerid) {
    return FlexPlayerDialog(playerid, "UniLangInComingMsg", DIALOG_STYLE_TABLIST_HEADERS, "Universal Language Translator", Lang_Data(), "Select", "Close");
}

FlexDialog:UniLangInComingMsg(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return UniLangTranslator(playerid);
    AlexaMsg(playerid, "You have enabled the translation of incoming messages", "ULT");
    EnableIncomingTranslation(playerid, inputtext);
    return UniLangTranslator(playerid);
}

stock UniLangOutGomingMsg(playerid) {
    return FlexPlayerDialog(playerid, "UniLangOutGomingMsg", DIALOG_STYLE_TABLIST_HEADERS, "Universal Language Translator", Lang_Data(), "Select", "Close");
}

FlexDialog:UniLangOutGomingMsg(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return UniLangTranslator(playerid);
    AlexaMsg(playerid, "You have enabled the translation of outgoing messages", "ULT");
    EnableOutgoingTranslation(playerid, inputtext);
    return UniLangTranslator(playerid);
}