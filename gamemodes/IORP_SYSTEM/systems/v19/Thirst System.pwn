#define ThirstCode 0
#define HungerCode 1
#define HygieneCode 2
#define SleepCode 3
#define BladderCode 4

#define ThirstMaxCount 12*60
#define HygieneMaxCount 12*60
#define BladderMaxCount 12*60

enum Motive:PlayerDataEnum {
    sleep_count,
    awake_count,
    ThirstCount,
    HygieneCount,
    BladderCount,

    bool:motivegui,
    login_time,
    bool:awake_mode,
    bool:freezedForBath,
    bool:freezedForPee,
    PlayerText:ths_textdraw[6],
    PlayerBar:ths_playerbar[6]
};
new Motive:PlayerData[MAX_PLAYERS][Motive:PlayerDataEnum];

new i18n_hunger_warn, Disease_Thrist, Disease_Skin, Disease_Bladder, Disease_Sleep, Disease_Hunger;
new operation:Thrist, operation:Hunger, operation:Hygiene, operation:Sleep, operation:Bladder;

hook OnGameModeInit() {
    operation:Thrist = operation:addnew("Thrist Disorder", 5, 2000);
    operation:Hunger = operation:addnew("Hunger Disorder", 5, 2000);
    operation:Hygiene = operation:addnew("Hygiene Disorder", 5, 2000);
    operation:Sleep = operation:addnew("Sleep Disorder", 5, 2000);
    operation:Bladder = operation:addnew("Bladder Disorder", 5, 2000);
    Disease_Thrist = Disease:Add("Diabetes", 5 * 60);
    Disease_Skin = Disease:Add("Urinary Incontinence", 5 * 60);
    Disease_Hunger = Disease:Add("Digestive Disorder", 5 * 60);
    Disease_Bladder = Disease:Add("Skin Rash", 5 * 60);
    Disease_Sleep = Disease:Add("Sleep Disorder", 5 * 60);
    Database:AddColumn("playerdata", "sleeped_on", "int", "0");
    Database:AddColumn("playerdata", "awake", "int", "0");
    Database:AddColumn("playerdata", "sleep", "int", "0");
    Database:AddColumn("playerdata", "ThirstLastTime", "int", "0");
    Database:AddColumn("playerdata", "HygieneLastTime", "int", "0");
    Database:AddColumn("playerdata", "BladderLastTime", "int", "0");
    Database:AddColumn("playerdata", "awake_mode", "boolean", "1");
    Database:AddColumn("playerdata", "Disease_Skin", "boolean", "0");
    Database:AddColumn("playerdata", "Disease_Bladder", "boolean", "0");
    Database:AddColumn("playerdata", "Disease_Thrist", "boolean", "0");
    Database:AddColumn("playerdata", "Disease_Sleep", "boolean", "0");
    Database:AddColumn("playerdata", "Disease_Hunger", "boolean", "0");

    i18n_hunger_warn = I18N_Register("{4286f4}[Alexa]:{FFFFFF} you are hungry, get some food");
    I18N_SetNativeText(i18n_hunger_warn, NATIVE_LANGUAGE_MALAYALAM, "{4286f4}[Alexa]:{FFFFFF} നിങ്ങൾക്ക് വിശക്കുന്നു, ഭക്ഷണം കഴിക്കൂ");
    I18N_SetNativeText(i18n_hunger_warn, NATIVE_LANGUAGE_TELUGU, "{4286f4}[Alexa]:{FFFFFF} మీరు ఆకలితో ఉన్నారు, కొంచెం ఆహారం తీసుకోండి");
    return 1;
}

