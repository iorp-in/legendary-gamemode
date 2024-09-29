UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (Faction:GetPlayerFID(playerid) != 0 || !Faction:IsPlayerSigned(playerid) || Faction:GetPlayerRankID(playerid) < 4) return 1;
    new houseid = GetNearestHouseID(playerid);
    if (houseid != -1) {
        if (House:IsPurchased(houseid)) {
            new targetid = GetPlayerIDByName(House:GetOwner(houseid));
            if (targetid != -1) {
                if (IsPlayerInRangeOfPlayer(playerid, targetid, 10.0)) {
                    UCP:AddCommand(playerid, "Seize House", true);
                }
            }
        }
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Seize House", inputtext)) {
        new houseid = GetNearestHouseID(playerid);
        if (houseid != -1) {
            if (House:IsPurchased(houseid)) {
                new targetid = GetPlayerIDByName(House:GetOwner(houseid));
                if (targetid != -1) {
                    if (IsPlayerInRangeOfPlayer(playerid, targetid, 10.0)) {
                        House:Reset(houseid);
                        SendClientMessage(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} house [%d] seized by government employee %s", houseid, GetPlayerNameEx(playerid)));
                    }
                }
            }
        }
        return ~1;
    }
    return 1;
}