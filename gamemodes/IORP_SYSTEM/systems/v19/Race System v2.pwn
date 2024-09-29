//#region vars
#define RESPAWN_TIME 2000
#define RACE_VIRTUAL_WORLD 0
#define VEHICLE_LEAVE_TIME 25
#define RACE_CLEANUP_TIME 60000
#define INVITE_EXPIRE 60
#define MAX_PUBLIC_RACES 13
#define MAX_PRIVATE_RACES 25
#define MAX_RACE_DISTANCE 30000
#define MIN_RACE_DISTANCE 150
#define MAX_CHECKPOINTS 300
#define MAX_TEXTDRAW_ICONS 80
#define MAX_CONTESTANTS 8
#define MIN_CONTESTANTS 2
#define MINIMAL_DISTANCE_CP 500.0
#define MAX_SUGGESTED_MAPICONS 2

new RaceVehicleList[] = {
    415, // Cheetah
    411, // Infernus
    451, // Turismo
    560, // Sultan
    494, // Hotring Racer
    524, // Cement Truck
    407, // Firetruck
    444, // Monster Truck
    423, // Mr. Whoopee
    457, // Golf Caddy
    571, // Go-Kart
    594, // RC Cam
    568, // Bandito
    463, // Freeway
    461, // PCJ-600
    468, // Sanchez
    471, // Quadbike
    510, // Mountain Bike
    530, // Forklift
    539 // Vortex Hovercraft
};

// This defines whether the player is allowed to pick any vehicle using their ID.
// Note 1: this only adds an extra option to the vehicle list called "Enter a specific model ID", the above list will still exist.
// Note 2: this allows the player to also spawn airplanes, helicopters or invalid vehicles like trailers!
// Default: false
new bool:ALLOW_ALL_VEHICLES = false;


// These values define the vehicle colors used on the model defined at RACE_VEHICLE_MODEL or the vehicle in the race.
// Default: -1 and -1
#define RACE_VEHICLE_COL1 -1
#define RACE_VEHICLE_COL2 -1

// This is the offset, which will be used to create the suggested race checkpoints on the radar.
// Note 1: if this number is lower than 0 or higher than 99, the map icons might not show. (Limit of SA-MP 0.3x.)
// Note 2: the map icons IDs will start at this number. If you have 3 suggested icons (see MAX_SUGGESTED_MAPICONS), make sure this number isn't higher than 97 due to limits.
// Default: 80
#define SUGGESTED_MAPICONS_OFFSET 80

#define COL_MENU_REGULAR 0xFFFFFFFF
#define COL_MENU_MOUSEOVER 0xDD8080FF
#define COL_MENU_SELECTED 0xCF2C23FF
#define COL_MENU_STARTED 0x5B0000FF
#define COL_TEXT_REG 0xFFFFFFFF
#define COL_TEXT_WIN 0xFF2D2DFF
#define COL_TEXT_IMPORTANT 0xFF6262FF
#define COL_TEXT_ERROR 0xD21313FF // D21313
#define COL_MAP_CP 0x5B0000FF

#define MAX_RACES MAX_PUBLIC_RACES + MAX_PRIVATE_RACES

enum Race:EnumData {
    Race:Host,
    Race:VehicleModel,
    Race:Started,
    Race:PlayerAmount,
    Race:CPAmount,
    Race:FinishedPlayers,
    Float:Race:Distance,
    Race:EndTimer
}

new Race:Data[MAX_RACES][Race:EnumData];

new Race:PeopleInRace[MAX_RACES][MAX_CONTESTANTS][2];
new Float:Race:CheckpointList[MAX_RACES][MAX_CHECKPOINTS + 2][3];
new Text:Race:MapIcons[MAX_RACES][MAX_TEXTDRAW_ICONS];
new Race:AmountOfPrivateRaces = 0;

new Text:Race:joinMenuButtons[3] = { Text:INVALID_TEXT_DRAW, ... };
new Text:Race:joinMenuSlots[MAX_RACES] = { Text:INVALID_TEXT_DRAW, ... };
new Text:Race:joinMenuPrivate = Text:INVALID_TEXT_DRAW;
new Text:Race:joinMenuRaceInfo[MAX_RACES][3];
new Text:Race:joinMenuExtra[4] = { Text:INVALID_TEXT_DRAW, ... };

enum Race:PlayerDataEnum {
    Race:PDataCurrentInviteID,
    Race:PDataCurrentInviteTime,
    Race:PDataExitVehTimer, // Race:PlayerData[playerid][Race:PDataExitVehTimer]
    PlayerText:Race:PDataSubTextID, // Race:PlayerData[playerid][Race:PDataSubTextID]
    Race:PDataJoinRaceID, // Race:PlayerData[playerid][Race:PDataJoinRaceID]
    Race:PDataJoinMenuOpen, // Race:PlayerData[playerid][Race:PDataJoinMenuOpen]
    Race:PDataClosestNode, // Race:PlayerData[playerid][Race:PDataClosestNode]
    Race:PDataCurrentRaceID, // Race:PlayerData[playerid][Race:PDataCurrentRaceID]
    Race:PDataSelectedVehicle, // Race:PlayerData[playerid][Race:PDataSelectedVehicle]
    Float:Race:PDataTotalRaceDistance, // Race:PlayerData[playerid][Race:PDataTotalRaceDistance]
    Float:Race:PDataOldX, // Race:PlayerData[playerid][Race:PDataOldX]
    Float:Race:PDataOldY, // Race:PlayerData[playerid][Race:PDataOldY]
    Float:Race:PDataOldZ, // Race:PlayerData[playerid][Race:PDataOldZ]
    Float:Race:PDataOldR, // Race:PlayerData[playerid][Race:PDataOldR]
    Race:PDataOldInt, // Race:PlayerData[playerid][Race:PDataOldInt]
    Race:PDataOldVW, // Race:PlayerData[playerid][Race:PDataOldVW]
    Float:Race:PDataStartSpotX, // Race:PlayerData[playerid][Race:PDataStartSpotX]
    Float:Race:PDataStartSpotY, // Race:PlayerData[playerid][Race:PDataStartSpotY]
    Float:Race:PDataStartSpotZ, // Race:PlayerData[playerid][Race:PDataStartSpotZ]
    Float:Race:PDataStartSpotA, // Race:PlayerData[playerid][Race:PDataStartSpotA]
    Race:PDataStartSpotI, // Race:PlayerData[playerid][Race:PDataStartSpotI]
    PlayerText:Race:PDataRacePlayerTD, // Race:PlayerData[playerid][Race:PDataRacePlayerTD]
    Race:PDataCurrentVehID, // Race:PlayerData[playerid][Race:PDataCurrentVehID]
    Race:PDatarespawnTimer, // Race:PlayerData[playerid][Race:PDatarespawnTimer]
    Race:PDataIsFinished, // Race:PlayerData[playerid][Race:PDataIsFinished]
    Race:PDataCurrentCPID // Race:PlayerData[playerid][Race:PDataCurrentCPID]
}
new Race:PlayerData[MAX_PLAYERS][Race:PlayerDataEnum];

#define MENU_X 50.0
#define MENU_Y 145.0
//#endregion

hook OnGameModeInit() {
    // TD - background
    Race:joinMenuExtra[0] = TextDrawCreate(MENU_X, MENU_Y, "_");
    TextDrawUseBox(Race:joinMenuExtra[0], true);
    TextDrawLetterSize(Race:joinMenuExtra[0], 1.0, 30.0);
    TextDrawBoxColor(Race:joinMenuExtra[0], 0x77);
    TextDrawTextSize(Race:joinMenuExtra[0], MENU_X + 540.0, MENU_Y + 255.0);
    // TD - map
    Race:joinMenuExtra[1] = TextDrawCreate(MENU_X + 150.0, MENU_Y + 10.0, "samaps:map");
    TextDrawFont(Race:joinMenuExtra[1], 4);
    TextDrawTextSize(Race:joinMenuExtra[1], 250.0, 250.0);

    // TD - title
    Race:joinMenuExtra[2] = TextDrawCreate(320.0, MENU_Y - 18.0, "World Sportscar Championship");
    TextDrawFont(Race:joinMenuExtra[2], 0);
    TextDrawLetterSize(Race:joinMenuExtra[2], 1.3, 3.5); // 1.0, 2.75
    TextDrawSetOutline(Race:joinMenuExtra[2], 2);
    TextDrawAlignment(Race:joinMenuExtra[2], 2);

    // TD - description
    Race:joinMenuExtra[3] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 19.0, \
        "Welcome to the...~n~World Sportscar Championship!~n~~n~"\
        "You can create or join a race by selecting one of the slots on the left.~n~~n~"\
        "Each race is randomly generated along the roads of San Andreas; no race is the same as the last one.~n~~n~"\
        "The map will show you the current race track of each slot and more information about each race will be shown in this box."\
        " ______________________________ Have fun!");
    TextDrawColor(Race:joinMenuExtra[3], COL_MENU_REGULAR);
    TextDrawTextSize(Race:joinMenuExtra[3], MENU_X + 530.0, 500.0);
    TextDrawLetterSize(Race:joinMenuExtra[3], 0.25, 1.2);
    TextDrawSetOutline(Race:joinMenuExtra[3], 1);
    // TD - buttons
    Race:joinMenuButtons[0] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 245.0, " Create");
    Race:joinMenuButtons[1] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 245.0, " Join");
    Race:joinMenuButtons[2] = TextDrawCreate(MENU_X + 80.0, MENU_Y + 245.0, " Close");

    for (new b; b < sizeof(Race:joinMenuButtons); b++) // same looks for all buttons
    {
        TextDrawColor(Race:joinMenuButtons[b], COL_MENU_REGULAR);
        TextDrawLetterSize(Race:joinMenuButtons[b], 0.4, 1.5);
        TextDrawSetOutline(Race:joinMenuButtons[b], 1);
        TextDrawUseBox(Race:joinMenuButtons[b], true);
        TextDrawBoxColor(Race:joinMenuButtons[b], 0x55);
        if (b == 2) {
            TextDrawTextSize(Race:joinMenuButtons[b], MENU_X + 140.0, 12.0);
        } else {
            TextDrawTextSize(Race:joinMenuButtons[b], MENU_X + 70.0, 12.0);
        }
        TextDrawSetSelectable(Race:joinMenuButtons[b], true);
    }

    // TD - private race button
    Race:joinMenuPrivate = TextDrawCreate(MENU_X + 10.0, MENU_Y + 19.0 + float(MAX_PUBLIC_RACES * 15), sprintf("<0/%d> Create private race!", MAX_PRIVATE_RACES));
    TextDrawColor(Race:joinMenuPrivate, COL_MENU_REGULAR);
    TextDrawLetterSize(Race:joinMenuPrivate, 0.25, 1.2);
    TextDrawSetOutline(Race:joinMenuPrivate, 1);
    TextDrawTextSize(Race:joinMenuPrivate, MENU_X + 155.0, 12.0);
    TextDrawSetSelectable(Race:joinMenuPrivate, true);

    // TD - public race buttons
    for (new raceid; raceid < MAX_RACES; raceid++) {
        if (raceid < MAX_PUBLIC_RACES) {
            Race:joinMenuSlots[raceid] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 19.0 + float(raceid * 15), "<Empty> Create a race!");
            TextDrawColor(Race:joinMenuSlots[raceid], COL_MENU_REGULAR);
            TextDrawLetterSize(Race:joinMenuSlots[raceid], 0.25, 1.2);
            TextDrawSetOutline(Race:joinMenuSlots[raceid], 1);
            TextDrawTextSize(Race:joinMenuSlots[raceid], MENU_X + 155.0, 12.0);
            TextDrawSetSelectable(Race:joinMenuSlots[raceid], true);
        } else {
            Race:joinMenuSlots[raceid] = Text:INVALID_TEXT_DRAW;
        }

        Race:Data[raceid][Race:Host] = INVALID_PLAYER_ID;
        Race:Data[raceid][Race:EndTimer] = -1;

        for (new p; p < MAX_CONTESTANTS; p++) {
            Race:PeopleInRace[raceid][p][0] = INVALID_PLAYER_ID;
        }
        for (new t; t < sizeof(Race:joinMenuRaceInfo[]); t++) {
            Race:joinMenuRaceInfo[raceid][t] = Text:INVALID_TEXT_DRAW;
        }
        for (new i; i < MAX_TEXTDRAW_ICONS; i++) {
            Race:MapIcons[raceid][i] = Text:INVALID_TEXT_DRAW;
        }
    }
    return 1;
}

