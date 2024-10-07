use practice 
create table t1( Id int primary key)

begin try 
 begin transaction
  insert into t1(Id) values (1)
  insert into t1(Id) values (2)
  insert into t1(Id) values (3)
 commit 
end try 
begin catch 
 rollback 
end catch 



select getdate()
select substring('Name', 1,1)
select isnull(PhoneNumber, 0) from Individuals.Persons
select upper('Name')
select lower('Name')
select Len('Name')
select Coalesce(null, null, 'Name')
select top 1 first_value(FirstName) over (order by Len(FirstName) desc) from Individuals.Persons


-- declare function and then provide its body 
create function GetsName (@id int)
returns varchar(20)
begin 
     declare @name varchar(20)
	 select @name=FirstName from Individuals.Persons
	 where ID = @id
	 return @name 
end 

-- you have to provide the function name 
select dbo.GetsName(8)

-- a function that takes class name and returns all students within that class 
-- colum names should be specified 
create function GetStudents(@classID int) 
returns table
as 
return (
	select concat(p.FirstName, ' ', p.LastName) as FullName from Academics.Enrollments e
	join Individuals.Persons p on e.StudentID  = p.ID
	where e.ID = @classID
)

select * from dbo.GetStudents(12)

select * from Academics.classSchedules


create function GetTeacherClassesByWeekday(@teacherID INT,  @weekday INT)
returns table 
as 
return (
	select c.ID, c.SubjectID, s.Name from Academics.Classes c
	join Academics.classSchedules cs on 
	cs.ClassID = c.ID 
	join Academics.Subjects s on c.SubjectID = s.ID
	where c.TeacherID = @teacherID and cs.WeekDay = @weekday
)
select * from dbo.GetTeacherClassesByWeekday(1, 5)


create function GetTeacherNameWithHighestClasses()
returns varchar(50)
Begin
    Declare @TeacherID INT

     select top 1 @TeacherID=TeacherID from 
	(
		select TeacherID,
		row_number() over (partition by TeacherID order by SubjectID) as row_number
		from Academics.Classes 
	) t
    order by row_number desc
	return @TeacherID
End 

select dbo.GetTeacherNameWithHighestClasses()


-- main goal is to fill the variable with data 
create  function GetStudentsWithProvidedFormat(@format varchar(20)) 
returns @t table (
	ID int, 
	Name varchar(20) 
  )
as 
Begin 
    if @format ='first' 
	    insert into @t
		  select ID, FirstName from Individuals.Persons
	else if @format ='last' 
	   insert into @t
	     select ID, LastName from Individuals.Persons 
    else if @format = 'full'
		   insert into @t
		     select ID, concat(FirstName, ' ', LastName) from Individuals.Persons 
	   return 
End 

select * from dbo.GetStudentsWithProvidedFormat('first')

