/*
    ********** Release 1.1.0 **********
*/
--changeset dzentgraf:ddl_add_column_currencycode labels:jira-1342,release-1.1.0
ALTER TABLE Sales.BusinessUnit ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Sales.BusinessUnit DROP COLUMN CurrencyCode;

--changeset dzentgraf:dml_update_currencycode labels:jira-1357,release-1.1.0
UPDATE Sales.BusinessUnit SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Sales.BusinessUnit SET CurrencyCode = NULL WHERE BusinessUnitID BETWEEN 1 AND 5;