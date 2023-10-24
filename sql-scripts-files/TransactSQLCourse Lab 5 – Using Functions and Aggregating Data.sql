-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 5 – Using Functions and Aggregating Data

-- Overview
-- In this lab, you will write queries that use functions to retrieve, aggregate, and group data 
-- from the AdventureWorksLT database.

-- Challenge 1: Retrieve Product Information
-- Your reports are returning the correct records, but you would like to modify how these records are displayed.

-- 1. Retrieve the name and approximate weight of each product
-- Write a query to return the product ID of each product, together with the product name formatted as upper case and 
-- a column named ApproxWeight with the weight of each product rounded to the nearest whole unit.

SELECT ProductID, 
	UPPER(Name) NameInUppercase, 
	Weight, CEILING(ISNULL(Weight, 0)) AS ApproxWeight
FROM SalesLT.Product;

-- 2. Retrieve the year and month in which products were first sold
-- Extend your query to include columns named SellStartYear and SellStartMonth containing the year and month in which Adventure Works 
-- started selling each product. The month should be displayed as the month name (for example, ‘January’).

SELECT ProductID, 
	UPPER(Name) NameInUppercase, 
	Weight, CEILING(ISNULL(Weight, 0)) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, 
	DATENAME(m,SellStartDate) AS SellStartMonth
FROM SalesLT.Product;

-- 3. Extract product types from product numbers
-- Extend your query to include a column named ProductType that contains the leftmost two characters from the product number.

SELECT ProductID, 
	UPPER(Name) NameInUppercase, 
	Weight, CEILING(ISNULL(Weight, 0)) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, 
	DATENAME(m,SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber,2) AS ProductType
FROM SalesLT.Product;

-- 4. Retrieve only products with a numeric size
-- Extend your query to filter the product returned so that only products with a numeric size are included.

SELECT ProductID, 
	UPPER(Name) NameInUppercase, 
	Weight, CEILING(ISNULL(Weight, 0)) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, 
	DATENAME(m,SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber,2) AS ProductType,
	Size
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;

-- Challenge 2: Rank Customers by Revenue
-- The sales manager would like a list of customers ranked by sales.
-- 1. Retrieve companies ranked by sales totals
-- Write a query that returns a list of company names with a ranking of their place in a list of highest TotalDue values from 
-- the SalesOrderHeader table.

SELECT CompanyName,
	TotalDue,
	RANK() OVER(ORDER BY TotalDue DESC) AS RankByRevenue
FROM SalesLT.Customer AS c JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID;

-- Challenge 3: Aggregate Product Sales
-- The product manager would like aggregated information about product sales.

-- 1. Retrieve total sales by product
-- Write a query to retrieve a list of the product names and the total revenue calculated as the sum of the LineTotal 
-- from the SalesLT.SalesOrderDetail table, with the results sorted in descending order of total revenue.

SELECT p.ProductID,
	p.ProductNumber,
	FORMAT(SUM(so.LineTotal),'#,#.##') AS TotalRevenue
FROM SalesLT.Product AS p JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
GROUP BY p.ProductID, p.ProductNumber
ORDER BY TotalRevenue DESC;

-- 2. Filter the product sales list to include only products that cost over $1,000
-- Modify the previous query to include sales totals for products that have a list price of more than $1000.

SELECT p.ProductID,
	p.ProductNumber, 
	FORMAT(p.ListPrice,'#,#.##') AS ListPrice,
	FORMAT(SUM(so.LineTotal),'#,#.##') AS TotalRevenue
FROM SalesLT.Product AS p JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.ProductID, p.ProductNumber, p.ListPrice
ORDER BY TotalRevenue DESC;

-- Added the Format function for presentation purposes.
-- However, on a real setting in which the DB is integrated with an application, you might want to return
-- Data to the application in its original format and leave the presentation for the application.

-- 3. Filter the product sales groups to include only total sales over $20,000
-- Modify the previous query to only include only product groups with a total sales value greater than $20,000.

SELECT p.ProductID,
	p.ProductNumber, 
	p.ListPrice,
	SUM(so.LineTotal) AS TotalRevenue
FROM SalesLT.Product AS p JOIN SalesLT.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.ProductID, p.ProductNumber, p.ListPrice
HAVING SUM(so.LineTotal) > 20000
ORDER BY TotalRevenue DESC;







