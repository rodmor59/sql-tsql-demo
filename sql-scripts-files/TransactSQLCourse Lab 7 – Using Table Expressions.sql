-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 7 – Using Table Expressions
-- Overview
-- In this lab, you will use views, temporary tables, variables, table-valued functions, derived tables, 
-- and common table expressions to retrieve data from the AdventureWorksLT database.

-- Challenge 1: Retrieve Product Information

-- Adventure Works sells many products that are variants of the same product model. You must write queries that retrieve information 
-- about these products

-- 1. Retrieve product model descriptions

-- Retrieve the product ID, product name, product model name, and product model summary for each product from the SalesLT.Product 
-- table and the SalesLT.vProductModelCatalogDescription view.

SELECT p.ProductID, p.Name AS ProductName, p.ProductModelID AS ProductModelId, 
	pm.Name AS ProductModelName, pm.Summary as ProductModelSummary
FROM SalesLT.Product AS p LEFT JOIN SalesLT.vProductModelCatalogDescription AS pm
ON p.ProductModelID = pm.ProductModelID
ORDER BY ProductID;

-- In this version, we changed the INNER JOIN for a LEFT JOIN because there are records in the Product Table that doesn't
-- have a corresponding Product Model ID in the Product Model Category Description View. This results in 295 rows.
-- If the LEFT JOIN is replaced with an INNER JOIN, it will only retur 40 records.
-- This means that there are 255 products without a product model description in the view.
-- The query with the INNER JOIN is as follows.

SELECT p.ProductID, p.Name AS ProductName, p.ProductModelID AS ProductModelId, 
	pm.Name AS ProductModelName, pm.Summary as ProductModelSummary
FROM SalesLT.Product AS p JOIN SalesLT.vProductModelCatalogDescription AS pm
ON p.ProductModelID = pm.ProductModelID
ORDER BY ProductID;

-- 2. Create a table of distinct colors 

-- Tip: Review the documentation for Variables in Transact-SQL Language Reference.

-- Create a table variable and populate it with a list of distinct colors from the SalesLT.Product table. 
-- Then use the table variable to filter a query that returns the product ID, name, and color from the SalesLT.Product table 
-- so that only products with a color listed in the table variable are returned.

DECLARE @table_color TABLE (
    Color nvarchar (15)
);

INSERT INTO @table_color
	SELECT DISTINCT(Color) 
		FROM SalesLT.Product;

SELECT p.ProductID, p.Name, p.Color
FROM SalesLT.Product AS p
WHERE p.Color IN (SELECT Color FROM @table_color);

-- 3. Retrieve product parent categories
-- The AdventureWorksLT database includes a table-valued function named dbo.ufnGetAllCategories, which returns a table of product 
-- categories (for example ‘Road Bikes’) and parent categories (for example ‘Bikes’). Write a query that uses this function to 
-- return a list of all products including their parent category and category.

SELECT pc.ProductCategoryID, pc.ParentProductCategoryName, pc.ProductCategoryName, 
	p.ProductID, p.Name
FROM SalesLT.Product AS p JOIN dbo.ufnGetAllCategories() AS pc
	ON p.ProductCategoryID = pc.ProductCategoryID
ORDER BY pc.ParentProductCategoryName, pc.ProductCategoryName, p.Name

-- Challenge 2: Retrieve Customer Sales Revenue

-- Each Adventure Works customer is a retail company with a named contact. You must create queries that return the total 
-- revenue for each customer, including the company and customer contact names. 

-- Tip: Review the documentation for the WITH common_table_expression syntax in the Transact-SQL language reference.

-- 1. Retrieve sales revenue by customer and contact
-- Retrieve a list of customers in the format Company (Contact Name) together with the total revenue for that customer. 
-- Use a derived table or a common table expression to retrieve the details for each sales order, and then query the derived table 
-- or CTE to aggregate and group the data.

-- First solution using a derived table

SELECT CompanyContact, SUM(SalesTotal) AS CustomerRevenue
FROM
(SELECT CONCAT(c.CompanyName,' (',FirstName,' ',LastName,')'),
	ISNULL(so.TotalDue, 0)
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS so
ON c.CustomerID = SO.CustomerID) AS cso_derived(CompanyContact,SalesTotal)
GROUP BY CompanyContact
ORDER BY CompanyContact;

-- Second solution using a common table expression (CTE)

WITH CustomerSales_CTE (CompanyContact, SalesTotal)
AS (SELECT CONCAT(c.CompanyName,' (',FirstName,' ',LastName,')'), 
	ISNULL(so.TotalDue, 0)
	FROM SalesLT.Customer AS c
	JOIN SalesLT.SalesOrderHeader AS so
	ON c.CustomerID = SO.CustomerID)
SELECT CompanyContact, SUM(SalesTotal) AS CustomerRevenue
FROM CustomerSales_CTE
GROUP BY CompanyContact
ORDER BY CompanyContact;







