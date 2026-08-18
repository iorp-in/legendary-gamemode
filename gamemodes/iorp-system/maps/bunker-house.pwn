#define MAX_DOORS 10
#define ELEV_MOVEDOOR_SPEED 10.0
#define ELEV_MOVECAGE_SPEED 5.0
#define DOOR_MOVE_SPEED 10.0
#define INVALID_DOOR_ID -1
#define PRESSED(%0) (newkeys & %0 == %0 && oldkeys & %0 != %0 )

enum {
    ACTOR_ENTRY_GUARD,
    ACTOR_STAIRWAY_GUARD_1,
    ACTOR_STAIRWAY_GUARD_2,
    ACTOR_RECEPTION_GUARD_1,
    ACTOR_RECEPTION_GUARD_2,
    ACTOR_MECHANIC,
    ACTOR_HOMELESS,
    ACTOR_CAMERAMAN,
    ACTOR_VIP,
    ACTOR_CHEF,
    ACTOR_BARTENDER,
    ACTOR_FOREMAN,
    ACTOR_RECEPTIONIST,
    ACTOR_IT_SUPPORT,
    ACTOR_STYLIST,
    MAX_BUNKER_ACTORS
}

enum {
    ELEVSTATE_LOADING, // elevator not initiated / loading
    ELEVSTATE_CLOSE, // elevator close
    ELEVSTATE_OPEN, // elevator open
    ELEVSTATE_OPENING, // elevator opening
    ELEVSTATE_CLOSING, // elevator closing
    ELEVSTATE_MOVING_U, // elevator moving up
    ELEVSTATE_MOVING_D, // elevator moving down
}

enum {
    ELEVDOOR_INT_L, // left door (seen from outside of the elevator)
    ELEVDOOR_INT_R, // right door (seen from outside of the elevator)
    MAX_INT_ELEVDOORS
}

enum {
    ELEVFLOOR_T, // top floor
    ELEVFLOOR_B, // bottom floor
    MAX_ELEVFLOORS
}

enum {
    DOORSTATE_CLOSE,
    DOORSTATE_OPENING,
    DOORSTATE_OPEN,
    DOORSTATE_CLOSING
}

enum e_ElevData {
    e_ElevState,
    e_ElevFloor,
    e_ElevObj,
    e_ElevDynArea[MAX_ELEVFLOORS],
    e_ElevIntDoorObj[MAX_INT_ELEVDOORS],
    e_ElevExtDoorDynObj[MAX_ELEVFLOORS],
    e_ElevKeypadObj
}

enum e_DoorData {
    Float: e_DoorClosedZ,
    e_DoorDynObj,
    e_DoorDynArea,
    e_DoorState
}


new
g_DynamicObject[659],
    g_Vehicle[2],
    g_VehicleObject[2],
    g_DynamicActor[MAX_BUNKER_ACTORS],
    g_ElevData[e_ElevData],
    g_DoorData[MAX_DOORS][e_DoorData],
    g_DoorsInitiated,
    g_EntryArea,
    g_ExitArea,
    bool: g_EntryExitSkip[MAX_PLAYERS char];

// Renamed GetAttachedObjectPos (Original made by Stylock)
PositionFromOffset(
    Float: input_x,
    Float: input_y,
    Float: input_z,
    Float: input_rx,
    Float: input_ry,
    Float: input_rz,
    Float: offset_x,
    Float: offset_y,
    Float: offset_z, &
    Float: ret_x, &
    Float: ret_y, &
    Float: ret_z
) {
    new
    Float:cos_x = floatcos(input_rx, degrees),
        Float:cos_y = floatcos(input_ry, degrees),
        Float:cos_z = floatcos(input_rz, degrees),
        Float:sin_x = floatsin(input_rx, degrees),
        Float:sin_y = floatsin(input_ry, degrees),
        Float:sin_z = floatsin(input_rz, degrees);

    ret_x = input_x + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    ret_y = input_y + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    ret_z = input_z - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;
}

CreateEntryExits() {
    g_EntryArea = CreateDynamicSphere(-1584.0164, -2572.3108, 28.8232, 1.5);
    g_ExitArea = CreateDynamicSphere(-1578.0275, -2569.4412, 28.8323, 1.5);
}

DestroyEntryExits() {
    DestroyDynamicArea(g_EntryArea);
    DestroyDynamicArea(g_ExitArea);
}

Float:GetElevatorFloorZ(floor) {
    new Float:floor_z;

    switch (floor) {
        case ELEVFLOOR_T:  {
            floor_z = 29.7241;
        }
        case ELEVFLOOR_B:  {
            floor_z = -5.1000;
        }
    }
    return floor_z;
}

Float:GetElevatorExtDoorZ(floor, bool:closed) {
    new Float:door_z;

    switch (floor) {
        case ELEVFLOOR_T:  {
            door_z = 29.4552;
        }
        case ELEVFLOOR_B:  {
            door_z = -5.3646;
        }
    }

    if (!closed) {
        door_z += 2.8302;
    }

    return door_z;
}

CreateElevator() {
    g_ElevData[e_ElevFloor] = ELEVFLOOR_T;

    g_ElevData[e_ElevObj] = CreateObject(18755, -1568.7562, -2563.4519, GetElevatorFloorZ(g_ElevData[e_ElevFloor]), 0.0000, 0.0000, 31.0000);
    SetObjectMaterial(g_ElevData[e_ElevObj], 1, 2669, "cj_chris", "cj_metalplate2", 0x00000000);
    SetObjectMaterial(g_ElevData[e_ElevObj], 2, 16322, "a51_stores", "wtmetal3", 0xFF696969);
    SetObjectMaterial(g_ElevData[e_ElevObj], 4, 16640, "a51", "ventb128", 0x00000000);
    SetObjectMaterial(g_ElevData[e_ElevObj], 5, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    SetObjectMaterial(g_ElevData[e_ElevObj], 6, 6985, "vgnfremnt2", "striplightsyel_256", 0xFFD2691E);
    SetObjectMaterial(g_ElevData[e_ElevObj], 7, 16322, "a51_stores", "wtmetal3", 0xFF696969);

    g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_L] = CreateObject(18757, -1568.9073, -2563.4260, 29.7425, 0.0000, 0.0000, 33.5998);
    SetObjectMaterial(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_L], 1, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0x00000000);
    AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_L], g_ElevData[e_ElevObj], 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);

    g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_R] = CreateObject(18756, -1568.9150, -2563.4196, 29.7479, 0.0000, 0.0000, 33.4999);
    SetObjectMaterial(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_R], 1, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0x00000000);
    AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_R], g_ElevData[e_ElevObj], 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);

    g_ElevData[e_ElevExtDoorDynObj][ELEVFLOOR_T] = CreateDynamicObject(2957, -1570.5792, -2564.6025, 29.4552, 0.0000, 0.0000, -58.8997);
    SetDynamicObjectMaterial(g_ElevData[e_ElevExtDoorDynObj][ELEVFLOOR_T], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0xFFC0C0C0);

    g_ElevData[e_ElevExtDoorDynObj][ELEVFLOOR_B] = CreateDynamicObject(2957, -1570.7213, -2564.3854, -5.3646, 0.0000, 0.0000, -58.8997);
    SetDynamicObjectMaterial(g_ElevData[e_ElevExtDoorDynObj][ELEVFLOOR_B], 0, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0xFFC0C0C0);

    g_ElevData[e_ElevKeypadObj] = CreateObject(19273, -1569.5758, -2566.3840, 29.0475, 0.0000, 0.0000, -60.0998);
    AttachObjectToObject(g_ElevData[e_ElevKeypadObj], g_ElevData[e_ElevObj], -1.1598, -2.2197, -0.2799, 0.0000, 0.0000, 180.0000);

    new Float: elev_x, Float: elev_y, Float: elev_z;
    GetObjectPos(g_ElevData[e_ElevObj], elev_x, elev_y, elev_z);

    for (new floor; floor < MAX_ELEVFLOORS; floor++) {
        g_ElevData[e_ElevDynArea][floor] = CreateDynamicSphere(elev_x, elev_y, GetElevatorFloorZ(floor), 5.0);
    }

    g_ElevData[e_ElevState] = ELEVSTATE_OPENING;
    ApplyElevatorState();
}

DestroyElevator() {
    DestroyObject(g_ElevData[e_ElevObj]);

    for (new d; d < MAX_INT_ELEVDOORS; d++) {
        DestroyObject(g_ElevData[e_ElevIntDoorObj][d]);
    }

    for (new f; f < MAX_ELEVFLOORS; f++) {
        DestroyDynamicObjectEx(g_ElevData[e_ElevExtDoorDynObj][f]);
    }

    DestroyObject(g_ElevData[e_ElevKeypadObj]);

    for (new f; f < MAX_ELEVFLOORS; f++) {
        DestroyDynamicArea(g_ElevData[e_ElevDynArea][f]);
    }
}

ApplyElevatorState() {
    switch (g_ElevData[e_ElevState]) {
        case ELEVSTATE_CLOSE:  {
            AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_L], g_ElevData[e_ElevObj], 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);
            AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_R], g_ElevData[e_ElevObj], 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);
        }
        case ELEVSTATE_CLOSING:  {
            new
            floor = g_ElevData[e_ElevFloor],
                Float:x,
                Float:y,
                Float:z;

            GetDynamicObjectPos(g_ElevData[e_ElevExtDoorDynObj][floor], x, y, z);
            MoveDynamicObject(g_ElevData[e_ElevExtDoorDynObj][floor], x, y, GetElevatorExtDoorZ(floor, .closed = true), ELEV_MOVEDOOR_SPEED);
        }
        case ELEVSTATE_OPENING:  {
            AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_R], g_ElevData[e_ElevObj], 0.0000, -1.8, 0.0000, 0.0000, 0.0000, 0.0000);
            AttachObjectToObject(g_ElevData[e_ElevIntDoorObj][ELEVDOOR_INT_L], g_ElevData[e_ElevObj], 0.0000, 1.8, 0.0000, 0.0000, 0.0000, 0.0000);

            new
            floor = g_ElevData[e_ElevFloor],
                Float:x,
                Float:y,
                Float:z;

            GetDynamicObjectPos(g_ElevData[e_ElevExtDoorDynObj][floor], x, y, z);
            MoveDynamicObject(g_ElevData[e_ElevExtDoorDynObj][floor], x, y, GetElevatorExtDoorZ(floor, .closed = false), ELEV_MOVEDOOR_SPEED);
        }
        case ELEVSTATE_OPEN:  {

        }
        case ELEVSTATE_MOVING_D:  {
            new
            Float: x,
            Float: y,
            Float: z,
            Float: rx,
            Float: ry,
            Float: rz
            ;

            GetObjectPos(g_ElevData[e_ElevObj], x, y, z);
            GetObjectRot(g_ElevData[e_ElevObj], rx, ry, rz);

            MoveObject(g_ElevData[e_ElevObj], x, y, GetElevatorFloorZ(ELEVFLOOR_B), ELEV_MOVECAGE_SPEED, rx, ry, rz);
        }
        case ELEVSTATE_MOVING_U:  {
            new
            Float: x,
            Float: y,
            Float: z,
            Float: rx,
            Float: ry,
            Float: rz
            ;

            GetObjectPos(g_ElevData[e_ElevObj], x, y, z);
            GetObjectRot(g_ElevData[e_ElevObj], rx, ry, rz);

            MoveObject(g_ElevData[e_ElevObj], x, y, GetElevatorFloorZ(ELEVFLOOR_T), ELEV_MOVECAGE_SPEED, rx, ry, rz);
        }
    }
}

CreateDoor(Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (g_DoorsInitiated >= MAX_DOORS) {
        return INVALID_DOOR_ID;
    }

    new
    Float:area_x,
    Float:area_y,
    Float:area_z
    ;

    PositionFromOffset(
        x,
        y,
        z,
        rx,
        ry,
        rz,
        -1.898399,
        -1.0117,
        -0.507799,
        area_x,
        area_y,
        area_z
    );

    g_DoorData[g_DoorsInitiated][e_DoorClosedZ] = z;
    g_DoorData[g_DoorsInitiated][e_DoorDynObj] = CreateDynamicObject(18756, x, y, z, rx, ry, rz);
    g_DoorData[g_DoorsInitiated][e_DoorDynArea] = CreateDynamicSphere(area_x, area_y, area_z, 4.0);
    g_DoorData[g_DoorsInitiated][e_DoorState] = DOORSTATE_CLOSE;

    SetDynamicObjectMaterial(g_DoorData[g_DoorsInitiated][e_DoorDynObj], 1, 3629, "arprtxxref_las", "ws_corrugateddoor1", 0xFFA9A9A9);

    return g_DoorsInitiated++;
}

DestroyDoors() {
    for (new d; d < g_DoorsInitiated; d++) {
        DestroyDynamicObjectEx(g_DoorData[d][e_DoorDynObj]);

        DestroyDynamicArea(g_DoorData[d][e_DoorDynArea]);
    }
}

UpdateDoorState(doorid) {
    switch (g_DoorData[doorid][e_DoorState]) {
        case DOORSTATE_CLOSE, DOORSTATE_CLOSING:  {
            if (IsAnyPlayerInDynamicArea(g_DoorData[doorid][e_DoorDynArea])) {
                g_DoorData[doorid][e_DoorState] = DOORSTATE_OPENING;

                new
                Float: x,
                Float: y,
                Float: z
                ;

                GetDynamicObjectPos(g_DoorData[doorid][e_DoorDynObj], x, y, z);
                MoveDynamicObject(g_DoorData[doorid][e_DoorDynObj], x, y, g_DoorData[doorid][e_DoorClosedZ] + 2.3, DOOR_MOVE_SPEED);

                PlaySoundForAll(6400, x, y, z);
            }
        }
        case DOORSTATE_OPEN, DOORSTATE_OPENING:  {
            if (!IsAnyPlayerInDynamicArea(g_DoorData[doorid][e_DoorDynArea])) {
                g_DoorData[doorid][e_DoorState] = DOORSTATE_CLOSING;

                new
                Float: x,
                Float: y,
                Float: z
                ;

                GetDynamicObjectPos(g_DoorData[doorid][e_DoorDynObj], x, y, z);
                MoveDynamicObject(g_DoorData[doorid][e_DoorDynObj], x, y, g_DoorData[doorid][e_DoorClosedZ], DOOR_MOVE_SPEED);
            }
        }
    }
}