hook OnGameModeExit() {
    // Destroy all the textdraws:
    for (new b; b < sizeof(Race:joinMenuButtons); b++) {
        TextDrawHideForAll(Race:joinMenuButtons[b]);
        TextDrawDestroy(Race:joinMenuButtons[b]);
    }
    for (new e; e < sizeof(Race:joinMenuExtra); e++) {
        TextDrawHideForAll(Race:joinMenuExtra[e]);
        TextDrawDestroy(Race:joinMenuExtra[e]);
    }
    for (new raceid; raceid < MAX_RACES; raceid++) {
        Race:Clear(raceid);
        TextDrawHideForAll(Race:joinMenuSlots[raceid]);
        TextDrawDestroy(Race:joinMenuSlots[raceid]);

        for (new r; r < sizeof(Race:joinMenuRaceInfo[]); r++) {
            TextDrawHideForAll(Race:joinMenuRaceInfo[raceid][r]);
            TextDrawDestroy(Race:joinMenuRaceInfo[raceid][r]);
        }

        for (new i; i < MAX_TEXTDRAW_ICONS; i++) {
            if (Race:MapIcons[raceid][i] != Text:INVALID_TEXT_DRAW) {
                TextDrawHideForAll(Race:MapIcons[raceid][i]);
                TextDrawDestroy(Race:MapIcons[raceid][i]);
                Race:MapIcons[raceid][i] = Text:INVALID_TEXT_DRAW;
            }
        }
    }
    foreach(new playerid:Player) {
        Race:RemoveText(playerid);
        Race:PlayerData[playerid][Race:PDataExitVehTimer] = 0;
    }
    return 1;
}

hook OnPlayerSpawn(playerid) {
    // Respawn the player after they've died:
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (raceid) {
        raceid -= 2;
        if (Race:Data[raceid][Race:Host] != INVALID_PLAYER_ID) {
            Race:Respawn(playerid, raceid);
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) {
    Race:PlayerData[playerid][Race:PDataSubTextID] = PlayerText:INVALID_TEXT_DRAW;
    Race:PlayerData[playerid][Race:PDataRacePlayerTD] = CreatePlayerTextDraw(playerid, MENU_X + 410.0, MENU_Y + 100.0, "~r~   Position: ~w~0/0~n~~r~Checkpoint: ~w~0/0__");
    PlayerTextDrawColor(playerid, Race:PlayerData[playerid][Race:PDataRacePlayerTD], COL_MENU_REGULAR);
    PlayerTextDrawLetterSize(playerid, Race:PlayerData[playerid][Race:PDataRacePlayerTD], 0.25, 1.2);
    PlayerTextDrawSetOutline(playerid, Race:PlayerData[playerid][Race:PDataRacePlayerTD], 1);
    return 1;
}

hook OnPlayerDisconnect(playerid) {
    // Message everyone that the race has been canceled:
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (raceid) {
        raceid -= 2;
        if (Race:Data[raceid][Race:Host] == playerid) {
            for (new p; p < MAX_CONTESTANTS; p++) {
                if (Race:PeopleInRace[raceid][p][0] != INVALID_PLAYER_ID && Race:PeopleInRace[raceid][p][0] != playerid) {
                    SendClientMessageEx(Race:PeopleInRace[raceid][p][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}The race you had participated in has been called off.");
                }
            }
        }
    }

    // Remove player from race and cancel race if necessary:
    Race:RemoveFromRace(playerid);
    PlayerTextDrawDestroy(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);
    Race:PlayerData[playerid][Race:PDataRacePlayerTD] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

hook OnPlayerEnterRaceCP(playerid) {
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    // When the player enters a race checkpoint in his race vehicle without being finished
    if (raceid && IsPlayerInVehicle(playerid, Race:PlayerData[playerid][Race:PDataCurrentVehID]) && !Race:PlayerData[playerid][Race:PDataIsFinished]) {
        raceid -= 2;
        new cp = Race:PlayerData[playerid][Race:PDataCurrentCPID],
            startspot = Race:PlayerData[playerid][Race:PDataStartSpotI];

        if (!cp) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation of your checkpoint position. (Reference ID: 012)");
            return 1;
        }
        cp++;

        if (Race:PeopleInRace[raceid][startspot][0] != playerid) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation of your race position. (Reference ID: 006)");
        }

        if (Race:Data[raceid][Race:PlayerAmount] > 1) {
            // Get race position based on amount of CPs.
            new max_cps = MAX_CHECKPOINTS + 2, cur_top_cps = -1, cur_top_id = -1, ranking[MAX_CONTESTANTS];

            for (new r = Race:Data[raceid][Race:FinishedPlayers]; r < MAX_CONTESTANTS; r++) {
                // Find the best player for the current rank (r = rank ID, p = contestant ID):
                for (new p; p < MAX_CONTESTANTS; p++) {
                    if (Race:PeopleInRace[raceid][p][0] == INVALID_PLAYER_ID || ranking[p] || Race:PlayerData[Race:PeopleInRace[raceid][p][0]][Race:PDataIsFinished]) continue;

                    new pcp = (Race:PeopleInRace[raceid][p][0] == playerid) ? cp : Race:PlayerData[Race:PeopleInRace[raceid][p][0]][Race:PDataCurrentCPID];
                    if (max_cps >= pcp > cur_top_cps) // Check if player's CP amount is between current ranks highest and last ranks highest.
                    {
                        cur_top_id = p;
                        cur_top_cps = pcp;
                    } else if (pcp == cur_top_cps && cur_top_id != -1) // If 2 players have the same CP-amount
                    {
                        // Get CP distance current checking player
                        new Float:pos[2][3], Float:p_dist, Float:cur_top_dist;
                        GetPlayerPos(Race:PeopleInRace[raceid][p][0], pos[0][0], pos[0][1], pos[0][2]);
                        pos[0][0] -= Race:CheckpointList[raceid][pcp][0];
                        pos[0][1] -= Race:CheckpointList[raceid][pcp][1];
                        pos[0][2] -= Race:CheckpointList[raceid][pcp][1];
                        p_dist = floatsqroot((pos[0][0] * pos[0][0]) + (pos[0][1] * pos[0][1]) + (pos[0][2] * pos[0][2]));

                        // Get CP distance from current best player for this rank
                        GetPlayerPos(Race:PeopleInRace[raceid][cur_top_id][0], pos[1][0], pos[1][1], pos[1][2]);
                        pos[1][0] -= Race:CheckpointList[raceid][pcp][0];
                        pos[1][1] -= Race:CheckpointList[raceid][pcp][1];
                        pos[1][2] -= Race:CheckpointList[raceid][pcp][1];
                        cur_top_dist = floatsqroot((pos[1][0] * pos[1][0]) + (pos[1][1] * pos[1][1]) + (pos[1][2] * pos[1][2]));

                        // Compare the distance, if this player is closer -> make him top
                        if (cur_top_dist > p_dist) {
                            cur_top_id = p;
                            cur_top_cps = pcp;
                        }
                    }
                }

                // Set the current checking rank to the chosen player:
                if (cur_top_id != -1) {
                    max_cps = cur_top_cps;
                    ranking[cur_top_id] = r + 1;
                    cur_top_id = -1;
                    cur_top_cps = -1;
                } else {
                    break;
                }
            }

            // Update other players their GUI if necessary:
            for (new u; u < MAX_CONTESTANTS; u++) {
                if (Race:PeopleInRace[raceid][u][0] == INVALID_PLAYER_ID || !ranking[u]) continue;

                if (ranking[u] != Race:PeopleInRace[raceid][u][1]) {
                    Race:PeopleInRace[raceid][u][1] = ranking[u]; // Saving the race rank in the global list.

                    // Updating for current player will happen a bit later.
                    if (Race:PeopleInRace[raceid][u][0] != playerid && !Race:PlayerData[Race:PeopleInRace[raceid][u][0]][Race:PDataIsFinished]) {
                        Race:UpdatePlayerGUI(Race:PeopleInRace[raceid][u][0]);
                    }
                }
            }
        } else // If there's only one contestant, there's only one spot they can claim:first place! :3
        {
            Race:PeopleInRace[raceid][startspot][1] = 1;
        }

        Race:SetCheckpoint(playerid, raceid, cp);
        Race:UpdatePlayerGUI(playerid);
        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
    }
    return 1;
}

hook OnPlayerUpdate(playerid) {
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (raceid) {
        // If race hasn't started or if player is respawning, force him in his vehicle at all costs
        if (Race:Data[raceid - 2][Race:Started] != 2 || Race:PlayerData[playerid][Race:PDatarespawnTimer]) {
            new raceveh = Race:PlayerData[playerid][Race:PDataCurrentVehID], curveh = GetPlayerVehicleID(playerid), curstate = GetPlayerState(playerid);

            // Check if player is in different vehicle:remove them if required
            if (curveh && curveh != raceveh && curstate != PLAYER_STATE_ONFOOT) {
                new Float:oldpos[3];
                GetVehiclePos(curveh, oldpos[0], oldpos[1], oldpos[2]);
                SetPlayerPosEx(playerid, oldpos[0], oldpos[1], oldpos[2]);
            } else if (!curveh && raceveh && curstate == PLAYER_STATE_ONFOOT) {
                PutPlayerInVehicleEx(playerid, raceveh, 0);
            }
            TogglePlayerControllable(playerid, false);
        }
    }
    return 1;
}

hook OnVehicleStreamIn(vehicleid, forplayerid) {
    // Lock race vehicles for other players, no carjacking allowed!
    foreach(new p:Player) {
        if (!IsPlayerNPC(p) && IsPlayerConnected(p)) {
            new raceid = Race:PlayerData[p][Race:PDataCurrentRaceID], veh = Race:PlayerData[p][Race:PDataCurrentVehID];
            if (raceid && veh == vehicleid) {
                SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
                SetVehicleParamsForPlayer(veh, p, false, false);
                break;
            }
        }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (IsPlayerNPC(playerid)) return 1;
    // Put player in vehicle if it desynced out of it
    if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (raceid && (Race:Data[raceid - 2][Race:Started] != 2 || Race:PlayerData[playerid][Race:PDatarespawnTimer])) {
            new raceveh = Race:PlayerData[playerid][Race:PDataCurrentVehID], curveh = GetPlayerVehicleID(playerid);
            if (raceveh && curveh != raceveh) {
                SendClientMessageEx(playerid, -1, "tried to be put back in vehicle");
                PutPlayerInVehicleEx(playerid, raceveh, 0);
            }
        }
    }

    // Show "get back in your vehicle" message
    if (newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER) {
        if (!Race:PlayerData[playerid][Race:PDataExitVehTimer]) {
            new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
            if (!raceid) return 1;

            raceid -= 2;
            if (Race:Data[raceid][Race:Started] != 2) return 1;

            new veh = Race:PlayerData[playerid][Race:PDataCurrentVehID];
            if (!veh) return 1;

            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health <= 0) return 1;

            // Lock vehicle for everyone but the player
            SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
            SetVehicleParamsForPlayer(veh, playerid, false, false);
            if (Race:PlayerData[playerid][Race:PDataIsFinished]) return 1;

            PlayerTextDrawHide(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);
            Race:PlayerData[playerid][Race:PDataExitVehTimer] = VEHICLE_LEAVE_TIME + 1;
            CallRemoteFunction("ExitVehTimer", "i", playerid);
        }

    }
    return 1;
}

forward ExitVehTimer(playerid);
public ExitVehTimer(playerid) {
    Race:RemoveText(playerid);
    if (!IsPlayerConnected(playerid)) return 0;

    new veh = Race:PlayerData[playerid][Race:PDataCurrentVehID];
    if (!IsPlayerInVehicle(playerid, veh) && GetPlayerVehicleSeat(playerid) != 0) {
        new time = Race:PlayerData[playerid][Race:PDataExitVehTimer] - 1;
        if (time == 0) {
            SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You have been disqualified for leaving your vehicle.");
            Race:RemoveFromRace(playerid);
        } else {
            new str[128];
            if (time == 1) format(str, sizeof(str), "~s~You have %i second to return to your ~y~vehicle ~s~before you are disqualified.", time);
            else format(str, sizeof(str), "~s~You have %i seconds to return to your ~y~vehicle ~s~before you are disqualified.", time);

            new PlayerText:textitem = Race:PlayerData[playerid][Race:PDataSubTextID];
            textitem = CreatePlayerTextDraw(playerid, 380.0, 350.0, str);
            PlayerTextDrawLetterSize(playerid, textitem, 0.5, 2.0);
            PlayerTextDrawAlignment(playerid, textitem, 2);
            PlayerTextDrawTextSize(playerid, textitem, 300.0, 450.0);
            PlayerTextDrawShow(playerid, textitem);
            Race:PlayerData[playerid][Race:PDataSubTextID] = textitem;
            Race:PlayerData[playerid][Race:PDataExitVehTimer] = time;
            SetPreciseTimer("ExitVehTimer", 800, false, "i", playerid);
            return 1;
        }
    } else {
        PlayerTextDrawShow(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);
    }
    Race:PlayerData[playerid][Race:PDataExitVehTimer] = 0;
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
    // Check if vehicle was a race vehicle
    foreach(new playerid:Player) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (raceid) {
            raceid -= 2;
            if (Race:Data[raceid][Race:Host] != INVALID_PLAYER_ID) {
                if (Race:PlayerData[playerid][Race:PDataCurrentVehID] == vehicleid) {
                    new Float:health;
                    GetPlayerHealth(playerid, health);
                    if (health > 0) Race:Respawn(playerid, raceid);
                    break;
                }
            }
        }
    }
    return 1;
}

