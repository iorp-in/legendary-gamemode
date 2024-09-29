enum CES_Data {
    bool:CES_Cuffed,
    bool:CES_Follow,
    bool:CES_Car,
    CES_Follow_PID
};

new Player_CES_Data[MAX_PLAYERS][CES_Data];

hook OnPlayerConnect(playerid) {
    Player_CES_Data[playerid][CES_Cuffed] = false;
    Player_CES_Data[playerid][CES_Follow] = false;
    Player_CES_Data[playerid][CES_Follow_PID] = INVALID_PLAYER_ID;
    return 1;
}

stock IsCuff_Player(playerid) {
    return Player_CES_Data[playerid][CES_Cuffed];
}

stock Cuff_Player(playerid) {
    Player_CES_Data[playerid][CES_Cuffed] = true;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    TogglePlayerControllable(playerid, false);
    CallRemoteFunction("OnPlayerCuffed", "d", playerid);
    return 1;
}

stock Uncuff_Player(playerid) {
    Player_CES_Data[playerid][CES_Cuffed] = false;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    TogglePlayerControllable(playerid, true);
    CallRemoteFunction("OnPlayerUncuffed", "d", playerid);
    return 1;
}

forward OnPlayerCuffed(playerid);
public OnPlayerCuffed(playerid) {
    return 1;
}

forward OnPlayerUncuffed(playerid);
public OnPlayerUncuffed(playerid) {
    return 1;
}

stock IsCES_FollowPlayer(playerid) {
    return Player_CES_Data[playerid][CES_Follow];
}

stock CES_FollowPlayer(playerid, Follow_PID) {
    if (!IsPlayerConnected(Follow_PID)) return 0;
    Player_CES_Data[playerid][CES_Follow] = true;
    Player_CES_Data[playerid][CES_Follow_PID] = Follow_PID;
    return 1;
}

stock CES_StopFollowPlayer(playerid) {
    Player_CES_Data[playerid][CES_Follow] = false;
    Player_CES_Data[playerid][CES_Follow_PID] = INVALID_PLAYER_ID;
    return 1;
}

stock CES_ThrowInCar(playerid, targetid) {
    new vehicleid = GetPlayerNearestVehicle(playerid);
    if (!IsValidVehicle(vehicleid)) return 0;
    new seatid = GetVehicleNextSeat(vehicleid, 1);
    if (seatid == INVALID_SEAT_ID) return 0;
    PutPlayerInVehicleEx(targetid, vehicleid, seatid);
    Player_CES_Data[targetid][CES_Car] = true;
    Player_CES_Data[targetid][CES_Follow_PID] = playerid;
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (Player_CES_Data[playerid][CES_Cuffed]) {
        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CUFFED) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    }
    if (Player_CES_Data[playerid][CES_Follow]) {
        if (!IsPlayerConnected(Player_CES_Data[playerid][CES_Follow_PID])) {
            Anim:Stop(playerid);
            TogglePlayerControllable(playerid, false);
            CES_StopFollowPlayer(playerid);
            return 1;
        }
        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(Player_CES_Data[playerid][CES_Follow_PID], Float:X, Float:Y, Float:Z);
        new Float:diff_distance = GetPlayerDistanceFromPoint(playerid, Float:X, Float:Y, Float:Z);
        if (diff_distance > 3.0) {
            TogglePlayerControllable(playerid, true);
            SetPlayerTargetPlayerAngle(playerid, Player_CES_Data[playerid][CES_Follow_PID]);
            ApplyAnimation(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
        } else {
            Anim:Stop(playerid);
            TogglePlayerControllable(playerid, false);
        }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if (newstate != PLAYER_STATE_ONFOOT) return 1;
    foreach(new i:Player) {
        if (Player_CES_Data[i][CES_Car] && Player_CES_Data[i][CES_Follow_PID] == playerid) {
            Player_CES_Data[i][CES_Car] = false;
            Player_CES_Data[i][CES_Follow_PID] = INVALID_PLAYER_ID;
            RemovePlayerFromVehicle(i);
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    foreach(new i:Player) {
        if (Player_CES_Data[i][CES_Car] && Player_CES_Data[i][CES_Follow_PID] == playerid) {
            Player_CES_Data[i][CES_Car] = false;
            Player_CES_Data[i][CES_Follow_PID] = INVALID_PLAYER_ID;
            RemovePlayerFromVehicle(i);
        }
    }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    // if(!GetPlayerRPMode(playerid) || !GetPlayerRPMode(targetid)) return 1;
    new allow_faction[] = { 0, 1, 2, 3, 5, 7, 8, 9, 10 };
    if (IsArrayContainNumber(allow_faction, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) {
        if (GetPlayerSpecialAction(targetid) != SPECIAL_ACTION_CUFFED) {
            QuickActions:AddCommand(playerid, "Cuff Player");
        } else {
            if (!Player_CES_Data[targetid][CES_Follow]) {
                QuickActions:AddCommand(playerid, "Enable Follow Me Action");
                new vehicleid = GetPlayerNearestVehicle(playerid);
                if (IsValidVehicle(vehicleid)) QuickActions:AddCommand(playerid, "Put In Car");
            } else QuickActions:AddCommand(playerid, "Disable Follow Me Action");
            QuickActions:AddCommand(playerid, "UnCuff Player");
        }
    }
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Cuff Player", inputtext)) return Cuff_Player(targetid);
    if (IsStringSame("UnCuff Player", inputtext)) return Uncuff_Player(targetid);
    if (IsStringSame("Enable Follow Me Action", inputtext)) {
        if (CES_FollowPlayer(targetid, playerid)) {}
        return 1;
    }
    if (IsStringSame("Disable Follow Me Action", inputtext)) return CES_StopFollowPlayer(targetid);
    if (IsStringSame("Put In Car", inputtext)) {
        if (CES_ThrowInCar(playerid, targetid)) {}
        return 1;
    }
    return 1;
}