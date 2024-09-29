new Iterator:actors < MAX_ACTORS > ;

enum DynamicActors:DataEnum {
    aID,
    ValidActor,
    aName[32],
    ActorSkin,
    Float:aX,
    Float:aY,
    Float:aZ,
    Float:aA,
    Text3D:ActorText,
    ActorPlayer,
    Actor_AnimLib[32],
    Actor_AnimName[32],
    Actor_AnimLoop,
    Actor_Interior,
    Actor_VirtualWorld
};

new DynamicActors:Data[MAX_ACTORS][DynamicActors:DataEnum];

stock DynamicActors:IsValidID(actorid) {
    return Iter_Contains(actors, actorid);
}

forward LoadDynamicActors();
public LoadDynamicActors() {
    new rows = cache_num_rows();
    if (rows) {
        new i, actorid;
        while (i < rows) {
            cache_get_value_name_int(i, "ID", actorid);
            cache_get_value_name_int(i, "ID", DynamicActors:Data[actorid][aID]);
            cache_get_value_name(i, "Name", DynamicActors:Data[actorid][aName], .max_len = 32);
            cache_get_value_name_int(i, "SkinID", DynamicActors:Data[actorid][ActorSkin]);
            cache_get_value_name_float(i, "X", DynamicActors:Data[actorid][aX]);
            cache_get_value_name_float(i, "Y", DynamicActors:Data[actorid][aY]);
            cache_get_value_name_float(i, "Z", DynamicActors:Data[actorid][aZ]);
            cache_get_value_name_float(i, "A", DynamicActors:Data[actorid][aA]);
            cache_get_value_name(i, "anim_lib", DynamicActors:Data[actorid][Actor_AnimLib], .max_len = 32);
            cache_get_value_name(i, "anim_name", DynamicActors:Data[actorid][Actor_AnimName], .max_len = 32);
            cache_get_value_name_int(i, "anim_loop", DynamicActors:Data[actorid][Actor_AnimLoop]);
            cache_get_value_name_int(i, "interior", DynamicActors:Data[actorid][Actor_Interior]);
            cache_get_value_name_int(i, "virtualworld", DynamicActors:Data[actorid][Actor_VirtualWorld]);
            DynamicActors:Data[actorid][ActorPlayer] = CreateDynamicActor(DynamicActors:Data[actorid][ActorSkin], DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY], DynamicActors:Data[actorid][aZ], DynamicActors:Data[actorid][aA], true, 100.0, DynamicActors:Data[actorid][Actor_VirtualWorld], DynamicActors:Data[actorid][Actor_Interior]);
            ApplyDynamicActorAnimation(DynamicActors:Data[actorid][ActorPlayer], DynamicActors:Data[actorid][Actor_AnimLib], DynamicActors:Data[actorid][Actor_AnimName], 4.1, DynamicActors:Data[actorid][Actor_AnimLoop], 0, 0, 1, 0);
            Iter_Add(actors, actorid);
            i++;
        }
    }
    printf("  [Actor System] Loaded %d Actors.", rows);
    return 1;
}

hook OnGameModeInit() {
    new query[512];
    strcat(query, "CREATE TABLE IF NOT EXISTS `actors` (\
	`ID` INT(10) NOT NULL,\
	`Name` VARCHAR(32) NULL DEFAULT NULL,\
	`SkinID` INT(3) NULL DEFAULT NULL,\
	`X` FLOAT NULL DEFAULT NULL,\
	`Y` FLOAT NULL DEFAULT NULL,\
	`Z` FLOAT NULL DEFAULT NULL,\
	`A` FLOAT NULL DEFAULT NULL,\
	`anim_lib` VARCHAR(32) NULL DEFAULT 'PED',\
	`anim_name` VARCHAR(32) NULL DEFAULT 'STAND',\
	`anim_loop` tinyint(1) NULL DEFAULT '0',");
    strcat(query, "`interior` int(11) NOT NULL default '-1',\
	`virtualworld` int(11) NOT NULL default '-1',\
	PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM `actors`", "LoadDynamicActors", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new actorid:actors) DestroyDynamicActor(DynamicActors:Data[actorid][ActorPlayer]);
    return 1;
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Actor System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Actor System", inputtext)) DynamicActors:AdminPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "actor system") || GetPlayerAdminLevel(playerid) < 8) return 1;
    DynamicActors:AdminPanel(playerid);
    return ~1;
}

stock DynamicActors:AdminPanel(playerid) {
    new string[1024];
    strcat(string, "Show Actors Tag\n");
    strcat(string, "Hide Actors Tag\n");
    strcat(string, "Manage Actor\n");
    strcat(string, "Create Actor\n");
    return FlexPlayerDialog(playerid, "DynamicActorsAdminPanel", DIALOG_STYLE_LIST, "Actor System", string, "Select", "Close");
}

