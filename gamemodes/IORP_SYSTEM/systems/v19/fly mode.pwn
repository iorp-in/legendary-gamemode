// Default Move Speed
#define MOVE_SPEED              100.0
#define ACCEL_RATE              0.03
#define ACCEL_MODE              true
// Players Mode
#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1
// Key state definitions
#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8
// Enumeration for storing data about the player
enum noclipenum {
    cameramode,
    flyobject,
    mode,
    lrold,
    udold,
    lastmove,
    Float:accelmul,
    Float:accelrate,
    Float:maxspeed,
    bool:accel,
    nskin_id
}
new noclipdata[MAX_PLAYERS][noclipenum];
new noclipweapondata[MAX_PLAYERS][13][2];
new bool:FlyMode[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    // Reset the data belonging to this player slot
    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
    noclipdata[playerid][lrold] = 0;
    noclipdata[playerid][udold] = 0;
    noclipdata[playerid][mode] = 0;
    noclipdata[playerid][lastmove] = 0;
    noclipdata[playerid][accelmul] = 0.0;
    noclipdata[playerid][accel] = ACCEL_MODE;
    noclipdata[playerid][accelrate] = ACCEL_RATE;
    noclipdata[playerid][maxspeed] = MOVE_SPEED;
    FlyMode[playerid] = false;
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    if (noclipdata[playerid][cameramode] == CAMERA_MODE_FLY) {
        new keys, ud, lr;
        GetPlayerKeys(playerid, keys, ud, lr);
        if (noclipdata[playerid][mode] && (GetTickCount() - noclipdata[playerid][lastmove] > 100)) MoveCamera(playerid);
        // Is the players current key state different than their last keystate?
        if (noclipdata[playerid][udold] != ud || noclipdata[playerid][lrold] != lr) {
            if ((noclipdata[playerid][udold] != 0 || noclipdata[playerid][lrold] != 0) && ud == 0 && lr == 0) { // All keys have been released, stop the object the camera is attached to and reset the acceleration multiplier
                StopPlayerObject(playerid, noclipdata[playerid][flyobject]);
                noclipdata[playerid][mode] = 0;
                noclipdata[playerid][accelmul] = 0.0;
            } else { // Indicates a new key has been pressed
                // Get the direction the player wants to move as indicated by the keys
                noclipdata[playerid][mode] = GetMoveDirectionFromKeys(ud, lr);
                // Process moving the object the players camera is attached to
                MoveCamera(playerid);
            }
        }
        noclipdata[playerid][udold] = ud;
        noclipdata[playerid][lrold] = lr; // Store current keys pressed for comparison next update
        return 0;
    }
    return 1;
}
stock GetMoveDirectionFromKeys(ud, lr) {
    new direction = 0;
    if (lr < 0) {
        if (ud < 0) direction = MOVE_FORWARD_LEFT; // Up & Left key pressed
        else if (ud > 0) direction = MOVE_BACK_LEFT; // Back & Left key pressed
        else direction = MOVE_LEFT; // Left key pressed
    } else if (lr > 0) // Right pressed
    {
        if (ud < 0) direction = MOVE_FORWARD_RIGHT; // Up & Right key pressed
        else if (ud > 0) direction = MOVE_BACK_RIGHT; // Back & Right key pressed
        else direction = MOVE_RIGHT; // Right key pressed
    } else if (ud < 0) direction = MOVE_FORWARD; // Up key pressed
    else if (ud > 0) direction = MOVE_BACK; // Down key pressed
    return direction;
}
stock MoveCamera(playerid) {
    new Float:FV[3], Float:CP[3];
    //GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);          // 	Cameras position in space
    GetPlayerObjectPos(playerid, noclipdata[playerid][flyobject], CP[0], CP[1], CP[2]); // 	Cameras position in space
    GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]); //  Where the camera is looking at
    // Increases the acceleration multiplier the longer the key is held
    if (noclipdata[playerid][accelmul] <= 1.0) noclipdata[playerid][accelmul] += noclipdata[playerid][accelrate];
    // Determine the speed to move the camera based on the acceleration multiplier
    new Float:speed = noclipdata[playerid][maxspeed] * (noclipdata[playerid][accel] ? noclipdata[playerid][accelmul] : 1.0);
    // Calculate the cameras next position based on their current position and the direction their camera is facing
    new Float:X, Float:Y, Float:Z;
    GetNextCameraPosition(noclipdata[playerid][mode], CP, FV, X, Y, Z);
    MovePlayerObject(playerid, noclipdata[playerid][flyobject], X, Y, Z, speed);
    //SendClientMessageEx(playerid, -1, sprintf("(%0.1f, %0.1f, %0.1f) - (%0.1f, %0.1f, %0.1f) - (%0.1f, %0.1f, %0.1f)", CP[0], CP[1], CP[2], FV[0], FV[1], FV[2], X, Y, Z));
    // Store the last time the camera was moved as now
    noclipdata[playerid][lastmove] = GetTickCount();
    return 1;
}
stock SetFlyModePos(playerid, Float:x, Float:y, Float:z) {
    if (FlyMode[playerid]) {
        SetPlayerObjectPos(playerid, noclipdata[playerid][flyobject], x, y, z);
        noclipdata[playerid][lastmove] = GetTickCount();
        return 1;
    }
    return 0;
}
stock GetFlyModePos(playerid, & Float:x, & Float:y, & Float:z) {
    if (FlyMode[playerid]) {
        GetPlayerObjectPos(playerid, noclipdata[playerid][flyobject], x, y, z);
        return 1;
    }
    return 0;
}
stock GetNextCameraPosition(move_mode, const Float:CP[3], const Float:FV[3], & Float:X, & Float:Y, & Float:Z) {
    // Calculate the cameras next position based on their current position and the direction their camera is facing
    #define OFFSET_X (FV[0]*6000.0)
    #define OFFSET_Y (FV[1]*6000.0)
    #define OFFSET_Z (FV[2]*6000.0)
    switch (move_mode) {
        case MOVE_FORWARD: {
            X = CP[0] + OFFSET_X;
            Y = CP[1] + OFFSET_Y;
            Z = CP[2] + OFFSET_Z;
        }
        case MOVE_BACK: {
            X = CP[0] - OFFSET_X;
            Y = CP[1] - OFFSET_Y;
            Z = CP[2] - OFFSET_Z;
        }
        case MOVE_LEFT: {
            X = CP[0] - OFFSET_Y;
            Y = CP[1] + OFFSET_X;
            Z = CP[2];
        }
        case MOVE_RIGHT: {
            X = CP[0] + OFFSET_Y;
            Y = CP[1] - OFFSET_X;
            Z = CP[2];
        }
        case MOVE_BACK_LEFT: {
            X = CP[0] + (-OFFSET_X - OFFSET_Y);
            Y = CP[1] + (-OFFSET_Y + OFFSET_X);
            Z = CP[2] - OFFSET_Z;
        }
        case MOVE_BACK_RIGHT: {
            X = CP[0] + (-OFFSET_X + OFFSET_Y);
            Y = CP[1] + (-OFFSET_Y - OFFSET_X);
            Z = CP[2] - OFFSET_Z;
        }
        case MOVE_FORWARD_LEFT: {
            X = CP[0] + (OFFSET_X - OFFSET_Y);
            Y = CP[1] + (OFFSET_Y + OFFSET_X);
            Z = CP[2] + OFFSET_Z;
        }
        case MOVE_FORWARD_RIGHT: {
            X = CP[0] + (OFFSET_X + OFFSET_Y);
            Y = CP[1] + (OFFSET_Y - OFFSET_X);
            Z = CP[2] + OFFSET_Z;
        }
    }
}
new Float:Fly_Player_Pos[MAX_PLAYERS][3];
stock CancelFlyMode(playerid) {
    GetPlayerCameraPos(playerid, Fly_Player_Pos[playerid][0], Fly_Player_Pos[playerid][1], Fly_Player_Pos[playerid][2]);
    TogglePlayerSpectatingEx(playerid, false);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if (!FlyMode[playerid]) return 1;
    SetPlayerPosEx(playerid, Fly_Player_Pos[playerid][0], Fly_Player_Pos[playerid][1], Fly_Player_Pos[playerid][2]);
    SetPlayerSkinEx(playerid, noclipdata[playerid][nskin_id]);
    FlyMode[playerid] = false;
    CancelEdit(playerid);
    DestroyPlayerObject(playerid, noclipdata[playerid][flyobject]);
    noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
    for (new i = 0; i <= 12; i++) GivePlayerWeaponEx(playerid, noclipweapondata[playerid][i][0], noclipweapondata[playerid][i][1]);
    return 1;
}
stock StartFlyMode(playerid) {
    noclipdata[playerid][nskin_id] = GetPlayerSkin(playerid);
    for (new i = 0; i <= 12; i++) GetPlayerWeaponData(playerid, i, noclipweapondata[playerid][i][0], noclipweapondata[playerid][i][1]);

    // Create an invisible object for the players camera to be attached to
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    noclipdata[playerid][flyobject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);
    // Place the player in spectating mode so objects will be streamed based on camera location
    TogglePlayerSpectatingEx(playerid, true);
    // Attach the players camera to the created object
    AttachCameraToPlayerObject(playerid, noclipdata[playerid][flyobject]);
    FlyMode[playerid] = true;
    noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
    return 1;
}
CMD:flyhelp(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    SendClientMessageEx(playerid, -1, "/flymode - to activate flymode");
    SendClientMessageEx(playerid, -1, "/fmspeed - set camera speed");
    SendClientMessageEx(playerid, -1, "/fmaccel - set camera accelate speed");
    SendClientMessageEx(playerid, -1, "/fmtoggle - toggle acceleration");
    SendClientMessageEx(playerid, -1, "/camsave - save camera positions");
    return 1;
}
CMD:flymode(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    // Place the player in and out of edit mode
    if (FlyMode[playerid]) CancelFlyMode(playerid);
    else StartFlyMode(playerid);
    return 1;
}
CMD:fmspeed(playerid, arg[], help) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    new Float:newspeed;
    sscanf(arg, "F(-1.0)", newspeed);
    if (newspeed == -1.0)
        newspeed = MOVE_SPEED;
    else if (newspeed < 5.0)
        newspeed = 5.0;
    else if (newspeed > 200.0)
        newspeed = 200.0;
    noclipdata[playerid][maxspeed] = newspeed;
    SendClientMessageEx(playerid, -1, sprintf("Flymode max speed set to %0.2f", newspeed));
    return 1;
}
CMD:fmaccel(playerid, arg[], help) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    new Float:newacc;
    sscanf(arg, "F(-1.0)", newacc);
    if (newacc == -1.0)
        newacc = ACCEL_RATE;
    else if (newacc < 0.005)
        newacc = 0.005;
    else if (newacc > 0.05)
        newacc = 0.05;
    noclipdata[playerid][accelrate] = newacc;
    SendClientMessageEx(playerid, -1, sprintf("Flymode max speed set to %0.3f", newacc));
    return 1;
}
CMD:fmtoggle(playerid, arg[], help) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    noclipdata[playerid][accel] = !noclipdata[playerid][accel];
    SendClientMessageEx(playerid, -1, sprintf("Flymode acceleration toggled %s", noclipdata[playerid][accel] ? ("on") : ("off")));
    return 1;
}
CMD:camsave(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    const Float:fScale = 5.0;
    new Float:fPX, Float:fPY, Float:fPZ, Float:fVX, Float:fVY, Float:fVZ;
    GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
    GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
    new Float:object_x = fPX + floatmul(fVX, fScale);
    new Float:object_y = fPY + floatmul(fVY, fScale);
    new Float:object_z = fPZ + floatmul(fVZ, fScale);
    SendClientMessageEx(playerid, -1, sprintf("//Camera Postition"));
    SendClientMessageEx(playerid, -1, sprintf("GetPlayerCameraPos: %f, %f, %f", fPX, fPY, fPZ));
    SendClientMessageEx(playerid, -1, sprintf("InterpolateCameraLookAt: %f, %f, %f", object_x, object_y, object_z));
    return 1;
}