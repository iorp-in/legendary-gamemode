new WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CourseFee = 10000, WeaponSpecialistDegree:CP1, WeaponSpecialistDegree:CP2, WeaponSpecialistDegree:CP3, WeaponSpecialistDegree:DIalogID;
enum {
    WeaponSpecialistDegree:offsetShowQuestion,
    WeaponSpecialistDegree:offsetQuestionTest,
    WeaponSpecialistDegree:offsetTestView,
    WeaponSpecialistDegree:CP_StartPhysicalMenu
};
enum {
    WeaponSpecialistDegree:CP1_Q_1,
    WeaponSpecialistDegree:CP1_Q_2,
    WeaponSpecialistDegree:CP2_Q_1,
    WeaponSpecialistDegree:CP3_Q_1,
    WeaponSpecialistDegree:CP3_Q_2,
    WeaponSpecialistDegree:CP3_Q_3,
};

hook GlobalOneMinuteInterval() {
    WeaponSpecialistDegree:CourseFee = Random(5000, 10000);
    return 1;
}

hook OnGameModeInit() {
    WeaponSpecialistDegree:CourseID = Course:Add("Weapon Specialist Degree", 6 * 60, WeaponSpecialistDegree:CourseFee);
    WeaponSpecialistDegree:CP1 = Course:AddChapter(WeaponSpecialistDegree:CourseID, "Legal use of Weapons");
    WeaponSpecialistDegree:CP2 = Course:AddChapter(WeaponSpecialistDegree:CourseID, "Protective Measures");
    WeaponSpecialistDegree:CP3 = Course:AddChapter(WeaponSpecialistDegree:CourseID, "Types of Weapons");
    WeaponSpecialistDegree:DIalogID = Dialog:GetFreeID();

    Database:AddColumn("playerdata", "WeaponDegree_LastAppliedAt", "int", "0");
    Database:AddColumn("playerdata", "WeaponDegree_IsCompletedOn", "int", "0");
    Database:AddColumn("playerdata", "WeaponDegree_IsPercentage", "int", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C1CompletedOn", "int", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C2CompletedOn", "int", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C3CompletedOn", "int", "0");

    Database:AddColumn("playerdata", "WeaponDegree_IsApplied", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_IsCompleted", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C1IsApplied", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C2IsApplied", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C3IsApplied", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C1IsCompleted", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C2IsCompleted", "boolean", "0");
    Database:AddColumn("playerdata", "WeaponDegree_C3IsCompleted", "boolean", "0");
    return 1;
}

hook OnPlayerLogin(playerid) {
    Course:SetPlayerState(playerid, WeaponSpecialistDegree:CourseID, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsApplied"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_LastAppliedAt"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompleted"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompletedOn"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsPercentage"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP1, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1CompletedOn"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP2, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2CompletedOn"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP3, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3CompletedOn"));
    return 1;
}

hook OnPlayerConnect(playerid) {
    Course:SetPlayerState(playerid, WeaponSpecialistDegree:CourseID);
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP1);
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP2);
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP3);
    return 1;
}

hook OnRequestCourseJoin(playerid, courseid) {
    if (courseid != WeaponSpecialistDegree:CourseID) return 1;
    if (GetPlayerCash(playerid) < WeaponSpecialistDegree:CourseFee) { SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you don't have enough money for this course."); return ~1; }
    GivePlayerCash(playerid, -WeaponSpecialistDegree:CourseFee, "weapon specialist degree fee");
    vault:addcash(Vault_ID_Government, WeaponSpecialistDegree:CourseFee, Vault_Transaction_Cash_To_Vault, sprintf("weapon specialist degree fee of %s", GetPlayerNameEx(playerid)));
    Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_IsApplied");
    WeaponSpecialistDegree:UpdateCourseInfo(playerid);
    Course:ApproveApplication(playerid, WeaponSpecialistDegree:CourseID);
    return ~1;
}

hook OnRequestCourseLeave(playerid, courseid) {
    if (courseid != WeaponSpecialistDegree:CourseID) return 1;
    Course:SetPlayerState(playerid, WeaponSpecialistDegree:CourseID, false);
    Database:UpdateBool(false, GetPlayerNameEx(playerid), "username", "WeaponDegree_IsApplied");
    WeaponSpecialistDegree:UpdateCourseInfo(playerid);
    SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} weapon specialist course has been canccelled, no refund");
    return ~1;
}

