#define Crop_Type_Corn 0
#define Crop_Type_Wheat 1
#define Crop_Type_Onion 2
#define Crop_Type_Potato 3
#define Crop_Type_Garlic 4
#define Crop_Type_Vinegar 5
#define Crop_Type_Tomato 6
#define Crop_Type_Rice 7

#define FARM_RESET_SECS 36 * 60 * 60
#define MAX_FARMS 10
#define MAX_FARM_PLANTS 4000

#define FARM_MIN_PRICE 50000
#define FARM_MAX_PRICE 99000

enum Farm:enumData {
    Farm:Owner[50],
        Farm:FarmName[50],
        Farm:Price,
        Farm:CropType,
        Farm:Stage,
        Farm:StageInitiatedAt,
        Float:Farm:Cord[3],
        Text3D:Farm:text3d,
        Farm:pickup
}

enum Farm:storageEnum {
    Farm:FarmID,
    Farm:TruckLoading,
    Farm:TruckUnloading,
    Float:Farm:Cord[3],
    Float:Farm:CpCord[3],
    Farm:Corn,
    Farm:SeedCorn,
    Farm:Wheat,
    Farm:SeedWheat,
    Farm:Onion,
    Farm:SeedOnion,
    Farm:Potato,
    Farm:SeedPotato,
    Farm:Garlic,
    Farm:SeedGarlic,
    Farm:Vinegar,
    Farm:SeedVinegar,
    Farm:Tomato,
    Farm:SeedTomato,
    Farm:Rice,
    Farm:SeedRice,
    Text3D:Farm:stext3d,
    Farm:spickup
}
enum Farm:PlantEnum {
    Farm:FarmID,
    Float:Farm:Cord[6],
    Farm:objectID,
    Text3D:Farm:text3d
}
enum Farm:PlayerDataEnum {
    bool:Farm:isEditing,
    Farm:plantID,
    bool:Farm:isStartedWork,
    Farm:cpFarmID,
    Farm:cpID,
    Farm:cpPlantCount
}
new Farm:PlayerData[MAX_PLAYERS][Farm:PlayerDataEnum];
new Farm:PlantData[MAX_FARM_PLANTS][Farm:PlantEnum];
new Farm:FarmData[MAX_FARMS][Farm:enumData];
new Farm:FarmStorageData[MAX_FARMS][Farm:storageEnum];
new Iterator:Farms < MAX_FARMS > ;
new Iterator:FarmPlants < MAX_FARM_PLANTS > ;
new Iterator:FarmStorages < MAX_FARMS > ;

hook OnGameModeInit() {
    new query[1024];
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS `farms` (\
    `ID` INT NOT NULL,\
	`Owner` VARCHAR(50) NOT NULL DEFAULT '-',\
	`FarmName` VARCHAR(50) NOT NULL DEFAULT 'My Farm',\
	`Price` INT NOT NULL DEFAULT '0',\
	`CropType` INT NOT NULL DEFAULT '-1',\
	`Stage` INT NOT NULL DEFAULT '0',\
	`StageInitiatedAt` INT NOT NULL DEFAULT '0',\
	`CordX` FLOAT NOT NULL DEFAULT '0.0',\
	`CordY` FLOAT NOT NULL DEFAULT '0.0',\
	`CordZ` FLOAT NOT NULL DEFAULT '0.0',\
    PRIMARY KEY (`ID`))");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM `farms`", "LoadFarms", "");
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS farmStorage (\
	`ID` INT NOT NULL,\
	`FarmID` INT NOT NULL,\
	`CordX` FLOAT NOT NULL DEFAULT '0.0',\
	`CordY` FLOAT NOT NULL DEFAULT '0.0',\
	`CordZ` FLOAT NOT NULL DEFAULT '0.0',\
	`CpCordX` FLOAT NOT NULL DEFAULT '0.0',\
	`CpCordY` FLOAT NOT NULL DEFAULT '0.0',\
	`CpCordZ` FLOAT NOT NULL DEFAULT '0.0',\
	`Corn` INT NOT NULL DEFAULT '0',\
	`SeedCorn` INT NOT NULL DEFAULT '0',\
	`Wheat` INT NOT NULL DEFAULT '0',\
	`SeedWheat` INT NOT NULL DEFAULT '0',\
	`Onion` INT NOT NULL DEFAULT '0',\
	`SeedOnion` INT NOT NULL DEFAULT '0',\
	`Potato` INT NOT NULL DEFAULT '0',\
	`SeedPotato` INT NOT NULL DEFAULT '0',\
	`Garlic` INT NOT NULL DEFAULT '0',\
	`SeedGarlic` INT NOT NULL DEFAULT '0',\
	`Vinegar` INT NOT NULL DEFAULT '0',\
	`SeedVinegar` INT NOT NULL DEFAULT '0',\
	`Tomato` INT NOT NULL DEFAULT '0',\
	`SeedTomato` INT NOT NULL DEFAULT '0',\
	`Rice` INT NOT NULL DEFAULT '0',\
	`SeedRice` INT NOT NULL DEFAULT '0',\
	PRIMARY KEY (`ID`))");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM farmStorage", "LoadFarmStorage", "");
    format(query, sizeof query, "CREATE TABLE IF NOT EXISTS farmPlants (\
	`ID` INT NOT NULL,\
	`FarmID` INT NOT NULL,\
	`CordX` FLOAT NOT NULL DEFAULT '0.0',\
	`CordY` FLOAT NOT NULL DEFAULT '0.0',\
	`CordZ` FLOAT NOT NULL DEFAULT '0.0',\
	`RCordX` FLOAT NOT NULL DEFAULT '0.0',\
	`RCordY` FLOAT NOT NULL DEFAULT '0.0',\
	`RCordZ` FLOAT NOT NULL DEFAULT '0.0',\
	PRIMARY KEY (`ID`))");
    mysql_tquery(Database, query);
    mysql_tquery(Database, "SELECT * FROM farmPlants", "LoadFarmPlants", "");
    return 1;
}

forward LoadFarms();
public LoadFarms() {
    new rows = cache_num_rows();
    if (rows) {
        new i, farmid;
        while (i < rows) {
            cache_get_value_name_int(i, "ID", farmid);
            cache_get_value_name(i, "Owner", Farm:FarmData[farmid][Farm:Owner]);
            cache_get_value_name(i, "FarmName", Farm:FarmData[farmid][Farm:FarmName]);
            cache_get_value_name_int(i, "Price", Farm:FarmData[farmid][Farm:Price]);
            cache_get_value_name_int(i, "CropType", Farm:FarmData[farmid][Farm:CropType]);
            cache_get_value_name_int(i, "Stage", Farm:FarmData[farmid][Farm:Stage]);
            cache_get_value_name_int(i, "StageInitiatedAt", Farm:FarmData[farmid][Farm:StageInitiatedAt]);
            cache_get_value_name_float(i, "CordX", Farm:FarmData[farmid][Farm:Cord][0]);
            cache_get_value_name_float(i, "CordY", Farm:FarmData[farmid][Farm:Cord][1]);
            cache_get_value_name_float(i, "CordZ", Farm:FarmData[farmid][Farm:Cord][2]);
            Iter_Add(Farms, farmid);
            Farm:Update(farmid);
            i++;
        }
    }
    return 1;
}

stock Farm:CreatePlantCp(playerid, farmid, idCount = 0) {
    if (!Farm:isValidFarmID(farmid)) return 1;
    new count = 0;
    foreach(new i:FarmPlants) {
        if (Farm:PlantData[i][Farm:FarmID] == farmid) {
            if (count == idCount) {
                if (Farm:FarmData[farmid][Farm:Stage] == 9) Farm:PlayerData[playerid][Farm:cpID] = CreateDynamicCP(Farm:PlantData[i][Farm:Cord][0], Farm:PlantData[i][Farm:Cord][1], Farm:PlantData[i][Farm:Cord][2] + 0.8, 3.0, 0, 0, playerid);
                else Farm:PlayerData[playerid][Farm:cpID] = CreateDynamicCP(Farm:PlantData[i][Farm:Cord][0], Farm:PlantData[i][Farm:Cord][1], Farm:PlantData[i][Farm:Cord][2] + 0.8, 2.0, 0, 0, playerid);
                return Farm:PlayerData[playerid][Farm:cpID];
            }
            count++;
        }
    }
    return -1;
}

stock StartFarmingCpSequance(playerid, farmid) {
    if (!Farm:isValidFarmID(farmid)) return 1;
    Farm:PlayerData[playerid][Farm:isStartedWork] = true;
    Farm:PlayerData[playerid][Farm:cpFarmID] = farmid;
    Farm:PlayerData[playerid][Farm:cpPlantCount] = 0;
    Farm:CreatePlantCp(playerid, farmid, 0);
    switch (Farm:FarmData[farmid][Farm:Stage]) {
        case 0, 10 :  {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}take your tractor and drive on farm field");
        }
        case 1 :  {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}take your tractor and drive on farm field");
        }
        case 3, 5, 7 :  {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}take your tractor and drive on farm field");
        }
        case 9 :  {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}take your harvester and drive on farm field");
        }
    }
    return 1;
}

stock OnFarmingCpSeuance(playerid) {
    new farmid = Farm:PlayerData[playerid][Farm:cpFarmID];
    if (!Farm:isValidFarmID(farmid)) return 1;
    new nextPlant = Farm:PlayerData[playerid][Farm:cpPlantCount] + 1;
    if (nextPlant == Farm:GetTotalFarmPlants(farmid)) {
        DestroyDynamicCP(Farm:PlayerData[playerid][Farm:cpID]);
        Farm:PlayerData[playerid][Farm:isStartedWork] = false;
        switch (Farm:GetFarmStageID(farmid)) {
            case 0, 10 :  {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}your farm has been prepared for seeding");
                Farm:SetFarmStage(farmid, Farm:GetFarmStageID(farmid) + 1);
            }
            case 1 :  {
                new requiredSeed = Farm:GetTotalFarmPlants(farmid);
                new storageid = Farm:GetStorageIdofFarm(farmid);
                new cropType = Farm:FarmData[farmid][Farm:CropType];
                Farm:DeductSeed(storageid, cropType, requiredSeed);
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}your farm has been seeded");
                Farm:SetFarmStage(farmid, Farm:GetFarmStageID(farmid) + 1);
            }
            case 3, 5, 7 :  {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}your farm has been watered");
                Farm:SetFarmStage(farmid, Farm:GetFarmStageID(farmid) + 1);
            }
            case 9 :  {
                new requiredSeed = Farm:GetTotalFarmPlants(farmid);
                new storageid = Farm:GetStorageIdofFarm(farmid);
                new cropType = Farm:FarmData[farmid][Farm:CropType];
                Farm:FarmData[farmid][Farm:CropType] = -1;
                Farm:AddResource(storageid, cropType, 5 * requiredSeed);
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}your farm has been harvested");
                Farm:SetFarmStage(farmid, Farm:GetFarmStageID(farmid) + 1);
            }
        }
        Farm:Update(farmid);
        Farm:DbUpdateFarm(farmid);
    } else {
        if (Farm:FarmData[farmid][Farm:Stage] == 3 || Farm:FarmData[farmid][Farm:Stage] == 5 || Farm:FarmData[farmid][Farm:Stage] == 7) {
            if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your tractor");
            if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 531) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your tractor");
            new trailerid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
            if (!IsValidVehicle(trailerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Farm Trailer");
            if (GetVehicleModel(trailerid) != 610) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Farm Trailer");
        } else if (Farm:FarmData[farmid][Farm:Stage] == 9) {
            if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Combine Harvester");
            if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 532) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Combine Harvester");
        } else {
            if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your tractor");
            if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 531) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your tractor");
            new trailerid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
            if (!IsValidVehicle(trailerid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Farm Trailer");
            if (GetVehicleModel(trailerid) != 610) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}where is your Farm Trailer");
        }
        DestroyDynamicCP(Farm:PlayerData[playerid][Farm:cpID]);
        Farm:PlayerData[playerid][Farm:cpPlantCount]++;
        Farm:PlayerData[playerid][Farm:cpID] = Farm:CreatePlantCp(playerid, farmid, Farm:PlayerData[playerid][Farm:cpPlantCount]);
        GameTextForPlayer(playerid, sprintf("~g~plant %d out of %d", Farm:PlayerData[playerid][Farm:cpPlantCount], Farm:GetTotalFarmPlants(farmid)), 500, 3);
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid) {
    if (Farm:PlayerData[playerid][Farm:cpID] == checkpointid) OnFarmingCpSeuance(playerid);
    return 1;
}

