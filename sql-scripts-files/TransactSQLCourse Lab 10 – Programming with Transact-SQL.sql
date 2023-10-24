-- Set AdventureWorks as the Database we are going to use
-- Alternatively, you can set the Database in the SQL Server Management Studio Visual Interface
USE AdventureWorksLT2012;

/* 
Lab 10 – Programming with Transact-SQL

Overview
In this lab, you will use some basic Transact-SQL programming logic to work with data in the AdventureWorksLT database.

Challenge 1: Creating scripts to insert sales orders

You want to create reusable scripts that make it easy to insert sales orders. You plan to create a script to 
insert the order header record, and a separate script to insert order detail records for a specified order header. 
Both scripts will make use of variables to make them easy to reuse. 

Tip: Review the documentation for variables and the IF…ELSE block in the Transact-SQL Language Reference.

1. Write code to insert an order header

Your script to insert an order header must enable users to specify values for the order date, due date, and customer ID. 
The SalesOrderID should be generated from the next value for the SalesLT.SalesOrderNumber sequence and assigned to a variable. 
The script should then insert a record into the SalesLT.SalesOrderHeader table using these values and a hard-coded value 
of ‘CARGO TRANSPORT 5’ for the shipping method with default or NULL values for all other columns.

After the script has inserted the record, it should display the inserted SalesOrderID using the PRINT command.

Test your code with the following values:

Order Date                   Due Date                    Customer ID
Today’s date                 7 days from now             1

Note: Support for Sequence objects was added to Azure SQL Database in version 12, which became available 
in some regions in February 2015. If you are using the previous version of Azure SQL database 
(and the corresponding previous version of the AdventureWorksLT sample database), you will need to adapt your 
code to insert the sales order header without specifying the SalesOrderID (which is an IDENTITY column in older versions 
of the sample database), and then assign the most recently generated identity value to the variable you have declared.
*/
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd,7,@OrderDate);
DECLARE @CustomerID int = 1;
DECLARE @OrderID int;

INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate,  @CustomerID, 'CARGO TRANSPORT 5');

SET @OrderID = IDENT_CURRENT('SalesLT.SalesOrderHeader');

PRINT @OrderID;

/*
2. Write code to insert an order detail

The script to insert an order detail must enable users to specify a sales order ID, a product ID, a quantity, and a unit price. 
It must then check to see if the specified sales order ID exists in the SalesLT.SalesOrderHeader table. If it does, 
the code should insert the order details into the SalesLT.SalesOrderDetail table (using default values or NULL for 
unspecified columns). If the sales order ID does not exist in the SalesLT.SalesOrderHeader table, 
the code should print the message ‘The order does not exist’.  You can test for the existence of a record by using the 
EXISTS predicate.

Test your code with the following values:

Sales Order ID                                                                        Product ID       Quantity     Unit Price
The sales order ID returned by your previous code to insert a sales order header.     760              1            782.99

Then test it again with the following values:
Sales Order ID           Product ID              Quantity          Unit Price
0                        760                     1                 782.99

First test, details for the order header inserted previously
*/
DECLARE @SalesOrderID int = @OrderID;
DECLARE @ProductID int = 760;
DECLARE @OrderQty int = 1;
DECLARE @UnitPrice money = 782.99;

IF EXISTS 
	(SELECT SalesOrderID FROM SalesLT.SalesOrderHeader
	WHERE SalesOrderID = @SalesOrderID)
BEGIN
	-- The SalesOrderID eXist.
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
	VALUES (@SalesOrderID,@ProductID,@OrderQty,@UnitPrice)
END 
ELSE
BEGIN
	-- The SalesOrder ID doesn't eXist.
	print('The order does not exist');
END

-- Second: Test with the test values Sales Order ID = 0
SET @SalesOrderID = 0;
SET @ProductID = 760;
SET @OrderQty = 1;
SET @UnitPrice = 782.99;

IF EXISTS 
	(SELECT SalesOrderID FROM SalesLT.SalesOrderHeader
	WHERE SalesOrderID = @SalesOrderID)
BEGIN
	-- The SalesOrderID eXist.
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
	VALUES (@SalesOrderID,@ProductID,@OrderQty,@UnitPrice)
END 
ELSE
BEGIN
	-- The SalesOrder ID doesn't eXist.
	print('The order does not exist');
END

