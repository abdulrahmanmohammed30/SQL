/* Write your T-SQL query statement below */

with OldProducts as 
(
   select product_id, 
          10 as new_price,
          dateadd(Day, -5,  (select min(change_date) from products)) as change_date 
    from products
    group by product_id
)

select product_id, new_price as price
from 
(
    select product_id,
           new_price, 
           row_number() over (partition by product_id order by change_date desc) as rank
     from (select * from products
            union all 
            select * from OldProducts
           )x
        where change_date <= '2019-08-16'
)x
where rank = 1