hook OnPlayerLogin(playerid) {
    Motive:PlayerData[playerid][awake_count] = Database:GetInt(GetPlayerNameEx(playerid), "username", "awake");
    Motive:PlayerData[playerid][sleep_count] = Database:GetInt(GetPlayerNameEx(playerid), "username", "sleep");
    Motive:PlayerData[playerid][awake_mode] = Database:GetBool(GetPlayerNameEx(playerid), "username", "awake_mode");
    new time = Database:GetInt(GetPlayerNameEx(playerid), "username", "sleeped_on");
    new minsSleeped = floatround((gettime() - time) / 60);
    if (Motive:PlayerData[playerid][awake_mode] == false && minsSleeped > 0) {
        if (Motive:PlayerData[playerid][awake_count] > Motive:PlayerData[playerid][sleep_count]) {
            Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][sleep_count] + minsSleeped;
            if (Motive:PlayerData[playerid][sleep_count] > Motive:PlayerData[playerid][awake_count]) Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][awake_count];
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFFF} your sleep motive has been updated, when you were off");
        }
    }
    Motive:PlayerData[playerid][awake_mode] = true;
    Motive:PlayerData[playerid][login_time] = gettime();
    Motive:PlayerData[playerid][freezedForBath] = false;
    Motive:PlayerData[playerid][freezedForPee] = false;
    Motive:PlayerData[playerid][ThirstCount] = Database:GetInt(GetPlayerNameEx(playerid), "username", "ThirstLastTime");
    Motive:PlayerData[playerid][HygieneCount] = Database:GetInt(GetPlayerNameEx(playerid), "username", "HygieneLastTime");
    Motive:PlayerData[playerid][BladderCount] = Database:GetInt(GetPlayerNameEx(playerid), "username", "BladderLastTime");

    if (Motive:PlayerData[playerid][ThirstCount] > ThirstMaxCount) Motive:PlayerData[playerid][ThirstCount] = ThirstMaxCount;
    if (Motive:PlayerData[playerid][HygieneCount] > HygieneMaxCount) Motive:PlayerData[playerid][HygieneCount] = HygieneMaxCount;
    if (Motive:PlayerData[playerid][BladderCount] > BladderMaxCount) Motive:PlayerData[playerid][BladderCount] = BladderMaxCount;

    Disease:SetPlayerState(playerid, Disease_Skin, Database:GetBool(GetPlayerNameEx(playerid), "username", "Disease_Skin"));
    Disease:SetPlayerState(playerid, Disease_Bladder, Database:GetBool(GetPlayerNameEx(playerid), "username", "Disease_Bladder"));
    Disease:SetPlayerState(playerid, Disease_Thrist, Database:GetBool(GetPlayerNameEx(playerid), "username", "Disease_Thrist"));
    Disease:SetPlayerState(playerid, Disease_Sleep, Database:GetBool(GetPlayerNameEx(playerid), "username", "Disease_Sleep"));
    Disease:SetPlayerState(playerid, Disease_Hunger, Database:GetBool(GetPlayerNameEx(playerid), "username", "Disease_Hunger"));

    Motive:PlayerData[playerid][ths_playerbar][0] = CreatePlayerProgressBar(playerid, 500.00, 125.00);
    Motive:PlayerData[playerid][ths_playerbar][1] = CreatePlayerProgressBar(playerid, 560.00, 125.00);
    Motive:PlayerData[playerid][ths_playerbar][2] = CreatePlayerProgressBar(playerid, 500.00, 135.00);
    Motive:PlayerData[playerid][ths_playerbar][3] = CreatePlayerProgressBar(playerid, 560.00, 135.00);
    Motive:PlayerData[playerid][ths_playerbar][4] = CreatePlayerProgressBar(playerid, 560.00, 145.00);
    UpdateMotiveBar(playerid);

    Motive:PlayerData[playerid][ths_textdraw][0] = CreatePlayerTextDraw(playerid, 525.000000, 125.000000, "Thrist");
    PlayerTextDrawColor(playerid, Motive:PlayerData[playerid][ths_textdraw][0], -1);
    PlayerTextDrawUseBox(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0);
    PlayerTextDrawBoxColor(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 255);
    PlayerTextDrawBackgroundColor(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 255);
    PlayerTextDrawAlignment(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 2);
    PlayerTextDrawFont(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 2);
    PlayerTextDrawLetterSize(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0.100000, 0.400000);
    PlayerTextDrawTextSize(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0.000000, 0.000000);
    PlayerTextDrawSetOutline(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0);
    PlayerTextDrawSetShadow(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0);
    PlayerTextDrawSetProportional(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 1);
    PlayerTextDrawSetSelectable(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0);
    PlayerTextDrawSetPreviewModel(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 400);
    PlayerTextDrawSetPreviewRot(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, Motive:PlayerData[playerid][ths_textdraw][0], 0, 0);

    Motive:PlayerData[playerid][ths_textdraw][1] = CreatePlayerTextDraw(playerid, 580.000000, 125.000000, "HUNGER");
    PlayerTextDrawColor(playerid, Motive:PlayerData[playerid][ths_textdraw][1], -1);
    PlayerTextDrawUseBox(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0);
    PlayerTextDrawBoxColor(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 255);
    PlayerTextDrawBackgroundColor(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 255);
    PlayerTextDrawAlignment(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0);
    PlayerTextDrawFont(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 1);
    PlayerTextDrawLetterSize(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0.100000, 0.400000);
    PlayerTextDrawTextSize(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 2.000000, 3.599999);
    PlayerTextDrawSetOutline(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0);
    PlayerTextDrawSetShadow(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0);
    PlayerTextDrawSetProportional(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 1);
    PlayerTextDrawSetSelectable(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 400);
    PlayerTextDrawSetPreviewRot(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, Motive:PlayerData[playerid][ths_textdraw][1], 0, 0);

    Motive:PlayerData[playerid][ths_textdraw][2] = CreatePlayerTextDraw(playerid, 518.000000, 135.000000, "HYGIENE");
    PlayerTextDrawColor(playerid, Motive:PlayerData[playerid][ths_textdraw][2], -1);
    PlayerTextDrawUseBox(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0);
    PlayerTextDrawBoxColor(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 255);
    PlayerTextDrawBackgroundColor(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 255);
    PlayerTextDrawAlignment(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0);
    PlayerTextDrawFont(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 1);
    PlayerTextDrawLetterSize(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0.100000, 0.400000);
    PlayerTextDrawTextSize(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 2.000000, 3.599999);
    PlayerTextDrawSetOutline(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0);
    PlayerTextDrawSetShadow(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0);
    PlayerTextDrawSetProportional(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 1);
    PlayerTextDrawSetSelectable(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 400);
    PlayerTextDrawSetPreviewRot(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, Motive:PlayerData[playerid][ths_textdraw][2], 0, 0);

    Motive:PlayerData[playerid][ths_textdraw][3] = CreatePlayerTextDraw(playerid, 582.000000, 135.000000, "SLEEP");
    PlayerTextDrawColor(playerid, Motive:PlayerData[playerid][ths_textdraw][3], -1);
    PlayerTextDrawUseBox(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0);
    PlayerTextDrawBoxColor(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 255);
    PlayerTextDrawBackgroundColor(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 255);
    PlayerTextDrawAlignment(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0);
    PlayerTextDrawFont(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 1);
    PlayerTextDrawLetterSize(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0.100000, 0.400000);
    PlayerTextDrawTextSize(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 2.000000, 3.599999);
    PlayerTextDrawSetOutline(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0);
    PlayerTextDrawSetShadow(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0);
    PlayerTextDrawSetProportional(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 1);
    PlayerTextDrawSetSelectable(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0);
    PlayerTextDrawSetPreviewModel(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 400);
    PlayerTextDrawSetPreviewRot(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, Motive:PlayerData[playerid][ths_textdraw][3], 0, 0);

    Motive:PlayerData[playerid][ths_textdraw][4] = CreatePlayerTextDraw(playerid, 580.000000, 145.000000, "BLADDER");
    PlayerTextDrawColor(playerid, Motive:PlayerData[playerid][ths_textdraw][4], -1);
    PlayerTextDrawUseBox(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0);
    PlayerTextDrawBoxColor(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 255);
    PlayerTextDrawBackgroundColor(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 255);
    PlayerTextDrawAlignment(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0);
    PlayerTextDrawFont(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 1);
    PlayerTextDrawLetterSize(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0.100000, 0.400000);
    PlayerTextDrawTextSize(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 2.000000, 3.599999);
    PlayerTextDrawSetOutline(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0);
    PlayerTextDrawSetShadow(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0);
    PlayerTextDrawSetProportional(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 1);
    PlayerTextDrawSetSelectable(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0);
    PlayerTextDrawSetPreviewModel(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 400);
    PlayerTextDrawSetPreviewRot(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, Motive:PlayerData[playerid][ths_textdraw][4], 0, 0);

    ShowMotives(playerid);
    return 1;
}

stock UpdateMotiveBar(playerid) {
    new prcThirstCode = GetNeedStatePercent(playerid, ThirstCode);
    new prcHungerCode = GetNeedStatePercent(playerid, HungerCode);
    new prcHygieneCode = GetNeedStatePercent(playerid, HygieneCode);
    new prcSleepCode = GetNeedStatePercent(playerid, SleepCode);
    new prcBladderCode = GetNeedStatePercent(playerid, BladderCode);
    SetPlayerProgressBarColour(playerid, Motive:PlayerData[playerid][ths_playerbar][0], GetNeedColor(ThirstCode, prcThirstCode));
    SetPlayerProgressBarColour(playerid, Motive:PlayerData[playerid][ths_playerbar][1], GetNeedColor(HungerCode, prcHungerCode));
    SetPlayerProgressBarColour(playerid, Motive:PlayerData[playerid][ths_playerbar][2], GetNeedColor(HygieneCode, prcHygieneCode));
    SetPlayerProgressBarColour(playerid, Motive:PlayerData[playerid][ths_playerbar][3], GetNeedColor(SleepCode, prcSleepCode));
    SetPlayerProgressBarColour(playerid, Motive:PlayerData[playerid][ths_playerbar][4], GetNeedColor(BladderCode, prcBladderCode));
    SetPlayerProgressBarValue(playerid, Motive:PlayerData[playerid][ths_playerbar][0], float(prcThirstCode));
    SetPlayerProgressBarValue(playerid, Motive:PlayerData[playerid][ths_playerbar][1], float(prcHungerCode));
    SetPlayerProgressBarValue(playerid, Motive:PlayerData[playerid][ths_playerbar][2], float(prcHygieneCode));
    SetPlayerProgressBarValue(playerid, Motive:PlayerData[playerid][ths_playerbar][3], float(prcSleepCode));
    SetPlayerProgressBarValue(playerid, Motive:PlayerData[playerid][ths_playerbar][4], float(prcBladderCode));
    return 1;
}

