#define TextDrawSetFormat(%0,%1) do{new _str[128]; format(_str,128,%1); TextDrawSetString(%0,_str);}while(FALSE)
new Text:XTextdrawHour, Text:TextdrawMinute, Text:TextdrawSeconds, Text:TextdrawDay, Text:TextdrawMonth, Text:ServerTag;
new Text:XTextdrawHourEx, Text:TextdrawMinuteEx, Text:TextdrawSecondsEx, Text:TextdrawDayEx, Text:TextdrawMonthEx, Text:ServerTagEx;

///=== Weathers ===///
new SpringWeather[8] = { 1, 10, 11, 14, 17 };
new SummerWeather[5] = { 0, 1, 10, 11 };
new AutumnWeather[10] = { 7, 9, 12, 15, 16, 17 };
new WinterWeather[13] = { 1, 4, 5, 7, 9, 12, 15, 17, 20 };

forward UpdateClock();
public UpdateClock() {
    //News
    new ServerHour, ServerMinute, ServerSecond;
    new Year, Month, Day;
    new summerrand = random(sizeof(SummerWeather));
    new winterrand = random(sizeof(WinterWeather));
    new springrand = random(sizeof(SpringWeather));
    new autumnrand = random(sizeof(AutumnWeather));

    //Gets
    gettime(ServerHour, ServerMinute, ServerSecond);
    getdate(Year, Month, Day);

    //TextDraw Clock
    TextDrawSetFormat(XTextdrawHour, "%02d", ServerHour);
    TextDrawSetFormat(TextdrawMinute, ":%02d", ServerMinute);
    TextDrawSetFormat(TextdrawSeconds, ":%02d", ServerSecond);
    //TextDraw Clock
    TextDrawSetFormat(XTextdrawHourEx, "%02d", ServerHour);
    TextDrawSetFormat(TextdrawMinuteEx, ":%02d", ServerMinute);
    TextDrawSetFormat(TextdrawSecondsEx, ":%02d", ServerSecond);
    for (new i = 0; i < GetMaxPlayers(); i++) { SetPlayerTime(i, ServerHour, ServerMinute); }

    //TextDraw Day
    TextDrawSetFormat(TextdrawDay, "%02d", Day);
    TextDrawSetFormat(TextdrawDayEx, "%02d", Day);

    // respawn vehicles
    if ((ServerHour == 12 || ServerHour == 0) && ServerMinute == 0 && ServerSecond == 1) {
        respawnunoccupiedvehicle();
    }

    // global call every 1 am
    if (ServerHour == 1 && ServerMinute == 1 && ServerSecond == 1) {
        CallRemoteFunction("GlobalOneAmInterval", "");
    }

    //Weather Changer
    //When a new hour starts. The one second is to prevent a bug.
    if (ServerMinute == 0 && ServerSecond == 1) {
        new string[128];
        format(string, sizeof(string), "{4286f4}[Alexa]: {FFFF00}It's %02d o' clock. The weather is changed.", ServerHour);
        SendClientMessageToAll(YELLOW, string);

        CallRemoteFunction("GlobalHourInterval", "");

        switch (Month) {
            case 1 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" January %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" January %d", Year));
                SetWeather(WinterWeather[winterrand]);
            }
            case 2 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" February %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" February %d", Year));
                SetWeather(WinterWeather[winterrand]);
            }
            case 3 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" March %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" March %d", Year));
                if (Day < 21) { SetWeather(WinterWeather[winterrand]); } else { SetWeather(SpringWeather[springrand]); }
            }
            case 4 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" April %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" April %d", Year));
                SetWeather(SpringWeather[springrand]);
            }
            case 5 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" May %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" May %d", Year));
                SetWeather(SpringWeather[springrand]);
            }
            case 6 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" June %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" June %d", Year));
                if (Day < 21) { SetWeather(SpringWeather[springrand]); } else { SetWeather(SummerWeather[summerrand]); }
            }
            case 7 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" July %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" July %d", Year));
                SetWeather(SummerWeather[summerrand]);
            }
            case 8 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" August %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" August %d", Year));
                SetWeather(SummerWeather[summerrand]);
            }
            case 9 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" September %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" September %d", Year));
                if (Day < 21) { SetWeather(SummerWeather[summerrand]); } else { SetWeather(AutumnWeather[autumnrand]); }
            }
            case 10 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" October %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" October %d", Year));
                SetWeather(AutumnWeather[autumnrand]);
            }
            case 11 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" November %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" November %d", Year));
                SetWeather(AutumnWeather[autumnrand]);
            }
            case 12 :  {
                TextDrawSetString(TextdrawMonth, sprintf(" December %d", Year));
                TextDrawSetString(TextdrawMonthEx, sprintf(" December %d", Year));
                if (Day < 21) { SetWeather(AutumnWeather[autumnrand]); } else { SetWeather(WinterWeather[winterrand]); }
            }
        }
        if (ServerHour == 22) { SetWorldTime(22); } else { SetWorldTime(ServerHour); }
    }
    return 1;
}

