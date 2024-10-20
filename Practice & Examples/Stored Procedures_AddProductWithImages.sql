CREATE TYPE ImageURLs AS TABLE (
  URL VARCHAR(255)
)
GO

create PROCEDURE AddProductWithImages 
  @Name NVARCHAR(100),
  @Description NVARCHAR(255), 
  @Price DECIMAL(10,2),
  @Quantity INT,
  @CategoryID INT,
  @SupplierID INT,
  @ImageURLs ImageURLs READONLY
AS
BEGIN
   IF @Name IS NULL OR
      @Description IS NULL OR
      @Price IS NULL OR
      @Quantity IS NULL OR
      @CategoryID IS NULL OR
      @SupplierID IS NULL
   BEGIN
      PRINT 'Cannot insert Product: Some of the provided parameters are null'
      RETURN
   END
   
   IF @Price < 0 OR
      @Quantity < 0 OR
      NOT EXISTS (SELECT 1 FROM Suppliers WHERE SupplierID = @SupplierID)
   BEGIN
      PRINT 'Cannot insert Product: Some of the provided parameters are invalid'
      RETURN
   END
   
   BEGIN TRANSACTION
   BEGIN TRY
      -- Insert the product into Products table
      INSERT INTO Products(Name, Description, Price, Quantity, CategoryID, SupplierID)
      VALUES (@Name, @Description, @Price, @Quantity, @CategoryID, @SupplierID)
      
      -- Get the newly inserted ProductID
      DECLARE @NewProductId INT = SCOPE_IDENTITY()

      -- Check if @ImageURLs contains any rows
      IF NOT EXISTS (SELECT 1 FROM @ImageURLs)
      BEGIN
         PRINT 'Warning: @ImageURLs is empty.'
         PRINT 'Warning: No Images were added.'
         COMMIT TRANSACTION
         RETURN
      END
      
      -- Insert Image URLs into ProductImages table
      INSERT INTO ProductImages (ImageURL, ProductID)
      SELECT URL AS ImageURL, @NewProductId AS ProductID
      FROM @ImageURLs

      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
      PRINT 'An error has occurred when inserting product.'
      ROLLBACK TRANSACTION
   END CATCH
END


DECLARE @ImageURLs AS ImageURLs;
INSERT INTO @ImageURLs (URL) VALUES ('https://example.com/laptop-image.jpg');

EXEC AddProductWithImages
    @Name = 'High-Performance Laptop',
    @Description = '15-inch laptop with 16GB RAM and 512GB SSD',
    @price = 999.99,
    @Quantity = 50,
    @CategoryID = 1,  -- Assuming 1 is the CategoryID for Electronics
    @SupplierID = 1,  -- Assuming 1 is a valid SupplierID
    @ImageURLs = @ImageURLs;

DECLARE @ImageURLs AS ImageURLs;
INSERT INTO @ImageURLs (URL) VALUES 
    ('https://example.com/chair-front.jpg'),
    ('https://example.com/chair-side.jpg'),
    ('https://example.com/chair-back.jpg');

EXEC AddProductWithImages
    @Name = 'Ergonomic Office Chair',
    @Description = 'Comfortable chair with lumbar support and adjustable height',
    @price = 249.99,
    @Quantity = 100,
    @CategoryID = 2,  -- Assuming 2 is the CategoryID for Furniture
    @SupplierID = 2,  -- Assuming 2 is a valid SupplierID
    @ImageURLs = @ImageURLs;

DECLARE @ImageURLs AS ImageURLs;

EXEC AddProductWithImages
    @Name = 'Classic Notebook',
    @Description = 'A5 size, 200 pages, hardcover notebook',
    @price = 12.99,
    @Quantity = 500,
    @CategoryID = 3,  -- Assuming 3 is the CategoryID for Stationery
    @SupplierID = 3,  -- Assuming 3 is a valid SupplierID
    @ImageURLs = @ImageURLs;


