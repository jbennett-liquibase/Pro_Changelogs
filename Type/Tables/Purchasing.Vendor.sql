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

/*
    ********** Release 1.1.0 **********
*/
--changeset dzentgraf:ddl_add_column_purchasing_currency_code labels:jira-1342,release-1.1.0
ALTER TABLE Purchasing.Vendor ADD CurrencyCode CHAR(3);
--rollback ALTER TABLE Purchasing.Vendor DROP COLUMN CurrencyCode;

--changeset dzentgraf:dml_update_purchasing_currency_code labels:jira-1342,release-1.1.0
UPDATE Purchasing.Vendor SET ModifiedDate = GETDATE(), CurrencyCode = 'USD';
--rollback UPDATE Purchasing.Vendor SET CurrencyCode = NULL;