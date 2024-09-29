new DJAutoPlayList_ID = -1;
new bool:DJAutoPlayList_Status = false;
new bool:DJRemixPlayList_Status = false;
new bool:DJ:PlayerAudioTTS[MAX_PLAYERS];
new bool:DJ:PlayerAudioMp3[MAX_PLAYERS];
new bool:DJ:PlayerAudioDj[MAX_PLAYERS];

stock DJ:IsPlayer(playerid) {
    return DJ:PlayerAudioDj[playerid];
}
stock DJ:SetPlayer(playerid, bool:status) {
    DJ:PlayerAudioDj[playerid] = status;
    return 1;
}
stock DJ:SetPlayerAsDj(playerid, bool:status) {
    DJ:SetPlayer(playerid, status);
    Database:UpdateInt(status, GetPlayerNameEx(playerid), "username", "isDJ", "playerdata");
    return 1;
}
stock DJ:GetStatusTTS(playerid) {
    return DJ:PlayerAudioTTS[playerid];
}
stock DJ:SetStatusTTS(playerid, bool:status) {
    DJ:PlayerAudioTTS[playerid] = status;
    return 1;
}
stock DJ:GetStatusMP3(playerid) {
    return DJ:PlayerAudioMp3[playerid];
}
stock DJ:SetStatusMP3(playerid, bool:status) {
    DJ:PlayerAudioMp3[playerid] = status;
    return 1;
}

new EtShop:DataMp3[MAX_PLAYERS];

stock EtShop:IsMp3Active(playerid) {
    return gettime() < EtShop:DataMp3[playerid];
}

stock EtShop:GetMp3(playerid) {
    return EtShop:DataMp3[playerid];
}

stock EtShop:SetMp3(playerid, expireAt) {
    EtShop:DataMp3[playerid] = expireAt;
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    EtShop:SetMp3(playerid, Database:GetInt(GetPlayerNameEx(playerid), "username", "MP3"));
    DJ:SetStatusTTS(playerid, false);
    DJ:SetStatusMP3(playerid, false);
    DJ:SetPlayer(playerid, false);
    DJ:SetPlayer(playerid, (Database:GetInt(GetPlayerNameEx(playerid), "username", "isDJ", "playerdata") ? true : false));
    return 1;
}

DC_CMD:stream(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new streamurl[128];
    if (sscanf(params, "s[128]", streamurl)) return DCC_SendChannelMessage(DCC_Channel:channel, "[USAGE]:!stream [URL]");
    foreach(new i:Player) if (DJ:GetStatusTTS(i)) PlayAudioStreamForPlayer(i, streamurl);
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("playing:%s", streamurl));
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "isDJ", "int", "0");
    Database:AddColumn("playerdata", "MP3", "int", "0");
    new query[512];
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS `djPlaylist` (\
	  `ID` int(11) NOT NULL AUTO_INCREMENT,\
	  `Name` varchar(125) NOT NULL,\
	  `PlayerName` varchar(50) NOT NULL,\
	  PRIMARY KEY  (`ID`))");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `djPlaylistSongs` (\
	  `ID` int NOT NULL AUTO_INCREMENT,\
	  `PlayListID` int NOT NULL,\
	  `Song` varchar(125) NOT NULL,\
	  `Length` int NOT NULL,\
	  `PlayerName` varchar(50) NOT NULL,\
	  PRIMARY KEY  (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");
    return 1;
}

stock DJ:GetPlayerlistSongName(songid) {
    new query[128], Cache:mysql_cache, title[125] = "Unknown";
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylistSongs where ID = %d", songid);
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) cache_get_value_name(0, "Song", title, sizeof title);
    cache_delete(mysql_cache);
    return title;
}

stock DJ:GetPlaylistSongCreater(songid) {
    new query[128], Cache:mysql_cache, title[125] = "Unknown";
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylistSongs where ID = %d", songid);
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) cache_get_value_name(0, "PlayerName", title, sizeof title);
    cache_delete(mysql_cache);
    return title;
}

stock DJ:GetPlaylistName(PlayListID) {
    new query[128], Cache:mysql_cache, title[125] = "Unknown";
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylist where ID = %d", PlayListID);
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) cache_get_value_name(0, "Name", title, sizeof title);
    cache_delete(mysql_cache);
    return title;
}

