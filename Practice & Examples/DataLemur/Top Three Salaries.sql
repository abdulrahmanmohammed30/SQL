with
    ranked_employees
    as
    (
        select name,
            salary,
            department_id
         , dense_rank() over(partition by department_id order by salary desc) as rank
        from employee
    )

select d.department_name, re.name, re.salary
from ranked_employees re

    join department d
    on re.department_id = d.department_id
where rank <= 3
order by d.department_name asc, re.salary desc, re.name asc