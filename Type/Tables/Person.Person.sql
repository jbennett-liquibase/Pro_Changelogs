--liquibase formatted sql

/*
    ********** Release 1.0.0 **********
*/
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