hook OnPlayerRequestDegree(playerid, courseid) {
    if (courseid != WeaponSpecialistDegree:CourseID) return 1;
    if (Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompleted")) Course:ViewDegree(playerid, WeaponSpecialistDegree:CourseID, playerid);
    return ~1;
}

hook OnRequestCourseChapter(playerid, courseid, chapterId) {
    if (courseid != WeaponSpecialistDegree:CourseID) return 1;
    if (chapterId == WeaponSpecialistDegree:CP1) {
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsApplied")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have applied for chapter 1. All the best for learning.");
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsApplied");
        }
        if (Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have already completed this chapter.");
            return ~1;
        }
        Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_LastAppliedAt");
        WeaponSpecialistDegree:UpdateCourseInfo(playerid);
        WeaponSpecialistDegree:StartChapter(playerid, WeaponSpecialistDegree:CP1);
    }
    if (chapterId == WeaponSpecialistDegree:CP2) {
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have to complete chapter 1 first.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsApplied")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have applied for chapter 2. All the best for learning.");
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsApplied");
        }
        if (Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have already completed this chapter.");
            return ~1;
        }
        Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_LastAppliedAt");
        WeaponSpecialistDegree:UpdateCourseInfo(playerid);
        WeaponSpecialistDegree:StartChapter(playerid, WeaponSpecialistDegree:CP2);
    }
    if (chapterId == WeaponSpecialistDegree:CP3) {
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have to complete chapter 1 first.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have to complete chapter 2 first.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        if (!Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsApplied")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have applied for chapter 3. All the best for learning.");
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsApplied");
        }
        if (Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsCompleted")) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} you have already completed this chapter.");
            return ~1;
        }
        Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_LastAppliedAt");
        WeaponSpecialistDegree:UpdateCourseInfo(playerid);
        WeaponSpecialistDegree:StartChapter(playerid, WeaponSpecialistDegree:CP3);
    }
    return ~1;
}