hook OnPlayerClickTextDrawEx(playerid, Text:clickedid) {
    new raceid = Race:PlayerData[playerid][Race:PDataJoinMenuOpen];
    if (!raceid) return 1;
    raceid -= 2;
    // If player clicked ESC (allows other filterscripts to register this action too)
    if (clickedid == Text:INVALID_TEXT_DRAW) {
        return Race:HideJoinMenu(playerid);
    }

    // If player clicked "Close"
    if (clickedid == Text:Race:joinMenuButtons[2]) {
        Race:HideJoinMenu(playerid);
        return Race:MainMenu(playerid);
    }

    // If one of the slots has already been selected previously:
    if (raceid != -1) {
        // If player clicked "Create"
        if (clickedid == Text:Race:joinMenuButtons[0] && Race:Data[raceid][Race:Host] == INVALID_PLAYER_ID) {
            CancelSelectTextDraw(playerid);
            Race:CreateRace(playerid, raceid);
            return 1;
        }

        // If player clicked "Join"
        if (clickedid == Text:Race:joinMenuButtons[1] && Race:Data[raceid][Race:Host] != INVALID_PLAYER_ID) {
            CancelSelectTextDraw(playerid);
            Race:PutPlayerInRace(playerid, raceid);
            return 1;
        }

        // Unselect last button (remove their red selected color)
        if (clickedid != Race:joinMenuSlots[raceid]) {
            if (Race:Data[raceid][Race:Started] == 2) {
                TextDrawColor(Race:joinMenuSlots[raceid], COL_MENU_STARTED);
            } else {
                TextDrawColor(Race:joinMenuSlots[raceid], COL_MENU_REGULAR);
            }
            TextDrawShowForPlayer(playerid, Race:joinMenuSlots[raceid]);

            for (new t; t < sizeof(Race:joinMenuRaceInfo[]); t++) {
                TextDrawHideForPlayer(playerid, Race:joinMenuRaceInfo[raceid][t]);
            }

            for (new c; c < MAX_TEXTDRAW_ICONS; c++) {
                if (Race:MapIcons[raceid][c] != Text:INVALID_TEXT_DRAW) {
                    TextDrawHideForPlayer(playerid, Race:MapIcons[raceid][c]);
                }
            }
        }
    }

    // If player clicked the private race slot (while not in a private race)
    if (Race:PlayerData[playerid][Race:PDataCurrentRaceID] - 2 < MAX_PUBLIC_RACES) {
        if (clickedid == Race:joinMenuPrivate) {
            Race:PlayerData[playerid][Race:PDataJoinMenuOpen] = MAX_PUBLIC_RACES + 2;
            TextDrawColor(Race:joinMenuPrivate, COL_MENU_SELECTED);
            TextDrawShowForPlayer(playerid, Race:joinMenuPrivate);

            TextDrawShowForPlayer(playerid, Race:joinMenuButtons[0]);
            TextDrawHideForPlayer(playerid, Race:joinMenuButtons[1]);
            TextDrawShowForPlayer(playerid, Race:joinMenuExtra[3]);
        } else if (raceid == MAX_PUBLIC_RACES) // Deselect it
        {
            TextDrawColor(Race:joinMenuPrivate, COL_MENU_REGULAR);
            TextDrawShowForPlayer(playerid, Race:joinMenuPrivate);
        }
    }

    // If clicked one of the public race slot
    for (new i; i < MAX_RACES; i++) {
        if (clickedid == Race:joinMenuSlots[i] && raceid != i) {
            Race:PlayerData[playerid][Race:PDataJoinMenuOpen] = i + 2;
            TextDrawColor(Race:joinMenuSlots[i], COL_MENU_SELECTED);
            TextDrawShowForPlayer(playerid, Race:joinMenuSlots[i]);

            // Show "Create" if there is no race
            if (Race:Data[i][Race:Host] == INVALID_PLAYER_ID) {
                TextDrawShowForPlayer(playerid, Race:joinMenuButtons[0]);
                TextDrawHideForPlayer(playerid, Race:joinMenuButtons[1]);
                TextDrawShowForPlayer(playerid, Race:joinMenuExtra[3]);
            } else // Show "Join" if there is a race
            {
                TextDrawHideForPlayer(playerid, Race:joinMenuButtons[0]);
                TextDrawShowForPlayer(playerid, Race:joinMenuButtons[1]);

                // Show all the Race Info TD's
                new bool:showdesc = true;
                for (new t; t < sizeof(Race:joinMenuRaceInfo[]); t++) {
                    if (Race:joinMenuRaceInfo[i][t] != Text:INVALID_TEXT_DRAW) {
                        TextDrawShowForPlayer(playerid, Race:joinMenuRaceInfo[i][t]);
                        showdesc = false;
                    }
                }

                // Show default description if there is no race
                if (showdesc) {
                    TextDrawShowForPlayer(playerid, Race:joinMenuExtra[3]);
                } else // Show map icons if there is a race
                {
                    TextDrawHideForPlayer(playerid, Race:joinMenuExtra[3]);
                    for (new c; c < MAX_TEXTDRAW_ICONS; c++) {
                        if (Race:MapIcons[i][c] != Text:INVALID_TEXT_DRAW) {
                            TextDrawShowForPlayer(playerid, Race:MapIcons[i][c]);
                        }
                    }
                }
            }
            return 1;
        }
    }
    return 1;
}

stock Float:Race:GetAngleToPos(Float:PX, Float:PY, Float:X, Float:Y) {
    new Float:Angle = floatabs(atan((Y - PY) / (X - PX)));
    Angle = (X <= PX && Y >= PY) ? floatsub(180.0, Angle) : (X < PX && Y < PY) ? floatadd(Angle, 180.0) : (X >= PX && Y <= PY) ? floatsub(360.0, Angle) : Angle;
    Angle = floatsub(Angle, 90.0);
    Angle = (Angle >= 360.0) ? floatsub(Angle, 360.0) : Angle;
    Angle = (Angle <= 0.0) ? floatadd(Angle, 360.0) : Angle;
    return Angle;
}

stock Race:HideJoinMenu(playerid) {
    CancelSelectTextDraw(playerid);
    Race:PlayerData[playerid][Race:PDataJoinMenuOpen] = 0;
    for (new b; b < sizeof(Race:joinMenuButtons); b++) {
        TextDrawHideForPlayer(playerid, Race:joinMenuButtons[b]);
    }
    for (new e; e < sizeof(Race:joinMenuExtra); e++) {
        TextDrawHideForPlayer(playerid, Race:joinMenuExtra[e]);
    }

    TextDrawHideForPlayer(playerid, Race:joinMenuPrivate);
    for (new s; s < MAX_RACES; s++) {
        if (Race:joinMenuSlots[s] != Text:INVALID_TEXT_DRAW) {
            TextDrawHideForPlayer(playerid, Race:joinMenuSlots[s]);
        }

        for (new i; i < MAX_TEXTDRAW_ICONS; i++) {
            if (Race:MapIcons[s][i] != Text:INVALID_TEXT_DRAW) {
                TextDrawHideForPlayer(playerid, Race:MapIcons[s][i]);
            }
        }
        for (new v; v < sizeof(Race:joinMenuRaceInfo[]); v++) {
            if (Race:joinMenuRaceInfo[s][v] != Text:INVALID_TEXT_DRAW) {
                TextDrawHideForPlayer(playerid, Race:joinMenuRaceInfo[s][v]);
            }
        }
    }

    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (raceid) {
        raceid -= 2;
        if (Race:Data[raceid][Race:Started] == 2) {
            if (Race:PlayerData[playerid][Race:PDataCurrentCPID] - 1 < Race:Data[raceid][Race:CPAmount]) {
                PlayerTextDrawShow(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);
            }
        } else {
            if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
                TextDrawShowForPlayer(playerid, Race:joinMenuRaceInfo[raceid][2]);
            }
        }
    }
    return 1;
}

stock Race:CreateRace(playerid, raceid) {
    for (new r; r < MAX_RACES; r++) {
        if (Race:Data[r][Race:Host] == playerid) {
            return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have already started a race!");
        }
    }

    new oldrace = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (oldrace) {
        return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in a race! Use 'pocket > race system > leave' to leave that race.");
    }

    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[2], pos[1]);
    new MapNode:closestNode;
    GetClosestMapNodeToPoint(pos[0], pos[2], pos[1], closestNode);
    if (closestNode == MapNode:INVALID_MAP_NODE_ID) {
        return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You need to move closer to a road!");
    }
    Race:PlayerData[playerid][Race:PDataClosestNode] = _:closestNode;
    Race:PlayerData[playerid][Race:PDataCurrentRaceID] = raceid + 2;
    Race:MenuCreateNew(playerid);
    return 1;
}

stock Race:MenuCreateNew(playerid, customModel = 0) {
    if (ALLOW_ALL_VEHICLES || customModel) {
        FlexPlayerDialog(playerid, "RaceMenuVehicleModal", DIALOG_STYLE_INPUT, "Vehicle Model", "Enter vehicle modelid for race", "Select", "Close", customModel);
    } else {
        new string[2000];
        strcat(string, "#\tName\n");
        for (new i; i < sizeof RaceVehicleList; i++) { strcat(string, sprintf("%d\t%s\n", RaceVehicleList[i], GetVehicleModelName(RaceVehicleList[i]))); }
        if (GetPlayerVIPLevel(playerid) > 0) strcat(string, "Custom\tModel\n");
        FlexPlayerDialog(playerid, "RaceMenuVehicleModal", DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Model", string, "Select", "Close", customModel);
    }
    return 1;
}

FlexDialog:RaceMenuVehicleModal(playerid, response, listitem, const inputtext[], customModel, const payload[]) {
    if (!response) {
        Race:PlayerData[playerid][Race:PDataClosestNode] = 0;
        Race:PlayerData[playerid][Race:PDataCurrentRaceID] = 0;
        TogglePlayerControllable(playerid, true);
        Race:ShowJoinMenu(playerid);
        return 1;
    }
    if (IsStringSame(inputtext, "Custom")) return Race:MenuCreateNew(playerid, 1);
    new modelid;
    if (sscanf(inputtext, "d", modelid) || modelid < 400 || modelid > 611) return Race:MenuCreateNew(playerid, customModel);
    return Race:MenuCreateLength(playerid, modelid);
}

stock Race:MenuCreateLength(playerid, modelid) {
    Race:PlayerData[playerid][Race:PDataSelectedVehicle] = modelid;
    return FlexPlayerDialog(
        playerid, "RaceMenuCreateLength", DIALOG_STYLE_INPUT, "Maximum length",
        "Please input the maximum length of the race in meters.\nLimit: 150 to 30,000 meters", "Start", "Cancel", modelid
    );
}

FlexDialog:RaceMenuCreateLength(playerid, response, listitem, const inputtext[], modelid, const payload[]) {
    if (!response) return Race:MenuCreateNew(playerid);

    // Retrieve closest node ID
    new closestNode = Race:PlayerData[playerid][Race:PDataClosestNode];
    if (closestNode == -1) {
        SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 001) The race has been reset.");
        Race:PlayerData[playerid][Race:PDataCurrentRaceID] = 0;
        Race:PlayerData[playerid][Race:PDataSelectedVehicle] = 0;
        return 1;
    }

    new raceLength;
    if (sscanf(inputtext, "d", raceLength) || raceLength < MIN_RACE_DISTANCE || raceLength > MAX_RACE_DISTANCE) return Race:MenuCreateLength(playerid, modelid);
    Race:PlayerData[playerid][Race:PDataClosestNode] = 0;

    // Check if slot got filled in the mean time
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (!raceid) {
        // Error if slot ID does not exist
        SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 003) The race has been reset.");
        Race:PlayerData[playerid][Race:PDataCurrentRaceID] = 0;
        Race:PlayerData[playerid][Race:PDataSelectedVehicle] = 0;
        return 1;
    }

    // create race
    raceid -= 2;
    if (Race:Data[raceid][Race:Host] != INVALID_PLAYER_ID) {
        // Check if private race
        new minr = MAX_PUBLIC_RACES, maxr = MAX_RACES, bool:privaterace = true;
        if (0 <= raceid < MAX_PUBLIC_RACES) {
            minr = 0;
            maxr = MAX_PUBLIC_RACES;
            privaterace = false;
        }

        // Get first empty slot
        new freeRace = -1;
        for (new r = minr; r < maxr; r++) {
            if (Race:Data[r][Race:Host] == INVALID_PLAYER_ID) {
                freeRace = r;
                break;
            }
        }

        // If no empty slot left, cancel race creation.. :(
        if (freeRace == -1) {
            if (privaterace) {
                SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: It's not possible to create more private races at the moment!");
            } else {
                SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: It's not possible to create more public races at the moment!");
            }
            Race:PlayerData[playerid][Race:PDataCurrentRaceID] = 0;
            Race:PlayerData[playerid][Race:PDataSelectedVehicle] = 0;
            return 1;
        }

        // If another slot is empty; save new slot ID
        raceid = freeRace;
        Race:PlayerData[playerid][Race:PDataCurrentRaceID] = raceid + 2;
    }

    // Save race info and start calculating
    Race:PlayerData[playerid][Race:PDataTotalRaceDistance] = float(raceLength);

    Race:Data[raceid][Race:Host] = playerid;
    Race:calculateNextRacePart(raceid, 0, MapNode:closestNode, true);
    return 1;
}

