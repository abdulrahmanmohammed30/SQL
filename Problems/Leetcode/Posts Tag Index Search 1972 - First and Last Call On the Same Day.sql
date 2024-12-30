
with users_cte as 
(
	select * 
	from calls  
	union all 
	select recipient_id, caller_id, call_time
	from calls 
)

select * 
from 
(
  select distinct 
  case 
	when 
		 FIRST_VALUE(recipient_id) over(partition by caller_id, cast(call_time as date ) order by call_time asc) =
		 FIRST_VALUE(recipient_id) over(partition by caller_id, cast(call_time as date) order by call_time desc)
	   then caller_id
	end as user_id 
   from  users_cte

)x
where user_id is not null