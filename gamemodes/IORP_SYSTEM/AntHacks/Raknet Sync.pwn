new bool:isDebugAllowed = false;
//https://github.com/BrunoBM16/samp-packet-list/wiki/RPC-List
//https://github.com/urShadow/Pawn.RakNet/wiki
const PLAYER_SYNC = 207;
const VEHICLE_SYNC = 200;
const PASSENGER_SYNC = 211;
const SPECTATING_SYNC = 212;
const TRAILER_SYNC = 210;
const UNOCCUPIED_SYNC = 209;
const AIM_SYNC = 203;
const BULLET_SYNC = 206;
const GiveOrTake = 115;
const EnterVehicle = 26;
const ExitVehicle = 154;
const PlayerEditAttachedObject = 116;
const SendDialogResponse = 62;
enum eDisabledKeys {
    Disable_LeftKey,
    Disable_RightKey,
    Disable_UpKey,
    Disable_DownKey,
    Disabled_Keys
};

new gPlayerDisabledKeys[MAX_PLAYERS][eDisabledKeys];

stock ProcessDisabledKeys(playerid, & lrKey, & udKey, & keys) {
    if (
        (lrKey == KEY_LEFT && gPlayerDisabledKeys[playerid][Disable_LeftKey]) ||
        (lrKey == KEY_RIGHT && gPlayerDisabledKeys[playerid][Disable_RightKey])
    ) {
        lrKey = 0;
    }

    if (
        (udKey == KEY_UP && gPlayerDisabledKeys[playerid][Disable_UpKey]) ||
        (udKey == KEY_DOWN && gPlayerDisabledKeys[playerid][Disable_DownKey])
    ) {
        udKey = 0;
    }

    keys &= ~gPlayerDisabledKeys[playerid][Disabled_Keys];
}

stock SetPlayerDisableKeysSync(playerid, keys, left = false, right = false, up = false, down = false) {
    gPlayerDisabledKeys[playerid][Disable_LeftKey] = left;
    gPlayerDisabledKeys[playerid][Disable_RightKey] = right;
    gPlayerDisabledKeys[playerid][Disable_UpKey] = up;
    gPlayerDisabledKeys[playerid][Disable_DownKey] = down;

    gPlayerDisabledKeys[playerid][Disabled_Keys] = keys;
}

