#define     MAX_PLANTS      	(250)   // limit of drug plants
#define     MAX_DEALERS         (50)    // limit of drug dealers

#define     USE_DRUNKLEVEL              // remove this line if you don't want SetPlayerDrunkLevel to be used while on Drug:pDrugs
#define     PLAYER_LIMIT    	(5)     // a player can plant up to x drug plants (Default:5)
#define     PLANT_MAX_GROWTH	(10)    // a plant will grow up to x grams of Drug:pDrugs (Default:75)
#define     GROWTH_INTERVAL 	(45)    // a plant will grow up every x seconds (Default:45)
#define     ROT_INTERVAL        (300)   // a plant will rot after x seconds of fully growing (Default:300)
#define     DRUG_CARRY_LIMIT    (150)   // a player can carry up to x grams of Drug:pDrugs (Default:150)
#define     DEALER_CARRY_LIMIT  (300)   // a player can carry up to x grams of Drug:pDrugs (Default:150)
#define     SEED_LIMIT         	(25)   	// a player can carry up to x drug plant seeds (Default:25)
#define     SEED_PRICE      	(80)    // price players will pay for a drug plant seed (Default:50)
#define     DRUG_BUY_PRICE      (20)    // price players will pay a dealer for a gram of Drug:pDrugs (Default:20)
#define     DRUG_SELL_PRICE     (16)    // price dealers will pay a player for a gram of Drug:pDrugs (Default:16)

enum Drug:EnumPlant {
    Float:Drug:PlantX,
    Float:Drug:PlantY,
    Float:Drug:PlantZ,
    Drug:PlantedBy[MAX_PLAYER_NAME],
    Drug:PlantGrowth,
    Drug:PlantObject,
    Drug:PlantTimer,
    Text3D:Drug:PlantLabel,
    bool:Drug:PlantLeaves
}

enum Drug:EnumPlayer {
    // saved
    Drug:pDrugs,
    Drug:pSeeds,
    Drug:pTotalUsed,
    Drug:pTotalPlanted,
    Drug:pTotalHarvestedPlants,
    Drug:pTotalHarvestedGrams,
    Drug:pTotalGiven,
    Drug:pTotalReceived,
    Drug:pTotalBought,
    Drug:pTotalBoughtPrice,
    Drug:pTotalSold,
    Drug:pTotalSoldPrice,
    // temp
    Drug:PlayerDrugsCooldown
}

enum Drug:EnumDealer {
    // loaded from db
    Drug:dSkin,
    Drug:dDrugs,
    Float:Drug:dPosX,
    Float:Drug:dPosY,
    Float:Drug:dPosZ,
    Float:Drug:dPosA,
    Drug:dAnimLib[50],
    Drug:dAnimName[50],
    Drug:dAnimLoop,
    Drug:dInterior,
    Drug:dWorld,
    // temp
    Drug:dActorId,
    Text3D:Drug:dLabelId,
    Drug:dMapIcon
}

new Drug:PlantData[MAX_PLANTS][Drug:EnumPlant];
new Iterator:Plants < MAX_PLANTS > ;

new Drug:PlayerData[MAX_PLAYERS][Drug:EnumPlayer],
    Drug:RegenTimer[MAX_PLAYERS] = {-1, ... },
    Drug:EffectTimer[MAX_PLAYERS] = {-1, ... };

new Drug:DealerData[MAX_DEALERS][Drug:EnumDealer];
new Iterator:Dealers < MAX_DEALERS > ;

stock Drug:IsValidPlantId(plantId) return Iter_Contains(Plants, plantId);
stock Drug:IsValidDealerId(dealerId) return Iter_Contains(Dealers, dealerId);
stock Drug:GetDealerDrugs(dealerId) return Drug:DealerData[dealerId][Drug:dDrugs];
stock Drug:Get(playerid) return Drug:PlayerData[playerid][Drug:pDrugs];
stock Drug:Set(playerid, drugs) return Drug:PlayerData[playerid][Drug:pDrugs] = drugs;
stock Drug:Increase(playerid, drugs) return Drug:PlayerData[playerid][Drug:pDrugs] += drugs;
stock Drug:GetSeed(playerid) return Drug:PlayerData[playerid][Drug:pSeeds];
stock Drug:GetTotalUsed(playerid) return Drug:PlayerData[playerid][Drug:pTotalUsed];
stock Drug:GetTotalPlanted(playerid) return Drug:PlayerData[playerid][Drug:pTotalPlanted];
stock Drug:GetTotalHarvestedPlants(playerid) return Drug:PlayerData[playerid][Drug:pTotalHarvestedPlants];
stock Drug:GetTotalHarvestedGrams(playerid) return Drug:PlayerData[playerid][Drug:pTotalHarvestedGrams];
stock Drug:GetTotalGiven(playerid) return Drug:PlayerData[playerid][Drug:pTotalGiven];
stock Drug:GetTotalReceived(playerid) return Drug:PlayerData[playerid][Drug:pTotalReceived];
stock Drug:GetTotalBought(playerid) return Drug:PlayerData[playerid][Drug:pTotalBought];
stock Drug:GetTotalBoughtPrice(playerid) return Drug:PlayerData[playerid][Drug:pTotalBoughtPrice];
stock Drug:GetTotalSold(playerid) return Drug:PlayerData[playerid][Drug:pTotalSold];
stock Drug:GetTotalSoldPrice(playerid) return Drug:PlayerData[playerid][Drug:pTotalSoldPrice];

stock Drug:GetPlantGrowthPercentage(plantId) {
    if (!Drug:IsValidPlantId(plantId)) return 0;
    return (Drug:PlantData[plantId][Drug:PlantGrowth] * 100) / PLANT_MAX_GROWTH;
}

stock Drug:GetPlantOwnerId(plantId) {
    if (!Drug:IsValidPlantId(plantId)) return INVALID_PLAYER_ID;
    foreach(new i:Player) if (IsStringSame(Drug:PlantData[plantId][Drug:PlantedBy], GetPlayerNameEx(i), true)) return i;
    return INVALID_PLAYER_ID;
}

