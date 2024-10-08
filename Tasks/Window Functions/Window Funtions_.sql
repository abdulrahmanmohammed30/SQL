 -- 11 SQL Window Functions Exercises with Solutions
 -- https://learnsql.com/blog/sql-window-functions-practice-exercises/

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
	result.place,
    athlete.first_name, 
	athlete.last_name, 
	max(result) over (order by result desc) - result as comparison_to_best,
	result - lead(result, 1, 0) over(order by result desc) as comparison_to_previous 
from result 
join athlete 
   on athlete.id= result.athlete_id
join race 
   on race.id = result.race_id
join round 
   on race.round_id = round.id
join event 
   on round.event_id = event.id
join discipline 
   on event.discipline_id = discipline.id
join competition 
   on event.competition_id = competition_id
where 
      race.is_final = 1 
      and competition.name = 'World Relays' 
	  and discipline.name = '100m Women'
ORDER BY place;

select * from round 
select * from race 
select * from event
select * from competition

-- 10
select 
   day, 
   users, 
   lead(users, 7, -1) over(order by day)
from statistics1 
where website_id = 2
  AND day BETWEEN '2016-05-01' AND '2016-05-14';

-- 11 
  select 
   day, 
   revenue, 
   lag(revenue , 3,  -1.00) over(order by day)
from statistics1 
where website_id = 3

