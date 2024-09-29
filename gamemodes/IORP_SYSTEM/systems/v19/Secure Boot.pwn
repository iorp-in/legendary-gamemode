forward OnServerReboot();
public OnServerReboot() {
    return 1;
}

stock RebootServer() {
    CallRemoteFunction("OnServerReboot", "");
    return SendRconCommand("gmx");
}

stock HardRebootServer() {
    CallRemoteFunction("OnServerReboot", "");
    CrashServer();
    return 1;
}

stock CrashServer() {
    SetPreciseTimer("FuncCrashServer", 2000, false);
    return 1;
}

forward FuncCrashServer();
public FuncCrashServer() {
    Discord:SendManagement("hard rebooting...");
    print("hard rebooting...");
    SendRconCommand("exit");
    // strfind("qwe", "asd", true, -100);
    return 1;
}