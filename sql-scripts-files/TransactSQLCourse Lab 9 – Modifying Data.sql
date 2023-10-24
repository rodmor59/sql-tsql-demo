-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

-- Lab 9 – Modifying Data

-- Overview
-- In this lab, you will insert, update, and delete data in the AdventureWorksLT database.

-- Challenge 1: Inserting Products

-- Each Adventure Works product is stored in the SalesLT.Product table, and each product has a unique ProductID identifier, 
-- which is implemented as an IDENTITY column in the SalesLT.Product table. Products are organized into categories, 
-- which are defined in the SalesLT.ProductCategory table. The products and product category records are related 
-- by a common ProductCategoryID identifier, which is an IDENTITY column in the SalesLT.ProductCategory table.

-- Adventure Works has started selling the following new product. Insert it into the SalesLT.Product table, 
-- using default or NULL values for unspecified columns:

-- Name        ProductNumber    StandardCost    ListPrice    ProductCategoryID    SellStartDate
-- LED Lights  LT-L123          2.56            12.99        37                   <Today>

-- After you have inserted the product, run a query to determine the ProductID that was generated. 

-- Then run a query to view the row for the product in the SalesLT.Product table.

-- Solution to the challenge:

-- I run a query to explore the table definition of SalesLT.Product to see which fields have a column default.
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Product'
-- Most columns have a column default value of null, except the rowguid and ModifiedDate fields.

-- The field ProductID is an Identity (Identity parameter is set to true).
-- The identity constraint inform SQL Server to auto increment the numeric value within the specified column anytime a new record 
-- is INSERTED.
-- This means that we don't have to specify a value for ProductID when writing the INSERT. The value will be generate automatically
-- When we run the INSERT.

-- Now we run the Insert Query, using the GetDate Function to get today's date for the SellStartDate column.

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('LED Lights','LT-L123',2.56,12.99,37,GETDATE());

-- Use Scope_Identity() to get the las Identity value inserted. This is the ProductID inserted in the previous transaction

SELECT SCOPE_IDENTITY();

-- Using the Scope_Identity, I run a Quert to select the row that I just inserted.

Select * From SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();

-- 2. Insert a new category with two products

-- Adventure Works is adding a product category for ‘Bells and Horns’ to its catalog. 
-- The parent category for the new category is 4 (Accessories). 
-- This new category includes the following two new products:

-- Name             ProductNumber  StandardCost    ListPrice   ProductCategoryID                  SellStartDate
-- Bicycle Bell     BB-RING        2.47            4.99        <The new ID for Bells and Horns>   <Today>
-- Bicycle Horn     BB-PARP        1.29            3.75        <The new ID for Bells and Horns>   <Today>

-- Write a query to insert the new product category.

INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES (4,'Bells and Horns')

-- Then insert the two new products with the appropriate ProductCategoryID value.
-- To get the ProductCategoryID value, we will use the IDENT_CURRENT function, which returns the last IDENTITY value generated 
-- for a specific table under any connection, regardless of the scope of the T-SQL statement that generated that value.

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES ('Bicycle Bell','BB-RING',2.47,4.99,IDENT_CURRENT('SalesLT.ProductCategory'),GETDATE()),
		('Bicycle Horn','BB-PARP',1.29,3.75,IDENT_CURRENT('SalesLT.ProductCategory'),GETDATE());

-- After you have inserted the products, query the SalesLT.Product and SalesLT.ProductCategory tables to verify 
-- that the data has been inserted.

-- First, query them separately
SELECT * FROM SalesLT.ProductCategory
WHERE ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory')

SELECT * FROM SalesLT.Product
WHERE ProductID = IDENT_CURRENT('SalesLT.Product') OR ProductID = (IDENT_CURRENT('SalesLT.Product') - 1)

-- Second, query them in the same SELECT instruction

SELECT p.Name, pc.Name FROM 
SalesLT.Product AS p JOIN SalesLT.ProductCategory AS pc ON p.ProductCategoryID = PC.ProductCategoryID
WHERE p.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory')

-- Challenge 2: Updating Products
-- You have inserted data for a product, but the pricing details are not correct. 
-- You must now update the records you have previously inserted to reflect the correct pricing. 
-- Tip: Review the documentation for UPDATE in the Transact-SQL Language Reference.

-- 1. Update product prices
-- The sales manager at Adventure Works has mandated a 10% price increase for all products in the Bells and Horns category. 
-- Update the rows in the SalesLT.Product table for these products to increase their price by 10%.

UPDATE SalesLT.Product
	SET ListPrice = ListPrice * 1.1
	WHERE ProductCategoryID = 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory
			WHERE Name = 'Bells and Horns');

-- After updating, check if the changes were made

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory
			WHERE Name = 'Bells and Horns');

-- 2. Discontinue products

-- The new LED lights you inserted in the previous challenge are to replace all previous light products. 
-- Update the SalesLT.Product table to set the DiscontinuedDate to today’s date for all products in the 
-- Lights category (Product Category ID 37) other than the LED Lights product you inserted previously in
-- the challenge number 1.

-- First, we check the current values, in which Discountinued Date is Null

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 37;

-- Second: We Make the update.

UPDATE SalesLT.Product
	SET DiscontinuedDate = GETDATE()
	WHERE ProductCategoryID = 37
	AND ProductNumber <> 'LT-L123';

-- third: After updating, we check that the changes were made and the Discontinued Date was set to today.

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 37;

-- Challenge 3: Deleting Products

-- The Bells and Horns category has not been successful, and it must be deleted from the database. 
-- Tip: Review the documentation for DELETE in the Transact-SQL Language Reference.

-- 1. Delete a product category and its products
-- Delete the records foe the Bells and Horns category and its products. 
-- You must ensure that you delete the records from the tables in the correct order to avoid a foreign-key constraint violation.

-- To avoid FK constraint violations, we must first delete the products from the products table. Only then can we delete
-- the Bells and Horns product category.

-- First, we check the records that we are going to delete

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory
			WHERE Name = 'Bells and Horns');

SELECT * 
FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';

--- Second: Delete the records

DELETE FROM SalesLT.Product
WHERE ProductCategoryID = 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory
			WHERE Name = 'Bells and Horns');

DELETE FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';

-- Third: we check that the records were deleted both from the product and product category tables.

SELECT * FROM SalesLT.Product
WHERE ProductCategoryID = 
		(SELECT ProductCategoryID 
			FROM SalesLT.ProductCategory
			WHERE Name = 'Bells and Horns');

SELECT * 
FROM SalesLT.ProductCategory
WHERE Name = 'Bells and Horns';


