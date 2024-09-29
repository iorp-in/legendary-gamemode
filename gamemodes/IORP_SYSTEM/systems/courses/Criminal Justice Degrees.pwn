new CJD_CourseID, CJD_CP1, CJD_CP2, CJD_DIalogID;
enum {
    CJD_CP_UnSolveDHomicide,
    CJD_CP_UnSolveDHomicideTest,
    CJD_CP_UnSHTestOptions,
    CJD_CP_StartPhysicalMenu
};
enum {
    CJD_CP1_Q_1,
    CJD_CP1_Q_2
};

hook OnGameModeInit() {
    CJD_CourseID = Course:Add("Criminal Justice Degrees", 1440, 1);
    CJD_CP1 = Course:AddChapter(CJD_CourseID, "Unsolved Homicide");
    CJD_CP2 = Course:AddChapter(CJD_CourseID, "Physical Training");
    CJD_DIalogID = Dialog:GetFreeID();
    return 1;
}

hook OnPlayerConnect(playerid) {
    Course:SetPlayerState(playerid, CJD_CourseID);
    Course:SetPlayerChapterState(playerid, CJD_CourseID, CJD_CP1);
    return 1;
}

hook OnRequestCourseJoin(playerid, courseid) {
    if (courseid != CJD_CourseID) return 1;
    Course:ApproveApplication(playerid, CJD_CourseID);
    return ~1;
}

hook OnRequestCourseLeave(playerid, courseid) {
    if (courseid != CJD_CourseID) return 1;
    Course:SetPlayerState(playerid, CJD_CourseID, false);
    SendClientMessage(playerid, -1, "course canccelled, no refund");
    return ~1;
}

stock CJD_StartChapter(playerid, chapterId) {
    if (chapterId == CJD_CP1) return UnSolvedHomiceStart(playerid, CJD_CP1_Q_1);
    if (chapterId == CJD_CP2) return StartPhysicalTraining(playerid);
    return 1;
}

stock StartPhysicalTraining(playerid) {
    new string[512];
    strcat(string, "Welcome in San Andreas Police Departmet, Physical Training\n\n");
    strcat(string, "you have to recover a stolen vehicle of SAPD from desert. This are vehicle details\n");
    strcat(string, "Color: Black\nType: SUV\nLocation: Desert\n\n");
    strcat(string, "once you reover the vehilce, return it to SAPD");
    ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_StartPhysicalMenu, DIALOG_STYLE_MSGBOX, "Criminal Justice Degrees: Physical Training", "", "Okay", "Cancel");
    return 1;
}

stock UnSolvedHomiceStart(playerid, homicideID) {
    if (homicideID == CJD_CP1_Q_1) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSolveDHomicide, DIALOG_STYLE_MSGBOX, "Criminal Justice Degrees: Unsolved Homecide", "Ms. Amelia Winters called the Police Department at approximately 8:45 p.m. Wednesday evening to report a robbery in her apartment.\nMs. Winters, who lives with three roommates, reported that she was alone in the apartment at the time of the incident.\nShe was reading in the living room when she heard a noise in the bedroom.\nShe did not immediately investigate the situation because she assumed that she must not have noticed one of her roommates returning home early.\nHowever, when her greetings went unanswered, she walked into the bedroom to see who was in the apartment.\nShe walked through her bedroom, looked into an adjoining bathroom and discovered a young Caucasian male,\napproximately 6 feet tall, age 14-16, standing in her shower, attempting to keep out of sight.\nHe had short brown hair and was wearing sunglasses. He was wearing a plain red t-shirt, blue jeans and black Nike sneakers.\nMs. Winters ordered the young man to leave, and he walked into the bedroom and climbed out of an open bedroom window.\nAfter he left, Ms. Winters suddenly grew fearful and went next door to a neighbor’s apartment to seek help and call the police.\nWhen she returned, she noticed that her purse had been stolen.\nShe did not know exactly when the purse had been stolen although she remembered that she had last seen it lying on her bed.\n\nIf you understand please proceed for test", "Start", "Back", CJD_CP1_Q_1);
    if (homicideID == CJD_CP1_Q_2) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSolveDHomicide, DIALOG_STYLE_MSGBOX, "Criminal Justice Degrees: Unsolved Homecide", "On August 1, 2009, the body of a woman was found in a wooded area outside of Troy. The cause of death was homicide.\nThe victim is described as a Hispanic female between the ages of 25-35 with dark brown hair and brown eyes.\nShe was approximately 5.55 feet tall and weighed 130 pounds.\nThe victim was found wearing a blueand-white striped T-shirt, white shorts, and white Nike tennis shoes.\nShe had three tattoos: an ivy pattern around her left ankle, a cross on her left shoulder and a daisy on her right hip.\nShe was found wearing five pieces of jewelry: a pair (2) of gold hoop earrings, a silver necklace with an amethyst pendant,\na sapphire ring with a gold setting on her left ring finger and a silver bracelet with a gold heart design.\nAlthough the media devoted extensive coverage to this case, the woman has not yet been identified.\n\nIf you understand please proceed for test", "Start", "Back", CJD_CP1_Q_2);
    return 1;
}