forward LoadFarmStorage();
public LoadFarmStorage() {
    new rows = cache_num_rows();
    if (rows) {
        new i, storageid;
        while (i < rows) {
            cache_get_value_name_int(i, "ID", storageid);
            cache_get_value_name_int(i, "FarmID", Farm:FarmStorageData[storageid][Farm:FarmID]);
            cache_get_value_name_float(i, "CordX", Farm:FarmStorageData[storageid][Farm:Cord][0]);
            cache_get_value_name_float(i, "CordY", Farm:FarmStorageData[storageid][Farm:Cord][1]);
            cache_get_value_name_float(i, "CordZ", Farm:FarmStorageData[storageid][Farm:Cord][2]);
            cache_get_value_name_float(i, "CpCordX", Farm:FarmStorageData[storageid][Farm:CpCord][0]);
            cache_get_value_name_float(i, "CpCordY", Farm:FarmStorageData[storageid][Farm:CpCord][1]);
            cache_get_value_name_float(i, "CpCordZ", Farm:FarmStorageData[storageid][Farm:CpCord][2]);
            cache_get_value_name_int(i, "Corn", Farm:FarmStorageData[storageid][Farm:Corn]);
            cache_get_value_name_int(i, "SeedCorn", Farm:FarmStorageData[storageid][Farm:SeedCorn]);
            cache_get_value_name_int(i, "Wheat", Farm:FarmStorageData[storageid][Farm:Wheat]);
            cache_get_value_name_int(i, "SeedWheat", Farm:FarmStorageData[storageid][Farm:SeedWheat]);
            cache_get_value_name_int(i, "Onion", Farm:FarmStorageData[storageid][Farm:Onion]);
            cache_get_value_name_int(i, "SeedOnion", Farm:FarmStorageData[storageid][Farm:SeedOnion]);
            cache_get_value_name_int(i, "Potato", Farm:FarmStorageData[storageid][Farm:Potato]);
            cache_get_value_name_int(i, "SeedPotato", Farm:FarmStorageData[storageid][Farm:SeedPotato]);
            cache_get_value_name_int(i, "Garlic", Farm:FarmStorageData[storageid][Farm:Garlic]);
            cache_get_value_name_int(i, "SeedGarlic", Farm:FarmStorageData[storageid][Farm:SeedGarlic]);
            cache_get_value_name_int(i, "Vinegar", Farm:FarmStorageData[storageid][Farm:Vinegar]);
            cache_get_value_name_int(i, "SeedVinegar", Farm:FarmStorageData[storageid][Farm:SeedVinegar]);
            cache_get_value_name_int(i, "Tomato", Farm:FarmStorageData[storageid][Farm:Tomato]);
            cache_get_value_name_int(i, "SeedTomato", Farm:FarmStorageData[storageid][Farm:SeedTomato]);
            cache_get_value_name_int(i, "Rice", Farm:FarmStorageData[storageid][Farm:Rice]);
            cache_get_value_name_int(i, "SeedRice", Farm:FarmStorageData[storageid][Farm:SeedRice]);
            Farm:FarmStorageData[storageid][Farm:TruckLoading] = 0;
            Farm:FarmStorageData[storageid][Farm:TruckUnloading] = 0;
            Iter_Add(FarmStorages, storageid);
            Farm:UpdateStorage(storageid);
            i++;
        }
    }
    return 1;
}

forward LoadFarmPlants();
public LoadFarmPlants() {
    new rows = cache_num_rows();
    if (rows) {
        new i, plantid;
        while (i < rows) {
            cache_get_value_name_int(i, "ID", plantid);
            cache_get_value_name_int(i, "FarmID", Farm:PlantData[plantid][Farm:FarmID]);
            cache_get_value_name_float(i, "CordX", Farm:PlantData[plantid][Farm:Cord][0]);
            cache_get_value_name_float(i, "CordY", Farm:PlantData[plantid][Farm:Cord][1]);
            cache_get_value_name_float(i, "CordZ", Farm:PlantData[plantid][Farm:Cord][2]);
            cache_get_value_name_float(i, "RCordX", Farm:PlantData[plantid][Farm:Cord][3]);
            cache_get_value_name_float(i, "RCordY", Farm:PlantData[plantid][Farm:Cord][4]);
            cache_get_value_name_float(i, "RCordZ", Farm:PlantData[plantid][Farm:Cord][5]);
            Iter_Add(FarmPlants, plantid);
            Farm:UpdatePlant(plantid);
            i++;
        }
    }
    return 1;
}

hook GlobalOneMinuteInterval() {
    foreach(new farmid:Farms) {
        switch (Farm:FarmData[farmid][Farm:Stage]) {
            case 2 :  {
                new currentTime = gettime();
                new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
                if (next_stage_time < currentTime) {
                    Farm:SetFarmStage(farmid, 3);
                }
            }
            case 4 :  {
                new currentTime = gettime();
                new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
                if (next_stage_time < currentTime) {
                    Farm:SetFarmStage(farmid, 5);
                }
            }
            case 6 :  {
                new currentTime = gettime();
                new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
                if (next_stage_time < currentTime) {
                    Farm:SetFarmStage(farmid, 7);
                }
            }
            case 8 :  {
                new currentTime = gettime();
                new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
                if (next_stage_time < currentTime) {
                    Farm:SetFarmStage(farmid, 9);
                }
            }
            case 9 :  {
                new currentTime = gettime();
                new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + FARM_RESET_SECS;
                if (next_stage_time < currentTime) {
                    Farm:SetFarmStage(farmid, 10);
                }
            }
        }
        Farm:Update(farmid);

        new currentTime = gettime();
        new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + FARM_RESET_SECS;
        if (next_stage_time < currentTime) {
            format(Farm:FarmData[farmid][Farm:Owner], 50, "-");
            format(Farm:FarmData[farmid][Farm:FarmName], 50, "My Farm");
            Farm:FarmData[farmid][Farm:CropType] = -1;
            Farm:FarmData[farmid][Farm:Price] = RandomEx(FARM_MIN_PRICE, FARM_MAX_PRICE);
            Farm:FarmData[farmid][Farm:Stage] = 0;
            Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
            Farm:Update(farmid);
        }
    }
    return 1;
}

