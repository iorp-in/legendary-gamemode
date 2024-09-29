#define MaxCourse 20
#define MaxChapters 20

enum CourseEnum {
    ctitle[50],
        DurationForEachChapter, // ask duration in minutes
        CourseFees, // ask for course fees, should be big so that player's don't do often and care for it
}
enum ChapterEnum {
    ChapTitle[50]
}
new CourseData[MaxCourse][CourseEnum];
new ChapterData[MaxCourse][MaxChapters][ChapterEnum];

enum pCourseEnum {
    bool:isCompleted,
    bool:isApplied,
    CompletedOn,
    PercentageObtained,
    lastChapterAppliedAt, // ask for when player applied last course, so that he can start another course after durationforeachchapter
}
new bool:PlayerCourseData[MAX_PLAYERS][MaxCourse][pCourseEnum];
enum pChapterEnum {
    bool:isCompleted,
    bool:isApplied,
    CompletedOn
}
new bool:PlayerChapterData[MAX_PLAYERS][MaxCourse][MaxChapters][pChapterEnum];

new Iterator:Chapters[MaxCourse] < MaxChapters > ;
new Iterator:Courses < MaxCourse > ;

stock Course:Add(const title[], DurationForEachChapterInMIns, courseFees) {
    new courseid = Iter_Free(Courses);
    if (courseid == INVALID_ITERATOR_SLOT) return -1;
    format(CourseData[courseid][ctitle], 50, "%s", title);
    CourseData[courseid][DurationForEachChapter] = DurationForEachChapterInMIns;
    CourseData[courseid][CourseFees] = courseFees;
    Iter_Add(Courses, courseid);
    return courseid;
}

stock Course:GetTotalChapters(courseid) {
    if (!Iter_Contains(Courses, courseid)) return -1;
    return Iter_Count(Chapters[courseid]);
}

stock Course:GetTotalMins(courseid) {
    new totalChapters = Course:GetTotalChapters(courseid);
    new timeforEachCourse = CourseData[courseid][DurationForEachChapter];
    return totalChapters * timeforEachCourse;
}

stock Course:AddChapter(courseid, const chapterTitle[]) {
    if (!Iter_Contains(Courses, courseid)) return -1;
    new chapterId = Iter_Free(Chapters[courseid]);
    if (chapterId == INVALID_ITERATOR_SLOT) return -1;
    format(ChapterData[courseid][chapterId][ChapTitle], 50, "%s", chapterTitle);
    Iter_Add(Chapters[courseid], chapterId);
    return chapterId;
}

stock Course:SetPlayerState(playerid, courseid, bool:isapplied = false, lastchapterappliedat = 0, bool:iscompleted = false, completedon = 0, percentageobtained = 0) {
    PlayerCourseData[playerid][courseid][isCompleted] = iscompleted;
    PlayerCourseData[playerid][courseid][isApplied] = isapplied;
    PlayerCourseData[playerid][courseid][lastChapterAppliedAt] = lastchapterappliedat;
    PlayerCourseData[playerid][courseid][CompletedOn] = completedon;
    PlayerCourseData[playerid][courseid][PercentageObtained] = percentageobtained;
    return 1;
}

stock Course:SetPlayerChapterState(playerid, courseid, chapterid, bool:iscompleted = false, bool:isapplied = false, completedon = 0) {
    PlayerChapterData[playerid][courseid][chapterid][isCompleted] = iscompleted;
    PlayerChapterData[playerid][courseid][chapterid][isApplied] = isapplied;
    PlayerChapterData[playerid][courseid][chapterid][CompletedOn] = completedon;
    return 1;
}

stock Course:GetCompletedCount(playerid) {
    new passed = 0;
    foreach(new courseid:Courses) {
        if (PlayerCourseData[playerid][courseid][isCompleted]) passed++;
    }
    return passed;
}

stock Course:GetPursuingCount(playerid) {
    new passed = 0;
    foreach(new courseid:Courses) {
        if (PlayerCourseData[playerid][courseid][isApplied] && !PlayerCourseData[playerid][courseid][isCompleted]) passed++;
    }
    return passed;
}

stock Course:IsPlayerHavingAnyCourse(playerid) {
    foreach(new courseid:Courses) {
        if (PlayerCourseData[playerid][courseid][isApplied] == true && PlayerCourseData[playerid][courseid][isCompleted] == false) return 1;
    }
    return 0;
}

stock Course:GetPlayerHavingCourseID(playerid) {
    foreach(new courseid:Courses) {
        if (PlayerCourseData[playerid][courseid][isApplied] == true && PlayerCourseData[playerid][courseid][isCompleted] == false) return courseid;
    }
    return -1;
}

