stock ContactList:Total(const username[]) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from contactList where username =\"%s\"", username));
    new total = 0, rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock ContactList:ShowList(playerid, page = 0) {
    new total = ContactList:Total(GetPlayerNameEx(playerid));
    new perpage = 25;
    new paged = (page + 1) * perpage;
    new remaining = total - paged;
    new skip = page * perpage;
    new totalpages = floatround(total / perpage);

    new Cache:result = mysql_query(Database, sprintf("select * from contactList where username =\"%s\" limit %d, %d", GetPlayerNameEx(playerid), skip, perpage));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(result);
        AlexaMsg(playerid, "you do not have any contacts");
        return ContactList:Menu(playerid);
    }
    new string[2000], name[50], phoneNumber[50];
    strcat(string, "Phone\tName\n");
    for (new i; i < rows; ++i) {
        cache_get_value_name(i, "name", name, 50);
        cache_get_value_name(i, "number", phoneNumber, 50);
        strcat(string, sprintf("%s\t%s\n", phoneNumber, name));
    }
    cache_delete(result);
    if (remaining > 0) strcat(string, "Next\tPage\n");
    if (page > 0) strcat(string, "Back\tPage\n");
    return FlexPlayerDialog(
        playerid, "ContactShowList", DIALOG_STYLE_TABLIST_HEADERS, sprintf("{4286f4}[Contact]: {FFFFFF}List (%d/%d)", page, totalpages), string, "View", "Close", page
    );
}

FlexDialog:ContactShowList(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return ContactList:Menu(playerid);
    if (IsStringSame(inputtext, "Next")) return ContactList:ShowList(playerid, page + 1);
    if (IsStringSame(inputtext, "Back")) return ContactList:ShowList(playerid, page - 1);
    return ContactList:Options(playerid, inputtext);
}

stock ContactList:Options(playerid, const phoneNumber[]) {
    new string[512];
    strcat(string, "Dial\n");
    strcat(string, "Delete\n");
    return FlexPlayerDialog(playerid, "ContactListOptions", DIALOG_STYLE_LIST, "Contacts", string, "Select", "Close", -1, phoneNumber);
}

FlexDialog:ContactListOptions(playerid, response, listitem, const inputtext[], extraid, const phoneNumber[]) {
    if (!response) return ContactList:Menu(playerid);
    if (IsStringSame(inputtext, "Dial")) {
        if (!Phone:MakeCall(playerid, strval(phoneNumber))) {
            return ContactList:Menu(playerid);
        }
    }
    if (IsStringSame(inputtext, "Delete")) {
        mysql_tquery(Database, sprintf("delete from contactList where username = \"%s\" and number = \"%s\"", GetPlayerNameEx(playerid), phoneNumber));
        AlexaMsg(playerid, "Contact deleted");
        return ContactList:Menu(playerid);
    }
    return 1;
}

stock ContactList:Menu(playerid) {
    new string[512];
    strcat(string, sprintf("My Number\t%d\n", Phone:GetPlayerNumber(playerid)));
    strcat(string, "Contact List\n");
    strcat(string, "Add Contact\n");
    return FlexPlayerDialog(playerid, "ContactListShowList", DIALOG_STYLE_TABLIST, "Contacts", string, "Select", "Close");
}

FlexDialog:ContactListShowList(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Contact List")) return ContactList:ShowList(playerid);
    if (IsStringSame(inputtext, "Add Contact")) return ContactList:AddNewInput(playerid);
    return ContactList:Menu(playerid);
}

stock ContactList:AddNewInput(playerid) {
    return FlexPlayerDialog(playerid, "ContactAddNewInput", DIALOG_STYLE_INPUT, "Add Contact", "Please enter the name of your contact", "Next", "Close");
}

FlexDialog:ContactAddNewInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return ContactList:Menu(playerid);
    new name[50];
    if (sscanf(inputtext, "s[50]", name) || strlen(name) < 3) return ContactList:AddNewInput(playerid);
    return ContactList:AddNewInput2(playerid, name);
}

stock ContactList:AddNewInput2(playerid, const name[]) {
    return FlexPlayerDialog(playerid, "ContactAddNewInput2", DIALOG_STYLE_INPUT, "Add Contact", "Please enter the number of your contact", "Save", "Close", -1, name);
}

FlexDialog:ContactAddNewInput2(playerid, response, listitem, const inputtext[], extraid, const name[]) {
    if (!response) return ContactList:Menu(playerid);
    new phoneNumber[10];
    if (sscanf(inputtext, "s[10]", phoneNumber) || strlen(phoneNumber) < 5) return ContactList:AddNewInput2(playerid, name);
    mysql_tquery(Database, sprintf(
        "insert into contactList (username, name, number, createdAt) values (\"%s\", \"%s\", \"%s\", %d)",
        GetPlayerNameEx(playerid), name, phoneNumber, gettime()
    ));
    AlexaMsg(playerid, sprintf("Contact saved, name: %s, number: %s", name, phoneNumber));
    return ContactList:Menu(playerid);
}