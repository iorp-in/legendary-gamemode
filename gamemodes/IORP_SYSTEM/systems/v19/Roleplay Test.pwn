#define TableLastTestTime "RoleplayTestTime"
#define MaxRPQuentions 7

hook OnGameModeInit() {
    Database:AddColumn("playerdata", TableLastTestTime, "int", "0");
    return 1;
}

new RPtestQNA[MaxRPQuentions][4][] = {
    {
        "Q1: If you're bored and want to deathmatch, what would you do?", //Question 1 ....
        "A1: Buy a weapon and start the killing everyone",
        "A2: Log out or connect to a dm server.",
        "A3: Form a gang which results in wars" //answer 2
    }, // Answers for Question 2 ....
    {
        "Q2: PowerGame mean?",
        "A1: kill peoples",
        "A2: Impossible Actions", //answer 1
        "A3: Metagaming"
    }, // Answers for Question 3 ....
    {
        "Q3: Cheat allowed ?",
        "A1: No.", //answer 0
        "A2: Yes,usefull for RP servers",
        "A3: i dont know"
    }, // Answers for Question 4 ....
    {
        "Q4: Are you allowed to jump to get somewhere faster?",
        "A1: Yes if you're in a hurry",
        "A2: No, bunnyhopping is not allowed. It is non-RP", //answer 1
        "A3: Yes, all the time"
    }, // Answers for Question 5 ....
    {
        "Q5: What is the correct method for getting admin' help in game?",
        "A1: Talk in ooc chat with all caps so they see it",
        "A2: Make an advert",
        "A3: use /admins and contact them personally" //answer 2
    }, // Answers for Question 6 ....
    {
        "Q6: What should you do if you have an awesome suggestion?",
        "A1: PM any of the current admins online",
        "A2: Explain it through local OOC, global OOC, advert or /report",
        "A3: Suggest it on the forum with proper details" //answer 2
    }, // Answers for Question 7 ....
    {
        "Q7: what is roleplay meaning?",
        "A1: taking a fiction character and use it for roleplay", //answer 0
        "A2: it is meaning less, it does not mean anything.",
        "A3: killing everyone with /fightmode"
    }
};

enum RpTestEnum {
    currentQuetion,
    correctAnswers,
    testStartTime
}
new RpTestData[MAX_PLAYERS][RpTestEnum];

stock startRoleplayTest(playerid) {
    if ((gettime() - Database:GetInt(GetPlayerNameEx(playerid), "username", TableLastTestTime)) < 60 * 60) return SendClientMessage(playerid, -1, "{4286f4}[Roleplay Test]: {FFFFEE}wait for one hour to try again");
    new string[1024];
    strcat(string, "you are about to start your roleplay test\n");
    strcat(string, "you will be asked few questions, if you answer them all correctly then you can pass this test.\n\n");
    strcat(string, "before you start this test, make sure you know all the rules and roleplay.\n");
    strcat(string, "if you are new and don't know them, then first goto this link and read/learn them.\n");
    strcat(string, "link: https://forum.iorp.in/topic/273/a-beginner-s-guide-to-rp-s-by-16luongl1\n");
    strcat(string, "link: https://forum.iorp.in/topic/6/rule-roleplay-guide-rules\n\n");
    strcat(string, "if you are ready to start? (remember you can take roleplay test one time in 6 hours)\n");
    strcat(string, "press continue (cancel if you are not)\n");
    return FlexPlayerDialog(playerid, "StartRoleplayTest", DIALOG_STYLE_MSGBOX, "{4286f4}[Roleplay Test]: {FFFFEE}guidelines", string, "start", "cancel");
}

FlexDialog:StartRoleplayTest(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    RpTestData[playerid][currentQuetion] = 0;
    RpTestData[playerid][correctAnswers] = 0;
    RpTestData[playerid][testStartTime] = gettime();
    SendClientMessage(playerid, -1, "{4286f4}[Roleplay Test]: {FFFFEE}you have five minute to complete this test");
    RpShowQuestion(playerid, RpTestData[playerid][currentQuetion]);
    return 1;
}

stock FailRoleplayTest(playerid) {
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", TableLastTestTime);
    CallRemoteFunction("OnRoleplayTestResult", "dd", playerid, 0);
    return 1;
}

stock PassRoleplayTest(playerid) {
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", TableLastTestTime);
    CallRemoteFunction("OnRoleplayTestResult", "dd", playerid, 1);
    return 1;
}

forward OnRoleplayTestResult(playerid, bool:result);
public OnRoleplayTestResult(playerid, bool:result) {
    SendClientMessage(playerid, -1, sprintf("{4286f4}[Roleplay Test]: {FFFFEE}you have given %d correct answers from %d questions", RpTestData[playerid][correctAnswers], MaxRPQuentions));
    return 1;
}

stock RpShowQuestion(playerid, qID = 0) {
    new string[1024];
    strcat(string, sprintf("%s\n", RPtestQNA[qID][1]));
    strcat(string, sprintf("%s\n", RPtestQNA[qID][2]));
    strcat(string, sprintf("%s\n", RPtestQNA[qID][3]));
    return FlexPlayerDialog(playerid, "RpShowQuestion", DIALOG_STYLE_LIST, sprintf("{FFFF00}%s", RPtestQNA[qID][0]), string, "Select", "Cancel Test");
}

FlexDialog:RpShowQuestion(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return FailRoleplayTest(playerid);
    if (RpTestData[playerid][currentQuetion] < 0 || RpTestData[playerid][currentQuetion] > MaxRPQuentions) return 1;
    new qID = RpTestData[playerid][currentQuetion];
    if (qID == 0 && listitem == 2) RpTestData[playerid][correctAnswers]++;
    else if (qID == 1 && listitem == 1) RpTestData[playerid][correctAnswers]++;
    else if (qID == 2 && listitem == 0) RpTestData[playerid][correctAnswers]++;
    else if (qID == 3 && listitem == 1) RpTestData[playerid][correctAnswers]++;
    else if (qID == 4 && listitem == 2) RpTestData[playerid][correctAnswers]++;
    else if (qID == 5 && listitem == 2) RpTestData[playerid][correctAnswers]++;
    else if (qID == 6 && listitem == 0) RpTestData[playerid][correctAnswers]++;
    if (RpTestData[playerid][currentQuetion] == (MaxRPQuentions - 1)) {
        if ((gettime() - RpTestData[playerid][testStartTime]) > 60 * 5) {
            SendClientMessage(playerid, -1, "{4286f4}[Roleplay Test]: {FFFFEE}you have taken more then five minute for this test");
            FailRoleplayTest(playerid);
            return 1;
        }
        if (RpTestData[playerid][correctAnswers] >= MaxRPQuentions - 2) PassRoleplayTest(playerid);
        else FailRoleplayTest(playerid);
        return 1;
    }
    RpTestData[playerid][currentQuetion]++;
    RpShowQuestion(playerid, RpTestData[playerid][currentQuetion]);
    return 1;
}