forward OnRequestCourseJoin(playerid, courseid);
public OnRequestCourseJoin(playerid, courseid) {
    return 1;
}

forward OnRequestCourseLeave(playerid, courseid);
public OnRequestCourseLeave(playerid, courseid) {
    return 1;
}

forward OnRequestCourseChapter(playerid, courseid, chapterId);
public OnRequestCourseChapter(playerid, courseid, chapterId) {
    return 1;
}

stock Course:ApproveApplication(playerid, courseid) {
    PlayerCourseData[playerid][courseid][isApplied] = true;
    SendClientMessage(playerid, -1, sprintf("{4286f4}[University]: {FFFFEE}You are enrolled for a %s course at the university.", CourseData[courseid][ctitle]));
    SendClientMessage(playerid, -1, "{4286f4}[University]: {FFFFEE}Please be regular and complete your classes regularly.");
    SendClientMessage(playerid, -1, "{4286f4}[University]: {FFFFEE}Once you complete all the chapters, you will get your degree.");
    Course:ShowChapterMenu(playerid, courseid);
    return 1;
}

forward OnPlayerRequestDegree(playerid, courseid);
public OnPlayerRequestDegree(playerid, courseid) {
    return 1;
}

UCP:OnInit(playerid, page) {
    if (page != 1) return 1;
    if (Course:GetCompletedCount(playerid) != 0) UCP:AddCommand(playerid, "View Graduation Certificates");
    return 1;
}

UCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    if (IsStringSame("View Graduation Certificates", inputtext)) {
        Course:ShowCompletedMenu(playerid);
        return ~1;
    }
    return 1;
}

stock Course:ViewDegree(playerid, courseid, toplayer) {
    new string[2000];
    strcat(string, sprintf("Applocant Name: %s\n", GetPlayerNameEx(playerid)));
    strcat(string, sprintf("Course Name: %s\n", CourseData[courseid][ctitle]));
    strcat(string, sprintf("Total Chapters: %d\n", Course:GetTotalChapters(courseid)));
    foreach(new chapterid:Chapters[courseid]) {
        strcat(string, sprintf("\tChapter %d: %s [Completed At: %s]\n", chapterid, ChapterData[courseid][chapterid][ChapTitle], UnixToHumanEx(PlayerChapterData[playerid][courseid][chapterid][CompletedOn])));
    }
    strcat(string, sprintf("Obtained Percentage: %d/100\n", PlayerCourseData[playerid][courseid][PercentageObtained]));
    strcat(string, sprintf("Completed On: %s\n", UnixToHumanEx(PlayerCourseData[playerid][courseid][CompletedOn])));
    return FlexPlayerDialog(toplayer, "CourseViewDegree", DIALOG_STYLE_MSGBOX, "University: Course Degree", string, "Okay", "");
}

hook OnPlayerRequestShop(playerid, shopid) {
    if (shopid != 29) return 1;
    Course:ShowMenu(playerid);
    return ~1;
}

stock Course:ShowMenu(playerid) {
    new string[2000];
    strcat(string, "Course ID\tTitle\tFee\tStatus\n");
    foreach(new courseid:Courses) {
        strcat(
            string,
            sprintf(
                "%d\t%s\t$%s\t%s\n",
                courseid,
                CourseData[courseid][ctitle],
                FormatCurrency(CourseData[courseid][CourseFees]),
                PlayerCourseData[playerid][courseid][isApplied] == false ?
                ("Not applied") : PlayerCourseData[playerid][courseid][isCompleted] == false ? "Pursuing" : "Graduated")
        );
    }
    return FlexPlayerDialog(playerid, "CourseShowMenu", DIALOG_STYLE_TABLIST_HEADERS, "University: Select your course", string, "Select", "Close");
}

FlexDialog:CourseShowMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    new courseid = strval(inputtext);
    if (PlayerCourseData[playerid][courseid][isApplied] == false && PlayerCourseData[playerid][courseid][isCompleted] == false) return Course:ApplyNew(playerid, courseid);
    if (PlayerCourseData[playerid][courseid][isApplied] == true && PlayerCourseData[playerid][courseid][isCompleted] == false) return Course:ShowChapterMenu(playerid, courseid);
    if (PlayerCourseData[playerid][courseid][isApplied] == true && PlayerCourseData[playerid][courseid][isCompleted] == true)
        return CallRemoteFunction("OnPlayerRequestDegree", "dd", playerid, courseid);
    return 1;
}