stock Race:calculateNextRacePart(slot, curCPSlot, MapNode:lastNode, bool:firstcalculation = false) {
    new Float:newpos[2];
    if (firstcalculation) {
        newpos[0] = float((random(6000) - 3000));
        newpos[1] = float((random(6000) - 3000));

        new Float:nodepos[3], Float:testpos[2];
        GetMapNodePos(MapNode:lastNode, nodepos[0], nodepos[1], nodepos[2]);

        // If the position is too close to the startpoint:try again (up to 10 times, to prevent freeze if all nodes are too close)
        for (new s; s != 10; s++) {
            testpos[0] = newpos[0] - nodepos[0];
            testpos[1] = newpos[1] - nodepos[1];

            if ((testpos[0] * testpos[0]) + (testpos[1] * testpos[1]) < (MIN_RACE_DISTANCE * MIN_RACE_DISTANCE)) {
                newpos[0] = float((random(6000) - 3000));
                newpos[1] = float((random(6000) - 3000));
            } else {
                break;
            }
        }
    } else {
        if (curCPSlot < 2) {
            SendClientMessageEx(Race:Data[slot][Race:Host], COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 007)  The race has been reset.");
            Race:PlayerData[Race:Data[slot][Race:Host]][Race:PDataSelectedVehicle] = 0;
            Race:PlayerData[Race:Data[slot][Race:Host]][Race:PDataTotalRaceDistance] = 0;
            Race:Clear(slot);
            return 1;
        }

        // Pick new position for the route calculator:
        newpos[0] = Race:CheckpointList[slot][curCPSlot - 2][0];
        newpos[1] = Race:CheckpointList[slot][curCPSlot - 2][1];

        new Float:angle = Race:GetAngleToPos(newpos[0], newpos[1], Race:CheckpointList[slot][curCPSlot - 1][0], Race:CheckpointList[slot][curCPSlot - 1][1]);
        angle += float(random(50) - 25);

        new Float:dist = 1000 + float(random(2000));
        newpos[0] += (dist * floatsin(-angle, degrees));
        newpos[1] += (dist * floatcos(-angle, degrees));

        // Get the new position between the world boundries:
        newpos[0] = (newpos[0] > 3000.0) ? float(3000 - random(500)) : (newpos[0] < -3000.0) ? float(-3000 + random(500)) : newpos[0];
        newpos[1] = (newpos[1] > 3000.0) ? float(3000 - random(500)) : (newpos[1] < -3000.0) ? float(-3000 + random(500)) : newpos[1];
    }

    new MapNode:newNode;
    GetClosestMapNodeToPoint(newpos[0], newpos[1], 25.0, newNode, lastNode);
    if (newNode == MapNode:INVALID_MAP_NODE_ID) {
        SendClientMessageEx(Race:Data[slot][Race:Host], COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 002)  The race has been reset.");
        Race:PlayerData[Race:Data[slot][Race:Host]][Race:PDataSelectedVehicle] = 0;
        Race:PlayerData[Race:Data[slot][Race:Host]][Race:PDataTotalRaceDistance] = 0;
        Race:Clear(slot);
        return 1;
    }
    FindPathThreaded(MapNode:lastNode, MapNode:newNode, "OnRacePathCalculated", "i", slot);
    return 1;
}

