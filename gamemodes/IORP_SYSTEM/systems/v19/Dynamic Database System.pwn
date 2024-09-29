stock Database:AddTable(const table[], const selectIdentifier[], const type[], const def[], bool:autoIncrement = true) {
    mysql_tquery(Database, sprintf(
        "create table if not exists %s (%s %s not null %s %s primary key)",
        table, selectIdentifier, type,
        (strlen(def) > 0 ? sprintf("default %s", def) : ""),
        autoIncrement ? "auto_increment" : ""
    ));
    return 1;
}

stock Database:InitTable(const table[], const selectIdentifier[], const value[]) {
    mysql_tquery(Database, sprintf("select * from %s where %s = \"%s\"", table, selectIdentifier, value), "DatabaseInsertCallback", "sss", table, selectIdentifier, value);
    return 1;
}

forward DatabaseInsertCallback(const table[], const selectIdentifier[], const value[]);
public DatabaseInsertCallback(const table[], const selectIdentifier[], const value[]) {
    new rows = cache_num_rows();
    if (!rows) mysql_tquery(Database, sprintf("insert into %s (%s) values (\"%s\")", table, selectIdentifier, value));
    return 1;
}

stock Database:AddColumn(const table[], const column[], const type[], const def[]) {
    mysql_tquery(Database, sprintf("call addColumn(\"iorp\", \"%s\", \"%s\", \"%s\", '%s')", table, column, type, (strlen(def) > 0) ? (sprintf("default (\"%s\")", def)) : ("")));
    return 1;
}

stock Database:RemoveColumn(const table[], const column[]) {
    mysql_tquery(Database, sprintf("call removeColumn(\"iorp\", \"%s\", \"%s\")", table, column));
    return 1;
}

stock bool:Database:GetBool(const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select %s from `%s` WHERE `%s` = \"%s\" limit 1", column, table, selectField, selectInput));
    new bool:data = false;
    if (cache_num_rows()) cache_get_value_name_bool(0, column, data);
    cache_delete(mysql_cache);
    return data;
}

stock Database:UpdateBool(bool:newValue, const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    mysql_tquery(Database, sprintf("update `%s` set `%s` = %d  WHERE `%s` = \"%s\"", table, column, newValue, selectField, selectInput));
    return 1;
}

stock Database:GetInt(const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select %s from `%s` WHERE `%s` = \"%s\" limit 1", column, table, selectField, selectInput));
    new data = 0;
    if (cache_num_rows()) cache_get_value_name_int(0, column, data);
    cache_delete(mysql_cache);
    return data;
}

stock Database:GetJsonInt(const column[], const field[], defaultValue = 0, const table[] = "playerdata", const selectField[] = "username", const selectInput[]) {
    new Cache:mysql_cache = mysql_query(Database, sprintf(
        "select IFNULL(JSON_EXTRACT(%s, '$.%s'), %d) as value from `%s` WHERE `%s` = \"%s\" limit 1", column, field, defaultValue, table, selectField, selectInput
    ));
    new data = defaultValue;
    if (cache_num_rows()) cache_get_value_name_int(0, "value", data);
    cache_delete(mysql_cache);
    return data;
}

stock Database:UpdateInt(newValue, const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    mysql_tquery(Database, sprintf("update `%s` set `%s` = %d  WHERE `%s` = \"%s\"", table, column, newValue, selectField, selectInput));
    return 1;
}

stock Database:UpdateJsonInt(const table[] = "playerdata", const column[], const field[], newValue, const selectField[] = "username", const selectInput[]) {
    mysql_tquery(Database, sprintf(
        "UPDATE `%s` SET %s = JSON_MERGE_PATCH(%s, '{\"%s\": %d}') WHERE `%s` = \"%s\" LIMIT 1", table, column, column, field, newValue, selectField, selectInput
    ));
    return 1;
}

stock Database:GetFloat(const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select %s from `%s` WHERE `%s` = \"%s\" limit 1", column, table, selectField, selectInput));
    new Float:data = 0.0;
    if (cache_num_rows()) cache_get_value_name_float(0, column, data);
    cache_delete(mysql_cache);
    return data;
}

stock Database:UpdateFloat(Float:newValue, const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    mysql_tquery(Database, sprintf("update `%s` set `%s` = %f  WHERE `%s` = \"%s\"", table, column, newValue, selectField, selectInput));
    return 1;
}

stock Database:GetString(const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select `%s` from `%s` WHERE `%s` = \"%s\" limit 1", column, table, selectField, selectInput));
    new data[1024] = "null";
    if (cache_num_rows()) cache_get_value_name(0, column, data, sizeof data);
    cache_delete(mysql_cache);
    return data;
}

stock Database:UpdateString(const newValue[], const selectInput[], const selectField[] = "username", const column[], const table[] = "playerdata") {
    mysql_tquery(Database, sprintf("update `%s` set `%s` = \"%s\"  WHERE `%s` = \"%s\"", table, column, newValue, selectField, selectInput));
    return 1;
}

hook OnAccountRename(const OldName[], const NewName[]) {
    mysql_tquery(Database, sprintf("update playerdata set username = \"%s\" where username = \"%s\"", NewName, OldName));
    return 1;
}

hook OnAccountDelete(const AccountName[]) {
    mysql_tquery(Database, sprintf("delete from playerdata where username = \"%s\"", AccountName));
    return 1;
}