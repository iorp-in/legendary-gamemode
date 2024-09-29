#define BackpackInvColumn_Oral_Antihistamines "Oral_Antihistamines"
#define InvLimit_Oral_Antihistamines 10
#define BackpackInvColumn_Ditropan_XL "Ditropan_XL"
#define InvLimit_Ditropan_XL 10
#define BackpackInvColumn_Benzodiazepines "Benzodiazepines"
#define InvLimit_Benzodiazepines 10
#define BackpackInvColumn_Temazepam "Temazepam"
#define InvLimit_Temazepam 10
#define BackpackInvColumn_Bismuth_Subsalicylate "Bismuth_Subsalicylate"
#define InvLimit_Bismuth_Subsalicylate 10

new MedicineInvID_Oral_Antihist, MedicineInvID_Ditropan_XL,
MedicineInvID_Benzodiazepines, MedicineInvID_Temazepam, MedicineInvID_Bismuth_Sub;

hook OnInventoryInit() {
    MedicineInvID_Oral_Antihist = Backpack:AddInventoryItem("Oral_Antihistamines", InvLimit_Oral_Antihistamines);
    MedicineInvID_Ditropan_XL = Backpack:AddInventoryItem("Ditropan_XL", InvLimit_Ditropan_XL);
    MedicineInvID_Benzodiazepines = Backpack:AddInventoryItem("Benzodiazepines", InvLimit_Benzodiazepines);
    MedicineInvID_Temazepam = Backpack:AddInventoryItem("Temazepam", InvLimit_Temazepam);
    MedicineInvID_Bismuth_Sub = Backpack:AddInventoryItem("Bismuth_Subsalicylate", InvLimit_Bismuth_Subsalicylate);
    Database:AddColumn(BackpackDB, BackpackInvColumn_Oral_Antihistamines, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Ditropan_XL, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Benzodiazepines, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Temazepam, "int", "0");
    Database:AddColumn(BackpackDB, BackpackInvColumn_Bismuth_Subsalicylate, "int", "0");
    return 1;
}

hook OnBackpackLoad(backPackId) {
    Backpack:PushItem(backPackId, MedicineInvID_Oral_Antihist, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Oral_Antihistamines, BackpackDB));
    Backpack:PushItem(backPackId, MedicineInvID_Ditropan_XL, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Ditropan_XL, BackpackDB));
    Backpack:PushItem(backPackId, MedicineInvID_Benzodiazepines, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Benzodiazepines, BackpackDB));
    Backpack:PushItem(backPackId, MedicineInvID_Temazepam, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Temazepam, BackpackDB));
    Backpack:PushItem(backPackId, MedicineInvID_Bismuth_Sub, Database:GetInt(sprintf("%d", backPackId), "id", BackpackInvColumn_Bismuth_Subsalicylate, BackpackDB));
    return 1;
}

hook OnBackpackSave(backPackId) {
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist), sprintf("%d", backPackId), "id", BackpackInvColumn_Oral_Antihistamines, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL), sprintf("%d", backPackId), "id", BackpackInvColumn_Ditropan_XL, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines), sprintf("%d", backPackId), "id", BackpackInvColumn_Benzodiazepines, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam), sprintf("%d", backPackId), "id", BackpackInvColumn_Temazepam, BackpackDB);
    Database:UpdateInt(Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub), sprintf("%d", backPackId), "id", BackpackInvColumn_Bismuth_Subsalicylate, BackpackDB);
    return 1;
}

hook OnBackpackRemove(backPackId) {
    Backpack:PopItem(backPackId, MedicineInvID_Oral_Antihist, Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist));
    Backpack:PopItem(backPackId, MedicineInvID_Ditropan_XL, Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL));
    Backpack:PopItem(backPackId, MedicineInvID_Benzodiazepines, Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines));
    Backpack:PopItem(backPackId, MedicineInvID_Temazepam, Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam));
    Backpack:PopItem(backPackId, MedicineInvID_Bismuth_Sub, Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub));
    return 1;
}

