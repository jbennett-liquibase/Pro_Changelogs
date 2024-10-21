<p align="left">
  <img src="img/liquibase.png" alt="Liquibase Logo" title="Liquibase Logo" width="324" height="72">
</p>

# Overview
This repository contains sample changelogs organized by object type and release.

The initial changesets were built using the [Adventure Works 2019](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms) database provided by Microsoft for SQL Server. While the structure of the files is correct the changelogs will not run as-is due to missing dependencies (only a few object examples are included).

Best practices for changelog management can be found [here](https://docs.liquibase.com/concepts/bestpractices.html).

# Tree By Type
```
changelog.type.xml
├───Tables
│       Person.Person.sql
│       Purchasing.Vendor.sql
│       Sales.Customer.sql
│
└───Views
│       HumanResources.EmployeeDepartmentHistory.sql
│       Purchashing.VendorWithAddress.sql
│       Sales.StoreWithContacts.sql
├───Stored Procedures
│       HumanResources.UpdateEmployeeLogin.sql
│       SalesTopTen.sql
│
```

# Tree By Version
```
changelog.version.xml
├───Version 1.0
│       version1_0.sql
│
└───Version 1.1
│       version1_1.sql
│
```

## Contact Liquibase
* Liquibase sales: https://www.liquibase.com/contact
* Liquibase support: https://support.liquibase.com/