CreateGeneralItems() {
    g_VehicleObject[0] = CreateObject(18763, -1506.1892, -2658.1350, -8.4806, 93.0999, 0.0000, -59.5999); //bike fallstop
    SetObjectMaterial(g_VehicleObject[0], 0, -1, "none", "none", 0x00FFFFFF);
    g_VehicleObject[1] = CreateObject(18763, -1582.5469, -2706.0200, -0.4629, 90.0000, 0.0000, 0.0000); //forklift fallstop
    SetObjectMaterial(g_VehicleObject[1], 0, -1, "none", "none", 0x00FFFFFF);

    g_DynamicObject[0] = CreateDynamicObject(1523, -1584.7768, -2572.9116, -6.9896, 0.0000, 0.0000, -58.4999); //freezer door
    SetDynamicObjectMaterial(g_DynamicObject[0], 0, -1, "none", "none", 0xFF696969);
    g_DynamicObject[1] = CreateDynamicObject(19828, -1580.5672, -2564.8098, -5.8962, 0.0000, 0.0000, -149.8999); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[1], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[2] = CreateDynamicObject(19325, -1577.6457, -2558.1743, 23.4836, 0.0000, 0.0000, -58.9000); //mazarot window
    SetDynamicObjectMaterial(g_DynamicObject[2], 0, 18646, "matcolours", "grey-90-percent", 0x96FFFFFF);
    g_DynamicObject[3] = CreateDynamicObject(2566, -1596.2181, -2575.0651, -6.4102, 0.0000, -0.0996, -149.1997); //HOTEL_S_BEDSET_3
    SetDynamicObjectMaterial(g_DynamicObject[3], 2, 14652, "ab_trukstpa", "CJ_WOOD1(EDGE)", 0xFFD2B48C);
    g_DynamicObject[4] = CreateDynamicObject(1886, -1571.0273, -2567.3593, 32.7284, 23.4999, 0.0000, -87.8000); //security cam
    g_DynamicObject[5] = CreateDynamicObject(19464, -1578.4399, -2566.2951, 30.3034, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[5], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[6] = CreateDynamicObject(19465, -1574.5577, -2563.9624, 30.2896, 0.0000, 0.0000, -58.8997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[6], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[7] = CreateDynamicObject(1886, -1578.4659, -2567.6103, 32.7555, 28.7999, 0.0000, 92.6996); //security cam
    g_DynamicObject[8] = CreateDynamicObject(19465, -1574.8452, -2570.5781, 30.2896, 0.0000, 0.0000, -58.8997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[8], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[9] = CreateDynamicObject(2718, -1516.9165, -2661.2246, -5.4759, 0.0000, 0.0000, 30.2000); //CJ_FLY_KILLER
    g_DynamicObject[10] = CreateDynamicObject(19408, -1571.4687, -2568.5778, 29.5415, 0.0000, 0.0000, -58.6999); //window cavity
    SetDynamicObjectMaterial(g_DynamicObject[10], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[11] = CreateDynamicObject(9153, -1595.4797, -2584.0954, 34.3146, -23.7000, -6.3000, -32.9999); //bush14_lvs
    SetDynamicObjectMaterial(g_DynamicObject[11], 0, 701, "badlands", "sm_des_bush1", 0x00000000);
    g_DynamicObject[12] = CreateDynamicObject(18553, -1583.0134, -2572.3156, 29.1107, 0.0000, 0.0000, 210.0000); //entrydoor exterior
    SetDynamicObjectMaterial(g_DynamicObject[12], 0, 16293, "a51_undergrnd", "Was_scrpyd_door_in_hngr", 0x00000000);
    g_DynamicObject[13] = CreateDynamicObject(18764, -1585.1285, -2573.6083, 25.3232, 0.0000, 0.0000, -58.5998); //entry floor block
    SetDynamicObjectMaterial(g_DynamicObject[13], 0, 2669, "cj_chris", "cj_metalplate2", 0x00000000);
    g_DynamicObject[14] = CreateDynamicObject(19377, -1572.2086, -2571.8618, 27.7364, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[14], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[15] = CreateDynamicObject(19377, -1572.3824, -2571.9433, 32.7363, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[15], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[16] = CreateDynamicObject(19466, -1571.4425, -2568.5185, 29.7737, 0.0000, 0.0000, -58.7999); //window001
    SetDynamicObjectMaterial(g_DynamicObject[16], 0, 16640, "a51", "a51_glass", 0x00000000);
    g_DynamicObject[17] = CreateDynamicObject(19464, -1578.7215, -2569.9938, 30.3034, 0.0000, 0.0000, 31.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[17], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[18] = CreateDynamicObject(18764, -1580.8884, -2571.0397, 28.3631, 0.0000, 0.0000, 31.0000); //entry doorway cube
    SetDynamicObjectMaterial(g_DynamicObject[18], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[19] = CreateDynamicObject(1616, -1582.1555, -2574.2070, 31.1471, -22.6000, 0.0000, -4.9998); //entry exterior camer
    g_DynamicObject[20] = CreateDynamicObject(1886, -1519.9654, -2663.8588, -2.2764, 43.5000, 0.0000, 73.6996); //shop_sec_cam
    g_DynamicObject[21] = CreateDynamicObject(19464, -1573.0345, -2560.5187, 30.1033, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[21], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[22] = CreateDynamicObject(19477, -1570.7386, -2564.5881, 31.6145, 0.0000, -0.0996, -148.0997); //photoforbidden
    SetDynamicObjectMaterial(g_DynamicObject[22], 0, 16093, "a51_ext", "a51_fencsign", 0x00000000);
    g_DynamicObject[23] = CreateDynamicObject(19464, -1574.8133, -2574.0500, 30.3034, 0.0000, 0.0000, 31.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[23], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[24] = CreateDynamicObject(19464, -1567.5893, -2566.1999, 28.7434, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[24], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[25] = CreateDynamicObject(19464, -1569.7641, -2567.5026, 33.8134, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[25], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[26] = CreateDynamicObject(19408, -1571.5057, -2568.5180, 29.5415, 0.0000, 0.0000, -58.6999); //wall056
    SetDynamicObjectMaterial(g_DynamicObject[26], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[27] = CreateDynamicObject(19464, -1570.4835, -2564.6662, 33.2234, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[27], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[28] = CreateDynamicObject(19465, -1577.5074, -2562.1813, 30.2896, 0.0000, 0.0000, -149.0997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[28], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[29] = CreateDynamicObject(2965, -1577.0964, -2558.8229, 23.7082, 180.0000, 270.0000, 120.8001); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[29], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[30] = CreateDynamicObject(19465, -1571.7192, -2572.1862, 30.2896, 0.0000, 0.0000, -149.0997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[30], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[31] = CreateDynamicObject(19464, -1573.0334, -2575.2915, 30.3034, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[31], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[32] = CreateDynamicObject(19464, -1569.1191, -2572.9328, 30.3034, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[32], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[33] = CreateDynamicObject(19464, -1568.1367, -2568.6333, 30.1033, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[33], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[34] = CreateDynamicObject(14596, -1576.5609, -2552.2939, 21.1175, 0.0000, 0.0000, 120.7994); //stairway
    SetDynamicObjectMaterial(g_DynamicObject[34], 0, 16640, "a51", "metpat64", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[34], 1, 18646, "matcolours", "grey-70-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[34], 2, 18646, "matcolours", "orange", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[34], 4, 18646, "matcolours", "grey-80-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[34], 6, 18646, "matcolours", "grey-10-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[34], 8, 7247, "vgncoast", "metalwheel2_128", 0x00000000);
    g_DynamicObject[35] = CreateDynamicObject(19465, -1576.8917, -2559.0576, 30.2896, 0.0000, 0.0000, 120.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[35], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[36] = CreateDynamicObject(19377, -1576.7724, -2564.6369, 32.7262, 0.0000, 270.0000, 31.0000); //big celiling
    SetDynamicObjectMaterial(g_DynamicObject[36], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[37] = CreateDynamicObject(19377, -1576.6142, -2564.5305, 27.7464, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[37], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[38] = CreateDynamicObject(19464, -1581.2159, -2561.6762, 30.3034, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[38], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[39] = CreateDynamicObject(19464, -1575.9990, -2551.2749, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[39], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[40] = CreateDynamicObject(2173, -1571.4315, -2569.3666, 27.8115, 0.0000, 0.0000, 31.0000); //MED_OFFICE_DESK_3
    SetDynamicObjectMaterial(g_DynamicObject[40], 0, 18646, "matcolours", "orange", 0x00000000);
    g_DynamicObject[41] = CreateDynamicObject(19999, -1570.1644, -2569.6791, 27.8145, 0.0000, 0.0000, -95.8002); //CutsceneChair2
    g_DynamicObject[42] = CreateDynamicObject(362, -1572.3010, -2563.1335, 32.7374, 0.0000, 74.3999, -103.9001); //minigun
    g_DynamicObject[43] = CreateDynamicObject(19477, -1567.8894, -2569.2993, 30.3110, 0.0000, 0.0000, 31.0000); //alien painting
    SetDynamicObjectMaterial(g_DynamicObject[43], 0, 14420, "dr_gsbits", "mp_apt1_pic1", 0x00000000);
    g_DynamicObject[44] = CreateDynamicObject(19893, -1571.1009, -2569.0546, 28.5958, 0.0000, 0.0000, 29.3999); //LaptopSAMP1
    SetDynamicObjectMaterial(g_DynamicObject[44], 1, 14489, "carlspics", "AH_landscap1", 0x00000000);
    g_DynamicObject[45] = CreateDynamicObject(18075, -1574.3868, -2566.8955, 32.6333, 0.0000, 0.0000, 31.2999); //lightD
    g_DynamicObject[46] = CreateDynamicObject(18553, -1578.6910, -2569.8186, 29.1107, 0.0000, 0.0000, 29.9999); //entrydoor interior
    SetDynamicObjectMaterial(g_DynamicObject[46], 0, 16293, "a51_undergrnd", "Was_scrpyd_door_in_hngr", 0xFF696969);
    g_DynamicObject[47] = CreateDynamicObject(19273, -1575.7342, -2571.0148, 29.0475, 0.0000, 0.0000, -148.6997); //KeypadNonDynamic
    g_DynamicObject[48] = CreateDynamicObject(19273, -1571.2956, -2573.0534, 29.0475, 0.0000, 0.0000, -57.2000); //KeypadNonDynamic
    g_DynamicObject[49] = CreateDynamicObject(19273, -1571.1556, -2572.9782, 29.0475, 0.0000, 0.0000, 121.2001); //KeypadNonDynamic
    g_DynamicObject[50] = CreateDynamicObject(19273, -1575.6628, -2571.1699, 29.0475, 0.0000, 0.0000, 30.1000); //KeypadNonDynamic
    g_DynamicObject[51] = CreateDynamicObject(18643, -1577.3243, -2571.2788, 32.3389, 1.0000, 134.9998, -119.9008); //LaserPointer1
    g_DynamicObject[52] = CreateDynamicObject(362, -1577.2235, -2571.4912, 32.7326, 0.0000, 74.3999, 65.4990); //minigun
    g_DynamicObject[53] = CreateDynamicObject(2965, -1577.3529, -2558.3942, 17.9381, 180.0000, 270.0000, 120.8001); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[53], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[54] = CreateDynamicObject(2986, -1574.0472, -2566.7634, 32.6208, 0.0000, 0.0000, 30.7999); //lxr_motelvent
    g_DynamicObject[55] = CreateDynamicObject(351, -1571.1988, -2569.4912, 28.5809, 100.0998, 56.8997, 127.9996); //shotgspa
    g_DynamicObject[56] = CreateDynamicObject(19576, -1571.1759, -2569.0205, 28.6504, 0.0000, 0.0000, 0.0000); //Apple2
    g_DynamicObject[57] = CreateDynamicObject(11729, -1576.5887, -2564.6955, 28.1056, 0.0000, 0.0000, -149.7001); //GymLockerClosed1
    g_DynamicObject[58] = CreateDynamicObject(2241, -1569.2700, -2568.1730, 28.2772, 0.0000, 0.0000, -108.1996); //Plant_Pot_5
    g_DynamicObject[59] = CreateDynamicObject(2315, -1580.2113, -2561.8666, 27.7604, 0.0000, 0.0000, 31.2000); //locker bench
    SetDynamicObjectMaterial(g_DynamicObject[59], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    g_DynamicObject[60] = CreateDynamicObject(11729, -1577.1495, -2565.0231, 28.1056, 0.0000, 0.0000, -149.7001); //GymLockerClosed1
    g_DynamicObject[61] = CreateDynamicObject(19464, -1582.3736, -2565.2985, 30.3034, 0.0000, 0.0000, 31.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[61], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[62] = CreateDynamicObject(19464, -1565.0886, -2573.6826, 30.1033, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[62], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[63] = CreateDynamicObject(19464, -1573.5173, -2559.7631, 30.1033, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[63], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[64] = CreateDynamicObject(19464, -1576.0904, -2555.4287, -4.4800, 0.0000, 0.0000, -148.9996); //wall1fix
    SetDynamicObjectMaterial(g_DynamicObject[64], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[65] = CreateDynamicObject(11729, -1577.7103, -2565.3498, 28.1056, 0.0000, 0.0000, -149.7001); //GymLockerClosed1
    g_DynamicObject[66] = CreateDynamicObject(19464, -1570.9499, -2563.9201, -1.6196, 0.0000, 0.0000, -148.8997); //wall4fix
    SetDynamicObjectMaterial(g_DynamicObject[66], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[67] = CreateDynamicObject(19464, -1579.1363, -2550.3383, -4.4800, 0.0000, 0.0000, -148.8997); //wall
    SetDynamicObjectMaterial(g_DynamicObject[67], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[68] = CreateDynamicObject(19464, -1578.8946, -2563.3801, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[68], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[69] = CreateDynamicObject(19377, -1579.8857, -2559.0805, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[69], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[70] = CreateDynamicObject(19465, -1581.0229, -2554.3117, -4.4703, 0.0000, 0.0000, 120.8999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[70], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[71] = CreateDynamicObject(19464, -1568.1396, -2568.6110, -4.4800, 0.0000, 0.0000, -148.8997); //wall3fix
    SetDynamicObjectMaterial(g_DynamicObject[71], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[72] = CreateDynamicObject(19377, -1579.8857, -2559.0805, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[72], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[73] = CreateDynamicObject(19377, -1574.9256, -2567.3364, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[73], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[74] = CreateDynamicObject(19377, -1588.8675, -2564.4763, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[74], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[75] = CreateDynamicObject(19377, -1574.9300, -2567.3278, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[75], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[76] = CreateDynamicObject(19377, -1583.9084, -2572.7277, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[76], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[77] = CreateDynamicObject(19465, -1580.6052, -2564.0322, 30.3495, 0.0000, 0.0000, -149.0997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[77], 0, 16640, "a51", "concretemanky", 0x00000000);
    g_DynamicObject[78] = CreateDynamicObject(19362, -1577.0434, -2558.8728, 23.7082, 0.0000, 0.0000, 120.8001); //mazarot bg
    SetDynamicObjectMaterial(g_DynamicObject[78], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[79] = CreateDynamicObject(1886, -1567.4112, -2571.1530, 32.7228, 34.0998, 0.0000, -100.1996); //security cam
    g_DynamicObject[80] = CreateDynamicObject(1886, -1571.6496, -2573.4367, 32.7224, 50.4998, 0.0000, -120.5000); //security cam
    g_DynamicObject[81] = CreateDynamicObject(2654, -1577.7545, -2565.4411, 30.3738, 0.0000, 0.0000, 119.6996); //CJ_shoe_box
    SetDynamicObjectMaterial(g_DynamicObject[81], 0, 2567, "ab", "Box_Texturepage", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[81], 1, 5132, "imstuff_las2", "cardbrdirty128", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[81], 2, 5132, "imstuff_las2", "cardbrdirty128", 0x00000000);
    g_DynamicObject[82] = CreateDynamicObject(1886, -1574.8260, -2558.8901, 32.7052, 38.7998, 0.0000, 0.4997); //security cam
    g_DynamicObject[83] = CreateDynamicObject(2291, -1588.4267, -2565.3820, -7.0664, 0.0000, 0.0000, 121.0998); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[83], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[84] = CreateDynamicObject(19464, -1573.0439, -2560.5000, -4.4800, 0.0000, 0.0000, -148.8997); //wall2fix
    SetDynamicObjectMaterial(g_DynamicObject[84], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[85] = CreateDynamicObject(19464, -1566.4726, -2567.6994, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[85], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[86] = CreateDynamicObject(3502, -1569.2187, -2574.7507, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[86], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[87] = CreateDynamicObject(19464, -1576.5959, -2573.7805, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[87], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[88] = CreateDynamicObject(19464, -1581.6794, -2576.8337, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[88], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[89] = CreateDynamicObject(19464, -1586.7545, -2579.8837, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[89], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[90] = CreateDynamicObject(19465, -1575.8548, -2568.4453, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[90], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[91] = CreateDynamicObject(19464, -1572.8022, -2573.5212, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[91], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[92] = CreateDynamicObject(11730, -1578.2458, -2565.6799, 28.1138, 0.0000, 0.0000, -147.8997); //GymLockerOpen1
    g_DynamicObject[93] = CreateDynamicObject(2315, -1578.1053, -2565.3444, 27.7604, 0.0000, 0.0000, 31.2000); //locker bench
    SetDynamicObjectMaterial(g_DynamicObject[93], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    g_DynamicObject[94] = CreateDynamicObject(11729, -1578.8243, -2566.0004, 28.1056, 0.0000, 0.0000, -149.7001); //GymLockerClosed1
    g_DynamicObject[95] = CreateDynamicObject(2315, -1578.8061, -2565.7700, 27.7504, 0.0000, 0.0000, 31.2000); //locker bench
    SetDynamicObjectMaterial(g_DynamicObject[95], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    g_DynamicObject[96] = CreateDynamicObject(2517, -1581.6180, -2563.8718, 27.7868, 0.0000, 0.0000, 30.7999); //CJ_SHOWER1
    g_DynamicObject[97] = CreateDynamicObject(2525, -1579.8453, -2566.5029, 27.8248, 0.0000, 0.0000, -58.2999); //CJ_TOILET4
    g_DynamicObject[98] = CreateDynamicObject(2518, -1580.6966, -2565.1013, 27.8106, 0.0000, 0.0000, -58.9000); //CJ_B_SINK2
    g_DynamicObject[99] = CreateDynamicObject(19475, -1580.0493, -2565.2487, 29.4722, 0.0000, 0.0000, 30.8999); //bath mirror
    SetDynamicObjectMaterial(g_DynamicObject[99], 0, 9932, "nitelites", "sfnitewindows", 0x00000000);
    g_DynamicObject[100] = CreateDynamicObject(11737, -1581.5201, -2563.8564, 27.8283, 0.0000, 0.0000, 30.8999); //RockstarMat1
    SetDynamicObjectMaterial(g_DynamicObject[100], 0, 14788, "ab_sfgymbits01", "ab_rollmat01", 0x00000000);
    g_DynamicObject[101] = CreateDynamicObject(2315, -1580.9289, -2562.3000, 27.7404, 0.0000, 0.0000, 31.2000); //locker bench
    SetDynamicObjectMaterial(g_DynamicObject[101], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    g_DynamicObject[102] = CreateDynamicObject(362, -1578.0841, -2565.8168, 29.5354, 9.2999, 115.6996, 0.0000); //minigun
    g_DynamicObject[103] = CreateDynamicObject(11730, -1578.9636, -2560.8315, 28.1138, 0.0000, 0.0000, 32.2999); //GymLockerOpen1
    g_DynamicObject[104] = CreateDynamicObject(11729, -1579.5102, -2561.1787, 28.1056, 0.0000, 0.0000, 30.8997); //GymLockerClosed1
    g_DynamicObject[105] = CreateDynamicObject(351, -1579.0505, -2560.7360, 29.1674, 7.7999, 101.4998, 35.9000); //shotgspa
    g_DynamicObject[106] = CreateDynamicObject(11729, -1580.0688, -2561.5119, 28.1056, 0.0000, 0.0000, 30.8997); //GymLockerClosed1
    g_DynamicObject[107] = CreateDynamicObject(11730, -1580.6179, -2561.8447, 28.1138, 0.0000, 0.0000, 30.7999); //GymLockerOpen1
    g_DynamicObject[108] = CreateDynamicObject(11729, -1581.1590, -2562.1630, 28.1056, 0.0000, 0.0000, 30.8997); //GymLockerClosed1
    g_DynamicObject[109] = CreateDynamicObject(19141, -1579.0831, -2560.9743, 28.3721, -26.6000, -92.2994, -141.3999); //SWATHelmet1
    g_DynamicObject[110] = CreateDynamicObject(3070, -1578.8553, -2560.7819, 28.2723, 0.0000, 0.0000, 0.0000); //kmb_goggles
    g_DynamicObject[111] = CreateDynamicObject(353, -1580.7264, -2561.7414, 29.6564, 6.9998, 91.1996, 32.1999); //mp5lng
    g_DynamicObject[112] = CreateDynamicObject(343, -1580.7340, -2561.8598, 28.4022, 0.0000, 0.0000, 0.0000); //teargas
    g_DynamicObject[113] = CreateDynamicObject(343, -1580.7340, -2561.9699, 28.4022, 0.0000, 0.0000, 100.5998); //teargas
    g_DynamicObject[114] = CreateDynamicObject(19472, -1580.5426, -2561.7226, 28.3523, 0.0000, 0.0000, -123.0998); //gasmask01
    g_DynamicObject[115] = CreateDynamicObject(18725, -1576.2092, -2708.8574, 0.0507, 0.0000, 0.0000, 0.0000); //smoke30lit
    g_DynamicObject[116] = CreateDynamicObject(19465, -1571.5340, -2570.7336, -4.4703, 0.0000, 0.0000, 120.8999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[116], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[117] = CreateDynamicObject(11707, -1581.3846, -2566.5949, 28.8257, 0.0000, 0.0000, 122.3000); //TowelRack1
    SetDynamicObjectMaterial(g_DynamicObject[117], 3, 18901, "matclothes", "beretblk", 0x00000000);
    g_DynamicObject[118] = CreateDynamicObject(19475, -1602.3298, -2720.2917, 4.2048, 0.0000, 0.0000, 95.8999); //radioactive sub
    SetDynamicObjectMaterial(g_DynamicObject[118], 0, 19962, "samproadsigns", "radiation", 0x00000000);
    g_DynamicObject[119] = CreateDynamicObject(19465, -1576.5051, -2554.7473, 12.9195, 0.0000, 0.0000, -149.0997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[119], 0, 18646, "matcolours", "orange", 0x00000000);
    g_DynamicObject[120] = CreateDynamicObject(19464, -1586.0776, -2557.3522, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[120], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[121] = CreateDynamicObject(19464, -1591.1350, -2560.3916, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[121], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[122] = CreateDynamicObject(19465, -1581.2800, -2565.3833, -4.4703, 0.0000, 0.0000, 120.8999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[122], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[123] = CreateDynamicObject(2985, -1590.6593, -2568.8666, -6.9977, 0.0000, 0.0000, -58.6999); //minigun_base
    SetDynamicObjectMaterial(g_DynamicObject[123], 0, 16322, "a51_stores", "metalic128", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[123], 1, -1, "none", "none", 0x00FFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[123], 2, 16322, "a51_stores", "metalic128", 0xFF696969);
    g_DynamicObject[124] = CreateDynamicObject(19464, -1584.4747, -2567.2929, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[124], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[125] = CreateDynamicObject(19464, -1581.2458, -2578.5974, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[125], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[126] = CreateDynamicObject(19464, -1592.4444, -2571.4958, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[126], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[127] = CreateDynamicObject(19465, -1590.3620, -2563.3610, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[127], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[128] = CreateDynamicObject(19464, -1587.3281, -2568.4348, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[128], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[129] = CreateDynamicObject(19465, -1584.2955, -2573.5207, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[129], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[130] = CreateDynamicObject(19377, -1597.8332, -2569.8847, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[130], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[131] = CreateDynamicObject(19377, -1592.8884, -2578.1384, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[131], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[132] = CreateDynamicObject(19464, -1589.4104, -2576.5454, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[132], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[133] = CreateDynamicObject(19464, -1586.3647, -2581.6108, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[133], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[134] = CreateDynamicObject(19464, -1591.8205, -2582.9306, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[134], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[135] = CreateDynamicObject(19464, -1596.8957, -2585.9797, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[135], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[136] = CreateDynamicObject(19563, -1585.2624, -2578.5295, -5.3218, 0.0000, 0.0000, 1.6999); //JuiceBox1
    g_DynamicObject[137] = CreateDynamicObject(19464, -1597.1241, -2581.0822, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[137], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[138] = CreateDynamicObject(19464, -1600.1722, -2576.0092, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[138], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[139] = CreateDynamicObject(19464, -1602.4945, -2569.8745, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[139], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[140] = CreateDynamicObject(19465, -1592.2524, -2566.1354, -4.4703, 0.0000, 0.0000, 120.8999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[140], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[141] = CreateDynamicObject(19464, -1596.1781, -2563.4196, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[141], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[142] = CreateDynamicObject(19465, -1595.4798, -2566.4348, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[142], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[143] = CreateDynamicObject(19464, -1602.4962, -2568.8791, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[143], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[144] = CreateDynamicObject(19464, -1603.2269, -2570.9252, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[144], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[145] = CreateDynamicObject(19377, -1597.8542, -2569.8776, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[145], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[146] = CreateDynamicObject(19377, -1592.8927, -2578.1359, -3.0000, 0.0000, 270.0000, 31.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[146], 0, 19595, "lsappartments1", "ceilingtiles3-128x128", 0x00000000);
    g_DynamicObject[147] = CreateDynamicObject(19464, -1588.0400, -2573.2011, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[147], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[148] = CreateDynamicObject(19430, -1571.1035, -2571.4958, -7.2244, 13.5999, -90.1996, 31.7999); //wall070
    SetDynamicObjectMaterial(g_DynamicObject[148], 0, 16322, "a51_stores", "metpat64chev_128", 0x00000000);
    g_DynamicObject[149] = CreateDynamicObject(3502, -1564.8216, -2582.3395, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[149], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[150] = CreateDynamicObject(3502, -1560.4281, -2589.9196, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[150], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[151] = CreateDynamicObject(3502, -1556.0299, -2597.5039, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[151], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[152] = CreateDynamicObject(3502, -1551.6318, -2605.0915, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[152], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[153] = CreateDynamicObject(3502, -1547.2384, -2612.6689, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[153], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[154] = CreateDynamicObject(3502, -1542.8353, -2620.2590, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[154], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[155] = CreateDynamicObject(3502, -1538.4331, -2627.8510, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[155], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[156] = CreateDynamicObject(3502, -1534.0373, -2635.4350, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[156], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[157] = CreateDynamicObject(3502, -1529.6446, -2643.0141, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[157], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[158] = CreateDynamicObject(3502, -1525.2540, -2650.5878, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[158], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[159] = CreateDynamicObject(3502, -1520.8668, -2658.1582, -5.7164, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[159], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[160] = CreateDynamicObject(1462, -1514.4195, -2664.5349, -7.2045, 0.0000, 0.0000, -57.5000); //DYN_woodpile
    g_DynamicObject[161] = CreateDynamicObject(19377, -1514.2679, -2664.9238, -2.2634, 0.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[161], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[162] = CreateDynamicObject(19465, -1518.5753, -2661.9892, -4.7501, 0.0000, 0.0000, 120.2994); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[162], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[163] = CreateDynamicObject(19465, -1519.6230, -2665.9643, -4.7402, 0.0000, 0.0000, 29.6998); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[163], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[164] = CreateDynamicObject(19377, -1514.2679, -2664.9238, -7.3035, 0.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[164], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[165] = CreateDynamicObject(19465, -1557.6728, -2688.4062, -4.7402, 0.0000, 0.0000, 29.9997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[165], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[166] = CreateDynamicObject(3502, -1523.6269, -2668.3637, -5.7663, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[166], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[167] = CreateDynamicObject(3502, -1531.1855, -2672.8002, -5.7663, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[167], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[168] = CreateDynamicObject(3502, -1538.7429, -2677.2319, -5.7663, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[168], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[169] = CreateDynamicObject(3502, -1546.3005, -2681.6657, -5.7663, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[169], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[170] = CreateDynamicObject(3502, -1553.8562, -2686.0976, -5.7663, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[170], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[171] = CreateDynamicObject(19377, -1563.0155, -2689.6760, -2.5060, 270.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[171], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[172] = CreateDynamicObject(19377, -1571.9914, -2696.7478, 4.9882, 0.0000, -55.1999, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[172], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[173] = CreateDynamicObject(19377, -1571.1695, -2696.3535, 6.1465, 0.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[173], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[174] = CreateDynamicObject(19377, -1561.4908, -2692.2963, -2.5060, 270.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[174], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[175] = CreateDynamicObject(14877, -1564.0715, -2691.9934, -5.1440, 0.0000, 0.0000, -149.7998); //exit stairs
    SetDynamicObjectMaterial(g_DynamicObject[175], 0, 18886, "electromagnet1", "hazardtile13-128x128", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[175], 1, 4595, "crparkgm_lan2", "sl_cparkbarrier1", 0x00000000);
    g_DynamicObject[176] = CreateDynamicObject(19377, -1562.2176, -2691.0659, -7.3035, 0.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[176], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[177] = CreateDynamicObject(14877, -1572.6196, -2696.9677, -1.0340, 0.0000, 0.0000, -149.7998); //exit stairs
    SetDynamicObjectMaterial(g_DynamicObject[177], 0, 18886, "electromagnet1", "hazardtile13-128x128", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[177], 1, 4595, "crparkgm_lan2", "sl_cparkbarrier1", 0x00000000);
    g_DynamicObject[178] = CreateDynamicObject(19377, -1561.3089, -2690.5310, 0.7098, 0.0000, -55.1999, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[178], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[179] = CreateDynamicObject(19377, -1572.0378, -2694.9289, 1.7137, 270.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[179], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[180] = CreateDynamicObject(19377, -1563.7972, -2691.9816, 2.0264, 0.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[180], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[181] = CreateDynamicObject(2708, -1590.2468, -2575.9399, -7.2290, 0.0000, 0.0000, -59.0000); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[181], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[182] = CreateDynamicObject(19377, -1570.5145, -2697.5471, 1.7137, 270.0000, 270.0000, 30.1998); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[182], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[183] = CreateDynamicObject(19465, -1575.7347, -2698.8188, 3.5497, 0.0000, 0.0000, 29.9997); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[183], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[184] = CreateDynamicObject(19377, -1579.1518, -2701.5139, 0.9362, 0.0000, 270.0000, 90.0000); //dock floor
    SetDynamicObjectMaterial(g_DynamicObject[184], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[185] = CreateDynamicObject(19464, -1598.1782, -2579.3217, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[185], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[186] = CreateDynamicObject(19465, -1514.5157, -2663.0493, -4.7402, 0.0000, 0.0000, 29.6998); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[186], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[187] = CreateDynamicObject(19465, -1593.1236, -2576.2756, -4.4703, 0.0000, 0.0000, 120.8999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[187], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[188] = CreateDynamicObject(19563, -1584.9864, -2578.3627, -5.3218, 0.0000, 0.0000, 76.2994); //JuiceBox1
    g_DynamicObject[189] = CreateDynamicObject(2394, -1588.7906, -2578.6340, -5.4895, 0.0000, 0.0000, -59.0000); //CJ_CLOTHES_STEP_1
    g_DynamicObject[190] = CreateDynamicObject(19465, -1598.7706, -2569.1855, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[190], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[191] = CreateDynamicObject(19465, -1595.7213, -2574.2607, -4.4703, 0.0000, 0.0000, 30.9999); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[191], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[192] = CreateDynamicObject(19464, -1601.8031, -2564.1110, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[192], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[193] = CreateDynamicObject(19464, -1600.4906, -2572.2756, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[193], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[194] = CreateDynamicObject(19377, -1583.8934, -2701.5319, 5.6763, 270.0000, 270.0000, 90.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[194], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[195] = CreateDynamicObject(19377, -1574.3537, -2706.5024, 5.6763, 270.0000, 270.0000, 90.0000); //dock wall
    SetDynamicObjectMaterial(g_DynamicObject[195], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[196] = CreateDynamicObject(19377, -1582.4592, -2696.3288, 5.6763, 270.0000, 270.0000, 0.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[196], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[197] = CreateDynamicObject(19377, -1579.1518, -2701.5139, 6.1662, 0.0000, 270.0000, 90.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[197], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[198] = CreateDynamicObject(9958, -1574.9814, -2719.7524, 3.0641, 0.0000, 0.0000, -89.8998); //submarine
    g_DynamicObject[199] = CreateDynamicObject(19377, -1579.1345, -2706.5261, 0.9664, 0.0000, 270.0000, 90.0000); //big ceiling
    SetDynamicObjectMaterial(g_DynamicObject[199], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[200] = CreateDynamicObject(19377, -1583.9161, -2706.4948, 5.6763, 270.0000, 270.0000, 90.0000); //dock wall
    SetDynamicObjectMaterial(g_DynamicObject[200], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[201] = CreateDynamicObject(19377, -1579.1341, -2706.5041, 6.1862, 0.0000, 270.0000, 90.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[201], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[202] = CreateDynamicObject(19465, -1515.6739, -2666.9526, -4.7501, 0.0000, 0.0000, 120.2994); //doorway
    SetDynamicObjectMaterial(g_DynamicObject[202], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[203] = CreateDynamicObject(19853, -1640.9731, -2723.3239, 16.6219, 0.0000, 90.0000, 0.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[203], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[204] = CreateDynamicObject(19853, -1610.3009, -2734.5932, -14.5677, 0.0000, 90.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[204], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[205] = CreateDynamicObject(19853, -1610.3309, -2734.5932, 16.6520, 0.0000, 90.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[205], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[206] = CreateDynamicObject(19377, -1569.1805, -2711.7165, 1.3062, 270.0000, 270.0000, 0.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[206], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[207] = CreateDynamicObject(19853, -1547.8315, -2734.5932, -14.5677, 0.0000, 90.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[207], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[208] = CreateDynamicObject(10841, -1640.8780, -2723.1818, -12.6422, 0.0000, 0.0000, 270.0000); //drydock1_SFSe01
    g_DynamicObject[209] = CreateDynamicObject(19853, -1547.8409, -2722.4250, -30.1578, 0.0000, 0.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[209], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[210] = CreateDynamicObject(19853, -1640.9731, -2723.3239, -14.5677, 0.0000, 90.0000, 0.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[210], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[211] = CreateDynamicObject(19377, -1589.0826, -2711.7165, 1.3062, 270.0000, 270.0000, 0.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[211], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[212] = CreateDynamicObject(19853, -1579.2956, -2711.7609, 21.7520, 0.0000, 90.0000, 270.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[212], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[213] = CreateDynamicObject(19853, -1547.8094, -2711.8110, -14.5677, 0.0000, 90.0000, 270.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[213], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[214] = CreateDynamicObject(19853, -1610.3011, -2722.8090, 32.2121, 0.0000, 180.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[214], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[215] = CreateDynamicObject(19853, -1520.3531, -2723.3239, -14.5677, 0.0000, 90.0000, 180.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[215], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[216] = CreateDynamicObject(19853, -1543.1488, -2711.8110, 16.6821, 0.0000, 90.0000, 270.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[216], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[217] = CreateDynamicObject(19853, -1547.8315, -2734.5932, 16.6520, 0.0000, 90.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[217], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[218] = CreateDynamicObject(11496, -1579.1894, -2711.0944, 0.8524, 0.0000, 0.0000, 270.0000); //des_wjetty
    SetDynamicObjectMaterial(g_DynamicObject[218], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[218], 1, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[218], 2, 615, "gta_tree_boak", "sm_redwood_bark", 0x00000000);
    g_DynamicObject[219] = CreateDynamicObject(19377, -1578.8415, -2711.6564, 10.8662, 270.0000, 270.0000, 0.0000); //dock ceiling
    SetDynamicObjectMaterial(g_DynamicObject[219], 0, 17562, "coast_apts", "Concrete_rough_256", 0x00000000);
    g_DynamicObject[220] = -1;
    // g_DynamicObject[220] = CreateDynamicObject(19853, -1504.8492, -2907.3398, 51.3418, 0.0000, 180.0000, 90.0000); //MIHouse1Land5
    // SetDynamicObjectMaterial(g_DynamicObject[220], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[221] = CreateDynamicObject(11496, -1595.1905, -2711.0944, 0.8524, 0.0000, 0.0000, 270.0000); //des_wjetty
    SetDynamicObjectMaterial(g_DynamicObject[221], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[221], 1, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[221], 2, 615, "gta_tree_boak", "sm_redwood_bark", 0x00000000);
    g_DynamicObject[222] = CreateDynamicObject(19853, -1615.1677, -2711.8110, 16.6821, 0.0000, 90.0000, 270.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[222], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[223] = CreateDynamicObject(19853, -1610.3309, -2722.4250, -30.1578, 0.0000, 0.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[223], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[224] = CreateDynamicObject(19853, -1520.3531, -2723.3239, 16.6620, 0.0000, 90.0000, 180.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[224], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[225] = CreateDynamicObject(19853, -1547.8393, -2722.8090, 32.2121, 0.0000, 180.0000, 90.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[225], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[226] = CreateDynamicObject(19853, -1610.3009, -2711.8110, -14.5677, 0.0000, 90.0000, 270.0000); //MIHouse1Land5
    SetDynamicObjectMaterial(g_DynamicObject[226], 0, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[227] = CreateDynamicObject(10841, -1640.8780, -2723.1818, -22.2623, 0.0000, 0.0000, 270.0000); //drydock1_SFSe01
    g_DynamicObject[228] = CreateDynamicObject(11496, -1563.1999, -2711.0944, 0.8524, 0.0000, 0.0000, 270.0000); //des_wjetty
    SetDynamicObjectMaterial(g_DynamicObject[228], 0, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[228], 1, 3063, "col_wall1x", "ab_wood1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[228], 2, 615, "gta_tree_boak", "sm_redwood_bark", 0x00000000);
    g_DynamicObject[229] = CreateDynamicObject(18228, -1566.6579, -2727.0844, 35.2345, -178.7998, 0.0000, -101.5000); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[229], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[229], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[230] = CreateDynamicObject(18228, -1517.4541, -2724.0827, 34.9846, -178.7998, 0.0000, 41.8997); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[230], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[230], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[231] = CreateDynamicObject(18228, -1583.5814, -2728.9965, 35.7089, -178.7998, 0.0000, 8.1997); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[231], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[231], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[232] = CreateDynamicObject(18228, -1610.9774, -2731.0205, 35.7868, -178.7998, 0.0000, 0.1999); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[232], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[232], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[233] = CreateDynamicObject(18228, -1631.8426, -2724.9404, 35.6511, -178.7998, 0.0000, 158.1999); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[233], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[233], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[234] = CreateDynamicObject(3502, -1510.5510, -2660.6948, -5.4461, 0.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[234], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[235] = CreateDynamicObject(3502, -1503.1490, -2656.3483, -4.9288, 7.2999, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[235], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[236] = CreateDynamicObject(18706, -1514.7757, -2668.4587, -5.1048, 0.0000, 0.0000, 0.0000); //prt_blood
    g_DynamicObject[237] = CreateDynamicObject(3502, -1496.0572, -2652.1821, -3.1363, 17.0000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[237], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[238] = CreateDynamicObject(3502, -1489.2424, -2648.1892, -0.1207, 25.2000, 0.0000, -59.5998); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[238], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[239] = CreateDynamicObject(974, -1515.4094, -2661.5969, -5.9470, 0.0000, 0.0000, -60.2999); //tall_fence
    SetDynamicObjectMaterial(g_DynamicObject[239], 1, 18787, "matramps", "metalflooring", 0x00000000);
    g_DynamicObject[240] = CreateDynamicObject(3502, -1513.3979, -2671.0410, -5.6563, 0.0000, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[240], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[241] = CreateDynamicObject(3502, -1509.0954, -2678.4663, -6.4744, 9.8999, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[241], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[242] = CreateDynamicObject(3502, -1505.0527, -2685.4414, -8.5452, 17.7999, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[242], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[243] = CreateDynamicObject(3502, -1501.2264, -2692.0419, -11.9350, 28.3999, 0.0000, 30.1000); //vgsN_con_tube
    SetDynamicObjectMaterial(g_DynamicObject[243], 0, 3411, "ce_railbridge", "rusta256128", 0x00000000);
    g_DynamicObject[244] = CreateDynamicObject(974, -1514.1180, -2666.0859, -5.9470, 0.0000, 0.0000, -149.8999); //tall_fence
    SetDynamicObjectMaterial(g_DynamicObject[244], 1, 18787, "matramps", "metalflooring", 0x00000000);
    g_DynamicObject[245] = CreateDynamicObject(19078, -1512.1545, -2661.4741, -6.8625, 0.0000, -93.8000, 125.9999); //TheParrot1
    g_DynamicObject[246] = CreateDynamicObject(849, -1513.0871, -2662.2922, -6.9169, 0.0000, 0.0000, 34.0000); //CJ_urb_rub_3
    g_DynamicObject[247] = CreateDynamicObject(853, -1515.0262, -2668.0585, -6.8017, 0.0000, 0.0000, 0.0000); //CJ_urb_rub_5
    g_DynamicObject[248] = CreateDynamicObject(2965, -1576.7889, -2554.9316, 6.3582, 180.0000, 270.0000, -149.0997); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[248], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[249] = CreateDynamicObject(14596, -1583.3153, -2554.4396, 3.7174, 0.0000, 0.0000, -149.2001); //stairway
    SetDynamicObjectMaterial(g_DynamicObject[249], 0, 16640, "a51", "metpat64", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[249], 1, 18646, "matcolours", "grey-70-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[249], 2, 18646, "matcolours", "orange", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[249], 4, 18646, "matcolours", "grey-80-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[249], 6, 18646, "matcolours", "grey-10-percent", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[249], 8, 7247, "vgncoast", "metalwheel2_128", 0x00000000);
    g_DynamicObject[250] = CreateDynamicObject(19477, -1577.3509, -2558.3581, 17.5482, 0.0000, 0.0000, 120.8001); //mazarot text
    SetDynamicObjectMaterialText(g_DynamicObject[250], 0, "Mazarot Incorporated", OBJECT_MATERIAL_SIZE_512x256, "Courier New", 30, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[251] = CreateDynamicObject(19362, -1577.2999, -2558.4440, 17.9381, 0.0000, 0.0000, 120.8001); //mazarot bg
    SetDynamicObjectMaterial(g_DynamicObject[251], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[252] = CreateDynamicObject(19325, -1577.8614, -2557.8154, 17.5137, 0.0000, 0.0000, -59.2000); //mazarot window
    SetDynamicObjectMaterial(g_DynamicObject[252], 0, 18646, "matcolours", "grey-90-percent", 0x96FFFFFF);
    g_DynamicObject[253] = CreateDynamicObject(19477, -1577.2419, -2555.2033, 0.1181, 0.0000, 0.0000, -149.0997); //mazarot text
    SetDynamicObjectMaterialText(g_DynamicObject[253], 0, "Mazarot Incorporated", OBJECT_MATERIAL_SIZE_512x256, "Courier New", 30, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[254] = CreateDynamicObject(19325, -1577.5566, -2555.3784, 6.0836, 0.0000, 0.0000, 30.8001); //mazarot window
    SetDynamicObjectMaterial(g_DynamicObject[254], 0, 18646, "matcolours", "grey-90-percent", 0x96FFFFFF);
    g_DynamicObject[255] = CreateDynamicObject(19475, -1576.8115, -2554.9331, 6.3182, 0.0000, 0.0000, -149.0997); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[255], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[256] = CreateDynamicObject(19325, -1577.9167, -2555.5937, 0.1835, 0.0000, 0.0000, 30.8001); //mazarot window
    SetDynamicObjectMaterial(g_DynamicObject[256], 0, 18646, "matcolours", "grey-90-percent", 0x96FFFFFF);
    g_DynamicObject[257] = CreateDynamicObject(363, -1577.9228, -2564.8115, 28.5645, 0.0000, 0.0000, -156.6000); //satchel
    g_DynamicObject[258] = CreateDynamicObject(19815, -1577.9863, -2716.6931, 1.0355, 270.0000, 0.0000, 270.0000); //ToolBoard1
    SetDynamicObjectMaterial(g_DynamicObject[258], 0, 18773, "tunnelsections", "metalflooring44-2", 0x00000000);
    g_DynamicObject[259] = CreateDynamicObject(19362, -1576.7392, -2554.8786, 6.3582, 0.0000, 0.0000, -149.0997); //mazarot bg
    SetDynamicObjectMaterial(g_DynamicObject[259], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[260] = CreateDynamicObject(19815, -1583.6462, -2710.1215, 1.5131, -157.6999, 0.0000, 270.0000); //ToolBoard1
    SetDynamicObjectMaterial(g_DynamicObject[260], 0, 18773, "tunnelsections", "metalflooring44-2", 0x00000000);
    g_DynamicObject[261] = CreateDynamicObject(18644, -1602.6168, -2720.8244, 3.2960, 90.3999, 0.0000, 0.0000); //Screwdriver1
    g_DynamicObject[262] = CreateDynamicObject(19921, -1603.3835, -2720.3937, 4.6767, 0.0000, 0.0000, 14.6997); //CutsceneToolBox1
    g_DynamicObject[263] = CreateDynamicObject(1428, -1601.7124, -2720.6318, 2.2407, 0.0000, 0.0000, 5.6999); //DYN_LADDER
    g_DynamicObject[264] = CreateDynamicObject(19898, -1603.0450, -2721.0852, 3.2825, 0.0000, 0.0000, -164.7998); //OilFloorStain1
    g_DynamicObject[265] = CreateDynamicObject(2229, -1582.4775, -2565.9836, -6.9755, 0.0000, 0.0000, -130.3999); //SWANK_SPEAKER
    SetDynamicObjectMaterial(g_DynamicObject[265], 0, 2225, "cj_hi_fi2", "CJ_SPEAKER3", 0xFFB22222);
    g_DynamicObject[266] = CreateDynamicObject(2965, -1577.2110, -2555.1965, 0.5080, 180.0000, 270.0000, -149.0997); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[266], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[267] = CreateDynamicObject(19475, -1577.0980, -2558.8005, 23.6683, 0.0000, 0.0000, 120.8001); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[267], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[268] = CreateDynamicObject(19475, -1589.2885, -2571.0942, -6.3453, 0.0000, 0.0000, -59.2999); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[268], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[269] = CreateDynamicObject(19089, -1628.9184, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[269], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[270] = CreateDynamicObject(19362, -1577.1562, -2555.1520, 0.5080, 0.0000, 0.0000, -149.0997); //mazarot bg
    SetDynamicObjectMaterial(g_DynamicObject[270], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[271] = CreateDynamicObject(2965, -1589.2700, -2571.1057, -6.3056, 180.0000, 270.0000, -59.2999); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[271], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[272] = CreateDynamicObject(19477, -1577.0946, -2558.7868, 23.3183, 0.0000, 0.0000, 120.8001); //mazarot text
    SetDynamicObjectMaterialText(g_DynamicObject[272], 0, "Mazarot Incorporated", OBJECT_MATERIAL_SIZE_512x256, "Courier New", 30, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[273] = CreateDynamicObject(19475, -1579.9112, -2557.7011, -4.5673, 0.0000, -0.3003, -150.0000); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[273], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[274] = CreateDynamicObject(2811, -1601.1750, -2573.3552, -7.0300, 0.0000, 0.0000, 0.0000); //GB_romanpot01
    g_DynamicObject[275] = CreateDynamicObject(2123, -1597.8924, -2572.9096, -6.3737, 0.0000, 0.0000, 178.9001); //SWANK_DIN_CHAIR_4
    SetDynamicObjectMaterial(g_DynamicObject[275], 0, 14652, "ab_trukstpa", "CJ_WOOD1(EDGE)", 0xFFD2B48C);
    g_DynamicObject[276] = CreateDynamicObject(2568, -1598.2939, -2571.2192, -7.0107, 0.0000, 0.0000, -58.8997); //Hotel_dresser_3
    SetDynamicObjectMaterial(g_DynamicObject[276], 2, 14652, "ab_trukstpa", "CJ_WOOD1(EDGE)", 0xFFD2B48C);
    g_DynamicObject[277] = CreateDynamicObject(2257, -1594.4171, -2562.5297, -4.6121, 0.0000, 0.0000, 31.0000); //Red Bridge BG
    SetDynamicObjectMaterial(g_DynamicObject[277], 1, 17555, "eastbeach3c_lae2", "gradient128", 0xFF696969);
    g_DynamicObject[278] = CreateDynamicObject(2571, -1599.0201, -2575.6467, -7.0240, 0.0000, 0.0000, 96.3000); //Hotel_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[278], 0, 14652, "ab_trukstpa", "CJ_WOOD1(EDGE)", 0xFFD2B48C);
    SetDynamicObjectMaterial(g_DynamicObject[278], 1, 14383, "burg_1", "carpet4kb", 0xFF98FB98);
    g_DynamicObject[279] = CreateDynamicObject(19934, -1589.1850, -2571.2878, -7.0054, 0.0000, 0.0000, -59.2999); //speech table
    SetDynamicObjectMaterial(g_DynamicObject[279], 0, 19267, "mapmarkers", "samporange", 0x00000000);
    g_DynamicObject[280] = CreateDynamicObject(19581, -1583.2635, -2569.5683, -5.9573, 0.0000, 0.0000, 79.0998); //MarcosFryingPan1
    g_DynamicObject[281] = CreateDynamicObject(2257, -1576.6944, -2573.6545, -4.9218, 0.0000, 0.0000, -148.6997); //Kitchen Painting
    SetDynamicObjectMaterial(g_DynamicObject[281], 1, 2254, "picture_frame_clip", "CJ_PAINTING24", 0x00000000);
    g_DynamicObject[282] = CreateDynamicObject(19482, -1588.0478, -2573.0349, -3.3473, 0.0000, 0.0000, -58.6999); //greenscreen
    SetDynamicObjectMaterial(g_DynamicObject[282], 0, 18835, "mickytextures", "whiteforletters", 0xFF00FF00);
    g_DynamicObject[283] = CreateDynamicObject(19482, -1587.9659, -2572.9733, -5.6472, 0.0000, 0.0000, -59.0998); //greenscreen
    SetDynamicObjectMaterial(g_DynamicObject[283], 0, 18835, "mickytextures", "whiteforletters", 0xFF00FF00);
    g_DynamicObject[284] = CreateDynamicObject(19928, -1586.3111, -2569.0502, -6.9857, 0.0000, 0.0000, 120.0998); //MKWorkTop4
    g_DynamicObject[285] = CreateDynamicObject(2226, -1590.6009, -2568.9245, -5.5980, -180.0000, 0.0000, -58.6999); //LOW_HI_FI_3
    SetDynamicObjectMaterial(g_DynamicObject[285], 0, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 1, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 2, 2188, "kbblackjack", "chip_tray_1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 3, 16640, "a51", "Metal3_128", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[285], 4, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 5, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 6, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 7, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[285], 8, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    g_DynamicObject[286] = CreateDynamicObject(2226, -1590.3995, -2569.2939, -5.9979, 0.0000, 0.0000, -58.6999); //LOW_HI_FI_3
    SetDynamicObjectMaterial(g_DynamicObject[286], 0, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 1, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 2, 2188, "kbblackjack", "chip_tray_1", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 3, 16640, "a51", "Metal3_128", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[286], 4, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 5, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 6, 8391, "ballys01", "CJ_blackplastic", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 7, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[286], 8, 1736, "cj_ammo", "CJ_Black_metal", 0x00000000);
    g_DynamicObject[287] = CreateDynamicObject(19482, -1591.0395, -2573.2934, -4.1873, 90.0000, 0.0000, -144.4998); //greenscreen
    SetDynamicObjectMaterial(g_DynamicObject[287], 0, 18835, "mickytextures", "whiteforletters", 0xFF00FF00);
    g_DynamicObject[288] = CreateDynamicObject(19482, -1586.4216, -2570.4704, -4.2673, 90.0000, 0.0000, 26.4999); //greenscreen
    SetDynamicObjectMaterial(g_DynamicObject[288], 0, 18835, "mickytextures", "whiteforletters", 0xFF00FF00);
    g_DynamicObject[289] = CreateDynamicObject(19482, -1588.7207, -2571.8886, -6.9664, 0.0000, 90.2001, -58.6999); //greenscreen
    SetDynamicObjectMaterial(g_DynamicObject[289], 0, 10756, "airportroads_sfse", "ws_white_wall1", 0xFF00FF00);
    g_DynamicObject[290] = CreateDynamicObject(2394, -1590.0268, -2576.5776, -5.4895, 0.0000, 0.0000, -59.0000); //CJ_CLOTHES_STEP_1
    g_DynamicObject[291] = CreateDynamicObject(19893, -1590.5899, -2568.6215, -6.1477, -360.0000, -359.9999, -121.6798); //LaptopSAMP1
    SetDynamicObjectMaterial(g_DynamicObject[291], 1, 19894, "laptopsamp1", "laptopscreen2", 0x00000000);
    g_DynamicObject[292] = CreateDynamicObject(2257, -1594.4014, -2562.5554, -4.6121, 0.0000, 0.0000, 31.0000); //Red Bridge Painting
    SetDynamicObjectMaterial(g_DynamicObject[292], 1, 10838, "airwelcomesign_sfse", "ws_airwelcome1", 0xFF191970);
    g_DynamicObject[293] = CreateDynamicObject(19475, -1577.3543, -2558.3718, 17.8981, 0.0000, 0.0000, 120.8001); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[293], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[294] = CreateDynamicObject(2767, -1590.6236, -2568.6057, -6.1677, 0.0000, 0.0000, 34.8401); //CJ_CB_TRAY
    SetDynamicObjectMaterial(g_DynamicObject[294], 0, 16640, "a51", "Metal3_128", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[294], 1, 18759, "dmcages", "metalgrid15-2", 0xFF000000);
    g_DynamicObject[295] = CreateDynamicObject(1663, -1590.4272, -2567.9450, -6.5531, 0.0000, 0.0000, -92.5998); //swivelchair_B
    SetDynamicObjectMaterial(g_DynamicObject[295], 0, 1726, "mrk_couches2", "kb_sofa5_256", 0x00000000);
    g_DynamicObject[296] = CreateDynamicObject(19924, -1582.6529, -2569.7026, -3.9897, 0.0000, 0.0000, 32.5998); //MKExtractionHood1
    g_DynamicObject[297] = CreateDynamicObject(19143, -1593.1003, -2568.7502, -3.0826, 180.0000, 180.0000, 53.9000); //PinSpotLight1
    g_DynamicObject[298] = CreateDynamicObject(19929, -1584.7187, -2568.0900, -6.9800, 0.0000, 0.0000, 120.3999); //MKWorkTop5
    g_DynamicObject[299] = CreateDynamicObject(3386, -1589.8492, -2565.4260, -7.0166, 0.0000, 0.0000, 121.1996); //a51_srack2_
    SetDynamicObjectMaterial(g_DynamicObject[299], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[300] = CreateDynamicObject(19927, -1585.6274, -2570.2653, -6.9892, 0.0000, 0.0000, -149.8002); //MKWorkTop3
    g_DynamicObject[301] = CreateDynamicObject(19916, -1582.2135, -2566.6511, -7.0064, 0.0000, 0.0000, 30.7999); //CutsceneFridge1
    g_DynamicObject[302] = CreateDynamicObject(19923, -1582.6511, -2569.6513, -6.9868, 0.0000, 0.0000, -149.3999); //MKIslandCooker1
    g_DynamicObject[303] = CreateDynamicObject(19933, -1583.6772, -2567.6770, -6.5665, 0.0000, 0.0000, 121.0998); //MKWallOven1
    g_DynamicObject[304] = CreateDynamicObject(19143, -1592.3636, -2567.9831, -3.0826, 180.0000, 180.0000, 42.2999); //PinSpotLight1
    g_DynamicObject[305] = CreateDynamicObject(19936, -1586.2607, -2569.0549, -5.2669, 0.0000, 0.0000, -149.0001); //MKCupboard3
    g_DynamicObject[306] = CreateDynamicObject(19937, -1585.1700, -2568.0954, -5.2656, 0.0000, 0.0000, -58.9001); //MKCupboard4
    g_DynamicObject[307] = CreateDynamicObject(19143, -1591.6717, -2567.1884, -3.0826, 180.0000, 180.0000, 30.2000); //PinSpotLight1
    g_DynamicObject[308] = CreateDynamicObject(19937, -1585.7668, -2570.3889, -5.2754, 0.0000, 0.0000, 30.6998); //MKCupboard4
    g_DynamicObject[309] = CreateDynamicObject(19143, -1590.7076, -2566.9851, -3.0826, 180.0000, 180.0000, 21.2999); //PinSpotLight1
    g_DynamicObject[310] = CreateDynamicObject(19937, -1583.5340, -2567.1076, -5.2656, 0.0000, 0.0000, -58.9001); //MKCupboard4
    g_DynamicObject[311] = CreateDynamicObject(19143, -1589.6247, -2566.7416, -3.0826, 180.0000, 180.0000, 4.6999); //PinSpotLight1
    g_DynamicObject[312] = CreateDynamicObject(3388, -1593.0268, -2567.3483, -7.0061, 0.0000, 0.0000, 120.4000); //a51_srack4_
    SetDynamicObjectMaterial(g_DynamicObject[312], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[313] = CreateDynamicObject(3389, -1593.8907, -2567.8518, -6.9875, 0.0000, 0.0000, 120.3999); //a51_srack1_
    SetDynamicObjectMaterial(g_DynamicObject[313], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[314] = CreateDynamicObject(19464, -1581.9399, -2558.3129, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[314], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[315] = CreateDynamicObject(3387, -1590.6993, -2565.9353, -7.0145, 0.0000, 0.0000, 120.5998); //a51_srack3_
    SetDynamicObjectMaterial(g_DynamicObject[315], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[316] = CreateDynamicObject(19422, -1590.0954, -2568.0266, -6.2203, 87.9999, 0.0000, -1.7999); //headphones02
    g_DynamicObject[317] = CreateDynamicObject(19993, -1590.1899, -2569.6218, -5.8681, -359.9999, -90.0000, 121.5000); //CutsceneBowl1
    SetDynamicObjectMaterial(g_DynamicObject[317], 0, 2600, "external", "CJ_LENS", 0x00000000);
    g_DynamicObject[318] = CreateDynamicObject(19611, -1589.1804, -2571.2834, -2.4934, 180.0000, 0.0000, 32.0998); //MicrophoneStand1
    g_DynamicObject[319] = CreateDynamicObject(19317, -1587.6800, -2566.4123, -6.2616, -67.7994, 1.7999, -149.0001); //bassguitar01
    g_DynamicObject[320] = CreateDynamicObject(19929, -1583.7856, -2567.5749, -6.9699, 0.0000, 0.0000, 120.3999); //MKWorkTop5
    g_DynamicObject[321] = CreateDynamicObject(2310, -1577.1622, -2571.1708, -6.5124, 0.0000, 0.0000, 30.0000); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[321], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[321], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[322] = CreateDynamicObject(19922, -1578.3260, -2570.7307, -7.0033, 0.0000, 0.0000, 120.4000); //MKTable1
    g_DynamicObject[323] = CreateDynamicObject(1805, -1579.7381, -2574.7543, -6.7319, 0.0000, 0.0000, 31.1000); //CJ_BARSTOOL
    g_DynamicObject[324] = CreateDynamicObject(19940, -1582.8525, -2575.2685, -5.2753, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[325] = CreateDynamicObject(2310, -1577.5526, -2570.4941, -6.5124, 0.0000, 0.0000, 30.0000); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[325], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[325], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[326] = CreateDynamicObject(19929, -1580.9350, -2574.5761, -6.9800, 0.0000, 0.0000, -149.2001); //MKWorkTop5
    g_DynamicObject[327] = CreateDynamicObject(2149, -1586.1103, -2569.0874, -5.9183, 0.0000, 0.0000, 73.4000); //CJ_MICROWAVE1
    g_DynamicObject[328] = CreateDynamicObject(1805, -1580.1385, -2574.1682, -6.7319, 0.0000, 0.0000, 31.1000); //CJ_BARSTOOL
    g_DynamicObject[329] = CreateDynamicObject(1805, -1580.5616, -2573.5256, -6.7319, 0.0000, 0.0000, 31.1000); //CJ_BARSTOOL
    g_DynamicObject[330] = CreateDynamicObject(19087, -1578.3243, -2570.8291, -1.9275, 0.0000, 0.0000, -60.6999); //Rope1
    SetDynamicObjectMaterial(g_DynamicObject[330], 0, 14629, "ab_chande", "ab_goldpipe", 0xFFFFFF00);
    g_DynamicObject[331] = CreateDynamicObject(19925, -1584.9272, -2571.4572, -6.9969, 0.0000, 0.0000, 120.8998); //MKWorkTop1
    g_DynamicObject[332] = CreateDynamicObject(19929, -1582.4615, -2575.4887, -6.9800, 0.0000, 0.0000, -149.2001); //MKWorkTop5
    g_DynamicObject[333] = CreateDynamicObject(2708, -1589.0107, -2577.9963, -7.2290, 0.0000, 0.0000, -59.0000); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[333], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[334] = CreateDynamicObject(19940, -1581.8479, -2576.9758, -5.2753, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[335] = CreateDynamicObject(19925, -1579.5019, -2564.9462, -6.9857, 0.0000, 0.0000, 31.2000); //MKWorkTop1
    g_DynamicObject[336] = CreateDynamicObject(19938, -1585.1798, -2571.3793, -5.2553, 0.0000, 0.0000, 121.2994); //MKShelf1
    g_DynamicObject[337] = CreateDynamicObject(19940, -1582.8413, -2575.2536, -4.3151, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[338] = CreateDynamicObject(19940, -1582.8575, -2575.2617, -4.7753, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[339] = CreateDynamicObject(19940, -1581.8414, -2576.9831, -4.7753, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[340] = CreateDynamicObject(19938, -1585.1798, -2571.3793, -4.2652, 0.0000, 0.0000, 121.2994); //MKShelf1
    g_DynamicObject[341] = CreateDynamicObject(19938, -1585.1798, -2571.3793, -4.7550, 0.0000, 0.0000, 121.2994); //MKShelf1
    g_DynamicObject[342] = CreateDynamicObject(19569, -1582.8719, -2570.1464, -5.9998, 0.0000, 0.0000, 0.0000); //MilkCarton1
    g_DynamicObject[343] = CreateDynamicObject(19830, -1583.0665, -2566.9753, -6.0472, 0.0000, 0.0000, 7.5998); //Blender1
    g_DynamicObject[344] = CreateDynamicObject(19929, -1578.3269, -2565.4050, -6.9800, 0.0000, 0.0000, 30.5998); //MKWorkTop5
    g_DynamicObject[345] = CreateDynamicObject(2310, -1577.9377, -2569.8298, -6.5124, 0.0000, 0.0000, 30.0000); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[345], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[345], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[346] = CreateDynamicObject(19925, -1577.3702, -2567.0004, -6.9857, 0.0000, 0.0000, 31.2000); //MKWorkTop1
    g_DynamicObject[347] = CreateDynamicObject(2310, -1579.2641, -2570.5712, -6.5124, 0.0000, 0.0000, -148.3999); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[347], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[347], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[348] = CreateDynamicObject(2310, -1578.8127, -2571.3061, -6.5124, 0.0000, 0.0000, -148.3999); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[348], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[348], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[349] = CreateDynamicObject(2310, -1578.4399, -2571.9125, -6.5124, 0.0000, 0.0000, -148.3999); //MIKE_DIN_CHAIR
    SetDynamicObjectMaterial(g_DynamicObject[349], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[349], 1, 16322, "a51_stores", "metalic128", 0xFFD2B48C);
    g_DynamicObject[350] = CreateDynamicObject(2311, -1586.8066, -2564.7792, -6.9801, 0.0000, 0.0000, 32.4000); //CJ_TV_TABLE2
    SetDynamicObjectMaterial(g_DynamicObject[350], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    g_DynamicObject[351] = CreateDynamicObject(19940, -1581.8243, -2576.9750, -4.3151, 0.0000, 0.0000, 30.5000); //MKShelf3
    g_DynamicObject[352] = CreateDynamicObject(3009, -1576.0533, -2709.1694, 1.0497, 28.0000, 64.0005, -54.1002); //chopcop_armL
    SetDynamicObjectMaterial(g_DynamicObject[352], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[353] = CreateDynamicObject(19482, -1578.1545, -2570.9672, -6.9491, 0.0000, -89.9001, 30.7000); //kitchen rug
    SetDynamicObjectMaterial(g_DynamicObject[353], 0, 14590, "mafcastopfoor", "ab_carpet01", 0xFFD2B48C);
    g_DynamicObject[354] = CreateDynamicObject(19937, -1581.3519, -2574.2858, -5.0553, 0.0000, 0.0000, 30.6998); //MKCupboard4
    g_DynamicObject[355] = CreateDynamicObject(19937, -1580.3774, -2575.9282, -5.0553, 0.0000, 0.0000, 30.6998); //MKCupboard4
    g_DynamicObject[356] = CreateDynamicObject(19087, -1582.0024, -2573.5808, -1.5901, 0.0000, 0.0000, -61.0998); //Rope1
    SetDynamicObjectMaterial(g_DynamicObject[356], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    g_DynamicObject[357] = CreateDynamicObject(19087, -1581.6545, -2573.3908, -1.5901, 0.0000, 0.0000, -61.0998); //Rope1
    SetDynamicObjectMaterial(g_DynamicObject[357], 0, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    g_DynamicObject[358] = CreateDynamicObject(18673, -1582.8048, -2569.6052, -7.5071, 0.0000, 0.0000, 29.3999); //cigarette_smoke
    g_DynamicObject[359] = CreateDynamicObject(19937, -1578.4663, -2564.7656, -5.2656, 0.0000, 0.0000, -148.4998); //MKCupboard4
    g_DynamicObject[360] = CreateDynamicObject(19937, -1577.4792, -2566.3779, -5.2656, 0.0000, 0.0000, -148.4998); //MKCupboard4
    g_DynamicObject[361] = CreateDynamicObject(19936, -1579.2143, -2564.8381, -5.2669, 0.0000, 0.0000, 121.3999); //MKCupboard3
    g_DynamicObject[362] = CreateDynamicObject(19560, -1583.7728, -2567.3815, -6.0472, 0.0000, 0.0000, 75.5998); //MeatTray1
    g_DynamicObject[363] = CreateDynamicObject(19583, -1583.3640, -2567.5163, -6.0373, 0.0000, 0.0000, -155.8999); //MarcosKnife1
    g_DynamicObject[364] = CreateDynamicObject(19586, -1583.4625, -2569.7426, -6.0071, 0.0000, 0.0000, 50.3997); //MarcosSpatula1
    g_DynamicObject[365] = CreateDynamicObject(19820, -1582.0738, -2576.4165, -6.0889, 0.0000, 0.0000, -29.1000); //AlcoholBottle1
    g_DynamicObject[366] = CreateDynamicObject(19821, -1582.2805, -2576.2219, -6.0689, 0.0000, 0.0000, 0.0000); //AlcoholBottle2
    g_DynamicObject[367] = CreateDynamicObject(19822, -1582.1074, -2575.8801, -6.0640, 0.0000, 0.0000, 0.0000); //AlcoholBottle3
    g_DynamicObject[368] = CreateDynamicObject(19823, -1582.5107, -2575.6127, -6.0398, 0.0000, 0.0000, 114.7994); //AlcoholBottle4
    g_DynamicObject[369] = CreateDynamicObject(19824, -1582.9825, -2575.0229, -6.0489, 0.0000, 0.0000, 0.0000); //AlcoholBottle5
    g_DynamicObject[370] = CreateDynamicObject(19819, -1583.1566, -2574.6791, -5.1704, 0.0000, 0.0000, 30.7000); //CocktailGlass1
    g_DynamicObject[371] = CreateDynamicObject(19819, -1583.0852, -2574.9167, -5.1704, 0.0000, 0.0000, 30.7000); //CocktailGlass1
    g_DynamicObject[372] = CreateDynamicObject(19819, -1582.8492, -2575.1354, -5.1704, 0.0000, 0.0000, 30.7000); //CocktailGlass1
    g_DynamicObject[373] = CreateDynamicObject(19819, -1582.7657, -2575.4111, -5.1704, 0.0000, 0.0000, 16.1000); //CocktailGlass1
    g_DynamicObject[374] = CreateDynamicObject(1541, -1580.8927, -2575.6081, -5.8769, 0.0000, 0.0000, 121.0998); //CJ_BEER_TAPS_1
    g_DynamicObject[375] = CreateDynamicObject(19572, -1582.0826, -2576.5573, -5.2603, 0.0000, 0.0000, -50.7999); //PisshBox1
    g_DynamicObject[376] = CreateDynamicObject(19818, -1582.4499, -2575.8579, -4.6838, 0.0000, 0.0000, 0.0000); //WineGlass1
    g_DynamicObject[377] = CreateDynamicObject(19818, -1582.3098, -2576.1582, -4.6838, 0.0000, 0.0000, -62.5000); //WineGlass1
    g_DynamicObject[378] = CreateDynamicObject(19818, -1582.1368, -2576.3378, -4.6838, 0.0000, 0.0000, -62.5000); //WineGlass1
    g_DynamicObject[379] = CreateDynamicObject(19482, -1586.1428, -2564.4033, -6.9538, 0.0000, 270.0000, -58.4000); //living room rug
    SetDynamicObjectMaterial(g_DynamicObject[379], 0, 14407, "carter_block", "zebra_skin", 0xFF696969);
    g_DynamicObject[380] = CreateDynamicObject(11744, -1577.8144, -2570.6572, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[380], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[381] = CreateDynamicObject(2247, -1578.3801, -2570.7416, -5.9295, 0.0000, 0.0000, 0.0000); //Plant_Pot_15
    g_DynamicObject[382] = CreateDynamicObject(11744, -1577.4365, -2571.3295, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[382], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[383] = CreateDynamicObject(11744, -1578.2081, -2569.9597, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[383], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[384] = CreateDynamicObject(11744, -1579.0516, -2570.4345, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[384], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[385] = CreateDynamicObject(11744, -1578.6496, -2571.1274, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[385], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[386] = CreateDynamicObject(11744, -1578.2717, -2571.8027, -6.1999, 0.0000, 0.0000, 29.5000); //MPlate1
    SetDynamicObjectMaterial(g_DynamicObject[386], 0, 2822, "gb_cleancrock01", "cj_plate2", 0x00000000);
    g_DynamicObject[387] = CreateDynamicObject(19621, -1603.2768, -2720.8745, 3.3689, 0.0000, 0.0000, -104.7994); //OilCan1
    g_DynamicObject[388] = CreateDynamicObject(11715, -1578.1435, -2570.1027, -6.2090, 2.2000, 0.0000, 121.2994); //MetalFork1
    g_DynamicObject[389] = CreateDynamicObject(11716, -1578.2945, -2569.8310, -6.2100, 0.0000, 0.0000, 120.5000); //MetalKnife1
    g_DynamicObject[390] = CreateDynamicObject(11715, -1577.7207, -2570.7949, -6.2090, 2.2000, 0.0000, 121.2994); //MetalFork1
    g_DynamicObject[391] = CreateDynamicObject(11716, -1577.8861, -2570.5175, -6.2100, 0.0000, 0.0000, 120.5000); //MetalKnife1
    g_DynamicObject[392] = CreateDynamicObject(11715, -1577.3177, -2571.4528, -6.2090, 2.2000, 0.0000, 121.2994); //MetalFork1
    g_DynamicObject[393] = CreateDynamicObject(11716, -1577.4991, -2571.1708, -6.2100, 0.0000, 0.0000, 120.5000); //MetalKnife1
    g_DynamicObject[394] = CreateDynamicObject(18725, -1583.5633, -2567.9145, -8.2047, 0.0000, 0.0000, 31.3999); //smoke30lit
    g_DynamicObject[395] = CreateDynamicObject(11715, -1578.7314, -2570.9816, -6.2013, 2.2000, 0.0000, -58.0998); //MetalFork1
    g_DynamicObject[396] = CreateDynamicObject(11715, -1578.3714, -2571.6530, -6.2031, 2.2000, 0.0000, -58.0998); //MetalFork1
    g_DynamicObject[397] = CreateDynamicObject(11715, -1579.1333, -2570.2941, -6.2005, 2.2000, 0.0000, -60.0000); //MetalFork1
    g_DynamicObject[398] = CreateDynamicObject(11716, -1578.9591, -2570.5927, -6.2100, 0.0000, 0.0000, -61.0998); //MetalKnife1
    g_DynamicObject[399] = CreateDynamicObject(11716, -1578.5769, -2571.2866, -6.2100, 0.0000, 0.0000, -61.0998); //MetalKnife1
    g_DynamicObject[400] = CreateDynamicObject(11716, -1578.2032, -2571.9633, -6.2100, 0.0000, 0.0000, -61.0998); //MetalKnife1
    g_DynamicObject[401] = CreateDynamicObject(2250, -1578.2790, -2570.8542, -5.9702, 0.0000, 0.0000, 132.2998); //Plant_Pot_19
    g_DynamicObject[402] = CreateDynamicObject(2028, -1584.0522, -2566.3491, -6.3884, 0.0000, 0.0000, -149.6999); //SWANK_CONSOLE
    g_DynamicObject[403] = CreateDynamicObject(1666, -1578.3197, -2570.8173, -6.1251, 0.0000, 0.0000, 0.0000); //propbeerglass1
    SetDynamicObjectMaterial(g_DynamicObject[403], 0, 18889, "forcefields", "glass1", 0x00000000);
    g_DynamicObject[404] = CreateDynamicObject(19481, -1579.8122, -2734.5268, 4.9626, 0.0000, 0.0000, 89.9999); //subdock incorp
    SetDynamicObjectMaterialText(g_DynamicObject[404], 0, "INCORPORATED", OBJECT_MATERIAL_SIZE_512x256, "Verdana", 30, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[405] = CreateDynamicObject(2104, -1583.1512, -2566.4121, -6.9762, 0.0000, 0.0000, -149.1999); //SWANK_HI_FI
    g_DynamicObject[406] = CreateDynamicObject(2313, -1583.9802, -2566.2509, -6.9766, 0.0000, 0.0000, -148.6999); //CJ_TV_TABLE1
    SetDynamicObjectMaterial(g_DynamicObject[406], 2, 14789, "ab_sfgymmain", "ab_wood02", 0x00000000);
    g_DynamicObject[407] = CreateDynamicObject(1719, -1584.8745, -2566.8415, -6.4689, 0.0000, 0.0000, -149.7998); //LOW_CONSOLE
    g_DynamicObject[408] = CreateDynamicObject(11724, -1587.5179, -2558.7180, -6.4643, 0.0000, 0.0000, 30.2999); //FireplaceSurround1
    SetDynamicObjectMaterial(g_DynamicObject[408], 0, 14623, "mafcasmain", "ab_tileStar", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[408], 1, 3314, "ce_burbhouse", "sw_wallbrick_06", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[408], 2, 10871, "blacksky_sfse", "ws_blackmarble", 0x00000000);
    g_DynamicObject[409] = CreateDynamicObject(1736, -1587.4355, -2558.9057, -4.3273, 0.0000, 0.0000, 30.9999); //CJ_Stags_head
    SetDynamicObjectMaterial(g_DynamicObject[409], 1, -1, "none", "none", 0xFFFF0000);
    g_DynamicObject[410] = CreateDynamicObject(2232, -1586.1031, -2567.6757, -6.3768, 0.0000, 0.0000, -148.8000); //MED_SPEAKER_4
    SetDynamicObjectMaterial(g_DynamicObject[410], 0, 2225, "cj_hi_fi2", "CJ_SPEAKER3", 0xFFB22222);
    g_DynamicObject[411] = CreateDynamicObject(2229, -1587.2019, -2568.4067, -6.9755, 0.0000, 0.0000, -174.1000); //SWANK_SPEAKER
    SetDynamicObjectMaterial(g_DynamicObject[411], 0, 2225, "cj_hi_fi2", "CJ_SPEAKER3", 0xFFB22222);
    g_DynamicObject[412] = CreateDynamicObject(19873, -1585.8210, -2563.9709, -6.4088, 0.0000, 0.0000, 0.0000); //ToiletPaperRoll1
    g_DynamicObject[413] = CreateDynamicObject(2291, -1587.9516, -2566.1682, -7.0664, 0.0000, 0.0000, 121.0998); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[413], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[414] = CreateDynamicObject(2292, -1589.2004, -2564.1684, -7.0770, 0.0000, 0.0000, 31.5000); //SWK_SINGLE_1b
    SetDynamicObjectMaterial(g_DynamicObject[414], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[415] = CreateDynamicObject(2292, -1587.5373, -2563.1496, -7.0770, 0.0000, 0.0000, 31.5000); //SWK_SINGLE_1b
    SetDynamicObjectMaterial(g_DynamicObject[415], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[416] = CreateDynamicObject(2291, -1586.3341, -2562.4094, -7.0664, 0.0000, 0.0000, 31.6000); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[416], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[417] = CreateDynamicObject(2291, -1584.3994, -2562.8010, -7.0664, 0.0000, 0.0000, -58.0000); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[417], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[418] = CreateDynamicObject(2291, -1584.8807, -2562.0288, -7.0664, 0.0000, 0.0000, -58.0000); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[418], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[419] = CreateDynamicObject(2292, -1583.6456, -2563.9992, -7.0770, 0.0000, 0.0000, -147.6999); //SWK_SINGLE_1b
    SetDynamicObjectMaterial(g_DynamicObject[419], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[420] = CreateDynamicObject(19786, -1584.2690, -2567.1542, -5.4292, 0.0000, 0.0000, -149.0000); //LCDTVBig1
    SetDynamicObjectMaterial(g_DynamicObject[420], 1, 19165, "gtamap", "paperbacking", 0x00000000);
    g_DynamicObject[421] = CreateDynamicObject(2291, -1587.1263, -2562.8969, -7.0664, 0.0000, 0.0000, 31.6000); //SWK_SINGLE_1
    SetDynamicObjectMaterial(g_DynamicObject[421], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[422] = CreateDynamicObject(2292, -1587.7408, -2566.5661, -7.0770, 0.0000, 0.0000, 121.4000); //SWK_SINGLE_1b
    SetDynamicObjectMaterial(g_DynamicObject[422], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[423] = CreateDynamicObject(19377, -1588.8680, -2564.4785, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[423], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[424] = CreateDynamicObject(19920, -1585.4188, -2563.8576, -6.4601, 5.9000, 0.0000, -154.0997); //CutsceneRemote1
    g_DynamicObject[425] = CreateDynamicObject(2292, -1585.1125, -2561.6293, -7.0770, 0.0000, 0.0000, -58.8997); //SWK_SINGLE_1b
    SetDynamicObjectMaterial(g_DynamicObject[425], 0, 9818, "ship_brijsfw", "blchr_seat2b", 0xFFCD853F);
    g_DynamicObject[426] = CreateDynamicObject(11725, -1587.4681, -2558.8110, -6.5805, 0.0000, 0.0000, 30.7000); //Fireplace1
    g_DynamicObject[427] = CreateDynamicObject(18762, -1587.8081, -2558.2263, -5.5478, 0.0000, 0.0000, 31.0000); //chimney
    SetDynamicObjectMaterial(g_DynamicObject[427], 0, 3314, "ce_burbhouse", "sw_wallbrick_06", 0x00000000);
    g_DynamicObject[428] = CreateDynamicObject(11726, -1586.1783, -2564.3176, -4.0784, 0.0000, 0.0000, 0.0000); //HangingLight1
    g_DynamicObject[429] = CreateDynamicObject(11727, -1603.0515, -2720.3513, 3.8320, 0.0000, 0.0000, 5.9998); //PaperChaseLight1
    SetDynamicObjectMaterial(g_DynamicObject[429], 0, 7247, "vgncoast", "metalwheel2_128", 0xFFC0C0C0);
    g_DynamicObject[430] = CreateDynamicObject(19562, -1585.1711, -2571.3654, -5.2437, 0.0000, 0.0000, 74.5998); //CerealBox2
    g_DynamicObject[431] = CreateDynamicObject(3273, -1575.2967, -2706.3901, 0.5726, 0.0000, 0.0000, 0.0000); //substa_transf2_
    g_DynamicObject[432] = CreateDynamicObject(19814, -1580.5736, -2564.8107, -6.6373, 0.0000, 0.0000, -148.3002); //ElectricalOutlet2
    SetDynamicObjectMaterial(g_DynamicObject[432], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[433] = CreateDynamicObject(19828, -1589.7873, -2564.0642, -5.8962, 0.0000, 0.0000, 121.5998); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[433], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[434] = CreateDynamicObject(18075, -1580.1866, -2559.5058, -3.0868, 0.0000, 0.0000, -59.0998); //lightD
    g_DynamicObject[435] = CreateDynamicObject(2257, -1582.6350, -2557.4255, -4.9116, 0.0000, 0.0000, -58.8996); //skull painting
    SetDynamicObjectMaterial(g_DynamicObject[435], 1, 8421, "pirateland", "tislndskullrock_256", 0x00000000);
    g_DynamicObject[436] = CreateDynamicObject(2257, -1581.1545, -2559.9145, -4.8719, 0.0000, 180.0000, -58.8996); //skull painting
    SetDynamicObjectMaterial(g_DynamicObject[436], 1, 8421, "pirateland", "tislndskullrock_256", 0xFFC0C0C0);
    g_DynamicObject[437] = CreateDynamicObject(19935, -1579.5788, -2561.0131, -5.0486, 0.0000, 0.0000, -58.7000); //MKCupboard2
    SetDynamicObjectMaterial(g_DynamicObject[437], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[438] = CreateDynamicObject(2257, -1585.3249, -2557.0705, -4.9317, 0.0000, 0.0000, 31.1004); //V Rock Painting
    SetDynamicObjectMaterial(g_DynamicObject[438], 1, 6864, "vgnvrock", "vrocksign1_256", 0xFF696969);
    g_DynamicObject[439] = CreateDynamicObject(1708, -1592.8979, -2562.5402, -6.9847, 0.0000, 0.0000, 0.0000); //kb_chair02
    SetDynamicObjectMaterial(g_DynamicObject[439], 1, 2023, "bitsnbobs", "CJ_LIGHTWOOD", 0xFFD2B48C);
    SetDynamicObjectMaterial(g_DynamicObject[439], 2, 18901, "matclothes", "hatmap1", 0xFF191970);
    g_DynamicObject[440] = CreateDynamicObject(19631, -1583.2740, -2701.0273, 1.8772, 0.0000, 87.1996, -34.9000); //SledgeHammer1
    g_DynamicObject[441] = CreateDynamicObject(2257, -1579.7220, -2562.2849, -4.9119, 0.0000, 0.0000, -58.8996); //skull painting
    SetDynamicObjectMaterial(g_DynamicObject[441], 1, 8421, "pirateland", "tislndskullrock_256", 0xFF696969);
    g_DynamicObject[442] = CreateDynamicObject(1708, -1595.5499, -2564.6416, -6.9847, 0.0000, 0.0000, 58.7999); //kb_chair02
    SetDynamicObjectMaterial(g_DynamicObject[442], 1, 2023, "bitsnbobs", "CJ_LIGHTWOOD", 0xFFD2B48C);
    SetDynamicObjectMaterial(g_DynamicObject[442], 2, 18901, "matclothes", "hatmap1", 0xFF191970);
    g_DynamicObject[443] = CreateDynamicObject(19786, -1578.0832, -2564.6950, -4.9826, 0.0000, 0.0000, 121.1996); //LCDTVBig1
    SetDynamicObjectMaterial(g_DynamicObject[443], 1, 6357, "sunstrans_law2", "SunBillB10", 0x00000000);
    g_DynamicObject[444] = CreateDynamicObject(2257, -1590.2606, -2560.0373, -4.9317, 0.0000, 0.0000, 31.1004); //Love Fist Painting
    SetDynamicObjectMaterial(g_DynamicObject[444], 1, 6354, "sunset03_law2", "billLA01", 0x00000000);
    g_DynamicObject[445] = CreateDynamicObject(2292, -1578.1042, -2553.3068, -7.0061, 0.0000, 0.0000, -59.0998); //SWK_SINGLE_1b
    g_DynamicObject[446] = CreateDynamicObject(18635, -1581.9675, -2556.9484, -6.8554, -86.5000, 0.0000, 44.5998); //GTASAHammer1
    g_DynamicObject[447] = CreateDynamicObject(19925, -1578.8022, -2560.2756, -6.9878, 0.0000, 0.0000, 121.1996); //MKWorkTop1
    SetDynamicObjectMaterial(g_DynamicObject[447], 0, 2176, "casino_props", "marblebox", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[447], 1, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[448] = CreateDynamicObject(19929, -1581.2462, -2556.2487, -6.9800, 0.0000, 0.0000, -148.6002); //MKWorkTop5
    SetDynamicObjectMaterial(g_DynamicObject[448], 0, 2176, "casino_props", "marblebox", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[448], 1, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[449] = CreateDynamicObject(19893, -1580.5660, -2557.9162, -6.0615, 0.0000, 0.0000, -58.3997); //LaptopSAMP1
    SetDynamicObjectMaterialText(g_DynamicObject[449], 1, ":(", OBJECT_MATERIAL_SIZE_512x512, "Arial", 255, 1, 0xFFFFFFFF, 0xFF4169E1, 1);
    g_DynamicObject[450] = CreateDynamicObject(19477, -1578.0782, -2704.8884, 4.0205, 0.0000, 0.0000, 179.3997); //transform employes
    SetDynamicObjectMaterial(g_DynamicObject[450], 0, 969, "electricgate", "KeepOut_64", 0x00000000);
    g_DynamicObject[451] = CreateDynamicObject(18673, -1580.5227, -2557.8947, -7.6384, 0.0000, 0.0000, 30.7000); //cigarette_smoke
    g_DynamicObject[452] = CreateDynamicObject(955, -1574.0843, -2570.2160, -6.5791, 0.0000, 0.0000, 120.9999); //CJ_EXT_SPRUNK
    g_DynamicObject[453] = CreateDynamicObject(19937, -1581.4001, -2555.7478, -5.0380, 0.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[453], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[454] = CreateDynamicObject(19937, -1580.3967, -2557.3737, -5.0380, 0.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[454], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[455] = CreateDynamicObject(19937, -1579.4045, -2558.9831, -5.0380, 0.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[455], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[456] = CreateDynamicObject(19929, -1579.7611, -2558.6809, -6.9800, 0.0000, 0.0000, -148.6002); //MKWorkTop5
    SetDynamicObjectMaterial(g_DynamicObject[456], 0, 2176, "casino_props", "marblebox", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[456], 1, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[457] = CreateDynamicObject(19936, -1578.8889, -2560.3015, -5.0451, 0.0000, 0.0000, -148.2998); //MKCupboard3
    SetDynamicObjectMaterial(g_DynamicObject[457], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[458] = CreateDynamicObject(2293, -1578.8778, -2553.7814, -6.9924, 0.0000, 0.0000, 31.1000); //SWK_1_FStool
    g_DynamicObject[459] = CreateDynamicObject(2291, -1577.8614, -2553.6875, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[460] = CreateDynamicObject(2291, -1577.3701, -2554.4682, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[461] = CreateDynamicObject(2291, -1576.8819, -2555.2614, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[462] = CreateDynamicObject(638, -1575.1346, -2558.0913, -6.2940, 0.0000, 0.0000, 30.5998); //kb_planter+bush
    SetDynamicObjectMaterial(g_DynamicObject[462], 0, 17005, "farmhouse", "sjmbigold6", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[462], 1, 17958, "burnsalpha", "plantb256", 0x00000000);
    g_DynamicObject[463] = CreateDynamicObject(2001, -1574.5316, -2571.7319, -6.9791, 0.0000, 0.0000, 31.8999); //nu_plant_ofc
    SetDynamicObjectMaterial(g_DynamicObject[463], 0, 17958, "burnsalpha", "plantb256", 0x00000000);
    g_DynamicObject[464] = CreateDynamicObject(2291, -1573.9161, -2560.2270, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[465] = CreateDynamicObject(2291, -1573.4261, -2561.0402, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[466] = CreateDynamicObject(11743, -1578.2341, -2565.4003, -6.0594, 0.0000, 0.0000, -57.0998); //MCoffeeMachine1
    g_DynamicObject[467] = CreateDynamicObject(19935, -1579.5788, -2561.0131, -3.0188, 180.0000, 0.0000, -58.7000); //MKCupboard2
    SetDynamicObjectMaterial(g_DynamicObject[467], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[468] = CreateDynamicObject(19835, -1580.6118, -2557.5209, -5.9653, 0.0000, 0.0000, -142.1999); //CoffeeCup1
    g_DynamicObject[469] = CreateDynamicObject(2292, -1568.9858, -2568.4492, -7.0061, 0.0000, 0.0000, -149.0997); //SWK_SINGLE_1b
    g_DynamicObject[470] = CreateDynamicObject(2257, -1593.1230, -2570.6347, -4.9218, 0.0000, 0.0000, -59.0996); //Desert Painting
    SetDynamicObjectMaterial(g_DynamicObject[470], 1, 2254, "picture_frame_clip", "CJ_PAINTING26", 0x00000000);
    g_DynamicObject[471] = CreateDynamicObject(2291, -1569.7401, -2567.2167, -7.0219, 0.0000, 0.0000, -58.2999); //SWK_SINGLE_1
    g_DynamicObject[472] = CreateDynamicObject(2292, -1569.9770, -2566.8300, -7.0061, 0.0000, 0.0000, -59.0998); //SWK_SINGLE_1b
    g_DynamicObject[473] = CreateDynamicObject(2291, -1569.3653, -2568.6857, -7.0219, 0.0000, 0.0000, -148.1999); //SWK_SINGLE_1
    g_DynamicObject[474] = CreateDynamicObject(19936, -1578.8940, -2560.2932, -2.9951, 180.0000, 0.0000, 121.7002); //MKCupboard3
    SetDynamicObjectMaterial(g_DynamicObject[474], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[475] = CreateDynamicObject(19937, -1579.4045, -2558.9831, -2.9981, 180.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[475], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[476] = CreateDynamicObject(1820, -1594.0329, -2564.0676, -6.9917, 0.0000, 0.0000, 32.7999); //COFFEE_LOW_4
    SetDynamicObjectMaterial(g_DynamicObject[476], 0, 2023, "bitsnbobs", "CJ_LIGHTWOOD", 0xFFD2B48C);
    g_DynamicObject[477] = CreateDynamicObject(19871, -1593.8902, -2563.3752, -7.2870, 0.0000, 0.0000, 28.6000); //CordonStand1
    g_DynamicObject[478] = CreateDynamicObject(1276, -1593.8728, -2563.3789, -6.0159, 0.0000, 0.0000, 0.0000); //package1
    SetDynamicObjectMaterial(g_DynamicObject[478], 0, 9683, "goldengate_sfw", "ws_goldengate1", 0x00000000);
    g_DynamicObject[479] = CreateDynamicObject(19937, -1580.4139, -2557.3518, -2.9981, 180.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[479], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[480] = CreateDynamicObject(19937, -1581.4106, -2555.7297, -2.9981, 180.0000, 0.0000, 31.7000); //MKCupboard4
    SetDynamicObjectMaterial(g_DynamicObject[480], 0, 17555, "eastbeach3c_lae2", "gradient128", 0xFFD2691E);
    g_DynamicObject[481] = CreateDynamicObject(19870, -1576.1611, -2711.7158, 0.9215, 0.0000, 270.0000, 0.0000); //MeshFence3
    SetDynamicObjectMaterial(g_DynamicObject[481], 0, 10806, "airfence_sfse", "ws_griddyfence", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[481], 1, 19165, "gtamap", "metal1-128x128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[481], 2, -1, "none", "none", 0x00FFFFFF);
    g_DynamicObject[482] = CreateDynamicObject(19870, -1577.9809, -2704.8769, 0.9276, 0.0000, 270.0000, 89.4000); //MeshFence3
    SetDynamicObjectMaterial(g_DynamicObject[482], 0, 10806, "airfence_sfse", "ws_griddyfence", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[482], 1, 19165, "gtamap", "metal1-128x128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[482], 2, -1, "none", "none", 0x00FFFFFF);
    g_DynamicObject[483] = CreateDynamicObject(19870, -1576.1507, -2701.3901, 0.9412, 0.0000, 270.0000, 0.0000); //MeshFence3
    SetDynamicObjectMaterial(g_DynamicObject[483], 0, 10806, "airfence_sfse", "ws_griddyfence", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[483], 1, 19165, "gtamap", "metal1-128x128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[483], 2, -1, "none", "none", 0x00FFFFFF);
    g_DynamicObject[484] = CreateDynamicObject(19870, -1577.8741, -2703.1787, 0.9118, 0.0000, 270.0000, 89.4000); //MeshFence3
    SetDynamicObjectMaterial(g_DynamicObject[484], 0, 10806, "airfence_sfse", "ws_griddyfence", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[484], 1, 19165, "gtamap", "metal1-128x128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[484], 2, -1, "none", "none", 0x00FFFFFF);
    g_DynamicObject[485] = CreateDynamicObject(19870, -1577.8664, -2709.9611, 0.9326, 0.0000, 270.0000, 89.4000); //MeshFence3
    SetDynamicObjectMaterial(g_DynamicObject[485], 0, 10806, "airfence_sfse", "ws_griddyfence", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[485], 1, 19165, "gtamap", "metal1-128x128", 0xFFFFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[485], 2, -1, "none", "none", 0x00FFFFFF);
    g_DynamicObject[486] = CreateDynamicObject(19477, -1578.0594, -2704.8981, 2.5306, 0.0000, 0.0000, 179.3997); //electric hazard
    SetDynamicObjectMaterial(g_DynamicObject[486], 0, 18365, "sawmillcs_t", "electricity_64", 0x00000000);
    g_DynamicObject[487] = CreateDynamicObject(3010, -1576.0533, -2709.1694, 1.0497, 28.0000, 64.0005, -54.1002); //chopcop_legR
    SetDynamicObjectMaterial(g_DynamicObject[487], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[488] = CreateDynamicObject(19806, -1578.3243, -2570.8291, -4.5074, 0.0000, 0.0000, -60.6999); //Chandelier1
    g_DynamicObject[489] = CreateDynamicObject(3012, -1576.0533, -2709.1694, 1.0497, 28.0000, 64.0005, -54.1002); //chopcop_head
    SetDynamicObjectMaterial(g_DynamicObject[489], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[490] = CreateDynamicObject(3011, -1576.0533, -2709.1694, 1.0497, 28.0000, 64.0005, -54.1002); //chopcop_legL
    SetDynamicObjectMaterial(g_DynamicObject[490], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[491] = CreateDynamicObject(18633, -1574.7497, -2705.5473, 5.8582, 0.0000, 0.0000, -97.5998); //transf conductor
    SetDynamicObjectMaterial(g_DynamicObject[491], 0, -1, "none", "none", 0xFFD2691E);
    g_DynamicObject[492] = CreateDynamicObject(19477, -1576.8249, -2554.9299, 5.9684, 0.0000, 0.0000, -149.0997); //mazarot text
    SetDynamicObjectMaterialText(g_DynamicObject[492], 0, "Mazarot Incorporated", OBJECT_MATERIAL_SIZE_512x256, "Courier New", 30, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[493] = CreateDynamicObject(3008, -1575.8487, -2709.1291, 0.8995, 0.0000, 0.0000, 48.0998); //chopcop_armR
    SetDynamicObjectMaterial(g_DynamicObject[493], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[494] = CreateDynamicObject(1428, -1574.8408, -2710.1525, 1.2970, 95.4999, 0.0000, 0.0000); //DYN_LADDER
    g_DynamicObject[495] = CreateDynamicObject(918, -1583.4189, -2703.1728, 1.4084, 0.0000, 0.0000, 0.0000); //CJ_FLAME_Drum
    g_DynamicObject[496] = CreateDynamicObject(18633, -1574.7469, -2707.2529, 5.8582, 0.0000, 0.0000, -97.5998); //transf conductor
    SetDynamicObjectMaterial(g_DynamicObject[496], 0, -1, "none", "none", 0xFFD2691E);
    g_DynamicObject[497] = CreateDynamicObject(19477, -1574.4565, -2706.3974, 5.7206, 0.0000, 0.0000, 0.0000); //transform fire seal
    SetDynamicObjectMaterial(g_DynamicObject[497], 0, 10756, "airportroads_sfse", "Heliconcrete", 0x00000000);
    g_DynamicObject[498] = CreateDynamicObject(19120, -1576.4549, -2710.2639, 1.0865, 0.0000, 88.1996, 0.0000); //PlainHelmet5
    SetDynamicObjectMaterial(g_DynamicObject[498], 0, -1, "none", "none", 0xFF696969);
    g_DynamicObject[499] = CreateDynamicObject(18633, -1575.5355, -2708.7795, 1.0707, 178.1997, 92.5998, -86.5997); //GTASAWrench1
    g_DynamicObject[500] = CreateDynamicObject(19899, -1583.3249, -2697.7260, 1.0154, 0.0000, 0.0000, 0.0000); //ToolCabinet1
    g_DynamicObject[501] = CreateDynamicObject(19900, -1583.1955, -2702.1010, 1.0456, 0.0000, 0.0000, -20.2999); //ToolCabinet2
    g_DynamicObject[502] = CreateDynamicObject(2103, -1583.1645, -2697.2907, 2.2820, 0.0000, 0.0000, 87.3999); //LOW_HI_FI_1
    g_DynamicObject[503] = CreateDynamicObject(19815, -1583.8177, -2700.5944, 2.6484, 0.0000, 0.0000, 90.4000); //ToolBoard1
    g_DynamicObject[504] = CreateDynamicObject(19996, -1582.2425, -2699.7988, 1.0115, 0.0000, 0.0000, -69.0998); //CutsceneFoldChair1
    g_DynamicObject[505] = CreateDynamicObject(3633, -1579.4892, -2697.4365, 1.4903, 0.0000, 0.0000, -45.2999); //imoildrum4_LAS
    SetDynamicObjectMaterial(g_DynamicObject[505], 0, 3630, "compthotrans_la", "nbarlid", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[505], 1, 918, "externalext", "CJ_OIL_DRUM", 0x00000000);
    g_DynamicObject[506] = CreateDynamicObject(2607, -1583.3172, -2700.6296, 1.4470, 0.0000, 0.0000, -92.4000); //mechanics desk
    SetDynamicObjectMaterial(g_DynamicObject[506], 0, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[506], 1, 14599, "paperchasebits", "ab_blueprint4", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[506], 2, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[506], 3, 1560, "7_11_door", "cj_sheetmetal2", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[506], 4, 14776, "genintintcarint3", "tool_store", 0x00000000);
    g_DynamicObject[507] = CreateDynamicObject(3633, -1577.9232, -2697.1154, 1.4903, 0.0000, 0.0000, -0.5000); //imoildrum4_LAS
    SetDynamicObjectMaterial(g_DynamicObject[507], 0, 3630, "compthotrans_la", "nbarlid", 0xFF696969);
    SetDynamicObjectMaterial(g_DynamicObject[507], 1, 918, "externalext", "CJ_OIL_DRUM", 0x00000000);
    g_DynamicObject[508] = CreateDynamicObject(19477, -1583.7806, -2705.4870, 3.7046, 0.0000, 0.0000, 0.0000); //mechanics poster
    SetDynamicObjectMaterial(g_DynamicObject[508], 0, 14737, "whorewallstuff", "ah_painting2", 0xFFFFB6C1);
    g_DynamicObject[509] = CreateDynamicObject(19898, -1578.8116, -2698.0627, 1.0319, 0.0000, 0.0000, 78.8000); //OilFloorStain1
    g_DynamicObject[510] = CreateDynamicObject(2475, -1583.0516, -2575.8837, -6.8269, 0.0000, 0.0000, -59.0998); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[510], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[511] = CreateDynamicObject(2517, -1601.0295, -2570.6696, -6.9798, 0.0000, 0.0000, -149.0997); //CJ_SHOWER1
    g_DynamicObject[512] = CreateDynamicObject(2518, -1600.8172, -2568.6247, -7.1051, 0.0000, 0.0000, 31.1000); //CJ_B_SINK2
    g_DynamicObject[513] = CreateDynamicObject(2475, -1585.2961, -2578.8269, -6.8269, 0.0000, 0.0000, -148.8999); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[513], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[514] = CreateDynamicObject(2475, -1586.5466, -2579.5810, -6.8269, 0.0000, 0.0000, -148.8999); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[514], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[515] = CreateDynamicObject(2475, -1587.6009, -2579.2292, -6.8269, 0.0000, 0.0000, 121.0998); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[515], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[516] = CreateDynamicObject(2475, -1588.3602, -2577.9692, -6.8269, 0.0000, 0.0000, 121.0998); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[516], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[517] = CreateDynamicObject(2475, -1589.8846, -2575.4453, -6.8269, 0.0000, 0.0000, 121.0998); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[517], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[518] = CreateDynamicObject(927, -1583.5992, -2574.9797, -5.7080, 0.0000, 0.0000, -58.9999); //Piping_Detail
    g_DynamicObject[519] = CreateDynamicObject(2475, -1589.1296, -2576.6938, -6.8269, 0.0000, 0.0000, 121.0998); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[519], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[520] = CreateDynamicObject(2475, -1584.0289, -2578.0625, -6.8269, 0.0000, 0.0000, -148.8999); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[520], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[521] = CreateDynamicObject(2475, -1587.0655, -2572.7619, -6.8269, 0.0000, 0.0000, 31.5000); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[521], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[522] = CreateDynamicObject(2475, -1589.5898, -2574.3090, -6.8269, 0.0000, 0.0000, 31.5000); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[522], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[523] = CreateDynamicObject(19464, -1601.2462, -2566.4763, -4.4800, 0.0000, 0.0000, -59.0000); //wall
    SetDynamicObjectMaterial(g_DynamicObject[523], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[524] = CreateDynamicObject(2475, -1588.3282, -2573.5349, -6.8269, 0.0000, 0.0000, 31.5000); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[524], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[525] = CreateDynamicObject(2525, -1601.7600, -2569.2041, -6.9899, 0.0000, 0.0000, 31.3999); //CJ_TOILET4
    g_DynamicObject[526] = CreateDynamicObject(19464, -1594.8575, -2580.8200, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[526], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[527] = CreateDynamicObject(19464, -1591.7988, -2585.9099, -4.4800, 0.0000, 0.0000, -148.9996); //wall
    SetDynamicObjectMaterial(g_DynamicObject[527], 0, 3820, "boxhses_sfsx", "ws_mixedbrick", 0x00000000);
    g_DynamicObject[528] = CreateDynamicObject(2394, -1589.1611, -2580.7338, -5.4895, 0.0000, 0.0000, -148.8000); //CJ_CLOTHES_STEP_1
    g_DynamicObject[529] = CreateDynamicObject(2708, -1588.5240, -2580.5119, -7.2290, 0.0000, 0.0000, -148.8000); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[529], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[530] = CreateDynamicObject(2394, -1591.2059, -2581.9736, -5.4895, 0.0000, 0.0000, -148.8000); //CJ_CLOTHES_STEP_1
    g_DynamicObject[531] = CreateDynamicObject(2708, -1590.5688, -2581.7517, -7.2290, 0.0000, 0.0000, -148.8000); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[531], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[532] = CreateDynamicObject(2394, -1593.2938, -2581.5952, -5.4895, 0.0000, 0.0000, 120.9998); //CJ_CLOTHES_STEP_1
    g_DynamicObject[533] = CreateDynamicObject(2708, -1593.0738, -2582.2329, -7.2290, 0.0000, 0.0000, 120.9998); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[533], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[534] = CreateDynamicObject(2394, -1594.5249, -2579.5468, -5.4895, 0.0000, 0.0000, 120.9998); //CJ_CLOTHES_STEP_1
    g_DynamicObject[535] = CreateDynamicObject(2708, -1594.3049, -2580.1845, -7.2290, 0.0000, 0.0000, 120.9998); //ZIP_SHELF1
    SetDynamicObjectMaterial(g_DynamicObject[535], 1, 1983, "new_cabinets2", "shop_shelfnu3", 0x00000000);
    g_DynamicObject[536] = CreateDynamicObject(18643, -1572.1627, -2563.3237, 32.3437, -23.0000, 128.7996, 44.4999); //LaserPointer1
    g_DynamicObject[537] = CreateDynamicObject(19564, -1586.5183, -2579.2836, -6.0180, 0.0000, 0.0000, 31.9999); //JuiceBox2
    g_DynamicObject[538] = CreateDynamicObject(19564, -1586.2833, -2579.2653, -6.0180, 0.0000, 0.0000, 37.0000); //JuiceBox2
    g_DynamicObject[539] = CreateDynamicObject(19565, -1588.0439, -2578.1062, -5.3207, 0.0000, 0.0000, -28.7999); //IceCreamBarsBox1
    g_DynamicObject[540] = CreateDynamicObject(19565, -1588.2739, -2577.7749, -5.3207, 0.0000, 0.0000, -28.7999); //IceCreamBarsBox1
    g_DynamicObject[541] = CreateDynamicObject(19566, -1589.3935, -2576.1818, -5.3260, 0.0000, 0.0000, -50.5998); //FishFingersBox1
    g_DynamicObject[542] = CreateDynamicObject(19566, -1589.5019, -2575.9074, -5.3260, 0.0000, 0.0000, -43.2999); //FishFingersBox1
    g_DynamicObject[543] = CreateDynamicObject(19566, -1589.9050, -2575.2109, -5.3260, 0.0000, 0.0000, -70.4000); //FishFingersBox1
    g_DynamicObject[544] = CreateDynamicObject(19572, -1586.3276, -2572.5615, -6.0208, 0.0000, 0.0000, 31.5000); //PisshBox1
    g_DynamicObject[545] = CreateDynamicObject(19572, -1586.7634, -2572.8266, -5.3210, 0.0000, 0.0000, 31.5000); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[545], 0, 2425, "cj_jucie", "CJ_SPRUNK_FRONT2", 0x00000000);
    g_DynamicObject[546] = CreateDynamicObject(19572, -1589.3238, -2574.3906, -6.0208, 0.0000, 0.0000, 31.5000); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[546], 0, 1340, "foodkarts", "chillidog_sign", 0x00000000);
    g_DynamicObject[547] = CreateDynamicObject(19572, -1585.6180, -2578.7973, -6.0208, 0.0000, 0.0000, 31.5000); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[547], 0, 1340, "foodkarts", "iceyside", 0x00000000);
    g_DynamicObject[548] = CreateDynamicObject(19572, -1582.6633, -2576.8608, -4.6310, 0.0000, 0.0000, 122.4000); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[548], 0, 2543, "cj_ss_3", "CJ_DOG_FOOD2", 0x00000000);
    g_DynamicObject[549] = CreateDynamicObject(19572, -1583.5488, -2577.5656, -5.3210, 0.0000, 0.0000, 27.0998); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[549], 0, 2543, "cj_ss_3", "CJ_DOOG_FOOD", 0x00000000);
    g_DynamicObject[550] = CreateDynamicObject(19572, -1588.6313, -2577.0412, -6.6988, 0.0000, 0.0000, -149.2998); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[550], 0, 5132, "imstuff_las2", "cardbrdirty128", 0x00000000);
    g_DynamicObject[551] = CreateDynamicObject(19572, -1585.4847, -2578.6965, -6.6988, 0.0000, 0.0000, -149.2998); //PisshBox1
    SetDynamicObjectMaterial(g_DynamicObject[551], 0, 5132, "imstuff_las2", "cardbrdirty128", 0x00000000);
    g_DynamicObject[552] = CreateDynamicObject(19089, -1628.9184, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[552], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[553] = CreateDynamicObject(19476, -1590.7757, -2565.0964, -5.2821, 0.0000, 0.0000, 120.3998); //recording in progres
    SetDynamicObjectMaterialText(g_DynamicObject[553], 0, "Recording in progress", OBJECT_MATERIAL_SIZE_512x256, "Impact", 60, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[554] = CreateDynamicObject(19571, -1582.7071, -2576.8198, -5.9871, 90.0000, 0.0000, 30.8999); //PizzaBox1
    SetDynamicObjectMaterial(g_DynamicObject[554], 0, 2821, "gb_foodwrap01", "GB_foodwrap03", 0x00000000);
    g_DynamicObject[555] = CreateDynamicObject(2293, -1591.7712, -2578.8901, -6.9847, 0.0000, 0.0000, 30.9999); //SWK_1_FStool
    SetDynamicObjectMaterial(g_DynamicObject[555], 0, 18031, "cj_exp", "mp_cloth_ds3", 0x00000000);
    g_DynamicObject[556] = CreateDynamicObject(1492, -1599.1346, -2568.5092, -7.0096, 0.0000, 0.0000, -58.5998); //Gen_doorINT02
    SetDynamicObjectMaterial(g_DynamicObject[556], 0, -1, "none", "none", 0xFFD2691E);
    SetDynamicObjectMaterial(g_DynamicObject[556], 1, 14526, "sweetsmain", "ah_whitpanelceil", 0x00000000);
    g_DynamicObject[557] = CreateDynamicObject(1492, -1596.0771, -2573.5832, -7.0096, 0.0000, 0.0000, -58.5998); //Gen_doorINT02
    SetDynamicObjectMaterial(g_DynamicObject[557], 0, -1, "none", "none", 0xFFD2691E);
    SetDynamicObjectMaterial(g_DynamicObject[557], 1, 14526, "sweetsmain", "ah_whitpanelceil", 0x00000000);
    g_DynamicObject[558] = CreateDynamicObject(1492, -1592.9366, -2566.4892, -7.0096, 0.0000, 0.0000, 30.9001); //Gen_doorINT02
    SetDynamicObjectMaterial(g_DynamicObject[558], 0, -1, "none", "none", 0xFFD2691E);
    SetDynamicObjectMaterial(g_DynamicObject[558], 1, 14526, "sweetsmain", "ah_whitpanelceil", 0x00000000);
    g_DynamicObject[559] = CreateDynamicObject(18075, -1574.9425, -2568.2695, -3.0868, 0.0000, 0.0000, -59.0998); //lightD
    g_DynamicObject[560] = CreateDynamicObject(18075, -1587.5283, -2574.4323, -3.0868, 0.0000, 0.0000, -59.0998); //lightD
    g_DynamicObject[561] = CreateDynamicObject(18075, -1592.1815, -2566.6757, -3.0868, 0.0000, 0.0000, -59.0998); //lightD
    g_DynamicObject[562] = CreateDynamicObject(18075, -1600.8968, -2574.3901, -3.1168, 0.0000, 0.0000, -148.9998); //lightD
    g_DynamicObject[563] = CreateDynamicObject(2475, -1582.7464, -2577.2919, -6.8269, 0.0000, 0.0000, -148.8999); //CJ_HOBBY_SHELF_3
    SetDynamicObjectMaterial(g_DynamicObject[563], 1, -1, "none", "none", 0xFF800000);
    g_DynamicObject[564] = CreateDynamicObject(19089, -1620.9583, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[564], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[565] = CreateDynamicObject(19089, -1635.7982, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[565], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[566] = CreateDynamicObject(19089, -1635.7984, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[566], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[567] = CreateDynamicObject(19089, -1620.9587, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[567], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[568] = CreateDynamicObject(19089, -1605.4284, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[568], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[569] = CreateDynamicObject(18608, -1604.8885, -2724.0666, 13.9694, 0.0000, 0.0000, 270.0000); //countS_lights01
    g_DynamicObject[570] = CreateDynamicObject(18608, -1628.3785, -2724.0666, 13.9694, 0.0000, 0.0000, 270.0000); //countS_lights01
    g_DynamicObject[571] = CreateDynamicObject(19089, -1605.4284, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[571], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[572] = CreateDynamicObject(19089, -1597.4685, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[572], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[573] = CreateDynamicObject(19089, -1612.3082, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[573], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[574] = CreateDynamicObject(19089, -1612.3084, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[574], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[575] = CreateDynamicObject(19089, -1597.4687, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[575], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[576] = CreateDynamicObject(19089, -1583.1175, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[576], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[577] = CreateDynamicObject(18608, -1582.5775, -2724.0666, 13.9694, 0.0000, 0.0000, 270.0000); //countS_lights01
    g_DynamicObject[578] = CreateDynamicObject(19089, -1583.1175, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[578], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[579] = CreateDynamicObject(19089, -1575.1573, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[579], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[580] = CreateDynamicObject(19089, -1589.9970, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[580], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[581] = CreateDynamicObject(19089, -1589.9975, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[581], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[582] = CreateDynamicObject(19089, -1575.1578, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[582], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[583] = CreateDynamicObject(19089, -1560.6142, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[583], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[584] = CreateDynamicObject(18608, -1560.0743, -2724.0666, 13.9694, 0.0000, 0.0000, 270.0000); //countS_lights01
    g_DynamicObject[585] = CreateDynamicObject(19089, -1560.6142, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[585], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[586] = CreateDynamicObject(19089, -1552.6541, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[586], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[587] = CreateDynamicObject(19089, -1567.4940, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[587], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[588] = CreateDynamicObject(19089, -1567.4942, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[588], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[589] = CreateDynamicObject(19089, -1552.6545, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[589], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[590] = CreateDynamicObject(19089, -1539.5429, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[590], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[591] = CreateDynamicObject(18608, -1539.0030, -2724.0666, 13.9694, 0.0000, 0.0000, 270.0000); //countS_lights01
    g_DynamicObject[592] = CreateDynamicObject(19089, -1539.5429, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[592], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[593] = CreateDynamicObject(19089, -1531.5830, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[593], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[594] = CreateDynamicObject(19089, -1546.4227, -2724.8864, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[594], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[595] = CreateDynamicObject(19089, -1546.4229, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[595], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[596] = CreateDynamicObject(19089, -1531.5832, -2723.1867, 22.6690, 0.0000, 0.0000, 270.0000); //light attach wire
    SetDynamicObjectMaterial(g_DynamicObject[596], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[597] = CreateDynamicObject(18228, -1585.5725, -2715.1650, 36.0017, -178.7998, 0.0000, 8.1997); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[597], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[597], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[598] = CreateDynamicObject(18228, -1528.9427, -2715.8801, 35.8297, -178.7998, 0.0000, 44.2994); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[598], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[598], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[599] = CreateDynamicObject(18228, -1563.5959, -2710.6286, 36.3843, -178.7998, 0.0000, 67.8992); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[599], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[599], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[600] = CreateDynamicObject(18228, -1617.9842, -2713.0014, 37.0307, -178.7998, 0.0000, -138.6002); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[600], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[600], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[601] = CreateDynamicObject(18228, -1550.2810, -2722.3798, 34.9813, -178.7998, 0.0000, -156.7001); //cunt_rockgp2_21
    SetDynamicObjectMaterial(g_DynamicObject[601], 0, 896, "underwater", "greyrockbig", 0x00000000);
    SetDynamicObjectMaterial(g_DynamicObject[601], 1, 896, "underwater", "greyrockbig", 0x00000000);
    g_DynamicObject[602] = CreateDynamicObject(19482, -1580.7840, -2556.3254, -4.5331, 0.0000, 0.0000, 31.7000); //incorporated
    SetDynamicObjectMaterialText(g_DynamicObject[602], 0, "Incorporated", OBJECT_MATERIAL_SIZE_512x256, "Arial", 40, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[603] = CreateDynamicObject(19482, -1579.2923, -2558.7431, -4.5331, 0.0000, 0.0000, 31.7000); //mazarot
    SetDynamicObjectMaterialText(g_DynamicObject[603], 0, "Mazarot", OBJECT_MATERIAL_SIZE_512x256, "Arial", 40, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[604] = CreateDynamicObject(19475, -1577.2285, -2555.2065, 0.4681, 0.0000, 0.0000, -149.0997); //mazarot eye
    SetDynamicObjectMaterialText(g_DynamicObject[604], 0, "N", OBJECT_MATERIAL_SIZE_256x256, "Webdings", 150, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[605] = CreateDynamicObject(2965, -1579.9245, -2557.6975, -4.5275, 0.0000, 89.6996, -150.0000); //mazarot logo
    SetDynamicObjectMaterial(g_DynamicObject[605], 0, -1, "none", "none", 0xFF000000);
    g_DynamicObject[606] = CreateDynamicObject(18608, -1580.7408, -2701.8759, 7.2146, 0.0000, 0.0000, 0.0000); //countS_lights01
    g_DynamicObject[607] = CreateDynamicObject(19481, -1579.9521, -2734.5668, 6.6027, 0.0000, 0.0000, 89.9999); //subdock mazarot bg
    SetDynamicObjectMaterialText(g_DynamicObject[607], 0, "MAZAROT", OBJECT_MATERIAL_SIZE_512x256, "Verdana", 50, 1, 0xFFD2691E, 0x00000000, 1);
    g_DynamicObject[608] = CreateDynamicObject(19481, -1579.9123, -2734.5668, 4.8726, 0.0000, 0.0000, 89.9999); //subdock incorp bg
    SetDynamicObjectMaterialText(g_DynamicObject[608], 0, "INCORPORATED", OBJECT_MATERIAL_SIZE_512x256, "Verdana", 30, 1, 0xFFD2691E, 0x00000000, 1);
    g_DynamicObject[609] = CreateDynamicObject(19582, -1582.8050, -2569.5881, -5.9573, 0.0000, 0.0000, 46.3997); //MarcosSteak1
    SetDynamicObjectMaterial(g_DynamicObject[609], 0, -1, "none", "none", 0xFF8B4513);
    g_DynamicObject[610] = CreateDynamicObject(2518, -1585.3812, -2570.4963, -6.9899, 0.0000, 0.0000, 122.3999); //CJ_B_SINK2
    SetDynamicObjectMaterial(g_DynamicObject[610], 0, -1, "none", "none", 0x00FFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[610], 1, -1, "none", "none", 0x00FFFFFF);
    SetDynamicObjectMaterial(g_DynamicObject[610], 2, 6000, "con_drivein", "Desrtmetal", 0xFFF5F5F5);
    g_DynamicObject[611] = CreateDynamicObject(19828, -1580.4300, -2565.0175, -5.8962, 0.0000, 0.0000, 31.2000); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[611], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[612] = CreateDynamicObject(19828, -1576.4521, -2567.6875, -5.8958, 0.0000, 0.0000, -58.8997); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[612], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[613] = CreateDynamicObject(19828, -1583.6833, -2574.2768, -5.8958, 0.0000, 0.0000, 121.0998); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[613], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[614] = CreateDynamicObject(19814, -1582.9289, -2566.5747, -5.3572, 0.0000, 0.0000, 31.5998); //ElectricalOutlet2
    SetDynamicObjectMaterial(g_DynamicObject[614], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[615] = CreateDynamicObject(19814, -1586.7275, -2568.9091, -5.3572, 0.0000, 0.0000, 31.5998); //ElectricalOutlet2
    SetDynamicObjectMaterial(g_DynamicObject[615], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[616] = CreateDynamicObject(2710, -1586.9139, -2558.2163, -5.8579, 0.0000, 0.0000, -10.6000); //WATCH_PICKUP
    g_DynamicObject[617] = CreateDynamicObject(19814, -1577.7440, -2565.5334, -5.3372, 0.0000, 0.0000, -59.2999); //ElectricalOutlet2
    SetDynamicObjectMaterial(g_DynamicObject[617], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[618] = CreateDynamicObject(19828, -1576.5544, -2567.5166, -5.8958, 0.0000, 0.0000, -58.8997); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[618], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[619] = CreateDynamicObject(19828, -1580.4023, -2564.7138, -5.8962, 0.0000, 0.0000, -149.8999); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[619], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[620] = CreateDynamicObject(19828, -1595.3243, -2575.1950, -5.8958, 0.0000, 0.0000, -58.8997); //LightSwitch3Off
    SetDynamicObjectMaterial(g_DynamicObject[620], 0, -1, "none", "none", 0xFFFFFFFF);
    g_DynamicObject[621] = CreateDynamicObject(3007, -1576.0533, -2709.1694, 1.0497, 28.0000, 64.0005, -54.1002); //chopcop_torso
    SetDynamicObjectMaterial(g_DynamicObject[621], 0, 3899, "hospital2", "burnt_faggots64", 0xFF696969);
    g_DynamicObject[622] = CreateDynamicObject(19883, -1582.8415, -2569.7453, -5.9454, 0.0000, 0.0000, 0.0000); //BreadSlice1
    SetDynamicObjectMaterial(g_DynamicObject[622], 0, -1, "none", "none", 0xFFCD853F);
    g_DynamicObject[623] = CreateDynamicObject(19481, -1579.8620, -2734.5368, 6.7227, 0.0000, 0.0000, 89.9999); //subdock mazarot
    SetDynamicObjectMaterialText(g_DynamicObject[623], 0, "MAZAROT", OBJECT_MATERIAL_SIZE_512x256, "Verdana", 50, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[624] = CreateDynamicObject(1886, -1520.9061, -2725.0769, 13.4547, 15.0999, 0.0000, -86.5998); //shop_sec_cam
    g_DynamicObject[625] = CreateDynamicObject(1886, -1514.0266, -2665.1638, -2.3229, 39.4000, 0.0000, -100.8999); //shop_sec_cam
    g_DynamicObject[626] = CreateDynamicObject(1886, -1573.9090, -2697.9213, 6.0521, 54.4999, 0.0000, 119.9000); //shop_sec_cam
    g_DynamicObject[627] = CreateDynamicObject(1886, -1583.0234, -2697.3913, 6.1750, 36.2000, 0.0000, 38.0998); //shop_sec_cam
    g_DynamicObject[628] = CreateDynamicObject(19477, -1581.3579, -2696.4355, 2.8125, 0.0000, 0.0000, -90.0000); //transformer maintena
    SetDynamicObjectMaterialText(g_DynamicObject[628], 0, "transformer maintenance", OBJECT_MATERIAL_SIZE_512x256, "Segoe Print", 30, 1, 0xFFFF0000, 0x00000000, 1);
    g_DynamicObject[629] = CreateDynamicObject(1886, -1573.3138, -2571.0380, -2.8901, 20.3999, 0.0000, 166.3999); //shop_sec_cam
    g_DynamicObject[630] = CreateDynamicObject(19805, -1581.4477, -2696.4689, 2.5492, 0.0000, 0.0000, -179.9998); //Whiteboard1
    g_DynamicObject[631] = CreateDynamicObject(19477, -1581.3579, -2696.4355, 2.9825, 0.0000, 0.0000, -90.0000); //to do list
    SetDynamicObjectMaterialText(g_DynamicObject[631], 0, "To do list:", OBJECT_MATERIAL_SIZE_512x256, "Segoe Print", 30, 1, 0xFFFF0000, 0x00000000, 1);
    g_DynamicObject[632] = CreateDynamicObject(19477, -1581.4283, -2696.4355, 2.6431, -0.4999, 0.0000, -90.0000); //submarine maintenanc
    SetDynamicObjectMaterialText(g_DynamicObject[632], 0, "submarine maintenance", OBJECT_MATERIAL_SIZE_512x256, "Segoe Print", 30, 1, 0xFFFF0000, 0x00000000, 1);
    g_DynamicObject[633] = CreateDynamicObject(18868, -1575.0760, -2710.8891, 1.0411, 0.0000, 0.0000, -136.6999); //MobilePhone4
    g_DynamicObject[634] = CreateDynamicObject(1492, -1577.9300, -2561.5458, 27.8204, 0.0000, 0.0000, -58.5998); //Gen_doorINT02
    SetDynamicObjectMaterial(g_DynamicObject[634], 0, -1, "none", "none", 0xFFD2691E);
    SetDynamicObjectMaterial(g_DynamicObject[634], 1, 14526, "sweetsmain", "ah_whitpanelceil", 0x00000000);
    g_DynamicObject[635] = CreateDynamicObject(19273, -1575.3502, -2564.5258, 29.0475, 0.0000, 0.0000, 30.3999); //KeypadNonDynamic
    g_DynamicObject[636] = CreateDynamicObject(19273, -1575.4906, -2564.4299, 29.0475, 0.0000, 0.0000, -149.2996); //KeypadNonDynamic
    g_DynamicObject[637] = CreateDynamicObject(1492, -1580.9768, -2563.3688, 27.8204, 0.0000, 0.0000, -58.5998); //Gen_doorINT02
    SetDynamicObjectMaterial(g_DynamicObject[637], 0, -1, "none", "none", 0xFFD2691E);
    SetDynamicObjectMaterial(g_DynamicObject[637], 1, 14526, "sweetsmain", "ah_whitpanelceil", 0x00000000);
    g_DynamicObject[638] = CreateDynamicObject(19377, -1583.9038, -2572.7385, -7.0633, 0.0000, 270.0000, 31.0000); //big floor
    SetDynamicObjectMaterial(g_DynamicObject[638], 0, 14537, "pdomebar", "club_floor2_sfwTEST", 0x00000000);
    g_DynamicObject[639] = CreateDynamicObject(19273, -1571.8480, -2562.6437, -5.8523, 0.0000, 0.0000, -59.2000); //KeypadNonDynamic
    g_DynamicObject[640] = CreateDynamicObject(19476, -1590.7757, -2565.0964, -5.3520, 0.0000, 0.0000, 120.3998); //do not disturb
    SetDynamicObjectMaterialText(g_DynamicObject[640], 0, "DO NOT DISTURB!", OBJECT_MATERIAL_SIZE_512x256, "Impact", 81, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[641] = CreateDynamicObject(19797, -1590.7812, -2565.0654, -5.1606, 0.0000, 0.0000, -149.0997); //PoliceVisorStrobe1
    SetDynamicObjectMaterial(g_DynamicObject[641], 0, 19523, "sampicons", "reeedgrad32", 0x00000000);
    g_DynamicObject[642] = CreateDynamicObject(19273, -1577.7386, -2559.6494, 29.0475, 0.0000, 0.0000, 30.1000); //KeypadNonDynamic
    g_DynamicObject[643] = CreateDynamicObject(19273, -1578.4073, -2559.0930, 29.0475, 0.0000, 0.0000, -149.3999); //KeypadNonDynamic
    g_DynamicObject[644] = CreateDynamicObject(19273, -1569.5758, -2566.3840, 29.0475, 0.0000, 0.0000, -60.0998); //KeypadNonDynamic
    g_DynamicObject[645] = CreateDynamicObject(19476, -1577.3592, -2562.1643, 30.3987, 0.0000, 0.0000, 31.7999); //locker room
    SetDynamicObjectMaterialText(g_DynamicObject[645], 0, "LOCKER ROOM", OBJECT_MATERIAL_SIZE_512x256, "Impact", 110, 1, 0xFF000000, 0x00000000, 1);
    g_DynamicObject[646] = CreateDynamicObject(19273, -1575.2519, -2569.3332, -5.8523, 0.0000, 0.0000, 121.3000); //KeypadNonDynamic
    g_DynamicObject[647] = CreateDynamicObject(19273, -1575.3890, -2569.4152, -5.8523, 0.0000, 0.0000, -59.2000); //KeypadNonDynamic
    g_DynamicObject[648] = CreateDynamicObject(19273, -1572.4680, -2571.2143, -5.8523, 0.0000, 0.0000, -150.6999); //KeypadNonDynamic
    g_DynamicObject[649] = CreateDynamicObject(19273, -1572.4200, -2571.3376, -5.8523, 0.0000, 0.0000, 31.4001); //KeypadNonDynamic
    g_DynamicObject[650] = CreateDynamicObject(19273, -1580.0937, -2553.8398, -5.8523, 0.0000, 0.0000, 31.4001); //KeypadNonDynamic
    g_DynamicObject[651] = CreateDynamicObject(19273, -1580.1649, -2553.7202, -5.8523, 0.0000, 0.0000, -148.1999); //KeypadNonDynamic
    g_DynamicObject[652] = CreateDynamicObject(19273, -1519.4952, -2662.4431, -5.8523, 0.0000, 0.0000, -150.4998); //KeypadNonDynamic
    g_DynamicObject[653] = CreateDynamicObject(19273, -1519.4339, -2662.5612, -5.8523, 0.0000, 0.0000, 30.2000); //KeypadNonDynamic
    g_DynamicObject[654] = CreateDynamicObject(19273, -1520.0837, -2665.0253, -5.8523, 0.0000, 0.0000, 120.7001); //KeypadNonDynamic
    g_DynamicObject[655] = CreateDynamicObject(19273, -1520.2080, -2665.0917, -5.8523, 0.0000, 0.0000, -59.7998); //KeypadNonDynamic
    g_DynamicObject[656] = CreateDynamicObject(19273, -1576.2004, -2697.8730, 2.6672, 0.0000, 0.0000, 120.7001); //KeypadNonDynamic
    g_DynamicObject[657] = CreateDynamicObject(19273, -1576.3492, -2697.9562, 2.6672, 0.0000, 0.0000, -59.9998); //KeypadNonDynamic
    g_DynamicObject[658] = CreateDynamicObject(19610, -1589.1804, -2571.2834, -4.1230, -144.2397, 0.0000, 32.0998); //Microphone1
    SetDynamicObjectMaterial(g_DynamicObject[658], 0, -1, "none", "none", 0xFF696969);

    g_Vehicle[0] = CreateVehicle(509, -1506.5611, -2658.3071, -6.4211, 95.5743, 0, 0, 20); //Bike
    g_Vehicle[1] = CreateVehicle(530, -1582.5765, -2705.8889, 1.7796, 183.5193, 0, 0, 20); //Forklift

    g_DynamicActor[ACTOR_ENTRY_GUARD] = CreateDynamicActor(71, -1570.8188, -2569.7690, 28.7656, 31.2999, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_HOMELESS] = CreateDynamicActor(78, -1510.5262, -2660.7250, -6.6230, 32.5998, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_STAIRWAY_GUARD_1] = CreateDynamicActor(166, -1586.2397, -2561.5456, 0.1483, -59.2999, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_MECHANIC] = CreateDynamicActor(50, -1603.0024, -2721.0073, 3.8322, 0.0000, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_STAIRWAY_GUARD_2] = CreateDynamicActor(165, -1578.9365, -2554.5410, 23.1464, 125.4999, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_RECEPTION_GUARD_1] = CreateDynamicActor(166, -1574.5638, -2563.5524, -5.2494, 123.5998, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_CAMERAMAN] = CreateDynamicActor(98, -1590.0212, -2570.8911, -6.2136, -132.8000, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_VIP] = CreateDynamicActor(147, -1588.7939, -2571.8769, -5.8014, 45.4998, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_RECEPTION_GUARD_2] = CreateDynamicActor(165, -1575.6761, -2564.2697, -5.3976, -58.7999, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_CHEF] = CreateDynamicActor(210, -1585.1816, -2569.4069, -6.3586, -55.0998, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_BARTENDER] = CreateDynamicActor(59, -1581.4663, -2575.1784, -5.9857, 17.5998, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_FOREMAN] = CreateDynamicActor(153, -1579.3376, -2709.1928, 2.0455, -87.9999, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_RECEPTIONIST] = CreateDynamicActor(150, -1581.7580, -2557.0976, -5.7504, -111.6996, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_IT_SUPPORT] = CreateDynamicActor(289, -1581.0035, -2558.0080, -5.4780, -57.0000, .streamdistance = 50.0, .worldid = 0);
    g_DynamicActor[ACTOR_STYLIST] = CreateDynamicActor(3, -1592.8725, -2579.3640, -6.1553, 125.3999, .streamdistance = 50.0, .worldid = 0);
}

DestroyGeneralItems() {
    for (new idx, idx_limit = sizeof g_VehicleObject; idx < idx_limit; idx++) {
        DestroyObject(g_VehicleObject[idx]);
    }

    for (new idx, idx_limit = sizeof g_DynamicObject; idx < idx_limit; idx++) {
        DestroyDynamicObjectEx(g_DynamicObject[idx]);
    }

    for (new idx, idx_limit = sizeof g_Vehicle; idx < idx_limit; idx++) {
        DestroyVehicle(g_Vehicle[idx]);
    }

    for (new idx, idx_limit = sizeof g_DynamicActor; idx < idx_limit; idx++) {
        DestroyActor(g_DynamicActor[idx]);
    }
}

hook OnGameModeInit() {
    CreateGeneralItems();
    CreateElevator();
    CreateEntryExits();
    CreateDoor(-1572.9832, -2571.6791, 29.7301, 0.0000, 0.0000, -58.9000);
    CreateDoor(-1572.8398, -2574.0109, 29.7301, 0.0000, 0.0000, -148.9999);
    CreateDoor(-1572.6760, -2565.0490, 29.7301, 0.0000, 0.0000, -58.9000);
    CreateDoor(-1575.0780, -2560.1855, 29.7301, 0.0000, 0.0000, -58.9000);
    CreateDoor(-1579.1849, -2555.4265, -5.0620, 0.0000, 0.0000, -58.9000);
    CreateDoor(-1569.6497, -2571.8188, -5.0620, 0.0000, 0.0000, -58.9000);
    CreateDoor(-1576.9494, -2570.3190, -5.0620, 0.0000, 0.0000, -149.0999);
    CreateDoor(-1516.7568, -2663.1357, -5.2957, 0.0000, 0.0000, -59.6999);
    CreateDoor(-1518.4584, -2664.1682, -5.3257, 0.0000, 0.0000, 29.8000);
    CreateDoor(-1574.5665, -2697.0371, 2.9613, 0.0000, 0.0000, 29.9000);
    return 1;
}

hook OnGameModeExit() {
    DestroyGeneralItems();
    DestroyElevator();
    DestroyDoors();
    DestroyEntryExits();
}

hook OnObjectMoved(objectid) {
    if (objectid == g_ElevData[e_ElevObj]) {
        switch (g_ElevData[e_ElevState]) {
            case ELEVSTATE_MOVING_U:  {
                g_ElevData[e_ElevFloor] = ELEVFLOOR_T;
            }
            case ELEVSTATE_MOVING_D:  {
                g_ElevData[e_ElevFloor] = ELEVFLOOR_B;
            }
            default:  {
                return 1;
            }
        }

        g_ElevData[e_ElevState] = ELEVSTATE_OPENING;
        ApplyElevatorState();

        new Float:x, Float:y, Float:z;
        GetObjectPos(g_ElevData[e_ElevObj], x, y, z);
        PlaySoundForAll(6401, x, y, z);
        return 1;
    }
    return 1;
}

hook OnDynamicObjectMoved(objectid) {
    for (new doorid; doorid < g_DoorsInitiated; doorid++) {
        if (objectid == g_DoorData[doorid][e_DoorDynObj]) {
            if (g_DoorData[doorid][e_DoorState] == DOORSTATE_OPENING) {
                g_DoorData[doorid][e_DoorState] = DOORSTATE_OPEN;
                UpdateDoorState(doorid);
            } else if (g_DoorData[doorid][e_DoorState] == DOORSTATE_CLOSING) {
                g_DoorData[doorid][e_DoorState] = DOORSTATE_CLOSE;
                UpdateDoorState(doorid);
            }
            return 1;
        }
    }

    for (new floor; floor < MAX_ELEVFLOORS; floor++) {
        if (objectid == g_ElevData[e_ElevExtDoorDynObj][floor]) {
            if (g_ElevData[e_ElevState] == ELEVSTATE_CLOSING) {

                g_ElevData[e_ElevState] = ELEVSTATE_CLOSE;
                ApplyElevatorState();

                if (g_ElevData[e_ElevFloor] == ELEVFLOOR_B) {
                    g_ElevData[e_ElevState] = ELEVSTATE_MOVING_U;
                } else {
                    g_ElevData[e_ElevState] = ELEVSTATE_MOVING_D;
                }
                ApplyElevatorState();

            } else if (g_ElevData[e_ElevState] == ELEVSTATE_OPENING) {
                g_ElevData[e_ElevState] = ELEVSTATE_OPEN;
                ApplyElevatorState();
            }
            return 1;
        }
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid) {
    if (areaid == g_EntryArea) {
        if (g_EntryExitSkip { playerid }) {
            g_EntryExitSkip { playerid } = false;
        } else {
            g_EntryExitSkip { playerid } = true;
            SetPlayerPos(playerid, -1578.0275, -2569.4412, 28.8323);
        }
        return 1;
    }

    if (areaid == g_ExitArea) {
        if (g_EntryExitSkip { playerid }) {
            g_EntryExitSkip { playerid } = false;
        } else {
            g_EntryExitSkip { playerid } = true;
            SetPlayerPos(playerid, -1584.0164, -2572.3108, 28.8232);
        }
        return 1;
    }

    for (new doorid; doorid < g_DoorsInitiated; doorid++) {
        if (areaid == g_DoorData[doorid][e_DoorDynArea]) {
            UpdateDoorState(doorid);
            return 1;
        }
    }

    for (new floor; floor < MAX_ELEVFLOORS; floor++) {
        if (areaid == g_ElevData[e_ElevDynArea][floor]) {
            if (g_ElevData[e_ElevFloor] != floor && g_ElevData[e_ElevState] == ELEVSTATE_OPEN) {
                g_ElevData[e_ElevState] = ELEVSTATE_CLOSING;
                ApplyElevatorState();
            }
            return 1;
        }
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid) {
    for (new doorid; doorid < g_DoorsInitiated; doorid++) {
        if (areaid == g_DoorData[doorid][e_DoorDynArea]) {
            UpdateDoorState(doorid);
            return 1;
        }
    }
    return 1;
}

hook OnDynamicActorStreamIn(actorid, forplayerid) {
    for (new idx, idx_limit = sizeof g_DynamicActor; idx < idx_limit; idx++) {
        if (actorid == g_DynamicActor[idx]) {
            switch (idx) {
                case ACTOR_ENTRY_GUARD:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "COP_AMBIENT", "COPLOOK_LOOP", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_STAIRWAY_GUARD_1, ACTOR_STAIRWAY_GUARD_2:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "MUSCULAR", "MUSCLEIDLE", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_RECEPTION_GUARD_1:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "MISC", "IDLE_CHAT_02", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_RECEPTION_GUARD_2:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "PED", "IDLE_CHAT", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_MECHANIC:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "COP_AMBIENT", "COPBROWSE_LOOP", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_HOMELESS:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "CRACK", "CRCKIDLE2", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_CAMERAMAN:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "MISC", "IDLE_CHAT_02", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_VIP:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "PED", "IDLE_CHAT", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_CHEF:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "ON_LOOKERS", "PANIC_LOOP", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_BARTENDER:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "ON_LOOKERS", "PANIC_POINT", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_FOREMAN:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "ON_LOOKERS", "PANIC_SHOUT", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_RECEPTIONIST:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "COP_AMBIENT", "COPLOOK_THINK", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_IT_SUPPORT:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "INT_SHOP", "SHOP_LOOKA", 4.0998, 1, 0, 0, 0, 0);
                }
                case ACTOR_STYLIST:  {
                    ApplyDynamicActorAnimation(g_DynamicActor[idx], "BAR", "BARCUSTOM_LOOP", 4.0998, 1, 0, 0, 0, 0);
                }
            }
            return 1;
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (PRESSED(KEY_SECONDARY_ATTACK) && g_ElevData[e_ElevState] == ELEVSTATE_OPEN) {
        for (new floor; floor < MAX_ELEVFLOORS; floor++) {
            if (IsPlayerInDynamicArea(playerid, g_ElevData[e_ElevDynArea][floor])) {
                g_ElevData[e_ElevState] = ELEVSTATE_CLOSING;
                ApplyElevatorState();
                break;
            }
        }
    }
}