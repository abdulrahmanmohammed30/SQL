select user_id, 
(
    select round(isnull(cast(count(case when action='confirmed' then 1 end) as float) / nullif(count(*), 0),0), 2)
    from Confirmations
    where Signups.user_id = Confirmations.user_id 
) as confirmation_rate 
from Signups