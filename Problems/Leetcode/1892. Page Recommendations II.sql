

with users_Friendship
as 
(
	select user1_id, user2_id 
	from Friendship 
	union  
	select user2_id, user1_id 
	from Friendship
), user_recommendations 
as 
(
   select user_id, page_id, count(1) as friends_likes 
   from (
		   select user1_id as user_id, page_id 
		   from users_Friendship uf 
		   join Likes l on uf.user2_id = l.user_id 
	  )x
    group by user_id, page_id
), user_liked_pages as 
(
    select u.user_id, l.page_id 
	from 
	(select distinct user1_id  as user_id
	from users_Friendship) as u 
	join Likes l on u.user_id = l.user_id
)


select user_id, page_id, friends_likes from user_recommendations ur 
where not exists(select 1 from user_liked_pages ul where ur.user_id = ul.user_id and ur.page_id = ul.page_id)
