//#snippet CreateDynamicExplosion CreateDynamicExplosion(Float:x,Float:y,Float:z,type,Float:radius,worldid=-1,interiorid=-1,playerid=-1,Float:distance=200.0);
//#snippet CreateDynamicExplosionDMG CreateDynamicExplosionDMG(Float:x,Float:y,Float:z,type,Float:radius,worldid=-1,interiorid=-1,playerid=-1,Float:distance=200.0,Float:damage=82.5,Float:vehicle_damage=82.5,byplayerid=INVALID_PLAYER_ID);

#define MAX_MINES								(2048)
#define MINE_INFINITY_HEALTH					(1000000.0)

enum {
    MINE_OBJECT_STANDARD = 19602,
        MINE_OBJECT_UNDERWATER = 2918,
        MINE_OBJECT_LASER = 18643,
        MINE_OBJECT_PIZZA = 19580,
}

enum {
    MINE_STATUS_UNACTIVE,
    MINE_STATUS_ACTIVE,
    MINE_STATUS_DAMAGED
}

enum {
    MINE_DESTROY_TYPE_DETECT,
    MINE_DESTROY_TYPE_KILL
}

enum {
    MINE_DETECT_TYPE_ALL,
    MINE_DETECT_TYPE_PLAYER,
    MINE_DETECT_TYPE_VEHICLE
}

enum Mine:DataEnum {
    Mine:Status,
    Mine:ObjectType,
    Mine:ExplosionType,
    Mine:RespawnTime,
    Float:Mine:Health,
    Float:Mine:MaxHealth,
    Float:Mine:ExplodeRadius,
    Float:Mine:ExplodeDamage,
    Float:Mine:ExplodeVehicleDamage,
    Float:Mine:DetectionRange,
    Mine:DetectType,
    Mine:PlayerName[50],
    Mine:ExplodeForOwner,
    Mine:FactionId,
    Mine:FactionSIgnIn,
    Float:Mine:Pos[6],
    Mine:WorldId,
    Mine:InteriorId,

    STREAMER_TAG_OBJECT:Mine:ObjectId,
    STREAMER_TAG_AREA:Mine:AreaId
}

new Mine:Data[MAX_MINES][Mine:DataEnum];
new Iterator:Mines < MAX_MINES > ;

// stock
stock Mine:GetOwner(mineId) {
    new string[100];
    format(string, sizeof string, "%s", Mine:Data[mineId][Mine:PlayerName]);
    return string;
}
stock Mine:Total() return Iter_Count(Mines);
stock Mine:IsValid(mineId) return Iter_Contains(Mines, mineId);
stock Mine:GetStatus(mineId) return Mine:Data[mineId][Mine:Status];
stock Mine:SetStatus(mineId, status = MINE_STATUS_ACTIVE) return Mine:Data[mineId][Mine:Status] = status;
stock Mine:GetObjectType(mineId) return Mine:Data[mineId][Mine:ObjectType];
stock Mine:GetExplosionType(mineId) return Mine:Data[mineId][Mine:ExplosionType];
stock Float:Mine:GetHealth(mineId) return Mine:Data[mineId][Mine:Health];
stock Float:Mine:SetHealth(mineId, Float:health) return Mine:Data[mineId][Mine:Health] = health;
stock Float:Mine:IncreaseHealth(mineId, Float:health) return Mine:Data[mineId][Mine:Health] += health;
stock Float:Mine:GetMaxHealth(mineId) return Mine:Data[mineId][Mine:MaxHealth];
stock Float:Mine:GetExplodeRadius(mineId) return Mine:Data[mineId][Mine:ExplodeRadius];
stock Float:Mine:GetExplodeDamage(mineId) return Mine:Data[mineId][Mine:ExplodeDamage];
stock Float:Mine:GetExplodeVehicleDamage(mineId) return Mine:Data[mineId][Mine:ExplodeVehicleDamage];
stock Float:Mine:GetDetectionRange(mineId) return Mine:Data[mineId][Mine:DetectionRange];
stock Mine:GetDetectType(mineId) return Mine:Data[mineId][Mine:DetectType];
stock Mine:GetRespawnTime(mineId) return Mine:Data[mineId][Mine:RespawnTime];
stock Mine:GetExplodeForOwner(mineId) return Mine:Data[mineId][Mine:ExplodeForOwner];
stock Mine:GetFactionId(mineId) return Mine:Data[mineId][Mine:FactionId];
stock Mine:GetFactionSIgnIn(mineId) return Mine:Data[mineId][Mine:FactionSIgnIn];
stock Float:Mine:GetPosX(mineId) return Mine:Data[mineId][Mine:Pos][0];
stock Float:Mine:GetPosY(mineId) return Mine:Data[mineId][Mine:Pos][1];
stock Float:Mine:GetPosZ(mineId) return Mine:Data[mineId][Mine:Pos][2];
stock Float:Mine:GetPosRX(mineId) return Mine:Data[mineId][Mine:Pos][3];
stock Float:Mine:GetPosRY(mineId) return Mine:Data[mineId][Mine:Pos][4];
stock Float:Mine:GetPosRZ(mineId) return Mine:Data[mineId][Mine:Pos][5];
stock Mine:GetWorldId(mineId) return Mine:Data[mineId][Mine:WorldId];
stock Mine:GetInteriorId(mineId) return Mine:Data[mineId][Mine:InteriorId];
stock Mine:GetObjectId(mineId) return Mine:Data[mineId][Mine:ObjectId];
stock Mine:GetAreaId(mineId) return Mine:Data[mineId][Mine:AreaId];

