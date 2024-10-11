create database PracticeMergeStatement; 
Go 
Use PracticeMergeStatement;
Go

-- Create the Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);
Go

-- Create the Employees Table (Target for the merge)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    DateJoined DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
Go
-- Create the NewEmployees Table (Source for the merge)
CREATE TABLE NewEmployees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    DateJoined DATE
);
Go
-- Create the Salaries Table (Used for employee salary history)
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    EffectiveDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
Go

-- Insert data into Departments Table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'Human Resources'),
(2, 'Engineering'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Sales');
Go
-- Insert data into Employees Table (Target)
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, DateJoined)
VALUES
(1, 'John', 'Doe', 2, 5000.00, '2022-01-15'),
(2, 'Jane', 'Smith', 1, 4500.00, '2021-12-10'),
(3, 'Mark', 'Johnson', 3, 6000.00, '2020-07-25'),
-- Insert more rows to reach 30
-- Add random dates and salaries
(30, 'Sara', 'Collins', 4, 6500.00, '2023-09-01');
Go

-- Insert data into NewEmployees Table (Source for Merge)
INSERT INTO NewEmployees (EmployeeID, FirstName, LastName, DepartmentID, Salary, DateJoined)
VALUES
(1, 'John', 'Doe', 2, 5200.00, '2022-01-15'), -- Salary change
(4, 'Emma', 'Williams', 1, 4800.00, '2022-03-19'), -- New employee
(5, 'Lucas', 'Brown', 4, 4700.00, '2022-08-21'),
-- Insert more rows to reach 30
(30, 'Sara', 'Collins', 4, 6700.00, '2023-09-01');

Merge Employees 
Using NewEmployees 
on Employees.EmployeeID = NewEmployees.EmployeeID 

when matched then 
  update set 
          Employees.FirstName = NewEmployees.FirstName,
          Employees.LastName = NewEmployees.LastName,
          Employees.DepartmentID = NewEmployees.DepartmentID,
          Employees.Salary = NewEmployees.Salary

when not matched by target then
   insert (EmployeeID, FirstName, LastName, DepartmentID, Salary, DateJoined)
   values (NewEmployees.EmployeeID, NewEmployees.FirstName, NewEmployees.LastName, NewEmployees.DepartmentID, Salary, DateJoined)

when not matched by source then
delete;



-- Create Customers Table (Target)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(100),
    SubscriptionStatus BIT,
    Address NVARCHAR(255)
);

-- Create NewCustomers Table (Source)
CREATE TABLE NewCustomers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(100),
    SubscriptionStatus BIT,
    Address NVARCHAR(255)
);



