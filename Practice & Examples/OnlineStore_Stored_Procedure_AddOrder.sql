
-- Database: Online Store

--Develop a stored procedure that processes a new order. 
--It should add entries to the Orders and OrderProducts tables, 
--update the product quantity in the Products table, and return 
--the total order amount.

CREATE Type OrderItems as Table (
    -- OrderId
	ProductID INT,
	Quantity INT, 
	UnitPrice decimal(10,2)
)
GO

CREATE OR ALTER PROC AddOrder 
	@CustomerID INT,
	@OrderDatetime datetime2,
	@ShippingMethod nvarchar(50),
	@OrderItems OrderItems READONLY,
	@TotalOrderAmount decimal(19,4) OUTPUT
as 
BEGIN 
   if @CustomerID is null or 
      @OrderDatetime is null or 
	  @ShippingMethod is null or 
	  LTRIM(RTRIM(@ShippingMethod)) = ''
	  BEGIN
	     PRINT 'Some of the parameters are null'
		 return 
	  END 

	  BEGIN TRANSACTION 
	  BEGIN TRY 
	   INSERT INTO Orders (CustomerID, OrderDatetime, ShippingMethod)
	   VALUES(@CustomerID, @OrderDatetime, @ShippingMethod)

	   if not exists (select 1 from @OrderItems)
	    BEGIN
		  PRINT  'No Order Items were provided'
		  Select 'Aborting Adding The Order' 
		  THROW 
		 END 

	   declare @NewOrderId INT= SCOPE_IDENTITY()
	   DECLARE OrderItemsCursor CURSOR 
	   for select * from @OrderItems
	   for read only 

	   DECLARE @ProductID INT, 
	           @Quantity INT, 
			   @UnitPrice decimal(10,2)

	   OPEN OrderItemsCursor 
	   FETCH OrderItemsCursor into @ProductID, @Quantity, @UnitPrice
	   WHILE @@FETCH_STATUS = 0
	   BEGIN
	     DECLARE @ProductActualQuantity INT = NULL, @ActualUnitPrice decimal(10,2) = NULL
		 SELECT @ProductActualQuantity=QUANTITY, @ActualUnitPrice=price from Products
		 where ProductID = @ProductID

		 -- Product is null 
		 if @ProductActualQuantity is null 
		   BEGIN
		     PRINT 'There is no product with id: '+@ProductID
			 Select 'Aborting Adding The Order' 
			 THROW	
		   END 

		 if @ProductActualQuantity < @Quantity
			 BEGIN
			  PRINT  'No Enough Units in the stock for product: ' + @ProductID
			  Select 'Aborting Adding The Order' 
			  THROW 
			 END 

		 if @ActualUnitPrice ! = @UnitPrice 
			 BEGIN
			  PRINT  'Provided Unit price for product: ' + @ProductID 
			  + 'is different from The actual Unit price for this product'
			  Select 'Aborting Adding The Order' 
			  THROW 
			 END 

		 Update Products 
		 SET Quantity = Quantity - @Quantity
		 WHERE ProductID=@ProductID

		 INSERT INTO OrderProducts(OrderID, ProductID, Quantity, UnitPrice)
		 VALUES (@NewOrderId, @ProductID, @Quantity, @UnitPrice)

		 SET @TotalOrderAmount = @TotalOrderAmount + @Quantity * @UnitPrice

	     FETCH OrderItemsCursor into @ProductID, @Quantity, @UnitPrice
	   END 

	   COMMIT 
	  END TRY 
	  BEGIN CATCH 
	   PRINT 'Could not add the order '
	  IF XACT_STATE() <> 0 
        ROLLBACK
ROLLBACK 
	  END CATCH 
END 


DECLARE @OrderItems OrderItems
INSERT INTO @OrderItems (ProductID, Quantity, UnitPrice)
VALUES (1, 2, 299.99), (3, 1, 79.99), (5, 3, 9.99)