stock Drug:GetClosestPlant(playerid, Float:range = 1.5) {
    new plantId = -1, Float:dist = range, Float:tempdist;
    foreach(new i:Plants) {
        tempdist = GetPlayerDistanceFromPoint(playerid, Drug:PlantData[i][Drug:PlantX], Drug:PlantData[i][Drug:PlantY], Drug:PlantData[i][Drug:PlantZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            plantId = i;
        }
    }

    return plantId;
}

stock Drug:GetClosestDealer(playerid, Float:range = 2.0) {
    new dealerId = -1, Float:dist = range, Float:tempdist;
    foreach(new i:Dealers) {
        tempdist = GetPlayerDistanceFromPoint(playerid, Drug:DealerData[i][Drug:dPosX], Drug:DealerData[i][Drug:dPosY], Drug:DealerData[i][Drug:dPosZ]);

        if (tempdist > range) continue;
        if (tempdist <= dist) {
            dist = tempdist;
            dealerId = i;
        }
    }

    return dealerId;
}

stock Drug:GetPlayerPlantCount(playerid) {
    new count = 0, name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
    foreach(new i:Plants) if (IsStringSame(Drug:PlantData[i][Drug:PlantedBy], name, true)) count++;
    return count;
}

stock Drug:PlantDestroy(plantId) {
    if (!Drug:IsValidPlantId(plantId)) return 0;
    KillTimer(Drug:PlantData[plantId][Drug:PlantTimer]);
    DestroyDynamicObjectEx(Drug:PlantData[plantId][Drug:PlantObject]);
    DestroyDynamic3DTextLabel(Drug:PlantData[plantId][Drug:PlantLabel]);

    Drug:PlantData[plantId][Drug:PlantObject] = Drug:PlantData[plantId][Drug:PlantTimer] = -1;
    Drug:PlantData[plantId][Drug:PlantLabel] = Text3D:  - 1;
    Drug:PlantData[plantId][Drug:PlantLeaves] = false;

    Iter_Remove(Plants, plantId);
    return 1;
}

stock Drug:SavePlayer(playerid) {
    Database:UpdateJsonInt("playerdata", "drugData", "Drugs", Drug:PlayerData[playerid][Drug:pDrugs], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "Seeds", Drug:PlayerData[playerid][Drug:pSeeds], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalUsed", Drug:PlayerData[playerid][Drug:pTotalUsed], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalPlanted", Drug:PlayerData[playerid][Drug:pTotalPlanted], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalHarvestedPlants", Drug:PlayerData[playerid][Drug:pTotalHarvestedPlants], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalHarvestedGrams", Drug:PlayerData[playerid][Drug:pTotalHarvestedGrams], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalGiven", Drug:PlayerData[playerid][Drug:pTotalGiven], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalReceived", Drug:PlayerData[playerid][Drug:pTotalReceived], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalBought", Drug:PlayerData[playerid][Drug:pTotalBought], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalBoughtPrice", Drug:PlayerData[playerid][Drug:pTotalBoughtPrice], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalSold", Drug:PlayerData[playerid][Drug:pTotalSold], "username", GetPlayerNameEx(playerid));
    Database:UpdateJsonInt("playerdata", "drugData", "TotalSoldPrice", Drug:PlayerData[playerid][Drug:pTotalSoldPrice], "username", GetPlayerNameEx(playerid));
    return 1;
}

stock Drug:SaveDealer(dealerId) {
    mysql_tquery(Database, sprintf(
        "UPDATE `drugdealers` SET `Skin`=%d, `Drugs`=%d, `PosX`=%f, `PosY`=%f, `PosZ`=%f, `PosA`=%f WHERE ID=%d",
        Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dDrugs], Drug:DealerData[dealerId][Drug:dPosX],
        Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ], Drug:DealerData[dealerId][Drug:dPosA],
        dealerId
    ));
    return 1;
}

stock Drug:RemoveDealer(dealerId) {
    new query[512];
    mysql_format(Database, query, sizeof(query), "DELETE FROM `drugdealers` WHERE ID=%d", dealerId);
    mysql_tquery(Database, query);
    return 1;
}

forward LoadDealers();
public LoadDealers() {
    new rows = cache_num_rows();
    if (rows) {
        new dealerId, loaded;
        new label[128];
        while (loaded < rows) {
            cache_get_value_name_int(loaded, "ID", dealerId);
            cache_get_value_name_int(loaded, "Skin", Drug:DealerData[dealerId][Drug:dSkin]);
            cache_get_value_name_int(loaded, "Drugs", Drug:DealerData[dealerId][Drug:dDrugs]);
            cache_get_value_name_float(loaded, "PosX", Drug:DealerData[dealerId][Drug:dPosX]);
            cache_get_value_name_float(loaded, "PosY", Drug:DealerData[dealerId][Drug:dPosY]);
            cache_get_value_name_float(loaded, "PosZ", Drug:DealerData[dealerId][Drug:dPosZ]);
            cache_get_value_name_float(loaded, "PosA", Drug:DealerData[dealerId][Drug:dPosA]);
            cache_get_value_name(loaded, "Anim_Lib", Drug:DealerData[dealerId][Drug:dAnimLib], .max_len = 50);
            cache_get_value_name(loaded, "Anim_Name", Drug:DealerData[dealerId][Drug:dAnimName], .max_len = 50);
            cache_get_value_name_int(loaded, "Anim_Loop", Drug:DealerData[dealerId][Drug:dAnimLoop]);
            cache_get_value_name_int(loaded, "Interior", Drug:DealerData[dealerId][Drug:dInterior]);
            cache_get_value_name_int(loaded, "VirtualW", Drug:DealerData[dealerId][Drug:dWorld]);

            Drug:DealerData[dealerId][Drug:dActorId] = CreateDynamicActor(Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ], Drug:DealerData[dealerId][Drug:dPosA], true, 100.0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1);
            ApplyDynamicActorAnimation(Drug:DealerData[dealerId][Drug:dActorId], Drug:DealerData[dealerId][Drug:dAnimLib], Drug:DealerData[dealerId][Drug:dAnimName], 4.1, Drug:DealerData[dealerId][Drug:dAnimLoop], 0, 0, 1, 0);

            format(label, sizeof(label), "Drug Dealer (%d)\n\n{FFFFFF}press {F1C40F}N {FFFFFF}to open dealer menu.", dealerId);
            Drug:DealerData[dealerId][Drug:dLabelId] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ] + 0.25, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1);
            Drug:DealerData[dealerId][Drug:dMapIcon] = CreateDynamicMapIcon(Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ], 46, -1, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1, 300);
            Iter_Add(Dealers, dealerId);
            loaded++;
        }

        printf("  [Drug System] Loaded %d Drug Dealers.", loaded);
    }
    return 1;
}

