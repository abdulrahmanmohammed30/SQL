select users.user_id as buyer_id, users.join_date, coalesce(count(order_id), 0) as orders_in_2019
from users
left join orders orders on users.user_id=orders.buyer_id and year(Orders.order_date) = 2019
group by users.user_id, users.join_date
