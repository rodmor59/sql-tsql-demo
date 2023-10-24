-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 4 – Using Set Operators
-- Overview
-- In this lab, you will use set operators to combine the results of multiple queries 
-- in the AdventureWorksLT database.

-- Challenge 1: Retrieve Customer Addresses
-- Customers can have two kinds of address: a main office address and a shipping address. 
-- The accounts department want to ensure that the main office address is always used 
-- for billing, and have asked you to write a query that clearly identifies the different 
-- types of address for each customer.

-- 1. Retrieve billing addresses
-- Write a query that retrieves the company name, first line of the street address, city,
-- and a column named AddressType with the value ‘Billing’ for customers where the address
-- type in the SalesLT.CustomerAddress table is ‘Main Office’.

-- First, I builded a query that returs all address types. This way I we have both
-- Billing and Shipping Addresses. I did this because it is useful to have also.

SELECT c.CompanyName, a.AddressLine1, a.City, 
	IIF(ca.AddressType = 'Main Office','Billing',ca.AddressType) AS AddressType 
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
ORDER BY c.CustomerID, AddressType;

-- Then I buid the Query specified in the challenge.
-- This query returs only addresses that are of the "Main Office" and change that name
-- to "Billing" in the results.

-- A personal note: Filtering the JOIN in the ON clause or the WHERE clause at the end 
-- produces almost identical performance results, as the DBMS compiler creates a plan
-- very similar for both cases, with filtering ocurring at the earliest possible moment.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
ORDER BY c.CustomerID;

-- 2. Retrieve shipping addresses
-- Write a similar query that retrieves the company name, first line of the street address, 
-- city, and a column named AddressType with the value ‘Shipping’ for customers where the 
-- address type in the SalesLT.CustomerAddress table is ‘Shipping’.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CustomerID;

-- 3. Combine billing and shipping addresses
-- Combine the results returned by the two queries to create a list of all customer addresses 
-- that is sorted by company name and then address type.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;

-- Challenge 2: Filter Customer Addresses
-- You have created a master list of all customer addresses, but now you have been asked to 
-- create filtered lists that show which customers have only a main office address, 
-- and which customers have both a main office and a shipping address.

-- 1. Retrieve customers with only a main office address
-- Write a query that returns the company name of each company that appears in a table of 
-- customers with a ‘Main Office’ address, but not in a table of customers with a ‘Shipping’ 
-- address.

SELECT c.CompanyName
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;

-- 2. Retrieve only customers with both a main office address and a shipping address
-- Write a query that returns the company name of each company that appears in a table of 
-- customers with a ‘Main Office’ address, and also in a table of customers with a ‘Shipping’ 
-- address.

SELECT c.CompanyName
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
INTERSECT
SELECT c.CompanyName
FROM SalesLT.Customer AS c INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;