-- Insert 30 rows into Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, SubscriptionStatus, Address)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 1, '123 Elm St'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 1, '456 Oak St'),
(3, 'Alice', 'Johnson', 'alice.j@example.com', 0, '789 Pine St'),
(4, 'Bob', 'Brown', 'bob.brown@example.com', 1, '321 Maple St'),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', 0, '654 Cedar St'),
(6, 'Diana', 'Evans', 'diana.evans@example.com', 1, '987 Spruce St'),
(7, 'Frank', 'Foster', 'frank.foster@example.com', 1, '101 Ash St'),
(8, 'Grace', 'Green', 'grace.green@example.com', 0, '202 Birch St'),
(9, 'Henry', 'Harris', 'henry.harris@example.com', 1, '303 Cherry St'),
(10, 'Ivy', 'Ingram', 'ivy.ingram@example.com', 0, '404 Willow St'),
(11, 'Jack', 'Jones', 'jack.jones@example.com', 1, '505 Redwood St'),
(12, 'Karen', 'King', 'karen.king@example.com', 1, '606 Dogwood St'),
(13, 'Liam', 'Lewis', 'liam.lewis@example.com', 0, '707 Fir St'),
(14, 'Mia', 'Martin', 'mia.martin@example.com', 1, '808 Magnolia St'),
(15, 'Nora', 'Nelson', 'nora.nelson@example.com', 1, '909 Palm St'),
(16, 'Oscar', 'Owens', 'oscar.owens@example.com', 0, '111 Peach St'),
(17, 'Paul', 'Parker', 'paul.parker@example.com', 1, '222 Pear St'),
(18, 'Quinn', 'Quincy', 'quinn.quincy@example.com', 0, '333 Plum St'),
(19, 'Rachel', 'Roberts', 'rachel.roberts@example.com', 1, '444 Poplar St'),
(20, 'Sam', 'Stevens', 'sam.stevens@example.com', 1, '555 Sycamore St'),
(21, 'Tina', 'Taylor', 'tina.taylor@example.com', 1, '666 Beech St'),
(22, 'Ursula', 'Underwood', 'ursula.u@example.com', 0, '777 Cypress St'),
(23, 'Victor', 'Vance', 'victor.vance@example.com', 1, '888 Hemlock St'),
(24, 'Wendy', 'White', 'wendy.white@example.com', 0, '999 Maple St'),
(25, 'Xander', 'Xavier', 'xander.xavier@example.com', 1, '1010 Alder St'),
(26, 'Yara', 'Young', 'yara.young@example.com', 1, '1111 Cherry St'),
(27, 'Zane', 'Zimmerman', 'zane.z@example.com', 0, '1212 Walnut St'),
(28, 'Andy', 'Adams', 'andy.adams@example.com', 1, '1313 Willow St'),
(29, 'Betty', 'Barnes', 'betty.b@example.com', 0, '1414 Oak St'),
(30, 'Carl', 'Carter', 'carl.c@example.com', 1, '1515 Pine St');


-- Insert 30 rows into NewCustomers table (with some updates and new customers)
INSERT INTO NewCustomers (CustomerID, FirstName, LastName, Email, SubscriptionStatus, Address)
VALUES
(1, 'John', 'Doe', 'john.newemail@example.com', 1, '123 Elm St'), -- Email changed
(2, 'Jane', 'Smith', 'jane.smith@example.com', 0, '456 Oak St'), -- Unsubscribed
(3, 'Alice', 'Johnson', 'alice.j@example.com', 0, '789 Pine St'),
(4, 'Bob', 'Brown', 'bob.b@example.com', 1, '321 Maple St'), -- Email changed
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', 0, '654 Cedar St'),
(6, 'David', 'Ellis', 'david.ellis@example.com', 1, '1601 Palm St'), -- New customer
(7, 'Fiona', 'Gray', 'fiona.gray@example.com', 1, '1721 Elm St'), -- New customer
(8, 'George', 'Hill', 'george.h@example.com', 1, '1899 Oak St'), -- New customer
(9, 'Holly', 'Ivers', 'holly.i@example.com', 0, '1344 Maple St'), -- New customer
(10, 'Isaac', 'Johnson', 'isaac.j@example.com', 1, '1502 Cedar St'), -- New customer
(11, 'Jenny', 'Kane', 'jenny.kane@example.com', 1, '1433 Spruce St'), -- New customer
(12, 'Kyle', 'Lewis', 'kyle.l@example.com', 0, '2222 Elm St'), -- New customer
(13, 'Laura', 'Martin', 'laura.m@example.com', 1, '3332 Pine St'), -- New customer
(14, 'Michael', 'Nolan', 'michael.nolan@example.com', 1, '3435 Cedar St'), -- New customer
(15, 'Nina', 'Owens', 'nina.owens@example.com', 0, '4545 Spruce St'), -- New customer
(16, 'Oliver', 'Perez', 'oliver.p@example.com', 1, '1016 Dogwood St'), -- New customer
(17, 'Penny', 'Quinn', 'penny.q@example.com', 1, '1175 Cedar St'), -- New customer
(18, 'Ron', 'Stewart', 'ron.stewart@example.com', 0, '2284 Oak St'), -- New customer
(19, 'Sophie', 'Taylor', 'sophie.t@example.com', 1, '3153 Palm St'), -- New customer
(20, 'Thomas', 'Underwood', 'thomas.u@example.com', 1, '4075 Fir St'), -- New customer
(21, 'Uma', 'Vega', 'uma.v@example.com', 0, '5078 Elm St'), -- New customer
(22, 'Vera', 'Wright', 'vera.wright@example.com', 1, '6657 Beech St'), -- New customer
(23, 'William', 'Xavier', 'william.xavier@example.com', 0, '7877 Birch St'), -- New customer
(24, 'Yasmin', 'Young', 'yasmin.young@example.com', 1, '8954 Cherry St'), -- New customer
(25, 'Zach', 'Zimmer', 'zach.zimmer@example.com', 1, '9771 Ash St'), -- New customer
(26, 'Andy', 'Adams', 'andy.new@example.com', 1, '1313 Willow St'), -- Updated customer
(27, 'Betty', 'Barnes', 'betty.barnes@example.com', 1, '1414 Oak St'), -- Updated customer
(28, 'Carl', 'Carter', 'carl.c.new@example.com', 1, '1515 Pine St'), -- Email changed
(29, 'Danny', 'Evans', 'danny.evans@example.com', 1, '1621 Palm St'), -- New customer
(30, 'Emma', 'Fletcher', 'emma.f@example.com', 0, '1745 Maple St'); -- New customer


