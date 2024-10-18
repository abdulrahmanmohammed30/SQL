
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



declare c3 cursor 
for select FirstName from Employees
for read only

open c3
declare @EmployeeID INT, @FirstName varchar(50),  @PrevFirstName varchar(50), @Count INT=0
fetch c3 into @FirstName	
while @@FETCH_STATUS = 0
BEGIN
   if (@FirstName = 'Amer' and @PrevFirstName = 'Ahmed') 
      SET @Count = @Count + 1

  SET @PrevFirstName = @FirstName
  fetch c3 into @FirstName	
END

Select @Count


use remove3 
GO 

declare c5 cursor 
for select ProjectID, ProjectName from Projects
for read only

declare @ProjectID INT, @ProjectName varchar(50) 

open c5 
fetch c5 into @ProjectID, @ProjectName
while @@FETCH_STATUS = 0 
BEGIN 
  select @ProjectID, @ProjectName
  fetch c5 into @ProjectID, @ProjectName
END 

close c5 
deallocate c5


select * from Persons 

declare pcursor cursor 
for select FullName as Name, Email 
from Persons 
for read only 

declare @Name varchar(255), @Email varchar(255)

open pcursor 

fetch pcursor into @Name, @Email 

while @@FETCH_STATUS = 0
BEGIN 
  select 'Individuals details: Name: '  + @Name + ', Email: ' + @Email 
  fetch pcursor into @Name, @Email 
END 

close pcursor
deallocate pcursor


declare tcursor cursor
for select ID, Specialization, HourlyRate 
from teachers 
for update 

declare @ID INT, @Specialization varchar(50), @HourlyRate decimal(10,2) 

open tcursor 
fetch tcursor into @ID, @Specialization, @HourlyRate 
while @@FETCH_STATUS = 0 
BEGIN  
    Declare @count INT = 
		(
			select count(1) as ct
			from teachers 
			where Specialization = @Specialization and
			HourlyRate > @HourlyRate
		) 
    select @ID, @Specialization, @HourlyRate, @count
 	fetch tcursor into @ID, @Specialization, @HourlyRate 
END 

close tcursor 
deallocate tcursor 

select * from teachers

update teachers 
set Specialization = 'Mathematics', HourlyRate = 200.00
where ID = 6



declare studentCursor cursor 
for select persons.Id, FullName as Name, PhoneNumber, Email from students 
join persons 
on students.Id = persons.Id 
where EnrollmentStatus = 1 
order by createdAt
for read only

declare @Id INT, @Name varchar(50), @PhoneNumber varchar(5), @Email varchar(50), @PrevId INT 

open studentCursor 
fetch studentCursor into @Id, @Name, @PhoneNumber, @Email 
while @@FETCH_STATUS = 0
BEGIN 
 
 select @Id, @Name, @PhoneNumber, @Email, @prevId
 SET @prevId = @Id
 fetch studentCursor into @Id, @Name, @PhoneNumber, @Email 


END 
close studentCursor
deallocate studentCursor