stock UnSolvedHomiceTest(playerid, homicideID) {
    if (homicideID == CJD_CP1_Q_1) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSHTestOptions, DIALOG_STYLE_MSGBOX, "Criminal Justice Degrees: Unsolved Homecide", "Question: Where was the suspected burglar hiding?\n\nA. In the living room.\nB. In the bedroom.\nC. Inside an adjoining bathroom in the shower.\nD. Just beneath an open bedroom window.\n\n\nSelect choosen option in next scree.", "Answer", "Back", CJD_CP1_Q_1);
    if (homicideID == CJD_CP1_Q_2) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSHTestOptions, DIALOG_STYLE_MSGBOX, "Criminal Justice Degrees: Unsolved Homecide", "Question: What articles of clothing was the victim wearing when her body was discovered?\n\nA. A red-and-white striped T-shirt, white shorts and white Nike tennis shoes.\nB. A blue-and-white striped sweatshirt, white shorts and white Nike tennis shoes.\nC. A blue-and-white striped T-shirt, white pants and white Nike tennis shoes.\nD. A blue-and-white striped T-shirt, white shorts and white Nike tennis shoes.\n\n\nSelect choosen option in next scree.", "Answer", "Back", CJD_CP1_Q_2);
    return 1;
}

stock UnSolvedHomiceTestOptions(playerid, homicideID) {
    if (homicideID == CJD_CP1_Q_1) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSolveDHomicideTest, DIALOG_STYLE_LIST, "Criminal Justice Degrees: Unsolved Homecide", "A. In the living room.\nB. In the bedroom.\nC. Inside an adjoining bathroom in the shower.\nD. Just beneath an open bedroom window.", "Answer", "Back", CJD_CP1_Q_1);
    if (homicideID == CJD_CP1_Q_2) return ShowPlayerDialogEx(playerid, CJD_DIalogID, CJD_CP_UnSolveDHomicideTest, DIALOG_STYLE_LIST, "Criminal Justice Degrees: Unsolved Homecide", "A. A red-and-white striped T-shirt, white shorts and white Nike tennis shoes.\nB. A blue-and-white striped sweatshirt, white shorts and white Nike tennis shoes.\nC. A blue-and-white striped T-shirt, white pants and white Nike tennis shoes.\nD. A blue-and-white striped T-shirt, white shorts and white Nike tennis shoes.", "Answer", "Back", CJD_CP1_Q_2);
    return 1;
}

stock UnSolvedHomiceTestResult(playerid, homicideID, answer) {
    if (homicideID == CJD_CP1_Q_1) {
        if (answer == 2) SendClientMessage(playerid, -1, "{4286f4}[Tutor]:{FFFFEE} very well cadet, you are heading into right path.");
        else SendClientMessage(playerid, -1, "{4286f4}[Tutor]:{FFFFEE} sorry cadet, you should have read it carefully, try next time.");
        UnSolvedHomiceStart(playerid, CJD_CP1_Q_2);
        return 1;
    }
    if (homicideID == CJD_CP1_Q_2) {
        if (answer == 3) SendClientMessage(playerid, -1, "{4286f4}[Tutor]:{FFFFEE} very well cadet, you have finished first lession.");
        else SendClientMessage(playerid, -1, "{4286f4}[Tutor]:{FFFFEE} sorry cadet, you should have read it carefully, try next time.");
        return 1;
    }
    return 1;
}

hook OnRequestCourseChapter(playerid, courseid, chapterId) {
    if (courseid != CJD_CourseID) return 1;

    CJD_StartChapter(playerid, chapterId);
    return ~1;
}

hook OnDialogResponseEx(playerid, dialogid, offsetid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (dialogid != CJD_DIalogID) return 1;
    if (offsetid == CJD_CP_UnSolveDHomicide) {
        if (!response) {
            Course:ShowChapterMenu(playerid, CJD_CourseID);
            return ~1;
        }
        UnSolvedHomiceTest(playerid, extraid);
        return ~1;
    }
    if (offsetid == CJD_CP_UnSHTestOptions) {
        if (!response) {
            CJD_StartChapter(playerid, extraid);
            return ~1;
        }
        UnSolvedHomiceTestOptions(playerid, extraid);
        return ~1;
    }
    if (offsetid == CJD_CP_UnSolveDHomicideTest) {
        if (!response) {
            CJD_StartChapter(playerid, extraid);
            return ~1;
        }
        UnSolvedHomiceTestResult(playerid, extraid, listitem);
        return ~1;
    }
    return ~1;
}