forward OnRacePathCalculated(Path:pathid, slot);
public OnRacePathCalculated(Path:pathid, slot) {
    new amount_of_nodes, Float:distance, MapNode:nodeid;
    GetPathSize(Path:pathid, amount_of_nodes);
    GetPathLength(Path:pathid, distance);
    if (0 <= slot < MAX_RACES && Race:Data[slot][Race:Host] != INVALID_PLAYER_ID) {
        new playerid = Race:Data[slot][Race:Host];
        // In case of invalid info, error
        if (!amount_of_nodes || distance == -1) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation. (Reference ID: 004) The race has been reset.");
            return Race:Clear(slot);
        }

        new lastIntersection, Float:distIntersection, curCPSlot = Race:GetFirstEmptyCPSlot(slot),
            Float:maxDistance = Race:PlayerData[playerid][Race:PDataTotalRaceDistance], i = 1,
            MapNode:lastNode, bool:cps_added;

        // Set start position nodes
        if (curCPSlot == 0) {
            GetPathNode(pathid, 0, nodeid);
            GetMapNodePos(nodeid, Race:CheckpointList[slot][0][0], Race:CheckpointList[slot][0][1], Race:CheckpointList[slot][0][2]);
            GetPathNode(pathid, 1, nodeid);
            GetMapNodePos(nodeid, Race:CheckpointList[slot][1][0], Race:CheckpointList[slot][1][1], Race:CheckpointList[slot][1][2]);

            curCPSlot = 2;
        }

        // Loop through all nodes
        for (; i < amount_of_nodes; i++) {
            // Add up distance since last intersection
            new MapNode:nodeid_1, MapNode:nodeid_2, Float:node_distance;
            GetPathNode(Path:pathid, i - 1, nodeid_1);
            GetPathNode(Path:pathid, i, nodeid_2);
            GetDistanceBetweenMapNodes(nodeid_1, nodeid_2, node_distance);
            distIntersection += node_distance;

            if (distIntersection > MINIMAL_DISTANCE_CP * 0.333) {
                cps_added = true;
                new Float:averageDist = distIntersection / float(floatround(distIntersection / MINIMAL_DISTANCE_CP, floatround_floor)), Float:curDist, Float:cpDist, bool:limitreached;

                // Re-read all nodes between last and current intersections and add checkpoints in between if necessary
                for (new n = lastIntersection + 1; n < i; n++) {
                    new MapNode:n_nodeid_1, MapNode:n_nodeid_2, Float:n_node_distance;
                    GetPathNode(Path:pathid, i - 1, n_nodeid_1);
                    GetPathNode(Path:pathid, i, n_nodeid_2);
                    GetDistanceBetweenMapNodes(n_nodeid_1, n_nodeid_2, n_node_distance);
                    cpDist += n_node_distance;

                    // Check distance between last and current checkpoint. (if greater than average distance, add new checkpoint)
                    if (cpDist >= averageDist) {
                        GetPathNode(pathid, n, nodeid);
                        GetMapNodePos(nodeid, Race:CheckpointList[slot][curCPSlot][0], Race:CheckpointList[slot][curCPSlot][1], Race:CheckpointList[slot][curCPSlot][2]);

                        curDist += cpDist; // Add checkpoint distance to total distance between current and last intersection.
                        cpDist = 0.0;
                        curCPSlot++;
                        lastNode = nodeid_2;

                        if (curCPSlot >= MAX_CHECKPOINTS + 2 || Race:Data[slot][Race:Distance] + curDist >= maxDistance) // Checkpoint or distance limit reached
                        {
                            Race:Data[slot][Race:Distance] += curDist;
                            limitreached = true;
                            break;
                        }
                    }
                }

                // Add current intersection
                if (limitreached == false) {
                    Race:Data[slot][Race:Distance] += curDist + cpDist;
                    GetPathNode(pathid, i, nodeid);
                    GetMapNodePos(nodeid, Race:CheckpointList[slot][curCPSlot][0], Race:CheckpointList[slot][curCPSlot][1], Race:CheckpointList[slot][curCPSlot][2]);

                    curCPSlot++;
                    lastNode = nodeid_2;

                    lastIntersection = i;
                    distIntersection = 0.0;
                }

                // End the race creation, add the finishing touch
                if (limitreached == true || curCPSlot >= MAX_CHECKPOINTS + 2 || Race:Data[slot][Race:Distance] >= maxDistance) {
                    // Set the name of the race
                    new str[48], pName[MAX_PLAYER_NAME], len;
                    len = GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
                    switch (pName[len - 1]) {
                        case 's', 'z', 'S', 'Z':
                            format(str, sizeof(str), "%s' race (%.1fm)", pName, Race:Data[slot][Race:Distance]);
                        default:
                            format(str, sizeof(str), "%s's race (%.1fm)", pName, Race:Data[slot][Race:Distance]);
                    }

                    // If private race, create new hidden textdraw if necessary
                    if (slot >= MAX_PUBLIC_RACES) {
                        if (Race:joinMenuSlots[slot] == Text:INVALID_TEXT_DRAW) {
                            Race:joinMenuSlots[slot] = TextDrawCreate(MENU_X + 10.0, MENU_Y + 19.0 + float(MAX_PUBLIC_RACES * 15), str);
                            TextDrawColor(Race:joinMenuSlots[slot], COL_MENU_REGULAR);
                            TextDrawLetterSize(Race:joinMenuSlots[slot], 0.25, 1.2);
                            TextDrawSetOutline(Race:joinMenuSlots[slot], 1);
                            TextDrawTextSize(Race:joinMenuSlots[slot], MENU_X + 155.0, 12.0);
                            TextDrawSetSelectable(Race:joinMenuSlots[slot], true);
                        }
                        Race:AmountOfPrivateRaces++;
                        format(str, sizeof(str), "<%i/%d> Create private race!", Race:AmountOfPrivateRaces, MAX_PRIVATE_RACES);
                        TextDrawSetString(Race:joinMenuPrivate, str);
                    } else {
                        TextDrawSetString(Race:joinMenuSlots[slot], str);
                    }

                    // Spawn all textdraw checkpoint icons on the race map
                    new interval = (curCPSlot >= MAX_TEXTDRAW_ICONS) ? floatround(float(curCPSlot - 1) / float(MAX_TEXTDRAW_ICONS), floatround_ceil) : 1;

                    for (new c = 1, cp = 2; cp < curCPSlot && cp <= MAX_CHECKPOINTS + 2 && c < MAX_TEXTDRAW_ICONS - 2; cp += interval) {
                        if ((!Race:CheckpointList[slot][cp][0] && !Race:CheckpointList[slot][cp][1])) continue;

                        Race:MapIcons[slot][c] = TextDrawCreate(MENU_X + 148.0 + ((Race:CheckpointList[slot][cp][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 257.0 - ((Race:CheckpointList[slot][cp][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_light");
                        TextDrawFont(Race:MapIcons[slot][c], 4);
                        TextDrawTextSize(Race:MapIcons[slot][c], 6.0, 6.0);
                        c++;
                    }

                    // Spawn start and finish icon
                    Race:MapIcons[slot][0] = TextDrawCreate(MENU_X + 148.0 + ((Race:CheckpointList[slot][0][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 255.0 - ((Race:CheckpointList[slot][0][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_impound");
                    Race:MapIcons[slot][MAX_TEXTDRAW_ICONS - 1] = TextDrawCreate(MENU_X + 148.0 + ((Race:CheckpointList[slot][curCPSlot - 1][0] + 3000.0) / 6000.0) * 250.0, MENU_Y + 255.0 - ((Race:CheckpointList[slot][curCPSlot - 1][1] + 3000.0) / 6000.0) * 250.0, "hud:radar_Flag");
                    TextDrawFont(Race:MapIcons[slot][0], 4);
                    TextDrawTextSize(Race:MapIcons[slot][0], 10.0, 10.0);
                    TextDrawFont(Race:MapIcons[slot][MAX_TEXTDRAW_ICONS - 1], 4);
                    TextDrawTextSize(Race:MapIcons[slot][MAX_TEXTDRAW_ICONS - 1], 10.0, 10.0);

                    // Set vehicle model to the textdraw race info
                    Race:Data[slot][Race:VehicleModel] = Race:PlayerData[playerid][Race:PDataSelectedVehicle];
                    Race:PlayerData[playerid][Race:PDataSelectedVehicle] = 0;

                    Race:joinMenuRaceInfo[slot][0] = TextDrawCreate(MENU_X + 390.0, MENU_Y - 5.0, "_"); // Vehicle model
                    TextDrawFont(Race:joinMenuRaceInfo[slot][0], TEXT_DRAW_FONT_MODEL_PREVIEW);
                    TextDrawUseBox(Race:joinMenuRaceInfo[slot][0], 1);
                    TextDrawBackgroundColor(Race:joinMenuRaceInfo[slot][0], 0);
                    TextDrawTextSize(Race:joinMenuRaceInfo[slot][0], 170.0, 130.0);
                    TextDrawSetOutline(Race:joinMenuRaceInfo[slot][0], 2);
                    TextDrawSetPreviewModel(Race:joinMenuRaceInfo[slot][0], Race:Data[slot][Race:VehicleModel]);
                    TextDrawSetPreviewVehCol(Race:joinMenuRaceInfo[slot][0], RACE_VEHICLE_COL1, RACE_VEHICLE_COL2);
                    TextDrawSetPreviewRot(Race:joinMenuRaceInfo[slot][0], 345.0, 0.0, 325.0, 1.0);

                    // Update rest of text to the textdraw race ifno
                    new text[145];
                    Race:Data[slot][Race:CPAmount] = curCPSlot - 2;
                    format(text, sizeof(text), "~r~Vehicle: ~w~%s~n~~r~Length: ~w~%.1f meters~n~~r~Checkpoints: ~w~%i~n~~r~Host: ~w~%s", GetVehicleModelName(Race:Data[slot][Race:VehicleModel]), Race:Data[slot][Race:Distance], Race:Data[slot][Race:CPAmount], pName);

                    Race:joinMenuRaceInfo[slot][1] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 95.0, text);
                    TextDrawColor(Race:joinMenuRaceInfo[slot][1], COL_MENU_REGULAR);
                    TextDrawLetterSize(Race:joinMenuRaceInfo[slot][1], 0.25, 1.2);
                    TextDrawSetOutline(Race:joinMenuRaceInfo[slot][1], 1);

                    // Spawn the host in the race and update contestants
                    Race:SpawnInRace(Race:Data[slot][Race:Host], slot, 0);
                    Race:Data[slot][Race:PlayerAmount] = 1;
                    Race:UpdateContestantList(slot);

                    if (Race:joinMenuRaceInfo[slot][2] != Text:INVALID_TEXT_DRAW) {
                        TextDrawShowForPlayer(playerid, Race:joinMenuRaceInfo[slot][2]);
                    }

                    Race:PlayerData[playerid][Race:PDataTotalRaceDistance] = 0;

                    // If race is private race, send different message
                    if (slot >= MAX_PUBLIC_RACES) {
                        format(text, sizeof(text), " [!] NOTE: {FFFFFF}You have started a private race with a length of %.1f meters! Use '{FF6262}pocket > race system > invite [name]{FFFFFF}' to invite people.", Race:Data[slot][Race:Distance]);
                        SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, text);
                    } else {
                        format(text, sizeof(text), " [!] NOTE: {FFFFFF}%s has started a new race with a length of %.1f meters! Use '{FF6262}pocket > race system > menu{FFFFFF}' to join this race.", pName, Race:Data[slot][Race:Distance]);
                        SendClientMessageToAll(COL_TEXT_IMPORTANT, text);
                    }
                    SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You can use '{FF6262}pocket > race system > start{FFFFFF}' to start the countdown or '{FF6262}pocket > race system > leave{FFFFFF}' to call the race off.");
                    GameTextForPlayer(playerid, "~r~100%", 250, 4);
                    Race:MainMenu(playerid);
                    return 1;
                }
            }
        }
        DestroyPath(Path:pathid);
        new text[8];
        format(text, sizeof(text), "~w~%i%%", floatround(100.0 * Race:Data[slot][Race:Distance] / maxDistance));
        GameTextForPlayer(playerid, text, 5000, 4);

        if (!cps_added || !lastNode) // Ugly fix :(
        {
            GetClosestMapNodeToPoint(Race:CheckpointList[slot][curCPSlot - 1][0], Race:CheckpointList[slot][curCPSlot - 1][1], 25.0, nodeid);
            Race:calculateNextRacePart(slot, curCPSlot, nodeid);
        } else {
            Race:calculateNextRacePart(slot, curCPSlot, lastNode);
        }
    }
    return 1;
}

stock Race:UpdateContestantList(raceid) {
    new list[255], amount, curlen = 32, bool:stopadding = false;
    for (new s; s < MAX_CONTESTANTS; s++) {
        if (Race:PeopleInRace[raceid][s][0] != INVALID_PLAYER_ID) {
            new pName[MAX_PLAYER_NAME];
            curlen += GetPlayerName(Race:PeopleInRace[raceid][s][0], pName, MAX_PLAYER_NAME);

            if (curlen < sizeof(list) - 16) {
                strcat(list, "~n~ - ");
                strcat(list, pName);
            } else if (stopadding == false) {
                stopadding = true;
                strcat(list, "~n~ - and more!");
            }
            amount++;
        }
    }
    format(list, sizeof(list), "~r~Contestants (%i of %d):~w~%s", amount, MAX_CONTESTANTS, list);
    if (Race:joinMenuRaceInfo[raceid][2] == Text:INVALID_TEXT_DRAW) {
        Race:joinMenuRaceInfo[raceid][2] = TextDrawCreate(MENU_X + 410.0, MENU_Y + 100.0, list);
        TextDrawColor(Race:joinMenuRaceInfo[raceid][2], COL_MENU_REGULAR);
        TextDrawLetterSize(Race:joinMenuRaceInfo[raceid][2], 0.25, 1.2);
        TextDrawSetOutline(Race:joinMenuRaceInfo[raceid][2], 1);
    } else {
        TextDrawSetString(Race:joinMenuRaceInfo[raceid][2], list);
    }
    return 1;
}

stock Race:GetFirstEmptyCPSlot(raceid) {
    if (0 <= raceid < MAX_RACES && Race:Data[raceid][Race:Host] != INVALID_PLAYER_ID) {
        for (new c; c < MAX_CHECKPOINTS + 2; c++) {
            if (Race:CheckpointList[raceid][c][0] || Race:CheckpointList[raceid][c][1] || Race:CheckpointList[raceid][c][2]) continue;
            return c;
        }
    }
    return MAX_CHECKPOINTS + 2;
}

stock Race:PutPlayerInRace(playerid, raceid) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (!(0 <= raceid < MAX_RACES) || Race:Data[raceid][Race:Host] == INVALID_PLAYER_ID) return 0;

    for (new r; r < MAX_RACES; r++) {
        if (Race:Data[r][Race:Host] == playerid) {
            if (r == raceid) {
                return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in this race!");
            } else {
                return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have already started another race! You cannot join this one.");
            }
        }
    }

    new oldrace = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (oldrace) {
        if (oldrace - 2 == raceid) {
            return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in this race!");
        } else {
            return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are already in another race! Use 'pocket > race system > leave' to leave that race.");
        }
    }

    if (Race:Data[raceid][Race:Started] == 2) {
        return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: This race has already started! You cannot join anymore.");
    }

    new currentcontestants = 0;
    foreach(new p:Player) {
        new pRace = Race:PlayerData[p][Race:PDataCurrentRaceID];
        if (pRace && pRace - 2 == raceid) currentcontestants++;
    }

    Race:Data[raceid][Race:PlayerAmount] = currentcontestants;
    if (currentcontestants >= MAX_CONTESTANTS) {
        SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You cannot join this race anymore! There's no room.");
        return 0;
    }

    Race:Data[raceid][Race:PlayerAmount]++;
    Race:PlayerData[playerid][Race:PDataCurrentRaceID] = raceid + 2;
    Race:SpawnInRace(playerid, raceid, currentcontestants);
    Race:UpdateContestantList(raceid);

    if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
        TextDrawShowForPlayer(playerid, Race:joinMenuRaceInfo[raceid][2]);
    }

    SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You can use '{FF6262}pocket > race system > leave{FFFFFF}' to leave this race.");
    return 1;
}

stock Race:RemoveText(playerid) {
    new PlayerText:textitem = PlayerText:Race:PlayerData[playerid][Race:PDataSubTextID];
    if (PlayerText:textitem != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawHide(playerid, textitem);
        PlayerTextDrawDestroy(playerid, textitem);
        Race:PlayerData[playerid][Race:PDataSubTextID] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock Race:RemoveFromRace(playerid, bool:oldspawn = false) {
    if (!IsPlayerConnected(playerid)) return 0;
    Race:RemoveText(playerid);
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (!raceid) {
        return 0;
    }
    raceid -= 2;

    new spot = Race:PlayerData[playerid][Race:PDataStartSpotI];
    if (Race:PeopleInRace[raceid][spot][0] == playerid) {
        Race:PeopleInRace[raceid][spot][0] = INVALID_PLAYER_ID;
        Race:PeopleInRace[raceid][spot][1] = 0;
    }

    new veh = Race:PlayerData[playerid][Race:PDataCurrentVehID];
    DestroyVehicle(veh);
    Race:PlayerData[playerid][Race:PDataCurrentVehID] = 0;
    DisablePlayerRaceCheckpoint(playerid);
    Race:PlayerData[playerid][Race:PDataCurrentCPID] = 0;
    new timer = Race:PlayerData[playerid][Race:PDatarespawnTimer];
    if (timer) {
        DeletePreciseTimer(timer);
    }
    Race:PlayerData[playerid][Race:PDatarespawnTimer] = 0;

    if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
        TextDrawHideForPlayer(playerid, Race:joinMenuRaceInfo[raceid][2]);
    }

    PlayerTextDrawHide(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);

    for (new ci, icon = SUGGESTED_MAPICONS_OFFSET; ci < MAX_SUGGESTED_MAPICONS; ci++, icon++) {
        RemovePlayerMapIcon(playerid, icon);
    }

    if (oldspawn == true) {
        new Float:oldpos[4], oldint, oldvw;
        oldpos[0] = Race:PlayerData[playerid][Race:PDataOldX];
        oldpos[1] = Race:PlayerData[playerid][Race:PDataOldY];
        oldpos[2] = Race:PlayerData[playerid][Race:PDataOldZ];
        oldpos[3] = Race:PlayerData[playerid][Race:PDataOldR];
        oldint = Race:PlayerData[playerid][Race:PDataOldInt];
        oldvw = Race:PlayerData[playerid][Race:PDataOldVW];
        SetPlayerPosEx(playerid, oldpos[0], oldpos[1], oldpos[2]);
        SetPlayerFacingAngle(playerid, oldpos[3]);
        SetPlayerInteriorEx(playerid, oldint);
        SetPlayerVirtualWorldEx(playerid, oldvw);
    }
    Race:PlayerData[playerid][Race:PDataOldX] = 0;
    Race:PlayerData[playerid][Race:PDataOldY] = 0;
    Race:PlayerData[playerid][Race:PDataOldZ] = 0;
    Race:PlayerData[playerid][Race:PDataOldR] = 0;
    Race:PlayerData[playerid][Race:PDataOldInt] = 0;
    Race:PlayerData[playerid][Race:PDataOldVW] = 0;

    // Delete race start position
    Race:PlayerData[playerid][Race:PDataStartSpotX] = 0;
    Race:PlayerData[playerid][Race:PDataStartSpotY] = 0;
    Race:PlayerData[playerid][Race:PDataStartSpotZ] = 0;
    Race:PlayerData[playerid][Race:PDataStartSpotA] = 0;
    Race:PlayerData[playerid][Race:PDataStartSpotI] = 0;

    TogglePlayerControllable(playerid, true);

    new bool:updatelist = true, bool:found_new_host;
    for (new r; r < MAX_RACES; r++) {
        if (Race:Data[r][Race:Host] == playerid) {
            if (Race:Data[r][Race:PlayerAmount] <= 1 && Race:Data[r][Race:FinishedPlayers] != Race:Data[r][Race:PlayerAmount]) // If player is only contestant left; delete race.
            {
                Race:Clear(r, true);

                if (r == raceid) {
                    updatelist = false;
                }
            } else // There is another player in the race; make him host!
            {
                for (new c; c < MAX_CONTESTANTS; c++) {
                    if (Race:PeopleInRace[raceid][c][0] != INVALID_PLAYER_ID && Race:PeopleInRace[raceid][c][0] != playerid) {
                        Race:Data[r][Race:Host] = Race:PeopleInRace[raceid][c][0];

                        new str[128], newhostName[MAX_PLAYER_NAME];
                        GetPlayerName(Race:Data[r][Race:Host], newhostName, MAX_PLAYER_NAME);

                        if (Race:Data[r][Race:PlayerAmount] > 1) // If there are more than 1 person left, send a message to other contestants as well
                        {
                            format(str, sizeof(str), " [!] NOTE: {FFFFFF}%s has become the new host for this race. The old host left.", newhostName);

                            for (new s; s < MAX_CONTESTANTS; s++) {
                                if (Race:PeopleInRace[raceid][s][0] != INVALID_PLAYER_ID && Race:PeopleInRace[raceid][s][0] != Race:Data[r][Race:Host] && Race:PeopleInRace[raceid][s][0] != playerid) {
                                    SendClientMessageEx(Race:PeopleInRace[raceid][s][0], COL_TEXT_IMPORTANT, str);
                                }
                            }
                        }

                        SendClientMessageEx(Race:Data[r][Race:Host], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You have become the new host for this race. The old host left.");
                        format(str, sizeof(str), " [!] NOTE: {FFFFFF}You have left the race. %s has taken your position as host.", newhostName);
                        SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, str);

                        // Update race information box
                        if (Race:joinMenuRaceInfo[r][1] != Text:INVALID_TEXT_DRAW) {
                            new text[145];
                            format(text, sizeof(text), "~r~Vehicle: ~w~%s~n~~r~Length: ~w~%.1f meters~n~~r~Checkpoints: ~w~%i~n~~r~Host: ~w~%s", GetVehicleModelName(Race:Data[r][Race:VehicleModel]), Race:Data[r][Race:Distance], Race:Data[r][Race:CPAmount], newhostName);

                            TextDrawSetString(Race:joinMenuRaceInfo[r][1], text);
                        }

                        found_new_host = true;
                        break;
                    }
                }

                // If still couldn't find any other player, clean race anyway.
                if (!found_new_host) {
                    Race:Clear(r, true);

                    if (r == raceid) {
                        updatelist = false;
                    }
                }
            }

            Race:PlayerData[playerid][Race:PDataTotalRaceDistance] = 0;
        }
    }
    if (!Race:PlayerData[playerid][Race:PDataIsFinished]) {
        Race:Data[raceid][Race:PlayerAmount]--;
    }
    Race:PlayerData[playerid][Race:PDataIsFinished] = 0;

    // Update the contestant list in the race menu.
    if (updatelist == true) {
        Race:UpdateContestantList(raceid);
    }
    Race:PlayerData[playerid][Race:PDataCurrentRaceID] = 0;
    return (found_new_host == true) ? 2 : 1;
}

stock Race:SpawnInRace(playerid, raceid, spot = -1) {
    new Float:spos[3], Float:angle;
    spos[0] = Race:PlayerData[playerid][Race:PDataStartSpotX];
    spos[1] = Race:PlayerData[playerid][Race:PDataStartSpotY];

    if (!spos[0] && !spos[1]) {
        new Float:oldpos[4], oldint, oldvw;
        GetPlayerPos(playerid, oldpos[0], oldpos[1], oldpos[2]);
        GetPlayerFacingAngle(playerid, oldpos[3]);
        oldint = GetPlayerInterior(playerid);
        oldvw = GetPlayerVirtualWorld(playerid);
        Race:PlayerData[playerid][Race:PDataOldX] = oldpos[0];
        Race:PlayerData[playerid][Race:PDataOldY] = oldpos[1];
        Race:PlayerData[playerid][Race:PDataOldZ] = oldpos[2];
        Race:PlayerData[playerid][Race:PDataOldR] = oldpos[3];
        Race:PlayerData[playerid][Race:PDataOldInt] = oldint;
        Race:PlayerData[playerid][Race:PDataOldVW] = oldvw;

        if (spot == -1) {
            for (new s; s < MAX_CONTESTANTS; s++) {
                if (Race:PeopleInRace[raceid][s][0] != INVALID_PLAYER_ID) {
                    spot = s;
                    break;
                }
            }

            if (spot == -1) {
                Race:RemoveFromRace(playerid);
                return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have been removed from the race, because there is no free space left.");
            }
        }

        new Float:size[3], Float:offset[2], Float:temp;
        angle = Race:GetAngleToPos(Race:CheckpointList[raceid][0][0], Race:CheckpointList[raceid][0][1], Race:CheckpointList[raceid][1][0], Race:CheckpointList[raceid][1][1]);
        GetVehicleModelInfo(Race:Data[raceid][Race:VehicleModel], VEHICLE_MODEL_INFO_SIZE, size[0], size[1], size[2]);
        offset[0] = (spot & 1) ? (size[0] * 0.75) :  - (size[0] * 0.75);
        offset[1] = -float((spot / 2) * floatround((size[1] * 1.2), floatround_ceil));

        new Float:flSin = floatsin(-angle, degrees), Float:flCos = floatcos(-angle, degrees);
        spos[0] = flSin * offset[1] + flCos * offset[0] + Race:CheckpointList[raceid][0][0];
        spos[1] = flCos * offset[1] - flSin * offset[0] + Race:CheckpointList[raceid][0][1];
        new MapNode:nodeid;
        GetClosestMapNodeToPoint(spos[0], spos[1], Race:CheckpointList[raceid][0][2] + 1.5, nodeid);
        GetMapNodePos(nodeid, temp, temp, spos[2]);

        Race:PlayerData[playerid][Race:PDataStartSpotX] = spos[0];
        Race:PlayerData[playerid][Race:PDataStartSpotY] = spos[1];
        Race:PlayerData[playerid][Race:PDataStartSpotZ] = spos[2];
        Race:PlayerData[playerid][Race:PDataStartSpotA] = angle;
        Race:PlayerData[playerid][Race:PDataStartSpotI] = spot;

        Race:PeopleInRace[raceid][spot][0] = playerid;
        Race:PeopleInRace[raceid][spot][1] = spot + 1;

    } else {
        new oldveh = Race:PlayerData[playerid][Race:PDataCurrentVehID];
        if (oldveh) {
            DestroyVehicle(oldveh);
        }
        spos[2] = Race:PlayerData[playerid][Race:PDataStartSpotZ];
        angle = Race:PlayerData[playerid][Race:PDataStartSpotA];
    }

    new veh = CreateVehicle(Race:Data[raceid][Race:VehicleModel], spos[0], spos[1], spos[2] + 2.5, angle, RACE_VEHICLE_COL1, RACE_VEHICLE_COL2, 0);
    SaveVehiclePosition(veh);
    ResetVehicleEx(veh);
    SetVehicleFuelEx(veh, 99.00);
    SetVehicleVirtualWorld(veh, RACE_VIRTUAL_WORLD);
    SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
    SetVehicleParamsForPlayer(veh, playerid, false, false);

    SetPlayerInteriorEx(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, RACE_VIRTUAL_WORLD);
    TogglePlayerControllable(playerid, false);

    // Fix the ghost vehicles:
    new oldveh = GetPlayerVehicleID(playerid);
    if (oldveh) {
        new Float:oldpos[3];
        GetVehiclePos(oldveh, oldpos[0], oldpos[1], oldpos[2]);
        SetPlayerPosEx(playerid, oldpos[0], oldpos[1], oldpos[2] - 2.0);
    } else {
        PutPlayerInVehicleEx(playerid, veh, 0);
    }
    Race:PlayerData[playerid][Race:PDataCurrentVehID] = veh;
    return 1;
}

stock Race:Respawn(playerid, raceid) {
    if (raceid < 0 || raceid > MAX_RACES) return 1;
    if (Race:Data[raceid][Race:Started] != 2) {
        Race:SpawnInRace(playerid, raceid);

        if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
            TextDrawShowForPlayer(playerid, Race:joinMenuRaceInfo[raceid][2]);
        }
        return 1;
    }

    if (Race:PlayerData[playerid][Race:PDataIsFinished]) {
        Race:RemoveFromRace(playerid);
        return 1;
    }

    new veh = Race:PlayerData[playerid][Race:PDataCurrentVehID], cp = Race:PlayerData[playerid][Race:PDataCurrentCPID] - 1;

    if (cp < 0) cp = 0;
    new Float:angle = Race:GetAngleToPos(
        Race:CheckpointList[raceid][cp][0], Race:CheckpointList[raceid][cp][1],
        Race:CheckpointList[raceid][cp + 1][0], Race:CheckpointList[raceid][cp + 1][1]
    );

    if (veh) {
        DestroyVehicle(veh);
    }

    veh = CreateVehicle(Race:Data[raceid][Race:VehicleModel], Race:CheckpointList[raceid][cp][0], Race:CheckpointList[raceid][cp][1], Race:CheckpointList[raceid][cp][2] + 3.5, angle, RACE_VEHICLE_COL1, RACE_VEHICLE_COL2, 0);
    SaveVehiclePosition(veh);
    ResetVehicleEx(veh);
    SetVehicleFuelEx(veh, 99.00);
    SetVehicleVirtualWorld(veh, RACE_VIRTUAL_WORLD);
    SetPlayerInteriorEx(playerid, 0);
    SetPlayerVirtualWorldEx(playerid, RACE_VIRTUAL_WORLD);
    SetVehicleParamsEx(veh, true, false, false, true, false, false, false);
    SetVehicleParamsForPlayer(veh, playerid, false, false);
    PutPlayerInVehicleEx(playerid, veh, 0);
    Race:PlayerData[playerid][Race:PDataCurrentVehID] = veh;

    TogglePlayerControllable(playerid, false);
    Race:PlayerData[playerid][Race:PDatarespawnTimer] = SetPreciseTimer("RespawnUnfreeze", RESPAWN_TIME, false, "i", playerid);
    GameTextForPlayer(playerid, "Respawning", RESPAWN_TIME + 200, 3);
    SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You have been respawned in the raceid.");
    return 1;
}

forward RespawnUnfreeze(playerid);
public RespawnUnfreeze(playerid) {
    if (!IsPlayerConnected(playerid)) return 1;
    TogglePlayerControllable(playerid, true);
    Race:PlayerData[playerid][Race:PDatarespawnTimer] = 0;
    return 1;
}

stock Race:Clear(raceid, checkhost = false) {
    Race:Data[raceid][Race:VehicleModel] = 0;
    Race:Data[raceid][Race:Started] = 0;
    Race:Data[raceid][Race:Distance] = 0.0;
    Race:Data[raceid][Race:FinishedPlayers] = 0;
    if (Race:Data[raceid][Race:EndTimer] != -1) {
        DeletePreciseTimer(Race:Data[raceid][Race:EndTimer]);
    }
    Race:Data[raceid][Race:EndTimer] = -1;

    for (new c; c < MAX_CHECKPOINTS + 2; c++) {
        Race:CheckpointList[raceid][c][0] = 0.0;
        Race:CheckpointList[raceid][c][1] = 0.0;
        Race:CheckpointList[raceid][c][2] = 0.0;
    }
    Race:Data[raceid][Race:CPAmount] = 0;

    for (new i; i < MAX_TEXTDRAW_ICONS; i++) {
        if (Race:MapIcons[raceid][i] != Text:INVALID_TEXT_DRAW) {
            TextDrawHideForAll(Race:MapIcons[raceid][i]);
            TextDrawDestroy(Race:MapIcons[raceid][i]);
            Race:MapIcons[raceid][i] = Text:INVALID_TEXT_DRAW;
        }
    }

    for (new t; t < sizeof(Race:joinMenuRaceInfo[]); t++) {
        if (Race:joinMenuRaceInfo[raceid][t] != Text:INVALID_TEXT_DRAW) {
            TextDrawHideForAll(Race:joinMenuRaceInfo[raceid][t]);
            TextDrawDestroy(Race:joinMenuRaceInfo[raceid][t]);
            Race:joinMenuRaceInfo[raceid][t] = Text:INVALID_TEXT_DRAW;
        }
    }

    if (raceid >= MAX_PUBLIC_RACES) // private races
    {
        new str[48];
        Race:AmountOfPrivateRaces--;
        format(str, sizeof(str), "<%i/%d> Create private race!", Race:AmountOfPrivateRaces, MAX_PRIVATE_RACES);
        TextDrawSetString(Race:joinMenuPrivate, str);

        TextDrawHideForAll(Race:joinMenuSlots[raceid]);
        TextDrawDestroy(Race:joinMenuSlots[raceid]);
        Race:joinMenuSlots[raceid] = Text:INVALID_TEXT_DRAW;
    }

    new playerid = Race:Data[raceid][Race:Host];
    Race:Data[raceid][Race:Host] = INVALID_PLAYER_ID;
    foreach(new p:Player) {
        if (IsPlayerConnected(p) && !IsPlayerNPC(p)) {
            new pRace = Race:PlayerData[p][Race:PDataCurrentRaceID];
            if (pRace && pRace - 2 == raceid) {
                if (!checkhost || (checkhost && p != playerid)) {
                    Race:RemoveFromRace(p);
                }
            }
        }
    }
    Race:Data[raceid][Race:PlayerAmount] = 0;

    TextDrawSetString(Race:joinMenuSlots[raceid], "<Empty> Create a race!");
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    UCP:AddCommand(playerid, "Race System (Beta)");
    if (Race:PlayerData[playerid][Race:PDataCurrentRaceID]) {
        UCP:AddCommand(playerid, "Race > Respawn", true);
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Race System (Beta)", inputtext)) Race:MainMenu(playerid);
    if (IsStringSame("Race > Respawn", inputtext)) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (raceid) {
            Race:Respawn(playerid, raceid);
        }
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "race system") && GetPlayerVIPLevel(playerid) > 0) {
        Race:MainMenu(playerid);
        return ~1;
    }
    return 1;
}

stock Race:Start(raceid, bool:countdown = true) {
    if (!(0 <= raceid < MAX_RACES) || Race:Data[raceid][Race:Host] == INVALID_PLAYER_ID) return 0;
    if (countdown == true) {
        Race:Data[raceid][Race:Started] = 1;
        SetPreciseTimer("RaceCountdownTimer", 1000, false, "ii", raceid, 3);
    } else // start race immediately
    {
        Race:Data[raceid][Race:Started] = 2;

        for (new s; s < MAX_CONTESTANTS; s++) {
            if (Race:PeopleInRace[raceid][s][0] != INVALID_PLAYER_ID) {
                new p = Race:PeopleInRace[raceid][s][0];

                TogglePlayerControllable(p, true);
                Race:PlayerData[p][Race:PDataStartSpotX] = 0;
                Race:PlayerData[p][Race:PDataStartSpotY] = 0;
                Race:PlayerData[p][Race:PDataStartSpotZ] = 0;
                Race:PlayerData[p][Race:PDataStartSpotA] = 0;

                SetCameraBehindPlayer(p);
                Race:UpdatePlayerGUI(p);
                Race:SetCheckpoint(p, raceid, 2);
                SendClientMessageEx(p, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}If you get stuck, you can respawn at the last checkpoint by using '{FF6262}pocket > race system > respawn{FFFFFF}'.");

                if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
                    TextDrawHideForPlayer(p, Race:joinMenuRaceInfo[raceid][2]);
                }

                new veh = Race:PlayerData[p][Race:PDataCurrentVehID], params[7];
                GetVehicleDamageStatus(veh, params[0], params[1], params[2], params[3]);
                UpdateVehicleDamageStatus(veh, params[0], params[1], params[2], 0);

                GetVehicleParamsEx(veh, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
                SetVehicleParamsEx(veh, true, params[1], params[2], true, params[4], params[5], params[6]);
            }
        }
    }
    return 1;
}

forward RaceCountdownTimer(raceid, count);
public RaceCountdownTimer(raceid, count) {
    if (Race:Data[raceid][Race:Started] != 1) {
        return 0;
    }

    new str[2];
    str[0] = '0' + count;

    for (new s; s < MAX_CONTESTANTS; s++) {
        if (Race:PeopleInRace[raceid][s][0] != INVALID_PLAYER_ID) {
            new p = Race:PeopleInRace[raceid][s][0];
            switch (count) {
                case 0 :  {
                    GameTextForPlayer(p, "GO!", 2000, 3);
                    TogglePlayerControllable(p, true);
                    PlayerPlaySound(p, 1057, 0.0, 0.0, 0.0);

                    Race:PlayerData[p][Race:PDataStartSpotX] = 0;
                    Race:PlayerData[p][Race:PDataStartSpotY] = 0;
                    Race:PlayerData[p][Race:PDataStartSpotZ] = 0;
                    Race:PlayerData[p][Race:PDataStartSpotA] = 0;

                    new veh = Race:PlayerData[p][Race:PDataCurrentVehID], params[7];
                    GetVehicleDamageStatus(veh, params[0], params[1], params[2], params[3]);
                    UpdateVehicleDamageStatus(veh, params[0], params[1], params[2], 0);

                    GetVehicleParamsEx(veh, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
                    SetVehicleParamsEx(veh, 1, params[1], params[2], 1, params[4], params[5], params[6]);
                }
                case 1, 2 :  {
                    GameTextForPlayer(p, str, 2000, 3);
                    PlayerPlaySound(p, 1056, 0.0, 0.0, 0.0);
                }
                case 3 :  {
                    GameTextForPlayer(p, str, 2000, 3);
                    PlayerPlaySound(p, 1056, 0.0, 0.0, 0.0);

                    SetCameraBehindPlayer(p);
                    Race:UpdatePlayerGUI(p);
                    Race:SetCheckpoint(p, raceid, 2);
                    SendClientMessageEx(p, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}If you get stuck, you can respawn at the last checkpoint by using '{FF6262}pocket > race system > respawn{FFFFFF}'.");

                    if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
                        TextDrawHideForPlayer(p, Race:joinMenuRaceInfo[raceid][2]);
                    }

                }
            }
        }
    }
    if (count) {
        SetPreciseTimer("RaceCountdownTimer", 1000, false, "ii", raceid, count - 1);
    } else {
        Race:Data[raceid][Race:Started] = 2;
    }
    return 1;
}

stock Race:ShowJoinMenu(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;

    Race:PlayerData[playerid][Race:PDataJoinMenuOpen] = 1;
    for (new e; e < sizeof(Race:joinMenuExtra); e++) {
        TextDrawShowForPlayer(playerid, Race:joinMenuExtra[e]);
    }
    for (new s; s < MAX_PUBLIC_RACES; s++) {
        if (Race:Data[s][Race:Started] == 2) {
            TextDrawColor(Race:joinMenuSlots[s], COL_MENU_STARTED);
        } else {
            TextDrawColor(Race:joinMenuSlots[s], COL_MENU_REGULAR);
        }
        TextDrawShowForPlayer(playerid, Race:joinMenuSlots[s]);
    }
    TextDrawShowForPlayer(playerid, Race:joinMenuButtons[2]);
    SelectTextDraw(playerid, COL_MENU_MOUSEOVER);

    for (new d; d < 5; d++) {
        SendDeathMessageToPlayer(playerid, -1, MAX_PLAYERS, -1);
    }

    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID], bool:privaterace = false;
    if (raceid) {
        PlayerTextDrawHide(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);

        raceid -= 2;
        if (Race:joinMenuRaceInfo[raceid][2] != Text:INVALID_TEXT_DRAW) {
            TextDrawHideForPlayer(playerid, Race:joinMenuRaceInfo[raceid][2]);
        }
        if (raceid >= MAX_PUBLIC_RACES) {
            if (Race:Data[raceid][Race:Started] == 2) {
                TextDrawColor(Race:joinMenuSlots[raceid], COL_MENU_STARTED);
            } else {
                TextDrawColor(Race:joinMenuSlots[raceid], COL_MENU_REGULAR);
            }
            TextDrawShowForPlayer(playerid, Race:joinMenuSlots[raceid]);
            privaterace = true;
        }
    }
    if (privaterace == false) {
        TextDrawColor(Race:joinMenuPrivate, COL_MENU_REGULAR);
        TextDrawShowForPlayer(playerid, Race:joinMenuPrivate);
    }
    return 1;
}

stock Race:UpdatePlayerGUI(playerid) {
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (!raceid) return 0;
    raceid -= 2;

    new startspot = Race:PlayerData[playerid][Race:PDataStartSpotI];
    if (Race:PeopleInRace[raceid][startspot][0] != playerid) return 0;

    new str[100], cp = Race:PlayerData[playerid][Race:PDataCurrentCPID] - 2;
    format(str, sizeof(str),
        "~r~   Position: ~w~%i/%i~n~~r~Checkpoint: ~w~%i/%i__",
        Race:PeopleInRace[raceid][startspot][1],
        Race:Data[raceid][Race:PlayerAmount], (cp > 0) ? cp : 0,
        Race:Data[raceid][Race:CPAmount]
    );
    PlayerTextDrawSetString(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD], str);
    PlayerTextDrawShow(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);
    return 1;
}

stock Race:SetCheckpoint(playerid, raceid, cp) {
    // If the player triggered the last checkpoint:
    if (cp == MAX_CHECKPOINTS + 2 || cp == Race:Data[raceid][Race:CPAmount] + 2) // checked last checkpoint
    {
        DisablePlayerRaceCheckpoint(playerid);
        PlayerTextDrawHide(playerid, PlayerText:Race:PlayerData[playerid][Race:PDataRacePlayerTD]);


        new nmb[3], startspot = Race:PlayerData[playerid][Race:PDataStartSpotI];
        if (Race:PeopleInRace[raceid][startspot][0] != playerid) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the calculation of your race position. (Reference ID: 005)");
        }

        // Create "Player has finished #th"-text:
        switch (Race:PeopleInRace[raceid][startspot][1]) {
            case 1:
                GameTextForPlayer(playerid, "1st place!", 3500, 3), nmb = "st";
            case 2:
                GameTextForPlayer(playerid, "2nd place!", 3500, 3), nmb = "nd";
            case 3:
                GameTextForPlayer(playerid, "3rd place!", 3500, 3), nmb = "rd";
                default:  {
                    new str[12];
                    format(str, sizeof(str), "%ith place!", Race:PeopleInRace[raceid][startspot][1]);
                    GameTextForPlayer(playerid, str, 3500, 3);
                    nmb = "th";
                }
        }
        new text[128], pName[MAX_PLAYER_NAME], oName[MAX_PLAYER_NAME], len;
        GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
        len = GetPlayerName(Race:Data[raceid][Race:Host], oName, MAX_PLAYER_NAME);

        switch (oName[len - 1]) {
            case 's', 'z', 'S', 'Z':
                format(text, sizeof(text), " [!] FINISH: %s finished %i%s place in %s' race!", pName, Race:PeopleInRace[raceid][startspot][1], nmb, oName);
            default:
                format(text, sizeof(text), " [!] FINISH: %s finished %i%s place in %s's race!", pName, Race:PeopleInRace[raceid][startspot][1], nmb, oName);
        }
        SendClientMessageToAll(COL_TEXT_WIN, text);

        Race:Data[raceid][Race:FinishedPlayers]++;

        // Check if everyone has finished or just one
        if (Race:Data[raceid][Race:PlayerAmount] == 1 || Race:Data[raceid][Race:PlayerAmount] == Race:Data[raceid][Race:FinishedPlayers]) // The last finisher starts the shortened ending timer.
        {
            if (Race:Data[raceid][Race:EndTimer] != -1) {
                DeletePreciseTimer(Race:Data[raceid][Race:EndTimer]);
            }
            Race:Data[raceid][Race:EndTimer] = SetPreciseTimer("RaceEndingTimer", 10000, false, "i", raceid);

            if (Race:Data[raceid][Race:PlayerAmount] == 1) {
                SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}All contestants have crossed the finish line! The race will be removed in 10 seconds.");
            } else {
                for (new p; p < MAX_CONTESTANTS; p++) {
                    if (Race:PeopleInRace[raceid][p][0] != INVALID_PLAYER_ID) {
                        SendClientMessageEx(Race:PeopleInRace[raceid][p][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}All contestants have crossed the finish line! The race will be removed in 10 seconds.");
                    }
                }
            }
        } else // The first finisher will start the ending timer.
        {
            if (Race:PeopleInRace[raceid][startspot][1] == 1 && Race:Data[raceid][Race:FinishedPlayers] == 1 && Race:Data[raceid][Race:EndTimer] == -1) {
                Race:Data[raceid][Race:EndTimer] = SetPreciseTimer("RaceEndingTimer", 60000, false, "i", raceid);

                for (new p; p < MAX_CONTESTANTS; p++) {
                    if (Race:PeopleInRace[raceid][p][0] != INVALID_PLAYER_ID) {
                        SendClientMessageEx(Race:PeopleInRace[raceid][p][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}The race will end in 60 seconds.");
                    }
                }
            }
        }

        Race:PlayerData[playerid][Race:PDataIsFinished] = 1;
        SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You can leave the race by using '{FF6262}pocket > race system > leave{FFFFFF}' or wait until the race ends.");
    }
    // If the player triggered the checkpoint just before the last one (spawns finish checkpoint)
    else if (cp == MAX_CHECKPOINTS + 1 || cp == Race:Data[raceid][Race:CPAmount] + 1) {
        SetPlayerRaceCheckpoint(playerid, 1, Race:CheckpointList[raceid][cp][0], Race:CheckpointList[raceid][cp][1], Race:CheckpointList[raceid][cp][2] + 1.0, 0.0, 0.0, 0.0, 15.0);
    } else if (cp <= MAX_CHECKPOINTS || cp <= Race:Data[raceid][Race:CPAmount]) // Spawns regular checkpoint
    {
        SetPlayerRaceCheckpoint(playerid, 0, Race:CheckpointList[raceid][cp][0], Race:CheckpointList[raceid][cp][1], Race:CheckpointList[raceid][cp][2] + 1.0, Race:CheckpointList[raceid][cp + 1][0], Race:CheckpointList[raceid][cp + 1][1], Race:CheckpointList[raceid][cp + 1][2], 15.0);
    } else {
        return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: An error occured during the placing of the next checkpoint. (Reference ID: 013)");
    }

    // Create map icons on radar which suggest the next two checkpoints:
    for (new ci, icon = SUGGESTED_MAPICONS_OFFSET; ci < MAX_SUGGESTED_MAPICONS; ci++, icon++) {
        new cin = cp + ci + 1; // For CP list position, to get coords
        if (cin < MAX_CHECKPOINTS + 2 && cin < Race:Data[raceid][Race:CPAmount] + 2) {
            SetPlayerMapIcon(playerid, icon, Race:CheckpointList[raceid][cin][0], Race:CheckpointList[raceid][cin][1], Race:CheckpointList[raceid][cin][2], 0, COL_MAP_CP, 0);
        } else {
            RemovePlayerMapIcon(playerid, icon);
        }
    }

    Race:PlayerData[playerid][Race:PDataCurrentCPID] = cp;
    return 1;
}

forward RaceEndingTimer(race);
public RaceEndingTimer(race) {
    for (new s; s < MAX_CONTESTANTS; s++) {
        if (Race:PeopleInRace[race][s][0] != INVALID_PLAYER_ID) {
            if (!Race:PlayerData[Race:PeopleInRace[race][s][0]][Race:PDataIsFinished]) {
                SendClientMessageEx(Race:PeopleInRace[race][s][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}Too slow! You didn't finish before the race ended.");
            } else {
                SendClientMessageEx(Race:PeopleInRace[race][s][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}The race has been ended. You have been respawned at your old position.");
            }
        }
    }
    Race:Clear(race);
    return 1;
}

stock Race:MainMenu(playerid) {
    new string[512];
    strcat(string, "Menu\n");
    strcat(string, "Start Race\n");
    strcat(string, "Respawn\n");
    strcat(string, "Leave\n");
    strcat(string, "Invite\n");
    strcat(string, "Show Invite\n");
    strcat(string, "Help\n");
    return FlexPlayerDialog(playerid, "RaceMainMenu", DIALOG_STYLE_LIST, "{4286f4}[Alexa]: {FFFFEE}Race System", string, "Select", "Close");
}

FlexDialog:RaceMainMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Menu")) return Race:ShowJoinMenu(playerid);
    if (IsStringSame(inputtext, "Start Race")) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (!raceid) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have not created a race yet.");
            return ~1;
        }
        raceid -= 2;
        if (Race:Data[raceid][Race:Host] != playerid) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have not created this race.");
            return ~1;
        }

        if (Race:Data[raceid][Race:Started]) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: This race has already started.");
            return ~1;
        }
        if (Race:Data[raceid][Race:PlayerAmount] < MIN_CONTESTANTS) {
            SendClientMessageEx(playerid, COL_TEXT_ERROR, sprintf(" [!] ERROR: To start this race, there needs to be at least %d contestants.", MIN_CONTESTANTS));
            return ~1;
        }
        return Race:Start(raceid);
    }
    if (IsStringSame(inputtext, "Respawn")) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (!raceid) return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are not in a race right now!");
        raceid -= 2;
        if (Race:Data[raceid][Race:Started] != 2) return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You cannot respawn right now! The race has not started yet.");
        if (Race:PlayerData[playerid][Race:PDataIsFinished]) return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You cannot respawn anymore! You have already finished.");
        return Race:Respawn(playerid, raceid);
    }
    if (IsStringSame(inputtext, "Leave")) {
        new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
        if (raceid && Race:Data[raceid - 2][Race:Host] == playerid) {
            // If the player is host
            raceid -= 2;
            if (Race:RemoveFromRace(playerid) == 1) {
                // Race has been ended and no host was found
                SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You have called off the race.");
                for (new p; p < MAX_CONTESTANTS; p++) {
                    if (Race:PeopleInRace[raceid][p][0] != INVALID_PLAYER_ID && Race:PeopleInRace[raceid][p][0] != Race:Data[raceid][Race:Host])
                        SendClientMessageEx(Race:PeopleInRace[raceid][p][0], COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}The race you are participating in has been called off.");
                }
            }
        } else {
            // If the player is a contestant (not the host)
            if (!raceid) return SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are currently not in a race.");
            SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, " [!] NOTE: {FFFFFF}You have left the race.");
            return Race:RemoveFromRace(playerid);
        }
        return 1;
    }
    if (IsStringSame(inputtext, "Invite")) return Race:MenuInvite(playerid);
    if (IsStringSame(inputtext, "Show Invite")) return Race:MenuShowInvite(playerid);
    if (IsStringSame(inputtext, "Help")) {
        SendClientMessageEx(playerid, COL_TEXT_REG, " ");
        SendClientMessageEx(playerid, COL_TEXT_WIN, " - - - Race System [Help] - - -");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > help ................\tshows this command list.");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > menu ..............\tshows the race list (join & create).");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > respawn .........\trespawns you during the race.");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > leave ...............\tleave the current race.");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > start ...............\tstart the race countdown (as host).");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > invite [name] ...\tinvite another player (as host).");
        SendClientMessageEx(playerid, COL_TEXT_REG, "pocket > race system > showinvite ......\tshows the current invite.");
        return Race:MainMenu(playerid);
    }
    return 1;
}

