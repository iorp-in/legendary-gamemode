new roleplay_rules;

hook OnGameModeInit() {
    roleplay_rules = Doc:GetFreeID();
    new string[2000];
    strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    strcat(string, "{FFFFEE}PLEASE READ THE R U L E S CAREFULLY AND THOROUGHLY.\n");
    strcat(string, "{FFFFEE}Any broken rule lead you to permanent ban from server.\n");
    strcat(string, "{FFFFEE}Thanks with love.\n");
    strcat(string, "\n{FFFFEE}press ESC or Cancel to close roleplay rules\n");
    strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    Doc:Add(0, roleplay_rules, "Roleplay Rules", string);
    return 1;
}


Doc:OnResponse(playerid, docid, response) {
    if (docid == roleplay_rules) {
        if (response) ShowRolePlayGuide(playerid);
        return ~1;
    }
    return 1;
}

stock ShowRolePlayGuide(playerid, intro_id = 0) {
    new string[2000];
    if (intro_id == 0) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}RP: Roleplaying\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Taking the role of a specific individual, acting their life out in the path you see fit.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 1) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}CK: Character Kill\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Suicide, any form of killing yourself that kills them permanently.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 2) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}PK: Player Kill\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}When another player kills you, for example shootout or fight. You goto hospital, get treated and stay alive though.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 3) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}MG: Metagaming\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Using OOC info for an IC benefit.\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Ex. I am spectating John, and another gang is around the corner. I TP to him, ICly tell him that they're round the corner and go away.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 4) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}PG: Post Gaming\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Forcing roleplay on another individual, causing potential unfair and unrealistic actions.\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Ex. John is surrounded by SWAT with M4's, he pulls a knife out and kills them all instantly without even giving them time to react.\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Ex. \"/me hits someone knocking them out\" there is no reaction time given.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 5) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}BH: Bunnyhopping\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Repeatedly jumping around to get somewhere quicker.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 6) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}Chicken Running\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Running around in a Zig-Zag so they can't get a shot on you.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 7) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}DM: Deathmatching\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Killing someone without a valid RP reason.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 8) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}IC: In Character\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Anything that happens RPly within your character's life.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else if (intro_id == 9) {
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(string, "{db6600}[Rule]: {ff6666}OOC: Out Of Character\n");
        strcat(string, "{db6600}[Description]: {FFFFEE}Anything that happens in real life, or not concerning the roleplay.\n");
        strcat(string, "{db6600}[Punishment]: {FFFFEE}Jailed, Kicked, Fined, frozen etc.\n");
        strcat(string, "{db6600}---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    } else {
        return 1;
    }
    return FlexPlayerDialog(playerid, "ShowRolePlayGuide", DIALOG_STYLE_MSGBOX, "{4286f4}[Alexa]: {FFFFEE}Roleplay Rules", string, "Next", "Close", intro_id);
}

FlexDialog:ShowRolePlayGuide(playerid, response, listitem, const inputtext[], intro_id, const payload[]) {
    if (!response) return 1;
    return ShowRolePlayGuide(playerid, intro_id + 1);
}