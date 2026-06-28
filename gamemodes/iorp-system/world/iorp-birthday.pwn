static BirthdayColumn[] = "Birthday2021Gift";

hook OnGameModeInit() {
    Database:AddColumn("playerdata", BirthdayColumn, "int", "1630702799");
    return 1;
}

hook OnPlayerLogin(playerid) {
    new time = gettime();
    if (time > 1630693800 && time < 1630799999) {
        SetPreciseTimer("BirthdayMsg", 2 * 60 * 1000, false, "d", playerid);
    }
    return 1;
}

forward BirthdayMsg(playerid);
public BirthdayMsg(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    AlexaMsg(playerid, "IORP is celebrating its birthday today, join your friends and celebrate.");
    AlexaMsg(playerid, "To claim your gifts, use /happybirthdayiorp.");
    AlexaMsg(playerid, "I appreciate you playing with us on this precious day.");
    return 1;
}

cmd:happybirthdayiorp(playerid, const params[]) {
    new time = gettime();
    if (time < 1630693800 || time > 1630780199) {
        return AlexaMsg(playerid, "Oh noes, my birthday was on the 4th of September, you missed it.");
    }
    if (gettime() - GetLoginTime(playerid) < 15 * 60) {
        return AlexaMsg(playerid, "Oh noes, To claim your reward, you must first celebrate IORP birthday with friends.");
    }
    new lastReward = Database:GetInt(GetPlayerNameEx(playerid), "username", BirthdayColumn, "playerdata");
    if (gettime() - lastReward < 60 * 60) {
        return AlexaMsg(playerid, "I don't have any gifts right now, try again later");
    }
    new money = RandomEx(5000, 10000);
    new bitcoins = RandomEx(4, 8);
    vault:PlayerVault(
        playerid, money, "IORP 2021 birthday reward",
        Vault_ID_Government, -money, sprintf("%s claimed IORP 2021 birthday reward", GetPlayerNameEx(playerid))
    );
    BitCoin:GiveOrTake(playerid, bitcoins, "IORP 2021 birthday reward");
    AlexaMsg(playerid, "Here is your reward for celebrating IORP's birthday. Enjoy your time playing.");
    AlexaMsg(playerid, sprintf("Money: %s Bitcoin: %d", FormatCurrency(money), bitcoins));
    Database:UpdateInt(gettime(), GetPlayerNameEx(playerid), "username", BirthdayColumn, "playerdata");
    return 1;
}