stock Race:MenuInvite(playerid) {
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (!raceid) {
        SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are currently not in a race.");
        return Race:MainMenu(playerid);
    }
    return FlexPlayerDialog(playerid, "RaceMenuInvite", DIALOG_STYLE_INPUT, "Send Race Invitation", "Enter playername or playerid", "Invite", "Close");
}

FlexDialog:RaceMenuInvite(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Race:MainMenu(playerid);
    new lastplayer = -1;
    if (sscanf(inputtext, "u", lastplayer) || lastplayer == playerid || !IsPlayerConnected(lastplayer)) return Race:MenuInvite(playerid);
    new raceid = Race:PlayerData[playerid][Race:PDataCurrentRaceID];
    if (!raceid) {
        SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You are currently not in a race.");
        return Race:MainMenu(playerid);
    }

    raceid -= 2;
    // Already invited?
    new curinvite = Race:PlayerData[lastplayer][Race:PDataCurrentInviteID];
    if (curinvite) {
        curinvite--;
        if (Race:PlayerData[lastplayer][Race:PDataCurrentInviteTime] >= gettime()) {
            if (curinvite == playerid) SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: You have already invited the given player.");
            else SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: The given player has already received another invite.");
            return Race:MenuInvite(playerid);
        }
    }

    // Already racing?
    new otherrace = Race:PlayerData[lastplayer][Race:PDataCurrentRaceID];
    if (otherrace) {
        otherrace -= 2;
        if (otherrace == raceid) SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: The given player is already in this race.");
        else SendClientMessageEx(playerid, COL_TEXT_ERROR, " [!] ERROR: The given player is already in another race.");
        return Race:MenuInvite(playerid);
    }

    new str[512];
    if (Race:Data[raceid][Race:Host] == playerid) format(str, sizeof(str), " [!] NOTE: {FFFFFF}You have been invited to join %s' race.", GetPlayerNameEx(playerid));
    else format(str, sizeof(str), " [!] NOTE: {FFFFFF}You have been invited by %s to join %s' race.", GetPlayerNameEx(playerid), GetPlayerNameEx(Race:Data[raceid][Race:Host]));

    SendClientMessageEx(lastplayer, COL_TEXT_ERROR, str);
    SendClientMessageEx(lastplayer, COL_TEXT_IMPORTANT, sprintf(" [!] NOTE: {FFFFFF}Use '{FF6262}pocket > race system > showinvite{FFFFFF}' to accept or decline it. The invite will expire in %d seconds.", INVITE_EXPIRE));
    Race:PlayerData[lastplayer][Race:PDataCurrentInviteID] = playerid + 1;
    Race:PlayerData[lastplayer][Race:PDataCurrentInviteTime] = gettime() + INVITE_EXPIRE;

    format(str, sizeof(str), " [!] NOTE: {FFFFFF}You have invited %s to join your race.", GetPlayerNameEx(lastplayer));
    SendClientMessageEx(playerid, COL_TEXT_IMPORTANT, str);
    return Race:MenuInvite(playerid);
}

