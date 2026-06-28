#define BackpackInvColumn_Oral_Antihistamines "Oral_Antihistamines"
#define BackpackInvColumn_Ditropan_XL "Ditropan_XL"
#define BackpackInvColumn_Benzodiazepines "Benzodiazepines"
#define BackpackInvColumn_Temazepam "Temazepam"
#define BackpackInvColumn_Bismuth_Subsalicylate "Bismuth_Subsalicylate"

hook OnInventoryInit() {
    InvMed_OralAntihistamine = Backpack:AddInventoryItem("Oral_Antihistamines", InvLimit_Oral_Antihistamines);
    InvMed_DitropanXL = Backpack:AddInventoryItem("Ditropan_XL", InvLimit_Ditropan_XL);
    InvMed_Benzodiazepine = Backpack:AddInventoryItem("Benzodiazepines", InvLimit_Benzodiazepines);
    InvMed_Temazepam = Backpack:AddInventoryItem("Temazepam", InvLimit_Temazepam);
    InvMed_BismuthSubsalicylate = Backpack:AddInventoryItem("Bismuth_Subsalicylate", InvLimit_Bismuth_Subsalicylate);
    Database:AddColumn(BackpackDB, BackpackInvColumn_Oral_Antihistamines, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Ditropan_XL, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Benzodiazepines, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Temazepam, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Bismuth_Subsalicylate, "int", "0");
    return 1;
}

hook OnBackpackLoad(backPackId) {
    Backpack:PushItem(backPackId, InvMed_OralAntihistamine, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Oral_Antihistamines, BackpackDB));
    Backpack:PushItem(backPackId, InvMed_DitropanXL, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Ditropan_XL, BackpackDB));
    Backpack:PushItem(backPackId, InvMed_Benzodiazepine, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Benzodiazepines, BackpackDB));
    Backpack:PushItem(backPackId, InvMed_Temazepam, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Temazepam, BackpackDB));
    Backpack:PushItem(backPackId, InvMed_BismuthSubsalicylate, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Bismuth_Subsalicylate, BackpackDB));
    return 1;
}

hook OnBackpackSave(backPackId) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvMed_OralAntihistamine), sprintf("%d", backPackId), "id", BackpackInvColumn_Oral_Antihistamines, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvMed_DitropanXL), sprintf("%d", backPackId), "id", BackpackInvColumn_Ditropan_XL, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvMed_Benzodiazepine), sprintf("%d", backPackId), "id", BackpackInvColumn_Benzodiazepines, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvMed_Temazepam), sprintf("%d", backPackId), "id", BackpackInvColumn_Temazepam, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, InvMed_BismuthSubsalicylate), sprintf("%d", backPackId), "id", BackpackInvColumn_Bismuth_Subsalicylate, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backPackId) {
    Backpack:PopItem(backPackId, InvMed_OralAntihistamine, Backpack:GetInvItemQuantity(backPackId, InvMed_OralAntihistamine));
    Backpack:PopItem(backPackId, InvMed_DitropanXL, Backpack:GetInvItemQuantity(backPackId, InvMed_DitropanXL));
    Backpack:PopItem(backPackId, InvMed_Benzodiazepine, Backpack:GetInvItemQuantity(backPackId, InvMed_Benzodiazepine));
    Backpack:PopItem(backPackId, InvMed_Temazepam, Backpack:GetInvItemQuantity(backPackId, InvMed_Temazepam));
    Backpack:PopItem(backPackId, InvMed_BismuthSubsalicylate, Backpack:GetInvItemQuantity(backPackId, InvMed_BismuthSubsalicylate));
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId == InvMed_OralAntihistamine) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_OralAntihistamine) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Oral_antihistamines);
            Backpack:PopItem(backPackId, InvMed_OralAntihistamine, 1);
        }
        return ~1;
    }
    if (inventoryId == InvMed_DitropanXL) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_DitropanXL) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Ditropan_XL);
            Backpack:PopItem(backPackId, InvMed_DitropanXL, 1);
        }
        return ~1;
    }
    if (inventoryId == InvMed_Benzodiazepine) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_Benzodiazepine) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Benzodiazepines);
            Backpack:PopItem(backPackId, InvMed_Benzodiazepine, 1);
        }
        return ~1;
    }
    if (inventoryId == InvMed_Temazepam) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_Temazepam) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Temazepam);
            Backpack:PopItem(backPackId, InvMed_Temazepam, 1);
        }
        return ~1;
    }
    if (inventoryId == InvMed_BismuthSubsalicylate) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_BismuthSubsalicylate) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Bismuth_Subsalicylate);
            Backpack:PopItem(backPackId, InvMed_BismuthSubsalicylate, 1);
        }
        return ~1;
    }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return 1;
    if (Backpack:GetInvItemQuantity(backPackId, InvMed_OralAntihistamine) > 0) QuickActions:AddCommand(playerid, "Give player Oral_Antihistamines medicine");
    if (Backpack:GetInvItemQuantity(backPackId, InvMed_DitropanXL) > 0) QuickActions:AddCommand(playerid, "Give player Ditropan_XL medicine");
    if (Backpack:GetInvItemQuantity(backPackId, InvMed_Benzodiazepine) > 0) QuickActions:AddCommand(playerid, "Give player Benzodiazepines medicine");
    if (Backpack:GetInvItemQuantity(backPackId, InvMed_Temazepam) > 0) QuickActions:AddCommand(playerid, "Give player Temazepam medicine");
    if (Backpack:GetInvItemQuantity(backPackId, InvMed_BismuthSubsalicylate) > 0) QuickActions:AddCommand(playerid, "Give player Bismuth_Subsalicylate medicine");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return 1;
    if (!strcmp("Give player Oral_Antihistamines medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_OralAntihistamine) < 1) return ~1;
        Backpack:PopItem(backPackId, InvMed_OralAntihistamine, 1);
        CallMedicineTake(targetid, InvMed_OralAntihistamine);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Oral_Antihistamines from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Oral_Antihistamines from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Ditropan_XL medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_DitropanXL) < 1) return ~1;
        Backpack:PopItem(backPackId, InvMed_DitropanXL, 1);
        CallMedicineTake(targetid, InvMed_DitropanXL);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Ditropan_XL from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Ditropan_XL from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Benzodiazepines medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_Benzodiazepine) < 1) return ~1;
        Backpack:PopItem(backPackId, InvMed_Benzodiazepine, 1);
        CallMedicineTake(targetid, InvMed_Benzodiazepine);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Benzodiazepines from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Benzodiazepines from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Temazepam medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_Temazepam) < 1) return ~1;
        Backpack:PopItem(backPackId, InvMed_Temazepam, 1);
        CallMedicineTake(targetid, InvMed_Temazepam);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Temazepam from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Temazepam from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Bismuth_Subsalicylate medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, InvMed_BismuthSubsalicylate) < 1) return ~1;
        Backpack:PopItem(backPackId, InvMed_BismuthSubsalicylate, 1);
        CallMedicineTake(targetid, InvMed_BismuthSubsalicylate);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Bismuth_Subsalicylate from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Bismuth_Subsalicylate from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    return 1;
}