forward PlantGrowth(plantId);
public PlantGrowth(plantId) {
    new label_string[128];
    Drug:PlantData[plantId][Drug:PlantGrowth] += RandomEx(3, 7);

    if (Drug:PlantData[plantId][Drug:PlantGrowth] >= PLANT_MAX_GROWTH) {
        Drug:PlantData[plantId][Drug:PlantGrowth] = PLANT_MAX_GROWTH;
        KillTimer(Drug:PlantData[plantId][Drug:PlantTimer]);
        Drug:PlantData[plantId][Drug:PlantTimer] = SetTimerEx("PlantRot", ROT_INTERVAL * 1000, false, "i", plantId);

        new percentage = Drug:GetPlantGrowthPercentage(plantId);
        format(label_string, sizeof(label_string), "Rotting Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth:{%06x}%d%%\n\n{FFFFFF}press N to harvest", plantId, Drug:PlantData[plantId][Drug:PlantedBy], (percentage < 25) ? -1 >>> 8 : 0x2ECC71FF >>> 8, percentage);
        UpdateDynamic3DTextLabelText(Drug:PlantData[plantId][Drug:PlantLabel], 0xF1C40FFF, label_string);

        SetDynamicObjectMaterial(Drug:PlantData[plantId][Drug:PlantObject], 2, 2, "plants_TABLETOP", "CJ_PLANT", 0xFFD35400);

        new owner_id = Drug:GetPlantOwnerId(plantId);
        if (IsPlayerConnected(owner_id)) SendClientMessageEx(owner_id, 0x3498DBFF, "DRUG PLANT:{FFFFFF}One of your drug plants growed, harvest it before it rots!");
    } else {
        new percentage = Drug:GetPlantGrowthPercentage(plantId);
        if (!Drug:PlantData[plantId][Drug:PlantLeaves] && percentage >= 25) {
            SetDynamicObjectMaterial(Drug:PlantData[plantId][Drug:PlantObject], 2, 2, "plants_TABLETOP", "CJ_PLANT", 0xFF2ECC71);
            Drug:PlantData[plantId][Drug:PlantLeaves] = true;
        }

        format(label_string, sizeof(label_string), "Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth:{%06x}%d%%\n\n{FFFFFF}press N to harvest", plantId, Drug:PlantData[plantId][Drug:PlantedBy], (percentage < 25) ? -1 >>> 8 : 0x2ECC71FF >>> 8, percentage);
        UpdateDynamic3DTextLabelText(Drug:PlantData[plantId][Drug:PlantLabel], 0xF1C40FFF, label_string);
    }

    return 1;
}

forward PlantRot(plantId);
public PlantRot(plantId) {
    new owner_id = Drug:GetPlantOwnerId(plantId);
    if (IsPlayerConnected(owner_id)) SendClientMessageEx(owner_id, 0x3498DBFF, "DRUG PLANT:{FFFFFF}One of your drug plants rotted!");
    Drug:PlantDestroy(plantId);
    return 1;
}

forward RegenHealth(playerid, amount);
public RegenHealth(playerid, amount) {
    amount--;

    new Float:health;
    GetPlayerHealth(playerid, health);

    if (health + 2.5 < 95.0) SetPlayerHealthEx(playerid, health + 2.5);
    if (amount > 0) {
        #if defined USE_DRUNKLEVEL
        SetPlayerDrunkLevel(playerid, 4999);
        #endif

        Drug:RegenTimer[playerid] = SetTimerEx("RegenHealth", 500, false, "ii", playerid, amount);
    } else {
        #if defined USE_DRUNKLEVEL
        SetPlayerDrunkLevel(playerid, 0);
        #endif

        if (Drug:RegenTimer[playerid] != -1) {
            KillTimer(Drug:RegenTimer[playerid]);
            Drug:RegenTimer[playerid] = -1;
        }
    }

    return 1;
}

forward RemoveEffects(playerid);
public RemoveEffects(playerid) {
    #if defined USE_DRUNKLEVEL
    SetPlayerDrunkLevel(playerid, 0);
    #endif

    SetPlayerWeather(playerid, 10);

    if (Drug:EffectTimer[playerid] != -1) {
        KillTimer(Drug:EffectTimer[playerid]);
        Drug:EffectTimer[playerid] = -1;
    }

    return 1;
}