stock DJ:GetPlayerlistCreatorName(PlayListID) {
    new query[128], Cache:mysql_cache, title[125] = "Unknown";
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylist where ID = %d", PlayListID);
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) cache_get_value_name(0, "PlayerName", title, sizeof title);
    cache_delete(mysql_cache);
    return title;
}

new DJTimerID;
forward DJRemixPlayList();
public DJRemixPlayList() {
    if (!DJRemixPlayList_Status) return 1;
    new query[128], Cache:mysql_cache, title[125], Length;
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylistSongs ORDER BY RAND() LIMIT 1");
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) {
        new string[512];
        cache_get_value_name_int(0, "Length", Length);
        cache_get_value_name(0, "Song", title, sizeof title);
        format(string, sizeof(string), "{4286f4}[Alexa]: {FFFFEE}auto playing {FFCC66}%s", title);
        foreach(new i:Player) if (DJ:GetStatusMP3(i)) SendClientMessageEx(i, -1, string);
        format(string, sizeof string, "https://iorp.in/music/%s", title);
        foreach(new i:Player) if (DJ:GetStatusMP3(i)) PlayAudioStreamForPlayer(i, string);
        DeletePreciseTimer(DJTimerID);
        DJTimerID = SetPreciseTimer("DJRemixPlayList", Length * 60, false);
    }
    cache_delete(mysql_cache);
    return 1;
}

forward DJAutoPlayList(PlayListID);
public DJAutoPlayList(PlayListID) {
    if (!DJAutoPlayList_Status) return 1;
    if (DJAutoPlayList_ID == -1) return 1;
    new query[128], Cache:mysql_cache, title[125], Length;
    mysql_format(Database, query, sizeof(query), "SELECT * from djPlaylistSongs where PlayListID = %d ORDER BY RAND() LIMIT 1", PlayListID);
    mysql_cache = mysql_query(Database, query);
    new rows = cache_num_rows();
    if (rows) {
        new string[512];
        cache_get_value_name_int(0, "Length", Length);
        cache_get_value_name(0, "Song", title, sizeof title);
        format(string, sizeof(string), "{4286f4}[Alexa]: {FFFFEE}auto playing {FFCC66}%s {FFFFEE} from playlist %s", title, DJ:GetPlaylistName(PlayListID));
        foreach(new i:Player) if (DJ:GetStatusMP3(i)) SendClientMessageEx(i, -1, string);
        format(string, sizeof string, "https://iorp.in/music/%s", title);
        foreach(new i:Player) if (DJ:GetStatusMP3(i)) PlayAudioStreamForPlayer(i, string);
        KillTimer(DJTimerID);
        DJTimerID = SetTimerEx("DJAutoPlayList", Length * 60, false, "d", PlayListID);
    }
    cache_delete(mysql_cache);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    Database:UpdateInt(EtShop:GetMp3(playerid), GetPlayerNameEx(playerid), "username", "MP3");
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Electronic) return 1;
    if (shopItemId != 35) return 1;
    if (EtShop:IsMp3Active(playerid)) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you already have mp3 player, no need to purchase it again until it expires."); return ~1; }
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase mp3 player"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s electronic item from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased electronic item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    EtShop:SetMp3(playerid, gettime() + 30 * 24 * 60 * 60);
    SendClientMessageEx(playerid, -1, "{4286f4}[Digital Shop]: {FFFFFF}You have purchased mp3 player. Validity: 30 days");
    return ~1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (EtShop:IsMp3Active(playerid)) UCP:AddCommand(playerid, "MP3 Player");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("MP3 Player", inputtext)) DJ:OpenPanel(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (GetPlayerVIPLevel(playerid) < 1) return 1;
    if (IsStringContainWords(text, "enable mp3, start mp3")) {
        if (DJ:GetStatusMP3(playerid)) return GameTextForPlayer(playerid, "~w~MP3 Streams already ~r~Enabled", 1000, 3);
        DJ:SetStatusMP3(playerid, true);
        GameTextForPlayer(playerid, "~w~MP3 Streams ~r~Enabled", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "disable mp3, stop mp3")) {
        if (!DJ:GetStatusMP3(playerid)) return GameTextForPlayer(playerid, "~w~MP3 Streams already ~r~Disabled", 1000, 3);
        DJ:SetStatusMP3(playerid, false);
        GameTextForPlayer(playerid, "~w~MP3 Streams ~r~Disabled", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "enable tts, start tts")) {
        if (DJ:GetStatusTTS(playerid)) return GameTextForPlayer(playerid, "~w~TTS Streams already ~r~Enabled", 1000, 3);
        DJ:SetStatusTTS(playerid, true);
        GameTextForPlayer(playerid, "~w~TTS Streams ~r~Enabled", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "disable tts, stop tts")) {
        if (!DJ:GetStatusTTS(playerid)) return GameTextForPlayer(playerid, "~w~TTS Streams already ~r~Disabled", 1000, 3);
        DJ:SetStatusTTS(playerid, false);
        GameTextForPlayer(playerid, "~w~TTS Streams ~r~Disabled", 1000, 3);
        return ~1;
    }
    if (IsStringContainWords(text, "aplay") && (GetPlayerAdminLevel(playerid) > 0 || DJ:IsPlayer(playerid))) {
        new song[128];
        sscanf(text, "s[128]", song);
        if (strreplace(song, "aplay ", "", false, 0, 1) == 0) strreplace(song, "aplay", "", false, 0, 1);
        if (isnull(song)) {
            SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} what to play?");
            return ~1;
        }
        foreach(new i:Player) {
            if (!DJ:GetStatusMP3(i)) continue;
            SendClientMessageEx(i, -1, sprintf("{4286f4}[Alexa]:{FFFFEE}DJ %s playing {FFCC66}%s {FFFFEE}for you", GetPlayerNameEx(playerid), song));
            PlayAudioStreamForPlayer(i, sprintf("https://iorp.in/music/%s", song));
        }
        return ~1;
    }
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("UPDATE `djPlaylist` SET `PlayerName` = \"%s\" WHERE  `PlayerName` = \"%s\"", NewName, OldName));
    mysql_tquery(Database, sprintf("UPDATE `djPlaylistSongs` SET `PlayerName` = \"%s\" WHERE  `PlayerName` = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("DELETE FROM `djPlaylist` WHERE `PlayerName` = \"%s\"", AccountName));
    mysql_tquery(Database, sprintf("DELETE FROM `djPlaylistSongs` WHERE `PlayerName` = \"%s\"", AccountName));
    return 1;
}

