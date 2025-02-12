with cte 
as (
	select player_id,
	       event_date, 
		   lead(event_date, 1) over(partition by player_id order by event_date) as next_date_login,
		   rank() over(partition by player_id order by event_date) as rn
	from Activity 
)

select event_date as install_dt, 
       count(player_id) as installs, 
	   Round(((sum(case when next_date_login is not null and datediff(day, event_date, next_date_login) = 1 then 1 else 0 end)  * 1.00) / count(player_id)),2) as Day1_retention
from cte 
where rn = 1 
group by event_date
