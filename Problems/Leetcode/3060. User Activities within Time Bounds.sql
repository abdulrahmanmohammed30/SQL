select distinct s1.user_id
from sessions s1
join sessions s2 on s1.session_id != s2.session_id and
                    s1.user_id = s2.user_id and 
                    s1.session_type = s2.session_type and 
					s1.session_end <= s2.session_start and
					datediff(hour, s1.session_end, s2.session_start) < 12
order by s1.user_id