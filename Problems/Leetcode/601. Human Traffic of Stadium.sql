/* Write your T-SQL query statement below */


with filtered_Stadium as 
(
    select * from Stadium where people >= 100 
)

select distinct s1.id, s1.visit_date, s1.people 
from filtered_Stadium s1, filtered_Stadium s2, filtered_Stadium s3
where 
   case
      when s1.id = s2.id - 1 and s2.id = s3.id - 1 then 1 
      when s1.id = s2.id - 1 and s1.id = s3.id + 1 then 1
      when s1.id = s2.id + 1 and s2.id = s3.id + 1 then 1
      else 0 
   end = 1

