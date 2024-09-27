--changeset dzentgraf:sp_create_toptenquota labels:jira-1357,release-1.0.1
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC;
--rollback DROP PROCEDURE Sales.TopTenQuota;