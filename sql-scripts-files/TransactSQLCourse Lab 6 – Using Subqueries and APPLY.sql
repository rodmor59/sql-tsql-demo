-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 6 – Using Subqueries and APPLY

-- Overview
-- In this lab, you will use subqueries and the APPLY operator to retrieve data from the AdventureWorksLT database.

-- Challenge 1: Retrieve Product Price Information
-- Adventure Works products each have a standard cost price that indicates the cost of manufacturing the product, 
-- and a list price that indicates the recommended selling price for the product. This data is stored in the SalesLT.Product table. 
-- Whenever a product is ordered, the actual unit price at which it was sold is also recorded in the SalesLT.SalesOrderDetail table. 
-- You must use subqueries to compare the cost and list prices for each product with the unit prices charged in each sale.

-- 1. Retrieve products whose list price is higher than the average unit price
-- Retrieve the product ID, name, and list price for each product where the list price is higher than the average unit price
-- for all products that have been sold.

SELECT ProductID, Name, ListPrice 
FROM SalesLT.Product
WHERE ListPrice > 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;

-- 2. Retrieve Products with a list price of $100 or more that have been sold for less than $100
-- Retrieve the product ID, name, and list price for each product where the list price is $100 or more, and the product has been
-- sold for less than $100.

SELECT ProductID, Name, ListPrice 
FROM SalesLT.Product
WHERE ListPrice >= 100 AND
	ProductID IN (
		SELECT ProductID FROM SalesLT.SalesOrderDetail
		WHERE UnitPrice < 100
	)
ORDER BY ProductID;

-- 3. Retrieve the cost, list price, and average selling price for each product
-- Retrieve the product ID, name, cost, and list price for each product along with the average unit price for which that product 
-- has been sold.

-- Solution 3.1 Using Ubsqueries
SELECT p.ProductID, Name, StandardCost, ListPrice, 
ISNULL(
	(SELECT AVG(UnitPrice) 
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE sod.ProductID = p.ProductID),
	0) AS AvgUnitPrice
FROM SalesLT.Product AS p
ORDER BY P.ProductID;

-- Solution 3.2 Using the Apply operator to use the result of one query into the other
SELECT p.ProductID, Name, StandardCost, ListPrice, ISNULL(AvgUnitPrice,0) AS AvgUnitPrice
FROM SalesLT.Product AS p
OUTER APPLY
	(
	SELECT ProductID, AVG(UnitPrice) AS AvgUnitPrice 
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE p.ProductID = sod.ProductID
	GROUP BY ProductID
	) A;

-- 4. Retrieve products that have an average selling price that is lower than the cost
-- Filter your previous query to include only products where the cost price is higher than the average selling price.

-- Solution 4.1 Using Ubsqueries
SELECT p.ProductID, Name, StandardCost, ListPrice,
	(SELECT AVG(UnitPrice) 
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE sod.ProductID = p.ProductID) 
	AS AvgSellingPrice
FROM SalesLT.Product AS p
WHERE StandardCost > 
	(SELECT AVG(UnitPrice) 
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE sod.ProductID = p.ProductID)
ORDER BY P.ProductID;
-- Note: In the previous challenge I used the IsNull function to show the Average price for product without any sales 
-- as 0. However, in this query I did not used it because it makes no sense to compare the standard cost with the
-- average price when any of those products has been sold. By removing the ISNULL function, null values are
-- equivalent to infinite, and as a result they are not considered by the > than the Standard Cost.

-- Solution 4.2 Using the Apply operator to use the result of one query into the other
SELECT p.ProductID, Name, StandardCost, ListPrice, AvgUnitPrice
FROM SalesLT.Product AS p
OUTER APPLY
	(
	SELECT ProductID, AVG(UnitPrice) AS AvgUnitPrice 
	FROM SalesLT.SalesOrderDetail AS sod
	WHERE p.ProductID = sod.ProductID
	GROUP BY ProductID
	) A
WHERE StandardCost > AvgUnitPrice;

-- Note: In this solution, the query that calculates average is executed onece, instead of two times.

-- Challenge 2: Retrieve Customer Information
-- The AdventureWorksLT database includes a table-valued user-defined function named dbo.ufnGetCustomerInformation. 
-- You must use this function to retrieve details of customers based on customer ID values retrieved from tables in the database.

-- 1. Retrieve customer information for all sales orders
-- Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders from the 
-- SalesLT.SalesOrderHeader table and the dbo.ufnGetCustomerInformation function.

SELECT SalesOrderID, soh.CustomerID, TotalDue, ci.FirstName, ci.LastName
FROM SalesLT.SalesOrderHeader AS soh
OUTER APPLY
	dbo.ufnGetCustomerInformation(soh.CustomerID) AS ci;

-- When Writing APLPIES, when calling tabled valued user defined functions, you don't need to call a select on them
-- Unless you wish to apply additional filtering or grouping over the function result. It is sufficient to Apply
-- Against the function, wich in itself behaves like a table and return a set of fields. You may call each column 
-- returned by the function in the main query.

-- 2. Retrieve customer address information
-- Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the SalesLT.Address and 
-- SalesLT.CustomerAddress tables, and the dbo.ufnGetCustomerInformation function.

SELECT ca.CustomerID, ci.FirstName, ci.LastName, a.AddressLine1, a.City 
FROM SalesLT.Address AS a JOIN
SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
OUTER APPLY
	dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY ca.CustomerID;