stock Mine:GetStatusText(mineId) {
    new string[25], status = Mine:GetStatus(mineId);
    format(
        string, sizeof string, "%s",
        status == MINE_STATUS_DAMAGED ? "Damage"
        : status == MINE_STATUS_UNACTIVE ? "Deactive" :
        "Active"
    );
    return string;
}

stock Mine:Create(const createdBy[], Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, worldid = 0, interiorid = 0, activeIn = 30, explodeForOwner = 1, factionId = -1, signInRequired = 0, explosionType = 2, objectType = MINE_OBJECT_STANDARD, detectionType = MINE_DETECT_TYPE_ALL, Float:detectionRange = 20.0, respawn = 0, Float:health = 1000.0, Float:maxHealth = 1000.0, Float:explodeRadius = 50.0, Float:damage = 82.5, Float:vehicle_damage = 82.5) {
    new mineId = Iter_Free(Mines);
    if (mineId == INVALID_ITERATOR_SLOT) return 0;
    format(Mine:Data[mineId][Mine:PlayerName], 50, "%s", createdBy);
    Mine:Data[mineId][Mine:Status] = MINE_STATUS_UNACTIVE;
    Mine:Data[mineId][Mine:ObjectType] = objectType;
    Mine:Data[mineId][Mine:ExplosionType] = explosionType;
    Mine:Data[mineId][Mine:RespawnTime] = respawn;
    Mine:Data[mineId][Mine:Health] = health;
    Mine:Data[mineId][Mine:MaxHealth] = maxHealth;
    Mine:Data[mineId][Mine:ExplodeRadius] = explodeRadius;
    Mine:Data[mineId][Mine:ExplodeDamage] = damage;
    Mine:Data[mineId][Mine:ExplodeVehicleDamage] = vehicle_damage;
    Mine:Data[mineId][Mine:DetectionRange] = detectionRange;
    Mine:Data[mineId][Mine:DetectType] = detectionType;
    Mine:Data[mineId][Mine:ExplodeForOwner] = explodeForOwner;
    Mine:Data[mineId][Mine:FactionId] = factionId;
    Mine:Data[mineId][Mine:FactionSIgnIn] = signInRequired;
    Mine:Data[mineId][Mine:Pos][0] = x;
    Mine:Data[mineId][Mine:Pos][1] = y;
    Mine:Data[mineId][Mine:Pos][2] = z;
    Mine:Data[mineId][Mine:Pos][3] = rx;
    Mine:Data[mineId][Mine:Pos][4] = ry;
    Mine:Data[mineId][Mine:Pos][5] = rz;
    Mine:Data[mineId][Mine:WorldId] = worldid;
    Mine:Data[mineId][Mine:InteriorId] = interiorid;


    Mine:Data[mineId][Mine:ObjectId] = CreateDynamicObject(objectType, x, y, z, rx, ry, rz, worldid, interiorid);
    Mine:Data[mineId][Mine:AreaId] = CreateDynamicSphere(x, y, z, detectionRange, worldid, interiorid);
    AttachDynamicAreaToObject(Mine:Data[mineId][Mine:AreaId], Mine:Data[mineId][Mine:ObjectId]);

    if (activeIn > 0) SetPreciseTimer("MineRespawn", activeIn * 1000, false, "d", mineId);

    Iter_Add(Mines, mineId);
    return 1;
}

