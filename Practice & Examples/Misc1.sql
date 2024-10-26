SET NOCOUNT ON;
USE tempdb;

-- Drop existing tables if they exist
IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL
    DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL
    DROP TABLE dbo.Customers;

-- Create Customers table
CREATE TABLE dbo.Customers
(
    custid CHAR(5) NOT NULL,
    city VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (custid)
);

-- Create Orders table
CREATE TABLE dbo.Orders
(
    orderid INT NOT NULL,
    custid CHAR(5) NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (orderid),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (custid) REFERENCES dbo.Customers(custid)
);

-- Insert data into Customers table
INSERT INTO dbo.Customers (custid, city) VALUES
    ('FISSA', 'Madrid'),
    ('FRNDO', 'Madrid'),
    ('KRLOS', 'Madrid'),
    ('MRPHS', 'Zion');

-- Insert data into Orders table

    

-- Select data from Customers and Orders tables
SELECT * FROM dbo.Customers;
SELECT * FROM dbo.Orders;
GO

create table sales 
(
   custid int,
   amount decimal(10,2) check(amount > 0) 
)
GO
insert into sales(custid, amount) values(2,null) 
insert into sales(custid, amount) values(5,12) 
insert into sales(custid, amount) values(2,1000) 
insert into sales(custid, amount) values(2,1500) 
insert into sales(custid, amount) values(2,2530) 
insert into sales(custid, amount) values(2,1500) 
GO
select * from sales
order by amount desc

declare @v1 int = 343, @v2 int = 589 
SELECT @v1 = @v2, @V2 = @v1  from employees where employeeid = 1
select @v1, @v2
GO

declare @v1 int = 343, @v2 int = 589 
select @v1=Salary, @v2 = @v1 from employees
select @v1, @v2


select EmployeeID, Name from employees 
order by salary 
GO

select distinct EmployeeID, Name from employees 
order by salary 

create table People 
(
   id int, 
   name varchar(50), 
)

select top (3) orderId, custId 
from orders 
order by orderId desc


select orderid, custid
from orders 
order by orderid desc 
offset 4 rows fetch next 2 rows only


select * from 
(
    select top (100) percent EmployeeID,
	       Name,
		   Salary
    from employees 
	order by Salary desc 
)x

  if object_id(N'dbo.MyOrders', N'V') is not null drop view dbo.MyOrders 
  GO

 CREATE	VIEW dbo.MyOrders
 AS
 SELECT 	orderid,	custid
 FROM	dbo.Orders
 ORDER	BY	orderid	DESC
 offset 0 rows  
 GO

 select * from MyOrders 


  SELECT	TOP	(3)	custid, orderid
 FROM	dbo.Orders
 ORDER	BY	orderid	DESC;