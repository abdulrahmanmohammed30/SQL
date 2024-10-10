CREATE TABLE #Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL
);
Go 

CREATE TABLE #Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL
);
Go 

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    SaleDate DATE NOT NULL,
    ProductID INT NOT NULL,
    EmployeeID INT NOT NULL,
    Quantity INT NOT NULL,
	Price INT NOT NULL,
    TotalPrice AS (Quantity * Price),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
Go

INSERT INTO #Product (ProductName, Price, Stock)
VALUES 
('Laptop', 1000.00, 50),
('Mouse', 20.00, 200),
('Keyboard', 50.00, 150),
('Monitor', 300.00, 80),
('Headphones', 80.00, 100),
('Printer', 150.00, 60),
('USB Cable', 10.00, 300),
('Phone', 500.00, 90),
('Tablet', 400.00, 70),
('Charger', 25.00, 150),
('Hard Drive', 120.00, 100),
('Camera', 700.00, 30),
('Speaker', 150.00, 100),
('Smart Watch', 250.00, 60),
('Memory Card', 30.00, 200),
('Flash Drive', 15.00, 300),
('Graphics Card', 600.00, 40),
('Processor', 400.00, 50),
('Motherboard', 200.00, 60),
('Power Supply', 100.00, 80),
('RAM', 80.00, 150),
('Cooling Fan', 20.00, 200),
('Keyboard Wrist Rest', 15.00, 100),
('Monitor Stand', 50.00, 70),
('External DVD Drive', 40.00, 50),
('Docking Station', 150.00, 40),
('Phone Case', 10.00, 200),
('Wireless Charger', 60.00, 80),
('Stylus Pen', 30.00, 120),
('Laptop Stand', 40.00, 50);
Go 
INSERT INTO #Employee (FirstName, LastName, HireDate, JobTitle)
VALUES 
('John', 'Smith', '2020-01-15', 'Sales Representative'),
('Jane', 'Doe', '2019-03-22', 'Sales Manager'),
('Michael', 'Johnson', '2018-05-30', 'Cashier'),
('Emily', 'Davis', '2021-07-10', 'Sales Associate'),
('Robert', 'Brown', '2020-09-20', 'Sales Representative'),
('Jessica', 'Taylor', '2017-02-18', 'Store Manager'),
('William', 'Wilson', '2019-12-01', 'Cashier'),
('Olivia', 'Anderson', '2020-11-13', 'Sales Representative'),
('David', 'Thomas', '2021-01-25', 'Sales Manager'),
('Sophia', 'Moore', '2019-08-15', 'Sales Associate'),
('Daniel', 'Martin', '2020-06-14', 'Sales Representative'),
('Emma', 'Garcia', '2018-10-05', 'Cashier'),
('James', 'Martinez', '2021-02-02', 'Sales Associate'),
('Ava', 'Rodriguez', '2020-04-24', 'Sales Manager'),
('Jacob', 'Lee', '2020-11-22', 'Cashier'),
('Isabella', 'Perez', '2019-12-12', 'Sales Associate'),
('Ethan', 'Harris', '2021-03-17', 'Sales Representative'),
('Mia', 'Clark', '2020-08-29', 'Sales Manager'),
('Alexander', 'Lewis', '2019-06-18', 'Cashier'),
('Charlotte', 'Walker', '2021-07-20', 'Sales Associate'),
('Matthew', 'Young', '2020-03-15', 'Sales Representative'),
('Amelia', 'Allen', '2021-05-23', 'Sales Manager'),
('Benjamin', 'King', '2018-09-19', 'Cashier'),
('Harper', 'Wright', '2019-07-25', 'Sales Associate'),
('Lucas', 'Scott', '2020-01-30', 'Sales Representative'),
('Ella', 'Green', '2021-09-04', 'Sales Associate'),
('Jack', 'Baker', '2018-11-27', 'Store Manager'),
('Abigail', 'Adams', '2019-05-31', 'Cashier'),
('Henry', 'Nelson', '2020-07-21', 'Sales Representative');
Go 


