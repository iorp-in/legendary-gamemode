#define MAIL_SERVER_URL "https://iorp.in/api/notification/email"
#define MAIL_SERVER_TOKEN "not-gonna-tell-you"

hook Global15SecondInterval() {
    mysql_tquery(Database, "select * from emailLogs where sent = 0 limit 5", "OnEmailIntervalInit");
    return 1;
}

forward OnEmailIntervalInit();
public OnEmailIntervalInit() {
    new rows = cache_num_rows();

    new id, username[100], content[2000], subject[2000], type[100];
    for (new i; i < rows; i++) {
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name(i, "username", username);
        cache_get_value_name(i, "subject", subject);
        cache_get_value_name(i, "content", content);
        cache_get_value_name(i, "type", type);

        mysql_tquery(Database, sprintf("update emailLogs set sent = 1 where id = %d", id));

        new body[2000];
        format(
            body, sizeof body,
            "{\"username\": \"%s\",\"content\": \"%s\",\"subject\": \"%s\",\"token\": \"%s\",\"type\": \"%s\"}",
            username, content, subject, MAIL_SERVER_TOKEN, type
        );

        sendHttpPost(MAIL_SERVER_URL, body);
    }
    return 1;
}

stock Email:Send(const type[], const username[], const subject[], const content[]) {
    #pragma unused type, username, subject, content
    // mysql_tquery(
    //     Database, sprintf(
    //         "insert into emailLogs (type, username, subject, content) values (\"%s\", \"%s\", \"%s\", \"%s\")",
    //         type, username, subject, content
    //     )
    // );
    return 1;
}

cmd:sendemail(playerid, const params[]) {
    if (GetPlayerAdminLevel(playerid) < 8) return 0;
    new username[50], content[144];
    if (sscanf(params, "s[50]s[144]", username, content)) return SendClientMessage(playerid, -1, "{FF0000}[Alexa]: {FFFFFF} /sendemail [username] [message]");
    if (!IsValidAccount(username)) return SendClientMessage(playerid, -1, "{FF0000}[Alexa]: {FFFFFF} invalid username");
    Email:Send(ALERT_TYPE_SERVER, username, sprintf("Admin %s message to %s", GetPlayerNameEx(playerid), username), content);
    SendClientMessage(playerid, -1, sprintf("{FF0000}[Alexa]: {FFFFFF} admin email message sent to %s", username));
    return 1;
}