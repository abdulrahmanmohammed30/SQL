

declare ProductsCursor cursor fast_forward 
for select * from products for read only

create or alter trigger trg_prevent_Products_deletion 
on Products
WITH ENCRYPTION
instead of delete 
as 
SELECT 'Cannot Delete Products Table Rows'

delete from Products 
where ProductID = 1


exec sp_helptext trg_prevent_Products_deletion


create or alter trigger trg_persons_update 
on Persons 
after update 
as 
if columns_updated() = 1
  PRINT 'Attempts to change columns'


update Persons
set Name='person 60' 
where ID = 5

select * from Persons 

select * from Employee 

