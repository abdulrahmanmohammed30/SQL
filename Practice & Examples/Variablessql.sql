
use PrivateTutoring
Declare @Name varchar(50) 
select @Name = FirstName from Individuals.Persons

select @Name

Declare @number varchar(11)

-- Notice the usage of Set 
-- It updates the FirstName column within the table and at 
-- the same time it assigns a value to the phoneNumber 
-- update the variable with the value returned from PhoneNumber 
-- is there any value returned from PhoneNumber? 
-- Yes, because it 's at specific row so of course there is a returned value 
-- select within update 
update Individuals.Persons 
set FirstName = 'fearless', @number=PhoneNumber
where ID= 9 
select @number 


Declare @x INT 
Select @@servername
Select @@rowcount
Select @@version 
Select @@error 
Select @@identity 
select @x=@@rowcount 
-- select @@roundcount = @x -- won't run, you cannot assign a value to globlal variable 


select @x

declare @t INT =50 
select @t 

declare @res INT= (select max(HourlyRate) from Individuals.Teachers)
select @res = HourlyRate from Individuals.Teachers
select @res 

-- cases 
-- the where returned more no value, the variable reserver the last value it had 
select @res 
select @res = HourlyRate from Individuals.Teachers where ID= 5000000
select @res 

-- the where returned more than one value, it takes the last value in the array
Declare @res INT 
select @res 
select @res= HourlyRate from Individuals.Teachers where Specialization='Mathematics'
select @res 


-- The following query won't run because you are using the query for assingment and display  
-- select @res= HourlyRate, HourlyRate from Individuals.Teachers where Specialization='Mathematics'

-- saving time instead of going twice to the hard desk, we did it in one go 
-- so update and select in one go 
Declare @Specialization varchar(50)
update Individuals.Teachers
set HourlyRate = 190.00, @Specialization=Specialization
where ID = 3
select @Specialization

-- create table in memory and use it 
declare @t table (x int)
insert into @t
select HourlyRate from Individuals.Teachers where Specialization='Mathematics'
select count(*) from @t

declare @x INT= 5 
select top(@x) * from Individuals.Teachers

declare @col varchar(20)
declare @tab varchar(20) 
DECLARE @sql NVARCHAR(MAX);

set @tab ='Teachers'
set @col='HourlyRate'

-- execute convert provided string to query and then run it, dynamic query 
execute ('SELECT ' + @col + ' FROM ' + @tab)

SET @sql = 'SELECT ' + QUOTENAME(@col) + ' FROM ' + QUOTENAME(@tab);

EXEC sp_executesql @sql;


---------- 
-- Global Variables 
-- RowCount -> Return number of rows affected by the last query you run 
select * from Individuals.Teachers 
select @@Rowcount

select @@error

select @@identity