stock CreateHPTL() {
    //Hours
    XTextdrawHour = TextDrawCreate(580.000000, 20.000000, "--");
    TextDrawAlignment(XTextdrawHour, 0);
    TextDrawBackgroundColor(XTextdrawHour, BLACK);
    TextDrawFont(XTextdrawHour, 3);
    TextDrawLetterSize(XTextdrawHour, 0.4, 1.5);
    TextDrawColor(XTextdrawHour, WHITE);
    TextDrawSetOutline(XTextdrawHour, 1);
    TextDrawSetProportional(XTextdrawHour, 1);
    TextDrawSetShadow(XTextdrawHour, 1);

    //Minutes
    TextdrawMinute = TextDrawCreate(595.000000, 20.000000, "--");
    TextDrawAlignment(TextdrawMinute, 0);
    TextDrawBackgroundColor(TextdrawMinute, BLACK);
    TextDrawFont(TextdrawMinute, 3);
    TextDrawLetterSize(TextdrawMinute, 0.4, 1.5);
    TextDrawColor(TextdrawMinute, WHITE);
    TextDrawSetOutline(TextdrawMinute, 1);
    TextDrawSetProportional(TextdrawMinute, 1);
    TextDrawSetShadow(TextdrawMinute, 1);

    //Seconds
    TextdrawSeconds = TextDrawCreate(620.000000, 23.500000, "--");
    TextDrawAlignment(TextdrawSeconds, 0);
    TextDrawBackgroundColor(TextdrawSeconds, BLACK);
    TextDrawFont(TextdrawSeconds, 3);
    TextDrawLetterSize(TextdrawSeconds, 0.2, 1.0);
    TextDrawColor(TextdrawSeconds, WHITE);
    TextDrawSetOutline(TextdrawSeconds, 1);
    TextDrawSetProportional(TextdrawSeconds, 1);
    TextDrawSetShadow(TextdrawSeconds, 1);

    //Day
    TextdrawDay = TextDrawCreate(550.000000, 8.000000, "--");
    TextDrawAlignment(TextdrawDay, 0);
    TextDrawBackgroundColor(TextdrawDay, BLACK);
    TextDrawFont(TextdrawDay, 3);
    TextDrawLetterSize(TextdrawDay, 0.3, 1.0);
    TextDrawColor(TextdrawDay, WHITE);
    TextDrawSetOutline(TextdrawDay, 1);
    TextDrawSetProportional(TextdrawDay, 1);
    TextDrawSetShadow(TextdrawDay, 1);

    //Month
    TextdrawMonth = TextDrawCreate(560.000000, 8.000000, "---------");
    TextDrawAlignment(TextdrawMonth, 0);
    TextDrawBackgroundColor(TextdrawMonth, BLACK);
    TextDrawFont(TextdrawMonth, 3);
    TextDrawLetterSize(TextdrawMonth, 0.3, 1.0);
    TextDrawColor(TextdrawMonth, WHITE);
    TextDrawSetOutline(TextdrawMonth, 1);
    TextDrawSetProportional(TextdrawMonth, 1);
    TextDrawSetShadow(TextdrawMonth, 1);
    //ServerTag
    ServerTag = TextDrawCreate(255.000000, 430.000000, "~r~~h~~h~INDIAN ~w~OC~b~~h~~h~E~w~AN ~g~~h~~h~ROLEPLAY");
    TextDrawFont(ServerTag, 2);
    TextDrawLetterSize(ServerTag, 0.283333, 1.600000);
    TextDrawTextSize(ServerTag, 500.000000, 17.000000);
    TextDrawSetOutline(ServerTag, 1);
    TextDrawSetShadow(ServerTag, 1);
    TextDrawAlignment(ServerTag, 1);
    TextDrawBackgroundColor(ServerTag, 255);
    TextDrawBoxColor(ServerTag, 50);
    TextDrawUseBox(ServerTag, 0);
    TextDrawSetProportional(ServerTag, 1);
    TextDrawSetSelectable(ServerTag, 0);
    TextDrawShowForAll(ServerTag);

    //Hours
    XTextdrawHourEx = TextDrawCreate(550.000000, 20.000000, "--");
    TextDrawAlignment(XTextdrawHourEx, 0);
    TextDrawBackgroundColor(XTextdrawHourEx, BLACK);
    TextDrawFont(XTextdrawHourEx, 3);
    TextDrawLetterSize(XTextdrawHourEx, 0.4, 1.5);
    TextDrawColor(XTextdrawHourEx, WHITE);
    TextDrawSetOutline(XTextdrawHourEx, 1);
    TextDrawSetProportional(XTextdrawHourEx, 1);
    TextDrawSetShadow(XTextdrawHourEx, 1);

    //Minutes
    TextdrawMinuteEx = TextDrawCreate(565.000000, 20.000000, "--");
    TextDrawAlignment(TextdrawMinuteEx, 0);
    TextDrawBackgroundColor(TextdrawMinuteEx, BLACK);
    TextDrawFont(TextdrawMinuteEx, 3);
    TextDrawLetterSize(TextdrawMinuteEx, 0.4, 1.5);
    TextDrawColor(TextdrawMinuteEx, WHITE);
    TextDrawSetOutline(TextdrawMinuteEx, 1);
    TextDrawSetProportional(TextdrawMinuteEx, 1);
    TextDrawSetShadow(TextdrawMinuteEx, 1);

    //Seconds
    TextdrawSecondsEx = TextDrawCreate(590.000000, 23.500000, "--");
    TextDrawAlignment(TextdrawSecondsEx, 0);
    TextDrawBackgroundColor(TextdrawSecondsEx, BLACK);
    TextDrawFont(TextdrawSecondsEx, 3);
    TextDrawLetterSize(TextdrawSecondsEx, 0.2, 1.0);
    TextDrawColor(TextdrawSecondsEx, WHITE);
    TextDrawSetOutline(TextdrawSecondsEx, 1);
    TextDrawSetProportional(TextdrawSecondsEx, 1);
    TextDrawSetShadow(TextdrawSecondsEx, 1);

    //Day
    TextdrawDayEx = TextDrawCreate(500.000000, 8.000000, "--");
    TextDrawAlignment(TextdrawDayEx, 0);
    TextDrawBackgroundColor(TextdrawDayEx, BLACK);
    TextDrawFont(TextdrawDayEx, 3);
    TextDrawLetterSize(TextdrawDayEx, 0.3, 1.0);
    TextDrawColor(TextdrawDayEx, WHITE);
    TextDrawSetOutline(TextdrawDayEx, 1);
    TextDrawSetProportional(TextdrawDayEx, 1);
    TextDrawSetShadow(TextdrawDayEx, 1);

    //Month
    TextdrawMonthEx = TextDrawCreate(510.000000, 8.000000, "---------");
    TextDrawAlignment(TextdrawMonthEx, 0);
    TextDrawBackgroundColor(TextdrawMonthEx, BLACK);
    TextDrawFont(TextdrawMonthEx, 3);
    TextDrawLetterSize(TextdrawMonthEx, 0.3, 1.0);
    TextDrawColor(TextdrawMonthEx, WHITE);
    TextDrawSetOutline(TextdrawMonthEx, 1);
    TextDrawSetProportional(TextdrawMonthEx, 1);
    TextDrawSetShadow(TextdrawMonthEx, 1);
    //ServerTag
    ServerTagEx = TextDrawCreate(255.000000, 430.000000, "~r~~h~~h~INDIAN ~w~OC~b~~h~~h~E~w~AN ~g~~h~~h~ROLEPLAY");
    TextDrawFont(ServerTagEx, 2);
    TextDrawLetterSize(ServerTagEx, 0.283333, 1.600000);
    TextDrawTextSize(ServerTagEx, 500.000000, 17.000000);
    TextDrawSetOutline(ServerTagEx, 1);
    TextDrawSetShadow(ServerTagEx, 1);
    TextDrawAlignment(ServerTagEx, 1);
    TextDrawBackgroundColor(ServerTagEx, 255);
    TextDrawBoxColor(ServerTagEx, 50);
    TextDrawUseBox(ServerTagEx, 0);
    TextDrawSetProportional(ServerTagEx, 1);
    TextDrawSetSelectable(ServerTagEx, 0);
    TextDrawShowForAll(ServerTagEx);
    return 1;
}

