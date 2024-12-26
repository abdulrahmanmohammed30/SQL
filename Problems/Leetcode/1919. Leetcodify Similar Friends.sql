with distinct_listens 
as 
(
	select distinct user_id,
	               song_id,
				   day 
	from Listens
), listens_with_friends
as 
(
	select l.user_id,l.song_id, 
	       l.day,
		   f.user2_id as friend_id
	from distinct_Listens l
	join Friendship f on l.user_id = f.user1_id 
)
select lwf.user_id as user1_id, 
       f.user_id as user2_id
from listens_with_friends lwf
join distinct_listens f on lwf.friend_id = f.user_id 
                           and lwf.day = f.day
						   and lwf.song_id = f.song_id
group by lwf.user_id, f.user_id
having(count(1) >= 3)