stock ShowMotives(playerid) {
    ShowPlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][0]);
    ShowPlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][1]);
    ShowPlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][2]);
    ShowPlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][3]);
    ShowPlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][4]);
    PlayerTextDrawShow(playerid, Motive:PlayerData[playerid][ths_textdraw][0]);
    PlayerTextDrawShow(playerid, Motive:PlayerData[playerid][ths_textdraw][1]);
    PlayerTextDrawShow(playerid, Motive:PlayerData[playerid][ths_textdraw][2]);
    PlayerTextDrawShow(playerid, Motive:PlayerData[playerid][ths_textdraw][3]);
    PlayerTextDrawShow(playerid, Motive:PlayerData[playerid][ths_textdraw][4]);
    Motive:PlayerData[playerid][motivegui] = true;
    return 1;
}

stock HideMotives(playerid) {
    HidePlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][0]);
    HidePlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][1]);
    HidePlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][2]);
    HidePlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][3]);
    HidePlayerProgressBar(playerid, Motive:PlayerData[playerid][ths_playerbar][4]);
    PlayerTextDrawHide(playerid, Motive:PlayerData[playerid][ths_textdraw][0]);
    PlayerTextDrawHide(playerid, Motive:PlayerData[playerid][ths_textdraw][1]);
    PlayerTextDrawHide(playerid, Motive:PlayerData[playerid][ths_textdraw][2]);
    PlayerTextDrawHide(playerid, Motive:PlayerData[playerid][ths_textdraw][3]);
    PlayerTextDrawHide(playerid, Motive:PlayerData[playerid][ths_textdraw][4]);
    Motive:PlayerData[playerid][motivegui] = false;
    return 1;
}

hook OnPlayerUpdateEx(playerid) {
    if (!IsTimePassedForPlayer(playerid, "HungerReduceHealth", 120) || IsPlayerPaused(playerid)) return 1;
    if (GetPlayerHealthEx(playerid) > 5) SetPlayerHealthEx(playerid, GetPlayerHealthEx(playerid) - 1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (IsPlayerNPC(playerid)) return 1;
    if (!IsPlayerLoggedIn(playerid)) return 1;
    PlayerTextDrawDestroy(playerid, Motive:PlayerData[playerid][ths_textdraw][0]);
    PlayerTextDrawDestroy(playerid, Motive:PlayerData[playerid][ths_textdraw][1]);
    PlayerTextDrawDestroy(playerid, Motive:PlayerData[playerid][ths_textdraw][2]);
    PlayerTextDrawDestroy(playerid, Motive:PlayerData[playerid][ths_textdraw][3]);
    PlayerTextDrawDestroy(playerid, Motive:PlayerData[playerid][ths_textdraw][4]);
    Database:UpdateInt(Motive:PlayerData[playerid][awake_count], GetPlayerNameEx(playerid), "username", "awake");
    Database:UpdateInt(Motive:PlayerData[playerid][sleep_count], GetPlayerNameEx(playerid), "username", "sleep");
    Database:UpdateInt(Motive:PlayerData[playerid][ThirstCount], GetPlayerNameEx(playerid), "username", "ThirstLastTime");
    Database:UpdateInt(Motive:PlayerData[playerid][BladderCount], GetPlayerNameEx(playerid), "username", "BladderLastTime");
    Database:UpdateInt(Motive:PlayerData[playerid][HygieneCount], GetPlayerNameEx(playerid), "username", "HygieneLastTime");
    Database:UpdateBool(Disease:GetPlayerState(playerid, Disease_Skin) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "Disease_Skin");
    Database:UpdateBool(Disease:GetPlayerState(playerid, Disease_Bladder) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "Disease_Bladder");
    Database:UpdateBool(Disease:GetPlayerState(playerid, Disease_Thrist) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "Disease_Thrist");
    Database:UpdateBool(Disease:GetPlayerState(playerid, Disease_Sleep) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "Disease_Sleep");
    Database:UpdateBool(Disease:GetPlayerState(playerid, Disease_Hunger) == 1 ? true : false, GetPlayerNameEx(playerid), "username", "Disease_Hunger");
    Database:UpdateBool(Motive:PlayerData[playerid][awake_mode], GetPlayerNameEx(playerid), "username", "awake_mode");
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "sleeped_on");
    return 1;
}

stock IsPlayerAwaken(playerid) {
    return Motive:PlayerData[playerid][awake_mode];
}

stock GetPlayerAwakeTime(playerid) {
    return Motive:PlayerData[playerid][awake_count];
}

stock GetPlayerSleepTime(playerid) {
    return Motive:PlayerData[playerid][sleep_count];
}