stock HideHPTL(playerid) {
    TextDrawHideForPlayer(playerid, XTextdrawHour);
    TextDrawHideForPlayer(playerid, TextdrawMinute);
    TextDrawHideForPlayer(playerid, TextdrawSeconds);
    TextDrawHideForPlayer(playerid, TextdrawDay);
    TextDrawHideForPlayer(playerid, TextdrawMonth);
    TextDrawHideForPlayer(playerid, ServerTag);
    TextDrawHideForPlayer(playerid, XTextdrawHourEx);
    TextDrawHideForPlayer(playerid, TextdrawMinuteEx);
    TextDrawHideForPlayer(playerid, TextdrawSecondsEx);
    TextDrawHideForPlayer(playerid, TextdrawDayEx);
    TextDrawHideForPlayer(playerid, TextdrawMonthEx);
    TextDrawHideForPlayer(playerid, ServerTagEx);
    return 1;
}

stock ShowHPTL(playerid) {
    if (Patch:GetHudStatus(playerid)) {
        TextDrawShowForPlayer(playerid, XTextdrawHour);
        TextDrawShowForPlayer(playerid, TextdrawMinute);
        TextDrawShowForPlayer(playerid, TextdrawSeconds);
        TextDrawShowForPlayer(playerid, TextdrawDay);
        TextDrawShowForPlayer(playerid, TextdrawMonth);
        TextDrawShowForPlayer(playerid, ServerTag);
    } else {
        TextDrawShowForPlayer(playerid, XTextdrawHourEx);
        TextDrawShowForPlayer(playerid, TextdrawMinuteEx);
        TextDrawShowForPlayer(playerid, TextdrawSecondsEx);
        TextDrawShowForPlayer(playerid, TextdrawDayEx);
        TextDrawShowForPlayer(playerid, TextdrawMonthEx);
        TextDrawShowForPlayer(playerid, ServerTagEx);
    }
    return 1;
}