stock Farm:DbUpdateFarm(farmid) {
    if (!Farm:isValidFarmID(farmid)) return 1;
    new query[1024];
    format(query, sizeof query, "Update `farms` SET \
	`Owner` = \"%s\",\
	`FarmName` = \"%s\",\
	`Price` = %d,\
	`CropType` = %d,\
	`Stage` = %d,\
	`StageInitiatedAt` = %d,\
	`CordX` = %f,\
	`CordY` = %f,\
	`CordZ` = %f \
	where `ID` = %d",
        Farm:FarmData[farmid][Farm:Owner], Farm:FarmData[farmid][Farm:FarmName], Farm:FarmData[farmid][Farm:Price], Farm:FarmData[farmid][Farm:CropType], Farm:FarmData[farmid][Farm:Stage],
        Farm:FarmData[farmid][Farm:StageInitiatedAt], Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2], farmid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbInsertFarm(farmid) {
    if (!Farm:isValidFarmID(farmid)) return 1;
    new query[1024];
    format(query, sizeof query, "INSERT INTO `farms` (`ID`, `Owner`, `FarmName`, `Price`, `CropType`, `Stage`, `StageInitiatedAt`, `CordX`, `CordY`, `CordZ`)  VALUES (%d, \"%s\", \"%s\", %d, %d, %d, %d, %f, %f, %f)",
        farmid, Farm:FarmData[farmid][Farm:Owner], Farm:FarmData[farmid][Farm:FarmName], Farm:FarmData[farmid][Farm:Price], Farm:FarmData[farmid][Farm:CropType], Farm:FarmData[farmid][Farm:Stage],
        Farm:FarmData[farmid][Farm:StageInitiatedAt], Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2]);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbDeleteFarm(farmid) {
    new query[1024];
    format(query, sizeof query, "Delete from `farms` where `ID` = %d", farmid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbUpdateStorage(storageid) {
    if (!Farm:isValidFarmStorageID(storageid)) return 1;
    new query[1024];
    format(query, sizeof query, "Update farmStorage SET\
	`FarmID` = %d,\
	`CordX` = %f,\
	`CordY` = %f,\
	`CordZ` = %f,\
	`CpCordX` = %f,\
	`CpCordY` = %f,\
	`CpCordZ` = %f,\
	`Corn` = %d,\
	`SeedCorn` = %d,\
	`Wheat` = %d,\
	`SeedWheat` = %d,\
	`Onion` = %d,\
	`SeedOnion` = %d,\
	`Potato` = %d,\
	`SeedPotato` = %d,\
	`Garlic` = %d,\
	`SeedGarlic` = %d,\
	`Vinegar` = %d,\
	`SeedVinegar` = %d,\
	`Tomato` = %d,\
	`SeedTomato` = %d,\
	`Rice` = %d,\
	`SeedRice` = %d \
	where `ID` = %d",
        Farm:FarmStorageData[storageid][Farm:FarmID], Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2],
        Farm:FarmStorageData[storageid][Farm:CpCord][0], Farm:FarmStorageData[storageid][Farm:CpCord][1], Farm:FarmStorageData[storageid][Farm:CpCord][2],
        Farm:FarmStorageData[storageid][Farm:Corn], Farm:FarmStorageData[storageid][Farm:SeedCorn], Farm:FarmStorageData[storageid][Farm:Wheat], Farm:FarmStorageData[storageid][Farm:SeedWheat],
        Farm:FarmStorageData[storageid][Farm:Onion], Farm:FarmStorageData[storageid][Farm:SeedOnion], Farm:FarmStorageData[storageid][Farm:Potato], Farm:FarmStorageData[storageid][Farm:SeedPotato],
        Farm:FarmStorageData[storageid][Farm:Garlic], Farm:FarmStorageData[storageid][Farm:SeedGarlic], Farm:FarmStorageData[storageid][Farm:Vinegar], Farm:FarmStorageData[storageid][Farm:SeedVinegar],
        Farm:FarmStorageData[storageid][Farm:Tomato], Farm:FarmStorageData[storageid][Farm:SeedTomato], Farm:FarmStorageData[storageid][Farm:Rice], Farm:FarmStorageData[storageid][Farm:SeedRice], storageid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbInsertStorage(storageid) {
    if (!Farm:isValidFarmStorageID(storageid)) return 1;
    new query[1024];
    format(query, sizeof query, "INSERT INTO farmStorage (`ID`, `FarmID`, `CordX`, `CordY`, `CordZ`, `CpCordX`, `CpCordY`, `CpCordZ`, `Corn`, `SeedCorn`, `Wheat`, `SeedWheat`, `Onion`, `SeedOnion`, `Potato`, `SeedPotato`, `Garlic`, `SeedGarlic`, `Vinegar`, `SeedVinegar`, `Tomato`, `SeedTomato`, `Rice`, `SeedRice`) \
    VALUES (%d, %d, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)",
        storageid, Farm:FarmStorageData[storageid][Farm:FarmID], Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2],
        Farm:FarmStorageData[storageid][Farm:CpCord][0], Farm:FarmStorageData[storageid][Farm:CpCord][1], Farm:FarmStorageData[storageid][Farm:CpCord][2],
        Farm:FarmStorageData[storageid][Farm:Corn], Farm:FarmStorageData[storageid][Farm:SeedCorn], Farm:FarmStorageData[storageid][Farm:Wheat], Farm:FarmStorageData[storageid][Farm:SeedWheat],
        Farm:FarmStorageData[storageid][Farm:Onion], Farm:FarmStorageData[storageid][Farm:SeedOnion], Farm:FarmStorageData[storageid][Farm:Potato], Farm:FarmStorageData[storageid][Farm:SeedPotato],
        Farm:FarmStorageData[storageid][Farm:Garlic], Farm:FarmStorageData[storageid][Farm:SeedGarlic], Farm:FarmStorageData[storageid][Farm:Vinegar], Farm:FarmStorageData[storageid][Farm:SeedVinegar],
        Farm:FarmStorageData[storageid][Farm:Tomato], Farm:FarmStorageData[storageid][Farm:SeedTomato], Farm:FarmStorageData[storageid][Farm:Rice], Farm:FarmStorageData[storageid][Farm:SeedRice]);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbDeleteStorage(storageid) {
    new query[1024];
    format(query, sizeof query, "Delete from farmStorage where `ID` = %d", storageid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbUpdatePlant(plantid) {
    if (!Farm:isValidPlantID(plantid)) return 1;
    new query[1024];
    format(query, sizeof query, "Update farmPlants SET \
	`FarmID` = %d, `CordX` = %f, `CordY` = %f, `CordZ` = %f, `RCordX` = %f,	`RCordY` = %f, `RCordZ` = %f where `ID` = %d",
        Farm:PlantData[plantid][Farm:FarmID], Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2], Farm:PlantData[plantid][Farm:Cord][3],
        Farm:PlantData[plantid][Farm:Cord][4], Farm:PlantData[plantid][Farm:Cord][5], plantid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbInsertPlant(plantid) {
    if (!Farm:isValidPlantID(plantid)) return 1;
    new query[1024];
    format(query, sizeof query, "INSERT INTO farmPlants (`ID`, `FarmID`, `CordX`, `CordY`, `CordZ`, `RCordX`, `RCordY`, `RCordZ`) VALUES (%d, %d, %f, %f, %f, %f, %f, %f)",
        plantid, Farm:PlantData[plantid][Farm:FarmID], Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2], Farm:PlantData[plantid][Farm:Cord][3],
        Farm:PlantData[plantid][Farm:Cord][4], Farm:PlantData[plantid][Farm:Cord][5]);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:DbDeletePlant(plantid) {
    new query[1024];
    format(query, sizeof query, "Delete from farmPlants where `ID` = %d", plantid);
    mysql_tquery(Database, query);
    return 1;
}

stock Farm:GetFarmStage(farmid) {
    new string[512];
    format(string, 50, "Dead Farm");
    switch (Farm:FarmData[farmid][Farm:Stage]) {
        case 0:
            format(string, 50, "Required Land Preparation");
        case 1:
            format(string, 50, "Required Seed Sowing");
        case 2 :  {
            new currentTime = gettime();
            new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
            if (next_stage_time > currentTime) {
                format(string, 50, "Crop Growing (wait until %s)", secondsToHms(next_stage_time - currentTime));
            } else {
                format(string, 50, "Required Irrigation");
            }
        }
        case 3:
            format(string, 50, "Required Irrigation");
        case 4 :  {
            new currentTime = gettime();
            new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
            if (next_stage_time > currentTime) {
                format(string, 50, "Crop Growing (wait until %s)", secondsToHms(next_stage_time - currentTime));
            } else {
                format(string, 50, "Required Irrigation");
            }
        }
        case 5:
            format(string, 50, "Required Irrigation");
        case 6 :  {
            new currentTime = gettime();
            new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
            if (next_stage_time > currentTime) {
                format(string, 50, "Crop Growing (wait until %s)", secondsToHms(next_stage_time - currentTime));
            } else {
                format(string, 50, "Required Irrigation");
            }
        }
        case 7:
            format(string, 50, "Required Irrigation");
        case 8 :  {
            new currentTime = gettime();
            new next_stage_time = Farm:FarmData[farmid][Farm:StageInitiatedAt] + 10 * 60;
            if (next_stage_time > currentTime) {
                format(string, 50, "Crop Growing (wait until %s)", secondsToHms(next_stage_time - currentTime));
            } else {
                format(string, 50, "Required Harvesting");
            }
        }
        case 9:
            format(string, 50, "Required Harvesting");
    }
    return string;
}

stock Farm:SetFarmStage(farmid, stage) {
    Farm:FarmData[farmid][Farm:Stage] = stage;
    Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
    return 1;
}

stock Farm:GetFarmStageID(farmid) {
    return Farm:FarmData[farmid][Farm:Stage];
}

stock Farm:GetFarmsCount() {
    return Iter_Count(Farms);
}

stock Farm:isValidFarmID(farmid) {
    return Iter_Contains(Farms, farmid);
}

stock Farm:isValidPlantID(plantid) {
    return Iter_Contains(FarmPlants, plantid);
}

stock Farm:GetPlayerNearestFarmID(playerid) {
    foreach(new farmid:Farms) {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2])) return farmid;
    }
    return -1;
}

stock Farm:GetToralPurchased(playerid) {
    new count = 0;
    foreach(new farmid:Farms) {
        if (IsStringSame(GetPlayerNameEx(playerid), Farm:FarmData[farmid][Farm:Owner])) count++;
    }
    return count;
}

stock Farm:GetPlayerNearestStorageID(playerid, Float:distance = 5.0) {
    foreach(new storageid:FarmStorages) {
        if (IsPlayerInRangeOfPoint(playerid, distance, Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2])) return storageid;
    }
    return -1;
}

stock Farm:GetTotalFarmPlants(farmid) {
    new count = 0;
    foreach(new i:FarmPlants) {
        if (Farm:PlantData[i][Farm:FarmID] == farmid) count++;
    }
    return count;
}

stock Farm:IsFarmPurchased(farmid) {
    if (IsStringSame(Farm:FarmData[farmid][Farm:Owner], "-")) return 0;
    return 1;
}

stock Farm:SetFarmOwner(farmid, const owner[]) {
    format(Farm:FarmData[farmid][Farm:Owner], 50, "%s", owner);
    return 1;
}

stock Farm:GetFarmOwner(farmid) {
    new string[50];
    format(string, 50, "%s", Farm:FarmData[farmid][Farm:Owner]);
    return string;
}

stock Farm:GetFarmName(farmid) {
    new string[50];
    format(string, 50, "%s", Farm:FarmData[farmid][Farm:FarmName]);
    return string;
}

stock Farm:IsPlayerFarmOwner(playerid, farmid) {
    return IsStringSame(GetPlayerNameEx(playerid), Farm:FarmData[farmid][Farm:Owner]);
}

stock Farm:GetStorageFarmID(storageid) {
    return Farm:FarmStorageData[storageid][Farm:FarmID];
}

stock Farm:IsStorageExistForFarm(farmid) {
    foreach(new storageid:FarmStorages) {
        if (Farm:FarmStorageData[storageid][Farm:FarmID] == farmid) return 1;
    }
    return 0;
}

stock Farm:GetStorageIdofFarm(farmid) {
    foreach(new storageid:FarmStorages) {
        if (Farm:FarmStorageData[storageid][Farm:FarmID] == farmid) return storageid;
    }
    return -1;
}

stock Farm:isValidFarmStorageID(storageid) {
    return Iter_Contains(FarmStorages, storageid);
}

stock Farm:GetCropName(cropType) {
    new string[50];
    format(string, sizeof string, "NaN");
    switch (cropType) {
        case 0 :  { format(string, sizeof string, "Corn"); }
        case 1 :  { format(string, sizeof string, "Wheat"); }
        case 2 :  { format(string, sizeof string, "Onion"); }
        case 3 :  { format(string, sizeof string, "Potato"); }
        case 4 :  { format(string, sizeof string, "Garlic"); }
        case 5 :  { format(string, sizeof string, "Vinegar"); }
        case 6 :  { format(string, sizeof string, "Tomato"); }
        case 7 :  { format(string, sizeof string, "Rice"); }
    }
    return string;
}

stock Farm:AccessFarmStorage(playerid, storageid) {
    if (!Farm:IsPlayerFarmOwner(playerid, Farm:GetStorageFarmID(storageid))) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}nah sorry, only owner can access :(");
        return 1;
    }
    new string[512];
    if (!Farm:FarmStorageData[storageid][Farm:TruckLoading]) strcat(string, "Enable truck loading\n");
    else strcat(string, "Disable truck loading\n");
    if (!Farm:FarmStorageData[storageid][Farm:TruckUnloading]) strcat(string, "Enable truck unloading\n");
    else strcat(string, "Disable truck unloading\n");
    FlexPlayerDialog(playerid, "FarmStorageMenu", DIALOG_STYLE_LIST, "Farm Storage", string, "Select", "Close", storageid);
    return 1;
}

FlexDialog:FarmStorageMenu(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Enable truck loading")) Farm:FarmStorageData[storageid][Farm:TruckLoading] = 1;
    if (IsStringSame(inputtext, "Disable truck loading")) Farm:FarmStorageData[storageid][Farm:TruckLoading] = 0;
    if (IsStringSame(inputtext, "Enable truck unloading")) Farm:FarmStorageData[storageid][Farm:TruckUnloading] = 1;
    if (IsStringSame(inputtext, "Disable truck unloading")) Farm:FarmStorageData[storageid][Farm:TruckUnloading] = 0;
    Farm:AccessFarmStorage(playerid, storageid);
    return 1;
}

stock Farm:Update(farmid) {
    if (!Farm:isValidFarmID(farmid)) return 1;
    DestroyDynamic3DTextLabel(Farm:FarmData[farmid][Farm:text3d]);
    DestroyDynamicPickup(Farm:FarmData[farmid][Farm:pickup]);
    new string[1024];
    if (!Farm:IsFarmPurchased(farmid)) {
        strcat(string, sprintf("{2ecc71}Farm: {ffffff}%s [%d] {e74c3c}(On Sale)\n", Farm:FarmData[farmid][Farm:FarmName], farmid));
        strcat(string, sprintf("{e74c3c}Owner: {ffffff}San Andreas Government Department\n"));
        strcat(string, sprintf("{e74c3c}Price: {ffffff}$%s\n\n", FormatCurrency(Farm:FarmData[farmid][Farm:Price])));
        strcat(string, sprintf("{3498db}press N to buy this farm\n"));
    } else {
        strcat(string, sprintf("{2ecc71}Farm: {ffffff}%s [%d]\n", Farm:FarmData[farmid][Farm:FarmName], farmid));
        strcat(string, sprintf("{e74c3c}Owner: {ffffff}%s\n", Farm:FarmData[farmid][Farm:Owner]));
        strcat(string, sprintf("{e74c3c}Last Used At: {ffffff}%s\n", UnixToHumanEx(Farm:FarmData[farmid][Farm:StageInitiatedAt])));
        strcat(string, sprintf("{e74c3c}Reset At: {ffffff}%s\n", UnixToHumanEx(Farm:FarmData[farmid][Farm:StageInitiatedAt] + FARM_RESET_SECS)));
        strcat(string, sprintf("{e74c3c}Crop: {ffffff}%s\n", Farm:GetCropName(Farm:FarmData[farmid][Farm:CropType])));
        strcat(string, sprintf("{e74c3c}Farming Stage: {ffffff} %s\n", Farm:GetFarmStage(farmid)));
        strcat(string, sprintf("{3498db}press N to open menu\n"));
    }
    Farm:FarmData[farmid][Farm:text3d] = CreateDynamic3DTextLabel(string, -1, Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2], 10.0);
    Farm:FarmData[farmid][Farm:pickup] = CreateDynamicPickup(19320, 0, Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2], 0, 0);
    return 1;
}

