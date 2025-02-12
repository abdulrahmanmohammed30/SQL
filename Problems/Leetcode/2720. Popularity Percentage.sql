with all_friends  
as (
	select user1, user2
	from friends
	union 
	select user2 as user1, user1 as user2 
	from friends 
), totalFriends
as (
	select count(distinct user1) as users_count  
	from all_friends
)

select user1, Round((((friends_count * 1.00) / users_count)) * 100, 2) as percentage_popularity 
from 
(
	select user1, count(distinct user2) as friends_count  
	from all_friends
	group by user1 
)x, totalFriends
order by user1 
