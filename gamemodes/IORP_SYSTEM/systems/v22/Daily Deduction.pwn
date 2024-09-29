hook GlobalOneAmInterval() {
    mysql_tquery(
        Database, "select owner from bankAccounts group by Owner having sum(balance) > 200000", "OnGlobalDeductionInit"
    );
    return 1;
}

forward OnGlobalDeductionInit();
public OnGlobalDeductionInit() {
    new username[50];
    new rows = cache_num_rows();
    for (new i; i < rows; i++) {
        cache_get_value_name(i, "owner", username);
        SetPreciseTimer("DeductDailyExpense", (i + 1) * 1000, false, "s", username);
    }

    return 1;
}

forward DeductDailyExpense(const username[]);
public DeductDailyExpense(const username[]) {
    if (!IsAccountLoggedInLast(username)) {
        new deductAmount = RandomEx(5000, 10000);
        DeductAnyBankAccount(username, deductAmount);
    }
    return 1;
}

stock DeductAnyBankAccount(const Account[], deductAmount) {
    new Cache:mysql_cache = mysql_query(Database, sprintf("select * from bankAccounts where owner = \"%s\" and balance > %d", Account, deductAmount));
    new rows = cache_num_rows();
    if (!rows) {
        cache_delete(mysql_cache);
        return 1;
    }

    new accountId, balance;
    for (new i; i < rows; i++) {
        cache_get_value_name_int(i, "ID", accountId);
        cache_get_value_name_int(i, "Balance", balance);

        if (balance > deductAmount) {
            Bank:SaveLogEx(Account, TYPE_WITHDRAW, accountId, -1, -deductAmount, "player daily expense");

            mysql_tquery(Database, sprintf(
                "update bankAccounts set balance = balance - %d where id = %d", deductAmount, accountId
            ));


            Email:Send(ALERT_TYPE_SERVER, Account, "Alexa: Player Daily Expenses", sprintf(
                "As part of the economic initiative / player daily expense, your bank account balance with account id %d has been deduct for $%s. \
                In order to avoid further deductions, please play on the IORP server daily. Thank you",
                accountId, FormatCurrency(deductAmount)
            ));

            vault:addcash(Vault_ID_DUMP_MONEY, deductAmount, Vault_Transaction_Cash_To_Vault, sprintf("%s daily expense", Account));

            break;
        }
    }

    cache_delete(mysql_cache);
    return 1;
}