hook GlobalOneMinuteInterval() {
    foreach(new playerid:Player) {
        if (IsPlayerPaused(playerid) || !IsPlayerLoggedIn(playerid) || Event:IsInEvent(playerid)) continue;
        new bool:time_passed = IsTimePassedForPlayer(playerid, "last_health_warn", 3 * 60);
        if (time_passed && GetNeedStatePercent(playerid, ThirstCode) < 20) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are thirsty, drink water asap.");
        if (time_passed && GetNeedStatePercent(playerid, HygieneCode) < 20) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are stinky, take shower asap.");
        if (time_passed && GetNeedStatePercent(playerid, BladderCode) < 20) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you need to pee asap.");
        if (time_passed && GetNeedStatePercent(playerid, SleepCode) < 20) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you are sleepy, goto bed asap.");
        if (Motive:PlayerData[playerid][ThirstCount] < ThirstMaxCount) Motive:PlayerData[playerid][ThirstCount]++;
        if (Motive:PlayerData[playerid][HygieneCount] < HygieneMaxCount) Motive:PlayerData[playerid][HygieneCount]++;
        if (Motive:PlayerData[playerid][BladderCount] < BladderMaxCount) Motive:PlayerData[playerid][BladderCount]++;
        UpdateMotiveBar(playerid);
        if (Motive:PlayerData[playerid][awake_mode]) Motive:PlayerData[playerid][awake_count]++;
        else {
            if (GetPlayerVIPLevel(playerid) > 0) Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][sleep_count] + 30;
            else Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][sleep_count] + 15;
            if (Motive:PlayerData[playerid][awake_count] > Motive:PlayerData[playerid][sleep_count]) {
                new leftMin = Motive:PlayerData[playerid][awake_count] - Motive:PlayerData[playerid][sleep_count];
                if (leftMin < 60) GameTextForPlayer(playerid, sprintf("~r~Sleep Left: ~w~%d Minute", leftMin), 5000, 3);
                else GameTextForPlayer(playerid, sprintf("~r~Sleep Left: ~w~%02d Hour", leftMin / 60), 5000, 3);
            }
        }
        if (GetPlayerHealthEx(playerid) < 20) {
            if (time_passed) SendClientMessage(playerid, -1, GetNativeText(i18n_hunger_warn, GetPlayerNativeLang(playerid)));
        }
        if (Motive:PlayerData[playerid][awake_count] >= Motive:PlayerData[playerid][sleep_count] && Motive:PlayerData[playerid][awake_mode]) {
            new diff = Motive:PlayerData[playerid][awake_count] - Motive:PlayerData[playerid][sleep_count];
            if (diff > 18 * 60) {
                if (GetPlayerHealthEx(playerid) > 5) SetPlayerHealthEx(playerid, GetPlayerHealthEx(playerid) - 4);
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}your health rapidly decreasing because you need sleep, alexa cmd: sleep mode / awake mode");
            } else if (diff > 16 * 60) {
                if (time_passed) SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}you need sleep, alexa cmd: sleep mode / awake mode");
            }
        } else if (!Motive:PlayerData[playerid][awake_mode]) {
            new diff = Motive:PlayerData[playerid][sleep_count] - Motive:PlayerData[playerid][awake_count];
            if (diff > 10 * 60 && time_passed) {
                Motive:PlayerData[playerid][awake_mode] = true;
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}you can not sleep more, we have awaken you");
            } else if (diff > 8 * 60 && time_passed) {
                SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE}you are going to over sleep, we suggest you should awake now, alexa cmd: sleep mode / awake mode");
            }
        }
    }
    return 1;
}

stock ActivateSleep(playerid) {
    if (!House:IsValidID(House:GetPlayerHouseID(playerid)) && !Hotel:IsPlayerInHotel(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you should be inside a house or hotel to sleep");
        return ~1;
    }
    if (!Motive:PlayerData[playerid][awake_mode]) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you are already sleeping");
        return ~1;
    }
    Motive:PlayerData[playerid][awake_mode] = false;
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you are now sleeping");
    ApplyAnimation(playerid, "CRACK", "crckdeth4", 4, 1, 0, 0, 1, 0, 1);
    Anim:SetState(playerid, true);
    return 1;
}

stock DeactivateSleep(playerid) {
    if (Motive:PlayerData[playerid][awake_mode]) {
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you are already awake");
        return ~1;
    }
    Motive:PlayerData[playerid][awake_mode] = true;
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you are now awaken");
    Anim:Stop(playerid);
    return 1;
}

stock ResetPlayerSleep(playerid) {
    if (!IsValidPlayerID(playerid)) return 1;
    Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][awake_count];
    UpdateMotiveBar(playerid);
    return 1;
}

hook OnAlexaResponse(playerid, const cmd[], const text[]) {
    if (IsStringContainWords(text, "hide motive, hide motives")) {
        HideMotives(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "show motive, show motives")) {
        ShowMotives(playerid);
        return ~1;
    }
    if (IsStringContainWords(text, "sleep mode")) {
        ActivateSleep(playerid);
        return ~1;
    } else if (IsStringContainWords(text, "awake mode")) {
        DeactivateSleep(playerid);
        return ~1;
    }
    //    if (IsStringContainWords(text, "reset sleep") && GetPlayerAdminLevel(playerid) == 10) {
    //        new extraid;
    //        if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
    //        if (!IsPlayerConnected(extraid)) extraid = playerid;
    //        Motive:PlayerData[extraid][sleep_count] = Motive:PlayerData[extraid][awake_count];
    //        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}you have reseted %s sleep time", GetPlayerNameEx(extraid)));
    //        SendClientMessage(extraid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}your sleep time has been reseted by admin %s", GetPlayerNameEx(playerid)));
    //        return ~1;
    //    } else if (IsStringContainWords(text, "reset motive") && GetPlayerAdminLevel(playerid) == 10) {
    //        new extraid;
    //        if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
    //        if (!IsPlayerConnected(extraid)) extraid = playerid;
    //        ResetMotiveStatus(extraid);
    //        ResetMotiveDisease(extraid);
    //        DiseaseStopSymptoms(extraid);
    //        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}you have reseted %s motive states", GetPlayerNameEx(extraid)));
    //        SendClientMessage(extraid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}your player motive has been reseted by admin %s", GetPlayerNameEx(playerid)));
    //        return ~1;
    //    } else if (IsStringContainWords(text, "give motive disease") && GetPlayerAdminLevel(playerid) == 10) {
    //        new extraid;
    //        if (sscanf(GetNextWordFromString(text, "for"), "u", extraid)) extraid = playerid;
    //        if (!IsPlayerConnected(extraid)) extraid = playerid;
    //        GiveMotiveDisease(extraid);
    //        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}you have given motive disease to %s", GetPlayerNameEx(extraid)));
    //        SendClientMessage(extraid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}your player have motive diseases, set by admin %s", GetPlayerNameEx(playerid)));
    //        return ~1;
    //    }
    return 1;
}

hook OnDiseaseStatusCheck() {
    foreach(new playerid:Player) {
        if (GetPlayerScore(playerid) < 5 || Event:IsInEvent(playerid) || gettime() - Motive:PlayerData[playerid][login_time] < 5 * 60) continue;
        if (GetNeedStatePercent(playerid, ThirstCode) <= 0) {
            Disease:SetPlayerState(playerid, Disease_Thrist, true);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You have a thrist disorder, please take medication immediately or seek a doctor.");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Otherwise your health condition becomes serious and can cause serious problems");
        }
        if (GetNeedStatePercent(playerid, HygieneCode) <= 0) {
            Disease:SetPlayerState(playerid, Disease_Skin, true);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You have a skin disorder, please take medication immediately or seek a doctor.");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Otherwise your health condition becomes serious and can cause serious problems");
        }
        if (GetNeedStatePercent(playerid, BladderCode) <= 0) {
            Disease:SetPlayerState(playerid, Disease_Bladder, true);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You have a bladder disorder, please take medication immediately or seek a doctor.");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Otherwise your health condition becomes serious and can cause serious problems");
        }
        if (GetNeedStatePercent(playerid, SleepCode) <= 0) {
            Disease:SetPlayerState(playerid, Disease_Sleep, true);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You have a sleep disorder, please take medication immediately or seek a doctor.");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Otherwise your health condition becomes serious and can cause serious problems");
        }
        if (GetPlayerHealthEx(playerid) < 5) {
            Disease:SetPlayerState(playerid, Disease_Hunger, true);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}You have a digestive disorder, please take medication immediately or seek a doctor.");
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}Otherwise your health condition becomes serious and can cause serious problems");
        }
    }
    return 1;
}

