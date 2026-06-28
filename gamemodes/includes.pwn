#pragma compress 0
#pragma dynamic 1000000
#if defined MAX_PLAYERS
#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS 100
#define MAX_NODES 32768
#define MAX_Y_HOOKS (1000)
#define CGEN_MEMORY (80000)
#define STRLIB_RETURN_SIZE 1024

#include "includes/a_samp"
#include "includes/a_mysql"
#include "includes/a_zone"
#include "includes/a_zones"
#include "includes/PawnPlus"
#include "includes/Pawn.CMD"
#include "includes/GPS"
#include "includes/sscanf2"
#include "includes/streamer"
// #include "includes/discord-connector"
#include "includes/evi"
#include "includes/gl_common"
#include "includes/WeaponData"
#include <YSI_Data/y_bit>
#include <YSI_Data/y_iterate>
// #include "includes/Pawn.RakNet"
#include "includes/foreach"
#include "includes/td-streamer"
#include "includes/PreviewModelDialog"
#include "includes/strlib"
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include "includes/3DTryg"
#include "includes/EVF"
#include "includes/samp-precise-timers"

//#function GetDynamicObjectModel(objectid);
#define GetDynamicObjectModel(%0) Streamer_GetIntData(STREAMER_TYPE_OBJECT, %0, E_STREAMER_MODEL_ID)

native IsStringContainWords(const string[], const words[]);
native SortString(const input[], const response[], size = sizeof response);
native TrimString(const input[], const output[], size = sizeof output);
native GetMenuList(const input[], const output[], size = sizeof output);
native GetHeaderMenuList(const input[], const output[], size = sizeof output);
native GetMenuString(const input[], position, const output[], size = sizeof output);
native GetWord(const string[], position = 0, const response[], size = sizeof response);
native GetSubString(const string[], const word[], const response[], size = sizeof response);
native RegMatch(const pattern[], const name[]);
native UnixToHuman(unix, const response[], const format[] = "%v %R", size = sizeof response);

native log(const text[], const filename[] = "samp_logger.txt", const dateformat[] = "%Y-%m-%d %H:%M:%S: ");

native Alexa(playerid, const query[], offset = 0);
native Math(playerid, const query[], offset = 0);
native IpInfo(playerid, const ip[], const token[], offset = 0);
native GetPercentage(value, maximum);
native GetPercentageOf(percent, value);
native regexMatchCount(const regex[], const input[]);
native sendHttpGet(const url[]);
native sendHttpPost(const url[], const body[]);

forward OnAlexaReply(playerid, const response[], offset);
public OnAlexaReply(playerid, const response[], offset) {
    // printf("onAlexaReply: playerid: %d, response: %s, offset: %d", playerid, response, offset);
    return 1;
}

forward OnMathResponse(playerid, const response[], offset);
public OnMathResponse(playerid, const response[], offset) {
    // printf("OnMathResponse: playerid: %d, response: %s, offset: %d", playerid, response, offset);
    return 1;
}

forward OnIpInfoResponse(playerid, const ip[], const loc[], const country[], const region[], const city[], const org[], const timezone[], const postal[], offset);
public OnIpInfoResponse(playerid, const ip[], const loc[], const country[], const region[], const city[], const org[], const timezone[], const postal[], offset) {
    // printf("playerid = %d, const ip[] = %s, const loc[] = %s, const country[] = %s, const region[] = %s, const city[] = %s, const org[] = %s, const timezone[] = %s, const postal[] = %s, offset = %d", playerid, ip, loc, country, region, city, org, timezone, postal, offset);
    return 1;
}

//#snippet init_cmd cmd:function(playerid, const params[]) {\n\treturn 1;\n}
//#snippet for for (new i; i < total; i++) {\n\n}