hook OnGameModeInit() {
    for (new i; i < MAX_PLANTS; i++) {
        Drug:PlantData[i][Drug:PlantObject] = Drug:PlantData[i][Drug:PlantTimer] = -1;
        Drug:PlantData[i][Drug:PlantLabel] = Text3D:  - 1;
    }

    for (new i; i < MAX_DEALERS; i++) {
        Drug:DealerData[i][Drug:dActorId] = -1;
        Drug:DealerData[i][Drug:dLabelId] = Text3D:  - 1;
        Drug:DealerData[i][Drug:dMapIcon] = -1;
    }

    Database:AddColumn("playerdata", "drugData", "json", "{}");
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `drugdealers` (\
		`ID` int(11) NOT NULL,\
	 	`Skin` int(11) NOT NULL,\
	  	`Drugs` int(11) NOT NULL,\
	  	`PosX` FLOAT NOT NULL,\
	  	`PosY` FLOAT NOT NULL,\
	  	`PosZ` FLOAT NOT NULL,\
	  	`PosA` FLOAT NOT NULL,\
		`Anim_Lib` VARCHAR(50) NULL DEFAULT 'PED',\
		`Anim_Name` VARCHAR(50) NULL DEFAULT 'STAND',\
		`Anim_Loop` tinyint(1) NULL DEFAULT '0',\
	 	`Interior` int(11) NOT NULL,\
	 	`VirtualW` int(11) NOT NULL,\
	  	PRIMARY KEY (`ID`)\
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;", "", "");

    ///load dealers
    mysql_tquery(Database, "SELECT * FROM drugdealers", "LoadDealers", "");
    return 1;
}

hook OnGameModeExit() {
    foreach(new i:Dealers) DestroyDynamicActor(Drug:DealerData[i][Drug:dActorId]);
    foreach(new i:Player) Drug:SavePlayer(i);
    return 1;
}

hook OnPlayerLogin(playerid) {
    Drug:PlayerData[playerid][Drug:pDrugs] = Database:GetJsonInt("drugData", "Drugs", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pSeeds] = Database:GetJsonInt("drugData", "Seeds", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalUsed] = Database:GetJsonInt("drugData", "TotalUsed", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalPlanted] = Database:GetJsonInt("drugData", "TotalPlanted", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalHarvestedPlants] = Database:GetJsonInt("drugData", "TotalHarvestedPlants", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalHarvestedGrams] = Database:GetJsonInt("drugData", "TotalHarvestedGrams", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalGiven] = Database:GetJsonInt("drugData", "TotalGiven", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalReceived] = Database:GetJsonInt("drugData", "TotalReceived", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalBought] = Database:GetJsonInt("drugData", "TotalBought", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalBoughtPrice] = Database:GetJsonInt("drugData", "TotalBoughtPrice", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalSold] = Database:GetJsonInt("drugData", "TotalSold", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    Drug:PlayerData[playerid][Drug:pTotalSoldPrice] = Database:GetJsonInt("drugData", "TotalSoldPrice", 0, "playerdata", "username", GetPlayerNameEx(playerid));
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    if (Drug:RegenTimer[playerid] != -1) KillTimer(Drug:RegenTimer[playerid]), Drug:RegenTimer[playerid] = -1;
    RemoveEffects(playerid);
    Drug:SavePlayer(playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    Drug:PlayerData[playerid][Drug:PlayerDrugsCooldown] = 0;
    if (Drug:RegenTimer[playerid] != -1) KillTimer(Drug:RegenTimer[playerid]), Drug:RegenTimer[playerid] = -1;
    if (Drug:EffectTimer[playerid] != -1) KillTimer(Drug:EffectTimer[playerid]), Drug:EffectTimer[playerid] = -1;
    Drug:SavePlayer(playerid);
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys != KEY_NO || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
    new plantId = Drug:GetClosestPlant(playerid);
    if (plantId != -1) {
        return Drug:PlantHarvest(playerid, plantId);
    }

    new dealerId = Drug:GetClosestDealer(playerid);
    if (dealerId != -1) {
        return Drug:DealerMenu(playerid, dealerId);
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Drugs");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Drugs", inputtext)) {
        Drug:Menu(playerid);
        return ~1;
    }
    return 1;
}

stock Drug:Menu(playerid) {
    new string[1024];
    strcat(string, sprintf("Drugs\t%s grams\n", FormatCurrencyEx(Drug:Get(playerid), ',', '\0')));
    strcat(string, sprintf("Seeds\t%s\n", FormatCurrencyEx(Drug:GetSeed(playerid), ',', '\0')));
    strcat(string, sprintf("Used Drugs\t%s grams\n", FormatCurrencyEx(Drug:GetTotalUsed(playerid), ',', '\0')));
    strcat(string, sprintf("Planted Drugs\t%s\n", FormatCurrencyEx(Drug:GetTotalPlanted(playerid), ',', '\0')));
    strcat(string, sprintf(
        "Harvested Plants\t%s  (%s grams)\n",
        FormatCurrencyEx(Drug:GetTotalHarvestedPlants(playerid), ',', '\0'),
        FormatCurrencyEx(Drug:GetTotalHarvestedGrams(playerid), ',', '\0')
    ));
    strcat(string, sprintf("Drugs Given\t%s grams\n", FormatCurrencyEx(Drug:GetTotalGiven(playerid), ',', '\0')));
    strcat(string, sprintf("Drugs Received\t%s grams\n", FormatCurrencyEx(Drug:GetTotalReceived(playerid), ',', '\0')));
    strcat(string, sprintf(
        "Drugs Bought\t%s grams {2ECC71}(%s)\n",
        FormatCurrencyEx(Drug:GetTotalBought(playerid), ',', '\0'),
        FormatCurrencyEx(Drug:GetTotalBought(playerid))
    ));
    strcat(string, sprintf(
        "Drugs Sold\t%s grams {2ECC71}(%s)\n",
        FormatCurrencyEx(Drug:GetTotalSold(playerid), ',', '\0'),
        FormatCurrencyEx(Drug:GetTotalSoldPrice(playerid))
    ));

    return FlexPlayerDialog(playerid, "DrugStatusMenu", DIALOG_STYLE_TABLIST, "Drug Status", string, "Okay", "");
}

FlexDialog:DrugStatusMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Drugs")) return Drug:MenuUse(playerid);
    if (IsStringSame(inputtext, "Seeds")) return Drug:PlantSeed(playerid);
    return Drug:Menu(playerid);
}

stock Drug:PlantHarvest(playerid, plantId) {
    if (!Drug:IsValidPlantId(plantId)) return 0;
    if (Drug:Get(playerid) >= DRUG_CARRY_LIMIT) return AlexaMsg(playerid, "You can't carry any more drugs");
    if (!Drug:PlantData[plantId][Drug:PlantLeaves]) return AlexaMsg(playerid, "You can't harvest this plant because it's not ready");
    new harvested = Drug:PlantData[plantId][Drug:PlantGrowth];
    if (Drug:Get(playerid) + harvested > DRUG_CARRY_LIMIT) harvested = DRUG_CARRY_LIMIT - Drug:Get(playerid);

    AlexaMsg(playerid, sprintf("You harvested a drug plant and got %d grams of drugs", harvested));

    Drug:PlayerData[playerid][Drug:pDrugs] += harvested;
    Drug:PlayerData[playerid][Drug:pTotalHarvestedPlants]++;
    Drug:PlayerData[playerid][Drug:pTotalHarvestedGrams] += harvested;

    new ownerId = Drug:GetPlantOwnerId(plantId);
    if (ownerId != playerid && IsPlayerConnected(ownerId)) AlexaMsg(ownerId, FormatColors("~r~Somebody harvested one of your drug plants"));

    Drug:PlantDestroy(plantId);
    return 1;
}

stock Drug:PlantSeed(playerid) {
    if (Drug:GetSeed(playerid) < 1) return AlexaMsg(playerid, "I don't think you have any drug seed");
    if (Drug:GetPlayerPlantCount(playerid) >= PLAYER_LIMIT) return AlexaMsg(playerid, "You can't plant any more drug plants");
    if (Drug:GetClosestPlant(playerid) != -1) return AlexaMsg(playerid, "You can't place a drug plant here because there is one nearby");
    new plantId = Iter_Free(Plants);
    if (plantId == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "Server drug plant limit reached");

    GetPlayerName(playerid, Drug:PlantData[plantId][Drug:PlantedBy], MAX_PLAYER_NAME);
    GetPlayerPos(playerid, Drug:PlantData[plantId][Drug:PlantX], Drug:PlantData[plantId][Drug:PlantY], Drug:PlantData[plantId][Drug:PlantZ]);

    Drug:PlantData[plantId][Drug:PlantGrowth] = 0;
    Drug:PlantData[plantId][Drug:PlantObject] = CreateDynamicObject(2244, Drug:PlantData[plantId][Drug:PlantX], Drug:PlantData[plantId][Drug:PlantY], Drug:PlantData[plantId][Drug:PlantZ] - 0.70, 0.0, 0.0, 0.0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid));
    SetDynamicObjectMaterial(Drug:PlantData[plantId][Drug:PlantObject], 2, 19478, "signsurf", "sign", 0xFFFFFFFF);

    Drug:PlantData[plantId][Drug:PlantLabel] = CreateDynamic3DTextLabel(sprintf(
            "Drug Plant (%d)\n\n{FFFFFF}Placed by %s\nGrowth: {4286f4}0%%\n\n{FFFFFF}press N to harvest", plantId, Drug:PlantData[plantId][Drug:PlantedBy]
        ),
        0xF1C40FFF, Drug:PlantData[plantId][Drug:PlantX], Drug:PlantData[plantId][Drug:PlantY], Drug:PlantData[plantId][Drug:PlantZ], 5.0, INVALID_PLAYER_ID,
        INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorldID(playerid), GetPlayerInteriorID(playerid)
    );

    Drug:PlantData[plantId][Drug:PlantTimer] = SetTimerEx("PlantGrowth", GROWTH_INTERVAL * 1000, true, "i", plantId);
    Iter_Add(Plants, plantId);

    Drug:PlayerData[playerid][Drug:pSeeds]--;
    Drug:PlayerData[playerid][Drug:pTotalPlanted]++;
    return 1;
}

