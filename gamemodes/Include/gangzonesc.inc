/*
	Interactive Gangzones (gangzones.inc)
	* Add boders to your gangzones and fully customizable gangzones. New dynamic functions for gangzones.

 	Author: (creator)
	* Gammix

 	Contributors:
	* Incognito - Streamer plugin, used dynamic areas

	(c) Copyright 2015
  	* This file is provided as is (no warranties).
*/
/*
FUNCTIONS:
native GangZoneCreate(Float:minx, Float:miny, Float:maxx, Float:maxy, color = -1, Float:bordersize = 1.0, brodercolor = 0x00000060);
native GangZoneDestroy(zone);
native GangZoneExist(zone);
native GangZoneShowForPlayer(playerid, zone, color = -1, bordercolor = -1);
native GangZoneShowForAll(zone, color = -1, bordercolor = -1);
native GangZoneHideForPlayer(playerid, zone);
native GangZoneHideForAll(zone);
native GangZoneFlashForPlayer(playerid, zone, flashcolor);
native GangZoneFlashForAll(zone, flashcolor);
native GangZoneStopFlashForPlayer(playerid, zone);
native GangZoneStopFlashForAll(zone);
native CountAllGangZones();
native IsPlayerInGangZone(playerid, zone);
native IsPlayerInAnyGangZone(playerid);
native GetPlayerGangZone(playerid);

CALLBACKS:
public OnPlayerEnterGangZone(playerid, zone);
public OnPlayerLeaveGangZone(playerid, zone);
*/

#include <streamer>

#define MAX_ZONES 1024//maximum gangzones your server can have, the limit is upto 1024 and minimum 5
//Note: Creating one interactive gangzone makes total 5 zones, 4 for borders and 1 for the main zone!

enum GangzoneInfo
{
	bool:E_exist,
	E_border[4],
	Float:E_minx,
	Float:E_miny,
	Float:E_maxx,
	Float:E_maxy,
 	E_dynamic,
 	E_color,
 	E_bordercolor
}
static gGangzone[MAX_ZONES][GangzoneInfo];

//Note: if you use this in a filterscript, please define "FILTERSCRIPT" in your script
#if defined FILTERSCRIPT// if used in a filterscript

	public OnFilterScriptExit()
	{
	    DestroyAllGangZones();//destory all gangzones

	    return CallLocalFunction("GZ_OnFilterScriptExit", " ");
	}
	#if defined _ALS_OnFilterScriptExit
		#undef OnFilterScriptExit
	#else
		#define _ALS_OnFilterScriptExit
	#endif
	#define OnFilterScriptExit GZ_OnFilterScriptExit
	forward GZ_OnFilterScriptExit();

#else// if used in a gamemode

	public OnGameModeExit()
	{
	    DestroyAllGangZones();//destory all gangzones

	    return CallLocalFunction("GZ_OnGameModeExit", " ");
	}
	#if defined _ALS_OnGameModeExit
		#undef OnGameModeExit
	#else
		#define _ALS_OnGameModeExit
	#endif
	#define OnGameModeExit GZ_OnGameModeExit
	forward GZ_OnGameModeExit();

#endif

stock GangZoneCreate_(Float:minx, Float:miny, Float:maxx, Float:maxy, color = -1, Float:bordersize = 1.0, brodercolor = 0x00000060)
{
	new E_zone = GangZoneCreate(minx, miny, maxx, maxy);//the main zone

	gGangzone[E_zone][E_minx] = minx;
	gGangzone[E_zone][E_miny] = miny;
	gGangzone[E_zone][E_maxx] = maxx;
	gGangzone[E_zone][E_maxy] = maxy;

	gGangzone[E_zone][E_color] = color;
	gGangzone[E_zone][E_bordercolor] = brodercolor;

	#define SEPERATION  (2.0 * bordersize)//the seperation value to differenciate borders from gangzone, set accordingly! (Default: 2.0)
	gGangzone[E_zone][E_border][0] = GangZoneCreate(minx - SEPERATION, miny, minx + SEPERATION, maxy);//border 1
	gGangzone[E_zone][E_border][1] = GangZoneCreate(minx - SEPERATION, maxy - SEPERATION, maxx, maxy + SEPERATION);//border 2
	gGangzone[E_zone][E_border][2] = GangZoneCreate(maxx - SEPERATION, miny, maxx + SEPERATION, maxy);//border 3
	gGangzone[E_zone][E_border][3] = GangZoneCreate(minx - SEPERATION, miny - SEPERATION, maxx, miny + SEPERATION);//border 4

	gGangzone[E_zone][E_dynamic] = CreateDynamicRectangle(minx, miny, maxx, maxy);//creating the dynamic zone

	gGangzone[E_zone][E_exist] = true;//finally, zone exists!
	return E_zone;
}
#if defined _ALS_GangZoneCreate
    #undef GangZoneCreate
