
CREATE FUNCTION GetCategoryProducts(@category varchar(50))
returns @res Table (
        ProductID INT,
	    Name nvarchar(100),
		Description nvarchar(255), 
		price decimal(10,2),
		Quantity INT,
		SupplierID INT, 
		CategoryID INT,
	    CategoryName nvarchar(50)
)
as 
BEGIN
   Insert INTO @res 
   select ProductID,
          Products.Name, 
          Description,
		  price,
		  Quantity,
		  SupplierID,
		  Products.CategoryID,
		  Categories.Name as CategoryName
   from Products 
   join Categories on Products.CategoryID = Categories.CategoryID
   where Categories.Name = @category
   return 
END 
GO

select * from dbo.GetCategoryProducts('Pharaonic Replicas')


CREATE FUNCTION GetCategoryProducts2(@category varchar(50))
returns Table
as 
return (
  select ProductID,
          Products.Name, 
          Description,
		  price,
		  Quantity,
		  SupplierID,
		  Products.CategoryID,
		  Categories.Name as CategoryName
   from Products 
   join Categories on Products.CategoryID = Categories.CategoryID
   where Categories.Name = @category
)
GO

select * from dbo.GetCategoryProducts2('Pharaonic Replicas')

GO

CREATE PROC GetCustomerOrders @customerID INT 
as 
BEGIN
   if @customerID is null 
    return
	 
	select Orders.OrderID,
		   Customers.CustomerID,
		   Customers.FirstName as CustomerName,
		   Products.ProductID, 
		   Products.Name as ProductName, 
		   OrderProducts.Quantity, 
		   (OrderProducts.Quantity * OrderProducts.UnitPrice) as ProductTotalPrice,
		   Orders.ShippingMethod, 
		   Orders.Status,
		   Orders.OrderDatetime
	from OrderProducts
	join Orders on OrderProducts.OrderId = Orders.OrderId
	join Products on OrderProducts.ProductID = Products.ProductID
	join Customers on Orders.CustomerId = Customers.CustomerId
	join Individuals on Customers.CustomerID = Individuals.IndividualID
	where Orders.CustomerID = @customerID
END 

exec GetCustomerOrders 3 