stock Drug:MenuUse(playerid) {
    if (Drug:PlayerData[playerid][Drug:PlayerDrugsCooldown] > gettime()) {
        new time[100];
        UnixToHuman(Drug:PlayerData[playerid][Drug:PlayerDrugsCooldown], time);
        AlexaMsg(playerid, sprintf("Drug cooldown, try after %s", time));
        return Drug:Menu(playerid);
    }
    return FlexPlayerDialog(playerid, "DrugMenuUse", DIALOG_STYLE_INPUT, "Use Drug",
        sprintf("Enter drug amount between 1 to %d", Drug:Get(playerid) > 10 ? 10 : Drug:Get(playerid)),
        "Consume", "Cancel"
    );
}

FlexDialog:DrugMenuUse(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Drug:Menu(playerid);
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > 10 || amount > Drug:Get(playerid)) return Drug:MenuUse(playerid);
    Drug:PlayerData[playerid][Drug:PlayerDrugsCooldown] = gettime() + (10 * amount);
    Drug:PlayerData[playerid][Drug:pDrugs] -= amount;
    Drug:PlayerData[playerid][Drug:pTotalUsed] += amount;

    SetPlayerWeather(playerid, 234);
    Drug:RegenTimer[playerid] = SetTimerEx("RegenHealth", 500, false, "ii", playerid, (2 * amount));
    Drug:EffectTimer[playerid] = SetTimerEx("RemoveEffects", (6 * amount) * 1000, false, "i", playerid);

    AlexaMsg(playerid, sprintf("used %d grams of drugs, Drugs are harmful to human health!", amount));
    return 1;
}

hook QuickActionsOnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (Drug:Get(playerid) > 0) QuickActions:AddCommand(playerid, "Give Drugs");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Give Drugs", inputtext)) {
        Drug:MenuGive(playerid, targetid);
        return ~1;
    }
    return 1;
}

stock Drug:MenuGive(playerid, toplayerid) {
    return FlexPlayerDialog(playerid, "DrugMenuGive", DIALOG_STYLE_INPUT, "Give drugs",
        sprintf("Enter amount of drugs to give\nLimit: 1 to %d", Drug:Get(playerid)),
        "Give", "Close", toplayerid
    );
}

FlexDialog:DrugMenuGive(playerid, response, listitem, const inputtext[], toplayerid, const payload[]) {
    if (!response || !IsPlayerConnected(toplayerid)) return 1;
    if (DistanceBetweenPlayers(playerid, toplayerid) > 5.0) return AlexaMsg(playerid, "You must be near to the player you want to give drugs");
    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > Drug:Get(playerid)) return Drug:MenuGive(playerid, toplayerid);
    if (Drug:Get(toplayerid) + amount > DRUG_CARRY_LIMIT) amount = DRUG_CARRY_LIMIT - Drug:Get(toplayerid);

    Drug:PlayerData[playerid][Drug:pDrugs] -= amount;
    Drug:PlayerData[toplayerid][Drug:pDrugs] += amount;

    Drug:PlayerData[playerid][Drug:pTotalGiven] += amount;
    Drug:PlayerData[toplayerid][Drug:pTotalReceived] += amount;

    AlexaMsg(toplayerid, sprintf("%s (%d) gave you %d grams of drugs", GetPlayerNameEx(playerid), playerid, amount));
    AlexaMsg(playerid, sprintf("%d grams of drugs given to %s (%d)", amount, GetPlayerNameEx(toplayerid), toplayerid));
    return 1;
}

stock Drug:DealerMenu(playerid, dealerId) {
    new string[1024];
    strcat(string, "Option\tPrice\tYou Have\n");
    strcat(string, sprintf("{%06x}Buy Drug Plant Seed\t{2ECC71}%s\t%s\n", (Drug:GetSeed(playerid) < SEED_LIMIT) ? (0xFFFFFFFF >>> 8) : (-1 >>> 8), FormatCurrencyEx(SEED_PRICE), FormatCurrencyEx(Drug:GetSeed(playerid), .iThousandSeparator = ',', .iCurrencyChar = '\0')));
    strcat(string, sprintf("{%06x}Buy Drugs (%s grams on dealer)\t{2ECC71}%s x gram\t%s grams\n", (Drug:Get(playerid) >= DRUG_CARRY_LIMIT || Drug:GetDealerDrugs(dealerId) < 1) ? ((-1) >>> 8) : (0xFFFFFFFF >>> 8), FormatCurrencyEx(Drug:GetDealerDrugs(dealerId)), FormatCurrencyEx(DRUG_BUY_PRICE), FormatCurrencyEx(Drug:Get(playerid), .iThousandSeparator = ',', .iCurrencyChar = '\0')));
    strcat(string, sprintf("{%06x}Sell Drugs\t{2ECC71}%s x gram\t%s grams\n", (Drug:Get(playerid) > 0) ? (0xFFFFFFFF >>> 8) : (-1) >>> (8), FormatCurrencyEx(DRUG_SELL_PRICE), FormatCurrencyEx(Drug:Get(playerid), .iThousandSeparator = ',', .iCurrencyChar = '\0')));
    return FlexPlayerDialog(playerid, "DrugDealermenu", DIALOG_STYLE_TABLIST_HEADERS, "Drug Dealer", string, "Select", "Close", dealerId);
}

FlexDialog:DrugDealermenu(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return 1;
    if (listitem == 0) return Drug:DealerMenuBuySeed(playerid, dealerId);
    if (listitem == 1) return Drug:DealerMenuBuyDrug(playerid, dealerId);
    if (listitem == 2) return Drug:DealerMenuSellDrug(playerid, dealerId);
    return 1;
}