stock WeaponSpecialistDegree:UpdateCourseInfo(playerid) {
    Course:SetPlayerState(playerid, WeaponSpecialistDegree:CourseID, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsApplied"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_LastAppliedAt"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompleted"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompletedOn"), Database:GetInt(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsPercentage"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP1, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C1CompletedOn"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP2, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C2CompletedOn"));
    Course:SetPlayerChapterState(playerid, WeaponSpecialistDegree:CourseID, WeaponSpecialistDegree:CP3, Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsApplied"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsCompleted"), Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_C3CompletedOn"));
    return 1;
}

stock WeaponSpecialistDegree:StartChapter(playerid, chapterId) {
    if (chapterId == WeaponSpecialistDegree:CP1) return ShowChapterNote(playerid, WeaponSpecialistDegree:CP1_Q_1);
    if (chapterId == WeaponSpecialistDegree:CP2) return ShowChapterNote(playerid, WeaponSpecialistDegree:CP2_Q_1);
    if (chapterId == WeaponSpecialistDegree:CP3) return ShowChapterNote(playerid, WeaponSpecialistDegree:CP3_Q_1);
    return 1;
}

stock ShowChapterNote(playerid, questionid) {
    if (questionid == WeaponSpecialistDegree:CP1_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Legal use of Weapons", "One day a teenage boy named Daniel Gonzalez (citizen of San Fierro) was roaming around the streets, and he saw there is a war going on with armed police and criminals.\none of the criminal dies from firing and threw his gun far away upon dying, then had found that criminal’s AK-47 placed on road.\nHe thought lets take it and create fear among peoples that he is the powerful person there.\nHe used to point it on civilians and started robing which made him having huge criminal records.\nLater he tried to rob an undercover cop which causes his arrest and 14yrs of jail.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP1_Q_1);
    if (questionid == WeaponSpecialistDegree:CP1_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Legal use of Weapons", "Once upon a time there were a village with no crimes and a very peaceful nature but then 2 Mafias enter the village being armed and started to live there,\nwhich had ended the village’s peacefulness and there the crimes had started increasing day by day, Government decided to send there,\ngood officers there to take down those two mafias, the cops planned a strategy and attacked those mafia in which one of them die and 2nd one left the village after this.\ncops immediately gone to chase him but they left mafia weapons in their house where those mafia use to live.\nSomehow a person entered that house and found those weapon, he stole all of them and use them to save peoples from the bad peoples around the village By knowing this the govt.\nAppointed him as cop of that village, he also let government know that he found lot of weapons and using them in saving people from\ncriminals because due to those 2mafia village was never be clean from crimes.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP1_Q_2);
    if (questionid == WeaponSpecialistDegree:CP2_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Protective Measures", "Think you are, a police officer and you were doing your duty as normal days, you had planned to meet your beloved friend next day during,\nthe day time you were on duty and u were going to fuel station in order to fill some fuel in your police mobile. There you saw 3 people,\nit was dark , you got a sight glimpse of your friend who got killed by those two man, there you took action slightly and took out your gun\nand tried to catch them but they started firing without hearing, after a couple seconds, two man died you shot many time as per rules\nand the policeman left their body near the drainage system. On the next day policeman took as custody in court where there were two man\nand their father’s lodged a complaint against the policeman who killed his son for no reason.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP2_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Types of Weapons", "There was a kid named John. He is a good boy, who is known by everyone in his area. One day, he went to a park with his parents on a sunny evening.\nThere was a toy shop in that park with many new toys in it. There he was a toy gun which attracted his eyes towards it.\nHe asked his parents to buy it for him but his parents rejected his request. He was crying a lot and while returning home he saw a gun shop near his area.\nHe had an eye on it. The next evening, after his school over he went to that shop to buy the guns. He went in front of the shop like a Don of a well-known gang.\nIn front of that shop, there was a sign board written The Caribbean Shots. He went into it and had a look around the shop.\nThat time he saw a shinny gun with silver colored finish over it. He asked him to take that one, but he refused to do it.\nAnd he asked that kid to show his license. He started blinking his eyes. Then the kid asked the name of the gun to the shopkeeper.\nHe said that is an antic piece from a famous person in the world and it is named as Desert Eagle.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP3_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Types of Weapons", "There was a famous hunter at 19th century. Who is well-known for his superior hunting skills.\nDue to this he was named as Harry – The Hunter by know persons. One day, there was announcement of a world titled hunting competition in his country.\nAll suggested him as a competitor around his village. He also accepted it and joined in that competition. On the Competition day, there was a struggle for him.\nIt was the use of the weapon. He only uses vintage guns for his hunting but there were only modern shotguns given to all participants.\nBut he didn’t lose his hope. He took an unknown one in his hand and started to travel into the forest to hunt animals.\nAt first, he saw a rabbit hopping in front of him. He placed his hands on the trigger and adjusted his aim towards the rabbit and shot it but he missed the target.\nDue to this he had travel more distance to see other animals. After a long time, he saw a rare deer and shot it.\nNow he took it and displayed in the competition and got the world title and became the winner of it.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP3_Q_2);
    if (questionid == WeaponSpecialistDegree:CP3_Q_3) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetShowQuestion, DIALOG_STYLE_MSGBOX, "Types of Weapons", "Once upon a time, there was two famous Mafia in an area. They were Blacklist and Red Blood Mafia. They both have clash at all time. One day,\na member from Red Blood robbed a huge money form the oppose gang and hide it in a safe in a underwater secret lab.\nThe Blacklist Mafia member were searching it as it is a huge money. One day, the Blacklist member named Ferictor met his childhood friend in a bar.\nHis friend is a member of Red Blood. He unknowingly said that place where they hide it. He got anger and passed the information to his leader.\nHe ordered his all members to start moving towards the lab. But there was a twist in it.\nBlacklist thought it could be easy to take it back but there was full security all around the lab.\nNow what? They decided to have a gang war between them. But Red Blood Mafia had a professional member who is sniper and he was at the top of the high tower.\nHe got the information about it and filled up the cartridges and stared to aim them using the scope from the tower. His other members also join hands with him and ended it.\n\nIf you understand please proceed for test", "Start", "Back", WeaponSpecialistDegree:CP3_Q_3);
    return 1;
}