stock Mine:Explode(mineId, type, playerid) {
    if (Float:Mine:GetHealth(mineId) == -1.0) {
        CreateDynamicExplosion(
            Mine:GetPosX(mineId), Mine:GetPosY(mineId), Mine:GetPosZ(mineId), Mine:GetExplosionType(mineId),
            Float:Mine:GetExplodeRadius(mineId), Mine:GetWorldId(mineId), Mine:GetInteriorId(mineId)
        );
    } else {
        CreateDynamicExplosionDMG(
            Mine:GetPosX(mineId), Mine:GetPosY(mineId), Mine:GetPosZ(mineId), Mine:GetExplosionType(mineId),
            Float:Mine:GetExplodeRadius(mineId), Mine:GetWorldId(mineId), Mine:GetInteriorId(mineId), -1, 200.0,
            Float:Mine:GetExplodeDamage(mineId), Float:Mine:GetExplodeVehicleDamage(mineId), INVALID_PLAYER_ID
        );
    }
    Mine:SetStatus(mineId, MINE_STATUS_DAMAGED);
    if (Mine:GetRespawnTime(mineId) > 0) SetPreciseTimer("MineRespawn", Mine:GetRespawnTime(mineId), false, "d", mineId);
    else {
        Mine:Remove(mineId);
    }
    CallRemoteFunction("OnMineDestory", "ddd", mineId, type, playerid);
    return 1;
}

stock Mine:Remove(mineId) {
    DestroyDynamicObjectEx(Mine:GetObjectId(mineId));
    DestroyDynamicArea(Mine:GetAreaId(mineId));
    Iter_Remove(Mines, mineId);
    return 1;
}

// public

forward MineRespawn(mineId);
public MineRespawn(mineId) {
    Mine:SetStatus(mineId, MINE_STATUS_ACTIVE);
    return 1;
}

forward OnMineDestory(mineId, type, playerid);
public OnMineDestory(mineId, type, playerid) {
    return 1;
}

// hook

hook OnPlayerShootDynObj(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z) {
    foreach(new mineId: Mines) {
        if (objectid == Mine:GetObjectId(mineId)) {
            if (Mine:GetHealth(mineId) == MINE_INFINITY_HEALTH) return 1;
            Mine:IncreaseHealth(mineId, Tryg3D::GetWeaponDamage(weaponid));
            new buffer[128];
            if (Mine:GetHealth(mineId) > 0) {
                format(buffer, sizeof buffer, "Mine~n~~w~%.0f HP~n~~r~~h~~h~-%.0f HP", Mine:GetHealth(mineId), Tryg3D::GetWeaponDamage(weaponid));
            } else {
                format(buffer, sizeof buffer, "Mine~n~~w~0 HP~n~~r~~h~~h~-%.0f HP", Tryg3D::GetWeaponDamage(weaponid));
            }
            GameTextForPlayer(playerid, buffer, 500, 4);
            if (Mine:GetHealth(mineId) <= 0.0) Mine:Explode(mineId, MINE_DESTROY_TYPE_KILL, playerid);
            return 1;
        }
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid) {
    foreach(new mineId: Mines) {
        if (areaid == Mine:GetAreaId(mineId)) {
            // check detection
            if (Mine:GetStatus(mineId) != MINE_STATUS_ACTIVE ||
                (Mine:GetDetectType(mineId) == MINE_DETECT_TYPE_PLAYER && IsPlayerInAnyVehicle(playerid)) ||
                (Mine:GetDetectType(mineId) == MINE_DETECT_TYPE_VEHICLE && !IsPlayerInAnyVehicle(playerid))
            ) return 1;

            // validate faction
            if (Mine:GetFactionId(mineId) != -1 && Mine:GetFactionId(mineId) == Faction:GetPlayerFID(playerid)) {
                if (!Mine:GetFactionSIgnIn(mineId)) return 1;
                if (Faction:IsPlayerSigned(playerid)) return 1;
            }

            // validate owner
            if (!Mine:GetExplodeForOwner(mineId) && IsStringSame(Mine:GetOwner(mineId), GetPlayerNameEx(playerid))) return 1;

            // explode
            Mine:SetHealth(mineId, 0.0);
            Mine:Explode(mineId, MINE_DESTROY_TYPE_DETECT, playerid);
            return 1;
        }
    }
    return 1;
}

/*
    MineComponent[mobid][mine_objectid] = CreateDynamicObject(MINE_OBJECT_STANDARD, x, y, z - 0.93, 0.0, 0.0, 0.0, worldid, interiorid, playerid, streamdistance);
    MineComponent[mobid][mine_objectid] = CreateDynamicObject(MINE_OBJECT_UNDERWATER, x, y, z - 0.10, 0.0, 0.0, 0.0, worldid, interiorid, playerid, streamdistance);
    MineComponent[mobid][mine_objectid] = CreateDynamicObject(MINE_OBJECT_LASER, x, y, z - 0.09, 180.0, 90.0, 0.0, worldid, interiorid, playerid, streamdistance);
    MineComponent[mobid][mine_objectid] = CreateDynamicObject(MINE_OBJECT_PIZZA, x, y, z + 0.05, 0.0, 0.0, 0.0, worldid, interiorid, playerid, streamdistance);
    MineComponent[mobid][mine_objectid] = CreateDynamicObject(19602, x, y, z - 0.93, 0.0, 0.0, 0.0, worldid, interiorid, playerid, streamdistance);
*/