create nonclustered index cityIndex 
on customer(city)

select * from customer where city = 'New York'

-- PK    --Constraint   ----> Clustered Index 
--Unique --Constraint   ---> non-clustered index 
create unique index index3 
on customer(cust_name) 

-- SQL server profillier 
-- SQL Server Tuning Advisor 


create table #NewStarts (
   ID INT Primary Key, 
   CreatedAt Date not null  
)
