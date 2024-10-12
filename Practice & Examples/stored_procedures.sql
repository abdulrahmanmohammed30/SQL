
alter proc Sum @x INT, @y INT = 12 
as 
 select @x + @y  -- calling parameter by position 

sum @x=5, @y=3-- calling parameter by name 


use Practice 
GO 

create proc GetCustomersByCity @city varchar(255) 
as 
select * 
from customer 
where city = @city
GO

select * into customer_1 from customer where 1!=1 

-- insert based on execute. You have to write the keyword execute 
insert into customer_1 
execute GetCustomersByCity 'New York'

select * from customer_1



-- stored procedure return is different from function return 
-- you can only return an integer datatype and you cannot return more than vlaue 
-- database developers and applications developers agrees on a set of numbers that 
-- indicate the behaviour of stored procedure such as return 100 means executed successfully 
-- 103 means a primary key error 
create proc GetCustomerGrade @customerId INT 
as 
  declare @grade INT
       select @grade=grade 
       from customer 
       where customer_id = @customerId 
  return @grade

declare @x INT 
Set @x = execute GetCustomerGrade 3001
select @x 


-- similar to call by reference in c# 
create proc GetCustomerGrade @customerId INT, @grade int output 
as 
    select @grade=grade 
    from customer 
    where customer_id = @customerId 

declare @x INT 
execute GetCustomerGrade 3001, @x output
select @x 

--------------------------------------
create proc GetCustomerGrade @customerId INT, @grade int output 
as 
    select @grade=grade 
    from customer 
    where customer_id = @customerId 

declare @x INT 
execute GetCustomerGrade 3001, @x output
select @x 

------------------
-- using the same output parameter for input and output
-- input output parameter 
-- input parameter, output parameter, input-output parameter, return parameter
create proc GetCustomerGrade @customerId INT output, @grade int output 
as 
    select @grade=grade 
    from customer 
    where customer_id = @customerId 

declare @x INT = 3001, @y INT
execute GetCustomerGrade @x output, @y output
select @x, @y


-- the following stored procedure you can create it 
-- for testing purposes for example but must not ever 
-- expose it to the application developer because you are sending 
-- the metadata as parameters so you are nearly sending the same characters 
-- over the network and you are providing the intruders the database metadate 
-- on a silver platter
-- always create stored procedures with encryption 
alter proc GetCustomerNames @col varchar(20), @tab varchar(20)
with encryption 
as 
 execute ('select ' + @col + ' from ' + @tab)

GetCustomerNames 'cust_name', 'customer' how 


exec sp_helptext 'GetCustomerNames'


