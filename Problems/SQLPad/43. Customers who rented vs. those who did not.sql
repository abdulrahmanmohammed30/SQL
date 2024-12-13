
with cte as 
(
	select  count(distinct filtered_rental.customer_id) as rented,
               count(distinct customer.customer_id) - count(distinct filtered_rental.customer_id) as never_rented
	from customer 
	left Join
	(
		Select * from rental
		where extract(YEAR FROM rental_ts ) =2020  and 
				  extract(MONTH FROM rental_ts) = 5  

	) AS filtered_rental
	on customer.customer_id = filtered_rental.customer_id 
 )

select 'rented' as has_rented,  rented as count
from cte 
UNION ALL 
select 'never-rented', never_rented
from cte 

