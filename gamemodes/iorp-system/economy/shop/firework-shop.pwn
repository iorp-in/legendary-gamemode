new firework_num[MAX_PLAYERS];
new firework_object[MAX_PLAYERS];
new firework_start[MAX_PLAYERS];
new firework_spark[MAX_PLAYERS], firework_dim[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    SetPVarInt(playerid, "PType", 0);
    SetPVarInt(playerid, "PColor", 0);
    firework_num[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    return 1;
}

forward svetstart(playerid);
public svetstart(playerid) {
    new Float:simx, Float:simy, Float:simz;
    GetDynamicObjectPos(firework_object[playerid], simx, simy, simz);
    DestroyDynamicObjectEx(firework_object[playerid]);
    firework_object[playerid] = CreateDynamicObject(354, simx, simy, simz + 2, 0, 0, 0);
    SetPreciseTimer("destroyFlare", 15000, 0, "d", playerid);
}

forward dimstart(playerid);
public dimstart(playerid) {
    new Float:dimx, Float:dimy, Float:dimz;
    GetDynamicObjectPos(firework_object[playerid], dimx, dimy, dimz);
    DestroyDynamicObjectEx(firework_object[playerid]);
    firework_object[playerid] = CreateDynamicObject(18715, dimx, dimy, dimz + 2, 0, 0, 0);
    SetPreciseTimer("destroyFlare", 500, 0, "d", playerid);
    new Float:X, Float:Y, Float:Z;
    GetDynamicObjectPos(firework_object[playerid], X, Y, Z);
    PlaySoundForPlayersInRange(1141, 20.0, X, Y, Z);
}

forward startone(playerid);
public startone(playerid) {
    new Float:objx, Float:objy, Float:objz;
    GetDynamicObjectPos(firework_object[playerid], objx, objy, objz);
    MoveDynamicObject(firework_object[playerid], objx, objy, objz + 13, 10);
    firework_spark[playerid] = CreateDynamicObject(18718, objx, objy, objz, 0, 0, 0);
    firework_dim[playerid] = CreateDynamicObject(18715, objx, objy, objz, 0, 0, 0);
    AttachDynamicObjectToObject(firework_spark[playerid], firework_object[playerid], 0, 0, -1, 0, 0, 0, 0);
    AttachDynamicObjectToObject(firework_dim[playerid], firework_object[playerid], 0, 0, 0, 0, 0, 0, 0);
    SetPreciseTimer("startonex", 1200, 0, "d", playerid);
}

forward startonex(playerid);
public startonex(playerid) {
    new Float:oobjx, Float:oobjy, Float:oobjz;
    GetDynamicObjectPos(firework_object[playerid], oobjx, oobjy, oobjz);
    CreateExplosion(oobjx, oobjy, oobjz, 0, 5);
    DestroyDynamicObjectEx(firework_object[playerid]);
    DestroyDynamicObjectEx(firework_spark[playerid]);
    DestroyDynamicObjectEx(firework_dim[playerid]);
    firework_start[playerid] = 0;
}

forward destroyFlare(playerid);
public destroyFlare(playerid) {
    DestroyDynamicObjectEx(firework_object[playerid]);
    firework_start[playerid] = 0;
}

stock blow_pyrotechnic_cmd(playerid) {
    if (firework_num[playerid] < 1) return SendClientMessageEx(playerid, 0xFF8000AA, "You do not have pyrotechnic products");
    if (GetPlayerInterior(playerid) != 0) return SendClientMessageEx(playerid, 0xFF8000AA, "The launch of pyrotechnics in buildings is prohibited");
    if (firework_start[playerid] != 0) return SendClientMessageEx(playerid, 0xFF8000AA, "Please wait...");
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    x += floatsin(-angle, degrees);
    y += floatcos(-angle, degrees);
    firework_num[playerid]--;
    firework_start[playerid] = 1;
    switch (GetPVarInt(playerid, "pType")) {
        case 1 :  {
            firework_object[playerid] = CreateDynamicObject(18717, x, y, z - 2.6, 0, 0, 0);
            SetPreciseTimer("dimstart", 6000, 0, "d", playerid);
        }
        case 2 :  {
            firework_object[playerid] = CreateDynamicObject(18717, x, y, z - 2.6, 0, 0, 0);
            SetPreciseTimer("svetstart", 6000, 0, "d", playerid);
        }
        case 3 :  {
            firework_object[playerid] = CreateDynamicObject(18728, x, y, z - 2, 0, 0, 0);
            SetPreciseTimer("destroyFlare", 10000, 0, "d", playerid);
        }
        case 4 :  {
            switch (GetPVarInt(playerid, "PColor")) {
                case 1:
                    firework_object[playerid] = CreateDynamicObject(1215, x, y, z - 0.5, 0, 0, 0);
                case 2:
                    firework_object[playerid] = CreateDynamicObject(19122, x, y, z - 0.5, 0, 0, 0);
                case 3:
                    firework_object[playerid] = CreateDynamicObject(19123, x, y, z - 0.5, 0, 0, 0);
                case 4:
                    firework_object[playerid] = CreateDynamicObject(19124, x, y, z - 0.5, 0, 0, 0);
                case 5:
                    firework_object[playerid] = CreateDynamicObject(19125, x, y, z - 0.5, 0, 0, 0);
                case 6:
                    firework_object[playerid] = CreateDynamicObject(19126, x, y, z - 0.5, 0, 0, 0);
                case 7:
                    firework_object[playerid] = CreateDynamicObject(19127, x, y, z - 0.5, 0, 0, 0);
            }
            SetPreciseTimer("startone", 6000, 0, "d", playerid);
        }
    }
    Streamer_Update(playerid);
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    if (firework_num[playerid] > 0) UCP:AddCommand(playerid, "Blow Pyrotechnic", true);
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (!strcmp("Blow Pyrotechnic", inputtext)) blow_pyrotechnic_cmd(playerid);
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Firework) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase this firework"); return ~1; }
    GivePlayerCash(playerid, -price, sprintf("Purchased %s firwork from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased firework item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    new firworkID = 0;
    if (shopItemId == 44) firworkID = 1; // Noisy Firecrackers
    if (shopItemId == 45) firworkID = 2; // Light Firecrackers
    if (shopItemId == 46) firworkID = 3; // Smoke Grenade
    if (shopItemId == 47) firworkID = 4; // Single Rocket
    if (firworkID == 0 || firworkID > 4) return ~1;
    SendClientMessageEx(playerid, -1, "{319aff}Use {ffcf00} your pocket > Blow Pyrotechnic {319aff} to use the fireworks");
    SetPVarInt(playerid, "pType", firworkID);
    firework_num[playerid] += 4;
    if (firworkID == 4) FireworkColorSelectMenu(playerid);
    return ~1;
}

FireworkColorSelectMenu(playerid) {
    return FlexPlayerDialog(playerid, "FireworkColorSelectMenu", DIALOG_STYLE_LIST, "Choose a color", "{ffffff}White\n{0000ff}Blue\n{38ff00}Green\n{ff0015}Red\n{66ff00}Bright Green\n{00b2ff}Blue\n{a900ff}Purple", "Choose", "");
}

FlexDialog:FireworkColorSelectMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    SetPVarInt(playerid, "PColor", listitem + 1);
    return 1;
}