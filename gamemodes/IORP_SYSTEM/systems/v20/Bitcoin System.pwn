hook OnGameModeInit() {
    Database:AddColumn("playerdata", "BitCoin", "int", "0");
    return 1;
}

stock BitCoin:Get(playerid) {
    return Database:GetInt(GetPlayerNameEx(playerid), "username", "BitCoin");
}

stock BitCoin:GiveOrTake(playerid, bitcoins, const log[]) {
    Database:UpdateInt(BitCoin:Get(playerid) + bitcoins, GetPlayerNameEx(playerid), "username", "BitCoin");
    AddBTCLog(playerid, bitcoins, log);
    return 1;
}

new BitCoin:StringTop[MAX_PLAYERS][2000];
new BitCoin:String[MAX_PLAYERS][2000];
stock BitCoin:Init(playerid, page = 0) {
    format(BitCoin:StringTop[playerid], 500, "");
    format(BitCoin:String[playerid], 2000, "");
    CallRemoteFunction("BitCoinOnInit", "dd", playerid, page);
    return 1;
}

forward BitCoinOnResponse(playerid, page, response, listitem, const inputtext[]);
public BitCoinOnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) BitCoin:Init(playerid, page - 1);
    //if(page == 0 && !response) User_Panel(playerid);
    return 1;
}

forward BitCoinOnInit(playerid, page);
public BitCoinOnInit(playerid, page) {
    SortString(BitCoin:StringTop[playerid], BitCoin:StringTop[playerid]);
    SortString(BitCoin:String[playerid], BitCoin:String[playerid]);
    if (!strlen(BitCoin:String[playerid])) format(BitCoin:String[playerid], 2000, "Nothing On This Page.");
    else BitCoin:AddCommand(playerid, "Next Page");
    if (page != 0) BitCoin:AddCommand(playerid, "Back Page");
    if (strlen(BitCoin:StringTop[playerid]) > 0) format(BitCoin:String[playerid], 2000, "%s\n%s", BitCoin:StringTop[playerid], BitCoin:String[playerid]);
    return FlexPlayerDialog(playerid, "BitCoinMenu", DIALOG_STYLE_LIST, sprintf("{4286f4}[Bitcoin]: {FFFFEE}Balance: %d BTC", BitCoin:Get(playerid)), BitCoin:String[playerid], "Select", "Close", page);
}

FlexDialog:BitCoinMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame("Nothing On This Page.", inputtext) && response) BitCoin:Init(playerid, extraid);
    else if (IsStringSame("Next Page", inputtext) && response) BitCoin:Init(playerid, extraid + 1);
    else if (IsStringSame("Back Page", inputtext) && response) BitCoin:Init(playerid, extraid - 1);
    else CallRemoteFunction("BitCoinOnResponse", "dddds", playerid, extraid, response, listitem, inputtext);
    return 1;
}

stock BitCoin:AddCommand(playerid, const command[], bool:top = false) {
    if (top) {
        if (!strlen(BitCoin:StringTop[playerid])) format(BitCoin:StringTop[playerid], 2000, "%s", command);
        else format(BitCoin:StringTop[playerid], 2000, "%s\n%s", BitCoin:StringTop[playerid], command);
    } else {
        if (!strlen(BitCoin:String[playerid])) format(BitCoin:String[playerid], 2000, "%s", command);
        else format(BitCoin:String[playerid], 2000, "%s\n%s", BitCoin:String[playerid], command);
    }
    return 1;
}

cmd:bitcoin(playerid, const params[]) {
    // if (GetPlayerRPMode(playerid)) { return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you can not use bitcoins in fight mode."); }
    if (IsPlayerInHeist(playerid)) { return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you can not use bitcoins in heist."); }
    if (Event:IsInEvent(playerid)) { return SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66} you can not use bitcoins in event."); }
    BitCoin:Init(playerid);
    return 1;
}

//#snippet init_bitcoin hook BitCoin@OnInit(playerid, page){if(page != 0) return 1;BitCoin:AddCommand(playerid, "Command");return 1;}hook BitCoin@OnResponse(playerid, page, response, listitem, const inputtext[]) {if(!response) return 1;if(IsStringSame("Command", inputtext)) {return ~1;} return 1;}
//#function GetVehicleName(vehicleid);

DC_CMD:givebitcoin(DCC_Message:message, const user[], const params[]) {
    new DCC_Channel:channel;
    DCC_GetMessageChannel(DCC_Message:message, DCC_Channel:channel);
    if (DCC_Channel:channel != DCC_Channel:Discord:IDManagement) return 0;
    new pID, bitcoin, reason[50];
    if (sscanf(params, "uis[50]", pID, bitcoin, reason)) return DCC_SendChannelMessage(DCC_Channel:channel, "[Usage]:!givebitcoin [PlayerID] [bitcoins] [reason]");
    else if (bitcoin < -500 || bitcoin > 500) return DCC_SendChannelMessage(DCC_Channel:channel, "[Error]:Invalid bitcoins -500 > bitcoins < 500 ");
    else if (pID == INVALID_PLAYER_ID) return DCC_SendChannelMessage(DCC_Channel:channel, "[Error]:Invalid PlayerID");
    new DCC_User:author, discordUser[DCC_USERNAME_SIZE];
    DCC_GetMessageAuthor(DCC_Message:message, DCC_User:author);
    DCC_GetUserName(DCC_User:author, discordUser);
    BitCoin:GiveOrTake(pID, bitcoin, sprintf("given by admin %s, reason: %s", discordUser, reason));
    SendClientMessage(pID, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} admin %s given you %d bitcoins", discordUser, bitcoin));
    SendClientMessage(pID, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} for Reason: %s", reason));
    DCC_SendChannelMessage(DCC_Channel:channel, sprintf("[Alexa]: %d bitcoins given to %s", bitcoin, GetPlayerNameEx(pID)));
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Bitcoin");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Bitcoin", inputtext)) {
        callcmd::bitcoin(playerid, "");
        return ~1;
    }
    return 1;
}