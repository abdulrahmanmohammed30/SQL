/* Write your T-SQL query statement below */

with users as (
    select requester_id as id
    from RequestAccepted 
    union 
    select accepter_id as id
    from RequestAccepted 
)

select top 1 id, count(1) as num
from users join RequestAccepted on requester_id = id or accepter_id = id
group by id 
order by num desc   