stock DJ:OpenPanel(playerid) {
    new string[512];
    if (GetPlayerAdminLevel(playerid) == 10 || DJ:IsPlayer(playerid)) strcat(string, "Play Music for All\n");
    if (GetPlayerAdminLevel(playerid) == 10) strcat(string, "Play Direct URL\n");
    strcat(string, "Play Music\n");
    strcat(string, "View DJ PlayList\n");
    strcat(string, "Stop Current Stream\n");
    if (!DJ:GetStatusMP3(playerid)) strcat(string, "Enable MP3 Streams\n");
    if (DJ:GetStatusMP3(playerid)) strcat(string, "Disable MP3 Streams\n");
    if (!DJ:GetStatusTTS(playerid)) strcat(string, "Enable TTS Streams\n");
    if (DJ:GetStatusTTS(playerid)) strcat(string, "Disable TTS Streams\n");
    return FlexPlayerDialog(playerid, "DJOpenPanel", DIALOG_STYLE_LIST, "{4286f4}[DJ System]: {FFFFEE}Main Panel", string, "Select", "Close");
}

FlexDialog:DJOpenPanel(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Play Direct URL", inputtext)) return DJ:MenuPlayDirectURL(playerid);
    if (IsStringSame("Play Music for All", inputtext)) return DJ:MenuPlayMusicforAll(playerid);
    if (IsStringSame("Play Music", inputtext)) return DJ:MenuPlayMusic(playerid);
    if (IsStringSame("View DJ PlayList", inputtext)) return DJ:ViewPlaylist(playerid);
    if (IsStringSame("Stop Current Stream", inputtext)) {
        AlexaMsg(playerid, "turned off current stream", "DJ");
        StopAudioStreamForPlayer(playerid);
        return DJ:OpenPanel(playerid);
    }
    if (IsStringSame("Enable MP3 Streams", inputtext)) {
        DJ:SetStatusMP3(playerid, true);
        AlexaMsg(playerid, "enabled mp3 streams", "DJ");
        return DJ:OpenPanel(playerid);
    }
    if (IsStringSame("Disable MP3 Streams", inputtext)) {
        DJ:SetStatusMP3(playerid, false);
        AlexaMsg(playerid, "disabled mp3 streams", "DJ");
        return DJ:OpenPanel(playerid);
    }
    if (IsStringSame("Enable TTS Streams", inputtext)) {
        DJ:SetStatusTTS(playerid, true);
        AlexaMsg(playerid, "enabled tts streams", "DJ");
        return DJ:OpenPanel(playerid);
    }
    if (IsStringSame("Disable TTS Streams", inputtext)) {
        DJ:SetStatusTTS(playerid, false);
        AlexaMsg(playerid, "disabled tts streams", "DJ");
        return DJ:OpenPanel(playerid);
    }
    return 1;
}

