#define FirstLoginCol "FirstLogin"

hook OnGameModeInit() {
    Database:AddColumn("playerdata", FirstLoginCol, "int", "1");
    return 1;
}

hook OnPlayerLogin(playerid) {
    if (!bool:Database:GetBool(GetPlayerNameEx(playerid), "username", FirstLoginCol)) return 1;
    vault:PlayerVault(playerid, 50000, "joining relief fund", Vault_ID_Government, -50000, sprintf("give to %s for first spawn", GetPlayerNameEx(playerid)));
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", FirstLoginCol);
    CallRemoteFunction("OnFirstLogin", "d", playerid);
    return 1;
}

forward OnFirstLogin(playerid);
public OnFirstLogin(playerid) {
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}use {f4353d}H+SPACE{FFCC66} or type {f4353d}/pocket{FFCC66} to open your pocket. type /help for a head start");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}San Andreas Government Department gave you $50,000 from public relief fund.");
    SendClientMessageEx(playerid, -1, "{4286f4}[Alexa]:{FFCC66}you can always go to cityhall to get more relief fund every hour.");
    GameTextForPlayer(playerid, "~w~Welcome~n~~y~In~n~~r~~h~~h~INDIAN ~w~OC~b~~h~~h~E~w~AN ~g~~h~~h~ROLEPLAY", 5000, 4);
    return 1;
}