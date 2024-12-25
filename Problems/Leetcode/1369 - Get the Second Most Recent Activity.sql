select * 
from (
	select distinct *, 
	dense_rank() over(partition by username order by startDate desc) as rk,
	count(startDate) over(partition by username) as ct
	from 
	(
		select distinct username, activity, startDate, endDate
		from UserActivity
	)d
)x
where rk = 2 or ct=1