--changeset jbennett:ddl_create_table_businessunit labels:jira-1218,release-1.0.0
CREATE TABLE Sales.BusinessUnit (
    BusinessUnitID INT PRIMARY KEY,
    Name VARCHAR(50),
    TerritoryID INT REFERENCES Sales.SalesTerritory(TerritoryID),
    ModifiedDate DATETIME
);
--rollback DROP TABLE Sales.BusinessUnit;

/*
    ********** Release 1.0.1 **********
*/
--changeset dzentgraf:ddl_add_column_currencycode labels:jira-1342,release-1.0.1
ALTER TABLE Sales.BusinessUnit ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Sales.BusinessUnit DROP COLUMN CurrencyCode;

--changeset dzentgraf:dml_update_currencycode labels:jira-1357,release-1.0.1
UPDATE Sales.BusinessUnit SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Sales.BusinessUnit SET CurrencyCode = NULL WHERE BusinessUnitID BETWEEN 1 AND 5;