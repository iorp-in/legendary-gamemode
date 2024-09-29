
new VehicleDestroyed = 136;

IRPC:VehicleDestroyed(playerid, BitStream:bs) {
    new vehicleid;
    BS_ReadUint16(bs, vehicleid);
    if(GetVehicleModel(vehicleid) < 400 || GetVehicleModel(vehicleid) > 611) return 0;
    return OnVehicleDeathRequest(vehicleid, playerid);
}

forward OnVehicleDeathRequest(vehicleid, killerid);
public OnVehicleDeathRequest(vehicleid, killerid) {
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
    if(health >= 250.0 && z > 0) return 0;
    return 1;
}