stock DJ:MenuPlayDirectURL(playerid) {
    return FlexPlayerDialog(playerid, "DJMenuPlayDirectURL", DIALOG_STYLE_INPUT, "{4286f4}[DJ System]: {FFFFEE}Play Direct URL", "Enter Direct URL", "Submit", "Close");
}

FlexDialog:DJMenuPlayDirectURL(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DJ:OpenPanel(playerid);
    new song[128];
    if (sscanf(inputtext, "s[128]", song)) return DJ:MenuPlayDirectURL(playerid);
    SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}DJ %s playing {FFCC66}%s {FFFFEE}for you", GetPlayerNameEx(playerid), song));
    PlayAudioStreamForPlayer(playerid, sprintf("%s", song));
    return DJ:OpenPanel(playerid);
}

stock DJ:MenuPlayMusicforAll(playerid) {
    return FlexPlayerDialog(playerid, "DJMenuPlayMusicforAll", DIALOG_STYLE_INPUT, "{4286f4}[DJ System]: {FFFFEE}Play Music for all", "Enter [Song Name]", "Submit", "Close");
}

FlexDialog:DJMenuPlayMusicforAll(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DJ:OpenPanel(playerid);
    new song[128];
    if (sscanf(inputtext, "s[128]", song)) return DJ:MenuPlayMusicforAll(playerid);
    foreach(new i:Player) {
        if (!DJ:GetStatusMP3(i)) continue;
        SendClientMessageEx(i, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}DJ %s playing {FFCC66}%s {FFFFEE}for you", GetPlayerNameEx(playerid), song));
        PlayAudioStreamForPlayer(i, sprintf("https://iorp.in/music/%s", song));
    }
    return DJ:OpenPanel(playerid);
}

stock DJ:MenuPlayMusic(playerid) {
    return FlexPlayerDialog(playerid, "DJMenuPlayMusic", DIALOG_STYLE_INPUT, "{4286f4}[DJ System]: {FFFFEE}Play Music for yourself ", "Enter [Song Name]", "Submit", "Close");
}

FlexDialog:DJMenuPlayMusic(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return DJ:OpenPanel(playerid);
    new string[128], song[144];
    if (sscanf(inputtext, "s[128]", song)) return DJ:MenuPlayMusic(playerid);
    format(string, sizeof string, "{4286f4}[Alexa]: {FFFFEE}playing {FFCC66}%s {FFFFEE}for you", song);
    SendClientMessageEx(playerid, COLOR_GREY, string);
    format(string, sizeof string, "https://iorp.in/music/%s", song);
    PlayAudioStreamForPlayer(playerid, string);
    return DJ:OpenPanel(playerid);
}