stock Farm:UpdateStorage(storageid) {
    if (!Farm:isValidFarmStorageID(storageid)) return 1;
    DestroyDynamicPickup(Farm:FarmStorageData[storageid][Farm:spickup]);
    DestroyDynamic3DTextLabel(Farm:FarmStorageData[storageid][Farm:stext3d]);
    new string[1024];
    strcat(string, sprintf("{2ecc71}Seed Storage for {ffffff}%s's  farm [%d]\n", Farm:FarmData[Farm:FarmStorageData[storageid][Farm:FarmID]][Farm:FarmName], storageid));
    strcat(string, sprintf("{e74c3c}Corn: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Corn], Farm:FarmStorageData[storageid][Farm:SeedCorn]));
    strcat(string, sprintf("{e74c3c}Wheat: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Wheat], Farm:FarmStorageData[storageid][Farm:SeedWheat]));
    strcat(string, sprintf("{e74c3c}Onion: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Onion], Farm:FarmStorageData[storageid][Farm:SeedOnion]));
    strcat(string, sprintf("{e74c3c}Potato: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Potato], Farm:FarmStorageData[storageid][Farm:SeedPotato]));
    strcat(string, sprintf("{e74c3c}Garlic: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Garlic], Farm:FarmStorageData[storageid][Farm:SeedGarlic]));
    strcat(string, sprintf("{e74c3c}Vinegar: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Vinegar], Farm:FarmStorageData[storageid][Farm:SeedVinegar]));
    strcat(string, sprintf("{e74c3c}Tomato: {FFFFFF}%d kg [Seed: %d kg]\n", Farm:FarmStorageData[storageid][Farm:Tomato], Farm:FarmStorageData[storageid][Farm:SeedTomato]));
    strcat(string, sprintf("{e74c3c}Rice: {FFFFFF}%d kg [Seed: %d kg]\n\n", Farm:FarmStorageData[storageid][Farm:Rice], Farm:FarmStorageData[storageid][Farm:SeedRice]));
    strcat(string, sprintf("{3498db}truckers use: /alexa access trailer\n"));
    Farm:FarmStorageData[storageid][Farm:stext3d] = CreateDynamic3DTextLabel(string, -1, Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2], 10.0);
    Farm:FarmStorageData[storageid][Farm:spickup] = CreateDynamicPickup(19132, 0, Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2], 0, 0);
    return 1;
}

stock Farm:UpdatePlant(plantid) {
    if (!Farm:isValidPlantID(plantid)) return 1;
    DestroyDynamicObjectEx(Farm:PlantData[plantid][Farm:objectID]);
    Farm:PlantData[plantid][Farm:objectID] = CreateDynamicObject(3409, Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2], Farm:PlantData[plantid][Farm:Cord][3], Farm:PlantData[plantid][Farm:Cord][4], Farm:PlantData[plantid][Farm:Cord][5]);
    return 1;
}

stock Farm:AddSeed(storageid, cropType, addSeed) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:SeedCorn] = Farm:FarmStorageData[storageid][Farm:SeedCorn] + addSeed; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:SeedWheat] = Farm:FarmStorageData[storageid][Farm:SeedWheat] + addSeed; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:SeedOnion] = Farm:FarmStorageData[storageid][Farm:SeedOnion] + addSeed; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:SeedPotato] = Farm:FarmStorageData[storageid][Farm:SeedPotato] + addSeed; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:SeedGarlic] = Farm:FarmStorageData[storageid][Farm:SeedGarlic] + addSeed; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:SeedVinegar] = Farm:FarmStorageData[storageid][Farm:SeedVinegar] + addSeed; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:SeedTomato] = Farm:FarmStorageData[storageid][Farm:SeedTomato] + addSeed; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:SeedRice] = Farm:FarmStorageData[storageid][Farm:SeedRice] + addSeed; }
    }
    Farm:DbUpdateStorage(storageid);
    Farm:UpdateStorage(storageid);
    return 1;
}

stock Farm:DeductSeed(storageid, cropType, requiredSeed) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:SeedCorn] = Farm:FarmStorageData[storageid][Farm:SeedCorn] - requiredSeed; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:SeedWheat] = Farm:FarmStorageData[storageid][Farm:SeedWheat] - requiredSeed; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:SeedOnion] = Farm:FarmStorageData[storageid][Farm:SeedOnion] - requiredSeed; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:SeedPotato] = Farm:FarmStorageData[storageid][Farm:SeedPotato] - requiredSeed; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:SeedGarlic] = Farm:FarmStorageData[storageid][Farm:SeedGarlic] - requiredSeed; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:SeedVinegar] = Farm:FarmStorageData[storageid][Farm:SeedVinegar] - requiredSeed; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:SeedTomato] = Farm:FarmStorageData[storageid][Farm:SeedTomato] - requiredSeed; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:SeedRice] = Farm:FarmStorageData[storageid][Farm:SeedRice] - requiredSeed; }
    }
    Farm:DbUpdateStorage(storageid);
    Farm:UpdateStorage(storageid);
    return 1;
}

stock Farm:IsHaveSeed(storageid, cropType, requiredSeed) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedCorn] > requiredSeed) return 1;
            else return 0;
        }
        case 1 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedWheat] > requiredSeed) return 1;
            else return 0;
        }
        case 2 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedOnion] > requiredSeed) return 1;
            else return 0;
        }
        case 3 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedPotato] > requiredSeed) return 1;
            else return 0;
        }
        case 4 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedGarlic] > requiredSeed) return 1;
            else return 0;
        }
        case 5 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedVinegar] > requiredSeed) return 1;
            else return 0;
        }
        case 6 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedTomato] > requiredSeed) return 1;
            else return 0;
        }
        case 7 :  {
            if (Farm:FarmStorageData[storageid][Farm:SeedRice] > requiredSeed) return 1;
            else return 0;
        }
    }
    return 0;
}

stock Farm:AddResource(storageid, cropType, addResourceInKG) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:Corn] = Farm:FarmStorageData[storageid][Farm:Corn] + addResourceInKG; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:Wheat] = Farm:FarmStorageData[storageid][Farm:Wheat] + addResourceInKG; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:Onion] = Farm:FarmStorageData[storageid][Farm:Onion] + addResourceInKG; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:Potato] = Farm:FarmStorageData[storageid][Farm:Potato] + addResourceInKG; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:Garlic] = Farm:FarmStorageData[storageid][Farm:Garlic] + addResourceInKG; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:Vinegar] = Farm:FarmStorageData[storageid][Farm:Vinegar] + addResourceInKG; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:Tomato] = Farm:FarmStorageData[storageid][Farm:Tomato] + addResourceInKG; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:Rice] = Farm:FarmStorageData[storageid][Farm:Rice] + addResourceInKG; }
    }
    Farm:DbUpdateStorage(storageid);
    Farm:UpdateStorage(storageid);
    return 0;
}

stock Farm:DeductResource(storageid, cropType, deductResourceInKG) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:Corn] = Farm:FarmStorageData[storageid][Farm:Corn] - deductResourceInKG; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:Wheat] = Farm:FarmStorageData[storageid][Farm:Wheat] - deductResourceInKG; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:Onion] = Farm:FarmStorageData[storageid][Farm:Onion] - deductResourceInKG; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:Potato] = Farm:FarmStorageData[storageid][Farm:Potato] - deductResourceInKG; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:Garlic] = Farm:FarmStorageData[storageid][Farm:Garlic] - deductResourceInKG; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:Vinegar] = Farm:FarmStorageData[storageid][Farm:Vinegar] - deductResourceInKG; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:Tomato] = Farm:FarmStorageData[storageid][Farm:Tomato] - deductResourceInKG; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:Rice] = Farm:FarmStorageData[storageid][Farm:Rice] - deductResourceInKG; }
    }
    Farm:DbUpdateStorage(storageid);
    Farm:UpdateStorage(storageid);
    return 0;
}

