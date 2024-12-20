with cte
as 
(
	select tweet_date,
		  substring(tweet, CHARINDEX('#', tweet), len(tweet)) as tweet
   from tweets
	where year(tweet_date) = 2024
		  and month(tweet_date) = 2
		  and CHARINDEX('#', tweet) > 0 
),hashtags as (
	select 
	case 
		when (charindex(' ',trim(value)) <> 0) then  substring(trim(value),1,charindex(' ',trim(value)) - 1)
		else trim(value)
	end as hashtag   
	from cte
	cross apply string_split(tweet, '#')
)

select top 3 concat('#', hashtag), count(1) as count
from hashtags 
where len(trim(hashtag)) > 0
group by concat('#', hashtag)
order by count(1) desc 