stock DJ:GetTotalPlaylist() {
    new Cache:result = mysql_query(Database, "select count(*) as total from djPlaylist");
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock DJ:GetTotalPlaylistSongs(playlistid) {
    new Cache:result = mysql_query(Database, sprintf("select count(*) as total from djPlaylistSongs where PlayListID = %d", playlistid));
    new total = 0;
    cache_get_value_name_int(0, "total", total);
    cache_delete(result);
    return total;
}

stock DJ:ViewPlaylist(playerid, page = 0) {
    new total = DJ:GetTotalPlaylist();
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new skip = page * perpage;
    new remaining = total - paged;

    new string[2000], Id, PlayerName[50], title[125];
    strcat(string, "ID\tTitle\tCreated By\n");

    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * from djPlaylist limit %d, %d", skip, perpage));
    new rows = cache_num_rows();
    if (rows) {
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", Id);
            cache_get_value_name(i, "Name", title, sizeof title);
            cache_get_value_name(i, "PlayerName", PlayerName, sizeof PlayerName);
            strcat(string, sprintf("%d\t%s\t%s\n", Id, title, PlayerName));
        }
    } else SendClientMessageEx(playerid, -1, "{4286f4}[DJ System]: {FFFFEE}could not found any PlayList");
    cache_delete(mysql_cache);

    if (DJ:IsPlayer(playerid)) strcat(string, "Add New PlayList\n");
    if (DJ:IsPlayer(playerid) && !DJRemixPlayList_Status) strcat(string, "Enable Remix PlayList\n");
    if (DJ:IsPlayer(playerid) && DJRemixPlayList_Status) strcat(string, "Disable Remix PlayList\n");

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(playerid, "DJViewPlaylist", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[DJ System]: {FFFFEE}PlayList", string, "Select", "Close", page);
}

FlexDialog:DJViewPlaylist(playerid, response, listitem, const inputtext[], page, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Add New PlayList")) return DJ:MenuAddPlaylist(playerid);
    if (IsStringSame(inputtext, "Next Page")) return DJ:ViewPlaylist(playerid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return DJ:ViewPlaylist(playerid, page - 1);
    if (IsStringSame(inputtext, "Enable Remix PlayList")) {
        DJRemixPlayList_Status = true;
        DJAutoPlayList_ID = -1;
        DJAutoPlayList_Status = false;
        DJRemixPlayList();
        GameTextForAll("~w~Auto Remix Playlist ~r~Enabled", 1000, 3);
        return DJ:ViewPlaylist(playerid, page);
    }
    if (IsStringSame(inputtext, "Disable Remix PlayList")) {
        DJRemixPlayList_Status = true;
        DJAutoPlayList_ID = -1;
        DJRemixPlayList_Status = false;
        GameTextForAll("~w~Auto Remix Playlist ~r~Disabled", 1000, 3);
        return DJ:ViewPlaylist(playerid, page);
    }
    new playlistid = strval(inputtext);
    return DJ:ViewPlaylistSongs(playerid, playlistid);
}

stock DJ:MenuAddPlaylist(playerid) {
    return FlexPlayerDialog(playerid, "DJMenuAddPlaylist", DIALOG_STYLE_INPUT, "{4286f4}[DJ System]: {FFFFEE}New PlayList", "Enter PlayList Name", "Create", "Close");
}

FlexDialog:DJMenuAddPlaylist(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new name[125];
    if (sscanf(inputtext, "s[125]", name)) return DJ:MenuAddPlaylist(playerid);
    mysql_tquery(Database, sprintf("insert into djPlaylist set `Name` = \"%s\", `PlayerName` = \"%s\"", name, GetPlayerNameEx(playerid)));
    AlexaMsg(playerid, sprintf("new playlist added: %s", name));
    return DJ:ViewPlaylist(playerid);
}

stock DJ:ViewPlaylistSongs(playerid, playlistid, page = 0) {
    new total = DJ:GetTotalPlaylistSongs(playlistid);
    new perpage = 15;
    new paged = (page + 1) * perpage;
    new skip = page * perpage;
    new remaining = total - paged;

    new string[2000], Id, PlayerName[50], title[125], Length;
    strcat(string, "ID\tSong\tLength\tCreated By\n");

    new Cache:mysql_cache = mysql_query(Database, sprintf("SELECT * from djPlaylistSongs where playlistid = %d limit %d, %d", playlistid, skip, perpage));
    new rows = cache_num_rows();
    if (rows) {
        for (new i; i < rows; ++i) {
            cache_get_value_name_int(i, "ID", Id);
            cache_get_value_name(i, "Song", title, sizeof title);
            cache_get_value_name_int(i, "Length", Length);
            cache_get_value_name(i, "PlayerName", PlayerName, sizeof PlayerName);
            strcat(string, sprintf("%d\t%s\t%d\t%s\n", Id, title, Length, PlayerName));
        }
    } else SendClientMessageEx(playerid, -1, "{4286f4}[DJ System]: {FFFFEE}could not found any PlayList");
    cache_delete(mysql_cache);

    if (DJ:IsPlayer(playerid)) strcat(string, "Add New Song\n");
    if (DJ:IsPlayer(playerid) && !DJAutoPlayList_Status) strcat(string, "Enable Autoplay PlayList\n");
    if (DJ:IsPlayer(playerid) && DJAutoPlayList_Status) strcat(string, "Disable Autoplay PlayList\n");
    if (DJ:IsPlayer(playerid)) strcat(string, "Rename PlayList\n");
    if (DJ:IsPlayer(playerid)) strcat(string, "Remove PlayList\n");

    if (remaining > 0) strcat(string, "Next Page\n");
    if (page > 0) strcat(string, "Back Page\n");

    return FlexPlayerDialog(
        playerid, "DJViewPlaylistSongs", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[DJ System]: {FFFFEE}PlayList Songs",
        string, "Select", "Close", playlistid, sprintf("%d", page)
    );
}

FlexDialog:DJViewPlaylistSongs(playerid, response, listitem, const inputtext[], playlistid, const payload[]) {
    new page = strval(payload);
    if (!response) return DJ:ViewPlaylist(playerid);
    if (IsStringSame(inputtext, "Next Page")) return DJ:ViewPlaylistSongs(playerid, playlistid, page + 1);
    if (IsStringSame(inputtext, "Back Page")) return DJ:ViewPlaylistSongs(playerid, playlistid, page - 1);
    if (IsStringSame(inputtext, "Add New Song")) return DJ:MenuAddNewSong(playerid, playlistid);
    if (IsStringSame(inputtext, "Rename PlayList")) return DJ:MenuRenamePlayList(playerid, playlistid);
    if (IsStringSame(inputtext, "Remove PlayList")) {
        mysql_tquery(Database, sprintf("delete from djPlaylistSongs where playlistid = %d", playlistid));
        mysql_tquery(Database, sprintf("delete from djPlaylist where ID = %d", playlistid));
        AlexaMsg(playerid, sprintf("removed playlist %d", playlistid));
        return DJ:OpenPanel(playerid);
    }
    if (IsStringSame(inputtext, "Enable Autoplay PlayList")) {
        DJAutoPlayList_ID = playlistid;
        DJAutoPlayList_Status = true;
        DJRemixPlayList_Status = false;
        DJAutoPlayList(playlistid);
        GameTextForAll(sprintf("~w~Auto Remix for %s Playlist ~r~Enabled", DJ:GetPlaylistName(playlistid)), 1000, 3);
        return DJ:ViewPlaylistSongs(playerid, playlistid, page);
    }
    if (IsStringSame(inputtext, "Disable Autoplay PlayList")) {
        DJAutoPlayList_ID = -1;
        DJAutoPlayList_Status = false;
        DJRemixPlayList_Status = false;
        GameTextForAll(sprintf("~w~Auto Remix for %s Playlist ~r~Disabled", DJ:GetPlaylistName(playlistid)), 1000, 3);
        return DJ:ViewPlaylistSongs(playerid, playlistid, page);
    }
    new songid = strval(inputtext);
    return DJ:MenuSongOptions(playerid, playlistid, songid);
}

stock DJ:MenuAddNewSong(playerid, playlistid) {
    return FlexPlayerDialog(playerid, "DJMenuAddNewSong", DIALOG_STYLE_INPUT, "Manage Playlist", "", "Submit", "Cancel", playlistid);
}

FlexDialog:DJMenuAddNewSong(playerid, response, listitem, const inputtext[], playlistid, const payload[]) {
    if (!response) return DJ:ViewPlaylistSongs(playerid, playlistid);
    new song[100], Length;
    if (sscanf(inputtext, "p<,>ds[100]", Length, song)) return DJ:MenuAddNewSong(playerid, playlistid);
    mysql_tquery(Database, sprintf(
        "insert into djPlaylistSongs set `PlayListID` = %d, `Song` = \"%s\", `Length` = %d, `PlayerName` = \"%s\"",
        playlistid, song, Length, GetPlayerNameEx(playerid)
    ));
    AlexaMsg(playerid, sprintf("New Song Added: {FFFFFF} %s Length = %d", song, Length));
    return DJ:ViewPlaylistSongs(playerid, playlistid);
}

stock DJ:MenuRenamePlayList(playerid, playlistid) {
    return FlexPlayerDialog(playerid, "DJMenuRenamePlayList", DIALOG_STYLE_INPUT, "Manage Playlist", "", "Submit", "Cancel", playlistid);
}

FlexDialog:DJMenuRenamePlayList(playerid, response, listitem, const inputtext[], playlistid, const payload[]) {
    if (!response) return DJ:ViewPlaylistSongs(playerid, playlistid);
    new name[100];
    if (sscanf(inputtext, "s[100]", name)) return DJ:MenuRenamePlayList(playerid, playlistid);
    mysql_tquery(Database, sprintf("update djPlaylist set Name = \"%s\" where ID = %d", name, playlistid));
    AlexaMsg(playerid, sprintf("renamed playlist id %d to %s", playlistid, name));
    return DJ:ViewPlaylistSongs(playerid, playlistid);
}

stock DJ:MenuSongOptions(playerid, playlistid, songid) {
    new string[2000];
    strcat(string, "Play This Song\n");
    if (DJ:IsPlayer(playerid)) strcat(string, "Play This Song for all\n");
    if (DJ:IsPlayer(playerid)) strcat(string, "Rename This Song\n");
    if (DJ:IsPlayer(playerid)) strcat(string, "Remove This Song\n");
    return FlexPlayerDialog(
        playerid, "DJMenuSongOptions", DIALOG_STYLE_LIST, "{4286f4}[DJ System]: {FFFFEE}Song Actions", string, "Select", "Close", playlistid, sprintf("%d", songid)
    );
}

FlexDialog:DJMenuSongOptions(playerid, response, listitem, const inputtext[], playlistid, const payload[]) {
    new songid = strval(payload);
    new songName[125];
    format(songName, sizeof songName, "%s", DJ:GetPlayerlistSongName(songid));
    if (!response) return DJ:ViewPlaylistSongs(playerid, playlistid);
    if (IsStringSame(inputtext, "Rename This Song")) return DJ:MenuRenameSong(playerid, playlistid, songid);
    if (IsStringSame(inputtext, "Play This Song")) {
        AlexaMsg(playerid, sprintf("playing {FFCC66}%s", songName));
        PlayAudioStreamForPlayer(playerid, sprintf("https://iorp.in/music/%s", songName));
        return DJ:MenuSongOptions(playerid, playlistid, songid);
    }
    if (IsStringSame(inputtext, "Play This Song for all")) {
        foreach(new i:Player) {
            if (!DJ:GetStatusMP3(i)) continue;
            AlexaMsg(i, sprintf("{FFCC66}%s{FFFFEE} playing {FFCC66}%s", GetPlayerNameEx(playerid), songName));
            PlayAudioStreamForPlayer(i, sprintf("https://iorp.in/music/%s", songName));
        }
        return DJ:MenuSongOptions(playerid, playlistid, songid);
    }
    if (IsStringSame(inputtext, "Remove This Song")) {
        mysql_tquery(Database, sprintf("delete from djPlaylistSongs where id = %d and playlistid = %d", songid, playlistid));
        AlexaMsg(playerid, sprintf("removed song %s from playlist", songName));
        return DJ:ViewPlaylistSongs(playerid, playlistid);
    }
    return 1;
}

stock DJ:MenuRenameSong(playerid, playlistid, songid) {
    return FlexPlayerDialog(playerid, "DJMenuRenameSong", DIALOG_STYLE_INPUT, "Menu", "Enter", "Submit", "Cancel", playlistid, sprintf("%d", songid));
}

FlexDialog:DJMenuRenameSong(playerid, response, listitem, const inputtext[], playlistid, const payload[]) {
    new songid = strval(payload);
    if (!response) return DJ:MenuSongOptions(playerid, playlistid, songid);
    new song[100], Length;
    if (sscanf(inputtext, "p<,>ds[100]", Length, song)) return DJ:MenuRenameSong(playerid, playlistid, songid);
    mysql_tquery(Database, sprintf("update djPlaylistSongs set `Song` = \"%s\", `Length` = %d where ID = %d and PlayListID = %d", song, Length, songid, playlistid));
    AlexaMsg(playerid, sprintf("song renamed to %s", song));
    return DJ:MenuSongOptions(playerid, playlistid, songid);
}