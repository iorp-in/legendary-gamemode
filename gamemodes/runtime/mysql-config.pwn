new MySQL:Database;

hook OnGameModeInit() {
    new MySQLOpt:option_id = mysql_init_options();
    mysql_set_option(option_id, AUTO_RECONNECT, true); // We will set that option to automatically reconnect on timeouts.
    mysql_log(ERROR | WARNING);
    Database = mysql_connect_file();
    if (Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0) // Checking if the database connection is invalid to shutdown.
    {
        print("[Alexa] MySql Disconnected, Server Shutting Down."); // Printing a message to the log.
        SendRconCommand("exit"); // Sending console command to shut down server.
        return 1;
    }
    print("[Alexa] MySql Connected"); // If the given MySQL details were all okay, this message prints to the log.
    return 1;
}