stock DestroyHPTL() {
    TextDrawDestroy(XTextdrawHour);
    TextDrawDestroy(TextdrawMinute);
    TextDrawDestroy(TextdrawSeconds);
    TextDrawDestroy(TextdrawDay);
    TextDrawDestroy(TextdrawMonth);
    TextDrawDestroy(ServerTag);
    TextDrawDestroy(XTextdrawHourEx);
    TextDrawDestroy(TextdrawMinuteEx);
    TextDrawDestroy(TextdrawSecondsEx);
    TextDrawDestroy(TextdrawDayEx);
    TextDrawDestroy(TextdrawMonthEx);
    TextDrawDestroy(ServerTagEx);
    return 1;
}


hook OnPatchStatusUpdate_Hud(playerid) {
    HideHPTL(playerid);
    ShowHPTL(playerid);
    return 1;
}

hook OnGameModeInit() {
    new Year, Month, Day;
    new ServerHour, ServerMinute, ServerSecond;
    new summerrand = random(sizeof(SummerWeather));
    new winterrand = random(sizeof(WinterWeather));
    new springrand = random(sizeof(SpringWeather));
    new autumnrand = random(sizeof(AutumnWeather));
    getdate(Year, Month, Day);
    gettime(ServerHour, ServerMinute, ServerSecond);
    CreateHPTL();
    switch (Month) {
        case 1 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" January %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" January %d", Year));
            SetWeather(WinterWeather[winterrand]);
        }
        case 2 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" February %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" February %d", Year));
            SetWeather(WinterWeather[winterrand]);
        }
        case 3 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" March %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" March %d", Year));
            if (Day < 21) { SetWeather(WinterWeather[winterrand]); } else { SetWeather(SpringWeather[springrand]); }
        }
        case 4 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" April %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" April %d", Year));
            SetWeather(SpringWeather[springrand]);
        }
        case 5 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" May %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" May %d", Year));
            SetWeather(SpringWeather[springrand]);
        }
        case 6 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" June %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" June %d", Year));
            if (Day < 21) { SetWeather(SpringWeather[springrand]); } else { SetWeather(SummerWeather[summerrand]); }
        }
        case 7 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" July %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" July %d", Year));
            SetWeather(SummerWeather[summerrand]);
        }
        case 8 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" August %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" August %d", Year));
            SetWeather(SummerWeather[summerrand]);
        }
        case 9 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" September %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" September %d", Year));
            if (Day < 21) { SetWeather(SummerWeather[summerrand]); } else { SetWeather(AutumnWeather[autumnrand]); }
        }
        case 10 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" October %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" October %d", Year));
            SetWeather(AutumnWeather[autumnrand]);
        }
        case 11 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" November %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" November %d", Year));
            SetWeather(AutumnWeather[autumnrand]);
        }
        case 12 :  {
            TextDrawSetString(TextdrawMonth, sprintf(" December %d", Year));
            TextDrawSetString(TextdrawMonthEx, sprintf(" December %d", Year));
            if (Day < 21) { SetWeather(AutumnWeather[autumnrand]); } else { SetWeather(WinterWeather[winterrand]); }
        }
    }
    if (ServerHour == 22) { SetWorldTime(22); } //Can't be different. I don't know why, but otherwise you get a atomic bomb weather.
    else { SetWorldTime(ServerHour); }
    return 1;
}

hook OnPlayerConnect(playerid) {
    if (IsPlayerNPC(playerid)) return 1;
    HideHPTL(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    HideHPTL(playerid);
    return 1;
}

hook OnPlayerRequestClass(playerid, classid) {
    if (IsPlayerNPC(playerid)) return 1;
    HideHPTL(playerid);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    ShowHPTL(playerid);
    return 1;
}

hook OnGameModeExit() {
    DestroyHPTL();
    return 1;
}