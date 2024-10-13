select * from Orders 
GO

create trigger t2 
on Orders 
instead of delete 
as
  PRINT 'Customer was added successfully'
GO

--after = for 
-- trigger takes schema name automatically 
create trigger dbo.t1 
on customer 
for update 
 as PRINT 'Customer was added successfully'
GO


insert into customer values (5580, 'Jack39', 'New York', 300, 5001)

select * from orders 
delete from Orders where ord_no = 5005

create trigger t4
on salesmen 
after update 
as 
print 'updated salesman successfully' 

-- trigger will fire regardless if any rows were affected or not
-- even if the salesmen table was empty, the trigger will fire 
update salesmen 
set commission = 0.16
where commission = 0.15
select * from salesmen


create trigger t7 
on customer 
after update  -- -> update query 
as if 
	update(grade) -- -> update function, check if a column is a part of the update statement 
	    PRINT 'Grade was updated'

select * from customer 

update customer 
set city = 'London'
where customer_id = 600


-- Trigger gets fired regardless of whether you affected any rows or not 
-- Takes the same schema name it was created on 
-- update can be treated as a function to let us know if a particular column of 
-- part of the update or not 

create trigger t8 
on customer 
instead of insert, update, delete 
as 
PRINT 'Customer is readonly'

-- we can enable and disable the trigger 

-- disable the trigger 
alter table customer disable trigger t8 
alter table customer enable trigger t8 

-- why did we write the schema names in the previous two commands? 
-- because the default schema is dbo 

-- triggers used for auditing 
create trigger t9 
on Orders 
after update
as 
select * from inserted 
select * from deleted 

select * from Orders 
update Orders 
set purch_amt = 6000 
where purch_amt = 110.50

select * from Orders 
delete from Orders where ord_no = 70005
create trigger t11 
on Orders
instead of delete 
as 
if format(cast(getdate() as date), 'ddd') != 'Sun'
 delete from orders
 where exists (select 1 from deleted where orders.ord_no = deleted.ord_no)
else 
 PRINT 'Failed to delete'


create trigger t12 
on Orders 
after delete 
as 
 if format(cast(getdate() as date), 'ddd') != 'Sun'
 BEGIN
  PRINT 'not deleted'
  -- rollback
  insert into Orders 
  select * from deleted
 END 

 select * from ages 
 