merge Customers 
using NewCustomers 
on Customers.CustomerID = NewCustomers.CustomerID

when matched then
update set 
   Customers.Email= NewCustomers.Email,
   Customers.SubscriptionStatus= NewCustomers.SubscriptionStatus

when not matched by target then
insert (CustomerID, FirstName, LastName, Email, SubscriptionStatus, Address)
values(NewCustomers.CustomerID, NewCustomers.FirstName, NewCustomers.LastName, NewCustomers.Email, NewCustomers.SubscriptionStatus, NewCustomers.Address);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(50),
    TotalAmount DECIMAL(10, 2),
    ShippingAddress VARCHAR(255)
);
Go

CREATE TABLE NewOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(50),
    TotalAmount DECIMAL(10, 2),
    ShippingAddress VARCHAR(255)
);
Go




-- Insert 30 rows into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, ShippingAddress)
VALUES
(1, 101, '2024-01-15', 'Shipped', 150.00, '123 Elm St'),
(2, 102, '2024-01-16', 'Processing', 250.00, '456 Oak St'),
(3, 103, '2024-01-17', 'Delivered', 175.50, '789 Pine St'),
(4, 104, '2024-01-18', 'Cancelled', 0.00, '321 Maple St'),
(5, 105, '2024-01-19', 'Processing', 99.99, '654 Cedar St'),
(6, 106, '2024-01-20', 'Delivered', 299.99, '987 Spruce St'),
(7, 107, '2024-01-21', 'Shipped', 500.00, '101 Ash St'),
(8, 108, '2024-01-22', 'Delivered', 450.50, '202 Birch St'),
(9, 109, '2024-01-23', 'Processing', 700.00, '303 Cherry St'),
(10, 110, '2024-01-24', 'Shipped', 325.25, '404 Willow St'),
(11, 111, '2024-01-25', 'Delivered', 600.00, '505 Redwood St'),
(12, 112, '2024-01-26', 'Processing', 850.00, '606 Dogwood St'),
(13, 113, '2024-01-27', 'Cancelled', 0.00, '707 Fir St'),
(14, 114, '2024-01-28', 'Shipped', 125.00, '808 Magnolia St'),
(15, 115, '2024-01-29', 'Delivered', 175.75, '909 Palm St'),
(16, 116, '2024-01-30', 'Processing', 450.00, '111 Peach St'),
(17, 117, '2024-01-31', 'Shipped', 650.00, '222 Pear St'),
(18, 118, '2024-02-01', 'Delivered', 300.00, '333 Plum St'),
(19, 119, '2024-02-02', 'Cancelled', 0.00, '444 Poplar St'),
(20, 120, '2024-02-03', 'Shipped', 99.99, '555 Sycamore St'),
(21, 121, '2024-02-04', 'Delivered', 220.00, '666 Beech St'),
(22, 122, '2024-02-05', 'Processing', 400.50, '777 Cypress St'),
(23, 123, '2024-02-06', 'Shipped', 330.00, '888 Hemlock St'),
(24, 124, '2024-02-07', 'Delivered', 610.00, '999 Maple St'),
(25, 125, '2024-02-08', 'Cancelled', 0.00, '1010 Alder St'),
(26, 126, '2024-02-09', 'Shipped', 500.75, '1111 Cherry St'),
(27, 127, '2024-02-10', 'Delivered', 750.00, '1212 Walnut St'),
(28, 128, '2024-02-11', 'Processing', 340.00, '1313 Willow St'),
(29, 129, '2024-02-12', 'Delivered', 850.50, '1414 Oak St'),
(30, 130, '2024-02-13', 'Shipped', 420.25, '1515 Pine St');
GO

