select fb1.date, count (fb2.action) / cast (count(1)  as decimal(10,2))
from fb_friend_requests fb1
    left join fb_friend_requests fb2
    on 
fb1.action = 'sent' and fb2.action = 'accepted'
        and fb1.user_id_sender = fb2.user_id_sender
        and fb1.user_id_receiver=fb2.user_id_receiver
where fb1.action = 'sent'
group by fb1.date

