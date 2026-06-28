#define ZONE_MARK_INTERVAL 5000
new a69_PlayerMarker[MAX_PLAYERS];
new Text3D:a69_MarkerText[MAX_PLAYERS];
new a69_TimerPlayerZoneMark;

hook OnGameModeInit() {
    for (new i = 0; i < MAX_PLAYERS; ++i) {
        a69_PlayerMarker[i] = -1;
    }
    a69_TimerPlayerZoneMark = SetTimer("update_player_zone_mark", ZONE_MARK_INTERVAL, true);
    return 1;
}

hook OnGameModeExit() {
    KillTimer(a69_TimerPlayerZoneMark);

    for (new i = 0; i < MAX_PLAYERS; ++i) {
        if (a69_PlayerMarker[i] != -1) {
            DestroyDynamicObjectEx(a69_PlayerMarker[i]);
            a69_PlayerMarker[i] = -1;
            if (!IsPlayerNPC(i)) {
                if (IsValidDynamic3DTextLabel(a69_MarkerText[i]))
                    DestroyDynamic3DTextLabel(a69_MarkerText[i]);
            }
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (a69_PlayerMarker[playerid] != -1) {
        DestroyDynamicObjectEx(a69_PlayerMarker[playerid]);
        a69_PlayerMarker[playerid] = -1;
        if (!IsPlayerNPC(playerid))
            if (IsValidDynamic3DTextLabel(a69_MarkerText[playerid]))
                DestroyDynamic3DTextLabel(a69_MarkerText[playerid]);
    }

    return 1;
}

forward update_player_zone_mark();
public update_player_zone_mark() {
    new i, j, col, Float:height;
    new Float:x, Float:y, Float:z;
    new Float:x0, Float:y0, Float:z0, Float:path, Float:speed;
    new name[64];
    static Float:MarkerXY[MAX_PLAYERS][2];

    foreach(i: Player) {
        if (IsPlayerConnected(i)) {
            strdel(name, 0, sizeof(name) - 1);
            GetPlayerName(i, name, sizeof(name));
            col = GetPlayerColor(i);
            GetPlayerPos(i, x, y, z);

            if (x > 3000.0) x = 3000.0;
            if (x < -3000.0) x = -3000.0;
            if (y > 3000.0) y = 3000.0;
            if (y < -3000.0) y = -3000.0;

            for (j = 0, height = 0.0; j < i; ++j) {
                if (IsPlayerInRangeOfPoint(j, 200, x, y, z))
                    height = floatadd(height, 0.04);
            }

            col = (col >> 8) | (0xFF000000);
            y = floatsub(221.7, floatmul(3.45, floatdiv(floatadd(3000.0, y), 6000.0)));
            x = floatadd(1821.1, floatmul(3.45, floatdiv(floatadd(3000.0, x), 6000.0)));

            if (a69_PlayerMarker[i] != -1) {
                GetDynamicObjectPos(a69_PlayerMarker[i], y0, x0, z0);
                path = VectorSize(y0 - y, x0 - x, 0);
                speed = floatdiv(path, floatdiv(ZONE_MARK_INTERVAL, 1200.0));

                if (IsPlayerNPC(i))
                    MoveDynamicObject(a69_PlayerMarker[i], y, x, 6.81, speed);
                else {
                    MoveDynamicObject(a69_PlayerMarker[i], y, x, 7.41, speed);
                    if (VectorSize(MarkerXY[i][0] - x, MarkerXY[i][1] - y, 0) > 0.03) {
                        if (IsValidDynamic3DTextLabel(a69_MarkerText[i]))
                            DestroyDynamic3DTextLabel(a69_MarkerText[i]);
                        a69_MarkerText[i] = CreateDynamic3DTextLabel(name, GetPlayerColor(i), y, x, floatadd(7.51, height), 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
                        MarkerXY[i][0] = x;
                        MarkerXY[i][1] = y;
                    }
                }
            } else {
                if (IsPlayerNPC(i))
                    a69_PlayerMarker[i] = CreateDynamicObject(2590, y, x, 6.81, 0, 0, 0);
                else {
                    a69_PlayerMarker[i] = CreateDynamicObject(2590, y, x, 7.41, 0, 0, 0);
                    a69_MarkerText[i] = CreateDynamic3DTextLabel(name, GetPlayerColor(i), y, x, floatadd(7.51, height), 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
                }
                if (a69_PlayerMarker[i] != -1)
                    SetDynamicObjectMaterial(a69_PlayerMarker[i], 0, 10770, "carrier_sfse", "ws_shipmetal4", col);
            }
        }
    }
    return 1;
}