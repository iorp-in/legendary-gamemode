//================Dialogs===================
new DIALOG_BOOMBOX;
new DIALOG_BOOMBOX1;
new DIALOG_BOOMBOX2;
new DIALOG_BOOMBOX3;
new DIALOG_BOOMBOX4;
new DIALOG_BOOMBOX5;
new DIALOG_BOOMBOX6;
new DIALOG_BOOMBOX7;
//==========================================

//===============Colors=====================
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COL_WHITE "{FFFFFF}"
#define COL_LBLUE "{00C3FF}"
#define COL_RED "{FF0000}"
#define COL_LIME "{00FF33}"

hook OnGameModeInit() {
    DIALOG_BOOMBOX = Dialog:GetFreeID();
    DIALOG_BOOMBOX1 = Dialog:GetFreeID();
    DIALOG_BOOMBOX2 = Dialog:GetFreeID();
    DIALOG_BOOMBOX3 = Dialog:GetFreeID();
    DIALOG_BOOMBOX4 = Dialog:GetFreeID();
    DIALOG_BOOMBOX5 = Dialog:GetFreeID();
    DIALOG_BOOMBOX6 = Dialog:GetFreeID();
    DIALOG_BOOMBOX7 = Dialog:GetFreeID();
    return 1;
}

//==========================================
hook OnPlayerDisconnect(playerid) {
    if (GetPVarType(playerid, "PlacedBB")) {
        DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
        if (GetPVarType(playerid, "BBArea")) {
            foreach(new i: Player) {
                if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                    StopAudioStreamForPlayer(i);
                    SendClientMessage(i, COLOR_LIGHTBLUE, " The boombox creator has disconnected from the server.");
                }
            }
        }
    }
    return 1;
}

CMD:bbhelp(playerid, params[]) {
    SendClientMessage(playerid, -1, "Boombox Commands---: /placeboombox /pickupboombox /setboombox---");
    return 1;
}

/*CMD:abbhelp(playerid, params[])// Part of Variable
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to use this command");
	SendClientMessage(playerid, -1, "Boombox Commands---: /giveboombox---");
	return 1;
}*/

/*CMD:giveboombox(playerid, params[]) // Part of Variable
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You are not authorized to use this command");
	new targetid, string[128], pname[MAX_PLAYER_NAME];
	if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE:/giveboombox [playerid]");
	Boombox[targetid] = 1;
	GetPlayerName(targetid, pname, sizeof(pname));
	format(string, sizeof(string), "You Have Given %s a Boombox", pname);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	SendClientMessage(targetid, COLOR_LIGHTBLUE, "You have been given a boombox by an administrator(/bbhelp)");
	return 1;
}*/

