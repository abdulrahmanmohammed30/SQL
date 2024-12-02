-- 8:33 pm max 15 

with
    cte
    as
    (
        select server_utilization .*,
            lead(status_time,1,null) over (partition by server_Id order by status_time) as end_time
        from server_utilization
    )

select sum(extract(day from (end_time - status_time))) + 
        floor(sum(extract(hour from (end_time - status_time))) / 24) as total_uptime_days
from cte
where session_status = 'start'
    and end_time is not null