IPacket:PLAYER_SYNC(playerid, BitStream:bs) {
    new onFootData[PR_OnFootSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadOnFootSync(bs, onFootData);

    if (isDebugAllowed) printf("Debug:PLAYER_SYNC[%d]: lrKey %d  udKey %d  keys %d  position: %.2f %.2f %.2f  quaternion %.2f %.2f %.2f %.2f  health %d  armour %d  additionalKey %d  weaponId %d  specialAction %d  velocity %.2f %.2f %.2f  surfingOffsets %.2f %.2f %.2f  surfingVehicleId %d  animationId %d  animationFlags %d",
        playerid,
        onFootData[PR_lrKey],
        onFootData[PR_udKey],
        onFootData[PR_keys],
        onFootData[PR_position][0],
        onFootData[PR_position][1],
        onFootData[PR_position][2],
        onFootData[PR_quaternion][0],
        onFootData[PR_quaternion][1],
        onFootData[PR_quaternion][2],
        onFootData[PR_quaternion][3],
        onFootData[PR_health],
        onFootData[PR_armour],
        onFootData[PR_additionalKey],
        onFootData[PR_weaponId],
        onFootData[PR_specialAction],
        onFootData[PR_velocity][0],
        onFootData[PR_velocity][1],
        onFootData[PR_velocity][2],
        onFootData[PR_surfingOffsets][0],
        onFootData[PR_surfingOffsets][1],
        onFootData[PR_surfingOffsets][2],
        onFootData[PR_surfingVehicleId],
        onFootData[PR_animationId],
        onFootData[PR_animationFlags]
    );

    if (onFootData[PR_surfingVehicleId] != 0 && onFootData[PR_surfingVehicleId] != INVALID_VEHICLE_ID) {
        if ((floatabs(onFootData[PR_surfingOffsets][0]) >= 10.0) || (floatabs(onFootData[PR_surfingOffsets][1]) >= 10.0) || (floatabs(onFootData[PR_surfingOffsets][2]) >= 10.0)) {
            onFootData[PR_surfingOffsets][0] = onFootData[PR_surfingOffsets][1] = onFootData[PR_surfingOffsets][2] = 0.0;
        }
    }
    if (onFootData[PR_surfingOffsets][0] != onFootData[PR_surfingOffsets][0] || onFootData[PR_surfingOffsets][1] != onFootData[PR_surfingOffsets][1] || onFootData[PR_surfingOffsets][2] != onFootData[PR_surfingOffsets][2]) {
        onFootData[PR_surfingOffsets][0] = onFootData[PR_surfingOffsets][1] = onFootData[PR_surfingOffsets][2] = 0.0;
    }
    if (!IsPlayerHaveWeapon(playerid, onFootData[PR_weaponId])) {
        //ResetPlayerWeaponsEx(playerid);
        return 0;
    }
    if ((onFootData[PR_quaternion][0] == 50.00) && (onFootData[PR_quaternion][1] == -50.00) && (onFootData[PR_quaternion][2] == 50.00) && (onFootData[PR_quaternion][3] == 50.00)) return 0;
    if ((onFootData[PR_velocity][0] == 0.00) && (onFootData[PR_velocity][1] == -50.00) && (onFootData[PR_velocity][2] == 0.10)) return 0;
    if (GetPlayerHealthEx(playerid) <= 0) return 0;

    ProcessDisabledKeys(playerid, onFootData[PR_lrKey], onFootData[PR_udKey], onFootData[PR_keys]);
    BS_SetWriteOffset(bs, 8);
    BS_WriteOnFootSync(bs, onFootData); // rewrite
    return 1;
}
IPacket:VEHICLE_SYNC(playerid, BitStream:bs) {
    new inCarData[PR_InCarSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, inCarData);

    if (isDebugAllowed) printf("Debug:VEHICLE_SYNC[%d]: vehicleId %d  lrKey %d  udKey %d  keys %d  quaternion %.2f %.2f %.2f %.2f  position %.2f %.2f %.2f  velocity %.2f %.2f %.2f  vehicleHealth %.2f  playerHealth %d  armour %d  additionalKey %d  weaponId %d  sirenState %d  landingGearState %d  trailerId %d  trainSpeed %.2f",
        playerid,
        inCarData[PR_vehicleId],
        inCarData[PR_lrKey],
        inCarData[PR_udKey],
        inCarData[PR_keys],
        inCarData[PR_quaternion][0],
        inCarData[PR_quaternion][1],
        inCarData[PR_quaternion][2],
        inCarData[PR_quaternion][3],
        inCarData[PR_position][0],
        inCarData[PR_position][1],
        inCarData[PR_position][2],
        inCarData[PR_velocity][0],
        inCarData[PR_velocity][1],
        inCarData[PR_velocity][2],
        inCarData[PR_vehicleHealth],
        inCarData[PR_playerHealth],
        inCarData[PR_armour],
        inCarData[PR_additionalKey],
        inCarData[PR_weaponId],
        inCarData[PR_sirenState],
        inCarData[PR_landingGearState],
        inCarData[PR_trailerId],
        inCarData[PR_trainSpeed]
    );

    if ((inCarData[PR_velocity][0] == 0.00) && (inCarData[PR_velocity][1] == -90.00) && (inCarData[PR_velocity][2] == 0.10)) return 0;
    ProcessDisabledKeys(playerid, inCarData[PR_lrKey], inCarData[PR_udKey], inCarData[PR_keys]);
    BS_SetWriteOffset(bs, 8);
    BS_WriteInCarSync(bs, inCarData);
    return 1;
}
IPacket:PASSENGER_SYNC(playerid, BitStream:bs) {
    new passengerData[PR_PassengerSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadPassengerSync(bs, passengerData);

    if (isDebugAllowed) printf("Debug:PASSENGER_SYNC[%d]: vehicleId %d  driveBy %d  seatId %d  additionalKey %d  weaponId %d  playerHealth %d  playerArmour %d  lrKey %d  udKey %d  keys %d  position %.2f %.2f %.2f",
        playerid,
        passengerData[PR_vehicleId],
        passengerData[PR_driveBy],
        passengerData[PR_seatId],
        passengerData[PR_additionalKey],
        passengerData[PR_weaponId],
        passengerData[PR_playerHealth],
        passengerData[PR_playerArmour],
        passengerData[PR_lrKey],
        passengerData[PR_udKey],
        passengerData[PR_keys],
        passengerData[PR_position][0],
        passengerData[PR_position][1],
        passengerData[PR_position][2]
    );

    if (IsValidVehicle(passengerData[PR_vehicleId])) {
        new Max_Seat = GetVehicleSeats(passengerData[PR_vehicleId]);
        if (passengerData[PR_seatId] < 0 || passengerData[PR_seatId] > Max_Seat) return 0;
    }
    ProcessDisabledKeys(playerid, passengerData[PR_lrKey], passengerData[PR_udKey], passengerData[PR_keys]);
    BS_SetWriteOffset(bs, 8);
    BS_WritePassengerSync(bs, passengerData);
    return 1;
}
IPacket:TRAILER_SYNC(playerid, BitStream:bs) {
    new trailerData[PR_TrailerSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadTrailerSync(bs, trailerData);

    if (isDebugAllowed) printf("Debug:TRAILER_SYNC[%d]: trailerId %d  position %.2f %.2f %.2f  quaternion %.2f %.2f %.2f %.2f  velocity %.2f %.2f %.2f  angularVelocity %.2f %.2f %.2f",
        playerid,
        trailerData[PR_trailerId],
        trailerData[PR_position][0],
        trailerData[PR_position][1],
        trailerData[PR_position][2],
        trailerData[PR_quaternion][0],
        trailerData[PR_quaternion][1],
        trailerData[PR_quaternion][2],
        trailerData[PR_quaternion][3],
        trailerData[PR_velocity][0],
        trailerData[PR_velocity][1],
        trailerData[PR_velocity][2],
        trailerData[PR_angularVelocity][0],
        trailerData[PR_angularVelocity][1],
        trailerData[PR_angularVelocity][2]
    );
    return 1;
}
IPacket:SPECTATING_SYNC(playerid, BitStream:bs) {
    new spectatingData[PR_SpectatingSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadSpectatingSync(bs, spectatingData);
    ProcessDisabledKeys(playerid, spectatingData[PR_lrKey], spectatingData[PR_udKey], spectatingData[PR_keys]);
    BS_SetWriteOffset(bs, 8);
    BS_WriteSpectatingSync(bs, spectatingData);
    return 1;
}

IPacket:UNOCCUPIED_SYNC(playerid, BitStream:bs) {
    new unoccupiedData[PR_UnoccupiedSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadUnoccupiedSync(bs, unoccupiedData);

    if (isDebugAllowed) printf("Debug:UNOCCUPIED_SYNC[%d]: vehicleId %d  seatId %d  roll %.2f %.2f %.2f  direction %.2f %.2f %.2f  position %.2f %.2f %.2f  velocity %.2f %.2f %.2f  angularVelocity %.2f %.2f %.2f  vehicleHealth %.2f",
        playerid,
        unoccupiedData[PR_vehicleId],
        unoccupiedData[PR_seatId],
        unoccupiedData[PR_roll][0],
        unoccupiedData[PR_roll][1],
        unoccupiedData[PR_roll][2],
        unoccupiedData[PR_direction][0],
        unoccupiedData[PR_direction][1],
        unoccupiedData[PR_direction][2],
        unoccupiedData[PR_position][0],
        unoccupiedData[PR_position][1],
        unoccupiedData[PR_position][2],
        unoccupiedData[PR_velocity][0],
        unoccupiedData[PR_velocity][1],
        unoccupiedData[PR_velocity][2],
        unoccupiedData[PR_angularVelocity][0],
        unoccupiedData[PR_angularVelocity][1],
        unoccupiedData[PR_angularVelocity][2],
        unoccupiedData[PR_vehicleHealth]
    );

    if (floatcmp(floatabs(unoccupiedData[PR_roll][0]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_roll][1]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_roll][2]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_direction][0]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_direction][1]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_direction][2]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_position][0]), 20000.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_position][1]), 20000.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_position][2]), 20000.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_angularVelocity][0]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_angularVelocity][1]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_angularVelocity][2]), 1.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_velocity][0]), 100.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_velocity][1]), 100.00000) == 1 ||
        floatcmp(floatabs(unoccupiedData[PR_velocity][2]), 100.00000) == 1
    ) {
        return 0;
    }
    if ((unoccupiedData[PR_roll][0] == unoccupiedData[PR_direction][0]) &&
        (unoccupiedData[PR_roll][1] == unoccupiedData[PR_direction][1]) &&
        (unoccupiedData[PR_roll][2] == unoccupiedData[PR_direction][2])
    ) {
        return 0; // ignore bad packet
    }
    return 1;
}
IPacket:AIM_SYNC(playerid, BitStream:bs) {
    new aimData[PR_AimSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadAimSync(bs, aimData);

    if (isDebugAllowed) printf("Debug:AIM_SYNC[%d]: camMode %d  camFrontVec %.2f %.2f %.2f  camPos %.2f %.2f %.2f  aimZ %.2f  weaponState %d  camZoom %d  aspectRatio %d",
        playerid,
        aimData[PR_camMode],
        aimData[PR_camFrontVec][0],
        aimData[PR_camFrontVec][1],
        aimData[PR_camFrontVec][2],
        aimData[PR_camPos][0],
        aimData[PR_camPos][1],
        aimData[PR_camPos][2],
        aimData[PR_aimZ],
        aimData[PR_weaponState],
        aimData[PR_camZoom],
        aimData[PR_aspectRatio]
    );

    if (aimData[PR_aimZ] != aimData[PR_aimZ]) // is NaN
    {
        aimData[PR_aimZ] = 0.0;
        BS_SetWriteOffset(bs, 8);
        BS_WriteAimSync(bs, aimData);
    }

    return 1;
}
IPacket:BULLET_SYNC(playerid, BitStream:bs) {
    new bulletData[PR_BulletSync];
    BS_IgnoreBits(bs, 8);
    BS_ReadBulletSync(bs, bulletData);

    if (isDebugAllowed) printf("Debug:BULLET_SYNC[%d]: hitType %d  hitId %d  origin %.2f %.2f %.2f  hitPos %.2f %.2f %.2f  offsets %.2f %.2f %.2f  weaponId %d",
        playerid,
        bulletData[PR_hitType],
        bulletData[PR_hitId],
        bulletData[PR_origin][0],
        bulletData[PR_origin][1],
        bulletData[PR_origin][2],
        bulletData[PR_hitPos][0],
        bulletData[PR_hitPos][1],
        bulletData[PR_hitPos][2],
        bulletData[PR_offsets][0],
        bulletData[PR_offsets][1],
        bulletData[PR_offsets][2],
        bulletData[PR_weaponId]
    );

    if (!IsPlayerHaveWeapon(playerid, bulletData[PR_weaponId])) return 0;
    return 1;
}
enum PR_OnGiveTake {
    bool:Pr_bGiveOrTake,
    Pr_wPlayerID,
    Float:Pr_damage_amount,
    Pr_dWeaponID,
    Pr_dBodypart
};

stock BS_ReadGiveOrTake(BitStream:bs, data[PR_OnGiveTake]) {
    BS_ReadValue(
        bs,
        PR_BOOL, data[Pr_bGiveOrTake],
        PR_UINT16, data[Pr_wPlayerID],
        PR_FLOAT, data[Pr_damage_amount],
        PR_UINT32, data[Pr_dWeaponID],
        PR_UINT32, data[Pr_dBodypart]
    );
}

IRPC:GiveOrTake(playerid, BitStream:bs) {
    new data[PR_OnGiveTake];
    BS_ReadGiveOrTake(bs, data);

    if (isDebugAllowed) printf(
        "GiveOrTake[%d], bGiveOrTake: %d, wPlayerID: %d, damage_amount: %f, dWeaponID: %d, dBodypart: %d",
        playerid,
        data[Pr_bGiveOrTake],
        data[Pr_wPlayerID],
        data[Pr_damage_amount],
        data[Pr_dWeaponID],
        data[Pr_dBodypart]
    );

    if (IsPlayerConnected(data[Pr_wPlayerID])) {
        if (IsPlayerStreamedIn(playerid, data[Pr_wPlayerID]) && IsPlayerStreamedIn(data[Pr_wPlayerID], playerid)) return 0;
    }
    if (data[Pr_damage_amount] < 0.0 || data[Pr_dBodypart] < 3 || data[Pr_dBodypart] > 9) return 0;
    return 1;
}

enum PR_EnterVehicle {
    PR_wVehicleID,
    PR_bIsPassenger
};

stock BS_ReadEnterVehicle(BitStream:bs, data[PR_EnterVehicle]) {
    BS_ReadValue(
        bs,
        PR_UINT16, data[PR_wVehicleID],
        PR_UINT8, data[PR_bIsPassenger]
    );
}

IRPC:EnterVehicle(playerid, BitStream:bs) {
    new data[PR_EnterVehicle];
    BS_ReadEnterVehicle(bs, data);
    if (!IsValidVehicle(data[PR_wVehicleID]) || !IsVehicleStreamedIn(data[PR_wVehicleID], playerid)) return 0;
    return 1;
}

enum PR_ExitVehicle {
    PR_wVehicleID
};

stock BS_ReadExitVehicle(BitStream:bs, data[PR_ExitVehicle]) {
    BS_ReadValue(
        bs,
        PR_UINT16, data[PR_wVehicleID]
    );
}

IRPC:ExitVehicle(playerid, BitStream:bs) {
    new data[PR_ExitVehicle];
    BS_ReadExitVehicle(bs, data);
    if (!IsValidVehicle(data[PR_wVehicleID]) || !IsVehicleStreamedIn(data[PR_wVehicleID], playerid)) return 0;
    return 1;
}

enum PR_OnPlayerEditAttachedObject {
    PR_response,
    PR_index,
    PR_model,
    PR_bone,
    Float:PR_positionX,
    Float:PR_positionY,
    Float:PR_positionZ,
    Float:PR_rotationX,
    Float:PR_rotationY,
    Float:PR_rotationZ,
    Float:PR_scaleX,
    Float:PR_scaleY,
    Float:PR_scaleZ,
    PR_color1,
    PR_color2
};

stock BS_ReadOnPlayerEditAttachedObj(BitStream:bs, data[PR_OnPlayerEditAttachedObject]) {
    BS_ReadValue(
        bs,
        PR_UINT32, data[PR_response],
        PR_UINT32, data[PR_index],
        PR_UINT32, data[PR_model],
        PR_UINT32, data[PR_bone],
        PR_FLOAT, data[PR_positionX],
        PR_FLOAT, data[PR_positionY],
        PR_FLOAT, data[PR_positionZ],
        PR_FLOAT, data[PR_rotationX],
        PR_FLOAT, data[PR_rotationY],
        PR_FLOAT, data[PR_rotationZ],
        PR_FLOAT, data[PR_scaleX],
        PR_FLOAT, data[PR_scaleY],
        PR_FLOAT, data[PR_scaleZ],
        PR_INT32, data[PR_color1],
        PR_INT32, data[PR_color2]
    );
}

IRPC:PlayerEditAttachedObject(playerid, BitStream:bs) {
    new data[PR_OnPlayerEditAttachedObject];
    BS_ReadOnPlayerEditAttachedObj(bs, data);
    if (data[PR_index] < 0 || data[PR_index] > 9) return 0;
    return 1;
}


enum PR_SendDialogResponse {
    PR_wDialogID,
    PR_bResponse,
    PR_wListItem,
    PR_bTextLength,
    PR_Text[256],
};

stock BS_ReadSendDialogResponse(BitStream:bs, data[PR_SendDialogResponse]) {
    BS_ReadValue(
        bs,
        PR_UINT16, data[PR_wDialogID],
        PR_UINT8, data[PR_bResponse],
        PR_UINT16, data[PR_wListItem],
        PR_UINT8, data[PR_bTextLength],
        PR_STRING, data[PR_Text]
    );
}

IRPC:SendDialogResponse(playerid, BitStream:bs) {
    new data[PR_SendDialogResponse];
    BS_ReadSendDialogResponse(bs, data);
    return 1;
}

public OnIncomingPacket(playerid, packetid, BitStream:bs) {
    return 1;
}
public OnIncomingRPC(playerid, rpcid, BitStream:bs) {
    return 1;

}
public OnOutgoingPacket(playerid, packetid, BitStream:bs) {
    return 1;

}
public OnOutgoingRPC(playerid, rpcid, BitStream:bs) {
    return 1;
}