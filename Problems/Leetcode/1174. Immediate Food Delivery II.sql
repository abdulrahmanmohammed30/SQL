/* Write your T-SQL query statement below */

select round((cast(count(iif(OrderStatus='immediate',1,null))  as float) / cast((select count(distinct customer_id) from Delivery) as float)) * 100, 2) as immediate_percentage 
from 
(
  select distinct customer_id, (
        select top 1 iif(order_date = customer_pref_delivery_date, 'immediate', 'scheduled' )
        from Delivery d2
        where d1.customer_id = d2.customer_id 
        order by d2.order_date
    )as OrderStatus
  from Delivery d1
)x


optimized solution 
/* Write your T-SQL query statement below */

with CustomerFirstOrder as 
(
    select customer_id, min(order_date) as order_date
    from Delivery 
    group by customer_id 
)
 
select round(avg(iif(d.order_date=d.customer_pref_delivery_date,1.0,0.0)) * 100,2) as immediate_percentage 
from Delivery d 
join CustomerFirstOrder  cfo
on d.customer_id = cfo.customer_id and d.order_date=cfo.order_date

