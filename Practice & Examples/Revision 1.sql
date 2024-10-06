
-- Aggregate Functions and null values 
use practice; 

create table ages (
ID INT Identity(1,1) primary key,
Age INT null 
); 

insert into Ages(Age) values (30), (22), (36), (25), (45), (48), (null), (52), (31), (null)

select distinct Age from Ages 

select avg(Age) as Age from Ages 

having max(Age) > 60
select  Ntile(4) over(order by Age) from Ages as [Group Number]

select avg(Age) as NotAccurateAge, avg(isnull(Age,0)) as AccurateAge from Ages 

sp_bindrule r1, 'Ages.Age'
insert into Ages(Age) values (3)

sp_unbindrule 'Ages.Age' 


Declare @startTime Time = '12:30'
select @startTime

Declare @newDate Smalldatetime = getdate()
select @newDate

Declare @NewAge varchar(12)= '32'
select Convert(INT, @NEWAGE)

create table employee (
 ID INT Identity(1,1) primary key, 
 FirstName varchar(50) not null, 
 LastName varchar(50) Sparse null, 
 PhoneNumber char(11) Sparse null
)



use PrivateTutoring
select TeacherID, SubjectID, StartDate, EndDate, MaxStudents, CreatedAt, StartTime, EndTime, 
case Weekday 
when 1 then 'MON' 
when 2 then 'TUE' 
when 3 then 'WED'
when 4 then 'THU'
when 5 then 'FRI' 
when 6 then 'SAT'
when 7 then 'SUN'
end as Weekday
from classes c
join Academics.ClassSchedules cs on cs.ClassID = c.ID


select Locations.Centers.ID as CenterID, Centers.Name, classes.ID as ClassID,count(e.StudentID) 
as [Number of Students Per Classs Per Center]
from classes 
join Locations.centers on classes.CenterID = centers.ID
join Academics.Enrollments e on e.classID = classes.ID  
group by Locations.Centers.ID ,Centers.Name, classes.ID	

alter schema Academics transfer dbo.Feedbacks