#else
    #define _ALS_GangZoneCreate
#endif
#define GangZoneCreate GangZoneCreate_

stock GangZoneDestroy_(zone)
{
  	if(! gGangzone[zone][E_exist]) return false;//check if exists

  	gGangzone[zone][E_minx] = 0.0;
	gGangzone[zone][E_miny] = 0.0;
	gGangzone[zone][E_maxx] = 0.0;
	gGangzone[zone][E_maxy] = 0.0;

    GangZoneDestroy(zone);//destroy main zone

 	for(new border = 0; border < 4; border++)//destroy all 4 borders
 	{
    	GangZoneDestroy(gGangzone[zone][E_border][border]);
 	}

	DestroyDynamicArea(gGangzone[zone][E_dynamic]);//destory dynamic area
	gGangzone[zone][E_dynamic] = -1;

 	gGangzone[zone][E_exist] = false;//finally, zone doesn't exists
  	return true;
}
#if defined _ALS_GangZoneDestroy
    #undef GangZoneDestroy
#else
    #define _ALS_GangZoneDestroy
#endif
#define GangZoneDestroy GangZoneDestroy_

stock GangZoneExist(zone)
{
    if(zone < 0 || zone >= MAX_ZONES)
	{
	    printf("Error::GangZoneExist()::Out Of Bounds::%i", zone);//by pottus
		return false;//if invalid zone id
    }

	return gGangzone[zone][E_exist];//check if zone exists!
}

stock GangZoneShowForPlayer_(playerid, zone, color = -1, bordercolor = -1)
{
	/*
	NOTE: if color is "-1" and if bordercolor is "-1", then the system will set
			the zone color automatically to default(the one set on creating the zone)!
	*/

  	if(! GangZoneExist(zone)) return false;

	if(color == -1) color = gGangzone[zone][E_color];
	else gGangzone[zone][E_color] = color;
	if(bordercolor == -1) bordercolor = gGangzone[zone][E_bordercolor];
	else gGangzone[zone][E_bordercolor] = bordercolor;

	GangZoneShowForPlayer(playerid, zone, color);
 	for(new border = 0; border < 4; border++) GangZoneShowForPlayer(playerid, gGangzone[zone][E_border][border], bordercolor);

	return true;
}
#if defined _ALS_GangZoneShowForPlayer
    #undef GangZoneShowForPlayer
#else
    #define _ALS_GangZoneShowForPlayer
#endif
#define GangZoneShowForPlayer GangZoneShowForPlayer_

stock GangZoneShowForAll_(zone, color = -1, bordercolor = -1)
{
  	if(! GangZoneExist(zone)) return false;

	if(color == -1) color = gGangzone[zone][E_color];
	else gGangzone[zone][E_color] = color;
	if(bordercolor == -1) bordercolor = gGangzone[zone][E_bordercolor];
	else gGangzone[zone][E_bordercolor] = bordercolor;

 	GangZoneShowForAll(zone, color);
	for(new border = 0; border < 4; border++) GangZoneShowForAll(gGangzone[zone][E_border][border], bordercolor);

	return true;
}
#if defined _ALS_GangZoneShowForAll
    #undef GangZoneShowForAll
#else
    #define _ALS_GangZoneShowForAll
#endif
#define GangZoneShowForAll GangZoneShowForAll_