stock Farm:IsHaveResource(storageid, cropType, requiredResourceInKG) {
    if (!Farm:isValidFarmStorageID(storageid)) return 0;
    switch (cropType) {
        case 0 :  {
            if (Farm:FarmStorageData[storageid][Farm:Corn] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 1 :  {
            if (Farm:FarmStorageData[storageid][Farm:Wheat] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 2 :  {
            if (Farm:FarmStorageData[storageid][Farm:Onion] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 3 :  {
            if (Farm:FarmStorageData[storageid][Farm:Potato] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 4 :  {
            if (Farm:FarmStorageData[storageid][Farm:Garlic] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 5 :  {
            if (Farm:FarmStorageData[storageid][Farm:Vinegar] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 6 :  {
            if (Farm:FarmStorageData[storageid][Farm:Tomato] > requiredResourceInKG) return 1;
            else return 0;
        }
        case 7 :  {
            if (Farm:FarmStorageData[storageid][Farm:Rice] > requiredResourceInKG) return 1;
            else return 0;
        }
    }
    return 0;
}

hook OnPlayerEditDynObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
    if (response == EDIT_RESPONSE_FINAL) {
        if (!Farm:PlayerData[playerid][Farm:isEditing]) return 1;
        new plantid = Farm:PlayerData[playerid][Farm:plantID];
        if (!Farm:isValidPlantID(plantid)) return 1;
        Farm:PlantData[plantid][Farm:Cord][0] = x;
        Farm:PlantData[plantid][Farm:Cord][1] = y;
        Farm:PlantData[plantid][Farm:Cord][2] = z;
        Farm:PlantData[plantid][Farm:Cord][3] = rx;
        Farm:PlantData[plantid][Farm:Cord][4] = ry;
        Farm:PlantData[plantid][Farm:Cord][5] = rz;
        Farm:UpdatePlant(plantid);
        Farm:DbUpdatePlant(plantid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}updated plant: %d", plantid));
        Farm:FarmAdminManage(playerid, Farm:PlantData[plantid][Farm:FarmID]);
        Farm:PlayerData[playerid][Farm:isEditing] = false;
        Farm:PlayerData[playerid][Farm:plantID] = -1;
        return 1;
    } else if (response == EDIT_RESPONSE_CANCEL) {
        if (!Farm:PlayerData[playerid][Farm:isEditing]) return 1;
        Farm:FarmAdminManage(playerid, Farm:PlantData[Farm:PlayerData[playerid][Farm:plantID]][Farm:FarmID]);
        Farm:PlayerData[playerid][Farm:isEditing] = false;
        Farm:PlayerData[playerid][Farm:plantID] = -1;
        return 1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new farmid = Farm:GetPlayerNearestFarmID(playerid);
    new storageID = Farm:GetPlayerNearestStorageID(playerid);
    if (farmid != -1) {
        Farm:AccessFarm(playerid, farmid);
        return ~1;
    }
    if (storageID != -1) {
        Farm:AccessFarmStorage(playerid, storageID);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (BetaTester:IsPlayer(playerid) || IsPlayerMasterAdmin(playerid)) {
        if (IsStringContainWords(text, "farming system")) {
            Farm:FarmAdminMenu(playerid);
            return ~1;
        }
    }
    return 1;
}

stock Farm:PurchaseOffer(playerid, farmid) {
    new string[1024];
    strcat(string, "do you want to purchase this farm?");
    return FlexPlayerDialog(playerid, "FarmPurchaseOffer", DIALOG_STYLE_MSGBOX, "Purchase Farm", string, "Buy", "Cancel", farmid);
}

FlexDialog:FarmPurchaseOffer(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return AlexaMsg(playerid, "farm lang purchase offer rejected");
    new farmprice = Farm:FarmData[farmid][Farm:Price];
    if (Farm:GetToralPurchased(playerid) > 0) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you can only purchase one farm");
    if (Farm:IsFarmPurchased(farmid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} farm is already purchased by someone else");
    if (GetPlayerCash(playerid) < farmprice) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you don't have enough cash to purchase this farm");
    Farm:SetFarmOwner(farmid, GetPlayerNameEx(playerid));
    Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
    AddPlayerLog(
        playerid,
        sprintf("Purchased a farm [%d] from the government for $%s", farmid, FormatCurrency(farmprice)),
        "business"
    );
    vault:PlayerVault(playerid, -farmprice, sprintf("purchased farm [%d]", farmid), Vault_ID_Government, farmprice, sprintf("sold farm [%d] to %s", farmid, GetPlayerNameEx(playerid)));
    Farm:Update(farmid);
    Farm:DbUpdateFarm(farmid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have purchased this farm, Keep using it otherwise it will auto reset withing 24 hours");
    return 1;
}

stock Farm:AccessFarm(playerid, farmid) {
    if (!Farm:IsFarmPurchased(farmid)) return Farm:PurchaseOffer(playerid, farmid);
    if (!Farm:IsPlayerFarmOwner(playerid, farmid)) return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}nah sorry, only owner can access :(");
    new string[1024];
    if (Farm:PlayerData[playerid][Farm:isStartedWork]) strcat(string, "Cancel Current Job\n");
    else {
        switch (Farm:FarmData[farmid][Farm:Stage]) {
            case 0, 10 : strcat(string, "Start Land Preparation\n");
            case 1 : strcat(string, "Start Seed Sowing\n");
            case 2 : return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Seed Sowed, wait untill it required Irrigation");
            case 3 : strcat(string, "Start Irrigation\n");
            case 4 : return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Crop Growing, wait untill it required Irrigation");
            case 5 : strcat(string, "Start Irrigation\n");
            case 6 : return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Crop Growing, wait untill it required Irrigation");
            case 7 : strcat(string, "Start Irrigation\n");
            case 8 : return SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Fertilizing, wait untill it required Harvesting");
            case 9 : strcat(string, "Start Harvesting\n");
        }
        strcat(string, "Sale Land to Government\n");
    }
    return FlexPlayerDialog(playerid, "FarmAccessFarm", DIALOG_STYLE_LIST, "Farm Control", string, "Select", "Close", farmid);
}

FlexDialog:FarmAccessFarm(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Cancel Current Job")) {
        Farm:PlayerData[playerid][Farm:isStartedWork] = false;
        Farm:PlayerData[playerid][Farm:cpFarmID] = -1;
        Farm:PlayerData[playerid][Farm:cpPlantCount] = 0;
        DestroyDynamicCP(Farm:PlayerData[playerid][Farm:cpID]);
        Farm:PlayerData[playerid][Farm:cpID] = -1;
        return Farm:AccessFarm(playerid, farmid);
    }
    if (IsStringSame(inputtext, "Sale Land to Government")) {
        new string[512];
        strcat(string, "Hi there, you are about to sell this land to San Andreas Government\n");
        strcat(string, "remember, there is no going back if you confirm this sell\n");
        strcat(string, "you will recieved on going market value of this land\n");
        strcat(string, "press enter to confirm the sell or esc to cancel\n");
        return FlexPlayerDialog(playerid, "FarmSaleLandtoGovernment", DIALOG_STYLE_MSGBOX, "Sell Land", string, "Yes", "No", farmid);
    }
    if (IsStringSame(inputtext, "Start Land Preparation")) return StartFarmingCpSequance(playerid, farmid);
    if (IsStringSame(inputtext, "Start Seed Sowing")) {
        new string[512];
        strcat(string, "ID\tCrop\n");
        strcat(string, "1\tCorn\n");
        strcat(string, "2\tWheat\n");
        strcat(string, "3\tOnion\n");
        strcat(string, "4\tPotato\n");
        strcat(string, "5\tGarlic\n");
        strcat(string, "6\tVinegar\n");
        strcat(string, "7\tTomato\n");
        strcat(string, "8\tRice\n");
        return FlexPlayerDialog(playerid, "FarmStartSeedSowing", DIALOG_STYLE_TABLIST_HEADERS, "Select Crop for Farming", string, "Select", "Close", farmid);
    }
    if (IsStringSame(inputtext, "Start Irrigation")) return StartFarmingCpSequance(playerid, farmid);
    if (IsStringSame(inputtext, "Start Harvesting")) return StartFarmingCpSequance(playerid, farmid);
    return 1;
}

FlexDialog:FarmSaleLandtoGovernment(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:AccessFarm(playerid, farmid);
    new farmprice = Farm:FarmData[farmid][Farm:Price];
    new cash = GetPercentageOf(RandomEx(50, 70), farmprice);
    if (cash > 0) {
        AddPlayerLog(
            playerid,
            sprintf("Purchased a sold [%d] from the government for $%s", farmid, FormatCurrency(cash)),
            "business"
        );
        vault:PlayerVault(playerid, cash, sprintf("sold farm [%d] to government", farmid), Vault_ID_Government, -cash, sprintf("%s sold farm [%d] to government", GetPlayerNameEx(playerid), farmid));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Farm]: {FFFFEE}you have recieved $%s from land sale", FormatCurrency(cash)));
    }
    format(Farm:FarmData[farmid][Farm:Owner], 50, "-");
    format(Farm:FarmData[farmid][Farm:FarmName], 50, "My Farm");
    Farm:FarmData[farmid][Farm:CropType] = -1;
    Farm:FarmData[farmid][Farm:Price] = RandomEx(FARM_MIN_PRICE, FARM_MAX_PRICE);
    Farm:FarmData[farmid][Farm:Stage] = 0;
    Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
    Farm:Update(farmid);
    Farm:DbUpdateFarm(farmid);
    SendClientMessage(playerid, -1, "{4286f4}[Farm]: {FFFFEE}land has been sold to government");
    return 1;
}

FlexDialog:FarmStartSeedSowing(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:AccessFarm(playerid, farmid);
    new cropType = strval(inputtext) - 1;
    new requiredSeed = Farm:GetTotalFarmPlants(farmid);
    new storageid = Farm:GetStorageIdofFarm(farmid);
    if (storageid == -1) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your farm does not have storage and any seed for further farming");
        return Farm:AccessFarm(playerid, farmid);
    }
    if (!Farm:IsHaveSeed(storageid, cropType, requiredSeed)) {
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}you don't have %d %s_Seed, buy seeds from seed market then continue", requiredSeed, Farm:GetCropName(cropType)));
        return Farm:AccessFarm(playerid, farmid);
    }
    Farm:FarmData[farmid][Farm:CropType] = cropType;
    StartFarmingCpSequance(playerid, farmid);
    return 1;
}

stock Farm:FarmAdminMenu(playerid) {
    new string[1024];
    strcat(string, "Create Farm\n");
    strcat(string, "Create Farm Storage\n");
    strcat(string, "Manage Farm\n");
    strcat(string, "Manage Storage\n");
    return FlexPlayerDialog(playerid, "FarmFarmAdminMenu", DIALOG_STYLE_LIST, "Farming System: Admin Panel", string, "Select", "Close");
}

FlexDialog:FarmFarmAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Farm")) {
        new farmid = Iter_Free(Farms);
        new storageid = Iter_Free(FarmStorages);
        if (Farm:GetFarmsCount() >= MAX_FARMS || farmid == INVALID_ITERATOR_SLOT || storageid == INVALID_ITERATOR_SLOT) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE} ah, actually we can't make more farms :(");
            return Farm:FarmAdminMenu(playerid);
        }
        format(Farm:FarmData[farmid][Farm:Owner], 50, "-");
        format(Farm:FarmData[farmid][Farm:FarmName], 50, "My Farm");
        Farm:FarmData[farmid][Farm:CropType] = -1;
        Farm:FarmData[farmid][Farm:Price] = RandomEx(FARM_MIN_PRICE, FARM_MAX_PRICE);
        Farm:FarmData[farmid][Farm:Stage] = 0;
        Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
        GetPlayerPos(playerid, Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2]);
        Iter_Add(Farms, farmid);
        Farm:Update(farmid);
        Farm:DbInsertFarm(farmid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE} created %s with ID: %d", Farm:FarmData[farmid][Farm:FarmName], farmid));

        Iter_Add(FarmStorages, storageid);
        Farm:FarmStorageData[storageid][Farm:FarmID] = farmid;
        Farm:FarmStorageData[storageid][Farm:TruckLoading] = 0;
        Farm:FarmStorageData[storageid][Farm:TruckUnloading] = 0;
        Farm:FarmStorageData[storageid][Farm:Corn] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedCorn] = 0;
        Farm:FarmStorageData[storageid][Farm:Wheat] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedWheat] = 0;
        Farm:FarmStorageData[storageid][Farm:Onion] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedOnion] = 0;
        Farm:FarmStorageData[storageid][Farm:Potato] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedPotato] = 0;
        Farm:FarmStorageData[storageid][Farm:Garlic] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedGarlic] = 0;
        Farm:FarmStorageData[storageid][Farm:Vinegar] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedVinegar] = 0;
        Farm:FarmStorageData[storageid][Farm:Tomato] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedTomato] = 0;
        Farm:FarmStorageData[storageid][Farm:Rice] = 0;
        Farm:FarmStorageData[storageid][Farm:SeedRice] = 0;
        GetPlayerPos(playerid, Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2]);
        Farm:UpdateStorage(storageid);
        Farm:DbInsertStorage(storageid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}farm storage created for %s with ID: %d", Farm:FarmData[farmid][Farm:FarmName], storageid));
        return Farm:FarmAdminManage(playerid, farmid);
    }
    if (IsStringSame(inputtext, "Manage Farm")) return Farm:MenuInputManageFarm(playerid);
    if (IsStringSame(inputtext, "Manage Storage")) return Farm:MenuInputManageStorage(playerid);
    return 1;
}

