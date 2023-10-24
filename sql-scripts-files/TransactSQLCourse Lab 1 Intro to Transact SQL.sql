-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 1 Transact SQL Course
-- Challenge 1: Retrieve Customer Data
-- 1. Retrieve customer details
-- Write a Transact-SQL query that retrieves all columns from the customer table
SELECT * FROM SalesLT.Customer;

-- 2. Retrieve customer name data
-- List of all customer contact names that includes the title, first name, middle name (if any), last
-- name, and suffix (if any) of all customers.
-- Null values are replaced with blanks for presentation purposes.

SELECT Title, FirstName, IsNull(MiddleName,'') AS MiddleName, LastName, 
	IsNull(Suffix,'') AS Suffix 
FROM SalesLT.Customer;

-- 3. Retrieve customer names and phone numbers
-- Each customer has an assigned salesperson. Write a query to create a call sheet that lists:
-- 3.1 The salesperson
-- 3.2 A column named CustomerName that displays how the customer contact should be greeted (for
-- example, �Mr Smith�)
-- 3.3 The customer�s phone number.

Select SalesPerson, (IsNull(Title,'') + '' + LastName) AS CustomerGreeting 
FROM SalesLT.Customer;


-- Challenge 2: Retrieve Customer and Sales Data

 -- This part of the Lab requires to use the SQL Conversion Functions.
 -- SQL Supports both the CAST and a CONVERT function.
 -- CAST is part of the ANSI-SQL specification; whereas, CONVERT is not.
 -- Unless you have some specific formatting requirements you�re trying to address during the conversion, 
 -- It is advisable to stick with using the CAST function.
 -- Some reasons to use CAST instead of CONVERT:
 --		CAST is ANSI-SQL compliant; therefore, more apt to be used in other database implementation.
 --		There is no performance penalty using CAST.
 --     CAST is easier to read.

-- 1. Retrieve a list of customer companies
-- The sales team has asked you to provide a list of all customer companies in the format <Customer ID> :
-- <Company Name> - for example, 78: Preferred Bikes.

SELECT (CAST(CustomerID AS varchar) + ': ' + CompanyName) AS CustomerCompany 
FROM SalesLT.Customer;

-- 2. Retrieve a list of sales order revisions
-- The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve 
-- data for a report that shows:
-- 2.1 The sales order number and revision number in the format <Order Number> (<Revision>) � for
-- example SO71774 (2).
-- 2.2 The order date converted to ANSI standard format (yyyy.mm.dd � for example 2015.01.31).

-- Here we have a specific format conversion requirement, we have to output the Date in the Ansi format,
-- Showing just the date and not the time. Therefore, we will use the CONVERT Function

SELECT (SalesOrderNumber + ' (' + CAST(RevisionNumber AS varchar) + ')') AS OrderRevision, 
	CONVERT(varchar(10),OrderDate,102) AS OrderDateANSI
FROM SalesLT.SalesOrderHeader;


-- Challenge 3: Retrieve Customer Contact Details
-- Some records in the database include missing or unknown values that are returned as NULL. 
-- Create some queries that handle these NULL fields appropriately.

-- 1. Retrieve customer contact names with middle names if known

-- You have been asked to write a query that returns a list of customer names. 
-- The list must consist of a single field in the format <first name> <last name> (for example Keith Harris) 
-- if the middle name is unknown, or <first name> <middle name> <last name> (for example Jane M. Gates) 
-- if a middle name is stored in the database.

SELECT FirstName + ' ' + IsNull(MiddleName + ' ','') + LastName AS FullName
FROM SalesLT.Customer;

-- 2. Retrieve primary contact details

-- Customers may provide adventure Works with an email address, a phone number, or both. If an email
-- address is available, then it should be used as the primary contact method; if not, then the phone
-- number should be used. You must write a query that returns a list of customer IDs in one column, and a
-- second column named PrimaryContact that contains the email address if known, and otherwise the phone number.

-- In the sample data provided in AdventureWorksLT, there are no customer records
-- without an email address. Therefore, to verify that your query works as expected, run the following
-- UPDATE statement to remove some existing email addresses.

UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

Select CustomerID, ISNULL(EmailAddress,Phone) AS PrimaryContact From SalesLT.Customer;

-- 3. Retrieve shipping status
-- You have been asked to create a query that returns a list of sales order IDs and order dates with a
-- column named ShippingStatus that contains the text �Shipped� for orders with a known ship date, and
-- �Awaiting Shipment� for orders with no ship date.

-- In the sample data provided in AdventureWorksLT, there are no sales order header
-- records without a ship date. 
-- To verify that your query works as expected, run the following UPDATE statement to remove some 
-- existing ship dates before creating your query.

UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

Select SalesOrderID, OrderDate, 
	CASE
      WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
      ELSE 'Shipped'
    END AS ShippingStatus 
From SalesLT.SalesOrderHeader;















