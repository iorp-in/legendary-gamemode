//./samp-npc -h 127.0.0.1 -p 7777 -n TrainDriverLV -m train_lv &
//./samp-npc -h 127.0.0.1 -p 7777 -n TrainDriverLS -m train_ls &
//./samp-npc -h 127.0.0.1 -p 7777 -n TrainDriverSF -m train_sf &
new Train_ID_LS, Train_ID_SF, Train_ID_LV;

hook OnGameModeInit()
{
    Train_ID_LS = CreateVehicle(538, 1700.7551, -1953.6531, 14.8756, 200.0, -1, -1, -1);
    Train_ID_SF = CreateVehicle(538, -1942.7950, 168.4164, 27.0006, 200.0, -1, -1, -1);
    Train_ID_LV = CreateVehicle(538, 1462.0745, 2630.8787, 10.8203, 200.0, -1, -1, -1);
    return 1;
}


hook OnPlayerRequestClass(playerid, classid)
{
	if(!IsPlayerNPC(playerid)) return 1; // We only deal with NPC players in this script
    else if(IsStringSame("TrainDriverLS", GetPlayerNameEx(playerid))) SetSpawnInfo(playerid,69,255,1700.7551,-1953.6531,14.8756,0.0,-1,-1,-1,-1,-1,-1), SpawnPlayer(playerid);
    else if(IsStringSame("TrainDriverSF", GetPlayerNameEx(playerid))) SetSpawnInfo(playerid,69,255,-1942.7950,168.4164,27.0006,0.0,-1,-1,-1,-1,-1,-1), SpawnPlayer(playerid);
    else if(IsStringSame("TrainDriverLV", GetPlayerNameEx(playerid))) SetSpawnInfo(playerid,69,255,1462.0745,2630.8787,10.8203,0.0,-1,-1,-1,-1,-1,-1), SpawnPlayer(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid)) return 1; // We only deal with NPC players in this script
    else if(IsStringSame("TrainDriverLS", GetPlayerNameEx(playerid))) PutPlayerInVehicleEx(playerid, Train_ID_LS, 0), Start_Train_Engine(Train_ID_LS);
    else if(IsStringSame("TrainDriverSF", GetPlayerNameEx(playerid))) PutPlayerInVehicleEx(playerid, Train_ID_SF, 0), Start_Train_Engine(Train_ID_SF);
    else if(IsStringSame("TrainDriverLV", GetPlayerNameEx(playerid))) PutPlayerInVehicleEx(playerid, Train_ID_LV, 0), Start_Train_Engine(Train_ID_LV);
    return 1;
}

stock Start_Train_Engine(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
    return 1;
}