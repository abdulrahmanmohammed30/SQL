/* Write your T-SQL query statement below */

select id,
case 
   when p_id is null then 'Root'
   when p_id is not null and exists(select top 1 1 from tree where p_id = t.id) then 'Inner'
   else 'Leaf' 
end as type  
from tree t