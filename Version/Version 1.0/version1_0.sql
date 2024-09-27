/*
    ********** Release 1.0.0 **********
*/
--changeset jbennett:ddl_create_table_businessunit labels:jira-1218,release-1.0.0
CREATE TABLE Sales.BusinessUnit (
    BusinessUnitID INT PRIMARY KEY,
    Name VARCHAR(50),
    TerritoryID INT REFERENCES Sales.SalesTerritory(TerritoryID),
    ModifiedDate DATETIME
);
--rollback DROP TABLE Sales.BusinessUnit;

--changeset jbennett:dml_insert_businessunit labels:jira-1218,release-1.0.0
INSERT INTO Sales.BusinessUnit (BusinessUnitID, Name, TerritoryID, ModifiedDate) VALUES (1, 'Explosives', 1, GETDATE());
INSERT INTO Sales.BusinessUnit (BusinessUnitID, Name, TerritoryID, ModifiedDate) VALUES (2, 'Glue', 1, GETDATE());
INSERT INTO Sales.BusinessUnit (BusinessUnitID, Name, TerritoryID, ModifiedDate) VALUES (3, 'Anvils', 2, GETDATE());
INSERT INTO Sales.BusinessUnit (BusinessUnitID, Name, TerritoryID, ModifiedDate) VALUES (4, 'Appliances', 3, GETDATE());
INSERT INTO Sales.BusinessUnit (BusinessUnitID, Name, TerritoryID, ModifiedDate) VALUES (5, 'Rockets', 4, GETDATE());
--rollback DELETE FROM Sales.BusinessUnit WHERE BusinessUnitID BETWEEN 1 AND 5;

--changeset dzentgraf:sp_create_toptenquota labels:jira-1357,release-1.0.0
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC;
--rollback DROP PROCEDURE Sales.TopTenQuota;