/*
Challenge 2: Updating Bike Prices

Adventure Works has determined that the market average price for a bike is $2,000, and consumer research has indicated that 
the maximum price any customer would be likely to pay for a bike is $5,000. 

You must write some Transact-SQL logic that incrementally increases the list price for all bike products by 10% 
until the average list price for a bike is at least the same as the market average, or until the most expensive bike 
is priced above the acceptable maximum indicated by the consumer research. 

Tip: Review the documentation for WHILE in the Transact-SQL Language Reference.

1. Write a WHILE loop to update bike prices

The loop should:

- Execute only if the average list price of a product in the ‘Bikes’ parent category is less than the market average. 
  Note that the product categories in the Bikes parent category can be determined from the SalesLT.vGetAllCategories view.

- Update all products that are in the ‘Bikes’ parent category, increasing the list price by 10%.

- Determine the new average and maximum selling price for products that are in the ‘Bikes’ parent category.

- If the new maximum price is greater than or equal to the maximum acceptable price, exit the loop; otherwise continue.
*/

/* Here's my take at the solution. Check also the Alternatives solutions at the end

First, we set the constanst for evaluating the market average and maximum acceptable price */

DECLARE @AverageMarketPrice money = 2000;
DECLARE @MaximumAcceptableprice money = 5000;

/*
Second we need to set the variables that will evaluate the While conditions, which are the following:
Average selling price is less than the market average.
Maximum selling price is less than the maximum acceptable price
*/
DECLARE @AverageSellingPrice money;
DECLARE @Maximumsellingprice money;

SELECT @AverageSellingPrice = AVG(ListPrice), @Maximumsellingprice = MAx(ListPrice)
FROM SalesLT.Product 
WHERE ProductCategoryID IN 
	(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
	WHERE ParentProductCategoryName = 'Bikes');
	
DECLARE @IterationNumber int = 1;

/* With all the variables and constans initialized, we write the WHILE Loop */

WHILE (@AverageSellingPrice < @AverageMarketPrice) AND (@Maximumsellingprice < @MaximumAcceptableprice)
BEGIN
	-- Since we entered the lopp, we Update the Products table to increase the price of all Bike products by 10%
	UPDATE SalesLT.Product
		SET ListPrice = ListPrice * 0.92755
	WHERE ProductCategoryID IN (SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
								WHERE ParentProductCategoryName = 'Bikes');
	-- After updating, we calculate the resulting new Average Selling Price and Maximum selling price
	SELECT @AverageSellingPrice = AVG(ListPrice), @Maximumsellingprice = MAx(ListPrice)
	FROM SalesLT.Product 
	WHERE ProductCategoryID IN 
		(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
		WHERE ParentProductCategoryName = 'Bikes');

	-- To keep control, I will print the resulting Average Selling Price, the Maximum selling price and the number of the iteration
	Print('Iteration Number: ' + CONVERT(nvarchar(30),@IterationNumber,1));
	Print('Average Selling Price: ' + CONVERT(nvarchar(30),@AverageSellingPrice,1));
	Print('Maximum selling price: ' + CONVERT(nvarchar(30),@Maximumsellingprice,1));

	-- Increase the iteration number:
	SET @IterationNumber = @IterationNumber + 1;

END

/* ALTERNATIVES SOLUTIONS

The solution suggested by the course doesn't take into account that if the Average or Max selling price is below the permitted
values, and then you Update it, the While ends but the final values are beyond the permitted ones.

To prevemt this from happening we should evaluate if after performing the update the permited values have gone beyond, and if
that is the case, rollback the transaction.

An alternative would be to test the Update using a select statement which multiplies List Prices by 10% 
and if the resulting averages go beyond the permitted values do not perform the update, breaking the loop

OF these two alternatives, the most efficient one would be number 2 as id doesn't involve changing or rolling back updates in the
Database, just querying

ALTERNATIVE 1: Roll Back The Transaction*/
DECLARE @AverageMarketPrice money = 2000;
DECLARE @MaximumAcceptableprice money = 5000;
DECLARE @AverageSellingPrice money;
DECLARE @Maximumsellingprice money;
DECLARE @TestAverageSellingPrice money;
DECLARE @TestMaximumsellingprice money;

SELECT @AverageSellingPrice = AVG(ListPrice), @Maximumsellingprice = MAx(ListPrice)
FROM SalesLT.Product 
WHERE ProductCategoryID IN 
	(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
	WHERE ParentProductCategoryName = 'Bikes');
	
DECLARE @IterationNumber int = 1;
/* With all the variables and constans initialized, we write the WHILE Loop */