stock Race:MenuShowInvite(playerid) {
    new invitingplayer = Race:PlayerData[playerid][Race:PDataCurrentInviteID];
    new invitetime = Race:PlayerData[playerid][Race:PDataCurrentInviteTime];
    if (invitetime < gettime()) {
        // If the invite has expired
        if (invitetime && invitingplayer) {
            Race:PlayerData[playerid][Race:PDataCurrentInviteID] = 0;
            Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = 0;
            AlexaMsg(playerid, sprintf(" [!] ERROR: The invite you received from %s has expired.", GetPlayerNameEx(invitingplayer)));
        } else {
            AlexaMsg(playerid, " [!] ERROR: You do not have an invite to show.");
        }
        return Race:MainMenu(playerid);
    }
    if (!invitingplayer) {
        Race:PlayerData[playerid][Race:PDataCurrentInviteID] = 0;
        Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = 0;
        AlexaMsg(playerid, " [!] ERROR: An error occured while showing invite. (Reference ID: 010) The inviting player ID could not be found.");
        return Race:MainMenu(playerid);
    }
    invitingplayer--;
    new raceid = Race:PlayerData[invitingplayer][Race:PDataCurrentRaceID];
    if (!raceid) {
        Race:PlayerData[playerid][Race:PDataCurrentInviteID] = 0;
        Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = 0;
        AlexaMsg(playerid, " [!] ERROR: The invite you received is not valid anymore. Invite has been removed.");
        return Race:MainMenu(playerid);
    }
    raceid -= 2;

    new dialogTitle[MAX_PLAYER_NAME + 24];
    new dialogStr[255];
    new pName[MAX_PLAYER_NAME];
    new vehicleName[100];
    new len = GetPlayerName(invitingplayer, pName, MAX_PLAYER_NAME);
    format(dialogTitle, sizeof(dialogTitle), "{FFFFFF}Invite from %s", pName);
    if (Race:Data[raceid][Race:VehicleModel]) {
        format(vehicleName, sizeof vehicleName, "%s", GetVehicleModelName(Race:Data[raceid][Race:VehicleModel]));
    } else {
        Race:PlayerData[playerid][Race:PDataCurrentInviteID] = 0;
        Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = 0;
        AlexaMsg(playerid, " [!] ERROR: An error occured while showing invite. (Reference ID: 011) Race vehicle model could not be found.");
        return Race:MainMenu(playerid);
    }

    // Make dialog text based on if the inviting player is the host of the race or not.
    if (Race:Data[raceid][Race:Host] == invitingplayer) {
        switch (pName[len - 1]) {
            case 's', 'z', 'S', 'Z'
            :  {
                format(dialogStr, sizeof(dialogStr), \
                    "{FFFFFF}You have been invited to join %s' race.\n\n{CF2C23}Vehicle: {FFFFFF}%s\n{CF2C23}Length: {FFFFFF}%.1f meters\n{CF2C23}Checkpoints{FFFFFF}: %i\n{CF2C23}Host: {FFFFFF}%s\n\nDo you want to accept or decline this invite?", \
                    pName, vehicleName, Race:Data[raceid][Race:Distance], Race:Data[raceid][Race:CPAmount], pName);
            }
            default:  {
                format(dialogStr, sizeof(dialogStr), \
                    "{FFFFFF}You have been invited to join %s's race.\n\n{CF2C23}Vehicle: {FFFFFF}%s\n{CF2C23}Length: {FFFFFF}%.1f meters\n{CF2C23}Checkpoints{FFFFFF}: %i\n{CF2C23}Host: {FFFFFF}%s\n\nDo you want to accept or decline this invite?", \
                    pName, vehicleName, Race:Data[raceid][Race:Distance], Race:Data[raceid][Race:CPAmount], pName);
            }
        }
    } else {
        new hName[MAX_PLAYER_NAME];
        len = GetPlayerName(Race:Data[raceid][Race:Host], hName, MAX_PLAYER_NAME);

        switch (hName[len - 1]) {
            case 's', 'z', 'S', 'Z'
            :  {
                format(dialogStr, sizeof(dialogStr), \
                    "{FFFFFF}You have been invited by %s to join %s' race.\n\n{CF2C23}Vehicle: {FFFFFF}%s\n{CF2C23}Length: {FFFFFF}%.1f meters\n{CF2C23}Checkpoints: {FFFFFF}%i\n{CF2C23}Host: {FFFFFF}%s\n\nDo you want to accept or decline this invite?", \
                    pName, hName, vehicleName, Race:Data[raceid][Race:Distance], Race:Data[raceid][Race:CPAmount], hName);
            }
            default:  {
                format(dialogStr, sizeof(dialogStr), \
                    "{FFFFFF}You have been invited by %s to join %s's race.\n\n{CF2C23}Vehicle: {FFFFFF}%s\n{CF2C23}Length: {FFFFFF}%.1f meters\n{CF2C23}Checkpoints: {FFFFFF}%i\n{CF2C23}Host: {FFFFFF}%s\n\nDo you want to accept or decline this invite?", \
                    pName, hName, vehicleName, Race:Data[raceid][Race:Distance], Race:Data[raceid][Race:CPAmount], hName);
            }
        }

    }
    Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = cellmax;
    return FlexPlayerDialog(playerid, "RaceShowInviteOffer", DIALOG_STYLE_MSGBOX, dialogTitle, dialogStr, "Accept", "Decline");
}

