--liquibase formatted sql

/*
    ********** Release 1.0.0 **********
*/
--changeset jbennett:ddl_create_table_purchasing_vendor labels:jira-1218,release-1.0.0
CREATE TABLE Purchasing.Vendor (
    BusinessEntityID int NOT NULL,
    AccountNumber AccountNumber NOT NULL,
    Name Name NOT NULL, CreditRating tinyint NOT NULL,
    PreferredVendorStatus Flag(1) CONSTRAINT DF_Vendor_PreferredVendorStatus DEFAULT 1 NOT NULL,
    ActiveFlag Flag(1) CONSTRAINT DF_Vendor_ActiveFlag DEFAULT 1 NOT NULL,
    PurchasingWebServiceURL nvarchar(1024),
    ModifiedDate datetime CONSTRAINT DF_Vendor_ModifiedDate DEFAULT GETDATE() NOT NULL,
    CONSTRAINT PK_Vendor_BusinessEntityID PRIMARY KEY (BusinessEntityID));
--rollback DROP TABLE Purchasing.Vendor;

--changeset mikeo:ddl_create_table_customer labels:jira-1220,release-1.0.0
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

--changeset mikeo:ddl_create_view_store_with_contacts labels:jira-1232,release-1.0.0 runOnChange:true
CREATE OR ALTER VIEW Sales.vStoreWithContacts AS SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,ct.[Name] AS [ContactType] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,pp.[PhoneNumber] 
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress] 
    ,p.[EmailPromotion] 
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityContact] bec 
    ON bec.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[ContactType] ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
--rollback DROP VIEW Sales.vStoreWithContacts;

--changeset mikeo:ddl_create_table_person labels:jira-1244,release-1.0.0
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

--changeset dzentgraf:sp_create_top_ten_quota labels:jira-1299,release-1.0.0
CREATE OR ALTER PROCEDURE Sales.TopTenQuota AS
SET ROWCOUNT 10
SELECT Sales.SalesPersonQuotaHistory.SalesQuota AS TopTenQuota, Sales.SalesPersonQuotaHistory.BusinessEntityID
FROM Sales.SalesPersonQuotaHistory
ORDER BY Sales.SalesPersonQuotaHistory.SalesQuota DESC;
--rollback DROP PROCEDURE Sales.TopTenQuota;