#define MaxAirTransports 4

enum AirTransport:DataEnum {
    AirTransport:Name[100],
        Float:AirTransport:PickupLocation[3],
        Float:AirTransport:Location[3],
        STREAMER_TAG_PICKUP:AirTransport:pickupid,
        STREAMER_TAG_3D_TEXT_LABEL:AirTransport:labelid,
}

new AirTransport:Data[MaxAirTransports][AirTransport:DataEnum] = {
    {
        "Los Santos Airported",
        { 1730.2211, -2335.1963, 13.5469 },
        { 1729.9608, -2325.6174, 13.5469 },
        -1,
        Text3D:INVALID_3DTEXT_ID
    },
    {
        "San Fierro Airport",
        {-1421.3910, -287.2864, 14.1484 },
        {-1417.5212, -290.3842, 14.1484 },
        -1,
        Text3D:INVALID_3DTEXT_ID
    },
    {
        "Los Ventures Airport",
        { 1672.8000, 1448.0228, 10.7873 },
        { 1690.7159, 1448.3187, 10.7661 },
        -1,
        Text3D:INVALID_3DTEXT_ID
    },
    {
        "Abandoned Airport",
        { 415.5439, 2533.6543, 19.1484 },
        { 403.2433, 2530.1655, 16.5718 },
        -1,
        Text3D:INVALID_3DTEXT_ID
    }
};

new AirTransport:Timer[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    AirTransport:Timer[playerid] = -1;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    DeletePreciseTimer(AirTransport:Timer[playerid]);
    return 1;
}

hook OnGameModeInit() {
    for (new i; i < MaxAirTransports; i++) {
        AirTransport:Data[i][AirTransport:pickupid] = CreateDynamicPickup(
            19606, 2,
            AirTransport:Data[i][AirTransport:PickupLocation][0],
            AirTransport:Data[i][AirTransport:PickupLocation][1],
            AirTransport:Data[i][AirTransport:PickupLocation][2],
            0, 0
        );
        AirTransport:Data[i][AirTransport:labelid] = CreateDynamic3DTextLabel(
            sprintf("Welcome to %s\nUse airlines for fast travel to end of world\nFare: $250", AirTransport:Data[i][AirTransport:Name]),
            0xFFFF99FF,
            AirTransport:Data[i][AirTransport:Location][0],
            AirTransport:Data[i][AirTransport:Location][1],
            AirTransport:Data[i][AirTransport:Location][2],
            10.0
        );
    }
    return 1;
}

hook OnGameModeExit() {
    for (new i; i < MaxAirTransports; i++) {
        DestroyDynamicPickup(AirTransport:Data[i][AirTransport:pickupid]);
        DestroyDynamic3DTextLabel(AirTransport:Data[i][AirTransport:labelid]);
    }
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, STREAMER_TAG_PICKUP:pickupid) {
    for (new i; i < MaxAirTransports; i++) {
        if (AirTransport:Data[i][AirTransport:pickupid] == pickupid) {
            return AirTransport:Menu(playerid, i);
        }
    }
    return 1;
}

stock AirTransport:Menu(playerid, airid) {
    new string[512];
    strcat(string, "#\tAirport\tFare\tDuration\n");
    for (new i; i < MaxAirTransports; i++) {
        if (i == airid) continue;
        strcat(string, sprintf("%d\t%s\t$800\t2-5 Minutes", i, AirTransport:Data[i][AirTransport:Name]));
    }
    return FlexPlayerDialog(playerid, "AirTransportMenu", DIALOG_STYLE_TABLIST_HEADERS, "Welcome to Air India: Select your destination", string, "Select", "Close");
}

FlexDialog:AirTransportMenu(playerid, response, listitem, const inputtext[], airid, const payload[]) {
    if (!response) return 1;
    if (GetPlayerCash(playerid) < 800) {
        SendClientMessage(playerid, -1, "{db6600}[Alexa]:{FFFFEE} you don't have $800 to buy ticket.");
        return AirTransport:Menu(playerid, airid);
    }

    new nextAirportId = strval(inputtext);
    vault:PlayerVault(
        playerid, -800, sprintf("flight to %s", AirTransport:Data[nextAirportId][AirTransport:Name]),
        Vault_ID_Government, 800, sprintf("%s flight to %s", GetPlayerNameEx(playerid), AirTransport:Data[nextAirportId][AirTransport:Name])
    );

    SetPlayerVirtualWorldEx(playerid, playerid);
    SetPlayerInteriorEx(playerid, 1);
    SetPlayerPosEx(playerid, 1.808619, 32.384357, 1199.593750);
    new seconds = Random(120, 300);
    StartScreenTimer(playerid, seconds);
    AirTransport:Timer[playerid] = SetPreciseTimer("TeleportToAirport", seconds * 1000, false, "dd", playerid, nextAirportId);
    return 1;
}

forward TeleportToAirport(playerid, nextAirportId);
public TeleportToAirport(playerid, nextAirportId) {
    SetPlayerVirtualWorldEx(playerid, 0);
    SetPlayerInteriorEx(playerid, 0);
    SetPlayerPosEx(
        playerid,
        AirTransport:Data[nextAirportId][AirTransport:Location][0],
        AirTransport:Data[nextAirportId][AirTransport:Location][1],
        AirTransport:Data[nextAirportId][AirTransport:Location][2]
    );
    AlexaMsg(playerid, sprintf("welcome to %s", AirTransport:Data[nextAirportId][AirTransport:Name]));
    return 1;
}