INSERT INTO #Sales (SaleDate, ProductID, EmployeeID, Quantity, Price)
VALUES 
('2023-01-10', 1, 1, 3, 1000), -- Laptop (Price: 1000)
('2023-01-11', 2, 2, 10, 20),  -- Mouse (Price: 20)
('2023-01-12', 3, 3, 5, 50),   -- Keyboard (Price: 50)
('2023-01-13', 4, 4, 2, 300),  -- Monitor (Price: 300)
('2023-01-14', 5, 5, 4, 80),   -- Headphones (Price: 80)
('2023-01-15', 6, 6, 1, 150),  -- Printer (Price: 150)
('2023-01-16', 7, 7, 6, 10),   -- USB Cable (Price: 10)
('2023-01-17', 8, 8, 2, 500),  -- Phone (Price: 500)
('2023-01-18', 9, 9, 3, 400),  -- Tablet (Price: 400)
('2023-01-19', 10, 10, 1, 25), -- Charger (Price: 25)
('2023-01-20', 11, 11, 7, 120),-- Hard Drive (Price: 120)
('2023-01-21', 12, 12, 3, 700),-- Camera (Price: 700)
('2023-01-22', 13, 13, 4, 150),-- Speaker (Price: 150)
('2023-01-23', 14, 14, 2, 250),-- Smart Watch (Price: 250)
('2023-01-24', 15, 15, 5, 30), -- Memory Card (Price: 30)
('2023-01-25', 16, 16, 8, 15), -- Flash Drive (Price: 15)
('2023-01-26', 17, 17, 1, 600),-- Graphics Card (Price: 600)
('2023-01-27', 18, 18, 4, 400),-- Processor (Price: 400)
('2023-01-28', 19, 19, 2, 200),-- Motherboard (Price: 200)
('2023-01-29', 20, 20, 6, 100),-- Power Supply (Price: 100)
('2023-01-30', 21, 21, 3, 80), -- RAM (Price: 80)
('2023-01-31', 22, 22, 7, 20), -- Cooling Fan (Price: 20)
('2023-02-01', 23, 23, 1, 15), -- Keyboard Wrist Rest (Price: 15)
('2023-02-02', 24, 24, 2, 50), -- Monitor Stand (Price: 50)
('2023-02-03', 25, 25, 4, 40), -- External DVD Drive (Price: 40)
('2023-02-04', 26, 26, 3, 150),-- Docking Station (Price: 150)
('2023-02-05', 27, 27, 5, 10), -- Phone Case (Price: 10)
('2023-02-06', 28, 28, 6, 60), -- Wireless Charger (Price: 60)
('2023-02-07', 29, 29, 4, 30), -- Stylus Pen (Price: 30)
('2023-02-08', 30, 30, 1, 40); -- Laptop Stand (Price: 40)
G0



-- Randomly insert 300 sales into the Sales table
DECLARE @Counter INT = 1;

WHILE @Counter <= 5000
BEGIN
    -- Generate random EmployeeID between 1 and 30
    DECLARE @EmployeeID INT = (SELECT FLOOR(RAND() * 30) + 1);

    -- Generate random ProductID between 1 and 30
    DECLARE @ProductID INT = (SELECT FLOOR(RAND() * 30) + 1);

    -- Generate random Quantity between 1 and 10
    DECLARE @Quantity INT = (SELECT FLOOR(RAND() * 10) + 1);

    -- Generate random Price for the ProductID (could range based on typical prices)
    DECLARE @Price INT;
    SET @Price = CASE @ProductID
        WHEN 1 THEN 1000 -- Laptop
        WHEN 2 THEN 20   -- Mouse
        WHEN 3 THEN 50   -- Keyboard
        WHEN 4 THEN 300  -- Monitor
        WHEN 5 THEN 80   -- Headphones
        WHEN 6 THEN 150  -- Printer
        WHEN 7 THEN 10   -- USB Cable
        WHEN 8 THEN 500  -- Phone
        WHEN 9 THEN 400  -- Tablet
        WHEN 10 THEN 25  -- Charger
        WHEN 11 THEN 120 -- Hard Drive
        WHEN 12 THEN 700 -- Camera
        WHEN 13 THEN 150 -- Speaker
        WHEN 14 THEN 250 -- Smart Watch
        WHEN 15 THEN 30  -- Memory Card
        WHEN 16 THEN 15  -- Flash Drive
        WHEN 17 THEN 600 -- Graphics Card
        WHEN 18 THEN 400 -- Processor
        WHEN 19 THEN 200 -- Motherboard
        WHEN 20 THEN 100 -- Power Supply
        WHEN 21 THEN 80  -- RAM
        WHEN 22 THEN 20  -- Cooling Fan
        WHEN 23 THEN 15  -- Keyboard Wrist Rest
        WHEN 24 THEN 50  -- Monitor Stand
        WHEN 25 THEN 40  -- External DVD Drive
        WHEN 26 THEN 150 -- Docking Station
        WHEN 27 THEN 10  -- Phone Case
        WHEN 28 THEN 60  -- Wireless Charger
        WHEN 29 THEN 30  -- Stylus Pen
        WHEN 30 THEN 40  -- Laptop Stand
        ELSE 100 -- Default price
    END;

    -- Generate random SaleDate between '2023-01-01' and '2023-12-31'
    DECLARE @SaleDate DATE = DATEADD(DAY, (SELECT FLOOR(RAND() * 365)), '2023-01-01');

    -- Insert the generated sale into the Sales table
    INSERT INTO #Sales (SaleDate, ProductID, EmployeeID, Quantity, Price)
    VALUES (@SaleDate, @ProductID, @EmployeeID, @Quantity, @Price);

    -- Increment the counter
    SET @Counter = @Counter + 1;
END;
Go 

-- Check the inserted sales
SELECT * FROM #Sales s 
join #Employee e on s.EmployeeID = e.EmployeeID
join #Product p on s.ProductID = p.ProductID;

