 
 -- 1
select 
  rental_date,
  title, 
  genre, 
  payment_amount,
  rank() over (partition by genre order by payment_amount desc) as rank
from single_rental sr 
join movie m on sr.movie_id = m.id

-- 2 
select first_name,
      last_name,
	  payment_date from 
(
  select  payment_date,
		  customer_id,
         row_number() over(order by payment_date desc) as rank from giftcard
)t
join customer c on t.customer_id = c.id
where rank = 2 


-- 3
select id, 
      rental_date,
	  payment_amount, 
	  sum(payment_amount) over(order by rental_date rows between unbounded PRECEDING and current row )
	  as running_total
from single_rental


--4 
select 
    procedure_date,
	doctor_id, 
	category, 
	name,
	score,
	sum(score) over(partition by category order by procedure_date rows between 2 preceding and 3 following) 
from procedure3
join doctor on doctor.id = procedure3.doctor_id

select id, procedure_date, name, price,
lag(price) over(order by id) as previous_price,  (price -  lag(price) over(order by id)) as difference
from procedure3



create function GetBestCategoryProcedurePrice(@category varchar(50))
returns INT 
Begin 
  declare @price INT 
   select top 1 @price=price 
   from procedure3
   where category = @category
   order by score desc
  return @price
End 

-- 6
-- naive solution 
select 
 procedure_date,
 name,
 price,
 category,
 score, 
  FIRST_VALUE(price) over(partition by category order by score desc) as best_procedurce,
   FIRST_VALUE(price) over(partition by category order by score desc) - price as difference 
from procedure3


-- 7
select name, first_name, last_name from 
(
  select 
       name,
       first_name, 
       last_name,
	   score, 
       avg(score) over(partition by name) as AvgPerProcedure
  from procedure3
  join doctor on procedure3.doctor_id = doctor.id
)t
where score >= AvgPerProcedure


-- 8
SELECT 
   race_date, 
   Round(AVG(wind), 3) AS avg_wind,
   Round(AVG(wind) - LAG(AVG(wind)) OVER(ORDER BY race_date), 3)
FROM RACE
GROUP BY race_date;


-- 9 
select 
    first_name, 
	last_name,
	place 
from result 
join athlete on athlete.id= result.athlete_id
join race on race.id = result.race_id
