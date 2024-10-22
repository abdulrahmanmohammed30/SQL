set transaction isolation level read uncommitted
select * from products 

set transaction isolation level repeatable read 
begin transaction 
 declare @quantity INT = (select quantity from products where productid = 1)
 waitfor delay '00:00:01' 
 update products 
 set quantity = @quantity - 2
 where ProductID = 1
commit  

begin tran
   select @@TRANCOUNT
   begin tran
	 select @@TRANCOUNT
     begin tran
	    select @@TRANCOUNT
	 commit
   commit
commit