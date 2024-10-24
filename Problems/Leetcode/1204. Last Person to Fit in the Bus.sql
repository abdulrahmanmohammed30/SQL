/* Write your T-SQL query statement below */

with cte as 
(
    select person_name, 1 as turn, weight as acc_weight
    from Queue 
    where turn = 1
    union all 
    select Queue.person_name, Queue.turn, acc_weight + Queue.weight 
    from cte 
    join Queue on Queue.turn = cte.turn + 1
    where acc_weight + Queue.weight <= 1000
)
select top 1 person_name from cte 
order by acc_weight desc