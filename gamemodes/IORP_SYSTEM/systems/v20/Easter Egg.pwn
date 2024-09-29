const EasterEgg:MaxEgg = 50;
const EasterEgg:MaxGroups = 4;
enum EasterEgg:groupData {
    Float:EasterEgg:minx,
    Float:EasterEgg:miny,
    Float:EasterEgg:maxx,
    Float:EasterEgg:maxy,
    Float:EasterEgg:zAverage
}
new EasterEgg:EggsTappingObject[MAX_PLAYERS];
new EasterEgg:EggsObjects[EasterEgg:MaxEgg];
new EasterEgg:LocationGroups[EasterEgg:MaxGroups][EasterEgg:groupData] = {
    {-281.4287, -197.1730, 71.2934, 215.5010, 3.0 },
    {-1187.0, -1330.0, -1006.0, -920.0, 130.0 },
    {-1411.0, -1608.0, -1337.0, -1439.0, 102.0 },
    { 1005.0, 732.0, 1333.0, 797.0, 11.0 }
};

hook OnGameModeInit() {
    Database:AddColumn("playerdata", "EasterEgg", "int", "0");
    EasterEgg:SpawnEggs();
    return 1;
}

hook GlobalHourInterval() {
    EasterEgg:SpawnEggs();
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid) {
    for (new i; i < EasterEgg:MaxEgg; i++) {
        if (EasterEgg:EggsObjects[i] == pickupid) {
            DestroyDynamicPickup(pickupid);
            new eggs = Database:GetInt(GetPlayerNameEx(playerid), "username", "EasterEgg");
            if (eggs >= 10) {
                GameTextForPlayer(playerid, "~r~Easter Egg: ~y~Max Limit Reached", 3000, 3);
            } else {
                GameTextForPlayer(playerid, "~r~Easter Egg: ~w~+1", 3000, 3);
                Database:UpdateInt(eggs + 1, GetPlayerNameEx(playerid), "username", "EasterEgg");
            }
        }
    }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new pEggs = Database:GetInt(GetPlayerNameEx(playerid), "username", "EasterEgg");
    new p2Eggs = Database:GetInt(GetPlayerNameEx(targetid), "username", "EasterEgg");
    if (pEggs > 0 && p2Eggs > 0 && GetPlayerCash(playerid) > 100 && GetPlayerCash(targetid) > 100) QuickActions:AddCommand(playerid, "Play egg tapping");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Play egg tapping", inputtext)) {
        EasterEgg:EggTapping(playerid, targetid);
        return ~1;
    }
    return 1;
}

forward EggTappingFinish(playerid, targetid, object1, object2);
public EggTappingFinish(playerid, targetid, object1, object2) {
    DestroyDynamicObjectEx(object1);
    DestroyDynamicObjectEx(object2);
    new choice = RandomEx(10, 30);
    if (choice > 20) {
        GameTextForPlayer(playerid, "~r~Easter Egg: ~y~You Won", 3000, 3);
        GameTextForPlayer(targetid, "~r~Easter Egg: ~y~You Loss", 3000, 3);
        GivePlayerCash(playerid, 100, sprintf("played egg tapping with %s", GetPlayerNameEx(targetid)));
        GivePlayerCash(targetid, -100, sprintf("played egg tapping with %s", GetPlayerNameEx(playerid)));
    } else {
        GameTextForPlayer(targetid, "~r~Easter Egg: ~y~You Won", 3000, 3);
        GameTextForPlayer(playerid, "~r~Easter Egg: ~y~You Loss", 3000, 3);
        GivePlayerCash(playerid, -100, sprintf("played egg tapping with %s", GetPlayerNameEx(targetid)));
        GivePlayerCash(targetid, 100, sprintf("played egg tapping with %s", GetPlayerNameEx(playerid)));
    }

    new pEggs = Database:GetInt(GetPlayerNameEx(playerid), "username", "EasterEgg");
    new p2Eggs = Database:GetInt(GetPlayerNameEx(targetid), "username", "EasterEgg");
    Database:UpdateInt(pEggs - 1, GetPlayerNameEx(playerid), "username", "EasterEgg");
    Database:UpdateInt(p2Eggs - 1, GetPlayerNameEx(targetid), "username", "EasterEgg");
    return 1;
}

stock EasterEgg:SpawnEggs() {
    for (new i; i < EasterEgg:MaxEgg; i++) {
        new ranChoice = RandomEx(0, EasterEgg:MaxGroups);
        new Float:minx = EasterEgg:LocationGroups[ranChoice][EasterEgg:minx];
        new Float:miny = EasterEgg:LocationGroups[ranChoice][EasterEgg:miny];
        new Float:maxx = EasterEgg:LocationGroups[ranChoice][EasterEgg:maxx];
        new Float:maxy = EasterEgg:LocationGroups[ranChoice][EasterEgg:maxy];
        new Float:zAverage = EasterEgg:LocationGroups[ranChoice][EasterEgg:zAverage];
        new Float:rx, Float:ry;
        RandomPointInRectangle(minx, miny, maxx, maxy, rx, ry);
        DestroyDynamicPickup(EasterEgg:EggsObjects[i]);
        EasterEgg:EggsObjects[i] = CreateDynamicPickup(19341, 2, rx, ry, zAverage, 0, 0);
    }
    return 1;
}

stock EasterEgg:DestroyAllEggs() {
    for (new i; i < EasterEgg:MaxEgg; i++) DestroyDynamicPickup(EasterEgg:EggsObjects[i]);
    return 1;
}

stock EasterEgg:EggTapping(playerid, targetid) {
    new Float:locp[7];
    GetPlayerPos(playerid, locp[0], locp[1], locp[2]);
    GetXYInFrontOfPlayer(playerid, locp[0], locp[1], 5.0);
    GetXYOnAnglePlayer(playerid, locp[3], locp[4], 10.0, 45.0);
    GetXYOnAnglePlayer(playerid, locp[5], locp[6], 10.0, -45.0);
    DestroyDynamicObjectEx(EasterEgg:EggsTappingObject[playerid]);
    DestroyDynamicObjectEx(EasterEgg:EggsTappingObject[targetid]);
    EasterEgg:EggsTappingObject[playerid] = CreateDynamicObject(19341, locp[3], locp[4], locp[2], 0.0, 0.0, 0.0);
    EasterEgg:EggsTappingObject[targetid] = CreateDynamicObject(19341, locp[5], locp[6], locp[2], 0.0, 0.0, 0.0);
    MoveDynamicObject(EasterEgg:EggsTappingObject[playerid], locp[0], locp[1], locp[2], 5.0);
    MoveDynamicObject(EasterEgg:EggsTappingObject[targetid], locp[0], locp[1], locp[2], 5.0);
    SetTimerEx("EggTappingFinish", 3000, false, "dddd", playerid, targetid, EasterEgg:EggsTappingObject[playerid], EasterEgg:EggsTappingObject[targetid]);
    return 1;
}