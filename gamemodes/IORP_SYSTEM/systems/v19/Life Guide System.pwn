new lifeguide_docid, lifeguide_short_docid;

hook OnGameModeInit() {
    lifeguide_docid = Doc:GetFreeID();
    lifeguide_short_docid = Doc:GetFreeID();
    new string[2000];
    strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are going to see your background history\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will get answers for this questions\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}Where did you came?\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}Where is your family?\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}How can you live your life here in SA?\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}And many other questions of your.\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}Do you want to continue???.\n");
    strcat(string, "{db6600}[Life Guide]: {FFFFEE}Press ESC to cancel this tutorial???.\n");
    strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    Doc:Add(0, lifeguide_docid, "Life Guide - Full Version", string);
    Doc:Add(0, lifeguide_short_docid, "Life Guide", string);
    return 1;
}

Doc:OnResponse(playerid, docid, response) {
    if (docid == lifeguide_docid) {
        if (response) ShowLifeGuide(playerid);
        return ~1;
    } else if (docid == lifeguide_short_docid) {
        if (response) ShowLifeGuide_Short(playerid);
        return ~1;
    }
    return 1;
}

enum LIFE_System_PlayerData_Enum {
    Float:Life_Sys_Pos[4],
        Life_Sys_Int,
        Life_Sys_VW
};
new Float:LIFE_System_PlayerData[MAX_PLAYERS][LIFE_System_PlayerData_Enum];