CMD:dance(playerid, params[]) //Dance Command to Dance to the boombox
{
    new animid;
    if (sscanf(params, "i", animid)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /dance [1-4]");
    if (animid < 1 || animid > 4) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /dance [1-4]");
    switch (animid) {
        case 1 : SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
        case 2 : SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
        case 3 : SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
        case 4 : SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
    }
    return 1;
}

CMD:placeboombox(playerid, params[]) {
    new string[128], Float:BBCoord[4], pName[MAX_PLAYER_NAME];
    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
    GetPlayerFacingAngle(playerid, BBCoord[3]);
    SetPVarFloat(playerid, "BBX", BBCoord[0]);
    SetPVarFloat(playerid, "BBY", BBCoord[1]);
    SetPVarFloat(playerid, "BBZ", BBCoord[2]);
    GetPlayerName(playerid, pName, sizeof(pName));
    BBCoord[0] += (2 * floatsin(-BBCoord[3], degrees));
    BBCoord[1] += (2 * floatcos(-BBCoord[3], degrees));
    BBCoord[2] -= 1.0;
    //if(Boombox[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a Boombox - Ask a Admin for one"); // Part of Variable
    if (GetPVarInt(playerid, "PlacedBB")) return SendClientMessage(playerid, -1, "You already placed a Boombox - use /pickupboombox");
    foreach(new i: Player) {
        if (GetPVarType(i, "PlacedBB")) {
            if (IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ"))) {
                SendClientMessage(playerid, COLOR_WHITE, "You cannot put your boombox in this Radius as their is already one placed in this radius");
                return 1;
            }
        }
    }
    new string2[128];
    format(string2, sizeof(string2), "%s has placed down an boombox!", pName);
    SendNearbyMessage(playerid, 15, string2, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    SetPVarInt(playerid, "PlacedBB", CreateDynamicObject(2226, BBCoord[0], BBCoord[1], BBCoord[2], 0.0, 0.0, 0.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
    format(string, sizeof(string), "Boombox Owner: %s\nUse /setboombox to set your boombox\n/pickupboombox to Pick up your boombox", pName);
    SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, -1, BBCoord[0], BBCoord[1], BBCoord[2] + 0.6, 5, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
    SetPVarInt(playerid, "BBArea", CreateDynamicSphere(BBCoord[0], BBCoord[1], BBCoord[2], 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
    SetPVarInt(playerid, "BBInt", GetPlayerInterior(playerid));
    SetPVarInt(playerid, "BBVW", GetPlayerVirtualWorld(playerid));
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:setboombox(playerid, params[]) {
    if (GetPVarType(playerid, "PlacedBB")) {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"))) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        } else {
            return SendClientMessage(playerid, -1, "You're not near in your BoomBox!");
        }
    } else {
        SendClientMessage(playerid, -1, " You don't have a boombox placed down!");
    }
    return 1;
}

CMD:pickupboombox(playerid, params[]) {
    if (!GetPVarInt(playerid, "PlacedBB")) {
        SendClientMessage(playerid, -1, "You haven't placed a Boombox!");
    }
    if (IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"))) {
        PickUpBoombox(playerid);
        SendClientMessage(playerid, -1, "Boombox picked up successfully.");
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid) {
    foreach(new i: Player) {
        if (GetPVarType(i, "BBArea")) {
            if (areaid == GetPVarInt(i, "BBArea")) {
                new station[256];
                GetPVarString(i, "BBStation", station, sizeof(station));
                if (!isnull(station)) {
                    PlayStream(playerid, station, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ"), 30.0, 1);
                    SendClientMessage(playerid, -1, "You have entered an boombox area");
                }
                return 1;
            }
        }
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid) {
    foreach(new i: Player) {
        if (GetPVarType(i, "BBArea")) {
            if (areaid == GetPVarInt(i, "BBArea")) {
                StopStream(playerid);
                SendClientMessage(playerid, -1, "You have left the boombox area");
                return 1;
            }
        }
    }
    return 1;
}

stock StopStream(playerid) {
    DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock PlayStream(playerid, const url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0) {
    if (GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
    else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock PickUpBoombox(playerid) {
    foreach(new i: Player) {
        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
            StopStream(i);
        }
    }
    DeletePVar(playerid, "BBArea");
    DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
    DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
    DeletePVar(playerid, "PlacedBB");
    DeletePVar(playerid, "BBLabel");
    DeletePVar(playerid, "BBX");
    DeletePVar(playerid, "BBY");
    DeletePVar(playerid, "BBZ");
    DeletePVar(playerid, "BBInt");
    DeletePVar(playerid, "BBVW");
    DeletePVar(playerid, "BBStation");
    return 1;
}

stock SendNearbyMessage(playerid, Float:radius, const string[], col1, col2, col3, col4, col5) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Float:ix, Float:iy, Float:iz;
    new Float:cx, Float:cy, Float:cz;
    foreach(new i: Player) {
        if (IsPlayerLoggedIn(i)) {
            if (GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
                GetPlayerPos(i, ix, iy, iz);
                cx = (x - ix);
                cy = (y - iy);
                cz = (z - iz);
                if (((cx < radius / 16) && (cx > -radius / 16)) && ((cy < radius / 16) && (cy > -radius / 16)) && ((cz < radius / 16) && (cz > -radius / 16))) {
                    SendClientMessage(i, col1, string);
                } else if (((cx < radius / 8) && (cx > -radius / 8)) && ((cy < radius / 8) && (cy > -radius / 8)) && ((cz < radius / 8) && (cz > -radius / 8))) {
                    SendClientMessage(i, col2, string);
                } else if (((cx < radius / 4) && (cx > -radius / 4)) && ((cy < radius / 4) && (cy > -radius / 4)) && ((cz < radius / 4) && (cz > -radius / 4))) {
                    SendClientMessage(i, col3, string);
                } else if (((cx < radius / 2) && (cx > -radius / 2)) && ((cy < radius / 2) && (cy > -radius / 2)) && ((cz < radius / 2) && (cz > -radius / 2))) {
                    SendClientMessage(i, col4, string);
                } else if (((cx < radius) && (cx > -radius)) && ((cy < radius) && (cy > -radius)) && ((cz < radius) && (cz > -radius))) {
                    SendClientMessage(i, col5, string);
                }
            }
        }
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if (dialogid == DIALOG_BOOMBOX) {
        if (!response) {
            SendClientMessage(playerid, COLOR_WHITE, " You cancel the Radio Station");
            return 1;
        }
        switch (listitem) {
            case 0 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX1, DIALOG_STYLE_LIST, "Jazz", "Smooth Jazz\nCrooze Jazz", "Select", "Cancel");
            }
            case 1 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX2, DIALOG_STYLE_LIST, "Pop", "Power FM\nCharHitz", "Select", "Cancel");
            }
            case 2 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX3, DIALOG_STYLE_LIST, "Rap", "RadioUP #1\nFlow 103 Rap", "Select", "Cancel");
            }
            case 3 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX4, DIALOG_STYLE_LIST, "Hip Hop", "Hot 108 Jamz\nThe Beat #1", "Select", "Cancel");
            }
            case 4 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX5, DIALOG_STYLE_LIST, "Rock", "Radio Paradise\nNoise FM", "Select", "Cancel");
            }
            case 5 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX6, DIALOG_STYLE_LIST, "Country", "181 Kicking Country\nAbsolute Country Radio", "Select", "Cancel");
            }
            case 6 :  {
                ShowPlayerDialog(playerid, DIALOG_BOOMBOX7, DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
            }
            case 7 :  {
                if (GetPVarType(playerid, "BBArea")) {
                    new string[128], pName[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, pName, sizeof(pName));
                    format(string, sizeof(string), "* %s has turned off their boombox.", pName);
                    SendNearbyMessage(playerid, 15, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            StopStream(i);
                        }
                    }
                    DeletePVar(playerid, "BBStation");
                }
                SendClientMessage(playerid, COLOR_WHITE, "You've turn off your boombox");
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX1) //JAZZ
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=467000", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=467000");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=146931", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=146931");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX2) //POP
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=13448", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=13448");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=31645", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=31645");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX3) //RAP
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=656213", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=656213");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=293191", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=293191");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX4) //HIP HOP
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=32999", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=32999");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=105867", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=105867");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX5) //ROCK
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=785339", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=785339");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=19275", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=19275");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX6) //COUNTRY
    {
        if (!response) {
            ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "Radio List", "Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox", "Select", "Cancel");
        }
        if (response) {
            if (listitem == 0) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=71887", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=71887");
                }
            }
            if (listitem == 1) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=34839", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=34839");
                }
            }
        }
        return 1;
    }
    if (dialogid == DIALOG_BOOMBOX7) //SET URL
    {
        if (response == 1) {
            if (isnull(inputtext)) {
                SendClientMessage(playerid, COLOR_WHITE, "You did not enter anything");
                return 1;
            }
            if (strlen(inputtext)) {
                if (GetPVarType(playerid, "PlacedBB")) {
                    foreach(new i: Player) {
                        if (IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) {
                            PlayStream(i, inputtext, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
                        }
                    }
                    SetPVarString(playerid, "BBStation", inputtext);
                }
            }
        } else {
            return 1;
        }
    }
    return 1;
}