DECLARE @TotalAmount DECIMAL(19,4)

EXEC AddOrder 
    @CustomerID = 1,
    @OrderDatetime = '2024-10-20 14:30:00',
    @ShippingMethod = 'Express',
    @OrderItems = @OrderItems,
    @TotalOrderAmount = @TotalAmount OUTPUT

PRINT 'Total Order Amount: ' + CAST(@TotalAmount AS NVARCHAR(20))

DECLARE @OrderItems OrderItems
INSERT INTO @OrderItems (ProductID, Quantity, UnitPrice)
VALUES (1, 1, 299.99), (999, 2, 20.00)

DECLARE @TotalAmount DECIMAL(19,4)

EXEC AddOrder 
    @CustomerID = 2,
    @OrderDatetime = '2024-10-20 15:45:00',
    @ShippingMethod = 'Standard',
    @OrderItems = @OrderItems,
    @TotalOrderAmount = @TotalAmount OUTPUT

PRINT 'Total Order Amount: ' + CAST(@TotalAmount AS NVARCHAR(20))

DECLARE @OrderItems OrderItems
INSERT INTO @OrderItems (ProductID, Quantity, UnitPrice)
VALUES (2, 200, 49.99)

DECLARE @TotalAmount DECIMAL(19,4)

EXEC AddOrder 
    @CustomerID = 3,
    @OrderDatetime = '2024-10-20 16:15:00',
    @ShippingMethod = 'Next Day',
    @OrderItems = @OrderItems,
    @TotalOrderAmount = @TotalAmount OUTPUT

PRINT 'Total Order Amount: ' + CAST(@TotalAmount AS NVARCHAR(20))

-- Another soltion that a SET Based Operation instead of the cursor
CREATE OR ALTER PROC AddOrder2
	@CustomerID INT,
	@OrderDatetime datetime2,
	@ShippingMethod nvarchar(50),
	@OrderItems OrderItems READONLY,
	@TotalOrderAmount decimal(19,4) OUTPUT
as 
BEGIN 
   if @CustomerID is null or 
      @OrderDatetime is null or 
	  @ShippingMethod is null or 
	  LTRIM(RTRIM(@ShippingMethod)) = ''
	  BEGIN
	     PRINT 'Some of the parameters are null'
		 return 
	  END 

	 BEGIN TRANSACTION

BEGIN TRY
    -- Insert the order
    INSERT INTO Orders (CustomerID, OrderDatetime, ShippingMethod)
    VALUES (@CustomerID, @OrderDatetime, @ShippingMethod);

    DECLARE @NewOrderId INT = SCOPE_IDENTITY();

    -- Step 1: Validate all order items before proceeding with updates
    IF EXISTS (
        SELECT 1 
        FROM @OrderItems OI
        LEFT JOIN Products P ON OI.ProductID = P.ProductID
        WHERE P.ProductID IS NULL 
           OR P.Quantity < OI.Quantity 
           OR P.Price != OI.UnitPrice
    )
    BEGIN
        -- Check if any validation failed
        THROW 50000, 'Invalid product information or insufficient stock in one or more items.', 1;
    END

    -- Step 2: If validation passes, proceed with updates
    -- Update the product quantities
    UPDATE P
    SET P.Quantity = P.Quantity - OI.Quantity
    FROM Products P
    INNER JOIN @OrderItems OI ON P.ProductID = OI.ProductID;

    -- Insert all items into OrderProducts
    INSERT INTO OrderProducts (OrderID, ProductID, Quantity, UnitPrice)
    SELECT @NewOrderId, OI.ProductID, OI.Quantity, OI.UnitPrice
    FROM @OrderItems OI;

    -- Calculate the total order amount
    SELECT @TotalOrderAmount = SUM(OI.Quantity * OI.UnitPrice)
    FROM @OrderItems OI;

    COMMIT;
END TRY

BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK;

    -- Re-raise the error
    THROW;
END CATCH

END 