hook OnPurchaseFromShop(playerid, shopid, shopItemId) {
    if (DynamicShopBusiness:GetType(shopid) != Shop_Type_Clinic) return 1;
    new stockCount = DynamicShopBusinessItem:GetShopStock(shopid, shopItemId);
    if (stockCount < 1) { AlexaMsg(playerid, "The store is out of stock, please contact the owner"); return ~1; }
    new price = DynamicShopBusinessItem:GetShopPrice(shopid, shopItemId);
    if (GetPlayerCash(playerid) < price) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough money to purchase this medicine"); return ~1; }
    // if player have backpack then check if backpack is not full
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (Backpack:isValidBackpack(backPackId)) {
        if (shopItemId == 39 && Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist) == InvLimit_Oral_Antihistamines) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough space in your backpack to purchase this medicine");
            return ~1;
        }
        if (shopItemId == 40 && Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL) == InvLimit_Ditropan_XL) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough space in your backpack to purchase this medicine");
            return ~1;
        }
        if (shopItemId == 41 && Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines) == InvLimit_Benzodiazepines) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough space in your backpack to purchase this medicine");
            return ~1;
        }
        if (shopItemId == 42 && Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam) == InvLimit_Temazepam) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough space in your backpack to purchase this medicine");
            return ~1;
        }
        if (shopItemId == 43 && Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub) == InvLimit_Bismuth_Subsalicylate) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you don't have enough space in your backpack to purchase this medicine");
            return ~1;
        }
    }
    // deduct mecine balance from player account
    // for medics, government will pay few percentage
    if (Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) {
        new totalAmount = price;
        new discount = GetPercentageOf(RandomEx(25, 50), totalAmount);
        new pricetopaybyplayer = totalAmount - discount;
        new pricetopaybygovn = discount;
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]: {FFFFEE}Government paid $%s amount on your medicine purchase", FormatCurrency(pricetopaybygovn)));
        GivePlayerCash(playerid, -pricetopaybyplayer, sprintf("Purchased %s medicine from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
        vault:addcash(Vault_ID_Government, -pricetopaybygovn, Vault_Transaction_Vault_To_Cash, sprintf("%s doctor purchased %s medicine from %s [%s] store", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));
    } else GivePlayerCash(playerid, -price, sprintf("Purchased %s medicine from %s [%s] store", DynamicShopBusinessItem:GetItemName(shopItemId), DynamicShopBusiness:GetName(shopid), DynamicShopBusiness:GetOwner(shopid)));

    // increase balance of shop
    DynamicShopBusiness:IncreaseBalance(shopid, price, sprintf("%s purchased medical item: %s", GetPlayerNameEx(playerid), DynamicShopBusinessItem:GetItemName(shopItemId)));
    DynamicShopBusinessItem:UpdateShopStock(shopid, shopItemId, DynamicShopBusinessItem:GetShopStock(shopid, shopItemId) - 1);
    new medicineid = -1;
    if (shopItemId == 39) medicineid = Medice_Oral_antihistamines;
    if (shopItemId == 40) medicineid = Medice_Ditropan_XL;
    if (shopItemId == 41) medicineid = Medice_Benzodiazepines;
    if (shopItemId == 42) medicineid = Medice_Temazepam;
    if (shopItemId == 43) medicineid = Medice_Bismuth_Subsalicylate;
    if (medicineid == -1) return ~1;
    if (Backpack:isValidBackpack(backPackId)) {
        if (shopItemId == 39) Backpack:PushItem(backPackId, MedicineInvID_Oral_Antihist, 1);
        if (shopItemId == 40) Backpack:PushItem(backPackId, MedicineInvID_Ditropan_XL, 1);
        if (shopItemId == 41) Backpack:PushItem(backPackId, MedicineInvID_Benzodiazepines, 1);
        if (shopItemId == 42) Backpack:PushItem(backPackId, MedicineInvID_Temazepam, 1);
        if (shopItemId == 43) Backpack:PushItem(backPackId, MedicineInvID_Bismuth_Sub, 1);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}medicine stored in your backpack.");
    } else CallMedicineTake(playerid, medicineid);
    return ~1;
}

stock CallMedicineTake(playerid, medicineid) {
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you have taken a medicine.");
    CallRemoteFunction("OnPlayerTakeMedicine", "dd", playerid, medicineid);
    return 1;
}

forward OnPlayerTakeMedicine(playerid, medicineid);
public OnPlayerTakeMedicine(playerid, medicineid) {
    if (medicineid == Medice_Oral_antihistamines && Disease:GetPlayerState(playerid, Disease_Skin)) {
        Disease:SetPlayerState(playerid, Disease_Skin, false);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your skin disorder has been treated.");
    }
    if (medicineid == Medice_Ditropan_XL && Disease:GetPlayerState(playerid, Disease_Bladder)) {
        Disease:SetPlayerState(playerid, Disease_Bladder, false);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your bladder disorder has been treated.");
    }
    if (medicineid == Medice_Benzodiazepines && Disease:GetPlayerState(playerid, Disease_Thrist)) {
        Disease:SetPlayerState(playerid, Disease_Thrist, false);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your thrist disorder has been treated.");
    }
    if (medicineid == Medice_Temazepam && Disease:GetPlayerState(playerid, Disease_Sleep)) {
        Disease:SetPlayerState(playerid, Disease_Sleep, false);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your sleep disorder has been treated.");
    }
    if (medicineid == Medice_Bismuth_Subsalicylate && Disease:GetPlayerState(playerid, Disease_Hunger)) {
        Disease:SetPlayerState(playerid, Disease_Hunger, false);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your digestive disorder has been treated.");
    }
    return 1;
}