stock ShowLifeGuide(playerid, intro_id = 0) {
    new string[2000];
    if (intro_id == 0) {
        GetPlayerPos(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][0], LIFE_System_PlayerData[playerid][Life_Sys_Pos][1], LIFE_System_PlayerData[playerid][Life_Sys_Pos][2]);
        GetPlayerFacingAngle(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][3]);
        LIFE_System_PlayerData[playerid][Life_Sys_Int] = GetPlayerInterior(playerid);
        LIFE_System_PlayerData[playerid][Life_Sys_VW] = GetPlayerVirtualWorld(playerid);
        TogglePlayerSpectatingEx(playerid, true);
        Streamer_ToggleCameraUpdate(playerid, true);
        InterpolateCameraPos(playerid, 0.000000, -2080.542236, 123.349609, 3334.443115, -1384.665527, 66.893356, 30000);
        InterpolateCameraLookAt(playerid, 78.843795, -2076.650878, 122.330741, 3330.093261, -1386.809814, 65.676284, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Welcome to IORP: Origin of Life\n");
        strcat(string, "________________________________________________________________\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are just one click away to start a virtual life :)\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 1) {
        InterpolateCameraPos(playerid, 782.133544, -2242.985595, 137.422103, 3670.437744, -896.390441, 36.852882, 30000);
        InterpolateCameraLookAt(playerid, 785.579345, -2239.978515, 135.401290, 3668.675048, -900.948425, 35.795822, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}My purpuse in server?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are given a virtual life, it is your duty (and also your entitlement as a human being) to find something beautiful within life, no matter how slight\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Quick introduction to life cycle of server\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}There was a accident while you were on trip with your family at Ylläs, Unfortunately, no one survived except you, so you are on your own now\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Controls for you to use in server\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Press Y to start engine\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Press H+Space or type pocket to open your pocket\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Aim player with right click and press space while aiming to open player menu\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 2) {
        InterpolateCameraPos(playerid, 192.243804, -1587.017822, 373.173828, 2944.494384, -1119.548706, 22.417306, 30000);
        InterpolateCameraLookAt(playerid, 192.186035, -1587.449707, 368.192840, 2942.666503, -1114.927734, 21.864154, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Where to start?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are 18 years old, so you are young.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will grow old over time.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to start your life, you have finished your high school\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to complete your graduation from Harvard University located in San Fierro\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}If you have not completed your graduation, you can not apply for a job. For which graduation eligibility is required\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will get more information about the undergraduate at the university\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What next?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Now you can get jobs in government or private sectors.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Earn Money. Buy House, Business, Vehicles ETC.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Just do not forget to pay your taxes on time.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 3) {
        InterpolateCameraPos(playerid, 1551.067016, 407.634460, 90.593505, 609.662109, -2009.976318, 41.603378, 30000);
        InterpolateCameraLookAt(playerid, 1555.220336, 410.369110, 90.072380, 605.922424, -2013.067626, 40.395606, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}What about my sex life?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}We also take care of your sexual desires. You can fulfill them with your partner or strippers.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Rape of a girl is illegal, you can spend your remaining life in jail for that.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What about my kids?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}In San Andreas, when newcomers like you arrive, They were given special type of injection.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}That is why you can not make your children due to obstruction of pregnancy.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}But if your marriage is good enough, then you can adopt newcomers as your children.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Go to court and apply for adoption process with your family.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will find more information about this in court..\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 4) {
        InterpolateCameraPos(playerid, 403.819458, 674.813720, 91.035530, 832.984313, 3555.389160, 73.206245, 30000);
        InterpolateCameraLookAt(playerid, 400.087341, 671.705688, 89.847473, 835.560241, 3551.619873, 71.167289, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}What is Alexa?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Alexa is your personal assistant, You need it to survive, it will guide you through the server.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Do I need her?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}She is capable of executing many orders of yours, and can get information about anything for you from internet.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can access the my pocket command's quickly using Alexa.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Where do I get it?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to buy a phone from a nearby market and activate alexa feature on it.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 5) {
        InterpolateCameraPos(playerid, 403.819458, 674.813720, 91.035530, 832.984313, 3555.389160, 73.206245, 30000);
        InterpolateCameraLookAt(playerid, 400.087341, 671.705688, 89.847473, 835.560241, 3551.619873, 71.167289, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}How life runs here?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Everybody does the routine. Like waking up, eating, working, eating, sleeping.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Some students, workers, old people live here and leave peacefully.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}There are governments that ensure that people follow the law and do not commit crime.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Some do but all do not. People commit crimes such as rape, drug dealing, weapon dealing, kidnapping etc.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Law enforcement tries to fight crime and the court decides for your imprisonment.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 6) {
        InterpolateCameraPos(playerid, 2770.966552, -1998.067871, 81.590568, 1224.505493, -2062.770263, 101.558341, 30000);
        InterpolateCameraLookAt(playerid, 2770.907958, -1996.278564, 76.922042, 1220.415527, -2061.045166, 99.256965, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}What else about SA:MP?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}It is life so you need eat well, sleep proper\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What if I don't?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}If your appetite is very high, you will become unconscious and then you need to go to the hospital.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What about Counter Strike Souce, PUBG, COD, Skyfall?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}They are games, you can play them by visiting the nearest gaming zone?\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Can I use global chat?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}No, there is nothing like this in real life. You can use mobile to call your friends or to chat with the closest players using /s.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}*We have enabled the PM system, but it can be used after 100 score.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}I need more help to understand this server?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Be sure to use the request system from my pocket and request it. Administrator will help you with more details?\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 7) {
        //cityhall
        InterpolateCameraPos(playerid, -1025.303955, 296.883270, 137.613067, 1403.128906, -1732.231201, 55.044918, 30000);
        InterpolateCameraLookAt(playerid, -1028.723510, 300.530700, 137.561630, 1406.995727, -1735.297485, 54.241611, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of City Hall\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can manage you server settings in city hall office.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can apply for ID Card which is called aadhaar card.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you must carry your id card because any law officer can ask for it.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you will be fined if you don't carry your id card.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 8) {
        // electronic shop with jobs secription
        InterpolateCameraPos(playerid, 216.559860, -1447.882934, 122.195266, 1307.707397, -1109.445068, 88.743896, 30000);
        InterpolateCameraLookAt(playerid, 220.733154, -1445.134521, 122.022148, 1311.651733, -1111.962768, 86.982429, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Electronic Shop\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase GPS.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase alexa communication kit.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase auto drive kit.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase phone.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase Tablet.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 9) {
        // cloth shop
        InterpolateCameraPos(playerid, 1313.608276, -988.652343, 661.398437, 1315.973510, -931.475891, 41.532184, 30000);
        InterpolateCameraLookAt(playerid, 1313.613037, -988.216613, 656.417480, 1316.114257, -926.492248, 41.153469, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Cloth Shop\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can purchase cloth's here.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can manage cloth's in your pocket controls.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 10) {
        // food corner 
        InterpolateCameraPos(playerid, 213.908920, -1724.497192, 207.819091, 1399.074218, -1512.260864, 126.540367, 30000);
        InterpolateCameraLookAt(playerid, 216.250671, -1720.637695, 205.669662, 1401.386474, -1508.497558, 124.197158, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Food Corner\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can eat food or dring coca cola here.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}food corner's are all around san andreas.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you need to eat properly to stay alive.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 11) {
        // recruitment officer
        InterpolateCameraPos(playerid, 465.991851, -1688.046752, 279.763488, 916.583618, -1745.224365, 14.368626, 30000);
        InterpolateCameraLookAt(playerid, 470.216705, -1688.568115, 277.140747, 921.582336, -1745.111938, 14.367721, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Recruitment Officer\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can apply for any faction here.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Only the faction leader can accept your application.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you must have been familier with roleplay to join any faction.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}check out all the roleplay cmds in help section.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 12) {
        // houses in sf
        InterpolateCameraPos(playerid, -2306.587402, 63.990978, 552.660644, -2718.148681, -290.653656, 12.300504, 30000);
        InterpolateCameraLookAt(playerid, -2308.468505, 61.057094, 549.075378, -2718.805664, -295.514465, 11.330378, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of House's located in SF\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you can puchase house in SF only atm.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you need house to sleep.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you need house to live with your family.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}you need house to have sexual desire with your partner.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can also sell your house anytime.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 13) {
        // business in lv
        InterpolateCameraPos(playerid, 0.000000, 850.066894, 140.551620, 2766.588378, 2451.833007, 12.836865, 30000);
        InterpolateCameraLookAt(playerid, 1489.538330, 851.685058, 139.186141, 2771.341552, 2450.282958, 12.761182, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Business's located in LV.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can puchase any business in lv.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}The business will generate revenue per minute.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can collect money from your business anytime.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can also sell your business anytime.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 14) {
        // Brothel
        InterpolateCameraPos(playerid, 1394.367187, -406.991455, 783.313781, 2211.165283, -1138.453002, 25.553855, 30000);
        InterpolateCameraLookAt(playerid, 1393.789306, -410.253143, 779.568420, 2212.995117, -1143.079101, 26.055339, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Jefferson Brother located in LS.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You should be 18+ to go in this place.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will find some sexual content inside this brothel.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need money to have some fun in there.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Actions are will be taken again you if you are under 18.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 15) {
        // GameZone in lv
        InterpolateCameraPos(playerid, -1025.303955, 296.883270, 137.613067, 1403.128906, -1732.231201, 55.044918, 30000);
        InterpolateCameraLookAt(playerid, -1028.723510, 300.530700, 137.561630, 1406.995727, -1735.297485, 54.241611, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Game Zone.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}There are many games you can play inside game zone.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Some of best game's are.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Counter Strike Source.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Call of Duty.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}PUBG.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Skyfall.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}any many more games.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}gamezone use your game money, so make sure your cash is bank or safe place so that you will not lost it.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 16) {
        // Bank in lv
        InterpolateCameraPos(playerid, 1247.755249, -1796.080688, 414.874084, 1047.872192, -1765.415527, 23.771612, 30000);
        InterpolateCameraLookAt(playerid, 1246.229248, -1795.159912, 410.202514, 1043.185180, -1764.493408, 22.294536, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Bank.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can open multiple account's in bank.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can transfer money from bank account to bank account.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can withdraw or deposit money at bank or ATM.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Bank Accounts are password protected.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You should have remember your password.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 17) {
        // Dealership in lv
        InterpolateCameraPos(playerid, 1459.061523, -1723.030883, 477.175598, 1726.881225, -1770.349487, 22.902858, 1000);
        InterpolateCameraLookAt(playerid, 1461.388305, -1723.395385, 472.765014, 1731.789428, -1770.427734, 21.952087, 1000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Dealership located in LS.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}In the dealership you can purchase any vehicle including air vehicles.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}The price are shown on the list of vehicles at our website's and in game too.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}To manage your vehicles use your pocket.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can give your car keys to another player too.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 18) {
        // Fun Fair in lv
        InterpolateCameraPos(playerid, 961.173461, -1380.524536, 128.355911, 824.772460, -1858.160156, 30.516748, 1000);
        InterpolateCameraLookAt(playerid, 965.556274, -1378.118164, 128.370452, 827.951538, -1861.666503, 28.904611, 1000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}On screen location is of Fun Fair LS.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can turn on any ride in free.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}There should be one player at the control center to manage rides.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can go this beach to have rides or dance with others.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}All the rides are free of cost.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Every ride has a specific run time.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 19) {
        InterpolateCameraPos(playerid, -48.441116, -395.725067, 83.822616, 755.483581, -1404.100708, 40.814258, 30000);
        InterpolateCameraLookAt(playerid, -50.355506, -391.274047, 82.588333, 752.487182, -1400.519409, 39.026493, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Is that all?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Of course not, this was just a quick introduction. You can except anything from real life here. If you are certainly not getting anything real or unavailable\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Please update us at iorp.in or send email to indianoceanroleplay@gmail.com\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Thanks for joining GTA SA: Origin of Life\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else {
        Stop_Life_Guide(playerid);
        return 1;
    }
    return FlexPlayerDialog(playerid, "LifeGuideIntroMenu", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]: {FFFFEE}Life Guide", string, "Next", "Close", intro_id);
}

FlexDialog:LifeGuideIntroMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) Stop_Life_Guide(playerid);
    else ShowLifeGuide(playerid, extraid + 1);
    return 1;
}

stock ShowLifeGuide_Short(playerid, intro_id = 0) {
    new string[2000];
    if (intro_id == 0) {
        GetPlayerPos(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][0], LIFE_System_PlayerData[playerid][Life_Sys_Pos][1], LIFE_System_PlayerData[playerid][Life_Sys_Pos][2]);
        GetPlayerFacingAngle(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][3]);
        LIFE_System_PlayerData[playerid][Life_Sys_Int] = GetPlayerInterior(playerid);
        LIFE_System_PlayerData[playerid][Life_Sys_VW] = GetPlayerVirtualWorld(playerid);
        TogglePlayerSpectatingEx(playerid, true);
        Streamer_ToggleCameraUpdate(playerid, true);
        InterpolateCameraPos(playerid, 0.000000, -2080.542236, 123.349609, 3334.443115, -1384.665527, 66.893356, 30000);
        InterpolateCameraLookAt(playerid, 78.843795, -2076.650878, 122.330741, 3330.093261, -1386.809814, 65.676284, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Welcome to IORP: Origin of Life\n");
        strcat(string, "________________________________________________________________\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are just one click away to start a virtual life :)\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 1) {
        InterpolateCameraPos(playerid, 782.133544, -2242.985595, 137.422103, 3670.437744, -896.390441, 36.852882, 30000);
        InterpolateCameraLookAt(playerid, 785.579345, -2239.978515, 135.401290, 3668.675048, -900.948425, 35.795822, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}My purpuse in server?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are given a virtual life, it is your duty (and also your entitlement as a human being) to find something beautiful within life, no matter how slight\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Quick introduction to life cycle of server\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}There was a accident while you were on trip with your family at Ylläs, Unfortunately, no one survived except you, so you are on your own now\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Controls for you to use in server\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Press Y to start engine\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Press H+Space or type pocket to open your pocket\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Aim player with right click and press space while aiming to open player menu\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 2) {
        InterpolateCameraPos(playerid, 192.243804, -1587.017822, 373.173828, 2944.494384, -1119.548706, 22.417306, 30000);
        InterpolateCameraLookAt(playerid, 192.186035, -1587.449707, 368.192840, 2942.666503, -1114.927734, 21.864154, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Where to start?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You are 18 years old, so you are young.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will grow old over time.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to start your life, you have finished your high school\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to complete your graduation from Harvard University located in San Fierro\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}If you have not completed your graduation, you can not apply for a job. For which graduation eligibility is required\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You will get more information about the undergraduate at the university\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What next?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Now you can get jobs in government or private sectors.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Earn Money. Buy House, Business, Vehicles ETC.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Just do not forget to pay your taxes on time.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 3) {
        InterpolateCameraPos(playerid, 403.819458, 674.813720, 91.035530, 832.984313, 3555.389160, 73.206245, 30000);
        InterpolateCameraLookAt(playerid, 400.087341, 671.705688, 89.847473, 835.560241, 3551.619873, 71.167289, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}What is Alexa?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Alexa is your personal assistant, You need it to survive, it will guide you through the server.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Do I need her?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}She is capable of executing many orders of yours, and can get information about anything for you from internet.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You can access the my pocket command's quickly using Alexa.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Where do I get it?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}You need to buy a phone from a nearby market and activate alexa feature on it.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 4) {
        InterpolateCameraPos(playerid, 2770.966552, -1998.067871, 81.590568, 1224.505493, -2062.770263, 101.558341, 30000);
        InterpolateCameraLookAt(playerid, 2770.907958, -1996.278564, 76.922042, 1220.415527, -2061.045166, 99.256965, 30000);
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}What else about SA:MP?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}It is life so you need eat well, sleep proper\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What if I don't?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}If your appetite is very high, you will become unconscious and then you need to go to the hospital.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}What about Counter Strike Souce, PUBG, COD, Skyfall?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}They are games, you can play them by visiting the nearest gaming zone?\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}Can I use global chat?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}No, there is nothing like this in real life. You can use mobile to call your friends or to chat with the closest players using /s.\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}*We have enabled the PM system, but it can be used after 100 score.\n");
        strcat(string, "\n{db6600}[Life Guide]: {FFFFEE}I need more help to understand this server?\n");
        strcat(string, "{db6600}[Life Guide]: {FFFFEE}Be sure to use the request us. Administrator will help you with more details?\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else {
        Stop_Life_Guide(playerid);
        return 1;
    }
    return FlexPlayerDialog(playerid, "LifeGuideIntoShortMenu", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]: {FFFFEE}Life Guide", string, "Next", "Close", intro_id);
}

FlexDialog:LifeGuideIntoShortMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) Stop_Life_Guide(playerid);
    else ShowLifeGuide_Short(playerid, extraid + 1);
    return 1;
}

stock Stop_Life_Guide(playerid) {
    GameTextForPlayer(playerid, "~r~The beginning of your life~g~..", 5000, 3);
    Streamer_ToggleCameraUpdate(playerid, false);
    SetCameraBehindPlayer(playerid);
    TogglePlayerSpectatingEx(playerid, false);
    SetPlayerFacingAngle(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][3]);
    SetPlayerPosEx(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Pos][0], LIFE_System_PlayerData[playerid][Life_Sys_Pos][1], LIFE_System_PlayerData[playerid][Life_Sys_Pos][2]);
    SetPlayerInteriorEx(playerid, LIFE_System_PlayerData[playerid][Life_Sys_Int]);
    SetPlayerVirtualWorldEx(playerid, LIFE_System_PlayerData[playerid][Life_Sys_VW]);
    return 1;
}

hook OnFirstLogin(playerid) {
    SetTimerEx("CallShowLifeGuide", 10000, false, "d", playerid);
    return 1;
}

forward CallShowLifeGuide(playerid);
public CallShowLifeGuide(playerid) {
    FlexPlayerDialog(playerid, "FirstSpawnConfirm", DIALOG_STYLE_MSGBOX, "Life Guide", "It's recommanded to view our life guide, if you are new to IORP.\n\nDo you want to view life guide?", "Confirm", "Skip");
    return 1;
}

FlexDialog:FirstSpawnConfirm(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    ShowLifeGuide_Short(playerid);
    return 1;
}