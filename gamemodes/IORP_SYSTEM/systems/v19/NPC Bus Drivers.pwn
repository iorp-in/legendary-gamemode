
hook OnGameModeInit()
{
    //SetTimer("Bus_NPC_Connect", 10*1000, false);
    return 1;
}

new Bus_NPC_Count = 0;
forward Bus_NPC_Connect();
public Bus_NPC_Connect()
{
    ConnectNPC(sprintf("Driver[%d]", Bus_NPC_Count), "npcidle");
    Bus_NPC_Count++;
    if(Bus_NPC_Count == 9) return 1;
    else return SetTimer("Bus_NPC_Connect", 10*1000, false);
}

