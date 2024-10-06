
-- control of flow statement 
-- if 
-- begin 
-- end 
-- if exists if not exists 
-- while 
-- continue 
-- break 
-- case 
-- if 
-- waitfor 
-- choose 

use PrivateTutoring;

update Individuals.Persons 
set FirstName = 'fearless'
where ID= 9 
Declare @x int = @@RowCount 

if @x > 0 
 begin 
    select 'Multi rows affected'
 end
else 
 begin
   select 'No rows affected'
 end


 if 'Persons' not in (select name from sys.tables)  
 create table Persons (
	ID INT Identity(1,1) Primary key,
	Name varchar(50)
)

if not exists(select * from sys.tables where name='Persons')
 create table Individuals.Persons (
	ID INT Identity(1,1) Primary key,
	Name varchar(50)
)


begin try
 delete from Academics.Classes 
 where ID = 3 
end try 
begin catch
  select @@error
  select ERROR_LINE(), ERROR_Number(), Error_Message()
end catch 


declare @x INT = 10 
while @x<= 20
begin	
  Set @x +=1 
  if @x = 14 
   continue
  if @x = 16
     break 
  select @x
end 