stock GangZoneHideForPlayer_(playerid, zone)
{
  	if(! GangZoneExist(zone)) return false;

	GangZoneHideForPlayer(playerid, zone);
	for(new border = 0; border < 4; border++) GangZoneHideForPlayer(playerid, gGangzone[zone][E_border][border]);

	return true;
}
#if defined _ALS_GangZoneHideForPlayer
    #undef GangZoneHideForPlayer
#else
    #define _ALS_GangZoneHideForPlayer
#endif
#define GangZoneHideForPlayer GangZoneHideForPlayer_

stock GangZoneHideForAll_(zone)
{
  	if(! GangZoneExist(zone)) return false;

	GangZoneHideForAll(zone);
	for(new border = 0; border < 4; border++) GangZoneHideForAll(gGangzone[zone][E_border][border]);

	return true;
}
#if defined _ALS_GangZoneHideForAll
    #undef GangZoneHideForAll
#else
    #define _ALS_GangZoneHideForAll
#endif
#define GangZoneHideForAll GangZoneHideForAll_

//the flashing functions are same as that of samp!
// GangZoneFlashForPlayer(playerid, zone, flashcolor);

// GangZoneFlashForAll(zone, flashcolor);

// GangZoneStopFlashForPlayer(playerid, zone);

// GangZoneStopFlashForAll(zone);

stock CountAllGangZones()
{
	new count = 0;
    for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        count ++;
		}
	}
	return count;
}

stock DestroyAllGangZones()
{
	for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        GangZoneDestroy(zone);
		}
	}
	return true;
}

stock ShowAllGangZonesForPlayer(playerid, color = -1, bordercolor = -1)
{
	for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        GangZoneShowForPlayer(playerid, zone, color, bordercolor);
		}
	}
	return true;
}

stock ShowAllGangZonesForAll(color = -1, bordercolor = -1)
{
	for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        GangZoneShowForAll(zone color, bordercolor);
		}
	}
	return true;
}

stock HideAllGangZonesForPlayer(playerid)
{
	for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        GangZoneHideForPlayer(playerid, zone);
		}
	}
	return true;
}

stock HideAllGangZonesForAll()
{
	for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
	        GangZoneHideForAll(zone);
		}
	}
	return true;
}

stock IsPlayerInGangZone(playerid, zone)
{
  	if(! GangZoneExist(zone)) return false;

	if(IsPlayerInDynamicArea(playerid, gGangzone[zone][E_dynamic])) return true;
	return false;
}

stock IsPlayerInAnyGangZone(playerid)
{
	if(! IsPlayerConnected(playerid)) return false;

	if(IsPlayerInAnyDynamicArea(playerid)) return true;
	return false;
}

stock GetPlayerGangZone(playerid)
{
	if(! IsPlayerConnected(playerid)) return false;

	return GetPlayerNumberDynamicAreas(playerid);
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
			if(areaid == gGangzone[zone][E_dynamic])
	    	{
	    	    CallLocalFunction("OnPlayerEnterGangZone", "dd", playerid, zone);
	    	    break;
	    	}
	    }
	}
    return CallLocalFunction("GZ_OnPlayerEnterDynamicArea", "ii", playerid, areaid);
}
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea GZ_OnPlayerEnterDynamicArea
forward GZ_OnPlayerEnterDynamicArea(playerid, areaid);

//the system callback
forward OnPlayerEnterGangZone(playerid, zone);

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new zone = 0; zone < MAX_ZONES; zone++)
	{
	    if(GangZoneExist(zone))
	    {
			if(areaid == gGangzone[zone][E_dynamic])
	    	{
	    	    CallLocalFunction("OnPlayerLeaveGangZone", "dd", playerid, zone);
	    	    break;
	    	}
	    }
	}
    return CallLocalFunction("GZ_OnPlayerLeaveDynamicArea", "ii", playerid, areaid);
}
#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea GZ_OnPlayerLeaveDynamicArea
forward GZ_OnPlayerLeaveDynamicArea(playerid, areaid);

//the system callback
forward OnPlayerLeaveGangZone(playerid, zone);
