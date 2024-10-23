
set xact_abort on
begin try 
   begin tran
   select 5 / 0
   update products set price = 30.00 where productid = 1
   select 'Transaction run to the end'
  commit
end try 
begin catch
 throw 
 if xact_state() = 0
   BEGIN 
   select 'nothing to commit'
   return
   END
 if xact_state() = -1
    Begin 
	select 'could not update the product'
	rollback
	End
 else if xact_state() = 1
 Begin 
      select 'product was updated'
	  commit 
 End 
end catch 

select xact_state()