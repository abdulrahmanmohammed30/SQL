/* Write your T-SQL query statement below */

select stock_name,
      sum(iif(operation='Sell',price,0)) -sum(iif(operation='Buy',price,0)) as capital_gain_loss 
from stocks
group by stock_name 

---

-- select stock_name,
--       sum(iif(operation='Sell',price,-price)) as capital_gain_loss 
-- from stocks
-- group by stock_name 