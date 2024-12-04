with cte1 as (
  select 
    searches, 
    num_users, 
    sum(num_users) over(
      order by 
        searches
    ) as group_end 
  from 
    search_frequency
), 
cte2 as (
  select 
    sum(num_users) as total_sum
  from 
    search_frequency
) 
select 
  sum(searches) / cast (
    count(1) as float
  ) as median 
from 
  cte1, 
  cte2 
where 
 (total_sum / 2) + 1 >= (group_end - num_users) + 1 and (total_sum / 2) + 1 <= group_end 
 or 
case
when total_sum % 2 = 0 then (total_sum / 2) >= (group_end - num_users) + 1 and
   (total_sum / 2) <= group_end 
  end  