stock ChapterTestView(playerid, questionid) {
    if (questionid == WeaponSpecialistDegree:CP1_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Legal use of Weapons", "Question: What should, he do when he got this weapon?\n\nA. The thing he did, create his fear and rule the area.\nB. He may had include himself in that war and kill criminals.\nC. He should give the gun to nearest police station to avoid misuse of it.\nD. He may had let the gun placed on road.\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP1_Q_1);
    if (questionid == WeaponSpecialistDegree:CP1_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Legal use of Weapons", "Questions: Why did he stole the weapons and for what purpose?\n\nA. To sell them in BlackMarket and make money.\nB. To end the ongoing crimes in the city and make it again the peaceful village.\nC. Because he found that there are no cops and he can rule the whole village.\nD. To place them somewhere where nobody can found the weapons and do misuse of them.\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP1_Q_2);
    if (questionid == WeaponSpecialistDegree:CP2_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Protective Measures", "Question 1: How many times did the police man shooted?\nA. he fired one time.\nB. he fired two times.\nC. he fired 6 time seperately on chest.\n\nQuestion 2: Why did the police man didn't fire before?\nA. To confirm that he was his friend.\nB. To check weather his friend was alive or not.\nC. To call more cops.\n\nQuestion 3: As per rules why we should not shoot in before action.\nA. because you could not fire , until you have warant and action.\nB. because you could not fire due to no conversation.\nC. becuase you don't have proper training.\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP2_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Types of Weapons", "Question: What is the type of the gun showed by the shopkeeper?\n\nA. Shotgun.\nB. Calibers.\nC. Rifles.\nD. Pistol.\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Types of Weapons", "Question: Which type of weapons are mostly used by the hunters?\n\nA. AR\nB. Shotgun\nC. SMG\nD. Pistol\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_2);
    if (questionid == WeaponSpecialistDegree:CP3_Q_3) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetTestView, DIALOG_STYLE_MSGBOX, "Types of Weapons", "Question: What was the weapon used by the person at the tower?\n\nA. Fists\nB. Pistol\nC. Sniper\nD. AR\n\n\nSelect choosen option in next scree.", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_3);
    return 1;
}

