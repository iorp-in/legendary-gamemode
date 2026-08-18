//** fs by newman303
#define POWER1 0.07//0.08//** Высота прыжка
#define POWER2 0.08//0.16//** Ускорение

new LegalCars[] = { 402, 415, 424, 434, 444, 468, 475, 502, 541, 542, 545, 576, 603 }; //** Список авто

forward DragGetPlayerSpeed(playerid);
public DragGetPlayerSpeed(playerid) {
    new Float:Coord[4];
    if (IsPlayerInAnyVehicle(playerid)) {
        GetVehicleVelocity(GetPlayerVehicleID(playerid), Coord[0], Coord[1], Coord[2]);
    } else {
        GetPlayerVelocity(playerid, Coord[0], Coord[1], Coord[2]);
    }
    Coord[3] = floatsqroot(floatpower(floatabs(Coord[0]), 2.0) + floatpower(floatabs(Coord[1]), 2.0) + floatpower(floatabs(Coord[2]), 2.0)) * 213.3;
    return floatround(Coord[3]);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if ((newkeys == 8) && (oldkeys == 40)) {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:vel[3], Float:rot;
        for (new i = 0; i < sizeof(LegalCars); i++) {
            if (LegalCars[i] == GetVehicleModel(vehicleid)) {
                GetVehicleVelocity(vehicleid, vel[0], vel[1], vel[2]);
                GetVehicleZAngle(vehicleid, rot);
                if (DragGetPlayerSpeed(playerid) < 3) //** максимальная стартовая скорость
                {
                    SetVehicleAngularVelocity(vehicleid, \
                        (floatcos(rot, degrees) * POWER1), \
                        (floatsin(rot, degrees) * POWER1), 0);

                    rot += 90.0;

                    SetVehicleVelocity(vehicleid, \
                        (floatcos(rot, degrees) * POWER2) + vel[0], \
                        (floatsin(rot, degrees) * POWER2) + vel[1], vel[2]);
                }
                break;
            }
        }
    }
    return 1;
}