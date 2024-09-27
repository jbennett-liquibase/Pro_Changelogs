/*
    ********** Release 1.1.0 **********
*/
--changeset jbennett:ddl_add_column_currencycode labels:jira-1342,release-1.1.0
ALTER TABLE Sales.BusinessUnit ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Sales.BusinessUnit DROP COLUMN CurrencyCode;

--changeset jbennett:dml_update_currencycode labels:jira-1357,release-1.1.0
UPDATE Sales.BusinessUnit SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Sales.BusinessUnit SET CurrencyCode = NULL WHERE BusinessUnitID BETWEEN 1 AND 5;

--changeset dzentgraf:sp_update_toptenquota labels:jira-1379,release-1.1.0
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC, Sales.SalesPersonQuotaHistory.SalesQuota ASC;
--rollback DROP PROCEDURE Sales.TopTenQuota;