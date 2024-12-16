WITH temp AS (
  SELECT user_id, activity_type,sum(time_spent) as time
  FROM activities 
  where activity_type = 'send' or activity_type='open'
  group by user_id, activity_type
)

select DISTINCT age_bucket,
 case 
     when t.activity_type  > d.activity_type then
        Round((t.time / (t.time + d.time)) * 100.0,2) 
     else 
        Round((d.time / (t.time + d.time)) * 100.0,2)
  end AS send_perc,

  case 
     when t.activity_type  > d.activity_type then
      Round((d.time / (t.time + d.time)) * 100.0,2) 
     else 
      Round((t.time / (t.time + d.time)) * 100.0,2)
  end AS open_perc
from temp t 
join temp d on t.user_id= d.user_id and t.activity_type != d.activity_type
join age_breakdown ab on t.user_id = ab.user_id
order by age_bucket

