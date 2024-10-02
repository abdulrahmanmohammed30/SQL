
-- 2
select s.FirstName, s.LastName as Name, c.CourseName from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	

-- 3
select FirstName, LastName, 
   case GradeLevel
    when 1 then 'First Grade' 
	when 2 then 'Second Grade' 
	when 3 then 'Third Grade' 
	when 4 then 'Forth Grade' 
   end as Grade
from Students


-- 4
select c.CourseName, convert(Decimal(3,2),avg(e.grade)) as [AVerage Grade] from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	
group by CourseName

-- 5
select  concat(s.FirstName,' ', s.LastName) as Name, c.CourseName, grade
, dense_rank() over(partition by CourseName order by grade desc) as Rank 
from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	

-- 6
select c.CourseName, convert(Decimal(3,2),avg(e.grade)) as [AVerage Grade] from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	
group by CourseName
having avg(e.grade) > 3.5

-- 7
select c.CourseName, count(case when grade > 3 then 1 else 0 end) as [Number of Students With High Grade],
count(case when grade < 3 then 1 else 0 end) as [Number of Students With Average Grade]  from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	
group by CourseName

-- 8 
select c.CourseName, count(s.StudentID) as [Number of Students]  from Enrollments e
join Students s on  e.StudentID = s.StudentID
join Courses c on e.CourseID=c.CourseID	
group by CourseName

-- 10
select concat(FirstName,' ', LastName) as Name, Format(EnrollmentDate,  'MMMM dddd yyyy') as [Enrollment Date]
from Students

-- 11 
select concat(s.FirstName, ' ', s.LastName) as Name, grade from 
Enrollments e join Students s on  e.StudentID = s.StudentID
where Exists ( 
  select avg(en.grade) as AvgGrade from Enrollments en
  where en.CourseID=e.CourseID
  group by en.CourseID
  having avg(en.Grade) > 3.5
) 