stock Farm:MenuInputManageFarm(playerid) {
    return FlexPlayerDialog(playerid, "FarmMenuInputManageFarm", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Farm ID", "Submit", "Cancel");
}

FlexDialog:FarmMenuInputManageFarm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Farm:FarmAdminMenu(playerid);
    new farmid;
    if (sscanf(inputtext, "d", farmid) || !Farm:isValidFarmID(farmid)) return Farm:MenuInputManageFarm(playerid);
    return Farm:FarmAdminManage(playerid, farmid);
}

stock Farm:FarmAdminManage(playerid, farmid) {
    new string[1024];
    strcat(string, "Show ID of plants\n");
    strcat(string, "Hide ID of plants\n");
    strcat(string, "Create Plant\n");
    strcat(string, "Edit Plant\n");
    strcat(string, "Remove Plant\n");
    strcat(string, "Remove All Plant\n");
    strcat(string, "Update Name\n");
    strcat(string, "Update Price\n");
    strcat(string, "Update Location\n");
    strcat(string, "Reset Farm\n");
    strcat(string, "Remove Farm\n");
    return FlexPlayerDialog(playerid, "FarmFarmAdminManage", DIALOG_STYLE_LIST, "Farming System: Admin Panel", string, "Select", "Close", farmid);
}

FlexDialog:FarmFarmAdminManage(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:MenuInputManageStorage(playerid);
    if (IsStringSame(inputtext, "Edit Plant")) return Farm:MenuEditPlant(playerid, farmid);
    if (IsStringSame(inputtext, "Remove Plant")) return Farm:MenuRemovePlant(playerid, farmid);
    if (IsStringSame(inputtext, "Update Name")) return Farm:MenuUpdateName(playerid, farmid);
    if (IsStringSame(inputtext, "Update Price")) return Farm:MenuUpdatePrice(playerid, farmid);
    if (IsStringSame(inputtext, "Show ID of plants")) {
        foreach(new plantid:FarmPlants) {
            if (Farm:PlantData[plantid][Farm:FarmID] == farmid) {
                DestroyDynamic3DTextLabel(Farm:PlantData[plantid][Farm:text3d]);
                Farm:PlantData[plantid][Farm:text3d] = CreateDynamic3DTextLabel(sprintf("Plant ID: %d, Farm ID: %d", plantid, Farm:PlantData[plantid][Farm:FarmID]), -1, Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2], 5.0);
            }
        }
        return Farm:FarmAdminManage(playerid, farmid);
    }
    if (IsStringSame(inputtext, "Hide ID of plants")) {
        foreach(new plantid:FarmPlants) {
            if (Farm:PlantData[plantid][Farm:FarmID] == farmid) {
                DestroyDynamic3DTextLabel(Farm:PlantData[plantid][Farm:text3d]);
                Farm:PlantData[plantid][Farm:text3d] = Text3D:  - 1;
            }
        }
        return Farm:FarmAdminManage(playerid, farmid);
    }
    if (IsStringSame(inputtext, "Create Plant")) {
        new plantid = Iter_Free(FarmPlants);
        if (plantid == INVALID_ITERATOR_SLOT) return ~1;
        if (Farm:GetTotalFarmPlants(farmid) >= 400 || plantid == INVALID_ITERATOR_SLOT) {
            SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}already created maximum plants for %s", Farm:GetFarmName(farmid)));
            return Farm:FarmAdminManage(playerid, farmid);
        }
        Iter_Add(FarmPlants, plantid);
        GetPlayerPos(playerid, Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2]);
        Farm:PlantData[plantid][Farm:Cord][3] = Farm:PlantData[plantid][Farm:Cord][0];
        Farm:PlantData[plantid][Farm:Cord][4] = Farm:PlantData[plantid][Farm:Cord][1];
        Farm:PlantData[plantid][Farm:Cord][5] = Farm:PlantData[plantid][Farm:Cord][2];
        Farm:PlantData[plantid][Farm:FarmID] = farmid;
        Farm:PlantData[plantid][Farm:Cord][3] = 0.0;
        Farm:PlantData[plantid][Farm:Cord][4] = 0.0;
        Farm:PlantData[plantid][Farm:Cord][5] = 0.0;
        Farm:DbInsertPlant(plantid);
        Farm:PlantData[plantid][Farm:objectID] = CreateDynamicObject(3409, Farm:PlantData[plantid][Farm:Cord][0], Farm:PlantData[plantid][Farm:Cord][1], Farm:PlantData[plantid][Farm:Cord][2], Farm:PlantData[plantid][Farm:Cord][3], Farm:PlantData[plantid][Farm:Cord][4], Farm:PlantData[plantid][Farm:Cord][5]);
        Farm:PlayerData[playerid][Farm:isEditing] = true;
        Farm:PlayerData[playerid][Farm:plantID] = plantid;
        return EditDynamicObject(playerid, Farm:PlantData[plantid][Farm:objectID]);
    }
    if (IsStringSame(inputtext, "Remove All Plant")) {
        mysql_tquery(Database, sprintf("Delete from farmPlants where `FarmID` = %d", farmid));
        foreach(new plantid:FarmPlants) {
            if (Farm:PlantData[plantid][Farm:FarmID] == farmid) {
                DestroyDynamic3DTextLabel(Farm:PlantData[plantid][Farm:text3d]);
                DestroyDynamicObjectEx(Farm:PlantData[plantid][Farm:objectID]);
                Iter_SafeRemove(FarmPlants, plantid, plantid);
            }
        }
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}all plants delete for %s", Farm:GetFarmName(farmid)));
        return Farm:FarmAdminManage(playerid, farmid);
    }
    if (IsStringSame(inputtext, "Update Location")) {
        GetPlayerPos(playerid, Farm:FarmData[farmid][Farm:Cord][0], Farm:FarmData[farmid][Farm:Cord][1], Farm:FarmData[farmid][Farm:Cord][2]);
        Farm:Update(farmid);
        Farm:DbUpdateFarm(farmid);
        return Farm:FarmAdminMenu(playerid);
    }
    if (IsStringSame(inputtext, "Reset Farm")) {
        format(Farm:FarmData[farmid][Farm:Owner], 50, "-");
        format(Farm:FarmData[farmid][Farm:FarmName], 50, "My Farm");
        Farm:FarmData[farmid][Farm:CropType] = -1;
        Farm:FarmData[farmid][Farm:Price] = RandomEx(FARM_MIN_PRICE, FARM_MAX_PRICE);
        Farm:FarmData[farmid][Farm:Stage] = 0;
        Farm:FarmData[farmid][Farm:StageInitiatedAt] = gettime();
        Farm:Update(farmid);
        Farm:DbUpdateFarm(farmid);
        return Farm:FarmAdminMenu(playerid);
    }
    if (IsStringSame(inputtext, "Remove Farm")) {
        mysql_tquery(Database, sprintf("Delete FROM `farms` WHERE `ID` = %d", farmid));
        mysql_tquery(Database, sprintf("Delete FROM farmPlants WHERE `FarmID` = %d", farmid));
        mysql_tquery(Database, sprintf("Delete FROM farmStorage WHERE `FarmID` = %d", farmid));

        // remove all plants
        foreach(new plantid:FarmPlants) {
            if (Farm:PlantData[plantid][Farm:FarmID] == farmid) {
                DestroyDynamic3DTextLabel(Farm:PlantData[plantid][Farm:text3d]);
                DestroyDynamicObjectEx(Farm:PlantData[plantid][Farm:objectID]);
                Iter_SafeRemove(FarmPlants, plantid, plantid);
            }
        }
        // for storage removal
        foreach(new storageid:FarmStorages) {
            if (Farm:FarmStorageData[storageid][Farm:FarmID] == farmid) {
                DestroyDynamic3DTextLabel(Farm:FarmStorageData[storageid][Farm:stext3d]);
                Farm:FarmStorageData[storageid][Farm:stext3d] = Text3D:  - 1;
                Iter_SafeRemove(FarmStorages, storageid, storageid);
            }
        }
        // remove farm
        DestroyDynamic3DTextLabel(Farm:FarmData[farmid][Farm:text3d]);
        DestroyDynamicPickup(Farm:FarmData[farmid][Farm:pickup]);
        Farm:FarmData[farmid][Farm:text3d] = Text3D:  - 1;
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}deleted %s", Farm:GetFarmName(farmid)));
        Iter_SafeRemove(Farms, farmid, farmid);
        return Farm:FarmAdminMenu(playerid);
    }
    return 1;
}