stock ChapterTakeTest(playerid, questionid) {
    if (questionid == WeaponSpecialistDegree:CP1_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Legal use of Weapons", "A. The thing he did, create his fear and rule the area.\nB. He may had include himself in that war and kill criminals.\nC. He should give the gun to nearest police station to avoid misuse of it.\nD. He may had let the gun placed on road.", "Answer", "Back", WeaponSpecialistDegree:CP1_Q_1);
    if (questionid == WeaponSpecialistDegree:CP1_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Legal use of Weapons", "A. To sell them in BlackMarket and make money.\nB. To end the ongoing crimes in the city and make it again the peaceful village.\nC. Because he found that there are no cops and he can rule the whole village.\nD. To place them somewhere where nobody can found the weapons and do misuse of them.", "Answer", "Back", WeaponSpecialistDegree:CP1_Q_2);
    if (questionid == WeaponSpecialistDegree:CP2_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Protective Measures", "A, A, A\nA, A, B\nA, A, C\nA, B, A\nA, B, B\nA, B, C\nA, C, A\nA, C, B\nA, C, C\nB, A, A\nB, A, B\nB, A, C\nB, B, A\nB, B, B\nB, B, C\nB, C, A\nB, C, B\nB, C, C\nC, A, A\nC, A, B\nC, A, C\nC, B, A\nC, B, B\nC, B, C\nC, C, A\nC, C, B\nC, C, C\n", "Answer", "Back", WeaponSpecialistDegree:CP2_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_1) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Types of Weapons", "A. Shotgun.\nB. Calibers.\nC. Rifles.\nD. Pistol.", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_1);
    if (questionid == WeaponSpecialistDegree:CP3_Q_2) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Types of Weapons", "A. AR\nB. Shotgun\nC. SMG\nD. Pistol", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_2);
    if (questionid == WeaponSpecialistDegree:CP3_Q_3) return ShowPlayerDialogEx(playerid, WeaponSpecialistDegree:DIalogID, WeaponSpecialistDegree:offsetQuestionTest, DIALOG_STYLE_LIST, "Types of Weapons", "A. Fists\nB. Pistol\nC. Sniper\nD. AR", "Answer", "Back", WeaponSpecialistDegree:CP3_Q_3);
    return 1;
}

stock ChapterTestResult(playerid, questionid, answer) {
    if (questionid == WeaponSpecialistDegree:CP1_Q_1) {
        if (answer == 2) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Correct answer, keep it up and complete degree as fast as you can.");
            ShowChapterNote(playerid, WeaponSpecialistDegree:CP1_Q_2);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
        return 1;
    }
    if (questionid == WeaponSpecialistDegree:CP1_Q_2) {
        if (answer == 1) {
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C1IsCompleted");
            Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_C1CompletedOn");
            WeaponSpecialistDegree:UpdateCourseInfo(playerid);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Congratulations, you have completed this chapter.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
        return 1;
    }
    if (questionid == WeaponSpecialistDegree:CP2_Q_1) {
        if (answer == 18) {
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C2IsCompleted");
            Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_C2CompletedOn");
            WeaponSpecialistDegree:UpdateCourseInfo(playerid);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Congratulations, you have completed this chapter.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
        return 1;
    }
    if (questionid == WeaponSpecialistDegree:CP3_Q_1) {
        if (answer == 3) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Correct answer, keep it up and complete degree as fast as you can.");
            ShowChapterNote(playerid, WeaponSpecialistDegree:CP3_Q_2);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
        return 1;
    }
    if (questionid == WeaponSpecialistDegree:CP3_Q_2) {
        if (answer == 1) {
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Correct answer, keep it up and complete degree as fast as you can.");
            ShowChapterNote(playerid, WeaponSpecialistDegree:CP3_Q_3);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
        return 1;
    }
    if (questionid == WeaponSpecialistDegree:CP3_Q_3) {
        if (answer == 2) {
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_C3IsCompleted");
            Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_C3CompletedOn");
            Database:UpdateBool(true, GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompleted");
            Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompletedOn");
            Database:UpdateInt(Random(80, 100), GetPlayerNameEx(playerid), "username", "WeaponDegree_IsPercentage");
            WeaponSpecialistDegree:UpdateCourseInfo(playerid);
            SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Congratulations, you have completed your degree.");
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return 1;
        }
        SendClientMessage(playerid, -1, "{4286f4}[Alexa]:{FFFFEE} Sorry, you have to pay more attention to classes or you will fail every time.");
        Course:ShowMenu(playerid);
        return 1;
    }
    return 1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != WeaponSpecialistDegree:DIalogID) return 1;
    if (offsetid == WeaponSpecialistDegree:offsetShowQuestion) {
        if (!response) {
            Course:ShowChapterMenu(playerid, WeaponSpecialistDegree:CourseID);
            return ~1;
        }
        ChapterTestView(playerid, extraid);
        return ~1;
    }
    if (offsetid == WeaponSpecialistDegree:offsetTestView) {
        if (!response) {
            WeaponSpecialistDegree:StartChapter(playerid, extraid);
            return ~1;
        }
        ChapterTakeTest(playerid, extraid);
        return ~1;
    }
    if (offsetid == WeaponSpecialistDegree:offsetQuestionTest) {
        if (!response) {
            WeaponSpecialistDegree:StartChapter(playerid, extraid);
            return ~1;
        }
        ChapterTestResult(playerid, extraid, listitem);
        return ~1;
    }
    return ~1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    if (Database:GetBool(GetPlayerNameEx(playerid), "username", "WeaponDegree_IsCompleted")) QuickActions:AddCommand(playerid, "Show Weapon Degree");
    new isHaveWeaponDegree = Database:GetBool(GetPlayerNameEx(targetid), "username", "WeaponDegree_IsCompleted");
    new allowedFactions[] = { 0, 1 };
    if (IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid)) QuickActions:AddCommand(playerid, "Check Weapon Degree");
    if (IsArrayContainNumber(allowedFactions, Faction:GetPlayerFID(playerid)) && Faction:IsPlayerSigned(playerid) && isHaveWeaponDegree) QuickActions:AddCommand(playerid, "Seize Weapon Degree");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    new isHaveWeaponDegree = Database:GetBool(GetPlayerNameEx(targetid), "username", "WeaponDegree_IsCompleted");
    if (IsStringSame("Show Weapon Degree", inputtext)) {
        Course:ViewDegree(playerid, WeaponSpecialistDegree:CourseID, targetid);
        return ~1;
    }
    if (IsStringSame("Check Weapon Degree", inputtext)) {
        if (!isHaveWeaponDegree) {
            AlexaMsg(playerid, sprintf("%s does not have a weapon degree", GetPlayerNameEx(targetid)));
            return ~1;
        }
        Course:ViewDegree(targetid, WeaponSpecialistDegree:CourseID, playerid);
        return ~1;
    }
    if (IsStringSame("Seize Weapon Degree", inputtext)) {
        SendClientMessage(targetid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} your weapon degree has been seized by officer %s", GetPlayerNameEx(playerid)));
        SendClientMessage(playerid, -1, sprintf("{4286f4}[Alexa]:{FFFFFF} you have seized degree license of %s", GetPlayerNameEx(targetid)));

        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_LastAppliedAt", "playerdata");
        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_IsCompletedOn", "playerdata");
        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_IsPercentage", "playerdata");
        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_C1CompletedOn", "playerdata");
        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_C2CompletedOn", "playerdata");
        Database:UpdateInt(0, GetPlayerNameEx(targetid), "username", "WeaponDegree_C3CompletedOn", "playerdata");

        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_IsApplied", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_IsCompleted", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C1IsApplied", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C2IsApplied", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C3IsApplied", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C1IsCompleted", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C2IsCompleted", "playerdata");
        Database:UpdateBool(false, GetPlayerNameEx(targetid), "username", "WeaponDegree_C3IsCompleted", "playerdata");
        return ~1;
    }
    return 1;
}