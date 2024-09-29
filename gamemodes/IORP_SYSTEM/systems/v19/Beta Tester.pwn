new bool:BetaTester:PlayerData[MAX_PLAYERS];
new bool:BetaTester:PlayerStatus[MAX_PLAYERS];

stock BetaTester:IsPlayer(playerid) {
    return BetaTester:PlayerData[playerid];
}

stock BetaTester:GetStatus(playerid) {
    return BetaTester:PlayerStatus[playerid];
}

stock BetaTester:SetStatus(playerid, bool:status) {
    BetaTester:PlayerStatus[playerid] = status;
    return status;
}

stock BetaTester:SetPlayer(playerid, bool:status) {
    BetaTester:PlayerData[playerid] = status;
    Database:UpdateBool(status, GetPlayerNameEx(playerid), "username", "beta_tester");
    return 1;
}

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "beta_tester", "boolean", "0");
    return 1;
}

hook OnPlayerConnect(playerid) {
    BetaTester:PlayerStatus[playerid] = false;
    return 1;
}

hook OnPlayerLogin(playerid) {
    BetaTester:PlayerData[playerid] = Database:GetBool(GetPlayerNameEx(playerid), "username", "beta_tester");
    return 1;
}


UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    if (BetaTester:IsPlayer(playerid)) UCP:AddCommand(playerid, "Enable/Disable Beta Mode");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page != 1 || !response) return 1;
    if (IsStringSame(inputtext, "Enable/Disable Beta Mode")) {
        SendClientMessageEx(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFEE} %s beta mode!", (BetaTester:GetStatus(playerid) ? "Disabled" : "Enabled")));
        BetaTester:SetStatus(playerid, !BetaTester:GetStatus(playerid));
    }
    return 1;
}