hook OnPlayerReqestBpItem(playerid, backPackId, inventoryId) {
    if (inventoryId == MedicineInvID_Oral_Antihist) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Oral_antihistamines);
            Backpack:PopItem(backPackId, MedicineInvID_Oral_Antihist, 1);
        }
        return ~1;
    }
    if (inventoryId == MedicineInvID_Ditropan_XL) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Ditropan_XL);
            Backpack:PopItem(backPackId, MedicineInvID_Ditropan_XL, 1);
        }
        return ~1;
    }
    if (inventoryId == MedicineInvID_Benzodiazepines) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Benzodiazepines);
            Backpack:PopItem(backPackId, MedicineInvID_Benzodiazepines, 1);
        }
        return ~1;
    }
    if (inventoryId == MedicineInvID_Temazepam) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Temazepam);
            Backpack:PopItem(backPackId, MedicineInvID_Temazepam, 1);
        }
        return ~1;
    }
    if (inventoryId == MedicineInvID_Bismuth_Sub) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub) < 1) {
            SendClientMessage(playerid, -1, "[Alexa]: backpack don't have medicine");
        } else {
            CallMedicineTake(playerid, Medice_Bismuth_Subsalicylate);
            Backpack:PopItem(backPackId, MedicineInvID_Bismuth_Sub, 1);
        }
        return ~1;
    }
    return 1;
}

QuickActions:OnInit(playerid, targetid, page) {
    if (page != 0) return 1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return 1;
    if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist) > 0) QuickActions:AddCommand(playerid, "Give player Oral_Antihistamines medicine");
    if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL) > 0) QuickActions:AddCommand(playerid, "Give player Ditropan_XL medicine");
    if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines) > 0) QuickActions:AddCommand(playerid, "Give player Benzodiazepines medicine");
    if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam) > 0) QuickActions:AddCommand(playerid, "Give player Temazepam medicine");
    if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub) > 0) QuickActions:AddCommand(playerid, "Give player Bismuth_Subsalicylate medicine");
    return 1;
}

hook QuickActionsOnResponse(playerid, targetid, page, response, listitem, const inputtext[]) {
    if (!response) return 1;
    new backPackId = Backpack:GetPlayerBackpackID(playerid);
    if (!Backpack:isValidBackpack(backPackId)) return 1;
    if (!strcmp("Give player Oral_Antihistamines medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Oral_Antihist) < 1) return ~1;
        Backpack:PopItem(backPackId, MedicineInvID_Oral_Antihist, 1);
        CallMedicineTake(targetid, MedicineInvID_Oral_Antihist);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Oral_Antihistamines from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Oral_Antihistamines from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Ditropan_XL medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Ditropan_XL) < 1) return ~1;
        Backpack:PopItem(backPackId, MedicineInvID_Ditropan_XL, 1);
        CallMedicineTake(targetid, MedicineInvID_Ditropan_XL);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Ditropan_XL from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Ditropan_XL from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Benzodiazepines medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Benzodiazepines) < 1) return ~1;
        Backpack:PopItem(backPackId, MedicineInvID_Benzodiazepines, 1);
        CallMedicineTake(targetid, MedicineInvID_Benzodiazepines);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Benzodiazepines from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Benzodiazepines from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Temazepam medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Temazepam) < 1) return ~1;
        Backpack:PopItem(backPackId, MedicineInvID_Temazepam, 1);
        CallMedicineTake(targetid, MedicineInvID_Temazepam);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Temazepam from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Temazepam from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    if (!strcmp("Give player Bismuth_Subsalicylate medicine", inputtext)) {
        if (Backpack:GetInvItemQuantity(backPackId, MedicineInvID_Bismuth_Sub) < 1) return ~1;
        Backpack:PopItem(backPackId, MedicineInvID_Bismuth_Sub, 1);
        CallMedicineTake(targetid, MedicineInvID_Bismuth_Sub);
        SendClientMessage(playerid, -1, sprintf("[Alexa] you have given %s medicine of Bismuth_Subsalicylate from your backpack", GetPlayerNameEx(targetid)));
        SendClientMessage(targetid, -1, sprintf("[Alexa] %s gives you medicine of Bismuth_Subsalicylate from his/her backpack", GetPlayerNameEx(playerid)));
        return ~1;
    }
    return 1;
}