FlexDialog:DynamicActorsAdminPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Manage Actor")) return DynamicActors:MenuManage(playerid);
    if (IsStringSame(inputtext, "Create Actor")) return DynamicActors:MenuCreate(playerid);
    if (IsStringSame(inputtext, "Show Actors Tag")) {
        new string[128];
        foreach(new actorid:actors) {
            format(string, sizeof(string), "{00FFFF}%s [%i]", DynamicActors:Data[actorid][aName], DynamicActors:Data[actorid][aID]);
            if (IsValidDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText])) DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
            DynamicActors:Data[actorid][ActorText] = CreateDynamic3DTextLabel(string, 0xFF8080FF, DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY], DynamicActors:Data[actorid][aZ] + 1.05, 10.0);
        }
        SendClientMessageEx(playerid, -1, "{4286f4}[Actor System]:{FFFFEE}Showing Actors Tag");
        return DynamicActors:AdminPanel(playerid);
    }
    if (IsStringSame(inputtext, "Hide Actors Tag")) {
        foreach(new actorid:actors) {
            if (IsValidDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText])) DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
        }
        return DynamicActors:AdminPanel(playerid);
    }
    return 1;
}

stock DynamicActors:MenuCreate(playerid) {
    return FlexPlayerDialog(
        playerid, "DynamicActorsMenuCreate", DIALOG_STYLE_INPUT, "{4286f4}[Actor System]:{FFFFEE}Admin Panel",
        "Enter SkinID and Actor Name\n[SkinID] [ActorName]", "Submit", "Close"
    );
}

FlexDialog:DynamicActorsMenuCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DynamicActors:AdminPanel(playerid);
    new actorName[32], skin;
    new actorid = Iter_Free(actors);
    if (sscanf(inputtext, "ds[32]", skin, actorName) || skin < 0 || skin > 311 || actorid == INVALID_ITERATOR_SLOT) return DynamicActors:MenuCreate(playerid);
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPosEx(playerid, x + 2, y, z);
    GetPlayerFacingAngle(playerid, a);
    new animlib[32];
    new animname[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, 32, animname, 32);
    DynamicActors:Data[actorid][aID] = actorid;
    DynamicActors:Data[actorid][ActorSkin] = skin;
    DynamicActors:Data[actorid][aX] = x;
    DynamicActors:Data[actorid][aY] = y;
    DynamicActors:Data[actorid][aZ] = z;
    DynamicActors:Data[actorid][aA] = a;
    DynamicActors:Data[actorid][Actor_AnimLib] = animlib;
    DynamicActors:Data[actorid][Actor_AnimName] = animname;
    DynamicActors:Data[actorid][aName] = actorName;
    DynamicActors:Data[actorid][Actor_AnimLoop] = 0;
    DynamicActors:Data[actorid][Actor_Interior] = GetPlayerInterior(playerid);
    DynamicActors:Data[actorid][Actor_VirtualWorld] = GetPlayerVirtualWorld(playerid);
    DynamicActors:Data[actorid][ActorPlayer] = CreateDynamicActor(
        DynamicActors:Data[actorid][ActorSkin], DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY],
        DynamicActors:Data[actorid][aZ], DynamicActors:Data[actorid][aA], true, 100.0,
        DynamicActors:Data[actorid][Actor_VirtualWorld], DynamicActors:Data[actorid][Actor_Interior]
    );
    ApplyDynamicActorAnimation(
        DynamicActors:Data[actorid][ActorPlayer], DynamicActors:Data[actorid][Actor_AnimLib], DynamicActors:Data[actorid][Actor_AnimName],
        4.1, DynamicActors:Data[actorid][Actor_AnimLoop], 0, 0, 1, 0
    );
    mysql_tquery(Database, sprintf(
        "INSERT INTO `actors` (`ID`,`Name`,`SkinID`,`X`,`Y`,`Z`,`A`,`anim_lib`,`anim_name`,`anim_loop`, `interior`, `virtualworld`) \
        VALUES ('%d',\"%s\",%i,%f,%f,%f,%f,\"%s\",\"%s\",%d,%d,%d)",
        actorid, actorName, skin, x, y, z, a, animlib, animname, DynamicActors:Data[actorid][Actor_AnimLoop],
        DynamicActors:Data[actorid][Actor_Interior], DynamicActors:Data[actorid][Actor_VirtualWorld]
    ));
    Iter_Add(actors, actorid);
    AlexaMsg(playerid, sprintf("New actor [%d] created. Skin ID: %i Name: %s", actorid, skin, actorName), "Actor System");
    return DynamicActors:Manage(playerid, actorid);
}

stock DynamicActors:MenuManage(playerid) {
    return FlexPlayerDialog(playerid, "DynamicActorsMenuManage", DIALOG_STYLE_INPUT, "Actor System", "Enter Actor ID", "Submit", "Close");
}