Select ProductID, sum(quantity) from #Sales 
group by rollup (ProductID)

Select ProductID,EmployeeID, sum(quantity) from #Sales 
group by rollup (ProductID, EmployeeID)


Select ProductID,EmployeeID, sum(quantity) from #Sales 
group by grouping sets (ProductID, EmployeeID)
order by EmployeeID, ProductID


create table #temp3(
  ProductID INT, 
  EmployeeID INT, 
  Quantity INT) 
insert into #temp3  
select ProductID, EmployeeID, Quantity
from #Sales

select * 
from #temp3 
pivot(sum(quantity) for EmployeeID in ([1], [2], [3])) as pv
order by ProductID


select * 
from #Employee

create nonclustered index jobTitleIndex 
on #Employee(JobTitle)

select * 
from #Employee 
where JobTitle = 'Sales Manager'

CREATE TABLE StoreData (
    Store INT,
    Week INT,
    xCount INT
);

INSERT INTO StoreData (Store, Week, xCount) VALUES (102, 1, 96);
INSERT INTO StoreData (Store, Week, xCount) VALUES (101, 1, 138);
INSERT INTO StoreData (Store, Week, xCount) VALUES (105, 1, 37);
INSERT INTO StoreData (Store, Week, xCount) VALUES (109, 1, 59);
INSERT INTO StoreData (Store, Week, xCount) VALUES (101, 2, 282);
INSERT INTO StoreData (Store, Week, xCount) VALUES (102, 2, 212);
INSERT INTO StoreData (Store, Week, xCount) VALUES (105, 2, 78);
INSERT INTO StoreData (Store, Week, xCount) VALUES (109, 2, 97);
INSERT INTO StoreData (Store, Week, xCount) VALUES (105, 3, 60);
INSERT INTO StoreData (Store, Week, xCount) VALUES (102, 3, 123);
INSERT INTO StoreData (Store, Week, xCount) VALUES (101, 3, 220);
INSERT INTO StoreData (Store, Week, xCount) VALUES (109, 3, 87);

select * 
from StoreData
pivot(sum(xCount) for Week in ([1], [2], [3])) as pv

-- Create the table
CREATE TABLE SalesData (
    SalesDate DATE,
    CustomerId VARCHAR(10),
    Amount VARCHAR(10)
);
Go
-- Insert the data
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-01', 'Cust-1', '50$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-02', 'Cust-1', '50$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-03', 'Cust-1', '50$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-01', 'Cust-2', '100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-02', 'Cust-2', '100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-01-03', 'Cust-2', '100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-02-01', 'Cust-2', '-100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-02-02', 'Cust-2', '-100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-02-03', 'Cust-2', '-100$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-03-01', 'Cust-3', '1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-04-01', 'Cust-3', '1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-05-01', 'Cust-3', '1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-06-01', 'Cust-3', '1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-07-01', 'Cust-3', '-1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-08-01', 'Cust-3', '-1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-09-01', 'Cust-3', '-1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-10-01', 'Cust-3', '-1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-11-01', 'Cust-3', '-1$');
INSERT INTO SalesData (SalesDate, CustomerId, Amount) VALUES ('2021-12-01', 'Cust-3', '-1$');

select  Convert(varchar,Jan_21) +  '$' AS Jan_21,
		Convert(varchar,Feb_21) +  '$' AS Feb_21,
		Convert(varchar,Mar_21) +  '$' AS Mar_21,
		Convert(varchar,Apr_21) +  '$' AS Apr_21,
		Convert(varchar, (Jan_21 + Feb_21 + Mar_21 + Apr_21)) + '$' as Total
from (
	select CustomerId,
		   ISNULL([Jan-21], 0) AS Jan_21,
		   ISNULL([Feb-21], 0) AS Feb_21,
		   ISNULL([Mar-21], 0) AS Mar_21,
		   ISNULL([Apr-21], 0) AS Apr_21
	from (
		   select CustomerId,
				  format(SalesDate, 'MMM\-yy') as sales_date, 
				  Convert(INT, replace(Amount, '$', '')) as Amount
		   from SalesData
		) t
	pivot(sum(Amount) for sales_date in ([Jan-21], [Feb-21], [Mar-21], [Apr-21])) as pv
union 
select 'Total' as customer,
		   ISNULL([Jan-21], 0) AS Jan_21,
		   ISNULL([Feb-21], 0) AS Feb_21,
		   ISNULL([Mar-21], 0) AS Mar_21,
		   ISNULL([Apr-21], 0) AS Apr_21
	from (
	   select 'Total' as customer,
			  format(SalesDate, 'MMM\-yy') as sales_date, 
			  Convert(INT, substring(Amount, 1, Len(Amount) - 1)) as Amount
	   from SalesData
	) t
pivot(sum(Amount) for sales_date in ([Jan-21], [Feb-21], [Mar-21], [Apr-21])) as pv
) t