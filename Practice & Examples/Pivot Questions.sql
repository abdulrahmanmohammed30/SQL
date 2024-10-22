
--Scenario
--You are tasked with analyzing the monthly sales of different products.
--You have a table that contains sales data with columns for Product, Month, 
--and SalesAmount. You want to pivot the data to show each product’s sales across all months.

--Question
--Create a pivot query that transforms the sales data to show the total sales per product
--for each month. Try solving this using both static and dynamic pivoting techniques.

CREATE TABLE ProductSales (
    Product NVARCHAR(50),
    Month NVARCHAR(10),
    SalesAmount DECIMAL(10, 2)
);
GO

INSERT INTO ProductSales (Product, Month, SalesAmount)
VALUES 
('ProductA', 'January', 500),
('ProductA', 'February', 450),
('ProductA', 'March', 600),
('ProductB', 'January', 800),
('ProductB', 'February', 850),
('ProductB', 'March', 900),
('ProductC', 'January', 300),
('ProductC', 'February', 350),
('ProductC', 'March', 400);

select Product, January, February, March
from ProductSales
pivot (sum(SalesAmount) for Month in (January, February, March))as t


declare @Months varchar(max) = stuff((select distinct ',' + QUOTENAME(Month) from ProductSales for xml path(''), type).value('.', 'NVARCHAR(MAX)'),1,1,'')   

execute ( 'select product, ' + @Months + ' from ProductSales' +  '  pivot (sum(SalesAmount) for Month in ( ' +@Months+ ')) as t')


--Question 2: Sales by Region and Year
--You are analyzing the sales data for a company across different regions and years. The table contains columns for Region, Year, and TotalSales.
--Your goal is to transform the table so that each row represents a region, and the columns represent the sales totals for different years.

CREATE TABLE RegionalSales (
    Region NVARCHAR(50),
    Year INT,
    TotalSales DECIMAL(10, 2)
);
GO
INSERT INTO RegionalSales (Region, Year, TotalSales)
VALUES 
('North', 2021, 1500.50),
('North', 2022, 1600.75),
('South', 2021, 1200.00),
('South', 2022, 1300.80),
('East', 2021, 1400.60),
('East', 2022, 1500.95),
('West', 2021, 1100.40),
('West', 2022, 1150.20);


declare @years varchar(max) =  stuff((select distinct ',' + quotename(Year) from RegionalSales for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')

execute('select Region, ' + @years + ' from RegionalSales pivot(sum(TotalSales) for Year in (' + @years + ')) as t' )


--Question 3: Employee Work Hours by Day
--You have a table that records the hours employees work each day. The table has columns 
--for EmployeeName, WorkDay, and HoursWorked. You want to pivot the table to show each 
--employee's total work hours per day of the week.

CREATE TABLE EmployeeWorkHours (
    EmployeeName NVARCHAR(50),
    WorkDay NVARCHAR(10),
    HoursWorked DECIMAL(5, 2)
);
GO

INSERT INTO EmployeeWorkHours (EmployeeName, WorkDay, HoursWorked)
VALUES 
('Alice', 'Monday', 8.00),
('Alice', 'Tuesday', 7.50),
('Alice', 'Wednesday', 8.00),
('Bob', 'Monday', 7.00),
('Bob', 'Tuesday', 7.00),
('Bob', 'Wednesday', 6.50),
('Charlie', 'Monday', 8.00),
('Charlie', 'Wednesday', 7.50),
('Charlie', 'Thursday', 8.00);

declare @Weekdays varchar(max)= stuff((select distinct ',' + WorkDay from EmployeeWorkHours order by ',' + WorkDay for xml path(''), type).value('.', 'nvarchar(max)'),1,1,'')
execute ('select EmployeeName, ' + @Weekdays + ' from EmployeeWorkHours pivot(sum(HoursWorked) for WorkDay in (' + @Weekdays + ')) as t')

