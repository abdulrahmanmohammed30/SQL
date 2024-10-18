
declare C1 Cursor  
for select EmployeeID, Name from employees
for read only -- update, default for update 
--loop and show rows or lop and edit table 

open c1 
DECLARE @Id INT, @Name nvarchar(50) 
fetch c1 into @Id, @Name 
WHILE @@FETCH_STATUS = 0
BEGIN
	select @Id as 'Id', @Name as 'Name'
	fetch c1 into @Id, @Name 
END 
close c1 
deallocate c1 
