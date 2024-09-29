forward OnVehicleParachuteThrown(playerid, vehicleid);
forward OnVehicleParachuteOpened(playerid, vehicleid);
forward OnVehicleParachuteOpenFail(playerid, vehicleid);

new VehicleConfigParachute[63],
    STREAMER_TAG_OBJECT:VehicleParachuteObject[MAX_VEHICLES][3],
    PlayerUsingVehPara[32],
    VEHPARA_KEY = KEY_CROUCH;

//Get Compress Adress
#define GetVehicleParaConfAddress(%0)				(floatround((%0)/32))
#define GetVehicleParaConfBit(%0)					((%0) % 32)

//BitFunctions.inc
#define VP_GetValueBit(%0,%1)						((%0) >>> (%1) & 0x01)
#define VP_SetValueBit(%0,%1,%2)					((%0) = (((%0) & ~(0x01 << (%1))) | ((0x01 << (%1))*(%2))))

#define IsPlayerUsingVehPara(%0)					VP_GetValueBit(PlayerUsingVehPara[GetVehicleParaConfAddress(%0)],GetVehicleParaConfBit(%0))
#define TogglePlayerUsingVehPara(%0,%1)				VP_SetValueBit(PlayerUsingVehPara[GetVehicleParaConfAddress(%0)],GetVehicleParaConfBit(%0),(%1))

#define IsToggleVehicleParachute(%0)				VP_GetValueBit(VehicleConfigParachute[GetVehicleParaConfAddress(%0)],GetVehicleParaConfBit(%0))
#define SetVehicleParachuteKey(%0)					VEHPARA_KEY = (%0)

stock ToggleVehicleParachute(vehicleid, bool:toggle) {
    for (new i = 0; i < 3; i++) {
        if(IsValidDynamicObject(VehicleParachuteObject[vehicleid][i])) DestroyDynamicObjectEx(VehicleParachuteObject[vehicleid][i]);
        VehicleParachuteObject[vehicleid][i] = STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;
    }
    if(toggle) {
        if(!IsToggleVehicleParachute(vehicleid)) {
            VehicleParachuteObject[vehicleid][1] = CreateDynamicObject(1310, 0.0, 0.0, -6000.0, 0.0, 0.0, 0.0, -1, -1);
            VehicleParachuteObject[vehicleid][2] = CreateDynamicObject(1310, 0.0, 0.0, -6000.0, 0.0, 0.0, 0.0, -1, -1);

            new Float:T3D:x, Float:T3D:y, Float:T3D:z;
            GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, T3D:x, T3D:y, T3D:z);
            T3D:z /= 2.0;

            AttachDynamicObjectToVehicle(VehicleParachuteObject[vehicleid][1], vehicleid, 0.5, 0.0, T3D:z + 0.1, 270.0, 0.0, 35.0);
            AttachDynamicObjectToVehicle(VehicleParachuteObject[vehicleid][2], vehicleid, -0.5, 0.0, T3D:z + 0.1, 270.0, 0.0, 325.0);
        }
    }
    VP_SetValueBit(VehicleConfigParachute[GetVehicleParaConfAddress(vehicleid)], GetVehicleParaConfBit(vehicleid), (_:toggle));
}

stock StartVehicleParachuteAction(playerid) {
    TogglePlayerUsingVehPara(playerid, 1);

    new vid = GetPlayerVehicleID(playerid);
    for (new i = 0; i < 3; i++) {
        if(IsValidDynamicObject(VehicleParachuteObject[vid][i])) DestroyDynamicObjectEx(VehicleParachuteObject[vid][i]);
        VehicleParachuteObject[vid][i] = STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;
    }
    VehicleParachuteObject[vid][0] = CreateDynamicObject(18849, 0.0, 0.0, -6000.0, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    switch (random(5)) {
        case 0:{
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 0, 18841, "MickyTextures", "Smileyface2", 0x00000000);
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 2, 10412, "hotel1", "carpet_red_256", 0x00FFFFFF);
        }
        case 1:{
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 0, 18841, "MickyTextures", "red032", 0x00000000);
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 2, 10412, "hotel1", "carpet_red_256", 0x00FFFFFF);
        }
        case 2:{
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 0, 18841, "MickyTextures", "ws_gayflag1", 0x00000000);
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 2, 10412, "hotel1", "carpet_red_256", 0x00FFFFFF);
        }
        case 3:{
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 0, 18841, "MickyTextures", "waterclear256", 0x00000000);
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 2, 10412, "hotel1", "carpet_red_256", 0x00FFFFFF);
        }
        case 4:{
            SetDynamicObjectMaterial(VehicleParachuteObject[vid][0], 2, 10412, "hotel1", "carpet_red_256", 0x00FFFFFF);
        }
    }
    new Float:T3D:x, Float:T3D:y, Float:T3D:z;
    GetVehicleModelInfo(GetVehicleModel(vid), VEHICLE_MODEL_INFO_SIZE, T3D:x, T3D:y, T3D:z);
    T3D:z /= 2.0;
    AttachDynamicObjectToVehicle(VehicleParachuteObject[vid][0], vid, 0.0, 0.0, T3D:z + 6.0, 0.0, 0.0, 90.0);
}

