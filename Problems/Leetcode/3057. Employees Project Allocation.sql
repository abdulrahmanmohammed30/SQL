
with
    cte
    as
    (
        select team, avg(workload) as team_avg_workload
        from Employees e
            join Project p on e.employee_id = p.employee_id
        group by e.team
    )
select e.employee_id, p.project_id, e.name, p.workload
from Employees e
    join cte on cte.team=e.team
    join Project p on e.employee_id = p.employee_id
where p.workload  > cte.team_avg_workload
order by e.employee_id, p.project_id



