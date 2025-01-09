
-- spent 1 
with cte as 
(
  select es1.id, es1.month, sum(es1.salary + coalesce(es2.salary,0) + coalesce(es3.salary,0)) as salary
  from EmployeeSalary es1 
  left join EmployeeSalary es2 on es1.id = es2.id and es1.month - 1 = es2.month
  left join EmployeeSalary es3 on es1.id = es3.id and es1.month - 2 = es3.month 
  group by es1.id, es1.month 
)


select id, month, salary 
from 
(
	select *, max (month) over (partition by id) as most_recent_month
	from cte 
)x 
where month != most_recent_month
order by id, month desc
