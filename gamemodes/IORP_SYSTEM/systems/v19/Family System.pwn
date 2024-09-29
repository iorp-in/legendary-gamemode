new Relations[][50] = {
    "Father",
    "Mother",
    "Son",
    "Daughter",
    "Brother",
    "Sister",
    "Uncle",
    "Aunt",
    "Daughter-in-law",
    "Son-in-law",
    "Brother-in-law",
    "Mother-in-law",
    "Father-in-law",
    "Nephew",
    "Niece",
    "Cousin",
    "Grandfather",
    "Grandmother",
    "Elder Brother",
    "Younger Brother",
    "Elder Sister",
    "Younger Sister",
    "Friend",
    "Best Friend",
    "Wife",
    "Husband",
    "Fiance",
    "Fiancee"
};

hook OnGameModeInit() {
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `family` (\
	  `Username` varchar(50) NOT NULL,\
	  `Playername` varchar(50) NOT NULL,\
	  `My_Relation` int(11) NOT NULL,\
	  `Your_Relation` int(11) NOT NULL\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

stock Family:IsValidRelation(relationid) {
    new totalRelations = sizeof Relations;
    if (relationid < 0 || relationid >= totalRelations) return 0;
    return 1;
}

stock Family:GetRelationName(relationid) {
    new string[50];
    format(string, sizeof string, "%s", Relations[relationid]);
    return string;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "My Family");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("My Family", inputtext)) {
        Family:MyView(playerid);
        return ~1;
    }
    return 1;
}

stock Family:MyView(playerid) {
    new Cache:mysql_cache = mysql_query(Database,
        sprintf(
            "SELECT * from family where Username=\"%s\" OR Playername = \"%s\"",
            GetPlayerNameEx(playerid), GetPlayerNameEx(playerid)
        )
    );
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        return AlexaMsg(playerid, "You are familyless :(");
    }
    new mName[50], yName[50], mrelation, yrelation, string[2000];
    strcat(string, "Name\tPlayer Relation\tStatus\n");
    for (new i; i < rows; i++) {
        cache_get_value_name(i, "username", mName, sizeof mName);
        cache_get_value_name(i, "Playername", yName, sizeof yName);
        cache_get_value_name_int(i, "My_Relation", mrelation);
        cache_get_value_name_int(i, "Your_Relation", yrelation);
        if (IsStringSame(GetPlayerNameEx(playerid), mName)) strcat(
            string, sprintf(
                "%s\t%s\t%s\n",
                yName, Family:GetRelationName(yrelation), IsPlayerConnected(GetPlayerIDByName(yName)) ? ("Online") : ("Offline")
            )
        );
        else strcat(
            string, sprintf(
                "%s\t%s\t%s\n",
                mName, Family:GetRelationName(yrelation), IsPlayerConnected(GetPlayerIDByName(mName)) ? ("Online") : ("Offline")
            )
        );
    }
    cache_delete(mysql_cache);
    return FlexPlayerDialog(playerid, "FamilyMyView", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]:{FFFFEE} your Family", string, "Okay", "");
}

FlexDialog:FamilyMyView(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    return Family:RelationActions(playerid, inputtext);
}

stock Family:RelationActions(playerid, const friendName[]) {
    new string[512];
    strcat(string, "Remove Relation\n");
    return FlexPlayerDialog(playerid, "FamilyRelationActions", DIALOG_STYLE_LIST, "Relation Actions", string, "Select", "Close", 0, friendName);
}

FlexDialog:FamilyRelationActions(playerid, response, listitem, const inputtext[], extraid, const account[]) {
    if (!response || !IsValidAccount(account)) return Family:MyView(playerid);
    if (IsStringSame(inputtext, "Remove Relation")) {
        new Cache:mysql_cache = mysql_query(Database,
            sprintf(
                "select * from family where (Username=\"%s\" AND Playername = \"%s\") OR (Username=\"%s\" AND Playername = \"%s\")",
                GetPlayerNameEx(playerid), account, account, GetPlayerNameEx(playerid)
            )
        );
        new rows = cache_num_rows();
        cache_delete(mysql_cache);

        if (rows) mysql_query(Database,
            sprintf(
                "Delete from family where (Username=\"%s\" AND Playername = \"%s\") OR (Username=\"%s\" AND Playername = \"%s\")",
                GetPlayerNameEx(playerid), account, account, GetPlayerNameEx(playerid)
            )
        );

        if (rows) AlexaMsg(playerid, sprintf("All your relationships were broken with %s", account));
        else AlexaMsg(playerid, sprintf("No relationship with %s found", account));
    }
    return Family:MyView(playerid);
}