Farm:MenuEditPlant(playerid, farmid) {
    return FlexPlayerDialog(playerid, "FarmMenuEditPlant", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Plant ID", "Submit", "Close", farmid);
}

FlexDialog:FarmMenuEditPlant(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:FarmAdminManage(playerid, farmid);
    new plantid;
    if (sscanf(inputtext, "d", plantid) || !Farm:isValidPlantID(plantid) || Farm:PlantData[plantid][Farm:FarmID] != farmid) return Farm:MenuEditPlant(playerid, farmid);
    Farm:PlayerData[playerid][Farm:isEditing] = true;
    Farm:PlayerData[playerid][Farm:plantID] = plantid;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}editing plant %d for %s", plantid, Farm:GetFarmName(farmid)));
    return EditDynamicObject(playerid, Farm:PlantData[plantid][Farm:objectID]);
}

Farm:MenuRemovePlant(playerid, farmid) {
    return FlexPlayerDialog(playerid, "FarmMenuRemovePlant", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Plant ID", "Submit", "Close", farmid);
}

FlexDialog:FarmMenuRemovePlant(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:FarmAdminManage(playerid, farmid);
    new plantid;
    if (sscanf(inputtext, "d", plantid) || !Farm:isValidPlantID(plantid) || Farm:PlantData[plantid][Farm:FarmID] != farmid) return Farm:MenuEditPlant(playerid, farmid);
    DestroyDynamic3DTextLabel(Farm:PlantData[plantid][Farm:text3d]);
    DestroyDynamicObjectEx(Farm:PlantData[plantid][Farm:objectID]);
    Farm:DbDeletePlant(plantid);
    Iter_SafeRemove(FarmPlants, plantid, plantid);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}removed plant %d from %s", plantid, Farm:GetFarmName(farmid)));
    return Farm:FarmAdminManage(playerid, farmid);
}

Farm:MenuUpdateName(playerid, farmid) {
    return FlexPlayerDialog(playerid, "FarmMenuUpdateName", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter farm new name", "Submit", "Close", farmid);
}

FlexDialog:FarmMenuUpdateName(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:FarmAdminManage(playerid, farmid);
    new name[50];
    if (sscanf(inputtext, "s[50]", name)) return Farm:MenuUpdateName(playerid, farmid);
    format(Farm:FarmData[farmid][Farm:FarmName], 50, "%s", name);
    Farm:DbUpdateFarm(farmid);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}farm name is now: %s", Farm:GetFarmName(farmid)));
    Farm:Update(farmid);
    foreach(new storageid:FarmStorages) {
        if (Farm:FarmStorageData[storageid][Farm:FarmID] == farmid) {
            Farm:UpdateStorage(storageid);
            Farm:DbUpdateStorage(storageid);
        }
    }
    return Farm:FarmAdminManage(playerid, farmid);
}

Farm:MenuUpdatePrice(playerid, farmid) {
    return FlexPlayerDialog(playerid, "FarmMenuUpdatePrice", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Farm New Price", "Submit", "Close", farmid);
}

FlexDialog:FarmMenuUpdatePrice(playerid, response, listitem, const inputtext[], farmid, const payload[]) {
    if (!response) return Farm:FarmAdminManage(playerid, farmid);
    new price;
    if (sscanf(inputtext, "d", price) || price < 1) return Farm:MenuUpdatePrice(playerid, farmid);
    Farm:FarmData[farmid][Farm:Price] = price;
    Farm:Update(farmid);
    Farm:DbUpdateFarm(farmid);
    return Farm:FarmAdminManage(playerid, farmid);
}

stock Farm:MenuInputManageStorage(playerid) {
    return FlexPlayerDialog(playerid, "FarmMenuInputManageStorage", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Storage ID", "Submit", "Cancel");
}

FlexDialog:FarmMenuInputManageStorage(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Farm:FarmAdminMenu(playerid);
    new storageid;
    if (sscanf(inputtext, "d", storageid) || !Farm:isValidFarmStorageID(storageid)) return Farm:MenuInputManageStorage(playerid);
    return Farm:FarmMenuManageStorage(playerid, storageid);
}

stock Farm:FarmMenuManageStorage(playerid, storageid) {
    new string[1024];
    strcat(string, "Set All Seed\n");
    strcat(string, "Update Location\n");
    strcat(string, "Update Vehicle Location\n");
    strcat(string, "Remove Storage\n");
    return FlexPlayerDialog(playerid, "FarmMenuManageStorage", DIALOG_STYLE_LIST, "Farming System: Admin Panel", string, "Select", "Close", storageid);
}

FlexDialog:FarmMenuManageStorage(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    if (!response) return Farm:MenuInputManageStorage(playerid);
    if (IsStringSame(inputtext, "Set All Seed")) return Farm:MenuSetStorageSeed(playerid, storageid);
    if (IsStringSame(inputtext, "Update Location")) {
        GetPlayerPos(playerid, Farm:FarmStorageData[storageid][Farm:Cord][0], Farm:FarmStorageData[storageid][Farm:Cord][1], Farm:FarmStorageData[storageid][Farm:Cord][2]);
        Farm:UpdateStorage(storageid);
        Farm:DbUpdateStorage(storageid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}updated location for storage %d", storageid));
        return Farm:FarmMenuManageStorage(playerid, storageid);
    }
    if (IsStringSame(inputtext, "Update Vehicle Location")) {
        GetPlayerPos(playerid, Farm:FarmStorageData[storageid][Farm:CpCord][0], Farm:FarmStorageData[storageid][Farm:CpCord][1], Farm:FarmStorageData[storageid][Farm:CpCord][2]);
        Farm:UpdateStorage(storageid);
        Farm:DbUpdateStorage(storageid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}updated vehicle location for storage %d", storageid));
        return Farm:FarmMenuManageStorage(playerid, storageid);
    }
    if (IsStringSame(inputtext, "Remove Storage")) {
        DestroyDynamic3DTextLabel(Farm:FarmStorageData[storageid][Farm:stext3d]);
        Farm:FarmStorageData[storageid][Farm:stext3d] = Text3D:  - 1;
        Farm:DbDeleteStorage(storageid);
        Iter_Remove(FarmStorages, storageid);
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}removed storage %d", storageid));
        return Farm:FarmAdminMenu(playerid);
    }
    return 1;
}

Farm:MenuSetStorageSeed(playerid, storageid) {
    return FlexPlayerDialog(playerid, "FarmMenuSetStorageSeed", DIALOG_STYLE_INPUT, "Farming System: Admin Panel", "Enter Seed Amount to Set", "Submit", "Close", storageid);
}

FlexDialog:FarmMenuSetStorageSeed(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    if (!response) return Farm:FarmMenuManageStorage(playerid, storageid);
    new seed;
    if (sscanf(inputtext, "d", seed) || seed < 0) return Farm:MenuSetStorageSeed(playerid, storageid);
    Farm:FarmStorageData[storageid][Farm:Corn] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedCorn] = seed;
    Farm:FarmStorageData[storageid][Farm:Wheat] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedWheat] = seed;
    Farm:FarmStorageData[storageid][Farm:Onion] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedOnion] = seed;
    Farm:FarmStorageData[storageid][Farm:Potato] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedPotato] = seed;
    Farm:FarmStorageData[storageid][Farm:Garlic] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedGarlic] = seed;
    Farm:FarmStorageData[storageid][Farm:Vinegar] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedVinegar] = seed;
    Farm:FarmStorageData[storageid][Farm:Tomato] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedTomato] = seed;
    Farm:FarmStorageData[storageid][Farm:Rice] = seed;
    Farm:FarmStorageData[storageid][Farm:SeedRice] = seed;
    Farm:UpdateStorage(storageid);
    Farm:DbUpdateStorage(storageid);
    return Farm:FarmMenuManageStorage(playerid, storageid);
}

stock Farm:GetCropResource(storageid, cropType) {
    switch (cropType) {
        case 0 :  { return Farm:FarmStorageData[storageid][Farm:Corn]; }
        case 1 :  { return Farm:FarmStorageData[storageid][Farm:Wheat]; }
        case 2 :  { return Farm:FarmStorageData[storageid][Farm:Onion]; }
        case 3 :  { return Farm:FarmStorageData[storageid][Farm:Potato]; }
        case 4 :  { return Farm:FarmStorageData[storageid][Farm:Garlic]; }
        case 5 :  { return Farm:FarmStorageData[storageid][Farm:Vinegar]; }
        case 6 :  { return Farm:FarmStorageData[storageid][Farm:Tomato]; }
        case 7 :  { return Farm:FarmStorageData[storageid][Farm:Rice]; }
    }
    return 0;
}

stock Farm:SetCropResource(storageid, cropType, amount) {
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:Corn] = amount; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:Wheat] = amount; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:Onion] = amount; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:Potato] = amount; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:Garlic] = amount; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:Vinegar] = amount; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:Tomato] = amount; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:Rice] = amount; }
    }
    return 1;
}

stock Farm:GetCropSeed(storageid, cropType) {
    switch (cropType) {
        case 0 :  { return Farm:FarmStorageData[storageid][Farm:SeedCorn]; }
        case 1 :  { return Farm:FarmStorageData[storageid][Farm:SeedWheat]; }
        case 2 :  { return Farm:FarmStorageData[storageid][Farm:SeedOnion]; }
        case 3 :  { return Farm:FarmStorageData[storageid][Farm:SeedPotato]; }
        case 4 :  { return Farm:FarmStorageData[storageid][Farm:SeedGarlic]; }
        case 5 :  { return Farm:FarmStorageData[storageid][Farm:SeedVinegar]; }
        case 6 :  { return Farm:FarmStorageData[storageid][Farm:SeedTomato]; }
        case 7 :  { return Farm:FarmStorageData[storageid][Farm:SeedRice]; }
    }
    return 0;
}

stock Farm:SetCropSeed(storageid, cropType, amount) {
    switch (cropType) {
        case 0 :  { Farm:FarmStorageData[storageid][Farm:SeedCorn] = amount; }
        case 1 :  { Farm:FarmStorageData[storageid][Farm:SeedWheat] = amount; }
        case 2 :  { Farm:FarmStorageData[storageid][Farm:SeedOnion] = amount; }
        case 3 :  { Farm:FarmStorageData[storageid][Farm:SeedPotato] = amount; }
        case 4 :  { Farm:FarmStorageData[storageid][Farm:SeedGarlic] = amount; }
        case 5 :  { Farm:FarmStorageData[storageid][Farm:SeedVinegar] = amount; }
        case 6 :  { Farm:FarmStorageData[storageid][Farm:SeedTomato] = amount; }
        case 7 :  { Farm:FarmStorageData[storageid][Farm:SeedRice] = amount; }
    }
    return 1;
}