stock GetNeedStatePercent(playerid, code) {
    if (code == ThirstCode) {
        new diff = Motive:PlayerData[playerid][ThirstCount];
        if (ThirstMaxCount - diff >= ThirstMaxCount) return 100;
        return GetPercentage(ThirstMaxCount - diff, ThirstMaxCount);
    } else if (code == HungerCode) {
        return GetPlayerHealthEx(playerid);
    } else if (code == HygieneCode) {
        new diff = Motive:PlayerData[playerid][HygieneCount];
        if (HygieneMaxCount - diff >= HygieneMaxCount) return 100;
        return GetPercentage(HygieneMaxCount - diff, HygieneMaxCount);
    } else if (code == SleepCode) {
        new maxHours = 24 * 60, diff = Motive:PlayerData[playerid][awake_count] - Motive:PlayerData[playerid][sleep_count];
        // SendClientMessage(playerid, -1, sprintf("awake count: %d, sleep count: %d, maxHours: %d, diff: %d", Motive:PlayerData[playerid][awake_count], Motive:PlayerData[playerid][sleep_count], maxHours, diff));
        if (maxHours - diff >= maxHours) return 100;
        return GetPercentage(maxHours - diff, maxHours);
    } else if (code == BladderCode) {
        new diff = Motive:PlayerData[playerid][BladderCount];
        if (BladderMaxCount - diff >= BladderMaxCount) return 100;
        return GetPercentage(BladderMaxCount - diff, BladderMaxCount);
    }
    return -2;
}

stock GetNeedColor(code, percent) {
    if (code == ThirstCode) {
        if (percent >= 80) return 0x00FF00AA;
        else if (percent >= 40) return 0xFFFF00AA;
        else return 0xFF0000AA;
    } else if (code == HungerCode) {
        if (percent >= 80) return 0x00FF00AA;
        else if (percent >= 40) return 0xFFFF00AA;
        else return 0xFF0000AA;
    } else if (code == HygieneCode) {
        if (percent >= 80) return 0x00FF00AA;
        else if (percent >= 40) return 0xFFFF00AA;
        else return 0xFF0000AA;
    } else if (code == SleepCode) {
        if (percent >= 80) return 0x00FF00AA;
        else if (percent >= 40) return 0xFFFF00AA;
        else return 0xFF0000AA;
    } else if (code == BladderCode) {
        if (percent >= 80) return 0x00FF00AA;
        else if (percent >= 40) return 0xFFFF00AA;
        else return 0xFF0000AA;
    }
    return 0xFF0000AA;
}

stock GetNeedStatePercentWord(code, percent) {
    new string[100];
    format(string, sizeof string, "invalid");
    if (code == ThirstCode) {
        if (percent >= 80) format(string, sizeof string, "{00FF00}Good");
        else if (percent >= 40) format(string, sizeof string, "{FFFF00}Thirsty");
        else format(string, sizeof string, "{FF0000}Very Thirsty");
    } else if (code == HungerCode) {
        if (percent >= 80) format(string, sizeof string, "{00FF00}Good");
        else if (percent >= 40) format(string, sizeof string, "{FFFF00}Hungry");
        else format(string, sizeof string, "{FF0000}Starving");
    } else if (code == HygieneCode) {
        if (percent >= 80) format(string, sizeof string, "{00FF00}Good");
        else if (percent >= 40) format(string, sizeof string, "{FFFF00}Grungry");
        else format(string, sizeof string, "{FF0000}Stinky");
    } else if (code == SleepCode) {
        if (percent >= 80) format(string, sizeof string, "{00FF00}Good");
        else if (percent >= 40) format(string, sizeof string, "{FFFF00}Sleepy");
        else format(string, sizeof string, "{FF0000}Exhausted");
    } else if (code == BladderCode) {
        if (percent >= 80) format(string, sizeof string, "{00FF00}Good");
        else if (percent >= 40) format(string, sizeof string, "{FFFF00}Has to Pee");
        else format(string, sizeof string, "{FF0000}Really Has to Pee");
    }
    return string;
}

// https://sims.fandom.com/wiki/Motive
stock Motive:ViewMotives(playerid) {
    new string[512];
    strcat(string, "Title\tLevel\tDisorder\n");
    strcat(string, sprintf("{FFFFFF}Thirst\t%s\t%s\n", GetNeedStatePercentWord(ThirstCode, GetNeedStatePercent(playerid, ThirstCode)), Disease:GetPlayerState(playerid, Disease_Thrist) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Hunger\t%s\t%s\n", GetNeedStatePercentWord(HungerCode, GetNeedStatePercent(playerid, HungerCode)), Disease:GetPlayerState(playerid, Disease_Hunger) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Hygiene\t%s\t%s\n", GetNeedStatePercentWord(HygieneCode, GetNeedStatePercent(playerid, HygieneCode)), Disease:GetPlayerState(playerid, Disease_Skin) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Sleep\t%s\t%s\n", GetNeedStatePercentWord(SleepCode, GetNeedStatePercent(playerid, SleepCode)), Disease:GetPlayerState(playerid, Disease_Sleep) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Bladder\t%s\t%s\n", GetNeedStatePercentWord(BladderCode, GetNeedStatePercent(playerid, BladderCode)), Disease:GetPlayerState(playerid, Disease_Bladder) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}%s\n", Motive:PlayerData[playerid][motivegui] ? "{FF0000}Hide\tMotive\tGUI" : "{FF0000}Show\tMotive\tGUI"));
    FlexPlayerDialog(
        playerid, "MotiveSelfView", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Your Motives | Health Status: %s", Disease:GetHealthLevel(playerid) == 0 ? "{00FF00}Good" : "{FF0000}Critical"),
        string, "Select", "Close"
    );
    return 1;
}

FlexDialog:MotiveSelfView(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    if (IsStringSame(inputtext, "Show")) return ShowMotives(playerid);
    if (IsStringSame(inputtext, "Hide")) return HideMotives(playerid);
    return 1;
}

stock Motive:SetDiseaseStatus(playerid, motiveid, bool:status) {
    if (motiveid == ThirstCode) Disease:SetPlayerState(playerid, Disease_Thrist, status);
    if (motiveid == HungerCode) Disease:SetPlayerState(playerid, Disease_Hunger, status);
    if (motiveid == HygieneCode) Disease:SetPlayerState(playerid, Disease_Skin, status);
    if (motiveid == SleepCode) Disease:SetPlayerState(playerid, Disease_Sleep, status);
    if (motiveid == BladderCode) Disease:SetPlayerState(playerid, Disease_Bladder, status);
    return 1;
}

stock Motive:SetPercentage(playerid, motiveid, percent) {
    if (percent < 0 || percent > 100) return 1;
    if (motiveid == ThirstCode) Motive:PlayerData[playerid][ThirstCount] = ThirstMaxCount - GetPercentageOf(percent, ThirstMaxCount);
    if (motiveid == HygieneCode) Motive:PlayerData[playerid][HygieneCount] = HygieneMaxCount - GetPercentageOf(percent, HygieneMaxCount);
    if (motiveid == SleepCode) {
        Motive:PlayerData[playerid][sleep_count] = Motive:PlayerData[playerid][awake_count];
        new maxHours = 24 * 60;
        new incr = maxHours - GetPercentageOf(percent, maxHours);
        Motive:PlayerData[playerid][awake_count] = Motive:PlayerData[playerid][awake_count] + incr;
    }
    if (motiveid == BladderCode) Motive:PlayerData[playerid][BladderCount] = BladderMaxCount - GetPercentageOf(percent, BladderMaxCount);
    return 1;
}

hook ApcpOnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    APCP:AddCommand(playerid, "Motives");
    return 1;
}

