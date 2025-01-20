--INSERT INTO Buses (bus_id, arrival_time, capacity) VALUES
--INSERT INTO Passengers (passenger_id, arrival_time) VALUES

with cte as (
	select row_number() over (order by b.arrival_time asc) as rn,
	       b.bus_id,
		   b.capacity,
		   count(1) as total_passengers
	from buses b 
	join passengers p on b.arrival_time >= p.arrival_time 
	group by b.bus_id, b.arrival_time, b.capacity, b.arrival_time
), recursive_cte as (
	select rn, 
	       bus_id,
		   iif(capacity < total_passengers, capacity, total_passengers) as onboarded_passengers,
		   iif(capacity < total_passengers, capacity, total_passengers) as total_onboarded_passengers
	from cte 
	where rn = 1
	union all 
	select cte.rn,
	      cte.bus_id, 
	      iif(capacity < total_passengers, capacity, total_passengers - recursive_cte.total_onboarded_passengers ) as onboarded_passengers,
		  iif(capacity < total_passengers, capacity, total_passengers - recursive_cte.total_onboarded_passengers ) + total_onboarded_passengers as total_onboarded_passengers
	from cte 
	join recursive_cte on cte.rn = recursive_cte.rn + 1 
)

select recursive_cte.bus_id, onboarded_passengers as passengers_cnt 
from recursive_cte