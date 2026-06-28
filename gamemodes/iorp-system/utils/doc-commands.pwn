HCP:OnInit(playerid, page) {
    if (page != 0) return 1;
    HCP:AddCommand(playerid, "Alexa Commands");
    HCP:AddCommand(playerid, "General Commands");
    HCP:AddCommand(playerid, "Roleplay Commands");
    if (GetPlayerVIPLevel(playerid) > 0) HCP:AddCommand(playerid, "Auto Roleplay Commands");
    if (GetPlayerVIPLevel(playerid) > 0) HCP:AddCommand(playerid, "VIP Commands");
    if (GetPlayerAdminLevel(playerid) > 0) HCP:AddCommand(playerid, "Admin Commands");
    if (IsPlayerMasterAdmin(playerid)) HCP:AddCommand(playerid, "Management Commands");
    return 1;
}

HCP:OnResponse(playerid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;

    if (IsStringSame("General Commands", inputtext)) {
        new info[2000];
        strcat(info, "{db6600}-----------------------------------------------------------------------------------------------n");
        strcat(info, "{db6600}/admins: {FFFFEE}check online management staff\n");
        strcat(info, "{db6600}/alexa: {FFFFEE}to talk with Alexa, your personal assistant who obeys your command.\n");
        strcat(info, "{db6600}/anim: {FFFFEE}to perform animations\n");
        strcat(info, "{db6600}/bitcoin: {FFFFEE}open premium player shop\n");
        strcat(info, "{db6600}/discord: {FFFFEE}link to: https://discord.gg/Xq9k3hr\n");
        strcat(info, "{db6600}/eject: {FFFFEE}eject other player from vehicle.\n");
        strcat(info, "{db6600}/gc: {FFFFEE}to talk in global chat\n");
        strcat(info, "{db6600}/pm, /rpm, /nopm: {FFFFEE}personal message commands\n");
        strcat(info, "{db6600}/pocket or /p or H+SPACE: {FFFFEE}to open your pocket, all in one solution for commands\n");
        strcat(info, "{db6600}/report: {FFFFEE}report player to administrators.\n");
        strcat(info, "{db6600}/s: {FFFFEE}to talk with nearest player using TTS\n");
        strcat(info, "{db6600}/v: {FFFFEE}vehicle gui controls.\n");
        strcat(info, "{db6600}-----------------------------------------------------------------------------------------------n");
        ShowInfo(playerid, "General Commands", info);
        return ~1;
    }

    if (IsStringSame("Roleplay Commands", inputtext)) {
        new info[2000];
        format(info, sizeof info, "");
        strcat(info, "{db6600}-------------------------------------------------------------------------------------------------------------------------------\n");
        strcat(info, "{db6600}/ad: {FFFFEE}Used to send an advertisement to the server, the fee for posting an advertisement is $500.\n");
        strcat(info, "{db6600}/call: {FFFFEE}A cmd for IC chat on call.\n");
        strcat(info, "{db6600}/do: {FFFFEE}IC emote . Used if you want to ask something roleplay wise or something what can't begin with your character name.\n");
        strcat(info, "{db6600}/em : {FFFFEE}A suggested use could be to announce a sort of atmosphere.\n");
        strcat(info, "{db6600}/fchat: {FFFFEE}Faction chat.\n");
        strcat(info, "{db6600}/fightmode: {FFFFEE}While roleplaying, to engage in extreme combat that involves shooting and killing.\n");
        strcat(info, "{db6600}/fr: {FFFFEE}Fake Roleplay is used for represent a person or authority.\n");
        strcat(info, "{db6600}/me: {FFFFEE}Displays an action or emote your character is performing.\n");
        strcat(info, "{db6600}/my: {FFFFEE}Same as /me, except instead of the `Name` prefix, you get `name's`.\n");
        strcat(info, "{db6600}/pu: {FFFFEE}Pull Over.\n");
        strcat(info, "{db6600}/radio: {FFFFEE}Radio for law factions only.\n");
        strcat(info, "{db6600}/say: {FFFFEE}A cmd for IC chat while Roleplay.\n");
        strcat(info, "{db6600}/shout: {FFFFEE}A cmd for IC shout while Roleplay.\n");
        strcat(info, "{db6600}/t: {FFFFEE}Express your thought while in character in RolePlay.\n");
        strcat(info, "{db6600}/w: {FFFFEE}Whisper to a specific player while Roleplay.\n");
        strcat(info, "{db6600}-------------------------------------------------------------------------------------------------------------------------------\n");
        ShowInfo(playerid, "Roleplay Commands", info);
        return ~1;
    }

    if (IsStringSame("Auto Roleplay Commands", inputtext)) {
        new info[2000];
        format(info, sizeof info, "");
        strcat(info, "{db6600}-------------------------------------------------------------------\n");
        strcat(info, "{db6600}/rpgun: {FFFFEE}use it when you are ready to engage a fight.\n");
        strcat(info, "{db6600}/rpgunout: {FFFFEE}use it to show, gun out rp.\n");
        strcat(info, "{db6600}/rpgunput: {FFFFEE}use it to show, gun put rp.\n");
        strcat(info, "{db6600}/rpsurrender: {FFFFEE}use it to surrender yourself.\n");
        strcat(info, "{db6600}/rpenginestart: {FFFFEE}use it to show engine start rp.\n");
        strcat(info, "{db6600}/rpenginestop: {FFFFEE}use it to show engine stop rp.\n");
        strcat(info, "{db6600}/rphouseunlock: {FFFFEE}use it to show house unlock door rp.\n");
        strcat(info, "{db6600}/rphouselock: {FFFFEE}use it show house lock rp.\n");
        strcat(info, "{db6600}/rpbath: {FFFFEE}use it to show bath rp.\n");
        strcat(info, "{db6600}/rpcuff: {FFFFEE}use it to cuff a player (for cops).\n");
        strcat(info, "{db6600}/rparrest: {FFFFEE}use it to arrest someone (for cops).\n");
        strcat(info, "{db6600}/rphandsup: {FFFFEE}use it to ask for handsup (for cops).\n");
        strcat(info, "{db6600}/rpbodycheck: {FFFFEE}use it to for body search (for cops).\n");
        strcat(info, "{db6600}/rpapproach: {FFFFEE}use it to approach a suspect (for cops).\n");
        strcat(info, "{db6600}--------------------------------------------------------------------\n");
        ShowInfo(playerid, "Auto Roleplay Commands", info);
        return ~1;
    }

    if (IsStringSame("Alexa Commands", inputtext)) {
        new info[2000];
        strcat(info, "{db6600}>> Alexa Commands - {FFFFEE}use {db6600}/alexa [command]\n");
        strcat(info, "{db6600}General:{FFFFEE} help, unbug me, chat animation, achievements, race system\n");
        strcat(info, "{db6600}General:{FFFFEE} hide/show motives, sleep/awake mode\n");
        strcat(info, "{db6600}Utilities:{FFFFEE} pocket, gps, patch status, clean/fix screen, chat mode\n");
        strcat(info, "{db6600}Sucide:{FFFFEE} i want to suicide, please kill me\n");

        if (GetPlayerVIPLevel(playerid) > 0) {
            strcat(info, "\n");
            strcat(info, "{db6600}>> VIP Commands\n");
            strcat(info, "{db6600}Phone:{FFFFEE} phone, tablet, dial, answer, pickup, hangup, my number, whatsapp\n");
            strcat(info, "{db6600}Vehicles:{FFFFEE} my cars, vipspawn, viprepair, viprefuel, vipmod, auto/manual gear\n");
            strcat(info, "{db6600}Vehicle :{FFFFEE} neon, xenon, halloween, engine, lights, bonnet, doors, alarm, windows \n");
            strcat(info, "{db6600}Character:{FFFFEE} license, change skin, family\n");
            strcat(info, "{db6600}Property:{FFFFEE} viphouseint, faction locker, factions\n");
            strcat(info, "{db6600}Entertainment:{FFFFEE} gamezone, minigames, race system\n");
            strcat(info, "{db6600}Features:{FFFFEE} vipweather, vipflamminghand, vipghostrider, math\n");
        }

        if (GetPlayerAdminLevel(playerid) > 0) {
            strcat(info, "\n");
            strcat(info, "{db6600}>> Admin Commands {FFFFEE}\n");
            strcat(info, "respawn, tp, goto, get, getvehicle, gotovehicle, sethealth, setarmour, freeze/unfreeze\n");
            strcat(info, "enable/disable management tag\n");
            if (GetPlayerAdminLevel(playerid) == 3) {
                strcat(info, "spawn, sumo map, wanted database, enable/disable global chat\n");
            }
        }

        ShowInfo(playerid, "Alexa Commands", info);
        return ~1;
    }

    if (IsStringSame("VIP Commands", inputtext)) {
        new info[2000];
        strcat(info, "{db6600}---------------------------------------------------\n");
        strcat(info, "{db6600}/vsay: {FFFFEE}Send message to all players.\n");
        strcat(info, "{db6600}/vchat: {FFFFEE}Send message to vip players.\n");
        strcat(info, "{db6600}/findbackpack: {FFFFEE}find backpack.\n");
        strcat(info, "{db6600}/vipcar: {FFFFEE}Spawn top cars.\n");
        strcat(info, "{db6600}---------------------------------------------------\n");
        ShowInfo(playerid, "VIP Commands", info);
        return ~1;
    }

    if (IsStringSame("Admin Commands", inputtext)) {
        new info[2000];
        format(info, sizeof info, "");
        strcat(info, "{db6600}---------------------------------------------------\n");
        strcat(info, "{db6600}/aplayer: {FFFFEE}open player administration panel.\n");
        strcat(info, "{db6600}/acp: {FFFFEE}open admin control panel.\n");
        strcat(info, "{db6600}/asay: {FFFFEE}send admin message to everyone.\n");
        strcat(info, "{db6600}/achat: {FFFFEE}admin chat.\n");
        strcat(info, "{db6600}---------------------------------------------------\n");
        ShowInfo(playerid, "Admin Commands", info);
        return ~1;
    }

    if (IsStringSame("Management Commands", inputtext)) {
        new info[2000];
        format(info, sizeof info, "");
        strcat(info, "{db6600}--------------------------------------------------------------------\n");
        strcat(info, "{db6600}/ascp: {FFFFEE}open system control panel.\n");
        strcat(info, "{db6600}/setadmin: {FFFFEE}set player's admin level.\n");
        strcat(info, "{db6600}/setvip: {FFFFEE}set player's VIP level.\n");
        strcat(info, "{db6600}/setmasteradmin: {FFFFEE}grant or revoke master admin access.\n");
        strcat(info, "{db6600}/ban: {FFFFEE}temporarily ban an account.\n");
        strcat(info, "{db6600}/unban: {FFFFEE}remove account ban.\n");
        strcat(info, "{db6600}/enableaccount: {FFFFEE}reactivate an account.\n");
        strcat(info, "{db6600}/disableaccount: {FFFFEE}permanently disable an account.\n");
        strcat(info, "{db6600}/changeaccountpassword: {FFFFEE}change account password.\n");
        strcat(info, "{db6600}/updatename: {FFFFEE}rename an account.\n");
        strcat(info, "{db6600}/approvename: {FFFFEE}approve a name change request.\n");
        strcat(info, "{db6600}/rejectname: {FFFFEE}reject a name change request.\n");
        strcat(info, "{db6600}/refund: {FFFFEE}issue a refund to a player.\n");
        strcat(info, "{db6600}/unbug: {FFFFEE}unstuck a player account.\n");
        strcat(info, "{db6600}/givebitcoin: {FFFFEE}give or remove bitcoins.\n");
        strcat(info, "{db6600}/getadmins: {FFFFEE}view all admins.\n");
        strcat(info, "{db6600}/getmasteradmins: {FFFFEE}view all master admins.\n");
        strcat(info, "{db6600}/getalldebt: {FFFFEE}view all players with debt.\n");
        strcat(info, "{db6600}/getdebt: {FFFFEE}view a player's debt history.\n");
        strcat(info, "{db6600}/givedebt: {FFFFEE}assign debt to a player.\n");
        strcat(info, "{db6600}/resetdebt: {FFFFEE}reset a player's debt.\n");
        strcat(info, "{db6600}/setbankpassword: {FFFFEE}change bank account password.\n");
        strcat(info, "{db6600}/enablebankaccount: {FFFFEE}enable a bank account.\n");
        strcat(info, "{db6600}/disablebankaccount: {FFFFEE}disable a bank account.\n");
        strcat(info, "{db6600}/setfaction: {FFFFEE}assign faction and rank.\n");
        strcat(info, "{db6600}/removefaction: {FFFFEE}remove player from faction.\n");
        strcat(info, "{db6600}--------------------------------------------------------------------\n");
        ShowInfo(playerid, "Management Commands", info);
        return ~1;
    }

    return 1;
}

stock ShowInfo(playerid, const caption[], const info[]) {
    return FlexPlayerDialog(playerid, "ShowInfo", DIALOG_STYLE_MSGBOX, caption, info, "Okay", "");
}

FlexDialog:ShowInfo(playerid, response, listitem, const inputtext[], extraid, const payload[]) {
    return HCP:Init(playerid);
}