#define MAX_RUNTIME_ERRORS (3)

new error_count = 0;
new bool:server_lock = false;

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle) {
    printf("[MYSQL ERROR] %s", error);

    LockServer();
    return 1;
}

public OnRuntimeError(code, & bool:suppress) {
    static const sc_messages[28][54] = {
        "None",
        "Forced exit",
        "Assertion failed",
        "Stack/heap collision (insufficient stack size)",
        "Array index out of bounds",
        "Invalid memory access",
        "Invalid instruction",
        "Stack underflow",
        "Heap underflow",
        "No (valid) native function callback",
        "Native function failed",
        "Divide by zero",
        "sleep mode",
        "reserved",
        "reserved",
        "reserved",
        "Out of memory",
        "Invalid/unsupported P-code file format",
        "File is for a newer version of the AMX",
        "File or function is not found",
        "Invalid index parameter (bad entry point)",
        "Debugger cannot run",
        "AMX not initialized (or doubly initialized)",
        "Unable to set user data field (table full)",
        "Cannot initialize the JIT",
        "Parameter error",
        "Domain error, expression result does not fit in range",
        "General error (unknown or unspecific error)"
    };

    error_count++;

    printf(
        "[RUNTIME ERROR] %s (%d) [%d/%d]",
        (0 <= code < sizeof(sc_messages)) ? sc_messages[code] : "Unknown",
        code,
        error_count,
        MAX_RUNTIME_ERRORS
    );

    if (error_count >= MAX_RUNTIME_ERRORS) {
        LockServer();
    }

    return 1;
}

stock LockServer() {
    if (server_lock)
        return 1;

    server_lock = true;

    printf("[SERVER LOCK] Critical error detected. Rebooting server.");
    SendClientMessageToAll(-1, "[SERVER LOCK] Critical error detected. Rebooting server.");

    kickall(-1);

    SendRconCommand("hostname IORP TM [Released] - Technical Error");
    SendRconCommand("password iorptech");

    HardRebootServer();
    return 1;
}