FlexDialog:DynamicActorsMenuManage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DynamicActors:AdminPanel(playerid);
    new actorid;
    if (sscanf(inputtext, "d", actorid) || !DynamicActors:IsValidID(actorid)) return DynamicActors:MenuManage(playerid);
    return DynamicActors:Manage(playerid, actorid);
}

stock DynamicActors:Manage(playerid, actorid) {
    if (!DynamicActors:IsValidID(actorid)) return 1;
    new string[1024];
    strcat(string, "Set Actor Skin\n");
    strcat(string, "Set Actor Name\n");
    strcat(string, "Set Actor Animation\n");
    strcat(string, "Go to actor\n");
    strcat(string, "Set Actor Position\n");
    strcat(string, "Remove Actor\n");
    return FlexPlayerDialog(playerid, "DynamicActorsManage", DIALOG_STYLE_LIST, "Actor System", string, "Select", "Close", actorid);
}

FlexDialog:DynamicActorsManage(playerid, response, listitem, const inputtext[], actorid, const payload[]) {
    if (!response) return DynamicActors:AdminPanel(playerid);
    if (IsStringSame(inputtext, "Set Actor Skin")) return DynamicActors:MenuSkinInput(playerid, actorid);
    if (IsStringSame(inputtext, "Set Actor Name")) return DynamicActors:MenuNameInput(playerid, actorid);
    if (IsStringSame(inputtext, "Set Actor Animation")) return DynamicActors:MenuAnimationInput(playerid, actorid);
    if (IsStringSame(inputtext, "Go to actor")) {
        SetPlayerPosEx(playerid, DynamicActors:Data[actorid][aX] + 1, DynamicActors:Data[actorid][aY] + 1, DynamicActors:Data[actorid][aZ]);
        AlexaMsg(playerid, sprintf("you are teleported to actor id %d", actorid), "Actor System");
        return DynamicActors:Manage(playerid, actorid);
    }
    if (IsStringSame(inputtext, "Set Actor Position")) {
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerFacingAngle(playerid, a);
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPosEx(playerid, x + 2, y, z);
        DynamicActors:Data[actorid][aX] = x;
        DynamicActors:Data[actorid][aY] = y;
        DynamicActors:Data[actorid][aZ] = z;
        DynamicActors:Data[actorid][aA] = a;
        DynamicActors:Data[actorid][Actor_Interior] = GetPlayerInterior(playerid);
        DynamicActors:Data[actorid][Actor_VirtualWorld] = GetPlayerVirtualWorld(playerid);
        new query[512];
        mysql_format(Database, query, sizeof(query), "UPDATE `actors` SET `X`='%f', `Y`='%f', `Z`='%f', `A`='%f', `interior`=%d, `virtualworld`=%d WHERE `ID`=%d", x, y, z, a, DynamicActors:Data[actorid][Actor_Interior], DynamicActors:Data[actorid][Actor_VirtualWorld], actorid);
        mysql_tquery(Database, query);
        DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
        DestroyDynamicActor(DynamicActors:Data[actorid][ActorPlayer]);
        DynamicActors:Data[actorid][ActorPlayer] = CreateDynamicActor(DynamicActors:Data[actorid][ActorSkin], DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY], DynamicActors:Data[actorid][aZ], DynamicActors:Data[actorid][aA], true, 100.0, DynamicActors:Data[actorid][Actor_VirtualWorld], DynamicActors:Data[actorid][Actor_Interior]);
        ApplyDynamicActorAnimation(DynamicActors:Data[actorid][ActorPlayer], DynamicActors:Data[actorid][Actor_AnimLib], DynamicActors:Data[actorid][Actor_AnimName], 4.1, DynamicActors:Data[actorid][Actor_AnimLoop], 0, 0, 1, 0);
        AlexaMsg(playerid, sprintf("Actor ID: %d moved to your current location", actorid), "Actor System");
        return DynamicActors:Manage(playerid, actorid);
    }
    if (IsStringSame(inputtext, "Remove Actor")) {
        DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
        DestroyDynamicActor(DynamicActors:Data[actorid][ActorPlayer]);
        mysql_tquery(Database, sprintf("DELETE FROM actors WHERE ID = %d", actorid));
        Iter_Remove(actors, actorid);
        AlexaMsg(playerid, sprintf("Actor ID: %d removed", actorid), "Actor System");
        return DynamicActors:AdminPanel(playerid);
    }
    return 1;
}

DynamicActors:MenuSkinInput(playerid, actorid) {
    return FlexPlayerDialog(playerid, "ActorMenuSkinInput", DIALOG_STYLE_INPUT, "Actor System", "Enter new skinid", "Update", "Cancel", actorid);
}

