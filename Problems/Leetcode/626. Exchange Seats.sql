
select s1.id, s2.student
from Seat s1
join Seat s2 on s1.id % 2 != 0 and s2.id = s1.id + 1
union 
select s2.id, s1.student  
from Seat s1
join Seat s2 on s2.id % 2 = 0 and s1.id = s2.id - 1
union 
select max_id as id, student 
from (
    select max(id) as max_id, count(id) as count_id
    from Seat 
)x 
join Seat on max_id = id
where count_id % 2 !=0  


----------------------------
--optimized solution 
declare @n int = (select count(id) from seat)

select  
case 
  when id % 2 = 0 then id - 1
  when id % 2 != 0 and id != @n then id + 1
  else id
end as id, student
from seat 
order by id
