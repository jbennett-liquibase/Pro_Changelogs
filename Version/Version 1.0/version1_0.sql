/*
    ********** Release 1.0.0 **********
*/
--changeset mikeo:ddl_create_table_customer labels:jira-1218,release-1.0.0
CREATE TABLE Sales.Customer (
    CustomerID int IDENTITY (1, 1) NOT NULL,
    PersonID int,
    StoreID int,
    TerritoryID int,
    AccountNumber varchar(10) NOT NULL,
    rowguid uniqueidentifier CONSTRAINT DF_Customer_rowguid DEFAULT newid() NOT NULL,
    ModifiedDate datetime CONSTRAINT DF_Customer_ModifiedDate DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Customer_CustomerID PRIMARY KEY (CustomerID));
--rollback DROP TABLE Sales.Customer;

--changeset mikeo:ddl_create_table_person labels:jira-1218,release-1.0.0
CREATE TABLE Person.Person (
    BusinessEntityID int NOT NULL,
    PersonType nchar(2) NOT NULL,
    NameStyle NameStyle(1) CONSTRAINT DF_Person_NameStyle DEFAULT 0 NOT NULL,
    Title nvarchar(8),
    FirstName Name NOT NULL,
    MiddleName Name,
    LastName Name NOT NULL,
    Suffix nvarchar(10),
    EmailPromotion int CONSTRAINT DF_Person_EmailPromotion DEFAULT 0 NOT NULL,
    AdditionalContactInfo xml,
    Demographics xml,
    rowguid uniqueidentifier CONSTRAINT DF_Person_rowguid DEFAULT newid() NOT NULL,
    ModifiedDate datetime CONSTRAINT DF_Person_ModifiedDate DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Person_BusinessEntityID PRIMARY KEY (BusinessEntityID));
--rollback DROP TABLE Person.Person;

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