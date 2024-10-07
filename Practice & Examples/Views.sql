
use Practice
Go

create view NewYorkSalesPeoople
as 
select * from salesmen 
where city = 'New York' 
Go

select * from NewYorkSalesPeoople


create view SalesPeopole 
as 
select salesman_id , name, city from salesmen
Go


if not exists (select * from sys.tables where name = 'Orders')
 CREATE TABLE Orders (
    ord_no INT,
    purch_amt DECIMAL(10, 2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);
Go 

create view Stats 
as 
select count(distinct customer_id) as Count, avg(purch_amt) as Avg, sum(purch_amt) as Sum
from orders 
group by ord_date
Go


create function GetOrdersByName(@name varchar(50)) 
returns table 
as 
return (
    select ord_no, purch_amt, ord_date, customer_id, salesman_id 
    from orders o
    where customer_id in (select customer_id from customer c where cust_name = @name)
)


create view nameorders 
as 

select * from customer
select * from orders

select * from dbo.GetOrdersByName('Brad Davis')


create function GetCustomersByGrade(@grade int) 
returns @t table 
 (customer_id int, cust_name varchar(50), city varchar(50)) 
as 
begin 
  insert into @t 
  select customer_id, cust_name, city from customer
  where grade = @grade
  return
end 

return (
    select ord_no, purch_amt, ord_date, customer_id, salesman_id 
    from orders o
    where customer_id in (select customer_id from customer c where cust_name = @name)
)

select * from dbo.GetCustomersByGrade(200)



create view elitsalesman 
as 
select ord_date, t.salesman_id, s.name from 
 (
    select ord_date, salesman_id,
    row_number() over (partition by ord_date order by purch_amt desc) as row_number
    from orders
  ) t
join salesmen s
on t.salesman_id = s.salesman_id
where row_number = 1

select * from elitsalesman

create view incentive 
as 
select distinct salesman_id, name
from elitsalesman
group by salesman_id, name
having count(1) >= 3

select * from incentive


create view highgrade 
as 
select top 1 with ties * 
from customer
order by grade desc 

create view citynum 
as 
select city, count(1) as count
from salesmen
group by city 


create view salesmanonoct 
as 
select s.salesman_id, s.name, s.city, s.commission
from orders o
join salesmen s on o.salesman_id = s.salesman_id
where Year(ord_date) = 2012 and Month(ord_date) = 10    

select salesman_id, name , city
from Salesmen
union 
select customer_id , cust_name, city
from Customer

select * from az_employees 
where CHARINDEX('Manager', position) > 0 and department_id in 
(
	select top 1 department_id from 
	(	
		select *, row_number() over(partition by department_id order by id desc) as EmployeesCountPerDepartment
		from az_employees
	)t
	order by EmployeesCountPerDepartment desc
)

-- Step 1: Create the az_employees table
CREATE TABLE az_employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    department_name VARCHAR(100),
    position VARCHAR(100)
);

-- Step 2: Insert 30 employees into the az_employees table
INSERT INTO az_employees (id, first_name, last_name, department_id, department_name, position) VALUES
(1, 'John', 'Doe', 101, 'Sales', 'Sales Manager'),
(2, 'Jane', 'Smith', 101, 'Sales', 'Sales Representative'),
(3, 'Michael', 'Johnson', 102, 'Marketing', 'Marketing Manager'),
(4, 'Emily', 'Davis', 102, 'Marketing', 'Marketing Specialist'),
(5, 'Chris', 'Brown', 103, 'IT', 'Software Engineer'),
(6, 'Sarah', 'Wilson', 103, 'IT', 'Network Administrator'),
(7, 'David', 'Jones', 104, 'Finance', 'Financial Analyst'),
(8, 'Laura', 'Garcia', 104, 'Finance', 'Accountant'),
(9, 'Paul', 'Martinez', 101, 'Sales', 'Sales Representative'),
(10, 'Daniel', 'Hernandez', 105, 'HR', 'HR Manager'),
(11, 'Maria', 'Lopez', 105, 'HR', 'HR Specialist'),
(12, 'James', 'Gonzalez', 103, 'IT', 'Software Engineer'),
(13, 'Linda', 'Clark', 102, 'Marketing', 'Content Writer'),
(14, 'Barbara', 'Rodriguez', 103, 'IT', 'System Administrator'),
(15, 'Robert', 'Lewis', 101, 'Sales', 'Sales Representative'),
(16, 'Susan', 'Lee', 102, 'Marketing', 'Marketing Specialist'),
(17, 'Kevin', 'Walker', 104, 'Finance', 'Accountant'),
(18, 'Jennifer', 'Hall', 104, 'Finance', 'Financial Analyst'),
(19, 'Charles', 'Allen', 105, 'HR', 'Recruiter'),
(20, 'Jessica', 'Young', 105, 'HR', 'HR Specialist'),
(21, 'Brian', 'King', 103, 'IT', 'Software Engineer'),
(22, 'Lisa', 'Wright', 101, 'Sales', 'Sales Manager'),
(23, 'Steven', 'Scott', 103, 'IT', 'Network Administrator'),
(24, 'Patricia', 'Torres', 102, 'Marketing', 'Marketing Manager'),
(25, 'Ronald', 'Nguyen', 104, 'Finance', 'Accountant'),
(26, 'Kenneth', 'Moore', 105, 'HR', 'HR Specialist'),
(27, 'George', 'Taylor', 103, 'IT', 'System Administrator'),
(28, 'Karen', 'Anderson', 101, 'Sales', 'Sales Representative'),
(29, 'Betty', 'Thomas', 102, 'Marketing', 'Content Writer'),
(30, 'Helen', 'Jackson', 105, 'HR', 'Recruiter');

