
    -- select user_id, count(case when session_type='Streamer' then 1 else null end) as sessions_count 
    -- from sessions 
    -- group by user_id
    -- having  min(case when session_type='Viewer' then session_start else null end) is not null 
    --         and min(case when session_type='Streamer' then session_start else null end) is not null 
	-- 	    and min(case when session_type='Viewer' then session_start else null end) 
	-- 	       < min(case when session_type='Streamer' then session_start else null end)
    -- order by count(case when session_type='Streamer' then 1 else null end) desc, user_id desc


with cte as 
(
   select user_id,
          min(case when session_type='Viewer' then session_start else null end) as min_viewer_startdate, 
		  min(case when session_type='Streamer' then session_start else null end) as min_streamer_startdate,
		  count(case when session_type='Streamer' then 1 else null end) as number_streams
   from sessions
   group by user_Id
)
    select user_id,number_streams  as sessions_count 
    from cte 
	where min_viewer_startdate is not null 
          and min_streamer_startdate is not null
		   and min_viewer_startdate < min_streamer_startdate
    order by number_streams desc, user_id desc