WHILE (@AverageSellingPrice < @AverageMarketPrice) AND (@Maximumsellingprice < @MaximumAcceptableprice)
BEGIN
	-- Since we entered the lopp, we Update the Products table to increase the price of all Bike products by 10%
	-- We use Begin Transaction in order to be able to Roll Back if we exceed the max permitted values.
	BEGIN TRANSACTION
		UPDATE SalesLT.Product
			SET ListPrice = ListPrice * 0.9
		WHERE ProductCategoryID IN (SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
									WHERE ParentProductCategoryName = 'Bikes');
		-- Before Updating the variables, we test if we have exceed the permitted values
		SELECT @TestAverageSellingPrice = AVG(ListPrice), @TestMaximumsellingprice = MAx(ListPrice)
		FROM SalesLT.Product 
		WHERE ProductCategoryID IN 
			(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
			WHERE ParentProductCategoryName = 'Bikes');

		IF (@TestAverageSellingPrice < @AverageMarketPrice) AND (@TestMaximumsellingprice < @MaximumAcceptableprice)
		BEGIN
			-- After updating, we calculate the resulting new Average Selling Price and Maximum selling price
			SELECT @AverageSellingPrice = AVG(ListPrice), @Maximumsellingprice = MAx(ListPrice)
			FROM SalesLT.Product 
			WHERE ProductCategoryID IN 
				(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
				WHERE ParentProductCategoryName = 'Bikes');

			-- To keep control, I will print the resulting Average Selling Price, the Maximum selling price and the number of the iteration
			Print('Iteration Number: ' + CONVERT(nvarchar(30),@IterationNumber,1));
			Print('Average Selling Price: ' + CONVERT(nvarchar(30),@AverageSellingPrice,1));
			Print('Maximum selling price: ' + CONVERT(nvarchar(30),@Maximumsellingprice,1));

			-- Increase the iteration number:
			SET @IterationNumber = @IterationNumber + 1;
			COMMIT TRANSACTION;
			CONTINUE;
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION;
			BREAK
		END
END

/* Print the Final Values */
Print('Final Values');
Print('Iteration Number: ' + CONVERT(nvarchar(30),@IterationNumber,1));
Print('Average Selling Price: ' + CONVERT(nvarchar(30),@AverageSellingPrice,1));
Print('Maximum selling price: ' + CONVERT(nvarchar(30),@Maximumsellingprice,1));

/* ALTERNATIVE 2: Test the Update in a Select Statement */

DECLARE @AverageMarketPrice money = 2000;
DECLARE @MaximumAcceptableprice money = 5000;
DECLARE @AverageSellingPrice money;
DECLARE @Maximumsellingprice money;
DECLARE @TestAverageSellingPrice money;
DECLARE @TestMaximumsellingprice money;

SELECT @AverageSellingPrice = AVG(ListPrice), @Maximumsellingprice = MAx(ListPrice)
FROM SalesLT.Product 
WHERE ProductCategoryID IN 
	(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
	WHERE ParentProductCategoryName = 'Bikes');
	
DECLARE @IterationNumber int = 1;

/* With all the variables and constans initialized, we write the WHILE Loop */

WHILE (@AverageSellingPrice < @AverageMarketPrice) AND (@Maximumsellingprice < @MaximumAcceptableprice)
BEGIN
	-- Since we entered the lopp, we Update the Products table to increase the price of all Bike products by 10%
	-- First: We test if as a result of the Update, the Average Selling Price and Maximum selling price will exceed permitted values.
	-- For that we use a Select Statement
	SELECT @TestAverageSellingPrice = AVG(ListPrice * 1.1), @TestMaximumsellingprice = MAx(ListPrice * 1.1)
		FROM SalesLT.Product 
		WHERE ProductCategoryID IN 
			(SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
			WHERE ParentProductCategoryName = 'Bikes');

	IF (@TestAverageSellingPrice < @AverageMarketPrice) AND (@TestMaximumsellingprice < @MaximumAcceptableprice)
	BEGIN
		UPDATE SalesLT.Product
			SET ListPrice = ListPrice * 1.1
		WHERE ProductCategoryID IN (SELECT DISTINCT ProductCategoryID FROM SalesLT.vGetAllCategories
									WHERE ParentProductCategoryName = 'Bikes');
		-- After updating, we set new Average Selling Price and Maximum selling price, using the test variables
		-- we already calculated
		SET @AverageSellingPrice = @TestAverageSellingPrice;
		SET @Maximumsellingprice = @TestMaximumsellingprice;

		-- To keep control, I will print the resulting Average Selling Price, the Maximum selling price and the number of the iteration
		Print('Iteration Number: ' + CONVERT(nvarchar(30),@IterationNumber,1));
		Print('Average Selling Price: ' + CONVERT(nvarchar(30),@AverageSellingPrice,1));
		Print('Maximum selling price: ' + CONVERT(nvarchar(30),@Maximumsellingprice,1));

		-- Increase the iteration number:
		SET @IterationNumber = @IterationNumber + 1;
		CONTINUE;
	END
	ELSE
	BEGIN
		BREAK;
	END
END

/* Print the Final Values */
Print('Final Values');
Print('Iteration Number: ' + CONVERT(nvarchar(30),@IterationNumber,1));
Print('Average Selling Price: ' + CONVERT(nvarchar(30),@AverageSellingPrice,1));
Print('Maximum selling price: ' + CONVERT(nvarchar(30),@Maximumsellingprice,1));