FlexDialog:RaceShowInviteOffer(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new inviteplayer = Race:PlayerData[playerid][Race:PDataCurrentInviteID];
    Race:PlayerData[playerid][Race:PDataCurrentInviteID] = 0;
    Race:PlayerData[playerid][Race:PDataCurrentInviteTime] = 0;

    // In case of invalid data, error
    if (!inviteplayer) {
        AlexaMsg(playerid, " [!] ERROR: An error occured while showing invite. (Reference ID: 010) The inviting player ID could not be found.");
        return Race:MainMenu(playerid);
    }
    inviteplayer--;

    // If the invite is declined
    if (!response || !IsPlayerConnected(inviteplayer)) {
        // If the inviting player is not online anymore, just 'decline', else use name of player.
        AlexaMsg(playerid, sprintf(" [!] NOTE: {FFFFFF}You have declined the race invite from %s.", GetPlayerNameEx(inviteplayer)));
        return Race:MainMenu(playerid);
    }

    // If player is not in race anymore
    new raceid = Race:PlayerData[inviteplayer][Race:PDataCurrentRaceID];
    if (!raceid) {
        AlexaMsg(playerid, " [!] ERROR: The player is not in a race anymore. You cannot join him.");
        return Race:MainMenu(playerid);
    }
    raceid -= 2;

    // If everything is okay, join the inviting player
    Race:PutPlayerInRace(playerid, raceid);
    return 1;
}