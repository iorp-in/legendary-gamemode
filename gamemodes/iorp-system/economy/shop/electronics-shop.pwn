new Dialog_ETSHOP;


hook OnGameModeInit() {
    Dialog_ETSHOP = Dialog:GetFreeID();
    return 1;
}

new etshop_string_top[MAX_PLAYERS][2000];
new etshop_string[MAX_PLAYERS][2000];
stock ETShop_Init(playerid, page = 0) {
    format(etshop_string_top[playerid], 500, "");
    format(etshop_string[playerid], 2000, "");
    CallRemoteFunction("ETShop_OnInit", "dd", playerid, page);
    return 1;
}

forward ETShop_OnResponse(playerid, page, response, listitem, const inputtext[]);
public ETShop_OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (page > 0 && !response) ETShop_Init(playerid, page - 1);
    //if(page == 0 && !response) User_Panel(playerid);
    return 1;
}

forward ETShop_OnInit(playerid, page);
public ETShop_OnInit(playerid, page) {
    SortString(etshop_string_top[playerid], etshop_string_top[playerid]);
    SortString(etshop_string[playerid], etshop_string[playerid]);
    if (!strlen(etshop_string[playerid])) format(etshop_string[playerid], 2000, "Nothing On This Page.");
    else ETShop_AddCommand(playerid, "Next Page");
    if (page != 0) ETShop_AddCommand(playerid, "Back Page");
    if (strlen(etshop_string_top[playerid]) > 0) format(etshop_string[playerid], 2000, "%s\n%s", etshop_string_top[playerid], etshop_string[playerid]);
    format(etshop_string[playerid], 2000, "%s\n%s", "Product\tPrice\tStatus", etshop_string[playerid]);
    return FlexPlayerDialog(playerid, "ElectronicShopMenu", DIALOG_STYLE_TABLIST_HEADERS, "{4286f4}[Alexa]: {FFFFEE}Electronic Items Shop", etshop_string[playerid], "Select", "Close", page);
}

FlexDialog:ElectronicShopMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!strcmp("Nothing On This Page.", inputtext) && response) ETShop_Init(playerid, extraid);
    else if (!strcmp("Next Page", inputtext) && response) ETShop_Init(playerid, extraid + 1);
    else if (!strcmp("Back Page", inputtext) && response) ETShop_Init(playerid, extraid - 1);
    else CallRemoteFunction("ETShop_OnResponse", "dddds", playerid, extraid, response, listitem, inputtext);
    return 1;
}

stock ETShop_AddCommand(playerid, const product[], price = 0, bool:item_status = false, bool:top = false) {
    if (top) {
        if (!strlen(etshop_string_top[playerid])) format(etshop_string_top[playerid], 2000, "%s\t$%s\t%s", product, FormatCurrency(price), item_status ? "{ff0000}Bought{FFFFFF}" : "{008000}Buy{FFFFFF}");
        else format(etshop_string_top[playerid], 2000, "%s\n%s\t$%s\t%s", etshop_string_top[playerid], product, FormatCurrency(price), item_status ? "{ff0000}Bought{FFFFFF}" : "{008000}Buy{FFFFFF}");
    } else {
        if (!strlen(etshop_string[playerid])) format(etshop_string[playerid], 2000, "%s\t$%s\t%s", product, FormatCurrency(price), item_status ? "{ff0000}Bought{FFFFFF}" : "{008000}Buy{FFFFFF}");
        else format(etshop_string[playerid], 2000, "%s\n%s\t$%s\t%s", etshop_string[playerid], product, FormatCurrency(price), item_status ? "{ff0000}Bought{FFFFFF}" : "{008000}Buy{FFFFFF}");
    }
    return 1;
}

stock etshop_cmd(playerid) {
    return ETShop_Init(playerid);
}