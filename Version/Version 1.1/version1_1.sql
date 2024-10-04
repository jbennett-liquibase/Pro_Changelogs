--liquibase formatted sql

/*
    ********** Release 1.1.0 **********
*/
--changeset jbennett:ddl_create_view_employee_dept_hist labels:jira-1301,release-1.1.0 runOnChange:true
CREATE OR ALTER VIEW HumanResources.vEmployeeDepartmentHistory AS SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,s.[Name] AS [Shift]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
    ,edh.[EndDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
    INNER JOIN [HumanResources].[Shift] s
    ON s.[ShiftID] = edh.[ShiftID];
--rollback DROP VIEW HumanResources.vEmployeeDepartmentHistory;

--changeset mikeo:sp_update_employee_login labels:jira-1342,release-1.1.0 runOnChange:true
CREATE OR ALTER PROCEDURE HumanResources.[uspUpdateEmployeeLogin]
    @BusinessEntityID [int], 
    @OrganizationNode [hierarchyid],
    @LoginID [nvarchar](256),
    @JobTitle [nvarchar](50),
    @HireDate [datetime],
    @CurrentFlag [dbo].[Flag]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [OrganizationNode] = @OrganizationNode 
            ,[LoginID] = @LoginID 
            ,[JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
--rollback DROP PROCEDURE HumanResources.[uspUpdateEmployeeLogin];

--changeset dzentgraf:ddl_add_column_purchasing_currency_code labels:jira-1342,release-1.1.0
ALTER TABLE Purchasing.Vendor ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Purchasing.Vendor DROP COLUMN CurrencyCode;

--changeset dzentgraf:dml_update_purchasing_currency_code labels:jira-1342,release-1.1.0
UPDATE Purchasing.Vendor SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Purchasing.Vendor SET CurrencyCode = NULL;

--changeset dzentgraf:ddl_add_column_sales_currency_code labels:jira-1342,release-1.1.0
ALTER TABLE Sales.Customer ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Sales.Customer DROP COLUMN CurrencyCode;

--changeset dzentgraf:dml_update_sales_currency_code labels:jira-1342,release-1.1.0
UPDATE Sales.Customer SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Sales.Customer SET CurrencyCode = NULL;

--changeset dzentgraf:sp_update_toptenquota labels:jira-1379,release-1.1.0
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC, Sales.SalesPersonQuotaHistory.SalesQuota ASC;
--rollback DROP PROCEDURE Sales.TopTenQuota;

--changeset dzentgraf:ddl_create_view_vendor_with_address labels:jira-1380,release-1.1.0 runOnChange:true
CREATE OR ALTER VIEW Purchasing.vVendorWithAddresses AS SELECT 
    v.[BusinessEntityID]
    ,v.[Name]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1] 
    ,a.[AddressLine2] 
    ,a.[City] 
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode] 
    ,cr.[Name] AS [CountryRegionName] 
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = v.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID];
--rollback DROP VIEW Purchasing.vVendorWithAddresses;