-- Insert 30 rows into NewOrders table
INSERT INTO NewOrders (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, ShippingAddress)
VALUES
(1, 101, '2024-01-15', 'Shipped', 160.00, '123 Elm St'), -- Updated total amount
(2, 102, '2024-01-16', 'Completed', 250.00, '456 Oak St'), -- Updated order status
(3, 103, '2024-01-17', 'Delivered', 175.50, '789 Pine St'),
(4, 104, '2024-01-18', 'Cancelled', 0.00, '321 Maple St'),
(5, 105, '2024-01-19', 'Completed', 99.99, '654 Cedar St'), -- Updated order status
(6, 106, '2024-01-20', 'Delivered', 299.99, '987 Spruce St'),
(31, 201, '2024-02-15', 'Processing', 540.75, '220 Oak St'), -- New order
(32, 202, '2024-02-16', 'Shipped', 320.50, '330 Cedar St'), -- New order
(33, 203, '2024-02-17', 'Processing', 425.75, '440 Maple St'), -- New order
(34, 204, '2024-02-18', 'Delivered', 499.99, '550 Birch St'), -- New order
(35, 205, '2024-02-19', 'Processing', 150.00, '660 Oak St'), -- New order
(36, 206, '2024-02-20', 'Shipped', 99.99, '770 Pine St'), -- New order
(37, 207, '2024-02-21', 'Delivered', 175.50, '880 Cedar St'), -- New order
(38, 208, '2024-02-22', 'Processing', 275.00, '990 Oak St'), -- New order
(39, 209, '2024-02-23', 'Shipped', 450.25, '1100 Pine St'), -- New order
(40, 210, '2024-02-24', 'Processing', 200.00, '1200 Cedar St'), -- New order
(41, 211, '2024-02-25', 'Shipped', 225.00, '1300 Maple St'), -- New order
(42, 212, '2024-02-26', 'Delivered', 600.00, '1400 Pine St'), -- New order
(43, 213, '2024-02-27', 'Processing', 520.00, '1500 Oak St'), -- New order
(44, 214, '2024-02-28', 'Shipped', 710.50, '1600 Cedar St'), -- New order
(45, 215, '2024-02-29', 'Processing', 440.00, '1700 Maple St'), -- New order
(46, 216, '2024-03-01', 'Delivered', 990.75, '1800 Oak St'), -- New order
(47, 217, '2024-03-02', 'Processing', 330.00, '1900 Cedar St'), -- New order
(48, 218, '2024-03-03', 'Shipped', 410.25, '2000 Maple St'), -- New order
(49, 219, '2024-03-04', 'Processing', 700.50, '2100 Oak St'), -- New order
(50, 220, '2024-03-05', 'Delivered', 240.75, '2200 Pine St'); -- New order
GO

merge Orders Target 
using NewOrders Source
on Target.OrderID= Source.OrderID

