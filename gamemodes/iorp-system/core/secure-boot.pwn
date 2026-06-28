stock HardRebootServer() {
    SetPreciseTimer("FuncCrashServer", 2000, false);
    return 1;
}

forward FuncCrashServer();
public FuncCrashServer() {
    print("hard rebooting...");
    SendRconCommand("exit");
    // strfind("qwe", "asd", true, -100);
    return 1;
}