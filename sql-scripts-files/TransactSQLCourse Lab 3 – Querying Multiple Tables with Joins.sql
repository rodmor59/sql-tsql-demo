-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 3 – Querying Multiple Tables with Joins
-- Overview
-- In this lab, you will use joins to combine data from multiple tables in the 
-- AdventureWorksLT database.

-- Challenge 1: Generate Invoice Reports
-- Adventure Works Cycles sells directly to retailers, who must be invoiced for their orders. 
-- You have been tasked with writing a query to generate a list of invoices to be sent to 
-- customers.

-- 1. Retrieve customer orders
-- As an initial step towards generating the invoice report, write a query that returns 
-- the company name from the SalesLT.Customer table, and the sales order ID and total due 
-- from the SalesLT.SalesOrderHeader table.

SELECT c.CompanyName, oh.SalesOrderID,
	FORMAT(oh.TotalDue, 'N2') AS TotalDue
FROM SalesLT.Customer AS c INNER JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID;

-- 2. Retrieve customer orders with addresses
-- Extend your customer orders query to include the Main Office address for each customer, 
-- including the full street address, city, state or province, postal code, and country or 
-- region 

-- Tip: Note that each customer can have multiple addressees in the SalesLT.Address 
-- table, so the database developer has created the SalesLT.CustomerAddress table to enable 
-- a many-to-many relationship between customers and addresses. Your query will need to include 
-- both of these tables, and should filter the join to SalesLT.CustomerAddress so that only 
-- Main Office addresses are included.

SELECT c.CompanyName,  ad.AddressLine1 + ' ' + ISNULL(ad.AddressLine2,'') AS FullStreetAdress, 
	ad.City, ad.StateProvince, ad.PostalCode, ad.CountryRegion, oh.SalesOrderID, 
	FORMAT(oh.TotalDue, 'N2') AS TotalDue
FROM SalesLT.Customer AS c INNER JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID AND ca.AddressType = 'Main Office'
INNER JOIN SalesLT.Address AS ad
ON ca.AddressID = ad.AddressID;

-- Challenge 2: Retrieve Sales Data
-- As you continue to work with the Adventure Works customer and sales data, you must 
-- create queries for reports that have been requested by the sales team.

-- 1. Retrieve a list of all customers and their orders
-- The sales manager wants a list of all customer companies and their contacts 
-- (first name and last name), showing the sales order ID and total due for each order 
-- they have placed. Customers who have not placed any orders should be included at the 
-- bottom of the list with NULL values for the order ID and total due.

SELECT c.CompanyName, c.FirstName + ' ' + c.LastName AS ContactName, oh.SalesOrderID,
	CONVERT(varchar(10),oh.OrderDate,102) AS OrderDateANSI, 
	FORMAT(oh.TotalDue, 'N2') AS TotalDue
FROM SalesLT.Customer AS c LEFT JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID
ORDER BY oh.OrderDate DESC;

-- 2. Retrieve a list of customers with no address
-- A sales employee has noticed that Adventure Works does not have address information 
-- for all customers. You must write a query that returns a list of customer IDs, company 
-- names, contact names (first name and last name), and phone numbers for customers with no 
-- address stored in the database.

SELECT c.CustomerID, c.CompanyName, (c.FirstName + ' ' + c.LastName) AS ContactName,
	c.Phone
FROM SalesLT.Customer AS c LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID 
WHERE ca.AddressID IS NULL;

-- 3. Retrieve a list of customers and products without orders
-- Some customers have never placed orders, and some products have never been ordered. 
-- Create a query that returns a column of customer IDs for customers who have never placed 
-- an order, and a column of product IDs for products that have never been ordered. Each row 
-- with a customer ID should have a NULL product ID (because the customer has never ordered a 
-- product) and each row with a product ID should have a NULL customer ID (because the product 
-- has never been ordered by a customer).
SELECT c.CustomerID, c.CompanyName, p.ProductID, p.Name
FROM SalesLT.Customer AS c FULL OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID AND oh.CustomerID IS NULL
FULL OUTER JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
FULL OUTER JOIN SalesLT.Product as p
ON p.ProductID = od.ProductID AND oh.CustomerID IS NULL
WHERE NOT (c.CustomerID IS NULL AND p.ProductID IS NULL)
ORDER BY p.ProductID, c.CustomerID;

-- On this last challenge 3.3, my solution is slighly different that the solution
-- of the course authors. Instead of joining all tables with full joins and filtering
-- at the end with WHERE oh.SalesOrderID IS NULL, I preferred to filter them on the
-- first and third joins. However this produced some results in which both the product
-- id and the customer id where null, so I filtered those out at the end with a Where
-- Clause. This Querie would consume less resourses since it is performing full joins
-- over filtered thables with the ON clause, instead of joining all the tables and
-- filtering them at the end.



