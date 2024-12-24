
with user_second_sold_item
as 
(
	select * from (
		select seller_id as user_id,
			  item_id, 
		row_number() over (partition by seller_id order by order_date) as order_number
		from orders 
	)x
	where order_number = 2
)

select u.user_id as 'seller_id', iif(u.favorite_brand = i.item_brand, 'yes', 'no') as '2nd_item_fav_brand'
from user_second_sold_item ussi 
join Items i on ussi.item_id = i.item_id  
right join Users u on ussi.user_id = u.user_id 

