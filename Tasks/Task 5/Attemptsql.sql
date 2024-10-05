-- 1
select  c.TeacherID as [Teacer Id], concat(p.FirstName,' ', p.LastName) as FullName, 
s.Name as [Subject Name]
from Classes c
join Individuals.Teachers t on c.TeacherID = t.ID
join Individuals.Persons p on t.ID = p.ID
join Academics.Subjects s on c.SubjectID=s.ID
group by c.TeacherID, concat(p.FirstName,' ', p.LastName), s.Name
having count(s.name) > 1

-- 2
select classID, StudentId, p.FullName, Grade, AttendancePercentage, [Max AttendancePercentage], SubjectID, TeacherID from (
 select classID, StudentId, p.FullName as FullName, Grade, AttendancePercentage, [Max AttendancePercentage], SubjectID, TeacherID from (
    select classID, StudentId, Grade, AttendancePercentage,
    max(AttendancePercentage) over (partition by classID order by AttendancePercentage desc) as [Max AttendancePercentage]
    from Academics.Enrollments 
  )t1 
 join Individuals.Persons p on t1.StudentID = p.ID
 join Academics.Classes c on t1.ClassID = c.ID
 where AttendancePercentage= [Max AttendancePercentage]
)t2
join Individuals.Persons p on p.ID = TeacherID
join Academics.Subjects s on s.ID =  SubjectID



-- 3 
select CenterID,  ClassID, [Total Number Of Classes Per Center], [Total Number Of Students Per Class],
avg([Total Number Of Students Per Class]) over (partition by CenterID) as [Average Students Per Class Per Center]
from 
 (
     select c.CenterID, c.ID as ClassID , e.StudentID, 
    count (c.ID) over (partition by c.ID) as [Total Number Of Classes Per Center],
    count(e.StudentID) over (partition by c.ID) as [Total Number Of Students Per Class] 
    from classes c 
    join Academics.enrollments e on c.ID = e.ClassID
    group by c.CenterID, c.ID, e.StudentID
 )t 
group by CenterID,ClassID, [Total Number Of Classes Per Center], [Total Number Of Students Per Class]


