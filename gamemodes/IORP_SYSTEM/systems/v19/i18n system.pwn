#define Max_IETN_LINES 1000
new NativeSentance[Max_IETN_LINES][NATIVE_LANGUAGE_MAX][2000];
new Iterator:i18nlines < Max_IETN_LINES > ;

stock I18N_Register(const englishText[]) {
    if (strlen(englishText) < 1) {
        print("too short i18n registeration attempt");
        return -1;
    }
    new nID = Iter_Free(i18nlines);
    if (nID == INVALID_ITERATOR_SLOT) {
        print("max limit reached for i18n");
        return -1;
    }
    format(NativeSentance[nID][NATIVE_LANGUAGE_ENGLISH], 2000, "%s", englishText);
    Iter_Add(i18nlines, nID);
    return nID;
}

stock I18N_IsValidID(nativeID) {
    if (Iter_Contains(i18nlines, nativeID)) return 1;
    return 0;
}

stock I18N_SetNativeText(i18nID, native_lang_code, const text[]) {
    if (native_lang_code < 0 || native_lang_code >= NATIVE_LANGUAGE_MAX) return 0;
    format(NativeSentance[i18nID][native_lang_code], 2000, "%s", text);
    return 1;
}

stock GetNativeText(i18nID, native_lang_code) {
    new string[2000];
    if (native_lang_code < 0 || native_lang_code >= NATIVE_LANGUAGE_MAX) return string;
    if (strlen(NativeSentance[i18nID][native_lang_code]) > 1) format(string, 2000, "%s", NativeSentance[i18nID][native_lang_code]);
    else format(string, 2000, "%s", NativeSentance[i18nID][NATIVE_LANGUAGE_ENGLISH]);
    return string;
}