hook ApcpOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Motives", inputtext)) {
        Motive:ShowMotives(playerid, targetid);
        return ~1;
    }
    return 1;
}

// here targetid is doctor or admin id
stock Motive:ShowMotives(doctorid, playerid) {
    new string[512];
    strcat(string, "Title\tLevel\tDisorder\n");
    strcat(string, sprintf("{FFFFFF}Thirst\t%s\t%s\n", GetNeedStatePercentWord(ThirstCode, GetNeedStatePercent(playerid, ThirstCode)), Disease:GetPlayerState(playerid, Disease_Thrist) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Hunger\t%s\t%s\n", GetNeedStatePercentWord(HungerCode, GetNeedStatePercent(playerid, HungerCode)), Disease:GetPlayerState(playerid, Disease_Hunger) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Hygiene\t%s\t%s\n", GetNeedStatePercentWord(HygieneCode, GetNeedStatePercent(playerid, HygieneCode)), Disease:GetPlayerState(playerid, Disease_Skin) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Sleep\t%s\t%s\n", GetNeedStatePercentWord(SleepCode, GetNeedStatePercent(playerid, SleepCode)), Disease:GetPlayerState(playerid, Disease_Sleep) ? "{FF0000}Yes" : "{00FF00}No"));
    strcat(string, sprintf("{FFFFFF}Bladder\t%s\t%s\n", GetNeedStatePercentWord(BladderCode, GetNeedStatePercent(playerid, BladderCode)), Disease:GetPlayerState(playerid, Disease_Bladder) ? "{FF0000}Yes" : "{00FF00}No"));
    FlexPlayerDialog(
        doctorid, "DocMotives", DIALOG_STYLE_TABLIST_HEADERS,
        sprintf("Motives | Health Status: %s", Disease:GetHealthLevel(playerid) == 0 ? "{00FF00}Good" : "{FF0000}Critical"),
        string, "Give Medicine", "Close", playerid
    );
    return 1;
}

FlexDialog:DocMotives(doctorid, response, motiveid, const inputtext[], patientid, const payload[]) {
    if (!response) return 1;

    new medicineList[5];
    medicineList[0] = InvLimit_Oral_Antihistamines;
    medicineList[1] = MedicineInvID_Ditropan_XL;
    medicineList[2] = MedicineInvID_Benzodiazepines;
    medicineList[3] = MedicineInvID_Temazepam;
    medicineList[4] = MedicineInvID_Bismuth_Sub;

    new medicineid = medicineList[motiveid];
    new backPackId = Backpack:GetPlayerBackpackID(doctorid);
    if (doctorid != patientid && backPackId != -1 && Faction:IsPlayerSigned(doctorid) && Faction:GetPlayerFID(doctorid) == FACTION_ID_SAMD) {
        new totalMeds = Backpack:GetInvItemQuantity(backPackId, medicineid);
        if (totalMeds < 1) return AlexaMsg(doctorid, "your backpack does not have enough medicines");
        AlexaMsg(doctorid, "medicine given to patient");
        CallMedicineTake(patientid, medicineid);
        Backpack:PopItem(backPackId, medicineid, 1);
        return 1;
    }
    if (GetPlayerAdminLevel(doctorid) >= 8) return Motive:ManagePlayer(doctorid, patientid, motiveid);
    return 1;
}

stock Motive:ManagePlayer(doctorid, patientid, motiveid) {
    new string[512];
    if (motiveid != HungerCode) strcat(string, "Set Motive Bar Value\n");
    strcat(string, "Enable Disorder\n");
    strcat(string, "Disable Disorder\n");
    return FlexPlayerDialog(doctorid, "MotiveManagePlayer", DIALOG_STYLE_LIST, "Manage Motive", string, "Select", "Close", patientid, sprintf("%d", motiveid));
}

FlexDialog:MotiveManagePlayer(doctorid, response, listitem, const inputtext[], patientid, const payload[]) {
    if (!response) return Motive:ShowMotives(doctorid, patientid);
    new motiveid = strval(payload);
    if (IsStringSame(inputtext, "Set Motive Bar Value")) return Motive:SetBarValue(doctorid, patientid, motiveid);
    if (IsStringSame(inputtext, "Enable Disorder")) {
        Motive:SetDiseaseStatus(patientid, motiveid, true);
        Motive:ShowMotives(doctorid, patientid);
        return 1;
    }
    if (IsStringSame(inputtext, "Disable Disorder")) {
        Motive:SetDiseaseStatus(patientid, motiveid, false);
        Motive:ShowMotives(doctorid, patientid);
        return 1;
    }
    return 1;
}

stock Motive:SetBarValue(doctorid, patientid, motiveid) {
    return FlexPlayerDialog(
        doctorid, "MotiveSetBarValue", DIALOG_STYLE_INPUT, "Manage Motive", "Enter percentage between 0 to 100", "Update", "Close", patientid, sprintf("%d", motiveid)
    );
}

FlexDialog:MotiveSetBarValue(doctorid, response, listitem, const inputtext[], patientid, const payload[]) {
    if (!response) return Motive:ShowMotives(doctorid, patientid);
    new motiveid = strval(payload);
    new percent;
    if (sscanf(inputtext, "d", percent) || percent < 0 || percent > 100) return Motive:SetBarValue(doctorid, patientid, motiveid);
    Motive:SetPercentage(patientid, motiveid, percent);
    Motive:ShowMotives(doctorid, patientid);
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (Faction:GetPlayerFID(playerid) == SAMD_ID && Faction:IsPlayerSigned(playerid)) QuickActions:AddCommand(playerid, "Do Health Checkup");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (IsStringSame("Do Health Checkup", inputtext)) {
        if (!response) return 1;
        Motive:ShowMotives(playerid, targetid);
        return ~1;
    }
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    UCP:AddCommand(playerid, "Motives");
    if (House:IsValidID(House:GetPlayerHouseID(playerid)) || Hotel:IsPlayerInHotel(playerid)) {
        if (Motive:PlayerData[playerid][awake_mode]) UCP:AddCommand(playerid, "Sleep Mode");
    }
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("Motives", inputtext)) { Motive:ViewMotives(playerid); return ~1; }
    if (IsStringSame("Sleep Mode", inputtext)) {
        ActivateSleep(playerid);
        return ~1;
    }
    return 1;
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid == 26) {
        Motive:PlayerData[playerid][freezedForBath] = true;
        new seconds = GetNeedStatePercent(playerid, HygieneCode) > 50 ? Random(15, 60) : Random(30, 100);
        freezeEx(playerid, seconds * 1000);
        SetTimerEx("OnPlayerBathComplete", seconds * 1000, false, "d", playerid);
        StopScreenTimer(playerid, 1);
        StartScreenTimer(playerid, seconds);
        ApplyAnimation(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your player is taking bath, please take of your hands from keyborad meanwhie...");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can interupt this by pressing enter, which is not recommanded");
        return ~1;
    }
    if (shopid == 27) {
        new seconds = Random(15, 60);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your player doing pee, rest yourself meanwhile he/she is done.");
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}you can interupt this by pressing enter, which is not recommanded");
        freezeEx(playerid, seconds * 1000);
        StopScreenTimer(playerid, 1);
        StartScreenTimer(playerid, seconds);
        Motive:PlayerData[playerid][freezedForPee] = true;
        SetTimerEx("OnPlayerPeeComplete", seconds * 1000, false, "d", playerid);
        SetPlayerSpecialAction(playerid, 68);
        return ~1;
    }
    return 1;
}

