new error_count = 0;
new server_lock = 0;
new server_start_time = -1;
new bool:softReboot = false;

hook OnGameModeInit() {
    server_start_time = gettime();
    return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle) {
    if (server_lock) return 1;
    new string[2000];
    format(string, sizeof string, "**Mysql Error**\nQeury: ```%s```\nError: ```%s```", query, error);
    Discord:SendManagement(string);
    LockServer();
    return 1;
}

public OnRuntimeError(code, & bool:suppress) {
    static const sc_messages[28][54] = {
        /* AMX_ERR_NONE      */
        "None",
        /* AMX_ERR_EXIT      */
        "Forced exit",
        /* AMX_ERR_ASSERT    */
        "Assertion failed",
        /* AMX_ERR_STACKERR  */
        "Stack/heap collision (insufficient stack size)",
        /* AMX_ERR_BOUNDS    */
        "Array index out of bounds",
        /* AMX_ERR_MEMACCESS */
        "Invalid memory access",
        /* AMX_ERR_INVINSTR  */
        "Invalid instruction",
        /* AMX_ERR_STACKLOW  */
        "Stack underflow",
        /* AMX_ERR_HEAPLOW   */
        "Heap underflow",
        /* AMX_ERR_CALLBACK  */
        "No (valid) native function callback",
        /* AMX_ERR_NATIVE    */
        "Native function failed",
        /* AMX_ERR_DIVIDE    */
        "Divide by zero",
        /* AMX_ERR_SLEEP     */
        "sleep mode",
        /* 13 */
        "reserved",
        /* 14 */
        "reserved",
        /* 15 */
        "reserved",
        /* AMX_ERR_MEMORY    */
        "Out of memory",
        /* AMX_ERR_FORMAT    */
        "Invalid/unsupported P-code file format",
        /* AMX_ERR_VERSION   */
        "File is for a newer version of the AMX",
        /* AMX_ERR_NOTFOUND  */
        "File or function is not found",
        /* AMX_ERR_INDEX     */
        "Invalid index parameter (bad entry point)",
        /* AMX_ERR_DEBUG     */
        "Debugger cannot run",
        /* AMX_ERR_INIT      */
        "AMX not initialized (or doubly initialized)",
        /* AMX_ERR_USERDATA  */
        "Unable to set user data field (table full)",
        /* AMX_ERR_INIT_JIT  */
        "Cannot initialize the JIT",
        /* AMX_ERR_PARAMS    */
        "Parameter error",
        /* AMX_ERR_DOMAIN    */
        "Domain error, expression result does not fit in range",
        /* AMX_ERR_GENERAL   */
        "General error (unknown or unspecific error)"
    };

    error_count++;

    if (!softReboot) {
        softReboot = true;
    }

    if (error_count > 2 && !server_lock) {
        server_lock = 1;
        Discord:SendManagement(sprintf("Run time error %d: %s", code, sc_messages[code]));
        HardRebootServer();
    }

    return 1;
}

stock LockServer() {
    if (server_lock) return 1;
    server_lock = 1;
    Discord:SendGeneral("\
        **Server Locked**\n```\
        It is me, Alexa, monitoring the IORP samp server. \
        Several technical errors have forced me to shut down the samp server to ensure your safety. \
        As soon as this error has been resolved, I'll let you know. If you need assistance, \
        you can reach out to my support at (indianoceanroleplay@gmail.com) or contact Harry#5791.\n\n\
        I greatly appreciate your cooperation \
    ```");
    kickall(-1);
    SendRconCommand("hostname IORP TM [Released] - Technical Error");
    SendRconCommand("password iorptech");
    HardRebootServer();
    return 1;
}

new bool:scheduledSoftReboot = false;

hook OnPlayerDisconnect(playerid, reason) {
    if (scheduledSoftReboot) return 1;

    new total = TotalPlayersInServer();
    if (total == 0) {
        scheduledSoftReboot = true;
        SetPreciseTimer("InitSoftReboot", 5 * 60 * 1000, false);
    }
    return 1;
}

forward InitSoftReboot();
public InitSoftReboot() {
    new total = TotalPlayersInServer();
    if (total == 0) {
        if (server_start_time > 0 && gettime() - server_start_time > 12 * 60 * 60) {
            Discord:SendGeneral("please wait, I need to restart server, blame carl...");
            HardRebootServer();
        } else if (softReboot && !server_lock) {
            Discord:SendGeneral("please wait, I need to restart server, damm it carl...");
            HardRebootServer();
        }
    }

    scheduledSoftReboot = false;
    return 1;
}