stock StopVehicleParachuteAction(playerid, vehicleid = INVALID_VEHICLE_ID) {
    TogglePlayerUsingVehPara(playerid, 0);
    if(vehicleid == INVALID_VEHICLE_ID) vehicleid = GetPlayerVehicleID(playerid);
    ToggleVehicleParachute(vehicleid, false);
}


hook OnPlayerUpdate(playerid) {
    if(IsPlayerUsingVehPara(playerid)) {
        if(IsCollisionFlag(Item::GetCollisionFlags(GetPlayerVehicleID(playerid), item_vehicle), POSITION_FLAG_GROUND)) {
            StopVehicleParachuteAction(playerid);
            CallLocalFunction("OnVehicleParachuteThrown", "dd", playerid, GetPlayerVehicleID(playerid));
        } else {
            static T3D:vid, Float:T3D:rx, Float:T3D:ry, Float:T3D:rz, Float:T3D:tx, Float:T3D:ty, Float:T3D:tz;
            T3D:vid = GetPlayerVehicleID(playerid);
            T3D:tx = T3D:ty = 0.0;
            Tryg3D::GetVehicleRotation(T3D:vid, T3D:rx, T3D:ry, T3D:rz);
            ShiftVectorRotation((Tryg3D::DeCompressRotation(T3D:ry) / 180.0), (Tryg3D::DeCompressRotation(-T3D:rx) / 180.0), 0.0, 0.0, 0.0, T3D:rz, T3D:tx, T3D:ty, T3D:tz);
            SetVehicleVelocity(T3D:vid, (T3D:tx / 10.0), (T3D:ty / 10.0), -0.2);
        }
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
    ToggleVehicleParachute(vehicleid, false);
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(IsValidDynamicObject(VehicleParachuteObject[vehicleid][0])) {
        ToggleVehicleParachute(vehicleid, false);
        CallLocalFunction("OnVehicleParachuteThrown", "dd", playerid, vehicleid);
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(oldstate == PLAYER_STATE_DRIVER && IsPlayerUsingVehPara(playerid)) {
        StopVehicleParachuteAction(playerid, GetPlayerVehicleID(playerid));
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0) {
        new vid = GetPlayerVehicleID(playerid);
        if(Tryg3D::KeyPressed(VEHPARA_KEY)) {
            if(IsToggleVehicleParachute(vid)) {
                if(IsPlayerUsingVehPara(playerid)) {
                    StopVehicleParachuteAction(playerid);
                    CallLocalFunction("OnVehicleParachuteThrown", "dd", playerid, vid);
                } else {
                    if(IsCollisionFlag(Item::GetCollisionFlags(vid, item_vehicle), POSITION_FLAG_AIR) && GetVehicleSpeed(vid) > 0.0) {
                        StartVehicleParachuteAction(playerid);
                        CallLocalFunction("OnVehicleParachuteOpened", "dd", playerid, vid);
                    } else {
                        CallLocalFunction("OnVehicleParachuteOpenFail", "dd", playerid, vid);
                    }
                }
            }
        }
    }
    return 1;
}

hook PutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    if(IsValidDynamicObject(VehicleParachuteObject[vehicleid][0])) {
        ToggleVehicleParachute(vehicleid, false);
    }
    return 1;
}

hook OnVehicleCreated(vehicleid) {
    ToggleVehicleParachute(vehicleid, false);
    return 1;
}

hook OnVehicleDestroyed(vehicleid) {
    ToggleVehicleParachute(vehicleid, false);
    return 1;

}

hook OnSetPlayerPosEx(playerid, Float:x, Float:y, Float:z) {
    if(IsPlayerUsingVehPara(playerid)) {
        StopVehicleParachuteAction(playerid, GetPlayerVehicleID(playerid));
    }
}

hook OnPlayerConnect(playerid) {
    TogglePlayerUsingVehPara(playerid, 0);
    return 1;
}

cmd:para(playerid, const params[]) {
    if(GetPlayerAdminLevel(playerid) < 1) return 0;
    if(!IsPlayerInAnyVehicle(playerid)) return 0;
    ToggleVehicleParachute(GetPlayerVehicleID(playerid), true);
    return 1;
}