stock CallDrinkWater(playerid) {
    CallRemoteFunction("OnPlayerDrinkWater", "d", playerid);
    return 1;
}

forward OnPlayerDrinkWater(playerid);
public OnPlayerDrinkWater(playerid) {
    Motive:PlayerData[playerid][ThirstCount] = 0;
    UpdateMotiveBar(playerid);
    return 1;
}

forward OnPlayerPeeComplete(playerid);
public OnPlayerPeeComplete(playerid) {
    if (!Motive:PlayerData[playerid][freezedForPee]) return 1;
    SetPlayerSpecialAction(playerid, 0);
    Motive:PlayerData[playerid][freezedForPee] = false;
    Motive:PlayerData[playerid][BladderCount] = 0;
    UpdateMotiveBar(playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your pee task is completed.");
    return 1;
}

forward OnPlayerBathComplete(playerid);
public OnPlayerBathComplete(playerid) {
    if (!Motive:PlayerData[playerid][freezedForBath]) return 1;
    Anim:Stop(playerid);
    Motive:PlayerData[playerid][freezedForBath] = false;
    Motive:PlayerData[playerid][HygieneCount] = 0;
    UpdateMotiveBar(playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your bath task is completed.");
    return 1;
}

hook OnPlayerUpdate(playerid) {
    if (Motive:PlayerData[playerid][freezedForBath]) ApplyAnimation(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
    if (Motive:PlayerData[playerid][freezedForPee]) SetPlayerSpecialAction(playerid, 68);
    if (!Motive:PlayerData[playerid][awake_mode]) ApplyAnimation(playerid, "CRACK", "crckidle2", 4, 1, 0, 0, 1, 0, 1);
    return 1;
}

hook OnPlayerPause(playerid) {
    if (Motive:PlayerData[playerid][freezedForBath]) {
        unfreeze(playerid);
        Anim:Stop(playerid);
        Motive:PlayerData[playerid][freezedForBath] = false;
        StopScreenTimer(playerid, 1);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your bath task is cancelled, remember it's important for your health.");
    }
    if (Motive:PlayerData[playerid][freezedForPee]) {
        unfreeze(playerid);
        SetPlayerSpecialAction(playerid, 0);
        Motive:PlayerData[playerid][freezedForPee] = false;
        StopScreenTimer(playerid, 1);
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your pee task is cancelled, remember it's important for your health.");
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if (newkeys == KEY_SECONDARY_ATTACK) {
        if (!Motive:PlayerData[playerid][awake_mode]) {
            DeactivateSleep(playerid);
            return ~1;
        }
        if (Motive:PlayerData[playerid][freezedForBath]) {
            unfreeze(playerid);
            Anim:Stop(playerid);
            Motive:PlayerData[playerid][freezedForBath] = false;
            StopScreenTimer(playerid, 1);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your bath task is cancelled, remember it's important for your health.");
            return ~1;
        }
        if (Motive:PlayerData[playerid][freezedForPee]) {
            unfreeze(playerid);
            SetPlayerSpecialAction(playerid, 0);
            Motive:PlayerData[playerid][freezedForPee] = false;
            StopScreenTimer(playerid, 1);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]: {FFFFEE}your pee task is cancelled, remember it's important for your health.");
            return ~1;
        }
    }
    return 1;
}

stock ResetMotiveStatus(playerid) {
    Motive:PlayerData[playerid][ThirstCount] = 0;
    Motive:PlayerData[playerid][HygieneCount] = 0;
    Motive:PlayerData[playerid][BladderCount] = 0;
    UpdateMotiveBar(playerid);
    return 1;
}

stock ResetMotiveDisease(playerid) {
    Disease:SetPlayerState(playerid, Disease_Skin, false);
    Disease:SetPlayerState(playerid, Disease_Bladder, false);
    Disease:SetPlayerState(playerid, Disease_Thrist, false);
    Disease:SetPlayerState(playerid, Disease_Sleep, false);
    Disease:SetPlayerState(playerid, Disease_Hunger, false);
    UpdateMotiveBar(playerid);
    return 1;
}

stock GiveMotiveDisease(playerid) {
    Disease:SetPlayerState(playerid, Disease_Skin, true);
    Disease:SetPlayerState(playerid, Disease_Bladder, true);
    Disease:SetPlayerState(playerid, Disease_Thrist, true);
    Disease:SetPlayerState(playerid, Disease_Sleep, true);
    Disease:SetPlayerState(playerid, Disease_Hunger, true);
    return 1;
}

hook OnOperationComplete(doctorid, patientid, operationid) {
    if (operationid == operation:Thrist) {
        Disease:SetPlayerState(patientid, Disease_Thrist, false);
        SendClientMessage(patientid, -1, "{00afff}Alexa:{FFFFFF} thrist disease cured by operation");
    }
    if (operationid == operation:Hunger) {
        Disease:SetPlayerState(patientid, Disease_Hunger, false);
        SendClientMessage(patientid, -1, "{00afff}Alexa:{FFFFFF} hunger disease cured by operation");
    }
    if (operationid == operation:Hygiene) {
        Disease:SetPlayerState(patientid, Disease_Skin, false);
        SendClientMessage(patientid, -1, "{00afff}Alexa:{FFFFFF} hygiene disease cured by operation");
    }
    if (operationid == operation:Sleep) {
        Disease:SetPlayerState(patientid, Disease_Sleep, false);
        SendClientMessage(patientid, -1, "{00afff}Alexa:{FFFFFF} sleep disease cured by operation");
    }
    if (operationid == operation:Bladder) {
        Disease:SetPlayerState(patientid, Disease_Bladder, false);
        SendClientMessage(patientid, -1, "{00afff}Alexa:{FFFFFF} bladder disease cured by operation");
    }
    return 1;
}