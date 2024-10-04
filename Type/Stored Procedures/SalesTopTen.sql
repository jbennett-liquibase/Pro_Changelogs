--liquibase formatted sql

/*
    ********** Release 1.0.0 **********
*/
--changeset dzentgraf:sp_top_ten_quota labels:jira-1299,release-1.0.0 runOnChange:true
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC;
--rollback DROP PROCEDURE Sales.TopTenQuota;