stock Drug:DealerMenuBuySeed(playerid, dealerId) {
    new allowedFaction[] = { 5, 7, 8, 9, 10 };
    if (!IsArrayContainNumber(allowedFaction, Faction:GetPlayerFID(playerid))) {
        AlexaMsg(playerid, "You can't buy plant seeds, only mafia can.");
        return Drug:DealerMenu(playerid, dealerId);
    }
    if (!Faction:IsPlayerSigned(playerid)) {
        AlexaMsg(playerid, "Sign in faction to buy plant seeds.");
        return Drug:DealerMenu(playerid, dealerId);
    }
    if (Drug:Get(playerid) >= SEED_LIMIT) {
        AlexaMsg(playerid, "You can't buy any more seeds.");
        return Drug:DealerMenu(playerid, dealerId);
    }

    new buyLimit = SEED_LIMIT - Drug:GetSeed(playerid);
    return FlexPlayerDialog(playerid, "DealerMenuBuySeed", DIALOG_STYLE_INPUT, "Buy Seed", sprintf(
        "Enter the amount of seeds you wish to purchase\nLimit 1 to %d", buyLimit
    ), "Buy", "Close", dealerId);
}

FlexDialog:DealerMenuBuySeed(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:DealerMenu(playerid, dealerId);

    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > SEED_LIMIT - Drug:GetSeed(playerid)) {
        return Drug:DealerMenuBuySeed(playerid, dealerId);
    }

    new price = amount * SEED_PRICE;
    if (GetPlayerCash(playerid) < price) {
        AlexaMsg(playerid, "You can't afford it");
        return Drug:DealerMenuBuySeed(playerid, dealerId);
    }

    Drug:PlayerData[playerid][Drug:pSeeds] += amount;
    GivePlayerCash(playerid, -price, sprintf("[Drug System]: Bought %s seeds for %s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)));
    vault:addcash(Vault_ID_Government, price, Vault_Transaction_Cash_To_Vault, sprintf("%s bought %d drug seeds", GetPlayerNameEx(playerid), amount));

    AlexaMsg(playerid, sprintf("{4286f4}[Drug System]: {FFFFEE}Bought %s seeds for {2ECC71}%s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)));
    return Drug:DealerMenu(playerid, dealerId);
}

stock Drug:DealerMenuBuyDrug(playerid, dealerId) {
    if (Drug:Get(playerid) >= DRUG_CARRY_LIMIT) {
        AlexaMsg(playerid, "You can't buy any more drugs");
        return Drug:DealerMenu(playerid, dealerId);
    }

    if (Drug:GetDealerDrugs(dealerId) < 1) {
        AlexaMsg(playerid, "This dealer has no drugs");
        return Drug:DealerMenu(playerid, dealerId);
    }

    new buyLimit = Drug:GetDealerDrugs(dealerId);
    if (buyLimit > DRUG_CARRY_LIMIT - Drug:Get(playerid)) buyLimit = DRUG_CARRY_LIMIT - Drug:Get(playerid);
    return FlexPlayerDialog(playerid, "DealerMenuBuyDrug", DIALOG_STYLE_INPUT, "Buy Drugs", sprintf(
        "Enter amount of drugs you wish to buy\nLimit: 1 to %d", buyLimit
    ), "Buy", "Close", dealerId);
}

FlexDialog:DealerMenuBuyDrug(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:DealerMenu(playerid, dealerId);

    new buyLimit = Drug:GetDealerDrugs(dealerId);
    if (buyLimit > DRUG_CARRY_LIMIT - Drug:Get(playerid)) buyLimit = DRUG_CARRY_LIMIT - Drug:Get(playerid);

    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > buyLimit) return Drug:DealerMenuBuyDrug(playerid, dealerId);
    new price = amount * DRUG_BUY_PRICE;
    if (price > GetPlayerCash(playerid)) {
        AlexaMsg(playerid, "You can't afford it");
        return Drug:DealerMenuBuyDrug(playerid, dealerId);
    }

    Drug:DealerData[dealerId][Drug:dDrugs] -= amount;
    Drug:PlayerData[playerid][Drug:pDrugs] += amount;
    Drug:PlayerData[playerid][Drug:pTotalBought] += amount;
    Drug:PlayerData[playerid][Drug:pTotalBoughtPrice] += price;
    GivePlayerCash(playerid, -price, sprintf(
        "[Drug System]: Bought %s grams of drugs for {2ECC71}%s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)
    ));
    vault:addcash(Vault_ID_Government, price, Vault_Transaction_Cash_To_Vault, sprintf("%s bought %d gram drugs", GetPlayerNameEx(playerid), amount));

    AlexaMsg(playerid, sprintf(
        "{4286f4}[Drug System]: {FFFFEE}Bought %s grams of drugs for {2ECC71}%s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)
    ));

    Drug:SaveDealer(dealerId);
    return Drug:DealerMenu(playerid, dealerId);
}

stock Drug:DealerMenuSellDrug(playerid, dealerId) {
    if (Drug:Get(playerid) < 1) {
        AlexaMsg(playerid, "You don't have enough drugs for sale");
        return Drug:DealerMenu(playerid, dealerId);
    }

    if (Drug:GetDealerDrugs(dealerId) >= DEALER_CARRY_LIMIT) {
        AlexaMsg(playerid, "The dealer can't buy any more drugs");
        return Drug:DealerMenu(playerid, dealerId);
    }

    new sellLimit = Drug:Get(playerid);
    if (sellLimit > (DEALER_CARRY_LIMIT - Drug:GetDealerDrugs(dealerId))) sellLimit = DEALER_CARRY_LIMIT - Drug:GetDealerDrugs(dealerId);

    return FlexPlayerDialog(playerid, "DealerMenuSellDrug", DIALOG_STYLE_INPUT, "Sell Drugs",
        sprintf("Enter amount of drugs you wish to sell\nLimit 1 to %d", sellLimit),
        "Sell", "Cancel", dealerId
    );
}

FlexDialog:DealerMenuSellDrug(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:DealerMenu(playerid, dealerId);

    new sellLimit = Drug:Get(playerid);
    if (sellLimit > DEALER_CARRY_LIMIT - Drug:GetDealerDrugs(dealerId)) sellLimit = DEALER_CARRY_LIMIT - Drug:GetDealerDrugs(dealerId);

    new amount;
    if (sscanf(inputtext, "d", amount) || amount < 1 || amount > sellLimit) return Drug:DealerMenuSellDrug(playerid, dealerId);

    new price = amount * DRUG_SELL_PRICE;
    Drug:DealerData[dealerId][Drug:dDrugs] += amount;
    Drug:PlayerData[playerid][Drug:pDrugs] -= amount;
    Drug:PlayerData[playerid][Drug:pTotalSold] += amount;
    Drug:PlayerData[playerid][Drug:pTotalSoldPrice] += price;
    GivePlayerCash(playerid, price, sprintf("[Drug System]: Sold %s grams of drugs for %s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)));
    vault:addcash(Vault_ID_Government, -price, Vault_Transaction_Cash_To_Vault, sprintf("%s sold %d gram drugs", GetPlayerNameEx(playerid), amount));

    AlexaMsg(playerid, sprintf("{4286f4}[Drug System]: {FFFFEE}Sold %s grams of drugs for {2ECC71}%s.", FormatCurrencyEx(amount, .iCurrencyChar = '\0'), FormatCurrencyEx(price)));

    Drug:SaveDealer(dealerId);
    return Drug:DealerMenu(playerid, dealerId);
}

ASCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    ASCP:AddCommand(playerid, "Drug System");
    return 1;
}

ASCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Drug System", inputtext)) {
        Drug:AdminMenu(playerid);
        return ~1;
    }
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (!IsStringContainWords(text, "drug system") || !IsPlayerMasterAdmin(playerid)) return 1;
    Drug:AdminMenu(playerid);
    return ~1;
}

stock Drug:AdminMenu(playerid) {
    new string[512];
    strcat(string, "Manage Dealer\n");
    strcat(string, "Create Dealer\n");
    return FlexPlayerDialog(playerid, "DrugAdminMenu", DIALOG_STYLE_LIST, "Drug System", string, "Selelct", "Close");
}

FlexDialog:DrugAdminMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Create Dealer")) return Drug:AdminMenuCreate(playerid);
    if (IsStringSame(inputtext, "Manage Dealer")) return Drug:AdminMenuManageInput(playerid);
    return 1;
}