FlexDialog:ActorMenuSkinInput(playerid, response, listitem, const inputtext[], actorid, const payload[]) {
    if (!response) return DynamicActors:Manage(playerid, actorid);
    new skindid;
    if (sscanf(inputtext, "d", skindid) || skindid < 0 || skindid > 311) return DynamicActors:MenuSkinInput(playerid, actorid);
    DynamicActors:Data[actorid][ActorSkin] = skindid;
    DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
    DestroyDynamicActor(DynamicActors:Data[actorid][ActorPlayer]);
    DynamicActors:Data[actorid][ActorPlayer] = CreateDynamicActor(
        DynamicActors:Data[actorid][ActorSkin], DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY],
        DynamicActors:Data[actorid][aZ], DynamicActors:Data[actorid][aA], true, 100.0,
        DynamicActors:Data[actorid][Actor_VirtualWorld], DynamicActors:Data[actorid][Actor_Interior]
    );
    ApplyDynamicActorAnimation(
        DynamicActors:Data[actorid][ActorPlayer], DynamicActors:Data[actorid][Actor_AnimLib], DynamicActors:Data[actorid][Actor_AnimName],
        4.1, DynamicActors:Data[actorid][Actor_AnimLoop], 0, 0, 1, 0
    );
    mysql_tquery(Database, sprintf("UPDATE `actors` SET `SkinID`='%d' WHERE `ID`=%d", skindid, actorid));
    AlexaMsg(playerid, sprintf("update actor id %d skin to %d", actorid, skindid));
    return DynamicActors:Manage(playerid, actorid);
}

DynamicActors:MenuNameInput(playerid, actorid) {
    return FlexPlayerDialog(playerid, "ActorMenuNameInput", DIALOG_STYLE_INPUT, "Actor System", "Enter new name", "Update", "Cancel", actorid);
}

FlexDialog:ActorMenuNameInput(playerid, response, listitem, const inputtext[], actorid, const payload[]) {
    if (!response) return DynamicActors:Manage(playerid, actorid);
    new newName[32];
    if (sscanf(inputtext, "s[32]", newName)) return DynamicActors:MenuNameInput(playerid, actorid);
    DynamicActors:Data[actorid][aName] = newName;
    mysql_tquery(Database, sprintf("UPDATE `actors` SET `Name`=\"%s\" WHERE `ID`=%d", newName, actorid));
    AlexaMsg(playerid, sprintf("updated actor id %d name to %s", actorid, newName));
    return DynamicActors:Manage(playerid, actorid);
}

DynamicActors:MenuAnimationInput(playerid, actorid) {
    return FlexPlayerDialog(playerid, "ActorMenuAnimationInput", DIALOG_STYLE_INPUT, "Actor System", "Enter Animation Details\n[AnimLib] [AnimName] [Loop]", "Update", "Cancel", actorid);
}

FlexDialog:ActorMenuAnimationInput(playerid, response, listitem, const inputtext[], actorid, const payload[]) {
    if (!response) return DynamicActors:Manage(playerid, actorid);
    new animlib[32], animname[32], loop;
    if (sscanf(inputtext, "s[32]s[32]d", animlib, animname, loop)) return DynamicActors:MenuAnimationInput(playerid, actorid);
    DynamicActors:Data[actorid][Actor_AnimLib] = animlib;
    DynamicActors:Data[actorid][Actor_AnimName] = animname;
    DynamicActors:Data[actorid][Actor_AnimLoop] = loop;
    DestroyDynamic3DTextLabel(DynamicActors:Data[actorid][ActorText]);
    DestroyDynamicActor(DynamicActors:Data[actorid][ActorPlayer]);
    DynamicActors:Data[actorid][ActorPlayer] = CreateDynamicActor(DynamicActors:Data[actorid][ActorSkin], DynamicActors:Data[actorid][aX], DynamicActors:Data[actorid][aY], DynamicActors:Data[actorid][aZ], DynamicActors:Data[actorid][aA], true, 100.0, DynamicActors:Data[actorid][Actor_VirtualWorld], DynamicActors:Data[actorid][Actor_Interior]);
    ApplyDynamicActorAnimation(DynamicActors:Data[actorid][ActorPlayer], DynamicActors:Data[actorid][Actor_AnimLib], DynamicActors:Data[actorid][Actor_AnimName], 4.1, DynamicActors:Data[actorid][Actor_AnimLoop], 0, 0, 1, 0);
    mysql_tquery(Database, sprintf("UPDATE `actors` SET `anim_lib`=\"%s\", `anim_name`=\"%s\", `anim_loop`='%d' WHERE `ID`=%d", animlib, animname, loop, actorid));
    AlexaMsg(playerid, sprintf("updated actor id %d animation data", actorid));
    return DynamicActors:Manage(playerid, actorid);
}