stock Family:GetFriendRelationID(playerid, friendid) {
    new Cache:mysql_cache = mysql_query(Database,
        sprintf(
            "SELECT * from family where (Username=\"%s\" AND Playername=\"%s\") OR ((Username=\"%s\" AND Playername=\"%s\"));",
            GetPlayerNameEx(playerid), GetPlayerNameEx(friendid), GetPlayerNameEx(friendid), GetPlayerNameEx(playerid)
        )
    );
    new my_relation = -1;
    new rows = cache_num_rows();
    if (rows) cache_get_value_name_int(0, "My_Relation", my_relation);
    cache_delete(mysql_cache);
    return my_relation;

}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 1) return 1;
    if (!Family:IsValidRelation(Family:GetFriendRelationID(playerid, targetid))) QuickActions:AddCommand(playerid, "Make Relation");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Make Relation", inputtext)) {
        Family:MakeRelationRequest(playerid, targetid);
        return ~1;
    }
    return 1;
}

stock Family:MakeRelationRequest(playerid, friendid) {
    if (!IsPlayerConnected(friendid)) return Family:MyView(playerid);
    new string[1024];
    strcat(string, "ID\tRelation\n");
    for (new relationid; relationid < sizeof Relations; relationid++) strcat(string, sprintf("%d\t%s\n", relationid, Family:GetRelationName(relationid)));
    return FlexPlayerDialog(playerid, "FamilyNewRelation", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]:{FFFFEE}Select your relation", string, "Select", "Close", friendid);
}

FlexDialog:FamilyNewRelation(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Family:MyView(playerid);
    new friendid = extraid;
    if (!IsPlayerConnected(friendid)) return AlexaMsg(playerid, "your friend is not connected with server");
    new string[1024];
    strcat(string, "ID\tRelation\n");
    for (new relationid; relationid < sizeof Relations; relationid++) strcat(string, sprintf("%d\t%s\n", relationid, Family:GetRelationName(relationid)));
    return FlexPlayerDialog(playerid, "FamilyNewRelationYour", DIALOG_STYLE_TABLIST_HEADERS, ("{4286f4}[Alexa]:{FFFFEE}Select %s's relation", GetPlayerNameEx(friendid)), string, "Select", "Close", friendid, inputtext);
}

FlexDialog:FamilyNewRelationYour(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new friendid = extraid, myrelationid = strval(payload), frelation = strval(inputtext);
    if (!IsPlayerConnected(friendid)) return AlexaMsg(playerid, "your friend is not connected with server");
    AlexaMsg(playerid, sprintf("relation request sent to %s", GetPlayerNameEx(friendid)));
    return FlexPlayerDialog(friendid, "FamilyRelationRequest", DIALOG_STYLE_MSGBOX, "Family Relation Request",
        sprintf("%s want to become your %s, do you want to accept this relation?", GetPlayerNameEx(playerid), Family:GetRelationName(myrelationid)),
        "Confirm", "Reject", playerid, sprintf("%d %d", frelation, myrelationid)
    );
}

FlexDialog:FamilyRelationRequest(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    new friendid = extraid, myrelationid, frelation;
    if (sscanf(payload, "d d", myrelationid, frelation)) return AlexaMsg(playerid, "args error", "Error");
    if (!IsPlayerConnected(friendid)) return AlexaMsg(playerid, "the player is not connected with server, request cancelled");
    if (!response) return AlexaMsg(friendid, sprintf("%s has rejected your relation request", GetPlayerNameEx(playerid)));
    AlexaMsg(friendid, sprintf("%s has accepted your relation request, you are now his/her %s", GetPlayerNameEx(playerid), Family:GetRelationName(frelation)));
    AlexaMsg(playerid, sprintf("you have accepted %s relation request, you are now his/her %s", GetPlayerNameEx(friendid), Family:GetRelationName(myrelationid)));
    mysql_query(Database,
        sprintf(
            "INSERT INTO family (Username, Playername, My_Relation, Your_Relation) VALUES (\"%s\", \"%s\", %d, %d)",
            GetPlayerNameEx(friendid), GetPlayerNameEx(playerid), frelation, myrelationid
        )
    );
    Family:MyView(friendid);
    Family:MyView(playerid);
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `family` SET `Username` = \"%s\" WHERE  `Username` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `family` SET `Playername` = \"%s\" WHERE  `Playername` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `family` WHERE `Username` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `family` WHERE `Playername` = \"%s\"", AccountName));
    return 1;
}