stock Drug:AdminMenuCreate(playerid) {
    return FlexPlayerDialog(playerid, "DrugAdminMenuCreate", DIALOG_STYLE_INPUT, "Create Dealer", "Enter skinid for dealer\nLimit: 0 to 311", "Create", "Cancel");
}

FlexDialog:DrugAdminMenuCreate(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Drug:AdminMenu(playerid);
    new skinId;
    if (sscanf(inputtext, "d", skinId) || skinId < 0 || skinId > 311) return Drug:AdminMenuCreate(playerid);
    new dealerId = Iter_Free(Dealers);
    if (dealerId == INVALID_ITERATOR_SLOT) return AlexaMsg(playerid, "Server dealers limit reached");
    Iter_Add(Dealers, dealerId);

    GetPlayerPos(playerid, Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ]);
    GetPlayerFacingAngle(playerid, Drug:DealerData[dealerId][Drug:dPosA]);

    Drug:DealerData[dealerId][Drug:dDrugs] = 0;
    Drug:DealerData[dealerId][Drug:dSkin] = skinId;
    Drug:DealerData[dealerId][Drug:dInterior] = GetPlayerInterior(playerid);
    Drug:DealerData[dealerId][Drug:dWorld] = GetPlayerVirtualWorld(playerid);
    Drug:DealerData[dealerId][Drug:dActorId] = CreateDynamicActor(
        Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ],
        Drug:DealerData[dealerId][Drug:dPosA], true, 100.0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1
    );

    Drug:DealerData[dealerId][Drug:dLabelId] = CreateDynamic3DTextLabel(
        sprintf("Drug Dealer (%d)\n\n{FFFFFF}press {F1C40F}N {FFFFFF}to open dealer menu.", dealerId),
        0xF1C40FFF, Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ] + 0.25,
        5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1
    );

    Drug:DealerData[dealerId][Drug:dMapIcon] = CreateDynamicMapIcon(
        Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ],
        46, -1, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1, 300
    );

    mysql_tquery(Database, sprintf(
        "INSERT INTO drugdealers SET `ID`=%d, `Skin`=%d, `Drugs`=%d, `PosX`=%f, `PosY`=%f, `PosZ`=%f, `PosA`=%f, `Interior`=%d, `VirtualW`=%d",
        dealerId, Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dDrugs], Drug:DealerData[dealerId][Drug:dPosX],
        Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ], Drug:DealerData[dealerId][Drug:dPosA],
        Drug:DealerData[dealerId][Drug:dInterior], Drug:DealerData[dealerId][Drug:dWorld]
    ));

    AlexaMsg(playerid, sprintf("dealer %d created", dealerId));
    SetPlayerPosEx(
        playerid, Drug:DealerData[dealerId][Drug:dPosX] + (1.5 * floatsin(-Drug:DealerData[dealerId][Drug:dPosA], degrees)),
        Drug:DealerData[dealerId][Drug:dPosY] + (1.5 * floatcos(-Drug:DealerData[dealerId][Drug:dPosA], degrees)), Drug:DealerData[dealerId][Drug:dPosZ]
    );
    return Drug:ManageDealer(playerid, dealerId);
}

stock Drug:AdminMenuManageInput(playerid) {
    return FlexPlayerDialog(
        playerid, "DrugAdminMenuManageInput", DIALOG_STYLE_INPUT, "Manage Drug Dealer", "Enter drug dealer id", "Select", "Close"
    );
}

FlexDialog:DrugAdminMenuManageInput(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Drug:AdminMenu(playerid);
    new dealerId;
    if (sscanf(inputtext, "d", dealerId) || !Drug:IsValidDealerId(dealerId)) return Drug:AdminMenuManageInput(playerid);
    return Drug:ManageDealer(playerid, dealerId);
}

stock Drug:ManageDealer(playerid, dealerId) {
    new string[1024];
    strcat(string, "#\tData\n");
    strcat(string, sprintf("Drugs\t%d\n", Drug:GetDealerDrugs(dealerId)));
    strcat(string, "Teleport to Dealer\n");
    strcat(string, "Set Dealer Position\n");
    strcat(string, "Set Dealer Skin\n");
    strcat(string, "Set Dealer Animation\n");
    strcat(string, "Remove Dealer\n");
    return FlexPlayerDialog(playerid, "DrugManageDealer", DIALOG_STYLE_TABLIST_HEADERS, "Manage Dealer", string, "Select", "Close", dealerId);
}

