with post_topics as 
(
	select p.post_id, k.topic_id as topic
	from posts p
	cross apply string_split(content, ' ')
	join keywords k on lower(trim(value)) = lower(k.word) 
	group by post_id, k.topic_id
)

select p.post_id, iif(string_agg(topic, ',') is null, 'Ambiguous!',string_agg(topic, ',') within group (order by topic)) as topic
from post_topics
right join posts p on post_topics.post_id = p.post_id 
group by p.post_id
order by p.post_id
