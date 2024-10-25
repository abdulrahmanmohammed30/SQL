/* Write your T-SQL query statement below */


select product_id,
       first_year,
       quantity,
       price
from 
(
    select *, 
        min(year) over(partition by product_id) as first_year
    from sales
)x
where year = first_year