when matched then
update set 
        Target.OrderDate = Source.OrderDate,
        Target.OrderStatus = Source.OrderStatus,
        Target.TotalAmount = Source.TotalAmount,
        Target.ShippingAddress = Source.ShippingAddress
when not matched by target then 
    INSERT (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, ShippingAddress)
    VALUES (Source.OrderID, Source.CustomerID, Source.OrderDate, Source.OrderStatus, Source.TotalAmount, Source.ShippingAddress);

create table cats (
	name varchar(50), 
	weight INT
)
Go

Declare @total INT
select @total = count(*) from cats 

select 
count(*) over(order by weight rows between unbounded preceding and current row) - 1 / @total
from cats


create function NormalizeTrackName(@trackName varchar(50)) 
returns varchar(20)
Begin
   declare @res varchar(50) = trim(replace(@trackname, '"', ''))
   return @res
End 

select dbo.NormalizeTrackName('"_Human"')

-- Create the table
CREATE TABLE sales (
    id INT PRIMARY KEY,
    user_id INT,
    item VARCHAR(50),
    created_at DATE,
    revenue INT
);

-- Insert the sample data
INSERT INTO sales (id, user_id, item, created_at, revenue) VALUES
(1, 109, 'milk', '2020-03-03', 123),
(2, 139, 'biscuit', '2020-03-18', 421),
(3, 120, 'milk', '2020-03-18', 176),
(4, 108, 'banana', '2020-03-18', 862),
(5, 130, 'milk', '2020-03-28', 333);


select *, 
datediff(Day, 
    lag(created_at, 1 ) over(partition by user_id order by created_at), created_at)
from sales

 
create database remove0 
Go
use  remove0
 CREATE TABLE UserActions (
    user_id INT,
    timestamp DATETIME,
    action VARCHAR(50)
);
INSERT INTO UserActions (user_id, timestamp, action)
VALUES 
(0, '2019-04-25 13:30:15', 'page_load'),
(0, '2019-04-25 13:30:18', 'page_load'),
(0, '2019-04-25 13:30:40', 'scroll_down'),
(0, '2019-04-25 13:30:45', 'page_exit'),
(0, '2019-04-25 13:31:10', 'scroll_exit');

exec sp_rename UserActions, facebook_web_log

select user_id, avg(session_time) as avg_session_time from (
select user_id,  format(timestamp, 'dd-MM-yyyy') as SessionDay, 
(
  select session_time from (
   	SELECT top 1 a1.user_id AS user_id
		,format(a1.TIMESTAMP, 'dd-MM-yyyy') AS SessionDay
		,CASE 
			WHEN a1.action > a2.action
				THEN datediff(Second, a1.TIMESTAMP, a2.TIMESTAMP)
			ELSE datediff(Second, a2.TIMESTAMP, a1.TIMESTAMP)
			END AS session_time
	FROM facebook_web_log a1
	JOIN facebook_web_log a2 ON a1.user_id = a2.user_id
		AND format(a1.TIMESTAMP, 'dd-MM-yyyy') = format(a2.TIMESTAMP, 'dd-MM-yyyy')
		and facebook_web_log.user_id = a1.user_id and format(facebook_web_log.TIMESTAMP, 'dd-MM-yyyy') = format(a1.TIMESTAMP, 'dd-MM-yyyy')
		AND a1.action IS NOT NULL
		AND a2.action IS NOT NULL
		AND (
			a1.action = 'page_load'
			OR a1.action = 'page_exit'
			)
		AND (
			a2.action = 'page_load'
			OR a2.action = 'page_exit'
			)
		AND a1.action <> a2.action
	ORDER BY CASE 
			WHEN a1.action > a2.action
				THEN a1.action
			ELSE a2.action
			END DESC
		,CASE 
			WHEN a1.action > a2.action
				THEN a2.action
			ELSE a1.action
			END
		) t 
) as session_time
from facebook_web_log
group by user_id,  format(timestamp, 'dd-MM-yyyy')
)t
group by user_id
