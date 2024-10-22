begin transaction 
update products 
set price = 25400.00 
where productID = 1 
WAITFOR DELAY '00:00:08';
rollback

set transaction isolation level repeatable read 
begin transaction 
 declare @quantity INT = (select quantity from products where productid = 1)
 waitfor delay '00:00:05' 
 update products 
 set quantity = @quantity - 1
 where ProductID = 1
commit  


begin try 
   begin tran
   update products set price = 30.00 where productid = 1
   select 'Transaction run to the end'
  commit
end try 
begin catch
 select xact_state()
 rollback 
 select 'could not update the product' 
end catch 
 
set transaction isolation level read uncommitted 
begin transaction 
select * from products where productid = 1 
commit


select * from products(NOLOCK) where productid = 1 

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
		 begin tran
			select @@TRANCOUNT
		 commit
		 select @@TRANCOUNT
	   commit
	   select @@TRANCOUNT
	commit
commit

begin try 
  begin tran
   
   update products set price = 30.00 where productid = 1
   select 'Transaction run to the end'
  commit
end try 
begin catch
 select xact_state()
 rollback 
 select 'could not update the product' 
end catch 
 


select * from products where productid = 1 