stock Course:ApplyNew(playerid, courseid) {
    if (Course:IsPlayerHavingAnyCourse(playerid)) {
        SendClientMessage(playerid, -1, "{4286f4}[University]: {FFFFEE}You already have an application for another course. You can't apply for this.");
        SendClientMessage(playerid, -1, "{4286f4}[University]: {FFFFEE}If you want to change course, you must cancel or complete your first applied course.");
        return Course:ShowMenu(playerid);
    }
    new string[2000];
    strcat(string, sprintf("Course Name: %s\n", CourseData[courseid][ctitle]));
    strcat(string, sprintf("Total Chapters: %d\n", Course:GetTotalChapters(courseid)));
    foreach(new chapterid:Chapters[courseid]) {
        strcat(string, sprintf("\tChapter %d: %s\n", chapterid, ChapterData[courseid][chapterid][ChapTitle]));
    }
    strcat(string, sprintf("\nEstimated time to complete this course is: %s\n", secondsToDHM(Course:GetTotalChapters(courseid) * Course:GetTotalMins(courseid) * 60)));
    strcat(string, sprintf("Course Fee: %d\n", CourseData[courseid][CourseFees]));
    strcat(string, sprintf("\n\nDo you want to apply this course?", CourseData[courseid][CourseFees]));
    return FlexPlayerDialog(playerid, "CourseApplyNew", DIALOG_STYLE_MSGBOX, "University: Apply Course", string, "Yes", "Back", courseid);
}

FlexDialog:CourseApplyNew(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return Course:ShowMenu(playerid);
    CallRemoteFunction("OnRequestCourseJoin", "dd", playerid, extraid);
    return 1;
}

stock Course:ShowCompletedMenu(playerid) {
    new string[2000];
    strcat(string, "Course ID\tTitle\tFee\tStatus\n");
    foreach(new courseid:Courses) {
        if (PlayerCourseData[playerid][courseid][isCompleted]) {
            strcat(
                string,
                sprintf(
                    "%d\t%s\t$%s\t%s\n",
                    courseid,
                    CourseData[courseid][ctitle],
                    FormatCurrency(CourseData[courseid][CourseFees]),
                    PlayerCourseData[playerid][courseid][isApplied] == false ?
                    ("Not applied") : PlayerCourseData[playerid][courseid][isCompleted] == false ? "Pursuing" : "Graduated"
                )
            );
        }
    }
    return FlexPlayerDialog(playerid, "CourseShowCompletedMenu", DIALOG_STYLE_TABLIST_HEADERS, "University: Select your course", string, "Select", "Close");
}

FlexDialog:CourseShowCompletedMenu(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    if (!response) return 1;
    CallRemoteFunction("OnPlayerRequestDegree", "dd", playerid, strval(inputtext));
    return 1;
}

stock Course:ShowChapterMenu(playerid, courseid) {
    if (!Iter_Contains(Courses, courseid)) return -1;
    new string[2000];
    strcat(string, "Chapter\tTitle\tStatus\n");
    foreach(new chapterid:Chapters[courseid]) {
        strcat(string, sprintf("%d\t%s\t%s\n", chapterid, ChapterData[courseid][chapterid][ChapTitle], (PlayerChapterData[playerid][courseid][chapterid][isApplied] == false && PlayerChapterData[playerid][courseid][chapterid][isCompleted] == false) ? "Not applied"
            : PlayerChapterData[playerid][courseid][chapterid][isCompleted] == false ? "Pursuing" : "Graduated"));
    }
    strcat(string, "Leave Course");
    return FlexPlayerDialog(playerid, "CourseShowChapterMenu", DIALOG_STYLE_TABLIST_HEADERS, "University: Select your chapter to start", string, "Select", "Close", courseid);
}

FlexDialog:CourseShowChapterMenu(playerid, response, listitem, const inputtext[], courseid, const payload[]) {
    if (!response) return Course:ShowMenu(playerid);
    if (IsStringSame(inputtext, "Leave Course")) return CallRemoteFunction("OnRequestCourseLeave", "dd", playerid, courseid);
    new chapterId = strval(inputtext);
    new currentTime = gettime();
    new lastApplied = PlayerCourseData[playerid][courseid][lastChapterAppliedAt];
    new timeDiffInMins = CourseData[courseid][DurationForEachChapter];
    new chapterStartAfer = lastApplied + (timeDiffInMins * 60);
    if (currentTime > chapterStartAfer) return CallRemoteFunction("OnRequestCourseChapter", "ddd", playerid, courseid, chapterId);
    SendClientMessage(playerid, -1, sprintf("{4286f4}[University]: {FFFFEE}you can not start next chapter, wait till %s to start it.", UnixToHumanEx(chapterStartAfer)));
    return Course:ShowChapterMenu(playerid, courseid);
}

// courses add
#include <YSI_Coding\y_hooks>
#include "IORP_SYSTEM/systems/courses/Weapon Specialist Degree.pwn"