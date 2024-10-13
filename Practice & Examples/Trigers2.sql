
create table History (
  _User varchar(50),
  _Date date, 
  _OldID int, 
  _NewID int
)
GO

alter trigger t2
on Orders 
instead of update 
as 
if (update(ord_no))
	BEGIN 
	    DECLARE @DeletedIdsWithRowNumber TABLE (RowNumber INT Identity(1,1) Primary key, Id INT)
        INSERT INTO @DeletedIdsWithRowNumber(Id) 
        SELECT ord_no AS Id FROM deleted 
 
        DECLARE @InsertedIdsWithRowNumber TABLE (RowNumber INT Identity(1,1) Primary key, Id INT)
        INSERT INTO @InsertedIdsWithRowNumber(Id) 
        SELECT ord_no AS Id FROM inserted 

	    insert into history(_User, _Date,  _OldID, _NewID)
		select suser_name(),
		getdate(),
		d.Id as _OldID,
		i.Id as _NewID
		from 
		@DeletedIdsWithRowNumber d join @InsertedIdsWithRowNumber i
		on d.RowNumber = i.RowNumber
	END
else 
	BEGIN 
	   merge orders 
	   using inserted 
	   on orders.ord_no = inserted.ord_no 
	   when matched then 
	   update 
	   set orders.purch_amt=inserted.purch_amt, 
		   orders.ord_date=inserted.ord_date,
		   orders.customer_id=inserted.customer_id,
		   orders.salesman_id=inserted.salesman_id;
	END
GO
truncate table history
select * from Orders 

update Orders 
set ord_no = 15
where ord_no = 70001
select * from history

create trigger t12 
on orders 
instead of update 
as if update(ord_no) 
	BEGIN
		declare @new int, @old int 
		select @old=ord_no from deleted 
	    select @new=ord_no from deleted 
		insert into history values(suser_name(), getdate(), @old, @new)
	END

------------------------------------------
-- OUTPUT: Runtime Trigger          
delete from customer 
output getdate(), deleted.customer_id
where customer_id = 3003 

update customer 
set cust_name='Jack 30' 
OUTPUT deleted.cust_name
where customer_id = 600 