FlexDialog:DrugManageDealer(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:AdminMenu(playerid);
    if (IsStringSame(inputtext, "Set Dealer Skin")) return Drug:MenuSetSkin(playerid, dealerId);
    if (IsStringSame(inputtext, "Set Dealer Animation")) return Drug:MenuSetAnimation(playerid, dealerId);
    if (IsStringSame(inputtext, "Teleport to Dealer")) {
        SetPlayerPosEx(playerid, Drug:DealerData[dealerId][Drug:dPosX] + 1, Drug:DealerData[dealerId][Drug:dPosY] + 1, Drug:DealerData[dealerId][Drug:dPosZ] + 1);
        AlexaMsg(playerid, "you are teleported to dealer");
        return Drug:ManageDealer(playerid, dealerId);
    }
    if (IsStringSame(inputtext, "Set Dealer Position")) {
        GetPlayerPos(playerid, Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ]);
        GetPlayerFacingAngle(playerid, Drug:DealerData[dealerId][Drug:dPosA]);
        DestroyDynamicActor(Drug:DealerData[dealerId][Drug:dActorId]);
        Drug:DealerData[dealerId][Drug:dActorId] = CreateDynamicActor(
            Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ],
            Drug:DealerData[dealerId][Drug:dPosA], true, 100.0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1
        );
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Drug:DealerData[dealerId][Drug:dLabelId], E_STREAMER_X, Drug:DealerData[dealerId][Drug:dPosX]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Drug:DealerData[dealerId][Drug:dLabelId], E_STREAMER_Y, Drug:DealerData[dealerId][Drug:dPosY]);
        Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, Drug:DealerData[dealerId][Drug:dLabelId], E_STREAMER_Z, Drug:DealerData[dealerId][Drug:dPosZ] + 0.25);
        Drug:SaveDealer(dealerId);

        SendClientMessageEx(playerid, 0x3498DBFF, "{4286f4}[Drug System]: {FFFFEE}Dealer updated.");
        SetPlayerPosEx(
            playerid, Drug:DealerData[dealerId][Drug:dPosX] + (1.5 * floatsin(-Drug:DealerData[dealerId][Drug:dPosA], degrees)),
            Drug:DealerData[dealerId][Drug:dPosY] + (1.5 * floatcos(-Drug:DealerData[dealerId][Drug:dPosA], degrees)), Drug:DealerData[dealerId][Drug:dPosZ]
        );

        AlexaMsg(playerid, "dealer position updated");
        return Drug:ManageDealer(playerid, dealerId);
    }
    if (IsStringSame(inputtext, "Remove Dealer")) {
        DestroyDynamicActor(Drug:DealerData[dealerId][Drug:dActorId]);
        DestroyDynamic3DTextLabel(Drug:DealerData[dealerId][Drug:dLabelId]);
        DestroyDynamicMapIcon(Drug:DealerData[dealerId][Drug:dMapIcon]);
        Drug:DealerData[dealerId][Drug:dDrugs] = 0;
        Drug:DealerData[dealerId][Drug:dActorId] = -1;
        Drug:DealerData[dealerId][Drug:dLabelId] = Text3D:  - 1;
        Drug:DealerData[dealerId][Drug:dMapIcon] = -1;
        Iter_Remove(Dealers, dealerId);
        Drug:RemoveDealer(dealerId);
        AlexaMsg(playerid, sprintf("drug dealer %d removed", dealerId));
        return 1;
    }
    return Drug:ManageDealer(playerid, dealerId);
}

stock Drug:MenuSetSkin(playerid, dealerId) {
    return FlexPlayerDialog(playerid, "DrugMenuSetSkin", DIALOG_STYLE_INPUT, "Create Dealer", "Enter skinid for dealer\nLimit: 0 to 311", "Create", "Cancel", dealerId);
}

FlexDialog:DrugMenuSetSkin(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:ManageDealer(playerid, dealerId);
    new skinId;
    if (sscanf(inputtext, "d", skinId) || skinId < 0 || skinId > 311) return Drug:MenuSetSkin(playerid, dealerId);
    Drug:DealerData[dealerId][Drug:dSkin] = skinId;
    DestroyDynamicActor(Drug:DealerData[dealerId][Drug:dActorId]);
    Drug:DealerData[dealerId][Drug:dActorId] = CreateDynamicActor(
        Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ],
        Drug:DealerData[dealerId][Drug:dPosA], true, 100.0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1
    );

    Drug:SaveDealer(dealerId);
    return Drug:ManageDealer(playerid, dealerId);
}

stock Drug:MenuSetAnimation(playerid, dealerId) {
    return FlexPlayerDialog(
        playerid, "DrugMenuSetAnimation", DIALOG_STYLE_INPUT, "Dealer Animation",
        "Enter [Animation Lib] [Animation Name] [Loop 0/1]", "Update", "Cancel", dealerId
    );
}

FlexDialog:DrugMenuSetAnimation(playerid, response, listitem, const inputtext[], dealerId, const payload[]) {
    if (!response) return Drug:ManageDealer(playerid, dealerId);
    new lib[50], name[50], loop;
    if (
        sscanf(inputtext, "s[50]s[50]d", lib, name, loop) || loop < 0 || loop > 1 || !IsAnimLibValid(lib) || !IsAnimNameValid(name)
    ) return Drug:MenuSetAnimation(playerid, dealerId);
    Drug:DealerData[dealerId][Drug:dAnimLib] = lib;
    Drug:DealerData[dealerId][Drug:dAnimName] = name;
    Drug:DealerData[dealerId][Drug:dAnimLoop] = loop;
    if (IsValidDynamicActor(Drug:DealerData[dealerId][Drug:dActorId])) DestroyDynamicActor(Drug:DealerData[dealerId][Drug:dActorId]);
    Drug:DealerData[dealerId][Drug:dActorId] = CreateDynamicActor(
        Drug:DealerData[dealerId][Drug:dSkin], Drug:DealerData[dealerId][Drug:dPosX], Drug:DealerData[dealerId][Drug:dPosY], Drug:DealerData[dealerId][Drug:dPosZ],
        Drug:DealerData[dealerId][Drug:dPosA], true, 100.0, Drug:DealerData[dealerId][Drug:dWorld], Drug:DealerData[dealerId][Drug:dInterior], -1
    );
    ApplyDynamicActorAnimation(
        Drug:DealerData[dealerId][Drug:dActorId], Drug:DealerData[dealerId][Drug:dAnimLib], Drug:DealerData[dealerId][Drug:dAnimName],
        4.1, Drug:DealerData[dealerId][Drug:dAnimLoop], 0, 0, 0, 0
    );
    mysql_tquery(Database, sprintf("UPDATE drugdealers SET `Anim_Lib`= \"%s\", `Anim_Name`= \"%s\", `Anim_Loop`='%d' WHERE ID=%d", lib, name, loop, dealerId));
    AlexaMsg(playerid, "dealer updated");
    return Drug:ManageDealer(playerid, dealerId);
}