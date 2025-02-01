--7:16 am to 8:09 am 
-- thinking for a while then writing code then closing the editor thinking then writing code
-- This problem needed some sort of incremental thinking 

with
    studentMajorCourses
    as
    (
        select s.student_id,
            c.course_id,
            c.major,
            c.mandatory
        from students s
            join courses c on s.major = c.major
    ),
    cte
    as
    (
        select smc.student_id
        from studentMajorCourses smc
            left join enrollments e on smc.student_id = e.student_id and
                smc.course_id = e.course_id
        group by smc.student_id
        having sum(case when smc.mandatory = 'Yes'and (grade is null or grade <> 'A') then -1 else 0 end) = 0 and
            sum(case when smc.mandatory = 'No' and e.semester is not null then 1 else 0 end) >= 2 and
            sum(case when smc.mandatory = 'No' and (grade is not null and grade <> 'A' and grade <> 'B') then -1 else 0 end) = 0
    )
select e.student_id
from enrollments e
    join cte c on e.student_id = c.student_id
group by e.student_id
having Avg(GPA) * 1.0 >= 2.5
order by e.student_id

