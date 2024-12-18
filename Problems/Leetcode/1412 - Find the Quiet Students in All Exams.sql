with cte as (
	select student_id, case
			when score = min(score) over (partition by exam_id) or 
				 score = max(score) over (partition by exam_id) 
			then 'nq'
			else 'q' 
	end as state 
	from Exam
)

select cte.student_id, student.student_name 
from cte 
join Student on cte.student_id = student.student_id
group by cte.student_id,student.student_name
having min(state) = 'q'and max(state) = 'q'