stock Farm:GetTypeName(cropType) {
    new string[50] = "unknown";
    switch (cropType) {
        case 0 : format(string, sizeof string, "Corn"); // Corn
        case 1 : format(string, sizeof string, "Wheat"); // Wheat
        case 2 : format(string, sizeof string, "Onion"); // Onion
        case 3 : format(string, sizeof string, "Potato"); // Potato
        case 4 : format(string, sizeof string, "Garlic"); // Garlic
        case 5 : format(string, sizeof string, "Vinegar"); // Vinegar
        case 6 : format(string, sizeof string, "Tomato"); // Tomato
        case 7 : format(string, sizeof string, "Rice"); // Rice
    }
    return string;
}

DTruck:OnInit(playerid, trailerid, page) {
    new storageid = Farm:GetPlayerNearestStorageID(playerid, 20.0);
    if (storageid != -1 && Farm:IsFarmPurchased(Farm:GetStorageFarmID(storageid))) DTruck:AddCommand(playerid, "Access Farming Storage");
    return 1;
}

DTruck:OnResponse(playerid, trailerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Access Farming Storage")) {
        new storageid = Farm:GetPlayerNearestStorageID(playerid, 20.0);
        if (storageid != -1) Farm:TruckingMenu(playerid, storageid, trailerid);
        return ~1;
    }
    return 1;
}

stock Farm:TruckingMenu(playerid, storageid, trailerid) {
    if (!Farm:FarmStorageData[storageid][Farm:TruckLoading] && !Farm:FarmStorageData[storageid][Farm:TruckUnloading]) {
        return AlexaMsg(playerid, "storage is locked by owner");
    }

    new string[512];
    if (Farm:FarmStorageData[storageid][Farm:TruckLoading]) {
        strcat(string, "Load Resource\n");
        strcat(string, "Load Seed\n");
    }
    if (Farm:FarmStorageData[storageid][Farm:TruckUnloading]) {
        strcat(string, "Unload Resource\n");
        strcat(string, "Unload Seed\n");
    }
    return FlexPlayerDialog(playerid, "FarmTruckingMenu", DIALOG_STYLE_LIST, "Farm Storage", string, "Select", "Cancel", storageid, sprintf("%d", trailerid));
}

FlexDialog:FarmTruckingMenu(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return 1;
    if (IsStringSame(inputtext, "Load Resource")) return Farm:TruckingMenuLoad(playerid, storageid, trailerid);
    if (IsStringSame(inputtext, "Load Seed")) return Farm:TruckingMenuLoadSeed(playerid, storageid, trailerid);
    if (IsStringSame(inputtext, "Unload Resource")) return Farm:TruckingMenuUnload(playerid, storageid, trailerid);
    if (IsStringSame(inputtext, "Unload Seed")) return Farm:TruckingMenuUnloadSeed(playerid, storageid, trailerid);
    return 1;
}

stock Farm:TruckingMenuLoad(playerid, storageid, trailerid) {
    new string[1024];
    strcat(string, "Crop\tIn Storage\n");
    for (new i; i < 8; i++) strcat(string, sprintf("%s\t%d/1000 KG\n", Farm:GetTypeName(i), Farm:GetCropResource(storageid, i)));
    return FlexPlayerDialog(
        playerid, "FarmTruckingMenuLoad", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Farm Storage]:{FFFFEE} Truck Loading", string,
        "Select", "Cancel", storageid, sprintf("%d", trailerid)
    );
}

FlexDialog:FarmTruckingMenuLoad(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new cropType = strval(inputtext);
    return Farm:MenuLoadInTruck(playerid, storageid, trailerid, cropType);
}

stock Farm:MenuLoadInTruck(playerid, storageid, trailerid, cropType) {
    return FlexPlayerDialog(
        playerid, "FarmMenuLoadInTruck", DIALOG_STYLE_INPUT, "Load from storage", "Enter amount of resource need to load in trailer",
        "Load", "Cancel", storageid, sprintf("%d %d", trailerid, cropType)
    );
}

FlexDialog:FarmMenuLoadInTruck(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid, cropType;
    sscanf(payload, "dd", trailerid, cropType);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || TrailerStorage:GetResourceByName(trailerid, Farm:GetTypeName(cropType)) + amount > 1000) return Farm:MenuLoadInTruck(playerid, storageid, trailerid, cropType);
    Farm:DeductResource(storageid, cropType, amount);
    TrailerStorage:IncreaseResourceByName(trailerid, Farm:GetTypeName(cropType), amount);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}loaded %dkg resource in trailer", amount));
    return Farm:TruckingMenu(playerid, storageid, trailerid);
}

stock Farm:TruckingMenuLoadSeed(playerid, storageid, trailerid) {
    new string[1024];
    strcat(string, "Crop\tIn Storage\n");
    for (new i; i < 8; i++) strcat(string, sprintf("%s\t%d/1000 KG\n", Farm:GetTypeName(i), Farm:GetCropResource(storageid, i)));
    return FlexPlayerDialog(
        playerid, "FarmTruckingMenuLoadSeed", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Farm Storage]:{FFFFEE} Truck Loading", string,
        "Select", "Cancel", storageid, sprintf("%d", trailerid)
    );
}

FlexDialog:FarmTruckingMenuLoadSeed(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new cropType = strval(inputtext);
    return Farm:MenuLoadInTruckSeed(playerid, storageid, trailerid, cropType);
}

stock Farm:MenuLoadInTruckSeed(playerid, storageid, trailerid, cropType) {
    return FlexPlayerDialog(
        playerid, "FarmMenuLoadInTruckSeed", DIALOG_STYLE_INPUT, "Load from storage", "Enter amount of seed need to load in trailer",
        "Load", "Cancel", storageid, sprintf("%d %d", trailerid, cropType)
    );
}

FlexDialog:FarmMenuLoadInTruckSeed(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid, cropType;
    sscanf(payload, "dd", trailerid, cropType);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || TrailerStorage:GetResourceByName(trailerid, sprintf("%s_Seed", Farm:GetTypeName(cropType))) + amount > 1000)
        return Farm:MenuLoadInTruckSeed(playerid, storageid, trailerid, cropType);
    Farm:DeductSeed(storageid, cropType, amount);
    TrailerStorage:IncreaseResourceByName(trailerid, sprintf("%s_Seed", Farm:GetTypeName(cropType)), amount);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}loaded %dkg resource seed in trailer", amount));
    return Farm:TruckingMenu(playerid, storageid, trailerid);
}

stock Farm:TruckingMenuUnload(playerid, storageid, trailerid) {
    new string[1024];
    strcat(string, "Crop\tIn Trailer\n");
    for (new i; i < 8; i++) strcat(string, sprintf("%s\t%d/1000 KG\n", Farm:GetTypeName(i), TrailerStorage:GetResourceByName(trailerid, Farm:GetTypeName(i))));
    return FlexPlayerDialog(
        playerid, "FarmTruckingMenuUnload", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Farm Storage]:{FFFFEE} Truck Loading", string,
        "Select", "Cancel", storageid, sprintf("%d", trailerid)
    );
}

FlexDialog:FarmTruckingMenuUnload(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new cropType = strval(inputtext);
    return Farm:MenuUnloadInTruck(playerid, storageid, trailerid, cropType);
}

stock Farm:MenuUnloadInTruck(playerid, storageid, trailerid, cropType) {
    return FlexPlayerDialog(
        playerid, "FarmMenuUnloadInTruck", DIALOG_STYLE_INPUT, "Load from storage", "Enter amount of resource need to unload from trailer",
        "Load", "Cancel", storageid, sprintf("%d %d", trailerid, cropType)
    );
}

FlexDialog:FarmMenuUnloadInTruck(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid, cropType;
    sscanf(payload, "dd", trailerid, cropType);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new amount;
    if (
        sscanf(inputtext, "d", amount) || amount < 1 || amount > TrailerStorage:GetResourceByName(trailerid, Farm:GetTypeName(cropType)) ||
        Farm:GetCropResource(storageid, cropType) + amount > 1000
    ) return Farm:MenuLoadInTruckSeed(playerid, storageid, trailerid, cropType);
    Farm:AddResource(storageid, cropType, amount);
    TrailerStorage:IncreaseResourceByName(trailerid, Farm:GetTypeName(cropType), -amount);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}unloaded %dkg resource from trailer", amount));
    return Farm:TruckingMenu(playerid, storageid, trailerid);
}

stock Farm:TruckingMenuUnloadSeed(playerid, storageid, trailerid) {
    new string[1024];
    strcat(string, "Crop\tIn Trailer\n");
    for (new i; i < 8; i++) strcat(string, sprintf("%s\t%d/1000 KG\n", Farm:GetTypeName(i), TrailerStorage:GetResourceByName(trailerid, sprintf("%s_Seed", Farm:GetTypeName(i)))));
    return FlexPlayerDialog(
        playerid, "FarmTruckingMenuUnloadSeed", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Farm Storage]:{FFFFEE} Truck Loading", string,
        "Select", "Cancel", storageid, sprintf("%d", trailerid)
    );
}

FlexDialog:FarmTruckingMenuUnloadSeed(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid = strval(payload);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new cropType = strval(inputtext);
    return Farm:MenuUnloadInTruckSeed(playerid, storageid, trailerid, cropType);
}

stock Farm:MenuUnloadInTruckSeed(playerid, storageid, trailerid, cropType) {
    return FlexPlayerDialog(
        playerid, "FarmMenuUnloadInTruckSeed", DIALOG_STYLE_INPUT, "Load from storage", "Enter amount of resource seed need to unload from trailer",
        "Load", "Cancel", storageid, sprintf("%d %d", trailerid, cropType)
    );
}

FlexDialog:FarmMenuUnloadInTruckSeed(playerid, response, listitem, const inputtext[], storageid, const payload[]) {
    new trailerid, cropType;
    sscanf(payload, "dd", trailerid, cropType);
    if (!response) return Farm:TruckingMenu(playerid, storageid, trailerid);
    new amount;
    if (
        sscanf(inputtext, "d", amount) || amount < 1 ||
        amount > TrailerStorage:GetResourceByName(trailerid, sprintf("%s_Seed", Farm:GetTypeName(cropType))) ||
        Farm:GetCropSeed(storageid, cropType) + amount > 1000
    ) return Farm:MenuLoadInTruckSeed(playerid, storageid, trailerid, cropType);
    Farm:AddSeed(storageid, cropType, amount);
    TrailerStorage:IncreaseResourceByName(trailerid, sprintf("%s_Seed", Farm:GetTypeName(cropType)), -amount);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}unloaded %dkg resource seed from trailer", amount));
    return Farm:TruckingMenu(playerid, storageid, trailerid);
}