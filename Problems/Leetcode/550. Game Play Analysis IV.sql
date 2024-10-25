/* Write your T-SQL query statement below */

with cte as 
(
   select player_id, min(event_date) as start_date
   from activity 
   group by player_id 
)

select round(cast(count(1) as float) / (select count(1) from cte),2) as fraction
from cte
join activity on activity.player_id = cte.player_id and
                 activity.event_date = dateadd(Day, 1, cte.start_date)